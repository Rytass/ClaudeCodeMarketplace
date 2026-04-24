# Checkbox

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/ng/checkbox) · Verified 1.0.0-rc.4 (2026-04-24)
>
> **Storybook**: https://storybook-ng.mezzanine-ui.org/?path=/docs/data-entry-checkbox--docs

A checkbox input component supporting `default` and `chip` display modes. Can be used standalone (binding a `boolean`) or within `MznCheckboxGroup` (binding `string[]` via the group's CVA). Supports indeterminate state, editable inline input (shown on check), and optional hint/description text.

`MznCheckboxGroup` wraps multiple checkboxes, provides a shared DI context, and exposes `ControlValueAccessor` for `string[]` values. It also supports a "select all" control via the `level` input.

## Import

```ts
import { MznCheckAll, MznCheckbox, MznCheckboxGroup } from '@mezzanine-ui/ng/checkbox';
import type { CheckboxEditableInput, CheckboxGroupLevelConfig } from '@mezzanine-ui/ng/checkbox';
import { CheckboxMode, CheckboxSize, CheckboxSeverity, CheckboxGroupLayout } from '@mezzanine-ui/core/checkbox';
```

## Selector

`<div mznCheckAll ...>` — attribute-directive component

`<div mznCheckbox ...>` — attribute-directive component

`<div mznCheckboxGroup ...>` — attribute-directive component

## MznCheckAll

A "check all" wrapper that automatically computes `checked` / `indeterminate` state based on the provided `options` and the sibling `MznCheckboxGroup`'s current value. Clicking toggles all non-disabled options.

`MznCheckAll` uses `contentChild(MznCheckboxGroup)` to locate the group — the `MznCheckboxGroup` **must** be a direct content child.

| Input      | Type                                    | Default       | Description                              |
| ---------- | --------------------------------------- | ------------- | ---------------------------------------- |
| `options`  | `readonly CheckboxGroupOption[]` (required) | —         | Full option list used for state calculation |
| `label`    | `string`                                | `'Check All'` | Label text for the check-all checkbox    |
| `disabled` | `boolean`                               | `false`       | Disable the check-all checkbox           |

```html
import { MznCheckAll, MznCheckbox, MznCheckboxGroup } from '@mezzanine-ui/ng/checkbox';

<div mznCheckAll [options]="options" label="全選">
  <div mznCheckboxGroup [(ngModel)]="selected" name="items">
    @for (opt of options; track opt.value) {
      <div mznCheckbox [value]="opt.value" [disabled]="opt.disabled ?? false">
        {{ opt.label }}
      </div>
    }
  </div>
</div>
```

## Inputs — MznCheckbox

| Input             | Type                  | Default     | Description                                            |
| ----------------- | --------------------- | ----------- | ------------------------------------------------------ |
| `checked`         | `boolean`             | —           | Controlled checked state (standalone usage)            |
| `disabled`        | `boolean`             | `false`     | Disabled state                                         |
| `error`           | `boolean`             | `false`     | Error state styling                                    |
| `hint`            | `string`              | —           | Hint text below label                                  |
| `indeterminate`   | `boolean`             | `false`     | Indeterminate state (show dash)                        |
| `label`           | `string`              | —           | Label text (alternative to projected content)          |
| `description`     | `string`              | —           | Secondary description (not shown in chip mode)         |
| `mode`            | `CheckboxMode`        | `'default'` | `'default' \| 'chip'`                                  |
| `name`            | `string`              | —           | Input name attribute                                   |
| `severity`        | `CheckboxSeverity`    | —           | Visual severity modifier                               |
| `size`            | `CheckboxSize`        | `'main'`    | `'main' \| 'minor'`                                    |
| `value`           | `string`              | `''`        | Value used by `MznCheckboxGroup`                       |
| `id`              | `string`              | auto        | Native `<input id>`; defaults to `mzn-checkbox-{n}`   |
| `withEditInput`   | `boolean`             | `false`     | Show inline text input when checked                    |
| `editableInput`   | `CheckboxEditableInput` | —         | Inline input configuration bundle                      |
| `detached`        | `boolean`             | `false`     | Internal — detach from group context (used by level checkbox) |

> Inputs declared with signal API (`input()`) accept both static and reactive values.

## Inputs — MznCheckboxGroup

| Input      | Type                       | Default        | Description                                        |
| ---------- | -------------------------- | -------------- | -------------------------------------------------- |
| `disabled` | `boolean`                  | `false`        | Disable all child checkboxes                       |
| `layout`   | `CheckboxGroupLayout`      | `'horizontal'` | `'horizontal' \| 'vertical'`                       |
| `level`    | `CheckboxGroupLevelConfig` | —              | "Select all" checkbox configuration bundle         |
| `mode`     | `CheckboxMode`             | `'default'`    | `'default' \| 'chip'` — propagated to children     |
| `name`     | `string`                   | `''`           | Input name propagated to all child checkboxes      |
| `size`     | `CheckboxSize`             | `'main'`       | Size propagated to all child checkboxes            |

## Outputs

| Output                  | Type                               | Component         | Description                                   |
| ----------------------- | ---------------------------------- | ----------------- | --------------------------------------------- |
| `editableInputChange`   | `OutputEmitterRef<string>`         | `MznCheckbox`     | Inline input value changes when `withEditInput` is true |
| `valueChange`           | `OutputEmitterRef<ReadonlyArray<string>>` | `MznCheckboxGroup` | Emitted when the group selection changes |

## ControlValueAccessor

Both `MznCheckbox` (standalone) and `MznCheckboxGroup` implement `ControlValueAccessor`.

**Standalone checkbox** — binds `boolean`:

```html
<div mznCheckbox formControlName="agreed">I agree to the terms</div>
<div mznCheckbox [formControl]="agreedCtrl">I agree to the terms</div>
<div mznCheckbox [(ngModel)]="agreed">I agree to the terms</div>
```

**CheckboxGroup** — binds `string[]`:

```html
<form [formGroup]="form">
  <div mznCheckboxGroup formControlName="fruits" name="fruits">
    <div mznCheckbox value="apple">Apple</div>
    <div mznCheckbox value="banana">Banana</div>
    <div mznCheckbox value="cherry">Cherry</div>
  </div>
</form>

<div mznCheckboxGroup [(ngModel)]="selectedFruits" name="fruits">
  <div mznCheckbox value="apple">Apple</div>
  <div mznCheckbox value="banana">Banana</div>
</div>
```

`MznCheckbox.writeValue(boolean)` sets internal checked state. When inside a group, the group's `toggle(value)` method is called on change instead of the individual CVA. `MznCheckboxGroup.writeValue(string[] | null)` replaces the internal selections array.

## Usage

```html
<!-- Standalone with form validation -->
<form [formGroup]="form">
  <div mznCheckbox formControlName="newsletter">Subscribe to newsletter</div>
  <div mznCheckbox formControlName="terms" [error]="form.get('terms')?.invalid && !!form.get('terms')?.touched">
    Accept terms and conditions
  </div>
</form>

<!-- Chip mode group -->
<div mznCheckboxGroup [(ngModel)]="tags" name="tags" mode="chip" layout="horizontal">
  <div mznCheckbox value="angular">Angular</div>
  <div mznCheckbox value="react">React</div>
  <div mznCheckbox value="vue">Vue</div>
</div>

<!-- Group with select-all level control -->
<div mznCheckboxGroup
  formControlName="permissions"
  name="permissions"
  [level]="{ active: true, label: 'Select All' }"
  layout="vertical">
  <div mznCheckbox value="read">Read</div>
  <div mznCheckbox value="write">Write</div>
  <div mznCheckbox value="delete">Delete</div>
</div>
```

```ts
import { MznCheckbox, MznCheckboxGroup } from '@mezzanine-ui/ng/checkbox';
import { ReactiveFormsModule, FormGroup, FormControl, Validators } from '@angular/forms';

@Component({
  imports: [MznCheckbox, MznCheckboxGroup, ReactiveFormsModule],
})
export class PermissionsComponent {
  readonly form = new FormGroup({
    permissions: new FormControl<string[]>([], [Validators.required]),
    terms: new FormControl(false, [Validators.requiredTrue]),
  });
}
```

## Notes

- When `MznCheckbox` is placed inside `MznCheckboxGroup`, the `disabled`, `mode`, `name`, and `size` inputs from the group take precedence over individual checkbox inputs.
- The group injects `MZN_CHECKBOX_GROUP` token. `MznCheckbox` reads this token and calls `group.toggle(value)` on change, bypassing its own CVA's `onChange`. The individual CVA is only active when the checkbox is standalone.
- The `level` checkbox (select-all) uses `[detached]="true"` internally to avoid being counted as a group member.
- Unlike React's `CheckboxGroup` where you pass `onChange` to the group itself, in Angular you bind `formControlName` or `[(ngModel)]` on the group element.
- `withEditInput` reveals an inline `MznInput` (base variant) when the checkbox is checked. The input value changes are emitted via `(editableInputChange)` — this is separate from the checkbox's CVA value.
