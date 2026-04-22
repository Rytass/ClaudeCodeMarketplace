# Layout Component

> **Category**: Layout
>
> **Storybook**: `Layout/Layout`
>
> **Source**: [GitHub Source Code](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/react/src/Layout) · Verified 1.0.3 (2026-04-21)

A full-page layout component providing a main content area and resizable side panels. Uses the compound component pattern; `Layout` internally creates a `LayoutHost` context provider.

## Component Architecture

| Component            | Type   | Description                                    |
| -------------------- | ------ | ---------------------------------------------- |
| `Layout`             | Server | Layout container (auto-wraps with LayoutHost)  |
| `Layout.Main`        | Client | Main content area with scrollbar support       |
| `Layout.LeftPanel`   | Client | Resizable left side panel                      |
| `Layout.RightPanel`  | Client | Resizable right side panel                     |

> **Note**: `LayoutHost` is an internal component, not exported from the public API. `Layout` automatically creates `LayoutHost` to wrap children; manual wrapping is not needed.
>
> **Deprecation Note**: `Scrollbar` is deprecated in 1.0.0. The `scrollbarProps` property is available for backward compatibility but uses native browser scrolling internally.

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

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/?path=/docs/layout-layout--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

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

### 場景推薦

| 使用場景 | 建議方案 | 說明 |
| ------- | ------- | ---- |
| 單欄佈局 | `<Layout.Main>` 只 | 簡單內容展示，無側邊欄 |
| 導航 + 主內容 | `<Layout.LeftPanel>` + `<Layout.Main>` | 左側導航，右側主要內容 |
| 主內容 + 詳情 | `<Layout.Main>` + `<Layout.RightPanel>` | 列表主頁面，右側顯示詳情 |
| 三欄佈局 | 全部子元件 | 完整儀表板佈局 |
| 響應式設計 | 條件渲染面板 | 根據螢幕大小動態顯示/隱藏側欄 |

### 常見錯誤

1. **手動包裝 LayoutHost**
   - ❌ 錯誤：`<LayoutHost><Layout>...</Layout></LayoutHost>`
   - ✅ 正確：直接使用 `<Layout>`，不需要手動包裝

2. **未設定面板寬度邊界**
   - ❌ 錯誤：允許面板縮小到不可用的大小
   - ✅ 正確：設定合理的 `defaultWidth` 並知道最小值是 240px

3. **子元件順序不當**
   - ❌ 錯誤：假設 JSX 順序會影響 DOM 順序
   - ✅ 正確：`Layout` 會自動重新排列，順序不重要

4. **未監聽面板寬度變化**
   - ❌ 錯誤：固定寬度，使用者拖曳後無法感知
   - ✅ 正確：使用 `onWidthChange` 回調更新狀態

5. **忘記管理面板 open 狀態**
   - ❌ 錯誤：`<Layout.RightPanel>`（面板無法關閉）
   - ✅ 正確：`<Layout.RightPanel open={isOpen}>`

### 實作建議

1. **無需手動包裝 LayoutHost**：`Layout` 內部自動建立 LayoutHost 上下文提供者，直接使用即可
2. **面板寬度**：`defaultWidth` 最小值 240px，預設 320px，可透過拖曳或方向鍵調整
3. **使用複合元件**：透過點號標記法使用 `Layout.Main`、`Layout.LeftPanel` 和 `Layout.RightPanel`，保持結構清晰
4. **獨立匯入也可用**：`LayoutMain`、`LayoutLeftPanel` 和 `LayoutRightPanel` 可直接從 `@mezzanine-ui/react` 匯入
5. **子元件順序靈活**：`Layout` 會自動重新排列，無論 JSX 中的寫入順序如何
