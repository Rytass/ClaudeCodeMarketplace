# Input Component

> **Category**: Data Entry
>
> **Storybook**: `Data Entry/Input`
>
> **Source**: [GitHub Source Code](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/react/src/Input) · Verified v2 source (2026-02-13)

A versatile input component supporting multiple variants for different use cases.

## Import

```tsx
import { Input } from '@mezzanine-ui/react';
import type {
  InputProps,
  InputSize,
  InputStrength,
  InputBaseProps,
  ClearableInput,
  NumberInput,
  BaseInputProps,
  WithAffixInputProps,
  SearchInputProps,
  NumberInputProps,
  CurrencyInputProps,
  ActionInputProps,
  SelectInputProps,
  WithPasswordStrengthIndicator,
  PasswordInputProps,
} from '@mezzanine-ui/react';
```

---

## Input Variants

| Variant    | Description                   | Features                           |
| ---------- | ----------------------------- | ---------------------------------- |
| `base`     | Base input (default)          | Supports clear button              |
| `affix`    | Input with prefix/suffix      | Custom prefix/suffix               |
| `search`   | Search input                  | Default search icon, clearable     |
| `number`   | Number input                  | 36x36 compact number input         |
| `currency` | Currency input                | Right-aligned, thousands format, optional spinner |
| `action`   | Input with action button      | Button outside the input           |
| `select`   | Input with dropdown           | Button at prefix/suffix/both       |
| `password` | Password input                | Eye toggle, strength indicator     |

---

## Shared Props (InputBaseProps)

Base properties shared by all variants. `InputBaseProps` extends `TextFieldProps` (excluding `children`, `clearable`, `onClear`, `prefix`, `suffix`).

| Property       | Type                                                                | Default  | Description          |
| -------------- | ------------------------------------------------------------------- | -------- | -------------------- |
| `active`       | `boolean`                                                           | -        | Whether active       |
| `defaultValue` | `string`                                                            | -        | Default value        |
| `disabled`     | `boolean`                                                           | `false`  | Whether disabled     |
| `error`        | `boolean`                                                           | `false`  | Whether error state  |
| `formatter`    | `(value: string) => string`                                         | -        | Format display value |
| `fullWidth`    | `boolean`                                                           | `true`   | Whether full width   |
| `id`           | `string`                                                            | -        | Input element ID     |
| `inputRef`     | `Ref<HTMLInputElement>`                                             | -        | Input element ref    |
| `inputProps`   | `Omit<NativeElementPropsWithoutKeyAndRef<'input'>, ...excluded>`    | -        | Props for input      |
| `inputType`    | `NativeElementPropsWithoutKeyAndRef<'input'>['type']`               | `'text'` | Input type attribute |
| `name`         | `string`                                                            | -        | Input name attribute |
| `onChange`     | `ChangeEventHandler<HTMLInputElement>`                              | -        | Value change event   |
| `parser`       | `(value: string) => string`                                         | -        | Parse display to raw |
| `placeholder`  | `string`                                                            | -        | Placeholder text     |
| `readonly`     | `boolean`                                                           | `false`  | Whether read-only    |
| `size`         | `InputSize` (`'main' \| 'sub'`)                                    | `'main'` | Size                 |
| `typing`       | `boolean`                                                           | -        | Whether typing       |
| `value`        | `string`                                                            | -        | Controlled value     |

### Helper Types

```tsx
// Clear functionality (shared by Base, Affix, Search, Password)
type ClearableInput = Pick<TextFieldProps, 'clearable' | 'onClear'>;

// Number related (shared by Number, Currency)
type NumberInput = {
  min?: number;
  max?: number;
  step?: number;
};

// Password strength indicator (conditional type)
type WithPasswordStrengthIndicator =
  | { showPasswordStrengthIndicator?: false; passwordStrengthIndicator?: never }
  | { showPasswordStrengthIndicator: true; passwordStrengthIndicator: PasswordStrengthIndicatorProps };

// Password strength level
type InputStrength = 'weak' | 'medium' | 'strong';
```

---

## Variant-specific Props

### Base Input

```tsx
type BaseInputProps = InputBaseProps & ClearableInput & {
  variant?: 'base';  // Default
};
```

### With Affix Input

```tsx
type WithAffixInputProps = InputBaseProps & TextFieldAffixProps & ClearableInput & {
  variant: 'affix';
};
// TextFieldAffixProps includes prefix?: ReactNode, suffix?: ReactNode
```

### Search Input

```tsx
type SearchInputProps = InputBaseProps & ClearableInput & {
  variant: 'search';
};
// clearable defaults to true
```

### Number Input

```tsx
type NumberInputProps = InputBaseProps & NumberInput & {
  variant: 'number';
};
// step defaults to 1
```

### Currency Input

```tsx
type CurrencyInputProps = InputBaseProps & NumberInput & TextFieldAffixProps & {
  variant: 'currency';
  showSpinner?: boolean;   // Default false
  onSpinUp?: VoidFunction;
  onSpinDown?: VoidFunction;
};
```

### Action Input

```tsx
type ActionInputProps = InputBaseProps & {
  variant: 'action';
  actionButton: ActionButtonProps & {
    position: 'prefix' | 'suffix';
  };
};
```

### Select Input

```tsx
type SelectInputProps = InputBaseProps & {
  variant: 'select';
  selectButton: SelectButtonProps & {
    position: 'prefix' | 'suffix' | 'both';
  };
  options?: DropdownOption[];
  selectedValue?: string;
  onSelect?: (value: string) => void;
  dropdownWidth?: number | string;      // Default 120
  dropdownMaxHeight?: number | string;  // Default 114
  dropdownPlacement?: PopperPlacement;  // Default 'bottom-start'
};
```

### Password Input

```tsx
type PasswordInputProps = InputBaseProps & ClearableInput & WithPasswordStrengthIndicator & {
  variant: 'password';
};
// When showPasswordStrengthIndicator is true, passwordStrengthIndicator is required
```

### InputProps Union Type

```tsx
type InputProps =
  | BaseInputProps
  | WithAffixInputProps
  | SearchInputProps
  | NumberInputProps
  | CurrencyInputProps
  | ActionInputProps
  | SelectInputProps
  | PasswordInputProps;
```

---

## Usage Examples

### Basic Input

```tsx
import { Input } from '@mezzanine-ui/react';

<Input
  placeholder="Enter text"
  onChange={(e) => console.log(e.target.value)}
/>
```

### Clearable Input

```tsx
<Input
  placeholder="Clearable"
  clearable
  value={value}
  onChange={(e) => setValue(e.target.value)}
  onClear={() => setValue('')}
/>
```

### Search Input

```tsx
<Input
  variant="search"
  placeholder="Search..."
  value={keyword}
  onChange={(e) => setKeyword(e.target.value)}
/>
```

### With Prefix/Suffix

```tsx
import { Icon } from '@mezzanine-ui/react';
import { UserIcon, SearchIcon } from '@mezzanine-ui/icons';

<Input
  variant="affix"
  prefix={<Icon icon={UserIcon} />}
  suffix="@gmail.com"
  placeholder="Username"
/>
```

### Currency Input

```tsx
<Input
  variant="currency"
  prefix="NT$"
  value={amount}
  onChange={(e) => setAmount(e.target.value)}
  showSpinner
/>
```

### Password Input

```tsx
<Input
  variant="password"
  placeholder="Enter password"
  showPasswordStrengthIndicator
  passwordStrengthIndicator={{
    strength: 'medium',
    strengthText: 'Medium',
  }}
/>
```

### With Action Button

```tsx
<Input
  variant="action"
  placeholder="Enter and submit"
  actionButton={{
    position: 'suffix',
    children: 'Submit',
    onClick: handleSubmit,
  }}
/>
```

---

## PasswordStrengthIndicator Props

Extends all native div attributes from `NativeElementPropsWithoutKeyAndRef<'div'>`.

| Property             | Type                                                 | Default          | Description                |
| -------------------- | ---------------------------------------------------- | ---------------- | -------------------------- |
| `strength`           | `InputStrength` (`'weak' \| 'medium' \| 'strong'`)  | `'weak'`         | Password strength          |
| `strengthText`       | `string`                                             | -                | Strength description text  |
| `strengthTextPrefix` | `string`                                             | `'Password Strength: '` | Strength text prefix       |
| `hintTexts`          | `Array<{ severity: FormHintTextProps['severity']; hint: string }>` | -  | Hint text array (with severity and text) |

---

## Figma Mapping

| Figma Variant              | React Props                              |
| -------------------------- | ---------------------------------------- |
| `Input / Base`             | `<Input variant="base">`                 |
| `Input / Search`           | `<Input variant="search">`               |
| `Input / Number`           | `<Input variant="number">`               |
| `Input / Currency`         | `<Input variant="currency">`             |
| `Input / Password`         | `<Input variant="password">`             |
| `Input / With Affix`       | `<Input variant="affix">`                |
| `Input / With Action`      | `<Input variant="action">`               |
| `Input / Disabled`         | `<Input disabled>`                       |
| `Input / Error`            | `<Input error>`                          |

---

## Best Practices

1. **Choose appropriate variant**: Select the matching variant based on the use case
2. **Provide placeholder**: Help users understand expected input
3. **Use clearable**: Provide clear functionality for long text input
4. **Use formatter for currency**: Auto-handle thousands formatting
5. **Password strength hint**: Show strength indicator for sensitive data input
