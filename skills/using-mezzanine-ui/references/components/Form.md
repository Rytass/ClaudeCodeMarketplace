# Form Component

> **Category**: Data Entry
>
> **Storybook**: `Data Entry/Form`
>
> **Source**: [GitHub Source Code](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/react/src/Form) · Verified v2 source (2026-02-13)

Form-related components including field containers, labels, hint text, and more.

## Import

```tsx
import {
  FormField,
  FormLabel,
  FormHintText,
  FormControlContext,
} from '@mezzanine-ui/react';

import type {
  FormFieldProps,
  FormLabelProps,
  FormHintTextProps,
  FormControl,
} from '@mezzanine-ui/react';

// FormElementFocusHandlers must be imported from sub-path
import type { FormElementFocusHandlers } from '@mezzanine-ui/react/Form';
```

---

## FormField Props

An integrated form field component including label, input area, hint text, etc.

| Property                 | Type                       | Default                       | Description                                |
| ------------------------ | -------------------------- | ----------------------------- | ------------------------------------------ |
| `name`                   | `string`                   | **Required**                  | Field name (also used as label's htmlFor)  |
| `label`                  | `string`                   | -                             | Label text                                 |
| `layout`                 | `FormFieldLayout`          | `FormFieldLayout.HORIZONTAL`  | Layout direction                           |
| `density`                | `FormFieldDensity`         | -                             | Density (label/data entry width ratio)     |
| `controlFieldSlotLayout` | `ControlFieldSlotLayout`   | `ControlFieldSlotLayout.MAIN` | Control area layout                        |
| `labelSpacing`           | `FormFieldLabelSpacing`    | `FormFieldLabelSpacing.MAIN`  | Label spacing (effective in horizontal/stretch mode) |
| `required`               | `boolean`                  | `false`                       | Whether required                           |
| `disabled`               | `boolean`                  | `false`                       | Whether disabled                           |
| `fullWidth`              | `boolean`                  | `false`                       | Whether full width                         |
| `severity`               | `SeverityWithInfo`         | `'info'`                      | Severity level                             |
| `showHintTextIcon`       | `boolean`                  | `true`                        | Whether to display the hint text icon      |
| `hintText`               | `string`                   | -                             | Hint text                                  |
| `hintTextIcon`           | `IconDefinition`           | -                             | Hint text icon                             |
| `counter`                | `string`                   | -                             | Counter text                               |
| `counterColor`           | `FormFieldCounterColor`    | `FormFieldCounterColor.INFO`  | Counter color                              |
| `labelInformationIcon`   | `IconDefinition`           | -                             | Label information icon (shows tooltip)     |
| `labelInformationText`   | `string`                   | -                             | Label information tooltip text             |
| `labelOptionalMarker`    | `string`                   | -                             | Label optional marker (e.g., "(Optional)") |

---

## FormFieldLayout Enum

| Layout       | Description                | Notes                                  |
| ------------ | -------------------------- | -------------------------------------- |
| `horizontal` | Horizontal (label on left) | Supports density, labelSpacing         |
| `vertical`   | Vertical (label on top)    | density and labelSpacing are ignored   |
| `stretch`    | Stretch layout             | Supports density, labelSpacing         |

## FormFieldDensity Enum

| Density  | Description    |
| -------- | -------------- |
| `base`   | Base density   |
| `tight`  | Tight density  |
| `narrow` | Narrow density |
| `wide`   | Wide density   |

## FormFieldLabelSpacing Enum

| LabelSpacing | Description   |
| ------------ | ------------- |
| `main`       | Main spacing  |
| `sub`        | Sub spacing   |

## FormFieldCounterColor Enum

| CounterColor | Description          |
| ------------ | -------------------- |
| `info`       | Info color (default) |
| `warning`    | Warning color        |
| `error`      | Error color          |

## ControlFieldSlotLayout Enum

| SlotLayout | Description |
| ---------- | ----------- |
| `main`     | Main layout |
| `sub`      | Sub layout  |

---

## Usage Examples

### Basic Usage (Vertical Layout)

```tsx
import { FormField, Input } from '@mezzanine-ui/react';

<FormField
  name="username"
  label="Username"
  layout="vertical"
  required
>
  <Input placeholder="Enter username" />
</FormField>
```

### Horizontal Layout

```tsx
<FormField
  name="email"
  label="Email"
  layout="horizontal"
  required
>
  <Input inputType="email" placeholder="Enter email" />
</FormField>
```

### With Hint Text

```tsx
<FormField
  name="password"
  label="Password"
  layout="vertical"
  required
  hintText="Password must be at least 8 characters"
>
  <Input variant="password" placeholder="Enter password" />
</FormField>
```

### With Error State

```tsx
<FormField
  name="email"
  label="Email"
  layout="vertical"
  required
  severity="error"
  hintText="Invalid email format"
>
  <Input inputType="email" error />
</FormField>
```

### With Character Counter

```tsx
function TextareaWithCounter() {
  const [value, setValue] = useState('');
  const maxLength = 100;

  return (
    <FormField
      name="description"
      label="Description"
      layout="vertical"
      counter={`${value.length}/${maxLength}`}
      counterColor={value.length > maxLength ? 'error' : 'info'}
    >
      <Textarea
        value={value}
        onChange={(e) => setValue(e.target.value)}
        placeholder="Enter description"
      />
    </FormField>
  );
}
```

### With Label Information

```tsx
import { QuestionOutlineIcon } from '@mezzanine-ui/icons';

<FormField
  name="apiKey"
  label="API Key"
  layout="vertical"
  labelInformationIcon={QuestionOutlineIcon}
  labelInformationText="API Key can be obtained from the settings page"
>
  <Input placeholder="Enter API Key" />
</FormField>
```

### Optional Field

```tsx
<FormField
  name="nickname"
  label="Nickname"
  layout="vertical"
  labelOptionalMarker="(Optional)"
>
  <Input placeholder="Enter nickname" />
</FormField>
```

### Hide Hint Text Icon

```tsx
<FormField
  name="note"
  label="Note"
  layout="vertical"
  hintText="This hint has no icon"
  showHintTextIcon={false}
>
  <Input placeholder="Enter note" />
</FormField>

// Standalone FormHintText without icon
<FormHintText
  hintText="Plain hint text"
  severity="info"
  showHintTextIcon={false}
/>
```

### Complete Form Example

```tsx
function ContactForm() {
  const [formData, setFormData] = useState({
    name: '',
    email: '',
    message: '',
  });
  const [errors, setErrors] = useState({});

  const handleSubmit = () => {
    // Validation logic
  };

  return (
    <form onSubmit={handleSubmit}>
      <FormField
        name="name"
        label="Name"
        layout="vertical"
        required
        severity={errors.name ? 'error' : 'info'}
        hintText={errors.name}
      >
        <Input
          value={formData.name}
          onChange={(e) =>
            setFormData((prev) => ({ ...prev, name: e.target.value }))
          }
          placeholder="Enter name"
          error={!!errors.name}
        />
      </FormField>

      <FormField
        name="email"
        label="Email"
        layout="vertical"
        required
        severity={errors.email ? 'error' : 'info'}
        hintText={errors.email || 'We will not share your email'}
      >
        <Input
          inputType="email"
          value={formData.email}
          onChange={(e) =>
            setFormData((prev) => ({ ...prev, email: e.target.value }))
          }
          placeholder="Enter email"
          error={!!errors.email}
        />
      </FormField>

      <FormField
        name="message"
        label="Message"
        layout="vertical"
        required
        counter={`${formData.message.length}/500`}
      >
        <Textarea
          value={formData.message}
          onChange={(e) =>
            setFormData((prev) => ({ ...prev, message: e.target.value }))
          }
          placeholder="Enter message"
          rows={4}
        />
      </FormField>

      <Button type="submit" variant="base-primary">
        Submit
      </Button>
    </form>
  );
}
```

---

## FormLabel

A standalone label component (underlying element is `<label>`).

### Props

| Property          | Type             | Description                                    |
| ----------------- | ---------------- | ---------------------------------------------- |
| `htmlFor`         | `string`         | Associated input id                            |
| `labelText`       | `string`         | **Required**, label text                       |
| `informationIcon` | `IconDefinition` | Information icon                               |
| `informationText` | `string`         | Information tooltip text                       |
| `optionalMarker`  | `ReactNode`      | Optional marker                                |

> Note: `required` state is automatically obtained via `FormControlContext`, displaying a required asterisk marker.

```tsx
import { FormLabel } from '@mezzanine-ui/react';

<FormLabel
  htmlFor="username"
  labelText="Username"
/>
```

---

## FormHintText

A standalone hint text component (underlying element is `<span>`).

### Props

| Property       | Type                                              | Default  | Description                               |
| -------------- | ------------------------------------------------- | -------- | ----------------------------------------- |
| `hintText`     | `string`                                          | -        | Hint text                                 |
| `hintTextIcon` | `IconDefinition`                                  | -        | Custom icon (priority over severity default icon) |
| `severity`     | `'success' \| 'warning' \| 'error' \| 'info'`    | `'info'` | Severity level                            |
| `showHintTextIcon` | `boolean`                                     | `true`   | Whether to display the hint text icon     |

```tsx
import { FormHintText } from '@mezzanine-ui/react';

<FormHintText
  hintText="Password must be at least 8 characters"
  severity="info"
/>

<FormHintText
  hintText="Invalid email format"
  severity="error"
/>
```

---

## FormControlContext

Form control context for retrieving form state in custom components.

```tsx
interface FormControl {
  disabled: boolean;
  fullWidth: boolean;
  required: boolean;
  severity?: SeverityWithInfo;
}
```

```tsx
import { FormControlContext } from '@mezzanine-ui/react';
import { useContext } from 'react';

function CustomInput() {
  const formControl = useContext(FormControlContext);

  return (
    <input
      disabled={formControl?.disabled}
      required={formControl?.required}
    />
  );
}
```

---

## FormElementFocusHandlers

Type definition for form element focus events.

```tsx
type FormElementFocusHandlers = {
  onBlur?: VoidFunction;
  onFocus?: VoidFunction;
};
```

---

## Form Hooks

Hooks for controlling form input state.

| Hook                              | Purpose                      |
| --------------------------------- | ---------------------------- |
| `useInputControlValue`            | Input controlled value       |
| `useInputWithClearControlValue`   | Input with clear             |
| `useSelectValueControl`           | Select value management      |
| `useCheckboxControlValue`         | Checkbox value management    |
| `useRadioControlValue`            | Radio value management       |
| `useSwitchControlValue`           | Switch value management      |
| `useAutoCompleteValueControl`     | AutoComplete value management|
| `useCustomControlValue`           | Custom control value         |
| `useControlValueState`            | Generic controlled/uncontrolled value state |

---

## Figma Mapping

| Figma Variant                  | React Props                               |
| ------------------------------ | ----------------------------------------- |
| `FormField / Vertical`         | `<FormField layout="vertical">`           |
| `FormField / Horizontal`       | `<FormField layout="horizontal">`         |
| `FormField / Required`         | `<FormField required>`                    |
| `FormField / Error`            | `<FormField severity="error">`            |
| `FormField / With Hint`        | `<FormField hintText="...">`              |

---

## FormGroup

A form field group component for grouping multiple `FormField` elements with a group title.

### Import

```tsx
// FormGroup is not exported from main package, must import from sub-path
import { FormGroup } from '@mezzanine-ui/react/Form';
import type { FormGroupProps } from '@mezzanine-ui/react/Form';
```

### Props

| Property                   | Type        | Default    | Description                    |
| -------------------------- | ----------- | ---------- | ------------------------------ |
| `title`                    | `string`    | **Required** | Group title                  |
| `fieldsContainerClassName` | `string`    | -          | Fields container CSS class     |
| `children`                 | `ReactNode` | -          | Form fields within the group   |

### Usage Example

```tsx
import { FormGroup, FormField, Input, Select } from '@mezzanine-ui/react';

function UserInfoForm() {
  return (
    <form>
      <FormGroup title="Basic Information">
        <FormField name="name" label="Name" layout="vertical" required>
          <Input placeholder="Enter name" />
        </FormField>
        <FormField name="email" label="Email" layout="vertical" required>
          <Input inputType="email" placeholder="Enter email" />
        </FormField>
      </FormGroup>

      <FormGroup title="Contact Information">
        <FormField name="phone" label="Phone" layout="vertical">
          <Input placeholder="Enter phone" />
        </FormField>
        <FormField name="address" label="Address" layout="vertical">
          <Input placeholder="Enter address" />
        </FormField>
      </FormGroup>
    </form>
  );
}
```

---

## Best Practices

1. **Use FormField consistently**: Ensure form field styling is consistent
2. **Provide clear labels**: Every input should have a corresponding label
3. **Show error messages**: Use `severity="error"` with `hintText`
4. **Mark required fields**: Use `required` to display the required marker
5. **Choose appropriate layout**: Use `vertical` for short forms, consider `horizontal` for settings forms
6. **Use FormGroup for grouping**: When there are many form fields, use `FormGroup` to organize related fields for better readability
