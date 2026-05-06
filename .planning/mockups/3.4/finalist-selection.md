---
gate: phase-3.4-plan-02-task-4
date: 2026-05-06
status: closed
selection_kind: recommended-starter
---

# Phase 3.4 Plan 02 Task 4 — Finalist Selection

## Selected finalists

**Pulse** — designated v1 **recommended starter direction**.

Selected by user 2026-05-06 after reviewing the rev-4 concept gallery: 15 PNGs covering the 5 candidate directions × 3 variants (desktop-flat, mobile-flat, mobile-raised), at the post-rev-4 treatment that landed across mockup revisions 2 → 3 → 4 (broader raised matrix + per-color offset tokens with `tintTowardBase()` mix-toward-base 40% replacing the rev-2 darken-floored-at-0 → near-black fix + universal modal scrim + axis-11 surface-alpha mood tuning).

User framing, verbatim: *"first use the Pulse theme as the final selection, we will implement that theme first"* and *"i eventually want to use all of them as theme variations."* All five candidate directions ship in v1; Pulse is the implementation priority and the README/showcase default.

## Inspiration source confirmed

Pulse's *"vibrant arcade hall by day, cabinet control panel"* mood was inspired by the **LDtk editor interface** (https://ldtk.io/docs/general/editor-components/). The direction was authored in Phase 3.3 as the personality nearest a tool-app / control-panel mental model — sharp 0 px corners everywhere, flush rectangular cabinet-strip tabs, square-cabinet-bezel brand mark, dense arcade-grid spacing (18 px padding / 10 px gap), wide 4-stop surface ramp, and an active green primary that reads as a lit cabinet button rather than a glowing nightclub tube. The user's confirmation closes the loop on whether the personality landed: it does.

LDtk-as-inspiration follows the project's standing posture: LDtk is loose inspiration, not spec — adoption stays curated even when mining is comprehensive, and values are never lifted verbatim. The Phase 2 LDtk source mining outputs (mood notes, layout patterns) informed Pulse's authoring in Phase 3.3 but did not constrain the palette or shape-axis values, all of which were derived from the project's own dark-only / flat-MD3 / no-glow / anti-cyberpunk constraints. Pulse's `base_color = #151A2E` and `accent_color = #8BFF6A` are NeoCade-original, not LDtk-extracted.

No Pulse values change as a result of this confirmation. The `pulse_neocade_theme.tres` Phase 4 will author per the [data/directions.json](.planning/mockups/3.4/data/directions.json) Pulse block and the rev-3/rev-4 mockup-validated shape-language axes (1 through 11).

## Status of the other four directions — NOT rejected

Per the user's framing *"i eventually want to use all of them as theme variations,"* Slate, Bubble, Daybreak, and Burst remain approved for v1 ship as personality variations. The locked single-concrete-class-plus-N-data-tres architecture (Track 5, 2026-05-06e/f) makes "1 starter direction + 4 personality variations" the natural shape — no `.gd` per direction, no class hierarchy. v1 ships **1 `.gd` + 5 `.tres`** at the addon root (`addons/neocade_theme/neocade_theme.gd` plus `pulse_neocade_theme.tres`, `slate_neocade_theme.tres`, `bubble_neocade_theme.tres`, `daybreak_neocade_theme.tres`, `burst_neocade_theme.tres`).

Pulse's role as recommended starter does NOT bake any of its values into `NeoCadeTheme` class defaults. The @export set is intentionally minimal (4 core + 5 shape = 9 properties), and per-direction personality lives in Theme Editor entry overrides per `.tres`. The "recommended starter" designation is two soft commitments only:

1. The showcase scene's default theme is `pulse_neocade_theme.tres`.
2. The README's "try this first" suggestion points to Pulse.

| Direction | v1 ship status | Phase 4 implementation order |
|---|---|---|
| Pulse    | ship as recommended starter (showcase default + README "try this first") | implement first |
| Slate    | ship as personality variation | implement after Pulse |
| Bubble   | ship as personality variation | implement after Pulse |
| Daybreak | ship as personality variation | implement after Pulse |
| Burst    | ship as personality variation | implement after Pulse |

Older project wording of "v1 ships N user-approved theme subclass `.tres` files" resolves under the current architecture to **N = 5 data-only direction `.tres` files** for v1.

## Future revision notes

### Pulse colorfulness — open for v1.x

User noted at the gate: *"i still dont think its colorful enough yet, so we can just mention that as a possible revision note in the future. but for now we should just work with what we have."*

Captured here so the concern survives the Phase 3.4 → Phase 4 → … → v1.0 ship transition. The intent is to revisit Pulse's color story after v1 ships, **without** changing v1's `pulse_neocade_theme.tres` content during the current milestone.

Constraints on what "more colorful" can mean given the locked architecture:

- The `@export` set is finalized at **9 properties** (4 core + 5 shape) per architecture revision 06f. Adding a "secondary accent" `@export` to expand Pulse's color story is a **v2 architecture change**, not v1.x.
- Per-direction personality is authored in **Theme Editor entry overrides per `.tres`** — Pulse's `.tres` can introduce richer tonal mid-stops, more accent placement, and secondary tints on specific Controls (progress fills, active states, brand-mark inner bezel, etc.) without changing the @export contract.
- The `wide` `axis_8_surface_spread` already drives a 4-stop tonal ramp for Pulse. Expanding to richer per-Control tinted overrides in `pulse_neocade_theme.tres` is the lever most consistent with the architecture.
- The `axis_11_surface_alpha` block (rev-4) currently sits at solid 1.00 across the board for Pulse (cabinet hardware metaphor). A future colorfulness pass should NOT change this — translucent cabinets read as glass UI, which is the wrong personality. Color expansion comes from accent placement / per-Control tinted overrides, not from alpha.

Phase 4 itself is **not** the place to land this — Phase 4's success criterion is that all 5 directions ship and feature-complete to `godot-minimal-theme`'s bar, with Pulse's currently-defined data-tokens. The colorfulness pass is a separate v1.x feat tracked in the deferred-items section of the milestone.

**Tracking entry for v1.x backlog:** *Pulse colorfulness pass — increase per-Control accent variety in `pulse_neocade_theme.tres` (richer tonal mid-stops, accent placement on more Controls, secondary tints on progress/active states/brand-mark inner bezel) while preserving cabinet-control-panel mood. No `@export` changes (v2 territory). No texture / no gradient on chrome (project hard rule). No translucency on cabinet surfaces (Pulse personality lock).*

### Other-direction polish — open for v1.x as discovered

Slate / Bubble / Daybreak / Burst will surface their own colorfulness / mood / fidelity concerns once Phase 4 implementation lands them in real Godot Controls. Capture per direction in v1.x backlog as Phase 4-7 progresses.

## Phase 3.4 next steps

Plan 02 Task 4 user gate is now **closed**. Plan 02's remaining cleanup (Task 5: SUMMARY emission) plus Plan 03 (finalist four-grid mockups + approval gate) and Plan 04 (design tokens closeout + Phase 4 handoff) remain.

Workflow resumes with `/gsd-execute-phase 3.4` (auto-resumes from the recorded gate) per CLAUDE.md — no `/clear` between within-phase commands.
