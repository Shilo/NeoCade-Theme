# Phase 4 Research — `NeoCadeTheme` class + 5 data-only `.tres` + Fonts + Icons

**Researched:** 2026-05-06
**Status:** RESEARCH COMPLETE
**Phase:** 4 — Foundation
**Author:** gsd-phase-researcher (inline)
**Inputs:** `04-CONTEXT.md`, `.planning/DESIGN_TOKENS.md`, `.planning/REQUIREMENTS.md` lines 29-128, `.planning/spikes/dynamic-theme/SpikeNeoCadeTheme.gd` (268 LOC, 6/6 strict-gate PASS), `.planning/research/MD3-RESEARCH.md`, `.planning/research/FLAT-3D-UI-RESEARCH.md`, `.planning/research/MINIMAL-THEME-DISSECTION.md`, `.planning/research/PITFALLS.md`, `.planning/research/CROSS-PLATFORM.md`, `.planning/research/STACK.md`, `.planning/research/EDITOR-COVERAGE.md`, `.planning/research/FEATURES.md`, `.planning/research/MINIMAL-THEME-COVERAGE-DELTA.md`, `.planning/research/FONT-REVIEW.md`, `.planning/research/GODOT-DYNAMIC-THEME-RESEARCH.md`.

---

## §0 What this research addresses (and what it deliberately does NOT)

**Scope.** Phase 4 has an unusual amount of decision-locking already done. DESIGN_TOKENS.md is the implementation contract (every `@export`, every formula, every Pulse/Slate/Bubble/Daybreak/Burst data block). CONTEXT.md sets D-01..D-14 (architecture lock + binding-table guidance + class-default policy + task ordering). REQUIREMENTS.md lines 29-128 enumerate FOUND-01..03 + FONT-01..09 + ICON-01..04 + TOKEN-01..10 verbatim.

**This document therefore answers only the engine-level open questions the planner needs to plan well:**

- §1 The additive iteration engine (D-01) — what Godot 4.6 `Theme` API surface produces every entry, how we update properties in place without `clear()`, and how we detect which entries are formula-bound vs author-only.
- §2 The binding mechanism (D-03 TENTATIVE) — concrete table structure that satisfies the "simplest workable approach" the user requested.
- §3 `@tool` + `.tres` deserialization order — when does `_init()` fire vs setters of deserialized `@export` values, and how to avoid pre-deserialization regeneration overwriting the saved `@export` block.
- §4 The reentry guard — spike's `_regenerating := false` flag, whether it's sufficient for production, and editor-vs-runtime branch.
- §5 FontVariation authoring for `opsz` / `wght` (Inter Variable Roman variations for HeaderLarge/HeaderMedium/HeaderSmall).
- §6 Bespoke SVG icon authoring + `.import` sidecar template (~10 Button-family icons per D-10).
- §7 Pulse verification methodology — what "regeneration matches Phase 3.4 mockup output" concretely means.
- §8 The minimal `_regenerate_theme()` shape Phase 4 must ship.
- §9 Validation Architecture (Nyquist Dimension 8) — what the theme regenerates correctly under, sample resolution, and per-direction regression baseline.
- §10 Risks, gotchas, and "do NOT confuse with the spike" landmines.
- §11 Phase 4 verification gates the planner should bake into PLAN.md `must_haves`.

**Out of scope for this research:** values (DESIGN_TOKENS owns those), per-direction personality (Phase 5/6/7 owns Theme Editor entry overrides per direction), mobile validation (Phase 8), showcase scene (Phase 9), cross-platform export QA (Phase 10), README polish (Phase 11). Where this research touches those topics, it's only to set up correct interfaces for them.

---

## §1 The additive iteration engine (resolves D-01)

### 1.1 The Godot 4.6 `Theme` API surface for full enumeration

Per CONTEXT.md `<canonical_refs>` "Godot 4.6 API References" + Godot 4.6 docs (`Theme` class), every entry in a `Theme` resource is reachable through symmetric per-data-type APIs:

```gdscript
# Type enumeration (all theme types currently registered)
var all_types: PackedStringArray = theme.get_type_list()  # superset of all data-type lists

# Per-data-type type enumeration (only types that have at least one entry of that data type)
var color_types: PackedStringArray    = theme.get_color_type_list()
var constant_types: PackedStringArray = theme.get_constant_type_list()
var font_types: PackedStringArray     = theme.get_font_type_list()
var font_size_types: PackedStringArray = theme.get_font_size_type_list()
var icon_types: PackedStringArray     = theme.get_icon_type_list()
var stylebox_types: PackedStringArray = theme.get_stylebox_type_list()

# Per-(type, data-type) item enumeration
var color_items: PackedStringArray    = theme.get_color_list("Button")    # ["font_color", "font_hover_color", ...]
var constant_items: PackedStringArray = theme.get_constant_list("Button") # ["h_separation", ...]
var font_items: PackedStringArray     = theme.get_font_list("Button")     # ["font", ...]
var font_size_items: PackedStringArray = theme.get_font_size_list("Button")
var icon_items: PackedStringArray     = theme.get_icon_list("Button")
var stylebox_items: PackedStringArray = theme.get_stylebox_list("Button") # ["normal", "hover", ...]

# Read / write / probe per-item
var sb: StyleBox = theme.get_stylebox("normal", "Button")
theme.set_stylebox("normal", "Button", sb_new)
var has: bool = theme.has_stylebox("normal", "Button")

# Type variation registration (Godot variation system; types inherit stylebox/color/constants from base type)
theme.set_type_variation("PrimaryButton", "Button")
```

**Critical semantics for D-01 (additive regeneration):**
- `set_stylebox()` REPLACES the entry (it doesn't merge). To preserve Theme Editor authored content, the engine must (a) check `has_stylebox(item, type)` first, (b) if present, MUTATE properties on the existing StyleBox instance via `set_*` accessors and re-register; OR (c) skip entirely if the slot is "author-owned" (per the binding table — see §2).
- `clear()` is FORBIDDEN per D-01 — wipes everything including authored variation styleboxes.
- Type variations: `set_type_variation(name, base)` REGISTERS the variation; the variation type then auto-inherits stylebox/color/constants from the base type per Godot's variation system. Per **PITFALLS 1.2**, variations DO NOT auto-inherit fonts. Phase 4 must set `font` explicitly on every variation.

### 1.2 Why mutate-in-place vs replace

A naive "additive" implementation could replace each StyleBox with a fresh copy when its formula re-derives. That's still safe IF the binding table excludes author-owned slots. But it's safer (and clearer) to mutate properties on the existing StyleBoxFlat instance:

```gdscript
# Conceptual: update a StyleBoxFlat in place rather than replace
var sb: StyleBoxFlat = theme.get_stylebox(item, theme_type) as StyleBoxFlat
if sb == null:
    # First-time generation — create
    sb = StyleBoxFlat.new()
    theme.set_stylebox(item, theme_type, sb)
sb.bg_color = computed_bg
sb.border_color = computed_border
sb.set_corner_radius_all(corner_radius)
# ... etc
```

**Why mutate-in-place:** `Resource` reference identity is preserved across regenerations. Anything in the editor or running scenes holding a reference to that StyleBox sees the update without re-binding. `set_stylebox()` of a fresh instance can leave stale references when Godot's editor caches by RID.

**Implementation choice for Phase 4:** Use mutate-in-place when the slot already has a `StyleBoxFlat` (or `StyleBoxLine`) of the expected concrete type. Use `set_*` to install a fresh instance when the slot is empty or has the wrong type. This handles both "first generation" (empty Theme) and "regeneration after `@export` change" cleanly.

### 1.3 The "what slots exist" problem

`Theme.get_stylebox_list("Button")` returns ONLY the items currently stored on the type. On a freshly-created `NeoCadeTheme.new()`, the list is empty. The engine therefore needs a **canonical schema** that says, for every Control type:

- "These are the stylebox slots Phase 4 owns" (so first-generation creates them).
- "These are the color/constant/font_size/icon slots Phase 4 owns."

This canonical schema IS the binding table (§2). It's the single source of truth for the formula's coverage; `_regenerate_theme()` walks the table, ensures each slot exists, mutates its properties from the formulas, and registers it in the live Theme.

**Key insight:** the iteration engine isn't a generic "iterate everything in the Theme" loop — it's a "walk the binding table and ensure each binding is correctly populated" loop. Slots NOT in the table are left untouched (D-04 — escape hatch). Slots IN the table are owned by the formula and mutate every regeneration.

This both (a) preserves Theme Editor authored content (anything authored that's not in the binding table survives) and (b) gives the formula a deterministic coverage list (so SC#7's "every Control + every type variation populated" is verifiable).

### 1.4 Coverage source — the 37-row scorecard + 13 type variations

Per CONTEXT.md D-09 + DESIGN_TOKENS §5 + `MINIMAL-THEME-COVERAGE-DELTA.md`, the binding table must cover:

**37 base Control types** (the scorecard rows; ROADMAP success criterion #7):
- BaseButton family (~6): Button, OptionButton, MenuButton, CheckBox, CheckButton, ColorPickerButton, LinkButton (LinkButton has no stylebox — color/constant/font only).
- Text input/display (5): Label, RichTextLabel, LineEdit, TextEdit, CodeEdit.
- Range controls (5): HSlider, VSlider, HScrollBar, VScrollBar, ProgressBar, SpinBox.
- List/tree (5): ItemList, Tree, TabBar, TabContainer, FoldableContainer.
- Popup-class as separate types (8): PopupPanel, PopupMenu, AcceptDialog, ConfirmationDialog, FileDialog, TooltipPanel, TooltipLabel, Window.
- Containers with chrome (4): Panel, PanelContainer, ScrollContainer, SplitContainer, MarginContainer (constants only).
- Advanced (3-5): MenuBar, ColorPicker, GraphEdit, GraphNode, GraphFrame.

(The exact 37 is the union of FEATURES.md §1 + the 3 NeoCade-additive types from MINIMAL-THEME-COVERAGE-DELTA.md.)

**13 type variations** (PrimaryButton, SecondaryButton, GhostButton, DangerButton, IconButton, FlatButton, HeaderLarge, HeaderMedium, HeaderSmall, Caption, CodeLabel, InfoText, CardPanel, HeroPanel — exactly the TYPEVAR-01..04 set).

**Phase 4 baseline = full formula state coverage on the 37 base types + register-and-font on the 13 variations.** Per-direction variation styleboxes (the "personality" StyleBoxFlat with direction-specific bg/border/padding) are Phase 5/6/7. Phase 4 ships ONLY the registration call + explicit fonts.

### 1.5 Per-Control state matrix (what slots are formula-owned)

A non-exhaustive but representative summary of stylebox slots Phase 4 must populate (from MINIMAL-THEME-DISSECTION.md + Godot 4.6 stylebox enumeration):

| Type | Stylebox slots (formula-owned) | Color slots | Constant slots |
|---|---|---|---|
| Button | normal, hover, pressed, hover_pressed, disabled, focus | font_color, font_hover_color, font_pressed_color, font_hover_pressed_color, font_disabled_color, font_focus_color, icon_normal_color, icon_disabled_color | h_separation, icon_max_width |
| OptionButton | (same as Button) | (same as Button) | h_separation, arrow_margin, modulate_arrow |
| CheckBox | normal, hover, pressed, disabled, focus | font_*_color, check_v_offset (constant) | h_separation, check_v_offset, icon_max_width |
| LineEdit | normal, focus, read_only | font_color, font_selected_color, caret_color, selection_color, font_placeholder_color | minimum_character_width, caret_width |
| TextEdit | normal, focus, read_only | (LineEdit + line_number, search_result, ...) | line_spacing |
| CodeEdit | normal, focus, read_only | (TextEdit + bookmark, breakpoint, executing_line, code_folding) | line_spacing |
| Tree | panel, focus, cursor, cursor_unfocused, selected, selected_focus, button_pressed, custom_button_normal, custom_button_pressed, custom_button_hover, title_button_normal, title_button_hover, title_button_pressed (≈13-16 styleboxes) | font_color, font_selected_color, guide_color, drop_position_color, ... | h_separation, v_separation, item_margin, button_margin, ... |
| ItemList | panel, focus, hovered, hovered_selected, selected, selected_focus, cursor, cursor_unfocused | (color set) | h_separation, v_separation, icon_margin |
| TabBar | tab_unselected, tab_selected, tab_hovered, tab_disabled, tab_focus, button_highlight, button_pressed, drop_mark | font_*_color | h_separation, icon_max_width, outline_size |
| TabContainer | (same as TabBar + panel) | (same) | (same + side_margin) |
| HSlider/VSlider | slider, grabber_area, grabber_area_highlight | (no font) | (no constants) — uses icons for grabber |
| HScrollBar/VScrollBar | scroll, scroll_focus, grabber, grabber_highlight, grabber_pressed | (no font) | grabber_minimum_size |
| ProgressBar | background, fill | font_color, font_outline_color | outline_size |
| SpinBox | (LineEdit + up_*, down_* icons) | (LineEdit) | buttons_vertical_separation |
| Panel | panel | — | — |
| PanelContainer | panel | — | — |
| PopupPanel | panel | — | — |
| PopupMenu | panel, hover, separator, labeled_separator_left, labeled_separator_right | font_color, font_hover_color, font_disabled_color, font_separator_color, ... | h_separation, v_separation, item_start_padding, item_end_padding, indent |
| AcceptDialog | (no styleboxes — uses Window + Panel subscenes; constants only) | (no font) | buttons_separation |
| ConfirmationDialog | (same) | (same) | (same) |
| FileDialog | (Panel + Tree + LineEdit + Button — no own styleboxes) | (no own colors) | (no own constants) |
| TooltipPanel | panel | — | — |
| TooltipLabel | (no styleboxes — Label colors only) | font_color, font_shadow_color | shadow_offset_x, shadow_offset_y, shadow_outline_size |
| Window | embedded_border, embedded_unfocused_border | title_color, title_outline_modulate | title_height, resize_margin, close_h_offset, close_v_offset |
| ScrollContainer | panel, focus | — | — |
| SplitContainer | split_bar_background | — | separation, autohide, minimum_grab_thickness |
| MarginContainer | — | — | margin_left, margin_top, margin_right, margin_bottom |
| Label | normal | font_color, font_outline_color, font_shadow_color | line_spacing, outline_size, shadow_offset_x, shadow_offset_y |
| RichTextLabel | normal, focus | default_color, font_*_color, table_*_color | line_separation, table_*_separation, outline_size, shadow_*, text_highlight_h_padding, text_highlight_v_padding |
| MenuBar | (no styleboxes — uses PopupMenu) | font_color, font_hover_color, font_pressed_color, font_disabled_color, font_focus_color, font_outline_color | h_separation, outline_size |
| MenuButton | (Button) | (Button) | (Button) |
| ColorPickerButton | (Button + bg) | (Button) | (Button) |
| LinkButton | — | font_color, font_hover_color, font_pressed_color, font_focus_color, font_disabled_color, font_outline_color | underline_spacing, outline_size |
| ColorPicker | (no own styleboxes — uses sub-Controls) | (color set) | h_width, sv_width, sv_height, label_width, margin |
| GraphEdit | panel, menu_panel | — | port_hotzone_inner_extent, port_hotzone_outer_extent |
| GraphNode | panel, panel_selected, titlebar, titlebar_selected, slot | (color set) | separation, port_h_offset |
| GraphFrame | panel, panel_selected, titlebar, titlebar_selected | (color set) | separation, autoshrink_margin |
| FoldableContainer | panel, focus, title_panel, title_collapsed_panel, title_hover_panel | font_color, font_hover_color, font_disabled_color, title_collapsed_font_color | h_separation, outline_size |

The exact slot lists per type are accessible via Godot 4.6's documentation and via Theme Editor (open any of Godot's default UI scenes, switch to Theme tab, expand the type). Phase 4 codifies the intersection-of-required-slots into the binding table.

### 1.6 Iteration engine pseudocode

```gdscript
const BINDING_TABLE: Dictionary = _build_binding_table()  # static; constructed once

func _regenerate_theme() -> void:
    if _regenerating: return                    # reentry guard
    _regenerating = true
    is_light = base_color.get_luminance() >= 0.5
    var p: Platform = _resolve_platform()
    var roles := _compute_role_tokens(p)        # surface ramp + state layers + offsets
    
    for theme_type in BINDING_TABLE:            # canonical 37 types
        var bindings: Dictionary = BINDING_TABLE[theme_type]
        for stylebox_slot in bindings.get("styleboxes", {}):
            var role_recipe: Dictionary = bindings["styleboxes"][stylebox_slot]
            _apply_stylebox(theme_type, stylebox_slot, role_recipe, roles, p)
        for color_slot in bindings.get("colors", {}):
            _apply_color(theme_type, color_slot, bindings["colors"][color_slot], roles)
        for constant_slot in bindings.get("constants", {}):
            _apply_constant(theme_type, constant_slot, bindings["constants"][constant_slot], p)
        for font_size_slot in bindings.get("font_sizes", {}):
            _apply_font_size(theme_type, font_size_slot, bindings["font_sizes"][font_size_slot], p)
        # Fonts: register only on type variations + default_font; per Pitfall 1.2 don't auto-inherit
    
    for variation_name in TYPE_VARIATIONS:      # 13 variations
        set_type_variation(variation_name, TYPE_VARIATIONS[variation_name].base)
        _apply_variation_font(variation_name, TYPE_VARIATIONS[variation_name], p)
        _apply_variation_font_size(variation_name, TYPE_VARIATIONS[variation_name], p)
    
    _regenerating = false
```

This skeleton meets D-01 (no `clear()`), D-04 (untouched slots survive), D-09 (every type populated), and PITFALLS 1.2 (fonts explicit on variations).

---

## §2 The binding mechanism (resolves D-03 TENTATIVE)

### 2.1 The user's preference (per CONTEXT.md `<specifics>`)

Quoting CONTEXT.md `<specifics>`:

> "The binding mechanism (slot-name table vs metadata tags vs property-name convention) is REVISABLE after Phase 4 implementation. User explicitly parked this for revision: 'I actually think a better approach would be that NeoCadeTheme directly applies the exports to the themed overrides based on a set of property names or something similar. but we can discuss that as a revision later.' Phase 4 picks the simplest workable approach (slot-name + property-name binding table in `.gd`) and documents the choice as revisable in PLAN.md."

**Phase 4 picks: slot-name + property-name binding table compiled into `neocade_theme.gd`. No per-resource metadata. No EditorInspectorPlugin. No human authoring UX.** Revisable later.

### 2.2 Recommended structure

A nested Dictionary keyed by `theme_type`, then by data-type group (`styleboxes`, `colors`, `constants`, `font_sizes`, `icons`), then by slot name. Each leaf is a "recipe" that names the role token + variant + state layer:

```gdscript
const BINDING_TABLE: Dictionary = {
    "Button": {
        "styleboxes": {
            "normal":         {"bg": "surface_high",     "border": "outline",       "raised_role": "surface_high"},
            "hover":          {"bg": "surface_high",     "border": "outline",       "state": "hover",   "raised_role": "surface_high"},
            "pressed":        {"bg": "surface_high",     "border": "outline",       "state": "pressed", "raised_role": "surface_high"},
            "hover_pressed":  {"bg": "surface_high",     "border": "outline",       "state": "pressed", "raised_role": "surface_high"},
            "disabled":       {"bg": "surface_high",     "border": "outline",       "state": "disabled","raised_role": "surface_high"},
            "focus":          {"focus_ring": true},  # special: outer ring per §6
        },
        "colors": {
            "font_color":              {"role": "text_default"},
            "font_hover_color":        {"role": "text_default"},
            "font_pressed_color":      {"role": "text_strong"},
            "font_hover_pressed_color":{"role": "text_strong"},
            "font_disabled_color":     {"role": "text_default", "alpha": "disabled"},
            "font_focus_color":        {"role": "text_default"},
            "icon_normal_color":       {"role": "text_default"},
            "icon_disabled_color":     {"role": "text_default", "alpha": "disabled"},
        },
        "constants": {
            "h_separation":            {"value": "icon_label_gap"},     # platform-derived
            "icon_max_width":          {"value": "icon_max_width"},     # 0 = no clamp; per platform
        },
        "font_sizes": {
            "font_size":               {"role": "body_medium"},         # platform-derived: 14 desktop / 16 mobile
        },
    },
    "OptionButton": {
        # Inherits Button stylebox semantics but gets extra arrow-margin constant + arrow-modulate color
        "styleboxes": {/* same as Button */},
        "colors":     {/* same as Button + */},
        "constants":  {/* + "arrow_margin": {...}, "modulate_arrow": {...} */},
    },
    # ... 35+ more types ...
}

const TYPE_VARIATIONS: Dictionary = {
    "PrimaryButton":   {"base": "Button", "font_variation": "label_large_700",  "font_size_role": "title_medium"},
    "SecondaryButton": {"base": "Button", "font_variation": "label_large_500",  "font_size_role": "label_large"},
    "GhostButton":     {"base": "Button", "font_variation": "label_large_500",  "font_size_role": "label_large"},
    "DangerButton":    {"base": "Button", "font_variation": "label_large_700",  "font_size_role": "label_large"},
    "IconButton":      {"base": "Button", "font_variation": "label_small_500",  "font_size_role": "label_small"},
    "FlatButton":      {"base": "Button", "font_variation": "label_large_500",  "font_size_role": "label_large"},
    "HeaderLarge":     {"base": "Label",  "font_variation": "display_small",    "font_size_role": "display_small"},
    "HeaderMedium":    {"base": "Label",  "font_variation": "headline_small",   "font_size_role": "headline_small"},
    "HeaderSmall":     {"base": "Label",  "font_variation": "title_large",      "font_size_role": "title_large"},
    "Caption":         {"base": "Label",  "font_variation": "body_small",       "font_size_role": "body_small"},
    "CodeLabel":       {"base": "Label",  "font_variation": "code",             "font_size_role": "code"},
    "InfoText":        {"base": "RichTextLabel", "font_variation": "body_large","font_size_role": "body_large"},
    "CardPanel":       {"base": "Panel"},   # stylebox personality is Phase 5+
    "HeroPanel":       {"base": "Panel"},
}
```

**Why this shape works:**
- **Slot-name keys** are the Godot Theme API surface — what `set_stylebox(slot, type, ...)` consumes. No translation layer.
- **Property-name leaf keys** (`bg`, `border`, `state`, `raised_role`) describe HOW the formula computes the StyleBoxFlat. Centralizes the recipe; the formula reads recipes, not StyleBoxFlat literals.
- **No metadata tags on Resources.** No `_neocade_*_role` keys on the StyleBoxFlat. The binding table IS the metadata, kept centrally.
- **Untouched slots survive.** If a `.tres` has a Theme Editor authored stylebox at `Button:my_custom_slot` (not in the binding table), `_regenerate_theme()` never sees it — D-04 escape hatch preserved.

### 2.3 Why this is "the simplest workable approach"

- One file (`neocade_theme.gd`) holds the entire schema. Easy to grep, easy to refactor.
- No per-resource state. The `.tres` files contain ONLY the 9 `@export` values + Theme Editor authored overrides. No `_neocade_*` metadata to keep in sync.
- The schema is data; the formula is code. Adding a new type variation = add an entry to TYPE_VARIATIONS. Adding a new stylebox slot = add an entry to BINDING_TABLE. No code-changes-per-Control overhead.
- The binding table is the canonical answer to "what does Phase 4 own?" — the same file the planner uses to derive coverage tasks.

### 2.4 Revisable later (per user)

Phase 4 PLAN.md MUST document the binding mechanism as REVISABLE in the class header docstring AND in the `_regenerate_theme()` body docstring AND in the Phase 4 README. The user signaled they may prefer a property-name-convention approach (e.g., `NeoCadeTheme.button_bg_role := "surface_high"` on the resource) post-Phase-4. Phase 4 commits to the table approach with explicit "this is revisable" annotations so v1.x revision is cheap.

---

## §3 `@tool` + `.tres` deserialization order

### 3.1 The risk: regeneration before exports load

`@tool` `Resource` subclasses run `_init()` in BOTH editor and runtime. When a `.tres` is loaded:

1. Godot creates an instance via `_init()`.
2. Godot then sets every `@export` property from the `.tres` file (this fires the setter on every property).
3. Each setter triggers `_regenerate_theme()`.

**The risk:** if `_init()` calls `_regenerate_theme()` (as the spike does — line 43-44), regeneration runs once with class-default values, THEN runs again after each export setter (5-9 more times). On a `.tres` load this means 6-10 regenerations for a single load. Wastes time; risks in-editor flicker.

### 3.2 Mitigation strategies (pick one)

**Option A — `_init()` does NOT call `_regenerate()`; defer to setters:**
- Don't regenerate from `_init()`.
- The first setter that fires after a `.tres` deserialization triggers the first regeneration.
- Subsequent setters re-trigger. Reentry guard ignores re-entry within a single setter chain.
- BUT: between setters, Godot dispatches multiple regenerations in sequence — still N regenerations per load.

**Option B — Defer regeneration via `call_deferred("_regenerate_theme")`:**
- Setter doesn't call `_regenerate_theme()` directly; calls `call_deferred("_regenerate_theme")`.
- All N setters from a `.tres` load enqueue the same deferred call; Godot collapses to one execution at the end of the frame.
- **Risk:** `Resource` is not a `Node`; `call_deferred()` works on RefCounted but the deferred call fires on the next idle frame, not necessarily before the consumer reads from the Theme. For an `@export` change in editor, this is fine (editor has idle frames). For runtime `.tres` load, the Theme is consumed AT load time by the scene that referenced it — the deferred regeneration may not have fired by the time the Control reads from the Theme.

**Option C — Reentry-guarded direct call + a small "loaded" sentinel:**
- Setter does `_regenerate_theme()` directly.
- Reentry guard suppresses recursion within a single regenerate.
- Add a `_export_load_in_progress: bool` flag set true during deserialization, suppressing per-setter regenerations; do one final regeneration after the load completes.
- **Problem:** Godot doesn't expose a "deserialization complete" callback on `Resource`. There's `_setup_local_to_scene()` (only for scene-local resources) and there's no `_load_complete()`.

**Option D — Always regenerate on every setter; accept the cost; verify it's small:**
- The spike already does this. Per VERIFY-RESULTS.md it passed all 6 strict gates. Regeneration is fast (the spike measured `_last_regeneration_usec`).
- For a `.tres` load with 9 exports, that's 9-10 regenerations × ~0.5-2 ms each = ~5-20 ms. Acceptable for editor; acceptable for runtime (Theme is loaded once per scene, not per frame).
- **Phase 4 RECOMMENDATION: Option D.** Simplicity wins. Add benchmarks (`Time.get_ticks_usec()` around `_regenerate_theme()`, log to Output) in `@tool` mode for editor-time visibility. If real-world `.tres` load latency exceeds 50 ms, revisit in Phase 4 polish.

### 3.3 `_init()` policy

Phase 4 RECOMMENDATION: `_init()` does NOT call `_regenerate_theme()`. Reason: at instance creation (`NeoCadeTheme.new()`), the user has not yet set any `@export` values; default values are used. The first setter (or first `_get_*` API call from a Theme consumer) will trigger generation. For `.tres` loads, the deserialization sequence triggers setters; each setter regenerates.

**However** — if a consumer creates `NeoCadeTheme.new()` and reads from the Theme immediately without setting any export, the Theme would be empty. To handle this clean-instance case:

- Add an explicit public method `regenerate()` (or `force_regenerate()`) that consumers can call.
- Document in README that `NeoCadeTheme.new()` requires at least one `@export` set before reads, OR an explicit `force_regenerate()` call.
- OR: in `_init()`, set a flag `_dirty := true`. On first Theme API access (override `_get_*` lazily), regenerate-if-dirty. This is invasive — requires overriding `Theme` API methods. NOT recommended.

**Phase 4 RECOMMENDATION:** Call `_regenerate_theme()` from `_init()` IF this is a fresh instance (no `.tres` deserialization happening). Use the spike's pattern: `func _init() -> void: _regenerate()`. The deserialization-driven N+1 regenerations are tolerable per Option D.

### 3.4 Setter pattern (matches spike with naming changes)

```gdscript
@export var base_color: Color = Color("#111820"):
    set(value):
        if base_color == value: return
        base_color = value
        _regenerate_theme()

@export var accent_color: Color = Color("#8BD3FF"):
    set(value):
        if accent_color == value: return
        accent_color = value
        _regenerate_theme()

# ... same for raised, platform, corner_radius, spacing, raised_strength, focus_thickness, outline_width
```

**Key differences from spike:**
- No private `_base_color` backing fields with `get:` overrides — the `@export` direct-assignment pattern is sufficient and reads cleaner. The backing-field pattern in the spike was useful for the spike's debug visibility (`_last_regeneration_usec` etc.) but is incidental, not load-bearing.
- Add the equality short-circuit: `if base_color == value: return`. Avoids regeneration when an editor inspector re-applies the same value (common during scene save/load).
- Direct assignment to the `@export` property name is idiomatic GDScript.

---

## §4 The reentry guard

### 4.1 Spike pattern (works)

```gdscript
var _regenerating: bool = false

func _regenerate_theme() -> void:
    if _regenerating: return
    _regenerating = true
    # ... mutate Theme entries (set_stylebox, set_color, etc.) ...
    _regenerating = false
```

**Why needed:** mutations of Theme entries CAN trigger Godot signals or `Theme.changed` emissions. If those emissions trigger any chain that ends up re-calling a setter, the setter would re-call `_regenerate_theme()`. The flag suppresses this.

The spike's strict-gate verification (VERIFY-RESULTS.md) confirms this works: 6/6 PASS in Godot 4.6.2.

**Phase 4 RECOMMENDATION:** Adopt the spike's exact pattern. Don't over-engineer.

### 4.2 Editor-vs-runtime branch

Spike doesn't differentiate; runs the same path in editor and runtime. This is correct — `@tool` semantics. Phase 4 follows.

If a future use-case requires editor-only behavior, add `if Engine.is_editor_hint(): ...` branches inside `_regenerate_theme()`. None needed for Phase 4.

---

## §5 FontVariation authoring (Inter Variable Roman variations)

### 5.1 What FontVariation enables

`Inter-Variable.ttf` is a single variable font with axes: `wght` (weight, 100-900), `opsz` (optical size, 14-32). Each `FontVariation` resource selects a point in the axis space and exposes it as a discrete font.

Phase 4 needs ~5 FontVariation resources for the M3 type scale (per DESIGN_TOKENS §8.5):

| FontVariation file | wght | opsz | M3 token |
|---|---|---|---|
| `Inter-DisplaySmall.tres` | 800 | 32 | display-small (HeaderLarge) |
| `Inter-HeadlineSmall.tres` | 700 | 32 | headline-small (HeaderMedium) |
| `Inter-TitleLarge.tres` | 600 | 24 | title-large (HeaderSmall) |
| `Inter-LabelLarge.tres` | 500 | — | label-large (default for Caption variation if needed) |
| `Inter-Body.tres` | 400 | — | body-medium / body-large (default font for everything else) |

(Some of these may collapse into the FontFile's defaults; Phase 4 author decides.)

### 5.2 FontVariation `.tres` shape

```ini
[gd_resource type="FontVariation" load_steps=2 format=3]

[ext_resource type="FontFile" uid="uid://..." path="res://addons/neocade_theme/fonts/Inter-Variable.tres" id="1"]

[resource]
base_font = ExtResource("1")
variation_opentype = {
    "wght": 800,
    "opsz": 32,
}
```

(Variation OpenType axis tags use 4-char strings; `wght` and `opsz` are the registered tags.)

### 5.3 FontFile import settings (per FONT-08 + PITFALLS 5.5)

The `Inter-Variable.ttf` import settings (`.import` sidecar):
- Antialiasing: `Grayscale` (NOT LCD — LCD subpixel rendering is broken on macOS Retina + GL Compatibility)
- Hinting: `Light` (NOT Full — Full hinting destroys variable-axis interpolation)
- Subpixel positioning: `Auto`
- Force autohinter: `false`
- MSDF: `false` (MSDF is for SDF rendering; Phase 4 uses bitmap glyphs)
- `allow_system_fallback`: `true` (default; explicitly set in `.tres` for clarity per FONT-06)
- `fallbacks`: `[]` (empty)

### 5.4 Setting fonts on Theme entries

```gdscript
var inter_variable: FontFile = preload("res://addons/neocade_theme/fonts/Inter-Variable.tres")
theme.default_font = inter_variable

# Per-variation explicit fonts (PITFALLS 1.2 — variations don't inherit):
var display_small: FontVariation = preload("res://addons/neocade_theme/fonts/Inter-DisplaySmall.tres")
theme.set_font("font", "HeaderLarge", display_small)
theme.set_font_size("font_size", "HeaderLarge", 36)  # desktop; 32 mobile
```

### 5.5 OFL.txt requirements (per FONT-05)

`addons/neocade_theme/OFL.txt` ships:
- The full SIL Open Font License 1.1 text.
- Inter's Reserved Font Name notice: `"Inter"` is the Reserved Font Name; consumers who modify the binary must rename per OFL §3.
- Copyright line: `Copyright 2020 The Inter Project Authors (https://github.com/rsms/inter)`.
- The README points consumers to OFL.txt for embedding in their About/Credits.

Single-font OFL (Inter is the only bundled font); no Outfit/Noto/JetBrains entries.

---

## §6 Bespoke SVG icon authoring (Button-family, ~10 icons)

### 6.1 What Phase 4 ships (per D-10)

Per CONTEXT.md D-10 + DESIGN_TOKENS §11 + ICON-01..04:

- Button family: ~10 SVG icons at 32×32 reference, monochrome, `modulate`-tintable.
- File names (one suggestion; final naming Claude's discretion per CONTEXT.md `<decisions>`):
  - `check.svg` — CheckBox checkmark
  - `radio_unchecked.svg`, `radio_checked.svg` — radio button (CheckBox + radio)
  - `toggle_off.svg`, `toggle_on.svg` — CheckButton (the toggle-style switch)
  - `arrow_down.svg` — OptionButton arrow + dropdown indicators
  - `clear.svg` — LineEdit clear-text "x"
  - `close.svg` — Window close button (small "x")
  - `checkbox_unchecked.svg`, `checkbox_checked.svg` — CheckBox box
- Each icon is a simple SVG (no embedded raster, no gradient fills, single solid `fill="#FFFFFF"` so Godot's `modulate` can tint).
- Each icon ships with a `.import` sidecar setting:
  - `Scale = 2.0` (high-DPI rendering — 32×32 source → 64×64 effective)
  - `Filter = Linear With Mipmaps`

### 6.2 SVG authoring approach

Phase 4 may author SVGs by:
- **Hand-written SVG XML** — simplest for a small set; full control over path structure; ~10-20 lines of XML per icon.
- **Material Symbols / open-source icon mining** — pull simple-shape references; redraw to NeoCade visual standard. NOT bundling Material Symbols (forbidden per ICON-04).
- **Programmatic generation** — only worth it for parametric icons (e.g., toggle in 8 sizes). Phase 4's ~10 icons don't need it.

**Recommendation:** Hand-written SVG. Each file ~15-30 lines; auditable.

Sample (`check.svg`):
```xml
<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32" width="32" height="32">
  <path d="M6 16 L13 23 L26 9" fill="none" stroke="#FFFFFF" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
```

### 6.3 `.import` sidecar template

Each icon needs a `.import` sidecar. Godot generates these on first import; Phase 4 must verify+commit each one with the correct `Scale = 2.0` and `Linear With Mipmaps` filter.

Sample (`check.svg.import`):
```ini
[remap]
importer="texture"
type="CompressedTexture2D"
uid="uid://..."  ; Godot-generated
path="res://.godot/imported/check.svg-<hash>.ctex"
metadata={"vram_texture": false}

[deps]
source_file="res://addons/neocade_theme/icons/check.svg"
dest_files=["res://.godot/imported/check.svg-<hash>.ctex"]

[params]
compress/mode=0
compress/high_quality=false
compress/lossy_quality=0.7
compress/hdr_compression=1
compress/normal_map=0
compress/channel_pack=0
mipmaps/generate=true
process/fix_alpha_border=false
process/premult_alpha=false
process/normal_map_invert_y=false
process/hdr_as_srgb=false
process/hdr_clamp_exposure=false
process/size_limit=0
detect_3d/compress_to=1

; SVG-specific
svg/scale=2.0
editor/scale_with_editor_scale=false
editor/convert_colors_with_editor_theme=false
```

(Field set verified against Godot 4.6 SVG importer; `mipmaps/generate=true` enables Linear With Mipmaps filter.)

**Phase 4 task ordering for icons:**
1. Author SVG file at `addons/neocade_theme/icons/{name}.svg`.
2. Open in Godot Editor (forces import); commit the auto-generated `.import` sidecar.
3. Edit sidecar to set `svg/scale=2.0` + `mipmaps/generate=true`. Re-import.
4. Verify sidecar committed.

### 6.4 Wiring icons in `_regenerate_theme()`

```gdscript
const ICON_PATH := "res://addons/neocade_theme/icons/"

const ICON_BINDING := {
    "CheckBox": {
        "checked":     ICON_PATH + "checkbox_checked.svg",
        "unchecked":   ICON_PATH + "checkbox_unchecked.svg",
        "radio_checked":  ICON_PATH + "radio_checked.svg",
        "radio_unchecked":ICON_PATH + "radio_unchecked.svg",
    },
    "CheckButton": {
        "checked":     ICON_PATH + "toggle_on.svg",
        "unchecked":   ICON_PATH + "toggle_off.svg",
    },
    "OptionButton": {
        "arrow":       ICON_PATH + "arrow_down.svg",
    },
    "LineEdit": {
        "clear":       ICON_PATH + "clear.svg",
    },
    "Window": {
        "close":       ICON_PATH + "close.svg",
        "close_pressed": ICON_PATH + "close.svg",  # tinted via close_h_color
    },
}

# In _regenerate_theme():
for theme_type in ICON_BINDING:
    for icon_slot in ICON_BINDING[theme_type]:
        var icon_path: String = ICON_BINDING[theme_type][icon_slot]
        var icon: Texture2D = load(icon_path)
        set_icon(icon_slot, theme_type, icon)
```

Non-Button icons (Tree expand/collapse, ColorPicker, FileDialog, ScrollBar, TabBar) are deferred to Phases 6/7 per D-11 — they follow the same import contract.

---

## §7 Pulse verification methodology

### 7.1 What "matches Phase 3.4 mockup output" means

Per DESIGN_TOKENS §12.5 + CONTEXT.md `<specifics>`, Phase 4 must verify Pulse's regeneration produces output that matches the Phase 3.4 finalist mockup at `.planning/mockups/3.4/finalist-gallery.html` (Pulse 4-grid: flat × raised × desktop × mobile).

**Concrete checks Phase 4 should run on Pulse:**
1. **Surface ramp values match.** Compute `surface_low/panel/high/overlay` in GDScript using DESIGN_TOKENS §6.2 formulas; compare to mockup CSS variables (the renderer computes them from the same `deriveSurfaceRamp()` JS function). Hex strings should match within ±1 byte/channel due to GDScript ↔ JS float precision differences.
2. **Accent on base WCAG ratio.** Pulse should be 13.62:1 (per DESIGN_TOKENS §2). Run a contrast computation in GDScript; assert ≥13.6:1 floor.
3. **`is_light` flag behavior.** Set `base_color = Color("#F0F0F0")`; assert `is_light == true`; assert `surface_high` flips to mix toward BLACK (not WHITE).
4. **Toggle exports trigger regeneration.** Programmatically: load `pulse_neocade_theme.tres`, set `accent_color = Color("#FF0000")`, assert `Button:focus.border_color == Color("#FF0000")`. Set `raised = true`, assert `Button:normal.shadow_size > 0`.
5. **Type variation registration.** Assert `theme.get_type_variation_base("PrimaryButton") == "Button"` after regenerate.
6. **Slot coverage smoke test.** Walk BINDING_TABLE; for each (type, stylebox_slot), assert `theme.has_stylebox(slot, type) == true`.
7. **Theme Editor visual confirmation.** Open `pulse_neocade_theme.tres` in Theme Editor; visually confirm every type lists every expected slot with non-engine-default values. (Phase 4 SUMMARY captures a screenshot for evidence.)
8. **Scene smoke test.** Phase 4 last task: assign `pulse_neocade_theme.tres` to `showcase/showcase.tscn`; manually launch Godot Editor; confirm controls render in Pulse-flavored colors without errors in Output.

### 7.2 Test scaffolding for Phase 4 (acceptable level)

Phase 4 doesn't need full GUT/test-runner integration. A single GDScript test scene under `addons/neocade_theme/_phase4_verify.gd` (NOT shipped in v1; deleted in Phase 11) that loads each direction `.tres`, asserts coverage, asserts a sample of computed colors, and prints PASS/FAIL is sufficient for Phase 4 close. Phase 9 / 10 own the full QA scaffolding.

---

## §8 The minimal `_regenerate_theme()` shape Phase 4 must ship

Synthesizing §1-§5 into the production class skeleton (paraphrased; final code is Phase 4 implementation work):

```gdscript
@tool
class_name NeoCadeTheme
extends Theme

enum Platform { DESKTOP, MOBILE, AUTO }

@export var base_color: Color = Color("#111820"): set = _set_base_color
@export var accent_color: Color = Color("#8BD3FF"): set = _set_accent_color
@export var raised: bool = false: set = _set_raised
@export var platform: Platform = Platform.AUTO: set = _set_platform

@export_group("Shape")
@export var corner_radius: int = 12: set = _set_corner_radius
@export var spacing: int = 4: set = _set_spacing
@export var raised_strength: int = 3: set = _set_raised_strength
@export var focus_thickness: int = 2: set = _set_focus_thickness
@export var outline_width: int = 1: set = _set_outline_width

var is_light: bool = false  # NOT exported; computed from base_color luminance
var _regenerating: bool = false
var _last_regeneration_usec: int = 0

func _init() -> void:
    _regenerate_theme()

# Setters (one per @export; example)
func _set_base_color(value: Color) -> void:
    if base_color == value: return
    base_color = value
    _regenerate_theme()
# ... 8 more setters with the same shape ...

func _regenerate_theme() -> void:
    if _regenerating: return
    _regenerating = true
    var t0 := Time.get_ticks_usec()
    
    is_light = base_color.get_luminance() >= 0.5
    var p: Platform = _resolve_platform()
    var roles: Dictionary = _compute_roles(p)  # surface ramp + state layers + offsets + text colors
    var fonts: Dictionary = _resolve_fonts(p)  # FontFile + FontVariation lookups
    var sizes: Dictionary = _resolve_sizes(p)  # platform-derived font sizes + density spacings + tap target floors
    
    # Default font (applies to base types via Theme inheritance)
    default_font = fonts.body_inter_variable
    default_font_size = sizes.body_medium
    
    # Walk binding table — populates 37 base types + their stylebox/color/constant/font_size slots
    for theme_type in BINDING_TABLE:
        _regenerate_type_entries(theme_type, BINDING_TABLE[theme_type], roles, fonts, sizes, p)
    
    # Register variations + set explicit fonts (PITFALLS 1.2)
    for variation in TYPE_VARIATIONS:
        var meta: Dictionary = TYPE_VARIATIONS[variation]
        set_type_variation(variation, meta.base)
        if meta.has("font_variation"):
            set_font("font", variation, fonts[meta.font_variation])
        if meta.has("font_size_role"):
            set_font_size("font_size", variation, sizes[meta.font_size_role])
    
    # Wire bespoke icons (Phase 4: Button family only)
    for theme_type in ICON_BINDING:
        for icon_slot in ICON_BINDING[theme_type]:
            set_icon(icon_slot, theme_type, load(ICON_BINDING[theme_type][icon_slot]))
    
    _last_regeneration_usec = Time.get_ticks_usec() - t0
    _regenerating = false

# _regenerate_type_entries(): walks {styleboxes, colors, constants, font_sizes} for one type.
# _compute_roles(): returns surface_low/panel/high/overlay + accent + accent_offset + state_hover/pressed +
#                   disabled_alpha + text_strong/default/muted + outline_color.
# _resolve_fonts(): returns {body_inter_variable, display_small, headline_small, title_large, ...}.
# _resolve_sizes(): returns {display_small, headline_small, body_medium, label_small, button_min, primary_button_min, ...}.
# _resolve_platform(): if platform == AUTO → MOBILE if OS.has_feature("mobile") else DESKTOP.
```

This is the shape Phase 4's `neocade_theme.gd` lands on. Total LOC estimate: 600-1000 lines (binding table is the bulk).

---

## §9 Validation Architecture (Nyquist Dimension 8)

Per `gsd-sdk` / Nyquist validation guidance, every phase needs a validation strategy: what we're measuring, sample resolution, regression baselines.

### 9.1 What Phase 4 validates

| Validation | Method | Sample resolution | Pass threshold |
|---|---|---|---|
| Class shape correctness | Static inspection of `neocade_theme.gd` for the 9 `@export` properties + correct types + correct group label + setter wiring | All 9 exports + `is_light` + `Platform` enum + `_regenerate_theme()` body | 9/9 exports correct + `is_light` non-exported + Platform enum present + setters fire regenerate |
| Iteration engine no-clear | Search `neocade_theme.gd` for `clear()` call inside `_regenerate_theme()` | `_regenerate_theme()` body + helpers | Zero `clear()` calls in regeneration path (D-01 enforcement) |
| Binding table coverage | Walk BINDING_TABLE keys against the 37-row scorecard from `MINIMAL-THEME-COVERAGE-DELTA.md` | All 37 types | Every scorecard row has at least one binding entry |
| Type variation registration | After regenerate, query `theme.get_type_variation_base()` for each of the 13 names | All 13 variations | Each returns expected base type |
| Per-variation explicit fonts | After regenerate, query `theme.has_font("font", variation)` for each variation that needs one (per PITFALLS 1.2) | All variations with font role | Each returns true |
| Surface ramp formula correctness | Compute surface ramp for each of 5 directions; compare to renderer JS output | 5 directions × 5 stops × 3 channels | Within ±1 byte/channel (GDScript ↔ JS float precision tolerance) |
| `is_light` flag behavior | Set `base_color = Color("#F0F0F0")`; assert `is_light == true`; assert `surface_high` mix target flips to BLACK | 2 cases (dark default + light test) | Both correct |
| Setter triggers regenerate | Set `accent_color = Color("#FF0000")` on a loaded `pulse_neocade_theme.tres`; assert downstream stylebox border_color updates | 1 sample property change → 1 sample stylebox slot read | Updated value present |
| Per-direction `.tres` load | Load each of the 5 `.tres`; assert `Theme` instance with correct `@export` values | 5 files | All 5 load with correct values |
| Pulse mockup parity | Visual comparison of Pulse-rendered scene vs `.planning/mockups/3.4/finalist-gallery.html` (Pulse 4-grid) | Visual eyeball + spot-check 3 hex values | "looks recognizably the same"; spot-checked hexes within tolerance |
| Font import settings | Inspect `Inter-Variable.ttf.import` for grayscale AA + light hinting + auto subpixel | One file | All three settings correct |
| Icon import scale + filter | Inspect each `*.svg.import` for `svg/scale=2.0` + `mipmaps/generate=true` | All Phase 4 icons (~10) | Both correct on every file |
| Scaffold deletion + scene update | `addons/neocade_theme/neocade_theme.tres` does not exist; `showcase/showcase.tscn` references `pulse_neocade_theme.tres` | 2 file states | Both true |
| OFL + addon metadata | `OFL.txt` contains "Inter" + "Reserved Font Name" + OFL 1.1 license body; `LICENSE.md`, `CHANGELOG.md`, `VERSION`, `README.md` exist with required content | 5 files + 3 OFL substrings | All present |

### 9.2 Sample resolution

Phase 4 validates against:
- **Code-level:** static greps + GDScript helper script that loads each `.tres`, walks BINDING_TABLE + TYPE_VARIATIONS, asserts coverage + spot-checks 5-10 computed values per direction.
- **Editor-level:** open each `.tres` in Theme Editor; visually confirm every type has every expected slot. Capture screenshots for SUMMARY evidence.
- **Runtime-level:** manually launch `showcase/showcase.tscn` in Godot Editor; verify Controls render in Pulse colors without errors. Phase 4 doesn't need export-target QA (Phase 10 owns).

### 9.3 Regression baseline

For Phase 4's verification gates to be repeatable:
- Phase 4 SUMMARY archives screenshots of the 5 directions' Theme Editor views.
- Phase 4 SUMMARY archives the GDScript helper's output (computed surface ramps for each direction).
- Future Phase 5/6/7 work that touches `_regenerate_theme()` regression-checks against these baselines.

---

## §10 Risks, gotchas, "do not confuse with the spike"

### 10.1 Spike landmines (must NOT carry forward)

| Spike behavior | Why it's wrong for production | Phase 4 must |
|---|---|---|
| `clear()` in `_regenerate()` | D-01 forbids — destroys Theme Editor authored content | Implement additive iteration via BINDING_TABLE walk |
| Private `_base_color` etc. backing fields | Incidental; cleaner to use direct `@export` assignment | Use direct `@export var name: T:` pattern |
| `_theme_profile()` returns hard-coded constants | Spike's "subclass profile" pattern is HISTORICAL (D-31 superseded subclasses) | Replace with `_compute_roles(p)` driven by `@export` + DESIGN_TOKENS formulas |
| `_after_base_regenerate()` hook | Subclass extension point — not used in single-class architecture | Remove |
| Spike covers 6 Control types | Insufficient for SC#7 (37 types + 13 variations) | Cover ALL 37 base types + register all 13 variations |
| `_make_box()` `set_content_margin_all(maxi(4, int(minimum * 0.28)))` heuristic | Heuristic; production should use DESIGN_TOKENS values | Port `spacing` + `tapPadding` derivations from DESIGN_TOKENS §10.1 |
| `set_font_size("font_size", "Button", 15)` desktop default | Hard-coded; doesn't use DESIGN_TOKENS §8.5 type scale | Read from `_resolve_sizes(p)` table per DESIGN_TOKENS §8.5 + §10.1 |

### 10.2 PITFALLS to enforce in Phase 4 code

Per CONTEXT.md `<canonical_refs>` PITFALLS reference:
- **1.1 (focus is OUTSIDE corner radius):** focus stylebox uses `expand_margin_*` (not corner_radius adjustment) and `border_width_*` for the ring. Ring color = `accent_color`. Verified visually.
- **1.2 (variations don't inherit fonts):** explicit `set_font("font", variation, ...)` on every variation. Tested via `theme.has_font("font", variation) == true` post-regenerate.
- **1.6 (integer pixels under GL Compatibility):** ALL `corner_radius_*` / `border_width_*` / `content_margin_*` / `expand_margin_*` use `int`. No `float` widths.
- **1.7 (popups are separate Windows):** PopupPanel, PopupMenu, AcceptDialog, ConfirmationDialog, FileDialog, TooltipPanel, TooltipLabel, Window are EACH first-class theme types in BINDING_TABLE. Not assumed to inherit Panel theming.
- **5.5 (font hinting for GL Compatibility):** Light hinting + grayscale AA + auto subpixel — all set in `Inter-Variable.ttf.import`.
- **10.3 (clean state switching):** `hover_pressed` slot exists for Button (not just hover OR pressed alone); state combos render correctly per the Pitfall 1.1 + state combination matrix in DESIGN_TOKENS §7.3.

### 10.3 GL Compatibility-specific concerns

The project's renderer is GL Compatibility (`project.godot` line — verified via CONTEXT.md `<code_context>`). Per SUMMARY Conflict 3 + GitHub #23640:
- NO drop shadows in v1 → every StyleBoxFlat has `shadow_size = -1` when `raised = false`.
- When `raised = true`, `shadow_size = raised_strength` + `shadow_offset = Vector2(0, raised_strength)`. Hard offset, no blur. Verified to render correctly under GL Compatibility per Phase 3.4 mockup output.
- LCD subpixel AA: NOT used. Grayscale AA only.
- MSDF: NOT used. Bitmap glyphs.

### 10.4 Theme Editor compatibility

Per D-02, the `@export` + `_regenerate_theme()` model must coexist seamlessly with Theme Editor authoring. Phase 4 verification:
- Open `pulse_neocade_theme.tres` in Theme Editor; manually edit a stylebox property; save; reload; verify the manual edit survives a regeneration triggered by a subsequent `@export` change. (This is the D-04 escape hatch in action — the manual edit is at a slot NOT in BINDING_TABLE; it survives.)
- Conversely: open `pulse_neocade_theme.tres`; manually edit `Button:normal.bg_color` (a slot IN BINDING_TABLE); save; toggle `raised`; verify the manual edit gets overwritten by the regenerated value. (Bound slots are formula-owned; manual edits to them are intentionally clobbered.)

These two tests confirm the binding-table boundary.

---

## §11 Phase 4 verification gates the planner should bake into PLAN.md `must_haves`

Synthesizing CONTEXT.md decisions + DESIGN_TOKENS §12.5 + this research, the planner's PLAN.md `must_haves` for Phase 4 should include (verbatim or paraphrased — these are the goal-backward verification anchors):

1. `addons/neocade_theme/neocade_theme.tres` is DELETED; `showcase/showcase.tscn` references `pulse_neocade_theme.tres`. (D-14 step 1, FOUND-01.)
2. `addons/neocade_theme/neocade_theme.gd` declares `@tool class_name NeoCadeTheme extends Theme` with all 9 `@export` properties + `is_light` (non-export) + setters firing `_regenerate_theme()`. (FOUND-02.)
3. `_regenerate_theme()` does NOT call `clear()`. (D-01.)
4. `_regenerate_theme()` walks a BINDING_TABLE that covers all 37 scorecard Control types. (D-09, SC#7.)
5. All 13 type variations are registered via `set_type_variation()`; each variation has `font` set explicitly (PITFALLS 1.2). (TYPEVAR-01..05.)
6. Inter Variable Roman is bundled at `addons/neocade_theme/fonts/Inter-Variable.ttf` with import settings: Grayscale AA + Light hinting + Auto subpixel; `OFL.txt` contains Inter Reserved Font Name notice + OFL 1.1 license body. (FONT-01, FONT-05, FONT-06, FONT-08.)
7. ~5 FontVariation `.tres` files at `addons/neocade_theme/fonts/` for the M3 type scale (display-small, headline-small, title-large, body, label-small or similar split). (FONT-06, TOKEN-10.)
8. ~10 Button-family bespoke SVG icons at `addons/neocade_theme/icons/` with `.import` sidecars setting `svg/scale=2.0` + `Linear With Mipmaps`. (ICON-01..04, D-10, D-11.)
9. 5 `.tres` files at addon root: `pulse_neocade_theme.tres` (FIRST per D-14 + DESIGN_TOKENS §12.4), `slate_neocade_theme.tres`, `bubble_neocade_theme.tres`, `daybreak_neocade_theme.tres`, `burst_neocade_theme.tres` — each with the `@export` values from DESIGN_TOKENS §5.1-§5.5. (FOUND-03.)
10. Loading any of the 5 `.tres` produces a `Theme` with `has_stylebox(slot, type) == true` for every slot in BINDING_TABLE for every type. (SC#7 strict reading — D-09.)
11. Setting `raised = true` then `false` on a loaded `.tres` produces correctly toggled `shadow_size` values on raised-eligible Controls (per §9.2 raised intensity by family). (FOUND-02 setter wiring.)
12. Setting `platform = MOBILE` on a loaded `.tres` produces tap targets ≥48px on every interactive Control. (Smoke test for MOBILE-02 — full audit is Phase 8.)
13. Setting `base_color = Color("#F0F0F0")` produces `is_light == true` and surface ramp uses BLACK (not WHITE) as the elevate target. (DESIGN_TOKENS §6.2 `is_light` flip.)
14. README documents: consumer pattern (`preload("res://addons/neocade_theme/{name}_neocade_theme.tres")`), recommended starter (Pulse), custom theme authoring (`NeoCadeTheme.new()`), CJK override pattern (UD-2 / FONT-09(a)). (FOUND-01 metadata + FONT-09.)
15. Addon metadata files exist: `OFL.txt` (FONT-05), `LICENSE.md`, `CHANGELOG.md`, `VERSION` (single line), `README.md` (Phase 4 minimal — Phase 11 expands). NO `plugin.cfg`. (FOUND-01, STACK Decision 5, D-05.)
16. Pulse-rendered scene visually matches Phase 3.4 finalist mockup (Pulse 4-grid). (DESIGN_TOKENS §12.5; manual eyeball + spot-check 3 hex values.)
17. Phase 4 PLAN.md documents the binding mechanism choice (slot-name + property-name table) as REVISABLE per CONTEXT.md `<specifics>`. (D-03 TENTATIVE preserved.)

These 17 gates are the direct goal-backward verification anchors. Plan tasks should each map to one or more of these gates via their `acceptance_criteria` fields.

---

## §12 Suggested plan structure (planner input)

The planner has wide latitude here, but a sensible 6-8 plan breakdown derived from D-14 + DESIGN_TOKENS §12.4 + this research:

### Plan 04-01 — Scaffold deletion + class shell (Wave 1)
- Delete `addons/neocade_theme/neocade_theme.tres`.
- Update `showcase/showcase.tscn` to reference (TBD pending Plan 04-07; in this plan, leave a temporary direct theme assignment or comment).
- Author `addons/neocade_theme/neocade_theme.gd` shell: `@tool class_name NeoCadeTheme extends Theme`, 9 `@export` properties (Core 4 + Shape 5 with `@export_group`), enum `Platform`, `is_light` var, `_regenerating` flag, setters with equality short-circuit, `_init()` calling `_regenerate_theme()`, empty `_regenerate_theme()` skeleton (just sets `is_light` for now; full body in Plan 04-04/05).
- Document binding-mechanism choice as REVISABLE in class-level docstring.
- Requirements: FOUND-02 (partial — class shape).
- must_haves: 1, 2, 3 (no `clear()` in skeleton already).
- autonomous: true.

### Plan 04-02 — Fonts (Wave 1)
- Bundle `Inter-Variable.ttf` at `addons/neocade_theme/fonts/Inter-Variable.ttf`.
- Author `Inter-Variable.ttf.import` with Grayscale AA + Light hinting + Auto subpixel.
- Author `Inter-Variable.tres` (FontFile pointing to the TTF).
- Author 4-5 FontVariation `.tres` files for the M3 type scale (HeaderLarge/Medium/Small + body + caption/code if needed).
- Author `OFL.txt` with full OFL 1.1 + Inter Reserved Font Name notice + Inter copyright line.
- Requirements: FONT-01, FONT-05, FONT-06, FONT-07 (synthetic italic note in CHANGELOG only — covered in Plan 04-08), FONT-08.
- must_haves: 6, 7.
- autonomous: true (Inter TTF is downloadable; OFL is a known text).

### Plan 04-03 — Icons (Wave 1, parallel with 04-02)
- Author ~10 bespoke SVG icons at `addons/neocade_theme/icons/{name}.svg` per D-10 (check, radio_checked, radio_unchecked, toggle_on, toggle_off, arrow_down, clear, close, checkbox_checked, checkbox_unchecked).
- Verify import (Godot generates `.import`); edit each sidecar to set `svg/scale=2.0` + `mipmaps/generate=true` (Linear With Mipmaps); re-import.
- Requirements: ICON-01, ICON-02 (Button family subset), ICON-03, ICON-04.
- must_haves: 8.
- autonomous: true (hand-author SVG XML).

### Plan 04-04 — Color formulas + role tokens + surface ramp (Wave 2)
- Implement helpers: `_mix(a, b, amount)`, `_tint_toward_base(elem, base, ratio)`, `_compute_roles(platform)`, `_resolve_platform()`.
- Implement state-layer overlay computation (DESIGN_TOKENS §6.5): `state_hover`, `state_pressed`, `disabled_alpha`.
- Implement text-color flip (DESIGN_TOKENS §6.4) on `is_light`.
- Implement raised-stylebox helper (DESIGN_TOKENS §9.2) — `_make_raised_stylebox(bg, offset_color, ...)`.
- Depends on: Plan 04-01.
- Requirements: TOKEN-01, TOKEN-02, TOKEN-03, TOKEN-08, TOKEN-09 (in code).
- must_haves: 13 (`is_light` flip).
- autonomous: true.

### Plan 04-05 — BINDING_TABLE + iteration engine + variation registration (Wave 2)
- Author the BINDING_TABLE constant covering all 37 scorecard Control types + their stylebox/color/constant/font_size slots.
- Author the TYPE_VARIATIONS constant for the 13 variations.
- Author the `_regenerate_theme()` body: walk BINDING_TABLE; for each (type, slot), apply role recipe; mutate-in-place if slot exists, create-if-empty.
- Register all 13 variations + apply explicit fonts per PITFALLS 1.2.
- Wire icon binding (the ~10 icons from Plan 04-03).
- Depends on: Plan 04-01, 04-02, 04-03, 04-04.
- Requirements: FOUND-02 (full body), TYPEVAR-01..05, ICON-02 (wiring).
- must_haves: 4, 5, 10, 17.
- autonomous: true.

### Plan 04-06 — Pulse `.tres` (Wave 3)
- Author `addons/neocade_theme/pulse_neocade_theme.tres` with `@export` values from DESIGN_TOKENS §5.1.
- Verify `_regenerate_theme()` produces correct surface ramp + accent + state layers + raised offsets matching Phase 3.4 finalist mockup.
- Run §11 verification gates 10, 11, 13, 16.
- Depends on: Plan 04-04, 04-05.
- Requirements: FOUND-03 (Pulse subset).
- must_haves: 9 (Pulse), 11, 12 (smoke), 13, 16.
- autonomous: true.

### Plan 04-07 — Slate / Bubble / Daybreak / Burst `.tres` + showcase/showcase.tscn update (Wave 4)
- Author `addons/neocade_theme/slate_neocade_theme.tres` per DESIGN_TOKENS §5.2.
- Author `bubble_neocade_theme.tres` per §5.3.
- Author `daybreak_neocade_theme.tres` per §5.4.
- Author `burst_neocade_theme.tres` per §5.5.
- Update `showcase/showcase.tscn` to reference `pulse_neocade_theme.tres`.
- Verify each `.tres` loads without errors; spot-check distinct visual identity per direction.
- Depends on: Plan 04-06.
- Requirements: FOUND-03 (full set).
- must_haves: 9 (full set), 1 (showcase/showcase.tscn).
- autonomous: true.

### Plan 04-08 — Addon metadata + Phase 4 README (Wave 4, parallel with 04-07)
- Author `addons/neocade_theme/LICENSE.md` (project license — likely MIT, follow project convention).
- Author `addons/neocade_theme/CHANGELOG.md` with `[Unreleased]` section + Phase 4 deliverables (Phase 11 expands for v1.0.0).
- Author `addons/neocade_theme/VERSION` (single line, e.g., `0.4.0` or whatever the project's pre-release versioning convention is).
- Author `addons/neocade_theme/README.md` (Phase 4 minimal — Phase 11 expands): consumer pattern (`preload(...)`), recommended starter (Pulse), custom theme authoring (`NeoCadeTheme.new()`), CJK override pattern (UD-2 / FONT-09(a)), binding-mechanism revisability note.
- Verify `OFL.txt` (from Plan 04-02) + LICENSE.md + CHANGELOG.md + VERSION + README.md all exist.
- Depends on: Plan 04-02 (OFL).
- Requirements: FOUND-01, FONT-09 (README content).
- must_haves: 14, 15.
- autonomous: true.

**8 plans, 4 waves**:
- Wave 1: Plans 04-01, 04-02, 04-03 (parallel — class shell + fonts + icons).
- Wave 2: Plans 04-04, 04-05 (parallel-eligible if 04-04 finishes first; otherwise sequential — formulas first, then engine).
- Wave 3: Plan 04-06 (Pulse — depends on engine + formulas).
- Wave 4: Plans 04-07, 04-08 (parallel — peer themes + metadata).

(The planner may collapse 04-04/04-05 if it judges the engine-and-formulas split too thin, or split 04-05 by Control type group if too thick. This research doesn't mandate the exact split — just gives a reasonable starting point.)

---

## §13 Summary for the planner

**The Phase 4 planning surface is unusually narrow.** DESIGN_TOKENS.md owns values; CONTEXT.md owns architecture; this research owns engine-level open questions. The planner's job is sequencing tasks against the binding-table-walk strategy, the Wave 1 parallelism (class shell + fonts + icons), and the Pulse-first verification gate. Use D-14's task ordering as the high-level skeleton; let DESIGN_TOKENS §12.4 + §12.5 serve as the per-direction checklist and verification gates.

**Key novel decisions this research locks in (preview for the planner):**
1. Binding mechanism: nested Dictionary `BINDING_TABLE` keyed by `theme_type → data_type → slot_name → recipe`. Compiled into `neocade_theme.gd`. No per-resource metadata. Documented as REVISABLE.
2. Reentry guard + `_init()` policy: spike's `_regenerating: bool` is sufficient; `_init()` calls `_regenerate_theme()`; setter equality short-circuit avoids no-op regenerations.
3. Iteration: mutate-in-place for existing StyleBoxFlat slots; `set_*` to install new ones for first generation. Slots NOT in BINDING_TABLE are untouched (D-04 escape hatch).
4. Type variation discipline: `set_type_variation()` registers; explicit `set_font()` per variation per PITFALLS 1.2.
5. FontVariation: 4-5 resources at `fonts/` for M3 type scale via Inter Variable axes (`opsz`, `wght`).
6. Bespoke icons: ~10 SVG at 32×32 monochrome with `svg/scale=2.0` + Linear With Mipmaps `.import` sidecar.
7. Verification: GDScript helper at `addons/neocade_theme/_phase4_verify.gd` (deleted in Phase 11) for slot-coverage + spot-checked computed values + `is_light` flip + raised toggle behavior.

**No further research required before planning.** All open engine questions are resolved by this document; the planner can proceed.

## RESEARCH COMPLETE

Phase 4 research complete. Core technical resolutions: binding-table architecture (nested Dictionary, compiled into `.gd`, revisable per user signal), iteration engine pattern (mutate-in-place, no `clear()`, walks BINDING_TABLE for the 37 scorecard Control types), `_init()` + setter pattern (spike's `_regenerating` flag works, equality short-circuit added), FontVariation strategy (4-5 resources for M3 scale via Inter axes), bespoke SVG icon authoring + import contract (~10 icons, `svg/scale=2.0`, Linear With Mipmaps), Pulse-first verification methodology (visual + spot-checked hex + slot coverage), and 17 must_have gates derived from PROJECT requirements + DESIGN_TOKENS §12.5. Suggested 8-plan, 4-wave breakdown documented for the planner.
