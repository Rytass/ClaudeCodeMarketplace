# Pagination Component

> **Category**: Data Display
>
> **Storybook**: `Data Display/Pagination`
>
> **Source Verification**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/react/src/Pagination) | Verified: 2026-03-06

Pagination component for paginated navigation of long data lists.

## Import

```tsx
import {
  Pagination,
  PaginationItem,
  PaginationJumper,
  PaginationPageSize,
  usePagination,
} from '@mezzanine-ui/react';
import type {
  PaginationProps,
  PaginationItemProps,
  PaginationItemType,
  PaginationJumperProps,
  PaginationPageSizeProps,
} from '@mezzanine-ui/react';
```

> `PaginationItemType` is actually re-exported from `@mezzanine-ui/core/pagination`.

---

## Pagination Props

Extends `DetailedHTMLProps<HTMLAttributes<HTMLElement>, HTMLElement>` (excluding `onChange`).

| Property                   | Type                                          | Default                                 | Description                       |
| -------------------------- | --------------------------------------------- | --------------------------------------- | --------------------------------- |
| `boundaryCount`            | `number`                                      | `1`                                     | Pages always shown at start/end   |
| `buttonText`               | `string`                                      | -                                       | Jumper button text                |
| `current`                  | `number`                                      | `1`                                     | Current page number               |
| `disabled`                 | `true`                                        | -                                       | Whether disabled (literal type)   |
| `hintText`                 | `string`                                      | -                                       | Hint text before jumper input     |
| `inputPlaceholder`         | `string`                                      | -                                       | Jumper input placeholder          |
| `itemRender`               | `(item: PaginationItemProps) => ReactNode`    | `(item) => <PaginationItem {...item}>` | Custom page item render           |
| `onChange`                 | `(page: number) => void`                      | -                                       | Page change event                 |
| `onChangePageSize`         | `PaginationPageSizeProps['onChange']`          | -                                       | Page size change event            |
| `pageSize`                 | `PaginationPageSizeProps['value']`             | `10`                                    | Items per page                    |
| `pageSizeLabel`            | `PaginationPageSizeProps['label']`             | -                                       | Page size label                   |
| `pageSizeOptions`          | `PaginationPageSizeProps['options']`           | -                                       | Page size options                 |
| `renderPageSizeOptionName` | `PaginationPageSizeProps['renderOptionName']`  | -                                       | Custom page size option name      |
| `renderResultSummary`      | `(from: number, to: number, total: number) => string` | -                              | Custom result summary             |
| `showJumper`               | `boolean`                                     | `false`                                 | Whether to show page jumper       |
| `showPageSizeOptions`      | `boolean`                                     | `false`                                 | Whether to show page size selector|
| `siblingCount`             | `number`                                      | `1`                                     | Pages shown before/after current  |
| `total`                    | `number`                                      | `0`                                     | Total number of items             |

---

## PaginationItemProps

Extends HTML attributes (excluding `ref`).

| Property   | Type                 | Default  | Description            |
| ---------- | -------------------- | -------- | ---------------------- |
| `active`   | `boolean`            | `false`  | Whether current page   |
| `disabled` | `boolean`            | `false`  | Whether disabled       |
| `page`     | `number`             | `1`      | Page number            |
| `type`     | `PaginationItemType` | `'page'` | Item type              |

### PaginationItemType

```tsx
type PaginationItemType = 'page' | 'ellipsis' | 'previous' | 'next' | string;
```

---

## PaginationJumperProps

Extends `DetailedHTMLProps<HTMLAttributes<HTMLDivElement>, HTMLDivElement>` (excluding `onChange`).

| Property           | Type                      | Default | Description                  |
| ------------------ | ------------------------- | ------- | ---------------------------- |
| `buttonText`       | `string`                  | -       | Button text                  |
| `disabled`         | `true`                    | -       | Whether disabled             |
| `hintText`         | `string`                  | -       | Hint text before input       |
| `inputPlaceholder` | `string`                  | -       | Input placeholder            |
| `onChange`         | `(page: number) => void`  | -       | Page change callback         |
| `pageSize`         | `number`                  | `5`     | Items per page (defaults to 5 when standalone; controlled by Pagination's pageSize when inside Pagination, default 10) |
| `total`            | `number`                  | `0`     | Total number of items        |

---

## PaginationPageSizeProps

Extends HTML div attributes.

| Property           | Type                          | Default                       | Description            |
| ------------------ | ----------------------------- | ----------------------------- | ---------------------- |
| `disabled`         | `boolean`                     | `false`                       | Whether disabled       |
| `label`            | `string`                      | -                             | Label text             |
| `onChange`         | `(pageSize: number) => void`  | -                             | Page size change callback |
| `options`          | `number[]`                    | `[10, 20, 50, 100]`          | Size options           |
| `renderOptionName` | `(pageSize: number) => string`| `` (p) => `${p}` ``         | Custom option name     |
| `value`            | `number`                      | -                             | Current size value     |

---

## usePagination Hook

```tsx
const { items } = usePagination(options);
```

### UsePaginationParams

| Property             | Type                      | Default | Description                |
| -------------------- | ------------------------- | ------- | -------------------------- |
| `boundaryCount`      | `number`                  | `1`     | Pages shown at start/end   |
| `current`            | `number`                  | `1`     | Current page               |
| `disabled`           | `boolean`                 | `false` | Whether all disabled       |
| `hideFirstButton`    | `boolean`                 | -       | Hide first page button     |
| `hideLastButton`     | `boolean`                 | -       | Hide last page button      |
| `hideNextButton`     | `boolean`                 | -       | Hide next page button      |
| `hidePreviousButton` | `boolean`                 | -       | Hide previous page button  |
| `onChange`           | `(page: number) => void`  | -       | Page change callback       |
| `pageSize`           | `number`                  | `10`    | Items per page             |
| `siblingCount`       | `number`                  | `1`     | Pages before/after current |
| `total`              | `number`                  | `0`     | Total number of items      |

### Return Value

| Property | Type                    | Description                           |
| -------- | ----------------------- | ------------------------------------- |
| `items`  | `PaginationItemProps[]` | Pagination item array with events and state |

Each item contains: `active`, `page`, `type`, `disabled`, `onClick`, `aria-current`, `aria-disabled`, `aria-label`.

---

## Usage Examples

### Basic Usage

```tsx
import { Pagination } from '@mezzanine-ui/react';
import { useState } from 'react';

function BasicPagination() {
  const [current, setCurrent] = useState(1);

  return (
    <Pagination
      current={current}
      total={100}
      onChange={setCurrent}
    />
  );
}
```

### With Page Size Selector

```tsx
function PaginationWithPageSize() {
  const [current, setCurrent] = useState(1);
  const [pageSize, setPageSize] = useState(10);

  return (
    <Pagination
      current={current}
      total={200}
      pageSize={pageSize}
      onChange={setCurrent}
      showPageSizeOptions
      pageSizeOptions={[10, 20, 50, 100]}
      pageSizeLabel="Items per page"
      onChangePageSize={setPageSize}
    />
  );
}
```

### With Page Jumper

```tsx
<Pagination
  current={current}
  total={500}
  onChange={setCurrent}
  showJumper
  hintText="Go to"
  buttonText="Jump"
  inputPlaceholder="Page"
/>
```

### Custom Result Summary

```tsx
<Pagination
  current={current}
  total={100}
  pageSize={10}
  onChange={setCurrent}
  renderResultSummary={(from, to, total) =>
    `Showing ${from}-${to} of ${total} items`
  }
/>
```

### Full Features

```tsx
function FullPagination() {
  const [current, setCurrent] = useState(1);
  const [pageSize, setPageSize] = useState(20);
  const total = 500;

  return (
    <Pagination
      current={current}
      total={total}
      pageSize={pageSize}
      onChange={setCurrent}
      onChangePageSize={setPageSize}
      showPageSizeOptions
      pageSizeOptions={[10, 20, 50]}
      pageSizeLabel="Per page"
      showJumper
      hintText="Go to"
      buttonText="Go"
      renderResultSummary={(from, to, total) =>
        `${from}-${to} / ${total}`
      }
    />
  );
}
```

### Disabled State

```tsx
<Pagination
  current={1}
  total={100}
  disabled
/>
```

### Using usePagination Hook

```tsx
import { usePagination, PaginationItem } from '@mezzanine-ui/react';

function CustomPagination() {
  const [current, setCurrent] = useState(1);
  const { items } = usePagination({
    current,
    total: 200,
    pageSize: 10,
    onChange: setCurrent,
  });

  return (
    <nav>
      {items.map((item, index) => (
        <PaginationItem key={index} {...item} />
      ))}
    </nav>
  );
}
```

---

## Figma Mapping

| Figma Variant                 | React Props                |
| ----------------------------- | -------------------------- |
| `Pagination / Basic`          | Basic configuration        |
| `Pagination / With Page Size` | `showPageSizeOptions`      |
| `Pagination / With Jumper`    | `showJumper`               |
| `Pagination / With Summary`   | `renderResultSummary`      |
| `Pagination / Disabled`       | `disabled`                 |

---

## Best Practices

1. **Provide total count**: `total` is required for correct page calculation
2. **Controlled mode**: Use `current` and `onChange` for controlled behavior
3. **Show jumper for large datasets**: Enable `showJumper` when data volume is large
4. **Custom summary**: Use `renderResultSummary` to provide clear information
5. **Appropriate pageSize options**: Set reasonable options based on data type
