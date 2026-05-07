---
phase: 6
reviewers: [opencode]
reviewed_at: 2026-05-07T08:04:03Z
plans_reviewed:
  - 06-01-PLAN.md
  - 06-02-PLAN.md
  - 06-03-PLAN.md
  - 06-04-PLAN.md
  - 06-05-PLAN.md
---

# Cross-AI Plan Review — Phase 6

## OpenCode Review

Let me continue reading the production class and check supporting files.
Now let me check the remaining portion of the production class and key reference files for completeness:
Here is the structured review of all 5 Phase 6 plans:

---

# Phase 6 Plan Cross-AI Review — OpenCode (deepseek/deepseek-v4-pro)

## Overall Assessment

The five plans collectively form a solid, dependency-ordered execution sequence that correctly prioritizes slot-name correction before visual polish. The slot-freeze foundation (06-01) is the critical enabler — current production code has known stale names (`Tree.hover`, Foldable `title_hover`/`title_collapsed`/`title_font_color`) that would silently fail. The wave structure (freeze→Tree→lists→tabs→range+containers) is sensible. However, the later plans under-specify the exact slot-surface expansion needed, particularly for Tree's 18 stylebox / 15 color / 27 constant full set and TabBar's `button_highlight` / `button_pressed` overlays. The icon authoring workload (~38 SVGs plus import sidecars) is substantial and somewhat under-emphasized.

---

## 06-01-PLAN.md — Slot Freeze and Verifier Foundation

**Summary:** A necessary foundation plan that must run first. Fixes the critical stale-slot problem in `CANONICAL_SLOT_NAMES` and creates reusable verification infrastructure for the remaining Phase 6 plans.

**Strengths:**
- Correctly identifies and plans to remove all three stale slot families: `Tree.hover` → `Tree.hovered`, Foldable `title_hover`/`title_collapsed`/`title_font_color` → official names, `tab_separation` guarded against binding.
- Well-structured staged verifier design (slot-freeze/tree/itemlist-foldable/tabs/range-containers/full) matching the remaining plan waves.
- Concrete TDD-style verification steps with `rg` exit-code assertions.
- Reuses proven Phase 5 resolver/ResourceSaver patterns rather than inventing new tooling.

**Concerns:**
- **HIGH**: `CANONICAL_SLOT_NAMES.Tree.stylebox` (line 694-697) currently lists 16 entries and includes `"hover"` (invalid). The probe log shows Godot 4.6.2 exposes **18** Tree styleboxes — the current list is missing `custom_button` and `hovered_dimmed`. Task 1 must expand beyond the current 16-entry list; a plan that only renames `hover`→`hovered` without adding `custom_button` and `hovered_dimmed` leaves 2/18 slots unverified and creates a false sense of completeness for later plans.
- **HIGH**: The current BINDING_TABLE.Tree (line 1415) maps `"hover":` to a recipe. Task 1 says to replace `Tree.hover` with `Tree.hovered` in "production bindings." But the BINDING_TABLE key is literally `"hover"` (not `"Tree.hover"`), so the rename must be from BINDING_TABLE `"hover"` slot-key → `"hovered"` slot-key. The plan's `rg` verification searches for `Tree\.hover|"hover"\s*:` — the regex `"hover"\s*:` will match other Controls' hover slots too (Button, PopupMenu, MenuBar, etc.). A more targeted pattern for Tree specifically is needed, or the verifier must assert `Tree.hovered` is present AND `Tree.hover` absent via Theme introspection.
- **MEDIUM**: Task 2 says to "copy/adapt the Phase 5 resolver into the Phase 6 helper directory." The Phase 5 resolver (Godot CLI path resolution) is referenced but the actual file may be machine-local. If the Phase 5 helper directory's `godot-cli-path.txt` contains a hardcoded local path, copying it may create stale references. The plan should instead create a fresh resolver that discovers Godot independently, falling back to the Phase 5 cached path.
- **MEDIUM**: The plan mentions "assert no public export changes" in the verifier. The verifier should also assert `DIRECTION_PRESETS.shape` keys haven't been modified (tab_radius, raised_lifts entries, focus_offset) since these are consumed by later plans.

**Suggestions:**
- Task 1 should explicitly enumerate the 18-stylebox expansion target (adding `custom_button` and `hovered_dimmed`) alongside the `hover→hovered` rename.
- The verifier's `slot-freeze` stage should use `Theme.get_stylebox_list("Tree")` introspection (not just source scanning) to confirm the loaded NeoCade theme exposes the correct 18 official slot names.
- Consider adding a BINDING_TABLE key-scan verification step that ensures every key in BINDING_TABLE.Tree.stylebox matches a key in the updated CANONICAL_SLOT_NAMES.

**Risk Assessment:** MEDIUM — The foundation is sound but the Tree slot expansion gap (16→18) is non-trivial. If `custom_button` and `hovered_dimmed` are not frozen in this wave, Plan 02 (Tree) will ship incomplete coverage.

---

## 06-02-PLAN.md — Tree Full Theming

**Summary:** Correctly treats Tree as the heaviest Phase 6 class. Icon reuse strategy is good. But the plan is imprecise about the full slot-surface expansion required for a "complete" Tree.

**Strengths:**
- Icon strategy correctly reuses existing `checkbox_checked.svg`/`unchecked.svg` for Tree's checked/unchecked slots (and disabled variants via `disabled_icon` reuse pattern).
- Creates only the unique icons Tree needs: disclosure (expand/collapse + mirrored), indeterminate, scroll hint, select arrow, up/down sort.
- Clear cursor transparency requirements (D-04 compliance).
- Properly separates Tree from ItemList/Foldable for focused implementation.

**Concerns:**
- **HIGH**: The plan's files_modified list only creates 7 icon resource pairs (14 files). But the probe log lists 12 Tree icon slots. The plan says "Reuse existing checkbox_checked.svg for Tree checked/unchecked" — this covers `checked`, `checked_disabled`, `unchecked`, `unchecked_disabled` (4 slots, 2 SVGs). Adding the 6 new SVGs (disclosure_expanded, disclosure_expanded_mirrored, disclosure_collapsed, disclosure_collapsed_mirrored, tree_indeterminate, tree_scroll_hint, tree_select_arrow, tree_updown = 8 SVGs covering 8 slots) gives 10 covered slots. But wait — `arrow` and `arrow_collapsed_mirrored` and `indeterminate_disabled` need explicit wiring. `arrow` = `disclosure_expanded.svg`, `arrow_collapsed` = `disclosure_collapsed.svg`, `arrow_collapsed_mirrored` = `disclosure_collapsed_mirrored.svg`. That's fine. But `indeterminate_disabled` should reuse `tree_indeterminate.svg` — this needs to be wired explicitly in the BINDING_TABLE. **The plan does not call out `indeterminate_disabled` as needing wiring, and it does not list `arrow` (expanded) as an explicit mapping target.**
- **HIGH**: The current BINDING_TABLE.Tree covers only 6 of 15 Tree colors (`font_color`, `font_selected_color`, `guide_color`, `drop_position_color`, `parent_hl_line_color`, `relationship_line_color`). Missing 9: `children_hl_line_color`, `custom_button_font_highlight`, `font_disabled_color`, `font_hovered_color`, `font_hovered_dimmed_color`, `font_hovered_selected_color`, `font_outline_color`, `scroll_hint_color`, `title_button_color`. D-04 requires high-contrast selected text and the plan mentions `font_outline_color` in D-05 — but the BINDING_TABLE expansion target is not enumerated. The executor needs explicit guidance on which missing colors to add.
- **MEDIUM**: The current BINDING_TABLE.Tree covers only 6 of 27 Tree constants. Missing 21 constants include critical ones like `draw_guides`, `draw_relationship_lines`, `scroll_speed`, `scroll_border`, `button_margin`, `relationship_line_width`, `h_separation`, `icon_h_separation`, `icon_max_width`, `outline_size`, and all `scrollbar_*` constants. Some constants are zero-or-int-default and need explicit values for the Tree to feel polished. The plan says "integer and desktop-dense" but doesn't specify which subset to populate.
- **MEDIUM**: The plan says to set `Tree.font` and `Tree.title_button_font` "if required for verifier coverage" — this is a conditional that should be a commitment. The probe shows these slots exist. Since BINDING_TABLE doesn't handle `font` data type, these MUST be set via explicit `set_font()` calls. The default_font fallback may handle `Tree.font` but `title_button_font` specifically controls title button appearance and should be explicitly set.
- **MEDIUM**: The BINDING_TABLE must add `hovered_dimmed` stylebox. This is a distinct slot from `hovered` — Godot uses it for dimmed hover states on non-focused trees. The plan's must_haves mention "`hovered_dimmed`" in the artifact description but not in a specific Task. The executor must add it.

**Suggestions:**
- Add an explicit mapping table in the plan: official slot name → SVG filename. This prevents wiring errors during execution.
- Enumerate the minimum set of Tree color/constant/icon slots that must be populated, referencing the probe log counts (15 colors, 27 constants, 12 icons, 2 fonts, 2 font_sizes).
- Specify `indeterminate_disabled` icon wiring (reuses `tree_indeterminate.svg`).
- Commit to explicit `set_font("font", "Tree", body_font)` and `set_font("title_button_font", "Tree", body_font)` calls.

**Risk Assessment:** MEDIUM — The plan's core visual intent is correct, but under-specification of the BINDING_TABLE expansion surface (especially Tree colors and constants) risks shipping an incomplete Tree that renders default-Godot chrome on several states.

---

## 06-03-PLAN.md — ItemList and FoldableContainer

**Summary:** A well-scoped plan that correctly depends on Tree for shared vocabulary. The Foldable slot-name corrections are essential. Cursor transparency is flagged but the current code's bug on ItemList cursor is not explicitly identified.

**Strengths:**
- Correctly identifies and plans to fix all stale FoldableContainer slot names.
- Reuses Tree disclosure icons for FoldableContainer affordances (visual consistency).
- Good shared selected-row vocabulary with Tree.
- Properly sized as a single wave (not over-scoping).

**Concerns:**
- **HIGH**: The current BINDING_TABLE.ItemList (line 1106-1107) binds `cursor` and `cursor_unfocused` to `"role": "state_hover"` — this produces **opaque** cursor styleboxes because `state_hover` is a fully-saturated Color. D-04 explicitly requires "cursor styleboxes must remain transparent or semi-transparent." The plan's behavioral test says "ItemList cursor overlays are transparent or semi-transparent" but does not explicitly task the executor with fixing the existing opaque binding. The existing code uses `state_hover` which is opaque — this needs to be changed to use the `_make_transparent_overlay` pattern or an alpha < 1.0 recipe.
- **MEDIUM**: The plan's color coverage may be incomplete. The probe shows ItemList has 7 colors. Current BINDING_TABLE covers 5 (font_color, font_hovered_color, font_selected_color, font_hovered_selected_color, guide_color). Missing: `font_outline_color` and `scroll_hint_color`. These should be added.
- **MEDIUM**: The FoldableContainer icon mapping is ambiguous. The plan says "Wire expanded_arrow, expanded_arrow_mirrored, folded_arrow, and folded_arrow_mirrored to Plan 02 disclosure icons." But the mapping needs to be: `expanded_arrow` → `disclosure_expanded.svg`, `folded_arrow` → `disclosure_collapsed.svg`, `expanded_arrow_mirrored` → `disclosure_expanded_mirrored.svg`, `folded_arrow_mirrored` → `disclosure_collapsed_mirrored.svg`. The plan should make this explicit.
- **MEDIUM**: The current BINDING_TABLE.ItemList has `"line_separation": {"value": 2}` (hardcoded integer). The probe shows `line_separation` as an existing constant. This is fine for desktop density per D-06, but the constant should be documented as the desktop baseline value for Phase 8 scaling.
- **LOW**: The plan says "Reuse the Tree selected-row helper/recipe shape only if it prevents contrast or geometry drift." This conditional language (from the parent CONTEXT.md) could lead to divergence if too narrowly interpreted. The verifier's `itemlist-foldable` stage should assert that ItemList selected states use the same contrast semantics as Tree to prevent drift.

**Suggestions:**
- Task 1 should explicitly fix the `cursor`/`cursor_unfocused` recipe role from `state_hover` (opaque) to a transparent/semi-transparent state overlay.
- Add `font_outline_color` and `scroll_hint_color` color bindings to ItemList BINDING_TABLE.
- Add explicit icon mapping: `folded_arrow`→`disclosure_collapsed.svg`, `expanded_arrow`→`disclosure_expanded.svg`, and their mirrored variants.
- The verifier `itemlist-foldable` stage should assert `cursor.bg_color.a < 1.0` to prevent opaque cursor regression.

**Risk Assessment:** LOW-MEDIUM — The Foldable slot-name fix eliminates the highest risk. The main remaining risk is the opaque cursor binding (existing bug), which would visibly break ItemList appearance.

---

## 06-04-PLAN.md — TabBar and TabContainer

**Summary:** The shared tab model is correctly designed. The icon strategy is sound. The missing `button_highlight`/`button_pressed` stylebox entries on TabBar are a gap that needs address.

**Strengths:**
- Shared stylebox construction between TabBar and TabContainer for overlapping slots (D-08 compliance).
- Correctly uses existing `DIRECTION_PRESETS.shape.tab_radius` and `raised_lifts.selected_tab/unselected_tab` values.
- Sensible icon approach: reuse existing `close.svg`, create only increment/decrement/drop_mark/menu icons.
- Correctly avoids binding `tab_separation` (confirmed missing by probe).
- Highlight variants correctly reuse same SVG assets (color slots drive tint, not separate files).

**Concerns:**
- **HIGH**: The probe shows TabBar has `button_highlight` and `button_pressed` stylebox slots (for overflow navigation buttons). The current BINDING_TABLE.TabBar (line 1334-1356) covers only 5 tab styleboxes — these button slots are **missing**. The plan mentions "Implement TabBar button slots (button_highlight, button_pressed) as small icon-button surfaces" but doesn't list these as explicit BINDING_TABLE additions. If these slots are not populated, TabBar overflow buttons render with engine-default chrome, breaking visual consistency.
- **HIGH**: The TabContainer icon slot `menu`/`menu_highlight` is listed in the probe. The plan's icon creation only creates `tab_menu.svg`. The BINDING_TABLE must have **two** separate icon recipe entries for `menu` and `menu_highlight` that both resolve to `tab_menu.svg`. The plan doesn't explicitly state this wiring — the executor must infer that `menu_highlight` reuses the base SVG.
- **MEDIUM**: The current BINDING_TABLE.TabContainer covers only 5 of 10 colors. The plan's Task action says "Implement... official icon slots" but doesn't enumerate missing color slots: `font_outline_color`, `icon_disabled_color`, `icon_hovered_color`, `icon_selected_color`, `icon_unselected_color`. Same gap for TabBar which has `font_outline_color` and icon color slots.
- **MEDIUM**: TabBar currently has only `h_separation` constant. The probe shows 4 constants: `h_separation`, `hover_switch_wait_msec`, `icon_max_width`, `outline_size`. Missing `hover_switch_wait_msec`, `icon_max_width`, and `outline_size`. TabContainer has 4 constants: `icon_max_width`, `icon_separation`, `outline_size`, `side_margin`. The current TabContainer BINDING_TABLE has zero constants — all 4 need adding.
- **MEDIUM**: The current tab construction uses `role: surface_high` for selected and `role: surface_low` for unselected. D-08 says "active tabs read as connected to content." The visual connection between selected tab and TabContainer panel requires the `tab_selected` bottom corners to visually merge with `TabContainer.panel` top edge. The current recipe uses uniform corner radii (from `shape.tab_radius`) which prevents visual attachment (selected tab appears as a detached chip). To achieve attachment, the selected tab's `corner_radius_bottom_left` and `corner_radius_bottom_right` should be set to 0 while `corner_radius_top_left` and `corner_radius_top_right` use `shape.tab_radius`. This requires a narrow tab-specific helper that overrides `_set_radius_all` behavior — the plan doesn't address this.
- **LOW**: The plan's `_make_tab_stylebox` pattern in RESEARCH.md always sets `sb.border_color = role_table.outline_color`. For selected tabs, a `role_primary` border may better enforce the "connected to content" visual. This is a taste decision delegated to the executor per D-01.

**Suggestions:**
- Task 2 should explicitly add `button_highlight` and `button_pressed` stylebox entries to BINDING_TABLE.TabBar (even if they map to `state_hover`/`state_pressed` with the same small-button geometry).
- Add all missing color slots for both TabBar and TabContainer (font_outline_color, icon color family).
- Add all missing constant slots: `hover_switch_wait_msec: 0` (project choice — no hover delay), `icon_max_width`, `outline_size`, `icon_separation`, `side_margin`.
- Create a narrow `_make_tab_selected_stylebox` helper that zeroes bottom radii for the "attached to panel" visual effect.
- Explicitly wire `menu_highlight` to the same `tab_menu.svg` icon in the BINDING_TABLE recipe.

**Risk Assessment:** MEDIUM — The shared tab model is well-designed but the missing `button_highlight`/`button_pressed` styleboxes on TabBar are a real visual gap, and the missing color/constant slots create incomplete coverage.

---

## 06-05-PLAN.md — Range Controls, Containers, Round-Trip Verification

**Summary:** The right final wave. Closes COV-04 and contributes to COV-07. The ResourceSaver round-trip is the correct phase-closing mechanism. Icon volume (~22 SVGs) is the main complexity.

**Strengths:**
- Correctly creates ScrollBar directional icons (left/right for H, up/down for V) while respecting `decrement`/`increment` official slot names.
- Properly avoids binding `scrollbar_h_separation`/`scrollbar_v_separation` (confirmed missing from probe).
- Layout-only containers get constants only (D-18 compliance).
- ResourceSaver round-trip pre- and post-verifier run provides strong data-integrity gates.
- Correctly reuses slider grabber/tick SVGs across normal/disabled/highlight slots.

**Concerns:**
- **HIGH**: The plan creates icons for `scrollbar_left.svg`, `scrollbar_right.svg`, `scrollbar_up.svg`, `scrollbar_down.svg` — but the **ScrollBar icon SLOT names** are `decrement`, `increment`, `decrement_highlight`, `increment_highlight`, `decrement_pressed`, `increment_pressed`. The BINDING_TABLE recipes must key by **slot name** (e.g., `"decrement": {"icon": "scrollbar_left"}` for HScrollBar, `"decrement": {"icon": "scrollbar_up"}` for VScrollBar). The plan mentions "Scrollbar increment/decrement icon recipes" but doesn't specify the slot-name→filename mapping. The executor needs explicit instruction: HScrollBar `decrement`→`scrollbar_left`, HScrollBar `increment`→`scrollbar_right`, VScrollBar `decrement`→`scrollbar_up`, VScrollBar `increment`→`scrollbar_down`. Highlight/pressed slots reuse the same SVG.
- **HIGH**: The current BINDING_TABLE has no entry for **ScrollContainer** at all (the 37-row freeze stops at Window). The probe shows ScrollContainer has `focus` and `panel` styleboxes, 2 colors (`scroll_hint_horizontal_color`, `scroll_hint_vertical_color`), and 2 icons (`scroll_hint_horizontal`, `scroll_hint_vertical`). The plan says "ScrollContainer gets focus, panel, scroll hint colors/icons" but there is no existing BINDING_TABLE entry to extend. The plan must explicitly create a new BINDING_TABLE.ScrollContainer entry. Same for HSplitContainer/VSplitContainer icon entries (current code only has constants, no icons). Same for HSeparator/VSeparator (current code has no entries).
- **HIGH**: The current HScrollBar BINDING_TABLE covers 5 styleboxes only — no icon entries. The plan must add the 6 decrement/increment icon recipe entries (normal + highlight + pressed, all reusing left/right SVGs). For VScrollBar, the 6 icon entries (normal + highlight + pressed, reusing up/down SVGs). The icon count is correct but the BINDING_TABLE wiring must be explicit.
- **MEDIUM**: Slider `grabber` vs `grabber_highlight` vs `grabber_disabled` — the plan only creates `slider_grabber.svg`. Highlight and disabled variants should reuse the same SVG file with different tints driven by color styleboxes rather than creating separate SVG files. This is the correct pattern (matching CheckBox disabled_icon reuse from Phase 5) but the plan should state this explicitly.
- **MEDIUM**: ProgressBar currently has only `font_color` in BINDING_TABLE. The probe shows `font_outline_color` also exists. D-14 says text colors must be themed — add `font_outline_color`. Also, ProgressBar has `outline_size` constant that should be set.
- **MEDIUM**: The plan creates `split_grabber_h.svg`, `split_grabber_v.svg`, `split_touch_dragger_h.svg`, `split_touch_dragger_v.svg` — 4 SVGs. But the SplitContainer base class also has `h_grabber`, `v_grabber` icon slots separate from HSplitContainer/VSplitContainer `grabber`/`touch_dragger` slots. The plan should clarify whether SplitContainer, HSplitContainer, and VSplitContainer all get icon bindings, or only the specific subclasses.
- **MEDIUM**: `CenterContainer` has zero theme slots per the probe. The plan correctly excludes it from binding. But the verifier must not flag it as uncovered.
- **LOW**: HScrollBar/VScrollBar currently use `"scroll_focus": {"role": "focus_ring"}` — this is correct per D-22 (uses official `scroll_focus` slot, not a combo). The verifier should assert `scroll_focus` but not `focus` on scrollbars.
- **LOW**: The ResourceSaver round-trip in Task 3 processes all 5 direction `.tres` files. The plan says "If ResourceSaver changes formatting but preserves the data-only contract, keep the canonicalized output" — this is ambiguous. If ResourceSaver produces different formatting (e.g., changes `format=3` to `format=3 uid=...`), the plan should specify acceptance criteria: script linkage preserved, all 9 exports preserved, no `[sub_resource]` blocks, no `theme_data/` entries, under 2048 bytes.

**Suggestions:**
- Add an explicit slot-name→icon-filename mapping table for ScrollBar and Slider icon entries, since the slot names (`decrement`/`increment`) don't match the filenames (`scrollbar_left`/`scrollbar_right`).
- List the new BINDING_TABLE entries needed for ScrollContainer (panel + focus styleboxes, 2 colors, 2 icons), SplitContainer (split_bar_background + touch_dragger colors + 4 icons), HSeparator/VSeparator (separator stylebox + separation constant).
- Explicitly state that `grabber_highlight`/`grabber_disabled` reuse `slider_grabber.svg` and `tick` reuse `slider_tick.svg`.
- Clarify SplitContainer vs HSplitContainer vs VSplitContainer icon scope.

**Risk Assessment:** MEDIUM — The plan covers all the right Controls but the BINDING_TABLE expansion surface is large (ScrollContainer, Separator, MarginContainer, HBox, VBox, Flow, Grid) and the ScrollBar icon slot-name-to-filename mapping needs to be precise. Missing a single slot leaves engine-default chrome.

---

## Overall Risk Assessment: MEDIUM

The 5 plans have a sound overall structure and correctly prioritize slot-freeze before polish. No plan violates locked architecture constraints (single class, data-only `.tres`, no new exports, no subclasses). The main risks are:

1. **Under-specification of BINDING_TABLE expansion targets** — Plans 02-05 say what to theme but not the exact lists of slots to add. Executors must cross-reference the probe log themselves, introducing risk of omission.
2. **Existing opaque cursor bug in ItemList** (06-03) — not explicitly called out as a fix.
3. **Missing TabBar `button_highlight`/`button_pressed` styleboxes** (06-04) — identified in prose but not in BINDING_TABLE expansion tasks.
4. **Missing ScrollContainer BINDING_TABLE entry** (06-05) — the plan assumes an entry exists to extend, but there isn't one.
5. **Icon volume (~38 SVGs with import sidecars)** is substantial and the plans somewhat under-emphasize the authoring and import workload across all 5 plans.

**Recommendation:** Address the HIGH concerns above before execution — specifically: enumerate BINDING_TABLE expansion targets per plan, fix the ItemList cursor bug explicitly, add ScrollContainer/Separator as explicit new entries in 06-05, and add the missing TabBar button styleboxes. The overall 5-wave approach is approved.


---

## Consensus Summary

Only OpenCode was invoked for this requested review cycle, so this section summarizes current OpenCode findings rather than cross-reviewer agreement.

### Agreed Strengths

- The five-plan wave order is sound: slot freeze, Tree, list/foldable, tabs, then range/container closeout.
- The plans preserve the locked single-class/data-only `.tres` architecture and do not introduce new exports or subclasses.
- The verifier and ResourceSaver round-trip emphasis is appropriate for a Godot Theme phase with many official slots.

### Agreed Concerns

- HIGH: Tree slot freeze must expand to the full Godot 4.6.2 Tree surface, including `custom_button` and `hovered_dimmed`, and must target the Tree `hover` BINDING_TABLE key precisely.
- HIGH: Tree color/icon expansion is under-specified, including missing explicit mappings for `indeterminate_disabled`, `arrow`, and nine Tree colors.
- HIGH: ItemList cursor recipes currently use opaque `state_hover` and need an explicit transparent/semi-transparent overlay fix.
- HIGH: TabBar/TabContainer need explicit overflow/button/menu-highlight stylebox and icon wiring, plus fuller color/constant coverage.
- HIGH: Range/container plans must explicitly add new ScrollContainer entries and exact ScrollBar slot-name-to-SVG mappings.

### Divergent Views

- None. Only OpenCode was run by request.
