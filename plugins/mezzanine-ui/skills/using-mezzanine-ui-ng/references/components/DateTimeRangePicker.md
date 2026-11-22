# DateTimeRangePicker

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/ng/date-time-range-picker) · Verified 1.0.0-rc.26 (2026-11-22)

Combines two `MznDateTimePicker` components (start and end) with a directional arrow separator. Implements `ControlValueAccessor` for use with `formControl` / `ngModel`. Requires `MZN_CALENDAR_CONFIG`.

## Import

```ts
import { MznDateTimeRangePicker, type RangePickerValue } from '@mezzanine-ui/ng/date-time-range-picker';
import type { TextFieldSize }    from '@mezzanine-ui/core/text-field';
import type { DateType }         from '@mezzanine-ui/core/calendar';
```

## Selector

`[mznDateTimeRangePicker]` — component applied to a container element.

## Inputs

| Input              | Type                                           | Default        | Description                                           |
| ------------------ | ---------------------------------------------- | -------------- | ----------------------------------------------------- |
| `value`            | `RangePickerValue \| undefined`                | —              | Controlled value; `RangePickerValue = undefined[] \| [DateType, DateType]` (from `@mezzanine-ui/core/picker`); applied only when truthy |
| `clearable`        | `boolean`                                      | `true`         | Show clear button                                     |
| `direction`        | `'row' \| 'column'`                            | `'row'`        | Pickers laid out side-by-side or stacked              |
| `disabled`         | `boolean`                                      | `false`        | Disable both pickers                                  |
| `error`            | `boolean`                                      | `false`        | Error/invalid state styling                           |
| `readOnly`         | `boolean`                                      | `false`        | Read-only mode                                        |
| `required`         | `boolean`                                      | `false`        | Required field flag                                   |
| `size`             | `TextFieldSize`                                | `'main'`       | Input field size                                      |
| `fullWidth`        | `boolean`                                      | `false`        | Stretch to container width                            |
| `placeholderLeft`  | `string \| undefined`                          | —              | Placeholder of the date input of each inner `MznDateTimePicker` (applied to both start and end; falls back to `formatDate`) |
| `placeholderRight` | `string \| undefined`                          | —              | Placeholder of the time input of each inner `MznDateTimePicker` (applied to both start and end; falls back to `formatTime`) |
| `formatDate`       | `string \| undefined`                          | —              | Date display format (e.g. `'YYYY/MM/DD'`)             |
| `formatTime`       | `string \| undefined`                          | —              | Time display format (e.g. `'HH:mm'`)                  |
| `hideHour`         | `boolean`                                      | `false`        | Hide hour column in time panel                        |
| `hideMinute`       | `boolean`                                      | `false`        | Hide minute column                                    |
| `hideSecond`       | `boolean`                                      | `false`        | Hide second column                                    |
| `hourStep`         | `number`                                       | `1`            | Hour increment step                                   |
| `minuteStep`       | `number`                                       | `1`            | Minute increment step                                 |
| `secondStep`       | `number`                                       | `1`            | Second increment step                                 |
| `isDateDisabled`   | `((date: DateType) => boolean) \| undefined`   | —              | Disable specific dates                                |

> Inputs declared with signal API (`input()`) accept both static and reactive values.

## Outputs

| Output         | Type                              | Description                            |
| -------------- | --------------------------------- | -------------------------------------- |
| `rangeChanged` | `OutputEmitterRef<RangePickerValue>` | Fires when either picker value changes |

## ControlValueAccessor

Yes — supports `formControl`, `formControlName`, and `ngModel`.

The bound value is `RangePickerValue` (`undefined[] | [DateType, DateType]`, i.e. `[start, end]`). At runtime either slot may be `undefined` while the user has only picked one side (the component emits `[from, undefined]` / `[undefined, to]`), but the declared type does not model that.

```html
<!-- Template-driven -->
<div mznDateTimeRangePicker [(ngModel)]="dateRange"></div>

<!-- Reactive forms -->
<div mznDateTimeRangePicker [formControl]="dateRangeCtrl"></div>

<!-- formControlName -->
<form [formGroup]="form">
  <div mznDateTimeRangePicker formControlName="period"></div>
</form>
```

```ts
import { FormControl } from '@angular/forms';
import type { RangePickerValue } from '@mezzanine-ui/ng/date-time-range-picker';

readonly dateRangeCtrl = new FormControl<RangePickerValue | null>(null);

// Read value
const [start, end] = this.dateRangeCtrl.value ?? [undefined, undefined];
```

## Usage

```html
<!-- Basic reactive form usage -->
<div mznDateTimeRangePicker
  [formControl]="dateRangeCtrl"
  placeholderLeft="開始日期時間"
  placeholderRight="結束日期時間"
  [hideSecond]="true"
  (rangeChanged)="onRangeChange($event)"
></div>

<!-- Column layout (stacked) -->
<div mznDateTimeRangePicker
  [(ngModel)]="dateRange"
  direction="column"
  [formatDate]="'YYYY/MM/DD'"
  [formatTime]="'HH:mm'"
></div>
```

## Notes

- Requires `MZN_CALENDAR_CONFIG` to be provided at the application root (see [Calendar](./Calendar.md)). Note: `MznDateTimeRangePicker` itself does **not** `inject()` the token directly — it is consumed by the nested `MznDateTimePicker` instances. Provide an `MZN_CALENDAR_CONFIG` provider at the app root (or wrap with the `[mznCalendarConfigProvider]` directive) so those inner components can access it.
- `RangePickerValue` is declared as `undefined[] | [DateType, DateType]`; partial selections are emitted as `[from, undefined]` / `[undefined, to]`. Writing `null` / `undefined` to the form control resets both slots.
- `placeholderLeft` / `placeholderRight` are forwarded identically to both inner pickers; they are the date / time input placeholders, not start / end placeholders.
- The component does not implement `setDisabledState`; disable via the `[disabled]` input. Internal `imports`: `MznDateTimePicker`, `MznIcon`. `(rangeChanged)` fires whenever either picker changes.
- The `direction='column'` layout stacks the two pickers vertically, useful for narrow containers.
- Format strings follow the conventions of the underlying calendar adapter (e.g. dayjs format tokens: `YYYY`, `MM`, `DD`, `HH`, `mm`, `ss`).
- Unlike the React counterpart which requires `DateTimeRangePickerPanel` for the panel, the Angular version encapsulates the popover internally.
