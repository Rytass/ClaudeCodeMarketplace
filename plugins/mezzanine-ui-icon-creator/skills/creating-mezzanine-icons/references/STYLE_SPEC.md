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
- **Terminals: flat butt cap, but the cap face must be *perpendicular to the stroke
  direction* (for an arc, that means *radial* — the face points at the arc's center).**
  The native set does not round terminals, but the cap face is never skewed either. This
  distinction is the single most common source of "off" custom icons — a skewed or
  wedge-shaped cap reads as a serif-like flourish and breaks the clean sans-serif feel.
  - Straight stroke → cap is a straight segment perpendicular to the stroke axis
    (`plus`: `H13V8.5H8.5` — the `V8.5` face is perpendicular to the horizontal bar).
  - Arc / arc-band → each open end is closed with a **radial straight line** from the outer
    radius to the inner radius. Native proof: `spinner` is a 3/4-circle band whose ends are
    `...8 2V3...` and `...3 8H2...` — the `V3` and `H2` are exactly those radial butt caps.
    `refresh-cw`, `reverse-left`, and `reset` all terminate their arcs the same way (radial
    flat cap, often meeting a solid arrowhead).
  - **Never** close an arc band by running a curve straight from the outer-radius endpoint
    into the inner arc — that produces a slanted wedge (the classic mistake). Insert an
    explicit `L` to the inner-radius point at the same angle first. See PATH_RECIPES.md §4.
  - Do not import Lucide/Feather-style *round* caps — those belong to a stroke-based system,
    not this fill-only one.
- **Joins: sharp** where two straight strokes meet at an interior angle (chevron vertex,
  plus/close crossings). Container *outer* corners are the exception — they are rounded 1.5u
  (see §5). Inner corners of a knockout stay sharp.
- **Clearance**: keep ≥ 1u between separate elements (e.g. `trash` inner ticks vs walls).
- **Inner detail lines** are also 1u (`file` text lines, `trash` ticks 6.1..7.1 = 1.0 wide).
- **Angles**: 90° and 45° dominate; use 15° increments only when the metaphor demands it.

## 5. Corners and curves

- **Container OUTER corner radius: 1.5u**, drawn as a kappa-scaled Bézier corner
  (kappa offset 1.5 × 0.55228 = 0.82843). Native evidence: `file` outer shell corner
  `11.5 → 13` over `2 → 3.5`; `folder` `...C7.44353 3 7.917 3.2575...` and `...14 5.17157 14 6`;
  `upload` bottom tray corners `...13.9941 13.3294 13.3226 14.001 12.4941 14.001`. This
  rounding is what gives the set its soft, sans-serif silhouette — apply it to every
  free-standing container outline (card, badge, panel, tray).
- **Everything that is not a container outer corner stays sharp**: chevrons, plus, close,
  the interior corners of a knockout, and arrow heads all use unrounded joins.
- **Circles**: 4 cubic Béziers, kappa = 0.55228 × radius. Native example (`checked-filled`,
  center 8,8 r6): control offset 6 × 0.55228 = 3.31371, producing the signature
  `4.68629` / `11.3137` coordinates.

Quick reference — where each treatment applies:

| Feature                              | Treatment                        | Native anchor            |
| ------------------------------------ | -------------------------------- | ------------------------ |
| Free-standing straight terminal      | butt cap ⟂ to stroke axis        | `plus`, `setting`        |
| Open arc / arc-band terminal         | radial straight (`L`/`V`/`H`) cap| `spinner`, `refresh-cw`  |
| Container outer corner               | rounded 1.5u (kappa 0.82843)     | `file`, `folder`, `upload` |
| Two straight strokes meeting         | sharp join                       | `chevron-down`, `close`  |
| Interior corner of a knockout        | sharp                            | `file` inner rect        |

## 6. Hollow shapes, winding, and overlaps

Two native techniques for a hole — pick one, don't mix within a shape:

1. **Opposite winding** (preferred for simple containers): draw the outer subpath clockwise
   and the inner subpath counter-clockwise in the same `d`; nonzero fill leaves the hole.
   No `fillRule` needed (`file`, `folder`, `box` use this).
2. **evenodd**: set `fillRule: 'evenodd'` (add `clipRule: 'evenodd'` alongside) and draw
   both subpaths in any direction (`eye`, `caret-down-flat` use this).

**When NOT to use evenodd — self-intersecting stroke glyphs.** A single continuous 1u outline
that crosses over itself (bluetooth rune, a knot) must fill with **nonzero** (omit `fillRule`).
Under evenodd the self-crossings knock out to white — the tell-tale white gashes at a glyph's
junctions. Rule of thumb: evenodd is for *separate* hole subpaths; nonzero is for *one*
outline that may overlap itself.

**Concentric inner knockout.** If the outer boundary is a rounded container, its inner
knockout should be **concentric-rounded** (inner radius = outer − wall), not square. A rounded
outer against a sharp inner reads as uncoordinated (see PATH_RECIPES §5).

**Overlapping solids need separation.** Two filled elements that overlap and share winding
merge into a single blob. Where a symbol sits on a solid (a gauge needle on its hub, a dot on
a badge) knock out to separate them — the native `checked-filled` knocks the check out of the
disc; a gauge pivot is cleanest as a **donut hub** with the needle leaving from its edge.

## 6b. Semantic realism

Geometry can be perfect and the icon still wrong if it defies real-world intuition. A hanging
tag's eyelet belongs at the **top** (that's where the string goes); a padlock's shackle is up,
a power plug's prongs point the way they insert, light radiates outward. Before finalizing,
sanity-check the metaphor against physics and convention, not just the grid.

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
