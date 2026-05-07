---
phase: 6
review_cycle: 2
reviewers: [opencode]
reviewed_at: 2026-05-07T08:22:03Z
review_base_commit: 011574d
plans_reviewed:
  - 06-01-PLAN.md
  - 06-02-PLAN.md
  - 06-03-PLAN.md
  - 06-04-PLAN.md
  - 06-05-PLAN.md
---

# Cross-AI Plan Review - Phase 6 - Cycle 2

## OpenCode Review
Now let me verify a few more key sections of the production code and the existing Phase 5 verification approach to ground my review:
Here is the structured review of all 5 Cycle 2 Phase 6 plans:

---

# Phase 6 Plan Cross-AI Review — OpenCode (deepseek/deepseek-v4-pro) — Cycle 2

## Overall Assessment

The five Cycle 2 plans are a substantial improvement over Cycle 1. All 9 Cycle 1 HIGH concerns have been resolved: the Tree slot freeze now targets the full 18-stylebox Godot 4.6.2 surface, the ItemList opaque-cursor bug is explicitly fixed, `button_highlight`/`button_pressed` are added to TabBar, ScrollContainer gets an explicit new BINDING_TABLE entry, and ScrollBar/icon slot→filename mappings are explicit across all plans. The revised plans now enumerate specific slot targets, color counts, and icon mappings — removing the "executor must guess" gap that was the root cause of most Cycle 1 HIGH concerns. The wave order (freeze→Tree→lists→tabs→range+closeout) remains sound.

---

## 06-01-PLAN.md — Slot Freeze and Verifier Foundation

**Summary:** Cycle 2 correctly expands the Tree CANONICAL_SLOT_NAMES freeze to 18 styleboxes (including `custom_button` and `hovered_dimmed`) and targets only the Tree `hover` → `hovered` rename in BINDING_TABLE without affecting other Controls' `hover` keys. The verifier's `slot-freeze` stage is well-specced. All Cycle 1 HIGH concerns for this plan are resolved.

**Strengths:**
- Task 1 now explicitly freezes the 18 probed Tree styleboxes from the probe log, with `custom_button` and `hovered_dimmed` included and invalid `hover` absent — closing the Cycle 1 16→18 gap.
- The Foldable stale-name fix (`title_hover` → `title_hover_panel`, `title_collapsed` → `title_collapsed_panel`, `title_font_color` → `collapsed_font_color`/`hover_font_color`) is explicit and verifier-backed.
- `tab_separation` exclusion is correctly enforced with a re-probe requirement if evidence changes.
- Task 1 behavior Test 2 correctly scopes the rename to Tree only — `"rename only the Tree stylebox slot key from `"hover"` to `"hovered"` and does not require or scan unrelated `"hover"` keys in other controls"`.
- The verifier `slot-freeze` stage assertion list (official slot lists, no stale names, no `Theme.clear()`, one addon-root `.gd`, no public export changes) is comprehensive.

**Concerns:**
- **MEDIUM:** The Task 1 automated verification uses a PowerShell regex that extracts the Tree stylebox body from the `.gd` file with `[\s\S]*?\"stylebox\"\s*:\s*\{([\s\S]*?)\n\t\t\}`. This regex depends on exact source formatting (two-tab indent after the closing brace). If the GDScript formatter changes indentation or adds trailing commas, the regex silently returns no match and the PowerShell exits 1 (false failure). The `rg` checks and runtime Theme introspection in later plans provide a backup, but this source-scan should either use a more robust approach (AST-agnostic `has_stylebox` introspection) or add a "regex match found" guard before slot assertions.
- **LOW:** Task 2 says "copy/adapt the Phase 5 resolver into the Phase 6 helper directory so execution does not depend on Phase 5-generated local path files." If the copied file hardcodes Phase 5 paths, the executor must update them. The plan's intent ("Phase 6 names and markers") is clear enough.
- **LOW:** The verifier does not assert `DIRECTION_PRESETS.shape` key integrity (tab_radius, raised_lifts entries, focus_offset). These are consumed by Plans 02-05 and a missing key would cause `_lookup_shape()` to return null silently. The Phase 5 verifier had similar shape-assertion patterns that should be extended.

**Suggestions:**
- Add a fallback introspection check in the verifier's `slot-freeze` stage: `assert(theme.get_stylebox_list("Tree").has("hovered")) and assert(not theme.get_stylebox_list("Tree").has("hover"))` — this works regardless of source formatting and provides the ground-truth guarantee.
- Extend the `slot-freeze` verifier stage to assert all the shape keys that Plans 02-05 reference (`tab_radius`, `raised_lifts.selected_tab`, `raised_lifts.unselected_tab`, etc.) exist in each direction preset.

**Risk Assessment:** LOW — The foundation is solid; the only fragility risk is the PowerShell regex source-scan, which has a runtime backup via the verifier's Theme introspection.

---

## 06-02-PLAN.md — Tree Full Theming

**Summary:** Cycle 2 adds the explicit icon-mapping table and enumerates all 15 Tree colors and 27 constants with the 9 required additions identified. The `indeterminate_disabled` → `tree_indeterminate.svg` wiring is now explicit. All Cycle 1 HIGH concerns for this plan are resolved.

**Strengths:**
- Complete icon mapping table with 12 official slot→SVG rows, including `arrow` → `disclosure_expanded.svg` and `indeterminate_disabled` → `tree_indeterminate.svg`.
- Color coverage is fully enumerated: the 9 missing colors are called out by name (`children_hl_line_color`, `custom_button_font_highlight`, `font_disabled_color`, `font_hovered_color`, `font_hovered_dimmed_color`, `font_hovered_selected_color`, `font_outline_color`, `scroll_hint_color`, `title_button_color`) plus the 6 already bound.
- Constants coverage: all 27 official Tree constants listed in the interface section.
- Explicit font/font_size: both `font`/`title_button_font` and `font_size`/`title_button_font_size` are targeted.
- TDD-style behavior tests cover: slot completeness, cursor transparency, guide colors from outline/accent, focus outer-ring, exact icon mapping, all 15 colors, and all 27 constants.
- Reuses existing `checkbox_checked.svg`/`checkbox_unchecked.svg` for checked/unchecked/disabled slots.

**Concerns:**
- **MEDIUM:** Task 2's action says to "explicitly set `Tree.font` and `Tree.title_button_font` directly next to the existing `_regenerate_theme()` explicit font calls." This is the correct pattern, but the plan doesn't explicitly verify that the `Tree.font` slot is populated in the TDD tests (tests 1-7 cover styleboxes, colors, constants, font_sizes, and icons — but not a `font` data-type check since BINDING_TABLE has no `font` branch). The verifier `tree` stage should include `assert(theme.get_font("font", "Tree") != null)` and `assert(theme.get_font("title_button_font", "Tree") != null)` to prevent silent omission.
- **LOW:** Task 1 says "Reuse existing `checkbox_checked.svg` and `checkbox_unchecked.svg` for Tree `checked`/`unchecked` and disabled equivalents via tinting." The plan says "via tinting" but the actual mechanism in BINDING_TABLE is icon-reuse (both `checked` and `checked_disabled` point to the same SVG; Godot's state system handles the dimming). The wording "via tinting" could mislead an executor into thinking a color-recipe is needed for the disabled icon. The mapping table is unambiguous — this is a wording nit, not a correctness issue.

**Suggestions:**
- Extend the `tree` verifier stage to assert both `Tree.font` and `Tree.title_button_font` are non-null on the loaded NeoCade theme.
- Add a constants-completeness assertion in the `tree` stage: for each of the 27 official constant names, `theme.has_constant("Tree", name)` must return true.

**Risk Assessment:** LOW — The explicit slot enumeration eliminates the Cycle 1 under-specification risk. The only remaining gap is the verifier-side font assertion.

---

## 06-03-PLAN.md — ItemList and FoldableContainer

**Summary:** Cycle 2 explicitly fixes the ItemList opaque-cursor bug (`state_hover` → transparent overlay) and adds the missing `font_outline_color`/`scroll_hint_color` color slots. FoldableContainer icon wiring is now explicit (`folded_arrow` → `disclosure_collapsed.svg`, etc.). All Cycle 1 HIGH and MEDIUM concerns for this plan are resolved.

**Strengths:**
- Task 1 action explicitly calls out the current cursor bug: "Fix the current baseline bug where `cursor` and `cursor_unfocused` are bound to opaque `{"role": "state_hover"}`." The action specifies replacing with a transparent/semi-transparent overlay path.
- Test 3 in Task 1's behavior block asserts `StyleBoxFlat.bg_color.a < 1.0` for both cursor slots — verifier-enforced, not advisory.
- ItemList color coverage now targets all 7 official colors (adds `font_outline_color` and `scroll_hint_color`).
- FoldableContainer icon mapping is explicit: `expanded_arrow` → `disclosure_expanded.svg`, `folded_arrow` → `disclosure_collapsed.svg`, and mirrored equivalents.
- Foldable stale slot names (`title_hover`, `title_collapsed`, `title_font_color`) are explicitly verified absent in Test 2.

**Concerns:**
- **LOW:** Task 1 says "Reuse the Tree selected-row helper/recipe shape only if it prevents contrast or geometry drift; otherwise keep the recipes inline." This conditional language delegates a visual-consistency decision to the executor. The verifier's `itemlist-foldable` stage should independently assert that ItemList selected-row semantics (accent-derived surface + high-contrast text) match Tree, regardless of whether a shared helper is used.
- **LOW:** ItemList constant `line_separation` currently has a hardcoded value of `2` in the existing BINDING_TABLE. The plan says to "document `line_separation` as the desktop baseline value that Phase 8 can scale." This documentation should be a comment in the BINDING_TABLE or a verifier annotation, not just plan prose.

**Suggestions:**
- Add an assertion in the `itemlist-foldable` verifier stage: ItemList `selected` and Tree `selected` styleboxes both use `accent_offset` (or equivalent accent-derived role) and both have `bg_color.a >= 0.85` for unmistakable selection.

**Risk Assessment:** LOW — The cursor-opacity fix is explicitly tasked and verifier-guarded. No residual HIGH concerns.

---

## 06-04-PLAN.md — TabBar and TabContainer

**Summary:** Cycle 2 explicitly adds `button_highlight`/`button_pressed` to TabBar BINDING_TABLE, wires `menu`/`menu_highlight` both to `tab_menu.svg`, and enumerates all 10 color slots and 4+4 constant slots. The shared tab model (active→content attachment via zeroed bottom radii) is specified. All Cycle 1 HIGH concerns for this plan are resolved.

**Strengths:**
- Test 5 explicitly asserts `button_highlight` and `button_pressed` styleboxes on TabBar as small overflow-button surfaces.
- Test 6 explicitly asserts TabContainer `menu` and `menu_highlight` as separate recipe entries both resolving to `tab_menu.svg`.
- Task 2 action explicitly calls out all 10 colors, 4 TabBar constants, and 4 TabContainer constants.
- The selected-tab visual attachment to content is addressed: "use `shape.tab_radius` for top corners and zero the bottom corners when needed so selected tabs do not read as detached chips."
- Icon reuse strategy is correct: highlight variants reuse base SVGs (tint via icon color slots, not duplicate files).

**Concerns:**
- **MEDIUM:** The plan says to "zero the bottom corners when needed" for selected tabs but doesn't specify a mechanism (a narrow `_make_tab_selected_stylebox` helper, or an inline override after `_set_radius_all`). Without a concrete approach, the executor might implement this inconsistently. Since `_set_radius_all` is called by the generic `_resolve_recipe`, a post-processing step on `tab_selected` styleboxes is needed to override the bottom radii. The plan should commit to a specific approach or add a `shape.tab_bottom_radius_zero` flag.
- **MEDIUM:** TabBar `hover_switch_wait_msec` constant is in the probe but the plan's interface and tasks don't reference a specific value. The executor should set this to `0` (no hover delay) or the engine default, with a rationale. The plan delegates this to D-01, but a constant with a specific behavioral impact warrants explicit treatment.
- **LOW:** TabBar `outline_size` constant exists in the probe (line 48). TabContainer `outline_size` also exists (line 68). Both are listed in the plan's interface section. But the plan doesn't specify the value — likely `outline_width` (@export) default of 1. The executor should document this choice.

**Suggestions:**
- Add a dedicated `_make_tab_selected` helper or a `zero_bottom_corners` post-processing step in the tab stylebox construction to enforce the "attached to content" visual.
- Set `hover_switch_wait_msec: 0` and `outline_size: 1` (matching `outline_width` @export) with rationale in the BINDING_TABLE or a code comment.

**Risk Assessment:** LOW — The missing `button_highlight`/`button_pressed` and `menu`/`menu_highlight` gaps from Cycle 1 are now explicitly tasked. The bottom-radius zeroing is the main remaining implementation detail.

---

## 06-05-PLAN.md — Range Controls, Containers, Round-Trip Verification

**Summary:** Cycle 2 adds an explicit ScrollContainer BINDING_TABLE entry, full ScrollBar slot→SVG mapping tables for both H/V directions, explicit BINDING_TABLE entries for SplitContainer/HSplitContainer/VSplitContainer/HSeparator/VSeparator and all layout-only containers. The container boundary section now has a clear "interfaces" table listing exactly which data kinds each new entry needs. All Cycle 1 HIGH concerns for this plan are resolved.

**Strengths:**
- Explicit "Interfaces" section with a table of all new/extended BINDING_TABLE entries: ScrollContainer (stylebox/color/icon), SplitContainer (stylebox/color/constant/icon), HSplitContainer/VSplitContainer (stylebox/constant/icon), MarginContainer (constants), layout containers (constants), HSeparator/VSeparator (stylebox+constant).
- ScrollBar icon mapping table is precise: 6 HScrollBar slots → `scrollbar_left.svg`/`scrollbar_right.svg`, 6 VScrollBar slots → `scrollbar_up.svg`/`scrollbar_down.svg`. Highlight/pressed reuse base SVGs.
- ProgressBar now includes `font_outline_color` and `outline_size` in Task 2 Test 7.
- Layout-only container exclusion: HBox/VBox/Flow/Grid get only `separation`/`h_separation`/`v_separation` constants. CenterContainer remains unbound (no slots). D-18 compliance is explicit.
- ResourceSaver round-trip has clear acceptance criteria: each `.tres` reloads as `NeoCadeTheme`, preserves all 9 exports, contains no `[sub_resource]` or `theme_data/`, under 2048 bytes.
- HSeparator/VSeparator `separator` stylebox and `separation` constant are explicitly called out.

**Concerns:**
- **MEDIUM:** The SplitContainer base class has `touch_dragger_color`, `touch_dragger_hover_color`, `touch_dragger_pressed_color` (3 colors). The plan's interfaces section lists these for SplitContainer, and says to create them. But the Task 2 action says "Explicitly create or extend `SplitContainer`, `HSplitContainer`, and `VSplitContainer` entries using only the probed stylebox/color/constant/icon slots listed in this plan." The colors are listed — good. The TDD tests (Task 2 Tests 1-7) don't explicitly assert these three touch-dragger colors exist. The verifier `range-containers` stage should include them.
- **MEDIUM:** HSplitContainer has icon slots `grabber` and `touch_dragger`. VSplitContainer has the same. But the base SplitContainer has `h_grabber`, `h_touch_dragger`, `v_grabber`, `v_touch_dragger` — 4 icon slots. The plan creates icons for the h/v variants (`split_grabber_h.svg`, `split_touch_dragger_h.svg`, etc.) but the interface table doesn't explicitly show which icon files map to which class's slots. The executor must infer: SplitContainer `h_grabber` → `split_grabber_h.svg`, SplitContainer `v_grabber` → `split_grabber_v.svg`, HSplitContainer `grabber` → `split_grabber_h.svg`, VSplitContainer `grabber` → `split_grabber_v.svg`, and similarly for touch_dragger. This is straightforward but the mapping should be explicit in the plan like the ScrollBar table.
- **LOW:** The plan's ScrollContainer entry says "panel treatment must avoid nested-card overuse per D-16." The ScrollContainer `panel` slot likely just needs `role: surface_low` with no border (or a subtle outline). The D-01 delegation means the executor picks, but setting this to `surface_panel` or higher would add unwanted card-like chrome to every scroll area. The plan could add a guard: the verifier should assert `ScrollContainer.panel` bg_color matches the role of a low/calm surface, not `surface_highlight`/`surface_overlay`.
- **LOW:** The ResourceSaver strip helper from Phase 5 may reference Phase 5-specific paths or `.tres` filenames. The plan says to port it with "Phase 6 names and markers" — the executor must be careful to update the `.tres` file list.

**Suggestions:**
- Add a SplitContainer icon mapping table (like the ScrollBar table) showing class→slot→SVG filename.
- Add touch_dragger color assertions to the verifier's `range-containers` stage.
- Add a ScrollContainer `panel` stylebox assertion: `bg_color` role should be `surface_low` or equivalent, not `surface_high`/`surface_overlay`.

**Risk Assessment:** LOW — The BINDING_TABLE expansion surface is now explicitly enumerated. The ResourceSaver round-trip provides strong data-integrity gates. The main execution risk is correctly mapping SplitContainer icon slots to the 4 h/v SVG files.

---

## Overall Risk Assessment: LOW

All 9 Cycle 1 HIGH concerns are fully resolved in the Cycle 2 plans. The revised plans now enumerate specific slot targets, icon mappings, color counts, and constant lists — removing the under-specification gap that was the root cause of most prior HIGH concerns. The plan structure (wave-ordered, dependency-aware) is sound. The verifier stages are well-designed with TDD-style behavior tests.

**Key improvements in Cycle 2:**
1. Tree slot freeze targets full 18-stylebox Godot 4.6.2 surface (was 16, missing `custom_button`/`hovered_dimmed`)
2. ItemList opaque-cursor bug explicitly fixed with verifier-enforced alpha < 1.0 guard
3. TabBar `button_highlight`/`button_pressed` and TabContainer `menu`/`menu_highlight` are explicit BINDING_TABLE additions
4. ScrollContainer gets an explicit new BINDING_TABLE entry (was entirely missing in Cycle 1)
5. All ScrollBar/Tree/Tab/Foldable icon slot→SVG filename mappings are explicit tables
6. All missing color/constant slots are enumerated per Control

**Remaining MEDIUM concerns (none blocking — all addressable during execution):**
- PowerShell regex source-scan fragility in 06-01 (backed by runtime introspection)
- Tab-selected bottom-radius zeroing needs a concrete mechanism in 06-04
- SplitContainer icon slot→file mapping should be a table in 06-05 (like ScrollBar's)
- `Tree.font`/`Tree.title_button_font` verifier assertions missing in 06-02

---

## Current HIGH Concerns

None.
---

## Consensus Summary

Only OpenCode was invoked for this requested Cycle 2 review (--opencode, model deepseek/deepseek-v4-pro), so this section summarizes that single reviewer rather than cross-reviewer agreement.

### Agreed Strengths

- Cycle 2 resolves the prior HIGH-level under-specification by enumerating Tree, ItemList/FoldableContainer, TabBar/TabContainer, ScrollBar, SplitContainer, and ScrollContainer slot targets explicitly.
- The five-plan wave order remains dependency-safe: slot freeze, Tree, list/foldable controls, tabs, then range/container closeout.
- The revised verifier strategy is strong enough to catch the previously risky silent-fallback cases.

### Agreed Concerns

- No current unresolved HIGH concerns remain.
- Remaining MEDIUM concerns are execution refinements: make the slot-freeze source scan less regex-fragile, add Tree font assertions, specify selected-tab bottom-radius mechanics, and make SplitContainer icon mapping/touch-dragger verifier assertions explicit.

### Divergent Views

- Not applicable; this cycle intentionally used OpenCode only.

## Current HIGH Concerns

None.
