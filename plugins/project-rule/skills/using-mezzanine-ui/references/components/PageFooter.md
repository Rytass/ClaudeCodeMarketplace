# PageFooter Component

> **Category**: Navigation
>
> **Storybook**: `Navigation/PageFooter`
>
> **Source Verification**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/react/src/PageFooter)

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
| `supportingActionIcon` | `ButtonProps['icon']`    | `DotVerticalIcon` | Overflow button icon     |
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

## Best Practices

1. **Button order**: Secondary button on left, primary button on right
2. **Fixed positioning**: Typically used with `position: fixed` or `sticky`
3. **Warning message**: Use for form validation failure hints
4. **Overflow menu**: Use overflow type for multiple secondary actions
5. **Semantic**: Renders as a `<footer>` element
