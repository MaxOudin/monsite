# 🍞 Breadcrumbs - Fil d'Ariane SEO

## 📋 Qu'est-ce qu'un breadcrumb ?

Le breadcrumb (fil d'Ariane) est un élément de navigation qui indique la position de l'utilisateur dans la hiérarchie du site.

### Avantages

✅ **UX améliorée** : Navigation facilitée  
✅ **SEO boosté** : Google affiche les breadcrumbs dans les résultats  
✅ **Taux de rebond réduit** : L'utilisateur explore plus de pages  
✅ **Données structurées** : BreadcrumbList Schema.org intégré  
✅ **Mobile-friendly** : Version responsive automatique  

---

## 🗂️ Architecture

```
app/
├── helpers/
│   └── breadcrumbs_helper.rb           # Logique breadcrumbs
├── views/
│   └── shared/
│       └── _breadcrumbs.html.erb       # Template HTML
└── assets/stylesheets/components/
    └── _breadcrumbs.scss               # Styles CSS
```

---

## 🎨 Affichage actuel

### Desktop (≥ 768px)
```
🏠 Accueil > Projets > Shazam API
```

### Mobile (< 768px)
```
← Projets
```

---

## 📝 Helper `breadcrumbs_helper.rb`

### Méthodes disponibles

```ruby
# app/helpers/breadcrumbs_helper.rb

# Génère automatiquement les breadcrumbs
def breadcrumbs(custom_crumbs: nil)
  return custom_crumbs if custom_crumbs.present?

  crumbs = [home_crumb]

  case controller_name
  when 'projets'
    crumbs += projet_breadcrumbs if action_name == 'show'
  when 'articles'
    crumbs += article_breadcrumbs if action_name == 'show'
  end
  crumbs
end

# Affiche le fil d'ariane
def render_breadcrumbs(custom_crumbs: nil)
  render partial: 'shared/breadcrumbs', 
         locals: { crumbs: breadcrumbs(custom_crumbs: custom_crumbs) }
end

# Génère les données structurées JSON-LD
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

### Méthodes privées

```ruby
private

def home_crumb
  { name: "Accueil", path: root_path, is_home: true }
end

def projet_breadcrumbs
  return [] unless @projet

  [
    { name: "Projets", path: projets_path },
    { name: @projet.titre, path: nil }  # nil = page actuelle (pas de lien)
  ]   
end

def article_breadcrumbs
  return [] unless @article

  [
    { name: "Articles", path: articles_path },
    { name: @article.titre, path: nil }
  ]
end
```

---

## 🖼️ Vue `_breadcrumbs.html.erb`

### Structure HTML

```erb
<% if crumbs.present? %>
  <nav aria-label="Fil d'ariane" class="breadcrumbs-nav" data-controller="breadcrumbs">
    <!-- VERSION DESKTOP -->
    <div class="breadcrumbs-desktop">
      <% crumbs.each_with_index do |crumb, index| %>
        <!-- Séparateur chevron -->
        <% if index > 0 %>
          <i class="fas fa-chevron-right breadcrumbs-separator" aria-hidden="true"></i>
        <% end %>

        <!-- Lien Accueil avec icône -->
        <% if index == 0 && crumb[:is_home] && crumb[:path].present? %>
          <%= link_to crumb[:path], class: "breadcrumbs-link breadcrumbs-home" do %>
            <i class="fas fa-home" aria-hidden="true"></i>
            <span><%= crumb[:name] %></span>
          <% end %>
        
        <!-- Lien intermédiaire -->
        <% elsif crumb[:path].present? %>
          <%= link_to crumb[:name], crumb[:path], class: "breadcrumbs-link" %>
        
        <!-- Page actuelle (pas de lien) -->
        <% else %>
          <span class="breadcrumbs-current" aria-current="page">
            <%= crumb[:name] %>
          </span>
        <% end %>
      <% end %>
    </div>

    <!-- Données structurées JSON-LD -->
    <script type="application/ld+json">
      <%= breadcrumbs_structured_data(crumbs, request.original_url) %>
    </script>

    <!-- VERSION MOBILE -->
    <% if crumbs.length > 1 %>
      <% parent = crumbs[-2] %>  <!-- Avant-dernier élément -->
      <% if parent && parent[:path].present? %>
        <div class="breadcrumbs-mobile">
          <%= link_to parent[:path], class: "breadcrumbs-back-link" do %>
            <i class="fas fa-arrow-left" aria-hidden="true"></i>
            <span><%= parent[:name] %></span>
          <% end %>
        </div>
      <% end %>
    <% end %>
  </nav>
<% end %>
```

---

## 🎨 Styles `_breadcrumbs.scss`

### Structure CSS

```scss
// Navigation container
.breadcrumbs-nav {
  margin-bottom: 1.5rem;
}

// VERSION DESKTOP (≥ 768px)
.breadcrumbs-desktop {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: 0.5rem;
  font-size: 0.875rem;
  color: #6b7280;

  @media (max-width: 767px) {
    display: none;  // Masqué sur mobile
  }
}

// Séparateur chevron
.breadcrumbs-separator {
  font-size: 0.75rem;
  color: #9ca3af;
  margin: 0 0.25rem;
}

// Lien accueil avec icône
.breadcrumbs-home {
  display: inline-flex;
  align-items: center;
  gap: 0.25rem;
}

// Liens cliquables
.breadcrumbs-link {
  color: #6b7280;
  font-weight: 500;
  text-decoration: none;
  transition: color 0.2s ease;

  &:hover {
    color: #003399;
    text-decoration: underline;
  }
}

// Page actuelle (non cliquable)
.breadcrumbs-current {
  color: #003399;
  font-weight: 600;
}

// VERSION MOBILE (< 768px)
.breadcrumbs-mobile {
  display: none;

  @media (max-width: 767px) {
    display: block;  // Affiché sur mobile
  }
}

.breadcrumbs-back-link {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  font-size: 0.875rem;
  color: #6b7280;
  font-weight: 500;
  text-decoration: none;

  &:hover {
    color: #003399;
  }
}
```

---

## 🚀 Utilisation dans les vues

### Automatique (recommandé)

```erb
<%# app/views/projets/show.html.erb %>

<div class="show-container">
  <%= render_breadcrumbs %>  <%# Génère automatiquement %>
  
  <!-- Contenu de la page -->
</div>
```

**Résultat** :
```
🏠 Accueil > Projets > Nom du projet
```

### Personnalisé

```erb
<%# app/views/pages/custom.html.erb %>

<% custom_crumbs = [
  { name: "Accueil", path: root_path, is_home: true },
  { name: "Services", path: services_path },
  { name: "Web Design", path: nil }
] %>

<%= render_breadcrumbs(custom_crumbs: custom_crumbs) %>
```

**Résultat** :
```
🏠 Accueil > Services > Web Design
```

---

## 📊 Données structurées intégrées

### JSON-LD généré automatiquement

Pour un projet "Shazam API" :

```json
{
  "@context": "https://schema.org",
  "@type": "BreadcrumbList",
  "itemListElement": [
    {
      "@type": "ListItem",
      "position": 1,
      "name": "Accueil",
      "item": "https://maximeoudin.fr/"
    },
    {
      "@type": "ListItem",
      "position": 2,
      "name": "Projets",
      "item": "https://maximeoudin.fr/projets"
    },
    {
      "@type": "ListItem",
      "position": 3,
      "name": "Shazam API",
      "item": "https://maximeoudin.fr/projets/shazam-api"
    }
  ]
}
```

### Affichage dans Google

```
maximeoudin.fr > Projets > Shazam API
```

---

## 🎯 Personnalisation

### Ajouter un nouveau controller

```ruby
# app/helpers/breadcrumbs_helper.rb

def breadcrumbs(custom_crumbs: nil)
  return custom_crumbs if custom_crumbs.present?

  crumbs = [home_crumb]

  case controller_name
  when 'projets'
    crumbs += projet_breadcrumbs if action_name == 'show'
  when 'articles'
    crumbs += article_breadcrumbs if action_name == 'show'
  when 'services'  # NOUVEAU
    crumbs += service_breadcrumbs if action_name == 'show'
  end
  crumbs
end

private

def service_breadcrumbs
  return [] unless @service

  [
    { name: "Services", path: services_path },
    { name: @service.titre, path: nil }
  ]
end
```

### Changer les couleurs

```scss
// app/assets/stylesheets/components/_breadcrumbs.scss

.breadcrumbs-link {
  color: #6b7280;  // Gris par défaut
  
  &:hover {
    color: #FF5733;  // VOTRE COULEUR au hover
  }
}

.breadcrumbs-current {
  color: #FF5733;  // VOTRE COULEUR pour page actuelle
}
```

### Changer les icônes

```erb
<!-- app/views/shared/_breadcrumbs.html.erb -->

<!-- Chevron → Slash -->
<i class="fas fa-slash breadcrumbs-separator"></i>

<!-- Maison → Logo personnalisé -->
<img src="<%= image_path('logo_mini.svg') %>" alt="Home">
```

---

## 🧪 Tests et validation

### 1. Test visuel

```bash
rails s
# Ouvrir : http://localhost:3000/projets/[slug]
```

**Vérifier** :
- ✅ Desktop : chemin complet affiché
- ✅ Mobile : bouton retour affiché
- ✅ Hover : couleur change
- ✅ Liens fonctionnels

### 2. Rich Results Test

**URL** : https://search.google.com/test/rich-results

**Procédure** :
1. Tester une page projet/article
2. Vérifier "BreadcrumbList" détecté
3. Vérifier la hiérarchie affichée

### 3. Responsive test

```bash
# Chrome DevTools (F12)
# > Toggle device toolbar (Ctrl+Shift+M)
# Tester différentes largeurs :
# - 375px (iPhone)
# - 768px (iPad)
# - 1024px (Desktop)
```

---

## 📱 Responsive behavior

| Largeur | Affichage |
|---------|-----------|
| **0-767px** | 🔙 Bouton retour uniquement |
| **768px+** | 🏠 Chemin complet avec icônes |

### Breakpoints

```scss
// Mobile
@media (max-width: 767px) { }

// Tablet et plus
@media (min-width: 768px) { }
```

---

## 🎭 Stimulus Controller (optionnel)

Si vous voulez ajouter des interactions JS :

```javascript
// app/javascript/controllers/breadcrumbs_controller.js

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["link"]

  connect() {
    console.log("Breadcrumbs controller connected")
  }

  // Ajouter un effet au clic
  navigate(event) {
    event.currentTarget.style.opacity = "0.6"
    setTimeout(() => {
      event.currentTarget.style.opacity = "1"
    }, 200)
  }
}
```

**Utilisation** :
```erb
<%= link_to crumb[:path], 
    class: "breadcrumbs-link",
    data: { 
      breadcrumbs_target: "link",
      action: "click->breadcrumbs#navigate"
    } do %>
```

---

## 🐛 Dépannage

### Les breadcrumbs ne s'affichent pas

**Causes possibles** :
1. `@projet` ou `@article` est nil
2. CSS non chargé
3. Helper non appelé

**Solutions** :
```ruby
# Vérifier dans la console Rails
rails console
> helper.breadcrumbs
# Doit retourner un array
```

### Desktop/Mobile inversés

**Cause** : Media queries CSS

**Vérification** :
```bash
# Inspecter l'élément (F12)
# Vérifier les classes appliquées
# .breadcrumbs-desktop doit avoir display: flex sur desktop
# .breadcrumbs-mobile doit avoir display: none sur desktop
```

### Données structurées non détectées

**Causes** :
1. JSON malformé
2. Script non inclus dans le HTML
3. Erreur de syntaxe

**Solution** :
```bash
# Vérifier le JSON généré
curl http://localhost:3000/projets/[slug] | grep "application/ld+json" -A 20
```

---

## ✅ Checklist

### Par page avec breadcrumbs

- [ ] Breadcrumbs visible sur desktop
- [ ] Bouton retour visible sur mobile
- [ ] Liens fonctionnels
- [ ] Page actuelle non cliquable
- [ ] Icônes affichées correctement
- [ ] Données structurées présentes
- [ ] BreadcrumbList validé (Rich Results Test)

### Configuration

- [ ] Helper configuré pour tous les controllers
- [ ] CSS importé (`_index.scss`)
- [ ] FontAwesome chargé (icônes)
- [ ] Couleurs personnalisées
- [ ] Responsive testé

---

## 💡 Bonnes pratiques

### ✅ À faire

- Utiliser des **noms courts** et descriptifs
- Garder **3-4 niveaux** maximum
- Page actuelle **non cliquable**
- **Tronquer** les titres trop longs (CSS)
- Tester sur **tous les devices**

### ❌ À éviter

- Breadcrumbs sur la page d'accueil (inutile)
- Trop de niveaux (> 5)
- Noms techniques (slugs) dans les breadcrumbs
- Oublier `aria-current="page"` sur page actuelle
- Négliger la version mobile

---

## 📊 Impact SEO

### CTR amélioré

**Sans breadcrumbs** :
```
maximeoudin.fr/projets/shazam-api
Shazam API | Maxime Oudin
Description...
```

**Avec breadcrumbs** :
```
maximeoudin.fr > Projets > Shazam API
Shazam API | Maxime Oudin  
Description...
```

**Augmentation CTR** : +5 à +10%

### UX améliorée

- ✅ Navigation plus intuitive
- ✅ Contexte clair pour l'utilisateur
- ✅ Moins de rebond
- ✅ Plus de pages vues/session

---

## 🎯 Résumé

**Composants** :
1. ✅ Helper Ruby (génération automatique)
2. ✅ Partial ERB (template HTML)
3. ✅ CSS responsive (desktop/mobile)
4. ✅ Données structurées (Schema.org)
5. ✅ Icônes FontAwesome

**Commande d'utilisation** :
```erb
<%= render_breadcrumbs %>
```

**Résultat** :
- Desktop : 🏠 Accueil > Projets > Page actuelle
- Mobile : ← Projets

---

*Pour compléter, voir aussi :*
- [02_SEO_GENERAL.md](./02_SEO_GENERAL.md) - Vue d'ensemble
- [03_SEO_METADATA.md](./03_SEO_METADATA.md) - Meta tags
- [04_SEO_STRUCTURED_DATA.md](./04_SEO_STRUCTURED_DATA.md) - Données structurées

*Dernière mise à jour : 23 Décembre 2025*

