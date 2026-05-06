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
