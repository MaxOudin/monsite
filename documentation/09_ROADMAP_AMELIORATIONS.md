# 09 — Roadmap d'améliorations (modèles & schéma DB)

> **Date de rédaction : 2026-07-05**
> Auteur : Maxime Oudin
> Objectif : recenser les améliorations identifiées sur les modèles et le schéma
> de base de données, décider ce qu'on intègre ou non, et découper le travail en
> branches Git claires, réalisables **à la suite** (chaque branche est mergée
> avant d'ouvrir la suivante, car certaines dépendent des précédentes).
>
> **Tests : RSpec uniquement.** Le dossier `test/` (Minitest) est considéré comme
> obsolète — sa suppression est traitée dans la branche 1 (`test/rspec-baseline`).
>
> ⚠️ **État réel des tests (constaté le 2026-07-05)** : l'infrastructure RSpec est
> installée et fonctionne (`rspec-rails`, `factory_bot`, `capybara`,
> `database_cleaner`, `shoulda-matchers` ; `rails_helper`/`spec_helper`/`support`
> OK ; la suite démarre). **Mais la couverture est quasi inexistante** : la
> plupart des specs modèles sont des stubs générés (`pending "add some
> examples…"`, blocs commentés). Seuls quelques fichiers ont du vrai contenu
> (`outil`, `projet`, `policies/article_policy`, `requests/csp_reports`,
> `system/projets`, `components/card_component`, `jobs/generate_sitemap`).
> **Conclusion : RSpec n'est pas encore un filet de sécurité.** Il faut écrire une
> couverture de base *avant* de toucher au schéma → branche 1
> (`test/rspec-baseline`), prérequis des refactos DB.

---

## Légende des décisions

| Statut | Signification |
|--------|---------------|
| ✅ À intégrer | Retenu, planifié dans une branche |
| 🕒 Plus tard | Utile mais non prioritaire, backlog |
| ❌ Écarté | Décidé de ne pas faire (avec raison) |

---

## Récapitulatif des branches (ordre d'exécution)

| # | Branche | Décision | Dépend de |
|---|---------|----------|-----------|
| 1 | `test/rspec-baseline` (supprime Minitest + couverture de base) | ✔️ Terminé | — |
| 2 | `fix/outils-orphan-fk` | ✅ À intégrer | 1 |
| 3 | `fix/db-not-null-constraints` | ✅ À intégrer | 2 |
| 4 | `fix/db-unique-indexes` | ✅ À intégrer | 3 |
| 5 | `feat/article-publication-status` | ✅ À intégrer | 4 |
| 6 | `feat/models-position-ordering` | 🕒 Plus tard | 4 |
| 7 | `feat/activestorage-images` | 🕒 Plus tard | 4 |
| 8 | `feat/i18n-ui` (site bilingue fr/en — interface) | 🕒 Plus tard | 1 |
| 9 | `feat/i18n-content` (traduction du contenu en base) | 🕒 Plus tard | 3, 8 |
| 10 | Uniformisation i18n des colonnes | ❌ Écarté | — |

L'ordre n'est pas arbitraire : on **fiabilise le socle** (nettoyage tests +
couverture de base RSpec → cohérence des relations → contraintes d'intégrité →
index d'unicité) **avant** d'ajouter des fonctionnalités qui s'appuient dessus.
La couverture de base (branche 1) est volontairement placée en premier : c'est le
filet qui rend les migrations DDL (branches 2-4) sûres à réaliser.

---

## Branche 1 — `test/rspec-baseline`

**Décision : ✅ À intégrer** — prérequis des refactos DB (branches 2-4).
Regroupe deux chantiers liés : passer à RSpec-only (supprimer Minitest) **et**
écrire une vraie couverture de base.

**✔️ Statut : TERMINÉ (2026-07-05).** `bundle exec rspec` : 79 exemples, 0 échec,
0 `pending`. Constat initial : la suite était **cassée au chargement** (le DSL
`permissions` de Pundit n'était pas requis) — corrigé par `require 'pundit/rspec'`.

### Contexte
Le projet contient à la fois `spec/` (RSpec) et `test/` (Minitest : quelques
`*_test.rb` sur modèles/contrôleurs + fixtures YAML) → deux frameworks en
parallèle = confusion et double maintenance. Par ailleurs, l'infra RSpec
fonctionne mais la couverture réelle est quasi nulle (stubs `pending`, blocs
commentés). Avant de modifier le schéma, il faut un socle de tests qui décrit le
comportement **actuel** des modèles, pour détecter toute régression introduite
par les migrations.

### Actions
**Partie A — RSpec-only**
- [x] Vérifier qu'aucune couverture unique n'existe dans `test/` → **tous stubs
      vides** (`# test "the truth"`), zéro couverture unique.
- [x] Supprimer le dossier `test/` et ses fixtures YAML (via `git rm`).
- [x] Retirer toute référence Minitest résiduelle (aucune ref externe, pas de CI).

**Partie B — couverture de base**
- [x] Remplacer les stubs `pending`/commentés par de vraies specs sur les
      modèles : `Service`, `Sujet`, `Article`, `User`, `Projet`, `Outil`.
- [x] Couvrir validations (`presence`, unicité, `inclusion` `type_projet`/`theme`),
      associations N-N, helpers (`couleur_du_theme`, `count_by_theme`), slugs.
- [x] Utiliser `shoulda-matchers` (présence, associations).
- [x] Créer/compléter les factories : `articles`, `users` (créées) ;
      `services`, `sujets` (remplies) ; `outils` corrigée (assoc N-N).
- [x] Retirer tous les `pending`.

### Specs (RSpec)
- [x] Cible atteinte : `bundle exec rspec` **vert, 0 pending** (79 exemples).

### Travail additionnel constaté (hors périmètre initial mais requis pour le vert)
- `require 'pundit/rspec'` ajouté (suite cassée au chargement).
- Config `ViewComponent::TestHelpers` manquante dans `rails_helper` (cassait
  aussi la spec `card_component` existante) → ajoutée.
- Specs système `projets` réalignées sur le contenu réel des vues (obsolètes).
- 🐞 **Bug applicatif corrigé** : `card_component.rb` utilisait
  `image_path("assets/images/yellow_logo.svg")` (chemin faux → `MissingAssetError`
  en prod sur le logo par défaut). Corrigé en `image_path("yellow_logo.svg")`.

### Risque
Faible (le seul code applicatif touché est le fix 1 ligne du logo par défaut).

---

## Branche 2 — `fix/outils-orphan-fk`

**Décision : ✅ À intégrer** — lever l'ambiguïté de modélisation.

### Contexte
La table `outils` porte une FK `projet_id` (relation 1-N Projet→Outil) **en plus**
de la relation N-N via `outils_projets` (seule déclarée dans le modèle `Outil`).
Cette colonne `projet_id` est un vestige : non utilisée par le modèle, source de
confusion.

### Actions
- [ ] Confirmer qu'aucune donnée utile ne dépend de `outils.projet_id`
      (vérifier en base : y a-t-il des valeurs non nulles ?).
- [ ] Migration : `remove_reference :outils, :projet, foreign_key: true`.
- [ ] Nettoyer l'annotation de schéma en tête de `app/models/outil.rb`.

### Specs (RSpec)
- [ ] `spec/models/outil_spec.rb` : la relation N-N `projets`/`outils` reste
      fonctionnelle (via `outils_projets`).
- [ ] Factory `spec/factories/outils.rb` : retirer toute réf à `projet` direct.

### Risque
Faible à moyen (migration destructive de colonne). Sauvegarder au préalable.
**Commande destructive → demander confirmation avant `db:migrate` en prod.**

---

## Branche 3 — `fix/db-not-null-constraints`

**Décision : ✅ À intégrer** — l'intégrité ne doit pas reposer que sur Ruby.

### Contexte
Les validations `presence: true` sont applicatives uniquement. La base accepte
aujourd'hui des `nom`/`titre`/`description` NULL (contournement via SQL direct,
seeds, imports).

### Actions
- [ ] Auditer les colonnes concernées : `services.nom/description`,
      `sujets.nom/description/numero`, `projets.titre/type_projet/description`,
      `articles.titre/theme`, `outils.nom/description`.
- [ ] Migration : `change_column_null` → `false` sur ces colonnes.
      (Nettoyer d'éventuelles lignes NULL existantes **avant** d'appliquer.)

### Specs (RSpec)
- [ ] Vérifier que les factories produisent toujours des objets valides.
- [ ] Les specs de validation existantes restent vertes.

### Risque
Moyen. Si des NULL existent en prod, la migration échoue → prévoir un backfill.

---

## Branche 4 — `fix/db-unique-indexes`

**Décision : ✅ À intégrer** — l'unicité applicative ne protège pas de la concurrence.

### Contexte
`uniqueness: true` (Ruby) laisse passer les doublons en cas d'écritures
concurrentes. Manquent des index uniques DB sur : `services.nom`, `sujets.nom`,
`sujets.numero`, `projets.titre`, `articles.titre`, `outils.nom`,
`outils.description`.
(`slug` a déjà son index unique sur `articles` et `projets`.)

### Actions
- [ ] Vérifier l'absence de doublons existants avant chaque index.
- [ ] Migration : `add_index ..., unique: true` sur les colonnes ci-dessus.

### Specs (RSpec)
- [ ] Une spec par contrainte : insérer un doublon lève
      `ActiveRecord::RecordNotUnique` au niveau base.

### Risque
Moyen. Doublons existants = migration en échec → dédoublonner d'abord.

> 🔗 **Articulation avec la branche 9 (Mobility)** : `titre`/`nom` deviendront des
> colonnes `jsonb` traduites. Les index uniques scalaires posés ici devront alors
> être remplacés par des index uniques **par locale** (ex. sur l'expression
> `titre->>'fr'` et `titre->>'en'`). Les poser maintenant reste utile (protection
> immédiate), en sachant qu'ils seront reconstruits en branche 9.

---

## Branche 5 — `feat/article-publication-status`

**Décision : ✅ À intégrer** — actuellement tout article existant est public.

### Contexte
Aucun état de publication : impossible d'avoir un brouillon. Un `Article` créé
est immédiatement visible et présent dans le sitemap / la recherche.

### Actions
- [ ] Migration : ajouter `published_at :datetime` (nil = brouillon) — préférable
      à un booléen (permet la publication programmée future).
- [ ] Scope `Article.published` (`where.not(published_at: nil)`), utilisé dans
      les contrôleurs publics, la recherche PgSearch et le sitemap.
- [ ] Back-office : action publier / dépublier.

### Specs (RSpec)
- [ ] `spec/models/article_spec.rb` : scope `published`.
- [ ] `spec/requests/` : un brouillon renvoie 404 en public, visible en admin.
- [ ] `spec/jobs/generate_sitemap_job_spec.rb` : les brouillons sont exclus.

### Risque
Faible. Penser à backfill : `UPDATE articles SET published_at = created_at`
pour ne pas masquer les articles déjà en ligne.

---

## Branche 6 — `feat/models-position-ordering`

**Décision : 🕒 Plus tard** — confort d'édition, pas bloquant.

### Contexte
`Service`, `Sujet` et `Projet` s'affichent par `created_at` (ou `numero` pour
`Sujet`). Pas de réordonnancement libre sans recréer les enregistrements.

### Actions (quand priorisé)
- [ ] Colonne `position :integer` sur `services` et `projets`
      (`Sujet` a déjà `numero` — décider si on unifie ou pas).
- [ ] `default_scope { order(:position) }` ou scope explicite `ordered`.
- [ ] Back-office : réordonnancement (drag & drop Stimulus).

### Specs (RSpec)
- [ ] Ordre respecté par le scope.

### Risque
Faible.

---

## Branche 7 — `feat/activestorage-images`

**Décision : 🕒 Plus tard** — chantier plus lourd, à isoler.

### Contexte
Les images sont stockées en `image_url` (string = URL externe). ActiveStorage est
déjà installé (utilisé par ActionText sur `Article#content`) mais pas exploité
pour les visuels de `Projet`, `Article`, `Service`, `Sujet`, `Outil`.
Bénéfices : upload direct, variantes/redimensionnement, plus de liens morts.

### Actions (quand priorisé)
- [ ] `has_one_attached :image` sur les modèles concernés.
- [ ] Stratégie de migration des `image_url` existants (script d'import ou
      cohabitation temporaire des deux champs).
- [ ] Adapter les vues (`image_url` → `url_for(model.image)` / variantes).
- [ ] Vérifier le service de stockage (local vs cloud) selon l'hébergement Kamal.

### Specs (RSpec)
- [ ] Attachement présent/valide, génération de variante.

### Risque
Élevé (migration de données + changement de vues + config stockage prod).
À traiter seule, non couplée à d'autres branches.

---

## Branche 8 — `feat/i18n-ui` (site bilingue fr/en — interface)

**Décision : 🕒 Plus tard** — socle de la localisation, indépendant du contenu.

### Contexte
Le site est aujourd'hui monolingue (fr). Objectif : servir l'interface en fr **et**
en. Cette branche ne traite **que** les textes statiques (labels, navigation,
boutons, formulaires, pages légales `mentions_legales`/`cgv`, méta SEO génériques).
La traduction des données en base est traitée séparément (branche 9).

### Actions (quand priorisé)
- [ ] Activer `I18n.available_locales = [:fr, :en]`, `default_locale = :fr`.
- [ ] Externaliser toutes les chaînes en dur des vues/helpers vers
      `config/locales/fr.yml` et `en.yml`.
- [ ] Routage localisé : préfixe de locale (`scope "(:locale)"` ou `/en/…`),
      `around_action` pour `I18n.with_locale`, détection via URL (prioritaire pour
      le SEO) puis `Accept-Language` en repli.
- [ ] Sélecteur de langue dans le layout (composant ViewComponent + Stimulus).
- [ ] SEO : balises `hreflang` fr/en (cf. `03_SEO_METADATA.md`,
      `04_SEO_STRUCTURED_DATA.md` à adapter).

### Specs (RSpec)
- [ ] `spec/requests` : `/en/…` rend l'interface en anglais, `/` reste fr.
- [ ] Repli sur `default_locale` pour une locale inconnue.
- [ ] Présence des balises `hreflang`.

### Risque
Moyen. Chantier large (balayage de toutes les vues) mais sans risque données.

---

## Branche 9 — `feat/i18n-content` (traduction du contenu en base)

**Décision : 🕒 Plus tard** — le vrai gros morceau ; touche le schéma.

### Contexte
Les modèles portent le contenu affiché (`Article.titre/theme` + `content`
ActionText ; `Projet.titre/description` ; `Service`/`Sujet`/`Outil.nom/description`).
Les rendre bilingues suppose de stocker une version par locale.

### ✅ Décision actée — stratégie de stockage : **Mobility + backend JSONB**
Une colonne `jsonb` par attribut traduit (`{ "fr": "...", "en": "..." }`).
Retenu car : gem maintenue, attributs requêtables (compatible PgSearch), pas de
table de jointure, extensible à une 3e langue sans nouvelle migration structurelle.

Options écartées (pour mémoire) :
- Colonnes suffixées `titre_fr`/`titre_en` : trivial mais explosion du nombre de
  colonnes, non extensible.
- Table de traductions (`key_value`) : extensible mais jointures et requêtes plus lourdes.

### Points durs à prévoir
- **ActionText `Article#content`** : non géré nativement par Mobility. Prévoir
  soit un rich text par locale (`has_rich_text :content_fr, :content_en`), soit
  une gestion locale-scopée dédiée. À arbitrer.
- **Slugs FriendlyId** : `titre` génère le slug → prévoir des slugs par locale
  (`friendly_id` scopé sur la locale, historique conservé).
- **PgSearch** : les `pg_search_scope` doivent chercher dans la locale active.
- **Sitemap** (`GenerateSitemapJob`) : émettre les URLs par locale + `hreflang`.
- **Validations d'unicité** : l'unicité `titre`/`nom` (branche 4) devient
  *par locale* — réconcilier avec les index uniques posés.

### Actions (quand priorisé)
- [ ] Ajouter la gem `mobility` + configurer le backend `:jsonb`
      (`Mobility.configure` : `default_backend :jsonb`, locales `[:fr, :en]`).
- [ ] Migration : colonnes `jsonb` par attribut traduit + index GIN si recherche
      directe sur le JSONB + backfill des valeurs fr existantes vers `{ "fr": … }`.
- [ ] Déclarer les attributs traduits dans les modèles (`translates :titre, …`).
- [ ] Adapter vues, recherche PgSearch, slugs FriendlyId et sitemap à la locale.
- [ ] Back-office : édition par langue.

### Specs (RSpec)
- [ ] Lecture/écriture d'un attribut selon `I18n.locale`.
- [ ] Repli sur fr si la traduction en manque.
- [ ] Slug distinct par locale ; recherche PgSearch localisée.

### Risque
Élevé. Migration de données + refonte affichage/recherche/SEO. À traiter seule,
après stabilisation du schéma (branches 2-4) et de l'UI i18n (branche 8).

---

## Branche 10 — Uniformisation i18n des colonnes

**Décision : ❌ Écarté** (pour l'instant).

> À ne pas confondre avec les branches 8/9 : ici il s'agit du **nommage** des
> colonnes (fr/en mélangés dans le code), pas de la traduction du site.

### Raison
Mélange fr/en dans les noms de colonnes (`titre`, `couleur`, `nom` vs
`image_alt`, `created_at`). Renommer = migrations + refactor massif des vues,
contrôleurs, specs, factories, pour un gain purement cosmétique tant que le code
n'est pas ouvert/partagé. **Coût > bénéfice actuel.** À réévaluer si le repo
devient public ou collaboratif.

---

## Notes transverses

- **Migrations destructives / prod** : `db:migrate` touchant des suppressions de
  colonnes ou des contraintes doit être confirmé et précédé d'un backup
  (cf. instructions de sécurité opérationnelle).
- **Convention de commit** : une branche = un thème, mergée avant la suivante.
- **Definition of done par branche** : migration + specs RSpec **écrites** et
  vertes (pas de `pending`) couvrant le changement + annotations de schéma des
  modèles à jour.
- **Rappel tests** : tant que la branche 1 (`test/rspec-baseline`) n'est pas
  mergée, considérer qu'il n'y a pas de filet de sécurité — d'où l'ordre imposé.
