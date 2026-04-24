# Navigation Component

> **Category**: Navigation
>
> **Storybook**: `Navigation/Navigation`
>
> **Source**: [GitHub Source Code](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/react/src/Navigation) · Verified 1.1.0 (2026-04-24)

Side navigation component supporting expand/collapse, multi-level, categories, search, and more.

## Import

```tsx
import {
  Navigation,
  NavigationOption,
  NavigationOptionCategory,
  NavigationHeader,
  NavigationFooter,
  NavigationIconButton,
  NavigationUserMenu,
} from '@mezzanine-ui/react';
import type {
  NavigationProps,
  NavigationChild,
  NavigationChildren,
  NavigationOptionProps,
  NavigationOptionCategoryProps,
  NavigationHeaderProps,
  NavigationFooterProps,
  NavigationIconButtonProps,
  NavigationUserMenuProps,
} from '@mezzanine-ui/react';

// The following types must be imported from sub-path
import type {
  NavigationOptionChild,
  NavigationOptionChildren,
} from '@mezzanine-ui/react/Navigation';
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/?path=/docs/navigation-navigation--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## Type Definitions

```ts
type NavigationChild =
  | ReactElement<NavigationFooterProps>
  | ReactElement<NavigationHeaderProps>
  | ReactElement<NavigationOptionCategoryProps>
  | ReactElement<NavigationOptionProps>
  | null | undefined | false;

type NavigationChildren = NavigationChild | NavigationChild[];

type NavigationOptionChild =
  | ReactElement<NavigationOptionProps>
  | ReactElement<BadgeProps>
  | false | null | undefined;

type NavigationOptionChildren = NavigationOptionChild | NavigationOptionChild[];
```

---

## Navigation Props

> Extends `NativeElementPropsWithoutKeyAndRef<'ul'>` (excluding `onClick`).

| Property          | Type                              | Default | Description              |
| ----------------- | --------------------------------- | ------- | ------------------------ |
| `activatedPath`   | `string[]`                        | -       | Current activated path   |
| `children`        | `NavigationChildren`              | -       | Children                 |
| `collapsed`       | `boolean`                         | `false` | Whether collapsed        |
| `exactActivatedMatch` | `boolean`                     | `false` | When true, href must match the current pathname exactly to be activated; when false, any href that is a prefix of the current pathname will be activated |
| `filter`          | `boolean`                         | -       | Whether to show search   |
| `onCollapseChange`| `(collapsed: boolean) => void`    | -       | Collapse change event    |
| `onOptionClick`   | `(activePath?: string[]) => void` | -       | Option click event       |
| `optionsAnchorComponent` | `React.ElementType`          | -       | Custom component for rendering options with href (e.g. `<Link>` from react-router-dom) |

---

## NavigationOption Props

> Extends `NativeElementPropsWithoutKeyAndRef<'li'>` (excluding `onClick`, `onMouseEnter`, `onMouseLeave`).

| Property         | Type                                                          | Default      | Description                               |
| ---------------- | ------------------------------------------------------------- | ------------ | ----------------------------------------- |
| `active`         | `boolean`                                                     | -            | Whether active                            |
| `children`       | `NavigationOptionChildren`                                    | -            | Sub-options (NavigationOption or Badge)    |
| `defaultOpen`    | `boolean`                                                     | `false`      | Whether sub-menu is expanded by default   |
| `href`           | `string`                                                      | -            | Link URL                                  |
| `icon`           | `IconDefinition`                                              | -            | Icon                                      |
| `id`             | `string`                                                      | -            | Unique identifier                         |
| `title`          | `string`                                                      | (required)   | Display title                             |
| `anchorComponent`| `React.ElementType`                                           | -            | Custom anchor component, should support `href` and `onClick` |
| `onTriggerClick` | `(path: string[], currentKey: string, href?: string) => void` | -            | Option trigger click event                |

**Animation Details**: The title is wrapped in a `titleWrapper` `<span>` with a `Fade` transition that provides smooth appear/disappear animation when the navigation collapses/expands. The fade is controlled by `in={collapsed === false || !icon}`, ensuring the title fades in when expanded or when an icon is not present, and fades out when collapsed with an icon.

**Tooltip Positioning**: When a tooltip is displayed for the option, it uses `offsetMainAxis={14}` (8 + 6, where 6 is the padding of the item) to maintain proper spacing from the navigation item.

---

## NavigationOptionCategory Props

> Extends `NativeElementPropsWithoutKeyAndRef<'li'>` (excluding `onClick`).

| Property   | Type        | Default    | Description                          |
| ---------- | ----------- | ---------- | ------------------------------------ |
| `children` | `ReactNode` | -          | Only accepts `NavigationOption` elements |
| `title`    | `string`    | (required) | Category title                       |

---

## NavigationHeader Props

> Extends `NativeElementPropsWithoutKeyAndRef<'header'>`.

| Property       | Type           | Default    | Description                              |
| -------------- | -------------- | ---------- | ---------------------------------------- |
| `children`     | `ReactNode`    | -          | Header content (usually a Logo icon)     |
| `title`        | `string`       | (required) | Title text                               |
| `onBrandClick` | `() => void`   | -          | Brand area (Logo + title) click callback |

**Brand Area Rendering**: The brand area is rendered as a `<button>` element when `onBrandClick` is provided, allowing for interactive behavior. When no callback is provided, it renders as a `<div>`.

**Title Display & Animation**: The title shows the first character when the navigation is collapsed and the full title when expanded. The title is wrapped in a `Fade` transition for smooth text appear/disappear during collapse/expand animations.

---

## NavigationFooter Props

> Extends `NativeElementPropsWithoutKeyAndRef<'footer'>`.

| Property   | Type         | Default | Description                                                                    |
| ---------- | ------------ | ------- | ------------------------------------------------------------------------------ |
| `children` | `ReactNode`  | -       | Footer content (`NavigationUserMenu` is handled separately; others are wrapped in icons container) |

---

## NavigationIconButton Props

| Property | Type             | Default | Description                  |
| -------- | ---------------- | ------- | ---------------------------- |
| `icon`   | `IconDefinition` | -       | **Required**, display icon   |
| `active` | `boolean`        | `false` | When true, applies active state styling class |

> Extends native `<button>` attributes (excluding `children`).

---

## NavigationUserMenu Props

> Extends `DropdownProps` (excluding `children` and `type`), supports `options`, `placement`, `onClose`, `onVisibilityChange`, and other properties.

| Property    | Type           | Default     | Description          |
| ----------- | -------------- | ----------- | -------------------- |
| `children`  | `ReactNode`    | -           | Username             |
| `className` | `string`       | -           | Custom className     |
| `imgSrc`    | `string`       | -           | User avatar URL      |
| `onClick`   | `() => void`   | -           | Click event          |
| `collapsedPlacement` | `DropdownProps['placement']` | -           | Dropdown position when navigation is collapsed |
| `placement` | `string`       | `'top-end'` | Dropdown position (inherited) |

---

## Usage Examples

### Basic Navigation

```tsx
import {
  Navigation,
  NavigationOption,
  NavigationHeader,
} from '@mezzanine-ui/react';
import { HomeIcon, UserIcon, SettingIcon } from '@mezzanine-ui/icons';

function BasicNavigation() {
  const [activePath, setActivePath] = useState<string[]>(['home']);

  return (
    <Navigation
      activatedPath={activePath}
      onOptionClick={setActivePath}
    >
      <NavigationHeader title="My App" />
      <NavigationOption icon={HomeIcon} title="Home" href="/home" />
      <NavigationOption icon={UserIcon} title="Users" href="/users" />
      <NavigationOption icon={SettingIcon} title="Settings" href="/settings" />
    </Navigation>
  );
}
```

### Collapsible Navigation

```tsx
function CollapsibleNavigation() {
  const [collapsed, setCollapsed] = useState(false);

  return (
    <Navigation
      collapsed={collapsed}
      onCollapseChange={setCollapsed}
    >
      <NavigationHeader title="Dashboard" />
      <NavigationOption icon={HomeIcon} title="Home" />
      <NavigationOption icon={UserIcon} title="Users" />
    </Navigation>
  );
}
```

### Multi-level Navigation

```tsx
<Navigation activatedPath={activePath} onOptionClick={setActivePath}>
  <NavigationOption icon={HomeIcon} title="Home" />
  <NavigationOption icon={FolderIcon} title="Projects">
    <NavigationOption title="Project A" href="/projects/a" />
    <NavigationOption title="Project B" href="/projects/b" />
    <NavigationOption title="Project C">
      <NavigationOption title="Sub-project 1" href="/projects/c/1" />
      <NavigationOption title="Sub-project 2" href="/projects/c/2" />
    </NavigationOption>
  </NavigationOption>
</Navigation>
```

### With Categories

```tsx
<Navigation>
  <NavigationOptionCategory title="Main Features">
    <NavigationOption icon={HomeIcon} title="Home" />
    <NavigationOption icon={SearchIcon} title="Search" />
  </NavigationOptionCategory>
  <NavigationOptionCategory title="Management">
    <NavigationOption icon={UserIcon} title="User Management" />
    <NavigationOption icon={SettingIcon} title="System Settings" />
  </NavigationOptionCategory>
</Navigation>
```

### With Search

```tsx
<Navigation filter>
  <NavigationOption icon={HomeIcon} title="Home" />
  <NavigationOption icon={UserIcon} title="Users" />
  <NavigationOption icon={SettingIcon} title="Settings" />
</Navigation>
```

### With Footer

```tsx
<Navigation>
  <NavigationHeader title="App">
    <Logo />
  </NavigationHeader>
  <NavigationOption icon={HomeIcon} title="Home" />
  <NavigationOption icon={UserIcon} title="Users" />
  <NavigationFooter>
    <div>Version 1.0.0</div>
  </NavigationFooter>
</Navigation>
```

### Custom Anchor (SPA Router Integration)

```tsx
import { Link } from 'react-router-dom';
import {
  Navigation,
  NavigationOption,
  NavigationHeader,
} from '@mezzanine-ui/react';
import { HomeIcon, UserIcon, SettingIcon } from '@mezzanine-ui/icons';

function SpaNavigation() {
  const [activePath, setActivePath] = useState<string[]>(['home']);

  return (
    <Navigation
      activatedPath={activePath}
      onOptionClick={setActivePath}
      optionsAnchorComponent={Link}
    >
      <NavigationHeader title="My App" />
      <NavigationOption icon={HomeIcon} title="Home" href="/home" />
      <NavigationOption icon={UserIcon} title="Users" href="/users" />
      <NavigationOption
        icon={SettingIcon}
        title="Settings"
        href="/settings"
        anchorComponent={Link}
      />
    </Navigation>
  );
}
```

> **Note**: `optionsAnchorComponent` sets the default anchor for all options. Individual options can override with `anchorComponent`. The custom component should support `href` and `onClick` props.

### With User Menu

```tsx
import { NavigationUserMenu, NavigationIconButton } from '@mezzanine-ui/react';
import { SettingIcon, HelpIcon } from '@mezzanine-ui/icons';

<Navigation>
  <NavigationHeader title="App" />
  <NavigationOption icon={HomeIcon} title="Home" />
  <NavigationFooter>
    <NavigationUserMenu
      imgSrc="/avatar.png"
      options={[
        { id: 'profile', name: 'Profile' },
        { id: 'logout', name: 'Log Out' },
      ]}
    >
      Username
    </NavigationUserMenu>
    <NavigationIconButton icon={SettingIcon} onClick={handleSettings} />
    <NavigationIconButton icon={HelpIcon} onClick={handleHelp} />
  </NavigationFooter>
</Navigation>
```

---

## Figma Mapping

| Figma Variant                   | React Props                              |
| ------------------------------- | ---------------------------------------- |
| `Navigation / Expanded`         | `<Navigation collapsed={false}>`         |
| `Navigation / Collapsed`        | `<Navigation collapsed>`                 |
| `Navigation / With Header`      | `<Navigation><NavigationHeader /></>`    |
| `Navigation / With Categories`  | `<NavigationOptionCategory>`             |
| `Navigation / Multi-level`      | Nested `<NavigationOption>`              |

---

---

## Best Practices (最佳實踐)

### 場景推薦 (Scenario Recommendations)

| 場景 | 推薦做法 | 相關 Props |
| --- | --- | --- |
| SPA 路由整合 | 使用 `optionsAnchorComponent={Link}` 搭配 react-router | `optionsAnchorComponent`, `anchorComponent` |
| 精確路由匹配 | 啟用 `exactActivatedMatch={true}` 避免路由前綴重疊 | `exactActivatedMatch` |
| 路由前綴匹配 | 保持 `exactActivatedMatch={false}` (預設) 用於巢狀路由 | `exactActivatedMatch` |
| 長導航列表 | 啟用 `filter={true}` 提供搜尋功能 | `filter` |
| 響應式設計 | 搭配 `collapsed={true}` 在小螢幕上使用 | `collapsed`, `onCollapseChange` |
| 深層導航結構 | 限制巢狀層級不超過 3 層，使用 `NavigationOptionCategory` 分組 | - |
| 動態導航項目 | 利用 `activatedPath` 和 `onOptionClick` 管理活躍狀態 | `activatedPath`, `onOptionClick` |

### 常見錯誤 (Common Mistakes)

1. **路由匹配誤設**
   - ❌ 誤：在多層路由時不設定 `exactActivatedMatch`，導致過多項目被啟用
   - ✅ 正確：根據路由結構選擇 `exactActivatedMatch={true}` 或 `false`
   - 範例：若路由為 `/dashboard` 和 `/dashboard/reports`，啟用精確匹配避免兩者同時亮起

2. **缺少圖標識別**
   - ❌ 誤：折疊時只顯示文字，用戶無法識別
   - ✅ 正確：所有選項提供有意義的圖標，確保折疊時仍可識別
   - 範例：`<NavigationOption icon={HomeIcon} title="首頁" />`

3. **過度巢狀**
   - ❌ 誤：超過 4 層深的巢狀結構
   - ✅ 正確：限制在 3 層以內，使用分類組織
   - 範例：使用 `NavigationOptionCategory` 而不是無限巢狀

4. **未整合路由器**
   - ❌ 誤：使用 `href` 但未提供 `optionsAnchorComponent`，導致整頁重載
   - ✅ 正確：搭配 SPA 路由器的 `Link` 組件
   - 範例：`<Navigation optionsAnchorComponent={Link}>`

5. **路由激活邏輯混亂**
   - ❌ 誤：手動更新 `activatedPath` 與瀏覽器 URL 不同步
   - ✅ 正確：監聽路由變化同步 `activatedPath`
   - 範例：使用 `useLocation()` hook 自動更新

### 核心建議 (Core Recommendations)

1. **提供圖標**：每個主選項都應有圖標便於識別
2. **限制巢狀層級**：建議最多 3 層巢狀
3. **使用分類**：用 `NavigationOptionCategory` 組織相關選項
4. **折疊模式圖標**：折疊時僅顯示圖標，需確保圖標清晰辨識
5. **路由器整合**：使用 `optionsAnchorComponent` 或逐項 `anchorComponent` 與 SPA 路由器整合 (如 react-router 的 `Link`)
