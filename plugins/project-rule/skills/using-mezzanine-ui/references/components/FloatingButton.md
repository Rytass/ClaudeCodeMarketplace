# FloatingButton Component

> **Category**: Others
>
> **Storybook**: `Others/FloatingButton`
>
> **Source**: [GitHub Source Code](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/react/src/FloatingButton)

A floating action button component that stays fixed on the page. Internally uses the `Button` component with fixed `variant="base-primary"`, `size="main"`, and `tooltipPosition="left"`. Supports auto-hide when `open` state is active.

## Import

```tsx
import { FloatingButton } from '@mezzanine-ui/react';
import type { FloatingButtonProps } from '@mezzanine-ui/react';
```

---

## Props

`FloatingButtonProps` extends `ButtonProps` (excluding `variant`, `size`, `className`, `tooltipPosition`), with the following additional properties:

| Property           | Type             | Default | Description                                        |
| ------------------ | ---------------- | ------- | -------------------------------------------------- |
| `autoHideWhenOpen` | `boolean`        | `false` | Auto-hide floating button when `open` is `true`    |
| `className`        | `string`         | -       | Additional CSS class for root element              |
| `open`             | `boolean`        | `false` | Open state of the floating button                  |
| `children`         | `ReactNode`      | -       | Button content                                     |
| `disabled`         | `boolean`        | `false` | Whether disabled (inherited from ButtonProps)       |
| `loading`          | `boolean`        | `false` | Whether to show loading state (inherited from ButtonProps) |
| `icon`             | `IconDefinition` | -       | Button icon (inherited from ButtonProps)            |
| `iconType`         | `ButtonIconType` | -       | Icon type (inherited from ButtonProps)              |
| `disabledTooltip`  | `boolean`        | `false` | Disable icon-only mode tooltip (inherited from ButtonProps) |
| `onClick`          | `MouseEventHandler` | -    | Click event handler (inherited from native props)  |

> Note: `variant`, `size`, `tooltipPosition` are internally fixed to `'base-primary'`, `'main'`, `'left'` and cannot be overridden via props.

---

## Type Definitions

### ButtonIconType

```ts
type ButtonIconType = 'leading' | 'trailing' | 'icon-only';
```

---

## Usage Examples

### Basic Floating Button

```tsx
import { FloatingButton } from '@mezzanine-ui/react';
import { PlusIcon } from '@mezzanine-ui/icons';

function BasicFloatingButton() {
  return (
    <FloatingButton
      icon={PlusIcon}
      iconType="icon-only"
      onClick={() => console.log('Add')}
    >
      Add
    </FloatingButton>
  );
}
```

### Auto-hide with Open State

```tsx
import { useState } from 'react';
import { FloatingButton } from '@mezzanine-ui/react';
import { PlusIcon } from '@mezzanine-ui/icons';

function FloatingButtonWithPanel() {
  const [panelOpen, setPanelOpen] = useState(false);

  return (
    <>
      <FloatingButton
        icon={PlusIcon}
        iconType="icon-only"
        open={panelOpen}
        autoHideWhenOpen
        onClick={() => setPanelOpen(true)}
      >
        Add Item
      </FloatingButton>
      {panelOpen && (
        <div className="panel">
          <p>Panel content</p>
          <button onClick={() => setPanelOpen(false)}>Close</button>
        </div>
      )}
    </>
  );
}
```

### With Loading State

```tsx
import { useState } from 'react';
import { FloatingButton } from '@mezzanine-ui/react';
import { UploadIcon } from '@mezzanine-ui/icons';

function FloatingButtonWithLoading() {
  const [loading, setLoading] = useState(false);

  const handleClick = async (): Promise<void> => {
    setLoading(true);

    try {
      await uploadData();
    } finally {
      setLoading(false);
    }
  };

  return (
    <FloatingButton
      icon={UploadIcon}
      iconType="icon-only"
      loading={loading}
      onClick={handleClick}
    >
      Upload
    </FloatingButton>
  );
}
```

---

## Best Practices

1. **Use icon-only mode**: Floating buttons are typically presented as icons. Set `iconType="icon-only"` with semantic `children` as tooltip text.
2. **Auto-hide**: When the floating button opens a panel or sidebar, use `autoHideWhenOpen` to prevent the button from obscuring content.
3. **Avoid multiple floating buttons**: A page should have only one floating button, representing the primary action.
4. **Fixed positioning**: FloatingButton positioning is controlled by CSS class, typically fixed at the bottom-right corner of the screen.
