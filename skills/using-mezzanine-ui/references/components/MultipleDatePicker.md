# MultipleDatePicker Component

> **Category**: Data Entry
>
> **Storybook**: `Data Entry/MultipleDatePicker`
>
> **Source**: [GitHub Source Code](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/react/src/MultipleDatePicker) · Verified v2 source (2026-03-06)

A multiple date picker that allows selecting multiple dates from a calendar, displaying selected dates as Tags. Requires manual confirmation before triggering onChange. Must be used with `CalendarContext`.

## Import

```tsx
import MultipleDatePicker, {
  MultipleDatePickerTrigger,
  useMultipleDatePickerValue,
} from '@mezzanine-ui/react/MultipleDatePicker';

import type {
  MultipleDatePickerDateValue,
  MultipleDatePickerProps,
  MultipleDatePickerTriggerProps,
  UseMultipleDatePickerValueProps,
  UseMultipleDatePickerValueReturn,
} from '@mezzanine-ui/react/MultipleDatePicker';
```

---

## MultipleDatePicker Props

| Property               | Type                                        | Default        | Description                          |
| ---------------------- | ------------------------------------------- | -------------- | ------------------------------------ |
| `actions`              | `Partial<CalendarFooterActionsProps['actions']>` | -           | Custom confirm/cancel button props   |
| `calendarProps`        | `CalendarProps` (partial omit)              | -              | Calendar extra props                 |
| `className`            | `string`                                    | -              | Outer container CSS class            |
| `clearable`            | `boolean`                                   | `true`         | Whether clearable                    |
| `disabled`             | `boolean`                                   | `false`        | Whether disabled                     |
| `disabledMonthSwitch`  | `boolean`                                   | `false`        | Disable month switching              |
| `disabledYearSwitch`   | `boolean`                                   | `false`        | Disable year switching               |
| `disableOnDoubleNext`  | `boolean`                                   | -              | Disable double arrow next            |
| `disableOnDoublePrev`  | `boolean`                                   | -              | Disable double arrow prev            |
| `disableOnNext`        | `boolean`                                   | -              | Disable next                         |
| `disableOnPrev`        | `boolean`                                   | -              | Disable prev                         |
| `displayMonthLocale`   | `string`                                    | -              | Month display localization           |
| `error`                | `boolean`                                   | `false`        | Error state                          |
| `format`               | `string`                                    | `'YYYY-MM-DD'` | Date tag display format              |
| `fullWidth`            | `boolean`                                   | `false`        | Whether full width                   |
| `isDateDisabled`       | `(date: DateType) => boolean`               | -              | Date disable check                   |
| `maxSelections`        | `number`                                    | -              | Maximum selectable dates             |
| `onCalendarToggle`     | `(open: boolean) => void`                   | -              | Calendar toggle callback             |
| `onChange`             | `(value: MultipleDatePickerValue) => void`  | -              | Change callback after confirmation   |
| `overflowStrategy`    | `'counter' \| 'wrap'`                       | `'counter'`    | Tag overflow strategy                |
| `placeholder`          | `string`                                    | -              | Placeholder text when none selected  |
| `popperProps`          | `InputTriggerPopperProps` (partial omit)    | -              | Popper positioning props             |
| `prefix`               | `ReactNode`                                 | -              | Prefix element                       |
| `readOnly`             | `boolean`                                   | `false`        | Whether read-only                    |
| `referenceDate`        | `DateType`                                  | -              | Reference date (defaults to now)     |
| `required`             | `boolean`                                   | -              | Whether required                     |
| `size`                 | `'main' \| 'sub'`                           | `'main'`       | Size                                 |
| `value`                | `MultipleDatePickerValue`                   | `[]`           | Selected dates array (controlled)    |

---

## MultipleDatePickerTrigger Props

Extends `TextFieldProps` (excluding `active`, `children`, `defaultChecked`, `disabled`, `readonly`, `typing`).

| Property           | Type                                | Default      | Description                      |
| ------------------ | ----------------------------------- | ------------ | -------------------------------- |
| `active`           | `boolean`                           | `false`      | Whether in open state (styling)  |
| `className`        | `string`                            | -            | CSS class                        |
| `clearable`        | `boolean`                           | `true`       | Whether clearable                |
| `disabled`         | `boolean`                           | `false`      | Whether disabled                 |
| `error`            | `boolean`                           | `false`      | Error state                      |
| `fullWidth`        | `boolean`                           | `false`      | Whether full width               |
| `onTagClose`       | `(date: DateType) => void`          | -            | Tag close (remove date) callback |
| `overflowStrategy` | `'counter' \| 'wrap'`              | `'counter'`  | Tag overflow strategy            |
| `placeholder`      | `string`                            | -            | Placeholder when none selected   |
| `prefix`           | `ReactNode`                         | -            | Prefix element                   |
| `readOnly`         | `boolean`                           | `false`      | Whether read-only                |
| `required`         | `boolean`                           | `false`      | Whether required                 |
| `size`             | `'main' \| 'sub'`                   | `'main'`     | Size                             |
| `suffix`           | `ReactNode`                         | -            | Suffix element (e.g., calendar icon) |
| `value`            | `DateValue[]`                       | `[]`         | Selected date value array        |

---

## useMultipleDatePickerValue Hook

### Props (UseMultipleDatePickerValueProps)

| Property         | Type                        | Default    | Description            |
| ---------------- | --------------------------- | ---------- | ---------------------- |
| `format`         | `string`                    | Required   | Date format string     |
| `maxSelections`  | `number`                    | -          | Maximum selectable     |
| `value`          | `MultipleDatePickerValue`   | `[]`       | Controlled value       |

### Return Value (UseMultipleDatePickerValueReturn)

| Property          | Type                                      | Description                              |
| ----------------- | ----------------------------------------- | ---------------------------------------- |
| `internalValue`   | `MultipleDatePickerValue`                 | Internal temporary value (pending confirm) |
| `toggleDate`      | `(date: DateType) => void`                | Toggle date selection/deselection        |
| `removeDate`      | `(date: DateType) => void`                | Remove a specific date from selection    |
| `clearAll`        | `() => void`                              | Clear all selected dates                 |
| `isDateSelected`  | `(date: DateType) => boolean`             | Check if a date is selected              |
| `isMaxReached`    | `boolean`                                 | Whether max selection count is reached   |
| `getConfirmValue` | `() => MultipleDatePickerValue`           | Get confirmed value (for onChange)        |
| `revertToValue`   | `() => void`                              | Revert to original controlled value (cancel) |
| `formatDate`      | `(date: DateType) => string`              | Format date to display string            |

---

## Type Definitions

```tsx
// Date array value
type MultipleDatePickerValue = DateType[];

// Trigger display date value
interface MultipleDatePickerDateValue {
  id: string;
  name: string;
  date: DateType;
}

// Overflow strategy
type OverflowStrategy = 'counter' | 'wrap';
```

---

## Usage Examples

### Basic Usage

```tsx
import { CalendarConfigProviderDayjs } from '@mezzanine-ui/react/Calendar';
import MultipleDatePicker from '@mezzanine-ui/react/MultipleDatePicker';
// MultipleDatePickerValue (= DateType[]) is not exported from the react package, use DateType[] directly
// Or from core: import type { MultipleDatePickerValue } from '@mezzanine-ui/core/multiple-date-picker';

function BasicExample() {
  const [value, setValue] = useState<DateType[]>([]);

  return (
    <CalendarConfigProviderDayjs>
      <MultipleDatePicker
        placeholder="Select multiple dates"
        value={value}
        onChange={setValue}
      />
    </CalendarConfigProviderDayjs>
  );
}
```

### Limit Selection Count

```tsx
<MultipleDatePicker
  maxSelections={5}
  placeholder="Select up to 5 dates"
  value={value}
  onChange={setValue}
/>
```

### Custom Format and Overflow Strategy

```tsx
<MultipleDatePicker
  format="MM/DD"
  overflowStrategy="wrap"
  fullWidth
  value={value}
  onChange={setValue}
/>
```

### Disable Specific Dates

```tsx
<MultipleDatePicker
  isDateDisabled={(date) => {
    // Disable weekends
    const dayOfWeek = dayjs(date).day();
    return dayOfWeek === 0 || dayOfWeek === 6;
  }}
  value={value}
  onChange={setValue}
/>
```

### Custom Action Button Text

```tsx
<MultipleDatePicker
  actions={{
    primaryButtonProps: { children: 'OK' },
    secondaryButtonProps: { children: 'Cancel' },
  }}
  value={value}
  onChange={setValue}
/>
```

### Using useMultipleDatePickerValue Hook (Custom Composition)

```tsx
import { useMultipleDatePickerValue } from '@mezzanine-ui/react/MultipleDatePicker';

function CustomMultipleDatePicker() {
  const [value, setValue] = useState<MultipleDatePickerValue>([]);

  const {
    internalValue,
    toggleDate,
    isDateSelected,
    isMaxReached,
    getConfirmValue,
    revertToValue,
    formatDate,
  } = useMultipleDatePickerValue({
    format: 'YYYY-MM-DD',
    maxSelections: 3,
    value,
  });

  const handleConfirm = () => {
    setValue(getConfirmValue());
  };

  return (
    <div>
      <p>{internalValue.length} dates selected</p>
      {internalValue.map((date) => (
        <span key={formatDate(date)}>{formatDate(date)}</span>
      ))}
      <button onClick={handleConfirm}>Confirm</button>
      <button onClick={revertToValue}>Cancel</button>
    </div>
  );
}
```

---

## Component Structure

MultipleDatePicker consists of a trigger and a calendar popup:

```
┌─────────────────────────────────────────┐
│ [Tag1] [Tag2] [+3]              📅     │  ← MultipleDatePickerTrigger
└─────────────────────────────────────────┘
         ↓
┌─────────────────────┐
│    Calendar Panel    │
│  ┌─────────────┐    │
│  │  Select Date │    │
│  └─────────────┘    │
│ [Cancel]   [Confirm] │  ← CalendarFooterActions
└─────────────────────┘
```

---

## Best Practices

1. **Context required**: Must be wrapped in CalendarContext.Provider
2. **Manual confirmation**: This component uses manual confirmation mode; onChange triggers only on confirm
3. **Overflow handling**: When there are too many tags, defaults to `counter` strategy showing `+N`; `wrap` strategy wraps to new lines
4. **Selection limit**: Use `maxSelections` to limit selectable dates; when the limit is reached, unselected dates are auto-disabled
5. **Date sorting**: Selected dates are automatically sorted chronologically internally
