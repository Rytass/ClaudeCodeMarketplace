# Modal Component

> **Category**: Feedback
>
> **Storybook**: `Feedback/Modal`
>
> **Source**: [GitHub Source Code](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/react/src/Modal) | Verified: 2026-02-13

A dialog component for scenarios requiring user attention or action.

## Import

```tsx
import {
  Modal,
  ModalHeader,
  ModalFooter,
  ModalBodyForVerification,
  useModalContainer,
} from '@mezzanine-ui/react';

import type {
  ModalProps,
  ModalHeaderProps,
  ModalFooterProps,
  ModalBodyForVerificationProps,
  ModalSize,
  ModalStatusType,
} from '@mezzanine-ui/react';

// The following components and types must be imported from sub-path
import { MediaPreviewModal } from '@mezzanine-ui/react/Modal';
import type {
  ModalContainerProps,
  MediaPreviewModalProps,
} from '@mezzanine-ui/react/Modal';
```

---

## Modal Props

Modal Props is a union type; required fields depend on `modalType` and `showModalHeader`/`showModalFooter` values.

### Common Props

Extends `ModalContainerProps` (excluding `children`) with partial `ModalHeaderProps` and `ModalFooterProps` properties.

| Property                         | Type              | Default      | Description                      |
| -------------------------------- | ----------------- | ------------ | -------------------------------- |
| `open`                           | `boolean`         | -            | Whether open                     |
| `onClose`                        | `() => void`      | -            | Close callback                   |
| `container`                      | `Element`         | -            | Portal target container          |
| `disableCloseOnBackdropClick`    | `boolean`         | `false`      | Disable close on backdrop click  |
| `disableCloseOnEscapeKeyDown`    | `boolean`         | `false`      | Disable close on ESC key         |
| `disablePortal`                  | `boolean`         | `false`      | Disable Portal rendering         |
| `onBackdropClick`                | `() => void`      | -            | Backdrop click callback          |
| `fullScreen`                     | `boolean`         | `false`      | Whether full screen              |
| `loading`                        | `boolean`         | `false`      | Whether loading                  |
| `modalStatusType`                | `ModalStatusType` | `'info'`     | Status icon type                 |
| `showDismissButton`              | `boolean`         | `true`       | Whether to show top-right close button |

### Standard/Extended Modal Props (modalType is not extendedSplit)

| Property    | Type                                                                | Default      | Description |
| ----------- | ------------------------------------------------------------------- | ------------ | ----------- |
| `modalType` | `'standard' \| 'extended' \| 'mediaPreview' \| 'verification'`     | `'standard'` | Dialog type |
| `size`      | `ModalSize`                                                         | `'regular'`  | Dialog size |

### Split Modal Props (modalType = extendedSplit)

| Property                        | Type        | Default  | Description       |
| ------------------------------- | ----------- | -------- | ----------------- |
| `modalType`                     | `'extendedSplit'` | **Required** | Split mode  |
| `size`                          | `'wide'`    | `'wide'` | Fixed to wide     |
| `extendedSplitLeftSideContent`  | `ReactNode` | **Required** | Left content |
| `extendedSplitRightSideContent` | `ReactNode` | **Required** | Right content|

### Conditionally Required Props

| Condition                  | Required Field  | Description                  |
| -------------------------- | --------------- | ---------------------------- |
| `showModalHeader = true`   | `title`         | Title (`string`)             |
| `showModalFooter = true`   | `confirmText`   | Confirm button text (`string`) |

### Header-related Props (when showModalHeader = true)

From `Partial<Omit<ModalHeaderProps, 'children' | 'className' | 'title'>>`.

| Property               | Type                         | Default      | Description          |
| ---------------------- | ---------------------------- | ------------ | -------------------- |
| `title`                | `string`                     | **Required** | Title                |
| `showStatusTypeIcon`   | `boolean`                    | `false`      | Show status icon     |
| `statusTypeIconLayout` | `'vertical' \| 'horizontal'` | `'vertical'` | Status icon layout   |
| `supportingText`       | `string`                     | -            | Supporting text      |
| `supportingTextAlign`  | `'left' \| 'center'`         | `'left'`     | Supporting text align|
| `titleAlign`           | `'left' \| 'center'`         | `'left'`     | Title alignment      |

### Footer-related Props (when showModalFooter = true)

From `Partial<Omit<ModalFooterProps, 'children' | 'className' | 'confirmText'>>`.

| Property                        | Type                                                              | Default   | Description                |
| ------------------------------- | ----------------------------------------------------------------- | --------- | -------------------------- |
| `confirmText`                   | `string`                                                          | **Required** | Confirm button text     |
| `cancelText`                    | `ReactNode`                                                       | -         | Cancel button text         |
| `onConfirm`                     | `ButtonProps['onClick']`                                          | -         | Confirm button callback    |
| `onCancel`                      | `ButtonProps['onClick']`                                          | -         | Cancel button callback     |
| `actionsButtonLayout`           | `'fill' \| 'fixed'`                                               | `'fixed'` | Button layout mode         |
| `showCancelButton`              | `boolean`                                                         | `true`    | Show cancel button         |
| `cancelButtonProps`             | `ButtonProps`                                                     | -         | Cancel button extra props  |
| `confirmButtonProps`            | `ButtonProps`                                                     | -         | Confirm button extra props |
| `auxiliaryContentType`          | `'annotation' \| 'button' \| 'checkbox' \| 'toggle' \| 'password'` | -       | Auxiliary content type     |
| `annotation`                    | `ReactNode`                                                       | -         | Annotation content         |
| `auxiliaryContentButtonProps`   | `ButtonProps`                                                     | -         | Auxiliary button props     |
| `auxiliaryContentButtonText`    | `ReactNode`                                                       | -         | Auxiliary button text      |
| `auxiliaryContentChecked`       | `boolean`                                                         | -         | Checkbox/toggle checked    |
| `auxiliaryContentLabel`         | `string`                                                          | -         | Checkbox/toggle label      |
| `auxiliaryContentOnChange`      | `(checked: boolean) => void`                                      | -         | Checkbox/toggle callback   |
| `auxiliaryContentOnClick`       | `ButtonProps['onClick']`                                          | -         | Auxiliary button click     |
| `passwordButtonProps`           | `ButtonProps`                                                     | -         | Password button props      |
| `passwordButtonText`            | `ReactNode`                                                       | -         | Password button text       |
| `passwordChecked`               | `boolean`                                                         | -         | Password visibility state  |
| `passwordCheckedLabel`          | `string`                                                          | -         | Password visibility label  |
| `passwordCheckedOnChange`       | `(checked: boolean) => void`                                      | -         | Password visibility callback |
| `passwordOnClick`               | `ButtonProps['onClick']`                                          | -         | Password button click      |

---

## ModalSize Type

| Size      | Description |
| --------- | ----------- |
| `tight`   | Tight       |
| `narrow`  | Narrow      |
| `regular` | Regular     |
| `wide`    | Wide        |

---

## modalType Values

| Value           | Description                              |
| --------------- | ---------------------------------------- |
| `standard`      | Standard dialog                          |
| `extended`      | Extended dialog                          |
| `extendedSplit` | Split dialog (footer in left content)    |
| `mediaPreview`  | Media preview                            |
| `verification`  | Verification flow                        |

---

## ModalStatusType Type

| StatusType | Description | Icon               |
| ---------- | ----------- | ------------------ |
| `success`  | Success     | CheckedOutlineIcon |
| `warning`  | Warning     | WarningOutlineIcon |
| `error`    | Error       | ErrorOutlineIcon   |
| `info`     | Info        | InfoOutlineIcon    |
| `email`    | Email       | MailIcon           |
| `delete`   | Delete      | TrashIcon          |

---

## Usage Examples

### Basic Usage

```tsx
import { useState } from 'react';
import { Modal, Button } from '@mezzanine-ui/react';

function BasicModal() {
  const [open, setOpen] = useState(false);

  return (
    <>
      <Button onClick={() => setOpen(true)}>Open Dialog</Button>

      <Modal
        open={open}
        onClose={() => setOpen(false)}
        showModalHeader
        title="Dialog Title"
        showModalFooter
        cancelText="Cancel"
        confirmText="Confirm"
        onCancel={() => setOpen(false)}
        onConfirm={() => setOpen(false)}
      >
        <p>Dialog content</p>
      </Modal>
    </>
  );
}
```

### Delete Confirmation Dialog

```tsx
function DeleteConfirmModal({ itemName, onConfirm, onClose }) {
  return (
    <Modal
      open
      onClose={onClose}
      size="narrow"
      modalStatusType="delete"
      showModalHeader
      title="Confirm Delete"
      showModalFooter
      cancelText="Cancel"
      confirmText="Delete"
      onCancel={onClose}
      onConfirm={onConfirm}
    >
      <Typography>Are you sure you want to delete "{itemName}"? This action cannot be undone.</Typography>
    </Modal>
  );
}
```

### With Loading State

```tsx
function ModalWithLoading() {
  const [open, setOpen] = useState(false);
  const [loading, setLoading] = useState(false);

  const handleConfirm = async () => {
    setLoading(true);
    try {
      await submitData();
      setOpen(false);
    } finally {
      setLoading(false);
    }
  };

  return (
    <Modal
      open={open}
      onClose={() => setOpen(false)}
      loading={loading}
      showModalHeader
      title="Submit Data"
      showModalFooter
      cancelText="Cancel"
      confirmText="Submit"
      onCancel={() => setOpen(false)}
      onConfirm={handleConfirm}
    >
      Content...
    </Modal>
  );
}
```

### Split Layout

```tsx
function ExtendedSplitModal() {
  return (
    <Modal
      open
      onClose={() => {}}
      modalType="extendedSplit"
      size="wide"
      extendedSplitLeftSideContent={
        <div>
          <Typography variant="h3">Left Content</Typography>
          <p>This is the main action area</p>
        </div>
      }
      extendedSplitRightSideContent={
        <div>
          <Typography variant="h3">Right Content</Typography>
          <p>This is the description or preview area</p>
        </div>
      }
      showModalFooter
      cancelText="Cancel"
      confirmText="Confirm"
    />
  );
}
```

---

## ModalHeader

Standalone header component for custom headers.

### Props

| Property               | Type                         | Default      | Description          |
| ---------------------- | ---------------------------- | ------------ | -------------------- |
| `showStatusTypeIcon`   | `boolean`                    | `false`      | Show status icon     |
| `statusTypeIconLayout` | `'vertical' \| 'horizontal'` | `'vertical'` | Status icon layout   |
| `supportingText`       | `string`                     | -            | Supporting text      |
| `supportingTextAlign`  | `'left' \| 'center'`         | `'left'`     | Supporting text align|
| `title`                | `string`                     | **Required** | Title text           |
| `titleAlign`           | `'left' \| 'center'`         | `'left'`     | Title alignment      |

Extends `NativeElementPropsWithoutKeyAndRef<'div'>`.

```tsx
<ModalHeader
  title="Warning"
  supportingText="Please read the following carefully"
  showStatusTypeIcon
/>
```

---

## ModalFooter

Standalone footer component for custom buttons.

### Props

| Property                         | Type                                                              | Default   | Description                |
| -------------------------------- | ----------------------------------------------------------------- | --------- | -------------------------- |
| `actionsButtonLayout`            | `'fill' \| 'fixed'`                                               | `'fixed'` | Button layout mode         |
| `annotation`                     | `ReactNode`                                                       | -         | Annotation content         |
| `auxiliaryContentType`           | `'annotation' \| 'button' \| 'checkbox' \| 'toggle' \| 'password'` | -       | Auxiliary content type     |
| `auxiliaryContentButtonProps`    | `ButtonProps`                                                     | -         | Auxiliary button props     |
| `auxiliaryContentButtonText`     | `ReactNode`                                                       | -         | Auxiliary button text      |
| `auxiliaryContentChecked`        | `boolean`                                                         | -         | Checkbox/toggle checked    |
| `auxiliaryContentLabel`          | `string`                                                          | -         | Checkbox/toggle label      |
| `auxiliaryContentOnChange`       | `(checked: boolean) => void`                                      | -         | Checkbox/toggle callback   |
| `auxiliaryContentOnClick`        | `ButtonProps['onClick']`                                          | -         | Auxiliary button click     |
| `cancelButtonProps`              | `ButtonProps`                                                     | -         | Cancel button extra props  |
| `cancelText`                     | `ReactNode`                                                       | -         | Cancel button text         |
| `confirmButtonProps`             | `ButtonProps`                                                     | -         | Confirm button extra props |
| `confirmText`                    | `ReactNode`                                                       | -         | Confirm button text        |
| `loading`                        | `boolean`                                                         | -         | Loading state              |
| `onCancel`                       | `ButtonProps['onClick']`                                          | -         | Cancel callback            |
| `onConfirm`                      | `ButtonProps['onClick']`                                          | -         | Confirm callback           |
| `passwordButtonProps`            | `ButtonProps`                                                     | -         | Password button props      |
| `passwordButtonText`             | `ReactNode`                                                       | -         | Password button text       |
| `passwordChecked`                | `boolean`                                                         | -         | Password visibility state  |
| `passwordCheckedLabel`           | `string`                                                          | -         | Password visibility label  |
| `passwordCheckedOnChange`        | `(checked: boolean) => void`                                      | -         | Password visibility callback |
| `passwordOnClick`                | `ButtonProps['onClick']`                                          | -         | Password button click      |
| `showCancelButton`               | `boolean`                                                         | `true`    | Show cancel button         |

```tsx
<ModalFooter
  confirmText="Confirm"
  cancelText="Cancel"
  onConfirm={handleConfirm}
  onCancel={handleCancel}
  auxiliaryContentType="checkbox"
  auxiliaryContentLabel="Don't show again"
  auxiliaryContentChecked={checked}
  auxiliaryContentOnChange={setChecked}
/>
```

---

## ModalBodyForVerification

Verification code input component for `modalType="verification"` scenarios.

### Props

| Property       | Type                       | Default          | Description            |
| -------------- | -------------------------- | ---------------- | ---------------------- |
| `autoFocus`    | `boolean`                  | `true`           | Auto-focus             |
| `disabled`     | `boolean`                  | `false`          | Whether disabled       |
| `error`        | `boolean`                  | `false`          | Whether error state    |
| `length`       | `number`                   | `4`              | Verification code length |
| `onChange`     | `(value: string) => void`  | -                | Value change callback  |
| `onComplete`   | `(value: string) => void`  | -                | Input complete callback|
| `onResend`     | `() => void`               | -                | Resend callback        |
| `readOnly`     | `boolean`                  | `false`          | Whether read-only      |
| `resendPrompt` | `string`                   | `"Didn't receive the code?"` | Resend prompt text   |
| `resendText`   | `string`                   | `'Click to resend'`          | Resend link text     |
| `value`        | `string`                   | `''`             | Current value          |

Extends `NativeElementPropsWithoutKeyAndRef<'div'>`.

```tsx
function VerificationModal() {
  const [code, setCode] = useState('');

  return (
    <Modal
      open
      onClose={() => {}}
      modalType="verification"
      showModalHeader
      title="Verification Code"
      showModalFooter
      confirmText="Confirm"
    >
      <ModalBodyForVerification
        length={6}
        value={code}
        onChange={setCode}
        onComplete={(val) => console.log('Complete:', val)}
        onResend={() => console.log('Resend')}
      />
    </Modal>
  );
}
```

---

## MediaPreviewModal

A dedicated dialog for media preview.

### Props

Extends `ModalContainerProps` (excluding `children`).

| Property                       | Type                             | Default | Description              |
| ------------------------------ | -------------------------------- | ------- | ------------------------ |
| `currentIndex`                 | `number`                         | -       | Controlled current index |
| `defaultIndex`                 | `number`                         | `0`     | Default index            |
| `disableNext`                  | `boolean`                        | `false` | Disable next page        |
| `disablePrev`                  | `boolean`                        | `false` | Disable previous page    |
| `enableCircularNavigation`     | `boolean`                        | `false` | Enable circular navigation |
| `mediaItems`                   | `(string \| React.ReactNode)[]`  | -       | Media item list          |
| `onIndexChange`                | `(index: number) => void`        | -       | Index change callback    |
| `onNext`                       | `() => void`                     | -       | Next page callback       |
| `onPrev`                       | `() => void`                     | -       | Previous page callback   |
| `showPaginationIndicator`      | `boolean`                        | `true`  | Show pagination indicator|

```tsx
import { MediaPreviewModal } from '@mezzanine-ui/react/Modal';

<MediaPreviewModal
  open={open}
  onClose={() => setOpen(false)}
  mediaItems={[
    '/image1.jpg',
    '/image2.jpg',
    <video src="/video.mp4" controls />,
  ]}
  defaultIndex={0}
  enableCircularNavigation
/>
```

---

## useModalContainer

A hook for getting the Modal container component.

### Return Value

```tsx
interface UseModalContainerReturn {
  Container: ModalContainer;
  defaultOptions: {
    className: string;
    disableCloseOnBackdropClick: false;
    disableCloseOnEscapeKeyDown: false;
    disablePortal: false;
    open: false;
  };
}
```

### ModalContainerProps

| Property                        | Type        | Default | Description                |
| ------------------------------- | ----------- | ------- | -------------------------- |
| `open`                          | `boolean`   | `false` | Whether open               |
| `onClose`                       | `() => void`| -       | Close callback             |
| `children`                      | `ReactNode` | -       | Children                   |
| `disableCloseOnBackdropClick`   | `boolean`   | `false` | Disable backdrop click close |
| `disableCloseOnEscapeKeyDown`   | `boolean`   | `false` | Disable ESC key close      |
| `disablePortal`                 | `boolean`   | `false` | Disable Portal rendering   |
| `container`                     | `Element`    | -       | Portal target container    |
| `onBackdropClick`               | `() => void` | -       | Backdrop click callback    |

```tsx
import { useModalContainer } from '@mezzanine-ui/react';

const { Container, defaultOptions } = useModalContainer();

<Container
  open={open}
  onClose={onClose}
  disableCloseOnBackdropClick={false}
  disableCloseOnEscapeKeyDown={false}
>
  {children}
</Container>
```

---

## Figma Mapping

| Figma Variant         | React Props                                |
| --------------------- | ------------------------------------------ |
| `Modal / Basic`       | `<Modal>`                                  |
| `Modal / With Header` | `<Modal showModalHeader title="...">`      |
| `Modal / With Footer` | `<Modal showModalFooter confirmText="...">`|
| `Modal / Size=Narrow` | `<Modal size="narrow">`                    |
| `Modal / Size=Wide`   | `<Modal size="wide">`                      |

---

## Best Practices

1. **Clear action intent**: Title should clearly describe the action
2. **Provide cancel option**: Allow users to exit
3. **Use destructive for dangerous actions**: Use `modalStatusType="delete"` for delete operations
4. **Prevent duplicate submissions during loading**: Use `loading` state
5. **Appropriate size**: Choose a suitable `size` based on content volume
