# Icon Component

> **Category**: Foundation
>
> **Storybook**: `Foundation/Icon`
>
> **Source**: [GitHub Source Code](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/react/src/Icon)

An icon component for displaying SVG icons provided by `@mezzanine-ui/icons`.

## Import

```tsx
import { Icon } from '@mezzanine-ui/react';
import type { IconProps, IconColor } from '@mezzanine-ui/react';

// Icons are imported from the icons package
import { PlusIcon, SearchIcon, SpinnerIcon } from '@mezzanine-ui/icons';
```

---

## Icon Props

`IconProps` extends native `<i>` element props (excluding `key` and `ref`).

| Property | Type             | Default | Description                                              |
| -------- | ---------------- | ------- | -------------------------------------------------------- |
| `icon`   | `IconDefinition` | -       | Required, icon definition (from `@mezzanine-ui/icons`)   |
| `color`  | `IconColor`      | -       | Icon color                                               |
| `size`   | `number`         | -       | Icon size (px)                                           |
| `spin`   | `boolean`        | `false` | Whether to apply spin animation                          |
| `title`  | `string`         | -       | Accessibility title                                      |

> In addition to the above, all native HTML attributes of `<i>` element (e.g., `onClick`, `className`, `style`) are accepted.
> When `onClick` or `onMouseOver` is present, cursor is automatically set to `pointer`.

---

## IconColor Type

```ts
type IconColor = 'inherit' | IconTone;
```

Semantic icon colors based on the design token system. `IconTone` comes from `@mezzanine-ui/system/palette`.

### Neutral

| Color                  | Description     |
| ---------------------- | --------------- |
| `inherit`              | Inherit parent  |
| `icon-fixed-light`     | Fixed light     |
| `icon-neutral-faint`   | Extra faint     |
| `icon-neutral-light`   | Light icon      |
| `icon-neutral`         | Standard icon   |
| `icon-neutral-strong`  | Strong icon     |
| `icon-neutral-bold`    | Bold icon       |
| `icon-neutral-solid`   | Solid icon      |

### Brand

| Color                | Description       |
| -------------------- | ----------------- |
| `icon-brand`         | Brand color icon  |
| `icon-brand-strong`  | Brand strong icon |
| `icon-brand-solid`   | Brand solid icon  |

### Semantic

| Color                  | Description     |
| ---------------------- | --------------- |
| `icon-error`           | Error icon      |
| `icon-error-strong`    | Error strong    |
| `icon-error-solid`     | Error solid     |
| `icon-warning`         | Warning icon    |
| `icon-warning-strong`  | Warning strong  |
| `icon-success`         | Success icon    |
| `icon-success-strong`  | Success strong  |
| `icon-info`            | Info icon       |
| `icon-info-strong`     | Info strong     |

> Note: The actual `IconColor` values are `'inherit'` or `IconTone` (without `icon-` prefix).
> The `icon-` prefix in the table above represents the corresponding CSS semantic color variables.
> For example, passing `color="neutral-strong"` maps to CSS variable `--mzn-color-semantic-icon-neutral-strong`.

---

## Usage Examples

### Basic Usage

```tsx
import { Icon } from '@mezzanine-ui/react';
import { PlusIcon, SearchIcon, HomeIcon } from '@mezzanine-ui/icons';

<Icon icon={PlusIcon} />
<Icon icon={SearchIcon} />
<Icon icon={HomeIcon} />
```

### Specifying Size

```tsx
<Icon icon={PlusIcon} size={16} />
<Icon icon={PlusIcon} size={24} />
<Icon icon={PlusIcon} size={32} />
```

### Specifying Color

```tsx
<Icon icon={CheckedFilledIcon} color="success" />
<Icon icon={ErrorFilledIcon} color="error" />
<Icon icon={WarningFilledIcon} color="warning" />
<Icon icon={InfoFilledIcon} color="brand" />
```

### Spin Animation

```tsx
import { SpinnerIcon } from '@mezzanine-ui/icons';

// For loading indication
<Icon icon={SpinnerIcon} spin />

// With size
<Icon icon={SpinnerIcon} spin size={24} />
```

### Accessibility Title

```tsx
<Icon icon={SearchIcon} title="Search" />
<Icon icon={HomeIcon} title="Home" />
```

### Clickable Icon

```tsx
<Icon
  icon={CloseIcon}
  onClick={() => handleClose()}
/>
```

---

## Icon Categories

Icons are categorized by function in `@mezzanine-ui/icons`:

| Category    | Description | Common Icons                               |
| ----------- | ----------- | ------------------------------------------ |
| `system/`   | System      | `MenuIcon`, `SearchIcon`, `UserIcon`       |
| `arrow/`    | Arrow       | `ChevronDownIcon`, `CaretRightIcon`        |
| `controls/` | Controls    | `PlusIcon`, `MinusIcon`, `CloseIcon`       |
| `alert/`    | Alert       | `CheckedFilledIcon`, `ErrorFilledIcon`     |
| `content/`  | Content     | `EditIcon`, `CopyIcon`, `DownloadIcon`     |
| `stepper/`  | Stepper     | `Item0Icon` ~ `Item9Icon`                  |

See [ICONS.md](../ICONS.md) for a complete icon list.

---

## Usage in Other Components

### Button with Icon

```tsx
import { Button } from '@mezzanine-ui/react';
import { PlusIcon } from '@mezzanine-ui/icons';

<Button icon={PlusIcon} iconType="leading">Add</Button>
<Button icon={PlusIcon} iconType="icon-only">Add</Button>
```

### TextField with Icon

```tsx
import { TextField } from '@mezzanine-ui/react';
import { SearchIcon, CloseIcon } from '@mezzanine-ui/icons';

<TextField
  prefix={<Icon icon={SearchIcon} size={16} />}
  suffix={<Icon icon={CloseIcon} size={16} />}
/>
```

### Status Indicator

```tsx
import {
  CheckedFilledIcon,
  ErrorFilledIcon,
  WarningFilledIcon,
} from '@mezzanine-ui/icons';

function StatusIcon({ status }) {
  const iconMap = {
    success: { icon: CheckedFilledIcon, color: 'success' },
    error: { icon: ErrorFilledIcon, color: 'error' },
    warning: { icon: WarningFilledIcon, color: 'warning' },
  };

  const { icon, color } = iconMap[status];
  return <Icon icon={icon} color={color} />;
}
```

---

## Figma Mapping

Figma icon nodes use `/` separated paths, corresponding to React import names:

| Figma Node                       | React Import         |
| -------------------------------- | -------------------- |
| `Icons / System / Search`        | `SearchIcon`         |
| `Icons / Controls / Plus`        | `PlusIcon`           |
| `Icons / Arrow / Chevron Down`   | `ChevronDownIcon`    |
| `Icons / Alert / Checked-Filled` | `CheckedFilledIcon`  |

---

## Best Practices

1. **Use semantic colors**: Ensure consistency through the `color` prop
2. **Set appropriate size**: Adjust `size` based on context
3. **Provide accessibility titles**: Add `title` for important icons
4. **Don't rely solely on icons to convey information**: Pair with text or tooltip
5. **Use `spin` for loading animations**: `SpinnerIcon` with `spin` prop
