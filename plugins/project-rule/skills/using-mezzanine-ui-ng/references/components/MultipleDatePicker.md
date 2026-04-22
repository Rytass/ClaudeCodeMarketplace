# MultipleDatePicker

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/ng/multiple-date-picker) · Verified 1.0.0-rc.3 (2026-04-21)
>
> **Storybook**: https://storybook-ng.mezzanine-ui.org/?path=/docs/data-entry-multiple-date-picker--docs

A multi-date picker that displays selected dates as closeable tag chips in the trigger. Focusing the trigger opens a calendar panel with a Confirm/Cancel footer; selections remain *pending* until the user clicks Confirm. The trigger supports two overflow strategies: `'counter'` (shows `+N`) or `'wrap'` (allows the trigger to grow vertically). Implements `ControlValueAccessor` binding `ReadonlyArray<DateType>`. Requires `MZN_CALENDAR_CONFIG`.

## Import

```ts
import {
  MznMultipleDatePicker,
  MznMultipleDatePickerTrigger,
} from '@mezzanine-ui/ng/multiple-date-picker';
import type { MultipleDatePickerDateValue } from '@mezzanine-ui/ng/multiple-date-picker';
import type { DateType, CalendarMode } from '@mezzanine-ui/core/calendar';

// Required provider:
import { MznCalendarConfigProvider } from '@mezzanine-ui/ng/calendar';
```

## Selector

`<div mznMultipleDatePicker ...>` — attribute-directive component

## Inputs

| Input              | Type                                | Default       | Description                                                              |
| ------------------ | ----------------------------------- | ------------- | ------------------------------------------------------------------------ |
| `value`            | `ReadonlyArray<DateType>`           | —             | Controlled date array (use CVA in forms instead)                         |
| `active`           | `boolean`                           | `false`       | Override trigger active/open styling                                     |
| `cancelText`       | `string`                            | `'Cancel'`    | Footer cancel button label                                               |
| `clearable`        | `boolean`                           | `true`        | Show clear button                                                        |
| `confirmText`      | `string`                            | `'Ok'`        | Footer confirm button label                                              |
| `disabled`         | `boolean`                           | `false`       | Disabled state                                                           |
| `error`            | `boolean`                           | `false`       | Error state styling                                                      |
| `format`           | `string`                            | —             | Display format for tag labels; defaults to `getDefaultModeFormat(mode)`  |
| `fullWidth`        | `boolean`                           | `false`       | Stretch to container width                                               |
| `isDateDisabled`   | `(date: DateType) => boolean`       | —             | Predicate to disable specific dates                                      |
| `maxSelections`    | `number`                            | —             | Maximum number of selectable dates; unselected dates are disabled once limit is reached |
| `mode`             | `CalendarMode`                      | `'day'`       | Calendar mode                                                            |
| `overflowStrategy` | `'counter' \| 'wrap'`               | `'counter'`   | How overflow tags are rendered                                           |
| `placeholder`      | `string`                            | `''`          | Trigger placeholder text                                                 |
| `readOnly`         | `boolean`                           | `false`       | Read-only state                                                          |
| `referenceDate`    | `DateType`                          | —             | Initial calendar reference date                                          |
| `required`         | `boolean`                           | `false`       | Required state                                                           |
| `size`             | `TextFieldSize`                     | `'main'`      | `'main' \| 'sub'`                                                        |

> Inputs declared with signal API (`input()`) accept both static and reactive values.

## Outputs

| Output         | Type                                          | Description                                           |
| -------------- | --------------------------------------------- | ----------------------------------------------------- |
| `datesChanged` | `OutputEmitterRef<ReadonlyArray<DateType>>`   | Emitted when the confirmed date selection changes     |

## ControlValueAccessor

`MznMultipleDatePicker` implements `ControlValueAccessor` binding `ReadonlyArray<DateType>`.

```html
<!-- formControlName -->
<form [formGroup]="form">
  <div mznMultipleDatePicker
    formControlName="blockedDates"
    placeholder="Select dates"
    [maxSelections]="5">
  </div>
</form>

<!-- formControl -->
<div mznMultipleDatePicker
  [formControl]="holidaysCtrl"
  [fullWidth]="true"
  overflowStrategy="wrap">
</div>

<!-- ngModel -->
<div mznMultipleDatePicker
  [(ngModel)]="selectedDates"
  placeholder="Pick dates">
</div>
```

`writeValue(ReadonlyArray<DateType> | undefined)` sets both `committedValue` and `pendingValue` signals. `null`/`undefined` resets both to `[]`. CVA's `onChange` is called only after the user confirms via the footer button.

## Two-Phase Commit

The component uses a `committedValue` / `pendingValue` signal pair:

- **`pendingValue`** — live selection during panel interaction; drives tag display and calendar highlight
- **`committedValue`** — the last confirmed selection; used as the CVA value
- Clicking **Confirm** → `pendingValue` is flushed to `committedValue`, `onChange` fires, panel closes
- Clicking **Cancel** or clicking outside → `pendingValue` reverts to `committedValue`, panel closes without emitting

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
<!-- Blackout date selector with max limit -->
<div mznFormField name="blockedDates" label="Blocked Dates">
  <div mznMultipleDatePicker
    formControlName="blockedDates"
    placeholder="Select up to 10 dates"
    [maxSelections]="10"
    [isDateDisabled]="isPastDate"
    [fullWidth]="true"
    (datesChanged)="onDatesChange($event)">
  </div>
</div>

<!-- Overflow wrap mode for many selections -->
<div mznMultipleDatePicker
  [(ngModel)]="eventDates"
  overflowStrategy="wrap"
  [fullWidth]="true">
</div>
```

```ts
import { MznMultipleDatePicker } from '@mezzanine-ui/ng/multiple-date-picker';
import type { DateType } from '@mezzanine-ui/core/calendar';
import { ReactiveFormsModule, FormGroup, FormControl } from '@angular/forms';

@Component({
  imports: [MznMultipleDatePicker, MznFormField, ReactiveFormsModule],
})
export class BlackoutScheduleComponent {
  readonly form = new FormGroup({
    blockedDates: new FormControl<ReadonlyArray<DateType>>([]),
  });

  readonly isPastDate = (date: DateType): boolean =>
    date < new Date().toISOString().split('T')[0];

  onDatesChange(dates: ReadonlyArray<DateType>): void {
    console.log('Confirmed dates:', dates);
  }
}
```

## Notes

- `datesChanged` fires on **Confirm** and also when the **clear action** is used (emits `[]`). It does not fire on individual calendar-day clicks before confirmation.
- `maxSelections`: once the pending selection reaches the limit, the `resolvedIsDateDisabled` computed merges `isDateDisabled` with a check that disables any unselected date. Removing a tag re-enables those dates immediately.
- `overflowStrategy: 'counter'` keeps the trigger height fixed and shows `+N` for hidden tags; `'wrap'` lets the trigger expand vertically to display all tags.
- Clicking outside the component triggers `onCancel()` (via `ClickAwayService`), discarding pending changes. Pressing Escape also cancels.
- Requires `MZN_CALENDAR_CONFIG`. See `DatePicker.md` for `MznCalendarConfigProvider` setup details.
