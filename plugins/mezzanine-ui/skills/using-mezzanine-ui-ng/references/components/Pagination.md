# Pagination

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/ng/pagination) · Verified 1.0.0-rc.3 (2026-04-21)

Navigation control for paged datasets. Automatically computes page items (previous, number pages, ellipses, next) from `total`, `pageSize`, `current`, `boundaryCount` and `siblingCount`. Optionally renders a page-size selector and a jump-to-page input.

## Import

```ts
import { MznPagination } from '@mezzanine-ui/ng/pagination';
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

## Notes

- Page items are computed entirely inside an `items` signal — there is no network request or async involved. Keep `total` and `current` reactive to see updates immediately.
- `current` is a plain `input(1)` — one-way binding only. Two-way binding is not supported; listen to `(pageChanged)` and update the parent state manually (e.g. `(pageChanged)="page = $event"`). This differs from some React pagination patterns where `current` participates in controlled state.
- `itemTemplate` is resolved via `contentChild<TemplateRef<{ $implicit: PaginationItem }>>('itemTemplate')` — name the template reference `#itemTemplate` to match.
- Unlike the React counterpart's `onChange` prop, Angular uses `pageChanged` output to avoid clashing with native DOM events.
