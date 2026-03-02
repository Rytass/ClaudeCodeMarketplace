# Popper Component

> **Category**: Utility
>
> **Storybook**: `Utility/Popper`
>
> **Source**: [GitHub Source Code](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/react/src/Popper)

A positioned popup layer component based on @floating-ui/react-dom, used as the underlying positioning for Tooltip, Dropdown, Select, and other components.

## Import

```tsx
import { Popper } from '@mezzanine-ui/react';
import type {
  PopperProps,
  PopperPlacement,
  PopperPositionStrategy,
  PopperController
} from '@mezzanine-ui/react';
```

---

## Popper Props

> Extends `NativeElementPropsWithoutKeyAndRef<'div'>`.

| Property        | Type                        | Default | Description              |
| --------------- | --------------------------- | ------- | ------------------------ |
| `anchor`        | `ElementGetter`             | -       | Anchor element (trigger) |
| `arrow`         | `ArrowConfig \| null`       | -       | Arrow configuration      |
| `children`      | `ReactNode`                 | -       | Popup content            |
| `container`     | `HTMLElement \| RefObject<HTMLElement \| null> \| null` | - | Portal container |
| `controllerRef` | `Ref<PopperController>`     | -       | Controller reference     |
| `disablePortal` | `boolean`                   | -       | Disable Portal           |
| `open`          | `boolean`                   | `false` | Whether open             |
| `options`       | `UseFloatingOptions`        | -       | floating-ui options      |

---

## ArrowConfig

```tsx
interface ArrowConfig {
  enabled: boolean;
  className: string;
  padding?: number;
}
```

---

## PopperPlacement

```tsx
type PopperPlacement =
  | 'top' | 'top-start' | 'top-end'
  | 'right' | 'right-start' | 'right-end'
  | 'bottom' | 'bottom-start' | 'bottom-end'
  | 'left' | 'left-start' | 'left-end';
```

---

## PopperController

Controller object obtained via `controllerRef`, equivalent to `UseFloatingReturn` from `@floating-ui/react-dom`. Actual structure may vary by `@floating-ui` version; below are the main properties:

```tsx
// Type equals UseFloatingReturn (from @floating-ui/react-dom)
interface PopperController {
  refs: {
    reference: MutableRefObject<Element | null>;
    floating: MutableRefObject<HTMLElement | null>;
    setReference: (el: Element | null) => void;
    setFloating: (el: HTMLElement | null) => void;
  };
  floatingStyles: CSSProperties;
  placement: Placement;
  middlewareData: MiddlewareData;
  update: () => void;
  // ...other UseFloatingReturn properties
}
```

---

## Usage Examples

### Basic Usage

```tsx
import { Popper } from '@mezzanine-ui/react';
import { useRef, useState } from 'react';

function BasicExample() {
  const anchorRef = useRef<HTMLButtonElement>(null);
  const [open, setOpen] = useState(false);

  return (
    <>
      <button
        ref={anchorRef}
        onClick={() => setOpen(!open)}
      >
        Toggle
      </button>
      <Popper
        anchor={anchorRef}
        open={open}
        options={{
          placement: 'bottom-start',
        }}
      >
        <div>Popup content</div>
      </Popper>
    </>
  );
}
```

### Specify Placement

```tsx
<Popper
  anchor={anchorRef}
  open={open}
  options={{
    placement: 'top',
  }}
>
  <div>Shown above</div>
</Popper>
```

### With Arrow

```tsx
<Popper
  anchor={anchorRef}
  open={open}
  arrow={{
    enabled: true,
    className: 'my-arrow-class',
    padding: 8,
  }}
  options={{
    placement: 'bottom',
  }}
>
  <div>Content with arrow</div>
</Popper>
```

### Using floating-ui Middleware

```tsx
import { offset, flip, shift } from '@floating-ui/react-dom';

<Popper
  anchor={anchorRef}
  open={open}
  options={{
    placement: 'bottom-start',
    middleware: [
      offset(8),        // Distance from anchor
      flip(),           // Auto-flip direction
      shift({ padding: 8 }), // Prevent overflow
    ],
  }}
>
  <div>Content</div>
</Popper>
```

### Getting the Controller

```tsx
function WithController() {
  const controllerRef = useRef<PopperController>(null);
  const anchorRef = useRef<HTMLButtonElement>(null);
  const [open, setOpen] = useState(false);

  const handleUpdate = () => {
    controllerRef.current?.update();
  };

  return (
    <>
      <button ref={anchorRef} onClick={() => setOpen(!open)}>
        Toggle
      </button>
      <Popper
        anchor={anchorRef}
        open={open}
        controllerRef={controllerRef}
      >
        <div>Content</div>
      </Popper>
      <button onClick={handleUpdate}>Manually update position</button>
    </>
  );
}
```

### Custom Container

```tsx
const containerRef = useRef<HTMLDivElement>(null);

<div ref={containerRef} style={{ position: 'relative' }}>
  <Popper
    anchor={anchorRef}
    open={open}
    container={containerRef.current}
  >
    <div>Renders to custom container</div>
  </Popper>
</div>
```

### Disable Portal

```tsx
<Popper
  anchor={anchorRef}
  open={open}
  disablePortal
>
  <div>Renders directly in place</div>
</Popper>
```

---

## Internal Behavior

1. **Portal**: Renders to Portal container by default
2. **Position calculation**: Uses floating-ui to compute optimal position
3. **Auto-update**: Position updates automatically when `open` changes
4. **Arrow positioning**: Arrow position and rotation are calculated automatically based on placement

---

## Figma Mapping

| Figma Variant          | React Props                              |
| ---------------------- | ---------------------------------------- |
| `Popper / Top`         | `options.placement="top"`                |
| `Popper / Bottom`      | `options.placement="bottom"`             |
| `Popper / Left`        | `options.placement="left"`               |
| `Popper / Right`       | `options.placement="right"`              |
| `Popper / With Arrow`  | `arrow.enabled`                          |

---

## Best Practices

1. **Use higher-level components**: Generally use Tooltip, Dropdown, Popover, and other higher-level components
2. **Middleware configuration**: Recommend using offset, flip, shift and other middleware for good positioning behavior
3. **Anchor element**: Anchor can be a ref or function; ensure it correctly retrieves the DOM element
4. **Manual update**: When anchor position changes but Popper doesn't update, use controllerRef.update()
5. **Arrow styling**: Use arrow.className to customize arrow styles
