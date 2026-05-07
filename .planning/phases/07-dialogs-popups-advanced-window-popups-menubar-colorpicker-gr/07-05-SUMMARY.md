---
phase: 07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr
plan: 05
subsystem: theme-ui
tags: [godot-4.6, theme-slots, graph, graphedit, graphnode, graphframe, resourcesaver, tdd]

requires:
  - phase: 07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr
    provides: Phase 7 slot-freeze, popup/menu, FileDialog, and ColorPicker staged verifier baselines
provides:
  - GraphEdit official Godot 4.6.2 stylebox, color, constant, and toolbar icon coverage
  - GraphNode official panel, focus, selected, slot, resizer_color, constant, port, and resizer coverage
  - GraphFrame official flat grouping styleboxes, resizer_color, and resizer icon coverage
  - Final Phase 7 full verifier enforcing 37/37 desktop scorecard, graph extras, data-only direction resources, and no root fallback resource
affects: [phase-07, phase-08, phase-09, cov-08, cov-01, cov-07, cov-09]

tech-stack:
  added: []
  patterns:
    - Graph-family icon slots map one-to-one to graph_<slot>.svg assets
    - GraphNode and GraphFrame are enforced as Phase 7 advanced extras alongside the canonical 37-row scorecard
    - Full verifier validates data-only direction resources before and after ResourceSaver round-trip

key-files:
  created:
    - addons/neocade_theme/icons/graph_*.svg
    - addons/neocade_theme/icons/graph_*.svg.import
  modified:
    - addons/neocade_theme/neocade_theme.gd
    - .planning/phases/07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr/helpers/_phase7_verify_headless.gd

key-decisions:
  - "GraphEdit uses calm canvas/menu surfaces, official panel_focus, translucent grid/selection colors, visible connection colors, and three desktop graph constants."
  - "GraphNode and GraphFrame are verified as official Phase 7 graph extras in addition to the canonical 37-row desktop scorecard."
  - "The final full stage now enforces data-only direction resources, no root fallback neocade_theme.tres, and zero pending Phase 7 groups."

patterns-established:
  - "Graph verifier stage asserts official slot completeness, icon mappings, Texture2D loads, compact GraphNode chrome, flat GraphFrame grouping, and graph focus-slot discipline."
  - "ResourceSaver round-trip remains idempotent after Phase 7; all five direction resources stay stripped below 2 KiB with no sub_resource/theme_data blocks."

requirements-completed: [COV-08, COV-01, COV-07, COV-09]

duration: 10 min
completed: 2026-05-07
---

# Phase 07 Plan 05: Graph Stack and Final Closure Summary

**GraphEdit, GraphNode, and GraphFrame desktop coverage with final 37/37 Phase 7 verification and data-only ResourceSaver round-trip**

## Performance

- **Duration:** 10 min
- **Started:** 2026-05-07T11:20:16Z
- **Completed:** 2026-05-07T11:30:21Z
- **Tasks:** 3 completed
- **Files modified:** 20

## Accomplishments

- Authored 9 graph-family SVG icons and Godot import sidecars for GraphEdit toolbar controls plus GraphNode/GraphFrame port and resizer slots.
- Completed `BINDING_TABLE` coverage for every official GraphEdit, GraphNode, and GraphFrame slot from the Phase 7 slot freeze, including GraphFrame `resizer_color`.
- Replaced the pending graph verifier group with strict assertions and expanded `full` to enforce 37/37 canonical scorecard coverage, graph extras, no root fallback resource, and data-only direction resources.
- Ran full verification before and after ResourceSaver; the round-trip kept all five direction resources below 2 KiB with no generated Theme entries.

## Task Commits

1. **Task 1: Author and import graph icon assets** - `6b3c3ef` (feat)
2. **Task 2 RED: Add failing graph coverage verifier** - `025f8e0` (test)
3. **Task 2 GREEN: Implement GraphEdit, GraphNode, and GraphFrame official slot coverage** - `5f77ab5` (feat)
4. **Task 3: Run final Phase 7 verifier and ResourceSaver round-trip** - `cee8d80` (test)

## Files Created/Modified

- `addons/neocade_theme/icons/graph_grid_toggle.svg` and `.import` - GraphEdit grid toggle icon.
- `addons/neocade_theme/icons/graph_layout.svg` and `.import` - GraphEdit layout icon.
- `addons/neocade_theme/icons/graph_minimap_toggle.svg` and `.import` - GraphEdit minimap toggle icon.
- `addons/neocade_theme/icons/graph_snapping_toggle.svg` and `.import` - GraphEdit snapping toggle icon.
- `addons/neocade_theme/icons/graph_zoom_in.svg`, `graph_zoom_out.svg`, `graph_zoom_reset.svg` and imports - GraphEdit zoom controls.
- `addons/neocade_theme/icons/graph_port.svg` and `.import` - GraphNode port icon.
- `addons/neocade_theme/icons/graph_resizer.svg` and `.import` - Shared GraphNode/GraphFrame resizer icon.
- `addons/neocade_theme/neocade_theme.gd` - GraphEdit, GraphNode, and GraphFrame production bindings.
- `.planning/phases/07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr/helpers/_phase7_verify_headless.gd` - strict graph and full-stage closure assertions.
- `addons/neocade_theme/*_neocade_theme.tres` - ResourceSaver round-tripped and verified; no committed diff was produced because the resources were already in stripped data-only form.

## Verification

- `powershell -NoProfile -ExecutionPolicy Bypass -File .planning/phases/07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr/helpers/_run-phase7-verify.ps1 -Stage graph`: PASS.
  - Result: `PHASE7_VERIFY OK (stage=graph)`, 11 groups OK, 0 pending, 0 failures.
- `powershell -NoProfile -ExecutionPolicy Bypass -File .planning/phases/07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr/helpers/_run-phase7-verify.ps1 -Stage full`: PASS before ResourceSaver.
  - Result: `PHASE7_VERIFY OK (stage=full)`, 12 groups OK, 0 pending, 0 failures.
- `godot --headless --path . --script .planning/phases/07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr/helpers/_phase7_resource_saver.gd`: PASS.
  - Result: all five direction resources round-tripped, stripped, and reloaded.
  - Sizes: Pulse 417 bytes, Slate 418 bytes, Bubble 419 bytes, Daybreak 428 bytes, Burst 412 bytes.
- `powershell -NoProfile -ExecutionPolicy Bypass -File .planning/phases/07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr/helpers/_run-phase7-verify.ps1 -Stage full`: PASS after ResourceSaver.
  - Result: `PHASE7_VERIFY OK (stage=full)`, 12 groups OK, 0 pending, 0 failures.

## Decisions Made

- Used dedicated graph SVGs instead of reusing unrelated editor icons so the official GraphEdit/GraphNode/GraphFrame slot family remains explicit.
- Kept GraphEdit canvas chrome calm: low surface panel, subtle grid alpha split, translucent selection fill, opaque selection stroke, and visible connection colors.
- Kept GraphFrame flat and grouping-oriented by using translucent styleboxes, no shadows, shared resizer art, and explicit `resizer_color`.
- Enforced GraphNode and GraphFrame as Phase 7 extras outside the original 37 canonical scorecard list while still closing the scorecard at 37/37.

## TDD Gate Compliance

- RED gate commit exists: `025f8e0` (`test(07-05): add failing graph coverage verifier`).
- GREEN gate commit exists after RED: `5f77ab5` (`feat(07-05): implement graph theme coverage`).
- Refactor gate: not needed.

## Deviations from Plan

None - plan executed exactly as written.

## Known Stubs

None. Stub-pattern scan hits in touched GDScript files are verifier/resource-saver local empty arrays, null guards, empty-string parser state, or legitimate Godot slot names such as `font_placeholder_color`; none are UI-flowing placeholders introduced by this plan.

## Threat Flags

None. File and resource access added/used here is confined to phase-local verification helpers and the planned ResourceSaver round-trip; no production network, auth, file-ingest, or trust-boundary surface was introduced.

## Issues Encountered

- Godot generated new graph SVG imports with default `svg/scale=1.0` and `mipmaps/generate=false`; the sidecars were normalized to `svg/scale=2.0` and `mipmaps/generate=true`, then reimported before the Task 1 commit.
- ResourceSaver produced no committed direction-resource diff because the five resources were already in stripped data-only form after previous round-trip work.

## Authentication Gates

None.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness

Phase 7 Plan 05 is complete. The Phase 7 full verifier now has zero pending groups, closes the desktop structural scorecard at 37/37, enforces GraphEdit/GraphNode/GraphFrame official slot coverage, and confirms all five direction resources remain data-only after ResourceSaver.

## Self-Check: PASSED

- Verified the summary, production script, verifier helper, and all 18 graph SVG/import files exist on disk.
- Verified task commits exist in git: `6b3c3ef`, `025f8e0`, `5f77ab5`, `cee8d80`.
- Re-ran the plan-level `full` verification successfully after writing this summary.
- Verified no unexpected tracked file deletions in task commits.

---
*Phase: 07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr*
*Completed: 2026-05-07*
