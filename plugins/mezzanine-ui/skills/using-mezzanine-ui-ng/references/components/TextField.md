# TextField

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/ng/text-field) · Verified 1.0.0-rc.3 (2026-04-21)
>
> **Storybook**: https://storybook-ng.mezzanine-ui.org/?path=/docs/data-entry-text-field--docs

A low-level field container component that wraps a native `<input>` or `<textarea>` and provides prefix/suffix slots, a clearable button, and state-driven styling (focused, hovered, error, disabled, etc.). Higher-level components like `MznInput` and `MznTextarea` use `MznTextField` internally — you rarely need to use it directly, but it is useful for building custom compound inputs.

`MznTextField` uses `hostDirectives` to apply `MznTextFieldHost`, which tracks focus, hover, typing, and value state by listening to DOM events on the descendant `<input>` or `<textarea>`.

## Import

```ts
import { MznTextField } from '@mezzanine-ui/ng/text-field';
import { MznTextFieldHost } from '@mezzanine-ui/ng/text-field';
import { TextFieldSize } from '@mezzanine-ui/core/text-field';
```

## Selector

`<div mznTextField ...>` — attribute-directive component (with `MznTextFieldHost` applied via `hostDirectives`)

## Inputs

The following inputs are forwarded to `MznTextFieldHost` via `hostDirectives`:

| Input        | Type              | Default   | Description                                                   |
| ------------ | ----------------- | --------- | ------------------------------------------------------------- |
| `active`     | `boolean`         | `false`   | Force active/open styling regardless of focus                 |
| `clearable`  | `boolean`         | `false`   | Show clear button when field has a value and is hovered/focused |
| `disabled`   | `boolean`         | `false`   | Disabled styling and state                                    |
| `error`      | `boolean`         | `false`   | Error styling                                                 |
| `fullWidth`  | `boolean`         | `true`    | Stretch to container width                                    |
| `hasPrefix`  | `boolean`         | `false`   | Enable prefix slot rendering and layout adjustment            |
| `hasSuffix`  | `boolean`         | `false`   | Enable suffix slot rendering and layout adjustment            |
| `noPadding`  | `boolean`         | `false`   | Remove internal padding                                       |
| `readonly`   | `boolean`         | `false`   | Read-only state                                               |
| `size`       | `TextFieldSize`   | `'main'`  | `'main' \| 'sub'`                                             |
| `typing`     | `boolean`         | —         | Override auto typing detection                                |
| `warning`    | `boolean`         | `false`   | Warning state styling                                         |

Own inputs on `MznTextField`:

| Input                    | Type      | Default | Description                                                 |
| ------------------------ | --------- | ------- | ----------------------------------------------------------- |
| `forceShowClearable`     | `boolean` | `false` | Always show clear button regardless of hover/focus state    |
| `hideSuffixWhenClearable`| `boolean` | `false` | Hide suffix slot content when clear button is visible       |

> Inputs declared with signal API (`input()`) accept both static and reactive values.

## Outputs

| Output           | Type                        | Description                                    |
| ---------------- | --------------------------- | ---------------------------------------------- |
| `cleared`        | `OutputEmitterRef<MouseEvent>` | Emitted when the clear button is clicked    |
| `hoveredChange`  | `OutputEmitterRef<boolean>` | From `MznTextFieldHost`; hover state changes   |
| `focusedChange`  | `OutputEmitterRef<boolean>` | From `MznTextFieldHost`; focus state changes   |
| `hasValueChange` | `OutputEmitterRef<boolean>` | From `MznTextFieldHost`; value presence changes|

## ControlValueAccessor

`MznTextField` does **not** implement `ControlValueAccessor`. It is a structural container only. For form bindings, use `MznInput` or `MznTextarea` which wrap `MznTextField` internally.

## Usage

```html
<!-- Direct usage — building a custom input -->
<div mznTextField [clearable]="true" [hasPrefix]="true" [hasSuffix]="true" (cleared)="value = ''">
  <span prefix>$</span>
  <input [value]="value" (input)="onAmountInput($event)" placeholder="Amount" />
  <span suffix>.00</span>
</div>

<!-- Error state -->
<div mznTextField [error]="ctrl.invalid && ctrl.touched" [fullWidth]="true">
  <input [formControl]="ctrl" placeholder="Enter value" />
</div>
```

```ts
// component class — typed DOM cast instead of $any()
protected onAmountInput(event: Event): void {
  const target = event.target as HTMLInputElement;
  this.value = target.value;
}
```

```ts
import { MznTextField } from '@mezzanine-ui/ng/text-field';

@Component({
  imports: [MznTextField, ReactiveFormsModule],
})
export class CustomInputComponent {
  readonly ctrl = new FormControl('');
}
```

## Notes

- `MznTextFieldHost` is applied via Angular's `hostDirectives` API and handles all DOM event listeners. When consumed inside another standalone component (like `MznInput`), it is imported in that component's `imports` array automatically.
- The clear button uses opacity transitions controlled by the `--clearing` host class modifier. It is always rendered in the DOM (to reserve layout space) but hidden until hovered/focused with a value present — this avoids layout shifts on hover. To force it visible, use `[forceShowClearable]="true"`.
- Unlike the React `<TextField>`, Angular's version does not accept `children` directly — it uses Angular content projection (`<ng-content>`) with named slots (`[prefix]` and `[suffix]`).
- `MznTextField` is typically not used in app templates directly; prefer `MznInput`, `MznTextarea`, or the picker-family trigger components.
- `hasPrefix` and `hasSuffix` are declared as own `input()` signals on `MznTextField` in addition to being forwarded from `MznTextFieldHost`. This means you can bind `[hasPrefix]="true"` directly on `<div mznTextField>` without going through the host directive — `MznTextField` re-declares them so both the host-class computation and any slot-layout logic within the component template see the same value.
