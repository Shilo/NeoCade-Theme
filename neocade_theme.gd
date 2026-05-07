@tool
class_name NeoCadeTheme
extends Theme

## NeoCade Theme — single concrete `@tool extends Theme` class for the NeoCade addon.
##
## Architecture (locked 2026-05-06f, D-31): one concrete instantiable class + N data-only `.tres`
## peers at `addons/neocade_theme/{name}_neocade_theme.tres`. Per-direction unique mood lives in
## Theme Editor entry overrides per `.tres`, NOT in additional `@export` properties.
##
## Setters on every `@export` property trigger `_regenerate_theme()`, which walks an internal
## BINDING_TABLE (Plan 04-05) to populate every formula-owned theme entry. Slots NOT in the
## binding table are LEFT UNTOUCHED (D-04 escape hatch — Theme Editor authored content survives).
##
## Binding mechanism (D-03 TENTATIVE): the current implementation uses a slot-name + property-name
## table compiled into this file. The user has signaled this may be revised toward a property-name
## convention or a metadata-tagged Resource model post-Phase-4. **This implementation is REVISABLE
## without breaking the public `@export` surface or the `.tres` file format** — only the internal
## binding mechanism would change.
##
## See: .planning/DESIGN_TOKENS.md, .planning/phases/04-.../04-RESEARCH.md, .planning/phases/04-.../04-CONTEXT.md.

enum Platform { DESKTOP, MOBILE, AUTO }

# ─── Core exports (DESIGN_TOKENS §4.1 rows 1-4) ─────────────────────────────────────────────
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

@export var raised: bool = false:
	set(value):
		if raised == value: return
		raised = value
		_regenerate_theme()

@export var platform: Platform = Platform.AUTO:
	set(value):
		if platform == value: return
		platform = value
		_regenerate_theme()

# ─── Shape exports (DESIGN_TOKENS §4.1 rows 5-9) ────────────────────────────────────────────
@export_group("Shape")

@export var corner_radius: int = 12:
	set(value):
		if corner_radius == value: return
		corner_radius = value
		_regenerate_theme()

@export var spacing: int = 4:
	set(value):
		if spacing == value: return
		spacing = value
		_regenerate_theme()

@export var raised_strength: int = 3:
	set(value):
		if raised_strength == value: return
		raised_strength = value
		_regenerate_theme()

@export var focus_thickness: int = 2:
	set(value):
		if focus_thickness == value: return
		focus_thickness = value
		_regenerate_theme()

@export var outline_width: int = 1:
	set(value):
		if outline_width == value: return
		outline_width = value
		_regenerate_theme()

# ─── Internal state (NOT exported) ──────────────────────────────────────────────────────────
var is_light: bool = false  # derived from base_color.get_luminance() at every regenerate
var _regenerating: bool = false  # reentry guard (per RESEARCH.md §4)
var _last_regeneration_usec: int = 0  # diagnostic; logged via Output in editor

func _init() -> void:
	_regenerate_theme()

func _regenerate_theme() -> void:
	if _regenerating: return
	_regenerating = true
	var t0 := Time.get_ticks_usec()

	is_light = base_color.get_luminance() >= 0.5
	var p: Platform = _resolve_platform()
	var tokens: Dictionary = _platform_tokens(p)
	var presets: Dictionary = _resolve_direction_presets()  # Cross-AI Cycle 1 C2 fix

	# ── Surface ramp (DESIGN_TOKENS §6.2) ──
	# spread_factor is the per-direction surface-ramp width control. Sourced from
	# DIRECTION_PRESETS (Cross-AI Cycle 1 C2 fix): Pulse=1.3 wide, Slate=0.7 narrow,
	# Bubble=1.0 medium, Daybreak=1.0 medium, Burst=1.3 wide; custom themes default to 1.0.
	var spread_factor: float = presets.spread_factor
	var elevate_target: Color = Color.BLACK if is_light else Color.WHITE

	var surface_base: Color    = base_color
	var surface_low: Color     = _mix(base_color, Color.BLACK, 0.18 * spread_factor)
	var surface_panel: Color   = _mix(base_color, elevate_target, 0.06 * spread_factor)
	var surface_high: Color    = _mix(base_color, elevate_target, 0.13 * spread_factor)
	var surface_overlay: Color = _mix(base_color, elevate_target, 0.20 * spread_factor)
	var outline_color: Color   = _mix(base_color, elevate_target, 0.24 * spread_factor)

	# ── Per-color tinted offsets for raised mode (DESIGN_TOKENS §6.3) ──
	var accent_offset: Color          = _tint_toward_base(accent_color, base_color)
	var surface_high_offset: Color    = _tint_toward_base(surface_high, base_color)
	var surface_panel_offset: Color   = _tint_toward_base(surface_panel, base_color)
	var surface_overlay_offset: Color = _tint_toward_base(surface_overlay, base_color)
	var surface_low_offset: Color     = _tint_toward_base(surface_low, base_color)

	# ── Text colors with is_light flip (DESIGN_TOKENS §6.4) ──
	var text_strong: Color
	var text_default: Color
	var text_muted: Color
	if is_light:
		text_strong  = Color("#1B2230")
		text_default = Color("#1B2230")
		text_muted   = Color("#5A6478")
	else:
		text_strong  = Color("#F7F8FB")
		text_default = Color("#F7F8FB")
		text_muted   = Color("#B9C1D0")

	# ── State-layer overlays (DESIGN_TOKENS §6.5) ──
	# Per-direction hover_pct / pressed_pct / disabled_opacity sourced from
	# DIRECTION_PRESETS (Cross-AI Cycle 1 C2 fix). pressed_pct stored as negative in the
	# preset (per DESIGN_TOKENS §6.5 convention: hover lifts toward elevate_target,
	# pressed sinks toward BLACK); the `abs()` extracts the magnitude.
	var hover_pct: float = presets.hover_pct
	var pressed_pct: float = abs(presets.pressed_pct)
	var disabled_opacity: float = presets.disabled_opacity
	var state_hover_target: Color = Color.BLACK if is_light else Color.WHITE
	var state_hover: Color = _mix(base_color, state_hover_target, hover_pct / 100.0)
	var state_pressed: Color = _mix(base_color, Color.BLACK, pressed_pct / 100.0)

	# ── Role tokens (DESIGN_TOKENS §7.1) ──
	var role_primary: Color = accent_color
	var accent_rim: Color = _mix(accent_color, Color.WHITE, 0.5)

	# ── BINDING_TABLE walk lands here (Plan 04-05). ──
	# The locals above are the precomputed inputs every entry-population path consumes.
	# Iteration is additive only; no Theme reset is permitted in this method (D-01 invariant).

	# ── Theme defaults (Cross-AI Cycle 1 C3 fix + Cycle 6 F6 fix; BL-01 fix 2026-05-06) ──
	# Set the theme-level default_font + default_font_size BEFORE the BINDING_TABLE walk
	# so any Control type without an explicit per-type font entry still renders in Inter.
	# BL-01 fix: load Inter-Variable.ttf directly (Godot 4 imports .ttf as FontFile via
	# the .import sidecar). Previously preloaded Inter-Variable.tres which round-tripped
	# the binary as PackedByteArray, doubling the bundle size.
	# FontVariation and FontFile both extend Font but are NOT cast-compatible — Plan 04-08
	# README's `theme.default_font as FontFile` only works if default_font IS a FontFile.
	# Per FONT-06: "Theme default_font is Inter Variable Roman; default_font.fallbacks = []"
	# — implies FontFile. Inter-Body.tres (FontVariation wght=400) is used below for
	# explicit set_font calls on body-weight Controls/variations.
	var inter_file := preload("res://addons/neocade_theme/fonts/Inter-Variable.ttf") as FontFile
	default_font = inter_file
	default_font_size = tokens.body
	var body_font := preload("res://addons/neocade_theme/fonts/Inter-Body.tres") as FontVariation

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
	# BL-02 fix 2026-05-06: InfoText is a RichTextLabel variation; RTL reads `normal_font`,
	# not `font` — the `font` slot was silently ignored, falling back to default_font.
	set_font("normal_font", "InfoText", body_font)
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

	# ── Build role lookup table from derivation locals (Plan 04-04) ──
	var role_table: Dictionary = {
		"surface_base":           surface_base,
		"surface_low":            surface_low,
		"surface_panel":          surface_panel,
		"surface_high":           surface_high,
		"surface_overlay":        surface_overlay,
		"outline_color":          outline_color,
		"accent_offset":          accent_offset,
		"surface_high_offset":    surface_high_offset,
		"surface_panel_offset":   surface_panel_offset,
		"surface_overlay_offset": surface_overlay_offset,
		"surface_low_offset":     surface_low_offset,
		"text_strong":            text_strong,
		"text_default":           text_default,
		"text_muted":             text_muted,
		"state_hover":            state_hover,
		"state_pressed":          state_pressed,
		"role_primary":           role_primary,
		"accent_rim":             accent_rim,
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

	_last_regeneration_usec = Time.get_ticks_usec() - t0
	_regenerating = false


# ─── Color helpers (DESIGN_TOKENS §6.1) ─────────────────────────────────────────────────────

## Linear RGB lerp matching the renderer's `lerp(a, b, t)` in `neocade-mockups.js`.
func _mix(a: Color, b: Color, amount: float) -> Color:
	return Color(
		a.r + (b.r - a.r) * amount,
		a.g + (b.g - a.g) * amount,
		a.b + (b.b - a.b) * amount,
		1.0
	)

## Element shifted partway toward `base_c` — preserves hue at every brightness, replacing the
## HSL-darken-floored-at-0 antipattern. Default ratio 0.40 per MOCKUP-REVISION-3-HANDOFF.md.
func _tint_toward_base(element: Color, base_c: Color, ratio: float = 0.40) -> Color:
	return _mix(element, base_c, ratio)


# ─── Platform helpers (DESIGN_TOKENS §10.1, §10.2) ──────────────────────────────────────────

## Resolve `Platform.AUTO` to MOBILE or DESKTOP via Godot's feature flags.
## DESKTOP / MOBILE are forced and bypass detection.
func _resolve_platform() -> Platform:
	if platform == Platform.AUTO:
		return Platform.MOBILE if OS.has_feature("mobile") else Platform.DESKTOP
	return platform

## Returns the 14-key platform-tokens table for the given resolved Platform per DESIGN_TOKENS §10.1.
## The return is a Dictionary so Plan 04-05's BINDING_TABLE walk can read tokens by string key.
func _platform_tokens(p: Platform) -> Dictionary:
	if p == Platform.MOBILE:
		return {
			"buttonMin": 48,
			"primaryButtonMin": 56,
			"inputMin": 56,
			"toggleMin": 32,
			"checkboxSize": 20,
			"body": 16,
			"label_": 14,
			"h1": 32,
			"h2": 22,
			"kicker": 13,
			"rowMin": 56,
			"tabMin": 48,
			"tapPadding": 12,
			"densityScale": 1.5,
		}
	return {  # DESKTOP (or AUTO that resolved to DESKTOP)
		"buttonMin": 36,
		"primaryButtonMin": 44,
		"inputMin": 34,
		"toggleMin": 22,
		"checkboxSize": 18,
		"body": 14,
		"label_": 12,
		"h1": 36,
		"h2": 22,
		"kicker": 12,
		"rowMin": 36,
		"tabMin": 32,
		"tapPadding": 8,
		"densityScale": 1.0,
	}


# ─── Raised stylebox helper (DESIGN_TOKENS §9) ──────────────────────────────────────────────

## Construct a StyleBoxFlat configured for flat or raised mode based on `raised` + `intensity`.
##
## - `raised = false`: shadow_size = -1 (Godot's "no shadow" sentinel per #98162); shadow_offset = ZERO.
## - `raised = true`: shadow_color = offset_color, shadow_size = intensity, shadow_offset = (0, intensity).
##   Hard offset, no blur — the extruded-flat 3D primitive (per FLAT-3D-UI-RESEARCH.md).
##
## Caller is responsible for setting bg_color + corner_radius_* + border_width_* + content_margin_*
## per the Control's slot semantics.
func _make_raised_stylebox(bg: Color, offset_color: Color, intensity: int) -> StyleBoxFlat:
	var sb := StyleBoxFlat.new()
	sb.bg_color = bg
	if raised:
		sb.shadow_color = offset_color
		sb.shadow_size = intensity
		sb.shadow_offset = Vector2(0, intensity)
	else:
		sb.shadow_size = -1
		sb.shadow_offset = Vector2.ZERO
	return sb


# ─── Direction presets (DESIGN_TOKENS §5/§6, directions.json axis_8/axis_9) ─────────────────
## Per-direction non-exported parameters that don't belong on the public 9-export surface but
## must differentiate Pulse (wide spread) from Slate (narrow spread) etc. Sourced from
## directions.json axis_8_surface_spread + axis_9_disabled_opacity + DESIGN_TOKENS §6.5
## state-layer pcts. Cross-AI Cycle 1 C2 fix.
##
## Lookup is by base_color hex (uppercased, no alpha — matches `Color.to_html(false)`).
## Fallback default is medium-spread / M3-baseline if no match.
const DIRECTION_PRESETS: Dictionary = {
	# Per-direction values reconciled to DESIGN_TOKENS §5.1-§5.5 verbatim (Cycle 6 F1 fix 2026-05-06).
	# Pulse — base=#151A2E, accent=#8BFF6A, spread=wide, hover=+6, pressed=-10, disabled=0.42 (DESIGN_TOKENS §5.1)
	"151A2E": {"spread_factor": 1.3, "hover_pct": 6.0, "pressed_pct": -10.0, "disabled_opacity": 0.42},
	# Slate — base=#111820, accent=#8BD3FF, spread=narrow, hover=+4 (subdued), pressed=-6, disabled=0.50 (DESIGN_TOKENS §5.2)
	"111820": {"spread_factor": 0.7, "hover_pct": 4.0, "pressed_pct": -6.0,  "disabled_opacity": 0.50},
	# Bubble — base=#241326, accent=#FFB3E6, spread=medium, hover=+8, pressed=-10, disabled=0.45 (DESIGN_TOKENS §5.3)
	"241326": {"spread_factor": 1.0, "hover_pct": 8.0, "pressed_pct": -10.0, "disabled_opacity": 0.45},
	# Daybreak — base=#0B2420, accent=#76F2D1, spread=medium, hover=+6, pressed=-6, disabled=0.50 (DESIGN_TOKENS §5.4)
	"0B2420": {"spread_factor": 1.0, "hover_pct": 6.0, "pressed_pct": -6.0,  "disabled_opacity": 0.50},
	# Burst — base=#20112E, accent=#FFD166, spread=wide, hover=+8, pressed=-12, disabled=0.45 (DESIGN_TOKENS §5.5)
	"20112E": {"spread_factor": 1.3, "hover_pct": 8.0, "pressed_pct": -12.0, "disabled_opacity": 0.45},
}

## Default (when base_color doesn't match any of the 5 approved directions — custom themes).
const DIRECTION_PRESET_DEFAULT: Dictionary = {
	"spread_factor": 1.0, "hover_pct": 8.0, "pressed_pct": -12.0, "disabled_opacity": 0.38,
}

## Returns the per-direction sub-dict for `base_color`. Lookup is by uppercased hex without alpha.
func _resolve_direction_presets() -> Dictionary:
	var key := base_color.to_html(false).to_upper()
	return DIRECTION_PRESETS.get(key, DIRECTION_PRESET_DEFAULT)


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


# ─── Canonical slot-name freeze (Cross-AI Cycle 2 C1 fix; Cycle 6 F4/F7 reconciled 2026-05-06) ──
## Per-Control slot-name enumeration sourced VERBATIM from MINIMAL-THEME-DISSECTION.md +
## helpers/BINDING_TABLE_SEED.txt (empirical Godot 4.6 ground-truth where they disagreed —
## Cycle 6 F7 fix: dissection had `on`/`off` for CheckButton; Godot 4.6 uses `checked`/`unchecked`).
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
	# CheckButton — 2 icon slots: `checked`/`unchecked` per Godot 4.6 class_checkbutton.md
	# (Cycle 6 F4 fix 2026-05-06: was "on"/"off"; CheckButton has NO `on`/`off` slots —
	# icon slots are checked, checked_disabled, checked_disabled_mirrored, checked_mirrored,
	# unchecked, unchecked_disabled, unchecked_disabled_mirrored, unchecked_mirrored).
	# Phase 4 ships only the 2 primary slots; the 6 disabled/mirrored variants are
	# deferred to v1.x per CHANGELOG (Plan 04-08).
	"CheckButton": {
		"icon": ["checked", "unchecked"],
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


# ─── BINDING_TABLE (Plan 04-05; 37 canonical scorecard Controls) ────────────────────────────
## CANONICAL 37-ROW FREEZE (Cross-AI Cycle 1 C1 fix; sourced verbatim from
## MINIMAL-THEME-COVERAGE-DELTA.md §Coverage Scorecard). NO executor discretion to add/drop.
##
## Structure: theme_type → data_type ("stylebox"/"color"/"constant"/"font_size"/"icon")
##   → slot_name → recipe Dictionary. Recipes:
##     {"role": "<role>"}              — pulls a derived color from role_table.
##     {"role": "...", "raised_intensity": int} — for stylebox; multiplier for raised lift.
##     {"role": "...", "disabled": true}        — pulls per-direction alpha from presets.disabled_opacity (Cycle 2 C2).
##     {"role": "focus_ring"}                   — special: transparent bg + accent border + expand.
##     {"value": "tokens.<key>"}                — for constant/font_size.
##     {"icon": "<filename>"}                   — for icons (file under addons/neocade_theme/icons/).
##
## D-01 invariant: iteration is ADDITIVE only (set_stylebox/set_color/set_constant/set_font_size/set_icon).
## D-04 escape hatch: entries not in BINDING_TABLE are left untouched.
## REVISABLE per CONTEXT.md D-03: this binding mechanism may evolve toward a metadata-tagged
## Resource model post-Phase-4. The public @export surface + .tres format are stable; only
## the internal binding mechanism would change.
const BINDING_TABLE: Dictionary = {
	# 1. AcceptDialog — minimal panel + button container constants (Phase 4 baseline)
	"AcceptDialog": {
		"stylebox": {
			"panel": {"role": "surface_panel", "raised_intensity": 1},
		},
		"constant": {
			"buttons_separation": {"value": "tokens.tapPadding"},
			"margin_top":    {"value": "tokens.tapPadding"},
			"margin_bottom": {"value": "tokens.tapPadding"},
			"margin_left":   {"value": "tokens.tapPadding"},
			"margin_right":  {"value": "tokens.tapPadding"},
		},
	},
	# 2. Button — 6 styleboxes + font colors + h_separation (PITFALLS 10.3 clean states)
	"Button": {
		"stylebox": {
			"normal":         {"role": "surface_panel", "raised_intensity": 1},  # Cycle 1 MEDIUM reconcile: was 0; lifts when raised=true
			"hover":          {"role": "state_hover",   "raised_intensity": 1},
			"pressed":        {"role": "state_pressed", "raised_intensity": 0},  # pressed sinks; never lifted
			"focus":          {"role": "focus_ring"},
			"disabled":       {"role": "surface_panel", "disabled": true, "raised_intensity": 0},  # Cycle 2 C2: per-direction alpha
			"hover_pressed":  {"role": "state_pressed", "raised_intensity": 0},
		},
		"color": {
			"font_color":              {"role": "text_strong"},
			"font_hover_color":        {"role": "text_strong"},
			"font_pressed_color":      {"role": "text_strong"},
			"font_focus_color":        {"role": "text_strong"},
			"font_disabled_color":     {"role": "text_strong", "disabled": true},  # Cycle 2 C2 fix
			"font_hover_pressed_color":{"role": "text_strong"},
			"icon_normal_color":       {"role": "text_strong"},
			"icon_hover_color":        {"role": "text_strong"},
			"icon_pressed_color":      {"role": "text_strong"},
			"icon_focus_color":        {"role": "text_strong"},
			"icon_disabled_color":     {"role": "text_strong", "disabled": true},  # Cycle 2 C2 fix
			"icon_hover_pressed_color":{"role": "text_strong"},
		},
		"constant": {
			"h_separation": {"value": "tokens.tapPadding"},
		},
	},
	# 3. CheckBox — 4 icon slots (CheckBox alternates as RadioButton in Godot)
	"CheckBox": {
		"stylebox": {
			"normal":         {"role": "surface_panel", "raised_intensity": 0},
			"hover":          {"role": "state_hover",   "raised_intensity": 0},
			"pressed":        {"role": "state_pressed", "raised_intensity": 0},
			"focus":          {"role": "focus_ring"},
			"disabled":       {"role": "surface_panel", "disabled": true},
			"hover_pressed":  {"role": "state_pressed", "raised_intensity": 0},
		},
		"color": {
			"font_color":              {"role": "text_strong"},
			"font_hover_color":        {"role": "text_strong"},
			"font_pressed_color":      {"role": "text_strong"},
			"font_focus_color":        {"role": "text_strong"},
			"font_disabled_color":     {"role": "text_strong", "disabled": true},
			"font_hover_pressed_color":{"role": "text_strong"},
		},
		"constant": {
			"h_separation": {"value": "tokens.tapPadding"},
			"check_v_offset": {"value": 0},
		},
		"icon": {
			"checked":         {"icon": "checkbox_checked"},
			"unchecked":       {"icon": "checkbox_unchecked"},
			"radio_checked":   {"icon": "radio_checked"},
			"radio_unchecked": {"icon": "radio_unchecked"},
		},
	},
	# 4. CheckButton — 2 icon slots (Cycle 6 F4 fix: `checked`/`unchecked`, not `on`/`off`)
	"CheckButton": {
		"stylebox": {
			"normal":         {"role": "surface_panel", "raised_intensity": 0},
			"hover":          {"role": "state_hover",   "raised_intensity": 0},
			"pressed":        {"role": "state_pressed", "raised_intensity": 0},
			"focus":          {"role": "focus_ring"},
			"disabled":       {"role": "surface_panel", "disabled": true},
			"hover_pressed":  {"role": "state_pressed", "raised_intensity": 0},
		},
		"color": {
			"font_color":              {"role": "text_strong"},
			"font_hover_color":        {"role": "text_strong"},
			"font_pressed_color":      {"role": "text_strong"},
			"font_focus_color":        {"role": "text_strong"},
			"font_disabled_color":     {"role": "text_strong", "disabled": true},
			"font_hover_pressed_color":{"role": "text_strong"},
		},
		"icon": {
			"checked":   {"icon": "checkbutton_checked"},
			"unchecked": {"icon": "checkbutton_unchecked"},
		},
	},
	# 5. CodeEdit — inherits TextEdit; Phase 4 ships base stylebox set (no syntax highlighting per AF-7)
	"CodeEdit": {
		"stylebox": {
			"normal":    {"role": "surface_low",   "raised_intensity": 0},
			"focus":     {"role": "focus_ring"},
			"read_only": {"role": "surface_low",   "disabled": true},
		},
		"color": {
			"font_color":            {"role": "text_default"},
			"font_placeholder_color":{"role": "text_muted"},
			"caret_color":           {"role": "role_primary"},
			"selection_color":       {"role": "accent_offset"},
			"current_line_color":    {"role": "surface_panel"},
			"line_number_color":     {"role": "text_muted"},
		},
	},
	# 6. ColorPicker — minimal Phase 4 baseline (full coverage Phase 7)
	"ColorPicker": {
		"constant": {
			"margin": {"value": "tokens.tapPadding"},
		},
	},
	# 7. ColorPickerButton — inherits Button family; minimal Phase 4 baseline
	"ColorPickerButton": {
		"stylebox": {
			"normal":   {"role": "surface_panel", "raised_intensity": 1},
			"hover":    {"role": "state_hover",   "raised_intensity": 1},
			"pressed":  {"role": "state_pressed", "raised_intensity": 0},
			"focus":    {"role": "focus_ring"},
			"disabled": {"role": "surface_panel", "disabled": true},
		},
		"color": {
			"font_color":          {"role": "text_strong"},
			"font_disabled_color": {"role": "text_strong", "disabled": true},
		},
	},
	# 8. ConfirmationDialog — same as AcceptDialog
	"ConfirmationDialog": {
		"stylebox": {
			"panel": {"role": "surface_panel", "raised_intensity": 1},
		},
		"constant": {
			"buttons_separation": {"value": "tokens.tapPadding"},
		},
	},
	# 9. FileDialog — minimal Phase 4 baseline (file/folder icons defer to Phase 7)
	"FileDialog": {
		"stylebox": {
			"panel": {"role": "surface_panel", "raised_intensity": 1},
		},
		"color": {
			"file_disabled_color": {"role": "text_muted",  "disabled": true},
			"file_icon_color":     {"role": "text_default"},
			"folder_icon_color":   {"role": "role_primary"},
			"icon_normal_color":   {"role": "text_default"},
		},
	},
	# 10. FoldableContainer — minimal Phase 4 baseline (Phase 6 polish completes)
	"FoldableContainer": {
		"stylebox": {
			"panel":           {"role": "surface_panel", "raised_intensity": 0},
			"title_panel":     {"role": "surface_high",  "raised_intensity": 0},
			"title_hover":     {"role": "state_hover",   "raised_intensity": 0},
			"title_collapsed": {"role": "surface_panel", "raised_intensity": 0},
			"focus":           {"role": "focus_ring"},
		},
		"color": {
			"font_color":       {"role": "text_default"},
			"title_font_color": {"role": "text_strong"},
		},
	},
	# 11. GraphEdit — minimal Phase 4 baseline (Phase 7 graph polish)
	"GraphEdit": {
		"stylebox": {
			"panel":      {"role": "surface_low",   "raised_intensity": 0},
			"menu_panel": {"role": "surface_panel", "raised_intensity": 0},
		},
		"color": {
			"grid_major":       {"role": "outline_color"},
			"grid_minor":       {"role": "outline_color"},
			"selection_fill":   {"role": "accent_offset"},
			"selection_stroke": {"role": "role_primary"},
		},
	},
	# 12. HScrollBar — 5 stylebox slots
	"HScrollBar": {
		"stylebox": {
			"scroll":            {"role": "surface_low",   "raised_intensity": 0},
			"scroll_focus":      {"role": "focus_ring"},
			"grabber":           {"role": "surface_high",  "raised_intensity": 0},
			"grabber_highlight": {"role": "state_hover",   "raised_intensity": 0},
			"grabber_pressed":   {"role": "state_pressed", "raised_intensity": 0},
		},
	},
	# 13. HSlider — slider track + grabber_area + highlight
	"HSlider": {
		"stylebox": {
			"slider":                  {"role": "surface_low",   "raised_intensity": 0},
			"grabber_area":            {"role": "role_primary",  "raised_intensity": 0},
			"grabber_area_highlight":  {"role": "accent_offset", "raised_intensity": 0},
		},
	},
	# 14. HSplitContainer — separation only (chrome is grabber icon)
	"HSplitContainer": {
		"constant": {
			"separation":             {"value": "tokens.tapPadding"},
			"minimum_grab_thickness": {"value": 6},
		},
	},
	# 15. ItemList — 9 stylebox slots + colors + constants
	"ItemList": {
		"stylebox": {
			"panel":                  {"role": "surface_low",   "raised_intensity": 0},
			"focus":                  {"role": "focus_ring"},
			"cursor":                 {"role": "state_hover",   "raised_intensity": 0},
			"cursor_unfocused":       {"role": "state_hover",   "raised_intensity": 0},
			"hovered":                {"role": "state_hover",   "raised_intensity": 0},
			"selected":               {"role": "accent_offset", "raised_intensity": 0},
			"selected_focus":         {"role": "accent_offset", "raised_intensity": 0},
			"hovered_selected":       {"role": "accent_offset", "raised_intensity": 0},
			"hovered_selected_focus": {"role": "accent_offset", "raised_intensity": 0},
		},
		"color": {
			"font_color":               {"role": "text_default"},
			"font_hovered_color":       {"role": "text_strong"},
			"font_selected_color":      {"role": "text_strong"},
			"font_hovered_selected_color": {"role": "text_strong"},
			"guide_color":              {"role": "outline_color"},
		},
		"constant": {
			"v_separation":  {"value": "tokens.tapPadding"},
			"h_separation":  {"value": "tokens.tapPadding"},
			"line_separation": {"value": 2},
		},
	},
	# 16. Label — 1 stylebox + 1 color
	"Label": {
		"stylebox": {
			"normal": {"role": "surface_base", "raised_intensity": 0},
		},
		"color": {
			"font_color": {"role": "text_strong"},
		},
	},
	# 17. LineEdit — 3 stylebox + caret + selection + clear icon
	"LineEdit": {
		"stylebox": {
			"normal":    {"role": "surface_low",   "raised_intensity": 0},
			"focus":     {"role": "focus_ring"},
			"read_only": {"role": "surface_low",   "disabled": true},
		},
		"color": {
			"font_color":            {"role": "text_default"},
			"font_placeholder_color":{"role": "text_muted"},
			"font_uneditable_color": {"role": "text_muted",  "disabled": true},
			"font_selected_color":   {"role": "text_strong"},
			"caret_color":           {"role": "role_primary"},
			"selection_color":       {"role": "accent_offset"},
			"clear_button_color":    {"role": "text_muted"},
			"clear_button_color_pressed": {"role": "text_strong"},
		},
		"icon": {
			"clear": {"icon": "clear"},
		},
	},
	# 18. LinkButton — colors only; no styleboxes (TextButton variant)
	"LinkButton": {
		"color": {
			"font_color":              {"role": "role_primary"},
			"font_hover_color":        {"role": "accent_rim"},
			"font_pressed_color":      {"role": "role_primary"},
			"font_focus_color":        {"role": "role_primary"},
			"font_disabled_color":     {"role": "role_primary", "disabled": true},
			"font_hover_pressed_color":{"role": "accent_rim"},
		},
		"constant": {
			"underline_spacing": {"value": 2},
		},
	},
	# 19. MenuBar — minimal Button-family inheritance + h_separation
	"MenuBar": {
		"stylebox": {
			"normal":   {"role": "surface_base", "raised_intensity": 0},
			"hover":    {"role": "state_hover",  "raised_intensity": 0},
			"pressed":  {"role": "state_pressed","raised_intensity": 0},
			"disabled": {"role": "surface_base", "disabled": true},
		},
		"color": {
			"font_color":          {"role": "text_strong"},
			"font_hover_color":    {"role": "text_strong"},
			"font_pressed_color":  {"role": "text_strong"},
			"font_disabled_color": {"role": "text_strong", "disabled": true},
		},
		"constant": {
			"h_separation": {"value": "tokens.tapPadding"},
		},
	},
	# 20. MenuButton — Button-family states
	"MenuButton": {
		"stylebox": {
			"normal":         {"role": "surface_panel", "raised_intensity": 1},
			"hover":          {"role": "state_hover",   "raised_intensity": 1},
			"pressed":        {"role": "state_pressed", "raised_intensity": 0},
			"focus":          {"role": "focus_ring"},
			"disabled":       {"role": "surface_panel", "disabled": true},
			"hover_pressed":  {"role": "state_pressed", "raised_intensity": 0},
		},
		"color": {
			"font_color":          {"role": "text_strong"},
			"font_hover_color":    {"role": "text_strong"},
			"font_pressed_color":  {"role": "text_strong"},
			"font_focus_color":    {"role": "text_strong"},
			"font_disabled_color": {"role": "text_strong", "disabled": true},
		},
		"constant": {
			"h_separation": {"value": "tokens.tapPadding"},
		},
	},
	# 21. OptionButton — 6 stylebox + arrow icon + arrow_margin constant
	"OptionButton": {
		"stylebox": {
			"normal":         {"role": "surface_panel", "raised_intensity": 1},
			"hover":          {"role": "state_hover",   "raised_intensity": 1},
			"pressed":        {"role": "state_pressed", "raised_intensity": 0},
			"focus":          {"role": "focus_ring"},
			"disabled":       {"role": "surface_panel", "disabled": true},
			"hover_pressed":  {"role": "state_pressed", "raised_intensity": 0},
		},
		"color": {
			"font_color":          {"role": "text_strong"},
			"font_hover_color":    {"role": "text_strong"},
			"font_pressed_color":  {"role": "text_strong"},
			"font_focus_color":    {"role": "text_strong"},
			"font_disabled_color": {"role": "text_strong", "disabled": true},
		},
		"constant": {
			"arrow_margin":  {"value": "tokens.tapPadding"},
			"h_separation": {"value": "tokens.tapPadding"},
		},
		"icon": {
			"arrow": {"icon": "arrow_down"},
		},
	},
	# 22. Panel — 1 stylebox (the bare-class)
	"Panel": {
		"stylebox": {
			"panel": {"role": "surface_panel", "raised_intensity": 0},
		},
	},
	# 23. PopupMenu — 5 styleboxes + 3 constants + checked/unchecked/submenu icons
	"PopupMenu": {
		"stylebox": {
			"panel":                 {"role": "surface_high",  "raised_intensity": 1},
			"hover":                 {"role": "state_hover",   "raised_intensity": 0},
			"separator":             {"role": "outline_color", "raised_intensity": 0},
			"labeled_separator_left":{"role": "outline_color", "raised_intensity": 0},
			"labeled_separator_right":{"role": "outline_color", "raised_intensity": 0},
		},
		"color": {
			"font_color":           {"role": "text_default"},
			"font_hover_color":     {"role": "text_strong"},
			"font_disabled_color":  {"role": "text_default", "disabled": true},
			"font_separator_color": {"role": "text_muted"},
			"font_accelerator_color":{"role": "text_muted"},
		},
		"constant": {
			"v_separation":     {"value": "tokens.tapPadding"},
			"h_separation":     {"value": "tokens.tapPadding"},
			"item_start_padding":{"value": "tokens.tapPadding"},
		},
		"icon": {
			"checked":         {"icon": "checkbox_checked"},
			"unchecked":       {"icon": "checkbox_unchecked"},
			"radio_checked":   {"icon": "radio_checked"},
			"radio_unchecked": {"icon": "radio_unchecked"},
		},
	},
	# 24. PopupPanel — 1 stylebox (PITFALLS 1.7 first-class)
	"PopupPanel": {
		"stylebox": {
			"panel": {"role": "surface_high", "raised_intensity": 1},
		},
	},
	# 25. ProgressBar — 2 styleboxes
	"ProgressBar": {
		"stylebox": {
			"background": {"role": "surface_low",  "raised_intensity": 0},
			"fill":       {"role": "role_primary", "raised_intensity": 0},
		},
		"color": {
			"font_color": {"role": "text_strong"},
		},
	},
	# 26. RichTextLabel — 1 stylebox + colors
	"RichTextLabel": {
		"stylebox": {
			"normal": {"role": "surface_base", "raised_intensity": 0},
			"focus":  {"role": "focus_ring"},
		},
		"color": {
			"default_color":    {"role": "text_default"},
			"selection_color":  {"role": "accent_offset"},
			"font_selected_color": {"role": "text_strong"},
		},
	},
	# 27. SpinBox — inherits LineEdit; Phase 4 ships button separation constants
	"SpinBox": {
		"constant": {
			"buttons_vertical_separation": {"value": 2},
			"buttons_width":                {"value": 16},
			"field_and_buttons_separation":{"value": 4},
		},
	},
	# 28. TabBar — 5 stylebox + tab font/icon colors
	"TabBar": {
		"stylebox": {
			"tab_selected":   {"role": "surface_high",  "raised_intensity": 1},
			"tab_unselected": {"role": "surface_low",   "raised_intensity": 0},
			"tab_hovered":    {"role": "state_hover",   "raised_intensity": 0},
			"tab_disabled":   {"role": "surface_low",   "disabled": true},
			"tab_focus":      {"role": "focus_ring"},
		},
		"color": {
			"font_selected_color":   {"role": "text_strong"},
			"font_unselected_color": {"role": "text_muted"},
			"font_hovered_color":    {"role": "text_strong"},
			"font_disabled_color":   {"role": "text_muted", "disabled": true},
			"icon_selected_color":   {"role": "text_strong"},
			"icon_unselected_color": {"role": "text_muted"},
			"icon_hovered_color":    {"role": "text_strong"},
			"icon_disabled_color":   {"role": "text_muted", "disabled": true},
			"drop_mark_color":       {"role": "role_primary"},
		},
		"constant": {
			"h_separation": {"value": "tokens.tapPadding"},
		},
	},
	# 29. TabContainer — TabBar set + panel + tabbar_background
	"TabContainer": {
		"stylebox": {
			"tab_selected":     {"role": "surface_high",  "raised_intensity": 1},
			"tab_unselected":   {"role": "surface_low",   "raised_intensity": 0},
			"tab_hovered":      {"role": "state_hover",   "raised_intensity": 0},
			"tab_disabled":     {"role": "surface_low",   "disabled": true},
			"tab_focus":        {"role": "focus_ring"},
			"panel":            {"role": "surface_panel", "raised_intensity": 0},
			"tabbar_background":{"role": "surface_base",  "raised_intensity": 0},
		},
		"color": {
			"font_selected_color":   {"role": "text_strong"},
			"font_unselected_color": {"role": "text_muted"},
			"font_hovered_color":    {"role": "text_strong"},
			"font_disabled_color":   {"role": "text_muted", "disabled": true},
			"drop_mark_color":       {"role": "role_primary"},
		},
	},
	# 30. TextEdit — 3 stylebox set
	"TextEdit": {
		"stylebox": {
			"normal":    {"role": "surface_low",   "raised_intensity": 0},
			"focus":     {"role": "focus_ring"},
			"read_only": {"role": "surface_low",   "disabled": true},
		},
		"color": {
			"font_color":            {"role": "text_default"},
			"font_placeholder_color":{"role": "text_muted"},
			"font_readonly_color":   {"role": "text_muted",  "disabled": true},
			"font_selected_color":   {"role": "text_strong"},
			"caret_color":           {"role": "role_primary"},
			"selection_color":       {"role": "accent_offset"},
			"current_line_color":    {"role": "surface_panel"},
		},
	},
	# 31. TooltipLabel — colors only (NeoCade-additive)
	"TooltipLabel": {
		"color": {
			"font_color": {"role": "text_strong"},
		},
	},
	# 32. TooltipPanel — 1 stylebox (PITFALLS 1.7 first-class)
	"TooltipPanel": {
		"stylebox": {
			"panel": {"role": "surface_overlay", "raised_intensity": 1},
		},
	},
	# 33. Tree — 16 styleboxes per CANONICAL_SLOT_NAMES (PITFALLS 1.7 first-class)
	"Tree": {
		"stylebox": {
			"panel":                  {"role": "surface_low",   "raised_intensity": 0},
			"focus":                  {"role": "focus_ring"},
			"title_button_normal":    {"role": "surface_panel", "raised_intensity": 0},
			"title_button_pressed":   {"role": "state_pressed", "raised_intensity": 0},
			"title_button_hover":     {"role": "state_hover",   "raised_intensity": 0},
			"button_hover":           {"role": "state_hover",   "raised_intensity": 0},
			"button_pressed":         {"role": "state_pressed", "raised_intensity": 0},
			"hover":                  {"role": "state_hover",   "raised_intensity": 0},
			"selected":               {"role": "accent_offset", "raised_intensity": 0},
			"selected_focus":         {"role": "accent_offset", "raised_intensity": 0},
			"hovered_selected":       {"role": "accent_offset", "raised_intensity": 0},
			"hovered_selected_focus": {"role": "accent_offset", "raised_intensity": 0},
			"custom_button_hover":    {"role": "state_hover",   "raised_intensity": 0},
			"custom_button_pressed":  {"role": "state_pressed", "raised_intensity": 0},
			"cursor":                 {"role": "state_hover",   "raised_intensity": 0},
			"cursor_unfocused":       {"role": "state_hover",   "raised_intensity": 0},
		},
		"color": {
			"font_color":           {"role": "text_default"},
			"font_selected_color":  {"role": "text_strong"},
			"guide_color":          {"role": "outline_color"},
			"drop_position_color":  {"role": "role_primary"},
			"parent_hl_line_color":{"role": "outline_color"},
			"relationship_line_color":{"role": "outline_color"},
		},
		"constant": {
			"v_separation":            {"value": "tokens.tapPadding"},
			"inner_item_margin_left":  {"value": "tokens.tapPadding"},
			"inner_item_margin_right": {"value": "tokens.tapPadding"},
			"inner_item_margin_top":   {"value": 0},
			"inner_item_margin_bottom":{"value": 0},
			"item_margin":             {"value": 4},
		},
	},
	# 34. VScrollBar — mirror of HScrollBar
	"VScrollBar": {
		"stylebox": {
			"scroll":            {"role": "surface_low",   "raised_intensity": 0},
			"scroll_focus":      {"role": "focus_ring"},
			"grabber":           {"role": "surface_high",  "raised_intensity": 0},
			"grabber_highlight": {"role": "state_hover",   "raised_intensity": 0},
			"grabber_pressed":   {"role": "state_pressed", "raised_intensity": 0},
		},
	},
	# 35. VSlider — mirror of HSlider
	"VSlider": {
		"stylebox": {
			"slider":                 {"role": "surface_low",   "raised_intensity": 0},
			"grabber_area":           {"role": "role_primary",  "raised_intensity": 0},
			"grabber_area_highlight": {"role": "accent_offset", "raised_intensity": 0},
		},
	},
	# 36. VSplitContainer — mirror of HSplitContainer
	"VSplitContainer": {
		"constant": {
			"separation":             {"value": "tokens.tapPadding"},
			"minimum_grab_thickness": {"value": 6},
		},
	},
	# 37. Window — 2 stylebox slots (PITFALLS 1.7 first-class)
	"Window": {
		"stylebox": {
			"embedded_border":          {"role": "surface_overlay", "raised_intensity": 1},
			"embedded_unfocused_border":{"role": "surface_overlay", "raised_intensity": 0},
		},
		"color": {
			"title_color": {"role": "text_strong"},
		},
		"constant": {
			"close_h_offset": {"value": 8},
			"title_height":   {"value": 28},
		},
	},
}


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
		# NOT a hard-coded literal. Recipes carrying "disabled": true get presets.disabled_opacity.
		var is_disabled: bool = recipe.get("disabled", false)
		var alpha: float = recipe.get("alpha", 1.0)
		if is_disabled:
			alpha = presets.disabled_opacity
		if role == "focus_ring":
			# Focus ring is a special stylebox: transparent bg, accent border, expand outside corner.
			var focus_sb := StyleBoxFlat.new()
			focus_sb.bg_color = Color(0, 0, 0, 0)
			focus_sb.border_color = role_table.role_primary
			focus_sb.border_width_left = focus_thickness
			focus_sb.border_width_top = focus_thickness
			focus_sb.border_width_right = focus_thickness
			focus_sb.border_width_bottom = focus_thickness
			focus_sb.corner_radius_top_left = corner_radius
			focus_sb.corner_radius_top_right = corner_radius
			focus_sb.corner_radius_bottom_left = corner_radius
			focus_sb.corner_radius_bottom_right = corner_radius
			focus_sb.expand_margin_left = 2
			focus_sb.expand_margin_top = 2
			focus_sb.expand_margin_right = 2
			focus_sb.expand_margin_bottom = 2
			focus_sb.shadow_size = -1
			return focus_sb
		var bg_color: Color = role_table.get(role, role_table.surface_panel)
		if alpha < 1.0:
			bg_color = Color(bg_color.r, bg_color.g, bg_color.b, alpha)
		# Pick the matching offset color (per §6.3) for the bg's family.
		var offset_color: Color = role_table.get(role + "_offset", role_table.surface_panel_offset)
		var sb_intensity: int = (raised_strength * raised_intensity) if raised else 0
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
		var value_ref = recipe.get("value", 0)
		if typeof(value_ref) == TYPE_STRING and (value_ref as String).begins_with("tokens."):
			var key: String = (value_ref as String).substr(7)
			return tokens.get(key, 0)
		return int(value_ref)
	elif data_type == "icon":
		var icon_name: String = recipe.get("icon", "")
		if icon_name == "":
			return null
		var path: String = "res://addons/neocade_theme/icons/" + icon_name + ".svg"
		var icon: Texture2D = load(path) as Texture2D
		return icon
	# Cross-AI Cycle 2 N1 fix: any unrecognized data_type (including the now-removed "font")
	# falls through to null — caller skips silently per D-04 escape hatch.
	return null
