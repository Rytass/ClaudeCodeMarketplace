# Badge

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/ng/badge) · Verified 1.0.0-rc.3 (2026-04-21)
>
> **Storybook**: https://storybook-ng.mezzanine-ui.org/?path=/docs/data-display-badge--docs

徽章元件，用於顯示數字計數、狀態圓點或文字標籤。透過 `variant` 切換顯示模式：`count-*` 顯示數字、`dot-*` 顯示狀態圓點、`text-*` 顯示文字標籤。計數型徽章可設定 `overflowCount` 限制最大顯示數值；`count` 為 `0` 時徽章自動隱藏。

## Import

```ts
import { MznBadge } from '@mezzanine-ui/ng/badge';
import type {
  BadgeVariant,
  BadgeTextSize,
  BadgeCountVariant,
  BadgeDotVariant,
  BadgeTextVariant,
} from '@mezzanine-ui/ng/badge';
```

## Selector

`<div mznBadge variant="..." ...>` — component，selector 限定 `div[mznBadge]`（host element 必須為 `<div>`）

## Inputs

| Input           | Type                   | Default | Description                                                                                 |
| --------------- | ---------------------- | ------- | ------------------------------------------------------------------------------------------- |
| `variant`       | `BadgeVariant` (required) | —    | 視覺變體，見下方 BadgeVariant 說明                                                           |
| `count`         | `number`               | —       | 計數型徽章的數字（`count-*` 型 variant）                                                    |
| `overflowCount` | `number`               | —       | 計數上限；超過時顯示 `{overflowCount}+`                                                      |
| `size`          | `BadgeTextSize`        | —       | 文字型/圓點帶文字徽章的尺寸（`text-*` 和部分 `dot-*` 型）                                    |
| `text`          | `string`               | —       | 文字型徽章的顯示文字（`text-*` 型）                                                          |
| `className`     | `string`               | —       | 附加到內層 badge `<span>` 的自訂 CSS class                                                   |

> Inputs declared with signal API (`input()`, `input.required()`) accept both static and reactive values.

## BadgeVariant 說明

| 分類          | 可選值                                                                                              |
| ------------- | --------------------------------------------------------------------------------------------------- |
| 計數型        | `'count-alert'` / `'count-inactive'` / `'count-inverse'` / `'count-brand'` / `'count-info'`        |
| 圓點型        | `'dot-error'` / `'dot-warning'` / `'dot-success'` / `'dot-brand'` / `'dot-neutral'` 等             |
| 文字型        | `'text-success'` / `'text-warning'` / `'text-error'` / `'text-brand'` / `'text-neutral'` 等        |

## Sub-components / Exports

| Export              | Purpose                                                                        |
| ------------------- | ------------------------------------------------------------------------------ |
| `MznBadge`          | 主要徽章元件                                                                    |
| `MznBadgeContainer` | **已棄用**（`@deprecated`）；請改用 `MznBadge` 的 content projection 模式取代  |

## Usage

```html
<!-- 計數型徽章（單獨使用） -->
<div mznBadge variant="count-alert" [count]="5"></div>

<!-- 計數型徽章（含溢出上限） -->
<div mznBadge variant="count-brand" [count]="120" [overflowCount]="99"></div>

<!-- 圓點型徽章覆蓋在圖示上（content projection） -->
<div mznBadge variant="dot-error">
  <i mznIcon [icon]="BellIcon"></i>
</div>

<!-- 文字型徽章 -->
<div mznBadge variant="text-success" text="NEW"></div>

<!-- 與 Tab 搭配（計數為 0 時自動隱藏） -->
<div mznBadge variant="count-inactive" [count]="0"></div>
<!-- → 徽章不顯示 -->
```

```ts
import { Component, signal } from '@angular/core';
import { MznBadge } from '@mezzanine-ui/ng/badge';
import { BellIcon } from '@mezzanine-ui/icons';

@Component({
  selector: 'app-notification',
  imports: [MznBadge],
  template: `
    <div mznBadge variant="count-alert" [count]="unreadCount()"></div>
    <div mznBadge variant="dot-error">
      <i mznIcon [icon]="bellIcon"></i>
    </div>
  `,
})
export class NotificationComponent {
  readonly bellIcon = BellIcon;
  readonly unreadCount = signal(3);
}
```

## Notes

- 當投射了子元素時，徽章會以 `position: absolute` 覆疊方式出現在子元素右上角（`container` mode）；無子元素時，徽章為 `inline` 模式。是否有子元素由元件使用 `MutationObserver` 自動偵測，不需手動設定。
- `MznBadgeContainer` 已標記為 `@deprecated`，請改用 `<div mznBadge variant="dot-*">...</div>` 的 content projection 模式。
- 計數型 variant：`count` 為 `0` 時 badge 自動加上 `hide` class 不顯示；需要始終顯示零值時應改用文字型 variant。
- `text` input 僅在 `text-*` 型 variant 下生效；`count` input 僅在 `count-*` 型 variant 下生效。
