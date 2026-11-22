# TimeRangePicker

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/ng/time-range-picker) · Verified 1.0.0-rc.26 (2026-11-22)

Time-only range picker that lets users select start and end times. Implements `ControlValueAccessor` for form integration. Renders `MznRangePickerTrigger` (dual inputs with arrow separator) and a single `MznTimePanel` in an `MznPopper` for whichever side (start/end) is focused. Requires `MZN_CALENDAR_CONFIG`.

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
| `placeholder` | `string`                          | `''`        | Placeholder for both inputs; falls back to `'HH:mm:ss'` when empty |
| `disabled`    | `boolean`                         | `false`     | Disable the picker                                  |
| `readOnly`    | `boolean`                         | `false`     | Read-only mode                                      |
| `clearable`   | `boolean`                         | `true`      | Show clear button                                   |
| `error`       | `boolean`                         | `false`     | Error state styling                                 |
| `required`    | `boolean`                         | `false`     | Declared but not applied to the rendered inputs     |
| `size`        | `TextFieldSize`                   | `'main'`    | Input field size                                    |
| `fullWidth`   | `boolean`                         | `false`     | Stretch to container width                          |
| `format`      | `string \| undefined`             | —           | Time display format (e.g. `'HH:mm'`); default `'HH:mm'` when `hideSecond`, otherwise `defaultTimeFormat` from `MZN_CALENDAR_CONFIG` |
| `hideHour`    | `boolean`                         | `false`     | Hide hour column                                    |
| `hideMinute`  | `boolean`                         | `false`     | Hide minute column                                  |
| `hideSecond`  | `boolean`                         | `false`     | Hide second column                                  |
| `hourStep`    | `number`                          | `1`         | Hour increment step                                 |
| `minuteStep`  | `number`                          | `1`         | Minute increment step                               |
| `secondStep`  | `number`                          | `1`         | Second increment step                               |

> Inputs declared with signal API (`input()`) accept both static and reactive values.

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
- `TimeRangePicker` renders two inputs (start/end) via `MznRangePickerTrigger`; focusing either input opens one time panel bound to that side. Confirm (OK) commits the focused side only; click-away cancels without committing.
- `format` controls the display string in the text fields; defaults to `'HH:mm'` when `hideSecond` is true, otherwise `defaultTimeFormat` from `MZN_CALENDAR_CONFIG`.
- `MznTimeRangePicker` does not implement `setDisabledState`; `FormControl.disable()` does not disable it. Bind `[disabled]` explicitly.
- Steps control which values appear in columns — a `minuteStep` of `30` shows only 00 and 30.
- `rangeChanged` (and the CVA `onChange`) fires only when both start and end are set, or with `[undefined, undefined]` when the user clears the value. Always guard against `undefined` when reading either slot of the emitted tuple.
