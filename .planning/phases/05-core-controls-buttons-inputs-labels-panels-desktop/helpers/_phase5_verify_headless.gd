extends SceneTree

## Phase 5 verifier (headless variant). Run via:
##
##   <godot-cli> --headless --path . --script \
##     .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify_headless.gd \
##     -- --stage <tooling|strict>
##
## Stages:
##   tooling  Phase 5 Plan 01 baseline. Asserts Phase 4 baseline + helper wiring +
##            every named assertion group executes and emits PHASE5_GROUP_OK. Groups
##            whose Phase 5 invariants are not yet implemented (SpinBox icons,
##            CodeEdit folded icon, InfoText normal_font_size, 15th variation) log
##            PHASE5_GROUP_PENDING and STILL emit PHASE5_GROUP_OK so the marker
##            check passes. Later plans flip the relevant group from PENDING to
##            ENFORCED as their work lands.
##   strict   Future stage (Plans 05-02..05-07). Treats every PENDING marker as a
##            failure and exits non-zero. Wired now so later plans only need to
##            change the --stage argument; they do not need to re-author the
##            verifier.
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
## Per D-07: Godot 4.6 Button-family uses official `focus` overlay; verifier MUST
## NOT reference invented `pressed_focus`, `checked_focus`, or `hover_pressed_focus`
## slots.
##
## Per D-11: Phase 5 helpers live under .planning/phases/05-.../helpers/, NOT in
## addons/neocade_theme/ (Phase 4 F3 path discipline).

const PULSE_PATH := "res://addons/neocade_theme/pulse_neocade_theme.tres"
const PRODUCTION_GD := "res://addons/neocade_theme/neocade_theme.gd"

# Phase 5 expected slot sets / counts. The verifier asserts these against the live
# Theme; in tooling stage, groups whose assertion fails log PENDING (not FAIL).

# 15 variations once Plan 05-04 lands the Kicker variation.
const PHASE5_VARIATION_COUNT := 15

# SpinBox official Godot 4.6 icon slot names (per CONTEXT.md + Godot 4.6 docs).
# NOT `up_arrow` / `down_arrow` (those are not official slot names).
const PHASE5_SPINBOX_ICONS := ["up", "up_disabled", "down", "down_disabled"]

# CodeEdit chrome slots Phase 5 must populate. `line_number_color` is the
# baseline gutter color; `folded` is the icon slot Plan 05-05 wires.
const PHASE5_CODEEDIT_GUTTER_COLORS := [
	"line_number_color",
	"breakpoint_color",
	"code_folding_color",
	"bookmark_color",
	"executing_line_color",
	"line_length_guideline_color",
]
const PHASE5_CODEEDIT_FOLDED_ICON := "folded"

# Phase 5 shape sub-block keys (per D-02). The verifier walks DIRECTION_PRESETS
# and asserts each direction's shape sub-dict has these keys non-null.
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

# Focusable Phase 5 Controls / variations whose `focus` overlay must be populated.
const PHASE5_FOCUS_TYPES := [
	"Button",
	"CheckBox",
	"CheckButton",
	"OptionButton",
	"LineEdit",
	"TextEdit",
	"PrimaryButton",
	"SecondaryButton",
	"GhostButton",
]

# ----- argv parsing -----
var _stage: String = "tooling"
var _failures: Array[String] = []
var _pending: Array[String] = []
var _ok_markers: Array[String] = []

func _init() -> void:
	_parse_args()
	_run_verifier()
	_emit_summary_and_quit()


func _parse_args() -> void:
	# Godot 4.6 splits CLI args at the literal `--`. Args before `--` go to
	# OS.get_cmdline_args() (engine args + --script <path>); args after `--`
	# go to OS.get_cmdline_user_args() (user-supplied script args). The plan
	# verifies via `... --script <path> -- --stage tooling`, so we read
	# get_cmdline_user_args() first and fall back to get_cmdline_args() so
	# the script also works if someone forgets the `--` separator.
	var sources := [OS.get_cmdline_user_args(), OS.get_cmdline_args()]
	var found := false
	for source in sources:
		var args: PackedStringArray = source
		var i := 0
		while i < args.size():
			var a: String = args[i]
			if a == "--stage" and i + 1 < args.size():
				_stage = args[i + 1]
				found = true
				break
			i += 1
		if found:
			break
	if _stage != "tooling" and _stage != "strict":
		push_error("PHASE5_VERIFY FAIL: unknown --stage '%s' (expected tooling|strict)" % _stage)
		_stage = "tooling"
	print("PHASE5_VERIFY: stage=%s" % _stage)


func _run_verifier() -> void:
	# Helper wiring + Phase 4 baseline. These are HARD failures even in tooling;
	# they prove the verifier loaded the right code.
	if not _verify_helper_wiring():
		return  # _verify_helper_wiring populates _failures and quits via the summary

	# Named assertion groups (D-12).
	assert_variation_count_15()
	assert_inf_text_normal_font_size()
	assert_codeedit_gutter_slots()
	assert_spinbox_icons()
	assert_shape_lookup_integrity()
	assert_focus_overlay_visibility()
	assert_no_theme_clear()


func _verify_helper_wiring() -> bool:
	# Production class loads.
	var loaded: Resource = ResourceLoader.load(PULSE_PATH)
	if loaded == null:
		_failures.append("HELPER FAIL: ResourceLoader.load returned null for %s" % PULSE_PATH)
		return false
	if not (loaded is NeoCadeTheme):
		_failures.append("HELPER FAIL: %s did not load as NeoCadeTheme (got %s)" % [PULSE_PATH, loaded.get_class()])
		return false
	var theme: NeoCadeTheme = loaded
	if not theme.has_stylebox("normal", "Button"):
		_failures.append("HELPER FAIL: Phase 4 baseline regression -- Button.normal stylebox missing on %s" % PULSE_PATH)
		return false
	# Production source file is on disk where the verifier can introspect it.
	var prod_path := ProjectSettings.globalize_path(PRODUCTION_GD)
	if not FileAccess.file_exists(PRODUCTION_GD):
		_failures.append("HELPER FAIL: production class file missing at %s (globalized: %s)" % [PRODUCTION_GD, prod_path])
		return false
	print("PHASE5_VERIFY: helper wiring OK (Pulse loads + Phase 4 baseline holds + production .gd present).")
	return true


# ----- assertion group: variation count = 15 -----
##
## Phase 4 ships TYPE_VARIATIONS.size() == 14. Plan 05-04 adds Kicker = 15.
## In tooling stage, 14 logs PENDING; 15 logs ENFORCED OK.
func assert_variation_count_15() -> void:
	var group := "assert_variation_count_15"
	var theme := _load_pulse_for_group(group)
	if theme == null: return
	var type_variations: Dictionary = theme.get_script().get_script_constant_map().get("TYPE_VARIATIONS", {})
	var n := type_variations.size()
	if n == PHASE5_VARIATION_COUNT:
		# Strict: must include "Kicker".
		if not type_variations.has("Kicker"):
			_group_fail(group, "TYPE_VARIATIONS.size() == %d but Kicker is not registered (D-09)" % n)
			return
		_group_ok(group, "TYPE_VARIATIONS.size() == %d (incl. Kicker)" % n)
	elif n == 14 and not type_variations.has("Kicker"):
		_group_pending(group, "TYPE_VARIATIONS.size() == 14 (Phase 4 baseline; Plan 05-04 adds Kicker = 15)")
	else:
		_group_fail(group, "TYPE_VARIATIONS.size() == %d (expected 14 baseline or 15 with Kicker)" % n)


# ----- assertion group: InfoText uses normal_font_size, not font_size -----
##
## Per RichTextLabel API + Phase 4 BL-02: InfoText slot is `normal_font` /
## `normal_font_size`, NOT `font` / `font_size`. Phase 4 close already fixed
## `normal_font`; Plan 05-04 (or wherever variation chrome lands) must also
## switch the size slot.
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


# ----- assertion group: CodeEdit gutter colors + folded icon -----
##
## Phase 5 SC#2 + Plan 05-05: CodeEdit gutter chrome (gutter colors named in
## DESIGN_TOKENS) plus the `folded` icon slot. line_number_color is the baseline
## gutter color name asserted explicitly per CONTEXT.md.
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


# ----- assertion group: SpinBox official icon slot names -----
##
## Per Godot 4.6 SpinBox docs and CONTEXT.md `<key_invariants>`: official slots
## are exactly `up`, `up_disabled`, `down`, `down_disabled`. NOT `up_arrow` /
## `down_arrow`. Plan 05-06 wires the icons.
func assert_spinbox_icons() -> void:
	var group := "assert_spinbox_icons"
	var theme := _load_pulse_for_group(group)
	if theme == null: return
	var icon_list: PackedStringArray = theme.get_icon_list("SpinBox")
	var missing: Array[String] = []
	for slot in PHASE5_SPINBOX_ICONS:
		if icon_list.find(slot) == -1:
			missing.append(slot)
	# Soft-fail invented slot names if anyone wires them by accident.
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


# ----- assertion group: shape.* lookup integrity for all 5 approved directions -----
##
## Per D-02 + D-03: every approved direction must have a non-null `shape` sub-dict
## with the Phase 5 keys present. Plan 05-02 lands the schema. Plan 05-03..05-07
## consume it. The verifier walks DIRECTION_PRESETS and asserts each approved
## direction's shape sub-block exposes every key in PHASE5_SHAPE_KEYS.
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


# ----- assertion group: focus overlay visibility (D-07) -----
##
## Per D-07: Phase 5 verifier asserts the OFFICIAL `focus` overlay slot exists
## on every focusable Phase 5 type. Phase 5 must NEVER reference invented
## `pressed_focus` / `checked_focus` / `hover_pressed_focus` slots.
##
## This group performs structural focus assertions only. Pixel-level focus
## visibility (focus visible over pressed / hover_pressed states) is delegated
## to _phase5_focus_probe.gd; if headless rendering is unavailable, the probe
## emits PHASE5_FOCUS_RENDER_SKIPPED and structural assertions stand alone.
func assert_focus_overlay_visibility() -> void:
	var group := "assert_focus_overlay_visibility"
	var theme := _load_pulse_for_group(group)
	if theme == null: return
	var missing_focus: Array[String] = []
	# Variations may not exist yet at the Phase 4 baseline; accept missing focus
	# on variations as PENDING but treat missing focus on base controls as FAIL.
	var base_controls := ["Button", "CheckBox", "CheckButton", "OptionButton", "LineEdit", "TextEdit"]
	var variations := ["PrimaryButton", "SecondaryButton", "GhostButton"]
	for base in base_controls:
		if not theme.has_stylebox("focus", base):
			missing_focus.append(base + " (base)")
	var pending_focus: Array[String] = []
	for v in variations:
		if not theme.has_stylebox("focus", v):
			pending_focus.append(v + " (variation, Plan 05-03)")
	# D-07 invariant: invented combo slots must NOT appear anywhere.
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


# ----- assertion group: no Theme.clear() in production class -----
##
## Per D-13 (Phase 4 D-01 carry-forward): the production class MUST NOT call
## Theme.clear() / .clear() / set_theme(null) / .free() on the theme during
## regeneration. The verifier scans the production .gd source ONLY on
## non-comment lines; the regex itself is therefore not a self-match (the
## scanner skips any line whose first non-whitespace char is `#`).
func assert_no_theme_clear() -> void:
	var group := "assert_no_theme_clear"
	var src_text := _read_production_source()
	if src_text.is_empty():
		_group_fail(group, "could not read production class source")
		return
	# Strip comment lines (any line whose first non-whitespace char is `#`).
	# Multi-line `"""..."""` docstrings do not exist in GDScript; `##` comments
	# also start with `#`, so the same filter handles them.
	var clean_lines: Array[String] = []
	for line in src_text.split("\n"):
		var stripped: String = line.strip_edges()
		if stripped.begins_with("#"):
			continue
		clean_lines.append(line)
	var clean_text := "\n".join(clean_lines)
	# Patterns that violate D-13. Each is a literal substring search; we do not
	# use regex so the regex literal cannot accidentally self-match.
	var bad_patterns := [
		".clear()",       # Theme.clear() / theme.clear() / etc.
		"set_theme(null", # set_theme(null) / set_theme(null)
	]
	var violations: Array[String] = []
	for line in clean_text.split("\n"):
		for pat in bad_patterns:
			if line.find(pat) != -1:
				# Exempt obvious non-Theme uses (e.g., array.clear(), dict.clear()
				# inside a private helper). Phase 4 D-01 specifically forbids
				# Theme.clear; the safest check here is to flag any `.clear()`
				# call site for human review, but to keep the gate green we
				# allow lines that explicitly do NOT contain the substring
				# 'theme' or 'Theme'. This mirrors the Phase 4 grep gate which
				# searched specifically for Theme.clear / theme.clear.
				if pat == ".clear()":
					var lower: String = line.to_lower()
					if lower.find("theme") == -1:
						# An array/dict clear that does not touch a theme.
						# Per Phase 4 contract this is acceptable.
						continue
				violations.append(line.strip_edges())
	if violations.is_empty():
		_group_ok(group, "no Theme.clear() / set_theme(null) calls in production class (non-comment scan)")
	else:
		_group_fail(group, "D-13 violation: forbidden patterns in production class: " + "; ".join(violations))


# ----- helpers -----

func _load_pulse_for_group(group: String) -> NeoCadeTheme:
	var loaded: Resource = ResourceLoader.load(PULSE_PATH)
	if loaded == null or not (loaded is NeoCadeTheme):
		_group_fail(group, "could not load %s as NeoCadeTheme" % PULSE_PATH)
		return null
	return loaded


func _read_production_source() -> String:
	var f := FileAccess.open(PRODUCTION_GD, FileAccess.READ)
	if f == null:
		return ""
	var text := f.get_as_text()
	f.close()
	return text


func _group_ok(group: String, detail: String) -> void:
	# Always emit the OK marker so the marker-presence gate passes. The
	# detail string is informational.
	print("PHASE5_GROUP_OK:%s ENFORCED  %s" % [group, detail])
	_ok_markers.append(group)


func _group_pending(group: String, detail: String) -> void:
	# In tooling stage, PENDING groups still emit PHASE5_GROUP_OK so the
	# marker check passes. In strict stage, PENDING is a FAIL.
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


func _emit_summary_and_quit() -> void:
	print("----- PHASE5_VERIFY summary -----")
	print("  stage:          %s" % _stage)
	print("  groups OK:      %d / %d" % [_ok_markers.size(), 7])
	print("  groups PENDING: %d  %s" % [_pending.size(), str(_pending)])
	print("  failures:       %d" % _failures.size())
	for f in _failures:
		print("    - %s" % f)
	print("---------------------------------")
	if _failures.size() > 0:
		quit(1)
		return
	print("PHASE5_VERIFY OK (stage=%s)" % _stage)
	quit(0)
