# DateTimePicker Component

> **Category**: Data Entry
>
> **Storybook**: `Data Entry/DateTimePicker`
>
> **Source**: [GitHub Source Code](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/react/src/DateTimePicker) · Verified v2 source (2026-02-13)

A date-time picker that allows selecting both date and time simultaneously. Must be used with `CalendarContext`. Internally composed of `DatePickerCalendar`, `TimePickerPanel`, and `PickerTriggerWithSeparator`.

## Import

```tsx
import { DateTimePicker } from '@mezzanine-ui/react';
import type { DateTimePickerProps } from '@mezzanine-ui/react';
```

---

## DateTimePicker Props

`DateTimePickerProps` extends three interfaces (each excluding some internal properties):
- `DatePickerCalendarProps` (excludes `anchor`, `onChange`, `open`, `referenceDate`, `value`)
- `TimePickerPanelProps` (excludes `anchor`, `onChange`, `open`, `popperProps`, `value`)
- `PickerTriggerWithSeparatorProps` (excludes multiple internal input-related properties)

### Own Props

| Property         | Type                                                     | Default                                  | Description              |
| ---------------- | -------------------------------------------------------- | ---------------------------------------- | ------------------------ |
| `defaultValue`   | `DateType`                                               | -                                        | Default value            |
| `formatDate`     | `string`                                                 | Depends on mode (default `'YYYY-MM-DD'`) | Date display format      |
| `formatTime`     | `string`                                                 | `hideSecond ? 'HH:mm' : 'HH:mm:ss'`     | Time display format      |
| `onChange`       | `(target?: DateType) => void`                            | -                                        | Change callback          |
| `onPanelToggle`  | `(open: boolean, focusedInput: FocusedInput) => void`    | -                                        | Panel toggle callback    |
| `popperPropsTime`| `TimePickerPanelProps['popperProps']`                    | -                                        | Time Popper props        |
| `referenceDate`  | `DateType`                                               | -                                        | Reference date           |
| `value`          | `DateType`                                               | -                                        | Selected value (controlled) |

> `FocusedInput = 'left' | 'right' | null`

### Inherited from DatePickerCalendarProps

| Property              | Type                                    | Default  | Description              |
| --------------------- | --------------------------------------- | -------- | ------------------------ |
| `calendarProps`       | `Omit<CalendarProps, ...>`              | -        | Calendar props           |
| `calendarRef`         | `RefObject<HTMLDivElement \| null>`     | -        | Calendar ref             |
| `disabledMonthSwitch` | `boolean`                               | `false`  | Disable month switching  |
| `disabledYearSwitch`  | `boolean`                               | `false`  | Disable year switching   |
| `disableOnDoubleNext` | `boolean`                               | -        | Disable double arrow next |
| `disableOnDoublePrev` | `boolean`                               | -        | Disable double arrow prev |
| `disableOnNext`       | `boolean`                               | -        | Disable next             |
| `disableOnPrev`       | `boolean`                               | -        | Disable prev             |
| `displayMonthLocale`  | `string`                                | -        | Month display locale     |
| `fadeProps`            | `FadeProps`                             | -        | Fade animation props     |
| `isDateDisabled`      | `(date: DateType) => boolean`           | -        | Date disable check       |
| `isHalfYearDisabled`  | `(date: DateType) => boolean`           | -        | Half-year disable check  |
| `isMonthDisabled`     | `(date: DateType) => boolean`           | -        | Month disable check      |
| `isQuarterDisabled`   | `(date: DateType) => boolean`           | -        | Quarter disable check    |
| `isWeekDisabled`      | `(date: DateType) => boolean`           | -        | Week disable check       |
| `isYearDisabled`      | `(date: DateType) => boolean`           | -        | Year disable check       |
| `mode`                | `CalendarMode`                          | `'day'`  | Calendar selection mode  |
| `popperProps`         | `Omit<InputTriggerPopperProps, ...>`    | -        | Calendar Popper props    |

### Inherited from TimePickerPanelProps

| Property      | Type      | Default | Description  |
| ------------- | --------- | ------- | ------------ |
| `hideHour`    | `boolean` | -       | Hide hours   |
| `hideMinute`  | `boolean` | -       | Hide minutes |
| `hideSecond`  | `boolean` | -       | Hide seconds |
| `hourStep`    | `number`  | -       | Hour step    |
| `minuteStep`  | `number`  | -       | Minute step  |
| `secondStep`  | `number`  | -       | Second step  |

### Inherited from PickerTriggerWithSeparatorProps

| Property           | Type               | Default | Description              |
| ------------------ | ------------------ | ------- | ------------------------ |
| `className`        | `string`           | -       | CSS class                |
| `clearable`        | `boolean`          | `true`  | Whether clearable        |
| `disabled`         | `boolean`          | `false` | Whether disabled         |
| `error`            | `boolean`          | `false` | Error state              |
| `fullWidth`        | `boolean`          | `false` | Whether full width       |
| `onClear`          | `MouseEventHandler` | -      | Clear callback           |
| `placeholderLeft`  | `string`           | -       | Date field placeholder   |
| `placeholderRight` | `string`           | -       | Time field placeholder   |
| `prefix`           | `ReactNode`        | -       | Prefix element           |
| `readOnly`         | `boolean`          | -       | Whether read-only        |
| `required`         | `boolean`          | `false` | Whether required         |
| `size`             | `'main' \| 'sub'`  | -       | Size                     |

---

## Usage Examples

### Basic Usage

```tsx
import { DateTimePicker } from '@mezzanine-ui/react';
import { CalendarConfigProviderDayjs } from '@mezzanine-ui/react/Calendar';

function BasicExample() {
  const [value, setValue] = useState<string | undefined>();

  return (
    <CalendarConfigProviderDayjs>
      <DateTimePicker
        value={value}
        onChange={setValue}
      />
    </CalendarConfigProviderDayjs>
  );
}
```

### Custom Format

```tsx
<DateTimePicker
  formatDate="YYYY/MM/DD"
  formatTime="HH:mm"
  placeholderLeft="Select date"
  placeholderRight="Select time"
  onChange={handleChange}
/>
```

### Hide Seconds

```tsx
<DateTimePicker
  hideSecond
  formatTime="HH:mm"
  onChange={handleChange}
/>
```

### Time Steps

```tsx
<DateTimePicker
  hourStep={1}
  minuteStep={15}
  secondStep={30}
  onChange={handleChange}
/>
```

### Disable Specific Dates

```tsx
<DateTimePicker
  isDateDisabled={(date) => {
    // Disable past dates
    return dayjs(date).isBefore(dayjs(), 'day');
  }}
  onChange={handleChange}
/>
```

### With Default Value

```tsx
<DateTimePicker
  defaultValue="2024-01-15T10:30:00"
  onChange={handleChange}
/>
```

### Controlled Mode

```tsx
function ControlledExample() {
  const [value, setValue] = useState<string | undefined>();

  return (
    <>
      <DateTimePicker
        value={value}
        onChange={setValue}
      />
      <Button onClick={() => setValue(dayjs().toISOString())}>
        Set to Now
      </Button>
    </>
  );
}
```

---

## Component Structure

DateTimePicker consists of two independent input fields and panels:
1. **Left input**: Date selection, shows calendar panel on focus
2. **Right input**: Time selection, shows time panel on focus

```
┌─────────────────────────────────────┐
│ [Date Input] ~ [Time Input]  📅    │
└─────────────────────────────────────┘
         ↓                    ↓
   ┌───────────┐        ┌───────────┐
   │ Calendar   │        │ Time      │
   │ Panel      │        │ Panel     │
   └───────────┘        └───────────┘
```

---

## Figma Mapping

| Figma Variant                   | React Props                |
| ------------------------------- | -------------------------- |
| `DateTimePicker / Default`      | Default                    |
| `DateTimePicker / Disabled`     | `disabled`                 |
| `DateTimePicker / Error`        | `error`                    |
| `DateTimePicker / With Value`   | `value` is set             |
| `DateTimePicker / Hide Second`  | `hideSecond`               |

---

## Behavior Notes

- **Suffix overlay when clearable (since RC3)**: When `clearable` is true, the clear icon overlays the calendar-time suffix icon using PickerTriggerWithSeparator's `hideSuffixWhenClearable` pattern. The suffix icon is hidden while the clear button is visible.

---

## Best Practices

1. **Context required**: Must be wrapped in CalendarContext.Provider
2. **Consistent formats**: `formatDate` and `formatTime` should match the actual use case
3. **Time steps**: Use step props to limit selectable times
4. **Input validation**: The component automatically validates input format
5. **Complete selection**: onChange only fires when both date and time are selected
