# Icon Component

> **Category**: Foundation
>
> **Storybook**: `Foundation/Icon`
>
> **Source**: [GitHub Source Code](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/react/src/Icon) · Verified 1.10.2 (2026-11-22)

An icon component for displaying SVG icons provided by `@mezzanine-ui/icons`.

## Import

```tsx
import { Icon } from '@mezzanine-ui/react';
import type { IconProps, IconColor } from '@mezzanine-ui/react';

// Icons are imported from the icons package
import { PlusIcon, SearchIcon, SpinnerIcon } from '@mezzanine-ui/icons';
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/foundation-icon--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## Icon Props

`IconProps` extends native `<i>` element props (excluding `key` and `ref`).

| Property | Type             | Default | Description                                              |
| -------- | ---------------- | ------- | -------------------------------------------------------- |
| `icon`   | `IconDefinition` | -       | Required, icon definition (from `@mezzanine-ui/icons`)   |
| `color`  | `IconColor`      | -       | Icon color                                               |
| `size`   | `number`         | -       | Icon size (px)                                           |
| `spin`   | `boolean`        | `false` | Whether to apply spin animation                          |
| `title`  | `string`         | -       | Accessibility title                                      |

> In addition to the above, all native HTML attributes of `<i>` element (e.g., `onClick`, `className`, `style`) are accepted.
> When `onClick` or `onMouseOver` is present, cursor is automatically set to `pointer`.

---

## IconColor Type

```ts
type IconColor = 'inherit' | IconTone;
```

Semantic icon colors based on the design token system. `IconTone` comes from `@mezzanine-ui/system/palette`.

### Neutral

| Color                  | Description     |
| ---------------------- | --------------- |
| `inherit`              | Inherit parent  |
| `fixed-light`     | Fixed light     |
| `neutral-faint`   | Extra faint     |
| `neutral-light`   | Light icon      |
| `neutral`         | Standard icon   |
| `neutral-strong`  | Strong icon     |
| `neutral-bold`    | Bold icon       |
| `neutral-solid`   | Solid icon      |

### Brand

| Color                | Description       |
| -------------------- | ----------------- |
| `brand`         | Brand color icon  |
| `brand-strong`  | Brand strong icon |
| `brand-solid`   | Brand solid icon  |

### Semantic

| Color                  | Description     |
| ---------------------- | --------------- |
| `error`           | Error icon      |
| `error-strong`    | Error strong    |
| `error-solid`     | Error solid     |
| `warning`         | Warning icon    |
| `warning-strong`  | Warning strong  |
| `success`         | Success icon    |
| `success-strong`  | Success strong  |
| `info`            | Info icon       |
| `info-strong`     | Info strong     |

> `IconColor` values are `'inherit'` or `IconTone` (no `icon-` prefix).
> For example, `color="neutral-strong"` maps to CSS variable `--mzn-color-semantic-icon-neutral-strong`.

---

## Usage Examples

### Basic Usage

```tsx
import { Icon } from '@mezzanine-ui/react';
import { PlusIcon, SearchIcon, HomeIcon } from '@mezzanine-ui/icons';

<Icon icon={PlusIcon} />
<Icon icon={SearchIcon} />
<Icon icon={HomeIcon} />
```

### Specifying Size

```tsx
<Icon icon={PlusIcon} size={16} />
<Icon icon={PlusIcon} size={24} />
<Icon icon={PlusIcon} size={32} />
```

### Specifying Color

```tsx
<Icon icon={CheckedFilledIcon} color="success" />
<Icon icon={ErrorFilledIcon} color="error" />
<Icon icon={WarningFilledIcon} color="warning" />
<Icon icon={InfoFilledIcon} color="brand" />
```

### Spin Animation

```tsx
import { SpinnerIcon } from '@mezzanine-ui/icons';

// For loading indication
<Icon icon={SpinnerIcon} spin />

// With size
<Icon icon={SpinnerIcon} spin size={24} />
```

### Accessibility Title

```tsx
<Icon icon={SearchIcon} title="Search" />
<Icon icon={HomeIcon} title="Home" />
```

### Clickable Icon

```tsx
<Icon
  icon={CloseIcon}
  onClick={() => handleClose()}
/>
```

---

## Icon Categories

Icons are categorized by function in `@mezzanine-ui/icons`:

| Category    | Description | Common Icons                               |
| ----------- | ----------- | ------------------------------------------ |
| `system/`   | System      | `MenuIcon`, `SearchIcon`, `UserIcon`       |
| `arrow/`    | Arrow       | `ChevronDownIcon`, `CaretRightIcon`        |
| `controls/` | Controls    | `PlusIcon`, `MinusIcon`, `CloseIcon`       |
| `alert/`    | Alert       | `CheckedFilledIcon`, `ErrorFilledIcon`     |
| `content/`  | Content     | `EditIcon`, `CopyIcon`, `DownloadIcon`     |
| `stepper/`  | Stepper     | `Item0Icon` ~ `Item9Icon`                  |

See [ICONS.md](../ICONS.md) for a complete icon list.

---

## Usage in Other Components

### Button with Icon

```tsx
import { Button } from '@mezzanine-ui/react';
import { PlusIcon } from '@mezzanine-ui/icons';

<Button icon={PlusIcon} iconType="leading">Add</Button>
<Button icon={PlusIcon} iconType="icon-only">Add</Button>
```

### TextField with Icon

```tsx
import { Icon, Input, TextField } from '@mezzanine-ui/react';
import { SearchIcon, CloseIcon } from '@mezzanine-ui/icons';

<TextField
  prefix={<Icon icon={SearchIcon} size={16} />}
  suffix={<Icon icon={CloseIcon} size={16} />}
>
  <Input placeholder="Search" />
</TextField>
```

### Status Indicator

```tsx
import { Icon, type IconColor } from '@mezzanine-ui/react';
import {
  CheckedFilledIcon,
  ErrorFilledIcon,
  WarningFilledIcon,
  type IconDefinition,
} from '@mezzanine-ui/icons';

function StatusIcon({ status }: { status: 'success' | 'error' | 'warning' }) {
  const iconMap: Record<'success' | 'error' | 'warning', { icon: IconDefinition; color: IconColor }> = {
    success: { icon: CheckedFilledIcon, color: 'success' },
    error: { icon: ErrorFilledIcon, color: 'error' },
    warning: { icon: WarningFilledIcon, color: 'warning' },
  };

  const { icon, color } = iconMap[status];
  return <Icon icon={icon} color={color} />;
}
```

---

## Figma Mapping

Figma icon nodes use `/` separated paths, corresponding to React import names:

| Figma Node                       | React Import         |
| -------------------------------- | -------------------- |
| `Icons / System / Search`        | `SearchIcon`         |
| `Icons / Controls / Plus`        | `PlusIcon`           |
| `Icons / Arrow / Chevron Down`   | `ChevronDownIcon`    |
| `Icons / Alert / Checked-Filled` | `CheckedFilledIcon`  |

---

## Best Practices

### 場景推薦

| 使用場景 | 建議方案 | 說明 |
| ------- | ------- | ---- |
| 按鈕內圖標 | `size={16}` | 按鈕內的輔助圖標，使用 16px |
| 表單標籤旁 | `size={16}` | 訊息提示、警告等小圖標 |
| 獨立圖標按鈕 | `size={24}` | 點擊操作的圖標，視覺上更突出 |
| 狀態指示器 | `size={32}` + 語義色 | 成功/失敗/警告等狀態 |
| 載入動畫 | `spin` + `SpinnerIcon` | 長時間操作的視覺反饋 |
| 導航圖標 | `color="inherit"` | 繼承父層顏色，適合導航列 |

### 常見錯誤

1. **只依靠圖標傳達資訊**
   - ❌ 錯誤：`<Icon icon={TrashIcon} />`（使用者不知道是什麼功能）
   - ✅ 正確：`<Button icon={TrashIcon}>Delete</Button>` 或加上 title 屬性

2. **未指定語義化顏色**
   - ❌ 錯誤：`<Icon icon={ErrorFilledIcon} />`（顏色不明顯）
   - ✅ 正確：`<Icon icon={ErrorFilledIcon} color="error-solid" />`

3. **圖標尺寸不一致**
   - ❌ 錯誤：不同位置使用不同 size，導致視覺雜亂
   - ✅ 正確：統一相同位置的圖標尺寸，如按鈕內都用 16px

4. **spin 動畫濫用**
   - ❌ 錯誤：在非載入狀態使用 `spin`
   - ✅ 正確：只在 `loading` 狀態使用 `spin` 屬性

5. **未提供無障礙標題**
   - ❌ 錯誤：`<Icon icon={SearchIcon} onClick={handleSearch} />`（螢幕閱讀器無法理解）
   - ✅ 正確：`<Icon icon={SearchIcon} title="Search" onClick={handleSearch} />`

### 實作建議

1. **使用語義化顏色**：確保顏色傳達正確的含義
2. **設定適當尺寸**：根據上下文調整大小，保持層級感
3. **提供無障礙標題**：重要的圖標應添加 `title` 屬性
4. **避免只依靠圖標**：搭配文字或 tooltip 傳達完整資訊
5. **載入動畫用 SpinnerIcon**：`<Icon icon={SpinnerIcon} spin />` 為標準做法
