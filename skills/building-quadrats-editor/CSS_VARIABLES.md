# Quadrats CSS Variables Reference

Quadrats uses CSS Custom Properties (CSS variables) to control theme styling. All variables are prefixed with `--qdr-`.

## Installing Theme Styles

```bash
npm install @quadrats/theme
```

```scss
// Import default theme (light)
@import '@quadrats/theme/src/qdr.scss';

// Import dark theme
@import '@quadrats/theme/src/qdr-dark.scss';

// Or import both
@import '@quadrats/theme/src/qdr.scss';
@import '@quadrats/theme/src/qdr-dark.scss';
```

---

## Applying Themes

Use `ConfigsProvider` to apply the theme class:

```tsx
import { ConfigsProvider } from '@quadrats/react/configs';

<ConfigsProvider theme="light">
  {({ theme: { props: { className } } }) => (
    <div className={className}>
      {/* className = "qdr-theme-light" */}
      <Quadrats editor={editor} value={value} onChange={setValue}>
        <Editable />
      </Quadrats>
    </div>
  )}
</ConfigsProvider>
```

Or add the class manually:

```html
<div class="qdr-theme-light">
  <!-- Editor content -->
</div>

<div class="qdr-theme-dark">
  <!-- Dark theme -->
</div>
```

---

## Color Variables

### Primary

| Variable                    | Light Mode                        | Dark Mode                          | Description              |
|-----------------------------|-----------------------------------|------------------------------------|--------------------------|
| `--qdr-primary`             | `#465bc7`                         | `#4767eb`                          | Primary color            |
| `--qdr-primary-light`       | `#778de8`                         | `#6882ef`                          | Primary light            |
| `--qdr-primary-dark`        | `#2d2d9e`                         | `#3249a7`                          | Primary dark             |
| `--qdr-on-primary`          | `#fff`                            | `#fff`                             | Text on primary          |
| `--qdr-primary-hover-bg`    | `rgba(119, 141, 232, 0.15)`      | `rgba(104, 130, 239, 0.15)`       | Primary hover background |
| `--qdr-primary-active-bg`   | `rgba(70, 91, 199, 0.2)`         | `rgba(71, 103, 235, 0.2)`         | Primary active background|

### Secondary

| Variable                    | Light Mode  | Dark Mode   | Description           |
|-----------------------------|-------------|-------------|-----------------------|
| `--qdr-secondary`           | `#383838`   | `#585858`   | Secondary color       |
| `--qdr-secondary-light`     | `#6a6a6a`   | `#b5b5b5`   | Secondary light       |
| `--qdr-secondary-dark`      | `#161616`   | `#3e3e3e`   | Secondary dark        |
| `--qdr-on-secondary`        | `#fff`      | `#fff`      | Text on secondary     |

### Status Colors

| Variable                | Light Mode  | Dark Mode   | Description    |
|-------------------------|-------------|-------------|----------------|
| `--qdr-error`           | `#fb414a`   | `#ff4d4f`   | Error          |
| `--qdr-error-light`     | `#ff6461`   | `#ff6d6f`   | Error light    |
| `--qdr-error-dark`      | `#cf1322`   | `#d94143`   | Error dark     |
| `--qdr-warning`         | `#f7ac38`   | `#f7ac38`   | Warning        |
| `--qdr-warning-light`   | `#fdd948`   | `#f8bb5c`   | Warning light  |
| `--qdr-warning-dark`    | `#f1842b`   | `#af7a28`   | Warning dark   |
| `--qdr-success`         | `#00b42a`   | `#1ac61a`   | Success        |
| `--qdr-success-light`   | `#23c343`   | `#43cf43`   | Success light  |
| `--qdr-success-dark`    | `#009a29`   | `#128b12`   | Success dark   |

### Text Colors

| Variable                | Light Mode  | Dark Mode   | Description     |
|-------------------------|-------------|-------------|-----------------|
| `--qdr-text-primary`    | `#161616`   | `#fff`      | Primary text    |
| `--qdr-text-secondary`  | `#8f8f8f`   | `#8c8c8c`   | Secondary text  |
| `--qdr-text-disabled`   | `#bcbcbc`   | `#595959`   | Disabled text   |

### Action States

| Variable                    | Light Mode  | Dark Mode   | Description          |
|-----------------------------|-------------|-------------|----------------------|
| `--qdr-action-active`       | `#161616`   | `#fff`      | Active state         |
| `--qdr-action-inactive`     | `#8f8f8f`   | `#8c8c8c`   | Inactive state       |
| `--qdr-action-disabled`     | `#bcbcbc`   | `#595959`   | Disabled state       |
| `--qdr-action-disabled-bg`  | `#e5e5e5`   | `#393939`   | Disabled background  |

### Background Colors

| Variable         | Light Mode  | Dark Mode   | Description      |
|------------------|-------------|-------------|------------------|
| `--qdr-surface`  | `#fff`      | `#242424`   | Surface background |
| `--qdr-block`    | `#fafafa`   | `#1a1a1a`   | Block background   |
| `--qdr-bg`       | `#f5f5f5`   | `#0a0a0a`   | Page background    |

### Borders and Dividers

| Variable         | Light Mode  | Dark Mode   | Description |
|------------------|-------------|-------------|-------------|
| `--qdr-divider`  | `#e7e7e7`   | `#333`      | Divider     |
| `--qdr-border`   | `#d9d9d9`   | `#434343`   | Border      |

### Overlays

| Variable               | Light Mode                   | Dark Mode                    | Description    |
|------------------------|------------------------------|------------------------------|----------------|
| `--qdr-overlay-dark`   | `rgba(22, 22, 22, 0.5)`     | `rgba(0, 0, 0, 0.5)`        | Dark overlay   |
| `--qdr-overlay-light`  | `rgba(255, 255, 255, 0.9)`  | `rgba(36, 36, 36, 0.9)`     | Light overlay  |

---

## Spacing Variables

| Variable           | Value       | Description |
|--------------------|-------------|-------------|
| `--qdr-spacing-0`  | `0`         | No spacing  |
| `--qdr-spacing-1`  | `0.165rem`  | 2.64px      |
| `--qdr-spacing-2`  | `0.25rem`   | 4px         |
| `--qdr-spacing-3`  | `0.375rem`  | 6px         |
| `--qdr-spacing-4`  | `0.5rem`    | 8px         |
| `--qdr-spacing-5`  | `0.625rem`  | 10px        |
| `--qdr-spacing-6`  | `0.75rem`   | 12px        |
| `--qdr-spacing-7`  | `1rem`      | 16px        |
| `--qdr-spacing-8`  | `1.25rem`   | 20px        |
| `--qdr-spacing-9`  | `1.5rem`    | 24px        |
| `--qdr-spacing-10` | `1.75rem`   | 28px        |
| `--qdr-spacing-11` | `2rem`      | 32px        |
| `--qdr-spacing-12` | `2.25rem`   | 36px        |
| `--qdr-spacing-13` | `2.5rem`    | 40px        |
| `--qdr-spacing-14` | `3rem`      | 48px        |
| `--qdr-spacing-18` | `5rem`      | 80px        |
| `--qdr-spacing-19` | `6rem`      | 96px        |

---

## Border Radius Variables

| Variable          | Value      | Description |
|-------------------|------------|-------------|
| `--qdr-radius-1`  | `0.25rem`  | 4px         |
| `--qdr-radius-2`  | `0.375rem` | 6px         |
| `--qdr-radius-3`  | `0.5rem`   | 8px         |
| `--qdr-radius-4`  | `0.625rem` | 10px        |
| `--qdr-radius-5`  | `0.75rem`  | 12px        |
| `--qdr-radius-6`  | `1rem`     | 16px        |

---

## Modal Sizes

| Variable                | Value   | Description  |
|-------------------------|---------|--------------|
| `--qdr-modal-size-s`    | `420px` | Small modal  |
| `--qdr-modal-size-m`    | `540px` | Medium modal |
| `--qdr-modal-size-l`    | `720px` | Large modal  |
| `--qdr-modal-size-xl`   | `100%`  | Full-width modal |

---

## Typography (Article)

For article content:

### Headings

| Variable    | H1    | H2      | H3       | H4       | H5   | H6       |
|-------------|-------|---------|----------|----------|------|----------|
| `font-size` | 2rem  | 1.5rem  | 1.3125rem| 1.125rem | 1rem | 0.8125rem|
| `line-height`| 1.4  | 1.4     | 1.45     | 1.45     | 1.5  | 1.5      |
| `font-weight`| 600  | 600     | 600      | 600      | 600  | 600      |

```scss
// Usage
.my-h1 {
  font-size: var(--qdr-typography-article-h1-font-size);
  line-height: var(--qdr-typography-article-h1-line-height);
  font-weight: var(--qdr-typography-article-h1-font-weight);
  letter-spacing: var(--qdr-typography-article-h1-letter-spacing);
}
```

### Body Text

| Variable Prefix | font-size   | line-height | font-weight |
|-----------------|-------------|-------------|-------------|
| `body1`         | 1rem        | 1.65        | 400         |
| `body2`         | 0.8125rem   | 1.7         | 400         |
| `subtitle1`     | 1rem        | 1.5         | 400         |

---

## Typography (Basic)

For UI components:

### Buttons and Inputs

| Variable Prefix | font-size   | line-height | font-weight |
|-----------------|-------------|-------------|-------------|
| `button1`       | 0.9375rem   | 2.65        | 500         |
| `button2`       | 0.9375rem   | 2.15        | 500         |
| `button3`       | 0.8125rem   | 1.85        | 500         |
| `input1`        | 0.9375rem   | 2.65        | 400         |
| `input2`        | 0.9375rem   | 2.15        | 400         |
| `input3`        | 0.8125rem   | 1.85        | 400         |

---

## Component-Specific CSS Variables

### Image

```scss
// Image alignment (automatically set by element.align)
--qdr-image-align: flex-start | center | flex-end;
--qdr-image-caption-align: left | center | right;

// Usage example
.qdr-image__figure {
  display: flex;
  justify-content: var(--qdr-image-align);
}

.qdr-image__caption {
  text-align: var(--qdr-image-caption-align);
}
```

---

## Custom Themes

### Overriding Variables

```scss
.qdr-theme-light {
  // Override primary color
  --qdr-primary: #1890ff;
  --qdr-primary-light: #40a9ff;
  --qdr-primary-dark: #096dd9;

  // Override backgrounds
  --qdr-surface: #fefefe;
  --qdr-bg: #f0f2f5;
}
```

### Creating a Custom Theme

Using the SCSS mixin:

```scss
@use '@quadrats/theme/theming/register' as *;
@use '@quadrats/theme/theming/palettes' as *;
@use '@quadrats/theme/theming/spacing' as *;

// Custom palette
$my-palette: (
  primary: #1890ff,
  primary-light: #40a9ff,
  primary-dark: #096dd9,
  on-primary: #fff,
  // ... other colors
);

// Register theme
@include qdr-theme('my-custom', map-merge($palette-light, $my-palette));

// Usage
// <div class="qdr-theme-my-custom">
```

### Pure CSS Custom Theme

```css
.qdr-theme-custom {
  /* Colors */
  --qdr-primary: #6366f1;
  --qdr-primary-light: #818cf8;
  --qdr-primary-dark: #4f46e5;
  --qdr-on-primary: #fff;

  --qdr-text-primary: #1f2937;
  --qdr-text-secondary: #6b7280;

  --qdr-surface: #fff;
  --qdr-bg: #f9fafb;
  --qdr-border: #e5e7eb;
  --qdr-divider: #f3f4f6;

  /* Spacing (if adjustments needed) */
  --qdr-spacing-7: 1.25rem;
  --qdr-spacing-14: 3.5rem;

  /* Border radius */
  --qdr-radius-3: 0.75rem;
}
```

---

## Tailwind CSS Integration

```js
// tailwind.config.js
module.exports = {
  theme: {
    extend: {
      colors: {
        qdr: {
          primary: 'var(--qdr-primary)',
          'primary-light': 'var(--qdr-primary-light)',
          'primary-dark': 'var(--qdr-primary-dark)',
          surface: 'var(--qdr-surface)',
          bg: 'var(--qdr-bg)',
          border: 'var(--qdr-border)',
          'text-primary': 'var(--qdr-text-primary)',
          'text-secondary': 'var(--qdr-text-secondary)',
        },
      },
      spacing: {
        'qdr-7': 'var(--qdr-spacing-7)',
        'qdr-14': 'var(--qdr-spacing-14)',
      },
      borderRadius: {
        'qdr-3': 'var(--qdr-radius-3)',
      },
    },
  },
};
```

```tsx
// Usage
<div className="bg-qdr-surface text-qdr-text-primary border-qdr-border">
  Content
</div>
```

---

## Default CSS Classes

CSS classes generated by Quadrats components:

| Element     | Class                                          |
|-------------|------------------------------------------------|
| Paragraph   | `qdr-paragraph`                                |
| Heading     | `qdr-h1` ~ `qdr-h6`                           |
| Blockquote  | `qdr-blockquote`                               |
| Divider     | `qdr-divider`                                  |
| Link        | `qdr-link`                                     |
| Image       | `qdr-image`, `qdr-image__figure`, `qdr-image__caption` |
| Table       | `qdr-table`, `qdr-table-cell`                  |
| List        | `qdr-list`, `qdr-list-item`                    |
| ReadMore    | `qdr-read-more`                                |
| Card        | `qdr-card`                                     |
| Carousel    | `qdr-carousel`                                 |
| Highlight   | `qdr-highlight`, `qdr-highlight--{variant}`    |
