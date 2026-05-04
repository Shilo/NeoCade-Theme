---
phase: 01-source-dive-godot-minimal-theme-tres-dissection
plan: 02
type: execute
wave: 1
depends_on:
  - 01
files_modified:
  - .planning/research/MINIMAL-THEME-DISSECTION.md
autonomous: true
requirements:
  - RES-01
must_haves:
  truths:
    - "Every one of the 27 user-facing Controls listed in CONTEXT.md D-08 has its own `### ClassName` section in the Per-Control Enumeration block of MINIMAL-THEME-DISSECTION.md"
    - "FlatButton has its own `### FlatButton` section (research-only per D-10)"
    - "Each `### ClassName` section enumerates every `set_*` call upstream makes targeting that class — exhaustively, no `and similar` shortcuts (D-07)"
    - "Each entry row carries: slot kind (stylebox/color/font/font_size/icon/constant), state suffix, symbolic formula, snapshot @ defaults, source line(s) into minimal_theme.tres"
    - "Active-verification step records the 80-class audit (per D-08) — every grep-discovered class target is classified as user-facing (enumerated), editor-only (skipped per D-10), type-variation (noted), or NeoCade-additive (deferred to Plan 04)"
  artifacts:
    - .planning/research/MINIMAL-THEME-DISSECTION.md (per-Control section appended; file already exists from Plan 01)
  key_links:
    - "Each enumerated class's source-line citations resolve to actual `set_*` lines in minimal_theme.tres"
    - "Globals/helper references in enumeration rows match names defined in Plan 01's Globals/Helper Functions sections (no orphaned references)"
    - "Active-verification audit list is exhaustive (every output of the D-08 verification grep is accounted for)"
---

<objective>
Append the per-Control × per-state × per-entry exhaustive enumeration to `.planning/research/MINIMAL-THEME-DISSECTION.md` (under the `## Per-Control Enumeration` placeholder created by Plan 01). For each of the 27 user-facing Controls in CONTEXT.md D-08 (plus FlatButton per D-10), produce one `### ClassName` section containing (a) a one-line "what this Control is" gloss, (b) a flat enumeration table with one row per (entry, state) pair, (c) a brief notes paragraph for any per-class quirks (e.g., upstream's TabBar font_outline_size is set vs left default).

Purpose: Discharge the bulk of RES-01. Every claim NeoCade makes about "feature-complete to godot-minimal-theme's bar" must be verifiable from this enumeration. Phase 4's `@tool` token-generator uses these tables as the input format for "what entries does each Control need?". Phase 10's COV-10 diff-checks against this enumeration to verify zero engine-default fallback for any Control upstream themes.

Output: ~27 + 1 = 28 `### ClassName` sections appended under `## Per-Control Enumeration` in MINIMAL-THEME-DISSECTION.md, plus an "## Active Verification Audit" subsection at the end of the per-Control block recording the 80-class classification.
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
@.planning/phases/01-source-dive-godot-minimal-theme-tres-dissection/01-01-dissection-skeleton-PLAN.md (sibling plan — globals + helpers section names this plan references)
@.planning/research/FEATURES.md (35-class matrix for class-name authority)

<interfaces>
<!-- Source file is the dissection target -->
<!-- /c/Programming_Files/Godot/godot-minimal-theme-main/minimal_theme.tres (1118 lines) -->

The 27 user-facing Controls per CONTEXT.md D-08, in alphabetical order:
1. AcceptDialog
2. Button
3. CheckBox
4. CheckButton
5. ColorPicker
6. GraphEdit
7. HScrollBar
8. HSlider
9. ItemList
10. Label
11. LineEdit
12. MenuBar
13. MenuButton
14. OptionButton
15. Panel
16. PopupMenu
17. PopupPanel
18. ProgressBar
19. RichTextLabel
20. TabBar
21. TabContainer
22. TextEdit
23. TooltipPanel
24. Tree
25. VScrollBar
26. VSlider
27. Window

Plus FlatButton (28th, research-only per D-10).

Per-class set_* discovery command (executor uses for each class):
```bash
grep -nE "set_(stylebox|color|font|icon|constant|font_size)\([^,]+, '<ClassName>'" \
  /c/Programming_Files/Godot/godot-minimal-theme-main/minimal_theme.tres
```

Active-verification (D-08) audit command — list ALL unique class targets in the file:
```bash
cd /c/Programming_Files/Godot/godot-minimal-theme-main && \
  grep -oE "set_(stylebox|color|font|icon|constant|font_size)\([^,]+, '[A-Z][a-zA-Z]+'" \
  minimal_theme.tres | grep -oE "'[A-Z][a-zA-Z]+'" | sort -u | tr -d "'"
```

Expected output (already verified in RESEARCH.md, 80 unique classes; classify each):
- USER-FACING (enumerate): AcceptDialog, Button, CheckBox, CheckButton, ColorPicker, GraphEdit, HScrollBar, HSlider, ItemList, Label, LineEdit, MenuBar (NOTE: D-08 list includes "MenuBar" but the grep surfaces "MainMenuBar" — see active-verification step), MenuButton, OptionButton, Panel (NOTE: D-08 list includes "Panel" but the grep surfaces "PanelContainer" / "PopupPanel" — see active-verification step), PopupMenu, PopupPanel, ProgressBar, RichTextLabel, TabBar, TabContainer, TextEdit, TooltipPanel, Tree, VScrollBar, VSlider, Window
- TYPE-VARIATIONS to mention in per-class notes (these are user-facing but specialize a base): TabContainerOdd, ItemListSecondary, TreeSecondary, FlatMenuButton
- RESEARCH-ONLY (D-10 exception): FlatButton
- EDITOR-ONLY (skip per D-10, but classify in audit list): MainScreenButton, BottomPanelButton, EditorAbout, EditorAudioBus, EditorDebuggerInspector, EditorHelpBitContent, EditorHelpBitTitle, EditorInspector, EditorInspectorCategory, EditorInspectorSection, EditorLogFilterButton, EditorProperty, EditorSettingsDialog, EditorSpinSlider, EditorStyles, EditorValidationPanel, RunBarButton, RunBarButtonMovieMakerDisabled, RunBarButtonMovieMakerEnabled, MovieWriterButtonPressed, ContextualToolbar, FocusViewport, GraphStateMachine, InspectorActionButton, LaunchPadMovieMode, LaunchPadNormal, ProjectExportDialog, ProjectManager, ProjectSettingsEditor, SceneImportSettingsDialog, ThemeEditorPreviewBG, ThemeEditorPreviewFG, ThemeItemEditorDialog, AnimationBezierTrackEdit, AnimationTimelineEdit, AnimationTrackEdit, AnimationTrackEditGroup, AssetLib, Background, Editor, MainMenuBar (treat as MenuBar's editor counterpart — see audit), PopupDialog
- USER-FACING-CONTAINER-CHROME (audit verifies; lightweight enumeration): HBoxContainer, VBoxContainer, PanelContainer, ScrollContainer, SplitContainer, HSplitContainer, VSplitContainer, HSeparator, VSeparator (likely just constants like h_separation; some may have only stylebox `panel`)

NOTE on D-08 vs grep audit:
The D-08 list says "MenuBar" but the grep surfaces "MainMenuBar" (editor-only) — there may be NO upstream theme entries for the bare `MenuBar` class. Active-verification audit must surface this fact and classify it. Same dynamic for "Panel": surfaced as "PanelContainer" / "PopupPanel" but bare "Panel" may be unthemed. If a D-08 class has zero `set_*` calls in upstream, document it as "themed via inheritance only" or "unthemed in upstream — NeoCade owns first-class theming."

Per-class table format (use uniformly across all classes):

```markdown
### ClassName
**Gloss:** [one-sentence what this Control is for, drawn from godot-master Control class docstring or common knowledge]

**Upstream entry count:** N total set_* calls (X stylebox, Y color, Z font/font_size, W icon, V constant)

| Slot Kind | Slot Name | State | Formula (symbolic) | Snapshot @ defaults | Source line(s) |
|-----------|-----------|-------|--------------------|---------------------|----------------|
| stylebox  | normal    | normal | StyleBoxFlat with bg=color_surface_base, corner_radius_all=corner_radius (≈4 default), `_set_border(sb, color_mono*Color(1,1,1,0.1), 1, draw_extra_borders)`, `_set_margin(sb, base_margin*2, base_margin)` | [@base_color=#272727, contrast=0.325, corner_radius=4]: bg≈Color(0.169,0.169,0.169,1), corner_radius=4, border=Color(1,1,1,0.1) width 1 | 256 (set), 81 (color def), 1096-1103 (_get_base_color), 1104-1110 (_set_margin), 1111-1118 (_set_border) |
| color     | font_color | normal | color_font_normal | Color(1,1,1,0.7) | 256 (set), 81 (def) |
| ...

**Per-class notes:** [Anything unusual — e.g., "upstream sets `font_outline_color` but NOT `font_outline_size`; engine renders no outline as a result", or "this Control is themed only via its `Panel` parent stylebox; no own entries", or "type variation TabContainerOdd specializes the `panel` stylebox at line NNN"]
```

The "Snapshot @ defaults" column uses upstream README defaults (`base_color=#272727`, `accent_color=#569eff`, `contrast=0.325`, `corner_radius=4`) — paste an honest evaluation, not a placeholder. For values that depend on `dark_theme` (true at this snapshot) or `dark_theme_icon_and_font` (true since `icon_and_font_color=AUTO` and `dark_theme=true`), pick the dark-branch value.
</interfaces>
</context>

<tasks>

<task type="auto">
  <name>Task 1: Active-verification audit — list all 80 unique class targets and classify each</name>
  <read_first>
    - /c/Programming_Files/Godot/godot-minimal-theme-main/minimal_theme.tres (full file, since the audit must be exhaustive)
    - .planning/phases/01-source-dive-godot-minimal-theme-tres-dissection/01-CONTEXT.md (D-08 27-class list, D-10 editor-only skip rule + FlatButton exception)
    - .planning/research/FEATURES.md (35-class matrix — class names authoritative)
  </read_first>
  <files>.planning/research/MINIMAL-THEME-DISSECTION.md (append to "## Per-Control Enumeration" section)</files>
  <action>
    Run the audit grep:
    ```bash
    cd /c/Programming_Files/Godot/godot-minimal-theme-main && \
      grep -oE "set_(stylebox|color|font|icon|constant|font_size)\([^,]+, '[A-Z][a-zA-Z]+'" \
      minimal_theme.tres | grep -oE "'[A-Z][a-zA-Z]+'" | sort -u | tr -d "'"
    ```

    The output should be the 80-class list catalogued in `<interfaces>` above (verify match; if different, the plan halts and the audit list is regenerated). Classify each into one of four buckets and write a section like this immediately under the `## Per-Control Enumeration` placeholder heading (before any `### ClassName` sections):

    ```markdown
    ## Per-Control Enumeration

    > **Active Verification Audit (per CONTEXT.md D-08).** This subsection records every unique class target the upstream `set_*` calls reference (80 classes total — the keyword grep `set_(stylebox|color|font|icon|constant|font_size)\(...,\s*'[A-Z][a-zA-Z]+'` surfaces them all). Each is classified into one of four buckets. The "user-facing — enumerated below" bucket is the dissection scope; the others are documented for completeness so coverage delta (Plan 04) starts from a verified baseline, not a keyword guess.

    ### Active Verification Audit

    | Class | Bucket | Why |
    |-------|--------|-----|
    | AcceptDialog | user-facing — enumerated below | D-08 user-facing dialog Control |
    | AnimationBezierTrackEdit | editor-only — skipped per D-10 | Editor animation pane internal |
    | AnimationTimelineEdit | editor-only — skipped per D-10 | Editor animation pane internal |
    | ... [continue for all 80] ... |
    | Window | user-facing — enumerated below | D-08 user-facing top-level Window |

    **Bucket counts:**
    - user-facing — enumerated below: 27 (or actual count if D-08 needs revision per audit findings)
    - research-only (FlatButton, D-10 exception): 1
    - type variation noted on its base (e.g., TabContainerOdd → TabContainer notes): {N}
    - container chrome (HBoxContainer / VBoxContainer / SeparatorContainers / PanelContainer / ScrollContainer / SplitContainer / HSplit / VSplit / HSeparator / VSeparator) — enumerated below as a single section "User-facing container chrome": {N}
    - editor-only — skipped per D-10: {N}

    **D-08 reconciliation:** [If any D-08 class has zero `set_*` calls in upstream — e.g., bare `MenuBar` or bare `Panel` — record here: "D-08 lists X but upstream has 0 entries; classified as 'unthemed by upstream' — NeoCade owns first-class theming, no upstream benchmark exists."]
    ```
  </action>
  <verify>
    ```bash
    grep -q "Active Verification Audit" .planning/research/MINIMAL-THEME-DISSECTION.md
    awk '/^### Active Verification Audit/,/^### / && !/^### Active Verification Audit/' .planning/research/MINIMAL-THEME-DISSECTION.md | grep -cE "^\| [A-Z][a-zA-Z]+ \|" | (read n; test "$n" -ge 80 || { echo "Audit table has only $n rows; expected ≥80"; exit 1; })
    grep -q "Bucket counts:" .planning/research/MINIMAL-THEME-DISSECTION.md
    ```
  </verify>
  <done>
    Audit table contains ≥80 rows (one per unique class target), every row classified, bucket counts present, D-08 reconciliation paragraph present (even if "no reconciliation needed").
  </done>
  <acceptance_criteria>
    - File contains heading `### Active Verification Audit`
    - Audit table has ≥80 data rows under that heading
    - Every D-08 class is either marked "user-facing — enumerated below" or has an explicit reconciliation note
    - FlatButton is marked "research-only (D-10 exception)"
    - Each editor-only class has bucket text matching `editor-only — skipped per D-10`
    - File contains the literal string `Bucket counts:`
  </acceptance_criteria>
</task>

<task type="auto">
  <name>Task 2: Enumerate Button + the four button family classes (CheckBox, CheckButton, OptionButton, MenuButton) + FlatButton (D-10) — they share the most state-suffix variety so doing them together establishes the per-state pattern other tasks reuse</name>
  <read_first>
    - /c/Programming_Files/Godot/godot-minimal-theme-main/minimal_theme.tres (lines 256-450 cover most Button-family entries — verify with grep first)
    - .planning/phases/01-source-dive-godot-minimal-theme-tres-dissection/01-RESEARCH.md (Pattern 1 row format, Pitfall 1.1 framing)
    - .planning/phases/01-source-dive-godot-minimal-theme-tres-dissection/01-01-dissection-skeleton-PLAN.md (Globals + Helper Functions section names this task references)
  </read_first>
  <files>.planning/research/MINIMAL-THEME-DISSECTION.md (append `### Button`, `### CheckBox`, `### CheckButton`, `### OptionButton`, `### MenuButton`, `### FlatButton` under `## Per-Control Enumeration`)</files>
  <action>
    For each class in [Button, CheckBox, CheckButton, OptionButton, MenuButton, FlatButton]:

    1. Run discovery grep:
       ```bash
       grep -nE "set_(stylebox|color|font|icon|constant|font_size)\([^,]+, '<ClassName>'" \
         /c/Programming_Files/Godot/godot-minimal-theme-main/minimal_theme.tres
       ```

    2. For each line returned, follow the value reference back to its definition (e.g., if value is `color_font_normal`, cite line 81 from the Globals section; if it's a freshly-constructed `StyleBoxFlat`, follow back to the construction lines and inline the construction recipe).

    3. Append a `### ClassName` section per the format in `<interfaces>`. Every `set_*` call gets one row. Every state suffix gets its own row (no combining "normal/hover" into one row even if values are equal — exhaustive per D-07).

    4. For Button specifically: explicitly enumerate the state matrix — `normal`, `hover`, `pressed`, `hover_pressed`, `disabled`, `focus`, `font_color`, `font_disabled_color`, `font_focus_color`, `font_hover_color`, `font_hover_pressed_color`, `font_pressed_color`, `icon_normal_color`, `icon_disabled_color`, `icon_focus_color`, `icon_hover_color`, `icon_hover_pressed_color`, `icon_pressed_color`, plus constants like `h_separation`, `icon_max_width`, `font_size`, `outline_size` — per upstream's actual coverage.

    5. For CheckBox/CheckButton: include the `radio_checked` / `radio_unchecked` / `radio_checked_disabled` / `radio_unchecked_disabled` icon entries plus the underlying button styleboxes inherited from Button base.

    6. For OptionButton/MenuButton: include the `arrow` icon entry plus per-state styleboxes.

    7. **Per-class notes:** for FlatButton, include explicit text "Editor-only in upstream; enumerated here per CONTEXT.md D-10 because NeoCade reuses the name as a Button type variation per FEATURES.md TYPEVAR-01 (DF-Button-1). NeoCade's FlatButton variation does NOT inherit upstream's editor-bound implementation; this enumeration is research material for the TYPEVAR-01 visual contract decision in Phase 5."

    8. Snapshot column uses upstream README defaults (`base_color=#272727`, `contrast=0.325`, `corner_radius=4`, `accent_color=#569eff`, `dark_theme=true`).

    Acceptance criterion is structural ("each class has its `### ClassName` section with N entry rows where N = the count from the discovery grep") — Plan 03's omission cross-reference catches *missing* entries upstream chose not to populate.
  </action>
  <verify>
    ```bash
    src=/c/Programming_Files/Godot/godot-minimal-theme-main/minimal_theme.tres
    out=.planning/research/MINIMAL-THEME-DISSECTION.md
    for c in Button CheckBox CheckButton OptionButton MenuButton FlatButton; do
      grep -q "^### $c\$" "$out" || { echo "MISSING SECTION: $c"; exit 1; }
      # DYNAMIC count check (per cross-AI review): row count ≥ discovery-grep count, never a hardcoded floor.
      # FlatButton is editor-only in upstream — it MAY have zero set_* lines per CONTEXT.md D-10. If discovery=0, the section must contain an explicit "no upstream entries — research-only TYPEVAR-01 placeholder" note (matched separately below).
      discovery=$(grep -cE "set_(stylebox|color|font|icon|constant|font_size)\([^,]+, '$c'" "$src" || true)
      enumerated=$(awk "/^### $c\$/,/^### [A-Z]/" "$out" | grep -cE "^\| (stylebox|color|font|font_size|icon|constant) ")
      if [ "$discovery" -eq 0 ]; then
        # Class has no upstream entries — section must carry an explicit "no upstream entries" note
        awk "/^### $c\$/,/^### [A-Z]/" "$out" | grep -qE "no upstream entries|research-only|NeoCade-additive" || { echo "$c has 0 set_* in upstream; section must carry an explicit 'no upstream entries' / 'research-only' / 'NeoCade-additive' note"; exit 1; }
      else
        # Class has N upstream entries — enumeration must equal discovery count exactly (D-07: exhaustive, no shortcuts and no surplus)
        test "$enumerated" -eq "$discovery" || { echo "$c: discovery=$discovery upstream entries, enumeration=$enumerated rows. Must equal exactly (per D-07 + cross-AI review: no static floors, no missing rows, no duplicate rows)."; exit 1; }
      fi
    done
    grep -q "TYPEVAR-01" "$out"   # FlatButton notes reference
    ```
    Plus: spot-check 3 random rows in the Button section against `set_*` lines in minimal_theme.tres — formula matches the cited line.
  </verify>
  <done>
    All 6 sections present. For every class with N≥1 upstream `set_*` lines, the enumeration row count equals N exactly (not a static floor). For any class with 0 upstream entries (FlatButton may qualify per D-10), the section carries an explicit "no upstream entries" / "research-only" / "NeoCade-additive" note. FlatButton notes reference TYPEVAR-01. Spot-check passes.
  </done>
  <acceptance_criteria>
    - File contains exactly the headings `### Button`, `### CheckBox`, `### CheckButton`, `### OptionButton`, `### MenuButton`, `### FlatButton`
    - For each section, the row count of `| stylebox|color|font|font_size|icon|constant |` shape rows EQUALS the count of upstream `set_*` lines targeting that class (dynamic equality — discovery grep run live in verify block above)
    - For any class where the discovery grep returns zero, the section contains one of the literal strings: `no upstream entries`, `research-only`, or `NeoCade-additive`
    - The `### FlatButton` section contains the literal string `TYPEVAR-01`
    - At least one row in `### Button` cites a line number ≤ 300 (the Button block in upstream starts ~line 256)
  </acceptance_criteria>
</task>

<task type="auto">
  <name>Task 3: Enumerate text-input + label classes — Label, RichTextLabel, LineEdit, TextEdit (the typography-heavy classes)</name>
  <read_first>
    - /c/Programming_Files/Godot/godot-minimal-theme-main/minimal_theme.tres (run discovery grep per class)
    - .planning/phases/01-source-dive-godot-minimal-theme-tres-dissection/01-01-dissection-skeleton-PLAN.md (Globals — `color_font_normal`, `color_font_secondary`, `color_font_highlighted`, `color_font_dimmed`)
  </read_first>
  <files>.planning/research/MINIMAL-THEME-DISSECTION.md (append `### Label`, `### RichTextLabel`, `### LineEdit`, `### TextEdit`)</files>
  <action>
    For each of [Label, RichTextLabel, LineEdit, TextEdit]:
    1. Discovery grep (same pattern as task 2).
    2. Append `### ClassName` section with one row per `set_*` call found.
    3. For LineEdit/TextEdit: explicitly enumerate the editor-text state matrix — `read_only`, `selection_color`, `caret_color`, `caret_background_color`, `font_selected_color`, `font_placeholder_color`, plus the per-state styleboxes (`normal`, `focus`, `read_only`).
    4. For RichTextLabel: include `default_color`, `font_selected_color`, `selection_color`, `bold_font` / `italic_font` / `bold_italic_font` / `mono_font`, plus `outline_size` / `outline_color`.
    5. Per-class notes: capture "upstream uses Inter as `Editor` font (line ~?, follow back from any `set_font` call) — per-Control font slots inherit unless overridden."
  </action>
  <verify>
    ```bash
    src=/c/Programming_Files/Godot/godot-minimal-theme-main/minimal_theme.tres
    out=.planning/research/MINIMAL-THEME-DISSECTION.md
    for c in Label RichTextLabel LineEdit TextEdit; do
      grep -q "^### $c\$" "$out" || { echo "MISSING: $c"; exit 1; }
      discovery=$(grep -cE "set_(stylebox|color|font|icon|constant|font_size)\([^,]+, '$c'" "$src" || true)
      enumerated=$(awk "/^### $c\$/,/^### [A-Z]/" "$out" | grep -cE "^\| (stylebox|color|font|font_size|icon|constant) ")
      if [ "$discovery" -eq 0 ]; then
        awk "/^### $c\$/,/^### [A-Z]/" "$out" | grep -qE "no upstream entries|research-only|NeoCade-additive" || { echo "$c has 0 upstream entries; section must carry explicit note"; exit 1; }
      else
        test "$enumerated" -eq "$discovery" || { echo "$c: discovery=$discovery, enumeration=$enumerated. Must equal exactly (D-07 + cross-AI review)"; exit 1; }
      fi
    done
    ```
  </verify>
  <done>
    All 4 sections present. For each class with N≥1 upstream entries, enumeration count equals N exactly. For any class with 0 upstream entries, section carries explicit "no upstream entries" note.
  </done>
  <acceptance_criteria>
    - File contains exactly the headings `### Label`, `### RichTextLabel`, `### LineEdit`, `### TextEdit`
    - For each section, the row count of `| stylebox|color|font|font_size|icon|constant |` shape rows EQUALS the count of upstream `set_*` lines targeting that class (dynamic equality, no static floor)
    - For any class where discovery grep returns zero, section contains one of: `no upstream entries`, `research-only`, `NeoCade-additive`
  </acceptance_criteria>
</task>

<task type="auto">
  <name>Task 4: Enumerate list/tree/tab classes — Tree, ItemList, TabBar, TabContainer (with TreeSecondary, ItemListSecondary, TabContainerOdd type-variations noted)</name>
  <read_first>
    - /c/Programming_Files/Godot/godot-minimal-theme-main/minimal_theme.tres (discovery grep per class; type-variation classes too)
    - .planning/phases/01-source-dive-godot-minimal-theme-tres-dissection/01-CONTEXT.md (D-11 — every state including unusual combinations like cursor_unfocused, selected_focus, tab_selected/tab_disabled/tab_focus)
  </read_first>
  <files>.planning/research/MINIMAL-THEME-DISSECTION.md (append `### Tree`, `### ItemList`, `### TabBar`, `### TabContainer`)</files>
  <action>
    For each of [Tree, ItemList, TabBar, TabContainer]:
    1. Discovery grep + type-variation grep (e.g., for Tree, also grep `'TreeSecondary'`).
    2. Append `### ClassName` section.
    3. For Tree: enumerate `panel`, `selected`, `selected_focus`, `cursor`, `cursor_unfocused`, `button_pressed`, `title_button_normal/hover/pressed`, plus colors `font_color`, `font_selected_color`, `font_outline_color`, `guide_color`, `relationship_line_color`, `parent_hl_line_color`, `children_hl_line_color`, `custom_button_*`, plus icons `arrow`, `arrow_collapsed`, `select_arrow`, `checked`, `unchecked`, `indeterminate`, `updown`.
    4. For ItemList: enumerate `panel`, `focus`, `selected`, `selected_focus`, `cursor`, `cursor_unfocused`, plus colors `font_color`, `font_hovered_color`, `font_selected_color`, `font_outline_color`, `guide_color`.
    5. For TabBar: enumerate `tab_selected`, `tab_unselected`, `tab_disabled`, `tab_focus`, `tab_hovered`, `button_pressed`, `button_highlight`, plus colors `font_selected_color`, `font_unselected_color`, `font_disabled_color`, `font_outline_color`, plus icons `increment`, `increment_highlight`, `decrement`, `decrement_highlight`, `drop_mark`, `close`, plus constants `h_separation`, `icon_separation`, `outline_size`, `font_size`, `font_outline_size`.
    6. For TabContainer: enumerate `tabbar_background`, `panel`, plus the same tab_* matrix as TabBar (TabContainer inherits TabBar's tab styleboxes; document upstream's TabContainer additions).
    7. Per-class notes: type-variations (TreeSecondary, ItemListSecondary, TabContainerOdd) are noted at the end of their base section with "Type variation: TreeSecondary specializes the X stylebox at line N to color_surface_lower instead of color_surface_base — used by upstream's editor for the secondary inspector tree."
  </action>
  <verify>
    ```bash
    src=/c/Programming_Files/Godot/godot-minimal-theme-main/minimal_theme.tres
    out=.planning/research/MINIMAL-THEME-DISSECTION.md
    for c in Tree ItemList TabBar TabContainer; do
      grep -q "^### $c\$" "$out" || { echo "MISSING: $c"; exit 1; }
      discovery=$(grep -cE "set_(stylebox|color|font|icon|constant|font_size)\([^,]+, '$c'" "$src" || true)
      enumerated=$(awk "/^### $c\$/,/^### [A-Z]/" "$out" | grep -cE "^\| (stylebox|color|font|font_size|icon|constant) ")
      if [ "$discovery" -eq 0 ]; then
        awk "/^### $c\$/,/^### [A-Z]/" "$out" | grep -qE "no upstream entries|research-only|NeoCade-additive" || { echo "$c has 0 upstream entries; section must carry explicit note"; exit 1; }
      else
        test "$enumerated" -eq "$discovery" || { echo "$c: discovery=$discovery, enumeration=$enumerated. Must equal exactly (D-07 + cross-AI review)"; exit 1; }
      fi
    done
    grep -q "TreeSecondary\|ItemListSecondary\|TabContainerOdd" "$out"   # type-variation noted somewhere
    ```
  </verify>
  <done>
    All 4 sections present. For each class with N≥1 upstream entries, enumeration count equals N exactly. Type variations noted.
  </done>
  <acceptance_criteria>
    - File contains exactly the headings `### Tree`, `### ItemList`, `### TabBar`, `### TabContainer`
    - For each section, enumeration row count EQUALS upstream `set_*` discovery count (dynamic equality, no static floor)
    - For any class with 0 upstream entries, section contains one of: `no upstream entries`, `research-only`, `NeoCade-additive`
    - At least one of TreeSecondary, ItemListSecondary, TabContainerOdd appears as a per-class note
  </acceptance_criteria>
</task>

<task type="auto">
  <name>Task 5: Enumerate range/scroll/progress classes — ProgressBar, HSlider, VSlider, HScrollBar, VScrollBar</name>
  <read_first>
    - /c/Programming_Files/Godot/godot-minimal-theme-main/minimal_theme.tres (discovery grep per class)
  </read_first>
  <files>.planning/research/MINIMAL-THEME-DISSECTION.md (append `### ProgressBar`, `### HSlider`, `### VSlider`, `### HScrollBar`, `### VScrollBar`)</files>
  <action>
    For each of [ProgressBar, HSlider, VSlider, HScrollBar, VScrollBar]:
    1. Discovery grep.
    2. Append `### ClassName` section.
    3. For ProgressBar: enumerate `background`, `fill`, plus colors `font_color`, `font_outline_color`, plus constants `font_size`, `outline_size`.
    4. For sliders (HSlider/VSlider — likely share most styleboxes): enumerate `slider`, `grabber_area`, `grabber_area_highlight`, `grabber_disabled`, plus icons `grabber`, `grabber_highlight`, `grabber_disabled`, `tick`, plus constants `center_grabber`, `grabber_offset`.
    5. For scrollbars: enumerate `scroll`, `scroll_focus`, `scroll_offset`, `grabber`, `grabber_highlight`, `grabber_pressed`, plus icons `decrement`, `decrement_highlight`, `decrement_pressed`, `increment`, `increment_highlight`, `increment_pressed`, plus constants — note the touch-area mention from upstream's engine-version-conditional setting (lines 38-44).
    6. Per-class notes: scrollbar "increase_scrollbar_touch_area" engine-version conditional handling — citation back to lines 38-44 in Globals.
  </action>
  <verify>
    ```bash
    src=/c/Programming_Files/Godot/godot-minimal-theme-main/minimal_theme.tres
    out=.planning/research/MINIMAL-THEME-DISSECTION.md
    for c in ProgressBar HSlider VSlider HScrollBar VScrollBar; do
      grep -q "^### $c\$" "$out" || { echo "MISSING: $c"; exit 1; }
      discovery=$(grep -cE "set_(stylebox|color|font|icon|constant|font_size)\([^,]+, '$c'" "$src" || true)
      enumerated=$(awk "/^### $c\$/,/^### [A-Z]/" "$out" | grep -cE "^\| (stylebox|color|font|font_size|icon|constant) ")
      if [ "$discovery" -eq 0 ]; then
        awk "/^### $c\$/,/^### [A-Z]/" "$out" | grep -qE "no upstream entries|research-only|NeoCade-additive" || { echo "$c has 0 upstream entries; section must carry explicit note"; exit 1; }
      else
        test "$enumerated" -eq "$discovery" || { echo "$c: discovery=$discovery, enumeration=$enumerated. Must equal exactly (D-07 + cross-AI review)"; exit 1; }
      fi
    done
    grep -q "increase_scrollbar_touch_area\|enable_touch_optimizations" "$out"
    ```
  </verify>
  <done>
    All 5 sections present. For each class with N≥1 upstream entries, enumeration count equals N exactly. Touch-area note included.
  </done>
  <acceptance_criteria>
    - File contains exactly the headings `### ProgressBar`, `### HSlider`, `### VSlider`, `### HScrollBar`, `### VScrollBar`
    - For each section, enumeration row count EQUALS upstream `set_*` discovery count (dynamic equality, no static floor)
    - For any class with 0 upstream entries, section contains one of: `no upstream entries`, `research-only`, `NeoCade-additive`
    - File mentions either `increase_scrollbar_touch_area` or `enable_touch_optimizations`
  </acceptance_criteria>
</task>

<task type="auto">
  <name>Task 6: Enumerate popup/window/dialog classes — Panel, PopupMenu, PopupPanel, AcceptDialog, TooltipPanel, Window — these directly inform Pitfall 1.7 confirmation in Plan 03</name>
  <read_first>
    - /c/Programming_Files/Godot/godot-minimal-theme-main/minimal_theme.tres (discovery grep per class — note: bare `Panel` class may have zero entries; D-08 reconciliation in Task 1 either flagged it or not)
    - .planning/research/PITFALLS.md (Pitfall 1.7 — popups separate Window theming claim, to be confirmed by enumeration evidence)
  </read_first>
  <files>.planning/research/MINIMAL-THEME-DISSECTION.md (append sections for each present class; if a class has zero entries per audit Task 1, write the section as "(no upstream entries — themed via inheritance/default; first-class theming is NeoCade-additive)")</files>
  <action>
    For each of [Panel, PopupMenu, PopupPanel, AcceptDialog, TooltipPanel, Window]:
    1. Discovery grep.
    2. If grep returns zero lines: append `### ClassName` with single sentence "Upstream does not theme this class directly — themed via the engine-default fallback or via parent-Control inheritance. NeoCade-additive: this is a class NeoCade owns first-class theming for; coverage delta (Plan 04) tracks this." Cite the active-verification audit row.
    3. If grep returns lines: append normal `### ClassName` section.
    4. For PopupMenu: enumerate `panel`, `hover`, `separator`, plus colors `font_color`, `font_hover_color`, `font_disabled_color`, `font_separator_color`, `font_accelerator_color`, `font_outline_color`, plus icons `submenu`, `submenu_mirrored`, `checked`, `unchecked`, `radio_checked`, `radio_unchecked`, plus constants `h_separation`, `v_separation`, `outline_size`, `font_size`, `font_separator_size`, `font_outline_size`.
    5. For PopupPanel: enumerate `panel`.
    6. For AcceptDialog: enumerate `panel`, plus the dialog button row spacing constants.
    7. For TooltipPanel: enumerate `panel`.
    8. For Window: enumerate `embedded_border`, `embedded_unfocused_border`, plus `title_color`, `title_outline_modulate`, plus icons `close`, `close_pressed`, plus constants `close_h_offset`, `close_v_offset`, `resize_margin`, `title_height`, `title_outline_size`, `title_font_size`.
    9. **Pitfall 1.7 evidence anchoring:** at the end of this batch's sections, add a `> Pitfall 1.7 (popup separate-Window theming) evidence:` paragraph citing the populated entries above. This is the *evidence* that Plan 03 references in its confirmation/refutation section.
  </action>
  <verify>
    ```bash
    for c in Panel PopupMenu PopupPanel AcceptDialog TooltipPanel Window; do
      grep -q "^### $c\$" .planning/research/MINIMAL-THEME-DISSECTION.md || { echo "MISSING: $c"; exit 1; }
    done
    grep -q "Pitfall 1.7 (popup separate-Window theming) evidence" .planning/research/MINIMAL-THEME-DISSECTION.md
    ```
  </verify>
  <done>
    All 6 sections present, Pitfall 1.7 evidence-anchor note present.
  </done>
  <acceptance_criteria>
    - File contains exactly the headings `### Panel`, `### PopupMenu`, `### PopupPanel`, `### AcceptDialog`, `### TooltipPanel`, `### Window`
    - File contains literal string `Pitfall 1.7 (popup separate-Window theming) evidence`
    - PopupMenu section contains rows for at least 3 of: `submenu`, `checked`, `radio_checked` (icons)
    - Window section contains rows for at least 2 of: `embedded_border`, `title_color`, `close` (mixed kinds)
  </acceptance_criteria>
</task>

<task type="auto">
  <name>Task 7: Enumerate remaining user-facing classes — ColorPicker, GraphEdit, MenuBar (D-08 reconciliation), plus container chrome single section</name>
  <read_first>
    - /c/Programming_Files/Godot/godot-minimal-theme-main/minimal_theme.tres (discovery grep per class; container-chrome classes: HBoxContainer, VBoxContainer, PanelContainer, ScrollContainer, SplitContainer, HSplitContainer, VSplitContainer, HSeparator, VSeparator)
    - Task 1's audit table (for D-08 reconciliation status of MenuBar)
  </read_first>
  <files>.planning/research/MINIMAL-THEME-DISSECTION.md (append `### ColorPicker`, `### GraphEdit`, `### MenuBar` (or reconciliation note), `### User-facing container chrome`)</files>
  <action>
    1. Discovery grep for ColorPicker, GraphEdit, MenuBar.
    2. **For ColorPicker:** enumerate `bar_arrow`, `picker_cursor`, `picker_cursor_bg`, `screen_picker`, plus icons for sliders/eyedropper, plus constants. ColorPicker is a complex compound Control with many sub-themed parts — be thorough.
    3. **For GraphEdit:** enumerate `panel`, `panel_focus`, plus colors `grid_major`, `grid_minor`, `selection_fill`, `selection_stroke`, `connection_*` (multiple), `activity`, plus icons `grid_toggle`, `minus`, `more`, `reset`, `snapping_toggle`, `zoom`, `layout`, plus constants `port_grab_distance_horizontal`, `port_grab_distance_vertical`. GraphEdit is dense.
    4. **For MenuBar:** Task 1's audit revealed whether bare `MenuBar` is themed. If grep returns zero (most likely — upstream targets `MainMenuBar` editor type), write the reconciliation note: "Upstream themes `MainMenuBar` (editor-only) but not the bare `MenuBar` user-facing class. NeoCade-additive: NeoCade owns first-class MenuBar theming. Coverage delta (Plan 04) flags this as a NeoCade-additive."
    5. **Container chrome single section** — write one `### User-facing container chrome` heading covering HBoxContainer / VBoxContainer / PanelContainer / ScrollContainer / SplitContainer / HSplitContainer / VSplitContainer / HSeparator / VSeparator together (most have only constants — `separation`, `h_separation`, `v_separation` — and HSplitContainer / VSplitContainer have a `separator` stylebox + `grabber` icon). Write one row per (class, slot) pair found.
  </action>
  <verify>
    ```bash
    src=/c/Programming_Files/Godot/godot-minimal-theme-main/minimal_theme.tres
    out=.planning/research/MINIMAL-THEME-DISSECTION.md
    grep -q "^### ColorPicker\$" "$out"
    grep -q "^### GraphEdit\$" "$out"
    grep -qE "^### MenuBar\$|MenuBar.*NeoCade-additive" "$out"
    grep -q "^### User-facing container chrome\$" "$out"
    # Dynamic discovery-grep equality (per cross-AI review): no static floors
    for c in ColorPicker GraphEdit; do
      discovery=$(grep -cE "set_(stylebox|color|font|icon|constant|font_size)\([^,]+, '$c'" "$src" || true)
      enumerated=$(awk "/^### $c\$/,/^### [A-Z]/" "$out" | grep -cE "^\| (stylebox|color|font|font_size|icon|constant) ")
      test "$enumerated" -eq "$discovery" || { echo "$c: discovery=$discovery, enumeration=$enumerated. Must equal exactly (D-07 + cross-AI review)"; exit 1; }
    done
    ```
  </verify>
  <done>
    All 4 sections present (or MenuBar reconciliation). For ColorPicker and GraphEdit, enumeration row count equals upstream discovery count exactly (no static floor).
  </done>
  <acceptance_criteria>
    - File contains `### ColorPicker`, `### GraphEdit`, and `### User-facing container chrome` headings exactly
    - Either `### MenuBar` heading exists OR file contains the literal string `MenuBar` near the literal string `NeoCade-additive`
    - ColorPicker and GraphEdit enumeration row counts EQUAL upstream `set_*` discovery counts (dynamic equality, no static floor)
  </acceptance_criteria>
</task>

<task type="auto">
  <name>Task 8: Final sweep — verify all 27 + FlatButton sections present, all reference Globals/helper names that exist in Plan 01's section, no orphaned references</name>
  <read_first>
    - .planning/research/MINIMAL-THEME-DISSECTION.md (full file — must read to validate cross-references)
    - .planning/phases/01-source-dive-godot-minimal-theme-tres-dissection/01-01-dissection-skeleton-PLAN.md (`<interfaces>` block lists every Globals/helper name)
  </read_first>
  <files>.planning/research/MINIMAL-THEME-DISSECTION.md (no new content; only validation + minor edits if orphans found)</files>
  <action>
    1. Confirm `### ClassName` headings for all 28 expected classes (27 user-facing + FlatButton):
       AcceptDialog, Button, CheckBox, CheckButton, ColorPicker, FlatButton, GraphEdit, HScrollBar, HSlider, ItemList, Label, LineEdit, MenuBar (or reconciliation note), MenuButton, OptionButton, Panel (or reconciliation note), PopupMenu, PopupPanel, ProgressBar, RichTextLabel, TabBar, TabContainer, TextEdit, TooltipPanel, Tree, VScrollBar, VSlider, Window. Plus the User-facing container chrome group.
    2. Extract every Globals/helper reference used in formula cells (greppable as `color_*`, `_get_base_color`, `_set_margin`, `_set_border`, `base_margin`, `popup_margin`, etc.) and confirm each appears in the Globals or Helper Functions sections (Plan 01's deliverable). Any reference not defined → add a row to Globals or fix the citation.
    3. Confirm no `### ClassName` section is empty.
  </action>
  <verify>
    ```bash
    EXPECTED_CLASSES="AcceptDialog Button CheckBox CheckButton ColorPicker FlatButton GraphEdit HScrollBar HSlider ItemList Label LineEdit MenuButton OptionButton PopupMenu PopupPanel ProgressBar RichTextLabel TabBar TabContainer TextEdit TooltipPanel Tree VScrollBar VSlider Window"
    for c in $EXPECTED_CLASSES; do
      grep -q "^### $c\$" .planning/research/MINIMAL-THEME-DISSECTION.md || { echo "MISSING: $c"; exit 1; }
    done
    # MenuBar and Panel may be reconciliation-noted instead of full sections — check either form
    grep -qE "^### MenuBar\$|MenuBar.*NeoCade-additive" .planning/research/MINIMAL-THEME-DISSECTION.md
    grep -qE "^### Panel\$|^### Panel " .planning/research/MINIMAL-THEME-DISSECTION.md
    grep -q "^### User-facing container chrome\$" .planning/research/MINIMAL-THEME-DISSECTION.md
    # No empty section
    awk '/^### [A-Z]/{cls=$0; rows=0; next} /^### / || /^## /{if(rows==0 && cls!="") {print "EMPTY SECTION:", cls; exit 1} cls=""} /^\| / {rows++}' .planning/research/MINIMAL-THEME-DISSECTION.md
    ```
  </verify>
  <done>
    All 28 expected sections present (or reconciled), no empty sections, no orphan globals references.
  </done>
  <acceptance_criteria>
    - Every class in the EXPECTED_CLASSES list has a `### ClassName` heading
    - MenuBar is either a section heading or appears with NeoCade-additive note
    - Panel is either a section heading or has reconciliation text
    - `### User-facing container chrome` heading exists
    - No `### ClassName` section is empty (every section has at least one row OR an explicit "no upstream entries" note)
  </acceptance_criteria>
</task>

</tasks>

<threat_model>
## Trust Boundaries

| Boundary | Description |
|----------|-------------|
| upstream `minimal_theme.tres` (MIT) → NeoCade dissection table cells | Per Plan 01: symbolic formula extraction (D-04) keeps the boundary clean. Snapshot column is verification-only and clearly labeled. |
| Glossary / per-state vocabulary completeness → coverage delta accuracy | If state suffixes are missed in enumeration, coverage delta (Plan 04) becomes wrong. Mitigation: D-11 mandates exhaustive state enumeration; per-task acceptance criteria require ≥N rows. |

## STRIDE Threat Register

| Threat ID | Category | Component | Disposition | Mitigation Plan |
|-----------|----------|-----------|-------------|-----------------|
| T-1-04 | Information disclosure | Inaccurate formula extraction (citing wrong line, copying wrong value) | mitigate | Every row carries a source line citation; spot-check verification in Plan 01's Manual-Only Verifications block (VALIDATION.md) catches systematic errors during `/gsd-verify-work`. |
| T-1-05 | Tampering | Type-variation classes (TabContainerOdd / TreeSecondary / ItemListSecondary / FlatMenuButton) being treated as user-facing classes when they're editor-only specializations | mitigate | Active-verification audit (Task 1) classifies type-variations into a distinct bucket; per-class notes in their bases (Tasks 4) document them but the dissection scope stays at the user-facing layer. |
| T-1-06 | Repudiation | D-08 list mismatch with actual upstream coverage (e.g., MenuBar / Panel not themed by upstream) | mitigate | Task 1's reconciliation paragraph explicitly documents any D-08 class with zero upstream entries as "themed via inheritance/default — NeoCade-additive." Coverage delta (Plan 04) consumes this for clean accounting. |
</threat_model>

<verification>
- [ ] All 28 `### ClassName` sections (27 user-facing + FlatButton) present, with reconciliation notes for any D-08 class upstream doesn't theme
- [ ] Each section's row count EXACTLY EQUALS the count of `set_*` lines for that class in upstream (`grep -c` dynamic equality — no static floors per cross-AI review 2026-05-04)
- [ ] For any class with 0 upstream entries, section carries an explicit "no upstream entries" / "research-only" / "NeoCade-additive" note (instead of a row count)
- [ ] No row references a Globals/helper name not defined in Plan 01's sections
- [ ] Active-verification audit covers all 80 unique class targets
- [ ] Pitfall 1.7 evidence-anchor note present for Plan 03 to consume
</verification>

<success_criteria>
- All grep checks across tasks 1-8 pass
- File line count grew substantially (loose lower bound: ≥1500 lines after this plan, since CONTEXT.md predicts a final 1500-3000 line dissection)
- Every formula in row cells uses the symbolic formula pattern from RESEARCH.md Pattern 1 (no lifted numeric constants without the formula)
</success_criteria>

<output>
After completion, create `.planning/phases/01-source-dive-godot-minimal-theme-tres-dissection/01-02-SUMMARY.md` capturing: total enumeration row count, audit reconciliation outcomes (which D-08 classes had zero upstream entries), per-class entry-count distribution, any orphan globals references found and fixed.
</output>
