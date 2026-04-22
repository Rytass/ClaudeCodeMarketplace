# Picker

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/ng/picker) · Verified 1.0.0-rc.3 (2026-04-21)
>
> **Storybook**: https://storybook-ng.mezzanine-ui.org/?path=/docs/data-entry-picker--docs

The `picker` package provides low-level primitive trigger components used internally by the date and time picker family. You rarely use these directly in application code — they are exported for advanced customisation scenarios.

Exported primitives:
- `MznPickerTrigger` — single-field trigger (wraps `MznFormattedInput`)
- `MznPickerTriggerWithSeparator` — **dual**-field trigger (left + right `MznFormattedInput`) used by DateTimePicker
- `MznRangePickerTrigger` — dual-field trigger for date range pickers (from / to)
- `MznFormattedInput` — masked character-by-character date/time input
- `MaskFormat` — mask format utilities

## Import

```ts
import {
  MznPickerTrigger,
  MznPickerTriggerWithSeparator,
  MznRangePickerTrigger,
  MznFormattedInput,
  MaskFormat,
} from '@mezzanine-ui/ng/picker';
import type { FormattedInputErrorMessages } from '@mezzanine-ui/ng/picker';
import { TextFieldSize } from '@mezzanine-ui/core/text-field';
```

## Selector

`<div mznPickerTrigger [format]="'YYYY-MM-DD'" ...>` — attribute-directive component

## Inputs — MznPickerTrigger

| Input              | Type                              | Default                   | Description                                                              |
| ------------------ | --------------------------------- | ------------------------- | ------------------------------------------------------------------------ |
| `format`           | `string` **(required)**           | —                         | Date/time format string (e.g. `'YYYY-MM-DD'`, `'HH:mm:ss'`)             |
| `value`            | `string \| undefined`             | —                         | Current display value (ISO or formatted)                                 |
| `placeholder`      | `string \| undefined`             | —                         | Placeholder text                                                         |
| `disabled`         | `boolean`                         | `false`                   | Disabled state                                                           |
| `readOnly`         | `boolean`                         | `false`                   | Read-only state                                                          |
| `clearable`        | `boolean`                         | `true`                    | Show clear button                                                        |
| `error`            | `boolean`                         | `false`                   | Error state styling                                                      |
| `fullWidth`        | `boolean`                         | `false`                   | Stretch to container width                                               |
| `size`             | `TextFieldSize`                   | `'main'`                  | `'main' \| 'sub'`                                                        |
| `hoverValue`       | `string \| undefined`             | —                         | Preview value on hover (calendar hover preview)                          |
| `hostClassModifier`| `string`                          | `''`                      | Extra host class modifier (e.g. `mzn-picker--date`)                      |
| `required`         | `boolean`                         | `false`                   | Required state                                                           |
| `validate`         | `((isoDate: string) => boolean) \| undefined` | —             | Custom validation predicate for typed input                              |
| `errorMessages`    | `FormattedInputErrorMessages`     | `{ enabled: true, ... }` | Error message config for invalid input / paste                            |

> Inputs declared with signal API (`input()`) accept both static and reactive values.

## Outputs — MznPickerTrigger

| Output          | Type                                                        | Description                                    |
| --------------- | ----------------------------------------------------------- | ---------------------------------------------- |
| `cleared`       | `OutputEmitterRef<void>`                                    | Clear button clicked                           |
| `inputFocused`  | `OutputEmitterRef<FocusEvent>`                              | Input focused                                  |
| `inputBlurred`  | `OutputEmitterRef<FocusEvent>`                              | Input blurred                                  |
| `valueChanged`  | `OutputEmitterRef<{ isoValue: string; rawDigits: string }>` | Typed input changed to a complete date         |
| `valueCleared`  | `OutputEmitterRef<void>`                                    | Typed value cleared internally                 |
| `pasteIsoValue` | `OutputEmitterRef<string>`                                  | Valid ISO date pasted                          |
| `inputKeydown`  | `OutputEmitterRef<KeyboardEvent>`                           | Key down event forwarded                       |

---

## MznPickerTriggerWithSeparator

**Dual-field** trigger with two independent `MznFormattedInput` boxes separated by a vertical divider. Used by `DateTimePicker` (left = date, right = time). This is **not** a single field with a visual separator — it contains two real inputs.

### Selector

`[mznPickerTriggerWithSeparator]`

### Inputs — MznPickerTriggerWithSeparator

| Input               | Type                                                 | Default   | Description                                          |
| ------------------- | ---------------------------------------------------- | --------- | ---------------------------------------------------- |
| `formatLeft`        | `string` **(required)**                              | —         | Format for the left input (e.g. `'YYYY-MM-DD'`)      |
| `formatRight`       | `string` **(required)**                              | —         | Format for the right input (e.g. `'HH:mm:ss'`)       |
| `valueLeft`         | `string \| undefined`                                | —         | Current left input value                             |
| `valueRight`        | `string \| undefined`                                | —         | Current right input value                            |
| `hoverValueLeft`    | `string \| undefined`                                | —         | Hover preview value for the left input               |
| `placeholderLeft`   | `string \| undefined`                                | —         | Placeholder for the left input                       |
| `placeholderRight`  | `string \| undefined`                                | —         | Placeholder for the right input                      |
| `errorMessagesLeft` | `FormattedInputErrorMessages`                        | `{ enabled: true, ... }` | Error message config for left input   |
| `errorMessagesRight`| `FormattedInputErrorMessages`                        | `{ enabled: true, ... }` | Error message config for right input  |
| `validateLeft`      | `((isoDate: string) => boolean) \| undefined`        | —         | Custom validation for left input                     |
| `validateRight`     | `((isoDate: string) => boolean) \| undefined`        | —         | Custom validation for right input                    |
| `clearable`         | `boolean`                                            | `true`    | Show clear button                                    |
| `disabled`          | `boolean`                                            | `false`   | Disabled state                                       |
| `error`             | `boolean`                                            | `false`   | Error state styling                                  |
| `fullWidth`         | `boolean`                                            | `false`   | Stretch to container width                           |
| `readOnly`          | `boolean`                                            | `false`   | Read-only state                                      |
| `required`          | `boolean`                                            | `false`   | Required state                                       |
| `size`              | `TextFieldSize`                                      | `'main'`  | `'main' \| 'sub'`                                    |
| `hostClassModifier` | `string`                                             | `''`      | Extra host class modifier                            |

### Outputs — MznPickerTriggerWithSeparator

| Output              | Type                                                        | Description                              |
| ------------------- | ----------------------------------------------------------- | ---------------------------------------- |
| `cleared`           | `OutputEmitterRef<void>`                                    | Clear button clicked                     |
| `leftFocused`       | `OutputEmitterRef<FocusEvent>`                              | Left input focused                       |
| `leftBlurred`       | `OutputEmitterRef<FocusEvent>`                              | Left input blurred                       |
| `leftComplete`      | `OutputEmitterRef<void>`                                    | Left mask fully filled                   |
| `leftChanged`       | `OutputEmitterRef<{ isoValue: string; rawDigits: string }>` | Left input value changed                 |
| `leftValueCleared`  | `OutputEmitterRef<void>`                                    | Left value cleared internally            |
| `pasteIsoValueLeft` | `OutputEmitterRef<string>`                                  | Valid ISO value pasted into left input   |
| `rightFocused`      | `OutputEmitterRef<FocusEvent>`                              | Right input focused                      |
| `rightBlurred`      | `OutputEmitterRef<FocusEvent>`                              | Right input blurred                      |
| `rightComplete`     | `OutputEmitterRef<void>`                                    | Right mask fully filled                  |
| `rightChanged`      | `OutputEmitterRef<{ isoValue: string; rawDigits: string }>` | Right input value changed                |
| `rightValueCleared` | `OutputEmitterRef<void>`                                    | Right value cleared internally           |
| `pasteIsoValueRight`| `OutputEmitterRef<string>`                                  | Valid ISO value pasted into right input  |

---

## MznRangePickerTrigger

Dual-field trigger for date range pickers (from / to), separated by a right-arrow icon. Used by `DateRangePicker` and `TimeRangePicker`.

### Selector

`[mznRangePickerTrigger]`

### Inputs — MznRangePickerTrigger

| Input                  | Type                                                 | Default   | Description                                              |
| ---------------------- | ---------------------------------------------------- | --------- | -------------------------------------------------------- |
| `format`               | `string` **(required)**                              | —         | Date/time format for both inputs                         |
| `inputFromValue`       | `string \| undefined`                                | —         | Current "from" value                                     |
| `inputToValue`         | `string \| undefined`                                | —         | Current "to" value                                       |
| `hoverFromValue`       | `string \| undefined`                                | —         | Hover preview value for "from" input                     |
| `hoverToValue`         | `string \| undefined`                                | —         | Hover preview value for "to" input                       |
| `inputFromPlaceholder` | `string \| undefined`                                | —         | Placeholder for "from" input                             |
| `inputToPlaceholder`   | `string \| undefined`                                | —         | Placeholder for "to" input                               |
| `errorMessagesFrom`    | `FormattedInputErrorMessages`                        | `{ enabled: true, ... }` | Error message config for "from" input  |
| `errorMessagesTo`      | `FormattedInputErrorMessages`                        | `{ enabled: true, ... }` | Error message config for "to" input    |
| `validateFrom`         | `((isoDate: string) => boolean) \| undefined`        | —         | Custom validation for "from" input                       |
| `validateTo`           | `((isoDate: string) => boolean) \| undefined`        | —         | Custom validation for "to" input                         |
| `clearable`            | `boolean`                                            | `true`    | Show clear button                                        |
| `disabled`             | `boolean`                                            | `false`   | Disabled state                                           |
| `error`                | `boolean`                                            | `false`   | Error state styling                                      |
| `fullWidth`            | `boolean`                                            | `false`   | Stretch to container width                               |
| `readOnly`             | `boolean`                                            | `false`   | Read-only state                                          |
| `required`             | `boolean`                                            | `false`   | Required state                                           |
| `size`                 | `TextFieldSize`                                      | `'main'`  | `'main' \| 'sub'`                                        |
| `hostClassModifier`    | `string`                                             | `''`      | Extra host class modifier                                |

### Outputs — MznRangePickerTrigger

| Output             | Type                                                        | Description                          |
| ------------------ | ----------------------------------------------------------- | ------------------------------------ |
| `cleared`          | `OutputEmitterRef<void>`                                    | Clear button clicked                 |
| `iconClick`        | `OutputEmitterRef<MouseEvent>`                              | Calendar icon clicked                |
| `fromFocused`      | `OutputEmitterRef<FocusEvent>`                              | "From" input focused                 |
| `fromBlurred`      | `OutputEmitterRef<FocusEvent>`                              | "From" input blurred                 |
| `fromValueCleared` | `OutputEmitterRef<void>`                                    | "From" value cleared internally      |
| `inputFromChanged` | `OutputEmitterRef<{ isoValue: string; rawDigits: string }>` | "From" input changed                 |
| `toFocused`        | `OutputEmitterRef<FocusEvent>`                              | "To" input focused                   |
| `toBlurred`        | `OutputEmitterRef<FocusEvent>`                              | "To" input blurred                   |
| `toValueCleared`   | `OutputEmitterRef<void>`                                    | "To" value cleared internally        |
| `inputToChanged`   | `OutputEmitterRef<{ isoValue: string; rawDigits: string }>` | "To" input changed                   |

---

## MznFormattedInput — Additional Inputs

`MznFormattedInput` is used inside all trigger components. Key inputs beyond `format`, `value`, `placeholder`, `disabled`, `hoverValue`, `validate`, and `errorMessages`:

| Input           | Type                        | Default | Description                                       |
| --------------- | --------------------------- | ------- | ------------------------------------------------- |
| `inputSize`     | `number \| undefined`       | —       | Native `<input size>` attribute (character width) |
| `ariaLabel`     | `string \| undefined`       | —       | `aria-label` on the inner `<input>`               |
| `ariaMultiline` | `boolean \| undefined`      | —       | `aria-multiline` on the inner `<input>`           |
| `ariaReadonly`  | `boolean \| undefined`      | —       | `aria-readonly` on the inner `<input>`            |
| `ariaRequired`  | `boolean \| undefined`      | —       | `aria-required` on the inner `<input>`            |

---

## ControlValueAccessor

`MznPickerTrigger`, `MznPickerTriggerWithSeparator`, and `MznRangePickerTrigger` do **not** implement `ControlValueAccessor`. CVA is implemented on `MznDatePicker`, `MznTimePicker`, etc.

## Usage

`MznPickerTrigger` is primarily used by the date/time picker family components. For a custom picker:

```html
<!-- Custom date picker shell -->
<div mznPickerTrigger
  [format]="'YYYY-MM-DD'"
  [value]="selectedDateString"
  [placeholder]="'Select date'"
  [clearable]="true"
  (inputFocused)="openCalendar()"
  (cleared)="onClear()"
  (valueChanged)="onValueChange($event)">
  <i mznIcon suffix [icon]="CalendarIcon" (click)="toggleCalendar($event)"></i>
</div>
```

```ts
import { MznPickerTrigger } from '@mezzanine-ui/ng/picker';
import type { FormattedInputErrorMessages } from '@mezzanine-ui/ng/picker';

@Component({
  imports: [MznPickerTrigger, MznIcon],
})
export class CustomDatePickerComponent {
  selectedDateString = '';

  onValueChange(payload: { isoValue: string; rawDigits: string }): void {
    this.selectedDateString = payload.isoValue;
  }

  onClear(): void {
    this.selectedDateString = '';
  }
}
```

## Notes

- `MznFormattedInput` uses a character-by-character mask approach: the format string (e.g. `'YYYY-MM-DD'`) is parsed into segments, and each character slot accepts only the appropriate digit. This produces a native `<input>` that formats as the user types without a separate mask library.
- `hoverValue` enables calendar hover preview: when the input is unfocused and empty, a preview date (from calendar mouse hover) is shown in a muted color.
- `validate` receives the ISO string of the typed date and returns `true` if valid. Use this to block disabled dates from being typed directly.
- `MznPickerTriggerWithSeparator` contains **two** real inputs (not one with a decorative separator). It is used by `DateTimePicker` where left = date format and right = time format.
- For application-level use, prefer `MznDatePicker`, `MznTimePicker`, etc. Use these primitives directly only for highly custom picker shells.
