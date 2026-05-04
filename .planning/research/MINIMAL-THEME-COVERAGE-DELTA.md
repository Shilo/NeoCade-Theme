# godot-minimal-theme — Coverage Delta vs FEATURES.md User-Facing Class Matrix

**Authored:** 2026-05-04
**Status:** Living research artifact — feeds Phase 4 generator (TokenSet structure decisions) and Phase 10 COV-10 verification.

> **For NeoCade's actual visual design (palette / typography / state-layer model / focus-ring strategy), this doc is NOT the source of truth.** Visual design lives in `.planning/research/ARCHITECTURE.md` (3 candidate palettes, M3 type scale, M3 state-layer model, mockup approval workflow) and crystallizes in `.planning/DESIGN_TOKENS.md` (created by Phase 3 mockup-approval gate, consumed by Phase 4 `@tool` generator). Phase 1 enumerates upstream's *coverage axis* — what classes/slots/states must be themed; not what NeoCade should look like.

**Cross-references:**
- `.planning/research/MINIMAL-THEME-DISSECTION.md` — descriptive enumeration of every entry upstream populates per Control × per state × per slot.
- `.planning/research/FEATURES.md` — FEATURES.md user-facing Control matrix (informally cited as "35 classes" in the executive summary header — see "Scope reconciliation note" below; the 37-row scorecard is this doc's authoritative count).
- `.planning/research/ARCHITECTURE.md` §1 (palette proposals A/B/C with WCAG-verified hex), §2-3 (typography + M3 type scale), §5 (M3 state-layer model), §6 (mockup approval workflow) — **NeoCade's visual design source of truth** (not this doc).
- `.planning/research/SOURCES.md` Section 1 (godot-minimal-theme) — synthesis pattern (`What was read / adopted / rejected / still open`); this delta doc is one of the artifacts SOURCES.md links to (cross-linked by Plan 05).

## Methodology

Each user-facing Control identified in Plan 01-02's `set_*` audit (37 state-rich classes after reconciliation against FEATURES.md's user-facing scope) is classified into one of:
- **Themed in upstream** — at least one `set_*` call targets the class in `minimal_theme.tres`. NeoCade has an upstream benchmark; coverage delta says "feature-complete to upstream's bar" for this class.
- **Bare-class unthemed (themed via specialization)** — upstream themes a more specialized class name (e.g., `MainMenuBar` instead of bare `MenuBar`). NeoCade-additive for the bare class — first-class theming required because the engine doesn't auto-cascade from the specialized name to the bare class.
- **NeoCade-additive** — no upstream entries; NeoCade owns the design (no benchmark exists).

Every "themed in upstream" row links into `MINIMAL-THEME-DISSECTION.md`'s `### ClassName` section. NeoCade-additive rows link to FEATURES.md or to the relevant Phase 5 type-variation decision.

## Coverage Scorecard

> **Scorecard scope: 37 numbered rows covering the state-rich Controls that need per-class theming attention** (24 directly themed in upstream + 1 Window-via-subclass + 2 bare-class unthemed + 2 container-chrome constants-only + 8 NeoCade-additive). Per-row classification details and bucket reconciliation in the [Numeric Summary](#numeric-summary) below. FlatButton is documented separately under "## FlatButton — Type Variation Note (D-10)" because it's a Button TYPEVAR-01 variation, not a Control class — counted as research-only OUTSIDE the scorecard per D-10.
>
> **Scope reconciliation note (added 2026-05-04 post-verification):** Earlier versions of this doc claimed "35 firm" rows matching FEATURES.md's "35 classes" header. That claim was inherited from FEATURES.md's executive summary, but FEATURES.md's own YES-marked rows total ~52 — the "35" was never a clean enumeration. This scorecard has 37 rows reflecting the actual Phase 1 audit findings. The 9 FEATURES.md YES-marked classes that don't appear here (HBoxContainer, VBoxContainer, FlowContainer + specializations, GridContainer, MarginContainer, PanelContainer, ScrollContainer, HSeparator, VSeparator) are constants-only or aggregate-by-base classes folded into Phase 7 container-chrome work (see "Surfaced Beyond FEATURES.md" footer + DISSECTION.md `### User-facing container chrome` section). Phase 10 COV-10 should diff against this 37-row scorecard, not against the FEATURES.md "35" header.

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
| 14 | HSplitContainer    | container               | themed in upstream (container chrome — constants only: `autohide`, `minimum_grab_thickness`, `separation`; 3 set_* at lines 552-554) | DISSECTION.md `### User-facing container chrome` |
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
| 36 | VSplitContainer    | container               | themed in upstream (container chrome — constants only: `autohide`, `minimum_grab_thickness`, `separation`; 3 set_* at lines 556-558) | DISSECTION.md `### User-facing container chrome` |
| 37 | Window             | popup/window            | themed in upstream (via subclass coverage — bare `Window` has zero `set_*` per Plan 02 audit, but `AcceptDialog`/`PopupPanel`/`PopupMenu`/`TooltipPanel` Window subclasses all themed; Godot's Theme system effectively styles Window through its subclass surface) | DISSECTION.md `### Window` |

> **Row-count reconciliation:** The scorecard table contains 37 numbered rows — one per state-rich Control identified by the Plan 02 `set_*` audit. The Numeric Summary below sums to exactly 37 row entries: 24 directly-themed + 1 themed-via-subclass-only (Window) + 2 bare-class-unthemed (MenuBar, Panel) + 2 container-chrome-constants-only (HSplit, VSplit) + 8 NeoCade-additive = 37. **Sum invariant (corrected):** `24 + 1 + 2 + 2 + 8 = 37`. Earlier "23 + 8 + 2 + 2 = 35" framing was off-by-one (Window double-handled — both excluded from the "23" count and listed as a scorecard row in the same bucket); see Numeric Summary's reconciliation note for the full correction history.

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

| Bucket | Count | Members |
|--------|------:|---------|
| **Themed in upstream — direct entries** | 24 | AcceptDialog, Button, CheckBox, CheckButton, ColorPicker, GraphEdit, HScrollBar, HSlider, ItemList, Label, LineEdit, MenuButton, OptionButton, PopupMenu, PopupPanel, ProgressBar, RichTextLabel, TabBar, TabContainer, TextEdit, TooltipPanel, Tree, VScrollBar, VSlider |
| **Themed in upstream — via subclass surface only** | 1 | Window (bare class has zero `set_*`; AcceptDialog/PopupPanel/PopupMenu/TooltipPanel subclasses themed) |
| **Bare-class unthemed (NeoCade owns first-class)** | 2 | MenuBar (upstream targets MainMenuBar editor variation only), Panel (upstream targets PanelContainer / PopupPanel only) |
| **Container chrome (constants only in upstream)** | 2 | HSplitContainer, VSplitContainer |
| **NeoCade-additive (no upstream benchmark)** | 8 | CodeEdit, ColorPickerButton, ConfirmationDialog, FileDialog, FoldableContainer, LinkButton, SpinBox, TooltipLabel |
| **Total scorecard rows** | **37** | |
| | | |
| **Research-only items OUTSIDE the scorecard** | 1 | FlatButton — Button TYPEVAR-01 inspiration; type variation, not a Control class |

**Sum invariant (corrected):** `direct (24) + subclass-only (1: Window) + bare-class-unthemed (2: MenuBar, Panel) + container-chrome (2) + NeoCade-additive (8) = 37 row entries`.

> **Note on the "35" claim** (correction to prior versions of this doc):
> The "35-class v1 user-facing scope" phrase comes from FEATURES.md's executive summary line *"NeoCade v1 styles all that have theme entries (35 classes — content-only Controls like NinePatchRect have none)"* — but FEATURES.md's own Category-A-through-H YES-marked rows total ~52 classes, so 35 was never a clean enumeration. This scorecard's 37 rows are the actual classes Phase 1 identified as needing per-class theming attention; the 9 additional FEATURES.md YES-marked classes (HBoxContainer, VBoxContainer, FlowContainer + flow specializations, GridContainer, MarginContainer, PanelContainer, ScrollContainer, HSeparator, VSeparator — see "Surfaced Beyond FEATURES.md" below) are constants-only or aggregate-by-base classes folded into Phase 7 container-chrome work via the consolidated DISSECTION.md `### User-facing container chrome` section. The "35" figure should be treated as informal until FEATURES.md is reconciled. **Phase 10 COV-10 verification should diff against this 37-row scorecard, not against FEATURES.md's "35" header claim.**

## Surfaced Beyond FEATURES.md

Plan 02's Active Verification Audit (`MINIMAL-THEME-DISSECTION.md ### Active Verification Audit`) surveyed every `set_*` invocation in `minimal_theme.tres` and grouped each target name into a bucket. Beyond the 35-class FEATURES.md universe, the audit surfaced these additional classes that upstream targets but are NOT user-facing v1 scope:

- **34 editor-only types** (AnimationBezierTrackEdit, AnimationTimelineEdit, AnimationTrackEdit, AnimationTrackEditGroup, AssetLib, BottomPanelButton, Editor, EditorAbout, EditorAudioBus, EditorDebuggerInspector, EditorHelpBitContent, EditorHelpBitTitle, EditorInspector, EditorInspectorCategory, EditorInspectorSection, EditorLogFilterButton, EditorProperty, EditorSettingsDialog, EditorSpinSlider, EditorStyles, EditorValidationPanel, GraphStateMachine, InspectorActionButton, MainMenuBar, MainScreenButton, PopupDialog, ProjectExportDialog, ProjectManager, ProjectSettingsEditor, RunBarButton, RunBarButtonMovieMakerDisabled, RunBarButtonMovieMakerEnabled, SceneImportSettingsDialog, ThemeItemEditorDialog) — explicitly skipped per D-10. Out of NeoCade v1 scope.
- **8 EditorStyles slot-names (not classes)** (Background, ContextualToolbar, FocusViewport, LaunchPadMovieMode, LaunchPadNormal, MovieWriterButtonPressed, ThemeEditorPreviewBG, ThemeEditorPreviewFG) — slot-names within EditorStyles, not Control classes. Out of NeoCade v1 scope.
- **9 container-chrome classes** beyond HSplit/VSplit themselves (HBoxContainer, VBoxContainer, PanelContainer, ScrollContainer, SplitContainer, HSeparator, VSeparator) — these ARE user-facing in FEATURES.md (rows 24-35 of FEATURES.md table), but were not enumerated as scorecard rows here because they share the consolidated `### User-facing container chrome` DISSECTION.md section and don't have per-class state matrices. Phase 7 styles them as part of container chrome.

The `### User-facing container chrome` consolidation in DISSECTION.md is a documentation pattern (one section, multiple classes) — NOT a coverage gap. NeoCade Phase 7's container styling closes all 9 chrome classes via shared constants/styleboxes, so v1 ships with the 37 scorecard rows + 9 additional container/separator chrome classes = 46 user-facing classes themed in total (37 explicit scorecard rows + 9 chrome classes covered by Phase 7's consolidated work). The scorecard's 37 rows are the **state-rich Controls** that need per-class theming attention; the +9 chrome classes are constants-only / aggregate-by-base and don't require independent coverage analysis here. The earlier "35 + 9 = 44" framing in prior versions of this doc was based on FEATURES.md's informal "35 classes" header which doesn't match its own row count — see Numeric Summary's reconciliation note above.
