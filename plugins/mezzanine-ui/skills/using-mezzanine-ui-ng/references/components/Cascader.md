# Cascader

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/ng/cascader) · Verified 1.0.0-rc.3 (2026-04-21)
>
> **Storybook**: https://storybook-ng.mezzanine-ui.org/?path=/docs/data-entry-cascader--docs

A cascading dropdown selector for hierarchical data. Each selection of a non-leaf node opens a new panel for the next level. Selecting a leaf node closes the panel and emits `valueChange` with the full selection path. The display value shows the path as `A / B / C`; when the display overflows the trigger width and the path has 3+ nodes, intermediate items are collapsed to `A / ... / C`.

Note: `MznCascader` does **not** implement `ControlValueAccessor` — it uses a controlled `value` + `valueChange` pattern.

## Import

```ts
import { MznCascader, MznCascaderPanel } from '@mezzanine-ui/ng/cascader';
import type { CascaderOption } from '@mezzanine-ui/ng/cascader';
import { CascaderSize } from '@mezzanine-ui/core/cascader';
```

## Selector

`<div mznCascader [options]="..." ...>` — attribute-directive component (`options` is required)

## Inputs

| Input           | Type                     | Default  | Description                                                          |
| --------------- | ------------------------ | -------- | -------------------------------------------------------------------- |
| `options`       | `CascaderOption[]` (required) | —   | Root option tree; `CascaderOption = { id: string, name: string, children?: CascaderOption[], disabled?: boolean }` |
| `value`         | `CascaderOption[]`       | —        | Currently selected path (array from root to leaf)                    |
| `placeholder`   | `string`                 | —        | Placeholder when no selection                                        |
| `disabled`      | `boolean`                | `false`  | Disabled state                                                       |
| `error`         | `boolean`                | `false`  | Error state styling                                                  |
| `fullWidth`     | `boolean`                | `false`  | Stretch to container width                                           |
| `readOnly`      | `boolean`                | `false`  | Read-only state                                                      |
| `clearable`     | `boolean`                | `false`  | Show clear button when a value is selected                           |
| `size`          | `CascaderSize`           | `'main'` | `'main' \| 'sub'`                                                    |
| `menuMaxHeight` | `string \| number`       | —        | Max height of cascader panels (px)                                   |
| `required`      | `boolean`                | `false`  | Required state                                                       |
| `dropdownZIndex`| `number \| string`       | —        | z-index for the panel                                                |
| `globalPortal`  | `boolean`                | —        | Render panel in a body-level portal                                  |

> Inputs declared with signal API (`input()`) accept both static and reactive values.

## Outputs

| Output           | Type                              | Description                                            |
| ---------------- | --------------------------------- | ------------------------------------------------------ |
| `valueChange`    | `OutputEmitterRef<CascaderOption[]>` | Emitted with the full path when a leaf is selected or cleared |
| `cascaderFocus`  | `OutputEmitterRef<void>`          | Emitted when the dropdown opens                        |
| `cascaderBlur`   | `OutputEmitterRef<void>`          | Emitted when the dropdown closes                       |

## ControlValueAccessor

`MznCascader` does **not** implement `ControlValueAccessor`. Use `[value]` + `(valueChange)` for controlled binding, or manage state via a parent component.

```html
<!-- Controlled pattern -->
<div mznCascader
  [options]="regionTree"
  [value]="selectedRegion"
  (valueChange)="selectedRegion = $event"
  placeholder="Select region">
</div>

<!-- With reactive form via manual binding -->
<div mznCascader
  [options]="categoryTree"
  [value]="resolvedCategoryPath"
  (valueChange)="onCategoryChange($event)"
  [clearable]="true">
</div>
```

## Usage

```html
<div mznFormField name="category" label="Category">
  <div mznCascader
    [options]="categoryOptions"
    [value]="selectedCategory"
    (valueChange)="onCategorySelect($event)"
    placeholder="Select category"
    [fullWidth]="true"
    [clearable]="true">
  </div>
</div>
```

```ts
import { MznCascader } from '@mezzanine-ui/ng/cascader';
import type { CascaderOption } from '@mezzanine-ui/ng/cascader';

@Component({
  imports: [MznCascader, MznFormField],
})
export class CategoryPickerComponent {
  readonly categoryOptions: CascaderOption[] = [
    {
      id: 'electronics',
      name: 'Electronics',
      children: [
        { id: 'phones', name: 'Phones', children: [
          { id: 'smartphones', name: 'Smartphones' },
          { id: 'feature-phones', name: 'Feature Phones' },
        ]},
        { id: 'laptops', name: 'Laptops' },
      ],
    },
    { id: 'clothing', name: 'Clothing' },
  ];

  selectedCategory: CascaderOption[] = [];

  onCategorySelect(path: CascaderOption[]): void {
    this.selectedCategory = path;
    // For reactive forms, manually patch:
    // this.form.get('category')?.setValue(path.map(o => o.id).join('/'));
  }
}
```

## MznCascaderPanel

A single-column option panel that renders one level of a cascader hierarchy. Used internally by `MznCascader` but publicly exported for standalone usage (e.g. custom cascader layouts).

**Selector**: `[mznCascaderPanel]`

| Input              | Type                   | Default | Description                                          |
| ------------------ | ---------------------- | ------- | ---------------------------------------------------- |
| `activeOptionId`   | `string \| undefined`  | —       | ID of the currently expanded (active) option         |
| `focusedOptionId`  | `string \| undefined`  | —       | ID of the keyboard-focused option                    |
| `options`          | `CascaderOption[]`     | `[]`    | Options to display in this panel                     |
| `selectedOptionId` | `string \| undefined`  | —       | ID of the currently selected leaf option             |

| Output         | Type                              | Description                                 |
| -------------- | --------------------------------- | ------------------------------------------- |
| `optionSelect` | `OutputEmitterRef<CascaderOption>` | Emitted when the user clicks an option (disabled options are suppressed) |

```html
<!-- Standalone panel usage -->
<div mznCascaderPanel
  [options]="levelOptions"
  [activeOptionId]="activeId"
  [selectedOptionId]="selectedId"
  (optionSelect)="onSelect($event)">
</div>
```

## Notes

- `MznCascader` is **not** a CVA — this is a notable difference from `MznSelect` and `MznAutocomplete`. To use with `ReactiveFormsModule`, bridge it manually: listen to `(valueChange)` and call `formControl.setValue(...)`.
- The `value` input accepts the full path array (not just the leaf id), matching the React counterpart's API where `value: string[]` holds ids of the selected path.
- The overflow collapse (showing `A / ... / C`) uses a hidden `<span>` measurement element and `ResizeObserver` to detect when the full path text exceeds the trigger width.
- When `globalPortal` is not set, the panel may be clipped by ancestor `overflow: hidden` containers. Set `[globalPortal]="true"` (or rely on the `MznInputTriggerPopper` default) in such cases.
- Overlay positioning and panel close-on-outside-click are handled by `MznInputTriggerPopper` inside `MznCascader`, not by `ClickAwayService` directly.
