# Icon

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/ng/icon) · Verified 1.0.0-rc.4 (2026-04-24)
>
> **Storybook**: https://storybook-ng.mezzanine-ui.org/?path=/docs/foundation-icon--docs

渲染來自 `@mezzanine-ui/icons` 的 SVG 圖示元件。使用 attribute selector `[mznIcon]` 套用於 `<i>` 元素（對齊 React `<Icon>` 渲染為 `<i class="mzn-icon">` 的結構）。透過 `icon` input 傳入圖示定義物件，支援調整顏色、尺寸、旋轉動畫，以及無障礙 `title`。

## Import

```ts
import { MznIcon } from '@mezzanine-ui/ng/icon';
import type { IconColor } from '@mezzanine-ui/core/icon';
// 圖示從 @mezzanine-ui/icons 匯入：
import { SearchIcon, PlusIcon, LoadingIcon } from '@mezzanine-ui/icons';
import type { IconDefinition } from '@mezzanine-ui/icons';
```

## Selector

`<i mznIcon [icon]="SomeIcon">` — attribute-directive component，建議 host element 為 `<i>`

## Inputs

| Input       | Type              | Default | Description                                                       |
| ----------- | ----------------- | ------- | ----------------------------------------------------------------- |
| `icon`      | `IconDefinition` (required) | — | 來自 `@mezzanine-ui/icons` 的圖示定義物件                    |
| `color`     | `IconColor`       | —       | 語意色彩，對應 palette（如 `'success'`、`'error'`、`'warning'`）  |
| `size`      | `number`          | —       | 圖示尺寸（px）；設定後會覆蓋 CSS 預設大小                         |
| `spin`      | `boolean`         | `false` | 是否啟用旋轉動畫（用於載入中圖示）                                |
| `clickable` | `boolean`         | `false` | 設為 `true` 時游標顯示為 `pointer`                               |
| `title`     | `string`          | —       | 無障礙標題文字（注入 `<title>` 至 SVG）；未設定時使用圖示自帶 title |

> Inputs declared with signal API (`input()`, `input.required()`) accept both static and reactive values.

## Outputs

`MznIcon` 無 output 事件；點擊事件請在 host element 上使用 `(click)`。

## Usage

```html
<!-- 基本使用 -->
<i mznIcon [icon]="SearchIcon"></i>

<!-- 指定尺寸 -->
<i mznIcon [icon]="SearchIcon" [size]="24"></i>

<!-- 語意色彩 -->
<i mznIcon [icon]="CheckIcon" color="success"></i>
<i mznIcon [icon]="CloseIcon" color="error"></i>
<i mznIcon [icon]="WarningIcon" color="warning"></i>

<!-- 旋轉動畫（載入中） -->
<i mznIcon [icon]="LoadingIcon" [spin]="true"></i>

<!-- 可點擊圖示 -->
<i mznIcon [icon]="EditIcon" [clickable]="true" (click)="handleEdit()"></i>

<!-- 無障礙標題 -->
<i mznIcon [icon]="UserIcon" title="使用者" [size]="20"></i>

<!-- 在按鈕內使用（搭配 MznButton） -->
<button mznButton variant="base-primary" iconType="leading">
  <i mznIcon [icon]="PlusIcon" [size]="16"></i>
  新增
</button>
```

```ts
import { Component } from '@angular/core';
import { MznIcon } from '@mezzanine-ui/ng/icon';
import {
  SearchIcon,
  LoadingIcon,
  CheckIcon,
  PlusIcon,
} from '@mezzanine-ui/icons';
import type { IconDefinition } from '@mezzanine-ui/icons';

@Component({
  selector: 'app-icons-demo',
  imports: [MznIcon],
  template: `
    <i mznIcon [icon]="searchIcon" [size]="16"></i>
    <i mznIcon [icon]="loadingIcon" [spin]="isLoading" [size]="24"></i>
    <i mznIcon [icon]="checkIcon" color="success" [size]="20"></i>
  `,
})
export class IconsDemoComponent {
  readonly searchIcon: IconDefinition = SearchIcon;
  readonly loadingIcon: IconDefinition = LoadingIcon;
  readonly checkIcon: IconDefinition = CheckIcon;
  readonly isLoading = true;
}
```

## Notes

- `icon` input 是 `input.required<IconDefinition>()`，若未傳入圖示定義則會拋出 Angular signal 錯誤。
- `color` input 透過 `toIconCssVars()` 設定 `--mzn-icon-color` CSS 變數，僅控制顏色，不更改圖示 SVG 本身。
- `size` input 透過 CSS 變數 `--mzn-icon-size` 設定，以 `px` 為單位，傳入純數字即可（不需加 `px`）。
- `spin` 為 `true` 時加上旋轉 CSS class；適合配合 `LoadingIcon` 使用。
- `exportAs: 'mznIcon'` — 可用 `#iconRef="mznIcon"` 在模板中取得實例參考。
- 不同於 React `<Icon>` 接受 children 作為 accessible label，Angular 版透過 `title` input 注入 `<title>` 元素。
