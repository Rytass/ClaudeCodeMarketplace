# Popper

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/ng/popper) · Verified 1.0.0-rc.4 (2026-04-24)

Low-level floating positioning component backed by `@floating-ui/dom`. Used internally by `MznDropdown`, `MznOverflowTooltip`, and other overlay components. You would typically use `MznPopper` only when building custom overlay components.

## Import

```ts
import { MznPopper } from '@mezzanine-ui/ng/popper';
import type {
  PopperPlacement,
  PopperPositionStrategy,
  PopperArrowOptions,
  PopperOffsetOptions,
} from '@mezzanine-ui/ng/popper';
import type { Middleware, Placement } from '@floating-ui/dom';
```

## Selector

`[mznPopper]` — component applied to an overlay container element.

## Inputs

| Input           | Type                                           | Default      | Description                                            |
| --------------- | ---------------------------------------------- | ------------ | ------------------------------------------------------ |
| `anchor`        | `HTMLElement \| ElementRef<HTMLElement> \| null` | `null`      | Reference element to position relative to              |
| `open`          | `boolean`                                      | `false`      | Controls whether the popper is positioned/visible      |
| `placement`     | `PopperPlacement`                              | `'bottom'`   | Initial preferred placement (Floating UI `Placement`)  |
| `strategy`      | `PopperPositionStrategy`                       | `'absolute'` | `'absolute' \| 'fixed'`                               |
| `middleware`    | `ReadonlyArray<Middleware> \| undefined`        | —            | Extra Floating UI middleware (e.g. `flip`, `shift`)    |
| `arrowOptions`  | `PopperArrowOptions \| undefined`              | —            | Arrow element config `{ enabled, className, padding }` |
| `offsetOptions` | `PopperOffsetOptions \| undefined`             | —            | Offset config `{ mainAxis, crossAxis }`                |
| `disableFlip`   | `boolean`                                      | `false`      | Disable the built-in `flip` middleware                 |

> Inputs declared with signal API (`input()`, `model()`) accept both static and reactive values.

## Outputs

| Output            | Type                         | Description                               |
| ----------------- | ---------------------------- | ----------------------------------------- |
| `positionUpdated` | `OutputEmitterRef<Placement>`| Fires after each position calculation     |

## Public Signals (readonly)

| Signal               | Type                          | Default | Description                                                                              |
| -------------------- | ----------------------------- | ------- | ---------------------------------------------------------------------------------------- |
| `floatingX`          | `Signal<number>`              | `0`     | Computed left offset in px                                                               |
| `floatingY`          | `Signal<number>`              | `0`     | Computed top offset in px                                                                |
| `currentPlacement`   | `Signal<Placement>`           | `'bottom'` | Resolved placement after flip/shift                                                   |
| `arrowX`             | `Signal<number \| undefined>` | —       | Arrow x position                                                                         |
| `arrowY`             | `Signal<number \| undefined>` | —       | Arrow y position                                                                         |
| `referenceHidden`    | `Signal<boolean>`             | `false` | Becomes `true` when the anchor element is hidden (e.g. scrolled behind `overflow: hidden`). Used by the host binding `[style.visibility]` to hide the popper when the anchor is out of view. |

## ControlValueAccessor

No.

## Usage

```html
<!-- Custom overlay panel using MznPopper -->
<div #triggerEl (click)="isOpen = !isOpen">Open Panel</div>

<div
  mznPopper
  [anchor]="triggerEl"
  [open]="isOpen"
  placement="bottom-start"
  [offsetOptions]="{ mainAxis: 8 }"
>
  <div class="custom-panel">
    <p>Overlay content</p>
  </div>
</div>
```

```ts
import { MznPopper } from '@mezzanine-ui/ng/popper';
import { flip, shift } from '@floating-ui/dom';
import type { Middleware } from '@floating-ui/dom';

isOpen = false;

readonly extraMiddleware: ReadonlyArray<Middleware> = [flip(), shift()];
```

## Notes

- `MznPopper` uses `autoUpdate` from `@floating-ui/dom` to recalculate position on scroll, resize, and reference mutations while `open` is `true`.
- The component sets `position: absolute` (or `fixed`) and `top`/`left` via host styles. The host element must not be inside an ancestor with `overflow: hidden` unless `strategy='fixed'`.
- For most use cases, prefer higher-level components (`MznDropdown`, `MznTooltip`, `MznOverflowTooltip`) which configure `MznPopper` internally.
- `disableFlip` is useful for `MznOverflowTooltip` which manages its own flip logic via the `middleware` input.
