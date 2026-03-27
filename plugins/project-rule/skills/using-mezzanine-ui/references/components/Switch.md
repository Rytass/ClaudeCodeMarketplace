# Switch Component

> ⚠️ **DEPRECATED in rc.8**: Replaced by Toggle component in rc.8. The `Switch` name is no longer used; use the `Toggle` component instead.

> **Category**: Data Entry
>
> **Storybook**: `Data Entry/Toggle` (renamed from Switch)
>
> **Source Verification**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/react/src/Toggle) · Verified rc.8 (2026-03-27)

Toggle switch component for switching between two states (on/off). In v2, renamed from `Toggle` to `Switch` (source directory remains `Toggle`, re-exported as `Switch` via `index.ts`).

## Import

```tsx
import { Switch } from '@mezzanine-ui/react';
import type { SwitchProps, SwitchSize } from '@mezzanine-ui/react';
// Underlying type aliases: ToggleProps as SwitchProps, ToggleSize as SwitchSize
```

---

## Switch Props

> Extends `Omit<NativeElementPropsWithoutKeyAndRef<'div'>, 'onChange'>`, `ref` points to the root `HTMLDivElement`.

| Property         | Type                                   | Default                      | Description                          |
| ---------------- | -------------------------------------- | ---------------------------- | ------------------------------------ |
| `checked`        | `boolean`                              | -                            | Controlled on state                  |
| `defaultChecked` | `boolean`                              | -                            | Uncontrolled default state           |
| `disabled`       | `boolean`                              | `false` (inherits FormControl) | Whether disabled                   |
| `inputProps`     | `Omit<InputHTMLAttributes, ...>`       | -                            | Props passed to native input element |
| `label`          | `string`                               | -                            | Label text                           |
| `onChange`       | `ChangeEventHandler<HTMLInputElement>` | -                            | Change event                         |
| `size`           | `SwitchSize`                           | `'main'`                     | Size                                 |
| `supportingText` | `string`                               | -                            | Supporting text below label          |

---

## SwitchSize Type

| Size   | Description    |
| ------ | -------------- |
| `main` | Primary size   |
| `sub`  | Secondary size |

---

## Usage Examples

### Basic Usage

```tsx
import { Switch } from '@mezzanine-ui/react';

// Uncontrolled
<Switch defaultChecked />

// Controlled
const [checked, setChecked] = useState(false);

<Switch
  checked={checked}
  onChange={(e) => setChecked(e.target.checked)}
/>
```

### With Label

```tsx
<Switch
  label="Enable Notifications"
  checked={checked}
  onChange={handleChange}
/>
```

### With Supporting Text

```tsx
<Switch
  label="Auto Update"
  supportingText="System will automatically check and install updates in the background"
  checked={checked}
  onChange={handleChange}
/>
```

### Different Sizes

```tsx
// Primary size (default)
<Switch size="main" label="Primary Size" />

// Secondary size
<Switch size="sub" label="Secondary Size" />
```

### Disabled State

```tsx
<Switch disabled label="Disabled" />
<Switch disabled checked label="Disabled but On" />
```

### Settings Group

```tsx
function SettingsForm() {
  const [settings, setSettings] = useState({
    notifications: true,
    autoUpdate: false,
    darkMode: false,
  });

  const handleChange = (key: string) => (e: ChangeEvent<HTMLInputElement>) => {
    setSettings({
      ...settings,
      [key]: e.target.checked,
    });
  };

  return (
    <div>
      <Switch
        label="Push Notifications"
        supportingText="Receive important message notifications"
        checked={settings.notifications}
        onChange={handleChange('notifications')}
      />
      <Switch
        label="Auto Update"
        supportingText="Automatically download and install updates"
        checked={settings.autoUpdate}
        onChange={handleChange('autoUpdate')}
      />
      <Switch
        label="Dark Mode"
        supportingText="Use dark interface theme"
        checked={settings.darkMode}
        onChange={handleChange('darkMode')}
      />
    </div>
  );
}
```

### With FormField

```tsx
import { FormField, Switch } from '@mezzanine-ui/react';

<FormField
  name="enableFeature"
  label="Feature Settings"
  layout="vertical"
>
  <Switch
    label="Enable New Feature"
    checked={checked}
    onChange={handleChange}
  />
</FormField>
```

---

## Figma Mapping

| Figma Variant               | React Props                        |
| --------------------------- | ---------------------------------- |
| `Switch / Main`             | `size="main"`                      |
| `Switch / Sub`              | `size="sub"`                       |
| `Switch / Checked`          | `checked`                          |
| `Switch / Unchecked`        | Default                            |
| `Switch / Disabled`         | `disabled`                         |
| `Switch / With Label`       | `label="..."`                      |
| `Switch / With Supporting`  | `label="..." supportingText="..."` |

---

## Internal Implementation Notes

- Uses `useSwitchControlValue` hook for managing controlled/uncontrolled state
- Inherits `disabled` state from `FormControlContext`
- Internal structure: `div` > `span` (knob) + hidden `checkbox` input

---

## Best Practices

1. **Use label**: Always provide a clear `label` describing the switch function
2. **Immediate effect**: Switch is suitable for settings that take effect immediately; use Checkbox for non-immediate ones
3. **Provide description**: Use `supportingText` for complex settings
4. **Controlled vs uncontrolled**: Use controlled mode for forms, uncontrolled for standalone use
5. **Disabled state**: Clearly show disabled state when the value cannot be changed
