# Exploitation — serveur de production

Le site tourne sur un VPS unique (Ubuntu 24.04 LTS, fuseau **UTC**) déployé avec Kamal :
conteneur web, `kamal-proxy` (SSL) et Postgres en accessoire, tous sur la même machine
(voir `config/deploy.yml`).

Contrairement à un PaaS (Heroku, Scalingo), personne ne s'occupe de l'OS, des redémarrages
ni des sauvegardes à notre place : cette page liste ce qu'il faut faire, et quand.

> Un seul serveur = pas de zéro coupure possible. L'objectif est une coupure planifiée de
> quelques minutes par mois, à heure creuse, des sauvegardes testées, et des alertes avant panne.

## État des lieux

| Sujet | État | Remarque |
|---|---|---|
| Mises à jour de sécurité OS | ✅ automatiques | `unattended-upgrades` |
| Heure de redémarrage automatique | ❌ à configurer | cause de l'incident du 16/10/2026 |
| Mises à jour Docker | ⚠️ manuelles | dépôt tiers, non couvert par `unattended-upgrades` |
| Sauvegarde Postgres hors serveur | ❌ à mettre en place | base dans un conteneur, sur le même disque |
| Test de restauration | ❌ jamais fait | |
| Scan CVE des gems | ✅ quotidien | `.github/workflows/security.yml` |
| Surveillance de disponibilité | ✅ UptimeRobot | ajouter un contrôle sur `/up` |
| Erreurs applicatives | ✅ Sentry | |
| Alertes disque / RAM | ❌ à mettre en place | |
| Pare-feu, SSH par clé, fail2ban | ❓ à vérifier | |
| Build Docker hors prod | ❌ | `builder.remote` builde sur le serveur web |

## Routine

### Tous les jours — automatique

- Mises à jour de sécurité Ubuntu (`unattended-upgrades`), redémarrage à **04:00 UTC** si nécessaire.
- Scan des CVE des gems (GitHub Actions, workflow `Security`) — lire les échecs reçus par mail.
- Sauvegarde Postgres vers S3 *(à mettre en place)*.

### Tous les mois — à la main, à heure creuse

Mise à jour complète du serveur, Docker inclus (les conteneurs redémarrent : quelques minutes de coupure) :

```bash
ssh pioncham@<serveur>
sudo apt update
apt list --upgradable          # relire ce qui va bouger
sudo apt full-upgrade
sudo reboot
```

Puis, une fois le serveur revenu :

```bash
docker ps                      # web, kamal-proxy et db sont "Up"
curl -sI https://maximeoudin.fr/up | head -1   # HTTP 200
docker system prune -f         # images et conteneurs arrêtés
docker builder prune -f        # cache de build
df -h /                        # place disque
```

Côté application :

```bash
bundle update --patch --strict # correctifs de gems sans changement de série
bundle exec rspec
kamal deploy
```

### Tous les trimestres

- **Tester la restauration** d'une sauvegarde Postgres dans une base locale ou temporaire.
- Vérifier la place disque, la taille des volumes Docker et des logs (`journalctl --disk-usage`).
- Relire les alertes UptimeRobot du trimestre : y a-t-il des coupures non expliquées ?
- Vérifier que le certificat SSL se renouvelle (géré par `kamal-proxy`).

### Tous les ans

- Revoir les versions majeures : Ruby, Rails, Postgres (image `postgres:17`), Ubuntu.
- Ubuntu 24.04 est supporté jusqu'en 2029 : ne pas lancer `do-release-upgrade` à la légère.
  Le passage à la LTS suivante se prépare (sauvegarde, test sur un serveur jetable).

## Configuration à faire une fois

### Redémarrage automatique à heure fixe

`/etc/apt/apt.conf.d/52unattended-upgrades-local` :

```
Unattended-Upgrade::Automatic-Reboot "true";
Unattended-Upgrade::Automatic-Reboot-Time "04:00";
Unattended-Upgrade::Remove-Unused-Kernel-Packages "true";
Unattended-Upgrade::Remove-Unused-Dependencies "true";
```

Vérifier avec `sudo unattended-upgrade --dry-run --debug`.

### Durcissement

- Pare-feu : `ufw` n'autorisant que 22, 80, 443. Postgres est déjà publié sur `127.0.0.1` uniquement.
- SSH : `PasswordAuthentication no`, `PermitRootLogin no` dans `/etc/ssh/sshd_config`.
- `fail2ban` sur SSH.

### Supervision

- UptimeRobot : contrôle HTTP sur `https://maximeoudin.fr/up` en plus de la page d'accueil.
- Alertes disque (> 80 %) et mémoire : agent de l'hébergeur ou Netdata.

## Diagnostiquer une coupure

```bash
uptime                                   # le serveur a-t-il redémarré ?
last -x reboot shutdown | head -5        # heures d'arrêt et de démarrage (UTC)
docker ps --format "{{.Names}}\t{{.Status}}"
journalctl -b -1 --no-pager | tail -50   # fin du démarrage précédent : qui a lancé l'arrêt ?
journalctl --since "AAAA-MM-JJ HH:MM" --until "AAAA-MM-JJ HH:MM" -p warning --no-pager
kamal app logs --since 1h
```

Lecture d'une alerte UptimeRobot :

- **Connection Timeout** : la machine ou le proxy ne répond pas du tout (serveur éteint, réseau, saturation).
- **HTTP 5xx** : la machine répond, c'est l'application qui plante → Sentry et `kamal app logs`.

## Historique des incidents

| Date (Paris) | Durée | Cause | Suite |
|---|---|---|---|
| 16/10/2026 19:56 → 20:34 | ~37 min | Redémarrage du serveur après mise à jour du noyau (6.8.0-146 → 147), en pleine soirée. Arrêt 17:53 UTC, démarrage 18:29 UTC : durée anormale, cause du délai non confirmée (logs `journalctl -b -1` à relire). | Fixer l'heure de redémarrage à 04:00 UTC. |
