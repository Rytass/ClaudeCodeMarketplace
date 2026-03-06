# Dropdown Component

> **Category**: Internal
>
> **Storybook**: `Internal/Dropdown`
>
> **Source**: [GitHub Source Code](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/react/src/Dropdown)

A low-level dropdown component for displaying option lists. Typically used as the internal implementation of higher-level components like Select and AutoComplete, but can also be used independently with Button or Input. Supports flat list, grouped, and tree structures, with built-in scrolling, loading states, keyboard shortcuts, and action buttons.

## Import

```tsx
import {
  Dropdown,
  DropdownAction,
  DropdownItem,
  DropdownItemCard,
  DropdownStatus,
} from '@mezzanine-ui/react';
import type {
  DropdownProps,
  DropdownActionProps,
  DropdownItemProps,
  DropdownItemCardProps,
  DropdownStatusProps,
} from '@mezzanine-ui/react';

// Core type definitions (re-exported via @mezzanine-ui/react)
import type {
  DropdownCheckPosition,
  DropdownInputPosition,
  DropdownItemLevel,
  DropdownItemSharedProps,
  DropdownItemValidate,
  DropdownMode,
  DropdownOption,
  DropdownOptionFlat,
  DropdownOptionGrouped,
  DropdownOptionTree,
  DropdownOptionsByType,
  DropdownStatusType,
  DropdownType,
} from '@mezzanine-ui/react';

// DropdownLoadingPosition must be imported from core
import type { DropdownLoadingPosition } from '@mezzanine-ui/core/dropdown';
```

---

## Props / Sub-components

### Dropdown

Main container component, responsible for trigger element, popup positioning (Popper), toggle logic, and option rendering. Internally uses `Translate` transition and `Popper` positioning.

Extends `DropdownItemSharedProps`.

| Property                  | Type                                                                       | Default     | Description                                                                     |
| ------------------------- | -------------------------------------------------------------------------- | ----------- | ------------------------------------------------------------------------------- |
| `children`                | `ReactElement<ButtonProps> \| ReactElement<InputProps>`                    | -           | Trigger element (Button or Input)                                               |
| `options`                 | `DropdownOption[]`                                                         | `[]`        | Option list (structure varies by `type`)                                        |
| `type`                    | `DropdownType`                                                             | `'default'` | Dropdown type: `'default'` (flat) / `'grouped'` / `'tree'`                     |
| `mode`                    | `DropdownMode`                                                             | `'single'`  | Selection mode: `'single'` / `'multiple'`                                       |
| `value`                   | `string \| string[]`                                                      | -           | Selected value(s)                                                               |
| `disabled`                | `boolean`                                                                  | `false`     | Whether disabled                                                                |
| `open`                    | `boolean`                                                                  | -           | Controlled open state                                                           |
| `activeIndex`             | `number \| null`                                                          | -           | Currently highlighted option index                                              |
| `id`                      | `string`                                                                   | -           | Container DOM id                                                                |
| `inputPosition`           | `DropdownInputPosition`                                                    | `'outside'` | Input position mode: `'outside'` (popup) / `'inside'` (inline)                 |
| `isMatchInputValue`       | `boolean`                                                                  | `false`     | Whether to match input value and highlight option text                          |
| `followText`              | `string`                                                                   | -           | Custom highlight match text (takes priority over auto-extraction from children) |
| `placement`               | `PopperPlacement`                                                          | `'bottom'`  | Popup placement                                                                 |
| `customWidth`             | `number \| string`                                                        | -           | Custom dropdown width (takes priority over `sameWidth`)                         |
| `sameWidth`               | `boolean`                                                                  | `false`     | Whether to match trigger element width                                          |
| `maxHeight`               | `number \| string`                                                        | -           | Max height of dropdown list (enables scrolling when set)                        |
| `zIndex`                  | `number \| string`                                                        | `1`         | z-index                                                                         |
| `globalPortal`            | `boolean`                                                                  | `true`      | Whether to use Portal (only effective when `inputPosition='outside'`)           |
| `listboxId`               | `string`                                                                   | -           | Listbox DOM id (for ARIA)                                                       |
| `listboxLabel`            | `string`                                                                   | -           | Listbox aria-label                                                              |
| `onSelect`                | `(option: DropdownOption) => void`                                        | -           | Selection callback                                                              |
| `onOpen`                  | `() => void`                                                               | -           | Open callback                                                                   |
| `onClose`                 | `() => void`                                                               | -           | Close callback                                                                  |
| `onVisibilityChange`      | `(open: boolean) => void`                                                 | -           | Visibility change callback                                                      |
| `onItemHover`             | `(index: number) => void`                                                 | -           | Item hover callback                                                             |
| `status`                  | `DropdownStatusType`                                                       | -           | Dropdown status: `'loading'` / `'empty'`                                        |
| `loadingText`             | `string`                                                                   | -           | Loading text                                                                    |
| `emptyText`               | `string`                                                                   | -           | Empty state text                                                                |
| `emptyIcon`               | `IconDefinition`                                                           | -           | Empty state icon                                                                |
| `loadingPosition`         | `DropdownLoadingPosition`                                                  | `'full'`    | Loading position: `'full'` / `'bottom'` (append loading)                        |
| `showDropdownActions`     | `boolean`                                                                  | `false`     | Whether to show action button bar                                               |
| `toggleCheckedOnClick`    | `boolean`                                                                  | -           | Whether clicking an option row should toggle checked state in multiple mode     |
| `actionCancelText`        | `string`                                                                   | -           | Cancel button text                                                              |
| `actionConfirmText`       | `string`                                                                   | -           | Confirm button text                                                             |
| `actionClearText`         | `string`                                                                   | -           | Clear button text                                                               |
| `actionText`              | `string`                                                                   | -           | Custom button text                                                              |
| `actionCustomButtonProps` | `ButtonProps`                                                              | -           | Custom button props                                                             |
| `showActionShowTopBar`    | `boolean`                                                                  | `false`     | Whether to show separator above action bar                                      |
| `onActionConfirm`         | `() => void`                                                               | -           | Confirm button callback                                                         |
| `onActionCancel`          | `() => void`                                                               | -           | Cancel button callback                                                          |
| `onActionCustom`          | `() => void`                                                               | -           | Custom button callback                                                          |
| `onActionClear`           | `() => void`                                                               | -           | Clear button callback                                                           |
| `onReachBottom`           | `() => void`                                                               | -           | Scroll to bottom callback (requires `maxHeight`)                                |
| `onLeaveBottom`           | `() => void`                                                               | -           | Leave bottom callback                                                           |
| `onScroll`                | `(computed: { scrollTop; maxScrollTop }, target) => void`                  | -           | Scroll event callback                                                           |
| `scrollbarDefer`          | `boolean \| object`                                                       | `true`      | Whether to defer OverlayScrollbars initialization                               |
| `scrollbarDisabled`       | `boolean`                                                                  | `false`     | Disable custom scrollbar, use native scrolling                                  |
| `scrollbarMaxWidth`       | `number \| string`                                                        | -           | Scrollbar container max width                                                   |
| `scrollbarOptions`        | `PartialOptions`                                                           | -           | OverlayScrollbars additional options                                            |

---

### DropdownAction

Action button bar at the bottom of the dropdown, supporting cancel/confirm/clear/custom buttons.

| Property                  | Type          | Default    | Description                        |
| ------------------------- | ------------- | ---------- | ---------------------------------- |
| `showActions`             | `boolean`     | `false`    | Whether to show action bar         |
| `showTopBar`              | `boolean`     | `false`    | Whether to show top separator      |
| `cancelText`              | `string`      | `'Cancel'` | Cancel button text                 |
| `confirmText`             | `string`      | `'Confirm'`| Confirm button text                |
| `clearText`               | `string`      | `'Clear Options'`| Clear button text            |
| `actionText`              | `string`      | `'Custom Action'`| Custom button text           |
| `customActionButtonProps` | `ButtonProps`  | -         | Custom button props                |
| `onCancel`                | `() => void`  | -         | Cancel button callback             |
| `onConfirm`               | `() => void`  | -         | Confirm button callback            |
| `onClear`                 | `() => void`  | -         | Clear button callback (enables clear mode) |
| `onClick`                 | `() => void`  | -         | Custom button callback (enables custom mode) |

> **Action mode logic**:
> - **Default mode**: Provide both `onCancel` and `onConfirm`, shows cancel/confirm buttons.
> - **Clear mode**: Provide only `onClear` (without `onClick`), shows clear button (with CloseIcon).
> - **Custom mode**: Provide only `onClick` (without `onClear`), shows custom button.

---

### DropdownItem

Option list render container, responsible for rendering options by `type` (default / grouped / tree), and managing scrolling, status display, and action bar.

Extends `Omit<DropdownItemSharedProps, 'type'>`.

| Property           | Type                       | Default   | Description                                                         |
| ------------------ | -------------------------- | --------- | ------------------------------------------------------------------- |
| `actionConfig`     | `DropdownActionProps`      | -         | Action button configuration                                         |
| `activeIndex`      | `number \| null`          | -         | Currently highlighted option index                                  |
| `followText`       | `string`                   | -         | Highlight match text                                                |
| `headerContent`    | `ReactNode`                | -         | Custom content at the top of the list (e.g., inline mode trigger)   |
| `listboxId`        | `string`                   | -         | Listbox DOM id                                                      |
| `listboxLabel`     | `string`                   | -         | Listbox aria-label                                                  |
| `maxHeight`        | `number \| string`        | -         | List max height                                                     |
| `sameWidth`        | `boolean`                  | `false`   | Whether to match trigger element width                              |
| `onHover`          | `(index: number) => void` | -         | Option hover callback                                               |
| `options`          | `DropdownOptionsByType<T>` | -         | Option list (type depends on `type`)                                |
| `type`             | `DropdownType`             | -         | Dropdown type                                                       |
| `status`           | `DropdownStatusType`       | -         | Status: `'loading'` / `'empty'`                                     |
| `loadingText`      | `string`                   | -         | Loading text                                                        |
| `emptyText`        | `string`                   | -         | Empty state text                                                    |
| `emptyIcon`        | `IconDefinition`           | -         | Empty state icon                                                    |
| `loadingPosition`  | `DropdownLoadingPosition`  | `'full'`  | Loading position: `'full'` / `'bottom'`                             |
| `onReachBottom`    | `() => void`               | -         | Scroll to bottom callback                                           |
| `onLeaveBottom`    | `() => void`               | -         | Leave bottom callback                                               |
| `onScroll`         | `(computed, target) => void` | -       | Scroll event callback                                               |
| `scrollbarDefer`   | `boolean \| object`       | `true`    | Defer scrollbar initialization                                      |
| `scrollbarDisabled`| `boolean`                  | `false`   | Disable custom scrollbar                                            |
| `scrollbarMaxWidth`| `number \| string`        | -         | Scrollbar container max width                                       |
| `scrollbarOptions` | `PartialOptions`           | -         | OverlayScrollbars options                                           |

---

### DropdownItemCard

Single option card render component, responsible for displaying label, icon, checkbox, highlight text, and shortcut key text.

| Property          | Type                      | Default     | Description                                          |
| ----------------- | ------------------------- | ----------- | ---------------------------------------------------- |
| `active`          | `boolean`                 | `false`     | Whether currently highlighted (controls `aria-selected`) |
| `checked`         | `boolean`                 | -           | Controlled checked state                             |
| `defaultChecked`  | `boolean`                 | `false`     | Uncontrolled default checked state                   |
| `indeterminate`   | `boolean`                 | `false`     | Indeterminate state (for tree mode partial selection) |
| `disabled`        | `boolean`                 | -           | Whether disabled                                     |
| `mode`            | `DropdownMode`            | -           | Selection mode (`'single'` / `'multiple'`)           |
| `label`           | `string`                  | -           | Display label                                        |
| `name`            | `string`                  | -           | Accessible name (falls back to `label`)              |
| `subTitle`        | `string`                  | -           | Subtitle                                             |
| `id`              | `string`                  | -           | DOM id (for `aria-activedescendant`)                 |
| `level`           | `DropdownItemLevel`       | `0`         | Level (`0` / `1` / `2`, for tree mode indentation)   |
| `followText`      | `string`                  | -           | Highlight match text                                 |
| `checkSite`       | `DropdownCheckPosition`   | `'none'`    | Checkbox position: `'prefix'` / `'suffix'` / `'none'` |
| `prependIcon`     | `IconDefinition`          | -           | Prepend icon                                         |
| `appendIcon`      | `IconDefinition`          | -           | Append icon                                          |
| `appendContent`   | `string`                  | -           | Append text content (e.g., shortcut key text)        |
| `showUnderline`   | `boolean`                 | `false`     | Whether to show bottom separator                     |
| `validate`        | `DropdownItemValidate`    | `'default'` | Validation state: `'default'` / `'danger'`           |
| `className`       | `string`                  | -           | Additional className                                 |
| `onClick`         | `() => void`              | -           | Click callback                                       |
| `onCheckedChange` | `(checked: boolean) => void` | -        | Checked state change callback                        |
| `onMouseEnter`    | `() => void`              | -           | Mouse enter callback                                 |

---

### DropdownStatus

Loading and empty state display component.

| Property      | Type                 | Default                  | Description                     |
| ------------- | -------------------- | ------------------------ | ------------------------------- |
| `status`      | `DropdownStatusType` | -                        | Status: `'loading'` / `'empty'` |
| `loadingText` | `string`             | `'Loading...'`           | Loading text                    |
| `emptyText`   | `string`             | `'No matching options.'` | Empty state text                |
| `emptyIcon`   | `IconDefinition`     | `FolderOpenIcon`         | Empty state icon                |

---

## Type Definitions

```ts
// === Core types (from @mezzanine-ui/core/dropdown) ===

// Note: When imported from @mezzanine-ui/react, the name is DropdownStatusType
type DropdownStatusType = 'loading' | 'empty';
type DropdownMode = 'single' | 'multiple';
type DropdownType = 'default' | 'tree' | 'grouped';
type DropdownItemLevel = 0 | 1 | 2;
type DropdownItemValidate = 'default' | 'danger';
type DropdownCheckPosition = 'prefix' | 'suffix' | 'none';
type DropdownInputPosition = 'inside' | 'outside';
type DropdownLoadingPosition = 'full' | 'bottom';

interface DropdownOption {
  name: string;
  id: string;
  showCheckbox?: boolean;
  showUnderline?: boolean;
  icon?: IconDefinition;
  validate?: DropdownItemValidate;
  checkSite?: DropdownCheckPosition;
  children?: DropdownOption[];
  shortcutKeys?: Array<string | number>;
  shortcutText?: string;
}

// Flat option (for type='default')
type DropdownOptionFlat = Omit<DropdownOption, 'children'>;

// Grouped option (for type='grouped', children cannot be nested further)
interface DropdownOptionGrouped extends Omit<DropdownOption, 'children'> {
  children: DropdownOptionFlat[];
}

// Tree option (for type='tree', max 3 levels)
type DropdownOptionTree = DropdownOptionTreeLevel3;

// Auto-infer option type by type
type DropdownOptionsByType<T extends DropdownType | undefined> =
  T extends 'default' ? DropdownOptionFlat[]
  : T extends 'grouped' ? DropdownOptionGrouped[]
  : T extends 'tree' ? DropdownOptionTree[]
  : DropdownOption[];

interface DropdownItemSharedProps {
  disabled?: boolean;
  mode?: DropdownMode;
  onSelect?: (option: DropdownOption) => void;
  type?: DropdownType;
  value?: string | string[];
}
```

---

## Usage Examples

### Basic Usage (with Button)

```tsx
import { Dropdown, Button } from '@mezzanine-ui/react';
import type { DropdownOption } from '@mezzanine-ui/react';

const options: DropdownOption[] = [
  { id: '1', name: 'Option 1' },
  { id: '2', name: 'Option 2' },
  { id: '3', name: 'Option 3' },
];

function BasicDropdown() {
  return (
    <Dropdown
      options={options}
      onSelect={(option) => console.log('Selected:', option)}
    >
      <Button>Open Menu</Button>
    </Dropdown>
  );
}
```

### With Input (text highlighting)

```tsx
import { useState } from 'react';
import { Dropdown, Input } from '@mezzanine-ui/react';

function InputDropdown() {
  const [keyword, setKeyword] = useState('');

  return (
    <Dropdown
      options={options}
      onSelect={(option) => setKeyword(option.name)}
      isMatchInputValue
      sameWidth
    >
      <Input
        placeholder="Search..."
        value={keyword}
        onChange={(e) => setKeyword(e.target.value)}
      />
    </Dropdown>
  );
}
```

### Grouped Options

```tsx
import { Dropdown, Button } from '@mezzanine-ui/react';
import type { DropdownOptionGrouped } from '@mezzanine-ui/react';

const groupedOptions: DropdownOptionGrouped[] = [
  {
    id: 'group-1',
    name: 'Fruits',
    children: [
      { id: 'apple', name: 'Apple' },
      { id: 'banana', name: 'Banana' },
    ],
  },
  {
    id: 'group-2',
    name: 'Vegetables',
    children: [
      { id: 'carrot', name: 'Carrot' },
      { id: 'spinach', name: 'Spinach' },
    ],
  },
];

function GroupedDropdown() {
  return (
    <Dropdown
      type="grouped"
      options={groupedOptions}
      onSelect={(option) => console.log(option)}
    >
      <Button>Grouped Menu</Button>
    </Dropdown>
  );
}
```

### Tree Structure (multiple selection + checkbox)

```tsx
import { useState } from 'react';
import { Dropdown, Button } from '@mezzanine-ui/react';
import type { DropdownOptionTree } from '@mezzanine-ui/react';

const treeOptions: DropdownOptionTree[] = [
  {
    id: 'dept-1',
    name: 'Engineering',
    showCheckbox: true,
    children: [
      { id: 'team-1', name: 'Frontend Team', showCheckbox: true },
      { id: 'team-2', name: 'Backend Team', showCheckbox: true },
    ],
  },
  {
    id: 'dept-2',
    name: 'Design',
    showCheckbox: true,
    children: [
      { id: 'team-3', name: 'UI Team', showCheckbox: true },
      { id: 'team-4', name: 'UX Team', showCheckbox: true },
    ],
  },
];

function TreeDropdown() {
  const [selected, setSelected] = useState<string[]>([]);

  const handleSelect = (option: DropdownOptionTree) => {
    setSelected((prev) =>
      prev.includes(option.id)
        ? prev.filter((id) => id !== option.id)
        : [...prev, option.id],
    );
  };

  return (
    <Dropdown
      type="tree"
      mode="multiple"
      options={treeOptions}
      value={selected}
      onSelect={handleSelect}
      maxHeight={300}
    >
      <Button>Tree Multi-select</Button>
    </Dropdown>
  );
}
```

### With Action Buttons and Loading State

```tsx
import { Dropdown, Button } from '@mezzanine-ui/react';

function DropdownWithActions() {
  return (
    <Dropdown
      options={options}
      onSelect={handleSelect}
      showDropdownActions
      actionConfirmText="Confirm"
      actionCancelText="Cancel"
      onActionConfirm={handleConfirm}
      onActionCancel={handleCancel}
      showActionShowTopBar
      status={isLoading ? 'loading' : undefined}
      loadingText="Loading..."
      loadingPosition="bottom"
      maxHeight={300}
    >
      <Button>Select</Button>
    </Dropdown>
  );
}
```

### Inline Input Mode

```tsx
import { Dropdown, Input } from '@mezzanine-ui/react';

function InlineDropdown() {
  return (
    <Dropdown
      inputPosition="inside"
      options={options}
      onSelect={handleSelect}
    >
      <Input placeholder="Search..." />
    </Dropdown>
  );
}
```

### Infinite Scroll Loading

```tsx
import { useState, useCallback } from 'react';
import { Dropdown, Button } from '@mezzanine-ui/react';

function InfiniteScrollDropdown() {
  const [options, setOptions] = useState(initialOptions);
  const [loading, setLoading] = useState(false);

  const handleReachBottom = useCallback(() => {
    setLoading(true);
    fetchMoreOptions().then((newOptions) => {
      setOptions((prev) => [...prev, ...newOptions]);
      setLoading(false);
    });
  }, []);

  return (
    <Dropdown
      options={options}
      onSelect={handleSelect}
      maxHeight={300}
      onReachBottom={handleReachBottom}
      status={loading ? 'loading' : undefined}
      loadingPosition="bottom"
      loadingText="Loading more..."
    >
      <Button>Infinite Scroll</Button>
    </Dropdown>
  );
}
```

---

## Behavior Notes

- **Empty status with `loadingPosition='bottom'` (fixed in RC3)**: Previously, when `loadingPosition='bottom'` was set and `status='empty'`, the empty status did not display correctly. Since RC3, the empty status always renders as full-area regardless of `loadingPosition`, ensuring it is visible even when `loadingPosition='bottom'` is configured.

---

## Best Practices

1. **Trigger element**: Use `Button` or `Input` as `children`; other elements may cause unexpected behavior.
2. **Width control**: Use `sameWidth` to match trigger element width, or `customWidth` for fixed width.
3. **Infinite scroll**: Combine `maxHeight`, `onReachBottom`, and `loadingPosition="bottom"` for paginated loading.
4. **Tree structure limit**: Tree options support a maximum of 3 levels; deeper levels are truncated at runtime with an error message.
5. **Keyboard shortcuts**: Configure shortcuts via `DropdownOption`'s `shortcutKeys`, supporting `cmd`/`ctrl`/`alt`/`shift` modifier combinations.
6. **Action bar modes**: `onClear` and `onClick` are mutually exclusive, determining the action bar rendering mode (clear mode vs custom mode vs default mode).
7. **Controlled vs uncontrolled**: Without `open`, the component is uncontrolled (auto-manages toggle); with `open`, it is controlled.
8. **This is a low-level component**: For general use cases, prefer higher-level wrapper components like `Select`.
