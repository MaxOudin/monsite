# Guide d'optimisation SEO - Maxime Oudin Portfolio

## ✅ Améliorations déjà implémentées

### 1. Données structurées (Schema.org)
- ✅ Schema Person pour la page d'accueil
- ✅ Schema Article pour les articles
- ✅ Schema CreativeWork pour les projets
- ✅ Breadcrumb pour la navigation

### 2. Meta tags optimisés
- ✅ Open Graph (Facebook)
- ✅ Twitter Cards
- ✅ Meta description et keywords
- ✅ Canonical URLs

### 3. Sitemap XML
- ✅ Sitemap généré automatiquement
- ✅ Priorités adaptées par type de contenu
- ✅ Images incluses dans le sitemap

### 4. URLs optimisées
- ✅ FriendlyId pour des URLs lisibles
- ✅ Slugs optimisés sans accents

## 🎯 Recommandations supplémentaires

### 1. Performance & Core Web Vitals

#### a) Optimiser les images
```ruby
# Dans app/models/projet.rb et article.rb
def optimized_image
  return unless image.attached?
  image.variant(resize_to_limit: [1200, 800], quality: 85)
end
```

#### b) Ajouter le lazy loading
```erb
<!-- Dans les vues -->
<img src="<%= @projet.image_url %>" 
     alt="<%= @projet.image_alt %>" 
     loading="lazy" 
     width="1200" 
     height="800">
```

#### c) Précharger les ressources critiques
```erb
<!-- Dans app/views/layouts/application.html.erb -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="dns-prefetch" href="https://tally.so">
```

### 2. Contenu & Sémantique

#### a) Ajouter un fil d'Ariane (Breadcrumb)
Créer un partial `shared/_breadcrumb.html.erb` :
```erb
<nav aria-label="Breadcrumb" class="breadcrumb">
  <ol>
    <li><a href="<%= root_path %>">Accueil</a></li>
    <% if @breadcrumb_items %>
      <% @breadcrumb_items.each do |item| %>
        <li><%= link_to_if item[:url], item[:name], item[:url] %></li>
      <% end %>
    <% end %>
  </ol>
</nav>
```

#### b) Optimiser les balises heading
- **Une seule H1 par page** : ✅ Déjà fait
- Utiliser H2, H3 de manière hiérarchique : ✅ Déjà fait
- Inclure des mots-clés pertinents dans les titres

#### c) Ajouter du contenu riche
- Créer une page "À propos" avec votre parcours
- Ajouter des témoignages clients (avec Schema.org Review)
- Créer une FAQ avec Schema.org FAQPage

### 3. Liens internes

#### a) Ajouter des articles liés
Dans `app/models/article.rb` :
```ruby
def related_articles(limit = 3)
  Article.where(theme: theme)
         .where.not(id: id)
         .limit(limit)
end
```

#### b) Créer une section "Projets similaires"
Dans `app/models/projet.rb` :
```ruby
def similar_projects(limit = 3)
  Projet.joins(:outils)
        .where(outils: { id: outil_ids })
        .where.not(id: id)
        .distinct
        .limit(limit)
end
```

### 4. SEO Local (Bordeaux)

#### a) Ajouter LocalBusiness Schema
```ruby
# Dans app/helpers/structured_data_helper.rb
def local_business_schema
  {
    "@context": "https://schema.org",
    "@type": "ProfessionalService",
    "name": "Maxime Oudin - Développeur Web",
    "image": image_url("yellow_logo.svg"),
    "@id": "https://#{ENV['DOMAIN']}",
    "url": "https://#{ENV['DOMAIN']}",
    "telephone": "+33-X-XX-XX-XX-XX", # À ajouter
    "priceRange": "$$",
    "address": {
      "@type": "PostalAddress",
      "streetAddress": "À compléter",
      "addressLocality": "Bordeaux",
      "postalCode": "33000",
      "addressCountry": "FR"
    },
    "geo": {
      "@type": "GeoCoordinates",
      "latitude": 44.837789,
      "longitude": -0.57918
    },
    "openingHoursSpecification": {
      "@type": "OpeningHoursSpecification",
      "dayOfWeek": [
        "Monday",
        "Tuesday",
        "Wednesday",
        "Thursday",
        "Friday"
      ],
      "opens": "09:00",
      "closes": "18:00"
    },
    "sameAs": [
      "https://www.linkedin.com/in/maxime-oudin", # À compléter
      "https://github.com/MaxOudin" # À compléter
    ]
  }.to_json.html_safe
end
```

### 5. Contenu technique

#### a) Créer un blog technique régulier
- **Fréquence recommandée** : 2-4 articles par mois
- **Sujets à aborder** :
  - Tutoriels Rails
  - Best practices JavaScript
  - Retours d'expérience sur des projets
  - Performances web
  - Sécurité web

#### b) Optimiser les descriptions de projets
- Minimum 300 mots par projet
- Inclure des mots-clés techniques
- Décrire les défis et solutions
- Ajouter des résultats mesurables

### 6. Réseaux sociaux

#### a) Ajouter des boutons de partage
```erb
<!-- shared/_social_share.html.erb -->
<div class="social-share">
  <a href="https://twitter.com/intent/tweet?text=<%= @article.titre %>&url=<%= article_url(@article) %>" 
     target="_blank" 
     rel="noopener">
    Partager sur Twitter
  </a>
  <a href="https://www.linkedin.com/sharing/share-offsite/?url=<%= article_url(@article) %>" 
     target="_blank" 
     rel="noopener">
    Partager sur LinkedIn
  </a>
</div>
```

### 7. Configuration Production

#### a) Ajouter les headers de sécurité
Dans `config/environments/production.rb` :
```ruby
# Headers de sécurité pour le SEO
config.action_dispatch.default_headers = {
  'X-Frame-Options' => 'SAMEORIGIN',
  'X-Content-Type-Options' => 'nosniff',
  'X-XSS-Protection' => '1; mode=block',
  'Referrer-Policy' => 'strict-origin-when-cross-origin'
}
```

#### b) Activer la compression
```ruby
config.middleware.use Rack::Deflater
```

#### c) Configurer le cache
```ruby
config.public_file_server.headers = {
  'Cache-Control' => 'public, max-age=31536000'
}
```

### 8. Monitoring & Analytics

#### a) Google Search Console
- Soumettre le sitemap
- Surveiller les erreurs d'indexation
- Analyser les requêtes de recherche

#### b) Google Analytics 4
- Suivre les pages vues
- Analyser le comportement utilisateur
- Mesurer les conversions (formulaire de contact)

#### c) PageSpeed Insights
- Tester régulièrement les performances
- Objectif : Score > 90 sur mobile et desktop

### 9. Checklist pré-publication d'un article/projet

- [ ] Titre optimisé (50-60 caractères)
- [ ] Meta description unique (150-160 caractères)
- [ ] URL lisible et descriptive
- [ ] Au moins une image optimisée avec alt text
- [ ] Liens internes vers d'autres contenus
- [ ] Contenu > 300 mots
- [ ] Structure H2/H3 logique
- [ ] Appel à l'action clair

### 10. Outils recommandés

#### Validation
- **Google Search Console** : https://search.google.com/search-console
- **Rich Results Test** : https://search.google.com/test/rich-results
- **Schema Validator** : https://validator.schema.org/
- **Meta Tags Validator** : https://metatags.io/

#### Analyse
- **Lighthouse** (Chrome DevTools)
- **GTmetrix** : https://gtmetrix.com/
- **WebPageTest** : https://www.webpagetest.org/
- **Ahrefs** ou **SEMrush** pour l'analyse concurrentielle

#### SEO Local
- **Google My Business** (essentiel pour Bordeaux)
- **Bing Places**

## 📈 KPIs à suivre

1. **Trafic organique** : Évolution mensuelle
2. **Position moyenne** : Pour vos mots-clés cibles
3. **Taux de clic (CTR)** : Dans les résultats de recherche
4. **Taux de rebond** : Objectif < 50%
5. **Temps sur la page** : Indicateur d'engagement
6. **Pages indexées** : Toutes vos pages importantes

## 🎯 Mots-clés cibles recommandés

### Primaires
- développeur web bordeaux
- développeur web indépendant bordeaux
- freelance développeur bordeaux

### Secondaires
- création site internet bordeaux
- développeur ruby on rails bordeaux
- développeur javascript bordeaux
- développeur react bordeaux

### Longue traîne
- développeur web freelance spécialisé e-commerce bordeaux
- créateur application web bordeaux
- développeur saas bordeaux
- développeur crm sur mesure bordeaux

## 🚀 Plan d'action prioritaire

### Semaine 1
1. ✅ Implémenter les données structurées (fait)
2. ✅ Optimiser les meta tags (fait)
3. Ajouter lazy loading aux images
4. Créer une page "À propos"

### Semaine 2
5. Optimiser les images (compression, formats WebP)
6. Ajouter des liens internes entre articles/projets
7. Créer le fil d'Ariane visuel
8. S'inscrire à Google Search Console

### Semaine 3-4
9. Créer 2-3 articles de blog de qualité
10. Enrichir les descriptions de projets
11. Ajouter Google Analytics
12. Créer une fiche Google My Business

### Mensuel
- Publier 2-4 articles de blog
- Analyser les performances SEO
- Ajuster la stratégie de contenu
- Nettoyer les erreurs d'indexation

## 📚 Ressources utiles

- [Guide Google SEO](https://developers.google.com/search/docs)
- [Schema.org Documentation](https://schema.org/)
- [Web.dev - Learn Performance](https://web.dev/learn/)
- [Moz Beginner's Guide to SEO](https://moz.com/beginners-guide-to-seo)

