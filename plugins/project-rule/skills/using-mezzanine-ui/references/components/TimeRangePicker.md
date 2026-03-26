# TimeRangePicker Component

> **Category**: Data Entry
>
> **Storybook**: `Data Entry/TimeRangePicker`
>
> **Source Verification**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/react/src/TimeRangePicker) | Verified rc.7: 2026-03-26

Time range picker for selecting start and end times. Uses RangePickerTrigger to provide dual inputs with a TimePickerPanel panel. Must be used with `CalendarContext`.

## Import

```tsx
// Main package import (recommended) — hook and types are also available from the main package
import {
  TimeRangePicker,
  useTimeRangePickerValue,
} from '@mezzanine-ui/react';
import type {
  TimeRangePickerProps,
  TimeRangePickerValue,
  UseTimeRangePickerValueProps,
} from '@mezzanine-ui/react';

// Or import from subpath
import TimeRangePicker, {
  useTimeRangePickerValue,
} from '@mezzanine-ui/react/TimeRangePicker';
```

---

## TimeRangePicker Props

> Extends `TimePickerPanelProps` (fadeProps, hideHour, hideMinute, hideSecond, hourStep, minuteStep, popperProps, secondStep) and `RangePickerTriggerProps` (className, clearable, disabled, error, errorMessagesFrom, errorMessagesTo, fullWidth, inputFromPlaceholder, inputFromProps, inputToPlaceholder, inputToProps, prefix, readOnly, required, size, validateFrom, validateTo).
>
> `ref` (forwardRef) points to the root `HTMLDivElement`.

### Own Properties

| Property        | Type                                      | Default                                        | Description            |
| --------------- | ----------------------------------------- | ---------------------------------------------- | ---------------------- |
| `format`        | `string`                                  | `'HH:mm:ss'` (`'HH:mm'` when hideSecond)      | Time display format    |
| `onChange`      | `(target?: TimeRangePickerValue) => void` | -                                              | Change callback        |
| `onPanelToggle` | `(open: boolean) => void`                 | -                                              | Panel toggle callback  |
| `value`         | `TimeRangePickerValue`                    | -                                              | Selected value (controlled) |

### Inherited from TimePickerPanelProps

| Property      | Type         | Default | Description              |
| ------------- | ------------ | ------- | ------------------------ |
| `fadeProps`   | `FadeProps`  | -       | Fade animation props     |
| `hideHour`    | `boolean`    | -       | Hide hours               |
| `hideMinute`  | `boolean`    | -       | Hide minutes             |
| `hideSecond`  | `boolean`    | -       | Hide seconds             |
| `hourStep`    | `number`     | -       | Hour interval            |
| `minuteStep`  | `number`     | -       | Minute interval          |
| `popperProps` | `Omit<InputTriggerPopperProps, 'anchor' \| 'children' \| 'fadeProps' \| 'open'>` | - | Popper positioning props |
| `secondStep`  | `number`     | -       | Second interval          |

### Inherited from RangePickerTriggerProps

| Property               | Type                                   | Default | Description              |
| ---------------------- | -------------------------------------- | ------- | ------------------------ |
| `className`            | `string`                               | -       | CSS class                |
| `clearable`            | `boolean`                              | `true`  | Whether clearable        |
| `disabled`             | `boolean`                              | `false` | Whether disabled         |
| `error`                | `boolean`                              | `false` | Error state              |
| `errorMessagesFrom`    | `FormattedInputProps['errorMessages']` | -       | From field error messages |
| `errorMessagesTo`      | `FormattedInputProps['errorMessages']` | -       | To field error messages  |
| `fullWidth`            | `boolean`                              | `false` | Whether full width       |
| `inputFromPlaceholder` | `string`                               | -       | From field placeholder   |
| `inputFromProps`       | `InputProps`                           | -       | From field additional props |
| `inputToPlaceholder`   | `string`                               | -       | To field placeholder     |
| `inputToProps`         | `InputProps`                           | -       | To field additional props |
| `prefix`               | `ReactNode`                            | -       | Prefix element           |
| `readOnly`             | `boolean`                              | -       | Whether read-only        |
| `required`             | `boolean`                              | `false` | Whether required         |
| `size`                 | `'main' \| 'sub'`                      | -       | Size                     |
| `validateFrom`         | `(isoDate: string) => boolean`         | -       | From field custom validation |
| `validateTo`           | `(isoDate: string) => boolean`         | -       | To field custom validation |

> The `format` default depends on `hideSecond`: if `hideSecond` is `true`, the default is `'HH:mm'`; otherwise it uses CalendarContext's `defaultTimeFormat`.

---

## useTimeRangePickerValue Hook

### Props (UseTimeRangePickerValueProps)

| Property   | Type                                      | Default  | Description          |
| ---------- | ----------------------------------------- | -------- | -------------------- |
| `format`   | `string`                                  | required | Time format string   |
| `onChange`  | `(value?: TimeRangePickerValue) => void`  | -        | Change callback      |
| `value`    | `TimeRangePickerValue`                    | -        | Controlled value     |

### Return Value

| Property            | Type                                              | Description                      |
| ------------------- | ------------------------------------------------- | -------------------------------- |
| `focusedInput`      | `'from' \| 'to' \| null`                          | Currently focused input          |
| `inputFromValue`    | `string`                                          | From field display value         |
| `inputToValue`      | `string`                                          | To field display value           |
| `onChange`          | `(target?: TimeRangePickerValue) => TimeRangePickerValue \| undefined` | Update internal value |
| `onClear`           | `() => void`                                      | Clear all values                 |
| `onFromFocus`       | `() => void`                                      | From field focus handler         |
| `onInputFromChange` | `(formatted: string \| undefined) => void`        | From field input change          |
| `onInputToChange`   | `(formatted: string \| undefined) => void`        | To field input change            |
| `onPanelChange`     | `(newTime: DateType \| undefined) => void`        | Panel selection change           |
| `onToFocus`         | `() => void`                                      | To field focus handler           |
| `panelValue`        | `DateType \| undefined`                           | Current panel corresponding value |
| `value`             | `TimeRangePickerValue`                            | Current internal value           |

---

## Type Definitions

```tsx
type TimeRangePickerValue = [DateType | undefined, DateType | undefined];
```

---

## Usage Examples

### Basic Usage

```tsx
import { CalendarConfigProviderDayjs } from '@mezzanine-ui/react/Calendar';
import TimeRangePicker from '@mezzanine-ui/react/TimeRangePicker';
import type { TimeRangePickerValue } from '@mezzanine-ui/react/TimeRangePicker';

function BasicExample() {
  const [value, setValue] = useState<TimeRangePickerValue | undefined>();

  return (
    <CalendarConfigProviderDayjs>
      <TimeRangePicker
        value={value}
        onChange={setValue}
      />
    </CalendarConfigProviderDayjs>
  );
}
```

### Hide Seconds

```tsx
<TimeRangePicker
  hideSecond
  inputFromPlaceholder="Start time"
  inputToPlaceholder="End time"
  value={value}
  onChange={setValue}
/>
```

### Time Interval and Validation

```tsx
<TimeRangePicker
  hourStep={1}
  minuteStep={15}
  hideSecond
  validateFrom={(isoDate) => {
    // Start time not earlier than 08:00
    return dayjs(isoDate).hour() >= 8;
  }}
  validateTo={(isoDate) => {
    // End time not later than 18:00
    return dayjs(isoDate).hour() <= 18;
  }}
  value={value}
  onChange={setValue}
/>
```

### With Error Messages

```tsx
<TimeRangePicker
  error
  errorMessagesFrom={{
    invalidInput: 'Invalid time format',
  }}
  errorMessagesTo={{
    invalidInput: 'Invalid time format',
  }}
  value={value}
  onChange={setValue}
/>
```

### Controlled Mode

```tsx
function ControlledExample() {
  const [value, setValue] = useState<TimeRangePickerValue | undefined>();

  const setWorkHours = () => {
    setValue([
      dayjs().hour(9).minute(0).second(0).toISOString(),
      dayjs().hour(18).minute(0).second(0).toISOString(),
    ]);
  };

  return (
    <>
      <TimeRangePicker
        value={value}
        onChange={setValue}
      />
      <Button onClick={setWorkHours}>Set to work hours</Button>
      <Button onClick={() => setValue(undefined)}>Clear</Button>
    </>
  );
}
```

### Independent Pending Values per Panel (rc.6)

In rc.6, each time panel maintains independent pending state, and Ok/Cancel buttons are correctly wired:

```tsx
<TimeRangePicker
  hideSecond
  value={value}
  onChange={setValue}
/>

// User can interact with from/to panels independently:
// - Focus from input → opens from panel with pending state
// - Select time → shows preview in panel
// - Click Ok → commits to onChange
// - Click Cancel → discards changes, panel closes
// - Focus to input → opens to panel independently
```

---

## Component Structure

TimeRangePicker uses RangePickerTrigger to display dual inputs, and shows the corresponding TimePickerPanel on focus:

```
┌──────────────────────────────────────────┐
│ [Start time]  →  [End time]        🕐    │  ← RangePickerTrigger
└──────────────────────────────────────────┘
         ↓                    ↓
   ┌──────────────┐     ┌──────────────┐
   │ Time panel   │     │ Time panel   │
   │  (from)      │     │  (to)        │
   │ HH : MM : SS │     │ HH : MM : SS │
   └──────────────┘     └──────────────┘
```

The time panel anchors its position to follow the focused input.

---

## Internal Implementation Notes

- The panel dynamically anchors to the focused input (from/to)
- `readOnly` prevents panel from opening
- Uses `usePickerDocumentEventClose` to handle click outside to close
- Integrates with `CalendarContext` to get the default time format

---

## Best Practices

1. **Context required**: Must be wrapped in a CalendarContext.Provider
2. **Format matching**: `format` should match `hideSecond` and other settings (e.g. use `'HH:mm'` when `hideSecond`)
3. **Reasonable intervals**: Step values should be reasonable time intervals (e.g. 5, 10, 15, 30 minutes)
4. **Field validation**: Use `validateFrom`/`validateTo` to ensure time logic is correct (e.g. end time is not earlier than start time)
5. **Click outside to close**: Clicking outside the panel automatically commits the current value and closes the panel
