# PageHeader Component

> **Category**: Navigation
>
> **Storybook**: `Navigation/PageHeader`
>
> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/react/src/PageHeader) · Verified 1.0.0 (2026-04-02)

Page header component for displaying page-level navigation and titles. Contains breadcrumb and content header.

## Import

```tsx
import { PageHeader } from '@mezzanine-ui/react';
import type { PageHeaderProps } from '@mezzanine-ui/react';
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/?path=/docs/navigation-pageheader--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## Type Definitions

```ts
type PageHeaderChild =
  | ReactElement<BreadcrumbProps>
  | ReactElement<ContentHeaderProps>
  | null | undefined | false;

type PageHeaderProps = NativeElementPropsWithoutKeyAndRef<'header'> & {
  children?: PageHeaderChild | PageHeaderChild[];
};
```

---

## PageHeader Props

> Extends `NativeElementPropsWithoutKeyAndRef<'header'>`.

| Property   | Type                                  | Default | Description                                  |
| ---------- | ------------------------------------- | ------- | -------------------------------------------- |
| `children` | `PageHeaderChild \| PageHeaderChild[]`| -       | Breadcrumb and/or ContentHeader sub-components |

---

## Child Component Requirements

PageHeader only accepts the following child components:
- **Breadcrumb**: Breadcrumb navigation (at most one)
- **ContentHeader**: Content header (must have one)

> **Note**: `ContentHeader` is not exported from the `@mezzanine-ui/react` main entry; it must be imported from `@mezzanine-ui/react/ContentHeader`.
>
> **Deprecation Notice**: `ContentHeader` is deprecated in 1.0.0. See [ContentHeader.md](ContentHeader.md) for migration guidance. Consider using a custom composition with `PageHeader` + `Section` + utility components instead.

Note: ContentHeader's `size` is automatically set to `'main'`.

---

## Usage Examples

### Basic Usage

```tsx
import { PageHeader, Breadcrumb, Button } from '@mezzanine-ui/react';
import ContentHeader from '@mezzanine-ui/react/ContentHeader';

<PageHeader>
  <Breadcrumb
    items={[
      { name: 'Home', href: '/' },
      { name: 'Product Management', href: '/products' },
      { name: 'Add Product' },
    ]}
  />
  <ContentHeader
    title="Add Product"
    description="Fill in the information below to add a product"
  >
    <Button variant="base-secondary">Cancel</Button>
    <Button>Save</Button>
  </ContentHeader>
</PageHeader>
```

### With Back Button

```tsx
<PageHeader>
  <Breadcrumb
    items={[
      { name: 'Home', href: '/' },
      { name: 'Settings' },
    ]}
  />
  <ContentHeader
    title="Account Settings"
    onBackClick={() => router.back()}
  >
    <Button>Save Changes</Button>
  </ContentHeader>
</PageHeader>
```

### Without Breadcrumb

```tsx
<PageHeader>
  <ContentHeader
    title="Dashboard"
    description="Welcome back"
  >
    <Button>Add Report</Button>
  </ContentHeader>
</PageHeader>
```

### With Search and Filter

```tsx
<PageHeader>
  <Breadcrumb
    items={[
      { name: 'Home', href: '/' },
      { name: 'Order Management' },
    ]}
  />
  <ContentHeader
    title="Order List"
    filter={{
      variant: 'search',
      placeholder: 'Search orders...',
      onChange: handleSearch,
    }}
  >
    <Button variant="base-secondary">Export</Button>
    <Button>Add Order</Button>
  </ContentHeader>
</PageHeader>
```

---

## Component Structure

```
+------------------------------------------------------+
| PageHeader                                            |
| +--------------------------------------------------+ |
| | Breadcrumb                                        | |
| | Home > Product Management > Add Product           | |
| +--------------------------------------------------+ |
| +--------------------------------------------------+ |
| | ContentHeader                                     | |
| | [Back] Add Product    [Search] [Secondary] [Primary]| |
| |        Fill in the information...                 | |
| +--------------------------------------------------+ |
+------------------------------------------------------+
```

---

## Figma Mapping

| Figma Variant                     | React Props                              |
| --------------------------------- | ---------------------------------------- |
| `PageHeader / With Breadcrumb`    | Includes Breadcrumb                      |
| `PageHeader / Without Breadcrumb` | Does not include Breadcrumb              |
| `PageHeader / With Back`          | ContentHeader has `onBackClick`          |
| `PageHeader / With Actions`       | ContentHeader has children (buttons)     |

---

## Best Practices (最佳實踐)

### 場景推薦 (Scenario Recommendations)

| 場景 | 推薦做法 | 相關元件 |
| --- | --- | --- |
| 多層級導航 | 包含 `Breadcrumb` 顯示當前位置 | `Breadcrumb` |
| 簡單頁面 | 僅使用 `ContentHeader` 無需面包屑 | `ContentHeader` |
| 返回功能 | 在 `ContentHeader` 設定 `onBackClick` | `onBackClick` |
| 搜尋和篩選 | 使用 `ContentHeader` 的 `filter` 屬性 | `filter` |
| 頁面操作按鈕 | 在 `ContentHeader` children 放置操作按鈕 | `children` |
| 描述信息 | 使用 `ContentHeader` 的 `description` 屬性 | `description` |
| 響應式設計 | 在小螢幕上隱藏冗餘元素 | Media queries |

### 常見錯誤 (Common Mistakes)

1. **缺少 ContentHeader**
   - ❌ 誤：`<PageHeader><Breadcrumb ... /></PageHeader>` 只有面包屑
   - ✅ 正確：必須包含 `ContentHeader`，面包屑是可選的
   - 範例：至少要有 `<ContentHeader title="..." />`

2. **多層 Breadcrumb**
   - ❌ 誤：包含多個 `Breadcrumb` 組件
   - ✅ 正確：最多只能有一個 `Breadcrumb`
   - 影響：多個會導致重複或覆蓋

3. **自訂 ContentHeader size**
   - ❌ 誤：手動設定 `<ContentHeader size="sub" />`
   - ✅ 正確：不設定 `size`，自動為 `main`
   - 影響：確保一致的視覺層級

4. **未結構化導航**
   - ❌ 誤：深層導航不使用面包屑
   - ✅ 正確：超過 2 層導航結構建議使用面包屑
   - 範例：`Home > Products > Category > Item` 需面包屑

5. **按鈕位置混亂**
   - ❌ 誤：操作按鈕放在 `Breadcrumb` 下方
   - ✅ 正確：操作按鈕放在 `ContentHeader` children
   - 範例：`<ContentHeader><Button /></ContentHeader>`

### 核心建議 (Core Recommendations)

1. **必須包含 ContentHeader**：PageHeader 必須包含一個 `ContentHeader`
2. **面包屑可選**：面包屑可選，但導航層級多時推薦使用
3. **大小自動設定**：`ContentHeader` 的大小自動設為 main
4. **語義化**：正確使用 `<header>` 標籤提升可訪問性
5. **響應式考量**：考慮在小螢幕上隱藏某些元素
