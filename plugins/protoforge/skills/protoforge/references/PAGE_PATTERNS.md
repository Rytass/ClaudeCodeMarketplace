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

import { useState, useMemo, useCallback, Key } from 'react';
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
import { Modal, ModalHeader, ModalBody, ModalActions, Button } from '@mezzanine-ui/react';
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
      <ModalHeader>
        {mode === 'create' ? '新增{entityLabel}' : '編輯{entityLabel}'}
      </ModalHeader>
      <ModalBody>
        <FormFieldsWrapper methods={methods} onSubmit={onSubmit}>
          {/* Fields derived from EntitySpec.fields */}
          {/* See COMPONENT_MAPPING.md for field type → component mapping */}
        </FormFieldsWrapper>
      </ModalBody>
      <ModalActions
        cancelText="取消"
        confirmText="確認"
        onCancel={onClose}
        onConfirm={methods.handleSubmit(onSubmit)}
      />
    </Modal>
  );
};
```

---

## 2. Detail Page

**Use for**: Single entity detail view with tabs for different information sections.

### File Structure

```
app/(admin)/{route}/[id]/
└── page.tsx
```

### Template

```tsx
'use client';

import { useMemo } from 'react';
import { useParams } from 'next/navigation';
import { PageWrapper } from 'mezzanine-ui-admin-components';
import { Tabs, TabPane, Tab, Typography } from '@mezzanine-ui/react';
import { useMock{Entity} } from '@/hooks/useMock{Entity}';

export default function {Entity}DetailPage(): JSX.Element {
  const params = useParams();
  const { items } = useMock{Entity}();
  const item = useMemo(
    () => items.find((i) => i.id === params.id),
    [items, params.id],
  );

  if (!item) {
    return <PageWrapper title="找不到資料" />;
  }

  return (
    <PageWrapper title={`${item.name} 詳情`}>
      <Tabs>
        <TabPane tab={<Tab>基本資訊</Tab>}>
          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 'var(--mzn-spacing-4)', padding: 'var(--mzn-spacing-4)' }}>
            {/* Render each field as label: value pairs */}
            <div>
              <Typography variant="caption" color="text-secondary">欄位標題</Typography>
              <Typography variant="body1">{item.fieldName}</Typography>
            </div>
          </div>
        </TabPane>
        <TabPane tab={<Tab>相關紀錄</Tab>}>
          {/* Related data table if applicable */}
        </TabPane>
      </Tabs>
    </PageWrapper>
  );
}
```

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

export default function Create{Entity}Page(): JSX.Element {
  const router = useRouter();
  const { create } = useMock{Entity}();
  const methods = useForm<{Entity}FormValues>();

  const handleSubmit = (values: {Entity}FormValues): void => {
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

import { useMemo } from 'react';
import { Typography, Icon } from '@mezzanine-ui/react';
import { AdminTable } from 'mezzanine-ui-admin-components';
import { PageWrapper } from 'mezzanine-ui-admin-components';

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
        <Typography variant="caption" color="text-secondary">{title}</Typography>
        <Typography variant="h3">{value}</Typography>
      </div>
    </div>
  );
}

export default function DashboardPage(): JSX.Element {
  // Aggregate mock data for stats
  return (
    <PageWrapper title="總覽">
      <div style={{
        display: 'grid',
        gridTemplateColumns: 'repeat(auto-fit, minmax(240px, 1fr))',
        gap: 'var(--mzn-spacing-4)',
        marginBottom: 'var(--mzn-spacing-6)',
      }}>
        <StatCard title="商品總數" value={42} icon={/* icon */} />
        <StatCard title="倉庫數量" value={5} icon={/* icon */} />
        <StatCard title="本月入庫" value={128} icon={/* icon */} />
      </div>

      {/* Recent items table */}
      <Typography variant="h5" style={{ marginBottom: 'var(--mzn-spacing-3)' }}>
        最近異動
      </Typography>
      <AdminTable
        dataSource={recentItems}
        columns={recentColumns}
      />
    </PageWrapper>
  );
}
```

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
