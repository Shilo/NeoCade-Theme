---
phase: 7
reviewers:
  - opencode
reviewed_at: 2026-05-07T10:15:00Z
plans_reviewed:
  - 07-01-PLAN.md
  - 07-02-PLAN.md
  - 07-03-PLAN.md
  - 07-04-PLAN.md
  - 07-05-PLAN.md
---

# Cross-AI Plan Review — Phase 7

## OpenCode Review

I'll start by reading key context files to ground the review in the actual codebase state, then produce the review.
Let me read the production code and the Phase 6 verifier to ground the review.
Let me read the remainder of `neocade_theme.gd` to see the BINDING_TABLE tail and existing Phase 7 entries, plus the Phase 6 ResourceSaver.
Now I have a complete picture of the codebase. Here is the review:

---

# Cross-AI Plan Review: Phase 7 — Dialogs, Popups, Advanced

## Summary

The five plans form a coherent, well-sequenced wave structure that faithfully mirrors Phase 6's successful pattern: slot-freeze foundation first, risk-cluster implementation waves second through fourth, and a final full-verification-plus-ResourceSaver wave last. The plans are grounded in concrete Godot 4.6.2 local probe evidence and respect every architecture invariant (one `.gd`, data-only `.tres`, no `Theme.clear`, no export expansion, no root fallback). Coverage targets—COV-06, COV-08, and cumulative COV-01/07/09 closure—are directly addressed. The plans will achieve the phase goals if executed precisely. The primary risk is icon-authoring volume (46 new SVGs across three waves) and silent font-wiring failures from a BINDING_TABLE that lacks a font branch.

## Strengths

- **Slot-freeze discipline is strong** — the probe log from local Godot 4.6.2 is the only permitted slot source; stale names (`icon_normal_color`, `title_hover`, guessed `file_up`) are explicitly forbidden.
- **Wave isolation is clean** — each plan owns a verifier stage; the full stage fails on any pending group, preventing premature "done" claims.
- **Icon contract is consistently applied** — all 46 icons across three waves follow the Phase 4/6 monochrome `#FFFFFF` / 32×32 / Godot `.import` sidecar pattern.
- **Popup first-class discipline (Pitfall 1.7) is respected** — Window, PopupPanel, PopupMenu, TooltipPanel, TooltipLabel, AcceptDialog, ConfirmationDialog, and FileDialog all get explicit entries; no parent-inheritance assumption.
- **ResourceSaver round-trip is deferred to the final wave** (07-05), matching Phase 6's pattern of not mutating `.tres` files until all production bindings exist.
- **Architecture invariants are guarded by verifier assertions** — `assert_no_theme_clear`, `assert_one_addon_root_gd`, `assert_public_export_lock`, data-only strip all carry forward.

## Concerns

### HIGH Severity

1. **Font slots for PopupMenu, MenuBar, Window, TooltipLabel, and ColorPickerButton — silent wiring gap.** BINDING_TABLE has no `"font"` data-type branch (Cross-AI Cycle 2 N1 fix). Several Phase 7 controls expose official `font`/`font_size` slots (PopupMenu.font/font_separator/font_size/font_separator_size, MenuBar.font/font_size, Window.title_font/title_font_size, TooltipLabel.font/font_size, ColorPickerButton.font/font_size). The existing `_regenerate_theme()` pattern handles font via direct `set_font()`/`set_font_size()` calls after the BINDING_TABLE walk (lines 220–233). If an executor reads a plan's "add all official slot coverage" instruction and writes a BINDING_TABLE recipe with `"font":` or `"font_size":` as its data-type key, the slot will silently be skipped (the iteration loop skips unrecognized data-types). The plans should explicitly state that font/font_size wire-up for these controls must use direct `set_font`/`set_font_size` calls in `_regenerate_theme()`, NOT BINDING_TABLE entries. **Mitigation:** Plans 07-02 (Task 2) and 07-04 (Task 3) could add a one-line instruction to the action block. Even without it, the verifier's slot-presence checks will catch missing fonts — but catching them late means an extra execution cycle.

2. **GraphNode and GraphFrame have zero BINDING_TABLE baseline.** The research shows GraphNode has 7 styleboxes + 1 color + 2 constants + 2 icons; GraphFrame has 4 styleboxes + 1 color + 1 icon. Plan 07-05 Task 2 must create complete blocks for both from scratch. The risk is that the executor builds only partial coverage (e.g., binds only `panel` stylebox for GraphNode) and the graph-stage verifier fails with a long list of missing slots, requiring a full re-execution of the wave. **Mitigation:** Plan 07-05 Task 2 should enumerate every official slot per the research table in its behavior section so the executor can't miss half the slots.

### MEDIUM Severity

3. **FileDialog's stale `icon_normal_color` is in the current BINDING_TABLE** (line 1183). Plan 07-03 Task 2 correctly states "Remove or stop depending on stale `icon_normal_color`" — but the verifier must also assert this stale color is absent from BINDING_TABLE, not just from the loaded theme. The Phase 6 verifier pattern (lines 335–370) does this for Tree/Foldable/Tab stale slots. Plan 07-03 should add a similar `assert_filedialog_stale_slots_absent` check.

4. **ColorPickerButton baseline already has 5 styleboxes** (lines 1146–1163) but only 2 colors (`font_color`, `font_disabled_color`). Plan 07-04 Task 3 says "add missing official colors (`font_focus_color`, `font_hover_color`, `font_outline_color`, `font_pressed_color`), constants (`h_separation`, `outline_size`), explicit font/font_size, and the `bg` icon." The font/font_size issue (Concern #1) applies here too. The `bg` icon slot needs a new `colorpicker_button_bg.svg` — Plan 07-04 Task 1 already lists this in its interface; the executor must not forget it when counting "16 + 1 = 17 total ColorPicker-family icons."

5. **Populated `[sub_resource]` blocks in direction `.tres` files after ResourceSaver save.** The Phase 6 ResourceSaver strip pattern (lines 150–221) successfully strips theme entries AND `[sub_resource]` blocks through `_strip_theme_entries()`. Plan 07-05 Task 3 implicitly relies on the same pattern in `_phase7_resource_saver.gd`. The risk is that the new Phase 7 helper uses a different strip logic that preserves sub-resources. **Mitigation:** The Phase 7 ResourceSaver helper should be copied verbatim from Phase 6 with only path/constant name changes, or the verifier must assert `[sub_resource` absence in every direction file post-strip.

6. **ConfirmationDialog has NO own slots in the probe** (research table shows empty row). Plan 07-02 still calls it a first-class type with explicit entries. The current baseline gives it `panel` + `buttons_separation` (lines 1165–1172). This isn't wrong — ConfirmationDialog inherits AcceptDialog in Godot's class tree, and AcceptDialog has concrete slots. But the verifier must be careful: `theme.has_stylebox("panel", "ConfirmationDialog")` may succeed because Godot walks the type chain — the panel entry binds to AcceptDialog and inherits. The verifier should check BINDING_TABLE has a `ConfirmationDialog` key with entries, not that the loaded Theme has separate ConfirmationDialog entries (they might be the same AcceptDialog entries via inheritance). The current verifier pattern reads BINDING_TABLE from script constants, so it should work.

### LOW Severity

7. **Icon volume is high** — 20 FileDialog + 17 ColorPicker-family + 9 graph icons = 46 new SVGs plus their `.import` sidecars. If any icon references an existing SVG that the verifier expects to be a dedicated file, the slot-to-filename mapping will break. The plans provide canonical filename conventions (`filedialog_parent_folder.svg`, `colorpicker_screen_picker.svg`, `graph_grid_toggle.svg`), which is good. The 07-01 verifier's slot-freeze stage should include a canonical-icon-names check for Phase 7 controls.

8. **GraphFrame's `resizer_color` is missing from Plan 07-05's interface section.** The research table shows GraphFrame has `resizer_color` (in addition to the 4 styleboxes and `resizer` icon). Plan 07-05 Task 2's action block says "GraphFrame should use grouping-oriented panels/titlebars and share `graph_resizer.svg`" — it should also mention `resizer_color` so the executor doesn't miss it.

9. **TooltipLabel `shadow_offset_x` / `shadow_offset_y` should be zero.** Plan 07-02 Task 2 says "controlled/no shadow offsets" and D-07 says "compact and mostly structural" — but the plan doesn't set explicit values. If the executor defaults to `4` or some non-zero value based on other constants, the tooltip will have an unwanted offset shadow. The plan should specify `shadow_offset_x: 0, shadow_offset_y: 0` explicitly.

10. **`PopupMenu.font_separator_outline_color` needs a role recipe that reads as a muted outline, not text.** This is a niche slot. If the executor binds it to `text_muted` (which is for text-on-surface), it may be too high-contrast for a separator outline. A dedicated `outline_color` role is more appropriate, consistent with how separator styleboxes use `outline_color`.

## Suggestions

- **Add a "font wiring" instruction to Plans 07-02 and 07-04** — one line: "Font/font_size slots for PopupMenu, MenuBar, Window, TooltipLabel, and ColorPickerButton must use direct `set_font`/`set_font_size` calls in `_regenerate_theme()` outside BINDING_TABLE, matching the Tree/ItemList/FoldableContainer pattern at lines 220–233."
- **Enumerate all GraphNode and GraphFrame slots verbatim in Plan 07-05 Task 2's action block** — copy the exact slot lists from RESEARCH.md lines 62–63 so the executor can't miss any.
- **Add `assert_filedialog_stale_slots_absent` to Plan 07-03's verifier hardening** — check that `icon_normal_color` is absent from both the loaded theme and the BINDING_TABLE key.
- **Canonical icon-name check in 07-01 slot-freeze verifier** — assert that BINDING_TABLE's Phase 7 icon recipes reference filenames matching the naming convention (`filedialog_*`, `colorpicker_*`, `graph_*`, `popup_*`).
- **Plan 07-05 interface: add `resizer_color` to GraphFrame** — the slot list in the plan should match the research table exactly.
- **TooltipLabel: specify shadow offsets as `0` explicitly** — Plan 07-02's action block should include `shadow_offset_x: 0, shadow_offset_y: 0` in the TooltipLabel binding.
- **PopupMenu `font_separator_outline_color`: suggest `outline_color` role** — matches the structural separator stylebox role and keeps muted hierarchy.

## Risk Assessment: **MEDIUM**

**Justification:** The plans have no architectural risks (no scope creep, no export expansion, no per-direction scripts). The dependency ordering is sound (slot-freeze → popups → FileDialog → ColorPicker → Graph → final). The primary execution risks are (1) font-wiring failures from the BINDING_TABLE font-branch gap causing silent skips that the verifier catches only after all bindings are written, requiring an extra cycle; (2) GraphNode/GraphFrame being built from a near-zero baseline, risking incomplete first-pass coverage; and (3) the sheer volume of icon authoring (46 SVGs across three waves) potentially overwhelming a single agent session. None of these are plan-design defects — they're execution-pace risks that the staged verifier catches reliably. The phase goals will be met; the question is whether it takes one execution cycle per wave or two.


---

## Consensus Summary

Only the requested OpenCode reviewer was invoked for this cycle, so consensus reflects one external model rather than overlap across multiple reviewers.

### Agreed Strengths

- Slot-freeze discipline and local Godot 4.6.2 probe evidence are strong foundations for avoiding stale theme names.
- The five-wave sequence is well ordered: foundation, popup/dialog shells, FileDialog, ColorPicker, then Graph and final ResourceSaver verification.
- Architecture invariants from prior phases are preserved: one addon root .gd, data-only direction resources, no Theme.clear, no export expansion.

### Agreed Concerns

- HIGH: Font and font_size slots for Phase 7 controls can silently fail if implemented through BINDING_TABLE; they need direct set_font / set_font_size calls in _regenerate_theme().
- HIGH: GraphNode and GraphFrame begin from near-zero baseline coverage, so Plan 07-05 should enumerate every official slot explicitly before execution.
- MEDIUM: FileDialog stale icon_normal_color removal should be asserted against both loaded theme entries and BINDING_TABLE recipes.

### Divergent Views

- None. Only OpenCode was requested and invoked in this review cycle.
