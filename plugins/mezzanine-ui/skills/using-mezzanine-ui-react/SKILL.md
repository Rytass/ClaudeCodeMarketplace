---
name: using-mezzanine-ui-react
description: React and Next.js guidance for @mezzanine-ui/react 1.10.2. Use when building Mezzanine forms, tables, filters, navigation, overlays, admin list or detail pages, page layouts and spacing, or choosing components and design tokens in JSX or TSX — including Section composition, 版面對不齊, 間距不一致, 列表頁, 篩選列, 該用哪個元件. For Angular use using-mezzanine-ui-ng.
---

# Mezzanine-UI Design System

**Core principle: All frontend development MUST prefer the Mezzanine-UI design system.**

> Baseline: `@mezzanine-ui/react` `1.10.2` · 需要 `@mezzanine-ui/core` ≥ `1.3.3` · `@mezzanine-ui/system` / `@mezzanine-ui/icons` ≥ `1.0.2` · `react` / `react-dom` ≥ `19`。
> 元件文件的 `Verified` 標記：以各 `references/components/*.md` 內的 Verified 行為準（本次同步目標 `1.10.2`）。`Switch.md` 刻意不標 `Verified` —— 該元件已不存在於原始碼（真正的開關元件是 `Toggle`）。
> 名稱／型別／預設值對原始碼的比對狀態見 [RECONCILIATION.md](../../RECONCILIATION.md)（尚有未分類的殘差）。
>
> **Last verified**: 2026-11-22
>
> Check latest version: `npm view @mezzanine-ui/react versions` or see [GitHub Releases](https://github.com/Mezzanine-UI/mezzanine/releases).

## 動手前 30 秒（選錯元件的成本比選慢高得多）

**寫下第一行 JSX 之前**，先用「UI 概念」反查元件名 → [§元件選用](#元件選用必讀--先用ui-概念反查元件名)。
Mezzanine 的元件名反映實作結構，照別的設計系統去猜會系統性選錯，而且**錯法看起來很合理**。

兩個最常錯、且已在真實專案出包的：

| 設計稿長這樣 | 正解 | 錯法（實際發生過） |
| ------------ | ---- | ------------------ |
| 表格裡的狀態欄，多種顏色 | `<Badge variant="dot-success" text="啟用" />` | `Tag` / `Badge variant="text-*"` 再補 `className` 上底色 |
| 兩顆連在一起、選中的較深 | `<RadioGroup type="segment">` + `<Radio type="segment">` | 兩顆 `Button` 換 `variant` 假裝選中（`ButtonGroup` 也一樣錯） |

**設計稿要求的效果，元件零覆寫做不到時 —— 停下來回報，不要自己補樣式。**
把「用 design token 寫覆寫」當成合規的變通是**錯的**：token 只能用在你自己的版面元素上，
不能拿來改元件外觀（完整規則見〈三條鐵則〉第 3 條）。這種情況的正確產出是：
**先給零覆寫可交付的版本，再用一句話說明差在哪、需要設計確認**，例如

> 目前用 `Badge variant="dot-*" text` 實作，狀態色與文字都到位；設計稿上那層**填色膠囊底**
> 在 Mezzanine 的 Badge 上零覆寫做不出來（`dot-*` / `text-*` 沒有背景色，`count-*` 只吃數字），
> 需要設計確認要改用圓點樣式，還是另外立一個新元件需求。

## Resource Overview

| Type               | Resource                                                         | Purpose                |
| ------------------ | ---------------------------------------------------------------- | ---------------------- |
| **Figma Components** | [Component File](https://www.figma.com/design/gjGdP49GQZzOeQf0bNOFlt) | Referenceable design components |
| **Figma Docs**     | [Documentation](https://www.figma.com/design/VgnrTeu6oOSE0giftMw1Oy) | Design specs & guidelines |
| **Frontend Package** | [GitHub](https://github.com/Mezzanine-UI/mezzanine)           | React component source |
| **Doc Site**       | [Storybook (React)](https://storybook.mezzanine-ui.org/react/)  | Component examples & API |

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
import { Button, Icon, Typography } from '@mezzanine-ui/react';
import { PlusIcon } from '@mezzanine-ui/icons';

function App() {
  return (
    <div>
      <Typography variant="h1">Welcome to Mezzanine UI</Typography>
      <Button variant="base-primary" size="main">
        <Icon icon={PlusIcon} />
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
import CalendarMethodsMoment from '@mezzanine-ui/core/calendarMethodsMoment';

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

## Page Layout Skeleton (必讀 — 版面 padding 契約)

**建立任何頁面之前先讀這段。** Mezzanine 的頁面級元件**自己內建 padding**，而這些 padding 只寫在 `@mezzanine-ui/core` 的 SCSS 裡，**從 React props / TypeScript 型別完全看不出來**。若照一般開發慣例「先給 page container 一圈 padding 再放元件」，`PageHeader` 會出現**兩層水平 padding**（外層 + 內建），標題與下方內容左緣錯開。

### A. 滿版帶狀元件 — 自帶 gutter，必須是 page container 的直接子代

以下元件**沒有卡片底色**，它們的水平 padding 就是版面 gutter 本身。放進任何有 `padding-inline` 的 wrapper 都會多縮一次；`Tab` / `PageFooter` 的橫線也會斷在兩側。（數值皆核對自 `@mezzanine-ui/core` 原始 SCSS。）

| 元件         | 生效條件                                | host padding                                                             | default       | compact       | 備註                                              |
| ------------ | --------------------------------------- | ------------------------------------------------------------------------ | ------------- | ------------- | ------------------------------------------------- |
| `PageHeader` | 無條件                                  | `vertical-spacious horizontal-spacious 0`                                | `16 / 16 / 0` | `12 / 14 / 0` | **bottom 為 0**，區塊間距靠 container `row-gap`   |
| `PageFooter` | 無條件                                  | `vertical-base horizontal-spacious`                                      | `8 / 16`      | `4 / 14`      | 另有 `border-top` 與底色，必須整條貼齊版面        |
| `FilterArea` | `size="main"`（**預設值**）             | `padding-inline: horizontal-spacious` + `padding-top: vertical-spacious` | `16 / top 16` | `14 / top 12` | 與 PageHeader 同構，同樣沒有 bottom padding       |
| `Tab`        | `size="main"`（**預設值**）+ horizontal | `vertical-spacious horizontal-spacious 0`                                | `16 / 16 / 0` | `12 / 14 / 0` | 底線 `::before` 為 `inset: 0`，需滿版才不會被截斷 |
| `Tab`        | `size="main"` + vertical                | `0 0 0 horizontal-spacious`                                              | `left 16`     | `left 14`     | 只有左側                                          |

> **`size="main"` vs `size="sub"` 是判斷關鍵**：`main` = 直接放在頁面骨架、自帶 gutter；`sub` = 放在 `Section` 內、**沒有**外距（由 Section 的 padding 負責）。`Section` 會自動把傳入 `contentHeader` / `filterArea` 改寫成 `size="sub"`，並用 `> .mzn-tab--horizontal.mzn-tab--main { padding: 0 }` 把 main size 的 Tab padding 歸零。**`FilterArea` 與 `Tab` 的預設值都是 `main`** — 放進 body wrapper 卻忘了改 `size="sub"`，就會出現 16 + 16 = 32px 的雙層內縮。

### B. 卡片／內容元件 — 放進 body wrapper，由 wrapper 提供 gutter

| 元件                     | host padding                            | default   | compact   | 備註                                                       |
| ------------------------ | --------------------------------------- | --------- | --------- | ---------------------------------------------------------- |
| `Section`                | `vertical-spacious horizontal-spacious` | `16 / 16` | `12 / 14` | 有底色圓角但**無 margin**，外側 gutter 仍要靠 wrapper 提供 |
| `Table`                  | 無（padding 在 `th` / `td` 儲存格上）   | —         | —         | host `<table>` 本身沒有 padding                            |
| `Layout` / `Layout.Main` | 無                                      | —         | —         | app shell，完全不提供 padding                              |
| `ContentHeader`          | 無（只有 `gap: calm`）                  | —         | —         | 內距全由外層 `PageHeader` / `Section` 提供                 |

### C. 其他自帶 padding 的元件（與版面 gutter 無關，但同樣不要再包一層）

`Pagination` `8/12`、`AlertBanner` `block 12 / inline 24`、`NotificationCenter` `16/16`、`Upload` dropzone `24/24`、`Message` `12/16`、`Tooltip` `4/8`、`TimePanel`、`Card`、`Cascader`、`SelectionCard`、`Calendar` 各自有 host padding。這些是元件自身的內距，不需要也不應該再外加 padding，但它們不負責頁面 gutter。

### 四條規則

1. **頁面最外層 container 不可有水平 padding**（`padding` / `padding-inline` / `padding-left|right` 一律不要）— 讓 A 組元件自己貼齊版面邊緣。
2. **A 組元件直接掛在最外層 column**，不要塞進有 padding 的 wrapper 內。若非得放在 body wrapper 內（例如 filter 屬於某個 Section 的一部分），改用 `size="sub"`。
3. **B 組內容一律另包一層 main content wrapper**，套上與 PageHeader 相同的水平 padding：`padding-inline: var(--mzn-spacing-padding-horizontal-spacious)`。這樣表格 / 卡片 / 表單的左緣才會對齊 PageHeader 的標題文字。
4. **垂直間距用 container 的 `row-gap`**（建議 `var(--mzn-spacing-gap-calm)`，12px / compact 10px），不要對 `PageHeader` 補 `margin-bottom` — 它的 bottom padding 就是刻意留 0 給 container 分配。

```
+-------------------------------------------+   <- page container: 無水平 padding
| PageHeader  (padding: 16 16 0)            |
|       Breadcrumb / Title                  |   <- 標題文字內縮 16px
+-------------------------------------------+
| Tab size="main"  (padding: 16 16 0)       |   <- A 組：貼邊，底線才會滿版
+-------------------------------------------+
        row-gap: var(--mzn-spacing-gap-calm)
+-------------------------------------------+
| body wrapper (padding-inline: 16)         |
|     +-------------------------------+     |
|     | Section / Table / Form        |     |
|     +-------------------------------+     |   <- 卡片左緣同樣內縮 16px
+-------------------------------------------+
| PageFooter  (padding: 8 16)               |   <- border-top 需滿版
+-------------------------------------------+
```

### Canonical page skeleton（每個頁面都照這個結構寫）

Mezzanine **沒有**提供負責頁面 gutter 的容器元件 — `Layout` / `Layout.Main` 是 app shell（Navigation + 面板），內部只有 flex / min-width / overflow，**零 padding、也沒有任何 padding 相關 prop**。所以 gutter 一定要由頁面自己處理，結構固定為三層：

```tsx
// ContentHeader 從未在主入口匯出（sub-path only，見 [CHANGELOG_NOTES.md](references/CHANGELOG_NOTES.md)〈元件移除／未匯出狀況〉），但 PageHeader 仍要求它作為必要子元件 → sub-path 匯入
import { PageHeader, PageFooter, Breadcrumb, Button, Table } from '@mezzanine-ui/react';
import ContentHeader from '@mezzanine-ui/react/ContentHeader';
import styles from './page.module.scss';

export default function ProductListPage(): JSX.Element {
  return (
    // 第 1 層：page container — 無水平 padding，只負責垂直排列與 row-gap
    <div className={styles.page}>
      {/* 第 2 層 a：PageHeader 直接掛在 page container 底下，貼齊版面 */}
      <PageHeader>
        <Breadcrumb items={[{ name: 'Home', href: '/' }, { name: 'Products' }]} />
        <ContentHeader title="Product Management" description="管理所有商品">
          <Button>Add Product</Button>
        </ContentHeader>
      </PageHeader>

      {/* 第 2 層 b：主要內容包一層 body wrapper，這裡才套水平 padding */}
      <main className={styles.body}>
        <Table columns={columns} dataSource={data} />
      </main>

      {/* 第 2 層 c：PageFooter 與 PageHeader 同層，border-top 才會滿版 */}
      <PageFooter actions={{ primaryButton: { children: 'Save' } }} />
    </div>
  );
}
```

```scss
// page.module.scss
.page {
  display: flex;
  flex-direction: column;
  // ❌ 這裡永遠不加 padding-inline / padding-left / padding-right
  row-gap: var(--mzn-spacing-gap-calm);
  width: 100%;
  min-height: 100%;
}

.body {
  // ✅ 頁面裡唯一負責水平 gutter 的地方，值必須與 PageHeader 的水平 padding 相同
  padding-inline: var(--mzn-spacing-padding-horizontal-spacious);
  padding-block-end: var(--mzn-spacing-padding-vertical-spacious);
  display: flex;
  flex-direction: column;
  row-gap: var(--mzn-spacing-gap-calm);
  flex: 1;
  min-height: 0;
}
```

逐層說明：

- **`.page`（第 1 層）** — 只做「由上而下排列 + 區塊間距」。它**不能**有任何水平 padding，因為 `PageHeader` / `PageFooter` 自己已經有了；在這裡加就是雙層內縮的來源。`row-gap` 取代 `margin`，因為 `PageHeader` 的 `padding-bottom` 是 `0`，間距刻意留給 container 分配。
- **`PageHeader` / `PageFooter`（第 2 層，直接子代）** — 必須是 `.page` 的直接子代。只要被任何有 `padding-inline` 的 wrapper 包住，header 會多縮一次、footer 的 `border-top` 與底色也會斷在兩側。
- **`.body`（第 2 層）** — 唯一補 gutter 的地方，`padding-inline` 一律用 `--mzn-spacing-padding-horizontal-spacious`，與 `PageHeader` 同值，這樣表格 / 卡片 / 表單左緣才會對齊標題文字。`padding-block-end` 給頁尾內容留呼吸空間。內容之間的間距同樣用 `row-gap`，不要在子元素上加 `margin`。
- **內容是 `Section` 時** — 要分清楚兩層 padding：**外側 gutter 仍由 `.body` 的 `padding-inline` 提供**（`Section` 是 `.body` 的子元素，少了它卡片會貼齊版面邊緣、也不會與 PageHeader 標題左緣對齊）；**內側 16px 則是 `Section` 自帶的**，所以不要再對 `Section` 本身或它的直接子元素補 padding。結果是：卡片左緣 = 標題文字左緣 = 16px，卡片內容再往內 16px。

搭配 `Layout` 時，整個骨架原封不動放進 `Layout.Main`（它不提供 padding，也不需要）：

```tsx
<Layout>
  <Navigation>...</Navigation>
  <Layout.Main>
    <div className={styles.page}>{/* 同上結構 */}</div>
  </Layout.Main>
</Layout>
```

> 若專案頁面數量多、想避免每頁重抄這段 SCSS，可以把 `.page` / `.body` 抽成共用的 SCSS mixin（例如 `styles/_page-layout.scss` 提供 `@mixin page-root` / `@mixin page-body`），JSX 結構仍照上面明確寫出來。**不要**把 `PageHeader` 包進自訂容器元件再用 props 傳進去 — 那會讓頁面結構變得不透明。

### 自查清單（寫完頁面前逐項確認）

- [ ] page container 沒有任何水平 padding？
- [ ] `PageHeader` / `PageFooter` 是 page container 的**直接子代**，沒被 padded wrapper 包住？
- [ ] 主要內容有獨立 wrapper 且 `padding-inline` 使用 `--mzn-spacing-padding-horizontal-spacious`（不是寫死 16px、也不是 24px）？
- [ ] 區塊間距靠 `row-gap`，沒有對 `PageHeader` 加 `margin-bottom`？
- [ ] 內容是 `Section` 時，它有放在套了 `padding-inline` 的 `.body` 裡（不是直接掛在 `.page` 下貼邊），且**沒有**再幫 `Section` 自己補 padding？
- [ ] 有用到 `FilterArea` / `Tab` 嗎？放在 `.page` 直接層就維持預設 `size="main"`（自帶 gutter）；放進 `.body` 或 `Section` 內就必須改 `size="sub"`，否則是 16 + 16 的雙層內縮？

詳細範例與反例見 [references/PATTERNS.md → Page Body Alignment with PageHeader](references/PATTERNS.md#page-body-alignment-with-pageheader-重要--容易忽略)。

---

## 元件選用（必讀 — 先用「UI 概念」反查元件名）

**放任何元件進畫面之前先讀這段。** Mezzanine 的元件名反映**實作結構**，不是使用者概念 —— 分段控制項的實作是 `RadioGroup type="segment"`，被歸類在 Data Entry；狀態標籤的實作是 `Badge`，不是 `Tag`。若照其他設計系統（MUI / Ant Design / Bootstrap）的先驗去猜元件名，會系統性地選錯，而且**錯法看起來很合理**：找不到 `color` prop 時，最自然的推論是「這個元件比較陽春，顏色要自己補」，而不是「顏色不在它的職責範圍內 → 我選錯元件了」。

### 三條鐵則

1. **先查下面的反查表**，用「我要做的 UI 長什麼樣」去找元件名，不要用「這東西在別的設計系統叫什麼」去猜。
2. **表上沒有 → 全文搜尋 `references/components/` 的 `Aliases` 行**（各元件文件在摘要句下方列出了其他設計系統與 Figma 的慣用名）。還是找不到才考慮用既有元件組合，**永遠不要自建元件取代**。
3. **Tripwire（最重要）：如果你需要覆寫元件的 `background` / `color` / `border` 才能做出設計稿 —— 停下來，這幾乎一定代表選錯元件。**
   回頭查表，不要在專案裡長出一套與設計系統平行的私有色階。
   （純排版位移的 `margin` / `width` / `flex` / `grid-area` 不算，那是版面職責。）

   > **這條規則涵蓋「重新指定 CSS 變數」，不只是直接寫 `background:`。**
   > 在某個 class 裡把元件內部用到的語意 token 指到別的 token —— 例如
   > `.statusApproved { --mzn-color-background-brand-faint: var(--mzn-color-background-success-faint); }`
   > —— **同樣是覆寫元件外觀**，而且更危險：它看起來像「只用了 design tokens」，實際上是在偽造元件的語意。
   >
   > 分清楚兩件事：
   > - ✅ **用 design tokens** = 在**你自己的版面元素**上使用 `var(--mzn-spacing-*)`、`var(--mzn-color-*)`（例如 page body 的 `padding-inline`）
   > - ❌ **重新定義 design tokens** = 在元件節點或其祖先上把 `--mzn-color-*` 指到別的值，藉此改變元件外觀
   >
   > 元件的語意色只能透過**元件自己的 prop**（`variant` / `severity` / `type`）選擇。
   > 一個元件沒有提供選語意色的 prop，就代表**它不負責表達語意** —— 那是選錯元件，不是缺功能。

> 鐵則 3 是本段唯一**可偵測**的訊號：它把「我推論錯了」這種看不見的失誤，轉成寫 SCSS 當下就能自問的條件。真實案例：某專案用 `Tag` + 五個自訂 class 覆寫底色做狀態晶片，違反了「樣式僅可透過 design tokens 調整」的規範**而當下沒有意識到**——因為它以為 Tag 就是狀態元件，只是剛好沒提供顏色 prop。

### UI 概念 → 元件 反查表

| 你要做的 UI（含他家設計系統慣用名）                                        | Mezzanine 元件                                        | 常見誤用                                 |
| -------------------------------------------------------------------------- | ----------------------------------------------------- | ---------------------------------------- |
| 狀態晶片 / status chip / 已核准・失敗・停用                                | `Badge variant="dot-*" text="…"`                      | ❌ `Tag` + `className` 覆寫底色          |
| 分類標籤 / Chip (MUI) / Tag (AntD) / Pill                                  | `Tag`（描邊外觀用 `readOnly`）                        | ❌ 自刻 `span` + border                  |
| 分段控制項 / Segmented Control / 檢視切換 / 排序切換 / Toggle Button Group | `RadioGroup type="segment"` + `Radio type="segment"`  | ❌ 多顆 `Button` 用 variant 差異模擬選中 |
| 開關 / Switch (MUI・AntD)                                                  | `Toggle`                                              | ❌ `Switch`（已不在公開 API）            |
| 未讀數字氣泡 / 角落紅點                                                    | `Badge variant="count-*"` / `dot-*` + children        | ❌ 自刻絕對定位圓點                      |
| 頁面級・系統級警示橫幅                                                     | `AlertBanner`（Portal `alert` 層，`sticky; top: 0`）  | ❌ 拿來當區塊內說明（它不會待在原地）    |
| 區塊內說明 / 警語 / 表單提示                                               | `InlineMessage`（`content` prop）                     | ❌ `AlertBanner`                         |
| Toast / Snackbar / 操作完成浮動提示                                        | `Message`（imperative API）                           | ❌ 自刻 toast                            |
| 站內通知列表 / 通知中心                                                    | `NotificationCenter`                                  | ❌ 用 `Message` 堆疊                     |
| 卡片式頁面區塊 / Panel / Fieldset                                          | `Section`（自帶內距與底色）                           | ❌ 自刻 `div` + box-shadow               |
| 圖文卡片 / 商品卡                                                          | `Card` 家族（v2 已拆子元件）                          | ❌ `Section`                             |
| 標題-內容成對的詳情資訊 / Descriptions (AntD)                              | `Description` + `DescriptionContent`                  | ❌ 兩欄 `Table`                          |
| 空資料畫面 / Empty state                                                   | `Empty`                                               | ❌ `ResultState`                         |
| 操作結果頁（成功 / 失敗 / 404）                                            | `ResultState`                                         | ❌ `Empty`                               |
| 載入骨架 / Skeleton screen                                                 | `Skeleton`                                            | ❌ `Spin` 蓋整頁                         |
| 轉圈 loading（無進度）                                                     | `Spin`                                                | ❌ `Progress`                            |
| 有百分比的進度                                                             | `Progress`                                            | ❌ `Spin`                                |
| 多步驟流程指示 / Steps (AntD)                                              | `Stepper`                                             | ❌ 自刻圓圈 + 連線                       |
| 選「值」的下拉                                                             | `Select`                                              | ❌ `Dropdown`                            |
| 選「動作」的下拉選單 / Menu                                                | `Dropdown`（`options` 陣列 + trigger children）       | ❌ `Select`                              |
| 滑過顯示說明                                                               | `Tooltip`                                             | ❌ 原生 `title` 屬性                     |
| 文字溢出才顯示完整內容                                                     | `OverflowTooltip`                                     | ❌ `Tooltip` + 自行量測寬度              |
| 頁籤 / Tabs                                                                | `Tab` + `TabItem`（只收 `TabItem`，其餘**靜默丟棄**） | ❌ 自刻按鈕列                            |
| 篩選列                                                                     | `FilterArea` + `FilterLine` + `Filter`                | ❌ 自排 `TextField` + `Button`           |

### 兩組最常錯的，記判斷句

- **Tag vs Badge** —— 問自己：**「這個標籤在說『它是什麼』，還是『它現在怎麼樣』？」**
  「是什麼」（分類、屬性、可篩選的標籤）→ `Tag`；「現在怎麼樣」（狀態、結果、進度）→ `Badge variant="dot-*"`。
  `Tag` **沒有**語意顏色，這是刻意的，不是缺漏。詳見 [Tag.md](references/components/Tag.md) 與 [Badge.md](references/components/Badge.md)。
- **Segmented Control** —— 設計師講 `Segmented Control`（Figma 元件名），程式碼叫 `Radio`。互斥的檢視切換、排序切換、篩選切換一律用 `RadioGroup type="segment"`，**不要用多顆 `Button` 的 variant 差異模擬選中狀態**。詳見 [Radio.md](references/components/Radio.md)。

### 自查清單（UI 寫完前逐項確認）

- [ ] 每個區塊都在反查表上找得到對應元件，沒有自建元件取代 Mezzanine 既有元件？
- [ ] **沒有任何 `className` 在覆寫元件的 `background` / `color` / `border`**（鐵則 3）？
- [ ] 狀態類的呈現用的是 `Badge`，不是 `Tag` + 自訂色？
- [ ] 互斥切換用的是 `RadioGroup type="segment"`，不是多顆 `Button`？
- [ ] 區塊內的說明／警語用 `InlineMessage`，沒有誤用會浮到頁面頂端的 `AlertBanner`？
- [ ] 沒有動到元件既有的 UX 行為（只透過 props 與 design tokens 調整）？

完整對照表、Figma 名稱對應與「為什麼會選錯」的機制分析見 [references/COMPONENT_SELECTION.md](references/COMPONENT_SELECTION.md)。

---

## 後台實作慣例（寫列表頁、表單、Drawer 前必讀）

使用者在多個後台專案反覆糾正的問題整理在 [references/IMPLEMENTATION_CONVENTIONS.md](references/IMPLEMENTATION_CONVENTIONS.md)。目標是整個平台像同一個人做的；新頁面先找專案裡已確認做對的頁面當範本。交付前逐項確認：

- [ ] 列表頁順序是 `PageHeader` → `Tab` → `FilterArea` → body wrapper 內的 `Section`；同層沒有兩層 `Tab`，第二層放 `Section` 的 `tab`？
- [ ] 篩選、表格、列操作的 input 與按鈕都是 `size="sub"`，並排元素之間有 gap、底部對齊？
- [ ] Table：欄寬符合資料長度、只釘頭尾欄、排序／分頁／批次操作／空狀態都用 Table 與 `Pagination` 原生功能，沒有自刻「共 N 筆」或底部操作列？
- [ ] 破壞性操作用 `destructive-*`；送出 API 的按鈕有 `loading`？
- [ ] 每個 input／select 都有 placeholder；沒有說明性文字、副標或引導橫幅？
- [ ] 同類頁面（同一種資料主體、同一種操作）的元件、尺寸、位置和既有頁面一致？
- [ ] 改完在瀏覽器 1280 寬實際看過畫面？

---

## What's New in v1.10.2

> 涵蓋 1.6.0 – 1.10.2（13 個 release），只列影響寫法的變更。1.5.1 以前的歷史、不實 changelog 核對表、移除／未匯出元件說明見 [references/CHANGELOG_NOTES.md](references/CHANGELOG_NOTES.md)。
> 最低相依：`react` / `react-dom` **≥ 19**、`@mezzanine-ui/core` ≥ 1.3.3、`@mezzanine-ui/system` / `@mezzanine-ui/icons` ≥ 1.0.2。

### BREAKING / 行為或預設值改變

- **React 19 起跳（1.8.0）** — peer dependency 由 `>=18` 改為 `>=19`；所有元件改用 `ref` 當一般 prop（不再 `forwardRef`）。React 18 專案需先升級。
- **`Textarea` 預設撐滿容器（1.10.0）** — 新增 `fullWidth`，預設 `true`（同 `Input`）；原本依內容寬的 `<Textarea />` 會變滿版，要維持舊寬度請傳 `fullWidth={false}`。
- **`Dropdown` `shift` 預設 `true`（1.8.0）** — 靠近視窗邊緣的選單會被推回可視範圍；要保留原始位置請傳 `shift={false}`。
- **`Dropdown` 非受控時點選項會關閉（1.7.3）** — 條件：`open` 未受控且 `mode` 非 `multiple`；受控選單仍需自行關閉。`Table` 的 dropdown row action 也因此點完會關。
- **`Tooltip` / `Button` / `Table` tooltip 改走 portal（1.10.2）** — icon-only `Button` 與 `Table` 儲存格截斷 tooltip 改渲染到 portal（修正釘選欄被下一列蓋住）；`Button` 同時有 `aria-haspopup` 與 `aria-expanded`（`Dropdown` 會設）時，彈出期間隱藏其 tooltip。portal tooltip 依 mount 順序堆疊。

### 新 prop / API

| 元件 | 版本 | 變更 |
| ---- | ---- | ---- |
| `Table` | 1.6.0 | `scrollbarOptions`：轉給內層 `Scrollbar` 的 OverlayScrollbars options（巢狀 table 忽略）；取代以 `!important` 覆寫標記的做法 |
| `Table` | 1.7.0 | `columnWidths` / `onColumnWidthsChange`：可持久化／重設的 resizable 欄寬。callback 每次拖曳在 mouseup 觸發一次；`columnWidths` 受控且優先於 `column.width`，傳 `{}` 重設；值會被 `minWidth`/`maxWidth` 夾限 |
| `Table` | 1.8.0 | bulk actions 的 `mainActions` 改為選填；分隔線只在前面有群組時才渲染 |
| `Table` | 1.10.1 | dropdown row action 新增選填 `listboxLabel`（預設以 action `name`、bulk overflow 以 `label` 命名 listbox，通常不需設定） |
| `FilterArea` | 1.7.3 | `loading`（送出鈕 loading，優先於 `submitButtonProps.loading`）、`submitButtonProps` / `resetButtonProps`；`size` / `type` / `onClick` 仍由元件控制，`isDirty` 為 false 時重設鈕維持 disabled |
| `Calendar` | 1.9.0 | `calendarFooterControlProps`：自訂底部捷徑（今天／本月…），`children` 可為字串或 per-mode map；`CalendarFooterControl` 新增 `disabled`，並匯出 `CalendarFooterControlProps`。Picker 經 `calendarProps` 傳入，map 物件請定義在 render 外保持穩定 |
| `PageFooter` | 1.8.0 | `dropdownTriggerAriaLabel`：命名 overflow trigger |
| utilities | 1.8.0 | `splitAriaProps` / `pickAriaProps`：轉傳 `aria-*` props |

> `Table` **沒有**頂層 `sorting` prop：排序是各 column 的 `sortOrder`（受控）+ `onSort(key, nextOrder)`，`dataSource` 需自行排序。

> `ClearActions` / `ContentHeader` / `Scrollbar` 從未由 `@mezzanine-ui/react` 主入口匯出，需用 sub-path 匯入（如 `@mezzanine-ui/react/ContentHeader`）；它們仍存在、未棄用。

### 行為修正（寫法可能受影響）

- **`Scrollbar`（1.6.0）** — 呼叫端傳入的 `options.overflow` 現在會依 key 合併到預設 `{ x: 'scroll', y: 'scroll' }`，先前會被丟棄。
- **`Table`（1.7.0）** — 同時 `pinnable` + `resizable` 時 resize 現可正常拖曳。
- **`Select`（1.7.2）** — `isForceClearable` 現在真的會傳到 trigger，單選也能顯示清除鈕。
- **`AutoComplete`（1.8.0 / 1.8.1）** — `readOnly` 現已生效（不開啟選單、阻擋選取／清除／貼上／建立）；單選選完後可立即再搜尋。
- **Pickers（1.7.1 / 1.8.1）** — 可直接覆寫已填的欄位（月 `5` → `05`）；重打相同值不再觸發 `onChange`（貼上仍會）；Day.js adapter 依設定 format 解析，週／ISO 週／季／半年輸入會解析成該期間首日；快速輸入不再掉位數。
- **`Calendar`（1.9.0）** — 底部捷徑在當前期間 disabled 時一併 disabled，不會選到 disabled 日期。
- **`Modal` / `Drawer`（1.7.4 / 1.8.0）** — `Drawer` 比照 `Modal` 實作 dialog focus model（開啟移入焦點、Tab 循環、關閉還原，`role="dialog"` + `aria-modal`）；`Modal` 以 `ModalHeader` 標題命名；enter transition 期間已移入 dialog 的焦點不再被拉回；`<fieldset disabled>` 內的控制項不再被當成可聚焦。
- **`Portal`（1.8.0）** — SSR hydration 不再出現 React #418；`disablePortal` 內容 SSR 也就地渲染。
- **`TextField` / `Input`（1.8.0）** — 受控 input 第一個按鍵不再被吃掉；`aria-*` 轉傳到原生 input；自己的 `onInput` 仍會被呼叫。
- **其他（1.8.0）** — `ButtonGroup` 會展開 Fragment children（子按鈕吃到群組的 `disabled` / `size` / `variant`）；`Select` 暴露 combobox ARIA 並接受 `aria-label`；`Section` 轉傳原生與 `aria-*` props；`ClearActions` 的 `aria-label` 可覆寫預設 "Close"；`NotificationCenter` 相對時間以 `Intl.RelativeTimeFormat` 在地化、每 30 秒更新；`Modal` / `MediaPreviewModal` 的 `disableScrollLock` 改傳給 backdrop。
- **`Tooltip`（1.6.1）** — 窄容器（如 icon-only trigger）內文字不再一字一行。

---

---

## Storybook — 權威互動參考

所有元件皆可在 [React Storybook](https://storybook.mezzanine-ui.org/react/) 中查看互動範例。當文件描述與實際行為不一致時，以 Storybook 的互動範例為準。

> 站台根目錄 `storybook.mezzanine-ui.org` 是 landing page，**`?path=` 參數會被忽略**；React 的 Storybook 在 `/react/`、Angular 在 `/angular/`。

每個元件的參考文件都包含直接的 Storybook 連結，格式為：
`https://storybook.mezzanine-ui.org/react/?path=/docs/{kebab-storybook-title}--docs`

> `{kebab-storybook-title}` 來自 Storybook 內的 title（例如 `Data Display/Section` → `data-display-section`），**不一定等於本文件的分類**（例如 Drawer 在 Storybook 屬 Feedback、Layout 屬 Foundation）。要新增連結時，以 `https://storybook.mezzanine-ui.org/react/index.json` 的 `entries` key 為準；沒有 `--docs` 的元件改用 `?path=/story/{id}`。

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

部分容器元件在 runtime 只渲染白名單內的 children；`<div>` 包裝、Fragment 夾雜、錯的 Button variant 會讓內容**直接消失**。「JSX 寫了但畫面不顯示」時第一個檢查這裡。

- `Tab` 只收 `TabItem`、`Layout` 只收 `Layout.Main` / `LeftPanel` / `RightPanel` / `Navigation` —— **靜默丟棄，無 warning**；slot 必須是直接子代。
- `ContentHeader` 的 `Button` 只保留 `base-primary` / `base-secondary` / `destructive-secondary` / 未指定。
- `PageHeader` 只收一個 `Breadcrumb` + 一個 `ContentHeader`；`Section` 的 `contentHeader` / `filterArea` 會被強制 `size: 'sub'`，型別不符則 console.warn 且不渲染。

完整白名單表、反例與排查流程見 [references/CHILDREN_VALIDATION.md](references/CHILDREN_VALIDATION.md)。

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
| `Switch` *(已移除 @ 1.0.0-canary.3)* | Switch toggle — 已由 Toggle 取代，原始碼已刪除 | [Switch.md](references/components/Switch.md)               |
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
| `ClearActions` *(從未在主入口)*  | Clear/close button                   | sub-path only         | [ClearActions.md](references/components/ClearActions.md)     |
| `ContentHeader` *(從未在主入口)* | Content section header — `PageHeader` / `Section` 內部仍必須用它 | sub-path only | [ContentHeader.md](references/components/ContentHeader.md)   |
| `Dropdown`                        | Dropdown container (API 已重構)      | `@mezzanine-ui/react` | [Dropdown.md](references/components/Dropdown.md)             |
| `Scrollbar` *(從未在主入口)*     | Custom scrollbar                     | sub-path only         | [Scrollbar.md](references/components/Scrollbar.md)           |

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
| [references/COMPONENT_SELECTION.md](references/COMPONENT_SELECTION.md) | UI 概念 → 元件反查、選錯元件的三種機制、元件邊界事實 |
| [references/DESIGN_TOKENS.md](references/DESIGN_TOKENS.md)   | Detailed design token definitions |
| [references/ICONS.md](references/ICONS.md)                   | Complete icon list             |
| [references/IMPLEMENTATION_CONVENTIONS.md](references/IMPLEMENTATION_CONVENTIONS.md) | 後台實作慣例：頁面骨架、篩選列、Table、按鈕、表單、Modal／Drawer、跨頁一致性 |
| [references/CHILDREN_VALIDATION.md](references/CHILDREN_VALIDATION.md) | 容器元件 children 白名單、靜默丟棄的反例與排查流程 |
| [references/CHANGELOG_NOTES.md](references/CHANGELOG_NOTES.md) | 1.5.1 以前的歷代 What's New 與不實 changelog 核對紀錄 |
| [references/PATTERNS.md](references/PATTERNS.md)             | Common usage pattern examples  |
| [references/FIGMA_MAPPING.md](references/FIGMA_MAPPING.md)   | Figma node mapping table       |
| [references/components/](references/components/)             | Detailed API docs per component |

---

## Maintenance

### Version Sync Command

When Mezzanine-UI releases a new version, use the `/sync-mezzanine-ui` command to refresh all skill content:

```
/sync-mezzanine-ui react 1.10.2
```

This orchestrates a team of agents to:
1. Fetch TypeScript interfaces from the GitHub source code
2. Update component `.md` files to match real props/types
3. Refresh cache JSON files
4. Update this SKILL.md with the new version info

See also: `scripts/upgrade-version.sh` (analysis script), `scripts/figma-sync.sh` (Figma metadata sync)
