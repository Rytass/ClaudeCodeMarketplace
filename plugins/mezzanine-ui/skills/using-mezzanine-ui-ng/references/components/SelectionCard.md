# SelectionCard

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/ng/selection-card) · Verified 1.0.0-rc.4 (2026-04-24)
>
> **Storybook**: https://storybook-ng.mezzanine-ui.org/?path=/docs/data-entry-selection-card--docs

A visual card-based selection component that wraps a native `<input type="radio">` or `<input type="checkbox">`. Each card displays an icon or image, a primary text, and an optional supporting text. Supports horizontal and vertical layout directions. Implements `ControlValueAccessor` binding `boolean` values.

For radio-group behaviour across multiple `SelectionCard` instances, set the same `name` attribute — the browser handles mutual exclusion natively.

## Import

```ts
import { MznSelectionCard } from '@mezzanine-ui/ng/selection-card';
import {
  SelectionCardDirection,
  SelectionCardType,
  SelectionCardImageObjectFit,
} from '@mezzanine-ui/core/selection-card';
```

## Selector

`<label mznSelectionCard ...>` — attribute-directive component

## Inputs

| Input                    | Type                          | Default        | Description                                              |
| ------------------------ | ----------------------------- | -------------- | -------------------------------------------------------- |
| `selector`               | `SelectionCardType`           | `'radio'`      | `'radio' \| 'checkbox'`                                  |
| `text`                   | `string`                      | `''`           | Primary card text                                        |
| `supportingText`         | `string`                      | —              | Secondary description text                               |
| `checked`                | `boolean`                     | —              | Controlled checked state                                 |
| `defaultChecked`         | `boolean`                     | `false`        | Initial uncontrolled checked state                       |
| `customIcon`             | `IconDefinition`              | —              | Custom icon; defaults to `FileIcon`                      |
| `direction`              | `SelectionCardDirection`      | `'horizontal'` | `'horizontal' \| 'vertical'`                             |
| `disabled`               | `boolean`                     | `false`        | Disabled state                                           |
| `image`                  | `string`                      | —              | Image URL; shown instead of icon when provided           |
| `imageObjectFit`         | `SelectionCardImageObjectFit` | `'cover'`      | CSS `object-fit` for the image                           |
| `name`                   | `string`                      | —              | Native input `name` for radio group sync                 |
| `readonly`               | `boolean`                     | `false`        | Readonly — hides the native input entirely               |
| `textMaxWidth`           | `string`                      | —              | Max width for the primary text                           |
| `supportingTextMaxWidth` | `string`                      | —              | Max width for the supporting text                        |
| `value`                  | `string`                      | `''`           | Native input `value`                                     |

> Inputs declared with signal API (`input()`) accept both static and reactive values.

## Outputs

| Output    | Type                         | Description                        |
| --------- | ---------------------------- | ---------------------------------- |
| `onClick` | `OutputEmitterRef<MouseEvent>` | Emitted when the card label is clicked |

## ControlValueAccessor

`MznSelectionCard` implements `ControlValueAccessor` binding `boolean`.

```html
<!-- Checkbox mode with formControlName -->
<form [formGroup]="form">
  <label mznSelectionCard
    selector="checkbox"
    formControlName="hasNewsletterSub"
    text="Newsletter"
    supportingText="Weekly updates">
  </label>
</form>

<!-- Radio group using name for native sync + ngModel per card -->
<label mznSelectionCard
  selector="radio"
  name="plan"
  value="free"
  [(ngModel)]="isPlanFree"
  text="Free Plan"
  supportingText="Basic features">
</label>
<label mznSelectionCard
  selector="radio"
  name="plan"
  value="pro"
  [(ngModel)]="isPlanPro"
  text="Pro Plan"
  supportingText="All features">
</label>
```

`writeValue(boolean)` sets `internalChecked`. The component also listens to document-level `change` events for `selector === 'radio'` to detect when sibling radio buttons in the same `name` group are selected, keeping `internalChecked` in sync across radio instances.

## Usage

```html
<!-- Vertical image cards for product selection -->
<label mznSelectionCard
  selector="checkbox"
  direction="vertical"
  [(ngModel)]="planA"
  [image]="'/assets/plan-a.png'"
  text="Starter Plan"
  supportingText="Up to 5 users"
  imageObjectFit="contain">
</label>

<!-- Horizontal icon cards in a group -->
<div style="display: flex; gap: 12px;">
  <label mznSelectionCard
    selector="radio"
    name="delivery"
    value="standard"
    [(ngModel)]="isStandard"
    [customIcon]="truckIcon"
    text="Standard"
    supportingText="3-5 days">
  </label>
  <label mznSelectionCard
    selector="radio"
    name="delivery"
    value="express"
    [(ngModel)]="isExpress"
    [customIcon]="rocketIcon"
    text="Express"
    supportingText="1-2 days">
  </label>
</div>
```

```ts
import { MznSelectionCard } from '@mezzanine-ui/ng/selection-card';

@Component({
  imports: [MznSelectionCard, FormsModule],
})
export class DeliveryPickerComponent {
  isStandard = true;
  isExpress = false;
}
```

## Notes

- Each `MznSelectionCard` CVA binds `boolean`, not the radio group value. For radio groups, manage the selected option at the parent level by listening to `onClick` or using individual `[(ngModel)]` per card with the same `name`.
- When `selector === 'radio'`, `ngAfterViewInit` installs a document-level `change` event listener to sync the `internalChecked` state when the browser unchecks sibling radios (the browser does not emit a `change` event on unchecked radios).
- Setting `[readonly]="true"` hides the native `<input>` entirely, so the card cannot be toggled via click.
- Unlike `MznCheckbox` and `MznRadio`, `MznSelectionCard` does not have a corresponding group component. Group behaviour for radio cards relies on the native browser radio-group mechanism via `name`.
