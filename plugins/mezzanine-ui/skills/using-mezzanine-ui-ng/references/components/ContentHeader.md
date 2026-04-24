# ContentHeader

> ⚠️ Internal helper — `MznContentHeader` is used internally by `MznSection` and `MznPageHeader` to render a titled header row. You can use it directly when composing a `mznSection`, but avoid using it as a standalone component outside that context.

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/ng/content-header) · Verified 1.0.0-rc.4 (2026-04-24)

Section/page header with title, optional description, and content projection slots for actions and breadcrumbs.

## Import

```ts
import { MznContentHeader } from '@mezzanine-ui/ng/content-header';
import type {
  ContentHeaderSize,
  ContentHeaderTitleComponent,
} from '@mezzanine-ui/ng/content-header';
```

## Selector

`[mznContentHeader]` — component applied to a host element (typically `<header>`).

## Exports

`ContentHeaderTitleComponent` is a type alias exported from the same package:

```ts
type ContentHeaderTitleComponent = 'h1' | 'h2' | 'h3' | 'h4' | 'h5' | 'h6' | 'p';
```

## Inputs

| Input              | Type                          | Default     | Description                                                           |
| ------------------ | ----------------------------- | ----------- | --------------------------------------------------------------------- |
| `title`            | `string` (**required**)       | —           | Header title text                                                     |
| `description`      | `string \| undefined`         | —           | Optional description below the title                                  |
| `size`             | `ContentHeaderSize`           | `'main'`    | `'main' \| 'sub'` — controls text size                               |
| `showBackButton`   | `boolean`                     | `false`     | Auto-renders a back icon button; emits `backClick` when clicked       |
| `titleComponent`   | `ContentHeaderTitleComponent \| undefined` | — | Override the heading HTML tag; defaults to `'h1'` for `main`, `'h2'` for `sub` |

> Inputs declared with signal API (`input()`, `model()`) accept both static and reactive values.

## Outputs

| Output       | Type                      | Description                                                      |
| ------------ | ------------------------- | ---------------------------------------------------------------- |
| `backClick`  | `OutputEmitterRef<void>`  | Emitted when the auto-rendered back button is clicked. Binding this output alone does NOT show the button — set `showBackButton` to `true` as well. |

## Usage

```html
<!-- Inside MznSection -->
<div mznSection>
  <header mznContentHeader title="使用者清單" size="sub"></header>
  <!-- main content -->
</div>

<!-- With description and named action slot -->
<header mznContentHeader title="訂單管理" description="管理所有訂單">
  <div contentHeaderActions>
    <button mznButton variant="base-primary">新增訂單</button>
  </div>
</header>

<!-- Programmatic back button (equivalent to React onBackClick) -->
<header mznContentHeader title="訂單詳情" showBackButton (backClick)="goBack()">
  <div contentHeaderFilter>
    <input mznInput placeholder="搜尋..." />
  </div>
  <div contentHeaderActions>
    <button mznButton variant="base-primary">儲存</button>
  </div>
  <div contentHeaderUtilities>
    <button mznButton iconType="icon-only"><i mznIcon [icon]="MoreIcon"></i></button>
  </div>
</header>

<!-- Custom header tag -->
<header mznContentHeader title="子區塊" size="sub" titleComponent="h3"></header>
```

### Content projection slots

| Slot attribute              | Description                                    |
| --------------------------- | ---------------------------------------------- |
| `[contentHeaderBackButton]` | Custom back button (only shown when `size='main'` and `showBackButton` is `false`) |
| `[contentHeaderFilter]`     | Filter / search area                           |
| `[contentHeaderActions]`    | Primary action buttons                         |
| `[contentHeaderUtilities]`  | Icon-only utility buttons (right-most)         |

## Notes

- `title` is `input.required<string>()` — omitting it throws a runtime error.
- `showBackButton` causes the component to render its own icon button. When `[contentHeaderBackButton]` slot content is also projected, the auto-rendered button takes precedence (slot is hidden).
- `MznSection` projects `[mznContentHeader]` into the first slot automatically; no additional wrapping is needed.
- `MznContentHeaderResponsive` (same package) provides a responsive variant for mobile-adaptive layouts.
