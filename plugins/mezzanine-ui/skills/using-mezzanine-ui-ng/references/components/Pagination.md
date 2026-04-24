# Pagination

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/ng/pagination) · Verified 1.0.0-rc.4 (2026-04-24)

Navigation control for paged datasets. Automatically computes page items (previous, number pages, ellipses, next) from `total`, `pageSize`, `current`, `boundaryCount` and `siblingCount`. Optionally renders a page-size selector and a jump-to-page input.

## Import

```ts
import {
  MznPagination,
  MznPaginationItem,
  MznPaginationJumper,
  MznPaginationPageSize,
} from '@mezzanine-ui/ng/pagination';
import type { PaginationItem } from '@mezzanine-ui/ng/pagination';
```

## Selector

`[mznPagination]` — component applied to a `<nav>` element.

## Inputs

| Input                     | Type                                              | Default     | Description                                           |
| ------------------------- | ------------------------------------------------- | ----------- | ----------------------------------------------------- |
| `total`                   | `number`                                          | `0`         | Total number of records                               |
| `current`                 | `number`                                          | `1`         | Current page (1-based)                                |
| `pageSize`                | `number`                                          | `10`        | Records per page                                      |
| `boundaryCount`           | `number`                                          | `1`         | Pages always shown at start and end                   |
| `siblingCount`            | `number`                                          | `1`         | Pages shown on each side of current                   |
| `disabled`                | `boolean`                                         | `false`     | Disables all controls                                 |
| `showJumper`              | `boolean`                                         | `false`     | Show jump-to-page input                               |
| `buttonText`              | `string \| undefined`                             | —           | Jumper submit button text                             |
| `hintText`                | `string \| undefined`                             | —           | Jumper prefix hint text                               |
| `inputPlaceholder`        | `string \| undefined`                             | —           | Jumper input placeholder                              |
| `showPageSizeOptions`     | `boolean`                                         | `false`     | Show per-page selector                                |
| `pageSizeLabel`           | `string \| undefined`                             | —           | Per-page selector label                               |
| `pageSizeOptions`         | `ReadonlyArray<number> \| undefined`              | —           | Per-page option values                                |
| `renderPageSizeOptionName`| `((pageSize: number) => string) \| undefined`     | —           | Customise per-page option display string              |
| `renderResultSummary`     | `((from: number, to: number, total: number) => string) \| undefined` | — | Render result count summary text   |
| `itemTemplate`            | `TemplateRef<{ $implicit: PaginationItem }>`      | —           | Custom template for individual page items             |

> Inputs declared with signal API (`input()`, `model()`) accept both static and reactive values.

## Outputs

| Output           | Type                        | Description                         |
| ---------------- | --------------------------- | ----------------------------------- |
| `pageChanged`    | `OutputEmitterRef<number>`  | Fires when user navigates to a page |
| `pageSizeChanged`| `OutputEmitterRef<number>`  | Fires when per-page size changes    |

## ControlValueAccessor

No — `MznPagination` is a navigation control, not a form field.

## Usage

```html
<!-- Basic -->
<nav mznPagination
  [total]="200"
  [current]="page"
  [pageSize]="20"
  (pageChanged)="page = $event"
></nav>

<!-- With jumper and page-size selector -->
<nav mznPagination
  [total]="total"
  [current]="page"
  [pageSize]="pageSize"
  [showJumper]="true"
  [showPageSizeOptions]="true"
  [pageSizeOptions]="[10, 20, 50]"
  [renderPageSizeOptionName]="formatPageSize"
  [renderResultSummary]="formatSummary"
  (pageChanged)="page = $event"
  (pageSizeChanged)="pageSize = $event"
></nav>

<!-- Custom item template -->
<nav mznPagination [total]="100" [current]="page" (pageChanged)="page = $event">
  <ng-template #itemTemplate let-item>
    <button [disabled]="item.disabled" (click)="page = item.page">{{ item.page }}</button>
  </ng-template>
</nav>
```

```ts
import { MznPagination } from '@mezzanine-ui/ng/pagination';

page = 1;
pageSize = 20;
total = 200;

formatPageSize(size: number): string {
  return `${size} 筆`;
}

formatSummary(from: number, to: number, total: number): string {
  return `顯示 ${from}–${to}，共 ${total} 筆`;
}
```

## Subcomponents

These primitives back the equivalent React pagination children. `MznPagination` composes them internally; export them directly for fully custom pagination shells.

### MznPaginationItem

Renders a single pagination button — a page number, `'previous'` / `'next'` chevron, or an `'ellipsis'` marker.

#### Selector

`[mznPaginationItem]` — attribute-directive component

#### Inputs — MznPaginationItem

| Input      | Type                  | Default  | Description                                      |
| ---------- | --------------------- | -------- | ------------------------------------------------ |
| `active`   | `boolean`             | `false`  | Marks the current page (sets `aria-current`)     |
| `disabled` | `boolean`             | `false`  | Disabled state                                   |
| `page`     | `number`              | `1`      | Page number label (ignored for non-`page` types) |
| `type`     | `PaginationItemType`  | `'page'` | `'page' \| 'previous' \| 'next' \| 'ellipsis'`   |

#### Outputs — MznPaginationItem

| Output      | Type                     | Description                                             |
| ----------- | ------------------------ | ------------------------------------------------------- |
| `itemClick` | `OutputEmitterRef<void>` | Emitted on click; suppressed for `ellipsis` / disabled  |

### MznPaginationJumper

Jump-to-page control — a numeric input plus a submit button. Emits `pageChanged` only for integers inside `[1, totalPages]`, where `totalPages = ceil(total / pageSize)`. The input is cleared after every submit attempt (valid or not).

#### Selector

`[mznPaginationJumper]` — attribute-directive component

#### Inputs — MznPaginationJumper

| Input              | Type                    | Default  | Description                                  |
| ------------------ | ----------------------- | -------- | -------------------------------------------- |
| `buttonText`       | `string \| undefined`   | —        | Submit button label                          |
| `disabled`         | `boolean`               | `false`  | Disabled state                               |
| `hintText`         | `string \| undefined`   | —        | Prefix hint text rendered before the input   |
| `inputPlaceholder` | `string \| undefined`   | —        | Placeholder for the numeric input            |
| `pageSize`         | `number`                | `10`     | Records per page; used to compute page count |
| `total`            | `number`                | `0`      | Total record count                           |

#### Outputs — MznPaginationJumper

| Output        | Type                       | Description                                          |
| ------------- | -------------------------- | ---------------------------------------------------- |
| `pageChanged` | `OutputEmitterRef<number>` | Fires when the user submits a valid page number      |

### MznPaginationPageSize

Per-page size selector — renders an optional label and a `MznSelect` dropdown.

#### Selector

`[mznPaginationPageSize]` — attribute-directive component

#### Inputs — MznPaginationPageSize

| Input              | Type                                            | Default  | Description                                     |
| ------------------ | ----------------------------------------------- | -------- | ----------------------------------------------- |
| `disabled`         | `boolean`                                       | `false`  | Disabled state                                  |
| `label`            | `string \| undefined`                           | —        | Text rendered before the select                 |
| `options`          | `ReadonlyArray<number> \| undefined`            | —        | Available page sizes; falls back to `[10, 20, 50, 100]` |
| `renderOptionName` | `((pageSize: number) => string) \| undefined`   | —        | Custom formatter for each option's display name |
| `value`            | `number`                                        | `10`     | Currently selected page size                    |

#### Outputs — MznPaginationPageSize

| Output            | Type                       | Description                                  |
| ----------------- | -------------------------- | -------------------------------------------- |
| `pageSizeChanged` | `OutputEmitterRef<number>` | Fires when the selected page size changes    |

## Notes

- Page items are computed entirely inside an `items` signal — there is no network request or async involved. Keep `total` and `current` reactive to see updates immediately.
- `current` is a plain `input(1)` — one-way binding only. Two-way binding is not supported; listen to `(pageChanged)` and update the parent state manually (e.g. `(pageChanged)="page = $event"`). This differs from some React pagination patterns where `current` participates in controlled state.
- `itemTemplate` is resolved via `contentChild<TemplateRef<{ $implicit: PaginationItem }>>('itemTemplate')` — name the template reference `#itemTemplate` to match.
- Unlike the React counterpart's `onChange` prop, Angular uses `pageChanged` output to avoid clashing with native DOM events.
