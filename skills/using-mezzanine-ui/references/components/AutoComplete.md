# AutoComplete Component

> **Category**: Data Entry
>
> **Storybook**: `Data Entry/AutoComplete`
>
> **Source Verification**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/react/src/AutoComplete) | Verification date: 2026-02-13

Autocomplete component combining input with dropdown menu. Supports search filtering and dynamic option creation. Internally uses `Dropdown` and `SelectTrigger` composition.

## Import

```tsx
import { AutoComplete } from '@mezzanine-ui/react';
import type {
  AutoCompleteBaseProps,
  AutoCompleteMultipleProps,
  AutoCompleteProps,
  AutoCompleteSingleProps,
} from '@mezzanine-ui/react';
```

---

## Type Definitions

```tsx
// AutoCompleteProps is a discriminated union
type AutoCompleteProps = AutoCompleteSingleProps | AutoCompleteMultipleProps;
```

---

## AutoComplete Props (Common AutoCompleteBaseProps)

| Property                     | Type                                                   | Default                | Description                              |
| ---------------------------- | ------------------------------------------------------ | ---------------------- | ---------------------------------------- |
| `addable`                    | `boolean`                                              | `false`                | Whether options can be dynamically added |
| `asyncData`                  | `boolean`                                              | `false`                | Whether data is async                    |
| `clearSearchText`            | `boolean`                                              | `true`                 | Whether to clear search text on blur     |
| `createSeparators`           | `string[]`                                             | `[',', '+', '\n']`     | Separator characters for creating options |
| `createActionText`           | `(text: string) => string`                             | -                      | Custom create button text function       |
| `createActionTextTemplate`   | `string`                                               | `'建立 "{text}"'`      | Create button text template              |
| `disabledOptionsFilter`      | `boolean`                                              | `false`                | Disable built-in filtering               |
| `dropdownZIndex`             | `number \| string`                                     | -                      | Dropdown z-index                         |
| `emptyText`                  | `string`                                               | -                      | Empty result hint text                   |
| `globalPortal`               | `boolean`                                              | `true`                 | Whether to enable Portal                 |
| `id`                         | `string`                                               | -                      | Input element id attribute               |
| `inputPosition`              | `DropdownInputPosition`                                | `'outside'`            | Input position                           |
| `inputProps`                 | `Omit<SelectTriggerInputProps, 'onChange' \| 'placeholder' \| 'role' \| 'value' \| 'aria-*'>` | - | Props passed to input element |
| `loading`                    | `boolean`                                              | `false`                | Whether loading                          |
| `loadingText`                | `string`                                               | -                      | Loading hint text                        |
| `loadingPosition`            | `DropdownLoadingPosition`                              | `'bottom'`             | Loading state display position           |
| `menuMaxHeight`              | `number \| string`                                     | -                      | Dropdown max height                      |
| `name`                       | `string`                                               | -                      | Input element name attribute             |
| `onInsert`                   | `(text: string, currentOptions: SelectValue[]) => SelectValue[]` | -            | Insert option callback                   |
| `onLeaveBottom`              | `() => void`                                           | -                      | Dropdown leave bottom callback           |
| `onReachBottom`              | `() => void`                                           | -                      | Dropdown reach bottom callback           |
| `onSearch`                   | `(input: string) => void \| Promise<void>`             | -                      | Search callback                          |
| `onSearchTextChange`         | `(text: string) => void`                               | -                      | Input text change callback (no debounce) |
| `onVisibilityChange`         | `(open: boolean) => void`                              | -                      | Dropdown visibility change callback      |
| `open`                       | `boolean`                                              | -                      | Controlled dropdown open state           |
| `options`                    | `SelectValue[]`                                        | **required**           | Options list                             |
| `placeholder`                | `string`                                               | `''`                   | Placeholder text                         |
| `popperOptions`              | `PopperProps['options']`                               | -                      | Popper options                           |
| `required`                   | `boolean`                                              | `false`                | Whether required                         |
| `searchDebounceTime`         | `number`                                               | `300`                  | Search debounce time (ms)                |
| `searchTextControlRef`       | `RefObject<{ reset: () => void; setSearchText: Dispatch<SetStateAction<string>> } \| undefined>` | - | Ref for external search text control |
| `trimOnCreate`               | `boolean`                                              | `true`                 | Whether to trim whitespace on create     |

> Also inherits `SelectTriggerProps` (excluding `active`, `clearable`, `forceHideSuffixActionIcon`, `mode`, `onClick`, `onKeyDown`, `onChange`, `renderValue`, `inputProps`, `suffixActionIcon`, `value`), including `className`, `disabled`, `error`, `fullWidth`, `inputRef`, `onClear`, `prefix`, `size`, etc.

---

## Single Mode Props

| Property       | Type                                    | Default    | Description          |
| -------------- | --------------------------------------- | ---------- | -------------------- |
| `mode`         | `'single'`                              | `'single'` | Single select mode   |
| `value`        | `SelectValue \| null`                   | -          | Selected value       |
| `defaultValue` | `SelectValue`                           | -          | Default value        |
| `onChange`      | `(newOptions: SelectValue) => void`     | -          | Change event         |
| `selector`     | `AutoCompleteSelector`                  | `'input'`  | Input selector type  |

---

## Multiple Mode Props

| Property            | Type                                  | Default     | Description          |
| ------------------- | ------------------------------------- | ----------- | -------------------- |
| `mode`              | `'multiple'`                          | -           | Multiple mode (required) |
| `value`             | `SelectValue[]`                       | -           | Selected values array |
| `defaultValue`      | `SelectValue[]`                       | -           | Default values array |
| `onChange`           | `(newOptions: SelectValue[]) => void` | -           | Change event         |
| `overflowStrategy`  | `'counter' \| 'wrap'`                | `'counter'` | Tag overflow strategy |
| `selector`          | `AutoCompleteSelector`                | `'input'`   | Input selector type  |

---

## Usage Examples

### Basic Usage (Single)

```tsx
import { AutoComplete } from '@mezzanine-ui/react';
import { useState } from 'react';

const options = [
  { id: '1', name: 'Option 1' },
  { id: '2', name: 'Option 2' },
  { id: '3', name: 'Option 3' },
];

function BasicAutoComplete() {
  const [value, setValue] = useState<SelectValue | null>(null);

  return (
    <AutoComplete
      options={options}
      value={value}
      onChange={setValue}
      placeholder="Search..."
    />
  );
}
```

### Multiple Mode

```tsx
function MultipleAutoComplete() {
  const [values, setValues] = useState<SelectValue[]>([]);

  return (
    <AutoComplete
      mode="multiple"
      options={options}
      value={values}
      onChange={setValues}
      placeholder="Select..."
    />
  );
}
```

### Async Search

```tsx
function AsyncAutoComplete() {
  const [options, setOptions] = useState<SelectValue[]>([]);
  const [value, setValue] = useState<SelectValue | null>(null);

  const handleSearch = async (input: string) => {
    const result = await api.searchUsers(input);
    setOptions(result.map((user) => ({
      id: user.id,
      name: user.name,
    })));
  };

  return (
    <AutoComplete
      asyncData
      options={options}
      value={value}
      onChange={setValue}
      onSearch={handleSearch}
      placeholder="Search users..."
      loadingText="Searching..."
      emptyText="No results found"
    />
  );
}
```

### Addable Options

```tsx
function AddableAutoComplete() {
  const [options, setOptions] = useState([
    { id: '1', name: 'React' },
    { id: '2', name: 'Vue' },
  ]);
  const [values, setValues] = useState<SelectValue[]>([]);

  const handleInsert = (text: string, currentOptions: SelectValue[]) => {
    const newOption = { id: `new-${Date.now()}`, name: text };
    return [...currentOptions, newOption];
  };

  return (
    <AutoComplete
      mode="multiple"
      addable
      options={options}
      value={values}
      onChange={(newValues) => {
        setValues(newValues);
        const newOptions = newValues.filter(
          (v) => !options.some((o) => o.id === v.id)
        );
        setOptions([...options, ...newOptions]);
      }}
      onInsert={handleInsert}
      placeholder="Enter tags..."
      createActionTextTemplate='Create "{text}"'
    />
  );
}
```

### Custom Search Logic

```tsx
function CustomFilterAutoComplete() {
  const [value, setValue] = useState<SelectValue | null>(null);
  const [filteredOptions, setFilteredOptions] = useState(allOptions);

  const handleSearch = (input: string) => {
    const filtered = allOptions.filter((opt) =>
      opt.name.toLowerCase().includes(input.toLowerCase())
    );
    setFilteredOptions(filtered);
  };

  return (
    <AutoComplete
      disabledOptionsFilter
      options={filteredOptions}
      value={value}
      onChange={setValue}
      onSearch={handleSearch}
      placeholder="Search..."
    />
  );
}
```

### SearchTextControlRef

The `searchTextControlRef` provides imperative control over the search text:
- `setSearchText('')` — clears input text only, leaving selected values and dropdown state unchanged.
- `reset()` — fully resets: clears search text, cancels pending searches, and re-triggers an empty search to restore options.

```tsx
import { AutoComplete, Button } from '@mezzanine-ui/react';
import { Dispatch, SetStateAction, useRef, useState } from 'react';

type SearchTextControlRef = {
  reset: () => void;
  setSearchText: Dispatch<SetStateAction<string>>;
};

function SubmitWithReset() {
  const [value, setValue] = useState<SelectValue[]>([]);
  const [submitted, setSubmitted] = useState<SelectValue[]>([]);
  const controlRef = useRef<SearchTextControlRef | undefined>(undefined);

  const handleSubmit = () => {
    if (!value.length) return;
    setSubmitted((prev) => [...prev, ...value]);
    setValue([]);
    controlRef.current?.reset();
  };

  return (
    <div style={{ display: 'flex', gap: '8px', alignItems: 'center' }}>
      <AutoComplete
        fullWidth
        mode="multiple"
        onChange={setValue}
        options={originOptions}
        placeholder="選取項目後送出"
        searchTextControlRef={controlRef}
        value={value}
      />
      <Button disabled={!value.length} onClick={handleSubmit}>
        送出
      </Button>
    </div>
  );
}
```

### With FormField

```tsx
<FormField
  name="tags"
  label="Tags"
  layout="vertical"
>
  <AutoComplete
    mode="multiple"
    options={tagOptions}
    value={selectedTags}
    onChange={setSelectedTags}
    placeholder="Select or add tags..."
    addable
    onInsert={handleInsert}
  />
</FormField>
```

---

## Related Type Definitions

```tsx
interface SelectValue {
  id: string;
  name: string;
}

// Input selector mode
type AutoCompleteSelector = 'input' | 'selection';
```

---

## Figma Mapping

| Figma Variant                    | React Props                                  |
| -------------------------------- | -------------------------------------------- |
| `AutoComplete / Single`          | `mode="single"`                              |
| `AutoComplete / Multiple`        | `mode="multiple"`                            |
| `AutoComplete / With Tags`       | `mode="multiple"` (selected items as Tags)   |
| `AutoComplete / Addable`         | `addable`                                    |
| `AutoComplete / Loading`         | `loading`                                    |

---

## Best Practices

1. **Provide sufficient options**: Display commonly used options initially
2. **Async search**: Use `asyncData` + `onSearch` for large datasets
3. **Debounce settings**: Adjust `searchDebounceTime` for performance optimization
4. **Custom create text**: Use `createActionText` for clear prompts
5. **Empty result hint**: Set `emptyText` to avoid blank screens
