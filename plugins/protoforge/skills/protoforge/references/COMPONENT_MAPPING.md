# Field Type → Component Mapping

This table maps each `FieldSpec.type` in a `ProjectSpec` to (a) the column renderer used inside `<Table>`, (b) the form primitive used with `react-hook-form`, and (c) the filter primitive used in list filters. All components are from `@mezzanine-ui/react`.

> Component props / behaviour live in `plugin:project-rule:using-mezzanine-ui` → `components/*.md`. Only the orchestration patterns stay here.

## Mapping Table

| Field Type | Table Column Render | Form Primitive | Binding | Filter Primitive |
|------------|---------------------|-----------------|---------|-------------------|
| `string` | `<Typography>{value}</Typography>` | `<Input>` | manual `register('...')` | `<Input>` (with `prefix={<Icon icon={SearchIcon} />}`) |
| `text` | `<Typography ellipsis>` | `<Textarea>` | manual `register('...')` | — (not filterable) |
| `number` | `<Typography>{value.toLocaleString()}</Typography>` | `<Input type="number">` | manual `register('...', { valueAsNumber: true })` | `<Input type="number">` |
| `date` | `format(value, 'yyyy/MM/dd')` | `<DatePicker>` | `useController` | `<DateRangePicker>` + `useController` |
| `datetime` | `format(value, 'yyyy/MM/dd HH:mm')` | `<DateTimePicker>` | `useController` | `<DateRangePicker>` + `useController` |
| `boolean` | `<Tag label={value ? '是' : '否'} />` | `<RadioGroup>` | `useController` | `<Select options={[全部/是/否]}>` |
| `enum` | `<Tag label={enumLabel} />` | `<Select>` | `useController` | `<Select>` |
| `select` | Related entity display name | `<Select>` (options from related mock) | `useController` | `<Select>` |
| `multiselect` | Comma-joined `<Tag>` list | `<Select mode="multiple">` | `useController` | `<Select mode="multiple">` |
| `image` | `<img>` thumbnail (64×64) or placeholder | `<Upload>` | `useController` | — (not filterable) |
| `file` | File name as `<Typography>` | `<Upload>` | `useController` | — (not filterable) |
| `password` | `<Typography>••••••</Typography>` (masked) | `<Input type="password">` | manual `register('...')` | — (not filterable) |
| `autocomplete` | `<Typography>{value}</Typography>` | `<AutoComplete>` | `useController` | `<AutoComplete>` |

## Imports

```tsx
// Core primitives
import {
  Typography,
  Tag,
  Input,
  Textarea,
  Select,
  RadioGroup,
  AutoComplete,
  Upload,
  DatePicker,
  DateRangePicker,
  DateTimePicker,
  Icon,
} from '@mezzanine-ui/react';
import FormField from '@mezzanine-ui/react/Form/FormField';
import { FormFieldLayout } from '@mezzanine-ui/core/form';
import { SearchIcon } from '@mezzanine-ui/icons';

// react-hook-form + yup
import { useForm, useController, type Control } from 'react-hook-form';
import { yupResolver } from '@hookform/resolvers/yup';
import * as yup from 'yup';
```

## Column Render Examples

### String / Number / Date / Boolean / Enum / Multiselect / Image

```tsx
// string
{ key: 'name', title: '名稱', dataIndex: 'name', width: 200 }

// number (formatted)
{
  key: 'price', title: '單價', width: 120, align: 'end',
  render: (source) => <Typography variant="body">{source.price.toLocaleString()}</Typography>,
}

// date
{
  key: 'createdAt', title: '建立日期', width: 150,
  render: (source) => format(new Date(source.createdAt), 'yyyy/MM/dd'),
}

// boolean (Tag)
{
  key: 'isActive', title: '狀態', width: 100,
  render: (source) => <Tag>{source.isActive ? '啟用' : '停用'}</Tag>,
}

// enum
const statusLabels: Record<string, string> = {
  pending: '待處理', approved: '已核准', rejected: '已拒絕',
};
{
  key: 'status', title: '審核狀態', width: 120,
  render: (source) => <Tag>{statusLabels[source.status] ?? source.status}</Tag>,
}

// multiselect
{
  key: 'tags', title: '標籤', width: 200,
  render: (source) => (
    <div style={{ display: 'flex', gap: 'var(--mzn-spacing-1)', flexWrap: 'wrap' }}>
      {source.tags.map((tag: string) => <Tag key={tag}>{tag}</Tag>)}
    </div>
  ),
}

// image
{
  key: 'image', title: '圖片', width: 80,
  render: (source) =>
    source.imageUrl
      ? <img src={source.imageUrl} alt="" style={{ width: 48, height: 48, objectFit: 'cover', borderRadius: 'var(--mzn-spacing-1)' }} />
      : <Typography color="text-neutral-light">—</Typography>,
}
```

## Form Binding Examples

> Text-like inputs use **manual register** (Mezzanine's `Input` / `Textarea` cannot accept `{...register()}` spread — see `plugin:project-rule:scaffolding-nextjs-page` → `FORM_MODAL_TEMPLATE.md`). Controlled inputs (`Select`, `DatePicker`, `Upload`, `AutoComplete`, `RadioGroup`) use **`useController`**.

### String (manual register)

```tsx
<FormField
  name="name"
  label="商品名稱"
  layout={FormFieldLayout.VERTICAL}
  required
  severity={errors.name ? 'error' : 'info'}
  hintText={errors.name?.message}
>
  <Input
    fullWidth
    placeholder="請輸入商品名稱"
    error={!!errors.name}
    name={register('name').name}
    onChange={(e) => { void register('name').onChange(e); }}
    onBlur={(e) => { void register('name').onBlur(e); }}
    inputRef={register('name').ref}
  />
</FormField>
```

### Enum / Select (useController)

```tsx
const { field: categoryField } = useController({ name: 'category', control });

<FormField
  name="category"
  label="分類"
  layout={FormFieldLayout.VERTICAL}
  required
  severity={errors.category ? 'error' : 'info'}
  hintText={errors.category?.message}
>
  <Select
    fullWidth
    placeholder="請選擇分類"
    value={categoryField.value}
    onChange={categoryField.onChange}
    options={[
      { id: 'raw', name: '原物料' },
      { id: 'semi', name: '半成品' },
      { id: 'finished', name: '成品' },
    ]}
  />
</FormField>
```

> For any other primitive (`DatePicker`, `Upload`, `AutoComplete`, `RadioGroup`, `Textarea`…), read the corresponding `plugin:project-rule:using-mezzanine-ui` → `components/<Name>.md` file for exact props, then follow the same binding recipe above.

## Yup Schema Example

```tsx
const productFormSchema = yup.object({
  name: yup.string().required('請輸入商品名稱').max(100, '商品名稱不得超過 100 字'),
  sku: yup.string().required('請輸入 SKU').matches(/^[A-Z0-9]{4,12}$/, 'SKU 須為 4-12 位大寫英數字'),
  category: yup.string().required('請選擇分類').oneOf(['raw', 'semi', 'finished']),
  price: yup.number().required('請輸入單價').min(1).max(999999),
  isActive: yup.boolean().required(),
});

type ProductFormData = yup.InferType<typeof productFormSchema>;

const {
  register,
  control,
  handleSubmit,
  reset,
  formState: { errors },
} = useForm<ProductFormData>({
  resolver: yupResolver(productFormSchema),
  defaultValues: { name: '', sku: '', category: 'raw', price: 1, isActive: true },
});
```

## Filter Row Pattern

Filter rows live **outside** any `<Table>` — render them in a flex container above the table. Use the same `FormField` + primitives pattern; the filter state is typically its own `useForm<FilterValues>()` and a "搜尋" button triggers `handleSubmit`.

```tsx
<form
  onSubmit={filterMethods.handleSubmit(onFilter)}
  style={{ display: 'flex', gap: 'var(--mzn-spacing-4)', alignItems: 'flex-end', flexWrap: 'wrap', padding: 'var(--mzn-spacing-4)' }}
>
  <FormField name="keyword" label="關鍵字" layout={FormFieldLayout.VERTICAL}>
    <Input
      fullWidth
      placeholder="搜尋名稱或 SKU"
      prefix={<Icon icon={SearchIcon} />}
      name={filterMethods.register('keyword').name}
      onChange={(e) => { void filterMethods.register('keyword').onChange(e); }}
      onBlur={(e) => { void filterMethods.register('keyword').onBlur(e); }}
      inputRef={filterMethods.register('keyword').ref}
    />
  </FormField>

  {/* Additional filters: SingleSelect via useController, DateRangePicker via useController, ... */}

  <Button type="submit" variant="base-primary">搜尋</Button>
</form>
```

## Validation Mapping (when `FieldSpec.validation` is present)

| Field Type | `validation.min/max` → | Where to enforce |
|-----------|------------------------|-------------------|
| `string`  | character length | `yup.string().min().max()` |
| `text`    | character length | `yup.string().min().max()` |
| `number`  | numeric value | `yup.number().min().max()` |
| `date`    | — | — |
| any       | `validation.pattern` | `yup.string().matches(regex, message)` |
| any       | `validation.message` | second arg to the yup rule |
