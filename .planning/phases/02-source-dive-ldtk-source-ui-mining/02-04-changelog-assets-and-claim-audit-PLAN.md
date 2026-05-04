---
phase: 02-source-dive-ldtk-source-ui-mining
plan: 04
type: execute
wave: 1
depends_on:
  - 01
files_modified:
  - .planning/research/LDTK-UI-MINING.md
autonomous: true
requirements:
  - RES-02
must_haves:
  truths:
    - "docs/CHANGELOG.md is audited end-to-end for UI-relevant additions, reworks, removals, and fixes"
    - "CHANGELOG lessons are recorded with version/date context when available and categorized by chrome, modal, icon, interaction, focus/accessibility, typography, palette/list, or panel organization"
    - "app/assets/icons/*.svg inventory covers all SVG icons and summarizes silhouette/stroke/fill conventions without copying designs"
    - "res/atlas and res/fonts are catalogued, with bitmap fonts and Aseprite atlases rejected or marked non-adoptable as required"
    - "LDtk-specific claims in the user's prior research report are confirmed, refuted, or marked not-evidenced with citations"
    - "Material Design icon and Endesga32 claims are explicitly handled"
  artifacts:
    - .planning/research/LDTK-UI-MINING.md (appended)
  key_links:
    - "CONTEXT.md D-07, D-08, D-17, D-18"
    - ".planning/inputs/NeoCade-Research-Report.md"
---

<objective>
Audit LDtk's CHANGELOG, shipped SVG/atlas/font assets, and the user's prior LDtk-related research claims, then append the evidence to `LDTK-UI-MINING.md`.
</objective>

<context>
@.planning/phases/02-source-dive-ldtk-source-ui-mining/02-CONTEXT.md
@.planning/research/LDTK-UI-MINING.md
@.planning/inputs/NeoCade-Research-Report.md
@.planning/research/SOURCES.md
@.planning/research/STACK.md
@.planning/research/PITFALLS.md

<interfaces>
Targets:
- `C:\Programming_Files\ldtk-master\docs\CHANGELOG.md`
- `C:\Programming_Files\ldtk-master\app\assets\icons\*.svg`
- `C:\Programming_Files\ldtk-master\res\atlas\`
- `C:\Programming_Files\ldtk-master\res\fonts\`
- `.planning/inputs/NeoCade-Research-Report.md`
</interfaces>
</context>

<tasks>

<task type="auto">
  <name>Task 1: Audit CHANGELOG.md for UI lessons learned</name>
  <read_first>
    - C:\Programming_Files\ldtk-master\docs\CHANGELOG.md
  </read_first>
  <files>.planning/research/LDTK-UI-MINING.md</files>
  <action>
    Read CHANGELOG.md end-to-end. Extract only UI-relevant entries and append them under `## CHANGELOG Lessons Learned`.

    For each lesson include:
    - Version/date if available from surrounding heading
    - Category: chrome, modal, icon, interaction, focus/accessibility, typography, palette/list, panel organization
    - Evidence citation `docs/CHANGELOG.md:N-M`
    - Lesson for NeoCade planning
    - Whether it suggests adopt, reject, or watch

    Pay special attention to reverted or fixed UI changes, since those are the strongest design warnings.
  </action>
  <verify>
    The lessons section includes multiple versioned entries and at least one "fixed", "removed", or "reorganized" lesson.
  </verify>
  <done>
    CHANGELOG lessons appended.
  </done>
</task>

<task type="auto">
  <name>Task 2: Inventory SVG icons, Aseprite atlases, and bitmap fonts</name>
  <read_first>
    - app/assets/icons/*.svg
    - res/atlas/*
    - res/fonts/*
  </read_first>
  <files>.planning/research/LDTK-UI-MINING.md</files>
  <action>
    Append `## Asset Inventory` content:
    - Count and list all SVG icons by filename, dimensions/viewBox if cheaply extractable, and likely role.
    - Summarize visible SVG design conventions: stroke/fill discipline, simple silhouettes, corner/end-cap style, color usage, consistency risks.
    - Record `res/atlas` files and mark them sprite-sheet source, not directly adoptable for NeoCade.
    - Record `res/fonts` files and re-confirm bitmap atlas font rejection under Pitfall 5.4 / HD-only / Inter-only v1 rules.

    Do not copy SVG path data into the doc. Cite filenames and short, human-readable observations only.
  </action>
  <verify>
    Asset inventory mentions the observed SVG icon count, `appElements.aseprite`, `icons.aseprite`, `pixel_berry`, and Noto Sans bitmap atlas files.
  </verify>
  <done>
    Asset inventory appended.
  </done>
</task>

<task type="auto">
  <name>Task 3: Verify prior research report's LDtk-specific claims</name>
  <read_first>
    - .planning/inputs/NeoCade-Research-Report.md
    - .planning/research/SOURCES.md Section 8
    - LDtk source files relevant to claims
  </read_first>
  <files>.planning/research/LDTK-UI-MINING.md</files>
  <action>
    Search the prior research report for LDtk claims, then append `## Prior Research Report Claim Verification` table with:
    - Claim
    - Verdict: confirmed, refuted, not evidenced, or partially true
    - Evidence citation
    - NeoCade impact

    Mandatory claims:
    - LDtk uses Material Design SVG icons
    - LDtk uses Endesga32 for level/content palettes
    - Any claim tying LDtk UI directly to NeoCade visual values
  </action>
  <verify>
    The verification table contains rows for Material Design SVG icons and Endesga32.
  </verify>
  <done>
    Prior-report claim verification appended.
  </done>
</task>

</tasks>

<verification>
- [ ] CHANGELOG lessons section exists with versioned UI entries
- [ ] Asset inventory covers SVG icons, Aseprite atlases, and bitmap fonts
- [ ] Prior report claim audit includes Material Design SVG icons and Endesga32
- [ ] Bitmap/atlas assets are not treated as adoptable theme assets
- [ ] No `.tres` or addon files changed
</verification>

<success_criteria>
- ROADMAP success criteria for CHANGELOG lessons and asset-directory mining are satisfied
- User-supplied report is challenged with evidence, not accepted on trust
</success_criteria>

<output>
After completion, create `.planning/phases/02-source-dive-ldtk-source-ui-mining/02-04-SUMMARY.md` with CHANGELOG lesson count, asset counts, and claim-verification verdicts.
</output>

