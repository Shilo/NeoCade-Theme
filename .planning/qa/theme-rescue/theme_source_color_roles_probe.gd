extends SceneTree

const MIN_CONTRAST := 4.5
const STYLE_PRESETS := {
	NeoCadeTheme.Style.PULSE: Color("#3AA8FF"),
	NeoCadeTheme.Style.DAYBREAK: Color("#76F2D1"),
	NeoCadeTheme.Style.SLATE: Color("#8BD3FF"),
	NeoCadeTheme.Style.BURST: Color("#FFD166"),
	NeoCadeTheme.Style.BUBBLE: Color("#57C7FF"),
}

var _failed := false


func _init() -> void:
	var theme := NeoCadeTheme.new()
	_assert_export_contract(theme)
	for style_value in STYLE_PRESETS.keys():
		theme.style = style_value
		_assert_color_close(theme.source_color, STYLE_PRESETS[style_value], "preset source_color for %s" % NeoCadeTheme.style_label(style_value))
		_assert_role_distinctness(theme, NeoCadeTheme.style_label(style_value))
		_assert_role_contrast(theme, NeoCadeTheme.style_label(style_value))

	theme.style = NeoCadeTheme.Style.PULSE
	var dynamic_fill_slots := [
		["Button", "normal"],
		["OptionButton", "normal"],
		["LineEdit", "normal"],
		["ItemList", "selected"],
		["ProgressBar", "fill"],
		["PositiveButton", "normal"],
	]
	var before_fills := []
	for slot in dynamic_fill_slots:
		before_fills.append(_flat_bg(theme, String(slot[0]), String(slot[1])))
	theme.source_color = Color("#A34DFF")
	for i in range(dynamic_fill_slots.size()):
		var slot: Array = dynamic_fill_slots[i]
		var after := _flat_bg(theme, String(slot[0]), String(slot[1]))
		if before_fills[i].is_equal_approx(after):
			_fail("%s.%s did not change after source_color edit" % [slot[0], slot[1]])

	if _failed:
		print("THEME_SOURCE_COLOR_ROLES_PROBE: FAIL")
		quit(1)
	else:
		print("THEME_SOURCE_COLOR_ROLES_PROBE: PASS")
		quit(0)


func _assert_export_contract(theme: NeoCadeTheme) -> void:
	var props := {}
	for prop in theme.get_property_list():
		props[String(prop.name)] = true
	_assert(props.has("source_color"), "source_color export exists")
	_assert(not props.has("base_color"), "base_color export removed")
	_assert(not props.has("accent_color"), "accent_color export removed")


func _assert_role_distinctness(theme: NeoCadeTheme, label: String) -> void:
	var fills := [
		_flat_bg(theme, "Button", "normal"),
		_flat_bg(theme, "OptionButton", "normal"),
		_flat_bg(theme, "LineEdit", "normal"),
		_flat_bg(theme, "ItemList", "selected"),
		_flat_bg(theme, "ProgressBar", "fill"),
		_flat_bg(theme, "PositiveButton", "normal"),
		_flat_bg(theme, "DangerButton", "normal"),
	]
	var unique_count := 0
	for i in range(fills.size()):
		var unique := true
		for j in range(i):
			if fills[i].is_equal_approx(fills[j]):
				unique = false
				break
		if unique:
			unique_count += 1
	_assert(unique_count >= 5, "%s exposes at least 5 distinct role fills" % label)


func _assert_role_contrast(theme: NeoCadeTheme, label: String) -> void:
	_assert_contrast(theme, label, "Button", "normal", "font_color")
	_assert_contrast(theme, label, "ColorPickerButton", "normal", "font_color")
	_assert_contrast(theme, label, "MenuButton", "normal", "font_color")
	_assert_contrast(theme, label, "OptionButton", "normal", "font_color")
	_assert_contrast(theme, label, "LineEdit", "normal", "font_color")
	_assert_contrast(theme, label, "TextEdit", "normal", "font_color")
	_assert_contrast(theme, label, "ItemList", "selected", "font_selected_color")
	_assert_contrast(theme, label, "Tree", "selected", "font_selected_color")
	_assert_contrast(theme, label, "TabBar", "tab_selected", "font_selected_color")
	_assert_contrast(theme, label, "PopupMenu", "panel", "font_color")
	_assert_contrast(theme, label, "PopupMenu", "hover", "font_hover_color")
	_assert_progress_contrast(theme, label)
	_assert_contrast(theme, label, "PositiveButton", "normal", "font_color")
	_assert_contrast(theme, label, "DangerButton", "normal", "font_color")


func _assert_contrast(theme: NeoCadeTheme, label: String, theme_type: String, stylebox_name: String, color_name: String) -> void:
	var bg := _flat_bg(theme, theme_type, stylebox_name)
	var fg := theme.get_color(color_name, theme_type)
	var ratio := _contrast_ratio(bg, fg)
	_assert(ratio >= MIN_CONTRAST, "%s %s.%s vs %s contrast %.2f" % [label, theme_type, stylebox_name, color_name, ratio])


func _assert_progress_contrast(theme: NeoCadeTheme, label: String) -> void:
	var track := _flat_bg(theme, "ProgressBar", "background")
	var fill := _flat_bg(theme, "ProgressBar", "fill")
	var text := theme.get_color("font_color", "ProgressBar")
	var outline := theme.get_color("font_outline_color", "ProgressBar")
	var track_ratio := _contrast_ratio(track, text)
	var fill_outline_ratio := _contrast_ratio(fill, outline)
	_assert(track_ratio >= MIN_CONTRAST, "%s ProgressBar text vs empty track contrast %.2f" % [label, track_ratio])
	_assert(fill_outline_ratio >= MIN_CONTRAST, "%s ProgressBar outline vs fill contrast %.2f" % [label, fill_outline_ratio])


func _flat_bg(theme: NeoCadeTheme, theme_type: String, stylebox_name: String) -> Color:
	var stylebox := theme.get_stylebox(stylebox_name, theme_type)
	if stylebox is StyleBoxFlat:
		return (stylebox as StyleBoxFlat).bg_color
	_fail("%s.%s is not StyleBoxFlat" % [theme_type, stylebox_name])
	return Color.BLACK


func _assert(condition: bool, message: String) -> void:
	if not condition:
		_fail(message)


func _assert_color_close(actual: Color, expected: Color, message: String) -> void:
	if not actual.is_equal_approx(expected):
		_fail("%s expected=%s actual=%s" % [message, expected.to_html(), actual.to_html()])


func _fail(message: String) -> void:
	_failed = true
	push_error("THEME_SOURCE_COLOR_ROLES_PROBE %s" % message)


func _contrast_ratio(a: Color, b: Color) -> float:
	var a_lum := _relative_luminance(a)
	var b_lum := _relative_luminance(b)
	var lighter: float = maxf(a_lum, b_lum)
	var darker: float = minf(a_lum, b_lum)
	return (lighter + 0.05) / (darker + 0.05)


func _relative_luminance(c: Color) -> float:
	return 0.2126 * _srgb_to_linear(c.r) + 0.7152 * _srgb_to_linear(c.g) + 0.0722 * _srgb_to_linear(c.b)


func _srgb_to_linear(channel: float) -> float:
	return channel / 12.92 if channel <= 0.03928 else pow((channel + 0.055) / 1.055, 2.4)
