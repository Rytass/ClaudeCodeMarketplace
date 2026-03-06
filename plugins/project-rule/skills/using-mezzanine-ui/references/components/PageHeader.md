# PageHeader Component

> **Category**: Navigation
>
> **Storybook**: `Navigation/PageHeader`
>
> **Source Verification**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/react/src/PageHeader)

Page header component for displaying page-level navigation and titles. Contains breadcrumb and content header.

## Import

```tsx
import { PageHeader } from '@mezzanine-ui/react';
import type { PageHeaderProps } from '@mezzanine-ui/react';
```

---

## Type Definitions

```ts
type PageHeaderChild =
  | ReactElement<BreadcrumbProps>
  | ReactElement<ContentHeaderProps>
  | null | undefined | false;

type PageHeaderProps = NativeElementPropsWithoutKeyAndRef<'header'> & {
  children?: PageHeaderChild | PageHeaderChild[];
};
```

---

## PageHeader Props

> Extends `NativeElementPropsWithoutKeyAndRef<'header'>`.

| Property   | Type                                  | Default | Description                                  |
| ---------- | ------------------------------------- | ------- | -------------------------------------------- |
| `children` | `PageHeaderChild \| PageHeaderChild[]`| -       | Breadcrumb and/or ContentHeader sub-components |

---

## Child Component Requirements

PageHeader only accepts the following child components:
- **Breadcrumb**: Breadcrumb navigation (at most one)
- **ContentHeader**: Content header (must have one)

> **Note**: `ContentHeader` is not exported from the `@mezzanine-ui/react` main entry; it must be imported from `@mezzanine-ui/react/ContentHeader`.

Note: ContentHeader's `size` is automatically set to `'main'`.

---

## Usage Examples

### Basic Usage

```tsx
import { PageHeader, Breadcrumb, Button } from '@mezzanine-ui/react';
import ContentHeader from '@mezzanine-ui/react/ContentHeader';

<PageHeader>
  <Breadcrumb
    items={[
      { name: 'Home', href: '/' },
      { name: 'Product Management', href: '/products' },
      { name: 'Add Product' },
    ]}
  />
  <ContentHeader
    title="Add Product"
    description="Fill in the information below to add a product"
  >
    <Button variant="base-secondary">Cancel</Button>
    <Button>Save</Button>
  </ContentHeader>
</PageHeader>
```

### With Back Button

```tsx
<PageHeader>
  <Breadcrumb
    items={[
      { name: 'Home', href: '/' },
      { name: 'Settings' },
    ]}
  />
  <ContentHeader
    title="Account Settings"
    onBackClick={() => router.back()}
  >
    <Button>Save Changes</Button>
  </ContentHeader>
</PageHeader>
```

### Without Breadcrumb

```tsx
<PageHeader>
  <ContentHeader
    title="Dashboard"
    description="Welcome back"
  >
    <Button>Add Report</Button>
  </ContentHeader>
</PageHeader>
```

### With Search and Filter

```tsx
<PageHeader>
  <Breadcrumb
    items={[
      { name: 'Home', href: '/' },
      { name: 'Order Management' },
    ]}
  />
  <ContentHeader
    title="Order List"
    filter={{
      variant: 'search',
      placeholder: 'Search orders...',
      onChange: handleSearch,
    }}
  >
    <Button variant="base-secondary">Export</Button>
    <Button>Add Order</Button>
  </ContentHeader>
</PageHeader>
```

---

## Component Structure

```
+------------------------------------------------------+
| PageHeader                                            |
| +--------------------------------------------------+ |
| | Breadcrumb                                        | |
| | Home > Product Management > Add Product           | |
| +--------------------------------------------------+ |
| +--------------------------------------------------+ |
| | ContentHeader                                     | |
| | [Back] Add Product    [Search] [Secondary] [Primary]| |
| |        Fill in the information...                 | |
| +--------------------------------------------------+ |
+------------------------------------------------------+
```

---

## Figma Mapping

| Figma Variant                     | React Props                              |
| --------------------------------- | ---------------------------------------- |
| `PageHeader / With Breadcrumb`    | Includes Breadcrumb                      |
| `PageHeader / Without Breadcrumb` | Does not include Breadcrumb              |
| `PageHeader / With Back`          | ContentHeader has `onBackClick`          |
| `PageHeader / With Actions`       | ContentHeader has children (buttons)     |

---

## Best Practices

1. **Must have ContentHeader**: PageHeader must contain a ContentHeader
2. **Breadcrumb is optional**: Breadcrumb is optional, but recommended when there is navigation hierarchy
3. **Size auto-set**: ContentHeader's size is automatically set to main
4. **Semantic**: Renders as a `<header>` element
5. **Responsive**: Consider hiding some elements on small screens
