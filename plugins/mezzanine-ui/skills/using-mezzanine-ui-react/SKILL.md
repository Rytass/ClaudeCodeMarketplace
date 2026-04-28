---
name: using-mezzanine-ui-react
description: React / Next.js Mezzanine-UI skill — create, edit, or style JSX components with @mezzanine-ui/react (1.1.0). Covers Button, TextField, Select, Table, Modal, Form, DatePicker, Tabs, Navigation, Typography, Icon, Drawer, Upload, Toggle, design tokens, theming, and CalendarConfigProvider. Use when working on *.tsx, *.scss files with @mezzanine-ui/react imports, building React forms, or configuring Mezzanine styles in a React codebase. Trigger — React, Next.js, tsx, JSX, mezzanine-ui/react, add mezzanine component, build form, create page UI, design tokens, mzn. For Angular projects use the sibling using-mezzanine-ui-ng skill instead.
---

# Mezzanine-UI Design System

**Core principle: All frontend development MUST prefer the Mezzanine-UI design system.**

> Baseline: `@mezzanine-ui/*` `1.x` (react/core `1.1.0`, icons/system `1.0.2`). Last verified: 2026-04-24.
>
> Check latest version: `npm view @mezzanine-ui/react versions` or see [GitHub Releases](https://github.com/Mezzanine-UI/mezzanine/releases).

## Resource Overview

| Type               | Resource                                                         | Purpose                |
| ------------------ | ---------------------------------------------------------------- | ---------------------- |
| **Figma Components** | [Component File](https://www.figma.com/design/gjGdP49GQZzOeQf0bNOFlt) | Referenceable design components |
| **Figma Docs**     | [Documentation](https://www.figma.com/design/VgnrTeu6oOSE0giftMw1Oy) | Design specs & guidelines |
| **Frontend Package** | [GitHub](https://github.com/Mezzanine-UI/mezzanine)           | React component source |
| **Doc Site**       | [Storybook](https://storybook.mezzanine-ui.org)                 | Component examples & API |

---

## Quick Start

### Installation

```bash
yarn add @mezzanine-ui/core @mezzanine-ui/react @mezzanine-ui/system @mezzanine-ui/icons
```

### Style Setup

Create `main.scss`:

```scss
@use '~@mezzanine-ui/system' as mzn-system;
@use '~@mezzanine-ui/core' as mzn-core;

// Set design system variables
:root {
  @include mzn-system.palette-variables(light);
  @include mzn-system.common-variables(default);
}

// Dark mode
[data-theme='dark'] {
  @include mzn-system.palette-variables(dark);
}

// Compact mode
[data-density='compact'] {
  @include mzn-system.common-variables(compact);
}

// Load component styles
@include mzn-core.styles();
```

### Basic Usage

```tsx
import './main.scss';
import { Button, Typography } from '@mezzanine-ui/react';
import { PlusIcon } from '@mezzanine-ui/icons';

function App() {
  return (
    <div>
      <Typography variant="h1">Welcome to Mezzanine UI</Typography>
      <Button variant="base-primary" size="main">
        <PlusIcon />
        Click Me
      </Button>
    </div>
  );
}
```

### CalendarConfigProvider Setup (日期/時間元件必要)

使用任何日期或時間相關元件（DatePicker, DateRangePicker, DateTimePicker, DateTimeRangePicker, MultipleDatePicker, TimePicker, TimeRangePicker, Calendar, TimePanel）之前，**必須**在應用程式根層級包裹 `CalendarConfigProvider`，否則會拋出 runtime error: `Cannot find values in your context`.

```tsx
// layout.tsx 或 App.tsx
import { CalendarConfigProvider } from '@mezzanine-ui/react';
import { CalendarMethodsMoment } from '@mezzanine-ui/core/calendar';

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <CalendarConfigProvider methods={CalendarMethodsMoment}>
      {children}
    </CalendarConfigProvider>
  );
}
```

> 也可使用 `CalendarConfigProviderMoment` 或 `CalendarConfigProviderDayjs` 便捷封裝（從 `@mezzanine-ui/react/Calendar` 匯入）。

---

## What's New in 1.1.0

### 新增功能 (Improvements)

- **`Input` 的 `SelectButton` 子元件**（用於 `Input` 的 `select` variant，見 `packages/react/src/Input/SelectButton/`）新增 `closeOnSelect` prop（預設值 `true`）：選取選項後自動關閉下拉選單，符合單選 UX 預期。若需保持舊行為（選後不關閉），可在呼叫端傳入 `closeOnSelect={false}`。詳見 [Input.md](./references/components/Input.md#select-input)。

### 錯誤修正 (Bug Fixes)

- **`Table`** — 修正 SSR hydration mismatch 問題。列高原本在 `useMemo` 中透過 `getComputedStyle` 讀取，伺服器端回傳 `0`、客戶端回傳實際 pixel，導致 React 18/19 strict mode 下發出 hydration 警告甚至拋錯。現改為在 `useIsomorphicLayoutEffect` 中延遲讀取，首次 render 結果在 SSR 與 CSR 之間完全一致。Next.js / Remix 使用者建議升級。
- **Picker 家族鍵盤導覽** (`DatePicker`、`DateRangePicker`、`TimePicker`、`DateTimePicker`、`DateTimeRangePicker`、`TimeRangePicker`、`MultipleDatePicker`) — 修復 1.0.4 portal 遷移後 Tab / Shift+Tab 無法在觸發輸入框與日曆/時間面板之間循環的問題。Popper 現在建立明確的邏輯焦點迴圈，並在 `Modal` focus trap 內亦可正常運作。

### 元件移除 (Removed)

> 以下元件已從 `@mezzanine-ui/react` 公開 API 移除，請在升級前完成遷移：

| 元件            | 遷移指引                                                                    |
| --------------- | --------------------------------------------------------------------------- |
| `ClearActions`  | 無直接替代品，改以組合模式自行實作關閉按鈕                                  |
| `ContentHeader` | 改以 `PageHeader` + `Section` + 自訂元素組合取代                            |
| `Scrollbar`     | 改用原生滾動或 CSS 自訂捲軸樣式                                             |
| `Switch`        | 已由 `Toggle` 正式取代，所有用法請直接改用 `<Toggle>`                       |

**相依套件要求**：`@mezzanine-ui/core` ≥ 1.0.4、`@mezzanine-ui/system` ≥ 1.0.2、`@mezzanine-ui/icons` ≥ 1.0.2

---

<details>
<summary>Previous: What's New in 1.0.4 / Patch Releases (1.0.1 – 1.0.3)</summary>

## Patch Releases (1.0.1 – 1.0.3)

> **No public API changes** in this range — existing usage does not need to be modified. Upgrade is a straightforward `yarn upgrade @mezzanine-ui/*`.

### `@mezzanine-ui/react` 1.0.4 (2026-04-22)

- **Fix** — Picker 家族（DatePicker、DateRangePicker、TimePicker、DateTimePicker、DateTimeRangePicker、TimeRangePicker、MultipleDatePicker）在 Modal 或視窗底部附近渲染時，下拉 popup 不再被裁切。`InputTriggerPopper` 預設改為 portal 模式（`z-index: 1005` 高於 `Modal: 1004`）。同時啟用 Floating UI 的 `flip` middleware，面板會在空間不足時自動翻轉方向。

### `@mezzanine-ui/react` 1.0.3 (2026-04-21)

- **Chore** — bump `@mezzanine-ui/core` dependency to `1.0.3`.

### `@mezzanine-ui/react` 1.0.2 (2026-04-17)

- **Fix** — `Badge`: correct `utils` import path to use a relative path. Internal only; no surface change.

### `@mezzanine-ui/react` 1.0.1 (2026-04-14)

- **Fix** — `Notifier`: lazy-init `createRoot` to fix React 19 event delegation. Required if the host app is on React 19 — previously `Notifier` toast handlers could silently fail to fire. No API change.

### `@mezzanine-ui/core` 1.0.3 (2026-04-21)

- **Feat** — `core/calendar`: separate ISO and locale week-year format tokens. Internal formatting utility; does **not** change Calendar / DatePicker React props. Only relevant if you consume `@mezzanine-ui/core/calendar` week-year format helpers directly.

### `@mezzanine-ui/icons` 1.0.2 · `@mezzanine-ui/system` 1.0.2 (2026-04-17)

- Monorepo-sync version bump only. No code change.

</details>

---

## What's New in 1.0.0

1.0.0 是 Mezzanine-UI 的**第一個正式穩定版本**。主要變更如下：

### 元件移除（Breaking Changes）

4 個元件從公開 API 中移除，不再從 `@mezzanine-ui/react` 主入口匯出：

- **ClearActions** — 無直接替代品，改用組合模式自行實作關閉按鈕
- **ContentHeader** — 無直接替代品，改以 `PageHeader` + `Section` + utility components 組合取代
- **Scrollbar** — 無直接替代品，改用原生滾動或 CSS 自訂捲軸樣式
- **Switch** — 已正式由 `Toggle` 取代，所有 Switch 用法請直接改用 Toggle

> 若專案中有使用上述元件，請在升級前完成遷移。詳見各元件 `.md` 的遷移說明。

### API 重構

- **Drawer** — 移除內建底部操作按鈕與篩選區域，改採明確的組合模式：`DrawerHeader` / `DrawerBody` / `DrawerFooter`
- **Dropdown** — API 簡化，移除直接傳入 `options` / `onSelect` 的模式，改為 slot-based 組合
- **Calendar** — 移除直接的 `mode` / `value` / `onChange` props，改為 `calendarDaysProps` / `calendarMonthsProps` 結構

### 功能增強

- **Toggle** — 正式取代 Switch，提供更簡潔一致的 API
- **Upload** — 移除內建錯誤與刪除 handler，新增 `dropzoneHints` prop 供自訂提示
- **Typography** — 新增 `align`、`color`、`display`、`ellipsis`、`noWrap`、`variant` props，排版控制更完整
- **Popper** — 新增 `arrow`、`className`、`enabled`、`padding` props，定位控制更靈活

---

## Breaking Changes in 1.0.0

- **4 個元件移除**：ClearActions、ContentHeader、Scrollbar、Switch
  - ClearActions: 無直接替代品，改用組合模式
  - ContentHeader: 無直接替代品，改用 PageHeader + Section + utility components
  - Scrollbar: 無直接替代品，改用原生滾動或 CSS 樣式
  - Switch: 已由 Toggle 取代，直接改用 Toggle
- **Toggle** 取代 Switch — 全新元件，提供更簡潔的 API
- **Drawer** 簡化 — 移除內建底部操作按鈕與篩選區域，改採組合模式（DrawerHeader / DrawerBody / DrawerFooter）
- **Dropdown** 重構 — 簡化 API，移除直接傳入 options / onSelect 的模式
- **Calendar** 重構 — 移除直接的 mode / value / onChange，改為 calendarDaysProps / calendarMonthsProps
- **Upload** 簡化 — 移除內建錯誤與刪除 handler，新增 dropzoneHints
- **Typography** 增強 — 新增 align、color、display、ellipsis、noWrap、variant props
- **Popper** 增強 — 新增 arrow、className、enabled、padding props

---

## Storybook — 權威互動參考

所有元件皆可在 [Storybook](https://storybook.mezzanine-ui.org) 中查看互動範例。當文件描述與實際行為不一致時，以 Storybook 的互動範例為準。

每個元件的參考文件都包含直接的 Storybook 連結，格式為：
`https://storybook.mezzanine-ui.org/?path=/docs/{kebab-category}-{kebab-component}--docs`

> **Best Practice**: 在實作前先查看 Storybook 的 Controls panel，了解各 prop 的實際效果和預設值。

---

## Package Architecture

| Package                 | Description                          |
| ----------------------- | ------------------------------------ |
| `@mezzanine-ui/system`  | Design tokens (colors, spacing, fonts, etc.) |
| `@mezzanine-ui/core`    | CSS styles and class definitions     |
| `@mezzanine-ui/react`   | React components                     |
| `@mezzanine-ui/icons`   | Icon library                         |

---

## Children Validation Pitfalls (重要 — 容易踩雷)

部分容器元件會在 **runtime** 用 `Children.map` / `isValidElement` / `child.type === X` 對 `children` 做型別檢查，**只渲染白名單內的子元件**。傳入其他 JSX（自訂元件、`<div>` 包裝、Fragment 內亂塞、錯誤的 Button variant 等）時，雖然 React 樹中還在，**畫面會直接消失**，且部分元件靜默無提示。

> 任何時候 ContentHeader / PageHeader / Tab / Layout / Navigation / Accordion 等容器「JSX 寫了但畫面不顯示」，**第一個檢查點就是 children 是否在白名單內**。`<></>` Fragment 不會被解開、`<div>` 不會被穿透。

### 過濾規則一覽

| 元件 | 接受的 children | 被丟棄的 children | 失敗模式 |
| --- | --- | --- | --- |
| `ContentHeader` | `<a>` / 帶 `href` 元素（返回鈕）、`Input variant="search"`、`Select`、`Toggle`、`Checkbox`、`Button`（**限 `base-primary` / `base-secondary` / `destructive-secondary` / undefined**）、icon-only `Button` 包進 `Dropdown` | 一般 `<div>`、`Typography`、自訂 wrapper、其他 variant 的 `Button`、無 icon 的 `Button` 包進 `Dropdown`、`SegmentedControl` | console.warn + 不渲染 |
| `PageHeader` | 至多一個 `Breadcrumb` + 必要一個 `ContentHeader`（強制 `size="main"`） | 任何其他元件、重複的 `Breadcrumb` / `ContentHeader` | console.warn + 不渲染 |
| `Section` (props) | `contentHeader` 必為 `<ContentHeader>`、`filterArea` 必為 `<FilterArea>`、`tab` 必為 `<Tab>` | 其他元件型別 | console.warn + 不渲染 |
| `Tab` | 只接受 `<TabItem>` | 任何其他元件、`<div>` 包裝、Fragment 中夾雜的非 TabItem | **靜默丟棄（無 warning）** |
| `Layout` | 只接受 `<Layout.Main>`、`<Layout.LeftPanel>`、`<Layout.RightPanel>`、`<Navigation>` | 自訂 `<div>` wrapper、其他元件 | **靜默丟棄（無 warning）** |
| `Navigation` | `NavigationHeader`、`NavigationFooter`、`NavigationOptionCategory`、`NavigationOption` | 原生 `<a>` / `<li>`、自訂導覽元件 | console.warn + 不渲染 |
| `NavigationOption` | 子層只接受 `NavigationOption`（巢狀）或 `Badge` | 其他元件 | 不渲染 |
| `NavigationOptionCategory` | 只接受 `NavigationOption` | 其他元件 | 不渲染 |
| `Accordion` | 一個 `AccordionTitle` + 一個 `AccordionContent`（其餘原始節點會自動包成 `AccordionContent`） | 重複的 `AccordionTitle` / `AccordionContent` | console.warn + 丟棄重複者 |
| `AccordionActions` | 只接受 `Button` / `Dropdown` | 其他元件 | 不渲染 |

### Tab 與 Layout 的靜默失敗（高風險）

`Tab` 與 `Layout` **不會在 console 顯示警告**。常見錯誤：

```tsx
// ❌ 包一層 div — 整個 TabItem 都不會渲染（無 warning）
<Tab>
  <div className={styles.wrapper}>
    <TabItem key="a">A</TabItem>
    <TabItem key="b">B</TabItem>
  </div>
</Tab>

// ❌ 條件渲染包了 Fragment 又混入文字 — 字串會被 drop
<Tab>
  <>
    <TabItem key="a">A</TabItem>
    {showB && '部分使用者可見'}  {/* 靜默掉 */}
  </>
</Tab>

// ✅ 直接放 TabItem，使用陣列 / 條件渲染
<Tab>
  <TabItem key="a">A</TabItem>
  {showB && <TabItem key="b">B</TabItem>}
</Tab>
```

```tsx
// ❌ Layout 自訂 wrapper — 內容不顯示
<Layout>
  <div className={styles.shell}>
    <Layout.LeftPanel>...</Layout.LeftPanel>
    <Layout.Main>...</Layout.Main>
  </div>
</Layout>

// ✅ Slot 必須是 Layout 直接子代
<Layout>
  <Layout.LeftPanel>...</Layout.LeftPanel>
  <Layout.Main>...</Layout.Main>
</Layout>
```

### ContentHeader Button variant 限制

`ContentHeader` 在 `getActions` 階段只保留三種 variant，其餘 variant **不渲染**：

```tsx
// ❌ variant="text" 不在白名單，按鈕不出現
<ContentHeader title="X">
  <Button variant="text">Cancel</Button>
  <Button>Save</Button>
</ContentHeader>

// ✅
<ContentHeader title="X">
  <Button variant="base-secondary">Cancel</Button>
  <Button>Save</Button>
</ContentHeader>
```

排序後固定為：`destructive-secondary` → `base-secondary` → `base-primary` / undefined。

### 不會過濾 children 的元件（permissive）

下列元件 **不在 runtime 檢查 children 型別**，TypeScript 型別只是 hint，實際塞任何 JSX 都會渲染（但仍須遵守 prop 對的物件 shape）：

`Stepper`、`Breadcrumb`、`ButtonGroup`、`FormField`、`FormGroup`、`SectionGroup`、`PageFooter`、`Drawer`、`Modal`、`Description`、`DescriptionContent`、`Dropdown`、`Table`、`FilterArea` / `FilterLine` / `Filter`。

> 即使這些元件不會 runtime 過濾，仍**強烈建議**遵守 TypeScript 型別。`Description` 的「supported children types」（DescriptionContent / Badge / Button / Progress / TagGroup）是設計建議，視覺與排版只在這些元件下被測試過。

### 排查流程

1. JSX 結構正確但畫面缺塊 → 檢查上方表格內元件的 children 是否合法
2. `Tab` / `Layout` 整塊消失而 console 無錯 → 是靜默過濾，移除中間 wrapper
3. `ContentHeader` 按鈕沒出現但別處出現 → 確認 `variant` 在白名單
4. `PageHeader` / `Navigation` console 出現 `Invalid ... type` warning → 該位置應替換為合法元件

詳細個別 API 與例外請見 [references/components/](references/components/) 內各元件文件中「Accepted children types」/「Children Validation」章節。

---

## Component Categories

> Categories below are based on `packages/react/src/index.ts` exports. See individual component reference files for detailed API.

### General

Foundational visual elements that serve as building blocks for other components.

| Component     | Description    | Reference                                            |
| ------------- | -------------- | ---------------------------------------------------- |
| `Button`      | Button         | [Button.md](references/components/Button.md)         |
| `ButtonGroup` | Button group   | [Button.md](references/components/Button.md)         |
| `Cropper`     | Crop tool      | [Cropper.md](references/components/Cropper.md)       |
| `Icon`        | Icon           | [Icon.md](references/components/Icon.md)             |
| `Separator`   | Divider line   | [Separator.md](references/components/Separator.md)   |
| `Typography`  | Typography     | [Typography.md](references/components/Typography.md) |

### Navigation

Components for navigating between and within pages.

| Component    | Description     | Reference                                            |
| ------------ | --------------- | ---------------------------------------------------- |
| `Breadcrumb` | Breadcrumb      | [Breadcrumb.md](references/components/Breadcrumb.md) |
| `Drawer`     | Drawer          | [Drawer.md](references/components/Drawer.md)         |
| `Navigation` | Side navigation | [Navigation.md](references/components/Navigation.md) |
| `PageFooter` | Page footer     | [PageFooter.md](references/components/PageFooter.md) |
| `PageHeader` | Page header     | [PageHeader.md](references/components/PageHeader.md) |
| `Stepper`    | Step indicator  | [Stepper.md](references/components/Stepper.md)       |
| `Tab`        | Tab             | [Tab.md](references/components/Tab.md)               |

### Data Display

Data presentation and visualization components.

| Component           | Description       | Reference                                                      |
| ------------------- | ----------------- | -------------------------------------------------------------- |
| `Accordion`         | Accordion         | [Accordion.md](references/components/Accordion.md)             |
| `Badge`             | Badge             | [Badge.md](references/components/Badge.md)                     |
| `Card`              | Card              | [Card.md](references/components/Card.md)                       |
| `Description`       | Description list  | [Description.md](references/components/Description.md)         |
| `Empty`             | Empty state       | [Empty.md](references/components/Empty.md)                     |
| `OverflowTooltip`   | Overflow tooltip  | [OverflowTooltip.md](references/components/OverflowTooltip.md) |
| `OverflowCounterTag`| Overflow counter  | [OverflowTooltip.md](references/components/OverflowTooltip.md) |
| `Pagination`        | Pagination        | [Pagination.md](references/components/Pagination.md)           |
| `Section`           | Section           | [Section.md](references/components/Section.md)                 |
| `SectionGroup`      | Section group     | [Section.md](references/components/Section.md)                 |
| `Table`             | Table             | [Table.md](references/components/Table.md)                     |
| `Tag`               | Tag               | [Tag.md](references/components/Tag.md)                         |
| `Tooltip`           | Tooltip           | [Tooltip.md](references/components/Tooltip.md)                 |

### Data Entry

Form and user input components.

| Component             | Description          | Reference                                                              |
| --------------------- | -------------------- | ---------------------------------------------------------------------- |
| `AutoComplete`        | Autocomplete         | [AutoComplete.md](references/components/AutoComplete.md)               |
| `Cascader`            | Cascader             | [Cascader.md](references/components/Cascader.md)                       |
| `Checkbox`            | Checkbox             | [Checkbox.md](references/components/Checkbox.md)                       |
| `DatePicker`          | Date picker          | [DatePicker.md](references/components/DatePicker.md)                   |
| `DateRangePicker`     | Date range picker    | [DateRangePicker.md](references/components/DateRangePicker.md)         |
| `DateTimePicker`      | Date time picker     | [DateTimePicker.md](references/components/DateTimePicker.md)           |
| `DateTimeRangePicker` | Date time range      | [DateTimeRangePicker.md](references/components/DateTimeRangePicker.md) |
| `FilterArea`          | Filter area          | [FilterArea.md](references/components/FilterArea.md)                   |
| `Form`                | Form                 | [Form.md](references/components/Form.md)                               |
| `FormGroup` *(sub-path only)* | Form field group | [Form.md](references/components/Form.md)                           |
| `Input`               | Input                | [Input.md](references/components/Input.md)                             |
| `MultipleDatePicker`  | Multiple date picker | [MultipleDatePicker.md](references/components/MultipleDatePicker.md)   |
| `Picker`              | Picker base          | [Picker.md](references/components/Picker.md)                           |
| `Radio`               | Radio button         | [Radio.md](references/components/Radio.md)                             |
| `Select`              | Select dropdown      | [Select.md](references/components/Select.md)                           |
| `SelectionCard`       | Selection card       | [SelectionCard.md](references/components/SelectionCard.md)             |
| `Slider`              | Slider               | [Slider.md](references/components/Slider.md)                           |
| `Switch` *(已廢棄 v1.1.0)* | Switch toggle — 請改用 Toggle | [Switch.md](references/components/Switch.md)               |
| `Textarea`            | Textarea             | [Textarea.md](references/components/Textarea.md)                       |
| `TextField`           | Text field           | [TextField.md](references/components/TextField.md)                     |
| `TimePicker`          | Time picker          | [TimePicker.md](references/components/TimePicker.md)                   |
| `TimeRangePicker`     | Time range picker    | [TimeRangePicker.md](references/components/TimeRangePicker.md)         |
| `Toggle`              | Toggle (取代 Switch) | [Toggle.md](references/components/Toggle.md)                           |
| `Upload`              | Upload               | [Upload.md](references/components/Upload.md)                           |

### Feedback

User action feedback and system status display.

| Component            | Description          | Reference                                                            |
| -------------------- | -------------------- | -------------------------------------------------------------------- |
| `InlineMessage`      | Inline message       | [InlineMessage.md](references/components/InlineMessage.md)           |
| `Message`            | Message toast        | [Message.md](references/components/Message.md)                       |
| `Modal`              | Modal dialog         | [Modal.md](references/components/Modal.md)                           |
| `NotificationCenter` | Notification center  | [NotificationCenter.md](references/components/NotificationCenter.md) |
| `Progress`           | Progress bar         | [Progress.md](references/components/Progress.md)                     |
| `ResultState`        | Result state         | [ResultState.md](references/components/ResultState.md)               |
| `Skeleton`           | Skeleton loader      | [Skeleton.md](references/components/Skeleton.md)                     |
| `Spin`               | Loading spinner      | [Spin.md](references/components/Spin.md)                             |

### Layout

Full-page layout components.

| Component | Description                | Reference                                          |
| --------- | -------------------------- | -------------------------------------------------- |
| `Layout`  | Full-page layout + sidebar | [Layout.md](references/components/Layout.md)       |

### Others

Auxiliary components.

| Component        | Description       | Reference                                                    |
| ---------------- | ----------------- | ------------------------------------------------------------ |
| `AlertBanner`    | Alert banner      | [AlertBanner.md](references/components/AlertBanner.md)       |
| `Anchor`         | Anchor navigation | [Anchor.md](references/components/Anchor.md)                 |
| `Backdrop`       | Backdrop overlay  | [Backdrop.md](references/components/Backdrop.md)             |
| `FloatingButton` | Floating button   | [FloatingButton.md](references/components/FloatingButton.md) |

### Utility

Utility components and transition animations.

| Component    | Description          | Reference                                            |
| ------------ | -------------------- | ---------------------------------------------------- |
| `Calendar`   | Calendar             | [Calendar.md](references/components/Calendar.md)     |
| `Collapse`   | Collapse animation   | [Transition.md](references/components/Transition.md) |
| `Fade`       | Fade animation       | [Transition.md](references/components/Transition.md) |
| `Notifier`   | Notifier             | [Notifier.md](references/components/Notifier.md)     |
| `Popper`     | Popper positioning   | [Popper.md](references/components/Popper.md)         |
| `Portal`     | Portal               | [Portal.md](references/components/Portal.md)         |
| `Rotate`     | Rotate animation     | [Transition.md](references/components/Transition.md) |
| `Scale`      | Scale animation      | [Transition.md](references/components/Transition.md) |
| `Slide`      | Slide animation      | [Transition.md](references/components/Transition.md) |
| `TimePanel`  | Time panel           | [TimePanel.md](references/components/TimePanel.md)   |
| `Transition` | Transition base      | [Transition.md](references/components/Transition.md) |
| `Translate`  | Translate animation  | [Transition.md](references/components/Transition.md) |

### Internal

Internal components, not typically used directly but available for advanced customization.

| Component                         | Description                          | Export                | Reference                                                    |
| --------------------------------- | ------------------------------------ | --------------------- | ------------------------------------------------------------ |
| `ClearActions` *(已廢棄 v1.1.0)* | Clear/close button                   | sub-path only         | [ClearActions.md](references/components/ClearActions.md)     |
| `ContentHeader` *(已廢棄 v1.1.0)*| Content section header               | sub-path only         | [ContentHeader.md](references/components/ContentHeader.md)   |
| `Dropdown`                        | Dropdown container (API 已重構)      | `@mezzanine-ui/react` | [Dropdown.md](references/components/Dropdown.md)             |
| `Scrollbar` *(已廢棄 v1.1.0)*    | Custom scrollbar                     | sub-path only         | [Scrollbar.md](references/components/Scrollbar.md)           |

---

## Design Token System

Mezzanine-UI uses a **Primitives + Semantic** two-layer architecture.

See [references/DESIGN_TOKENS.md](references/DESIGN_TOKENS.md) for detailed design tokens.

### Quick Reference

**Color usage**:
```scss
color: var(--mzn-color-text-brand);
background-color: var(--mzn-color-background-base);
border-color: var(--mzn-color-border-neutral);
```

**Spacing usage**:
```scss
padding: var(--mzn-spacing-padding-horizontal-base);
gap: var(--mzn-spacing-gap-base);
```

---

## Icon Usage

Icons are organized in `@mezzanine-ui/icons`.

See [references/ICONS.md](references/ICONS.md) for the complete icon list.

### Quick Example

```tsx
import { Icon } from '@mezzanine-ui/react';
import { PlusIcon, SearchIcon } from '@mezzanine-ui/icons';

<Icon icon={PlusIcon} />
<Icon icon={SearchIcon} size={24} />
```

---

## Theme Switching

### Light/Dark Mode

```tsx
// Switch theme
document.documentElement.setAttribute('data-theme', 'dark');
```

### Default/Compact Density

```tsx
// Switch density
document.documentElement.setAttribute('data-density', 'compact');
```

---

## Related Documentation

| Document                                    | Description                    |
| ------------------------------------------- | ------------------------------ |
| [references/DESIGN_TOKENS.md](references/DESIGN_TOKENS.md)   | Detailed design token definitions |
| [references/ICONS.md](references/ICONS.md)                   | Complete icon list             |
| [references/PATTERNS.md](references/PATTERNS.md)             | Common usage pattern examples  |
| [references/FIGMA_MAPPING.md](references/FIGMA_MAPPING.md)   | Figma node mapping table       |
| [references/components/](references/components/)             | Detailed API docs per component |

---

## Maintenance

### Version Sync Command

When Mezzanine-UI releases a new version, use the `/sync-mezzanine-ui` command to refresh all skill content:

```
/sync-mezzanine-ui 1.1.0
```

This orchestrates a team of agents to:
1. Fetch TypeScript interfaces from the GitHub source code
2. Update component `.md` files to match real props/types
3. Refresh cache JSON files
4. Update this SKILL.md with the new version info

See also: `scripts/upgrade-version.sh` (analysis script), `scripts/figma-sync.sh` (Figma metadata sync)
