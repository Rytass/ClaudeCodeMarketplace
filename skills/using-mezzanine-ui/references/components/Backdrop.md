# Backdrop Component

> **Category**: Others
>
> **Storybook**: `Others/Backdrop`
>
> **Source Verification**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/react/src/Backdrop)

Backdrop overlay component for creating backgrounds for modals, drawers, and other overlay layers.

## Import

```tsx
import { Backdrop } from '@mezzanine-ui/react';
import type { BackdropProps } from '@mezzanine-ui/react';
```

---

## Backdrop Props

| Property                        | Type                 | Default | Description                        |
| ------------------------------- | -------------------- | ------- | ---------------------------------- |
| `children`                      | `ReactNode`          | -       | Child content                      |
| `container`                     | `HTMLElement \| RefObject<HTMLElement \| null> \| null` | - | Portal container |
| `disableCloseOnBackdropClick`   | `boolean`            | `false` | Disable close on backdrop click    |
| `disablePortal`                 | `boolean`            | `false` | Disable Portal                     |
| `disableScrollLock`             | `boolean`            | `false` | Disable scroll lock                |
| `onBackdropClick`               | `MouseEventHandler`  | -       | Backdrop click callback            |
| `onClose`                       | `VoidFunction`       | -       | Close callback                     |
| `open`                          | `boolean`            | `false` | Whether open                       |
| `variant`                       | `BackdropVariant`    | `'dark'`| Backdrop variant                   |

---

## BackdropVariant Type

```tsx
type BackdropVariant = 'dark' | 'light';
```

---

## Usage Examples

### Basic Usage

```tsx
import { Backdrop } from '@mezzanine-ui/react';
import { useState } from 'react';

function BasicExample() {
  const [open, setOpen] = useState(false);

  return (
    <>
      <Button onClick={() => setOpen(true)}>Open Backdrop</Button>
      <Backdrop
        open={open}
        onClose={() => setOpen(false)}
      >
        <div>Content</div>
      </Backdrop>
    </>
  );
}
```

### Disable Close on Backdrop Click

```tsx
<Backdrop
  open={open}
  onClose={handleClose}
  disableCloseOnBackdropClick
>
  <div>Must use button to close</div>
</Backdrop>
```

### Custom Backdrop Click Handler

```tsx
<Backdrop
  open={open}
  onClose={handleClose}
  onBackdropClick={(event) => {
    console.log('Backdrop clicked');
  }}
>
  <div>Content</div>
</Backdrop>
```

### Disable Scroll Lock

```tsx
<Backdrop
  open={open}
  onClose={handleClose}
  disableScrollLock
>
  <div>Page can still scroll while backdrop is open</div>
</Backdrop>
```

### Custom Container

```tsx
const containerRef = useRef<HTMLDivElement>(null);

<div ref={containerRef} style={{ position: 'relative' }}>
  <Backdrop
    open={open}
    onClose={handleClose}
    container={containerRef.current}
  >
    <div>Rendered into custom container</div>
  </Backdrop>
</div>
```

### Disable Portal

```tsx
<Backdrop
  open={open}
  onClose={handleClose}
  disablePortal
>
  <div>Rendered in place without Portal</div>
</Backdrop>
```

---

## Internal Behavior

1. **Scroll lock**: Body scroll is locked by default when open
2. **Portal**: Renders to Portal container by default
3. **Fade animation**: Uses Fade transition effect
4. **Positioning**: Uses absolute positioning with custom container or disablePortal

---

## Figma Mapping

| Figma Variant           | React Props                    |
| ----------------------- | ------------------------------ |
| `Backdrop / Dark`       | `variant="dark"` (default)     |
| `Backdrop / Light`      | `variant="light"`              |

---

## Best Practices

1. **Pair with Modal/Drawer**: Usually used together with Modal, Drawer, and similar components
2. **Scroll lock**: Scroll lock is enabled by default to prevent background scrolling
3. **Close method**: Provide click-to-close on backdrop for better UX
4. **Portal usage**: Default Portal renders to body level, avoiding z-index issues
5. **Fade animation**: Built-in Fade animation provides smooth show/hide effects
