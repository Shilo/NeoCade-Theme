---
phase: 07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr
plan: 02
subsystem: theme-ui
tags: [godot-4.6, theme-slots, popups, popupmenu, menubar, window, tooltip, tdd]

requires:
  - phase: 07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr
    provides: Phase 7 slot-freeze, verifier runner, and canonical popup/menu icon recipe map
provides:
  - Window, PopupPanel, PopupMenu, AcceptDialog, ConfirmationDialog, TooltipPanel, TooltipLabel, and MenuBar production bindings
  - PopupMenu submenu and mirrored submenu bespoke SVG icons
  - Strict popups-menus verifier stage with zero pending groups
affects: [phase-07, phase-08, phase-09, cov-06, cov-08, cov-01, cov-07, cov-09]

tech-stack:
  added: []
  patterns:
    - Direct set_font/set_font_size calls for Phase 7 font slots after the BINDING_TABLE walk
    - PopupMenu disabled icon variants reuse base bespoke artwork and rely on theme tinting
    - Popup/dialog shell styleboxes use tonal surfaces with no texture chrome

key-files:
  created:
    - addons/neocade_theme/icons/popup_submenu.svg
    - addons/neocade_theme/icons/popup_submenu.svg.import
    - addons/neocade_theme/icons/popup_submenu_mirrored.svg
    - addons/neocade_theme/icons/popup_submenu_mirrored.svg.import
  modified:
    - addons/neocade_theme/neocade_theme.gd
    - .planning/phases/07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr/helpers/_phase7_verify_headless.gd

key-decisions:
  - "Popup/menu font and font_size slots are set directly after the BINDING_TABLE walk; no Phase 7 font slots were added to BINDING_TABLE."
  - "PopupMenu disabled checked/unchecked/radio variants reuse the base checkbox/radio SVGs and depend on disabled tinting instead of separate artwork."
  - "PopupMenu separators are zero-margin structural line styleboxes, not panel/card surfaces."

patterns-established:
  - "Plan 07-02 verifier expansion: the popups-menus stage now enforces Window, popup/dialog shell, Tooltip, MenuBar, and PopupMenu production coverage."
  - "PopupMenu icon mapping is explicit: checked/unchecked use checkbox SVGs, radio slots use radio SVGs, submenu slots use popup_submenu SVGs."

requirements-completed: [COV-06, COV-08, COV-01, COV-07, COV-09]

duration: 8 min
completed: 2026-05-07
---

# Phase 07 Plan 02: Popup/Menu Structural Coverage Summary

**Window, popup/dialog, tooltip, MenuBar, and PopupMenu desktop theme coverage with direct font-slot wiring and submenu icons**

## Performance

- **Duration:** 8 min
- **Started:** 2026-05-07T10:42:16Z
- **Completed:** 2026-05-07T10:49:39Z
- **Tasks:** 3 completed
- **Files modified:** 6

## Accomplishments

- Added PopupMenu submenu and mirrored submenu SVG assets with Godot import sidecars using real `uid://` values, `svg/scale=2.0`, and mipmaps enabled.
- Completed Window, PopupPanel, AcceptDialog, ConfirmationDialog, TooltipPanel, TooltipLabel, and MenuBar production bindings.
- Completed PopupMenu official 4.6.2 slot coverage: styleboxes, colors, constants, fonts, font sizes, and all ten icon slots.
- Replaced the pending popups-menus verifier group with strict assertions and verified the stage has zero pending groups.

## Task Commits

1. **Task 1: Author and import PopupMenu submenu icons** - `1609c3a` (feat)
2. **Task 2 RED: Add failing popup shell verifier** - `d6a0233` (test)
3. **Task 2 GREEN: Implement Window, popup/dialog, Tooltip, and MenuBar coverage** - `cbd188c` (feat)
4. **Task 3 RED: Add failing PopupMenu verifier** - `fce09d9` (test)
5. **Task 3 GREEN: Complete PopupMenu coverage** - `47f8746` (feat)

## Files Created/Modified

- `addons/neocade_theme/icons/popup_submenu.svg` - non-mirrored PopupMenu submenu arrow.
- `addons/neocade_theme/icons/popup_submenu.svg.import` - Godot-generated import sidecar normalized to the established icon settings.
- `addons/neocade_theme/icons/popup_submenu_mirrored.svg` - mirrored PopupMenu submenu arrow.
- `addons/neocade_theme/icons/popup_submenu_mirrored.svg.import` - Godot-generated mirrored import sidecar normalized to the established icon settings.
- `addons/neocade_theme/neocade_theme.gd` - popup/menu production bindings and direct Phase 7 font calls.
- `.planning/phases/07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr/helpers/_phase7_verify_headless.gd` - strict popups-menus verifier assertions.

## Verification

- `powershell -NoProfile -ExecutionPolicy Bypass -File .planning/phases/07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr/helpers/_run-phase7-verify.ps1 -Stage popups-menus`: PASS.
  - OK markers: `assert_slot_freeze`, `assert_known_stale_phase7_slots_absent`, `assert_phase7_icon_recipe_names`, `assert_no_theme_clear`, `assert_one_addon_root_gd`, `assert_public_export_lock`, `assert_slot_freeze_artifact`, `assert_popups_menus_stage`.
  - Pending markers: none.

## Decisions Made

- Kept all Window, TooltipLabel, MenuBar, and PopupMenu font/font_size slots out of `BINDING_TABLE`; direct calls happen after the binding-table iteration in `_regenerate_theme()`.
- Used the existing disclosure-arrow visual language for PopupMenu submenu icons while giving them dedicated popup filenames and import sidecars.
- Kept PopupMenu separators structural by using zero content margins and muted alpha instead of panel/card surfaces.

## TDD Gate Compliance

- Task 2 RED gate commit exists: `d6a0233` (`test(07-02): add failing popup shell verifier`).
- Task 2 GREEN gate commit exists after RED: `cbd188c` (`feat(07-02): implement popup shell coverage`).
- Task 3 RED gate commit exists: `fce09d9` (`test(07-02): add failing PopupMenu verifier`).
- Task 3 GREEN gate commit exists after RED: `47f8746` (`feat(07-02): complete PopupMenu coverage`).
- Refactor gate: not needed.

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered

- Godot generated the new SVG imports with default `svg/scale=1.0` and `mipmaps/generate=false`; the sidecars were normalized to the Phase 4/6 icon contract and reimported before the icon task commit.

## Known Stubs

None.

## Threat Flags

None.

## Authentication Gates

None.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness

Plan 07-03 can build FileDialog icon and structural coverage on a strict popup/menu baseline. The `popups-menus` verifier stage now has zero pending groups; later Phase 7 stages remain owned by their dedicated plans.

## Self-Check: PASSED

- Verified all 7 key files exist on disk.
- Verified task commits exist in git: `1609c3a`, `d6a0233`, `cbd188c`, `fce09d9`, `47f8746`.
- Re-ran the plan-level `popups-menus` verification successfully after writing this summary.
- Verified no unexpected tracked file deletions in task commits.

---
*Phase: 07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr*
*Completed: 2026-05-07*
