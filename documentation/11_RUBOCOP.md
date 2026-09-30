# RuboCop

Guide d’utilisation de RuboCop sur le portfolio, avec une stratégie progressive de mise en conformité.

## Pourquoi RuboCop ?

RuboCop applique des conventions Ruby/Rails de façon automatique et détecte des problèmes réels (variables inutilisées, branches dupliquées, patterns Rails/Performance).

Plugins activés :

| Gem | Rôle |
|-----|------|
| `rubocop` | Cops de base (Layout, Lint, Style, Metrics…) |
| `rubocop-rails` | Conventions Rails |
| `rubocop-performance` | Patterns plus efficaces |
| `rubocop-rspec` | Conventions RSpec |

## Fichiers de configuration

| Fichier | Rôle |
|---------|------|
| [`.rubocop.yml`](../.rubocop.yml) | Règles du projet (Ruby 3.4, exclusions, seuils Metrics/RSpec) |
| [`.rubocop_todo.yml`](../.rubocop_todo.yml) | Dette technique historique : offenses encore tolérées |

`.rubocop.yml` hérite de `.rubocop_todo.yml`. Les nouveaux fichiers / nouvelles offenses **ne sont pas** couverts par le todo : ils doivent être propres.

## Commandes utiles

```bash
# Analyse complète (doit rester vert en CI)
bundle exec rubocop

# Un fichier ou un dossier
bundle exec rubocop app/models/article.rb
bundle exec rubocop app/services/

# Auto-correct sûr uniquement
bundle exec rubocop -a

# Auto-correct sûr + unsafe (à revoir dans le diff)
bundle exec rubocop -A

# Un département de cops
bundle exec rubocop -a --only Layout,Lint
bundle exec rubocop -a --only Rails/Presence,Performance
```

## Stratégie progressive

Le codebase a été mis au vert via un todo généré, puis des vagues de corrections ciblées (Layout, Lint, puis Rails/Performance autocorrectables).

Pour réduire la dette :

1. Choisir un cop dans `.rubocop_todo.yml`
2. Retirer sa section du todo
3. Corriger (`bundle exec rubocop -a --only Cop/Name` ou correction manuelle)
4. Vérifier `bundle exec rubocop` et les specs concernées
5. Commit dédié si le diff est large

Éviter un `rubocop -A` global : trop de bruit, risque sémantique sur les cops unsafe.

## CI locale

RuboCop est intégré dans [`config/ci.rb`](../config/ci.rb) :

```bash
bin/ci
```

L’étape `Style: RuboCop` tourne avant les tests pour un feedback rapide.

## Bonnes pratiques PR

- Ne pas ajouter de nouvelles offenses hors todo
- Préférer corriger plutôt qu’exclure
- Disable local ponctuel si besoin justifié :

```ruby
# rubocop:disable Lint/UnusedMethodArgument -- raison courte
def example(arg)
end
# rubocop:enable Lint/UnusedMethodArgument
```

- Regénérer le todo seulement après une vague de corrections volontaire :

```bash
bundle exec rubocop --auto-gen-config --auto-gen-only-exclude --exclude-limit 100 --no-offense-counts --no-auto-gen-timestamp
```

## Périmètre volontairement hors scope (pour l’instant)

- Pas de hook pre-commit Git
- Pas de migration vers `rubocop-rails-omakase`
- Pas d’auto-correct unsafe massif sur tout le codebase
