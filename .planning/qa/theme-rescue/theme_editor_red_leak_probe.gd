extends SceneTree

const THEME_PATH := "res://addons/neocade_theme/neocade_theme.tres"
const OUTPUT_PATH := "res://.planning/qa/theme-rescue/theme-editor-sentinel-leaks.log"
const BASE_SENTINEL := Color("#ff00ff")
const ACCENT_SENTINEL := Color("#00ffff")
const BASE_SETTING := "interface/theme/base_color"
const ACCENT_SETTING := "interface/theme/accent_color"

var _lines: PackedStringArray = []
var _failures: PackedStringArray = []
var _custom_theme: Theme
var _editor_theme: Theme
var _editor_settings: Object


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	_custom_theme = load(THEME_PATH) as NeoCadeTheme
	if _custom_theme == null:
		_fail("Could not load %s as NeoCadeTheme" % THEME_PATH)
		_finish()
		return

	var editor_interface := Engine.get_singleton("EditorInterface") if Engine.has_singleton("EditorInterface") else null
	if editor_interface == null:
		_fail("EditorInterface unavailable; run this probe with --editor")
		_finish()
		return
	if editor_interface.has_method("get_editor_settings"):
		_editor_settings = editor_interface.call("get_editor_settings")
	if editor_interface.has_method("get_editor_theme"):
		_editor_theme = editor_interface.call("get_editor_theme") as Theme
	if _editor_theme == null:
		_fail("EditorInterface.get_editor_theme unavailable")
		_finish()
		return

	_expect_sentinel_editor_settings()

	_lines.append("# Expected temporary editor sentinels")
	_lines.append("# %s = %s" % [BASE_SETTING, BASE_SENTINEL.to_html(false)])
	_lines.append("# %s = %s" % [ACCENT_SETTING, ACCENT_SENTINEL.to_html(false)])
	_lines.append("")
	_lines.append("# Merged editor theme sentinel slots not authored by NeoCade")
	_scan_merged_theme()

	_lines.append("")
	_lines.append("# Live editor Control tree sentinel resolved values")
	var base_control := editor_interface.call("get_base_control") as Control
	if base_control != null:
		_scan_control_tree(base_control, base_control.get_path())

	_lines.sort()
	_write_log(OUTPUT_PATH, _lines)
	var found_leak := false
	for line in _lines:
		if line.begins_with("LEAK "):
			found_leak = true
			print(line)
	if found_leak:
		_fail("Editor sentinel leakage detected; see %s" % OUTPUT_PATH)
	_finish()


func _expect_sentinel_editor_settings() -> void:
	if _editor_settings == null:
		_fail("Editor settings unavailable; cannot verify temporary sentinel colors")
		return
	var current_base: Color = _editor_settings.call("get_setting", BASE_SETTING)
	var current_accent: Color = _editor_settings.call("get_setting", ACCENT_SETTING)
	if _distance(Color(current_base.r, current_base.g, current_base.b, 1.0), BASE_SENTINEL) > 0.02:
		_fail("Set %s to #%s before running this probe; current=%s" % [
			BASE_SETTING,
			BASE_SENTINEL.to_html(false),
			current_base.to_html(true),
		])
	if _distance(Color(current_accent.r, current_accent.g, current_accent.b, 1.0), ACCENT_SENTINEL) > 0.02:
		_fail("Set %s to #%s before running this probe; current=%s" % [
			ACCENT_SETTING,
			ACCENT_SENTINEL.to_html(false),
			current_accent.to_html(true),
		])


func _scan_merged_theme() -> void:
	for theme_type in _editor_theme.get_type_list():
		for slot_name in _editor_theme.get_color_list(theme_type):
			var color := _editor_theme.get_color(slot_name, theme_type)
			var sentinel := _sentinel_label(color)
			if sentinel != "" and not _custom_theme.has_color(slot_name, theme_type):
				_lines.append("LEAK theme_color source=%s %s.%s=%s" % [
					sentinel,
					theme_type,
					slot_name,
					color.to_html(true),
				])
		for slot_name in _editor_theme.get_stylebox_list(theme_type):
			var stylebox := _editor_theme.get_stylebox(slot_name, theme_type)
			if not (stylebox is StyleBoxFlat):
				continue
			var flat := stylebox as StyleBoxFlat
			if _custom_theme.has_stylebox(slot_name, theme_type):
				continue
			var bg_sentinel := _sentinel_label(flat.bg_color)
			var border_sentinel := _sentinel_label(flat.border_color)
			if bg_sentinel != "" or border_sentinel != "":
				_lines.append("LEAK theme_stylebox bg_source=%s border_source=%s %s.%s bg=%s border=%s" % [
					bg_sentinel,
					border_sentinel,
					theme_type,
					slot_name,
					flat.bg_color.to_html(true),
					flat.border_color.to_html(true),
				])


func _scan_control_tree(control: Control, path: NodePath) -> void:
	var control_class := control.get_class()
	var variation := control.theme_type_variation
	var type_names: Array[StringName] = []
	if variation != &"":
		type_names.append(variation)
	type_names.append(StringName(control_class))
	var editor_types := _editor_theme.get_type_list()

	for type_name in type_names:
		if not editor_types.has(type_name):
			continue
		for slot_name in _editor_theme.get_color_list(type_name):
			var color := control.get_theme_color(slot_name, type_name)
			var sentinel := _sentinel_label(color)
			if sentinel != "" and not _custom_theme.has_color(slot_name, type_name):
				_lines.append("LEAK control_color source=%s path=%s class=%s variation=%s type=%s slot=%s value=%s" % [
					sentinel,
					path,
					control_class,
					variation,
					type_name,
					slot_name,
					color.to_html(true),
				])
		for slot_name in _editor_theme.get_stylebox_list(type_name):
			var stylebox := control.get_theme_stylebox(slot_name, type_name)
			if not (stylebox is StyleBoxFlat):
				continue
			if _custom_theme.has_stylebox(slot_name, type_name):
				continue
			var flat := stylebox as StyleBoxFlat
			var bg_sentinel := _sentinel_label(flat.bg_color)
			var border_sentinel := _sentinel_label(flat.border_color)
			if bg_sentinel != "" or border_sentinel != "":
				_lines.append("LEAK control_stylebox bg_source=%s border_source=%s path=%s class=%s variation=%s type=%s slot=%s bg=%s border=%s" % [
					bg_sentinel,
					border_sentinel,
					path,
					control_class,
					variation,
					type_name,
					slot_name,
					flat.bg_color.to_html(true),
					flat.border_color.to_html(true),
				])

	for child in control.get_children():
		if child is Control:
			_scan_control_tree(child, child.get_path())


func _sentinel_label(color: Color) -> String:
	if color.a < 0.05:
		return ""
	var normalized := Color(color.r, color.g, color.b, 1.0)
	if _distance(normalized, BASE_SENTINEL) <= 0.08 or _is_magenta_family(normalized):
		return "base"
	if _distance(normalized, ACCENT_SENTINEL) <= 0.08 or _is_cyan_family(normalized):
		return "accent"
	return ""


func _is_magenta_family(color: Color) -> bool:
	var max_channel := maxf(color.r, maxf(color.g, color.b))
	if max_channel < 0.22:
		return false
	return color.r >= max_channel * 0.82 and color.b >= max_channel * 0.82 and color.g <= max_channel * 0.28


func _is_cyan_family(color: Color) -> bool:
	var max_channel := maxf(color.r, maxf(color.g, color.b))
	if max_channel < 0.22:
		return false
	return color.g >= max_channel * 0.82 and color.b >= max_channel * 0.82 and color.r <= max_channel * 0.28


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
	print("THEME_EDITOR_SENTINEL_LEAK_PROBE: wrote %s" % path)


func _fail(message: String) -> void:
	_failures.append(message)
	printerr("THEME_EDITOR_SENTINEL_LEAK_PROBE_FAIL: %s" % message)


func _finish() -> void:
	if _failures.is_empty():
		print("THEME_EDITOR_SENTINEL_LEAK_PROBE: PASS")
		quit(0)
	else:
		for message in _failures:
			printerr(message)
		quit(1)
