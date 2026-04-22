# TimeRangePicker

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/ng/time-range-picker) · Verified 1.0.0-rc.3 (2026-04-21)

Time-only range picker that lets users select start and end times. Implements `ControlValueAccessor` for form integration. Backed by `MznTimePanel` internally. Requires `MZN_CALENDAR_CONFIG`.

## Import

```ts
import { MznTimeRangePicker } from '@mezzanine-ui/ng/time-range-picker';

import type { RangePickerValue } from '@mezzanine-ui/core/picker';
import type { TextFieldSize }    from '@mezzanine-ui/core/text-field';
```

## Selector

`[mznTimeRangePicker]` — component applied to a container element.

## Inputs

| Input         | Type                              | Default     | Description                                         |
| ------------- | --------------------------------- | ----------- | --------------------------------------------------- |
| `value`       | `RangePickerValue \| undefined`   | —           | Controlled range tuple — `[DateType \| undefined, DateType \| undefined]`; either slot may be `undefined` |
| `placeholder` | `string`                          | `''`        | Placeholder text shown in the input field           |
| `disabled`    | `boolean`                         | `false`     | Disable the picker                                  |
| `readOnly`    | `boolean`                         | `false`     | Read-only mode                                      |
| `clearable`   | `boolean`                         | `true`      | Show clear button                                   |
| `error`       | `boolean`                         | `false`     | Error state styling                                 |
| `required`    | `boolean`                         | `false`     | Required field flag                                 |
| `size`        | `TextFieldSize`                   | `'main'`    | Input field size                                    |
| `fullWidth`   | `boolean`                         | `false`     | Stretch to container width                          |
| `format`      | `string \| undefined`             | —           | Time display format (e.g. `'HH:mm'`)               |
| `hideHour`    | `boolean`                         | `false`     | Hide hour column                                    |
| `hideMinute`  | `boolean`                         | `false`     | Hide minute column                                  |
| `hideSecond`  | `boolean`                         | `false`     | Hide second column                                  |
| `hourStep`    | `number`                          | `1`         | Hour increment step                                 |
| `minuteStep`  | `number`                          | `1`         | Minute increment step                               |
| `secondStep`  | `number`                          | `1`         | Second increment step                               |

> Inputs declared with signal API (`input()`, `model()`) accept both static and reactive values.

## Outputs

| Output          | Type                              | Description                           |
| --------------- | --------------------------------- | ------------------------------------- |
| `rangeChanged`  | `OutputEmitterRef<RangePickerValue>` | Fires when range value changes      |
| `panelToggled`  | `OutputEmitterRef<boolean>`       | Fires when panel opens (`true`) or closes (`false`) |

## ControlValueAccessor

Yes — supports `formControl`, `formControlName`, and `ngModel`.

Bound value is `RangePickerValue` — tuple shape `[DateType | undefined, DateType | undefined]`. Each slot may independently be `undefined` (e.g. between Start selection and End selection).

```html
<!-- Template-driven -->
<div mznTimeRangePicker [(ngModel)]="timeRange" [hideSecond]="true"></div>

<!-- Reactive forms -->
<div mznTimeRangePicker [formControl]="timeRangeCtrl" [minuteStep]="15"></div>
```

```ts
import { FormControl } from '@angular/forms';
import type { RangePickerValue } from '@mezzanine-ui/core/picker';

readonly timeRangeCtrl = new FormControl<RangePickerValue | null>(null);
```

## Usage

```html
<!-- Basic usage -->
<div mznTimeRangePicker
  [(ngModel)]="timeRange"
  placeholder="選擇時間範圍"
  [hideSecond]="true"
  [minuteStep]="15"
></div>

<!-- Reactive form with validation -->
<div mznTimeRangePicker
  [formControl]="timeRangeCtrl"
  [error]="timeRangeCtrl.invalid && timeRangeCtrl.touched"
></div>
```

## Notes

- Requires `MZN_CALENDAR_CONFIG` — see [Calendar](./Calendar.md) for setup.
- Unlike `DateTimeRangePicker` which renders two separate picker inputs, `TimeRangePicker` renders a single combined input that opens a panel with two time columns (start/end).
- `format` controls the display string in the text field; defaults to the `defaultTimeFormat` from `MZN_CALENDAR_CONFIG`.
- Steps control which values appear in columns — a `minuteStep` of `30` shows only 00 and 30.
- `rangeChanged` fires with `[undefined, undefined]` when the user clears the value, not only when both times are confirmed. Always guard against `undefined` when reading either slot of the emitted tuple.
