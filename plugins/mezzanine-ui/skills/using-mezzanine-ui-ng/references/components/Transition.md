# Transition

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/ng/transition) · Verified 1.0.0-rc.3 (2026-04-21)

Collection of transition directives that animate CSS properties on their host element. All directives apply styles directly to the host — no wrapper element is introduced. Also exports Angular animation triggers (for use with `@trigger` syntax) and utility functions.

## Import

```ts
// Directives
import { MznFade }     from '@mezzanine-ui/ng/transition';
import { MznScale }    from '@mezzanine-ui/ng/transition';
import { MznCollapse } from '@mezzanine-ui/ng/transition';
import { MznRotate }   from '@mezzanine-ui/ng/transition';
import { MznSlide }    from '@mezzanine-ui/ng/transition';
import { MznTranslate } from '@mezzanine-ui/ng/transition';

// Animation triggers
import {
  mznFadeAnimation,
  mznScaleAnimation,
  mznCollapseAnimation,
  mznSlideRightAnimation,
  mznSlideTopAnimation,
  mznTranslateBottomAnimation,
} from '@mezzanine-ui/ng/transition';

// Utilities
import { buildTransitionString, getAutoSizeDuration } from '@mezzanine-ui/ng/transition';
import type { TransitionDuration, TransitionEasing, TransitionDelay } from '@mezzanine-ui/ng/transition';
```

## Common Inputs (MznFade, MznScale, MznSlide)

| Input       | Type                 | Default          | Description                                     |
| ----------- | -------------------- | ---------------- | ----------------------------------------------- |
| `in`        | `input<boolean>()`   | `false`          | Whether to transition to the "entered" state     |
| `appear`    | `boolean`            | `true`           | Animate on first mount if `in=true`              |
| `duration`  | `TransitionDuration` | design-token based | `{ enter: number, exit: number }` in ms        |
| `easing`    | `TransitionEasing`   | design-token based | `{ enter: string, exit: string }` CSS easing  |
| `delay`     | `TransitionDelay`    | `0`              | `{ enter?: number, exit?: number }` or `number` |
| `keepMount` | `boolean`            | `false`          | When `true`, DOM stays mounted when exited       |

> **Note:** `MznFade` and `MznScale` declare `in` as `model<boolean>()` (two-way bindable with `[(in)]`). `MznSlide` declares `in` as plain `input(false)` — one-way only. `MznCollapse` also declares `in` as plain `input(false)`.

## Common Outputs (MznFade, MznScale, MznCollapse, MznSlide)

| Output      | Type                                                         | Description                       |
| ----------- | ------------------------------------------------------------ | --------------------------------- |
| `onEnter`   | `OutputEmitterRef<{ element: HTMLElement; isAppearing: boolean }>` | Transition enter starts     |
| `onEntered` | `OutputEmitterRef<{ element: HTMLElement; isAppearing: boolean }>` | Transition enter completes  |
| `onExit`    | `OutputEmitterRef<{ element: HTMLElement }>`                 | Transition exit starts            |
| `onExited`  | `OutputEmitterRef<{ element: HTMLElement }>`                 | Transition exit completes         |

## MznCollapse — Inputs

`MznCollapse` is a **component** (not a directive) — it wraps content in a height-animating container.

| Input            | Type                | Default    | Description                                                |
| ---------------- | ------------------- | ---------- | ---------------------------------------------------------- |
| `in`             | `input<boolean>()`  | `false`    | Plain one-way input; use `[in]="expr"` (no `[(in)]`)      |
| `collapsedHeight`| `string \| number`  | `0`        | Container height when collapsed (e.g. `'48px'` or `0`)    |
| `duration`       | `TransitionDuration`| `'auto'`   | `'auto'` derives duration from content height              |
| `easing`         | `TransitionEasing`  | design-token based | `{ enter: string, exit: string }` CSS easing       |
| `delay`          | `TransitionDelay`   | `0`        | Transition delay                                           |
| `keepMount`      | `boolean`           | `false`    | Keep DOM when exited (forced `true` when `collapsedHeight ≠ '0px'`) |

## MznCollapse — Outputs

In addition to the common outputs (`onEnter`, `onEntered`, `onExit`, `onExited`), `MznCollapse` also emits:

| Output       | Type                                                                     | Description                        |
| ------------ | ------------------------------------------------------------------------ | ---------------------------------- |
| `onEntering` | `OutputEmitterRef<{ element: HTMLElement; isAppearing: boolean }>`       | Fired during the entering phase    |
| `onExiting`  | `OutputEmitterRef<{ element: HTMLElement }>`                             | Fired during the exiting phase     |

## MznScale — Additional Inputs

| Input             | Type     | Default    | Description                   |
| ----------------- | -------- | ---------- | ----------------------------- |
| `transformOrigin` | `string` | `'center'` | CSS `transform-origin` value  |
| + common inputs   |          |            |                               |

## MznRotate — Inputs

| Input             | Type      | Default         | Description                             |
| ----------------- | --------- | --------------- | --------------------------------------- |
| `in`              | `boolean` | `false`         | Rotated state; plain `input` (no lifecycle outputs, no `model`) |
| `degrees`         | `number`  | `180`           | Rotation in degrees when `in=true`      |
| `duration`        | `number`  | fast token      | Transition duration in ms               |
| `easing`          | `string`  | standard easing | CSS easing function                     |
| `transformOrigin` | `string`  | `'center'`      | CSS `transform-origin`                  |

## MznSlide — Inputs

| Input    | Type        | Default   | Description                  |
| -------- | ----------- | --------- | ---------------------------- |
| `from`   | `SlideFrom` | `'right'` | `'right' \| 'top'`           |
| + common inputs (see above) |   |           |                              |

> `SlideFrom` is `'right' | 'top'` only — `'left'` and `'bottom'` are not supported.

## MznTranslate — Inputs

`MznTranslate` animates `transform` (small 4 px offset) + `opacity` on the host element.

| Input       | Type             | Default    | Description                                                           |
| ----------- | ---------------- | ---------- | --------------------------------------------------------------------- |
| `from`      | `model<TranslateFrom>()` | `'top'` | Entry direction; `'top' \| 'bottom' \| 'left' \| 'right'`; **two-way bindable** |
| `in`        | `model<boolean>()`| `false`   | Two-way bindable trigger                                              |
| `duration`  | `TransitionDuration` | design-token based | `{ enter: number, exit: number }` in ms                   |
| `easing`    | `TransitionEasing` | design-token based | `{ enter: string, exit: string }` CSS easing             |
| `delay`     | `TransitionDelay`| `0`        | Transition delay                                                      |
| `keepMount` | `boolean`        | `false`    | Keep DOM when exited                                                  |

## MznTranslate — Outputs

Same common outputs as other directives: `onEnter`, `onEntered`, `onExit`, `onExited`.

## ControlValueAccessor

No.

## Usage

```html
<!-- Fade in/out an overlay -->
<div
  mznFade
  [(in)]="isVisible"
  [duration]="{ enter: 200, exit: 150 }"
  (onExited)="onFadeExited()"
>
  <div class="overlay">內容</div>
</div>

<!-- Scale transition for a menu -->
<div mznScale [(in)]="isMenuOpen">
  <ul class="menu">...</ul>
</div>

<!-- Rotate a chevron icon: mznRotate goes on the wrapper, not on the mznIcon element -->
<span mznRotate [in]="isExpanded" [degrees]="180">
  <i mznIcon [icon]="chevronIcon"></i>
</span>

<!-- Or directly on the icon element (common shorthand) -->
<i mznIcon mznRotate [in]="isExpanded" [icon]="chevronIcon"></i>

<!-- Slide from right (e.g. drawer) -->
<div mznSlide [(in)]="isDrawerOpen" from="right">
  <aside class="drawer">...</aside>
</div>
```

```ts
import { MznFade, MznScale } from '@mezzanine-ui/ng/transition';

isVisible = false;

onFadeExited(): void {
  // Safe to unmount after animation completes
  this.shouldRender = false;
}
```

### Angular animation trigger (alternative)

```ts
import { Component } from '@angular/core';
import { mznFadeAnimation } from '@mezzanine-ui/ng/transition';

@Component({
  animations: [mznFadeAnimation],
  template: `<div [@mznFade]="isVisible ? 'visible' : 'hidden'">Content</div>`,
})
export class MyComponent {
  isVisible = false;
}
```

## Notes

- `in` is declared as `model<boolean>()` on `MznFade`, `MznScale`, and `MznTranslate` — enabling two-way binding with `[(in)]`. On `MznSlide` and `MznCollapse` it is a plain `input(false)`, so use one-way `[in]="expr"` only.
- `from` on `MznTranslate` is also a `model<TranslateFrom>()` — two-way bindable. On `MznSlide` it is a plain `input`.
- `SlideFrom` is `'right' | 'top'` — `'left'` and `'bottom'` are not valid values.
- Directives animate the **host element** directly — no wrapper `<div>` is inserted. This is essential for layout contexts (flex, grid, absolute positioning) where an extra element would break the visual result.
- `keepMount=false` (default): the host is removed from the DOM after the exit animation completes (via `visibility: hidden` + `onExited`). Set `keepMount=true` to keep it in the DOM (e.g. for performance with frequently toggled elements).
- `MznRotate` is lighter-weight — it has no lifecycle outputs, only `in` (plain `input<boolean>`, not `model`). Apply `mznRotate` to the element you want to rotate; `[icon]` is an `MznIcon` input and should not be placed on the `mznRotate` host unless that element also carries `mznIcon`.
- `MznCollapse` is a `@Component` (not a `@Directive`) — it renders a wrapper element with `display: contents`, so it does not affect layout directly. Its `in` is a plain `input`, not a `model`.
- `MznCollapse` exposes `onEntering` and `onExiting` outputs in addition to the common `onEnter`/`onEntered`/`onExit`/`onExited`.
- The Angular animation triggers (e.g. `mznFadeAnimation`) are for use with Angular's `@angular/animations` engine when you need AOT-compiled animations.
