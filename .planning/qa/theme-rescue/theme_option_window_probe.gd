extends SceneTree

const THEME_PATH := "res://addons/neocade_theme/neocade_theme.tres"
func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var canonical := load(THEME_PATH) as NeoCadeTheme
	if canonical == null:
		printerr("THEME_OPTION_WINDOW_PROBE: missing NeoCadeTheme")
		quit(1)
		return

	var neocade_flat := _theme_variant(canonical, false)
	var neocade_raised := _theme_variant(canonical, true)
	_log_theme_slots(neocade_flat, "NeoCade Pulse flat")
	_log_theme_slots(neocade_raised, "NeoCade Pulse raised")
	_log_resolved_control_slots(neocade_flat, "NeoCade Pulse flat")
	_log_resolved_control_slots(neocade_raised, "NeoCade Pulse raised")

	_log_resolved_control_slots(null, "Godot default")

	print("Minimal theme comparison is source-level only; its tool script requires EditorInterface.")

	print("THEME_OPTION_WINDOW_PROBE: PASS")
	quit(0)


func _theme_variant(source: NeoCadeTheme, raised: bool) -> NeoCadeTheme:
	var theme := source.duplicate(true) as NeoCadeTheme
	theme.style = NeoCadeTheme.Style.PULSE
	theme.raised = raised
	theme.platform = NeoCadeTheme.Platform.DESKTOP
	return theme


func _log_theme_slots(theme: Theme, label: String) -> void:
	print("--- %s explicit theme slots ---" % label)
	_log_stylebox(theme.get_stylebox(&"normal", &"OptionButton") as StyleBoxFlat, "OptionButton.normal")
	_log_stylebox(theme.get_stylebox(&"hover", &"OptionButton") as StyleBoxFlat, "OptionButton.hover")
	_log_stylebox(theme.get_stylebox(&"pressed", &"OptionButton") as StyleBoxFlat, "OptionButton.pressed")
	_log_stylebox(theme.get_stylebox(&"panel", &"PopupMenu") as StyleBoxFlat, "PopupMenu.panel")
	_log_stylebox(theme.get_stylebox(&"hover", &"PopupMenu") as StyleBoxFlat, "PopupMenu.hover")
	_log_stylebox(theme.get_stylebox(&"embedded_border", &"Window") as StyleBoxFlat, "Window.embedded_border")
	print("Window constants close_h=%s close_v=%s title_height=%s resize_margin=%s" % [
		theme.get_constant(&"close_h_offset", &"Window"),
		theme.get_constant(&"close_v_offset", &"Window"),
		theme.get_constant(&"title_height", &"Window"),
		theme.get_constant(&"resize_margin", &"Window"),
	])


func _log_resolved_control_slots(theme: Theme, label: String) -> void:
	var option_button := OptionButton.new()
	var window := Window.new()
	if theme != null:
		option_button.theme = theme
		window.theme = theme
	root.add_child(option_button)
	root.add_child(window)
	var popup := option_button.get_popup()
	print("--- %s resolved control/window slots ---" % label)
	_log_stylebox(option_button.get_theme_stylebox(&"normal", &"OptionButton") as StyleBoxFlat, "OptionButton.normal")
	_log_stylebox(option_button.get_theme_stylebox(&"hover", &"OptionButton") as StyleBoxFlat, "OptionButton.hover")
	_log_stylebox(option_button.get_theme_stylebox(&"pressed", &"OptionButton") as StyleBoxFlat, "OptionButton.pressed")
	_log_stylebox(popup.get_theme_stylebox(&"panel", &"PopupMenu") as StyleBoxFlat, "PopupMenu.panel")
	_log_stylebox(popup.get_theme_stylebox(&"hover", &"PopupMenu") as StyleBoxFlat, "PopupMenu.hover")
	_log_stylebox(window.get_theme_stylebox(&"embedded_border", &"Window") as StyleBoxFlat, "Window.embedded_border")
	print("Window constants close_h=%s close_v=%s title_height=%s resize_margin=%s" % [
		window.get_theme_constant(&"close_h_offset", &"Window"),
		window.get_theme_constant(&"close_v_offset", &"Window"),
		window.get_theme_constant(&"title_height", &"Window"),
		window.get_theme_constant(&"resize_margin", &"Window"),
	])
	option_button.queue_free()
	window.queue_free()


func _log_stylebox(sb: StyleBoxFlat, label: String) -> void:
	if sb == null:
		print("%s missing/non-flat" % label)
		return
	print("%s bg=%s border=%s bw=%s/%s/%s/%s margin=%s/%s/%s/%s expand=%s/%s/%s/%s radius=%s/%s/%s/%s shadow=%s" % [
		label,
		sb.bg_color.to_html(false),
		sb.border_color.to_html(false),
		sb.border_width_left,
		sb.border_width_top,
		sb.border_width_right,
		sb.border_width_bottom,
		sb.content_margin_left,
		sb.content_margin_top,
		sb.content_margin_right,
		sb.content_margin_bottom,
		sb.expand_margin_left,
		sb.expand_margin_top,
		sb.expand_margin_right,
		sb.expand_margin_bottom,
		sb.corner_radius_top_left,
		sb.corner_radius_top_right,
		sb.corner_radius_bottom_right,
		sb.corner_radius_bottom_left,
		sb.shadow_size,
	])
