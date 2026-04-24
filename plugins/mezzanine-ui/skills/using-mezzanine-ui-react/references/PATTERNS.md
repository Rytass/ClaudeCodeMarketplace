# Mezzanine-UI Common Usage Patterns

Common UI pattern implementation examples.

> Baseline: `@mezzanine-ui/*` `1.x` (react/core `1.1.0`, icons/system `1.0.2`). Last verified: 2026-04-24.

## Table of Contents

- [Layout Patterns](#layout-patterns)
- [Form Patterns](#form-patterns)
- [Table Patterns](#table-patterns)
- [Dialog Patterns](#dialog-patterns)
- [Navigation Patterns](#navigation-patterns)
- [Loading States](#loading-states)
- [Error Handling](#error-handling)
- [Notifications](#notifications)

---

## Layout Patterns

### Full Page Layout + Side Panel

```tsx
import { Layout } from '@mezzanine-ui/react';
import { Navigation, NavigationHeader, NavigationOption, NavigationOptionCategory } from '@mezzanine-ui/react';
import { HomeIcon, SettingIcon } from '@mezzanine-ui/icons';
import { useState } from 'react';

function AppWithSidePanel() {
  const [sidePanelOpen, setSidePanelOpen] = useState(false);
  const [selectedItem, setSelectedItem] = useState<DataItem | null>(null);

  const handleItemClick = (item: DataItem): void => {
    setSelectedItem(item);
    setSidePanelOpen(true);
  };

  return (
    <div style={{ display: 'flex', height: '100vh' }}>
      <Navigation>
        <NavigationHeader>
          <img src="/logo.svg" alt="Logo" />
        </NavigationHeader>
        <NavigationOptionCategory title="Main Menu">
          <NavigationOption icon={HomeIcon} title="Home" />
          <NavigationOption icon={SettingIcon} title="Settings" />
        </NavigationOptionCategory>
      </Navigation>

      <Layout>
        <Layout.Main>
          <PageHeader title="Item List" />
          <Table
            columns={columns}
            dataSource={data}
            onRow={(record) => ({
              onClick: () => handleItemClick(record),
            })}
          />
        </Layout.Main>
        <Layout.SidePanel
          open={sidePanelOpen}
          defaultSidePanelWidth={400}
        >
          {selectedItem && (
            <>
              <h2>{selectedItem.name}</h2>
              <p>{selectedItem.description}</p>
              <Button onClick={() => setSidePanelOpen(false)}>
                Close
              </Button>
            </>
          )}
        </Layout.SidePanel>
      </Layout>
    </div>
  );
}
```

---

## Form Patterns

### Basic Form

```tsx
import {
  FormField,
  Input,
  Select,
  Button,
} from '@mezzanine-ui/react';

const typeOptions = [
  { id: 'personal', name: 'Personal' },
  { id: 'business', name: 'Business' },
];

function BasicForm() {
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [type, setType] = useState<{ id: string; name: string } | null>(null);

  const handleSubmit = () => {
    // Handle submission
  };

  return (
    <form onSubmit={handleSubmit}>
      <FormField name="name" label="Name" required>
        <Input
          value={name}
          onChange={(e) => setName(e.target.value)}
          placeholder="Enter name"
        />
      </FormField>

      <FormField name="email" label="Email" required hintText="We will not disclose your Email">
        <Input
          value={email}
          onChange={(e) => setEmail(e.target.value)}
          placeholder="Enter Email"
        />
      </FormField>

      <FormField name="type" label="Type">
        <Select
          value={type}
          onChange={(value) => setType(value)}
          placeholder="Select type"
          options={typeOptions}
        />
      </FormField>

      <div style={{ display: 'flex', gap: 8, justifyContent: 'flex-end' }}>
        <Button variant="base-secondary" onClick={() => {}}>
          Cancel
        </Button>
        <Button variant="base-primary" onClick={handleSubmit}>
          Submit
        </Button>
      </div>
    </form>
  );
}
```

### Form Validation

```tsx
import {
  FormField,
  Input,
} from '@mezzanine-ui/react';
import type { SeverityWithInfo } from '@mezzanine-ui/system/severity';

function FormWithValidation() {
  const [email, setEmail] = useState('');
  const [error, setError] = useState('');

  const validateEmail = (value: string) => {
    if (!value) {
      setError('Email is required');
      return false;
    }
    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value)) {
      setError('Invalid Email format');
      return false;
    }
    setError('');
    return true;
  };

  const severity: SeverityWithInfo = error ? 'error' : 'info';

  return (
    <FormField name="email" label="Email" required severity={severity} hintText={error || undefined}>
      <Input
        value={email}
        onChange={(e) => {
          setEmail(e.target.value);
          validateEmail(e.target.value);
        }}
        placeholder="Enter Email"
      />
    </FormField>
  );
}
```

### Search Form

```tsx
import { Input, Button } from '@mezzanine-ui/react';

function SearchForm() {
  const [keyword, setKeyword] = useState('');

  const handleSearch = () => {
    // Execute search
  };

  return (
    <div style={{ display: 'flex', gap: 8 }}>
      <Input
        variant="search"
        value={keyword}
        onChange={(e) => setKeyword(e.target.value)}
        placeholder="Search..."
        clearable
      />
      <Button variant="base-primary" onClick={handleSearch}>
        Search
      </Button>
    </div>
  );
}
```

---

## Table Patterns

### Basic Data Table

```tsx
import { Table, Tag, Button, Modal } from '@mezzanine-ui/react';
import { useState } from 'react';

function DataTable() {
  const [deleteTarget, setDeleteTarget] = useState<DataItem | null>(null);

  const handleDeleteConfirm = () => {
    if (deleteTarget) {
      handleDelete(deleteTarget.id);
      setDeleteTarget(null);
    }
  };

  const columns = [
    {
      title: 'Name',
      dataIndex: 'name',
    },
    {
      title: 'Status',
      dataIndex: 'status',
      render: (status: string) => (
        <Tag type="static" label={status === 'active' ? 'Active' : 'Inactive'} />
      ),
    },
    {
      title: 'Created At',
      dataIndex: 'createdAt',
      render: (date: string) => new Date(date).toLocaleDateString(),
    },
    {
      title: 'Actions',
      render: (_: unknown, record: DataItem) => (
        <div style={{ display: 'flex', gap: 8 }}>
          <Button
            variant="base-text-link"
            size="minor"
            onClick={() => handleEdit(record)}
          >
            Edit
          </Button>
          <Button
            variant="destructive-text-link"
            size="minor"
            onClick={() => setDeleteTarget(record)}
          >
            Delete
          </Button>
        </div>
      ),
    },
  ];

  const data = [
    { id: '1', name: 'Item 1', status: 'active', createdAt: '2024-01-01' },
    { id: '2', name: 'Item 2', status: 'inactive', createdAt: '2024-01-02' },
  ];

  return (
    <>
      <Table columns={columns} dataSource={data} />
      <Modal
        open={!!deleteTarget}
        onClose={() => setDeleteTarget(null)}
        size="narrow"
        modalType="standard"
        showModalHeader
        title="Confirm Deletion"
        showModalFooter
        confirmText="Delete"
        onConfirm={handleDeleteConfirm}
        cancelText="Cancel"
        onCancel={() => setDeleteTarget(null)}
      >
        Are you sure you want to delete "{deleteTarget?.name}"?
      </Modal>
    </>
  );
}
```

### Selectable Table

```tsx
import { Table, Button } from '@mezzanine-ui/react';
import type { TableRowSelection } from '@mezzanine-ui/react';

function SelectableTable() {
  const [selectedKeys, setSelectedKeys] = useState<string[]>([]);

  const rowSelection: TableRowSelection = {
    selectedRowKeys: selectedKeys,
    onChange: (keys) => setSelectedKeys(keys as string[]),
  };

  const handleBatchDelete = () => {
    // Batch delete selected items
  };

  return (
    <div>
      {selectedKeys.length > 0 && (
        <div style={{ marginBottom: 16 }}>
          <span>{selectedKeys.length} items selected</span>
          <Button
            variant="destructive-secondary"
            size="sub"
            onClick={handleBatchDelete}
          >
            Batch Delete
          </Button>
        </div>
      )}
      <Table
        columns={columns}
        dataSource={data}
        rowSelection={rowSelection}
      />
    </div>
  );
}
```

### Table with Pagination

```tsx
import { Table, Pagination, usePagination } from '@mezzanine-ui/react';

function PaginatedTable() {
  const [data, setData] = useState([]);
  const [total, setTotal] = useState(0);
  const [currentPage, setCurrentPage] = useState(1);

  const pagination = usePagination({
    total,
    pageSize: 10,
    current: currentPage,
    onChange: (page) => {
      setCurrentPage(page);
      fetchData(page, 10);
    },
  });

  useEffect(() => {
    fetchData(1, 10);
  }, []);

  return (
    <div>
      <Table columns={columns} dataSource={data} />
      <div style={{ marginTop: 16, display: 'flex', justifyContent: 'flex-end' }}>
        <Pagination {...pagination} />
      </div>
    </div>
  );
}
```

---

## Dialog Patterns

### Confirmation Dialog

```tsx
import { Modal } from '@mezzanine-ui/react';

function ConfirmModal({ open, onClose, onConfirm }) {
  return (
    <Modal
      open={open}
      onClose={onClose}
      size="narrow"
      modalType="standard"
      showModalHeader
      title="Confirm Deletion"
      showModalFooter
      confirmText="Delete"
      onConfirm={onConfirm}
      cancelText="Cancel"
      onCancel={onClose}
    >
      Are you sure you want to delete this item? This action cannot be undone.
    </Modal>
  );
}
```

### Form Dialog

```tsx
import {
  Modal,
  FormField,
  Input,
} from '@mezzanine-ui/react';

function FormModal({ open, onClose, onSubmit }) {
  const [name, setName] = useState('');
  const [loading, setLoading] = useState(false);

  const handleSubmit = async () => {
    setLoading(true);
    try {
      await onSubmit({ name });
      onClose();
    } finally {
      setLoading(false);
    }
  };

  return (
    <Modal
      open={open}
      onClose={onClose}
      modalType="standard"
      showModalHeader
      title="Add Item"
      showModalFooter
      confirmText="Confirm"
      onConfirm={handleSubmit}
      cancelText="Cancel"
      onCancel={onClose}
      loading={loading}
    >
      <FormField name="name" label="Name" required>
        <Input
          value={name}
          onChange={(e) => setName(e.target.value)}
          placeholder="Enter name"
        />
      </FormField>
    </Modal>
  );
}
```

### Drawer Detail

```tsx
import {
  Drawer,
  DrawerHeader,
  DrawerBody,
  DrawerFooter,
  Button,
  Description,
  DescriptionGroup,
  DescriptionContent,
} from '@mezzanine-ui/react';

function DetailDrawer({ open, onClose, data }) {
  return (
    <Drawer open={open} onClose={onClose}>
      <DrawerHeader title="Item Details" />
      <DrawerBody>
        <DescriptionGroup>
          <Description title="Name">
            <DescriptionContent>{data?.name}</DescriptionContent>
          </Description>
          <Description title="Status">
            <DescriptionContent>{data?.status}</DescriptionContent>
          </Description>
          <Description title="Created At">
            <DescriptionContent>{data?.createdAt}</DescriptionContent>
          </Description>
        </DescriptionGroup>
      </DrawerBody>
      <DrawerFooter>
        <Button variant="base-secondary" onClick={onClose}>
          Cancel
        </Button>
        <Button variant="base-primary" onClick={() => handleEdit(data)}>
          Edit
        </Button>
      </DrawerFooter>
    </Drawer>
  );
}
```

---

## Navigation Patterns

### Side Navigation

```tsx
import {
  Navigation,
  NavigationHeader,
  NavigationOption,
  NavigationOptionCategory,
  NavigationFooter,
  NavigationUserMenu,
} from '@mezzanine-ui/react';
import { HomeIcon, SettingIcon, FileIcon } from '@mezzanine-ui/icons';

function SideNavigation() {
  const [activeKey, setActiveKey] = useState('home');

  return (
    <Navigation>
      <NavigationHeader>
        <img src="/logo.svg" alt="Logo" />
      </NavigationHeader>

      <NavigationOptionCategory title="Main Menu">
        <NavigationOption
          icon={HomeIcon}
          title="Home"
          active={activeKey === 'home'}
          onTriggerClick={() => setActiveKey('home')}
        />
        <NavigationOption
          icon={FileIcon}
          title="Documents"
          active={activeKey === 'documents'}
          onTriggerClick={() => setActiveKey('documents')}
        />
      </NavigationOptionCategory>

      <NavigationOptionCategory title="Settings">
        <NavigationOption
          icon={SettingIcon}
          title="System Settings"
          active={activeKey === 'settings'}
          onTriggerClick={() => setActiveKey('settings')}
        />
      </NavigationOptionCategory>

      <NavigationFooter>
        <NavigationUserMenu imgSrc="/avatar.png" />
      </NavigationFooter>
    </Navigation>
  );
}
```

### Tab Navigation

```tsx
import { Tab, TabItem } from '@mezzanine-ui/react';
import { Key } from 'react';

function TabNavigation() {
  const [activeKey, setActiveKey] = useState<Key>('overview');

  return (
    <div>
      <Tab activeKey={activeKey} onChange={(key) => setActiveKey(key)}>
        <TabItem key="overview">Overview</TabItem>
        <TabItem key="details">Details</TabItem>
        <TabItem key="history">History</TabItem>
      </Tab>

      {activeKey === 'overview' && <OverviewContent />}
      {activeKey === 'details' && <DetailsContent />}
      {activeKey === 'history' && <HistoryContent />}
    </div>
  );
}
```

---

## Loading States

### Page Loading

```tsx
import { Spin, Skeleton } from '@mezzanine-ui/react';

function PageLoading() {
  const [loading, setLoading] = useState(true);
  const [data, setData] = useState(null);

  if (loading) {
    return (
      <div style={{ padding: 24, textAlign: 'center' }}>
        <Spin loading description="Loading..." />
      </div>
    );
  }

  return <PageContent data={data} />;
}

// Or use Skeleton
function PageWithSkeleton() {
  const [loading, setLoading] = useState(true);

  if (loading) {
    return (
      <div style={{ padding: 24 }}>
        <Skeleton width={200} height={24} />
        <Skeleton width="100%" height={16} style={{ marginTop: 16 }} />
        <Skeleton width="100%" height={16} style={{ marginTop: 8 }} />
        <Skeleton width="80%" height={16} style={{ marginTop: 8 }} />
      </div>
    );
  }

  return <PageContent />;
}
```

### Button Loading

```tsx
import { Button } from '@mezzanine-ui/react';

function SubmitButton() {
  const [loading, setLoading] = useState(false);

  const handleClick = async () => {
    setLoading(true);
    try {
      await submitData();
    } finally {
      setLoading(false);
    }
  };

  return (
    <Button variant="base-primary" loading={loading} onClick={handleClick}>
      Submit
    </Button>
  );
}
```

---

## Error Handling

### Form Errors

```tsx
import { FormField, Input, InlineMessageGroup } from '@mezzanine-ui/react';

function FormWithErrors({ errors }) {
  const nameError = errors.find(e => e.field === 'name');

  return (
    <div>
      {errors.length > 0 && (
        <InlineMessageGroup
          items={errors.map(err => ({
            key: err.field,
            severity: 'error' as const,
            content: err.message,
          }))}
        />
      )}

      <FormField
        name="name"
        label="Name"
        required
        severity={nameError ? 'error' : 'info'}
        hintText={nameError?.message}
      >
        <Input placeholder="Enter name" />
      </FormField>
    </div>
  );
}
```

### Empty State

```tsx
import { Empty, Button } from '@mezzanine-ui/react';

function EmptyState() {
  return (
    <Empty
      title="No data available"
      type="initial-data"
    >
      <Button onClick={() => handleCreate()}>
        Create first entry
      </Button>
    </Empty>
  );
}
```

### Result State

```tsx
import { ResultState, Button } from '@mezzanine-ui/react';

function SuccessResult() {
  return (
    <ResultState
      type="success"
      title="Operation Successful"
      description="Your changes have been saved"
      actions={{
        secondaryButton: { children: 'Back to list', onClick: () => navigate('/list') },
        primaryButton: { children: 'Continue adding', onClick: () => reset() },
      }}
    />
  );
}

function ErrorResult() {
  return (
    <ResultState
      type="error"
      title="Operation Failed"
      description="An error occurred, please try again later"
      actions={{
        secondaryButton: { children: 'Retry', onClick: () => retry() },
      }}
    />
  );
}
```

---

## Notifications

### Message Alerts

```tsx
import { Message, Button } from '@mezzanine-ui/react';

function NotificationExample() {
  const handleSave = async () => {
    try {
      await saveData();
      Message.success('Saved successfully');
    } catch (error) {
      Message.error('Save failed, please try again later');
    }
  };

  return (
    <Button variant="base-primary" onClick={handleSave}>
      Save
    </Button>
  );
}
```

### Notification Center

```tsx
import { NotificationCenter, Button } from '@mezzanine-ui/react';

function NotificationExample() {
  const showNotification = () => {
    NotificationCenter.success({
      title: 'Operation Successful',
      description: 'Your changes have been saved',
      duration: 5000,
    });
  };

  const showError = () => {
    NotificationCenter.error({
      title: 'Operation Failed',
      description: 'An error occurred, please contact the administrator',
      duration: 0, // Does not auto-close
    });
  };

  return (
    <div>
      <Button onClick={showNotification}>Show success notification</Button>
      <Button onClick={showError}>Show error notification</Button>
    </div>
  );
}
```

### Alert Banner

```tsx
import { AlertBanner } from '@mezzanine-ui/react';

function PageWithBanner() {
  const [showBanner, setShowBanner] = useState(true);

  return (
    <div>
      {showBanner && (
        <AlertBanner
          severity="warning"
          message="System maintenance tonight at 22:00, estimated downtime: 2 hours."
          onClose={() => setShowBanner(false)}
        />
      )}
      <PageContent />
    </div>
  );
}
```
