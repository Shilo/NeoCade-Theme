extends SceneTree

const THEME_PATH := "res://addons/neocade_theme/neocade_theme.tres"


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var canonical := load(THEME_PATH) as NeoCadeTheme
	if canonical == null:
		printerr("THEME_TAB_STATE_PROBE: missing NeoCadeTheme")
		quit(1)
		return

	for style_value in NeoCadeTheme.selectable_styles():
		_log_theme(_theme_variant(canonical, style_value, false), "desktop:%s" % NeoCadeTheme.style_label(style_value))
		_log_theme(_theme_variant(canonical, style_value, true), "raised:%s" % NeoCadeTheme.style_label(style_value))

	print("THEME_TAB_STATE_PROBE: PASS")
	quit(0)


func _theme_variant(source: NeoCadeTheme, style_value: int, raised: bool) -> NeoCadeTheme:
	var theme := source.duplicate(true) as NeoCadeTheme
	theme.style = style_value
	theme.raised = raised
	theme.platform = NeoCadeTheme.Platform.DESKTOP
	return theme


func _log_theme(theme: Theme, label: String) -> void:
	var button_normal := theme.get_stylebox(&"normal", &"Button") as StyleBoxFlat
	var button_pressed := theme.get_stylebox(&"pressed", &"Button") as StyleBoxFlat
	var tab_unselected := theme.get_stylebox(&"tab_unselected", &"TabBar") as StyleBoxFlat
	var tab_hovered := theme.get_stylebox(&"tab_hovered", &"TabBar") as StyleBoxFlat
	var tab_selected := theme.get_stylebox(&"tab_selected", &"TabBar") as StyleBoxFlat
	if button_normal == null or button_pressed == null or tab_unselected == null or tab_hovered == null or tab_selected == null:
		printerr("THEME_TAB_STATE_PROBE: missing state stylebox for %s" % label)
		quit(1)
		return

	print("%s Button.normal=%s Button.pressed=%s Tab.unselected=%s Tab.hovered=%s Tab.selected=%s lum=%0.4f/%0.4f/%0.4f" % [
		label,
		button_normal.bg_color.to_html(false),
		button_pressed.bg_color.to_html(false),
		tab_unselected.bg_color.to_html(false),
		tab_hovered.bg_color.to_html(false),
		tab_selected.bg_color.to_html(false),
		_luminance(tab_unselected.bg_color),
		_luminance(tab_hovered.bg_color),
		_luminance(tab_selected.bg_color),
	])


func _luminance(c: Color) -> float:
	return 0.2126 * _srgb_to_linear(c.r) + 0.7152 * _srgb_to_linear(c.g) + 0.0722 * _srgb_to_linear(c.b)


func _srgb_to_linear(channel: float) -> float:
	return channel / 12.92 if channel <= 0.03928 else pow((channel + 0.055) / 1.055, 2.4)
