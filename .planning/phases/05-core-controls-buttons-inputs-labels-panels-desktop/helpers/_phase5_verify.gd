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


func assert_shape_lookup_integrity() -> void:
	var group := "assert_shape_lookup_integrity"
	var theme := _load_pulse_for_group(group)
	if theme == null: return
	var presets: Dictionary = theme.get_script().get_script_constant_map().get("DIRECTION_PRESETS", {})
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
	if problems.is_empty() and directions_with_shape == 5:
		_group_ok(group, "all 5 directions have shape.* sub-blocks with required keys")
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
	if _stage == "strict":
		print("PHASE5_GROUP_FAIL:%s STRICT  %s" % [group, detail])
		_failures.append("strict-mode pending: %s -- %s" % [group, detail])
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
	print("  groups OK:      %d / %d" % [_ok_markers.size(), 7])
	print("  groups PENDING: %d  %s" % [_pending.size(), str(_pending)])
	print("  failures:       %d" % _failures.size())
	for f in _failures:
		print("    - %s" % f)
	print("---------------------------------")
	if _failures.size() > 0:
		push_error("PHASE5_VERIFY FAILED with %d failures (see Output)" % _failures.size())
		return
	print("PHASE5_VERIFY OK (stage=%s)" % _stage)
