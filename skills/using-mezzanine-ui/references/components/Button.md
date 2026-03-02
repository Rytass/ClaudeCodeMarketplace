# Button Component

> **Category**: Foundation
>
> **Storybook**: `Foundation/Button`
>
> **Source**: [GitHub Source Code](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/react/src/Button) · Verified v2 source (2026-02-13)

The most commonly used interactive element, supporting multiple variants and sizes.

## Import

```tsx
import { Button, ButtonGroup } from '@mezzanine-ui/react';
import type {
  ButtonProps,
  ButtonPropsBase,
  ButtonComponent,
  ButtonVariant,
  ButtonSize,
  ButtonGroupProps,
  ButtonGroupChild,
  ButtonGroupOrientation,
} from '@mezzanine-ui/react';

// The following types must be imported from sub-path
import type { ButtonIconType } from '@mezzanine-ui/react/Button';
```

---

## Button Props

`ButtonProps<C>` is a generic type extending `ButtonPropsBase` plus the native attributes of element `C`.

| Property          | Type              | Default          | Description                                              |
| ----------------- | ----------------- | ---------------- | -------------------------------------------------------- |
| `variant`         | `ButtonVariant`   | `'base-primary'` | Button variant                                           |
| `size`            | `ButtonSize`      | `'main'`         | Button size                                              |
| `disabled`        | `boolean`         | `false`          | Whether disabled                                         |
| `loading`         | `boolean`         | `false`          | Whether to show loading state (with Spinner icon)        |
| `icon`            | `IconDefinition`  | -                | Icon                                                     |
| `iconType`        | `ButtonIconType`  | -                | Icon position                                            |
| `children`        | `ReactNode`       | -                | Button text; used as tooltip when `iconType='icon-only'` |
| `disabledTooltip` | `boolean`         | `false`          | Whether to disable icon-only button's tooltip            |
| `tooltipPosition` | `PopperPlacement` | `'bottom'`       | Tooltip position for icon-only button                    |
| `component`       | `ButtonComponent` | `'button'`       | Custom render element (`'button'`, `'a'`, or JSX component) |

---

## ButtonComponent Type

```ts
type ButtonComponent = 'button' | 'a' | JSXElementConstructor<any>;
```

---

## ButtonVariant Type

### Base

| Variant          | Description      | Use Case                  |
| ---------------- | ---------------- | ------------------------- |
| `base-primary`   | Primary button   | Main action (CTA)         |
| `base-secondary` | Secondary button | Secondary action          |
| `base-tertiary`  | Tertiary button  | Low-priority action       |
| `base-ghost`     | Ghost button     | Action on plain background |
| `base-dashed`    | Dashed button    | Add/create actions        |
| `base-text-link` | Text link        | Navigation or linking     |

### Destructive

| Variant                 | Description             | Use Case                     |
| ----------------------- | ----------------------- | ---------------------------- |
| `destructive-primary`   | Destructive primary     | Irreversible actions (delete) |
| `destructive-secondary` | Destructive secondary   | Secondary destructive action |
| `destructive-ghost`     | Destructive ghost       | Low-emphasis destructive action |
| `destructive-text-link` | Destructive text link   | Navigate to destructive action |

### Inverse

| Variant         | Description    | Use Case                    |
| --------------- | -------------- | --------------------------- |
| `inverse`       | Inverse button | Used on dark backgrounds    |
| `inverse-ghost` | Inverse ghost  | Ghost button on dark backgrounds |

---

## ButtonSize Type

```ts
type ButtonSize = GeneralSize; // 'main' | 'sub' | 'minor'
```

| Size    | Description |
| ------- | ----------- |
| `main`  | Main size   |
| `sub`   | Sub size    |
| `minor` | Minor size  |

---

## ButtonIconType Type

| IconType    | Description          |
| ----------- | -------------------- |
| `leading`   | Icon on left of text |
| `trailing`  | Icon on right of text |
| `icon-only` | Icon only            |

---

## Usage Examples

### Basic Variants

```tsx
import { Button } from '@mezzanine-ui/react';

// Primary button
<Button variant="base-primary">Primary</Button>

// Secondary button
<Button variant="base-secondary">Secondary</Button>

// Tertiary button
<Button variant="base-tertiary">Tertiary</Button>

// Ghost button
<Button variant="base-ghost">Ghost</Button>

// Dashed button
<Button variant="base-dashed">Dashed</Button>

// Text link
<Button variant="base-text-link">Text Link</Button>
```

### Destructive Actions

```tsx
<Button variant="destructive-primary">Delete</Button>
<Button variant="destructive-secondary">Cancel</Button>
<Button variant="destructive-ghost">Remove</Button>
<Button variant="destructive-text-link">Delete Link</Button>
```

### Sizes

```tsx
<Button size="main">Main Size</Button>
<Button size="sub">Sub Size</Button>
<Button size="minor">Minor Size</Button>
```

### With Icons

```tsx
import { PlusIcon, ChevronDownIcon, TrashIcon } from '@mezzanine-ui/icons';

// Leading icon
<Button icon={PlusIcon} iconType="leading">Add</Button>

// Trailing icon
<Button icon={ChevronDownIcon} iconType="trailing">Expand</Button>

// Icon only (automatically shows tooltip)
<Button icon={TrashIcon} iconType="icon-only">Delete</Button>

// Icon only (tooltip disabled)
<Button icon={TrashIcon} iconType="icon-only" disabledTooltip>Delete</Button>
```

### States

```tsx
// Disabled
<Button disabled>Disabled</Button>

// Loading
<Button loading>Loading</Button>

// Loading (with icon)
<Button loading icon={PlusIcon} iconType="leading">Adding</Button>
```

### As Link

```tsx
// Using <a> tag
<Button component="a" href="/path">Go to Link</Button>

// With Next.js Link
import Link from 'next/link';

<Button component={Link} href="/path">Go to Link</Button>
```

---

## ButtonGroup

Button group that combines multiple buttons together.

### ButtonGroup Props

`ButtonGroupProps` extends native `<div>` element attributes (excluding `key` and `ref`).

| Property      | Type                                     | Default          | Description                                        |
| ------------- | ---------------------------------------- | ---------------- | -------------------------------------------------- |
| `children`    | `ButtonGroupChild \| ButtonGroupChild[]` | -                | Child buttons                                      |
| `disabled`    | `boolean`                                | `false`          | Group default disabled state (individual buttons can override) |
| `fullWidth`   | `boolean`                                | `false`          | Whether to set width: 100%                         |
| `orientation` | `ButtonGroupOrientation`                 | `'horizontal'`   | Arrangement direction                              |
| `size`        | `ButtonSize`                             | `'main'`         | Group default button size (individual buttons can override) |
| `variant`     | `ButtonVariant`                          | `'base-primary'` | Group default button variant (individual buttons can override) |

> `ButtonGroupOrientation` is equivalent to `'horizontal' | 'vertical'`.
>
> `ButtonGroupChild` is equivalent to `ReactElement<ButtonProps> | null | undefined | false`.

### Usage Examples

```tsx
import { Button, ButtonGroup } from '@mezzanine-ui/react';

// Horizontal group
<ButtonGroup>
  <Button>Left</Button>
  <Button>Center</Button>
  <Button>Right</Button>
</ButtonGroup>

// Vertical group
<ButtonGroup orientation="vertical">
  <Button>Top</Button>
  <Button>Center</Button>
  <Button>Bottom</Button>
</ButtonGroup>
```

---

## Figma Mapping

| Figma Variant                    | React Props                                      |
| -------------------------------- | ------------------------------------------------ |
| `Size=Main, Variant=Primary`    | `<Button size="main" variant="base-primary">`    |
| `Size=Sub, Variant=Secondary`   | `<Button size="sub" variant="base-secondary">`   |
| `Variant=Destructive-Primary`   | `<Button variant="destructive-primary">`         |
| `State=Disabled`                 | `<Button disabled>`                              |
| `State=Loading`                  | `<Button loading>`                               |
| `Icon=Leading`                   | `<Button icon={Icon} iconType="leading">`        |
| `Icon=Trailing`                  | `<Button icon={Icon} iconType="trailing">`       |
| `Icon=Only`                      | `<Button icon={Icon} iconType="icon-only">`      |

---

## Best Practices

1. **Use correct variant**: Use `base-primary` for main actions, `destructive-*` for dangerous actions
2. **One primary button per page**: Avoid visual confusion
3. **icon-only buttons need clear text**: `children` automatically serves as tooltip
4. **Prevent repeated clicks during loading**: `loading` state automatically blocks onClick
5. **Use `component="a"` for links**: Maintain semantic HTML
