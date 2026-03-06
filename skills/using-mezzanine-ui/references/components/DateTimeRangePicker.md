# DateTimeRangePicker Component

> **Category**: Data Entry
>
> **Storybook**: `Data Entry/DateTimeRangePicker`
>
> **Source**: [GitHub Source Code](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/react/src/DateTimeRangePicker) · Verified v2 source (2026-03-06)

A date-time range picker that combines two DateTimePickers to select start and end date-times. Must be used with `CalendarContext`. The direction icon switches between `LongTailArrowRightIcon` / `LongTailArrowDownIcon` based on the `direction` prop.

## Import

```tsx
import { DateTimeRangePicker } from '@mezzanine-ui/react';
import type {
  DateTimeRangePickerProps,
  DateTimeRangePickerValue,
} from '@mezzanine-ui/react';
```

---

## DateTimeRangePicker Props

`DateTimeRangePickerProps` extends `Omit<DateTimePickerProps, 'defaultValue' | 'onChange' | 'value' | 'ref' | 'prefix'>`. All inherited props are applied to both DateTimePickers simultaneously.

### Own Props

| Property    | Type                                        | Default | Description              |
| ----------- | ------------------------------------------- | ------- | ------------------------ |
| `className` | `string`                                    | -       | Outer container CSS class |
| `direction` | `'row' \| 'column'`                         | `'row'` | Layout direction of the two pickers |
| `onChange`  | `(value: DateTimeRangePickerValue) => void` | -       | Range value change callback |
| `value`     | `DateTimeRangePickerValue`                  | -       | Selected value (controlled) |

### Inherited from DateTimePickerProps (shared by both DateTimePickers)

| Property               | Type                                           | Default         | Description              |
| ---------------------- | ---------------------------------------------- | --------------- | ------------------------ |
| `calendarProps`        | `Omit<CalendarProps, ...>`                     | -               | Calendar props           |
| `calendarRef`          | `RefObject<HTMLDivElement \| null>`            | -               | Calendar ref             |
| `clearable`            | `boolean`                                      | `true`          | Whether clearable        |
| `disabled`             | `boolean`                                      | `false`         | Whether disabled         |
| `disabledMonthSwitch`  | `boolean`                                      | `false`         | Disable month switching  |
| `disabledYearSwitch`   | `boolean`                                      | `false`         | Disable year switching   |
| `disableOnDoubleNext`  | `boolean`                                      | -               | Disable double arrow next |
| `disableOnDoublePrev`  | `boolean`                                      | -               | Disable double arrow prev |
| `disableOnNext`        | `boolean`                                      | -               | Disable next             |
| `disableOnPrev`        | `boolean`                                      | -               | Disable prev             |
| `displayMonthLocale`   | `string`                                       | -               | Month display locale     |
| `error`                | `boolean`                                      | `false`         | Error state              |
| `fadeProps`             | `FadeProps`                                    | -               | Fade animation props     |
| `formatDate`           | `string`                                       | Depends on mode | Date display format      |
| `formatTime`           | `string`                                       | `'HH:mm:ss'`   | Time display format (defaults to `'HH:mm'` when `hideSecond`) |
| `fullWidth`            | `boolean`                                      | `false`         | Whether full width       |
| `hideHour`             | `boolean`                                      | -               | Hide hours               |
| `hideMinute`           | `boolean`                                      | -               | Hide minutes             |
| `hideSecond`           | `boolean`                                      | -               | Hide seconds             |
| `hourStep`             | `number`                                       | -               | Hour step                |
| `isDateDisabled`       | `(date: DateType) => boolean`                  | -               | Date disable check       |
| `isHalfYearDisabled`   | `(date: DateType) => boolean`                  | -               | Half-year disable check  |
| `isMonthDisabled`      | `(date: DateType) => boolean`                  | -               | Month disable check      |
| `isQuarterDisabled`    | `(date: DateType) => boolean`                  | -               | Quarter disable check    |
| `isWeekDisabled`       | `(date: DateType) => boolean`                  | -               | Week disable check       |
| `isYearDisabled`       | `(date: DateType) => boolean`                  | -               | Year disable check       |
| `minuteStep`           | `number`                                       | -               | Minute step              |
| `mode`                 | `CalendarMode`                                 | `'day'`         | Calendar selection mode  |
| `onClear`              | `MouseEventHandler`                            | -               | Clear callback           |
| `onPanelToggle`        | `(open: boolean, focusedInput: FocusedInput) => void` | -        | Panel toggle callback    |
| `placeholderLeft`      | `string`                                       | -               | Date field placeholder   |
| `placeholderRight`     | `string`                                       | -               | Time field placeholder   |
| `popperProps`          | `Omit<InputTriggerPopperProps, ...>`           | -               | Calendar Popper props    |
| `popperPropsTime`      | `TimePickerPanelProps['popperProps']`           | -               | Time Popper props        |
| `readOnly`             | `boolean`                                      | -               | Whether read-only        |
| `referenceDate`        | `DateType`                                     | Current time    | Reference date           |
| `required`             | `boolean`                                      | `false`         | Whether required         |
| `secondStep`           | `number`                                       | -               | Second step              |
| `size`                 | `'main' \| 'sub'`                              | -               | Size                     |

---

## Type Definitions

```tsx
type DateTimeRangePickerValue = [DateType | undefined, DateType | undefined];
type FocusedInput = 'left' | 'right' | null;
```

---

## Usage Examples

### Basic Usage

```tsx
import { DateTimeRangePicker } from '@mezzanine-ui/react';
import type { DateTimeRangePickerValue } from '@mezzanine-ui/react';
import { CalendarConfigProviderDayjs } from '@mezzanine-ui/react/Calendar';

function BasicExample() {
  const [value, setValue] = useState<DateTimeRangePickerValue>([
    undefined,
    undefined,
  ]);

  return (
    <CalendarConfigProviderDayjs>
      <DateTimeRangePicker
        value={value}
        onChange={setValue}
      />
    </CalendarConfigProviderDayjs>
  );
}
```

### Vertical Layout

```tsx
<DateTimeRangePicker
  direction="column"
  value={value}
  onChange={setValue}
/>
```

### Custom Format and Hide Seconds

```tsx
<DateTimeRangePicker
  formatDate="YYYY/MM/DD"
  formatTime="HH:mm"
  hideSecond
  placeholderLeft="Select date"
  placeholderRight="Select time"
  value={value}
  onChange={setValue}
/>
```

### Disable Specific Dates

```tsx
<DateTimeRangePicker
  isDateDisabled={(date) => {
    // Disable past dates
    return dayjs(date).isBefore(dayjs(), 'day');
  }}
  value={value}
  onChange={setValue}
/>
```

### Set Time Steps

```tsx
<DateTimeRangePicker
  hourStep={1}
  minuteStep={15}
  hideSecond
  formatTime="HH:mm"
  value={value}
  onChange={setValue}
/>
```

---

## Component Structure

DateTimeRangePicker is composed of two DateTimePickers separated by an arrow icon:

```
direction="row":
┌──────────────────────────┐   →   ┌──────────────────────────┐
│ [Date] ~ [Time]       📅 │       │ [Date] ~ [Time]       📅 │
└──────────────────────────┘       └──────────────────────────┘

direction="column":
┌──────────────────────────┐
│ [Date] ~ [Time]       📅 │
└──────────────────────────┘
              ↓
┌──────────────────────────┐
│ [Date] ~ [Time]       📅 │
└──────────────────────────┘
```

---

## Best Practices

1. **Context required**: Must be wrapped in CalendarContext.Provider
2. **Layout direction**: Use `row` when space is sufficient; use `column` for narrow layouts
3. **Shared props**: All DateTimePicker-related props are applied to both pickers simultaneously
4. **Consistent formats**: `formatDate` and `formatTime` should match the actual use case
5. **Controlled mode**: value is a `[from, to]` array; onChange fires when either end changes
