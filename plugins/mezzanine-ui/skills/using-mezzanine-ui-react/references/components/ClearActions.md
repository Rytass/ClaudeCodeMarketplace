# ClearActions Component

> **Export status (1.10.2)**: Source exists at `packages/react/src/ClearActions` but is **not re-exported from `src/index.ts`**, so `import { ClearActions } from '@mezzanine-ui/react'` does not work. Import it via the sub-path `@mezzanine-ui/react/ClearActions` (default export; `ClearActionsProps` as a type export). It is a real, functional component (not deprecated) and is used internally by Modal, Drawer, TextField, InlineMessage, AlertBanner, and Upload.

> **Category**: Internal (sub-path only)
>
> **Storybook**: `Internal/ClearActions`
>
> **Source**: [GitHub Source Code](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/react/src/ClearActions) · Verified 1.10.2 (2026-11-22)

Clear/close button component providing a unified close button style. Used for close functionality in Modal, Drawer, AlertBanner, and other components.

## Import

```tsx
// Internal component, not publicly exported from @mezzanine-ui/react
// Must be imported from sub-path
import ClearActions from '@mezzanine-ui/react/ClearActions';
import type { ClearActionsProps } from '@mezzanine-ui/react/ClearActions';
```

> **Note**: ClearActions is not exported from the `@mezzanine-ui/react` main entry (`src/index.ts`); use the sub-path import above. The variant types (`ClearActionsStandardVariant`, `ClearActionsEmbeddedVariant`, `ClearActionsVariant`, `ClearActionsType`) live in `@mezzanine-ui/core/clear-actions`.

---

## ClearActions Props

| Property  | Type                                      | Default      | Description       |
| --------- | ----------------------------------------- | ------------ | ----------------- |
| `className` | `string`                                 | -            | Custom CSS class name (inherited from native `<button>` props) |
| `onClick` | `MouseEventHandler<HTMLButtonElement>`    | -            | Click callback    |
| `type`    | `'standard' \| 'embedded' \| 'clearable'` | `'standard'` | Usage context type |
| `variant` | `ClearActionsStandardVariant \| ClearActionsEmbeddedVariant` | `'base'` (standard) / `'contrast'` (embedded) | Visual variant (optional; not available when `type='clearable'`, see below) |

> `ClearActionsProps` 為 discriminated union，其餘原生 `<button>` 屬性（排除 `key`、`ref`、`onClick`、`type`）皆可傳入（含 `className`）；`onClick` 型別為 `React.MouseEventHandler<HTMLButtonElement>`。元件固定渲染 `type="button"`，預設 `aria-label="Close"`（可被傳入值覆蓋）。
>
> **Discriminated Union rules**:
> - `type='standard'`（或省略）→ `variant?: 'base' | 'inverse'`（預設 `'base'`）
> - `type='embedded'` → `variant?: 'contrast' | 'emphasis'`（預設 `'contrast'`）
> - `type='clearable'` → no `variant` prop（內部固定使用 `'default'`）

---

## ClearActions Type

| Type        | Description                                | Icon                |
| ----------- | ------------------------------------------ | ------------------- |
| `standard`  | Standard close button (Modal, Drawer)      | CloseIcon           |
| `embedded`  | Embedded close button (contrast background) | CloseIcon          |
| `clearable` | Clear button (Input clear functionality)   | DangerousFilledIcon |

---

## ClearActions Variant

### Standard Type Variants

| Variant   | Description          |
| --------- | -------------------- |
| `base`    | Base style (default) |
| `inverse` | Inverse color style  |

### Embedded Type Variants

| Variant    | Description              |
| ---------- | ------------------------ |
| `contrast` | Contrast style (default) |
| `emphasis` | Emphasis style           |

### Clearable Type Variants

Uses fixed `default` variant.

---

## Usage Examples

### Standard Type (Modal Close Button)

```tsx
<ClearActions
  type="standard"
  variant="base"
  onClick={handleClose}
/>
```

### Embedded Type (On Dark Background)

```tsx
<ClearActions
  type="embedded"
  variant="contrast"
  onClick={handleClose}
/>
```

### Clearable Type (Input Clear)

```tsx
<ClearActions
  type="clearable"
  onClick={handleClear}
/>
```

---

## Usage in Other Components

### Modal

```tsx
// Modal internally uses ClearActions
<ModalHeader>
  <Typography>Title</Typography>
  <ClearActions type="standard" onClick={onClose} />
</ModalHeader>
```

### TextField

```tsx
// TextField internally uses ClearActions
<TextField clearable onClear={handleClear}>
  {/* ClearActions type="clearable" is rendered automatically */}
</TextField>
```

### AlertBanner

```tsx
// AlertBanner internally uses ClearActions for its close button
```

---

## Accessibility

- Automatically sets `aria-label="Close"`
- Button type is `type="button"`

---

## Figma Mapping

| Figma Variant                   | React Props                  |
| ------------------------------- | ---------------------------- |
| `ClearActions / Standard`       | `type="standard"` (default)  |
| `ClearActions / Embedded`       | `type="embedded"`            |
| `ClearActions / Clearable`      | `type="clearable"`           |

---

## Best Practices

1. **Use higher-level components**: Generally do not use ClearActions directly; use Modal, Drawer, AlertBanner, and similar components instead
2. **Context selection**: Choose appropriate type based on usage context
3. **Contrast colors**: Use `embedded` type on dark backgrounds
4. **Clear functionality**: Use `clearable` type for input clear functionality
