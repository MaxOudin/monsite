# Stack Solid (Queue, Cache, Cable)

## Ce qui a été fait

- Gems installées : `solid_queue`, `solid_cable`, `solid_cache`
- `config/queue.yml`, `config/recurring.yml`, `config/cache.yml`, `config/cable.yml` en place
- `config/database.yml` : bases séparées en production (`primary`, `queue`, `cable`, `cache`) ; en dev/test les 4 connexions pointent vers la même base
- `config/environments/production.rb` : `cache_store = :solid_cache_store`, `active_job.queue_adapter = :solid_queue`, `solid_queue.connects_to`
- `config/environments/development.rb` et `test.rb` : `solid_queue.connects_to` pour utiliser la connexion `queue`
- **Procfile** : `worker: bundle exec bin/jobs` (remplace Sidekiq)
- Schémas : `db/queue_schema.rb`, `db/cable_schema.rb`, `db/cache_schema.rb`

## Actions à faire

### 1. En local (development)

Charger les schémas des bases queue, cable et cache dans `cd_development` (une seule base en dev, les 3 schémas y sont chargés) :

```bash
bin/rails db:prepare
```

Si les tables queue/cable/cache ne sont pas créées, charger les schémas à la main :

```bash
bin/rails db:schema:load:queue
bin/rails db:schema:load:cable
bin/rails db:schema:load:cache
```

Puis lancer le worker (optionnel en dev) :

```bash
bundle exec bin/jobs
```

### 2. En production (déploiement)

- **Créer les 3 bases** sur PostgreSQL (si pas déjà fait) :  
  `cd_production_queue`, `cd_production_cable`, `cd_production_cache`

- **Préparer toutes les bases** (création + chargement des schémas) :

```bash
RAILS_ENV=production bundle exec rails db:prepare
```

Si besoin, charger chaque schéma explicitement :

```bash
RAILS_ENV=production bundle exec rails db:schema:load:queue
RAILS_ENV=production bundle exec rails db:schema:load:cable
RAILS_ENV=production bundle exec rails db:schema:load:cache
```

- **Lancer le worker** : le process `worker` du Procfile (`bundle exec bin/jobs`) doit tourner en production pour exécuter les jobs et les tâches récurrentes (`config/recurring.yml`).

### 3. Tâches récurrentes

Le fichier `config/recurring.yml` définit les jobs récurrents (ex. nettoyage Solid Queue toutes les heures). Pour ajouter la génération hebdomadaire du sitemap, ajouter un job dédié et une entrée dans `recurring.yml` (voir la doc du sitemap dans le projet).

## Les jobs récurrents sont-ils actifs en prod ?

**Oui, à condition que le process worker tourne en production.**

- Le **Procfile** définit `worker: bundle exec bin/jobs`. Sur ton hébergement (Docker, Heroku, VPS, etc.), il faut **démarrer ce process** en plus du process `web`. Si seul le process web tourne, les jobs (dont le heartbeat et le sitemap) ne seront jamais exécutés.
- À vérifier au déploiement : que le worker est bien lancé (ex. dans Docker Compose un service `worker`, ou un dyno worker sur Heroku).

## Voir si un job est lancé ou a tourné

### 1. Logs (le plus simple)

Le **HeartbeatCheckJob** écrit dans les logs à chaque exécution :

```
[HeartbeatCheckJob] Scheduler OK — 2026-03-17T22:30:00+01:00
```

- En **dev** : tu vois cette ligne dans la sortie du process **worker** (terminal où tourne `bin/dev` ou `bundle exec bin/jobs`).
- En **prod** : regarde les logs du **worker** (pas seulement du web). Selon ton hébergeur : `docker compose logs -f worker`, `heroku logs --tail -a ton-app`, ou le fichier / service où vont les logs du process worker.

Si cette ligne apparaît toutes les 10 minutes, le scheduler et le worker fonctionnent.

### 2. Base de données (queue)

Les jobs passent par la base **queue** (`cd_production_queue` en prod, ou `cd_development` en dev). Tu peux inspecter les exécutions :

```bash
# Console Rails (en pensant à la connexion queue en prod)
bin/rails runner "
  SolidQueue::Job.connection  # utilise la connexion queue
  last = SolidQueue::Job.where(class_name: 'HeartbeatCheckJob').order(finished_at: :desc).first
  puts last ? \"Dernier heartbeat: #{last.finished_at}\" : 'Aucun heartbeat trouvé'
"
```

En prod, si ta console utilise par défaut la base primary, il faut utiliser la connexion queue. Exemple en console :

```ruby
# En production, se connecter à la base queue pour voir les jobs
ActiveRecord::Base.connected_to(role: :writing, shard: :queue) do
  SolidQueue::Job.where(class_name: 'HeartbeatCheckJob').order(finished_at: :desc).limit(5).pluck(:finished_at)
end
```

(Adapter si ta config multi-DB utilise `connects_to` sans shard — alors un simple `SolidQueue::Job.where(...)` peut suffire car les modèles Solid Queue sont déjà connectés à la base queue.)

### 3. Tâches récurrentes enregistrées

Pour voir quelles tâches récurrentes sont connues par Solid Queue (chargées depuis `config/recurring.yml`) :

```bash
bin/rails runner "SolidQueue::RecurringTask.all.each { |t| puts \"#{t.key} -> #{t.schedule}\" }"
```

Tu devrais voir par exemple `heartbeat_check` et `clear_solid_queue_finished_jobs`.

---

## Vérifications rapides

- **Queue** : `bin/rails runner "puts ActiveJob::Base.queue_adapter"` → doit afficher `SolidQueue::Adapter` en dev/prod.
- **Worker** : `bundle exec bin/jobs` démarre sans erreur et affiche les processus (supervisor, workers, etc.).
- **Cache** : en production, `Rails.cache` utilise Solid Cache (base `cd_production_cache`).
- **Cable** : en production, Action Cable utilise Solid Cable (base `cd_production_cable`) ; plus besoin de Redis pour Cable.
