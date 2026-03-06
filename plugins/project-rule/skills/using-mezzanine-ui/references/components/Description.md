# Description Component

> **Category**: Data Display
>
> **Storybook**: `Data Display/Description`
>
> **Source Verification**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/react/src/Description)

Description component for displaying structured information in title-content pairs.

## Import

```tsx
import {
  Description,
  DescriptionContent,
  DescriptionTitle,
  DescriptionGroup,
} from '@mezzanine-ui/react';
import type {
  DescriptionProps,
  DescriptionContentProps,
  DescriptionTitleProps,
  DescriptionGroupProps,
} from '@mezzanine-ui/react';
```

---

## Description Props

Extends `DistributiveOmit<DescriptionTitleProps, 'className' | 'children'>`, so it also accepts `badge`, `icon`, `tooltip`, `tooltipPlacement`, `widthType`, etc.

| Property      | Type                           | Default        | Description                              |
| ------------- | ------------------------------ | -------------- | ---------------------------------------- |
| `children`    | `ReactElement`                 | -              | Content element (see supported types below) |
| `className`   | `string`                       | -              | Custom class name                        |
| `orientation` | `DescriptionOrientation`       | `'horizontal'` | Layout direction                         |
| `size`        | `DescriptionSize`              | `'main'`       | Default size for child content           |
| `title`       | `string`                       | -              | Required, title text                     |

---

### Size Propagation

The `size` prop on `Description` sets the default size for its child `DescriptionContent`. A child's own `size` prop takes precedence over the parent's `size`.

```tsx
// All children default to 'sub' size
<Description title="Name" size="sub">
  <DescriptionContent>John Doe</DescriptionContent>
</Description>

// Child overrides parent size
<Description title="Name" size="sub">
  <DescriptionContent size="main">John Doe</DescriptionContent>
</Description>
```

---

## Supported children Types

Description's children can be one of the following components:

- `DescriptionContent` (text content)
- `Badge` (badge)
- `Button` (button)
- `Progress` (progress bar)
- `TagGroup` (tag group)

---

## DescriptionTitle Props

`DescriptionTitleProps` uses a discriminated union type; whether `icon` is required depends on whether `tooltip` is provided.

### Base Props (DescriptionTitleBaseProps)

| Property      | Type                    | Default     | Description                    |
| ------------- | ----------------------- | ----------- | ------------------------------ |
| `badge`       | `BadgeDotVariant`       | -           | Dot badge next to the title    |
| `children`    | `string`                | -           | Required, title text           |
| `className`   | `string`                | -           | Custom class name              |
| `widthType`   | `DescriptionWidthType`  | `'stretch'` | Title width behavior           |

### With Tooltip (DescriptionTitleWithTooltip)

| Property           | Type             | Default | Description                            |
| ------------------ | ---------------- | ------- | -------------------------------------- |
| `icon`             | `IconDefinition` | -       | Required, icon after the title         |
| `tooltip`          | `string`         | -       | Required, tooltip shown on icon hover  |
| `tooltipPlacement` | `Placement`      | `'top'` | Tooltip position                       |

### Without Tooltip (DescriptionTitleWithoutTooltip)

| Property           | Type              | Default | Description                     |
| ------------------ | ----------------- | ------- | ------------------------------- |
| `icon`             | `IconDefinition`  | -       | Optional, icon after the title  |
| `tooltip`          | `undefined`       | -       | Do not set tooltip              |
| `tooltipPlacement` | `undefined`       | -       | Do not set placement            |

> When `tooltip` is provided, `icon` is required.

---

## DescriptionContent Props

`DescriptionContentProps` uses a discriminated union type; whether `icon` and `onClickIcon` are accepted depends on `variant`.

### Base Props (DescriptionContentBaseProps)

| Property      | Type                                                        | Default    | Description                                        |
| ------------- | ----------------------------------------------------------- | ---------- | -------------------------------------------------- |
| `children`    | `string`                                                    | -          | Required, content text                             |
| `className`   | `string`                                                    | -          | Custom class name                                  |
| `size`        | `DescriptionSize`                                           | `'main'`   | Text size (`'main' \| 'sub'`)                      |
| `variant`     | `'normal' \| 'statistic' \| 'trend-up' \| 'trend-down'`    | `'normal'` | Content style                                      |
| `icon`        | `never`                                                     | -          | Not available (only for `'with-icon'` variant)     |
| `onClickIcon` | `never`                                                     | -          | Not available (only for `'with-icon'` variant)     |

### With Clickable Icon (DescriptionContentWithClickableIcon)

| Property      | Type             | Default | Description                     |
| ------------- | ---------------- | ------- | ------------------------------- |
| `children`    | `string`         | -       | Required, content text          |
| `className`   | `string`         | -       | Custom class name               |
| `size`        | `DescriptionSize`| -       | Text size (`'main' \| 'sub'`)   |
| `variant`     | `'with-icon'`    | -       | Required, enables icon mode     |
| `icon`        | `IconDefinition` | -       | Required, icon after content    |
| `onClickIcon` | `VoidFunction`   | -       | Icon click event                |

---

## DescriptionGroup Props

| Property    | Type             | Default | Description                        |
| ----------- | ---------------- | ------- | ---------------------------------- |
| `children`  | `ReactElement[]` | -       | Required, Description child elements |
| `className` | `string`         | -       | Custom class name                  |

---

## Type Definitions

```ts
// Title width behavior
type DescriptionWidthType = 'narrow' | 'wide' | 'stretch' | 'hug';

// Content size
type DescriptionSize = 'main' | 'sub';

// Layout direction (inherited from Orientation)
type DescriptionOrientation = 'horizontal' | 'vertical';

// Content style variant (full enumeration, some are for internal use)
type DescriptionContentVariant =
  | 'badge'
  | 'button'
  | 'normal'
  | 'progress'
  | 'statistic'
  | 'tags'
  | 'trend-up'
  | 'trend-down'
  | 'with-icon';
```

---

## Usage Examples

### Basic Usage

```tsx
import { Description, DescriptionContent } from '@mezzanine-ui/react';

<Description title="Name">
  <DescriptionContent>John Doe</DescriptionContent>
</Description>
```

### Vertical Layout

```tsx
<Description title="Address" orientation="vertical">
  <DescriptionContent>
    123 Main Street, Suite 456, New York, NY 10001
  </DescriptionContent>
</Description>
```

### With Badge

```tsx
import { Description, Badge } from '@mezzanine-ui/react';

<Description title="Status">
  <Badge variant="dot-success" text="Online" />
</Description>
```

### With Button

```tsx
import { Description, Button } from '@mezzanine-ui/react';

<Description title="Action">
  <Button variant="text" onClick={handleClick}>
    Edit
  </Button>
</Description>
```

### With Progress

```tsx
import { Description, Progress } from '@mezzanine-ui/react';

<Description title="Progress">
  <Progress percent={75} type="percent" />
</Description>
```

### With TagGroup

```tsx
import { Description, Tag, TagGroup } from '@mezzanine-ui/react';

<Description title="Tags">
  <TagGroup>
    <Tag label="React" />
    <Tag label="TypeScript" />
    <Tag label="Node.js" />
  </TagGroup>
</Description>
```

### With Badge Title

```tsx
<Description title="Status" badge="dot-success">
  <DescriptionContent>Running</DescriptionContent>
</Description>
```

### With Tooltip Title

```tsx
import { InfoIcon } from '@mezzanine-ui/icons';

<Description title="Field Name" icon={InfoIcon} tooltip="This is the field description text">
  <DescriptionContent>Content</DescriptionContent>
</Description>
```

### Using DescriptionGroup

```tsx
import { DescriptionGroup, Description, DescriptionContent } from '@mezzanine-ui/react';

<DescriptionGroup>
  <Description title="Name">
    <DescriptionContent>John Doe</DescriptionContent>
  </Description>
  <Description title="Position">
    <DescriptionContent>Engineer</DescriptionContent>
  </Description>
</DescriptionGroup>
```

### DescriptionContent Variants

```tsx
// Statistic number
<DescriptionContent variant="statistic" size="main">
  1,234
</DescriptionContent>

// Trend up
<DescriptionContent variant="trend-up">
  +12.5%
</DescriptionContent>

// Trend down
<DescriptionContent variant="trend-down">
  -3.2%
</DescriptionContent>

// With icon
<DescriptionContent variant="with-icon" icon={EditIcon} onClickIcon={handleEdit}>
  Editable content
</DescriptionContent>
```

### Information List

```tsx
function UserInfo({ user }) {
  return (
    <div className="info-list">
      <Description title="Name">
        <DescriptionContent>{user.name}</DescriptionContent>
      </Description>
      <Description title="Email">
        <DescriptionContent>{user.email}</DescriptionContent>
      </Description>
      <Description title="Phone">
        <DescriptionContent>{user.phone}</DescriptionContent>
      </Description>
      <Description title="Status">
        <Badge variant="dot-success" text="Active" />
      </Description>
    </div>
  );
}
```

### Detail Page

```tsx
function OrderDetail({ order }) {
  return (
    <div className="order-detail">
      <Description title="Order ID">
        <DescriptionContent>{order.id}</DescriptionContent>
      </Description>
      <Description title="Created Date">
        <DescriptionContent>{order.createdAt}</DescriptionContent>
      </Description>
      <Description title="Order Status">
        <Badge variant="dot-warning" text="Processing" />
      </Description>
      <Description title="Processing Progress">
        <Progress percent={order.progress} type="percent" />
      </Description>
      <Description title="Action">
        <Button variant="contained" onClick={handleViewDetail}>
          View Details
        </Button>
      </Description>
    </div>
  );
}
```

### Mixed Layout

```tsx
<div className="description-grid">
  <Description title="Title One">
    <DescriptionContent>Content One</DescriptionContent>
  </Description>
  <Description title="Title Two">
    <DescriptionContent>Content Two</DescriptionContent>
  </Description>
  <Description title="Detailed Description" orientation="vertical">
    <DescriptionContent>
      This is a longer description text, using vertical layout to give the content more space to display.
    </DescriptionContent>
  </Description>
</div>
```

---

## Figma Mapping

| Figma Variant                    | React Props                              |
| -------------------------------- | ---------------------------------------- |
| `Description / Horizontal`       | `orientation="horizontal"`               |
| `Description / Vertical`         | `orientation="vertical"`                 |
| `Description / With Content`     | children is DescriptionContent           |
| `Description / With Badge`       | children is Badge                        |
| `Description / With Button`      | children is Button                       |
| `Description / With Progress`    | children is Progress                     |
| `Description / With Tags`        | children is TagGroup                     |

---

## Best Practices

1. **Keep titles concise**: Titles should be short and clear
2. **Appropriate content**: Choose suitable child components based on content type
3. **Consistent layout**: Maintain the same orientation within the same area
4. **Spacing control**: Use appropriate spacing between multiple Descriptions
5. **Responsive considerations**: Consider using vertical layout on small screens
