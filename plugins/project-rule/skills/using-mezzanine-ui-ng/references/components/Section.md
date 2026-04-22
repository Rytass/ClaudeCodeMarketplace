# Section

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/ng/section) · Verified 1.0.0-rc.3 (2026-04-21)

Layout container that composes a `MznContentHeader`, an optional `MznFilterArea`, optional tabs, and the main content area. Uses named `ng-content` selectors to position each child in the correct slot.

## Import

```ts
import { MznSection, MznSectionGroup } from '@mezzanine-ui/ng/section';
import type { SectionGroupDirection }  from '@mezzanine-ui/ng/section';
// Usually paired with:
import { MznContentHeader } from '@mezzanine-ui/ng/content-header';
import { MznFilterArea }    from '@mezzanine-ui/ng/filter-area';
```

## Selectors

| Selector              | Role                                               |
| --------------------- | -------------------------------------------------- |
| `[mznSection]`        | Root section container                             |
| `[mznSectionGroup]`   | Wrapper for multiple side-by-side `MznSection`s    |

## MznSection — Inputs

None — `MznSection` is a pure layout shell. All configuration is done on projected child components.

## MznSectionGroup — Inputs

| Input       | Type                   | Default      | Description                                                                 |
| ----------- | ---------------------- | ------------ | --------------------------------------------------------------------------- |
| `direction` | `SectionGroupDirection` | `'vertical'` | Arrangement direction: `'horizontal'` (side-by-side) or `'vertical'` (stacked) |

`SectionGroupDirection = 'horizontal' | 'vertical'`

## ControlValueAccessor

No.

## Content Projection Slots

`MznSection` projects children into predefined slots:

| Slot selector                     | Projected component                    |
| --------------------------------- | -------------------------------------- |
| `[mznContentHeader]`              | `MznContentHeader`                     |
| `[mznFilterArea]`                 | `MznFilterArea`                        |
| `[mznTabs], [sectionTab]`         | `MznTabs` or a custom tab component    |
| *(default)*                       | Main content area (wrapped in `__content` div) |

## Usage

```html
<!-- Basic section with header -->
<div mznSection>
  <header mznContentHeader title="使用者清單" size="sub"></header>
  <table><!-- table content --></table>
</div>

<!-- Section with filter area -->
<div mznSection>
  <header mznContentHeader title="訂單管理"></header>
  <div mznFilterArea>
    <!-- filter controls -->
  </div>
  <div>主要內容</div>
</div>

<!-- Multiple sections side by side -->
<div mznSectionGroup>
  <div mznSection>
    <header mznContentHeader title="左側區塊"></header>
    <p>左側內容</p>
  </div>
  <div mznSection>
    <header mznContentHeader title="右側區塊"></header>
    <p>右側內容</p>
  </div>
</div>
```

## Notes

- `MznSection` has no inputs of its own — all styling is via projected children. This differs from the React counterpart which accepts `title` and `size` props directly on `<Section>`.
- The default content slot is wrapped in a `<div class="mzn-section__content">` container; other slots are projected directly without an additional wrapper.
- `MznSectionGroup` arranges multiple sections using CSS flexbox. The **default direction is `'vertical'`** (stacked). Pass `direction="horizontal"` to place sections side by side. The `direction` attribute is removed from the DOM host (set to `null`) — use the Angular input binding only.
