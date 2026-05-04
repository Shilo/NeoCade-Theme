---
phase: 02-source-dive-ldtk-source-ui-mining
plan: 03
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
    - "app/assets/css/app.scss is mined beyond the palette variables already referenced by ARCHITECTURE.md"
    - "SCSS chrome conventions are documented with selector line ranges for panels, buttons/tool buttons, modal/dialog surfaces, context menus, palette/list surfaces, focus/hover/active states, and scroll/status affordances where present"
    - "Active verification grep audit covers gradients, shadow declarations, transition/animation, focus, hover, active, selected, disabled, collapsed, modal, context-menu, and panel selectors"
    - "SCSS-derived findings are framed as inspiration only and do not promote LDtk numeric values into NeoCade binding tokens"
    - "At least 8 SCSS-derived patterns or confirmations are appended with line citations"
    - "Any cyberpunk-adjacent or non-portable visual move is rejected explicitly"
  artifacts:
    - .planning/research/LDTK-UI-MINING.md (appended)
  key_links:
    - "CONTEXT.md D-03, D-12, D-15, D-16"
    - ".planning/research/ARCHITECTURE.md Section 7 anti-cyberpunk rules"
---

<objective>
Mine LDtk's `app/assets/css/app.scss` for concrete chrome and interaction-state conventions, then run an active verification grep audit so obvious visual-state patterns are not missed.
</objective>

<context>
@.planning/phases/02-source-dive-ldtk-source-ui-mining/02-CONTEXT.md
@.planning/research/LDTK-UI-MINING.md
@.planning/research/ARCHITECTURE.md
@.planning/research/PITFALLS.md

<interfaces>
Main stylesheet:
- `C:\Programming_Files\ldtk-master\app\assets\css\app.scss`
</interfaces>
</context>

<tasks>

<task type="auto">
  <name>Task 1: Section-map app.scss before extracting findings</name>
  <read_first>
    - C:\Programming_Files\ldtk-master\app\assets\css\app.scss
  </read_first>
  <files>.planning/research/LDTK-UI-MINING.md</files>
  <action>
    Build a selector/section map for `app.scss` using `rg -n` and targeted reads. Append a compact map to `## SCSS Chrome and Interaction Conventions` before detailed findings.

    Include line ranges for:
    - Global palette/type/root variables
    - Main layout and side panels
    - Buttons and tool buttons
    - Modal/dialog/context-menu selectors
    - Palette/list/tree-like selectors
    - Forms and inputs
    - Status, warning, notification, and banner selectors
    - Collapsible or selected/active states
  </action>
  <verify>
    The SCSS section map exists and cites line ranges from `app.scss`.
  </verify>
  <done>
    `app.scss` map appended.
  </done>
</task>

<task type="auto">
  <name>Task 2: Extract SCSS chrome and interaction-state findings</name>
  <read_first>
    - Relevant `app.scss` ranges identified in Task 1
  </read_first>
  <files>.planning/research/LDTK-UI-MINING.md</files>
  <action>
    Append at least 8 SCSS-derived findings under `## SCSS Chrome and Interaction Conventions`.

    Each finding must include:
    - Selector or convention name
    - `app.scss:N-M` citation
    - What LDtk does visually
    - Whether NeoCade can adopt the idea as a Theme/StyleBox pattern, with any translation note using the mandatory prefix
    - Anti-cyberpunk note or rejection reason

    Do not copy LDtk numeric SCSS values as NeoCade token decisions. Numeric values may be cited as evidence only, clearly labeled non-binding.
  </action>
  <verify>
    At least 8 findings exist, each with `app.scss` line citations and no binding-token language.
  </verify>
  <done>
    SCSS findings appended.
  </done>
</task>

<task type="auto">
  <name>Task 3: Run active verification grep audit for missed visual-state selectors</name>
  <read_first>
    - C:\Programming_Files\ldtk-master\app\assets\css\app.scss
    - .planning/research/LDTK-UI-MINING.md (current SCSS findings)
  </read_first>
  <files>.planning/research/LDTK-UI-MINING.md</files>
  <action>
    Run an active grep audit with patterns including:
    ```powershell
    rg -n "gradient|box-shadow|text-shadow|filter|transition|animation|focus|hover|active|selected|disabled|collapsed|modal|context|palette|panel|button|scroll|warning|error|success" 'C:\Programming_Files\ldtk-master\app\assets\css\app.scss'
    ```

    Append an `Active Verification Audit` subsection under `## Phase 2 Verification Log` listing:
    - Patterns searched
    - Any high-value hits not already covered
    - Any rejected visual moves, especially shadows/glow/gradient usage that would conflict with NeoCade v1 constraints
    - Confirmation that the SCSS pass went beyond lines 1-24
  </action>
  <verify>
    The verification log contains the phrase `Active Verification Audit` and mentions gradients, shadows, focus, hover, selected, disabled, collapsed, modal, context, panel, and button searches.
  </verify>
  <done>
    Active verification audit appended.
  </done>
</task>

</tasks>

<verification>
- [ ] SCSS section map created
- [ ] At least 8 SCSS findings with line citations exist
- [ ] Active verification grep audit appended
- [ ] No LDtk numeric values are promoted to binding NeoCade tokens
- [ ] No `.tres` or addon files changed
</verification>

<success_criteria>
- Phase 2 has evidence-grade SCSS chrome and state findings
- The active verification audit reduces missed-selector risk
</success_criteria>

<output>
After completion, create `.planning/phases/02-source-dive-ldtk-source-ui-mining/02-03-SUMMARY.md` with SCSS line ranges read, findings count, rejection count, and active-verification notes.
</output>

