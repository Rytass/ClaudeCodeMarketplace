# Accordion Component

> **Category**: Data Display
>
> **Storybook**: `Data Display/Accordion`
>
> **Source**: [GitHub Source Code](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/react/src/Accordion) · Verified v2 source (2026-03-13)

Collapsible accordion panels for expanding/collapsing content areas. Supports controlled/uncontrolled modes and group management.

## Import

```tsx
import {
  Accordion,
  AccordionTitle,
  AccordionContent,
  AccordionActions,
  AccordionGroup,
} from '@mezzanine-ui/react';
import type {
  AccordionProps,
  AccordionTitleProps,
  AccordionContentProps,
  AccordionActionsProps,
  AccordionGroupProps,
} from '@mezzanine-ui/react';
```

---

## Props / Sub-components

### Accordion

Main container component that manages expanded/collapsed state and passes it to children via Context. Internally uses `Fade` transition animation to control content visibility.

Extends `Omit<NativeElementPropsWithoutKeyAndRef<'div'>, 'onChange'>`.

| Property          | Type                          | Default  | Description                                                                                    |
| ----------------- | ----------------------------- | -------- | ---------------------------------------------------------------------------------------------- |
| `children`        | `ReactNode`                   | -        | Children; use `AccordionTitle` / `AccordionContent` combination, or place content directly (auto-wrapped as content) |
| `defaultExpanded` | `boolean`                     | `false`  | Initial expanded state in uncontrolled mode                                                    |
| `disabled`        | `boolean`                     | `false`  | Whether disabled (clicking title won't toggle when disabled)                                   |
| `expanded`        | `boolean`                     | -        | Expanded state in controlled mode; setting this prop enables controlled mode                   |
| `onChange`        | `(expanded: boolean) => void` | -        | Callback when expanded/collapsed state changes                                                 |
| `size`            | `'main' \| 'sub'`            | `'main'` | Accordion size                                                                                 |
| `title`           | `string`                      | -        | Shortcut for setting title text; when using this prop all `children` are treated as content     |
| `actions`         | `AccordionActionsProps`       | -        | Action buttons on the right side of title (only effective when using `title` prop)              |

---

### AccordionTitle

Accordion title bar, containing the expand/collapse arrow icon and click interaction. Internally uses `Rotate` transition component to control `ChevronRightIcon` rotation (-90 degrees when expanded).

Extends `NativeElementPropsWithoutKeyAndRef<'div'>`.

| Property        | Type                    | Default | Description                                                          |
| --------------- | ----------------------- | ------- | -------------------------------------------------------------------- |
| `children`      | `ReactNode`             | -       | Title content; can include text and `AccordionActions` sub-component |
| `iconClassName` | `string`                | -       | Custom className for the arrow icon                                  |
| `actions`       | `AccordionActionsProps` | -       | Props for the right-side actions area (renders `AccordionActions`)   |

---

### AccordionContent

Accordion content area, displayed when expanded, with `Collapse` transition animation for height collapse effect.

Extends `NativeElementPropsWithoutKeyAndRef<'div'>`.

| Property   | Type        | Default | Description                                            |
| ---------- | ----------- | ------- | ------------------------------------------------------ |
| `children` | `ReactNode` | -       | Content                                                |
| `expanded` | `boolean`   | -       | Additional expanded state control (merged with Accordion Context) |

---

### AccordionActions

Action button group on the right side of the title. Internally rendered with `ButtonGroup`, only allowing `Button` or `Dropdown` as children.

Extends `Omit<ButtonGroupProps, 'children'>`.

| Property   | Type                                              | Default | Description                                    |
| ---------- | ------------------------------------------------- | ------- | ---------------------------------------------- |
| `children` | `AccordionActionsChild \| AccordionActionsChild[]` | -       | Only `Button` or `Dropdown` allowed as children |

```ts
type AccordionActionsChild =
  | ReactElement<DropdownProps>
  | ReactElement<ButtonProps>
  | null
  | undefined
  | false;
```

---

### AccordionGroup

Groups multiple `Accordion` components together, uniformly passing `size` to each child `Accordion`.

Extends `NativeElementPropsWithoutKeyAndRef<'div'>`.

| Property    | Type               | Default  | Description                                  |
| ----------- | ------------------ | -------- | -------------------------------------------- |
| `children`  | `ReactNode`        | -        | Children (should contain multiple `Accordion`) |
| `exclusive` | `boolean`          | `false`  | If true, only one accordion can be expanded at a time (mutex mode) |
| `size`      | `'main' \| 'sub'` | `'main'` | Uniform size for all Accordions in the group |

---

## Type Definitions

```ts
// Internal Context type (not used directly, for reference only)
interface AccordionControlContextValue {
  contentId?: string;
  disabled: boolean;
  expanded: boolean;
  titleId?: string;
  toggleExpanded(e: boolean): void;
}
```

---

## Usage Examples

### Basic Usage (using title prop)

```tsx
import { Accordion } from '@mezzanine-ui/react';

function BasicAccordion() {
  return (
    <Accordion title="Accordion Title">
      <p>This is the accordion content area.</p>
    </Accordion>
  );
}
```

### Custom Structure with Sub-components

```tsx
import {
  Accordion,
  AccordionTitle,
  AccordionContent,
  AccordionActions,
  Button,
} from '@mezzanine-ui/react';

function CustomAccordion() {
  return (
    <Accordion>
      <AccordionTitle>
        Custom Title Content
        <AccordionActions>
          <Button variant="base-ghost" size="minor">
            Edit
          </Button>
        </AccordionActions>
      </AccordionTitle>
      <AccordionContent>
        <p>Custom content area.</p>
      </AccordionContent>
    </Accordion>
  );
}
```

### Controlled Mode

```tsx
import { useState } from 'react';
import { Accordion } from '@mezzanine-ui/react';

function ControlledAccordion() {
  const [expanded, setExpanded] = useState(false);

  return (
    <Accordion
      title="Controlled Accordion"
      expanded={expanded}
      onChange={setExpanded}
    >
      <p>Expanded state controlled by external state.</p>
    </Accordion>
  );
}
```

### AccordionGroup

```tsx
import { Accordion, AccordionGroup } from '@mezzanine-ui/react';

function GroupedAccordion() {
  return (
    <AccordionGroup size="sub">
      <Accordion title="Section 1">
        <p>Content of section 1.</p>
      </Accordion>
      <Accordion title="Section 2">
        <p>Content of section 2.</p>
      </Accordion>
      <Accordion title="Section 3">
        <p>Content of section 3.</p>
      </Accordion>
    </AccordionGroup>
  );
}
```

### With Action Buttons (via actions prop)

```tsx
import { Accordion, Button } from '@mezzanine-ui/react';

function AccordionWithActions() {
  return (
    <Accordion
      title="Accordion with Actions"
      actions={{
        children: [
          <Button key="edit" variant="base-ghost" size="minor">
            Edit
          </Button>,
          <Button key="delete" variant="destructive-ghost" size="minor">
            Delete
          </Button>,
        ],
      }}
    >
      <p>Content area.</p>
    </Accordion>
  );
}
```

### Exclusive Accordion

Using the `exclusive` prop on `AccordionGroup` enables mutex mode where only one accordion can be expanded at a time:

```tsx
import { Accordion, AccordionGroup } from '@mezzanine-ui/react';

function ExclusiveAccordion() {
  return (
    <AccordionGroup exclusive>
      <Accordion title="付款方式">
        目前支援信用卡、Line Pay、Apple Pay 等多種付款方式，
        您可以在結帳時選擇最方便的付款選項。
      </Accordion>
      <Accordion title="運送政策">
        訂單成立後 1-3 個工作天內出貨，全台宅配約 1-2 天送達。
        滿 $1,000 享免運優惠，未滿則需支付 $80 運費。
      </Accordion>
      <Accordion title="退換貨須知">
        商品到貨後 7 天內可申請退換貨，請保持商品完整包裝。
        如有瑕疵或寄送錯誤，我們將負擔來回運費。
      </Accordion>
    </AccordionGroup>
  );
}
```

---

## Best Practices

### 場景推薦

| 使用情境 | 推薦用法 | 原因 |
| ------- | ------- | ---- |
| 簡單文字標題 | `title="標題文字"` | 簡潔，無需子組件 |
| 標題含圖示/按鈕 | `<AccordionTitle>` + `<AccordionActions>` | 靈活組合，支援複雜內容 |
| 單一 Accordion | `<Accordion />` | 獨立使用 |
| 多個相關 Accordion | `<AccordionGroup>` | 統一尺寸和排列 |
| 互斥展開 | `<AccordionGroup exclusive>` | 只能同時開一個，如 FAQ |
| 主列表 | `size="main"` | 頂層內容 |
| 巢狀子內容 | `size="sub"` | 次層或詳細資訊 |
| 條件式操作 | `<AccordionActions><Button/></AccordionActions>` | 編輯、刪除等動作 |

### 常見錯誤

#### ❌ 混用 title prop 與 AccordionTitle
```tsx
// 錯誤：title 優先級更高，AccordionTitle 被忽視
<Accordion title="Main Title">
  <AccordionTitle>This is ignored</AccordionTitle>
  <AccordionContent>Content</AccordionContent>
</Accordion>
```

#### ✅ 正確做法：只用其中一種
```tsx
// 方式 1：簡單文字標題
<Accordion title="Main Title">
  Content here
</Accordion>

// 方式 2：自訂結構
<Accordion>
  <AccordionTitle>Custom Title</AccordionTitle>
  <AccordionContent>Content here</AccordionContent>
</Accordion>
```

#### ❌ AccordionGroup 中使用不同 size
```tsx
// 錯誤：視覺不一致
<AccordionGroup>
  <Accordion size="main" title="大" />
  <Accordion size="sub" title="小" />  {/* 不和諧 */}
</AccordionGroup>
```

#### ✅ 正確做法：group 統一 size
```tsx
<AccordionGroup size="sub">
  <Accordion title="Item 1" />
  <Accordion title="Item 2" />  {/* 統一套用 size="sub" */}
</AccordionGroup>
```

#### ❌ 在 AccordionActions 放入非 Button/Dropdown
```tsx
// 錯誤：自訂元素被過濾，無法呈現
<AccordionActions>
  <span>Custom Text</span>  {/* 被過濾 */}
  <Button>Delete</Button>
</AccordionActions>
```

#### ✅ 正確做法：只用 Button 或 Dropdown
```tsx
<AccordionActions>
  <Button variant="base-ghost" size="minor">
    Edit
  </Button>
  <Dropdown>
    <DropdownItem>Option</DropdownItem>
  </Dropdown>
</AccordionActions>
```

#### ❌ Exclusive 模式未預期的行為
```tsx
// 錯誤：使用 exclusive 但期望多個展開
<AccordionGroup exclusive>
  <Accordion expanded={true} title="Section 1" />
  <Accordion expanded={true} title="Section 2" />
  {/* 只有最後一個會展開 */}
</AccordionGroup>
```

#### ✅ 正確做法：controlled mode 配合 exclusive
```tsx
const [expandedId, setExpandedId] = useState('section-1');

<AccordionGroup exclusive>
  <Accordion
    expanded={expandedId === 'section-1'}
    onChange={(isExp) => isExp && setExpandedId('section-1')}
    title="Section 1"
  />
  <Accordion
    expanded={expandedId === 'section-2'}
    onChange={(isExp) => isExp && setExpandedId('section-2')}
    title="Section 2"
  />
</AccordionGroup>
```

#### ❌ 忽視 Accordion 無障礙屬性
```tsx
// 不夠好：缺少 id，ARIA 關聯不清
<Accordion>
  <AccordionTitle>Title</AccordionTitle>
</Accordion>
```

#### ✅ 正確做法：設定 id 建立 ARIA 關聯
```tsx
<Accordion>
  <AccordionTitle id="section-1-title">Title</AccordionTitle>
  <AccordionContent>Content</AccordionContent>
</Accordion>
```

### 核心要點

1. **title prop vs 子組件**：簡單用 title，複雜用子組件，勿混用
2. **AccordionGroup 統一 size**：group 會套用 size 到所有子 Accordion
3. **exclusive 互斥模式**：適合 FAQ、Tabs 類應用
4. **Actions 元素限制**：只能放 Button 或 Dropdown
5. **無障礙支援**：設定 id 確保屏幕閱讀器正確關聯標題和內容
