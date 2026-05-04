---
phase: 03-visual-direction-mockup-approval-gate
plan: 05
type: checkpoint
wave: 4
depends_on:
  - 04
files_modified:
  - .planning/DESIGN_TOKENS.md
  - .planning/mockups/03-APPROVAL-LOG.md
  - .planning/mockups/03-ESCALATION.md
  - .planning/phases/03-visual-direction-mockup-approval-gate/03-05-SUMMARY.md
autonomous: false
requirements:
  - DESIGN-05
  - DESIGN-06
  - DOCS-01
  - TOKEN-01
  - TOKEN-02
  - TOKEN-03
  - TOKEN-04
  - TOKEN-05
  - TOKEN-06
  - TOKEN-07
  - TOKEN-08
  - TOKEN-09
  - TOKEN-10
must_haves:
  truths:
    - "D-24: The user approves the visual direction first; only then does `DESIGN_TOKENS.md` capture exact values and become the implementation contract"
    - "User explicitly approves one final visual direction in writing, or requests targeted revisions; approval is not inferred"
    - "Final approval includes Inter Variable upright/Roman confirmation: multiple upright `wght` values, no italic file, synthetic italic labelled, system fallback labelled, consumer mono override labelled"
    - "If revisions are requested, up to three targeted revision rounds are logged, each tied to written user feedback and updated mockup paths"
    - "If the user rejects the finalist direction level rather than requesting targeted mockup edits, workflow routes back to Plan 02 with written feedback without consuming a Plan 05 mockup-revision round"
    - "If still not approved after three targeted mockup revision rounds, `03-ESCALATION.md` is written with unresolved disagreement, evidence, options, and recommended tie-break action; no final tokens are written until the user gives a binding approval or override"
    - "`DESIGN_TOKENS.md` is written only after approval and includes desktop and mobile token blocks"
    - "`DESIGN_TOKENS.md` contains exact hex colors, WCAG AA contrast table, M3 state-layer opacities, Inter-only type scale, spacing, radius, stroke, elevation/no-shadow, and mobile deltas"
    - "`DESIGN_TOKENS.md` records `surface.sunken` rejected for v1, no drop shadows, `shadow_size = -1` policy, and synthetic italic / fallback / mono override rules"
    - "Approval log records the final mockup file paths, selected direction, user approval text, and token finalization date"
    - "Hard blocker is closed only if no `.tres` styling commits/files were touched during Phase 3"
    - "No files under `addons/neocade_theme/` and no `.tres` files are modified in this plan"
  artifacts:
    - .planning/DESIGN_TOKENS.md
    - .planning/mockups/03-APPROVAL-LOG.md
    - .planning/mockups/03-ESCALATION.md
  key_links:
    - "PROJECT.md mockup approval gate"
    - "REQUIREMENTS.md DESIGN-05, DESIGN-06, DOCS-01, TOKEN-01..10"
    - ".planning/mockups/03-finalist-comparison.html"
    - ".planning/mockups/03-finalist-contrast.md"
---

<objective>
Run the final approval gate. If the user approves, write the binding `DESIGN_TOKENS.md` contract and close the Phase 3 hard blocker without touching theme implementation files.
</objective>

<context>
@.planning/PROJECT.md
@.planning/REQUIREMENTS.md
@.planning/ROADMAP.md
@.planning/STATE.md
@.planning/phases/03-visual-direction-mockup-approval-gate/03-CONTEXT.md
@.planning/phases/03-visual-direction-mockup-approval-gate/03-04-SUMMARY.md
@.planning/mockups/03-finalist-comparison.md
@.planning/mockups/03-finalist-contrast.md
@.planning/mockups/03-finalist-render-check.md
@.planning/research/ARCHITECTURE.md
@.planning/research/CROSS-PLATFORM.md
@.planning/research/FEATURES.md
@.planning/research/PITFALLS.md
</context>

<tasks>

<task type="checkpoint:human-verify">
  <name>Task 1: Final mockup approval checkpoint</name>
  <read_first>
    - .planning/phases/03-visual-direction-mockup-approval-gate/03-04-SUMMARY.md
    - .planning/mockups/03-finalist-comparison.html
    - .planning/mockups/finalists/
  </read_first>
  <files>(no files written until user answers)</files>
  <action>
    Present the finalist mockups and ask the user to:
    - approve one final visual direction, or
    - request specific targeted mockup revisions, or
    - reject the finalist set and route back to direction-board work.

    Also restate the typography baseline and ask for confirmation as part of final approval:
    - Inter Variable upright/Roman only.
    - Multiple upright `wght` values are available; no true italic file ships in v1.
    - Synthetic italic is labelled as synthetic v1 behavior.
    - Non-Latin text uses functional system fallback unless consumers add script-specific fonts.
    - Mono/code is a consumer override sample, not a bundled second font.

    Do not proceed to token finalization until the user explicitly approves one direction in writing.
  </action>
  <how_to_verify>
    User writes approval, revision instructions, or direction-level reset instructions, with typography confirmation or override request.
  </how_to_verify>
  <done>
    Approval or revision request is available.
  </done>
</task>

<task type="auto">
  <name>Task 2: Handle targeted revisions, max three rounds</name>
  <read_first>
    - User approval/revision response
    - .planning/mockups/03-finalist-comparison.html
    - .planning/mockups/finalists/
  </read_first>
  <files>
    - .planning/mockups/finalists/
    - .planning/mockups/03-APPROVAL-LOG.md
    - .planning/mockups/03-ESCALATION.md
  </files>
  <action>
    If user approved, record approval and skip to Task 3.

    If user requested a different direction-level concept or rejected the finalist set:
    - Record the reset request in `03-APPROVAL-LOG.md`.
    - Write the feedback needed for Plan 02 direction-board revision.
    - Route back to Plan 02. Do not increment the Plan 05 targeted mockup revision counter and do not write `DESIGN_TOKENS.md`.

    If user requested targeted mockup revisions:
    - Record revision round number, feedback, files changed, and verification in `03-APPROVAL-LOG.md`.
    - Apply targeted changes only to finalist mockup artifacts.
    - Re-run contrast/render checks for affected mockups.
    - Return to Task 1 for user approval.

    If targeted mockup revision round would exceed three total rounds:
    - Write `03-ESCALATION.md`.
    - Include unresolved disagreement, each revision round, evidence from mockups/contrast checks, the user's stated concern, and recommended tie-break options: approve with noted risks, split/merge direction traits, route back to Plan 02 for a new finalist set, or pause Phase 3.
    - Present `03-ESCALATION.md` to the user for a binding override decision.
    - Do not write `DESIGN_TOKENS.md` until the user gives explicit approval or override in writing.
  </action>
  <verify>
    If approved, `03-APPROVAL-LOG.md` contains `APPROVED` and typography confirmation. If revised, it contains `Revision round`. If escalated, `03-ESCALATION.md` exists and `DESIGN_TOKENS.md` does not.
  </verify>
  <done>
    Either final approval is logged, or workflow is escalated before tokens are written.
  </done>
</task>

<task type="auto">
  <name>Task 3: Write DESIGN_TOKENS.md from approved finalist</name>
  <read_first>
    - .planning/mockups/03-APPROVAL-LOG.md
    - .planning/mockups/03-finalist-contrast.md
    - .planning/mockups/03-finalist-comparison.md
    - .planning/research/ARCHITECTURE.md
    - .planning/research/CROSS-PLATFORM.md
    - .planning/research/PITFALLS.md
  </read_first>
  <files>.planning/DESIGN_TOKENS.md</files>
  <action>
    Write the final token contract.

    Required sections:
    - Approval summary with approved direction, date, user approval quote, typography confirmation, and mockup paths.
    - Color tokens: five surface stops with friendly aliases; outline; text strong/default/muted; eight accents; semantic roles.
    - Contrast table: text-on-surface, accent-label, focus-ring, non-text state pairs.
    - Typography: Inter Variable upright/Roman only; single upright `.ttf`, no italic file, M3-derived type scale; `opsz`/`wght` guidance; synthetic italic; non-Latin system fallback; consumer-supplied mono override.
    - Spacing: desktop eight-step scale and mobile +50% rules for `space.4` and above.
    - Radius: none/sm/md/lg with exact px values; mobile radii unchanged.
    - Stroke: hairline/focus/danger widths with integer px.
    - Elevation: color-only tonal ramp; no shadows; `shadow_size = -1` policy for every StyleBoxFlat.
    - State layers: hover 8%, focus 12% + 2px ring, pressed 12%, dragged 16%, disabled 38% text / 12% container.
    - Desktop/mobile deltas.
    - Phase 4 implementation notes for the `@tool` generator.

    Do not include speculative alternate palettes except as short non-binding rejected/future notes.
  </action>
  <verify>
    ```powershell
    Test-Path .planning\DESIGN_TOKENS.md
    Select-String -Path .planning\DESIGN_TOKENS.md -Pattern 'APPROVED'
    Select-String -Path .planning\DESIGN_TOKENS.md -Pattern 'Inter Variable'
    Select-String -Path .planning\DESIGN_TOKENS.md -Pattern 'shadow_size = -1'
    Select-String -Path .planning\DESIGN_TOKENS.md -Pattern '48px'
    Select-String -Path .planning\DESIGN_TOKENS.md -Pattern 'WCAG'
    ```
  </verify>
  <done>
    `DESIGN_TOKENS.md` is binding and ready for Phase 4.
  </done>
</task>

<task type="auto">
  <name>Task 4: Hard blocker and no-theme-touch verification</name>
  <read_first>
    - .planning/DESIGN_TOKENS.md
    - .planning/mockups/03-APPROVAL-LOG.md
    - git status
    - git log --name-only --oneline -- . ':(exclude).planning/**'
  </read_first>
  <files>.planning/phases/03-visual-direction-mockup-approval-gate/03-05-SUMMARY.md</files>
  <action>
    Verify and document:
    - Final approval exists.
    - `DESIGN_TOKENS.md` exists.
    - No `.tres` files or addon styling files changed during Phase 3.
    - Phase 4 is now unblocked only if all above are true.

    Create `03-05-SUMMARY.md` with final artifacts and gate status.
  </action>
  <verify>
    ```powershell
    $status = git status --short
    if ($status -match 'addons/neocade_theme|\.tres') { throw "Theme/addon file changed during Phase 3 plan 05" }
    Test-Path .planning\phases\03-visual-direction-mockup-approval-gate\03-05-SUMMARY.md
    Select-String -Path .planning\phases\03-visual-direction-mockup-approval-gate\03-05-SUMMARY.md -Pattern 'unblocked'
    ```
  </verify>
  <done>
    Phase 3 deliverables are complete and Phase 4 gate status is explicit.
  </done>
</task>

</tasks>

<verification>
- [ ] User approval logged
- [ ] Revision loop respected max three rounds
- [ ] Direction-level reset routes back to Plan 02 without consuming mockup revision budget
- [ ] Escalation artifact exists instead of tokens if three targeted revision rounds fail
- [ ] `DESIGN_TOKENS.md` written only after approval
- [ ] Tokens include desktop and mobile values with WCAG math
- [ ] Hard blocker verification confirms no `.tres` or addon styling changes
</verification>

<success_criteria>
- Phase 3 closes with a user-approved visual direction and binding design-token contract
- Phase 4 can safely begin implementation from `DESIGN_TOKENS.md`
</success_criteria>

<output>
After completion, create `.planning/phases/03-visual-direction-mockup-approval-gate/03-05-SUMMARY.md`.
</output>
