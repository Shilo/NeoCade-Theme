---
phase: 02-source-dive-ldtk-source-ui-mining
plan: 05
type: execute
wave: 4
depends_on:
  - 02
  - 03
  - 04
files_modified:
  - .planning/research/LDTK-UI-MINING.md
  - .planning/research/SOURCES.md
autonomous: true
requirements:
  - RES-02
  - DOCS-05
must_haves:
  truths:
    - "LDTK-UI-MINING.md final verification log proves roadmap thresholds: at least 8-12 adopted patterns and 3-5 rejected patterns, with counts from the live document"
    - "Every adopted pattern has file:line evidence and anti-cyberpunk audit language"
    - "Every translation note uses the mandatory inspiration-sketch prefix"
    - "Standalone Anti-Cyberpunk Filter Audit section is populated by compiling per-pattern anti-cyberpunk notes, or it explicitly records that no adopted pattern failed the filter"
    - "Open Questions section is populated with unresolved Phase 3+ design questions, or explicitly closed with `None`"
    - "D-11: SOURCES.md updates are mandatory Phase 2 output; Section 2 and Section 3 must be updated in place, and Section 8 must receive a narrow LDtk-claim verification note where applicable"
    - "D-13: Any translation sketches summarized into SOURCES.md stay explicitly inspiration-grade and do not become binding design-token or implementation specifications"
    - "SOURCES.md Section 2 (LDtk UI docs) and Section 3 (LDtk source) are updated in place with Phase 2 findings and cross-links to LDTK-UI-MINING.md"
    - "SOURCES.md Section 3 confidence is raised from LOW to HIGH only if all four prior open items are closed; otherwise confidence and open items are honest"
    - "SOURCES.md Section 8 is updated only for LDtk-related prior-report claims verified during this phase"
    - "No .tres styling commits or addon changes are made"
  artifacts:
    - .planning/research/LDTK-UI-MINING.md (finalized)
    - .planning/research/SOURCES.md (updated)
  key_links:
    - "ROADMAP.md Phase 2 success criteria"
    - "REQUIREMENTS.md RES-02 and DOCS-05"
---

<objective>
Finalize the Phase 2 research artifact, run threshold/quality verification, and update `SOURCES.md` so the LDtk source-dive findings become part of the project source dossier.
</objective>

<context>
@.planning/PROJECT.md
@.planning/ROADMAP.md
@.planning/REQUIREMENTS.md
@.planning/phases/02-source-dive-ldtk-source-ui-mining/02-CONTEXT.md
@.planning/research/LDTK-UI-MINING.md
@.planning/research/SOURCES.md
</context>

<tasks>

<task type="auto">
  <name>Task 1: Final verification pass over LDTK-UI-MINING.md</name>
  <read_first>
    - .planning/research/LDTK-UI-MINING.md
  </read_first>
  <files>.planning/research/LDTK-UI-MINING.md</files>
  <action>
    Append to `## Phase 2 Verification Log`:
    - Adopted pattern count
    - Rejected pattern count
    - CHANGELOG lesson count
    - Asset inventory counts
    - Prior-report claim verdict count
    - File-by-file index coverage count
    - Confirmation that every adopted pattern has line citation and anti-cyberpunk text
    - Confirmation that every translation note uses `Inspiration sketch - Phase 3 mockup or Phase 5+ designer's call.`
    - Confirmation that no `.tres`/addon files were touched

    If any ROADMAP threshold is under minimum, write `BLOCKED` to the verification log, create the SUMMARY.md with the blocking reason, and skip Tasks 2-5. Do not update SOURCES.md with incomplete confidence claims.
  </action>
  <verify>
    Verification log includes counts and shows adopted patterns >= 8, rejected patterns >= 3, and no addon-touch confirmation.
  </verify>
  <done>
    If thresholds pass, `LDTK-UI-MINING.md` verification log is finalized. If thresholds fail, the plan stops with a BLOCKED note and no SOURCES.md edits.
  </done>
</task>

<task type="auto">
  <name>Task 2: Compile standalone Anti-Cyberpunk Filter Audit and Open Questions sections</name>
  <read_first>
    - .planning/research/LDTK-UI-MINING.md
  </read_first>
  <files>.planning/research/LDTK-UI-MINING.md</files>
  <action>
    Populate `## Anti-Cyberpunk Filter Audit` by compiling a table from every adopted pattern:
    - Pattern name
    - Source section
    - Filter result: pass / rejected
    - Reason it does not pull NeoCade toward synthwave, neon-noir, dystopian, scanline, glitch, fake-circuit, or cyberpunk visual language

    Then populate `## Open Questions`:
    - Scan the artifact for `open`, `Phase 3`, `designer's call`, `defer`, `unknown`, and translation notes.
    - Lift unresolved design questions into bullets with downstream owner (Phase 3, Phase 4, Phase 5+, or v1.x).
    - If no unresolved questions remain, write exactly: `None - all LDtk patterns were either resolved, rejected, or marked as non-binding inspiration.`
  </action>
  <verify>
    `LDTK-UI-MINING.md` contains non-empty content under `## Anti-Cyberpunk Filter Audit` and `## Open Questions`.
  </verify>
  <done>
    Standalone audit and open-question sections are populated or explicitly closed.
  </done>
</task>

<task type="auto">
  <name>Task 3: Update SOURCES.md Section 2 and Section 3 with LDtk findings</name>
  <read_first>
    - .planning/research/SOURCES.md Sections 2 and 3
    - .planning/research/LDTK-UI-MINING.md final verification log
  </read_first>
  <files>.planning/research/SOURCES.md</files>
  <action>
    Edit `.planning/research/SOURCES.md` in place:
    - Section 2 (LDtk UI docs): add a Phase 2 source-dive note that source mining resolved or refined web-doc open questions; link to `LDTK-UI-MINING.md`.
    - Section 3 (LDtk source): add what was read in Phase 2, what was adopted, what was rejected, what remains open, and confidence.
    - Close the four current Section 3 open items only if the artifact actually covers them:
      - UI patterns end-to-end
      - atlas conventions
      - CHANGELOG end-to-end
      - prior-report claim verification
    - Raise confidence to HIGH only if all four are closed.
    - If any of the four remain open, treat that as a phase-blocking issue: add a BLOCKED note to `02-05-SUMMARY.md`, do not claim Phase 2 complete, and set Section 3 confidence no higher than MEDIUM-HIGH with the remaining open item named.

    Preserve existing SOURCES.md structure and avoid editing unrelated sections.
  </action>
  <verify>
    Section 3 contains `LDTK-UI-MINING.md`, Phase 2 date, adopted/rejected summaries, and an updated confidence line.
  </verify>
  <done>
    SOURCES.md Sections 2 and 3 updated, or the phase is blocked with the unclosed item named.
  </done>
</task>

<task type="auto">
  <name>Task 4: Update SOURCES.md Section 8 for LDtk-related prior-report claim results</name>
  <read_first>
    - .planning/research/SOURCES.md Section 8
    - LDTK-UI-MINING.md prior-report claim verification table
  </read_first>
  <files>.planning/research/SOURCES.md</files>
  <action>
    Add a `### Phase 2 LDtk Claim Verification` subsection under Section 8 for LDtk-specific claims only. Include:
    - Material Design SVG icons verdict
    - Endesga32 verdict
    - Any additional LDtk claim verdicts
    - Link to `LDTK-UI-MINING.md`

    Do not reopen unrelated report critique already handled elsewhere.
  </action>
  <verify>
    Section 8 contains LDtk claim verification language and links to `LDTK-UI-MINING.md`.
  </verify>
  <done>
    Section 8 updated narrowly.
  </done>
</task>

<task type="auto">
  <name>Task 5: Run final no-theme-touch and documentation verification</name>
  <read_first>
    - git status
    - .planning/research/LDTK-UI-MINING.md
    - .planning/research/SOURCES.md
  </read_first>
  <files>(no files written unless verification notes need correction)</files>
  <action>
    Verify:
    ```powershell
    git status --short
    Select-String -Path .planning\research\LDTK-UI-MINING.md -Pattern 'Inspiration sketch - Phase 3 mockup or Phase 5\+ designer''s call\.'
    Select-String -Path .planning\research\SOURCES.md -Pattern 'LDTK-UI-MINING.md'
    ```
    Confirm `git status --short` has no modified files under `addons/neocade_theme/` or any `.tres` path.
  </action>
  <verify>
    Documentation files are modified, and no theme/addon styling files are modified.
  </verify>
  <done>
    Final verification complete.
  </done>
</task>

</tasks>

<verification>
- [ ] `LDTK-UI-MINING.md` verification log proves roadmap thresholds
- [ ] SOURCES.md Sections 2, 3, and 8 are updated narrowly
- [ ] RES-02 and DOCS-05 are covered
- [ ] No `.tres` or addon files changed
</verification>

<success_criteria>
- Phase 2 findings are committed as research artifacts
- SOURCES.md reflects Phase 2 evidence
- The phase remains research-only
</success_criteria>

<output>
After completion, create `.planning/phases/02-source-dive-ldtk-source-ui-mining/02-05-SUMMARY.md` with final counts, SOURCES.md sections changed, confidence level selected, and no-theme-touch verification.
</output>
