# Input Component

> **Category**: Data Entry
>
> **Storybook**: `Data Entry/Input`
>
> **Source**: [GitHub Source Code](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/react/src/Input) · Verified 1.10.2 (2026-11-22)

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
  MeasureInputProps,
  ActionInputProps,
  SelectInputProps,
  WithPasswordStrengthIndicator,
  PasswordInputProps,
} from '@mezzanine-ui/react';
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/data-entry-input--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## Input Variants

| Variant    | Description                   | Features                           |
| ---------- | ----------------------------- | ---------------------------------- |
| `base`     | Base input (default)          | Supports clear button              |
| `affix`    | Input with prefix/suffix      | Custom prefix/suffix               |
| `search`   | Search input                  | Default search icon, clearable     |
| `number`   | Number input                  | 36x36 compact number input         |
| `measure`  | Measure/unit input                                 | Unit text, optional spinner controls |
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
| `inputType`    | `NativeElementPropsWithoutKeyAndRef<'input'>['type']`               | variant-based (`'text'`; `number` → `'number'`; `password` → `'password'`/`'text'` toggle) | Input type attribute (overrides variant default) |
| `name`         | `string`                                                            | -        | Input name attribute |
| `onChange`     | `ChangeEventHandler<HTMLInputElement>`                              | -        | Value change event   |
| `parser`       | `(value: string) => string`                                         | -        | Parse display to raw |
| `placeholder`  | `string`                                                            | -        | Placeholder text     |
| `readonly`     | `boolean`                                                           | -        | Whether read-only (no destructuring default; falsy when omitted) |
| `size`         | `InputSize` (`'main' \| 'sub'`)                                    | `'main'` | Size                 |
| `typing`       | `boolean`                                                           | -        | Whether typing       |
| `value`        | `string`                                                            | -        | Controlled value     |

> `disabled` / `readonly` / `typing` come from `TextFieldInteractiveStateProps`, a union: only one of them may be set at a time (`disabled` and `readonly` are typed as literal `true`; combining them is a type error).
>
> `warning`, `forceShowClearable` and `hideSuffixWhenClearable` also exist on `InputBaseProps` (via `TextFieldProps`) but `Input` does not forward them to the inner `TextField`, so they have no effect. `className` is applied to the outer container.
>
> `active`, `disabled`, `error`, `fullWidth`, `readonly`, `size`, `typing` (and `className`) are inherited from `TextFieldProps` through `Omit<TextFieldProps, 'children' | 'clearable' | 'onClear' | 'prefix' | 'suffix'>`; they are real props of every variant. `Input` accepts a `ref` (`HTMLDivElement`, the outer container). `aria-*` / `role` props passed to `Input` are forwarded to the native `<input>`. Variant-specific props (`variant`, `showSpinner`, `onSpinUp`, `onSpinDown`, `min`, `max`, `step`, `options`, `selectedValue`, `onSelect`, `dropdownWidth`, `dropdownMaxHeight`, `dropdownPlacement`, `actionButton`, `selectButton`, `showPasswordStrengthIndicator`, `passwordStrengthIndicator`) are documented per variant below; they exist only on their own union branch.

### Helper Types

```tsx
// Clear functionality (shared by Base, Affix, Search, Password)
type ClearableInput = Pick<TextFieldProps, 'clearable' | 'onClear'>;

// Number related (shared by Number, Measure)
type NumberInput = {
  min?: number;
  max?: number;
  step?: number;
};

// Password strength indicator (conditional type)
type WithPasswordStrengthIndicator =
  | { showPasswordStrengthIndicator?: false; passwordStrengthIndicator?: never }
  | { showPasswordStrengthIndicator: true; passwordStrengthIndicator: PasswordStrengthIndicatorProps };

// Password strength level (exhaustive: no other members)
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

### Measure Input

```tsx
type MeasureInputProps = InputBaseProps & NumberInput & TextFieldAffixProps & {
  variant: 'measure';
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

// ActionButtonProps (from packages/react/src/Input/ActionButton):
// extends Omit<NativeElementPropsWithoutKeyAndRef<'button'>, 'type' | 'disabled'>
//   disabled?: boolean;        // falls back to `disabled || readonly` of Input
//   icon?: IconDefinition;     // Default CopyIcon
//   label?: string;            // Default 'Copy' (rendered as the button text; `children` is not rendered)
//   size?: InputSize;          // Default 'main' (overridden by Input's `size`)
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

// SelectButtonProps (from packages/react/src/Input/SelectButton)
type SelectButtonProps = {
  closeOnSelect?: boolean;              // Default true: close dropdown on option click
  disabled?: boolean;
  dropdownWidth?: number | string;
  dropdownMaxHeight?: number | string;
  dropdownPlacement?: PopperPlacement;
  options?: DropdownOption[];
  onSelect?: (value: string) => void;
  size?: InputSize;                     // Default 'main'
  value?: string;
};
```

> `closeOnSelect`（預設 `true`）：選項點擊後自動關閉下拉選單；需要選後不關閉時，傳 `closeOnSelect={false}`。
>
> `SelectButtonProps` 另 extends `Omit<NativeElementPropsWithoutKeyAndRef<'button'>, 'disabled' | 'onSelect' | 'type' | 'selectedValue'>`。頂層 `options` / `onSelect` / `dropdownWidth` / `dropdownMaxHeight` / `dropdownPlacement` 會覆寫 `selectButton` 內的同名欄位；顯示在按鈕上的文字與勾選項目是 `selectButton.value`。頂層 `selectedValue` 型別上存在，但 `Input` 實作並未讀取，請改用 `selectButton.value`。

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
  | MeasureInputProps
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

### Measure Input

```tsx
<Input
  variant="measure"
  prefix="NT$"
  suffix="元"
  value={amount}
  onChange={(e) => setAmount(e.target.value)}
  showSpinner
  onSpinUp={() => console.log('spin up')}
  onSpinDown={() => console.log('spin down')}
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
    label: 'Submit',
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
| `strengthTextPrefix` | `string`                                             | `'密碼強度：'`          | Strength text prefix       |
| `hintTexts`          | `Array<{ severity: FormHintTextProps['severity']; hint: string }>` | -  | Hint text array (with severity and text) |

---

## Figma Mapping

| Figma Variant              | React Props                              |
| -------------------------- | ---------------------------------------- |
| `Input / Base`             | `<Input variant="base">`                 |
| `Input / Search`           | `<Input variant="search">`               |
| `Input / Number`           | `<Input variant="number">`               |
| `Input / Measure`          | `<Input variant="measure">`              |
| `Input / Password`         | `<Input variant="password">`             |
| `Input / With Affix`       | `<Input variant="affix">`                |
| `Input / With Action`      | `<Input variant="action">`               |
| `Input / Disabled`         | `<Input disabled>`                       |
| `Input / Error`            | `<Input error>`                          |

---

## Best Practices

### 場景推薦

| 使用場景 | 建議方案 | 說明 |
| ------- | ------- | ---- |
| 通用文字輸入 | `variant="base"` | 最常見的輸入框，適合基本文字、郵件等 |
| 搜尋功能 | `variant="search"` | 內建搜尋圖標，預設支援清除按鈕 |
| 數字輸入 | `variant="number"` | 固定小尺寸 36x36，適合單一數字欄位 |
| 貨幣/測量單位 | `variant="measure"` | 支援前後綴標籤（如 NT$、元）和步進按鈕 |
| 包含前後綴 | `variant="affix"` | 靈活的自訂前後綴（圖標、文字等） |
| 密碼輸入 | `variant="password"` | 支援顯示/隱藏切換和強度指示器 |
| 搭配外部按鈕 | `variant="action"` | 複製、提交等輔助操作按鈕 |
| 下拉選單組合 | `variant="select"` | 文字輸入加下拉清單 |

### 常見錯誤

1. **使用 currency variant（已棄用）**
   - ❌ 錯誤：`<Input variant="currency" />`
   - ✅ 正確：改用 `variant="measure"` 並配合 `prefix`/`suffix` props

2. **搞混 formatter 和 parser**
   - ❌ 錯誤：只設定 `formatter`，沒有設定 `parser`
   - ✅ 正確：成對使用，formatter 用於顯示，parser 用於儲存原始值

3. **measure variant 忘記設定 onSpinUp/onSpinDown**
   - ❌ 錯誤：`<Input variant="measure" showSpinner />`（沒有按鈕回調）
   - ✅ 正確：`<Input variant="measure" showSpinner onSpinUp={handleUp} onSpinDown={handleDown} />`

4. **password variant 搜尋框混用**
   - ❌ 錯誤：在搜尋框使用 password variant
   - ✅ 正確：`variant="search"` 搜尋，`variant="password"` 密碼

5. **number variant 邊界值未設定**
   - ❌ 錯誤：`<Input variant="number" />`（沒有 min/max 限制）
   - ✅ 正確：`<Input variant="number" min={0} max={100} step={5} />`

### 實作建議

1. **選擇適當的 variant**：根據用途選擇對應的輸入類型，無效的 variant 組合會導致 TypeScript 編譯錯誤
2. **提供 placeholder**：幫助使用者理解預期的輸入格式
3. **使用 clearable**：對於長文本輸入，提供清除按鈕提升體驗
4. **formatter/parser 成對使用**：處理貨幣、電話號碼等格式化輸入時，確保顯示和儲存的值一致
5. **密碼強度提示**：敏感資料輸入時，顯示密碼強度指示器指導使用者
