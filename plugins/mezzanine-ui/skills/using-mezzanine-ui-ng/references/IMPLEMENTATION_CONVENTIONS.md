# 後台實作慣例（實戰回饋整理）

這份文件整理自 2026-08～11 多個 Mezzanine 後台專案中，使用者反覆糾正 AI 代理的 UI 問題。每條都是「代理預設會做錯、使用者每次都要改」的事。寫頁面時與 SKILL.md 的〈Page Layout Skeleton〉〈元件選用〉一起用；專案有自己的設計規範或客戶設計稿時，以專案為準。

核心目標只有一個：**整個平台看起來像同一個人做的**。同一種資訊、同一種操作，在每一頁都用同一個元件、同一種尺寸、同一種位置。新頁面先找專案裡已經做對的頁面當範本，照它的結構寫，不要從零設計。

## Contents

- [頁面骨架](#頁面骨架)
- [篩選列](#篩選列)
- [Table](#table)
- [按鈕](#按鈕)
- [狀態、標籤與連結](#狀態標籤與連結)
- [回饋與說明文字](#回饋與說明文字)
- [表單與輸入](#表單與輸入)
- [Modal 與 Drawer](#modal-與-drawer)
- [跨頁一致性與驗證](#跨頁一致性與驗證)
- [懷疑是 Mezzanine 的 bug 時](#懷疑是-mezzanine-的-bug-時)

## 頁面骨架

結構與 padding 數值以 SKILL.md〈Page Layout Skeleton〉為準，這裡只列實際最常出錯的地方。

- **列表頁的標準順序**：`mznPageHeader` → 頁層級 `mznTabs`（若有）→ 頁層級 `mznFilterArea` → body wrapper 內的 `mznSection`（內放 `mznTable`）。這幾個都是 page container 的直接子代，間距靠 container 的 `row-gap`。
- **`mznSection` 外面一定要有 body wrapper 提供左右 gutter**，數值與 `mznPageHeader`／`mznFilterArea` 相同（`--mzn-spacing-padding-horizontal-spacious`），白底卡片左緣才會對齊標題與篩選列。包之前先檢查原本的元素有沒有自己的 padding，有就移除，不要疊成兩層。
- **篩選整張表的 `mznFilterArea` 放在頁層級**（`size="main"`，預設值），不要塞進 `mznSection`。只有「屬於某一個 Section 的篩選」才放進 `mznSection` 內當直接子元素（Section 以 content projection 投影 `[mznFilterArea]`），此時必須手動改 `size="sub"`；ng 的 Section 不會自動改。
- **同一層級不能有兩層 `mznTabs`**。第二層分頁放進 `mznSection` 內（Section 投影 `[mznTabs]`），並設 `size="sub"`。
- `mznSection` 內的 tab、table、pagination 之間要有間距，用 wrapper 的 `row-gap`，不要讓元素貼在一起；`mznPagination` 與表格之間、並排按鈕之間都要有 gap。
- `mznSection` 有最小高度；單頭與單身這類緊密相關的內容可放在同一個 Section，降低整體高度。
- **`mznPageHeader` 只放標題、操作按鈕、返回**。返回一律用 `mznContentHeader` 內建的返回鈕：設 `[showBackButton]="true"` 並綁 `(backClick)`（僅 `size="main"` 顯示），不另做「回列表」按鈕。公司名稱、狀態、身分等資料不要塞進 header，放到下方的基本資料區（狀態用 `mznBadge`、身分用 `mznTag`）。
- 不常用、怕誤觸的操作（例如手動同步）收進 header 的更多選單（`[contentHeaderActions]` 內用 `mznDropdown` 搭配 icon-only `mznButton`），不要做成顯眼按鈕。
- `mznPageFooter` 依 Storybook 的標準用法（`type` 選 `standard`／`overflow`／`information`，按鈕放 `[actions]` 插槽），不自己排頁尾按鈕列。
- 桌面以 1280～1440 寬為基準，資訊盡量緊湊，避免整頁出現水平捲軸；標題、按鈕文字、日期不要換行，空間不夠時先調欄寬與排版。

## 篩選列

- 用 `mznFilterArea` + `mznFilterLine` + `mznFilter`，不自排 `mznInput` + `mznButton`。搜尋與重設按鈕是 `mznFilterArea` 內建的（`submitText`／`resetText`、`(filterSubmit)`／`(filterReset)`），不自己再放。
- 盡量**單行**：依內容類型用 `mznFilter` 的 `span`（1～6）或 `minWidth` 給欄寬（日期區間、短代碼、名稱的寬度不同），不要每格等寬。篩選器名稱不可換行。
- 列表頁篩選一律 `size="sub"`：`mznFilterArea` 設 `size="sub"`，**內部的 input／select 也各自明確寫 `size="sub"`**（不要假設會從 FilterArea 繼承）；`mznFilter` 的 `align` 讓按鈕與 input **底部對齊、行高一致**。
- 提示文字放 `placeholder`，不要用 input 下方的 hint／info 註解。
- 單一勾選型的篩選（例如「只看啟用」）用 `mznToggle`（使用者口語常說 Switch；ng 沒有 `MznSwitch`）。
- 按「搜尋」才觸發查詢（`(filterSubmit)`）；查詢中綁 `[loading]` 讓搜尋按鈕顯示 loading；不要預設帶入使用者沒選的篩選條件（匯出類的日期區間可以給合理預設）。
- 各頁篩選列的欄寬規則、間距、按鈕位置要一致。

## Table

- **欄寬**：每欄給符合實際資料長度的預設 `width`，盡量不出現 `…`；長 UUID 只顯示前幾碼。
- **可調欄寬（`[resizable]="true"`）時每欄都要給 `minWidth`，且不要開 `fullWidth`**：表格寬度由欄寬加總決定，超出時外層自動水平捲動、右側保留空間，否則一拖寬某欄就會擠壓相鄰欄位。ng 的 `scroll` 只有垂直的 `y`，沒有水平設定。要記住使用者調過的寬度，用 `[columnWidths]` + `(columnWidthsChange)` 受控，並把 record 放在 signal／欄位上，不要寫 inline 物件。
- **釘選只釘頭尾**：識別欄（主鍵、名稱）用欄位的 `fixed: 'start'` 釘左，操作欄（`actions` 的 `fixed: 'end'`）釘右，不釘中間的欄位。重要欄位與操作往前放。注意 ng 的 `[pinnable]` 是「列釘選到頂端」，不是欄位釘選，不要誤用。
- **排序用 Table 原生的欄位排序**：欄位設 `sortOrder: null` 才會出現排序控制（`undefined` 代表不可排序），以 `(sortChange)` 取得 `{ key, order }`，實際排序交給後端；金額、日期類欄位通常都需要排序。
- **資料量大用 Table 的 `pagination` input 做後端分頁**：總筆數用 `renderResultSummary`（`(from, to, total) => string`）顯示，並設 `showPageSizeOptions: true` 搭配 `pageSizeOptions` 提供每頁筆數選擇；頁碼與筆數變更用 `onChange`／`onPageSizeChange`。不要在表格上方另寫「共 N 筆」。獨立使用 `mznPagination` 時對應 `[renderResultSummary]`、`[showPageSizeOptions]`、`(pageChanged)`、`(pageSizeChanged)`。
- **多選後的批次操作用 Table 原生的 bulk actions**：`[rowSelection]` 設 `{ mode: 'checkbox', selectedRowKeys, onChange, bulkActions: { mainActions, destructiveAction, overflowAction } }`，不要自己做固定在底部的操作列，也不要另放「已勾選 N 筆」的說明文字（摘要由 `renderSelectionSummary` 處理）。
- **空資料用 Table 自帶的空狀態**（`[emptyProps]`，必填 `title`），不另放 `mznEmpty` 或說明橫幅。
- 列操作用 Table 的 `[actions]`（`render` 回傳動作項目），預設就是無底色的文字型按鈕（`base-text-link`），刪除類動作該項設 `variant: 'destructive-text-link'`；只有一兩個操作時直接顯示，不要收進 `type: 'dropdown'`（會被遮住 tooltip 的「…」選單）。
- 捲軸出現在外層容器即可，除非真的需要，不要讓表格自己產生垂直捲軸（`scroll.y`）；可捲動的清單底部要露出半列，提示還有內容。

## 按鈕

- 破壞性操作（刪除、停用、移除、登出、取消某筆資料）一律用 `destructive-*` variant（`destructive-primary`／`destructive-secondary`／`destructive-ghost`／`destructive-text-link`），沒有例外。單純「丟棄草稿」這類不是破壞資料的操作用 `base-secondary`，不用 primary。
- 列表頁、篩選列、表格內的按鈕統一 `size="sub"`，提高資訊密度；並排按鈕大小一致、之間有 gap（成組用 `mznButtonGroup`），不要自訂按鈕寬度或 padding。
- 按鈕文字精簡（「停用設定」→「停用」）；`tooltipText` 只用在 icon-only 按鈕，一般按鈕不加內容等於按鈕文字的 tooltip。
- **送出 API 的按鈕在請求中要顯示 loading spinner**（`mznButton` 的 `[loading]`），不能只是 disabled。

## 狀態、標籤與連結

- 狀態（啟用、失敗、處理中）用 `mznBadge variant="dot-*"`（`dot-success`／`dot-error`／`dot-warning`／`dot-info`／`dot-inactive`）；分類、身分、屬性用 `mznTag`，偏好較小的 `size`，避免擠在一起。判斷句見 SKILL.md〈兩組最常錯的，記判斷句〉。
- 表格與內容中的可點擊文字（開 Drawer 的名稱、外部系統連結）**全站只用一套樣式：預設文字色（`--mzn-color-text-neutral-solid`，與 Table 內文同色）＋ hover 時出現底線**。不用品牌色（primary）、不要常駐底線，也不要同一專案混用多種組合。這是你自己的版面元素，用 design tokens 設定，不是覆寫元件；專案已有不同的設計規範時以專案為準。
- 外開連結用「外開」圖示，不用「分享」圖示。
- 同一種資料主體（客戶、供應商、交易對象）在每一頁的點擊行為一致：點名稱開同一個 Drawer 顯示基本資料，Drawer 內再提供開完整頁的入口。

## 回饋與說明文字

- **不要加說明性文字**：操作說明、副標、「地址請在上方維護」這類引導、歷史決策說明，一律不放（`mznContentHeader` 的 `description` 同理，沒有必要就不填）。需要說明代表版面設計有問題，先改版面。
- 內頁避免 `mznAlertBanner`，只用於真正的頁面級或系統級警示；`mznInlineMessage` 也盡量少用。
- 操作完成的提示用 `MznMessageService`（`inject` 後呼叫 `success()`／`error()` 等，是 service 不是 directive），不提供「復原」按鈕，除非使用者要求。
- 非同步處理中的頁面要自動更新狀態，完成時可用 `MznMessageService` 或 `mznNotificationCenter` 通知。

## 表單與輸入

- **每個 input／select 都要有合適的 `placeholder`**（篩選列、表單、Modal 皆同），不要留白框。
- 欄位標題等寬對齊；排版用 Mezzanine 的 form 元件（`mznFormField`）處理，不用絕對定位，避免欄位重疊。欄位多時依內容長度排版，不強制固定兩欄。
- 長清單選擇（人員、客戶、供應商）用 `mznAutocomplete`，搭配 `[asyncData]="true"`、`[loading]`、`(searchChange)`（可配 `searchDebounceTime`）與 `(reachBottom)` 動態載入分頁並設筆數上限，不要一次載入全部。
- 需要複製的值（ID、連結）用 `mznInput` 的 `[actionButton]`（`{ position: 'suffix', icon, label, onClick }`）形式，不另放一顆分開的複製按鈕。注意 `mznInput` 要套在容器元素（`<div mznInput>`），不是原生 `<input>`。
- 數值單位、幣別等用 Mezzanine 既有的輸入形式（`mznInput` 的 `prefixText`／`suffixText`，或先查元件文件），找不到再問，不自建。
- 新增與編輯用同一份表單結構。

## Modal 與 Drawer

- 細節檢視先開 `mznDrawer`（重點資訊），需要時才跳完整頁面；不要用 `mznModal` 顯示大量資料。
- 按鈕位置依 Modal／Drawer 元件內建的 footer 配置，不自己排：Modal 用 `mznModalFooter`（`confirmText`、`cancelText`、`confirmButtonVariant`），Drawer 用 `isBottomDisplay` 搭配 `bottomPrimaryAction*`／`bottomSecondaryAction*`／`bottomGhostAction*` 系列 input。確認鍵請求中要 loading：Modal 設 `[loading]`（Footer 會自動取得），Drawer 設 `bottomPrimaryActionLoading`。
- 疊層時「取消」回到上一層，不是整個關閉。
- Modal 內多個步驟或分頁切換時寬度不變（固定 `size`）。
- 破壞性操作要有確認 Modal，確認鍵 `confirmButtonVariant="destructive-primary"`。
- 流程能合併的步驟就合併，不為了分步而分步。

## 跨頁一致性與驗證

- 新頁面或大改版面前，先用 artifact（引入 Mezzanine 樣式、light mode）或 ASCII 畫稿給使用者確認；畫稿的容器要與實作一致（Drawer 就畫 Drawer，不要畫成獨立頁）。
- 改 UI 前後都用瀏覽器實際看畫面（含 1280 寬與使用者回報的裝置），不要只讀程式碼推論。
- 修正一頁的版面問題後，掃一遍同類頁面套用同樣修正；常見做法是請子代理全站盤點同一個 pattern 的用法。
- 把專案的標準頁面（已確認做對的頁面）記在專案 CLAUDE.md，之後新頁面照它寫。

## 懷疑是 Mezzanine 的 bug 時

1. 先升到最新版確認問題還在。
2. 在乾淨環境（例如 Storybook 或最小重現專案）獨立重現，排除專案自己的樣式與設定。
3. 確認是元件本身的問題後，整理重現步驟給使用者，由使用者決定是否到 [Mezzanine-UI/mezzanine](https://github.com/Mezzanine-UI/mezzanine/issues) 開 issue。
4. 等待修正期間，先用零覆寫的方式交付，並說明差異。
