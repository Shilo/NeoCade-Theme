extends SceneTree

const THEME_PATH := "res://addons/neocade_theme/neocade_theme.tres"

var _failures: PackedStringArray = []


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var theme := load(THEME_PATH) as NeoCadeTheme
	if theme == null:
		_fail("Could not load %s as NeoCadeTheme" % THEME_PATH)
		_finish()
		return

	for style_value in NeoCadeTheme.Style.values():
		if style_value == NeoCadeTheme.Style.CUSTOM:
			continue
		theme.style = style_value
		theme.raised = false
		theme.platform = NeoCadeTheme.Platform.DESKTOP
		var label: String = str(NeoCadeTheme.Style.find_key(style_value))
		_expect_focus_viewport_outline_only(theme, label)
		_expect_editor_subsection_padding(theme, label)
		_expect_tree_table_header_side_reservation(theme, label)

	_finish()


func _expect_focus_viewport_outline_only(theme: Theme, label: String) -> void:
	var focus := theme.get_stylebox(&"FocusViewport", &"EditorStyles") as StyleBoxFlat
	if focus == null:
		_fail("%s EditorStyles.FocusViewport missing StyleBoxFlat" % label)
		return
	if focus.bg_color.a > 0.01:
		_fail("%s EditorStyles.FocusViewport must not fill viewport, bg=%s" % [label, focus.bg_color])
	if focus.border_width_left < 1 or focus.border_color.a <= 0.01:
		_fail("%s EditorStyles.FocusViewport should keep a visible outline" % label)


func _expect_editor_subsection_padding(theme: Theme, label: String) -> void:
	var section := theme.get_stylebox(&"prop_subsection_stylebox", &"Editor") as StyleBoxFlat
	if section == null:
		_fail("%s Editor.prop_subsection_stylebox missing StyleBoxFlat" % label)
		return
	if section.border_width_left != 0 or section.border_width_right != 0:
		_fail("%s Editor.prop_subsection_stylebox should use padding, not side rails" % label)
	if section.content_margin_left < 6.0 or section.content_margin_right < 6.0:
		_fail("%s Editor.prop_subsection_stylebox side padding too small: %.1f/%.1f" % [
			label,
			section.content_margin_left,
			section.content_margin_right,
		])


func _expect_tree_table_header_side_reservation(theme: Theme, label: String) -> void:
	var header := theme.get_stylebox(&"title_button_normal", &"TreeTable") as StyleBoxFlat
	if header == null:
		_fail("%s TreeTable.title_button_normal missing StyleBoxFlat" % label)
		return
	if header.border_width_left < 1 or header.border_width_right < 1:
		_fail("%s TreeTable.title_button_normal should reserve 1px side edge" % label)
	if header.border_color.a > 0.01:
		_fail("%s TreeTable.title_button_normal side reservation should be transparent" % label)


func _fail(message: String) -> void:
	_failures.append(message)
	printerr("THEME_EDITOR_REGRESSION_PROBE_FAIL: %s" % message)


func _finish() -> void:
	if _failures.is_empty():
		print("THEME_EDITOR_REGRESSION_PROBE: PASS")
		quit(0)
	else:
		for message in _failures:
			printerr(message)
		quit(1)
