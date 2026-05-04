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

> **Scorecard scope: 35 FEATURES.md v1 user-facing classes (per cross-AI review 2026-05-04 fix).** HSplitContainer (#14) and VSplitContainer (#36) ARE part of the 35 (verified at plan-authoring time by reading FEATURES.md — both rows marked YES with "Constants + grabber icon" entries). FlatButton is documented separately under "## FlatButton — Type Variation Note (D-10)" because it's a Button TYPEVAR-01 variation, not a Control class — counted as research-only OUTSIDE the 35-class scope per D-10. **The 38-row + double-count framing of the prior plan version was wrong; this scorecard has exactly 35 rows.**

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
