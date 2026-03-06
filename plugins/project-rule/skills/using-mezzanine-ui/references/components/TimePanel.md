# TimePanel Component

> **Category**: Utility
>
> **Storybook**: `Utility/Time Panel`
>
> **Source Verification**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/react/src/TimePanel)

Time panel component for selecting time. Must be used with CalendarContext.

## Import

```tsx
import { TimePanel, TimePanelAction, TimePanelColumn } from '@mezzanine-ui/react';
import type { TimePanelProps, TimePanelActionProps, TimePanelColumnProps } from '@mezzanine-ui/react';
```

---

## TimePanel Props

| Property     | Type                      | Default | Description          |
| ------------ | ------------------------- | ------- | -------------------- |
| `hideHour`   | `boolean`                 | `false` | Hide hour column     |
| `hideMinute` | `boolean`                 | `false` | Hide minute column   |
| `hideSecond` | `boolean`                 | `false` | Hide second column   |
| `hourStep`   | `number`                  | `1`     | Hour step            |
| `minuteStep` | `number`                  | `1`     | Minute step          |
| `onChange`   | `(target: DateType) => void` | -    | Change callback      |
| `secondStep` | `number`                  | `1`     | Second step          |
| `value`      | `DateType`                | -       | Current time value   |

---

## Usage Examples

### Basic Usage (requires CalendarContext)

```tsx
import { TimePanel } from '@mezzanine-ui/react';
import { CalendarConfigProviderDayjs } from '@mezzanine-ui/react/Calendar';
import { useState } from 'react';

function BasicExample() {
  const [time, setTime] = useState<string | undefined>();

  return (
    <CalendarConfigProviderDayjs>
      <TimePanel
        value={time}
        onChange={setTime}
      />
    </CalendarConfigProviderDayjs>
  );
}
```

### Show Only Hours and Minutes

```tsx
<CalendarConfigProviderDayjs>
  <TimePanel
    value={time}
    onChange={setTime}
    hideSecond
  />
</CalendarConfigProviderDayjs>
```

### Show Only Minutes and Seconds

```tsx
<CalendarConfigProviderDayjs>
  <TimePanel
    value={time}
    onChange={setTime}
    hideHour
  />
</CalendarConfigProviderDayjs>
```

### Setting Steps

```tsx
<CalendarConfigProviderDayjs>
  <TimePanel
    value={time}
    onChange={setTime}
    hourStep={1}
    minuteStep={15}  // One option every 15 minutes
    secondStep={30}  // One option every 30 seconds
  />
</CalendarConfigProviderDayjs>
```

---

## TimePanelColumn

Single column component for the time panel (hour/minute/second). `ref` (forwardRef) points to `HTMLDivElement`.

```tsx
interface TimePanelColumnProps {
  activeUnit?: TimePanelUnit['value'];
  cellHeight?: number;
  onChange?: (unit: TimePanelUnit) => void;
  units: TimePanelUnit[];
}
```

| Property     | Type                                | Default                                          | Description                  |
| ------------ | ----------------------------------- | ------------------------------------------------ | ---------------------------- |
| `activeUnit` | `TimePanelUnit['value']`            | -                                                | Currently selected time unit value |
| `cellHeight` | `number`                            | CSS variable `--mzn-spacing-size-element-loose`  | Controls scroll positioning cell height |
| `onChange`   | `(unit: TimePanelUnit) => void`     | -                                                | Selection change callback    |
| `units`      | `TimePanelUnit[]`                   | -                                                | List of time units to display |

---

## TimePanelAction

"This moment" button component for the time panel. Extends `Omit<NativeElementPropsWithoutKeyAndRef<'div'>, 'children'>`. `ref` (forwardRef) points to `HTMLDivElement`.

```tsx
interface TimePanelActionProps
  extends Omit<NativeElementPropsWithoutKeyAndRef<'div'>, 'children'> {
  onClick?: VoidFunction;
}
```

| Property  | Type           | Default | Description                    |
| --------- | -------------- | ------- | ------------------------------ |
| `onClick` | `VoidFunction` | -       | "This moment" click callback   |

---

## "This Moment" Button Behavior

When clicking the "This moment" button:
1. Gets the current time
2. Adjusts to the nearest selectable value based on step settings
3. Calls the onChange callback

---

## Relationship with TimePicker

The `TimePicker` component uses `TimePanel` internally as its time selection panel:

```tsx
// Approximate internal structure of TimePicker
function TimePicker(props) {
  return (
    <CalendarConfigProvider>
      <PickerTrigger>
        <Input />
      </PickerTrigger>
      <TimePanel
        value={value}
        onChange={onChange}
        hideHour={props.hideHour}
        hideMinute={props.hideMinute}
        hideSecond={props.hideSecond}
        hourStep={props.hourStep}
        minuteStep={props.minuteStep}
        secondStep={props.secondStep}
      />
    </CalendarConfigProvider>
  );
}
```

---

## CalendarContext Dependency

TimePanel requires the following methods from CalendarContext:
- `getHour(date)` - Get hour
- `getMinute(date)` - Get minute
- `getSecond(date)` - Get second
- `setHour(date, hour)` - Set hour
- `setMinute(date, minute)` - Set minute
- `setSecond(date, second)` - Set second
- `startOf(date, unit)` - Get the start of a given unit
- `getNow()` - Get current time

---

## Figma Mapping

| Figma Variant                 | React Props                              |
| ----------------------------- | ---------------------------------------- |
| `TimePanel / Default`         | Default (shows hour, minute, second)     |
| `TimePanel / HourMinute`      | `hideSecond`                             |
| `TimePanel / MinuteSecond`    | `hideHour`                               |
| `TimePanel / With Step`       | `hourStep`/`minuteStep`/`secondStep` set |

---

## Best Practices

1. **CalendarContext required**: Must be used within a CalendarConfigProvider
2. **Step settings**: Common step settings include 15 minutes, 30 minutes
3. **Hide seconds**: Most scenarios do not need seconds; hiding is recommended
4. **Use TimePicker**: In general, use the TimePicker component directly
5. **Date library integration**: Requires integration with date libraries such as dayjs, moment, etc.
