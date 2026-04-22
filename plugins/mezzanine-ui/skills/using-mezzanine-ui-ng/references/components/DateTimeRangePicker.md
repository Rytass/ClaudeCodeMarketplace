# DateTimeRangePicker

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/ng/date-time-range-picker) · Verified 1.0.0-rc.3 (2026-04-21)

Combines two `MznDateTimePicker` components (start and end) with a directional arrow separator. Implements `ControlValueAccessor` for use with `formControl` / `ngModel`. Requires `MZN_CALENDAR_CONFIG`.

## Import

```ts
import { MznDateTimeRangePicker } from '@mezzanine-ui/ng/date-time-range-picker';

import type { RangePickerValue } from '@mezzanine-ui/core/picker';
import type { TextFieldSize }    from '@mezzanine-ui/core/text-field';
import type { DateType }         from '@mezzanine-ui/core/calendar';
```

## Selector

`[mznDateTimeRangePicker]` — component applied to a container element.

## Inputs

| Input              | Type                                           | Default        | Description                                           |
| ------------------ | ---------------------------------------------- | -------------- | ----------------------------------------------------- |
| `value`            | `RangePickerValue \| undefined`                | —              | Controlled value; `RangePickerValue = [DateType \| undefined, DateType \| undefined]` |
| `clearable`        | `boolean`                                      | `true`         | Show clear button                                     |
| `direction`        | `'row' \| 'column'`                            | `'row'`        | Pickers laid out side-by-side or stacked              |
| `disabled`         | `boolean`                                      | `false`        | Disable both pickers                                  |
| `error`            | `boolean`                                      | `false`        | Error/invalid state styling                           |
| `readOnly`         | `boolean`                                      | `false`        | Read-only mode                                        |
| `required`         | `boolean`                                      | `false`        | Required field flag                                   |
| `size`             | `TextFieldSize`                                | `'main'`       | Input field size                                      |
| `fullWidth`        | `boolean`                                      | `false`        | Stretch to container width                            |
| `placeholderLeft`  | `string \| undefined`                          | —              | Placeholder for start datetime picker                 |
| `placeholderRight` | `string \| undefined`                          | —              | Placeholder for end datetime picker                   |
| `formatDate`       | `string \| undefined`                          | —              | Date display format (e.g. `'YYYY/MM/DD'`)             |
| `formatTime`       | `string \| undefined`                          | —              | Time display format (e.g. `'HH:mm'`)                  |
| `hideHour`         | `boolean`                                      | `false`        | Hide hour column in time panel                        |
| `hideMinute`       | `boolean`                                      | `false`        | Hide minute column                                    |
| `hideSecond`       | `boolean`                                      | `false`        | Hide second column                                    |
| `hourStep`         | `number`                                       | `1`            | Hour increment step                                   |
| `minuteStep`       | `number`                                       | `1`            | Minute increment step                                 |
| `secondStep`       | `number`                                       | `1`            | Second increment step                                 |
| `isDateDisabled`   | `((date: DateType) => boolean) \| undefined`   | —              | Disable specific dates                                |

> Inputs declared with signal API (`input()`, `model()`) accept both static and reactive values.

## Outputs

| Output         | Type                              | Description                            |
| -------------- | --------------------------------- | -------------------------------------- |
| `rangeChanged` | `OutputEmitterRef<RangePickerValue>` | Fires when either picker value changes |

## ControlValueAccessor

Yes — supports `formControl`, `formControlName`, and `ngModel`.

The bound value is `RangePickerValue` which is a tuple `[DateType | undefined, DateType | undefined]` (start, end). Either slot may be `undefined` when the user has not yet selected that date/time.

```html
<!-- Template-driven -->
<div mznDateTimeRangePicker [(ngModel)]="dateRange"></div>

<!-- Reactive forms -->
<div mznDateTimeRangePicker [formControl]="dateRangeCtrl"></div>
```

```ts
import { FormControl } from '@angular/forms';
import type { RangePickerValue } from '@mezzanine-ui/core/picker';

readonly dateRangeCtrl = new FormControl<RangePickerValue | null>(null);

// Read value
const [start, end] = this.dateRangeCtrl.value ?? [];
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

- Requires `MZN_CALENDAR_CONFIG` to be provided at the application root (see [Calendar](./Calendar.md)). Note: `MznDateTimeRangePicker` itself does **not** `inject()` the token directly — it is consumed by the nested `MznDateTimePicker` instances. Provide `MznCalendarConfigProvider` at the app root so those inner components can access it.
- `RangePickerValue` is `[DateType | undefined, DateType | undefined]`. Either slot may be `undefined`. Writing `null` to the form control is valid and represents no selection.
- The `direction='column'` layout stacks the two pickers vertically, useful for narrow containers.
- Format strings follow the conventions of the underlying calendar adapter (e.g. dayjs format tokens: `YYYY`, `MM`, `DD`, `HH`, `mm`, `ss`).
- Unlike the React counterpart which requires `DateTimeRangePickerPanel` for the panel, the Angular version encapsulates the popover internally.
