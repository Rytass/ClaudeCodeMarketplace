# NotificationCenter

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/ng/notification-center) · Verified 1.0.0-rc.3 (2026-04-21)

Per-item notification component (`MznNotificationCenter`) and drawer container (`MznNotificationCenterDrawer`). The item component supports two rendering modes: `type='notification'` (floating toast with slide-in animation) and `type='drawer'` (list item in a notification drawer with timestamp and dropdown actions).

## Import

```ts
import {
  MznNotificationCenter,
  MznNotificationCenterContainer,
  MznNotificationCenterDrawer,
} from '@mezzanine-ui/ng/notification-center';

import type { NotificationItem, NotificationSeverity, NotificationType } from '@mezzanine-ui/ng/notification-center';
import type { DropdownOption } from '@mezzanine-ui/core/dropdown';
```

## Selectors

| Selector                                | Role                                               |
| --------------------------------------- | -------------------------------------------------- |
| `[mznNotificationCenter]`               | Single notification item (toast or drawer item)    |
| `[mznNotificationCenterContainer]`      | Toast stack container with overflow "view all" button |
| `[mznNotificationCenterDrawer]`         | Drawer wrapper for a list of notifications         |

## MznNotificationCenter — Inputs

| Input                 | Type                          | Default           | Description                                               |
| --------------------- | ----------------------------- | ----------------- | --------------------------------------------------------- |
| `title`               | `string`                      | `''`              | Notification heading                                      |
| `description`         | `string`                      | `''`              | Body text                                                 |
| `severity`            | `NotificationSeverity`        | `'info'`          | `'info' \| 'success' \| 'warning' \| 'error'`            |
| `type`                | `NotificationType`            | `'notification'`  | `'notification'` (floating) or `'drawer'` (list item)     |
| `from`                | `'right' \| 'top'`            | `'top'`           | Slide-in direction (notification mode only)               |
| `duration`            | `number \| false`             | `false`           | Auto-close delay; `false` = persistent                    |
| `showConfirmButton`   | `boolean`                     | `false`           | Show confirm/action button                                |
| `confirmButtonText`   | `string`                      | `'Confirm'`       | Confirm button label                                      |
| `showCancelButton`    | `boolean`                     | `false`           | Show cancel button                                        |
| `cancelButtonText`    | `string`                      | `'Cancel'`        | Cancel button label                                       |
| `timeStamp`           | `string \| number \| Date`    | `new Date()`      | Notification timestamp                                    |
| `timeStampLocale`     | `string`                      | `'zh-TW'`         | Locale for timestamp formatting                           |
| `showBadge`           | `boolean`                     | `false`           | Show badge indicator                                      |
| `options`             | `ReadonlyArray<DropdownOption>` | `[]`             | Dropdown menu options (drawer mode)                       |
| `appendTips`          | `string \| undefined`         | —                 | Appended tip text in footer                               |
| `prependTips`         | `string \| undefined`         | —                 | Prepended tip text in footer                              |
| `reference`           | `string \| number \| undefined` | —               | Unique identifier emitted in `closed`                     |

> Inputs declared with signal API (`input()`, `model()`) accept both static and reactive values.

## MznNotificationCenter — Outputs

| Output          | Type                                       | Description                                |
| --------------- | ------------------------------------------ | ------------------------------------------ |
| `confirmed`     | `OutputEmitterRef<void>`                   | Confirm button clicked                     |
| `cancelled`     | `OutputEmitterRef<void>`                   | Cancel button clicked                      |
| `closed`        | `OutputEmitterRef<string \| number \| undefined>` | Dismiss; emits `reference`          |
| `badgeClicked`  | `OutputEmitterRef<void>`                   | Badge icon clicked                         |
| `badgeSelected` | `OutputEmitterRef<DropdownOption>`         | Dropdown option selected                   |

## MznNotificationCenterContainer — Inputs

Selector: `[mznNotificationCenterContainer]`

Renders a fixed-position toast stack. When `items.length > maxVisibleNotifications` a "查看更多" button is displayed. The actual toast markup is defined by the consumer via a `<ng-template #itemTemplate let-item>` content child.

| Input                      | Type                                                | Default    | Description                                              |
| -------------------------- | --------------------------------------------------- | ---------- | -------------------------------------------------------- |
| `items`                    | `ReadonlyArray<T>` (**required**)                   | —          | Toast items; `T` must have an optional `key?: string \| number` field |
| `maxVisibleNotifications`  | `number`                                            | `3`        | Maximum toasts shown before the overflow button appears  |
| `viewAllButtonText`        | `string`                                            | `'查看更多'` | Label for the overflow button                           |

| Output           | Type                      | Description                                        |
| ---------------- | ------------------------- | -------------------------------------------------- |
| `viewAllClicked` | `OutputEmitterRef<void>`  | Fired when the overflow button is clicked; typically clears toasts and opens the drawer |

**Template pattern:**

```html
<div mznNotificationCenterContainer
  [items]="toasts()"
  (viewAllClicked)="onViewAll()"
>
  <ng-template #itemTemplate let-item>
    <div mznNotificationCenter
      type="notification"
      [severity]="item.severity"
      [title]="item.title"
      [reference]="item.key"
      (closed)="remove($event)"
    ></div>
  </ng-template>
</div>
```

## MznNotificationCenterDrawer — Inputs

| Input                           | Type                                     | Default                    | Description                                             |
| ------------------------------- | ---------------------------------------- | -------------------------- | ------------------------------------------------------- |
| `open`                          | `boolean`                                | `false`                    | Controls drawer visibility                              |
| `title`                         | `string \| undefined`                    | —                          | Drawer header title                                     |
| `notificationList`              | `ReadonlyArray<NotificationItem>`        | —                          | When provided, the drawer auto-groups items by time     |
| `drawerSize`                    | `DrawerSize`                             | `'narrow'`                 | Drawer width                                            |
| `todayLabel`                    | `string`                                 | `'今天'`                   | Time-group label for today's notifications              |
| `yesterdayLabel`                | `string`                                 | `'昨天'`                   | Time-group label for yesterday's notifications          |
| `past7DaysLabel`                | `string`                                 | `'過去七天'`               | Time-group label for past 7 days                        |
| `earlierLabel`                  | `string`                                 | `'更早'`                   | Time-group label for older notifications                |
| `emptyNotificationTitle`        | `string`                                 | `'目前沒有新的通知'`       | Empty state heading                                     |
| `emptyNotificationDescription`  | `string`                                 | `'當有新的系統通知時，將會顯示在這裡。'` | Empty state body text           |
| `filterBarShow`                 | `boolean`                                | `false`                    | Show the filter bar above the notification list         |
| `filterBarDefaultValue`         | `string \| undefined`                    | —                          | Default radio value for filter bar                      |
| `filterBarValue`                | `string \| undefined`                    | —                          | Controlled radio value for filter bar                   |
| `filterBarAllRadioLabel`        | `string \| undefined`                    | —                          | Label for "All" radio option                            |
| `filterBarReadRadioLabel`       | `string \| undefined`                    | —                          | Label for "Read" radio option                           |
| `filterBarUnreadRadioLabel`     | `string \| undefined`                    | —                          | Label for "Unread" radio option                         |
| `filterBarShowUnreadButton`     | `boolean`                                | `false`                    | Show the custom unread action button                    |
| `filterBarCustomButtonLabel`    | `string \| undefined`                    | —                          | Label for the custom action button (e.g. "全部已讀")   |
| `filterBarOptions`              | `ReadonlyArray<DropdownOption> \| undefined` | —                       | Extra dropdown options in the filter bar                |

## MznNotificationCenterDrawer — Outputs

| Output                        | Type                               | Description                                 |
| ----------------------------- | ---------------------------------- | ------------------------------------------- |
| `closed`                      | `OutputEmitterRef<void>`           | Drawer closed (backdrop or X button)        |
| `filterBarOnRadioChange`      | `OutputEmitterRef<string>`         | Filter bar radio selection changed          |
| `filterBarOnCustomButtonClick`| `OutputEmitterRef<void>`           | Filter bar custom button clicked            |
| `filterBarOnSelect`           | `OutputEmitterRef<DropdownOption>` | Filter bar dropdown option selected         |

## NotificationItem interface

`NotificationItem` is the canonical data shape for items passed to `[notificationList]`. Import it from `@mezzanine-ui/ng/notification-center`.

| Field                  | Type                               | Notes                                                                 |
| ---------------------- | ---------------------------------- | --------------------------------------------------------------------- |
| `key`                  | `string \| number \| undefined`    | Unique identifier; preferred over deprecated `id`                    |
| `type`                 | `NotificationType \| undefined`    | `'drawer' \| 'notification'`; default `'drawer'`                     |
| `severity`             | `NotificationSeverity \| undefined` | `'info' \| 'success' \| 'warning' \| 'error'`; default `'info'`    |
| `title`                | `string \| undefined`              | Notification heading                                                  |
| `description`          | `string \| undefined`              | Body text                                                             |
| `confirmButtonText`    | `string \| undefined`              | Confirm button label (shown when `showConfirmButton` is set on item)  |
| `cancelButtonText`     | `string \| undefined`              | Cancel button label                                                   |
| `timeStamp`            | `string \| number \| Date \| undefined` | Timestamp for grouping and display                               |
| `timeStampLocale`      | `string \| undefined`              | Locale for formatting `timeStamp`; default `'zh-TW'`                 |
| `prependTips`          | `string \| undefined`              | Group label injected above the first item in each time group         |
| `appendTips`           | `string \| undefined`              | Footnote text below the item                                         |
| `showBadge`            | `boolean \| undefined`             | Show badge dot on the drawer item's action button                    |
| `options`              | `ReadonlyArray<DropdownOption> \| undefined` | Per-item dropdown menu options                             |
| `id` (**deprecated**)  | `string \| undefined`              | Legacy field; use `key` instead                                      |
| `timestamp` (**deprecated**) | `Date \| undefined`          | Legacy field; use `timeStamp` instead                                |
| `read` (**deprecated**) | `boolean \| undefined`            | Legacy field; no longer used internally                              |

## Service API

There is no dedicated `MznNotificationCenterService`. Manage the list yourself and iterate with `@for`.

## ControlValueAccessor

No.

## Usage

```html
<!-- Floating notification toast -->
<div mznNotificationCenter
  type="notification"
  severity="success"
  title="部署成功"
  description="Build #42 已上線。"
  from="right"
  [duration]="5000"
  [reference]="notif.key"
  (closed)="dismiss($event)"
></div>

<!-- Notification drawer with list of items -->
<div mznNotificationCenterDrawer
  [open]="isDrawerOpen"
  title="通知中心"
  (closed)="isDrawerOpen = false"
>
  @for (notif of notifications; track notif.key) {
    <div mznNotificationCenter
      type="drawer"
      [title]="notif.title"
      [description]="notif.description"
      [severity]="notif.severity"
      [timeStamp]="notif.timestamp"
      [showConfirmButton]="true"
      confirmButtonText="查看"
      [reference]="notif.key"
      (confirmed)="viewNotification(notif)"
      (closed)="dismissNotification($event)"
    ></div>
  }
</div>
```

```ts
import { MznNotificationCenter, MznNotificationCenterDrawer } from '@mezzanine-ui/ng/notification-center';

notifications: readonly Notification[] = [];
isDrawerOpen = false;

dismissNotification(key: string | number | undefined): void {
  if (key == null) return;
  this.notifications = this.notifications.filter((n) => n.key !== String(key));
}
```

## Notes

- `type='notification'` uses a slide + fade animation driven by an internal state machine (similar to `MznAccordion`). When `duration` is a number, the item auto-dismisses after that delay.
- Timestamp hover shows a popper with full date/time formatted by `timeStampLocale`.
- The drawer mode shows an overflow `mznDropdown` when `options` is non-empty, useful for per-item actions like "Mark as read" or "Delete".
- Unlike React's `NotificationCenter` which has a companion service/context, Angular manages the notification list externally. Use a signal-based store or service to maintain the list.
