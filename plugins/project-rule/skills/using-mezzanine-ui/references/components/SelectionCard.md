# SelectionCard Component

> **Category**: Data Entry
>
> **Storybook**: `Data Entry/SelectionCard`
>
> **Source Verification**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/react/src/SelectionCard) · Verified 1.0.3 (2026-04-21)

SelectionCard component providing selection items with images or icons. Supports single-select (radio) and multi-select (checkbox) modes.

## Import

```tsx
import { SelectionCard } from '@mezzanine-ui/react';

import type {
  SelectionCardProps,
  SelectionCardPropsBase,
} from '@mezzanine-ui/react';

// SelectionCardDirection, SelectionCardType can be imported from sub-path
import type { SelectionCardDirection, SelectionCardType } from '@mezzanine-ui/react/SelectionCard';
// SelectionCardImageObjectFit is only available from core (react/SelectionCard does not export this type)
import type { SelectionCardImageObjectFit } from '@mezzanine-ui/core/selection-card';
```

> **Note**: `SelectionCardDirection` and `SelectionCardType` are not exported from the `@mezzanine-ui/react` main entry; import from `@mezzanine-ui/react/SelectionCard` or `@mezzanine-ui/core/selection-card`.

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/?path=/docs/data-entry-selection-card--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## SelectionCardPropsBase

Base props interface, extends `Omit<NativeElementPropsWithoutKeyAndRef<'label'>, 'onChange'>`.

| Property              | Type                                                        | Default        | Description                    |
| --------------------- | ----------------------------------------------------------- | -------------- | ------------------------------ |
| `checked`             | `boolean`                                                   | -              | Controlled checked state       |
| `customIcon`          | `IconDefinition`                                            | -              | Custom icon                    |
| `defaultChecked`      | `boolean`                                                   | `false`        | Default checked state          |
| `direction`           | `SelectionCardDirection` (`'horizontal' \| 'vertical'`)     | `'horizontal'` | Layout direction               |
| `disabled`            | `boolean`                                                   | `false`        | Whether disabled               |
| `id`                  | `string`                                                    | -              | Input element id               |
| `image`               | `string`                                                    | -              | Image URL                      |
| `imageObjectFit`      | `SelectionCardImageObjectFit` (`'cover' \| 'contain' \| 'fill' \| 'none' \| 'scale-down'`) | `'cover'` | Image fit mode |
| `inputRef`            | `Ref<HTMLInputElement>`                                     | -              | Input element ref              |
| `name`                | `string`                                                    | -              | Input name attribute           |
| `onChange`            | `ChangeEventHandler<HTMLInputElement>`                      | -              | Change callback                |
| `readonly`            | `boolean`                                                   | `false`        | Whether read-only              |
| `selector`            | `SelectionCardType` (`'radio' \| 'checkbox'`)               | `'radio'`      | Selector type                  |
| `supportingText`      | `string`                                                    | -              | Supporting text                |
| `supportingTextMaxWidth` | `CSSProperties['maxWidth']`                               | -              | Max width for supporting text  |
| `text`                | `string`                                                    | **required**   | Primary text                   |
| `textMaxWidth`        | `CSSProperties['maxWidth']`                                 | -              | Max width for primary text  |
| `value`               | `string`                                                    | -              | Input value attribute          |

## SelectionCardProps

Extends `SelectionCardPropsBase` with additional:

| Property         | Type                                           | Default | Description      |
| ---------------- | ---------------------------------------------- | ------- | ---------------- |
| `onClick`        | `(event: MouseEvent<HTMLLabelElement>) => void` | -       | Click callback   |

---

## Type Definitions

```tsx
// Layout direction
type SelectionCardDirection = 'horizontal' | 'vertical';

// Selector type
type SelectionCardType = 'radio' | 'checkbox';

// Image fit mode
type SelectionCardImageObjectFit = 'cover' | 'contain' | 'fill' | 'none' | 'scale-down';
```

---

## Usage Examples

### Basic Usage

```tsx
import { SelectionCard } from '@mezzanine-ui/react';

<SelectionCard
  text="Option 1"
  supportingText="Description for option 1"
  selector="radio"
  name="option"
  value="1"
/>
```

### With Image

```tsx
<SelectionCard
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

<SelectionCard
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
<SelectionCard
  text="Feature A"
  supportingText="Enable Feature A"
  selector="checkbox"
  name="features"
  value="a"
/>
```

### Vertical Layout

```tsx
<SelectionCard
  text="Vertical Option"
  supportingText="Vertical direction layout"
  direction="vertical"
  selector="radio"
  name="layout"
  value="vertical"
/>
```

### With Text Width Constraints

```tsx
<SelectionCard
  text="Long text option that might wrap"
  supportingText="This supporting text also has a max width constraint"
  textMaxWidth="150px"
  supportingTextMaxWidth="200px"
  selector="radio"
  name="option"
  value="constrained"
/>
```

### Controlled Component

```tsx
function ControlledSelectionCard() {
  const [selected, setSelected] = useState('a');

  return (
    <div>
      <SelectionCard
        text="Option A"
        checked={selected === 'a'}
        onChange={() => setSelected('a')}
        selector="radio"
        name="option"
        value="a"
      />
      <SelectionCard
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
    <SelectionCard
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
<SelectionCard
  text="Not selectable"
  disabled
  selector="radio"
  name="option"
  value="disabled"
/>

// Read-only
<SelectionCard
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

| Figma Variant                      | React Props                              |
| ---------------------------------- | ---------------------------------------- |
| `SelectionCard / Radio`            | `selector="radio"` (default)             |
| `SelectionCard / Checkbox`         | `selector="checkbox"`                    |
| `SelectionCard / Horizontal`       | `direction="horizontal"` (default)       |
| `SelectionCard / Vertical`         | `direction="vertical"`                   |
| `SelectionCard / With Image`       | `image` has value                        |
| `SelectionCard / With Icon`        | `customIcon` has value                   |
| `SelectionCard / Disabled`         | `disabled`                               |
| `SelectionCard / Readonly`         | `readonly`                               |

---

## Best Practices

1. **Required text**: Primary text is required for labeling and accessibility
2. **Recommend supportingText**: Provide supporting text for enhanced UX
3. **Use with RadioGroup/CheckboxGroup**: Provide `name` and `value` when used in groups
4. **react-hook-form integration**: Use `inputRef` to pass register's ref
5. **Visual consistency**: Keep the same `direction` and image/icon settings within a group
