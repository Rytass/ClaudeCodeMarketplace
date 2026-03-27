---
name: using-mezzanine-ui
description: Mezzanine-UI design system development guide (v2, rc.8). All frontend development MUST prefer this design system. Use when building UI interfaces or React components, using @mezzanine-ui/* packages, looking up design specs and component usage, reviewing Figma designs, or implementing form/table/modal/navigation UI patterns.
---

# Mezzanine-UI Design System (v2)

**Core principle: All frontend development MUST prefer the Mezzanine-UI design system.**

> Currently v2 Release Candidate, npm version `1.x` series
>
> **Last verified**: 2026-03-27

### Version Mapping

| Design Docs / Storybook | npm Version | Git Branch | Status                 |
| ----------------------- | ----------- | ---------- | ---------------------- |
| v1 (Legacy)             | `0.x`       | main       | Deprecated             |
| **v2 (Current)**        | **`1.x`**   | **v2**     | RC (1.0.0-rc.8)       |

> This document is based on **v2** (npm `1.x` series).
>
> Check latest version: `npm view @mezzanine-ui/react versions` or see [GitHub Releases](https://github.com/Mezzanine-UI/mezzanine/releases)

## Resource Overview

| Type               | Resource                                                         | Purpose                |
| ------------------ | ---------------------------------------------------------------- | ---------------------- |
| **Figma Components** | [Component File](https://www.figma.com/design/gjGdP49GQZzOeQf0bNOFlt) | Referenceable design components |
| **Figma Docs**     | [Documentation](https://www.figma.com/design/VgnrTeu6oOSE0giftMw1Oy) | Design specs & guidelines |
| **Frontend Package** | [GitHub](https://github.com/Mezzanine-UI/mezzanine)           | React component source |
| **Doc Site**       | [Storybook](https://storybook.mezzanine-ui.org)                 | Component examples & API |

---

## Quick Start

### Installation

```bash
yarn add @mezzanine-ui/core @mezzanine-ui/react @mezzanine-ui/system @mezzanine-ui/icons
```

### Style Setup

Create `main.scss`:

```scss
@use '~@mezzanine-ui/system' as mzn-system;
@use '~@mezzanine-ui/core' as mzn-core;

// Set design system variables
:root {
  @include mzn-system.palette-variables(light);
  @include mzn-system.common-variables(default);
}

// Dark mode
[data-theme='dark'] {
  @include mzn-system.palette-variables(dark);
}

// Compact mode
[data-density='compact'] {
  @include mzn-system.common-variables(compact);
}

// Load component styles
@include mzn-core.styles();
```

### Basic Usage

```tsx
import './main.scss';
import { Button, Typography } from '@mezzanine-ui/react';
import { PlusIcon } from '@mezzanine-ui/icons';

function App() {
  return (
    <div>
      <Typography variant="h1">Welcome to Mezzanine UI</Typography>
      <Button variant="base-primary" size="main">
        <PlusIcon />
        Click Me
      </Button>
    </div>
  );
}
```

### CalendarConfigProvider Setup (日期/時間元件必要)

使用任何日期或時間相關元件（DatePicker, DateRangePicker, DateTimePicker, DateTimeRangePicker, MultipleDatePicker, TimePicker, TimeRangePicker, Calendar, TimePanel）之前，**必須**在應用程式根層級包裹 `CalendarConfigProvider`，否則會拋出 runtime error: `Cannot find values in your context`.

```tsx
// layout.tsx 或 App.tsx
import { CalendarConfigProvider } from '@mezzanine-ui/react';
import { CalendarMethodsMoment } from '@mezzanine-ui/core/calendar';

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <CalendarConfigProvider methods={CalendarMethodsMoment}>
      {children}
    </CalendarConfigProvider>
  );
}
```

> 也可使用 `CalendarConfigProviderMoment` 或 `CalendarConfigProviderDayjs` 便捷封裝（從 `@mezzanine-ui/react/Calendar` 匯入）。

---

## What's New in rc.8

- **Toggle** 取代 Switch — 全新元件，提供更簡潔的 API
- **Drawer** 簡化 — 移除內建底部操作按鈕與篩選區域，改採組合模式（DrawerHeader / DrawerBody / DrawerFooter）
- **Dropdown** 重構 — 簡化 API，移除直接傳入 options / onSelect 的模式
- **Calendar** 重構 — 移除直接的 mode / value / onChange，改為 calendarDaysProps / calendarMonthsProps
- **Upload** 簡化 — 移除內建錯誤與刪除 handler，新增 dropzoneHints
- **Typography** 增強 — 新增 align、color、display、ellipsis、noWrap、variant props
- **Popper** 增強 — 新增 arrow、className、enabled、padding props
- **4 個元件已廢棄**：ClearActions、ContentHeader、Scrollbar、Switch

---

## Storybook — 權威互動參考

所有元件皆可在 [Storybook](https://storybook.mezzanine-ui.org) 中查看互動範例。當文件描述與實際行為不一致時，以 Storybook 的互動範例為準。

每個元件的參考文件都包含直接的 Storybook 連結，格式為：
`https://storybook.mezzanine-ui.org/?path=/docs/{kebab-category}-{kebab-component}--docs`

> **Best Practice**: 在實作前先查看 Storybook 的 Controls panel，了解各 prop 的實際效果和預設值。

---

## Package Architecture

| Package                 | Description                          |
| ----------------------- | ------------------------------------ |
| `@mezzanine-ui/system`  | Design tokens (colors, spacing, fonts, etc.) |
| `@mezzanine-ui/core`    | CSS styles and class definitions     |
| `@mezzanine-ui/react`   | React components                     |
| `@mezzanine-ui/icons`   | Icon library                         |

---

## Component Categories

> Categories below are based on `packages/react/src/index.ts` exports. See individual component reference files for detailed API.

### General

Foundational visual elements that serve as building blocks for other components.

| Component     | Description    | Reference                                            |
| ------------- | -------------- | ---------------------------------------------------- |
| `Button`      | Button         | [Button.md](references/components/Button.md)         |
| `ButtonGroup` | Button group   | [Button.md](references/components/Button.md)         |
| `Cropper`     | Crop tool      | [Cropper.md](references/components/Cropper.md)       |
| `Icon`        | Icon           | [Icon.md](references/components/Icon.md)             |
| `Separator`   | Divider line   | [Separator.md](references/components/Separator.md)   |
| `Typography`  | Typography     | [Typography.md](references/components/Typography.md) |

### Navigation

Components for navigating between and within pages.

| Component    | Description     | Reference                                            |
| ------------ | --------------- | ---------------------------------------------------- |
| `Breadcrumb` | Breadcrumb      | [Breadcrumb.md](references/components/Breadcrumb.md) |
| `Drawer`     | Drawer          | [Drawer.md](references/components/Drawer.md)         |
| `Navigation` | Side navigation | [Navigation.md](references/components/Navigation.md) |
| `PageFooter` | Page footer     | [PageFooter.md](references/components/PageFooter.md) |
| `PageHeader` | Page header     | [PageHeader.md](references/components/PageHeader.md) |
| `Stepper`    | Step indicator  | [Stepper.md](references/components/Stepper.md)       |
| `Tab`        | Tab             | [Tab.md](references/components/Tab.md)               |

### Data Display

Data presentation and visualization components.

| Component           | Description       | Reference                                                      |
| ------------------- | ----------------- | -------------------------------------------------------------- |
| `Accordion`         | Accordion         | [Accordion.md](references/components/Accordion.md)             |
| `Badge`             | Badge             | [Badge.md](references/components/Badge.md)                     |
| `Card`              | Card              | [Card.md](references/components/Card.md)                       |
| `Description`       | Description list  | [Description.md](references/components/Description.md)         |
| `Empty`             | Empty state       | [Empty.md](references/components/Empty.md)                     |
| `OverflowCounterTag`| Overflow counter  | [OverflowTooltip.md](references/components/OverflowTooltip.md) |
| `Pagination`        | Pagination        | [Pagination.md](references/components/Pagination.md)           |
| `Section`           | Section           | [Section.md](references/components/Section.md)                 |
| `SectionGroup`      | Section group     | [Section.md](references/components/Section.md)                 |
| `Table`             | Table             | [Table.md](references/components/Table.md)                     |
| `Tag`               | Tag               | [Tag.md](references/components/Tag.md)                         |
| `Tooltip`           | Tooltip           | [Tooltip.md](references/components/Tooltip.md)                 |

### Data Entry

Form and user input components.

| Component             | Description          | Reference                                                              |
| --------------------- | -------------------- | ---------------------------------------------------------------------- |
| `AutoComplete`        | Autocomplete         | [AutoComplete.md](references/components/AutoComplete.md)               |
| `Cascader`            | Cascader             | [Cascader.md](references/components/Cascader.md)                       |
| `Checkbox`            | Checkbox             | [Checkbox.md](references/components/Checkbox.md)                       |
| `DatePicker`          | Date picker          | [DatePicker.md](references/components/DatePicker.md)                   |
| `DateRangePicker`     | Date range picker    | [DateRangePicker.md](references/components/DateRangePicker.md)         |
| `DateTimePicker`      | Date time picker     | [DateTimePicker.md](references/components/DateTimePicker.md)           |
| `DateTimeRangePicker` | Date time range      | [DateTimeRangePicker.md](references/components/DateTimeRangePicker.md) |
| `FilterArea`          | Filter area          | [FilterArea.md](references/components/FilterArea.md)                   |
| `Form`                | Form                 | [Form.md](references/components/Form.md)                               |
| `FormGroup` *(sub-path only)* | Form field group | [Form.md](references/components/Form.md)                           |
| `Input`               | Input                | [Input.md](references/components/Input.md)                             |
| `MultipleDatePicker`  | Multiple date picker | [MultipleDatePicker.md](references/components/MultipleDatePicker.md)   |
| `Picker`              | Picker base          | [Picker.md](references/components/Picker.md)                           |
| `Radio`               | Radio button         | [Radio.md](references/components/Radio.md)                             |
| `Select`              | Select dropdown      | [Select.md](references/components/Select.md)                           |
| `SelectionCard`       | Selection card       | [SelectionCard.md](references/components/SelectionCard.md)             |
| `Slider`              | Slider               | [Slider.md](references/components/Slider.md)                           |
| `Switch` *(已廢棄)*   | Switch toggle — 請改用 Toggle | [Switch.md](references/components/Switch.md)               |
| `Textarea`            | Textarea             | [Textarea.md](references/components/Textarea.md)                       |
| `TextField`           | Text field           | [TextField.md](references/components/TextField.md)                     |
| `TimePicker`          | Time picker          | [TimePicker.md](references/components/TimePicker.md)                   |
| `TimeRangePicker`     | Time range picker    | [TimeRangePicker.md](references/components/TimeRangePicker.md)         |
| `Toggle`              | Toggle (取代 Switch) | [Toggle.md](references/components/Toggle.md)                           |
| `Upload`              | Upload               | [Upload.md](references/components/Upload.md)                           |

### Feedback

User action feedback and system status display.

| Component            | Description          | Reference                                                            |
| -------------------- | -------------------- | -------------------------------------------------------------------- |
| `InlineMessage`      | Inline message       | [InlineMessage.md](references/components/InlineMessage.md)           |
| `Message`            | Message toast        | [Message.md](references/components/Message.md)                       |
| `Modal`              | Modal dialog         | [Modal.md](references/components/Modal.md)                           |
| `NotificationCenter` | Notification center  | [NotificationCenter.md](references/components/NotificationCenter.md) |
| `Progress`           | Progress bar         | [Progress.md](references/components/Progress.md)                     |
| `ResultState`        | Result state         | [ResultState.md](references/components/ResultState.md)               |
| `Skeleton`           | Skeleton loader      | [Skeleton.md](references/components/Skeleton.md)                     |
| `Spin`               | Loading spinner      | [Spin.md](references/components/Spin.md)                             |

### Layout

Full-page layout components.

| Component | Description                | Reference                                          |
| --------- | -------------------------- | -------------------------------------------------- |
| `Layout`  | Full-page layout + sidebar | [Layout.md](references/components/Layout.md)       |

### Others

Auxiliary components.

| Component        | Description       | Reference                                                    |
| ---------------- | ----------------- | ------------------------------------------------------------ |
| `AlertBanner`    | Alert banner      | [AlertBanner.md](references/components/AlertBanner.md)       |
| `Anchor`         | Anchor navigation | [Anchor.md](references/components/Anchor.md)                 |
| `Backdrop`       | Backdrop overlay  | [Backdrop.md](references/components/Backdrop.md)             |
| `FloatingButton` | Floating button   | [FloatingButton.md](references/components/FloatingButton.md) |

### Utility

Utility components and transition animations.

| Component    | Description          | Reference                                            |
| ------------ | -------------------- | ---------------------------------------------------- |
| `Calendar`   | Calendar             | [Calendar.md](references/components/Calendar.md)     |
| `Collapse`   | Collapse animation   | [Transition.md](references/components/Transition.md) |
| `Fade`       | Fade animation       | [Transition.md](references/components/Transition.md) |
| `Notifier`   | Notifier             | [Notifier.md](references/components/Notifier.md)     |
| `Popper`     | Popper positioning   | [Popper.md](references/components/Popper.md)         |
| `Portal`     | Portal               | [Portal.md](references/components/Portal.md)         |
| `Rotate`     | Rotate animation     | [Transition.md](references/components/Transition.md) |
| `Scale`      | Scale animation      | [Transition.md](references/components/Transition.md) |
| `Slide`      | Slide animation      | [Transition.md](references/components/Transition.md) |
| `TimePanel`  | Time panel           | [TimePanel.md](references/components/TimePanel.md)   |
| `Transition` | Transition base      | [Transition.md](references/components/Transition.md) |
| `Translate`  | Translate animation  | [Transition.md](references/components/Transition.md) |

### Internal

Internal components, not typically used directly but available for advanced customization.

| Component                    | Description                          | Export                | Reference                                                    |
| ---------------------------- | ------------------------------------ | --------------------- | ------------------------------------------------------------ |
| `ClearActions` *(已廢棄)*    | Clear/close button                   | sub-path only         | [ClearActions.md](references/components/ClearActions.md)     |
| `ContentHeader` *(已廢棄)*   | Content section header               | sub-path only         | [ContentHeader.md](references/components/ContentHeader.md)   |
| `Dropdown`                   | Dropdown container (API 已重構)      | `@mezzanine-ui/react` | [Dropdown.md](references/components/Dropdown.md)             |
| `Scrollbar` *(已廢棄)*       | Custom scrollbar                     | sub-path only         | [Scrollbar.md](references/components/Scrollbar.md)           |

---

## Design Token System

v2 uses a **Primitives + Semantic** two-layer architecture.

See [references/DESIGN_TOKENS.md](references/DESIGN_TOKENS.md) for detailed design tokens.

### Quick Reference

**Color usage**:
```scss
color: var(--mzn-color-text-brand);
background-color: var(--mzn-color-background-base);
border-color: var(--mzn-color-border-neutral);
```

**Spacing usage**:
```scss
padding: var(--mzn-spacing-padding-horizontal-base);
gap: var(--mzn-spacing-gap-base);
```

---

## Icon Usage

Icons are organized in `@mezzanine-ui/icons`.

See [references/ICONS.md](references/ICONS.md) for the complete icon list.

### Quick Example

```tsx
import { Icon } from '@mezzanine-ui/react';
import { PlusIcon, SearchIcon } from '@mezzanine-ui/icons';

<Icon icon={PlusIcon} />
<Icon icon={SearchIcon} size={24} />
```

---

## Theme Switching

### Light/Dark Mode

```tsx
// Switch theme
document.documentElement.setAttribute('data-theme', 'dark');
```

### Default/Compact Density

```tsx
// Switch density
document.documentElement.setAttribute('data-density', 'compact');
```

---

## Related Documentation

| Document                                    | Description                    |
| ------------------------------------------- | ------------------------------ |
| [references/DESIGN_TOKENS.md](references/DESIGN_TOKENS.md)   | Detailed design token definitions |
| [references/ICONS.md](references/ICONS.md)                   | Complete icon list             |
| [references/PATTERNS.md](references/PATTERNS.md)             | Common usage pattern examples  |
| [references/FIGMA_MAPPING.md](references/FIGMA_MAPPING.md)   | Figma node mapping table       |
| [references/components/](references/components/)             | Detailed API docs per component |
