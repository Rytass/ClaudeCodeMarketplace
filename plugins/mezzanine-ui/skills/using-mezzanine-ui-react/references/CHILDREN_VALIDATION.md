# Children Validation Pitfalls

> Verified 1.10.2 (2026-11-22) · 從 SKILL.md 搬出的完整版。

部分容器元件會在 **runtime** 用 `Children.map` / `isValidElement` / `child.type === X` 對 `children` 做型別檢查，**只渲染白名單內的子元件**。傳入其他 JSX（自訂元件、`<div>` 包裝、Fragment 內亂塞、錯誤的 Button variant 等）時，雖然 React 樹中還在，**畫面會直接消失**，且部分元件靜默無提示。

> 任何時候 ContentHeader / PageHeader / Tab / Layout / Navigation / Accordion 等容器「JSX 寫了但畫面不顯示」，**第一個檢查點就是 children 是否在白名單內**。`<></>` Fragment 不會被解開、`<div>` 不會被穿透。

## 過濾規則一覽

| 元件 | 接受的 children | 被丟棄的 children | 失敗模式 |
| --- | --- | --- | --- |
| `ContentHeader` | `<a>` / 帶 `href` 元素（返回鈕）、`Input variant="search"`、`Select`、`Toggle`、`Checkbox`、`Button`（**限 `base-primary` / `base-secondary` / `destructive-secondary` / undefined**）、icon-only `Button` 包進 `Dropdown` | 一般 `<div>`、`Typography`、自訂 wrapper、其他 variant 的 `Button`、無 icon 的 `Button` 包進 `Dropdown`、`SegmentedControl`（見下方註） | console.warn + 不渲染 |

> **註 — `SegmentedControl` 只是 `ContentHeader` 不吃它，不是 Mezzanine 沒有這個元件。**
> `ContentHeaderProps` 的型別 union 含 `SegmentedControlProps` 但內部未實作渲染分支。
> 分段控制項的真正實作是 [`RadioGroup type="segment"`](components/Radio.md)，功能完整。
> 別因為搜到「未實作」就改用多顆 `Button` 模擬。
| `PageHeader` | 至多一個 `Breadcrumb` + 必要一個 `ContentHeader`（強制 `size="main"`） | 任何其他元件、重複的 `Breadcrumb` / `ContentHeader` | console.warn + 不渲染 |
| `Section` (props) | `contentHeader` 必為 `<ContentHeader>`、`filterArea` 必為 `<FilterArea>`（兩者會被強制 `size: 'sub'`，自行傳入的 `size` 無效）、`tab` 必為 `<Tab>` | 其他元件型別 | console.warn + 不渲染 |
| `Tab` | 只接受 `<TabItem>` | 任何其他元件、`<div>` 包裝、Fragment 中夾雜的非 TabItem | **靜默丟棄（無 warning）** |
| `Layout` | 只接受 `<Layout.Main>`、`<Layout.LeftPanel>`、`<Layout.RightPanel>`、`<Navigation>` | 自訂 `<div>` wrapper、其他元件 | **靜默丟棄（無 warning）** |
| `Navigation` | `NavigationHeader`、`NavigationFooter`、`NavigationOptionCategory`、`NavigationOption` | 原生 `<a>` / `<li>`、自訂導覽元件 | console.warn + 不渲染 |
| `NavigationOption` | 子層只接受 `NavigationOption`（巢狀）或 `Badge` | 其他元件 | 不渲染 |
| `NavigationOptionCategory` | 只接受 `NavigationOption` | 其他元件 | 不渲染 |
| `Accordion` | 一個 `AccordionTitle` + 一個 `AccordionContent`（其餘原始節點會自動包成 `AccordionContent`） | 重複的 `AccordionTitle` / `AccordionContent` | console.warn + 丟棄重複者 |
| `AccordionActions` | 只接受 `Button` / `Dropdown` | 其他元件 | 不渲染 |

## Tab 與 Layout 的靜默失敗（高風險）

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

## ContentHeader Button variant 限制

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

## 不會過濾 children 的元件（permissive）

下列元件 **不在 runtime 檢查 children 型別**，TypeScript 型別只是 hint，實際塞任何 JSX 都會渲染（但仍須遵守 prop 對的物件 shape）：

`Stepper`、`Breadcrumb`、`ButtonGroup`、`FormField`、`FormGroup`、`SectionGroup`、`PageFooter`、`Drawer`、`Modal`、`Description`、`DescriptionContent`、`Dropdown`、`Table`、`FilterArea` / `FilterLine` / `Filter`。

> 即使這些元件不會 runtime 過濾，仍**強烈建議**遵守 TypeScript 型別。`Description` 的「supported children types」（DescriptionContent / Badge / Button / Progress / TagGroup）是設計建議，視覺與排版只在這些元件下被測試過。

## 排查流程

1. JSX 結構正確但畫面缺塊 → 檢查上方表格內元件的 children 是否合法
2. `Tab` / `Layout` 整塊消失而 console 無錯 → 是靜默過濾，移除中間 wrapper
3. `ContentHeader` 按鈕沒出現但別處出現 → 確認 `variant` 在白名單
4. `PageHeader` / `Navigation` console 出現 `Invalid ... type` warning → 該位置應替換為合法元件

詳細個別 API 與例外請見 [references/components/](components/) 內各元件文件中「Accepted children types」/「Children Validation」章節。
