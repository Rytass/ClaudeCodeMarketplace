# Breadcrumb Component

> **Category**: Navigation
>
> **Storybook**: `Navigation/Breadcrumb`
>
> **Source Verification**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/react/src/Breadcrumb)

Breadcrumb component for displaying hierarchical page navigation paths.

## Import

```tsx
import { Breadcrumb } from '@mezzanine-ui/react';
import type { BreadcrumbProps, BreadcrumbItemProps } from '@mezzanine-ui/react';
```

> **Note**: `BreadcrumbItem` component is not exported from `@mezzanine-ui/react` main entry. Use `items` array or children mode with the `BreadcrumbItemProps` type.

---

## Type Definitions

```ts
type BreadcrumbItemComponent = 'a' | 'span' | JSXElementConstructor<any>;

type BreadcrumbProps = Omit<NativeElementPropsWithoutKeyAndRef<'nav'>, 'children'> & (
  | { condensed?: boolean; items: BreadcrumbItemProps[]; children?: never }
  | { condensed?: boolean; items?: never; children: ReactElement<BreadcrumbItemProps> | ReactElement<BreadcrumbItemProps>[] }
);

type BreadcrumbItemProps<C extends BreadcrumbItemComponent = 'span'> =
  | ComponentOverridableForwardRefComponentPropsFactory<...>  // Text or link
  | BreadcrumbDropdownProps;                                   // Dropdown
```

---

## Breadcrumb Props

| Property    | Type                                                        | Default | Description                               |
| ----------- | ----------------------------------------------------------- | ------- | ----------------------------------------- |
| `condensed` | `boolean`                                                   | -       | Condensed mode, shows only last two items |
| `items`     | `BreadcrumbItemProps[]`                                     | -       | Items array (mutually exclusive with children) |
| `children`  | `ReactElement<BreadcrumbItemProps> \| ReactElement<...>[]`  | -       | BreadcrumbItem elements                   |
| `className` | `string`                                                    | -       | Custom CSS class                          |

> Extends `nav` element native attributes (excluding `children`).

---

## BreadcrumbItem Props

### Text Item (BreadcrumbItemTextProps)

| Property    | Type       | Default  | Description                   |
| ----------- | ---------- | -------- | ----------------------------- |
| `component` | `'span'`   | `'span'` | Renders as text               |
| `name`      | `string`   | required | Item name                     |
| `current`   | `boolean`  | -        | Whether current page          |
| `id`        | `string`   | -        | Unique identifier             |
| `href`      | `never`    | -        | Not available for text items  |
| `onClick`   | `never`    | -        | Not available for text items  |
| `target`    | `never`    | -        | Not available for text items  |

### Link Item (BreadcrumbLinkItemProps)

| Property    | Type                                                  | Default  | Description        |
| ----------- | ----------------------------------------------------- | -------- | ------------------ |
| `component` | `'a'`                                                 | -        | Renders as link    |
| `name`      | `string`                                              | required | Item name          |
| `href`      | `string`                                              | required | Link URL           |
| `target`    | `'_blank' \| '_parent' \| '_self' \| '_top' \| string` | -      | Link target        |
| `current`   | `boolean`                                             | -        | Whether current page |
| `id`        | `string`                                              | -        | Unique identifier  |
| `onClick`   | `() => void`                                          | -        | Click event        |

> Extends `a` element native attributes (excluding `children`), such as `rel`.

### Dropdown Item (BreadcrumbDropdownProps)

| Property    | Type             | Default  | Description              |
| ----------- | ---------------- | -------- | ------------------------ |
| `name`      | `string`         | required | Item name                |
| `className` | `string`         | -        | Custom CSS class         |
| `current`   | `boolean`        | -        | Whether current page     |
| `id`        | `string`         | -        | Unique identifier        |
| `open`      | `boolean`        | -        | Whether dropdown is open |
| `onClick`   | `() => void`     | -        | Click event              |

> Extends `DropdownProps` (excluding `children`). `href` and `target` are `never`.

---

## Usage Examples

### Using items Array

```tsx
import { Breadcrumb } from '@mezzanine-ui/react';

const items = [
  { name: 'Home', href: '/' },
  { name: 'Products', href: '/products' },
  { name: 'Details', href: '/products/123' },
];

<Breadcrumb items={items} />
```

### Using children

> **Note**: `BreadcrumbItem` is not exported from the main entry. Prefer using the `items` array mode.

```tsx
import { Breadcrumb } from '@mezzanine-ui/react';

// Recommended: use items array
<Breadcrumb items={[
  { name: 'Home', href: '/' },
  { name: 'Products', href: '/products' },
  { name: 'Details' },
]} />
```

### Condensed Mode

When items exceed 4, middle items are automatically collapsed. Enabling `condensed` shows only the last two items.

```tsx
const items = [
  { name: 'Home', href: '/' },
  { name: 'Category', href: '/category' },
  { name: 'Sub Category', href: '/category/sub' },
  { name: 'Products', href: '/products' },
  { name: 'Details' },
];

// Auto collapse
<Breadcrumb items={items} />

// Condensed mode: shows only last two items + ellipsis menu
<Breadcrumb items={items} condensed />
```

### With Click Events

```tsx
const items = [
  {
    name: 'Home',
    href: '/',
    onClick: () => console.log('Go home'),
  },
  {
    name: 'Product List',
    href: '/products',
    onClick: () => console.log('Go products'),
  },
  { name: 'Details' },
];

<Breadcrumb items={items} />
```

### Open in New Window

```tsx
const items = [
  { name: 'Home', href: '/', target: '_blank' },
  { name: 'Products' },
];

<Breadcrumb items={items} />
```

---

## Auto Collapse Rules

- **4 items or fewer**: All displayed
- **More than 4 items**: First 2 + ellipsis menu + last 2
- **Condensed mode**: Ellipsis menu + last 2

---

## Figma Mapping

| Figma Variant                 | React Props              |
| ----------------------------- | ------------------------ |
| `Breadcrumb / Default`        | Basic configuration      |
| `Breadcrumb / Condensed`      | `condensed`              |
| `Breadcrumb / With Overflow`  | Auto collapse with 4+ items |

---

## Best Practices

1. **No link on last item**: Current page item doesn't need `href`
2. **Use meaningful names**: Item names should clearly express hierarchy
3. **Use condensed mode appropriately**: Consider `condensed` for deep hierarchies
4. **Start with home**: Breadcrumbs typically start from the home page
5. **Pair with routing**: Can be combined with React Router for dynamic generation
