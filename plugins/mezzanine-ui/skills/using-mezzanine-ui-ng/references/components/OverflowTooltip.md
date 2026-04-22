# OverflowTooltip

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/ng/overflow-tooltip) · Verified 1.0.0-rc.3 (2026-04-21)

Floating tag panel that appears near an anchor element to display a list of tags that have overflowed their container. Uses `MznPopper` for positioning and `MznFade` for enter/exit animation. Tags can be dismissable or read-only.

## Import

```ts
import { MznOverflowTooltip, MznOverflowCounterTag } from '@mezzanine-ui/ng/overflow-tooltip';

import type { TagSize } from '@mezzanine-ui/core/tag';
import type { Placement } from '@floating-ui/dom';
```

## Selector

`[mznOverflowTooltip]` — component on a container element.

## Inputs

| Input       | Type                                         | Default        | Description                                          |
| ----------- | -------------------------------------------- | -------------- | ---------------------------------------------------- |
| `anchor`    | `HTMLElement \| ElementRef<HTMLElement>` (**required**) | —  | Anchor element the tooltip is positioned relative to |
| `tags`      | `string[]` (**required**)                   | —              | List of tag labels to render                         |
| `open`      | `boolean`                                    | `false`        | Whether the tooltip is visible                       |
| `placement` | `Placement`                                  | `'top-start'`  | Floating-UI placement; auto-flips/shifts at viewport edge |
| `readOnly`  | `boolean`                                    | `false`        | When `true`, tags are static and cannot be dismissed |
| `tagSize`   | `TagSize`                                    | `'main'`       | Size of each rendered tag                            |
| `className` | `string`                                     | —              | Extra CSS class added to the popper host             |

> Inputs declared with signal API (`input()`, `model()`) accept both static and reactive values.

## Outputs

| Output       | Type                          | Description                                          |
| ------------ | ----------------------------- | ---------------------------------------------------- |
| `tagDismiss` | `OutputEmitterRef<number>`    | Emits the index of the dismissed tag; parent must remove it from `tags` |

## ControlValueAccessor

No.

## Usage

```html
<!-- Anchor trigger + tooltip panel -->
<div class="tag-container">
  @for (tag of visibleTags; track $index) {
    <span mznTag type="dismissable" [label]="tag" (close)="removeTag($index)"></span>
  }
  @if (overflowTags.length) {
    <span #anchor mznTag type="static" [label]="'+' + overflowTags.length" (click)="isOpen = !isOpen"></span>
  }
</div>

<div mznOverflowTooltip
  [anchor]="anchor"
  [open]="isOpen"
  [tags]="overflowTags"
  [readOnly]="false"
  (tagDismiss)="removeOverflowTag($event)"
></div>
```

```ts
import { MznOverflowTooltip } from '@mezzanine-ui/ng/overflow-tooltip';

tags: string[] = ['設計', '開發', '測試', '部署', '維護', '文件'];
overflowTags: string[] = [];
isOpen = false;

removeOverflowTag(index: number): void {
  this.overflowTags = this.overflowTags.filter((_, i) => i !== index);
}
```

## MznOverflowCounterTag

`MznOverflowCounterTag` is a self-contained overflow indicator that combines an `MznTag` counter button with a `MznOverflowTooltip` panel. Clicking the counter opens the tooltip; clicking outside closes it via `ClickAwayService`.

### Selector

`[mznOverflowCounterTag]` — attribute selector applied to any container element.

### Inputs

| Input       | Type                                         | Default       | Description                                                                |
| ----------- | -------------------------------------------- | ------------- | -------------------------------------------------------------------------- |
| `tags`      | `string[]` (**required**)                    | —             | Overflow tag labels; the counter badge displays `tags.length`              |
| `disabled`  | `boolean`                                    | `false`       | Disables the counter button (click has no effect)                          |
| `className` | `string`                                     | —             | Extra CSS class passed through to the inner `MznOverflowTooltip`           |
| `placement` | `Placement`                                  | `'top-start'` | Popper placement for the tooltip panel                                     |
| `readOnly`  | `boolean`                                    | `false`       | When `true`, tags inside the tooltip are static and cannot be dismissed    |
| `tagSize`   | `TagSize`                                    | `'main'`      | Size of the counter tag and the tags inside the tooltip                    |

### Output

| Output       | Type                       | Description                                                           |
| ------------ | -------------------------- | --------------------------------------------------------------------- |
| `tagDismiss` | `OutputEmitterRef<number>` | Emits the index of the dismissed tag; parent must remove it from `tags` |

### Injected Services

`ClickAwayService` is injected and registers a click-outside listener whenever the tooltip panel is open, automatically closing it when the user clicks elsewhere.

### Usage example

```html
<!-- MznOverflowCounterTag acts as the overflow indicator button -->
<span mznOverflowCounterTag
  [tags]="overflowTags"
  placement="top-start"
  (tagDismiss)="removeOverflowTag($event)"
></span>
```

```ts
import { MznOverflowCounterTag } from '@mezzanine-ui/ng/overflow-tooltip';

overflowTags: string[] = ['設計', '開發', '測試', '部署', '維護'];

removeOverflowTag(index: number): void {
  this.overflowTags = this.overflowTags.filter((_, i) => i !== index);
}
```

---

## Notes

- The popper stays mounted until the fade-out animation completes (`onFadeExited` sets `popperOpen` to `false`). This prevents layout flicker on rapid open/close.
- After tags render, an internal `requestAnimationFrame` effect measures each row's actual width and sets an explicit `width` on the content element so multi-row tag lists align cleanly — this mirrors the React implementation exactly.
- Middleware composition (`flip` + `shift`) is placement-aware: aligned placements (`top-start`, `top-end`) prioritise `flip` before `shift`, whereas centred placements reverse the order, matching the React `OverflowTooltip` logic.
- Use `MznOverflowCounterTag` when you need a ready-made counter button + tooltip combination. Use `MznOverflowTooltip` directly when you need a custom trigger.
