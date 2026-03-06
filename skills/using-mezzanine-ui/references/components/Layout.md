# Layout Component

> **Category**: Layout
>
> **Storybook**: `Layout/Layout`
>
> **Source**: [GitHub Source Code](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/react/src/Layout)

A full-page layout component providing a main content area and resizable side panels. Uses the compound component pattern; `Layout` internally creates a `LayoutHost` context provider.

## Component Architecture

| Component            | Type   | Description                                    |
| -------------------- | ------ | ---------------------------------------------- |
| `Layout`             | Server | Layout container (auto-wraps with LayoutHost)  |
| `Layout.Main`        | Client | Main content area with scrollbar support       |
| `Layout.LeftPanel`   | Client | Resizable left side panel                      |
| `Layout.RightPanel`  | Client | Resizable right side panel                     |

> **Note**: `LayoutHost` is an internal component, not exported from the public API. `Layout` automatically creates `LayoutHost` to wrap children; manual wrapping is not needed.

## Import

```tsx
import {
  Layout,
  LayoutMain,
  LayoutLeftPanel,
  LayoutRightPanel,
} from '@mezzanine-ui/react';

import type {
  LayoutProps,
  LayoutMainProps,
  LayoutLeftPanelProps,
  LayoutRightPanelProps,
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

| Property                   | Type        | Default | Description                                                                  |
| -------------------------- | ----------- | ------- | ---------------------------------------------------------------------------- |
| `children`                 | `ReactNode` | -       | Children (`Layout.Main`, `Layout.LeftPanel`, and `Layout.RightPanel`)        |
| `contentWrapperClassName`  | `string`    | -       | Additional class name applied to the content wrapper element                 |
| `navigationClassName`      | `string`    | -       | Additional class name for the navigation wrapper (only if Navigation is used)|

---

## LayoutMain Props

Main content area.

| Property        | Type                             | Default | Description                                                                  |
| --------------- | -------------------------------- | ------- | ---------------------------------------------------------------------------- |
| `children`      | `ReactNode`                      | -       | Main content                                                                 |
| `className`     | `string`                         | -       | Additional class name applied to the main element                            |
| `scrollbarProps`| `Omit<ScrollbarProps, 'children'>` | `{}`  | Props passed to the internal `Scrollbar` component                           |

---

## LayoutLeftPanel Props

Resizable left side panel.

| Property        | Type                      | Default | Description                                          |
| --------------- | ------------------------- | ------- | ---------------------------------------------------- |
| `open`          | `boolean`                 | `false` | Controls whether the panel and its divider are visible |
| `defaultWidth`  | `number`                  | `320`   | Initial width (px) of the panel, minimum 240         |
| `onWidthChange` | `(width: number) => void` | -       | Callback fired when the panel width changes          |
| `className`     | `string`                  | -       | Additional class name applied to the panel element   |
| `scrollbarProps`| `Omit<ScrollbarProps, 'children'>` | `{}` | Props passed to the internal `Scrollbar` component |
| `children`      | `ReactNode`               | -       | Content rendered inside the left panel               |

---

## LayoutRightPanel Props

Resizable right side panel.

| Property        | Type                      | Default | Description                                          |
| --------------- | ------------------------- | ------- | ---------------------------------------------------- |
| `open`          | `boolean`                 | `false` | Controls whether the panel and its divider are visible |
| `defaultWidth`  | `number`                  | `320`   | Initial width (px) of the panel, minimum 240         |
| `onWidthChange` | `(width: number) => void` | -       | Callback fired when the panel width changes          |
| `className`     | `string`                  | -       | Additional class name applied to the panel element   |
| `scrollbarProps`| `Omit<ScrollbarProps, 'children'>` | `{}` | Props passed to the internal `Scrollbar` component |
| `children`      | `ReactNode`               | -       | Content rendered inside the right panel              |

---

## Usage Examples

### Basic Usage (Compound Component Pattern)

```tsx
import { Layout } from '@mezzanine-ui/react';
import { useState } from 'react';

function AppLayout() {
  const [rightPanelOpen, setRightPanelOpen] = useState(false);

  return (
    <Layout>
      <Layout.Main>
        <h1>Main Content</h1>
        <button onClick={() => setRightPanelOpen(true)}>
          Open Right Panel
        </button>
      </Layout.Main>
      <Layout.RightPanel open={rightPanelOpen}>
        <h2>Right Panel Content</h2>
        <button onClick={() => setRightPanelOpen(false)}>
          Close
        </button>
      </Layout.RightPanel>
    </Layout>
  );
}
```

### With Left and Right Panels

```tsx
import { Layout } from '@mezzanine-ui/react';
import { useState } from 'react';

function AppLayoutWithBothPanels() {
  const [leftOpen, setLeftOpen] = useState(false);
  const [rightOpen, setRightOpen] = useState(false);

  return (
    <Layout>
      <Layout.LeftPanel open={leftOpen} defaultWidth={280}>
        <p>Left panel content</p>
      </Layout.LeftPanel>
      <Layout.Main>
        <p>Main content area</p>
      </Layout.Main>
      <Layout.RightPanel open={rightOpen} defaultWidth={400}>
        <p>Right panel content</p>
      </Layout.RightPanel>
    </Layout>
  );
}
```

### With Custom Width and Resize Callback

```tsx
import { Layout } from '@mezzanine-ui/react';
import { useState } from 'react';

function AppLayoutWithCustomWidth() {
  const [rightPanelOpen, setRightPanelOpen] = useState(false);
  const [panelWidth, setPanelWidth] = useState(400);

  return (
    <Layout>
      <Layout.Main>
        <p>Main content area</p>
      </Layout.Main>
      <Layout.RightPanel
        open={rightPanelOpen}
        defaultWidth={panelWidth}
        onWidthChange={setPanelWidth}
      >
        <p>Right panel content, current width: {panelWidth}px</p>
      </Layout.RightPanel>
    </Layout>
  );
}
```

---

## Best Practices

1. **No need to manually wrap LayoutHost**: `Layout` internally creates `LayoutHost` context provider automatically; just use `<Layout>` directly.
2. **Panel width**: `defaultWidth` minimum is 240px, default 320px, adjustable by dragging or arrow keys.
3. **Compound Component**: Use dot notation with `Layout.Main`, `Layout.LeftPanel`, and `Layout.RightPanel` to keep the structure clear.
4. **Standalone imports also available**: `LayoutMain`, `LayoutLeftPanel`, and `LayoutRightPanel` can be imported directly from `@mezzanine-ui/react`.
5. **Child order is flexible**: `Layout` automatically reorders `Navigation`, `LeftPanel`, `Main`, and `RightPanel` into the correct DOM sequence regardless of the order they are written in JSX.
