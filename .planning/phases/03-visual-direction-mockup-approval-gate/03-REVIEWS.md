---
phase: 03-visual-direction-mockup-approval-gate
cycle: 1
reviewers:
  - claude
  - opencode
verdict: BLOCK
high_count: 3
medium_count: 11
low_count: 6
created: 2026-05-04
---

# Phase 3 Plan Reviews - Cycle 1

Both requested reviewers blocked the initial plan. The shared blocker was that Plan 02 required image-generated concept designs but did not name or verify the actual image-generation path. OpenCode also escalated the undefined "after three failed approval rounds" behavior to HIGH.

## Consensus High Findings

### H-01: Image generation path is undefined

Reviewers: Claude, OpenCode

Affected plan: `03-02-five-concept-directions-PLAN.md`

Issue: Task 2 says to use the available image-generation workflow/tool, but does not name the tool, smoke-test availability, or define what happens if the executor cannot generate raster concept images.

Required fix: Name the Codex image generation path explicitly, add it to Plan 01 tooling baseline, require prompt/image outputs, and stop for a user-visible blocker if image generation is unavailable instead of silently substituting HTML-only boards.

### H-02: Approval escalation after three revision rounds is undefined

Reviewer: OpenCode

Affected plan: `03-05-approval-tokens-and-gate-close-PLAN.md`

Issue: The plan caps revisions at three rounds but says only to "escalate" if the user still does not approve. That leaves Phase 4 indefinitely blocked without a defined artifact or decision path.

Required fix: Add `03-ESCALATION.md` with unresolved disagreement, evidence, options, and recommended tie-break action. Do not write `DESIGN_TOKENS.md` until the user gives a binding approval or override.

## Medium Findings To Address

- Add explicit Inter-only confirmation text to the Plan 03/05 human checkpoints so typography approval is logged alongside visual approval.
- Enforce Plan 04 desktop/mobile mockup counts against the actual finalist slugs selected in Plan 03.
- Give Plan 05 a route back to Plan 02 if full-fidelity finalists reveal that the user wants a different direction-level concept, without consuming mockup revision rounds.
- Add basic contrast sanity checks to all five Plan 02 direction boards before finalist selection.
- Clarify mood-board image licensing: all-rights-reserved references stay URL-only; committed local reference images require explicit CC/PD license and attribution.
- Require concept images to include UI-adjacent elements and label them as mood/atmosphere references, not final UI previews.
- Resolve ROADMAP vs Plan 04 scope mismatch: Phase 3 finalist mockups are representative, not exhaustive 35-class implementation galleries.
- Require GoPeak fallback to be programmatic/repeatable enough to inform Phase 10 screenshot automation.
- Add a compact comparison matrix before detailed direction boards to reduce selection overload.
- Add HTML-to-Godot rendering fidelity disclaimer and flag low-margin contrast pairs for Web export verification.

## Low Findings To Consider

- Specify `references.json` as `{ "references": [...] }`.
- Probe browser/render-check tooling before Plan 02 render checks.
- Cross-link Phase 3 findings from other relevant `SOURCES.md` sections if prototype/report critique changes.
- Add a friendly-arcade guardrail for any future/spaceship-derived direction.
- Compare finalists back to the user-supplied prototype so improvements in arcade warmth are explicit.
- Clarify "Inter Variable Roman" wording as upright Inter Variable, multiple `wght` values, no italic file.

## Machine Summaries

Claude:

`CYCLE_SUMMARY: high=1; medium=5; low=3; verdict=BLOCK`

OpenCode / DeepSeek V4 Pro:

`CYCLE_SUMMARY: high=2; medium=6; low=3; verdict=BLOCK`

## Cycle 1 Resolution Applied

- Plan 01 now records the Codex `image_gen` / `imagegen` path and requires a user-visible blocker if no image generator is available.
- Plan 02 now names `image_gen`, requires UI-adjacent concept images, forbids silent non-image fallback, adds all-five contrast sanity checks, and opens with a comparison matrix.
- Plan 03 now logs explicit Inter Variable upright/Roman confirmation and writes machine-readable `finalist_slugs`.
- Plan 04 now enforces mockup files against `finalist_slugs`, flags low-margin contrast for Web export, adds HTML-to-Godot rendering disclaimers, and compares finalists back to the prototype.
- Plan 05 now defines direction-level reset routing, explicit typography confirmation, and `03-ESCALATION.md` after three failed targeted mockup revision rounds.
- `ROADMAP.md` Phase 3 success criteria now match the five-direction, concept-first, representative finalist-mockup flow captured during discussion.

## Cycle 2 Reviews

Cycle 2 verdict: PASS. Both reviewers confirmed the high blockers were resolved and found no new HIGH issues.

Claude:

`CYCLE_SUMMARY: high=0; medium=4; low=5; verdict=PASS`

Key notes:
- H-01 image generation path is resolved by Plan 01 tooling baseline plus Plan 02 named `image_gen` workflow and blocker behavior.
- H-02 escalation is resolved by Plan 05 `03-ESCALATION.md`, direction-level reset routing, and no-token-before-approval rule.
- Remaining MEDIUM notes concern extra guardrails: Plan 02 should mechanically read `PHASE-3-TOOLING.md`, Plan 05 could softly cap repeated direction-level resets, hard-blocker verification could inspect Phase 3 commit history, and missing `finalist_slugs` could point back to Plan 03.

OpenCode / DeepSeek V4 Pro:

`CYCLE_SUMMARY: high=0; medium=4; low=3; verdict=PASS`

Key notes:
- H-01 image generation is resolved because `image_gen` / `imagegen` is named, availability is recorded, and non-image fallback is forbidden without user approval.
- H-02 approval escalation is resolved because `03-ESCALATION.md` now captures disagreement, evidence, options, and a binding override path.
- Remaining MEDIUM notes concern optional unblocking alternatives if Codex `image_gen` is absent, browser tooling baseline, Plan 02 precondition wording, and autonomy clarity outside Codex.

Convergence status: no HIGH concerns remain after cycle 2.
