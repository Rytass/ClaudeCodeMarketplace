# Layout Component

> **Category**: Layout
>
> **Storybook**: `Layout/Layout`
>
> **Source**: [GitHub Source Code](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/react/src/Layout)

A full-page layout component providing a main content area and a resizable side panel. Uses the compound component pattern; `Layout` internally creates a `LayoutHost` context provider.

## Component Architecture

| Component          | Type     | Description                                     |
| ------------------ | -------- | ----------------------------------------------- |
| `Layout`           | Server   | Layout container (auto-wraps with LayoutHost)   |
| `Layout.Main`      | Server   | Main content area (pure children passthrough)   |
| `Layout.SidePanel` | Client   | Resizable side panel                            |

> **Note**: `LayoutHost` is an internal component, not exported from the public API. `Layout` automatically creates `LayoutHost` to wrap children; manual wrapping is not needed.

## Import

```tsx
import {
  Layout,
  LayoutMain,
  LayoutSidePanel,
} from '@mezzanine-ui/react';

import type {
  LayoutProps,
  LayoutMainProps,
  LayoutSidePanelProps,
} from '@mezzanine-ui/react';
```

Sub-path additional exports:

```tsx
import type { LayoutHostProps } from '@mezzanine-ui/react/Layout';
```

---

## Layout Props

Outermost layout container.

Extends `NativeElementPropsWithoutKeyAndRef<'div'>` (all native `<div>` attributes).

| Property   | Type        | Default | Description                                    |
| ---------- | ----------- | ------- | ---------------------------------------------- |
| `children` | `ReactNode` | -       | Children (`Layout.Main` and `Layout.SidePanel`) |

---

## LayoutMain Props

Main content area. **Does not extend native element props**, only accepts children.

| Property   | Type        | Default | Description  |
| ---------- | ----------- | ------- | ------------ |
| `children` | `ReactNode` | -       | Main content |

---

## LayoutSidePanel Props

Resizable side panel.

| Property                    | Type                          | Default | Description                               |
| --------------------------- | ----------------------------- | ------- | ----------------------------------------- |
| `open`                      | `boolean`                     | `false` | Whether side panel is open                |
| `defaultSidePanelWidth`     | `number`                      | `320`   | Default width (px), minimum 240           |
| `onSidePanelWidthChange`    | `(width: number) => void`     | -       | Width change callback                     |
| `children`                  | `ReactNode`                   | -       | Side panel content                        |

---

## Usage Examples

### Basic Usage (Compound Component Pattern)

```tsx
import { Layout } from '@mezzanine-ui/react';
import { useState } from 'react';

function AppLayout() {
  const [sidePanelOpen, setSidePanelOpen] = useState(false);

  return (
    <Layout>
      <Layout.Main>
        <h1>Main Content</h1>
        <button onClick={() => setSidePanelOpen(true)}>
          Open Side Panel
        </button>
      </Layout.Main>
      <Layout.SidePanel open={sidePanelOpen}>
        <h2>Side Panel Content</h2>
        <button onClick={() => setSidePanelOpen(false)}>
          Close
        </button>
      </Layout.SidePanel>
    </Layout>
  );
}
```

### With Custom Width

```tsx
import { Layout } from '@mezzanine-ui/react';
import { useState } from 'react';

function AppLayoutWithCustomWidth() {
  const [sidePanelOpen, setSidePanelOpen] = useState(false);
  const [panelWidth, setPanelWidth] = useState(400);

  return (
    <Layout>
      <Layout.Main>
        <p>Main content area</p>
      </Layout.Main>
      <Layout.SidePanel
        open={sidePanelOpen}
        defaultSidePanelWidth={panelWidth}
        onSidePanelWidthChange={setPanelWidth}
      >
        <p>Side panel content, current width: {panelWidth}px</p>
      </Layout.SidePanel>
    </Layout>
  );
}
```

---

## Best Practices

1. **No need to manually wrap LayoutHost**: `Layout` internally creates `LayoutHost` context provider automatically; just use `<Layout>` directly.
2. **Side panel width**: `defaultSidePanelWidth` minimum is 240px, default 320px, adjustable by dragging.
3. **Compound Component**: Use dot notation with `Layout.Main` and `Layout.SidePanel` to keep the structure clear.
4. **Standalone imports also available**: `LayoutMain` and `LayoutSidePanel` can be imported directly from `@mezzanine-ui/react`.
