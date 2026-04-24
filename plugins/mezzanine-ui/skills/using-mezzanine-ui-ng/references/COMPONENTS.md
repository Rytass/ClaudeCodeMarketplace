# Mezzanine-UI Angular Component Reference

> Baseline: `@mezzanine-ui/ng` `1.0.0-rc.4` · Last verified 2026-04-24.

Consolidated flat API index. For deeper examples see
[PATTERNS.md](PATTERNS.md) and `references/components/`.
All components are **standalone**. All inputs use the Angular 21 signal API
(`input<T>()`, `model<T>()`, `output<T>()`). Components marked **CVA** implement
`ControlValueAccessor` and work with `formControl` / `ngModel`.

---

## Table of Contents

- [General](#general)
- [Navigation](#navigation)
- [Data Display](#data-display)
- [Data Entry](#data-entry)
- [Feedback](#feedback)
- [Layout](#layout)
- [Others](#others)
- [Utility](#utility)
- [Angular-only Components](#angular-only-components)
- [Internal / Deprecated](#internal--deprecated)

---

## General

### MznButton

**Selector**: `[mznButton]` (attribute directive)
**Import**: `@mezzanine-ui/ng/button`
**CVA**: No

| Input             | Type                    | Default         | Description                               |
| ----------------- | ----------------------- | --------------- | ----------------------------------------- |
| `variant`         | `ButtonVariant`         | `'base-primary'`| Visual style variant                      |
| `size`            | `ButtonSize`            | `'main'`        | `'main'` \| `'sub'` \| `'minor'`          |
| `disabled`        | `boolean`               | `false`         | Disabled state                            |
| `loading`         | `boolean`               | `false`         | Shows spinner, blocks clicks              |
| `iconType`        | `ButtonIconType`        | —               | `'leading'` \| `'trailing'` \| `'icon-only'` |
| `tooltipText`     | `string`                | —               | Tooltip shown in `icon-only` mode         |
| `tooltipPosition` | `Placement`             | `'bottom'`      | Tooltip placement                         |
| `disabledTooltip` | `boolean`               | `false`         | Suppress automatic tooltip                |
| `icon`            | `IconDefinition`        | —               | Icon for CSS class calculation            |

**Outputs**: none

```html
<button mznButton variant="base-primary" size="main">送出</button>
<button mznButton variant="base-secondary" [loading]="isLoading()">儲存</button>
<a mznButton variant="base-text-link" href="/dashboard">前往</a>
<button mznButton variant="base-primary" iconType="icon-only"
  [icon]="PlusIcon" tooltipText="新增"></button>
```

`ButtonVariant` values: `base-primary`, `base-secondary`, `base-ghost`,
`base-text-link`, `destructive-primary`, `destructive-secondary`,
`destructive-ghost`, `destructive-text-link`.

---

### MznButtonGroup

**Selector**: `[mznButtonGroup]` (attribute directive)
**Import**: `@mezzanine-ui/ng/button`

| Input         | Type                      | Default          | Description                        |
| ------------- | ------------------------- | ---------------- | ---------------------------------- |
| `variant`     | `ButtonVariant`           | `'base-primary'` | Shared variant for child buttons   |
| `size`        | `ButtonSize`              | `'main'`         | Shared size                        |
| `disabled`    | `boolean`                 | `false`          | Shared disabled state              |
| `fullWidth`   | `boolean`                 | `false`          | Stretch to container width         |
| `orientation` | `'horizontal' \| 'vertical'` | `'horizontal'` | Group layout direction           |

```html
<div mznButtonGroup variant="base-secondary" size="sub">
  <button mznButton>按鈕 1</button>
  <button mznButton>按鈕 2</button>
</div>
```

---

### MznIcon

**Selector**: `[mznIcon]` (attribute on `<i>`)
**Import**: `@mezzanine-ui/ng/icon`
**CVA**: No

| Input       | Type              | Default | Description                        |
| ----------- | ----------------- | ------- | ---------------------------------- |
| `icon`      | `IconDefinition`  | required| Icon definition from `@mezzanine-ui/icons` |
| `size`      | `number`          | —       | Size in px                         |
| `color`     | `IconColor`       | —       | Semantic color                     |
| `spin`      | `boolean`         | `false` | Rotation animation                 |
| `clickable` | `boolean`         | `false` | Shows pointer cursor               |
| `title`     | `string`          | —       | Accessible title                   |

```html
<i mznIcon [icon]="SearchIcon"></i>
<i mznIcon [icon]="LoadingIcon" [spin]="true"></i>
<i mznIcon [icon]="CheckIcon" color="success" [size]="20"></i>
```

---

### MznSeparator

**Selector**: `[mznSeparator]` (attribute on `<hr>`)
**Import**: `@mezzanine-ui/ng/separator`

| Input         | Type                          | Default        | Description   |
| ------------- | ----------------------------- | -------------- | ------------- |
| `orientation` | `'horizontal' \| 'vertical'` | `'horizontal'` | Line direction |

```html
<hr mznSeparator />
<hr mznSeparator orientation="vertical" />
```

---

### MznTypography

**Selector**: `[mznTypography]` (attribute directive)
**Import**: `@mezzanine-ui/ng/typography`

| Input      | Type                    | Default  | Description                                 |
| ---------- | ----------------------- | -------- | ------------------------------------------- |
| `variant`  | `TypographySemanticType`| `'body'` | `h1`–`h6`, `body`, `body2`, `caption`, `caption-highlight`, `label`, `label2`, etc. |
| `align`    | `TypographyAlign`       | —        | CSS `text-align`                            |
| `color`    | `TypographyColor`       | —        | Semantic text color                         |
| `display`  | `TypographyDisplay`     | —        | CSS `display`                               |
| `ellipsis` | `boolean`               | `false`  | Single-line truncate with `…`               |
| `noWrap`   | `boolean`               | `false`  | `white-space: nowrap`                       |

```html
<h1 mznTypography variant="h2">頁面標題</h1>
<p mznTypography variant="body" color="text-secondary">說明文字</p>
<span mznTypography variant="caption" [ellipsis]="true">長文字截斷…</span>
```

---

### MznTag

**Selector**: `[mznTag]` (attribute on `<span>`)
**Import**: `@mezzanine-ui/ng/tag`

| Input      | Type       | Default    | Description                                                       |
| ---------- | ---------- | ---------- | ----------------------------------------------------------------- |
| `type`     | `TagType`  | `'static'` | `'static'` \| `'counter'` \| `'dismissable'` \| `'addable'` \| `'overflow-counter'` |
| `label`    | `string`   | —          | Display text                                                      |
| `size`     | `TagSize`  | `'main'`   | `'main'` \| `'sub'`                                               |
| `count`    | `number`   | —          | Count for `counter` / `overflow-counter` types                    |
| `disabled` | `boolean`  | `false`    | Disabled state                                                    |
| `active`   | `boolean`  | `false`    | Active/selected state                                             |
| `readOnly` | `boolean`  | `false`    | Prevents interactions                                             |

**Outputs**: `close: MouseEvent`, `tagClick: MouseEvent`

```html
<span mznTag type="static" label="設計"></span>
<span mznTag type="counter" label="待處理" [count]="3"></span>
<span mznTag type="dismissable" label="React" (close)="remove('React')"></span>
<span mznTag type="addable" label="新增" (tagClick)="handleAdd()"></span>
```

---

### MznBadge

**Selector**: `div[mznBadge]` (requires `<div>` host)
**Import**: `@mezzanine-ui/ng/badge`

| Input           | Type             | Default | Description                                    |
| --------------- | ---------------- | ------- | ---------------------------------------------- |
| `variant`       | `BadgeVariant`   | required| `count-alert`, `count-brand`, `count-info`, `count-inactive`, `count-inverse`, `dot-error`, `dot-success`, `text-success`, etc. |
| `count`         | `number`         | —       | Count for `count-*` variants                   |
| `overflowCount` | `number`         | —       | Shows `{n}+` when exceeded                     |
| `text`          | `string`         | —       | Label for `text-*` / `dot-*` variants          |
| `size`          | `BadgeTextSize`  | —       | Size for text/dot-text variants                |
| `className`     | `string`         | —       | Extra CSS class on inner badge span            |

```html
<div mznBadge variant="count-alert" [count]="notifications()"></div>
<div mznBadge variant="dot-error">
  <i mznIcon [icon]="BellIcon"></i>
</div>
<div mznBadge variant="count-brand" [count]="120" [overflowCount]="99"></div>
```

---

### MznCropper

**Selector**: `[mznCropper]` (directive); `mzn-cropper-modal` (modal variant)
**Import**: `@mezzanine-ui/ng/cropper`

`MznCropperDirective` applies cropping behavior to a host element.
Use `MznCropperModal` for a dialog-based crop flow.
Refer to `references/components/Cropper.md` for full API.

---

## Navigation

### MznBreadcrumb

**Selector**: `[mznBreadcrumb]` (attribute on `<nav>`)
**Import**: `@mezzanine-ui/ng/breadcrumb`

| Input       | Type                                 | Default | Description                                            |
| ----------- | ------------------------------------ | ------- | ------------------------------------------------------ |
| `items`     | `readonly BreadcrumbItemData[]`      | required| Breadcrumb item data array                             |
| `condensed` | `boolean`                            | `false` | Collapsed mode — shows only last two items + overflow  |

`BreadcrumbItemData`: `{ id?, name, href?, target?, current?, onClick? }`

```html
<nav mznBreadcrumb [items]="[
  { id: 'home', name: '首頁', href: '/' },
  { id: 'products', name: '產品', href: '/products' },
  { id: 'current', name: '詳細頁面' }
]"></nav>
```

---

### MznDrawer

**Selector**: `[mznDrawer]`
**Import**: `@mezzanine-ui/ng/drawer`

| Input                        | Type            | Default       | Description                             |
| ---------------------------- | --------------- | ------------- | --------------------------------------- |
| `open`                       | `boolean`       | `false`       | Show/hide drawer                        |
| `size`                       | `DrawerSize`    | `'medium'`    | `'small'` \| `'medium'` \| `'large'`   |
| `headerTitle`                | `string`        | —             | Header text                             |
| `isHeaderDisplay`            | `boolean`       | `false`       | Show header area                        |
| `isBottomDisplay`            | `boolean`       | `false`       | Show footer action area                 |
| `bottomPrimaryActionText`    | `string`        | —             | Primary action label                    |
| `bottomSecondaryActionText`  | `string`        | —             | Secondary action label                  |
| `bottomGhostActionText`      | `string`        | —             | Ghost action label                      |
| `disableCloseOnBackdropClick`| `boolean`       | `false`       | Prevent close on backdrop               |
| `disableCloseOnEscapeKeyDown`| `boolean`       | `false`       | Prevent close on Escape                 |
| `filterAreaShow`             | `boolean`       | `false`       | Show built-in filter area               |

**Outputs**: `closed`, `backdropClick`, `bottomPrimaryActionClick`,
`bottomSecondaryActionClick`, `bottomGhostActionClick`

```html
<section
  mznDrawer
  [open]="drawerOpen()"
  [isHeaderDisplay]="true"
  headerTitle="詳細資訊"
  [isBottomDisplay]="true"
  bottomPrimaryActionText="儲存"
  bottomSecondaryActionText="取消"
  (closed)="drawerOpen.set(false)"
  (bottomPrimaryActionClick)="save()"
  (bottomSecondaryActionClick)="drawerOpen.set(false)"
>
  <!-- drawer content -->
</section>
```

---

### MznNavigation

**Selector**: `[mznNavigation]`
**Import**: `@mezzanine-ui/ng/navigation`

| Input                  | Type                      | Default     | Description                                      |
| ---------------------- | ------------------------- | ----------- | ------------------------------------------------ |
| `activatedPath`        | `readonly string[]`       | —           | Active item path (matches `optionId` hierarchy)  |
| `collapsed`            | `boolean`                 | —           | Sidebar collapsed state                          |
| `collapsedPlacement`   | `'right'\|'left'\|'top'\|'bottom'` | `'right'` | Tooltip placement in collapsed mode    |
| `exactActivatedMatch`  | `boolean`                 | `false`     | Exact vs prefix match for activation             |
| `filter`               | `boolean`                 | `false`     | Show built-in search filter input                |
| `items`                | `readonly NavigationItemConfig[]` | —   | Data-driven option list (alternative to content projection) |

**Outputs**: `collapseChange: boolean`, `optionClick: readonly string[]`

Sub-components: `MznNavigationHeader`, `MznNavigationFooter`,
`MznNavigationOption`, `MznNavigationOptionCategory`,
`MznNavigationIconButton`, `MznNavigationUserMenu`

See [PATTERNS.md — Navigation + Layout](PATTERNS.md#navigation--layout-patterns)
for complete usage.

---

### MznNavigationOption

**Selector**: `mzn-navigation-option` (element)
**Import**: `@mezzanine-ui/ng/navigation`

| Input          | Type              | Default | Description                              |
| -------------- | ----------------- | ------- | ---------------------------------------- |
| `title`        | `string`          | required| Display label                            |
| `optionId`     | `string`          | —       | Unique ID used in `activatedPath`        |
| `icon`         | `IconDefinition`  | —       | Leading icon                             |
| `href`         | `string`          | —       | Link target                              |
| `hasChildren`  | `boolean`         | `false` | Renders expand toggle                    |
| `defaultOpen`  | `boolean`         | `false` | Start expanded                           |
| `active`       | `boolean`         | —       | Manual active override                   |

**Outputs**: `triggerClick: { path, key, href? }`

---

### MznPageHeader

**Selector**: `[mznPageHeader]`
**Import**: `@mezzanine-ui/ng/page-header`

Structural container for a page's top header region. No inputs.
Place `[mznContentHeader]` inside for title, description, and back button.

```html
<header mznPageHeader>
  <header mznContentHeader title="頁面標題"></header>
</header>
```

---

### MznPageFooter

**Selector**: `[mznPageFooter]`
**Import**: `@mezzanine-ui/ng/page-footer`

| Input                     | Type                         | Default      | Description                     |
| ------------------------- | ---------------------------- | ------------ | ------------------------------- |
| `type`                    | `'standard' \| 'sticky'`     | `'standard'` | Sticky attaches to viewport bottom |
| `annotation`              | `string`                     | —            | Footer annotation text          |
| `warningMessage`          | `string`                     | —            | Warning text                    |
| `supportingActionName`    | `string`                     | —            | Extra action button label       |
| `supportingActionIcon`    | `IconDefinition`             | —            | Extra action button icon        |
| `supportingActionVariant` | `ButtonVariant`              | `'base-ghost'`| Extra action variant           |

**Outputs**: `supportingActionClick`

---

### MznStepper

**Selector**: `[mznStepper]`
**Import**: `@mezzanine-ui/ng/stepper`

| Input         | Type                       | Default        | Description                          |
| ------------- | -------------------------- | -------------- | ------------------------------------ |
| `currentStep` | `number`                   | `0`            | Zero-based active step index         |
| `type`        | `'number' \| 'icon'`       | `'number'`     | Step indicator style                 |
| `orientation` | `'horizontal' \| 'vertical'`| `'horizontal'` | Layout direction                     |

**Outputs**: `stepChange: number`

Sub-component: `[mznStep]` — `title` (required), `description`, `icon`, `status`

```html
<div mznStepper [currentStep]="step()" (stepChange)="step.set($event)">
  <div mznStep title="基本資料"></div>
  <div mznStep title="聯絡資訊"></div>
  <div mznStep title="確認"></div>
</div>
```

---

### MznTabs / MznTabItem

**Selector**: `[mznTabs]` / `[mznTabItem]`
**Import**: `@mezzanine-ui/ng/tab`

**MznTabs inputs**:

| Input              | Type                      | Default | Description                     |
| ------------------ | ------------------------- | ------- | ------------------------------- |
| `activeKey`        | `string \| number`        | —       | Controlled active key           |
| `defaultActiveKey` | `string \| number`        | `0`     | Uncontrolled initial key        |
| `direction`        | `'horizontal' \| 'vertical'` | `'horizontal'` | Tab orientation      |
| `size`             | `'main' \| 'sub'`         | `'main'`| Tab strip size                  |

**Outputs**: `activeKeyChange: string | number`

**MznTabItem inputs**: `key` (required), `disabled`, `error`, `icon`, `badgeCount`
**Outputs**: `clicked`

```html
<div mznTabs [activeKey]="tab()" (activeKeyChange)="tab.set($event)">
  <div mznTabItem key="list">清單</div>
  <div mznTabItem key="grid">方格</div>
</div>
```

---

## Data Display

### MznAccordion

**Selector**: `[mznAccordion]`
**Import**: `@mezzanine-ui/ng/accordion`

| Input             | Type                    | Default | Description                               |
| ----------------- | ----------------------- | ------- | ----------------------------------------- |
| `title`           | `string`                | —       | Accordion header text                     |
| `expanded`        | `boolean`               | —       | Controlled expanded state                 |
| `defaultExpanded` | `boolean`               | `false` | Uncontrolled initial state                |
| `disabled`        | `boolean`               | `false` | Prevents expansion                        |
| `size`            | `'main' \| 'sub'`       | `'main'`| Size variant                              |

**Outputs**: `expandedChange: boolean`

```html
<div mznAccordion title="進階選項" [defaultExpanded]="false">
  <!-- content -->
</div>
```

---

### MznBaseCard / MznQuickActionCard

**Selector**: `[mznBaseCard]` / `[mznQuickActionCard]`
**Import**: `@mezzanine-ui/ng/card`

**MznBaseCard inputs**:

| Input                | Type                    | Default | Description               |
| -------------------- | ----------------------- | ------- | ------------------------- |
| `title`              | `string`                | —       | Card title                |
| `description`        | `string`                | —       | Card description          |
| `active`             | `boolean`               | `false` | Selected/active state     |
| `disabled`           | `boolean`               | `false` | Disabled state            |
| `readOnly`           | `boolean`               | `false` | Non-interactive           |
| `actionName`         | `string`                | —       | Action link text          |
| `actionVariant`      | `BaseCardActionVariant` | `'base-text-link'` | Action button variant |
| `options`            | `ReadonlyArray<DropdownOption>` | `[]` | Dropdown menu options |

**MznQuickActionCard inputs**: `title`, `subtitle`, `icon`, `disabled`,
`readOnly`, `mode: 'horizontal' | 'vertical'`

---

### MznDescription

**Selector**: `[mznDescription]`
**Import**: `@mezzanine-ui/ng/description`

| Input              | Type                    | Default        | Description                     |
| ------------------ | ----------------------- | -------------- | ------------------------------- |
| `title`            | `string`                | required       | Field label                     |
| `orientation`      | `'horizontal' \| 'vertical'` | `'horizontal'` | Layout direction         |
| `size`             | `DescriptionSize`       | `'main'`       | Density                         |
| `widthType`        | `'stretch' \| 'fixed'`  | `'stretch'`    | Title column width behavior     |
| `badge`            | `BadgeDotVariant`       | —              | Status dot                      |
| `icon`             | `IconDefinition`        | —              | Leading icon                    |
| `tooltip`          | `string`                | —              | Info tooltip text               |
| `tooltipPlacement` | `Placement`             | —              | Tooltip position                |

Use inside `[mznDescriptionGroup]` for grid layout.

```html
<div mznDescriptionGroup>
  <div mznDescription title="姓名">王小明</div>
  <div mznDescription title="狀態" badge="dot-success">啟用</div>
</div>
```

---

### MznEmpty

**Selector**: `[mznEmpty]`
**Import**: `@mezzanine-ui/ng/empty`

| Input         | Type           | Default          | Description                              |
| ------------- | -------------- | ---------------- | ---------------------------------------- |
| `title`       | `string`       | required         | Empty state title                        |
| `type`        | `EmptyType`    | `'initial-data'` | Illustration variant                     |
| `size`        | `EmptySize`    | `'main'`         | Component size                           |
| `description` | `string`       | —                | Explanatory text                         |
| `pictogram`   | `TemplateRef`  | —                | Custom illustration template             |
| `actions`     | `EmptyActions` | —                | Action button config                     |

```html
<div mznEmpty title="尚無資料" type="initial-data" description="請新增第一筆資料">
  <button mznButton variant="base-primary">新增</button>
</div>
```

---

### MznOverflowTooltip

**Selector**: `[mznOverflowTooltip]`
**Import**: `@mezzanine-ui/ng/overflow-tooltip`

Shows overflow tags in a tooltip when count exceeds available space.

| Input       | Type                      | Default       | Description                           |
| ----------- | ------------------------- | ------------- | ------------------------------------- |
| `tags`      | `string[]`                | required      | Tag label array                       |
| `anchor`    | `HTMLElement \| ElementRef`| required     | Positioning anchor element            |
| `open`      | `boolean`                 | `false`       | Controlled open state                 |
| `placement` | `Placement`               | `'top-start'` | Tooltip placement                     |
| `tagSize`   | `TagSize`                 | `'main'`      | Tag size inside tooltip               |
| `readOnly`  | `boolean`                 | `false`       | Suppress dismiss buttons              |

**Outputs**: `tagDismiss: number` (dismissed tag index)

---

### MznPagination

**Selector**: `[mznPagination]`
**Import**: `@mezzanine-ui/ng/pagination`

| Input               | Type      | Default | Description                         |
| ------------------- | --------- | ------- | ----------------------------------- |
| `total`             | `number`  | `0`     | Total item count                    |
| `current`           | `number`  | `1`     | Current page (1-based)              |
| `pageSize`          | `number`  | `10`    | Items per page                      |
| `disabled`          | `boolean` | `false` | Disable all controls                |
| `showJumper`        | `boolean` | `false` | Show page jump input                |
| `showPageSizeOptions`| `boolean`| `false` | Show page size selector             |
| `pageSizeOptions`   | `ReadonlyArray<number>` | — | Available page sizes          |
| `boundaryCount`     | `number`  | `1`     | Pages shown at each boundary        |
| `siblingCount`      | `number`  | `1`     | Pages shown around current          |

**Outputs**: `pageChange: number`, `pageSizeChange: number`

```html
<div
  mznPagination
  [total]="total()"
  [current]="page()"
  [pageSize]="10"
  [showJumper]="true"
  (pageChange)="page.set($event)"
></div>
```

---

### MznSection

**Selector**: `[mznSection]`
**Import**: `@mezzanine-ui/ng/section`

Content card wrapper with shadow. No inputs beyond host. Place
`[mznContentHeader]` with `size="sub"` inside for the section heading.

```html
<div mznSection>
  <header mznContentHeader title="區段標題" size="sub"></header>
  <!-- section content -->
</div>
```

---

### MznTable

**Selector**: `[mznTable]`
**Import**: `@mezzanine-ui/ng/table`

| Input              | Type                           | Default    | Description                          |
| ------------------ | ------------------------------ | ---------- | ------------------------------------ |
| `columns`          | `readonly TableColumn[]`       | required   | Column definitions                   |
| `dataSource`       | `readonly TableDataSource[]`   | `[]`       | Row data                             |
| `loading`          | `boolean`                      | `false`    | Loading overlay                      |
| `size`             | `TableSize`                    | `'main'`   | Row density                          |
| `fullWidth`        | `boolean`                      | `false`    | Stretch to 100%                      |
| `rowSelection`     | `TableRowSelection \| boolean` | `false`    | Checkbox selection config            |
| `selectedRowKeys`  | `readonly string[]`            | `[]`       | Controlled selection                 |
| `expandable`       | `TableExpandable \| boolean`   | `false`    | Row expansion config                 |
| `pagination`       | `TablePagination`              | —          | Built-in pagination config           |
| `scroll`           | `TableScroll`                  | —          | `{ x?, y? }` fixed dimensions        |
| `sticky`           | `boolean`                      | `true`     | Sticky header                        |
| `showHeader`       | `boolean`                      | `true`     | Show column header row               |
| `emptyText`        | `string`                       | `'No data'`| Empty state text                     |
| `loading`          | `boolean`                      | `false`    | Loading skeleton                     |
| `zebraStriping`    | `boolean`                      | `false`    | Alternating row background           |
| `resizable`        | `boolean`                      | `false`    | Resizable columns                    |

**Outputs**: `selectedRowKeysChange: readonly string[]`,
`expandedRowKeysChange: readonly string[]`,
`sortChange: { column, order }`

`TableColumn` key fields: `title`, `dataIndex`, `key`, `render`, `width`,
`fixed: 'left' | 'right'`, `sorter`, `align`.

```ts
protected readonly columns: ReadonlyArray<TableColumn> = [
  { title: '名稱', dataIndex: 'name', sorter: true },
  { title: '狀態', dataIndex: 'status', render: (v: string) => v },
];
```

---

### MznTooltip

**Selector**: `[mznTooltip]` (attribute directive)
**Import**: `@mezzanine-ui/ng/tooltip`

| Input                    | Type        | Default | Description                    |
| ------------------------ | ----------- | ------- | ------------------------------ |
| `mznTooltip`             | `string`    | —       | Tooltip content text           |
| `tooltipPlacement`       | `Placement` | `'top'` | Floating placement             |
| `tooltipOpen`            | `boolean`   | —       | Controlled open state          |
| `tooltipArrow`           | `boolean`   | `true`  | Show arrow                     |
| `tooltipOffset`          | `number`    | `8`     | Distance from anchor (px)      |
| `tooltipMouseLeaveDelay` | `number`    | `100`   | Hide delay (ms)                |
| `tooltipDisablePortal`   | `boolean`   | `false` | Render in-place (not body)     |

```html
<button mznButton mznTooltip="點此送出" tooltipPlacement="bottom">送出</button>
```

---

## Data Entry

### MznFormField

**Selector**: `[mznFormField]`
**Import**: `@mezzanine-ui/ng/form`
**CVA**: No (wraps CVA controls)

| Input                   | Type                     | Default       | Description                          |
| ----------------------- | ------------------------ | ------------- | ------------------------------------ |
| `name`                  | `string`                 | required      | Control name (for label association) |
| `label`                 | `string`                 | —             | Field label text                     |
| `layout`                | `FormFieldLayout`        | `HORIZONTAL`  | `HORIZONTAL` \| `VERTICAL`           |
| `required`              | `boolean`                | `false`       | Shows required marker                |
| `severity`              | `SeverityWithInfo`       | `'info'`      | `'info'` \| `'success'` \| `'warning'` \| `'error'` |
| `hintText`              | `string`                 | —             | Helper / error message               |
| `disabled`              | `boolean`                | `false`       | Greys out label                      |
| `fullWidth`             | `boolean`                | `false`       | Stretch to container width           |
| `labelOptionalMarker`   | `string`                 | —             | Text shown after label (e.g. `(選填)`) |
| `counter`               | `string`                 | —             | Character counter display            |
| `density`               | `FormFieldDensity`       | —             | Field density override               |

```html
<div mznFormField name="email" label="Email" [required]="true"
  severity="error" hintText="格式不正確" [layout]="FormFieldLayout.VERTICAL">
  <div mznInput variant="base" [error]="true" formControlName="email"></div>
</div>
```

---

### MznInput

**Selector**: `[mznInput]`
**Import**: `@mezzanine-ui/ng/input`
**CVA**: Yes

| Input           | Type              | Default | Description                                     |
| --------------- | ----------------- | ------- | ----------------------------------------------- |
| `variant`       | `InputVariant`    | —       | `'base'` \| `'password'` \| `'search'` \| etc.  |
| `fullWidth`     | `boolean`         | `true`  | Stretch to 100%                                 |
| `disabled`      | `boolean`         | `false` | Disabled state                                  |
| `error`         | `boolean`         | `false` | Error visual state                              |
| `clearable`     | `boolean`         | —       | Show clear button                               |
| `active`        | `boolean`         | `false` | Forced active/focus ring                        |
| `defaultValue`  | `string`          | —       | Uncontrolled initial value                      |
| `actionButton`  | `{ icon, tooltip?, onClick }` | — | Suffix action icon button          |
| `selectButton`  | `{ label, options? }`  | —  | Prefix select dropdown                          |

Use `formControlName` or `[formControl]` for Reactive Forms.
Use slot `prefix` / `suffix` for leading/trailing icons.

```html
<div mznInput variant="base" formControlName="name" [fullWidth]="true">
  <i mznIcon [icon]="UserIcon" slot="prefix" [size]="16"></i>
</div>
<div mznInput variant="password" formControlName="password"></div>
<div mznInput variant="search" [clearable]="true" [(ngModel)]="searchText"></div>
```

---

### MznSelect

**Selector**: `[mznSelect]`
**Import**: `@mezzanine-ui/ng/select`
**CVA**: Yes

| Input           | Type                        | Default    | Description                        |
| --------------- | --------------------------- | ---------- | ---------------------------------- |
| `options`       | `ReadonlyArray<DropdownOption>` | `[]`   | Option list `{ id, name }`         |
| `mode`          | `'single' \| 'multiple'`   | `'single'` | Single or multi-select             |
| `placeholder`   | `string`                    | `''`       | Placeholder text                   |
| `disabled`      | `boolean`                   | `false`    | Disabled state                     |
| `error`         | `boolean`                   | `false`    | Error visual state                 |
| `fullWidth`     | `boolean`                   | `false`    | Stretch to 100%                    |
| `clearable`     | `boolean`                   | `false`    | Allow clearing value               |
| `loading`       | `boolean`                   | `false`    | Show loading indicator             |
| `readOnly`      | `boolean`                   | `false`    | Non-interactive                    |
| `menuMaxHeight` | `number`                    | —          | Dropdown max height (px)           |
| `type`          | `DropdownType`              | `'default'`| `'default'` \| `'compact'`        |
| `globalPortal`  | `boolean`                   | `true`     | Render dropdown in body portal     |

```html
<div mznSelect formControlName="category" [options]="categoryOptions"
  placeholder="請選擇分類" [fullWidth]="true"></div>
```

---

### MznAutocomplete

**Selector**: `[mznAutocomplete]`
**Import**: `@mezzanine-ui/ng/autocomplete`
**CVA**: Yes

| Input        | Type                           | Default | Description                         |
| ------------ | ------------------------------ | ------- | ----------------------------------- |
| `options`    | `ReadonlyArray<DropdownOption>`| —       | Suggestion list                     |
| `addable`    | `boolean`                      | `false` | Allow creating new options          |
| `asyncData`  | `boolean`                      | `false` | Data loaded asynchronously          |
| `disabled`   | `boolean`                      | `false` | Disabled state                      |
| `error`      | `boolean`                      | `false` | Error state                         |
| `fullWidth`  | `boolean`                      | `false` | Full width                          |
| `active`     | `boolean`                      | `false` | Forced active state                 |

Use `[mznAutocompletePrefix]` on a host element to mark prefix content.

---

### MznCascader

**Selector**: `[mznCascader]`
**Import**: `@mezzanine-ui/ng/cascader`

| Input          | Type                   | Default | Description                     |
| -------------- | ---------------------- | ------- | ------------------------------- |
| `options`      | `CascaderOption[]`     | required| Nested option tree              |
| `value`        | `CascaderOption[]`     | —       | Controlled value                |
| `placeholder`  | `string`               | —       | Placeholder text                |
| `disabled`     | `boolean`              | `false` | Disabled state                  |
| `error`        | `boolean`              | `false` | Error state                     |
| `clearable`    | `boolean`              | `false` | Allow clearing                  |
| `fullWidth`    | `boolean`              | `false` | Full width                      |
| `readOnly`     | `boolean`              | `false` | Non-interactive                 |
| `size`         | `CascaderSize`         | —       | Size variant                    |
| `required`     | `boolean`              | `false` | Required marker                 |

---

### MznCheckbox

**Selector**: `[mznCheckbox]`
**Import**: `@mezzanine-ui/ng/checkbox`
**CVA**: Yes

| Input           | Type             | Default | Description                                    |
| --------------- | ---------------- | ------- | ---------------------------------------------- |
| `checked`       | `boolean`        | —       | Controlled checked state                       |
| `disabled`      | `boolean`        | `false` | Disabled state                                 |
| `error`         | `boolean`        | `false` | Error state                                    |
| `indeterminate` | `boolean`        | `false` | Indeterminate state                            |
| `label`         | `string`         | —       | Label text                                     |
| `description`   | `string`         | —       | Supporting description text                    |
| `hint`          | `string`         | —       | Hint text                                      |
| `mode`          | `CheckboxMode`   | `'default'` | `'default'` \| `'card'`                   |
| `size`          | `CheckboxSize`   | `'main'`| `'main'` \| `'sub'`                            |
| `value`         | `string`         | `''`    | Value submitted in checkbox groups             |
| `name`          | `string`         | —       | HTML name attribute                            |

Wrap multiple checkboxes in `[mznCheckboxGroup]` for group behavior.

---

### MznRadio

**Selector**: `[mznRadio]`
**Import**: `@mezzanine-ui/ng/radio`
**CVA**: Yes

| Input    | Type        | Default  | Description                            |
| -------- | ----------- | -------- | -------------------------------------- |
| `value`  | `string`    | required | Radio value                            |
| `disabled`| `boolean`  | `false`  | Disabled state                         |
| `error`  | `boolean`   | `false`  | Error state                            |
| `hint`   | `string`    | —        | Supporting hint                        |
| `icon`   | `IconDefinition` | —   | Leading icon (when `type='icon'`)      |
| `size`   | `RadioSize` | —        | Size variant                           |
| `type`   | `'radio' \| 'icon'` | `'radio'` | Render variant                 |
| `name`   | `string`    | —        | HTML name (for HTML form grouping)     |

Wrap in `[mznRadioGroup]` for exclusive selection.

---

### MznDatePicker

**Selector**: `[mznDatePicker]`
**Import**: `@mezzanine-ui/ng/date-picker`
**CVA**: Yes — value type `DateType` (string `YYYY-MM-DD`)

| Input                  | Type                              | Default | Description                      |
| ---------------------- | --------------------------------- | ------- | -------------------------------- |
| `clearable`            | `boolean`                         | `true`  | Allow clearing                   |
| `disabled`             | `boolean`                         | `false` | Disabled state                   |
| `error`                | `boolean`                         | `false` | Error state                      |
| `format`               | `string`                          | —       | Display format override          |
| `fullWidth`            | `boolean`                         | `false` | Full width                       |
| `isDateDisabled`       | `(date: DateType) => boolean`     | —       | Date disable predicate           |
| `mode`                 | `CalendarMode`                    | `'day'` | `'day'` \| `'month'` \| `'year'` \| `'half-year'` \| `'quarter'` |
| `disabledMonthSwitch`  | `boolean`                         | `false` | Lock month navigation            |
| `disabledYearSwitch`   | `boolean`                         | `false` | Lock year navigation             |
| `placeholder`          | `string`                          | —       | Placeholder text                 |
| `referenceDate`        | `DateType`                        | —       | Initial calendar focus date      |

> Requires `MZN_CALENDAR_CONFIG` or `[mznCalendarConfigProvider]` ancestor.

---

### MznDateRangePicker

**Selector**: `[mznDateRangePicker]`
**Import**: `@mezzanine-ui/ng/date-range-picker`
**CVA**: Yes — value type `[DateType, DateType] | null`

Key inputs same as `MznDatePicker` plus:

| Input                   | Type                      | Default       | Description                    |
| ----------------------- | ------------------------- | ------------- | ------------------------------ |
| `confirmMode`           | `'immediate' \| 'manual'` | `'immediate'` | When to commit range selection |
| `inputFromPlaceholder`  | `string`                  | —             | Start date placeholder         |
| `inputToPlaceholder`    | `string`                  | —             | End date placeholder           |

---

### MznDateTimePicker

**Selector**: `[mznDateTimePicker]`
**Import**: `@mezzanine-ui/ng/date-time-picker`
**CVA**: Yes — value type `DateType`

Combines date and time selection. Inherits most `MznDatePicker` inputs.
Additional: `defaultValue`, `disableOnDoubleNext`, `disableOnDoublePrev`.

---

### MznDateTimeRangePicker

**Selector**: `[mznDateTimeRangePicker]`
**Import**: `@mezzanine-ui/ng/date-time-range-picker`
**CVA**: Yes

| Input       | Type                    | Default | Description                |
| ----------- | ----------------------- | ------- | -------------------------- |
| `clearable` | `boolean`               | `true`  | Allow clearing             |
| `direction` | `'row' \| 'column'`     | `'row'` | Pickers layout direction   |
| `disabled`  | `boolean`               | `false` | Disabled state             |
| `error`     | `boolean`               | `false` | Error state                |
| `formatDate`| `string`                | —       | Date format override       |
| `formatTime`| `string`                | —       | Time format override       |
| `fullWidth` | `boolean`               | `false` | Full width                 |

---

### MznMultipleDatePicker

**Selector**: `[mznMultipleDatePicker]`
**Import**: `@mezzanine-ui/ng/multiple-date-picker`
**CVA**: Yes — value type `string[]`

| Input               | Type                           | Default     | Description                         |
| ------------------- | ------------------------------ | ----------- | ----------------------------------- |
| `clearable`         | `boolean`                      | `true`      | Allow clearing all                  |
| `disabled`          | `boolean`                      | `false`     | Disabled state                      |
| `error`             | `boolean`                      | `false`     | Error state                         |
| `format`            | `string`                       | —           | Display format                      |
| `fullWidth`         | `boolean`                      | `false`     | Full width                          |
| `maxSelections`     | `number`                       | —           | Maximum selectable count            |
| `mode`              | `CalendarMode`                 | `'day'`     | Calendar selection mode             |
| `overflowStrategy`  | `'counter' \| 'wrap'`          | `'counter'` | How to display many selected dates  |

---

### MznTimePicker

**Selector**: `[mznTimePicker]`
**Import**: `@mezzanine-ui/ng/time-picker`
**CVA**: Yes — value type `string` (`HH:mm:ss`)

| Input         | Type      | Default | Description                 |
| ------------- | --------- | ------- | --------------------------- |
| `clearable`   | `boolean` | `true`  | Allow clearing              |
| `disabled`    | `boolean` | `false` | Disabled state              |
| `error`       | `boolean` | `false` | Error state                 |
| `fullWidth`   | `boolean` | `false` | Full width                  |
| `hideHour`    | `boolean` | `false` | Hide hour column            |
| `hideMinute`  | `boolean` | `false` | Hide minute column          |
| `hideSecond`  | `boolean` | `false` | Hide second column          |
| `hourStep`    | `number`  | `1`     | Hour increment              |
| `minuteStep`  | `number`  | `1`     | Minute increment            |
| `secondStep`  | `number`  | `1`     | Second increment            |
| `placeholder` | `string`  | `''`    | Placeholder text            |
| `readOnly`    | `boolean` | `false` | Non-interactive             |

---

### MznTimeRangePicker

**Selector**: `[mznTimeRangePicker]`
**Import**: `@mezzanine-ui/ng/time-range-picker`
**CVA**: Yes

Inherits `MznTimePicker` inputs. Value type: `[string, string] | null`.

---

### MznFilterArea

**Selector**: `[mznFilterArea]`
**Import**: `@mezzanine-ui/ng/filter-area`

Container for search/filter form rows with built-in Reset + Search buttons.

| Input             | Type                      | Default    | Description                         |
| ----------------- | ------------------------- | ---------- | ----------------------------------- |
| `isDirty`         | `boolean`                 | `true`     | Whether Reset button is enabled     |
| `resetText`       | `string`                  | `'Reset'`  | Reset button label                  |
| `submitText`      | `string`                  | `'Search'` | Search button label                 |
| `size`            | `FilterAreaSize`          | `'main'`   | Field density                       |
| `actionsAlign`    | `'start' \| 'end'`        | `'end'`    | Button group alignment              |
| `rowAlign`        | `'center' \| 'flex-end'`  | `'center'` | Row vertical alignment              |
| `resetButtonType` | `'button'\|'submit'\|'reset'` | `'button'` | HTML button type           |
| `submitButtonType`| `'button'\|'submit'\|'reset'`| `'button'`| HTML button type           |

---

### MznSlider

**Selector**: `[mznSlider]`
**Import**: `@mezzanine-ui/ng/slider`
**CVA**: Yes — value type `number | [number, number]`

| Input        | Type             | Default | Description                      |
| ------------ | ---------------- | ------- | -------------------------------- |
| `min`        | `number`         | `0`     | Minimum value                    |
| `max`        | `number`         | `100`   | Maximum value                    |
| `step`       | `number`         | `1`     | Step increment                   |
| `disabled`   | `boolean`        | `false` | Disabled state                   |
| `prefixIcon` | `IconDefinition` | —       | Leading icon                     |

---

### MznTextarea

**Selector**: `[mznTextarea]`
**Import**: `@mezzanine-ui/ng/textarea`
**CVA**: Yes

| Input        | Type            | Default  | Description                              |
| ------------ | --------------- | -------- | ---------------------------------------- |
| `disabled`   | `boolean`       | `false`  | Disabled state                           |
| `placeholder`| `string`        | —        | Placeholder text                         |
| `readonly`   | `boolean`       | `false`  | Read-only                                |
| `resize`     | `TextareaResize`| `'none'` | `'none'` \| `'both'` \| `'horizontal'` \| `'vertical'` |
| `rows`       | `number`        | —        | Number of visible rows                   |
| `type`       | `TextareaType`  | `'default'` | `'default'` \| `'comment'`           |

---

### MznTextField

Built from `[mznTextFieldHost]` + internal directives. Provides a composite
input with optional prefix/suffix actions. Refer to `references/components/TextField.md`.

---

### MznToggle

**Selector**: `[mznToggle]`
**Import**: `@mezzanine-ui/ng/toggle`
**CVA**: Yes — value type `boolean`

| Input             | Type          | Default | Description                  |
| ----------------- | ------------- | ------- | ---------------------------- |
| `checked`         | `boolean`     | —       | Controlled state             |
| `disabled`        | `boolean`     | `false` | Disabled state               |
| `label`           | `string`      | —       | Label text                   |
| `size`            | `ToggleSize`  | `'main'`| `'main'` \| `'sub'`          |
| `supportingText`  | `string`      | —       | Secondary label text         |

```html
<div mznToggle [formControl]="enableCtrl" label="啟用通知"></div>
```

---

### MznSelectionCard

**Selector**: `[mznSelectionCard]`
**Import**: `@mezzanine-ui/ng/selection-card`
**CVA**: Yes

Card-style radio or checkbox control.

| Input           | Type                       | Default    | Description              |
| --------------- | -------------------------- | ---------- | ------------------------ |
| `selector`      | `'radio' \| 'checkbox'`   | —          | Control type             |
| `checked`       | `boolean`                  | —          | Controlled state         |
| `defaultChecked`| `boolean`                  | `false`    | Uncontrolled initial     |
| `disabled`      | `boolean`                  | `false`    | Disabled state           |

---

### MznUpload

**Selector**: `[mznUpload]`
**Import**: `@mezzanine-ui/ng/upload`

| Input             | Type                     | Default  | Description                          |
| ----------------- | ------------------------ | -------- | ------------------------------------ |
| `files`           | `readonly UploadFile[]`  | `[]`     | Current file list                    |
| `accept`          | `string`                 | —        | MIME types filter                    |
| `multiple`        | `boolean`                | `false`  | Allow multiple files                 |
| `maxFiles`        | `number`                 | —        | Maximum file count                   |
| `mode`            | `UploadMode`             | `'list'` | `'list'` \| `'card'` \| `'avatar'`  |
| `disabled`        | `boolean`                | `false`  | Disabled state                       |
| `showFileSize`    | `boolean`                | `true`   | Show file size in list               |
| `size`            | `UploadSize`             | `'main'` | Component size                       |
| `uploadHandler`   | `UploadHandler`          | —        | Custom upload function               |
| `errorMessage`    | `string`                 | —        | Custom error message                 |
| `hints`           | `readonly UploadHint[]`  | —        | Helper text items                    |
| `dropzoneHints`   | `readonly UploadHint[]`  | —        | Dropzone helper text                 |

---

## Feedback

### MznInlineMessage

**Selector**: `[mznInlineMessage]`
**Import**: `@mezzanine-ui/ng/inline-message`

| Input      | Type                    | Required | Description               |
| ---------- | ----------------------- | -------- | ------------------------- |
| `severity` | `InlineMessageSeverity` | Yes      | `'error'` \| `'warning'` \| `'success'` \| `'info'` |
| `content`  | `string`                | Yes      | Message text              |
| `icon`     | `IconDefinition`        | No       | Custom icon override      |

**Outputs**: `closed`

```html
@if (error()) {
  <div mznInlineMessage severity="error" [content]="error()!"></div>
}
```

---

### MznMessage (component) + MznMessageService

**Selector**: `[mznMessage]`
**Import**: `@mezzanine-ui/ng/message`

`MznMessage` is the display component rendered by `MznMessageService`.
Inject `MznMessageService` directly in application code.

```ts
private readonly message = inject(MznMessageService);
// Methods: success(), error(), info(), warning(), add(), remove()
this.message.success('儲存成功！');
this.message.error('發生錯誤', { duration: false });
```

---

### MznModal

**Selector**: `[mznModal]`
**Import**: `@mezzanine-ui/ng/modal`

| Input                         | Type           | Default      | Description                       |
| ----------------------------- | -------------- | ------------ | --------------------------------- |
| `open`                        | `boolean`      | `false`      | Show/hide modal                   |
| `modalType`                   | `ModalType`    | `'standard'` | `'standard'` \| `'side-panel'`    |
| `size`                        | `ModalSize`    | `'regular'`  | `'narrow'` \| `'regular'` \| `'wide'` \| `'extra-wide'` |
| `showModalHeader`             | `boolean`      | `false`      | Show header with title            |
| `showModalFooter`             | `boolean`      | `false`      | Show footer with confirm/cancel   |
| `title`                       | `string`       | —            | Header title                      |
| `confirmText`                 | `string`       | —            | Confirm button label              |
| `cancelText`                  | `string`       | —            | Cancel button label               |
| `loading`                     | `boolean`      | `false`      | Loading state on confirm button   |
| `showDismissButton`           | `boolean`      | `true`       | Show × close button               |
| `fullScreen`                  | `boolean`      | `false`      | Full-screen mode                  |
| `disableCloseOnBackdropClick` | `boolean`      | `false`      | Prevent close on backdrop click   |
| `disableCloseOnEscapeKeyDown` | `boolean`      | `false`      | Prevent close on Escape           |
| `modalStatusType`             | `ModalStatusType`| `'info'`   | Status icon type                  |
| `disablePortal`               | `boolean`      | `false`      | Render inline (not body portal)   |

**Outputs**: `closed`, `backdropClick`, `confirm`, `cancel`

See [PATTERNS.md — Modal & Drawer](PATTERNS.md#modal--drawer-patterns).

---

### MznNotificationCenter

**Selector**: `[mznNotificationCenter]`
**Import**: `@mezzanine-ui/ng/notification-center`

| Input                 | Type                   | Default   | Description                          |
| --------------------- | ---------------------- | --------- | ------------------------------------ |
| `severity`            | `NotificationSeverity` | `'info'`  | `'info'` \| `'success'` \| `'error'` \| `'warning'` |
| `description`         | `string`               | `''`      | Notification body text               |
| `from`                | `'right' \| 'top'`     | `'top'`   | Entry direction                      |
| `duration`            | `number \| false`      | `false`   | Auto-dismiss duration (ms)           |
| `showConfirmButton`   | `boolean`              | `false`   | Show confirm action                  |
| `confirmButtonText`   | `string`               | `'Confirm'`| Confirm button label                |
| `showCancelButton`    | `boolean`              | `false`   | Show cancel action                   |
| `cancelButtonText`    | `string`               | `'Cancel'`| Cancel button label                 |
| `showBadge`           | `boolean`              | `false`   | Show severity badge                  |
| `options`             | `ReadonlyArray<DropdownOption>` | `[]` | Dropdown action options        |
| `reference`           | `string \| number`     | —         | Unique reference key                 |

---

### MznProgress

**Selector**: `[mznProgress]`
**Import**: `@mezzanine-ui/ng/progress`

| Input          | Type             | Default      | Description                         |
| -------------- | ---------------- | ------------ | ----------------------------------- |
| `percent`      | `number`         | `0`          | Progress value 0-100                |
| `type`         | `ProgressType`   | `'progress'` | `'progress'` \| `'circle'`          |
| `status`       | `ProgressStatus` | —            | `'success'` \| `'error'` \| `'normal'` |
| `tick`         | `number`         | `0`          | Tick marks count                    |
| `percentProps` | `ProgressPercentProps` | —      | Percent label customization         |
| `icons`        | `{ success?, error? }` | —      | Status icon overrides               |

---

### MznResultState

**Selector**: `[mznResultState]`
**Import**: `@mezzanine-ui/ng/result-state`

| Input         | Type               | Default         | Description                           |
| ------------- | ------------------ | --------------- | ------------------------------------- |
| `title`       | `string`           | required        | Result title                          |
| `description` | `string`           | —               | Explanatory text                      |
| `type`        | `ResultStateType`  | `'information'` | `'success'` \| `'error'` \| `'warning'` \| `'information'` \| `'empty'` |
| `size`        | `ResultStateSize`  | `'main'`        | Component size                        |

```html
<div mznResultState type="success" title="送出成功" description="資料已儲存。">
  <button mznButton variant="base-primary">返回列表</button>
</div>
```

---

### MznSkeleton

**Selector**: `[mznSkeleton]`
**Import**: `@mezzanine-ui/ng/skeleton`

| Input     | Type                    | Default | Description                           |
| --------- | ----------------------- | ------- | ------------------------------------- |
| `width`   | `number \| string`      | —       | Width (number = px, string = any unit)|
| `height`  | `number \| string`      | —       | Height                                |
| `circle`  | `boolean`               | `false` | Circle shape (for avatars)            |
| `variant` | `TypographySemanticType`| —       | Match a typography variant's height   |

```html
<div mznSkeleton width="200" height="24"></div>
<div mznSkeleton [circle]="true" width="40" height="40"></div>
```

---

### MznSpin

**Selector**: `[mznSpin]`
**Import**: `@mezzanine-ui/ng/spin`

| Input                  | Type           | Default | Description                              |
| ---------------------- | -------------- | ------- | ---------------------------------------- |
| `loading`              | `boolean`      | `false` | Show spinner                             |
| `size`                 | `GeneralSize`  | `'main'`| `'main'` \| `'sub'` \| `'minor'`        |
| `description`          | `string`       | —       | Loading description text                 |
| `stretch`              | `boolean`      | `false` | Fill parent container                    |
| `color`                | `string`       | —       | Custom spinner color                     |
| `trackColor`           | `string`       | —       | Custom track color                       |
| `backdropProps`        | `SpinBackdropProps` | `{}` | Backdrop overlay config               |

Wraps content: shows spinner overlay when `loading=true`, content underneath.

```html
<div mznSpin [loading]="isLoading()" size="main" [stretch]="true">
  <app-data-table />
</div>
```

---

## Layout

### MznLayout

**Selector**: `[mznLayout]`
**Import**: `@mezzanine-ui/ng/layout`

| Input                      | Type     | Default | Description                           |
| -------------------------- | -------- | ------- | ------------------------------------- |
| `contentWrapperClassName`  | `string` | —       | Extra class on content wrapper        |
| `navigationClassName`      | `string` | —       | Extra class on navigation wrapper     |

Sub-components: `[mznLayoutMain]`, `[mznLayoutLeftPanel]`, `[mznLayoutRightPanel]`

Use `MznLayout` as the root shell wrapping `MznNavigation` + content area.

---

## Others

### MznAlertBanner

**Selector**: `[mznAlertBanner]`
**Import**: `@mezzanine-ui/ng/alert-banner`

| Input          | Type                     | Default | Description                          |
| -------------- | ------------------------ | ------- | ------------------------------------ |
| `severity`     | `AlertBannerSeverity`    | required| `'info'` \| `'success'` \| `'warning'` \| `'error'` |
| `message`      | `string`                 | required| Banner message text                  |
| `closable`     | `boolean`                | `true`  | Show close button                    |
| `actions`      | `ReadonlyArray<AlertBannerAction>` | `[]` | Action button list          |
| `createdAt`    | `number`                 | —       | Timestamp (for notification use)     |
| `icon`         | `IconDefinition`         | —       | Custom icon override                 |
| `reference`    | `string \| number`       | —       | Unique reference key                 |
| `disablePortal`| `boolean`                | `false` | Render inline                        |

**Outputs**: `closed`

```html
@if (showBanner()) {
  <div mznAlertBanner severity="warning"
    message="系統維護公告：今晚 22:00 停機 2 小時。"
    (closed)="showBanner.set(false)">
  </div>
}
```

---

### MznAnchor

**Import**: `@mezzanine-ui/ng/anchor`

Page-anchoring navigation component. See `references/components/Anchor.md`.

---

### MznBackdrop

**Selector**: `[mznBackdrop]`
**Import**: `@mezzanine-ui/ng/backdrop`

| Input                         | Type              | Default  | Description                      |
| ----------------------------- | ----------------- | -------- | -------------------------------- |
| `open`                        | `boolean`         | `false`  | Show backdrop                    |
| `variant`                     | `BackdropVariant` | `'dark'` | `'dark'` \| `'transparent'`      |
| `disableScrollLock`           | `boolean`         | `false`  | Skip scroll locking              |
| `disableCloseOnBackdropClick` | `boolean`         | `false`  | Prevent close on click           |
| `disablePortal`               | `boolean`         | `false`  | Render inline                    |
| `container`                   | `HTMLElement \| ElementRef \| null` | — | Portal container     |

**Outputs**: `backdropClick`, `closed`

---

### MznFloatingButton

**Selector**: `[mznFloatingButton]`
**Import**: `@mezzanine-ui/ng/floating-button`

| Input            | Type              | Default | Description                            |
| ---------------- | ----------------- | ------- | -------------------------------------- |
| `icon`           | `IconDefinition`  | —       | FAB icon                               |
| `open`           | `boolean`         | `false` | Whether the FAB menu is open           |
| `disabled`       | `boolean`         | `false` | Disabled state                         |
| `loading`        | `boolean`         | `false` | Loading state                          |
| `iconType`       | `ButtonIconType`  | —       | Icon arrangement                       |
| `autoHideWhenOpen`| `boolean`        | `false` | Hide FAB when menu open                |
| `disabledTooltip`| `boolean`         | `false` | Suppress tooltip                       |

---

## Utility

### MznCalendar

**Selector**: `[mznCalendar]`
**Import**: `@mezzanine-ui/ng/calendar`

Headless calendar grid component used internally by date pickers. Can be used
directly for custom date selection UIs.

| Input                  | Type                                       | Default | Description               |
| ---------------------- | ------------------------------------------ | ------- | ------------------------- |
| `mode`                 | `CalendarMode`                             | `'day'` | Selection mode            |
| `value`                | `DateType \| ReadonlyArray<DateType>`      | —       | Selected date(s)          |
| `referenceDate`        | `DateType`                                 | `''`    | Calendar focus date       |
| `disabledMonthSwitch`  | `boolean`                                  | `false` | Lock month nav            |
| `disabledYearSwitch`   | `boolean`                                  | `false` | Lock year nav             |
| `isDateDisabled`       | `(date: DateType) => boolean`              | —       | Disable predicate         |
| `isDateInRange`        | `(date: DateType) => boolean`              | —       | Range highlight predicate |
| `noShadow`             | `boolean`                                  | `false` | Remove card shadow        |

> Requires `MZN_CALENDAR_CONFIG` or `[mznCalendarConfigProvider]` ancestor.

---

### MznNotifierService

**Import**: `@mezzanine-ui/ng/notifier`
**Type**: `Injectable({ providedIn: 'root' })`

Low-level notification queue manager. Use `MznMessageService` for toasts.

```ts
readonly displayed: Signal<ReadonlyArray<NotifierData>>
readonly queued: Signal<ReadonlyArray<NotifierData>>

config(config: Partial<NotifierConfig>): void
getConfig(): Readonly<NotifierConfig>
add(data: Partial<NotifierData> & { message?: string }): string  // returns key
remove(key: string): void
```

---

### MznPopper

**Selector**: `[mznPopper]`
**Import**: `@mezzanine-ui/ng/popper`

Floating positioning primitive (wraps `@floating-ui/dom`).

| Input           | Type                       | Default     | Description               |
| --------------- | -------------------------- | ----------- | ------------------------- |
| `anchor`        | `HTMLElement \| ElementRef \| null` | — | Positioning anchor    |
| `open`          | `boolean`                  | `false`     | Show/hide                 |
| `placement`     | `PopperPlacement`          | `'bottom'`  | Floating placement        |
| `offsetOptions` | `PopperOffsetOptions`      | —           | Offset config             |
| `arrowOptions`  | `PopperArrowOptions`       | —           | Arrow config              |
| `middleware`    | `ReadonlyArray<Middleware>` | —          | Extra floating-ui middleware |

---

### MznPortal

**Import**: `@mezzanine-ui/ng/portal`
**Service**: `MznPortalRegistry`

Renders content at a different DOM location (default: `document.body`).
Used internally by Modal, Drawer, Select, Popper, etc.

---

### MznCollapse (Transition)

**Selector**: `[mznCollapse]`
**Import**: `@mezzanine-ui/ng/transition`

| Input             | Type                | Default | Description                       |
| ----------------- | ------------------- | ------- | --------------------------------- |
| `in`              | `boolean`           | `false` | Expanded state                    |
| `collapsedHeight` | `string \| number`  | `0`     | Height when collapsed             |
| `duration`        | `TransitionDuration`| `'auto'`| Transition duration               |
| `easing`          | `TransitionEasing`  | —       | CSS easing function               |
| `keepMount`       | `boolean`           | `false` | Keep DOM when collapsed           |
| `delay`           | `TransitionDelay`   | `0`     | Transition delay                  |

---

## Angular-only Components

Components that exist only in the Angular package (no React counterpart).

### MznThumbnail

**Selector**: `[mznThumbnail]`
**Import**: `@mezzanine-ui/ng/thumbnail`

| Input   | Type     | Default | Description    |
| ------- | -------- | ------- | -------------- |
| `title` | `string` | —       | Thumbnail title|

Image/video thumbnail container with overlay actions.

---

### MznSingleThumbnailCard *(已廢棄 v1.0.0-rc.4)*

> **已廢棄** — `thumbnail-cards` package removed in v1.0.0-rc.4. These components still resolve from their individual sub-paths but the shared `thumbnail-cards` entry point is gone. Prefer the individual packages listed below or migrate to `MznQuickActionCard`.

**Import**: `@mezzanine-ui/ng/single-thumbnail-card`

Card layout with a single `16:9` thumbnail. Includes
`MznSingleThumbnailCardSkeleton` for loading states.

| Input                  | Type              | Default   | Description              |
| ---------------------- | ----------------- | --------- | ------------------------ |
| `thumbnailAspectRatio` | `string`          | `'16/9'`  | CSS aspect-ratio value   |
| `thumbnailWidth`       | `number \| string`| —         | Thumbnail column width   |

---

### MznFourThumbnailCard *(已廢棄 v1.0.0-rc.4)*

**Import**: `@mezzanine-ui/ng/four-thumbnail-card`

Card layout with a 2×2 thumbnail grid. Includes
`MznFourThumbnailCardSkeleton`.

| Input            | Type              | Default | Description            |
| ---------------- | ----------------- | ------- | ---------------------- |
| `thumbnailWidth` | `number \| string`| `200`   | Grid container width   |

---

### MznThumbnailCardInfo *(已廢棄 v1.0.0-rc.4)*

**Selector**: `[mznThumbnailCardInfo]`
**Import**: `@mezzanine-ui/ng/thumbnail-card-info`

Info panel section used inside thumbnail card layouts.

| Input         | Type                          | Default     | Description                    |
| ------------- | ----------------------------- | ----------- | ------------------------------ |
| `title`       | `string`                      | —           | Card title                     |
| `subtitle`    | `string`                      | —           | Card subtitle                  |
| `filetype`    | `string`                      | —           | File type label                |
| `actionName`  | `string`                      | —           | Action button label            |
| `type`        | `ThumbnailCardInfoType`       | `'default'` | Info layout variant            |
| `disabled`    | `boolean`                     | `false`     | Disabled state                 |
| `options`     | `ReadonlyArray<DropdownOption>`| `[]`        | Dropdown menu options          |

**Outputs**: `actionClick: MouseEvent`

---

### MznMediaPreviewModal

**Selector**: `[mznMediaPreviewModal]`
**Import**: `@mezzanine-ui/ng/media-preview-modal`

| Input                       | Type                          | Default | Description                           |
| --------------------------- | ----------------------------- | ------- | ------------------------------------- |
| `open`                      | `boolean`                     | `false` | Show modal                            |
| `mediaItems`                | `ReadonlyArray<MediaPreviewItem>` | `[]` | Media item array                    |
| `defaultIndex`              | `number`                      | `0`     | Initial active item index             |
| `currentIndex`              | `number`                      | —       | Controlled active index               |
| `disableNext`               | `boolean`                     | `false` | Disable forward navigation            |
| `disablePrev`               | `boolean`                     | `false` | Disable backward navigation           |
| `enableCircularNavigation`  | `boolean`                     | `false` | Wrap around at ends                   |
| `showPaginationIndicator`   | `boolean`                     | `true`  | Show dot indicator                    |

---

## Internal / Deprecated

These exist in the package but are either implementation details or legacy.
Do not use directly in application code.

| Component / Directive     | Selector                   | Notes                                             |
| ------------------------- | -------------------------- | ------------------------------------------------- |
| `MznClearActions`         | `button[mznClearActions]`  | Internal close-button used by Drawer/Modal        |
| `MznContentHeader`        | `[mznContentHeader]`       | Use inside `[mznPageHeader]` or `[mznSection]`. Inputs: `title` (req), `description`, `size`, `showBackButton`, `titleComponent`. Output: `backClick` |
| `MznDropdownAction`       | `[mznDropdownAction]`      | Internal dropdown footer actions for Select/Autocomplete |
| `MznScrollbar`            | `[mznScrollbar]`           | Custom scrollbar used internally by Navigation    |
