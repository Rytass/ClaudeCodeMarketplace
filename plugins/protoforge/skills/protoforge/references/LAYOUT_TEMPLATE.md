# Admin Layout Template

Generated prototypes compose the admin shell directly inside `app/(admin)/layout.tsx` using primitives from `@mezzanine-ui/react`. No companion shell packages are used.

> For any component's props / behaviour, consult the `plugin:project-rule:using-mezzanine-ui` skill. Key docs:
>
> - `components/Navigation.md` — `Navigation`, `NavigationHeader`, `NavigationOption`, `NavigationOptionCategory`, `NavigationFooter`, `NavigationUserMenu`
> - `components/Layout.md` — compound `Layout` / `Layout.Main`
> - `components/PageHeader.md` — `PageHeader` + `ContentHeader` (ContentHeader imports from the sub-path `@mezzanine-ui/react/ContentHeader`)
> - `SKILL.md` → "CalendarConfigProvider Setup" — mandatory provider for any date/time picker

---

## `src/app/(admin)/layout.tsx`

```tsx
'use client';

import { useMemo, type ReactNode } from 'react';
import { usePathname, useRouter } from 'next/navigation';
import {
  CalendarConfigProvider,
  Layout,
  Navigation,
  NavigationHeader,
  NavigationOption,
  NavigationOptionCategory,
} from '@mezzanine-ui/react';
import { CalendarMethodsMoment } from '@mezzanine-ui/core/calendar';
import {
  BoxIcon,
  FolderIcon,
  FolderMoveIcon,
  HomeIcon,
  UserIcon,
} from '@mezzanine-ui/icons';

interface AdminLayoutProps {
  readonly children: ReactNode;
}

export default function AdminLayout({ children }: AdminLayoutProps): ReactNode {
  const pathname = usePathname();
  const router = useRouter();

  // Convert `/warehouses/123` → `['warehouses', '123']` for `activatedPath`
  const activatedPath = useMemo<string[]>(
    () => pathname.split('/').filter(Boolean),
    [pathname],
  );

  return (
    <CalendarConfigProvider methods={CalendarMethodsMoment}>
      <div style={{ display: 'flex', height: '100vh', width: '100%' }}>
        <Navigation
          activatedPath={activatedPath}
          onOptionClick={(path) => {
            if (!path) return;
            router.push(`/${path.join('/')}`);
          }}
        >
          <NavigationHeader title="Warehouse Admin">
            {/* Replace with `<img src="/logo.svg" />` if branding exists */}
          </NavigationHeader>

          <NavigationOption id="" title="儀表板" icon={HomeIcon} href="/" />

          <NavigationOptionCategory title="主資料">
            <NavigationOption id="products" title="商品管理" icon={BoxIcon} href="/products" />
            <NavigationOption id="warehouses" title="倉庫管理" icon={FolderMoveIcon} href="/warehouses" />
          </NavigationOptionCategory>

          <NavigationOption id="employees" title="員工管理" icon={UserIcon} href="/employees" />
        </Navigation>

        <Layout>
          <Layout.Main>{children}</Layout.Main>
        </Layout>
      </div>
    </CalendarConfigProvider>
  );
}
```

### Generation rules

- Build `NavigationOption` / `NavigationOptionCategory` from `projectSpec.navigation`; icons are looked up from `@mezzanine-ui/icons` using the `icon` string on each nav entry.
- `id` is the last path segment; `href` is the full absolute path. Using `href` alongside `onOptionClick` lets Mezzanine render the proper anchor element while still triggering the router push.
- If the root dashboard lives at `/`, pass `id=""` plus `href="/"` so it matches `activatedPath === []`.
- `NavigationOptionCategory` accepts only `title` + children; never attach icons to it.

---

## `src/app/layout.tsx` (root)

```tsx
import type { ReactNode } from 'react';
import './globals.scss';

interface RootLayoutProps {
  readonly children: ReactNode;
}

export default function RootLayout({ children }: RootLayoutProps): ReactNode {
  return (
    <html lang="zh-TW">
      <body>{children}</body>
    </html>
  );
}
```

---

## `src/app/globals.scss`

```scss
@use '~@mezzanine-ui/system' as mzn-system;
@use '~@mezzanine-ui/core' as mzn-core;

:root {
  @include mzn-system.palette-variables(light);
  @include mzn-system.common-variables(default);
}

[data-theme='dark'] {
  @include mzn-system.palette-variables(dark);
}

@include mzn-core.styles();

* {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}

html,
body {
  height: 100%;
}
```

---

## Page Header Pattern

Every page inside `(admin)/` should render a page header at the top of its content. Use the `PageHeader` + `ContentHeader` pair:

```tsx
import { PageHeader, Button } from '@mezzanine-ui/react';
import ContentHeader from '@mezzanine-ui/react/ContentHeader';

<PageHeader>
  <ContentHeader title="商品管理" onBackClick={() => router.back()}>
    <Button variant="base-secondary" onClick={handleExport}>匯出 CSV</Button>
    <Button onClick={handleCreate}>新增商品</Button>
  </ContentHeader>
</PageHeader>
```

- `ContentHeader` is marked deprecated in 1.0.0 but **still required** by `PageHeader` — import from the sub-path as shown.
- Breadcrumbs are optional: `<Breadcrumb items={[{ name: '首頁', href: '/' }, { name: '商品管理' }]} />` placed before `ContentHeader`.

---

## Checklist when generating the layout

- [ ] `'use client'` directive at top of `layout.tsx`
- [ ] `CalendarConfigProvider` wraps everything (even if no pickers appear in the layout — child pages likely use them)
- [ ] `Navigation` receives `activatedPath` derived from `usePathname()`
- [ ] Flex container gives `Navigation` its docked position and leaves remaining space for `Layout.Main`
- [ ] Icons come from `@mezzanine-ui/icons`; categories never receive icons
- [ ] No imports from deprecated Mezzanine-UI companion packages (the enforce hook will block them)
