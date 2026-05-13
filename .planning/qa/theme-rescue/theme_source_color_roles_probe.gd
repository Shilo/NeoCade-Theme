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
		_assert_primary_button_semantics(theme, NeoCadeTheme.style_label(style_value))

	theme.style = NeoCadeTheme.Style.PULSE
	var dynamic_fill_slots := [
		["Button", "normal"],
		["OptionButton", "normal"],
		["LineEdit", "normal"],
		["ItemList", "selected"],
		["ProgressBar", "fill"],
		["PrimaryButton", "normal"],
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
	_assert(theme.get_type_variation_base(&"PrimaryButton") == &"Button", "PrimaryButton type variation exists")
	_assert(theme.get_type_variation_base(&"PositiveButton") == &"", "PositiveButton type variation is intentionally absent")
	_assert(theme.get_type_variation_base(&"DangerButton") == &"Button", "DangerButton type variation exists")
	_assert(theme.get_type_variation_base(&"NegativeButton") == &"", "NegativeButton type variation is intentionally absent")
	_assert(theme.get_type_variation_base(&"PanelLabel") == &"Label", "PanelLabel type variation exists")
	_assert(theme.get_type_variation_base(&"DialogLabel") == &"Label", "DialogLabel type variation exists")
	_assert(theme.get_type_variation_base(&"PanelRichTextLabel") == &"RichTextLabel", "PanelRichTextLabel type variation exists")
	_assert(theme.get_type_variation_base(&"DialogRichTextLabel") == &"RichTextLabel", "DialogRichTextLabel type variation exists")


func _assert_role_distinctness(theme: NeoCadeTheme, label: String) -> void:
	var fills := [
		_flat_bg(theme, "Button", "normal"),
		_flat_bg(theme, "OptionButton", "normal"),
		_flat_bg(theme, "LineEdit", "normal"),
		_flat_bg(theme, "ItemList", "selected"),
		_flat_bg(theme, "ProgressBar", "fill"),
		_flat_bg(theme, "PrimaryButton", "normal"),
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
	_assert_contrast(theme, label, "PrimaryButton", "normal", "font_color")
	_assert_contrast(theme, label, "DangerButton", "normal", "font_color")
	_assert_text_over_surface(theme, label, "Panel", "panel", "PanelLabel", "font_color")
	_assert_text_over_surface(theme, label, "PopupPanel", "panel", "DialogLabel", "font_color")
	_assert_rich_text_over_surface(theme, label, "Panel", "panel", "PanelRichTextLabel")
	_assert_rich_text_over_surface(theme, label, "PopupPanel", "panel", "DialogRichTextLabel")


func _assert_primary_button_semantics(theme: NeoCadeTheme, label: String) -> void:
	var primary := theme.get_stylebox("normal", "PrimaryButton") as StyleBoxFlat
	var button := theme.get_stylebox("normal", "Button") as StyleBoxFlat
	var danger := theme.get_stylebox("normal", "DangerButton") as StyleBoxFlat
	_assert(primary != null, "%s PrimaryButton normal stylebox exists" % label)
	_assert(button != null, "%s Button normal stylebox exists" % label)
	_assert(danger != null, "%s DangerButton normal stylebox exists" % label)
	if primary == null or button == null or danger == null:
		return
	_assert(_color_distance(primary.bg_color, button.bg_color) > 0.08, "%s PrimaryButton does not collapse to Button action fill" % label)
	_assert(_color_distance(primary.bg_color, danger.bg_color) > 0.18, "%s PrimaryButton does not collapse to DangerButton fill" % label)
	_assert(_color_distance(primary.border_color, danger.border_color) > 0.18, "%s PrimaryButton border does not borrow danger edge" % label)
	_assert(_contrast_ratio(primary.bg_color, theme.get_color("font_color", "PrimaryButton")) >= MIN_CONTRAST, "%s PrimaryButton foreground follows actual background" % label)


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


func _assert_text_over_surface(theme: NeoCadeTheme, label: String, surface_type: String, stylebox_name: String, text_type: String, color_name: String) -> void:
	var bg := _flat_bg(theme, surface_type, stylebox_name)
	var fg := theme.get_color(color_name, text_type)
	var ratio := _contrast_ratio(bg, fg)
	_assert(ratio >= MIN_CONTRAST, "%s %s over %s.%s contrast %.2f" % [label, text_type, surface_type, stylebox_name, ratio])


func _assert_rich_text_over_surface(theme: NeoCadeTheme, label: String, surface_type: String, stylebox_name: String, text_type: String) -> void:
	_assert_text_over_surface(theme, label, surface_type, stylebox_name, text_type, "default_color")


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


func _color_distance(a: Color, b: Color) -> float:
	return absf(a.r - b.r) + absf(a.g - b.g) + absf(a.b - b.b) + absf(a.a - b.a)


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
