# DateRangePicker

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/ng/date-range-picker) · Verified 1.0.0-rc.26 (2026-11-22)
>
> **Storybook**: https://storybook-ng.mezzanine-ui.org/?path=/docs/data-entry-date-range-picker--docs

A date range picker showing two formatted inputs (start/end) and a dual-panel calendar. First click sets the start date; second click sets the end date and auto-normalises to `[start, end]`. In `confirmMode: 'manual'`, a footer with Confirm/Cancel buttons appears. Implements `ControlValueAccessor` binding `RangePickerValue` (`undefined[] | [DateType, DateType]`; the empty state is `[undefined, undefined]`). Requires `MZN_CALENDAR_CONFIG`.

## Import

```ts
import {
  MznDateRangePicker,
  MznDateRangePickerCalendar,
} from '@mezzanine-ui/ng/date-range-picker';
import type { RangePickerValue } from '@mezzanine-ui/core/picker';
import type { DateType, CalendarMode } from '@mezzanine-ui/core/calendar';

// Required provider (see "Required Provider" below):
import { MZN_CALENDAR_CONFIG, createCalendarConfig, CalendarLocale } from '@mezzanine-ui/ng/calendar';
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
| `actions`               | `MznCalendarFooterActionsProps`     | —              | Footer action buttons (`primaryButtonProps` = confirm, `secondaryButtonProps` = cancel; each `{ children?, disabled?, onClick? }`). When provided, picking a range stages it instead of committing and closing; in `manual` mode it overrides the auto-generated Confirm/Cancel buttons, handlers included. Hoist to a class field or signal |
| `validateFrom`          | `(isoDate: string) => boolean`      | —              | Validation for typed input in the start field; a rejected value is not committed. `isXDisabled` predicates only affect the calendar |
| `validateTo`            | `(isoDate: string) => boolean`      | —              | Validation for typed input in the end field; a rejected value is not committed             |

> Inputs declared with signal API (`input()`) accept both static and reactive values.

## Outputs

| Output          | Type                                      | Description                                  |
| --------------- | ----------------------------------------- | -------------------------------------------- |
| `rangeChanged`  | `OutputEmitterRef<RangePickerValue>`      | Emitted when the selected range changes      |

## ControlValueAccessor

`MznDateRangePicker` implements `ControlValueAccessor` binding `RangePickerValue` (`undefined[] | [DateType, DateType]`).

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
import { MZN_CALENDAR_CONFIG, createCalendarConfig, CalendarLocale } from '@mezzanine-ui/ng/calendar';
import CalendarMethodsDayjs from '@mezzanine-ui/core/calendarMethodsDayjs';

export const appConfig: ApplicationConfig = {
  providers: [
    {
      provide: MZN_CALENDAR_CONFIG,
      useValue: createCalendarConfig(CalendarMethodsDayjs, {
        locale: CalendarLocale.ZH_TW,
      }),
    },
  ],
};
```

(`MznCalendarConfigProvider` is an attribute directive `[mznCalendarConfigProvider]`, not a provider function; see `Calendar.md`.)

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

## Subcomponents

### MznDateRangePickerCalendar

Standalone range-calendar popper that wraps `MznRangeCalendar` inside `MznPopper`. A thin pass-through — use it when building a custom range-picker shell that needs the dual-calendar panel attached to an arbitrary trigger element. `MznDateRangePicker` uses this internally.

#### Selector

`[mznDateRangePickerCalendar]` — attribute-directive component

#### Inputs — MznDateRangePickerCalendar

| Input                  | Type                                                              | Default             | Description                                              |
| ---------------------- | ----------------------------------------------------------------- | ------------------- | -------------------------------------------------------- |
| `anchor`               | `HTMLElement \| ElementRef<HTMLElement> \| null`                  | `null`              | Element the popper attaches to                           |
| `offsetOptions`        | `PopperOffsetOptions`                                             | `{ mainAxis: 4 }`   | Popper offset configuration                              |
| `open`                 | `boolean`                                                         | `false`             | Whether the calendar panel is visible                    |
| `placement`            | `PopperPlacement`                                                 | `'bottom-start'`    | Popper placement                                         |
| `referenceDate`        | `DateType`                                                        | `''`                | Initial reference date for the left calendar             |
| `value`                | `DateType \| ReadonlyArray<DateType> \| undefined`                | —                   | Currently selected or in-progress range value            |
| `mode`                 | `CalendarMode`                                                    | `'day'`             | Calendar mode                                            |
| `disabledMonthSwitch`  | `boolean`                                                         | `false`             | Disable month navigation                                 |
| `disabledYearSwitch`   | `boolean`                                                         | `false`             | Disable year navigation                                  |
| `disableOnNext`        | `boolean`                                                         | `false`             | Disable right calendar's "next" button                   |
| `disableOnPrev`        | `boolean`                                                         | `false`             | Disable left calendar's "previous" button                |
| `disableOnDoubleNext`  | `boolean`                                                         | `false`             | Disable right calendar's "double next" button            |
| `disableOnDoublePrev`  | `boolean`                                                         | `false`             | Disable left calendar's "double previous" button         |
| `displayMonthLocale`   | `string \| undefined`                                             | —                   | Locale for month labels                                  |
| `displayWeekDayLocale` | `string \| undefined`                                             | —                   | Locale for weekday labels                                |
| `isDateDisabled`       | `((date: DateType) => boolean) \| undefined`                      | —                   | Predicate to disable specific dates                      |
| `isDateInRange`        | `((date: DateType) => boolean) \| undefined`                      | —                   | Predicate marking dates in-range                         |
| `isMonthDisabled`      | `((date: DateType) => boolean) \| undefined`                      | —                   | Predicate to disable months                              |
| `isMonthInRange`       | `((date: DateType) => boolean) \| undefined`                      | —                   | Predicate marking months in-range                        |
| `isYearDisabled`       | `((date: DateType) => boolean) \| undefined`                      | —                   | Predicate to disable years                               |
| `isYearInRange`        | `((date: DateType) => boolean) \| undefined`                      | —                   | Predicate marking years in-range                         |
| `isWeekDisabled`       | `((date: DateType) => boolean) \| undefined`                      | —                   | Predicate to disable weeks                               |
| `isWeekInRange`        | `((date: DateType) => boolean) \| undefined`                      | —                   | Predicate marking weeks in-range                         |
| `isQuarterDisabled`    | `((date: DateType) => boolean) \| undefined`                      | —                   | Predicate to disable quarters                            |
| `isQuarterInRange`     | `((date: DateType) => boolean) \| undefined`                      | —                   | Predicate marking quarters in-range                      |
| `isHalfYearDisabled`   | `((date: DateType) => boolean) \| undefined`                      | —                   | Predicate to disable half-years                          |
| `isHalfYearInRange`    | `((date: DateType) => boolean) \| undefined`                      | —                   | Predicate marking half-years in-range                    |
| `quickSelect`          | `{ activeId?: string; options: ReadonlyArray<CalendarQuickSelectOption> } \| undefined` | — | Quick-select shortcut configuration              |
| `renderAnnotations`    | `((date: DateType) => CalendarDayAnnotation) \| undefined`        | —                   | Per-date annotation render function                      |
| `showFooterActions`    | `boolean`                                                         | `false`             | Show footer Cancel/Ok buttons                            |
| `actions`              | `MznCalendarFooterActionsProps \| undefined`                      | `undefined`         | Footer action buttons bundle; footer renders when this or `showFooterActions` is set |

#### Outputs — MznDateRangePickerCalendar

| Output         | Type                                                | Description                                                    |
| -------------- | --------------------------------------------------- | -------------------------------------------------------------- |
| `rangeChanged` | `OutputEmitterRef<[DateType, DateType \| undefined]>` | Emitted when the range is completed or start date updates    |
| `cellHover`    | `OutputEmitterRef<DateType>`                        | Emitted when the mouse hovers over a day cell                  |
| `mouseLeave`   | `OutputEmitterRef<void>`                            | Emitted when the mouse leaves the calendar panel               |
| `confirmed`    | `OutputEmitterRef<void>`                            | Footer confirm button clicked (when `showFooterActions=true`)  |
| `cancelled`    | `OutputEmitterRef<void>`                            | Footer cancel button clicked (when `showFooterActions=true`)   |

The component also exposes a public method `resetPickingState()` that forwards to the inner `MznRangeCalendar`, clearing any in-progress hover/picking state.

## Notes

- `RangePickerValue` is `undefined[] | [DateType, DateType]`. Initialise `FormControl` with `[undefined, undefined]` when no default range is needed.
- In `confirmMode: 'immediate'`, the calendar closes automatically after the second date is picked. In `manual` mode, the footer appears and the range is committed only on Confirm.
- The component internally tracks `committedValue` (confirmed range) and `pendingSelection` (in-progress range). The trigger displays the pending selection state during picking.
- `MznDateRangePicker` does not implement `setDisabledState`；`formControl.disable()` 不會讓元件進入 disabled，請另外綁定 `[disabled]`。
- 點擊元件外部（`ClickAwayService`）時會執行 cancel：清除 staged 選取並關閉面板（同時觸發 `onTouched`）。
- See `DatePicker.md` for the single-date variant and `MznCalendarConfigProvider` setup details.
