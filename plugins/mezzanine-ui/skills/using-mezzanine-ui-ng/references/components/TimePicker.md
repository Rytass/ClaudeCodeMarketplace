# TimePicker

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/ng/time-picker) · Verified 1.0.0-rc.3 (2026-04-21)
>
> **Storybook**: https://storybook-ng.mezzanine-ui.org/?path=/docs/data-entry-time-picker--docs

A time picker with a formatted input field that opens a scrollable `MznTimePickerPanel` on focus. The panel has Ok/Cancel footer buttons — changes remain *pending* until Ok is clicked. Supports direct keyboard typing in the input (character-by-character mask). When the panel opens with no current value it initialises to the current time rounded to the nearest step. Implements `ControlValueAccessor` binding `DateType | undefined`. Requires `MZN_CALENDAR_CONFIG`.

## Import

```ts
import { MznTimePicker, MznTimePickerPanel } from '@mezzanine-ui/ng/time-picker';
import type { DateType } from '@mezzanine-ui/core/calendar';

// Required provider:
import { MznCalendarConfigProvider } from '@mezzanine-ui/ng/calendar';
```

## Selector

`<div mznTimePicker ...>` — attribute-directive component

## Inputs

| Input         | Type                  | Default    | Description                                                             |
| ------------- | --------------------- | ---------- | ----------------------------------------------------------------------- |
| `value`       | `DateType`            | —          | Controlled time value (use CVA in forms instead)                        |
| `placeholder` | `string`              | `''`       | Input placeholder text                                                  |
| `disabled`    | `boolean`             | `false`    | Disabled state                                                          |
| `readOnly`    | `boolean`             | `false`    | Read-only state                                                         |
| `clearable`   | `boolean`             | `true`     | Show clear button                                                       |
| `error`       | `boolean`             | `false`    | Error state styling                                                     |
| `fullWidth`   | `boolean`             | `false`    | Stretch to container width                                              |
| `hideHour`    | `boolean`             | `false`    | Hide hour scroll column                                                 |
| `hideMinute`  | `boolean`             | `false`    | Hide minute scroll column                                               |
| `hideSecond`  | `boolean`             | `false`    | Hide second scroll column; also changes default format to `'HH:mm'`    |
| `hourStep`    | `number`              | `1`        | Hour column scroll step                                                 |
| `minuteStep`  | `number`              | `1`        | Minute column scroll step                                               |
| `secondStep`  | `number`              | `1`        | Second column scroll step                                               |
| `size`        | `TextFieldSize`       | `'main'`   | `'main' \| 'sub'`                                                       |
| `format`      | `string`              | —          | Explicit display format; overrides `hideSecond` shortcut                |
| `required`    | `boolean`             | `false`    | Required state                                                          |

> Inputs declared with signal API (`input()`) accept both static and reactive values.

## Outputs

| Output         | Type                                   | Description                                 |
| -------------- | -------------------------------------- | ------------------------------------------- |
| `timeChanged`  | `OutputEmitterRef<DateType \| undefined>` | Emitted when the committed time changes  |
| `panelToggled` | `OutputEmitterRef<boolean>`            | Emitted when the time panel opens or closes |

## ControlValueAccessor

`MznTimePicker` implements `ControlValueAccessor` binding `DateType | undefined`.

```html
<!-- formControlName -->
<form [formGroup]="form">
  <div mznTimePicker formControlName="meetingTime" [hideSecond]="true"></div>
</form>

<!-- formControl -->
<div mznTimePicker [formControl]="alarmCtrl" [hourStep]="1" [minuteStep]="5"></div>

<!-- ngModel -->
<div mznTimePicker
  [(ngModel)]="openingTime"
  placeholder="HH:mm"
  [hideSecond]="true">
</div>
```

`writeValue(DateType | undefined)` stores the value in `internalValue`. `null`/`undefined` clears the selection. CVA's `onChange` fires on two paths: panel Confirm click and direct keyboard-typed input (when the full typed value parses successfully).

## Two-Phase Commit

The component maintains an `internalValue` / `pendingValue` signal pair:

- **`pendingValue`** — live value while the panel is open; initialised to `internalValue` (or current time if unset) on panel open
- **`internalValue`** — the last confirmed value; drives the input display and CVA
- Clicking **Ok** → `pendingValue` is committed to `internalValue`, `onChange` fires, panel closes
- Clicking **Cancel** or pressing **Escape** → `pendingValue` is discarded, panel closes
- Pressing **Enter** while the panel is open confirms the pending value

Typed input bypasses the panel and commits directly via `onTriggerValueChange`.

## Required Provider

```ts
// app.config.ts
import { MznCalendarConfigProvider } from '@mezzanine-ui/ng/calendar';

export const appConfig: ApplicationConfig = {
  providers: [
    MznCalendarConfigProvider({ firstDayOfWeek: 1, locale: 'zh-TW' }),
  ],
};
```

## Usage

```html
<!-- Appointment time with minute step and no seconds -->
<div mznFormField name="appointmentTime" label="Time">
  <div mznTimePicker
    formControlName="appointmentTime"
    placeholder="Select time"
    [hideSecond]="true"
    [minuteStep]="15"
    [fullWidth]="true"
    (timeChanged)="onTimeSelected($event)">
  </div>
</div>

<!-- Opening hours picker with hour step -->
<div mznTimePicker
  [(ngModel)]="openTime"
  [hourStep]="1"
  [minuteStep]="30"
  [hideSecond]="true">
</div>
```

```ts
import { MznTimePicker } from '@mezzanine-ui/ng/time-picker';
import type { DateType } from '@mezzanine-ui/core/calendar';
import { ReactiveFormsModule, FormGroup, FormControl, Validators } from '@angular/forms';

@Component({
  imports: [MznTimePicker, MznFormField, ReactiveFormsModule],
})
export class AppointmentFormComponent {
  readonly form = new FormGroup({
    appointmentTime: new FormControl<DateType | undefined>(undefined, Validators.required),
  });

  onTimeSelected(time: DateType | undefined): void {
    console.log('Time confirmed:', time);
  }
}
```

## MznTimePickerPanel

The floating time-picker panel. Wraps `MznTimePanel` inside `MznPopper`. Normally composed by `MznTimePicker` but publicly exported for standalone use (e.g. embedding the panel in a custom layout).

**Selector**: `[mznTimePickerPanel]`

| Input                | Type                                               | Default          | Description                              |
| -------------------- | -------------------------------------------------- | ---------------- | ---------------------------------------- |
| `anchor`             | `HTMLElement \| ElementRef<HTMLElement> \| null`   | `null`           | Anchor element for Popper positioning    |
| `open`               | `boolean`                                          | `false`          | Whether the panel is visible             |
| `value`              | `DateType \| undefined`                            | —                | Current time value displayed in the panel |
| `hideHour`           | `boolean`                                          | `false`          | Hide hour scroll column                  |
| `hideMinute`         | `boolean`                                          | `false`          | Hide minute scroll column                |
| `hideSecond`         | `boolean`                                          | `false`          | Hide second scroll column                |
| `hourStep`           | `number`                                           | `1`              | Hour column step                         |
| `minuteStep`         | `number`                                           | `1`              | Minute column step                       |
| `secondStep`         | `number`                                           | `1`              | Second column step                       |
| `popperPlacement`    | `PopperPlacement`                                  | `'bottom-start'` | Popper placement direction               |
| `popperOffsetOptions`| `PopperOffsetOptions`                              | `{ mainAxis: 4 }` | Popper offset configuration             |

| Output        | Type                         | Description                                     |
| ------------- | ---------------------------- | ----------------------------------------------- |
| `confirmed`   | `OutputEmitterRef<void>`     | Emitted when the user clicks Ok                 |
| `cancelled`   | `OutputEmitterRef<void>`     | Emitted when the user clicks Cancel             |
| `timeChanged` | `OutputEmitterRef<DateType>` | Emitted on each scroll change within the panel  |

```html
<!-- Standalone panel attached to a custom anchor -->
<button #myAnchor (click)="panelOpen = true">Pick time</button>
<div mznTimePickerPanel
  [anchor]="myAnchor"
  [open]="panelOpen"
  [value]="pendingTime"
  (timeChanged)="pendingTime = $event"
  (confirmed)="onConfirm()"
  (cancelled)="panelOpen = false">
</div>
```

> Panel close is Popper-driven (`MznPopper` with `[open]` binding). `ClickAwayService` is **not** injected by `MznTimePickerPanel` or `MznTimePicker`.

## Notes

- **Format resolution order**: explicit `[format]` input → `hideSecond: true` shortcut (`'HH:mm'`) → `config.defaultTimeFormat` (e.g. `'HH:mm:ss'`). Provide `[format]` to override entirely.
- When the panel opens with no value, `computeCurrentTime()` snaps the current time to the nearest step using `Math.round(value / step) * step`, then clamps the result with `Math.min(..., 23)` (hour), `Math.min(..., 59)` (minute), `Math.min(..., 59)` (second).
- Typed input is handled by `MznPickerTrigger`'s character-by-character mask using `resolvedFormat`. A complete, valid typed value commits immediately without requiring the panel Ok button.
- Pressing **Enter** in the trigger field triggers `onConfirm()` even when the panel is not open — it commits whatever value is in `pendingValue` (which may be `undefined` if no panel was opened).
- `(panelToggled)` is useful for coordinating layout changes (e.g. adjusting a sibling element's height) when the panel opens or closes — separate from `(timeChanged)`.
- Requires `MZN_CALENDAR_CONFIG`. See `DatePicker.md` for `MznCalendarConfigProvider` setup details.
