# Anchor

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/ng/anchor) · Verified 1.0.0-rc.4 (2026-04-24)
>
> **Storybook**: https://storybook-ng.mezzanine-ui.org/?path=/docs/navigation-anchor-group--docs

錨點群組元件，以資料驅動方式渲染一組錨點導航連結。支援最多三層巢狀（每層最多 3 個子項目），自動監聽 URL hash 變化以標示當前錨點，並支援 `autoScrollTo` 平滑滾動功能。

## Import

```ts
import { MznAnchorGroup } from '@mezzanine-ui/ng/anchor';
import type { AnchorItemData } from '@mezzanine-ui/ng/anchor';
```

## Selector

`<div mznAnchorGroup [anchors]="anchorData">` — attribute-directive component on any block element

## Inputs — MznAnchorGroup

| Input       | Type                          | Default | Description                                        |
| ----------- | ----------------------------- | ------- | -------------------------------------------------- |
| `anchors`   | `readonly AnchorItemData[]` (required) | — | 錨點項目資料陣列，支援最多三層巢狀              |
| `className` | `string`                      | —       | 附加到 host 的自訂 CSS class                        |

> Inputs declared with signal API (`input()`, `input.required()`) accept both static and reactive values.

## Outputs

`MznAnchorGroup` 無 output 事件；點擊行為透過 `AnchorItemData.onClick` 回呼傳入。

## AnchorItemData 介面

| 欄位           | Type                          | Description                                          |
| -------------- | ----------------------------- | ---------------------------------------------------- |
| `id`           | `string` (required)           | 唯一識別碼                                           |
| `name`         | `string` (required)           | 顯示名稱                                             |
| `href`         | `string` (required)           | 連結目標（含 `#` hash）                              |
| `children`     | `readonly AnchorItemData[]`   | 子錨點項目（最多 3 層，每層最多 3 個）               |
| `disabled`     | `boolean`                     | 是否停用此錨點（向下繼承至子項目）                   |
| `autoScrollTo` | `boolean`                     | 是否平滑滾動至目標元素（向下繼承至子項目）           |
| `onClick`      | `VoidFunction`                | 點擊回呼                                             |
| `title`        | `string`                      | HTML `title` 屬性                                    |

## Usage

```html
<div mznAnchorGroup [anchors]="anchorItems"></div>
```

```ts
import { Component, signal } from '@angular/core';
import { MznAnchorGroup } from '@mezzanine-ui/ng/anchor';
import type { AnchorItemData } from '@mezzanine-ui/ng/anchor';

@Component({
  selector: 'app-docs-nav',
  imports: [MznAnchorGroup],
  template: `
    <aside>
      <div mznAnchorGroup [anchors]="anchorItems"></div>
    </aside>
  `,
})
export class DocsNavComponent {
  readonly anchorItems: readonly AnchorItemData[] = [
    { id: 'overview', name: '總覽', href: '#overview' },
    {
      id: 'usage',
      name: '使用方式',
      href: '#usage',
      autoScrollTo: true,
      children: [
        { id: 'basic', name: '基本用法', href: '#basic' },
        { id: 'advanced', name: '進階用法', href: '#advanced' },
      ],
    },
    { id: 'api', name: 'API', href: '#api' },
  ];
}
```

## Notes

- 元件內部以遞迴 `<ng-template>` 展開連結，最終 DOM 結構與 React `<AnchorGroup>` 完全一致，不產生額外的 wrapper 元素。
- 當前錨點高亮依賴 `window.location.hash`，元件會在 `ngOnInit` 時綁定 `hashchange` 事件並在 `DestroyRef` 時自動清除。
- 巢狀限制：最多三層（`MAX_NESTING_LEVEL = 3`），每層最多 3 個子項目（`MAX_CHILDREN_PER_LEVEL = 3`）；超出部分會被截斷。
- SSR 環境下，`window` 存取前有 `typeof window !== 'undefined'` 保護，不會在 server 端拋錯。
- 不同於 React 版有獨立的 `<Anchor>` 元件，Angular 版僅匯出 `MznAnchorGroup`（資料驅動），沒有對應的 `MznAnchor` 單項元件。
