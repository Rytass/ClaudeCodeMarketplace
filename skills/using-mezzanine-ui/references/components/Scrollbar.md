# Scrollbar Component

> **Category**: Internal
>
> **Storybook**: `Internal/Scrollbar`
>
> **Source Verification**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/react/src/Scrollbar)

Custom scrollbar component providing consistent scrollbar styles across browsers. Based on OverlayScrollbars.

## Import

```tsx
// Internal component, not publicly exported from @mezzanine-ui/react
// Must be imported from sub-path
import Scrollbar from '@mezzanine-ui/react/Scrollbar';
import type { ScrollbarProps } from '@mezzanine-ui/react/Scrollbar';
```

> **Note**: Scrollbar is not exported from the `@mezzanine-ui/react` main entry. It is an internal component.

---

## Scrollbar Props

| Property          | Type                                          | Default | Description                |
| ----------------- | --------------------------------------------- | ------- | -------------------------- |
| `children`        | `ReactNode`                                   | -       | Content                    |
| `className`       | `string`                                      | -       | className                  |
| `defer`           | `boolean \| object`                           | `true`  | Deferred initialization    |
| `disabled`        | `boolean`                                     | `false` | Disable custom scrollbar   |
| `events`          | `OverlayScrollbarsComponentProps['events']`   | -       | Event handlers             |
| `maxHeight`       | `number \| string`                            | -       | Maximum height             |
| `maxWidth`        | `number \| string`                            | -       | Maximum width              |
| `onViewportReady` | `(viewport, instance?) => void`               | -       | Viewport ready callback    |
| `options`         | `PartialOptions`                              | -       | OverlayScrollbars options  |
| `style`           | `CSSProperties`                               | -       | Style                      |

---

## Default Options

The component uses the following default OverlayScrollbars options:

```tsx
{
  overflow: {
    x: 'scroll',
    y: 'scroll',
  },
  scrollbars: {
    autoHide: 'scroll',
    autoHideDelay: 600,
    clickScroll: true,
  },
}
```

> **Note**: `overflow` is a forced value and will be overridden back to `{ x: 'scroll', y: 'scroll' }` even if passed via `options`. `scrollbars` is an overridable default that can be customized via `options.scrollbars`.

---

## Usage Examples

### Basic Usage

```tsx
import Scrollbar from '@mezzanine-ui/react/Scrollbar';

<Scrollbar maxHeight={300}>
  <div style={{ height: 600 }}>
    Long content...
  </div>
</Scrollbar>
```

### Width Constraint

```tsx
<Scrollbar maxWidth={400} maxHeight={300}>
  <div style={{ width: 800, height: 600 }}>
    Extra wide and tall content...
  </div>
</Scrollbar>
```

### Disable Custom Scrollbar

```tsx
<Scrollbar disabled maxHeight={300}>
  <div style={{ height: 600 }}>
    Using native scrollbar...
  </div>
</Scrollbar>
```

### Get Viewport Reference

```tsx
function ScrollbarWithRef() {
  const handleViewportReady = (viewport: HTMLDivElement, instance) => {
    console.log('viewport element:', viewport);
    console.log('OverlayScrollbars instance:', instance);
  };

  return (
    <Scrollbar maxHeight={300} onViewportReady={handleViewportReady}>
      <div style={{ height: 600 }}>Content...</div>
    </Scrollbar>
  );
}
```

### Custom Options

```tsx
<Scrollbar
  maxHeight={300}
  options={{
    scrollbars: {
      autoHide: 'leave',
      autoHideDelay: 200,
    },
  }}
>
  <div style={{ height: 600 }}>Content...</div>
</Scrollbar>
```

### Usage in Modal

```tsx
<Modal open={open} onClose={handleClose}>
  <ModalHeader>Title</ModalHeader>
  <ModalBody>
    <Scrollbar maxHeight={400}>
      <div style={{ height: 800 }}>
        Long form or list content...
      </div>
    </Scrollbar>
  </ModalBody>
  <ModalFooter>
    <Button onClick={handleClose}>Close</Button>
  </ModalFooter>
</Modal>
```

---

## Event Handling

```tsx
<Scrollbar
  maxHeight={300}
  events={{
    initialized: (instance) => {
      console.log('Scrollbar initialized');
    },
    scroll: ({ target }) => {
      console.log('Scrolling:', target.scrollTop);
    },
  }}
>
  <div style={{ height: 600 }}>Content...</div>
</Scrollbar>
```

---

## Figma Mapping

| Figma Variant               | React Props                              |
| --------------------------- | ---------------------------------------- |
| `Scrollbar / Default`       | Default                                  |
| `Scrollbar / Horizontal`    | Content width exceeds container          |
| `Scrollbar / Vertical`      | Content height exceeds container         |
| `Scrollbar / Both`          | Content exceeds container in both axes   |

---

## Best Practices

1. **Set dimensions**: Must set `maxHeight` or `maxWidth` to see scrollbars
2. **Deferred init**: Default `defer=true` improves initial render performance
3. **Disabled mode**: `disabled=true` renders as a plain div
4. **Click scroll**: Default `clickScroll` enabled, allows clicking the track to scroll directly
5. **Auto hide**: Scrollbar auto-hides 600ms after scrolling stops
