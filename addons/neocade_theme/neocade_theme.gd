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

	# SKELETON ONLY — Plans 04-04 (formulas) and 04-05 (binding-table walk) populate this body.
	# NO Theme.clear call permitted in this method per D-01 (additive iteration only).

	_last_regeneration_usec = Time.get_ticks_usec() - t0
	_regenerating = false
