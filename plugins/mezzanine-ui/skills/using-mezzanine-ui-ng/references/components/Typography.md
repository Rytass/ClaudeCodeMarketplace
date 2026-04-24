# Typography

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/ng/typography) · Verified 1.0.0-rc.4 (2026-04-24)
>
> **Storybook**: https://storybook-ng.mezzanine-ui.org/?path=/docs/foundation-typography--docs

文字排版 directive，提供一致的語意化文字樣式。使用 attribute selector `[mznTypography]`，可套用於任意 HTML 元素，透過 `variant` 套用設計系統中定義的語意排版類型（如 `h1`、`body`、`caption` 等）。支援 `color`、`align`、`display` 等 CSS 變數控制，以及 `ellipsis` 單行截斷。

## Import

```ts
import { MznTypography } from '@mezzanine-ui/ng/typography';
import type {
  TypographyAlign,
  TypographyColor,
  TypographyDisplay,
  TypographySemanticType,
} from '@mezzanine-ui/ng/typography';
// TypographySemanticType 常用值（非完整清單）：
// 'h1' | 'h2' | 'h3' | 'h4' | 'h5' | 'h6'
// 'body' | 'body-highlight'
// 'caption' | 'caption-highlight'
// 'label-primary' | 'label-primary-highlight'
// 'label-secondary' | 'label-secondary-highlight'
// 'input' | 'title' 等
```

## Selector

`<h1 mznTypography variant="h1">` — attribute directive，可套用於任意 HTML 元素

## Inputs

| Input      | Type                    | Default  | Description                                                            |
| ---------- | ----------------------- | -------- | ---------------------------------------------------------------------- |
| `variant`  | `TypographySemanticType`| `'body'` | 語意排版類型，對應設計系統中的文字樣式                                  |
| `color`    | `TypographyColor`       | —        | 語意色彩，設定 `--mzn-typography-color` CSS 變數                       |
| `align`    | `TypographyAlign`       | —        | CSS `text-align` 值，設定 `--mzn-typography-align` CSS 變數            |
| `display`  | `TypographyDisplay`     | —        | CSS `display` 值，設定 `--mzn-typography-display` CSS 變數             |
| `ellipsis` | `boolean`               | `false`  | 啟用單行截斷省略號（需搭配 `block`/`inline-block` 容器）               |
| `noWrap`   | `boolean`               | `false`  | 禁止文字換行（等效於 CSS `white-space: nowrap`）                        |

> Inputs declared with signal API (`input()`) accept both static and reactive values.

## Outputs

`MznTypography` 無 output 事件。

## TypographySemanticType 常用對照

| Variant                      | 適用場景                        |
| ---------------------------- | ------------------------------- |
| `'h1'` ~ `'h6'`              | 頁面各級標題                     |
| `'body'`                     | 一般正文                         |
| `'body-highlight'`           | 強調正文（通常加粗）              |
| `'caption'`                  | 說明文字、標籤                    |
| `'caption-highlight'`        | 強調說明文字                      |
| `'label-primary'`            | 主要標籤（如按鈕文字）            |
| `'label-primary-highlight'`  | 強調主要標籤                      |
| `'label-secondary'`          | 次要標籤（如次要按鈕文字）        |
| `'input'`                    | 輸入框文字                        |
| `'title'`                    | 標題欄文字                        |

## Usage

```html
<!-- 標題 -->
<h1 mznTypography variant="h1">頁面主標題</h1>
<h2 mznTypography variant="h2">區塊標題</h2>

<!-- 正文 -->
<p mznTypography variant="body">這是一段說明文字，描述功能的詳細內容。</p>
<p mznTypography variant="body-highlight">這段文字較為重要，以加粗呈現。</p>

<!-- 說明標籤 -->
<span mznTypography variant="caption" color="text-secondary">最後更新：2026-04-21</span>
<span mznTypography variant="caption-highlight" color="text-warning">注意事項</span>

<!-- 文字截斷 -->
<span
  mznTypography
  variant="body"
  [ellipsis]="true"
  style="max-width: 200px; display: block;"
>
  這是一段很長的文字，超出寬度後會自動以省略號截斷
</span>

<!-- 對齊 -->
<p mznTypography variant="caption" align="center">置中對齊的說明文字</p>
<p mznTypography variant="caption" align="right">靠右對齊</p>

<!-- 禁止換行 -->
<span mznTypography variant="label-secondary" [noWrap]="true">不換行的標籤文字</span>
```

```ts
import { Component, signal } from '@angular/core';
import { MznTypography } from '@mezzanine-ui/ng/typography';
import type { TypographyColor } from '@mezzanine-ui/ng/typography';

@Component({
  selector: 'app-status-badge',
  imports: [MznTypography],
  template: `
    <span mznTypography variant="caption" [color]="statusColor()">
      {{ statusText() }}
    </span>
  `,
})
export class StatusBadgeComponent {
  readonly status = signal<'success' | 'error' | 'warning'>('success');

  readonly statusColor = (): TypographyColor => {
    const map: Record<string, TypographyColor> = {
      success: 'text-success',
      error: 'text-error',
      warning: 'text-warning',
    };
    return map[this.status()] ?? 'text-primary';
  };

  readonly statusText = (): string => {
    const map: Record<string, string> = {
      success: '正常',
      error: '異常',
      warning: '警告',
    };
    return map[this.status()] ?? '';
  };
}
```

## Notes

- `MznTypography` 是一個純 directive（`Directive`，非 `Component`），不包含任何模板或 DOM 結構，僅新增 CSS class 和 CSS 變數到 host element 上。
- `color`、`align`、`display` 透過 `toTypographyCssVars()` 設定 CSS 變數，而非直接修改 `style` 屬性；需要 Mezzanine CSS 的 `--mzn-typography-*` 變數定義才能生效。
- `ellipsis` 需要搭配外部容器的 `max-width` 和 `display: block`（或 `inline-block`）才能正常截斷，否則 `overflow: hidden` 沒有觸發條件。
- 不同於 React `<Typography component="h1">` 使用 `component` prop 決定 DOM 標籤，Angular 版直接將 directive 套用在正確語意標籤上（`<h1 mznTypography>`）。
- `TypographySemanticType` 從 `@mezzanine-ui/system/typography` 匯出，涵蓋所有設計系統定義的語意類型。
