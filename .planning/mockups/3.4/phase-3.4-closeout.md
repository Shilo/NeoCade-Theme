# Phase 3.4 Closeout — Visual Direction (Flat / Extruded-Flat) Mockup + Approval Gate

**Closeout authored:** 2026-05-06 (Plan 04 Task 1 → Task 4)
**Phase:** 03.4-visual-direction-flat-extruded-flat-mockup-approval-gate
**Status:** CLOSED — all gates passed; Phase 4 unblocked once `/gsd-verify-work` confirms.
**Approved final themes:** Pulse, Slate, Bubble, Daybreak, Burst (all 5 ship as data-only `.tres` peers).
**Recommended starter:** Pulse (showcase scene default + README "try this first" suggestion only — no architectural privilege).
**Architecture:** Single concrete `NeoCadeTheme` class + 5 data-only `.tres` peers (CORRECTIVE-ADDENDUM D-31, finalized 2026-05-06f).

---

## Section 1 — Final approval prerequisite (Plan 04 Task 1)

Plan 04 Task 1 mandates: confirm `.planning/mockups/3.4/final-approval.md` exists and records (a) at least one approved final theme, (b) exactly one recommended starter direction, (c) approval date, and (d) relationship to `NeoCadeTheme`. If any are missing, halt with `## CHECKPOINT REACHED`.

### Verification result: PASS

| Required marker | Source line in `final-approval.md` | Result |
|---|---|---|
| At least one approved final theme | §"Approved final themes" — table lists Pulse, Slate, Bubble, Daybreak, Burst with WCAG and ship status | PRESENT (5 themes) |
| Exactly one recommended starter direction | §"Base direction" — "Pulse — the v1 recommended starter direction. Confirmed by user 2026-05-06" | PRESENT (Pulse) |
| Approval date | §"Approval date" — "2026-05-06" | PRESENT |
| Relationship to `NeoCadeTheme` | §"Phase 4 prerequisite" — "single concrete `NeoCadeTheme` class will live at `addons/neocade_theme/neocade_theme.gd`" + 9-property `@export` set | PRESENT |

### Approval gate provenance

- **Approval date:** 2026-05-06.
- **Approved by:** User (project owner) at the Phase 3.4 Plan 03 Task 4 user-decision gate.
- **Selection kind:** `all-five-ship + recommended-starter` — every Phase 3.3 candidate was approved for v1 ship, with Pulse separately picked as the v1 recommended-starter (showcase default + README suggestion).
- **Gate file:** `.planning/mockups/3.4/final-approval.md` (frontmatter `gate: phase-3.4-plan-03-task-4`, `status: closed`).
- **Architectural framing:** D-31 reframed the historic D-16/D-17 "base direction" pick as "recommended starter" — values do NOT bake into class defaults; the picked direction is purely a soft commitment to (1) preload as the showcase scene's project theme and (2) name in the addon README's "try this first" suggestion. All 5 directions ship as peer data-only `.tres` files.
- **Forward-compat is_light demo:** Override C (`pulse-finalist-override-light.png`) added at user request demonstrates the architecture's `is_light = base_color.get_luminance() >= 0.5` flag flips text/surface/state-hover correctly. Light mode itself remains v2 (PROJECT.md Out of Scope); the wiring is documented in DESIGN_TOKENS.md as forward-compat work and Phase 4's `addons/neocade_theme/neocade_theme.gd` MUST carry the same branch into GDScript.

### Plan 04 unblocked

Final approval prerequisite is **complete**. Plan 04 Tasks 2-4 may proceed:
- Task 2 — write `.planning/DESIGN_TOKENS.md` (single-class / data-resource contract).
- Task 3 — Phase 3.4 success-criteria audit + decisions D-01..D-27 cross-reference (this file, §3).
- Task 4 — forbidden-surface and Phase 4 handoff audit (this file, §4).
