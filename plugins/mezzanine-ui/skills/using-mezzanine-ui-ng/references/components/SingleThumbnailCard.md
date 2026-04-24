# SingleThumbnailCard

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/ng/single-thumbnail-card) · Verified 1.0.0-rc.4 (2026-04-24)

Attribute directive component that displays a single image thumbnail with optional tag, personal action button, and info section (title/subtitle/filetype/action). The card width is determined by the image child element. Supports three action modes: `'default'`, `'action'`, and `'overflow'`.

## Import

```ts
import {
  MznSingleThumbnailCard,
  MznSingleThumbnailCardSkeleton,
  SingleThumbnailCardType,
} from '@mezzanine-ui/ng/single-thumbnail-card';
```

## Selector

`[mznSingleThumbnailCard]` — component applied to a block host element (typically `<div>`).

## Inputs

| Input                      | Type                                 | Default     | Description                                                              |
| -------------------------- | ------------------------------------ | ----------- | ------------------------------------------------------------------------ |
| `filetype`                 | `string \| undefined`                | —           | File extension for the filetype badge (e.g., `'pdf'`, `'jpg'`, `'zip'`). |
| `personalActionIcon`       | `IconDefinition \| undefined`        | —           | Icon for the personal action button. When set, the button is rendered.  |
| `personalActionActiveIcon` | `IconDefinition \| undefined`        | —           | Icon shown when `personalActionActive` is `true`.                        |
| `personalActionActive`     | `boolean`                            | `false`     | Whether the personal action is in active state.                          |
| `subtitle`                 | `string \| undefined`                | —           | Subtitle text shown in the info section.                                 |
| `tag`                      | `string \| undefined`                | —           | Optional tag label shown on top of the thumbnail.                        |
| `title`                    | `string \| undefined`                | —           | Title text shown in the info section.                                    |
| `type`                     | `SingleThumbnailCardType`            | `'default'` | Action mode — `'default'`, `'action'`, or `'overflow'`.                  |
| `actionName`               | `string \| undefined`                | —           | Label for the action button when `type="action"`.                        |
| `options`                  | `ReadonlyArray<DropdownOption>`      | —           | Dropdown options when `type="overflow"`.                                 |

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
<!-- 預設模式 (default) -->
<div
  mznSingleThumbnailCard
  title="Document Title"
  subtitle="2024/01/15"
  tag="New"
>
  <img alt="thumbnail" src="https://picsum.photos/320/180" />
</div>

<!-- Action 模式 with filetype badge -->
<div
  mznSingleThumbnailCard
  title="Report.pdf"
  subtitle="2.4 MB"
  filetype="pdf"
  type="action"
  actionName="下載"
  (actionClick)="onDownload($event)"
>
  <img alt="report cover" src="cover.jpg" />
</div>

<!-- Overflow 模式 with personal action -->
<div
  mznSingleThumbnailCard
  title="Photo"
  subtitle="640x480"
  type="overflow"
  [options]="menuOptions"
  [personalActionIcon]="starIcon"
  [personalActionActiveIcon]="starFilledIcon"
  [personalActionActive]="isFavorite"
  (optionSelect)="onOptionSelect($event)"
  (personalActionClick)="togglePersonalAction($event)"
>
  <img alt="photo" src="photo.jpg" />
</div>
```

## MznSingleThumbnailCardSkeleton

Skeleton placeholder that mimics the `MznSingleThumbnailCard` layout.

### Selector

`[mznSingleThumbnailCardSkeleton]`

### Inputs

| Input                   | Type                 | Default                                        | Description                             |
| ----------------------- | -------------------- | ---------------------------------------------- | --------------------------------------- |
| `thumbnailAspectRatio`  | `string`             | `'16/9'`                                       | Aspect ratio of the thumbnail skeleton. |
| `thumbnailWidth`        | `number \| string`   | `'var(--mzn-spacing-size-container-slim)'`     | Width of the thumbnail skeleton.        |

### Usage

```html
<div mznSingleThumbnailCardSkeleton></div>
<div
  mznSingleThumbnailCardSkeleton
  thumbnailAspectRatio="4/3"
  thumbnailWidth="200px"
></div>
```

## Notes

- Component is `standalone: true`; imports `MznIcon` and `MznThumbnailCardInfo` internally. Change detection is `OnPush`.
- The info section is delegated to `MznThumbnailCardInfo` — `actionClick` / `optionSelect` / `actionName` / `options` / `filetype` / `type` / `title` / `subtitle` are forwarded to it.
- `personalActionClick` passes the current `personalActionActive` value so parents can toggle state without a two-way binding.
- When `personalActionIcon` is not set, the personal action button is not rendered.
- When `tag` is falsy, the tag element is not rendered.
- An overlay `<div>` is always rendered on top of the projected content for hover effects.

## Migration from React

React `SingleThumbnailCard` maps onto `[mznSingleThumbnailCard]`:

| React prop                 | Angular                                          |
| -------------------------- | ------------------------------------------------ |
| `title`                    | `[title]`                                        |
| `subtitle`                 | `[subtitle]`                                     |
| `tag`                      | `[tag]`                                          |
| `filetype`                 | `[filetype]`                                     |
| `type`                     | `[type]`                                         |
| `actionName`               | `[actionName]`                                   |
| `options`                  | `[options]`                                      |
| `personalActionIcon`       | `[personalActionIcon]`                           |
| `personalActionActiveIcon` | `[personalActionActiveIcon]`                     |
| `personalActionActive`     | `[personalActionActive]`                         |
| `onAction`                 | `(actionClick)`                                  |
| `onOptionSelect`           | `(optionSelect)`                                 |
| `onPersonalActionClick`    | `(personalActionClick)` — payload `{event,active}` |
| `children` (`<img>`)       | projected via `<ng-content />`                   |
