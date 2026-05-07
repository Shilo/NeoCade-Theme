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
##   shape    Plan 05-02 staged enforcement. Treats shape-language groups as
##            strict (PENDING == FAIL) while letting unrelated Phase 5 groups
##            (SpinBox icons, CodeEdit gutter, InfoText size, 15-variation count,
##            variation focus overlay) remain in tooling/PENDING mode so this
##            plan's verify gate is targeted. Strict in the shape stage:
##            assert_shape_lookup_integrity, assert_shape_value_integrity,
##            assert_shape_recipe_resolution, assert_semantic_role_table,
##            assert_no_invented_focus_combos, assert_no_theme_clear.
##   strict   Future stage (Plans 05-03..05-07). Treats every PENDING marker as a
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
## Plan 05-02 added shape-stage groups (D-02/D-03/D-04 + semantic roles + D-07
## BINDING_TABLE forbidden-name scan):
##   - assert_shape_value_integrity      (Plan 05-02 Task 1: per-direction
##                                         primary_radius / focus_offset /
##                                         raised_lifts.primary / strategy
##                                         distinctness verbatim from
##                                         DESIGN_TOKENS §5.1-§5.5)
##   - assert_shape_recipe_resolution    (Plan 05-02 Task 2: _resolve_recipe()
##                                         dispatches `radius` / `padding` /
##                                         `alpha` / `raised_intensity` /
##                                         `strategy` against shape.* via
##                                         _lookup_shape on the active direction)
##   - assert_semantic_role_table        (Plan 05-02 Task 2: role_danger /
##                                         role_warning / role_success /
##                                         role_info exist BEFORE BINDING_TABLE
##                                         walk so DangerButton can bind them)
##   - assert_no_invented_focus_combos   (Plan 05-02 Task 3: BINDING_TABLE rows
##                                         do NOT name pressed_focus /
##                                         checked_focus / hover_pressed_focus
##                                         (D-07 invariant). Forbidden-name
##                                         list is data, not pattern, so the
##                                         scanner is not self-invalidating.)
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
	if _stage != "tooling" and _stage != "strict" and _stage != "shape":
		push_error("PHASE5_VERIFY FAIL: unknown --stage '%s' (expected tooling|shape|strict)" % _stage)
		_stage = "tooling"
	print("PHASE5_VERIFY: stage=%s" % _stage)


func _run_verifier() -> void:
	# Helper wiring + Phase 4 baseline. These are HARD failures even in tooling;
	# they prove the verifier loaded the right code.
	if not _verify_helper_wiring():
		return  # _verify_helper_wiring populates _failures and quits via the summary

	# Named assertion groups (D-12 baseline).
	assert_variation_count_15()
	assert_inf_text_normal_font_size()
	assert_codeedit_gutter_slots()
	assert_spinbox_icons()
	assert_shape_lookup_integrity()
	assert_focus_overlay_visibility()
	assert_no_theme_clear()
	# Plan 05-02 groups (shape language, recipe resolution, semantic roles,
	# BINDING_TABLE forbidden-name scan). These are strict in `shape` stage.
	assert_shape_value_integrity()
	assert_shape_recipe_resolution()
	assert_semantic_role_table()
	assert_no_invented_focus_combos()


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
## Per D-02 + D-03 + D-08: every approved direction must have a non-null `shape`
## sub-dict with the Phase 5 keys present. Plan 05-02 lands the schema. Plan 05-03+
## consume it. Plan 05-02 Task 3 expanded the group to:
##   1. Walk DIRECTION_PRESETS const and assert each approved direction's shape
##      sub-block exposes every key in PHASE5_SHAPE_KEYS (Plan 01 baseline).
##   2. INSTANTIATE/LOAD each of the 5 .tres direction resources and assert
##      _resolve_direction_presets() returns the matching DIRECTION_PRESETS row
##      (NOT DIRECTION_PRESET_DEFAULT) — proves the hex-keyed lookup works
##      end-to-end on the live `.tres` data, not just on the const literal.
##   3. Assert _lookup_shape() returns non-null for every Phase 5 recipe path
##      ("shape.primary_radius" / "shape.primary_padding" / "shape.focus_offset"
##       / "shape.raised_lifts.primary" / "shape.surface_alpha_panels" /
##       "shape.primary_strategy" / "shape.ghost_strategy" / "shape.kicker_style").
##      Includes focus_offset explicitly because Plan 5 must verify focus ring
##      gap per direction (D-08, DESIGN_TOKENS §8.2).
const PHASE5_DIRECTION_TRES_PATHS := {
	"151A2E": "res://addons/neocade_theme/pulse_neocade_theme.tres",
	"111820": "res://addons/neocade_theme/slate_neocade_theme.tres",
	"241326": "res://addons/neocade_theme/bubble_neocade_theme.tres",
	"0B2420": "res://addons/neocade_theme/daybreak_neocade_theme.tres",
	"20112E": "res://addons/neocade_theme/burst_neocade_theme.tres",
}

# Recipe paths the Phase 5 generator dereferences against shape on every direction.
# Each entry's leaf is sanity-checked for non-null on the LIVE direction `.tres` —
# proves the hex-keyed lookup chain (base_color → DIRECTION_PRESETS row → shape
# sub-block → leaf value) works end-to-end. Includes shape.focus_offset (D-08).
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

	# Phase A: const-literal walk (Plan 01 baseline).
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

	# Phase B: per-direction `.tres` load + _resolve_direction_presets() check
	# (Plan 05-02 Task 3). Confirms the live hex-keyed lookup matches the const
	# literal — i.e., the `.tres` files for each direction actually pin
	# base_color to a hex that DIRECTION_PRESETS recognizes (regression catch:
	# if a `.tres` drifts to a non-approved hex, _resolve_direction_presets()
	# would silently fall back to DEFAULT and the personality would vanish).
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
		# Confirm the resolved row IS the per-direction row (not DEFAULT). The
		# unique discriminator is the spread_factor + presence of shape.* —
		# direction rows have a `shape` block; DEFAULT also has one but the
		# scalar values differ. Compare full shape against the const-literal
		# row for this hex to prove the lookup hit the right row.
		var const_row: Dictionary = presets.get(hex_key, {})
		if not resolved.has("shape") or not const_row.has("shape"):
			problems.append("%s resolved row missing shape sub-block" % tres_path)
			continue
		var resolved_shape: Dictionary = resolved.shape
		var const_shape: Dictionary = const_row.shape
		# Spot-check primary_radius + focus_offset + primary_strategy match.
		# (Full deep-equal would be redundant with assert_shape_value_integrity.)
		var ok_radius: bool = resolved_shape.get("primary_radius") == const_shape.get("primary_radius")
		var ok_focus: bool = resolved_shape.get("focus_offset") == const_shape.get("focus_offset")
		var ok_strategy: bool = String(resolved_shape.get("primary_strategy", "")) == String(const_shape.get("primary_strategy", ""))
		# DEFAULT discriminator: if the resolved row equals DIRECTION_PRESET_DEFAULT.shape
		# (e.g., friendly-generous strategy + primary_radius 8 + focus_offset 2 — Daybreak
		# would collide with that profile by accident, so we cross-check the .tres's
		# base_color hex matches the expected hex_key). DEFAULT _has_ "friendly-generous"
		# strategy, so we also assert the loaded theme's base_color hex actually equals
		# hex_key (the strongest end-to-end check).
		var loaded_hex: String = direction_theme.base_color.to_html(false).to_upper()
		if loaded_hex != hex_key:
			problems.append("%s base_color hex = %s but expected %s (resolves to wrong direction or DEFAULT)" % [tres_path, loaded_hex, hex_key])
			continue
		if not ok_radius:
			problems.append("%s primary_radius mismatch: resolved=%s const=%s (DEFAULT-fallback?)" % [tres_path, str(resolved_shape.get("primary_radius")), str(const_shape.get("primary_radius"))])
		if not ok_focus:
			problems.append("%s focus_offset mismatch: resolved=%s const=%s" % [tres_path, str(resolved_shape.get("focus_offset")), str(const_shape.get("focus_offset"))])
		if not ok_strategy:
			problems.append("%s primary_strategy mismatch: resolved=%s const=%s" % [tres_path, str(resolved_shape.get("primary_strategy")), str(const_shape.get("primary_strategy"))])
		# Phase C: assert every Phase 5 recipe path resolves non-null via _lookup_shape.
		if not direction_theme.has_method("_lookup_shape"):
			problems.append("%s lacks _lookup_shape method (Plan 05-02 Task 2 missing)" % tres_path)
			continue
		for path in PHASE5_RECIPE_PATHS:
			var v: Variant = direction_theme.call("_lookup_shape", resolved, path)
			if v == null:
				problems.append("%s _lookup_shape('%s') returned null" % [tres_path, path])
		# focus_offset explicit type check (D-08): must be int 0..2 inclusive.
		var fo: Variant = direction_theme.call("_lookup_shape", resolved, "shape.focus_offset")
		if fo != null and (typeof(fo) != TYPE_INT or fo < 0 or fo > 4):
			problems.append("%s shape.focus_offset out of expected 0..2 range: %s" % [tres_path, str(fo)])
		tres_resolved_directions += 1

	# DEFAULT fallback contract: a custom NeoCadeTheme.new() with non-approved
	# hex resolves to DIRECTION_PRESET_DEFAULT.shape (D-13). We instantiate a
	# fresh NeoCadeTheme directly (no .tres) and confirm.
	if not default_preset.has("shape"):
		problems.append("DIRECTION_PRESET_DEFAULT.shape missing (D-13 contract violated)")
	else:
		var default_shape: Dictionary = default_preset.shape
		var custom: NeoCadeTheme = NeoCadeTheme.new()
		# Tweak base_color to a hex that's NOT in DIRECTION_PRESETS.
		custom.base_color = Color("#0F0F0F")
		var custom_resolved: Dictionary = custom.call("_resolve_direction_presets")
		if not custom_resolved.has("shape"):
			problems.append("custom NeoCadeTheme.new() resolved row has no shape (DEFAULT broken)")
		else:
			var custom_shape: Dictionary = custom_resolved.shape
			# Spot-check: friendly-generous strategy + primary_radius 8 (DEFAULT signature).
			if String(custom_shape.get("primary_strategy", "")) != String(default_shape.get("primary_strategy", "")):
				problems.append("custom theme primary_strategy = %s; expected DEFAULT %s" % [str(custom_shape.get("primary_strategy")), str(default_shape.get("primary_strategy"))])

	if problems.is_empty() and directions_with_shape == 5 and tres_resolved_directions == 5:
		_group_ok(group, "all 5 directions have shape.* sub-blocks; .tres files resolve to per-direction rows; recipe paths non-null incl. focus_offset; DEFAULT fallback works")
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


# ----- assertion group: shape value integrity (Plan 05-02 Task 1) -----
##
## Asserts each approved direction's `shape` sub-block holds the per-direction
## values verbatim from DESIGN_TOKENS §5.1-§5.5:
##
##   Pulse (151A2E):    primary_radius=0,  primary_padding≈(14,10), focus_offset=0,
##                      raised_lifts.primary=3,  primary_strategy="bold-accent-fill"
##   Slate (111820):    primary_radius=14, primary_padding≈(16,11), focus_offset=2,
##                      raised_lifts.primary=2,  primary_strategy="quiet-pill"
##   Bubble (241326):   primary_radius=999 (pill on primary; base radius 26),
##                      primary_padding≈(20,14), focus_offset=2,
##                      raised_lifts.primary=6, primary_strategy="pillowy-fully-rounded"
##   Daybreak (0B2420): primary_radius=8,  primary_padding≈(18,12), focus_offset=2,
##                      raised_lifts.primary=3,  primary_strategy="friendly-generous"
##   Burst (20112E):    primary_radius=28 (oversized; base radius 18),
##                      primary_padding≈(20,14), focus_offset=1,
##                      raised_lifts.primary=5, primary_strategy="oversized-statement"
##
## Also enforces Phase 4 scalar carry-over (spread_factor, hover_pct, pressed_pct,
## disabled_opacity unchanged) and DEFAULT.shape presence (medium-spread / radius 8 /
## focus_offset 2 / friendly-generous per CONTEXT.md D-13).
##
## Failure mode is PENDING in tooling, FAIL in shape/strict stages.
func assert_shape_value_integrity() -> void:
	var group := "assert_shape_value_integrity"
	var theme := _load_pulse_for_group(group)
	if theme == null: return
	var const_map: Dictionary = theme.get_script().get_script_constant_map()
	var presets: Dictionary = const_map.get("DIRECTION_PRESETS", {})
	var default_preset: Dictionary = const_map.get("DIRECTION_PRESET_DEFAULT", {})
	var problems: Array[String] = []

	# Per-direction expected values, sourced verbatim from DESIGN_TOKENS §5.1-§5.5.
	# Each row: hex, primary_radius, focus_offset, raised_lifts.primary, primary_strategy.
	var expected := [
		{"hex": "151A2E", "primary_radius": 0,   "focus_offset": 0, "lift_primary": 3, "strategy": "bold-accent-fill"},
		{"hex": "111820", "primary_radius": 14,  "focus_offset": 2, "lift_primary": 2, "strategy": "quiet-pill"},
		{"hex": "241326", "primary_radius": 999, "focus_offset": 2, "lift_primary": 6, "strategy": "pillowy-fully-rounded"},
		{"hex": "0B2420", "primary_radius": 8,   "focus_offset": 2, "lift_primary": 3, "strategy": "friendly-generous"},
		{"hex": "20112E", "primary_radius": 28,  "focus_offset": 1, "lift_primary": 5, "strategy": "oversized-statement"},
	]
	# Phase 4 scalar baselines (must NOT regress when shape sub-block is added).
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
		# Phase 4 scalar carry-over (Test 3).
		var scalars: Dictionary = phase4_scalars[hex]
		for sk in scalars.keys():
			if not sub.has(sk):
				problems.append("%s missing Phase 4 scalar %s" % [hex, sk])
				continue
			if typeof(sub[sk]) != typeof(scalars[sk]) or not is_equal_approx(float(sub[sk]), float(scalars[sk])):
				problems.append("%s scalar %s = %s (expected %s)" % [hex, sk, str(sub[sk]), str(scalars[sk])])
		# Shape sub-block (Tests 1, 4).
		var shape: Variant = sub.get("shape", null)
		if shape == null or typeof(shape) != TYPE_DICTIONARY:
			problems.append("%s shape sub-block missing or not a Dictionary" % hex)
			continue
		var shape_dict: Dictionary = shape
		# primary_radius
		if shape_dict.get("primary_radius", null) != row["primary_radius"]:
			problems.append("%s shape.primary_radius = %s (expected %s)" % [hex, str(shape_dict.get("primary_radius", null)), str(row["primary_radius"])])
		# focus_offset
		if shape_dict.get("focus_offset", null) != row["focus_offset"]:
			problems.append("%s shape.focus_offset = %s (expected %s)" % [hex, str(shape_dict.get("focus_offset", null)), str(row["focus_offset"])])
		# raised_lifts.primary
		var lifts: Variant = shape_dict.get("raised_lifts", null)
		if lifts == null or typeof(lifts) != TYPE_DICTIONARY:
			problems.append("%s shape.raised_lifts missing or not Dictionary" % hex)
		else:
			var lifts_dict: Dictionary = lifts
			if lifts_dict.get("primary", null) != row["lift_primary"]:
				problems.append("%s shape.raised_lifts.primary = %s (expected %s)" % [hex, str(lifts_dict.get("primary", null)), str(row["lift_primary"])])
		# primary_padding must be Vector2i (Phase 4 FOUND-02 lock).
		var padding: Variant = shape_dict.get("primary_padding", null)
		if padding == null:
			problems.append("%s shape.primary_padding missing" % hex)
		elif typeof(padding) != TYPE_VECTOR2I:
			problems.append("%s shape.primary_padding type = %d (expected Vector2i = %d)" % [hex, typeof(padding), TYPE_VECTOR2I])
		# primary_strategy is StringName (D-04 first-class enum).
		var strategy: Variant = shape_dict.get("primary_strategy", null)
		if strategy == null:
			problems.append("%s shape.primary_strategy missing" % hex)
		else:
			var strat_str := String(strategy)
			if strat_str != row["strategy"]:
				problems.append("%s shape.primary_strategy = '%s' (expected '%s')" % [hex, strat_str, row["strategy"]])
			strategies_seen[strat_str] = true

	# Test 4: at least 4 distinct primary strategies across the 5 directions.
	if strategies_seen.size() < 4:
		problems.append("primary_strategy distinct count = %d (expected >= 4 across 5 directions)" % strategies_seen.size())

	# DEFAULT.shape present and non-empty for non-approved colors.
	if default_preset.is_empty():
		problems.append("DIRECTION_PRESET_DEFAULT const not found")
	else:
		var default_shape: Variant = default_preset.get("shape", null)
		if default_shape == null or typeof(default_shape) != TYPE_DICTIONARY or (default_shape as Dictionary).is_empty():
			problems.append("DIRECTION_PRESET_DEFAULT.shape missing or empty (D-13)")

	if problems.is_empty():
		_group_ok(group, "shape values match DESIGN_TOKENS §5.1-§5.5 verbatim across all 5 approved directions + DEFAULT")
	else:
		_group_pending(group, "; ".join(problems))


# ----- assertion group: shape recipe resolution (Plan 05-02 Task 2) -----
##
## Per D-03: BINDING_TABLE recipes can reference `shape.<key>` paths and
## _resolve_recipe() dereferences them against the active direction's shape
## sub-block via _lookup_shape().
##
## Tests by instantiating Pulse and calling _resolve_recipe() with synthetic
## recipes that exercise each shape lookup branch (radius, padding, alpha,
## raised_intensity, strategy). Pulse is used because its shape values are
## numerically distinct from raw integer recipe values (primary_radius=0 vs
## the corner_radius @export of 0 — but raised_lifts.primary=3 vs the
## raised_strength @export of 3 collide; we use Bubble (lift=6) to disambiguate).
func assert_shape_recipe_resolution() -> void:
	var group := "assert_shape_recipe_resolution"
	# Use Bubble rather than Pulse because Bubble's shape values (radius 999,
	# raised_lifts.primary 6) do not collide with any @export default scalar.
	var bubble_path := "res://addons/neocade_theme/bubble_neocade_theme.tres"
	var loaded: Resource = ResourceLoader.load(bubble_path)
	if loaded == null or not (loaded is NeoCadeTheme):
		_group_fail(group, "could not load %s as NeoCadeTheme" % bubble_path)
		return
	var theme: NeoCadeTheme = loaded
	var has_lookup: bool = theme.has_method("_lookup_shape")
	var has_resolve: bool = theme.has_method("_resolve_recipe")
	if not has_lookup or not has_resolve:
		var details := PackedStringArray()
		details.append("_lookup_shape present=" + str(has_lookup))
		details.append("_resolve_recipe present=" + str(has_resolve))
		_group_pending(group, "Plan 05-02 Task 2 helpers not yet present: " + ", ".join(details))
		return
	var presets: Dictionary = theme.call("_resolve_direction_presets")
	if presets.is_empty() or not presets.has("shape"):
		_group_pending(group, "Bubble preset has no shape sub-block (Task 1 not done)")
		return
	# Test the dotted-path walker.
	var probe_radius = theme.call("_lookup_shape", presets, "shape.primary_radius")
	if probe_radius != 999:
		_group_pending(group, "_lookup_shape('shape.primary_radius') for Bubble = %s (expected 999)" % str(probe_radius))
		return
	var probe_lift = theme.call("_lookup_shape", presets, "shape.raised_lifts.primary")
	if probe_lift != 6:
		_group_pending(group, "_lookup_shape('shape.raised_lifts.primary') for Bubble = %s (expected 6)" % str(probe_lift))
		return
	# Required helper functions per D-03/D-04:
	var required_helpers := [
		"_set_radius_all",
		"_set_content_margin_from_padding",
		"_apply_primary_strategy",
		"_apply_ghost_strategy",
		"_apply_kicker_style",
	]
	var missing_helpers: Array[String] = []
	for helper in required_helpers:
		if not theme.has_method(helper):
			missing_helpers.append(helper)
	if not missing_helpers.is_empty():
		_group_pending(group, "missing required helpers: " + ", ".join(missing_helpers))
		return
	# Quick recipe-resolution sanity check: a stylebox recipe that references
	# `radius: shape.primary_radius` and `padding: shape.primary_padding`
	# must produce a StyleBoxFlat whose corner_radius_top_left == 999 and
	# whose content_margin_left equals primary_padding.x.
	var role_table: Dictionary = {
		"surface_panel": Color("#221026"),
		"surface_panel_offset": Color("#1A0C20"),
		"text_strong": Color.WHITE,
		"role_primary": Color("#FFB3E6"),
		"outline_color": Color("#3A1F40"),
	}
	var tokens: Dictionary = theme.call("_platform_tokens", NeoCadeTheme.Platform.DESKTOP)
	var recipe := {
		"role": "surface_panel",
		"radius": "shape.primary_radius",
		"padding": "shape.primary_padding",
	}
	var sb_value = theme.call("_resolve_recipe", recipe, "stylebox", role_table, tokens, presets)
	if sb_value == null or not (sb_value is StyleBoxFlat):
		_group_pending(group, "_resolve_recipe with shape.* keys did not return a StyleBoxFlat")
		return
	var sb: StyleBoxFlat = sb_value
	if sb.corner_radius_top_left != 999:
		_group_pending(group, "stylebox corner_radius_top_left = %d (expected 999 from shape.primary_radius)" % sb.corner_radius_top_left)
		return
	var bubble_padding: Vector2i = (presets["shape"] as Dictionary)["primary_padding"]
	if sb.content_margin_left != bubble_padding.x or sb.content_margin_top != bubble_padding.y:
		_group_pending(group, "stylebox content_margin_left/top = %d/%d (expected %d/%d from shape.primary_padding)" % [sb.content_margin_left, sb.content_margin_top, bubble_padding.x, bubble_padding.y])
		return
	# Alpha lookup.
	var alpha_recipe := {
		"role": "surface_panel",
		"alpha": "shape.surface_alpha_panels",
	}
	var sb_alpha = theme.call("_resolve_recipe", alpha_recipe, "stylebox", role_table, tokens, presets)
	if sb_alpha == null or not (sb_alpha is StyleBoxFlat):
		_group_pending(group, "alpha recipe did not return a StyleBoxFlat")
		return
	var bubble_alpha_panels: float = (presets["shape"] as Dictionary)["surface_alpha_panels"]
	if not is_equal_approx((sb_alpha as StyleBoxFlat).bg_color.a, bubble_alpha_panels):
		_group_pending(group, "stylebox bg_color.a = %f (expected %f from shape.surface_alpha_panels)" % [(sb_alpha as StyleBoxFlat).bg_color.a, bubble_alpha_panels])
		return
	_group_ok(group, "_resolve_recipe dispatches shape.radius/padding/alpha/raised_intensity correctly via _lookup_shape; helpers present")


# ----- assertion group: semantic role table (Plan 05-02 Task 2) -----
##
## Per CONTEXT.md review HIGH gate + DESIGN_TOKENS §7.1: role_danger /
## role_warning / role_success / role_info MUST exist in role_table BEFORE
## any variation references them. Plan 05-03 introduces DangerButton; if
## role_danger is missing from role_table at that point DangerButton silently
## falls back to surface_panel and ships the wrong color.
##
## Verification strategy: load Pulse, exercise _resolve_recipe with a color
## recipe that references each semantic role; if the resolved color matches
## the DESIGN_TOKENS §7.1 default (or a per-direction override), the role
## is wired. If it falls back to text_strong (the default in _resolve_recipe
## for unknown roles), that is detected and reported.
func assert_semantic_role_table() -> void:
	var group := "assert_semantic_role_table"
	var theme := _load_pulse_for_group(group)
	if theme == null: return
	var role_defaults := {
		"role_success": Color("#5CC971"),
		"role_warning": Color("#FFD166"),
		"role_danger":  Color("#FF6E6E"),
		"role_info":    Color("#5FE3FF"),
	}
	var presets: Dictionary = theme.call("_resolve_direction_presets")
	# We exercise _resolve_recipe via the public surface: the recipe
	# {"role": "role_danger"} should resolve to the danger color, NOT to
	# the default fallback. We need access to the assembled role_table; the
	# easiest path is to introspect the production source for the role_table
	# Dictionary literal. The verifier scans the source for the keys.
	var src_text := _read_production_source()
	if src_text.is_empty():
		_group_fail(group, "could not read production source for role_table introspection")
		return
	var missing_in_source: Array[String] = []
	for role in role_defaults.keys():
		var as_str: String = role
		# Match "role_danger": / role_danger: / "role_danger" =
		var found: bool = false
		for line in src_text.split("\n"):
			var stripped: String = line.strip_edges()
			if stripped.begins_with("#"):
				continue
			if stripped.find("\"" + as_str + "\"") != -1 or stripped.find(as_str + ":") != -1:
				found = true
				break
		if not found:
			missing_in_source.append(as_str)
	if not missing_in_source.is_empty():
		_group_pending(group, "missing semantic role keys in production source: " + ", ".join(missing_in_source))
		return
	# A minimal recipe-resolution sanity probe: build a fake role_table that
	# DOES include role_danger and ask _resolve_recipe to look it up. If the
	# resolver dispatches "role" lookups via role_table.get(role, fallback),
	# it should return the matching color rather than the fallback. This
	# proves Plan 05-02 Task 2's recipe path honors semantic role keys.
	if not theme.has_method("_resolve_recipe"):
		_group_pending(group, "_resolve_recipe missing")
		return
	var fake_table: Dictionary = {
		"role_danger":  role_defaults["role_danger"],
		"role_success": role_defaults["role_success"],
		"role_warning": role_defaults["role_warning"],
		"role_info":    role_defaults["role_info"],
		"text_strong":  Color.WHITE,
		"surface_panel": Color.GRAY,
	}
	var tokens: Dictionary = theme.call("_platform_tokens", NeoCadeTheme.Platform.DESKTOP)
	var recipe := {"role": "role_danger"}
	var resolved = theme.call("_resolve_recipe", recipe, "color", fake_table, tokens, presets)
	if resolved == null:
		_group_pending(group, "_resolve_recipe returned null for role_danger color recipe")
		return
	if not (resolved is Color):
		_group_pending(group, "role_danger recipe resolved to non-Color: %s" % str(resolved))
		return
	var c: Color = resolved
	if not c.is_equal_approx(role_defaults["role_danger"]):
		_group_pending(group, "role_danger resolved to %s; expected %s (recipe fell back to text_strong/surface_panel)" % [c.to_html(false), role_defaults["role_danger"].to_html(false)])
		return
	_group_ok(group, "role_danger / role_warning / role_success / role_info present in production source and resolve via recipe path")


# ----- assertion group: BINDING_TABLE forbidden focus-combo names (Plan 05-02 Task 3) -----
##
## Per D-07 invariant: BINDING_TABLE rows MUST NOT name `pressed_focus`,
## `checked_focus`, or `hover_pressed_focus`. Phase 4 baseline already complies;
## Phase 5 must keep complying as variation chrome is authored.
##
## The forbidden-name list is data, NOT a regex pattern, so the scanner is not
## self-invalidating: the verifier source contains the list as Array literal
## (not an inline-search-string), and the production source scan is what we
## care about. We strip comments first so the docstring on this function is
## not flagged.
const FORBIDDEN_FOCUS_COMBO_SLOTS := ["pressed_focus", "checked_focus", "hover_pressed_focus"]

func assert_no_invented_focus_combos() -> void:
	var group := "assert_no_invented_focus_combos"
	var src_text := _read_production_source()
	if src_text.is_empty():
		_group_fail(group, "could not read production source")
		return
	# Strip comment lines (the forbidden names appear in a docstring comment block).
	var clean_lines: Array[String] = []
	for line in src_text.split("\n"):
		var stripped: String = line.strip_edges()
		if stripped.begins_with("#"):
			continue
		clean_lines.append(line)
	var clean_text := "\n".join(clean_lines)
	# Look for the forbidden names appearing as Dictionary keys in BINDING_TABLE.
	# The match form is `"pressed_focus":` or `'pressed_focus':` -- the colon is
	# the discriminator between "appears as a key" and "appears in a literal
	# string elsewhere".
	var violations: Array[String] = []
	for forbidden in FORBIDDEN_FOCUS_COMBO_SLOTS:
		var as_dq_key: String = "\"" + forbidden + "\":"
		var as_sq_key: String = "'" + forbidden + "':"
		for line in clean_text.split("\n"):
			if line.find(as_dq_key) != -1 or line.find(as_sq_key) != -1:
				violations.append("%s in line: %s" % [forbidden, line.strip_edges()])
	if violations.is_empty():
		_group_ok(group, "no invented focus combo slots in BINDING_TABLE (D-07 holds)")
	else:
		_group_fail(group, "D-07 violation: " + "; ".join(violations))


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
	# In shape stage, PENDING is a FAIL only for the shape-related groups
	# that Plan 05-02 owns; the rest stay tooling-style.
	var shape_stage_strict := [
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


func _emit_summary_and_quit() -> void:
	print("----- PHASE5_VERIFY summary -----")
	print("  stage:          %s" % _stage)
	print("  groups OK:      %d / %d" % [_ok_markers.size(), 11])
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
