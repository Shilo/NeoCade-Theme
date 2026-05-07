---
phase: 06-lists-layout-range-tree-itemlist-tabs-containers-sliders-des
plan: 02
subsystem: theme-tree
tags: [godot-4.6, tree, theme-slots, icons, tdd]

requires:
  - phase: 06-lists-layout-range-tree-itemlist-tabs-containers-sliders-des
    provides: Plan 06-01 slot-freeze verifier and Godot import helpers
provides:
  - Full official Godot 4.6.2 Tree slot coverage
  - Tree disclosure, indeterminate, scroll hint, select, and sort SVG icons
  - Strict Tree verifier stage with COV and TYPEVAR carry-forward markers
affects: [phase-06, phase-08, cov-05, cov-01, cov-09, typevar-06]

tech-stack:
  added: []
  patterns:
    - TDD verifier stage for heavy Control slot coverage
    - Godot-generated SVG import sidecars with locked NeoCade icon settings

key-files:
  created:
    - addons/neocade_theme/icons/disclosure_expanded.svg
    - addons/neocade_theme/icons/disclosure_expanded.svg.import
    - addons/neocade_theme/icons/disclosure_expanded_mirrored.svg
    - addons/neocade_theme/icons/disclosure_expanded_mirrored.svg.import
    - addons/neocade_theme/icons/disclosure_collapsed.svg
    - addons/neocade_theme/icons/disclosure_collapsed.svg.import
    - addons/neocade_theme/icons/disclosure_collapsed_mirrored.svg
    - addons/neocade_theme/icons/disclosure_collapsed_mirrored.svg.import
    - addons/neocade_theme/icons/tree_indeterminate.svg
    - addons/neocade_theme/icons/tree_indeterminate.svg.import
    - addons/neocade_theme/icons/tree_scroll_hint.svg
    - addons/neocade_theme/icons/tree_scroll_hint.svg.import
    - addons/neocade_theme/icons/tree_select_arrow.svg
    - addons/neocade_theme/icons/tree_select_arrow.svg.import
    - addons/neocade_theme/icons/tree_updown.svg
    - addons/neocade_theme/icons/tree_updown.svg.import
  modified:
    - addons/neocade_theme/neocade_theme.gd
    - .planning/phases/06-lists-layout-range-tree-itemlist-tabs-containers-sliders-des/helpers/_phase6_verify_headless.gd

key-decisions:
  - "Tree keeps dense editor/data-view constants while selected rows use accent-derived fills and cursor/hover states remain semi-transparent overlays."
  - "Tree fonts are set explicitly outside BINDING_TABLE: body Inter for rows and header-weight Inter for title buttons."
  - "TYPEVAR-06 remains Phase 8-owned; Plan 06-02 emits only a carry-forward verifier marker for Tree density/focus/icon behavior."

patterns-established:
  - "Tree icon recipes are verifier-checked against explicit official-slot-to-SVG mappings."
  - "Tree role-color verification recomputes outline/accent roles from the loaded direction theme."

requirements-completed: [COV-05, COV-01, COV-09]

duration: 8 min
completed: 2026-05-07
---

# Phase 06 Plan 02: Tree Coverage Summary

**Official Godot 4.6.2 Tree theming with dense rows, explicit fonts, strict slot verification, and NeoCade disclosure icons**

## Performance

- **Duration:** 8 min
- **Started:** 2026-05-07T08:45:45Z
- **Completed:** 2026-05-07T08:52:55Z
- **Tasks:** 3 completed
- **Files modified:** 18 production/helper/icon files

## Accomplishments

- Added 8 bespoke 32x32 monochrome Tree/disclosure SVGs plus Godot import sidecars using the Phase 4 icon contract.
- Expanded `BINDING_TABLE.Tree` to cover all official Godot 4.6.2 Tree styleboxes, colors, constants, font sizes, and icons.
- Added explicit Tree font bindings and a strict Tree verifier stage that checks slot coverage, cursor transparency, focus discipline, role-derived colors, and exact icon recipes.

## Task Commits

1. **Task 1: Author and import Tree icon assets** - `98f3e31` (feat)
2. **Task 2 RED: Add failing Tree coverage verifier** - `2f24aad` (test)
3. **Task 2 GREEN: Implement full Tree slot coverage** - `a9ed81c` (feat)
4. **Task 3: Record Tree coverage contribution for Phase 8 documentation** - `0d9fdf2` (test)

## Files Created/Modified

- `addons/neocade_theme/icons/disclosure_expanded.svg` and `.import` - Tree expanded arrow / Foldable expanded reuse asset.
- `addons/neocade_theme/icons/disclosure_expanded_mirrored.svg` and `.import` - mirrored expanded disclosure asset for later Foldable reuse.
- `addons/neocade_theme/icons/disclosure_collapsed.svg` and `.import` - Tree collapsed arrow asset.
- `addons/neocade_theme/icons/disclosure_collapsed_mirrored.svg` and `.import` - Tree RTL collapsed arrow asset.
- `addons/neocade_theme/icons/tree_indeterminate.svg` and `.import` - Tree checkbox indeterminate state asset.
- `addons/neocade_theme/icons/tree_scroll_hint.svg` and `.import` - Tree scroll hint asset.
- `addons/neocade_theme/icons/tree_select_arrow.svg` and `.import` - Tree select arrow asset.
- `addons/neocade_theme/icons/tree_updown.svg` and `.import` - Tree sort/updown affordance asset.
- `addons/neocade_theme/neocade_theme.gd` - Tree fonts, colors, constants, font sizes, icon recipes, and semi-transparent hover/cursor overlays.
- `.planning/phases/06-lists-layout-range-tree-itemlist-tabs-containers-sliders-des/helpers/_phase6_verify_headless.gd` - strict Tree verifier and TYPEVAR-06 carry-forward marker.

## Verification

- `powershell -NoProfile -Command "$godot = (Get-Content '.planning/phases/06-lists-layout-range-tree-itemlist-tabs-containers-sliders-des/helpers/godot-cli-path.txt' -Raw).Trim(); & $godot --headless --path . --import --quit-after 2"`: PASS.
- `rg -n '#FFFFFF|uid://|svg/scale=2.0|mipmaps/generate=true' addons/neocade_theme/icons/disclosure_expanded.svg addons/neocade_theme/icons/disclosure_expanded.svg.import addons/neocade_theme/icons/tree_indeterminate.svg addons/neocade_theme/icons/tree_indeterminate.svg.import`: PASS.
- `powershell -NoProfile -ExecutionPolicy Bypass -File .planning/phases/06-lists-layout-range-tree-itemlist-tabs-containers-sliders-des/helpers/_run-phase6-verify.ps1 -Stage tree`: PASS.
  - OK markers: `assert_slot_freeze`, `assert_known_stale_slots_absent`, `assert_no_theme_clear`, `assert_one_addon_root_gd`, `assert_public_export_lock`, `assert_slot_freeze_artifact`, `assert_tree_stage`.
  - Coverage markers: `PHASE6_COVERAGE_OK:COV-05`, `PHASE6_COVERAGE_OK:COV-01`, `PHASE6_COVERAGE_OK:COV-09`.
  - Carry-forward marker: `PHASE6_CARRY_FORWARD:TYPEVAR-06`.
  - Pending markers remain for Plans 06-03 through 06-05 only.

## Decisions Made

- Used accent-offset selected rows with high-contrast text, while hover/cursor styleboxes use low alpha so they remain overlays.
- Kept Tree row constants dense and integer-based instead of using game-menu-sized padding.
- Reused existing checkbox SVGs for checked/unchecked Tree states and added only the missing Tree-specific assets.

## TDD Gate Compliance

- RED gate commit exists: `2f24aad` (`test(06-02): add failing Tree coverage verifier`).
- GREEN gate commit exists after RED: `a9ed81c` (`feat(06-02): implement Tree theme slot coverage`).
- Refactor gate: not needed.

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 3 - Blocking] Locked Godot SVG import settings after default import**
- **Found during:** Task 1 (Author and import Tree icon assets)
- **Issue:** The first Godot import generated real `.svg.import` sidecars, but with editor-default `svg/scale=1.0` and `mipmaps/generate=false`, which failed the Phase 4/6 icon contract.
- **Fix:** Preserved the generated `uid://` and `.ctex` paths, set `svg/scale=2.0` and `mipmaps/generate=true`, and reran Godot import.
- **Files modified:** New Tree/disclosure `.svg.import` sidecars.
- **Verification:** Re-ran Godot import and `rg` contract checks for `uid://`, `svg/scale=2.0`, and `mipmaps/generate=true`.
- **Committed in:** `98f3e31`

**Total deviations:** 1 auto-fixed (Rule 3 blocking)
**Impact on plan:** Required to satisfy the planned icon import contract; no architecture or scope change.

## Known Stubs

- `.planning/phases/06-lists-layout-range-tree-itemlist-tabs-containers-sliders-des/helpers/_phase6_verify_headless.gd:377` - `assert_itemlist_foldable_stage_pending`; intentional placeholder for Plan 06-03.
- `.planning/phases/06-lists-layout-range-tree-itemlist-tabs-containers-sliders-des/helpers/_phase6_verify_headless.gd:381` - `assert_tabs_stage_pending`; intentional placeholder for Plan 06-04.
- `.planning/phases/06-lists-layout-range-tree-itemlist-tabs-containers-sliders-des/helpers/_phase6_verify_headless.gd:385` - `assert_range_containers_stage_pending`; intentional placeholder for Plan 06-05.

These do not block Plan 06-02 because the Tree stage is now strict and passing; the remaining pending groups are owned by later Phase 6 plans.

## Issues Encountered

- The RED verifier failed as intended before production changes, reporting missing Tree colors, constants, icons, opaque cursor overlays, and missing icon recipes.

## Authentication Gates

None.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness

Ready for Plan 06-03. Tree no longer relies on engine defaults for official Tree 4.6.2 slots, and the verifier now carries a strict Tree gate for later Phase 6 work.

## Self-Check: PASSED

- Verified key created/modified files exist on disk.
- Verified task commits exist in git: `98f3e31`, `2f24aad`, `a9ed81c`, `0d9fdf2`.
- Re-ran `_run-phase6-verify.ps1 -Stage tree`; it passed with 7 OK groups, 3 later-plan pending groups, and 0 failures.
- Verified no unexpected tracked file deletions in task commits.

---
*Phase: 06-lists-layout-range-tree-itemlist-tabs-containers-sliders-des*
*Completed: 2026-05-07*
