# Field Type → Component Mapping

This mapping defines which mezzanine-ui component to use for each field type in different contexts.

## Mapping Table

| Field Type | Table Column Render | Form Component | Filter Component |
|------------|-------------------|----------------|-----------------|
| `string` | `<Typography>{value}</Typography>` | `<InputField>` | `<InputField>` with `SearchIcon` |
| `text` | `<Typography>` (max 50 chars + ellipsis) | `<TextAreaField>` | — (not filterable) |
| `number` | `<Typography>{value.toLocaleString()}</Typography>` | `<InputField>` with `type="number"` | `<InputField>` with `type="number"` |
| `date` | `format(value, 'yyyy/MM/dd')` | `<DatePickerField>` | `<DateRangePickerField>` |
| `datetime` | `format(value, 'yyyy/MM/dd HH:mm')` | `<DateTimePickerField>` | `<DateRangePickerField>` |
| `boolean` | `<Tag label={value ? '是' : '否'} />` | `<RadioGroupField>` options: 是/否 | `<SingleSelectField>` options: 全部/是/否 |
| `enum` | `<Tag label={enumLabel} />` | `<SingleSelectField>` | `<SingleSelectField>` |
| `select` | Related entity display name | `<SingleSelectField>` (options from related mock) | `<SingleSelectField>` |
| `multiselect` | Comma-joined `<Tag>` list | `<MultiSelectField>` (options from related mock or static) | `<MultiSelectField>` |
| `image` | `<img>` thumbnail (64×64) or placeholder | `<UploadImageField>` | — (not filterable) |
| `file` | File name as `<Typography>` link | `<UploadFileField>` | — (not filterable) |
| `password` | `<Typography>••••••</Typography>` (masked) | `<PasswordField>` | — (not filterable) |
| `autocomplete` | `<Typography>{value}</Typography>` | `<AutoCompleteField>` (options from static list or related entity) | `<AutoCompleteField>` |

## Import Sources

```tsx
// Table rendering
import { Typography, Tag } from '@mezzanine-ui/react';

// Form fields (all from react-hook-form-v2)
import {
  InputField,
  TextAreaField,
  SingleSelectField,
  MultiSelectField,
  DatePickerField,
  DateRangePickerField,
  DateTimePickerField,
  RadioGroupField,
  CheckboxField,
  UploadImageField,
  UploadFileField,
  PasswordField,
  AutoCompleteField,
} from '@mezzanine-ui/react-hook-form-v2';

// Icons for filter inputs
import { SearchIcon } from '@mezzanine-ui/icons';
```

## Column Render Examples

### String Column

```tsx
{ title: '名稱', dataIndex: 'name', width: 200 }
```

### Number Column (formatted)

```tsx
{
  title: '單價',
  width: 120,
  align: 'end' as const,
  render: (source) => (
    <Typography variant="body">
      {source.price.toLocaleString()}
    </Typography>
  ),
}
```

### Date Column

```tsx
import { format } from 'date-fns';

{
  title: '建立日期',
  width: 150,
  render: (source) => format(new Date(source.createdAt), 'yyyy/MM/dd'),
}
```

### Boolean Column (Tag)

```tsx
{
  title: '狀態',
  width: 100,
  render: (source) => (
    <Tag label={source.isActive ? '啟用' : '停用'} />
  ),
}
```

### Enum Column (Tag with mapping)

```tsx
const statusLabels: Record<string, string> = {
  pending: '待處理',
  approved: '已核准',
  rejected: '已拒絕',
};

{
  title: '審核狀態',
  width: 120,
  render: (source) => (
    <Tag label={statusLabels[source.status] ?? source.status} />
  ),
}
```

### Multiselect Column (Tag list)

```tsx
{
  title: '標籤',
  width: 200,
  render: (source) => (
    <div style={{ display: 'flex', gap: 'var(--mzn-spacing-1)', flexWrap: 'wrap' }}>
      {source.tags.map((tag: string) => (
        <Tag key={tag} label={tag} />
      ))}
    </div>
  ),
}
```

### Image Column (Thumbnail)

```tsx
{
  title: '圖片',
  width: 80,
  render: (source) => (
    source.imageUrl
      ? <img src={source.imageUrl} alt="" style={{ width: 48, height: 48, objectFit: 'cover', borderRadius: 'var(--mzn-spacing-1)' }} />
      : <Typography color="text-neutral-light">—</Typography>
  ),
}
```

### File Column (Filename)

```tsx
{
  title: '附件',
  width: 150,
  render: (source) => (
    <Typography variant="body">{source.fileName || '—'}</Typography>
  ),
}
```

## Form Field Examples

### Enum Field (SingleSelectField)

```tsx
const categoryOptions = [
  { id: 'raw', name: '原物料' },
  { id: 'semi', name: '半成品' },
  { id: 'finished', name: '成品' },
];

<SingleSelectField
  registerName="category"
  label="分類"
  options={categoryOptions}
  required
/>
```

### Boolean Field (RadioGroupField)

```tsx
<RadioGroupField
  registerName="isActive"
  label="啟用狀態"
  options={[
    { id: 'true', name: '啟用' },
    { id: 'false', name: '停用' },
  ]}
/>
```

### Multiselect Field (MultiSelectField)

```tsx
const tagOptions = [
  { id: 'urgent', name: '緊急' },
  { id: 'important', name: '重要' },
  { id: 'low', name: '低優先' },
];

<MultiSelectField
  registerName="tags"
  label="標籤"
  options={tagOptions}
/>
```

### Image Field (UploadImageField)

```tsx
// In prototypes, UploadImageField is display-only (no real upload)
// Use a mock URL as default value
<UploadImageField
  registerName="image"
  label="商品圖片"
/>
```

### File Field (UploadFileField)

```tsx
// In prototypes, UploadFileField is display-only (no real upload)
<UploadFileField
  registerName="attachment"
  label="附件"
/>
```

### Related Entity Field (SingleSelectField with mock data)

```tsx
// Options come from the related entity's mock data
const warehouseOptions = mockWarehouses.map((w) => ({
  id: w.id,
  name: w.name,
}));

<SingleSelectField
  registerName="warehouseId"
  label="倉庫"
  options={warehouseOptions}
  required
/>
```

## Validation Rules

When a `FieldSpec` has a `validation` property, map it to react-hook-form's `register` options via the `registerName` prop combined with `useForm`'s `rules`:

```tsx
// In the form component, pass validation rules through useForm
const methods = useForm<FormValues>({
  defaultValues: { /* ... */ },
});

// For string fields with min/max length:
<InputField
  registerName="name"
  label="商品名稱"
  required
  maxLength={validation.max}    // maps to maxLength prop
/>

// For number fields with min/max value, use react-hook-form register options:
// Pass via the form's resolver or inline validation
<InputField
  registerName="price"
  label="單價"
  type="number"
  required
/>

// Register with validation in the form setup:
methods.register('price', {
  min: { value: 1, message: '單價不得小於 1' },
  max: { value: 999999, message: '單價不得超過 999999' },
});

// For pattern validation:
methods.register('email', {
  pattern: { value: /^[^\s@]+@[^\s@]+\.[^\s@]+$/, message: '請輸入有效的 Email' },
});
```

### Validation Mapping Table

| Field Type | validation.min/max meaning   | Implementation                                    |
|------------|------------------------------|---------------------------------------------------|
| `string`   | min/max character length     | `minLength` / `maxLength` props or register rules |
| `text`     | min/max character length     | `minLength` / `maxLength` register rules          |
| `number`   | min/max numeric value        | `min` / `max` register rules                     |
| `date`     | not applicable               | —                                                |
| `enum`     | not applicable               | —                                                |
| any        | validation.pattern           | `pattern` register rule with regex                |
| any        | validation.message           | Custom error message for the rule                 |

## Filter Form Pattern

Filters are rendered as a horizontal form row using `flex` layout:

```tsx
import { useForm } from 'react-hook-form';
import { InputField, SingleSelectField, DateRangePickerField } from '@mezzanine-ui/react-hook-form-v2';
import { Button, Icon } from '@mezzanine-ui/react';
import { SearchIcon } from '@mezzanine-ui/icons';

interface FilterValues {
  keyword: string;
  category: string;
  dateRange: [string, string];
}

function ProductFilters({ onFilter }: { onFilter: (values: FilterValues) => void }) {
  const methods = useForm<FilterValues>();

  return (
    <FormFieldsWrapper methods={methods} onSubmit={onFilter}>
      <div style={{ display: 'flex', gap: 'var(--mzn-spacing-4)', alignItems: 'flex-end', flexWrap: 'wrap' }}>
        <InputField
          registerName="keyword"
          label="關鍵字"
          placeholder="搜尋名稱或 SKU"
          prefix={<Icon icon={SearchIcon} />}
        />
        <SingleSelectField
          registerName="category"
          label="分類"
          options={categoryOptions}
          clearable
        />
        <DateRangePickerField
          registerName="dateRange"
          label="建立日期"
        />
        <Button type="submit" variant="base-primary">搜尋</Button>
      </div>
    </FormFieldsWrapper>
  );
}
```
