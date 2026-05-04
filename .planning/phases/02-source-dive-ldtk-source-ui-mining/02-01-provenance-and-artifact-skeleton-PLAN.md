---
phase: 02-source-dive-ldtk-source-ui-mining
plan: 01
type: execute
wave: 0
depends_on: []
files_modified:
  - .planning/research/LDTK-UI-MINING.md
autonomous: true
requirements:
  - RES-02
must_haves:
  truths:
    - "LDTK-UI-MINING.md exists at .planning/research/ with provenance, scope, method, file-inventory, and reserved section headings for later Phase 2 plans"
    - "Provenance records source root, snapshot date, LDtk version from docs/version.txt when available, no-git-metadata status, and live line/file counts"
    - "File inventory includes src/electron.renderer/**/*.hx, src/electron.renderer/ui/**/*.hx, page/Editor.hx, tool/, app.scss, docs/CHANGELOG.md, app/assets/icons/*.svg, res/atlas, and res/fonts"
    - "Method section states LDtk is loose inspiration only and every translation note must use the mandatory inspiration-sketch prefix"
    - "PowerShell-native fallbacks are documented for every rg inventory command so execution is not blocked if ripgrep is unavailable"
    - "Git metadata check is guarded by a .git existence check so the known no-.git snapshot is recorded cleanly"
    - "No addon, theme, .tres, font, or icon asset files are modified"
  artifacts:
    - .planning/research/LDTK-UI-MINING.md
  key_links:
    - "Phase 2 CONTEXT.md D-01, D-09, D-10, D-14, D-15"
    - ".planning/research/SOURCES.md Sections 2, 3, and 8"
---

<objective>
Create the durable Phase 2 research artifact skeleton, `.planning/research/LDTK-UI-MINING.md`, and pin live provenance for the LDtk source snapshot before any pattern extraction begins.

This plan does not extract all patterns yet. It establishes the shared document structure, source inventory, citation rules, and anti-copying posture that later Phase 2 plans append to.
</objective>

<context>
@.planning/PROJECT.md
@.planning/ROADMAP.md
@.planning/STATE.md
@.planning/REQUIREMENTS.md
@.planning/phases/02-source-dive-ldtk-source-ui-mining/02-CONTEXT.md
@.planning/phases/02-source-dive-ldtk-source-ui-mining/02-RESEARCH.md
@.planning/research/SOURCES.md

<interfaces>
Mining root: `C:\Programming_Files\ldtk-master\`

Primary targets:
- `C:\Programming_Files\ldtk-master\src\electron.renderer\`
- `C:\Programming_Files\ldtk-master\src\electron.renderer\page\Editor.hx`
- `C:\Programming_Files\ldtk-master\src\electron.renderer\tool\`
- `C:\Programming_Files\ldtk-master\app\assets\css\app.scss`
- `C:\Programming_Files\ldtk-master\app\assets\icons\`
- `C:\Programming_Files\ldtk-master\res\atlas\`
- `C:\Programming_Files\ldtk-master\res\fonts\`
- `C:\Programming_Files\ldtk-master\docs\CHANGELOG.md`
- `C:\Programming_Files\ldtk-master\docs\version.txt`
</interfaces>
</context>

<tasks>

<task type="auto">
  <name>Task 1: Record live LDtk source provenance</name>
  <read_first>
    - C:\Programming_Files\ldtk-master\docs\version.txt
    - C:\Programming_Files\ldtk-master\app\package.json
    - C:\Programming_Files\ldtk-master\LICENSE
  </read_first>
  <files>(no files written)</files>
  <action>
    Run live inventory commands and keep their outputs for Task 2. Prefer `rg` where available; if `rg` is missing, use the PowerShell fallback beside each command.
    ```powershell
    Test-Path 'C:\Programming_Files\ldtk-master'
    Get-Content -Raw 'C:\Programming_Files\ldtk-master\docs\version.txt' -ErrorAction SilentlyContinue
    if (Test-Path 'C:\Programming_Files\ldtk-master\.git') { git -C 'C:\Programming_Files\ldtk-master' rev-parse --short HEAD } else { 'No .git directory in snapshot' }
    rg --files 'C:\Programming_Files\ldtk-master\src\electron.renderer' -g '*.hx' | Measure-Object
    Get-ChildItem 'C:\Programming_Files\ldtk-master\src\electron.renderer' -Recurse -Filter *.hx | Measure-Object
    rg --files 'C:\Programming_Files\ldtk-master\src\electron.renderer\ui' -g '*.hx' | Measure-Object
    Get-ChildItem 'C:\Programming_Files\ldtk-master\src\electron.renderer\ui' -Recurse -Filter *.hx | Measure-Object
    (Get-Content 'C:\Programming_Files\ldtk-master\app\assets\css\app.scss' | Measure-Object -Line).Lines
    (Get-Content 'C:\Programming_Files\ldtk-master\docs\CHANGELOG.md' | Measure-Object -Line).Lines
    rg --files 'C:\Programming_Files\ldtk-master\app\assets\icons' -g '*.svg' | Measure-Object
    Get-ChildItem 'C:\Programming_Files\ldtk-master\app\assets\icons' -Filter *.svg | Measure-Object
    ```
    If `rg` and fallback counts disagree, record both and use the PowerShell fallback as the Windows-native verification anchor.
  </action>
  <verify>
    The LDtk root exists, `app.scss` exists, `docs/CHANGELOG.md` exists, and the Haxe/icon counts are nonzero.
  </verify>
  <done>
    Live provenance values are available for Task 2.
  </done>
</task>

<task type="auto">
  <name>Task 2: Create LDTK-UI-MINING.md skeleton with reserved append sections</name>
  <read_first>
    - .planning/research/SOURCES.md (Sections 2, 3, 8 for current source dossier status)
    - .planning/phases/02-source-dive-ldtk-source-ui-mining/02-CONTEXT.md (D-09 and D-10 required structure)
  </read_first>
  <files>.planning/research/LDTK-UI-MINING.md</files>
  <action>
    Create `.planning/research/LDTK-UI-MINING.md` with the D-10 sections plus two execution-friendly additions (`File-by-File UI Index` and `SCSS Chrome and Interaction Conventions`). Add a short note in `## Scope and Method` that the order is optimized for mining flow while preserving every D-10 deliverable.

    Required content:
    - Header: `# LDtk UI Mining`
    - Authored date: `2026-05-04`
    - Provenance table using Task 1 live values
    - Scope and method section
    - Citation contract: every adopted pattern must cite file path and line range
    - Loose-inspiration warning: LDtk is not a design spec or value source
    - Mandatory translation prefix: `Inspiration sketch - Phase 3 mockup or Phase 5+ designer's call.`
    - Reserved headings in this order:
      - `## File-by-File UI Index`
      - `## UI Pattern Catalogue`
      - `## SCSS Chrome and Interaction Conventions`
      - `## Rejected Patterns`
      - `## CHANGELOG Lessons Learned`
      - `## Asset Inventory`
      - `## Prior Research Report Claim Verification`
      - `## Anti-Cyberpunk Filter Audit`
      - `## Open Questions`
      - `## Phase 2 Verification Log`
  </action>
  <verify>
    ```powershell
    Select-String -Path .planning\research\LDTK-UI-MINING.md -Pattern '# LDtk UI Mining'
    Select-String -Path .planning\research\LDTK-UI-MINING.md -SimpleMatch "Inspiration sketch - Phase 3 mockup or Phase 5+ designer's call."
    Select-String -Path .planning\research\LDTK-UI-MINING.md -Pattern '## UI Pattern Catalogue'
    Select-String -Path .planning\research\LDTK-UI-MINING.md -Pattern '## Phase 2 Verification Log'
    ```
  </verify>
  <done>
    Skeleton exists and later Phase 2 plans can append without reorganizing it.
  </done>
</task>

</tasks>

<verification>
- [ ] `LDTK-UI-MINING.md` exists and contains all reserved headings
- [ ] Provenance values are live, not copied from stale context
- [ ] The loose-inspiration and mandatory translation-prefix rules are visible near the top
- [ ] No `addons/neocade_theme/` files changed
</verification>

<success_criteria>
- `LDTK-UI-MINING.md` created with provenance and section skeleton
- Later plans can append under reserved headings
- Phase 2 source-dive remains research-only
</success_criteria>

<output>
After completion, create `.planning/phases/02-source-dive-ldtk-source-ui-mining/02-01-SUMMARY.md` with provenance values recorded, any source files missing, and confirmation that no theme files were touched.
</output>
