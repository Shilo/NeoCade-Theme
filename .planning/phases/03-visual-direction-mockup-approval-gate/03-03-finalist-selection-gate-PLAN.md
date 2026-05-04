---
phase: 03-visual-direction-mockup-approval-gate
plan: 03
type: checkpoint
wave: 2
depends_on:
  - 02
files_modified:
  - .planning/mockups/03-FINALIST-SELECTION.md
  - .planning/phases/03-visual-direction-mockup-approval-gate/03-03-SUMMARY.md
autonomous: false
requirements:
  - DESIGN-01
  - DESIGN-02
  - DESIGN-06
must_haves:
  truths:
    - "User sees the five direction boards and concept image outputs before any finalist mockups are built"
    - "User selects two or three finalists in writing, or explicitly requests a targeted revision to direction boards"
    - "Finalist selection records whether Boardwalk Sunset remains the recommended baseline or whether another direction becomes preferred"
    - "Typography remains Inter-only unless user explicitly reopens the font decision"
    - "Selection artifact names exactly which directions proceed to full-fidelity desktop/mobile mockups and what targeted changes each finalist should carry"
    - "No `DESIGN_TOKENS.md` is written yet; token values are finalized only after full-fidelity approval"
    - "No files under `addons/neocade_theme/` and no `.tres` files are modified"
  artifacts:
    - .planning/mockups/03-FINALIST-SELECTION.md
  key_links:
    - "03-CONTEXT.md D-12, D-15, D-16..D-25"
    - ".planning/mockups/03-direction-boards.html"
    - ".planning/phases/03-visual-direction-mockup-approval-gate/03-02-SUMMARY.md"
---

<objective>
Pause for the first required visual gate: the user reviews the five concept/direction boards and selects two or three finalists for full-fidelity desktop/mobile mockups.
</objective>

<context>
@.planning/PROJECT.md
@.planning/REQUIREMENTS.md
@.planning/phases/03-visual-direction-mockup-approval-gate/03-CONTEXT.md
@.planning/phases/03-visual-direction-mockup-approval-gate/03-02-SUMMARY.md
@.planning/mockups/03-direction-boards.md
@.planning/mockups/03-direction-boards.html
</context>

<tasks>

<task type="checkpoint:human-verify">
  <name>Task 1: Present direction boards for finalist selection</name>
  <read_first>
    - .planning/mockups/03-direction-boards.html
    - .planning/mockups/03-direction-boards.md
    - .planning/phases/03-visual-direction-mockup-approval-gate/03-02-SUMMARY.md
  </read_first>
  <files>(no files written until user answers)</files>
  <action>
    Show the user the direction board artifact paths and summarize:
    - The five named directions.
    - Which direction is recommended and why.
    - The strongest two or three finalist candidates.
    - Any risks or revisions to consider.

    Ask the user to choose exactly two or three finalists, or to request specific direction-board revisions.
  </action>
  <how_to_verify>
    User responds in writing with:
    - selected finalists, or
    - targeted revision instructions.
  </how_to_verify>
  <done>
    User selection is available before writing `03-FINALIST-SELECTION.md`.
  </done>
</task>

<task type="auto">
  <name>Task 2: Record finalist selection</name>
  <read_first>
    - User's written finalist-selection response
    - .planning/mockups/03-direction-boards.md
  </read_first>
  <files>.planning/mockups/03-FINALIST-SELECTION.md</files>
  <action>
    Create `03-FINALIST-SELECTION.md` with:
    - Date and phase.
    - Exact user selection.
    - Direction names and slugs proceeding to finalist mockups.
    - Required targeted adjustments per finalist.
    - Explicit statement that Inter-only remains locked unless the user reopened it.
    - Explicit statement that `DESIGN_TOKENS.md` is still pending final approval.
    - Link to concept/direction-board artifacts.

    If the user requested direction-board revisions instead of selection, record the requested changes and route back to Plan 02 rather than proceeding to Plan 04.
  </action>
  <verify>
    ```powershell
    Test-Path .planning\mockups\03-FINALIST-SELECTION.md
    Select-String -Path .planning\mockups\03-FINALIST-SELECTION.md -Pattern 'Finalists'
    Select-String -Path .planning\mockups\03-FINALIST-SELECTION.md -Pattern 'DESIGN_TOKENS.md.*pending'
    ```
  </verify>
  <done>
    Finalist selection is durable and unblocks Plan 04.
  </done>
</task>

<task type="auto">
  <name>Task 3: Summary and no-theme-touch verification</name>
  <read_first>
    - .planning/mockups/03-FINALIST-SELECTION.md
    - git status
  </read_first>
  <files>.planning/phases/03-visual-direction-mockup-approval-gate/03-03-SUMMARY.md</files>
  <action>
    Write summary with:
    - Selected finalist directions.
    - Adjustments to carry into full-fidelity mockups.
    - Confirmation that token finalization is still blocked.
    - No-theme-touch verification.
  </action>
  <verify>
    ```powershell
    Test-Path .planning\phases\03-visual-direction-mockup-approval-gate\03-03-SUMMARY.md
    $status = git status --short
    if ($status -match 'addons/neocade_theme|\.tres') { throw "Theme/addon file changed during Phase 3 plan 03" }
    ```
  </verify>
  <done>
    Plan 04 has a written input contract.
  </done>
</task>

</tasks>

<verification>
- [ ] User selected two or three finalists or requested revisions
- [ ] Finalist selection logged in `.planning/mockups/03-FINALIST-SELECTION.md`
- [ ] No `DESIGN_TOKENS.md` yet
- [ ] No `.tres` or addon styling files changed
</verification>

<success_criteria>
- Full-fidelity mockups can be built from an explicit user finalist selection
- Phase 3 approval sequence remains user-driven
</success_criteria>

<output>
After completion, create `.planning/phases/03-visual-direction-mockup-approval-gate/03-03-SUMMARY.md`.
</output>
