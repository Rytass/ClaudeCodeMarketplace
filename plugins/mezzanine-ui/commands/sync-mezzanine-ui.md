---
name: sync-mezzanine-ui
description: "Sync a Mezzanine-UI skill (React or Angular) to match the latest source code. Fetches TypeScript source from GitHub, updates component .md files, refreshes cache JSON, updates SKILL.md. When called with only a framework (no version), auto-resolves the latest stable release from GitHub — pre-release versions (rc / beta / alpha) must always be supplied explicitly. Use when @mezzanine-ui/react or @mezzanine-ui/ng releases a new version. Trigger: sync mezzanine, update mezzanine docs, mezzanine upgrade, mezzanine new version, refresh mezzanine skill."
argument-hint: "<framework: react|ng> [target-version]"
---

# Sync Mezzanine-UI Skill

Orchestrate a team of agents to sync a Mezzanine-UI skill against the actual source code. This ensures all component documentation reflects real TypeScript interfaces/directives and Storybook usage patterns, reducing hallucination.

Two skills are supported — each tracks one npm package:
- **`react`** → `using-mezzanine-ui-react` skill (tracks `@mezzanine-ui/react`)
- **`ng`** → `using-mezzanine-ui-ng` skill (tracks `@mezzanine-ui/ng`)

Both packages live on the `main` branch under `packages/react` and `packages/ng` respectively. npm versions advance independently, so run this command once per framework when you want to bump both.

## Paths

All paths below are relative to the plugin root. `{framework}` is either `react` or `ng`.

- **Skill root**: `skills/using-mezzanine-ui-{framework}/`
- **Component docs**: `skills/using-mezzanine-ui-{framework}/references/components/`
- **Cache files**: `skills/using-mezzanine-ui-{framework}/cache/`
- **Scripts**: `skills/using-mezzanine-ui-{framework}/scripts/`
- **Shared script**: `skills/using-mezzanine-ui-react/scripts/upgrade-version.sh` (accepts `--framework` to target either skill)
- **React-specific agents**: `agents/mzn-*.md` (excluding `mzn-ng-*` and `mzn-cache-updater` / `mzn-meta-updater`)
- **Angular-specific agents**: `agents/mzn-ng-*.md`
- **Shared agents**: `agents/mzn-cache-updater.md`, `agents/mzn-meta-updater.md`

## Phase 0 — Argument Parsing & Prerequisites

Parse the arguments (if any) and fill in missing fields by prompting the user or resolving them automatically from GitHub. Handle all four cases below. **Do not fail silently** — if the input is ambiguous or contradictory, always ask the user directly before proceeding.

### Version-resolution policy

- **No version supplied** → automatically resolve the **latest stable release** (no pre-release suffix such as `-rc`, `-beta`, `-alpha`, `-next`) from GitHub. See the [Resolve Latest Stable](#resolve-latest-stable) block below.
- **Version supplied** → use it as-is. This is the **only** way to sync a pre-release (rc / beta / alpha); pre-releases are never picked automatically, even when they are newer than the latest stable tag.
- This policy applies to both frameworks (`react` and `ng`).

### Case A — No args supplied

Invocation: `/sync-mezzanine-ui`

Prompt the user:

> Which framework would you like to sync?
>
> - `react` — `@mezzanine-ui/react` (React / Next.js)
> - `ng`    — `@mezzanine-ui/ng`    (Angular 21+)
>
> Reply with just the framework name and I'll auto-pick the **latest stable release**. To target a pre-release, also supply the version (e.g. `ng 1.0.0-rc.4`).

After they answer, continue to Case B with the framework they named (and optionally the version, which falls through to Case D).

### Case B — One arg that IS `react` or `ng`

Invocation: `/sync-mezzanine-ui react` or `/sync-mezzanine-ui ng`

Framework is known; resolve the latest stable version automatically using the [Resolve Latest Stable](#resolve-latest-stable) block. Print the result:

> Latest stable `@mezzanine-ui/{framework}` is **`{resolved_version}`** (published `{published_at}`). Syncing to that version.
>
> ⚠ Need a pre-release (rc / beta / alpha)? Re-run with an explicit version, e.g. `/sync-mezzanine-ui ng 1.0.0-rc.4` — pre-releases are never auto-selected.

Then set `{target_version} = {resolved_version}` and continue to **Detect Current Version** below.

If the resolver returns empty (no matching stable release), abort with:

> Could not find a stable `@mezzanine-ui/{framework}` release on GitHub. Please supply an explicit version: `/sync-mezzanine-ui {framework} <version>`.

### Case C — One arg that looks like a version (starts with a digit)

Invocation: `/sync-mezzanine-ui 1.1.0` or `/sync-mezzanine-ui 1.0.0-rc.4`

Framework is missing. The version alone is not enough to pick a skill — both frameworks share the semver format. Prompt:

> You supplied a target version (`{arg}`) but didn't say which framework.
>
> - `react` — `@mezzanine-ui/react`
> - `ng`    — `@mezzanine-ui/ng`
>
> Which skill should I sync to `{arg}`?

**Hint for disambiguation** — if the version string is clearly RC-shaped (contains `rc`), lean toward `ng` in the suggestion wording, but still ask explicitly; never assume.

### Case D — Two args

Invocation: `/sync-mezzanine-ui <framework> <version>`

Validate:
- Framework MUST be exactly `react` or `ng`. If it's anything else (e.g. `vue`, `angular`, `nextjs`), abort with:
  > Unsupported framework: `{arg}`. Choose `react` or `ng`.
- Version MUST match semver (regex `^\d+\.\d+\.\d+(-[a-z0-9.-]+)?$`). If not, abort with:
  > `{arg}` doesn't look like a valid version. Expected semver, e.g. `1.1.0` or `1.0.0-rc.4`.

If the args are reversed (first token looks like a version, second like a framework), silently swap them and proceed — this is a common mistake and recovering is cheap.

### Resolve Latest Stable

Run this block only when a version needs to be resolved automatically (Cases A → B, or Case B). The query:

1. Lists up to the 100 most recent releases from `Mezzanine-UI/mezzanine`.
2. Excludes drafts and anything GitHub flags as `prerelease`.
3. Filters by per-package tag prefix (`@mezzanine-ui/{framework}@`), plus legacy `v{semver}` tags for the `react` track only (the Angular package has no legacy tag stream).
4. Rejects any semver that contains a hyphen — this is the belt-and-suspenders check against `-rc.`, `-beta.`, `-alpha.`, `-next.` tags that slip past GitHub's prerelease flag.
5. Sorts by semver descending and picks the top entry.

Run it (requires `curl` + `jq`, both already required by `upgrade-version.sh`):

```bash
framework="{framework}"   # "react" or "ng"
curl -sfL \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "https://api.github.com/repos/Mezzanine-UI/mezzanine/releases?per_page=100" \
| jq -r --arg framework "$framework" '
    [ .[]
      | select(.prerelease == false and .draft == false)
      | . as $r
      | .tag_name as $tag
      | ($tag | capture(
          "^(?<p>@mezzanine-ui/" + $framework + "@|v)(?<v>[0-9]+\\.[0-9]+\\.[0-9]+)$"
        ; "x"))
      | select(. != null)
      | select($framework == "react" or .p != "v")
      | { version: .v, published: $r.published_at }
    ]
    | sort_by(.version | split(".") | map(tonumber))
    | reverse
    | .[0] // empty
    | "\(.version)\t\(.published)"
  '
```

Expected output is a single line: `{version}\t{published_at}` (e.g. `1.1.0	2026-03-14T09:12:47Z`). Empty output means no stable release matched — fall through to the abort message in Case B.

### After Resolution

You now have `{framework}` and `{target_version}`. Print a one-line confirmation before continuing:

> Syncing `using-mezzanine-ui-{framework}` → `{target_version}`.

### Detect Current Version

Resolve the cache file that carries the current documented version:
- **React** → `skills/using-mezzanine-ui-react/cache/component-api-index.json` — read `._meta.version`
- **Angular** → `skills/using-mezzanine-ui-ng/cache/component-index.json` — read `.version`

If the current version equals the target version, warn the user:
> "Skill is already documented at this version. Re-run anyway to refresh all content?"

Wait for confirmation before continuing.

## Phase 1 — Run Upgrade Analysis Script

Run the shared shell script with the `--framework` flag to produce an upgrade manifest for the selected skill:

```bash
bash skills/using-mezzanine-ui-react/scripts/upgrade-version.sh \
  --framework {framework} \
  --from {current_version} \
  --to   {target_version}
```

This produces `skills/using-mezzanine-ui-{framework}/scripts/upgrade-manifest.json` containing:
- `meta.framework` — `"react"` or `"ng"` (downstream agents key off this)
- Component diff (added, removed, unchanged)
- Changelog entries between versions — filtered by per-package tag prefix (`@mezzanine-ui/react@*` or `@mezzanine-ui/ng@*`)
- Per-component props (React) or inputs (Angular) diff
- **Angular-only**: `angularSpecific[]` tracking selector / CVA / DI tokens / standalone imports changes
- Prioritized work items (HIGH / MEDIUM — every work item must be resolved regardless of priority)

### Display Summary

Show the user a summary table (Angular has extra rows):

| Metric                              | Count | Framework |
| ----------------------------------- | ----- | --------- |
| Components added                    | N     | both      |
| Components removed                  | N     | both      |
| Components with prop/input changes  | N     | both      |
| Components with Angular changes     | N     | ng only   |
| Work items (HIGH)                   | N     | both      |
| Work items (MEDIUM)                 | N     | both      |
| Releases covered                    | N     | both      |

Ask the user: **Proceed with agent team sync?** Wait for confirmation.

## Phase 2 — Source Fetching (blocking)

Launch the framework-appropriate fetcher agent:
- **React** → `mzn-source-fetcher`
- **Angular** → `mzn-ng-source-fetcher`

Pass it the following context:
- Target version: `{target_version}`
- Manifest path: `skills/using-mezzanine-ui-{framework}/scripts/upgrade-manifest.json`
- Output path: `skills/using-mezzanine-ui-{framework}/scripts/source-payload.json`

**Wait for completion** before proceeding — all subsequent agents depend on this output.

## Phase 3 — Component Updates (parallel)

Read the manifest to determine which agents are needed, then launch them **in parallel**. Agent names are `mzn-*` for React, `mzn-ng-*` for Angular.

### 3a. Simple Component Updater

If the manifest has UPDATE work items for non-complex components, launch the framework-appropriate simple updater:
- **React** → `mzn-component-updater-simple`
- **Angular** → `mzn-ng-component-updater-simple`

Pass it:
- Manifest path
- Source payload path
- Component docs directory path

### 3b. Complex Component Updater

If the manifest has UPDATE work items for complex components, launch the framework-appropriate complex updater:
- **React** → `mzn-component-updater-complex`  (complex list: Table, Form, Select, AutoComplete, Cascader, Dropdown, DatePicker, DateRangePicker, DateTimePicker, DateTimeRangePicker, MultipleDatePicker, TimePicker, TimeRangePicker, Navigation, Drawer, Upload, Calendar, Notifier, NotificationCenter)
- **Angular** → `mzn-ng-component-updater-complex`  (complex list additionally includes: FormField, FormGroup, Input, Modal, Stepper — see the agent's frontmatter for the authoritative list)

Pass it the same paths as 3a.

### 3c. Component Creator

If `componentDiff.added` in the manifest is non-empty, launch the creator:
- **React** → `mzn-component-creator`
- **Angular** → `mzn-ng-component-creator`

Pass it:
- Manifest path
- Source payload path
- Template reference: `skills/using-mezzanine-ui-{framework}/references/components/Button.md`

### 3d. Component Deprecator

If `componentDiff.removed` in the manifest is non-empty, launch the deprecator:
- **React** → `mzn-component-deprecator`
- **Angular** → `mzn-ng-component-deprecator` (also passes COMPONENTS.md path; Angular deprecator updates both SKILL.md and COMPONENTS.md)

Pass it:
- Manifest path
- SKILL.md path
- **Angular only**: COMPONENTS.md path (`skills/using-mezzanine-ui-ng/references/COMPONENTS.md`)

**Wait for all Phase 3 agents to complete** before proceeding.

## Phase 4 — Cache & Metadata Finalization (parallel)

Launch these two agents **in parallel**. Both are framework-aware — they read `manifest.meta.framework` to determine which skill directory to operate on.

### 4a. Cache Updater

Launch `mzn-cache-updater`.

Pass it:
- Manifest path
- Source payload path
- Cache directory path (`skills/using-mezzanine-ui-{framework}/cache/`)

Behavior by framework:
- **React**: refreshes `component-api-index.json` + `import-paths-index.json` (content) and version-only updates for Figma-managed caches
- **Angular**: refreshes `component-index.json` (with selector/inputs/outputs/CVA fields) + `import-paths-index.json` + `services-index.json`

### 4b. Meta Updater

Launch `mzn-meta-updater`.

Pass it:
- Manifest path
- Target version
- SKILL.md path
- PATTERNS.md path

Behavior by framework:
- **React**: updates SKILL.md, PATTERNS.md, COMPONENTS.md, ICONS.md, DESIGN_TOKENS.md, FIGMA_MAPPING.md
- **Angular**: updates SKILL.md, PATTERNS.md, COMPONENTS.md, SERVICES.md, plus shared ICONS.md/DESIGN_TOKENS.md/FIGMA_MAPPING.md (re-reference)

**Wait for completion.**

## Phase 5 — Full Verification (MANDATORY, blocking)

This phase verifies that **every single** active component's documentation matches the live TypeScript source code. This is not a sample — it is an exhaustive, 100% coverage check. No component may be skipped.

### 5a. Re-fetch live source for verification

For ALL active components (from `componentDiff.unchanged` + `componentDiff.added`), use WebFetch to retrieve the actual TypeScript source file from GitHub. URL template differs per framework:

- **React**: `https://raw.githubusercontent.com/Mezzanine-UI/mezzanine/main/packages/react/src/{Component}/{Component}.tsx`
- **Angular**: lookup the source file path in `cache/component-index.json` (field `sourceDir`) — file is typically `{sourceDir}/{kebab}.(component|directive).ts` — then fetch `https://raw.githubusercontent.com/Mezzanine-UI/mezzanine/main/{path}`

### 5b. Per-component verification

For **each** active component, compare the live source against the `.md` documentation:

**React** (props parity):
1. Parse the Props interface/type. Trace `extends`, `Omit`, `Pick` chains. Fall back to function destructuring if no explicit interface. Identify explicitly Omit'd props.
2. Read the `.md` file and extract all props from the props table(s).
3. Compare: every source prop in docs, every docs prop in source, Omit'd props absent from docs, types and defaults match, no stale annotations.

**Angular** (10-point Angular Verification Checklist — see `mzn-ng-component-updater-simple`'s workflow for the full list):
1. **Selector** matches exactly (and selectorKind hasn't silently changed).
2. **exportAs** matches (or is absent in both).
3. **Inputs table** has 100% parity with `input()` / `@Input()` declarations — names, types, defaults, api column (signal vs legacy).
4. **Outputs table** has 100% parity with `output()` / `@Output()`.
5. **Import section** matches `index.ts` re-exports exactly.
6. **Standalone imports example** matches `@Component({ imports: [...] })` array verbatim.
7. **ControlValueAccessor** state — if `implementsCva` is true, docs include a Reactive Forms example with `formControlName`; if false, docs must NOT show such an example.
8. **DI tokens** — every `provide: MZN_*` and every `inject(MZN_*)` is documented.
9. **Host bindings** user-visible behaviors noted (best effort).
10. **No stale version annotations**.

### 5c. Cross-file consistency check

- All `.md` files have `Verified {target_version}` in their source line
- SKILL.md component/directive table entries match actual `.md` files (no missing, no duplicates)
- **Angular**: SKILL.md's Selector column matches `cache/component-index.json` for every row
- COMPONENTS.md headings match actual `.md` files (no missing, no duplicates)
- All cache files have `version: {target_version}` (path differs per framework)
- No remaining old version strings (grep entire skill directory)
- PATTERNS.md has no references to deprecated components/selectors
- **Angular**: SERVICES.md entries cross-check against `cache/services-index.json`

### 5d. Report

Output a FULL verification report:

```
=== Full Verification Report ({target_version}) ===

Component-by-component (N total):
  ✅ PASS (N): ComponentA, ComponentB, ...
  ❌ FAIL (N):
    ComponentX:
      - [MISSING_PROP] propName (type, in source but not docs)
      - [EXTRA_PROP] propName (in docs but not source)
      - [TYPE_MISMATCH] propName (docs: X, source: Y)
    ComponentY:
      - ...

Cross-file consistency:
  [OK/FAIL] Version strings: N files checked, M issues
  [OK/FAIL] SKILL.md table: N entries, M mismatches
  [OK/FAIL] COMPONENTS.md: N headings, M mismatches
  [OK/FAIL] Cache files: all at {target_version}

Coverage: N/N components verified (100%)
```

### 5e. Fix-and-recheck loop

If any FAIL is found:
1. Fix the issue using the Edit tool (NEVER Write — incremental changes only)
2. Re-verify ONLY the fixed component(s) against live source
3. Repeat until all components PASS

**Do NOT proceed to Phase 6 until the report shows 0 failures and 100% coverage.**

## Phase 6 — Cleanup & Summary

### Cleanup

Delete the intermediate build artifact:
```bash
rm -f skills/using-mezzanine-ui-{framework}/scripts/source-payload.json
```

This file is large (~700KB for React, similar for Angular) and only needed during the sync process. It should NOT be committed.

### Summary

Display the final sync summary:

```
✓ Mezzanine-UI Skill Sync Complete ({framework})
  Skill:    using-mezzanine-ui-{framework}
  Version:  {current_version} → {target_version}
  Components updated:    N
  Components created:    N
  Components deprecated: N
  Cache files refreshed: {6 for react, 3 for ng}
  Reference docs updated: {react: COMPONENTS.md, ICONS.md, DESIGN_TOKENS.md, FIGMA_MAPPING.md / ng: COMPONENTS.md, SERVICES.md, + shared reference docs}
  SKILL.md updated: ✓
  Full verification: ✓ (N/N components, 100% coverage, 0 failures)
  Intermediate artifacts cleaned: ✓

⚠ (React only) Remember to run figma-sync.sh separately if you have a Figma token.
⚠ (Angular) If @mezzanine-ui/core bumped, React skill's DESIGN_TOKENS.md may need a corresponding refresh — run /sync-mezzanine-ui react ... if so.
⚠ Review changes with `git diff` before committing.
```
