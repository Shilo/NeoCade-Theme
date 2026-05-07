---
phase: 7
review_cycle: 2
reviewers:
  - opencode
reviewed_at: 2026-05-07T10:24:58Z
plans_reviewed:
  - 07-01-PLAN.md
  - 07-02-PLAN.md
  - 07-03-PLAN.md
  - 07-04-PLAN.md
  - 07-05-PLAN.md
prior_cycle_highs_checked:
  - Direct set_font/set_font_size instructions outside BINDING_TABLE for Phase 7 font slots.
  - Full official GraphNode and GraphFrame slot enumeration in Plan 07-05.
current_high_count: 0
---

# Cross-AI Plan Review - Phase 7, Cycle 2

## OpenCode Review

# Cross-AI Plan Review - Phase 7, Cycle 2 (Replan)

## 1. Summary

The five replanned Phase 7 plans form a coherent wave structure that mirrors Phase 6's proven pattern: slot-freeze foundation first, risk-cluster implementation waves second through fourth, and a final full-verification-plus-ResourceSaver wave last. The plans are grounded in concrete Godot 4.6.2 local probe evidence, respect every architecture invariant (one `.gd`, data-only `.tres`, no `Theme.clear`, no export expansion, no root fallback), and directly address all COV-06/COV-08/cumulative COV-01/07/09 requirements. Both cycle-1 HIGH concerns are fully resolved through explicit language in the replanned files. The primary remaining risk is execution-pace from the icon-authoring volume (46 SVGs across three waves), which the staged verifier catches reliably.

## 2. Cycle-1 HIGH Resolution Check

### HIGH #1: Font/font_size wiring outside BINDING_TABLE

**Verdict: FULLY RESOLVED**

| Plan | Evidence |
|------|----------|
| 07-02 interfaces | Explicit "Font wiring rule" paragraph: all Phase 7 `font` and `font_size` slots must be written with direct `set_font()`/`set_font_size()` calls in `_regenerate_theme()` after the BINDING_TABLE walk. Do not add `"font"` or `"font_size"` recipe data-types. |
| 07-02 Task 2 action | Window `title_font`/`title_font_size`, TooltipLabel `font`/`font_size`, MenuBar `font`/`font_size`, PopupMenu fonts - all explicitly called out as direct `set_font()`/`set_font_size()` calls. |
| 07-02 Task 3 action | PopupMenu `font`/`font_separator`/`font_size`/`font_separator_size` must be direct `set_font()`/`set_font_size()` calls. |
| 07-04 interfaces | Font wiring rule repeated verbatim for ColorPickerButton `font`/`font_size`. |
| 07-04 Task 3 action | Direct `set_font()`/`set_font_size()` calls required for `font` and `font_size`. |

No plan uses `"font"` or `"font_size"` as a BINDING_TABLE data-type key. The instruction is repeated at both the interface-spec level and in every task action block where font slots exist.

### HIGH #2: GraphNode and GraphFrame slot enumeration in Plan 07-05

**Verdict: FULLY RESOLVED**

| Plan | Evidence |
|------|----------|
| 07-05 interfaces | GraphNode: 7 styleboxes (`panel`, `panel_focus`, `panel_selected`, `slot`, `slot_selected`, `titlebar`, `titlebar_selected`), 1 color (`resizer_color`), 2 constants (`port_h_offset`, `separation`), 2 icons (`port`, `resizer`). GraphFrame: 4 styleboxes (`panel`, `panel_selected`, `titlebar`, `titlebar_selected`), 1 color (`resizer_color`), 1 icon (`resizer`). |
| 07-05 Task 2 action | Verbatim enumeration for GraphNode: styleboxes `panel`, `panel_focus`, `panel_selected`, `slot`, `slot_selected`, `titlebar`, `titlebar_selected`; color `resizer_color`; constants `port_h_offset`, `separation`; icons `port`, `resizer`. Same style for GraphFrame. |
| 07-05 Task 2 tests | Test 2 explicitly requires all official styleboxes, color, constants, and icons populated for GraphNode; Test 3 does the same for GraphFrame. |

Every official GraphNode/GraphFrame slot is enumerated both in the formal interface section and in the executor-facing action block. No slot can be missed.

## 3. Strengths

- **Font-wiring rule is hardened** - the explicit prohibition against `"font"`/`"font_size"` BINDING_TABLE keys appears in every plan that touches font slots (07-02, 07-04), not just once.
- **Verifier stages are incremental and fail-fast** - `slot-freeze` -> `popups-menus` -> `filedialog` -> `colorpicker` -> `graph` -> `full`. The `full` stage fails on any pending group, preventing premature "done" claims.
- **Slot-freeze discipline** - Plan 07-01 Task 1 uses only the local 4.6.2 probe log as the slot source; stale names (`icon_normal_color`, guessed `file_up`) are explicitly forbidden.
- **Icon contract consistently applied** - all 46 icons across Plans 07-02, 07-03, 07-04, and 07-05 follow the Phase 4/6 contract: `#FFFFFF`, 32x32, Godot `.import` sidecars, no external packs.
- **ResourceSaver deferral** - Plan 07-05 Task 3 runs the ResourceSaver only after all production bindings exist, matching Phase 6's pattern. Explicitly requires copying Phase 6 strip behavior with only name changes.
- **Cycle-1 MEDIUM items all addressed** - FileDialog stale `icon_normal_color` removal (07-03), ColorPickerButton `bg` icon (07-04), `[sub_resource]` strip via Phase 6 pattern copy (07-05), ConfirmationDialog explicit BINDING_TABLE key (07-02), GraphFrame `resizer_color` (07-05 Task 2), TooltipLabel `shadow_offset_x: 0, shadow_offset_y: 0` (07-02 Task 2), PopupMenu `font_separator_outline_color` -> `outline_color` role (07-02 Task 3).

## 4. Current Concerns

### MEDIUM Severity

**M1: Icon-authoring volume strains single-wave execution.** Plans 07-03 (20 FileDialog SVGs), 07-04 (17 ColorPicker SVGs), and 07-05 (9 graph SVGs) total 46 bespoke icon files across three sequential waves. Each wave requires Godot import, `.import` sidecar generation, and `uid://` verification. If any wave has an icon-authoring gap, the downstream wave's verifier failures cascade. This is an execution-pace risk (not a plan-design defect) - the staged verifier catches the gap, but remediation may require re-executing a wave.

**M2: PopupMenu checked/unchecked icon mapping to Phase 4 assets is implicit.** Plan 07-02 Task 3 says "Bind all ten official icon slots" and Test 2 says "Disabled check/radio/unchecked icon variants reuse the base bespoke icons with disabled tinting instead of separate art." The plan does not explicitly state which existing Phase 4 SVGs map to which PopupMenu slot names (e.g., `checkbox_checked.svg` -> PopupMenu `checked`, `radiobutton_checked.svg` -> PopupMenu `radio_checked`). An executor who mis-maps these will break the verifier. The mapping is recoverable from the Phase 4 icon vocabulary, but explicit slot-to-filename pairs would prevent ambiguity.

## 5. Suggestions

- **07-02 Task 3: Add explicit PopupMenu icon mapping table.** List the 10 official PopupMenu icon slot names alongside their target SVG filenames (e.g., `checked` -> `checkbox_checked.svg`, `radio_checked` -> `radiobutton_checked.svg`, `submenu` -> `popup_submenu.svg`). This prevents executor ambiguity without changing any design decision.
- **07-03 Task 1: Consider a `filedialog_clear.svg` reuse note.** If `lineedit_clear.svg` is visually identical, a one-line note ("`clear` may reuse `lineedit_clear.svg` if visually identical") saves time. Currently the plan says "Reuse... only when it is visually and semantically exact" which is correct but could benefit from a concrete example.
- **Confirm verifier carries forward Phase 6's 37-row scorecard.** Plan 07-01 Task 2 says to "Copy/adapt the Phase 6 helper pattern" - adding an explicit action line ("port Phase 6's `_assert_37_row_scorecard()` and its row-name list into the Phase 7 verifier") would guarantee the full-stage check works on the first pass.

## 6. Risk Assessment: **LOW**

**Justification:** The plans have zero architectural risks (no scope creep, no export expansion, no per-direction scripts, no root `.tres` resurrection). Dependency ordering is sound (01->02->03->04->05). Both cycle-1 HIGH concerns are fully resolved with explicit, repeated language in the replanned files. The structural verifier stages are incremental and fail-fast. The only remaining concerns are execution-pace risks (icon volume, implicit icon mapping) that the staged verifier catches reliably - none are plan-design defects. The phase goals will be met; the question is only whether it takes one execution cycle per wave or requires mild remediation within a wave.

## 7. Current HIGH Count: **0**

---

## Consensus Summary

Only the requested OpenCode reviewer was invoked for this cycle, so consensus reflects one external model rather than overlap across multiple reviewers.

### Agreed Strengths

- The two cycle-1 HIGH concerns are fully resolved in the replanned files.
- The Phase 7 wave ordering remains sound and mirrors the successful Phase 6 staged-verification pattern.
- The plans preserve the major architecture invariants: one addon root `.gd`, data-only `.tres`, no `Theme.clear()`, no public export expansion, and no root fallback `.tres`.

### Agreed Concerns

- MEDIUM: Icon authoring volume remains the main execution-pace risk across FileDialog, ColorPicker, and Graph waves.
- MEDIUM: PopupMenu checked/unchecked/radio icon slot-to-file mapping is recoverable but implicit; an explicit table would reduce execution ambiguity.

### Divergent Views

- None. Only OpenCode was requested and invoked in this review cycle.

### Current HIGH Concerns

None.
