# Accordion Component

> **Category**: Data Display
>
> **Storybook**: `Data Display/Accordion`
>
> **Source Verification**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/react/src/Accordion)

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

1. **Use `title` prop for simple titles**: When only text title is needed, setting `title` is more concise than using `AccordionTitle`.
2. **Use sub-components for custom structure**: When extra elements (icons, buttons) are needed in the title, use `AccordionTitle` and `AccordionContent`.
3. **Avoid mixing approaches**: Do not use `title` prop and `AccordionTitle` sub-component simultaneously; `title` prop takes precedence.
4. **Group consistency**: Use `AccordionGroup` to ensure uniform `size` across multiple accordions.
5. **AccordionActions only allows `Button` or `Dropdown`**: Other elements will be filtered and trigger console warnings.
6. **Accessibility**: Setting `id` on `AccordionTitle` establishes ARIA association between title and content.
