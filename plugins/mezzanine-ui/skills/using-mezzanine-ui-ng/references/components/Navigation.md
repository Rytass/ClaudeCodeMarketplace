# Navigation

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/ng/navigation) · Verified 1.0.0-rc.4 (2026-04-24)

Side navigation bar with collapsible state, multi-level options, category groups, and icon-only collapsed mode. Sub-components communicate via `MZN_NAVIGATION_ACTIVATED` and `MZN_NAVIGATION_OPTION_LEVEL` injection tokens.

## Import

```ts
import {
  MznNavigation,
  MznNavigationOption,
  MznNavigationOptionCategory,
  MznNavigationUserMenu,
  MznNavigationHeader,
  MznNavigationFooter,
  MznNavigationIconButton,
} from '@mezzanine-ui/ng/navigation';

import type { DropdownOption } from '@mezzanine-ui/core/dropdown';
```

> **Note:** The item/option/category config *shapes* used by the `[items]` input (e.g. `NavigationItemConfig`, `NavigationOptionConfig`, `NavigationCategoryConfig`) are **internal convenience types** — they are not publicly exported from `@mezzanine-ui/ng/navigation`. Consumers should either use the template-based API (nested `<mzn-navigation-option>` elements) or define their own interface matching the `MznNavigation` `[items]` input's expected shape (see the inline shape in the Config-based example below).

## Sub-components

| Selector                        | Export                        | Purpose                                              |
| ------------------------------- | ----------------------------- | ---------------------------------------------------- |
| `[mznNavigation]`               | `MznNavigation`               | Root container; controls collapse, filter, items     |
| `[mznNavigationHeader]`         | `MznNavigationHeader`         | Brand logo + title area at top                       |
| `[mznNavigationFooter]`         | `MznNavigationFooter`         | Action icons at the bottom (settings, profile, etc.) |
| `mzn-navigation-option`         | `MznNavigationOption`         | Single nav item; supports nesting                    |
| `mzn-navigation-option-category`| `MznNavigationOptionCategory` | Groups nav options under a labelled category         |
| `div[mznNavigationUserMenu]`    | `MznNavigationUserMenu`       | Avatar + username + dropdown user menu               |
| `[mznNavigationIconButton]`     | `MznNavigationIconButton`     | Standalone icon button for icon-only areas           |

> `MznNavigationOption` and `MznNavigationOptionCategory` use **element selectors** to avoid HTML5 auto-close behaviour when nested inside `<ul>/<li>` structures. `MznNavigationUserMenu` is a **compound selector** — it must be applied to a `<div>` element.

## MznNavigation — Inputs

| Input                | Type                              | Default      | Description                                              |
| -------------------- | --------------------------------- | ------------ | -------------------------------------------------------- |
| `collapsed`          | `boolean \| undefined`            | —            | Controlled collapse state                                |
| `activatedPath`      | `readonly string[]`               | —            | Array of active option IDs (path to active item)         |
| `filter`             | `boolean`                         | `false`      | Show search/filter input inside the nav                  |
| `items`              | `ReadonlyArray<NavItem>` *(see shape below)* | —  | Declarative config-based option list                     |
| `exactActivatedMatch`| `boolean`                         | `false`      | Match active path exactly (vs prefix match)              |
| `collapsedPlacement` | `'right' \| 'left' \| 'top' \| 'bottom'` | `'right'` | Tooltip placement for icon-only mode          |

> Inputs declared with signal API (`input()`, `model()`) accept both static and reactive values.

## MznNavigation — Outputs

| Output           | Type                             | Description                                    |
| ---------------- | -------------------------------- | ---------------------------------------------- |
| `collapseChange` | `OutputEmitterRef<boolean>`      | Fires when collapse state changes              |
| `optionClick`    | `OutputEmitterRef<readonly string[]>` | Fires with path array when an option is clicked |

## MznNavigationHeader — Inputs

| Input    | Type                  | Default | Description              |
| -------- | --------------------- | ------- | ------------------------ |
| `title`  | `string \| undefined` | —       | Brand/app title text     |

## MznNavigationHeader — Outputs

| Output        | Type                    | Description              |
| ------------- | ----------------------- | ------------------------ |
| `brandClick`  | `OutputEmitterRef<void>` | Brand area clicked      |

## MznNavigationOption — Inputs

| Input         | Type                     | Default | Description                                            |
| ------------- | ------------------------ | ------- | ------------------------------------------------------ |
| `title`       | `string` (**required**) | —       | Option label                                           |
| `optionId`    | `string \| undefined`    | —       | Unique ID for active path matching                     |
| `href`        | `string \| undefined`    | —       | Router link or URL; renders as `<a>` when set          |
| `icon`        | `IconDefinition`         | —       | Leading icon                                           |
| `active`      | `boolean \| undefined`   | —       | Manual active override                                 |
| `hasChildren` | `boolean`                | `false` | Whether to show expand chevron (for nested content)    |
| `defaultOpen` | `boolean`                | `false` | Initial open state for nested options                  |

## MznNavigationOption — Outputs

| Output         | Type                                                                              | Description            |
| -------------- | --------------------------------------------------------------------------------- | ---------------------- |
| `triggerClick` | `OutputEmitterRef<{ path: readonly string[]; key: string; href?: string }>` | Option clicked; `path` is the full key path from root to this option |

## MznNavigationOptionCategory — Inputs

| Input   | Type                  | Default | Description              |
| ------- | --------------------- | ------- | ------------------------ |
| `title` | `string` (**required**) | —     | Category heading label   |

`MznNavigationOptionCategory` has no outputs. Project `<mzn-navigation-option>` elements as children.

## MznNavigationUserMenu — Inputs

| Input                | Type                             | Default      | Description                                             |
| -------------------- | -------------------------------- | ------------ | ------------------------------------------------------- |
| `imgSrc`             | `string \| undefined`            | —            | Avatar image URL; falls back to user icon on error      |
| `options`            | `ReadonlyArray<DropdownOption>`  | `[]`         | Dropdown menu items                                     |
| `placement`          | `Placement`                      | `'top-end'`  | Dropdown placement when nav is expanded                 |
| `collapsedPlacement` | `Placement`                      | `'right-end'`| Dropdown placement when nav is collapsed                |

> `Placement` is from `@floating-ui/dom`.

## MznNavigationUserMenu — Outputs

| Output            | Type                              | Description                                    |
| ----------------- | --------------------------------- | ---------------------------------------------- |
| `visibilityChange`| `OutputEmitterRef<boolean>`       | Emits `true` when menu opens, `false` on close |
| `optionSelected`  | `OutputEmitterRef<DropdownOption>`| Emits the selected menu item                   |
| `closed`          | `OutputEmitterRef<void>`          | Emits when menu closes (click-away or selection)|

## MznNavigationIconButton — Inputs

| Input    | Type                          | Default | Description          |
| -------- | ----------------------------- | ------- | -------------------- |
| `icon`   | `IconDefinition` (**required**) | —     | Icon to display      |
| `active` | `boolean`                     | `false` | Active highlight     |

## ControlValueAccessor

No.

## Usage

### Template-based (recommended for dynamic menus)

```html
<nav mznNavigation
  [collapsed]="navCollapsed"
  [activatedPath]="['settings', 'general']"
  (collapseChange)="navCollapsed = $event"
  (optionClick)="onNavClick($event)"
>
  <header mznNavigationHeader title="Admin Portal" (brandClick)="goHome()">
    <img src="logo.svg" alt="Logo" />
  </header>

  <mzn-navigation-option title="儀表板" optionId="dashboard" href="/dashboard" [icon]="dashboardIcon" />

  <mzn-navigation-option title="使用者管理" optionId="users" [icon]="usersIcon" [hasChildren]="true">
    <mzn-navigation-option title="使用者清單" optionId="users-list" href="/users" />
    <mzn-navigation-option title="角色管理" optionId="roles" href="/users/roles" />
  </mzn-navigation-option>

  <footer mznNavigationFooter>
    <button mznNavigationIconButton [icon]="settingsIcon" (click)="openSettings()"></button>
  </footer>
</nav>
```

### Config-based (`[items]` input)

The `[items]` input accepts an array of option nodes and/or category nodes.
`NavigationItemConfig` / `NavigationOptionConfig` / `NavigationCategoryConfig` are **not exported** — define the shape inline (or as your own local interface):

```ts
import { MznNavigation } from '@mezzanine-ui/ng/navigation';
import type { IconDefinition } from '@mezzanine-ui/icons';
import { HomeIcon, UsersIcon } from '@mezzanine-ui/icons';

// Local shape that matches what the [items] input expects.
// Option node (no `type`) OR category node (`type: 'category'`).
interface NavOptionItem {
  readonly title: string;
  readonly id?: string;
  readonly href?: string;
  readonly icon?: IconDefinition;
  readonly active?: boolean;
  readonly defaultOpen?: boolean;
  readonly children?: ReadonlyArray<NavOptionItem>;
}

interface NavCategoryItem {
  readonly type: 'category';
  readonly title: string;
  readonly children?: ReadonlyArray<NavOptionItem>;
}

type NavItem = NavOptionItem | NavCategoryItem;

readonly navItems: ReadonlyArray<NavItem> = [
  { title: '儀表板', id: 'dashboard', href: '/dashboard', icon: HomeIcon },
  {
    title: '使用者管理',
    id: 'users',
    icon: UsersIcon,
    children: [
      { title: '使用者清單', id: 'users-list', href: '/users' },
      { title: '角色管理', id: 'roles', href: '/users/roles' },
    ],
  },
  { type: 'category', title: '系統設定', children: [
    { title: '一般設定', id: 'settings-general', href: '/settings' },
  ]},
];
```

```html
<nav mznNavigation [items]="navItems" [activatedPath]="activePath"></nav>
```

## Notes

- Active state is determined by `activatedPath` — an array of `optionId` values forming the path from root to the active leaf. For example, `['users', 'users-list']` activates the "使用者清單" option and its parent.
- `exactActivatedMatch=true` requires the full path to match; `false` (default) activates on prefix match.
- `MznNavigationFooter` does not accept regular inputs — project icon buttons and user-profile elements via `<ng-content>` and `<ng-content select="[icons]">`.
- When `collapsed=true`, the nav renders in icon-only mode. Options show tooltips on hover using `collapsedPlacement`.
- The `filter` input adds a search box at the top of the options list for filtering by title.
- The React counterpart has separate `<NavigationIconMenu>` and `<NavigationUserMenu>` sub-components; Angular uses `[mznNavigationIconButton]` and `div[mznNavigationUserMenu]` from the same package. Note that `MznNavigationUserMenu` requires a `<div>` host element — using it on any other tag will fail.
- `MznNavigationOptionCategory` uses `mzn-navigation-option-category` as its tag selector and renders a category label above a group of nested `<mzn-navigation-option>` elements.
- The `triggerClick` payload shape is `{ path: readonly string[]; key: string; href?: string }`. `path` is the full ancestry key path (e.g. `['users', 'users-list']`), `key` is the immediate key for this option.
