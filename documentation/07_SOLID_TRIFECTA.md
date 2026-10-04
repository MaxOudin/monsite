# Résumé : Solid Trifecta (Queue, Cache, Cable) en dev et prod

Ce document résume les travaux réalisés pour intégrer le **Solid Trifecta** (Solid Queue, Solid Cache, Solid Cable) au projet, en **développement** et en **production**.

---

## ⚠️ En cas de perte de données en production

Si après des commandes `db:schema:load:queue`, `db:schema:load:cable` ou `db:schema:load:cache` la base de prod est vide (plus d’articles, projets, etc.) :

1. **Restaurer un backup** : restaurer un dump PostgreSQL de l’accessoire Kamal `db` pris **avant** ces commandes.
2. Ne plus jamais lancer ces trois commandes en production lorsque primary, queue, cable et cache utilisent la **même** base (voir §3 ci‑dessous).

---

## 1. Objectif

- **Solid Queue** : jobs asynchrones et tâches récurrentes (ex. sitemap quotidien), sans Redis.
- **Solid Cache** : cache durable en base, sans Redis.
- **Solid Cable** : Action Cable sans Redis (WebSockets).

Tout repose sur **PostgreSQL** (une ou plusieurs bases).

---

## 2. Gems ajoutées

Dans le `Gemfile` :

```ruby
gem 'solid_queue'
gem 'solid_cache'
gem 'solid_cable'
```

Puis :

```bash
bundle install
bin/rails solid_queue:install   # crée config/queue.yml, config/recurring.yml, db/queue_schema.rb, bin/jobs
bin/rails solid_cable:install   # crée db/cable_schema.rb, met à jour config/cable.yml
bin/rails solid_cache:install    # crée config/cache.yml, db/cache_schema.rb, met à jour production.rb
```

---

## 3. Configuration des bases (`config/database.yml`)

### Développement et test

Une **seule base** par environnement ; les 4 rôles (primary, queue, cable, cache) pointent vers elle :

- **development** : `primary`, `queue`, `cable`, `cache` → `cd_development`
- **test** : `primary`, `queue`, `cable`, `cache` → `cd_test`

### Production (Kamal)

Une **seule base** également. Kamal fournit `DATABASE_URL` (accessoire Postgres `db`).

- **production** : `primary`, `queue`, `cable`, `cache` → `url: ENV["SCALINGO_POSTGRESQL_URL"] || ENV["DATABASE_URL"]`

`SCALINGO_POSTGRESQL_URL` est un repli historique. En déploiement Kamal, seule `DATABASE_URL` est définie.

Aucune création de bases supplémentaires en prod (pas de `cd_production_queue`, etc.).

### Chargement des schémas (tables Solid Queue / Cable / Cache)

- **En dev/test** : après `rails db:create`, exécuter une fois :
  ```bash
  bin/rails db:schema:load:queue
  bin/rails db:schema:load:cable
  bin/rails db:schema:load:cache
  ```
  En dev/test les connexions queue/cable/cache pointent vers la **même** base ; ces commandes ajoutent les tables Solid dans cette base. Vérifier que `db/queue_schema.rb` ne contient **que** les tables Solid Queue (pas tout le schéma app), sinon ne pas lancer `schema:load:queue` sur une base qui contient déjà des données.

- **En prod (une seule base) – attention**  
  **Ne jamais exécuter** `db:schema:load:queue`, `db:schema:load:cable` ou `db:schema:load:cache` lorsque primary, queue, cable et cache pointent vers la **même** base : Rails peut purger cette base et recréer les tables, ce qui **efface toutes les données** (articles, projets, etc.).  
  Les tables Solid doivent être créées autrement : migrations dédiées (avec `if_not_exists: true`) ou en s’assurant qu’elles existent déjà (ex. déploiement initial avec `db:prepare` sur une base vide). En cas de doute, ne pas lancer ces commandes en prod.

---

## 4. Environnements

### `config/environments/development.rb` et `test.rb`

- `config.active_job.queue_adapter = :solid_queue`
- `config.solid_queue.connects_to = { database: { writing: :queue } }`  
  (pour que Solid Queue utilise la connexion `queue`, qui pointe vers la même base en dev/test.)

### `config/environments/production.rb`

- `config.cache_store = :solid_cache_store`
- `config.active_job.queue_adapter = :solid_queue`
- Pas de `connects_to` spécifique si une seule base (toutes les connexions utilisent la même URL).

### `config/cable.yml`

- **development** : `adapter: async`
- **test** : `adapter: test`
- **production** : `adapter: solid_cable` (avec options éventuelles : `polling_interval`, `message_retention`).

### `config/cache.yml`

- **production** : `database: cache` (connexion nommée `cache` dans `database.yml`, ici la même base que primary en prod).

---

## 5. Processus jobs

- **Local** : `bin/dev` lit `Procfile.dev`, qui lance `jobs: bin/rails solid_queue:start` à côté du serveur, de CSS et de JS.
- **Production** : Kamal ne déclare qu’un rôle `web` (`config/deploy.yml`). Le `CMD` de l’image est `rails server`. `config/puma.rb` n’embarque Solid Queue que si `SOLID_QUEUE_IN_PUMA` est défini, et cette variable n’est pas posée.

Les jobs et les tâches récurrentes tournent donc en local avec `bin/dev`. Ils ne tournent pas sur le conteneur web Kamal.

---

## 6. Tâches récurrentes (`config/recurring.yml`)

Exemples en production :

- **generate_sitemap** : `GenerateSitemapJob`, tous les jours à 23h.
- **clear_solid_queue_finished_jobs** : nettoyage des jobs terminés, toutes les heures.

Fichier des jobs : `app/jobs/generate_sitemap_job.rb` (appel à la tâche Rake `sitemap:refresh:no_ping`).

---

## 7. Vérifications

- **Adapter en prod** (console Kamal, `kamal app exec` ou `bin/rails console` en production) :
  ```ruby
  ActiveJob::Base.queue_adapter
  # => #<ActiveJob::QueueAdapters::SolidQueueAdapter ...>
  ```

- **Tâches récurrentes** :
  ```ruby
  SolidQueue::RecurringTask.pluck(:key, :schedule)
  ```

- **Dernière exécution du sitemap** :
  ```ruby
  SolidQueue::Job.where(class_name: "GenerateSitemapJob").order(finished_at: :desc).pick(:finished_at)
  ```

- **Logs** : en local, le processus `jobs` de `bin/dev`. En production, aucun processus ne consomme la file tant qu’un rôle job ou `SOLID_QUEUE_IN_PUMA` n’est pas ajouté.

---

## 8. Récap des fichiers modifiés / créés

| Fichier | Rôle |
|--------|------|
| `Gemfile` | Gems `solid_queue`, `solid_cache`, `solid_cable` |
| `config/database.yml` | Connexions primary, queue, cable, cache (une base en dev/test/prod) |
| `config/queue.yml` | Config Solid Queue (workers, dispatchers) |
| `config/recurring.yml` | Tâches récurrentes (sitemap, nettoyage) |
| `config/cache.yml` | Config Solid Cache (production : database cache) |
| `config/cable.yml` | Adapters async / test / solid_cable |
| `config/environments/production.rb` | cache_store, active_job.queue_adapter |
| `config/environments/development.rb`, `test.rb` | queue_adapter, solid_queue.connects_to |
| `db/queue_schema.rb`, `db/cable_schema.rb`, `db/cache_schema.rb` | Schémas des tables Solid Queue / Cable / Cache |
| `bin/jobs` | CLI Solid Queue (supervisor + workers) |
| `Procfile.dev` | web, css, js, jobs — lu par `bin/dev` |
| `config/deploy.yml` | Rôle Kamal `web` uniquement |
| `config/puma.rb` | Plugin Solid Queue si `SOLID_QUEUE_IN_PUMA` |
| `app/jobs/generate_sitemap_job.rb` | Job récurrent sitemap |
| `app/jobs/heartbeat_check_job.rb` | Job de test (optionnel) |
| `config/sitemap.rb` | Désactivation du ping Google (déprécié) |

---

## 9. Production (Kamal) – Points importants

1. **Variables d’environnement** : `DATABASE_URL` est un secret Kamal. Postgres tourne comme accessoire `db` (`config/deploy.yml`).
2. **Une seule base** : pas de création de bases `cd_production_queue`, etc. ; une seule URL pour primary, queue, cable, cache.
3. **Jobs** : pas de rôle worker dans `config/deploy.yml`, et `SOLID_QUEUE_IN_PUMA` n’est pas défini. Le sitemap récurrent et le nettoyage Solid Queue ne s’exécutent pas en production dans cet état.
4. **Schémas queue/cable/cache** : ne pas lancer `db:schema:load:*` sur la base de production partagée (voir §3).

Ce résumé couvre l’essentiel des travaux pour avoir le Solid Trifecta opérationnel en dev et en prod.
