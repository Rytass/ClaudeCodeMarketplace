# PageFooter Component

> **Category**: Navigation
>
> **Storybook**: `Navigation/PageFooter`
>
> **Source Verification**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/react/src/PageFooter) | Verified rc.7: 2026-03-26

Page footer component for displaying page-level action buttons and auxiliary information.

## Import

```tsx
import { PageFooter } from '@mezzanine-ui/react';
import type { PageFooterProps } from '@mezzanine-ui/react';
```

> **Note**: `PageFooterType` and `PageFooterActions` types are not exported from the main entry; only `PageFooterProps` is available from `@mezzanine-ui/react`.

---

## PageFooter Props

> `PageFooterProps` is a union type: `PageFooterStandardProps | PageFooterOverflowProps | PageFooterInformationProps`, all extending `PageFooterBaseProps`.

### Base Props (PageFooterBaseProps)

> Extends `NativeElementPropsWithoutKeyAndRef<'footer'>`.

| Property              | Type                | Default | Description              |
| --------------------- | ------------------- | ------- | ------------------------ |
| `actions`             | `PageFooterActions` | -       | Action button config     |
| `annotationClassName` | `string`            | -       | Annotation area className|
| `warningMessage`      | `string`            | -       | Warning message          |

---

## PageFooterType

```tsx
type PageFooterType = 'standard' | 'overflow' | 'information';
```

---

## PageFooterActions

```tsx
// Single button
type SingleButtonAction = {
  primaryButton: ButtonProps;
  secondaryButton?: never;
};

// Two buttons
type TwoButtonsAction = {
  primaryButton: ButtonProps;
  secondaryButton: ButtonProps;
};

type PageFooterActions = SingleButtonAction | TwoButtonsAction;
```

---

## Additional Props by Type

### type="standard" (Default)

| Property                     | Type                     | Default        | Description                |
| ---------------------------- | ------------------------ | -------------- | -------------------------- |
| `type`                       | `'standard'`             | `'standard'`   | Type indicator             |
| `supportingActionName`       | `ButtonProps['children']`| -              | Supporting action text     |
| `supportingActionType`       | `ButtonProps['type']`    | -              | Supporting action type     |
| `supportingActionOnClick`    | `ButtonProps['onClick']` | -              | Supporting action click    |
| `supportingActionVariant`    | `ButtonProps['variant']` | `'base-ghost'` | Supporting action variant  |

### type="overflow"

| Property               | Type                     | Default           | Description              |
| ---------------------- | ------------------------ | ----------------- | ------------------------ |
| `supportingActionIcon` | `ButtonProps['icon']`    | `DotHorizontalIcon` | Overflow button icon     |
| `dropdownProps`        | `Partial<DropdownProps>` | (required)        | Dropdown props           |

### type="information"

| Property     | Type     | Description        |
| ------------ | -------- | ------------------ |
| `annotation` | `string` | Information text   |

---

## Usage Examples

### Standard Type

```tsx
import { PageFooter } from '@mezzanine-ui/react';

<PageFooter
  type="standard"
  supportingActionName="Reset"
  supportingActionOnClick={handleReset}
  actions={{
    secondaryButton: {
      children: 'Cancel',
      onClick: handleCancel,
    },
    primaryButton: {
      children: 'Save',
      onClick: handleSave,
    },
  }}
/>
```

### Overflow Type

```tsx
<PageFooter
  type="overflow"
  dropdownProps={{
    options: [
      { id: 'export', name: 'Export' },
      { id: 'import', name: 'Import' },
      { id: 'delete', name: 'Delete' },
    ],
    onSelect: handleMenuSelect,
  }}
  actions={{
    primaryButton: {
      children: 'Save',
      onClick: handleSave,
    },
  }}
/>
```

### Information Type

```tsx
<PageFooter
  type="information"
  annotation="Last updated: 2024-01-15 10:30"
  actions={{
    secondaryButton: {
      children: 'Previous',
      onClick: handlePrev,
    },
    primaryButton: {
      children: 'Next',
      onClick: handleNext,
    },
  }}
/>
```

### With Warning Message

```tsx
<PageFooter
  warningMessage="Some fields are not filled in"
  actions={{
    primaryButton: {
      children: 'Save',
      onClick: handleSave,
      disabled: true,
    },
  }}
/>
```

### Single Button

```tsx
<PageFooter
  actions={{
    primaryButton: {
      children: 'Done',
      onClick: handleComplete,
    },
  }}
/>
```

### Form Footer

```tsx
function FormFooter({ isValid, onSubmit, onCancel, onReset }) {
  return (
    <PageFooter
      type="standard"
      supportingActionName="Reset Form"
      supportingActionOnClick={onReset}
      warningMessage={!isValid ? 'Please fill in required fields' : undefined}
      actions={{
        secondaryButton: {
          children: 'Cancel',
          onClick: onCancel,
        },
        primaryButton: {
          children: 'Submit',
          onClick: onSubmit,
          disabled: !isValid,
        },
      }}
    />
  );
}
```

---

## Component Structure

```
+--------------------------------------------------------------+
| PageFooter                                                    |
| +----------------+-----------------+-------------------------+ |
| | Supporting     | Warning Area    | Action Buttons          | |
| | Action Area    |                 |                         | |
| | [Reset]        | Warning message | [Secondary] [Primary]   | |
| +----------------+-----------------+-------------------------+ |
+--------------------------------------------------------------+
```

---

## Figma Mapping

| Figma Variant                    | React Props                                  |
| -------------------------------- | -------------------------------------------- |
| `PageFooter / Standard`          | `type="standard"`                            |
| `PageFooter / Overflow`          | `type="overflow"`                            |
| `PageFooter / Information`       | `type="information"`                         |
| `PageFooter / Single Button`     | `actions` has only primaryButton             |
| `PageFooter / Two Buttons`       | `actions` has primaryButton + secondaryButton|
| `PageFooter / With Warning`      | `warningMessage` has value                   |

---

## Best Practices (最佳實踐)

### 場景推薦 (Scenario Recommendations)

| 場景 | 推薦做法 | 相關 Props |
| --- | --- | --- |
| 簡單操作確認 | 使用 `type="standard"` 搭配一個或兩個按鈕 | `actions`, `primaryButton` |
| 表單提交 | 使用 `type="standard"` 搭配 `supportingActionName="Reset"` | `supportingActionName` |
| 多個次要操作 | 使用 `type="overflow"` 與下拉菜單 | `type="overflow"`, `dropdownProps` |
| 驗證失敗提示 | 顯示 `warningMessage` 並禁用提交按鈕 | `warningMessage`, `disabled` |
| 信息展示頁面 | 使用 `type="information"` 搭配 `annotation` | `type="information"`, `annotation` |
| 固定在底部 | 搭配 CSS `position: fixed` 或 `sticky` | - |

### 常見錯誤 (Common Mistakes)

1. **按鈕順序反向**
   - ❌ 誤：主操作按鈕在左邊，次要按鈕在右邊
   - ✅ 正確：次要按鈕在左，主操作按鈕在右
   - 範例：`secondaryButton` 先定義，`primaryButton` 後定義

2. **缺少 warningMessage**
   - ❌ 誤：表單驗證失敗後不提示用戶
   - ✅ 正確：在驗證失敗時顯示 `warningMessage`
   - 範例：`warningMessage={!isValid ? '請填寫必填項' : undefined}`

3. **type 選擇不當**
   - ❌ 誤：多個操作都使用 `standard` 類型
   - ✅ 正確：多個次要操作使用 `overflow` 類型
   - 影響：避免按鈕過多導致布局混亂

4. **未固定位置**
   - ❌ 誤：在滾動內容下未固定頁腳
   - ✅ 正確：使用 `position: fixed` 或 `sticky`
   - 範例：`<PageFooter style={{ position: 'sticky', bottom: 0 }} />`

5. **actionName 過長**
   - ❌ 誤：`supportingActionName="Reset All Data"`
   - ✅ 正確：`supportingActionName="重置"`
   - 影響：按鈕寬度合理，不影響主按鈕

### 核心建議 (Core Recommendations)

1. **按鈕位置**：次要按鈕在左，主操作按鈕在右
2. **固定位置**：通常使用 `position: fixed` 或 `sticky`
3. **警告提示**：用於表單驗證失敗提示
4. **溢出菜單**：多個次要操作使用 `overflow` 類型
5. **語義化**：正確使用 `<footer>` 標籤提升可訪問性
