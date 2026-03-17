# Résumé : Solid Trifecta (Queue, Cache, Cable) en dev et prod

Ce document résume les travaux réalisés pour intégrer le **Solid Trifecta** (Solid Queue, Solid Cache, Solid Cable) au projet, en **développement** et en **production**.

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

### Production (ex. Scalingo)

Une **seule base** également : l’URL est fournie par le PaaS.

- **production** : `primary`, `queue`, `cable`, `cache` → `url: ENV["SCALINGO_POSTGRESQL_URL"] || ENV["DATABASE_URL"]`

Aucune création de bases supplémentaires en prod (pas de `cd_production_queue`, etc.).

### Chargement des schémas (tables Solid Queue / Cable / Cache)

- **En dev/test** : après `rails db:create`, exécuter une fois :
  ```bash
  bin/rails db:schema:load:queue
  bin/rails db:schema:load:cable
  bin/rails db:schema:load:cache
  ```
  Ou `bin/rails db:prepare` si les schémas sont gérés par la tâche standard.

- **En prod** (une seule fois, après déploiement) :
  ```bash
  scalingo-monsite -a maximeoudinpointfr run env DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bundle exec rails db:schema:load:queue
  scalingo-monsite -a maximeoudinpointfr run env DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bundle exec rails db:schema:load:cable
  scalingo-monsite -a maximeoudinpointfr run env DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bundle exec rails db:schema:load:cache
  ```

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

## 5. Procfile et worker

- **Procfile** :
  - `release: bundle exec rails db:migrate` (ou `db:prepare` selon stratégie).
  - `web: bundle exec puma -C config/puma.rb`
  - `worker: bundle exec bin/jobs`

- **Procfile.dev** (optionnel) : ajout de `worker: bundle exec bin/jobs` pour lancer le worker en local avec `bin/dev`.

Sans process **worker** en production, les jobs et tâches récurrentes ne s’exécutent pas.

---

## 6. Tâches récurrentes (`config/recurring.yml`)

Exemples en production :

- **generate_sitemap** : `GenerateSitemapJob`, tous les jours à 23h.
- **clear_solid_queue_finished_jobs** : nettoyage des jobs terminés, toutes les heures.

Fichier des jobs : `app/jobs/generate_sitemap_job.rb` (appel à la tâche Rake `sitemap:refresh:no_ping`).

---

## 7. Vérifications

- **Adapter en prod** (console Scalingo) :
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

- **Logs** : vérifier les logs du process **worker** sur Scalingo pour les exécutions des jobs.

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
| `Procfile` | release, web, worker |
| `Procfile.dev` | web, css, js, worker (optionnel) |
| `app/jobs/generate_sitemap_job.rb` | Job récurrent sitemap |
| `app/jobs/heartbeat_check_job.rb` | Job de test (optionnel) |
| `config/sitemap.rb` | Désactivation du ping Google (déprécié) |

---

## 9. Production (Scalingo) – Points importants

1. **Variables d’environnement** : `SCALINGO_POSTGRESQL_URL` (ou `DATABASE_URL`) fournie par l’addon Postgres ; pas besoin de `CD_DATABASE_PASSWORD` si tout passe par l’URL.
2. **Une seule base** : pas de création de bases `cd_production_queue`, etc. ; une seule URL pour primary, queue, cable, cache.
3. **Worker** : scale à 1 dans le dashboard Scalingo (onglet Scaling) pour que les jobs et le sitemap récurrent tournent.
4. **Schémas queue/cable/cache** : à charger une fois en prod avec `DISABLE_DATABASE_ENVIRONMENT_CHECK=1` (voir §3).

Ce résumé couvre l’essentiel des travaux pour avoir le Solid Trifecta opérationnel en dev et en prod.
