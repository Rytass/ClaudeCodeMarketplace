# Radio

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/ng/radio) · Verified 1.0.0-rc.3 (2026-04-21)
>
> **Storybook**: https://storybook-ng.mezzanine-ui.org/?path=/docs/data-entry-radio--docs

A single-select radio button component supporting `radio` (standard) and `segment` (segmented control) types. Can be used standalone or within `MznRadioGroup`. The group provides a shared DI context and exposes `ControlValueAccessor` for `string` values.

`MznRadioGroup` can render radio buttons from a declarative `options` array or accept projected `mznRadio` children. Both approaches can be mixed.

## Import

```ts
import { MznRadio, MznRadioGroup, MZN_RADIO_GROUP } from '@mezzanine-ui/ng/radio';
import type {
  RadioWithInputConfig,
  RadioGroupOption,
  RadioGroupContextValue,
  RadioGroupOrientation,
} from '@mezzanine-ui/ng/radio';
import { RadioSize, RadioType } from '@mezzanine-ui/core/radio';
```

## Selector

`<div mznRadio value="..." ...>` — attribute-directive component (`value` is required)

`<div mznRadioGroup ...>` — attribute-directive component

## Inputs — MznRadio

| Input             | Type                     | Default    | Description                                               |
| ----------------- | ------------------------ | ---------- | --------------------------------------------------------- |
| `value`           | `string` (required)      | —          | The radio's string value                                  |
| `checked`         | `boolean`                | —          | Controlled checked state (standalone usage)               |
| `disabled`        | `boolean`                | `false`    | Disabled state                                            |
| `error`           | `boolean`                | `false`    | Error state styling                                       |
| `hint`            | `string`                 | —          | Secondary hint text (radio type only)                     |
| `icon`            | `IconDefinition`         | —          | Icon shown in the segment (segment type only)             |
| `name`            | `string`                 | —          | Input name attribute                                      |
| `size`            | `RadioSize`              | `'main'`   | `'main' \| 'minor'`                                       |
| `type`            | `RadioType`              | `'radio'`  | `'radio' \| 'segment'`                                    |
| `withInputConfig` | `RadioWithInputConfig`   | —          | Inline text input config shown alongside the radio button |

> Inputs declared with signal API (`input()`) accept both static and reactive values.

## Inputs — MznRadioGroup

| Input         | Type                             | Default        | Description                                              |
| ------------- | -------------------------------- | -------------- | -------------------------------------------------------- |
| `options`     | `ReadonlyArray<RadioGroupOption>`| `[]`           | Declarative option list; renders before projected children |
| `disabled`    | `boolean`                        | `false`        | Disable all radios                                       |
| `orientation` | `RadioGroupOrientation`          | `'horizontal'` | `'horizontal' \| 'vertical'`                             |
| `name`        | `string`                         | `''`           | Input name propagated to all radios                      |
| `size`        | `InputCheckSize`                 | `'main'`       | Size propagated to all radios                            |
| `type`        | `RadioType`                      | `'radio'`      | Type propagated to all radios                            |

## Outputs

| Output        | Type                       | Component       | Description                                |
| ------------- | -------------------------- | --------------- | ------------------------------------------ |
| `valueChange` | `OutputEmitterRef<string>` | `MznRadioGroup` | Emitted when the selected value changes    |

## ControlValueAccessor

Both `MznRadio` (standalone) and `MznRadioGroup` implement `ControlValueAccessor`.

**Standalone radio** — binds `string` (the radio's own `value` when selected):

```html
<div mznRadio [formControl]="colorCtrl" value="red">Red</div>
<div mznRadio [(ngModel)]="selectedColor" value="blue">Blue</div>
```

**RadioGroup** — binds `string` (the `value` of the selected radio):

```html
<form [formGroup]="form">
  <div mznRadioGroup formControlName="color" name="color">
    <div mznRadio value="red">Red</div>
    <div mznRadio value="blue">Blue</div>
    <div mznRadio value="green">Green</div>
  </div>
</form>

<div mznRadioGroup [(ngModel)]="selectedColor" name="color">
  <div mznRadio value="red">Red</div>
  <div mznRadio value="blue">Blue</div>
</div>
```

`MznRadio.writeValue(string)` stores the group value in an internal signal and computes `resolvedChecked = group.value() === this.value()`. `MznRadioGroup.writeValue(string | null)` sets the internal value signal; `null` becomes `''`.

## Usage

```html
<!-- Segmented control group via options array -->
<div mznRadioGroup
  formControlName="plan"
  name="plan"
  type="segment"
  [options]="[
    { id: 'free', name: 'Free' },
    { id: 'pro', name: 'Pro' },
    { id: 'enterprise', name: 'Enterprise', disabled: true }
  ]">
</div>

<!-- Vertical radio group with hints -->
<div mznRadioGroup [(ngModel)]="shippingMethod" name="shipping" orientation="vertical">
  <div mznRadio value="standard" hint="3-5 business days">Standard</div>
  <div mznRadio value="express" hint="1-2 business days">Express</div>
  <div mznRadio value="overnight" hint="Next business day">Overnight</div>
</div>
```

```ts
import { MznRadio, MznRadioGroup } from '@mezzanine-ui/ng/radio';
import { ReactiveFormsModule, FormControl } from '@angular/forms';

@Component({
  imports: [MznRadio, MznRadioGroup, ReactiveFormsModule],
})
export class PlanSelectorComponent {
  readonly planCtrl = new FormControl('free');
}
```

## Notes

- When radios are inside a group, the group's `MZN_RADIO_GROUP` DI token provides shared state. The radio's `select(value)` call on change bubbles up through the group's CVA `onChange`.
- For `segment` type, icons can be provided via the `icon` input (individual radio) or the `icon` field in `RadioGroupOption`.
- `withInputConfig` shows an adjacent `MznInput` (base variant) that auto-focuses when the radio is selected. This is a React parity feature for "Other: [input]" patterns.
- Unlike `MznCheckboxGroup` which binds `string[]`, `MznRadioGroup` binds a single `string` — reflecting radio's mutually exclusive selection.
