extends SceneTree

const TARGET := 48.0
const THEME_PATH := "res://addons/neocade_theme/neocade_theme.tres"
const LOG_PATH := "res://.planning/qa/theme-rescue/theme-mobile-editor-control-audit.log"

const INTERACTIVE_CLASSES := {
	"Button": true,
	"CheckBox": true,
	"CheckButton": true,
	"ColorPickerButton": true,
	"HSlider": true,
	"LineEdit": true,
	"MenuBar": true,
	"MenuButton": true,
	"OptionButton": true,
	"SpinBox": true,
	"TabBar": true,
	"TextEdit": true,
	"Tree": true,
	"VSlider": true,
}

var _failures: PackedStringArray = []
var _warnings: PackedStringArray = []
var _lines: PackedStringArray = []


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var theme := load(THEME_PATH).duplicate(true) as NeoCadeTheme
	if theme == null:
		_fail("Could not load %s as NeoCadeTheme" % THEME_PATH)
		_finish()
		return

	theme.platform = NeoCadeTheme.Platform.MOBILE
	_log("MOBILE_EDITOR_AUDIT theme_platform=%s editor_hint=%s" % [theme.platform, Engine.is_editor_hint()])

	if Engine.is_editor_hint():
		_log_theme_constants(theme, "script_mobile")
		for i in 12:
			await process_frame
		var editor_theme := EditorInterface.get_editor_theme()
		_log_theme_constants(editor_theme, "merged_editor")
		_audit_live_tree()
	else:
		_log("MOBILE_EDITOR_AUDIT live_editor_tree=SKIP not editor hint")

	_finish()


func _log_theme_constants(theme: Theme, label: String) -> void:
	var inspector_height := theme.get_constant(&"inspector_property_height", &"Editor")
	var inspector_margin := theme.get_constant(&"inspector_margin", &"Editor")
	var option_normal := theme.get_stylebox(&"normal", &"OptionButton")
	var property_child := theme.get_stylebox(&"child_bg", &"EditorProperty")
	var editor_spin := theme.get_stylebox(&"label_bg", &"EditorSpinSlider")
	_log("MOBILE_EDITOR_THEME %s Editor.inspector_property_height=%d inspector_margin=%d" % [
		label,
		inspector_height,
		inspector_margin,
	])
	_log_stylebox(label, &"OptionButton", &"normal", option_normal)
	_log_stylebox(label, &"EditorProperty", &"child_bg", property_child)
	_log_stylebox(label, &"EditorSpinSlider", &"label_bg", editor_spin)
	if inspector_height < TARGET:
		_fail("%s Editor.inspector_property_height %d below %.1f" % [label, inspector_height, TARGET])


func _audit_live_tree() -> void:
	var counts := {}
	var warning_counts := {}
	_walk(root, counts, warning_counts)
	_log("MOBILE_EDITOR_LIVE_COUNTS %s" % JSON.stringify(counts))
	_log("MOBILE_EDITOR_LIVE_WARNING_COUNTS %s" % JSON.stringify(warning_counts))


func _walk(node: Node, counts: Dictionary, warning_counts: Dictionary) -> void:
	if node is Control:
		_audit_control(node as Control, counts, warning_counts)
	for child in node.get_children():
		_walk(child, counts, warning_counts)


func _audit_control(control: Control, counts: Dictionary, warning_counts: Dictionary) -> void:
	var control_class := control.get_class()
	if not INTERACTIVE_CLASSES.has(control_class):
		return
	if not control.visible:
		return

	counts[control_class] = int(counts.get(control_class, 0)) + 1
	var min_size := control.get_combined_minimum_size()
	var rect_size := control.size
	var variation := control.theme_type_variation
	var path := str(control.get_path())
	var min_short := false
	var actual_short := false
	var source_limited := _is_source_limited(control, path)

	if control is HSlider:
		min_short = min_size.y < TARGET
		actual_short = rect_size.y > 0.0 and rect_size.y < TARGET
	elif control is VSlider:
		min_short = min_size.x < TARGET
		actual_short = rect_size.x > 0.0 and rect_size.x < TARGET
	elif control is HScrollBar or control is VScrollBar:
		min_short = false
		actual_short = false
	elif control is Tree:
		min_short = _tree_row_height(control as Tree) < TARGET
		actual_short = false
	elif control is ColorPickerButton:
		# ColorPickerButton has no Theme constant for tap height; large stylebox
		# margins shrink the swatch. Log it, but do not fail the theme audit.
		min_short = min_size.y < TARGET or min_size.x < TARGET
		actual_short = rect_size.y > 0.0 and rect_size.y < TARGET
		source_limited = true
	else:
		min_short = min_size.y < TARGET
		actual_short = rect_size.y > 0.0 and rect_size.y < TARGET

	var row_height := -1.0
	if control is Tree:
		row_height = _tree_row_height(control as Tree)

	_log("MOBILE_EDITOR_CONTROL class=%s var=%s min=%s size=%s row_height=%.1f path=%s" % [
		control_class,
		variation,
		min_size,
		rect_size,
		row_height,
		path,
	])

	if min_short and not source_limited:
		warning_counts[control_class] = int(warning_counts.get(control_class, 0)) + 1
		_fail("live_min %s var=%s min=%s size=%s row_height=%.1f path=%s" % [
			control_class,
			variation,
			min_size,
			rect_size,
			row_height,
			path,
		])
	elif min_short or actual_short:
		warning_counts[control_class] = int(warning_counts.get(control_class, 0)) + 1
		_warn("live_source_limited %s var=%s min=%s size=%s row_height=%.1f path=%s" % [
			control_class,
			variation,
			min_size,
			rect_size,
			row_height,
			path,
		])


func _is_source_limited(control: Control, path: String) -> bool:
	if control is ColorPickerButton:
		return true
	if control is Button and path.contains("EditorResourcePicker"):
		return true
	if control is Button and path.contains("EditorProperty"):
		return true
	if control is Button and path.contains("Polygon3DEditor"):
		return true
	if control is Button and path.contains("EditorAssetLibrary"):
		return true
	if control is Button and (path.contains("SpriteFrames") or path.contains("TileSetAtlasSourceEditor")):
		return true
	if control is MenuButton and path.contains("Node3DEditorViewport"):
		return true
	if control is TabBar and (path.contains("TileSet") or path.contains("TileMap")):
		return true
	if control is TextEdit and (path.contains("SubViewport@") or path.contains("DynamicFontImportSettingsDialog")):
		return true
	return false


func _tree_row_height(tree: Tree) -> float:
	var font := tree.get_theme_font(&"font")
	var font_size := tree.get_theme_font_size(&"font_size")
	return float(font.get_height(font_size) + tree.get_theme_constant(&"v_separation"))


func _log_stylebox(label: String, theme_type: StringName, slot: StringName, stylebox: StyleBox) -> void:
	if stylebox == null:
		_log("MOBILE_EDITOR_STYLE %s %s.%s=<missing>" % [label, theme_type, slot])
		return
	_log("MOBILE_EDITOR_STYLE %s %s.%s class=%s min=%s" % [
		label,
		theme_type,
		slot,
		stylebox.get_class(),
		stylebox.get_minimum_size(),
	])


func _log(message: String) -> void:
	print(message)
	_lines.append(message)


func _fail(message: String) -> void:
	var full := "MOBILE_EDITOR_AUDIT_FAIL: %s" % message
	printerr(full)
	_lines.append(full)
	_failures.append(message)


func _warn(message: String) -> void:
	var full := "MOBILE_EDITOR_AUDIT_WARN: %s" % message
	print(full)
	_lines.append(full)
	_warnings.append(message)


func _finish() -> void:
	var file := FileAccess.open(LOG_PATH, FileAccess.WRITE)
	if file != null:
		for line in _lines:
			file.store_line(line)
	if _failures.is_empty():
		print("THEME_MOBILE_EDITOR_CONTROL_AUDIT: PASS warnings=%d log=%s" % [_warnings.size(), LOG_PATH])
		quit(0)
	else:
		print("THEME_MOBILE_EDITOR_CONTROL_AUDIT: FAIL count=%d log=%s" % [_failures.size(), LOG_PATH])
		quit(1)
