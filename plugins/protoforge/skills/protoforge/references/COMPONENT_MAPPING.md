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
| `boolean` | `<Tag color={value ? 'success' : 'default'}>{value ? '是' : '否'}</Tag>` | `<RadioGroupField>` options: 是/否 | `<SingleSelectField>` options: 全部/是/否 |
| `enum` | `<Tag>{enumLabel}</Tag>` | `<SingleSelectField>` | `<SingleSelectField>` |
| `select` | Related entity display name | `<SingleSelectField>` (options from related mock) | `<SingleSelectField>` |

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
    <Typography variant="body1">
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
    <Tag color={source.isActive ? 'success' : 'default'}>
      {source.isActive ? '啟用' : '停用'}
    </Tag>
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
    <Tag>{statusLabels[source.status] ?? source.status}</Tag>
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
        <Button type="submit" variant="contained">搜尋</Button>
      </div>
    </FormFieldsWrapper>
  );
}
```
