extends SceneTree

const THEME_PATH := "res://addons/neocade_theme/neocade_theme.tres"
const OUTPUT_PATH := "res://.planning/qa/theme-rescue/theme-editor-merge-leaks.log"
const SPLIT_OUTPUT_PATH := "res://.planning/qa/theme-rescue/theme-editor-merge-split.log"

var _failures: PackedStringArray = []


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var custom := load(THEME_PATH) as NeoCadeTheme
	if custom == null:
		_fail("Could not load %s as NeoCadeTheme" % THEME_PATH)
		_finish()
		return
	custom.style = NeoCadeTheme.Style.PULSE
	custom.raised = false
	custom.platform = NeoCadeTheme.Platform.DESKTOP

	var editor_theme: Theme = null
	if Engine.has_singleton("EditorInterface"):
		var editor_interface := Engine.get_singleton("EditorInterface")
		if editor_interface != null and editor_interface.has_method("get_editor_theme"):
			editor_theme = editor_interface.call("get_editor_theme") as Theme

	if editor_theme == null:
		print("THEME_EDITOR_MERGE_LEAK_PROBE: SKIP EditorInterface.get_editor_theme unavailable; run with --editor for merged editor-theme leak scan")
		_finish()
		return

	var leak_lines: PackedStringArray = []
	var split_lines: PackedStringArray = []
	_scan_merged_colors(editor_theme, custom, leak_lines)
	_scan_merged_styleboxes(editor_theme, custom, leak_lines)
	_scan_split_container(editor_theme, custom, split_lines)

	leak_lines.sort()
	_write_log(OUTPUT_PATH, leak_lines)
	_write_log(SPLIT_OUTPUT_PATH, split_lines)
	for line in leak_lines:
		print(line)
	if leak_lines.size() > 0:
		_fail("Merged editor theme has %d white/black candidate slots not authored by NeoCade" % leak_lines.size())

	_finish()


func _scan_merged_colors(editor_theme: Theme, custom: Theme, leak_lines: PackedStringArray) -> void:
	for theme_type in editor_theme.get_type_list():
		for slot_name in editor_theme.get_color_list(theme_type):
			var color := editor_theme.get_color(slot_name, theme_type)
			if not _is_sentinel_color(color):
				continue
			if custom.has_color(slot_name, theme_type):
				continue
			leak_lines.append("LEAK color %s.%s=%s" % [theme_type, slot_name, color.to_html(true)])


func _scan_merged_styleboxes(editor_theme: Theme, custom: Theme, leak_lines: PackedStringArray) -> void:
	for theme_type in editor_theme.get_type_list():
		for slot_name in editor_theme.get_stylebox_list(theme_type):
			var stylebox := editor_theme.get_stylebox(slot_name, theme_type)
			if not (stylebox is StyleBoxFlat):
				continue
			var flat := stylebox as StyleBoxFlat
			if not (_is_sentinel_color(flat.bg_color) or _is_sentinel_color(flat.border_color)):
				continue
			if custom.has_stylebox(slot_name, theme_type):
				continue
			leak_lines.append("LEAK stylebox %s.%s bg=%s border=%s" % [
				theme_type,
				slot_name,
				flat.bg_color.to_html(true),
				flat.border_color.to_html(true),
			])


func _scan_split_container(editor_theme: Theme, custom: Theme, split_lines: PackedStringArray) -> void:
	for theme_type in [&"SplitContainer", &"HSplitContainer", &"VSplitContainer"]:
		split_lines.append("SPLIT %s custom_has_bg=%s editor_has_bg=%s custom_sep=%s editor_sep=%s custom_min=%s editor_min=%s custom_autohide=%s editor_autohide=%s" % [
			theme_type,
			custom.has_stylebox(&"split_bar_background", theme_type),
			editor_theme.has_stylebox(&"split_bar_background", theme_type),
			custom.get_constant(&"separation", theme_type) if custom.has_constant(&"separation", theme_type) else "<missing>",
			editor_theme.get_constant(&"separation", theme_type) if editor_theme.has_constant(&"separation", theme_type) else "<missing>",
			custom.get_constant(&"minimum_grab_thickness", theme_type) if custom.has_constant(&"minimum_grab_thickness", theme_type) else "<missing>",
			editor_theme.get_constant(&"minimum_grab_thickness", theme_type) if editor_theme.has_constant(&"minimum_grab_thickness", theme_type) else "<missing>",
			custom.get_constant(&"autohide", theme_type) if custom.has_constant(&"autohide", theme_type) else "<missing>",
			editor_theme.get_constant(&"autohide", theme_type) if editor_theme.has_constant(&"autohide", theme_type) else "<missing>",
		])
		for slot_name in [&"grabber", &"h_grabber", &"v_grabber", &"touch_dragger", &"h_touch_dragger", &"v_touch_dragger"]:
			split_lines.append("SPLIT_ICON %s.%s custom=%s editor=%s custom_size=%s editor_size=%s" % [
				theme_type,
				slot_name,
				custom.has_icon(slot_name, theme_type),
				editor_theme.has_icon(slot_name, theme_type),
				custom.get_icon(slot_name, theme_type).get_size() if custom.has_icon(slot_name, theme_type) else "<missing>",
				editor_theme.get_icon(slot_name, theme_type).get_size() if editor_theme.has_icon(slot_name, theme_type) else "<missing>",
			])


func _is_sentinel_color(color: Color) -> bool:
	if color.a < 0.05:
		return false
	var rgb := Color(color.r, color.g, color.b, 1.0)
	return _distance(rgb, Color.WHITE) <= 0.02 or _distance(rgb, Color.BLACK) <= 0.02


func _distance(a: Color, b: Color) -> float:
	return absf(a.r - b.r) + absf(a.g - b.g) + absf(a.b - b.b)


func _write_log(path: String, lines: PackedStringArray) -> void:
	var absolute_path := ProjectSettings.globalize_path(path)
	DirAccess.make_dir_recursive_absolute(absolute_path.get_base_dir())
	var file := FileAccess.open(absolute_path, FileAccess.WRITE)
	if file == null:
		_fail("Could not write %s error=%s" % [absolute_path, FileAccess.get_open_error()])
		return
	file.store_string("\n".join(lines) + "\n")
	file.close()
	print("THEME_EDITOR_MERGE_LEAK_PROBE: wrote %s" % path)


func _fail(message: String) -> void:
	_failures.append(message)
	printerr("THEME_EDITOR_MERGE_LEAK_PROBE_FAIL: %s" % message)


func _finish() -> void:
	if _failures.is_empty():
		print("THEME_EDITOR_MERGE_LEAK_PROBE: PASS")
		quit(0)
	else:
		for message in _failures:
			printerr(message)
		quit(1)
