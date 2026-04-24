# Modal

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/ng/modal) · Verified 1.0.0-rc.4 (2026-04-24)

Dialog overlay component backed by a `MznBackdrop`. Provides `MznModalHeader` and `MznModalFooter` as companion components, both reading state from the `MZN_MODAL_CONTEXT` injection token. Escape-key handling is mediated by `EscapeKeyService` + `TopStackService` so only the top-most modal closes.

## Import

```ts
import {
  MznModal,
  MznModalHeader,
  MznModalFooter,
  MznModalBodyContainer,
  MznModalBodyForVerification,
} from '@mezzanine-ui/ng/modal';

import type { ModalSize, ModalStatusType, ModalType } from '@mezzanine-ui/core/modal';
```

## Selectors

| Selector                          | Role                                                       |
| --------------------------------- | ---------------------------------------------------------- |
| `[mznModal]`                      | Root dialog overlay                                        |
| `[mznModalHeader]`                | Title + optional status icon row                           |
| `[mznModalFooter]`                | Confirm / cancel button row with auxiliary options         |
| `[mznModalBodyContainer]`         | Angular-only scroll-aware body wrapper (see below)         |
| `[mznModalBodyForVerification]`   | Verification / confirm-code body variant                   |

### Angular-only body directives

Unlike React (which auto-wraps children in a scroll-aware body container), Angular uses `ng-content` projection so consumers must opt-in explicitly:

- **`[mznModalBodyContainer]`** — apply to a body wrapper element to enable the scroll-triggered separator (the horizontal line that appears between header and body when content scrolls). Without this directive the separator stays hidden. When the parent `mznModal` has `modalType="extended"`, both top and bottom separators are forced permanently visible regardless of scroll position.
- **`[mznModalBodyForVerification]`** — body variant used by verification / OTP / confirmation flows; pre-styles inner spacing for that pattern.

```html
<section mznModal [(open)]="open" [showModalHeader]="true" [showModalFooter]="true">
  <header mznModalHeader title="確認刪除" modalStatusType="delete"></header>

  <div mznModalBodyContainer>
    <!-- Long content here — separator auto-appears on scroll -->
    <p mznTypography variant="body">...</p>
  </div>

  <footer mznModalFooter confirmText="確定" cancelText="取消"></footer>
</section>
```

## MznModal — Inputs

| Input                          | Type               | Default      | Description                                                          |
| ------------------------------ | ------------------ | ------------ | -------------------------------------------------------------------- |
| `open`                         | `boolean`          | `false`      | Controls modal visibility                                            |
| `size`                         | `ModalSize`        | `'regular'`  | `'regular' \| 'large' \| 'wide'`                                    |
| `loading`                      | `boolean`          | `false`      | Propagated to `MznModalFooter` confirm button via context            |
| `modalStatusType`              | `ModalStatusType`  | `'info'`     | `'info' \| 'success' \| 'warning' \| 'error' \| 'delete' \| 'email'` |
| `modalType`                    | `ModalType`        | `'standard'` | `'standard' \| 'split' \| 'extended'` — `'extended'` forces both scroll separators permanently visible |
| `fullScreen`                   | `boolean`          | `false`      | Full-screen mode                                                     |
| `showDismissButton`            | `boolean`          | `true`       | Show ✕ close icon in the corner                                      |
| `showModalHeader`              | `boolean`          | `false`      | Project `[mznModalHeader]` slot (renders header ng-content)          |
| `showModalFooter`              | `boolean`          | `false`      | Project `[mznModalFooter]` slot (renders footer ng-content)          |
| `disableCloseOnBackdropClick`  | `boolean`          | `false`      | Prevent backdrop click from closing                                  |
| `disableCloseOnEscapeKeyDown`  | `boolean`          | `false`      | Prevent Escape key from closing                                      |
| `disablePortal`                | `boolean`          | `false`      | Render modal in-place instead of via portal                          |
| `backdropClassName`            | `string \| undefined` | —         | Extra class on the backdrop element                                  |
| `dialogStyle`                  | `Record<string, string> \| undefined` | — | Inline styles on the dialog element (e.g. `{ width: '640px' }`)  |

> Inputs declared with signal API (`input()`, `model()`) accept both static and reactive values.

## MznModal — Outputs

| Output          | Type                    | Description                               |
| --------------- | ----------------------- | ----------------------------------------- |
| `closed`        | `OutputEmitterRef<void>` | Fires when modal closes (any trigger)    |
| `backdropClick` | `OutputEmitterRef<void>` | Fires on backdrop click                  |

## MznModalHeader — Inputs

| Input                 | Type                         | Default      | Description                             |
| --------------------- | ---------------------------- | ------------ | --------------------------------------- |
| `title`               | `string` (**required**)     | —            | Heading text                            |
| `supportingText`      | `string \| undefined`        | —            | Subtitle text below the heading         |
| `showStatusTypeIcon`  | `boolean`                    | `false`      | Show status icon (colour from context)  |
| `statusTypeIconLayout`| `'horizontal' \| 'vertical'` | `'vertical'` | Icon beside or above the title          |
| `titleAlign`          | `'left' \| 'center'`         | `'left'`     | Title alignment                         |
| `supportingTextAlign` | `'left' \| 'center'`         | `'left'`     | Supporting text alignment               |

## MznModalFooter — Inputs

| Input                      | Type                                                            | Default          | Description                                   |
| -------------------------- | --------------------------------------------------------------- | ---------------- | --------------------------------------------- |
| `confirmText`              | `string`                                                        | `'確認'`         | Confirm button text                           |
| `cancelText`               | `string`                                                        | `'取消'`         | Cancel button text                            |
| `showCancelButton`         | `boolean`                                                       | `true`           | Show cancel button                            |
| `confirmButtonVariant`     | `ButtonVariant`                                                 | `'base-primary'` | Confirm button variant                        |
| `actionsButtonLayout`      | `'fill' \| 'fixed'`                                             | `'fixed'`        | Button sizing                                 |
| `auxiliaryContentType`     | `'annotation' \| 'button' \| 'checkbox' \| 'password' \| 'toggle' \| undefined` | — | Left-side helper content |
| `auxiliaryContentLabel`    | `string \| undefined`                                           | —                | Label for checkbox/toggle helper              |
| `auxiliaryContentChecked`  | `boolean`                                                       | `false`          | Checked state for checkbox/toggle helper      |
| `auxiliaryContentButtonText`| `string \| undefined`                                          | —                | Button text for button-type helper            |
| `annotation`               | `string \| undefined`                                           | —                | Annotation text (type='annotation')           |
| `passwordChecked`          | `boolean`                                                       | `false`          | Remember-me state for password helper         |
| `passwordCheckedLabel`     | `string \| undefined`                                           | —                | Remember-me label for password helper         |
| `passwordButtonText`       | `string \| undefined`                                           | —                | "Forgot password" button text                 |

## MznModalFooter — Outputs

| Output                    | Type                       | Description                       |
| ------------------------- | -------------------------- | --------------------------------- |
| `confirmed`               | `OutputEmitterRef<void>`   | Confirm button clicked            |
| `cancelled`               | `OutputEmitterRef<void>`   | Cancel button clicked             |
| `auxiliaryContentChanged` | `OutputEmitterRef<boolean>`| Helper checkbox/toggle changed    |
| `auxiliaryContentClicked` | `OutputEmitterRef<void>`   | Helper button clicked             |
| `passwordCheckedChanged`  | `OutputEmitterRef<boolean>`| Remember-me checkbox changed      |
| `passwordClicked`         | `OutputEmitterRef<void>`   | Forgot password button clicked    |

## MznModalBodyForVerification — Inputs

Selector: `[mznModalBodyForVerification]`

Used for OTP / verification code entry flows. Renders multiple single-character input fields with auto-advance, Backspace, arrow-key navigation, paste distribution, and a configurable resend prompt.

| Input          | Type                  | Default          | Description                                               |
| -------------- | --------------------- | ---------------- | --------------------------------------------------------- |
| `autoFocus`    | `boolean`             | `true`           | Auto-focus the first field after mount                    |
| `disabled`     | `boolean`             | `false`          | Disable all input fields                                  |
| `error`        | `boolean`             | `false`          | Apply error styling to all fields                         |
| `length`       | `number`              | `4`              | Number of character fields                                |
| `readOnly`     | `boolean`             | `false`          | Read-only mode                                            |
| `resendPrompt` | `string`              | `'收不到驗證碼？'` | Prompt text before the resend link                       |
| `resendText`   | `string \| undefined` | —                | Resend link text; when set the resend row becomes visible |
| `value`        | `string`              | `''`             | Initial value distributed across fields                   |

## MznModalBodyForVerification — Outputs

| Output        | Type              | Description                                             |
| ------------- | ----------------- | ------------------------------------------------------- |
| `valueChange` | `output<string>()` | Emitted on every field change; value is all fields joined |
| `completed`   | `output<string>()` | Emitted when all fields are filled; value is the full code |
| `resent`      | `output<void>()`   | Emitted when the resend link is clicked                 |

### Verification Usage Example

```html
<div mznModal [open]="isOpen" [showModalHeader]="true" [showModalFooter]="true">
  <div mznModalHeader title="輸入驗證碼" supportingText="已寄送至您的手機"></div>
  <div mznModalBodyForVerification
    [length]="6"
    [autoFocus]="true"
    resendText="重新發送"
    (valueChange)="onCodeChange($event)"
    (completed)="onComplete($event)"
    (resent)="onResend()"
  ></div>
  <div mznModalFooter confirmText="確認" (confirmed)="onSubmit()" (cancelled)="isOpen = false"></div>
</div>
```

## DI Tokens / Services Required

`MznModal` auto-provides the following services at the root level — no manual provider setup is needed:

| Service / Token            | Purpose                                              |
| -------------------------- | ---------------------------------------------------- |
| `EscapeKeyService`         | Tracks Escape keydown globally (singleton)           |
| `TopStackService`          | Ensures only the topmost overlay closes on Escape    |
| `MZN_MODAL_CONTEXT`        | Provides `modalStatusType` and `loading` to children |

The context is provided per-`mznModal` instance — child `mznModalHeader` and `mznModalFooter` read it via `inject(MZN_MODAL_CONTEXT, { optional: true })`.

## ControlValueAccessor

No.

## Usage

```html
<!-- Standard confirmation modal -->
<div mznModal
  [open]="isOpen"
  [loading]="isSaving"
  [showModalHeader]="true"
  [showModalFooter]="true"
  modalStatusType="error"
  (closed)="isOpen = false"
>
  <div mznModalHeader
    title="確認刪除"
    supportingText="此操作無法復原"
    [showStatusTypeIcon]="true"
  ></div>
  <div class="mzn-modal__body-container">
    <p>確定要刪除這筆資料嗎？</p>
  </div>
  <div mznModalFooter
    confirmText="刪除"
    [confirmButtonVariant]="'destructive-primary'"
    (confirmed)="onDelete()"
    (cancelled)="isOpen = false"
  ></div>
</div>

<!-- Wide modal with fixed dialog width -->
<div mznModal
  [open]="isOpen"
  size="wide"
  [dialogStyle]="{ width: '760px', maxWidth: '760px' }"
  (closed)="isOpen = false"
>
  <div class="mzn-modal__body-container">自訂內容</div>
</div>
```

```ts
import { MznModal, MznModalHeader, MznModalFooter } from '@mezzanine-ui/ng/modal';

isOpen = false;
isSaving = false;

async onDelete(): Promise<void> {
  this.isSaving = true;
  await this.service.delete();
  this.isSaving = false;
  this.isOpen = false;
}
```

## Notes

- `showModalHeader` and `showModalFooter` must be `true` to enable the corresponding `ng-content` slot — the slots are rendered conditionally in the modal template.
- The `loading` input is forwarded to `MznModalFooter` through `MZN_MODAL_CONTEXT`; you only need to set it on `mznModal`, not on `mznModalFooter`.
- `modalStatusType` propagates to `MznModalHeader` via the same context and determines the status icon colour.
- When multiple modals are stacked, `TopStackService` + `EscapeKeyService` ensure the Escape key only closes the frontmost modal.
- The React counterpart has `ModalSplitLayout`, `ModalCloseIcon`, `ModalBody`, and `ModalActions` sub-components; in the Angular version, layout is controlled by the `modalType` input (`'standard' | 'split' | 'extended'`) and the `[mznModalBodyContainer]` directive.
- `modalType='extended'` forces both scroll separators (top + bottom) visible unconditionally — useful when you always want the visual separation regardless of whether the body content is scrollable.
