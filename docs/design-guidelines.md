# Design Guidelines

UI/UX patterns and styling conventions for Rails LLM.

## Design Philosophy

- **Clarity First** - Clean, simple interfaces that guide users
- **Dark Mode Native** - Both light and dark modes equally polished
- **Accessibility** - WCAG 2.1 AA compliance by default
- **Responsive** - Mobile-first, works at 320px+ widths
- **Consistent** - Predictable patterns across all pages
- **Performant** - No design flourishes that impact performance

## Color Palette

### Primary Colors

| Name | Light | Dark | Usage |
|------|-------|------|-------|
| **Indigo** | #4F46E5 | #818CF8 | Buttons, links, primary actions |
| **Slate** | #64748B | #E2E8F0 | Text, borders, secondary |
| **White** | #FFFFFF | #111827 | Backgrounds |

### Status Colors

| Status | Light | Dark | Tailwind |
|--------|-------|------|----------|
| **Success** | #10B981 | #6EE7B7 | green-500 / green-400 |
| **Error** | #EF4444 | #FCA5A5 | red-500 / red-400 |
| **Warning** | #F59E0B | #FCD34D | amber-500 / amber-300 |
| **Info** | #3B82F6 | #93C5FD | blue-500 / blue-400 |

### Gray Scale

**Light Mode:**
- Background: white (#FFFFFF)
- Surface: gray-50 (#F9FAFB)
- Border: gray-200 (#E5E7EB)
- Text (primary): gray-900 (#111827)
- Text (secondary): gray-600 (#4B5563)

**Dark Mode:**
- Background: gray-950 (#030712)
- Surface: gray-900 (#111827)
- Border: gray-800 (#1F2937)
- Text (primary): white (#FFFFFF)
- Text (secondary): gray-300 (#D1D5DB)

## Typography

### Font Stack

```css
/* Tailwind default */
font-family: system-ui, -apple-system, sans-serif;
```

### Scale

| Size | Class | Usage |
|------|-------|-------|
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
| 600 | font-semibold | Headings, labels |
| 700 | font-bold | Emphasis, strong |

### Line Height

```css
/* Tailwind defaults */
h1, h2, h3: leading-tight (1.25)
p, body: leading-relaxed (1.625)
```

## Spacing Scale

Tailwind spacing scale (4px base unit):

```
0 = 0px
1 = 4px
2 = 8px
3 = 12px
4 = 16px      ← Most common
6 = 24px
8 = 32px
```

### Common Spacing Patterns

```html
<!-- Container padding -->
<div class="p-4 sm:p-6 lg:p-8">

<!-- Vertical space between sections -->
<section class="mb-8">

<!-- Component internal spacing -->
<div class="px-4 py-3">

<!-- Gap between flex items -->
<div class="flex gap-2">
```

## Component Patterns

### Buttons

**Primary Button** (Call-to-action)
```erb
<button class="px-4 py-2 bg-indigo-600 text-white font-semibold rounded-lg
               hover:bg-indigo-700 dark:bg-indigo-500 dark:hover:bg-indigo-600
               focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2
               dark:focus:ring-offset-gray-900
               transition-colors duration-200">
  Sign In
</button>
```

**Secondary Button** (Alternative action)
```erb
<button class="px-4 py-2 border border-gray-300 bg-white text-gray-900 font-semibold rounded-lg
               hover:bg-gray-50 dark:border-gray-700 dark:bg-gray-900 dark:text-white
               dark:hover:bg-gray-800
               focus:outline-none focus:ring-2 focus:ring-indigo-500
               transition-colors duration-200">
  Cancel
</button>
```

**Danger Button** (Destructive action)
```erb
<button class="px-4 py-2 bg-red-600 text-white font-semibold rounded-lg
               hover:bg-red-700 dark:bg-red-500 dark:hover:bg-red-600
               focus:outline-none focus:ring-2 focus:ring-red-500
               transition-colors duration-200">
  Delete Account
</button>
```

### Forms

**Form Container**
```erb
<div class="w-full max-w-md mx-auto">
  <%= form_with(model: @user, local: true) do |f| %>
    <!-- form fields -->
  <% end %>
</div>
```

**Form Field with Label**
```erb
<div class="mb-4">
  <%= f.label :email, class: "block text-sm font-semibold text-gray-900
                              dark:text-white mb-2" %>
  <%= f.email_field :email,
                   class: "w-full px-4 py-2 border border-gray-300 rounded-lg
                          bg-white text-gray-900 placeholder-gray-500
                          dark:border-gray-700 dark:bg-gray-900 dark:text-white
                          dark:placeholder-gray-400
                          focus:outline-none focus:border-indigo-500 focus:ring-2
                          focus:ring-indigo-200 dark:focus:ring-indigo-900
                          transition-colors",
                   placeholder: 'user@example.com' %>
</div>
```

**Password Field with Toggle**
```erb
<div class="mb-4">
  <%= f.label :password, class: "block text-sm font-semibold mb-2" %>
  <div class="relative" data-controller="password-toggle">
    <%= f.password_field :password,
                        class: "w-full px-4 py-2 pr-12 border border-gray-300 rounded-lg...",
                        data: { "password_toggle-target": "input" } %>
    <button type="button" class="absolute right-3 top-2.5"
            data-action="password-toggle#toggle">
      <span data-password_toggle-target="iconShow">👁️</span>
      <span data-password_toggle-target="iconHide" class="hidden">👁️‍🗨️</span>
    </button>
  </div>
</div>
```

**Error Messages**
```erb
<div class="mb-4" role="alert" aria-live="polite">
  <%= render 'devise/shared/error_messages', object: @user %>
</div>
```

### Cards

**Card Container**
```erb
<div class="bg-white dark:bg-gray-900 rounded-lg border border-gray-200
           dark:border-gray-800 shadow-sm p-6">
  <h2 class="text-lg font-semibold text-gray-900 dark:text-white mb-4">
    Section Title
  </h2>
  <!-- card content -->
</div>
```

### Flash Messages (Toast Notifications)

Located in `app/views/shared/_flash.html.erb`. Stimulus auto-dismisses after 5 seconds.

**Structure:**
```erb
<!-- Flash container (Stimulus controller) -->
<div data-controller="flash" class="fixed top-4 right-4 max-w-md z-50">
  <!-- Message element with type-specific styling -->
  <div class="rounded-lg p-4 text-sm font-medium">
    <%= message_text %>
  </div>
</div>
```

**Type Styling:**
- `notice` / `success` → green (bg-green-50, text-green-700)
- `alert` / `error` → red (bg-red-50, text-red-700)
- `warning` → amber (bg-amber-50, text-amber-700)
- `info` → blue (bg-blue-50, text-blue-700)

## Dark Mode Implementation

### Activation

Dark mode controlled by:
- System preference (`prefers-color-scheme`)
- Tailwind CSS `dark:` variant
- CSS class-based toggle (if implemented)

### Tailwind Dark Mode

All color classes must have dark variant:

```erb
<!-- Good: Both modes specified -->
<div class="bg-white dark:bg-gray-900 text-gray-900 dark:text-white">

<!-- Bad: Missing dark variant -->
<div class="bg-white text-gray-900">
```

### Dark Mode Checklist

- [ ] All backgrounds have `dark:bg-*`
- [ ] All text colors have `dark:text-*`
- [ ] All borders have `dark:border-*`
- [ ] Form fields have dark variants
- [ ] Buttons have dark variants
- [ ] Links are visible in both modes
- [ ] Contrast ratio ≥ 4.5:1 (text), ≥ 3:1 (UI components)

### Testing Dark Mode

Chrome DevTools:
1. Inspect element
2. Rendering tab → Emulate CSS media feature
3. Select: `prefers-color-scheme: dark`

## Responsive Design

### Breakpoints

| Breakpoint | Min Width | Tailwind |
|------------|-----------|----------|
| Mobile | 320px | (default) |
| Small | 640px | sm: |
| Medium | 768px | md: |
| Large | 1024px | lg: |
| XL | 1280px | xl: |

### Mobile-First Approach

```erb
<!-- Mobile first, then enhance -->
<div class="block md:hidden">Mobile menu</div>
<div class="hidden md:block">Desktop menu</div>

<!-- Spacing scales -->
<div class="p-4 md:p-6 lg:p-8">
  Content
</div>

<!-- Text size scales -->
<h1 class="text-2xl md:text-3xl lg:text-4xl">Heading</h1>
```

### Container Queries

For responsive components (future enhancement):
```css
@container (min-width: 400px) {
  .component { /* adjust layout */ }
}
```

## Accessibility Guidelines

### WCAG 2.1 AA Compliance

**Color Contrast:**
- Text: 4.5:1 (normal), 3:1 (large 18pt+)
- UI components: 3:1 minimum
- Test with: WebAIM Contrast Checker

**Keyboard Navigation:**
- Tab through interactive elements
- Focus indicators visible (`:focus-ring-2`)
- No keyboard traps

**Screen Readers:**
- Use semantic HTML (`<button>`, `<nav>`, `<section>`)
- Add ARIA labels where needed
- `role="alert"` for error messages
- `aria-live="polite"` for dynamic content

**Forms:**
```erb
<label for="email" class="block text-sm font-semibold mb-2">
  Email Address
</label>
<input id="email" type="email" ... />

<!-- Error messaging -->
<div id="email-error" class="text-sm text-red-600 mt-1" role="alert">
  Email is required
</div>
```

### Focus Management

```css
/* Custom focus ring (Tailwind default is good) */
:focus-visible {
  outline: 2px solid #4F46E5;
  outline-offset: 2px;
}

/* Dark mode focus ring */
:dark:focus-visible {
  outline: 2px solid #818CF8;
}
```

## Animation Guidelines

### Performance-First Approach

Use CSS transitions (avoid JavaScript animations):

```css
.button {
  transition: background-color 200ms ease-in-out;
}

.button:hover {
  background-color: /* new color */;
}
```

### Avoid

- Automatic page animations (jarring UX)
- Slow transitions (>500ms, feels sluggish)
- Animations on load (unless very subtle)
- Too many simultaneous animations

### Recommended Animations

```html
<!-- Button hover/active state (200ms) -->
<button class="transition-colors duration-200 hover:bg-indigo-700">

<!-- Form field focus ring (200ms) -->
<input class="transition-all duration-200 focus:ring-2">

<!-- Flash message fade-out (300ms) -->
<div class="transition-opacity duration-300 opacity-0">
```

## Icon System

### Usage

Currently using Unicode/Emoji for simplicity:
- ✓ (success)
- ✕ (error)
- ⚠ (warning)
- ℹ (info)
- 👁 / 👁️‍🗨️ (password toggle)

### Future: SVG Icons

Consider switching to SVG library (Heroicons, Feather, etc.) for:
- Better scalability
- Consistent rendering
- Custom coloring
- A11y support (role="img", aria-label)

## Page Layout

### Standard Layout Structure

```erb
<%= render 'layouts/application' do %>
  <!-- Header/Navigation -->
  <header>
    <nav class="max-w-7xl mx-auto px-4">
      <!-- navigation items -->
    </nav>
  </header>

  <!-- Main Content -->
  <main class="max-w-7xl mx-auto px-4 py-8">
    <!-- Page-specific content -->
  </main>

  <!-- Flash Messages -->
  <%= render 'shared/flash' %>

  <!-- Footer (optional) -->
  <footer>
    <!-- footer content -->
  </footer>
<% end %>
```

### Max Width Container

```css
.container {
  @apply max-w-7xl mx-auto px-4 sm:px-6 lg:px-8;
}
```

## Custom Components (Future)

Consider extracting to ViewComponent or Stimulus components:
- Form builder with consistent styling
- Flash message component
- Card component
- Button variants component
- Modal/dialog component

## Design Inspiration & References

- **Colors:** Tailwind CSS default palette
- **Typography:** System fonts (OS-native rendering)
- **Icons:** Heroicons, Feather Icons
- **Components:** shadcn/ui patterns
- **Accessibility:** WCAG 2.1 AA, WebAIM guidelines
- **Dark Mode:** Apple Human Interface Guidelines

## Design Asset Files

- Logo/Branding: (not yet created)
- Style Guide: This document
- Component Library: ViewComponent (if implemented)
- Design Tokens: Tailwind config

## Browser Support

- Modern browsers: Chrome, Firefox, Safari, Edge (latest)
- Minimum: CSS Grid, Flexbox, CSS Variables support
- Dark mode: `prefers-color-scheme` media query support
- No IE11 support (intentional - modern only)

## Performance Design Principles

- **No SVG icons inline** (use emoji or Stimulus-loaded icons)
- **No JavaScript animations** (CSS transitions only)
- **Lazy-load images** where applicable
- **Minimize CSS** - Tailwind purges unused classes
- **No decorative animations** on page load
- **No external font loading** (system fonts only)

## Unresolved Design Questions

1. Should we implement a component library (ViewComponent)?
2. Should we customize Tailwind config colors/fonts?
3. Should we add SVG icon system?
4. Should we implement light/dark mode toggle?
5. Should we add animations to form validation?
6. Should we create a more distinctive color scheme?
7. Should we implement a design system documentation (Storybook)?

---

**Last Updated:** 2026-01-13 | **Tailwind Version:** 4.1
