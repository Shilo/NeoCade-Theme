---
phase: 05-core-controls-buttons-inputs-labels-panels-desktop
plan: 02
subsystem: dynamic-theme-generator
tags:
  - direction-shape-schema
  - recipe-resolution
  - semantic-role-table
  - phase5-verifier
  - d-02
  - d-03
  - d-04
  - d-08
  - d-13
dependency_graph:
  requires:
    - 05-01-SUMMARY  # Godot 4.6 CLI + dual verifier scaffold
    - 04-05-SUMMARY  # BINDING_TABLE + _resolve_recipe baseline
  provides:
    - DIRECTION_PRESETS.shape (per-direction shape language sub-block, 5 directions + DEFAULT)
    - _lookup_shape(presets, dotted_path) helper
    - _resolve_recipe schema additions (radius / padding / alpha / raised_intensity / strategy / kicker_style / value via shape.*)
    - role_table semantic role keys (role_success / role_warning / role_danger / role_info)
    - _set_radius_all / _set_content_margin_from_padding helpers
    - _apply_primary_strategy / _apply_ghost_strategy / _apply_kicker_style strategy dispatchers
    - assert_shape_lookup_integrity end-to-end .tres-load assertion
  affects:
    - addons/neocade_theme/neocade_theme.gd
    - .planning/phases/05-.../helpers/_phase5_verify_headless.gd
    - .planning/phases/05-.../helpers/_phase5_verify.gd
tech_stack:
  added:
    - StringName closed-enum strategy keys (D-04)
    - Vector2i Phase 4 FOUND-02 reuse for per-direction primary_padding
  patterns:
    - "Dotted-path Variant lookup via shape.<a>.<b>... walker (`_lookup_shape`)"
    - "Recipe schema string-prefix discriminator: `shape.` => _lookup_shape, `tokens.` => platform tokens, else literal"
    - "Closed-enum dispatch: match String(strategy_name) keeps strategy set finite; `_:` no-op = D-04 escape hatch"
    - "PowerShell `& $godot --headless --path . --script ... -- --stage shape` invocation"
key_files:
  created:
    - .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/05-02-SUMMARY.md
  modified:
    - addons/neocade_theme/neocade_theme.gd
    - .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify_headless.gd
    - .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify.gd
decisions:
  - "Strategy enum dispatch lives in dedicated `_apply_*_strategy()` helpers rather than inline `_resolve_recipe()` switch — keeps recipe resolution readable when 5+ strategies stack (D-04 future-proof)."
  - "Strategy lookup discriminates dispatch target by suffix of the dotted path (`shape.primary_strategy` -> primary; `shape.ghost_strategy` -> ghost) — generalizes cleanly when Plan 05-03+ adds shape.danger_strategy, shape.success_strategy, etc."
  - "_lookup_shape uses literal string prefix `shape.` (not regex) — matches the `tokens.` precedent for `value: tokens.<key>` and avoids self-invalidation when the verifier scans for the prefix."
  - "Semantic role keys live in role_table (Dictionary) rather than as @export properties — keeps the public 9-export surface FROZEN per Phase 4 D-13 while still letting Plan 05-03 DangerButton bind via `{\"role\": \"role_danger\"}`."
  - "DEFAULT fallback verification instantiates NeoCadeTheme.new() with a non-approved hex (#0F0F0F) rather than mocking the lookup — proves the live `_resolve_direction_presets()` path actually works for custom consumers (D-13 contract)."
  - "Task 3 verifier extension uses `base_color.to_html(false).to_upper()` for the .tres hex check — matches `_resolve_direction_presets()`'s key-derivation exactly so any drift between the two is caught."
metrics:
  duration: ~30m (re-spawned executor — Task 1 already complete; this run executed Tasks 2 + 3)
  completed_date: 2026-05-07
  tasks: 3
  commits: 2 (this re-spawn) + 1 (prior Task 1 commit on worktree base)
  groups_ok: 11/11 (shape stage)
  failures: 0
---

# Phase 5 Plan 02: Direction Shape Schema and Recipe Resolution Summary

Authored the per-direction `DIRECTION_PRESETS.shape` sub-block + recipe-resolver dispatch + semantic role table so Phase 5+ variation chrome flows from data recipes that read `shape.<key>` paths against the active direction — without expanding the public 9-export surface or touching any `.tres` file.

## What Shipped

### Task 1 — DIRECTION_PRESETS.shape sub-block (commit `d2f268b`, pre-existing)

**Files:** `addons/neocade_theme/neocade_theme.gd`, `_phase5_verify_headless.gd`, `_phase5_verify.gd`.

Each of the 5 approved direction rows (keyed by uppercased base_color hex: `151A2E`/`111820`/`241326`/`0B2420`/`20112E`) plus `DIRECTION_PRESET_DEFAULT` gained a `shape: Dictionary` sub-block with these keys (sourced VERBATIM from DESIGN_TOKENS §5.1-§5.5 "Theme Editor override intent" lines):

| Key | Type | Purpose |
| --- | ---- | ------- |
| `primary_radius` | int | Primary-button corner radius (Pulse 0; Slate 14; Bubble 999 pill; Daybreak 8; Burst 28). |
| `primary_padding` | Vector2i | x = horizontal padding, y = vertical padding (per Phase 4 FOUND-02 paired-x/y convention). |
| `primary_strategy` | StringName | Closed enum: `bold-accent-fill`, `quiet-pill`, `pillowy-fully-rounded`, `friendly-generous`, `oversized-statement`. |
| `ghost_strategy` | StringName | Closed enum: `accent-outlined-accent-text`, `thin-accent-outline`, `rounded-ghost-thicker-outline`, `soft-outline`, `normal-accent-ghost`. |
| `secondary_radius` / `tab_radius` / `chip_radius` / `card_radius` / `hero_radius` | int | Per-Control radius family. |
| `surface_alpha_{panels,popup,buttons}` | float | Surface alpha trio per direction (Slate popup 0.92 iOS-bleed; Daybreak panels 0.96 / popup 0.90 airy-bleed; rest 1.00). |
| `raised_lifts` | Dictionary | 11 sub-keys (`primary` / `secondary` / `ghost` / `selected_tab` / `unselected_tab` / `panel` / `dialog` / `list` / `mark` / `selected_row` / `chip`) for per-direction extruded-flat lift magnitudes. Pulse selected_row=0 (rows do NOT lift per §5.1). |
| `focus_offset` | int | Per-direction focus ring gap (DESIGN_TOKENS §8.2): Pulse=0, Burst=1, Slate/Bubble/Daybreak=2. |
| `kicker_style` | StringName | Closed enum: `uppercase-tracked-accent` (Pulse/Bubble), `small-caps-subtle` (Slate), `sentence-case-accent` (Daybreak/DEFAULT), `uppercase-bold-larger-scale` (Burst). |

Phase 4 scalar carry-over (`spread_factor`, `hover_pct`, `pressed_pct`, `disabled_opacity`) preserved unchanged on every row. No new `@export` properties. No `.tres` file modifications.

Verifier groups added in Task 1: `assert_shape_value_integrity` (per-direction value match against tokens), `assert_shape_recipe_resolution` (Task 2 helper-presence pre-check), `assert_semantic_role_table` (Task 2 role-key pre-check), `assert_no_invented_focus_combos` (D-07 BINDING_TABLE forbidden-name scan), and the new `--stage shape` selector (PENDING → FAIL only for shape-related groups).

### Task 2 — `_lookup_shape`, recipe schema extensions, semantic role table (commit `c8d9224`)

**Files:** `addons/neocade_theme/neocade_theme.gd`.

**Semantic role table (review HIGH gate closure, DESIGN_TOKENS §7.1):**
- New locals in `_regenerate_theme()` BEFORE the BINDING_TABLE walk: `role_success = Color("#5CC971")`, `role_warning = Color("#FFD166")`, `role_danger = Color("#FF6E6E")`, `role_info = Color("#5FE3FF")` — defaults sourced verbatim from §7.1.
- Added to `role_table` so Plan 05-03's DangerButton (and future Success / Warning / Info chrome) can bind via `{"role": "role_danger"}` without silently falling back to `surface_panel` / `text_strong` (which would ship the wrong color and breach §7.1).
- Per §7.1 "directions may override" — v1 ships defaults; per-direction overrides plug in via `DIRECTION_PRESETS.shape.*` in v2.

**`_lookup_shape(presets, dotted_path) -> Variant`:** New helper. Walks `presets["shape"]` segment-by-segment for paths like `"shape.primary_radius"` / `"shape.raised_lifts.primary"`. Returns the leaf (int / float / Vector2i / StringName / Dictionary) or `null` if any segment is missing. For approved direction presets, missing keys are verifier failures (D-02 mandate); the only acceptable null return is when `presets` lacks `shape` entirely — never possible for approved directions or DEFAULT.

**Helper functions (new):**
- `_set_radius_all(sb, r)` — uniform corner_radius_top_left/top_right/bottom_left/bottom_right.
- `_set_content_margin_from_padding(sb, Vector2i)` — x→left/right, y→top/bottom.
- `_apply_primary_strategy(sb, name, role_table, presets)` — dispatches the 5 closed-enum primary strategies; mutates StyleBoxFlat in place per the active direction.
- `_apply_ghost_strategy(sb, name, role_table, presets)` — same for the 5 ghost strategies.
- `_apply_kicker_style(name, role_table) -> Color` — returns the per-direction Kicker font_color (helper present so Task 2's verifier finds it; Plan 05-04 wires the actual `Kicker` BINDING_TABLE entry).

**`_resolve_recipe()` schema extensions (D-03):** the existing `stylebox` / `color` / `constant` / `font_size` branches now interpret these new recipe keys:

| Key | Recipe value form | Effect |
| --- | ----------------- | ------ |
| `radius` | int literal `OR` `"shape.<int_key>"` | Calls `_set_radius_all(sb, resolved_radius)`. Falls back to `@export corner_radius` if absent. |
| `padding` | `"shape.<Vector2i_key>"` | Calls `_set_content_margin_from_padding(sb, padding)`. Falls back to platform-aware Phase 4 derivation if not a `shape.*` lookup. |
| `alpha` | float literal `OR` `"shape.<float_key>"` | Multiplies bg_color alpha (preserves rgb). Works on both stylebox and color recipes. |
| `raised_intensity` | int literal `OR` `"shape.<int_key>"` | Per-direction lift magnitude (e.g., `shape.raised_lifts.primary`). |
| `strategy` | `"shape.primary_strategy"` `OR` `"shape.ghost_strategy"` | Dispatches by suffix: `*.primary_strategy` → `_apply_primary_strategy`; `*.ghost_strategy` → `_apply_ghost_strategy`. |
| `kicker_style` | `"shape.kicker_style"` | Color recipe path: dispatches via `_apply_kicker_style` and returns the resolved Color. |
| `value` | `"tokens.<key>"` `OR` `"shape.<int_key>"` | Constant/font_size recipes can pull from tokens (Phase 4 baseline) or shape (Plan 05-02 new). |

**Focus ring construction:** the `focus_ring` special-case stylebox now reads `shape.focus_offset` via `_lookup_shape` for `expand_margin_*` so each direction's focus ring sits at its DESIGN_TOKENS §8.2 gap (Pulse=0, Burst=1, others=2). If `focus_offset` is absent or non-numeric the helper falls back to 2 (mid).

**Closed-enum strategy dispatch (D-04):** unknown strategy names are no-ops (D-04 escape hatch + recipe-default bg stays in place); the verifier flags typos at `assert_shape_recipe_resolution`.

**D-01 invariant preserved:** no `Theme.clear()` / `set_theme(null)` introduced. **D-04 escape hatch preserved:** recipes returning null still skip their slot.

### Task 3 — `assert_shape_lookup_integrity` end-to-end (commit `416b6c4`)

**Files:** `_phase5_verify_headless.gd`, `_phase5_verify.gd`.

Extended the Plan 01 baseline `assert_shape_lookup_integrity` group in BOTH verifier variants (headless + EditorScript) so the `shape` stage proves the live hex-keyed direction lookup works on every approved `.tres`, not just on the const-literal map.

**New consts at the top of each verifier:**

```gdscript
const PHASE5_DIRECTION_TRES_PATHS := {
    "151A2E": "res://addons/neocade_theme/pulse_neocade_theme.tres",
    "111820": "res://addons/neocade_theme/slate_neocade_theme.tres",
    "241326": "res://addons/neocade_theme/bubble_neocade_theme.tres",
    "0B2420": "res://addons/neocade_theme/daybreak_neocade_theme.tres",
    "20112E": "res://addons/neocade_theme/burst_neocade_theme.tres",
}

const PHASE5_RECIPE_PATHS := [
    "shape.primary_radius", "shape.primary_padding", "shape.primary_strategy",
    "shape.ghost_strategy", "shape.kicker_style", "shape.focus_offset",
    "shape.surface_alpha_panels", "shape.surface_alpha_popup",
    "shape.surface_alpha_buttons",
    "shape.raised_lifts.primary", "shape.raised_lifts.panel", "shape.raised_lifts.dialog",
]
```

**Phase A** (carry-forward, Plan 01 baseline): walks `DIRECTION_PRESETS` const for each of the 5 approved hex keys and asserts each shape sub-block exposes every `PHASE5_SHAPE_KEYS` entry non-null.

**Phase B** (Plan 05-02 Task 3 new): per-direction `.tres` load. For each `.tres`:
- Asserts loaded `base_color.to_html(false).to_upper()` equals the expected hex_key (regression catch: a `.tres` drifting to a non-approved hex would silently DEFAULT-fallback and the personality would vanish).
- Asserts `_resolve_direction_presets()` returns a row whose `shape` sub-block matches the const-literal row for that hex on `primary_radius` + `focus_offset` + `primary_strategy` (live lookup hits the right row, NOT `DIRECTION_PRESET_DEFAULT`).
- Iterates `PHASE5_RECIPE_PATHS` (12 entries) and asserts each `_lookup_shape(resolved, path)` returns non-null. Closes Task 3 spec "assert all recipe paths used by Phase 5 plans resolve non-null" — and includes `shape.focus_offset` explicitly per D-08.
- `shape.focus_offset` gets an extra range check (`TYPE_INT`, `0..4` inclusive) to enforce DESIGN_TOKENS §8.2.

**Phase C** (Plan 05-02 Task 3 new): DEFAULT fallback contract (D-13). Instantiates `NeoCadeTheme.new()` with a non-approved hex (`#0F0F0F`) and asserts `_resolve_direction_presets()` returns `DIRECTION_PRESET_DEFAULT.shape` (signature check: `primary_strategy = friendly-generous`). Proves custom-themed consumers get a stable shape baseline rather than null/empty.

**Forbidden-name list scan (`assert_no_invented_focus_combos`):** unchanged — already a data Array (not regex pattern), so Task 3's "do not make the forbidden-name list self-invalidating" requirement was already met by Plan 01.

## Verification

`--stage shape` headless run logged at `.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/logs/05-02-shape-task3.log`:

```
PHASE5_VERIFY: stage=shape
PHASE5_VERIFY: helper wiring OK (Pulse loads + Phase 4 baseline holds + production .gd present).
PHASE5_GROUP_OK:assert_shape_lookup_integrity ENFORCED  all 5 directions have shape.* sub-blocks; .tres files resolve to per-direction rows; recipe paths non-null incl. focus_offset; DEFAULT fallback works
PHASE5_GROUP_OK:assert_no_theme_clear ENFORCED  no Theme.clear() / set_theme(null) calls in production class (non-comment scan)
PHASE5_GROUP_OK:assert_shape_value_integrity ENFORCED  shape values match DESIGN_TOKENS §5.1-§5.5 verbatim across all 5 approved directions + DEFAULT
PHASE5_GROUP_OK:assert_shape_recipe_resolution ENFORCED  _resolve_recipe dispatches shape.radius/padding/alpha/raised_intensity correctly via _lookup_shape; helpers present
PHASE5_GROUP_OK:assert_semantic_role_table ENFORCED  role_danger / role_warning / role_success / role_info present in production source and resolve via recipe path
PHASE5_GROUP_OK:assert_no_invented_focus_combos ENFORCED  no invented focus combo slots in BINDING_TABLE (D-07 holds)
----- PHASE5_VERIFY summary -----
  groups OK:      11 / 11
  groups PENDING: 5  ["assert_variation_count_15", "assert_inf_text_normal_font_size", "assert_codeedit_gutter_slots", "assert_spinbox_icons", "assert_focus_overlay_visibility"]
  failures:       0
PHASE5_VERIFY OK (stage=shape)
```

The 5 PENDING groups are by design — they cover Plan 05-04 (15th `Kicker` variation), Plan 05-04 InfoText size slot, Plan 05-05 CodeEdit gutter chrome + folded icon, Plan 05-06 SpinBox arrow icons, and Plan 05-03 variation focus overlay wiring. Plan 05-02's `--stage shape` correctly treats them as TOOLING (PENDING ≠ FAIL) per D-12.

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 3 - Blocking] Worktree filesystem-write path resolution**
- **Found during:** Task 2 implementation.
- **Issue:** The Edit/Write tools use the literal absolute path the agent supplies. When that path was `C:\Programming_Files\Shilocity\Godot\NeoCade-Theme\addons\neocade_theme\neocade_theme.gd` (the natural absolute path the agent had been writing about), the writes landed in the **main repo working tree** on `main` branch, NOT in the worktree at `C:\Programming_Files\Shilocity\Godot\NeoCade-Theme\.claude\worktrees\agent-a341736679053212a\addons\...`. The harness's Read tool kept showing the in-memory edited view, so it took a verifier failure to surface the leak.
- **Fix:** (a) `git checkout HEAD -- addons/neocade_theme/neocade_theme.gd` in the main repo to revert the leaked changes (no commit was created; only the working tree was modified, so a per-file checkout was sufficient). (b) `cp` the captured edits into the correct worktree path. (c) Switched all subsequent Edit/Write paths to the explicit `.claude\worktrees\agent-a341736679053212a\` prefix. (d) Validated with `git rev-parse --abbrev-ref HEAD` (worktree-agent-* namespace) before each commit, plus `git status --short` after each Bash file-mutation to confirm the change appeared in the worktree.
- **Files modified:** Recovery touched `/c/Programming_Files/Shilocity/Godot/NeoCade-Theme/addons/neocade_theme/neocade_theme.gd` (reverted) and `/c/Programming_Files/Shilocity/Godot/NeoCade-Theme/.claude/worktrees/agent-a341736679053212a/addons/neocade_theme/neocade_theme.gd` (received the Task 2 changes).
- **Commit:** Task 2 work landed cleanly at `c8d9224` on the worktree branch only (verified `git diff main...HEAD --name-only`).

No Rules 1, 2, or 4 deviations.

## Self-Check: PASSED

**Files exist on the worktree branch:**
- `addons/neocade_theme/neocade_theme.gd` — FOUND (1736 lines, sha256 `9f154286...51465e2b`)
- `.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify_headless.gd` — FOUND, modified
- `.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify.gd` — FOUND, modified
- `.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/05-02-SUMMARY.md` — FOUND (this file)

**Commits exist on `worktree-agent-a341736679053212a`:**
- `d2f268b` (Task 1) — pre-existing on worktree base
- `c8d9224` (Task 2) — added by this re-spawn
- `416b6c4` (Task 3) — added by this re-spawn

**No out-of-scope drift:** `git status` shows only this SUMMARY.md untracked at the moment of write; no `addons/*.tres` or `showcase/showcase.tscn` modifications appear in any of the three commits.
