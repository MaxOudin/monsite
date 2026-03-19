# Audit mémoire — Web & Worker (Scalingo)

**Date de l'audit :** 19 mars 2026
**Contexte :** Mémoire web ~217 Mo, mémoire worker ~240 Mo observées dans le dashboard Scalingo.

---

## Verdict global

Les chiffres observés sont **dans la fourchette haute du normal** pour une app Rails 8 avec ce stack (Devise, Pundit, ActiveStorage + Vips, Sentry, SolidQueue/Cable/Cache, pg_search, ViewComponent…). jemalloc est correctement activé sur les deux processus.

**Le vrai signal d'alarme serait une croissance continue dans le temps.** Un plateau stable, même élevé, n'est pas une fuite mémoire — c'est le baseline de l'application.

---

## Ce qui a été audité

| Fichier / Composant | Statut |
|---|---|
| `config/puma.rb` | ✅ Correct |
| `config/queue.yml` | ✅ Correct |
| `config/database.yml` (pool) | ✅ Correct |
| `config/cache.yml` (SolidCache) | ✅ Correct |
| `config/cable.yml` (SolidCable) | ✅ Correct |
| `config/environments/production.rb` | ✅ Correct |
| `config/initializers/rack_attack.rb` | ⚠️ Voir point 3 |
| `config/initializers/sentry.rb` | ✅ Correct |
| `app/jobs/generate_sitemap_job.rb` | ⚠️ Voir point 1 |
| `bin/with-jemalloc` | ✅ Correct |
| `Gemfile` | ⚠️ Voir point 2 |

---

## Problèmes identifiés

### 1. `GenerateSitemapJob` — `load_tasks` appelé sans garde

**Fichier :** `app/jobs/generate_sitemap_job.rb`

**Problème :** `Rails.application.load_tasks` charge toutes les définitions de tâches Rake dans l'objet global `Rake::Task` à chaque appel. Les objets tâche s'accumulent dans la mémoire du processus worker.

```ruby
# ⚠️ Actuel
def perform
  require "rake"
  Rails.application.load_tasks  # charge TOUT à chaque exécution
  Rake::Task["sitemap:refresh:no_ping"].reenable
  Rake::Task["sitemap:refresh:no_ping"].invoke
end
```

**Fix :**

```ruby
# ✅ Corrigé
def perform
  require "rake"
  Rails.application.load_tasks unless Rake::Task.task_defined?("sitemap:refresh:no_ping")
  Rake::Task["sitemap:refresh:no_ping"].reenable
  Rake::Task["sitemap:refresh:no_ping"].invoke
end
```

Le job tourne une fois par jour donc l'impact est limité, mais c'est un anti-pattern à corriger.

---

### 2. `gem "redis"` chargé inutilement

**Fichier :** `Gemfile`

**Problème :** Le gem `redis` est présent dans le Gemfile mais en production l'app utilise :
- **SolidCable** (PostgreSQL) pour ActionCable — pas Redis
- **SolidCache** (PostgreSQL) pour le cache — pas Redis
- **SolidQueue** (PostgreSQL) pour les jobs — pas Redis

Le gem est chargé au boot et alloue de la mémoire sans servir à rien.

**Action :** Vérifier qu'aucun code n'utilise Redis directement (`grep -r "Redis" app/ config/`), puis supprimer la ligne du Gemfile et relancer `bundle install`.

---

### 3. `ActiveSupport::Notifications.subscribe` dans `rack_attack.rb`

**Fichier :** `config/initializers/rack_attack.rb` — lignes 69 et 179

**Problème :** Deux souscriptions aux notifications sont enregistrées au niveau classe. En production (`enable_reloading = false`) c'est safe — elles ne sont enregistrées qu'une fois au boot.

**Risque en staging :** Si `enable_reloading = true` est activé en staging, chaque rechargement de fichier multiplie les listeners, ce qui peut causer des comportements inattendus (logs dupliqués, compteurs Rack::Attack doublés).

**Action :** Aucune en production. En staging, s'assurer que `enable_reloading = false` ou envelopper les souscriptions avec une garde :

```ruby
# Protection contre les souscriptions multiples en dev/staging
unless Rails.application.config.enable_reloading
  ActiveSupport::Notifications.subscribe('rack.attack') do |...|
    # ...
  end
end
```

---

## Ce qui est correct

### jemalloc activé sur les deux processus

```bash
# Procfile
web:    bin/with-jemalloc bundle exec puma -C config/puma.rb
worker: bin/with-jemalloc bundle exec bin/jobs
```

jemalloc réduit la fragmentation mémoire de Ruby, particulièrement efficace avec Puma multi-thread. Configuration correcte.

### Pool de connexions bien dimensionné

| Connexions | Pool | Justification |
|---|---|---|
| Primary | 5 (= RAILS_MAX_THREADS) | Aligné avec 3 threads Puma |
| Queue | 2 | Solid Queue minimal |
| Cable | 1 | Solid Cable minimal |
| Cache | 2 | Solid Cache minimal |

Total : ~10 connexions par processus. Normal pour ce setup.

### SolidCache limité à 256 Mo

```yaml
# config/cache.yml
store_options:
  max_size: <%= 256.megabytes %>
```

La limite est sur **la base de données**, pas en RAM. N'affecte pas la mémoire des processus Ruby.

### eager_load activé en production

```ruby
# config/environments/production.rb
config.eager_load = true
```

Charge tout le code au boot, ce qui augmente la mémoire initiale mais évite les allocations JIT pendant les requêtes. C'est le comportement attendu et recommandé.

---

## Recommandations

| Priorité | Action | Impact |
|---|---|---|
| **Haute** | Corriger `GenerateSitemapJob` avec `task_defined?` | Évite l'accumulation de tâches Rake dans le worker |
| **Moyenne** | Supprimer `gem "redis"` si inutilisé | Réduit légèrement le footprint mémoire au boot |
| **Moyenne** | Vérifier la courbe mémoire dans Scalingo (croissance vs plateau) | Distingue une vraie fuite d'un baseline élevé |
| **Basse** | Ajouter `MALLOC_ARENA_MAX=2` en variable d'env Scalingo | Réduit la fragmentation glibc même avec jemalloc |
| **Basse** | Évaluer `puma-worker-killer` si la mémoire croît dans le temps | Force des restarts périodiques pour récupérer la mémoire |

### Variable `MALLOC_ARENA_MAX=2`

À ajouter dans les variables d'environnement Scalingo. Réduit le nombre d'arènes mémoire de glibc (défaut : 8× le nombre de CPU), ce qui diminue la fragmentation :

```
MALLOC_ARENA_MAX=2
```

---

## Baseline mémoire attendue

Pour référence, une app Rails 8 avec ce Gemfile démarre typiquement à :

| Composant | Mémoire attendue |
|---|---|
| Ruby runtime | ~40 Mo |
| Rails + gems chargés | ~80–120 Mo |
| Puma 3 threads + pools DB | ~20–30 Mo |
| Bootsnap cache | négligeable (fichiers) |
| **Total web (baseline)** | **~150–200 Mo** |
| Worker (Solid Queue + même gems) | **~150–220 Mo** |

Les 217 Mo web et 240 Mo worker sont donc légèrement au-dessus du baseline bas mais restent dans la plage normale.

---

## Comment surveiller

### Via Scalingo

Dans le dashboard Scalingo → **Métriques** → observer la courbe mémoire sur 7 jours :
- **Courbe plate** → baseline normal, pas d'action urgente
- **Courbe croissante** → fuite mémoire réelle, creuser avec les outils ci-dessous

### Outils de diagnostic

```bash
# Voir les objets Ruby en mémoire (en console Rails)
ObjectSpace.count_objects

# Gem derailed_benchmarks pour analyser le poids des gems
bundle exec derailed bundle:mem

# Voir la consommation par gem
bundle exec derailed bundle:objects
```

---

*Dernière mise à jour : 19 mars 2026*
