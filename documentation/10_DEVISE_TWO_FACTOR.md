# Double authentification (devise-two-factor)

Documentation du parcours TOTP + codes de secours sur maximeoudin.fr.
Dernière mise à jour : 2026-08-24.

## Objectif

Protéger le compte admin (session web Devise) avec :

1. **TOTP** via une app Authenticator (Google Authenticator, 1Password, etc.)
2. **Codes de secours** à usage unique (`:two_factor_backupable`)

L’API JWT reste sans OTP, mais les écritures articles ont été retirées (`index` / `show` seuls) pour qu’un token obtenu sans 2FA ne puisse pas modifier le contenu.

## Prérequis

- Rails + Devise déjà en place
- Clés **Active Record Encryption** (le gem chiffre `otp_secret`)
- PostgreSQL (colonne `otp_backup_codes` en tableau)

### Générer et stocker les clés de chiffrement

Ne jamais committer ces valeurs ni les coller dans un chat.

```bash
bin/rails db:encryption:init
```

Ajouter dans `.env` (développement) :

```bash
ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY=...
ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY=...
ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT=...
```

En production (Kamal), mêmes noms sous `env.secret` dans `config/deploy.yml` :

```bash
kamal secrets set ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY=...
kamal secrets set ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY=...
kamal secrets set ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT=...
```

Utiliser des jeux de clés **différents** entre développement et production.

Vérification :

```bash
bin/rails runner 'puts ActiveRecord::Encryption.config.primary_key.present?'
# => true
```

Les tests utilisent des clés dédiées dans `config/environments/test.rb` (pas besoin de `.env` pour `rspec`).

## Gems

```ruby
# Gemfile
gem "devise-two-factor"
gem "rqrcode" # QR code d'enrollment
```

```bash
bundle install
bin/rails db:migrate
```

## Modèle User

Important : **ne pas** charger `:database_authenticatable` en même temps que `:two_factor_authenticatable` (bypass Warden du 2FA).

```ruby
devise :two_factor_authenticatable, :two_factor_backupable,
       :recoverable, :rememberable, :validatable,
       :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist
```

Colonnes :

| Colonne | Rôle |
|---|---|
| `otp_secret` | Secret TOTP (chiffré) |
| `consumed_timestep` | Anti-rejeu des codes |
| `otp_required_for_login` | Active le 2FA pour ce compte |
| `otp_backup_codes` | Hashes bcrypt des codes de secours (`string[]`) |

## Configuration Devise

Dans `config/initializers/devise.rb` (un seul bloc `config.warden`) :

- `manager.failure_app = CustomDeviseFailureApp`
- Stratégies Warden en tête : `:two_factor_authenticatable` puis `:two_factor_backupable` (`unshift`)
- `config.sign_in_after_reset_password = false` (sinon le reset contourne l’OTP)

**Important** : sans `otp_required_for_login == true`, la stratégie 2FA **accepte** le login sans vérifier l’OTP. L’activation doit donc persister ce flag (et les codes de secours) de façon fiable.

### Rememberable et POST login

`config/initializers/devise_rememberable_2fa.rb` désactive la stratégie `:rememberable` lorsqu’un mot de passe est présent dans le POST de connexion. Sinon un cookie « se souvenir de moi » peut authentifier à la place d’un OTP invalide / manquant (cascade Warden laissée ouverte pour les backup codes).

Dans `ApplicationController` :

```ruby
devise_parameter_sanitizer.permit(:sign_in, keys: [:otp_attempt])
```

Les logs filtrent déjà `:otp` → `otp_attempt` est masqué.

## Parcours utilisateur

### Connexion

Formulaire `POST /users/sign_in` avec `email`, `password`, `otp_attempt` (**obligatoire** si `otp_required_for_login`).

Un code de secours peut remplacer le TOTP dans `otp_attempt`.

Vérifications attendues une fois le 2FA activé :

- sans OTP → refus
- OTP incorrect → refus
- TOTP ou code de secours valide → OK

### Activation (`/compte/2fa`)

1. Se connecter **sans** 2FA (ou après login normal)
2. Navbar → lien **2FA** → `/compte/2fa`
3. **Configurer le 2FA** → génère `otp_secret` **sans** activer encore `otp_required_for_login` (refusé si déjà activé)
4. Scanner le QR (issuer = `DOMAIN` / `maximeoudin.fr`)
5. Entrer un premier code TOTP → `TwoFactorConfirmService` active le 2FA, génère les codes de secours, puis **recharge** l’user et vérifie la persistance (`otp_required` + codes) sinon erreur `:persist_failed`
6. Page `/compte/2fa/backup_codes` : codes affichés **une seule fois** (session flash) — à stocker hors ligne

Une fois activé, on ne peut plus relancer « Configurer le 2FA » sans désactiver d’abord.

### Désactivation

Sur `/compte/2fa` : mot de passe + OTP (ou code de secours).

## Fichiers clés

| Fichier | Rôle |
|---|---|
| `app/models/user.rb` | Modules Devise 2FA |
| `app/controllers/two_factor_settings_controller.rb` | UI activation / désactivation |
| `app/services/two_factor_*_service.rb` | Setup, confirm, disable |
| `app/helpers/application_helper.rb` | `#otp_qr_svg` (SVG sans déclaration XML, fond blanc) |
| `app/views/devise/sessions/new.html.erb` | Champ OTP login |
| `app/views/two_factor_settings/*` | Écrans 2FA |
| `config/initializers/devise.rb` | Warden 2FA + failure_app |
| `config/initializers/devise_rememberable_2fa.rb` | Pas de bypass OTP via remember me |
| `config/routes.rb` | `resource :two_factor_settings` + API lecture seule |
| `config/application.rb` | Chargement des clés encryption depuis ENV |
| `config/deploy.yml` | Secrets Kamal encryption |

## API

```ruby
resources :articles, only: %i[index show]
```

`POST /api/v1/login` (JWT) n’exige pas d’OTP : volontaire tant que l’API ne mute plus de contenu. Les CRUD web passent par la session Devise + 2FA.

## Tests

```bash
bundle exec rspec spec/models/user_spec.rb \
  spec/services/two_factor_*_spec.rb \
  spec/requests/sessions_two_factor_spec.rb \
  spec/requests/two_factor_settings_spec.rb \
  spec/requests/api_v1_articles_read_only_spec.rb
```

Le modèle inclut les shared examples du gem :

```ruby
require "devise_two_factor/spec_helpers"
it_behaves_like "two_factor_authenticatable"
it_behaves_like "two_factor_backupable"
```

Factory : trait `:with_two_factor`.

## Checklist déploiement

1. Générer de **nouvelles** clés encryption (prod) et les mettre dans Kamal secrets
2. `bundle install` + image Docker rebuild / `kamal deploy`
3. Migrer en prod (Kamal ne le fait pas tout seul) :
   ```bash
   kamal app exec --reuse 'bin/rails db:migrate'
   ```
4. Se connecter une fois, activer le 2FA **une seule fois**, sauvegarder les codes de secours
5. Vérifier en base : `otp_required_for_login == true` et `otp_backup_codes` non vides
6. Vérifier login : sans OTP → refus ; OTP bidon → refus ; TOTP valide → OK ; code de secours → OK
7. Vérifier qu’un reset password ne reconnecte pas automatiquement
8. Vérifier qu’on ne peut pas réactiver le 2FA sans le désactiver d’abord

## Références

- [devise-two-factor](https://github.com/devise-two-factor/devise-two-factor)
- [Active Record Encryption](https://guides.rubyonrails.org/active_record_encryption.html)
