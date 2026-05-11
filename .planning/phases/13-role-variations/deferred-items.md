# Phase 13 Deferred Items

Items discovered during Phase 13 execution that are out of scope for the current plan and tracked here for future closure.

## DI-13-01 — `default-chrome-unchanged` verifier stage over-strict on PanelContainer alpha

**Discovered:** Plan 13-02 Task 3 diagnostic run (2026-05-11)
**Out-of-scope rationale:** Pre-existing behavior from Phase 12 (`shape.surface_alpha_panels` is a per-direction translucency token); not introduced by Plan 13-02. Plan 13-02 scope is registry growth + explicit Role Label fonts; alpha-band sanity for default chrome is the stage's own contract.
**Stage:** `_phase13_verify_headless.gd --stage default-chrome-unchanged`
**Symptom:** `style=Daybreak PanelContainer.panel bg_color has translucent alpha 0.960 — Phase 12 baseline was opaque`
**Root cause:** The stage was authored in Wave 0 (Plan 13-01) under the assumption that the default `PanelContainer.panel` stylebox has opaque `bg_color.a >= 0.99`. Empirically the Phase 12 baseline (which Plan 13-01 had not yet run) renders the default panel with `bg_color.a = shape.surface_alpha_panels` from each direction's preset. For Daybreak this resolves to ~0.96 (within the stage's [0.05, 0.99] "translucent" band). The stage therefore false-RED-s on Phase 12 baseline behavior. SC#3 is genuinely intact: Wave 1 only added 9 new variation slots and 8 new font/font_size calls; no edit touched the default `PanelContainer.panel` recipe.
**Recommended fix (future plan):** Relax the stage's alpha-band check so that `bg_color.a == shape.surface_alpha_panels` is accepted as "Phase 12 baseline" while alpha values near `0.06` (the Phase 13 Role Panel tint literal) are still flagged. The simplest form is to check that no bound `bg_color` in default `PanelContainer.panel` references a `role_<x>` token — which is what SC#3 actually mandates — rather than an alpha-band heuristic. Plan 13-03 or 13-04 owner discretion.
**Impact on Plan 13-02:** None. Plan 13-02 SC#3 invariant ("default chrome unchanged from Phase 12 baseline") is upheld by inspection of the diff: zero lines of the default `Label` color recipe or default `PanelContainer.panel` recipe were touched. Wave 1 added 9 new TYPE_VARIATIONS entries (none colliding with `Label` or `PanelContainer`) plus 8 new explicit font/font_size lines (all keyed to the 4 new Role Label variation names, never to `Label` itself).
