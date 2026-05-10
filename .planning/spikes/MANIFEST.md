# Spike Manifest

## Idea

Diagnose and propose moves to escape the editor-theme reading of NeoCade and reach a unique, expressive game-UI identity within the locked flat-MD3 / no-textures / no-gradients / anti-cyberpunk constraints. Drives the planned post-v1 "Signature Visual Moves" phase. Scope and references live in `visual-identity-distinctiveness/BRIEF.md`.

## Requirements

Decisions confirmed during spiking. Non-negotiable for the Phase 12 build, updated as spikes progress.

- Spike sub-directories live under their umbrella (e.g. `visual-identity-distinctiveness/001-...`) rather than as siblings of the umbrella, since the umbrella also carries `BRIEF.md` and the consolidated `REPORT.md`.
- All spike outputs are `.planning/`-only — no addon code edits, no new BINDING_TABLE entries, no new SVGs in `addons/`. Phase 12 owns implementation.
- Reference imagery in this repo is limited to the 5 NeoCade direction concept PNGs and `inputs/NeoCade-Theme-Prototype.png`. Commercial game-UI references (Royal Match, Brawl Stars, etc.) are URL-only / copyright-restricted and contribute qualitatively, not as measured pixels. Synthesized reference frames (per spike 001's `synth_references.py`) are the measured stand-in for MD3 spec layouts and shipped game-UI conventions.
- Color monoculture is real, measured, and directional. NeoCade's 5 directions average 1.6 hues per showcase frame; Slate and Daybreak read as 1 hue. MD3 spec target = 3, shipped game UIs = 5+. (Source: 001 verdict, 2026-05-10.)
- Raised-depth-formula replacement is HSV value-darken at strength `0.20 + 0.10 * raised_strength`. Hue and saturation preserved by construction. The BRIEF's hue-drift complaint was partly a misread — the actual defect is darkness (~23% drop where HCGames needs ~40%), not hue (≤2° rotation in all shipped configs). C4 helps colored-button affordance only; does NOT fix dark-tonal neutral buttons because face and depth converge into base_color (those are quiet UI and don't need strong depth). (Source: 002a/002b verdicts, 2026-05-10.)
- **Phase 12 scope refined by user (2026-05-10):** the real headline fix is making `accent_color` surface more often in idle-state chrome (C2', new), not introducing new hues via MD3 secondary/tertiary derivation (C2, deferred). Role colors must be PURPOSEFUL — opt-in via type variation only, never auto-bound to widget defaults. Generic semantic names (`AccentPanel`, `InfoPanel`, `WarningPanel`, `DangerPanel`, `SuccessPanel`; `SuccessLabel`, `WarningLabel`, `DangerLabel`, `InfoLabel`), never game-specific (no LobbyPanel, no MatchPanel). North star is MD3 Expressive: purposeful + restrained color usage, not blanket. (Source: user refinement after spike completion, 2026-05-10.)
- **Deferred follow-up spikes (post-Phase 12):**
  - C2 (MD3 secondary/tertiary auto-derivation) revisits only when accent-expansion fix (C2') is validated insufficient on its own. Future opt-in via `use_md3_extended_palette: bool` export, never default.
  - C5 (lift thickness bump) re-evaluates visually after C2'+C6 ship; current lifts may be sufficient once accent presence and direction-uniqueness moves land.
  - Surface tonal range expansion ("HSV value range with more brightness also" — user idea) — separate spike. Lift face brightness across the 5-stop ramp so dark themes like Pulse have more contrast between panel and button. Higher risk than C4 because it touches every surface stop.

## Spikes

| # | Name | Type | Validates | Verdict | Tags |
|---|------|------|-----------|---------|------|
| dynamic-theme | Dynamic-theme architecture (Phase 03.2 gate) | feasibility | Export-driven `@tool extends Theme` regenerates representative subset; subclass super-first contract; .tres roundtrip; AUTO platform detection | ✓ VALIDATED 6/6 | architecture, godot, closed |
| visual-identity-distinctiveness/001 | color-monoculture-diagnostic | standard | Given a Pulse/Slate/Bubble/Daybreak/Burst showcase frame, when unique hues are counted vs MD3 reference, then the gap is expressed numerically | ✓ VALIDATED | identity, color, diagnostic |
| visual-identity-distinctiveness/002a | raised-depth-formula-current | comparison | Given a hot-pink `raised=true` button, when current `_raised_depth_color` renders, then depth strip drifts toward base+black | ⚠ PARTIAL (hue OK; darkness underclaims) | identity, raised, comparison |
| visual-identity-distinctiveness/002b | raised-depth-formula-hsv-darken | comparison | Given the same button, when depth uses HSV value-darken with no base-pull, then depth stays in same hue family | ✓ WINNER | identity, raised, comparison |
| visual-identity-distinctiveness/003 | per-direction-signature-move-catalog | standard | Given the 5 directions, when each is forced to differ on at least one non-color/non-radius axis, then they no longer read as same theme + hex swap | ✓ VALIDATED (6 candidates: 4 ADOPT, 2 OPEN) | identity, direction |
| visual-identity-distinctiveness/004 | signature-moves-html-mockups | standard | Given the top candidates from 001-003, when applied to throwaway HTML mockups, then the user can pick visually before Phase 12 starts | ✓ VALIDATED — mockup-signature-moves.html | identity, mockup |
| visual-identity-distinctiveness/005 | before-after-comparison | deliverable + tooling | Given the refined Phase 12 plan, when the user wants to compare current Godot rendering vs proposed result, then a forward-looking HTML mockup + 10 real BEFORE screenshots + comparison website + re-runnable Godot capture script all live in one bundle | ✓ DELIVERED — mockup-refined-plan.html + comparison.html + capture_screenshots.gd + 10 BEFORE PNGs | identity, mockup, screenshot, tooling |
