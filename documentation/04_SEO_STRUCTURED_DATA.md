# 🏗️ SEO Structured Data - Données structurées Schema.org

## 📋 Qu'est-ce que les données structurées ?

Les données structurées (Schema.org) sont un format de code qui aide Google à mieux comprendre votre contenu et à afficher des **rich snippets** (résultats enrichis) dans les résultats de recherche.

### Avantages

✅ **Rich snippets** dans Google (étoiles, images, breadcrumbs)  
✅ **Meilleur CTR** (taux de clic amélioré)  
✅ **Featured snippets** possibles (position 0)  
✅ **Google Knowledge Graph** (panneau de connaissance)  
✅ **Voice search** optimisé (Assistant Google, Alexa)  

---

## 🗂️ Architecture actuelle

```
app/
├── helpers/
│   └── structured_data_helper.rb       # Tous les schémas
└── views/
    ├── layouts/
    │   └── _meta_tags.html.erb         # Inclusion des schémas
    └── shared/
        └── _structured_data.html.erb    # Partial réutilisable
```

---

## 📦 Helper `structured_data_helper.rb`

### Schémas implémentés

| Schéma | Type | Usage |
|--------|------|-------|
| **Organization** | `ProfessionalService` | Page d'accueil, services |
| **Website** | `WebSite` | Page d'accueil |
| **Person** | `Person` | Identité professionnelle |
| **Article** | `Article` | Pages articles |
| **CreativeWork** | `CreativeWork` | Pages projets |
| **BreadcrumbList** | `BreadcrumbList` | Navigation (auto) |

---

## 🏢 Schema Organization

**Usage** : Page d'accueil, page services

```ruby
def organization_structured_data
  {
    "@context": "https://schema.org",
    "@type": "ProfessionalService",
    "name": "Maxime Oudin - Développeur Web Indépendant",
    "description": DEFAULT_META['meta_description'],
    "url": "https://#{ENV['DOMAIN']}",
    "logo": image_url("yellow_logo.svg"),
    "image": image_url("yellow_logo.svg"),
    "telephone": "", # À compléter si souhaité
    "email": "", # À compléter si souhaité
    "address": {
      "@type": "PostalAddress",
      "addressLocality": "Bordeaux",
      "addressRegion": "Nouvelle-Aquitaine",
      "postalCode": "33000",
      "addressCountry": "FR"
    },
    "geo": {
      "@type": "GeoCoordinates",
      "latitude": 44.837789,
      "longitude": -0.57918
    },
    "areaServed": {
      "@type": "GeoCircle",
      "geoMidpoint": {
        "@type": "GeoCoordinates",
        "latitude": 44.837789,
        "longitude": -0.57918
      },
      "geoRadius": "50000"
    },
    "priceRange": "$$",
    "sameAs": [
      DEFAULT_META['linkedin_url']
    ].compact
  }.to_json.html_safe
end
```

**Utilisation** :

```erb
<%# app/views/services/index.html.erb %>
<%= render 'shared/structured_data', types: [:organization, :website] %>
```

---

## 🌐 Schema Website

**Usage** : Page d'accueil

```ruby
def website_structured_data
  {
    "@context": "https://schema.org",
    "@type": "WebSite",
    "name": DEFAULT_META['meta_product_name'],
    "description": DEFAULT_META['meta_description'],
    "url": "https://#{ENV['DOMAIN']}",
    "potentialAction": {
      "@type": "SearchAction",
      "target": "https://#{ENV['DOMAIN']}/search?q={search_term_string}",
      "query-input": "required name=search_term_string"
    },
    "inLanguage": "fr-FR",
    "author": {
      "@type": "Person",
      "name": "Maxime Oudin"
    }
  }.to_json.html_safe
end
```

---

## 👤 Schema Person

**Usage** : Page services, à propos

```ruby
def person_schema
  {
    "@context": "https://schema.org",
    "@type": "Person",
    "name": "Maxime Oudin",
    "jobTitle": "Développeur concepteur web indépendant",
    "url": "https://#{ENV['DOMAIN']}",
    "image": image_url("yellow_logo.svg"),
    "address": {
      "@type": "PostalAddress",
      "addressLocality": "Bordeaux",
      "addressCountry": "FR"
    },
    "worksFor": {
      "@type": "Organization",
      "name": "Maxime Oudin - Développeur Web Indépendant"
    },
    "knowsAbout": [
      "Ruby on Rails",
      "JavaScript",
      "Développement Web",
      "E-commerce",
      "Applications Web"
    ]
  }.to_json.html_safe
end
```

---

## 📝 Schema Article

**Usage** : Pages articles individuels

```ruby
def article_schema(article)
  {
    "@context": "https://schema.org",
    "@type": "Article",
    "headline": article.titre,
    "description": article.content.to_plain_text.truncate(160),
    "image": article.image_url,
    "datePublished": article.created_at.iso8601,
    "dateModified": article.updated_at.iso8601,
    "author": {
      "@type": "Person",
      "name": "Maxime Oudin"
    },
    "publisher": {
      "@type": "Organization",
      "name": "Maxime Oudin",
      "logo": {
        "@type": "ImageObject",
        "url": image_url("yellow_logo.svg")
      }
    },
    "mainEntityOfPage": {
      "@type": "WebPage",
      "@id": article_url(article)
    }
  }.to_json.html_safe
end
```

**Utilisation** :

```erb
<%# app/views/articles/show.html.erb %>
<script type="application/ld+json">
  <%= article_schema(@article) %>
</script>
```

---

## 🎨 Schema CreativeWork

**Usage** : Pages projets

```ruby
def projet_schema(projet)
  {
    "@context": "https://schema.org",
    "@type": "CreativeWork",
    "name": projet.titre,
    "description": projet.description,
    "image": projet.image_url,
    "dateCreated": projet.date_debut&.iso8601,
    "dateModified": projet.updated_at.iso8601,
    "author": {
      "@type": "Person",
      "name": "Maxime Oudin"
    },
    "url": projet_url(projet)
  }.to_json.html_safe
end
```

**Utilisation** :

```erb
<%# app/views/projets/show.html.erb %>
<script type="application/ld+json">
  <%= projet_schema(@projet) %>
</script>
```

---

## 🍞 Schema BreadcrumbList

**Usage** : Automatique via le helper breadcrumbs

```ruby
def breadcrumbs_structured_data(crumbs, current_url)
  {
    "@context": "https://schema.org",
    "@type": "BreadcrumbList",
    "itemListElement": crumbs.each_with_index.map do |crumb, index|
      {
        "@type": "ListItem",
        "position": index + 1,
        "name": crumb[:name],
        "item": crumb[:path].present? ? "#{request.base_url}#{crumb[:path]}" : current_url
      }
    end
  }.to_json.gsub('</', '<\/').html_safe
end
```

**Utilisation** : Automatique dans `_breadcrumbs.html.erb`

---

## 📄 Partial réutilisable

### `app/views/shared/_structured_data.html.erb`

```erb
<%# Usage : <%= render 'shared/structured_data', types: [:organization, :website] %>

<% types ||= [:organization, :website] %>

<% types.each do |type| %>
  <script type="application/ld+json">
    <%= send("#{type}_structured_data") %>
  </script>
<% end %>
```

### Exemples d'utilisation

**Page d'accueil** :
```erb
<%= render 'shared/structured_data', types: [:organization, :website] %>
```

**Page services** :
```erb
<%= render 'shared/structured_data', types: [:organization, :person] %>
```

**Page article** :
```erb
<script type="application/ld+json">
  <%= article_schema(@article) %>
</script>
```

---

## 🧪 Tests et validation

### 1. Test local

```bash
# Démarrer le serveur
rails s

# Ouvrir dans le navigateur
http://localhost:3000

# Afficher le code source (clic droit)
# Chercher "application/ld+json"
```

### 2. Rich Results Test (Google)

**URL** : https://search.google.com/test/rich-results

**Procédure** :
1. Coller l'URL de votre page
2. Cliquer sur "Test URL"
3. Vérifier les résultats :
   - ✅ "Page is eligible for rich results"
   - ✅ Types détectés (Organization, Article, etc.)
   - ❌ Erreurs ou avertissements à corriger

**URLs à tester** :
- Page d'accueil : `https://maximeoudin.fr`
- Projet : `https://maximeoudin.fr/projets/[slug]`
- Article : `https://maximeoudin.fr/articles/[slug]`

### 3. Schema Validator

**URL** : https://validator.schema.org/

**Procédure** :
1. Copier le JSON-LD depuis le code source
2. Coller dans le validateur
3. Vérifier qu'il n'y a pas d'erreurs

### 4. Commande Rails

```bash
rails seo:validate_structured_data
```

**Sortie** :
```
Pour valider vos données structurées:
1. Démarrez votre serveur: rails s
2. Visitez ces URLs dans l'outil Google:
   https://search.google.com/test/rich-results

URLs à tester:
   - Page d'accueil: https://maximeoudin.fr
   - Exemple projet: https://maximeoudin.fr/projets/shazam-api
   - Exemple article: https://maximeoudin.fr/articles/[slug]
```

---

## 🎯 Types de rich snippets possibles

### Organization

**Affichage dans Google** :
- Logo de l'entreprise
- Coordonnées (adresse, téléphone)
- Zone d'intervention
- Horaires d'ouverture (si configurés)

### Article

**Affichage dans Google** :
- Image principale
- Date de publication
- Auteur
- Breadcrumbs

### BreadcrumbList

**Affichage dans Google** :
```
maximeoudin.fr > Projets > Shazam API
```

### Person

**Affichage dans Google** :
- Photo
- Poste
- Compétences
- Organisation

---

## 🔧 Personnalisation avancée

### Ajouter des reviews (témoignages)

```ruby
def review_schema(review)
  {
    "@context": "https://schema.org",
    "@type": "Review",
    "itemReviewed": {
      "@type": "Service",
      "name": "Développement Web"
    },
    "reviewRating": {
      "@type": "Rating",
      "ratingValue": review.rating,
      "bestRating": "5"
    },
    "author": {
      "@type": "Person",
      "name": review.author_name
    },
    "reviewBody": review.content,
    "datePublished": review.created_at.iso8601
  }.to_json.html_safe
end
```

### Ajouter FAQPage

```ruby
def faq_schema(faqs)
  {
    "@context": "https://schema.org",
    "@type": "FAQPage",
    "mainEntity": faqs.map do |faq|
      {
        "@type": "Question",
        "name": faq.question,
        "acceptedAnswer": {
          "@type": "Answer",
          "text": faq.answer
        }
      }
    end
  }.to_json.html_safe
end
```

### Ajouter HowTo

```ruby
def howto_schema(title, steps)
  {
    "@context": "https://schema.org",
    "@type": "HowTo",
    "name": title,
    "step": steps.map.with_index do |step, index|
      {
        "@type": "HowToStep",
        "position": index + 1,
        "name": step[:name],
        "text": step[:text],
        "image": step[:image]
      }
    end
  }.to_json.html_safe
end
```

---

## 💡 Bonnes pratiques

### ✅ À faire

- Utiliser des données **réelles et précises**
- Tester **toutes les pages** avec Rich Results Test
- Garder les schémas **à jour** (dates, contenus)
- Utiliser le **type le plus spécifique** possible
- Inclure des **images de qualité**
- Ajouter des **propriétés optionnelles** pertinentes

### ❌ À éviter

- Données **fausses ou trompeuses**
- **Spam de mots-clés** dans les descriptions
- Utiliser Schema.org pour **cacher du contenu**
- **Dupliquer** le même schéma plusieurs fois
- Oublier de **valider** après modifications

---

## 📊 Impact sur le SEO

### Direct

**Impact** : ⭐⭐⭐⭐ (Élevé)
- N'améliore PAS le ranking directement
- Mais améliore fortement le **CTR** (taux de clic)
- CTR amélioré = **meilleur ranking indirect**

### Rich Snippets

**Augmentation CTR moyenne** : +20 à +30%

**Exemple** :
```
Sans rich snippet : 100 impressions → 3 clics (CTR 3%)
Avec rich snippet  : 100 impressions → 5 clics (CTR 5%)
```

### Featured Snippets

**Position 0** dans Google :
- Peut générer jusqu'à **50% du trafic** d'une requête
- Nécessite Schema.org + contenu de qualité
- Formats : FAQ, HowTo, définitions

---

## 🐛 Dépannage

### Erreur "undefined method 'organization_structured_data'"

**Cause** : Le serveur n'a pas chargé les nouveaux helpers

**Solution** :
```bash
# Redémarrer le serveur Rails
# Ctrl+C puis :
rails s
```

### Les données n'apparaissent pas dans le code source

**Vérification** :
```bash
# Dans la console Rails
rails console

# Tester le helper
helper.organization_structured_data
# Doit retourner du JSON

# Vérifier ENV
ENV['DOMAIN']
# Doit retourner votre domaine
```

### Google ne détecte pas les données

**Causes possibles** :
1. JavaScript bloque le rendu (pas notre cas avec ERB)
2. Erreur de syntaxe JSON
3. Schema non valide
4. Page non indexée

**Solutions** :
1. Valider avec Schema Validator
2. Vérifier dans Rich Results Test
3. Attendre quelques jours (indexation Google)

---

## ✅ Checklist

### Par page

- [ ] Au moins un schéma présent
- [ ] JSON-LD validé (pas d'erreurs)
- [ ] Données précises et à jour
- [ ] Images avec URLs absolues
- [ ] Dates au format ISO8601
- [ ] URLs complètes (pas relatives)

### Globalement

- [ ] Organization sur page d'accueil
- [ ] Article sur chaque article
- [ ] CreativeWork sur chaque projet
- [ ] BreadcrumbList automatique
- [ ] Tous les schémas testés avec Google

---

## 🎯 Résumé

**Format** : JSON-LD (recommandé par Google)

**Priorités** :
1. ✅ Organization (page d'accueil)
2. ✅ Article (pages articles)
3. ✅ CreativeWork (pages projets)
4. ✅ BreadcrumbList (automatique)
5. 📝 FAQPage (à ajouter si FAQ)
6. 📝 Review (si témoignages)

**Tests essentiels** :
- Rich Results Test Google
- Schema.org Validator
- Test visuel dans les SERPs

---

*Pour compléter, voir aussi :*
- [02_SEO_GENERAL.md](./02_SEO_GENERAL.md) - Vue d'ensemble
- [03_SEO_METADATA.md](./03_SEO_METADATA.md) - Meta tags
- [05_BREADCRUMBS.md](./05_BREADCRUMBS.md) - Breadcrumbs

*Dernière mise à jour : 23 Décembre 2025*

