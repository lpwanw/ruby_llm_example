# Design Guidelines

UI/UX patterns and styling conventions for Rails LLM.

## Design Philosophy

- **Minimalism + Trust** - Clean Swiss-style design with blue primary. Professional and trustworthy.
- **Dark Mode Native** - Both light and dark modes equally polished
- **Accessibility** - WCAG 2.1 AA compliance by default
- **Responsive** - Mobile-first, works at 320px+ widths
- **Consistent** - Predictable patterns across all pages
- **Performant** - No design flourishes that impact performance

## Design System Overview

**Style:** Minimalism + Swiss Modernism 2.0
**Typography:** Poppins (headings) + Open Sans (body)
**Primary Color:** Trust Blue (#2563EB)
**CTA Color:** Orange (#F97316)

## Typography

### Font Stack

```css
/* Headings */
font-family: 'Poppins', system-ui, sans-serif;

/* Body */
font-family: 'Open Sans', system-ui, sans-serif;
```

### Google Fonts Import

```css
@import url('https://fonts.googleapis.com/css2?family=Open+Sans:wght@300;400;500;600;700&family=Poppins:wght@400;500;600;700&display=swap');
```

### Scale

| Size | Class | Usage |
|------|-------|-------|
| **48-60px** | text-5xl/6xl | Hero headlines |
| **32px** | text-4xl | Page titles (h1) |
| **28px** | text-3xl | Section headers (h2) |
| **24px** | text-2xl | Subsections (h3) |
| **20px** | text-xl | Component titles |
| **16px** | text-base | Body text (default) |
| **14px** | text-sm | Labels, secondary text |
| **12px** | text-xs | Hints, metadata |

### Font Weights

| Weight | Tailwind | Usage |
|--------|----------|-------|
| 400 | font-normal | Body text |
| 500 | font-medium | Labels |
| 600 | font-semibold | Buttons, headings |
| 700 | font-bold | Hero titles, emphasis |

## Color Palette

### Primary Colors (Trust Blue)

| Shade | Hex | Tailwind | Usage |
|-------|-----|----------|-------|
| 50 | #EFF6FF | primary-50 | Light backgrounds |
| 100 | #DBEAFE | primary-100 | Hover backgrounds |
| 200 | #BFDBFE | primary-200 | Borders (hover) |
| 300 | #93C5FD | primary-300 | Icons (dark mode) |
| 400 | #60A5FA | primary-400 | Links (dark mode) |
| 500 | #3B82F6 | primary-500 | Focus rings |
| **600** | **#2563EB** | **primary-600** | **Primary buttons, links** |
| 700 | #1D4ED8 | primary-700 | Button hover |
| 800 | #1E40AF | primary-800 | Text emphasis |
| 900 | #1E3A8A | primary-900 | Dark backgrounds |

### CTA Colors (Orange)

| Shade | Hex | Tailwind | Usage |
|-------|-----|----------|-------|
| 50 | #FFF7ED | cta-50 | Light backgrounds |
| 100 | #FFEDD5 | cta-100 | Hover backgrounds |
| 400 | #FB923C | cta-400 | Icons |
| **500** | **#F97316** | **cta-500** | **CTA buttons** |
| 600 | #EA580C | cta-600 | CTA hover |
| 700 | #C2410C | cta-700 | CTA active |

### Status Colors

| Status | Light | Dark | Tailwind |
|--------|-------|------|----------|
| **Success** | #10B981 | #6EE7B7 | green-500 / green-400 |
| **Error** | #EF4444 | #FCA5A5 | red-500 / red-400 |
| **Warning** | #F59E0B | #FCD34D | amber-500 / amber-300 |
| **Info** | #3B82F6 | #93C5FD | blue-500 / blue-400 |

### Gray Scale

**Light Mode:**
- Background: white (#FFFFFF) / gray-50 (#F9FAFB)
- Surface: gray-50 (#F9FAFB)
- Border: gray-100 (#F3F4F6) / gray-200 (#E5E7EB)
- Text (primary): gray-900 (#111827)
- Text (secondary): gray-600 (#4B5563)

**Dark Mode:**
- Background: gray-900 (#111827)
- Surface: gray-800 (#1F2937)
- Border: gray-700 (#374151)
- Text (primary): white (#FFFFFF)
- Text (secondary): gray-400 (#9CA3AF)

## Component Patterns

### Buttons

**Primary Button** (Trust Blue)
```erb
<button class="px-4 py-2 bg-primary-600 text-white font-semibold rounded-lg
               hover:bg-primary-700
               focus:outline-none focus:ring-2 focus:ring-primary-500 focus:ring-offset-2
               dark:focus:ring-offset-gray-800
               transition cursor-pointer">
  Sign In
</button>
```

**CTA Button** (Orange - high conversion)
```erb
<button class="px-8 py-4 bg-cta-500 text-white font-semibold rounded-xl
               hover:bg-cta-600
               shadow-lg shadow-cta-500/25 hover:shadow-xl hover:shadow-cta-500/30
               hover:-translate-y-0.5
               transition-all cursor-pointer">
  Get Started Free
</button>
```

**Secondary Button** (Outlined)
```erb
<button class="px-4 py-2 border border-gray-300 bg-white text-gray-700 font-medium rounded-lg
               hover:bg-gray-50 dark:border-gray-600 dark:bg-gray-700 dark:text-gray-300
               dark:hover:bg-gray-600
               focus:outline-none focus:ring-2 focus:ring-primary-500
               transition cursor-pointer">
  Cancel
</button>
```

**Danger Button** (Red)
```erb
<button class="px-4 py-2 border border-red-300 text-red-600 font-medium rounded-lg
               hover:bg-red-50 dark:border-red-600 dark:text-red-400
               dark:hover:bg-red-900/20
               focus:outline-none focus:ring-2 focus:ring-red-500
               transition cursor-pointer">
  Delete Account
</button>
```

### Form Fields

**Input Field**
```erb
<%= f.email_field :email,
    class: "w-full px-4 py-3 border border-gray-300 dark:border-gray-600
           rounded-lg shadow-sm
           placeholder-gray-400 dark:placeholder-gray-500
           bg-white dark:bg-gray-700 text-gray-900 dark:text-white
           focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-transparent
           transition" %>
```

**Label**
```erb
<%= f.label :email, class: "block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1" %>
```

**Helper Text**
```erb
<p class="text-xs text-gray-500 dark:text-gray-400 mb-2">Minimum 8 characters</p>
```

### Cards

**Feature Card**
```erb
<div class="group p-6 bg-gray-50 dark:bg-gray-800 rounded-2xl
            border border-gray-100 dark:border-gray-700
            hover:border-primary-200 dark:hover:border-primary-800
            transition-all cursor-pointer">
  <div class="w-12 h-12 rounded-xl bg-primary-100 dark:bg-primary-900/30
              flex items-center justify-center mb-4
              group-hover:scale-110 transition-transform">
    <!-- SVG icon -->
  </div>
  <h3 class="text-lg font-semibold text-gray-900 dark:text-white mb-2">Title</h3>
  <p class="text-gray-600 dark:text-gray-400">Description text</p>
</div>
```

**Auth Card**
```erb
<div class="bg-white dark:bg-gray-800 rounded-2xl
            shadow-xl shadow-gray-200/50 dark:shadow-none
            border border-gray-100 dark:border-gray-700
            p-8 sm:p-10">
  <!-- form content -->
</div>
```

### Navigation

**Fixed Navbar**
```erb
<nav class="fixed top-0 left-0 right-0 z-50
            bg-white/80 dark:bg-gray-900/80 backdrop-blur-md
            border-b border-gray-200 dark:border-gray-800">
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
    <div class="flex justify-between items-center h-16">
      <!-- Logo + Nav items -->
    </div>
  </div>
</nav>
```

### Links

```erb
<%= link_to "Link text", path, class: "font-medium text-primary-600 hover:text-primary-500 dark:text-primary-400 dark:hover:text-primary-300 transition" %>
```

## Page Layouts

### Auth Pages (Split-Screen)

Desktop: 50/50 split with branding panel on left
Mobile: Single column, logo above form

```erb
<div class="min-h-screen flex">
  <!-- Left: Branding (hidden on mobile) -->
  <div class="hidden lg:flex lg:w-1/2 bg-gradient-to-br from-primary-600 to-primary-900">
    <!-- Branding content -->
  </div>

  <!-- Right: Auth form -->
  <div class="flex-1 flex items-center justify-center bg-gray-50 dark:bg-gray-900 px-4 py-12">
    <!-- Form content -->
  </div>
</div>
```

### Landing Page Structure

```erb
<div class="min-h-screen bg-gray-50 dark:bg-gray-900">
  <!-- Fixed Navbar -->
  <nav>...</nav>

  <!-- Hero Section -->
  <div class="pt-16">
    <div class="relative max-w-7xl mx-auto px-4 py-24 sm:py-32 lg:py-40">
      <!-- Hero content -->
    </div>
  </div>

  <!-- Features Section -->
  <section class="py-24 bg-white dark:bg-gray-800/50">
    <div class="max-w-7xl mx-auto px-4">
      <!-- Features grid -->
    </div>
  </section>

  <!-- Footer -->
  <footer class="py-12 border-t border-gray-200 dark:border-gray-800">
    <!-- Footer content -->
  </footer>
</div>
```

## Spacing Scale

Tailwind spacing scale (4px base unit):

| Value | Pixels | Usage |
|-------|--------|-------|
| 1 | 4px | Icon gaps |
| 2 | 8px | Compact spacing |
| 3 | 12px | Button padding |
| 4 | 16px | Standard spacing |
| 6 | 24px | Section spacing |
| 8 | 32px | Large gaps |
| 12 | 48px | Section padding |
| 16 | 64px | Large section gaps |
| 24 | 96px | Hero padding |

## Dark Mode

### Tailwind Config

Dark mode uses `prefers-color-scheme` media query.

### Color Mapping

| Element | Light | Dark |
|---------|-------|------|
| Background | white / gray-50 | gray-900 |
| Surface | gray-50 | gray-800 |
| Border | gray-100/200 | gray-700 |
| Text | gray-900 | white |
| Muted text | gray-600 | gray-400 |
| Primary | primary-600 | primary-400 |

### Required Classes

Always pair light/dark variants:
```erb
<div class="bg-white dark:bg-gray-800 text-gray-900 dark:text-white border-gray-200 dark:border-gray-700">
```

## Animation Guidelines

### Transitions

- **Default:** `transition` (150ms)
- **Colors:** `transition-colors` (200ms)
- **All properties:** `transition-all` (200ms)
- **Transform:** Include `hover:-translate-y-0.5` for lift effect

### Hover States

```erb
<!-- Color change only -->
<button class="transition-colors hover:bg-primary-700">

<!-- Lift effect (for CTAs) -->
<button class="transition-all hover:-translate-y-0.5 hover:shadow-xl">

<!-- Scale effect (for icons) -->
<div class="group-hover:scale-110 transition-transform">
```

### Performance Rules

- Use `transform` and `opacity` for animations
- Avoid animating `width`, `height`, `top`, `left`
- Keep transitions under 300ms
- Respect `prefers-reduced-motion`

## Icon System

Using inline SVG icons (Heroicons style):

```erb
<svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="..." />
</svg>
```

### Standard Sizes

- **Small:** w-4 h-4 (16px)
- **Default:** w-5 h-5 (20px)
- **Large:** w-6 h-6 (24px)
- **Feature icons:** w-8 h-8 (32px)

## Accessibility

### Color Contrast

- Text: 4.5:1 minimum (WCAG AA)
- UI components: 3:1 minimum
- Use gray-900 on white (not gray-400)
- Use white on primary-600+

### Focus States

```erb
focus:outline-none focus:ring-2 focus:ring-primary-500 focus:ring-offset-2 dark:focus:ring-offset-gray-800
```

### Cursor

Add `cursor-pointer` to all interactive elements:
- Buttons
- Links
- Clickable cards
- Form checkboxes
- Toggle buttons

### Screen Reader

- Use semantic HTML
- Add `role="alert"` for error messages
- Include `aria-label` for icon-only buttons

## Responsive Breakpoints

| Breakpoint | Min Width | Usage |
|------------|-----------|-------|
| (default) | 0px | Mobile styles |
| sm: | 640px | Small tablets |
| md: | 768px | Tablets |
| lg: | 1024px | Desktop |
| xl: | 1280px | Large desktop |

### Common Patterns

```erb
<!-- Text scaling -->
<h1 class="text-4xl sm:text-5xl lg:text-6xl">

<!-- Padding scaling -->
<div class="px-4 sm:px-6 lg:px-8">

<!-- Grid columns -->
<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">

<!-- Show/hide -->
<div class="hidden lg:block">Desktop only</div>
<div class="lg:hidden">Mobile only</div>
```

## CSS Variables

Defined in `application.tailwind.css`:

```css
@theme {
  --font-heading: 'Poppins', system-ui, sans-serif;
  --font-body: 'Open Sans', system-ui, sans-serif;
  --color-primary-*: /* blue scale */;
  --color-cta-*: /* orange scale */;
}
```

## File Structure

```
app/assets/stylesheets/
└── application.tailwind.css  # Tailwind imports + custom theme

app/views/
├── layouts/
│   └── application.html.erb
├── shared/
│   └── _flash.html.erb
├── devise/
│   └── shared/
│       ├── _auth_container.html.erb
│       ├── _links.html.erb
│       └── _error_messages.html.erb
└── home/
    └── index.html.erb
```

---

**Last Updated:** 2026-01-13 | **Tailwind Version:** 4.1 | **Style:** Minimalism + Trust Blue
