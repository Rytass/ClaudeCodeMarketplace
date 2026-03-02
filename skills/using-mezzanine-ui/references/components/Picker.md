# Picker Component

> **Category**: Internal
>
> **Storybook**: `Internal/Picker`
>
> **Source Verification**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/react/src/Picker)

Internal shared Picker base components and Hooks, used by picker components such as DatePicker, DateRangePicker, TimePicker, TimeRangePicker, DateTimePicker, etc. Not recommended for direct use, but can be referenced or composed when building custom pickers.

## Import

```tsx
import {
  PickerTrigger,
  RangePickerTrigger,
  usePickerDocumentEventClose,
  usePickerValue,
  useTabKeyClose,
} from '@mezzanine-ui/react/Picker';

import type {
  PickerTriggerProps,
  RangePickerTriggerProps,
  UsePickerDocumentEventCloseProps,
  UsePickerValueProps,
} from '@mezzanine-ui/react/Picker';
```

> This module also exports lower-level components and utilities such as `FormattedInput`, `PickerTriggerWithSeparator`, `usePickerInputValue`, `useDateInputFormatter`, `MaskFormat`, etc.

---

## PickerTrigger Props

A single input trigger based on TextField, with FormattedInput support for formatted input.

| Property          | Type                                        | Default  | Description                    |
| ----------------- | ------------------------------------------- | -------- | ------------------------------ |
| `className`       | `string`                                    | -        | CSS class                      |
| `clearable`       | `boolean`                                   | `true`   | Whether clearable              |
| `disabled`        | `boolean`                                   | `false`  | Whether disabled               |
| `error`           | `boolean`                                   | `false`  | Error state                    |
| `errorMessages`   | `FormattedInputProps['errorMessages']`      | -        | Error message configuration    |
| `format`          | `string`                                    | -        | Input format (e.g. `'YYYY-MM-DD'`) |
| `fullWidth`       | `boolean`                                   | `true`   | Whether full width             |
| `inputProps`      | `InputProps` (partial omit)                 | -        | Additional input props         |
| `inputRef`        | `RefObject<HTMLInputElement \| null>`       | -        | Input ref                      |
| `onChange`        | `ChangeEventHandler<HTMLInputElement>`      | -        | Input change callback          |
| `placeholder`     | `string`                                    | -        | placeholder                    |
| `prefix`          | `ReactNode`                                 | -        | Prefix element                 |
| `readOnly`        | `boolean`                                   | `false`  | Whether read-only              |
| `required`        | `boolean`                                   | `false`  | Whether required               |
| `size`            | `'main' \| 'sub'`                           | `'main'` | Size                           |
| `suffix`          | `ReactNode`                                 | -        | Suffix element                 |
| `validate`        | `FormattedInputProps['validate']`           | -        | Custom validation function     |
| `value`           | `string`                                    | -        | Input value                    |

---

## PickerTriggerWithSeparator Props

A dual input trigger based on TextField (left and right separated by a divider), used in scenarios like DateTimePicker where date and time need to be entered separately. Contains two FormattedInput instances internally.

| Property                | Type                                                   | Default  | Description                                    |
| ----------------------- | ------------------------------------------------------ | -------- | ---------------------------------------------- |
| `className`             | `string`                                               | -        | CSS class                                      |
| `clearable`             | `boolean`                                              | `true`   | Whether clearable                              |
| `disabled`              | `boolean`                                              | `false`  | Whether disabled                               |
| `error`                 | `boolean`                                              | `false`  | Error state                                    |
| `errorMessagesLeft`     | `FormattedInputProps['errorMessages']`                 | -        | Left input field error messages                |
| `errorMessagesRight`    | `FormattedInputProps['errorMessages']`                 | -        | Right input field error messages               |
| `formatLeft`            | `string`                                               | required | Left input format (e.g. `'YYYY-MM-DD'`)       |
| `formatRight`           | `string`                                               | required | Right input format (e.g. `'HH:mm:ss'`)        |
| `fullWidth`             | `boolean`                                              | `true`   | Whether full width                             |
| `inputLeftProps`        | `InputProps` (partial omit)                            | -        | Left input additional props                    |
| `inputLeftRef`          | `RefObject<HTMLInputElement \| null>`                  | -        | Left input ref                                 |
| `inputRightProps`       | `InputProps` (partial omit)                            | -        | Right input additional props                   |
| `inputRightRef`         | `RefObject<HTMLInputElement \| null>`                  | -        | Right input ref                                |
| `onBlurLeft`            | `FocusEventHandler<HTMLInputElement>`                  | -        | Left input blur callback                       |
| `onBlurRight`           | `FocusEventHandler<HTMLInputElement>`                  | -        | Right input blur callback                      |
| `onChangeLeft`          | `(value: string, rawDigits: string) => void`           | -        | Left input change                              |
| `onChangeRight`         | `(value: string, rawDigits: string) => void`           | -        | Right input change                             |
| `onFocusLeft`           | `FocusEventHandler<HTMLInputElement>`                  | -        | Left input focus callback                      |
| `onFocusRight`          | `FocusEventHandler<HTMLInputElement>`                  | -        | Right input focus callback                     |
| `onLeftComplete`        | `() => void`                                           | -        | Left input complete callback (can trigger auto-focus to right) |
| `onPasteIsoValueLeft`   | `(isoValue: string) => void`                           | -        | Left paste valid ISO value callback            |
| `onPasteIsoValueRight`  | `(isoValue: string) => void`                           | -        | Right paste valid ISO value callback           |
| `onRightComplete`       | `() => void`                                           | -        | Right input complete callback                  |
| `placeholderLeft`       | `string`                                               | -        | Left placeholder                               |
| `placeholderRight`      | `string`                                               | -        | Right placeholder                              |
| `prefix`                | `ReactNode`                                            | -        | Prefix element                                 |
| `readOnly`              | `boolean`                                              | `false`  | Whether read-only                              |
| `required`              | `boolean`                                              | `false`  | Whether required                               |
| `size`                  | `'main' \| 'sub'`                                      | -        | Size                                           |
| `suffix`                | `ReactNode`                                            | -        | Suffix element                                 |
| `validateLeft`          | `(isoDate: string) => boolean`                         | -        | Left custom validation function                |
| `validateRight`         | `(isoDate: string) => boolean`                         | -        | Right custom validation function               |
| `valueLeft`             | `string`                                               | -        | Left input value                               |
| `valueRight`            | `string`                                               | -        | Right input value                              |

---

## RangePickerTrigger Props

A dual input trigger based on TextField, used for range pickers (e.g. DateRangePicker, TimeRangePicker), containing "from" and "to" FormattedInput instances separated by an arrow icon.

| Property                 | Type                                                     | Default  | Description                    |
| ------------------------ | -------------------------------------------------------- | -------- | ------------------------------ |
| `className`              | `string`                                                 | -        | CSS class                      |
| `clearable`              | `boolean`                                                | `true`   | Whether clearable              |
| `disabled`               | `boolean`                                                | `false`  | Whether disabled               |
| `error`                  | `boolean`                                                | `false`  | Error state                    |
| `errorMessagesFrom`      | `FormattedInputProps['errorMessages']`                   | -        | From field error messages      |
| `errorMessagesTo`        | `FormattedInputProps['errorMessages']`                   | -        | To field error messages        |
| `format`                 | `string`                                                 | required | Input format                   |
| `fullWidth`              | `boolean`                                                | `true`   | Whether full width (inherited from TextField) |
| `inputFromPlaceholder`   | `string`                                                 | -        | From field placeholder         |
| `inputFromProps`         | `InputProps` (partial omit)                              | -        | From field additional props    |
| `inputFromRef`           | `RefObject<HTMLInputElement \| null>`                    | -        | From field ref                 |
| `inputFromValue`         | `string`                                                 | -        | From field value               |
| `inputToPlaceholder`     | `string`                                                 | -        | To field placeholder           |
| `inputToProps`           | `InputProps` (partial omit)                              | -        | To field additional props      |
| `inputToRef`             | `RefObject<HTMLInputElement \| null>`                    | -        | To field ref                   |
| `inputToValue`           | `string`                                                 | -        | To field value                 |
| `onFromBlur`             | `FocusEventHandler<HTMLInputElement>`                    | -        | From field blur callback       |
| `onFromFocus`            | `FocusEventHandler<HTMLInputElement>`                    | -        | From field focus callback      |
| `onIconClick`            | `MouseEventHandler`                                      | -        | Icon click callback            |
| `onInputFromChange`      | `(formatted: string, rawDigits: string) => void`         | -        | From field input change        |
| `onInputToChange`        | `(formatted: string, rawDigits: string) => void`         | -        | To field input change          |
| `onToBlur`               | `FocusEventHandler<HTMLInputElement>`                    | -        | To field blur callback         |
| `onToFocus`              | `FocusEventHandler<HTMLInputElement>`                    | -        | To field focus callback        |
| `prefix`                 | `ReactNode`                                              | -        | Prefix element                 |
| `readOnly`               | `boolean`                                                | `false`  | Whether read-only              |
| `required`               | `boolean`                                                | `false`  | Whether required               |
| `size`                   | `'main' \| 'sub'`                                        | -        | Size                           |
| `suffix`                 | `ReactNode`                                              | -        | Suffix element                 |
| `suffixActionIcon`       | `ReactNode`                                              | -        | Suffix action icon (takes priority over suffix) |
| `validateFrom`           | `(isoDate: string) => boolean`                           | -        | From field custom validation   |
| `validateTo`             | `(isoDate: string) => boolean`                           | -        | To field custom validation     |

---

## usePickerDocumentEventClose Hook

Manages picker popup close behavior, including: click outside to close, Escape key to close, Tab key to close.

### Props (UsePickerDocumentEventCloseProps)

| Property                   | Type                                 | Description                                  |
| -------------------------- | ------------------------------------ | -------------------------------------------- |
| `anchorRef`                | `RefObject<HTMLElement \| null>`     | Trigger ref (for click outside detection)    |
| `lastElementRefInFlow`     | `RefObject<HTMLElement \| null>`     | Last element ref in flow (for Tab key)       |
| `onClose`                  | `VoidFunction`                       | Escape key close callback (does not commit changes) |
| `onChangeClose`            | `VoidFunction`                       | Click outside/Tab key close callback (commits changes) |
| `open`                     | `boolean`                            | Whether open                                 |
| `popperRef`                | `RefObject<HTMLElement \| null>`     | Popup ref (to determine if click is inside popup) |

---

## usePickerValue Hook

Tracks synchronization between Picker internal value and input value.

### Props (UsePickerValueProps)

| Property        | Type                                    | Description        |
| --------------- | --------------------------------------- | ------------------ |
| `defaultValue`  | `DateType`                              | Default value      |
| `format`        | `string`                                | Display format     |
| `inputRef`      | `RefObject<HTMLInputElement \| null>`   | Input ref          |
| `value`         | `DateType`                              | Controlled value   |

### Return Value

| Property        | Type                                            | Description                          |
| --------------- | ----------------------------------------------- | ------------------------------------ |
| `inputValue`    | `string`                                        | Formatted input display value        |
| `onBlur`        | `FocusEventHandler<HTMLInputElement>`           | Blur handler (validates value)       |
| `onChange`      | `(val?: DateType) => void`                      | Syncs input and internal value       |
| `onInputChange` | `ChangeEventHandler<HTMLInputElement>`          | Input text change handler            |
| `onKeyDown`     | `KeyboardEventHandler<HTMLInputElement>`        | Keyboard event handler (Enter/Escape) |
| `value`         | `DateType \| undefined`                         | Current internal value               |

---

## useTabKeyClose Hook

Listens for the Tab key and triggers close when focus leaves the last element in the flow.

```tsx
function useTabKeyClose(
  onClose: VoidFunction,
  lastElementRefInFlow: RefObject<HTMLElement | null>,
  deps?: DependencyList,
): void;
```

---

## Usage Examples

### Custom Single Value Picker

```tsx
import {
  PickerTrigger,
  usePickerValue,
  usePickerDocumentEventClose,
} from '@mezzanine-ui/react/Picker';

function CustomPicker() {
  const inputRef = useRef<HTMLInputElement>(null);
  const anchorRef = useRef<HTMLDivElement>(null);
  const popperRef = useRef<HTMLDivElement>(null);
  const [open, setOpen] = useState(false);

  const { inputValue, onChange, onBlur, onKeyDown, value } = usePickerValue({
    format: 'YYYY-MM-DD',
    inputRef,
    value: controlledValue,
  });

  usePickerDocumentEventClose({
    anchorRef,
    lastElementRefInFlow: inputRef,
    onClose: () => setOpen(false),
    onChangeClose: () => {
      onExternalChange?.(value);
      setOpen(false);
    },
    open,
    popperRef,
  });

  return (
    <PickerTrigger
      ref={anchorRef}
      format="YYYY-MM-DD"
      inputRef={inputRef}
      onBlur={onBlur}
      placeholder="Select date"
      value={inputValue}
    />
  );
}
```

### Custom Range Picker

```tsx
import {
  RangePickerTrigger,
  usePickerDocumentEventClose,
} from '@mezzanine-ui/react/Picker';

function CustomRangePicker() {
  const anchorRef = useRef<HTMLDivElement>(null);
  const popperRef = useRef<HTMLDivElement>(null);
  const inputFromRef = useRef<HTMLInputElement>(null);
  const inputToRef = useRef<HTMLInputElement>(null);
  const [open, setOpen] = useState(false);

  usePickerDocumentEventClose({
    anchorRef,
    lastElementRefInFlow: inputToRef,
    onClose: () => setOpen(false),
    onChangeClose: () => {
      handleSubmit();
      setOpen(false);
    },
    open,
    popperRef,
  });

  return (
    <RangePickerTrigger
      ref={anchorRef}
      format="HH:mm"
      inputFromRef={inputFromRef}
      inputFromPlaceholder="Start"
      inputFromValue={fromValue}
      inputToRef={inputToRef}
      inputToPlaceholder="End"
      inputToValue={toValue}
      onFromFocus={() => setOpen(true)}
      onToFocus={() => setOpen(true)}
      onInputFromChange={handleFromChange}
      onInputToChange={handleToChange}
    />
  );
}
```

### Using useTabKeyClose to Listen for Tab Close

```tsx
import { useTabKeyClose } from '@mezzanine-ui/react/Picker';

function PickerWithTabClose() {
  const lastInputRef = useRef<HTMLInputElement>(null);

  useTabKeyClose(
    () => {
      setOpen(false);
      handleSubmit();
    },
    lastInputRef,
    [handleSubmit],
  );

  return <input ref={lastInputRef} />;
}
```

---

## Component Structure

### PickerTrigger (Single Input)

```
┌──────────────────────────────────┐
│ [FormattedInput]          [icon] │  ← TextField wrapper
└──────────────────────────────────┘
```

### PickerTriggerWithSeparator (Separated Dual Input)

```
┌──────────────────────────────────────────────┐
│ [FormattedInput(left)] | [FormattedInput(right)] [icon] │  ← TextField wrapper
└──────────────────────────────────────────────┘
```

### RangePickerTrigger (Dual Input)

```
┌──────────────────────────────────────────┐
│ [FormattedInput] → [FormattedInput] [icon] │  ← TextField wrapper
└──────────────────────────────────────────┘
```

---

## Best Practices

1. **Internal component**: This module is a shared internal component; in general, use high-level components (DatePicker, TimePicker, etc.) directly
2. **Close behavior separation**: `onClose` is for Escape (reverts value), `onChangeClose` is for click outside and Tab (commits changes)
3. **FormattedInput**: PickerTrigger and RangePickerTrigger internally use FormattedInput to implement formatted typing
4. **Ref management**: Use `anchorRef`, `popperRef`, `inputRef` with usePickerDocumentEventClose to implement complete open/close logic
5. **Custom pickers**: To build custom pickers, compose PickerTrigger/RangePickerTrigger with usePickerDocumentEventClose
