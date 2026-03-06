# FilterArea Component

> **Category**: Data Entry
>
> **Storybook**: `Data Entry/FilterArea`
>
> **Source**: [GitHub Source Code](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/react/src/FilterArea) | Verified: 2026-03-06

A filter area component for building search and filter forms. Contains three sub-components: FilterArea, FilterLine, and Filter. Expand/collapse buttons use `ChevronDownIcon` / `ChevronUpIcon`.

## Import

```tsx
import { FilterArea, FilterLine, Filter } from '@mezzanine-ui/react';
import type { FilterAreaProps, FilterLineProps, FilterProps } from '@mezzanine-ui/react';
```

---

## FilterArea Props

`FilterAreaProps` extends `Omit<NativeElementPropsWithoutKeyAndRef<'div'>, 'children' | 'onSubmit' | 'onReset'>`.

| Property           | Type                                                     | Default    | Description              |
| ------------------ | -------------------------------------------------------- | ---------- | ------------------------ |
| `actionsAlign`     | `FilterAreaActionsAlign`                                 | `'end'`    | Action button alignment  |
| `children`         | `ReactElement<FilterLineProps> \| ReactElement<FilterLineProps>[]` | **Required** | FilterLine children |
| `isDirty`          | `boolean`                                                | `true`     | Whether form is modified |
| `onReset`          | `() => void`                                             | -          | Reset callback           |
| `onSubmit`         | `() => void`                                             | -          | Submit callback          |
| `resetText`        | `string`                                                 | `'Reset'`  | Reset button text        |
| `size`             | `FilterAreaSize`                                         | `'main'`   | Size                     |
| `submitText`       | `string`                                                 | `'Search'` | Submit button text       |
| `resetButtonType`  | `ComponentPropsWithoutRef<'button'>['type']`             | `'button'` | Reset button type        |
| `submitButtonType` | `ComponentPropsWithoutRef<'button'>['type']`             | `'button'` | Submit button type       |

> **Core types**:
> - `FilterAreaActionsAlign = 'start' | 'center' | 'end'`
> - `FilterAreaSize = 'main' | 'sub'`

---

## FilterLine Props

`FilterLineProps` extends `Omit<NativeElementPropsWithoutKeyAndRef<'div'>, 'children'>`.

| Property   | Type                                                        | Description       |
| ---------- | ----------------------------------------------------------- | ----------------- |
| `children` | `ReactElement<FilterProps> \| ReactElement<FilterProps>[]`  | Filter children   |

---

## Filter Props

`FilterProps` extends `Omit<NativeElementPropsWithoutKeyAndRef<'div'>, 'children'>`.

| Property   | Type                                                              | Default     | Description                     |
| ---------- | ----------------------------------------------------------------- | ----------- | ------------------------------- |
| `align`    | `FilterAlign`                                                     | `'stretch'` | Vertical alignment              |
| `children` | `ReactElement<FormFieldProps> \| ReactElement<FormFieldProps>[]`  | **Required** | FormField children             |
| `grow`     | `boolean`                                                         | `false`     | Whether to auto-expand to fill  |
| `minWidth` | `string \| number`                                                | -           | Minimum width                   |
| `span`     | `FilterSpan`                                                      | `2`         | Grid columns to span            |

> **Core types**:
> - `FilterAlign = 'start' | 'center' | 'end' | 'stretch'`
> - `FilterSpan = 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12`

---

## Usage Examples

### Basic Usage

```tsx
import { FilterArea, FilterLine, Filter, FormField, Input, Select } from '@mezzanine-ui/react';

<FilterArea
  onSubmit={handleSearch}
  onReset={handleReset}
  submitText="Search"
  resetText="Reset"
>
  <FilterLine>
    <Filter>
      <FormField label="Name">
        <Input placeholder="Enter name" />
      </FormField>
    </Filter>
    <Filter>
      <FormField label="Status">
        <Select options={statusOptions} placeholder="Select" />
      </FormField>
    </Filter>
  </FilterLine>
</FilterArea>
```

### Multi-line Filter (expandable)

```tsx
<FilterArea
  onSubmit={handleSearch}
  onReset={handleReset}
>
  <FilterLine>
    <Filter>
      <FormField label="Name">
        <Input />
      </FormField>
    </Filter>
    <Filter>
      <FormField label="Status">
        <Select options={statusOptions} />
      </FormField>
    </Filter>
  </FilterLine>
  <FilterLine>
    <Filter>
      <FormField label="Date">
        <DatePicker />
      </FormField>
    </Filter>
    <Filter>
      <FormField label="Type">
        <Select options={typeOptions} />
      </FormField>
    </Filter>
  </FilterLine>
</FilterArea>
```

### Custom Field Width

```tsx
<FilterArea onSubmit={handleSearch}>
  <FilterLine>
    <Filter span={3}>
      <FormField label="Keyword">
        <Input />
      </FormField>
    </Filter>
    <Filter span={2}>
      <FormField label="Status">
        <Select options={statusOptions} />
      </FormField>
    </Filter>
    <Filter grow>
      <FormField label="Notes">
        <Input />
      </FormField>
    </Filter>
  </FilterLine>
</FilterArea>
```

### With react-hook-form

```tsx
import { useForm, FormProvider } from 'react-hook-form';

function FilterExample() {
  const methods = useForm({
    defaultValues: { name: '', status: '' },
  });

  const handleSearch = methods.handleSubmit((data) => {
    console.log(data);
  });

  const handleReset = () => {
    methods.reset();
  };

  return (
    <FormProvider {...methods}>
      <form onSubmit={handleSearch}>
        <FilterArea
          onSubmit={handleSearch}
          onReset={handleReset}
          isDirty={methods.formState.isDirty}
          submitButtonType="submit"
        >
          <FilterLine>
            <Filter>
              <FormField label="Name">
                <Input {...methods.register('name')} />
              </FormField>
            </Filter>
          </FilterLine>
        </FilterArea>
      </form>
    </FormProvider>
  );
}
```

### Control Reset Button State

```tsx
<FilterArea
  onSubmit={handleSearch}
  onReset={handleReset}
  isDirty={formState.isDirty}  // Disable reset button when not modified
>
  <FilterLine>
    <Filter>
      <FormField label="Search">
        <Input />
      </FormField>
    </Filter>
  </FilterLine>
</FilterArea>
```

---

## Expand/Collapse Behavior

- When there are multiple FilterLines, an expand/collapse button is displayed
- Collapsed state shows only the first line
- Expanded state shows all filter lines

---

## Grid System

The Filter component uses a 12-column grid system:
- `span={2}` takes 2/12 width (default)
- `span={12}` takes full row
- `grow` auto-expands to fill remaining space

---

## Figma Mapping

| Figma Variant                 | React Props                              |
| ----------------------------- | ---------------------------------------- |
| `FilterArea / Collapsed`      | Default state for multi-line             |
| `FilterArea / Expanded`       | Expanded state                           |
| `FilterArea / Single Line`    | Single line filter                       |

---

## Best Practices

1. **Common filters first**: Place the most frequently used filters in the first line
2. **Reasonable width**: Use `span` to control field width for visual balance
3. **Reset state**: Use `isDirty` to control the reset button's enabled state
4. **Use with form libraries**: Recommended to use with react-hook-form for form state management
5. **Semantic text**: Customize button text based on scenario (Search/Filter/Query)
