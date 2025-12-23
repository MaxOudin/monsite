# 🏷️ SEO Metadata - Meta tags et Open Graph

## 📋 Vue d'ensemble

Les meta tags sont essentiels pour :
- ✅ Apparence dans les résultats Google
- ✅ Partage sur réseaux sociaux (Facebook, Twitter, LinkedIn)
- ✅ Amélioration du taux de clic (CTR)
- ✅ Éviter le contenu dupliqué (canonical)

---

## 🗂️ Architecture actuelle

```
app/
├── helpers/
│   └── meta_tags_helper.rb          # Logique meta tags
├── views/
│   └── layouts/
│       ├── _head.html.erb           # Organisation <head>
│       └── _meta_tags.html.erb      # Tous les meta tags
config/
└── meta.yml                         # Configuration par défaut
```

---

## ⚙️ Configuration par défaut

### Fichier `config/meta.yml`

```yaml
meta_product_name: "Maxime Oudin"
meta_title: "Développeur concepteur web indépendant à Bordeaux"
meta_description: "Développeur web indépendant à Bordeaux et Paris. Spécialisé dans la création de sites vitrine, e-commerce, CRM, SaaS, et applications web. Expertise Ruby on Rails."
meta_image: "yellow_logo.svg"
meta_keywords: "développeur web bordeaux, développeur web indépendant, création site internet bordeaux, ruby on rails, application web"

og_type: "website"
og_url: "https://maximeoudin.fr"
og_description: "Développeur web indépendant à Bordeaux et Paris..."
og_site_name: "Développeur concepteur web indépendant à Bordeaux"
og_locale: "fr_FR"

# Vérification Google Search Console
google_site_verification: ""

# Réseaux sociaux
linkedin_url: "https://www.linkedin.com/in/maxime-oudin-developer/"
```

---

## 🎯 Helper `meta_tags_helper.rb`

### Méthodes disponibles

```ruby
# app/helpers/meta_tags_helper.rb

# Title SEO
def meta_title
  content_for?(:meta_title) ? content_for(:meta_title) : DEFAULT_META["meta_title"]
end

# Description SEO
def meta_description
  content_for?(:meta_description) ? content_for(:meta_description) : DEFAULT_META["meta_description"]
end

# Image avec fallback sur yellow_logo.svg
def meta_image
  meta_image = content_for?(:meta_image) ? content_for(:meta_image) : DEFAULT_META["meta_image"]
  
  # Protection contre images invalides
  if meta_image.blank? || !valid_image?(meta_image)
    meta_image = DEFAULT_META["meta_image"]
  end
  
  meta_image.starts_with?("http") ? meta_image : image_url(meta_image)
rescue Sprockets::Rails::Helper::AssetNotFound
  image_url(DEFAULT_META["meta_image"])
end

# URL Canonique (évite contenu dupliqué)
def meta_canonical_url
  if content_for?(:canonical_url)
    content_for(:canonical_url)
  else
    url_for(only_path: false, params: request.query_parameters.except(*ignored_query_params))
  end
end

# Keywords (optionnel)
def meta_keywords
  content_for?(:meta_keywords) ? content_for(:meta_keywords) : DEFAULT_META["meta_keywords"]
end
```

---

## 📄 Layout `_meta_tags.html.erb`

### Structure complète

```erb
<!-- Title -->
<title><%= meta_title %></title>

<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">

<!-- Meta Tags de base -->
<meta name="author" content="Maxime Oudin">
<meta name="robots" content="index, follow">
<meta name="description" content="<%= meta_description %>">

<% if meta_keywords.present? %>
  <meta name="keywords" content="<%= meta_keywords %>">
<% end %>

<!-- Vérifications moteurs de recherche -->
<% if DEFAULT_META['google_site_verification'].present? %>
  <meta name="google-site-verification" content="<%= DEFAULT_META['google_site_verification'] %>">
<% end %>

<!-- URL Canonique -->
<link rel="canonical" href="<%= meta_canonical_url %>">

<!-- Google Dublin Core -->
<meta name="dc.title" content="<%= meta_title %>">
<meta name="dc.description" content="<%= meta_description %>">
<meta name="dc.relation" content="https://<%= ENV['DOMAIN'] %>">
<meta name="dc.source" content="https://<%= ENV['DOMAIN'] %>">
<meta name="dc.language" content="fr">

<!-- Facebook Open Graph -->
<meta property="og:title" content="<%= meta_title %>" />
<meta property="og:type" content="website" />
<meta property="og:url" content="<%= request.original_url %>" />
<meta property="og:image" content="<%= meta_image %>" />
<meta property="og:image:width" content="1200" />
<meta property="og:image:height" content="630" />
<meta property="og:description" content="<%= meta_description %>" />
<meta property="og:site_name" content="<%= DEFAULT_META['meta_product_name'] %>" />
<meta property="og:locale" content="fr_FR" />

<!-- Twitter Cards -->
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:site" content="@maximeoudin">
<meta name="twitter:creator" content="@maximeoudin">
<meta name="twitter:title" content="<%= meta_title %>">
<meta name="twitter:description" content="<%= meta_description %>">
<meta name="twitter:image" content="<%= meta_image %>">
<meta name="twitter:image:alt" content="<%= meta_title %>">

<!-- Favicons -->
<%= favicon_link_tag 'yellow_logo.svg', rel: 'icon', type: 'image/svg' %>
<%= favicon_link_tag 'yellow_logo.svg', rel: 'apple-touch-icon', type: 'image/svg', sizes: '180x180' %>
```

---

## 📝 Utilisation dans les vues

### Page d'accueil

```erb
<%# app/views/services/index.html.erb %>

<% content_for :meta_title, "Développeur Web Bordeaux | Maxime Oudin" %>
<% content_for :meta_description, "Créateur de sites web et applications sur mesure à Bordeaux. Ruby on Rails, JavaScript, React. Devis gratuit." %>
<% content_for :meta_image, image_url("home_hero.jpg") %>
<% content_for :meta_keywords, "développeur web bordeaux, freelance bordeaux, création site web" %>

<!-- Contenu de la page -->
```

### Page Projet

```erb
<%# app/views/projets/show.html.erb %>

<% content_for :meta_title, "#{@projet.titre} | #{DEFAULT_META["meta_product_name"]}" %>
<% content_for :meta_description, @projet.description.truncate(160) %>
<% content_for :meta_image, @projet.image_url if @projet.image_url.present? %>

<!-- Contenu du projet -->
```

### Page Article

```erb
<%# app/views/articles/show.html.erb %>

<% content_for :meta_title, "#{@article.titre} | #{DEFAULT_META["meta_product_name"]}" %>
<% description = @article.content.to_plain_text.truncate(160) rescue @article.titre %>
<% content_for :meta_description, description %>
<% content_for :meta_image, @article.image_url if @article.image_url.present? %>

<!-- Contenu de l'article -->
```

---

## 🎯 Bonnes pratiques

### Title (balise `<title>`)

**Longueur idéale** : 50-60 caractères

**Format recommandé** :
```
[Mot-clé principal] | [Nom] - [Localisation]
```

**Exemples** :
```
✅ "Développeur Web Ruby on Rails | Maxime Oudin - Bordeaux"
✅ "Création Site E-commerce | Freelance Bordeaux"
❌ "Bienvenue sur mon site" (trop vague)
❌ "Développeur web freelance indépendant spécialisé en Ruby on Rails..." (trop long)
```

### Meta Description

**Longueur idéale** : 120-160 caractères

**Format recommandé** :
```
[Service] + [Bénéfice] + [Localisation] + [CTA]
```

**Exemples** :
```
✅ "Développeur web freelance à Bordeaux. Création de sites performants et applications sur mesure. Devis gratuit sous 24h."

❌ "Je suis développeur" (trop court)
❌ "Développeur web spécialisé dans la création de sites internet, applications web, e-commerce, CRM et SaaS..." (trop long, coupé)
```

### Meta Keywords

⚠️ **Peu utilisé par Google**, mais peut aider d'autres moteurs.

**Format** : 5-10 mots-clés maximum, séparés par des virgules

```erb
<meta name="keywords" content="développeur web bordeaux, freelance bordeaux, ruby on rails, création site web">
```

### URL Canonique

**But** : Éviter le contenu dupliqué

```erb
<!-- Spécifier l'URL canonique -->
<link rel="canonical" href="https://maximeoudin.fr/projets/mon-projet">
```

**Le helper supprime automatiquement** :
- Paramètres UTM (`utm_source`, `utm_medium`, etc.)
- Paramètres de tracking (`fbclid`, `gclid`, etc.)
- Paramètres analytics (`_ga`, `_gl`)

---

## 📱 Open Graph (Facebook)

### Balises essentielles

```html
<meta property="og:title" content="Votre titre">
<meta property="og:type" content="website">
<meta property="og:url" content="https://maximeoudin.fr/page">
<meta property="og:image" content="https://maximeoudin.fr/image.jpg">
<meta property="og:description" content="Description">
<meta property="og:site_name" content="Maxime Oudin">
<meta property="og:locale" content="fr_FR">
```

### Image Open Graph

**Dimensions recommandées** : 1200 x 630 pixels

**Format** :
- JPEG ou PNG
- Poids < 300KB
- Ratio 1.91:1

**Création** :
```ruby
# Pour créer une image OG dédiée
# app/views/layouts/_meta_tags.html.erb
<meta property="og:image" content="<%= image_url('og_image_1200x630.jpg') %>">
<meta property="og:image:width" content="1200">
<meta property="og:image:height" content="630">
```

### Test Open Graph

**Facebook Debugger** : https://developers.facebook.com/tools/debug/

1. Coller votre URL
2. Cliquer sur "Scrape Again"
3. Vérifier l'aperçu

---

## 🐦 Twitter Cards

### Type "summary_large_image"

```html
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:site" content="@maximeoudin">
<meta name="twitter:creator" content="@maximeoudin">
<meta name="twitter:title" content="Votre titre">
<meta name="twitter:description" content="Description">
<meta name="twitter:image" content="https://...">
<meta name="twitter:image:alt" content="Description de l'image">
```

### Types de cards

| Type | Usage | Image |
|------|-------|-------|
| **summary** | Contenu générique | 144x144 (carré) |
| **summary_large_image** | Article, projet | 1200x630 |
| **app** | Application mobile | Variable |
| **player** | Vidéo | 1200x630 |

### Test Twitter Card

**Card Validator** : https://cards-dev.twitter.com/validator

---

## 🖼️ Gestion des images

### Image par défaut

Si aucune image n'est fournie, le helper utilise automatiquement `yellow_logo.svg` :

```ruby
def meta_image
  meta_image = content_for?(:meta_image) ? content_for(:meta_image) : DEFAULT_META["meta_image"]
  
  # Protection contre images invalides
  if meta_image.blank? || !valid_image?(meta_image)
    meta_image = DEFAULT_META["meta_image"]  # yellow_logo.svg
  end
  
  meta_image.starts_with?("http") ? meta_image : image_url(meta_image)
rescue Sprockets::Rails::Helper::AssetNotFound
  image_url(DEFAULT_META["meta_image"])  # Fallback
end
```

### Images valides

**Formats acceptés** :
- URLs HTTP/HTTPS complètes
- Assets locaux (ex: `"logo.png"`, `"images/banner.jpg"`)

**Format invalide** :
- Caractères spéciaux (ex: `"uuu"`, `"@#$%"`)
- Noms de fichiers inexistants

---

## ✅ Checklist par page

### Chaque page doit avoir :

- [ ] **Title unique** (50-60 caractères)
- [ ] **Meta description unique** (120-160 caractères)
- [ ] **URL canonique**
- [ ] **Image optimisée** (1200x630 pour OG/Twitter)
- [ ] **Alt text sur l'image**
- [ ] **Mots-clés pertinents** (dans title et description)

### Vérifier :

```bash
# Afficher le code source
curl https://maximeoudin.fr/projets/mon-projet | grep -E "(title|description|og:|twitter:)"
```

---

## 🧪 Tests et validation

### 1. Test manuel

1. **Ouvrir la page** dans le navigateur
2. **Clic droit** > "Afficher le code source"
3. **Chercher** les balises meta dans le `<head>`
4. **Vérifier** que toutes les valeurs sont correctes

### 2. Outils de validation

| Outil | URL | Usage |
|-------|-----|-------|
| **Meta Tags Preview** | https://metatags.io/ | Aperçu Google/FB/Twitter |
| **Facebook Debugger** | https://developers.facebook.com/tools/debug/ | Test Open Graph |
| **Twitter Validator** | https://cards-dev.twitter.com/validator | Test Twitter Cards |
| **Lighthouse** | Chrome DevTools | Score SEO général |

### 3. Commande Rails

```bash
# Vérifier tous les meta tags
rails seo:check_meta_tags
```

**Sortie attendue** :
```
Meta tags par défaut:
  Title:       Développeur concepteur web... (45 caractères)
  Description: Développeur web indépendant à Bordeaux... (155 caractères)
  Keywords:    développeur web bordeaux, freelance...

Projets (échantillon):
  Mon Projet:
    Title: Mon Projet | Maxime Oudin (28 caractères)
    Desc:  Description du projet... (148 caractères)
    Image: ✅
    Alt:   ✅
```

---

## 🔧 Personnalisation avancée

### Meta tags spécifiques par controller

```ruby
# app/controllers/projets_controller.rb

def show
  @projet = Projet.friendly.find(params[:id])
  
  # Meta tags personnalisés
  @meta_title = "#{@projet.titre} - Projet #{@projet.type_projet}"
  @meta_description = "Découvrez #{@projet.titre}, un projet #{@projet.type_projet} réalisé avec #{@projet.outils.pluck(:nom).join(', ')}"
  @meta_keywords = [@projet.type_projet, @projet.outils.pluck(:nom), "bordeaux"].flatten.join(", ")
end
```

### Image OpenGraph dynamique

Pour générer une image OG unique par article/projet :

```ruby
# Utiliser un service comme Cloudinary, Imgix ou générer avec ImageMagick
def og_image_for(article)
  "https://res.cloudinary.com/#{account}/image/upload/l_text:Arial_60:#{CGI.escape(article.titre)}/og_template.jpg"
end
```

---

## 📊 Impact sur le SEO

### Title

**Impact** : ⭐⭐⭐⭐⭐ (Très élevé)
- Facteur de ranking principal
- Affecte directement le CTR
- Première chose vue dans les résultats

### Meta Description

**Impact** : ⭐⭐⭐⭐ (Élevé)
- N'affecte PAS le ranking directement
- Améliore le CTR (donc ranking indirect)
- Importante pour l'UX

### Open Graph / Twitter

**Impact** : ⭐⭐⭐ (Moyen)
- Pas d'impact ranking direct
- Améliore partages sociaux
- Génère du trafic référent

### Canonical

**Impact** : ⭐⭐⭐⭐⭐ (Très élevé)
- Évite pénalités contenu dupliqué
- Consolide le ranking sur une seule URL
- Essentiel pour pagination, filtres, etc.

---

## 🎯 Résumé

**Priorités** :
1. ✅ Title unique et optimisé (50-60 car.)
2. ✅ Meta description vendeuse (120-160 car.)
3. ✅ URL canonique configurée
4. ✅ Open Graph pour les partages sociaux
5. ✅ Image par défaut en fallback

**Commandes utiles** :
```bash
rails seo:check_meta_tags    # Vérifier tous les meta tags
rails seo:check              # Vérification complète
```

---

*Pour compléter, voir aussi :*
- [02_SEO_GENERAL.md](./02_SEO_GENERAL.md) - Vue d'ensemble
- [04_SEO_STRUCTURED_DATA.md](./04_SEO_STRUCTURED_DATA.md) - Données structurées
- [05_BREADCRUMBS.md](./05_BREADCRUMBS.md) - Breadcrumbs

*Dernière mise à jour : 23 Décembre 2025*

