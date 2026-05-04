---
phase: 01-source-dive-godot-minimal-theme-tres-dissection
plan: 03
subsystem: research
tags: [godot, theme, default_theme, theme_db, base_button, popup, window, focus-stylebox, separate-window, pitfall-confirmation, engine-source-cross-reference]

# Dependency graph
requires:
  - phase: 01-source-dive-godot-minimal-theme-tres-dissection
    provides: "Plan 01 — provenance + globals + helpers + ## Engine-Default Cross-Reference and Pitfall Confirmations placeholder section"
  - phase: 01-source-dive-godot-minimal-theme-tres-dissection
    provides: "Plan 02 — per-Control upstream-populated slot enumeration for 28 user-facing classes (Button, CheckBox, CheckButton, FlatButton, MenuButton, OptionButton, Label, LineEdit, RichTextLabel, TextEdit, ItemList, TabBar, TabContainer, Tree, ProgressBar, HSlider, VSlider, HScrollBar, VScrollBar, AcceptDialog, Panel, PopupMenu, PopupPanel, TooltipPanel, Window, ColorPicker, GraphEdit, MenuBar) + container chrome rollup"
provides:
  - "Engine-source anchor (NOT-A-GIT-REPO; mtime 2026-05-01 18:12:23 -0700; version.py confirms Godot 4.7-beta — newer than NeoCade's 4.6 target)"
  - "30 per-Control omission tables + 3 all-populated notes covering 28 user-facing classes' default_theme.cpp slot diff against upstream populations"
  - "Pitfall 1.1 (focus stylebox overlay) confirmation with engine evidence (button.cpp lines 222-230 + 290-303; base_button.cpp focus state machinery) + theme-resource evidence (minimal_theme.tres focus = base_empty_sb at lines 271, 581, 690, 787, 859-861, 926; composite-state hover_pressed populated at lines 260, 274, 283, 295, 471, 486, 649, 668, 679, 697)"
  - "Pitfall 1.7 (popup separate-Window theming) confirmation with Layer A/Layer B distinction (theme_db.cpp 365-374 + 380-383 class-hierarchy walk; window.cpp 67-95 per-Window override maps; theme_db.cpp 217-263 per-Window ThemeContext propagation; popup.cpp Popup-extends-Window proof; minimal_theme.tres 714, 735, 743, 748, 749 popup panel populations)"
  - "Critical 4.7-only? markers on 5 entries (CheckBox.checkbox_*_color, CheckButton.button_*_color, MenuButton.font_hover_pressed_color, PopupMenu.gutter_compact) flagging Phase 4 must verify against 4.6-stable release tag"
affects: [phase-04-token-generator, phase-05-focus-rings, phase-06-popup-theming, phase-07-coverage-completion, phase-10-coverage-verification]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "Pitfall confirmation pattern: explicit two-fold evidence (engine source for behavior + theme resource for upstream response) with literal source-line citations and CONFIRMED/REFUTED verdict"
    - "Layer A vs Layer B distinction for per-class-vs-per-instance theme inheritance — applies to popup, dialog, and any Window-derived Control class"
    - "Engine-version anchoring discipline: SHA when available, mtime + version.py extraction when ZIP-extracted, ENGINE-VERSION-CAVEAT marker when neither pins ≥ target version"

key-files:
  created:
    - .planning/phases/01-source-dive-godot-minimal-theme-tres-dissection/01-03-omission-and-pitfalls-SUMMARY.md
  modified:
    - .planning/research/MINIMAL-THEME-DISSECTION.md (appended ~660 lines under `## Engine-Default Cross-Reference and Pitfall Confirmations` placeholder; total file grew from 1011 → 1683 lines)

key-decisions:
  - "Engine source = Godot 4.7-beta (ZIP snapshot; version.py confirms major=4 minor=7 patch=0 status=beta) — newer than NeoCade's 4.6 target. Caveat applied inline; 4.7-only? markers flag any per-class entries that may not exist in 4.6-stable."
  - "FlatButton has 0 default_theme.cpp declarations — it is a Button TYPEVAR, not a base Control class. Documented as 'all engine-declared slots populated by upstream' since there are no engine declarations to omit."
  - "Pitfall 1.1 evidence chain spans both base_button.cpp (focus event/state machinery via status.pressed_down_with_focus + set_focus_mode) and button.cpp (focus draw-as-overlay at NOTIFICATION_DRAW lines 228-230 + DRAW_NORMAL precedence at lines 290-303). Both files cited; the original plan body said 'base_button.cpp' but the actual draw logic lives in button.cpp's NOTIFICATION_DRAW (its descendant). Documented this distinction in a 'Note on file selection' callout."
  - "Pitfall 1.7 evidence is structurally three-fold: theme_db.cpp class-hierarchy walk (Layer A applies because of the walk), window.cpp per-Window override maps (Layer B does NOT cross because each Window owns its own), theme_db.cpp ThemeContext propagation (the structural reason override bags do not chain across Window boundaries — each child Window short-circuits at line 264-265 with its own ThemeContext entry). All three citations are in the section."
  - "Pitfall 1.7 found upstream gap: upstream does NOT populate `pressed_focus` / `checked_focus` slots, only `hover_pressed` and font_hover_pressed_color. NeoCade Phase 5 must close this gap (REQUIREMENTS.md FOC-01/FOC-02 plus accessibility-driven extra coverage)."

patterns-established:
  - "Per-class omission table format: 6-column (Slot kind / Slot name / State / default_theme.cpp line / Upstream behavior / Implication for NeoCade) — every row decides 'Populate' vs 'Follow upstream' explicitly. Phase 4 token generator can scan the 'Implication for NeoCade' column directly to drive TokenSet structure."
  - "Upstream-orphaned table pattern: separate from omission table, captures slots upstream sets but engine does not pre-declare. _mirrored variants are most common — RTL fallback works via Godot's stylebox-suffix lookup, so 'orphaned' is misleading; flagged in a reading note."
  - "Pitfall confirmation/refutation section template: (1) Pitfall claim verbatim, (2) Engine-source evidence with literal source-line citations + relevant code excerpts, (3) Theme-resource evidence with line-anchored upstream citations, (4) Conclusion with explicit CONFIRMED verdict + Implication for NeoCade actionable directive."

requirements-completed: [RES-01]

# Metrics
duration: ~25min
completed: 2026-05-04
---

# Phase 01 Plan 03: Omission and Pitfalls Summary

**Engine-source cross-referenced 28 user-facing Controls against `default_theme.cpp` slot declarations, then confirmed Pitfalls 1.1 (focus overlay) and 1.7 (popup separate-Window theming) directly from `button.cpp` / `base_button.cpp` / `theme_db.cpp` / `window.cpp` / `popup.cpp` source plus `minimal_theme.tres` line-anchored response evidence.**

## Performance

- **Duration:** ~25 min
- **Started:** 2026-05-04T11:21:00Z (approximately, when worktree branch was created and first read happened)
- **Completed:** 2026-05-04T (commit time of final task — see Task 4 commit)
- **Tasks:** 4 of 4 complete
- **Files modified:** 1 (`.planning/research/MINIMAL-THEME-DISSECTION.md` — appended ~660 lines under the placeholder section)

## Accomplishments

- Anchored engine source to Godot 4.7-beta ZIP snapshot at `/c/Programming_Files/Godot/godot-master/` with explicit caveat that NeoCade targets 4.6 (so 4.7-only? markers identify entries Phase 4 must re-verify)
- Built per-Control omission tables for **28 user-facing Controls** plus 2 upstream-orphaned tables (Button, MenuButton — _mirrored / hover_pressed) plus 3 all-populated notes (FlatButton, PopupPanel, TooltipPanel) — total 33 per-Control omission outcomes, well above the 20-entry plan threshold
- Confirmed **Pitfall 1.1** (focus stylebox overlay) with engine evidence at `button.cpp` lines 222-230 (focus drawn as overlay AFTER state stylebox) + 290-303 ("Focus colors only take precedence over normal state" inline comment), `base_button.cpp` 214/258/292/319 (focus state-machine via status.pressed_down_with_focus) + line 652 (set_focus_mode(FOCUS_ALL)), and `default_theme.cpp` 285/324 (composite hover_pressed declarations on CheckBox/CheckButton)
- Confirmed **Pitfall 1.7** (popup separate-Window theming) with Layer A/Layer B distinction backed by `theme_db.cpp` 365-374 + 380-383 (class-hierarchy walk via `ClassDB::get_parent_class_nocheck`), `window.cpp` 67-95 (each Window owns separate `theme_*_override` maps), `popup.cpp` 54/70/171/321 + `window.cpp` 682 (Popup extends Window, `is_embedded()` per-instance), and `theme_db.cpp` 217-263 (per-Window `ThemeContext` propagation; child Window short-circuit at line 264-265)
- Identified **upstream's gap on `pressed_focus` / `checked_focus`**: upstream does NOT populate composite-focus slots — focus indication is invisible when stacked with pressed/checked. NeoCade Phase 5 must close this gap (Implication for NeoCade item 2 in Pitfall 1.1 section)

## Task Commits

Each task was committed atomically:

1. **Task 1: Anchor engine-source reference + write Engine-Default Cross-Reference subsection header** — `6a8af41` (docs)
2. **Task 2: Per-Control omission tables for 28 user-facing classes** — `57cde13` (docs)
3. **Task 3: Pitfall 1.1 (focus stylebox overlay) confirmation section** — `bc406bb` (docs)
4. **Task 4: Pitfall 1.7 (popup separate-Window theming) confirmation section** — `176eca3` (docs)

## Files Created/Modified

- `.planning/research/MINIMAL-THEME-DISSECTION.md` — Appended `## Engine-Default Cross-Reference and Pitfall Confirmations` section (~660 lines added under existing placeholder; file grew from 1011 → 1683 lines). Subsections:
  - `### Engine-Default Cross-Reference` — engine-source anchor + methodology + 30 per-Control omission/orphan tables + 3 all-populated notes
  - `### Pitfall 1.1 — Focus Stylebox Overlay Behavior (Confirmation)` — engine + theme evidence + CONFIRMED verdict + 4-item NeoCade Phase 5 directive
  - `### Pitfall 1.7 — Popup Separate-Window Theming (Confirmation)` — Layer A / Layer B distinction + engine + theme evidence + CONFIRMED verdict + 8-class popup type-theming directive

## Decisions Made

- **Engine source = Godot 4.7-beta** (ZIP-extracted to `/c/Programming_Files/Godot/godot-master/`; not a git clone). version.py confirms `major=4 minor=7 patch=0 status="beta"`. Since 4.7-beta > NeoCade's 4.6 target, no `ENGINE-VERSION-CAVEAT` marker was required (the conditional check passes), but I explicitly inlined a per-class "4.7-only? — verify in 4.6" marker on five entries that may not exist in 4.6-stable: `CheckBox.checkbox_checked_color` / `checkbox_unchecked_color`, `CheckButton.button_checked_color` / `button_unchecked_color`, `MenuButton.font_hover_pressed_color`, `PopupMenu.gutter_compact`. Phase 4 token generator MUST re-verify these against `godotengine/godot@4.6-stable`.
- **FlatButton handled as TYPEVAR not Control:** the engine grep returned 0 lines for FlatButton, confirming it is a Button type variation registered through Godot's `set_theme_type_variation` mechanism, not a base Control class. The omission table for FlatButton is therefore an "all engine-declared slots populated by upstream" note (no engine declarations exist to omit).
- **`base_button.cpp` vs `button.cpp` evidence split:** the plan instructed me to find focus draw logic in `base_button.cpp`, but the actual draw code lives in `button.cpp` (the concrete descendant with `NOTIFICATION_DRAW`). I cited BOTH files: `base_button.cpp` for focus-state-machinery evidence (status.pressed_down_with_focus, set_focus_mode(FOCUS_ALL)), and `button.cpp` for focus-as-overlay drawing evidence (lines 222-230). Added a "Note on file selection" callout to make the split explicit.
- **Pitfall 1.7 Layer A/Layer B explicit callout:** the section's "Critical distinction" callout (matching CONTEXT.md D-13 framing per RESEARCH.md Pitfall 4) is mandatory and present. Conflating Layer A (resource-level type entries that DO apply) with Layer B (runtime per-Control override bags that do NOT cross Window boundaries) produces broken popup theming — both are true; both must be understood separately.

## Deviations from Plan

### Auto-fixed issues

**1. [Rule 1 - Bug] Restored main repo working tree after misdirected Edit tool path**
- **Found during:** Task 1
- **Issue:** First Edit invocation used the path that resolved to the **main repo** (`C:\Programming_Files\Shilocity\Godot\NeoCade-Theme\.planning\research\MINIMAL-THEME-DISSECTION.md`) rather than the worktree's copy. Modifications appeared in the main repo's working tree (which would conflict with future commits) instead of the worktree's branch.
- **Fix:** Ran `git -C <main-repo-path> checkout -- .planning/research/MINIMAL-THEME-DISSECTION.md` to restore the main repo's working tree to its committed state, then redirected the Edit tool at the worktree-relative path (`/c/Programming_Files/.../worktrees/agent-ac451d4f8e404d96a/.planning/research/MINIMAL-THEME-DISSECTION.md`). All subsequent edits used the worktree path.
- **Verification:** `git -C <main-repo-path> status --short` confirmed clean working tree post-restoration; `wc -l` confirmed main repo's file size returned to 1011 lines (pre-Plan-03 state); subsequent worktree commits show correct progression (1011 → 1029 → 1447 → 1564 → 1683).
- **Files modified:** None (the unintended edit was reverted, not committed). The intentional content went into the worktree's `.planning/research/MINIMAL-THEME-DISSECTION.md` only.
- **Committed in:** N/A (no committed changes to revert — the unintended edit was caught before any git operation)
- **Why this counts as Rule 1:** A misdirected file edit on the wrong working tree would have caused a future merge conflict / desynced state when the worktree's branch eventually merges back to main. The restoration was a correctness fix, not a feature decision.

**2. [Rule 1 - Bug] Documented base_button.cpp / button.cpp evidence split with a callout**
- **Found during:** Task 3
- **Issue:** The plan body's `<read_first>` and acceptance criteria explicitly named `base_button.cpp`, but my investigation showed that focus draw logic lives in `button.cpp` (the concrete descendant) — `base_button.cpp` only handles focus event/state machinery, not drawing. The naive interpretation (cite only base_button.cpp) would have been factually wrong; the alternative (cite only button.cpp) would have failed the acceptance criterion's literal `grep -q "base_button.cpp"` check.
- **Fix:** Added a "Note on file selection" callout at the top of Pitfall 1.1's "Engine-source evidence" subsection that explicitly distinguishes the two files' roles, then cited BOTH in the evidence body — base_button.cpp for focus state machinery (status.pressed_down_with_focus + set_focus_mode), button.cpp for focus-as-overlay drawing (lines 222-230 + 290-303 inline comment).
- **Verification:** `grep -q "base_button.cpp"` passes; `grep -q "button.cpp"` passes; the callout makes the file-selection rationale auditable for any reader.
- **Files modified:** `.planning/research/MINIMAL-THEME-DISSECTION.md` (Pitfall 1.1 section — small inline addition)
- **Committed in:** `bc406bb` (Task 3 commit)

**3. [Rule 2 - Missing critical functionality] Documented plan's awk-bounded grep verify command had a self-canceling pattern bug**
- **Found during:** Task 4 verification
- **Issue:** The plan's verify block included `awk '/^### Pitfall 1.7/,/^### |^## /' .planning/research/MINIMAL-THEME-DISSECTION.md | grep -q "Implication for NeoCade:"` to ensure Pitfall 1.7 has its own Implication for NeoCade line. The pattern's start regex (`^### Pitfall 1.7`) and end regex (`^### `) both match the same start line, so awk's range immediately closes after one line, returning only the heading itself.
- **Fix:** Did not change the plan's verify command (out of scope per the no-modify-non-target-files discipline) but verified Pitfall 1.7's Implication for NeoCade is present using a corrected extraction (`awk 'BEGIN{f=0} /^### Pitfall 1.7/{f=1; next} f && /^### |^## /{f=0} f' ...` returned 1 hit), confirming the section content is correct. The plan's literal-grep acceptance criteria all pass.
- **Verification:** Direct line-range check `sed -n '1640,1685p' MINIMAL-THEME-DISSECTION.md | grep -c "Implication for NeoCade:"` returned 1 (Pitfall 1.7's instance is at line 1671). Global `grep -c "Implication for NeoCade"` returned 10 (8 table-header rows + 1 in Pitfall 1.1 + 1 in Pitfall 1.7).
- **Files modified:** None
- **Committed in:** N/A (verification documentation only; no committed changes)
- **Why this counts as Rule 2:** Catching the plan-level verify command bug is a correctness requirement — without surfacing it, future maintainers would mis-debug the plan-level verify when it fails on a fully-correct section. Documenting in SUMMARY ensures Phase 1 verifier and downstream phases see the issue and any future re-runs use a corrected pattern.

---

**Total deviations:** 3 auto-fixed (1 bug fix, 1 evidence-citation completeness, 1 plan-level verify-command bug surfaced)
**Impact on plan:** All deviations preserve the plan's intent and acceptance criteria. No scope creep. The misdirected-path fix prevented future merge conflicts; the base_button.cpp/button.cpp split fix added correctness to the citation chain; the awk-pattern bug surfaces a plan-quality issue for the verifier without modifying the plan or the dissection content.

## Issues Encountered

- **Worktree path resolution surprise:** The Edit tool resolved the absolute path `C:\Programming_Files\Shilocity\Godot\NeoCade-Theme\.planning\...` to the **main repo**, not the worktree. The user-supplied `<files_to_read>` block in my prompt used relative paths, but the act of reading then editing required absolute paths — and the worktree's relative path normalizes to the main repo when expanded by the Edit tool. Resolution: always use the explicit worktree-prefixed path `/c/Programming_Files/Shilocity/Godot/NeoCade-Theme/.claude/worktrees/agent-<id>/...` for all file operations in worktree-isolated executions. Documented in deviation #1.
- **Plan's verify-block awk pattern bug** (deviation #3): the awk range pattern was self-canceling. Documented; section content is correct.

## User Setup Required

None — Phase 1 is research-only; no external service configuration, environment variables, or runtime infrastructure required.

## Next Phase Readiness

- **Plan 04 (Coverage Delta) ready:** Plan 03's omission tables include explicit "Populate / Follow upstream" decisions for every row. Plan 04 can extract these into the 27-themed-vs-35-target coverage delta document directly.
- **Phase 4 (Token Generator) constraint capture:** 5 entries flagged as `4.7-only?` MUST be re-verified against `godotengine/godot@4.6-stable`. NeoCade tokens for these slots should not be authored until 4.6-stable verification confirms the slots exist.
- **Phase 5 (Focus Rings) constraint capture:** Pitfall 1.1's "Implication for NeoCade" section enumerates 4 design directives — populate composite focus slots (pressed_focus / checked_focus / radio_checked_focus), use expand_margin not border_width for focus ring construction, populate font_focus_color + composite font color slots, mobile variant needs increased ring expand_margin.
- **Phase 6 (Popup Theming) constraint capture:** Pitfall 1.7's "Implication for NeoCade" section enumerates 8 popup classes that MUST be type-themed in `neocade_theme.tres` (PopupMenu, PopupPanel, AcceptDialog, FileDialog-additive, ConfirmationDialog-additive, TooltipPanel, TooltipLabel-additive, Window-additive). Phase 6 implementations CANNOT rely on `add_theme_*_override` calls on parent Controls — those don't reach popups.
- **No blockers for Phase 1 verification (`/gsd-verify-work`):** all plan acceptance criteria pass; both pitfalls confirmed; reading order is `## Per-Control Enumeration → ## Engine-Default Cross-Reference and Pitfall Confirmations → ### Engine-Default Cross-Reference → ### Pitfall 1.1 → ### Pitfall 1.7`.

## Self-Check: PASSED

**Files:**
- FOUND: `.planning/research/MINIMAL-THEME-DISSECTION.md` (1683 lines, all sections present)
- FOUND: `.planning/phases/01-source-dive-godot-minimal-theme-tres-dissection/01-03-omission-and-pitfalls-SUMMARY.md` (this file)

**Commits:**
- FOUND: `6a8af41` (Task 1 — Engine-Default Cross-Reference subsection header)
- FOUND: `57cde13` (Task 2 — per-Control omission tables)
- FOUND: `bc406bb` (Task 3 — Pitfall 1.1 confirmation)
- FOUND: `176eca3` (Task 4 — Pitfall 1.7 confirmation)

**Plan acceptance criteria (all PASS):**
- Engine-Default Cross-Reference heading present
- Engine-source anchor literal + Detected version literal + version 4.7 detected (no caveat marker required since version.py confirms ≥ 4.6)
- 33 per-Control omission outcomes (≥20 required)
- Pitfall 1.1 heading + verdict + base_button.cpp + pressed_focus + Implication for NeoCade
- Pitfall 1.7 heading + verdict + theme_db.cpp + popup.cpp/window.cpp + Layer A + Layer B + Implication for NeoCade (verified via fixed bounded extraction; plan's awk pattern had a self-canceling bug surfaced in deviations)

**Reading order verified:** `## Per-Control Enumeration` (lines 189+) → `## Engine-Default Cross-Reference and Pitfall Confirmations` (line 1009) → `### Engine-Default Cross-Reference` (line 1013) → `### Pitfall 1.1` (line 1448) → `### Pitfall 1.7` (line 1565).

---
*Phase: 01-source-dive-godot-minimal-theme-tres-dissection*
*Plan: 03 (omission-and-pitfalls)*
*Completed: 2026-05-04*
