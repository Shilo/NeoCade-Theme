@tool
extends EditorScript

## Phase 5 verifier (EditorScript variant). Run via Godot Editor: File -> Run.
##
## Runs the SAME named assertion groups as the headless variant
## (_phase5_verify_headless.gd), so the editor and CI gates stay in lockstep.
##
## Per D-12 (Phase 5 CONTEXT.md), the named groups are:
##   - assert_variation_count_15
##   - assert_inf_text_normal_font_size
##   - assert_codeedit_gutter_slots
##   - assert_spinbox_icons
##   - assert_shape_lookup_integrity
##   - assert_focus_overlay_visibility
##   - assert_no_theme_clear
##
## Plan 05-02 added shape-stage groups:
##   - assert_shape_value_integrity
##   - assert_shape_recipe_resolution
##   - assert_semantic_role_table
##   - assert_no_invented_focus_combos
##
## Plan 05-03 added buttons-stage groups (TYPEVAR-01 + COV-02 + D-07):
##   - assert_button_variation_rows
##   - assert_button_variation_states
##   - assert_button_variation_fonts
##   - assert_button_strategy_distinctness
##   - assert_dangerbutton_role_danger
##   - assert_basebutton_family_chrome
##
## Per D-07: Phase 5 verifier MUST NOT reference invented `pressed_focus`,
## `checked_focus`, or `hover_pressed_focus` slots. Focus is the official
## `focus` overlay only.
##
## Per D-11 / Phase 4 F3: helpers live outside addons/neocade_theme/.

const PULSE_PATH := "res://addons/neocade_theme/pulse_neocade_theme.tres"
const PRODUCTION_GD := "res://addons/neocade_theme/neocade_theme.gd"

const PHASE5_VARIATION_COUNT := 15
const PHASE5_SPINBOX_ICONS := ["up", "up_disabled", "down", "down_disabled"]
const PHASE5_CODEEDIT_GUTTER_COLORS := [
	"line_number_color",
	"breakpoint_color",
	"code_folding_color",
	"bookmark_color",
	"executing_line_color",
	"line_length_guideline_color",
]
const PHASE5_CODEEDIT_FOLDED_ICON := "folded"
const PHASE5_SHAPE_KEYS := [
	"primary_radius",
	"primary_padding",
	"primary_strategy",
	"ghost_strategy",
	"surface_alpha_panels",
	"surface_alpha_popup",
	"surface_alpha_buttons",
	"raised_lifts",
	"focus_offset",
	"kicker_style",
]
# Plan 05-03 Task 1.
const PHASE5_BUTTON_VARIATIONS := [
	"PrimaryButton",
	"SecondaryButton",
	"GhostButton",
	"DangerButton",
	"IconButton",
	"FlatButton",
]
const PHASE5_BUTTON_VARIATION_STATES := ["normal", "hover", "pressed", "focus", "disabled", "hover_pressed"]
const PHASE5_BASEBUTTON_FAMILY := [
	"Button",
	"CheckBox",
	"CheckButton",
	"OptionButton",
	"MenuButton",
	"ColorPickerButton",
	"LinkButton",
]

# Stage selection in EditorScript context: edit `_stage` below to run strict mode
# from the editor (CI calls the headless variant with --stage strict).
var _stage: String = "tooling"
var _failures: Array[String] = []
var _pending: Array[String] = []
var _ok_markers: Array[String] = []


func _run() -> void:
	print("PHASE5_VERIFY: stage=%s (EditorScript)" % _stage)
	if not _verify_helper_wiring():
		_emit_summary()
		return
	assert_variation_count_15()
	assert_inf_text_normal_font_size()
	assert_codeedit_gutter_slots()
	assert_spinbox_icons()
	assert_shape_lookup_integrity()
	assert_focus_overlay_visibility()
	assert_no_theme_clear()
	# Plan 05-02 groups.
	assert_shape_value_integrity()
	assert_shape_recipe_resolution()
	assert_semantic_role_table()
	assert_no_invented_focus_combos()
	# Plan 05-03 groups.
	assert_button_variation_rows()
	assert_button_variation_states()
	assert_button_variation_fonts()
	assert_button_strategy_distinctness()
	assert_dangerbutton_role_danger()
	assert_basebutton_family_chrome()
	# Plan 05-03 Task 2 polish.
	assert_basebutton_family_shape_aware()
	assert_checkbox_disabled_icon_reuse()
	_emit_summary()


func _verify_helper_wiring() -> bool:
	var loaded: Resource = ResourceLoader.load(PULSE_PATH)
	if loaded == null:
		_failures.append("HELPER FAIL: ResourceLoader.load returned null for %s" % PULSE_PATH)
		return false
	if not (loaded is NeoCadeTheme):
		_failures.append("HELPER FAIL: %s did not load as NeoCadeTheme (got %s)" % [PULSE_PATH, loaded.get_class()])
		return false
	if not (loaded as NeoCadeTheme).has_stylebox("normal", "Button"):
		_failures.append("HELPER FAIL: Phase 4 baseline regression -- Button.normal stylebox missing")
		return false
	if not FileAccess.file_exists(PRODUCTION_GD):
		_failures.append("HELPER FAIL: production class file missing at %s" % PRODUCTION_GD)
		return false
	print("PHASE5_VERIFY: helper wiring OK (Pulse loads + Phase 4 baseline holds + production .gd present).")
	return true


func assert_variation_count_15() -> void:
	var group := "assert_variation_count_15"
	var theme := _load_pulse_for_group(group)
	if theme == null: return
	var type_variations: Dictionary = theme.get_script().get_script_constant_map().get("TYPE_VARIATIONS", {})
	var n := type_variations.size()
	if n == PHASE5_VARIATION_COUNT:
		if not type_variations.has("Kicker"):
			_group_fail(group, "TYPE_VARIATIONS.size() == %d but Kicker is not registered (D-09)" % n)
			return
		_group_ok(group, "TYPE_VARIATIONS.size() == %d (incl. Kicker)" % n)
	elif n == 14 and not type_variations.has("Kicker"):
		_group_pending(group, "TYPE_VARIATIONS.size() == 14 (Phase 4 baseline; Plan 05-04 adds Kicker = 15)")
	else:
		_group_fail(group, "TYPE_VARIATIONS.size() == %d (expected 14 baseline or 15 with Kicker)" % n)


func assert_inf_text_normal_font_size() -> void:
	var group := "assert_inf_text_normal_font_size"
	var theme := _load_pulse_for_group(group)
	if theme == null: return
	var has_normal_size: bool = theme.has_font_size("normal_font_size", "InfoText")
	var has_wrong_size: bool = theme.has_font_size("font_size", "InfoText")
	var has_normal_font: bool = theme.has_font("normal_font", "InfoText")
	if has_normal_size and not has_wrong_size and has_normal_font:
		_group_ok(group, "InfoText: normal_font set, normal_font_size set, wrong font_size absent")
	else:
		var details := PackedStringArray()
		details.append("normal_font_size present=" + str(has_normal_size))
		details.append("font_size (wrong) present=" + str(has_wrong_size))
		details.append("normal_font present=" + str(has_normal_font))
		_group_pending(group, "InfoText size slot not yet at Phase 5 contract: %s" % ", ".join(details))


func assert_codeedit_gutter_slots() -> void:
	var group := "assert_codeedit_gutter_slots"
	var theme := _load_pulse_for_group(group)
	if theme == null: return
	var missing_colors: Array[String] = []
	for slot in PHASE5_CODEEDIT_GUTTER_COLORS:
		if not theme.has_color(slot, "CodeEdit"):
			missing_colors.append(slot)
	var icon_list: PackedStringArray = theme.get_icon_list("CodeEdit")
	var has_folded: bool = (icon_list.find(PHASE5_CODEEDIT_FOLDED_ICON) != -1)
	if missing_colors.is_empty() and has_folded:
		_group_ok(group, "CodeEdit gutter colors all populated and `folded` icon present")
	else:
		var details := PackedStringArray()
		if not missing_colors.is_empty():
			details.append("missing gutter colors: " + ", ".join(missing_colors))
		if not has_folded:
			details.append("missing `folded` icon (Plan 05-05)")
		_group_pending(group, "; ".join(details))


func assert_spinbox_icons() -> void:
	var group := "assert_spinbox_icons"
	var theme := _load_pulse_for_group(group)
	if theme == null: return
	var icon_list: PackedStringArray = theme.get_icon_list("SpinBox")
	var missing: Array[String] = []
	for slot in PHASE5_SPINBOX_ICONS:
		if icon_list.find(slot) == -1:
			missing.append(slot)
	var invented: Array[String] = []
	for bad in ["up_arrow", "down_arrow"]:
		if icon_list.find(bad) != -1:
			invented.append(bad)
	if not invented.is_empty():
		_group_fail(group, "SpinBox uses invented slot names (must be up/up_disabled/down/down_disabled): " + ", ".join(invented))
		return
	if missing.is_empty():
		_group_ok(group, "SpinBox icons present at official slots: " + ", ".join(PHASE5_SPINBOX_ICONS))
	else:
		_group_pending(group, "SpinBox missing official icon slots: " + ", ".join(missing) + " (Plan 05-06)")


## Plan 05-02 Task 3: extended to load each `.tres` and confirm
## _resolve_direction_presets() returns the matching DIRECTION_PRESETS row
## (not DEFAULT). Mirror of the headless variant — see that file for full
## documentation.
const PHASE5_DIRECTION_TRES_PATHS := {
	"151A2E": "res://addons/neocade_theme/pulse_neocade_theme.tres",
	"111820": "res://addons/neocade_theme/slate_neocade_theme.tres",
	"241326": "res://addons/neocade_theme/bubble_neocade_theme.tres",
	"0B2420": "res://addons/neocade_theme/daybreak_neocade_theme.tres",
	"20112E": "res://addons/neocade_theme/burst_neocade_theme.tres",
}

const PHASE5_RECIPE_PATHS := [
	"shape.primary_radius",
	"shape.primary_padding",
	"shape.primary_strategy",
	"shape.ghost_strategy",
	"shape.kicker_style",
	"shape.focus_offset",
	"shape.surface_alpha_panels",
	"shape.surface_alpha_popup",
	"shape.surface_alpha_buttons",
	"shape.raised_lifts.primary",
	"shape.raised_lifts.panel",
	"shape.raised_lifts.dialog",
]

func assert_shape_lookup_integrity() -> void:
	var group := "assert_shape_lookup_integrity"
	var theme := _load_pulse_for_group(group)
	if theme == null: return
	var const_map: Dictionary = theme.get_script().get_script_constant_map()
	var presets: Dictionary = const_map.get("DIRECTION_PRESETS", {})
	var default_preset: Dictionary = const_map.get("DIRECTION_PRESET_DEFAULT", {})
	if presets.is_empty():
		_group_fail(group, "DIRECTION_PRESETS const not found on production class")
		return
	var approved_hex_keys := ["151A2E", "111820", "241326", "0B2420", "20112E"]
	var problems: Array[String] = []
	var directions_with_shape := 0
	for hex_key in approved_hex_keys:
		var sub: Dictionary = presets.get(hex_key, {})
		if sub.is_empty():
			problems.append("direction %s missing in DIRECTION_PRESETS" % hex_key)
			continue
		var shape: Variant = sub.get("shape", null)
		if shape == null:
			problems.append("direction %s missing 'shape' sub-block (Plan 05-02)" % hex_key)
			continue
		if typeof(shape) != TYPE_DICTIONARY:
			problems.append("direction %s 'shape' is not Dictionary (got %s)" % [hex_key, typeof(shape)])
			continue
		directions_with_shape += 1
		var shape_dict: Dictionary = shape
		for key in PHASE5_SHAPE_KEYS:
			if not shape_dict.has(key):
				problems.append("direction %s shape missing key '%s'" % [hex_key, key])
				continue
			if shape_dict[key] == null:
				problems.append("direction %s shape['%s'] is null" % [hex_key, key])
	# Plan 05-02 Task 3: per-direction `.tres` load + recipe-path resolution.
	var tres_resolved_directions := 0
	for hex_key in approved_hex_keys:
		var tres_path: String = PHASE5_DIRECTION_TRES_PATHS.get(hex_key, "")
		if tres_path == "":
			problems.append("direction %s has no `.tres` path mapping in verifier" % hex_key)
			continue
		var direction_loaded: Resource = ResourceLoader.load(tres_path)
		if direction_loaded == null or not (direction_loaded is NeoCadeTheme):
			problems.append("could not load %s as NeoCadeTheme" % tres_path)
			continue
		var direction_theme: NeoCadeTheme = direction_loaded
		var resolved: Dictionary = direction_theme.call("_resolve_direction_presets")
		if resolved.is_empty():
			problems.append("%s _resolve_direction_presets returned empty" % tres_path)
			continue
		var const_row: Dictionary = presets.get(hex_key, {})
		if not resolved.has("shape") or not const_row.has("shape"):
			problems.append("%s resolved row missing shape sub-block" % tres_path)
			continue
		var resolved_shape: Dictionary = resolved.shape
		var const_shape: Dictionary = const_row.shape
		var loaded_hex: String = direction_theme.base_color.to_html(false).to_upper()
		if loaded_hex != hex_key:
			problems.append("%s base_color hex = %s but expected %s" % [tres_path, loaded_hex, hex_key])
			continue
		if resolved_shape.get("primary_radius") != const_shape.get("primary_radius"):
			problems.append("%s primary_radius mismatch" % tres_path)
		if resolved_shape.get("focus_offset") != const_shape.get("focus_offset"):
			problems.append("%s focus_offset mismatch" % tres_path)
		if String(resolved_shape.get("primary_strategy", "")) != String(const_shape.get("primary_strategy", "")):
			problems.append("%s primary_strategy mismatch" % tres_path)
		if not direction_theme.has_method("_lookup_shape"):
			problems.append("%s lacks _lookup_shape" % tres_path)
			continue
		for path in PHASE5_RECIPE_PATHS:
			var v: Variant = direction_theme.call("_lookup_shape", resolved, path)
			if v == null:
				problems.append("%s _lookup_shape('%s') returned null" % [tres_path, path])
		var fo: Variant = direction_theme.call("_lookup_shape", resolved, "shape.focus_offset")
		if fo != null and (typeof(fo) != TYPE_INT or fo < 0 or fo > 4):
			problems.append("%s shape.focus_offset out of expected range: %s" % [tres_path, str(fo)])
		tres_resolved_directions += 1
	# DEFAULT fallback (D-13).
	if not default_preset.has("shape"):
		problems.append("DIRECTION_PRESET_DEFAULT.shape missing (D-13)")
	else:
		var default_shape: Dictionary = default_preset.shape
		var custom: NeoCadeTheme = NeoCadeTheme.new()
		custom.base_color = Color("#0F0F0F")
		var custom_resolved: Dictionary = custom.call("_resolve_direction_presets")
		if not custom_resolved.has("shape"):
			problems.append("custom NeoCadeTheme.new() resolved row has no shape")
		else:
			var custom_shape: Dictionary = custom_resolved.shape
			if String(custom_shape.get("primary_strategy", "")) != String(default_shape.get("primary_strategy", "")):
				problems.append("custom theme primary_strategy mismatch with DEFAULT")
	if problems.is_empty() and directions_with_shape == 5 and tres_resolved_directions == 5:
		_group_ok(group, "all 5 directions have shape.* sub-blocks; .tres files resolve to per-direction rows; recipe paths non-null incl. focus_offset; DEFAULT fallback works")
	else:
		_group_pending(group, "shape sub-blocks not fully populated yet (Plan 05-02): %s" % "; ".join(problems))


func assert_focus_overlay_visibility() -> void:
	var group := "assert_focus_overlay_visibility"
	var theme := _load_pulse_for_group(group)
	if theme == null: return
	var missing_focus: Array[String] = []
	var base_controls := ["Button", "CheckBox", "CheckButton", "OptionButton", "LineEdit", "TextEdit"]
	var variations := ["PrimaryButton", "SecondaryButton", "GhostButton"]
	for base in base_controls:
		if not theme.has_stylebox("focus", base):
			missing_focus.append(base + " (base)")
	var pending_focus: Array[String] = []
	for v in variations:
		if not theme.has_stylebox("focus", v):
			pending_focus.append(v + " (variation, Plan 05-03)")
	var invented_slots := ["pressed_focus", "checked_focus", "hover_pressed_focus"]
	var invented_found: Array[String] = []
	for ttype in (base_controls + variations):
		for s in invented_slots:
			if theme.has_stylebox(s, ttype):
				invented_found.append("%s.%s" % [ttype, s])
	if not invented_found.is_empty():
		_group_fail(group, "D-07 violation: invented focus combo slots found: " + ", ".join(invented_found))
		return
	if not missing_focus.is_empty():
		_group_fail(group, "base-control focus stylebox missing on: " + ", ".join(missing_focus))
		return
	if pending_focus.is_empty():
		_group_ok(group, "focus stylebox present on all base controls and variations; no invented combo slots")
	else:
		_group_pending(group, "base-control focus OK; pending variation focus: " + ", ".join(pending_focus))


func assert_no_theme_clear() -> void:
	var group := "assert_no_theme_clear"
	var f := FileAccess.open(PRODUCTION_GD, FileAccess.READ)
	if f == null:
		_group_fail(group, "could not read production class source")
		return
	var src_text: String = f.get_as_text()
	f.close()
	var clean_lines: Array[String] = []
	for line in src_text.split("\n"):
		var stripped: String = line.strip_edges()
		if stripped.begins_with("#"):
			continue
		clean_lines.append(line)
	var clean_text := "\n".join(clean_lines)
	var bad_patterns := [".clear()", "set_theme(null"]
	var violations: Array[String] = []
	for line in clean_text.split("\n"):
		for pat in bad_patterns:
			if line.find(pat) != -1:
				if pat == ".clear()":
					var lower: String = line.to_lower()
					if lower.find("theme") == -1:
						continue
				violations.append(line.strip_edges())
	if violations.is_empty():
		_group_ok(group, "no Theme.clear() / set_theme(null) calls in production class (non-comment scan)")
	else:
		_group_fail(group, "D-13 violation: forbidden patterns in production class: " + "; ".join(violations))


# ----- Plan 05-02 assertion groups (mirror of headless variant) -----

func assert_shape_value_integrity() -> void:
	var group := "assert_shape_value_integrity"
	var theme := _load_pulse_for_group(group)
	if theme == null: return
	var const_map: Dictionary = theme.get_script().get_script_constant_map()
	var presets: Dictionary = const_map.get("DIRECTION_PRESETS", {})
	var default_preset: Dictionary = const_map.get("DIRECTION_PRESET_DEFAULT", {})
	var problems: Array[String] = []
	var expected := [
		{"hex": "151A2E", "primary_radius": 0,   "focus_offset": 0, "lift_primary": 3, "strategy": "bold-accent-fill"},
		{"hex": "111820", "primary_radius": 14,  "focus_offset": 2, "lift_primary": 2, "strategy": "quiet-pill"},
		{"hex": "241326", "primary_radius": 999, "focus_offset": 2, "lift_primary": 6, "strategy": "pillowy-fully-rounded"},
		{"hex": "0B2420", "primary_radius": 8,   "focus_offset": 2, "lift_primary": 3, "strategy": "friendly-generous"},
		{"hex": "20112E", "primary_radius": 28,  "focus_offset": 1, "lift_primary": 5, "strategy": "oversized-statement"},
	]
	var phase4_scalars := {
		"151A2E": {"spread_factor": 1.3, "hover_pct": 6.0,  "pressed_pct": -10.0, "disabled_opacity": 0.42},
		"111820": {"spread_factor": 0.7, "hover_pct": 4.0,  "pressed_pct":  -6.0, "disabled_opacity": 0.50},
		"241326": {"spread_factor": 1.0, "hover_pct": 8.0,  "pressed_pct": -10.0, "disabled_opacity": 0.45},
		"0B2420": {"spread_factor": 1.0, "hover_pct": 6.0,  "pressed_pct":  -6.0, "disabled_opacity": 0.50},
		"20112E": {"spread_factor": 1.3, "hover_pct": 8.0,  "pressed_pct": -12.0, "disabled_opacity": 0.45},
	}
	var strategies_seen: Dictionary = {}
	for row in expected:
		var hex: String = row["hex"]
		var sub: Dictionary = presets.get(hex, {})
		if sub.is_empty():
			problems.append("direction %s missing in DIRECTION_PRESETS" % hex)
			continue
		var scalars: Dictionary = phase4_scalars[hex]
		for sk in scalars.keys():
			if not sub.has(sk):
				problems.append("%s missing Phase 4 scalar %s" % [hex, sk])
				continue
			if not is_equal_approx(float(sub[sk]), float(scalars[sk])):
				problems.append("%s scalar %s = %s (expected %s)" % [hex, sk, str(sub[sk]), str(scalars[sk])])
		var shape: Variant = sub.get("shape", null)
		if shape == null or typeof(shape) != TYPE_DICTIONARY:
			problems.append("%s shape sub-block missing or not a Dictionary" % hex)
			continue
		var shape_dict: Dictionary = shape
		if shape_dict.get("primary_radius", null) != row["primary_radius"]:
			problems.append("%s shape.primary_radius = %s (expected %s)" % [hex, str(shape_dict.get("primary_radius", null)), str(row["primary_radius"])])
		if shape_dict.get("focus_offset", null) != row["focus_offset"]:
			problems.append("%s shape.focus_offset = %s (expected %s)" % [hex, str(shape_dict.get("focus_offset", null)), str(row["focus_offset"])])
		var lifts: Variant = shape_dict.get("raised_lifts", null)
		if lifts == null or typeof(lifts) != TYPE_DICTIONARY:
			problems.append("%s shape.raised_lifts missing or not Dictionary" % hex)
		else:
			var lifts_dict: Dictionary = lifts
			if lifts_dict.get("primary", null) != row["lift_primary"]:
				problems.append("%s shape.raised_lifts.primary = %s (expected %s)" % [hex, str(lifts_dict.get("primary", null)), str(row["lift_primary"])])
		var padding: Variant = shape_dict.get("primary_padding", null)
		if padding == null:
			problems.append("%s shape.primary_padding missing" % hex)
		elif typeof(padding) != TYPE_VECTOR2I:
			problems.append("%s shape.primary_padding type = %d (expected Vector2i)" % [hex, typeof(padding)])
		var strategy: Variant = shape_dict.get("primary_strategy", null)
		if strategy == null:
			problems.append("%s shape.primary_strategy missing" % hex)
		else:
			var strat_str := String(strategy)
			if strat_str != row["strategy"]:
				problems.append("%s shape.primary_strategy = '%s' (expected '%s')" % [hex, strat_str, row["strategy"]])
			strategies_seen[strat_str] = true
	if strategies_seen.size() < 4:
		problems.append("primary_strategy distinct count = %d (expected >= 4 across 5 directions)" % strategies_seen.size())
	if default_preset.is_empty():
		problems.append("DIRECTION_PRESET_DEFAULT const not found")
	else:
		var default_shape: Variant = default_preset.get("shape", null)
		if default_shape == null or typeof(default_shape) != TYPE_DICTIONARY or (default_shape as Dictionary).is_empty():
			problems.append("DIRECTION_PRESET_DEFAULT.shape missing or empty")
	if problems.is_empty():
		_group_ok(group, "shape values match DESIGN_TOKENS §5.1-§5.5 verbatim")
	else:
		_group_pending(group, "; ".join(problems))


func assert_shape_recipe_resolution() -> void:
	var group := "assert_shape_recipe_resolution"
	var bubble_path := "res://addons/neocade_theme/bubble_neocade_theme.tres"
	var loaded: Resource = ResourceLoader.load(bubble_path)
	if loaded == null or not (loaded is NeoCadeTheme):
		_group_fail(group, "could not load %s as NeoCadeTheme" % bubble_path)
		return
	var theme: NeoCadeTheme = loaded
	if not theme.has_method("_lookup_shape") or not theme.has_method("_resolve_recipe"):
		_group_pending(group, "Plan 05-02 helpers not yet present (_lookup_shape / _resolve_recipe)")
		return
	var presets: Dictionary = theme.call("_resolve_direction_presets")
	if presets.is_empty() or not presets.has("shape"):
		_group_pending(group, "Bubble preset has no shape sub-block")
		return
	var probe_radius = theme.call("_lookup_shape", presets, "shape.primary_radius")
	if probe_radius != 999:
		_group_pending(group, "_lookup_shape shape.primary_radius for Bubble = %s (expected 999)" % str(probe_radius))
		return
	var required_helpers := ["_set_radius_all", "_set_content_margin_from_padding", "_apply_primary_strategy", "_apply_ghost_strategy", "_apply_kicker_style"]
	var missing_helpers: Array[String] = []
	for h in required_helpers:
		if not theme.has_method(h):
			missing_helpers.append(h)
	if not missing_helpers.is_empty():
		_group_pending(group, "missing helpers: " + ", ".join(missing_helpers))
		return
	_group_ok(group, "_lookup_shape walks dotted paths; required helpers present")


func assert_semantic_role_table() -> void:
	var group := "assert_semantic_role_table"
	var theme := _load_pulse_for_group(group)
	if theme == null: return
	var f := FileAccess.open(PRODUCTION_GD, FileAccess.READ)
	if f == null:
		_group_fail(group, "could not read production source")
		return
	var src_text: String = f.get_as_text()
	f.close()
	var role_keys := ["role_success", "role_warning", "role_danger", "role_info"]
	var missing: Array[String] = []
	for role in role_keys:
		var found := false
		for line in src_text.split("\n"):
			var stripped: String = line.strip_edges()
			if stripped.begins_with("#"):
				continue
			if stripped.find("\"" + role + "\"") != -1 or stripped.find(role + ":") != -1:
				found = true
				break
		if not found:
			missing.append(role)
	if missing.is_empty():
		_group_ok(group, "semantic role keys present in production source")
	else:
		_group_pending(group, "missing role keys: " + ", ".join(missing))


const FORBIDDEN_FOCUS_COMBO_SLOTS := ["pressed_focus", "checked_focus", "hover_pressed_focus"]


# ----- Plan 05-03 assertion groups (mirror of headless variant) -----

func assert_button_variation_rows() -> void:
	var group := "assert_button_variation_rows"
	var theme := _load_pulse_for_group(group)
	if theme == null: return
	var binding_table: Dictionary = theme.get_script().get_script_constant_map().get("BINDING_TABLE", {})
	if binding_table.is_empty():
		_group_fail(group, "BINDING_TABLE const not found")
		return
	var missing: Array[String] = []
	for v in PHASE5_BUTTON_VARIATIONS:
		if not binding_table.has(v):
			missing.append(v)
	if missing.is_empty():
		_group_ok(group, "all six TYPEVAR-01 button variation rows present")
	else:
		_group_pending(group, "missing TYPEVAR-01 button variation rows: " + ", ".join(missing))


func assert_button_variation_states() -> void:
	var group := "assert_button_variation_states"
	var theme := _load_pulse_for_group(group)
	if theme == null: return
	var problems: Array[String] = []
	for v in PHASE5_BUTTON_VARIATIONS:
		for state in PHASE5_BUTTON_VARIATION_STATES:
			if not theme.has_stylebox(state, v):
				problems.append("%s.%s missing" % [v, state])
	if problems.is_empty():
		_group_ok(group, "all six button variations expose the full state set on Pulse")
	else:
		_group_pending(group, "; ".join(problems))


func assert_button_variation_fonts() -> void:
	var group := "assert_button_variation_fonts"
	var theme := _load_pulse_for_group(group)
	if theme == null: return
	var problems: Array[String] = []
	for v in PHASE5_BUTTON_VARIATIONS:
		if not theme.has_font("font", v):
			problems.append("%s.font missing (PITFALLS 1.2)" % v)
		if not theme.has_font_size("font_size", v):
			problems.append("%s.font_size missing" % v)
	if problems.is_empty():
		_group_ok(group, "all six button variations have explicit `font` + `font_size` (D-17)")
	else:
		_group_pending(group, "; ".join(problems))


func assert_button_strategy_distinctness() -> void:
	var group := "assert_button_strategy_distinctness"
	var theme := _load_pulse_for_group(group)
	if theme == null: return
	if not theme.has_method("_lookup_shape"):
		_group_pending(group, "_lookup_shape missing (Plan 05-02)")
		return
	var presets: Dictionary = theme.get_script().get_script_constant_map().get("DIRECTION_PRESETS", {})
	if presets.is_empty():
		_group_fail(group, "DIRECTION_PRESETS const not found")
		return
	var primary_seen: Dictionary = {}
	var ghost_seen: Dictionary = {}
	for hex_key in ["151A2E", "111820", "241326", "0B2420", "20112E"]:
		var sub: Dictionary = presets.get(hex_key, {})
		if sub.is_empty(): continue
		var ps_v: Variant = theme.call("_lookup_shape", sub, "shape.primary_strategy")
		if ps_v != null: primary_seen[String(ps_v)] = true
		var gs_v: Variant = theme.call("_lookup_shape", sub, "shape.ghost_strategy")
		if gs_v != null: ghost_seen[String(gs_v)] = true
	var problems: Array[String] = []
	if primary_seen.size() < 4:
		problems.append("primary_strategy distinct count = %d" % primary_seen.size())
	if ghost_seen.size() < 4:
		problems.append("ghost_strategy distinct count = %d" % ghost_seen.size())
	if problems.is_empty():
		_group_ok(group, "primary + ghost strategies each expose >=4 distinct values across 5 directions")
	else:
		_group_pending(group, "; ".join(problems))


func assert_dangerbutton_role_danger() -> void:
	var group := "assert_dangerbutton_role_danger"
	var theme := _load_pulse_for_group(group)
	if theme == null: return
	if not theme.has_stylebox("normal", "DangerButton"):
		_group_pending(group, "DangerButton.normal missing (Plan 05-03 not yet landed)")
		return
	var sb: StyleBox = theme.get_stylebox("normal", "DangerButton")
	if not (sb is StyleBoxFlat):
		_group_fail(group, "DangerButton.normal is not a StyleBoxFlat")
		return
	var fsb: StyleBoxFlat = sb
	var expected := Color("#FF6E6E")
	var rgb_match := is_equal_approx(fsb.bg_color.r, expected.r) \
		and is_equal_approx(fsb.bg_color.g, expected.g) \
		and is_equal_approx(fsb.bg_color.b, expected.b)
	if not rgb_match:
		_group_pending(group, "DangerButton.normal bg_color = %s; expected role_danger = %s" % [fsb.bg_color.to_html(false), expected.to_html(false)])
		return
	if not theme.has_color("font_color", "DangerButton"):
		_group_pending(group, "DangerButton.font_color missing")
		return
	_group_ok(group, "DangerButton.normal resolves to role_danger #%s (Plan 05-02 semantic role flowed through)" % fsb.bg_color.to_html(false).to_upper())


func assert_basebutton_family_shape_aware() -> void:
	var group := "assert_basebutton_family_shape_aware"
	var f := FileAccess.open(PRODUCTION_GD, FileAccess.READ)
	if f == null:
		_group_fail(group, "could not read production source")
		return
	var src_text: String = f.get_as_text()
	f.close()
	var shape_aware_targets := ["Button", "OptionButton", "MenuButton", "ColorPickerButton"]
	# Anchor past CANONICAL_SLOT_NAMES so we hit BINDING_TABLE rows.
	var binding_table_anchor: int = src_text.find("const BINDING_TABLE")
	if binding_table_anchor == -1:
		_group_fail(group, "BINDING_TABLE const declaration not found in production source")
		return
	var problems: Array[String] = []
	for klass in shape_aware_targets:
		var header: String = "\"" + String(klass) + "\":"
		var idx: int = src_text.find(header, binding_table_anchor)
		if idx == -1:
			problems.append("%s row not found in BINDING_TABLE" % klass)
			continue
		var window: String = src_text.substr(idx, 4000)
		# Cut at next `\n\t# <digit>` (numbered class header), not at any inline
		# `\n\t# ...` comment that may appear within the row body.
		var search_start: int = 1
		while true:
			var cut: int = window.find("\n\t# ", search_start)
			if cut == -1:
				break
			var next_char_idx: int = cut + 4
			if next_char_idx < window.length():
				var ch: String = window.substr(next_char_idx, 1)
				if ch >= "0" and ch <= "9":
					window = window.substr(0, cut)
					break
			search_start = cut + 1
		if window.find("\"shape.") == -1 and window.find("'shape.") == -1:
			problems.append("%s row has no `shape.*` recipe references (Plan 05-03 Task 2)" % klass)
	if problems.is_empty():
		_group_ok(group, "Button / OptionButton / MenuButton / ColorPickerButton rows reference shape.* recipes")
	else:
		_group_pending(group, "; ".join(problems))


func assert_checkbox_disabled_icon_reuse() -> void:
	var group := "assert_checkbox_disabled_icon_reuse"
	var theme := _load_pulse_for_group(group)
	if theme == null: return
	var problems: Array[String] = []
	var cb_icons: PackedStringArray = theme.get_icon_list("CheckButton")
	for ic in ["checked_disabled", "unchecked_disabled"]:
		if cb_icons.find(ic) == -1:
			problems.append("CheckButton.%s missing — reuse the existing checkbutton SVG" % ic)
	var cx_icons: PackedStringArray = theme.get_icon_list("CheckBox")
	for ic in ["checked_disabled", "unchecked_disabled"]:
		if cx_icons.find(ic) == -1:
			problems.append("CheckBox.%s missing — reuse the existing checkbox SVG" % ic)
	if problems.is_empty():
		_group_ok(group, "CheckBox + CheckButton disabled icon slots reuse existing SVGs")
	else:
		_group_pending(group, "; ".join(problems))


func assert_basebutton_family_chrome() -> void:
	var group := "assert_basebutton_family_chrome"
	var theme := _load_pulse_for_group(group)
	if theme == null: return
	var problems: Array[String] = []
	var filled := ["Button", "CheckBox", "CheckButton", "OptionButton", "MenuButton", "ColorPickerButton"]
	for klass in filled:
		for state in ["normal", "hover", "pressed", "focus", "disabled"]:
			if not theme.has_stylebox(state, klass):
				problems.append("%s.%s missing" % [klass, state])
	for klass in ["Button", "CheckBox", "CheckButton", "OptionButton", "MenuButton"]:
		if not theme.has_stylebox("hover_pressed", klass):
			problems.append("%s.hover_pressed missing" % klass)
	for ic in ["checked", "unchecked", "radio_checked", "radio_unchecked"]:
		var icons: PackedStringArray = theme.get_icon_list("CheckBox")
		if icons.find(ic) == -1:
			problems.append("CheckBox icon `%s` missing" % ic)
	for ic in ["checked", "unchecked"]:
		var icons2: PackedStringArray = theme.get_icon_list("CheckButton")
		if icons2.find(ic) == -1:
			problems.append("CheckButton icon `%s` missing" % ic)
	for slot in ["font_color", "font_hover_color", "font_focus_color"]:
		if not theme.has_color(slot, "LinkButton"):
			problems.append("LinkButton.%s missing" % slot)
	if theme.has_stylebox("normal", "LinkButton"):
		problems.append("LinkButton.normal stylebox present — LinkButton must stay text-only")
	if problems.is_empty():
		_group_ok(group, "all 7 BaseButton-family controls expose their official slot set; LinkButton stays text-only")
	else:
		_group_pending(group, "; ".join(problems))


func assert_no_invented_focus_combos() -> void:
	var group := "assert_no_invented_focus_combos"
	var f := FileAccess.open(PRODUCTION_GD, FileAccess.READ)
	if f == null:
		_group_fail(group, "could not read production source")
		return
	var src_text: String = f.get_as_text()
	f.close()
	var clean_lines: Array[String] = []
	for line in src_text.split("\n"):
		var stripped: String = line.strip_edges()
		if stripped.begins_with("#"):
			continue
		clean_lines.append(line)
	var clean_text := "\n".join(clean_lines)
	var violations: Array[String] = []
	for forbidden in FORBIDDEN_FOCUS_COMBO_SLOTS:
		var as_dq_key: String = "\"" + forbidden + "\":"
		var as_sq_key: String = "'" + forbidden + "':"
		for line in clean_text.split("\n"):
			if line.find(as_dq_key) != -1 or line.find(as_sq_key) != -1:
				violations.append("%s in line: %s" % [forbidden, line.strip_edges()])
	if violations.is_empty():
		_group_ok(group, "no invented focus combo slots in BINDING_TABLE")
	else:
		_group_fail(group, "D-07 violation: " + "; ".join(violations))


# ----- shared helpers -----

func _load_pulse_for_group(group: String) -> NeoCadeTheme:
	var loaded: Resource = ResourceLoader.load(PULSE_PATH)
	if loaded == null or not (loaded is NeoCadeTheme):
		_group_fail(group, "could not load %s as NeoCadeTheme" % PULSE_PATH)
		return null
	return loaded


func _group_ok(group: String, detail: String) -> void:
	print("PHASE5_GROUP_OK:%s ENFORCED  %s" % [group, detail])
	_ok_markers.append(group)


func _group_pending(group: String, detail: String) -> void:
	# Mirror the headless variant's stage policy: shape stage is strict for
	# shape-related groups; buttons stage is strict for buttons groups +
	# carry-forward shape; strict stage is strict for everything; tooling
	# is permissive.
	var shape_stage_strict := [
		"assert_shape_lookup_integrity",
		"assert_shape_value_integrity",
		"assert_shape_recipe_resolution",
		"assert_semantic_role_table",
		"assert_no_invented_focus_combos",
		"assert_no_theme_clear",
	]
	var buttons_stage_strict := [
		"assert_button_variation_rows",
		"assert_button_variation_states",
		"assert_button_variation_fonts",
		"assert_button_strategy_distinctness",
		"assert_dangerbutton_role_danger",
		"assert_basebutton_family_chrome",
		"assert_basebutton_family_shape_aware",
		"assert_checkbox_disabled_icon_reuse",
		"assert_focus_overlay_visibility",
		"assert_shape_lookup_integrity",
		"assert_shape_value_integrity",
		"assert_shape_recipe_resolution",
		"assert_semantic_role_table",
		"assert_no_invented_focus_combos",
		"assert_no_theme_clear",
	]
	var fail: bool = false
	if _stage == "strict":
		fail = true
	elif _stage == "shape" and group in shape_stage_strict:
		fail = true
	elif _stage == "buttons" and group in buttons_stage_strict:
		fail = true
	if fail:
		var label: String = _stage.to_upper()
		print("PHASE5_GROUP_FAIL:%s %s  %s" % [group, label, detail])
		_failures.append("%s-mode pending: %s -- %s" % [_stage, group, detail])
	else:
		print("PHASE5_GROUP_PENDING:%s  %s" % [group, detail])
		print("PHASE5_GROUP_OK:%s TOOLING  pending invariant" % group)
		_pending.append(group)
		_ok_markers.append(group)


func _group_fail(group: String, detail: String) -> void:
	print("PHASE5_GROUP_FAIL:%s  %s" % [group, detail])
	_failures.append("%s -- %s" % [group, detail])


func _emit_summary() -> void:
	print("----- PHASE5_VERIFY summary -----")
	print("  stage:          %s" % _stage)
	# Plan 01 baseline 7 + Plan 05-02 added 4 + Plan 05-03 added 8 = 19.
	print("  groups OK:      %d / %d" % [_ok_markers.size(), 19])
	print("  groups PENDING: %d  %s" % [_pending.size(), str(_pending)])
	print("  failures:       %d" % _failures.size())
	for f in _failures:
		print("    - %s" % f)
	print("---------------------------------")
	if _failures.size() > 0:
		push_error("PHASE5_VERIFY FAILED with %d failures (see Output)" % _failures.size())
		return
	print("PHASE5_VERIFY OK (stage=%s)" % _stage)
