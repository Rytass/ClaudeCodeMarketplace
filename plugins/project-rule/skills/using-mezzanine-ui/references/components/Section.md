# Section Component

> **Category**: Data Display
>
> **Storybook**: `Data Display/Section`
>
> **Source Verification**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/react/src/Section) · Verified v2 source (2026-03-13)
>
> **Migration Note (rc.4)**: Module resolution fix changed barrel file extension from `.tsx` → `.ts`. No API changes.

Section container component for composing `ContentHeader`, `FilterArea`, `Tab`, and other sub-components to build structured page sections. The passed `contentHeader` and `filterArea` automatically receive `size="sub"`.

## Import

```tsx
import { Section } from '@mezzanine-ui/react';
import type { SectionProps } from '@mezzanine-ui/react';
```

---

## Props

The component uses `forwardRef<HTMLDivElement, PropsWithChildren<SectionProps>>`, so it also accepts `children` and a standard div ref.

| Property        | Type                               | Default | Description                                                          |
| --------------- | ---------------------------------- | ------- | -------------------------------------------------------------------- |
| `className`     | `string`                           | -       | Additional CSS class                                                 |
| `contentHeader` | `ReactElement<ContentHeaderProps>` | -       | Accepts `<ContentHeader />` component; other components trigger a console warning |
| `filterArea`    | `ReactElement<FilterAreaProps>`    | -       | Accepts `<FilterArea />` component; other components trigger a console warning    |
| `tab`           | `ReactElement<TabProps>`           | -       | Accepts `<Tab />` component; other components trigger a console warning           |
| `children`      | `ReactNode`                        | -       | Section body content, rendered after contentHeader, filterArea, and tab           |

> Section automatically injects `size="sub"` prop into the passed `contentHeader` and `filterArea`, ensuring correct sizing in sub-sections.

---

## Render Order

The internal render order within Section is fixed as follows:

1. `contentHeader` (ContentHeader component)
2. `filterArea` (FilterArea component)
3. `tab` (Tab component)
4. `children` (body content)

---

## Usage Examples

### Basic Section

```tsx
import { Section } from '@mezzanine-ui/react';
import ContentHeader from '@mezzanine-ui/react/ContentHeader';

function BasicSection() {
  return (
    <Section
      contentHeader={<ContentHeader title="Order List" />}
    >
      <p>Order content area</p>
    </Section>
  );
}
```

### With FilterArea

```tsx
import { Section, FilterArea } from '@mezzanine-ui/react';
import ContentHeader from '@mezzanine-ui/react/ContentHeader';

function SectionWithFilter() {
  return (
    <Section
      contentHeader={<ContentHeader title="Product Management" />}
      filterArea={
        <FilterArea>
          {/* Filter criteria content */}
        </FilterArea>
      }
    >
      <div>Product list</div>
    </Section>
  );
}
```

### With Tab Pagination

```tsx
import { Section, Tab, TabItem } from '@mezzanine-ui/react';
import ContentHeader from '@mezzanine-ui/react/ContentHeader';
import { Key, useState } from 'react';

function SectionWithTabs() {
  const [activeTab, setActiveTab] = useState<Key>('all');

  return (
    <Section
      contentHeader={<ContentHeader title="Member Management" />}
      tab={
        <Tab activeKey={activeTab} onChange={(key) => setActiveTab(key)}>
          <TabItem key="all">All</TabItem>
          <TabItem key="active">Active</TabItem>
          <TabItem key="inactive">Inactive</TabItem>
        </Tab>
      }
    >
      <div>
        {activeTab === 'all' && <p>All members</p>}
        {activeTab === 'active' && <p>Active members</p>}
        {activeTab === 'inactive' && <p>Inactive members</p>}
      </div>
    </Section>
  );
}
```

### Full Composition

```tsx
import { Section, FilterArea, Tab, TabItem } from '@mezzanine-ui/react';
import ContentHeader from '@mezzanine-ui/react/ContentHeader';

function FullSection() {
  return (
    <Section
      contentHeader={
        <ContentHeader
          title="Report Overview"
          actions={[{ children: 'Export', variant: 'base-secondary' }]}
        />
      }
      filterArea={
        <FilterArea>
          {/* Date range, status filters, etc. */}
        </FilterArea>
      }
      tab={
        <Tab activeKey="daily">
          <TabItem key="daily">Daily</TabItem>
          <TabItem key="weekly">Weekly</TabItem>
          <TabItem key="monthly">Monthly</TabItem>
        </Tab>
      }
    >
      <div>Report data area</div>
    </Section>
  );
}
```

---

## Type Validation

Section validates the types of passed sub-components at runtime:

- `contentHeader` only accepts `<ContentHeader />` component
- `filterArea` only accepts `<FilterArea />` component
- `tab` only accepts `<Tab />` component

Passing non-matching components will output a console warning, e.g.:

```
[Section] Invalid contentHeader type: <MyCustomHeader>. Only <ContentHeader /> component from @mezzanine-ui/react is allowed.
```

---

## Content Area minHeight

Section's content area now supports `minHeight` to maintain consistent layout height. This is applied as a CSS style on the content area.

```tsx
<Section
  contentHeader={<ContentHeader title="Dashboard" />}
  style={{ '--section-content-min-height': '400px' } as React.CSSProperties}
>
  <div>Content with consistent minimum height</div>
</Section>
```

---

## Scenario-Oriented Best Practices

### 場景推薦

| 使用場景 | 建議做法 | 原因 |
| -------- | -------- | ---- |
| 內容區配備標題和操作 | 使用 `contentHeader` 搭配 `children` | ContentHeader 提供標題、搜尋、操作按鈕等，Section 自動調整尺寸 |
| 多條件篩選 | 使用 `filterArea` 放置過濾控制項 | FilterArea 佔據專用區域，隔離篩選邏輯，內容獨立更新 |
| 分頁籤式檢視 | 使用 `tab` 切換不同資料集合 | Tab 改變時 children 內容更新，Section 保持結構穩定 |
| 完整的列表頁面 | 組合 contentHeader、filterArea、tab、children | 按順序組合可建立標準的資料管理頁面 |
| 需要最小高度保持版面穩定 | 使用 CSS custom property `--section-content-min-height` | 避免內容少時頁面塌陷 |

### 常見錯誤

- **傳入非指定元件到 contentHeader/filterArea/tab**：Section 會在控制台警告並可能行為異常。應傳入正確的 Mezzanine 元件
- **嘗試在 contentHeader 中手動設置 `size="main"`**：Section 會自動覆寫為 `size="sub"`，手動設置無效
- **在 filterArea 內放置非篩選相關內容**：FilterArea 語義上應該只包含篩選條件，其他內容應放在 children
- **期望 tab 改變時 contentHeader 也更新**：ContentHeader 位置固定在頂部，改變 tab 不會影響它。若需聯動，應在 children 處理
- **嵌套多層 Section**：雖然技術上可行但會導致複雜的嵌套層級。應扁平化結構或改用其他容器

## Best Practices

1. **Use designated components**: `contentHeader`, `filterArea`, `tab` only accept their corresponding Mezzanine components; do not pass custom components.
2. **Automatic size adjustment**: Section automatically sets `contentHeader` and `filterArea` to `size="sub"`; no manual specification needed.
3. **Structural consistency**: Use the Section composition pattern consistently across pages to ensure uniform layout and spacing.
4. **Body content in children**: Place tables, lists, and other main data content in `children`; let Section manage the block layout.
5. **Consistent height**: Use `minHeight` on the content area when you need consistent section heights across a page.
