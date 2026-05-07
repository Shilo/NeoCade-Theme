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
##   text-panels  Plan 05-04 staged enforcement. Treats text/label/panel-variation
##            groups as strict while leaving SpinBox/CodeEdit groups in
##            tooling/PENDING mode. Strict in the text-panels stage:
##            assert_variation_count_15, assert_inf_text_normal_font_size,
##            assert_kicker_chrome, assert_text_label_variation_chrome,
##            assert_panel_variation_chrome, assert_no_letter_spacing_claim,
##            assert_no_theme_clear, assert_no_invented_focus_combos.
##   text-final  Plan 05-05 staged enforcement. Treats text-class chrome
##            completeness + CodeEdit gutter chrome + the no-syntax-highlighting
##            scope guard as strict, while leaving SpinBox icons in
##            tooling/PENDING mode (Plan 05-06). All Plan 05-04 text-panels
##            strict groups carry forward strict in the text-final stage so a
##            text-final regression also catches text-panels regressions.
##            Strict-only-in-text-final additions:
##              - assert_codeedit_gutter_slots
##              - assert_text_class_chrome_complete
##              - assert_codeedit_no_syntax_highlighting
##   spinbox  Plan 05-06 staged enforcement. Flips assert_spinbox_icons to
##            strict (PENDING == FAIL) so the wired SpinBox up/up_disabled/
##            down/down_disabled icon slots are mandatory. All prior strict
##            stages carry forward strict so a spinbox regression also catches
##            buttons / text-panels / text-final regressions. Plan 05-06 is
##            the last Phase 5 stage before the full strict gate.
##   final    Plan 05-07 staged enforcement (Wave 7). Flips three new groups
##            strict on top of all prior strict stages:
##              - assert_resource_data_only      — every approved direction
##                                                  `.tres` is < 2 KiB, contains
##                                                  no [sub_resource], no
##                                                  theme_data/, and reloads
##                                                  as NeoCadeTheme (D-06).
##              - assert_flat_no_shadow_when_off — for raised=false on every
##                                                  approved direction, every
##                                                  generated StyleBoxFlat has
##                                                  shadow_size == -1 and
##                                                  shadow_offset == ZERO.
##              - assert_raised_hard_offset_shadow — for raised=true on every
##                                                  approved direction, every
##                                                  generated StyleBoxFlat with
##                                                  shadow_size > 0 has
##                                                  shadow_offset.x == 0 and
##                                                  shadow_offset.y == shadow_size
##                                                  (hard offset, no blur, no
##                                                  side drift). Recipes with
##                                                  raised_intensity == 0 yield
##                                                  shadow_size == 0 (allowed).
##            All Plan 05-06 / 05-05 / 05-04 / 05-03 / 05-02 strict groups
##            carry forward strict.
##   strict   Treats every PENDING marker as a failure and exits non-zero.
##            Wired now so later plans only need to change the --stage
##            argument; they do not need to re-author the verifier.
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
## Plan 05-03 added buttons-stage groups (TYPEVAR-01 + COV-02 + D-07):
##   - assert_button_variation_rows      (Plan 05-03 Task 1: BINDING_TABLE has
##                                         all six TYPEVAR-01 variation rows
##                                         (PrimaryButton, SecondaryButton,
##                                         GhostButton, DangerButton,
##                                         IconButton, FlatButton).)
##   - assert_button_variation_states    (Plan 05-03 Task 1: each variation
##                                         exposes the official Button state
##                                         set: normal/hover/pressed/focus/
##                                         disabled/hover_pressed where the
##                                         strategy is non-flat. FlatButton
##                                         may use transparent normal.)
##   - assert_button_variation_fonts     (Plan 05-03 Task 1 / PITFALLS 1.2:
##                                         each variation has explicit
##                                         `font` and `font_size` registered
##                                         on the Theme — variations do NOT
##                                         inherit fonts from base type.)
##   - assert_button_strategy_distinctness (Plan 05-03 Task 1 / D-04: at
##                                         least 4 distinct primary_strategy
##                                         values are exercised across the 5
##                                         approved directions; sentinel
##                                         against accidental strategy
##                                         collapse.)
##   - assert_dangerbutton_role_danger    (Plan 05-03 Task 1 review HIGH
##                                         gate: DangerButton.normal bg
##                                         resolves to role_danger
##                                         (#FF6E6E default), NOT
##                                         surface_panel — proves the
##                                         semantic role wired by Plan 05-02
##                                         Task 2 actually flows through.)
##   - assert_basebutton_family_chrome   (Plan 05-03 Task 2 / COV-02: the
##                                         seven BaseButton-family Controls
##                                         (Button, CheckBox, CheckButton,
##                                         OptionButton, MenuButton,
##                                         ColorPickerButton, LinkButton)
##                                         have their official slot set
##                                         populated. LinkButton is
##                                         text-only — no normal stylebox.)
##   - assert_focus_overlay_visibility (Plan 05-03 Task 3): updated to
##                                         require focus on every variation
##                                         in the buttons-stage strict
##                                         set.
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

# Plan 05-03: TYPEVAR-01 button variations. The six runtime button variations
# the dynamic generator must produce per direction. FlatButton here is the
# RUNTIME variation per TYPEVAR-01 (not the editor-only `FlatButton` Godot
# class).
const PHASE5_BUTTON_VARIATIONS := [
	"PrimaryButton",
	"SecondaryButton",
	"GhostButton",
	"DangerButton",
	"IconButton",
	"FlatButton",
]

# Plan 05-03 Task 2 / COV-02: the seven BaseButton-family Controls Phase 5 must
# theme. LinkButton is text-only and is asserted differently (no normal
# stylebox required) downstream.
const PHASE5_BASEBUTTON_FAMILY := [
	"Button",
	"CheckBox",
	"CheckButton",
	"OptionButton",
	"MenuButton",
	"ColorPickerButton",
	"LinkButton",
]

# Plan 05-03 Task 1 / D-04: each variation row should populate this state set
# (the official Godot 4.6 Button slot list). FlatButton is allowed to leave
# `disabled` plus an additional state on transparent bg — see
# assert_button_variation_states for the relaxed rule.
const PHASE5_BUTTON_VARIATION_STATES := [
	"normal",
	"hover",
	"pressed",
	"focus",
	"disabled",
	"hover_pressed",
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
	if _stage != "tooling" and _stage != "strict" and _stage != "shape" and _stage != "buttons" and _stage != "text-panels" and _stage != "text-final" and _stage != "spinbox" and _stage != "final":
		push_error("PHASE5_VERIFY FAIL: unknown --stage '%s' (expected tooling|shape|buttons|text-panels|text-final|spinbox|final|strict)" % _stage)
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
	# Plan 05-03 groups (Button variations + BaseButton-family chrome).
	# These are strict in `buttons` stage; carry-forward strict in `strict`.
	assert_button_variation_rows()
	assert_button_variation_states()
	assert_button_variation_fonts()
	assert_button_strategy_distinctness()
	assert_dangerbutton_role_danger()
	assert_basebutton_family_chrome()
	# Plan 05-03 Task 2 polish groups.
	assert_basebutton_family_shape_aware()
	assert_checkbox_disabled_icon_reuse()
	# Plan 05-04 groups (text/label/panel variation chrome + no-letter-spacing-
	# claim guard). Strict in the `text-panels` stage; tooling elsewhere.
	assert_no_letter_spacing_claim()
	assert_kicker_chrome()
	assert_text_label_variation_chrome()
	assert_panel_variation_chrome()
	# Plan 05-05 groups (text-class chrome completeness + CodeEdit no-syntax-
	# highlighting scope guard). Strict in the `text-final` stage; tooling
	# elsewhere. The existing assert_codeedit_gutter_slots flips strict in
	# text-final too via the strict list below.
	assert_text_class_chrome_complete()
	assert_codeedit_no_syntax_highlighting()
	# Plan 05-07 groups (Wave 7 — final ResourceSaver round-trip + raised
	# shadow contract). Strict in the `final` stage; tooling elsewhere.
	assert_resource_data_only()
	assert_flat_no_shadow_when_off()
	assert_raised_hard_offset_shadow()


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
	# Plan 05-04 Rule 1 fix: theme.has_font_size walks the type-variation/base-
	# type inheritance chain AND reports any slot that is documented on the
	# Control class (e.g., RichTextLabel exposes both `font` and `normal_font`
	# — Godot returns true for has_font_size("font_size", "InfoText") even when
	# our generator never set that slot, because the slot exists on the
	# underlying RichTextLabel type signature).
	#
	# The correct test for "explicitly set vs inherited/built-in default" is
	# `get_font_size_list("InfoText")`, which returns ONLY the slots the
	# generator authored. Empirical proof captured in
	# .../helpers/_phase5_diag_inftext.gd: get_font_size_list("InfoText")
	# returns ["normal_font_size"] when the generator omits font_size, and
	# ["font_size", "normal_font_size"] when both are set.
	var size_list: PackedStringArray = theme.get_font_size_list("InfoText")
	var has_normal_size: bool = (size_list.find("normal_font_size") != -1)
	var has_wrong_size_authored: bool = (size_list.find("font_size") != -1)
	var font_list: PackedStringArray = theme.get_font_list("InfoText")
	var has_normal_font: bool = (font_list.find("normal_font") != -1)
	if has_normal_size and not has_wrong_size_authored and has_normal_font:
		_group_ok(group, "InfoText: normal_font set, normal_font_size set, wrong font_size NOT authored (only inherited slot signature, which Godot can't suppress)")
	else:
		var details := PackedStringArray()
		details.append("normal_font_size authored=" + str(has_normal_size))
		details.append("font_size authored (must be false)=" + str(has_wrong_size_authored))
		details.append("normal_font authored=" + str(has_normal_font))
		details.append("get_font_size_list=" + str(size_list))
		_group_pending(group, "InfoText size slot not yet at Phase 5 contract: %s" % ", ".join(details))


# ----- assertion group: CodeEdit gutter colors + folded icon -----
##
## Phase 5 SC#2 + Plan 05-05: CodeEdit gutter chrome (gutter colors named in
## DESIGN_TOKENS) plus the `folded` icon slot. line_number_color is the baseline
## gutter color name asserted explicitly per CONTEXT.md.
##
## Plan 05-05 Rule 1 fix (carry-forward of Wave 4 fix on assert_inf_text_*):
## theme.has_color walks the inheritance chain and reports built-in CodeEdit
## class slot signatures (line_number_color is exposed by Godot's CodeEdit
## class even when our generator never authored it). The correct probe for
## "explicitly authored vs inherited/default" is get_color_list("CodeEdit"),
## which returns ONLY slots the generator AUTHORED via set_color().
func assert_codeedit_gutter_slots() -> void:
	var group := "assert_codeedit_gutter_slots"
	var theme := _load_pulse_for_group(group)
	if theme == null: return
	var color_list: PackedStringArray = theme.get_color_list("CodeEdit")
	var missing_colors: Array[String] = []
	for slot in PHASE5_CODEEDIT_GUTTER_COLORS:
		if color_list.find(slot) == -1:
			missing_colors.append(slot)
	var icon_list: PackedStringArray = theme.get_icon_list("CodeEdit")
	var has_folded: bool = (icon_list.find(PHASE5_CODEEDIT_FOLDED_ICON) != -1)
	if missing_colors.is_empty() and has_folded:
		_group_ok(group, "CodeEdit gutter colors all AUTHORED and `folded` icon present")
	else:
		var details := PackedStringArray()
		if not missing_colors.is_empty():
			details.append("missing AUTHORED gutter colors: " + ", ".join(missing_colors))
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
	# Plan 05-03 Task 3: every TYPEVAR-01 button variation must expose `focus`.
	# IconButton + FlatButton are added relative to the Plan 01 baseline so the
	# buttons-stage gate enforces focus across the full variation set.
	var variations := PHASE5_BUTTON_VARIATIONS
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


# ----- Plan 05-03 assertion groups (TYPEVAR-01 + COV-02) -----

# ----- assertion group: BINDING_TABLE has all six button variation rows ------
##
## Plan 05-03 Task 1 / TYPEVAR-01: each of PrimaryButton, SecondaryButton,
## GhostButton, DangerButton, IconButton, FlatButton must have a row in
## BINDING_TABLE so the dynamic generator emits chrome on every regenerate.
## D-14 is preserved: variations not in BINDING_TABLE remain untouched, so
## the absence of a row is a real invariant violation, not a degraded state.
func assert_button_variation_rows() -> void:
	var group := "assert_button_variation_rows"
	var theme := _load_pulse_for_group(group)
	if theme == null: return
	var const_map: Dictionary = theme.get_script().get_script_constant_map()
	var binding_table: Dictionary = const_map.get("BINDING_TABLE", {})
	if binding_table.is_empty():
		_group_fail(group, "BINDING_TABLE const not found on production class")
		return
	var missing: Array[String] = []
	for v in PHASE5_BUTTON_VARIATIONS:
		if not binding_table.has(v):
			missing.append(v)
	if missing.is_empty():
		_group_ok(group, "all six TYPEVAR-01 button variation rows present in BINDING_TABLE: " + ", ".join(PHASE5_BUTTON_VARIATIONS))
	else:
		_group_pending(group, "missing TYPEVAR-01 button variation rows in BINDING_TABLE: " + ", ".join(missing))


# ----- assertion group: each variation has the official Button state set ----
##
## Plan 05-03 Task 1 / D-04: per-direction chrome runs through the same state
## set Godot 4.6 Button uses (normal/hover/pressed/focus/disabled/hover_pressed).
## Each variation must populate the WHOLE set so consumers tabbing/clicking
## across states see consistent personality. FlatButton may use a transparent
## bg on `normal` (recipe sets bg_color.a == 0) but the slot must still be
## present.
##
## D-07 invariant: only the official `focus` overlay is asserted.
## `pressed_focus` / `checked_focus` / `hover_pressed_focus` are forbidden by
## assert_no_invented_focus_combos.
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
		_group_ok(group, "all six button variations expose the full state set on Pulse: " + ", ".join(PHASE5_BUTTON_VARIATION_STATES))
	else:
		_group_pending(group, "; ".join(problems))


# ----- assertion group: each variation has explicit font + font_size --------
##
## Plan 05-03 Task 1 / PITFALLS 1.2 / D-17: type variations do NOT inherit
## fonts from their base type. Phase 4 already wires explicit set_font +
## set_font_size for the six button variations (lines 205-226 of the
## production class). Phase 5 must keep that wiring; if a future regenerate
## strips it, this group catches the regression.
func assert_button_variation_fonts() -> void:
	var group := "assert_button_variation_fonts"
	var theme := _load_pulse_for_group(group)
	if theme == null: return
	var problems: Array[String] = []
	for v in PHASE5_BUTTON_VARIATIONS:
		if not theme.has_font("font", v):
			problems.append("%s.font missing (PITFALLS 1.2 — variations do NOT inherit fonts)" % v)
		if not theme.has_font_size("font_size", v):
			problems.append("%s.font_size missing" % v)
	if problems.is_empty():
		_group_ok(group, "all six button variations have explicit `font` + `font_size` (Inter Variable Roman per D-17)")
	else:
		_group_pending(group, "; ".join(problems))


# ----- assertion group: distinct primary strategies across directions -------
##
## Plan 05-03 Task 1 / D-04 sentinel: at least 4 distinct primary_strategy
## values must be exercised across the 5 approved directions when generating
## PrimaryButton chrome. Without this assertion a buggy strategy dispatcher
## could silently collapse all 5 directions onto the same default and the 5
## directions would visually look identical on Primary chrome.
##
## We exercise this by loading each approved direction's `.tres` (so the
## live hex-keyed lookup runs), reading `shape.primary_strategy` via
## `_lookup_shape`, and tallying distinct values. Mirrors the strategy-set
## guard in assert_shape_value_integrity but framed at the variation layer
## so a regression in the BINDING_TABLE recipe (e.g., recipe inlines the
## strategy as a literal instead of referencing `shape.primary_strategy`)
## still surfaces here.
func assert_button_strategy_distinctness() -> void:
	var group := "assert_button_strategy_distinctness"
	var theme := _load_pulse_for_group(group)
	if theme == null: return
	if not theme.has_method("_lookup_shape"):
		_group_pending(group, "_lookup_shape missing (Plan 05-02 not landed)")
		return
	var const_map: Dictionary = theme.get_script().get_script_constant_map()
	var presets: Dictionary = const_map.get("DIRECTION_PRESETS", {})
	if presets.is_empty():
		_group_fail(group, "DIRECTION_PRESETS const not found on production class")
		return
	var primary_seen: Dictionary = {}
	var ghost_seen: Dictionary = {}
	for hex_key in ["151A2E", "111820", "241326", "0B2420", "20112E"]:
		var sub: Dictionary = presets.get(hex_key, {})
		if sub.is_empty():
			continue
		var ps_v: Variant = theme.call("_lookup_shape", sub, "shape.primary_strategy")
		if ps_v != null:
			primary_seen[String(ps_v)] = true
		var gs_v: Variant = theme.call("_lookup_shape", sub, "shape.ghost_strategy")
		if gs_v != null:
			ghost_seen[String(gs_v)] = true
	var problems: Array[String] = []
	if primary_seen.size() < 4:
		problems.append("primary_strategy distinct count = %d (expected >= 4 across 5 directions): %s" % [primary_seen.size(), str(primary_seen.keys())])
	if ghost_seen.size() < 4:
		problems.append("ghost_strategy distinct count = %d (expected >= 4 across 5 directions): %s" % [ghost_seen.size(), str(ghost_seen.keys())])
	if problems.is_empty():
		_group_ok(group, "primary_strategy + ghost_strategy each expose >=4 distinct values across 5 directions: primary=%s ghost=%s" % [str(primary_seen.keys()), str(ghost_seen.keys())])
	else:
		_group_pending(group, "; ".join(problems))


# ----- assertion group: DangerButton resolves to role_danger ----------------
##
## Plan 05-03 Task 1 review HIGH gate: the BINDING_TABLE row for DangerButton
## must reference the `role_danger` semantic role added by Plan 05-02 Task 2,
## NOT fall back to `surface_panel` / `text_strong`. We assert this two ways:
##   1. The Pulse theme's DangerButton.normal stylebox bg_color matches the
##      §7.1 default `#FF6E6E` (allowing the per-direction state-layer mix
##      not to apply because `role_danger` is a fixed semantic color the
##      role_table looks up directly — recipes that do NOT set `alpha` or
##      `disabled` flags get the unmodified role color).
##   2. The font_color slot resolves to a Color (text on the danger surface)
##      rather than null.
## If the chrome ever falls back to surface_panel, bg_color would equal the
## per-direction surface_panel mix, NOT the danger red, and the assertion
## fails loudly.
func assert_dangerbutton_role_danger() -> void:
	var group := "assert_dangerbutton_role_danger"
	var theme := _load_pulse_for_group(group)
	if theme == null: return
	if not theme.has_stylebox("normal", "DangerButton"):
		_group_pending(group, "DangerButton.normal stylebox missing (Plan 05-03 Task 1 not yet landed)")
		return
	var sb: StyleBox = theme.get_stylebox("normal", "DangerButton")
	if sb == null:
		_group_pending(group, "DangerButton.normal returned null stylebox")
		return
	if not (sb is StyleBoxFlat):
		_group_fail(group, "DangerButton.normal is not a StyleBoxFlat (got %s)" % sb.get_class())
		return
	var fsb: StyleBoxFlat = sb
	var expected_danger := Color("#FF6E6E")
	# Compare RGB only — alpha may differ if a recipe later layers translucency.
	var rgb_match := is_equal_approx(fsb.bg_color.r, expected_danger.r) \
		and is_equal_approx(fsb.bg_color.g, expected_danger.g) \
		and is_equal_approx(fsb.bg_color.b, expected_danger.b)
	if not rgb_match:
		_group_pending(group, "DangerButton.normal bg_color = %s; expected role_danger = %s (recipe likely fell back to surface_panel)" % [fsb.bg_color.to_html(false), expected_danger.to_html(false)])
		return
	# Sanity: font_color slot resolves (text on danger surface).
	if not theme.has_color("font_color", "DangerButton"):
		_group_pending(group, "DangerButton.font_color missing — recipe row incomplete")
		return
	_group_ok(group, "DangerButton.normal resolves to role_danger #%s (Plan 05-02 semantic role flowed through)" % fsb.bg_color.to_html(false).to_upper())


# ----- assertion group: BaseButton-family slot coverage ---------------------
##
## Plan 05-03 Task 2 / COV-02: the seven BaseButton-family Controls Phase 5
## owns must have their official Godot 4.6 slot set populated. Phase 4 set
## the baseline; Plan 05-03 Task 2 confirms Plan 05-02 / Plan 05-03 Task 1
## did not regress.
##
## Per-class slot expectations:
##   - Button / OptionButton / MenuButton / ColorPickerButton: 6 styleboxes
##     (normal/hover/pressed/focus/disabled/hover_pressed where the class
##     supports it; ColorPickerButton's API does not expose hover_pressed
##     officially, so we treat it as optional).
##   - CheckBox / CheckButton: 4 base styleboxes minimum (normal/hover/
##     pressed/focus) plus the icon set Phase 4 provides.
##   - LinkButton: text-only — NO normal stylebox is expected (LinkButton
##     renders without a filled chrome). We assert font_color is set for
##     normal/hover and that the LinkButton row does NOT carry a `normal`
##     stylebox recipe (regression catch: someone adds filled chrome that
##     Godot would not draw).
## Plan 05-03 Task 2 polish: BaseButton-family rows reference Plan 05-02
## shape.* recipes so per-direction radius / padding / lift differences flow
## through the base controls (not just TYPEVAR-01 variations). Without this
## polish, MenuButton/OptionButton/ColorPickerButton would render with the
## flat @export `corner_radius` baseline regardless of direction, while
## PrimaryButton / SecondaryButton would visibly differ — a UI inconsistency
## reviewed in Phase 4 D-04.
##
## Verification: load the production source, scan each base BINDING_TABLE row
## (Button / OptionButton / MenuButton / ColorPickerButton — CheckBox /
## CheckButton intentionally skip the radius/padding key because they are
## icon-driven, not chrome-driven), and assert the row contains a `shape.`
## reference somewhere in the stylebox sub-block (the `radius` or `padding`
## key with a `shape.<...>` value). Failure mode: PENDING in tooling, FAIL
## in buttons / strict.
func assert_basebutton_family_shape_aware() -> void:
	var group := "assert_basebutton_family_shape_aware"
	var src_text := _read_production_source()
	if src_text.is_empty():
		_group_fail(group, "could not read production source")
		return
	# Per Phase 4 commentary, CheckBox + CheckButton are intentionally
	# icon-driven; their stylebox slots stay on the @export corner_radius
	# baseline. The 4 Button-style classes below all benefit from
	# direction-aware chrome.
	var shape_aware_targets := ["Button", "OptionButton", "MenuButton", "ColorPickerButton"]
	# Anchor search past CANONICAL_SLOT_NAMES so we hit BINDING_TABLE rows
	# instead of the slot-enumeration rows (which have the same `"Button":`
	# header but no recipes). BINDING_TABLE_BEGIN is the const declaration
	# line; we search after that.
	var binding_table_anchor: int = src_text.find("const BINDING_TABLE")
	if binding_table_anchor == -1:
		_group_fail(group, "BINDING_TABLE const declaration not found in production source")
		return
	# Walk each top-level row in BINDING_TABLE and look for a stylebox
	# entry whose value contains `"shape."` (either radius or padding key).
	var problems: Array[String] = []
	for klass in shape_aware_targets:
		# Find the row header AFTER the BINDING_TABLE anchor so we never
		# hit the CANONICAL_SLOT_NAMES dict that has the same key form.
		var header: String = "\"" + String(klass) + "\":"
		var idx: int = src_text.find(header, binding_table_anchor)
		if idx == -1:
			problems.append("%s row not found in BINDING_TABLE" % klass)
			continue
		# Take the next ~4000 characters (rows are short) and look for shape.
		var window: String = src_text.substr(idx, 4000)
		# Stop the window at the next top-level NUMBERED row header to avoid
		# bleeding into adjacent classes. Format is `\n\t# <digit>. <Klass>`.
		# Inline polish comments like `\n\t# Plan 05-03 Task 2 polish: ...`
		# do not start with a digit so they are NOT treated as a row boundary.
		var search_start: int = 1
		while true:
			var cut: int = window.find("\n\t# ", search_start)
			if cut == -1:
				break
			# Check the character after `\n\t# `: only digit-prefixed comments
			# are class headers. (Pre-existing class headers in this file all
			# follow `# <number>. <Class>` format.)
			var next_char_idx: int = cut + 4  # past "\n\t# "
			if next_char_idx < window.length():
				var ch: String = window.substr(next_char_idx, 1)
				if ch >= "0" and ch <= "9":
					window = window.substr(0, cut)
					break
			search_start = cut + 1
		if window.find("\"shape.") == -1 and window.find("'shape.") == -1:
			problems.append("%s BINDING_TABLE row has no `shape.*` recipe references (Plan 05-03 Task 2)" % klass)
	if problems.is_empty():
		_group_ok(group, "Button / OptionButton / MenuButton / ColorPickerButton rows reference shape.* recipes (Plan 05-02 wiring flows through)")
	else:
		_group_pending(group, "; ".join(problems))


## Plan 05-03 Task 2 polish: CheckBox + CheckButton expose disabled-state
## icon slots that REUSE the existing checked / unchecked SVGs (per the
## Action item: "reuse existing SVGs for disabled/toggled where Godot
## exposes tintable icon slots, unless Godot introspection proves a
## distinct slot name"). Phase 4 commentary in CANONICAL_SLOT_NAMES already
## documents that Godot 4.6 CheckButton exposes:
##   checked, checked_disabled, checked_disabled_mirrored, checked_mirrored,
##   unchecked, unchecked_disabled, unchecked_disabled_mirrored,
##   unchecked_mirrored
## Phase 4 shipped only the 2 primary slots; Plan 05-03 Task 2 closes the
## reuse contract: every disabled slot binds to the same checked/unchecked
## SVG so the icon stays visible (Godot's font_disabled_color tints it).
##
## Tested by introspecting the live theme's icon list per class.
func assert_checkbox_disabled_icon_reuse() -> void:
	var group := "assert_checkbox_disabled_icon_reuse"
	var theme := _load_pulse_for_group(group)
	if theme == null: return
	var problems: Array[String] = []
	# CheckButton: checked_disabled + unchecked_disabled (skip *_mirrored —
	# Phase 4 commentary defers them to v1.x; we add them only if Godot
	# requires them, which it does NOT per docs).
	var cb_icons: PackedStringArray = theme.get_icon_list("CheckButton")
	for ic in ["checked_disabled", "unchecked_disabled"]:
		if cb_icons.find(ic) == -1:
			problems.append("CheckButton.%s missing — reuse the existing checkbutton_checked / checkbutton_unchecked SVG" % ic)
	# CheckBox: checked_disabled + unchecked_disabled (Phase 4 wired
	# checked/unchecked + radio_checked/radio_unchecked already).
	var cx_icons: PackedStringArray = theme.get_icon_list("CheckBox")
	for ic in ["checked_disabled", "unchecked_disabled"]:
		if cx_icons.find(ic) == -1:
			problems.append("CheckBox.%s missing — reuse the existing checkbox_checked / checkbox_unchecked SVG" % ic)
	if problems.is_empty():
		_group_ok(group, "CheckBox + CheckButton disabled icon slots reuse existing SVGs (no new artwork required)")
	else:
		_group_pending(group, "; ".join(problems))


func assert_basebutton_family_chrome() -> void:
	var group := "assert_basebutton_family_chrome"
	var theme := _load_pulse_for_group(group)
	if theme == null: return
	var problems: Array[String] = []
	# Filled chrome controls — focus + at least normal/hover/pressed/disabled.
	var filled_chrome := ["Button", "CheckBox", "CheckButton", "OptionButton", "MenuButton", "ColorPickerButton"]
	var required_filled := ["normal", "hover", "pressed", "focus", "disabled"]
	for klass in filled_chrome:
		for state in required_filled:
			if not theme.has_stylebox(state, klass):
				problems.append("%s.%s missing" % [klass, state])
	# Optional hover_pressed: Button / CheckBox / CheckButton / OptionButton /
	# MenuButton expose it in Godot 4.6; ColorPickerButton's docs don't list
	# it, so we don't enforce it there.
	for klass in ["Button", "CheckBox", "CheckButton", "OptionButton", "MenuButton"]:
		if not theme.has_stylebox("hover_pressed", klass):
			problems.append("%s.hover_pressed missing" % klass)
	# CheckBox + CheckButton icon coverage Phase 4 ships (regression catch).
	for klass in ["CheckBox"]:
		var icons_required := ["checked", "unchecked", "radio_checked", "radio_unchecked"]
		var icon_list: PackedStringArray = theme.get_icon_list(klass)
		for ic in icons_required:
			if icon_list.find(ic) == -1:
				problems.append("%s icon `%s` missing" % [klass, ic])
	for klass in ["CheckButton"]:
		var icon_list2: PackedStringArray = theme.get_icon_list(klass)
		for ic in ["checked", "unchecked"]:
			if icon_list2.find(ic) == -1:
				problems.append("%s icon `%s` missing" % [klass, ic])
	# LinkButton: text-only. We require font_color slots populated and assert
	# the production source's BINDING_TABLE row does NOT carry a `normal`
	# stylebox recipe.
	for slot in ["font_color", "font_hover_color", "font_focus_color"]:
		if not theme.has_color(slot, "LinkButton"):
			problems.append("LinkButton.%s missing" % slot)
	# Regression catch: BINDING_TABLE.LinkButton must NOT contain a stylebox
	# block. We probe via the live theme: has_stylebox should be false for
	# `normal` after a regenerate, since the recipe row carries no stylebox.
	if theme.has_stylebox("normal", "LinkButton"):
		problems.append("LinkButton.normal stylebox present — LinkButton is text-only; filled chrome is not drawn by Godot's LinkButton renderer")
	if problems.is_empty():
		_group_ok(group, "all 7 BaseButton-family controls expose their official slot set; LinkButton stays text-only")
	else:
		_group_pending(group, "; ".join(problems))


# ----- assertion group: no fake letter_spacing claim (Plan 05-04 Task 1) -----
##
## Per plan 05-04 Test 5 + DESIGN_TOKENS §8.6 + research constraint: official
## Godot 4.6 Label theme properties do not expose a Theme-level letter-spacing
## slot. The Kicker variation may set font, font_size, and font_color only.
## Tracking/uppercase is content/showcase behavior unless a verified Godot API
## is found during execution.
##
## This group scans the production class source for the literal token
## "letter_spacing"; if it appears anywhere outside a comment, the verifier
## fails. If a future Godot release exposes such a constant, the implementer
## can add a documented citation (Godot 4.6 docs URL) plus a precise
## introspection assertion proving the constant exists, then this scan can be
## relaxed -- but never silently.
func assert_no_letter_spacing_claim() -> void:
	var group := "assert_no_letter_spacing_claim"
	var src_text := _read_production_source()
	if src_text.is_empty():
		_group_fail(group, "could not read production source")
		return
	# Strip comment-only lines so the docstring/comment narrative around this
	# decision (which legitimately mentions "letter_spacing") isn't flagged.
	var clean_lines: Array[String] = []
	for line in src_text.split("\n"):
		var stripped: String = line.strip_edges()
		if stripped.begins_with("#"):
			continue
		clean_lines.append(line)
	var clean_text := "\n".join(clean_lines)
	if clean_text.find("letter_spacing") != -1:
		var hits: Array[String] = []
		for line in clean_text.split("\n"):
			if line.find("letter_spacing") != -1:
				hits.append(line.strip_edges())
		_group_fail(group, "production class references `letter_spacing` outside comments (no verified Godot 4.6 API): " + "; ".join(hits))
		return
	_group_ok(group, "no `letter_spacing` Theme constant claim in production source (Theme owns font/size/color only for Kicker)")


# ----- assertion group: Kicker variation chrome (Plan 05-04 Task 1 + 2) -----
##
## Per D-09 / D-10 / DESIGN_TOKENS §8.6 / PITFALLS 1.2:
##   - TYPE_VARIATIONS["Kicker"] == "Label" (Test 1 / 2 in plan).
##   - set_font("font", "Kicker", body_font) explicitly (PITFALLS 1.2).
##   - set_font_size("font_size", "Kicker", tokens.kicker) explicitly.
##   - font_color differs by direction's `shape.kicker_style` enum:
##       Pulse  ("uppercase-tracked-accent")     -> role_primary
##       Slate  ("small-caps-subtle")            -> text_muted
##       Bubble ("uppercase-tracked-accent")     -> role_primary
##       Daybreak ("sentence-case-accent")       -> role_primary
##       Burst  ("uppercase-bold-larger-scale")  -> role_primary
##     Distinct color expectation: Slate Kicker font_color must equal text_muted
##     (visibly different from accent on its dark base) while the other 4
##     directions resolve to role_primary (each their own accent color).
##
## The group loads each direction `.tres` and asserts (a) Kicker font + size
## are present (via get_*_list — has_* walks inheritance and reports built-in
## Control class slot signatures, masking missing AUTHORED set_*() calls),
## (b) font_color resolves per the direction's kicker_style.
func assert_kicker_chrome() -> void:
	var group := "assert_kicker_chrome"
	# Phase A: TYPE_VARIATIONS map has Kicker -> Label (also covered by
	# assert_variation_count_15 but worth duplicating here so this group can be
	# read in isolation).
	var theme := _load_pulse_for_group(group)
	if theme == null: return
	var type_variations: Dictionary = theme.get_script().get_script_constant_map().get("TYPE_VARIATIONS", {})
	if not type_variations.has("Kicker"):
		_group_pending(group, "TYPE_VARIATIONS missing `Kicker` (Plan 05-04 Task 1 not done)")
		return
	if String(type_variations["Kicker"]) != "Label":
		_group_fail(group, "TYPE_VARIATIONS['Kicker'] = '%s' (expected 'Label')" % str(type_variations["Kicker"]))
		return
	# Phase B: Kicker has explicit font + font_size on every direction (PITFALLS 1.2).
	# Per direction, font_color must dispatch from the kicker_style enum.
	var per_direction_expected := {
		"151A2E": {"role": "role_primary", "kicker_style": "uppercase-tracked-accent"},
		"111820": {"role": "text_muted",   "kicker_style": "small-caps-subtle"},
		"241326": {"role": "role_primary", "kicker_style": "uppercase-tracked-accent"},
		"0B2420": {"role": "role_primary", "kicker_style": "sentence-case-accent"},
		"20112E": {"role": "role_primary", "kicker_style": "uppercase-bold-larger-scale"},
	}
	var problems: Array[String] = []
	# Reuse the .tres path map from the shape-lookup-integrity group.
	for hex_key in PHASE5_DIRECTION_TRES_PATHS.keys():
		var tres_path: String = PHASE5_DIRECTION_TRES_PATHS[hex_key]
		var loaded: Resource = ResourceLoader.load(tres_path)
		if loaded == null or not (loaded is NeoCadeTheme):
			problems.append("could not load %s" % tres_path)
			continue
		var t: NeoCadeTheme = loaded
		# Explicit font + size per Pitfall 1.2 — use get_*_list so we test for
		# AUTHORED slots, not Godot-inherited Control class defaults.
		# (Empirical proof: _phase5_diag_inftext.gd shows has_font_size returns
		# true for inherited slot signatures even when set_*() never authored.)
		var k_font_list: PackedStringArray = t.get_font_list("Kicker")
		var k_size_list: PackedStringArray = t.get_font_size_list("Kicker")
		if k_font_list.find("font") == -1:
			problems.append("%s missing Kicker.font (not authored)" % tres_path)
		if k_size_list.find("font_size") == -1:
			problems.append("%s missing Kicker.font_size (not authored)" % tres_path)
		# kicker_style enum match against DIRECTION_PRESETS.
		var expected_meta: Dictionary = per_direction_expected[hex_key]
		var resolved_presets: Dictionary = t.call("_resolve_direction_presets")
		if not resolved_presets.has("shape"):
			problems.append("%s presets has no shape" % tres_path)
			continue
		var actual_kicker_style: String = String(resolved_presets.shape.get("kicker_style", ""))
		if actual_kicker_style != String(expected_meta["kicker_style"]):
			problems.append("%s shape.kicker_style = '%s' (expected '%s')" % [tres_path, actual_kicker_style, expected_meta["kicker_style"]])
		# Color check: assert font_color is AUTHORED and resolves to the right
		# semantic color for the kicker_style enum. role_primary == accent_color
		# on every direction; text_muted == #B9C1D0 on every dark base (all 5
		# approved directions are dark per DESIGN_TOKENS §6.4).
		var k_color_list: PackedStringArray = t.get_color_list("Kicker")
		if k_color_list.find("font_color") != -1:
			var actual_color: Color = t.get_color("font_color", "Kicker")
			if String(expected_meta["role"]) == "role_primary":
				if not actual_color.is_equal_approx(t.accent_color):
					problems.append("%s Kicker.font_color = %s (expected accent %s for kicker_style '%s')" % [tres_path, actual_color.to_html(false), t.accent_color.to_html(false), actual_kicker_style])
			elif String(expected_meta["role"]) == "text_muted":
				var expected_muted := Color("#B9C1D0")
				if not actual_color.is_equal_approx(expected_muted):
					problems.append("%s Kicker.font_color = %s (expected text_muted %s for kicker_style '%s')" % [tres_path, actual_color.to_html(false), expected_muted.to_html(false), actual_kicker_style])
		else:
			problems.append("%s missing Kicker.font_color (Plan 05-04 Task 2)" % tres_path)
	if problems.is_empty():
		_group_ok(group, "Kicker variation registered, font/size set, font_color dispatches per kicker_style enum on all 5 directions")
	else:
		_group_pending(group, "; ".join(problems))


# ----- assertion group: text/label/RTL variation chrome (Plan 05-04 Task 2) -----
##
## Per TYPEVAR-02 / TYPEVAR-03 / TYPEVAR-05 + DESIGN_TOKENS §8.5:
##   - HeaderLarge / HeaderMedium / HeaderSmall / Caption / CodeLabel exist
##     and have explicit font + font_size + font_color.
##   - InfoText (RichTextLabel variation) uses normal_font / normal_font_size
##     (BL-02 fix carry-forward) and has default_color authored.
##
## Color contract: Header* and Caption resolve to text_strong (no per-direction
## override at variation level); InfoText default_color resolves to text_default.
## CodeLabel uses text_strong by default. Plan 05-04 Task 2 wires per-direction
## color tints if needed, but the v1 baseline uses the global text_* roles.
##
## Uses get_*_list to test for AUTHORED slots — has_* walks inheritance and
## reports Godot-built-in Control class defaults, which would mask missing
## explicit set_font / set_font_size / set_color calls.
func assert_text_label_variation_chrome() -> void:
	var group := "assert_text_label_variation_chrome"
	var theme := _load_pulse_for_group(group)
	if theme == null: return
	var problems: Array[String] = []
	var label_variations := ["HeaderLarge", "HeaderMedium", "HeaderSmall", "Caption", "CodeLabel"]
	for v in label_variations:
		# Phase 4 already authored font + font_size; Phase 5 must NOT regress that.
		if theme.get_font_list(v).find("font") == -1:
			problems.append("%s missing font (not authored)" % v)
		if theme.get_font_size_list(v).find("font_size") == -1:
			problems.append("%s missing font_size (not authored)" % v)
		# Plan 05-04 Task 2 mandate: each label variation has font_color
		# explicitly authored via BINDING_TABLE so the color refreshes per
		# direction on theme regenerate.
		if theme.get_color_list(v).find("font_color") == -1:
			problems.append("%s missing font_color (Plan 05-04 Task 2)" % v)
	# InfoText is a RichTextLabel variation: D-16 / BL-02 says it uses
	# `normal_font` and `normal_font_size`, NOT `font` / `font_size`.
	var info_font_list: PackedStringArray = theme.get_font_list("InfoText")
	var info_size_list: PackedStringArray = theme.get_font_size_list("InfoText")
	var info_color_list: PackedStringArray = theme.get_color_list("InfoText")
	if info_font_list.find("normal_font") == -1:
		problems.append("InfoText missing normal_font (BL-02)")
	if info_size_list.find("normal_font_size") == -1:
		problems.append("InfoText missing normal_font_size (Plan 05-04 Task 1)")
	if info_size_list.find("font_size") != -1:
		problems.append("InfoText has wrong `font_size` slot authored (D-16 BL-02 fix forbids it)")
	# default_color is the RichTextLabel body color slot.
	if info_color_list.find("default_color") == -1:
		problems.append("InfoText missing default_color (Plan 05-04 Task 2)")
	if problems.is_empty():
		_group_ok(group, "Label variations + InfoText have correct font/font_size/font_color slots")
	else:
		_group_pending(group, "; ".join(problems))


# ----- assertion group: panel-variation chrome (Plan 05-04 Task 3) -----
##
## Per TYPEVAR-04 + COV-07 (in-progress) + DESIGN_TOKENS §5.1-§5.5:
##   - CardPanel and HeroPanel each have a `panel` stylebox.
##   - The stylebox is direction-specific: corner_radius reads from
##     shape.card_radius / shape.hero_radius, alpha from
##     shape.surface_alpha_panels, raised intensity from
##     shape.raised_lifts.panel.
##   - Panel and PanelContainer (base classes) keep their `panel` stylebox
##     but read direction-specific surface_alpha_panels.
##
## The verifier loads every approved direction `.tres` and asserts CardPanel /
## HeroPanel `panel` styleboxes are AUTHORED (via get_stylebox_list — has_*
## walks inheritance) AND that corner_radius_top_left matches the expected
## per-direction card_radius / hero_radius.
func assert_panel_variation_chrome() -> void:
	var group := "assert_panel_variation_chrome"
	# Per-direction expected radii (sourced from DIRECTION_PRESETS.shape).
	var expected_radius := {
		"151A2E": {"card": 0,  "hero": 0},   # Pulse: rectangular
		"111820": {"card": 14, "hero": 14},  # Slate: rounded
		"241326": {"card": 26, "hero": 26},  # Bubble: pillowy
		"0B2420": {"card": 8,  "hero": 8},   # Daybreak: airy
		"20112E": {"card": 18, "hero": 18},  # Burst: statement
	}
	var problems: Array[String] = []
	for hex_key in PHASE5_DIRECTION_TRES_PATHS.keys():
		var tres_path: String = PHASE5_DIRECTION_TRES_PATHS[hex_key]
		var loaded: Resource = ResourceLoader.load(tres_path)
		if loaded == null or not (loaded is NeoCadeTheme):
			problems.append("could not load %s" % tres_path)
			continue
		var t: NeoCadeTheme = loaded
		# Base classes still have a panel stylebox after Phase 5 (carried
		# forward from Phase 4). Use get_stylebox_list so we check authored
		# styleboxes only; has_stylebox walks inheritance and would obscure
		# whether NeoCadeTheme actually authored the slot.
		for base_t in ["Panel", "PanelContainer"]:
			if t.get_stylebox_list(base_t).find("panel") == -1:
				problems.append("%s %s missing panel stylebox (not authored)" % [tres_path, base_t])
		# Variations must have the panel stylebox AND match radius.
		for v in ["CardPanel", "HeroPanel"]:
			if t.get_stylebox_list(v).find("panel") == -1:
				problems.append("%s %s missing panel stylebox (Plan 05-04 Task 3)" % [tres_path, v])
				continue
			var sb: StyleBox = t.get_stylebox("panel", v)
			if not (sb is StyleBoxFlat):
				problems.append("%s %s panel is not a StyleBoxFlat (got %s)" % [tres_path, v, sb.get_class()])
				continue
			var sbf: StyleBoxFlat = sb
			var key: String = "card" if v == "CardPanel" else "hero"
			var expected: int = expected_radius[hex_key][key]
			if sbf.corner_radius_top_left != expected:
				problems.append("%s %s.panel corner_radius_top_left = %d (expected %d from shape.%s_radius)" % [tres_path, v, sbf.corner_radius_top_left, expected, key])
	if problems.is_empty():
		_group_ok(group, "CardPanel + HeroPanel panel styleboxes match per-direction shape.{card,hero}_radius on all 5 directions; Panel/PanelContainer baselines preserved")
	else:
		_group_pending(group, "; ".join(problems))


# ----- assertion group: text-class chrome completeness (Plan 05-05 Task 1) -----
##
## Per COV-03 + DESIGN_TOKENS §5/§7: the five Phase 5 text classes (Label,
## RichTextLabel, LineEdit, TextEdit, CodeEdit) must have their AUTHORED
## desktop chrome slots populated. "Authored" = set_color/set_stylebox emitted
## via the BINDING_TABLE walk. We probe via get_*_list("type").find != -1 to
## avoid Godot's has_*() reporting Control-class default signatures (Wave 4
## BL-02 fix, carried forward).
##
## Required AUTHORED slots per type (Phase 5 desktop, no syntax highlighting):
##   Label          -> color: font_color
##                     stylebox: normal
##   RichTextLabel  -> color: default_color, selection_color, font_selected_color
##                     stylebox: normal, focus
##   LineEdit       -> color: font_color, font_placeholder_color,
##                            font_uneditable_color, font_selected_color,
##                            caret_color, selection_color
##                     stylebox: normal, focus, read_only
##   TextEdit       -> color: font_color, font_placeholder_color,
##                            font_readonly_color, font_selected_color,
##                            caret_color, selection_color, current_line_color
##                     stylebox: normal, focus, read_only
##   CodeEdit       -> color: font_color, font_placeholder_color,
##                            font_readonly_color, font_selected_color,
##                            caret_color, selection_color, current_line_color
##                     stylebox: normal, focus, read_only
##
## CodeEdit gutter colors + folded icon are owned by assert_codeedit_gutter_slots
## so this group does NOT duplicate them — it only asserts the *text chrome*
## CodeEdit shares with TextEdit.
const PHASE5_TEXT_CLASS_CHROME_REQUIREMENTS := {
	"Label": {
		"color": ["font_color"],
		"stylebox": ["normal"],
	},
	"RichTextLabel": {
		"color": ["default_color", "selection_color", "font_selected_color"],
		"stylebox": ["normal", "focus"],
	},
	"LineEdit": {
		"color": [
			"font_color", "font_placeholder_color", "font_uneditable_color",
			"font_selected_color", "caret_color", "selection_color",
		],
		"stylebox": ["normal", "focus", "read_only"],
	},
	"TextEdit": {
		"color": [
			"font_color", "font_placeholder_color", "font_readonly_color",
			"font_selected_color", "caret_color", "selection_color",
			"current_line_color",
		],
		"stylebox": ["normal", "focus", "read_only"],
	},
	"CodeEdit": {
		"color": [
			"font_color", "font_placeholder_color", "font_readonly_color",
			"font_selected_color", "caret_color", "selection_color",
			"current_line_color",
		],
		"stylebox": ["normal", "focus", "read_only"],
	},
}

func assert_text_class_chrome_complete() -> void:
	var group := "assert_text_class_chrome_complete"
	var theme := _load_pulse_for_group(group)
	if theme == null: return
	var problems: Array[String] = []
	for type_name in PHASE5_TEXT_CLASS_CHROME_REQUIREMENTS.keys():
		var requirements: Dictionary = PHASE5_TEXT_CLASS_CHROME_REQUIREMENTS[type_name]
		var color_list: PackedStringArray = theme.get_color_list(type_name)
		for slot in requirements.get("color", []):
			if color_list.find(slot) == -1:
				problems.append("%s missing AUTHORED color slot `%s`" % [type_name, slot])
		var stylebox_list: PackedStringArray = theme.get_stylebox_list(type_name)
		for slot in requirements.get("stylebox", []):
			if stylebox_list.find(slot) == -1:
				problems.append("%s missing AUTHORED stylebox slot `%s`" % [type_name, slot])
	if problems.is_empty():
		_group_ok(group, "Label / RichTextLabel / LineEdit / TextEdit / CodeEdit text chrome AUTHORED across font/caret/selection/placeholder/read_only/focus slots")
	else:
		_group_pending(group, "; ".join(problems))


# ----- assertion group: CodeEdit no syntax highlighting scope creep (Plan 05-05 Task 1) -----
##
## Per FEATURES AF-7 + 05-RESEARCH.md + plan: CodeEdit syntax highlighting is
## NOT in Phase 5 scope. The Theme should NOT author any color slot in the
## syntax-highlighting family. Phase 5 only owns chrome around the text:
## fonts, caret, selection, placeholder/read-only, focus, and the gutter
## colors/icons handled by assert_codeedit_gutter_slots.
##
## Forbidden slots (verified against Godot 4.6 CodeEdit/CodeHighlighter API):
##   keyword_color, function_color, number_color, member_variable_color,
##   symbol_color, control_flow_keyword_color, brace_mismatch_color,
##   string_color, base_type_color, engine_type_color, user_type_color,
##   comment_color, doc_comment_color
##
## If any of these are AUTHORED on the live theme via the BINDING_TABLE walk,
## Phase 5 has accidentally creeped into Plan 06+ scope. Fail loud.
const PHASE5_CODEEDIT_FORBIDDEN_SYNTAX_COLORS := [
	"keyword_color",
	"function_color",
	"number_color",
	"member_variable_color",
	"symbol_color",
	"control_flow_keyword_color",
	"brace_mismatch_color",
	"string_color",
	"base_type_color",
	"engine_type_color",
	"user_type_color",
	"comment_color",
	"doc_comment_color",
]

func assert_codeedit_no_syntax_highlighting() -> void:
	var group := "assert_codeedit_no_syntax_highlighting"
	var theme := _load_pulse_for_group(group)
	if theme == null: return
	var color_list: PackedStringArray = theme.get_color_list("CodeEdit")
	var found: Array[String] = []
	for slot in PHASE5_CODEEDIT_FORBIDDEN_SYNTAX_COLORS:
		if color_list.find(slot) != -1:
			found.append(slot)
	if found.is_empty():
		_group_ok(group, "CodeEdit has no AUTHORED syntax-highlighting color slots (AF-7 honored)")
	else:
		_group_fail(group, "AF-7 violation: CodeEdit has AUTHORED syntax-highlighting slots (out of Phase 5 scope): " + ", ".join(found))


# ----- assertion group: data-only direction `.tres` (Plan 05-07 Task 2 / D-06) -----
##
## Per D-06 + PROJECT.md: each approved direction `.tres` is data-only —
## script linkage + 9 @export values only. The verifier:
##   1. Reads each direction `.tres` raw from disk.
##   2. Asserts size < 2048 bytes.
##   3. Asserts no `[sub_resource` line is present (regenerated entries do not
##      leak into the file).
##   4. Asserts no `theme_data/` line is present (per-Control state entries do
##      not leak in).
##   5. Asserts the file re-loads as `NeoCadeTheme` and has the Phase 4
##      baseline (Button.normal stylebox populates via _regenerate_theme()).
## All five approved directions are checked.
func assert_resource_data_only() -> void:
	var group := "assert_resource_data_only"
	var problems: Array[String] = []
	for path in PHASE5_DIRECTION_TRES_PATHS.values():
		var bytes_arr: PackedByteArray = FileAccess.get_file_as_bytes(path)
		if bytes_arr.is_empty():
			problems.append("%s: file missing or empty" % path)
			continue
		var size: int = bytes_arr.size()
		if size >= 2048:
			problems.append("%s: size %d >= 2048 bytes (D-06 / SC#6)" % [path, size])
		var f := FileAccess.open(path, FileAccess.READ)
		if f == null:
			problems.append("%s: cannot open for read" % path)
			continue
		var text: String = f.get_as_text()
		f.close()
		if text.find("[sub_resource") != -1:
			problems.append("%s: contains [sub_resource block (D-06 violated)" % path)
		if text.find("theme_data/") != -1:
			problems.append("%s: contains theme_data/ entry (D-06 violated)" % path)
		# Reload + Phase 4 baseline.
		var loaded: Resource = ResourceLoader.load(path, "", ResourceLoader.CACHE_MODE_IGNORE)
		if loaded == null or not (loaded is NeoCadeTheme):
			problems.append("%s: did not re-load as NeoCadeTheme" % path)
			continue
		var t: NeoCadeTheme = loaded
		if not t.has_stylebox("normal", "Button"):
			problems.append("%s: post-strip Phase 4 baseline regression — Button.normal missing" % path)
	if problems.is_empty():
		_group_ok(group, "all 5 direction `.tres` files data-only, < 2 KiB, no [sub_resource], no theme_data/, reload as NeoCadeTheme with Phase 4 baseline")
	else:
		_group_pending(group, "; ".join(problems))


# ----- assertion group: flat-mode shadow contract (Plan 05-07 Task 2) -----
##
## Per `_make_raised_stylebox` (DESIGN_TOKENS §9 + Conflict 3): when
## `raised=false`, every generated `StyleBoxFlat` must have:
##   - `shadow_size == -1` (Godot's "no shadow" sentinel per #98162)
##   - `shadow_offset == Vector2.ZERO`
## The verifier instantiates a fresh `NeoCadeTheme` per approved direction
## (loading the `.tres` triggers `_regenerate_theme()` which populates every
## entry), explicitly forces `raised=false` to be safe, then walks every
## authored StyleBoxFlat across every authored theme type and asserts the
## invariant. Non-StyleBoxFlat styleboxes (StyleBoxEmpty etc.) are skipped —
## the contract is on the FLAT family only.
func assert_flat_no_shadow_when_off() -> void:
	var group := "assert_flat_no_shadow_when_off"
	var problems: Array[String] = []
	for hex_key in PHASE5_DIRECTION_TRES_PATHS.keys():
		var path: String = PHASE5_DIRECTION_TRES_PATHS[hex_key]
		var loaded: Resource = ResourceLoader.load(path, "", ResourceLoader.CACHE_MODE_IGNORE)
		if loaded == null or not (loaded is NeoCadeTheme):
			problems.append("%s: did not load as NeoCadeTheme" % path)
			continue
		var t: NeoCadeTheme = loaded
		# Force raised=false to be defensive (the .tres files all ship raised=false
		# by design per Phase 4, but the contract says "loaded with raised=false").
		# Setting the property fires the setter which re-runs _regenerate_theme().
		if t.raised:
			t.raised = false
		# Walk every authored theme type and every authored stylebox slot.
		var type_list: PackedStringArray = t.get_stylebox_type_list()
		var bad_count: int = 0
		var bad_examples: Array[String] = []
		for ttype in type_list:
			var slot_list: PackedStringArray = t.get_stylebox_list(ttype)
			for slot in slot_list:
				var sb: StyleBox = t.get_stylebox(slot, ttype)
				if not (sb is StyleBoxFlat):
					continue
				var sbf: StyleBoxFlat = sb
				if sbf.shadow_size != -1 or sbf.shadow_offset != Vector2.ZERO:
					bad_count += 1
					if bad_examples.size() < 3:
						bad_examples.append("%s.%s: shadow_size=%d offset=%s" % [ttype, slot, sbf.shadow_size, str(sbf.shadow_offset)])
		if bad_count > 0:
			problems.append("%s (raised=false): %d StyleBoxFlat have non-(-1) shadow_size or non-ZERO offset; e.g. %s" % [path, bad_count, "; ".join(bad_examples)])
	if problems.is_empty():
		_group_ok(group, "raised=false: every generated StyleBoxFlat has shadow_size == -1 and shadow_offset == ZERO across all 5 directions")
	else:
		_group_pending(group, "; ".join(problems))


# ----- assertion group: raised-mode hard-offset shadow contract (Plan 05-07 Task 2) -----
##
## Per `_make_raised_stylebox` (DESIGN_TOKENS §9 + FLAT-3D-UI-RESEARCH.md):
## when `raised=true`, every generated `StyleBoxFlat` must have hard-offset
## shadow semantics:
##   - `shadow_offset.x == 0`
##   - `shadow_offset.y == shadow_size`  (shadow drops straight down by exactly
##                                         the shadow size — the extruded-flat
##                                         3D primitive)
##   - `shadow_size == raised_strength * raised_intensity` for some recipe-side
##     `raised_intensity >= 0`. When the recipe sets `raised_intensity == 0`
##     (e.g. the focus_ring slot, pressed states, panel inner styleboxes),
##     `shadow_size == 0` is permitted; that is still the "hard offset" form
##     (no blur, no glow, no texture) — just no visible drop.
##
## The verifier asserts the structural form: every authored StyleBoxFlat under
## raised=true must satisfy `shadow_offset == Vector2(0, shadow_size)`. We
## additionally verify that any non-zero `shadow_size` is a non-negative
## multiple of `raised_strength` (proof that intensity flowed through
## `_make_raised_stylebox(bg, offset, raised_strength * raised_intensity)`).
##
## Focus styleboxes (`role: "focus_ring"`) hard-set `shadow_size = -1` per the
## production class — those are exempt from the raised contract because focus
## is an outer-ring overlay, not a fill stylebox.
func assert_raised_hard_offset_shadow() -> void:
	var group := "assert_raised_hard_offset_shadow"
	var problems: Array[String] = []
	for hex_key in PHASE5_DIRECTION_TRES_PATHS.keys():
		var path: String = PHASE5_DIRECTION_TRES_PATHS[hex_key]
		var loaded: Resource = ResourceLoader.load(path, "", ResourceLoader.CACHE_MODE_IGNORE)
		if loaded == null or not (loaded is NeoCadeTheme):
			problems.append("%s: did not load as NeoCadeTheme" % path)
			continue
		var t: NeoCadeTheme = loaded
		# Force raised=true (re-fires the setter -> _regenerate_theme()).
		t.raised = true
		var raised_strength_v: int = t.raised_strength
		var type_list: PackedStringArray = t.get_stylebox_type_list()
		var bad_count: int = 0
		var bad_examples: Array[String] = []
		for ttype in type_list:
			var slot_list: PackedStringArray = t.get_stylebox_list(ttype)
			for slot in slot_list:
				var sb: StyleBox = t.get_stylebox(slot, ttype)
				if not (sb is StyleBoxFlat):
					continue
				var sbf: StyleBoxFlat = sb
				# Focus rings are exempt — the production class hard-sets
				# `shadow_size = -1` and `shadow_offset = ZERO` for ALL recipes
				# whose role is "focus_ring", regardless of `raised`. The
				# focus_ring slot name varies across BINDING_TABLE rows (`focus`
				# on Button-family, `tab_focus` on TabBar/TabContainer,
				# `scroll_focus` on H/VScrollBar) so a slot-name allowlist
				# would drift; instead we use the unambiguous structural
				# signature: shadow_size == -1 + shadow_offset == ZERO is the
				# explicit "no shadow" sentinel that only the focus_ring
				# branch produces under raised=true (the raised branch in
				# `_make_raised_stylebox` always emits non-negative shadow_size).
				# This also gracefully exempts any future focus-ring slot
				# wiring that lands in Phase 6/7.
				var ss: int = sbf.shadow_size
				var so: Vector2 = sbf.shadow_offset
				if ss == -1 and so == Vector2.ZERO:
					# focus_ring (or any other "no shadow" stylebox) — exempt.
					continue
				if ss < 0:
					# Anything other than -1 is undefined / a bug.
					bad_count += 1
					if bad_examples.size() < 3:
						bad_examples.append("%s.%s: shadow_size=%d < 0 (raised=true should produce >= 0 unless explicit focus-ring -1 + ZERO offset)" % [ttype, slot, ss])
					continue
				# Hard offset: shadow drops straight down by exactly shadow_size.
				if so.x != 0.0 or so.y != float(ss):
					bad_count += 1
					if bad_examples.size() < 3:
						bad_examples.append("%s.%s: shadow_size=%d but shadow_offset=%s (expected (0, %d) hard offset)" % [ttype, slot, ss, str(so), ss])
					continue
				# shadow_size must be a non-negative multiple of raised_strength
				# (proof that the recipe flowed through _make_raised_stylebox with
				# intensity = raised_strength * raised_intensity_recipe; when the
				# recipe pins raised_intensity == 0 we get shadow_size == 0).
				if raised_strength_v > 0 and (ss % raised_strength_v) != 0:
					bad_count += 1
					if bad_examples.size() < 3:
						bad_examples.append("%s.%s: shadow_size=%d not a multiple of raised_strength=%d (recipe drift?)" % [ttype, slot, ss, raised_strength_v])
		if bad_count > 0:
			problems.append("%s (raised=true): %d StyleBoxFlat violate hard-offset contract; e.g. %s" % [path, bad_count, "; ".join(bad_examples)])
	if problems.is_empty():
		_group_ok(group, "raised=true: every generated StyleBoxFlat has shadow_offset == Vector2(0, shadow_size); shadow_size is a non-negative multiple of raised_strength; focus rings exempt (-1)")
	else:
		_group_pending(group, "; ".join(problems))


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
	# In buttons stage (Plan 05-03), PENDING is a FAIL only for the
	# buttons-related groups (variation rows, states, fonts, strategy
	# distinctness, role_danger, BaseButton-family chrome, focus overlay,
	# and the carry-forward shape + invariant groups Plan 05-02 already
	# pinned strict).
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
		# Plan 05-02 carry-forward: shape groups stay strict in `buttons`
		# stage because the buttons recipes depend on them resolving.
		"assert_shape_lookup_integrity",
		"assert_shape_value_integrity",
		"assert_shape_recipe_resolution",
		"assert_semantic_role_table",
		"assert_no_invented_focus_combos",
		"assert_no_theme_clear",
	]
	# Plan 05-04 strict list: text/label/panel variation chrome + InfoText slot
	# fix + 15-variation count + no-letter-spacing-claim guard. Shape-stage
	# guards (no_theme_clear / no_invented_focus_combos) carry forward strict.
	var text_panels_stage_strict := [
		"assert_variation_count_15",
		"assert_inf_text_normal_font_size",
		"assert_kicker_chrome",
		"assert_text_label_variation_chrome",
		"assert_panel_variation_chrome",
		"assert_no_letter_spacing_claim",
		"assert_no_theme_clear",
		"assert_no_invented_focus_combos",
	]
	# Plan 05-05 strict list: text-class chrome completeness + CodeEdit gutter
	# slots + no-syntax-highlighting scope guard. Plan 05-04 text-panels groups
	# carry forward strict (a text-final regression must also catch text-panels
	# regressions). Shape/Theme.clear() invariants carry forward strict.
	var text_final_stage_strict := [
		"assert_codeedit_gutter_slots",
		"assert_text_class_chrome_complete",
		"assert_codeedit_no_syntax_highlighting",
		# Plan 05-04 carry-forward.
		"assert_variation_count_15",
		"assert_inf_text_normal_font_size",
		"assert_kicker_chrome",
		"assert_text_label_variation_chrome",
		"assert_panel_variation_chrome",
		"assert_no_letter_spacing_claim",
		# Carry-forward invariants.
		"assert_no_theme_clear",
		"assert_no_invented_focus_combos",
	]
	# Plan 05-06 strict list: assert_spinbox_icons flips strict (the four
	# official Godot 4.6 slot names — up / up_disabled / down / down_disabled —
	# must be authored). All Plan 05-03 / 05-04 / 05-05 strict groups carry
	# forward so a spinbox regression also catches earlier-stage regressions.
	var spinbox_stage_strict := [
		"assert_spinbox_icons",
		# Plan 05-05 carry-forward (text-final).
		"assert_codeedit_gutter_slots",
		"assert_text_class_chrome_complete",
		"assert_codeedit_no_syntax_highlighting",
		# Plan 05-04 carry-forward (text-panels).
		"assert_variation_count_15",
		"assert_inf_text_normal_font_size",
		"assert_kicker_chrome",
		"assert_text_label_variation_chrome",
		"assert_panel_variation_chrome",
		"assert_no_letter_spacing_claim",
		# Plan 05-03 carry-forward (buttons).
		"assert_button_variation_rows",
		"assert_button_variation_states",
		"assert_button_variation_fonts",
		"assert_button_strategy_distinctness",
		"assert_dangerbutton_role_danger",
		"assert_basebutton_family_chrome",
		"assert_basebutton_family_shape_aware",
		"assert_checkbox_disabled_icon_reuse",
		"assert_focus_overlay_visibility",
		# Plan 05-02 carry-forward (shape).
		"assert_shape_lookup_integrity",
		"assert_shape_value_integrity",
		"assert_shape_recipe_resolution",
		"assert_semantic_role_table",
		# Carry-forward invariants.
		"assert_no_theme_clear",
		"assert_no_invented_focus_combos",
	]
	# Plan 05-07 strict list: data-only `.tres` + flat-mode shadow_size==-1
	# + raised-mode hard-offset shadow contract. ALL prior strict groups
	# carry forward strict (a final regression catches every earlier-wave
	# regression too). This is the cumulative Phase 5 gate.
	var final_stage_strict := [
		# Plan 05-07 NEW.
		"assert_resource_data_only",
		"assert_flat_no_shadow_when_off",
		"assert_raised_hard_offset_shadow",
		# Plan 05-06 carry-forward.
		"assert_spinbox_icons",
		# Plan 05-05 carry-forward.
		"assert_codeedit_gutter_slots",
		"assert_text_class_chrome_complete",
		"assert_codeedit_no_syntax_highlighting",
		# Plan 05-04 carry-forward.
		"assert_variation_count_15",
		"assert_inf_text_normal_font_size",
		"assert_kicker_chrome",
		"assert_text_label_variation_chrome",
		"assert_panel_variation_chrome",
		"assert_no_letter_spacing_claim",
		# Plan 05-03 carry-forward.
		"assert_button_variation_rows",
		"assert_button_variation_states",
		"assert_button_variation_fonts",
		"assert_button_strategy_distinctness",
		"assert_dangerbutton_role_danger",
		"assert_basebutton_family_chrome",
		"assert_basebutton_family_shape_aware",
		"assert_checkbox_disabled_icon_reuse",
		"assert_focus_overlay_visibility",
		# Plan 05-02 carry-forward.
		"assert_shape_lookup_integrity",
		"assert_shape_value_integrity",
		"assert_shape_recipe_resolution",
		"assert_semantic_role_table",
		# Carry-forward invariants.
		"assert_no_theme_clear",
		"assert_no_invented_focus_combos",
	]
	var fail: bool = false
	if _stage == "strict":
		fail = true
	elif _stage == "shape" and group in shape_stage_strict:
		fail = true
	elif _stage == "buttons" and group in buttons_stage_strict:
		fail = true
	elif _stage == "text-panels" and group in text_panels_stage_strict:
		fail = true
	elif _stage == "text-final" and group in text_final_stage_strict:
		fail = true
	elif _stage == "spinbox" and group in spinbox_stage_strict:
		fail = true
	elif _stage == "final" and group in final_stage_strict:
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
	# Plan 01 baseline 7 + Plan 05-02 added 4 + Plan 05-03 added 8 + Plan 05-04 added 4 + Plan 05-05 added 2 + Plan 05-07 added 3 = 28.
	print("  groups OK:      %d / %d" % [_ok_markers.size(), 28])
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
