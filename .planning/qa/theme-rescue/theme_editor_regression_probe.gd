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
		_expect_resource_picker_surface_matches_value_cell(theme, label)
		_expect_editor_fonts_authored(theme, label)
		_expect_checkbutton_checkbox_scale(theme, label)
		_expect_selection_control_colors(theme, label)
		_expect_popup_selection_icons(theme, label)

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
	var subsection_color := theme.get_color(&"prop_subsection", &"Editor")
	if subsection_color.a > 0.01:
		_fail("%s Editor.prop_subsection must stay transparent because TreeItem custom_bg_color fills the full row" % label)

	var section := theme.get_stylebox(&"prop_subsection_stylebox", &"Editor") as StyleBoxFlat
	if section == null:
		_fail("%s Editor.prop_subsection_stylebox missing StyleBoxFlat" % label)
		return
	if section.border_width_left < 1 or section.border_width_right < 1:
		_fail("%s Editor.prop_subsection_stylebox should reserve transparent side spacing" % label)
	if section.border_color.a > 0.01:
		_fail("%s Editor.prop_subsection_stylebox side reservation should be transparent" % label)
	if section.content_margin_left < 6.0 or section.content_margin_right < 6.0:
		_fail("%s Editor.prop_subsection_stylebox side padding too small: %.1f/%.1f" % [
			label,
			section.content_margin_left,
			section.content_margin_right,
		])

func _expect_resource_picker_surface_matches_value_cell(theme: Theme, label: String) -> void:
	var tree_panel := theme.get_stylebox(&"panel", &"Tree") as StyleBoxFlat
	var value_cell := theme.get_stylebox(&"child_bg", &"EditorProperty") as StyleBoxFlat
	if tree_panel == null or value_cell == null:
		_fail("%s Tree.panel / EditorProperty.child_bg missing StyleBoxFlat" % label)
		return
	if _color_distance(tree_panel.bg_color, value_cell.bg_color) > 0.01:
		_fail("%s Tree.panel should match inspector value cell bg, got %s vs %s" % [
			label,
			tree_panel.bg_color.to_html(true),
			value_cell.bg_color.to_html(true),
		])


func _expect_editor_fonts_authored(theme: Theme, label: String) -> void:
	for font_name in [&"main", &"bold", &"title"]:
		if not theme.has_font(font_name, &"EditorFonts"):
			_fail("%s EditorFonts.%s missing" % [label, font_name])
	for size_name in [&"main_size", &"bold_size", &"title_size"]:
		if not theme.has_font_size(size_name, &"EditorFonts"):
			_fail("%s EditorFonts.%s missing" % [label, size_name])


func _expect_checkbutton_checkbox_scale(theme: Theme, label: String) -> void:
	var checkbox := theme.get_icon(&"checked", &"CheckBox")
	var checkbutton := theme.get_icon(&"checked", &"CheckButton")
	if checkbox == null or checkbutton == null:
		_fail("%s checkbox/checkbutton icon missing" % label)
		return
	if checkbutton.get_height() < 20.0 or checkbutton.get_width() < 34.0:
		_fail("%s CheckButton icon should use the enlarged compact switch footprint, got %s" % [
			label,
			checkbutton.get_size(),
		])


func _expect_selection_control_colors(theme: Theme, label: String) -> void:
	var accent := theme.get_color(&"checkbox_checked_color", &"CheckBox")
	var checkbox_off := theme.get_color(&"checkbox_unchecked_color", &"CheckBox")
	var checkbutton_on := theme.get_color(&"button_checked_color", &"CheckButton")
	var checkbutton_off := theme.get_color(&"button_unchecked_color", &"CheckButton")
	var button_normal := (theme.get_stylebox(&"normal", &"Button") as StyleBoxFlat).bg_color
	if not checkbutton_on.is_equal_approx(accent):
		_fail("%s CheckBox and CheckButton checked fills should match accent" % label)
	if checkbox_off.get_luminance() <= button_normal.get_luminance() + 0.03:
		_fail("%s CheckBox unchecked fill should be visibly lighter than Button.normal" % label)
	if checkbutton_off.get_luminance() <= button_normal.get_luminance() + 0.03:
		_fail("%s CheckButton unchecked fill should be visibly lighter than Button.normal" % label)
	if _color_distance(checkbox_off, checkbutton_off) > 0.01:
		_fail("%s CheckBox and CheckButton unchecked fills should match" % label)


func _expect_popup_selection_icons(theme: Theme, label: String) -> void:
	if not NeoCadeTheme.ENABLE_RUNTIME_POPUP_SELECTION_ICONS:
		return
	var accent := theme.get_color(&"checkbox_checked_color", &"CheckBox")
	var inactive := theme.get_color(&"checkbox_unchecked_color", &"CheckBox")
	var popup_checked := _sample_icon(theme, &"PopupMenu", &"checked", Vector2i(6, 6))
	var popup_unchecked := _sample_icon(theme, &"PopupMenu", &"unchecked", Vector2i(6, 6))
	var popup_radio_checked := _sample_icon(theme, &"PopupMenu", &"radio_checked", Vector2i(12, 6))
	var popup_radio_unchecked := _sample_icon(theme, &"PopupMenu", &"radio_unchecked", Vector2i(12, 12))
	if _color_distance(popup_checked, accent) > 0.08:
		_fail("%s PopupMenu checked icon should embed accent fill, got %s" % [label, popup_checked.to_html(true)])
	if _color_distance(popup_unchecked, inactive) > 0.08:
		_fail("%s PopupMenu unchecked icon should embed inactive fill, got %s" % [label, popup_unchecked.to_html(true)])
	if _color_distance(popup_radio_checked, accent) > 0.08:
		_fail("%s PopupMenu radio_checked icon should embed accent fill, got %s" % [label, popup_radio_checked.to_html(true)])
	if _color_distance(popup_radio_unchecked, inactive) > 0.08:
		_fail("%s PopupMenu radio_unchecked icon should embed inactive fill, got %s" % [label, popup_radio_unchecked.to_html(true)])


func _sample_icon(theme: Theme, theme_type: StringName, slot: StringName, point: Vector2i) -> Color:
	var icon := theme.get_icon(slot, theme_type)
	if icon == null:
		_fail("%s.%s icon missing" % [theme_type, slot])
		return Color.TRANSPARENT
	var image := icon.get_image()
	if image == null:
		_fail("%s.%s icon image unavailable" % [theme_type, slot])
		return Color.TRANSPARENT
	return image.get_pixelv(point)


func _color_distance(a: Color, b: Color) -> float:
	return absf(a.r - b.r) + absf(a.g - b.g) + absf(a.b - b.b) + absf(a.a - b.a)


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
