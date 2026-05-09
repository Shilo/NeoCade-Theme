extends SceneTree

const THEME_PATH := "res://addons/neocade_theme/neocade_theme.tres"


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var canonical := load(THEME_PATH) as NeoCadeTheme
	if canonical == null:
		printerr("THEME_POPUP_SCROLLBAR_PROBE: missing NeoCadeTheme")
		quit(1)
		return

	_log_theme(_theme_variant(canonical, false), "Pulse flat")
	_log_theme(_theme_variant(canonical, true), "Pulse raised")
	print("THEME_POPUP_SCROLLBAR_PROBE: PASS")
	quit(0)


func _theme_variant(source: NeoCadeTheme, raised: bool) -> NeoCadeTheme:
	var theme := source.duplicate(true) as NeoCadeTheme
	theme.style = NeoCadeTheme.Style.PULSE
	theme.raised = raised
	theme.platform = NeoCadeTheme.Platform.DESKTOP
	return theme


func _log_theme(theme: Theme, label: String) -> void:
	print("--- %s ---" % label)
	for entry in [
		{"type": &"Button", "slot": &"normal"},
		{"type": &"PopupMenu", "slot": &"panel"},
		{"type": &"PopupPanel", "slot": &"panel"},
		{"type": &"TooltipPanel", "slot": &"panel"},
		{"type": &"Window", "slot": &"embedded_border"},
		{"type": &"HScrollBar", "slot": &"scroll"},
		{"type": &"HScrollBar", "slot": &"grabber"},
		{"type": &"VScrollBar", "slot": &"scroll"},
		{"type": &"VScrollBar", "slot": &"grabber"},
		{"type": &"ProgressBar", "slot": &"background"},
		{"type": &"ProgressBar", "slot": &"fill"},
	]:
		var sb := theme.get_stylebox(entry["slot"], entry["type"]) as StyleBoxFlat
		if sb == null:
			print("%s.%s missing" % [entry["type"], entry["slot"]])
			continue
		print("%s.%s bg=%s border=%s bw=%s/%s/%s/%s margin=%s/%s/%s/%s expand=%s/%s/%s/%s radius=%s/%s/%s/%s" % [
			entry["type"],
			entry["slot"],
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
		])
	for theme_type in [&"HScrollBar", &"VScrollBar"]:
		for icon_name in [&"decrement", &"increment"]:
			var icon := theme.get_icon(icon_name, theme_type)
			print("%s.%s icon_size=%s" % [theme_type, icon_name, icon.get_size()])
	print("ProgressBar.font_color=%s outline_color=%s outline_size=%s" % [
		theme.get_color(&"font_color", &"ProgressBar").to_html(false),
		theme.get_color(&"font_outline_color", &"ProgressBar").to_html(false),
		theme.get_constant(&"outline_size", &"ProgressBar"),
	])
