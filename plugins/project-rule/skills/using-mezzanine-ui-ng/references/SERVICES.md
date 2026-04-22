# Mezzanine-UI Angular Services & DI Tokens

> Baseline: `@mezzanine-ui/ng` `1.0.0-rc.3` · Last verified 2026-04-21.

Angular DI services exported from `@mezzanine-ui/ng/services`. They replace
React's hook abstractions (`useClickAway`, `useWindowWidth`, etc.) with
`providedIn: 'root'` singletons that integrate with Angular's `DestroyRef`
for automatic cleanup.

---

## Import

```ts
import {
  ClickAwayService,
  EscapeKeyService,
  ScrollLockService,
  TopStackService,
  WindowWidthService,
} from '@mezzanine-ui/ng/services';
```

---

## ClickAwayService

**Purpose**: Detects clicks occurring **outside** a container element (or a set
of containers). Listens at the document **capture phase**, so inner
`stopPropagation()` calls cannot suppress it. Registration is deferred one
animation frame so the triggering click that opened a dropdown does not
immediately close it.

**React equivalent**: `useClickAway` / `useDocumentEvents`.

### Method signature

```ts
listen(
  containers: HTMLElement | readonly (HTMLElement | null | undefined)[],
  handler: (event: MouseEvent | TouchEvent | PointerEvent) => void,
  destroyRef?: DestroyRef,
): () => void   // returns cleanup fn
```

| Parameter     | Type                                                 | Description                              |
| ------------- | ---------------------------------------------------- | ---------------------------------------- |
| `containers`  | `HTMLElement \| readonly (HTMLElement \| null \| undefined)[]` | One or more container elements |
| `handler`     | `ClickAwayHandler`                                   | Called on every outside click/touch      |
| `destroyRef`  | `DestroyRef` (optional)                              | Auto-cleanup on component destroy        |

### Usage example

```ts
import { Component, DestroyRef, ElementRef, inject, signal } from '@angular/core';
import { ClickAwayService } from '@mezzanine-ui/ng/services';

@Component({ selector: 'app-dropdown', standalone: true, template: `...` })
export class DropdownComponent {
  private readonly el = inject(ElementRef<HTMLElement>);
  private readonly clickAway = inject(ClickAwayService);
  private readonly destroyRef = inject(DestroyRef);

  protected readonly open = signal(false);

  toggleOpen(): void {
    if (!this.open()) {
      this.open.set(true);
      // Pass DestroyRef so listener is removed when component is destroyed
      this.clickAway.listen(this.el.nativeElement, () => {
        this.open.set(false);
      }, this.destroyRef);
    }
  }
}
```

**Multi-container tip** (host element + portalled popper):

```ts
this.clickAway.listen(
  [this.hostEl.nativeElement, this.popperEl.nativeElement],
  () => this.open.set(false),
  this.destroyRef,
);
```

---

## EscapeKeyService

**Purpose**: Registers a document-level `keydown` listener that fires only on
`Escape`. Calls `event.preventDefault()` automatically. Multiple listeners are
stacked — combine with `TopStackService.isTop()` to ensure only the topmost
overlay closes on each Escape press (LIFO unwind).

**React equivalent**: `useEscapeKey`.

### Method signature

```ts
listen(
  handler: (event: KeyboardEvent) => void,
  destroyRef?: DestroyRef,
): () => void   // returns cleanup fn
```

### Usage example

```ts
import { Component, DestroyRef, inject, signal } from '@angular/core';
import { EscapeKeyService, TopStackService } from '@mezzanine-ui/ng/services';

@Component({ selector: 'app-modal', standalone: true, template: `...` })
export class ModalComponent {
  private readonly escapeKey = inject(EscapeKeyService);
  private readonly topStack = inject(TopStackService);
  private readonly destroyRef = inject(DestroyRef);

  protected readonly open = signal(false);

  ngOnInit(): void {
    const entry = this.topStack.register();
    this.destroyRef.onDestroy(() => entry.unregister());

    this.escapeKey.listen((event) => {
      // Only close if this modal is the topmost overlay
      if (entry.isTop()) {
        this.open.set(false);
      }
    }, this.destroyRef);
  }
}
```

---

## ScrollLockService

**Purpose**: Locks and unlocks page scrolling with **nested lock support**
(reference-counted). Reserves scrollbar width to prevent layout shift.
Handles iOS Safari rubber-band scrolling via `position: fixed` + `top` trick.

**React equivalent**: `useScrollLock` / `body-scroll-lock`.

### Method signatures

```ts
lock(reserveScrollBarGap?: boolean): void    // default: true
unlock(): void
```

| Method   | Description                                                      |
| -------- | ---------------------------------------------------------------- |
| `lock()` | Increments lock count; freezes `document.body` scroll           |
| `unlock()` | Decrements lock count; restores styles when count reaches 0  |

### Usage example

```ts
import { Component, DestroyRef, inject, OnInit } from '@angular/core';
import { ScrollLockService } from '@mezzanine-ui/ng/services';

@Component({ selector: 'app-overlay', standalone: true, template: `...` })
export class OverlayComponent implements OnInit {
  private readonly scrollLock = inject(ScrollLockService);
  private readonly destroyRef = inject(DestroyRef);

  ngOnInit(): void {
    this.scrollLock.lock();
    // Always unlock on destroy — even if the component is removed unexpectedly
    this.destroyRef.onDestroy(() => this.scrollLock.unlock());
  }
}
```

> Nested modals each call `lock()` independently. Only the last `unlock()`
> restores scroll — no manual counting needed.

---

## TopStackService

**Purpose**: Manages z-index stacking order for multiple floating layers
(modals, drawers, tooltips). Each registrant gets an entry with `isTop()` to
check whether it is the frontmost layer.

**React equivalent**: `useTopOfStack` / custom context stacks.

### Method signature

```ts
register(): TopStackEntry
```

```ts
interface TopStackEntry {
  readonly isTop: () => boolean;   // true when this is the topmost entry
  readonly unregister: () => void; // removes this entry from the stack
}
```

### Usage example

```ts
import { Component, DestroyRef, inject } from '@angular/core';
import { TopStackService } from '@mezzanine-ui/ng/services';

@Component({ selector: 'app-dialog', standalone: true, template: `...` })
export class DialogComponent {
  private readonly topStack = inject(TopStackService);
  private readonly destroyRef = inject(DestroyRef);

  private stackEntry = this.topStack.register();

  constructor() {
    this.destroyRef.onDestroy(() => this.stackEntry.unregister());
  }

  protected shouldHandleEscape(): boolean {
    return this.stackEntry.isTop();
  }
}
```

> Use alongside `EscapeKeyService` — only act on Escape when `isTop()` is true.

---

## WindowWidthService

**Purpose**: Tracks the current `window.innerWidth` as a reactive **signal**.
SSR-safe (returns `undefined` when `window` is unavailable). A single
`resize` listener is shared across all consumers.

**React equivalent**: `useWindowWidth` or a custom `resize` hook.

### Signal & method

```ts
readonly width: Signal<number | undefined>   // current window.innerWidth

startListening(destroyRef?: DestroyRef): void
// Call once from an injection context to activate the resize listener.
// Subsequent calls are no-ops (guarded by `this.listening`).
```

### Usage example — responsive breakpoint tracking

```ts
import { Component, computed, DestroyRef, inject, OnInit } from '@angular/core';
import { WindowWidthService } from '@mezzanine-ui/ng/services';

@Component({
  selector: 'app-responsive-panel',
  standalone: true,
  template: `
    @if (isMobile()) {
      <p>Mobile view</p>
    } @else {
      <p>Desktop view</p>
    }
  `,
})
export class ResponsivePanelComponent implements OnInit {
  private readonly windowWidth = inject(WindowWidthService);
  private readonly destroyRef = inject(DestroyRef);

  /** Start listening — safe to call multiple times. */
  ngOnInit(): void {
    this.windowWidth.startListening(this.destroyRef);
  }

  protected readonly isMobile = computed(
    (): boolean => (this.windowWidth.width() ?? Infinity) < 768,
  );
}
```

---

## DI Tokens

### MZN_CALENDAR_CONFIG

| Property      | Value                           |
| ------------- | ------------------------------- |
| **Source**    | `@mezzanine-ui/ng/calendar`     |
| **Token type**| `InjectionToken<CalendarConfigs>` |
| **Purpose**   | Supplies `CalendarMethods`, locale, and default date/time formats to all Calendar / Picker sub-components |

All date picker and calendar components consume this token internally.
You must provide it (or `MznCalendarConfigProvider`) whenever using:
`MznDatePicker`, `MznDateRangePicker`, `MznDateTimePicker`,
`MznDateTimeRangePicker`, `MznMultipleDatePicker`, `MznTimePicker`,
`MznCalendar`.

#### Option A — Template directive (recommended for lazy tree-shaking)

```ts
import { MznCalendarConfigProvider } from '@mezzanine-ui/ng/calendar';
import CalendarMethodsDayjs from '@mezzanine-ui/core/calendarMethodsDayjs';

@Component({
  imports: [MznCalendarConfigProvider, MznDatePicker],
  template: `
    <div mznCalendarConfigProvider [methods]="methods" locale="zh-TW">
      <div mznDatePicker [formControl]="ctrl" />
    </div>
  `,
})
export class PageComponent {
  protected readonly methods = CalendarMethodsDayjs;
}
```

#### Option B — ApplicationConfig providers (global, recommended for most apps)

```ts
import { ApplicationConfig } from '@angular/core';
import { MZN_CALENDAR_CONFIG, createCalendarConfig, CalendarLocale } from '@mezzanine-ui/ng/calendar';
import CalendarMethodsDayjs from '@mezzanine-ui/core/calendarMethodsDayjs';

export const appConfig: ApplicationConfig = {
  providers: [
    {
      provide: MZN_CALENDAR_CONFIG,
      useValue: createCalendarConfig(CalendarMethodsDayjs, {
        locale: CalendarLocale.ZH_TW,
        defaultDateFormat: 'YYYY/MM/DD',
        defaultTimeFormat: 'HH:mm',
      }),
    },
  ],
};
```

#### CalendarConfigs interface

```ts
interface CalendarConfigs extends CalendarMethods {
  readonly defaultDateFormat: string;   // default 'YYYY-MM-DD'
  readonly defaultTimeFormat: string;   // default 'HH:mm:ss'
  readonly locale: string;              // normalized lowercase, e.g. 'zh-tw'
}
```

---

### MZN_NAVIGATION_ACTIVATED / MZN_NAVIGATION_OPTION_LEVEL

| Token                          | Source                          | Purpose                                                    |
| ------------------------------ | ------------------------------- | ---------------------------------------------------------- |
| `MZN_NAVIGATION_ACTIVATED`     | `@mezzanine-ui/ng/navigation`   | Carries activated path, collapse state, filter text        |
| `MZN_NAVIGATION_OPTION_LEVEL`  | `@mezzanine-ui/ng/navigation`   | Carries nesting level and path prefix for option ancestors |

These are **internal** tokens provided automatically by `MznNavigation`.
Do not provide them manually unless building a custom navigation wrapper.

---

### MZN_BUTTON_GROUP

| Token             | Source                       | Purpose                                                         |
| ----------------- | ---------------------------- | --------------------------------------------------------------- |
| `MZN_BUTTON_GROUP`| `@mezzanine-ui/ng/button`    | Shares `variant`, `size`, `disabled` defaults to child buttons |

Provided automatically by `MznButtonGroup`. Internal — do not provide manually.

---

### Other Context Tokens (Internal)

| Token                             | Source                           |
| --------------------------------- | -------------------------------- |
| `MZN_ACCORDION_GROUP`             | `@mezzanine-ui/ng/accordion`     |
| `MZN_CHECKBOX_GROUP`              | `@mezzanine-ui/ng/checkbox`      |
| `MZN_RADIO_GROUP`                 | `@mezzanine-ui/ng/radio`         |
| `MZN_STEPPER_CONTEXT`             | `@mezzanine-ui/ng/stepper`       |
| `MZN_TAB_CONTEXT`                 | `@mezzanine-ui/ng/tab`           |
| `MZN_DESCRIPTION_CONTEXT`         | `@mezzanine-ui/ng/description`   |
| `MZN_TABLE_CONTEXT`               | `@mezzanine-ui/ng/table`         |
| `MZN_FILTER_AREA_CONTEXT`         | `@mezzanine-ui/ng/filter-area`   |
| `MZN_MODAL_CONTEXT`               | `@mezzanine-ui/ng/modal`         |

All of the above are provided by their parent component via the Angular DI
hierarchy and consumed by child components. They are **not** part of the
public API surface for application developers.

---

## Summary Comparison: Services vs React Hooks

| Angular Service          | React Equivalent             | Key difference                            |
| ------------------------ | ----------------------------- | ----------------------------------------- |
| `ClickAwayService`       | `useClickAway`                | Capture-phase; multi-container; async     |
| `EscapeKeyService`       | `useEscapeKey`                | Flat listener; combine w/ `TopStackService` for LIFO |
| `ScrollLockService`      | `useScrollLock` / body-scroll-lock | Reference-counted; iOS safe          |
| `TopStackService`        | custom context / portals      | Explicit `register()`/`unregister()`      |
| `WindowWidthService`     | `useWindowWidth`              | Signal-based; single shared listener      |
