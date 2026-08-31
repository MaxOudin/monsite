# Design System — maximeoudin.fr

> Document de référence de la charte graphique.  
> Dernière mise à jour : 2026-08-31.

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
| `5xl` | 48px / 3rem | `text-5xl` |
| `6xl` | 60px / 3.75rem | `text-6xl` |

> `5xl`/`6xl` réservés au H1 hero display (voir ci-dessous) — ne pas utiliser ailleurs sans mise à jour de cette doc.

### Hiérarchie typographique

| Élément | Taille | Graisse | Couleur |
|---|---|---|---|
| `h1` (générique — pages Projets/Articles/contenus) | `text-3xl` → `text-5xl` (responsive) | 700 | `text-gray-900` / dark: `text-gray-50` |
| `h1` **hero display** (page d'accueil uniquement) | `text-3xl` → `text-6xl` | **500** | `text-gray-900` / dark: `text-gray-50`, `tracking-tight leading-[1.08]` |
| `h2` | `text-2xl` → `text-3xl` | 700 | `text-gray-900` / dark: `text-gray-50` |
| `h3` | `text-xl` → `text-2xl` | 700 | `text-gray-900` / dark: `text-gray-50` |
| Corps de texte | `text-base` | 400 | `#141414` / dark: `text-gray-50` |
| Texte secondaire | `text-sm` | 400–500 | `text-gray-600` / dark: `text-gray-200` |
| Métadonnées / muted | `text-xs` → `text-sm` | 400 | `text-gray-500` / dark: `#b5c4d1` |

> **Hero display** : traitement typographique volontairement plus léger et éditorial (poids 500, tracking resserré) réservé au H1 du hero d'accueil. Ne pas généraliser ce poids aux autres titres du site sans décision explicite — la hiérarchie standard (700) reste la référence partout ailleurs.

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

> Variante historique, plus emphatique (`scale-105 shadow-2xl`). Pour le hero d'accueil, préférer **3.7**.

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

### 3.7 CTA hero — variante pill (minimaliste)

> Réservée à la section hero d'accueil. Remplace la variante 3.6 pour ce contexte spécifique — plus discrète, sans ombre portée lourde.

| Propriété | Valeur |
|---|---|
| Fond | `bg-primary` |
| Texte | `text-secondary` |
| Border radius | `rounded-full` |
| Hauteur | `h-12`, `px-8` |
| Font | `text-base font-medium` |
| Hover fond | `hover:bg-primary-hover` |
| Hover élévation | `hover:-translate-y-0.5` |
| Ombre | aucune par défaut (contraste avec 3.6) |
| Transition | `duration-300` |
| Contraste | 7.2:1 ✅ |

```ruby
ButtonComponent.new(variant: :primary, shape: :pill, size: :lg)
```

---

### 3.8 Lien CTA secondaire (inline)

> Utilisé quand un deuxième CTA doit rester visuellement en retrait du CTA principal, sans porter le même poids visuel qu'un bouton plein. **Doit conserver une couleur brand au hover** — jamais uniquement grise, pour rester identifiable comme lien de marque.

| Propriété | Valeur |
|---|---|
| Texte défaut | `text-gray-600` / dark: `text-gray-300` |
| Border-bottom défaut | `border-gray-300` / dark: `border-white/20` |
| Texte hover | `hover:text-secondary` / dark: `hover:text-blue-300` |
| Border hover | `hover:border-secondary` / dark: `hover:border-blue-300` |
| Font | `text-sm font-medium` |
| Transition | `duration-300` |

```ruby
ButtonComponent.new(variant: :link, size: :sm)
```

> ⚠️ Cette variante ne doit pas remplacer le bouton secondaire plein (3.2) hors contexte hero — elle est réservée aux cas où deux CTA de poids égal nuiraient à la hiérarchie visuelle.

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

### 4.3 Fil d'Ariane

> Même famille que le label d'index (point jaune + uppercase tracking). Un seul trail, desktop et mobile — pas de variante « retour » séparée.

| Propriété | Valeur |
|---|---|
| Font | `text-xs font-medium uppercase tracking-[0.14em]` |
| Couleur liens | `text-gray-500` |
| Hover liens | `hover:text-secondary` / dark: `#93c5fd` |
| Page courante | `text-gray-900`, **casse normale** (titres longs), `truncate` |
| Séparateur | Point `size-1.5 rounded-full bg-primary` (même token que le label d'index) |
| Transition | `duration-300` |
| Position | Même coquille `.page-container` que l'index (`py-16 md:py-20`) — le trail s'aligne sur le label « Réalisations / Écrits » |

Ne pas utiliser d'icône home ni de chevron — le point brand suffit comme séparateur.

### 4.4 Liens footer

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
| CTA pill (hero) | 9999px | `rounded-full` |

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
| Hero d'accueil | Pas de logo en fond (déjà dans la navbar) — garder le hero épuré |
| `5xl` / `6xl` | Réservés au H1 hero display |
| Variante `:link` | Uniquement en second CTA (hero) — ne pas remplacer le bouton secondary 3.2 |
| Cards collection | Un seul `CardComponent` pour Projets et Articles — pas de cards ad-hoc |

---

## 8. Animations & mouvement

### Classes d'entrée (hero)

| Classe | Usage |
|---|---|
| `hero-in-1` → `hero-in-5` | Fade-up séquencé des éléments du hero à l'arrivée sur la page |
| `animate-hero-float` | Flottement lent des formes décoratives en arrière-plan |
| `delay-*` | Décalage d'apparition entre éléments |

### Accessibilité — réduction de mouvement

**Obligatoire** : toutes les animations `hero-in-*` et `animate-hero-float` doivent être désactivées pour les utilisateurs ayant activé la réduction de mouvement système.

```css
@media (prefers-reduced-motion: reduce) {
  .hero-in-1, .hero-in-2, .hero-in-3, .hero-in-4, .hero-in-5,
  .animate-hero-float {
    animation: none !important;
    opacity: 1 !important;
    transform: none !important;
  }
}
```

Déjà présent dans `application.tailwind.css` (avec `filter: none` en complément).

---

## 9. Pages de collection (Projets / Articles)

> Les index Projets et Articles partagent le même langage visuel et le même partial (`shared/_collection_index`). Les cards passent toutes par `CardComponent`. Ne pas diverger l'un sans l'autre.

### 9.1 En-tête d'index

Même famille que le hero d'accueil, sans reprendre le traitement display (poids 500 / `6xl`).

| Élément | Traitement |
|---|---|
| Coquille | `.page-container` — `py-16 md:py-20` (identique aux shows, pour aligner label et breadcrumbs) |
| Label | Point `bg-primary` + `text-xs font-medium uppercase tracking-[0.14em] text-gray-500` |
| `h1` | `text-3xl` → `text-5xl`, **700**, `tracking-tight` (hiérarchie générique §2) |
| Sous-titre | `text-base` → `text-lg`, `text-gray-600`, `max-w-[46ch]` |
| CTA admin | `ButtonComponent` primary + `href:` (création) |

### 9.2 Recherche

| Propriété | Valeur |
|---|---|
| Input | `rounded-xl`, `border-gray-200`, `px-5 py-3`, focus `ring-secondary` |
| Submit | `ButtonComponent` primary `size: :lg` (pas pill — réservé au hero 3.7) |
| Bannière résultats | `bg-primary/10 border-primary/30`, lien « Effacer » en `text-secondary` |

### 9.3 Card collection

Même composant pour un projet ou un article. Image au-dessus, contenu en dessous — **pas d'overlay texte-sur-image**.

| Propriété | Valeur |
|---|---|
| Conteneur | `rounded-xl`, `border-gray-200`, `bg-white`, `shadow-md` |
| Hover | `hover:-translate-y-1 hover:shadow-lg` (`duration-300`) |
| Image | `aspect-[16/10]`, `object-cover`, zoom léger au hover (`scale-105`) |
| Fallback image | Logo jaune, `object-contain`, fond `bg-primary/10` |
| Meta | Badge + point `bg-primary` + date — `text-xs uppercase tracking-[0.14em] text-gray-500` |
| Titre | `h2` `text-xl font-bold text-gray-900`, hover `text-secondary` (dark: `#93c5fd`) |
| Extrait | `text-sm text-gray-600`, `line-clamp-2` |
| Reduced motion | Pas de translate ni de scale (`motion-reduce:`) |

```ruby
CardComponent.new(model: projet)
CardComponent.new(model: article)
```

### 9.4 Grille

| Breakpoint | Colonnes |
|---|---|
| Mobile | 1 |
| `sm` | 2 |
| `lg` | 3 |

Espacement : `gap-6` → `lg:gap-8`.
