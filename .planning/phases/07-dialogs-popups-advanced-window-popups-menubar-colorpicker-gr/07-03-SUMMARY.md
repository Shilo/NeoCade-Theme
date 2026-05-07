---
phase: 07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr
plan: 03
subsystem: theme-ui
tags: [godot-4.6, theme-slots, filedialog, icons, tdd]

requires:
  - phase: 07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr
    provides: Phase 7 slot-freeze, popup/menu baseline, and staged verifier runner
provides:
  - FileDialog official Godot 4.6.2 color, constant, and icon bindings
  - 20 bespoke FileDialog SVG icons with Godot import sidecars
  - Strict FileDialog verifier stage with stale-slot, Texture2D, and artifact-scope checks
affects: [phase-07, phase-08, phase-09, cov-06, cov-01, cov-07]

tech-stack:
  added: []
  patterns:
    - Godot Theme FileDialog shell resolved through AcceptDialog/Window inherited chrome
    - Platform-aware internal thumbnailSize token for FileDialog thumbnail_size
    - FileDialog icon slots mapped one-to-one to filedialog_<slot>.svg assets

key-files:
  created:
    - addons/neocade_theme/icons/filedialog_*.svg
    - addons/neocade_theme/icons/filedialog_*.svg.import
  modified:
    - addons/neocade_theme/neocade_theme.gd
    - .planning/phases/07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr/helpers/_phase7_verify_headless.gd

key-decisions:
  - "FileDialog does not write unsupported FileDialog.panel; shell chrome resolves through AcceptDialog/Window because local Godot 4.6.2 exposes no FileDialog stylebox slots."
  - "FileDialog.thumbnail_size uses an internal platform token: 96 desktop and 128 mobile, preserving Phase 8 mobile tuning room without adding exports."
  - "FileDialog.folder_icon_color uses accent_offset rather than raw accent so folders remain accent-derived without becoming over-bright."

patterns-established:
  - "FileDialog verifier stage enforces official colors, thumbnail_size, all 20 icons, no icon_normal_color in BINDING_TABLE or loaded theme entries, and no FileDialog-specific artifacts outside the icon set."
  - "FileDialog icons follow the Phase 4/6 import contract: 32x32 SVG source, single #FFFFFF artwork, svg/scale=2.0, mipmaps enabled, and compress/mode=0."

requirements-completed: [COV-06, COV-01, COV-07]

duration: 8 min
completed: 2026-05-07
---

# Phase 07 Plan 03: FileDialog Structural Coverage Summary

**FileDialog desktop theme coverage with 20 bespoke Godot 4.6.2 icon slots, thumbnail sizing, and stale-slot verification**

## Performance

- **Duration:** 8 min
- **Started:** 2026-05-07T10:53:50Z
- **Completed:** 2026-05-07T11:01:45Z
- **Tasks:** 3 completed
- **Files modified:** 42

## Accomplishments

- Authored all 20 official FileDialog SVG icons and committed Godot `.import` sidecars with the established icon import settings.
- Completed `BINDING_TABLE.FileDialog` for official colors, `thumbnail_size`, and every official icon slot.
- Removed the unsupported FileDialog-specific `panel` binding and kept shell chrome inherited from dialog/window entries.
- Replaced the pending FileDialog verifier group with strict assertions, including loaded-theme stale-slot checks and COV marker output.

## Task Commits

1. **Task 1: Author and import FileDialog icon set** - `30377d2` (feat)
2. **Task 2 RED: Add failing FileDialog verifier** - `8f2287c` (test)
3. **Task 2 GREEN: Implement FileDialog bindings** - `d028454` (feat)
4. **Task 3: Harden FileDialog verifier assertions** - `2f5dd36` (test)

## Files Created/Modified

- `addons/neocade_theme/icons/filedialog_*.svg` - 20 official FileDialog icon assets.
- `addons/neocade_theme/icons/filedialog_*.svg.import` - Godot-generated sidecars normalized to the Phase 4/6 icon contract.
- `addons/neocade_theme/neocade_theme.gd` - FileDialog production bindings plus internal `thumbnailSize` platform token.
- `.planning/phases/07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr/helpers/_phase7_verify_headless.gd` - strict FileDialog stage assertions.

## Verification

- `powershell -NoProfile -Command "$godot = (Get-Content '.planning/phases/07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr/helpers/godot-cli-path.txt' -Raw).Trim(); & $godot --headless --path . --import --quit-after 2"`: PASS.
- File existence check for all 20 `addons/neocade_theme/icons/filedialog_<slot>.svg`: PASS.
- `powershell -NoProfile -ExecutionPolicy Bypass -File .planning/phases/07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr/helpers/_run-phase7-verify.ps1 -Stage filedialog`: PASS.
  - OK markers: `assert_slot_freeze`, `assert_known_stale_phase7_slots_absent`, `assert_phase7_icon_recipe_names`, `assert_no_theme_clear`, `assert_one_addon_root_gd`, `assert_public_export_lock`, `assert_slot_freeze_artifact`, `assert_popups_menus_stage`, `assert_filedialog_stage`.
  - COV markers: `COV-06`, `COV-01`, `COV-07`.
  - Pending markers: none.

## Decisions Made

- Used inherited dialog/window shell chrome instead of keeping a non-official `FileDialog.panel` slot.
- Added `thumbnailSize` as an internal platform token rather than a public export.
- Used dedicated `filedialog_clear.svg` even though it is visually close to `clear.svg`, preserving the plan's stable filename family.

## TDD Gate Compliance

- RED gate commit exists: `8f2287c` (`test(07-03): add failing FileDialog verifier`).
- GREEN gate commit exists after RED: `d028454` (`feat(07-03): implement FileDialog theme bindings`).
- Refactor gate: not needed.

## Deviations from Plan

None - plan executed exactly as written.

## Known Stubs

None.

## Threat Flags

None.

## Issues Encountered

- Godot generated new SVG imports with default `svg/scale=1.0` and `mipmaps/generate=false`; the sidecars were normalized to `svg/scale=2.0` and `mipmaps/generate=true`, then reimported before the Task 1 commit.

## Authentication Gates

None.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness

Plan 07-04 can build ColorPicker and ColorPickerButton coverage on a strict FileDialog baseline. The `filedialog` verifier stage now has zero pending groups and enforces official slot completeness plus stale FileDialog `icon_normal_color` absence in both recipes and loaded theme entries.

## Self-Check: PASSED

- Verified all key production, verifier, summary, and 40 FileDialog icon/import files exist on disk.
- Verified task commits exist in git: `30377d2`, `8f2287c`, `d028454`, `2f5dd36`.
- Re-ran the plan-level `filedialog` verification successfully after writing this summary.
- Verified no unexpected tracked file deletions in task commits.

---
*Phase: 07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr*
*Completed: 2026-05-07*
