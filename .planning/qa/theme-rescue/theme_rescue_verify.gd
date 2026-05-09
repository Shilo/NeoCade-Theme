extends SceneTree

const THEME_PATH := "res://addons/neocade_theme/neocade_theme.tres"
const MIN_TEXT_CONTRAST := 4.5

var _failures: PackedStringArray = []


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	_check_project_settings()

	var canonical := load(THEME_PATH) as NeoCadeTheme
	if canonical == null:
		_fail("canonical theme did not load as NeoCadeTheme")
		_finish()
		return

	for style_value in NeoCadeTheme.selectable_styles():
		var desktop := _theme_variant(canonical, style_value, false, NeoCadeTheme.Platform.DESKTOP)
		var raised := _theme_variant(canonical, style_value, true, NeoCadeTheme.Platform.DESKTOP)
		var mobile := _theme_variant(canonical, style_value, false, NeoCadeTheme.Platform.MOBILE)

		_check_theme(desktop, "desktop:%s" % NeoCadeTheme.style_label(style_value), false)
		_check_theme(raised, "raised:%s" % NeoCadeTheme.style_label(style_value), true)
		_check_theme(mobile, "mobile:%s" % NeoCadeTheme.style_label(style_value), false)
		_check_mobile_is_larger(desktop, mobile, NeoCadeTheme.style_label(style_value))

	_finish()


func _check_project_settings() -> void:
	_expect_equal(ProjectSettings.get_setting("display/window/size/viewport_width"), 1920, "viewport_width")
	_expect_equal(ProjectSettings.get_setting("display/window/size/viewport_height"), 1080, "viewport_height")
	_expect_equal(ProjectSettings.get_setting("display/window/subwindows/embed_subwindows"), true, "embed_subwindows")


func _theme_variant(source: NeoCadeTheme, style_value: int, raised: bool, platform: int) -> NeoCadeTheme:
	var theme := source.duplicate(true) as NeoCadeTheme
	theme.style = style_value
	theme.raised = raised
	theme.platform = platform
	return theme


func _check_theme(theme: NeoCadeTheme, label: String, expect_raised: bool) -> void:
	_expect_equal(theme.default_base_scale, 1.0, "%s default_base_scale" % label)
	_expect_icon_max(theme, "Window", "close", 24, label)
	_expect_icon_max(theme, "OptionButton", "arrow", 24, label)
	_expect_icon_between(theme, "CheckBox", "checked", Vector2(20, 20), Vector2(26, 26), label)
	_expect_icon_between(theme, "CheckButton", "checked", Vector2(28, 14), Vector2(34, 20), label)

	var is_mobile := label.begins_with("mobile:")
	_expect_margin_max(theme, "PrimaryButton", "normal", 28 if is_mobile else 18, 20 if is_mobile else 14, label)
	_expect_margin_max(theme, "PanelContainer", "panel", 18 if is_mobile else 14, 14 if is_mobile else 12, label)
	_expect_window_chrome(theme, label)
	_expect_popup_chrome(theme, label)
	_expect_no_label_chrome(theme, label)
	_expect_tab_top_only_corners(theme, label)
	_expect_button_surface_chrome(theme, label, expect_raised)
	_expect_colored_button_raised_chrome(theme, label, expect_raised)
	_expect_ghost_button_raised_chrome(theme, label, expect_raised)
	_expect_input_surface_chrome(theme, label)

	_expect_contrast(theme, "PrimaryButton", "normal", "font_color", MIN_TEXT_CONTRAST, label)
	_expect_contrast(theme, "DangerButton", "normal", "font_color", MIN_TEXT_CONTRAST, label)
	_expect_contrast(theme, "ItemList", "selected", "font_selected_color", MIN_TEXT_CONTRAST, label)

	_check_no_positive_shadows(theme, label)


func _check_mobile_is_larger(desktop: NeoCadeTheme, mobile: NeoCadeTheme, style_label: String) -> void:
	var desktop_button := desktop.get_stylebox("normal", "PrimaryButton") as StyleBoxFlat
	var mobile_button := mobile.get_stylebox("normal", "PrimaryButton") as StyleBoxFlat
	if desktop_button == null or mobile_button == null:
		return
	if mobile_button.content_margin_top <= desktop_button.content_margin_top:
		_fail("mobile:%s PrimaryButton top padding did not grow" % style_label)
	if mobile_button.content_margin_left <= desktop_button.content_margin_left:
		_fail("mobile:%s PrimaryButton side padding did not grow" % style_label)


func _check_no_positive_shadows(theme: Theme, label: String) -> void:
	for theme_type in theme.get_type_list():
		for slot_name in theme.get_stylebox_list(theme_type):
			var stylebox := theme.get_stylebox(slot_name, theme_type)
			if stylebox is StyleBoxFlat:
				var flat := stylebox as StyleBoxFlat
				if flat.shadow_size > 0 or flat.shadow_offset != Vector2.ZERO:
					_fail("%s %s.%s uses soft shadow_size=%s offset=%s" % [label, theme_type, slot_name, flat.shadow_size, flat.shadow_offset])


func _expect_icon_max(theme: Theme, theme_type: StringName, slot_name: StringName, max_px: int, label: String) -> void:
	if not theme.has_icon(slot_name, theme_type):
		_fail("%s missing icon %s.%s" % [label, theme_type, slot_name])
		return
	var icon := theme.get_icon(slot_name, theme_type)
	var size := icon.get_size()
	if size.x > max_px or size.y > max_px:
		_fail("%s icon %s.%s too large: %s" % [label, theme_type, slot_name, size])


func _expect_icon_between(theme: Theme, theme_type: StringName, slot_name: StringName, min_size: Vector2, max_size: Vector2, label: String) -> void:
	if not theme.has_icon(slot_name, theme_type):
		_fail("%s missing icon %s.%s" % [label, theme_type, slot_name])
		return
	var icon := theme.get_icon(slot_name, theme_type)
	var size := icon.get_size()
	if size.x < min_size.x or size.y < min_size.y:
		_fail("%s icon %s.%s too small: %s expected at least %s" % [label, theme_type, slot_name, size, min_size])
	if size.x > max_size.x or size.y > max_size.y:
		_fail("%s icon %s.%s too large: %s expected at most %s" % [label, theme_type, slot_name, size, max_size])


func _expect_window_chrome(theme: Theme, label: String) -> void:
	var window_panel := theme.get_stylebox("embedded_border", "Window") as StyleBoxFlat
	if window_panel == null:
		_fail("%s missing Window.embedded_border" % label)
		return
	if window_panel.expand_margin_top < 30 or window_panel.content_margin_top < 26:
		_fail("%s Window.embedded_border does not cover title bar/content margin: expand_top=%s content_top=%s" % [label, window_panel.expand_margin_top, window_panel.content_margin_top])
	_expect_equal(theme.get_constant("title_height", "Window"), 36, "%s Window.title_height" % label)
	_expect_equal(theme.get_constant("close_h_offset", "Window"), 18, "%s Window.close_h_offset" % label)
	_expect_equal(theme.get_constant("close_v_offset", "Window"), 24, "%s Window.close_v_offset" % label)


func _expect_popup_chrome(theme: Theme, label: String) -> void:
	var popup_panel := theme.get_stylebox("panel", "PopupMenu") as StyleBoxFlat
	if popup_panel == null:
		_fail("%s missing PopupMenu.panel" % label)
	elif popup_panel.border_width_left < 2 or popup_panel.content_margin_left > 8:
		_fail("%s PopupMenu.panel border/margins off: border=%s/%s/%s/%s margin=%s/%s/%s/%s" % [
			label,
			popup_panel.border_width_left, popup_panel.border_width_top, popup_panel.border_width_right, popup_panel.border_width_bottom,
			popup_panel.content_margin_left, popup_panel.content_margin_top, popup_panel.content_margin_right, popup_panel.content_margin_bottom,
		])

	var tooltip_panel := theme.get_stylebox("panel", "TooltipPanel") as StyleBoxFlat
	if tooltip_panel == null:
		_fail("%s missing TooltipPanel.panel" % label)
	elif tooltip_panel.border_width_left != 0 or tooltip_panel.border_width_top != 0 or tooltip_panel.content_margin_top > 4:
		_fail("%s TooltipPanel.panel border/margins off: border=%s/%s/%s/%s margin=%s/%s/%s/%s" % [
			label,
			tooltip_panel.border_width_left, tooltip_panel.border_width_top, tooltip_panel.border_width_right, tooltip_panel.border_width_bottom,
			tooltip_panel.content_margin_left, tooltip_panel.content_margin_top, tooltip_panel.content_margin_right, tooltip_panel.content_margin_bottom,
		])


func _expect_no_label_chrome(theme: Theme, label: String) -> void:
	if theme.has_stylebox("normal", "Label"):
		_fail("%s Label.normal stylebox should not be authored" % label)


func _expect_tab_top_only_corners(theme: Theme, label: String) -> void:
	for theme_type in [&"TabBar", &"TabContainer"]:
		for slot_name in [&"tab_selected", &"tab_unselected", &"tab_hovered", &"tab_disabled", &"tab_focus"]:
			if not theme.has_stylebox(slot_name, theme_type):
				continue
			var stylebox := theme.get_stylebox(slot_name, theme_type) as StyleBoxFlat
			if stylebox == null:
				continue
			if stylebox.corner_radius_bottom_left != 0 or stylebox.corner_radius_bottom_right != 0:
				_fail("%s %s.%s has bottom tab radius left/right=%s/%s" % [
					label,
					theme_type,
					slot_name,
					stylebox.corner_radius_bottom_left,
					stylebox.corner_radius_bottom_right,
				])


func _expect_button_surface_chrome(theme: NeoCadeTheme, label: String, expect_raised: bool) -> void:
	for theme_type in [&"Button", &"SecondaryButton", &"OptionButton", &"MenuButton", &"ColorPickerButton", &"IconButton"]:
		var normal := theme.get_stylebox("normal", theme_type) as StyleBoxFlat
		var hover := theme.get_stylebox("hover", theme_type) as StyleBoxFlat
		var pressed := theme.get_stylebox("pressed", theme_type) as StyleBoxFlat
		var disabled := theme.get_stylebox("disabled", theme_type) as StyleBoxFlat
		if normal == null or hover == null or pressed == null or disabled == null:
			_fail("%s missing button-family styleboxes for %s" % [label, theme_type])
			continue
		if normal.bg_color.a < 0.95:
			_fail("%s %s.normal is not a filled button surface: alpha=%.2f" % [label, theme_type, normal.bg_color.a])
		if not expect_raised and _max_border_width(normal) > 1:
			_fail("%s %s.normal flat border too thick: %s/%s/%s/%s" % [
				label,
				theme_type,
				normal.border_width_left,
				normal.border_width_top,
				normal.border_width_right,
				normal.border_width_bottom,
			])
		var edge_contrast := _contrast_ratio(normal.bg_color, normal.border_color)
		if not expect_raised and _max_border_width(normal) > 0 and edge_contrast > 1.45:
			_fail("%s %s.normal border is too contrasty for editor-like button chrome: bg=%s border=%s ratio=%.2f" % [
				label,
				theme_type,
				normal.bg_color.to_html(false),
				normal.border_color.to_html(false),
				edge_contrast,
			])
		if expect_raised:
			if normal.border_width_bottom <= normal.border_width_top:
				_fail("%s raised %s.normal has no bottom depth edge" % [label, theme_type])
			if normal.border_width_left < 1 or normal.border_width_top < 1 or normal.border_width_right < 1:
				_fail("%s raised %s.normal lost the subtle face edge: %s/%s/%s/%s" % [
					label,
					theme_type,
					normal.border_width_left,
					normal.border_width_top,
					normal.border_width_right,
					normal.border_width_bottom,
				])
			if edge_contrast < 1.06 or edge_contrast > 1.80:
				_fail("%s raised %s.normal face edge is not subtle/visible enough: ratio=%.2f" % [label, theme_type, edge_contrast])
			_expect_reserved_bottom_depth(normal, label, theme_type)
		if not expect_raised and _max_border_width(disabled) != 0:
			_fail("%s %s.disabled should not keep an outline border" % [label, theme_type])

		var normal_lum := _relative_luminance(normal.bg_color)
		var hover_lum := _relative_luminance(hover.bg_color)
		var pressed_lum := _relative_luminance(pressed.bg_color)
		if theme.is_light:
			if hover_lum >= normal_lum or pressed_lum >= hover_lum:
				_fail("%s %s button ramp does not darken on hover/press for light base" % [label, theme_type])
		else:
			if hover_lum <= normal_lum or pressed_lum <= hover_lum:
				_fail("%s %s button ramp does not brighten on hover/press for dark base" % [label, theme_type])


func _expect_colored_button_raised_chrome(theme: NeoCadeTheme, label: String, expect_raised: bool) -> void:
	for theme_type in [&"PrimaryButton", &"DangerButton"]:
		var normal := theme.get_stylebox("normal", theme_type) as StyleBoxFlat
		if normal == null:
			_fail("%s missing colored button stylebox for %s" % [label, theme_type])
			continue
		if normal.shadow_size != 0 or normal.shadow_offset != Vector2.ZERO:
			_fail("%s %s still uses StyleBoxFlat shadow" % [label, theme_type])
		if not expect_raised:
			continue
		if normal.border_width_bottom <= normal.border_width_top:
			_fail("%s raised %s has no hard bottom depth" % [label, theme_type])
		if normal.border_width_left < 1 or normal.border_width_top < 1 or normal.border_width_right < 1:
			_fail("%s raised %s lost the colored face rim: %s/%s/%s/%s" % [
				label,
				theme_type,
				normal.border_width_left,
				normal.border_width_top,
				normal.border_width_right,
				normal.border_width_bottom,
			])
		var edge_contrast := _contrast_ratio(normal.bg_color, normal.border_color)
		if edge_contrast < 1.30:
			_fail("%s raised %s colored rim is too subtle: ratio=%.2f" % [label, theme_type, edge_contrast])
		_expect_reserved_bottom_depth(normal, label, theme_type)


func _expect_ghost_button_raised_chrome(theme: NeoCadeTheme, label: String, expect_raised: bool) -> void:
	var normal := theme.get_stylebox("normal", "GhostButton") as StyleBoxFlat
	if normal == null:
		_fail("%s missing GhostButton.normal" % label)
		return
	if normal.shadow_size != 0 or normal.shadow_offset != Vector2.ZERO:
		_fail("%s GhostButton still uses StyleBoxFlat shadow" % label)
	if not expect_raised:
		return
	if normal.border_width_bottom <= normal.border_width_top:
		_fail("%s raised GhostButton has no hard bottom depth: %s/%s/%s/%s" % [
			label,
			normal.border_width_left,
			normal.border_width_top,
			normal.border_width_right,
			normal.border_width_bottom,
		])
	if normal.border_width_left < 1 or normal.border_width_top < 1 or normal.border_width_right < 1:
		_fail("%s raised GhostButton lost the face rim: %s/%s/%s/%s" % [
			label,
			normal.border_width_left,
			normal.border_width_top,
			normal.border_width_right,
			normal.border_width_bottom,
		])
	_expect_reserved_bottom_depth(normal, label, "GhostButton")


func _expect_input_surface_chrome(theme: NeoCadeTheme, label: String) -> void:
	for theme_type in [&"LineEdit", &"TextEdit", &"CodeEdit"]:
		var normal := theme.get_stylebox("normal", theme_type) as StyleBoxFlat
		var read_only := theme.get_stylebox("read_only", theme_type) as StyleBoxFlat
		if normal == null or read_only == null:
			_fail("%s missing input styleboxes for %s" % [label, theme_type])
			continue
		if normal.bg_color.a < 0.95:
			_fail("%s %s.normal is not a filled input surface: alpha=%.2f" % [label, theme_type, normal.bg_color.a])
		if _max_border_width(normal) > 1:
			_fail("%s %s.normal input edge too thick: %s/%s/%s/%s" % [
				label,
				theme_type,
				normal.border_width_left,
				normal.border_width_top,
				normal.border_width_right,
				normal.border_width_bottom,
			])
		var edge_contrast := _contrast_ratio(normal.bg_color, normal.border_color)
		if edge_contrast > 1.45:
			_fail("%s %s.normal input edge is too contrasty: bg=%s border=%s ratio=%.2f" % [
				label,
				theme_type,
				normal.bg_color.to_html(false),
				normal.border_color.to_html(false),
				edge_contrast,
			])
		if _max_border_width(read_only) != 0:
			_fail("%s %s.read_only should not keep an outline border" % [label, theme_type])


func _expect_reserved_bottom_depth(stylebox: StyleBoxFlat, label: String, theme_type: String) -> void:
	var face_width: int = maxi(stylebox.border_width_left, maxi(stylebox.border_width_top, stylebox.border_width_right))
	var border_extra: int = maxi(0, stylebox.border_width_bottom - face_width)
	var margin_extra: int = int(round(stylebox.content_margin_bottom - stylebox.content_margin_top))
	if margin_extra != border_extra:
		_fail("%s raised %s does not reserve bottom depth height: border_extra=%s margin_extra=%s" % [
			label,
			theme_type,
			border_extra,
			margin_extra,
		])


func _expect_margin_max(theme: Theme, theme_type: StringName, slot_name: StringName, max_h: int, max_v: int, label: String) -> void:
	var stylebox := theme.get_stylebox(slot_name, theme_type) as StyleBoxFlat
	if stylebox == null:
		_fail("%s missing StyleBoxFlat %s.%s" % [label, theme_type, slot_name])
		return
	if stylebox.content_margin_left > max_h or stylebox.content_margin_right > max_h:
		_fail("%s %s.%s horizontal margin too large: %s/%s" % [label, theme_type, slot_name, stylebox.content_margin_left, stylebox.content_margin_right])
	var face_width: int = maxi(stylebox.border_width_left, maxi(stylebox.border_width_top, stylebox.border_width_right))
	var allowed_bottom_extra: int = maxi(0, stylebox.border_width_bottom - face_width)
	if stylebox.content_margin_top > max_v or stylebox.content_margin_bottom > max_v + allowed_bottom_extra:
		_fail("%s %s.%s vertical margin too large: %s/%s" % [label, theme_type, slot_name, stylebox.content_margin_top, stylebox.content_margin_bottom])


func _expect_contrast(theme: Theme, theme_type: StringName, stylebox_slot: StringName, color_slot: StringName, minimum: float, label: String) -> void:
	var stylebox := theme.get_stylebox(stylebox_slot, theme_type) as StyleBoxFlat
	if stylebox == null:
		_fail("%s missing contrast stylebox %s.%s" % [label, theme_type, stylebox_slot])
		return
	if not theme.has_color(color_slot, theme_type):
		_fail("%s missing contrast color %s.%s" % [label, theme_type, color_slot])
		return
	var text_color := theme.get_color(color_slot, theme_type)
	var ratio := _contrast_ratio(stylebox.bg_color, text_color)
	if ratio < minimum:
		_fail("%s contrast %s.%s/%s is %.2f:1" % [label, theme_type, stylebox_slot, color_slot, ratio])


func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_fail("%s expected %s got %s" % [label, expected, actual])


func _max_border_width(stylebox: StyleBoxFlat) -> int:
	return maxi(
		maxi(stylebox.border_width_left, stylebox.border_width_top),
		maxi(stylebox.border_width_right, stylebox.border_width_bottom)
	)


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


func _fail(message: String) -> void:
	_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("THEME_RESCUE_VERIFY: PASS")
		quit(0)
		return

	printerr("THEME_RESCUE_VERIFY: FAIL")
	for failure in _failures:
		printerr("- " + failure)
	quit(1)
