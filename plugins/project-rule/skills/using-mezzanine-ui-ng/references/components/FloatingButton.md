# FloatingButton

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/ng/floating-button) · Verified 1.0.0-rc.3 (2026-04-21)
>
> **Storybook**: https://storybook-ng.mezzanine-ui.org/?path=/docs/navigation-floating-button--docs

浮動按鈕元件，固定於畫面角落的主要操作按鈕容器。內部封裝一顆 `MznButton`（強制 `variant="base-primary"`、`size="main"`、`tooltipPosition="left"`），提供 `autoHideWhenOpen` 機制在展開狀態時自動隱藏。

## Import

```ts
import { MznFloatingButton } from '@mezzanine-ui/ng/floating-button';
import type { ButtonIconType } from '@mezzanine-ui/core/button';
// ButtonIconType: 'leading' | 'trailing' | 'icon-only'
```

## Selector

`<div mznFloatingButton [icon]="SomeIcon">` — attribute-directive component，host element 通常為 `<div>`（對齊 React 結構）

## Inputs

| Input              | Type             | Default | Description                                                               |
| ------------------ | ---------------- | ------- | ------------------------------------------------------------------------- |
| `icon`             | `IconDefinition` | —       | 按鈕圖示定義（來自 `@mezzanine-ui/icons`）                                 |
| `iconType`         | `ButtonIconType` | —       | `'leading'`（圖示在左）/ `'trailing'`（圖示在右）/ `'icon-only'`（僅圖示）|
| `disabled`         | `boolean`        | `false` | 是否禁用內部按鈕                                                           |
| `disabledTooltip`  | `boolean`        | `false` | 是否禁用 `icon-only` 模式的自動 tooltip                                    |
| `loading`          | `boolean`        | `false` | 是否顯示載入狀態                                                           |
| `open`             | `boolean`        | `false` | 是否為展開狀態（搭配 `autoHideWhenOpen` 使用）                             |
| `autoHideWhenOpen` | `boolean`        | `false` | 設為 `true` 時，`open` 為 `true` 的情況下自動隱藏按鈕                      |

> Inputs declared with signal API (`input()`) accept both static and reactive values.

## Outputs

`MznFloatingButton` 無 output 事件；請直接在 host element 上使用 `(click)` 原生事件。

## Usage

```html
<!-- 固定於畫面右下角 -->
<div
  mznFloatingButton
  [icon]="PlusIcon"
  iconType="leading"
  style="position: fixed; bottom: 24px; right: 24px; z-index: 100;"
  (click)="openCreateDialog()"
>
  新增
</div>

<!-- 僅圖示（icon-only 模式） -->
<div
  mznFloatingButton
  iconType="icon-only"
  [icon]="PlusIcon"
  style="position: fixed; bottom: 24px; right: 24px;"
  (click)="toggle()"
>
</div>

<!-- 與展開面板搭配（展開時自動隱藏） -->
<div
  mznFloatingButton
  [icon]="PlusIcon"
  iconType="leading"
  [open]="isPanelOpen()"
  [autoHideWhenOpen]="true"
  style="position: fixed; bottom: 24px; right: 24px;"
  (click)="isPanelOpen.set(true)"
>
  操作
</div>
```

```ts
import { Component, signal } from '@angular/core';
import { MznFloatingButton } from '@mezzanine-ui/ng/floating-button';
import { PlusIcon } from '@mezzanine-ui/icons';
import type { IconDefinition } from '@mezzanine-ui/icons';

@Component({
  selector: 'app-page',
  imports: [MznFloatingButton],
  template: `
    <div
      mznFloatingButton
      [icon]="plusIcon"
      iconType="leading"
      [loading]="isCreating()"
      style="position: fixed; bottom: 24px; right: 24px; z-index: 200;"
      (click)="createItem()"
    >
      新增
    </div>
  `,
})
export class PageComponent {
  readonly plusIcon: IconDefinition = PlusIcon;
  readonly isCreating = signal(false);

  async createItem(): Promise<void> {
    this.isCreating.set(true);
    // await...
    this.isCreating.set(false);
  }
}
```

## Notes

- 內部按鈕強制使用 `variant="base-primary"` 和 `size="main"`，不支援透過 input 覆蓋；如需其他 variant，請改用標準 `MznButton`。
- `iconType="icon-only"` 時，hover 會在左側（`tooltipPosition="left"`）顯示 tooltip，與 React 版一致。
- 浮動按鈕的定位（`position: fixed`、`z-index`）需由外部 CSS 控制，元件本身不預設絕對位置。
- 不同於 React 版的 `<FloatingButton>` 直接渲染 `<button>`，Angular 版的 host element 為 `<div>`，內部才有 `<button mznButton>`。
