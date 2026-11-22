# Content Projection Pitfalls

> Verified 1.0.0-rc.26 (2026-11-22) · 從 SKILL.md 搬出的完整版。
Angular 端與 React 端類似，多個容器元件透過 **named `ng-content` slot** 或 **directive selector 比對**決定哪些子元素會被渲染。如果寫了 host element 但 **selector / 父子關係不正確**，內容會被靜默吃掉。

> 任何時候 `mznTabs` / `mznLayout` / `mznSection` / `mznPageHeader` / `mznNavigation` / `mznAccordion` 等容器「HTML 寫了但畫面沒東西」，先檢查：(1) 子元素 selector 是否正確 (2) 是否多包了一層 `<div>` 把 selector 從父層斷開。

## 常見靜默過濾來源

| 容器 | 接受的子元素 | 失敗模式 |
| --- | --- | --- |
| `[mznTabs]` | `[mznTabItem]` 直接子代（host 不限 `<button>`） | 包一層 `<div>`：項目仍會顯示，但 `contentChildren(MznTabItem)` 只收直接子代 → 選取狀態與指示條失效 |
| `[mznLayout]` | `[mznLayoutMain]` / `[mznLayoutLeftPanel]` / `[mznLayoutRightPanel]` / `[mznNavigation]` 直接子代 | 包 wrapper 後 `ng-content` slot 找不到 → 不渲染 |
| `[mznPageHeader]` | `[mznBreadcrumb]` 與 `[mznContentHeader]`（透過 ng-content） | host 元素若不是 directive 預期的元素則樣式錯亂 |
| `[mznSection]` | `ng-content select`：`[mznContentHeader]`、`[mznFilterArea]`、`[mznTabs]`／`[sectionTab]`，其餘進主內容 | 包在另一層 div 內就落入主內容區；渲染順序固定為 contentHeader → filterArea → tabs → content，與書寫順序無關 |
| `[mznNavigation]` | `[mznNavigationHeader]` / `[mznNavigationFooter]` / `<mzn-navigation-option>` / `<mzn-navigation-option-category>` | 用原生 `<a>` / `<li>` → 不被識別、不渲染 |
| `[mznAccordion]` | `[mznAccordionTitle]` / `[mznAccordionContent]` / `[mznAccordionActions]` | 缺少 directive selector → 內容區或 actions 不出現 |
| `[mznContentHeader]` 內 actions slot | 只接受 `<button mznButton>` 且 variant ∈ `base-primary` / `base-secondary` / `destructive-secondary` | 自訂 `<div>` wrapper / 其他 variant 不渲染 |

## 常見錯誤

```html
<!-- ❌ 包一層 div：TabItem 看得到，但 mznTabs 收集不到 → 點了不會切換選取 -->
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

## 排查流程

1. 子元素的 selector 是否與父層期望的 directive 一致？
2. 是否包了 `<div>` 或其他 host element 把 ng-content / DI token context 切斷？
3. 是否在 `standalone: true` 元件裡缺少 `imports` 對應 directive？（會讓 selector 直接無效）
4. host element tag 是否符合 directive 限制（各元件文件的 Selectors 段）？

詳細個別約束請見 [components/](components/) 內 `Selectors` / `Content Projection Slots` 章節。

---
