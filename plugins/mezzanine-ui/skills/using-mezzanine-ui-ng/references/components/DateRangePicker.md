# DateRangePicker

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/ng/date-range-picker) · Verified 1.0.0-rc.3 (2026-04-21)
>
> **Storybook**: https://storybook-ng.mezzanine-ui.org/?path=/docs/data-entry-date-range-picker--docs

A date range picker showing two formatted inputs (start/end) and a dual-panel calendar. First click sets the start date; second click sets the end date and auto-normalises to `[start, end]`. In `confirmMode: 'manual'`, a footer with Confirm/Cancel buttons appears. Implements `ControlValueAccessor` binding `RangePickerValue` (`[DateType, DateType]`). Requires `MZN_CALENDAR_CONFIG`.

## Import

```ts
import {
  MznDateRangePicker,
  MznDateRangePickerCalendar,
} from '@mezzanine-ui/ng/date-range-picker';
import type { RangePickerValue } from '@mezzanine-ui/core/picker';
import type { DateType, CalendarMode } from '@mezzanine-ui/core/calendar';

// Required provider:
import { MznCalendarConfigProvider } from '@mezzanine-ui/ng/calendar';
```

## Selector

`<div mznDateRangePicker ...>` — attribute-directive component

## Inputs

| Input                   | Type                                | Default        | Description                                                    |
| ----------------------- | ----------------------------------- | -------------- | -------------------------------------------------------------- |
| `value`                 | `RangePickerValue \| undefined`     | —              | Controlled range value `[startDate, endDate]`                  |
| `mode`                  | `CalendarMode`                      | `'day'`        | Calendar mode                                                  |
| `format`                | `string`                            | —              | Display format; defaults to mode's default                     |
| `inputFromPlaceholder`  | `string`                            | —              | Start date input placeholder                                   |
| `inputToPlaceholder`    | `string`                            | —              | End date input placeholder                                     |
| `confirmMode`           | `'immediate' \| 'manual'`           | `'immediate'`  | `immediate`: auto-close after two picks; `manual`: requires Confirm |
| `disabled`              | `boolean`                           | `false`        | Disabled state                                                 |
| `readOnly`              | `boolean`                           | `false`        | Read-only state                                                |
| `error`                 | `boolean`                           | `false`        | Error state styling                                            |
| `fullWidth`             | `boolean`                           | `false`        | Stretch to container width                                     |
| `clearable`             | `boolean`                           | `true`         | Show clear button                                              |
| `size`                  | `TextFieldSize`                     | `'main'`       | `'main' \| 'sub'`                                              |
| `referenceDate`         | `DateType`                          | —              | Initial calendar reference date                                |
| `disabledMonthSwitch`   | `boolean`                           | `false`        | Disable month navigation                                       |
| `disabledYearSwitch`    | `boolean`                           | `false`        | Disable year navigation                                        |
| `disableOnNext`         | `boolean`                           | `false`        | Disable "next" navigation                                      |
| `disableOnPrev`         | `boolean`                           | `false`        | Disable "previous" navigation                                  |
| `disableOnDoubleNext`   | `boolean`                           | `false`        | Disable "double next" navigation                               |
| `disableOnDoublePrev`   | `boolean`                           | `false`        | Disable "double previous" navigation                           |
| `displayMonthLocale`    | `string`                            | —              | Locale for month labels                                        |
| `displayWeekDayLocale`  | `string`                            | —              | Locale for weekday labels                                      |
| `isDateDisabled`        | `(date: DateType) => boolean`       | —              | Disable specific dates                                         |
| `isMonthDisabled`       | `(date: DateType) => boolean`       | —              | Disable months                                                 |
| `isYearDisabled`        | `(date: DateType) => boolean`       | —              | Disable years                                                  |
| `isWeekDisabled`        | `(date: DateType) => boolean`       | —              | Disable weeks                                                  |
| `isQuarterDisabled`     | `(date: DateType) => boolean`       | —              | Disable quarters                                               |
| `isHalfYearDisabled`    | `(date: DateType) => boolean`       | —              | Disable half-years                                             |
| `quickSelect`           | `{ activeId?: string, options: CalendarQuickSelectOption[] }` | — | Quick select shortcuts                |
| `renderAnnotations`     | `(date: DateType) => CalendarDayAnnotation` | —      | Per-date annotation                                            |

> Inputs declared with signal API (`input()`) accept both static and reactive values.

## Outputs

| Output          | Type                                      | Description                                  |
| --------------- | ----------------------------------------- | -------------------------------------------- |
| `rangeChanged`  | `OutputEmitterRef<RangePickerValue>`      | Emitted when the selected range changes      |

## ControlValueAccessor

`MznDateRangePicker` implements `ControlValueAccessor` binding `RangePickerValue` (`[DateType | undefined, DateType | undefined]`).

```html
<!-- formControlName -->
<form [formGroup]="form">
  <div mznDateRangePicker
    formControlName="dateRange"
    inputFromPlaceholder="Start Date"
    inputToPlaceholder="End Date">
  </div>
</form>

<!-- formControl -->
<div mznDateRangePicker
  [formControl]="reportRangeCtrl"
  [clearable]="true"
  [fullWidth]="true">
</div>

<!-- ngModel -->
<div mznDateRangePicker [(ngModel)]="selectedRange"></div>
```

`writeValue([start, end] | null)` stores the pair in `committedValue`. `null` resets to `[undefined, undefined]`.

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
<!-- Report date filter with manual confirm mode -->
<div mznFormField name="reportRange" label="Report Period">
  <div mznDateRangePicker
    formControlName="reportRange"
    inputFromPlaceholder="From"
    inputToPlaceholder="To"
    confirmMode="manual"
    [fullWidth]="true"
    [isDateDisabled]="isFutureDate"
    (rangeChanged)="onRangeSelected($event)">
  </div>
</div>
```

```ts
import { MznDateRangePicker } from '@mezzanine-ui/ng/date-range-picker';
import type { RangePickerValue } from '@mezzanine-ui/core/picker';
import type { DateType } from '@mezzanine-ui/core/calendar';

@Component({
  imports: [MznDateRangePicker, MznFormField, ReactiveFormsModule],
})
export class ReportFormComponent {
  readonly form = new FormGroup({
    reportRange: new FormControl<RangePickerValue>([undefined, undefined] as unknown as RangePickerValue),
  });

  readonly isFutureDate = (date: DateType): boolean =>
    date > new Date().toISOString().split('T')[0];

  onRangeSelected(range: RangePickerValue): void {
    console.log('Range selected:', range);
  }
}
```

## Notes

- `RangePickerValue` is `[DateType | undefined, DateType | undefined]`. Initialise `FormControl` with `[undefined, undefined]` when no default range is needed.
- In `confirmMode: 'immediate'`, the calendar closes automatically after the second date is picked. In `manual` mode, the footer appears and the range is committed only on Confirm.
- The component internally tracks `committedValue` (confirmed range) and `pendingSelection` (in-progress range). The trigger displays the pending selection state during picking.
- See `DatePicker.md` for the single-date variant and `MznCalendarConfigProvider` setup details.
