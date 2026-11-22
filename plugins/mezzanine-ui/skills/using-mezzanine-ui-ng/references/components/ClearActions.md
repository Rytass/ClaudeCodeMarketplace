# ClearActions

> ⚠️ Internal helper — `MznClearActions` is used internally by `MznSelect`, `MznAutocomplete`, `MznTextField` (and thus `MznInput`), `MznModal`, `MznDrawer`, `MznPicker`, and other components to render close/clear icons. **Not recommended for direct usage.** Prefer using the `clearable` or `showDismissButton` inputs on the parent component instead.

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/ng/clear-actions) · Verified 1.0.0-rc.26 (2026-11-22)

Small button component for close, clear, or dismiss interactions. Renders a `CloseIcon` (standard/embedded) or `DangerousFilledIcon` (clearable) depending on `type`.

## Import

```ts
import { MznClearActions } from '@mezzanine-ui/ng/clear-actions';
import type {
  ClearActionsType,
  ClearActionsEmbeddedVariant,
  ClearActionsStandardVariant,
  ClearActionsVariant,
} from '@mezzanine-ui/ng/clear-actions';
```

## Selector

`button[mznClearActions]` — component applied to a `<button>` element only.

## Inputs

| Input     | Type                                                         | Default      | Description                                                    |
| --------- | ------------------------------------------------------------ | ------------ | -------------------------------------------------------------- |
| `type`    | `ClearActionsType`                                           | `'standard'` | `'standard' \| 'embedded' \| 'clearable'`                      |
| `aria-label` | `string`                                                  | `'Close'`    | 按鈕的可及名稱（signal input，property 名稱為 `ariaLabel`，template 以 alias `aria-label` 綁定）；請與介面其餘文案一起翻譯 |
| `variant` | `ClearActionsEmbeddedVariant \| ClearActionsStandardVariant` | —            | Visual variant: `standard` → `'base' \| 'inverse'`, `embedded` → `'contrast' \| 'emphasis'`; ignored when `type='clearable'` (always `'default'`) |

> There is no `disabled` input on `MznClearActions`. Disable via the parent component.
>
> The `variant` input has no signal-level default. The component computes the fallback internally: `'base'` for `standard`, `'contrast'` for `embedded`, and `'default'` for `clearable`. Do not assume any particular default when reading the API.

## Outputs

| Output    | Type                           | Description            |
| --------- | ------------------------------ | ---------------------- |
| `clicked` | `OutputEmitterRef<MouseEvent>` | Button click event     |

## Usage

```html
<!-- If you must use it directly -->
<button mznClearActions type="standard" (clicked)="onClose()"></button>
<button mznClearActions type="clearable" (clicked)="onClear()"></button>
```

## Notes

- The host selector is `button[mznClearActions]` — only valid on `<button>` elements.
- `aria-label` defaults to `"Close"`; override it via the `aria-label` input (e.g. `<button mznClearActions aria-label="清除">`). Button type is forced to `"button"` to prevent form submission.
- For clearable inputs, use `[clearable]="true"` on the input/select component; it will render `MznClearActions` internally.
