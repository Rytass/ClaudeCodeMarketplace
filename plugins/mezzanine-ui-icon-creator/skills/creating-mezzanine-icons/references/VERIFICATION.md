# Verification Workflow

A new icon is not done until it has passed all three gates: definition lint,
side-by-side render, and blur/weight check. "The path math is correct" is not a
substitute for rendering it.

## Gate 1 — Definition lint (static checks)

- [ ] `svg.viewBox === '0 0 16 16'` and `svg.fill === 'none'`
- [ ] `path.fill === 'currentColor'`; no other color values anywhere
- [ ] Single `d` string; no `stroke*`, `transform`, `width`, `height` fields
- [ ] Command vocabulary only `M L H V C Z` (no `A Q S T`, no lowercase/relative)
- [ ] No coordinate outside `1.8 .. 14.21` (live area + directional-tip tolerance)
- [ ] Straight-line coords are integers or halves; derived coords ≤ 5 decimals
- [ ] Every notional stroke measures exactly 1.0 wide (spot-check: pick two edge
      coordinate pairs and subtract — axis-aligned diffs = 1.0 or 0.5×2;
      45° cap corners are 0.70703 apart per axis)
- [ ] `fillRule`/`clipRule` present only if the shape genuinely needs evenodd holes
- [ ] Element clearance ≥ 1u between separate shapes
- [ ] `name` kebab-case; export `PascalCase + Icon`; one icon per file
- [ ] Detail budget: ≤ 3 conceptual elements; if more, simplify the metaphor

## Gate 2 — Side-by-side render (mandatory)

Write the harness below to a temp file, paste the candidate `IconDefinition`(s) and 3–4
native neighbors (from NATIVE_EXAMPLES.md, ideally the same archetype), open it in a
browser (or render via any available browser tool) and inspect. Delete the temp file
afterwards.

```html
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<style>
  body { font-family: system-ui, sans-serif; margin: 24px; background: #fff; color: #161616; }
  .dark { background: #161616; color: #f2f2f2; }
  section { margin-bottom: 28px; }
  .row { display: flex; align-items: center; gap: 16px; }
  .cell { display: flex; flex-direction: column; align-items: center; gap: 4px; }
  .cell span { font-size: 10px; opacity: .6; }
  .candidate { outline: 1px dashed #d84; outline-offset: 4px; }
  .blur svg { filter: blur(2px); }
  h2 { font-size: 13px; text-transform: uppercase; letter-spacing: .05em; opacity: .7; }
</style>
</head>
<body>
<script>
// Paste definitions here. Mark candidates with candidate: true.
const icons = [
  { candidate: false, name: 'chevron-down', d: 'M12.1465 5.64648L8 9.79297L3.85352 5.64648L3.14648 6.35352L8 11.207L12.8535 6.35352L12.1465 5.64648Z' },
  // { candidate: true, name: 'my-new-icon', d: '...', fillRule: 'evenodd' },
];

const sizes = [16, 24, 32, 48];

function svgFor(icon, size) {
  const fr = icon.fillRule ? ` fill-rule="${icon.fillRule}" clip-rule="${icon.fillRule}"` : '';
  return `<svg width="${size}" height="${size}" viewBox="0 0 16 16" fill="none">` +
    `<path fill="currentColor"${fr} d="${icon.d}"/></svg>`;
}

function renderRow(size, blur) {
  return `<div class="row ${blur ? 'blur' : ''}">` + icons.map((icon) =>
    `<div class="cell ${icon.candidate ? 'candidate' : ''}">${svgFor(icon, size)}<span>${icon.name}</span></div>`
  ).join('') + `</div>`;
}

function renderTheme(cls, title) {
  return `<div class="${cls}" style="padding:16px">` +
    `<h2>${title}</h2>` +
    sizes.map((s) => `<section><h2>${s}px</h2>${renderRow(s, false)}</section>`).join('') +
    `<section><h2>Blur test (24px)</h2>${renderRow(24, true)}</section>` +
    `</div>`;
}

document.body.innerHTML = renderTheme('', 'Light') + renderTheme('dark', 'Dark');
</script>
</body>
</html>
```

Inspection points, per size:

- **16px**: edges crisp? (fuzzy edges ⇒ off-grid straight lines)
- **24/32px**: line weight visually identical to neighbors? curves smooth?
- **48px**: no lumps or kinks in Béziers? (kinks ⇒ freehanded curves — rebuild with recipes)
- **Dark theme**: renders pure `currentColor`? (any tint ⇒ hardcoded color leaked in)

## Gate 3 — Blur / optical-weight test

In the harness's blur row, all icons collapse to grey blobs. The candidate's blob must
match the neighbors' darkness:

- **Too dark** → overweight: lines thicker than 1u, too many elements, or shape drawn
  past the 12×12 live area. Fix geometry, don't shrink the render.
- **Too light** → underweight: shape too small for its keyshape (e.g. a square drawn at
  Ø-circle extents looks fine, but one drawn at 9×9 vanishes), or overly sparse.

This is the industry-standard "optical volume" check (Lucide / Octicons / Nucleo) and is
the single most reliable predictor of an icon "blending in".

## In-app verification

When the icon ships into a real project, additionally verify at the consumption site:

```tsx
import { Icon } from '@mezzanine-ui/react';
import { SearchIcon } from '@mezzanine-ui/icons';
import { MyCustomIcon } from './custom-icons/my-custom';

<>
  <Icon icon={SearchIcon} size={24} />
  <Icon icon={MyCustomIcon} size={24} />  {/* must be indistinguishable in weight/style */}
</>
```

- `color` prop variants (`primary`, `error`, …) apply correctly (proves `currentColor` chain)
- Default sizing follows `1em` when `size` is omitted (proves no `width`/`height` leaked)
- If used in buttons/table actions, check the 16px rendering there — that's the harshest
  real-world size.

## SVGO note (for icons imported from SVG files)

If the source ever passes through an `.svg` file, optimize before transcribing into an
`IconDefinition`: `svgo --multipass` with `preset-default`, keep `removeViewBox: false`,
add `removeAttrs` for `stroke|fill` remnants. Then still run Gates 1–3 — SVGO output is
routinely off-grid and over-precise; expect to re-snap coordinates.
