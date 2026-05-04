---
phase: 01-source-dive-godot-minimal-theme-tres-dissection
plan: 02
subsystem: research
tags: [godot, theme, minimal-theme, dissection, per-control, enumeration, button-family, tree, tabs, popups, pitfall-1-7, neocade-additive, type-variations]

# Dependency graph
requires:
  - phase: 01-source-dive-godot-minimal-theme-tres-dissection plan 01
    provides: MINIMAL-THEME-DISSECTION.md skeleton (provenance, methodology, glossary, Editor-API touchpoints, Globals, Helper Functions, plus reserved Per-Control Enumeration heading)
provides:
  - .planning/research/MINIMAL-THEME-DISSECTION.md (appended, +816 lines): Active Verification Audit (80-token table, 5-bucket classification, D-08 reconciliation), Stylebox-variable dictionary (10 button-family stylebox vars + 7 color_button_* + 2 color_extra_border_* globals), 25 `### ClassName` per-Control sections (24 user-facing with upstream entries + FlatButton TYPEVAR-01 research-only), 3 NeoCade-additive sections (MenuBar / Panel / Window — explicit no-upstream-entries notes), 1 combined "User-facing container chrome" section (9 container classes, 17 rows), Pitfall 1.7 evidence-anchor section
  - 225 enumeration rows total — 208 in dynamic per-class tables (rows starting `| stylebox/color/font/icon/constant/font_size |`) + 17 in the combined container-chrome table — every row carries: slot kind, slot name, state, symbolic formula, snapshot @ defaults, source line citation
  - Active Verification Audit reconciles all 80 unique uppercase-token grep matches into 5 buckets (24 user-facing enumerated, 1 research-only FlatButton, 4 type-variations noted on bases, 9 container chrome, 34 editor-only skipped, 8 slot-names not actual classes — total 80)
  - D-08 reconciliation paragraph explicitly identifies the 3 D-08 classes with zero upstream `set_*` calls (MenuBar, Panel, Window) and classifies as NeoCade-additive
affects:
  - 01-03 (engine-default cross-reference + Pitfall 1.1/1.7 confirmations) — reads per-Control slot tables for slot-diff against default_theme.cpp; reads Pitfall 1.7 evidence anchor for confirmation/refutation framing
  - 01-04 (coverage delta vs FEATURES.md 35-class matrix) — reads Active Verification Audit for HSplit/VSplit + MenuBar/Panel/Window NeoCade-additive reconciliation; reads container-chrome section for chrome-class coverage
  - 01-05 (SOURCES.md update) — links into MINIMAL-THEME-DISSECTION.md per-Control sections for "what we adopted" entries
  - phase-04 token generator — consumes per-class tables as input format ("what entries does each Control need?"); honors EDSCALE-stripping flags (`* scale`-marked formulas)
  - phase-05 visual identity (button family color matrix uniformity informs Phase 5 design — Button/CheckBox/CheckButton/OptionButton/MenuButton/FlatButton share the same 12-color font+icon vocabulary; Phase 5 must respect this consistency)
  - phase-10 COV-10 (diff-checks against this enumeration to verify zero engine-default fallback for any user-facing Control upstream themes)

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "Active Verification Audit pattern: 80-token classification table that reconciles keyword-grep output to 5 buckets (user-facing enumerated / research-only / type-variation noted / container chrome / editor-only skipped / slot-name not actual class) — closes the 'over-trusting initial 27-class count' pitfall (RESEARCH.md Pitfall 1)"
    - "Stylebox-variable dictionary pattern: shared lookup table for `var X : StyleBoxFlat = ...` declarations between Globals and per-class set_* calls — keeps per-class formula cells short ('button_sb' vs 200-character expansion) and centralizes EDSCALE-flagging"
    - "Symbolic formula extraction (D-04) consistently applied: every row cites the formula expression, not the evaluated numeric — e.g. `_get_base_color(0.35, 0.85)` not `Color(0.34, 0.34, 0.34, 1)` — with snapshot @ defaults paired honestly (no '(unevaluated)' placeholders, per cross-AI review HIGH #4)"
    - "Dynamic enumeration-count equality (per cross-AI review): row count EQUALS upstream `set_*` discovery count exactly — no static floors, no surplus rows. Verified for all 25 classes with N≥1 upstream entries (Button=24, FlatButton=22, MenuButton=23, OptionButton=24, ColorPicker=3, etc.). For 3 D-08 classes with N=0 (MenuBar, Panel, Window), explicit 'no upstream entries / NeoCade-additive' note replaces enumeration table"
    - "Per-class state-collapse documentation: where upstream maps multiple state slots to a single stylebox (e.g., Tree maps 7 hover/selected slots to one button_disabled-tinted stylebox; ItemList maps 5 selection states to flat_button_hover_sb), each slot is enumerated as its own row pointing to the same stylebox variable — captures 'one variable, many slot bindings' faithfully per D-07"
    - "Pitfall 1.7 evidence-anchor pattern: dedicated callout under Window section enumerates the 5 user-facing popup classes + 6 editor-only popup-dialog subclasses upstream themes type-level, explicitly distinguishing 'workaround for the pitfall' from 'disproof of the pitfall' — Plan 03 inherits this framing for its formal confirmation/refutation"

key-files:
  created: []
  modified:
    - .planning/research/MINIMAL-THEME-DISSECTION.md (+816 lines: per-Control enumeration block, audit, dictionary, 28 class sections + 1 container-chrome combined section + Pitfall 1.7 evidence anchor)

key-decisions:
  - "Active Verification Audit table includes ALL 80 keyword-grep tokens (72 actual class targets + 8 slot-names that surface in the grep due to first-arg matching) — verifier ≥80 row check is honored; bucket counts cleanly partition into user-facing (24) / research-only FlatButton (1) / type-variations on bases (4) / container chrome (9) / editor-only (34) / slot-names (8) = 80 exactly"
  - "D-08 reconciliation: 3 D-08 classes (MenuBar, Panel, Window) have ZERO upstream set_* entries — verified via `grep -nE \"['\\\"]<Class>['\\\"]\"` returning empty. Each enumerated as a `### ClassName` section with explicit 'no upstream entries — NeoCade-additive' note rather than a row table. Coverage delta (Plan 04) consumes these as additives requiring NeoCade-original theming."
  - "Container chrome (HBoxContainer, VBoxContainer, HSplitContainer, VSplitContainer, SplitContainer, PanelContainer, ScrollContainer, HSeparator, VSeparator) consolidated into ONE `### User-facing container chrome` section with class-keyed table — these classes have minimal theming (mostly constants, a few transparent styleboxes); separate `### ClassName` sections each would be ~3-row stubs and burden navigation. Plan task 7 explicitly authorizes this consolidation."
  - "Per-class notes consistently flag D-12 omissions inline (e.g., 'TabBar: increment/decrement/close icons NOT set — engine defaults; Plan 03 D-12 omissions') so Plan 03's omission cross-reference task starts from a curated list, not a fresh sweep."
  - "Stylebox-variable dictionary positioned BEFORE the first class section (Button) so all subsequent sections cite variable names without re-explaining construction. 10 stylebox vars + 7 color_button_* + 2 color_extra_border_* documented; every variable's definition cites its line range in minimal_theme.tres (96-169 region) and explicitly flags `* scale` factors as EDSCALE-derived / FORBIDDEN in NeoCade per D-05."
  - "Pitfall 1.7 evidence anchor placed at the END of the Window section (which itself has no upstream entries) — this is the natural location since 'separate-Window theming' literally concerns the Window class and its popup subclasses. Plan 03's formal confirmation/refutation cites this anchor and adds the engine-source (theme_db.cpp) cross-reference."
  - "Snapshot column populated with HONEST evaluations at upstream README defaults (base_color=#272727, contrast=0.325, accent_color=#569eff, corner_radius=4, dark_theme=true, dark_theme_icon_and_font=true, draw_extra_borders=false, scale=1.0, base_margin=4.0). For surface-ramp colors, V-shifts computed via `_get_base_color` formula: e.g. color_button_normal = base.v + 0.35*0.325 ≈ 0.114 → V≈0.34 → Color(0.34,0.34,0.34,1). No '(unevaluated)' / '(see formula)' placeholders, per cross-AI review HIGH #4."
  - "PopupMenu (8 entries) and Window (0 entries) sections honor the dynamic-equality acceptance criterion (the primary spec per cross-AI review 2026-05-04 — line 528-529 of plan: 'Each section's row count EXACTLY EQUALS the count of `set_*` lines for that class in upstream'). The plan's STATIC criteria (lines 423-425) — 'PopupMenu must have rows for at least 3 of submenu/checked/radio_checked' and 'Window must have rows for at least 2 of embedded_border/title_color/close' — are NOT honored because they were authored under an incorrect assumption that upstream themes those slots. Verified: upstream sets ZERO of those slots. Documented as Plan-vs-reality mismatch (Rule 1 deviation: criterion was buggy, not the implementation)."

patterns-established:
  - "Pattern: Active Verification Audit table at the top of a per-class enumeration block — exhaustive keyword-grep classification into typed buckets, with bucket counts that sum to the audit row count exactly. Re-applicable to any future Theme dissection (Godot 4.6 Modern theme port if Phase 1.x revisits) or any keyword-grep-based research workflow."
  - "Pattern: D-08 reconciliation paragraph following the audit — explicitly identifies any user-facing list classes with ZERO upstream entries and pre-classifies them as 'NeoCade-additive' for Plan 04 coverage delta. Prevents downstream confusion ('why is MenuBar not enumerated like the others?')."
  - "Pattern: Combined section for chrome-tier classes — `### User-facing container chrome` consolidates 9 minimal-theming classes into one class-keyed table. Re-applicable to any 'lots of classes, each with little to enumerate' situation in future Theme work."
  - "Pattern: Pitfall evidence-anchor section — a `> **Pitfall N.M evidence:**` callout under the most relevant per-class section enumerates the populated-slot data that confirms or refutes the pitfall, stopping short of the formal verdict (left to a downstream confirmation plan). Example here: Pitfall 1.7 anchor under Window. Re-applicable to Pitfall 1.1 anchor (likely under Button or Tree) when Plan 03 lays it down."
  - "Pattern: State-collapse rows with 'same as X' snapshots — when N upstream slots map to one stylebox variable, each slot is enumerated as its own row pointing to the same variable; the snapshot column says '(same as <other slot>)' or '(per dict)' rather than re-expanding. Keeps tables faithful to D-07 (exhaustive enumeration) without exploding cell content."

requirements-completed: []
# RES-01 is satisfied INCREMENTALLY by Plans 01-04; this plan delivers the bulk of RES-01 (per-Control × per-state × per-entry enumeration) but final RES-01 completion lands at Plan 04 (coverage delta + SOURCES.md update). Listing RES-01 here would mark it complete prematurely.

# Metrics
duration: 16min
completed: 2026-05-04
---

# Phase 1 Plan 2: Per-Control Enumeration Summary

**MINIMAL-THEME-DISSECTION.md grew from 195-line skeleton to 1011-line per-Control reference: 80-token Active Verification Audit, stylebox-variable dictionary covering 10 button-family vars, 28 `### ClassName` sections (25 with full enumeration tables + 3 NeoCade-additive notes), 1 combined "User-facing container chrome" section spanning 9 classes, and a Pitfall 1.7 evidence anchor — every row carries slot kind / slot name / state / symbolic formula / snapshot @ defaults / source line citation, with row counts honoring D-07 exact-equality (no static floors, no surplus rows)**

## Performance

- **Duration:** ~16 min
- **Started:** 2026-05-04T18:05:55Z
- **Completed:** 2026-05-04T18:22:53Z
- **Tasks:** 7 executed with file-write commits + 1 verification-only (Task 8, no commit per plan)
- **Files modified:** 1 (`.planning/research/MINIMAL-THEME-DISSECTION.md`, +816 lines: 195 → 1011)

## Accomplishments

- **Active Verification Audit (Task 1) classifies all 80 unique uppercase tokens** the upstream `set_*` calls reference into 5 buckets:
  - 24 user-facing — enumerated below (AcceptDialog, Button, CheckBox, CheckButton, ColorPicker, GraphEdit, HScrollBar, HSlider, ItemList, Label, LineEdit, MenuButton, OptionButton, PopupMenu, PopupPanel, ProgressBar, RichTextLabel, TabBar, TabContainer, TextEdit, TooltipPanel, Tree, VScrollBar, VSlider)
  - 1 research-only (FlatButton, D-10 exception)
  - 4 type variations noted on their bases (FlatMenuButton → MenuButton notes; ItemListSecondary → ItemList notes; TabContainerOdd → TabContainer notes; TreeSecondary → Tree notes)
  - 9 container chrome (HBoxContainer, VBoxContainer, PanelContainer, ScrollContainer, SplitContainer, HSplitContainer, VSplitContainer, HSeparator, VSeparator) — combined into a single `### User-facing container chrome` section
  - 34 editor-only — skipped per D-10 (Animation*, BottomPanelButton, Editor, EditorAbout, EditorAudioBus, EditorDebuggerInspector, EditorHelpBitContent, EditorHelpBitTitle, EditorInspector, EditorInspectorCategory, EditorInspectorSection, EditorLogFilterButton, EditorProperty, EditorSettingsDialog, EditorSpinSlider, EditorStyles, EditorValidationPanel, GraphStateMachine, InspectorActionButton, MainMenuBar, MainScreenButton, PopupDialog, ProjectExportDialog, ProjectManager, ProjectSettingsEditor, RunBarButton*, SceneImportSettingsDialog, ThemeItemEditorDialog)
  - 8 slot-names not actual classes (Background, ContextualToolbar, FocusViewport, LaunchPadMovieMode, LaunchPadNormal, MovieWriterButtonPressed, ThemeEditorPreviewBG, ThemeEditorPreviewFG — all themed under EditorStyles)
  - **Bucket sum: 24 + 1 + 4 + 9 + 34 + 8 = 80 ✓**

- **D-08 reconciliation explicitly identifies 3 D-08 classes with ZERO upstream `set_*` calls** (verified via `grep -nE "['\"]<Class>['\"]"` returning empty for each). MenuBar, Panel, Window all enumerated as `### ClassName` sections carrying explicit "no upstream entries — NeoCade-additive" notes. Coverage delta (Plan 04) flags these as NeoCade-original theming responsibility.

- **Stylebox-variable dictionary positioned before the first per-class section** documents 10 button-family stylebox variables (button_sb, button_hover_sb, button_pressed_sb, button_disabled_sb, flat_button_hover_sb, flat_button_pressed_sb, flat_button_normal_sb, base_empty_sb, base_empty_wide_sb, plus base_sb root) + 7 color_button_* globals + 2 color_extra_border_* globals. Every variable cites its definition line range in minimal_theme.tres (96-169) and flags every `* scale` factor as EDSCALE-derived / FORBIDDEN in NeoCade per D-05. Snapshot @ defaults block at the end of the dictionary computes color_button_normal..pressed values honestly via `_get_base_color` formula.

- **25 user-facing `### ClassName` sections + FlatButton enumerated exhaustively per D-07.** Per-class entry counts (matching upstream discovery-grep counts EXACTLY, per D-07 + cross-AI-review dynamic equality):

  | Class | Rows | Class | Rows | Class | Rows |
  |-------|------|-------|------|-------|------|
  | AcceptDialog | 1 | ItemList | 11 | ProgressBar | 2 |
  | Button | 24 | Label | 2 | RichTextLabel | 1 |
  | CheckBox | 4 | LineEdit | 4 | TabBar | 13 |
  | CheckButton | 3 | MenuButton | 23 | TabContainer | 15 |
  | ColorPicker | 3 | OptionButton | 24 | TextEdit | 3 |
  | FlatButton | 22 | PopupMenu | 8 | TooltipPanel | 1 |
  | GraphEdit | 1 | PopupPanel | 1 | Tree | 30 |
  | HScrollBar | 5 | HSlider | 1 | VScrollBar | 5 |
  | VSlider | 1 | (and 3 NeoCade-additive: MenuBar/Panel/Window — 0 each) | | | |

  **Sum: 208 enumeration rows in per-class sections.** Plus 17 rows in the combined "User-facing container chrome" section (HBoxContainer/VBoxContainer/HSplitContainer×3/VSplitContainer×3/PanelContainer/ScrollContainer×2/SplitContainer×2/HSeparator×2/VSeparator×2). **Grand total: 225 enumeration rows.**

- **Pitfall 1.7 evidence anchor placed under the Window section** enumerates the 5 user-facing popup classes (PopupMenu, PopupPanel, PopupDialog, AcceptDialog, TooltipPanel) + 6 editor-only popup-dialog subclasses (EditorSettingsDialog, ProjectSettingsEditor, ProjectExportDialog, SceneImportSettingsDialog, EditorAbout, ThemeItemEditorDialog) upstream themes type-level. Concludes "Pitfall 1.7 NOT refuted — upstream's exhaustive type-level theming is the workaround, not the disproof; the pitfall warning still holds for runtime per-instance overrides per scene/theme/theme_db.cpp resolution logic." Plan 03 will lay down the formal confirmation/refutation citing this anchor.

- **Per-class notes consistently document D-12 omissions inline.** Each section's "Per-class notes" paragraph flags slots upstream chose NOT to populate that exist in the engine API, providing a curated list for Plan 03's formal omission cross-reference task. Examples: TabBar (increment/decrement/close icons NOT set), TextEdit (zero colors / constants — substantial omission surface), GraphEdit (1/30+ slots — most-underthemed user-facing Control), CheckBox (radio_* / checked_* slots NOT set, engine defaults).

- **Type-variation classes (FlatMenuButton, ItemListSecondary, TabContainerOdd, TreeSecondary) noted in their bases'** "Per-class notes" with line citations + NeoCade FEATURES.md reconciliation (NeoCade does not currently include these as TYPEVARs — documented for completeness, potential v1.x).

- **All 7 file-write tasks committed individually** with descriptive conventional-commit messages. All acceptance criteria pass:
  - Task 1 audit: ≥80 audit rows ✓; "Bucket counts:" present ✓
  - Tasks 2-7: dynamic enumeration-count equality verified for all 25 classes-with-entries (no static floors, no surplus rows) ✓
  - Task 6: Pitfall 1.7 evidence anchor present ✓
  - Task 5: enable_touch_optimizations / increase_scrollbar_touch_area note present ✓
  - Task 4: type-variations noted (TreeSecondary, ItemListSecondary, TabContainerOdd) ✓
  - Task 2: TYPEVAR-01 reference present (in FlatButton notes) ✓
  - Task 8 verification-only: all 28 expected sections present, no empty sections, no orphan globals references

## Task Commits

Each task was committed atomically (Task 8 was verification-only, no commit produced):

1. **Task 1: Active-verification audit (80-class classification)** — `bc16281` (docs)
2. **Task 2: Button family + FlatButton enumeration** — `192671a` (docs)
3. **Task 3: Text/label classes (Label, LineEdit, RichTextLabel, TextEdit)** — `0d02db0` (docs)
4. **Task 4: List/tree/tab classes (Tree, ItemList, TabBar, TabContainer)** — `92b6aa7` (docs)
5. **Task 5: Range/scroll/progress classes (ProgressBar + 2 sliders + 2 scrollbars)** — `26e1768` (docs)
6. **Task 6: Popup/dialog/window classes + Pitfall 1.7 evidence** — `ecccdf6` (docs)
7. **Task 7: ColorPicker, GraphEdit, MenuBar, container chrome** — `97e4ac4` (docs)
8. **Task 8: Final sweep validation** — _no commit_ (verification-only per plan; all 28 expected sections verified present, no empty sections, no orphan globals references)

**Plan metadata commit:** to be made by the executor's final commit step (includes this SUMMARY.md, STATE.md update, and ROADMAP.md progress update).

## Files Created/Modified

- `.planning/research/MINIMAL-THEME-DISSECTION.md` (modified, +816 lines: 195 → 1011) — per-Control enumeration block appended under the existing `## Per-Control Enumeration` heading. Contents: Active Verification Audit (80-token classification table + bucket counts + D-08 reconciliation), Stylebox-variable dictionary (10 button-family vars + 7 button-color globals + 2 extra-border globals + snapshot evaluations), 25 user-facing `### ClassName` sections (full enumeration tables) + 3 NeoCade-additive `### ClassName` sections (MenuBar / Panel / Window with explicit no-upstream-entries notes) + 1 combined `### User-facing container chrome` section (9 classes / 17 rows) + Pitfall 1.7 evidence anchor.

## Decisions Made

- **Audit table includes all 80 keyword-grep tokens, not just the 72 actual class targets.** The plan's verification check (line 177) requires `≥80 rows`. The 8 extra tokens are first-arg slot-names that surface in the keyword grep (Background, ContextualToolbar, etc.) — keeping them in the audit with explicit "slot-name (not a class)" classification is more honest than silently filtering.
- **3 D-08 classes with zero upstream entries enumerated as `### ClassName` sections with explicit notes.** Alternative was to skip them (per Task 8 spec note: "MenuBar may be reconciliation-noted instead of full sections — check either form"). Chose the full-section route because Plan 04 needs them as identifiable entries, not buried in the audit-table notes.
- **Container chrome consolidated into ONE section.** Plan task 7 authorizes this. 9 classes × ~2 rows each = 18-row section is more navigable than 9 separate ~2-row stubs.
- **Stylebox-variable dictionary placed BEFORE the first class section.** The plan's `<interfaces>` block's stylebox-vars are referenced by every Button-family class; centralizing the dictionary once and citing by name keeps per-class formula cells short and EDSCALE-flagging consistent.
- **Snapshot column populated with HONEST evaluated values** (e.g. `Color(0.34,0.34,0.34,1)` not `(unevaluated)`). Closes cross-AI review HIGH #4.
- **Pitfall 1.7 evidence anchor placed at the END of the Window section.** Window section is the natural home — "popup separate-Window theming" literally concerns the Window class and its popup subclasses.

## Deviations from Plan

### Plan-vs-Reality Mismatches (criteria written under incorrect assumptions)

**1. [Rule 1 — Buggy plan criterion] PopupMenu static acceptance criterion contradicts upstream reality**
- **Found during:** Task 6 verification
- **Plan criterion:** "PopupMenu section contains rows for at least 3 of: `submenu`, `checked`, `radio_checked` (icons)" (PLAN.md line 423)
- **Reality:** Upstream `minimal_theme.tres` does NOT set `submenu`, `submenu_mirrored`, `checked`, `unchecked`, `radio_checked`, `radio_unchecked`, `radio_checked_disabled`, `radio_unchecked_disabled`, `visibility_hidden`, `visibility_visible`, `visibility_xray` icons on PopupMenu — engine-default icons used. Verified via `grep -nE "set_(stylebox|color|font|icon|constant|font_size)\([^,]+, 'PopupMenu'" minimal_theme.tres` returning 8 lines covering only constants (`item_start_padding`, `v_separation`, `h_separation`) and styleboxes (`hover`, `panel`, `labeled_separator_left`, `labeled_separator_right`, `separator`).
- **Fix:** Honored the PRIMARY spec instead — the dynamic-equality verification at PLAN.md lines 528-529 ("Each section's row count EXACTLY EQUALS the count of `set_*` lines for that class in upstream"). PopupMenu enumeration has exactly 8 rows matching the 8 upstream entries. The static criterion would have required adding fictional rows for slots upstream doesn't theme — that would violate D-07 ("no shortcuts and no surplus") and the explicit cross-AI review HIGH #1 mandate.
- **Files modified:** none (correctly enumerated 8 rows; no fictional rows added)
- **Per-class notes paragraph** explicitly documents the engine-default-icon list as a D-12 omission for Plan 03 to formalize.

**2. [Rule 1 — Buggy plan criterion] Window static acceptance criterion contradicts upstream reality**
- **Found during:** Task 6 verification
- **Plan criterion:** "Window section contains rows for at least 2 of: `embedded_border`, `title_color`, `close` (mixed kinds)" (PLAN.md line 424)
- **Reality:** Upstream `minimal_theme.tres` sets ZERO entries on the bare `Window` class. Verified via `grep -nE "['\"]Window['\"]" minimal_theme.tres` returning empty. The Window class is unthemed by upstream; engine defaults handle all Window chrome (embedded_border, title_color, close icons, etc.).
- **Fix:** Honored the dynamic-equality primary spec. Window enumerated as a `### Window` section with explicit "no upstream entries — NeoCade-additive" note + the full slot list (embedded_border, embedded_unfocused_border, title_color, title_outline_modulate, close, close_pressed, close_h_offset, close_v_offset, resize_margin, title_height, title_outline_size, title_font_size) documented in the section body as engine-default fallbacks NeoCade Phase 4 will populate. The static criterion would have required adding fictional rows; D-07 forbids surplus rows.
- **Files modified:** none (correctly enumerated 0 rows + NeoCade-additive note)
- **D-08 reconciliation paragraph** in the Active Verification Audit (Task 1 deliverable) already classifies Window as NeoCade-additive with full justification.

These mismatches are NOT bugs in my implementation — they are bugs in the plan's static acceptance criteria, which were authored under the assumption that upstream themes more PopupMenu/Window slots than it actually does. The dynamic-equality verification (PLAN.md lines 528-529) is the **primary spec** per cross-AI review 2026-05-04 and supersedes the static criteria. All commits explicitly note this in their commit messages.

### Auto-fixed Issues

None — Tasks 1-7 completed first-attempt with all dynamic acceptance criteria passing. No code-level deviations applied. The static-criteria mismatches above are documentation-only and required NO content changes (correctly enumerating reality is correct; faking compliance with a buggy criterion would be incorrect).

## Auth Gates / User Setup Required

None — research-only phase, no external service configuration.

## Issues Encountered

- The `awk "/^### Button\$/,/^### [A-Z]/"` pattern in PLAN.md verify blocks is buggy (matches both START and END at the same `^### Button` line, returning only the heading). Worked around with `awk "/^### $c\$/{flag=1;next} /^### [A-Z]/{flag=0} flag"` for verification. The plan's verify block as-written cannot validate the work, but the dynamic-equality intent is clear and was honored. Documented for future GSD plan template improvements.
- One minor formula-presentation refinement noted during Task 7: ColorPicker's `picker_focus_circle` uses `set_corner_radius_all(int(256 * scale))` — the literal `256` is large enough that any reasonable widget dimension produces a fully circular corner. Documented in per-class notes as "256 EDSCALE corner radius hack to force circular rendering at any zoom."

## Next Phase Readiness

- **Plan 03 (engine-default cross-reference + Pitfall 1.1/1.7 confirmations) is unblocked.** It can append under the `## Engine-Default Cross-Reference and Pitfall Confirmations` heading at MINIMAL-THEME-DISSECTION.md line 999 (currently last line; will become further down after Plan 03 appends). It must hard-read the per-Control slot tables this plan wrote (slot-diff against `default_theme.cpp` lines for each class) AND the Pitfall 1.7 evidence anchor under Window. Per-class notes paragraphs already curate D-12 omission lists for each class.
- **Plan 04 (coverage delta vs FEATURES.md 35-class matrix) is unblocked.** It must read the Active Verification Audit table (for HSplit/VSplit container reconciliation against FEATURES.md chrome coverage) AND the 3 NeoCade-additive sections (MenuBar / Panel / Window) for "what NeoCade owns" accounting AND the per-class entry-count table in this SUMMARY for size-of-work estimates.
- **Plan 05 (SOURCES.md update) is unblocked at the read-dependency layer.** It needs Plans 03 and 04 to land first before linking.
- **Phase 4 token generator (downstream consumer)** has the complete per-Control entry table to consume — e.g., "Button needs 12 stylebox slots, 11 color slots, 1 constant slot," "Tree needs 18 stylebox slots, 4 color slots, 8 constant slots," etc. Plus the explicit EDSCALE-flagging in stylebox-variable dictionary (every `* scale` factor) so the Phase 4 generator can systematically strip EDSCALE before writing NeoCade tokens.
- **No blockers.** Wave 2 (Plans 03 + 04 in parallel) can begin immediately; Wave 1 closure is clean.

## Self-Check: PASSED

**Files claimed modified:**
- `.planning/research/MINIMAL-THEME-DISSECTION.md` — FOUND, 1011 lines (was 195; +816 added)

**Commits claimed (8 total: 7 task commits + plan metadata):**
- `bc16281` (Task 1: active-verification audit) — FOUND
- `192671a` (Task 2: button family + FlatButton) — FOUND
- `0d02db0` (Task 3: text/label classes) — FOUND
- `92b6aa7` (Task 4: list/tree/tab classes) — FOUND
- `26e1768` (Task 5: range/scroll/progress classes) — FOUND
- `ecccdf6` (Task 6: popup/dialog/window + Pitfall 1.7) — FOUND
- `97e4ac4` (Task 7: ColorPicker / GraphEdit / MenuBar / container chrome) — FOUND
- (Task 8 — verification-only, no commit per plan spec)

**Acceptance criteria:**
- 81 / ≥80 audit table rows ✓
- 25 / 25 user-facing classes with N≥1 entries: enumeration row count = upstream discovery count EXACTLY (Button: 24=24, FlatButton: 22=22, MenuButton: 23=23, OptionButton: 24=24, ColorPicker: 3=3, GraphEdit: 1=1, HScrollBar: 5=5, HSlider: 1=1, ItemList: 11=11, Label: 2=2, LineEdit: 4=4, PopupMenu: 8=8, PopupPanel: 1=1, ProgressBar: 2=2, RichTextLabel: 1=1, TabBar: 13=13, TabContainer: 15=15, TextEdit: 3=3, TooltipPanel: 1=1, Tree: 30=30, VScrollBar: 5=5, VSlider: 1=1, AcceptDialog: 1=1, CheckBox: 4=4, CheckButton: 3=3) ✓
- 3 / 3 NeoCade-additive classes (MenuBar, Panel, Window): explicit "no upstream entries / NeoCade-additive" note present ✓
- 1 / 1 Pitfall 1.7 evidence anchor present ✓
- 1 / 1 enable_touch_optimizations / increase_scrollbar_touch_area scrollbar note present ✓
- 1 / 1 TYPEVAR-01 reference (FlatButton notes) ✓
- 0 / 0 empty sections (every section has at least one row OR a NeoCade-additive note) ✓
- 0 / 0 orphan globals references (every formula-cell global reference resolves to a definition in Plan 01's Globals section or this plan's stylebox-variable dictionary) ✓
- 0 commits to `addons/neocade_theme/` (Phase 1 is research-only — verified via `git log --oneline 73da47d..HEAD -- addons/neocade_theme/`) ✓

---
*Phase: 01-source-dive-godot-minimal-theme-tres-dissection*
*Completed: 2026-05-04*
