# Selection Component

> **Category**: Data Entry
>
> **Storybook**: `Data Entry/Selection`
>
> **Source Verification**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/react/src/Selection) · Verified v2 source (2026-03-06)

Selection card component providing selection items with images or icons. Supports single-select (radio) and multi-select (checkbox) modes.

## Import

```tsx
import { Selection } from '@mezzanine-ui/react';

import type {
  SelectionProps,
  SelectionPropsBase,
} from '@mezzanine-ui/react';

// SelectionDirection, SelectionType can be imported from sub-path
import type { SelectionDirection, SelectionType } from '@mezzanine-ui/react/Selection';
// SelectionImageObjectFit is only available from core (react/Selection does not export this type)
import type { SelectionImageObjectFit } from '@mezzanine-ui/core/selection';
```

> **Note**: `SelectionDirection` and `SelectionType` are not exported from the `@mezzanine-ui/react` main entry; import from `@mezzanine-ui/react/Selection` or `@mezzanine-ui/core/selection`. The default export is `Selection as GenericSelection` (supports generics).

---

## SelectionPropsBase

Base props interface, extends `Omit<NativeElementPropsWithoutKeyAndRef<'label'>, 'onChange'>`.

| Property         | Type                                                        | Default        | Description            |
| ---------------- | ----------------------------------------------------------- | -------------- | ---------------------- |
| `checked`        | `boolean`                                                   | -              | Controlled checked state |
| `customIcon`     | `IconDefinition`                                            | -              | Custom icon            |
| `defaultChecked` | `boolean`                                                   | `false`        | Default checked state  |
| `direction`      | `SelectionDirection` (`'horizontal' \| 'vertical'`)         | `'horizontal'` | Layout direction       |
| `disabled`       | `boolean`                                                   | `false`        | Whether disabled       |
| `id`             | `string`                                                    | -              | Input element id       |
| `image`          | `string`                                                    | -              | Image URL              |
| `imageObjectFit` | `SelectionImageObjectFit` (`'cover' \| 'contain' \| 'fill' \| 'none' \| 'scale-down'`) | `'cover'` | Image fit mode |
| `inputRef`       | `Ref<HTMLInputElement>`                                     | -              | Input element ref      |
| `name`           | `string`                                                    | -              | Input name attribute   |
| `onChange`       | `ChangeEventHandler<HTMLInputElement>`                      | -              | Change callback        |
| `readonly`       | `boolean`                                                   | `false`        | Whether read-only      |
| `selector`       | `SelectionType` (`'radio' \| 'checkbox'`)                   | `'radio'`      | Selector type          |
| `supportingText` | `string`                                                    | -              | Supporting text        |
| `text`           | `string`                                                    | **required**   | Primary text           |
| `value`          | `string`                                                    | -              | Input value attribute  |

## SelectionProps

Extends `SelectionPropsBase` with additional:

| Property         | Type                                           | Default | Description      |
| ---------------- | ---------------------------------------------- | ------- | ---------------- |
| `onClick`        | `(event: MouseEvent<HTMLLabelElement>) => void` | -       | Click callback   |

---

## Type Definitions

```tsx
// Layout direction
type SelectionDirection = 'horizontal' | 'vertical';

// Selector type
type SelectionType = 'radio' | 'checkbox';

// Image fit mode
type SelectionImageObjectFit = 'cover' | 'contain' | 'fill' | 'none' | 'scale-down';
```

---

## Usage Examples

### Basic Usage

```tsx
import { Selection } from '@mezzanine-ui/react';

<Selection
  text="Option 1"
  supportingText="Description for option 1"
  selector="radio"
  name="option"
  value="1"
/>
```

### With Image

```tsx
<Selection
  text="Product A"
  supportingText="Description of Product A"
  image="/images/product-a.jpg"
  selector="radio"
  name="product"
  value="a"
/>
```

### Custom Icon

```tsx
import { FolderIcon } from '@mezzanine-ui/icons';

<Selection
  text="Folder"
  supportingText="Select folder type"
  customIcon={FolderIcon}
  selector="radio"
  name="type"
  value="folder"
/>
```

### Multi-select Mode

```tsx
<Selection
  text="Feature A"
  supportingText="Enable Feature A"
  selector="checkbox"
  name="features"
  value="a"
/>
```

### Vertical Layout

```tsx
<Selection
  text="Vertical Option"
  supportingText="Vertical direction layout"
  direction="vertical"
  selector="radio"
  name="layout"
  value="vertical"
/>
```

### Controlled Component

```tsx
function ControlledSelection() {
  const [selected, setSelected] = useState('a');

  return (
    <div>
      <Selection
        text="Option A"
        checked={selected === 'a'}
        onChange={() => setSelected('a')}
        selector="radio"
        name="option"
        value="a"
      />
      <Selection
        text="Option B"
        checked={selected === 'b'}
        onChange={() => setSelected('b')}
        selector="radio"
        name="option"
        value="b"
      />
    </div>
  );
}
```

### With react-hook-form

```tsx
import { useForm } from 'react-hook-form';

function FormExample() {
  const { register } = useForm();

  return (
    <Selection
      text="Agree to Terms"
      supportingText="I have read and agree to the Terms of Service"
      selector="checkbox"
      inputRef={register('agreement').ref}
      {...register('agreement')}
    />
  );
}
```

### Disabled and Read-only

```tsx
// Disabled
<Selection
  text="Not selectable"
  disabled
  selector="radio"
  name="option"
  value="disabled"
/>

// Read-only
<Selection
  text="View only"
  readonly
  checked
  selector="radio"
  name="option"
  value="readonly"
/>
```

---

## Image Fit Modes

| Value        | Description                              |
| ------------ | ---------------------------------------- |
| `cover`      | Fill container, may crop (default)       |
| `contain`    | Show completely, may have whitespace     |
| `fill`       | Stretch to fill container                |
| `none`       | No adjustment, use original size         |
| `scale-down` | Scale down but don't scale up            |

---

## Accessibility

- `text` is required, used as the primary label
- `supportingText` is recommended for enhanced accessibility
- Automatically sets `aria-labelledby` and `aria-describedby`
- Disabled state sets `aria-disabled`

---

## Figma Mapping

| Figma Variant                 | React Props                              |
| ----------------------------- | ---------------------------------------- |
| `Selection / Radio`           | `selector="radio"` (default)             |
| `Selection / Checkbox`        | `selector="checkbox"`                    |
| `Selection / Horizontal`      | `direction="horizontal"` (default)       |
| `Selection / Vertical`        | `direction="vertical"`                   |
| `Selection / With Image`      | `image` has value                        |
| `Selection / With Icon`       | `customIcon` has value                   |
| `Selection / Disabled`        | `disabled`                               |
| `Selection / Readonly`        | `readonly`                               |

---

## Best Practices

1. **Required text**: Primary text is required for labeling and accessibility
2. **Recommend supportingText**: Provide supporting text for enhanced UX
3. **Use with RadioGroup/CheckboxGroup**: Provide `name` and `value` when used in groups
4. **react-hook-form integration**: Use `inputRef` to pass register's ref
5. **Visual consistency**: Keep the same `direction` and image/icon settings within a group
