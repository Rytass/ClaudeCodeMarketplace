# FourThumbnailCard

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/ng/four-thumbnail-card) · Verified 1.0.0-rc.4 (2026-04-24)

Attribute directive component that displays a 2x2 grid of image thumbnails with optional tag, personal action button, and info section. Children must be `MznThumbnail` components; if fewer than 4 are provided, empty slots are rendered to fill the grid. Supports three action modes: `'default'`, `'action'`, and `'overflow'`.

## Import

```ts
import {
  MznFourThumbnailCard,
  MznFourThumbnailCardSkeleton,
  FourThumbnailCardType,
} from '@mezzanine-ui/ng/four-thumbnail-card';
import { MznThumbnail } from '@mezzanine-ui/ng/thumbnail';
```

## Selector

`[mznFourThumbnailCard]` — component applied to a block host element (typically `<div>`).

## Inputs

| Input                      | Type                             | Default     | Description                                                              |
| -------------------------- | -------------------------------- | ----------- | ------------------------------------------------------------------------ |
| `filetype`                 | `string \| undefined`            | —           | File extension for the filetype badge (e.g., `'pdf'`, `'jpg'`, `'zip'`). |
| `personalActionIcon`       | `IconDefinition \| undefined`    | —           | Icon for the personal action button. When set, the button is rendered.  |
| `personalActionActiveIcon` | `IconDefinition \| undefined`    | —           | Icon shown when `personalActionActive` is `true`.                        |
| `personalActionActive`     | `boolean`                        | `false`     | Whether the personal action is in active state.                          |
| `subtitle`                 | `string \| undefined`            | —           | Subtitle text shown in the info section.                                 |
| `tag`                      | `string \| undefined`            | —           | Optional tag label shown on top of the thumbnail grid.                   |
| `title`                    | `string \| undefined`            | —           | Title text shown in the info section.                                    |
| `type`                     | `FourThumbnailCardType`          | `'default'` | Action mode — `'default'`, `'action'`, or `'overflow'`.                  |
| `actionName`               | `string \| undefined`            | —           | Label for the action button when `type="action"`.                        |
| `options`                  | `ReadonlyArray<DropdownOption>`  | —           | Dropdown options when `type="overflow"`.                                 |

> Inputs declared with signal API (`input()`) accept both static and reactive values.

## Outputs

| Output                 | Payload                                   | Description                                              |
| ---------------------- | ----------------------------------------- | -------------------------------------------------------- |
| `personalActionClick`  | `{ event: MouseEvent; active: boolean }`  | Emitted when the personal action button is clicked.      |
| `actionClick`          | `MouseEvent`                              | Emitted when the action button is clicked (`type="action"`). |
| `optionSelect`         | `DropdownOption`                          | Emitted when a dropdown option is selected (`type="overflow"`). |

## ControlValueAccessor

No.

## Usage

```html
<!-- 預設模式 — 4 張縮圖 -->
<div mznFourThumbnailCard title="Photo Collection" subtitle="4 photos">
  <div mznThumbnail title="Photo 1"><img alt="p1" src="p1.jpg" /></div>
  <div mznThumbnail title="Photo 2"><img alt="p2" src="p2.jpg" /></div>
  <div mznThumbnail title="Photo 3"><img alt="p3" src="p3.jpg" /></div>
  <div mznThumbnail title="Photo 4"><img alt="p4" src="p4.jpg" /></div>
</div>

<!-- 不滿 4 張 — 自動補空格 -->
<div mznFourThumbnailCard title="部分相片" subtitle="2 photos">
  <div mznThumbnail><img alt="1" src="1.jpg" /></div>
  <div mznThumbnail><img alt="2" src="2.jpg" /></div>
</div>

<!-- Overflow 模式 -->
<div
  mznFourThumbnailCard
  title="Album"
  subtitle="12 photos"
  type="overflow"
  [options]="menuOptions"
  (optionSelect)="onOptionSelect($event)"
>
  <div mznThumbnail *ngFor="let p of photos" [title]="p.name">
    <img [alt]="p.name" [src]="p.src" />
  </div>
</div>
```

## MznFourThumbnailCardSkeleton

Skeleton placeholder that mimics the `MznFourThumbnailCard` layout (2x2 grid).

### Selector

`[mznFourThumbnailCardSkeleton]`

### Inputs

| Input             | Type                 | Default | Description                                                                                       |
| ----------------- | -------------------- | ------- | ------------------------------------------------------------------------------------------------- |
| `thumbnailWidth`  | `number \| string`   | `200`   | Width of each thumbnail skeleton. Accepts a number (pixels) or a CSS string value.                |

### Usage

```html
<div mznFourThumbnailCardSkeleton></div>
<div mznFourThumbnailCardSkeleton [thumbnailWidth]="160"></div>
```

## Notes

- Component is `standalone: true`; imports `MznIcon` and `MznThumbnailCardInfo` internally. Change detection is `OnPush`.
- Children are projected via `<ng-content select="[mznThumbnail]" />` — only elements matching the `[mznThumbnail]` selector are rendered inside the grid.
- Children are tracked via `@ContentChildren(MznThumbnail, { descendants: true })`; missing slots (up to a maximum of 4) are filled with empty placeholder `<div>` elements.
- The empty-slot count updates reactively when the projected `mznThumbnail` children change (`ngAfterContentInit` subscribes to `thumbnailList.changes`).
- The info section is delegated to `MznThumbnailCardInfo` — `actionClick` / `optionSelect` / `actionName` / `options` / `filetype` / `type` / `title` / `subtitle` are forwarded to it.
- `personalActionClick` passes the current `personalActionActive` value so parents can toggle state without a two-way binding.

## Migration from React

React `FourThumbnailCard` maps onto `[mznFourThumbnailCard]`:

| React prop                 | Angular                                                   |
| -------------------------- | --------------------------------------------------------- |
| `title`                    | `[title]`                                                 |
| `subtitle`                 | `[subtitle]`                                              |
| `tag`                      | `[tag]`                                                   |
| `filetype`                 | `[filetype]`                                              |
| `type`                     | `[type]`                                                  |
| `actionName`               | `[actionName]`                                            |
| `options`                  | `[options]`                                               |
| `personalActionIcon`       | `[personalActionIcon]`                                    |
| `personalActionActiveIcon` | `[personalActionActiveIcon]`                              |
| `personalActionActive`     | `[personalActionActive]`                                  |
| `onAction`                 | `(actionClick)`                                           |
| `onOptionSelect`           | `(optionSelect)`                                          |
| `onPersonalActionClick`    | `(personalActionClick)` — payload `{event,active}`        |
| `thumbnails` (array prop)  | projected `mznThumbnail` children (up to 4)               |
