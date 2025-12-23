# 🚀 Quick Start SEO - Actions immédiates

## ⚡ À faire MAINTENANT (5 minutes)

### 1. Vérifier la configuration

```bash
cd /Users/maxime/code/MaxOudin/projects/maximeoudinpointfr/monsite
rails seo:check
```

✅ Si tout est vert, passez à l'étape 2 !

### 2. Régénérer le sitemap

```bash
rails seo:generate_sitemap
```

✅ Le sitemap contient maintenant toutes vos pages optimisées !

### 3. Voir le rapport complet

```bash
rails seo:report
```

✅ Vous obtiendrez des recommandations personnalisées.

---

## 📅 Cette semaine (2 heures)

### Jour 1-2 : Google Search Console

1. **S'inscrire** : https://search.google.com/search-console
2. **Ajouter votre site** : maximeoudin.fr
3. **Vérifier la propriété** :
   - Via DNS (recommandé)
   - Ou via fichier HTML
4. **Soumettre le sitemap** : `https://maximeoudin.fr/sitemaps/sitemap.xml.gz`

### Jour 3-4 : Google Analytics

1. **Créer un compte** : https://analytics.google.com/
2. **Créer une propriété GA4**
3. **Obtenir le code de suivi** (gtag.js)
4. **Installer dans** `app/views/layouts/_head.html.erb` avant `</head>` :

```erb
<!-- Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=G-XXXXXXXXXX"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'G-XXXXXXXXXX');
</script>
```

### Jour 5 : Optimisation images

```bash
# Installer ImageOptim (Mac) ou utiliser TinyPNG.com
# Compresser toutes les images du dossier app/assets/images/
# Objectif : < 200KB par image
```

### Jour 6-7 : Page "À propos"

Créer `app/views/pages/about.html.erb` avec :
- Votre parcours professionnel
- Vos compétences techniques
- Pourquoi vous choisir
- Témoignages clients (si disponibles)
- CTA (Call-to-Action) vers contact

---

## 📊 Ce mois-ci (10 heures)

### Semaine 1 : Contenu
- [ ] Écrire 2 articles de blog (500+ mots chacun)
- [ ] Enrichir 3 descriptions de projets (300+ mots)
- [ ] Ajouter des alt texts à toutes les images

### Semaine 2 : SEO Local
- [ ] Créer fiche [Google My Business](https://www.google.com/intl/fr_fr/business/)
- [ ] Ajouter photos professionnelles
- [ ] Définir zone d'intervention (Bordeaux + 50km)
- [ ] Demander 3-5 avis clients

### Semaine 3 : Maillage interne
- [ ] Ajouter des liens entre articles similaires
- [ ] Lier les projets aux articles techniques
- [ ] Créer une section "Articles liés" sur les pages projets

### Semaine 4 : Analyse
- [ ] Analyser Google Search Console
- [ ] Corriger les erreurs d'indexation
- [ ] Vérifier les Core Web Vitals
- [ ] Ajuster la stratégie selon les données

---

## 🧪 Tests essentiels

### 1. Données structurées

```bash
# Démarrer le serveur
rails s

# Ouvrir dans le navigateur
http://localhost:3000

# Faire clic droit > "Afficher le code source"
# Chercher "application/ld+json"
```

**Puis tester avec** : https://search.google.com/test/rich-results

### 2. Meta tags

**Tester avec** : https://metatags.io/

URLs à tester :
- Page d'accueil : https://maximeoudin.fr
- Un projet : https://maximeoudin.fr/projets/[slug]
- Un article : https://maximeoudin.fr/articles/[slug]

### 3. Performance

**Tester avec** : https://pagespeed.web.dev/

Objectif : Score > 90 sur mobile et desktop

---

## ✅ Checklist avant déploiement

### Configuration
- [ ] `ENV['DOMAIN']` est configuré
- [ ] Meta tags sont uniques par page
- [ ] Robots est sur `index, follow` (production)
- [ ] Images ont toutes un alt text
- [ ] Sitemap se génère correctement

### Tests locaux
- [ ] Serveur démarre sans erreur
- [ ] Pages s'affichent correctement
- [ ] Breadcrumbs fonctionnent (desktop & mobile)
- [ ] Données structurées présentes dans le code source
- [ ] Images se chargent avec lazy loading

### Validation en ligne
- [ ] Rich Results Test validé
- [ ] Schema.org validé
- [ ] Meta tags prévisualisés correctement
- [ ] Pas d'erreurs dans la console navigateur

---

## 🚨 Après déploiement

### Actions immédiates (30 min)

```bash
# En production (via SSH ou console)
rails sitemap:refresh
```

Puis :
1. **Soumettre à Google Search Console**
2. **Tester les Core Web Vitals** : https://pagespeed.web.dev/
3. **Vérifier l'indexation** : Recherche Google `site:maximeoudin.fr`
4. **Tester le partage social** : Partager sur Facebook/Twitter

### Première semaine
- [ ] Vérifier Google Search Console quotidiennement
- [ ] Corriger les erreurs d'exploration
- [ ] Vérifier que toutes les pages sont indexées
- [ ] Surveiller les positions sur mots-clés cibles

---

## 🔧 Commandes utiles

```bash
# Vérifier la configuration complète
rails seo:check

# Rapport détaillé avec recommandations
rails seo:report

# Générer le sitemap
rails seo:generate_sitemap

# Vérifier tous les meta tags
rails seo:check_meta_tags

# Valider les données structurées (donne les instructions)
rails seo:validate_structured_data
```

---

## 🆘 Dépannage rapide

### Le sitemap ne se génère pas

```bash
# Vérifier la configuration
cat config/sitemap.rb

# Vérifier les permissions
ls -la public/sitemaps/

# Régénérer
rails sitemap:refresh
```

### Les données structurées n'apparaissent pas

```bash
# Redémarrer le serveur (charge les nouveaux helpers)
# Ctrl+C puis :
rails s

# Vérifier dans le code source
curl http://localhost:3000 | grep "application/ld+json"
```

### Erreur "Asset not found"

Vérifier dans `config/meta.yml` que l'image par défaut existe :
```yaml
meta_image: "yellow_logo.svg"
```

### Les breadcrumbs ne s'affichent pas

```bash
# Vérifier que le CSS est chargé
ls app/assets/stylesheets/components/_breadcrumbs.scss

# Vérifier l'import
grep "breadcrumbs" app/assets/stylesheets/components/_index.scss
```

---

## 📚 Documentation complémentaire

- **Vue d'ensemble** : [02_SEO_GENERAL.md](./02_SEO_GENERAL.md)
- **Meta tags** : [03_SEO_METADATA.md](./03_SEO_METADATA.md)
- **Données structurées** : [04_SEO_STRUCTURED_DATA.md](./04_SEO_STRUCTURED_DATA.md)
- **Breadcrumbs** : [05_BREADCRUMBS.md](./05_BREADCRUMBS.md)

---

## 🎯 Mots-clés à cibler

### Primaires (priorité haute)
1. développeur web bordeaux
2. développeur web indépendant bordeaux
3. freelance développeur bordeaux

### Secondaires
4. création site internet bordeaux
5. développeur ruby on rails bordeaux
6. développeur full stack bordeaux

### Longue traîne (articles de blog)
7. comment créer un site web professionnel bordeaux
8. développeur e-commerce bordeaux
9. créateur application web bordeaux

**Utiliser naturellement ces mots-clés dans** :
- Titres d'articles
- Meta descriptions
- Descriptions de projets
- Alt texts des images

---

## ✨ Résumé

**Fait aujourd'hui** :
- ✅ Configuration SEO vérifiée
- ✅ Sitemap généré
- ✅ Rapport analysé

**À faire cette semaine** :
- 📊 Google Search Console
- 📈 Google Analytics
- 🖼️ Optimiser les images

**À faire ce mois** :
- 📝 Créer du contenu régulièrement
- 📍 SEO local (Google My Business)
- 🔗 Maillage interne

**Le SEO est un marathon, pas un sprint. Soyez patient et régulier !** 💪

---

*Dernière mise à jour : 23 Décembre 2025*

