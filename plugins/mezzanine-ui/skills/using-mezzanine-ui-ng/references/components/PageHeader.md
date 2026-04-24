# PageHeader

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/ng/page-header) · Verified 1.0.0-rc.4 (2026-04-24)
>
> **Storybook**: https://storybook-ng.mezzanine-ui.org/?path=/docs/layout-page-header--docs

頁面標頭容器，組合 `MznBreadcrumb` 與 `MznContentHeader` 的包裝元件。`MznPageHeader` 本身是一個極簡的 shell component，不接受任何 inputs，僅提供語意化 `role="banner"`、`class="mzn-page-header"` 以及 `<ng-content>` 插槽供子元件填入。

## Import

```ts
import { MznPageHeader } from '@mezzanine-ui/ng/page-header';
// 通常配合以下元件一起使用：
import { MznBreadcrumb } from '@mezzanine-ui/ng/breadcrumb';
// MznContentHeader 來自 content-header 套件（若有使用）
```

## Selector

`<header mznPageHeader>` — attribute-directive component，建議 host element 為 `<header>`

## Inputs

`MznPageHeader` 無任何 inputs。

## Outputs

`MznPageHeader` 無任何 outputs。

## Usage

```html
<!-- 組合 Breadcrumb + ContentHeader -->
<header mznPageHeader>
  <nav
    mznBreadcrumb
    [items]="breadcrumbItems()"
    aria-label="Breadcrumb"
  ></nav>
  <header mznContentHeader
    title="商品管理"
    description="管理系統中的所有商品資料"
  >
    <div actions>
      <button mznButton variant="base-primary" (click)="createProduct()">
        新增商品
      </button>
    </div>
  </header>
</header>

<!-- 頁腳通常配合 MznPageFooter 一起使用 -->
<div class="page-layout">
  <header mznPageHeader>
    <nav mznBreadcrumb [items]="breadcrumb()"></nav>
  </header>

  <main class="page-content">
    <!-- 頁面主體 -->
  </main>

  <div mznPageFooter type="standard" supportingActionName="取消">
    <div actions>
      <button mznButton variant="base-primary" (click)="save()">儲存</button>
    </div>
  </div>
</div>
```

```ts
import { Component, signal } from '@angular/core';
import { MznPageHeader } from '@mezzanine-ui/ng/page-header';
import { MznPageFooter } from '@mezzanine-ui/ng/page-footer';
import { MznBreadcrumb } from '@mezzanine-ui/ng/breadcrumb';
import { MznButton } from '@mezzanine-ui/ng/button';
import type { BreadcrumbItemData } from '@mezzanine-ui/ng/breadcrumb';

@Component({
  selector: 'app-product-edit',
  imports: [MznPageHeader, MznPageFooter, MznBreadcrumb, MznButton],
  template: `
    <header mznPageHeader>
      <nav mznBreadcrumb [items]="breadcrumb()"></nav>
    </header>
    <main><!-- content --></main>
    <div mznPageFooter type="standard" supportingActionName="返回列表">
      <div actions>
        <button mznButton variant="base-primary" (click)="save()">儲存</button>
      </div>
    </div>
  `,
})
export class ProductEditComponent {
  readonly breadcrumb = signal<readonly BreadcrumbItemData[]>([
    { id: 'products', name: '商品管理', href: '/products' },
    { id: 'edit', name: '編輯商品' },
  ]);

  save(): void { /* ... */ }
}
```

## Notes

- `MznPageHeader` 極其精簡：源碼只有 `role="banner"` 和 `hostClass`，不含任何 inputs 或 outputs。
- 實際的標題文字、Breadcrumb、操作按鈕均由放入 `<ng-content>` 的子元件負責（通常是 `MznBreadcrumb` 和 `MznContentHeader`）。
- Angular 版的 `MznPageHeader` 對應 React 版的 `<PageHeader>` 包裝容器概念，但不需要傳入任何 props，完全靠 content projection 組合內容。
- 使用 `<header>` 作為 host element 比 `<div>` 更符合語意，搭配 `role="banner"` 能讓螢幕閱讀器正確識別。
