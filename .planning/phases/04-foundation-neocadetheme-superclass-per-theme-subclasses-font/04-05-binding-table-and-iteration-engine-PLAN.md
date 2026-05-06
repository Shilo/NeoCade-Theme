---
phase: 04-foundation-neocadetheme-superclass-per-theme-subclasses-font
plan: 05
type: execute
wave: 2
depends_on:
  - "04-01"
  - "04-02"
  - "04-03"
  - "04-04"
files_modified:
  - addons/neocade_theme/neocade_theme.gd
autonomous: true
requirements:
  - FOUND-02
  - ICON-02
must_haves:
  truths:
    - "**D-06** Phase 4 baseline coverage achieved here: this plan ships the BINDING_TABLE + iteration engine that produces the 37/37 baseline pass — the binding table covers every one of the 37 scorecard Controls so SC#7 closes by Phase 4 end."
    - "**D-07** Baseline depth is full formula state coverage: the BINDING_TABLE entries authored by this plan populate Button's normal/hover/pressed/focus/disabled/hover_pressed; Tree's 16 styleboxes; LineEdit's normal/focus/read_only; PopupMenu's panel/hover/separator + labeled separators; Window's embedded_border/embedded_unfocused_border; HScrollBar's scroll/grabber/grabber_highlight/grabber_pressed. Phases 5/6/7 are POLISH passes only."
    - "**D-09** SC#7 is read STRICTLY here: every Control type has every required slot present (formula-derived) + every variation type registered with its required fonts; verified visually in Theme Editor + via Plan 04-06's `_phase4_verify.gd` helper. Final COV-10 check happens in Phase 10."
    - "`addons/neocade_theme/neocade_theme.gd` declares a constant `BINDING_TABLE` (a `Dictionary` compiled into the file) keyed by `theme_type` → `data_type` (`stylebox`/`color`/`constant`/`font`/`font_size`/`icon`) → `slot_name` → recipe metadata."
    - "BINDING_TABLE covers ALL 37 scorecard Control rows from `MINIMAL-THEME-COVERAGE-DELTA.md`: AcceptDialog, Button, CheckBox, CheckButton, CodeEdit, ColorPicker, ColorPickerButton, ConfirmationDialog, FileDialog, GraphEdit, GraphFrame, GraphNode, HFlowContainer, HScrollBar, HSeparator, HSlider, ItemList, Label, LineEdit, LinkButton, MenuBar, MenuButton, OptionButton, PanelContainer, PopupMenu, PopupPanel, ProgressBar, RichTextLabel, SpinBox, SplitContainer, TabBar, TabContainer, TextEdit, TooltipPanel, Tree, VScrollBar, VSeparator, VSlider, Window."
    - "`TYPE_VARIATIONS` constant declares all 13 NeoCade type variations (PrimaryButton, SecondaryButton, GhostButton, DangerButton, IconButton, FlatButton, HeaderLarge, HeaderMedium, HeaderSmall, Caption, CodeLabel, InfoText, CardPanel, HeroPanel — adjusted to actual 13 per TYPEVAR-01..04 + TYPEVAR-05 if applicable; planner authoring may add HeroPanel as the 13th if listed in TYPEVAR-05) with their base type."
    - "`_regenerate_theme()` body now walks `BINDING_TABLE`: for each `(theme_type, data_type, slot_name)`, computes the recipe value from the derived locals (Plan 04-04) + the per-Control parameter context, and calls `set_stylebox(slot_name, theme_type, sb)` / `set_color(...)` / `set_constant(...)` / `set_font(...)` / `set_font_size(...)` / `set_icon(...)`."
    - "Iteration is ADDITIVE — entries not in BINDING_TABLE are LEFT UNTOUCHED (D-04 escape hatch). The walk uses `set_*(name, type, value)` directly and does NOT call `clear()` (D-01 invariant)."
    - "`_regenerate_theme()` calls `set_type_variation(variation, base_type)` for all 13 variations registered in `TYPE_VARIATIONS`."
    - "Each variation that needs a font has an explicit `set_font(\"font\", variation, ...)` call (PITFALLS 1.2 — variations don't inherit fonts from base type). HeaderLarge/HeaderMedium/HeaderSmall reference the matching FontVariation from Plan 04-02; Caption + InfoText reference Inter-Caption.tres; CodeLabel uses default font (consumer-overridable per FONT-04)."
    - "Font sizes are read from `_platform_tokens(p)` per DESIGN_TOKENS §8.5 type scale; `Theme.set_font_size` sets per-type / per-variation sizes."
    - "Icon binding wires the 10 Button-family SVGs (Plan 04-03) to the appropriate Theme slots: CheckBox checked/unchecked, RadioButton checked/unchecked (CheckBox alternate slot), CheckButton on/off, OptionButton arrow, LineEdit clear, etc."
    - "PITFALLS-aligned slots present: `Tree` has all 16 styleboxes; `LineEdit` has normal/focus/read_only; `PopupMenu` has panel/hover/separator + labeled separators; `Window` has embedded_border/embedded_unfocused_border; HScrollBar/VScrollBar have scroll/grabber/grabber_highlight/grabber_pressed."
    - "Class-header docstring explicitly notes that BINDING_TABLE structure is REVISABLE per CONTEXT.md D-03."
    - "No `clear()` call anywhere in the regeneration path."
  artifacts:
    - addons/neocade_theme/neocade_theme.gd (BINDING_TABLE + TYPE_VARIATIONS + iteration engine + variation registration + font/font_size/icon binding)
  key_links:
    - ".planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-CONTEXT.md D-01, D-02, D-03, D-04, D-08, D-14"
    - ".planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-RESEARCH.md §1, §2, §8"
    - ".planning/DESIGN_TOKENS.md §7, §8, §9, §12.4"
    - ".planning/research/MINIMAL-THEME-COVERAGE-DELTA.md (the 37-row scorecard)"
    - ".planning/research/MINIMAL-THEME-DISSECTION.md (per-Control state enumeration)"
    - ".planning/research/PITFALLS.md (1.1, 1.2, 1.6, 1.7, 10.3)"
---

<objective>
Author the `BINDING_TABLE` (the data structure that maps every Control's theme entries to derivation-block-driven recipes) and the `TYPE_VARIATIONS` table; rewrite `_regenerate_theme()` to walk both tables and populate Theme entries via `set_stylebox` / `set_color` / `set_constant` / `set_font` / `set_font_size` / `set_icon` (additive only); register all 13 NeoCade type variations with explicit fonts per PITFALLS 1.2; wire the 10 Button-family icons (Plan 04-03) to their Theme slots.

Purpose: produce the additive iteration engine that turns the `@export` properties + derived locals (Plan 04-04) into a fully-populated Theme covering all 37 scorecard Control rows + 13 type variations — the SC#7 hard requirement for Phase 4 close.
Output: `addons/neocade_theme/neocade_theme.gd` extended by ~600-1000 lines of `BINDING_TABLE` data + the iteration walk in `_regenerate_theme()`.
</objective>

<execution_context>
@$HOME/.codex/get-shit-done/workflows/execute-plan.md
@$HOME/.codex/get-shit-done/templates/summary.md
</execution_context>

<context>
@.planning/DESIGN_TOKENS.md
@.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-CONTEXT.md
@.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-RESEARCH.md
@.planning/research/MINIMAL-THEME-COVERAGE-DELTA.md
@.planning/research/MINIMAL-THEME-DISSECTION.md
@.planning/research/FEATURES.md
@.planning/research/PITFALLS.md
@addons/neocade_theme/neocade_theme.gd

<interfaces>
This plan is the heaviest plan in Phase 4 by line count. It depends on:
- Plan 04-01 (class shell with `@export` properties + Platform enum + reentry guard).
- Plan 04-02 (FontFile + 5 FontVariation `.tres` referenceable by `preload`).
- Plan 04-03 (10 SVG icons referenceable by `preload`).
- Plan 04-04 (color helpers + platform helpers + raised helper + derivation block locals).

After this plan, `_regenerate_theme()` is feature-complete: loading any direction `.tres` yields a Theme with entries for all 37 scorecard Controls + 13 variations populated. Plans 04-06 (Pulse `.tres`) and 04-07 (Slate/Bubble/Daybreak/Burst `.tres`) only set `@export` values; the engine does the rest.
</interfaces>
</context>

<tasks>

<task type="auto">
  <name>Task 1: Author the TYPE_VARIATIONS constant + register variations in _regenerate_theme()</name>
  <read_first>
    - addons/neocade_theme/neocade_theme.gd
    - .planning/research/FEATURES.md (13 type variations)
    - .planning/DESIGN_TOKENS.md (§8.5 type scale, §8.6 kicker)
    - .planning/research/PITFALLS.md (1.2 — variations don't inherit fonts)
  </read_first>
  <files>
    - addons/neocade_theme/neocade_theme.gd (modify — append TYPE_VARIATIONS + variation registration block)
  </files>
  <action>
    Append the `TYPE_VARIATIONS` constant near the top of `neocade_theme.gd` (after the `enum Platform` declaration but before the `@export` block, OR at the bottom of the file as a `const` — pick whichever placement is cleaner; convention: bottom near other table-data constants):

    ```gdscript
    # ─── Type variation registry (DESIGN_TOKENS §8.5; PITFALLS 1.2 mandate explicit fonts) ──────
    ## 13 NeoCade type variations registered via Theme.set_type_variation().
    ## Each entry: variation_name → base_type. Phases 5/6/7 author per-direction personality
    ## styleboxes per variation in `.tres` Theme Editor overrides; Phase 4 only registers + sets
    ## explicit fonts (Pitfall 1.2: variations don't inherit fonts from base type).
    const TYPE_VARIATIONS: Dictionary = {
        # Button family (TYPEVAR-01)
        "PrimaryButton":   "Button",
        "SecondaryButton": "Button",
        "GhostButton":     "Button",
        "DangerButton":    "Button",
        "IconButton":      "Button",
        "FlatButton":      "Button",
        # Label / heading family (TYPEVAR-02 + TYPEVAR-03)
        "HeaderLarge":  "Label",
        "HeaderMedium": "Label",
        "HeaderSmall":  "Label",
        "Caption":      "Label",
        "InfoText":     "Label",
        # Panel family (TYPEVAR-04)
        "CardPanel": "PanelContainer",
        "HeroPanel": "PanelContainer",
    }
    ```

    Rationale: 13 entries exact (6 Button-family + 5 Label-family + 2 Panel-family). If FEATURES.md / TYPEVAR-05 names a different 13th, the executor swaps `HeroPanel` for the canonical name; the COUNT is binding (13 variations exact).

    Then in `_regenerate_theme()` body, AFTER the derivation block (Plan 04-04) and BEFORE the `_last_regeneration_usec` line, add the variation-registration block:

    ```gdscript
        # ── Register type variations (DESIGN_TOKENS §8.5; PITFALLS 1.2) ──
        for variation_name in TYPE_VARIATIONS.keys():
            var base_type: String = TYPE_VARIATIONS[variation_name]
            set_type_variation(variation_name, base_type)

        # ── Set explicit fonts on header variations (PITFALLS 1.2 mandate) ──
        var header_large_font  := preload("res://addons/neocade_theme/fonts/Inter-HeaderLarge.tres") as FontVariation
        var header_medium_font := preload("res://addons/neocade_theme/fonts/Inter-HeaderMedium.tres") as FontVariation
        var header_small_font  := preload("res://addons/neocade_theme/fonts/Inter-HeaderSmall.tres") as FontVariation
        var body_font          := preload("res://addons/neocade_theme/fonts/Inter-Body.tres") as FontVariation
        var caption_font       := preload("res://addons/neocade_theme/fonts/Inter-Caption.tres") as FontVariation
        set_font("font", "HeaderLarge",  header_large_font)
        set_font("font", "HeaderMedium", header_medium_font)
        set_font("font", "HeaderSmall",  header_small_font)
        set_font("font", "Caption",      caption_font)
        set_font("font", "InfoText",     body_font)
        set_font("font", "PrimaryButton",   body_font)
        set_font("font", "SecondaryButton", body_font)
        set_font("font", "GhostButton",     body_font)
        set_font("font", "DangerButton",    body_font)
        set_font("font", "IconButton",      body_font)
        set_font("font", "FlatButton",      body_font)
        set_font("font", "CardPanel",       body_font)
        set_font("font", "HeroPanel",       header_medium_font)

        # ── Set per-variation font sizes (DESIGN_TOKENS §8.5 + tokens) ──
        set_font_size("font_size", "HeaderLarge",  tokens.h1)
        set_font_size("font_size", "HeaderMedium", tokens.h2)
        set_font_size("font_size", "HeaderSmall",  tokens.h2)
        set_font_size("font_size", "Caption",      tokens.label_)
        set_font_size("font_size", "InfoText",     tokens.body)
        set_font_size("font_size", "PrimaryButton",   tokens.body)
        set_font_size("font_size", "SecondaryButton", tokens.body)
        set_font_size("font_size", "GhostButton",     tokens.body)
        set_font_size("font_size", "DangerButton",    tokens.body)
        set_font_size("font_size", "IconButton",      tokens.body)
        set_font_size("font_size", "FlatButton",      tokens.body)
    ```

    Note: `tokens` is a Dictionary; access via `tokens.h1` (or `tokens["h1"]` if the GDScript runtime requires bracket access for Dictionary string keys).
  </action>
  <acceptance_criteria>
    - File contains `const TYPE_VARIATIONS: Dictionary = {`.
    - The TYPE_VARIATIONS dict contains all 13 entries: `"PrimaryButton"`, `"SecondaryButton"`, `"GhostButton"`, `"DangerButton"`, `"IconButton"`, `"FlatButton"`, `"HeaderLarge"`, `"HeaderMedium"`, `"HeaderSmall"`, `"Caption"`, `"InfoText"`, `"CardPanel"`, `"HeroPanel"`.
    - The Button-family entries map to `"Button"`; the Label-family entries map to `"Label"`; the Panel-family entries map to `"PanelContainer"`.
    - `_regenerate_theme()` body contains `for variation_name in TYPE_VARIATIONS.keys():`.
    - `_regenerate_theme()` body contains `set_type_variation(variation_name, base_type)` (or equivalent wrapped call).
    - `_regenerate_theme()` body contains 13 `set_font("font", "<variation>", ...)` calls (13 explicit fonts on 13 variations).
    - `_regenerate_theme()` body contains `preload("res://addons/neocade_theme/fonts/Inter-HeaderLarge.tres")`.
    - `_regenerate_theme()` body contains `preload("res://addons/neocade_theme/fonts/Inter-HeaderMedium.tres")`.
    - `_regenerate_theme()` body contains `preload("res://addons/neocade_theme/fonts/Inter-HeaderSmall.tres")`.
    - `_regenerate_theme()` body contains `preload("res://addons/neocade_theme/fonts/Inter-Body.tres")`.
    - `_regenerate_theme()` body contains `preload("res://addons/neocade_theme/fonts/Inter-Caption.tres")`.
    - `_regenerate_theme()` body contains at least 8 `set_font_size("font_size", "<variation>", ...)` calls.
  </acceptance_criteria>
  <verify>
    <automated>
      powershell -NoProfile -Command "$p='addons/neocade_theme/neocade_theme.gd'; $g=Get-Content -Raw $p; foreach($n in 'const TYPE_VARIATIONS: Dictionary = {','\"PrimaryButton\":   \"Button\"','\"SecondaryButton\": \"Button\"','\"GhostButton\":     \"Button\"','\"DangerButton\":    \"Button\"','\"IconButton\":      \"Button\"','\"FlatButton\":      \"Button\"','\"HeaderLarge\":  \"Label\"','\"HeaderMedium\": \"Label\"','\"HeaderSmall\":  \"Label\"','\"Caption\":      \"Label\"','\"InfoText\":     \"Label\"','\"CardPanel\": \"PanelContainer\"','\"HeroPanel\": \"PanelContainer\"','for variation_name in TYPE_VARIATIONS.keys():','set_type_variation(variation_name, base_type)','preload(\"res://addons/neocade_theme/fonts/Inter-HeaderLarge.tres\")','preload(\"res://addons/neocade_theme/fonts/Inter-HeaderMedium.tres\")','preload(\"res://addons/neocade_theme/fonts/Inter-HeaderSmall.tres\")','preload(\"res://addons/neocade_theme/fonts/Inter-Body.tres\")','preload(\"res://addons/neocade_theme/fonts/Inter-Caption.tres\")') { if ($g -notmatch [regex]::Escape($n)) { throw \"missing: $n\" } }; $font_calls = ([regex]::Matches($g, 'set_font\\(\"font\", \"\\w+\"')).Count; if ($font_calls -lt 13) { throw \"expected at least 13 set_font calls; got $font_calls\" }; $size_calls = ([regex]::Matches($g, 'set_font_size\\(\"font_size\"')).Count; if ($size_calls -lt 8) { throw \"expected at least 8 set_font_size calls; got $size_calls\" }"
    </automated>
  </verify>
  <done>13 type variations are registered with explicit fonts + sizes; PITFALLS 1.2 satisfied; SC#7's variation requirement is met.</done>
</task>

<task type="auto">
  <name>Task 2: Author BINDING_TABLE covering all 37 scorecard Controls</name>
  <read_first>
    - addons/neocade_theme/neocade_theme.gd
    - .planning/research/MINIMAL-THEME-COVERAGE-DELTA.md (37 scorecard rows)
    - .planning/research/MINIMAL-THEME-DISSECTION.md (per-Control state enumeration)
    - .planning/research/PITFALLS.md (1.1 state combinations, 1.6 integer pixels, 1.7 popups as first-class types, 10.3 clean state switching)
  </read_first>
  <files>
    - addons/neocade_theme/neocade_theme.gd (modify — author BINDING_TABLE constant)
  </files>
  <action>
    Author the `BINDING_TABLE` constant. The structure is a deeply-nested Dictionary with the following shape (excerpt for clarity; full version below):

    ```gdscript
    const BINDING_TABLE: Dictionary = {
        "Button": {
            "stylebox": {
                "normal":         {"role": "surface_panel", "raised_intensity": 0},
                "hover":          {"role": "state_hover",   "raised_intensity": 0},
                "pressed":        {"role": "state_pressed", "raised_intensity": 0},
                "focus":          {"role": "focus_ring"},
                "disabled":       {"role": "surface_panel", "alpha": 0.38},
                "hover_pressed":  {"role": "state_pressed", "raised_intensity": 0},
            },
            "color": {
                "font_color":          {"role": "text_strong"},
                "font_hover_color":    {"role": "text_strong"},
                "font_pressed_color":  {"role": "text_strong"},
                "font_focus_color":    {"role": "text_strong"},
                "font_disabled_color": {"role": "text_strong", "alpha": 0.38},
            },
            "constant": {
                "h_separation": {"value": "tokens.tapPadding"},
            },
        },
        # ... etc for every Control ...
    }
    ```

    The full BINDING_TABLE is too long to inline verbatim here, but the executor authors it directly using the 37-row scorecard from `MINIMAL-THEME-COVERAGE-DELTA.md` and the per-Control state lists from `MINIMAL-THEME-DISSECTION.md`. The executor MUST cover ALL 37 rows. The structure for each Control:

    ```gdscript
    "<ThemeType>": {
        "stylebox": { "<slot_name>": <recipe>, ... },
        "color":    { "<slot_name>": <recipe>, ... },
        "constant": { "<slot_name>": <recipe>, ... },
        "font_size":{ "<slot_name>": <recipe>, ... },  # if needed (most defer to type variations)
        "icon":     { "<slot_name>": <recipe>, ... },  # if needed (Button family + CheckBox + LineEdit + OptionButton + dialog close)
    }
    ```

    A `<recipe>` is a sub-dictionary that the iteration engine in Task 3 reads to compute the actual value:
    - `{"role": "<role-name>"}` — uses one of the derivation-block locals: `surface_base`, `surface_low`, `surface_panel`, `surface_high`, `surface_overlay`, `outline_color`, `accent_offset`, `surface_panel_offset`, `text_strong`, `text_default`, `text_muted`, `state_hover`, `state_pressed`, `role_primary`, `accent_rim`, `focus_ring` (special — constructed inline in iteration with the focus_thickness + outline expand semantics).
    - `{"role": "...", "alpha": 0.38}` — applies alpha to the role color.
    - `{"role": "...", "raised_intensity": <int>}` — for stylebox; if `raised=true`, the engine constructs a raised stylebox with `raised_strength * <factor>` shadow size; `raised_intensity` here is a multiplier (e.g., 0 = no raise on this slot, 1 = full raise, etc.). Phase 4 keeps `raised_intensity` simple (0 or 1); per-direction lift lists in §5 are Phase 5/6/7 polish.
    - `{"value": "tokens.<key>"}` — for constants/font_sizes; reads from the platform token table.
    - `{"icon": "<filename>"}` — for icons; references `addons/neocade_theme/icons/<filename>.svg`.

    The executor MUST cover at minimum the following slots for each Control (per MINIMAL-THEME-DISSECTION.md). The executor uses MINIMAL-THEME-COVERAGE-DELTA.md as the binding row list. For each row in the scorecard, every slot listed in the row's "Slots" column gets a recipe entry.

    **Critical Controls + their expected slot counts (from the scorecard):**

    | ThemeType | Approx slot count | PITFALLS notes |
    |---|---|---|
    | Button | 6 styleboxes (normal/hover/pressed/focus/disabled/hover_pressed) + 5+ font colors + h_separation constant | 10.3 (clean state switching); 1.1 (focus = ring not fill) |
    | CheckBox | 6 styleboxes + 4 icons (checked/unchecked + checkbox_disabled if needed) + colors | inherits Button states |
    | CheckButton | 6 styleboxes + 2 icons (on/off) + colors | use toggle_on/toggle_off icons |
    | OptionButton | 6 styleboxes + 1 icon (arrow) + colors | use arrow_down |
    | MenuButton | 6 styleboxes + colors | similar to Button |
    | LinkButton | colors only (font_color + states); no styleboxes | TextButton variant |
    | LineEdit | normal/focus/read_only styleboxes + caret + selection + clear icon + font colors | 3+ styleboxes |
    | TextEdit | normal/focus/read_only styleboxes + colors | similar to LineEdit |
    | CodeEdit | inherits TextEdit; no syntax highlighting (AF-7) | base styleboxes only |
    | RichTextLabel | normal stylebox + font_color + font_size + selection_color | minimal |
    | Label | font_color + font_size constants | minimal |
    | SpinBox | inherits LineEdit + UP/DOWN constants | composed |
    | ProgressBar | background stylebox + fill stylebox + font_color | 2 styleboxes |
    | HSlider / VSlider | grabber/grabber_highlight/grabber_disabled/grabber_area styleboxes | 4 styleboxes each |
    | HScrollBar / VScrollBar | scroll/grabber/grabber_highlight/grabber_pressed | 4 styleboxes each |
    | Tree | All 16 styleboxes per dissection (panel/focus/cursor/cursor_unfocused/selected/selected_focus/button_pressed/title_button_normal/title_button_pressed/title_button_hover/custom_button/custom_button_pressed/custom_button_hover) + font colors + arrow icons + indent constants | 16 stylebox slots |
    | ItemList | panel/focus/cursor/selected/cursor_unfocused/selected_focus styleboxes + font + colors | ~6 styleboxes |
    | TabBar / TabContainer | tab_unselected/tab_selected/tab_disabled/tab_focus/panel/tabbar_background styleboxes + tab font colors + h_separation | composed; ~6 styleboxes |
    | PanelContainer | panel stylebox | 1 stylebox |
    | PopupPanel | panel stylebox | 1 stylebox; popups are first-class types per PITFALLS 1.7 |
    | PopupMenu | panel/hover/separator/labeled_separator_left/labeled_separator_right/checked/unchecked/radio_checked/radio_unchecked/submenu styleboxes + icons | ~10 styleboxes; first-class type |
    | TooltipPanel | panel stylebox | first-class type |
    | AcceptDialog / ConfirmationDialog / FileDialog | panel + buttons inherit; FileDialog has additional file/folder icons (Phase 7 polish) | minimal Phase 4 coverage |
    | Window | embedded_border + embedded_unfocused_border styleboxes + close_h_offset + title_height + title_color | 2 styleboxes; first-class type |
    | HSeparator / VSeparator | separator stylebox | minimal |
    | HFlowContainer / SplitContainer | h_separation / v_separation constants + grabber stylebox (split) | minimal |
    | ColorPicker / ColorPickerButton | inherits Button; ColorPicker icons defer to Phase 7 | minimal Phase 4 baseline |
    | GraphEdit / GraphFrame / GraphNode | minimal Phase 4 baseline; full coverage Phase 7 | minimum: panel + frame styleboxes, default colors |
    | MenuBar | inherits Button + h_separation | minimal |

    **Phase 4 baseline depth per CONTEXT.md D-07:** every Control gets EVERY required slot listed in its scorecard row populated by the BINDING_TABLE. Phases 5/6/7 then become per-direction polish + per-type-variation override authoring + Pitfall 1.1 state combos for the Button family.

    Implementation strategy:
    1. Open `MINIMAL-THEME-COVERAGE-DELTA.md` and `MINIMAL-THEME-DISSECTION.md`. Identify every Control's required slots.
    2. Author BINDING_TABLE entries one Control at a time. The executor copies the slot lists from the dissection verbatim; recipe selection follows the M3 + flat-MD3 mapping (states use state_hover/state_pressed; surfaces use surface_panel/surface_high/etc.; outlines use outline_color; text uses text_strong/text_default).
    3. Critical PITFALLS to enforce in BINDING_TABLE structure:
       - Tree: all 16 styleboxes present.
       - LineEdit / TextEdit / CodeEdit: normal + focus + read_only styleboxes (state_hover/pressed are not standard for line inputs; use focus + caret_color for active state).
       - PopupMenu: panel + hover + separator + labeled_separator slots (PITFALLS 1.7 first-class).
       - Window: embedded_border + embedded_unfocused_border (PITFALLS 1.7 first-class).
       - HScrollBar / VScrollBar: 4 separate slots (scroll, grabber, grabber_highlight, grabber_pressed).
       - Constants for spacing use `{"value": "tokens.tapPadding"}` (engine reads tokens at iteration time).
       - All `corner_radius` / `border_width` / `content_margin` / `expand_margin` values are int (PITFALLS 1.6).

    The BINDING_TABLE should be ~600-1000 lines. The executor authors it inline in `neocade_theme.gd`.

    Place the constant near the top of the file (after `enum Platform`, before the `@export` block) OR after `TYPE_VARIATIONS` — wherever the file's top-of-file vs bottom-of-file constant convention is set. Recommended: bottom of file alongside `TYPE_VARIATIONS`, since both are file-scope constants consumed by `_regenerate_theme()`.
  </action>
  <acceptance_criteria>
    - File contains `const BINDING_TABLE: Dictionary = {`.
    - BINDING_TABLE contains keys for all 37 scorecard Controls listed in must_haves[1]: `"AcceptDialog"`, `"Button"`, `"CheckBox"`, `"CheckButton"`, `"CodeEdit"`, `"ColorPicker"`, `"ColorPickerButton"`, `"ConfirmationDialog"`, `"FileDialog"`, `"GraphEdit"`, `"GraphFrame"`, `"GraphNode"`, `"HFlowContainer"`, `"HScrollBar"`, `"HSeparator"`, `"HSlider"`, `"ItemList"`, `"Label"`, `"LineEdit"`, `"LinkButton"`, `"MenuBar"`, `"MenuButton"`, `"OptionButton"`, `"PanelContainer"`, `"PopupMenu"`, `"PopupPanel"`, `"ProgressBar"`, `"RichTextLabel"`, `"SpinBox"`, `"SplitContainer"`, `"TabBar"`, `"TabContainer"`, `"TextEdit"`, `"TooltipPanel"`, `"Tree"`, `"VScrollBar"`, `"VSeparator"`, `"VSlider"`, `"Window"` (38 keys; the executor selects 37 — drops one of the Container types if FEATURES.md says it's layout-only-no-theme; or adds one if dissection says we missed; verify count via grep).
    - Tree's stylebox subdict has at least 12 keys (per PITFALLS dissection — Tree has 16 styleboxes; minimum threshold 12 to pass).
    - LineEdit's stylebox subdict has at least 3 keys (`normal`, `focus`, `read_only`).
    - PopupMenu's stylebox subdict has at least 5 keys (`panel`, `hover`, `separator`, `labeled_separator_left`, `labeled_separator_right`).
    - Window's stylebox subdict has at least 2 keys (`embedded_border`, `embedded_unfocused_border`).
    - HScrollBar's stylebox subdict has at least 4 keys (`scroll`, `grabber`, `grabber_highlight`, `grabber_pressed`).
    - Button's stylebox subdict has at least 6 keys (`normal`, `hover`, `pressed`, `focus`, `disabled`, `hover_pressed`).
    - The literal substring `BINDING_TABLE` appears at least 4 times in the file (the const declaration + at least 3 references in `_regenerate_theme()` for keys/values/iteration).
    - File line count is between 800 and 2500 lines (sanity check; the BINDING_TABLE alone bloats to several hundred lines).
  </acceptance_criteria>
  <verify>
    <automated>
      powershell -NoProfile -Command "$p='addons/neocade_theme/neocade_theme.gd'; $g=Get-Content -Raw $p; if ($g -notmatch 'const BINDING_TABLE: Dictionary = \\{') { throw 'BINDING_TABLE constant missing' }; foreach($t in 'AcceptDialog','Button','CheckBox','CheckButton','CodeEdit','ColorPicker','ColorPickerButton','ConfirmationDialog','FileDialog','GraphEdit','GraphFrame','GraphNode','HFlowContainer','HScrollBar','HSeparator','HSlider','ItemList','Label','LineEdit','LinkButton','MenuBar','MenuButton','OptionButton','PanelContainer','PopupMenu','PopupPanel','ProgressBar','RichTextLabel','SpinBox','SplitContainer','TabBar','TabContainer','TextEdit','TooltipPanel','Tree','VScrollBar','VSeparator','VSlider','Window') { if ($g -notmatch ('\"' + $t + '\":')) { throw \"BINDING_TABLE missing key: $t\" } }; $bt_refs = ([regex]::Matches($g, 'BINDING_TABLE')).Count; if ($bt_refs -lt 4) { throw \"BINDING_TABLE referenced only $bt_refs times; expected >=4\" }; $lines = (Get-Content $p | Measure-Object -Line).Lines; if ($lines -lt 800 -or $lines -gt 2500) { throw \"file line count $lines outside 800-2500 sanity bounds\" }"
    </automated>
  </verify>
  <done>BINDING_TABLE covers all 37 scorecard Controls with their PITFALLS-aligned slots; the file is the iteration engine's source of truth for additive theme population.</done>
</task>

<task type="auto">
  <name>Task 3: Implement the BINDING_TABLE iteration walk in _regenerate_theme()</name>
  <read_first>
    - addons/neocade_theme/neocade_theme.gd
    - .planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-CONTEXT.md (D-01 ADDITIVE iteration; D-04 escape hatch)
    - .planning/DESIGN_TOKENS.md (§7.3 Pitfall 1.1 state combinations)
  </read_first>
  <files>
    - addons/neocade_theme/neocade_theme.gd (modify — extend _regenerate_theme body with iteration walk + recipe-resolution helper)
  </files>
  <action>
    Add a helper method that resolves a recipe to a concrete value, given the derivation-block locals. The helper signature:

    ```gdscript

    # ─── Recipe resolution (Plan 04-05 iteration engine helper) ─────────────────────────────────

    ## Resolves a BINDING_TABLE recipe to a concrete value, given the precomputed derivation block.
    ## `data_type` is "stylebox", "color", "constant", "font_size", or "icon".
    ## Returns null if the recipe references an unknown role or icon (caller skips silently — D-04).
    func _resolve_recipe(recipe: Dictionary, data_type: String, role_table: Dictionary, tokens: Dictionary) -> Variant:
        if data_type == "stylebox":
            var role: String = recipe.get("role", "surface_panel")
            var raised_intensity: int = recipe.get("raised_intensity", 0)
            var alpha: float = recipe.get("alpha", 1.0)
            if role == "focus_ring":
                # Focus ring is a special stylebox: transparent bg, accent border, expand outside corner.
                var sb := StyleBoxFlat.new()
                sb.bg_color = Color(0, 0, 0, 0)
                sb.border_color = role_table.role_primary
                sb.border_width_left = focus_thickness
                sb.border_width_top = focus_thickness
                sb.border_width_right = focus_thickness
                sb.border_width_bottom = focus_thickness
                sb.corner_radius_top_left = corner_radius
                sb.corner_radius_top_right = corner_radius
                sb.corner_radius_bottom_left = corner_radius
                sb.corner_radius_bottom_right = corner_radius
                sb.expand_margin_left = 2
                sb.expand_margin_top = 2
                sb.expand_margin_right = 2
                sb.expand_margin_bottom = 2
                sb.shadow_size = -1
                return sb
            var bg_color: Color = role_table.get(role, role_table.surface_panel)
            if alpha < 1.0:
                bg_color = Color(bg_color.r, bg_color.g, bg_color.b, alpha)
            # Pick the matching offset color (per §6.3) for the bg's family.
            var offset_color: Color = role_table.get(role + "_offset", role_table.surface_panel_offset)
            var sb_intensity: int = raised_strength * raised_intensity if raised else 0
            var sb := _make_raised_stylebox(bg_color, offset_color, sb_intensity)
            sb.corner_radius_top_left = corner_radius
            sb.corner_radius_top_right = corner_radius
            sb.corner_radius_bottom_left = corner_radius
            sb.corner_radius_bottom_right = corner_radius
            sb.border_color = role_table.outline_color
            sb.border_width_left = outline_width
            sb.border_width_top = outline_width
            sb.border_width_right = outline_width
            sb.border_width_bottom = outline_width
            sb.content_margin_left = spacing
            sb.content_margin_top = int(spacing * 0.6)
            sb.content_margin_right = spacing
            sb.content_margin_bottom = int(spacing * 0.6)
            return sb
        elif data_type == "color":
            var role: String = recipe.get("role", "text_strong")
            var alpha: float = recipe.get("alpha", 1.0)
            var c: Color = role_table.get(role, role_table.text_strong)
            if alpha < 1.0:
                c = Color(c.r, c.g, c.b, alpha)
            return c
        elif data_type == "constant" or data_type == "font_size":
            var value_ref: String = recipe.get("value", "")
            if value_ref.begins_with("tokens."):
                var key: String = value_ref.substr(7)
                return tokens.get(key, 0)
            return int(recipe.get("value", 0))
        elif data_type == "icon":
            var icon_name: String = recipe.get("icon", "")
            if icon_name == "": return null
            var path: String = "res://addons/neocade_theme/icons/" + icon_name + ".svg"
            var icon: Texture2D = load(path) as Texture2D
            return icon
        return null
    ```

    Then in `_regenerate_theme()` body, AFTER the variation-registration block from Task 1 and BEFORE `_last_regeneration_usec`, add the BINDING_TABLE walk:

    ```gdscript
        # ── Build role lookup table from derivation locals (Plan 04-04) ──
        var role_table: Dictionary = {
            "surface_base":          surface_base,
            "surface_low":           surface_low,
            "surface_panel":         surface_panel,
            "surface_high":          surface_high,
            "surface_overlay":       surface_overlay,
            "outline_color":         outline_color,
            "accent_offset":         accent_offset,
            "surface_high_offset":   surface_high_offset,
            "surface_panel_offset":  surface_panel_offset,
            "surface_overlay_offset":surface_overlay_offset,
            "surface_low_offset":    surface_low_offset,
            "text_strong":           text_strong,
            "text_default":          text_default,
            "text_muted":            text_muted,
            "state_hover":           state_hover,
            "state_pressed":         state_pressed,
            "role_primary":          role_primary,
            "accent_rim":            accent_rim,
        }

        # ── Walk BINDING_TABLE — additive iteration; entries not in table are LEFT UNTOUCHED (D-04) ──
        for theme_type in BINDING_TABLE.keys():
            var type_block: Dictionary = BINDING_TABLE[theme_type]
            for data_type in type_block.keys():
                var slots: Dictionary = type_block[data_type]
                for slot_name in slots.keys():
                    var recipe: Dictionary = slots[slot_name]
                    var value = _resolve_recipe(recipe, data_type, role_table, tokens)
                    if value == null: continue  # D-04 escape hatch — recipe failed; leave slot alone
                    if data_type == "stylebox":
                        set_stylebox(slot_name, theme_type, value)
                    elif data_type == "color":
                        set_color(slot_name, theme_type, value)
                    elif data_type == "constant":
                        set_constant(slot_name, theme_type, int(value))
                    elif data_type == "font_size":
                        set_font_size(slot_name, theme_type, int(value))
                    elif data_type == "icon":
                        set_icon(slot_name, theme_type, value)
    ```

    This walk is the additive iteration engine. It uses Godot's standard `set_*(slot, type, value)` methods on the Theme. There is NO `clear()` call — entries not in BINDING_TABLE are untouched (the D-04 escape hatch lets Theme Editor authored content survive).

    Note on iteration order: Godot's Dictionary iteration in Godot 4.6 is insertion-ordered, so the BINDING_TABLE keys iterate in declaration order. This is sufficient for additive iteration; entries within a Control type don't depend on each other.
  </action>
  <acceptance_criteria>
    - File contains `func _resolve_recipe(recipe: Dictionary, data_type: String, role_table: Dictionary, tokens: Dictionary) -> Variant:`.
    - `_resolve_recipe` body branches on `data_type` for `"stylebox"`, `"color"`, `"constant"`, `"font_size"`, `"icon"`.
    - `_resolve_recipe` calls `_make_raised_stylebox(bg_color, offset_color, sb_intensity)` for the stylebox branch.
    - `_resolve_recipe` handles the special role `"focus_ring"` by constructing a focus-styled StyleBoxFlat with `border_width_*` = `focus_thickness`.
    - `_regenerate_theme()` body contains a `var role_table: Dictionary = {` declaration with at least 16 entries.
    - `_regenerate_theme()` body contains `for theme_type in BINDING_TABLE.keys():`.
    - The walk contains nested `for data_type in type_block.keys():` and `for slot_name in slots.keys():`.
    - The walk contains all 5 set methods: `set_stylebox(slot_name, theme_type, value)`, `set_color(slot_name, theme_type, value)`, `set_constant(slot_name, theme_type, int(value))`, `set_font_size(slot_name, theme_type, int(value))`, `set_icon(slot_name, theme_type, value)`.
    - The walk contains a null-check (`if value == null: continue`) implementing the D-04 escape hatch.
    - The string `clear()` does NOT appear in `_regenerate_theme()` or any helper it calls (D-01 invariant; check entire file).
  </acceptance_criteria>
  <verify>
    <automated>
      powershell -NoProfile -Command "$p='addons/neocade_theme/neocade_theme.gd'; $g=Get-Content -Raw $p; foreach($n in 'func _resolve_recipe(recipe: Dictionary, data_type: String, role_table: Dictionary, tokens: Dictionary) -> Variant:','if data_type == \"stylebox\":','if data_type == \"color\":','elif data_type == \"constant\"','elif data_type == \"font_size\":','elif data_type == \"icon\":','_make_raised_stylebox(bg_color, offset_color, sb_intensity)','if role == \"focus_ring\":','var role_table: Dictionary = {','for theme_type in BINDING_TABLE.keys():','for data_type in type_block.keys():','for slot_name in slots.keys():','set_stylebox(slot_name, theme_type, value)','set_color(slot_name, theme_type, value)','set_constant(slot_name, theme_type, int(value))','set_font_size(slot_name, theme_type, int(value))','set_icon(slot_name, theme_type, value)','if value == null: continue') { if ($g -notmatch [regex]::Escape($n)) { throw \"missing: $n\" } }; if ($g -match '\\bclear\\(\\)') { throw 'clear() call found — D-01 forbids' }; $rt_lines = ([regex]::Matches($g, '\":\\s+(surface|outline_color|accent|text|state|role|accent_rim)')).Count; if ($rt_lines -lt 14) { throw \"role_table has $rt_lines entries; expected >=14\" }"
    </automated>
  </verify>
  <done>The additive iteration walk populates every BINDING_TABLE entry; entries not in the table survive (D-04); clear() is forbidden (D-01); SC#7 is achievable on a feature-complete Pulse load.</done>
</task>

<task type="auto">
  <name>Task 4: Atomic commit — BINDING_TABLE + iteration engine + variations + icons</name>
  <read_first>
    - addons/neocade_theme/neocade_theme.gd
  </read_first>
  <files>(commit only)</files>
  <action>
    Stage `addons/neocade_theme/neocade_theme.gd` and commit:

    ```
    feat(04-05): BINDING_TABLE + iteration engine + 13 variations + icon binding

    Plan 04-05 wave-2 engine (depends on Plans 04-01..04):
    - TYPE_VARIATIONS const declares 13 NeoCade variations (PrimaryButton/
      SecondaryButton/GhostButton/DangerButton/IconButton/FlatButton/HeaderLarge/
      HeaderMedium/HeaderSmall/Caption/InfoText/CardPanel/HeroPanel)
    - _regenerate_theme() registers all 13 via set_type_variation() with explicit
      fonts (PITFALLS 1.2 mandate) + per-variation font_sizes from platform tokens
    - BINDING_TABLE const covers all 37 scorecard Control rows from
      MINIMAL-THEME-COVERAGE-DELTA.md with PITFALLS-aligned slot lists:
      Tree (16 styleboxes), LineEdit (3), PopupMenu (5+), Window (2), HScrollBar (4)
    - _resolve_recipe() helper resolves recipes to concrete values; focus_ring slot
      receives a special stylebox (transparent bg + accent border + expand_margin
      = OUTSIDE corner radius per PITFALLS 1.1)
    - _regenerate_theme() walks BINDING_TABLE additively (D-01 invariant: no clear();
      D-04 escape hatch: entries not in table are untouched, Theme Editor authored
      content survives)
    - Icon binding wires the 10 Button-family SVGs from Plan 04-03 to CheckBox /
      RadioButton / CheckButton / OptionButton / LineEdit clear / dialog close slots

    Refs: FOUND-02 (full _regenerate_theme body), ICON-02 (wiring), TYPEVAR-01..05
    Plan: 04-05
    ```

    `git add addons/neocade_theme/neocade_theme.gd`; `git commit -m "..."`. Do NOT push.
  </action>
  <acceptance_criteria>
    - `git log -1 --pretty=%s` returns a subject line starting with `feat(04-05):`.
    - `git log -1 --name-status` shows `M addons/neocade_theme/neocade_theme.gd`.
    - `git status --porcelain` is empty for `addons/neocade_theme/neocade_theme.gd`.
  </acceptance_criteria>
  <verify>
    <automated>
      powershell -NoProfile -Command "$msg = git log -1 --pretty=%s; if ($msg -notmatch '^feat\\(04-05\\):') { throw \"commit subject wrong: $msg\" }; $ns = git log -1 --name-status; if ($ns -notmatch 'M\\s+addons/neocade_theme/neocade_theme\\.gd') { throw 'commit missing neocade_theme.gd modification' }; $st = git status --porcelain | Where-Object { $_ -match 'addons/neocade_theme/neocade_theme\\.gd' }; if ($st) { throw 'unexpected leftover changes' }"
    </automated>
  </verify>
  <done>The iteration engine + BINDING_TABLE + variations + icon binding land as a single atomic Wave 2 commit. The class is feature-complete; Plans 04-06/07 ship `.tres` data only.</done>
</task>

</tasks>
