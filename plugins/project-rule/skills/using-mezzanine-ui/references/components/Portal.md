# Portal Component

> **Category**: Utility
>
> **Storybook**: `Utility/Portal`
>
> **Source**: [GitHub Source Code](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/react/src/Portal)

A portal component that renders children to a different location in the DOM. Used by Modal, Drawer, Tooltip, and other components that need to escape the parent DOM structure.

## Import

```tsx
import { Portal } from '@mezzanine-ui/react';
import type { PortalProps } from '@mezzanine-ui/react';

// Portal initialization (call at app startup)
import { initializePortals } from '@mezzanine-ui/react/Portal';

// Other sub-path exports
// import { getContainer, getRootElement, resetPortals, PortalLayer } from '@mezzanine-ui/react/Portal';
```

---

## Portal Props

| Property        | Type                                     | Default     | Description        |
| --------------- | ---------------------------------------- | ----------- | ------------------ |
| `children`      | `ReactNode`                              | -           | Child content      |
| `container`     | `HTMLElement \| RefObject<HTMLElement \| null> \| null` | - | Target container |
| `disablePortal` | `boolean`                                | `false`     | Disable Portal     |
| `layer`         | `'default' \| 'alert'`                   | `'default'` | Portal layer       |

---

## PortalLayer

| Layer     | Description                                                              |
| --------- | ------------------------------------------------------------------------ |
| `default` | Default layer, renders to `#mzn-portal-container` (className: `mzn-portal-default`) |
| `alert`   | Alert layer, renders to `#mzn-alert-container` (className: `mzn-portal-alert`)      |

---

## Usage Examples

### Basic Usage

```tsx
import { Portal } from '@mezzanine-ui/react';

<Portal>
  <div>This content renders to the Portal container</div>
</Portal>
```

### Using Alert Layer

```tsx
<Portal layer="alert">
  <div>This content renders to the alert container (higher z-index)</div>
</Portal>
```

### Specify Target Container (HTMLElement)

```tsx
function CustomContainer() {
  const [container, setContainer] = useState<HTMLElement | null>(null);

  useEffect(() => {
    setContainer(document.getElementById('my-container'));
  }, []);

  return (
    <Portal container={container}>
      <div>Renders to custom container</div>
    </Portal>
  );
}
```

### Specify Target Container (RefObject)

```tsx
function RefContainer() {
  const containerRef = useRef<HTMLDivElement>(null);

  return (
    <>
      <div ref={containerRef} id="target-container" />
      <Portal container={containerRef}>
        <div>Renders to the ref-pointed container</div>
      </Portal>
    </>
  );
}
```

### Disable Portal

```tsx
<Portal disablePortal>
  <div>Renders in place, Portal not used</div>
</Portal>
```

### Usage in Modal

```tsx
// Modal component internally uses Portal
function Modal({ open, children }) {
  if (!open) return null;

  return (
    <Portal>
      <div className="modal-backdrop">
        <div className="modal-content">
          {children}
        </div>
      </div>
    </Portal>
  );
}
```

---

## Portal Containers

Mezzanine-UI automatically creates two Portal containers as **children** of `rootElement` (default: `document.body`):

```html
<body> <!-- rootElement (default: document.body) -->
  <div id="root"><!-- Application --></div>
  <!-- Portal containers below, children of rootElement -->
  <div id="mzn-portal-container" class="mzn-portal-default"><!-- default layer --></div>
  <div id="mzn-alert-container" class="mzn-portal-alert"><!-- alert layer --></div>
</body>
```

---

## Server-Side Rendering (SSR)

In SSR environments, since `window` doesn't exist, Portal returns `null`:

```tsx
// Server-side does not render Portal content
if (typeof window === 'undefined') return null;
```

---

## Relationship with Other Components

The following components use Portal internally:
- **Modal** - Dialog
- **Drawer** - Drawer
- **Backdrop** - Backdrop overlay
- **Popper** - Positioned popup layer
- **Tooltip** - Tooltip
- **Message** - Message notification
- **NotificationCenter** - Notification center

---

## Figma Mapping

Portal is a purely functional component with no corresponding visual element in Figma.

---

## Best Practices

1. **Use higher-level components**: Generally don't use Portal directly; use Modal, Drawer, etc.
2. **Layer selection**: Use `layer="alert"` for content requiring the highest z-index (e.g., global alerts)
3. **Custom container**: Use the `container` prop when a specific DOM location is needed
4. **Disable Portal**: Use `disablePortal` for testing or special layout needs
5. **SSR note**: Portal doesn't render on the server; be aware of hydration issues
