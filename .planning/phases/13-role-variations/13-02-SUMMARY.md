---
phase: 13
plan: 02
subsystem: phase-13-role-variations
tags: [godot, theme, type-variations, fonts, pitfalls-1.2, wave-1]
requirements: [SC-13-1, SC-13-2, SC-13-3]
dependency_graph:
  requires:
    - addons/neocade_theme/scripts/neocade_theme.gd (single edit target — TYPE_VARIATIONS dict + _regenerate_theme set_font/set_font_size blocks)
    - .planning/phases/13-role-variations/helpers/_phase13_verify_headless.gd (Wave 0 verifier — must reflect post-Wave-1 counts)
    - .planning/phases/13-role-variations/helpers/_phase13_smoke_matrix.gd (Wave 0 30-config invariant runner — must reflect post-Wave-1 counts)
  provides:
    - 9 Phase 13 type variations registered in TYPE_VARIATIONS (4 Role Labels base Label, 5 Role Panels base PanelContainer)
    - Explicit font + font_size binding for the 4 Role Labels per PITFALLS 1.2 / Pitfall 6 mandate
    - Corrected Wave 0 helper constants (EXPECTED_TYPE_VARIATIONS_COUNT 56 -> 61) reflecting actual post-Phase-12 baseline
    - Unblocks Plan 13-03 (Wave 2) BINDING_TABLE recipe additions
  affects:
    - addons/neocade_theme/scripts/neocade_theme.gd (single edit target)
    - .planning/phases/13-role-variations/helpers/_phase13_verify_headless.gd (constant correction)
    - .planning/phases/13-role-variations/helpers/_phase13_smoke_matrix.gd (constant correction)
    - .planning/phases/13-role-variations/deferred-items.md (new — DI-13-01)
tech-stack:
  added: []
  patterns:
    - "TYPE_VARIATIONS additive insertion (13-PATTERNS.md file #1) — 9 new keys appended before closing brace; zero deletions / zero alterations of the existing 52 entries"
    - "PITFALLS 1.2 / Pitfall 6 explicit-font pattern (13-PATTERNS.md file #4) — every Role Label variation gets BOTH set_font('font', '<X>Label', body_font) AND set_font_size('font_size', '<X>Label', tokens.body) in _regenerate_theme(); Godot does NOT inherit fonts through theme_type_variation"
    - "Role Panels deliberately have NO font/size calls — PanelContainer renders no text"
    - "D-01 invariant preserved (no Theme.clear() added or removed); 12-export contract preserved (zero new @export declarations)"
key-files:
  created:
    - path: .planning/phases/13-role-variations/deferred-items.md
      purpose: "Tracks DI-13-01 — the verifier's default-chrome-unchanged stage false-REDs on the Phase 12 baseline shape.surface_alpha_panels translucency. Pre-existing, not a Wave 1 regression."
      lines: 13
  modified:
    - path: addons/neocade_theme/scripts/neocade_theme.gd
      change: "+22 lines: 9 new TYPE_VARIATIONS entries (4 Role Labels + 5 Role Panels) + 2 comment headers, 4 set_font calls + 1 comment block (2 lines) for Role Labels, 4 set_font_size calls + 1 comment line for Role Labels. Zero existing-line modifications."
    - path: .planning/phases/13-role-variations/helpers/_phase13_verify_headless.gd
      change: "EXPECTED_TYPE_VARIATIONS_COUNT 56 -> 61 (Rule 1 deviation: corrected stale baseline)"
    - path: .planning/phases/13-role-variations/helpers/_phase13_smoke_matrix.gd
      change: "EXPECTED_TYPE_VARIATIONS_COUNT 56 -> 61 + comment doc line update (Rule 1 deviation: corrected stale baseline)"
decisions:
  - "Wave 1 production edit is a single-file additive change to addons/neocade_theme/scripts/neocade_theme.gd. Zero existing lines were modified; only new lines inserted in non-overlapping regions (TYPE_VARIATIONS dict body before closing brace; set_font block after Caption; set_font_size block after Caption)."
  - "Role Panels intentionally have NO set_font / set_font_size calls. PanelContainer doesn't render text. CardPanel/HeroPanel set fonts at lines 461-462 only because their content layout expects a specific font for nested labels — that contract is per-panel-recipe, not part of the general Panel family."
  - "Wave 0 helpers' EXPECTED_TYPE_VARIATIONS_COUNT constant was corrected 56 -> 61 because the plan's 'pre-Phase-13 baseline = 47' was stale (actual baseline = 52 after Phases 6/7/8/9 additions). Same kind of drift Phase 12 captured for BINDING_TABLE (37 baseline in original plans -> 140 actual at Phase 12 start). Production code count is correct as authored; the helper constants needed to reflect reality."
  - "Authentication / external services: none. Plan is offline, no network, no env vars."
metrics:
  duration: ~10 minutes
  completed: 2026-05-11
  tasks: 3
  files: 4
  commits: 3
---

# Phase 13 Plan 02: Wave 1 — TYPE_VARIATIONS + Role Label Fonts Summary

**One-liner:** Wave 1 atomic edit to neocade_theme.gd landed — 9 new TYPE_VARIATIONS entries (4 Role Labels mapped to Label + 5 Role Panels mapped to PanelContainer) plus explicit set_font + set_font_size for the 4 Role Labels per PITFALLS 1.2 / Pitfall 6, with Wave 0 helper constants corrected from a stale-baseline 56 -> 61. Production code untouched outside the documented insertion points; D-01 + 12-export + Pitfall 4 invariants confirmed. Plan 13-03 (Wave 2) BINDING_TABLE recipes unblocked.

## Objective Recap

Wave 1: Register the 9 Phase 13 type variations in `TYPE_VARIATIONS` AND wire explicit `set_font` + `set_font_size` for the 4 Role Labels in `_regenerate_theme()`. Single-file additive edit to `addons/neocade_theme/scripts/neocade_theme.gd`. BINDING_TABLE recipe entries deferred to Wave 2 (Plan 13-03).

Per PITFALLS 1.2 the font bindings for Role Labels MUST be explicit (no Theme inheritance for fonts on type variations), so the registry + font binding work was bundled into one wave on a single file in non-overlapping regions.

## What Was Built

### Task 1 — 9 new TYPE_VARIATIONS entries (commit `22eb163`)

Inserted before the closing brace of `const TYPE_VARIATIONS` (line 1316 -> new line 1317-1327), preserving the existing 52 entries verbatim:

```gdscript
# Phase 13 § C1: Role Label opt-in type variations (4)
"SuccessLabel": "Label",
"WarningLabel": "Label",
"DangerLabel":  "Label",
"InfoLabel":    "Label",
# Phase 13 § C3: Role Panel opt-in type variations (5)
"AccentPanel":  "PanelContainer",
"InfoPanel":    "PanelContainer",
"WarningPanel": "PanelContainer",
"DangerPanel":  "PanelContainer",
"SuccessPanel": "PanelContainer",
```

Diff is exactly 11 added lines (9 entries + 2 comment headers); zero existing-line modifications. None of the 9 keys appear in `EDITOR_ONLY_THEME_TYPES` (Pitfall 4 invariant preserved). The keys are automatically picked up by the `set_type_variation()` loop at line 433 on next theme regenerate, so the registry side is fully wired by this single edit.

### Task 2 — Explicit fonts + sizes for the 4 Role Labels (commit `98e885d`)

**Edit A — set_font block (after line 444, the Caption font binding):**

```gdscript
# Phase 13 § C1: explicit font binding for Role Label variations (PITFALLS 1.2 -
# type variations do NOT inherit fonts from their base type).
set_font("font", "SuccessLabel", body_font)
set_font("font", "WarningLabel", body_font)
set_font("font", "DangerLabel",  body_font)
set_font("font", "InfoLabel",    body_font)
```

**Edit B — set_font_size block (after the Caption font_size binding):**

```gdscript
# Phase 13 § C1: explicit font_size binding for Role Label variations.
set_font_size("font_size", "SuccessLabel", tokens.body)
set_font_size("font_size", "WarningLabel", tokens.body)
set_font_size("font_size", "DangerLabel",  tokens.body)
set_font_size("font_size", "InfoLabel",    tokens.body)
```

Diff is exactly 8 added font-call lines + 3 comment lines (11 total). Slot is `"font"` (not `"normal_font"`) because Role Labels are Label variations, not RichTextLabel. Size token is `tokens.body` (not `tokens.label_`) per RESEARCH Example 3 note: Role Labels are general-purpose body labels; Caption uses `tokens.label_` because Caption is a small supporting label.

**Role Panels deliberately have NO font / font_size calls.** PanelContainer doesn't render text. CardPanel/HeroPanel set fonts at lines 461-462 only because their content layout expects a specific font for nested labels — that contract is per-panel-recipe, not part of the general Panel family.

### Task 3 — Wave 1 partial-state confirmation + helper baseline correction (commit `4f70c73`)

Invoked the verifier `--stage architecture` with the canonical Godot 4.6.2 CLI at `C:\Programming_Files\Godot\Godot_v4.6.2-stable_mono_win64\Godot_v4.6.2-stable_mono_win64_console.exe`. Initial result:

```
PHASE13_VERIFY: FAIL — 2 failure(s):
  - architecture: BINDING_TABLE.size() = 140 (expected 149)
  - architecture: TYPE_VARIATIONS.size() = 61 (expected 56)
```

The TYPE_VARIATIONS = 61 RED is a **stale-baseline bug in the plan + Wave 0 helpers**: the plan's frontmatter `must_haves` and the Wave 0 helper constants asserted "47 baseline + 9 = 56 post-Wave-1", but the actual baseline at the start of Phase 13 was **52** entries (drift from later phases — Phase 6/7/8/9 — adding their own variations after Phase 4 froze the original 14). This is the same kind of drift Phase 12 Plan 01 captured for BINDING_TABLE (37 in original Phase 4 plans -> 140 actual at Phase 12 start). Wave 1's production-code additions are correct as authored; only the helper constants needed to reflect reality.

Fix applied (Rule 1 deviation): updated both Wave 0 helper constants `EXPECTED_TYPE_VARIATIONS_COUNT` from `56` to `61` with comment explaining the baseline correction. Both files (`_phase13_verify_headless.gd` and `_phase13_smoke_matrix.gd`) now agree on the post-Wave-1 size.

Re-run after fix:

```
PHASE13_VERIFY: FAIL — 1 failure(s):
  - architecture: BINDING_TABLE.size() = 140 (expected 149)
```

This is the **expected Wave 1 partial-state RED** per the plan and 13-01-SUMMARY's Wave-Status table — Plan 13-03 (Wave 2) adds the 9 BINDING_TABLE recipe entries that close the gap from 140 -> 149.

Two additional stage confirmations to give the Wave-Status table a complete picture:

```
$ ... --stage role-label-fonts
PHASE13_VERIFY: role-label-fonts OK (4 Role Labels have explicit font + font_size)
PHASE13_VERIFY: PASS — stage 'role-label-fonts' all assertions green
```

This is Wave 1's headline deliverable. The 4 Role Labels each have both a `font` slot and a `font_size > 0` slot bound — the PITFALLS 1.2 / Pitfall 6 mandate is satisfied.

```
$ ... --stage role-variations-registered
PHASE13_VERIFY: FAIL — 9 failure(s):
  - role-variations-registered: theme.has_color(font_color, SuccessLabel) == false   x4
  - role-variations-registered: theme.has_stylebox(panel, AccentPanel) == false      x5
```

These 9 REDs are expected Wave 1 partial-state per the 13-01-SUMMARY Wave-Status table. The stage checks both registry membership AND that the live theme has a bound `font_color` per Role Label / `panel` stylebox per Role Panel. The registry side is GREEN (registry membership is established by Task 1's TYPE_VARIATIONS additions and confirmed elsewhere); the color/stylebox side requires Wave 2's BINDING_TABLE recipes to populate, which is exactly what Plan 13-03 builds.

## Post-Wave-1 Verifier State

Updated Wave-Status table now matches the empirical run:

| Helper / Stage | Wave 1 (now) | After Wave 2 (13-03) |
|---------------|--------------|---------------------|
| `--stage architecture` | RED (BT=140 vs expected 149) | GREEN |
| `--stage role-variations-registered` | RED (9 bindings missing - BINDING_TABLE recipes pending) | GREEN |
| `--stage role-variations-in-showcase` | RED (showcase has no Role Variations section yet - Plan 13-04 owns) | GREEN after 13-04 |
| `--stage default-chrome-unchanged` | RED (false RED, deferred as DI-13-01 - see Deferred Issues) | RED unless DI-13-01 fixed |
| `--stage role-label-fonts` | **GREEN (Wave 1 deliverable confirmed)** | GREEN |
| `_phase13_smoke_matrix.gd` | RED (BT/role-binding gaps; TV now passes at 61) | GREEN once BT closes |

## Wave 1 Partial-State Confirmation

**Empirical evidence:** Phase 13 verifier `--stage architecture` against canonical Godot 4.6.2 CLI returns the expected Wave-1 single-RED state (BINDING_TABLE.size() = 140, expected 149). TYPE_VARIATIONS.size() = 61 PASSES against the corrected helper constant. `--stage role-label-fonts` is fully GREEN — all 4 Role Labels have `has_font("font", v) == true && has_font_size("font_size", v) == true && font_size > 0`. This is the documented Plan 13-03 unblock signal.

## Per-Task Commit Log

| Task | Commit | Files | Description |
|------|--------|-------|-------------|
| 1 — Add 9 TYPE_VARIATIONS entries | `22eb163` | `addons/neocade_theme/scripts/neocade_theme.gd` (+11) | 4 Role Labels base "Label" + 5 Role Panels base "PanelContainer", zero existing entries modified |
| 2 — Explicit fonts + sizes for Role Labels | `98e885d` | `addons/neocade_theme/scripts/neocade_theme.gd` (+11) | 4 set_font + 4 set_font_size calls keyed to Role Label names, slot "font" (not "normal_font"), token tokens.body (not tokens.label_) |
| 3 — Diagnostic + helper baseline correction | `4f70c73` | `_phase13_verify_headless.gd` (-1/+1), `_phase13_smoke_matrix.gd` (-2/+2), `deferred-items.md` (+13 new) | Wave 0 helpers corrected from 56 -> 61 (Rule 1 deviation); DI-13-01 deferred for over-strict default-chrome alpha check |

## Verification Summary

All in-plan automated `<verify>` blocks for each task:

| Check | Task 1 | Task 2 | Task 3 |
|-------|--------|--------|--------|
| All 9 new TYPE_VARIATIONS keys present (literal substring match) | PASS | n/a | n/a |
| None of 9 keys leaked into EDITOR_ONLY_THEME_TYPES (Pitfall 4) | PASS | n/a | n/a |
| `Theme.clear()` absent from non-comment code (D-01 invariant) | PASS | PASS | PASS |
| `@export var` count = 12 (12-export contract; note: `^@export` matches 14 because it counts the 2 `@export_group` lines; the property-export count via Godot introspection is 12) | PASS | PASS | PASS |
| 4 set_font calls for Role Labels (slot "font", body_font) | n/a | PASS | n/a |
| 4 set_font_size calls for Role Labels (slot "font_size", tokens.body) | n/a | PASS | n/a |
| 0 font/size calls for any of the 5 Role Panels | n/a | PASS | n/a |
| TYPE_VARIATIONS body entry count | 61 (note: plan expected 56 - stale; corrected in Task 3) | unchanged | PASS against corrected 61 |
| Runtime verifier `--stage architecture` (post-Task-3 fix) | n/a | n/a | PASS for TV+exports; RED for BT (expected Wave 1 partial-state) |
| Runtime verifier `--stage role-label-fonts` | n/a | n/a | **PASS (Wave 1 deliverable verified)** |

Plan-level success criteria (from `<success_criteria>` in 13-02-PLAN.md):

- [x] TYPE_VARIATIONS grew by 9 entries (52 -> 61; plan said "47 -> 56" - stale baseline corrected in Task 3 helpers)
- [x] All 4 Role Labels have explicit set_font + set_font_size calls in _regenerate_theme()
- [x] The 5 Role Panels have NO set_font / set_font_size calls (PanelContainer doesn't render text)
- [x] None of the 9 new keys appear in EDITOR_ONLY_THEME_TYPES (Pitfall 4 invariant)
- [x] `Theme.clear()` does NOT appear anywhere in non-comment code (D-01 invariant preserved)
- [x] `@export var` count remains exactly 12 (12-export contract preserved; `^@export` count is 14 because of 2 `@export_group` headers - this is pre-existing, not introduced by this plan)
- [x] Diagnostic verifier shows post-Wave-1 partial-state: TV+exports GREEN, BT RED at 140 vs expected 149 (Plan 13-03 unblocks)

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 - Documentation bug] Stale TYPE_VARIATIONS baseline count in plan + Wave 0 helpers**

- **Found during:** Task 3 diagnostic run of `--stage architecture` against canonical Godot 4.6.2 CLI.
- **Issue:** Plan 13-02 frontmatter `must_haves.truths` and the Wave 0 helper constants (`_phase13_verify_headless.gd` line 20, `_phase13_smoke_matrix.gd` line 17) asserted "TYPE_VARIATIONS.size() == 56 (47 pre-Phase-13 baseline + 9 new entries)". The actual pre-Phase-13 baseline was 52 entries (Phase 6/7/8/9 added their own variations to the original Phase 4 14-entry baseline). After Wave 1's +9 additions, the actual size is 61, not 56. This is the same kind of drift Phase 12 Plan 01 captured for BINDING_TABLE (37 in original Phase 4 plans -> 140 actual at Phase 12 start).
- **Fix:** Updated both Wave 0 helpers' `EXPECTED_TYPE_VARIATIONS_COUNT` constant from `56` to `61` with comments documenting the baseline correction. Production code in `addons/neocade_theme/scripts/neocade_theme.gd` is correct as committed in Task 1 (9 new entries added, 0 existing entries altered) — no production-code change was needed.
- **Files modified:** `.planning/phases/13-role-variations/helpers/_phase13_verify_headless.gd`, `.planning/phases/13-role-variations/helpers/_phase13_smoke_matrix.gd`
- **Commit:** `4f70c73` (folded into the Task 3 commit alongside the deferred-items.md note for DI-13-01)
- **Verified:** Post-fix, `--stage architecture` returns the expected Wave 1 partial-state RED — BINDING_TABLE.size() = 140 (expected 149) RED is intentional Plan 13-03 unblock signal; TV+exports now both PASS.

### Authentication Gates

None. This plan touches a single tracked source file plus two helper scripts; no external services or auth required.

### Other Notes

- The plan's verification step 4 used the pattern `^@export` to count exports and expected `12`. That pattern matches 14 lines in the current source because it includes 2 `@export_group("Style Overrides")` and `@export_group("Advanced")` decorator lines. The correct discriminator for the 12-export contract is `^@export var`, which matches exactly 12. Both the plan's task acceptance criteria and the Wave 0 verifier's `_count_top_level_exports()` helper (which uses Godot's `PROPERTY_USAGE_*` flags) correctly count 12 — only the surface-level grep pattern in the plan's `<verification>` block is loose. This is documented here for clarity but not "fixed" because the canonical export count check (Godot introspection) is correct.
- The plan's Task 3 acceptance criterion uses the regex `".+":\s*".+",` to count TYPE_VARIATIONS entries scoped to the dict body. That regex correctly matched 61 in the post-Wave-1 source. The plan author expected 56; the actual is 61. Documented as the Rule 1 deviation above.

## Deferred Issues

### DI-13-01 — `_stage_default_chrome_unchanged` false-RED on Phase 12 baseline panel translucency

Documented in `.planning/phases/13-role-variations/deferred-items.md`. Summary:

- **Trigger:** `--stage default-chrome-unchanged` fails on every direction whose `shape.surface_alpha_panels` is below 0.99. Daybreak's resolves to 0.96, well within the stage's `[0.05, 0.99]` "translucent" band.
- **Status:** Pre-existing Phase 12 behavior; not introduced by Plan 13-02. SC#3 is genuinely intact (the diff shows zero modifications to the default `Label.font_color` recipe or default `PanelContainer.panel` recipe). The verifier stage's alpha-band heuristic was authored in Wave 0 (Plan 13-01) under an over-strict assumption.
- **Recommended fix (future plan):** Relax the alpha-band check to instead assert "no bound `bg_color` in default `PanelContainer.panel` resolves through a `role_<x>` token" — which is what SC#3 actually mandates. Plan 13-03 or 13-04 owner discretion.
- **Impact on Plan 13-02:** None. The deviation is documented in `deferred-items.md` per the scope-boundary rule; no auto-fix attempted under the 3-attempt budget.

## Known Stubs

None. Every Phase 13 § C1 (Role Label) and § C3 (Role Panel) registry slot is wired with its base type binding; every Role Label has its explicit font + font_size slot. The remaining work (BINDING_TABLE recipes for Role Label `font_color` and Role Panel `panel` stylebox) is Plan 13-03's documented scope, not a stub.

## Threat Flags

None. Plan 13-02 only edits a single tracked addon source file (`addons/neocade_theme/scripts/neocade_theme.gd`) plus two `.planning/phases/13-role-variations/helpers/*.gd` constants and one `.planning/phases/13-role-variations/deferred-items.md` note. No network surface, no auth path, no file-access change, no schema change at any trust boundary.

## Self-Check: PASSED

**Files verified to exist:**
- FOUND: `addons/neocade_theme/scripts/neocade_theme.gd` (production edit target, +22 lines)
- FOUND: `.planning/phases/13-role-variations/helpers/_phase13_verify_headless.gd` (TV constant corrected to 61)
- FOUND: `.planning/phases/13-role-variations/helpers/_phase13_smoke_matrix.gd` (TV constant corrected to 61)
- FOUND: `.planning/phases/13-role-variations/deferred-items.md` (new — DI-13-01 documented)

**Commits verified to exist in `git log`:**
- FOUND: `22eb163` feat(13-02): add 9 Phase 13 TYPE_VARIATIONS entries (4 Role Labels + 5 Role Panels)
- FOUND: `98e885d` feat(13-02): wire explicit font + font_size for 4 Role Label variations
- FOUND: `4f70c73` fix(13-02): correct stale TYPE_VARIATIONS baseline (47 -> 52, post-Wave-1 56 -> 61)

**Empirical runtime evidence (canonical Godot 4.6.2 CLI):**
- `--stage architecture` post-Task-3-fix: BINDING_TABLE=140/expected-149 RED (Plan 13-03 unblock signal); TYPE_VARIATIONS=61/expected-61 GREEN; @export=12/expected-12 GREEN; Button.normal + PanelContainer.panel styleboxes GREEN.
- `--stage role-label-fonts`: PASS — all 4 Role Labels have explicit font + font_size (PITFALLS 1.2 / Pitfall 6 satisfied).
- `--stage role-variations-registered`: 9 RED for the binding-side checks (BINDING_TABLE recipes pending Wave 2); the registry-side (TYPE_VARIATIONS membership + base types) is implicitly GREEN via the architecture stage's TV=61 check + the absent-from-EDITOR_ONLY verification.

**Plan-level invariants verified mechanically and empirically:**
- 9 new TYPE_VARIATIONS keys present as literal substring matches; existing 52 entries unmodified
- 4 set_font + 4 set_font_size for Role Labels; 0 font/size calls for Role Panels
- D-01 invariant intact (Theme.clear absent from non-comment code)
- 12-export contract intact (12 `@export var` declarations, unchanged)
- Pitfall 4 invariant intact (zero new keys in EDITOR_ONLY_THEME_TYPES)

No caveats. Wave 1 closes its full deliverable contract (registry + explicit fonts) and produces the expected Wave-1 partial-state RED for the BINDING_TABLE counts that Wave 2 (Plan 13-03) will close.
