# ThumbnailCardInfo

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/ng/thumbnail-card-info) · Verified 1.0.0-rc.4 (2026-04-24)

Attribute directive component that renders the info section (filetype badge, title, subtitle, and optional action) shared by `MznSingleThumbnailCard` and `MznFourThumbnailCard`. Supports three interaction modes: `'default'` (no action), `'action'` (text-link button), and `'overflow'` (dot-horizontal menu with dropdown).

Most consumers do not use this component directly — prefer `MznSingleThumbnailCard` / `MznFourThumbnailCard`, which compose it internally. Use it on its own only when building custom card layouts.

## Import

```ts
import {
  MznThumbnailCardInfo,
  ThumbnailCardInfoActionVariant,
  ThumbnailCardInfoType,
} from '@mezzanine-ui/ng/thumbnail-card-info';
```

## Selector

`[mznThumbnailCardInfo]` — component applied to a block host element (typically `<div>`).

## Inputs

| Input            | Type                                | Default           | Description                                                                                  |
| ---------------- | ----------------------------------- | ----------------- | -------------------------------------------------------------------------------------------- |
| `actionName`     | `string \| undefined`               | —                 | Label text for the action button. Only relevant when `type="action"`.                        |
| `actionVariant`  | `ThumbnailCardInfoActionVariant`    | `'base-text-link'`| Button variant for the action button — `'base-text-link'` or `'destructive-text-link'`.      |
| `disabled`       | `boolean`                           | `false`           | Whether the action button or overflow button is disabled.                                    |
| `filetype`       | `string \| undefined`               | —                 | File extension for the filetype badge (e.g., `'pdf'`). Renders a category-specific colour.   |
| `options`        | `ReadonlyArray<DropdownOption>`     | `[]`              | Dropdown options for the overflow menu. Only relevant when `type="overflow"`.                |
| `subtitle`       | `string \| undefined`               | —                 | Card subtitle text.                                                                          |
| `title`          | `string \| undefined`               | —                 | Card title text.                                                                             |
| `type`           | `ThumbnailCardInfoType`             | `'default'`       | Interaction mode — `'default'`, `'action'`, or `'overflow'`.                                 |

> Inputs declared with signal API (`input()`) accept both static and reactive values.

## Outputs

| Output         | Payload          | Description                                                    |
| -------------- | ---------------- | -------------------------------------------------------------- |
| `actionClick`  | `MouseEvent`     | Emitted when the action button is clicked (`type="action"`).   |
| `optionSelect` | `DropdownOption` | Emitted when a dropdown option is selected (`type="overflow"`). The overflow menu closes automatically after selection. |

## ControlValueAccessor

No.

## Usage

```html
<!-- 預設（無操作） -->
<div
  mznThumbnailCardInfo
  title="Report.pdf"
  subtitle="2.4 MB"
  filetype="pdf"
></div>

<!-- Action 模式 — 文字連結按鈕 -->
<div
  mznThumbnailCardInfo
  title="Report.pdf"
  subtitle="2.4 MB"
  filetype="pdf"
  type="action"
  actionName="下載"
  (actionClick)="onDownload($event)"
></div>

<!-- Action 模式 — destructive variant -->
<div
  mznThumbnailCardInfo
  title="草稿.pdf"
  subtitle="尚未送出"
  type="action"
  actionName="刪除"
  actionVariant="destructive-text-link"
  (actionClick)="onDelete($event)"
></div>

<!-- Overflow 模式 — dot-horizontal 下拉選單 -->
<div
  mznThumbnailCardInfo
  title="Photo.jpg"
  subtitle="640x480"
  filetype="jpg"
  type="overflow"
  [options]="menuOptions"
  (optionSelect)="onOptionSelect($event)"
></div>
```

## Notes

- Component is `standalone: true`; imports `MznButton`, `MznDropdown`, and `MznIcon` internally. Change detection is `OnPush`.
- When `filetype` is provided, the component calls `getFileTypeCategory(ext)` from `@mezzanine-ui/core/card/fileTypeMapping` to apply a category-specific colour modifier class (e.g., image / document / archive categories).
- When `title` is falsy, the title `<span>` is not rendered; same for `subtitle`.
- When `type="action"`, a `mznButton` with `size="sub"` and the resolved `actionVariant` is rendered. The click event calls `event.stopPropagation()` before emitting `actionClick`.
- When `type="overflow"`, an icon-only `mznButton` toggles an `mznDropdown` anchored to the trigger. The dropdown runs in `mode="single"`, and selecting an option emits `optionSelect` and auto-closes the menu.
- When `type="default"` (the default), neither the action button nor the overflow menu is rendered.
- The component is typically composed inside `MznSingleThumbnailCard` / `MznFourThumbnailCard` — use those for full card layouts. Use `MznThumbnailCardInfo` standalone only when building custom composition.

## Migration from React

React `ThumbnailCardInfo` maps onto `[mznThumbnailCardInfo]`:

| React prop       | Angular                                |
| ---------------- | -------------------------------------- |
| `title`          | `[title]`                              |
| `subtitle`       | `[subtitle]`                           |
| `filetype`       | `[filetype]`                           |
| `type`           | `[type]`                               |
| `actionName`     | `[actionName]`                         |
| `actionVariant`  | `[actionVariant]`                      |
| `disabled`       | `[disabled]`                           |
| `options`        | `[options]`                            |
| `onAction`       | `(actionClick)`                        |
| `onOptionSelect` | `(optionSelect)`                       |
