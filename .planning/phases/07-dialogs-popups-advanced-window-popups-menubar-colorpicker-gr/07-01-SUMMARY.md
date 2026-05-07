---
phase: 07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr
plan: 01
subsystem: theme-verification
tags: [godot-4.6, theme-slots, verifier, resourcesaver, tdd]

requires:
  - phase: 06-lists-layout-range-tree-itemlist-tabs-containers-sliders-des
    provides: Phase 6 staged verifier, slot-freeze, and ResourceSaver helper patterns
provides:
  - Official Godot 4.6.2 Phase 7 slot freeze
  - Strict Phase 7 slot-freeze verifier stage
  - Phase 7-local Godot CLI resolver and provenance files
  - ResourceSaver round-trip helper shell for final Phase 7 resource persistence
affects: [phase-07, phase-08, phase-09, cov-06, cov-08, cov-01, cov-07, cov-09]

tech-stack:
  added: []
  patterns:
    - Godot headless staged verifier with pending future groups
    - ResourceSaver save plus strip pass for data-only direction resources

key-files:
  created:
    - .planning/phases/07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr/helpers/phase7-slot-freeze.txt
    - .planning/phases/07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr/helpers/Resolve-Godot46.ps1
    - .planning/phases/07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr/helpers/_run-phase7-verify.ps1
    - .planning/phases/07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr/helpers/_phase7_verify_headless.gd
    - .planning/phases/07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr/helpers/_phase7_resource_saver.gd
    - .planning/phases/07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr/helpers/godot-cli-path.txt
    - .planning/phases/07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr/helpers/godot-cli-provenance.txt
  modified:
    - addons/neocade_theme/neocade_theme.gd

key-decisions:
  - "Phase 7 slot evidence is frozen from logs/07-research-slot-probe.log and enforced by a headless Godot slot-freeze stage."
  - "Later Phase 7 verifier groups remain explicit pending groups; the full stage fails until Plans 07-02 through 07-05 implement them."
  - "The ResourceSaver helper was created but intentionally not run in Plan 07-01; Plan 07-05 owns direction resource round-trips."

patterns-established:
  - "Slot evidence fixture: phase7-slot-freeze.txt records engine version, source log, stale-name exclusions, official slot lists, and canonical Phase 7 icon filename families."
  - "Verifier staging: slot-freeze is strict now; popups-menus, filedialog, colorpicker, and graph are pending until their owner plans land."
  - "Data-only resource persistence: ResourceSaver.save is followed by a deterministic strip pass preserving script linkage and 9 exports."

requirements-completed: [COV-06, COV-08, COV-01, COV-07, COV-09]

duration: 8 min
completed: 2026-05-07
---

# Phase 07 Plan 01: Execution Foundation Summary

**Godot 4.6.2 slot freeze and strict Phase 7 verification foundation for popup, dialog, ColorPicker, and graph controls**

## Performance

- **Duration:** 8 min
- **Started:** 2026-05-07T10:29:43Z
- **Completed:** 2026-05-07T10:37:29Z
- **Tasks:** 3 completed
- **Files modified:** 8

## Accomplishments

- Froze official Phase 7 slot evidence from the local Godot 4.6.2 probe into `phase7-slot-freeze.txt`.
- Updated `CANONICAL_SLOT_NAMES` for Window, popup/dialog, FileDialog, Tooltip, MenuBar, ColorPicker, ColorPickerButton, GraphEdit, GraphNode, and GraphFrame.
- Removed the unsupported stale `FileDialog.icon_normal_color` recipe and added a verifier guard against stale Phase 7 slot names.
- Added a Phase 7-local Godot resolver, staged verifier runner, strict slot-freeze verifier, and ResourceSaver helper shell.

## Task Commits

1. **Task 1 RED: Add failing Phase 7 slot-freeze verifier** - `8c0e63d` (test)
2. **Task 1 GREEN: Freeze official Phase 7 slots** - `8152f70` (feat)
3. **Task 2: Add Phase 7 verifier helper foundation** - `44dc1bb` (feat)
4. **Task 3: Add ResourceSaver round-trip helper shell** - `f9947b4` (feat)

## Files Created/Modified

- `addons/neocade_theme/neocade_theme.gd` - official Phase 7 canonical slot lists and stale FileDialog color removal.
- `.planning/phases/07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr/helpers/phase7-slot-freeze.txt` - official Godot 4.6.2 slot freeze artifact.
- `.planning/phases/07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr/helpers/Resolve-Godot46.ps1` - Phase 7-local search-only Godot resolver.
- `.planning/phases/07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr/helpers/_run-phase7-verify.ps1` - staged verifier runner.
- `.planning/phases/07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr/helpers/_phase7_verify_headless.gd` - strict slot-freeze verifier with pending later-stage groups.
- `.planning/phases/07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr/helpers/_phase7_resource_saver.gd` - ResourceSaver save/strip/reload helper shell.
- `.planning/phases/07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr/helpers/godot-cli-path.txt` - resolved local Godot 4.6.2 console executable.
- `.planning/phases/07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr/helpers/godot-cli-provenance.txt` - resolver provenance.

## Verification

- `powershell -NoProfile -ExecutionPolicy Bypass -File .planning/phases/07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr/helpers/_run-phase7-verify.ps1 -Stage slot-freeze`: PASS.
  - OK markers: `assert_slot_freeze`, `assert_known_stale_phase7_slots_absent`, `assert_phase7_icon_recipe_names`, `assert_no_theme_clear`, `assert_one_addon_root_gd`, `assert_public_export_lock`, `assert_slot_freeze_artifact`.
  - Pending markers: none for `slot-freeze`.
- `rg -n 'PHASE7_RESOURCE_SAVER|ResourceSaver.save|_strip_theme_entries|_strip_load_steps_attr' .planning/phases/07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr/helpers/_phase7_resource_saver.gd`: PASS.

## Decisions Made

- Used `phase7-slot-freeze.txt` and the new headless verifier as the TDD RED fixture so current incomplete Phase 7 canonical metadata failed before migration.
- Kept later Phase 7 verifier groups pending instead of weakly passing them; `full` is designed to fail until all owner plans land.
- Did not run `_phase7_resource_saver.gd` in this plan because it mutates direction `.tres` files; Plan 07-05 owns that round-trip.

## TDD Gate Compliance

- RED gate commit exists: `8c0e63d` (`test(07-01): add failing Phase 7 slot freeze verifier`).
- GREEN gate commit exists after RED: `8152f70` (`feat(07-01): freeze Phase 7 official slots`).
- Refactor gate: not needed.

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 3 - Blocking] Added verifier infrastructure during the Task 1 RED gate**
- **Found during:** Task 1 (Freeze Phase 7 slots and canonical coverage metadata)
- **Issue:** Task 1's verification command referenced Phase 7 helper files that the plan listed under Task 2, so the TDD RED gate was not runnable without creating the verifier/runner first.
- **Fix:** Created the Phase 7 resolver, runner, headless verifier, slot-freeze fixture, and Godot path/provenance files as the RED test surface, then implemented the production metadata change in the GREEN commit.
- **Files modified:** `.planning/phases/07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr/helpers/Resolve-Godot46.ps1`, `.planning/phases/07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr/helpers/_run-phase7-verify.ps1`, `.planning/phases/07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr/helpers/_phase7_verify_headless.gd`, `.planning/phases/07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr/helpers/phase7-slot-freeze.txt`, `.planning/phases/07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr/helpers/godot-cli-path.txt`, `.planning/phases/07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr/helpers/godot-cli-provenance.txt`
- **Verification:** The first slot-freeze run failed for missing Phase 7 canonical metadata and stale `FileDialog.icon_normal_color`; after GREEN, the same command passed.
- **Committed in:** `8c0e63d`

**Total deviations:** 1 auto-fixed (Rule 3 blocking)
**Impact on plan:** Required to make the planned TDD verification command runnable; no architecture or public API scope changed.

## Known Stubs

- `.planning/phases/07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr/helpers/_phase7_verify_headless.gd:459` - `assert_popups_menus_stage`; intentional pending group for Plan 07-02.
- `.planning/phases/07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr/helpers/_phase7_verify_headless.gd:463` - `assert_filedialog_stage`; intentional pending group for Plan 07-03.
- `.planning/phases/07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr/helpers/_phase7_verify_headless.gd:467` - `assert_colorpicker_stage`; intentional pending group for Plan 07-04.
- `.planning/phases/07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr/helpers/_phase7_verify_headless.gd:471` - `assert_graph_stage`; intentional pending group for Plan 07-05.

These do not block Plan 07-01 because the plan explicitly allows later stages to contain pending groups while making `full` fail on any pending group.

## Issues Encountered

- The verifier generated Phase 7 `godot-cli-path.txt` and `godot-cli-provenance.txt` from the local Godot 4.6.2 resolver. They were committed so downstream Phase 7 plans can run their import and verification commands without re-resolving.

## Authentication Gates

None.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness

Ready for Plan 07-02. The `slot-freeze` stage now prevents popup/menu, FileDialog, ColorPicker, and graph work from building on stale Godot slot names or unstable icon filename mappings.

## Self-Check: PASSED

- Verified all 9 key files exist on disk.
- Verified task commits exist in git: `8c0e63d`, `8152f70`, `44dc1bb`, `f9947b4`.
- Re-ran the plan-level `slot-freeze` verification successfully after writing this summary.
- Verified no unexpected tracked file deletions in task commits.

---
*Phase: 07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr*
*Completed: 2026-05-07*
