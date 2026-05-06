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
    - "**D-06** Phase 4 baseline coverage achieved here: this plan ships the BINDING_TABLE + iteration engine that produces the 37/37 baseline pass — the binding table covers every one of the 37 scorecard Controls (CANONICAL list frozen below; Cross-AI Cycle 1 C1 fix) so SC#7 closes by Phase 4 end."
    - "**D-07** Baseline depth is full formula state coverage: the BINDING_TABLE entries authored by this plan populate Button's normal/hover/pressed/focus/disabled/hover_pressed; Tree's 16 styleboxes; LineEdit's normal/focus/read_only; PopupMenu's panel/hover/separator + labeled separators; Window's embedded_border/embedded_unfocused_border; HScrollBar's scroll/grabber/grabber_highlight/grabber_pressed. Phases 5/6/7 are POLISH passes only."
    - "**D-09** SC#7 is read STRICTLY here: every Control type has every required slot present (formula-derived) + every variation type registered with its required fonts; verified via Plan 04-06's `_phase4_verify.gd` helper. Final COV-10 check happens in Phase 10."
    - "`addons/neocade_theme/neocade_theme.gd` declares a constant `BINDING_TABLE` (a `Dictionary` compiled into the file) keyed by `theme_type` → `data_type` (`stylebox`/`color`/`constant`/`font_size`/`icon`) → `slot_name` → recipe metadata. **Cross-AI Cycle 2 N1 fix:** the `font` data type is REMOVED from the schema — per-Control fonts go through `theme.default_font` (set by Plan 04-04 derivation block) and explicit `set_font()` calls on the 14 type variations (PITFALLS 1.2). No base Control needs a per-slot font binding (verified against MINIMAL-THEME-DISSECTION.md: zero base Controls set `font` slots in upstream)."
    - "**CANONICAL 37 ROW FREEZE (Cross-AI Cycle 1 C1 fix; sourced verbatim from MINIMAL-THEME-COVERAGE-DELTA.md §Coverage Scorecard):** AcceptDialog, Button, CheckBox, CheckButton, CodeEdit, ColorPicker, ColorPickerButton, ConfirmationDialog, FileDialog, FoldableContainer, GraphEdit, HScrollBar, HSlider, HSplitContainer, ItemList, Label, LineEdit, LinkButton, MenuBar, MenuButton, OptionButton, Panel, PopupMenu, PopupPanel, ProgressBar, RichTextLabel, SpinBox, TabBar, TabContainer, TextEdit, TooltipLabel, TooltipPanel, Tree, VScrollBar, VSlider, VSplitContainer, Window. **Count = 37 exact. NO executor discretion to add or drop. NO 'select 37 from 39'.** Bucket reconciliation: 24 themed-in-upstream + 1 Window-via-subclass + 2 bare-class-unthemed (MenuBar, Panel) + 2 container-chrome-constants-only (HSplitContainer, VSplitContainer) + 8 NeoCade-additive (CodeEdit, ColorPickerButton, ConfirmationDialog, FileDialog, FoldableContainer, LinkButton, SpinBox, TooltipLabel) = 37."
    - "`TYPE_VARIATIONS` constant declares all **14** NeoCade type variations (Cross-AI Cycle 1 C4 fix: pick 14 with CodeLabel INCLUDED — the correct enumeration of TYPEVAR-01..04 + TYPEVAR-05): PrimaryButton, SecondaryButton, GhostButton, DangerButton, IconButton, FlatButton (6 Button) + HeaderLarge, HeaderMedium, HeaderSmall, Caption, CodeLabel (5 Label) + InfoText (1 RichTextLabel/Label) + CardPanel, HeroPanel (2 PanelContainer) = 14."
    - "`_regenerate_theme()` body now walks `BINDING_TABLE`: for each `(theme_type, data_type, slot_name)`, computes the recipe value from the derived locals (Plan 04-04) + the per-Control parameter context, and calls `set_stylebox(slot_name, theme_type, sb)` / `set_color(...)` / `set_constant(...)` / `set_font_size(...)` / `set_icon(...)`. (Cross-AI Cycle 2 N1 fix: NO `set_font` branch — per-Control fonts are NOT a BINDING_TABLE concept; the only font bindings come from `default_font` + the 14 explicit type-variation `set_font` calls in Task 1.)"
    - "Iteration is ADDITIVE — entries not in BINDING_TABLE are LEFT UNTOUCHED (D-04 escape hatch). The walk uses `set_*(name, type, value)` directly and does NOT call `clear()` (D-01 invariant)."
    - "**Cross-AI Cycle 2 C1 fix — CANONICAL_SLOT_NAMES freeze.** A sibling const `CANONICAL_SLOT_NAMES: Dictionary` declares the EXACT slot-name list per Control type for the most-complex Controls (Tree 16 styleboxes; Button 6 styleboxes + 5 colors; LineEdit 3 styleboxes; PopupMenu 5 styleboxes + 3 constants; Window 2 styleboxes; HScrollBar 4 styleboxes; VScrollBar 4 styleboxes; OptionButton 6 styleboxes + 1 constant + arrow icon; CheckBox 4 icons; CheckButton 2 icons; ItemList 6+ styleboxes; TabBar 5 styleboxes + 8 colors). Slot names are sourced VERBATIM from `MINIMAL-THEME-DISSECTION.md` (the live-verified-from-godot-minimal-theme dissection). Plan 04-06's verifier iterates `CANONICAL_SLOT_NAMES` and asserts each declared slot exists on the loaded theme via `theme.has_stylebox/color/constant/font_size/icon(slot_name, theme_type)` — this guarantees correct slot-name strings, not just row counts."
    - "**Cross-AI Cycle 2 C2 fix — disabled alpha sourced from presets.** `_resolve_recipe()` reads `disabled_opacity` from the per-direction `presets` dictionary (Plan 04-04 DIRECTION_PRESETS). The Button.disabled / Button.font_disabled_color / etc. recipes use `disabled_opacity` (a float passed in) instead of hard-coded `0.38`. Recipes carry a `\"disabled\": true` flag (or equivalent) to opt into the per-direction alpha, replacing the previous `\"alpha\": 0.38` literal."
    - "**Cross-AI Cycle 2 M2 fix — platform-aware stylebox margins.** `_resolve_recipe()`'s stylebox branch multiplies content_margin by `tokens.densityScale` and adds `tokens.tapPadding` so MOBILE platform produces visibly larger Button.normal margins than DESKTOP (Plan 04-06's MOBILE-toggle assertion can now observe the change)."
    - "`_regenerate_theme()` calls `set_type_variation(variation, base_type)` for all 14 variations registered in `TYPE_VARIATIONS`."
    - "**Cross-AI Cycle 1 C3 fix:** `_regenerate_theme()` sets `default_font = preload(\"res://addons/neocade_theme/fonts/Inter-Body.tres\")` and `default_font_size = tokens.body` BEFORE the BINDING_TABLE walk, so any Control type that lacks an explicit per-type font entry still renders in Inter at the correct platform size (FONT-06 closure)."
    - "Each variation that needs a font has an explicit `set_font(\"font\", variation, ...)` call (PITFALLS 1.2 — variations don't inherit fonts from base type). HeaderLarge/HeaderMedium/HeaderSmall reference the matching FontVariation from Plan 04-02; Caption + InfoText reference Inter-Caption.tres / Inter-Body.tres; CodeLabel uses Inter-Body.tres + a CHANGELOG note that consumers can override with their preferred mono per FONT-04 stricken (consumer override pattern documented in README, Plan 04-08)."
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
Author the `BINDING_TABLE` (the data structure that maps every Control's theme entries to derivation-block-driven recipes), the sibling `CANONICAL_SLOT_NAMES` slot-name freeze, and the `TYPE_VARIATIONS` table; rewrite `_regenerate_theme()` to walk both tables and populate Theme entries via `set_stylebox` / `set_color` / `set_constant` / `set_font_size` / `set_icon` (additive only; per-Control fonts NOT included — Cross-AI Cycle 2 N1 fix); register all 14 NeoCade type variations with explicit fonts per PITFALLS 1.2; wire the 10 Button-family icons (Plan 04-03) to their Theme slots.

Purpose: produce the additive iteration engine that turns the `@export` properties + derived locals (Plan 04-04) into a fully-populated Theme covering all 37 scorecard Control rows + 14 type variations — the SC#7 hard requirement for Phase 4 close.
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

After this plan, `_regenerate_theme()` is feature-complete: loading any direction `.tres` yields a Theme with entries for all 37 scorecard Controls + 14 variations populated. Plans 04-06 (Pulse `.tres`) and 04-07 (Slate/Bubble/Daybreak/Burst `.tres`) only set `@export` values; the engine does the rest.
</interfaces>
</context>

<tasks>

<task type="auto">
  <name>Task 1: Author the TYPE_VARIATIONS constant + register variations in _regenerate_theme()</name>
  <read_first>
    - addons/neocade_theme/neocade_theme.gd
    - .planning/research/FEATURES.md (type variations table; 14 variations per Cross-AI Cycle 1 C4)
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
    ## 14 NeoCade type variations registered via Theme.set_type_variation() (Cross-AI Cycle 1 C4
    ## fix: PICK 14 with CodeLabel INCLUDED — the correct enumeration of TYPEVAR-01..04+05).
    ## Each entry: variation_name → base_type. Phases 5/6/7 author per-direction personality
    ## styleboxes per variation in `.tres` Theme Editor overrides; Phase 4 only registers + sets
    ## explicit fonts (Pitfall 1.2: variations don't inherit fonts from base type).
    const TYPE_VARIATIONS: Dictionary = {
        # Button family (TYPEVAR-01) — 6
        "PrimaryButton":   "Button",
        "SecondaryButton": "Button",
        "GhostButton":     "Button",
        "DangerButton":    "Button",
        "IconButton":      "Button",
        "FlatButton":      "Button",
        # Label / heading family (TYPEVAR-02 + TYPEVAR-03) — 5
        "HeaderLarge":  "Label",
        "HeaderMedium": "Label",
        "HeaderSmall":  "Label",
        "Caption":      "Label",
        "CodeLabel":    "Label",     # Cross-AI Cycle 1 C4 fix: INCLUDED (was previously dropped)
        # InfoText (TYPEVAR-05; rich-text small body) — 1
        "InfoText":     "RichTextLabel",
        # Panel family (TYPEVAR-04) — 2
        "CardPanel": "PanelContainer",
        "HeroPanel": "PanelContainer",
    }
    ```

    Rationale: **14 entries exact** (6 Button + 5 Label + 1 RichTextLabel + 2 Panel = 14 — Cross-AI Cycle 1 C4 fix). The COUNT is binding: 14 variations.

    Then in `_regenerate_theme()` body, AFTER the derivation block (Plan 04-04) and BEFORE the `_last_regeneration_usec` line, add the default-font block + variation-registration block:

    ```gdscript
        # ── Theme defaults (Cross-AI Cycle 1 C3 fix; FONT-06 closure) ──
        # Set the theme-level default_font + default_font_size BEFORE the BINDING_TABLE walk
        # so any Control type without an explicit per-type font entry still renders in Inter.
        var body_font := preload("res://addons/neocade_theme/fonts/Inter-Body.tres") as FontVariation
        default_font = body_font
        default_font_size = tokens.body

        # ── Register type variations (DESIGN_TOKENS §8.5; PITFALLS 1.2) ──
        for variation_name in TYPE_VARIATIONS.keys():
            var base_type: String = TYPE_VARIATIONS[variation_name]
            set_type_variation(variation_name, base_type)

        # ── Set explicit fonts on header variations (PITFALLS 1.2 mandate) ──
        var header_large_font  := preload("res://addons/neocade_theme/fonts/Inter-HeaderLarge.tres") as FontVariation
        var header_medium_font := preload("res://addons/neocade_theme/fonts/Inter-HeaderMedium.tres") as FontVariation
        var header_small_font  := preload("res://addons/neocade_theme/fonts/Inter-HeaderSmall.tres") as FontVariation
        var caption_font       := preload("res://addons/neocade_theme/fonts/Inter-Caption.tres") as FontVariation
        # 14 variations × set_font (Cross-AI Cycle 1 C4 fix: CodeLabel included)
        set_font("font", "HeaderLarge",  header_large_font)
        set_font("font", "HeaderMedium", header_medium_font)
        set_font("font", "HeaderSmall",  header_small_font)
        set_font("font", "Caption",      caption_font)
        set_font("font", "CodeLabel",    body_font)   # consumer can override to a mono per FONT-04 stricken
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
        set_font_size("font_size", "CodeLabel",    tokens.label_)
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
    - The TYPE_VARIATIONS dict contains all **14** entries (Cross-AI Cycle 1 C4 fix): `"PrimaryButton"`, `"SecondaryButton"`, `"GhostButton"`, `"DangerButton"`, `"IconButton"`, `"FlatButton"`, `"HeaderLarge"`, `"HeaderMedium"`, `"HeaderSmall"`, `"Caption"`, `"CodeLabel"`, `"InfoText"`, `"CardPanel"`, `"HeroPanel"`.
    - The Button-family entries map to `"Button"`; the Label-family entries map to `"Label"`; the Panel-family entries map to `"PanelContainer"`; InfoText maps to `"RichTextLabel"`.
    - `_regenerate_theme()` body contains `default_font = body_font` and `default_font_size = tokens.body` (Cross-AI Cycle 1 C3 fix; FONT-06 closure).
    - `_regenerate_theme()` body contains `for variation_name in TYPE_VARIATIONS.keys():`.
    - `_regenerate_theme()` body contains `set_type_variation(variation_name, base_type)` (or equivalent wrapped call).
    - `_regenerate_theme()` body contains **14** `set_font("font", "<variation>", ...)` calls (14 explicit fonts on 14 variations).
    - `_regenerate_theme()` body contains `set_font("font", "CodeLabel", body_font)` (Cross-AI Cycle 1 C4 fix: CodeLabel restored).
    - `_regenerate_theme()` body contains `preload("res://addons/neocade_theme/fonts/Inter-HeaderLarge.tres")`.
    - `_regenerate_theme()` body contains `preload("res://addons/neocade_theme/fonts/Inter-HeaderMedium.tres")`.
    - `_regenerate_theme()` body contains `preload("res://addons/neocade_theme/fonts/Inter-HeaderSmall.tres")`.
    - `_regenerate_theme()` body contains `preload("res://addons/neocade_theme/fonts/Inter-Body.tres")`.
    - `_regenerate_theme()` body contains `preload("res://addons/neocade_theme/fonts/Inter-Caption.tres")`.
    - `_regenerate_theme()` body contains at least 12 `set_font_size("font_size", "<variation>", ...)` calls.
  </acceptance_criteria>
  <verify>
    <automated>
      powershell -NoProfile -Command "$p='addons/neocade_theme/neocade_theme.gd'; $g=Get-Content -Raw $p; foreach($n in 'const TYPE_VARIATIONS: Dictionary = {','\"PrimaryButton\":   \"Button\"','\"SecondaryButton\": \"Button\"','\"GhostButton\":     \"Button\"','\"DangerButton\":    \"Button\"','\"IconButton\":      \"Button\"','\"FlatButton\":      \"Button\"','\"HeaderLarge\":  \"Label\"','\"HeaderMedium\": \"Label\"','\"HeaderSmall\":  \"Label\"','\"Caption\":      \"Label\"','\"CodeLabel\":    \"Label\"','\"InfoText\":     \"RichTextLabel\"','\"CardPanel\": \"PanelContainer\"','\"HeroPanel\": \"PanelContainer\"','for variation_name in TYPE_VARIATIONS.keys():','set_type_variation(variation_name, base_type)','default_font = body_font','default_font_size = tokens.body','set_font(\"font\", \"CodeLabel\"','preload(\"res://addons/neocade_theme/fonts/Inter-HeaderLarge.tres\")','preload(\"res://addons/neocade_theme/fonts/Inter-HeaderMedium.tres\")','preload(\"res://addons/neocade_theme/fonts/Inter-HeaderSmall.tres\")','preload(\"res://addons/neocade_theme/fonts/Inter-Body.tres\")','preload(\"res://addons/neocade_theme/fonts/Inter-Caption.tres\")') { if ($g -notmatch [regex]::Escape($n)) { throw \"missing: $n\" } }; $font_calls = ([regex]::Matches($g, 'set_font\\(\"font\", \"\\w+\"')).Count; if ($font_calls -lt 14) { throw \"expected at least 14 set_font calls; got $font_calls\" }; $size_calls = ([regex]::Matches($g, 'set_font_size\\(\"font_size\"')).Count; if ($size_calls -lt 12) { throw \"expected at least 12 set_font_size calls; got $size_calls\" }"
    </automated>
  </verify>
  <done>14 type variations registered with explicit fonts + sizes (CodeLabel included); theme `default_font` / `default_font_size` set; PITFALLS 1.2 + FONT-06 satisfied; SC#7's variation requirement met.</done>
</task>

<task type="auto">
  <name>Task 2: Author BINDING_TABLE covering all 37 scorecard Controls (CANONICAL FREEZE — Cross-AI Cycle 1 C1 fix)</name>
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
    **Cross-AI Cycle 1 C1 fix — CANONICAL 37-ROW FREEZE.** The binding table covers EXACTLY these 37 theme types (sourced verbatim from `MINIMAL-THEME-COVERAGE-DELTA.md §Coverage Scorecard`; no executor discretion to add/drop):

    ```
    1. AcceptDialog        14. HSplitContainer    27. SpinBox
    2. Button              15. ItemList           28. TabBar
    3. CheckBox            16. Label              29. TabContainer
    4. CheckButton         17. LineEdit           30. TextEdit
    5. CodeEdit            18. LinkButton         31. TooltipLabel
    6. ColorPicker         19. MenuBar            32. TooltipPanel
    7. ColorPickerButton   20. MenuButton         33. Tree
    8. ConfirmationDialog  21. OptionButton       34. VScrollBar
    9. FileDialog          22. Panel              35. VSlider
    10. FoldableContainer  23. PopupMenu          36. VSplitContainer
    11. GraphEdit          24. PopupPanel         37. Window
    12. HScrollBar         25. ProgressBar
    13. HSlider            26. RichTextLabel
    ```

    These 37 names are the EXACT keys the BINDING_TABLE Dictionary must declare at its top level. NO substitutions; NO executor "drop the unused one." If FEATURES.md or DISSECTION.md disagrees with a name, the scorecard is canonical (per CONTEXT.md D-09 + COVERAGE-DELTA.md §"Numeric Summary").

    **Slot-name authority.** Per-Control slot lists are sourced from `MINIMAL-THEME-DISSECTION.md` (the verified-from-godot-minimal-theme dissection, which contains live-verified slot names). The executor cross-checks against Godot 4.6's Theme Editor at runtime when a slot name is ambiguous — but MINIMAL-THEME-DISSECTION.md is the canonical baseline. For NeoCade-additive Controls (CodeEdit, ColorPickerButton, ConfirmationDialog, FileDialog, FoldableContainer, LinkButton, SpinBox, TooltipLabel) — no upstream baseline exists; the executor uses the slot names produced by inspecting `Theme.get_stylebox_list("<TypeName>")` etc. via a one-shot `@tool` script BEFORE authoring the dictionary entries (or by referencing the Godot 4.6 source class definitions for those types).

    **Recipe-to-role mapping discipline.** Every recipe's `role` MUST refer to one of the role-table keys produced by Plan 04-04's derivation block + role_table assembly: `surface_base`, `surface_low`, `surface_panel`, `surface_high`, `surface_overlay`, `outline_color`, `accent_offset`, `surface_high_offset`, `surface_panel_offset`, `surface_overlay_offset`, `surface_low_offset`, `text_strong`, `text_default`, `text_muted`, `state_hover`, `state_pressed`, `role_primary`, `accent_rim`, OR the special key `focus_ring` (constructed inline in `_resolve_recipe`).

    Author the `BINDING_TABLE` constant. The structure is a deeply-nested Dictionary with the following shape (excerpt for clarity; full version below):

    ```gdscript
    const BINDING_TABLE: Dictionary = {
        "Button": {
            "stylebox": {
                "normal":         {"role": "surface_panel", "raised_intensity": 1},  # raised-eligible: lifts when raised=true (Cross-AI Cycle 1 MEDIUM reconcile fix)
                "hover":          {"role": "state_hover",   "raised_intensity": 1},
                "pressed":        {"role": "state_pressed", "raised_intensity": 0},  # pressed sinks; never lifted
                "focus":          {"role": "focus_ring"},
                "disabled":       {"role": "surface_panel", "disabled": true, "raised_intensity": 0},  # Cross-AI Cycle 2 C2 fix: NO hard-coded 0.38; "disabled":true triggers presets.disabled_opacity
                "hover_pressed":  {"role": "state_pressed", "raised_intensity": 0},
            },
            "color": {
                "font_color":          {"role": "text_strong"},
                "font_hover_color":    {"role": "text_strong"},
                "font_pressed_color":  {"role": "text_strong"},
                "font_focus_color":    {"role": "text_strong"},
                "font_disabled_color": {"role": "text_strong", "disabled": true},  # Cross-AI Cycle 2 C2 fix: was "alpha": 0.38; now sources presets.disabled_opacity
            },
            "constant": {
                "h_separation": {"value": "tokens.tapPadding"},
            },
        },
        # ... etc for every Control ...
    }
    ```

    **Cross-AI Cycle 2 C2 fix — `"disabled": true` instead of `"alpha": 0.38`:** every Button-family / disabled-state recipe MUST use the new `"disabled": true` flag (which the iteration engine resolves by reading `presets.disabled_opacity` from Plan 04-04 DIRECTION_PRESETS). The literal `0.38` MUST NOT appear as a hard-coded `alpha` value anywhere in BINDING_TABLE recipes. Per-direction Pulse=0.42, Slate=0.50, Bubble=0.45, Daybreak=0.50, Burst=0.45 — visible per-direction differentiation on disabled state. (Custom themes fall through to `DIRECTION_PRESET_DEFAULT.disabled_opacity = 0.38` as the legacy default — only the fallback path sees 0.38.)

    **MEDIUM reconcile fix (Codex Cycle 1):** previously `Button.normal` had `raised_intensity = 0`, but Plan 04-06's verifier expects `shadow_size > 0` when `raised = true`. **The fix:** `Button.normal` (and `Button.hover`) get `raised_intensity = 1`. `Button.pressed`/`hover_pressed`/`disabled` keep `raised_intensity = 0` (pressed visually SINKS not lifts; disabled is flat). Plan 04-06's `_phase4_verify.gd` raised-toggle test explicitly asserts `Button.normal` has `shadow_size > 0` when `raised = true`, which now passes.

    The full BINDING_TABLE is too long to inline verbatim here, but the executor authors it directly using the 37-row scorecard from `MINIMAL-THEME-COVERAGE-DELTA.md` and the per-Control state lists from `MINIMAL-THEME-DISSECTION.md`. The executor MUST cover ALL 37 rows EXACTLY (no add/drop). The structure for each Control:

    ```gdscript
    "<ThemeType>": {
        "stylebox": { "<slot_name>": <recipe>, ... },
        "color":    { "<slot_name>": <recipe>, ... },
        "constant": { "<slot_name>": <recipe>, ... },
        "font_size":{ "<slot_name>": <recipe>, ... },  # if needed (most defer to type variations)
        "icon":     { "<slot_name>": <recipe>, ... },  # if needed (Button family + CheckBox + LineEdit + OptionButton + dialog close)
    }
    ```

    **Cross-AI Cycle 2 N1 fix:** the `font` data type is NOT supported in BINDING_TABLE. Per-Control fonts go through `theme.default_font` (set in Plan 04-04 derivation block — Cross-AI Cycle 1 C3) and explicit `set_font("font", "<variation>", ...)` calls on the 14 type variations (Task 1). NO base Control in MINIMAL-THEME-DISSECTION.md declares a per-slot `font` binding for v1; the schema simplification reflects this.

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
    - BINDING_TABLE contains keys for the **CANONICAL 37 scorecard Controls** (Cross-AI Cycle 1 C1 fix; sourced verbatim from `MINIMAL-THEME-COVERAGE-DELTA.md §Coverage Scorecard`): `"AcceptDialog"`, `"Button"`, `"CheckBox"`, `"CheckButton"`, `"CodeEdit"`, `"ColorPicker"`, `"ColorPickerButton"`, `"ConfirmationDialog"`, `"FileDialog"`, `"FoldableContainer"`, `"GraphEdit"`, `"HScrollBar"`, `"HSlider"`, `"HSplitContainer"`, `"ItemList"`, `"Label"`, `"LineEdit"`, `"LinkButton"`, `"MenuBar"`, `"MenuButton"`, `"OptionButton"`, `"Panel"`, `"PopupMenu"`, `"PopupPanel"`, `"ProgressBar"`, `"RichTextLabel"`, `"SpinBox"`, `"TabBar"`, `"TabContainer"`, `"TextEdit"`, `"TooltipLabel"`, `"TooltipPanel"`, `"Tree"`, `"VScrollBar"`, `"VSlider"`, `"VSplitContainer"`, `"Window"` (**EXACTLY 37 keys, no more, no less, no executor discretion**).
    - `BINDING_TABLE.size() == 37` is asserted by Plan 04-06's `_phase4_verify.gd`.
    - `Button.normal` has `raised_intensity: 1` (Cross-AI Cycle 1 MEDIUM reconcile fix — was 0; now lifts when `raised=true` so Plan 04-06's shadow_size>0 assertion passes).
    - `Button.pressed` has `raised_intensity: 0` (pressed sinks; never lifted).
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
      powershell -NoProfile -Command "$p='addons/neocade_theme/neocade_theme.gd'; $g=Get-Content -Raw $p; if ($g -notmatch 'const BINDING_TABLE: Dictionary = \\{') { throw 'BINDING_TABLE constant missing' }; $canon=@('AcceptDialog','Button','CheckBox','CheckButton','CodeEdit','ColorPicker','ColorPickerButton','ConfirmationDialog','FileDialog','FoldableContainer','GraphEdit','HScrollBar','HSlider','HSplitContainer','ItemList','Label','LineEdit','LinkButton','MenuBar','MenuButton','OptionButton','Panel','PopupMenu','PopupPanel','ProgressBar','RichTextLabel','SpinBox','TabBar','TabContainer','TextEdit','TooltipLabel','TooltipPanel','Tree','VScrollBar','VSlider','VSplitContainer','Window'); if ($canon.Count -ne 37) { throw \"canon list count $($canon.Count) != 37\" }; foreach($t in $canon) { if ($g -notmatch ('\"' + $t + '\":')) { throw \"BINDING_TABLE missing canonical key: $t\" } }; $bt_refs = ([regex]::Matches($g, 'BINDING_TABLE')).Count; if ($bt_refs -lt 4) { throw \"BINDING_TABLE referenced only $bt_refs times; expected >=4\" }; $lines = (Get-Content $p | Measure-Object -Line).Lines; if ($lines -lt 800 -or $lines -gt 2500) { throw \"file line count $lines outside 800-2500 sanity bounds\" }"
    </automated>
  </verify>
  <done>BINDING_TABLE covers all 37 scorecard Controls with their PITFALLS-aligned slots; the file is the iteration engine's source of truth for additive theme population.</done>
</task>

<task type="auto">
  <name>Task 2.5: Author CANONICAL_SLOT_NAMES slot-name freeze (Cross-AI Cycle 2 C1 fix)</name>
  <read_first>
    - addons/neocade_theme/neocade_theme.gd (after Task 2 — BINDING_TABLE is in place)
    - .planning/research/MINIMAL-THEME-DISSECTION.md (per-Control slot lists — slot names verbatim from godot-minimal-theme dissection)
    - .planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-REVIEWS.md (Cycle 2 C1 partial-resolution)
  </read_first>
  <files>
    - addons/neocade_theme/neocade_theme.gd (modify — append CANONICAL_SLOT_NAMES constant)
  </files>
  <action>
    **Cross-AI Cycle 2 C1 fix (slot-name freeze).** Cycle 1 froze the canonical 37-Control row list. Cycle 2 found exact slot names per Control were still delegated to executor discretion. This task FREEZES the slot names verbatim from `MINIMAL-THEME-DISSECTION.md` so Plan 04-06's verifier can iterate them and assert each exists, eliminating wrong-slot-name false-positives that pass row-count checks.

    Append `CANONICAL_SLOT_NAMES: Dictionary` to `neocade_theme.gd` AFTER the `BINDING_TABLE` constant. The dictionary is keyed by `theme_type` → `data_type` → array of slot-name strings. It is the SLOT-NAME ENUMERATION SOURCE OF TRUTH; verifiers (Plan 04-06) read it. BINDING_TABLE recipes for each slot must match the slot-name lists here.

    **Cross-Control coverage scope (Cycle 2 freeze):** the most-complex Controls have full slot enumerations frozen here; simpler Controls (Label, RichTextLabel, ProgressBar, etc.) are covered by their BINDING_TABLE row's slot-name keys (the `BINDING_TABLE[type][data_type].keys()` IS the slot-name list, just not duplicated here). The freeze table is for the Controls where MINIMAL-THEME-DISSECTION.md proves slot names matter most.

    ```gdscript

    # ─── Canonical slot-name freeze (Cross-AI Cycle 2 C1 fix) ───────────────────────────────────
    ## Per-Control slot-name enumeration sourced VERBATIM from MINIMAL-THEME-DISSECTION.md.
    ## Plan 04-06's verifier iterates these arrays and asserts each slot exists on the loaded
    ## theme, replacing the previous "broad row-count check" that could pass with wrong slot names.
    ## BINDING_TABLE recipe slot-keys MUST match these arrays exactly.
    const CANONICAL_SLOT_NAMES: Dictionary = {
        # Tree — 16 stylebox slots (per MINIMAL-THEME-DISSECTION.md §Tree, lines 689-720)
        # NOTE: upstream collapses many to one stylebox; NeoCade preserves the slot-name set.
        "Tree": {
            "stylebox": ["panel", "focus", "title_button_normal", "title_button_pressed", "title_button_hover",
                         "button_hover", "button_pressed", "hover", "selected", "selected_focus",
                         "hovered_selected", "hovered_selected_focus", "custom_button_hover", "custom_button_pressed",
                         "cursor", "cursor_unfocused"],
            "color": ["font_color", "guide_color", "drop_position_color", "parent_hl_line_color"],
            "constant": ["v_separation", "inner_item_margin_left", "inner_item_margin_right"],
        },
        # Button — 6 stylebox + 5+ font colors (per MINIMAL-THEME-DISSECTION.md §Button)
        # NOTE: upstream sets 12 styleboxes (incl. _mirrored variants); v1 ships 6 base + Godot
        # mirrors via type chain. _mirrored slots are added in Phase 5/6 polish.
        "Button": {
            "stylebox": ["normal", "hover", "pressed", "focus", "disabled", "hover_pressed"],
            "color": ["font_color", "font_hover_color", "font_pressed_color", "font_focus_color",
                      "font_disabled_color", "font_hover_pressed_color",
                      "icon_normal_color", "icon_hover_color", "icon_pressed_color", "icon_focus_color",
                      "icon_disabled_color", "icon_hover_pressed_color"],
            "constant": ["h_separation"],
        },
        # CheckBox — 4 icon slots (per MINIMAL-THEME-DISSECTION.md §CheckBox)
        "CheckBox": {
            "icon": ["checked", "unchecked", "radio_checked", "radio_unchecked"],
            "color": ["font_pressed_color", "font_hover_pressed_color"],
            "stylebox": ["normal"],
        },
        # CheckButton — 2 icon slots (per MINIMAL-THEME-DISSECTION.md §CheckButton)
        "CheckButton": {
            "icon": ["on", "off"],
            "color": ["font_focus_color", "font_hover_pressed_color", "font_pressed_color"],
        },
        # OptionButton — 6 stylebox + 1 constant + 1 icon
        "OptionButton": {
            "stylebox": ["normal", "hover", "pressed", "focus", "disabled", "hover_pressed"],
            "constant": ["arrow_margin"],
            "icon": ["arrow"],
            "color": ["font_color", "font_hover_color", "font_pressed_color", "font_focus_color",
                      "font_disabled_color"],
        },
        # LineEdit — 3 stylebox + caret + selection + clear icon (per MINIMAL-THEME-DISSECTION.md §LineEdit)
        "LineEdit": {
            "stylebox": ["normal", "focus", "read_only"],
            "color": ["font_placeholder_color"],
            "icon": ["clear"],
        },
        # TextEdit — same 3-stylebox set as LineEdit
        "TextEdit": {
            "stylebox": ["normal", "focus", "read_only"],
        },
        # PopupMenu — 5 stylebox + 3 constants (per MINIMAL-THEME-DISSECTION.md §PopupMenu)
        "PopupMenu": {
            "stylebox": ["panel", "hover", "separator", "labeled_separator_left", "labeled_separator_right"],
            "constant": ["item_start_padding", "v_separation", "h_separation"],
        },
        # PopupPanel — 1 stylebox
        "PopupPanel": {
            "stylebox": ["panel"],
        },
        # TooltipPanel — 1 stylebox
        "TooltipPanel": {
            "stylebox": ["panel"],
        },
        # Window — 2 stylebox slots (per MINIMAL-THEME-DISSECTION.md §Window — NeoCade-additive)
        "Window": {
            "stylebox": ["embedded_border", "embedded_unfocused_border"],
        },
        # HScrollBar — 5 stylebox slots (per MINIMAL-THEME-DISSECTION.md §HScrollBar)
        "HScrollBar": {
            "stylebox": ["scroll", "scroll_focus", "grabber", "grabber_highlight", "grabber_pressed"],
        },
        # VScrollBar — 5 stylebox slots (mirror of HScrollBar)
        "VScrollBar": {
            "stylebox": ["scroll", "scroll_focus", "grabber", "grabber_highlight", "grabber_pressed"],
        },
        # ItemList — 6 styleboxes + colors + 1 constant (per MINIMAL-THEME-DISSECTION.md §ItemList)
        "ItemList": {
            "stylebox": ["panel", "focus", "cursor", "cursor_unfocused", "hovered", "selected", "selected_focus",
                         "hovered_selected", "hovered_selected_focus"],
            "color": ["guide_color"],
            "constant": ["v_separation"],
        },
        # TabBar — 5 stylebox + 8 colors (per MINIMAL-THEME-DISSECTION.md §TabBar)
        "TabBar": {
            "stylebox": ["tab_selected", "tab_unselected", "tab_hovered", "tab_disabled", "tab_focus"],
            "color": ["font_selected_color", "font_unselected_color", "font_hovered_color", "font_disabled_color",
                      "icon_selected_color", "icon_unselected_color", "icon_hovered_color", "icon_disabled_color"],
        },
        # TabContainer — same TabBar set + panel + tabbar_background
        "TabContainer": {
            "stylebox": ["tab_selected", "tab_unselected", "tab_hovered", "tab_disabled", "tab_focus",
                         "panel", "tabbar_background"],
        },
        # HSlider / VSlider — slider stylebox per MINIMAL-THEME-DISSECTION.md
        "HSlider": {
            "stylebox": ["slider", "grabber_area", "grabber_area_highlight"],
        },
        "VSlider": {
            "stylebox": ["slider", "grabber_area", "grabber_area_highlight"],
        },
        # ProgressBar — 2 styleboxes
        "ProgressBar": {
            "stylebox": ["background", "fill"],
        },
        # Label — 1 stylebox + 1 color
        "Label": {
            "stylebox": ["normal"],
            "color": ["font_color"],
        },
        # RichTextLabel — 1 stylebox
        "RichTextLabel": {
            "stylebox": ["normal"],
        },
        # PanelContainer-like (Panel) — 1 stylebox
        "Panel": {
            "stylebox": ["panel"],
        },
        # Per-direction polish (Phase 5/6/7) extends these. The Controls below have their slot
        # name lists equal to BINDING_TABLE[type][data_type].keys() at runtime; freezing them
        # in this dict is optional for v1 verification (Plan 04-06 derives slot lists from
        # BINDING_TABLE.keys() for any Control NOT in CANONICAL_SLOT_NAMES).
    }
    ```

    **Verification handshake with Plan 04-06:** Plan 04-06's verifier (`_phase4_verify.gd` + `_phase4_verify_headless.gd`) iterates `CANONICAL_SLOT_NAMES` keys and for each `(theme_type, data_type, slot_name)` triple, calls the matching `theme.has_*` method (`has_stylebox` / `has_color` / `has_constant` / `has_icon`). If ANY frozen slot is missing, the verifier fails. This catches wrong slot names that would otherwise pass row-count checks.

    The freeze covers the 22 most-complex Controls (Tree's 16, Button's 6+12, CheckBox/CheckButton/OptionButton, LineEdit/TextEdit, all Popups, Window, both ScrollBars, ItemList, both TabBar variants, both Sliders, ProgressBar, Label, RichTextLabel, Panel). The remaining 15 simpler Controls (AcceptDialog, ConfirmationDialog, FileDialog, FoldableContainer, GraphEdit, HSplitContainer, ColorPicker, ColorPickerButton, CodeEdit, LinkButton, MenuBar, MenuButton, SpinBox, TooltipLabel, VSplitContainer) verify via "BINDING_TABLE has at least one entry for this type" — they're either inherits-from-Button (LinkButton/MenuButton/MenuBar/etc.) or minimal-baseline (FoldableContainer/GraphEdit/etc. add coverage in Phases 6/7).
  </action>
  <acceptance_criteria>
    - File contains `const CANONICAL_SLOT_NAMES: Dictionary = {`.
    - File contains `"Tree":` key under CANONICAL_SLOT_NAMES with a `"stylebox":` array of 16 strings (the 16 Tree stylebox slots).
    - The Tree stylebox array contains the literal strings: `"panel"`, `"focus"`, `"title_button_normal"`, `"title_button_pressed"`, `"title_button_hover"`, `"button_hover"`, `"button_pressed"`, `"hover"`, `"selected"`, `"selected_focus"`, `"hovered_selected"`, `"hovered_selected_focus"`, `"custom_button_hover"`, `"custom_button_pressed"`, `"cursor"`, `"cursor_unfocused"`.
    - File contains `"Button":` key with stylebox array including `"normal"`, `"hover"`, `"pressed"`, `"focus"`, `"disabled"`, `"hover_pressed"`.
    - File contains `"LineEdit":` with stylebox array `["normal", "focus", "read_only"]`.
    - File contains `"PopupMenu":` with stylebox array including `"panel"`, `"hover"`, `"separator"`, `"labeled_separator_left"`, `"labeled_separator_right"`.
    - File contains `"Window":` with stylebox array including `"embedded_border"`, `"embedded_unfocused_border"`.
    - File contains `"HScrollBar":` with stylebox array including `"scroll"`, `"scroll_focus"`, `"grabber"`, `"grabber_highlight"`, `"grabber_pressed"`.
    - File contains `"VScrollBar":` with the same 5 slot names as HScrollBar.
    - File contains `"CheckBox":` with `"icon":` array including `"checked"`, `"unchecked"`.
    - File contains `"CheckButton":` with `"icon":` array including `"on"`, `"off"`.
    - File contains `"OptionButton":` with `"icon":` array including `"arrow"`.
    - The CANONICAL_SLOT_NAMES dict declares at least 22 Control type keys (the freeze coverage scope).
  </acceptance_criteria>
  <verify>
    <automated>
      powershell -NoProfile -Command "$p='addons/neocade_theme/neocade_theme.gd'; $g=Get-Content -Raw $p; if ($g -notmatch 'const CANONICAL_SLOT_NAMES: Dictionary = \\{') { throw 'CANONICAL_SLOT_NAMES constant missing' }; $tree_slots=@('panel','focus','title_button_normal','title_button_pressed','title_button_hover','button_hover','button_pressed','hover','selected','selected_focus','hovered_selected','hovered_selected_focus','custom_button_hover','custom_button_pressed','cursor','cursor_unfocused'); foreach($s in $tree_slots) { if ($g -notmatch ('\"' + [regex]::Escape($s) + '\"')) { throw \"CANONICAL_SLOT_NAMES.Tree missing slot: $s\" } }; foreach($n in '\"Button\":','\"CheckBox\":','\"CheckButton\":','\"OptionButton\":','\"LineEdit\":','\"TextEdit\":','\"PopupMenu\":','\"PopupPanel\":','\"TooltipPanel\":','\"Window\":','\"HScrollBar\":','\"VScrollBar\":','\"ItemList\":','\"TabBar\":','\"TabContainer\":','\"HSlider\":','\"VSlider\":','\"ProgressBar\":','\"Label\":','\"RichTextLabel\":','\"Panel\":','\"embedded_border\"','\"embedded_unfocused_border\"','\"labeled_separator_left\"','\"labeled_separator_right\"','\"grabber_highlight\"','\"grabber_pressed\"') { if ($g -notmatch [regex]::Escape($n)) { throw \"CANONICAL_SLOT_NAMES missing: $n\" } }"
    </automated>
  </verify>
  <done>CANONICAL_SLOT_NAMES freeze table is in place; Plan 04-06's verifier can now iterate frozen slots per Control type and catch wrong slot names that would have passed row-count checks.</done>
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
    Add a helper method that resolves a recipe to a concrete value, given the derivation-block locals. The helper signature now takes `presets` (the per-direction DIRECTION_PRESETS sub-dict from Plan 04-04) so disabled-opacity is sourced per-direction (Cross-AI Cycle 2 C2 fix). The stylebox branch multiplies content_margin by `tokens.densityScale` and adds `tokens.tapPadding` so MOBILE platform produces visibly larger margins (Cross-AI Cycle 2 M2 fix).

    ```gdscript

    # ─── Recipe resolution (Plan 04-05 iteration engine helper) ─────────────────────────────────

    ## Resolves a BINDING_TABLE recipe to a concrete value, given the precomputed derivation block.
    ## `data_type` is "stylebox", "color", "constant", "font_size", or "icon".
    ##   (Cross-AI Cycle 2 N1 fix: NO "font" branch — per-Control fonts are handled by
    ##   theme.default_font + the 14 explicit set_font calls on type variations in Task 1.)
    ## Returns null if the recipe references an unknown role or icon (caller skips silently — D-04).
    func _resolve_recipe(recipe: Dictionary, data_type: String, role_table: Dictionary,
                          tokens: Dictionary, presets: Dictionary) -> Variant:
        if data_type == "stylebox":
            var role: String = recipe.get("role", "surface_panel")
            var raised_intensity: int = recipe.get("raised_intensity", 0)
            # Cross-AI Cycle 2 C2 fix: disabled flag pulls per-direction alpha from presets,
            # NOT a hard-coded 0.38. Recipes carrying "disabled": true get presets.disabled_opacity.
            var is_disabled: bool = recipe.get("disabled", false)
            var alpha: float = recipe.get("alpha", 1.0)
            if is_disabled:
                alpha = presets.disabled_opacity
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
            # Cross-AI Cycle 2 M2 fix: platform-aware margins. DESKTOP (densityScale=1.0,
            # tapPadding=8) yields the base spacing; MOBILE (densityScale=1.5, tapPadding=12)
            # produces a visibly larger Button.normal content_margin_*. Plan 04-06's MOBILE
            # toggle assertion observes this difference.
            var density: float = tokens.get("densityScale", 1.0)
            var tap_pad: int = tokens.get("tapPadding", 0)
            var h_margin: int = int(spacing * density) + tap_pad
            var v_margin: int = int(spacing * 0.6 * density) + tap_pad
            sb.content_margin_left = h_margin
            sb.content_margin_top = v_margin
            sb.content_margin_right = h_margin
            sb.content_margin_bottom = v_margin
            return sb
        elif data_type == "color":
            var role: String = recipe.get("role", "text_strong")
            # Cross-AI Cycle 2 C2 fix: disabled flag pulls per-direction alpha from presets.
            var is_disabled: bool = recipe.get("disabled", false)
            var alpha: float = recipe.get("alpha", 1.0)
            if is_disabled:
                alpha = presets.disabled_opacity
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
        # Cross-AI Cycle 2 N1 fix: any unrecognized data_type (including the now-removed "font")
        # falls through to null — caller skips silently per D-04 escape hatch.
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
        # Cross-AI Cycle 2 N1 fix: only 5 setter branches — NO set_font branch. Per-Control
        # fonts are handled by default_font + explicit set_font on the 14 type variations.
        # Cross-AI Cycle 2 C2 fix: presets passed to _resolve_recipe so disabled alpha is
        # sourced per-direction from DIRECTION_PRESETS.disabled_opacity.
        for theme_type in BINDING_TABLE.keys():
            var type_block: Dictionary = BINDING_TABLE[theme_type]
            for data_type in type_block.keys():
                var slots: Dictionary = type_block[data_type]
                for slot_name in slots.keys():
                    var recipe: Dictionary = slots[slot_name]
                    var value = _resolve_recipe(recipe, data_type, role_table, tokens, presets)
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
                    # NOTE: data_type == "font" is intentionally NOT handled (Cross-AI Cycle 2
                    # N1 fix). Such entries will not appear in BINDING_TABLE since the schema
                    # explicitly excludes "font". If they did, _resolve_recipe returns null
                    # (its switch has no font branch), and the value==null check above skips.
    ```

    This walk is the additive iteration engine. It uses Godot's standard `set_*(slot, type, value)` methods on the Theme. There is NO `clear()` call — entries not in BINDING_TABLE are untouched (the D-04 escape hatch lets Theme Editor authored content survive).

    Note on iteration order: Godot's Dictionary iteration in Godot 4.6 is insertion-ordered, so the BINDING_TABLE keys iterate in declaration order. This is sufficient for additive iteration; entries within a Control type don't depend on each other.
  </action>
  <acceptance_criteria>
    - File contains `func _resolve_recipe(recipe: Dictionary, data_type: String, role_table: Dictionary,` (multi-line signature; the `presets: Dictionary` param appears on the continuation line — Cross-AI Cycle 2 C2 fix).
    - File contains `presets: Dictionary` as a parameter to `_resolve_recipe` (Cross-AI Cycle 2 C2 fix).
    - `_resolve_recipe` body branches on `data_type` for `"stylebox"`, `"color"`, `"constant"`, `"font_size"`, `"icon"` — exactly 5 branches (Cross-AI Cycle 2 N1 fix: NO `"font"` branch).
    - `_resolve_recipe` calls `_make_raised_stylebox(bg_color, offset_color, sb_intensity)` for the stylebox branch.
    - `_resolve_recipe` handles the special role `"focus_ring"` by constructing a focus-styled StyleBoxFlat with `border_width_*` = `focus_thickness`.
    - **Cross-AI Cycle 2 C2 fix:** `_resolve_recipe`'s stylebox branch contains `var is_disabled: bool = recipe.get("disabled", false)` and the literal `alpha = presets.disabled_opacity` (NOT a hard-coded `0.38`).
    - **Cross-AI Cycle 2 C2 fix:** `_resolve_recipe`'s color branch ALSO contains the same `presets.disabled_opacity` source (not a hard-coded `0.38`).
    - **Cross-AI Cycle 2 C2 fix:** the literal `0.38` does NOT appear ANYWHERE inside the body of `_resolve_recipe()` or in any BINDING_TABLE recipe `alpha` value — verified via grep: `0.38` only appears in `DIRECTION_PRESET_DEFAULT` (Plan 04-04) as the legacy custom-theme fallback.
    - **Cross-AI Cycle 2 M2 fix:** `_resolve_recipe`'s stylebox branch contains `tokens.get("densityScale", 1.0)` and `tokens.get("tapPadding", 0)`.
    - **Cross-AI Cycle 2 M2 fix:** the stylebox branch computes `h_margin` and `v_margin` using both `density` and `tap_pad` so MOBILE platform tokens (`densityScale=1.5, tapPadding=12`) produce numerically larger content_margin_* than DESKTOP (`densityScale=1.0, tapPadding=8`).
    - `_regenerate_theme()` body contains a `var role_table: Dictionary = {` declaration with at least 16 entries.
    - `_regenerate_theme()` body contains `for theme_type in BINDING_TABLE.keys():`.
    - The walk contains nested `for data_type in type_block.keys():` and `for slot_name in slots.keys():`.
    - The walk contains all 5 set methods: `set_stylebox(slot_name, theme_type, value)`, `set_color(slot_name, theme_type, value)`, `set_constant(slot_name, theme_type, int(value))`, `set_font_size(slot_name, theme_type, int(value))`, `set_icon(slot_name, theme_type, value)`.
    - **Cross-AI Cycle 2 N1 fix:** the walk does NOT contain `set_font(slot_name, theme_type,` — there are exactly 5 setter calls in the walk, not 6. (The `set_font` calls in Task 1's variation-registration block are explicit per-variation calls and do NOT live inside the BINDING_TABLE walk.)
    - The walk contains the call `_resolve_recipe(recipe, data_type, role_table, tokens, presets)` — 5 arguments (Cross-AI Cycle 2 C2 fix added `presets`).
    - The walk contains a null-check (`if value == null: continue`) implementing the D-04 escape hatch.
    - The string `clear()` does NOT appear in `_regenerate_theme()` or any helper it calls (D-01 invariant; check entire file).
  </acceptance_criteria>
  <verify>
    <automated>
      powershell -NoProfile -Command "$p='addons/neocade_theme/neocade_theme.gd'; $g=Get-Content -Raw $p; foreach($n in 'func _resolve_recipe(recipe: Dictionary, data_type: String, role_table: Dictionary,','presets: Dictionary','if data_type == \"stylebox\":','if data_type == \"color\":','elif data_type == \"constant\"','elif data_type == \"font_size\":','elif data_type == \"icon\":','_make_raised_stylebox(bg_color, offset_color, sb_intensity)','if role == \"focus_ring\":','var role_table: Dictionary = {','for theme_type in BINDING_TABLE.keys():','for data_type in type_block.keys():','for slot_name in slots.keys():','set_stylebox(slot_name, theme_type, value)','set_color(slot_name, theme_type, value)','set_constant(slot_name, theme_type, int(value))','set_font_size(slot_name, theme_type, int(value))','set_icon(slot_name, theme_type, value)','if value == null: continue','_resolve_recipe(recipe, data_type, role_table, tokens, presets)','presets.disabled_opacity','tokens.get(\"densityScale\"','tokens.get(\"tapPadding\"','recipe.get(\"disabled\", false)') { if ($g -notmatch [regex]::Escape($n)) { throw \"missing: $n\" } }; if ($g -match '\\bclear\\(\\)') { throw 'clear() call found — D-01 forbids' }; $rt_lines = ([regex]::Matches($g, '\":\\s+(surface|outline_color|accent|text|state|role|accent_rim)')).Count; if ($rt_lines -lt 14) { throw \"role_table has $rt_lines entries; expected >=14\" }; $resolve_body_match = [regex]::Match($g, '(?s)func _resolve_recipe.*?(?=^func |\\Z)'); if ($resolve_body_match.Success) { $resolve_body = $resolve_body_match.Value; if ($resolve_body -match '\\b0\\.38\\b') { throw 'C2 fix incomplete: 0.38 hard-coded inside _resolve_recipe body' } }; $btn_recipe_section = [regex]::Match($g, '(?s)\"Button\":\\s*\\{.*?\\\\}\\s*,'); if ($btn_recipe_section.Success -and $btn_recipe_section.Value -match '\\\"alpha\\\":\\s*0\\.38') { throw 'C2 fix incomplete: \"alpha\": 0.38 still in Button BINDING_TABLE recipe' }; if ($g -match '(?s)func _resolve_recipe.*?elif data_type == \"font\"') { throw 'N1 fix incomplete: font branch still in _resolve_recipe' }; $walk_section_match = [regex]::Match($g, '(?s)for theme_type in BINDING_TABLE\\.keys.*?(?=^\\s*_last_regeneration_usec|\\Z)'); if ($walk_section_match.Success -and $walk_section_match.Value -match 'set_font\\(slot_name, theme_type,') { throw 'N1 fix incomplete: BINDING_TABLE walk contains set_font(slot_name, theme_type, ...)' }"
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
    feat(04-05): BINDING_TABLE (37 canonical) + slot-name freeze + iteration engine

    Plan 04-05 wave-2 engine (depends on Plans 04-01..04; Cross-AI Cycle 1 +
    Cycle 2 fixes):
    - C1 fix: BINDING_TABLE covers EXACTLY 37 canonical scorecard Controls per
      MINIMAL-THEME-COVERAGE-DELTA.md (no executor discretion to add/drop):
      AcceptDialog, Button, CheckBox, CheckButton, CodeEdit, ColorPicker,
      ColorPickerButton, ConfirmationDialog, FileDialog, FoldableContainer,
      GraphEdit, HScrollBar, HSlider, HSplitContainer, ItemList, Label, LineEdit,
      LinkButton, MenuBar, MenuButton, OptionButton, Panel, PopupMenu, PopupPanel,
      ProgressBar, RichTextLabel, SpinBox, TabBar, TabContainer, TextEdit,
      TooltipLabel, TooltipPanel, Tree, VScrollBar, VSlider, VSplitContainer, Window
    - Cycle 2 C1 fix: NEW const CANONICAL_SLOT_NAMES freezes per-Control slot
      names verbatim from MINIMAL-THEME-DISSECTION.md (Tree's 16 styleboxes,
      Button's 6+12, LineEdit's 3, PopupMenu's 5, Window's 2, both ScrollBars'
      5, etc.). Plan 04-06's verifier iterates the freeze table and asserts
      every declared slot exists — catches wrong slot names that pass row-counts.
    - Cycle 2 C2 fix: BINDING_TABLE recipes use "disabled": true flag (NOT
      hard-coded "alpha": 0.38). _resolve_recipe sources alpha from
      presets.disabled_opacity per direction (Pulse=0.42 / Slate=0.50 /
      Bubble=0.45 / Daybreak=0.50 / Burst=0.45). 0.38 only appears in the
      DIRECTION_PRESET_DEFAULT fallback in Plan 04-04 for custom themes.
    - Cycle 2 N1 fix: schema EXCLUDES "font" data type (per-Control fonts are
      not a BINDING_TABLE concept). Per-Control fonts come from theme.default_font
      + the 14 explicit set_font calls on type variations (Task 1). Iteration
      walk has 5 setters, NOT 6: stylebox/color/constant/font_size/icon.
    - Cycle 2 M2 fix: _resolve_recipe stylebox branch wires tokens.densityScale
      and tokens.tapPadding into content_margin computation. MOBILE platform
      (densityScale=1.5, tapPadding=12) yields larger Button.normal margins
      than DESKTOP (densityScale=1.0, tapPadding=8). Plan 04-06 verifier
      observes the MOBILE>DESKTOP difference.
    - C3 fix: theme.default_font = Inter-Body.tres + default_font_size = tokens.body
      set BEFORE the BINDING_TABLE walk (FONT-06 closure)
    - C4 fix: TYPE_VARIATIONS = 14 entries (PrimaryButton/SecondaryButton/
      GhostButton/DangerButton/IconButton/FlatButton + HeaderLarge/HeaderMedium/
      HeaderSmall/Caption/CodeLabel + InfoText + CardPanel/HeroPanel) — CodeLabel
      INCLUDED (was previously dropped)
    - MEDIUM reconcile fix: Button.normal raised_intensity = 1 (was 0), so Plan
      04-06's "shadow_size > 0 when raised=true" assertion passes
    - PITFALLS-aligned slot lists: Tree (16 styleboxes), LineEdit (3), PopupMenu
      (5+), Window (2), HScrollBar (4)
    - _resolve_recipe() helper resolves recipes to concrete values; focus_ring slot
      receives a special stylebox (transparent bg + accent border + expand_margin
      = OUTSIDE corner radius per PITFALLS 1.1)
    - _regenerate_theme() walks BINDING_TABLE additively (D-01 invariant: no clear();
      D-04 escape hatch: entries not in table are untouched)
    - Icon binding wires the 10 Button-family SVGs from Plan 04-03 to CheckBox /
      RadioButton / CheckButton / OptionButton / LineEdit clear / dialog close slots

    Refs: FOUND-02 (full _regenerate_theme body), FONT-06 (default_font),
      ICON-02 (wiring), TYPEVAR-01..05
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
