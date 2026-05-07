---
phase: 05-core-controls-buttons-inputs-labels-panels-desktop
plan: 05
subsystem: dynamic-theme-generator
tags:
  - codeedit-gutter-chrome
  - codeedit-folded-icon
  - codeedit-text-chrome-final
  - text-class-chrome-completeness
  - codeedit-no-syntax-highlighting
  - cov-03
  - typevar-02
  - typevar-03
  - typevar-05
  - cov-01
  - cov-09
  - typevar-06
  - d-11-icon-import-contract
  - d-12-codeedit-folded
  - af-7-no-syntax-highlighting
  - phase5-verifier
  - text-final-stage
dependency_graph:
  requires:
    - 05-01-SUMMARY  # Godot 4.6 CLI resolver + dual verifier scaffold + PHASE5_CODEEDIT_GUTTER_COLORS / PHASE5_CODEEDIT_FOLDED_ICON constants
    - 05-02-SUMMARY  # role_table semantic roles (role_danger, role_warning) consumed by gutter recipes
    - 05-04-SUMMARY  # text-panels strict groups + get_<kind>_list AUTHORED-slot pattern
  provides:
    - "BINDING_TABLE.CodeEdit: font_readonly_color + font_selected_color (text chrome parity with TextEdit)"
    - "BINDING_TABLE.CodeEdit: 5 gutter color recipes (breakpoint_color/code_folding_color/bookmark_color/executing_line_color/line_length_guideline_color)"
    - "BINDING_TABLE.CodeEdit.icon: official Godot 4.6 `folded` slot wired to code_folded.svg"
    - "addons/neocade_theme/icons/code_folded.svg + .svg.import (32x32 monochrome white per D-11)"
    - "text-final stage in headless + EditorScript verifiers (PENDING == FAIL for 11 strict groups: 3 new + 8 carry-forward from text-panels + invariants)"
    - "2 new strict groups (assert_text_class_chrome_complete, assert_codeedit_no_syntax_highlighting)"
    - "assert_codeedit_gutter_slots flipped strict in text-final and switched to get_color_list AUTHORED-slot detection"
  affects:
    - addons/neocade_theme/neocade_theme.gd (BINDING_TABLE.CodeEdit: 2 new text chrome colors + 5 new gutter colors + 1 new icon recipe)
    - addons/neocade_theme/icons/code_folded.svg (NEW)
    - addons/neocade_theme/icons/code_folded.svg.import (NEW)
    - .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify_headless.gd
    - .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify.gd
tech-stack:
  added: []
  patterns:
    - "BINDING_TABLE.CodeEdit gutter chrome via DESIGN_TOKENS semantic role lookups (role_danger / role_warning / role_primary / outline_color / text_muted)"
    - "Phase 4 D-11 icon contract: 32x32 reference, monochrome #FFFFFF, .import sidecar with svg/scale=2.0 + mipmaps/generate=true + compress/mode=0 + process/fix_alpha_border=true"
    - "Three-stage SVG import workflow (write SVG -> minimal placeholder .import -> godot --headless --import -> commit godot-issued uid:// + path) — never hand-author UIDs"
    - "Verifier groups use get_<kind>_list (AUTHORED slots) to bypass Godot's has_<kind> reporting Control-class signatures (Wave 4 BL-02 fix carry-forward)"
    - "AF-7 scope guard via positive forbidden-list scan (PHASE5_CODEEDIT_FORBIDDEN_SYNTAX_COLORS) instead of allow-list — fails loud if syntax-highlighting slot creep happens"
key-files:
  created:
    - addons/neocade_theme/icons/code_folded.svg
    - addons/neocade_theme/icons/code_folded.svg.import
    - .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/05-05-SUMMARY.md
  modified:
    - addons/neocade_theme/neocade_theme.gd
    - .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify_headless.gd
    - .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify.gd
decisions:
  - "Gutter color recipe choices follow DESIGN_TOKENS semantic role intent: breakpoint_color -> role_danger (red stop), bookmark_color -> role_warning (yellow), executing_line_color -> role_primary (active accent), code_folding_color + line_number_color -> text_muted (gutter chrome neutrality), line_length_guideline_color -> outline_color (subtle column rule)."
  - "CodeEdit `folded` icon SVG is a chevron-down (path M10 12 L16 20 L22 12) — visually consistent with the arrow_down.svg vocabulary used by OptionButton, distinguishing 'fold/expand' from the 'X' clear vocabulary. 32x32 reference at stroke-width 3 monochrome #FFFFFF per Phase 4 D-11."
  - "Three-stage SVG import workflow honored (D-11): wrote SVG -> wrote minimal `.import` placeholder (no uid/path) -> ran `godot --headless --import` -> committed the populated `.import` (godot-issued uid://mfsh7wsslfe7 + ctex path). UID was NOT hand-authored."
  - "assert_codeedit_gutter_slots switched from theme.has_color() to theme.get_color_list().find != -1 for AUTHORED-slot detection (Plan 05-04 Wave 4 Rule 1 fix carried forward). has_color walks Control inheritance and reports built-in CodeEdit slot signatures; get_color_list returns ONLY slots the BINDING_TABLE walk explicitly authored via set_color()."
  - "AF-7 enforcement uses a forbidden-list scan (assert_codeedit_no_syntax_highlighting checks 13 syntax-highlighting slot names: keyword/function/number/member_variable/symbol/control_flow_keyword/brace_mismatch/string/base_type/engine_type/user_type/comment/doc_comment) instead of an allow-list. Pattern fails LOUD on accidental scope creep instead of silently passing."
  - "text-final stage carries forward all Plan 05-04 text-panels strict groups (8 groups) plus the 2 invariants (no_theme_clear, no_invented_focus_combos), so a text-final regression also catches text-panels regressions. Total strict: 11 groups + 1 PENDING (assert_spinbox_icons, owned by Plan 05-06)."
  - "CodeEdit syntax-highlighting slots were verified absent via the forbidden-list probe; per FEATURES AF-7, those land in a future scope (likely Phase 7 or post-v1)."
  - "Mirror EditorScript verifier (_phase5_verify.gd) updated in lockstep so Editor 'File -> Run' coverage matches CI; `_stage` defaults to tooling but the strict-list machinery is identical."
metrics:
  duration: ~30 minutes (sequential mode on main working tree, no worktree)
  completed: 2026-05-06
  tasks_completed: 2
  commits: 4
  groups_ok_text_final: 25
  groups_ok_text_panels: 25
  groups_ok_buttons: 25
  failures: 0
---

# Phase 5 Plan 05: CodeEdit Polish + Text Chrome Finalization Summary

Closes Plan 05-05 (Wave 5): the five Phase 5 desktop text classes (Label, RichTextLabel, LineEdit, TextEdit, CodeEdit) now have complete AUTHORED chrome — fonts, caret, selection, placeholder/read-only, focus — and CodeEdit additionally gains its 5 gutter color slots plus the official Godot 4.6 `folded` icon, all without any syntax-highlighting scope creep (AF-7 honored).

## What landed

**Production class (`addons/neocade_theme/neocade_theme.gd`) — BINDING_TABLE.CodeEdit:**

1. **Text chrome parity with TextEdit** (Task 1):
   - `font_readonly_color` -> `{"role": "text_muted", "disabled": true}`
   - `font_selected_color` -> `{"role": "text_strong"}`
2. **Gutter color slots** (Task 2; Godot 4.6 official names):
   - `breakpoint_color`            -> `role_danger` (red stop indicator)
   - `code_folding_color`          -> `text_muted` (gutter chrome neutrality)
   - `bookmark_color`              -> `role_warning` (yellow bookmark)
   - `executing_line_color`        -> `role_primary` (active line = accent)
   - `line_length_guideline_color` -> `outline_color` (subtle column rule)
   - `line_number_color`           -> `text_muted` (already present from Phase 4 baseline)
3. **`folded` icon recipe** (Task 2; D-12):
   - `"folded": {"icon": "code_folded"}` — points to the new SVG.

**New icon files (`addons/neocade_theme/icons/`):**

- `code_folded.svg` — 32x32 monochrome `#FFFFFF` chevron-down (`<path d="M10 12 L16 20 L22 12" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" />`).
- `code_folded.svg.import` — committed AFTER `godot --headless --import` populated `uid="uid://mfsh7wsslfe7"` and `path="res://.godot/imported/code_folded.svg-00c7c69c43235622edd7c7b96b85f278.ctex"`. Per Phase 4 D-11: `svg/scale=2.0`, `mipmaps/generate=true`, `compress/mode=0`, `process/fix_alpha_border=true`.

**Verifier additions (both `_phase5_verify_headless.gd` and `_phase5_verify.gd` mirror):**

1. New stage `text-final` registered in arg parser + stage policy.
2. New assertion group `assert_text_class_chrome_complete` — walks Label / RichTextLabel / LineEdit / TextEdit / CodeEdit and asserts AUTHORED color + stylebox slots via `get_<kind>_list().find != -1`. Required slots per type encoded in `PHASE5_TEXT_CLASS_CHROME_REQUIREMENTS` const.
3. New assertion group `assert_codeedit_no_syntax_highlighting` — scans `theme.get_color_list("CodeEdit")` for any of 13 forbidden syntax-highlighting slot names (keyword_color, function_color, number_color, member_variable_color, symbol_color, control_flow_keyword_color, brace_mismatch_color, string_color, base_type_color, engine_type_color, user_type_color, comment_color, doc_comment_color); fails LOUD on creep.
4. Existing `assert_codeedit_gutter_slots` switched from `theme.has_color()` to `theme.get_color_list().find != -1` (Plan 05-04 Wave 4 Rule 1 fix carry-forward) and added to the text-final strict list.
5. `text_final_stage_strict` list (11 groups: 3 new + 8 carry-forward from text-panels + 2 invariants).
6. Group counts bumped 23 -> 25.

## Verifier results

```text
PHASE5_VERIFY summary -----
  stage:          text-final
  groups OK:      25 / 25
  groups PENDING: 1  ["assert_spinbox_icons"]
  failures:       0
PHASE5_VERIFY OK (stage=text-final)
```

Carry-forward regression check (post-Plan-05-05):

| Stage         | Exit | Failures | Status                                   |
| ------------- | ---- | -------- | ---------------------------------------- |
| `buttons`     | 0    | 0        | Plan 05-03 strict groups still pass      |
| `text-panels` | 0    | 0        | Plan 05-04 strict groups still pass      |
| `text-final`  | 0    | 0        | Plan 05-05 strict groups pass            |

Only PENDING (across all stages): `assert_spinbox_icons` — owned by Plan 05-06.

`godot --headless --import` exits 0 with no `ERROR:` / `SCRIPT ERROR:` lines.

## Tasks completed

| Task | Name                                                 | TDD       | Commits |
| ---- | ---------------------------------------------------- | --------- | ------- |
| 1    | Add text input/display final chrome recipes          | RED+GREEN | a7d4591 (RED), 4c0108e (GREEN) |
| 2    | Add CodeEdit folded icon and gutter assertions       | GREEN     | 2006885 (feat), 0b79b67 (mirror)   |

Total: 4 commits.

## Commits

| Hash      | Type | Files                                                                                                | Description                                                                |
| --------- | ---- | ---------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------- |
| a7d4591   | test | `helpers/_phase5_verify_headless.gd`                                                                 | RED T1 — text-final stage + 2 new assertion groups + has_color->get_color_list fix |
| 4c0108e   | feat | `addons/neocade_theme/neocade_theme.gd`                                                              | GREEN T1 — CodeEdit font_readonly_color + font_selected_color              |
| 2006885   | feat | `addons/neocade_theme/icons/code_folded.svg`, `code_folded.svg.import`, `addons/neocade_theme/neocade_theme.gd` | GREEN T2 — gutter colors + folded icon (godot-issued UID)                  |
| 0b79b67   | test | `helpers/_phase5_verify.gd`                                                                          | Mirror — EditorScript verifier kept in lockstep                            |

## Deviations from Plan

**None.** Plan executed exactly as written:

- Task 1 added font_readonly_color + font_selected_color to CodeEdit BINDING_TABLE row (TextEdit parity).
- Task 2 authored code_folded.svg per D-11 contract, ran the three-stage import workflow (write -> placeholder -> --import -> commit godot-issued UID), and wired the `folded` icon recipe + 5 gutter color recipes.
- Both tasks honored the AF-7 scope boundary: zero syntax-highlighting slots authored, scoped to chrome only.
- The Wave 4 BL-02 carry-forward (has_<kind> -> get_<kind>_list AUTHORED-slot detection) was applied to assert_codeedit_gutter_slots without prompt — this matches the documented key invariants in CONTEXT.md and prevents the same false-pass risk Plan 05-04 hit.

## Authentication gates

None required.

## Known stubs

None. CodeEdit is feature-complete to its Phase 5 desktop scope; syntax highlighting (AF-7) is documented as out-of-scope for Phase 5 and is enforced by `assert_codeedit_no_syntax_highlighting`.

## Threat flags

None — no new network endpoints, auth paths, file access patterns, or schema changes at trust boundaries. Pure Theme metadata work.

## Self-Check: PASSED

Verified:

- `addons/neocade_theme/icons/code_folded.svg` FOUND (32x32 SVG, 4 lines).
- `addons/neocade_theme/icons/code_folded.svg.import` FOUND with godot-issued `uid://mfsh7wsslfe7`.
- `addons/neocade_theme/neocade_theme.gd` modified (BINDING_TABLE.CodeEdit expanded).
- `helpers/_phase5_verify_headless.gd` and `helpers/_phase5_verify.gd` updated in lockstep.
- All 4 commits FOUND in `git log`: a7d4591, 4c0108e, 2006885, 0b79b67.
- `git status --short` clean (only the new SUMMARY.md will be uncommitted at this point).
- No `*_neocade_theme.tres` or `main.tscn` modifications committed (per orchestrator constraint).
- `text-final` verifier passes 25/25 with 0 failures and 0 ERROR/SCRIPT ERROR lines in either the import log or the verifier log.
- `buttons` and `text-panels` stages still pass with 0 failures (no regressions).
