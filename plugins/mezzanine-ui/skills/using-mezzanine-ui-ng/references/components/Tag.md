# Tag

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/ng/tag) · Verified 1.0.0-rc.4 (2026-04-24)
>
> **Storybook**: https://storybook-ng.mezzanine-ui.org/?path=/docs/data-display-tag--docs

標籤元件，用於分類、篩選或標記內容。支援五種模式：`static`（純標籤）、`counter`（帶計數徽章）、`dismissable`（可關閉）、`addable`（可點擊新增）及 `overflow-counter`（溢出計數）。`MznTagGroup` 可包裹多個標籤，並支援 `fade` 過場動畫。

## Import

```ts
import { MznTag, MznTagGroup } from '@mezzanine-ui/ng/tag';
import type { TagType, TagSize } from '@mezzanine-ui/core/tag';
// TagType: 'static' | 'counter' | 'dismissable' | 'addable' | 'overflow-counter'
// TagSize: 'main' | 'sub'
```

## Selector

`<span mznTag type="static" label="標籤文字">` — attribute-directive component，建議 host element 為 `<span>`

`<div mznTagGroup>` — 標籤群組容器

## Inputs — MznTag

| Input      | Type       | Default    | Description                                                                                              |
| ---------- | ---------- | ---------- | -------------------------------------------------------------------------------------------------------- |
| `type`     | `TagType`  | `'static'` | 標籤模式：`'static'` / `'counter'` / `'dismissable'` / `'addable'` / `'overflow-counter'`                |
| `label`    | `string`   | —          | 標籤顯示文字（`static`、`counter`、`dismissable`、`addable` 型）                                          |
| `size`     | `TagSize`  | `'main'`   | `'main' \| 'sub'` — 標籤尺寸                                                                             |
| `count`    | `number`   | —          | 計數器數字（`counter` 和 `overflow-counter` 型）                                                          |
| `disabled` | `boolean`  | `false`    | 是否禁用（`dismissable`、`addable`、`overflow-counter` 型）                                               |
| `active`   | `boolean`  | `false`    | 是否啟用中（套用 active 樣式）                                                                            |
| `readOnly` | `boolean`  | `false`    | 是否唯讀                                                                                                  |

> Inputs declared with signal API (`input()`) accept both static and reactive values.

## Outputs — MznTag

| Output     | Type                         | Description                                              |
| ---------- | ---------------------------- | -------------------------------------------------------- |
| `close`    | `OutputEmitterRef<MouseEvent>` | 關閉按鈕被點擊時觸發（`dismissable` 型）                |
| `tagClick` | `OutputEmitterRef<MouseEvent>` | 標籤被點擊時觸發（`addable` / `overflow-counter` 型）   |

## Inputs — MznTagGroup

| Input        | Type               | Default  | Description                             |
| ------------ | ------------------ | -------- | --------------------------------------- |
| `transition` | `'fade' \| 'none'` | `'none'` | 過場動畫；`'fade'` 在標籤增刪時以漸變呈現 |

## Usage

```html
<!-- 靜態標籤 -->
<span mznTag type="static" label="設計"></span>
<span mznTag type="static" label="前端" size="sub"></span>

<!-- 計數標籤 -->
<span mznTag type="counter" label="待處理" [count]="pendingCount()"></span>

<!-- 可關閉標籤 -->
<span mznTag type="dismissable" label="React" (close)="removeTag('React')"></span>

<!-- 可新增標籤 -->
<span mznTag type="addable" label="新增標籤" (tagClick)="openTagInput()"></span>

<!-- 溢出計數標籤 -->
<span mznTag type="overflow-counter" [count]="extraTagCount()" (tagClick)="showAllTags()"></span>

<!-- 標籤群組（帶 fade 動畫） -->
<div mznTagGroup transition="fade">
  @for (tag of tags(); track tag.id) {
    <span
      mznTag
      type="dismissable"
      [label]="tag.name"
      (close)="removeTag(tag.id)"
    ></span>
  }
  <span mznTag type="addable" label="新增" (tagClick)="openAddTag()"></span>
</div>
```

```ts
import { Component, signal } from '@angular/core';
import { MznTag, MznTagGroup } from '@mezzanine-ui/ng/tag';

interface TagItem {
  id: string;
  name: string;
}

@Component({
  selector: 'app-tag-editor',
  imports: [MznTag, MznTagGroup],
  template: `
    <div mznTagGroup transition="fade">
      @for (tag of tags(); track tag.id) {
        <span
          mznTag
          type="dismissable"
          [label]="tag.name"
          [disabled]="isReadOnly()"
          (close)="removeTag(tag.id)"
        ></span>
      }
      @if (!isReadOnly()) {
        <span mznTag type="addable" label="新增標籤" (tagClick)="addTag()"></span>
      }
    </div>
  `,
})
export class TagEditorComponent {
  readonly tags = signal<TagItem[]>([
    { id: '1', name: 'Angular' },
    { id: '2', name: 'TypeScript' },
  ]);
  readonly isReadOnly = signal(false);

  removeTag(id: string): void {
    this.tags.update((tags) => tags.filter((t) => t.id !== id));
  }

  addTag(): void { /* open dialog... */ }
}
```

## Notes

- `addable` 和 `overflow-counter` 型的 host element 為透明（`display: contents`），實際的標籤樣式套用在內部 `<button>` 上；這是為了讓 CSS selector（如 `:disabled`、hover）正確匹配。
- `close` output 僅在 `type="dismissable"` 時有效；`tagClick` output 僅在 `type="addable"` 或 `type="overflow-counter"` 時有效。
- `active` input 可用於表示「已選取」的篩選標籤（如篩選條件面板）。
- `MznTagGroup` 的 `transition="fade"` 僅控制標籤容器的動畫，標籤增刪的 CSS transition 由 SCSS 定義。
