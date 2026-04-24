# Textarea

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/ng/textarea) · Verified 1.0.0-rc.4 (2026-04-24)
>
> **Storybook**: https://storybook-ng.mezzanine-ui.org/?path=/docs/data-entry-textarea--docs

A multi-line text input component that wraps a native `<textarea>` inside `MznTextField`. Supports `default`, `warning`, and `error` visual states via the `type` input, and configurable resize behavior. Implements `ControlValueAccessor` for Angular Forms integration.

## Import

```ts
import { MznTextarea } from '@mezzanine-ui/ng/textarea';
import type { TextareaType, TextareaResize } from '@mezzanine-ui/ng/textarea';
```

## Selector

`<div mznTextarea ...>` — attribute-directive component

## Inputs

| Input         | Type             | Default     | Description                                             |
| ------------- | ---------------- | ----------- | ------------------------------------------------------- |
| `disabled`    | `boolean`        | `false`     | Disabled state (only effective when `type === 'default'`) |
| `placeholder` | `string`         | —           | Placeholder text                                        |
| `readonly`    | `boolean`        | `false`     | Read-only state (only effective when `type === 'default'`) |
| `resize`      | `TextareaResize` | `'none'`    | CSS resize: `'none' \| 'both' \| 'horizontal' \| 'vertical'` |
| `rows`        | `number`         | —           | Native `<textarea rows>`                                |
| `type`        | `TextareaType`   | `'default'` | Visual state: `'default' \| 'warning' \| 'error'`      |

> `disabled` and `readonly` are only applied when `type === 'default'`. Warning and error states bypass them.

> Inputs declared with signal API (`input()`) accept both static and reactive values.

## Outputs

| Output        | Type                       | Description                  |
| ------------- | -------------------------- | ---------------------------- |
| `valueChange` | `OutputEmitterRef<string>` | Emitted on every input event |

## ControlValueAccessor

`MznTextarea` implements `ControlValueAccessor` via `provideValueAccessor(MznTextarea)`. It binds to `string` values.

```html
<!-- formControlName -->
<form [formGroup]="form">
  <div mznTextarea formControlName="bio" [rows]="4" placeholder="Write your bio..."></div>
</form>

<!-- formControl -->
<div mznTextarea [formControl]="bioCtrl" resize="vertical"></div>

<!-- ngModel -->
<div mznTextarea [(ngModel)]="notes" placeholder="Notes"></div>
```

`writeValue(value: string | null)` stores the value in an internal signal that drives the native `<textarea [value]>`. `null` is coerced to `''`. Touch event is registered on blur.

## Usage

```html
<!-- Basic reactive form with error state -->
<form [formGroup]="form">
  <div mznFormField name="description" label="Description" layout="vertical"
       [severity]="form.get('description')?.invalid ? 'error' : 'info'"
       hintText="Max 500 characters">
    <div mznTextarea
      formControlName="description"
      [rows]="5"
      placeholder="Describe the product..."
      [type]="form.get('description')?.invalid && form.get('description')?.touched ? 'error' : 'default'">
    </div>
  </div>
</form>

<!-- Resizable textarea -->
<div mznTextarea [(ngModel)]="comment" resize="vertical" [rows]="3" placeholder="Comment"></div>
```

```ts
import { MznTextarea } from '@mezzanine-ui/ng/textarea';
import { MznFormField } from '@mezzanine-ui/ng/form';
import { ReactiveFormsModule, FormControl, Validators } from '@angular/forms';

@Component({
  imports: [MznTextarea, MznFormField, ReactiveFormsModule],
})
export class FeedbackFormComponent {
  readonly form = new FormGroup({
    description: new FormControl('', [Validators.required, Validators.maxLength(500)]),
  });
}
```

## Notes

- Unlike `MznInput` which has a `variant` prop, `MznTextarea` uses `type` for visual state. The `type` mapping: `'error'` → `MznTextField [error]="true"`, `'warning'` → `MznTextField [warning]="true"`.
- When `type` is `'warning'` or `'error'`, the `disabled` and `readonly` inputs have no effect (they are only applied in `'default'` mode via computed signals).
- When `resize` is not `'none'`, a `ResizeHandleIcon` is rendered in the bottom-right corner for visual affordance.
- React's `<Textarea>` maps to this component. The `onChange` React prop maps to the `(valueChange)` output event — note that unlike React, you do not need a separate `onChange` handler when using CVA (`formControlName` / `[(ngModel)]`).
