# Phase 10: QA + Cross-Platform Export Validation - Context

**Gathered:** 2026-05-07
**Status:** Ready for planning
**Mode:** Autonomous (`--auto`; UAT deferred)

<domain>
## Phase Boundary

Phase 10 proves release readiness where the current environment allows it:
Godot project load smoke, QA documentation, contrast evidence, coverage
evidence, export preset readiness, and explicit deferral of hardware/manual
surfaces that cannot be validated in-session.
</domain>

<decisions>
## Implementation Decisions

- **D-01:** Treat Godot MCP load/run output as the automated local smoke gate.
- **D-02:** Do not block autonomous execution on unavailable screenshot capture,
  export templates, Android/iOS devices, Apple signing, or macOS notarization.
- **D-03:** Record every deferred manual/device QA item in a matrix with release
  impact rather than hiding it.
- **D-04:** Keep GL Compatibility as the ship renderer.
- **D-05:** Add maintainer documentation for the Theme inspector workaround.
</decisions>

<deferred>
## Deferred Ideas

Screenshot decks, tab-walk screenshots, real-device mobile validation, and
clean-project screenshot proof are deferred UAT/manual QA.
</deferred>
