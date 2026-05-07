---
phase: 06-lists-layout-range-tree-itemlist-tabs-containers-sliders-des
plan: 03
subsystem: theme-itemlist-foldable
tags: [godot-4.6, itemlist, foldablecontainer, theme-slots, tdd]

requires:
  - phase: 06-lists-layout-range-tree-itemlist-tabs-containers-sliders-des
    provides: Plan 06-02 Tree selected-row and disclosure icon vocabulary
provides:
  - Full official Godot 4.6.2 ItemList slot coverage
  - FoldableContainer official title panel/color/icon slot coverage
  - Strict itemlist-foldable verifier stage with zero pending groups
affects: [phase-06, phase-08, cov-05, cov-01, cov-09, typevar-06]

tech-stack:
  added: []
  patterns:
    - TDD verifier stage for ItemList and FoldableContainer slot coverage
    - Reuse of Tree selected-row and disclosure icon vocabulary

key-files:
  created:
    - .planning/phases/06-lists-layout-range-tree-itemlist-tabs-containers-sliders-des/06-03-SUMMARY.md
  modified:
    - addons/neocade_theme/neocade_theme.gd
    - .planning/phases/06-lists-layout-range-tree-itemlist-tabs-containers-sliders-des/helpers/_phase6_verify_headless.gd

key-decisions:
  - "ItemList cursor and cursor_unfocused remain semi-transparent overlays while selected rows share Tree's accent-offset vocabulary."
  - "FoldableContainer uses only official Godot 4.6.2 title panel/color/icon slots and reuses Tree disclosure SVGs."
  - "The itemlist-foldable verifier stage is routed so this stage has zero pending groups; later tabs/range placeholders run only in their owner stages or full."

patterns-established:
  - "ItemList explicit font binding stays outside BINDING_TABLE because BINDING_TABLE intentionally has no font branch."
  - "FoldableContainer header chrome uses panel/state surface roles, not primary/accent button roles."
  - "Phase 6 cumulative markers emit after both ItemList and FoldableContainer gates pass."

requirements-completed: [COV-05, COV-01, COV-09, TYPEVAR-06]

duration: 6 min
completed: 2026-05-07
---

# Phase 06 Plan 03: ItemList and FoldableContainer Coverage Summary

**Official ItemList and FoldableContainer theming with transparent list cursors, Tree-aligned selection/disclosure vocabulary, and strict zero-pending verification**

## Performance

- **Duration:** 6 min
- **Started:** 2026-05-07T08:58:36Z
- **Completed:** 2026-05-07T09:05:00Z
- **Tasks:** 3 completed
- **Files modified:** 2

## Accomplishments

- Completed ItemList official stylebox, color, constant, font-size, font, and scroll-hint icon coverage.
- Kept ItemList `cursor` and `cursor_unfocused` alpha-bearing overlays and aligned selected states with Tree selected-row semantics.
- Completed FoldableContainer official title panel/color/icon coverage using Tree disclosure icons for expanded/folded and mirrored states.
- Hardened the `itemlist-foldable` verifier so it exits 0 only with ItemList and FoldableContainer contracts satisfied and zero pending groups.

## Task Commits

1. **Task 1 RED: ItemList coverage verifier** - `413ae1c` (test)
2. **Task 1 GREEN: ItemList slot coverage** - `bc4704c` (feat)
3. **Task 2 RED: FoldableContainer coverage verifier** - `32f0f36` (test)
4. **Task 2 GREEN: FoldableContainer slot coverage** - `1c9c041` (feat)
5. **Task 3: Harden itemlist-foldable verifier stage** - `6f666d9` (test)

## Files Created/Modified

- `addons/neocade_theme/neocade_theme.gd` - Added explicit ItemList/FoldableContainer font binding, ItemList cursor alpha and missing official slots, and FoldableContainer constants/font-size/disclosure icons.
- `.planning/phases/06-lists-layout-range-tree-itemlist-tabs-containers-sliders-des/helpers/_phase6_verify_headless.gd` - Added strict ItemList and FoldableContainer assertions, icon recipe checks, stale-slot guards, stage routing, and COV/TYPEVAR markers.
- `.planning/phases/06-lists-layout-range-tree-itemlist-tabs-containers-sliders-des/06-03-SUMMARY.md` - Plan execution summary and self-check record.

## Verification

- `powershell -NoProfile -ExecutionPolicy Bypass -File .planning/phases/06-lists-layout-range-tree-itemlist-tabs-containers-sliders-des/helpers/_run-phase6-verify.ps1 -Stage itemlist-foldable`: PASS.
  - OK groups: `assert_slot_freeze`, `assert_known_stale_slots_absent`, `assert_no_theme_clear`, `assert_one_addon_root_gd`, `assert_public_export_lock`, `assert_slot_freeze_artifact`, `assert_tree_stage`, `assert_itemlist_stage`, `assert_foldable_stage`.
  - Coverage markers: `PHASE6_COVERAGE_OK:COV-05`, `PHASE6_COVERAGE_OK:COV-01`, `PHASE6_COVERAGE_OK:COV-09`.
  - Carry-forward marker: `PHASE6_CARRY_FORWARD:TYPEVAR-06`.
  - Pending groups: `0`.

## Decisions Made

- Used ItemList `state_hover` with alpha values for cursor overlays instead of opaque hover fills.
- Routed selected ItemList rows through `shape.raised_lifts.selected_row`, preserving Tree vocabulary while allowing direction-owned raised behavior.
- Kept FoldableContainer title chrome in surface/state roles and mapped disclosure icons exactly to the Tree disclosure family.
- Made `itemlist-foldable` stage-specific to avoid reporting later-plan tabs/range placeholders as pending for this plan's verification.

## TDD Gate Compliance

- RED gate commit exists for Task 1: `413ae1c` (`test(06-03): add failing ItemList coverage verifier`).
- GREEN gate commit exists after Task 1 RED: `bc4704c` (`feat(06-03): implement ItemList theme slot coverage`).
- RED gate commit exists for Task 2: `32f0f36` (`test(06-03): add failing FoldableContainer coverage verifier`).
- GREEN gate commit exists after Task 2 RED: `1c9c041` (`feat(06-03): implement FoldableContainer theme slot coverage`).
- Refactor gate: not needed.

## Deviations from Plan

None - plan executed exactly as written.

## Known Stubs

- `.planning/phases/06-lists-layout-range-tree-itemlist-tabs-containers-sliders-des/helpers/_phase6_verify_headless.gd:13` - `tabs` stage comment remains a future Plan 06-04 placeholder.
- `.planning/phases/06-lists-layout-range-tree-itemlist-tabs-containers-sliders-des/helpers/_phase6_verify_headless.gd:14` - `range-containers` stage comment remains a future Plan 06-05 placeholder.
- `.planning/phases/06-lists-layout-range-tree-itemlist-tabs-containers-sliders-des/helpers/_phase6_verify_headless.gd:403` - `assert_tabs_stage_pending`; intentional placeholder for Plan 06-04.
- `.planning/phases/06-lists-layout-range-tree-itemlist-tabs-containers-sliders-des/helpers/_phase6_verify_headless.gd:407` - `assert_range_containers_stage_pending`; intentional placeholder for Plan 06-05.

These do not block Plan 06-03 because `itemlist-foldable` no longer calls later-plan pending groups; they remain active only for their owner stages and `full`.

## Issues Encountered

- RED verifier runs failed as intended before production changes: first for ItemList missing slots/opaque cursors, then for FoldableContainer missing constants/icons.

## Authentication Gates

None.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness

Ready for Plan 06-04. Tree, ItemList, and FoldableContainer now have strict verifier coverage for the Phase 6 list/disclosure slice, while tabs and range/container groups remain isolated for their owner plans.

## Self-Check: PASSED

- Found modified production file: `addons/neocade_theme/neocade_theme.gd`.
- Found modified verifier file: `.planning/phases/06-lists-layout-range-tree-itemlist-tabs-containers-sliders-des/helpers/_phase6_verify_headless.gd`.
- Found summary file: `.planning/phases/06-lists-layout-range-tree-itemlist-tabs-containers-sliders-des/06-03-SUMMARY.md`.
- Verified task commits exist: `413ae1c`, `bc4704c`, `32f0f36`, `1c9c041`, `6f666d9`.

---
*Phase: 06-lists-layout-range-tree-itemlist-tabs-containers-sliders-des*
*Completed: 2026-05-07*
