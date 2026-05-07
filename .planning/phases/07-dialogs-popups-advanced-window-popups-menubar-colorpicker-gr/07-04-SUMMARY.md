---
phase: 07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr
plan: 04
subsystem: theme-ui
tags: [godot-4.6, theme-slots, colorpicker, icons, tdd]

requires:
  - phase: 07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr
    provides: Phase 7 slot-freeze, popup/menu baseline, FileDialog baseline, and staged verifier runner
provides:
  - ColorPicker official Godot 4.6.2 focus, cursor color, constants, and 16 icon bindings
  - ColorPickerButton official Button-family state coverage, direct font wiring, constants, and bg icon
  - 17 bespoke ColorPicker-family SVG icons with Godot import sidecars
  - Strict ColorPicker verifier stage with zero pending groups
affects: [phase-07, phase-08, phase-09, cov-08, cov-01, cov-09]

tech-stack:
  added: []
  patterns:
    - Godot Theme ColorPicker gradients and samplers remain engine-rendered
    - ColorPickerButton font/font_size slots are direct calls after BINDING_TABLE
    - ColorPicker-family icon slots map one-to-one to colorpicker_<slot>.svg assets

key-files:
  created:
    - addons/neocade_theme/icons/colorpicker_*.svg
    - addons/neocade_theme/icons/colorpicker_*.svg.import
  modified:
    - addons/neocade_theme/neocade_theme.gd
    - .planning/phases/07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr/helpers/_phase7_verify_headless.gd

key-decisions:
  - "ColorPicker binds exactly the official 16 icon slots from the Phase 7 slot freeze; ColorPickerButton uses the separate bg icon slot."
  - "ColorPickerButton font and font_size are wired with direct set_font/set_font_size calls after the BINDING_TABLE walk, not through BINDING_TABLE."
  - "ColorPicker focus styleboxes use transparent StyleBoxFlat focus rings so engine-rendered picker fields remain unobscured."

patterns-established:
  - "ColorPicker verifier stage now enforces ColorPicker and ColorPickerButton production coverage with zero pending groups."
  - "ColorPicker icons follow the Phase 4/6 import contract: 32x32 SVG source, single #FFFFFF artwork, svg/scale=2.0, mipmaps enabled, compress/mode=0, and process/fix_alpha_border=true."

requirements-completed: [COV-08, COV-01, COV-09]

duration: 10 min
completed: 2026-05-07
---

# Phase 07 Plan 04: ColorPicker Structural Coverage Summary

**ColorPicker and ColorPickerButton desktop coverage with exact Godot 4.6.2 slot bindings and bespoke SVG icon assets**

## Performance

- **Duration:** 10 min
- **Started:** 2026-05-07T11:05:54Z
- **Completed:** 2026-05-07T11:14:46Z
- **Tasks:** 3 completed
- **Files modified:** 36

## Accomplishments

- Authored 17 ColorPicker-family SVG assets: 16 official ColorPicker icons plus `colorpicker_button_bg.svg`.
- Completed `BINDING_TABLE.ColorPicker` for all official focus styleboxes, cursor color, desktop constants, and 16 icon slots.
- Completed `BINDING_TABLE.ColorPickerButton` for all official Button-family styleboxes, state colors, constants, and `bg` icon.
- Added direct ColorPickerButton `set_font()` / `set_font_size()` calls after the binding-table walk.
- Replaced the pending ColorPicker verifier group with strict assertions and verified the stage has zero pending groups.

## Task Commits

1. **Task 1: Author and import ColorPicker icon set** - `688686c` (feat)
2. **Task 2 RED: Add failing ColorPicker verifier** - `cbf611e` (test)
3. **Task 2 GREEN: Implement ColorPicker slot coverage** - `f628d2c` (feat)
4. **Task 3 RED: Add failing ColorPickerButton verifier** - `2429539` (test)
5. **Task 3 GREEN: Complete ColorPickerButton coverage** - `5588d16` (feat)

## Files Created/Modified

- `addons/neocade_theme/icons/colorpicker_*.svg` - 17 monochrome ColorPicker-family icon sources.
- `addons/neocade_theme/icons/colorpicker_*.svg.import` - Godot-generated import sidecars normalized to the established icon settings.
- `addons/neocade_theme/neocade_theme.gd` - ColorPicker and ColorPickerButton production bindings plus direct ColorPickerButton font calls.
- `.planning/phases/07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr/helpers/_phase7_verify_headless.gd` - strict ColorPicker stage assertions.

## Verification

- `powershell -NoProfile -Command "$godot = (Get-Content '.planning/phases/07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr/helpers/godot-cli-path.txt' -Raw).Trim(); & $godot --headless --path . --import --quit-after 2"`: PASS.
- ColorPicker icon existence check for all 17 SVGs and `.svg.import` files: PASS.
- ColorPicker import settings check (`uid://`, `svg/scale=2.0`, `mipmaps/generate=true`, `compress/mode=0`, `process/fix_alpha_border=true`): PASS.
- `powershell -NoProfile -ExecutionPolicy Bypass -File .planning/phases/07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr/helpers/_run-phase7-verify.ps1 -Stage colorpicker`: PASS.
  - OK markers: `assert_slot_freeze`, `assert_known_stale_phase7_slots_absent`, `assert_phase7_icon_recipe_names`, `assert_no_theme_clear`, `assert_one_addon_root_gd`, `assert_public_export_lock`, `assert_slot_freeze_artifact`, `assert_popups_menus_stage`, `assert_filedialog_stage`, `assert_colorpicker_stage`.
  - Pending markers: none.
  - COV markers: `COV-08`, `COV-01`.
- Architecture invariant check: PASS (`@export var` count remains 9, no `Theme.clear`, no root `neocade_theme.tres`, one addon-root `.gd`).

## Decisions Made

- Used dedicated `colorpicker_expanded_arrow.svg` and `colorpicker_folded_arrow.svg` files instead of reusing generic arrows so the official ColorPicker icon family remains explicit.
- Used desktop constants `sv_width=240`, `sv_height=180`, `h_width=24`, `label_width=64`, `center_slider_grabbers=1`, and `margin=tokens.tapPadding`; Phase 8 still owns mobile picker sizing.
- Kept `ColorPickerButton.font` and `ColorPickerButton.font_size` out of `BINDING_TABLE` and wired them directly after the table walk per review-convergence requirements.

## TDD Gate Compliance

- Task 2 RED gate commit exists: `cbf611e` (`test(07-04): add failing ColorPicker verifier`).
- Task 2 GREEN gate commit exists after RED: `f628d2c` (`feat(07-04): implement ColorPicker slot coverage`).
- Task 3 RED gate commit exists: `2429539` (`test(07-04): add failing ColorPickerButton verifier`).
- Task 3 GREEN gate commit exists after RED: `5588d16` (`feat(07-04): complete ColorPickerButton coverage`).
- Refactor gate: not needed.

## Deviations from Plan

None - plan executed exactly as written.

## Known Stubs

None. Stub-pattern scan hits in touched files were pre-existing comments/slot names or verifier-local accumulator defaults, not UI-flowing placeholders introduced by this plan.

## Threat Flags

None.

## Issues Encountered

- Godot generated new SVG imports with default `svg/scale=1.0` and `mipmaps/generate=false`; the sidecars were normalized to `svg/scale=2.0` and `mipmaps/generate=true`, then reimported before the icon task commit.

## Authentication Gates

None.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness

Plan 07-05 can build GraphEdit, GraphNode, and GraphFrame coverage on a strict ColorPicker baseline. The `colorpicker` verifier stage now has zero pending groups; the remaining Phase 7 pending group is `graph`, owned by Plan 07-05.

## Self-Check: PASSED

- Verified all 17 ColorPicker-family SVG files and all 17 `.svg.import` sidecars exist on disk.
- Verified production, verifier, and summary files exist on disk.
- Verified task commits exist in git: `688686c`, `cbf611e`, `f628d2c`, `2429539`, `5588d16`.
- Re-ran the plan-level `colorpicker` verification successfully after writing this summary.
- Verified no unexpected tracked file deletions in task commits.

---
*Phase: 07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr*
*Completed: 2026-05-07*
