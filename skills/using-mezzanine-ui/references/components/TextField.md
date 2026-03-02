# TextField Component

> **Category**: Data Entry
>
> **Storybook**: `Data Entry/TextField`
>
> **Source Verification**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/react/src/TextField)

Text input field container component providing a unified input box appearance. It is the underlying component for Input, Select, and other components.

## Import

```tsx
import { TextField } from '@mezzanine-ui/react';
import type {
  TextFieldProps,
  TextFieldBaseProps,
  TextFieldAffixProps,
  TextFieldInteractiveStateProps,
  TextFieldPaddingInfo,
  TextFieldSize
} from '@mezzanine-ui/react';
```

---

## TextField Props

> `TextFieldProps = TextFieldBaseProps & TextFieldAffixProps & TextFieldInteractiveStateProps`
>
> `ref` (forwardRef) points to the root `HTMLDivElement`.

| Property    | Type                                                        | Default  | Source                        | Description            |
| ----------- | ----------------------------------------------------------- | -------- | ----------------------------- | ---------------------- |
| `active`    | `boolean`                                                   | `false`  | TextFieldBaseProps            | Whether active state   |
| `children`  | `ReactNode \| ((paddingInfo: TextFieldPaddingInfo) => ReactNode)` | **required** | TextFieldBaseProps      | Content or function    |
| `clearable` | `boolean`                                                   | `false`  | TextFieldBaseProps            | Whether clearable      |
| `error`     | `boolean`                                                   | `false`  | TextFieldBaseProps            | Error state            |
| `fullWidth` | `boolean`                                                   | `true`   | TextFieldBaseProps            | Whether full width     |
| `onClear`   | `MouseEventHandler`                                         | -        | TextFieldBaseProps            | Clear button callback  |
| `size`      | `TextFieldSize`                                             | `'main'` | TextFieldBaseProps            | Size                   |
| `warning`   | `boolean`                                                   | `false`  | TextFieldBaseProps            | Warning state          |
| `prefix`    | `ReactNode`                                                 | -        | TextFieldAffixProps           | Prefix content         |
| `suffix`    | `ReactNode`                                                 | -        | TextFieldAffixProps           | Suffix content         |
| `typing`    | `boolean`                                                   | -        | TextFieldInteractiveStateProps | Whether typing         |
| `disabled`  | `boolean`                                                   | `false`  | TextFieldInteractiveStateProps | Whether disabled       |
| `readonly`  | `boolean`                                                   | `false`  | TextFieldInteractiveStateProps | Whether read-only      |

---

## TextFieldInteractiveStateProps

`disabled`, `readonly`, and `typing` are mutually exclusive and cannot be used simultaneously:

```tsx
// Normal state (can set typing)
type Normal = { typing?: boolean; disabled?: never; readonly?: never };

// Disabled state
type Disabled = { typing?: never; disabled: true; readonly?: never };

// Read-only state
type Readonly = { typing?: never; disabled?: never; readonly: true };
```

---

## TextFieldPaddingInfo

When children is a function, it receives padding info:

```tsx
interface TextFieldPaddingInfo {
  paddingClassName: string; // Same padding class as TextField
}
```

---

## Usage Examples

### Basic Usage

```tsx
import { TextField } from '@mezzanine-ui/react';

<TextField>
  <input type="text" placeholder="Enter..." />
</TextField>
```

### Function Children (controlling padding)

```tsx
<TextField>
  {({ paddingClassName }) => (
    <input
      type="text"
      className={paddingClassName}
      placeholder="Control padding yourself"
    />
  )}
</TextField>
```

### With Prefix and Suffix

```tsx
import { SearchIcon, CalendarIcon } from '@mezzanine-ui/icons';
import { Icon } from '@mezzanine-ui/react';

<TextField
  prefix={<Icon icon={SearchIcon} />}
  suffix={<Icon icon={CalendarIcon} />}
>
  <input type="text" />
</TextField>
```

### Clearable

```tsx
<TextField
  clearable
  onClear={() => setValue('')}
>
  <input type="text" value={value} onChange={handleChange} />
</TextField>
```

### Error State

```tsx
<TextField error>
  <input type="text" />
</TextField>
```

### Warning State

```tsx
<TextField warning>
  <input type="text" />
</TextField>
```

### Disabled State

```tsx
<TextField disabled>
  <input type="text" disabled />
</TextField>
```

### Read-only State

```tsx
<TextField readonly>
  <input type="text" readOnly />
</TextField>
```

### Small Size

```tsx
<TextField size="sub">
  <input type="text" />
</TextField>
```

### Active State (e.g., dropdown open)

```tsx
<TextField active>
  <input type="text" />
</TextField>
```

---

## Relationship with Input Component

The `Input` component internally uses `TextField` as its container:

```tsx
// Approximate internal structure of Input component
function Input(props) {
  return (
    <TextField
      prefix={props.prefix}
      suffix={props.suffix}
      clearable={props.clearable}
      // ...other TextField props
    >
      <input {...inputProps} />
    </TextField>
  );
}
```

---

## Auto Typing Detection

When `typing` is not explicitly set, the component auto-detects:
- Listens to internal input/textarea `input` and `mousedown` events to set typing
- Listens to `blur` event to cancel typing state

---

## Clear Button Display Logic

The clear button (clearable) is visible when:
1. `clearable` is enabled
2. A value exists
3. Any of the following: hovered **or** typing **or** focused

---

## Figma Mapping

| Figma Variant              | React Props                              |
| -------------------------- | ---------------------------------------- |
| `TextField / Default`      | Default                                  |
| `TextField / Active`       | `active`                                 |
| `TextField / Typing`       | `typing`                                 |
| `TextField / Error`        | `error`                                  |
| `TextField / Warning`      | `warning`                                |
| `TextField / Disabled`     | `disabled`                               |
| `TextField / Readonly`     | `readonly`                               |
| `TextField / With Prefix`  | `prefix` has value                       |
| `TextField / With Suffix`  | `suffix` has value                       |
| `TextField / Clearable`    | `clearable`                              |
| `TextField / Main`         | `size="main"` (default)                  |
| `TextField / Sub`          | `size="sub"`                             |

---

## Best Practices

1. **Use Input component**: In general, use the Input component directly instead of TextField
2. **Function children**: Use function form when precise padding control is needed
3. **State mutual exclusion**: disabled, readonly, typing are mutually exclusive
4. **Clear functionality**: Implement the onClear callback when enabling clearable
5. **Accessibility**: Internal input must set corresponding disabled/readOnly attributes
