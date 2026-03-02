# NotificationCenter Component

> **Category**: Feedback
>
> **Storybook**: `Feedback/Notification Center`
>
> **Source Verification**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/react/src/NotificationCenter)

Notification center component for displaying global notifications. Supports both popup notification and drawer list modes.

## Import

```tsx
import { NotificationCenter } from '@mezzanine-ui/react';
import type { NotificationData, NotificationSeverity } from '@mezzanine-ui/react';

// NotificationCenterDrawer is not exported from '@mezzanine-ui/react' main entry; must be imported from sub-path
import { NotificationCenterDrawer } from '@mezzanine-ui/react/NotificationCenter';
import type {
  NotificationCenterDrawerProps,
  NotificationConfigProps,
} from '@mezzanine-ui/react/NotificationCenter';
```

---

## API Methods

| Method                          | Description                    |
| ------------------------------- | ------------------------------ |
| `NotificationCenter.add(data)`  | Add a notification             |
| `NotificationCenter.remove(key)`| Remove a specific notification |
| `NotificationCenter.destroy()`  | Remove all notifications       |
| `NotificationCenter.config(cfg)`| Set global configuration       |
| `NotificationCenter.success()`  | Success notification (sugar)   |
| `NotificationCenter.warning()`  | Warning notification (sugar)   |
| `NotificationCenter.error()`    | Error notification (sugar)     |
| `NotificationCenter.info()`     | Info notification (sugar)      |

---

## NotificationData Props

Extends `NotifierData` (`children`, `onClose`, `duration`) and `NotificationConfigProps` (`onViewAll`, `viewAllButtonText`, and other Slide transition props).

| Property                     | Type                                    | Default           | Description                                 |
| ---------------------------- | --------------------------------------- | ----------------- | ------------------------------------------- |
| `children`                   | `ReactNode`                             | -                 | Notification content (inherited from NotifierData) |
| `appendTips`                 | `string`                                | -                 | Append tips (drawer mode)                   |
| `cancelButtonProps`          | `ButtonProps`                           | -                 | Cancel button props                         |
| `cancelButtonText`           | `string`                                | `'Cancel'`        | Cancel button text                          |
| `confirmButtonProps`         | `ButtonProps`                           | -                 | Confirm button props                        |
| `confirmButtonText`          | `string`                                | `'Confirm'`       | Confirm button text                         |
| `description`                | `string`                                | -                 | Notification description                    |
| `duration`                   | `number \| false`                       | `false`           | Auto-close time (ms); `false` means no auto-close |
| `maxVisibleNotifications`    | `number`                                | `3`               | Max visible count (notification mode only)  |
| `onBadgeClick`               | `() => void`                            | -                 | Badge click (drawer mode)                   |
| `onBadgeSelect`              | `(option: DropdownOption) => void`      | -                 | Badge select (drawer mode)                  |
| `onCancel`                   | `() => void`                            | -                 | Cancel callback                             |
| `onClose`                    | `(key: Key) => void`                    | -                 | Close callback                              |
| `onConfirm`                  | `() => void`                            | -                 | Confirm callback                            |
| `onViewAll`                  | `() => void`                            | -                 | View all callback                           |
| `options`                    | `DropdownOption[]`                      | -                 | Dropdown options (drawer mode)              |
| `prependTips`                | `string`                                | -                 | Prepend tips (drawer mode)                  |
| `reference`                  | `Key`                                   | -                 | Notification identifier key                 |
| `severity`                   | `NotificationSeverity`                  | `'info'`          | Severity level                              |
| `showBadge`                  | `boolean`                               | -                 | Show badge (drawer mode)                    |
| `timeStamp`                  | `string \| number`                      | Current time      | Timestamp                                   |
| `timeStampLocale`            | `string`                                | `'zh-TW'`         | Timestamp locale                            |
| `title`                      | `string`                                | -                 | Notification title                          |
| `type`                       | `NotificationType`                      | `'notification'`  | Notification type: `'notification'` / `'drawer'` |
| `viewAllButtonText`          | `string`                                | `'View More'`     | View all button text                        |

---

## NotificationSeverity

```tsx
type NotificationSeverity = 'success' | 'warning' | 'error' | 'info';
```

---

## Usage Examples

### Basic Usage

```tsx
import { NotificationCenter, Button } from '@mezzanine-ui/react';

function App() {
  const handleClick = () => {
    NotificationCenter.add({
      title: 'Notification Title',
      description: 'This is the notification content',
      severity: 'info',
    });
  };

  return <Button onClick={handleClick}>Show Notification</Button>;
}
```

### Using Sugar Methods

```tsx
// Success notification
NotificationCenter.success({
  title: 'Operation Successful',
  description: 'Data has been saved',
});

// Warning notification
NotificationCenter.warning({
  title: 'Attention',
  description: 'This operation may be risky',
});

// Error notification
NotificationCenter.error({
  title: 'Error',
  description: 'Operation failed, please try again',
});

// Info notification
NotificationCenter.info({
  title: 'Notice',
  description: 'A new version has been released',
});
```

### Auto-close

```tsx
NotificationCenter.success({
  title: 'Operation Successful',
  description: 'Auto-closes in 3 seconds',
  duration: 3000,
});
```

### With Action Buttons

```tsx
NotificationCenter.add({
  title: 'Confirm Delete',
  description: 'Are you sure you want to delete this item?',
  severity: 'warning',
  confirmButtonText: 'Confirm',
  cancelButtonText: 'Cancel',
  onConfirm: () => {
    // Execute delete
  },
  onCancel: () => {
    // Cancel operation
  },
});
```

### Global Configuration

```tsx
// Set default duration
NotificationCenter.config({
  duration: 5000,
});
```

### Drawer Mode

```tsx
// For displaying notification lists
const notifications = [
  {
    type: 'drawer' as const,
    title: 'New Message',
    description: 'You have a new message',
    timeStamp: new Date().toISOString(),
    showBadge: true,
    options: [
      { id: 'mark-read', name: 'Mark as Read' },
      { id: 'delete', name: 'Delete' },
    ],
    onBadgeSelect: (option) => {
      console.log('Selected:', option);
    },
  },
];
```

### Limit Visible Count

```tsx
NotificationCenter.add({
  title: 'Notification',
  description: 'Shows "View More" when exceeding 3',
  maxVisibleNotifications: 3,
  onViewAll: () => {
    // Navigate to notification list page
    router.push('/notifications');
  },
});
```

### Remove Notifications

```tsx
// Get key when adding
const key = NotificationCenter.success({
  title: 'Processing',
  description: 'Please wait...',
  duration: false,
});

// Remove later
NotificationCenter.remove(key);

// Remove all
NotificationCenter.destroy();
```

---

## NotificationCenterDrawer

Notification list drawer component that displays notifications in a Drawer format. Groups by time (Today, Yesterday, Past 7 Days, Earlier).

### Props

| Property                         | Type                                     | Default                    | Description                                    |
| -------------------------------- | ---------------------------------------- | -------------------------- | ---------------------------------------------- |
| `children`                       | `ReactElement[]`                         | -                          | Manually pass NotificationCenter elements      |
| `notificationList`               | `NotificationDataForDrawer[]`            | -                          | Notification data list (mutually exclusive with children) |
| `drawerSize`                     | `DrawerSize`                             | `'narrow'`                 | Drawer size                                    |
| `title`                          | `string`                                 | -                          | Drawer title                                   |
| `open`                           | `boolean`                                | -                          | Whether open                                   |
| `onClose`                        | `() => void`                             | -                          | Close callback                                 |
| `todayLabel`                     | `string`                                 | `'Today'`                  | Today group label                              |
| `yesterdayLabel`                  | `string`                                 | `'Yesterday'`              | Yesterday group label                          |
| `past7DaysLabel`                 | `string`                                 | `'Past 7 Days'`            | Past 7 days group label                        |
| `earlierLabel`                   | `string`                                 | `'Earlier'`                | Earlier group label                            |
| `emptyNotificationIcon`          | `IconDefinition`                         | `NotificationIcon`         | Empty notification icon                        |
| `emptyNotificationTitle`         | `string`                                 | `'No new notifications'`   | Empty notification text                        |
| `controlBarShow`                 | `boolean`                                | -                          | Whether to show control bar                    |
| `controlBarDefaultValue`         | `string`                                 | -                          | Control bar default value                      |
| `controlBarValue`                | `string`                                 | -                          | Control bar controlled value                   |
| `controlBarOnRadioChange`        | `(value: string) => void`                | -                          | Radio change callback                          |
| `controlBarAllRadioLabel`        | `string`                                 | -                          | All radio label                                |
| `controlBarReadRadioLabel`       | `string`                                 | -                          | Read radio label                               |
| `controlBarUnreadRadioLabel`     | `string`                                 | -                          | Unread radio label                             |
| `controlBarShowUnreadButton`     | `boolean`                                | -                          | Whether to show unread button                  |
| `controlBarCustomButtonLabel`    | `string`                                 | -                          | Custom button label                            |
| `controlBarOnCustomButtonClick`  | `() => void`                             | -                          | Custom button callback                         |
| `renderControlBar`               | `(props) => ReactNode`                   | -                          | Custom control bar render                      |

---

## Differences from Message

| Feature      | NotificationCenter     | Message               |
| ------------ | ---------------------- | --------------------- |
| Position     | Top-right              | Top-center            |
| Content      | Title + Description    | Message only          |
| Action Buttons | Supported            | Not supported         |
| Use Case     | Complex notifications, requiring confirmation | Simple tips |
| Duration     | No auto-close by default | Auto-close by default |
| Animation    | Slide in               | Slide in              |

---

## Figma Mapping

| Figma Variant                       | React Props                              |
| ----------------------------------- | ---------------------------------------- |
| `Notification / Success`            | `severity="success"`                     |
| `Notification / Warning`            | `severity="warning"`                     |
| `Notification / Error`              | `severity="error"`                       |
| `Notification / Info`               | `severity="info"` (default)              |
| `Notification / With Actions`       | `onConfirm` has value                    |
| `Notification / Drawer`             | `type="drawer"`                          |

---

## Best Practices

1. **Appropriate severity**: Choose severity based on message importance
2. **Concise title**: Title should be short and clear
3. **Auto-close**: Set `duration` for non-critical notifications
4. **Action buttons**: Provide onConfirm/onCancel when user confirmation is needed
5. **Limit count**: Use `maxVisibleNotifications` to avoid screen clutter
