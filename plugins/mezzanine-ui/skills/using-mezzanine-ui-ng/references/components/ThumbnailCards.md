# ThumbnailCards

> ⚠️ **DEPRECATED in @mezzanine-ui/ng 1.0.0-rc.4** — This component has been decomposed into individual replacements. Use the following per-component references instead:
> - [SingleThumbnailCard.md](./SingleThumbnailCard.md) — `MznSingleThumbnailCard` + `MznSingleThumbnailCardSkeleton`
> - [FourThumbnailCard.md](./FourThumbnailCard.md) — `MznFourThumbnailCard` + `MznFourThumbnailCardSkeleton`
> - [ThumbnailCardInfo.md](./ThumbnailCardInfo.md) — `MznThumbnailCardInfo`
>
> You may also consider `QuickActionCard` as an alternative layout.

> ℹ️ Angular-only — no direct React equivalent. These card types are Angular-specific implementations not present in `@mezzanine-ui/react`.

> **Sources** (deprecated):
> - `single-thumbnail-card/` — `MznSingleThumbnailCard`
> - `four-thumbnail-card/` — `MznFourThumbnailCard`
> - `thumbnail-card-info/` — `MznThumbnailCardInfo`
>
> **Verified** 1.0.0-rc.3 (2026-04-21) · **Deprecated** in 1.0.0-rc.4 (2026-04-24)

Three companion components for displaying media/file cards with thumbnail previews. `MznSingleThumbnailCard` shows one image alongside file info. `MznFourThumbnailCard` renders a 2×2 thumbnail grid. `MznThumbnailCardInfo` is the shared info section used by both.

## Import

```ts
import { MznSingleThumbnailCard, MznSingleThumbnailCardSkeleton } from '@mezzanine-ui/ng/single-thumbnail-card';
import { MznFourThumbnailCard, MznFourThumbnailCardSkeleton }     from '@mezzanine-ui/ng/four-thumbnail-card';
import { MznThumbnailCardInfo }                                    from '@mezzanine-ui/ng/thumbnail-card-info';
import { MznThumbnail }                                            from '@mezzanine-ui/ng/thumbnail';

import type { DropdownOption }                from '@mezzanine-ui/core/dropdown';
import type { SingleThumbnailCardType }       from '@mezzanine-ui/ng/single-thumbnail-card';
import type { FourThumbnailCardType }         from '@mezzanine-ui/ng/four-thumbnail-card';
import type { ThumbnailCardInfoActionVariant } from '@mezzanine-ui/ng/thumbnail-card-info';
```

## Selectors

| Selector                   | Component                | Purpose                                     |
| -------------------------- | ------------------------ | ------------------------------------------- |
| `[mznSingleThumbnailCard]` | `MznSingleThumbnailCard` | Card with one wide thumbnail + info section |
| `[mznFourThumbnailCard]`   | `MznFourThumbnailCard`   | Card with 2×2 thumbnail grid + info section |
| `[mznThumbnailCardInfo]`   | `MznThumbnailCardInfo`   | Info section (filetype, title, subtitle, action) |

---

## MznSingleThumbnailCard — Inputs

| Input                    | Type                              | Default     | Description                                              |
| ------------------------ | --------------------------------- | ----------- | -------------------------------------------------------- |
| `title`                  | `string \| undefined`             | —           | File/item title                                          |
| `subtitle`               | `string \| undefined`             | —           | Secondary info (e.g. file size, date)                    |
| `filetype`               | `string \| undefined`             | —           | File extension for filetype badge (e.g. `'pdf'`, `'jpg'`) |
| `tag`                    | `string \| undefined`             | —           | Tag label shown on the thumbnail                         |
| `type`                   | `SingleThumbnailCardType`         | `'default'` | `'default' \| 'action' \| 'overflow'`                   |
| `actionName`             | `string \| undefined`             | —           | Action button text (`type='action'`)                     |
| `options`                | `ReadonlyArray<DropdownOption>`   | —           | Overflow menu options (`type='overflow'`)                |
| `personalActionIcon`     | `IconDefinition \| undefined`     | —           | Icon for the personal action button (e.g. bookmark)      |
| `personalActionActiveIcon`| `IconDefinition \| undefined`    | —           | Active state icon for personal action                    |
| `personalActionActive`   | `boolean`                         | `false`     | Active state of personal action                          |

## MznSingleThumbnailCard — Outputs

| Output                | Type                                   | Description                           |
| --------------------- | -------------------------------------- | ------------------------------------- |
| `actionClick`         | `OutputEmitterRef<MouseEvent>`         | Action button clicked                 |
| `optionSelect`        | `OutputEmitterRef<DropdownOption>`     | Overflow option selected              |
| `personalActionClick` | `OutputEmitterRef<{ event: MouseEvent; active: boolean }>` | Personal action button clicked |

---

## MznFourThumbnailCard — Inputs

Same inputs as `MznSingleThumbnailCard` plus:

| Input  | Type  | Default | Description                                           |
| ------ | ----- | ------- | ----------------------------------------------------- |
| *(same as MznSingleThumbnailCard)* | | | Up to 4 `[mznThumbnail]` children expected |

## MznFourThumbnailCard — Outputs

Same outputs as `MznSingleThumbnailCard` (including `personalActionClick: OutputEmitterRef<{ event: MouseEvent; active: boolean }>`).

Children: `MznFourThumbnailCard` uses `ContentChildren(MznThumbnail)` to collect up to 4 thumbnail children. If fewer than 4 are provided, empty placeholder slots are rendered.

---

## MznThumbnailCardInfo — Inputs

| Input           | Type                                | Default            | Description                                             |
| --------------- | ----------------------------------- | ------------------ | ------------------------------------------------------- |
| `title`         | `string \| undefined`               | —                  | Title text                                              |
| `subtitle`      | `string \| undefined`               | —                  | Subtitle text                                           |
| `filetype`      | `string \| undefined`               | —                  | File extension for category icon badge                  |
| `type`          | `ThumbnailCardInfoType`             | `'default'`        | `'default' \| 'action' \| 'overflow'`                  |
| `actionName`    | `string \| undefined`               | —                  | Action button text (`type='action'`)                    |
| `actionVariant` | `ThumbnailCardInfoActionVariant`    | `'base-text-link'` | Button variant (`'base-text-link' \| 'destructive-text-link'`); applies only when `type='action'` |
| `options`       | `ReadonlyArray<DropdownOption>`     | `[]`               | Overflow menu options (`type='overflow'`)               |
| `disabled`      | `boolean`                           | `false`            | Disable interactions                                    |

## MznThumbnailCardInfo — Outputs

| Output          | Type                              | Description                   |
| --------------- | --------------------------------- | ----------------------------- |
| `actionClick`   | `OutputEmitterRef<MouseEvent>`    | Action button clicked         |
| `optionSelect`  | `OutputEmitterRef<DropdownOption>`| Overflow option selected      |

---

---

## Skeleton variants

Both card types ship with skeleton placeholder components for loading states.

### MznSingleThumbnailCardSkeleton

**Selector**: `[mznSingleThumbnailCardSkeleton]`

| Input                 | Type                | Default                                 | Description                            |
| --------------------- | ------------------- | --------------------------------------- | -------------------------------------- |
| `thumbnailAspectRatio` | `string`           | `'16/9'`                                | CSS `aspect-ratio` of the thumbnail skeleton |
| `thumbnailWidth`      | `number \| string`  | `'var(--mzn-spacing-size-container-slim)'` | Width of the thumbnail skeleton      |

### MznFourThumbnailCardSkeleton

**Selector**: `[mznFourThumbnailCardSkeleton]`

| Input            | Type               | Default | Description                                        |
| ---------------- | ------------------ | ------- | -------------------------------------------------- |
| `thumbnailWidth` | `number \| string` | `200`   | Width of each thumbnail skeleton in the 2×2 grid   |

```html
<!-- Single thumbnail skeleton -->
<div mznSingleThumbnailCardSkeleton thumbnailAspectRatio="4/3" thumbnailWidth="200px"></div>

<!-- Four thumbnail skeleton -->
<div mznFourThumbnailCardSkeleton [thumbnailWidth]="160"></div>
```

---

## ControlValueAccessor

No — all three components are display/interaction only.

## Usage

```html
<!-- SingleThumbnailCard with action -->
<div mznSingleThumbnailCard
  title="Document.pdf"
  subtitle="2.4 MB"
  filetype="pdf"
  type="action"
  actionName="下載"
  (actionClick)="download($event)"
>
  <div mznThumbnail title="預覽">
    <img src="thumb.png" alt="縮圖" />
  </div>
</div>

<!-- FourThumbnailCard with overflow menu -->
<div mznFourThumbnailCard
  title="Photo Album"
  subtitle="4 items"
  type="overflow"
  [options]="menuOptions"
  (optionSelect)="onMenuSelect($event)"
>
  <div mznThumbnail title="Photo 1"><img src="p1.jpg" alt="1" /></div>
  <div mznThumbnail title="Photo 2"><img src="p2.jpg" alt="2" /></div>
  <div mznThumbnail title="Photo 3"><img src="p3.jpg" alt="3" /></div>
  <div mznThumbnail title="Photo 4"><img src="p4.jpg" alt="4" /></div>
</div>

<!-- Standalone ThumbnailCardInfo -->
<div mznThumbnailCardInfo
  title="Report.xlsx"
  subtitle="Last modified: 2025-11-01"
  filetype="xlsx"
  type="overflow"
  [options]="fileOptions"
  (optionSelect)="handleFileAction($event)"
></div>
```

## Notes

- `MznFourThumbnailCard` uses `ContentChildren(MznThumbnail)` to detect projected thumbnails. Empty slots (when fewer than 4 children) are rendered as placeholder `<div>` elements.
- The `filetype` input maps to a file-category icon via `getFileTypeCategory()` from `@mezzanine-ui/core/card/fileTypeMapping`. Common values: `'pdf'`, `'jpg'`, `'png'`, `'xlsx'`, `'docx'`, `'mp4'`.
- `MznCardGroup` with `cardType='single-thumbnail'` or `'four-thumbnail'` automatically applies the grid layout for groups of these cards. See [Card](./Card.md).
- These components have no React equivalents — they are Angular-only additions to the design system.
