---
gate: phase-3.4-plan-03-task-4
approval_date: 2026-05-06
status: closed
selection_kind: all-five-ship + recommended-starter
---

# Phase 3.4 Plan 03 Task 4 — Final Approval

## Approval date

2026-05-06.

## Approved final themes

All five v1 directions are approved for ship as data-only `.tres` peers under the locked single-concrete-class architecture (`CORRECTIVE-ADDENDUM` D-31, finalized 2026-05-06e/f). v1 ships **1 `.gd` + 5 `.tres`** at the addon root:

| Direction | v1 ship status | base_color | accent_color | WCAG contrast | Phase 4 implementation order |
|---|---|---|---|---|---|
| Pulse    | approved as v1 **recommended starter** (showcase scene default + README "try this first") | `#151A2E` | `#8BFF6A` | 13.62:1 | implement first |
| Slate    | approved as v1 personality variation | `#111820` | `#8BD3FF` | 10.94:1 | implement after Pulse |
| Bubble   | approved as v1 personality variation | `#241326` | `#FFB3E6` | 10.74:1 | implement after Pulse |
| Daybreak | approved as v1 personality variation | `#0B2420` | `#76F2D1` | 11.96:1 | implement after Pulse |
| Burst    | approved as v1 personality variation | `#20112E` | `#FFD166` | 12.33:1 | implement after Pulse |

CLAUDE.md "v1 ships N user-approved theme subclass `.tres` files" resolves to **N = 5** for v1.

## Rejected / deferred finalist themes

None. All five candidate directions from `THEME-DIRECTIONS.md` (Revision Round 2/2 dark-only) are approved.

## Base direction

Under the D-31 reframing, "base direction" is **reframed as "recommended starter"** — the picked direction has only two soft commitments (showcase scene default + README "try this first" suggestion). No values bake into superclass defaults. The recommended starter for v1 is:

**Pulse** — the v1 recommended starter direction. Confirmed by user 2026-05-06 at the Plan 03 final-approval gate: *"everything else is approved"* (after the cream-light forward-compat demo passed review).

## Notes / revision caveats

### Plan 03 deliverable approvals (this gate)

- Pulse 4-grid (flat × raised × desktop × mobile) — approved.
- Color-override row (Override A warm-amber, Override B ocean-cyan, Override C cream-light) — approved. Override C is a forward-compat demo of the `is_light = base_color.get_luminance() >= 0.5` flag for v2 light mode; **v1 still ships dark-only** per PROJECT.md Out of Scope. The flag is wired into the renderer today and will carry into Phase 4's `addons/neocade_theme/neocade_theme.gd`.
- Full Control/state coverage matrix for the architecture (40 user-facing Godot 4.6 Control classes + Pitfall 1.1 state combos `pressed_focus`, `checked_focus`, `hover_pressed`) — approved.
- Render-check audit (anti-cyberpunk, anti-texture, anti-painterly-chrome, mobile tap-targets, text-fit, overlap, forbidden-surface, light-mode `is_light` flag wiring) — all PASS.

### Forward-tracked v1.x backlog items

These survived the gate but are explicitly **not v1 work** — captured here so they aren't lost between Phase 3.4 → Phase 4 → … → v1 ship.

- **Pulse colorfulness pass** (carried from Plan 02 Task 4 finalist-selection.md): increase per-Control accent variety in `pulse_neocade_theme.tres` while preserving cabinet-control-panel mood. No `@export` changes (v2 territory). No texture / gradient / translucency on chrome. Author the change as Theme-Editor entry overrides per `.tres`, not new exports.
- **Other directions' polish passes** (Slate / Bubble / Daybreak / Burst): surface concerns once Phase 4 lands them in real Godot Controls; capture per direction in v1.x backlog as Phase 4-7 progresses.
- **v2 light mode**: the `is_light` flag is already wired in the mockup renderer (Override C demonstrates it) and will be wired into the production `NeoCadeTheme.gd` in Phase 4. v2 can plug in light variants like `light_pulse_neocade_theme.tres` via two `@export` values (light `base_color`, dark-enough `accent_color`) without code changes. Out of scope for v1.

## Phase 4 prerequisite

**Phase 4 may implement only after `DESIGN_TOKENS.md` is written in Plan 04.** Plan 04 is autonomous and unblocks now that this gate is closed. Phase 4 itself starts after `/gsd-verify-work` of Phase 3.4 passes and the user advances to Phase 4 via `/gsd-discuss-phase 4` (per project CLAUDE.md, no `/clear` within a phase but `/clear` between phases is required).

The single concrete `NeoCadeTheme` class will live at `addons/neocade_theme/neocade_theme.gd` (per Track 4 flat-addon-layout) with the locked 9-property `@export` set: Core (`base_color`, `accent_color`, `raised`, `platform`) + Shape (`corner_radius`, `spacing`, `raised_strength`, `focus_thickness`, `outline_width`). All five direction `.tres` files live at `addons/neocade_theme/{name}_neocade_theme.tres` (no `_dev/`, no `themes/`, no root `neocade_theme.tres`, no `neocade_mobile_theme.tres`).

## Phase 3.4 next steps

Plan 03 Task 4 user gate is now **closed**. Plan 03's remaining cleanup (SUMMARY closure) plus Plan 04 (DESIGN_TOKENS.md closeout + Phase 4 handoff) remain. Workflow resumes within `/gsd-execute-phase 3.4` — no `/clear` between within-phase commands per project CLAUDE.md.
