# Notifier / createNotifier

> **Category**: Utility
>
> **Storybook**: `Utility/Notifier`
>
> **Source Verification**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/react/src/Notifier)

Notifier factory function for creating custom notification systems. It is the underlying implementation of Message, NotificationCenter, and other components.

## Import

```tsx
import { createNotifier } from '@mezzanine-ui/react';
import type {
  Notifier,
  NotifierConfig,
  NotifierData,
  RenderNotifier,
  CreateNotifierProps,
} from '@mezzanine-ui/react';
```

---

## createNotifier Parameters

| Parameter         | Type                                                      | Description                |
| ----------------- | --------------------------------------------------------- | -------------------------- |
| `config`          | `C extends NotifierConfig`                                | Custom notifier config     |
| `duration`        | `number \| false`                                         | Default display time (ms)  |
| `maxCount`        | `number`                                                  | Max visible count          |
| `render`          | `(notifier: N & { key: Key }) => ReactNode`               | Notification render fn     |
| `renderContainer` | `(children: ReactNode) => ReactNode`                      | Container render fn        |
| `setRoot`         | `(root: HTMLDivElement) => void`                          | Set root element attributes|
| `sortBeforeUpdate`| `(notifiers: (N & { key: Key })[]) => (N & { key: Key })[]` | Sort function           |

---

## Notifier Return Object

| Method       | Type                                  | Description                    |
| ------------ | ------------------------------------- | ------------------------------ |
| `add`        | `(notifier: N & { key?: Key }) => Key`| Add a notification             |
| `remove`     | `(key: Key) => void`                  | Remove a specific notification |
| `destroy`    | `() => void`                          | Remove all and destroy         |
| `config`     | `(config: C) => void`                 | Update configuration           |
| `getConfig`  | `() => C`                             | Get current configuration      |

---

## NotifierData

```tsx
interface NotifierData extends Pick<NotifierConfig, 'duration'> {
  children?: ReactNode;
  // duration is inherited from Pick<NotifierConfig, 'duration'>, type is number | false
  onClose?: (key: Key) => void;
}
```

---

## Usage Examples

### Create a Custom Notifier

```tsx
import { createNotifier } from '@mezzanine-ui/react';

interface MyNotificationData {
  key?: number;
  title: string;
  message: string;
  type: 'success' | 'error' | 'info';
  duration?: number | false;
  onClose?: (key: number) => void;
}

const MyNotification = createNotifier<MyNotificationData>({
  duration: 3000,
  maxCount: 5,
  render: (notifier) => (
    <div className={`notification notification--${notifier.type}`}>
      <h4>{notifier.title}</h4>
      <p>{notifier.message}</p>
      <button onClick={() => notifier.onClose?.(notifier.key)}>Close</button>
    </div>
  ),
  setRoot: (root) => {
    root.className = 'my-notification-container';
  },
});

// Usage
MyNotification.add({
  title: 'Success',
  message: 'Operation completed',
  type: 'success',
});
```

### With Container Render

```tsx
const AlertBannerNotifier = createNotifier<AlertBannerData>({
  duration: false,
  render: (notifier) => (
    <AlertBanner
      severity={notifier.severity}
      onClose={() => notifier.onClose?.(notifier.key)}
    >
      {notifier.message}
    </AlertBanner>
  ),
  renderContainer: (children) => (
    <div className="alert-banner-container">
      {children}
    </div>
  ),
});
```

### Custom Sorting

```tsx
const PriorityNotifier = createNotifier<PriorityNotificationData>({
  render: (notifier) => (
    <Notification {...notifier} onClose={() => notifier.onClose?.(notifier.key)} />
  ),
  sortBeforeUpdate: (notifiers) => {
    return notifiers.sort((a, b) => b.priority - a.priority);
  },
});
```

### Update Configuration

```tsx
// Create notifier
const Notification = createNotifier<NotificationData>({
  duration: 3000,
  render: (notifier) => (
    <NotificationUI {...notifier} onClose={() => notifier.onClose?.(notifier.key)} />
  ),
});

// Update default duration
Notification.config({ duration: 5000 });

// Get current configuration
const currentConfig = Notification.getConfig();
```

### Manually Remove Notifications

```tsx
// Get key when adding
const key = Notification.add({
  title: 'Processing',
  message: 'Please wait...',
  duration: false, // No auto-close
});

// Manually remove after completion
await someAsyncOperation();
Notification.remove(key);
```

### Destroy Notifier

```tsx
// Destroy on component unmount
useEffect(() => {
  return () => {
    Notification.destroy();
  };
}, []);
```

---

## Message and NotificationCenter Implementation

```tsx
// Message internal implementation (similar to)
const Message = createNotifier<MessageData>({
  duration: 3000,
  maxCount: 4,
  render: (message) => (
    <Message {...message} reference={message.key} key={undefined} />
  ),
  setRoot: (root) => {
    root?.setAttribute('class', classes.root);
  },
});

// NotificationCenter internal implementation (similar to)
// Note: Visible count is not controlled by createNotifier's maxCount,
// but by NotificationData's maxVisibleNotifications prop (default 3).
// renderContainer uses NotificationCenterContainer to truncate visible notifications.
const NotificationCenter = createNotifier<NotificationData>({
  duration: false,
  render: (notif) => (
    <NotificationCenter {...notif} reference={notif.key} key={notif.key} />
  ),
  renderContainer: (children) => (
    <NotificationCenterContainer>{children}</NotificationCenterContainer>
  ),
  setRoot: (root) => {
    root?.setAttribute('class', classes.root);
  },
});
```

---

## Sugar Method Pattern

```tsx
// Add sugar methods to Notifier
const Message = createNotifier<MessageData>({
  render: (notifier) => (
    <MessageUI {...notifier} onClose={() => notifier.onClose?.(notifier.key)} />
  ),
});

// Add success, error, etc. methods
const MessageWithSugar = {
  ...Message,
  success: (message: string) => Message.add({ message, severity: 'success' }),
  error: (message: string) => Message.add({ message, severity: 'error' }),
  warning: (message: string) => Message.add({ message, severity: 'warning' }),
  info: (message: string) => Message.add({ message, severity: 'info' }),
};

// Usage
MessageWithSugar.success('Operation successful!');
```

---

## Figma Mapping

Notifier is a pure functional factory with no corresponding visual element in Figma. The rendered content is determined by the `render` function.

---

## Best Practices

1. **Use existing components**: Generally use Message or NotificationCenter instead of createNotifier directly
2. **Appropriate duration**: Set duration based on message importance
3. **Limit count**: Use maxCount to avoid too many notifications
4. **Cleanup on destroy**: Call destroy() on component unmount to clean up resources
5. **Sorting strategy**: Use sortBeforeUpdate to prioritize important notifications
