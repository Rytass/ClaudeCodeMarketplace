# Page Patterns

Four page types are supported. Each pattern defines the complete file structure and component composition built from `@mezzanine-ui/react` primitives.

> For any component's props / behaviour, consult `plugin:mezzanine-ui:using-mezzanine-ui-react` → `components/*.md`. The form modal binding convention is defined in `plugin:project-rule:scaffolding-nextjs-page` → `FORM_MODAL_TEMPLATE.md`.

---

## 1. List Page (most common)

**Use for**: Entity management with table, optional tabs / filters, pagination, and CRUD modal.

### File Structure

```
app/(admin)/{route}/
├── page.tsx                          # Main page component
└── _components/
    ├── {Entity}FormModal.tsx         # Create/Edit modal
    └── index.ts                      # Re-exports
```

### page.tsx Template

```tsx
'use client';

import { useCallback, useMemo, useState, type Key } from 'react';
import {
  Button,
  PageHeader,
  Table,
  Tab,
  TabItem,
  Tag,
  Typography,
} from '@mezzanine-ui/react';
import type { TableColumn } from '@mezzanine-ui/react';
import ContentHeader from '@mezzanine-ui/react/ContentHeader';
import { useMock{Entity} } from '@/hooks/useMock{Entity}';
import { {Entity}FormModal } from './_components/{Entity}FormModal';
import type { Mock{Entity} } from '@/types';

export default function {Entity}ListPage(): JSX.Element {
  const { items, create, update, remove } = useMock{Entity}();

  const [page, setPage] = useState<number>(1);
  const pageSize = 10;

  const [modalOpen, setModalOpen] = useState<boolean>(false);
  const [editingItem, setEditingItem] = useState<Mock{Entity} | null>(null);

  // Optional: tabs state when the entity has a status tab strip
  const [activeTab, setActiveTab] = useState<Key>('all');

  const handleCreate = useCallback((): void => {
    setEditingItem(null);
    setModalOpen(true);
  }, []);

  const handleEdit = useCallback((item: Mock{Entity}): void => {
    setEditingItem(item);
    setModalOpen(true);
  }, []);

  const handleDelete = useCallback((item: Mock{Entity}): void => {
    remove(item.id);
  }, [remove]);

  const handleSubmit = useCallback((values: Omit<Mock{Entity}, 'id'>): void => {
    if (editingItem) {
      update(editingItem.id, values);
    } else {
      create(values);
    }
    setModalOpen(false);
  }, [editingItem, create, update]);

  // Columns (see COMPONENT_MAPPING.md for render patterns)
  const columns = useMemo((): TableColumn<Mock{Entity}>[] => [
    // ... columns derived from EntitySpec.fields where isTableColumn === true
  ], []);

  const filteredItems = useMemo(
    () => items, // Apply tab / filter logic here when applicable
    [items],
  );

  const paginatedData = useMemo(
    () => filteredItems.slice((page - 1) * pageSize, page * pageSize),
    [filteredItems, page],
  );

  return (
    <div style={{ padding: 'var(--mzn-spacing-6)' }}>
      <PageHeader>
        <ContentHeader title="{pageTitle}">
          <Button onClick={handleCreate}>新增{entityLabel}</Button>
        </ContentHeader>
      </PageHeader>

      {/* Optional tabs (render only when the entity has a status strip) */}
      <Tab activeKey={activeTab} onChange={setActiveTab}>
        <TabItem key="all">全部</TabItem>
        <TabItem key="active">啟用中</TabItem>
      </Tab>

      {/* Filter row lives above the table — see COMPONENT_MAPPING.md → Filter Row Pattern */}

      <Table<Mock{Entity}>
        fullWidth
        dataSource={paginatedData}
        columns={columns}
        getRowKey={(row) => row.id}
        actions={{
          items: (source) => [
            { key: 'edit', text: '編輯', onClick: () => handleEdit(source) },
            { key: 'delete', text: '刪除', danger: true, onClick: () => handleDelete(source) },
          ],
        }}
        pagination={{
          total: filteredItems.length,
          current: page,
          onChange: setPage,
          pageSize,
        }}
      />

      <{Entity}FormModal
        open={modalOpen}
        loading={false}
        {entity}={editingItem}
        onClose={() => setModalOpen(false)}
        onSubmit={handleSubmit}
      />
    </div>
  );
}
```

### FormModal Template

Use the canonical manual-register pattern from `plugin:project-rule:scaffolding-nextjs-page/FORM_MODAL_TEMPLATE.md`. Skeleton:

```tsx
'use client';

import { useCallback, useEffect, type ReactNode } from 'react';
import { useForm, useController } from 'react-hook-form';
import { yupResolver } from '@hookform/resolvers/yup';
import * as yup from 'yup';
import { Input, Modal, ModalFooter, ModalHeader, Select } from '@mezzanine-ui/react';
import FormField from '@mezzanine-ui/react/Form/FormField';
import { FormFieldLayout } from '@mezzanine-ui/core/form';
import type { Mock{Entity} } from '@/types';

const {entity}FormSchema = yup.object({
  name: yup.string().required('請輸入名稱').max(100),
  category: yup.string().required('請選擇分類'),
});

type {Entity}FormData = yup.InferType<typeof {entity}FormSchema>;

interface {Entity}FormModalProps {
  readonly open: boolean;
  readonly {entity}: Mock{Entity} | null;
  readonly loading: boolean;
  readonly onClose: () => void;
  readonly onSubmit: (data: {Entity}FormData) => void | Promise<void>;
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
    control,
    handleSubmit,
    reset,
    formState: { errors },
  } = useForm<{Entity}FormData>({
    resolver: yupResolver({entity}FormSchema),
    defaultValues: { name: '', category: '' },
  });

  useEffect(() => {
    if (open && {entity}) {
      reset({ name: {entity}.name, category: {entity}.category });
    } else if (open) {
      reset({ name: '', category: '' });
    }
  }, [open, {entity}, reset]);

  const { field: categoryField } = useController({ name: 'category', control });

  const handleFormSubmit = useCallback(
    async (data: {Entity}FormData): Promise<void> => {
      await onSubmit(data);
    },
    [onSubmit],
  );

  return (
    <Modal modalType="standard" open={open} onClose={onClose}>
      <ModalHeader title={isEditMode ? '編輯{entityLabel}' : '新增{entityLabel}'} />
      <form onSubmit={(e) => { void handleSubmit(handleFormSubmit)(e); }}>
        <div style={{ minWidth: 400, padding: 'var(--mzn-spacing-5)', display: 'flex', flexDirection: 'column', gap: 'var(--mzn-spacing-4)' }}>
          <FormField
            name="name"
            label="名稱"
            layout={FormFieldLayout.VERTICAL}
            required
            severity={errors.name ? 'error' : 'info'}
            hintText={errors.name?.message}
          >
            <Input
              fullWidth
              placeholder="請輸入名稱"
              error={!!errors.name}
              name={register('name').name}
              onChange={(e) => { void register('name').onChange(e); }}
              onBlur={(e) => { void register('name').onBlur(e); }}
              inputRef={register('name').ref}
            />
          </FormField>

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

          {/* Additional fields — see COMPONENT_MAPPING.md for per-type recipes */}
        </div>
        <ModalFooter
          cancelText="取消"
          confirmText={isEditMode ? '儲存' : '新增'}
          onCancel={onClose}
          cancelButtonProps={{ disabled: loading }}
          confirmButtonProps={{ type: 'submit', loading }}
        />
      </form>
    </Modal>
  );
}
```

> Element props detail (`Input`, `Select`, `Modal`, `FormField`, `Textarea`, `DatePicker`, `Upload` …) — see `plugin:mezzanine-ui:using-mezzanine-ui-react` → `components/<Name>.md`.

### Orderable List Variant

When `PageSpec.orderable` is `true`, enable `<Table>`'s native `draggable`:

```tsx
<Table<Mock{Entity}>
  fullWidth
  dataSource={orderedItems}
  columns={columns}
  getRowKey={(row) => row.id}
  draggable={{
    onDragEnd: ({ sourceIndex, destinationIndex }) => {
      setOrderedItems((prev) => {
        const item = prev[sourceIndex];
        const without = [...prev.slice(0, sourceIndex), ...prev.slice(sourceIndex + 1)];
        return [...without.slice(0, destinationIndex), item, ...without.slice(destinationIndex)];
      });
    },
  }}
/>
```

---

## 2. Detail Page

**Use for**: Single entity detail view with optional tabs.

### File Structure

```
app/(admin)/{route}/[id]/
└── page.tsx
```

### Template

```tsx
'use client';

import { useMemo, useState, type Key } from 'react';
import { useParams, useRouter } from 'next/navigation';
import {
  PageHeader,
  Tab,
  TabItem,
  Table,
  Typography,
} from '@mezzanine-ui/react';
import ContentHeader from '@mezzanine-ui/react/ContentHeader';
import { useMock{Entity} } from '@/hooks/useMock{Entity}';
// Import related entity hooks only when a tab uses relatedEntity:
import { useMock{RelatedEntity} } from '@/hooks/useMock{RelatedEntity}';

export default function {Entity}DetailPage(): JSX.Element {
  const params = useParams();
  const router = useRouter();
  const { items } = useMock{Entity}();
  const item = useMemo(
    () => items.find((i) => i.id === params.id),
    [items, params.id],
  );

  // Only for tabs with relatedEntity:
  const { items: relatedItems } = useMock{RelatedEntity}();
  const filteredRelated = useMemo(
    () => relatedItems.filter((r) => r.{entityRef}Id === params.id),
    [relatedItems, params.id],
  );

  const [activeTab, setActiveTab] = useState<Key>('tab-0');

  if (!item) {
    return (
      <div style={{ padding: 'var(--mzn-spacing-6)' }}>
        <PageHeader>
          <ContentHeader title="找不到資料" onBackClick={() => router.back()} />
        </PageHeader>
      </div>
    );
  }

  return (
    <div style={{ padding: 'var(--mzn-spacing-6)' }}>
      <PageHeader>
        <ContentHeader
          title={`${item.name} 詳情`}
          onBackClick={() => router.back()}
        />
      </PageHeader>

      <Tab activeKey={activeTab} onChange={setActiveTab}>
        <TabItem key="tab-0">{tabSpec[0].label}</TabItem>
        <TabItem key="tab-1">{tabSpec[1].label}</TabItem>
      </Tab>

      {activeTab === 'tab-0' && (
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 'var(--mzn-spacing-4)', padding: 'var(--mzn-spacing-4)' }}>
          {/* Render one <div> per field in tabSpec.fields */}
          <div>
            <Typography variant="caption" color="text-neutral-light">{fieldLabel}</Typography>
            <Typography variant="body">{String(item[fieldName])}</Typography>
          </div>
        </div>
      )}

      {activeTab === 'tab-1' && (
        <Table
          fullWidth
          dataSource={filteredRelated}
          columns={relatedColumns}
          getRowKey={(row) => row.id}
        />
      )}
    </div>
  );
}
```

**Fallback when `PageSpec.tabs` is absent**: render a single "基本資訊" tab containing every entity field as a label/value pair.

---

## 3. Form Page

**Use for**: Standalone create/edit form (when forms are too complex for a modal).

### File Structure

```
app/(admin)/{route}/create/
└── page.tsx
```

### Template

```tsx
'use client';

import { useCallback, type ReactNode } from 'react';
import { useRouter } from 'next/navigation';
import { useForm } from 'react-hook-form';
import { yupResolver } from '@hookform/resolvers/yup';
import * as yup from 'yup';
import { Button, Input, PageHeader } from '@mezzanine-ui/react';
import FormField from '@mezzanine-ui/react/Form/FormField';
import { FormFieldLayout } from '@mezzanine-ui/core/form';
import ContentHeader from '@mezzanine-ui/react/ContentHeader';
import { useMock{Entity} } from '@/hooks/useMock{Entity}';

const {entity}FormSchema = yup.object({
  name: yup.string().required('請輸入名稱'),
});

type {Entity}FormData = yup.InferType<typeof {entity}FormSchema>;

export default function Create{Entity}Page(): ReactNode {
  const router = useRouter();
  const { create } = useMock{Entity}();

  const {
    register,
    handleSubmit,
    formState: { errors, isSubmitting },
  } = useForm<{Entity}FormData>({
    resolver: yupResolver({entity}FormSchema),
    defaultValues: { name: '' },
  });

  const handleFormSubmit = useCallback((data: {Entity}FormData): void => {
    create(data);
    router.push('/{route}');
  }, [create, router]);

  return (
    <div style={{ padding: 'var(--mzn-spacing-6)' }}>
      <PageHeader>
        <ContentHeader title="新增{entityLabel}" onBackClick={() => router.back()} />
      </PageHeader>

      <form
        onSubmit={(e) => { void handleSubmit(handleFormSubmit)(e); }}
        style={{ display: 'flex', flexDirection: 'column', gap: 'var(--mzn-spacing-4)', maxWidth: 720, marginTop: 'var(--mzn-spacing-6)' }}
      >
        <FormField
          name="name"
          label="名稱"
          layout={FormFieldLayout.VERTICAL}
          required
          severity={errors.name ? 'error' : 'info'}
          hintText={errors.name?.message}
        >
          <Input
            fullWidth
            placeholder="請輸入名稱"
            error={!!errors.name}
            name={register('name').name}
            onChange={(e) => { void register('name').onChange(e); }}
            onBlur={(e) => { void register('name').onBlur(e); }}
            inputRef={register('name').ref}
          />
        </FormField>

        {/* Additional fields — see COMPONENT_MAPPING.md */}

        <div style={{ display: 'flex', gap: 'var(--mzn-spacing-3)', justifyContent: 'flex-end', marginTop: 'var(--mzn-spacing-4)' }}>
          <Button
            type="button"
            variant="base-secondary"
            onClick={() => router.back()}
            disabled={isSubmitting}
          >
            取消
          </Button>
          <Button type="submit" loading={isSubmitting}>儲存</Button>
        </div>
      </form>
    </div>
  );
}
```

---

## 4. Dashboard Page

**Use for**: Overview page with stat cards and summary tables.

### Template

```tsx
'use client';

import { useMemo, type ReactNode } from 'react';
import {
  Icon,
  PageHeader,
  Table,
  Tag,
  Typography,
} from '@mezzanine-ui/react';
import type { TableColumn } from '@mezzanine-ui/react';
import ContentHeader from '@mezzanine-ui/react/ContentHeader';
import { BoxIcon, CheckCircleIcon, FolderMoveIcon } from '@mezzanine-ui/icons';
import { useMockProduct } from '@/hooks/useMockProduct';
import { useMockWarehouse } from '@/hooks/useMockWarehouse';

function StatCard({ title, value, icon }: { readonly title: string; readonly value: string | number; readonly icon: ReactNode }): ReactNode {
  return (
    <div style={{
      padding: 'var(--mzn-spacing-6)',
      borderRadius: 'var(--mzn-spacing-2)',
      border: '1px solid var(--mzn-color-border)',
      display: 'flex',
      alignItems: 'center',
      gap: 'var(--mzn-spacing-4)',
    }}>
      {icon}
      <div>
        <Typography variant="caption" color="text-neutral-light">{title}</Typography>
        <Typography variant="h3">{value}</Typography>
      </div>
    </div>
  );
}

export default function DashboardPage(): ReactNode {
  const { items: products } = useMockProduct();
  const { items: warehouses } = useMockWarehouse();

  const stats = useMemo(() => ({
    productCount: products.length,
    warehouseCount: warehouses.length,
    activeProducts: products.filter((p) => p.isActive).length,
  }), [products, warehouses]);

  const recentProducts = useMemo(
    () => [...products].sort((a, b) =>
      new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime(),
    ).slice(0, 5),
    [products],
  );

  const recentProductColumns = useMemo((): TableColumn<typeof products[number]>[] => [
    { key: 'name', title: '商品名稱', dataIndex: 'name', width: 200 },
    { key: 'category', title: '分類', dataIndex: 'category', width: 100 },
  ], []);

  return (
    <div style={{ padding: 'var(--mzn-spacing-6)' }}>
      <PageHeader>
        <ContentHeader title="總覽" description="營運資訊快覽" />
      </PageHeader>

      <div style={{
        display: 'grid',
        gridTemplateColumns: 'repeat(auto-fit, minmax(240px, 1fr))',
        gap: 'var(--mzn-spacing-4)',
        marginTop: 'var(--mzn-spacing-4)',
        marginBottom: 'var(--mzn-spacing-6)',
      }}>
        <StatCard title="商品總數" value={stats.productCount} icon={<Icon icon={BoxIcon} size={24} />} />
        <StatCard title="倉庫數量" value={stats.warehouseCount} icon={<Icon icon={FolderMoveIcon} size={24} />} />
        <StatCard title="啟用商品" value={stats.activeProducts} icon={<Icon icon={CheckCircleIcon} size={24} />} />
      </div>

      <Typography variant="h5" style={{ marginBottom: 'var(--mzn-spacing-3)' }}>狀態分佈</Typography>
      <div style={{ display: 'flex', gap: 'var(--mzn-spacing-3)', flexWrap: 'wrap', marginBottom: 'var(--mzn-spacing-6)' }}>
        <Tag>{`啟用中: ${stats.activeProducts}`}</Tag>
        <Tag>{`停用: ${stats.productCount - stats.activeProducts}`}</Tag>
      </div>

      <Typography variant="h5" style={{ marginBottom: 'var(--mzn-spacing-3)' }}>最近異動</Typography>
      <Table
        fullWidth
        dataSource={recentProducts}
        columns={recentProductColumns}
        getRowKey={(row) => row.id}
      />

      <div style={{
        marginTop: 'var(--mzn-spacing-6)',
        padding: 'var(--mzn-spacing-8)',
        border: '2px dashed var(--mzn-color-border)',
        borderRadius: 'var(--mzn-spacing-2)',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        minHeight: 200,
      }}>
        <Typography color="text-neutral-light">圖表區域（待整合）</Typography>
      </div>
    </div>
  );
}
```

---

## 5. Export (CSV Download) Pattern

**Use for**: Any list page whose `actions` array contains `'export'`.

### Utility Function

Create `src/utils/downloadCSV.ts` once per project:

```tsx
'use client';

interface CSVColumn<T> {
  readonly title: string;
  readonly dataIndex?: keyof T;
  readonly render?: (source: T) => string;
}

export function downloadCSV<T extends Record<string, unknown>>(
  data: readonly T[],
  columns: readonly CSVColumn<T>[],
  filename: string,
): void {
  const header = columns.map((col) => col.title).join(',');
  const rows = data.map((item) =>
    columns
      .map((col) => {
        const value = col.render
          ? col.render(item)
          : String(col.dataIndex ? item[col.dataIndex] ?? '' : '');
        return value.includes(',') || value.includes('"')
          ? `"${value.replace(/"/g, '""')}"`
          : value;
      })
      .join(','),
  );

  const csvContent = [header, ...rows].join('\n');
  const BOM = '\uFEFF';
  const blob = new Blob([BOM + csvContent], { type: 'text/csv;charset=utf-8;' });
  const url = URL.createObjectURL(blob);

  const link = document.createElement('a');
  link.href = url;
  link.download = `${filename}.csv`;
  document.body.appendChild(link);
  link.click();
  document.body.removeChild(link);
  URL.revokeObjectURL(url);
}
```

### Integration with PageHeader

Put the export button inside `<ContentHeader>` alongside the primary create button:

```tsx
import { Button, Icon, PageHeader } from '@mezzanine-ui/react';
import ContentHeader from '@mezzanine-ui/react/ContentHeader';
import { DownloadIcon } from '@mezzanine-ui/icons';
import { downloadCSV } from '@/utils/downloadCSV';

<PageHeader>
  <ContentHeader title="商品管理">
    <Button
      variant="base-secondary"
      prefix={<Icon icon={DownloadIcon} />}
      onClick={() => downloadCSV(items, exportColumns, 'products')}
    >
      匯出 CSV
    </Button>
    <Button onClick={handleCreate}>新增商品</Button>
  </ContentHeader>
</PageHeader>
```

---

## Common Patterns

### `'use client'` Directive

Every page and component file **must** start with `'use client'` since every prototype uses `useState`, `useForm`, and other client hooks.

### Mezzanine-UI Spacing

Use CSS variables for spacing, never hardcoded pixels:

- `var(--mzn-spacing-1)` … `var(--mzn-spacing-8)`

### Date Formatting

```tsx
import { format } from 'date-fns';
format(new Date(value), 'yyyy/MM/dd');
```

### Component Prop Details

All primitive APIs live in `plugin:mezzanine-ui:using-mezzanine-ui-react` (`components/*.md`). When in doubt, open that skill rather than guessing prop names.
