# DateRangePicker Component

> **Category**: Data Entry
>
> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/data-entry-daterangepicker--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。
>
> **Source**: [GitHub Source Code](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/react/src/DateRangePicker) · Verified 1.10.2 (2026-11-22)

A date range picker for selecting start and end dates. Must be used with `CalendarContext`. Internally composed of `DateRangePickerCalendar` and `RangePickerTrigger`.

## ⚠️ Prerequisite: CalendarConfigProvider

此元件依賴 `CalendarContext`，必須在應用程式根層級（如 `layout.tsx` 或 `App.tsx`）包裹 `CalendarConfigProvider`。
缺少此設定會導致 runtime error: `Cannot find values in your context`.

```tsx
// layout.tsx 或 App.tsx
import { CalendarConfigProvider } from '@mezzanine-ui/react';
import CalendarMethodsMoment from '@mezzanine-ui/core/calendarMethodsMoment';
// 或使用 dayjs: import CalendarMethodsDayjs from '@mezzanine-ui/core/calendarMethodsDayjs';

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <CalendarConfigProvider methods={CalendarMethodsMoment}>
      {children}
    </CalendarConfigProvider>
  );
}
```

> 也可使用便捷封裝 `CalendarConfigProviderMoment` 或 `CalendarConfigProviderDayjs`。
> 詳見 [Calendar.md](./Calendar.md) 的完整設定說明。

---

## Import

```tsx
import {
  DateRangePicker,
  DateRangePickerCalendar,
  useDateRangeCalendarControls,
  useDateRangePickerValue,
} from '@mezzanine-ui/react';
import type {
  DateRangePickerProps,
  DateRangePickerCalendarProps,
  UseDateRangePickerValueProps,
} from '@mezzanine-ui/react';
```

---

## DateRangePicker Props

`DateRangePickerProps` combines properties from `DateRangePickerCalendarProps` and `RangePickerTriggerProps`, plus its own `confirmMode`, `actions`, etc.

| Property               | Type                                              | Default        | Description                    |
| ---------------------- | ------------------------------------------------- | -------------- | ------------------------------ |
| `actions`              | `CalendarFooterActionsProps['actions']`            | -              | Custom action buttons          |
| `calendarProps`        | `RangeCalendarProps['calendarProps']` (`Omit<CalendarProps, 'calendarFooterControlProps' \| 'mode' \| 'value' \| 'onChange' \| 'referenceDate' \| 'renderAnnotations' \| 'onNext' \| 'onPrev' \| 'onDoubleNext' \| 'onDoublePrev' \| 'onMonthControlClick' \| 'onYearControlClick'>`) | - | Other props passed to each calendar |
| `className`            | `string`                                          | -              | Outer container CSS class      |
| `clearable`            | `boolean`                                         | `true`         | Whether clearable              |
| `confirmMode`          | `'immediate' \| 'manual'`                         | `'immediate'`  | Confirmation mode              |
| `defaultValue`         | `[DateType, DateType]`                            | -              | Default value                  |
| `disabled`             | `boolean`                                         | `false`        | Whether disabled               |
| `disabledMonthSwitch`  | `boolean`                                         | `false`        | Disable month switching        |
| `disabledYearSwitch`   | `boolean`                                         | `false`        | Disable year switching         |
| `disableOnDoubleNext`  | `boolean`                                         | -              | Disable double arrow next      |
| `disableOnDoublePrev`  | `boolean`                                         | -              | Disable double arrow prev      |
| `disableOnNext`        | `boolean`                                         | -              | Disable next                   |
| `disableOnPrev`        | `boolean`                                         | -              | Disable prev                   |
| `displayMonthLocale`   | `string`                                          | `locale` (from `CalendarContext`) | Month display locale |
| `displayWeekDayLocale` | `string`                                          | `locale` (from `CalendarContext`) | Weekday display locale |
| `error`                | `boolean`                                         | `false`        | Error state                    |
| `errorMessagesFrom`    | `{ enabled?: boolean; invalidInput?: string; invalidPaste?: string }` | `{ enabled: true, invalidInput: 'Input value is not valid.', invalidPaste: 'Pasted content is not valid.' }` | Start field error messages |
| `errorMessagesTo`      | `{ enabled?: boolean; invalidInput?: string; invalidPaste?: string }` | same as `errorMessagesFrom` | End field error messages |
| `fadeProps`            | `Omit<FadeProps, 'children' \| 'in'>`             | -              | Fade animation props           |
| `firstCalendarRef`     | `RefObject<HTMLDivElement \| null>`               | -              | First calendar ref             |
| `format`               | `string`                                          | Depends on mode | Display format (determined by mode) |
| `fullWidth`            | `boolean`                                         | `false`        | Whether full width             |
| `inputFromPlaceholder` | `string`                                          | -              | Start field placeholder        |
| `inputFromProps`       | `Omit<NativeInputProps, 'defaultValue' \| 'disabled' \| 'onChange' \| 'placeholder' \| 'readOnly' \| 'required' \| 'value' \| aria-disabled \| aria-multiline \| aria-readonly \| aria-required>` | - | Start field native input props |
| `inputToPlaceholder`   | `string`                                          | -              | End field placeholder          |
| `inputToProps`         | same as `inputFromProps`                          | -              | End field native input props   |
| `isDateDisabled`       | `(date: DateType) => boolean`                     | -              | Date disable check             |
| `isHalfYearDisabled`   | `(date: DateType) => boolean`                     | -              | Half-year disable check        |
| `isMonthDisabled`      | `(date: DateType) => boolean`                     | -              | Month disable check            |
| `isQuarterDisabled`    | `(date: DateType) => boolean`                     | -              | Quarter disable check          |
| `isWeekDisabled`       | `(date: DateType) => boolean`                     | -              | Week disable check             |
| `isYearDisabled`       | `(date: DateType) => boolean`                     | -              | Year disable check             |
| `mode`                 | `CalendarMode`                                    | `'day'`        | Selection mode                 |
| `onCalendarToggle`     | `(open: boolean) => void`                         | -              | Calendar toggle callback       |
| `onChange`             | `(target?: RangePickerValue) => void`             | -              | Change callback                |
| `popperProps`          | `Omit<InputTriggerPopperProps, 'anchor' \| 'children' \| 'fadeProps' \| 'open'>` | - | Popper positioning props |
| `prefix`               | `ReactNode`                                       | -              | Prefix element                 |
| `quickSelect`          | `Pick<CalendarQuickSelectProps, 'activeId' \| 'options'>` | -       | Quick select options           |
| `readOnly`             | `boolean`                                         | -              | Whether read-only              |
| `referenceDate`        | `DateType`                                        | -              | Reference date                 |
| `renderAnnotations`    | `(date: DateType) => { value: string; color?: TypographyColor }` | - | Custom date annotation renderer |
| `required`             | `boolean`                                         | `false`        | Whether required               |
| `secondCalendarRef`    | `RefObject<HTMLDivElement \| null>`               | -              | Second calendar ref            |
| `size`                 | `'main' \| 'sub'`                                 | -              | Size                           |
| `validateFrom`         | `(isoDate: string) => boolean`                    | -              | Start field validation         |
| `validateTo`           | `(isoDate: string) => boolean`                    | -              | End field validation           |
| `value`                | `RangePickerValue`                                | -              | Selected value (controlled)    |

> `DateRangePickerProps` picks exactly these keys from `DateRangePickerCalendarProps` (`calendarProps`, `disabledMonthSwitch`, `disableOnNext`, `disableOnPrev`, `disableOnDoubleNext`, `disableOnDoublePrev`, `disabledYearSwitch`, `displayMonthLocale`, `displayWeekDayLocale`, `fadeProps`, `firstCalendarRef`, `isDateDisabled`, `isWeekDisabled`, `isMonthDisabled`, `isYearDisabled`, `isQuarterDisabled`, `isHalfYearDisabled`, `mode`, `popperProps`, `quickSelect`, `renderAnnotations`, `secondCalendarRef`) and from `RangePickerTriggerProps` (`className`, `clearable`, `disabled`, `error`, `errorMessagesFrom`, `errorMessagesTo`, `fullWidth`, `inputFromPlaceholder`, `inputFromProps`, `inputToPlaceholder`, `inputToProps`, `prefix`, `readOnly`, `required`, `size`, `validateFrom`, `validateTo`). `isDateInRange` / `is*InRange`, `on*Hover`, `onLeave` and `previewValue` are NOT props of `DateRangePicker`; they exist only on `DateRangePickerCalendar`.

> **confirmMode behavior**:
> - `'immediate'` (default): Automatically triggers onChange and closes the calendar after selecting two dates
> - `'manual'`: Requires clicking the confirm button to trigger; if `actions` is not provided, confirm/cancel buttons are auto-generated

---

### DateRangePickerCalendarProps (standalone `DateRangePickerCalendar`)

Picks from `RangeCalendarProps`: `actions`, `calendarProps`, `disabledMonthSwitch`, `disabledYearSwitch`, `disableOnNext`, `disableOnPrev`, `disableOnDoubleNext`, `disableOnDoublePrev`, `displayMonthLocale`, `displayWeekDayLocale`, `firstCalendarRef`, `isDateDisabled`, `isDateInRange`, `isMonthDisabled`, `isMonthInRange`, `isWeekDisabled`, `isWeekInRange`, `isYearDisabled`, `isYearInRange`, `isQuarterDisabled`, `isQuarterInRange`, `isHalfYearDisabled`, `isHalfYearInRange`, `onDateHover`, `onWeekHover`, `previewValue`, `onMonthHover`, `onYearHover`, `onQuarterHover`, `onHalfYearHover`, `quickSelect`, `renderAnnotations`, `secondCalendarRef`, `value`; plus `anchor`, `fadeProps`, `open` picked from `InputTriggerPopperProps`. Own props:

| Property        | Type                                                    | Default | Description |
| --------------- | ------------------------------------------------------- | ------- | ----------- |
| `mode`          | `CalendarMode`                                          | `'day'` | Calendar mode |
| `onChange`      | `(value: [DateType, DateType \| undefined]) => void`    | -       | Cell click; second click returns normalized `[start, end]`, first click returns the clicked date |
| `onLeave`       | `() => void`                                            | -       | Fired when the mouse leaves the calendar panel |
| `popperProps`   | `Omit<InputTriggerPopperProps, 'anchor' \| 'children' \| 'fadeProps' \| 'open'>` | - | Popper props |
| `referenceDate` | `DateType`                                              | **required** | Reference date |

---

## Portal Behavior

The calendar popper portals out of the DOM subtree by default, fixing clipping inside `Modal` / `overflow: hidden` ancestors and enabling viewport-edge flip. To restore inline (non-portal) rendering per call site:

```tsx
<DateRangePicker
  popperProps={{ disablePortal: true }}
  value={value}
  onChange={setValue}
/>
```

### Keyboard Navigation

`Tab` / `Shift+Tab` navigation between the trigger inputs and the portalled calendar works via an explicit logical focus loop, reliable even inside a `Modal` focus trap.

---

## Type Definitions

```tsx
type CalendarMode = 'day' | 'week' | 'month' | 'year' | 'quarter' | 'half-year';

// From @mezzanine-ui/core/picker
type RangePickerValue<T = DateType> = undefined[] | [T, T];

// Item structure within quickSelect.options
interface CalendarQuickSelectOption {
  id: string;
  name: string;
  disabled?: boolean;
  onClick: VoidFunction;
}
```

---

## Hooks

`DateRangePicker` is built on two exported hooks. Most consumers never need to call these directly — they exist for building a custom trigger/calendar pairing.

### `useDateRangePickerValue(props: UseDateRangePickerValueProps)`

Manages the from/to input values, calendar value, hover preview, and clear behavior.

| Property                 | Type                                              | Default | Description |
| ------------------------- | -------------------------------------------------- | ------- | ------------ |
| `format`                  | `string`                                          | -       | Required. Format pattern for the inputs (e.g. `'YYYY-MM-DD'`) |
| `hasDisabledDateInRange`  | `(start: DateType, end: DateType) => boolean`     | -       | **Deprecated.** `DateRangePicker` no longer supplies this — deciding whether a range covers a disabled unit moved into `RangeCalendar`'s shared scan. Still honoured for external callers of this hook. |
| `inputFromRef`            | `RefObject<HTMLInputElement \| null>`             | -       | Required. Ref for the 'from' input element |
| `inputToRef`              | `RefObject<HTMLInputElement \| null>`             | -       | Required. Ref for the 'to' input element |
| `mode`                    | `DateRangePickerCalendarProps['mode']`            | -       | Calendar mode |
| `onChange`                | `(value?: RangePickerValue) => void`              | -       | Fired when the range is complete |
| `value`                   | `RangePickerValue`                                | -       | Controlled value |

Returns `{ calendarValue, checkIsInRange, committedCalendarValue, hoverValue, hoverFromValue, hoverToValue, inputFromValue, inputToValue, onCalendarChange, onCalendarHover, onChange, onClear, onFromBlur, onFromFocus, onHoverClear, onInputFromChange, onInputToChange, onToBlur, onToFocus, value }`.

> `committedCalendarValue` holds only what the user has actually committed (no hover preview mixed in) — anything deciding *how far the selection has got* should read this rather than `calendarValue`, which folds the hovered date into its second slot.

### `useDateRangeCalendarControls(referenceDate: DateType, mode: CalendarMode)`

Low-level hook that drives the two side-by-side calendar panes' reference dates and prev/next navigation. Returns `{ currentMode, onFirstNext, onFirstPrev, onMonthControlClick, onSecondNext, onSecondPrev, onYearControlClick, popModeStack, referenceDates, updateFirstReferenceDate, updateSecondReferenceDate }`.

---

## Usage Examples

### Basic Usage

```tsx
import { DateRangePicker } from '@mezzanine-ui/react';
import { CalendarConfigProviderDayjs } from '@mezzanine-ui/react/Calendar';

function BasicExample() {
  const [value, setValue] = useState<[string, string] | undefined>();

  return (
    <CalendarConfigProviderDayjs>
      <DateRangePicker
        value={value}
        onChange={setValue}
      />
    </CalendarConfigProviderDayjs>
  );
}
```

### With Default Value

```tsx
<DateRangePicker
  defaultValue={['2024-01-01', '2024-01-31']}
  onChange={handleChange}
/>
```

### Custom Format

```tsx
<DateRangePicker
  format="YYYY/MM/DD"
  inputFromPlaceholder="Start date"
  inputToPlaceholder="End date"
  onChange={handleChange}
/>
```

### Manual Confirm Mode

```tsx
<DateRangePicker
  confirmMode="manual"
  onChange={handleChange}
/>
```

### Disable Specific Dates

```tsx
<DateRangePicker
  isDateDisabled={(date) => {
    // Disable weekends
    const dayOfWeek = dayjs(date).day();
    return dayOfWeek === 0 || dayOfWeek === 6;
  }}
  onChange={handleChange}
/>
```

### Month Selection Mode

```tsx
<DateRangePicker
  mode="month"
  format="YYYY-MM"
  onChange={handleChange}
/>
```

### With Quick Select

```tsx
<DateRangePicker
  quickSelect={{
    activeId: activeQuickSelectId,
    options: [
      { id: 'today', name: 'Today', onClick: () => handleQuickSelect([today, today]) },
      { id: 'week', name: 'This Week', onClick: () => handleQuickSelect([startOfWeek, endOfWeek]) },
      { id: 'month', name: 'This Month', onClick: () => handleQuickSelect([startOfMonth, endOfMonth]) },
    ],
  }}
  onChange={handleChange}
/>
```

### Custom Action Buttons

```tsx
<DateRangePicker
  actions={{
    primaryButtonProps: {
      children: 'Confirm',
      onClick: handleConfirm,
    },
    secondaryButtonProps: {
      children: 'Cancel',
      onClick: handleCancel,
    },
  }}
  onChange={handleChange}
/>
```

---

## Figma Mapping

| Figma Variant                    | React Props                |
| -------------------------------- | -------------------------- |
| `DateRangePicker / Default`      | Default                    |
| `DateRangePicker / Disabled`     | `disabled`                 |
| `DateRangePicker / Error`        | `error`                    |
| `DateRangePicker / With Value`   | `value` is set             |
| `DateRangePicker / Day Mode`     | `mode="day"`               |
| `DateRangePicker / Month Mode`   | `mode="month"`             |

---

## Behavior Notes

- **Suffix overlay when clearable**: When `clearable` is true, the clear icon overlays the calendar suffix icon. The calendar icon is hidden while the clear button is visible.
- **Hover preview no longer pollutes the committed range**: hovering a second date while picking previews the range without mutating what has actually been committed. Internally, `RangeCalendar` paints from a `previewValue` kept separate from `value`; the click handler and the highlight/disabled-range check both read only the committed anchors, so a half-finished range can no longer be mistaken for a finished one mid-hover.
- **Disabled-date scan is capped internally**: when `isDateDisabled` (or the week/month/quarter/year/half-year equivalents) is supplied, `RangeCalendar` walks every unit between the two anchors once to decide whether the range crosses a disabled unit — this same check gates both the in-range highlight and whether a click completes the range, so hovering never highlights a range that a click would then reject. The walk is capped at an internal, non-configurable limit of 4,000 units (`maxRangeScanSteps` in `useRangeScan`, not exported from the package) — a scan that hits the cap is treated as `'incomplete'` and the range is withheld from highlighting/selection rather than assumed clear. With no disabled-date predicate supplied for the active mode, no scan runs at all and every range is treated as clear.

  `maxRangeScanSteps` is an internal implementation detail, not a public prop of `DateRangePicker`, `DateRangePickerCalendar`, or `RangeCalendar` — it is not re-exported from `@mezzanine-ui/react`.

---

## Best Practices

1. **Context required**: Must be wrapped in CalendarContext.Provider
2. **Date library choice**: Can use dayjs, luxon, or moment
3. **Disable logic**: Use `isDateDisabled` and similar functions to disable specific dates
4. **Confirm mode**: Use `confirmMode="manual"` when explicit confirmation is needed
5. **Quick select**: Provide quick select options for commonly used date ranges
