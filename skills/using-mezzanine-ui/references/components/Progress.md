# Progress Component

> **Category**: Feedback
>
> **Storybook**: `Feedback/Progress`
>
> **Source**: [GitHub Source Code](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/react/src/Progress)

A progress bar component for displaying operation completion progress.

## Import

```tsx
import { Progress } from '@mezzanine-ui/react';
import type { ProgressProps } from '@mezzanine-ui/react';
```

---

## Progress Props

| Property       | Type                                    | Default      | Description                      |
| -------------- | --------------------------------------- | ------------ | -------------------------------- |
| `icons`        | `{ error?: IconDefinition; success?: IconDefinition }` | -  | Custom error/success icons       |
| `percent`      | `number`                                | `0`          | Progress percentage (0-100)      |
| `percentProps` | `Omit<TypographyProps, 'className' \| 'children'>` | - | Percentage text props            |
| `status`       | `'enabled' \| 'success' \| 'error'`     | Auto-detect  | Force set status                 |
| `tick`         | `number`                                | `0`          | Tick mark position (0-100)       |
| `type`         | `'progress' \| 'percent' \| 'icon'`     | `'progress'` | Display type                     |

---

## ProgressType

| Type       | Description             | Right Side Display       |
| ---------- | ----------------------- | ------------------------ |
| `progress` | Progress bar only       | No additional display    |
| `percent`  | Progress bar + percent  | Shows `XX%` number       |
| `icon`     | Progress bar + icon     | Shows icon on success/error |

---

## ProgressStatus

| Status    | Description              | Auto-detect Condition    |
| --------- | ------------------------ | ------------------------ |
| `enabled` | In progress (default green) | `percent < 100`       |
| `success` | Success (green + icon)   | `percent >= 100`         |
| `error`   | Error (red + icon)       | Must be set manually     |

---

## Usage Examples

### Basic Progress Bar

```tsx
import { Progress } from '@mezzanine-ui/react';

<Progress percent={30} />
<Progress percent={60} />
<Progress percent={100} />
```

### Show Percentage

```tsx
<Progress percent={45} type="percent" />
// Shows "45%"
```

### With Status Icon

```tsx
// In progress
<Progress percent={60} type="icon" />

// Success
<Progress percent={100} type="icon" status="success" />

// Error
<Progress percent={60} type="icon" status="error" />
```

### With Tick Mark

```tsx
// Show tick at 75% position
<Progress percent={50} tick={75} />
```

### Custom Icons

```tsx
import { CheckedFilledIcon, DangerousFilledIcon } from '@mezzanine-ui/icons';

<Progress
  percent={100}
  type="icon"
  status="success"
  icons={{
    success: CheckedFilledIcon,
    error: DangerousFilledIcon,
  }}
/>
```

### Dynamic Update

```tsx
function UploadProgress() {
  const [percent, setPercent] = useState(0);
  const [status, setStatus] = useState<'enabled' | 'success' | 'error'>('enabled');

  const handleUpload = async () => {
    setStatus('enabled');

    for (let i = 0; i <= 100; i += 10) {
      await delay(100);
      setPercent(i);
    }

    setStatus('success');
  };

  return (
    <>
      <Progress percent={percent} type="icon" status={status} />
      <Button onClick={handleUpload}>Start Upload</Button>
    </>
  );
}
```

### Error State

```tsx
function DownloadProgress() {
  const [percent, setPercent] = useState(60);
  const [status, setStatus] = useState<'enabled' | 'error'>('error');

  return (
    <Progress
      percent={percent}
      type="icon"
      status={status}
    />
  );
}
```

---

## Figma Mapping

| Figma Variant                | React Props                              |
| ---------------------------- | ---------------------------------------- |
| `Progress / Default`         | `type="progress"`                        |
| `Progress / With Percent`    | `type="percent"`                         |
| `Progress / With Icon`       | `type="icon"`                            |
| `Progress / Success`         | `status="success"`                       |
| `Progress / Error`           | `status="error"`                         |
| `Progress / With Tick`       | `tick={75}`                              |

---

## Best Practices

1. **Choose appropriate type**: Use `progress` for simple scenarios, `percent` when numbers are needed
2. **Auto status detection**: When `status` is not specified, it is automatically determined by percent
3. **Error state must be set manually**: Error state requires explicit `status="error"`
4. **Smooth animation**: CSS provides automatic transition animation when percent updates
5. **Tick marks**: Use `tick` to mark targets or milestones
