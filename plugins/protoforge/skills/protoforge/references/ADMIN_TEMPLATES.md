# Admin Components API Reference

Generated prototypes use `mezzanine-ui-admin-components` and `@mezzanine-ui/react-hook-form-v2` as the primary building blocks.

## Package Sources

```
mezzanine-ui-admin-components  → AuthorizedAdminPageWrapper, PageWrapper, AdminTable, Sidebar, Header, DropdownActions, Information, UploadImagesWall, Divider, Hints
@mezzanine-ui/react-hook-form-v2 → FormFieldsWrapper, InputField, TextAreaField, SelectField, SingleSelectField, MultiSelectField, DatePickerField, DateRangePickerField, DateTimePickerField, RadioGroupField, CheckboxField, CheckboxGroupField, SearchInputField, UploadImageField, UploadFileField, AutoCompleteField, SliderField, PasswordField, StaticField
@mezzanine-ui/react            → Typography, Button, Icon, Tag, Modal, Tabs, TabPane, Tab, Navigation, NavigationOption, NavigationOptionCategory, cx
@mezzanine-ui/icons            → All icon definitions (PlusIcon, SearchIcon, FolderIcon, etc.)
@mezzanine-ui/core/table       → TableColumn, TableDataSourceWithID, TablePagination
```

---

## AuthorizedAdminPageWrapper

Root layout shell with Header + Sidebar + Dialog/Modal/Layout providers.

```tsx
import { AuthorizedAdminPageWrapper } from 'mezzanine-ui-admin-components';

<AuthorizedAdminPageWrapper
  // Header props
  logo={<img src="/logo.svg" alt="Logo" />}
  name="使用者名稱"
  role="管理員"
  account="user@example.com"
  onLogout={() => {/* mock logout */}}
  // Sidebar props
  navigationChildren={navigationChildren}
  onPush={(path) => router.push(path)}
  // Optional
  headerHeight={64}
  sidebarWidth={270}
>
  {children}
</AuthorizedAdminPageWrapper>
```

### Props

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `logo` | `ReactNode` | — | Header logo element |
| `name` | `string` | — | Display name in header |
| `role` | `string` | — | Role label in header |
| `account` | `string` | — | Account identifier |
| `onLogout` | `VoidFunction` | — | Logout handler |
| `navigationChildren` | `NavigationChildren` | — | Sidebar navigation items |
| `onPush` | `(path: string) => void` | — | Navigation route handler |
| `headerHeight` | `number` | `64` | Header height in px |
| `sidebarWidth` | `number` | `270` | Sidebar width in px |
| `children` | `ReactNode` | — | Page content |

---

## PageWrapper

Page-level wrapper with title and optional create button.

```tsx
import { PageWrapper } from 'mezzanine-ui-admin-components';

<PageWrapper
  title="商品管理"
  onCreate={() => setModalOpen(true)}
  createText="新增商品"
>
  {/* AdminTable or form content */}
</PageWrapper>
```

### Props

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `title` | `string` | — | Page heading (Typography h1) |
| `onCreate` | `VoidFunction` | — | Create button handler (hidden if undefined) |
| `createText` | `string` | — | Create button label |
| `createButtonDisabled` | `boolean` | `false` | Disable create button |
| `isFormPage` | `boolean` | `false` | Extra bottom padding for form pages |
| `customizeActionComponent` | `ReactNode` | — | Custom action area (next to create button) |

---

## AdminTable

Table with built-in tabs, filters slot, row actions dropdown, and pagination.

```tsx
import { AdminTable } from 'mezzanine-ui-admin-components';
import { TableColumn, TableDataSourceWithID } from '@mezzanine-ui/core/table';

interface Product extends TableDataSourceWithID {
  id: string;
  name: string;
  sku: string;
  price: number;
}

const columns: TableColumn<Product>[] = [
  { title: '商品名稱', dataIndex: 'name', width: 200 },
  { title: 'SKU', dataIndex: 'sku', width: 150 },
  { title: '單價', width: 120, render: (source) => `$${source.price.toLocaleString()}` },
];

<AdminTable<Product>
  dataSource={products}
  columns={columns}
  loading={loading}
  pagination={{
    total: products.length,
    current: page,
    onChange: (p) => setPage(p),
    options: { pageSize: 10 },
  }}
  actions={(source) => [
    { text: '編輯', onClick: () => handleEdit(source) },
    { text: '刪除', danger: true, onClick: () => handleDelete(source) },
  ]}
  filtersComponent={<FilterForm />}
  tabs={[
    { id: 'all', name: '全部' },
    { id: 'active', name: '啟用中' },
  ]}
  activeTabId={activeTab}
  onTabChange={setActiveTab}
/>
```

### Props

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `dataSource` | `T[]` | — | Data array (must extend `TableDataSourceWithID`) |
| `columns` | `TableColumn<T>[]` | — | Column definitions |
| `loading` | `boolean` | — | Show loading state |
| `pagination` | `TablePagination` | — | Pagination config |
| `scroll` | `TableScrolling` | — | Horizontal/vertical scroll |
| `draggable` | `TableDraggable` | — | Row drag-and-drop config |
| `actions` | `(source: T) => DropdownItemsType` | — | Per-row action menu items |
| `actionsDisabled` | `(source: T) => boolean` | — | Disable action menu per row |
| `filtersComponent` | `ReactNode` | — | Filter UI above table |
| `tabs` | `{ id: Key; name: string }[]` | — | Tab definitions above filters |
| `activeTabId` | `Key` | — | Currently active tab |
| `onTabChange` | `(tabId: Key) => void` | — | Tab change handler |

### DropdownItemsType

```typescript
type DropdownItemType = {
  text: string;        // Menu item label
  danger?: boolean;    // Red text styling
  hidden?: boolean;    // Conditionally hide item
  onClick?: (e) => void;
  // ... other MenuItemProps
};
type DropdownItemsType = DropdownItemType[];
```

### TableColumn<T>

```typescript
interface TableColumn<T> {
  title: string;          // Column header text
  dataIndex?: keyof T;    // Auto-render field (if no render function)
  width?: number;         // Column width in px
  align?: 'start' | 'center' | 'end';
  fixed?: 'start' | 'end';
  render?: (source: T, index: number) => ReactNode;  // Custom cell render
  sorter?: (a: T, b: T) => number;
}
```

### TableDataSourceWithID

Every row must have a unique `id` field:

```typescript
interface TableDataSourceWithID {
  id: string | number;
  [key: string]: unknown;
}
```

---

## FormFieldsWrapper

Form container wrapping react-hook-form's `FormProvider` with optional stepper and footer.

```tsx
import { FormFieldsWrapper } from '@mezzanine-ui/react-hook-form-v2';
import { useForm } from 'react-hook-form';

const methods = useForm<ProductFormValues>({
  defaultValues: { name: '', sku: '', price: 0 },
});

<FormFieldsWrapper
  methods={methods}
  onSubmit={handleSubmit}
  haveFooter
  submitButtonText="儲存"
  cancelButtonText="取消"
  onCancel={async () => handleClose()}
>
  <InputField registerName="name" label="商品名稱" required />
  <InputField registerName="sku" label="SKU" required />
  <InputField registerName="price" label="單價" type="number" required />
</FormFieldsWrapper>
```

### Props

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `methods` | `UseFormReturn<T>` | — | react-hook-form methods |
| `onSubmit` | `SubmitHandler<T>` | — | Form submit handler |
| `children` | `ReactNode` | — | Form field components |
| `haveFooter` | `boolean` | — | Show cancel/submit buttons |
| `submitButtonText` | `string` | `'確認'` | Submit button label |
| `cancelButtonText` | `string` | `'取消'` | Cancel button label |
| `onCancel` | `(values: T) => Promise<void>` | — | Cancel handler |
| `steps` | `{ id: string; name: string }[]` | — | Stepper steps |
| `activeStep` | `number` | — | Current step index |
| `setActiveStep` | `(step: number) => void` | — | Step change handler |

---

## Form Field Components (react-hook-form-v2)

All fields share a common pattern:

```tsx
<{FieldComponent}
  registerName="fieldName"       // react-hook-form field path
  label="欄位標題"                // Field label
  required                       // Show required indicator
  disabled={false}               // Disable input
  placeholder="請輸入..."        // Placeholder text
/>
```

### Available Fields

| Component | Import | Use For |
|-----------|--------|---------|
| `InputField` | `@mezzanine-ui/react-hook-form-v2` | Single-line text, numbers |
| `TextAreaField` | `@mezzanine-ui/react-hook-form-v2` | Multi-line text |
| `SelectField` | `@mezzanine-ui/react-hook-form-v2` | Dropdown select (multiple) |
| `SingleSelectField` | `@mezzanine-ui/react-hook-form-v2` | Dropdown select (single) |
| `MultiSelectField` | `@mezzanine-ui/react-hook-form-v2` | Multi-select with tags |
| `DatePickerField` | `@mezzanine-ui/react-hook-form-v2` | Date picker |
| `DateRangePickerField` | `@mezzanine-ui/react-hook-form-v2` | Date range picker |
| `DateTimePickerField` | `@mezzanine-ui/react-hook-form-v2` | Date + time picker |
| `RadioGroupField` | `@mezzanine-ui/react-hook-form-v2` | Radio button group |
| `CheckboxField` | `@mezzanine-ui/react-hook-form-v2` | Single checkbox |
| `CheckboxGroupField` | `@mezzanine-ui/react-hook-form-v2` | Checkbox group |
| `SearchInputField` | `@mezzanine-ui/react-hook-form-v2` | Input with search icon |
| `PasswordField` | `@mezzanine-ui/react-hook-form-v2` | Password input |
| `UploadImageField` | `@mezzanine-ui/react-hook-form-v2` | Image upload |
| `UploadFileField` | `@mezzanine-ui/react-hook-form-v2` | File upload |
| `AutoCompleteField` | `@mezzanine-ui/react-hook-form-v2` | Autocomplete input |
| `SliderField` | `@mezzanine-ui/react-hook-form-v2` | Slider input |
| `StaticField` | `@mezzanine-ui/react-hook-form-v2` | Read-only display field |

### Select Options Format

Select fields use `{ id: string; name: string }` shape:

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

---

## Information

Inline information message with severity-based icon and color.

```tsx
import { Information } from 'mezzanine-ui-admin-components';

<Information mode="warning" text="此操作不可復原" />
```

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `mode` | `'info' \| 'success' \| 'warning' \| 'error'` | `'info'` | Severity |
| `text` | `string` | — | Message text |
| `alignStart` | `boolean` | `false` | Align icon to top for multiline |

---

## Navigation Structure

Sidebar navigation uses mezzanine-ui's `Navigation` components:

```tsx
import { NavigationOption, NavigationOptionCategory } from '@mezzanine-ui/react';
import { FolderIcon, BoxIcon, FolderMoveIcon, HomeIcon } from '@mezzanine-ui/icons';

const navigationChildren = (
  <>
    <NavigationOptionCategory title="主資料" icon={FolderIcon}>
      <NavigationOption id="/products" title="商品管理" icon={BoxIcon} />
      <NavigationOption id="/warehouses" title="倉庫管理" icon={FolderMoveIcon} />
    </NavigationOptionCategory>
    <NavigationOption id="/dashboard" title="儀表板" icon={HomeIcon} />
  </>
);
```

The `id` prop doubles as the route path — `onPush(id)` is called when clicked.
