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
	_group_pending("platform-tokens", "Plan 08-02 owns forced platform/mobile token assertions")

func assert_tap_targets_stage() -> void:
	_group_pending("tap-targets", "Plan 08-03 owns strict 48px audit closure")

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
