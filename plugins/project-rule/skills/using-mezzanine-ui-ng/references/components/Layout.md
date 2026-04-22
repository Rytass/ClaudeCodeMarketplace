# Layout

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/ng/layout) · Verified 1.0.0-rc.3 (2026-04-21)

Application shell layout container. Slots a `MznNavigation`, optional left/right side panels, and the main content area. Uses named `ng-content` projections to position each zone.

## Import

```ts
import {
  MznLayout,
  MznLayoutMain,
  MznLayoutLeftPanel,
  MznLayoutRightPanel,
} from '@mezzanine-ui/ng/layout';
```

## Selectors

| Selector                 | Role                                           |
| ------------------------ | ---------------------------------------------- |
| `[mznLayout]`            | Root application shell container               |
| `[mznLayoutMain]`        | Primary scrollable content area                |
| `[mznLayoutLeftPanel]`   | Collapsible left side panel                    |
| `[mznLayoutRightPanel]`  | Collapsible right side panel                   |

## MznLayout — Inputs

| Input                    | Type                  | Default | Description                                              |
| ------------------------ | --------------------- | ------- | -------------------------------------------------------- |
| `contentWrapperClassName`| `string \| undefined` | —       | Extra CSS class on the content wrapper `<div>`           |
| `navigationClassName`    | `string \| undefined` | —       | Extra CSS class on the navigation wrapper `<div>`        |

## MznLayoutMain — Inputs

| Input                 | Type                  | Default | Description                                            |
| --------------------- | --------------------- | ------- | ------------------------------------------------------ |
| `className`           | `string \| undefined` | —       | Extra CSS class                                        |
| `scrollbarDisabled`   | `boolean`             | `false` | Disable custom scrollbar                               |
| `scrollbarMaxHeight`  | `string \| undefined` | —       | Max height for scrollbar container (CSS value)         |
| `scrollbarMaxWidth`   | `string \| undefined` | —       | Max width for scrollbar container (CSS value)          |

## MznLayoutLeftPanel — Inputs

| Input                | Type                  | Default | Description                                              |
| -------------------- | --------------------- | ------- | -------------------------------------------------------- |
| `defaultWidth`       | `number`              | `320`   | Initial panel width in px (clamped to min 240)           |
| `open`               | `boolean`             | `false` | Whether the panel is visible                             |
| `scrollbarDisabled`  | `boolean`             | `false` | Disable custom scrollbar (fall back to native)           |
| `scrollbarMaxHeight` | `string \| undefined` | —       | Max height for the inner scrollbar container             |
| `scrollbarMaxWidth`  | `string \| undefined` | —       | Max width for the inner scrollbar container              |

## MznLayoutLeftPanel — Outputs

| Output        | Type              | Description                                          |
| ------------- | ----------------- | ---------------------------------------------------- |
| `widthChange` | `output<number>()` | Emitted on divider drag and on keyboard resize steps |

## MznLayoutRightPanel — Inputs

| Input                | Type                  | Default | Description                                              |
| -------------------- | --------------------- | ------- | -------------------------------------------------------- |
| `defaultWidth`       | `number`              | `320`   | Initial panel width in px (clamped to min 240)           |
| `open`               | `boolean`             | `false` | Whether the panel is visible                             |
| `scrollbarDisabled`  | `boolean`             | `false` | Disable custom scrollbar (fall back to native)           |
| `scrollbarMaxHeight` | `string \| undefined` | —       | Max height for the inner scrollbar container             |
| `scrollbarMaxWidth`  | `string \| undefined` | —       | Max width for the inner scrollbar container              |

## MznLayoutRightPanel — Outputs

| Output        | Type              | Description                                          |
| ------------- | ----------------- | ---------------------------------------------------- |
| `widthChange` | `output<number>()` | Emitted on divider drag and on keyboard resize steps |

> Inputs declared with signal API (`input()`, `model()`) accept both static and reactive values.

## Content Projection Slots

| Slot selector            | Projected zone        |
| ------------------------ | --------------------- |
| `[mznNavigation]`        | Top navigation bar    |
| `[mznLayoutLeftPanel]`   | Left side panel       |
| `[mznLayoutMain]`        | Main content          |
| `[mznLayoutRightPanel]`  | Right side panel      |

## ControlValueAccessor

No.

## Usage

```html
<div mznLayout>
  <!-- Navigation bar -->
  <nav mznNavigation [collapsed]="navCollapsed" (collapseChange)="navCollapsed = $event">
    <header mznNavigationHeader title="My App"></header>
    <mzn-navigation-option title="首頁" href="/" [icon]="homeIcon" />
  </nav>

  <!-- Optional left panel -->
  <aside mznLayoutLeftPanel [open]="leftPanelOpen" [defaultWidth]="320" (widthChange)="onLeftPanelWidthChange($event)">
    <p>Side content</p>
  </aside>

  <!-- Main content -->
  <div mznLayoutMain [scrollbarDisabled]="false">
    <router-outlet></router-outlet>
  </div>

  <!-- Optional right panel -->
  <aside mznLayoutRightPanel [open]="rightPanelOpen">
    <p>Right panel content</p>
  </aside>
</div>
```

```ts
import {
  MznLayout,
  MznLayoutMain,
  MznLayoutLeftPanel,
  MznLayoutRightPanel,
} from '@mezzanine-ui/ng/layout';

navCollapsed = false;
leftPanelOpen = true;
rightPanelOpen = false;

onLeftPanelWidthChange(width: number): void {
  console.log('Left panel resized to', width);
}
```

## Notes

- `MznLayoutMain` wraps its content in a `MznScrollbar` container. Set `scrollbarDisabled=true` if you manage scrolling yourself.
- `MznLayoutLeftPanel` and `MznLayoutRightPanel` are toggled via the `open` input. Their animation/transition is handled internally.
- Both panels contain a draggable divider for resizing. Drag the divider with the mouse to adjust the panel width. Minimum width is `240px`; maximum is constrained by the main content area's available space above `480px`. When the divider is focused, keyboard resize works in ±10px steps — **LeftPanel**: ArrowRight widens, ArrowLeft narrows; **RightPanel**: ArrowLeft widens, ArrowRight narrows (each key pushes the divider away from the main content toward its panel side).
- The layout expects `[mznNavigation]` to be a `<nav>` element with the `mznNavigation` directive — the content is projected into a wrapper div that controls top positioning.
- There is no `MznLayoutFooter` component — use `MznPageFooter` from `@mezzanine-ui/ng/page-footer` if a full-width footer is needed.
