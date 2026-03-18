# ContentHeader Component

> **Category**: Internal (internal component, not exported from main entry)
>
> **Storybook**: `Internal/ContentHeader`
>
> **Source Verification**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/react/src/ContentHeader) · Verified v2 source (2026-03-18)

> **Important**: `ContentHeader` is not exported from the `@mezzanine-ui/react` main entry (`index.ts`). This is an internal component primarily used internally by `PageHeader`. If you need to use it directly, import from the sub-path.

Content header component for displaying title, description, filters, and action buttons.

## Import

```tsx
// ContentHeader is not exported from the main entry; import from sub-path
import ContentHeader from '@mezzanine-ui/react/ContentHeader';
import type { ContentHeaderProps } from '@mezzanine-ui/react/ContentHeader';
```

---

## ContentHeader Props

| Property         | Type                                      | Default    | Description                     |
| ---------------- | ----------------------------------------- | ---------- | ------------------------------- |
| `actions`        | `ButtonProps[]`                           | -          | Action button configuration     |
| `children`       | `ContentHeaderChild[]`                    | -          | Child elements                  |
| `description`    | `string`                                  | -          | Description text                |
| `filter`         | `FilterProps`                             | -          | Filter component configuration  |
| `onBackClick`    | `() => void`                              | -          | Back button click (only available when `size='main'`; `never` when `size='sub'`) |
| `size`           | `'main' \| 'sub'`                         | `'main'`   | Size                            |
| `title`          | `string`                                  | **required** | Title text                    |
| `titleComponent` | `'h1' \| 'h2' \| 'h3' \| 'h4' \| 'h5' \| 'h6' \| 'p'` | by size | Title HTML element    |
| `utilities`      | `(ButtonProps \| DropdownProps)[]`        | -          | Utility button configuration    |

---

## Supported children Types

- **Back button**: Element with `href` attribute (e.g., `<a>` or `<Link>`)
- **Filter component**: SearchInput, Select, SegmentedControl, Toggle, Checkbox
- **Action buttons**: Button (auto-sorted by variant)
- **Utility buttons**: Button with icon (icon-only)
- **Dropdown menu**: Dropdown (for overflow actions)

---

## filter Props

```tsx
type FilterProps = {
  variant: 'search' | 'select' | 'segmentedControl' | 'toggle' | 'checkbox';
} & (SearchInputProps | SelectProps | SegmentedControlProps | ToggleProps | CheckboxProps);
```

---

## Usage Examples

### Basic Usage

```tsx
import ContentHeader from '@mezzanine-ui/react/ContentHeader';
import { Button } from '@mezzanine-ui/react';

<ContentHeader title="Product List">
  <Button variant="base-secondary">Export</Button>
  <Button>Add Product</Button>
</ContentHeader>
```

### With Description

```tsx
<ContentHeader
  title="Account Settings"
  description="Manage your account information and preferences"
>
  <Button>Save Changes</Button>
</ContentHeader>
```

### With Back Button

```tsx
<ContentHeader
  title="Edit Product"
  onBackClick={() => router.back()}
>
  <Button variant="base-secondary">Cancel</Button>
  <Button>Save</Button>
</ContentHeader>
```

### With Filter Component (using props)

```tsx
<ContentHeader
  title="Order Management"
  filter={{
    variant: 'search',
    placeholder: 'Search orders...',
    onChange: handleSearch,
  }}
  actions={[
    { children: 'Export', variant: 'base-secondary', onClick: handleExport },
    { children: 'Add Order', onClick: handleAdd },
  ]}
/>
```

### With Filter Component (using children)

```tsx
<ContentHeader title="User Management">
  <Input variant="search" placeholder="Search users..." onChange={handleSearch} />
  <Button variant="base-secondary">Export</Button>
  <Button>Add User</Button>
</ContentHeader>
```

### With Utility Buttons

```tsx
import { PlusIcon, FilterIcon, DotHorizontalIcon } from '@mezzanine-ui/icons';

<ContentHeader
  title="Reports"
  utilities={[
    { icon: PlusIcon, onClick: handleAdd },
    { icon: FilterIcon, onClick: handleFilter },
  ]}
>
  <Button>Generate Report</Button>
</ContentHeader>
```

### With Overflow Menu

```tsx
<ContentHeader title="Settings">
  <Dropdown
    options={[
      { id: 'export', name: 'Export' },
      { id: 'import', name: 'Import' },
      { id: 'reset', name: 'Reset' },
    ]}
    onSelect={handleMenuSelect}
  >
    <Button icon={DotHorizontalIcon} iconType="icon-only" />
  </Dropdown>
  <Button>Save</Button>
</ContentHeader>
```

### Using Link as Back Button

```tsx
import Link from 'next/link';

<ContentHeader title="Product Details">
  <Link href="/products" title="back" />
  <Button>Edit</Button>
</ContentHeader>
```

### Sub Size

```tsx
<ContentHeader
  size="sub"
  title="Sub-section Title"
  description="Sub-section description text"
>
  <Button size="sub">Action</Button>
</ContentHeader>
```

---

## Component Structure

```
┌──────────────────────────────────────────────────────────────┐
│ ContentHeader                                                │
│ ┌──────────────────────┬───────────────────────────────────┐ │
│ │ Title Area           │ Action Area                       │ │
│ │ [←] Title            │ [Search] [Secondary] [Primary] [Util] [⋮] │ │
│ │     Description      │                                   │ │
│ └──────────────────────┴───────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────┘
```

---

## Button Auto-Sorting

Buttons in children are automatically sorted by variant:
1. `destructive-secondary` -> sorted to the leftmost
2. `base-secondary` -> sorted in the middle
3. `base-primary` (default) -> sorted to the rightmost

Buttons without a specified variant (i.e., `variant` is `undefined`) are also rendered, treated as `base-primary` for sorting. Only buttons with `destructive-secondary`, `base-secondary`, and `base-primary` (including `undefined`) variants are rendered; other variants are filtered out with a console warning.

---

## Figma Mapping

| Figma Variant                      | React Props                              |
| ---------------------------------- | ---------------------------------------- |
| `ContentHeader / Main`             | `size="main"` (default)                  |
| `ContentHeader / Sub`              | `size="sub"`                             |
| `ContentHeader / With Back`        | `onBackClick` or children has href element |
| `ContentHeader / With Description` | `description` has value                  |
| `ContentHeader / With Filter`      | `filter` or children has SearchInput/Select |
| `ContentHeader / With Actions`     | `actions` or children has Button         |
| `ContentHeader / With Utilities`   | `utilities` or children has icon-only Button |

---

## Best Practices

1. **title is required**: ContentHeader must have a title
2. **Flexible usage**: Can be configured via props or children
3. **Props take priority**: When both are set, props take priority over children
4. **Size matching**: Button sizes should match the ContentHeader size
5. **Semantic**: Renders as a `<header>` element
