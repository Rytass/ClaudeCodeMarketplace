# Cropper

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/ng/cropper) · Verified 1.0.0-rc.3 (2026-04-21)
>
> **Storybook**: https://storybook-ng.mezzanine-ui.org/?path=/docs/media-cropper--docs

圖片裁切套件，提供 canvas 繪製裁切元件、Modal 包裝、Imperative API service，以及將裁切結果輸出為 Blob/DataURL/File 的工具函式。`MznCropper` 為語意化 shell directive；`MznCropperElement` 為核心互動元件；`MznCropperModal` 為包裝 Modal；`MznCropperModalService` 提供命令式呼叫。

## Import

```ts
import {
  MznCropper,
  MznCropperElement,
  MznCropperModal,
  MznCropperModalService,
  cropToBlob,
  cropToDataURL,
  cropToFile,
  loadImage,
} from '@mezzanine-ui/ng/cropper';
import type {
  CropArea,
  CropToBlobOptions,
  CropperPropsBase,
  CropperModalConfirmContext,
  CropperModalOpenOptions,
  CropperModalResult,
} from '@mezzanine-ui/ng/cropper';
import type { CropperSize } from '@mezzanine-ui/core/cropper';
// CropperSize: 'main' | 'sub'
```

## Selector

`<div mznCropper size="main">` — shell container directive

`<div mznCropperElement [imageSrc]="...">` — 核心裁切互動元件

`<div mznCropperModal [open]="..." [cropperProps]="...">` — Modal 包裝元件

## Inputs — MznCropper

| Input  | Type          | Default  | Description                          |
| ------ | ------------- | -------- | ------------------------------------ |
| `size` | `CropperSize` | `'main'` | `'main' \| 'sub'` — 元件尺寸        |

## Inputs — MznCropperElement

| Input             | Type                       | Default | Description                                               |
| ----------------- | -------------------------- | ------- | --------------------------------------------------------- |
| `imageSrc`        | `string \| File \| Blob`   | —       | 要裁切的圖片來源                                           |
| `initialCropArea` | `CropArea`                 | —       | 初始裁切區域（canvas 座標）                                |
| `aspectRatio`     | `number`                   | —       | 裁切區域長寬比（`width / height`）；未設定則自由比例        |
| `minWidth`        | `number`                   | `50`    | 裁切區域最小寬度（px）                                     |
| `minHeight`       | `number`                   | `50`    | 裁切區域最小高度（px）                                     |
| `size`            | `CropperSize`              | `'main'`| 元件尺寸，與外層 `MznCropper` 同步                         |

## Outputs — MznCropperElement

| Output        | Type                    | Description                                             |
| ------------- | ----------------------- | ------------------------------------------------------- |
| `cropChange`  | `output<CropArea>()`    | 裁切區域改變時觸發，回傳 image pixel 座標                |
| `cropDragEnd` | `output<CropArea>()`    | 裁切區域拖曳結束時觸發                                   |
| `imageDragEnd`| `output<void>()`        | 圖片拖曳（平移）結束時觸發                               |
| `imageLoad`   | `output<void>()`        | 圖片載入成功時觸發                                       |
| `imageError`  | `output<Error>()`       | 圖片載入失敗時觸發                                       |
| `scaleChange` | `output<number>()`      | 縮放倍率變更時觸發（Slider 或滑鼠滾輪）                  |

## Public Methods — MznCropperElement

| Method        | Return Type                   | Description                                             |
| ------------- | ----------------------------- | ------------------------------------------------------- |
| `getCanvas()` | `HTMLCanvasElement \| null`   | 取得底層 `<canvas>` 元素，供 `cropToBlob` 等工具函式使用 |

Imperative access via `@ViewChild`:

```ts
@ViewChild(MznCropperElement) cropperEl!: MznCropperElement;

const canvas = this.cropperEl.getCanvas();
```

## Inputs — MznCropperModal

| Input                           | Type                               | Default       | Description                                                     |
| ------------------------------- | ---------------------------------- | ------------- | --------------------------------------------------------------- |
| `open`                          | `boolean`                          | `false`       | 是否開啟 Modal                                                   |
| `title`                         | `string`                           | `'圖片裁切'`  | Modal 標題                                                       |
| `cropperProps`                  | `CropperPropsBase`                 | —             | 傳遞給內部 `MznCropperElement` 的 props                          |
| `loading`                       | `boolean`                          | `false`       | 確認按鈕的載入狀態                                               |
| `cancelText`                    | `string`                           | `'取消'`      | 取消按鈕文字                                                     |
| `confirmText`                   | `string`                           | `'確認'`      | 確認按鈕文字                                                     |
| `cropperContentClassName`       | `string \| undefined`              | —             | 附加到裁切內容容器的自訂 CSS class                               |
| `dialogStyle`                   | `Record<string, string> \| undefined` | —          | 套用在 Modal dialog 節點上的 inline style（可鎖定固定寬度）       |
| `showModalFooter`               | `boolean`                          | `true`        | 是否顯示底部操作列                                               |
| `showModalHeader`               | `boolean`                          | `true`        | 是否顯示標題列                                                   |
| `size`                          | `ModalSize`                        | `'wide'`      | Modal 尺寸：`'regular' \| 'large' \| 'wide'`                    |
| `supportingText`                | `string \| undefined`              | —             | 輔助說明文字                                                     |
| `disableCloseOnBackdropClick`   | `boolean`                          | `false`       | 禁用點擊遮罩關閉                                                 |
| `disableCloseOnEscapeKeyDown`   | `boolean`                          | `false`       | 禁用 Escape 鍵關閉                                               |
| `fullScreen`                    | `boolean`                          | `false`       | 全螢幕模式                                                       |

## Outputs — MznCropperModal

| Output        | Type                                          | Description                                            |
| ------------- | --------------------------------------------- | ------------------------------------------------------ |
| `confirmed`   | `output<CropperModalConfirmContext>()`         | 確認時回傳 `{ canvas, cropArea, imageSrc }`            |
| `cancelled`   | `output<void>()`                              | 點擊取消時觸發                                          |
| `closed`      | `output<void>()`                              | Modal 關閉時觸發（backdrop click / Escape）             |
| `cropChange`  | `output<CropArea>()`                          | 內部裁切區域變更時透傳                                  |
| `cropDragEnd` | `output<CropArea>()`                          | 裁切區域拖曳結束時透傳                                  |
| `imageDragEnd`| `output<void>()`                              | 圖片拖曳結束時透傳                                      |
| `imageLoad`   | `output<void>()`                              | 圖片載入成功時透傳                                      |
| `imageError`  | `output<Error>()`                             | 圖片載入失敗時透傳                                      |
| `scaleChange` | `output<number>()`                            | 縮放倍率變更時透傳                                      |

## CropArea 介面

| 欄位     | Type     | Description                        |
| -------- | -------- | ---------------------------------- |
| `x`      | `number` | 裁切區域左上角 x 座標（image px）   |
| `y`      | `number` | 裁切區域左上角 y 座標（image px）   |
| `width`  | `number` | 裁切區域寬度（image px）            |
| `height` | `number` | 裁切區域高度（image px）            |

## Usage

```html
<!-- 宣告式：shell + 裁切元件 -->
<div mznCropper size="main">
  <div
    mznCropperElement
    [imageSrc]="imageUrl()"
    [aspectRatio]="4 / 3"
    (cropChange)="currentCrop = $event"
  ></div>
</div>

<!-- Modal 宣告式 -->
<div
  mznCropperModal
  [open]="isOpen()"
  title="裁切頭像"
  [cropperProps]="{ imageSrc: avatarFile(), aspectRatio: 1 }"
  [loading]="isUploading()"
  (confirmed)="onConfirm($event)"
  (cancelled)="isOpen.set(false)"
  (closed)="isOpen.set(false)"
></div>
```

```ts
import { Component, inject, signal } from '@angular/core';
import {
  MznCropperModalService,
  cropToBlob,
  cropToDataURL,
  cropToFile,
} from '@mezzanine-ui/ng/cropper';
import type {
  CropperModalConfirmContext,
  CropToBlobOptions,
} from '@mezzanine-ui/ng/cropper';

// CropToBlobOptions fields:
// {
//   imageSrc: string | File | Blob;   // required
//   cropArea: CropArea;               // required
//   canvas?: HTMLCanvasElement;       // optional — provided from getCanvas()
//   format?: string;                  // default 'image/png'
//   quality?: number;                 // default 0.92 (jpeg/webp only)
//   outputWidth?: number;             // default: cropArea.width
//   outputHeight?: number;            // default: cropArea.height
// }

@Component({ /* ... */ })
export class AvatarUploadComponent {
  private readonly cropperModal = inject(MznCropperModalService);
  readonly isUploading = signal(false);

  async openCropper(file: File): Promise<void> {
    // MznCropperModalService.open() returns Promise<CropperModalResult | null>
    // null means the user cancelled or closed the modal without confirming
    const result = await this.cropperModal.open({
      title: '裁切頭像',
      cropperProps: { imageSrc: file, aspectRatio: 1, size: 'main' },
    });

    if (result) {
      const blob = await cropToBlob({
        imageSrc: file,
        cropArea: result.cropArea!,
        canvas: result.canvas ?? undefined,
        format: 'image/jpeg',
        quality: 0.9,
      });
      // upload blob...
    }
  }

  async onModalConfirm(ctx: CropperModalConfirmContext): Promise<void> {
    if (!ctx.cropArea) return;
    const dataUrl = await cropToDataURL({
      imageSrc: ctx.imageSrc!,
      cropArea: ctx.cropArea,
      canvas: ctx.canvas ?? undefined,
    });
    // use dataUrl...
  }
}
```

## Notes

- `MznCropperElement` 的 `cropChange` 回傳 image pixel 座標的 `CropArea`，可直接傳入 `cropToBlob({ imageSrc, cropArea })` 等工具函式。
- `cropToBlob`、`cropToDataURL`、`cropToFile` 全部接受單一 `CropToBlobOptions` 物件（**非**兩個位置參數），`imageSrc` 和 `cropArea` 為必填欄位。
- `cropToFile(options, filename)` 接受第二個位置參數 `filename: string`（回傳 `Promise<File>`）。
- 使用者只能拖曳平移圖片，裁切框本身不可 resize（固定由 `aspectRatio`/`initialCropArea` 決定）。
- `MznCropperModalService.open()` 回傳 `Promise<CropperModalResult | null>`；使用者取消或關閉時回傳 `null`（不是 `undefined`）。
- 不同於 React 版有 `<CropperModal>` 元件，Angular 版推薦優先使用 `MznCropperModalService` 的命令式 API。
- `CropperModalOpenOptions` 支援三個回呼欄位：`onCancel?: () => void`、`onClose?: () => void`、`onConfirm?: (context: CropperModalConfirmContext) => void | Promise<void>`。
