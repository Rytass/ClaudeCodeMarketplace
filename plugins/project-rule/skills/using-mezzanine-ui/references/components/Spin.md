# Spin Component

> **Category**: Feedback
>
> **Storybook**: `Feedback/Spin`
>
> **Source Verification**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/react/src/Spin) · Verified v2 source (2026-03-13)

Spinning loading component for indicating content is loading.

## Import

```tsx
import { Spin } from '@mezzanine-ui/react';
import type { SpinProps } from '@mezzanine-ui/react';
```

---

## Spin Props

| Property               | Type                  | Default  | Description                |
| ---------------------- | --------------------- | -------- | -------------------------- |
| `children`             | `ReactNode`           | -        | Wrapped content            |
| `description`          | `string`              | -        | Loading description text   |
| `descriptionClassName` | `string`              | -        | Description className      |
| `size`                 | `GeneralSize`          | `'main'` | Size (`'main' \| 'sub' \| 'minor'`) |
| `stretch`              | `boolean`             | `false`  | Whether to stretch to fill container |
| `iconProps`            | `Omit<IconProps, 'icon' \| 'spin'>` | -  | Custom icon props          |
| `loading`              | `boolean`             | `false`  | Whether loading            |
| `backdropProps`        | `Omit<BackdropProps, 'container' \| 'open'>` | - | Backdrop props (nested mode) |

---

## Usage Examples

### Standalone Usage

```tsx
import { Spin } from '@mezzanine-ui/react';

// Basic usage
<Spin loading />

// With description
<Spin loading description="Loading..." />

// Different sizes
<Spin loading size="main" />
<Spin loading size="sub" />
<Spin loading size="minor" />
```

### Stretch to Fill Container

```tsx
<div style={{ height: 200 }}>
  <Spin loading stretch />
</div>
```

### Wrapping Content (Nested Mode)

When Spin wraps child elements, it automatically uses a semi-transparent overlay to cover the content.

```tsx
function LoadingCard() {
  const [loading, setLoading] = useState(true);

  return (
    <Spin loading={loading} description="Loading...">
      <Card
        title="Card Title"
        description="Card content..."
      />
    </Spin>
  );
}
```

### Table Loading

```tsx
function DataTable() {
  const [loading, setLoading] = useState(false);
  const [data, setData] = useState([]);

  const fetchData = async () => {
    setLoading(true);
    const result = await api.getData();
    setData(result);
    setLoading(false);
  };

  return (
    <Spin loading={loading}>
      <Table dataSource={data} columns={columns} />
    </Spin>
  );
}
```

### Custom Icon Style

```tsx
<Spin
  loading
  iconProps={{
    color: 'primary',
    size: 32,
  }}
/>
```

### Full Page Loading

```tsx
function PageLoading() {
  return (
    <div style={{ position: 'fixed', inset: 0 }}>
      <Spin
        loading
        stretch
        description="Loading page..."
      />
    </div>
  );
}
```

### Delayed Display

Avoid flickering by not showing Spin for short loading times.

```tsx
function DelayedSpin({ loading, delay = 300, children }) {
  const [show, setShow] = useState(false);

  useEffect(() => {
    let timer: NodeJS.Timeout;

    if (loading) {
      timer = setTimeout(() => setShow(true), delay);
    } else {
      setShow(false);
    }

    return () => clearTimeout(timer);
  }, [loading, delay]);

  return (
    <Spin loading={show}>
      {children}
    </Spin>
  );
}
```

### Conditional Loading

```tsx
function ConditionalLoading() {
  const [loading, setLoading] = useState(false);

  return (
    <>
      <Button onClick={() => setLoading(!loading)}>
        Toggle Loading State
      </Button>

      <Spin loading={loading}>
        <div className="content">
          This is the content area
        </div>
      </Spin>
    </>
  );
}
```

---

## Two Modes

### Standalone Mode

Without wrapping children, displays only the spinning icon and description.

```tsx
<Spin loading description="Loading" />
```

### Nested Mode

Wrapping children with a semi-transparent overlay when loading.

```tsx
<Spin loading>
  <Content />
</Spin>
```

---

## Figma Mapping

| Figma Variant              | React Props                              |
| -------------------------- | ---------------------------------------- |
| `Spin / Main`              | `size="main"`                            |
| `Spin / Sub`               | `size="sub"`                             |
| `Spin / Minor`             | `size="minor"`                           |
| `Spin / With Description`  | `description="..."`                      |
| `Spin / Nested`            | Wrapping children                        |

---

## Best Practices

1. **Use loading prop**: Control display state via `loading`
2. **Provide description text**: Long loading times should include a description
3. **Avoid flickering**: Consider delayed display for short loading times
4. **Nested mode**: Recommend nested mode for data block loading
5. **Stretch to fill**: Use `stretch` when the container needs a fixed height
