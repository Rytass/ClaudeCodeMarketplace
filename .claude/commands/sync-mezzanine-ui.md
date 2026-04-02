---
name: sync-mezzanine-ui
description: "Sync Mezzanine-UI skill content to match the latest source code. Fetches TypeScript interfaces from GitHub, updates component .md files, refreshes cache JSON, updates SKILL.md. Use when mezzanine-ui releases a new version. Trigger: sync mezzanine, update mezzanine docs, mezzanine upgrade, mezzanine new version, refresh mezzanine skill."
argument-hint: "<target-version>"
---

# Sync Mezzanine-UI Skill

Orchestrate a team of agents to sync the `using-mezzanine-ui` skill content against the actual Mezzanine-UI source code. This ensures all component documentation reflects real TypeScript interfaces and Storybook usage patterns, reducing hallucination.

## Paths

All paths below are relative to the plugin root:

- **Skill root**: `skills/using-mezzanine-ui/`
- **Component docs**: `skills/using-mezzanine-ui/references/components/`
- **Cache files**: `skills/using-mezzanine-ui/cache/`
- **Scripts**: `skills/using-mezzanine-ui/scripts/`
- **Agents**: `agents/mzn-*.md`

## Phase 0 — Argument Parsing & Prerequisites

{{#if args}}
Parse the target version from: `{{ args }}`

Validate it matches semver format (e.g., `1.0.0`, `1.0.0-rc.9`, `1.1.0`).
{{else}}
Ask the user: **What version are you upgrading to?** (e.g., `1.0.0-rc.9`, `1.0.0`)
{{/if}}

### Detect Current Version

Read `skills/using-mezzanine-ui/cache/component-api-index.json` and extract the `._meta.version` field to determine the current documented version.

If the current version equals the target version, warn the user:
> "Skill is already documented at this version. Re-run anyway to refresh all content?"

Wait for confirmation before continuing.

## Phase 1 — Run Upgrade Analysis Script

Run the existing shell script to produce an upgrade manifest:

```bash
cd skills/using-mezzanine-ui
bash scripts/upgrade-version.sh --from {current_version} --to {target_version}
```

This produces `scripts/upgrade-manifest.json` containing:
- Component diff (added, removed, unchanged)
- Changelog entries between versions
- Per-component props diff
- Prioritized work items (HIGH / MEDIUM)

### Display Summary

Show the user a summary table:

| Metric                     | Count |
| -------------------------- | ----- |
| Components added           | N     |
| Components removed         | N     |
| Components with prop changes | N   |
| Work items (HIGH)          | N     |
| Work items (MEDIUM)        | N     |
| Releases covered           | N     |

Ask the user: **Proceed with agent team sync?** Wait for confirmation.

## Phase 2 — Source Fetching (blocking)

Launch the `mzn-source-fetcher` agent.

Pass it the following context:
- Target version: `{target_version}`
- Manifest path: `skills/using-mezzanine-ui/scripts/upgrade-manifest.json`
- Output path: `skills/using-mezzanine-ui/scripts/source-payload.json`

**Wait for completion** before proceeding — all subsequent agents depend on this output.

## Phase 3 — Component Updates (parallel)

Read the manifest to determine which agents are needed, then launch them **in parallel**:

### 3a. Simple Component Updater

If the manifest has UPDATE work items for non-complex components, launch `mzn-component-updater-simple`.

Pass it:
- Manifest path
- Source payload path
- Component docs directory path

### 3b. Complex Component Updater

If the manifest has UPDATE work items for complex components (Table, Form, Select, AutoComplete, Cascader, Dropdown, DatePicker, DateRangePicker, DateTimePicker, DateTimeRangePicker, MultipleDatePicker, TimePicker, TimeRangePicker, Navigation, Drawer, Upload, Calendar, Notifier, NotificationCenter), launch `mzn-component-updater-complex`.

Pass it the same paths as 3a.

### 3c. Component Creator

If `componentDiff.added` in the manifest is non-empty, launch `mzn-component-creator`.

Pass it:
- Manifest path
- Source payload path
- Template reference: `skills/using-mezzanine-ui/references/components/Button.md`

### 3d. Component Deprecator

If `componentDiff.removed` in the manifest is non-empty, launch `mzn-component-deprecator`.

Pass it:
- Manifest path
- SKILL.md path

**Wait for all Phase 3 agents to complete** before proceeding.

## Phase 4 — Cache & Metadata Finalization (parallel)

Launch these two agents **in parallel**:

### 4a. Cache Updater

Launch `mzn-cache-updater` to refresh ALL cache files (component-api-index.json, import-paths-index.json + version-only updates for Figma cache files).

Pass it:
- Manifest path
- Source payload path
- Cache directory path

### 4b. Meta Updater

Launch `mzn-meta-updater` to update SKILL.md, PATTERNS.md, COMPONENTS.md, ICONS.md, DESIGN_TOKENS.md, FIGMA_MAPPING.md, and run consistency verification.

Pass it:
- Manifest path
- Target version
- SKILL.md path
- PATTERNS.md path

**Wait for completion.**

## Phase 5 — Full Verification (MANDATORY, blocking)

This phase verifies that **every single** active component's documentation matches the live TypeScript source code. This is not a sample — it is an exhaustive, 100% coverage check. No component may be skipped.

### 5a. Re-fetch live source for verification

For ALL active components (from `componentDiff.unchanged` + `componentDiff.added`), use WebFetch to retrieve the actual TypeScript source file from GitHub:

```
https://raw.githubusercontent.com/Mezzanine-UI/mezzanine/v2/packages/react/src/{Component}/{Component}.tsx
```

### 5b. Per-component verification

For **each** active component, compare the live source against the `.md` documentation:

1. **Extract props from source**: Parse the Props interface/type. Trace `extends`, `Omit`, `Pick` chains. Fall back to function destructuring if no explicit interface. Identify explicitly Omit'd props.
2. **Read the `.md` file**: Extract all props from the props table(s).
3. **Compare**:
   - Every prop in source MUST exist in docs (no missing props)
   - Every prop in docs MUST exist in source (no phantom props)
   - Props excluded via `Omit<>` must NOT appear in docs
   - Types must match exactly
   - Default values must match source destructuring patterns
   - No stale "Removed in rc.X" or "NEW in rc.X" annotations

### 5c. Cross-file consistency check

- All `.md` files have `Verified {target_version}` in their source line
- SKILL.md component table entries match actual `.md` files (no missing, no duplicates)
- COMPONENTS.md headings match actual `.md` files (no missing, no duplicates)
- All cache files have `version: {target_version}`
- No remaining old version strings (grep entire skill directory)
- PATTERNS.md has no references to deprecated components

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
rm -f skills/using-mezzanine-ui/scripts/source-payload.json
```

This file is ~700KB and only needed during the sync process. It should NOT be committed.

### Summary

Display the final sync summary:

```
✓ Mezzanine-UI Skill Sync Complete
  Version: {current_version} → {target_version}
  Components updated: N
  Components created: N
  Components deprecated: N
  Cache files refreshed: 6
  Reference docs updated: 4 (COMPONENTS.md, ICONS.md, DESIGN_TOKENS.md, FIGMA_MAPPING.md)
  SKILL.md updated: ✓
  Full verification: ✓ (N/N components, 100% coverage, 0 failures)
  Intermediate artifacts cleaned: ✓

⚠ Remember to run figma-sync.sh separately if you have a Figma token.
⚠ Review changes with `git diff` before committing.
```
