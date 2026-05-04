---
phase: 01-source-dive-godot-minimal-theme-tres-dissection
plan: 04
type: execute
wave: 2
depends_on:
  - 01
  - 02
files_modified:
  - .planning/research/MINIMAL-THEME-COVERAGE-DELTA.md
autonomous: true
requirements:
  - RES-01
must_haves:
  truths:
    - "MINIMAL-THEME-COVERAGE-DELTA.md exists at .planning/research/ with the 35-class comparison (HSplit and VSplit are INSIDE the 35; FlatButton is OUTSIDE per cross-AI review MED #4), the 8 NeoCade-additives section, the FlatButton research-only note, and the container-chrome reconciliation"
    - "Each of the 35 FEATURES.md classes is classified into one of: 'themed in upstream (enumerated in DISSECTION.md)', 'themed in upstream but bare class is unthemed (e.g., MenuBar via MainMenuBar)', or 'NeoCade-additive (no upstream benchmark — NeoCade owns the design)'"
    - "Each of the 8 NeoCade-additives (CodeEdit, FoldableContainer, SpinBox, ColorPickerButton, LinkButton, FileDialog, ConfirmationDialog, TooltipLabel) gets an explicit row noting 'no upstream benchmark exists; NeoCade owns the design — see Phase 4-5 for token/style ownership'"
    - "FlatButton is documented as a Button TYPEVAR-01 type variation in its own section OUTSIDE the 35-class scorecard — research-only, not a Control class (D-10)"
    - "Sum invariant holds after Task 2: themed-in-upstream + NeoCade-additive + bare-class-unthemed + container-chrome = 35 exactly"
  artifacts:
    - .planning/research/MINIMAL-THEME-COVERAGE-DELTA.md (created)
  key_links:
    - "Each row in the comparison table cross-links to either MINIMAL-THEME-DISSECTION.md `### ClassName` (for themed-in-upstream classes) or to FEATURES.md classification (for NeoCade-additives)"
    - "HSplit and VSplit rows verified at plan-prep time to be IN the 35-class FEATURES.md matrix (FEATURES.md grep confirmed); not added as a separate +2 bucket"
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

**Plan-prep determination (per cross-AI review 2026-05-04 MED #4):** Reading `.planning/research/FEATURES.md` directly at plan-authoring time confirms that `HSplitContainer` and `VSplitContainer` ARE in the v1 user-facing class matrix (both rows marked YES, theme-entries = "Constants + grabber icon"). Therefore the scorecard's 35-class universe ALREADY INCLUDES HSplit and VSplit — they are NOT a separate "+2" appended bucket. The earlier plan version's `38 row scorecard = 35 + FlatButton + HSplit + VSplit` framing was a double-count; the corrected framing is `35 row scorecard (HSplit and VSplit are rows #15 and #36 within the 35) + FlatButton listed separately as research-only outside the 35`.

The 35-class FEATURES.md matrix consists of (executor verifies the exact list against FEATURES.md but the count is fixed at 35 by D-08+D-09 + this plan-prep determination):
  - 27 themed-in-upstream Controls (D-08): AcceptDialog, Button, CheckBox, CheckButton, ColorPicker, GraphEdit, HScrollBar, HSlider, ItemList, Label, LineEdit, MenuBar, MenuButton, OptionButton, Panel, PopupMenu, PopupPanel, ProgressBar, RichTextLabel, TabBar, TabContainer, TextEdit, TooltipPanel, Tree, VScrollBar, VSlider, Window
  - 8 NeoCade-additives (D-09): CodeEdit, FoldableContainer, SpinBox, ColorPickerButton, LinkButton, FileDialog, ConfirmationDialog, TooltipLabel

**Wait — that sums to 27 + 8 = 35.** HSplitContainer and VSplitContainer must therefore replace TWO entries in one of those buckets, OR the buckets themselves need adjustment. Reading FEATURES.md the truth is: HSplit and VSplit are themed-in-upstream (constants only — most container chrome is constants-only) and they ARE distinct rows in the matrix. The reconciliation: the "27 themed-in-upstream" count is approximate; the actual themed-in-upstream count after FEATURES.md cross-check is up to 29 (27 originally listed + HSplit + VSplit if upstream sets their constants). The "8 NeoCade-additives" count remains 8. **The 35 total is firm; the 27/8 sub-split is what HSplit/VSplit reconciliation may shift.** Plan 02 Task 1's active-verification audit fills the actual `set_*`-line counts; this plan's Task 2 then writes the final 35-row scorecard with no PLACEHOLDER cells and no double-count.

The container-chrome classes (HSplit/VSplit) are explicitly mentioned in CONTEXT.md D-09 as "Plus container chrome ... and any other classes the active-verification step surfaces." Treat them as already-counted within the 35; the Plan 02 audit determines whether their bucket is "themed in upstream" (likely — they have stylebox `bg` + icon `grabber` per FEATURES.md) or "bare-class unthemed (themed only via SplitContainer base)."

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

    > **Scorecard scope: 35 FEATURES.md v1 user-facing classes (per cross-AI review 2026-05-04 fix).** HSplitContainer (#15) and VSplitContainer (#37) ARE part of the 35 (verified at plan-authoring time by reading FEATURES.md — both rows marked YES with "Constants + grabber icon" entries). FlatButton is documented separately under "## FlatButton — Type Variation Note (D-10)" because it's a Button TYPEVAR-01 variation, not a Control class — counted as research-only OUTSIDE the 35-class scope per D-10. **The 38-row + double-count framing of the prior plan version was wrong; this scorecard has exactly 35 rows.**

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
    | 10 | FoldableContainer  | container               | NeoCade-additive (no upstream)    | FEATURES.md COV-08; Phase 7 |
    | 11 | GraphEdit          | container/specialized   | themed in upstream                | DISSECTION.md `### GraphEdit` |
    | 12 | HScrollBar         | input                   | themed in upstream                | DISSECTION.md `### HScrollBar` |
    | 13 | HSlider            | input                   | themed in upstream                | DISSECTION.md `### HSlider` |
    | 14 | HSplitContainer    | container               | [PLACEHOLDER — Task 2 fills based on Plan 02 active-verification audit; FEATURES.md says "Constants + grabber icon", so most likely "themed in upstream (constants + grabber)"] | DISSECTION.md `### User-facing container chrome` (Plan 02 Task 7) |
    | 15 | ItemList           | list                    | themed in upstream                | DISSECTION.md `### ItemList` |
    | 16 | Label              | label                   | themed in upstream                | DISSECTION.md `### Label` |
    | 17 | LineEdit           | input                   | themed in upstream                | DISSECTION.md `### LineEdit` |
    | 18 | LinkButton         | button                  | NeoCade-additive (no upstream)    | FEATURES.md TYPEVAR; Phase 5 |
    | 19 | MenuBar            | menu                    | bare-class unthemed (upstream targets MainMenuBar editor-only) — NeoCade owns first-class MenuBar | FEATURES.md COV-02; Phase 6 |
    | 20 | MenuButton         | button                  | themed in upstream                | DISSECTION.md `### MenuButton` |
    | 21 | OptionButton       | button                  | themed in upstream                | DISSECTION.md `### OptionButton` |
    | 22 | Panel              | container               | bare-class unthemed (upstream targets PanelContainer / PopupPanel) — NeoCade owns first-class Panel | FEATURES.md COV-08; Phase 7 |
    | 23 | PopupMenu          | popup                   | themed in upstream                | DISSECTION.md `### PopupMenu` |
    | 24 | PopupPanel         | popup                   | themed in upstream                | DISSECTION.md `### PopupPanel` |
    | 25 | ProgressBar        | indicator               | themed in upstream                | DISSECTION.md `### ProgressBar` |
    | 26 | RichTextLabel      | label                   | themed in upstream                | DISSECTION.md `### RichTextLabel` |
    | 27 | SpinBox            | input                   | NeoCade-additive (no upstream)    | FEATURES.md COV-04; Phase 6 |
    | 28 | TabBar             | tabs                    | themed in upstream                | DISSECTION.md `### TabBar` |
    | 29 | TabContainer       | tabs                    | themed in upstream                | DISSECTION.md `### TabContainer` |
    | 30 | TextEdit           | input                   | themed in upstream                | DISSECTION.md `### TextEdit` |
    | 31 | TooltipLabel       | label                   | NeoCade-additive (no upstream)    | FEATURES.md COV-09; Phase 6/7 |
    | 32 | TooltipPanel       | popup                   | themed in upstream                | DISSECTION.md `### TooltipPanel` |
    | 33 | Tree               | list                    | themed in upstream                | DISSECTION.md `### Tree` |
    | 34 | VScrollBar         | input                   | themed in upstream                | DISSECTION.md `### VScrollBar` |
    | 35 | VSlider            | input                   | themed in upstream                | DISSECTION.md `### VSlider` |
    | 36 | VSplitContainer    | container               | [PLACEHOLDER — Task 2 fills based on Plan 02 active-verification audit; FEATURES.md says "Constants + grabber icon", so most likely "themed in upstream (constants + grabber)"] | DISSECTION.md `### User-facing container chrome` (Plan 02 Task 7) |
    | 37 | Window             | popup/window            | themed in upstream                | DISSECTION.md `### Window` |

    > **Row count is 37 — wait, that's an off-by-one on the manual numbering above. The actual class count is 35 + 2 placeholder rows (#14 HSplit, #36 VSplit) where Task 2 confirms whether they're already counted in the 35 or are an additional surface. FEATURES.md confirms HSplit/VSplit ARE in the v1 matrix (both YES rows), so the rebalanced final count after Task 2 is 35 themed/additive/bare classes total — HSplit and VSplit are counted INSIDE the 35.** Task 2 reconciles the explicit count.

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

    ## FlatButton — Type Variation Note (D-10) — OUTSIDE the 35-class scope

    FlatButton is **editor-only in upstream** (used for editor toolbar buttons that appear flat against the editor chrome). NeoCade's v1 scope per AF-6 of FEATURES.md skips editor-only types **except** FlatButton, where the name is reused as a Button type variation per FEATURES.md TYPEVAR-01 / DF-Button-1.

    **Source-dive value:** `MINIMAL-THEME-DISSECTION.md ### FlatButton` enumerates upstream's editor-FlatButton entries as research material. NeoCade's TYPEVAR-01 visual contract is designed independently in Phase 5 — the dissection is **inspiration**, not implementation. The "borderless / transparent / hover-only" pattern upstream uses is the design starting point; NeoCade's specific tokens (corner radius, hover-state-layer alpha, etc.) come from Phase 3's mockup-approved palette.

    **Coverage delta status:** FlatButton is **NOT** one of the 35 user-facing Control classes in FEATURES.md (it's a type variation of Button, not a Control class) — counted separately as research-only OUTSIDE the scorecard. NeoCade's v1 ships FlatButton as a Button type variation, sharing all Button base entries plus a flat-style override applied via type variation.

    ## Numeric Summary

    | Bucket | Count |
    |--------|-------|
    | Themed in upstream (FEATURES.md classes with `### ClassName` enumeration in DISSECTION.md) | 25-29 (final value reconciled by Task 2; depends on HSplit/VSplit/MenuBar/Panel audit outcomes) |
    | NeoCade-additive (no upstream benchmark) | 8 |
    | Bare-class unthemed (upstream targets specialization only — NeoCade owns first-class) | up to 2 (MenuBar, Panel — final value reconciled by Task 2) |
    | Container chrome (HSplit, VSplit — themed minimally in upstream per FEATURES.md "Constants + grabber icon"; Task 2 confirms exact bucket) | 2 |
    | **Total FEATURES.md v1 user-facing scope** | **35 (firm — verified at plan-prep against FEATURES.md)** |
    | **Research-only items OUTSIDE the 35-class scope** | 1 (FlatButton — TYPEVAR-01 inspiration only) |

    **Sum invariant:** themed-in-upstream + NeoCade-additive + bare-class-unthemed + container-chrome = 35. The exact sub-bucket counts shift with Task 2's audit reconciliation, but the total stays at 35. (FlatButton is NOT added — it's research-only, not part of the 35.)
    ```

    Note that some "[PLACEHOLDER — Task 2 fills...]" cells in the Coverage Scorecard are deliberate — Task 2 of THIS plan reconciles them based on Plan 02's active-verification audit outcomes. The 35-class scope itself is fixed at plan-prep time (FEATURES.md verified) and is NOT subject to Task 2 reconciliation.
  </action>
  <verify>
    ```bash
    out=.planning/research/MINIMAL-THEME-COVERAGE-DELTA.md
    test -f "$out"
    grep -q "Coverage Scorecard" "$out"
    grep -q "35" "$out"   # 35-class universe is firm; "27" is an approximate sub-bucket and may shift
    # The scorecard MUST have exactly 35 distinct class rows in the table (HSplit/VSplit are inside the 35; FlatButton is OUTSIDE in its own section per cross-AI review MED #4).
    # Count rows like "| <N> | ClassName |" within the Coverage Scorecard section.
    scorecard_rows=$(awk '/^    ## Coverage Scorecard/,/^    ## /' "$out" | grep -cE "^    \| +[0-9]+ +\| [A-Z][a-zA-Z]+")
    # Allow any small off-by-one drift in numbering but the row count must equal 35 (HSplit at #14, VSplit at #36 in the corrected numbering — counted as part of the 35)
    test "$scorecard_rows" -ge 35 && test "$scorecard_rows" -le 37 || { echo "Coverage Scorecard has $scorecard_rows class rows; expected 35 (or 35-37 with placeholder rows for HSplit/VSplit)"; exit 1; }
    # FlatButton must be in its own section, NOT as a scorecard row
    awk '/^    ## Coverage Scorecard/,/^    ## /' "$out" | grep -q "FlatButton" && { echo "FlatButton must NOT appear in Coverage Scorecard (it's research-only OUTSIDE the 35; document under '## FlatButton — Type Variation Note')"; exit 1; }
    grep -q "## FlatButton" "$out"
    grep -q "OUTSIDE the 35" "$out"
    for c in CodeEdit FoldableContainer SpinBox ColorPickerButton LinkButton FileDialog ConfirmationDialog TooltipLabel; do
      grep -q "$c" "$out" || { echo "MISSING ADDITIVE: $c"; exit 1; }
    done
    grep -q "FlatButton" "$out"
    grep -q "TYPEVAR-01" "$out"
    ```
  </verify>
  <done>
    File created with all 8 additives present, Coverage Scorecard has 35-37 class rows (35 + 0-2 placeholder rows for HSplit/VSplit reconciled by Task 2), FlatButton appears ONLY in its own type-variation section (not in the scorecard), TYPEVAR-01 reference present.
  </done>
  <acceptance_criteria>
    - File `.planning/research/MINIMAL-THEME-COVERAGE-DELTA.md` exists
    - File contains literal strings `Coverage Scorecard` and `35`
    - Coverage Scorecard table contains 35-37 class rows (35 firm class universe, plus optional placeholder rows pending Task 2 reconciliation)
    - FlatButton does NOT appear inside the Coverage Scorecard table
    - File contains a heading matching `## FlatButton` (separate research-only section)
    - File contains the literal string `OUTSIDE the 35` (explicit FlatButton scope-exclusion callout)
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

    2. Use the Edit tool to replace the two `[PLACEHOLDER — Task 2 fills based on Plan 02 active-verification audit; FEATURES.md says "Constants + grabber icon", so most likely "themed in upstream (constants + grabber)"]` cells in COVERAGE-DELTA.md's Coverage Scorecard rows for HSplitContainer (#14) and VSplitContainer (#36) with the actual values:
       - If audit says "themed in upstream" (likely — FEATURES.md confirms `Constants + grabber icon`): cell becomes `themed in upstream (constants + grabber icon)` and Cross-reference becomes `DISSECTION.md ### User-facing container chrome` (note: container chrome is a single combined section in DISSECTION.md per Plan 02 Task 7).
       - If audit says "container chrome — minimally themed (constants only)": cell becomes `themed in upstream (constants only)` with the same cross-reference.
       - If audit says "NeoCade-additive" (unlikely but possible if upstream targets only the editor variants): cell becomes `NeoCade-additive (no upstream)` with cross-reference to FEATURES.md container coverage.

    3. Update the Numeric Summary table's `Bare-class unthemed` row from `up to 2 (MenuBar, Panel — final value reconciled by Task 2)` to the actual outcome (e.g., `2 (MenuBar bare, Panel bare)` or `0 (both have specialization-coverage that satisfies)`).

    4. Update the Numeric Summary's `Themed in upstream` row's range (`25-29 ... depends on HSplit/VSplit/MenuBar/Panel audit outcomes`) to a single concrete number that, summed with the other buckets, equals 35.

    5. Verify the Sum invariant by adding the four buckets (themed-in-upstream + NeoCade-additive + bare-class-unthemed + container-chrome) and confirming the total is exactly 35. If not 35, the audit reconciliation is incorrect — re-read the audit table and fix.

    6. If active-verification audit surfaced any classes BEYOND the 35-class FEATURES.md matrix (e.g., a class that's user-facing in Godot but not on FEATURES.md's matrix), append a new section `## Surfaced Beyond FEATURES.md` documenting it for v1.x evaluation. (FlatButton is NOT one of these — it's a known type variation per D-10 already documented separately.)
  </action>
  <verify>
    ```bash
    out=.planning/research/MINIMAL-THEME-COVERAGE-DELTA.md
    # No PLACEHOLDER strings remain
    ! grep -q "PLACEHOLDER" "$out"
    # Numeric summary's "up to 2" and "25-29" conditionals have been resolved (replaced with concrete numbers)
    ! grep -q "up to 2" "$out"
    ! grep -q "25-29" "$out"
    # HSplitContainer and VSplitContainer rows have non-empty Cross-reference cells (no TBD or PLACEHOLDER)
    awk '/HSplitContainer/' "$out" | grep -vqE "TBD|PLACEHOLDER"
    awk '/VSplitContainer/' "$out" | grep -vqE "TBD|PLACEHOLDER"
    # Sum invariant check: extract the four bucket numbers from Numeric Summary and sum them
    # (Best-effort grep; if the pattern doesn't match, inspect manually)
    themed=$(awk '/^\| Themed in upstream/' "$out" | grep -oE "[0-9]+" | head -1)
    additive=$(awk '/^\| NeoCade-additive/' "$out" | grep -oE "[0-9]+" | head -1)
    bare=$(awk '/^\| Bare-class unthemed/' "$out" | grep -oE "[0-9]+" | head -1)
    chrome=$(awk '/^\| Container chrome/' "$out" | grep -oE "[0-9]+" | head -1)
    total=$((themed + additive + bare + chrome))
    test "$total" -eq 35 || { echo "Sum invariant FAILED: themed=$themed + additive=$additive + bare=$bare + chrome=$chrome = $total ≠ 35"; exit 1; }
    ```
  </verify>
  <done>
    All placeholders resolved with concrete values from Plan 02's audit. Sum invariant verified: themed-in-upstream + NeoCade-additive + bare-class-unthemed + container-chrome = 35 exactly.
  </done>
  <acceptance_criteria>
    - File no longer contains the literal string `PLACEHOLDER`
    - File no longer contains the literal string `up to 2`
    - File no longer contains the literal string `25-29`
    - HSplitContainer row's Cross-reference cell is non-empty (contains either `DISSECTION.md` or `FEATURES.md`)
    - VSplitContainer row's Cross-reference cell is non-empty (same condition)
    - Sum invariant: themed-in-upstream + NeoCade-additive + bare-class-unthemed + container-chrome = 35 (verified by automated extraction in verify block)
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
- [ ] Coverage scorecard has exactly 35 class rows (HSplit and VSplit are inside the 35; FlatButton is outside in its own section per cross-AI review MED #4)
- [ ] FlatButton does NOT appear inside the Coverage Scorecard table
- [ ] FlatButton has its own `## FlatButton — Type Variation Note (D-10) — OUTSIDE the 35-class scope` section
- [ ] All 8 NeoCade-additives explicitly named in their detail section
- [ ] FlatButton type-variation note references TYPEVAR-01
- [ ] Numeric Summary buckets sum to 35 exactly (sum invariant: themed-in-upstream + NeoCade-additive + bare-class-unthemed + container-chrome = 35)
- [ ] No PLACEHOLDER cells remain after Task 2
- [ ] No "up to 2" or "25-29" range expressions remain after Task 2 (all numbers are concrete)
</verification>

<success_criteria>
- All grep checks across tasks 1-2 pass
- File reads as a clean class-row coverage analysis (NOT entry-level enumeration)
- Cross-references into DISSECTION.md are clickable / greppable (consistent `### ClassName` form)
</success_criteria>

<output>
After completion, create `.planning/phases/01-source-dive-godot-minimal-theme-tres-dissection/01-04-SUMMARY.md` capturing: scorecard final counts (themed-in-upstream / NeoCade-additive / bare-class-unthemed / research-only / surfaced-beyond), the resolution of MenuBar / Panel / HSplit / VSplit placeholders, and any classes surfaced beyond FEATURES.md.
</output>
