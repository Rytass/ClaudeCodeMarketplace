# Thumbnail

> ℹ️ Angular-only — no direct React equivalent.

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/ng/thumbnail) · Verified 1.0.0-rc.4 (2026-04-24)

Attribute directive component that adds the thumbnail CSS class and an optional hover overlay to any host element (`<div>`, `<a>`, `<button>`, etc.). Used as the image cell inside `MznFourThumbnailCard` and `MznSingleThumbnailCard`.

## Import

```ts
import { MznThumbnail } from '@mezzanine-ui/ng/thumbnail';
```

## Selector

`[mznThumbnail]` — component applied to any block host element.

## Inputs

| Input   | Type                  | Default | Description                                         |
| ------- | --------------------- | ------- | --------------------------------------------------- |
| `title` | `string \| undefined` | —       | Text shown in the overlay on hover                  |

> Input declared with signal API (`input()`) accepts both static and reactive values.

## Outputs

None.

## ControlValueAccessor

No.

## Usage

```html
<!-- Static image thumbnail -->
<div mznThumbnail title="封面圖">
  <img src="cover.jpg" alt="封面" style="width: 100%; height: 100%; object-fit: cover;" />
</div>

<!-- Clickable thumbnail -->
<button mznThumbnail type="button" title="查看詳情" (click)="openPreview()">
  <img src="photo.jpg" alt="照片" />
</button>

<!-- Link thumbnail -->
<a mznThumbnail href="/detail/1" target="_blank" title="前往頁面">
  <img src="preview.jpg" alt="預覽" />
</a>

<!-- Inside FourThumbnailCard -->
<div mznFourThumbnailCard title="相冊">
  <div mznThumbnail title="第一張">
    <img src="photo1.jpg" alt="1" />
  </div>
  <div mznThumbnail title="第二張">
    <img src="photo2.jpg" alt="2" />
  </div>
</div>
```

## Notes

- `MznThumbnail` applies `mzn-four-thumbnail-card__thumbnail` CSS class to the host via `@HostBinding('class')`. The host element must contain an `<img>` or other media element as its child.
- The component uses `host: { '[attr.title]': 'null' }` to suppress the native HTML `title` attribute on the host element. This prevents the browser's built-in tooltip from appearing alongside the custom overlay, avoiding a double-tooltip UX issue and improving accessibility.
- The overlay `<div>` is always rendered in the DOM. However, the inner `<span>` that displays the text is only rendered when the `title` input has a value (`@if (title())`). An empty/undefined `title` leaves the overlay container present but empty.
- Host element semantics are preserved — use `<button>` for clickable thumbnails and `<a>` for navigable ones to maintain accessibility.
- There is no equivalent React component. The React card components handle their thumbnail rendering internally.
