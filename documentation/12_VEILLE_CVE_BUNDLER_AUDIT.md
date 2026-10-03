# Veille CVE — bundler-audit

Surveillance des vulnérabilités des gems Ruby via le `Gemfile.lock`.

## À propos de l'outil

`bundler-audit` compare les versions verrouillées dans `Gemfile.lock` à la base [ruby-advisory-db](https://github.com/rubysec/ruby-advisory-db).

Limites :
- **lockfile seulement** — ne détecte pas l'usage réel du code vulnérable ;
- **pas le JavaScript** (Bun / npm) — autre outil requis ;
- une alerte « High » n'implique pas forcément une exposition dans cette app.

Commandes :

```bash
bin/bundler-audit                          # wrapper (met à jour la DB + check)
bundle exec bundler-audit check --update   # sans ignores du wrapper
```

## Ce qui est en place

| Élément | Statut |
|---------|--------|
| Gem `bundler-audit` (dev/test) | ✅ |
| Wrapper `bin/bundler-audit` | ✅ |
| Documentation (ce fichier) | ✅ |
| Ignores justifiés / datés | ❌ (aucun pour l'instant) |
| Job CI GitHub Actions (schedule) | ❌ |
| Étape `bin/ci` locale | ✅ |

## État initial (2026-10-03)

Audit après ajout de la gem, **avant** corrections.

| Criticité | Alertes |
|-----------|--------:|
| Critical | 0 |
| High | 22 |
| Medium | 39 |
| Low | 11 |
| Unknown | 95 |
| **Total** | **167** |
| Gems concernées | 25 |

Classification rapide (à traiter via le skill `rails-cve-remediation`) :

| Groupe | Sens | Exemples |
|--------|------|----------|
| **A** | Correctif patch / mineure dans la série | nokogiri 1.19.x, rack 3.2.x, net-imap 0.6.x, Rails 8.1.2.x, concurrent-ruby, jwt, view_component… |
| **B** | Montée majeure | puma 6 → 7, devise 4 → 5 |
| **dev/test** | Impact plus faible | addressable (capybara/launchy), rubyzip 2 → 3 (selenium) |

## État après corrections

*À remplir après le chantier CVE.*

| Criticité | Avant | Après |
|-----------|------:|------:|
| Critical | 0 | — |
| High | 22 | — |
| Medium | 39 | — |
| Low | 11 | — |
| Unknown | 95 | — |
| **Total** | **167** | — |

Alertes restantes / blocages : —

## Plan de mise en place

1. ✅ Ajouter la gem + wrapper + doc (branche `feat/bundler-audit`)
2. ⬜ Corriger Critical/High (groupe A puis B) — skill `rails-cve-remediation`
3. ⬜ Traiter Medium/Low/Unknown restants ou ignores datés
4. ⬜ Ajouter le workflow GitHub `.github/workflows/security.yml` — skill `rails-security-ci`

## Procédure en cas d'alerte

1. Lancer `bin/bundler-audit` (ou lire la CI).
2. Classer : correctif patch ? majeure ? bloqué ? exposition réelle dans l'app ?
3. Corriger (update borné) **ou** ignorer dans `bin/bundler-audit` avec justification + date de revue.
4. Mettre à jour ce document (tableau après corrections).
5. Ne jamais ignorer une CVE sans vérifier l'exposition dans **ce** codebase.
