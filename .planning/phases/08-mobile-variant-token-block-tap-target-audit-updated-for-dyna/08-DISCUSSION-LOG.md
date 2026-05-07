# Phase 8: Mobile Variant Token Block + Tap-Target Audit - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md - this log preserves the alternatives considered.

**Date:** 2026-05-07
**Phase:** 8-Mobile Variant Token Block + Tap-Target Audit
**Areas discussed:** Autonomous scope, dynamic mobile architecture, mobile sizing defaults, tap-target audit, documentation and test scene, verification

---

## Autonomous Scope

| Option | Description | Selected |
|--------|-------------|----------|
| Use agent best judgement | Continue Phase 8 under authorized `/gsd-autonomous` scope for Phases 6-8. | yes |
| Pause for user sizing decisions | Ask the user to choose every mobile sizing/audit policy. | |
| Defer mobile until device availability | Stop until UD-5 real-device testing details are resolved. | |

**User's choice:** Auto-selected recommended option under Phases 6-8 autonomous authorization.
**Notes:** UD-5 remains Phase 10 scope; Phase 8 can prove local forced-mobile behavior.

---

## Dynamic Mobile Architecture

| Option | Description | Selected |
|--------|-------------|----------|
| Platform export mode only | Keep mobile as `platform=MOBILE/AUTO` on the single class and direction resources. | yes |
| Separate mobile `.tres` resources | Reintroduce `neocade_mobile_theme.tres` or per-direction mobile siblings. | |
| Per-density resources | Generate Android density-bucket theme files. | |

**User's choice:** Auto-selected recommended option.
**Notes:** Matches PROJECT.md and REQUIREMENTS.md after the architecture redirect.

---

## Mobile Sizing Defaults

| Option | Description | Selected |
|--------|-------------|----------|
| 48px contract | Use 48px as the interactive target floor, body 16px, spacing density +50%, radii unchanged. | yes |
| Native-platform mimicry | Change sizing and style to resemble iOS/Android native controls. | |
| Minimal deltas | Only bump a few obvious controls and leave the rest desktop-sized. | |

**User's choice:** Auto-selected recommended option.
**Notes:** Reconciles iOS HIG and Material 3 while preserving NeoCade identity.

---

## Tap-Target Audit

| Option | Description | Selected |
|--------|-------------|----------|
| Strict computed audit | Build a phase helper that computes/document per-type theme-controlled tap proxies and fails below 48px. | yes |
| Visual-only audit | Rely on the test scene and manual inspection. | |
| Full runtime device audit now | Require Android/iOS devices before accepting Phase 8. | |

**User's choice:** Auto-selected recommended option.
**Notes:** Device testing remains later; Phase 8 needs a deterministic local gate.

---

## Documentation and Test Scene

| Option | Description | Selected |
|--------|-------------|----------|
| Root spec plus minimal toggle proof | Create `MOBILE-DESIGN-SPEC.md` and wire only enough scene control to prove platform/raised toggles. | yes |
| Build full showcase now | Move Phase 9 showcase work into Phase 8. | |
| Spec only | Skip toggle proof and leave scene behavior to Phase 9. | |

**User's choice:** Auto-selected recommended option.
**Notes:** Avoids scope creep while satisfying the Phase 8 success criterion.

---

## Verification

| Option | Description | Selected |
|--------|-------------|----------|
| Phase-local staged verifier | Follow Phase 6/7 helper discipline with full-stage zero pending groups and all five directions checked. | yes |
| Manual checklist | Write docs and rely on reviewer judgement. | |
| Cross-platform screenshots now | Pull Phase 10 screenshot/export work forward. | |

**User's choice:** Auto-selected recommended option.
**Notes:** Keeps Phase 8 structural and deterministic.

---

## the agent's Discretion

- Exact audit formulas and helper names.
- Whether sizing fixes happen through tokens, BINDING_TABLE recipes, direct calls, or helper functions.
- Minimal support code needed for platform/raised toggle proof.

## Deferred Ideas

- Phase 10 real-device/browser validation.
- Phase 9 full showcase visual proof.
- v2 native/platform-specific features or DPI-adaptive theme generation.
