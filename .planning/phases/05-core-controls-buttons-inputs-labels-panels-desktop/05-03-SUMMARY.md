---
phase: 05-core-controls-buttons-inputs-labels-panels-desktop
plan: 03
subsystem: dynamic-theme-generator
tags:
  - typevar-01
  - cov-02
  - cov-09
  - basebutton-family
  - button-variations
  - focus-overlay
  - d-04-strategy-dispatch
  - d-07
  - phase5-verifier
dependency_graph:
  requires:
    - 05-01-SUMMARY  # Godot 4.6 CLI + dual verifier scaffold + focus probe scaffold
    - 05-02-SUMMARY  # DIRECTION_PRESETS.shape + _lookup_shape + role_table + strategy dispatchers
    - 04-05-SUMMARY  # BINDING_TABLE + _resolve_recipe baseline
  provides:
    - 6 BINDING_TABLE rows for TYPEVAR-01 button variations (PrimaryButton, SecondaryButton, GhostButton, DangerButton, IconButton, FlatButton)
    - shape.* recipe coverage on Button / OptionButton / MenuButton / ColorPickerButton (Task 2 polish)
    - CheckBox + CheckButton disabled icon slots via existing-SVG reuse
    - 8 new D-12 named verifier groups (buttons stage)
    - per-direction focus_thickness + shape.focus_offset structural assertions in _phase5_focus_probe.gd
  affects:
    - addons/neocade_theme/neocade_theme.gd
    - .planning/phases/05-.../helpers/_phase5_verify_headless.gd
    - .planning/phases/05-.../helpers/_phase5_verify.gd
    - .planning/phases/05-.../helpers/_phase5_focus_probe.gd
tech_stack:
  added: []
  patterns:
    - "BINDING_TABLE-anchored String.find() so verifier scans BINDING_TABLE rows, not CANONICAL_SLOT_NAMES rows that share key form"
    - "Window-cut heuristic on numbered comment headers (`\\n\\t# <digit>`) — distinguishes class-row boundaries from inline polish comments"
    - "Per-direction focus probe loops PHASE5_DIRECTION_TRES_PATHS and asserts structural focus profile on each direction's variation chrome"
    - "DangerButton recipe uses fixed semantic role (role_danger from §7.1) without strategy dispatch — destructive CTAs stay color-stable across directions"
    - "FlatButton uses {alpha: 0.0} on `normal` so the slot is populated (Godot's renderer requires a stylebox for variation registration to take effect) but reads as fully transparent until interaction"
key_files:
  created:
    - .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/05-03-SUMMARY.md
  modified:
    - addons/neocade_theme/neocade_theme.gd
    - .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify_headless.gd
    - .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify.gd
    - .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_focus_probe.gd
decisions:
  - "Base Button / OptionButton / MenuButton / ColorPickerButton rows pull from shape.SECONDARY_radius (not shape.primary_radius) — primary chrome is reserved for the PrimaryButton variation per DESIGN_TOKENS §5; the base Button class is the secondary-tier action."
  - "DangerButton uses {role: role_danger} as a fixed semantic role and INTENTIONALLY skips strategy dispatch. Destructive actions must read consistent across directions (red is red — Pulse cannot make it 'arcade-pulse-danger', Bubble cannot make it 'pillowy-danger'). Hover/pressed differentiation comes from alpha (0.92 / 0.78) rather than per-direction strategy."
  - "IconButton drops shape.primary_padding entirely (compact square hit area) and uses tokens-driven h_separation=0 plus per-direction shape.secondary_radius. Icon hover/pressed/focus colors flip to role_primary so the glyph signals state without a chrome change."
  - "FlatButton uses alpha=0.0 on `normal` rather than omitting the slot. Type-variation registration requires the slot to exist on the theme (set_stylebox call must fire) so Godot picks up the variation — a missing `normal` slot would fall back to the base Button chrome and FlatButton would not read flat."
  - "CheckBox + CheckButton disabled-icon slots REUSE existing checked/unchecked SVGs rather than ship new artwork. Godot's font_disabled_color tints the icon at render time; new SVGs would only differ in opacity, which the tint already provides."
  - "Verifier String.find() now anchors past `const BINDING_TABLE` so the BINDING_TABLE row scanner does not accidentally hit the CANONICAL_SLOT_NAMES dict (same `\"Button\":` key form, but slot enum only — no recipes). Cut heuristic also requires NUMBERED comment headers to mark row boundaries, so inline polish comments (`# Plan 05-03 Task 2 polish: ...`) inside the row body do not prematurely close the scan window."
  - "Focus probe extended to all 5 approved directions (Pulse / Slate / Bubble / Daybreak / Burst) × 4 base controls × 6 TYPEVAR-01 variations = 50 expected focus slots. Each slot gets 5 mandatory structural assertions (StyleBoxFlat / transparent bg / accent border / focus_thickness uniform / shape.focus_offset uniform). Sanity-checks each `.tres`'s loaded base_color hex matches the expected key so DIRECTION_PRESET_DEFAULT silent fallback cannot invalidate the per-direction structural checks."
metrics:
  duration: ~50min
  completed_date: 2026-05-07
  tasks: 3
  commits: 6
  groups_ok: 19/19 (buttons stage)
  focus_slots_ok: 50/50 (5 directions × 10 controls)
  failures: 0
---

# Phase 5 Plan 03: BaseButton Family + Button Variations Summary

Authored TYPEVAR-01 button variation chrome (6 variations) + polished the BaseButton-family base rows with per-direction shape recipes + extended the focus probe to assert structural focus integrity across all 5 approved directions × 10 focusable controls. Closes COV-02 (BaseButton family) and TYPEVAR-01 (button variations) for desktop, and establishes the COV-09 focus baseline for Phase 5.

## What Shipped

### Task 1 — TYPEVAR-01 button variation chrome (commits `03bc63c` RED + `3db249e` GREEN)

**Files:** `addons/neocade_theme/neocade_theme.gd`, `_phase5_verify_headless.gd`, `_phase5_verify.gd`.

**6 new BINDING_TABLE rows** (entries 38-43 in the table) for the TYPEVAR-01 variations. Each variation populates the canonical Godot 4.6 Button state set (normal/hover/pressed/focus/disabled/hover_pressed) using official slot names only (D-07 holds — no `pressed_focus` / `checked_focus` / `hover_pressed_focus` combo slots).

| Variation | bg recipe | radius | padding | raised lift | strategy |
|-----------|-----------|--------|---------|-------------|----------|
| PrimaryButton | `role_primary` | `shape.primary_radius` | `shape.primary_padding` | `shape.raised_lifts.primary` | `shape.primary_strategy` |
| SecondaryButton | `surface_panel` | `shape.secondary_radius` | `shape.primary_padding` | `shape.raised_lifts.secondary` | — |
| GhostButton | `surface_panel` (ghost overrides) | `shape.secondary_radius` | `shape.primary_padding` | `shape.raised_lifts.ghost` | `shape.ghost_strategy` |
| DangerButton | `role_danger` (fixed) | `shape.primary_radius` | `shape.primary_padding` | `shape.raised_lifts.primary` | — |
| IconButton | `surface_panel` | `shape.secondary_radius` | tokens-driven | `shape.raised_lifts.ghost` | — |
| FlatButton | `surface_panel` (alpha=0.0) | `shape.secondary_radius` | `shape.primary_padding` | 0 (never lifts) | — |

**Key wiring:**
- All 6 variations leverage Plan 05-02's `_resolve_recipe` extensions (`radius` / `padding` / `alpha` / `raised_intensity` / `strategy` recipe keys) so per-direction shape language flows from `DIRECTION_PRESETS.shape.*` without per-direction recipe edits.
- PrimaryButton + GhostButton dispatch through `_apply_primary_strategy` / `_apply_ghost_strategy` (5 closed-enum strategies each, sourced verbatim from DESIGN_TOKENS §5.1-§5.5).
- DangerButton uses `{"role": "role_danger"}` added by Plan 05-02 Task 2 → resolves to `#FF6E6E` (DESIGN_TOKENS §7.1 default) on Pulse, NOT `surface_panel`. Closes the Plan 05-03 review HIGH gate.
- IconButton overrides `h_separation=0` and skips `shape.primary_padding` for a compact square hit area; icon hover/pressed/focus flip to `role_primary` so state reads via icon color rather than chrome change.
- FlatButton uses `{"alpha": 0.0}` on `normal` and `disabled` so the slot is REGISTERED (variation chrome won't apply without `set_stylebox` firing) but the bg reads transparent until interaction.
- Phase 4 already wires `set_font` + `set_font_size` for these 6 variations (PITFALLS 1.2 mandate); Plan 05-03 only adds chrome.

**5 new D-12 named verifier groups (mirror of headless + EditorScript)** — buttons stage strict gating:
- `assert_button_variation_rows`: BINDING_TABLE has all 6 TYPEVAR-01 rows.
- `assert_button_variation_states`: each variation populates the full state set on Pulse.
- `assert_button_variation_fonts`: each variation has explicit `font` + `font_size` (PITFALLS 1.2 regression catch).
- `assert_button_strategy_distinctness`: ≥4 distinct primary AND ghost strategy values across the 5 approved directions (sentinel against accidental strategy collapse).
- `assert_dangerbutton_role_danger`: DangerButton.normal bg_color matches `#FF6E6E` RGB (proves Plan 05-02 semantic role flowed through, NOT a surface_panel fallback). Closes review HIGH gate.

**1 sixth D-12 group introduced for COV-02 sanity:**
- `assert_basebutton_family_chrome`: 7 BaseButton-family Controls (Button, CheckBox, CheckButton, OptionButton, MenuButton, ColorPickerButton, LinkButton) expose their official slot set; LinkButton stays text-only (no `normal` stylebox — regression catch).

**Plan 01's `assert_focus_overlay_visibility`** promoted in `--stage buttons` to require `focus` on every TYPEVAR-01 variation (was: only PrimaryButton / SecondaryButton / GhostButton). Now requires DangerButton / IconButton / FlatButton too. Plan 05-03 Task 1's GREEN implementation provides them.

### Task 2 — BaseButton-family polish (commits `9204974` RED + `721b70f` fix + `5293e25` GREEN)

**Files:** `addons/neocade_theme/neocade_theme.gd`, `_phase5_verify_headless.gd`, `_phase5_verify.gd`.

**BINDING_TABLE polish:**
- **Button / OptionButton / MenuButton / ColorPickerButton** rows now reference `shape.secondary_radius` + `shape.primary_padding` + `shape.raised_lifts.secondary` so the per-direction shape language flows into base controls (not just TYPEVAR-01 variations). Without this, Slate/Bubble/Burst's MenuButton/OptionButton would render with the flat `@export corner_radius` baseline and Phase 5 would ship a UX inconsistency.
- **CheckBox / CheckButton** stay icon-driven on stylebox slots (intentionally — Phase 4 commentary documents this).
- **CheckBox** added `checked_disabled` + `unchecked_disabled` icons reusing the existing `checkbox_checked` / `checkbox_unchecked` SVGs (Godot's font_disabled_color tint handles the visual disabled state).
- **CheckButton** same reuse pattern with `checkbutton_checked` / `checkbutton_unchecked`. The 4 `*_mirrored` variants stay deferred to v1.x per Phase 4 CHANGELOG.

**2 new D-12 named verifier groups (mirror in EditorScript variant):**
- `assert_basebutton_family_shape_aware`: source-text scan over BINDING_TABLE rows (anchored past `const BINDING_TABLE` so it can't accidentally match CANONICAL_SLOT_NAMES — same key form, no recipes). Each shape-aware target must contain a `shape.*` reference somewhere in its body.
- `assert_checkbox_disabled_icon_reuse`: live theme introspection via `get_icon_list` for `checked_disabled` + `unchecked_disabled` on CheckBox + CheckButton.

**LinkButton remains text-only** (no `normal` stylebox added) — regression caught by `assert_basebutton_family_chrome`.

### Task 3 — 5-direction × 10-control structural focus probe (commit `bd9643a`)

**Files:** `_phase5_focus_probe.gd` (full rewrite from Pulse-only to all-direction probe).

The Plan 01 baseline focus probe loaded only Pulse and asserted on 4 base controls (16 implicit checks). Plan 05-03 Task 3 extends it to:
- Loop `PHASE5_DIRECTION_TRES_PATHS` (5 approved directions).
- For each direction, assert focus on **4 base controls** (Button / CheckBox / CheckButton / OptionButton) AND **6 TYPEVAR-01 variations** (PrimaryButton / SecondaryButton / GhostButton / DangerButton / IconButton / FlatButton). 4 + 6 = 10 slots × 5 directions = **50 expected focus slots**.

**5 mandatory structural assertions per focus stylebox:**
1. **StyleBoxFlat** — rejects custom subclasses the focus pipeline doesn't understand.
2. **`bg_color.a == 0`** — focus is an outer ring, not a fill replacement.
3. **`border_color == theme.accent_color`** — per-direction accent (Pulse `#8BFF6A` / Slate `#8BD3FF` / Bubble `#FFB3E6` / Daybreak `#76F2D1` / Burst `#FFD166`).
4. **All 4 `border_width_*` uniform == `theme.focus_thickness`** — per-direction `@export` (Pulse 2 / Slate 2 / Bubble 3 / Daybreak 2 / Burst 3).
5. **All 4 `expand_margin_*` uniform == `shape.focus_offset`** via `_lookup_shape` (Pulse 0 / Slate 2 / Bubble 2 / Daybreak 2 / Burst 1, per DESIGN_TOKENS §8.2).

**D-07 invariant guard:** invented combo slots (`pressed_focus` / `checked_focus` / `hover_pressed_focus`) hard-fail per direction.

**Sanity check:** each `.tres`'s loaded `base_color.to_html(false).to_upper()` must match its expected `PHASE5_DIRECTION_TRES_PATHS` key — guards against silent `DIRECTION_PRESET_DEFAULT` fallback that would invalidate the per-direction structural checks (regression catch).

**Pixel render path:** continues to emit `PHASE5_FOCUS_RENDER_SKIPPED` per CONTEXT.md. Full tab-walk visual QA remains Phase 10. Structural assertions stand alone as the Plan 05-03 gate.

## Verification

### Plan 05-03 verify blocks (plan-verbatim, all three tasks)

```
=== buttons-stage verifier (Tasks 1 + 2) ===
PHASE5_VERIFY OK (stage=buttons)
  groups OK:      19 / 19
  groups PENDING: 4  ["assert_variation_count_15", "assert_inf_text_normal_font_size", "assert_codeedit_gutter_slots", "assert_spinbox_icons"]
  failures:       0

=== focus probe (Task 3) ===
PHASE5_FOCUS_PROBE OK
  directions probed: 5 / 5
  focus slots OK:    50 / 50
  pixel render:      SKIPPED
  failures:          0
```

The 4 PENDING groups are by design — they cover Plan 05-04 (15th `Kicker` variation + InfoText size slot), Plan 05-05 (CodeEdit gutter chrome + folded icon), Plan 05-06 (SpinBox arrow icons). Plan 05-03's `--stage buttons` correctly treats them as TOOLING (PENDING ≠ FAIL) per D-12.

### Plan 05-02 carry-forward (regression check)

```
=== shape-stage verifier ===
PHASE5_VERIFY OK (stage=shape)
  groups OK:      19 / 19
  groups PENDING: 4
  failures:       0
```

All Plan 05-02 shape gates still ENFORCED OK (the `--stage buttons` strict allow-list explicitly carries forward `assert_shape_lookup_integrity` / `assert_shape_value_integrity` / `assert_shape_recipe_resolution` / `assert_semantic_role_table` / `assert_no_invented_focus_combos` / `assert_no_theme_clear` so the variation recipes can rely on shape resolution).

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 - Bug] `assert_basebutton_family_shape_aware` String.find() returned wrong row**
- **Found during:** Task 2 first GREEN attempt — Button + OptionButton flagged as having no `shape.*` references despite the BINDING_TABLE rows having them.
- **Issue:** `src_text.find("\"Button\":")` returned the FIRST occurrence at line 666 — the `CANONICAL_SLOT_NAMES["Button"]` slot enumeration (no recipes). The actual `BINDING_TABLE["Button"]` row at line 820 was never scanned. Same bug for OptionButton.
- **Fix:** Anchored the search past `src_text.find("const BINDING_TABLE")` so the row scanner walks the right dict. Hard-fails if the `const BINDING_TABLE` declaration is itself missing (regression catch).
- **Files modified:** `_phase5_verify_headless.gd`, `_phase5_verify.gd`.
- **Commit:** `721b70f`.

**2. [Rule 1 - Bug] Window-cut heuristic stopped at inline polish comment**
- **Found during:** Task 2 first GREEN attempt — even after fixing the anchor, the row window for `Button` was being cut at `\n\t# Plan 05-03 Task 2 polish:` (an inline comment INSIDE the Button row body), so the scanner never reached the `shape.*` references on lines 823+.
- **Issue:** Original heuristic cut at the next `\n\t# ` which matches BOTH numbered class headers (`# 3. CheckBox`) AND inline polish comments. Pre-existing CANONICAL_SLOT_NAMES rows didn't have inline comments, so the bug only surfaced once Plan 05-03 added them.
- **Fix:** Required the character after `\n\t# ` to be a digit (`0-9`) before treating the position as a row boundary. Inline comments don't start with a digit so they're correctly ignored.
- **Files modified:** `_phase5_verify_headless.gd`, `_phase5_verify.gd`.
- **Commit:** `721b70f` (same commit as deviation #1; both were the same self-review pass).

No Rule 2 (missing critical functionality), Rule 3 (blocking), or Rule 4 (architectural) deviations.

## Self-Check: PASSED

**Files exist on the worktree branch (`worktree-agent-abae1205f1446c870`):**
- `addons/neocade_theme/neocade_theme.gd` — FOUND (1995 lines after Plan 05-03 additions)
- `.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify_headless.gd` — FOUND, modified
- `.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify.gd` — FOUND, modified
- `.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_focus_probe.gd` — FOUND, full rewrite
- `.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/05-03-SUMMARY.md` — FOUND (this file)

**Commits exist on `worktree-agent-abae1205f1446c870`:**
- `03bc63c` (Task 1 RED) — added buttons-stage verifier + 6 new D-12 named groups (pre-implementation; verifier FAILs on missing chrome).
- `3db249e` (Task 1 GREEN) — added 6 BINDING_TABLE rows for TYPEVAR-01 variations; verifier passes.
- `9204974` (Task 2 RED) — added `assert_basebutton_family_shape_aware` + `assert_checkbox_disabled_icon_reuse`; verifier FAILs on missing polish.
- `721b70f` (Task 2 fix) — Rule 1 bug fixes for verifier scoping (BINDING_TABLE anchor + numbered-comment-only cut heuristic).
- `5293e25` (Task 2 GREEN) — polished Button / OptionButton / MenuButton / ColorPickerButton + added disabled icon reuse to CheckBox / CheckButton; verifier passes.
- `bd9643a` (Task 3) — extended focus probe to 5 directions × 10 controls with 5 mandatory structural assertions per slot.

**No out-of-scope drift:** `git status` shows only this `05-03-SUMMARY.md` untracked at the moment of write; `git diff --name-only e0de3bd..HEAD` lists exactly the 4 files in scope per the plan's `files_modified` frontmatter. No `addons/*.tres` modifications, no `showcase/showcase.tscn` modifications, no `STATE.md` / `ROADMAP.md` modifications (the orchestrator owns those writes after the wave completes).
