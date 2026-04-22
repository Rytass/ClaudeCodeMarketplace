# DatePicker

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/ng/date-picker) · Verified 1.0.0-rc.3 (2026-04-21)
>
> **Storybook**: https://storybook-ng.mezzanine-ui.org/?path=/docs/data-entry-date-picker--docs

A single-date picker that opens a calendar popover on input focus. Supports `day`, `week`, `month`, `year`, `quarter`, and `half-year` calendar modes. The typed input accepts formatted date strings (character-by-character mask). Implements `ControlValueAccessor` binding `DateType` (a string ISO date or the library's internal date representation). Requires `MZN_CALENDAR_CONFIG` to be provided via `MznCalendarConfigProvider`.

## Import

```ts
import { MznDatePicker } from '@mezzanine-ui/ng/date-picker';
import type { DateType, CalendarMode } from '@mezzanine-ui/core/calendar';

// Required provider (in ApplicationConfig or component providers):
import { MznCalendarConfigProvider } from '@mezzanine-ui/ng/calendar';
```

## Selector

`[mznDatePicker]` — attribute selector applicable to any host element. `<div mznDatePicker>` is the idiomatic usage; the selector is not restricted to `div`.

## Inputs

| Input                   | Type                                | Default    | Description                                                  |
| ----------------------- | ----------------------------------- | ---------- | ------------------------------------------------------------ |
| `value`                 | `DateType`                          | —          | Controlled date value                                        |
| `mode`                  | `CalendarMode`                      | `'day'`    | Calendar mode: `'day' \| 'week' \| 'month' \| 'year' \| 'quarter' \| 'half-year'` |
| `format`                | `string`                            | —          | Display format; defaults to mode's default (e.g. `'YYYY-MM-DD'` for `day`) |
| `placeholder`           | `string`                            | `''`       | Placeholder text                                             |
| `disabled`              | `boolean`                           | `false`    | Disabled state                                               |
| `readOnly`              | `boolean`                           | `false`    | Read-only state                                              |
| `error`                 | `boolean`                           | `false`    | Error state styling                                          |
| `fullWidth`             | `boolean`                           | `false`    | Stretch to container width                                   |
| `clearable`             | `boolean`                           | `true`     | Show clear button                                            |
| `size`                  | `TextFieldSize`                     | `'main'`   | `'main' \| 'sub'`                                            |
| `referenceDate`         | `DateType`                          | —          | Initial calendar reference month/year                        |
| `disabledMonthSwitch`   | `boolean`                           | `false`    | Disable month navigation buttons in calendar                 |
| `disabledYearSwitch`    | `boolean`                           | `false`    | Disable year navigation buttons in calendar                  |
| `disableOnNext`         | `boolean`                           | `false`    | Disable "next" navigation button                             |
| `disableOnPrev`         | `boolean`                           | `false`    | Disable "previous" navigation button                         |
| `disableOnDoubleNext`   | `boolean`                           | `false`    | Disable "double next" navigation button                      |
| `disableOnDoublePrev`   | `boolean`                           | `false`    | Disable "double previous" navigation button                  |
| `displayMonthLocale`    | `string`                            | —          | Locale for month labels                                      |
| `displayWeekDayLocale`  | `string`                            | —          | Locale for weekday labels                                    |
| `isDateDisabled`        | `(date: DateType) => boolean`       | —          | Predicate to disable specific dates                          |
| `isMonthDisabled`       | `(date: DateType) => boolean`       | —          | Predicate to disable months                                  |
| `isYearDisabled`        | `(date: DateType) => boolean`       | —          | Predicate to disable years                                   |
| `isWeekDisabled`        | `(date: DateType) => boolean`       | —          | Predicate to disable weeks                                   |
| `isQuarterDisabled`     | `(date: DateType) => boolean`       | —          | Predicate to disable quarters                                |
| `isHalfYearDisabled`    | `(date: DateType) => boolean`       | —          | Predicate to disable half-years                              |
| `quickSelect`           | `{ activeId?: string, options: CalendarQuickSelectOption[] }` | — | Quick select shortcut options |
| `renderAnnotations`     | `(date: DateType) => CalendarDayAnnotation` | —  | Per-date annotation render function                          |

> Inputs declared with signal API (`input()`) accept both static and reactive values.

## Outputs

| Output            | Type                                 | Description                           |
| ----------------- | ------------------------------------ | ------------------------------------- |
| `dateChanged`     | `OutputEmitterRef<DateType \| undefined>` | Emitted on date selection or clear |
| `calendarToggled` | `OutputEmitterRef<boolean>`          | Emitted when calendar opens/closes    |

## ControlValueAccessor

`MznDatePicker` implements `ControlValueAccessor` binding `DateType | undefined`.

```html
<!-- formControlName -->
<form [formGroup]="form">
  <div mznDatePicker formControlName="birthDate" placeholder="Birthday" mode="day"></div>
</form>

<!-- formControl -->
<div mznDatePicker [formControl]="startDateCtrl" placeholder="Start date"></div>

<!-- ngModel -->
<div mznDatePicker [(ngModel)]="selectedDate" placeholder="Select date"></div>
```

`writeValue(DateType | undefined)` stores the value in `internalValue` and syncs `internalReferenceDate` so the calendar opens at the selected date's month. `null`/`undefined` clears the selection.

## Required Provider

All date/time components require `MZN_CALENDAR_CONFIG`. Provide it once in `ApplicationConfig`:

```ts
// app.config.ts
import { ApplicationConfig } from '@angular/core';
import { MznCalendarConfigProvider } from '@mezzanine-ui/ng/calendar';

export const appConfig: ApplicationConfig = {
  providers: [
    MznCalendarConfigProvider({
      firstDayOfWeek: 0, // 0 = Sunday, 1 = Monday
      locale: 'zh-TW',  // locale string for date formatting
    }),
  ],
};
```

## Usage

```html
<!-- Basic reactive form -->
<form [formGroup]="form">
  <div mznFormField name="startDate" label="Start Date"
       [severity]="form.get('startDate')?.invalid ? 'error' : 'info'">
    <div mznDatePicker
      formControlName="startDate"
      placeholder="YYYY-MM-DD"
      [fullWidth]="true"
      [isDateDisabled]="isPastDate">
    </div>
  </div>
</form>

<!-- Month picker with disabled dates -->
<div mznDatePicker
  [(ngModel)]="selectedMonth"
  mode="month"
  placeholder="Select month"
  [clearable]="true">
</div>
```

```ts
import { MznDatePicker } from '@mezzanine-ui/ng/date-picker';
import type { DateType } from '@mezzanine-ui/core/calendar';
import { ReactiveFormsModule, FormGroup, FormControl, Validators } from '@angular/forms';

@Component({
  imports: [MznDatePicker, MznFormField, ReactiveFormsModule],
})
export class BookingFormComponent {
  readonly form = new FormGroup({
    startDate: new FormControl<DateType | undefined>(undefined, Validators.required),
  });

  readonly isPastDate = (date: DateType): boolean => {
    // Compare date string to today's ISO date
    return date < new Date().toISOString().split('T')[0];
  };
}
```

## Injected Services / DI

`ClickAwayService` is injected in `ngAfterViewInit` and registers a click-outside listener on the host element. When the calendar is open and the user clicks outside, it closes the calendar and calls `onTouched()` to mark the control as touched.

`MZN_CALENDAR_CONFIG` is also injected (required) to supply the locale and date-formatting helpers. Provide it once at the application root via `MznCalendarConfigProvider`.

`DestroyRef` and `ElementRef<HTMLElement>` are also injected internally for cleanup wiring and host-element access — these are Angular platform primitives, not Mezzanine-specific.

## MznDatePickerCalendar (sibling public export)

`MznDatePickerCalendar` is a first-class public export from `@mezzanine-ui/ng/date-picker` — it pairs `MznPopper` with `MznCalendar` and is the calendar popover that `MznDatePicker` itself uses internally. You can consume it directly when building custom picker compositions.

**Selector**: `[mznDatePickerCalendar]`

### Inputs

| Input                     | Type                                                        | Default              | Description                                               |
| ------------------------- | ----------------------------------------------------------- | -------------------- | --------------------------------------------------------- |
| `anchor`                  | `HTMLElement \| ElementRef<HTMLElement> \| null`           | `null`               | Reference element for Popper positioning                  |
| `open`                    | `boolean`                                                   | `false`              | Whether the popover is visible                            |
| `mode`                    | `CalendarMode`                                              | `'day'`              | Calendar mode                                             |
| `referenceDate`           | `DateType`                                                  | `''`                 | Reference date driving the displayed month/year           |
| `value`                   | `DateType \| undefined`                                     | `undefined`          | Currently-selected date                                   |
| `disableOnDoubleNext`     | `boolean`                                                   | `false`              | Disable the calendar "jump forward 2" control             |
| `disableOnDoublePrev`     | `boolean`                                                   | `false`              | Disable the calendar "jump back 2" control                |
| `disableOnNext`           | `boolean`                                                   | `false`              | Disable the calendar "next" control                       |
| `disableOnPrev`           | `boolean`                                                   | `false`              | Disable the calendar "prev" control                       |
| `disabledMonthSwitch`     | `boolean`                                                   | `false`              | Disable month switcher button                             |
| `disabledYearSwitch`      | `boolean`                                                   | `false`              | Disable year switcher button                              |
| `displayMonthLocale`      | `string \| undefined`                                       | —                    | Locale for month-header display                           |
| `displayWeekDayLocale`    | `string \| undefined`                                       | —                    | Locale for weekday-header display                         |
| `isDateDisabled`          | `((date: DateType) => boolean) \| undefined`                | —                    | Per-date predicate                                        |
| `isHalfYearDisabled`      | `((date: DateType) => boolean) \| undefined`                | —                    | Per-half-year predicate                                   |
| `isMonthDisabled`         | `((date: DateType) => boolean) \| undefined`                | —                    | Per-month predicate                                       |
| `isQuarterDisabled`       | `((date: DateType) => boolean) \| undefined`                | —                    | Per-quarter predicate                                     |
| `isWeekDisabled`          | `((date: DateType) => boolean) \| undefined`                | —                    | Per-week predicate                                        |
| `isYearDisabled`          | `((date: DateType) => boolean) \| undefined`                | —                    | Per-year predicate                                        |
| `popperPlacement`         | `PopperPlacement`                                           | `'bottom-start'`     | Popper placement                                          |
| `popperOffsetOptions`     | `PopperOffsetOptions`                                       | `{ mainAxis: 4 }`    | Popper offset middleware options                          |
| `quickSelect`             | `{ activeId?: string; options: ReadonlyArray<CalendarQuickSelectOption> } \| undefined` | — | Quick-select shortcuts for the footer                     |
| `renderAnnotations`       | `((date: DateType) => CalendarDayAnnotation) \| undefined`  | —                    | Per-cell annotation renderer                              |

### Outputs

| Output        | Type                   | Description                                     |
| ------------- | ---------------------- | ----------------------------------------------- |
| `dateChanged` | `output<DateType>()`   | Emitted when a date is selected in the calendar |
| `hover`       | `output<DateType>()`   | Emitted when a calendar cell is hovered         |
| `leave`       | `output<void>()`       | Emitted when the pointer leaves the calendar    |

> `MznDatePickerCalendar` does not implement ControlValueAccessor — it is a purely presentational popover for composing custom pickers.

## Notes

- `MZN_CALENDAR_CONFIG` must be provided — without it the component throws. Use `MznCalendarConfigProvider` in `ApplicationConfig` providers array.
- The `format` input falls back to `getDefaultModeFormat(mode)` if not provided (e.g. `'YYYY-MM-DD'` for `day`, `'YYYY-MM'` for `month`).
- Typed input validation combines `isDateDisabled`, `isMonthDisabled`, etc. into a single `validateFn` predicate. Typing a disabled date in the input is silently rejected.
- Unlike React's `onChange?: (date) => void`, Angular uses CVA — no explicit handler needed when using `formControlName` / `[(ngModel)]`.
- `(dateChanged)` is provided as an additional event output alongside CVA, useful when you need to react to date changes without forms (e.g. driving a separate filter).
- See also `DateRangePicker.md` for the range variant, and `DateTimePicker.md` for combined date+time selection.
