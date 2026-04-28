---
name: using-mezzanine-ui-ng
description: Angular 21+ Mezzanine-UI skill — create, edit, or style standalone Angular components with @mezzanine-ui/ng (1.0.0-rc.4, RC tier) directives. Covers directive-based selectors (mznButton, mznInput, mznSelect, mznTextField, mznFormField, mznModal, mznTable, mznNavigation), ControlValueAccessor + ReactiveFormsModule integration, DI services (ClickAwayService, EscapeKeyService, MZN_CALENDAR_CONFIG), sub-path imports, design tokens. Use when working on *.component.ts, *.component.html, *.component.scss files that import from @mezzanine-ui/ng/*, building Angular reactive forms with mznFormField + formControlName, wiring Mezzanine directives into standalone components, or configuring Angular global SCSS. Trigger — Angular, standalone component, mzn directive, ControlValueAccessor, ReactiveForms, mezzanine-ui/ng, ng form, ng select, ng table, ng modal. For React / Next.js projects use the sibling using-mezzanine-ui-react skill instead.
---

# Mezzanine-UI Angular (`@mezzanine-ui/ng`)

**Core principle: For Angular 21+ standalone projects, prefer `@mezzanine-ui/ng` directives over custom Angular implementations.**

> Baseline: `@mezzanine-ui/ng` `1.0.0-rc.4` · `@mezzanine-ui/core` `1.0.4` · `@mezzanine-ui/system` `1.0.2` · `@mezzanine-ui/icons` `1.0.2`. Last verified: 2026-04-24.
>
> **⚠️ RC tier** — `@mezzanine-ui/ng` is in Release Candidate. API may still shift minor details before `1.0.0` stable. Check `npm view @mezzanine-ui/ng versions` for the latest.

> **For React (Next.js) projects** see the companion skill [`using-mezzanine-ui-react`](../using-mezzanine-ui-react/SKILL.md). Design tokens, icons, and Figma mappings are shared.

## What's New in 1.0.0-rc.4

**純版本對齊（No Angular source changes）**

`@mezzanine-ui/ng@1.0.0-rc.4` is a compatibility bump paired with `@mezzanine-ui/core@1.0.4`. Zero Angular source files changed in this cycle.

- **Pair with `@mezzanine-ui/core@1.0.4`** — the core release fixed React-side picker positioning (globalPortal + flip). Angular was already correct: `MznInputTriggerPopper` ships with `globalPortal=true` and `MznPopper` enables `flip()` by default, so no behaviour change on the Angular side.
- **No prop changes** — 0 component APIs modified.
- **Deprecation: `ThumbnailCards`** — the `thumbnail-cards` package is removed. Use the individual replacement components instead:
  - `MznSingleThumbnailCard` (`@mezzanine-ui/ng/single-thumbnail-card`)
  - `MznFourThumbnailCard` (`@mezzanine-ui/ng/four-thumbnail-card`)
  - `MznSingleThumbnailCardSkeleton` / `MznFourThumbnailCardSkeleton`
  - `MznQuickActionCard` (`@mezzanine-ui/ng/quick-action-card`)

**升級方式 (upgrade)**:

```bash
yarn add @mezzanine-ui/ng@1.0.0-rc.4 @mezzanine-ui/core@1.0.4
```

## Resource Overview

| Type                 | Resource                                                                | Purpose                                |
| -------------------- | ----------------------------------------------------------------------- | -------------------------------------- |
| **Frontend Package** | [GitHub — packages/ng](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/ng) | Angular component source       |
| **Angular Storybook** | [storybook-ng.mezzanine-ui.org](https://storybook-ng.mezzanine-ui.org) | Angular component examples (if hosted) |
| **Figma Components** | [Component File](https://www.figma.com/design/gjGdP49GQZzOeQf0bNOFlt)   | Shared with React — canonical design   |

---

## Quick Start

### Installation

```bash
yarn add @mezzanine-ui/ng @mezzanine-ui/core @mezzanine-ui/system @mezzanine-ui/icons
```

Angular peer dependencies required:

```
@angular/core >= 21.0.0
@angular/common >= 21.0.0
@angular/cdk >= 21.0.0
@angular/animations >= 21.0.0
@angular/forms >= 21.0.0
```

### Global SCSS Setup

`src/styles.scss` — **identical to React** because `@mezzanine-ui/core` and `/system` are shared:

```scss
@use '@mezzanine-ui/system' as mzn-system;
@use '@mezzanine-ui/core' as mezzanine;

:root {
  @include mzn-system.colors('light');
  @include mzn-system.common-variables(default);
}

[data-theme='dark'] {
  @include mzn-system.colors('dark');
}

[data-density='compact'] {
  @include mzn-system.common-variables(compact);
}

@include mezzanine.styles();
```

> If your Angular project uses the `~` tilde prefix in SCSS, drop it — `@use '@mezzanine-ui/system'` works out-of-the-box with Angular CLI / Nx.

### Bootstrap (standalone app)

Mezzanine does **not** require an `ApplicationConfig` provider. Mezzanine directives are imported per-component via `imports: [...]`.

```ts
// main.ts
import { bootstrapApplication } from '@angular/platform-browser';
import { appConfig } from './app/app.config';
import { App } from './app/app';

bootstrapApplication(App, appConfig).catch(err => console.error(err));
```

```ts
// app.config.ts — nothing Mezzanine-specific required
export const appConfig: ApplicationConfig = {
  providers: [
    provideBrowserGlobalErrorListeners(),
    provideZoneChangeDetection({ eventCoalescing: true }),
    provideRouter(appRoutes),
    provideHttpClient(withFetch()),
  ],
};
```

### Basic Usage Example

```ts
// login.page.ts
import { Component } from '@angular/core';
import { ReactiveFormsModule, FormBuilder, Validators } from '@angular/forms';
import { MznButton } from '@mezzanine-ui/ng/button';
import { MznFormField } from '@mezzanine-ui/ng/form';
import { MznInput } from '@mezzanine-ui/ng/input';
import { MznIcon } from '@mezzanine-ui/ng/icon';
import { FormFieldLayout } from '@mezzanine-ui/core/form';
import { UserIcon } from '@mezzanine-ui/icons';

@Component({
  selector: 'app-login-page',
  imports: [ReactiveFormsModule, MznButton, MznFormField, MznInput, MznIcon],
  templateUrl: './login.page.html',
})
export class LoginPage {
  protected readonly userIcon = UserIcon;
  protected readonly verticalLayout = FormFieldLayout.VERTICAL;

  protected readonly loginForm = this.fb.group({
    account: ['', [Validators.required]],
    password: ['', [Validators.required]],
  });

  constructor(private fb: FormBuilder) {}
}
```

```html
<!-- login.page.html -->
<form [formGroup]="loginForm">
  <div mznFormField name="account" label="帳號" [layout]="verticalLayout">
    <div mznInput variant="base" placeholder="Enter account" [fullWidth]="true" formControlName="account">
      <i mznIcon [icon]="userIcon" [size]="16" slot="prefix"></i>
    </div>
  </div>

  <button mznButton type="submit" variant="base-primary" [disabled]="loginForm.invalid">
    登入
  </button>
</form>
```

### Calendar / Date Provider

Angular date components read config via the `MZN_CALENDAR_CONFIG` DI token. There are two ways to supply it:

**Option A — `ApplicationConfig` provider (recommended for most apps):**

```ts
// app.config.ts
import { provide } from '@angular/core';
import {
  MZN_CALENDAR_CONFIG,
  createCalendarConfig,
  CalendarLocale,
} from '@mezzanine-ui/ng/calendar';
import CalendarMethodsDayjs from '@mezzanine-ui/core/calendarMethodsDayjs';

export const appConfig: ApplicationConfig = {
  providers: [
    // ...
    {
      provide: MZN_CALENDAR_CONFIG,
      useValue: createCalendarConfig(CalendarMethodsDayjs, {
        locale: CalendarLocale.ZH_TW,
      }),
    },
  ],
};
```

**Option B — `MznCalendarConfigProvider` host directive (for per-subtree overrides):**

`MznCalendarConfigProvider` is a **directive** (not a factory function). Apply it to any host element to scope a calendar config to its subtree:

```ts
import { MznCalendarConfigProvider } from '@mezzanine-ui/ng/calendar';
import CalendarMethodsDayjs from '@mezzanine-ui/core/calendarMethodsDayjs';

@Component({
  imports: [MznCalendarConfigProvider, MznDatePicker],
  template: `
    <div mznCalendarConfigProvider [methods]="dayjsMethods" locale="zh-TW">
      <div mznDatePicker [(ngModel)]="date"></div>
    </div>
  `,
})
export class ExamplePage {
  protected readonly dayjsMethods = CalendarMethodsDayjs;
}
```

> Equivalent of React's `<CalendarConfigProvider>`. Date internals use DayJS by default (no extra adapter wiring needed beyond the methods import).

---

## Architecture Overview

### Directive-based selectors

Mezzanine-ng components are **standalone directives / components** that attach to semantic HTML:

| Selector | Usage example | Meaning |
| -------- | ------------- | ------- |
| `[mznButton]`     | `<button mznButton variant="base-primary">`        | Attribute directive on native `<button>` / `<a>` |
| `[mznInput]`      | `<div mznInput formControlName="x">`               | Component wrapping a native `<input>` internally |
| `[mznFormField]`  | `<div mznFormField name="account" label="帳號">`  | Wrapper providing label, hint, error slots |
| `[mznIcon]`       | `<i mznIcon [icon]="userIcon" [size]="16">`       | Attribute directive on `<i>` |
| `[mznModal]`      | `<section mznModal>`                               | Component rendering the modal chrome |
| `<mzn-navigation-option>` | Custom element tag                         | A small number of components use tag selectors |

### ControlValueAccessor + ReactiveForms

Form inputs implement `ControlValueAccessor`, so they bind via `formControlName` / `[(ngModel)]` / `[formControl]` like any Angular control:

```html
<div mznInput [formControl]="usernameCtrl"></div>
<div mznSelect [formControl]="statusCtrl"></div>
<div mznCheckbox [formControl]="agreeCtrl"></div>
```

Validation stays in `ReactiveFormsModule` — Mezzanine does **not** wrap `Validators`. Display errors with `[mznInlineMessage]` siblings.

### Signal-based inputs / outputs

Components use Angular's signal API (`input()`, `output()`, `computed()`). This means:

- Most `@Input` properties are `InputSignal<T>` — read via `this.size()` internally
- Two-way binding: `[(collapsed)]="collapsed"` works when the component exposes `collapsed = model<boolean>(false)`
- Effects replace `ngOnChanges` in most cases

### DI Services (replaces React hooks)

Imported from `@mezzanine-ui/ng/services`:

| Service | Purpose | React equivalent |
| ------- | ------- | ---------------- |
| `ClickAwayService`   | Detect outside-click | `useClickAway` hook |
| `EscapeKeyService`   | Stacked Escape handling | `useEscapeKeyDown` |
| `ScrollLockService`  | Lock body scroll (modals) | `useScrollLock` |
| `TopStackService`    | Manage z-index / focus stack | — |
| `WindowWidthService` | Reactive breakpoints | `useWindowSize` |

See [references/SERVICES.md](references/SERVICES.md).

### Utilities

Imported from `@mezzanine-ui/ng/utils`:

| Export | Purpose |
| ------ | ------- |
| `getCSSVariablePixelValue` | Read a `:root` CSS var and resolve to px (handles `rem`/`px`/unitless) |
| `highlightText` / `HighlightSegment` | Split text into segments around a keyword for search-result highlighting |
| `provideValueAccessor` | `NG_VALUE_ACCESSOR` multi-provider shorthand for custom `ControlValueAccessor` components |
| `formatNumberWithCommas` / `parseNumberWithCommas` | Locale-aware comma formatting / parsing for numeric inputs |

See [references/PATTERNS.md → Utilities](references/PATTERNS.md#utilities).

---

## Content Projection Pitfalls (重要 — 寫了但畫面不顯示)

Angular 端與 React 端類似，多個容器元件透過 **named `ng-content` slot** 或 **directive selector 比對**決定哪些子元素會被渲染。如果寫了 host element 但 **selector / 父子關係不正確**，內容會被靜默吃掉。

> 任何時候 `mznTabs` / `mznLayout` / `mznSection` / `mznPageHeader` / `mznNavigation` / `mznAccordion` 等容器「HTML 寫了但畫面沒東西」，先檢查：(1) 子元素 selector 是否正確 (2) 是否多包了一層 `<div>` 把 selector 從父層斷開。

### 常見靜默過濾來源

| 容器 | 接受的子元素 | 失敗模式 |
| --- | --- | --- |
| `[mznTabs]` | `<button mznTabItem>` 直接子代 | 包一層 `<div>` 或不是 `<button>` → 不渲染 |
| `[mznLayout]` | `[mznLayoutMain]` / `[mznLayoutLeftPanel]` / `[mznLayoutRightPanel]` / `[mznNavigation]` 直接子代 | 包 wrapper 後 `ng-content` slot 找不到 → 不渲染 |
| `[mznPageHeader]` | `[mznBreadcrumb]` 與 `[mznContentHeader]`（透過 ng-content） | host 元素若不是 directive 預期的元素則樣式錯亂 |
| `[mznSection]` | named slot：contentHeader / filterArea / tab / 主內容 | slot selector 不對 → 對應區塊空白 |
| `[mznNavigation]` | `[mznNavigationHeader]` / `[mznNavigationFooter]` / `<mzn-navigation-option>` / `<mzn-navigation-option-category>` | 用原生 `<a>` / `<li>` → 不被識別、不渲染 |
| `[mznAccordion]` | `[mznAccordionTitle]` / `[mznAccordionContent]` / `[mznAccordionActions]` | 缺少 directive selector → 內容區或 actions 不出現 |
| `[mznContentHeader]` 內 actions slot | 只接受 `<button mznButton>` 且 variant ∈ `base-primary` / `base-secondary` / `destructive-secondary` | 自訂 `<div>` wrapper / 其他 variant 不渲染 |

### 常見錯誤

```html
<!-- ❌ 包一層 div：mznTabItem 找不到 mznTabs context -->
<div mznTabs>
  <div class="tabs-wrapper">
    <button mznTabItem [key]="'a'">A</button>
    <button mznTabItem [key]="'b'">B</button>
  </div>
</div>

<!-- ✅ 直接放 host element -->
<div mznTabs>
  <button mznTabItem [key]="'a'">A</button>
  <button mznTabItem [key]="'b'">B</button>
</div>
```

```html
<!-- ❌ Layout slot 被外層 div 切斷 -->
<div mznLayout>
  <div class="shell">
    <aside mznLayoutLeftPanel>...</aside>
    <main mznLayoutMain>...</main>
  </div>
</div>

<!-- ✅ slot directive 必須是 mznLayout 直接子代 -->
<div mznLayout>
  <nav mznNavigation>...</nav>
  <aside mznLayoutLeftPanel [open]="leftOpen()">...</aside>
  <main mznLayoutMain>...</main>
</div>
```

```html
<!-- ❌ 直接寫原生 a：Navigation 不認得 -->
<nav mznNavigation>
  <a routerLink="/x">外部連結</a>
</nav>

<!-- ✅ 用 mzn-navigation-option，搭配 router 元件透過 anchorComponent / 自身 routerLink 處理 -->
<nav mznNavigation>
  <mzn-navigation-option title="X" routerLink="/x"></mzn-navigation-option>
</nav>
```

### 排查流程

1. 子元素的 selector 是否與父層期望的 directive 一致？
2. 是否包了 `<div>` 或其他 host element 把 ng-content / DI token context 切斷？
3. 是否在 `standalone: true` 元件裡缺少 `imports` 對應 directive？（會讓 selector 直接無效）
4. host element tag 是否符合 directive 限制（如 `mznTabItem` 必為 `<button>`）？

詳細個別約束請見 [references/components/](references/components/) 內 `Selectors` / `Content Projection Slots` 章節。

---

## Import Convention (Sub-path only)

**Always import from the specific secondary entry point**, not the main `@mezzanine-ui/ng` barrel:

```ts
// ✅ Correct
import { MznButton } from '@mezzanine-ui/ng/button';
import { MznInput, MznInputVariant } from '@mezzanine-ui/ng/input';
import { MZN_CALENDAR_CONFIG, createCalendarConfig } from '@mezzanine-ui/ng/calendar';

// ❌ Wrong — the main barrel only exports VERSION
import { MznButton } from '@mezzanine-ui/ng';
```

Design constants and enums live in `@mezzanine-ui/core`:

```ts
import { FormFieldLayout } from '@mezzanine-ui/core/form';
import { ButtonSize, ButtonVariant } from '@mezzanine-ui/core/button';
```

Icons:

```ts
import { UserIcon, SearchIcon } from '@mezzanine-ui/icons';
```

---

## Component Categories

> Source-of-truth: `/packages/ng/<component>/public-api.ts`. See per-component markdown in [references/components/](references/components/).

### General

| Directive / Component | Import path | Reference |
| --------------------- | ----------- | --------- |
| `MznButton`    | `@mezzanine-ui/ng/button`    | [Button.md](references/components/Button.md) |
| `MznIcon`      | `@mezzanine-ui/ng/icon`      | [Icon.md](references/components/Icon.md) |
| `MznSeparator` | `@mezzanine-ui/ng/separator` | [Separator.md](references/components/Separator.md) |
| `MznTypography`| `@mezzanine-ui/ng/typography`| [Typography.md](references/components/Typography.md) |
| `MznCropper`   | `@mezzanine-ui/ng/cropper`   | [Cropper.md](references/components/Cropper.md) |

### Navigation

| Directive / Component | Import path | Reference |
| --------------------- | ----------- | --------- |
| `MznBreadcrumb` | `@mezzanine-ui/ng/breadcrumb` | [Breadcrumb.md](references/components/Breadcrumb.md) |
| `MznDrawer`     | `@mezzanine-ui/ng/drawer`     | [Drawer.md](references/components/Drawer.md) |
| `MznNavigation`                | `@mezzanine-ui/ng/navigation` | [Navigation.md](references/components/Navigation.md) |
| `MznNavigationOptionCategory`  | `@mezzanine-ui/ng/navigation` | [Navigation.md](references/components/Navigation.md) |
| `MznNavigationUserMenu`        | `@mezzanine-ui/ng/navigation` | [Navigation.md](references/components/Navigation.md) |
| `MznPageFooter` | `@mezzanine-ui/ng/page-footer`| [PageFooter.md](references/components/PageFooter.md) |
| `MznPageHeader` | `@mezzanine-ui/ng/page-header`| [PageHeader.md](references/components/PageHeader.md) |
| `MznStepper`    | `@mezzanine-ui/ng/stepper`    | [Stepper.md](references/components/Stepper.md) |
| `MznTab`        | `@mezzanine-ui/ng/tab`        | [Tab.md](references/components/Tab.md) |

### Data Display

| Directive / Component | Import path | Reference |
| --------------------- | ----------- | --------- |
| `MznAccordion`         | `@mezzanine-ui/ng/accordion`         | [Accordion.md](references/components/Accordion.md) |
| `MznBadge`             | `@mezzanine-ui/ng/badge`             | [Badge.md](references/components/Badge.md) |
| `MznCard`              | `@mezzanine-ui/ng/card`              | [Card.md](references/components/Card.md) |
| `MznDescription`       | `@mezzanine-ui/ng/description`       | [Description.md](references/components/Description.md) |
| `MznEmpty`             | `@mezzanine-ui/ng/empty`             | [Empty.md](references/components/Empty.md) |
| `MznOverflowTooltip`   | `@mezzanine-ui/ng/overflow-tooltip`  | [OverflowTooltip.md](references/components/OverflowTooltip.md) |
| `MznPagination`        | `@mezzanine-ui/ng/pagination`        | [Pagination.md](references/components/Pagination.md) |
| `MznSection`           | `@mezzanine-ui/ng/section`           | [Section.md](references/components/Section.md) |
| `MznTable`             | `@mezzanine-ui/ng/table`             | [Table.md](references/components/Table.md) |
| `MznTag`               | `@mezzanine-ui/ng/tag`               | [Tag.md](references/components/Tag.md) |
| `MznTooltip`           | `@mezzanine-ui/ng/tooltip`           | [Tooltip.md](references/components/Tooltip.md) |

### Data Entry

| Directive / Component | Import path | Reference |
| --------------------- | ----------- | --------- |
| `MznAutocomplete`        | `@mezzanine-ui/ng/autocomplete`            | [Autocomplete.md](references/components/Autocomplete.md) |
| `MznCascader`            | `@mezzanine-ui/ng/cascader`                | [Cascader.md](references/components/Cascader.md) |
| `MznCheckbox`            | `@mezzanine-ui/ng/checkbox`                | [Checkbox.md](references/components/Checkbox.md) |
| `MznDatePicker`          | `@mezzanine-ui/ng/date-picker`             | [DatePicker.md](references/components/DatePicker.md) |
| `MznDateRangePicker`     | `@mezzanine-ui/ng/date-range-picker`       | [DateRangePicker.md](references/components/DateRangePicker.md) |
| `MznDateTimePicker`      | `@mezzanine-ui/ng/date-time-picker`        | [DateTimePicker.md](references/components/DateTimePicker.md) |
| `MznDateTimeRangePicker` | `@mezzanine-ui/ng/date-time-range-picker`  | [DateTimeRangePicker.md](references/components/DateTimeRangePicker.md) |
| `MznFilterArea`          | `@mezzanine-ui/ng/filter-area`             | [FilterArea.md](references/components/FilterArea.md) |
| `MznFormField`           | `@mezzanine-ui/ng/form`                    | [Form.md](references/components/Form.md) |
| `MznInput`               | `@mezzanine-ui/ng/input`                   | [Input.md](references/components/Input.md) |
| `MznMultipleDatePicker`  | `@mezzanine-ui/ng/multiple-date-picker`    | [MultipleDatePicker.md](references/components/MultipleDatePicker.md) |
| `MznPicker`              | `@mezzanine-ui/ng/picker`                  | [Picker.md](references/components/Picker.md) |
| `MznRadio`               | `@mezzanine-ui/ng/radio`                   | [Radio.md](references/components/Radio.md) |
| `MznSelect`              | `@mezzanine-ui/ng/select`                  | [Select.md](references/components/Select.md) |
| `MznSelectionCard`       | `@mezzanine-ui/ng/selection-card`          | [SelectionCard.md](references/components/SelectionCard.md) |
| `MznSlider`              | `@mezzanine-ui/ng/slider`                  | [Slider.md](references/components/Slider.md) |
| `MznTextarea`            | `@mezzanine-ui/ng/textarea`                | [Textarea.md](references/components/Textarea.md) |
| `MznTextField`           | `@mezzanine-ui/ng/text-field`              | [TextField.md](references/components/TextField.md) |
| `MznTimePicker`          | `@mezzanine-ui/ng/time-picker`             | [TimePicker.md](references/components/TimePicker.md) |
| `MznTimeRangePicker`     | `@mezzanine-ui/ng/time-range-picker`       | [TimeRangePicker.md](references/components/TimeRangePicker.md) |
| `MznToggle`              | `@mezzanine-ui/ng/toggle`                  | [Toggle.md](references/components/Toggle.md) |
| `MznUpload`              | `@mezzanine-ui/ng/upload`                  | [Upload.md](references/components/Upload.md) |

### Feedback

| Directive / Component | Import path | Reference |
| --------------------- | ----------- | --------- |
| `MznInlineMessage`      | `@mezzanine-ui/ng/inline-message`      | [InlineMessage.md](references/components/InlineMessage.md) |
| `MznMessage`            | `@mezzanine-ui/ng/message`             | [Message.md](references/components/Message.md) |
| `MznModal`              | `@mezzanine-ui/ng/modal`               | [Modal.md](references/components/Modal.md) |
| `MznNotificationCenter` | `@mezzanine-ui/ng/notification-center` | [NotificationCenter.md](references/components/NotificationCenter.md) |
| `MznProgress`           | `@mezzanine-ui/ng/progress`            | [Progress.md](references/components/Progress.md) |
| `MznResultState`        | `@mezzanine-ui/ng/result-state`        | [ResultState.md](references/components/ResultState.md) |
| `MznSkeleton`           | `@mezzanine-ui/ng/skeleton`            | [Skeleton.md](references/components/Skeleton.md) |
| `MznSpin`               | `@mezzanine-ui/ng/spin`                | [Spin.md](references/components/Spin.md) |

### Layout

| Directive / Component | Import path | Reference |
| --------------------- | ----------- | --------- |
| `MznLayout` | `@mezzanine-ui/ng/layout` | [Layout.md](references/components/Layout.md) |

### Others

| Directive / Component | Import path | Reference |
| --------------------- | ----------- | --------- |
| `MznAlertBanner`    | `@mezzanine-ui/ng/alert-banner`    | [AlertBanner.md](references/components/AlertBanner.md) |
| `MznAnchor`         | `@mezzanine-ui/ng/anchor`          | [Anchor.md](references/components/Anchor.md) |
| `MznBackdrop`       | `@mezzanine-ui/ng/backdrop`        | [Backdrop.md](references/components/Backdrop.md) |
| `MznFloatingButton` | `@mezzanine-ui/ng/floating-button` | [FloatingButton.md](references/components/FloatingButton.md) |

### Angular-only components

Components that exist in `@mezzanine-ui/ng` but **not** `@mezzanine-ui/react`:

| Directive / Component | Import path | Reference |
| --------------------- | ----------- | --------- |
| `MznThumbnail`             | `@mezzanine-ui/ng/thumbnail`                | [Thumbnail.md](references/components/Thumbnail.md) |
| `MznSingleThumbnailCard` *(已廢棄 v1.0.0-rc.4)*   | `@mezzanine-ui/ng/single-thumbnail-card`    | [SingleThumbnailCard.md](references/components/SingleThumbnailCard.md) |
| `MznFourThumbnailCard` *(已廢棄 v1.0.0-rc.4)*     | `@mezzanine-ui/ng/four-thumbnail-card`      | [FourThumbnailCard.md](references/components/FourThumbnailCard.md) |
| `MznThumbnailCardInfo` *(已廢棄 v1.0.0-rc.4)*     | `@mezzanine-ui/ng/thumbnail-card-info`      | [ThumbnailCardInfo.md](references/components/ThumbnailCardInfo.md) |
| `MznMediaPreviewModal`     | `@mezzanine-ui/ng/media-preview-modal`      | [MediaPreviewModal.md](references/components/MediaPreviewModal.md) |

### Utility

| Directive / Component | Import path | Reference |
| --------------------- | ----------- | --------- |
| `MznCalendar`   | `@mezzanine-ui/ng/calendar`   | [Calendar.md](references/components/Calendar.md) |
| `MznNotifier`   | `@mezzanine-ui/ng/notifier`   | [Notifier.md](references/components/Notifier.md) |
| `MznPopper`     | `@mezzanine-ui/ng/popper`     | [Popper.md](references/components/Popper.md) |
| `MznPortal`     | `@mezzanine-ui/ng/portal`     | [Portal.md](references/components/Portal.md) |
| `MznTimePanel`  | `@mezzanine-ui/ng/time-panel` | [TimePanel.md](references/components/TimePanel.md) |
| `MznTransition` | `@mezzanine-ui/ng/transition` | [Transition.md](references/components/Transition.md) |

### Internal / Deprecated

| Directive / Component | Status | Reference |
| --------------------- | ------ | --------- |
| `MznClearActions`  | *(internal)* — used inside Select / Input | [ClearActions.md](references/components/ClearActions.md) |
| `MznContentHeader` | *(internal)* — used inside PageHeader / Section | [ContentHeader.md](references/components/ContentHeader.md) |
| `MznDropdown`      | *(internal slot target)*                   | [Dropdown.md](references/components/Dropdown.md) |
| `MznScrollbar`     | *(internal)* — custom scrollbar           | [Scrollbar.md](references/components/Scrollbar.md) |

---

## Shared Resources (synced from `using-mezzanine-ui-react`)

Design tokens, icon catalog, and Figma mappings are identical across React and Angular. They're copied into this skill so each can be used independently:

| Document                                                       | Description                    |
| -------------------------------------------------------------- | ------------------------------ |
| [references/DESIGN_TOKENS.md](references/DESIGN_TOKENS.md)     | Palette / spacing / typography tokens (shared with React) |
| [references/ICONS.md](references/ICONS.md)                     | Icon catalog from `@mezzanine-ui/icons` (shared with React) |
| [references/FIGMA_MAPPING.md](references/FIGMA_MAPPING.md)     | Figma node → component map (shared with React) |

---

## Angular-specific Documentation

| Document                                            | Description                                      |
| --------------------------------------------------- | ------------------------------------------------ |
| [references/PATTERNS.md](references/PATTERNS.md)    | Angular pattern cookbook — page scaffolds, forms, layouts |
| [references/SERVICES.md](references/SERVICES.md)    | DI services exported from `@mezzanine-ui/ng/services` |
| [references/COMPONENTS.md](references/COMPONENTS.md)| Consolidated Angular component index with full API |

---

## Maintenance

### Version Sync Command

When `@mezzanine-ui/ng` releases a new version, run the sync orchestrator:

```
/sync-mezzanine-ui 1.0.0 --target angular
```

The orchestrator shares infrastructure with the React sync: fetches TypeScript from GitHub, regenerates cache JSON, refreshes shared design-token / icon / figma-mapping docs.

See companion skill `using-mezzanine-ui-react` for the React side.
