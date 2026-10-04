# Brakeman

Analyse statique du code Rails (injections, XSS, mass assignment, etc.). Brakeman lit le code, il ne charge pas l'application et ne voit pas les gems (`bundler-audit` couvre ce second volet).

## Commande

```bash
bin/brakeman --no-pager
```

Le binstub force `--ensure-latest` : si une version plus récente existe sur RubyGems, la commande s'arrête (code 5) sans scanner. Mettre à jour avec `bundle update brakeman`, puis relancer.

## Ce qui est en place

| Élément | Statut |
|---------|--------|
| Gem `brakeman` (dev/test), 8.1.0 | ✅ |
| Binstub `bin/brakeman` | ✅ |
| Documentation (ce fichier) | ✅ |
| `config/brakeman.ignore` | ❌ inutile (0 warning) |
| Étape `bin/ci` locale | ✅ |
| Job CI GitHub Actions | ❌ |

## État initial (2026-10-04)

Scan Brakeman 8.1.0, Rails 8.1.2, 79 checks, 0 erreur d'analyse.

| Couverture | Nombre |
|------------|-------:|
| Contrôleurs | 12 |
| Modèles | 9 |
| Templates | 55 |
| Warnings | 0 |

| Confiance | Type | Nombre |
|-----------|------|-------:|
| — | — | 0 |

Motifs revus en plus du scan (Brakeman ne les signale pas toujours) : pas de `constantize` sur un paramètre, pas de `:role` en mass assignment, pas de `URI::DEFAULT_PARSER.make_regexp`. Les `html_safe` restants sont le SVG de QR code (sortie de `RQRCode`) et du JSON-LD (`to_json`).

## Suite

1. Garder `bin/brakeman --no-pager` vert dans `bin/ci`.
2. Un nouveau warning se traite dans le code, ou dans `config/brakeman.ignore` avec une note datée (faux positif ou dette).
3. Le workflow GitHub Actions reste à ajouter, comme pour bundler-audit.
