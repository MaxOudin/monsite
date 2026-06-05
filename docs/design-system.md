# Design System — maximeoudin.fr

> Document de référence de la charte graphique.  
> Dernière mise à jour : 2026-06-05.

---

## 1. Couleurs

### Palette principale

Les couleurs brand sont définies comme tokens Tailwind dans `application.tailwind.css` (`@theme`) et utilisables directement comme classes utilitaires.

| Token | Classe Tailwind | Hex | Usage |
|---|---|---|---|
| `primary` | `bg-primary` `text-primary` `border-primary` | `#FFDD00` | CTA principal, accents, highlights |
| `primary-hover` | `hover:bg-primary-hover` | `#FFE633` | État hover du fond primary |
| `secondary` | `bg-secondary` `text-secondary` `border-secondary` | `#004AAD` | Bouton secondaire, titres, hover nav, brand |
| `secondary-hover` | `hover:bg-secondary-hover` | `#003A8D` | État hover du fond secondary |
| `accent` | `bg-accent` `text-accent` | `#FF007F` | Accents visuels décoratifs, icônes uniquement |
| `brand-bg` | `bg-brand-bg` | `#F8F9FC` | Fond de page (light) |
| `brand-text` | `text-brand-text` | `#141414` | Corps de texte principal |

### Ratios de contraste WCAG — Light mode

| Combinaison | Ratio | AA normal (4.5:1) | AA large (3:1) |
|---|---|---|---|
| `#004AAD` sur `#F8F9FC` | 7.9:1 | ✅ | ✅ |
| `#141414` sur `#F8F9FC` | 17.5:1 | ✅ | ✅ |
| `#004AAD` sur `#FFDD00` | 7.2:1 | ✅ | ✅ |
| `#FFFFFF` sur `#004AAD` | 8.1:1 | ✅ | ✅ |
| `#FFFFFF` sur `#111827` | 18.1:1 | ✅ | ✅ |
| `#6EB5FF` sur `#F8F9FC` | 2.05:1 | ❌ interdit comme texte | ❌ |
| `#FF007F` sur `#FFFFFF` | 3.78:1 | ❌ interdit en texte normal | ✅ grands éléments uniquement |
| `#FFDD00` sur `#FFFFFF` | 1.35:1 | ❌ interdit comme texte | ❌ |

---

## 2. Typographie

### Police

| Rôle | Famille | Source |
|---|---|---|
| Corps + titres | `Montserrat` | Google Fonts (poids 300, 400, 500, 700) |
| Éditorial (non actif) | `Playfair Display SC` | Google Fonts — chargée mais non utilisée |

### Échelle de tailles

| Token | Valeur | Tailwind |
|---|---|---|
| `xs` | 12px / 0.75rem | `text-xs` |
| `sm` | 14px / 0.875rem | `text-sm` |
| `base` | 16px / 1rem | `text-base` |
| `lg` | 18px / 1.125rem | `text-lg` |
| `xl` | 20px / 1.25rem | `text-xl` |
| `2xl` | 24px / 1.5rem | `text-2xl` |
| `3xl` | 32px / 2rem | `text-3xl` |
| `4xl` | 40px / 2.5rem | `text-4xl` |

### Hiérarchie typographique

| Élément | Taille | Graisse | Couleur |
|---|---|---|---|
| `h1` | `text-3xl` → `text-5xl` (responsive) | 700 | `text-gray-900` |
| `h2` | `text-2xl` → `text-3xl` | 700 | `text-gray-900` |
| `h3` | `text-xl` → `text-2xl` | 700 | `text-gray-900` |
| Corps de texte | `text-base` | 400 | `#141414` / `text-gray-900` |
| Texte secondaire | `text-sm` | 400–500 | `text-gray-600` (`#4b5563`) |
| Métadonnées / muted | `text-xs` → `text-sm` | 400 | `text-gray-500` (`#6b7280`) |

---

## 3. Boutons

Tous les boutons passent par `ButtonComponent` (ViewComponent).  
Base commune : `inline-flex items-center justify-center rounded-lg font-semibold transition-all duration-300`

### 3.1 Primaire — CTA principal

> Utiliser pour l'action principale d'une page ou d'une section.

| Propriété | Valeur |
|---|---|
| Fond | `bg-primary` |
| Texte | `text-secondary` |
| Border radius | `rounded-lg` (8px) |
| Hover fond | `hover:bg-primary-hover` |
| Hover élévation | `translateY(-2px)` (`hover:-translate-y-0.5`) |
| Ombre | `shadow-md` → `shadow-lg` au hover |
| Transition | `duration-300` |
| Contraste | 7.2:1 ✅ |

```ruby
ButtonComponent.new(variant: :primary, size: :md)
ButtonComponent.new(variant: :primary, size: :lg)
```

---

### 3.2 Secondaire — action complémentaire

> Utiliser en accompagnement d'un bouton primaire.

| Propriété | Valeur |
|---|---|
| Fond | `bg-secondary` |
| Texte | `text-white` |
| Border | `border border-secondary` |
| Hover fond | `hover:bg-secondary-hover` |
| Hover border | `hover:border-secondary-hover` |
| Hover élévation | `translateY(-2px)` |
| Ombre | `shadow-md` → `shadow-lg` au hover |
| Transition | `duration-300` |
| Contraste | 8.1:1 ✅ |

```ruby
ButtonComponent.new(variant: :secondary, size: :md)
```

---

### 3.3 Dark — action neutre (ex. recherche, déconnexion)

> Utiliser pour les actions utilitaires sans priorité brand.

| Propriété | Valeur |
|---|---|
| Fond | `#111827` (gray-900) |
| Texte | `#FFFFFF` |
| Hover fond | `#1f2937` (gray-800) |
| Hover élévation | `translateY(-2px)` |
| Transition | `duration-300` |
| Contraste | 18.1:1 ✅ |

```ruby
ButtonComponent.new(variant: :dark, size: :md)
```

---

### 3.4 Danger — action destructive

| Propriété | Valeur |
|---|---|
| Fond | `#dc2626` (red-600) |
| Texte | `#FFFFFF` |
| Hover fond | `#ef4444` (red-500) |
| Contraste | 4.62:1 ✅ |

```ruby
ButtonComponent.new(variant: :danger, size: :md)
```

---

### 3.5 Tailles disponibles

| Token | Padding | Font |
|---|---|---|
| `sm` | `px-3 py-1.5` | `text-sm` |
| `md` | `px-4 py-2` | `text-sm` |
| `lg` | `px-6 py-3` | `text-base` |

---

### 3.6 CTA hero (taille XL hors composant)

> Réservé aux sections hero — taille et padding augmentés.

| Propriété | Light mode | Dark mode |
|---|---|---|
| Fond | `bg-primary` | `bg-primary` |
| Texte | `text-secondary` | `text-secondary` |
| Padding | `px-8 py-4` | — |
| Font | `text-lg font-bold` | — |
| Hover fond | `hover:bg-primary-hover` | `hover:bg-primary-hover` |
| Hover effet | `scale-105 shadow-2xl` | — |
| Contraste | 7.2:1 ✅ | 7.9:1 ✅ |

---

## 4. Navigation

### 4.1 Navbar desktop

| État | Couleur | Classe Tailwind |
|---|---|---|
| Default | gray-700 | `text-gray-700` |
| Hover | secondary | `hover:text-secondary` |
| Active (page courante) | secondary + gras | `text-secondary font-semibold` |
| Transition | 300ms | `transition-colors duration-300` |

### 4.2 Navbar mobile

| État | Couleur | Classe Tailwind |
|---|---|---|
| Default | gray-900 | `text-gray-900` |
| Hover | secondary | `hover:text-secondary` |
| Active (page courante) | secondary + gras | `text-secondary font-semibold` |
| Transition | 300ms | `transition-colors duration-300` |

### 4.3 Liens footer

| État | Couleur | Fond | Contraste |
|---|---|---|---|
| Default | `text-gray-400` (`#9ca3af`) | `bg-gray-900` (`#111827`) | 5.5:1 ✅ |
| Hover | `text-white` | `bg-gray-900` | 18.1:1 ✅ |

---

## 5. Ombres, bordures, transitions

### Ombres

| Token | Valeur |
|---|---|
| `shadow-sm` | `0 2px 4px rgba(0,0,0,0.1)` |
| `shadow-md` | `0 4px 6px rgba(0,0,0,0.1)` |
| `shadow-lg` | `0 10px 15px rgba(0,0,0,0.1)` |

### Border radius

| Usage | Valeur | Tailwind |
|---|---|---|
| Petits éléments (badges) | 4px | `rounded` |
| Boutons, inputs, cartes | 8px | `rounded-lg` |
| Grandes cartes | 12px | `rounded-xl` |

### Transitions

| Usage | Durée | Tailwind |
|---|---|---|
| Couleurs de texte / fond | 300ms | `duration-300` |
| Ombres, élévations | 300ms | `duration-300` |
| Transformations (scale, translate) | 300ms | `duration-300` |

---

## 6. Dark mode

### Palette dark mode

| Token | Hex | Tailwind équivalent | Usage |
|---|---|---|---|
| Fond de page | `#111827` | `gray-900` | Body, sections, navbar |
| Fond carte | `#374151` | `gray-700` | Cartes, surfaces élevées |
| Fond input | `#374151` | `gray-700` | Formulaires |
| Texte principal | `#f9fafb` | `gray-50` | Corps de texte |
| Texte secondaire | `#e5e7eb` | `gray-200` | Sous-titres |
| Texte muted | `#b5c4d1` | — | Métadonnées (5.8:1 ✅) |
| Texte désactivé | `#9ca3af` | `gray-400` | Éléments inactifs (4.7:1 ✅) |
| Bordure | `rgba(255,255,255,0.12)` | — | Toutes bordures |

### Ratios de contraste WCAG — Dark mode

| Combinaison | Ratio | AA normal | AA large |
|---|---|---|---|
| `#f9fafb` sur `#111827` | 16.7:1 | ✅ | ✅ |
| `#e5e7eb` sur `#111827` | 13.0:1 | ✅ | ✅ |
| `#b5c4d1` sur `#374151` | 5.8:1 | ✅ | ✅ |
| `#9ca3af` sur `#374151` | 4.7:1 | ✅ | ✅ |
| `#FFDD00` sur `#111827` | 7.9:1 | ✅ | ✅ |
| `#004AAD` sur `#f9fafb` | 7.9:1 | ✅ | ✅ |

### Comportement des couleurs brand en dark mode

| Élément | Light | Dark | Changement |
|---|---|---|---|
| Bouton primary | `#FFDD00` / `#004AAD` | identique | aucun |
| Bouton secondary | `#004AAD` / `#FFFFFF` | identique | aucun |
| Hover nav | `#004AAD` | `#6EB5FF` (plus lumineux) | override CSS |
| Fond body | `#F8F9FC` | `#111827` | override CSS |
| Fond carte | `#FFFFFF` | `#374151` | override CSS |

---

## 7. Points de vigilance

| Règle | Détail |
|---|---|
| `#6EB5FF` | Décoratif uniquement — contraste 2.05:1 sur fond clair, interdit comme texte |
| `#FF007F` | Icônes et accents visuels uniquement — 3.78:1, insuffisant pour le texte normal |
| `#FFDD00` | Jamais en texte sur fond blanc — 1.35:1 |
| Inline `style="color:"` | Éviter — impossible à surcharger en dark mode sans `!important` |
| `ButtonComponent` | Seul point d'entrée autorisé pour les boutons — éviter les boutons ad-hoc dans les vues |
