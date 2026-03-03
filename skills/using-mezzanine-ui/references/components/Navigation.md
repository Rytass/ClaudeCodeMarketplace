# Navigation Component

> **Category**: Navigation
>
> **Storybook**: `Navigation/Navigation`
>
> **Source Verification**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/react/src/Navigation)

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

---

## NavigationFooter Props

> Extends `NativeElementPropsWithoutKeyAndRef<'footer'>`.

| Property   | Type         | Default | Description                                                                    |
| ---------- | ------------ | ------- | ------------------------------------------------------------------------------ |
| `children` | `ReactNode`  | -       | Footer content (`NavigationUserMenu` is handled separately; others are wrapped in icons container) |

---

## NavigationIconButton Props

| Property | Type             | Description                  |
| -------- | ---------------- | ---------------------------- |
| `icon`   | `IconDefinition` | **Required**, display icon   |

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

## RC1 Enhancements

- **Auto-activate nav option**: Automatically highlights the navigation option matching the current path
- **Username overflow handling**: Long usernames are automatically truncated with Tooltip
- **UserMenu overflow handling**: UserMenu supports scrolling when content overflows
- **Text fade transition**: Smooth text fade-in/fade-out animation during sidebar collapse/expand
- **Bug fixes**: `collapsedPlacement` and UserMenu tooltip positioning corrections; open/active state text and background color token fixes; minimum width constraint fixes

---

## Best Practices

1. **Provide icons**: Every main option should have an icon for identification
2. **Limit nesting levels**: Recommend at most 3 levels of nesting
3. **Use categories**: Group related options with `NavigationOptionCategory`
4. **Collapsed mode icons**: Only icons are shown when collapsed; ensure icons are recognizable
5. **Integrate with Router**: Use `optionsAnchorComponent` or per-option `anchorComponent` with SPA router components (e.g. react-router's `Link`)
