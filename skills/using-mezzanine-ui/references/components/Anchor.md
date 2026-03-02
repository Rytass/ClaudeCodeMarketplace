# Anchor Component

> **Category**: Others
>
> **Storybook**: `Others/Anchor`
>
> **Source Verification**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/react/src/Anchor)

Anchor navigation component for in-page section navigation with automatic hash tracking.

## Import

```tsx
import { Anchor, AnchorGroup } from '@mezzanine-ui/react';
import type { AnchorProps, AnchorGroupProps } from '@mezzanine-ui/react';
```

> **Note**: `AnchorItemData` type is not exported from `@mezzanine-ui/react` main entry, only used internally.

---

## Anchor Props (Data Mode)

| Property  | Type               | Description        |
| --------- | ------------------ | ------------------ |
| `anchors` | `AnchorItemData[]` | Anchor data array  |

## Anchor Props (Children Mode)

| Property       | Type                                                          | Description          |
| -------------- | ------------------------------------------------------------- | -------------------- |
| `autoScrollTo` | `boolean`                                                     | Auto-scroll on click |
| `children`     | `string \| ReactElement<AnchorProps> \| Array<string \| ReactElement<AnchorProps>>` | Child anchors or text (actual constraint: `AnchorPropsWithChildren`) |
| `disabled`     | `boolean`                                                     | Whether disabled     |
| `href`         | `string`                                                      | Link target          |
| `onClick`      | `() => void`                                                  | Click callback       |
| `title`        | `string`                                                      | Title attribute      |

---

## AnchorGroup Props

| Property    | Type                                                              | Description      |
| ----------- | ----------------------------------------------------------------- | ---------------- |
| `anchors`   | `AnchorItemData[]`                                                | Anchor data array |
| `children`  | `ReactElement<AnchorPropsWithChildren> \| ReactElement<...>[]`    | Anchor children  |
| `className` | `string`                                                          | Custom className |

> `anchors` and `children` are mutually exclusive; use one or the other.

---

## AnchorItemData Type

```tsx
interface AnchorItemData {
  autoScrollTo?: boolean;
  children?: AnchorItemData[];
  disabled?: boolean;
  href: string;
  id: string;
  name: string;
  onClick?: VoidFunction;
  title?: string;
}
```

---

## Usage Examples

### Using Data Mode

```tsx
import { Anchor, AnchorGroup } from '@mezzanine-ui/react';

const anchors = [
  { id: '1', name: 'Chapter 1', href: '#chapter1' },
  { id: '2', name: 'Chapter 2', href: '#chapter2' },
  { id: '3', name: 'Chapter 3', href: '#chapter3', children: [
    { id: '3-1', name: 'Chapter 3 Section 1', href: '#chapter3-1' },
    { id: '3-2', name: 'Chapter 3 Section 2', href: '#chapter3-2' },
  ]},
];

<AnchorGroup>
  <Anchor anchors={anchors} />
</AnchorGroup>
```

### Using Children Mode

```tsx
<AnchorGroup>
  <Anchor href="#chapter1">Chapter 1</Anchor>
  <Anchor href="#chapter2">Chapter 2</Anchor>
  <Anchor href="#chapter3">
    Chapter 3
    <Anchor href="#chapter3-1">Chapter 3 Section 1</Anchor>
    <Anchor href="#chapter3-2">Chapter 3 Section 2</Anchor>
  </Anchor>
</AnchorGroup>
```

### Auto Scroll

```tsx
<AnchorGroup>
  <Anchor href="#section1" autoScrollTo>Section 1</Anchor>
  <Anchor href="#section2" autoScrollTo>Section 2</Anchor>
</AnchorGroup>
```

### Disabled Item

```tsx
<AnchorGroup>
  <Anchor href="#enabled">Enabled Item</Anchor>
  <Anchor href="#disabled" disabled>Disabled Item</Anchor>
</AnchorGroup>
```

### With Click Callback

```tsx
<AnchorGroup>
  <Anchor
    href="#section1"
    onClick={() => console.log('Clicked section1')}
  >
    Section 1
  </Anchor>
</AnchorGroup>
```

---

## Nesting Levels

Anchor supports up to 3 levels of nesting:

```
├── Level 1 (main anchor)
│   ├── Level 2 (sub anchor)
│   │   └── Level 3 (grandchild anchor)
```

Structures beyond 3 levels are ignored.

---

## Figma Mapping

| Figma Variant               | React Props                    |
| --------------------------- | ------------------------------ |
| `Anchor / Default`          | Default                        |
| `Anchor / Active`           | Matches current hash           |
| `Anchor / Disabled`         | `disabled`                     |
| `Anchor / Nested`           | Nested structure with children |

---

## Best Practices

1. **Unique ID**: Each anchor needs a unique id or href
2. **Level control**: Avoid nesting beyond 3 levels
3. **Auto scroll**: Enable `autoScrollTo` for long pages
4. **Parent disabling**: When parent anchor is disabled, all child anchors are also disabled
5. **Hash sync**: Component automatically tracks URL hash changes
