# Drawer Component

> **Category**: Navigation
>
> **Storybook**: `Navigation/Drawer`
>
> **Source**: [GitHub Source Code](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/react/src/Drawer)

A drawer component that slides out from the edge of the page, used to display detailed information or forms.

## Import

```tsx
import { Drawer } from '@mezzanine-ui/react';
import type { DrawerProps, DrawerPlacement } from '@mezzanine-ui/react';
```

---

## Drawer Props

> Extends `NativeElementPropsWithoutKeyAndRef<'div'>` and partial `BackdropProps`.

### Core Props

| Property                      | Type              | Default    | Description                    |
| ----------------------------- | ----------------- | ---------- | ------------------------------ |
| `open`                        | `boolean`         | -          | Whether the drawer is open     |
| `onClose`                     | `VoidFunction`    | -          | Close event handler            |
| `children`                    | `ReactNode`       | -          | Content                        |
| `size`                        | `DrawerSize`      | `'medium'` | Width size                     |
| `headerTitle`                 | `string`          | -          | Header title text              |
| `isHeaderDisplay`             | `boolean`         | -          | Whether to show header area    |
| `isBottomDisplay`             | `boolean`         | -          | Whether to show bottom area    |
| `container`                   | `Element`         | -          | Portal container               |
| `disablePortal`               | `boolean`         | -          | Disable Portal                 |
| `disableCloseOnBackdropClick` | `boolean`         | `false`    | Disable close on backdrop click|
| `disableCloseOnEscapeKeyDown` | `boolean`         | `false`    | Disable close on ESC key       |
| `contentKey`                  | `React.Key`       | -          | Remounts drawer content on change, prevents stale DOM state |
| `onBackdropClick`             | `() => void`      | -          | Backdrop click event handler   |

### Bottom Ghost Button Props

| Property                          | Type              | Default         | Description          |
| --------------------------------- | ----------------- | --------------- | -------------------- |
| `bottomGhostActionText`           | `string`          | -               | Button text          |
| `bottomOnGhostActionClick`        | `VoidFunction`    | -               | Click event handler  |
| `bottomGhostActionDisabled`       | `boolean`         | -               | Whether disabled     |
| `bottomGhostActionIcon`           | `IconDefinition`  | -               | Button icon          |
| `bottomGhostActionIconType`       | `ButtonIconType`  | -               | Icon position        |
| `bottomGhostActionLoading`        | `boolean`         | -               | Loading state        |
| `bottomGhostActionSize`           | `ButtonSize`      | -               | Button size          |
| `bottomGhostActionVariant`        | `ButtonVariant`   | `'base-ghost'`  | Button variant       |

### Bottom Primary Button Props

| Property                          | Type              | Default           | Description          |
| --------------------------------- | ----------------- | ----------------- | -------------------- |
| `bottomPrimaryActionText`         | `string`          | -                 | Button text          |
| `bottomOnPrimaryActionClick`      | `VoidFunction`    | -                 | Click event handler  |
| `bottomPrimaryActionDisabled`     | `boolean`         | -                 | Whether disabled     |
| `bottomPrimaryActionIcon`         | `IconDefinition`  | -                 | Button icon          |
| `bottomPrimaryActionIconType`     | `ButtonIconType`  | -                 | Icon position        |
| `bottomPrimaryActionLoading`      | `boolean`         | -                 | Loading state        |
| `bottomPrimaryActionSize`         | `ButtonSize`      | -                 | Button size          |
| `bottomPrimaryActionVariant`      | `ButtonVariant`   | `'base-primary'`  | Button variant       |

### Bottom Secondary Button Props

| Property                            | Type              | Default             | Description          |
| ----------------------------------- | ----------------- | ------------------- | -------------------- |
| `bottomSecondaryActionText`         | `string`          | -                   | Button text          |
| `bottomOnSecondaryActionClick`      | `VoidFunction`    | -                   | Click event handler  |
| `bottomSecondaryActionDisabled`     | `boolean`         | -                   | Whether disabled     |
| `bottomSecondaryActionIcon`         | `IconDefinition`  | -                   | Button icon          |
| `bottomSecondaryActionIconType`     | `ButtonIconType`  | -                   | Icon position        |
| `bottomSecondaryActionLoading`      | `boolean`         | -                   | Loading state        |
| `bottomSecondaryActionSize`         | `ButtonSize`      | -                   | Button size          |
| `bottomSecondaryActionVariant`      | `ButtonVariant`   | `'base-secondary'`  | Button variant       |

### Control Bar Props

| Property                          | Type                                    | Default      | Description                    |
| --------------------------------- | --------------------------------------- | ------------ | ------------------------------ |
| `controlBarShow`                  | `boolean`                               | `false`      | Whether to show control bar    |
| `renderControlBar`                | `() => ReactNode`                       | -            | Custom control bar render fn   |
| `controlBarAllRadioLabel`         | `string`                                | -            | Control bar "All" label        |
| `controlBarReadRadioLabel`        | `string`                                | -            | Control bar "Read" label       |
| `controlBarUnreadRadioLabel`      | `string`                                | -            | Control bar "Unread" label     |
| `controlBarShowUnreadButton`      | `boolean`                               | `false`      | Whether to show unread button  |
| `controlBarCustomButtonLabel`     | `string`                                | `'Mark All Read'` | Custom button text             |
| `controlBarOnCustomButtonClick`   | `VoidFunction`                          | -            | Custom button click handler    |
| `controlBarOnRadioChange`         | `ChangeEventHandler<HTMLInputElement>`  | -            | Radio change event handler     |
| `controlBarDefaultValue`          | `string`                                | -            | Default radio value            |
| `controlBarValue`                 | `string`                                | -            | Controlled radio value         |
| `controlBarIsEmpty`               | `boolean`                               | `false`      | Whether to disable custom btn  |

---

## Type Definitions

```ts
type DrawerSize = 'narrow' | 'medium' | 'wide';
// Note: DrawerSize must be imported from @mezzanine-ui/core/drawer

// DrawerPlacement is exported but the Drawer component currently uses fixed right placement, does not use placement prop
type DrawerPlacement = 'top' | 'right' | 'bottom' | 'left';
```

### DrawerSize

| Size     | Description   |
| -------- | ------------- |
| `narrow` | Narrow drawer |
| `medium` | Medium drawer |
| `wide`   | Wide drawer   |

---

## Usage Examples

### Basic Usage

```tsx
import { Drawer, Button } from '@mezzanine-ui/react';
import { useState } from 'react';

function BasicDrawer() {
  const [open, setOpen] = useState(false);

  return (
    <>
      <Button onClick={() => setOpen(true)}>Open Drawer</Button>
      <Drawer
        open={open}
        onClose={() => setOpen(false)}
        isHeaderDisplay
        headerTitle="Drawer Title"
      >
        <p>Drawer content</p>
      </Drawer>
    </>
  );
}
```

### Different Sizes

```tsx
// Narrow
<Drawer size="narrow" open={open} onClose={onClose}>
  Narrow drawer content
</Drawer>

// Medium (default)
<Drawer size="medium" open={open} onClose={onClose}>
  Medium drawer content
</Drawer>

// Wide
<Drawer size="wide" open={open} onClose={onClose}>
  Wide drawer content
</Drawer>
```

### With Header and Bottom

```tsx
<Drawer
  open={open}
  onClose={onClose}
  isHeaderDisplay
  headerTitle="Edit User"
  isBottomDisplay
  bottomPrimaryActionText="Save"
  bottomOnPrimaryActionClick={handleSave}
  bottomSecondaryActionText="Cancel"
  bottomOnSecondaryActionClick={onClose}
>
  <UserForm />
</Drawer>
```

### With Three Bottom Buttons

```tsx
<Drawer
  open={open}
  onClose={onClose}
  isHeaderDisplay
  headerTitle="Advanced Settings"
  isBottomDisplay
  bottomGhostActionText="Reset"
  bottomOnGhostActionClick={handleReset}
  bottomSecondaryActionText="Cancel"
  bottomOnSecondaryActionClick={onClose}
  bottomPrimaryActionText="Apply"
  bottomOnPrimaryActionClick={handleApply}
>
  <SettingsForm />
</Drawer>
```

### Disable Backdrop Click Close

```tsx
<Drawer
  open={open}
  onClose={onClose}
  disableCloseOnBackdropClick
  isHeaderDisplay
  headerTitle="Important Form"
>
  <ImportantForm />
</Drawer>
```

### Disable ESC Close

```tsx
<Drawer
  open={open}
  onClose={onClose}
  disableCloseOnEscapeKeyDown
  isHeaderDisplay
  headerTitle="Fill Form"
>
  <FormContent />
</Drawer>
```

### Form Drawer

```tsx
function FormDrawer() {
  const [open, setOpen] = useState(false);
  const [formData, setFormData] = useState({ name: '', email: '' });

  const handleSave = () => {
    // Save logic
    setOpen(false);
  };

  return (
    <>
      <Button onClick={() => setOpen(true)}>Add User</Button>
      <Drawer
        open={open}
        onClose={() => setOpen(false)}
        size="medium"
        isHeaderDisplay
        headerTitle="Add User"
        isBottomDisplay
        bottomPrimaryActionText="Save"
        bottomOnPrimaryActionClick={handleSave}
        bottomSecondaryActionText="Cancel"
        bottomOnSecondaryActionClick={() => setOpen(false)}
      >
        <FormField name="name" label="Name" layout="vertical" required>
          <Input
            value={formData.name}
            onChange={(e) => setFormData({ ...formData, name: e.target.value })}
          />
        </FormField>
        <FormField name="email" label="Email" layout="vertical" required>
          <Input
            inputType="email"
            value={formData.email}
            onChange={(e) => setFormData({ ...formData, email: e.target.value })}
          />
        </FormField>
      </Drawer>
    </>
  );
}
```

---

## Figma Mapping

| Figma Variant                    | React Props                              |
| -------------------------------- | ---------------------------------------- |
| `Drawer / Narrow`                | `size="narrow"`                          |
| `Drawer / Medium`                | `size="medium"`                          |
| `Drawer / Wide`                  | `size="wide"`                            |
| `Drawer / With Header`           | `isHeaderDisplay`                        |
| `Drawer / With Bottom Actions`   | `isBottomDisplay`                        |
| `Drawer / Full`                  | `isHeaderDisplay isBottomDisplay`        |

---

## Best Practices

1. **Choose appropriate size**: Select `size` based on content volume
2. **Provide close methods**: Ensure users can close the drawer
3. **Use bottom buttons for forms**: Form drawers should use the bottom action area
4. **Disable backdrop close for critical operations**: Prevent accidental closure
5. **Stacking handling**: With multiple drawers, ESC only closes the topmost one
