# AlertBanner Component

> **Category**: Others
>
> **Storybook**: `Others/Alert Banner`
>
> **Source Verification**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/react/src/AlertBanner)

Alert banner component for displaying important system-level notifications. Supports both component-based and imperative APIs. Internally based on `createNotifier`, with sorting rules: non-info first, newest first. Renders using Portal `alert` level.

## Import

```tsx
import { AlertBanner } from '@mezzanine-ui/react';
import type { AlertBannerProps } from '@mezzanine-ui/react';

// AlertBannerSeverity must be imported from core
import type { AlertBannerSeverity } from '@mezzanine-ui/core/alert-banner';
```

---

## AlertBannerProps (Component-based)

Extends `Omit<NativeElementPropsWithoutKeyAndRef<'div'>, 'children' | 'title'>`.

| Property   | Type                  | Default | Description              |
| ---------- | --------------------- | ------- | ------------------------ |
| `actions`  | `AlertBannerAction[]` | -       | Action buttons (max 2)   |
| `closable` | `boolean`             | `true`  | Whether closable         |
| `icon`     | `IconDefinition`      | -       | Custom icon              |
| `message`  | `string`              | -       | Required, message content |
| `onClose`  | `() => void`          | -       | Close callback           |
| `severity` | `AlertBannerSeverity` | -       | Required, severity level |

---

## AlertBannerSeverity Type

| Severity  | Description | Default Icon          |
| --------- | ----------- | --------------------- |
| `info`    | Info        | InfoFilledIcon        |
| `warning` | Warning     | WarningFilledIcon     |
| `error`   | Error       | ErrorFilledIcon       |

---

## AlertBannerAction Type

```tsx
interface AlertBannerAction {
  content?: string;                              // Button text
  onClick: (event: MouseEvent) => void;          // Click callback
  // ...other Button props
}
```

---

## Imperative API

### Basic Methods

| Method                    | Description            |
| ------------------------- | ---------------------- |
| `AlertBanner.add()`       | Add alert              |
| `AlertBanner.remove(key)` | Remove specific alert  |
| `AlertBanner.destroy()`   | Clear all alerts       |
| `AlertBanner.config()`    | Set global config      |
| `AlertBanner.getConfig()` | Get current config     |

### Shortcut Methods

| Method                   | Description   |
| ------------------------ | ------------- |
| `AlertBanner.info()`    | Info alert    |
| `AlertBanner.warning()` | Warning alert |
| `AlertBanner.error()`   | Error alert   |

### AlertBannerData (`add()` parameter type)

Extends `Omit<NotifierData, 'onClose'>` and `AlertBannerConfigProps` (= `NotifierConfig`).

| Property    | Type                  | Default      | Description              |
| ----------- | --------------------- | ------------ | ------------------------ |
| `actions`   | `AlertBannerAction[]` | -            | Action buttons (max 2)   |
| `closable`  | `boolean`             | -            | Whether closable         |
| `duration`  | `number \| false`     | -            | Auto-close duration (ms) |
| `icon`      | `IconDefinition`      | -            | Custom icon              |
| `message`   | `string`              | **required** | Message content          |
| `onClose`   | `() => void`          | -            | Close callback           |
| `reference` | `Key`                 | -            | Identification key       |
| `severity`  | `AlertBannerSeverity` | **required** | Severity level           |

---

## Usage Examples

### Component-based Usage

```tsx
import { AlertBanner } from '@mezzanine-ui/react';
import { useState } from 'react';

function AlertBannerExample() {
  const [visible, setVisible] = useState(true);

  if (!visible) return null;

  return (
    <AlertBanner
      severity="info"
      message="This is an info notification"
      closable
      onClose={() => setVisible(false)}
    />
  );
}
```

### With Action Buttons

```tsx
<AlertBanner
  severity="warning"
  message="Your account is about to expire"
  actions={[
    {
      content: 'Renew Now',
      onClick: () => handleRenew(),
    },
    {
      content: 'Remind Later',
      onClick: () => handleRemindLater(),
    },
  ]}
/>
```

### Imperative Usage

```tsx
import { AlertBanner, Button } from '@mezzanine-ui/react';

// Shortcut methods
<Button onClick={() => AlertBanner.info('This is info')}>
  Info
</Button>

<Button onClick={() => AlertBanner.warning('Please note!')}>
  Warning
</Button>

<Button onClick={() => AlertBanner.error('An error occurred!')}>
  Error
</Button>
```

### Using add Method

```tsx
// Basic usage
AlertBanner.add({
  message: 'This is an alert message',
  severity: 'info',
});

// With action buttons
AlertBanner.add({
  message: 'System maintenance in progress',
  severity: 'warning',
  actions: [
    {
      content: 'Learn More',
      onClick: () => window.open('/maintenance'),
    },
  ],
});

// Non-closable
AlertBanner.add({
  message: 'Important notice',
  severity: 'error',
  closable: false,
});
```

### Alert with Key

```tsx
// Add alert with key
const key = AlertBanner.error('Error message', { key: 'error-alert' });

// Remove later
AlertBanner.remove(key);
```

### With Close Callback

```tsx
AlertBanner.add({
  message: 'About to close',
  severity: 'info',
  onClose: () => {
    console.log('Alert closed');
  },
});
```

### Destroy All Alerts

```tsx
AlertBanner.destroy();
```

---

## Internal Behavior

1. **Sorting rules**: When multiple AlertBanners are displayed simultaneously, non-`info` severity (`error`, `warning`) appears first; same priority sorted by creation time (newest first)
2. **Animation**: Entry/exit uses `isEntering` / `isExiting` state for animation management, exit animation lasts 250ms (moderate duration)
3. **Portal**: Renders in Portal `alert` level

---

## Figma Mapping

| Figma Variant                 | React Props                          |
| ----------------------------- | ------------------------------------ |
| `AlertBanner / Info`          | `severity="info"`                    |
| `AlertBanner / Warning`       | `severity="warning"`                 |
| `AlertBanner / Error`         | `severity="error"`                   |
| `AlertBanner / With Actions`  | `actions={[...]}`                    |
| `AlertBanner / Closable`      | `closable`                           |

---

## Best Practices

1. **Choose appropriate severity**: Select severity based on message importance
2. **Keep messages concise**: message should be short and clear
3. **Max 2 action buttons**: Avoid too many choices
4. **Error messages should not auto-close by default**: Give users enough time to read
5. **Component-based for fixed positions**: Use component-based for fixed page areas
6. **Imperative for global notifications**: Use imperative API for system-level notifications
