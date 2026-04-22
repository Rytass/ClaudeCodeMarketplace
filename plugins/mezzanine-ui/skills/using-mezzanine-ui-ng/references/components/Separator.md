# Separator

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/ng/separator) · Verified 1.0.0-rc.3 (2026-04-21)
>
> **Storybook**: https://storybook-ng.mezzanine-ui.org/?path=/docs/layout-separator--docs

水平或垂直分隔線元件。透過 `orientation` 切換方向；垂直方向時自動設置 `aria-orientation="vertical"` 以符合無障礙規範。

## Import

```ts
import { MznSeparator } from '@mezzanine-ui/ng/separator';
import type { SeparatorOrientation } from '@mezzanine-ui/core/separator';
// SeparatorOrientation: 'horizontal' | 'vertical'
```

## Selector

`<hr mznSeparator>` — attribute-directive component，建議 host element 為 `<hr>` 以符合語意

## Inputs

| Input         | Type                   | Default        | Description                                            |
| ------------- | ---------------------- | -------------- | ------------------------------------------------------ |
| `orientation` | `SeparatorOrientation` | `'horizontal'` | `'horizontal' \| 'vertical'` — 分隔線方向              |

> Inputs declared with signal API (`input()`) accept both static and reactive values.

## Outputs

`MznSeparator` 無 output 事件。

## Usage

```html
<!-- 水平分隔線（預設） -->
<hr mznSeparator />

<!-- 垂直分隔線 -->
<hr mznSeparator orientation="vertical" />

<!-- 在表單區段間使用 -->
<section>
  <h3>基本資料</h3>
  <div mznFormGroup title="...">...</div>
</section>
<hr mznSeparator />
<section>
  <h3>進階設定</h3>
  <div mznFormGroup title="...">...</div>
</section>

<!-- 在導航列中垂直分隔 -->
<nav style="display: flex; align-items: center; gap: 8px;">
  <a href="/home">首頁</a>
  <hr mznSeparator orientation="vertical" style="height: 16px;" />
  <a href="/about">關於</a>
</nav>
```

```ts
import { Component } from '@angular/core';
import { MznSeparator } from '@mezzanine-ui/ng/separator';

@Component({
  selector: 'app-settings',
  imports: [MznSeparator],
  template: `
    <section>
      <h3>個人資訊</h3>
      <!-- form fields -->
    </section>
    <hr mznSeparator />
    <section>
      <h3>帳號設定</h3>
      <!-- form fields -->
    </section>
    <hr mznSeparator />
    <section>
      <h3>通知偏好</h3>
      <!-- form fields -->
    </section>
  `,
})
export class SettingsComponent {}
```

## Notes

- 元件帶有 `role="separator"` 且垂直方向時加入 `aria-orientation="vertical"`，符合 ARIA 規範。
- `<hr>` 作為 host element 語意最正確；若需要 inline 垂直分隔可改用 `<span mznSeparator>`。
- 元件本身不帶任何尺寸樣式，高度（垂直）或寬度（水平）需由外部 CSS 或 Flexbox 容器控制。
- 不同於 React 版可透過 className 完全自訂，Angular 版目前不接受自訂 CSS class input；如需額外樣式，請在 host element 上直接加 class。
