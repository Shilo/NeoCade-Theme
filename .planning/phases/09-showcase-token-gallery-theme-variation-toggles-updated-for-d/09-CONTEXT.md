# Phase 9: Showcase + Token Gallery + Theme/Variation Toggles - Context

**Gathered:** 2026-05-07
**Status:** Ready for planning
**Mode:** Autonomous (`--auto`; user requested no questions, UAT deferred)

<domain>
## Phase Boundary

Phase 9 builds the live Godot showcase scene for NeoCade. It must prove the
implemented theme in a consumer-visible way: 9 showcase sections, realistic
sample content, runtime direction/raised/platform/default switching, BBCode
font behavior, token gallery, and coverage strip.

This phase does not perform final screenshot matrices, renderer/device export
validation, or manual user acceptance testing. Those are Phase 10 scope and
are deferred per the user's autonomous instruction.
</domain>

<decisions>
## Implementation Decisions

- **D-01:** Use Pulse as the default applied theme because Phase 3.4 selected it as the recommended starter.
- **D-02:** Keep `main.tscn` lightweight and build the showcase programmatically in `scripts/showcase.gd`. This avoids fragile hand-authored scene churn for dozens of Controls.
- **D-03:** Runtime toggles duplicate the selected `.tres` before mutating `raised` or `platform`, so shipped resources are not dirtied by the showcase.
- **D-04:** Include all five approved direction resources plus Godot default comparison. Do not include a root `neocade_theme.tres` or `neocade_mobile_theme.tres`.
- **D-05:** Set `accessibility_name`/tooltip metadata on every interactive sample control that the script creates.
- **D-06:** Add `export_presets.cfg` in Phase 9 so Phase 11 can build the Web showcase and Phase 10 has named cross-target presets to validate.
</decisions>

<code_context>
## Existing Code Insights

- `addons/neocade_theme/neocade_theme.gd` already supports `raised` and `platform` setters, so the showcase can exercise the real dynamic architecture.
- `main.tscn` already points at Pulse; only the support script needed to change.
- Godot 4.6.2 is available through the MCP server and can run the project for smoke validation.
</code_context>

<deferred>
## Deferred Ideas

- Screenshot decks, renderer comparisons, real-device mobile checks, and human UAT are deferred to Phase 10 or v1.0.1 notes.
- Browser-hosted showcase publication is Phase 11 release workflow scope.
</deferred>
