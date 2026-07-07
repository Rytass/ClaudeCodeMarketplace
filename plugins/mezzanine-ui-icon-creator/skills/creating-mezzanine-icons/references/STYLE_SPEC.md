# Mezzanine Icon Style Specification

Derived from an exhaustive read of all 130 icon definitions in `@mezzanine-ui/icons` 1.0.2
(`packages/icons/src/` in the [Mezzanine-UI monorepo](https://github.com/Mezzanine-UI/mezzanine)),
cross-checked against industry icon-system guidelines (Material, IBM Carbon, Ant Design, Lucide, Octicons).

## 1. Type interface

Custom icons must satisfy the exact `IconDefinition` interface exported by `@mezzanine-ui/icons`
(source: `packages/icons/src/typings.ts`):

```ts
export interface IconDefinition {
  name: string;
  definition: {
    svg?: {
      viewBox?: string;
      fill?: string;
    };
    title?: string;
    path?: {
      d?: string;
      fill?: string;
      fillRule?: 'nonzero' | 'evenodd' | 'inherit';
      clipRule?: 'nonzero' | 'evenodd' | 'inherit';
      stroke?: string;
      strokeWidth?: string | number;
      strokeLinecap?: 'inherit' | 'round' | 'butt' | 'square' | undefined;
      strokeLinejoin?: 'inherit' | 'round' | 'bevel' | 'miter' | undefined;
      transform?: string;
    };
  };
}
```

The interface *permits* stroke and transform fields, but **all 130 native icons leave them unset**.
Custom icons must too — the React `Icon` component spreads `definition.svg` and `definition.path`
directly onto DOM elements, so anything you set becomes a live attribute.

Fields actually used by the native set (use exactly these, nothing more):

| Field            | Value                                    | Usage count (of 130) |
| ---------------- | ---------------------------------------- | -------------------- |
| `svg.viewBox`    | `'0 0 16 16'`                            | 130 / 130            |
| `svg.fill`       | `'none'`                                 | 130 / 130            |
| `path.fill`      | `'currentColor'`                         | 130 / 130            |
| `path.d`         | single merged path string                | 130 / 130            |
| `path.fillRule`  | `'evenodd'` (hollow/ring shapes only)    | 19 / 130             |
| `path.clipRule`  | `'evenodd'` (paired with fillRule)       | 10 / 130             |

## 2. Paint model: fill-only ("outlined stroke")

The native set contains **zero stroke-based icons**. Icons that *look* like line work
(chevrons, plus, trash, file) are filled polygons whose outline traces both sides of each
notional stroke — the industry "outline stroke / expand stroke" practice. Reasons:

- `fill: 'currentColor'` is the theming hook — `Icon`'s `color` prop maps to the
  `--mzn-icon-color` CSS variable; a live `stroke` attribute would escape it.
- Outlined fills scale with the geometry; live strokes distort line weight when the icon
  renders at 1em / 16px / 48px.

**Never** emit `stroke`, `strokeWidth`, `strokeLinecap`, or `strokeLinejoin`.

## 3. Grid, live area, keyshapes

All values are in 16-grid units (1u = 1/16 of the rendered size).

```
0    2                 14   16
+----+------------------+---+
|    |   live area      |   |
|    |   12 x 12        |   |
|    |                  |   |
+----+------------------+---+
```

- **Canvas**: 16×16. **Padding**: 2u on every side. **Live area**: 12×12 (coords 2..14).
- Native measurements confirming this: `checked-filled` circle 2..14, `plus` cross 3..13,
  `setting` 2..14 × 2.5..13.5, `dot-grid` 2.8..13.2.

Keyshapes (optical-weight compensation — a square of the same width as a circle's diameter
looks heavier, so it must be smaller; ratio follows Material's 20:18 on a 24-grid):

| Keyshape             | Size          | Extent           |
| -------------------- | ------------- | ---------------- |
| Circle               | Ø12           | 2..14            |
| Square               | ≈11 × 11      | 2.5..13.5        |
| Landscape rectangle  | 12 × 10       | x 2..14, y 3..13 |
| Portrait rectangle   | 10 × 12       | x 3..13, y 2..14 |

Directional glyphs (arrows, chevrons) may extend to the live-area edge on their pointing
axis (`long-tail-arrow-right` reaches x = 14.207 at the tip — the tip *point* may slightly
exceed 14 because the visual mass still sits inside the live area).

## 4. Line work

- **Equivalent stroke width: exactly 1u.** Confirmed across the set: `chevron-down` V-bar
  1.0, `close` diagonals 1.0, `trash` container walls 1.0, `checked-outline` ring 1.0
  (outer r6, inner r5), `search` handle 1.0.
- **Caps and joins: square** (butt caps, miter-like corner cuts). The set does not round
  line-work terminals. Do not import Lucide/Feather-style round caps.
- **Clearance**: keep ≥ 1u between separate elements (e.g. `trash` inner ticks vs walls).
- **Inner detail lines** are also 1u (`file` text lines, `trash` ticks 6.1..7.1 = 1.0 wide).
- **Angles**: 90° and 45° dominate; use 15° increments only when the metaphor demands it.

## 5. Corners and curves

- **Container corner radius: 1.5u**, drawn as a kappa-scaled Bézier corner
  (`file` rect: corner from `11.5 → 13` over `2 → 3.5`, radius 1.5). See PATH_RECIPES.md.
- **Line-work corners are square** — no radius on chevrons, plus, close, etc.
- **Circles**: 4 cubic Béziers, kappa = 0.55228 × radius. Native example (`checked-filled`,
  center 8,8 r6): control offset 6 × 0.55228 = 3.31371, producing the signature
  `4.68629` / `11.3137` coordinates.

## 6. Hollow shapes (rings, knockouts)

Two native techniques — pick one, don't mix within a shape:

1. **Opposite winding** (preferred for simple containers): draw the outer subpath clockwise
   and the inner subpath counter-clockwise in the same `d`; nonzero fill leaves the hole.
   No `fillRule` needed (`file`, `folder`, `box` use this).
2. **evenodd**: set `fillRule: 'evenodd'` (add `clipRule: 'evenodd'` alongside) and draw
   both subpaths in any direction (`eye`, `caret-down-flat` use this).

## 7. Coordinate precision

- Straight axis-aligned edges: integers or halves (`3`, `7.5`, `13`) — this is what keeps
  edges crisp at 16px.
- Derived values (kappa curves, 45° offsets): ≤ 5 decimals, matching native precision
  (`4.68629`, `0.35352`, `12.7539`).
- Never emit more than 5 decimals; never leave floating garbage like `7.999999`.

## 8. Naming, files, exports

| Item          | Convention                             | Example                          |
| ------------- | -------------------------------------- | -------------------------------- |
| `name` field  | kebab-case, matches semantic           | `'rocket-launch'`                |
| Export        | PascalCase + `Icon` suffix             | `RocketLaunchIcon`               |
| File          | one icon per file, kebab-case          | `rocket-launch.ts`               |
| Type import   | `import type { IconDefinition } from '@mezzanine-ui/icons'` | — |
| Suffix pairs  | filled/outline variants use `-filled` / `-outline` | `star-filled` / `star-outline` |

Native categories for reference when organizing custom sets: `alert` (status), `arrow`
(direction), `content` (files/media/actions), `controls` (UI operations), `stepper`
(numbered steps), `system` (app chrome).

## 9. Density budget

An icon that carries more subpaths/detail than its neighbors reads *darker* in a row.
Budget guideline from the native set: most icons are 1–3 conceptual elements
(container + 1–2 inner details). If the metaphor needs more, simplify — Ant Design's
rule: once the meaning is clear, every extra line is decoration and must go.

## 10. Forbidden list (hard rejects)

- `transform` on path or svg (0 / 130 natives use it)
- `<use>`, `<g>`, filters, masks, gradients, multiple `<path>` elements
- Hardcoded colors anywhere (`#000`, `red`, `rgb(...)`) — only `'none'` / `'currentColor'`
- `width` / `height` attributes on the svg definition (sizing is CSS-driven: `1em` default,
  `size` prop → `--mzn-icon-size`)
- Round line caps / rounded line-work corners
- Duplicate subpath copies (an export artifact visible in native `search.ts` — do **not**
  emulate it; it doubles paint operations for no visual gain)
