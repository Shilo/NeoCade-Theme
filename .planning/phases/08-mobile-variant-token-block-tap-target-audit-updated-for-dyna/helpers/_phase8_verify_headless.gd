extends SceneTree

const PRODUCTION_GD := "res://addons/neocade_theme/neocade_theme.gd"
const PULSE_PATH := "res://addons/neocade_theme/pulse_neocade_theme.tres"
const ROOT_FALLBACK_PATH := "res://addons/neocade_theme/neocade_theme.tres"
const MOBILE_FALLBACK_PATH := "res://addons/neocade_theme/neocade_mobile_theme.tres"
const MOBILE_SPEC_PATH := "res://MOBILE-DESIGN-SPEC.md"
const TAP_AUDIT_PATH := "res://.planning/phases/08-mobile-variant-token-block-tap-target-audit-updated-for-dyna/helpers/_phase8_tap_target_audit.gd"

const APPROVED_DIRECTIONS := {
	"Pulse": "res://addons/neocade_theme/pulse_neocade_theme.tres",
	"Slate": "res://addons/neocade_theme/slate_neocade_theme.tres",
	"Bubble": "res://addons/neocade_theme/bubble_neocade_theme.tres",
	"Daybreak": "res://addons/neocade_theme/daybreak_neocade_theme.tres",
	"Burst": "res://addons/neocade_theme/burst_neocade_theme.tres",
}

const EXPECTED_EXPORTS := [
	"base_color", "accent_color", "raised", "platform",
	"corner_radius", "spacing", "raised_strength", "focus_thickness", "outline_width",
]

const SCORECARD_37_TYPES := [
	"AcceptDialog", "Button", "CheckBox", "CheckButton", "CodeEdit", "ColorPicker",
	"ColorPickerButton", "ConfirmationDialog", "FileDialog", "FoldableContainer",
	"GraphEdit", "HScrollBar", "HSlider", "HSplitContainer", "ItemList", "Label",
	"LineEdit", "LinkButton", "MenuBar", "MenuButton", "OptionButton", "Panel",
	"PopupMenu", "PopupPanel", "ProgressBar", "RichTextLabel", "SpinBox", "TabBar",
	"TabContainer", "TextEdit", "TooltipLabel", "TooltipPanel", "Tree", "VScrollBar",
	"VSlider", "VSplitContainer", "Window",
]

var _stage := "architecture"
var _failures: Array[String] = []
var _pending: Array[String] = []
var _ok: Array[String] = []

func _init() -> void:
	_parse_args()
	_run()
	_emit_summary_and_quit()

func _parse_args() -> void:
	for source in [OS.get_cmdline_user_args(), OS.get_cmdline_args()]:
		var args: PackedStringArray = source
		var i := 0
		while i < args.size():
			if args[i] == "--stage" and i + 1 < args.size():
				_stage = args[i + 1]
				break
			i += 1
	if not ["architecture", "platform-tokens", "tap-targets", "docs", "scene-toggle", "full"].has(_stage):
		_failures.append("unknown stage: %s" % _stage)
		_stage = "architecture"
	print("PHASE8_VERIFY: stage=%s" % _stage)

func _run() -> void:
	assert_architecture_stage()
	if ["platform-tokens", "tap-targets", "docs", "scene-toggle", "full"].has(_stage):
		assert_platform_tokens_stage()
	if ["tap-targets", "docs", "scene-toggle", "full"].has(_stage):
		assert_tap_targets_stage()
	if ["docs", "scene-toggle", "full"].has(_stage):
		assert_docs_stage()
	if ["scene-toggle", "full"].has(_stage):
		assert_scene_toggle_stage()
	if _stage == "full":
		assert_full_stage()

func assert_architecture_stage() -> void:
	var group := "architecture"
	var problems: Array[String] = []
	var pulse := _load_direction(PULSE_PATH)
	if pulse == null:
		problems.append("Pulse does not load as NeoCadeTheme")
	if not FileAccess.file_exists(PRODUCTION_GD):
		problems.append("production script missing")
	_append_one_addon_root_gd(problems)
	_append_public_export_lock(problems)
	_append_forbidden_source_tokens(problems)
	_append_forbidden_resources(problems)
	_append_direction_resource_shape(problems)
	if problems.is_empty():
		_group_ok(group, "single-script, five-data-resource architecture is intact")
	else:
		_group_fail(group, "; ".join(problems))

func assert_platform_tokens_stage() -> void:
	var group := "platform-tokens"
	var problems: Array[String] = []
	var desktop := _configured_theme(NeoCadeTheme.Platform.DESKTOP, false)
	var mobile := _configured_theme(NeoCadeTheme.Platform.MOBILE, false)
	var auto_theme := _configured_theme(NeoCadeTheme.Platform.AUTO, false)
	if desktop == null or mobile == null or auto_theme == null:
		_group_fail(group, "could not duplicate Pulse for DESKTOP/MOBILE/AUTO")
		return

	_expect_equal(problems, "desktop default_font_size", desktop.default_font_size, 14)
	_expect_equal(problems, "mobile default_font_size", mobile.default_font_size, 16)
	_expect_font_size(problems, desktop, "HeaderLarge", "font_size", 36)
	_expect_font_size(problems, mobile, "HeaderLarge", "font_size", 36)
	_expect_font_size(problems, desktop, "HeaderMedium", "font_size", 22)
	_expect_font_size(problems, mobile, "HeaderMedium", "font_size", 22)
	_expect_font_size(problems, desktop, "HeaderSmall", "font_size", 22)
	_expect_font_size(problems, mobile, "HeaderSmall", "font_size", 22)
	_expect_font_size(problems, desktop, "Caption", "font_size", 12)
	_expect_font_size(problems, mobile, "Caption", "font_size", 14)
	_expect_font_size(problems, desktop, "Kicker", "font_size", 12)
	_expect_font_size(problems, mobile, "Kicker", "font_size", 13)
	_expect_constant(problems, desktop, "FileDialog", "thumbnail_size", 96)
	_expect_constant(problems, mobile, "FileDialog", "thumbnail_size", 128)
	_expect_constant(problems, desktop, "Button", "h_separation", 8)
	_expect_constant(problems, mobile, "Button", "h_separation", 12)

	var desktop_button := _stylebox_flat(desktop, "Button", "normal")
	var mobile_button := _stylebox_flat(mobile, "Button", "normal")
	if desktop_button == null or mobile_button == null:
		problems.append("Button.normal stylebox missing on desktop or mobile")
	else:
		if mobile_button.content_margin_top <= desktop_button.content_margin_top:
			problems.append("Button.normal mobile vertical margin must exceed desktop")
		if _radius_tuple(mobile_button) != _radius_tuple(desktop_button):
			problems.append("Button.normal radius changed across desktop/mobile")
	var desktop_focus := _stylebox_flat(desktop, "Button", "focus")
	var mobile_focus := _stylebox_flat(mobile, "Button", "focus")
	if desktop_focus == null or mobile_focus == null:
		problems.append("Button.focus stylebox missing on desktop or mobile")
	else:
		if desktop_focus.border_width_left != mobile_focus.border_width_left:
			problems.append("focus border width changed across desktop/mobile")
	if not auto_theme.has_stylebox("normal", "Button"):
		problems.append("AUTO did not resolve/regenerate representative Button.normal")

	_append_raised_platform_orthogonality(problems)
	if problems.is_empty():
		_group_ok(group, "DESKTOP, MOBILE, AUTO, typography, spacing, radius, and raised/platform toggles are deterministic")
	else:
		_group_fail(group, "; ".join(problems))

func assert_tap_targets_stage() -> void:
	var group := "tap-targets"
	var problems: Array[String] = []
	var script := load(TAP_AUDIT_PATH)
	if script == null:
		_group_fail(group, "tap-target audit helper did not load")
		return
	var result: Dictionary = script.run_audit()
	if int(result.get("failures", 0)) > 0:
		for row: Dictionary in result.get("rows", []):
			if String(row.get("status", "")) == "FAIL":
				problems.append("%s raised=%s %s %.1fx%.1f %s" % [
					row.get("direction", ""),
					str(row.get("raised", false)),
					row.get("type", ""),
					float(row.get("width_proxy", 0)),
					float(row.get("height_proxy", 0)),
					row.get("notes", "")
				])
	var directions: Dictionary = {}
	var raised_values: Dictionary = {}
	var row_count := 0
	for row: Dictionary in result.get("rows", []):
		directions[String(row.get("direction", ""))] = true
		raised_values[str(row.get("raised", false))] = true
		row_count += 1
	if directions.size() != APPROVED_DIRECTIONS.size():
		problems.append("audit did not cover all five directions, got %s" % str(directions.keys()))
	if not (raised_values.has("false") and raised_values.has("true")):
		problems.append("audit did not cover both raised=false and raised=true")
	if row_count != APPROVED_DIRECTIONS.size() * 2 * SCORECARD_37_TYPES.size():
		problems.append("audit row count expected %d got %d" % [APPROVED_DIRECTIONS.size() * 2 * SCORECARD_37_TYPES.size(), row_count])
	if problems.is_empty():
		_group_ok(group, "forced mobile tap-target audit passes with %d PASS, %d LIMITED, %d N/A, 0 FAIL" % [
			int(result.get("passed", 0)), int(result.get("limited", 0)), int(result.get("na", 0))
		])
	else:
		_group_fail(group, "; ".join(problems))

func assert_docs_stage() -> void:
	_group_pending("docs", "Plan 08-04 owns MOBILE-DESIGN-SPEC.md")

func assert_scene_toggle_stage() -> void:
	_group_pending("scene-toggle", "Plan 08-05 owns runtime toggle proof")

func assert_full_stage() -> void:
	if _pending.is_empty():
		_group_ok("full", "zero pending groups")
	else:
		_group_fail("full", "pending groups remain: %s" % str(_pending))

func _append_one_addon_root_gd(problems: Array[String]) -> void:
	var dir := DirAccess.open("res://addons/neocade_theme")
	if dir == null:
		problems.append("cannot open addon root")
		return
	var files: Array[String] = []
	dir.list_dir_begin()
	var name := dir.get_next()
	while name != "":
		if not dir.current_is_dir() and name.ends_with(".gd"):
			files.append(name)
		name = dir.get_next()
	dir.list_dir_end()
	files.sort()
	if files != ["neocade_theme.gd"]:
		problems.append("addon root .gd files expected [neocade_theme.gd], got %s" % str(files))

func _append_public_export_lock(problems: Array[String]) -> void:
	var found: Array[String] = []
	for line in _read_file(PRODUCTION_GD).split("\n"):
		var s := line.strip_edges()
		if s.begins_with("@export var "):
			found.append(s.substr("@export var ".length()).split(":", true, 1)[0].strip_edges())
	if found != EXPECTED_EXPORTS:
		problems.append("public exports drifted expected=%s actual=%s" % [str(EXPECTED_EXPORTS), str(found)])

func _append_forbidden_source_tokens(problems: Array[String]) -> void:
	var source := _read_production_source_non_comment()
	for token in ["Theme.clear(", ".clear(", "set_theme(null)"]:
		if source.find(token) != -1:
			problems.append("forbidden production reset call found: %s" % token)

func _append_forbidden_resources(problems: Array[String]) -> void:
	for path in [ROOT_FALLBACK_PATH, MOBILE_FALLBACK_PATH]:
		if FileAccess.file_exists(path):
			problems.append("forbidden resource exists: %s" % path)
	for forbidden_dir in ["res://addons/neocade_theme/_dev", "res://addons/neocade_theme/themes"]:
		if DirAccess.dir_exists_absolute(forbidden_dir):
			problems.append("forbidden addon directory exists: %s" % forbidden_dir)

func _append_direction_resource_shape(problems: Array[String]) -> void:
	for path in APPROVED_DIRECTIONS.values():
		var theme := _load_direction(path)
		if theme == null:
			problems.append("%s did not load as NeoCadeTheme" % path)
			continue
		var text := _read_file(path)
		if text.find("script = ExtResource(") == -1 or text.find("neocade_theme.gd") == -1:
			problems.append("%s missing single script linkage" % path)
		if text.find("[sub_resource") != -1:
			problems.append("%s contains [sub_resource]" % path)
		for key in EXPECTED_EXPORTS:
			if text.find(key + " = ") == -1:
				problems.append("%s missing explicit export %s" % [path, key])

func _load_direction(path: String) -> NeoCadeTheme:
	var loaded := ResourceLoader.load(path, "", ResourceLoader.CACHE_MODE_IGNORE)
	if loaded is NeoCadeTheme:
		return loaded
	return null

func _configured_theme(platform_value: NeoCadeTheme.Platform, raised_value: bool) -> NeoCadeTheme:
	var base := _load_direction(PULSE_PATH)
	if base == null:
		return null
	var theme: NeoCadeTheme = base.duplicate(true)
	theme.raised = raised_value
	theme.platform = platform_value
	return theme

func _append_raised_platform_orthogonality(problems: Array[String]) -> void:
	var desktop_flat := _configured_theme(NeoCadeTheme.Platform.DESKTOP, false)
	var desktop_raised := _configured_theme(NeoCadeTheme.Platform.DESKTOP, true)
	var mobile_flat := _configured_theme(NeoCadeTheme.Platform.MOBILE, false)
	var mobile_raised := _configured_theme(NeoCadeTheme.Platform.MOBILE, true)
	var combos := {
		"raised=false/platform=DESKTOP": desktop_flat,
		"raised=true/platform=DESKTOP": desktop_raised,
		"raised=false/platform=MOBILE": mobile_flat,
		"raised=true/platform=MOBILE": mobile_raised,
	}
	for combo in combos.keys():
		var theme: NeoCadeTheme = combos[combo]
		if theme == null:
			problems.append("%s did not create a theme" % combo)
			continue
		for type_name in ["Button", "LineEdit", "Tree"]:
			if not _theme_type_has_any_entry(theme, type_name):
				problems.append("%s lost representative %s entries" % [combo, type_name])
	var flat_sb := _stylebox_flat(desktop_flat, "Button", "normal")
	var raised_sb := _stylebox_flat(desktop_raised, "Button", "normal")
	if flat_sb == null or raised_sb == null:
		problems.append("raised/platform check missing Button.normal")
	else:
		if flat_sb.shadow_size != -1:
			problems.append("raised=false/platform=DESKTOP expected no-shadow sentinel -1 got %d" % flat_sb.shadow_size)
		if raised_sb.shadow_size <= 0 or raised_sb.shadow_offset.y <= 0:
			problems.append("raised=true/platform=DESKTOP expected positive hard offset")
	var desktop_raised_button := _stylebox_flat(desktop_raised, "Button", "normal")
	var mobile_raised_button := _stylebox_flat(mobile_raised, "Button", "normal")
	var desktop_flat_button := _stylebox_flat(desktop_flat, "Button", "normal")
	var mobile_flat_button := _stylebox_flat(mobile_flat, "Button", "normal")
	if desktop_raised_button != null and mobile_raised_button != null:
		if mobile_raised_button.content_margin_top <= desktop_raised_button.content_margin_top:
			problems.append("mobile raised Button margin must exceed desktop raised")
	if desktop_flat_button != null and mobile_flat_button != null:
		if mobile_flat_button.content_margin_top <= desktop_flat_button.content_margin_top:
			problems.append("mobile flat Button margin must exceed desktop flat")
	var toggled := _configured_theme(NeoCadeTheme.Platform.DESKTOP, true)
	if toggled != null:
		toggled.platform = NeoCadeTheme.Platform.MOBILE
		toggled.platform = NeoCadeTheme.Platform.DESKTOP
		toggled.platform = NeoCadeTheme.Platform.MOBILE
		for type_name in ["Button", "LineEdit", "Tree"]:
			if not _theme_type_has_any_entry(toggled, type_name):
				problems.append("repeated platform toggles after raised removed %s entries" % type_name)

func _expect_equal(problems: Array[String], label: String, actual: int, expected: int) -> void:
	if actual != expected:
		problems.append("%s expected %d got %d" % [label, expected, actual])

func _expect_font_size(problems: Array[String], theme: Theme, type_name: String, slot: String, expected: int) -> void:
	if not theme.has_font_size(slot, type_name):
		problems.append("%s.%s font_size missing" % [type_name, slot])
		return
	_expect_equal(problems, "%s.%s" % [type_name, slot], theme.get_font_size(slot, type_name), expected)

func _expect_constant(problems: Array[String], theme: Theme, type_name: String, slot: String, expected: int) -> void:
	if not theme.has_constant(slot, type_name):
		problems.append("%s.%s constant missing" % [type_name, slot])
		return
	_expect_equal(problems, "%s.%s" % [type_name, slot], theme.get_constant(slot, type_name), expected)

func _stylebox_flat(theme: Theme, type_name: String, slot: String) -> StyleBoxFlat:
	if theme == null or not theme.has_stylebox(slot, type_name):
		return null
	var sb := theme.get_stylebox(slot, type_name)
	return sb as StyleBoxFlat

func _radius_tuple(sb: StyleBoxFlat) -> Array[int]:
	return [sb.corner_radius_top_left, sb.corner_radius_top_right, sb.corner_radius_bottom_left, sb.corner_radius_bottom_right]

func _theme_type_has_any_entry(theme: Theme, type_name: String) -> bool:
	return (
		theme.get_stylebox_list(type_name).size() > 0
		or theme.get_color_list(type_name).size() > 0
		or theme.get_constant_list(type_name).size() > 0
		or theme.get_font_list(type_name).size() > 0
		or theme.get_font_size_list(type_name).size() > 0
		or theme.get_icon_list(type_name).size() > 0
	)

func _read_file(path: String) -> String:
	var f := FileAccess.open(path, FileAccess.READ)
	if f == null:
		return ""
	var text := f.get_as_text()
	f.close()
	return text

func _read_production_source_non_comment() -> String:
	var out: PackedStringArray = []
	for line in _read_file(PRODUCTION_GD).split("\n"):
		var index := line.find("#")
		out.append(line.substr(0, index) if index >= 0 else line)
	return "\n".join(out)

func _group_ok(group: String, detail: String) -> void:
	print("PHASE8_GROUP_OK:%s ENFORCED  %s" % [group, detail])
	_ok.append(group)

func _group_pending(group: String, detail: String) -> void:
	if _stage == "full":
		print("PHASE8_GROUP_FAIL:%s FULL pending  %s" % [group, detail])
		_failures.append("%s pending in full stage: %s" % [group, detail])
		return
	print("PHASE8_GROUP_PENDING:%s  %s" % [group, detail])
	_pending.append(group)

func _group_fail(group: String, detail: String) -> void:
	print("PHASE8_GROUP_FAIL:%s  %s" % [group, detail])
	_failures.append("%s -- %s" % [group, detail])

func _emit_summary_and_quit() -> void:
	print("----- PHASE8_VERIFY summary -----")
	print("  stage:          %s" % _stage)
	print("  groups OK:      %d" % _ok.size())
	print("  groups PENDING: %d  %s" % [_pending.size(), str(_pending)])
	print("  failures:       %d" % _failures.size())
	for f in _failures:
		print("    - %s" % f)
	print("---------------------------------")
	if not _failures.is_empty():
		quit(1)
		return
	print("PHASE8_VERIFY OK (stage=%s)" % _stage)
	quit(0)
