# 📊 SEO Général - Vue d'ensemble et stratégie

## 🎯 Objectif principal

**Faire de votre site le portfolio de référence pour "développeur web Bordeaux"**

---

## 📋 Architecture SEO actuelle

### ✅ Ce qui est en place

| Composant | Status | Impact |
|-----------|--------|--------|
| **Meta tags** | ✅ Optimisés | Améliore le CTR dans Google |
| **Données structurées** | ✅ Implémenté | Rich snippets possibles |
| **Sitemap XML** | ✅ Configuré | Indexation plus rapide |
| **Breadcrumbs** | ✅ Avec Schema.org | Navigation + SEO |
| **Lazy loading** | ✅ Activé | Performance améliorée |
| **Canonical URLs** | ✅ Configuré | Évite contenu dupliqué |
| **Open Graph** | ✅ Complet | Partage social optimisé |
| **Robots.txt** | ✅ OK | Contrôle l'indexation |

---

## 🗂️ Structure des fichiers SEO

```
app/
├── helpers/
│   ├── meta_tags_helper.rb          # Gestion meta tags
│   ├── structured_data_helper.rb    # Schema.org
│   ├── breadcrumbs_helper.rb        # Fil d'Ariane
│   └── performance_helper.rb        # Optimisations

├── views/
│   ├── layouts/
│   │   ├── application.html.erb     # Layout principal
│   │   ├── _head.html.erb           # <head> organisé
│   │   └── _meta_tags.html.erb      # Tous les meta tags
│   └── shared/
│       ├── _breadcrumbs.html.erb    # Fil d'Ariane
│       └── _structured_data.html.erb # Données structurées

├── assets/stylesheets/components/
│   └── _breadcrumbs.scss            # Styles breadcrumbs

config/
├── meta.yml                         # Configuration meta par défaut
├── sitemap.rb                       # Génération sitemap
└── routes.rb                        # URLs SEO-friendly

lib/tasks/
└── seo.rake                         # Commandes SEO personnalisées
```

---

## 📈 Stratégie de contenu

### Fréquence de publication recommandée

| Type | Fréquence | Longueur min |
|------|-----------|--------------|
| **Articles de blog** | 2-4 / mois | 500 mots |
| **Projets détaillés** | 1-2 / mois | 300 mots |
| **Mise à jour projets** | 1 / trimestre | - |

### Sujets d'articles suggérés

**Technique** :
- "5 erreurs à éviter lors de la création d'un site web"
- "Pourquoi choisir Ruby on Rails pour votre application"
- "Guide : Optimiser les performances de votre site"
- "Sécurité web : Les bases essentielles"

**SEO / Marketing** :
- "Comment améliorer le référencement de votre site Bordeaux"
- "Les étapes clés pour créer un site e-commerce réussi"
- "Pourquoi votre entreprise a besoin d'une application web"

**Tutoriels** :
- "Créer un blog avec Ruby on Rails"
- "Déployer son application sur Heroku"
- "Intégrer Stripe pour les paiements"

---

## 🎯 Mots-clés cibles

### Primaires (priorité max)

```
développeur web bordeaux              Volume: 590/mois  Difficulté: Moyenne
développeur web indépendant bordeaux  Volume: 140/mois  Difficulté: Faible
freelance développeur bordeaux        Volume: 210/mois  Difficulté: Faible
```

### Secondaires

```
création site internet bordeaux       Volume: 720/mois  Difficulté: Élevée
développeur ruby on rails bordeaux    Volume: 50/mois   Difficulté: Faible
développeur full stack bordeaux       Volume: 320/mois  Difficulté: Moyenne
```

### Longue traîne (articles)

```
comment créer un site web bordeaux
développeur e-commerce bordeaux
créateur application web bordeaux
développeur saas bordeaux
agence web bordeaux alternative freelance
```

---

## 📊 KPIs à suivre

### Google Search Console

| Métrique | Objectif 3 mois | Objectif 6 mois |
|----------|-----------------|-----------------|
| **Impressions** | 5 000 | 15 000 |
| **Clics** | 150 | 500 |
| **Position moyenne** | Top 20 | Top 10 |
| **CTR** | 3% | 5% |
| **Pages indexées** | 30+ | 50+ |

### Google Analytics

| Métrique | Objectif 3 mois | Objectif 6 mois |
|----------|-----------------|-----------------|
| **Trafic organique** | +50% | +100% |
| **Taux de rebond** | < 60% | < 50% |
| **Temps sur page** | > 2 min | > 3 min |
| **Pages/session** | 2.5 | 3.5 |
| **Conversions** | 3 leads | 10 leads |

### Core Web Vitals

| Métrique | Seuil "Bon" | Objectif |
|----------|-------------|----------|
| **LCP** (Largest Contentful Paint) | < 2.5s | < 2s |
| **FID** (First Input Delay) | < 100ms | < 50ms |
| **CLS** (Cumulative Layout Shift) | < 0.1 | < 0.05 |

---

## 🗺️ Sitemap et indexation

### Configuration actuelle

```ruby
# config/sitemap.rb
SitemapGenerator::Sitemap.default_host = "https://#{ENV['DOMAIN']}"

add '/', changefreq: 'daily', priority: 1.0
add projets_path, changefreq: 'weekly', priority: 0.9
add articles_path, changefreq: 'weekly', priority: 0.9
add services_path, changefreq: 'monthly', priority: 0.8
add '/mentions-legales', changefreq: 'yearly', priority: 0.2

# Projets individuels
Projet.find_each do |projet|
  add projet_path(projet),
      lastmod: projet.updated_at,
      changefreq: 'monthly',
      priority: 0.8,
      images: [{ loc: projet.image_url, title: projet.titre }]
end

# Articles individuels  
Article.find_each do |article|
  add article_path(article),
      lastmod: article.updated_at,
      changefreq: 'monthly',
      priority: 0.7,
      images: [{ loc: article.image_url, title: article.titre }]
end
```

### Commandes utiles

```bash
# Régénérer le sitemap
rails sitemap:refresh

# Sitemap sans notifier Google (dev)
rails sitemap:refresh:no_ping

# Générer avec stats
rails seo:generate_sitemap
```

---

## ⚡ Performance et Core Web Vitals

### Optimisations implémentées

**Images** :
- ✅ Lazy loading activé (`loading="lazy"`)
- ✅ Dimensions explicites (évite CLS)
- ✅ Compression recommandée (< 200KB)

**Cache** :
- ✅ Headers optimisés (1 an pour assets)
- ✅ Compression Gzip/Deflate activée
- ✅ Redis cache en production (optionnel)

**CSS/JS** :
- ✅ Assets compilés et minifiés
- ✅ Importmap pour JS moderne
- ✅ CSS séparé par composants

### Améliorations futures

**Images avancées** :
```ruby
# Dans app/helpers/performance_helper.rb
def responsive_image_tag(source, alt_text, options = {})
  srcset = [
    "#{source}?w=320 320w",
    "#{source}?w=640 640w",
    "#{source}?w=1024 1024w",
    "#{source}?w=1200 1200w"
  ].join(", ")
  
  image_tag(source, srcset: srcset, sizes: "...", loading: "lazy", alt: alt_text)
end
```

**WebP** :
```ruby
# Convertir les images en WebP pour -30% de poids
# Utiliser ImageMagick ou libvips
```

---

## 🔍 SEO Local (Bordeaux)

### Google My Business

**Configuration recommandée** :
- Nom : "Maxime Oudin - Développeur Web Freelance"
- Catégorie : Développeur de logiciels
- Zone d'intervention : Bordeaux + 50km
- Horaires : Lundi-Vendredi 9h-18h
- Site web : https://maximeoudin.fr
- Description : Inclure mots-clés locaux

**Photos à ajouter** :
- Photo de profil professionnelle
- Logo
- Photos de projets réalisés
- Espace de travail (optionnel)

**Avis clients** :
- Demander 5-10 avis au lancement
- Répondre à tous les avis (positifs et négatifs)
- Objectif : 4.5+ étoiles

### Citations locales

Inscriptions recommandées :
- [Pages Jaunes](https://www.pagesjaunes.fr)
- [Kompass](https://fr.kompass.com)
- [Yelp France](https://www.yelp.fr)
- Annuaires locaux Bordeaux

---

## 🔗 Stratégie de liens

### Liens internes

**À implémenter** :
- Articles liés par thème
- Projets similaires (même technologie)
- CTAs vers contact dans chaque article
- Liens contextuels dans le contenu

**Exemple** :
```erb
<!-- Dans app/views/articles/show.html.erb -->
<div class="related-articles">
  <h3>Articles similaires</h3>
  <% @article.related_articles(3).each do |related| %>
    <%= link_to related.titre, article_path(related) %>
  <% end %>
</div>
```

### Backlinks (liens externes)

**Stratégies** :
- Publier des guest posts sur blogs tech
- Participer à des forums (Reddit, Dev.to)
- Contribuer à des projets open source
- Créer du contenu référencable (infographies, guides)
- Obtenir des témoignages clients avec lien

**À éviter** :
- ❌ Acheter des liens
- ❌ Fermes de liens
- ❌ Échanges de liens excessifs
- ❌ Annuaires de mauvaise qualité

---

## 📱 Mobile-First

### Vérifications

- [x] Site responsive sur tous les breakpoints
- [x] Texte lisible sans zoom (16px minimum)
- [x] Boutons facilement cliquables (48px minimum)
- [x] Images adaptées au mobile
- [x] Navigation mobile intuitive
- [x] Breadcrumbs adapté (bouton retour sur mobile)

### Test

```bash
# Lighthouse (Chrome DevTools)
# F12 > Lighthouse > Mobile > Generate report
# Objectif : Score > 90
```

---

## 🛠️ Outils essentiels

### Gratuits

| Outil | Usage | URL |
|-------|-------|-----|
| **Google Search Console** | Suivi indexation | search.google.com/search-console |
| **Google Analytics** | Statistiques trafic | analytics.google.com |
| **PageSpeed Insights** | Performance | pagespeed.web.dev |
| **Rich Results Test** | Données structurées | search.google.com/test/rich-results |
| **Schema Validator** | Validation Schema.org | validator.schema.org |
| **Meta Tags Preview** | Prévisualiser meta tags | metatags.io |

### Payants (optionnels)

| Outil | Prix | Usage |
|-------|------|-------|
| **Ahrefs** | ~99€/mois | Backlinks, mots-clés |
| **SEMrush** | ~119€/mois | Tout-en-un SEO |
| **Screaming Frog** | Gratuit/<150€/an | Audit technique |

---

## 📅 Plan d'action 6 mois

### Mois 1 : Fondations
- [x] Configuration technique SEO
- [ ] Google Search Console
- [ ] Google Analytics
- [ ] 5 articles publiés
- [ ] Images optimisées

### Mois 2 : Local
- [ ] Google My Business
- [ ] 8 articles (total: 13)
- [ ] 5+ avis clients
- [ ] Maillage interne

### Mois 3 : Contenu
- [ ] 8 articles (total: 21)
- [ ] 10 projets détaillés
- [ ] Première analyse performances
- [ ] Ajustements SEO

### Mois 4-6 : Croissance
- [ ] 3-4 articles/mois
- [ ] Backlinks naturels (5-10)
- [ ] Optimisation continue
- [ ] Objectifs atteints

---

## ✅ Checklist mensuelle

### Contenu
- [ ] Publier 2-4 articles
- [ ] Mettre à jour 1-2 projets existants
- [ ] Ajouter témoignages clients
- [ ] Optimiser mots-clés

### Technique
- [ ] Vérifier Google Search Console
- [ ] Corriger erreurs d'indexation
- [ ] Tester Core Web Vitals
- [ ] Mettre à jour sitemap

### Analyse
- [ ] Analyser trafic organique
- [ ] Identifier pages performantes
- [ ] Identifier pages à améliorer
- [ ] Ajuster stratégie contenu

---

## 🎯 Résumé

**SEO = Technique (30%) + Contenu (50%) + Liens (20%)**

1. **Technique** : ✅ Fait ! Configuration optimale
2. **Contenu** : 📝 À faire régulièrement (2-4 articles/mois)
3. **Liens** : 🔗 Se construit naturellement avec du bon contenu

**La clé du succès : RÉGULARITÉ et PATIENCE** 💪

---

*Pour plus de détails, consultez :*
- [03_SEO_METADATA.md](./03_SEO_METADATA.md) - Meta tags
- [04_SEO_STRUCTURED_DATA.md](./04_SEO_STRUCTURED_DATA.md) - Données structurées
- [05_BREADCRUMBS.md](./05_BREADCRUMBS.md) - Breadcrumbs

*Dernière mise à jour : 23 Décembre 2025*

