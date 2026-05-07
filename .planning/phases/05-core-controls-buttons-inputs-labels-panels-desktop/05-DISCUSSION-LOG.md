# Phase 5: Core Controls — Buttons, Inputs, Labels, Panels (desktop) - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md — this log preserves the alternatives considered.

**Date:** 2026-05-07
**Phase:** 05-core-controls-buttons-inputs-labels-panels-desktop
**Areas discussed:** Variation authoring mechanism, Direction coverage scope, Pitfall 1.1 state combos, Kicker variation timing, Verification approach (Godot CLI prerequisite)

---

## Gray Area Selection (multi-select)

| Option | Description | Selected |
|--------|-------------|----------|
| Variation authoring mechanism | How the 14 type variations get per-direction personality (formula vs sub_resources vs hybrid) — sets the architectural pattern for Phases 5/6/7. | ✓ |
| Direction coverage scope this phase | All 5 directions vs Pulse-only vs Pulse + Slate (premium benchmark) — affects deliverable size. | ✓ |
| Pitfall 1.1 state-combo strategy | Explicit pressed_focus / checked_focus slots vs focus-as-overlay layering — surfaces in the planner gray area below. | (asked separately as follow-up) |
| Kicker variation timing | Add 15th variation now (DESIGN_TOKENS §8.6's explicit Phase 5 todo) vs defer. | (asked separately as follow-up) |

**User's choice:** Variation authoring mechanism + Direction coverage scope (multi-select; Pitfall 1.1 + Kicker raised as a separate follow-up ask after the primary two were nailed down).

---

## Verification Approach (asked alongside selection)

| Option | Description | Selected |
|--------|-------------|----------|
| Same Cycle 6 F7 hand-author fallback | Continue Phase 4's pattern — hand-author .tres byte-aligned with ResourceSaver output; dual EditorScript + headless verifier; user-machine human-UAT gate. No Godot CLI dependency, but brittle for sub_resource blocks. | |
| Require Godot 4.6 CLI prerequisite | Phase 5 Plan 01 = install + verify `godot --headless --import` on Windows. All subsequent .tres authoring uses ResourceSaver round-trip. Byte-correct binary form; matches actual artist workflow. ~5 minute one-time setup cost. | ✓ |
| User runs Godot 4.6 manually at end of phase | Executor authors programmatically; user runs `_phase5_*.gd` helpers via Godot Tools menu and commits .tres. Artist-aligned but slows iteration. | |

**User's choice:** Require Godot 4.6 CLI prerequisite (Recommended).
**Notes:** Codified as D-11. Phase 5 Plan 01 deliverable is `Godot_v4.6.x-stable_win64.exe` installed + `--headless --import` verified clean + `--headless` script asserting `Theme.has_stylebox("normal", "PrimaryButton")` succeeds. Path documented in `.planning/phases/05-.../helpers/godot-cli-path.txt`.

---

## Variation Authoring Mechanism

| Option | Description | Selected |
|--------|-------------|----------|
| Formula-driven via BINDING_TABLE extension | Variations become first-class entries in BINDING_TABLE with recipes that reference `shape.<key>` lookups against DIRECTION_PRESETS.shape sub-block. .tres files stay tiny (~440 bytes); seamless @exports model preserved end-to-end. | ✓ |
| Embedded sub_resources per .tres | Each direction .tres grows with [sub_resource] StyleBoxFlat blocks for variation×state. _regenerate_theme() leaves variation entries UNTOUCHED via D-04 escape hatch. .tres files balloon to ~30-50 KB; per-direction overrides clearly visible; @exports mutation does NOT update variation chrome (intentional). | |
| Hybrid — formula for color/state, .tres for shape/personality | Color/state-layer/font-color stay formula-driven; shape (radius, padding, surface_alpha, raised_lifts) goes per-.tres sub_resources. More complex than either pure approach; hard to draw the line consistently. | |

**User's choice:** Formula-driven via BINDING_TABLE extension (Recommended).
**Notes:** Codified as D-01..D-04 in CONTEXT.md. The seamless @exports ↔ Theme Editor model from Phase 4 D-02 extends to the variation layer without exception. Strategies (primary_strategy, ghost_strategy, kicker_style) are first-class enums sourced from DESIGN_TOKENS §5.1-§5.5; planner adds a `_apply_strategy()` dispatch helper. Adding a 6th approved direction in v2 = adding a strategy entry, not editing 14 recipe rows.

---

## Direction Coverage Scope

| Option | Description | Selected |
|--------|-------------|----------|
| All 5 directions in Phase 5 | Ship variation personality for Pulse + Slate + Bubble + Daybreak + Burst simultaneously. Maintains Phase 4 cadence. Formula-driven mechanism makes per-direction cost ≈ data entry into DIRECTION_PRESETS.shape. | ✓ |
| Pulse only in Phase 5; peers in 5b/6/7 | Match Phase 4's "Pulse first" cadence at the variation layer. Peer directions look "half-themed" until Phase 7 close. | |
| Pulse + Slate (premium benchmark) | Two most-tonally-different directions in Phase 5; Bubble/Daybreak/Burst as polish in Phase 6. Reveals whether the formula schema captures both extremes before committing. | |

**User's choice:** All 5 directions in Phase 5 (Recommended).
**Notes:** Codified as D-05..D-06. No new .tres files required (variation chrome flows from BINDING_TABLE + DIRECTION_PRESETS at load time). Each .tres remains < 2 KB after Phase 5. Matches PROJECT.md "each subclass .tres must be feature-complete to godot-minimal-theme's bar" pledge per direction; demos cleanly in Phase 9 showcase.

---

## Pitfall 1.1 State Combos (follow-up after primary mechanism + scope locked)

| Option | Description | Selected |
|--------|-------------|----------|
| Defer to planner — Claude picks based on Godot 4.6 draw-order behavior | Researcher empirically validates whether focus stylebox draws OVER pressed/checked or gets replaced. Planner picks (a) overlay-only (no combos) or (b) explicit combo BINDING_TABLE entries based on the empirical finding. | ✓ |
| Add explicit combo slots in BINDING_TABLE | Author Button.pressed_focus, Button.checked_focus, etc. as new BINDING_TABLE entries. Most defensive against Godot edge cases; biggest code surface. | |
| Rely on overlay layering only | Trust focus stylebox (transparent + 2px accent border + 2px expand) to draw over state stylebox. No combo entries. Tightest scope. | |

**User's choice:** Defer to planner — Claude picks based on Godot 4.6 draw-order behavior (Recommended).
**Notes:** Codified as D-07..D-08. Researcher's RESEARCH.md must include a concrete Godot 4.6 draw-order test result before planner picks. Sources: `--headless` script that screenshots a Button in each state combination, OR authoritative citation from Godot source (`scene/gui/base_button.cpp` `_get_default_stylebox()` logic). COV-09 baseline establishes here, completes in Phase 7; Tab-walk QA happens in Phase 10 (QA-03).

---

## Kicker Variation Timing (follow-up after primary mechanism + scope locked)

| Option | Description | Selected |
|--------|-------------|----------|
| Add Kicker as 15th type variation in Phase 5 | Closes DESIGN_TOKENS §8.6's explicit Phase 5 todo. Per-direction kicker style via DIRECTION_PRESETS.shape.kicker_style enum (uppercase-tracked-accent / small-caps-subtle / sentence-case-accent / uppercase-bold-larger). Kicker font_size = tokens.kicker (already in PLATFORM_TOKENS). | ✓ |
| Defer to Phase 8 (mobile + typography polish) | Phase 5 ships 14 variations only. Risk: Phase 9 showcase demos lack kicker; retroactive add is messy. | |
| Defer to v1.x | Kicker is rare in real game UIs; ship without it. Drop §8.6's todo from v1 scope. | |

**User's choice:** Add Kicker as 15th type variation in Phase 5 (Recommended).
**Notes:** Codified as D-09..D-10. TYPE_VARIATIONS gains `"Kicker": "Label"`; explicit `set_font` + `set_font_size` per PITFALLS 1.2; per-direction style via shape.kicker_style enum. Pulse/Bubble = "uppercase-tracked-accent" (font_color = accent + letter_spacing constant if Godot Label supports; else fallback documented as v1.x limitation); Slate = "small-caps-subtle"; Daybreak = "sentence-case-accent"; Burst = "uppercase-bold-larger" (wght=700 + size = tokens.kicker + 1). TYPEVAR-06 documentation finalized in Phase 8 incorporates Kicker.

---

## Claude's Discretion

- Exact recipe-key naming (`"radius"` vs `"corner_radius"` vs `"shape_radius"`) — pick whichever reads cleaner alongside existing keys.
- Strategy dispatch implementation (`_apply_strategy()` as switch / dictionary-of-Callables / inline) — pick simplest that scales to ~10 strategies.
- CodeEdit gutter color granularity — populate the named DESIGN_TOKENS roles (5-6 colors) or full Godot 4.6 set (8-10 colors); pick based on showcase visual completeness.
- SpinBox arrow icon style (triangular vs chevron) — pick whichever reads at small sizes; monochrome 32×32 per Phase 4 D-11 contract.
- Pitfall 1.1 final choice (overlay-only vs explicit combos) — researcher's empirical finding in RESEARCH.md determines this; planner doesn't pre-commit.
- Helper file location (`.planning/phases/05-.../helpers/`) — Phase 4 F3 path discipline holds.

## Deferred Ideas

(See CONTEXT.md `<deferred>` section — same content carried verbatim, plus the discussion-log-only items below.)

- **Strategy enum expansion (6th direction)** — v2; current 5 strategies cover all 5 approved directions.
- **EditorInspectorPlugin for variation authoring UX** — deferred indefinitely (Phase 4 D-05 holds).
- **Binding mechanism revision** — v1.x refinement (Phase 4 D-03 noted REVISABLE; Phase 5 picks up the slot-name + property-name binding table approach unchanged).
- **Light mode (`is_light=true` branch already structurally present from Phase 4)** — v2.
- **Editor-only theme types (FlatButton-as-editor / MainScreenButton / etc.)** — v1.x.
