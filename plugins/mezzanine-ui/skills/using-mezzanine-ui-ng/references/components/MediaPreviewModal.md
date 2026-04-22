# MediaPreviewModal

> ℹ️ Angular-only — no direct React equivalent.

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/ng/media-preview-modal) · Verified 1.0.0-rc.3 (2026-04-21)

Full-screen media gallery modal with prev/next navigation, circular browsing, and automatic adjacent-image preloading. Supports both string URLs and `TemplateRef` items for custom content. Uses `EscapeKeyService`, `TopStackService`, and `ScrollLockService` like `MznModal`.

## Import

```ts
import { MznMediaPreviewModal } from '@mezzanine-ui/ng/media-preview-modal';
import type { MediaPreviewItem } from '@mezzanine-ui/ng/media-preview-modal';
```

## Selector

`[mznMediaPreviewModal]` — component applied to a container element.

## Inputs

| Input                          | Type                                   | Default  | Description                                              |
| ------------------------------ | -------------------------------------- | -------- | -------------------------------------------------------- |
| `open`                         | `boolean`                              | `false`  | Controls modal visibility                                |
| `mediaItems`                   | `ReadonlyArray<MediaPreviewItem>`      | `[]`     | Array of image URLs or `TemplateRef` items               |
| `defaultIndex`                 | `number`                               | `0`      | Initial active index (uncontrolled)                      |
| `currentIndex`                 | `number \| undefined`                  | —        | Controlled active index                                  |
| `disableNext`                  | `boolean`                              | `false`  | Disable forward navigation                               |
| `disablePrev`                  | `boolean`                              | `false`  | Disable backward navigation                              |
| `enableCircularNavigation`     | `boolean`                              | `false`  | Wrap from last item to first and vice versa              |
| `showPaginationIndicator`      | `boolean`                              | `true`   | Show `n / total` indicator when multiple items           |
| `disableCloseOnBackdropClick`  | `boolean`                              | `true`   | Prevent backdrop click from closing                      |
| `disableCloseOnEscapeKeyDown`  | `boolean`                              | `false`  | Prevent Escape key from closing                          |
| `disablePortal`                | `boolean`                              | `false`  | Render in-place instead of via portal                    |

> `MediaPreviewItem = string | TemplateRef<unknown>`

> Inputs declared with signal API (`input()`, `model()`) accept both static and reactive values.

## Outputs

| Output        | Type                        | Description                                        |
| ------------- | --------------------------- | -------------------------------------------------- |
| `closed`      | `OutputEmitterRef<void>`    | Fires when modal closes                            |
| `next`        | `OutputEmitterRef<void>`    | Fires when forward navigation is triggered         |
| `prev`        | `OutputEmitterRef<void>`    | Fires when backward navigation is triggered        |
| `indexChange` | `OutputEmitterRef<number>`  | Fires with new index on navigation                 |

## DI Tokens / Services Required

Auto-provided at root; no manual setup needed:

| Service              | Purpose                                               |
| -------------------- | ----------------------------------------------------- |
| `EscapeKeyService`   | Global Escape key handler                             |
| `TopStackService`    | Ensures only topmost overlay closes on Escape         |
| `ScrollLockService`  | Locks body scroll while modal is open                 |

## ControlValueAccessor

No.

## Usage

```html
<!-- Uncontrolled (manages index internally) -->
<div mznMediaPreviewModal
  [open]="isOpen"
  [mediaItems]="imageUrls"
  [defaultIndex]="0"
  [enableCircularNavigation]="true"
  (closed)="isOpen = false"
  (indexChange)="onIndexChange($event)"
></div>

<!-- Controlled (parent manages index) -->
<div mznMediaPreviewModal
  [open]="isOpen"
  [mediaItems]="imageUrls"
  [currentIndex]="currentIndex"
  (closed)="isOpen = false"
  (next)="currentIndex = Math.min(currentIndex + 1, imageUrls.length - 1)"
  (prev)="currentIndex = Math.max(currentIndex - 1, 0)"
></div>

<!-- Mixed content (URL + custom template) -->
<ng-template #customItem>
  <video controls src="video.mp4" style="max-height: 80vh;"></video>
</ng-template>

<div mznMediaPreviewModal
  [open]="isOpen"
  [mediaItems]="[imageUrl, customItem]"
  (closed)="isOpen = false"
></div>
```

```ts
import { MznMediaPreviewModal } from '@mezzanine-ui/ng/media-preview-modal';

isOpen = false;
currentIndex = 0;
readonly imageUrls: readonly string[] = [
  'https://example.com/photo1.jpg',
  'https://example.com/photo2.jpg',
  'https://example.com/photo3.jpg',
];

openPreview(index: number): void {
  this.currentIndex = index;
  this.isOpen = true;
}

onIndexChange(index: number): void {
  this.currentIndex = index;
}
```

## Notes

- Adjacent images (previous and next) are preloaded automatically using `new Image()` to improve perceived performance.
- `disableCloseOnBackdropClick` defaults to `true` (opposite of `MznModal`) since users often click on the dark background while viewing media without intending to close.
- `TemplateRef` items in `mediaItems` receive no implicit context — the template should be self-contained.
- The pagination indicator (`n / total`) only appears when there are two or more items and `showPaginationIndicator=true`.
- This component is Angular-only; it was built for the Angular admin shell and has no corresponding React component in the design system.
