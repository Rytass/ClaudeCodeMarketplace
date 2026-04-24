# TimePanel

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/ng/time-panel) · Verified 1.0.0-rc.4 (2026-04-24)

Scrollable time column panel for hour, minute, and second selection. Used internally by `MznTimePicker` and `MznTimeRangePicker`. Requires `MZN_CALENDAR_CONFIG` for date manipulation.

## Import

```ts
import { MznTimePanel, MznTimePanelColumn } from '@mezzanine-ui/ng/time-panel';
// Also requires:
import { MZN_CALENDAR_CONFIG, createCalendarConfig } from '@mezzanine-ui/ng/calendar';
```

## Selector

`[mznTimePanel]` — component applied to a container element.

## Inputs

| Input        | Type                              | Default   | Description                                              |
| ------------ | --------------------------------- | --------- | -------------------------------------------------------- |
| `value`      | `DateType \| undefined`           | —         | Currently selected time (as a date/time value)           |
| `hideHour`   | `boolean`                         | `false`   | Hide the hour column                                     |
| `hideMinute` | `boolean`                         | `false`   | Hide the minute column                                   |
| `hideSecond` | `boolean`                         | `false`   | Hide the second column                                   |
| `hourStep`   | `number`                          | `1`       | Increment step for hours                                 |
| `minuteStep` | `number`                          | `1`       | Increment step for minutes                               |
| `secondStep` | `number`                          | `1`       | Increment step for seconds                               |
| `cellHeight` | `number`                          | (CSS var) | Height of each time cell in px                           |

> Inputs declared with signal API (`input()`, `model()`) accept both static and reactive values.

## Outputs

| Output        | Type                          | Description                                 |
| ------------- | ----------------------------- | ------------------------------------------- |
| `timeChanged` | `OutputEmitterRef<DateType>`  | Fires when hour, minute, or second changes  |
| `confirmed`   | `OutputEmitterRef<void>`      | Fires when the confirm button is clicked    |
| `cancelled`   | `OutputEmitterRef<void>`      | Fires when the cancel button is clicked     |

## DI Tokens Required

`MZN_CALENDAR_CONFIG` must be provided (see [Calendar](./Calendar.md) for setup).

## ControlValueAccessor

No — use `MznTimePicker` or `MznTimeRangePicker` for form integration.

## Usage

```html
<!-- Embedded time panel -->
<div mznTimePanel
  [value]="selectedTime"
  [hourStep]="1"
  [minuteStep]="15"
  [hideSecond]="true"
  (timeChanged)="selectedTime = $event"
  (confirmed)="onConfirm()"
  (cancelled)="onCancel()"
></div>
```

```ts
import { MznTimePanel } from '@mezzanine-ui/ng/time-panel';
import type { DateType } from '@mezzanine-ui/core/calendar';

selectedTime: DateType = '';

onConfirm(): void {
  console.log('Time confirmed:', this.selectedTime);
}
```

## Subcomponents

### MznTimePanelColumn

A single scrollable column (hour, minute, or second) inside `MznTimePanel`. Renders a button per `TimePanelUnit`, auto-scrolls to the active unit, and emits on selection. Use directly only when composing a custom time panel layout — `MznTimePanel` wires three of these together for you.

#### Selector

`[mznTimePanelColumn]` — attribute-directive component

#### Inputs — MznTimePanelColumn

| Input        | Type                                | Default                                              | Description                                              |
| ------------ | ----------------------------------- | ---------------------------------------------------- | -------------------------------------------------------- |
| `units`      | `ReadonlyArray<TimePanelUnit>` **(required)** | —                                          | List of selectable units rendered in this column         |
| `activeUnit` | `number \| undefined`               | —                                                    | Currently selected unit value; drives auto-scroll        |
| `cellHeight` | `number`                            | `getCSSVariablePixelValue('--mzn-spacing-size-element-loose', 32)` | Per-cell pixel height used for scroll positioning |

#### Outputs — MznTimePanelColumn

| Output        | Type                                    | Description                                              |
| ------------- | --------------------------------------- | -------------------------------------------------------- |
| `unitChanged` | `OutputEmitterRef<TimePanelUnit>`       | Fires when a unit button is clicked                      |

The column uses `requestAnimationFrame` + `setTimeout` to schedule scrolling after layout, so it also works when rendered inside a `display: none` popper; the first scroll uses `behavior: 'auto'` and subsequent updates use `behavior: 'smooth'`.

## Notes

- `MznTimePanel` is a low-level panel component — it does not manage trigger/popover behaviour. Use `MznTimePicker` or `MznTimeRangePicker` for a complete input field with dropdown panel.
- The `MZN_CALENDAR_CONFIG` token is required; the panel uses it to parse and manipulate time values.
- `cellHeight` defaults to a CSS custom property value (`--mzn-*`). Override only if embedding in a container with non-standard density.
- Steps (`hourStep`, `minuteStep`, `secondStep`) control which values appear in each column. A `minuteStep` of `15` renders only 0, 15, 30, 45.
