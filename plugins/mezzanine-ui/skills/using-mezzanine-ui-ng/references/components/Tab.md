# Tab

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/ng/tab) · Verified 1.0.0-rc.4 (2026-04-24)
>
> **Storybook**: https://storybook-ng.mezzanine-ui.org/?path=/docs/navigation-tab--docs

Tab 導航元件，用於組織多個內容面板之間的切換。`MznTabs` 為容器，管理 active bar 位置與 active key 狀態；`MznTabItem` 為單一 Tab 按鈕（host element 必須為 `<button>`）。支援受控（`[activeKey]`）與非受控（`[defaultActiveKey]`）兩種模式，以及水平/垂直方向。

## Import

```ts
import { MznTabs, MznTabItem } from '@mezzanine-ui/ng/tab';
import { MZN_TABS_CONTEXT } from '@mezzanine-ui/ng/tab';
import type { TabsContext } from '@mezzanine-ui/ng/tab';
```

## Selector

`<div mznTabs [(activeKey)]="currentTab">` — tabs container

`<button mznTabItem [key]="'tab1'">` — 單一 tab item，host element 必須為 `<button>`

## Inputs — MznTabs

| Input            | Type                  | Default | Description                                                                   |
| ---------------- | --------------------- | ------- | ----------------------------------------------------------------------------- |
| `activeKey`      | `string \| number`    | —       | 受控模式：當前選取的 key（不設定則使用非受控模式）                              |
| `defaultActiveKey` | `string \| number`  | `0`     | 非受控模式的初始 active key                                                    |
| `direction`      | `'horizontal' \| 'vertical'` | `'horizontal'` | Tab 排列方向                                                   |
| `size`           | `'main' \| 'sub'`     | `'main'`| Tab 尺寸                                                                      |

> Inputs declared with signal API (`input()`) accept both static and reactive values.

## Outputs — MznTabs

| Output            | Type                                 | Description                    |
| ----------------- | ------------------------------------ | ------------------------------ |
| `activeKeyChange` | `OutputEmitterRef<string \| number>` | Tab 切換時觸發，發送新的 active key |

## Inputs — MznTabItem

| Input        | Type                    | Default     | Description                                              |
| ------------ | ----------------------- | ----------- | -------------------------------------------------------- |
| `key`        | `string \| number` (required) | —     | 此 Tab 的唯一識別 key                                    |
| `disabled`   | `boolean`               | `false`     | 是否禁用                                                  |
| `error`      | `boolean`               | `false`     | 是否顯示錯誤狀態                                          |
| `icon`       | `IconDefinition`        | —           | Tab 圖示，顯示於文字左側                                  |
| `badgeCount` | `number`                | —           | 未讀計數徽章；未設定不顯示                                |

> Inputs declared with signal API (`input()`, `input.required()`) accept both static and reactive values.

## Outputs — MznTabItem

| Output    | Type                     | Description          |
| --------- | ------------------------ | -------------------- |
| `clicked` | `OutputEmitterRef<void>` | Tab 被點擊時觸發      |

## Usage

```html
<!-- 受控模式（推薦） -->
<div mznTabs [activeKey]="activeTab()" (activeKeyChange)="activeTab.set($event)">
  <button mznTabItem [key]="'overview'">總覽</button>
  <button mznTabItem [key]="'analytics'">分析</button>
  <button mznTabItem [key]="'settings'">設定</button>
</div>

<!-- 雙向綁定 -->
<div mznTabs [(activeKey)]="activeTab">
  <button mznTabItem [key]="'tab1'">頁籤一</button>
  <button mznTabItem [key]="'tab2'">頁籤二</button>
</div>

<!-- 非受控模式 -->
<div mznTabs [defaultActiveKey]="'tab1'">
  <button mznTabItem [key]="'tab1'">頁籤一</button>
  <button mznTabItem [key]="'tab2'">頁籤二</button>
</div>

<!-- 垂直排列 -->
<div mznTabs direction="vertical" [activeKey]="activeTab()">
  <button mznTabItem [key]="0">首頁</button>
  <button mznTabItem [key]="1">設定</button>
</div>

<!-- 帶徽章計數與圖示 -->
<div mznTabs [activeKey]="activeTab()" (activeKeyChange)="activeTab.set($event)">
  <button mznTabItem [key]="'inbox'" [icon]="InboxIcon" [badgeCount]="unreadCount()">
    收件匣
  </button>
  <button mznTabItem [key]="'sent'">已傳送</button>
  <button mznTabItem [key]="'trash'" [error]="hasError()">垃圾桶</button>
  <button mznTabItem [key]="'archived'" [disabled]="true">封存</button>
</div>
```

```ts
import { Component, signal } from '@angular/core';
import { MznTabs, MznTabItem } from '@mezzanine-ui/ng/tab';
import { InboxIcon } from '@mezzanine-ui/icons';
import type { IconDefinition } from '@mezzanine-ui/icons';

@Component({
  selector: 'app-email',
  imports: [MznTabs, MznTabItem],
  template: `
    <div mznTabs [activeKey]="activeTab()" (activeKeyChange)="activeTab.set($event)">
      <button mznTabItem [key]="'inbox'" [icon]="inboxIcon" [badgeCount]="unreadCount()">
        收件匣
      </button>
      <button mznTabItem [key]="'sent'">已傳送</button>
      <button mznTabItem [key]="'drafts'">草稿</button>
    </div>

    @switch (activeTab()) {
      @case ('inbox') { <app-inbox /> }
      @case ('sent') { <app-sent /> }
      @case ('drafts') { <app-drafts /> }
    }
  `,
})
export class EmailComponent {
  readonly inboxIcon: IconDefinition = InboxIcon;
  readonly activeTab = signal<string>('inbox');
  readonly unreadCount = signal(5);
}
```

## Notes

- `MznTabItem` 的 host element **必須是 `<button>`**，以確保鍵盤可及性與正確的 DOM 語意（`type="button"` 由元件自動加上）。
- Active bar（底線/側線）的位置由 `MznTabs` 在 `AfterViewInit` 及 `requestAnimationFrame` 時計算，確保 DOM 已更新後再定位。
- 受控模式：`activeKey` + `(activeKeyChange)`；非受控模式：只設定 `[defaultActiveKey]`，元件內部自行管理狀態。
- `badgeCount` 的顏色會依 active/error 狀態自動調整：`error` → `count-alert`，active → `count-brand`，其他 → `count-inactive`。
- `MZN_TABS_CONTEXT` 為 Angular-only DI token，`MznTabItem` 透過它取得父層 `MznTabs` 的 active key 與 `handleTabClick`。
