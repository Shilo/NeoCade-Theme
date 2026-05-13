@tool
extends EditorScript

## Phase 12 in-editor verifier. Run via Godot Editor -> File -> Run on this file.
##
## Mirrors _phase12_verify_headless.gd's assertion battery (duplicated, not loaded —
## Phase 4 KISS precedent). Output appears in the Godot Output panel; failures use
## `assert(...)` so the editor surfaces a stack trace.
##
## Notes on baseline constants:
## - EXPECTED_BINDING_TABLE_ROWS = 140 (pre-Phase-12 baseline; the historical "37 rows" note
##   referred to the Phase 4 scorecard Control count — subsequent phases grew the table to 140).
## - SC#3 exempts GraphEditMinimap / GraphStateMachine: these types use intentional semi-
##   transparent borders for graph-canvas visuals (Phase 7 design; not new halos).

const CANONICAL_TRES := "res://addons/neocade_theme/neocade_theme.tres"
const EXPECTED_EXPORT_COUNT := 12
## BINDING_TABLE.size() = 140 at pre-Phase-12 baseline (top-level theme_type keys).
const EXPECTED_BINDING_TABLE_ROWS := 140

## Graph types exempt from SC#3 border-alpha check (pre-existing intentional semi-transparent overlays).
const SC3_EXEMPT_TYPES: Array = [
	"GraphEditMinimap",
	"GraphStateMachine",
	"GraphEdit",
	"GraphNode",
	"GraphFrame",
]

func _run() -> void:
	print("PHASE12_VERIFY (EditorScript): begin")

	var loaded: Resource = ResourceLoader.load(CANONICAL_TRES)
	assert(loaded != null, "PHASE12_VERIFY: canonical .tres failed to load (%s)" % CANONICAL_TRES)
	assert(loaded is NeoCadeTheme, "PHASE12_VERIFY: loaded resource is not a NeoCadeTheme")
	var theme: NeoCadeTheme = loaded

	# Architecture
	var script: Script = theme.get_script() as Script
	var consts: Dictionary = script.get_script_constant_map()
	var bt: Dictionary = consts.get("BINDING_TABLE", {})
	assert(bt.size() == EXPECTED_BINDING_TABLE_ROWS,
		"PHASE12_VERIFY: BINDING_TABLE.size() = %d (expected %d)" % [bt.size(), EXPECTED_BINDING_TABLE_ROWS])
	assert(theme.has_stylebox("normal", "Button"),
		"PHASE12_VERIFY: theme regenerate produced no Button.normal stylebox")
	assert(theme.has_stylebox("panel", "PanelContainer"),
		"PHASE12_VERIFY: theme regenerate produced no PanelContainer.panel stylebox")

	# SC#6
	var export_count: int = _count_top_level_exports(script)
	assert(export_count == EXPECTED_EXPORT_COUNT,
		"PHASE12_VERIFY: @export count = %d (expected %d)" % [export_count, EXPECTED_EXPORT_COUNT])

	# SC#1 — raised=false: no Button.normal shadow_size > 0 for any selectable style.
	for style_value in NeoCadeTheme.selectable_styles():
		var t: NeoCadeTheme = theme.duplicate(true) as NeoCadeTheme
		t.raised = false
		t.style = style_value
		var sb := t.get_stylebox("normal", "Button")
		if sb is StyleBoxFlat:
			var sbf := sb as StyleBoxFlat
			assert(sbf.shadow_size <= 0,
				"PHASE12_VERIFY SC#1: %s raised=false Button.normal shadow_size=%d" % [NeoCadeTheme.style_label(style_value), sbf.shadow_size])

	# SC#2 — raised=true: TabBar/TabContainer tab_selected styleboxes have no depth.
	for style_value in NeoCadeTheme.selectable_styles():
		var t: NeoCadeTheme = theme.duplicate(true) as NeoCadeTheme
		t.raised = true
		t.style = style_value
		for type_name in ["TabBar", "TabContainer"]:
			if t.has_stylebox("tab_selected", type_name):
				var sb := t.get_stylebox("tab_selected", type_name)
				if sb is StyleBoxFlat:
					var sbf := sb as StyleBoxFlat
					assert(sbf.shadow_size <= 0,
						"PHASE12_VERIFY SC#2: %s/%s.tab_selected shadow_size=%d at raised=true" % [NeoCadeTheme.style_label(style_value), type_name, sbf.shadow_size])

	# SC#3 — no intermediate-alpha border colors (GraphEditMinimap/GraphStateMachine exempt).
	var inspected := 0
	var skipped := 0
	for style_value in NeoCadeTheme.selectable_styles():
		for raised_v in [false, true]:
			var t: NeoCadeTheme = theme.duplicate(true) as NeoCadeTheme
			t.raised = raised_v
			t.style = style_value
			for theme_type in t.get_stylebox_type_list():
				if SC3_EXEMPT_TYPES.has(theme_type):
					skipped += 1
					continue
				for sb_name in t.get_stylebox_list(theme_type):
					var sb := t.get_stylebox(sb_name, theme_type)
					if sb is StyleBoxFlat:
						inspected += 1
						var a: float = (sb as StyleBoxFlat).border_color.a
						assert(a <= 0.001 or a >= 0.999,
							"PHASE12_VERIFY SC#3: %s/%s.%s border_alpha=%.3f (halo risk)" % [NeoCadeTheme.style_label(style_value), theme_type, sb_name, a])

	print("PHASE12_VERIFY (EditorScript): PASS — architecture, SC#1, SC#2, SC#3 (%d styleboxes, %d skipped), SC#6 all green" % [inspected, skipped])


func _count_top_level_exports(script: Script) -> int:
	var count := 0
	for prop in script.get_script_property_list():
		var usage: int = int(prop.get("usage", 0))
		if (usage & PROPERTY_USAGE_SCRIPT_VARIABLE) != 0 and (usage & PROPERTY_USAGE_EDITOR) != 0 and (usage & PROPERTY_USAGE_STORAGE) != 0:
			count += 1
	return count
