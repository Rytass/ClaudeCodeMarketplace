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
- [ ] **Cap geometry**: every free-standing terminal is a flat butt cap whose face is
      perpendicular to the stroke. For any arc/arc-band end, the closing segment must be
      **radial** — its two endpoints share one polar angle about the arc centre (differ only
      in radius). A cap whose endpoints have different angles is a skewed wedge → reject.
      (This is the check that catches the classic "serif-looking" arc icon. See the script
      below to verify it numerically.)
- [ ] **Corner geometry**: container outer corners rounded 1.5u (kappa 0.82843); all other
      joins sharp. No round line caps anywhere. A rounded container's inner knockout is
      concentric-rounded (inner radius = outer − wall), not square.
- [ ] **Winding**: `fillRule: 'evenodd'` only for genuine *separate* hole subpaths. A single
      self-intersecting stroke glyph (bluetooth) must be **nonzero** (omit `fillRule`) —
      evenodd would knock its crossings out to white.
- [ ] **Overlap**: no two solids merged into a blob (needle-on-hub); overlapping symbols are
      knocked out for separation.
- [ ] **Even wall**: for a 1u outline of a complex silhouette, the wall is uniform — produced
      by programmatic inset or a filled+knockout, never a hand-written inner contour.
- [ ] **Semantic realism**: orientation matches physics/convention (hanging-tag eyelet at top,
      shackle up, etc.).
- [ ] Element clearance ≥ 1u between separate shapes
- [ ] `name` kebab-case; export `PascalCase + Icon`; one icon per file
- [ ] Detail budget: ≤ 3 conceptual elements; if more, simplify the metaphor

Numeric cap check (run when the icon has any arc terminal — no rendering needed):

```python
import re, math
# d = the path string; cx,cy = the arc's centre used to build the band
def radial_caps_ok(d, cx, cy, tol=0.02):
    prev = cur = None
    for s in re.findall(r"[MLCZ][^MLCZ]*", d):
        n = [float(x) for x in re.findall(r"-?\d+\.?\d*", s[1:])]
        if s[0] == "M": cur = (n[0], n[1])
        elif s[0] == "C": cur = (n[4], n[5])
        elif s[0] == "L":                        # candidate radial cap
            p = (n[0], n[1])
            a0 = math.atan2(prev[1]-cy, prev[0]-cx)
            a1 = math.atan2(p[1]-cy,  p[0]-cx)
            if abs((a0-a1+math.pi) % (2*math.pi) - math.pi) > tol:
                return False                     # skewed cap
            cur = p
        prev = cur
    return True
```

If it returns `False`, an `L` closure is skewed — rebuild that arc band per PATH_RECIPES §4b.

## Gate 2 — Side-by-side render (mandatory)

You **must actually look at the rendered pixels** — path math being correct is not enough
(an even wall, a merged blob, a white-gashed crossing, a wrong-way tag all pass the static
checks but fail on sight). Two ways to look; use whichever is available.

### Gate 2a — Offline render (preferred; no browser needed)

When a browser/screenshot tool is unavailable or flaky, render the SVG to PNG on disk and
read the image directly. This is the most reliable path and works headless:

```bash
# one icon -> PNG (fill uses a concrete color so it shows; currentColor renders black otherwise)
printf '%s' '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 16 16" fill="none"><path fill="#1F2A37" d="D_HERE"/></svg>' > /tmp/ic.svg
rsvg-convert -w 128 -h 128 -b white /tmp/ic.svg -o /tmp/ic.png     # or: inkscape, resvg, cairosvg

# tile the candidate next to native neighbors for comparison
montage cand.png native1.png native2.png -tile 3x1 -geometry +8+8 -background '#e8e8e8' /tmp/cmp.png
```

Then open the PNG with the Read/image tool and inspect at ~128–320 px. Render each candidate
solo at ~280 px too, to catch wall-thickness unevenness, merged solids, skewed caps, and
knockout gashes that vanish at small sizes. (`montage` label text needs ghostscript; if `gs`
is missing the tiles still combine — ignore the label warnings.)

### Gate 2b — Browser harness

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
