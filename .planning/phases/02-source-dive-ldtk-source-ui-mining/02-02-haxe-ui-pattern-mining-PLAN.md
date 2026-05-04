---
phase: 02-source-dive-ldtk-source-ui-mining
plan: 02
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
    - "Every .hx file under src/electron.renderer/ui/, ui/modal/, ui/palette/, and ui/vp/ receives at least a one-line entry in the File-by-File UI Index"
    - "page/Editor.hx and src/electron.renderer/tool/ are mined for chrome wiring and tool-button conventions"
    - "At least 12 Haxe-derived adoptable UI patterns are documented with file:line citations, behavior notes, anti-cyberpunk audit notes, and non-binding NeoCade inspiration sketches where obvious"
    - "At least 5 Haxe-derived rejected patterns are documented with file:line citations and Godot Theme portability reasoning"
    - "D-04: ROADMAP minimum thresholds are treated as blocking floors, not targets; Haxe mining should materially exceed 8-12 adopted patterns and 3-5 rejections where evidence supports it"
    - "D-06: Comprehensive source coverage does not promote LDtk to spec depth; the executor reads everything, adopts selectively, and writes evidence so later phases can re-check it"
    - "Every translation note uses the exact prefix `Inspiration sketch - Phase 3 mockup or Phase 5+ designer's call.`"
    - "D-13: Translation sketches remain inspiration-grade and are never substitutes for DESIGN_TOKENS.md, MOBILE-DESIGN-SPEC.md, or later implementation plans"
    - "No .tres styling or addon files are modified"
  artifacts:
    - .planning/research/LDTK-UI-MINING.md (appended)
  key_links:
    - "CONTEXT.md D-01, D-02, D-05, D-12, D-15, D-16"
---

<objective>
Mine LDtk's renderer Haxe UI implementation for concrete polished-application UI patterns: panel chrome, modal flow, context menus, command palette, tool palettes, status/notification surfaces, layer/entity/editor panel conventions, and tool-button behavior.

Output is appended to `LDTK-UI-MINING.md`, not implemented in NeoCade.
</objective>

<context>
@.planning/phases/02-source-dive-ldtk-source-ui-mining/02-CONTEXT.md
@.planning/phases/02-source-dive-ldtk-source-ui-mining/02-RESEARCH.md
@.planning/research/LDTK-UI-MINING.md
@.planning/research/PITFALLS.md
@.planning/research/FEATURES.md

<interfaces>
Core Haxe targets:
- `C:\Programming_Files\ldtk-master\src\electron.renderer\page\Editor.hx`
- `C:\Programming_Files\ldtk-master\src\electron.renderer\Tool.hx`
- `C:\Programming_Files\ldtk-master\src\electron.renderer\tool\`
- `C:\Programming_Files\ldtk-master\src\electron.renderer\ui\`
- `C:\Programming_Files\ldtk-master\src\electron.renderer\ui\modal\`
- `C:\Programming_Files\ldtk-master\src\electron.renderer\ui\palette\`
- `C:\Programming_Files\ldtk-master\src\electron.renderer\ui\vp\`
</interfaces>
</context>

<tasks>

<task type="auto">
  <name>Task 1: Build the Haxe file-by-file UI index</name>
  <read_first>
    - All `.hx` files under the Haxe target directories listed in interfaces
  </read_first>
  <files>.planning/research/LDTK-UI-MINING.md</files>
  <action>
    Append to `## File-by-File UI Index` a table with one row per mined file:
    - Relative path from `C:\Programming_Files\ldtk-master\`
    - UI role
    - Primary UI pattern, if any
    - Mining disposition: `adopt-candidate`, `rejected`, `background`, or `not-ui`

    Use `rg --files` for the file list, then read files in batches. Do not skip small files; D-01 requires a comprehensive pass.
  </action>
  <verify>
    The index contains rows for `ui\CommandPalette.hx`, `ui\modal\ContextMenu.hx`, `ui\modal\Panel.hx`, `ui\palette\`, `ui\vp\`, `page\Editor.hx`, and at least one `tool\*.hx` file.
  </verify>
  <done>
    Comprehensive file index is appended.
  </done>
</task>

<task type="auto">
  <name>Task 2: Extract adoptable Haxe UI patterns</name>
  <read_first>
    - Files marked `adopt-candidate` in Task 1
  </read_first>
  <files>.planning/research/LDTK-UI-MINING.md</files>
  <action>
    Append at least 12 entries to `## UI Pattern Catalogue`. Each entry must include:
    - Pattern name
    - Evidence: one or more `C:\Programming_Files\ldtk-master\...:N-M` citations
    - What LDtk does
    - Why it is useful for NeoCade
    - Anti-cyberpunk filter: one sentence confirming the pattern stays arcade-friendly and does not bring synthwave/noir/glitch aesthetics
    - Optional translation note, only where obvious, beginning exactly with `Inspiration sketch - Phase 3 mockup or Phase 5+ designer's call.`

    Candidate pattern families to check:
    - Main editor panel wiring and edit buttons
    - Modal/Dialog lifecycle and close behavior
    - Context menu composition
    - Command palette / quick search
    - Tool palette button modes
    - Palette popout handling
    - Entity/layer list visual affordances
    - Notifications and persistent banners
    - Collapsible panels and section headers
    - Tool-specific active/disabled conventions
    - Form-field reset/default affordances
    - Viewport overlays and cursor feedback
  </action>
  <verify>
    `LDTK-UI-MINING.md` contains at least 12 Haxe-derived pattern entries and every entry has a line citation and anti-cyberpunk note.
  </verify>
  <done>
    Adoptable Haxe pattern catalogue appended.
  </done>
</task>

<task type="auto">
  <name>Task 3: Extract Haxe-derived rejected patterns</name>
  <read_first>
    - Files or features found in Task 1/2 that do not map cleanly to Godot Theme resources
  </read_first>
  <files>.planning/research/LDTK-UI-MINING.md</files>
  <action>
    Append at least 5 entries to `## Rejected Patterns` from Haxe implementation evidence. Each rejection needs:
    - Pattern name
    - Evidence citation
    - Why NeoCade rejects it
    - Whether it is rejected because of Godot Theme limitations, HD-only constraints, anti-cyberpunk drift, copying risk, or phase scope

    Strong candidates include behavior requiring scripting rather than Theme entries, Heaps/Electron-specific process/UI assumptions, hover-triggered popouts, bitmap/atlas-driven UI primitives, or LDtk content-domain affordances that should not become NeoCade theme spec.
  </action>
  <verify>
    At least 5 rejected Haxe patterns are present and none are vague or uncited.
  </verify>
  <done>
    Rejection list appended.
  </done>
</task>

</tasks>

<verification>
- [ ] Haxe file-by-file index covers every required UI directory
- [ ] At least 12 Haxe-derived adopted patterns exist
- [ ] At least 5 Haxe-derived rejected patterns exist
- [ ] Every adopted pattern includes a line citation and anti-cyberpunk note
- [ ] Every translation note uses the mandatory prefix
- [ ] No theme/addon files changed
</verification>

<success_criteria>
- Haxe UI mining closes the ROADMAP pattern/rejection thresholds by itself or materially contributes to them
- LDtk remains inspiration-only in tone and wording
</success_criteria>

<output>
After completion, create `.planning/phases/02-source-dive-ldtk-source-ui-mining/02-02-SUMMARY.md` with counts: files indexed, adopted patterns, rejected patterns, and any Haxe surfaces intentionally marked `not-ui`.
</output>
