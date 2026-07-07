# Path Construction Recipes

Deterministic math for building Mezzanine-compatible path data. Every recipe reproduces
coordinates found in the native set — follow them and the output is native-identical by
construction. All units are 16-grid units; SVG y-axis points **down**.

## Constants

| Constant             | Value     | Native evidence                              |
| -------------------- | --------- | -------------------------------------------- |
| KAPPA                | `0.55228` | `checked-filled`: 6 × 0.55228 = `3.31371`    |
| Stroke width         | `1.0`     | every line-work icon                          |
| 45° half-offset      | `0.35352` | `chevron-down`: `5.64648` / `6.35352` = 6 ∓ 0.35352 (exact value 1/(2√2) = 0.35355, native rounds to 0.35352) |
| 45° full-offset      | `0.70703` | `chevron-down` vertex: `9.79297` / `11.207` = 10.5 ∓ 0.70703 |
| Container radius     | `1.5`     | `file`, `trash` container corners             |
| Kappa corner offset  | `0.82843` | 1.5 × 0.55228 (`file`: `12.3284`, `2.67157`) |

## 1. Stroke outlining (the core operation)

Every visible "line" is a filled quadrilateral: offset the centerline ±0.5 along its normal.

**Axis-aligned stroke** — centerline y = c, from x₁ to x₂ (horizontal):
outline the rect `x₁, c−0.5` → `x₂, c+0.5`. Written native-style:

```
M{x2} {c-0.5} V{c+0.5} H{x1} V{c-0.5} H{x2} Z
```

Native example — `plus` (two 1u bars, centerlines x=8 and y=8, extent 3..13):
`M8.5 7.5H13V8.5H8.5V13H7.5V8.5H3V7.5H7.5V3H8.5V7.5Z`

**45° stroke** — offset each centerline endpoint by `(±0.35352, ∓0.35352)`
(the two signs give the two edges). Butt caps: connect the edge ends directly,
producing cap corners 1.0 apart.

Native example — `close` (X made of two 45° strokes, centerlines
(4,4)–(12.4,12.4) and (12.4,4)–(4,12.4)):
`M12.7539 4.35352L8.90723 8.19922L12.7539 12.0459L12.0469 12.7529L8.2002 8.90625L4.35352 12.7529L3.64648 12.0459L7.49219 8.19922L3.64648 4.35352L4.35352 3.64648L8.2002 7.49219L12.0469 3.64648L12.7539 4.35352Z`

**Arbitrary angle** — for centerline direction `(dx, dy)` with length L, the unit normal is
`(-dy/L, dx/L)`; offset endpoints by ±0.5 × normal. Round results to ≤5 decimals.

## 2. Chevron (V-stroke with square caps)

Canonical geometry (`chevron-down`): centerline `(3.5,6) → (8,10.5) → (12.5,6)`,
both legs at 45°, width 1. The construction:

- Cap corners: endpoint ± `(0.35352, 0.35352)` perpendicular to the leg
- Vertex: outer point = vertex + `0.70703` along the bisector (here +y), inner point = vertex − `0.70703`

```
M12.1465 5.64648 L8 9.79297 L3.85352 5.64648 L3.14648 6.35352 L8 11.207 L12.8535 6.35352 Z
```

Rotate/mirror the same numbers for up/left/right chevrons (swap/negate coordinates around 8).

## 3. Circle (kappa Bézier)

Circle center `(cx, cy)`, radius `r`, k = r × 0.55228 — **clockwise** (positive shape):

```
M{cx} {cy-r}
C{cx+k} {cy-r} {cx+r} {cy-k} {cx+r} {cy}
C{cx+r} {cy+k} {cx+k} {cy+r} {cx} {cy+r}
C{cx-k} {cy+r} {cx-r} {cy+k} {cx-r} {cy}
C{cx-r} {cy-k} {cx-k} {cy-r} {cx} {cy-r}
Z
```

Counter-clockwise (for holes under nonzero winding): reverse the x-order — from the top
point head left first. Native Ø12 badge circle (center 8,8, r 6, CW):
`M8 2C11.3137 2 14 4.68629 14 8C14 11.3137 11.3137 14 8 14C4.68629 14 2 11.3137 2 8C2 4.68629 4.68629 2 8 2Z`

Native r5 hole (CCW, from `checked-outline`):
`M8 3C5.23858 3 3 5.23858 3 8C3 10.7614 5.23858 13 8 13C10.7614 13 13 10.7614 13 8C13 5.23858 10.7614 3 8 3Z`

## 4. Ring / outline badge

Ø12 outer circle CW + Ø10 inner circle CCW concatenated in one `d` (1u ring). Add inner
symbol subpaths (CW) after the hole — they paint on top of the knocked-out interior.
This is exactly `checked-outline`'s structure. No `fillRule` needed.

## 5. Rounded container (1.5u corners)

Rect from `(x1,y1)` to `(x2,y2)`, radius 1.5, kappa offset 0.82843. Top-right corner
sequence (others by symmetry):

```
H{x2-1.5} C{x2-1.5+0.82843} {y1} {x2} {y1+1.5-0.82843} {x2} {y1+1.5}
```

Native example — `file` outer shell (10×12 portrait rect, x 3..13, y 2..14, only the
outer path is rounded; the inner knockout is a plain square-cornered rect drawn CCW):

```
M11.5 2C12.3284 2 13 2.67157 13 3.5V12.5C13 13.3284 12.3284 14 11.5 14H4.5C3.67157 14 3 13.3284 3 12.5V3.5C3 2.67157 3.67157 2 4.5 2H11.5ZM4 13H12V3H4V13Z
```

Wall thickness = 1u (outer 3..13, inner 4..12). Inner content lines are separate 1u
rect subpaths with ≥1u clearance from the walls.

## 6. Arrows

**Long-tail** (canonical `long-tail-arrow-right`): 1u shaft on the horizontal centerline
(y 7.5..8.5) from x=2, plus a 45° V head with centerline `(9.5,4) → (13.5,8) → (9.5,12)`
— same construction as the chevron. Shaft merges into the head's inner edge:

```
M14.207 8L9.85352 12.3535L9.14648 11.6465L12.293 8.5H2V7.5H12.293L9.14648 4.35352L9.85352 3.64648L14.207 8Z
```

To point another direction, rotate all coordinates 90°/180° around (8,8)
(`(x,y) → (16−y, x)` etc.) — do not re-derive.

**Caret** (solid triangle, `caret-down`): base 9 wide at y=4.5 (x 3.5..12.5), apex `(8,11.5)`:
`M3.5 4.5L8 11.5L12.5 4.5L3.5 4.5Z` (native adds `fillRule/clipRule: 'evenodd'` here; harmless for a solid triangle — omit for new icons).

## 7. Filled badge with knockout symbol

Ø12 circle CW, then the symbol drawn CCW inside — nonzero winding knocks it out
(`checked-filled` pattern). Symbol strokes are still built with recipe #1
(the check mark is an outlined 1u stroke, just wound opposite).

## 8. Assembly rules

1. One `d` string; subpaths concatenated as `...Z M...` (single space, no commas between subpaths).
2. Winding: positive shapes CW, holes CCW. Use `fillRule: 'evenodd'` + `clipRule: 'evenodd'`
   only when winding control is impractical (e.g. reusing symmetric subpath code).
3. Command vocabulary: `M L H V C Z` only (matches the native set — no `A`, `Q`, `S`, `T`,
   no relative commands).
4. Round every computed value to ≤5 decimals; keep straight-line coords on integers/halves.

## 9. Porting an icon from a 24-grid reference set

When modeling a new icon on a Lucide/Material shape: scale the *centerline sketch*
by 2/3 onto the 16-grid, snap centerlines to integers/halves, then re-outline all strokes
at **1u** with recipe #1. Never scale finished 24-grid path data directly — a 2px stroke
becomes 1.33u (visibly heavier than native) and coordinates land off-grid.

## 10. Worked example — `MinusOutlineIcon`

Goal: ring badge with a horizontal minus bar (pairs with native `*-outline` alert icons).

1. Ring: recipe #4 → outer Ø12 CW + inner Ø10 CCW (exact native subpaths from #3).
2. Bar: centerline y=8, x 5..11 (≥1u clearance from the r5 hole edge at x≈3), width 1
   → rect `5,7.5 → 11,8.5`, drawn CW (positive, paints inside the hole).

```ts
import type { IconDefinition } from '@mezzanine-ui/icons';

export const MinusOutlineIcon: IconDefinition = {
  name: 'minus-outline',
  definition: {
    svg: {
      viewBox: '0 0 16 16',
      fill: 'none',
    },
    path: {
      fill: 'currentColor',
      d: 'M8 2C11.3137 2 14 4.68629 14 8C14 11.3137 11.3137 14 8 14C4.68629 14 2 11.3137 2 8C2 4.68629 4.68629 2 8 2ZM8 3C5.23858 3 3 5.23858 3 8C3 10.7614 5.23858 13 8 13C10.7614 13 13 10.7614 13 8C13 5.23858 10.7614 3 8 3ZM11 7.5V8.5H5V7.5H11Z',
    },
  },
};
```

Every coordinate above is either a native-verified circle constant or an integer/half —
zero freehand values. This is the standard to hold every new icon to.
