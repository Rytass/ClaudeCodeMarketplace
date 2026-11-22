# Breadcrumb

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/ng/breadcrumb) · Verified 1.0.0-rc.26 (2026-11-22)
>
> **Storybook**: https://storybook-ng.mezzanine-ui.org/?path=/docs/navigation-breadcrumb--docs

麵包屑導覽元件，顯示頁面在階層中的位置。透過 `items` 陣列以資料驅動方式渲染，自動處理分隔線、當前頁標記，以及超過 4 項或 `condensed` 模式時的中段項目收合（以 overflow 按鈕呈現）。最後一個項目會被自動標記為 `current`。

## Import

```ts
import { MznBreadcrumb, MznBreadcrumbItem } from '@mezzanine-ui/ng/breadcrumb';
// @internal — managed by MznBreadcrumb; avoid using directly
import {
  MznBreadcrumbOverflowMenu,
  MznBreadcrumbOverflowMenuItem,
} from '@mezzanine-ui/ng/breadcrumb';
import type { BreadcrumbItemData } from '@mezzanine-ui/ng/breadcrumb';
```

## Selector

`<nav mznBreadcrumb [items]="...">` — attribute-directive component，建議使用 `<nav>` 作為 host element 以符合語意

`<span mznBreadcrumbItem name="...">` — 子項目 component（通常由 `MznBreadcrumb` 內部渲染）

## Inputs — MznBreadcrumb

| Input      | Type                              | Default | Description                                                                         |
| ---------- | --------------------------------- | ------- | ----------------------------------------------------------------------------------- |
| `items`    | `readonly BreadcrumbItemData[]` (required) | — | 麵包屑項目資料陣列                                                           |
| `condensed`| `boolean`                         | `false` | 精簡模式：僅顯示最後兩個項目，其餘以 overflow 按鈕代替                              |

> Inputs declared with signal API (`input()`, `input.required()`) accept both static and reactive values.

## Inputs — MznBreadcrumbItem

| Input      | Type      | Default | Description                           |
| ---------- | --------- | ------- | ------------------------------------- |
| `name`     | `string` (required) | —  | 項目顯示名稱                     |
| `current`  | `boolean` | `false` | 是否為當前頁面（純文字，不渲染連結）  |
| `href`     | `string`  | —       | 連結目標                              |
| `itemId`   | `string`  | —       | 綁定到 host 的 `id` 屬性              |
| `target`   | `string`  | —       | 連結 `target` 屬性                    |

## Outputs — MznBreadcrumbItem

| Output      | Type                     | Description |
| ----------- | ------------------------ | ----------- |
| `itemClick` | `OutputEmitterRef<void>` | 點擊項目連結時觸發（僅在非 `current` 且有 `href`、渲染為 `<a>` 時；純文字項目不觸發） |

## BreadcrumbItemData 介面

| 欄位      | Type          | Description                                    |
| --------- | ------------- | ---------------------------------------------- |
| `name`    | `string`      | 項目名稱（必填）                               |
| `id`      | `string`      | 唯一識別碼（未提供時以 `name` fallback）        |
| `href`    | `string`      | 連結目標                                       |
| `current` | `boolean`     | 是否為當前頁面                                 |
| `target`  | `string`      | 連結 target 屬性                               |
| `onClick` | `() => void`  | 點擊回呼                                       |

## Sub-components / Exports

| Export                         | Purpose                                                                   |
| ------------------------------ | ------------------------------------------------------------------------- |
| `MznBreadcrumb`                | 主要麵包屑容器，負責 slot 計算與 overflow 邏輯                             |
| `MznBreadcrumbItem`            | 單一項目（連結或純文字），通常由 `MznBreadcrumb` 內部渲染                   |
| `MznBreadcrumbOverflowMenu`    | `@internal` — Overflow 按鈕 + 下拉選單，由 `MznBreadcrumb` 在需要收合時（`condensed` 且項目 > 2，或預設模式項目 > 4）自動管理，不建議直接使用。其 `collapsed`（`readonly (BreadcrumbItemData & { id: string })[]`，required）由父層注入，**不對外提供**，因此本文件不列 Inputs 表 |
| `MznBreadcrumbOverflowMenuItem`| `@internal` — Overflow 選單中的單一項目，由 `MznBreadcrumbOverflowMenu` 內部渲染，不建議直接使用 |

> **Note**: `MznBreadcrumbOverflowMenu` and `MznBreadcrumbOverflowMenuItem` are marked `@internal` in the source JSDoc. They are publicly exported but managed automatically by `MznBreadcrumb` — avoid using them directly.
>
> `MznBreadcrumbOverflowMenu` inputs: `collapsed: readonly (BreadcrumbItemData & { id: string })[]` (required).
> `MznBreadcrumbOverflowMenuItem` inputs: `name: string` (required), `href?: string`, `target?: string`. Output: `itemClick: void`.

## Usage

```html
<!-- 標準模式 -->
<nav
  mznBreadcrumb
  [items]="[
    { id: 'home', name: '首頁', href: '/' },
    { id: 'products', name: '產品', href: '/products' },
    { id: 'detail', name: '商品詳情' }
  ]"
></nav>

<!-- 精簡模式（超過 2 個時中段以 overflow 代替） -->
<nav mznBreadcrumb [condensed]="true" [items]="breadcrumbItems"></nav>
```

```ts
import { Component, signal } from '@angular/core';
import { MznBreadcrumb } from '@mezzanine-ui/ng/breadcrumb';
import type { BreadcrumbItemData } from '@mezzanine-ui/ng/breadcrumb';

@Component({
  selector: 'app-page',
  imports: [MznBreadcrumb],
  template: `<nav mznBreadcrumb [items]="breadcrumb()"></nav>`,
})
export class PageComponent {
  readonly breadcrumb = signal<readonly BreadcrumbItemData[]>([
    { id: 'home', name: '首頁', href: '/' },
    { id: 'settings', name: '設定', href: '/settings' },
    { id: 'profile', name: '個人資料' },
  ]);
}
```

## Notes

- 預設模式：≤ 4 項時全部顯示；> 4 項時顯示前 2 項、overflow 按鈕、倒數第 2 項與最後一項，第 3 至倒數第 3 項收合於 overflow。
- `condensed` 模式：始終只顯示最後 2 項（含 overflow 代表所有前面的項目）。
- 最後一個項目固定視為 `current = true`，不論其 `current` 欄位原值為何。
- `MznBreadcrumb` 對應 React `<Breadcrumb>` 的資料驅動 API；若需要完全自訂每個項目，可直接使用 `MznBreadcrumbItem`。
- `aria-label="Breadcrumb"` 由元件以靜態 host 屬性加在 host element 上，無需手動設定。
- `MznBreadcrumb` 內部 standalone `imports`：`MznIcon`、`MznBreadcrumbItem`、`MznBreadcrumbOverflowMenu`；使用端只需 import `MznBreadcrumb`。
- Overflow 選單項目的 `onClick` 會在點擊時呼叫並關閉選單；`itemClick` 於一般項目只對 `<a>` 觸發。
