# Spin

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/ng/spin) · Verified 1.0.0-rc.4 (2026-04-24)
>
> **Storybook**: https://storybook-ng.mezzanine-ui.org/?path=/docs/feedback-spin--docs

載入中旋轉指示器元件。透過 `loading` 控制顯示，支援 `size` 調整大小、`color`/`trackColor` 自訂弧線/軌道色彩，以及 `description` 顯示載入文字。使用 `<ng-content>` 投射子內容時，元件自動進入**巢狀模式**，以光照遮罩覆蓋子內容並將旋轉指示器置中顯示。

## Import

```ts
import { MznSpin } from '@mezzanine-ui/ng/spin';
import type { SpinBackdropProps } from '@mezzanine-ui/ng/spin';
import type { GeneralSize } from '@mezzanine-ui/system/size';
// GeneralSize: 'main' | 'sub' | 'minor'
```

## Selector

`<div mznSpin [loading]="isLoading">` — attribute-directive component

## Inputs

| Input                 | Type                | Default  | Description                                                                     |
| --------------------- | ------------------- | -------- | ------------------------------------------------------------------------------- |
| `loading`             | `boolean`           | `false`  | 是否顯示載入指示器                                                               |
| `size`                | `GeneralSize`       | `'main'` | `'main' \| 'sub' \| 'minor'` — 旋轉指示器大小                                  |
| `description`         | `string`            | —        | 載入描述文字，顯示於旋轉圈下方                                                   |
| `descriptionClassName`| `string`            | —        | 附加到描述文字元素的額外 CSS class                                               |
| `color`               | `string`            | —        | 自訂弧線動畫色彩（CSS 顏色值），設定 `--mzn-spin--color` CSS 變數               |
| `trackColor`          | `string`            | —        | 自訂軌道背景色彩（CSS 顏色值），設定 `--mzn-spin--track-color` CSS 變數          |
| `stretch`             | `boolean`           | `false`  | 是否伸展至容器的 100% 寬高（巢狀模式下常用）                                     |
| `backdropProps`       | `SpinBackdropProps` | `{}`     | 巢狀模式下的遮罩設定（預設禁用 scroll lock 和點擊關閉，使用 light variant）       |

> Inputs declared with signal API (`input()`) accept both static and reactive values.

## Outputs

`MznSpin` 無 output 事件。

## SpinBackdropProps 介面

| 欄位                        | Type              | Default  | Description                        |
| --------------------------- | ----------------- | -------- | ---------------------------------- |
| `class`                     | `string`          | —        | 套用在遮罩容器的 CSS class          |
| `disableCloseOnBackdropClick` | `boolean`       | `true`   | 禁用點擊遮罩關閉（巢狀模式預設禁用）|
| `disableScrollLock`         | `boolean`         | `true`   | 禁用 scroll lock（巢狀模式預設禁用）|
| `variant`                   | `BackdropVariant` | `'light'`| 遮罩顏色變體                        |

## Usage

```html
<!-- 獨立模式：直接顯示旋轉指示器 -->
<div mznSpin [loading]="true"></div>
<div mznSpin [loading]="isLoading" size="sub" description="載入中..."></div>

<!-- 自訂色彩 -->
<div mznSpin [loading]="true" color="#1890ff" trackColor="rgba(0,0,0,0.1)"></div>

<!-- 巢狀模式：以光照遮罩覆蓋子內容 -->
<div mznSpin [loading]="isLoading" description="處理中...">
  <div class="content-area" style="width: 400px; height: 300px;">
    <p>表單內容或資料表格...</p>
  </div>
</div>

<!-- 巢狀模式 + stretch（填滿容器） -->
<div style="position: relative; height: 200px;">
  <div mznSpin [loading]="isSaving" [stretch]="true" description="儲存中...">
    <div>Section content</div>
  </div>
</div>
```

```ts
import { Component, signal } from '@angular/core';
import { MznSpin } from '@mezzanine-ui/ng/spin';

@Component({
  selector: 'app-data-table',
  imports: [MznSpin],
  template: `
    <!-- 巢狀模式：table 載入時顯示遮罩 -->
    <div mznSpin [loading]="isLoading()" description="載入資料...">
      <table>
        <tbody>
          @for (row of rows(); track row.id) {
            <tr><td>{{ row.name }}</td></tr>
          }
        </tbody>
      </table>
    </div>

    <!-- 獨立模式：頁面全域載入指示器 -->
    @if (isPageLoading()) {
      <div
        mznSpin
        [loading]="true"
        size="main"
        description="頁面載入中..."
        style="position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%);"
      ></div>
    }
  `,
})
export class DataTableComponent {
  readonly isLoading = signal(false);
  readonly isPageLoading = signal(false);
  readonly rows = signal<Array<{ id: number; name: string }>>([]);
}
```

## Notes

- 元件在 `AfterContentInit` 時偵測是否有子內容（`<ng-content>`），自動切換獨立/巢狀模式，與 React 版 `children` 有無的路徑分岐邏輯一致。
- 巢狀模式使用 `MznBackdrop` 的 `light` variant（`disableScrollLock: true`、`disableCloseOnBackdropClick: true`）作為遮罩，預設行為不鎖定捲軸也不允許點擊關閉。
- `color` 和 `trackColor` 接受任意 CSS 顏色字串（hex、rgba、hsl 等），透過 CSS 變數注入，不需修改 SCSS。
- `size="minor"` 為最小尺寸，適合在按鈕或小型 UI 元件內使用（`MznButton` 的 `loading` 狀態即使用此尺寸）。
