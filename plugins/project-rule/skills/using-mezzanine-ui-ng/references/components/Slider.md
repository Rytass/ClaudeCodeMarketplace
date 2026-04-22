# Slider

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/ng/slider) · Verified 1.0.0-rc.3 (2026-04-21)
>
> **Storybook**: https://storybook-ng.mezzanine-ui.org/?path=/docs/data-entry-slider--docs

A draggable slider component supporting single-value and range (two-thumb) selection modes. The mode is determined automatically from the value type: a `number` is single mode; a `[number, number]` tuple enables range mode. Supports mouse/touch dragging, optional prefix/suffix icon buttons, optional numeric inputs, and optional tick marks. Implements `ControlValueAccessor`.

## Import

```ts
import { MznSlider } from '@mezzanine-ui/ng/slider';
import type { SliderValue, RangeSliderValue } from '@mezzanine-ui/core/slider';
// SliderValue = number | RangeSliderValue
// RangeSliderValue = [number, number]
```

## Selector

`<div mznSlider ...>` — attribute-directive component

## Inputs

| Input               | Type                                   | Default     | Description                                                       |
| ------------------- | -------------------------------------- | ----------- | ----------------------------------------------------------------- |
| `value`             | `SliderValue`                          | —           | Controlled value; `number` for single, `[number, number]` for range |
| `disabled`          | `boolean`                              | `false`     | Disabled state                                                    |
| `min`               | `number`                               | `0`         | Minimum value                                                     |
| `max`               | `number`                               | `100`       | Maximum value                                                     |
| `step`              | `number`                               | `1`         | Step increment                                                    |
| `prefixIcon`        | `IconDefinition`                       | —           | Icon button before the slider                                     |
| `suffixIcon`        | `IconDefinition`                       | —           | Icon button after the slider                                      |
| `withInput`         | `boolean`                              | `false`     | Show numeric input field(s) for direct value entry                |
| `withTick`          | `number \| readonly number[]`          | —           | Tick marks: count (uniform) or specific values                    |
| `onPrefixIconClick` | `() => void`                           | —           | Custom handler for prefix icon click (overrides decrement default) |
| `onSuffixIconClick` | `() => void`                           | —           | Custom handler for suffix icon click (overrides increment default) |

> Inputs declared with signal API (`input()`) accept both static and reactive values.

## Outputs

| Output              | Type                          | Description                                       |
| ------------------- | ----------------------------- | ------------------------------------------------- |
| `valueChange`       | `OutputEmitterRef<SliderValue>` | Emitted on every value change (drag, click, input) |
| `prefixIconClick`   | `OutputEmitterRef<void>`      | Emitted when prefix icon is clicked               |
| `suffixIconClick`   | `OutputEmitterRef<void>`      | Emitted when suffix icon is clicked               |

## ControlValueAccessor

`MznSlider` implements `ControlValueAccessor` binding `SliderValue` (`number | [number, number]`).

```html
<!-- Single value with formControlName -->
<form [formGroup]="form">
  <div mznSlider formControlName="volume" [min]="0" [max]="100" [step]="1"></div>
</form>

<!-- Range with formControl -->
<div mznSlider [formControl]="priceRangeCtrl" [min]="0" [max]="10000" [step]="100"></div>

<!-- ngModel -->
<div mznSlider [(ngModel)]="brightness" [min]="0" [max]="100"></div>
```

`writeValue(SliderValue)` sets `internalValue`. For range mode, initialize the `FormControl` with a tuple: `new FormControl<[number, number]>([20, 80])`. For single mode: `new FormControl<number>(50)`.

## Usage

```html
<!-- Volume control with icons -->
<div mznSlider
  [(ngModel)]="volume"
  [min]="0"
  [max]="100"
  [prefixIcon]="VolumeLowIcon"
  [suffixIcon]="VolumeHighIcon"
  [withInput]="true">
</div>

<!-- Price range filter -->
<div mznSlider
  [formControl]="priceRangeCtrl"
  [min]="0"
  [max]="5000"
  [step]="50"
  [withTick]="4"
  [withInput]="true">
</div>

<!-- Step-based with ticks at specific values -->
<div mznSlider
  [(ngModel)]="selectedLevel"
  [min]="0"
  [max]="10"
  [withTick]="[2, 4, 6, 8]">
</div>
```

```ts
import { MznSlider } from '@mezzanine-ui/ng/slider';
import { ReactiveFormsModule, FormControl } from '@angular/forms';
import { MinusIcon, PlusIcon } from '@mezzanine-ui/icons';

@Component({
  imports: [MznSlider, ReactiveFormsModule],
})
export class PriceFilterComponent {
  readonly priceRangeCtrl = new FormControl<[number, number]>([100, 2000]);
  readonly MinusIcon = MinusIcon;
  readonly PlusIcon = PlusIcon;
}
```

## Notes

- The slider mode (single vs. range) is determined at runtime from `writeValue`'s argument type, not from an explicit prop. When using CVA, initialize the `FormControl` with the correct type.
- Drag events run outside Angular's NgZone for performance, then re-enter via `ngZone.run()` on each mouse move. This avoids excessive change detection during dragging.
- The `withInput` flag shows `MznInput` components with `variant="number"`. For range mode, two inputs are shown (start and end).
- Prefix/suffix icon buttons decrement/increment by `step` by default. Provide `[onPrefixIconClick]` / `[onSuffixIconClick]` callback inputs to override this behaviour.
- Unlike the React `<Slider>` which uses `onChange`, Angular uses CVA — no explicit `onChange` handler needed when using `formControlName` / `[(ngModel)]`.
