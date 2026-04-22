# Scrollbar

> ⚠️ Internal helper — `MznScrollbar` is a thin wrapper around [OverlayScrollbars](https://kingsora.github.io/OverlayScrollbars/) used internally by `MznLayoutMain`, `MznNavigation`, and `MznTable`. **Not recommended for direct usage.** If you need custom scrolling behaviour in a layout area, use `MznLayoutMain` which exposes `scrollbarDisabled`, `scrollbarMaxHeight`, and `scrollbarMaxWidth` inputs.

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/ng/scrollbar) · Verified 1.0.0-rc.3 (2026-04-21)

Custom scrollbar component backed by OverlayScrollbars. Applies styled scrollbars that match the Mezzanine design tokens.

## Import

```ts
import { MznScrollbar } from '@mezzanine-ui/ng/scrollbar';
import type { PartialOptions, EventListeners } from 'overlayscrollbars';
```

## Selector

`[mznScrollbar]` — component applied to a scrollable container element.

## Inputs

| Input       | Type                                          | Default | Description                                                  |
| ----------- | --------------------------------------------- | ------- | ------------------------------------------------------------ |
| `disabled`  | `boolean`                                     | `false` | When `true`, falls back to native scrollbar                  |
| `defer`     | `boolean \| { timeout?: number }`             | `true`  | Defer OverlayScrollbars initialization (avoids layout shift) |
| `maxHeight` | `string \| undefined`                         | —       | CSS max-height value (e.g. `'300px'`, `'50vh'`)              |
| `maxWidth`  | `string \| undefined`                         | —       | CSS max-width value (e.g. `'500px'`, `'100%'`)               |
| `options`   | `PartialOptions \| undefined`                 | —       | OverlayScrollbars options object                             |
| `events`    | `EventListeners \| undefined`                 | —       | OverlayScrollbars event listeners                            |

## Outputs

| Output          | Type                                                               | Description                                                       |
| --------------- | ------------------------------------------------------------------ | ----------------------------------------------------------------- |
| `viewportReady` | `OutputEmitterRef<{ viewport: HTMLDivElement; instance?: OverlayScrollbars }>` | Emits after OverlayScrollbars initialises; provides the inner viewport element and the OS instance for external integration (virtualisation, DnD, etc.) |

## Usage

```html
<!-- Direct usage (uncommon) -->
<div mznScrollbar style="height: 400px; overflow: auto;">
  <div>Long content...</div>
</div>
```

## Notes

- Prefer `MznLayoutMain` with `[scrollbarDisabled]` for application-level scroll areas.
- OverlayScrollbars must be available as a peer dependency (`overlayscrollbars` package).
- The `defer` input prevents a flash of native scrollbars before OverlayScrollbars initialises. Set to `false` if you need the custom scrollbar immediately (e.g. SSR-agnostic cases).
