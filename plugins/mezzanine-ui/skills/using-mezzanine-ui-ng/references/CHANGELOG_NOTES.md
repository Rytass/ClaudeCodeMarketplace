# 歷代 What's New（rc.26 以前）

> 從 SKILL.md 搬出的版本歷史，保留原文。目前版本的變更見 SKILL.md〈What's New in 1.0.0-rc.26〉。

## What's New in 1.0.0-rc.10（rc.5 – rc.10）

> 涵蓋 rc.5 – rc.10（6 個 release）。核對自 `packages/ng/CHANGELOG.md` 與原始碼。

### ⚠️ Breaking — output 全面改名（rc.9）

`MznSelect` 與 `MznDropdown` 的 output 大量改名。**Angular template 綁一個不存在的 output 不會有編譯錯誤，只會靜默不觸發**，升級後務必全域搜尋替換：

| Directive     | 舊名                                                                                              | 新名                                                                        |
| ------------- | ------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------- |
| `MznSelect`   | `selectionChange` `onScroll` `onReachBottom` `onLeaveBottom`                                      | `change` `scroll` `reachBottom` `leaveBottom`                               |
| `MznDropdown` | `selected` `closed` `itemHovered` `actionCancelled` `actionCleared` `actionConfirmed` `actionCustomClicked` | `select` `close` `itemHover` `actionCancel` `actionClear` `actionConfirm` `actionCustom` |

> **只有主元件改名。** `MznDropdownItem` / `MznDropdownAction` / `MznDropdownItemCard` 維持舊名 —— 不要做全域無差別取代。

`MznDropdown` 同時移除 `actionConfig` / `name` / `showCheckIcon` / `showHeader` / `disableClickAway`，並改用 CDK Overlay 重寫 popover。

### 其他變更

- **`MznInput`（rc.7）** — 掛在原生 `<input>` / `<textarea>` 上時改為**初始化即 throw**。先前這樣寫會讓 CVA 脫鉤、`ngModel` 靜默失效，現在變成一眼可見的錯誤。見 [Input.md](components/Input.md#selector)。
- **`MznDropdown` / `MznSelect`（rc.8）** — 新增 `flip` input，視窗底部空間不足時翻轉選單。
- **`MznSelect`（rc.9）** — 補上一批對齊 React 的 input：`value` / `defaultValue` / `warning` / `searchText` / `inputProps` / `suffixAction` / `forceXxx` 等，並新增 `blur` / `clear` / `focus` / `tagClose` output。
- **`MznAutocomplete`** — 提供 `caseSensitive` input（預設 `false`，搜尋比對不分大小寫），對應 React 的同名 prop。
- **`MznTable`（rc.6）** — 欄寬調整改為優先向最右欄借用空間，與 React 對齊。
- **`MznCalendar`（rc.5）** — 僅新增 Temporal adapter 的 story，無 API 變更。


---

## What's New in 1.0.0-rc.4

**純版本對齊（No Angular source changes）**

`@mezzanine-ui/ng@1.0.0-rc.4` is a compatibility bump paired with `@mezzanine-ui/core@1.0.4`. Zero Angular source files changed in this cycle.

- **Pair with `@mezzanine-ui/core@1.0.4`** — the core release fixed React-side picker positioning (globalPortal + flip). Angular was already correct: `MznInputTriggerPopper` ships with `globalPortal=true` and `MznPopper` enables `flip()` by default, so no behaviour change on the Angular side.
- **No prop changes** — 0 component APIs modified.
- **Removed: `ThumbnailCards` 聚合入口** — the `thumbnail-cards` aggregate package is removed; there is no longer a shared entry point. Import the individual components instead (they remain exported and supported in rc.26):
  - `MznSingleThumbnailCard` (`@mezzanine-ui/ng/single-thumbnail-card`)
  - `MznFourThumbnailCard` (`@mezzanine-ui/ng/four-thumbnail-card`)
  - `MznSingleThumbnailCardSkeleton` / `MznFourThumbnailCardSkeleton`
  - `MznQuickActionCard` (`@mezzanine-ui/ng/quick-action-card`)

**升級方式 (upgrade)**:

```bash
yarn add @mezzanine-ui/ng@1.0.0-rc.4 @mezzanine-ui/core@1.0.4
```
