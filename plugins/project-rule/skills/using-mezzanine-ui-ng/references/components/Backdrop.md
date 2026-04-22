# Backdrop

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/ng/backdrop) · Verified 1.0.0-rc.3 (2026-04-21)
>
> **Storybook**: https://storybook-ng.mezzanine-ui.org/?path=/docs/overlay-backdrop--docs

全螢幕遮罩元件，常用於 Modal、Drawer 等覆蓋式 UI 的底層。支援深色/淺色變體，自動鎖定 body 捲軸，並透過 `MznPortal` 渲染至全域容器。點擊遮罩區域時觸發 `backdropClick` 事件；可選擇禁用點擊關閉行為。

## Import

```ts
import { MznBackdrop } from '@mezzanine-ui/ng/backdrop';
import type { BackdropVariant } from '@mezzanine-ui/core/backdrop';
// BackdropVariant = 'dark' | 'light'
```

## Selector

`<div mznBackdrop [open]="isOpen">` — attribute-directive component，host element 通常為 `<div>`

## Inputs

| Input                          | Type                                       | Default  | Description                                                              |
| ------------------------------ | ------------------------------------------ | -------- | ------------------------------------------------------------------------ |
| `open`                         | `boolean`                                  | `false`  | 是否開啟遮罩；控制淡入/淡出動畫與 scroll lock                            |
| `variant`                      | `BackdropVariant`                          | `'dark'` | `'dark' \| 'light'` — 遮罩顏色變體                                      |
| `disableScrollLock`            | `boolean`                                  | `false`  | 設為 `true` 時不鎖定 body 捲軸                                           |
| `disableCloseOnBackdropClick`  | `boolean`                                  | `false`  | 設為 `true` 時點擊遮罩不觸發 `closed` 事件                              |
| `disablePortal`                | `boolean`                                  | `false`  | 設為 `true` 時內容渲染在原位，不 portal 至全域容器                       |
| `container`                    | `HTMLElement \| ElementRef<HTMLElement> \| null` | `null` | 自訂 Portal 目標容器；未設定時使用全域 portal 容器（`body` 底下）       |

> Inputs declared with signal API (`input()`) accept both static and reactive values.

## Outputs

| Output          | Type                     | Description                                     |
| --------------- | ------------------------ | ----------------------------------------------- |
| `backdropClick` | `OutputEmitterRef<void>` | 點擊遮罩背景時觸發（無論是否禁用關閉行為）       |
| `closed`        | `OutputEmitterRef<void>` | 點擊遮罩且未禁用 `disableCloseOnBackdropClick` 時觸發 |

## Usage

```html
<!-- 基本遮罩覆蓋 Modal -->
<div mznBackdrop [open]="isModalOpen" (closed)="closeModal()">
  <div class="my-modal">
    <h2>Modal 標題</h2>
    <p>Modal 內容</p>
    <button (click)="closeModal()">關閉</button>
  </div>
</div>

<!-- 淺色遮罩 + 禁用點擊關閉（例如非同步載入時） -->
<div
  mznBackdrop
  variant="light"
  [open]="isLoading"
  [disableCloseOnBackdropClick]="true"
>
  <div class="loading-spinner">載入中...</div>
</div>

<!-- 限縮於特定容器的遮罩 -->
<div #containerRef style="position: relative;">
  <div
    mznBackdrop
    [open]="isSectionLoading"
    [container]="containerRef"
    [disableScrollLock]="true"
  >
  </div>
  <div>Section 內容</div>
</div>
```

```ts
import { Component, signal, ElementRef, viewChild } from '@angular/core';
import { MznBackdrop } from '@mezzanine-ui/ng/backdrop';

@Component({
  selector: 'app-modal',
  imports: [MznBackdrop],
  template: `...`,
})
export class ModalComponent {
  readonly isOpen = signal(false);

  openModal(): void {
    this.isOpen.set(true);
  }

  closeModal(): void {
    this.isOpen.set(false);
  }
}
```

## Notes

- `MznBackdrop` 本身即為內容容器（`<ng-content />`），子元素會渲染在遮罩之上的 `.mzn-backdrop__content` 區塊中。
- scroll lock 由 `ScrollLockService` 管理，`DestroyRef.onDestroy` 時自動解鎖，避免元件銷毀後 body 永久鎖定。
- 淡入/淡出動畫由內層 `MznFade` directive 處理，不需要額外配置。
- 設定 `container` 可讓遮罩限縮在特定區塊而非全螢幕，結合 `position: relative` 的父容器使用。
- 不同於 React 版的 `open` prop 直接控制，Angular 版使用 signal input，支援 signal 和靜態值雙向綁定。
