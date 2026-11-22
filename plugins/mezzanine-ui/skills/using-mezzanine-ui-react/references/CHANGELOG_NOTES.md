# Mezzanine-UI React — 歷代 What's New 與核實紀錄（1.5.1 以前）

> 從 `SKILL.md` 搬出的歷史段落，**保留原文**（僅在 Dropdown `shift` 一處加上更正註記）。
> 要查「某個 prop 現在到底存不存在／預設值是多少」，**以 [components/*.md](components/) 為準**，不要以本檔的歷史敘事為準。
> 1.6 以後的變更見 [SKILL.md](../SKILL.md) 的〈What's New in v1.10.2〉。

---

## What's New in v1.5.1

> 涵蓋 1.4.3 – 1.5.1（4 個 release）累積變更。**1.5.1 本身只修正一個 Storybook-only 缺陷**（`TabsSize` story 的 `activeKey` 對不到任何 tab，因為共用的 item 陣列被包成 Fragment，`flattenChildren` 會把 Fragment 自己的 key 疊加到每個子項上，`<TabItem key="0">` 因此被併成 `"0.0"`）——**`Tabs` 元件本體未變動**，實測 1.5.0 → 1.5.1 已發布套件僅 `package.json` 有差異（跟著 bump `core@1.2.1`）。真正的實質變更在 **1.5.0**。

### 無障礙（Accessibility）大修 — 1.5.0

- **`Modal` / `MediaPreviewModal`** — 新增 `useFocusTrap` hook（已列入元件索引），實作真正的 dialog focus model：開啟時把焦點移入對話框（第一個可聚焦元素；若沒有可聚焦元素，改聚焦內容容器本身，靠新加的 `tabIndex={-1}`）、`Tab` / `Shift+Tab` 只在對話框內循環、關閉時把焦點還原到開啟前的元素，並且能感知巢狀 dialog。鍵盤使用者不會再 Tab 出對話框、跑到背後的頁面；對話框現在也標記 `aria-modal`。
- **`Tooltip`** — 內容現在可被指標、鍵盤、輔助科技存取：render-prop payload 新增 `onFocus` / `onBlur`（focus 開啟、blur 關閉），內容節點帶上 `role="tooltip"` 與穩定的 `useId`，接到觸發元素的 `aria-describedby`。純 icon 的 `Button` 上的 tooltip 文字，現在鍵盤操作與螢幕報讀器也讀得到，不再只有滑鼠 hover 才有。新的 focus 觸發**只在 `:focus-visible`（鍵盤聚焦）才開啟**，瀏覽器給 `<button>` 的 mousedown focus 不會觸發——避免點擊 icon-only 按鈕後 tooltip 卡在畫面上蓋住別的東西（例如 Table row action 的 dropdown）。仍符合 WCAG 2.1 SC 1.4.13。
- **`Button`** — icon-only 模式下會把呼叫端自己的 `ref` 與 tooltip 的 `ref` 組合起來，傳入自己的 ref 不會再讓 tooltip 失效。
- **`Navigation`** — 移除無效的 `menuitem` role（改正確標示群組／葉節點），每個導覽控制項現在都能正確向輔助科技播報。
- **`Table`** — icon-only 與 dropdown 的 row-action 按鈕補上 accessible name；row-action 選單維持在可視範圍內（原本最後一欄或水平捲動時會被裁切在右邊界，且沒有可調整的 prop）。
- **`Dropdown`** — 加上 floating-ui 的 `shift` middleware（依 floating-ui 建議排在 `flip` 之後），選單貼近視窗右邊界時會被推回可視範圍而非被裁切。**新增 API**：`shift?: boolean`。
  > **更正（1.10.2 同步）**：`Dropdown` 的 `shift` 預設值**已是 `true`**（1.8.0 起預設啟用；要關掉請傳 `shift={false}`），並非「無預設的新增 API」。以 [Dropdown.md](components/Dropdown.md) 為準。
- **`TextField`** — 原生 input 的 ARIA 語意保留不被覆蓋。
- **`InlineMessage`** — 呼叫端傳入的 DOM props 會被展開到根節點。
- **`ContentHeader`** — 返回鈕文字改為可翻譯。
- **`PageFooter`** — 不再渲染沒有名稱的空按鈕。

### `DateRangePicker` 正確性與效能 — 1.5.0

- Hover 預覽不再洗掉已提交的範圍——先選起點、移動游標（哪怕只是切換月份讓游標劃過某個 cell）再點終點，過去會把起點丟掉、重新開始選取。`RangeCalendar` 現在讀已提交值而非被 hover 污染的 `calendarValue`，來判斷這次點擊該開始還是結束範圍。
- Hover 高亮預覽與點擊防呆邏輯現在問的是同一個問題，預覽不會再顯示一個下一次點擊就會被拒絕的範圍。
- 大範圍不再卡頓數秒——停用日期掃描原本不管有沒有真的設 disabled-date predicate、每次 render 都逐日重掃六次（每個時間粒度各一次），20 年範圍每次 render 約 524ms，年份打錯（例如透過輸入框打出 `4026`）可以卡到 50 秒。掃描邏輯移到 `RangeCalendar`，只在真的有 predicate 時才跑、依當前粒度單位跳步，並設有掃描步數上限（超過上限就回報「找不到停用日期」，讓過長範圍維持可操作而非整個凍結）。**該步數上限是 `useRangeScan.ts` 內部常數，不是 public prop。**
- **`RangeCalendarProps`** 新增 `previewValue`。
- **`Calendar`** — 對齊週次掃描邏輯，修正不完整範圍時的驗證。

### 其他修正 — 1.4.3 / 1.4.4

- **`Form` / `TagsField`、`AutoComplete`、`Dropdown`、`Pagination`、`DatePicker` / `TimePicker`**（1.4.3）— 修正一整類 CJK IME bug：按 Enter 確認注音／拼音候選字時，不再誤觸發送出／選取／確認動作。靠 `core@1.2.0` 新增的共用 `isImeComposing` helper（同時把 Safari 的 `keyCode 229` 也視為 composing 中）。
- **`Notifier` / `Message`**（1.4.4）— 修正短時間內連發多則訊息會靜默合併成一則的問題：auto-key 過去只取 `Date.now()`（毫秒解析度），同一毫秒建立的多個 notifier 會撞 key、被當成「更新」而非新增；現在 auto-key 在時鐘沒走的情況下會往下跳號，維持單調遞增。
- **`Table`**（1.4.4）— `loading` 期間不再把偽造的 `{ key: idx }` placeholder row 塞進 consumer 的 record callback（`column.render` / `actions.render` / `rowState` / `getCheckboxProps` / `rowExpandable` / `expandedRowRender` / `isRowDisabled`），避免這些 callback 存取不存在的欄位丟出 `TypeError`；`record` 在 row / cell 型別上改為 optional，並且 placeholder row 不再借用真實 row key（不會再被誤判為選取中／可展開，或被 `Draggable` 包住）。

### 新公開 API 一覽（1.4.3 – 1.5.1）

| API | 說明 |
| --- | --- |
| `Dropdown` → `shift?: boolean` | floating-ui `shift` middleware，見上 |
| `RangeCalendarProps` → `previewValue` | 見上 |
| `NavigationHeaderProps` → `collapseToggleLabel` | 收合按鈕的可翻譯 label，隨 1.5.0 a11y 修正一併補上 |

> `maxRangeScanSteps` **不是** public API——它是 `useRangeScan.ts` 內的常數，從未被匯出，不要當成 prop 使用或寫進呼叫端程式碼。

**相依套件版本**：`@mezzanine-ui/core` `1.2.1`、`@mezzanine-ui/system` `1.0.2`、`@mezzanine-ui/icons` `1.0.2`（三個相依皆為**精確釘版**，非 `>=`）。core 由 `1.2.0`（1.4.3 起要求）bump 到 `1.2.1`（1.5.1 起要求）。

<details>
<summary>Previous: What's New in v1.4.2</summary>

## What's New in v1.4.2

- **`AutoComplete`** — 選項比對預設從**大小寫敏感改為不敏感**（先前比對 RegExp 漏了 `i` flag，輸入 `vir` 找不到 `Virginia`）。新增 `caseSensitive?: boolean`（預設 `false`）供退回舊行為；`addable` 模式的重複檢查（`isSameOptionName()`）也一併尊重這個 flag，避免對只差大小寫的既有選項再提供「建立」動作。**這是行為變更，倚賴舊行為的專案升級後需明確傳 `caseSensitive`。**
- **`Dropdown`** — option `mousedown` 時保留 trigger focus，修正 `AutoComplete` 篩選文字在 blur 時被清空。純內部修正，無 API 變更。

> 1.4.2 只動到 `AutoComplete` 家族與 `Dropdown` 內部事件處理。（此段為 1.4.2 當時的敘述；自 1.5.1 同步起，全部 68 份現役元件文件皆已標 `Verified 1.5.1`。）

</details>

---

## What's New in v1.4.1

> 涵蓋 1.2.0 – 1.4.1（5 個 release）累積變更。詳見各元件文件與 [GitHub Releases](https://github.com/Mezzanine-UI/mezzanine/releases)。

### 元件移除／未匯出狀況（已依 CHANGELOG 與 git tag 逐版核對）

> **1.4.1 本身沒有移除任何元件。** 1.4.1 只有兩個 bug fix（見下方）。
> 下表是這四個元件**目前**的實際狀態，以及它們真正變動的版本 —— 核對自 `packages/react/CHANGELOG.md` 與各 tag 的 `packages/react/src/index.ts`。

| 元件            | 實際狀態                                                                                       | 變動版本                              | 遷移指引                                             |
| --------------- | ---------------------------------------------------------------------------------------------- | ------------------------------------- | ---------------------------------------------------- |
| `Switch`        | **真的移除**：原始碼目錄 `src/Switch/` 已不存在，由 `Toggle` 取代                              | `1.0.0-canary.3`（canary.2 仍存在）   | 一律改用 `<Toggle>`，公開 API 刻意對齊               |
| `ClearActions`  | **仍存在於原始碼**（`src/ClearActions/`），**從未**從主入口匯出，一直是 sub-path only            | 無 —— 從 0.0.1 至 1.4.2 都不在主入口 | 主入口取不到；需要時走 `@mezzanine-ui/react/ClearActions` |
| `ContentHeader` | **仍存在於原始碼**（`src/ContentHeader/`），**從未**從主入口匯出；`PageHeader` / `Section` 內部仍**必須**用它 | 無 —— 同上                            | 走 sub-path `@mezzanine-ui/react/ContentHeader`      |
| `Scrollbar`     | **仍存在於原始碼**（`src/Scrollbar/`），**從未**從主入口匯出                                    | 無 —— 同上                            | 走 sub-path，或改用原生滾動 / CSS 自訂捲軸樣式        |

> **重要更正**：先前版本的本文件宣稱「這四個元件於 1.1.0 標記棄用、1.4.1 完成移除」，**與原始碼不符**。
> 逐一比對 `0.0.1` → `1.4.2` 全部 tag 的 `src/index.ts` 後確認：
> - `Switch` 從 `0.0.1` 起就在主入口，直到 `1.0.0-canary.3` 被 `Toggle` 取代；
> - 另外三個**從未**出現在主入口，因此不存在「移除」這件事，也沒有任何 `@deprecated` 標記；
> - `1.1.0` – `1.4.2` 之間的 CHANGELOG **沒有任何**元件移除或棄用紀錄。

### 新增功能 (Improvements)

- **`Select`**（1.4.0）— 新增 opt-in `flip?: boolean` prop（預設 `false`），轉發給底層 `Dropdown`。啟用後選單在視窗底部空間不足時會往上翻轉，同時保持寬度與錨點水平對齊。
- **`Dropdown`**（1.4.0）— `flip` 啟用時僅沿主軸（`bottom-start` ↔ `top-start`）翻轉，不做 shift/cross-axis 位移，`sameWidth` 選單維持水平對齊；進場動畫方向現在會跟隨 floating-ui 實際翻轉後的方向，不再固定用翻轉前的方向播放。
- **`Popper`**（1.4.0）— 新增 `onPlacementChange` callback，於 floating-ui 解析出的 placement（含 middleware 翻轉後結果）變動時觸發，方便消費端根據翻轉後方向調整進場動畫。
- **`Pagination`**（1.2.0）— 分頁大小下拉選單現在會設定 `flip`，避免在表格貼近視窗底部時選單被裁切。
- **`CalendarConfigProviderTemporal`**（1.2.0）— 新增 `@mezzanine-ui/react/temporal` 的 JS 原生 `Temporal` 日期轉接器，免第三方日期函式庫依賴（需 Chrome 144+ / Firefox 139+ / Edge 144+ 或註冊 `@js-temporal/polyfill`）。
- **`Dropdown`**（1.2.0）— 新增 opt-in `flip?: boolean` prop（預設 `false`），啟用 floating-ui `flip` middleware，視窗溢出時自動翻轉方向。

### 錯誤修正 (Bug Fixes)

- **`Select`**（1.4.1）— 修正 `error` prop 被靜默忽略的問題。`SelectTrigger` 過去轉發 `error={type === 'error'}`，但 `type` 是 `DropdownType`（永遠不會是 `'error'`），導致 error 樣式從未套用；現在改為直接採用真正的 `error` prop。
- **`Navigation`**（1.4.1）— 修正只有 `Badge` 作為唯一子項的 `NavigationOption` 被誤判為可展開群組的問題（改依實際子選項數量 `items.length` 判斷，不再誤用原始 `children`）。
- **`Dropdown` / `Select` / `AutoComplete`**（1.3.1）— 修正 React 18 開發模式下每次 render 觸發器都會出現的 `ref is not a prop` console 警告，純噪音修正，無行為變更。
- **`Table`**（1.3.0）— 欄寬調整（resize）改為優先向最右側欄位借用空間，中間欄位在拖曳時維持穩定；僅當最右欄達 `minWidth` 才退回向相鄰欄借用。既有 `columns` / `minWidth` / `maxWidth` 設定不受影響。
- **`Calendar` / `DatePicker` / `DateRangePicker` / `MultipleDatePicker`**（修正在 **`@mezzanine-ui/core` 1.1.0**，非 react 1.2.0）— 修正 Day.js / Moment adapter 對非 ISO 星期一起始 locale 的週數計算錯誤。三個 commit：`1e736cc` 把 `ISO_WEEK_LOCALES` 對齊 CLDR `weekInfo`（修正 11 個誤分類地區，如 `pt-PT` / `he-IL` / `ar-SA` 實為週日起始，`en-AU` / `ro-RO` / `tr-TR` 等雖週一起始但 `minimalDays=1` 不算 ISO）；`c628e51`（Day.js）與 `b915ff6`（Moment）把 ISO 判定改為「週一起始 **且** `minimalDays=4`」雙條件，並補上遺漏的 `.locale()` 呼叫 —— 先前 `.week()` / `.startOf('week')` 未設 instance locale 會 fallback 到全域預設（通常 `en`，週日起始）。顯示週數的 UI 建議重新驗證。

  > 修正位於 core 的 calendar adapter 層，react / ng 的日期元件透過注入 `calendarMethods` 取用，因此**不需要** react 端另外修改；只要相依的 `@mezzanine-ui/core` 到 1.1.0 即生效。react 1.2.0 與 core 1.1.0 同日（2026-05-07）發布，先前本文件因此把它誤記在 react 1.2.0 名下。

**相依套件版本**：`packages/react/package.json` 對三個套件都是**精確釘版（exact pin，無 `^` / `~` / `>=`）** —— `@mezzanine-ui/core` `1.1.0`、`@mezzanine-ui/system` `1.0.2`、`@mezzanine-ui/icons` `1.0.2`。不要寫成 `>=`，那會誤導成「更高版本也相容」。

<details>
<summary>Previous: What's New in 1.1.0</summary>

## What's New in 1.1.0

### 新增功能 (Improvements)

- **`Input` 的 `SelectButton` 子元件**（用於 `Input` 的 `select` variant，見 `packages/react/src/Input/SelectButton/`）新增 `closeOnSelect` prop（預設值 `true`）：選取選項後自動關閉下拉選單，符合單選 UX 預期。若需保持舊行為（選後不關閉），可在呼叫端傳入 `closeOnSelect={false}`。詳見 [Input.md](./references/components/Input.md#select-input)。

### 錯誤修正 (Bug Fixes)

- **`Table`** — 修正 SSR hydration mismatch 問題。列高原本在 `useMemo` 中透過 `getComputedStyle` 讀取，伺服器端回傳 `0`、客戶端回傳實際 pixel，導致 React 18/19 strict mode 下發出 hydration 警告甚至拋錯。現改為在 `useIsomorphicLayoutEffect` 中延遲讀取，首次 render 結果在 SSR 與 CSR 之間完全一致。Next.js / Remix 使用者建議升級。
- **Picker 家族鍵盤導覽** (`DatePicker`、`DateRangePicker`、`TimePicker`、`DateTimePicker`、`DateTimeRangePicker`、`TimeRangePicker`、`MultipleDatePicker`) — 修復 1.0.4 portal 遷移後 Tab / Shift+Tab 無法在觸發輸入框與日曆/時間面板之間循環的問題。Popper 現在建立明確的邏輯焦點迴圈，並在 `Modal` focus trap 內亦可正常運作。

### 元件狀態更正

> 舊版文件曾將 `ClearActions`、`ContentHeader`、`Scrollbar`、`Switch` 一併列為 1.1.0 棄用、1.4.1 移除；逐版原始碼核對後確認不實。前三者從未由主入口匯出，但仍可由 sub-path 使用且沒有 `@deprecated` 標記；只有 `Switch` 已移除，請改用 `Toggle`。

</details>

---

<details>
<summary>Previous: What's New in 1.0.4 / Patch Releases (1.0.1 – 1.0.3)</summary>

## Patch Releases (1.0.1 – 1.0.3)

> **No public API changes** in this range — existing usage does not need to be modified. Upgrade is a straightforward `yarn upgrade @mezzanine-ui/*`.

### `@mezzanine-ui/react` 1.0.4 (2026-04-22)

- **Fix** — Picker 家族（DatePicker、DateRangePicker、TimePicker、DateTimePicker、DateTimeRangePicker、TimeRangePicker、MultipleDatePicker）在 Modal 或視窗底部附近渲染時，下拉 popup 不再被裁切。`InputTriggerPopper` 預設改為 portal 模式（`z-index: 1005` 高於 `Modal: 1004`）。同時啟用 Floating UI 的 `flip` middleware，面板會在空間不足時自動翻轉方向。

### `@mezzanine-ui/react` 1.0.3 (2026-04-21)

- **Chore** — bump `@mezzanine-ui/core` dependency to `1.0.3`.

### `@mezzanine-ui/react` 1.0.2 (2026-04-17)

- **Fix** — `Badge`: correct `utils` import path to use a relative path. Internal only; no surface change.

### `@mezzanine-ui/react` 1.0.1 (2026-04-14)

- **Fix** — `Notifier`: lazy-init `createRoot` to fix React 19 event delegation. Required if the host app is on React 19 — previously `Notifier` toast handlers could silently fail to fire. No API change.

### `@mezzanine-ui/core` 1.0.3 (2026-04-21)

- **Feat** — `core/calendar`: separate ISO and locale week-year format tokens. Internal formatting utility; does **not** change Calendar / DatePicker React props. Only relevant if you consume `@mezzanine-ui/core/calendar` week-year format helpers directly.

### `@mezzanine-ui/icons` 1.0.2 · `@mezzanine-ui/system` 1.0.2 (2026-04-17)

- Monorepo-sync version bump only. No code change.

</details>

---

## What's New in 1.0.0

1.0.0 是 Mezzanine-UI 的**第一個正式穩定版本**。主要變更如下：

### 元件移除（Breaking Changes）

**只有一個元件真的被移除：`Switch`。**（發生在 `1.0.0-canary.3`，由 `Toggle` 取代。）

- **Switch** — 原始碼目錄已刪除，一律改用 `<Toggle>`；公開 API 刻意對齊（`checked` / `defaultChecked` / `disabled` / `onChange`），另增 `label` / `supportingText` / `size`。

> **更正**：先前本節宣稱「4 個元件從主入口移除」。逐一比對 `0.0.1` → `1.4.2` 全部 tag 的 `src/index.ts` 後確認，
> `ClearActions` / `ContentHeader` / `Scrollbar` **從未**出現在主入口 —— 它們一直都是 sub-path only，
> 原始碼至今仍在（`src/ClearActions/`、`src/ContentHeader/`、`src/Scrollbar/`），也沒有任何 `@deprecated` 標記。
> 所以對這三個元件而言不存在「1.0.0 移除」這件事。完整狀態見上方〈元件移除／未匯出狀況〉表。

### API 變更（已逐項對照 1.4.x 原始碼核實）

| 元件         | 敘述                                                                                          | 核實結果                                                                                                                                  |
| ------------ | --------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------- |
| `Calendar`   | 改為 `calendarDaysProps` / `calendarMonthsProps` 結構                                          | ✅ 屬實（`Calendar.tsx:75,89`）                                                                                                            |
| `Toggle`     | 取代 `Switch`                                                                                  | ✅ 屬實，但發生在 `1.0.0-canary.3`（見上方移除表）                                                                                         |
| `Upload`     | 新增 `dropzoneHints` prop                                                                      | ✅ 屬實                                                                                                                                    |
| `Typography` | 新增 `align` / `color` / `display` / `ellipsis` / `noWrap` / `variant`                         | ✅ 屬實（`Typography.tsx:41-66`）                                                                                                          |
| `Drawer`     | ~~移除內建底部操作按鈕，改採 `DrawerHeader` / `DrawerBody` / `DrawerFooter` 組合模式~~         | ❌ **不實**。這三個子元件**在整個 monorepo 都不存在**；底部操作按鈕也**沒有**被移除，仍是扁平 props（`bottomPrimaryActionText`、`bottomOnGhostActionClick` … 見 [Drawer.md](references/components/Drawer.md)） |
| `Dropdown`   | ~~移除 `options` / `onSelect`，改為 slot-based 組合~~                                          | ❌ **不實**。`options: DropdownOption[]` 是**必填** prop（`Dropdown.tsx:170`），`onSelect?:` 也仍存在（`:166`）                             |
| `Popper`     | 新增 `arrow` / `className` / `enabled` / `padding` props                                       | ⚠️ **部分不實**。`arrow` 是**物件**（`padding` 是它的欄位），**沒有**頂層的 `enabled` 或 `padding` prop（`Popper.tsx:37-65`）               |

> **注意**：`packages/react/CHANGELOG.md` 的 `1.0.0` release 區塊**只有 Bug Fixes、沒有 Features**。
> 上表這些 API 變更是 `0.x` → `1.0.0` 整段 canary / rc 期間的累積結果，**不是 1.0.0 這個 release 當下發生的**。
> 判斷某個 prop 現在到底存不存在時，**以各元件的 `references/components/*.md` 為準**（那些由 sync workflow 逐版對照 TypeScript 原始碼產生），不要以本節的歷史敘事為準。
