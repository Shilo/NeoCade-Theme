---
phase: 05-core-controls-buttons-inputs-labels-panels-desktop
plan: 04
subsystem: dynamic-theme-generator
tags:
  - kicker-variation
  - infotext-bl02-size-slot
  - label-rtl-variation-chrome
  - panel-card-hero-variation-chrome
  - typevar-02
  - typevar-03
  - typevar-04
  - typevar-05
  - cov-07
  - d-09
  - d-10
  - d-16
  - phase5-verifier
  - text-panels-stage
dependency_graph:
  requires:
    - 05-01-SUMMARY  # Godot 4.6 CLI resolver + dual verifier scaffold
    - 05-02-SUMMARY  # DIRECTION_PRESETS.shape + _lookup_shape + strategy dispatchers + semantic role table
    - 05-03-SUMMARY  # BaseButton family rows + 6 button variations + focus probe
  provides:
    - TYPE_VARIATIONS["Kicker"]: "Label" (15th type variation; D-09 closes DESIGN_TOKENS §8.6 todo)
    - explicit set_font + set_font_size for Kicker (PITFALLS 1.2; variations don't inherit fonts)
    - InfoText size slot fix (set_font_size("normal_font_size", "InfoText", ...) replaces the wrong "font_size" slot per D-16 BL-02)
    - BINDING_TABLE rows for HeaderLarge / HeaderMedium / HeaderSmall / Caption / CodeLabel font_color
    - BINDING_TABLE row for Kicker font_color (kicker_style closed-enum dispatch via _apply_kicker_style)
    - BINDING_TABLE row for InfoText (default_color, selection_color, font_selected_color)
    - BINDING_TABLE rows for PanelContainer / CardPanel / HeroPanel (shape.{card,hero}_radius + shape.surface_alpha_panels + shape.raised_lifts.panel)
    - text-panels stage in headless + EditorScript verifiers (PENDING == FAIL for 8 strict groups)
    - 4 new strict groups (assert_no_letter_spacing_claim, assert_kicker_chrome, assert_text_label_variation_chrome, assert_panel_variation_chrome)
    - empirical proof of Godot's has_<kind> inheritance behavior (helpers/_phase5_diag_inftext.gd)
  affects:
    - addons/neocade_theme/neocade_theme.gd (TYPE_VARIATIONS + BINDING_TABLE + _regenerate_theme set_font/set_font_size calls)
    - .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify_headless.gd
    - .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify.gd
    - .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_diag_inftext.gd (NEW)
    - .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/.gitignore (helpers/_run-verifier.ps1 excluded)
tech-stack:
  added: []
  patterns:
    - "TYPE_VARIATIONS const + explicit set_font + set_font_size per variation (PITFALLS 1.2 contract)"
    - "BINDING_TABLE color-only rows for label variations (font_color) + RTL color rows (default_color / selection_color / font_selected_color)"
    - "BINDING_TABLE stylebox rows for PanelContainer / CardPanel / HeroPanel using shape.* dotted-path lookups"
    - "Closed-enum dispatch for Kicker font_color via _apply_kicker_style (D-04 first-class enum)"
    - "Verifier groups use get_<kind>_list (AUTHORED slots) instead of has_<kind> (Godot reports inherited Control class signatures)"
key-files:
  created:
    - .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_diag_inftext.gd
    - .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/05-04-SUMMARY.md
  modified:
    - addons/neocade_theme/neocade_theme.gd
    - .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify_headless.gd
    - .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify.gd
    - .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/.gitignore
decisions:
  - "Kicker is the 15th type variation mapped to Label (D-09); Theme owns font + size + color only — tracking / case-transform / wght-bold-larger-scale live content-side because Godot 4.6 Label has no Theme-level letter_spacing constant (research finding; assert_no_letter_spacing_claim guards regression)."
  - "InfoText size slot must be `normal_font_size` (RichTextLabel canonical), not `font_size` (Phase 4 close fixed `normal_font` but missed the size half — Godot silently ignores the wrong slot and falls back to default_font_size)."
  - "PanelContainer added to BINDING_TABLE (Rule 2 deviation): Phase 4 only had Panel, but CardPanel + HeroPanel both extend PanelContainer, so without an explicit row the base container would not flow per-direction surface_alpha_panels / raised_lifts.panel."
  - "Verifier `has_<kind>` reports Godot Control class slot signatures, masking missing AUTHORED set_*() calls (Rule 1 deviation). Switched to get_<kind>_list across 5 groups (assert_inf_text_normal_font_size, assert_kicker_chrome, assert_text_label_variation_chrome, assert_panel_variation_chrome, plus a defensive carry-forward fix on assert_inf_text_normal_font_size). Empirical proof captured in helpers/_phase5_diag_inftext.gd."
  - "PanelContainer panel role = surface_panel; CardPanel = surface_panel + shape.card_radius; HeroPanel = surface_high + shape.hero_radius — surface_high is one tonal step above surface_panel so a Hero stack reads above a Card in the extruded-flat layer order."
metrics:
  duration: ~25 minutes (sequential mode)
  completed: 2026-05-06
---

# Phase 5 Plan 04: Text, Label, RichTextLabel, and Panel Variation Chrome Summary

Closes Plan 05-04: TYPE_VARIATIONS now has 15 entries (Kicker added per D-09); InfoText size slot uses `normal_font_size` per D-16/BL-02; Label, RichTextLabel, Panel, PanelContainer, CardPanel, and HeroPanel variation chrome flows through the Plan 05-02 `shape.*` recipe schema across all 5 approved directions.

## What landed

**Production class (`addons/neocade_theme/neocade_theme.gd`):**

1. `TYPE_VARIATIONS` gains `"Kicker": "Label"` → **15 entries** (was 14). Closes D-09 / DESIGN_TOKENS §8.6 explicit Phase 5 todo.
2. `_regenerate_theme()` adds:
   - `set_font("font", "Kicker", body_font)` — PITFALLS 1.2 (variations don't inherit fonts).
   - `set_font_size("font_size", "Kicker", tokens.kicker)` — 12 desktop / 13 mobile per DESIGN_TOKENS §10.1.
3. **InfoText size-slot BL-02 fix:** the wrong `set_font_size("font_size", "InfoText", ...)` line is **deleted** (not supplemented) and replaced with `set_font_size("normal_font_size", "InfoText", tokens.body)` to pair with the already-correct `normal_font` slot Phase 4 fixed.
4. **7 new BINDING_TABLE color-only rows** (Plan 05-04 Task 2; rows 44-50): HeaderLarge / HeaderMedium / HeaderSmall (text_strong) / Caption (text_default) / CodeLabel (text_strong) / Kicker (`{"kicker_style": "shape.kicker_style"}` — dispatches via `_apply_kicker_style`) / InfoText (default_color / selection_color / font_selected_color).
5. **3 new BINDING_TABLE stylebox rows** (Plan 05-04 Task 3; rows 51-53): PanelContainer / CardPanel / HeroPanel — all use `shape.surface_alpha_panels` + `shape.raised_lifts.panel`; CardPanel adds `shape.card_radius`, HeroPanel adds `shape.hero_radius` and uses `surface_high` role for layer-order distinction.

**Verifier (`_phase5_verify_headless.gd` + `_phase5_verify.gd`):**

6. New `--stage text-panels` (8 strict groups: variation_count_15, inf_text_normal_font_size, kicker_chrome, text_label_variation_chrome, panel_variation_chrome, no_letter_spacing_claim, no_theme_clear, no_invented_focus_combos).
7. 4 new assertion groups (assert_no_letter_spacing_claim, assert_kicker_chrome, assert_text_label_variation_chrome, assert_panel_variation_chrome). Total group count rose from 19 to **23**.
8. `assert_inf_text_normal_font_size` rewritten to use `get_font_size_list` / `get_font_list` for AUTHORED slot detection (was using `has_*`, which walks Control inheritance and reports built-in slot signatures).

**Helper added:** `helpers/_phase5_diag_inftext.gd` — empirical proof of Godot's `has_<kind>` inheritance behavior. Run via `<godot> --headless --path . --script .planning/.../helpers/_phase5_diag_inftext.gd`.

## Tasks executed

| Task | Name | Commit | Files |
| ---- | ---- | ------ | ----- |
| 1 RED | Add text-panels stage + 4 strict groups | `8dde92a` | _phase5_verify*.gd, _phase5_diag_inftext.gd, .gitignore |
| 1 GREEN | Kicker variation + InfoText size-slot BL-02 fix | `d2f4984` | addons/neocade_theme/neocade_theme.gd |
| 2 GREEN | Label/RTL variation chrome — color recipes | `ae67472` | addons/neocade_theme/neocade_theme.gd |
| 3 GREEN | Panel + PanelContainer + CardPanel + HeroPanel chrome | `41e5adb` | addons/neocade_theme/neocade_theme.gd |

## Verification result

```
$ <godot> --headless --path . --script .../_phase5_verify_headless.gd -- --stage text-panels
PHASE5_VERIFY: stage=text-panels
...
PHASE5_GROUP_OK:assert_kicker_chrome ENFORCED  Kicker variation registered, font/size set, font_color dispatches per kicker_style enum on all 5 directions
PHASE5_GROUP_OK:assert_text_label_variation_chrome ENFORCED  Label variations + InfoText have correct font/font_size/font_color slots
PHASE5_GROUP_OK:assert_panel_variation_chrome ENFORCED  CardPanel + HeroPanel panel styleboxes match per-direction shape.{card,hero}_radius on all 5 directions; Panel/PanelContainer baselines preserved
----- PHASE5_VERIFY summary -----
  stage:          text-panels
  groups OK:      23 / 23
  groups PENDING: 2  ["assert_codeedit_gutter_slots", "assert_spinbox_icons"]
  failures:       0
PHASE5_VERIFY OK (stage=text-panels)
```

The 2 PENDING groups (`assert_codeedit_gutter_slots`, `assert_spinbox_icons`) are owned by Plans 05-05 / 05-06 and correctly remain TOOLING-mode in this stage.

**Carry-forward gate:** `--stage buttons` (Wave 3) re-run post-Plan-05-04: 23/23 OK, 0 failures. The buttons-stage strict list still passes, proving Wave 3's BaseButton-family + variation chrome assertions are not regressed.

## Requirements addressed

- **TYPEVAR-02** ✓ — HeaderLarge / HeaderMedium / HeaderSmall / Caption / CodeLabel / Kicker (6 Label-typed variations registered + per-variation font + font_size + font_color).
- **TYPEVAR-03** ✓ — InfoText (RichTextLabel variation) with `normal_font` / `normal_font_size` (D-16 BL-02) + default_color + selection_color + font_selected_color.
- **TYPEVAR-04** ✓ — CardPanel + HeroPanel (PanelContainer-typed) with per-direction radius / alpha / raised lift; PanelContainer base class also wired (Rule 2 add).
- **TYPEVAR-05** ✓ — InfoText size slot fixed (closes BL-02 follow-through; Phase 4 only fixed the font half).
- **TYPEVAR-06** ✓ — Kicker registered as the 15th type variation (D-09 / D-10 verifier count assertion).
- **COV-01** ⊙ — partial: Label and RichTextLabel base types remain themed via Phase 4 baselines; Plan 05-04 adds variations on top.
- **COV-03** ⊙ — partial: text/label coverage delivered for v1 (header / caption / code / kicker / info-text variations all themed across 5 directions).
- **COV-07** ⊙ — partial: Panel + PanelContainer + CardPanel + HeroPanel chrome contributes; Plan 05-07 closes the full panel-family round-trip (Window + AcceptDialog + ConfirmationDialog dialog scaffolding stays in scope for that plan).
- **COV-09** — Phase 5 typography contract: `Kicker` font is body-weight Inter Variable Roman (D-17 / FONT-04 stricken / FONT-09 b); consumer can override the `font` slot via Theme Editor for a mono CodeLabel.

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 - Bug] Verifier `has_<kind>` walks inheritance and reports built-in Control class slot signatures**

- **Found during:** Task 1 GREEN (when Kicker had been added but verifier still claimed `Kicker.font` was missing on some intermediate diagnostic).
- **Issue:** Godot 4.6's `Theme.has_font(slot, type_or_variation)`, `has_font_size(...)`, `has_color(...)`, and `has_stylebox(...)` walk the type-variation inheritance chain AND report any slot that exists on the underlying Control class signature — even when `set_*()` was never called. Example: `theme.has_font_size("font_size", "InfoText")` returns `true` because RichTextLabel's class signature exposes a `font_size` slot, even when our generator only authored `normal_font_size`. This silently masks "wrong slot still authored" regressions like the original BL-02 bug.
- **Fix:** Switched all 5 affected verifier groups from `has_<kind>` to `get_<kind>_list(type)` and a `.find(slot) != -1` test. `get_<kind>_list` returns ONLY slots the generator authored (verified empirically in `helpers/_phase5_diag_inftext.gd` — when `font_size` is omitted, it disappears from the list; when added, it reappears).
- **Files modified:** `.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify_headless.gd`, `.../helpers/_phase5_verify.gd`, `.../helpers/_phase5_diag_inftext.gd` (new diagnostic).
- **Commit:** Verifier fix landed as part of Task 1 RED (`8dde92a`) up front, since the previous Wave 4 executor's dangling work proved this would be necessary.

**2. [Rule 2 - Missing critical functionality] PanelContainer base class missing from BINDING_TABLE**

- **Found during:** Task 3.
- **Issue:** Phase 4's BINDING_TABLE had a `Panel` row (the bare-class) but no `PanelContainer` row. Both `CardPanel` and `HeroPanel` extend PanelContainer per D-09/§8.5. Without an explicit row, the base container would not flow per-direction `shape.surface_alpha_panels` or `shape.raised_lifts.panel` — variations would render correctly but `PanelContainer`-typed nodes (which the Theme Editor showcase scenes use) would render with the flat @export `corner_radius` baseline.
- **Fix:** Added `PanelContainer` row (#51) with `panel` stylebox using `surface_panel` + `shape.surface_alpha_panels` + `shape.raised_lifts.panel`. Verifier `assert_panel_variation_chrome` was authored to check both `Panel` AND `PanelContainer` so the deviation doesn't go un-tested on subsequent regenerates.
- **Files modified:** `addons/neocade_theme/neocade_theme.gd`.
- **Commit:** `41e5adb` (Task 3 GREEN).

### Authentication / human-action gates

None — fully autonomous execution.

## Reference: previous Wave 4 executor's dangling work

Useful research artifacts (not landed; preserved as dangling commits `7496ec7..fd4b266`):

- `7496ec7` — Task 1 RED scaffolding (verifier additions). The `--stage text-panels` definition + 4 new assertion groups carried forward verbatim into commit `8dde92a` here.
- `6f020a6` — Task 1 GREEN. Discovered the `has_<kind>` Rule 1 bug; the diagnostic file `_phase5_diag_inftext.gd` was reproduced verbatim, and the `get_*_list` switch is incorporated into the new verifier groups up front (no second-pass fix required).
- `b70efff` — Task 2 GREEN BINDING_TABLE color rows. Recipe shapes carried forward identically.
- `22ef94e` — Task 3 GREEN BINDING_TABLE panel rows. Three rows (PanelContainer / CardPanel / HeroPanel) carried forward identically.
- `fd4b266` — previous SUMMARY (template + tags + decisions list informed this SUMMARY's structure).

The dangling commits were on a worktree branch based at `e0de3bd` (pre-Wave 3) instead of current main `f39ebcf` (post-Wave 3). Sequential mode landed identical content cleanly on top of Wave 3.

## Known Stubs

None. All 7 text/label/RTL variations + 3 panel variations have authored chrome verified across all 5 approved directions. The 2 PENDING groups (`assert_codeedit_gutter_slots`, `assert_spinbox_icons`) are explicitly **out of Plan 05-04 scope** and remain TOOLING-mode in this stage; Plans 05-05 and 05-06 own their resolution.

## Self-Check: PASSED

- **Created files exist:**
  - FOUND: `.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_diag_inftext.gd`
  - FOUND: `.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/05-04-SUMMARY.md` (this file, will exist post-write)
- **Commits exist:**
  - FOUND: `8dde92a` (Task 1 RED)
  - FOUND: `d2f4984` (Task 1 GREEN — Kicker + InfoText fix)
  - FOUND: `ae67472` (Task 2 GREEN — Label/RTL color recipes)
  - FOUND: `41e5adb` (Task 3 GREEN — Panel/PanelContainer/CardPanel/HeroPanel)
- **Verifier gates:**
  - text-panels stage: 23/23 OK, 0 failures (PASS)
  - buttons stage carry-forward: 23/23 OK, 0 failures (PASS — Wave 3 not regressed)
- **Out-of-scope writes:** none. STATE.md, ROADMAP.md, addon `*_neocade_theme.tres` files, and `showcase/showcase.tscn` were not modified.

## TDD Gate Compliance

This plan's frontmatter `type: execute` (not `tdd`), but the individual tasks have `tdd="true"`. Per-task gate sequence verified:

- **Task 1:** `8dde92a` (test) → `d2f4984` (feat) — RED-then-GREEN ✓.
- **Task 2:** Test scaffolding shipped in Task 1 RED (`8dde92a` includes `assert_text_label_variation_chrome`) → `ae67472` (feat) — GREEN proves the strict assertions flip from FAIL to ENFORCED ✓.
- **Task 3:** Test scaffolding shipped in Task 1 RED (`assert_panel_variation_chrome`) → `41e5adb` (feat) — GREEN closes the last failing strict assertion ✓.

REFACTOR phase: not needed. The new BINDING_TABLE rows + recipe lookups land cleanly through the existing Plan 05-02 `_resolve_recipe` engine without requiring helper extraction or refactor.
