---
phase: 08-mobile-variant-token-block-tap-target-audit-updated-for-dyna
plan: 01
subsystem: verification
tags: [godot-4.6, mobile, verifier, tap-targets, architecture]

requires:
  - phase: 07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr
    provides: Phase 7 staged verifier pattern and locked data-only direction resource architecture
provides:
  - Phase 8 staged verifier runner and architecture gate
  - Phase 8 tap-target audit helper skeleton with 37-row classification
  - Frozen mobile contract artifact for forced platform and audit policy
affects: [phase-08, phase-09, phase-10, MOBILE-01, MOBILE-02, MOBILE-06, MOBILE-08]

tech-stack:
  added: []
  patterns:
    - Phase-local PowerShell runner resolves a local Godot 4.6.x executable and invokes a headless SceneTree verifier
    - Full verifier stages fail on pending groups until their owner plans close them
    - Tap-target rows are classified as interactive, display, or layout before strict enforcement

key-files:
  created:
    - .planning/phases/08-mobile-variant-token-block-tap-target-audit-updated-for-dyna/helpers/Resolve-Godot46.ps1
    - .planning/phases/08-mobile-variant-token-block-tap-target-audit-updated-for-dyna/helpers/_run-phase8-verify.ps1
    - .planning/phases/08-mobile-variant-token-block-tap-target-audit-updated-for-dyna/helpers/_phase8_verify_headless.gd
    - .planning/phases/08-mobile-variant-token-block-tap-target-audit-updated-for-dyna/helpers/_phase8_tap_target_audit.gd
    - .planning/phases/08-mobile-variant-token-block-tap-target-audit-updated-for-dyna/helpers/phase8-mobile-contract.txt
  modified: []

key-decisions:
  - "Phase 8 verifier starts with a strict architecture gate and explicit pending groups for platform tokens, tap targets, docs, and scene toggle."
  - "The tap-target audit classifies all 37 scorecard rows before enforcement so display/layout controls are documented rather than fake-padded."

patterns-established:
  - "Phase 8 verifier constants lock APPROVED_DIRECTIONS, EXPECTED_EXPORTS, ROOT_FALLBACK_PATH, and MOBILE_FALLBACK_PATH from the first plan."
  - "The architecture stage rejects forbidden mobile/root fallback resources, per-direction addon-root scripts, Theme.clear-style reset calls, and missing direction exports."

requirements-completed: [MOBILE-01, MOBILE-02, MOBILE-06, MOBILE-08]

duration: 8 min
completed: 2026-05-07
---

# Phase 08 Plan 01: Verification Foundation Summary

**Phase-local Godot verifier foundation with architecture invariants, 37-row tap-target classification, and a frozen mobile contract**

## Performance

- **Duration:** 8 min
- **Started:** 2026-05-07T12:23:00Z
- **Completed:** 2026-05-07T12:31:00Z
- **Tasks:** 3 completed
- **Files modified:** 7

## Accomplishments

- Added the Phase 8 Godot resolver/runner pair with the six planned stages: `architecture`, `platform-tokens`, `tap-targets`, `docs`, `scene-toggle`, and `full`.
- Added `_phase8_verify_headless.gd` with a passing architecture stage and explicit pending groups for later plans.
- Added `_phase8_tap_target_audit.gd` with all five direction paths, forced `NeoCadeTheme.Platform.MOBILE`, both raised states, `MIN_TAP_TARGET := 48`, and all 37 scorecard classifications.
- Added `phase8-mobile-contract.txt` recording the five approved direction resources, forbidden mobile/root/per-density resources, locked 9 exports, platform matrix, and 48px audit policy.

## Task Commits

This plan was committed atomically as one plan-level commit per the Phase 8 execution instruction.

## Files Created/Modified

- `.planning/phases/08-mobile-variant-token-block-tap-target-audit-updated-for-dyna/helpers/Resolve-Godot46.ps1` - Phase-local Godot 4.6 resolver adapted from the Phase 7 helper.
- `.planning/phases/08-mobile-variant-token-block-tap-target-audit-updated-for-dyna/helpers/_run-phase8-verify.ps1` - Stage-aware PowerShell runner.
- `.planning/phases/08-mobile-variant-token-block-tap-target-audit-updated-for-dyna/helpers/_phase8_verify_headless.gd` - Architecture gate and staged verifier skeleton.
- `.planning/phases/08-mobile-variant-token-block-tap-target-audit-updated-for-dyna/helpers/_phase8_tap_target_audit.gd` - Tap-target audit helper skeleton and classification table.
- `.planning/phases/08-mobile-variant-token-block-tap-target-audit-updated-for-dyna/helpers/phase8-mobile-contract.txt` - Frozen Phase 8 mobile contract.

## Verification

- `powershell -NoProfile -ExecutionPolicy Bypass -File .planning/phases/08-mobile-variant-token-block-tap-target-audit-updated-for-dyna/helpers/_run-phase8-verify.ps1 -Stage architecture`: PASS.
  - Result: `PHASE8_VERIFY OK (stage=architecture)`, 1 group OK, 0 pending, 0 failures.
- `rg -n "architecture|platform-tokens|tap-targets|docs|scene-toggle|full" .../_run-phase8-verify.ps1`: PASS.
- `rg -n "APPROVED_DIRECTIONS|EXPECTED_EXPORTS|ROOT_FALLBACK_PATH|MOBILE_FALLBACK_PATH" .../_phase8_verify_headless.gd`: PASS.
- `rg -n "PHASE8_TAP_TARGET_AUDIT|MIN_TAP_TARGET := 48|SCORECARD_37|interactive|display|layout|Platform.MOBILE" .../_phase8_tap_target_audit.gd`: PASS.
- `rg -n "48px|DESKTOP|MOBILE|AUTO|pulse_neocade_theme|neocade_mobile_theme.tres|9 exports|density" .../phase8-mobile-contract.txt`: PASS.

## Decisions Made

- Kept later verifier stages pending rather than soft-passing them, preserving Phase 6/7 staged discipline.
- Used one audit helper as the shared source for both report generation and verifier checks so Plan 08-03 can replace pending logic with strict formulas without adding architecture.

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered

None.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness

Plan 08-02 can now harden forced platform tokens against a green architecture gate. The full stage is expected to fail until later owner plans close pending groups.

## Self-Check: PASSED

- Verified architecture stage exits 0.
- Verified all planned helper/contract files exist.
- Verified no production or direction resource file was modified in this foundation plan.

---
*Phase: 08-mobile-variant-token-block-tap-target-audit-updated-for-dyna*
*Completed: 2026-05-07*
