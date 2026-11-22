# DatePicker Component

> **Category**: Data Entry
>
> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/data-entry-datepicker--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。
>
> **Source**: [GitHub Source Code](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/react/src/DatePicker) · Verified 1.10.2 (2026-11-22)

Date picker component supporting multiple modes (day, week, month, quarter, half-year, year). Requires `CalendarContext`. Internally composed of `PickerTrigger` and `DatePickerCalendar`.

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
import { DatePicker, DatePickerCalendar, CalendarContext } from '@mezzanine-ui/react';
import type { DatePickerProps, DatePickerCalendarProps } from '@mezzanine-ui/react';
```

---

## DatePicker Props

`DatePickerProps` extends `DatePickerCalendarProps` (excluding `anchor`, `calendarRef`, `disableOnDoubleNext`, `disableOnDoublePrev`, `onChange`, `open`, `referenceDate`, `updateReferenceDate`) and `PickerTriggerProps` (excluding `defaultValue`, `format`, `inputRef`, `onChange`, `onClear`, `onClick`, `onIconClick`, `onKeyDown`, `value`).

### Own Props

| Property              | Type                          | Default      | Description                              |
| --------------------- | ----------------------------- | ------------ | ---------------------------------------- |
| `defaultValue`        | `DateType`                    | -            | Default value                            |
| `disableOnDoubleNext` | `boolean`                     | -            | Disable double-arrow next                |
| `disableOnDoublePrev` | `boolean`                     | -            | Disable double-arrow previous            |
| `format`              | `string`                      | by mode      | Date format (length must match output value) |
| `onCalendarToggle`    | `(open: boolean) => void`     | -            | Calendar open/close event                |
| `onChange`            | `(target?: DateType) => void` | -            | Change event                             |
| `referenceDate`       | `DateType`                    | `defaultValue` or current time | Reference date (initial calendar view) |

### Inherited from DatePickerCalendarProps

| Property              | Type                              | Default  | Description                    |
| --------------------- | --------------------------------- | -------- | ------------------------------ |
| `calendarProps`       | `Omit<CalendarProps, 'disableOnNext' \| 'disableOnPrev' \| 'disableOnDoubleNext' \| 'disableOnDoublePrev' \| 'displayMonthLocale' \| 'isDateDisabled' \| 'isMonthDisabled' \| 'isQuarterDisabled' \| 'isHalfYearDisabled' \| 'isWeekDisabled' \| 'isYearDisabled' \| 'locale' \| 'mode' \| 'onChange' \| 'onMonthControlClick' \| 'onNext' \| 'onDoubleNext' \| 'onPrev' \| 'onDoublePrev' \| 'onYearControlClick' \| 'referenceDate' \| 'updateReferenceDate' \| 'value'>` | - | Other props passed to `Calendar` |
| `disabledMonthSwitch` | `boolean`                         | `false`  | Disable month switching        |
| `disabledYearSwitch`  | `boolean`                         | `false`  | Disable year switching         |
| `disableOnNext`       | `boolean`                         | -        | Disable next                   |
| `disableOnPrev`       | `boolean`                         | -        | Disable previous               |
| `displayMonthLocale`  | `string`                          | `locale` (from `CalendarContext`) | Month display locale |
| `fadeProps`            | `Omit<FadeProps, 'children' \| 'in'>` | -    | Fade animation props           |
| `isDateDisabled`      | `(date: DateType) => boolean`     | -        | Date disabled check            |
| `isHalfYearDisabled`  | `(date: DateType) => boolean`     | -        | Half-year disabled check       |
| `isMonthDisabled`     | `(date: DateType) => boolean`     | -        | Month disabled check           |
| `isQuarterDisabled`   | `(date: DateType) => boolean`     | -        | Quarter disabled check         |
| `isWeekDisabled`      | `(date: DateType) => boolean`     | -        | Week disabled check            |
| `isYearDisabled`      | `(date: DateType) => boolean`     | -        | Year disabled check            |
| `mode`                | `CalendarMode`                    | `'day'`  | Date mode                      |
| `onHover`             | `(date: DateType) => void`        | -        | Present in the type, but `DatePicker` does not honour it (it wires its own hover-preview handler and does not forward the prop) |
| `onLeave`             | `() => void`                      | -        | Present in the type, but `DatePicker` does not honour it (same as `onHover`) |
| `popperProps`         | `Omit<InputTriggerPopperProps, 'anchor' \| 'children' \| 'fadeProps' \| 'open'>` | - | Popper positioning props |

### Inherited from PickerTriggerProps

| Property        | Type                                  | Default | Description            |
| --------------- | ------------------------------------- | ------- | ---------------------- |
| `className`     | `string`                              | -       | CSS class              |
| `clearable`     | `boolean`                             | `true`  | Whether clearable      |
| `disabled`      | `boolean`                             | `false` | Whether disabled       |
| `error`         | `boolean`                             | `false` | Whether in error state |
| `errorMessages` | `{ enabled?: boolean; invalidInput?: string; invalidPaste?: string }` (`FormattedInputProps['errorMessages']`) | `{ enabled: true, invalidInput: 'Input value is not valid.', invalidPaste: 'Pasted content is not valid.' }` | Error message configuration (an object, not an array) |
| `fullWidth`     | `boolean`                             | `false` | Whether full width     |
| `inputProps`    | `Omit<NativeInputProps, ...>`         | -       | Props passed to input  |
| `placeholder`   | `string`                              | -       | Placeholder text       |
| `prefix`        | `ReactNode`                           | -       | Prefix                 |
| `readOnly`      | `boolean`                             | -       | Whether read-only (blocks opening the calendar) |
| `required`      | `boolean`                             | `false` | Whether required       |
| `size`          | `'main' \| 'sub'`                     | -       | Size                   |
| `validate`      | `(isoDate: string) => boolean`        | -       | Present in the type, but `DatePicker` overrides it with its own validator built from `isDateDisabled` / `isWeekDisabled` / `isMonthDisabled` / `isQuarterDisabled` / `isYearDisabled` / `isHalfYearDisabled` (per `mode`) |
| `value`         | `DateType`                            | -       | Controlled value (declared by `DatePickerCalendarProps`; `PickerTriggerProps['value']` is omitted) |
| `warning`       | `boolean`                             | `false` | Whether in warning state (from `TextFieldProps`) |

> `PickerTriggerProps` also extends `TextFieldProps` (minus `active`, `children`, `defaultChecked`, `disabled`, `readonly`, `typing`) and therefore accepts the native `<div>` props of the trigger root. `suffix`, `forceShowClearable`, `hideSuffixWhenClearable`, `hoverValue` and `onFocus` appear in the type but are set internally by `DatePicker` and override any value you pass.

### DatePickerCalendarProps (for the standalone `DatePickerCalendar`)

| Property        | Type                                         | Default | Description |
| --------------- | -------------------------------------------- | ------- | ----------- |
| `anchor`        | `InputTriggerPopperProps['anchor']`          | -       | Popper anchor (omitted from `DatePickerProps`) |
| `calendarProps` | see above                                    | -       | Other props for `Calendar` |
| `calendarRef`   | `RefObject<HTMLDivElement \| null>`          | -       | Ref for the calendar element (omitted from `DatePickerProps`) |
| `mode`          | `CalendarMode`                               | `'day'` | Calendar mode |
| `onChange`      | `(target: DateType) => void`                 | -       | Fired by the calendar cell click (omitted from `DatePickerProps`, which declares its own `onChange`) |
| `onHover`       | `(date: DateType) => void`                   | -       | Fired when hovering a calendar cell (any mode) |
| `onLeave`       | `() => void`                                 | -       | Fired when the mouse leaves the calendar panel |
| `open`          | `boolean`                                    | -       | Whether the popper is open (omitted from `DatePickerProps`) |
| `popperProps`   | `Omit<InputTriggerPopperProps, 'anchor' \| 'children' \| 'fadeProps' \| 'open'>` | - | Popper props |
| `referenceDate` | `DateType`                                   | -       | Reference date (required in `DatePickerCalendarProps`; `DatePickerProps` re-declares it as optional) |
| `value`         | `DateType`                                   | -       | Active cell value |

Plus `fadeProps`, the `disable*`/`disabled*Switch`/`displayMonthLocale`/`is*Disabled` props picked from `CalendarProps` (as in the inherited table above).

---

## CalendarMode Type

| Mode        | Description | Default Format |
| ----------- | ----------- | -------------- |
| `day`       | Day         | `YYYY-MM-DD`   |
| `week`      | Week        | `gggg-[W]ww`   |
| `month`     | Month       | `YYYY-MM`      |
| `quarter`   | Quarter     | `YYYY-[Q]Q`    |
| `half-year` | Half-year   | `YYYY-[H]n`    |
| `year`      | Year        | `YYYY`         |

---

## Portal Behavior

The calendar popper portals out of the DOM subtree by default, so `z-index: popover (1005)` wins against `Modal (1004)`. This fixes clipping when the picker is inside a `Modal` or any ancestor with `overflow: hidden`, and enables viewport-edge flip.

To use inline (non-portal) rendering per call site:

```tsx
<DatePicker
  popperProps={{ disablePortal: true }}
  value={value}
  onChange={setValue}
/>
```

### Keyboard Navigation

`Tab` / `Shift+Tab` navigation between the trigger input and the portalled calendar works. The popper establishes an explicit logical focus loop so the browser does not skip the calendar when the portal severs natural DOM order. This is particularly reliable inside a `Modal` focus trap.

---

## CalendarContext is Required

DatePicker must be used within a `CalendarContext.Provider` with a date library adapter.

### Using Day.js

```tsx
import { CalendarConfigProviderDayjs } from '@mezzanine-ui/react/Calendar';

function App() {
  return (
    <CalendarConfigProviderDayjs>
      <DatePicker />
    </CalendarConfigProviderDayjs>
  );
}
```

### Using Luxon

```tsx
import { CalendarConfigProviderLuxon } from '@mezzanine-ui/react/Calendar';

<CalendarConfigProviderLuxon>
  <DatePicker />
</CalendarConfigProviderLuxon>
```

### Using Moment

```tsx
import { CalendarConfigProviderMoment } from '@mezzanine-ui/react/Calendar';

<CalendarConfigProviderMoment>
  <DatePicker />
</CalendarConfigProviderMoment>
```

---

## Usage Examples

### Basic Date Selection

```tsx
import { DatePicker } from '@mezzanine-ui/react';
import { CalendarConfigProviderDayjs } from '@mezzanine-ui/react/Calendar';

function BasicDatePicker() {
  const [date, setDate] = useState<string | undefined>();

  return (
    <CalendarConfigProviderDayjs>
      <DatePicker
        value={date}
        onChange={setDate}
        placeholder="Select date"
      />
    </CalendarConfigProviderDayjs>
  );
}
```

### Month Selection

```tsx
<DatePicker
  mode="month"
  value={month}
  onChange={setMonth}
  placeholder="Select month"
/>
```

### Year Selection

```tsx
<DatePicker
  mode="year"
  value={year}
  onChange={setYear}
  placeholder="Select year"
/>
```

### Week Selection

```tsx
<DatePicker
  mode="week"
  value={week}
  onChange={setWeek}
  placeholder="Select week"
/>
```

### Disabling Specific Dates

```tsx
<DatePicker
  value={date}
  onChange={setDate}
  isDateDisabled={(dateStr) => {
    const date = dayjs(dateStr);
    // Disable weekends
    return date.day() === 0 || date.day() === 6;
  }}
/>
```

### Restricting Date Range

```tsx
<DatePicker
  value={date}
  onChange={setDate}
  isDateDisabled={(dateStr) => {
    const date = dayjs(dateStr);
    const minDate = dayjs('2024-01-01');
    const maxDate = dayjs('2024-12-31');
    return date.isBefore(minDate) || date.isAfter(maxDate);
  }}
/>
```

### Custom Format

```tsx
<DatePicker
  value={date}
  onChange={setDate}
  format="YYYY/MM/DD"
  placeholder="YYYY/MM/DD"
/>
```

### Error State

```tsx
<DatePicker
  value={date}
  onChange={setDate}
  error
  errorMessages={{ invalidInput: 'Please select a valid date' }}
/>
```

---

## Related Components

- [DateRangePicker](./DateRangePicker.md) - Date range selection
- [DateTimePicker](./DateTimePicker.md) - Date and time selection
- [TimePicker](./TimePicker.md) - Time selection
- [Calendar](./Calendar.md) - Calendar (internal component)

---

## Figma Mapping

| Figma Variant                | React Props                              |
| ---------------------------- | ---------------------------------------- |
| `DatePicker / Day`           | `<DatePicker mode="day">`                |
| `DatePicker / Month`         | `<DatePicker mode="month">`              |
| `DatePicker / Year`          | `<DatePicker mode="year">`               |
| `DatePicker / Week`          | `<DatePicker mode="week">`               |
| `DatePicker / Disabled`      | `<DatePicker disabled>`                  |
| `DatePicker / Error`         | `<DatePicker error>`                     |

---

## Behavior Notes

- **Suffix overlay when clearable**: When `clearable` is true, the clear icon overlays the calendar suffix icon. The calendar icon is hidden while the clear button is visible, providing a cleaner UX.

---

## Best Practices

1. **Provide CalendarContext**: Ensure usage within a Provider
2. **Choose appropriate date library**: Select dayjs/luxon/moment based on project needs
3. **Set reasonable default formats**: Adjust date format based on regional conventions
4. **Provide date restrictions**: Use `isDateDisabled` to restrict selectable range
5. **Pair with FormField**: Provide labels and error messages
