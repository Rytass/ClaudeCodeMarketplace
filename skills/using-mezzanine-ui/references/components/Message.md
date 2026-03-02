# Message Component

> **Category**: Feedback
>
> **Storybook**: `Feedback/Message`
>
> **Source**: [GitHub Source Code](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/react/src/Message) | Verified: 2026-02-13

A global message notification component for displaying operation feedback, system notifications, and other lightweight messages. Uses an imperative API.

## Import

```tsx
import { Message } from '@mezzanine-ui/react';
import type { MessageData, MessageSeverity, MessageType } from '@mezzanine-ui/react';
```

---

## Message API

Message uses an imperative API; no element rendering is required.

### Basic Methods

| Method                | Description         |
| --------------------- | ------------------- |
| `Message.add(data)`   | Add a message       |
| `Message.remove(key)` | Remove a message    |
| `Message.destroy()`   | Clear all messages  |
| `Message.config(cfg)` | Set global config   |

### Shortcut Methods

| Method                              | Description     |
| ----------------------------------- | --------------- |
| `Message.success(content, props?)`  | Success message |
| `Message.warning(content, props?)`  | Warning message |
| `Message.error(content, props?)`    | Error message   |
| `Message.info(content, props?)`     | Info message    |
| `Message.loading(content, props?)`  | Loading message |

Shortcut methods return a `Key`, which can be used with `Message.remove(key)`.

---

## MessageData Type

Extends `Omit<NotifierData, 'onClose'>` and `MessageConfigProps` (including Translate transition props).

| Property      | Type                | Default | Description                                      |
| ------------- | ------------------- | ------- | ------------------------------------------------ |
| `children`    | `ReactNode`         | -       | Message content (inherited from NotifierData)    |
| `duration`    | `number \| false`   | `3000`  | Display time (ms); loading defaults to no auto-close |
| `icon`        | `IconDefinition`    | -       | Custom icon                                      |
| `reference`   | `Key`               | -       | Message identification key                       |
| `severity`    | `MessageSeverity`   | -       | Severity level                                   |
| `easing`      | `TranslateProps['easing']` | - | Transition easing                                |
| `from`        | `TranslateProps['from']`   | - | Transition direction                             |
| `onEnter`     | `() => void`        | -       | Enter transition start                           |
| `onEntering`  | `() => void`        | -       | Enter transition in progress                     |
| `onEntered`   | `() => void`        | -       | Enter transition complete                        |
| `onExit`      | `() => void`        | -       | Exit transition start                            |
| `onExiting`   | `() => void`        | -       | Exit transition in progress                      |
| `onExited`    | `(node: HTMLElement) => void` | - | Exit transition complete                     |

---

## MessageType Type

```tsx
type MessageType = FC<MessageData> &
  Notifier<MessageData, MessageConfigProps> &
  Record<
    string,
    (
      message: MessageData['children'],
      props?: Omit<MessageData, 'children' | 'severity' | 'icon'> & {
        key?: Key;
      },
    ) => Key
  >;
```

---

## MessageSeverity Type

| Severity  | Description | Default Icon        |
| --------- | ----------- | ------------------- |
| `success` | Success     | CheckedFilledIcon   |
| `warning` | Warning     | WarningFilledIcon   |
| `error`   | Error       | ErrorFilledIcon     |
| `info`    | Info        | InfoFilledIcon      |
| `loading` | Loading     | SpinnerIcon (spinning) |

---

## Usage Examples

### Shortcut Methods

```tsx
import { Message, Button } from '@mezzanine-ui/react';

// Success message
<Button onClick={() => Message.success('Operation successful!')}>
  Success
</Button>

// Warning message
<Button onClick={() => Message.warning('Please note!')}>
  Warning
</Button>

// Error message
<Button onClick={() => Message.error('Operation failed!')}>
  Error
</Button>

// Info message
<Button onClick={() => Message.info('This is information')}>
  Info
</Button>
```

### Loading Message

```tsx
function LoadingExample() {
  const handleClick = async () => {
    // Show loading (won't auto-close)
    const key = Message.loading('Loading...');

    try {
      await fetchData();
      Message.remove(key);
      Message.success('Loading complete!');
    } catch {
      Message.remove(key);
      Message.error('Loading failed!');
    }
  };

  return <Button onClick={handleClick}>Load Data</Button>;
}
```

### Using add Method

```tsx
// Basic usage
Message.add({
  children: 'This is message content',
  severity: 'info',
});

// Custom duration
Message.add({
  children: 'This message shows for 5 seconds',
  severity: 'success',
  duration: 5000,
});
```

### Message with Key

```tsx
// Add message with reference
Message.add({
  children: 'Message content',
  severity: 'success',
  reference: 'unique-key',
});

// Remove later
Message.remove('unique-key');
```

### Global Configuration

```tsx
// Set default duration
Message.config({
  duration: 5000,  // Default 3000
});
```

### Destroy All Messages

```tsx
// Clear all messages
Message.destroy();
```

### Custom Icon

```tsx
import { StarFilledIcon } from '@mezzanine-ui/icons';

Message.add({
  children: 'Message with custom icon',
  icon: StarFilledIcon,
});
```

### With Additional Config

```tsx
Message.success('Success message', {
  duration: 5000,
  reference: 'custom-key',
});
```

---

## Global Configuration Options

Set via `Message.config()`:

| Config     | Type     | Default | Description              |
| ---------- | -------- | ------- | ------------------------ |
| `duration` | `number` | `3000`  | Default display time (ms)|

> Note: `loading` severity does not auto-close by default. Maximum simultaneous display count is 4.

---

## Behavioral Characteristics

- Default `duration` is 3000ms (loading severity does not auto-close by default)
- Maximum simultaneous display count is 4
- Timer pauses/resumes on browser blur and mouse hover
- Animation effect slides in from below with fade in

---

## Figma Mapping

| Figma Variant         | React Method        |
| --------------------- | ------------------- |
| `Message / Success`   | `Message.success()` |
| `Message / Warning`   | `Message.warning()` |
| `Message / Error`     | `Message.error()`   |
| `Message / Info`      | `Message.info()`    |
| `Message / Loading`   | `Message.loading()` |

---

## Best Practices

1. **Choose appropriate type**: Select severity based on the message nature
2. **Keep it short**: Message content should be concise and clear
3. **Clean up loading**: `loading` messages must be manually removed
4. **Use Modal for important messages**: Messages requiring user confirmation should use Modal
