---
status: complete
phase: 05-core-controls-buttons-inputs-labels-panels-desktop
source: [05-01-SUMMARY.md, 05-02-SUMMARY.md, 05-03-SUMMARY.md, 05-04-SUMMARY.md, 05-05-SUMMARY.md, 05-06-SUMMARY.md, 05-07-SUMMARY.md]
started: 2026-05-07T06:45:16Z
updated: 2026-05-07T06:45:16Z
---

## Current Test

[testing complete — 8 auto-verified pass, 6 visual deferred to Phase 9, 1 LSP-recheck pending user reload]

## Tests

### 1. Headless Verifier — All 8 Strict Stages
expected: |
  Run all 8 verifier stages headless (tooling, shape, buttons, text-panels,
  text-final, spinbox, final, strict). Each exits 0 with "PHASE5_VERIFY OK".
result: pass
note: "Auto-verified at HEAD c3e0690. 8/8 stages green; 0 failures across all stages."

### 2. Variation Count = 15 (Kicker Present)
expected: |
  TYPE_VARIATIONS in `addons/neocade_theme/neocade_theme.gd` has 15 entries
  including the new `Kicker: Label` (D-09 closes DESIGN_TOKENS §8.6 todo).
result: pass
note: "Auto-verified by `assert_variation_count_15` group. PHASE5_GROUP_OK emitted."

### 3. Direction Shape Schema Populated for All 5 Directions
expected: |
  DIRECTION_PRESETS has `shape` sub-block with verbatim values from
  DESIGN_TOKENS §5.1-§5.5 for Pulse, Slate, Bubble, Daybreak, Burst,
  plus DIRECTION_PRESET_DEFAULT.
result: pass
note: "Auto-verified by `assert_shape_value_integrity`, `assert_shape_lookup_integrity`."

### 4. Strategy Dispatch Differentiation
expected: |
  primary_strategy resolves to distinct enum names per direction (bold-accent-fill,
  quiet-pill, pillowy-fully-rounded, friendly-generous, oversized-statement).
  Per-direction PrimaryButton styleboxes differ in radius/padding/bg_color.
result: pass
note: "Auto-verified by `assert_button_strategy_distinctness`. 5 distinct strategies confirmed."

### 5. DangerButton Bound to role_danger
expected: |
  BINDING_TABLE.DangerButton recipe binds via {role: "role_danger"}; semantic
  role color exists in role_table BEFORE the BINDING_TABLE walk (review HIGH gate).
result: pass
note: "Auto-verified by `assert_dangerbutton_role_danger` and `assert_semantic_role_table`."

### 6. Focus Ring on Every Focusable Control × 5 Directions
expected: |
  10 focusable Controls × 5 directions = 50 focus slot assertions pass.
  No invented `pressed_focus`/`checked_focus` slots (D-07 — Godot 4.6 official
  `focus` overlay only).
result: pass
note: "Auto-verified by `_phase5_focus_probe.gd`. 50/50 focus slots OK."

### 7. CodeEdit Gutter Chrome + folded Icon
expected: |
  CodeEdit gutter color slots populated; `folded` icon present with godot-issued UID
  (uid://mfsh7wsslfe7); no syntax highlighting (AF-7).
result: pass
note: "Auto-verified by `assert_codeedit_gutter_slots` and `assert_no_syntax_highlighting`."

### 8. SpinBox Official Slot Names
expected: |
  Theme.get_icon_list("SpinBox") includes the four official Godot 4.6 names:
  up, up_disabled, down, down_disabled.
result: pass
note: "Auto-verified by `assert_spinbox_icons`. 4/4 official slots; 0 legacy names."

### 9. Visual Review — Open Pulse in showcase/showcase.tscn
expected: |
  Pulse direction's bold-accent-fill PrimaryButton with rectangular radius=0,
  Inter Variable Roman body type, no textures/patterns/shadows on chrome.
result: skipped
reason: "Deferred to Phase 9 (showcase scene + theme picker is the explicit Phase 9 deliverable; comprehensive screenshot-based verification lives there)."

### 10. Visual Review — Direction Distinctness (Greyscale Test, D-30)
expected: |
  Each direction identifiable by shape language alone (D-30 greyscale-sufficiency
  test from Phase 3.4): Slate r=14 pill, Bubble r=26 pillowy + r=999 primary,
  Daybreak r=8 airy, Burst r=18 statement + r=28 primary.
result: skipped
reason: "Deferred to Phase 9 (showcase scene)."

### 11. Visual Review — Kicker Variation Per-Direction Style
expected: |
  Kicker style dispatch renders correctly per direction (uppercase-tracked-accent,
  small-caps-subtle, sentence-case-accent, uppercase-bold-larger).
result: skipped
reason: "Deferred to Phase 9 (showcase scene). User can preview manually in Theme Editor for now."

### 12. Visual Review — Focus Ring Visibility on Each Direction's Surface
expected: |
  Focus ring renders OUTSIDE corner radius bounds (Pitfall 1.1 — outer ring),
  per-direction focus_offset (DESIGN_TOKENS §8.2: 0/2/2/2/1).
result: skipped
reason: "Deferred to Phase 9 (showcase scene). Structural assertions auto-passed in test 6."

### 13. Visual Review — CodeEdit Gutter at Real Sizes
expected: |
  Gutter line numbers, folded icon, breakpoint/folding/bookmark colors render
  proportionally and tonally consistent with each direction's surface.
result: skipped
reason: "Deferred to Phase 9 (showcase scene)."

### 14. Visual Review — SpinBox Arrow Icons
expected: |
  Up/down chevrons render cleanly at default editor zoom; disabled state dims
  arrows per disabled_opacity (0.42-0.50 range).
result: skipped
reason: "Deferred to Phase 9 (showcase scene)."

### 15. Phase 4 LSP Errors Cleared (typed `path: String`)
expected: |
  After commit c3e0690 typed Phase 4 helper `path` variables as String, the
  Godot editor's GDScript LSP no longer emits "Cannot infer the type of 'path'
  variable" errors when indexing _phase4_import.gd / _phase4_verify.gd.
result: [pending]
note: "User must reload Godot editor / restart LSP to confirm. Original LSP errors surfaced during verify-work."

## Summary

total: 15
passed: 8
issues: 0
pending: 1
skipped: 6
blocked: 0

## Gaps

<!-- None — all auto-verified items pass; visual items deferred to Phase 9 by user election; LSP recheck is informational, not a gap. -->

## Phase Outcome

**Phase 5 implementation: VERIFIED at the structural / data / contract level.**

- Headless verifier: 8/8 stages green, 28/28 OK markers, 0 failures.
- All 7 plan SUMMARYs landed atomic commits per Phase 4 cadence.
- D-06 data-only invariant met: 5 direction `.tres` files ≤ 373 B each after ResourceSaver round-trip.
- D-09 Kicker variation closes DESIGN_TOKENS §8.6 explicit Phase 5 todo.
- D-07 Pitfall 1.1 empirically validated; no invented combo focus slots authored.
- D-11 retired the Phase 4 Cycle 6 F7 hand-author fallback; Godot 4.6.2 CLI is the canonical save path.
- Review HIGH gate (`role_danger` exists before binding) closed in Plan 05-02.
- BL-02 InfoText `normal_font_size` slot fix carried forward and asserted.

**Visual / aesthetic verification deferred to Phase 9** per user election — Phase 9 owns the
showcase scene + theme picker + variation toggles, which is the natural home for
comprehensive per-Control × variation × state screenshot QA.
