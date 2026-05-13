# Theme Color Identity Review - 2026-05-13

## Scope

User approved the `style + source_color` direction and requested one more autonomous review pass before merge:

- Claude: design-only review, no implementation proposals.
- OpenCode/DeepSeek: plan-only review, no implementation proposals.
- Codex: challenge reviewer findings instead of accepting them blindly, then patch relevant docs/mockup.

Reviewed artifacts:

- `.planning/research/THEME-COLOR-IDENTITY-RETHINK.md`
- `.planning/mockups/color-identity/theme-color-identity-approval-gate.html`
- `.planning/mockups/color-identity/README.md`
- `.planning/DESIGN_TOKENS.md`
- `.planning/research/THEME-DIRECTIONS.md`
- `.planning/research/MD3-RESEARCH.md`
- `.planning/research/FLAT-3D-UI-RESEARCH.md`
- `.planning/research/LDTK-UI-MINING.md`
- `.planning/mockups/03-direction-boards.html`
- `addons/neocade_theme/scripts/neocade_theme.gd`

## External Verdicts

### Claude Design Review

Verdict: **READY WITH MINOR FIXES**.

Accepted findings:

- Bubble's dark shell plus cream/sky islands make free-floating `Label` and `RichTextLabel` foregrounds a v1 design requirement, not a future nice-to-have.
- Pulse's default action role visibly migrates from the old lime-accent read to an amber action family, so the approval gate should call that out explicitly.
- The mockup's stress-source guardrail nudge used `sin(sourceHue)`, which loses source-specific movement at red/cyan stress sources.

Deferred or challenged findings:

- The HCT/CAM16 concern is real but not a design blocker. The implementation plan should lock v1 to deterministic Godot-local hue/chroma/tone helpers plus WCAG verification, then revisit HCT only if probes fail.
- Slate's intentionally quiet source response should be verified, but it is part of Slate's identity rather than an automatic flaw.

### OpenCode/DeepSeek Plan Review

Verdict: **READY WITH MINOR FIXES**.

Accepted findings:

- `DESIGN_TOKENS.md` needed stronger supersession wording. A "pending note" was too soft after user approval.
- The implementation plan must explicitly define the alias-to-role-table migration path before touching `BINDING_TABLE`.
- The implementation plan must lock the production color-space choice before code work begins.
- Existing semantic variations (`SuccessLabel`, `WarningPanel`, etc.) need to be reconciled with the new `success_fill` / `warning_fill` / `info_fill` aliases.

Deferred or challenged findings:

- Updating `STATE.md`, `PROJECT.md`, and `ROADMAP.md` is not required for this design/mockup merge. Those docs should update with the implementation plan and code branch so they describe the next actual architecture, not just the approved target.
- Bubble light islands are no longer open after the user's explicit approval; the remaining work is documenting the exception and implementing contrast-safe local foreground roles.
- `tab_selected_fill` may derive from `selection_fill` in v1. It remains a useful alias because tabs may diverge later without renaming bindings.

## Patches Applied

- `DESIGN_TOKENS.md`
  - Replaced the pending rework note with an approved source-color rework note.
  - Rewrote the direction integrity rule so the old palettes remain historical/current-shipped data while the rework document owns the next color generation and preset `source_color` values.

- `THEME-COLOR-IDENTITY-RETHINK.md`
  - Made Bubble free Label foreground handling a v1 requirement for panel/dialog surfaces.
  - Added explicit Pulse action-family migration approval language.
  - Documented the external review verdicts and how findings were accepted, deferred, or rejected.
  - Locked the implementation-plan direction to Godot-local hue/chroma/tone helpers plus WCAG verification first, with HCT/CAM16 deferred unless evidence demands it.

- `theme-color-identity-approval-gate.html`
  - Added decision gate cards for Bubble surface-local labels and Pulse action migration.
  - Replaced the `sin(sourceHue)` guardrail nudge with a source-aware function that does not collapse at red/cyan stress inputs.

## Final Planning Position

The approved design is ready to merge as a planning/mockup baseline. The implementation branch must still produce a separate detailed plan and then implement against verifiers:

- role coverage verifier for default control aliases;
- contrast/on_* verifier for every generated fill state;
- red-family semantic guardrail verifier;
- source-stress matrix across presets, red, gray, white/black, green, blue, and orange;
- BINDING_TABLE alias migration proof;
- compatibility decision for retiring or migrating `base_color` / `accent_color`;
- update of `PROJECT.md`, `REQUIREMENTS.md`, `ROADMAP.md`, `STATE.md`, and `AGENTS.md` once the public export contract actually changes.
