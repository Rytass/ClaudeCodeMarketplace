# Form Modal Template

## Complete Template

```tsx
'use client';

import { useCallback, useEffect, type ReactNode } from 'react';
import { useForm } from 'react-hook-form';
import { yupResolver } from '@hookform/resolvers/yup';
import * as yup from 'yup';
import Modal, { ModalHeader, ModalFooter } from '@mezzanine-ui/react/Modal';
import FormField from '@mezzanine-ui/react/Form/FormField';
import { FormFieldLayout } from '@mezzanine-ui/core/form';
import Input from '@mezzanine-ui/react/Input';
import type { Get{Entities}Query } from '@/graphql/generated/graphql';
import styles from './{entity}-form-modal.module.scss';

type {Entity} = Get{Entities}Query['{entities}'][number];

// --- Yup Schema ---
const {entity}FormSchema = yup.object({
  name: yup
    .string()
    .required('Please enter a name')
    .min(1, 'Name must be at least 1 character')
    .max(50, 'Name must be at most 50 characters'),
  // Add more fields as needed
});

type {Entity}FormData = yup.InferType<typeof {entity}FormSchema>;

// --- Props ---
interface {Entity}FormModalProps {
  readonly open: boolean;
  readonly {entity}: {Entity} | null;
  readonly loading: boolean;
  readonly onClose: () => void;
  readonly onSubmit: (data: {Entity}FormData) => Promise<void>;
}

export function {Entity}FormModal({
  open,
  {entity},
  loading,
  onClose,
  onSubmit,
}: {Entity}FormModalProps): ReactNode {
  const isEditMode = {entity} !== null;

  const {
    register,
    handleSubmit,
    reset,
    formState: { errors },
  } = useForm<{Entity}FormData>({
    resolver: yupResolver({entity}FormSchema),
    defaultValues: {
      name: '',
    },
  });

  // --- Reset form on open ---
  useEffect(() => {
    if (open && {entity}) {
      reset({ name: {entity}.name });
    } else if (open && !{entity}) {
      reset({ name: '' });
    }
  }, [open, {entity}, reset]);

  const handleFormSubmit = useCallback(
    async (data: {Entity}FormData): Promise<void> => {
      await onSubmit(data);
    },
    [onSubmit],
  );

  return (
    <Modal modalType="standard" open={open} onClose={onClose}>
      <ModalHeader title={isEditMode ? 'Edit {entityLabel}' : 'Create {entityLabel}'} />
      <form
        onSubmit={e => {
          void handleSubmit(handleFormSubmit)(e);
        }}
      >
        <div className={styles.body}>
          <FormField
            name="name"
            label="Name"
            layout={FormFieldLayout.VERTICAL}
            required
            severity={errors.name ? 'error' : 'info'}
            hintText={errors.name?.message}
          >
            <Input
              fullWidth
              placeholder="Enter name"
              error={!!errors.name}
              name={register('name').name}
              onChange={e => {
                void register('name').onChange(e);
              }}
              onBlur={e => {
                void register('name').onBlur(e);
              }}
              inputRef={register('name').ref}
            />
          </FormField>
        </div>
        <ModalFooter
          cancelText="Cancel"
          confirmText={isEditMode ? 'Save' : 'Create'}
          onCancel={onClose}
          cancelButtonProps={{ disabled: loading }}
          confirmButtonProps={{ type: 'submit', loading }}
        />
      </form>
    </Modal>
  );
}
```

## Mezzanine Input + react-hook-form Binding

Mezzanine UI's Input component does NOT support direct `{...register('field')}` spread. You MUST bind manually:

```tsx
<Input
  fullWidth
  placeholder="Enter value"
  error={!!errors.fieldName}
  name={register('fieldName').name}
  onChange={e => {
    void register('fieldName').onChange(e);
  }}
  onBlur={e => {
    void register('fieldName').onBlur(e);
  }}
  inputRef={register('fieldName').ref}
/>
```

### Why You Cannot Spread register Directly

Mezzanine `Input`'s `onChange` type differs from native input. Spreading directly causes type conflicts. Manual binding is the established pattern in this project.

## FormField Usage Notes

```tsx
<FormField
  name="fieldName"               // Corresponds to the register name
  label="Field Title"            // Displayed above the field
  layout={FormFieldLayout.VERTICAL}  // Vertical layout (label on top, input below)
  required                        // Shows required mark *
  severity={errors.fieldName ? 'error' : 'info'}  // Error styling
  hintText={errors.fieldName?.message}             // Error message
>
  {/* Input / Select / Textarea / ... */}
</FormField>
```

## Modal Structure

```
Modal (modalType="standard")
├── ModalHeader (title)
├── form (onSubmit)
│   ├── div.body (form fields area)
│   │   ├── FormField + Input
│   │   ├── FormField + Select
│   │   └── ...
│   └── ModalFooter
│       ├── cancelText + onCancel
│       └── confirmText + confirmButtonProps (type: 'submit')
```

### ModalFooter Key Settings

```tsx
<ModalFooter
  cancelText="Cancel"
  confirmText={isEditMode ? 'Save' : 'Create'}
  onCancel={onClose}
  cancelButtonProps={{ disabled: loading }}
  confirmButtonProps={{ type: 'submit', loading }}  // type: 'submit' triggers form submission
/>
```

## SCSS Module

```scss
// {entity}-form-modal.module.scss
.body {
  min-width: 400px;
  // Add spacing for multiple fields
  display: flex;
  flex-direction: column;
  gap: 16px;
}
```

## Create / Edit Dual-Mode Logic

Determine mode by checking whether the `{entity}` prop is `null`:

| Mode   | `{entity}` prop | ModalHeader title   | ConfirmText |
|--------|-----------------|---------------------|-------------|
| Create | `null`          | Create {entityLabel} | Create      |
| Edit   | `{Entity}`      | Edit {entityLabel}   | Save        |

`useEffect` resets the form based on mode when `open` becomes `true`.

## Common Form Field Types

### Select (Dropdown)

```tsx
import Select from '@mezzanine-ui/react/Select';
import { useWatch, useController } from 'react-hook-form';

const { field } = useController({ name: 'status', control });

<FormField name="status" label="Status" layout={FormFieldLayout.VERTICAL}>
  <Select
    fullWidth
    value={field.value}
    onChange={field.onChange}
    options={[
      { value: 'ACTIVE', label: 'Active' },
      { value: 'INACTIVE', label: 'Inactive' },
    ]}
  />
</FormField>
```

### Textarea

```tsx
import Textarea from '@mezzanine-ui/react/Textarea';

<FormField name="description" label="Description" layout={FormFieldLayout.VERTICAL}>
  <Textarea
    fullWidth
    rows={4}
    placeholder="Enter description"
    name={register('description').name}
    onChange={e => {
      void register('description').onChange(e);
    }}
    onBlur={e => {
      void register('description').onBlur(e);
    }}
    inputRef={register('description').ref}
  />
</FormField>
```
