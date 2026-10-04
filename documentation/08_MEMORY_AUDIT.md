# Audit mémoire — Web & Worker (Scalingo, mars 2026)

**Date de l'audit :** 19 mars 2026
**Contexte :** Mémoire web ~217 Mo, mémoire worker ~240 Mo observées dans le dashboard Scalingo, quand l’app y était hébergée.

**État actuel :** la production est sur Kamal (`config/deploy.yml`), un seul conteneur web. `Procfile`, `.profile.d/` et `bin/with-jemalloc` ont été retirés. jemalloc n’est plus préchargé. Il n’y a pas de processus worker séparé en production. Les chiffres ci-dessous décrivent l’ancien hébergement.

---

## Verdict global

Les chiffres observés étaient **dans la fourchette haute du normal** pour une app Rails 8 avec ce stack (Devise, Pundit, ActiveStorage + Vips, Sentry, SolidQueue/Cable/Cache, pg_search, ViewComponent…). jemalloc était activé sur les deux processus Scalingo, via `bin/with-jemalloc`. Ce binaire n’existe plus.

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
| `app/jobs/generate_sitemap_job.rb` | ✅ Garde `task_defined?` en place |
| `bin/with-jemalloc` | Retiré avec le passage à Kamal |
| `Gemfile` | ✅ `gem "redis"` absent |

---

## Problèmes identifiés

### 1. `GenerateSitemapJob` — `load_tasks` appelé sans garde

**Fichier :** `app/jobs/generate_sitemap_job.rb`

**Problème (corrigé) :** `Rails.application.load_tasks` charge toutes les définitions de tâches Rake dans l'objet global `Rake::Task` à chaque appel. Le job garde maintenant l’appel avec `Rake::Task.task_defined?("sitemap:refresh:no_ping")`.

---

### 2. `gem "redis"` chargé inutilement

**Traité.** Le `Gemfile` ne déclare plus `redis`. Action Cable, le cache et les jobs passent par Solid Cable, Solid Cache et Solid Queue (PostgreSQL).

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

### jemalloc, à l’époque Scalingo

Le `Procfile` Scalingo lançait le web et le worker via `bin/with-jemalloc`, qui préchargeait `libjemalloc` depuis `/app/.apt`. Ces fichiers ont été supprimés : l’image Docker / Kamal ne précharge pas jemalloc.

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
| **Haute** | `GenerateSitemapJob` garde `task_defined?` | Fait |
| **Moyenne** | `gem "redis"` retiré | Fait |
| **Moyenne** | Suivre la mémoire du conteneur web Kamal (`docker stats` sur le VPS) | Distingue une vraie fuite d'un baseline élevé |
| **Basse** | `MALLOC_ARENA_MAX=2` en variable d'environnement du conteneur, si la fragmentation glibc pose problème | jemalloc n’est plus préchargé |
| **Basse** | Évaluer `puma-worker-killer` si la mémoire croît dans le temps | Force des restarts périodiques pour récupérer la mémoire |

### Variable `MALLOC_ARENA_MAX=2`

À poser dans les variables d’environnement Kamal seulement si la fragmentation glibc du conteneur web devient un sujet. Réduit le nombre d'arènes mémoire de glibc (défaut : 8× le nombre de CPU) :

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

### Via le VPS

`docker stats` sur le conteneur web Kamal, sur plusieurs jours :
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

*Audit du 19 mars 2026. Mise à jour d’octobre 2026 : hébergement Kamal, fichiers Scalingo retirés.*
