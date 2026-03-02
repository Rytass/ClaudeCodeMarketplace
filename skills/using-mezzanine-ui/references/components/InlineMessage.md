# InlineMessage Component

> **Category**: Feedback
>
> **Storybook**: `Feedback/Inline Messages`
>
> **Source**: [GitHub Source Code](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/react/src/InlineMessage)

An inline message component for displaying contextual feedback messages.

## Import

```tsx
import { InlineMessage, InlineMessageGroup } from '@mezzanine-ui/react';
import type {
  InlineMessageProps,
  InlineMessageGroupProps,
  InlineMessageGroupItem,
} from '@mezzanine-ui/react';

// InlineMessageSeverity must be imported from core
import type { InlineMessageSeverity } from '@mezzanine-ui/core/inline-message';
```

---

## InlineMessage Props

Extends `NativeElementPropsWithoutKeyAndRef<'div'>`.

| Property    | Type                                | Default    | Description                      |
| ----------- | ----------------------------------- | ---------- | -------------------------------- |
| `content`   | `string`                            | **Required** | Message content (string only)  |
| `className` | `string`                            | -          | Additional className             |
| `icon`      | `IconDefinition`                    | -          | Custom icon                      |
| `onClose`   | `() => void`                        | -          | Close callback                   |
| `severity`  | `InlineMessageSeverity`             | **Required** | Severity level                 |

---

## InlineMessageSeverity Type

```tsx
type InlineMessageSeverity = 'info' | 'warning' | 'error';
```

Note: InlineMessage does not support `success` type (unlike Alert).

---

## Usage Examples

### Basic Usage

```tsx
import { InlineMessage } from '@mezzanine-ui/react';

<InlineMessage severity="info" content="This is an info message" />
<InlineMessage severity="warning" content="This is a warning message" />
<InlineMessage severity="error" content="This is an error message" />
```

### With Close Button

```tsx
// Only severity="info" displays a close button
<InlineMessage
  severity="info"
  content="This is a closable message"
  onClose={() => console.log('closed')}
/>
```

### Custom Icon

```tsx
import { InfoIcon } from '@mezzanine-ui/icons';

<InlineMessage
  severity="info"
  content="Message with custom icon"
  icon={InfoIcon}
/>
```

### Form Field Hint

```tsx
function FormFieldWithHint() {
  const [hasError, setHasError] = useState(false);

  return (
    <div>
      <Input
        error={hasError}
        onChange={(e) => setHasError(!e.target.value)}
      />
      {hasError && (
        <InlineMessage
          severity="error"
          content="This field is required"
        />
      )}
    </div>
  );
}
```

### Warning Hint

```tsx
<InlineMessage
  severity="warning"
  content="This action cannot be undone"
/>
```

---

## InlineMessageGroup

A group component that combines multiple InlineMessages together.

### InlineMessageGroup Props

| Property      | Type                        | Default | Description                                 |
| ------------- | --------------------------- | ------- | ------------------------------------------- |
| `items`       | `InlineMessageGroupItem[]`  | -       | Message items (ignored when children exists) |
| `children`    | `ReactNode`                 | -       | Custom message nodes                        |
| `onItemClose` | `(key: Key) => void`        | -       | Item close callback                         |

### InlineMessageGroupItem

```tsx
interface InlineMessageGroupItem extends Omit<InlineMessageProps, 'content'> {
  key: Key;
  content: string;
}
```

### InlineMessageGroup Usage Example

```tsx
import { InlineMessageGroup } from '@mezzanine-ui/react';

<InlineMessageGroup
  items={[
    { key: '1', severity: 'info', content: 'Info message' },
    { key: '2', severity: 'warning', content: 'Warning message' },
    { key: '3', severity: 'error', content: 'Error message' },
  ]}
  onItemClose={(key) => console.log('closed', key)}
/>
```

---

## InlineMessage vs AlertBanner

| Feature       | InlineMessage              | AlertBanner                   |
| ------------- | -------------------------- | ----------------------------- |
| Position      | Inline, near fields        | Page top (Portal alert layer) |
| Close button  | Info only                  | Yes (configurable closable)   |
| Severity      | info / warning / error     | info / warning / error        |
| Action buttons| None                       | Up to 2                       |
| API           | Component only             | Component + imperative        |
| Use case      | Form validation, field hints | Global system notifications |
| Animation     | Fade in/out                | CSS transition (entering/exiting) |

---

## Close Behavior

- **severity="info"**: Displays close button (using ClearActions)
- **severity="warning" / "error"**: No close button

This is because warning and error messages typically require user action to resolve and should not be directly dismissed.

---

## Figma Mapping

| Figma Variant                  | React Props                              |
| ------------------------------ | ---------------------------------------- |
| `InlineMessage / Info`         | `severity="info"`                        |
| `InlineMessage / Warning`      | `severity="warning"`                     |
| `InlineMessage / Error`        | `severity="error"`                       |

---

## Best Practices

1. **Keep content concise**: Content should be short and clear
2. **Use correct semantics**: Choose the appropriate severity based on message type
3. **Appropriate placement**: Place near the related input field or content
4. **Accessibility**: Component includes `role="status"` and `aria-live="polite"`
5. **String only**: Content only supports strings, not ReactNode
