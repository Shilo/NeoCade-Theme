---
phase: 01-source-dive-godot-minimal-theme-tres-dissection
plan: 04
type: execute
wave: 1
depends_on: []
files_modified:
  - .planning/research/MINIMAL-THEME-COVERAGE-DELTA.md
autonomous: true
requirements:
  - RES-01
must_haves:
  truths:
    - "MINIMAL-THEME-COVERAGE-DELTA.md exists at .planning/research/ with the 27-vs-35 comparison, the 8 NeoCade-additives section, the FlatButton type-variation note, and the container-chrome reconciliation"
    - "Each of the 35 FEATURES.md classes is classified into one of: 'themed in upstream (enumerated in DISSECTION.md)', 'themed in upstream but bare class is unthemed (e.g., MenuBar via MainMenuBar)', or 'NeoCade-additive (no upstream benchmark — NeoCade owns the design)'"
    - "Each of the 8 NeoCade-additives (CodeEdit, FoldableContainer, SpinBox, ColorPickerButton, LinkButton, FileDialog, ConfirmationDialog, TooltipLabel) gets an explicit row noting 'no upstream benchmark exists; NeoCade owns the design — see Phase 4-5 for token/style ownership'"
    - "FlatButton is documented as a Button TYPEVAR-01 type variation (TYPEVAR-01 / DF-Button-1 per FEATURES.md) — even though upstream uses FlatButton as an editor-only Control type"
  artifacts:
    - .planning/research/MINIMAL-THEME-COVERAGE-DELTA.md (created)
  key_links:
    - "Each row in the comparison table cross-links to either MINIMAL-THEME-DISSECTION.md `### ClassName` (for themed-in-upstream classes) or to FEATURES.md classification (for NeoCade-additives)"
    - "Container-chrome reconciliation accounts for HSplit/VSplit/Separator classes that are user-facing in FEATURES.md but minimally themed in upstream"
---

<objective>
Create `.planning/research/MINIMAL-THEME-COVERAGE-DELTA.md` — the 27-themed-in-upstream vs 35-target-in-FEATURES.md coverage comparison plus the 8 NeoCade-additives + FlatButton + container-chrome accounting. This is the analysis split required by CONTEXT.md D-15 (description vs analysis): the dissection doc stays purely descriptive; this doc carries the comparison analysis.

Purpose: Discharge CONTEXT.md D-09 (8 NeoCade-additives documented) and D-10 (FlatButton special-case noted). Phase 4's `@tool` token-generator and Phase 10's COV-10 verification both need this delta to know which Controls have an upstream benchmark and which NeoCade designs from scratch.

Output: One new file `.planning/research/MINIMAL-THEME-COVERAGE-DELTA.md` with sections:
  1. Header / authored date / cross-references
  2. Coverage scorecard (35 FEATURES.md classes × upstream coverage status)
  3. NeoCade-additives detail (8 + container chrome surfaces)
  4. FlatButton type-variation note
  5. Numeric summary (X themed in upstream / Y NeoCade-additive / Z bare-class-unthemed)
</objective>

<execution_context>
@$HOME/.claude/get-shit-done/workflows/execute-plan.md
@$HOME/.claude/get-shit-done/templates/summary.md
</execution_context>

<context>
@.planning/PROJECT.md
@.planning/ROADMAP.md
@.planning/STATE.md
@.planning/phases/01-source-dive-godot-minimal-theme-tres-dissection/01-CONTEXT.md
@.planning/phases/01-source-dive-godot-minimal-theme-tres-dissection/01-RESEARCH.md
@.planning/research/FEATURES.md (35-class matrix — authority for the comparison axis)

<interfaces>
<!-- 35 user-facing Control classes per FEATURES.md (the comparison axis) -->
The 35-class FEATURES.md matrix consists of (executor reads FEATURES.md to confirm exact list — but per CONTEXT.md D-08 + D-09, the dissection-relevant subset is):
  - 27 themed-in-upstream Controls (D-08): AcceptDialog, Button, CheckBox, CheckButton, ColorPicker, GraphEdit, HScrollBar, HSlider, ItemList, Label, LineEdit, MenuBar, MenuButton, OptionButton, Panel, PopupMenu, PopupPanel, ProgressBar, RichTextLabel, TabBar, TabContainer, TextEdit, TooltipPanel, Tree, VScrollBar, VSlider, Window
  - 8 NeoCade-additives (D-09): CodeEdit, FoldableContainer, SpinBox, ColorPickerButton, LinkButton, FileDialog, ConfirmationDialog, TooltipLabel
  - Container chrome (D-09 trailing note + active-verification): HSplitContainer, VSplitContainer

Note: 27 + 8 = 35. The container-chrome classes (HSplit/VSplit) are explicitly mentioned in CONTEXT.md D-09 as "Plus container chrome ... and any other classes the active-verification step surfaces." Treat HSplit/VSplit as one of: (a) themed in upstream (likely — they're common and have stylebox `bg` + icon `grabber`), (b) bare-class-unthemed (if upstream targets only the editor variants), or (c) NeoCade-additive. Plan 02 Task 1's active-verification audit answers this.

<!-- Reconciliation rules (per CONTEXT.md and Plan 02 active-verification) -->
- "MenuBar" — D-08 lists; upstream targets `MainMenuBar` (editor-only). Per Plan 02 Task 1 reconciliation → bare MenuBar is "themed via inheritance/default — NeoCade-additive for first-class MenuBar coverage."
- "Panel" — D-08 lists; upstream theme keys are `PanelContainer` and `PopupPanel` but bare `Panel` may have no entries. Per Plan 02 → reconciliation note in DISSECTION.md decides.
- "FlatButton" — D-10 explicit. NeoCade uses the name as a Button TYPEVAR-01 type variation (FEATURES.md DF-Button-1). Even though upstream's FlatButton is editor-only, the dissected entries are research material for NeoCade's TYPEVAR-01 visual contract.

<!-- Output file structure -->
The doc is purely the 27-vs-35 + additives analysis. It is NOT the per-Control entry enumeration (that lives in DISSECTION.md). Tables here are class-row level, not entry-row level.
</interfaces>
</context>

<tasks>

<task type="auto">
  <name>Task 1: Create MINIMAL-THEME-COVERAGE-DELTA.md with header + the 35-class scorecard table</name>
  <read_first>
    - .planning/research/FEATURES.md (35-class matrix — confirm class names match D-08 + D-09 + container chrome)
    - .planning/phases/01-source-dive-godot-minimal-theme-tres-dissection/01-CONTEXT.md (D-08, D-09, D-10)
    - .planning/research/MINIMAL-THEME-DISSECTION.md (Plan 02's active-verification audit — for reconciliation outcomes; if Plan 02 has not yet completed, the audit reconciliation values come from Plan 02's `<interfaces>` block predictions and are flagged as "pending Plan 02 completion")
    - .planning/research/SOURCES.md (cross-link target — Plan 05 will link this delta doc back into SOURCES.md)
  </read_first>
  <files>.planning/research/MINIMAL-THEME-COVERAGE-DELTA.md</files>
  <action>
    Use the Write tool to create the file with this exact content (preserve every section heading and the 35-row table):

    ```markdown
    # godot-minimal-theme — Coverage Delta vs FEATURES.md 35-Class Matrix

    **Authored:** 2026-05-04
    **Status:** Living research artifact — feeds Phase 4 generator (TokenSet structure decisions) and Phase 10 COV-10 verification.
    **Cross-references:**
    - `.planning/research/MINIMAL-THEME-DISSECTION.md` — descriptive enumeration of every entry upstream populates per Control × per state × per slot.
    - `.planning/research/FEATURES.md` — the 35-class FEATURES.md matrix authoritative for NeoCade's v1 user-facing-Control coverage scope.
    - `.planning/research/SOURCES.md` Section 1 (godot-minimal-theme) — synthesis pattern (`What was read / adopted / rejected / still open`); this delta doc is one of the artifacts SOURCES.md links to (cross-linked by Plan 05).

    ## Methodology

    Each of the 35 user-facing Controls in FEATURES.md is classified into one of:
    - **Themed in upstream** — at least one `set_*` call targets the class in `minimal_theme.tres`. NeoCade has an upstream benchmark; coverage delta says "feature-complete to upstream's bar" for this class.
    - **Bare-class unthemed (themed via specialization)** — upstream themes a more specialized class name (e.g., `MainMenuBar` instead of bare `MenuBar`). NeoCade-additive for the bare class — first-class theming required because the engine doesn't auto-cascade from the specialized name to the bare class.
    - **NeoCade-additive** — no upstream entries; NeoCade owns the design (no benchmark exists).

    Every "themed in upstream" row links into `MINIMAL-THEME-DISSECTION.md`'s `### ClassName` section. NeoCade-additive rows link to FEATURES.md or to the relevant Phase 5 type-variation decision.

    ## Coverage Scorecard

    | # | Class | FEATURES.md class type | Upstream coverage | Cross-reference |
    |---|-------|------------------------|-------------------|-----------------|
    | 1  | AcceptDialog       | dialog                  | themed in upstream                | DISSECTION.md `### AcceptDialog` |
    | 2  | Button             | button                  | themed in upstream                | DISSECTION.md `### Button` |
    | 3  | CheckBox           | button                  | themed in upstream                | DISSECTION.md `### CheckBox` |
    | 4  | CheckButton        | button                  | themed in upstream                | DISSECTION.md `### CheckButton` |
    | 5  | CodeEdit           | input                   | NeoCade-additive (no upstream)    | FEATURES.md COV-04; Phase 4 owns design |
    | 6  | ColorPicker        | input                   | themed in upstream                | DISSECTION.md `### ColorPicker` |
    | 7  | ColorPickerButton  | button                  | NeoCade-additive (no upstream)    | FEATURES.md TYPEVAR / button-family; Phase 5 |
    | 8  | ConfirmationDialog | dialog                  | NeoCade-additive (no upstream)    | FEATURES.md COV-05; Phase 6 |
    | 9  | FileDialog         | dialog                  | NeoCade-additive (no upstream)    | FEATURES.md COV-05; Phase 6 |
    | 10 | FlatButton         | (Button type variation) | research-only (D-10 — see notes)  | DISSECTION.md `### FlatButton`; Phase 5 TYPEVAR-01 |
    | 11 | FoldableContainer  | container               | NeoCade-additive (no upstream)    | FEATURES.md COV-08; Phase 7 |
    | 12 | GraphEdit          | container/specialized   | themed in upstream                | DISSECTION.md `### GraphEdit` |
    | 13 | HScrollBar         | input                   | themed in upstream                | DISSECTION.md `### HScrollBar` |
    | 14 | HSlider            | input                   | themed in upstream                | DISSECTION.md `### HSlider` |
    | 15 | HSplitContainer    | container               | [PLACEHOLDER — Task 2 fills based on Plan 02 active-verification audit] | TBD |
    | 16 | ItemList           | list                    | themed in upstream                | DISSECTION.md `### ItemList` |
    | 17 | Label              | label                   | themed in upstream                | DISSECTION.md `### Label` |
    | 18 | LineEdit           | input                   | themed in upstream                | DISSECTION.md `### LineEdit` |
    | 19 | LinkButton         | button                  | NeoCade-additive (no upstream)    | FEATURES.md TYPEVAR; Phase 5 |
    | 20 | MenuBar            | menu                    | bare-class unthemed (upstream targets MainMenuBar editor-only) — NeoCade owns first-class MenuBar | FEATURES.md COV-02; Phase 6 |
    | 21 | MenuButton         | button                  | themed in upstream                | DISSECTION.md `### MenuButton` |
    | 22 | OptionButton       | button                  | themed in upstream                | DISSECTION.md `### OptionButton` |
    | 23 | Panel              | container               | bare-class unthemed (upstream targets PanelContainer / PopupPanel) — NeoCade owns first-class Panel | FEATURES.md COV-08; Phase 7 |
    | 24 | PopupMenu          | popup                   | themed in upstream                | DISSECTION.md `### PopupMenu` |
    | 25 | PopupPanel         | popup                   | themed in upstream                | DISSECTION.md `### PopupPanel` |
    | 26 | ProgressBar        | indicator               | themed in upstream                | DISSECTION.md `### ProgressBar` |
    | 27 | RichTextLabel      | label                   | themed in upstream                | DISSECTION.md `### RichTextLabel` |
    | 28 | SpinBox            | input                   | NeoCade-additive (no upstream)    | FEATURES.md COV-04; Phase 6 |
    | 29 | TabBar             | tabs                    | themed in upstream                | DISSECTION.md `### TabBar` |
    | 30 | TabContainer       | tabs                    | themed in upstream                | DISSECTION.md `### TabContainer` |
    | 31 | TextEdit           | input                   | themed in upstream                | DISSECTION.md `### TextEdit` |
    | 32 | TooltipLabel       | label                   | NeoCade-additive (no upstream)    | FEATURES.md COV-09; Phase 6/7 |
    | 33 | TooltipPanel       | popup                   | themed in upstream                | DISSECTION.md `### TooltipPanel` |
    | 34 | Tree               | list                    | themed in upstream                | DISSECTION.md `### Tree` |
    | 35 | VScrollBar         | input                   | themed in upstream                | DISSECTION.md `### VScrollBar` |
    | 36 | VSlider            | input                   | themed in upstream                | DISSECTION.md `### VSlider` |
    | 37 | VSplitContainer    | container               | [PLACEHOLDER — Task 2 fills based on Plan 02 active-verification audit] | TBD |
    | 38 | Window             | popup/window            | themed in upstream                | DISSECTION.md `### Window` |

    > **Row count is 38** — 35 FEATURES.md classes + FlatButton (research-only D-10) + HSplitContainer + VSplitContainer (container chrome called out in D-09). FEATURES.md may already include HSplit/VSplit in its 35; verify in Task 2 and reconcile if double-counted.

    ## NeoCade-Additives (8) — Detail

    Per CONTEXT.md D-09, these eight Controls have no upstream benchmark — NeoCade owns the design. Each row below is for downstream Phase 4-7 generator + visual-design implementation.

    | Class | Why no upstream benchmark | NeoCade ownership phase | Design hooks |
    |-------|---------------------------|-------------------------|--------------|
    | CodeEdit            | Editor's GDScript editor uses CodeEdit but upstream theme leaves it engine-default; NeoCade theme it for game console / chat / runtime CodeEdit usage | Phase 4 (token foundation) + Phase 6 (input styling) | syntax-highlighting tokens (deferred to v1.x); base styling derived from TextEdit |
    | FoldableContainer   | Newer Godot Control (4.4+); upstream targets pre-FoldableContainer era                              | Phase 7 (container styling)            | Header chrome from PanelContainer; foldable affordance from upstream's `arrow_collapsed` Tree icon style |
    | SpinBox             | SpinBox is a composite (LineEdit + UpDown buttons); upstream styles components but not the composite directly | Phase 6 (input styling) | Compose from LineEdit + Button states |
    | ColorPickerButton   | Editor uses, but theme defaults rely on engine fallback; needs first-class theming for game-runtime color pickers | Phase 5 (button-family styling) | Compose from Button + ColorPicker swatch icon |
    | LinkButton          | Underline-on-hover button variant; not styled in upstream (editor doesn't use)                     | Phase 5 (button TYPEVAR)               | New stylebox profile; underline via font setting |
    | FileDialog          | Composite popup; upstream targets generic AcceptDialog only                                          | Phase 6 (popup styling)                | Compose from AcceptDialog + ItemList chrome |
    | ConfirmationDialog  | Specialized AcceptDialog with cancel button; upstream styles AcceptDialog only                      | Phase 6 (popup styling)                | Compose from AcceptDialog; emphasize destructive-action button via state-layer model |
    | TooltipLabel        | Inner Label of TooltipPanel; upstream styles TooltipPanel only                                      | Phase 6/7 (label styling)              | Compose from Label + TooltipPanel padding |

    ## FlatButton — Type Variation Note (D-10)

    FlatButton is **editor-only in upstream** (used for editor toolbar buttons that appear flat against the editor chrome). NeoCade's v1 scope per AF-6 of FEATURES.md skips editor-only types **except** FlatButton, where the name is reused as a Button type variation per FEATURES.md TYPEVAR-01 / DF-Button-1.

    **Source-dive value:** `MINIMAL-THEME-DISSECTION.md ### FlatButton` enumerates upstream's editor-FlatButton entries as research material. NeoCade's TYPEVAR-01 visual contract is designed independently in Phase 5 — the dissection is **inspiration**, not implementation. The "borderless / transparent / hover-only" pattern upstream uses is the design starting point; NeoCade's specific tokens (corner radius, hover-state-layer alpha, etc.) come from Phase 3's mockup-approved palette.

    **Coverage delta status:** FlatButton is NOT one of the 35 (it's a type variation, not a Control class) — counted separately. NeoCade's v1 ships FlatButton as a Button type variation, sharing all Button base entries plus a flat-style override.

    ## Numeric Summary

    | Bucket | Count |
    |--------|-------|
    | Themed in upstream (FEATURES.md classes with `### ClassName` enumeration in DISSECTION.md) | 27 |
    | NeoCade-additive (no upstream benchmark) | 8 |
    | Bare-class unthemed (upstream targets specialization only — NeoCade owns first-class) | up to 2 (MenuBar, Panel — depending on active-verification audit outcome) |
    | Research-only (FlatButton — D-10 exception) | 1 |
    | Container chrome (HSplit, VSplit — TBD per Plan 02 audit) | 2 |
    | **Total FEATURES.md scope** | 35 |
    | **Plus research items beyond FEATURES.md scope** | 1 (FlatButton) |

    27 + 8 = 35 if MenuBar and Panel are counted in "themed in upstream" via specialization. If they're "bare-class unthemed → NeoCade owns," shift those counts. Plan 02 active-verification audit reconciles the exact split.
    ```

    Note that some "[PLACEHOLDER — Task 2 fills...]" cells are deliberate — Task 2 of THIS plan reconciles them based on Plan 02's active-verification audit outcomes.
  </action>
  <verify>
    ```bash
    test -f .planning/research/MINIMAL-THEME-COVERAGE-DELTA.md
    grep -q "Coverage Scorecard" .planning/research/MINIMAL-THEME-COVERAGE-DELTA.md
    grep -q "27" .planning/research/MINIMAL-THEME-COVERAGE-DELTA.md
    grep -q "35" .planning/research/MINIMAL-THEME-COVERAGE-DELTA.md
    for c in CodeEdit FoldableContainer SpinBox ColorPickerButton LinkButton FileDialog ConfirmationDialog TooltipLabel; do
      grep -q "$c" .planning/research/MINIMAL-THEME-COVERAGE-DELTA.md || { echo "MISSING ADDITIVE: $c"; exit 1; }
    done
    grep -q "FlatButton" .planning/research/MINIMAL-THEME-COVERAGE-DELTA.md
    grep -q "TYPEVAR-01" .planning/research/MINIMAL-THEME-COVERAGE-DELTA.md
    ```
  </verify>
  <done>
    File created with all 8 additives present, scorecard table populated, FlatButton/TYPEVAR-01 references present.
  </done>
  <acceptance_criteria>
    - File `.planning/research/MINIMAL-THEME-COVERAGE-DELTA.md` exists
    - File contains literal strings `Coverage Scorecard`, `27`, `35`
    - File contains all 8 NeoCade-additive class names (CodeEdit, FoldableContainer, SpinBox, ColorPickerButton, LinkButton, FileDialog, ConfirmationDialog, TooltipLabel)
    - File contains literal strings `FlatButton` and `TYPEVAR-01`
  </acceptance_criteria>
</task>

<task type="auto">
  <name>Task 2: Reconcile HSplitContainer / VSplitContainer placeholder rows + bare-class outcomes against Plan 02's active-verification audit</name>
  <read_first>
    - .planning/research/MINIMAL-THEME-DISSECTION.md (Plan 02 Task 1's `### Active Verification Audit` table — record the bucket each of HSplitContainer, VSplitContainer, MenuBar, Panel was classified into)
    - .planning/research/MINIMAL-THEME-COVERAGE-DELTA.md (placeholder cells in Task 1's deliverable to update)
  </read_first>
  <files>.planning/research/MINIMAL-THEME-COVERAGE-DELTA.md (Edit placeholder cells; update Numeric Summary)</files>
  <action>
    1. Read DISSECTION.md's Active Verification Audit. For each of HSplitContainer, VSplitContainer, MenuBar, Panel, find the bucket assignment ("user-facing — enumerated below" / "container chrome" / "editor-only" / etc.) and any reconciliation note.

    2. Use the Edit tool to replace the two `[PLACEHOLDER — Task 2 fills based on Plan 02 active-verification audit]` cells in COVERAGE-DELTA.md's Coverage Scorecard rows for HSplitContainer (#15) and VSplitContainer (#37) with the actual values:
       - If audit says "themed in upstream": cell becomes `themed in upstream` and Cross-reference becomes `DISSECTION.md ### User-facing container chrome` (note: container chrome is a single combined section in DISSECTION.md per Plan 02 Task 7).
       - If audit says "container chrome — minimally themed (constants only)": cell becomes `themed in upstream (constants only)` with the same cross-reference.
       - If audit says "NeoCade-additive": cell becomes `NeoCade-additive (no upstream)` with cross-reference to FEATURES.md container coverage.

    3. Update the Numeric Summary table's `Bare-class unthemed` row from `up to 2 (MenuBar, Panel — depending on active-verification audit outcome)` to the actual outcome (e.g., `2 (MenuBar bare, Panel bare)` or `0 (both have specialization-coverage that satisfies)`).

    4. Update the Numeric Summary's final paragraph (`27 + 8 = 35 if MenuBar and Panel are counted...`) to reflect the actual reconciliation outcome — pick whichever sentence matches reality and remove the conditional.

    5. If active-verification audit surfaced any classes BEYOND the 35+1+2 (e.g., a class that's user-facing in Godot but not on FEATURES.md's matrix) — append a new section `## Surfaced Beyond FEATURES.md` documenting it for v1.x evaluation.
  </action>
  <verify>
    ```bash
    # No PLACEHOLDER strings remain
    ! grep -q "PLACEHOLDER" .planning/research/MINIMAL-THEME-COVERAGE-DELTA.md
    # Numeric summary's "up to 2" conditional has been resolved (or replaced)
    ! grep -q "up to 2" .planning/research/MINIMAL-THEME-COVERAGE-DELTA.md
    # HSplitContainer and VSplitContainer rows have non-empty Cross-reference cells
    awk '/HSplitContainer/' .planning/research/MINIMAL-THEME-COVERAGE-DELTA.md | grep -qvE "TBD|PLACEHOLDER"
    awk '/VSplitContainer/' .planning/research/MINIMAL-THEME-COVERAGE-DELTA.md | grep -qvE "TBD|PLACEHOLDER"
    ```
  </verify>
  <done>
    All placeholders resolved with concrete values from Plan 02's audit.
  </done>
  <acceptance_criteria>
    - File no longer contains the literal string `PLACEHOLDER`
    - File no longer contains the literal string `up to 2`
    - HSplitContainer row's Cross-reference cell is non-empty (contains either `DISSECTION.md` or `FEATURES.md`)
    - VSplitContainer row's Cross-reference cell is non-empty (same condition)
  </acceptance_criteria>
</task>

</tasks>

<threat_model>
## Trust Boundaries

| Boundary | Description |
|----------|-------------|
| FEATURES.md 35-class matrix → coverage delta scope | If FEATURES.md's class set drifts (added / removed classes), this delta becomes stale. Mitigation: this doc is dated; Phase 10 COV-10 re-verifies against the then-current FEATURES.md. |
| Plan 02 active-verification audit → Task 2 reconciliation | Task 2 depends on Task 1 of Plan 02 (the audit). Wave-1 parallel scheduling means audit may complete before or after this plan; Task 2 explicitly reads from DISSECTION.md so it gets a deterministic snapshot regardless of scheduling. |

## STRIDE Threat Register

| Threat ID | Category | Component | Disposition | Mitigation Plan |
|-----------|----------|-----------|-------------|-----------------|
| T-1-10 | Repudiation | Counting "themed in upstream" inconsistently between this delta and DISSECTION.md | mitigate | Cross-reference column in scorecard cites the exact `### ClassName` heading in DISSECTION.md; Phase 10 COV-10 verifies coverage by walking these links. |
| T-1-11 | Information disclosure | Misclassifying a NeoCade-additive as "themed in upstream" because the class name appears in upstream as an editor-only specialization (e.g., MainMenuBar vs MenuBar) | mitigate | Reconciliation rules in Task 1's `<interfaces>` block explicitly call out MenuBar/Panel/HSplit/VSplit; Task 2 verifies against Plan 02's audit. |
</threat_model>

<verification>
- [ ] Coverage scorecard has exactly 38 rows (35 FEATURES.md + FlatButton + 2 splits) — or whatever count Task 2 reconciliation produces
- [ ] All 8 NeoCade-additives explicitly named in their detail section
- [ ] FlatButton type-variation note references TYPEVAR-01
- [ ] Numeric Summary buckets sum correctly
- [ ] No PLACEHOLDER cells remain after Task 2
</verification>

<success_criteria>
- All grep checks across tasks 1-2 pass
- File reads as a clean class-row coverage analysis (NOT entry-level enumeration)
- Cross-references into DISSECTION.md are clickable / greppable (consistent `### ClassName` form)
</success_criteria>

<output>
After completion, create `.planning/phases/01-source-dive-godot-minimal-theme-tres-dissection/01-04-SUMMARY.md` capturing: scorecard final counts (themed-in-upstream / NeoCade-additive / bare-class-unthemed / research-only / surfaced-beyond), the resolution of MenuBar / Panel / HSplit / VSplit placeholders, and any classes surfaced beyond FEATURES.md.
</output>
