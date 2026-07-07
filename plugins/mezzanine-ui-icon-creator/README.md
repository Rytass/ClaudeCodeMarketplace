# mezzanine-ui-icon-creator

Create custom SVG icons that visually match the native `@mezzanine-ui/icons` set, so
project-specific icons sit next to built-in Mezzanine icons without looking out of place.

## What's inside

| Component | Description |
| --------- | ----------- |
| `creating-mezzanine-icons` skill | Style-locked authoring guide with deterministic path construction recipes and a mandatory verification workflow |

## Why

`@mezzanine-ui/icons` ships 130 icons. Real projects always need a few more. Freehanding
SVG paths produces icons that are subtly off — wrong equivalent stroke width, lumpy curves,
mismatched optical weight. This skill locks every visual parameter to values measured from
the full native set (16×16 grid, fill-only `currentColor`, 1u equivalent stroke, kappa
circles, 1.5u container corners) and gives agents reproducible math instead of taste.

## Skill structure

```
skills/creating-mezzanine-icons/
├── SKILL.md                        entry point: style contract + workflow
└── references/
    ├── STYLE_SPEC.md               full spec: grid, keyshapes, naming, forbidden list
    ├── PATH_RECIPES.md             construction math: stroke outlining, circles, arrows
    ├── NATIVE_EXAMPLES.md          130-icon inventory + annotated canonical sources
    └── VERIFICATION.md             lint checklist + side-by-side/blur preview harness
```

## Usage

Install via the Rytass marketplace, then just ask for an icon in a Mezzanine project:

> "我需要一個 rocket icon，@mezzanine-ui/icons 沒有提供"

The skill guides the agent to check the native inventory first, construct the path with
the locked recipes, emit a typed `IconDefinition`, and verify it side-by-side with native
neighbors before delivering.

Baseline: `@mezzanine-ui/icons` 1.0.2.
