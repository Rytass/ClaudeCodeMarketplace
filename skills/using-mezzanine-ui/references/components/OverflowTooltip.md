# OverflowTooltip Component

> **Category**: Data Display -- OverflowCounterTag is exported from the main entry; OverflowTooltip is an internal component
>
> **Storybook**: `Data Display/OverflowTooltip`
>
> **Source Verification**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/react/src/OverflowTooltip)

Overflow tag tooltip component for displaying truncated tag lists. Typically used with Select in multi-select mode.

## Import

```tsx
// Only OverflowCounterTag is exported from the main entry
import { OverflowCounterTag } from '@mezzanine-ui/react';
import type { OverflowCounterTagProps } from '@mezzanine-ui/react';

// OverflowTooltip itself is an internal component; must be imported from sub-path
// import OverflowTooltip from '@mezzanine-ui/react/OverflowTooltip';
```

> **Note**: Only `OverflowCounterTag` is exported from the `@mezzanine-ui/react` main entry. `OverflowTooltip` is an internal component.

---

## OverflowCounterTag Props

OverflowCounterTag is a composite component of OverflowTooltip and Tag. Clicking the counter tag expands the overflow tag list.

Extends `NativeElementPropsWithoutKeyAndRef<'span'>` and `Pick<OverflowTooltipProps, 'className' | 'onTagDismiss' | 'placement' | 'tags' | 'tagSize' | 'readOnly'>`.

| Property       | Type                      | Default | Description                  |
| -------------- | ------------------------- | ------- | ---------------------------- |
| `className`    | `string`                  | -       | Custom class name            |
| `disabled`     | `boolean`                 | -       | Whether disabled             |
| `onTagDismiss` | `(index: number) => void` | -       | Tag dismiss callback (required) |
| `placement`    | `Placement`               | -       | Popup placement              |
| `readOnly`     | `boolean`                 | -       | Whether read-only            |
| `tags`         | `string[]`                | `[]`    | Tag list                     |
| `tagSize`      | `TagProps['size']`        | -       | Tag size                     |

### OverflowCounterTag Usage Example

```tsx
import { OverflowCounterTag } from '@mezzanine-ui/react';

<OverflowCounterTag
  tags={['Tag 1', 'Tag 2', 'Tag 3']}
  onTagDismiss={(index) => handleRemove(index)}
  tagSize="main"
/>
```

---

## OverflowTooltip Props (Internal Component)

`OverflowTooltipProps` is an object type (not an interface inheritance).

| Property       | Type                       | Default       | Description          |
| -------------- | -------------------------- | ------------- | -------------------- |
| `anchor`       | `PopperProps['anchor']`    | **required**  | Anchor element       |
| `className`    | `string`                   | -             | className            |
| `onTagDismiss` | `(tagIndex: number) => void` | **required** | Tag dismiss callback |
| `open`         | `boolean`                  | **required**  | Whether open         |
| `placement`    | `Placement`                | `'top-start'` | Popup placement      |
| `readOnly`     | `boolean`                  | -             | Whether read-only    |
| `tags`         | `string[]`                 | **required**  | Tag list             |
| `tagSize`      | `TagProps['size']`         | -             | Tag size             |

---

## Usage Examples

### Basic Usage (OverflowTooltip Internal Component)

```tsx
// OverflowTooltip must be imported from sub-path (not exported from main entry)
import OverflowTooltip from '@mezzanine-ui/react/OverflowTooltip';
import { useRef, useState } from 'react';

function BasicExample() {
  const anchorRef = useRef<HTMLDivElement>(null);
  const [open, setOpen] = useState(false);
  const [tags, setTags] = useState(['Tag 1', 'Tag 2', 'Tag 3']);

  const handleTagDismiss = (index: number) => {
    setTags(prev => prev.filter((_, i) => i !== index));
  };

  return (
    <div>
      <div
        ref={anchorRef}
        onMouseEnter={() => setOpen(true)}
        onMouseLeave={() => setOpen(false)}
      >
        +{tags.length} more
      </div>
      <OverflowTooltip
        anchor={anchorRef}
        open={open}
        tags={tags}
        onTagDismiss={handleTagDismiss}
      />
    </div>
  );
}
```

### Read-Only Mode

```tsx
<OverflowTooltip
  anchor={anchorRef}
  open={open}
  tags={['Tag 1', 'Tag 2', 'Tag 3']}
  onTagDismiss={() => {}}
  readOnly
/>
```

### Custom Placement

```tsx
<OverflowTooltip
  anchor={anchorRef}
  open={open}
  tags={tags}
  onTagDismiss={handleTagDismiss}
  placement="bottom-start"
/>
```

### Small Size Tags

```tsx
<OverflowTooltip
  anchor={anchorRef}
  open={open}
  tags={tags}
  onTagDismiss={handleTagDismiss}
  tagSize="sub"
/>
```

### With Multi-Select

```tsx
function MultiSelectWithOverflow() {
  const [selectedValues, setSelectedValues] = useState(['a', 'b', 'c', 'd', 'e']);
  const [tooltipOpen, setTooltipOpen] = useState(false);
  const overflowRef = useRef<HTMLSpanElement>(null);

  const displayedTags = selectedValues.slice(0, 2);
  const overflowTags = selectedValues.slice(2);

  return (
    <div>
      {displayedTags.map(tag => (
        <Tag key={tag} label={tag} type="dismissable" onClose={() => handleRemove(tag)} />
      ))}
      {overflowTags.length > 0 && (
        <span
          ref={overflowRef}
          onMouseEnter={() => setTooltipOpen(true)}
          onMouseLeave={() => setTooltipOpen(false)}
        >
          +{overflowTags.length}
        </span>
      )}
      <OverflowTooltip
        anchor={overflowRef}
        open={tooltipOpen}
        tags={overflowTags}
        onTagDismiss={(index) => handleRemove(overflowTags[index])}
      />
    </div>
  );
}
```

---

## Tag Behavior

- **readOnly=false** (default): Tags are displayed as dismissable; clicking X triggers `onTagDismiss`
- **readOnly=true**: Tags are displayed as static; cannot be dismissed

---

## Figma Mapping

| Figma Variant                    | React Props                              |
| -------------------------------- | ---------------------------------------- |
| `OverflowTooltip / Default`      | Default                                  |
| `OverflowTooltip / ReadOnly`     | `readOnly`                               |
| `OverflowTooltip / Top`          | `placement="top-start"` (default)        |
| `OverflowTooltip / Bottom`       | `placement="bottom-start"`               |

---

## Best Practices

1. **Hover trigger**: Typically use mouseEnter/mouseLeave to control open/close
2. **Sync state**: `onTagDismiss` should synchronize with external state
3. **Appropriate placement**: Choose suitable `placement` based on available space
4. **Read-only mode**: Use `readOnly` for display-only scenarios
5. **Pair with Select**: Commonly used with multi-select Select's overflow counter
