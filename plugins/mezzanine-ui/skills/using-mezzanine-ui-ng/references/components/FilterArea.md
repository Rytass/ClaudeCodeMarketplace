# FilterArea

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/ng/filter-area) · Verified 1.0.0-rc.4 (2026-04-24)

Multi-row filter form container with built-in expand/collapse and submit/reset actions. Composes `MznFilterLine` rows (each containing `MznFilter` field wrappers). By default only the first row is visible; additional rows are revealed with an expand toggle.

## Import

```ts
import {
  MznFilterArea,
  MznFilterLine,
  MznFilter,
} from '@mezzanine-ui/ng/filter-area';

import type {
  FilterAreaSize,
  FilterAlign,
  FilterAreaActionsAlign,
  FilterAreaRowAlign,
  FilterSpan,
} from '@mezzanine-ui/core/filter-area';
```

## Selectors

| Selector           | Role                                                          |
| ------------------ | ------------------------------------------------------------- |
| `[mznFilterArea]`  | Container; manages expand/collapse, submit/reset              |
| `[mznFilterLine]`  | Single row of filter fields                                   |
| `[mznFilter]`      | Individual field wrapper with span/alignment controls         |

## MznFilterArea — Inputs

| Input               | Type                     | Default     | Description                                                 |
| ------------------- | ------------------------ | ----------- | ----------------------------------------------------------- |
| `size`              | `FilterAreaSize`         | `'main'`    | Propagated to all child form inputs via DI context          |
| `submitText`        | `string`                 | `'Search'`  | Submit button label                                         |
| `resetText`         | `string`                 | `'Reset'`   | Reset button label                                          |
| `isDirty`           | `boolean`                | `true`      | When `false`, reset button is disabled                      |
| `actionsAlign`      | `FilterAreaActionsAlign` | `'end'`     | `'start' \| 'end'` — button row alignment                  |
| `rowAlign`          | `FilterAreaRowAlign`     | `'center'`  | Vertical alignment of items within a row                    |
| `submitButtonType`  | `'button' \| 'submit' \| 'reset'` | `'button'` | HTML button type for submit               |
| `resetButtonType`   | `'button' \| 'submit' \| 'reset'` | `'button'` | HTML button type for reset                |

> Inputs declared with signal API (`input()`, `model()`) accept both static and reactive values.

## MznFilterArea — Outputs

| Output          | Type                    | Description              |
| --------------- | ----------------------- | ------------------------ |
| `filterSubmit`  | `OutputEmitterRef<void>` | Submit button clicked   |
| `filterReset`   | `OutputEmitterRef<void>` | Reset button clicked    |

## MznFilter — Inputs

| Input      | Type           | Default     | Description                                                          |
| ---------- | -------------- | ----------- | -------------------------------------------------------------------- |
| `span`     | `FilterSpan`   | `2`         | Column span within the 6-column grid row (1–6)                      |
| `grow`     | `boolean`      | `false`     | Allow field to grow and fill remaining space (overrides `span`)      |
| `align`    | `FilterAlign`  | `'stretch'` | Vertical alignment: `'stretch' \| 'center'`                         |
| `minWidth` | `string`       | —           | Optional minimum width of the field (e.g. `'200px'`); sets `min-width` inline style |

## ControlValueAccessor

No — `MznFilterArea` is a layout container. Use standard form controls (`formControl`, `ngModel`) on the input elements projected inside `mznFilter`.

## Usage

```html
<!-- Basic filter area with two rows -->
<div mznFilterArea
  submitText="搜尋"
  resetText="重設"
  [isDirty]="form.dirty"
  (filterSubmit)="onSearch()"
  (filterReset)="onReset()"
>
  <!-- First row (always visible) -->
  <div mznFilterLine>
    <div mznFilter [span]="2">
      <label>關鍵字</label>
      <input mznInput [formControl]="keywordCtrl" />
    </div>
    <div mznFilter [span]="2">
      <label>狀態</label>
      <div mznSelect [formControl]="statusCtrl" [options]="statusOptions"></div>
    </div>
  </div>

  <!-- Second row (hidden by default, revealed on expand) -->
  <div mznFilterLine>
    <div mznFilter [span]="3">
      <label>日期範圍</label>
      <div mznDateRangePicker [formControl]="dateRangeCtrl"></div>
    </div>
  </div>
</div>
```

```ts
import { MznFilterArea, MznFilterLine, MznFilter } from '@mezzanine-ui/ng/filter-area';
import { FormControl, FormGroup } from '@angular/forms';

readonly form = new FormGroup({
  keyword: new FormControl(''),
  status: new FormControl<string | null>(null),
  dateRange: new FormControl(null),
});

get keywordCtrl(): FormControl { return this.form.get('keyword') as FormControl; }
get statusCtrl(): FormControl { return this.form.get('status') as FormControl; }

onSearch(): void {
  const values = this.form.value;
  // perform search with values
}

onReset(): void {
  this.form.reset();
}
```

## MznFilterLine

`MznFilterLine` has no public inputs. It auto-hides non-first rows via the `MZN_FILTER_AREA_CONTEXT` DI token: when the parent `[mznFilterArea]`'s `expanded` state is `false`, any `[mznFilterLine]` that is not the first sibling sets `display: none` on its host. No explicit input is required on `[mznFilterLine]` itself.

## Notes

- `MznFilterArea` injects `size` to child components via `MZN_FILTER_AREA_CONTEXT`. Input components inside `mznFilter` that read this context will automatically resize.
- `FilterSpan` ranges from `1` to `6` (six-column grid). The previous "1–4" documentation was incorrect.
- Multi-row expand/collapse is automatic: when more than one `[mznFilterLine]` is projected, a chevron toggle button appears. The first row is always visible.
- `isDirty=false` disables the reset button — useful when the form is in its default state.
- `actionsAlign='end'` right-aligns the submit/reset group; `'start'` left-aligns it. The actions are always on the last rendered row next to the filter fields.
