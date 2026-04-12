# Page Patterns

Four page types are supported. Each pattern defines the complete file structure and component composition.

---

## 1. List Page (most common)

**Use for**: Entity management with table, filters, pagination, and CRUD modal.

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

import { useState, useMemo, useCallback } from 'react';
// Also import `Key` from 'react' if using AdminTable with tabs
import { PageWrapper } from 'mezzanine-ui-admin-components';
import { AdminTable } from 'mezzanine-ui-admin-components';
import { TableColumn } from '@mezzanine-ui/core/table';
import { Typography, Tag } from '@mezzanine-ui/react';
import { useMock{Entity} } from '@/hooks/useMock{Entity}';
import { {Entity}FormModal } from './_components/{Entity}FormModal';
import type { Mock{Entity} } from '@/types';

export default function {Entity}ListPage(): JSX.Element {
  // Mock data
  const { items, create, update, remove } = useMock{Entity}();

  // Pagination state
  const [page, setPage] = useState<number>(1);
  const pageSize = 10;

  // Modal state
  const [modalOpen, setModalOpen] = useState<boolean>(false);
  const [editingItem, setEditingItem] = useState<Mock{Entity} | null>(null);

  // Handlers
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

  // Paginated data
  const paginatedData = useMemo(
    () => items.slice((page - 1) * pageSize, page * pageSize),
    [items, page],
  );

  return (
    <PageWrapper
      title="{pageTitle}"
      onCreate={handleCreate}
      createText="新增{entityLabel}"
    >
      <AdminTable<Mock{Entity}>
        dataSource={paginatedData}
        columns={columns}
        pagination={{
          total: items.length,
          current: page,
          onChange: setPage,
          options: { pageSize },
        }}
        actions={(source) => [
          { text: '編輯', onClick: () => handleEdit(source) },
          { text: '刪除', danger: true, onClick: () => handleDelete(source) },
        ]}
      />

      <{Entity}FormModal
        open={modalOpen}
        onClose={() => setModalOpen(false)}
        onSubmit={handleSubmit}
        defaultValues={editingItem}
        mode={editingItem ? 'edit' : 'create'}
      />
    </PageWrapper>
  );
}
```

### FormModal Template

```tsx
'use client';

import { FC, useEffect } from 'react';
import { useForm } from 'react-hook-form';
import { Modal, ModalHeader, ModalFooter } from '@mezzanine-ui/react';
import { FormFieldsWrapper, InputField, SingleSelectField } from '@mezzanine-ui/react-hook-form-v2';
import type { Mock{Entity} } from '@/types';

interface {Entity}FormModalProps {
  open: boolean;
  onClose: () => void;
  onSubmit: (values: Omit<Mock{Entity}, 'id'>) => void;
  defaultValues: Mock{Entity} | null;
  mode: 'create' | 'edit';
}

export const {Entity}FormModal: FC<{Entity}FormModalProps> = ({
  open,
  onClose,
  onSubmit,
  defaultValues,
  mode,
}) => {
  const methods = useForm<Omit<Mock{Entity}, 'id'>>({
    defaultValues: defaultValues ?? {/* initial defaults */},
  });

  useEffect(() => {
    if (defaultValues) {
      methods.reset(defaultValues);
    } else {
      methods.reset({/* initial defaults */});
    }
  }, [defaultValues, methods]);

  return (
    <Modal open={open} onClose={onClose}>
      <ModalHeader title={mode === 'create' ? '新增{entityLabel}' : '編輯{entityLabel}'} />
      <FormFieldsWrapper methods={methods}>
        {/* Fields derived from EntitySpec.fields */}
        {/* See COMPONENT_MAPPING.md for field type → component mapping */}
      </FormFieldsWrapper>
      <ModalFooter
        cancelText="取消"
        confirmText="確認"
        onCancel={onClose}
        onConfirm={methods.handleSubmit(onSubmit)}
      />
    </Modal>
  );
};
```

### Orderable List Page Variant

When `PageSpec.orderable` is `true`, add drag-and-drop reordering via `AdminTable`'s `draggable` prop:

```tsx
// Additional state for orderable list
const [orderedItems, setOrderedItems] = useState<readonly Mock{Entity}[]>(items);

// Sync with source data when items change
useEffect(() => {
  setOrderedItems(items);
}, [items]);

// Drag handler
const handleDragEnd = useCallback((result: { sourceIndex: number; destinationIndex: number }): void => {
  const { sourceIndex, destinationIndex } = result;
  setOrderedItems((prev) => {
    // Immutable reorder — no splice/mutation
    const item = prev[sourceIndex];
    const without = [...prev.slice(0, sourceIndex), ...prev.slice(sourceIndex + 1)];
    return [...without.slice(0, destinationIndex), item, ...without.slice(destinationIndex)];
  });
}, []);

// In AdminTable:
<AdminTable<Mock{Entity}>
  dataSource={paginatedData}
  columns={columns}
  draggable={{
    onDragEnd: handleDragEnd,
  }}
  // ... other props
/>
```

---

## 2. Detail Page

**Use for**: Single entity detail view with tabs for different information sections.

### File Structure

```
app/(admin)/{route}/[id]/
└── page.tsx
```

### Template (default — no tabs spec)

When `PageSpec.tabs` is not provided, use the default two-tab layout:

```tsx
'use client';

import { useState, useMemo, type Key } from 'react';
import { useParams } from 'next/navigation';
import { PageWrapper } from 'mezzanine-ui-admin-components';
import { Tab, TabItem, Typography } from '@mezzanine-ui/react';
import { useMock{Entity} } from '@/hooks/useMock{Entity}';

export default function {Entity}DetailPage(): JSX.Element {
  const params = useParams();
  const { items } = useMock{Entity}();
  const item = useMemo(
    () => items.find((i) => i.id === params.id),
    [items, params.id],
  );
  const [activeTab, setActiveTab] = useState<Key>('info');

  if (!item) {
    return <PageWrapper title="找不到資料" />;
  }

  return (
    <PageWrapper title={`${item.name} 詳情`}>
      <Tab activeKey={activeTab} onChange={(key) => setActiveTab(key)}>
        <TabItem key="info">基本資訊</TabItem>
        <TabItem key="related">相關紀錄</TabItem>
      </Tab>
      {activeTab === 'info' && (
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 'var(--mzn-spacing-4)', padding: 'var(--mzn-spacing-4)' }}>
          {/* Render each field as label: value pairs */}
          <div>
            <Typography variant="caption" color="text-neutral-light">欄位標題</Typography>
            <Typography variant="body">{item.fieldName}</Typography>
          </div>
        </div>
      )}
      {activeTab === 'related' && (
        <div style={{ padding: 'var(--mzn-spacing-4)' }}>
          {/* Related data table if applicable */}
        </div>
      )}
    </PageWrapper>
  );
}
```

### Template (with tabs spec)

When `PageSpec.tabs` is provided, generate one `TabItem` per entry and conditionally render content panels:

```tsx
'use client';

import { useState, useMemo, type Key } from 'react';
import { useParams } from 'next/navigation';
import { PageWrapper, AdminTable } from 'mezzanine-ui-admin-components';
import { Tab, TabItem, Typography } from '@mezzanine-ui/react';
import { useMock{Entity} } from '@/hooks/useMock{Entity}';
// Import related entity hooks as needed
import { useMock{RelatedEntity} } from '@/hooks/useMock{RelatedEntity}';

export default function {Entity}DetailPage(): JSX.Element {
  const params = useParams();
  const { items } = useMock{Entity}();
  const item = useMemo(
    () => items.find((i) => i.id === params.id),
    [items, params.id],
  );

  // For tabs with relatedEntity, filter related data
  const { items: relatedItems } = useMock{RelatedEntity}();
  const filteredRelated = useMemo(
    () => relatedItems.filter((r) => r.{entityRef}Id === params.id),
    [relatedItems, params.id],
  );

  // Tab keys derived from PageSpec.tabs — use kebab-case labels as keys
  const [activeTab, setActiveTab] = useState<Key>('tab-0');

  if (!item) {
    return <PageWrapper title="找不到資料" />;
  }

  return (
    <PageWrapper title={`${item.name} 詳情`}>
      <Tab activeKey={activeTab} onChange={(key) => setActiveTab(key)}>
        {/* One TabItem per entry in PageSpec.tabs */}
        <TabItem key="tab-0">{tabSpec.label}</TabItem>
        <TabItem key="tab-1">{tabSpec.label}</TabItem>
      </Tab>

      {/* Tab with fields[] — render field label:value pairs */}
      {activeTab === 'tab-0' && (
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 'var(--mzn-spacing-4)', padding: 'var(--mzn-spacing-4)' }}>
          {/* Only render fields listed in tabSpec.fields */}
          <div>
            <Typography variant="caption" color="text-neutral-light">{field.label}</Typography>
            <Typography variant="body">{item[field.name]}</Typography>
          </div>
        </div>
      )}

      {/* Tab with relatedEntity — render AdminTable */}
      {activeTab === 'tab-1' && (
        <AdminTable
          dataSource={filteredRelated}
          columns={relatedColumns}
        />
      )}
    </PageWrapper>
  );
}
```

**Fallback**: When `PageSpec.tabs` is absent, use the default template above with all fields in "基本資訊" tab and an empty "相關紀錄" tab.

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

import { useRouter } from 'next/navigation';
import { useForm } from 'react-hook-form';
import { PageWrapper } from 'mezzanine-ui-admin-components';
import { FormFieldsWrapper, InputField } from '@mezzanine-ui/react-hook-form-v2';
import { useMock{Entity} } from '@/hooks/useMock{Entity}';
import type { Mock{Entity} } from '@/types';

export default function Create{Entity}Page(): JSX.Element {
  const router = useRouter();
  const { create } = useMock{Entity}();
  const methods = useForm<Omit<Mock{Entity}, 'id'>>();

  const handleSubmit = (values: Omit<Mock{Entity}, 'id'>): void => {
    create(values);
    router.push('/{route}');
  };

  return (
    <PageWrapper title="新增{entityLabel}" isFormPage>
      <FormFieldsWrapper
        methods={methods}
        onSubmit={handleSubmit}
        haveFooter
        submitButtonText="儲存"
        cancelButtonText="取消"
        onCancel={async () => router.back()}
      >
        {/* Form fields */}
      </FormFieldsWrapper>
    </PageWrapper>
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
import { Typography, Icon, Tag } from '@mezzanine-ui/react';
import { AdminTable, PageWrapper } from 'mezzanine-ui-admin-components';
import { BoxIcon, FolderMoveIcon, CheckCircleIcon } from '@mezzanine-ui/icons';
// Import one hook per entity in projectSpec.entities:
import { useMockProduct } from '@/hooks/useMockProduct';
import { useMockWarehouse } from '@/hooks/useMockWarehouse';
// ... add more as needed

// Stat card component (inline — simple enough to not need a separate file)
function StatCard({ title, value, icon }: { title: string; value: string | number; icon: ReactNode }): JSX.Element {
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

export default function DashboardPage(): JSX.Element {
  // Import mock data from all primary entities
  const { items: products } = useMockProduct();
  const { items: warehouses } = useMockWarehouse();
  // ... import all entity hooks

  // Derive stat values from actual mock data
  const stats = useMemo(() => ({
    productCount: products.length,
    warehouseCount: warehouses.length,
    activeProducts: products.filter((p) => p.isActive).length,
  }), [products, warehouses]);

  // Recent items — last 5 from each entity sorted by createdAt
  const recentProducts = useMemo(
    () => [...products].sort((a, b) =>
      new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime(),
    ).slice(0, 5),
    [products],
  );

  const recentWarehouses = useMemo(
    () => [...warehouses].slice(0, 5),
    [warehouses],
  );

  // Column definitions for recent tables (simplified — show key fields only)
  const recentProductColumns = useMemo(() => [
    { title: '商品名稱', dataIndex: 'name' as const, width: 200 },
    { title: '分類', dataIndex: 'category' as const, width: 100 },
  ], []);

  const recentWarehouseColumns = useMemo(() => [
    { title: '倉庫名稱', dataIndex: 'name' as const, width: 200 },
    { title: '地址', dataIndex: 'location' as const, width: 200 },
  ], []);

  return (
    <PageWrapper title="總覽">
      {/* Section 1: Stat Cards — derived from actual mock data counts */}
      <div style={{
        display: 'grid',
        gridTemplateColumns: 'repeat(auto-fit, minmax(240px, 1fr))',
        gap: 'var(--mzn-spacing-4)',
        marginBottom: 'var(--mzn-spacing-6)',
      }}>
        <StatCard title="商品總數" value={stats.productCount} icon={<Icon icon={BoxIcon} size={24} />} />
        <StatCard title="倉庫數量" value={stats.warehouseCount} icon={<Icon icon={FolderMoveIcon} size={24} />} />
        <StatCard title="啟用商品" value={stats.activeProducts} icon={<Icon icon={CheckCircleIcon} size={24} />} />
      </div>

      {/* Section 2: Status Breakdown — for entities with enum/boolean status fields */}
      <Typography variant="h5" style={{ marginBottom: 'var(--mzn-spacing-3)' }}>
        狀態分佈
      </Typography>
      <div style={{
        display: 'flex',
        gap: 'var(--mzn-spacing-3)',
        flexWrap: 'wrap',
        marginBottom: 'var(--mzn-spacing-6)',
      }}>
        {/* For each enum status value, show count as a Tag */}
        <Tag label={`啟用中: ${stats.activeProducts}`} />
        <Tag label={`停用: ${stats.productCount - stats.activeProducts}`} />
        {/* Repeat for other enum fields */}
      </div>

      {/* Section 3: Recent Activity Tables — one per primary entity (5 rows each) */}
      <Typography variant="h5" style={{ marginBottom: 'var(--mzn-spacing-3)' }}>
        最近異動
      </Typography>
      <AdminTable
        dataSource={recentProducts}
        columns={recentProductColumns}
      />

      {/* Add more recent tables for other entities with spacing */}
      <div style={{ marginTop: 'var(--mzn-spacing-6)' }}>
        <Typography variant="h5" style={{ marginBottom: 'var(--mzn-spacing-3)' }}>
          最近倉庫紀錄
        </Typography>
        <AdminTable
          dataSource={recentWarehouses}
          columns={recentWarehouseColumns}
        />
      </div>

      {/* Section 4: Chart Placeholder — reserved area for future chart integration */}
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
        <Typography color="text-neutral-light">
          圖表區域（待整合）
        </Typography>
      </div>
    </PageWrapper>
  );
}
```

---

## 5. Export (CSV Download) Pattern

**Use for**: Any list page with `'export'` in its `actions` array.

### Utility Function

Create `src/utils/downloadCSV.ts` (reusable across pages):

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
        // Escape CSV values containing commas or quotes
        return value.includes(',') || value.includes('"')
          ? `"${value.replace(/"/g, '""')}"`
          : value;
      })
      .join(','),
  );

  const csvContent = [header, ...rows].join('\n');
  const BOM = '\uFEFF'; // UTF-8 BOM for Excel compatibility
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

### Integration with PageWrapper

Use `customizeActionComponent` to add the export button alongside the create button:

```tsx
import { Button, Icon } from '@mezzanine-ui/react';
import { DownloadIcon } from '@mezzanine-ui/icons';
import { downloadCSV } from '@/utils/downloadCSV';

<PageWrapper
  title="商品管理"
  onCreate={handleCreate}
  createText="新增商品"
  customizeActionComponent={
    <Button
      variant="base-secondary"
      icon={DownloadIcon}
      iconType="leading"
      onClick={() => downloadCSV(items, exportColumns, 'products')}
    >
      匯出 CSV
    </Button>
  }
>
```

Where `exportColumns` maps entity fields to CSV-friendly string renderers.

---

## Common Patterns

### 'use client' Directive

Every page and component file **must** start with `'use client'` since we use `useState`, `useCallback`, and other client hooks.

### Mezzanine-UI Spacing

Use CSS variables for spacing, never hardcoded pixels:
- `var(--mzn-spacing-1)` = 4px
- `var(--mzn-spacing-2)` = 8px
- `var(--mzn-spacing-3)` = 12px
- `var(--mzn-spacing-4)` = 16px
- `var(--mzn-spacing-5)` = 20px
- `var(--mzn-spacing-6)` = 24px
- `var(--mzn-spacing-8)` = 32px

### Date Formatting

Use `date-fns` for date formatting (include in generated package.json):

```tsx
import { format } from 'date-fns';
format(new Date(value), 'yyyy/MM/dd');
```
