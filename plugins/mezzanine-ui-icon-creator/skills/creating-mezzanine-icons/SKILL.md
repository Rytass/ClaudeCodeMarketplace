---
name: creating-mezzanine-icons
description: Create custom SVG icons that visually match the native @mezzanine-ui/icons set (130 built-in icons, 16x16 grid, fill-only style). Use when a needed icon is missing from @mezzanine-ui/icons, when adding a custom IconDefinition, or when designing SVG icons for a Mezzanine-UI (React or Angular) project. Covers the locked style contract, deterministic path construction recipes (stroke outlining, kappa circles, rings, chevrons, arrows), IconDefinition scaffolding, and side-by-side verification. Trigger — custom icon, missing icon, new icon, svg icon, IconDefinition, mezzanine icon, icon 不夠用, 自訂 icon, 補 icon.
---

# Creating Mezzanine-UI Compatible Icons

Produce custom SVG icons that sit next to native `@mezzanine-ui/icons` icons without looking out of place. The native set is **style-locked**: every rule below is derived from analyzing all 130 built-in icon sources (`@mezzanine-ui/icons` 1.0.2) plus industry icon-system practice (Material, Carbon, Ant Design, Lucide, Octicons).

> **Prime directive: never freehand path data.** Every coordinate must come from the deterministic recipes in [references/PATH_RECIPES.md](references/PATH_RECIPES.md). Freehanded curves are the #1 cause of icons that look "almost right but off".

## Step 0 — Check the native inventory first

Before creating anything, check whether a native icon (or a close-enough one) already exists. The full 130-icon inventory by category is in [references/NATIVE_EXAMPLES.md](references/NATIVE_EXAMPLES.md). If a native icon covers the semantic, **use it — do not create a duplicate**.

## The Style Contract (hard invariants)

Violating any row makes the icon rejectable. Full details and rationale: [references/STYLE_SPEC.md](references/STYLE_SPEC.md).

| Rule                | Locked value                                                       |
| ------------------- | ------------------------------------------------------------------ |
| viewBox             | `0 0 16 16` — always, no exceptions                                |
| Paint model         | **Fill only.** `svg.fill: 'none'`, `path.fill: 'currentColor'`. Never use `stroke`, `strokeWidth`, or stroke-based drawing |
| Path count          | Exactly **one** `<path>` — merge all shapes as subpaths in one `d` string |
| Equivalent stroke   | **1 unit** (in the 16-grid) for all line work                      |
| Live area           | 12×12 (inset 2 from each edge); tallest/widest elements may reach 2..14 |
| Keyshapes           | Circle Ø12 (2..14) · Square ≈11 (2.5..13.5) · Rect 12×10 / 10×12   |
| Corner radius       | Containers 1.5u; line work meets at square (unrounded) joins       |
| Circles             | 4 cubic Béziers with kappa `0.55228` — never approximate           |
| Hollow shapes       | `fillRule: 'evenodd'` + `clipRule: 'evenodd'`, or opposite subpath winding |
| Forbidden           | `transform`, `<use>`, filters, hardcoded colors, `width`/`height` on svg |
| Decimal precision   | ≤ 5 decimals; straight lines on integers or halves (x.5)           |

## Workflow

### 1. Pick the archetype

Match the new icon to one of the native archetypes so it inherits proven geometry:

- **Line-work glyph** (chevron, plus, close, trash) — outlined 1u strokes
- **Filled badge** (checked-filled, star-filled) — solid keyshape, optional knockout symbol
- **Ring/outline badge** (checked-outline) — Ø12 circle with 1u ring + inner symbol
- **Container + content** (file, folder, calendar) — 1.5u-radius rounded rect + inner 1u details
- **Arrow** (long-tail / short-tail / caret) — canonical head+shaft dimensions

### 2. Construct the path deterministically

Follow [references/PATH_RECIPES.md](references/PATH_RECIPES.md) exactly:

1. Sketch on the 16-grid: place element centerlines on integers or halves.
2. Convert every stroke to an outline by offsetting ±0.5 along the normal
   (axis-aligned: ±0.5 on one axis; 45° diagonals: ±0.35355 on both axes — native rounds to `0.35352`).
3. Circles/arcs via the kappa formula; rounded corners via the 1.5u corner recipe.
4. Concatenate all subpaths into one `d` string (`M...Z M...Z`, space-separated).
5. Add `fillRule: 'evenodd', clipRule: 'evenodd'` **only** if the shape needs holes that winding direction can't produce.

### 3. Emit the IconDefinition

One icon per file, kebab-case filename, `PascalCase + Icon` export:

```ts
// custom-icons/rocket.ts
import type { IconDefinition } from '@mezzanine-ui/icons';

export const RocketIcon: IconDefinition = {
  name: 'rocket',
  definition: {
    svg: {
      viewBox: '0 0 16 16',
      fill: 'none',
    },
    path: {
      fill: 'currentColor',
      d: 'M...Z',
    },
  },
};
```

Consume exactly like a native icon — React: `<Icon icon={RocketIcon} size={24} />`; the Icon host spreads `definition.svg` / `definition.path` straight onto the DOM, and `currentColor` keeps theme colors (`color` prop → `--mzn-icon-color`) working. Angular (`@mezzanine-ui/ng`) consumes the same `IconDefinition` objects.

### 4. Verify before delivering (mandatory)

Run the checklist and the side-by-side preview harness in [references/VERIFICATION.md](references/VERIFICATION.md):

1. **Lint the definition** — viewBox, fill-only, single path, no forbidden attrs, precision.
2. **Side-by-side render** at 16 / 24 / 32 / 48 px next to 3–4 native neighbors (harness template provided).
3. **Blur test** — at equal blur, the new icon's grey density must match the natives'; too dark = overweight (too much detail or >1u lines), too light = underweight.
4. **Dark mode** — flip `color` to white; any hardcoded color shows immediately.

Do not report the icon as done until the side-by-side render has actually been produced and inspected.

## Common failure modes (self-check)

- Equivalent stroke ≠ 1u (usually from copying a 24-grid icon without rescaling)
- Freehand Béziers instead of kappa circles → lumpy curves next to perfect native circles
- More detail density than natives → icon reads "darker" in a row of icons
- Rounded line caps/joins — the native set uses **square** cuts on line work
- Shape drawn to the full 16×16 canvas instead of the 12×12 live area
- Keeping a live `stroke` attribute → breaks `currentColor` theming and scale consistency

## References

| File                                             | Content                                              |
| ------------------------------------------------ | ---------------------------------------------------- |
| [STYLE_SPEC.md](references/STYLE_SPEC.md)         | Full style contract, keyshapes, naming, type interface |
| [PATH_RECIPES.md](references/PATH_RECIPES.md)     | Deterministic construction math + worked example      |
| [NATIVE_EXAMPLES.md](references/NATIVE_EXAMPLES.md) | 130-icon inventory + annotated canonical sources    |
| [VERIFICATION.md](references/VERIFICATION.md)     | QC checklist + preview harness + blur test            |
