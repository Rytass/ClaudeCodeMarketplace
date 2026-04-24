# Form

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/ng/form) · Verified 1.0.0-rc.4 (2026-04-24)
>
> **Storybook**: https://storybook-ng.mezzanine-ui.org/?path=/docs/data-entry-form--docs

The form package provides `MznFormField`, `MznFormGroup`, `MznFormLabel`, and `MznFormHintText` — structural components that wrap inputs and wire up labels, hint text, error severity, and disabled/required state via the `MZN_FORM_CONTROL` DI token. `MznFormField` provides state downward to any child inputs that inject `MZN_FORM_CONTROL`.

## Import

```ts
import {
  MznFormField,
  MznFormGroup,
  MznFormLabel,
  MznFormHintText,
  MZN_FORM_CONTROL,
  type FormControl,
} from '@mezzanine-ui/ng/form';
import {
  FormFieldLayout,
  FormFieldDensity,
  FormFieldLabelSpacing,
  FormFieldCounterColor,
  ControlFieldSlotLayout,
} from '@mezzanine-ui/core/form';
import { SeverityWithInfo } from '@mezzanine-ui/system/severity';
```

## `FormControl` Interface

`FormControl` is the shape of the value provided by the `MZN_FORM_CONTROL` DI token. `MznFormField` provides it to all descendant inputs automatically. Fields: `disabled: boolean`, `fullWidth: boolean`, `required: boolean`, `severity?: SeverityWithInfo`. Useful when building a custom input that needs to read parent form state:

```ts
import { inject } from '@angular/core';
import { MZN_FORM_CONTROL } from '@mezzanine-ui/ng/form';

const ctrl = inject(MZN_FORM_CONTROL, { optional: true });
const isDisabled = ctrl?.disabled ?? false;
```

## Selector

`<div mznFormField name="..." ...>` — attribute-directive component

`<div mznFormGroup title="..." ...>` — attribute-directive component

`<label mznFormLabel labelText="..." ...>` — attribute-directive component

`<span mznFormHintText hintText="..." ...>` — attribute-directive component

## Inputs — MznFormField

| Input                       | Type                                    | Default                         | Description                                           |
| --------------------------- | --------------------------------------- | ------------------------------- | ----------------------------------------------------- |
| `name`                      | `string` (required)                     | —                               | Field name, also used as `htmlFor` on the label       |
| `label`                     | `string`                                | —                               | Label text                                            |
| `layout`                    | `FormFieldLayout`                       | `'horizontal'`                  | `'horizontal' \| 'vertical' \| 'extended'`            |
| `density`                   | `FormFieldDensity`                      | —                               | Compact density; only applies when layout ≠ vertical  |
| `disabled`                  | `boolean`                               | `false`                         | Propagates `disabled` to children via DI              |
| `required`                  | `boolean`                               | `false`                         | Shows required marker on label; propagates via DI     |
| `severity`                  | `SeverityWithInfo`                      | `'info'`                        | Controls hint text icon & color                       |
| `fullWidth`                 | `boolean`                               | `false`                         | Propagates to children via DI                         |
| `hintText`                  | `string`                                | —                               | Helper text beneath the input                         |
| `hintTextIcon`              | `IconDefinition`                        | —                               | Custom icon before hint text                          |
| `showHintTextIcon`          | `boolean`                               | `true`                          | Show/hide the hint icon                               |
| `counter`                   | `string`                                | —                               | Character counter text (e.g. `'12/100'`)              |
| `counterColor`              | `FormFieldCounterColor`                 | `'info'`                        | Counter text color                                    |
| `labelSpacing`              | `FormFieldLabelSpacing`                 | `'main'`                        | Label-to-input gap spacing                            |
| `labelInformationIcon`      | `IconDefinition`                        | —                               | Tooltip trigger icon next to label                    |
| `labelInformationText`      | `string`                                | —                               | Tooltip content for the information icon              |
| `labelOptionalMarker`       | `string`                                | —                               | Optional marker text, e.g. `'(Optional)'`             |
| `controlFieldSlotLayout`    | `ControlFieldSlotLayout`                | `ControlFieldSlotLayout.MAIN`   | Slot layout variant                                   |
| `controlFieldSlotColumns`   | `2 \| 3 \| 4`                           | —                               | Grid columns for the slot area                        |

> Inputs declared with signal API (`input()`, `model()`) accept both static and reactive values.

## Inputs — MznFormGroup

| Input                       | Type      | Default | Description                                 |
| --------------------------- | --------- | ------- | ------------------------------------------- |
| `title`                     | `string` (required) | — | Group title text                    |
| `fieldsContainerClassName`  | `string`  | —       | Extra CSS class for the fields container    |

## Inputs — MznFormLabel

| Input               | Type              | Default | Description                            |
| ------------------- | ----------------- | ------- | -------------------------------------- |
| `labelText`         | `string` (required) | —     | Label display text                     |
| `htmlFor`           | `string`          | —       | Linked input element `id`              |
| `informationIcon`   | `IconDefinition`  | —       | Info icon definition                   |
| `informationText`   | `string`          | —       | Tooltip text for the info icon         |
| `optionalMarker`    | `string`          | —       | Optional marker string                 |

## Inputs — MznFormHintText

| Input              | Type              | Default  | Description                                          |
| ------------------ | ----------------- | -------- | ---------------------------------------------------- |
| `hintText`         | `string`          | —        | Hint text content                                    |
| `hintTextIcon`     | `IconDefinition`  | —        | Custom icon; falls back to severity default          |
| `severity`         | `SeverityWithInfo`| `'info'` | Controls icon and color                              |
| `showHintTextIcon` | `boolean`         | `true`   | Toggle icon visibility                               |

## Outputs

`MznFormField`, `MznFormGroup`, `MznFormLabel`, and `MznFormHintText` have no output events.

## ControlValueAccessor

None of the form-infrastructure components implement `ControlValueAccessor`. They wrap CVA inputs; they do not bind form values themselves.

## Usage

```html
<!-- Reactive Forms -->
<form [formGroup]="form">
  <div mznFormField name="email" label="Email" layout="horizontal" [required]="true"
       hintText="Enter a valid email" [severity]="form.get('email')?.invalid && form.get('email')?.touched ? 'error' : 'info'">
    <input mznInput formControlName="email" placeholder="user@example.com" />
  </div>

  <div mznFormField name="bio" label="Bio" layout="vertical" counter="0/300">
    <div mznTextarea formControlName="bio" [rows]="4"></div>
  </div>
</form>
```

```html
<!-- FormGroup wrapping multiple fields -->
<div mznFormGroup title="Personal Info">
  <div mznFormField name="firstName" label="First Name">
    <input mznInput formControlName="firstName" />
  </div>
  <div mznFormField name="lastName" label="Last Name">
    <input mznInput formControlName="lastName" />
  </div>
</div>
```

```ts
import { MznFormField, MznFormGroup } from '@mezzanine-ui/ng/form';
import { MznInput } from '@mezzanine-ui/ng/input';
import { ReactiveFormsModule } from '@angular/forms';

@Component({
  imports: [MznFormField, MznFormGroup, MznInput, ReactiveFormsModule],
  // ...
})
export class MyFormComponent {
  readonly form = new FormGroup({
    email: new FormControl('', [Validators.required, Validators.email]),
    bio: new FormControl(''),
  });
}
```

## Notes

- `MznFormField` uses `MZN_FORM_CONTROL` to push `disabled`, `required`, `severity`, and `fullWidth` state into child inputs. Child inputs that inject this token (e.g. `MznFormLabel`) react automatically — you do not need to pass `required` to the label manually.
- Unlike the React `<Form>` component where severity is read from a React Context, the Angular version uses Angular DI via an `InjectionToken`.
- The `layout` default is `'horizontal'` (label left, input right). Use `'vertical'` for stacked layouts. `'extended'` is similar to horizontal but the label area is wider.
- `MznFormGroup` and `MznFormField` are standalone and do not need to be added to an `NgModule`.
