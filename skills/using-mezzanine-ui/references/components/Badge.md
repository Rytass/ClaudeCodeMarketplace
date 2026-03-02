# Badge Component

> **Category**: Data Display
>
> **Storybook**: `Data Display/Badge`
>
> **Source Verification**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/react/src/Badge)

Badge component for marking status, quantity, or hint messages. Supports dot and count modes.

## Import

```tsx
import { Badge, BadgeContainer } from '@mezzanine-ui/react';
import type { BadgeProps } from '@mezzanine-ui/react';
```

> **Note**: `BadgeContainer` is deprecated (`@deprecated`), use the `Badge` component directly. `BadgeContainerProps` is equivalent to `NativeElementPropsWithoutKeyAndRef<'span'>`.

`BadgeProps` extends `Omit<NativeElementPropsWithoutKeyAndRef<'span'>, 'children'>` and unions with `BadgeVariantProps`.

---

## Badge Variant Types

### Dot Variants

| Variant         | Description    | Usage                    |
| --------------- | -------------- | ------------------------ |
| `dot-success`   | Success green  | Online/success status    |
| `dot-error`     | Error red      | Error/offline status     |
| `dot-warning`   | Warning yellow | Warning/attention status |
| `dot-info`      | Info blue      | Information hint         |
| `dot-inactive`  | Gray           | Inactive/idle status     |

### Count Variants

| Variant          | Description    | Usage                    |
| ---------------- | -------------- | ------------------------ |
| `count-alert`    | Alert red bg   | Important notification count |
| `count-inactive` | Gray bg        | Secondary notification count |
| `count-inverse`  | Dark bg        | Inverted color scheme    |
| `count-brand`    | Brand color bg | Brand-related count      |
| `count-info`     | Info blue bg   | General info count       |

---

## Badge Props

Badge props are divided into three mutually exclusive structures based on `variant` type:

### Count Badge (`variant: BadgeCountVariant`)

| Property        | Type                | Default | Description                    |
| --------------- | ------------------- | ------- | ------------------------------ |
| `variant`       | `BadgeCountVariant` | -       | Required, count variant        |
| `count`         | `number`            | -       | Required, number to display    |
| `overflowCount` | `number`            | -       | Shows `99+` when exceeded      |

> Count badge does not support `children` and `text`.

### Dot Badge with Text (`variant: BadgeDotVariant`)

| Property  | Type              | Default | Description                      |
| --------- | ----------------- | ------- | -------------------------------- |
| `variant` | `BadgeDotVariant` | -       | Required, dot variant            |
| `text`    | `string`          | -       | Text next to the dot (optional)  |

> Dot badge with text does not support `children`.

### Dot Badge with Children (`variant: BadgeDotVariant`)

| Property   | Type              | Default | Description                            |
| ---------- | ----------------- | ------- | -------------------------------------- |
| `variant`  | `BadgeDotVariant` | -       | Required, dot variant                  |
| `children` | `ReactNode`       | -       | Children, dot appears at top-right     |

> Dot badge with children does not support `text`.

---

## Usage Examples

### Dot Badge

```tsx
import { Badge } from '@mezzanine-ui/react';

// Standalone dot
<Badge variant="dot-success" />
<Badge variant="dot-error" />
<Badge variant="dot-warning" />
<Badge variant="dot-info" />
<Badge variant="dot-inactive" />

// With text
<Badge variant="dot-success" text="Online" />
<Badge variant="dot-error" text="Offline" />
```

### Dot Badge with Children

```tsx
import { Badge, Icon } from '@mezzanine-ui/react';
import { NotificationIcon } from '@mezzanine-ui/icons';

// Dot appears at top-right of icon
<Badge variant="dot-error">
  <Icon icon={NotificationIcon} />
</Badge>
```

### Count Badge

```tsx
// Count badge
<Badge variant="count-alert" count={5} />
<Badge variant="count-info" count={10} />
<Badge variant="count-inactive" count={0} />

// With overflow limit
<Badge variant="count-alert" count={120} overflowCount={99} />
// Displays "99+"
```

### Status List

```tsx
function StatusList() {
  const statuses = [
    { name: 'System A', variant: 'dot-success' as const },
    { name: 'System B', variant: 'dot-error' as const },
    { name: 'System C', variant: 'dot-warning' as const },
  ];

  return (
    <ul>
      {statuses.map((status) => (
        <li key={status.name}>
          <Badge variant={status.variant} text={status.name} />
        </li>
      ))}
    </ul>
  );
}
```

### Notification Icon

```tsx
function NotificationBadge({ hasNotification }: { hasNotification: boolean }) {
  return (
    <Badge variant="dot-error">
      <Icon icon={NotificationIcon} size={24} />
    </Badge>
  );
}
```

---

## count = 0 Behavior

When `count` is 0, count variant badges are automatically hidden.

```tsx
// Badge will not display
<Badge variant="count-alert" count={0} />
```

---

## Figma Mapping

| Figma Variant                | React Props                              |
| ---------------------------- | ---------------------------------------- |
| `Badge / Dot Success`        | `variant="dot-success"`                  |
| `Badge / Dot Error`          | `variant="dot-error"`                    |
| `Badge / Dot Warning`        | `variant="dot-warning"`                  |
| `Badge / Dot Info`           | `variant="dot-info"`                     |
| `Badge / Dot Inactive`       | `variant="dot-inactive"`                 |
| `Badge / Dot With Text`      | `variant="dot-*" text="..."`             |
| `Badge / Count Alert`        | `variant="count-alert"`                  |
| `Badge / Count Inactive`     | `variant="count-inactive"`               |
| `Badge / Count Inverse`      | `variant="count-inverse"`                |
| `Badge / Count Brand`        | `variant="count-brand"`                  |
| `Badge / Count Info`         | `variant="count-info"`                   |

---

## Type Definitions

```ts
// Variant types exported from @mezzanine-ui/core/badge
type BadgeDotVariant =
  | 'dot-success'
  | 'dot-error'
  | 'dot-warning'
  | 'dot-info'
  | 'dot-inactive';

type BadgeCountVariant =
  | 'count-alert'
  | 'count-inactive'
  | 'count-inverse'
  | 'count-brand'
  | 'count-info';

type BadgeVariant = BadgeDotVariant | BadgeCountVariant;

// BadgeVariantProps is a discriminated union
type BadgeVariantProps = BadgeCountProps | BadgeDotWithTextProps | BadgeDotProps;

// BadgeCountProps
interface BadgeCountProps {
  variant: BadgeCountVariant;
  count: number;
  overflowCount?: number;
  children?: never;
  text?: never;
}

// BadgeDotWithTextProps
interface BadgeDotWithTextProps {
  variant: BadgeDotVariant;
  text?: string;
  children?: never;
  count?: never;
  overflowCount?: never;
}

// BadgeDotProps
interface BadgeDotProps {
  variant: BadgeDotVariant;
  children?: ReactNode;
  text?: never;
  count?: never;
  overflowCount?: never;
}
```

> `BadgeCountVariant` and `BadgeDotVariant` are defined in `@mezzanine-ui/core/badge` and must be imported from that package. `BadgeProps` is exported from `@mezzanine-ui/react`.

---

## Best Practices

1. **Choose appropriate variant**: Select the corresponding variant based on semantics
2. **Set overflow count**: Use `overflowCount` for large numbers to prevent layout overflow
3. **Dot with icon**: Wrap dot badge around icons
4. **0 hides badge**: Count variant automatically hides when 0
5. **Status consistency**: Maintain consistent status color meanings within the same system
