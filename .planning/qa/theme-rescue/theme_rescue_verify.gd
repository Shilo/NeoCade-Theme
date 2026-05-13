extends SceneTree

const THEME_PATH := "res://addons/neocade_theme/neocade_theme.tres"
const MIN_TEXT_CONTRAST := 4.5

var _failures: PackedStringArray = []


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	_check_project_settings()
	_check_new_theme_defaults()
	_check_regeneration_batches_changed_signal()
	_check_texture_cache_modes()

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


func _check_new_theme_defaults() -> void:
	var theme := NeoCadeTheme.new()
	_expect_equal(theme.style, NeoCadeTheme.Style.PULSE, "NeoCadeTheme.new style")
	_expect_equal(theme.raised, false, "NeoCadeTheme.new raised")
	_expect_equal(theme.platform, NeoCadeTheme.Platform.AUTO, "NeoCadeTheme.new platform")
	_expect_color_equal(theme.base_color, Color("#151A2E"), "NeoCadeTheme.new base_color")
	_expect_color_equal(theme.accent_color, Color("#8BFF6A"), "NeoCadeTheme.new accent_color")
	_expect_equal(theme.corner_radius, 0, "NeoCadeTheme.new corner_radius")
	_expect_equal(theme.spacing, 14, "NeoCadeTheme.new spacing")
	_expect_equal(theme.raised_strength, 2, "NeoCadeTheme.new raised_strength")
	_expect_equal(theme.focus_thickness, 2, "NeoCadeTheme.new focus_thickness")
	_expect_equal(theme.outline_width, 1, "NeoCadeTheme.new outline_width")
	_expect_equal(theme.use_runtime_popup_selection_icons, true, "NeoCadeTheme.new use_runtime_popup_selection_icons")
	_expect_equal(theme.texture_cache, false, "NeoCadeTheme.new texture_cache")
	if not theme.has_stylebox(&"normal", &"Button"):
		_fail("NeoCadeTheme.new should generate Button.normal")
	if not theme.has_icon(&"checked", &"PopupMenu"):
		_fail("NeoCadeTheme.new should generate PopupMenu.checked")


func _check_regeneration_batches_changed_signal() -> void:
	var theme := NeoCadeTheme.new()
	var changed_count := [0]
	theme.changed.connect(func() -> void: changed_count[0] += 1)
	theme.raised = not theme.raised
	if int(changed_count[0]) != 1:
		_fail("NeoCadeTheme regeneration should emit exactly one changed signal, got %d" % int(changed_count[0]))


func _check_texture_cache_modes() -> void:
	var theme := NeoCadeTheme.new()
	if theme.texture_cache:
		_fail("texture_cache should default to false")
	if not theme._active_icon_cache.is_empty() or not theme._active_generated_texture_cache.is_empty():
		_fail("texture_cache=false should release active texture caches after regeneration")

	theme.texture_cache = true
	if theme._active_icon_cache.is_empty():
		_fail("texture_cache=true should retain loaded icon cache after regeneration")
	if theme._active_generated_texture_cache.is_empty():
		_fail("texture_cache=true should retain generated texture cache after regeneration")

	theme.texture_cache = false
	if not theme._active_icon_cache.is_empty() or not theme._active_generated_texture_cache.is_empty():
		_fail("disabling texture_cache should release active texture caches")

	var cached_a := NeoCadeTheme.new()
	var cached_b := NeoCadeTheme.new()
	cached_a.texture_cache = true
	var a_icons := cached_a._active_icon_cache.size()
	var a_generated := cached_a._active_generated_texture_cache.size()
	cached_b.texture_cache = true
	cached_b.texture_cache = false
	if cached_a._active_icon_cache.size() != a_icons or cached_a._active_generated_texture_cache.size() != a_generated:
		_fail("texture_cache should be per-instance; toggling another theme must not clear the first theme's retained cache")


func _theme_variant(source: NeoCadeTheme, style_value: int, raised: bool, platform: int) -> NeoCadeTheme:
	var theme := source.duplicate(true) as NeoCadeTheme
	theme.style = style_value
	theme.raised = raised
	theme.platform = platform
	return theme


func _check_theme(theme: NeoCadeTheme, label: String, expect_raised: bool) -> void:
	_expect_equal(theme.default_base_scale, 1.0, "%s default_base_scale" % label)
	var is_mobile := label.begins_with("mobile:")
	_expect_icon_max(theme, "Window", "close", 32 if is_mobile else 24, label)
	_expect_icon_max(theme, "OptionButton", "arrow", 24, label)
	_expect_icon_between(theme, "CheckBox", "checked", Vector2(40, 40) if is_mobile else Vector2(20, 20), Vector2(42, 42) if is_mobile else Vector2(26, 26), label)
	_expect_icon_between(theme, "CheckButton", "checked", Vector2(56, 29) if is_mobile else Vector2(34, 14), Vector2(60, 32) if is_mobile else Vector2(38, 20), label)
	_expect_margin_max(theme, "PrimaryButton", "normal", 28 if is_mobile else 18, 20 if is_mobile else 14, label)
	_expect_margin_max(theme, "PanelContainer", "panel", 18 if is_mobile else 14, 14 if is_mobile else 12, label)
	_expect_window_chrome(theme, label, expect_raised)
	_expect_popup_chrome(theme, label, expect_raised)
	_expect_separator_chrome(theme, label)
	_expect_panel_surface_chrome(theme, label, expect_raised)
	_expect_scrollbar_chrome(theme, label)
	_expect_scroll_hint_chrome(theme, label)
	_expect_no_label_chrome(theme, label)
	_expect_no_rich_text_label_chrome(theme, label)
	_expect_tab_top_only_corners(theme, label)
	_expect_tab_state_chrome(theme, label)
	if Engine.is_editor_hint():
		_expect_editor_compact_chrome(theme, label)
		_expect_editor_integration_chrome(theme, label)
		_expect_editor_property_input_chrome(theme, label, expect_raised)
		_expect_create_dialog_chrome(theme, label)
	_expect_shared_interaction_chrome(theme, label)
	_expect_tree_view_chrome(theme, label)
	_expect_list_view_chrome(theme, label)
	_expect_split_container_chrome(theme, label)
	_expect_button_surface_chrome(theme, label, expect_raised)
	_expect_colored_button_raised_chrome(theme, label, expect_raised)
	_expect_ghost_button_raised_chrome(theme, label, expect_raised)
	_expect_input_surface_chrome(theme, label)
	_expect_progress_bar_text_chrome(theme, label)

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


func _expect_window_chrome(theme: Theme, label: String, expect_raised: bool) -> void:
	var window_panel := theme.get_stylebox("embedded_border", "Window") as StyleBoxFlat
	var button_panel := theme.get_stylebox("normal", "Button") as StyleBoxFlat
	if window_panel == null:
		_fail("%s missing Window.embedded_border" % label)
		return
	if button_panel == null:
		_fail("%s missing Button.normal for Window chrome comparison" % label)
		return
	if window_panel.expand_margin_top < 30 or window_panel.content_margin_top < 26:
		_fail("%s Window.embedded_border does not cover title bar/content margin: expand_top=%s content_top=%s" % [label, window_panel.expand_margin_top, window_panel.content_margin_top])
	var window_density := window_panel.content_margin_top / 28.0
	var expected_expand_left := int(round(8.0 * window_density))
	var expected_expand_top := int(round(32.0 * window_density))
	var expected_expand_right := int(round(8.0 * window_density))
	var expected_expand_bottom := int(round(6.0 * window_density))
	if window_panel.expand_margin_left != expected_expand_left or window_panel.expand_margin_top != expected_expand_top or window_panel.expand_margin_right != expected_expand_right or window_panel.expand_margin_bottom != expected_expand_bottom:
		_fail("%s Window.embedded_border should match Godot default decoration expand margins: expand=%s/%s/%s/%s" % [
			label,
			window_panel.expand_margin_left,
			window_panel.expand_margin_top,
			window_panel.expand_margin_right,
			window_panel.expand_margin_bottom,
		])
	var expected_content_left := int(round(10.0 * window_density))
	var expected_content_top := int(round(28.0 * window_density))
	var expected_content_right := int(round(10.0 * window_density))
	var expected_bottom_margin: int = int(round(8.0 * window_density)) + maxi(0, window_panel.border_width_bottom - window_panel.border_width_top)
	if window_panel.content_margin_left != expected_content_left or window_panel.content_margin_top != expected_content_top or window_panel.content_margin_right != expected_content_right or window_panel.content_margin_bottom != expected_bottom_margin:
		_fail("%s Window.embedded_border should match Godot default content margins plus raised bottom reserve: margin=%s/%s/%s/%s expected=%s/%s/%s/%s" % [
			label,
			window_panel.content_margin_left,
			window_panel.content_margin_top,
			window_panel.content_margin_right,
			window_panel.content_margin_bottom,
			expected_content_left,
			expected_content_top,
			expected_content_right,
			expected_bottom_margin,
		])
	if not window_panel.bg_color.is_equal_approx(button_panel.bg_color):
		_fail("%s Window.embedded_border should use Button.normal face color: window=%s button=%s" % [
			label,
			window_panel.bg_color.to_html(false),
			button_panel.bg_color.to_html(false),
		])
	if not expect_raised and _max_border_width(window_panel) != 1:
		_fail("%s Window.embedded_border flat border should be 1px, got %s/%s/%s/%s" % [
			label,
			window_panel.border_width_left,
			window_panel.border_width_top,
			window_panel.border_width_right,
			window_panel.border_width_bottom,
		])
	if expect_raised and window_panel.border_width_bottom <= window_panel.border_width_top:
		_fail("%s Window.embedded_border raised state has no bottom depth edge" % label)
	var edge_contrast := _contrast_ratio(window_panel.bg_color, window_panel.border_color)
	if edge_contrast > (1.80 if expect_raised else 1.45):
		_fail("%s Window.embedded_border edge too contrasty: ratio=%.2f bg=%s border=%s" % [
			label,
			edge_contrast,
			window_panel.bg_color.to_html(false),
			window_panel.border_color.to_html(false),
		])
	var is_mobile := label.begins_with("mobile:")
	_expect_equal(theme.get_constant("title_height", "Window"), 48 if is_mobile else 36, "%s Window.title_height" % label)
	_expect_equal(theme.get_constant("close_h_offset", "Window"), 36 if is_mobile else 18, "%s Window.close_h_offset" % label)
	_expect_equal(theme.get_constant("close_v_offset", "Window"), 40 if is_mobile else 24, "%s Window.close_v_offset" % label)


func _expect_popup_chrome(theme: Theme, label: String, expect_raised: bool) -> void:
	var button_panel := theme.get_stylebox("normal", "Button") as StyleBoxFlat
	var option_panel := theme.get_stylebox("normal", "OptionButton") as StyleBoxFlat
	var option_hover := theme.get_stylebox("hover", "OptionButton") as StyleBoxFlat
	var popup_hover := theme.get_stylebox("hover", "PopupMenu") as StyleBoxFlat
	if button_panel == null:
		_fail("%s missing Button.normal for popup chrome comparison" % label)
		return
	if option_panel == null or option_hover == null or popup_hover == null:
		_fail("%s missing OptionButton/PopupMenu state styleboxes for dropdown comparison" % label)
		return
	for entry in [
		{"type": &"PopupMenu", "slot": &"panel", "max_h": 0, "max_v": 0, "min_h": 0, "min_v": 0, "source": option_panel},
		{"type": &"PopupPanel", "slot": &"panel", "max_h": 8, "max_v": 6, "min_h": 8, "min_v": 6, "source": button_panel},
		{"type": &"TooltipPanel", "slot": &"panel", "max_h": 8, "max_v": 8, "min_h": 0, "min_v": 0, "source": button_panel},
	]:
		var popup_panel := theme.get_stylebox(entry["slot"], entry["type"]) as StyleBoxFlat
		if popup_panel == null:
			_fail("%s missing %s.%s" % [label, entry["type"], entry["slot"]])
			continue
		var source_panel := entry["source"] as StyleBoxFlat
		var max_h := int(entry["max_h"])
		var max_v := int(entry["max_v"])
		var min_h := int(entry["min_h"])
		var min_v := int(entry["min_v"])
		if label.begins_with("mobile:"):
			max_h = int(ceili(float(max_h) * 1.5))
			max_v = int(ceili(float(max_v) * 1.5))
			min_h = int(ceili(float(min_h) * 1.5))
			min_v = int(ceili(float(min_v) * 1.5))
		var max_bottom := max_v + (10 if expect_raised else 0)
		if (
			popup_panel.content_margin_left > max_h
			or popup_panel.content_margin_right > max_h
			or popup_panel.content_margin_top > max_v
			or popup_panel.content_margin_bottom > max_bottom
			or popup_panel.content_margin_left < min_h
			or popup_panel.content_margin_right < min_h
			or popup_panel.content_margin_top < min_v
			or popup_panel.content_margin_bottom < min_v
		):
			_fail("%s %s.%s popup margins outside expected range: %s/%s/%s/%s" % [
				label,
				entry["type"],
				entry["slot"],
				popup_panel.content_margin_left,
				popup_panel.content_margin_top,
				popup_panel.content_margin_right,
				popup_panel.content_margin_bottom,
			])
		if not popup_panel.bg_color.is_equal_approx(source_panel.bg_color):
			_fail("%s %s.%s should use its source face color: popup=%s source=%s" % [
				label,
				entry["type"],
				entry["slot"],
				popup_panel.bg_color.to_html(false),
				source_panel.bg_color.to_html(false),
			])
		if not expect_raised and _max_border_width(popup_panel) != 1:
			_fail("%s %s.%s flat popup border should be 1px, got %s/%s/%s/%s" % [
				label,
				entry["type"],
				entry["slot"],
				popup_panel.border_width_left,
				popup_panel.border_width_top,
				popup_panel.border_width_right,
				popup_panel.border_width_bottom,
			])
		if expect_raised and popup_panel.border_width_bottom <= popup_panel.border_width_top:
			_fail("%s raised %s.%s has no bottom popup depth" % [label, entry["type"], entry["slot"]])
		var edge_contrast := _contrast_ratio(popup_panel.bg_color, popup_panel.border_color)
		if edge_contrast > (1.80 if expect_raised else 1.45):
			_fail("%s %s.%s popup edge too contrasty: ratio=%.2f bg=%s border=%s" % [
				label,
				entry["type"],
				entry["slot"],
				edge_contrast,
				popup_panel.bg_color.to_html(false),
				popup_panel.border_color.to_html(false),
			])
	if not popup_hover.bg_color.is_equal_approx(option_hover.bg_color):
		_fail("%s PopupMenu.hover should use OptionButton.hover bg color: popup=%s option=%s" % [
			label,
			popup_hover.bg_color.to_html(false),
			option_hover.bg_color.to_html(false),
		])


func _expect_separator_chrome(theme: Theme, label: String) -> void:
	for entry in [
		{"type": &"HSeparator", "slot": &"separator", "vertical": false},
		{"type": &"VSeparator", "slot": &"separator", "vertical": true},
		{"type": &"PopupMenu", "slot": &"separator", "vertical": false},
		{"type": &"PopupMenu", "slot": &"labeled_separator_left", "vertical": false},
		{"type": &"PopupMenu", "slot": &"labeled_separator_right", "vertical": false},
	]:
		var stylebox := theme.get_stylebox(entry["slot"], entry["type"])
		var line := stylebox as StyleBoxLine
		if line == null:
			_fail("%s %s.%s should use StyleBoxLine like Godot editor/minimal separators" % [
				label,
				entry["type"],
				entry["slot"],
			])
			continue
		if line.vertical != bool(entry["vertical"]):
			_fail("%s %s.%s vertical flag mismatch" % [label, entry["type"], entry["slot"]])
		if line.thickness < 1:
			_fail("%s %s.%s separator thickness too small: %s" % [label, entry["type"], entry["slot"], line.thickness])
		if line.color.a <= 0.01:
			_fail("%s %s.%s separator is invisible" % [label, entry["type"], entry["slot"]])


func _expect_panel_surface_chrome(theme: Theme, label: String, expect_raised: bool) -> void:
	for entry in [
		{"type": &"Panel", "slot": &"panel", "raises": true},
		{"type": &"PanelContainer", "slot": &"panel", "raises": true},
		{"type": &"CardPanel", "slot": &"panel", "raises": true},
		{"type": &"HeroPanel", "slot": &"panel", "raises": true},
		{"type": &"TabContainer", "slot": &"panel", "raises": true},
		{"type": &"ScrollContainer", "slot": &"panel", "raises": false},
		{"type": &"ItemList", "slot": &"panel", "raises": false},
		{"type": &"Tree", "slot": &"panel", "raises": false},
	]:
		var panel_style := theme.get_stylebox(entry["slot"], entry["type"])
		if panel_style == null:
			_fail("%s missing panel stylebox %s.%s" % [label, entry["type"], entry["slot"]])
			continue
		if panel_style is StyleBoxEmpty:
			continue
		var panel := panel_style as StyleBoxFlat
		if panel == null:
			_fail("%s panel stylebox %s.%s should be StyleBoxFlat or StyleBoxEmpty" % [label, entry["type"], entry["slot"]])
			continue
		var edge_contrast := _contrast_ratio(panel.bg_color, panel.border_color)
		if edge_contrast > (1.80 if expect_raised and bool(entry["raises"]) else 1.45):
			_fail("%s %s.%s panel edge too contrasty: ratio=%.2f bg=%s border=%s" % [
				label,
				entry["type"],
				entry["slot"],
				edge_contrast,
				panel.bg_color.to_html(false),
				panel.border_color.to_html(false),
			])
		if expect_raised and bool(entry["raises"]):
			if panel.border_width_bottom <= panel.border_width_top:
				_fail("%s raised %s.%s has no bottom panel depth" % [label, entry["type"], entry["slot"]])
			_expect_reserved_bottom_depth(panel, label, String(entry["type"]))
		elif _max_border_width(panel) > 1:
			_fail("%s %s.%s flat/passive panel border too thick: %s/%s/%s/%s" % [
				label,
				entry["type"],
				entry["slot"],
				panel.border_width_left,
				panel.border_width_top,
				panel.border_width_right,
				panel.border_width_bottom,
			])


func _expect_scrollbar_chrome(theme: Theme, label: String) -> void:
	var expect_square := label.ends_with(":Pulse")
	var min_thickness := 6 if label.begins_with("mobile:") else 8
	for theme_type in [&"HScrollBar", &"VScrollBar"]:
		for slot_name in [&"decrement", &"decrement_highlight", &"decrement_pressed", &"increment", &"increment_highlight", &"increment_pressed"]:
			_expect_icon_max(theme, theme_type, slot_name, 1, label)
		var scroll := theme.get_stylebox("scroll", theme_type) as StyleBoxFlat
		var scroll_focus := theme.get_stylebox("scroll_focus", theme_type) as StyleBoxFlat
		var grabber := theme.get_stylebox("grabber", theme_type) as StyleBoxFlat
		var hover := theme.get_stylebox("grabber_highlight", theme_type) as StyleBoxFlat
		var pressed := theme.get_stylebox("grabber_pressed", theme_type) as StyleBoxFlat
		if scroll == null or scroll_focus == null or grabber == null or hover == null or pressed == null:
			_fail("%s missing scrollbar styleboxes for %s" % [label, theme_type])
			continue
		if scroll.bg_color.a > 0.01 or scroll_focus.bg_color.a > 0.01:
			_fail("%s %s track should be transparent: scroll_alpha=%.2f focus_alpha=%.2f" % [
				label,
				theme_type,
				scroll.bg_color.a,
				scroll_focus.bg_color.a,
			])
		if _max_border_width(scroll) != 0 or _max_border_width(scroll_focus) != 0:
			_fail("%s %s track/focus should not draw borders" % [label, theme_type])
		var min_size := scroll.get_minimum_size()
		var grabber_min_size := grabber.get_minimum_size()
		if theme_type == &"HScrollBar":
			if min_size.y < min_thickness or grabber_min_size.y < min_thickness:
				_fail("%s HScrollBar track/grabber too thin: track=%s grabber=%s min=%d" % [label, min_size, grabber_min_size, min_thickness])
		else:
			if min_size.x < min_thickness or grabber_min_size.x < min_thickness:
				_fail("%s VScrollBar track/grabber too thin: track=%s grabber=%s min=%d" % [label, min_size, grabber_min_size, min_thickness])
		if _max_border_width(grabber) != 0 or _max_border_width(hover) != 0 or _max_border_width(pressed) != 0:
			_fail("%s %s grabbers should be filled pills without outline borders" % [label, theme_type])
		if grabber.bg_color.a < 0.20 or grabber.bg_color.a > 0.45:
			_fail("%s %s grabber should be semi-transparent like Godot editor default, alpha=%.2f" % [
				label,
				theme_type,
				grabber.bg_color.a,
			])
		if hover.bg_color.a <= grabber.bg_color.a or hover.bg_color.a > 0.65:
			_fail("%s %s hover grabber alpha should visibly increase without becoming opaque: normal=%.2f hover=%.2f" % [
				label,
				theme_type,
				grabber.bg_color.a,
				hover.bg_color.a,
			])
		if not pressed.bg_color.is_equal_approx(hover.bg_color):
			_fail("%s %s pressed grabber should share hover alpha/color like Godot modern: pressed=%s hover=%s" % [
				label,
				theme_type,
				pressed.bg_color.to_html(true),
				hover.bg_color.to_html(true),
			])
		if expect_square:
			for stylebox in [scroll, grabber, hover, pressed]:
				if stylebox.corner_radius_top_left != 0 or stylebox.corner_radius_top_right != 0 or stylebox.corner_radius_bottom_left != 0 or stylebox.corner_radius_bottom_right != 0:
					_fail("%s %s should be square in Pulse, got radius %s/%s/%s/%s" % [
						label,
						theme_type,
						stylebox.corner_radius_top_left,
						stylebox.corner_radius_top_right,
						stylebox.corner_radius_bottom_right,
						stylebox.corner_radius_bottom_left,
					])


func _expect_scroll_hint_chrome(theme: Theme, label: String) -> void:
	var vertical_hint := theme.get_icon("scroll_hint_vertical", "ScrollContainer")
	var horizontal_hint := theme.get_icon("scroll_hint_horizontal", "ScrollContainer")
	var vertical_size := vertical_hint.get_size()
	var horizontal_size := horizontal_hint.get_size()
	if vertical_size.x <= vertical_size.y:
		_fail("%s ScrollContainer.scroll_hint_vertical should be a horizontal top/bottom fade texture, got %s" % [label, vertical_size])
	if horizontal_size.y <= horizontal_size.x:
		_fail("%s ScrollContainer.scroll_hint_horizontal should be a vertical left/right fade texture, got %s" % [label, horizontal_size])
	if not theme.get_color("scroll_hint_vertical_color", "ScrollContainer").is_equal_approx(Color.BLACK):
		_fail("%s ScrollContainer.scroll_hint_vertical_color should be neutral black like Godot's default fade modulate" % label)
	if not theme.get_color("scroll_hint_horizontal_color", "ScrollContainer").is_equal_approx(Color.BLACK):
		_fail("%s ScrollContainer.scroll_hint_horizontal_color should be neutral black like Godot's default fade modulate" % label)


func _expect_no_label_chrome(theme: Theme, label: String) -> void:
	if not theme.has_stylebox("normal", "Label"):
		return
	var stylebox := theme.get_stylebox("normal", "Label")
	if stylebox is StyleBoxEmpty:
		return
	var flat := stylebox as StyleBoxFlat
	if flat != null and flat.bg_color.a == 0.0 and _max_border_width(flat) == 0:
		return
	_fail("%s Label.normal may be authored only as empty/transparent chrome to block editor fallback" % label)


func _expect_no_rich_text_label_chrome(theme: Theme, label: String) -> void:
	for slot_name in [&"normal", &"focus"]:
		var stylebox := theme.get_stylebox(slot_name, "RichTextLabel") as StyleBoxFlat
		if stylebox == null:
			_fail("%s RichTextLabel.%s transparent stylebox should be authored to block default fallback" % [label, slot_name])
			continue
		if stylebox.bg_color.a != 0.0 or _max_border_width(stylebox) != 0:
			_fail("%s RichTextLabel.%s should draw no background/border: alpha=%.2f border=%s/%s/%s/%s" % [
				label,
				slot_name,
				stylebox.bg_color.a,
				stylebox.border_width_left,
				stylebox.border_width_top,
				stylebox.border_width_right,
				stylebox.border_width_bottom,
			])


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


func _expect_tab_state_chrome(theme: Theme, label: String) -> void:
	var button_normal := theme.get_stylebox("normal", "Button") as StyleBoxFlat
	var button_hover := theme.get_stylebox("hover", "Button") as StyleBoxFlat
	var button_pressed := theme.get_stylebox("pressed", "Button") as StyleBoxFlat
	if button_normal == null or button_hover == null or button_pressed == null:
		_fail("%s missing Button states for tab active-state comparison" % label)
		return
	for theme_type in [&"TabBar", &"TabContainer"]:
		var unselected := theme.get_stylebox("tab_unselected", theme_type) as StyleBoxFlat
		var hovered := theme.get_stylebox("tab_hovered", theme_type) as StyleBoxFlat
		var selected := theme.get_stylebox("tab_selected", theme_type) as StyleBoxFlat
		var disabled := theme.get_stylebox("tab_disabled", theme_type) as StyleBoxFlat
		if unselected == null or hovered == null or selected == null or disabled == null:
			_fail("%s missing tab state styleboxes for %s" % [label, theme_type])
			continue
		_expect_state_step_visibility(unselected, hovered, selected, label, "%s.tab" % theme_type, 1.10, 1.05)
		if not selected.bg_color.is_equal_approx(button_pressed.bg_color):
			_fail("%s %s.tab_selected should use Button.pressed/toggled active bg: tab=%s button=%s" % [
				label,
				theme_type,
				selected.bg_color.to_html(false),
				button_pressed.bg_color.to_html(false),
			])
		if not hovered.bg_color.is_equal_approx(button_hover.bg_color):
			_fail("%s %s.tab_hovered should use Button.hover bg: tab=%s button=%s" % [
				label,
				theme_type,
				hovered.bg_color.to_html(false),
				button_hover.bg_color.to_html(false),
			])
		if not unselected.bg_color.is_equal_approx(button_normal.bg_color):
			_fail("%s %s.tab_unselected should use Button.normal bg: tab=%s button=%s" % [
				label,
				theme_type,
				unselected.bg_color.to_html(false),
				button_normal.bg_color.to_html(false),
			])
		if _relative_luminance(selected.bg_color) <= _relative_luminance(unselected.bg_color):
			_fail("%s %s.tab_selected should be brighter than tab_unselected" % [label, theme_type])
		for state in [
			{"name": &"tab_selected", "stylebox": selected},
			{"name": &"tab_unselected", "stylebox": unselected},
			{"name": &"tab_hovered", "stylebox": hovered},
			{"name": &"tab_disabled", "stylebox": disabled},
		]:
			var state_stylebox := state["stylebox"] as StyleBoxFlat
			if _max_border_width(state_stylebox) != 0:
				_fail("%s %s.%s should not draw an outline border" % [label, theme_type, state["name"]])
		if _max_border_width(disabled) != 0:
			_fail("%s %s.tab_disabled should not keep an outline border" % [label, theme_type])


func _expect_editor_compact_chrome(theme: Theme, label: String) -> void:
	for margin_name in [&"margin_top", &"margin_bottom", &"margin_left", &"margin_right"]:
		_expect_equal(theme.get_constant(margin_name, "MarginContainer"), 0, "%s MarginContainer.%s" % [label, margin_name])
		_expect_equal(theme.get_constant(margin_name, "EditorDock"), 6, "%s EditorDock.%s" % [label, margin_name])
	if ClassDB.class_exists("InspectorDock") and not ClassDB.is_parent_class("InspectorDock", "EditorDock"):
		_fail("%s InspectorDock should inherit EditorDock for dock margin theming" % label)
	if ClassDB.class_exists("FileSystemDock") and not ClassDB.is_parent_class("FileSystemDock", "EditorDock"):
		_fail("%s FileSystemDock should inherit EditorDock for dock margin theming" % label)
	if theme.get_type_variation_base(&"NoBorderHorizontal") != &"MarginContainer":
		_fail("%s NoBorderHorizontal should inherit MarginContainer for editor scroll-body wrappers" % label)
	if theme.get_type_variation_base(&"NoBorderHorizontalBottom") != &"NoBorderHorizontal":
		_fail("%s NoBorderHorizontalBottom should inherit NoBorderHorizontal" % label)
	_expect_equal(theme.get_constant(&"margin_top", &"NoBorderHorizontalBottom"), 4, "%s NoBorderHorizontalBottom.margin_top" % label)
	_expect_equal(theme.get_constant(&"margin_left", &"NoBorderHorizontalBottom"), 0, "%s NoBorderHorizontalBottom.margin_left" % label)
	_expect_equal(theme.get_constant(&"margin_right", &"NoBorderHorizontalBottom"), 0, "%s NoBorderHorizontalBottom.margin_right" % label)
	_expect_equal(theme.get_constant(&"margin_bottom", &"NoBorderHorizontalBottom"), 0, "%s NoBorderHorizontalBottom.margin_bottom" % label)
	# Godot editor docks such as FileSystemDock build toolbar rows from plain
	# HBoxContainer/VBoxContainer nodes inside EditorDock, which is a MarginContainer.
	# Keep generic layout spacing minimal and use EditorDock margins for visible dock
	# padding around the toolbar rows.
	_expect_equal(theme.get_constant("separation", "HBoxContainer"), 2, "%s HBoxContainer.separation" % label)
	_expect_equal(theme.get_constant("separation", "VBoxContainer"), 2, "%s VBoxContainer.separation" % label)
	_expect_equal(theme.get_constant("h_separation", "FlowContainer"), 4, "%s FlowContainer.h_separation" % label)
	_expect_equal(theme.get_constant("v_separation", "FlowContainer"), 4, "%s FlowContainer.v_separation" % label)
	_expect_equal(theme.get_constant("h_separation", "GridContainer"), 4, "%s GridContainer.h_separation" % label)
	_expect_equal(theme.get_constant("v_separation", "GridContainer"), 4, "%s GridContainer.v_separation" % label)
	var expected_tab_side_margin := (theme as NeoCadeTheme).corner_radius if theme is NeoCadeTheme else 0
	_expect_equal(theme.get_constant("side_margin", "TabContainer"), expected_tab_side_margin, "%s TabContainer.side_margin" % label)
	_expect_equal(theme.get_constant("tab_separation", "TabContainer"), 0, "%s TabContainer.tab_separation" % label)
	_expect_equal(theme.get_constant("icon_max_width", "TabBar"), 0, "%s TabBar.icon_max_width" % label)
	_expect_equal(theme.get_constant("icon_max_width", "TabContainer"), 0, "%s TabContainer.icon_max_width" % label)

	var tabbar_background := theme.get_stylebox("tabbar_background", "TabContainer") as StyleBoxFlat
	if tabbar_background == null:
		_fail("%s missing TabContainer.tabbar_background" % label)
	else:
		if _max_border_width(tabbar_background) != 0:
			_fail("%s TabContainer.tabbar_background should not draw an outline border" % label)
		if tabbar_background.content_margin_left != 0 or tabbar_background.content_margin_right != 0:
			_fail("%s TabContainer.tabbar_background should not add fake left/right toolbar margins, got %s/%s" % [
				label,
				tabbar_background.content_margin_left,
				tabbar_background.content_margin_right,
			])
		if tabbar_background.content_margin_top != 0 or tabbar_background.content_margin_bottom != 0:
			_fail("%s TabContainer.tabbar_background should not own toolbar vertical inset, got %s/%s" % [
				label,
				tabbar_background.content_margin_top,
				tabbar_background.content_margin_bottom,
			])

	for dock_type in [&"DockTabContainer", &"SideDockTabContainer", &"BottomSideDockTabContainer"]:
		var dock_panel := theme.get_stylebox("panel", dock_type) as StyleBoxFlat
		if dock_panel == null:
			_fail("%s missing %s.panel for editor dock toolbar background inset" % [label, dock_type])
		else:
			if dock_panel.bg_color.a < 0.99:
				_fail("%s %s.panel should paint the dock toolbar background" % [label, dock_type])
			if dock_panel.content_margin_left < 6 or dock_panel.content_margin_right < 6:
				_fail("%s %s.panel should own left/right dock inset, got %s/%s" % [
					label,
					dock_type,
					dock_panel.content_margin_left,
					dock_panel.content_margin_right,
				])
			if dock_panel.content_margin_top < 5 or dock_panel.content_margin_bottom < 5:
				_fail("%s %s.panel should keep toolbar padding inside the painted dock background, got top/bottom=%s/%s" % [
					label,
					dock_type,
					dock_panel.content_margin_top,
					dock_panel.content_margin_bottom,
				])

		var dock_tabbar := theme.get_stylebox("tabbar_background", dock_type) as StyleBoxFlat
		if dock_tabbar == null:
			_fail("%s missing %s.tabbar_background for editor dock tab header inset" % [label, dock_type])
		else:
			if _max_border_width(dock_tabbar) != 0:
				_fail("%s %s.tabbar_background should not draw an outline border" % [label, dock_type])
			if dock_tabbar.bg_color.a < 0.99:
				_fail("%s %s.tabbar_background should paint the full editor dock tab header" % [label, dock_type])
			if dock_tabbar.content_margin_left < 4 or dock_tabbar.content_margin_right < 4:
				_fail("%s %s.tabbar_background should keep tab header side inset inside the painted background, got %s/%s" % [
					label,
					dock_type,
					dock_tabbar.content_margin_left,
					dock_tabbar.content_margin_right,
				])
			if dock_tabbar.content_margin_top < 2 or dock_tabbar.content_margin_bottom != 0:
				_fail("%s %s.tabbar_background should add compact top inset without detaching tabs, got top/bottom=%s/%s" % [
					label,
					dock_type,
					dock_tabbar.content_margin_top,
					dock_tabbar.content_margin_bottom,
				])

	var option_normal := theme.get_stylebox("normal", "OptionButton") as StyleBoxFlat
	if option_normal == null:
		_fail("%s missing OptionButton.normal" % label)
	else:
		if option_normal.content_margin_top > 6 or option_normal.content_margin_bottom > 9:
			_fail("%s OptionButton vertical margins should stay editor-compact, got top/bottom=%s/%s" % [
				label,
				option_normal.content_margin_top,
				option_normal.content_margin_bottom,
			])
	_expect_equal(theme.get_constant("arrow_margin", "OptionButton"), 6, "%s OptionButton.arrow_margin" % label)
	_expect_equal(theme.get_constant("h_separation", "OptionButton"), 4, "%s OptionButton.h_separation" % label)

	for theme_type in [&"FlatButton", &"FlatMenuButton"]:
		var normal := theme.get_stylebox("normal", theme_type) as StyleBoxFlat
		var hover := theme.get_stylebox("hover", theme_type) as StyleBoxFlat
		if normal == null or hover == null:
			_fail("%s missing shared flat-button styleboxes for %s" % [label, theme_type])
			continue
		var flat_scale := 1.5 if label.begins_with("mobile:") else 1.0
		var expected_h := 6.0 * flat_scale
		var expected_v := 4.0 * flat_scale
		if normal.bg_color.a > 0.01 or _max_border_width(normal) != 0:
			_fail("%s %s.normal should be transparent and borderless" % [label, theme_type])
		if normal.content_margin_left > expected_h or normal.content_margin_top > expected_v + 1.0:
			_fail("%s %s.normal margins should stay default-like wide-flat, got %s/%s/%s/%s" % [
				label,
				theme_type,
				normal.content_margin_left,
				normal.content_margin_top,
				normal.content_margin_right,
				normal.content_margin_bottom,
			])
		if normal.content_margin_left < expected_h or normal.content_margin_right < expected_h or normal.content_margin_top < expected_v or normal.content_margin_bottom < expected_v:
			_fail("%s %s.normal margins should keep visible toolbar inset, got left/top/right/bottom=%s/%s/%s/%s" % [
				label,
				theme_type,
				normal.content_margin_left,
				normal.content_margin_top,
				normal.content_margin_right,
				normal.content_margin_bottom,
			])
		if _max_border_width(hover) != 0:
			_fail("%s %s.hover should not draw an outline border" % [label, theme_type])
		var expected_accent := (theme as NeoCadeTheme).accent_color
		if not theme.get_color("icon_pressed_color", theme_type).is_equal_approx(expected_accent):
			_fail("%s %s.icon_pressed_color should use accent for toggled editor buttons" % [label, theme_type])
		if not theme.get_color("icon_hover_pressed_color", theme_type).is_equal_approx(expected_accent):
			_fail("%s %s.icon_hover_pressed_color should keep accent while toggled+hovered" % [label, theme_type])
		_expect_equal(theme.get_constant("h_separation", theme_type), 4, "%s %s.h_separation" % [label, theme_type])

	var menu_icon := theme.get_icon("menu", "TabContainer")
	if menu_icon.get_size().x < 24 or menu_icon.get_size().y < 24:
		_fail("%s TabContainer.menu icon should be at least 24px for editor more menu, got %s" % [label, menu_icon.get_size()])
	if menu_icon.get_size().x > 28 or menu_icon.get_size().y > 28:
		_fail("%s TabContainer.menu icon should stay toolbar-sized, got %s" % [label, menu_icon.get_size()])
	for icon_name in [&"GuiTabMenu", &"GuiTabMenuHl", &"GuiTabMenuHlDarkBackground", &"TripleBar"]:
		if not theme.has_icon(icon_name, "EditorIcons"):
			_fail("%s missing EditorIcons.%s override" % [label, icon_name])
			continue
		var editor_icon_size := theme.get_icon(icon_name, "EditorIcons").get_size()
		if editor_icon_size.x < 24 or editor_icon_size.y < 24:
			_fail("%s EditorIcons.%s should be at least 24px, got %s" % [label, icon_name, editor_icon_size])
		if editor_icon_size.x > 28 or editor_icon_size.y > 28:
			_fail("%s EditorIcons.%s should stay toolbar-sized, got %s" % [label, icon_name, editor_icon_size])


func _expect_editor_property_input_chrome(theme: Theme, label: String, expect_raised: bool) -> void:
	if theme.get_type_variation_base(&"EditorInspectorButton") != &"Button":
		_fail("%s EditorInspectorButton should inherit Button for inspector value controls" % label)
	if theme.get_type_variation_base(&"EditorInspectorFlatButton") != &"FlatButton":
		_fail("%s EditorInspectorFlatButton should inherit FlatButton for editor-only flat controls" % label)

	var option_normal := theme.get_stylebox("normal", "OptionButton") as StyleBoxFlat
	var child_bg := theme.get_stylebox("child_bg", "EditorProperty") as StyleBoxFlat
	var spin_label_bg := theme.get_stylebox("label_bg", "EditorSpinSlider") as StyleBoxFlat
	if option_normal == null or child_bg == null or spin_label_bg == null:
		_fail("%s missing editor property input surface styleboxes" % label)
		return

	var row_bg := theme.get_stylebox("bg", "EditorProperty")
	if row_bg is StyleBoxFlat:
		var row_flat := row_bg as StyleBoxFlat
		if row_flat.bg_color.a > 0.01 or _max_border_width(row_flat) != 0:
			_fail("%s EditorProperty.bg should stay transparent; child_bg owns value input surface" % label)
	elif not (row_bg is StyleBoxEmpty):
		_fail("%s EditorProperty.bg should be StyleBoxEmpty or transparent StyleBoxFlat" % label)

	for entry in [
		{"name": &"EditorProperty.child_bg", "stylebox": child_bg},
		{"name": &"EditorSpinSlider.label_bg", "stylebox": spin_label_bg},
	]:
		var stylebox := entry["stylebox"] as StyleBoxFlat
		if not stylebox.bg_color.is_equal_approx(option_normal.bg_color):
			_fail("%s %s should use the same face color as OptionButton.normal because flat inspector controls rely on parent/label bg: got=%s option=%s" % [
				label,
				entry["name"],
				stylebox.bg_color.to_html(false),
				option_normal.bg_color.to_html(false),
			])
		if not expect_raised and _max_border_width(stylebox) != 1:
			_fail("%s %s flat border should match input/button 1px edge" % [label, entry["name"]])
		if expect_raised and stylebox.border_width_bottom <= stylebox.border_width_top:
			_fail("%s raised %s should reserve bottom depth like other input/button surfaces" % [label, entry["name"]])
		var edge_contrast := _contrast_ratio(stylebox.bg_color, stylebox.border_color)
		if edge_contrast > (1.80 if expect_raised else 1.45):
			_fail("%s %s edge is too contrasty for editor property input chrome: ratio=%.2f" % [
				label,
				entry["name"],
				edge_contrast,
			])

	_expect_equal(theme.get_constant(&"line_edit_margin", &"EditorSpinSlider"), 28, "%s EditorSpinSlider.line_edit_margin" % label)
	_expect_equal(theme.get_constant(&"line_edit_margin_empty", &"EditorSpinSlider"), 20, "%s EditorSpinSlider.line_edit_margin_empty" % label)
	if not theme.get_color(&"label_color", &"EditorSpinSlider").is_equal_approx(theme.get_color(&"drop_position_color", &"Tree")):
		_fail("%s EditorSpinSlider.label_color should use the accent color so vector x/y/z labels stand out" % label)
	_expect_icon_max(theme, &"EditorSpinSlider", &"updown", 24, label)
	_expect_icon_max(theme, &"SpinBox", &"updown", 24, label)


func _expect_editor_integration_chrome(theme: Theme, label: String) -> void:
	for entry in [
		{"variation": &"BottomPanel", "base": &"TabContainer"},
		{"variation": &"BottomPanelButton", "base": &"FlatMenuButton"},
		{"variation": &"EditorLogFilterButton", "base": &"Button"},
		{"variation": &"TabContainerOdd", "base": &"TabContainer"},
		{"variation": &"TreeTable", "base": &"Tree"},
		{"variation": &"RunBarButton", "base": &"FlatMenuButton"},
		{"variation": &"RunBarButtonMovieMakerEnabled", "base": &"RunBarButton"},
		{"variation": &"RunBarButtonMovieMakerDisabled", "base": &"RunBarButton"},
		{"variation": &"TopBarOptionButton", "base": &"OptionButton"},
	]:
		if theme.get_type_variation_base(entry["variation"]) != entry["base"]:
			_fail("%s %s should inherit %s" % [label, entry["variation"], entry["base"]])

	# ActionMapEditor packs Revert/Add/Remove into a compact TreeTable action column.
	# Match Godot's compact TreeTable button metric: button_margin stays zero, while the
	# TreeTable button styleboxes reserve transparent left/right space around each icon.
	_expect_equal(theme.get_constant(&"button_margin", &"TreeTable"), 0, "%s TreeTable.button_margin" % label)
	_expect_equal(theme.get_constant(&"h_separation", &"TreeTable"), 0, "%s TreeTable.h_separation" % label)
	_expect_equal(theme.get_constant(&"item_margin", &"TreeTable"), 16, "%s TreeTable.item_margin" % label)
	var table_button := theme.get_stylebox(&"button_pressed", &"TreeTable")
	if table_button == null:
		_fail("%s TreeTable.button_pressed missing" % label)
	elif table_button.get_minimum_size().x < 8.0:
		_fail("%s TreeTable.button_pressed horizontal padding too small: %s" % [label, table_button.get_minimum_size()])

	var accent := theme.get_color(&"drop_position_color", &"Tree")
	for entry in [
		{"type": &"CheckBox", "slot": &"checkbox_checked_color"},
		{"type": &"CheckButton", "slot": &"button_checked_color"},
		{"type": &"EditorLogFilterButton", "slot": &"icon_pressed_color"},
	]:
		if not theme.get_color(entry["slot"], entry["type"]).is_equal_approx(accent):
			_fail("%s %s.%s should use accent when active/checked" % [label, entry["type"], entry["slot"]])
	var button_normal := (theme.get_stylebox(&"normal", &"Button") as StyleBoxFlat).bg_color
	for entry in [
		{"type": &"CheckBox", "slot": &"checkbox_unchecked_color"},
		{"type": &"CheckButton", "slot": &"button_unchecked_color"},
	]:
		var inactive_color := theme.get_color(entry["slot"], entry["type"])
		if inactive_color.get_luminance() <= button_normal.get_luminance() + 0.03:
			_fail("%s %s.%s should be a lighter base-derived inactive fill than Button.normal" % [label, entry["type"], entry["slot"]])
		var accent_distance := absf(inactive_color.r - accent.r) + absf(inactive_color.g - accent.g) + absf(inactive_color.b - accent.b) + absf(inactive_color.a - accent.a)
		if accent_distance < 0.08:
			_fail("%s %s.%s inactive fill should not collapse into accent checked fill" % [label, entry["type"], entry["slot"]])

	for icon_name in [&"FileBigThumb", &"FileDeadBigThumb", &"FolderBigThumb", &"FileMediumThumb", &"FileDeadMediumThumb", &"FolderMediumThumb"]:
		var icon := theme.get_icon(icon_name, &"EditorIcons")
		if icon.get_size().x < 64 or icon.get_size().y < 64:
			_fail("%s EditorIcons.%s should be large enough for crisp file thumbnails, got %s" % [label, icon_name, icon.get_size()])
	for icon_slot in [&"file_thumbnail", &"folder_thumbnail"]:
		var icon := theme.get_icon(icon_slot, &"FileDialog")
		if icon.get_size().x < 64 or icon.get_size().y < 64:
			_fail("%s FileDialog.%s should be large enough for thumbnail mode, got %s" % [label, icon_slot, icon.get_size()])

	var subsection_style := theme.get_stylebox(&"prop_subsection_stylebox", &"Editor") as StyleBoxFlat
	var subsection_color := theme.get_color(&"prop_subsection", &"Editor")
	if subsection_color.a > 0.01:
		_fail("%s Editor.prop_subsection must remain transparent; Signals/Groups TreeItem custom_bg_color otherwise paints full-width over the parent edge" % label)
	if subsection_style == null:
		_fail("%s Editor.prop_subsection_stylebox missing for Signals/inspector headers" % label)
	elif subsection_style.border_width_left < 1 or subsection_style.border_width_right < 1:
		_fail("%s Editor.prop_subsection_stylebox should reserve transparent side spacing, got %s/%s/%s/%s" % [
			label,
			subsection_style.border_width_left,
			subsection_style.border_width_top,
			subsection_style.border_width_right,
			subsection_style.border_width_bottom,
		])
	elif subsection_style.border_color.a > 0.01:
		_fail("%s Editor.prop_subsection_stylebox side reservation should be transparent" % label)
	elif subsection_style.content_margin_left < 5 or subsection_style.content_margin_right < 5:
		_fail("%s Editor.prop_subsection_stylebox needs small left/right inset so parent view edges remain visible" % label)
	var group_note := theme.get_stylebox(&"bg_group_note", &"EditorProperty") as StyleBoxFlat
	if group_note == null:
		_fail("%s EditorProperty.bg_group_note missing for inspector layout hint" % label)
	elif group_note.content_margin_left < 8 or group_note.content_margin_top < 6:
		_fail("%s EditorProperty.bg_group_note needs inner padding so hint icons/text do not hug the edge" % label)
	var category_bg := theme.get_stylebox(&"bg", &"EditorInspectorCategory") as StyleBoxFlat
	if category_bg == null:
		_fail("%s EditorInspectorCategory.bg missing" % label)
	elif category_bg.bg_color.is_equal_approx(theme.get_color(&"prop_subsection", &"Editor")):
		_fail("%s EditorInspectorCategory.bg should be distinct from subsection headers" % label)

	var bottom_tab := theme.get_stylebox(&"tab_selected", &"BottomPanel") as StyleBoxFlat
	var odd_tab := theme.get_stylebox(&"tab_selected", &"TabContainerOdd") as StyleBoxFlat
	if bottom_tab == null:
		_fail("%s BottomPanel.tab_selected missing" % label)
	elif _max_border_width(bottom_tab) != 0:
		_fail("%s BottomPanel.tab_selected should not draw an outline" % label)
	if odd_tab == null:
		_fail("%s TabContainerOdd.tab_selected missing for Editor Settings tabs" % label)

	var contextual_toolbar := theme.get_stylebox(&"ContextualToolbar", &"EditorStyles") as StyleBoxFlat
	var editor_content := theme.get_stylebox(&"Content", &"EditorStyles") as StyleBoxFlat
	if contextual_toolbar == null:
		_fail("%s EditorStyles.ContextualToolbar missing for secondary contextual toolbar background" % label)
	elif editor_content != null and contextual_toolbar.bg_color.is_equal_approx(editor_content.bg_color):
		_fail("%s EditorStyles.ContextualToolbar should stand off from the viewport/editor content surface" % label)

	var code_style := theme.get_stylebox(&"normal", &"CodeEdit") as StyleBoxFlat
	var text_style := theme.get_stylebox(&"normal", &"TextEdit") as StyleBoxFlat
	if code_style == null:
		_fail("%s CodeEdit.normal missing" % label)
	elif text_style != null and code_style.bg_color.get_luminance() >= text_style.bg_color.get_luminance():
		_fail("%s CodeEdit.normal should be darker than generic TextEdit for readable code view bg" % label)
	for slider_type in [&"HSlider", &"VSlider"]:
		var grabber := theme.get_icon(&"grabber", slider_type)
		var grabber_highlight := theme.get_icon(&"grabber_highlight", slider_type)
		if grabber.get_size() != Vector2(16, 16) or grabber_highlight.get_size() != Vector2(16, 16):
			_fail("%s %s grabber icons should stay compact generated 16px rectangles, got %s/%s" % [
				label,
				slider_type,
				grabber.get_size(),
				grabber_highlight.get_size(),
			])
	var h_slider := theme.get_stylebox(&"slider", &"HSlider") as StyleBoxFlat
	if h_slider == null or h_slider.get_minimum_size().y < 4.0:
		_fail("%s HSlider.slider should have a visible track height for ColorPicker intensity sliders" % label)
	var v_slider := theme.get_stylebox(&"slider", &"VSlider") as StyleBoxFlat
	if v_slider == null or v_slider.get_minimum_size().x < 4.0:
		_fail("%s VSlider.slider should have a visible track width" % label)
	var checker := theme.get_icon(&"sample_bg", &"ColorPicker")
	if checker.get_size().x < 8 or checker.get_size().y < 8:
		_fail("%s ColorPicker.sample_bg checker texture is too small: %s" % [label, checker.get_size()])
	var hue := theme.get_icon(&"color_hue", &"ColorPicker")
	if hue.get_size() != Vector2(800, 6):
		_fail("%s ColorPicker.color_hue should be a generated 800x6 hue ramp, got %s" % [label, hue.get_size()])
	else:
		var hue_image := hue.get_image()
		var hue_red := hue_image.get_pixel(0, 0)
		var hue_cyan := hue_image.get_pixel(400, 0)
		if hue_red.r < 0.95 or hue_red.g > 0.05 or hue_red.b > 0.05:
			_fail("%s ColorPicker.color_hue left edge should start red, got %s" % [label, hue_red])
		if hue_cyan.g < 0.85 or hue_cyan.b < 0.85 or hue_cyan.r > 0.20:
			_fail("%s ColorPicker.color_hue middle should pass through cyan, got %s" % [label, hue_cyan])
	var preset_checker := theme.get_icon(&"preset_bg", &"ColorPresetButton")
	if preset_checker.get_size().x < 8 or preset_checker.get_size().y < 8:
		_fail("%s ColorPresetButton.preset_bg checker texture is too small: %s" % [label, preset_checker.get_size()])
	var preset_fg := theme.get_stylebox(&"preset_fg", &"ColorPresetButton") as StyleBoxFlat
	if preset_fg == null:
		_fail("%s ColorPresetButton.preset_fg missing for ColorPicker preset swatches" % label)
	for check_type in [&"CheckBox", &"CheckButton"]:
		_expect_check_control_state_margins_stable(theme, label, check_type)
	var spinbox_updown := theme.get_icon(&"updown", &"SpinBox")
	if spinbox_updown != null and not spinbox_updown.get_size().is_zero_approx():
		_fail("%s SpinBox.updown should stay empty so separate up/down icons center in their buttons, got %s" % [label, spinbox_updown.get_size()])
	if Engine.is_editor_hint():
		var editor_spinbox_updown := theme.get_icon(&"updown", &"EditorSpinSlider")
		if editor_spinbox_updown == null or editor_spinbox_updown.get_size().is_zero_approx():
			_fail("%s EditorSpinSlider.updown should keep its composite editor affordance" % label)


func _expect_create_dialog_chrome(theme: Theme, label: String) -> void:
	_expect_equal(theme.get_font_size("font_size", "HeaderSmall"), theme.default_font_size, "%s HeaderSmall.font_size" % label)
	if theme.get_type_variation_base(&"TreeSecondary") != &"Tree":
		_fail("%s TreeSecondary should inherit Tree for CreateDialog sidebars" % label)
	if theme.get_type_variation_base(&"ItemListSecondary") != &"ItemList":
		_fail("%s ItemListSecondary should inherit ItemList for CreateDialog recent list" % label)
	if theme.get_type_variation_base(&"EditorHelpBitTitle") != &"RichTextLabel":
		_fail("%s EditorHelpBitTitle should inherit RichTextLabel" % label)
	if theme.get_type_variation_base(&"EditorHelpBitContent") != &"RichTextLabel":
		_fail("%s EditorHelpBitContent should inherit RichTextLabel" % label)

	var neocade := theme as NeoCadeTheme
	for dialog_type in [&"AcceptDialog", &"ConfirmationDialog", &"PopupDialog"]:
		var dialog_panel := theme.get_stylebox(&"panel", dialog_type) as StyleBoxFlat
		if dialog_panel == null:
			_fail("%s missing %s.panel for editor dialog shell" % [label, dialog_type])
			continue
		if neocade != null and not dialog_panel.bg_color.is_equal_approx(neocade.base_color):
			_fail("%s %s.panel should use base color, not button fill: panel=%s base=%s" % [
				label,
				dialog_type,
				dialog_panel.bg_color.to_html(false),
				neocade.base_color.to_html(false),
			])

	var tree_panel := theme.get_stylebox(&"panel", &"Tree")
	var tree_secondary_panel := theme.get_stylebox(&"panel", &"TreeSecondary") as StyleBoxFlat
	if tree_panel == null or tree_secondary_panel == null:
		_fail("%s missing Tree/TreeSecondary panel for CreateDialog tree comparison" % label)
	elif tree_panel is StyleBoxFlat and not tree_secondary_panel.bg_color.is_equal_approx((tree_panel as StyleBoxFlat).bg_color):
		_fail("%s TreeSecondary.panel should match Tree.panel bg when Tree.panel draws a bg" % label)
	elif tree_panel is StyleBoxEmpty and tree_secondary_panel.bg_color.a < 0.99:
		_fail("%s TreeSecondary.panel should draw the explicit list surface now that Tree.panel is empty for resource pickers" % label)
	elif tree_panel is StyleBoxFlat and (tree_panel as StyleBoxFlat).bg_color.a < 0.99:
		_fail("%s Tree.panel should draw a real list surface for plain editor Tree dialogs" % label)

	var item_panel := theme.get_stylebox(&"panel", &"ItemList") as StyleBoxFlat
	var item_secondary_panel := theme.get_stylebox(&"panel", &"ItemListSecondary") as StyleBoxFlat
	if item_panel == null or item_secondary_panel == null:
		_fail("%s missing ItemList/ItemListSecondary panel for CreateDialog recent list comparison" % label)
	elif not item_secondary_panel.bg_color.is_equal_approx(item_panel.bg_color):
		_fail("%s ItemListSecondary.panel should match ItemList.panel bg: secondary=%s item=%s" % [
			label,
			item_secondary_panel.bg_color.to_html(false),
			item_panel.bg_color.to_html(false),
		])

	for help_type in [&"EditorHelpBitTitle", &"EditorHelpBitContent"]:
		var help_style := theme.get_stylebox(&"normal", help_type) as StyleBoxFlat
		if help_style == null:
			_fail("%s missing %s.normal for EditorHelpBit in CreateDialog" % [label, help_type])
			continue
		if help_style.bg_color.a < 0.99:
			_fail("%s %s.normal should draw a concrete help-bit panel" % [label, help_type])
		if _max_border_width(help_style) != 0:
			_fail("%s %s.normal should not draw an outline border" % [label, help_type])
		if help_style.content_margin_left < 6 or help_style.content_margin_top < 3:
			_fail("%s %s.normal padding too small for readable help text: %s/%s/%s/%s" % [
				label,
				help_type,
				help_style.content_margin_left,
				help_style.content_margin_top,
				help_style.content_margin_right,
				help_style.content_margin_bottom,
			])


func _expect_shared_interaction_chrome(theme: Theme, label: String) -> void:
	var button_hover := theme.get_stylebox("hover", "Button") as StyleBoxFlat
	var button_pressed := theme.get_stylebox("pressed", "Button") as StyleBoxFlat
	if button_hover == null or button_pressed == null:
		_fail("%s missing Button hover/pressed for shared interaction check" % label)
		return
	var entries := [
		{"type": &"PopupMenu", "slot": &"hover", "state": button_hover},
		{"type": &"ItemList", "slot": &"hovered", "state": button_hover},
		{"type": &"ItemList", "slot": &"selected", "state": button_pressed},
		{"type": &"ItemList", "slot": &"selected_focus", "state": button_pressed},
		{"type": &"ItemList", "slot": &"hovered_selected", "state": button_pressed},
		{"type": &"ItemList", "slot": &"hovered_selected_focus", "state": button_pressed},
		{"type": &"MenuBar", "slot": &"hover", "state": button_hover},
		{"type": &"MenuBar", "slot": &"pressed", "state": button_pressed},
		{"type": &"Tree", "slot": &"hovered", "state": button_hover},
		{"type": &"Tree", "slot": &"selected", "state": button_pressed},
		{"type": &"Tree", "slot": &"selected_focus", "state": button_pressed},
		{"type": &"Tree", "slot": &"hovered_selected", "state": button_pressed},
		{"type": &"Tree", "slot": &"hovered_selected_focus", "state": button_pressed},
		{"type": &"Tree", "slot": &"button_hover", "state": button_hover},
		{"type": &"Tree", "slot": &"button_pressed", "state": button_pressed},
		{"type": &"Tree", "slot": &"custom_button_hover", "state": button_hover},
		{"type": &"Tree", "slot": &"custom_button_pressed", "state": button_pressed},
	]
	if Engine.is_editor_hint():
		entries.append_array([
			{"type": &"ItemListSecondary", "slot": &"hovered", "state": button_hover},
			{"type": &"ItemListSecondary", "slot": &"selected", "state": button_pressed},
			{"type": &"ItemListSecondary", "slot": &"selected_focus", "state": button_pressed},
			{"type": &"ItemListSecondary", "slot": &"hovered_selected", "state": button_pressed},
			{"type": &"ItemListSecondary", "slot": &"hovered_selected_focus", "state": button_pressed},
		])

	for entry in entries:
		var stylebox := theme.get_stylebox(entry["slot"], entry["type"]) as StyleBoxFlat
		if stylebox == null:
			_fail("%s missing shared interaction stylebox %s.%s" % [label, entry["type"], entry["slot"]])
			continue
		var expected := entry["state"] as StyleBoxFlat
		if not stylebox.bg_color.is_equal_approx(expected.bg_color):
			_fail("%s %s.%s interaction color drifted: expected=%s got=%s" % [
				label,
				entry["type"],
				entry["slot"],
				expected.bg_color.to_html(false),
				stylebox.bg_color.to_html(false),
			])


func _expect_check_control_state_margins_stable(theme: Theme, label: String, theme_type: StringName) -> void:
	var normal := theme.get_stylebox(&"normal", theme_type) as StyleBoxFlat
	if normal == null:
		_fail("%s %s.normal missing StyleBoxFlat" % [label, theme_type])
		return
	var normal_margins := Vector4(
		normal.content_margin_left,
		normal.content_margin_top,
		normal.content_margin_right,
		normal.content_margin_bottom
	)
	for slot_name in [
		&"normal_mirrored",
		&"hover",
		&"hover_mirrored",
		&"pressed",
		&"pressed_mirrored",
		&"disabled",
		&"disabled_mirrored",
		&"hover_pressed",
		&"hover_pressed_mirrored",
	]:
		var state_style := theme.get_stylebox(slot_name, theme_type) as StyleBoxFlat
		if state_style == null:
			_fail("%s %s.%s missing StyleBoxFlat" % [label, theme_type, slot_name])
			continue
		var state_margins := Vector4(
			state_style.content_margin_left,
			state_style.content_margin_top,
			state_style.content_margin_right,
			state_style.content_margin_bottom
		)
		if not state_margins.is_equal_approx(normal_margins):
			_fail("%s %s.%s margins %s should match normal margins %s to prevent text shift" % [
				label,
				theme_type,
				slot_name,
				state_margins,
				normal_margins,
			])


func _expect_tree_view_chrome(theme: Theme, label: String) -> void:
	var arrow := theme.get_icon("arrow", "Tree")
	var arrow_collapsed := theme.get_icon("arrow_collapsed", "Tree")
	var item_margin := theme.get_constant("item_margin", "Tree")
	var min_arrow_width := int(maxf(arrow.get_size().x, arrow_collapsed.get_size().x))
	if item_margin < min_arrow_width:
		_fail("%s Tree.item_margin is too small for fold arrow gutter: margin=%s arrow_width=%s" % [label, item_margin, min_arrow_width])

	var accent := theme.get_color("drop_position_color", "Tree")
	for color_name in [&"font_selected_color", &"font_hovered_selected_color"]:
		var selected_font := theme.get_color(color_name, "Tree")
		if not selected_font.is_equal_approx(accent):
			_fail("%s Tree.%s should use accent color for selected item text: expected=%s got=%s" % [
				label,
				color_name,
				accent.to_html(false),
				selected_font.to_html(false),
			])

	var tree_scroll_hint := theme.get_icon("scroll_hint", "Tree")
	var tree_hint_size := tree_scroll_hint.get_size()
	if tree_hint_size.x <= tree_hint_size.y:
		_fail("%s Tree.scroll_hint should be a horizontal fade texture, not a square glyph: size=%s" % [label, tree_hint_size])
	if not theme.get_color("scroll_hint_color", "Tree").is_equal_approx(Color.BLACK):
		_fail("%s Tree.scroll_hint_color should be neutral black like Godot's default fade modulate" % label)

	var item_scroll_hint := theme.get_icon("scroll_hint", "ItemList")
	var item_hint_size := item_scroll_hint.get_size()
	if item_hint_size.x <= item_hint_size.y:
		_fail("%s ItemList.scroll_hint should be a horizontal fade texture, not a square glyph: size=%s" % [label, item_hint_size])
	if not theme.get_color("scroll_hint_color", "ItemList").is_equal_approx(Color.BLACK):
		_fail("%s ItemList.scroll_hint_color should be neutral black like Godot's default fade modulate" % label)

	_expect_equal(theme.get_constant(&"draw_guides", &"Tree"), 0, "%s Tree.draw_guides" % label)
	if theme.get_color(&"guide_color", &"Tree").a > 0.01:
		_fail("%s Tree.guide_color should stay transparent; row guide/separator lines remain hidden" % label)
	_expect_equal(theme.get_constant(&"draw_relationship_lines", &"Tree"), 1, "%s Tree.draw_relationship_lines" % label)
	_expect_equal(theme.get_constant(&"relationship_line_width", &"Tree"), 0, "%s Tree.relationship_line_width for selected-only mode" % label)
	for constant_name in [&"parent_hl_line_width", &"children_hl_line_width"]:
		if theme.get_constant(constant_name, "Tree") < 1:
			_fail("%s Tree.%s should be at least 1 so selected parent-child nesting paths are visible" % [label, constant_name])
	_expect_equal(theme.get_constant(&"parent_hl_line_margin", &"Tree"), 3, "%s Tree.parent_hl_line_margin" % label)

	var relationship_line := theme.get_color(&"relationship_line_color", &"Tree")
	var parent_line := theme.get_color(&"parent_hl_line_color", &"Tree")
	var children_line := theme.get_color(&"children_hl_line_color", &"Tree")
	if relationship_line.a < 0.08 or relationship_line.a > 0.30:
		_fail("%s Tree.relationship_line_color should follow editor relationship_line_opacity, alpha=%.2f" % [label, relationship_line.a])
	if parent_line.a <= relationship_line.a:
		_fail("%s Tree.parent_hl_line_color should be stronger than relationship_line_color for the selected branch" % label)
	if children_line.a < relationship_line.a:
		_fail("%s Tree.children_hl_line_color should be at least as visible as normal relationship lines" % label)

	for slot_name in [
		&"title_button_normal",
		&"title_button_hover",
		&"title_button_pressed",
		&"custom_button",
		&"hovered",
		&"selected",
		&"selected_focus",
		&"hovered_selected",
		&"hovered_selected_focus",
	]:
		var stylebox := theme.get_stylebox(slot_name, "Tree") as StyleBoxFlat
		if stylebox == null:
			_fail("%s missing Tree.%s stylebox" % [label, slot_name])
			continue
		if _max_border_width(stylebox) != 0:
			_fail("%s Tree.%s should not draw borders: %s/%s/%s/%s" % [
				label,
				slot_name,
				stylebox.border_width_left,
				stylebox.border_width_top,
				stylebox.border_width_right,
				stylebox.border_width_bottom,
			])

	var tree_button_h := 9.0 if label.begins_with("mobile:") else 6.0
	for slot_name in [
		&"button_hover",
		&"button_pressed",
		&"custom_button",
		&"custom_button_hover",
		&"custom_button_pressed",
	]:
		var button_style := theme.get_stylebox(slot_name, "Tree") as StyleBoxFlat
		if button_style == null:
			_fail("%s missing Tree.%s icon-button stylebox" % [label, slot_name])
			continue
		if button_style.content_margin_left < tree_button_h or button_style.content_margin_right < tree_button_h:
			_fail("%s Tree.%s should reserve side padding for editor item icons, got %.1f/%.1f" % [
				label,
				slot_name,
				button_style.content_margin_left,
				button_style.content_margin_right,
			])
		if button_style.content_margin_top > 1.0 or button_style.content_margin_bottom > 1.0:
			_fail("%s Tree.%s should not inflate row height, got top/bottom %.1f/%.1f" % [
				label,
				slot_name,
				button_style.content_margin_top,
				button_style.content_margin_bottom,
			])


func _expect_list_view_chrome(theme: Theme, label: String) -> void:
	var accent := theme.get_color("drop_position_color", "Tree")
	var button_pressed := theme.get_stylebox("pressed", "Button") as StyleBoxFlat
	if button_pressed == null:
		_fail("%s missing Button.pressed for ItemList selected comparison" % label)
		return

	var theme_types := [&"ItemList"]
	if Engine.is_editor_hint():
		theme_types.append(&"ItemListSecondary")

	for theme_type in theme_types:
		var panel := theme.get_stylebox(&"panel", theme_type) as StyleBoxFlat
		if panel == null:
			_fail("%s missing %s.panel for list view chrome" % [label, theme_type])
		elif _max_border_width(panel) != 0:
			_fail("%s %s.panel should not draw a border/outline: %s/%s/%s/%s" % [
				label,
				theme_type,
				panel.border_width_left,
				panel.border_width_top,
				panel.border_width_right,
				panel.border_width_bottom,
			])

		for color_name in [&"font_selected_color", &"font_hovered_selected_color"]:
			var selected_font := theme.get_color(color_name, theme_type)
			if not selected_font.is_equal_approx(accent):
				_fail("%s %s.%s should use accent color for selected item text: expected=%s got=%s" % [
					label,
					theme_type,
					color_name,
					accent.to_html(false),
					selected_font.to_html(false),
				])

		if theme.get_color(&"guide_color", theme_type).a > 0.01:
			_fail("%s %s.guide_color should be transparent so ItemList separators are hidden" % [label, theme_type])
		if theme.get_color(&"font_outline_color", theme_type).a > 0.01:
			_fail("%s %s.font_outline_color should be transparent because outline_size is 0" % [label, theme_type])
		_expect_equal(theme.get_constant(&"outline_size", theme_type), 0, "%s %s.outline_size" % [label, theme_type])

		for slot_name in [&"selected", &"selected_focus", &"hovered_selected", &"hovered_selected_focus"]:
			var selected_style := theme.get_stylebox(slot_name, theme_type) as StyleBoxFlat
			if selected_style == null:
				_fail("%s missing %s.%s selected list style" % [label, theme_type, slot_name])
				continue
			if not selected_style.bg_color.is_equal_approx(button_pressed.bg_color):
				_fail("%s %s.%s should share Button.pressed background: expected=%s got=%s" % [
					label,
					theme_type,
					slot_name,
					button_pressed.bg_color.to_html(false),
					selected_style.bg_color.to_html(false),
				])
			if _max_border_width(selected_style) != 0:
				_fail("%s %s.%s should not draw a selected border/outline: %s/%s/%s/%s" % [
					label,
					theme_type,
					slot_name,
					selected_style.border_width_left,
					selected_style.border_width_top,
					selected_style.border_width_right,
					selected_style.border_width_bottom,
				])


func _expect_split_container_chrome(theme: Theme, label: String) -> void:
	for theme_type in [&"SplitContainer", &"HSplitContainer", &"VSplitContainer"]:
		var split_bar := theme.get_stylebox("split_bar_background", theme_type)
		if split_bar == null:
			_fail("%s missing %s.split_bar_background" % [label, theme_type])
			continue
		if not (split_bar is StyleBoxEmpty):
			_fail("%s %s.split_bar_background should be StyleBoxEmpty so the gap inherits its parent surface, got %s" % [
				label,
				theme_type,
				split_bar.get_class(),
			])
			continue
		if split_bar.get_margin(SIDE_LEFT) != 0.0 or split_bar.get_margin(SIDE_TOP) != 0.0 or split_bar.get_margin(SIDE_RIGHT) != 0.0 or split_bar.get_margin(SIDE_BOTTOM) != 0.0:
			_fail("%s %s.split_bar_background should have zero empty margins: %s/%s/%s/%s" % [
				label,
				theme_type,
				split_bar.get_margin(SIDE_LEFT),
				split_bar.get_margin(SIDE_TOP),
				split_bar.get_margin(SIDE_RIGHT),
				split_bar.get_margin(SIDE_BOTTOM),
			])
		_expect_equal(theme.get_constant("autohide", theme_type), 1, "%s %s.autohide" % [label, theme_type])
		_expect_equal(theme.get_constant("separation", theme_type), 6, "%s %s.separation" % [label, theme_type])
		_expect_equal(theme.get_constant("minimum_grab_thickness", theme_type), 6, "%s %s.minimum_grab_thickness" % [label, theme_type])

	_expect_split_grabber_icon(theme, "SplitContainer", "h_grabber", true, label)
	_expect_split_grabber_icon(theme, "SplitContainer", "v_grabber", false, label)
	_expect_split_grabber_icon(theme, "HSplitContainer", "grabber", true, label)
	_expect_split_grabber_icon(theme, "VSplitContainer", "grabber", false, label)

	var dragger_normal := theme.get_color("touch_dragger_color", "SplitContainer")
	var dragger_hover := theme.get_color("touch_dragger_hover_color", "SplitContainer")
	var dragger_pressed := theme.get_color("touch_dragger_pressed_color", "SplitContainer")
	if _contrast_ratio(dragger_normal, dragger_hover) < 1.10:
		_fail("%s SplitContainer touch dragger hover color is too close to normal" % label)
	if dragger_hover.is_equal_approx(dragger_pressed):
		_fail("%s SplitContainer touch dragger pressed color is too close to hover" % label)


func _expect_split_grabber_icon(theme: Theme, theme_type: StringName, slot_name: StringName, vertical_indicator: bool, label: String) -> void:
	if not theme.has_icon(slot_name, theme_type):
		_fail("%s missing split grabber icon %s.%s" % [label, theme_type, slot_name])
		return
	var size := theme.get_icon(slot_name, theme_type).get_size()
	if vertical_indicator:
		if size.x != 6 or size.y < 48:
			_fail("%s %s.%s should be a 6px-thick long vertical indicator, got %s" % [label, theme_type, slot_name, size])
	else:
		if size.y != 6 or size.x < 48:
			_fail("%s %s.%s should be a 6px-thick long horizontal indicator, got %s" % [label, theme_type, slot_name, size])


func _expect_button_surface_chrome(theme: NeoCadeTheme, label: String, expect_raised: bool) -> void:
	for theme_type in [&"Button", &"OptionButton", &"MenuButton", &"ColorPickerButton", &"IconButton"]:
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
		_expect_state_step_visibility(normal, hover, pressed, label, theme_type, 1.10, 1.08)


func _expect_colored_button_raised_chrome(theme: NeoCadeTheme, label: String, expect_raised: bool) -> void:
	for theme_type in [&"PrimaryButton", &"DangerButton"]:
		var normal := theme.get_stylebox("normal", theme_type) as StyleBoxFlat
		var hover := theme.get_stylebox("hover", theme_type) as StyleBoxFlat
		var pressed := theme.get_stylebox("pressed", theme_type) as StyleBoxFlat
		if normal == null or hover == null or pressed == null:
			_fail("%s missing colored button stylebox for %s" % [label, theme_type])
			continue
		if normal.shadow_size != 0 or normal.shadow_offset != Vector2.ZERO:
			_fail("%s %s still uses StyleBoxFlat shadow" % [label, theme_type])
		if normal.border_width_left < 1 or normal.border_width_top < 1 or normal.border_width_right < 1:
			_fail("%s %s should use the same flat face edge model as Button" % [label, theme_type])
		if not expect_raised and _max_border_width(normal) > 1:
			_fail("%s flat %s border too thick: %s/%s/%s/%s" % [
				label,
				theme_type,
				normal.border_width_left,
				normal.border_width_top,
				normal.border_width_right,
				normal.border_width_bottom,
			])
		if normal.bg_color.is_equal_approx(hover.bg_color) or hover.bg_color.is_equal_approx(pressed.bg_color):
			_fail("%s %s hover/pressed states do not produce a visible face-color ramp" % [label, theme_type])
		_expect_state_step_visibility(normal, hover, pressed, label, theme_type, 1.10, 1.08)
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
		if edge_contrast < 1.06:
			_fail("%s raised %s colored rim is too subtle: ratio=%.2f" % [label, theme_type, edge_contrast])
		_expect_reserved_bottom_depth(normal, label, theme_type)


func _expect_ghost_button_raised_chrome(theme: NeoCadeTheme, label: String, expect_raised: bool) -> void:
	var normal := theme.get_stylebox("normal", "GhostButton") as StyleBoxFlat
	var hover := theme.get_stylebox("hover", "GhostButton") as StyleBoxFlat
	var pressed := theme.get_stylebox("pressed", "GhostButton") as StyleBoxFlat
	if normal == null or hover == null or pressed == null:
		_fail("%s missing GhostButton state styleboxes" % label)
		return
	if normal.shadow_size != 0 or normal.shadow_offset != Vector2.ZERO:
		_fail("%s GhostButton still uses StyleBoxFlat shadow" % label)
	if normal.bg_color.a > 0.01:
		_fail("%s GhostButton.normal should stay transparent: alpha=%.2f" % [label, normal.bg_color.a])
	if hover.bg_color.a <= normal.bg_color.a or pressed.bg_color.a < hover.bg_color.a:
		_fail("%s GhostButton hover/pressed state layer alpha is not increasing: normal=%.2f hover=%.2f pressed=%.2f" % [
			label,
			normal.bg_color.a,
			hover.bg_color.a,
			pressed.bg_color.a,
		])
	if pressed.border_width_left < 1 or pressed.border_width_top < 1 or pressed.border_width_right < 1 or pressed.border_width_bottom < 1:
		_fail("%s GhostButton.pressed lost its outline border" % label)
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


func _expect_progress_bar_text_chrome(theme: Theme, label: String) -> void:
	var background := theme.get_stylebox("background", "ProgressBar") as StyleBoxFlat
	var fill := theme.get_stylebox("fill", "ProgressBar") as StyleBoxFlat
	if background == null or fill == null:
		_fail("%s missing ProgressBar background/fill styleboxes" % label)
		return
	var font_color := theme.get_color("font_color", "ProgressBar")
	var outline_color := theme.get_color("font_outline_color", "ProgressBar")
	var outline_size := theme.get_constant("outline_size", "ProgressBar")
	var track_text_contrast := _contrast_ratio(background.bg_color, font_color)
	var fill_outline_contrast := _contrast_ratio(fill.bg_color, outline_color)
	if track_text_contrast < MIN_TEXT_CONTRAST:
		_fail("%s ProgressBar.font_color does not contrast with empty track: ratio=%.2f track=%s font=%s" % [
			label,
			track_text_contrast,
			background.bg_color.to_html(false),
			font_color.to_html(false),
		])
	if not outline_color.is_equal_approx(background.bg_color):
		_fail("%s ProgressBar.font_outline_color should match the track background: track=%s outline=%s" % [
			label,
			background.bg_color.to_html(false),
			outline_color.to_html(false),
		])
	if fill_outline_contrast < MIN_TEXT_CONTRAST:
		_fail("%s ProgressBar.font_outline_color does not contrast with full fill: ratio=%.2f fill=%s outline=%s" % [
			label,
			fill_outline_contrast,
			fill.bg_color.to_html(false),
			outline_color.to_html(false),
		])
	if outline_size < 2:
		_fail("%s ProgressBar.outline_size should be at least 2 for mixed fill/track text readability, got %s" % [label, outline_size])


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


func _expect_state_step_visibility(
	normal: StyleBoxFlat,
	hover: StyleBoxFlat,
	pressed: StyleBoxFlat,
	label: String,
	theme_type: String,
	min_hover_ratio: float,
	min_pressed_ratio: float
) -> void:
	var hover_ratio := _contrast_ratio(normal.bg_color, hover.bg_color)
	var pressed_ratio := _contrast_ratio(hover.bg_color, pressed.bg_color)
	if hover_ratio < min_hover_ratio:
		_fail("%s %s normal->hover delta is too subtle: ratio=%.2f" % [label, theme_type, hover_ratio])
	if pressed_ratio < min_pressed_ratio:
		_fail("%s %s hover->pressed delta is too subtle: ratio=%.2f" % [label, theme_type, pressed_ratio])


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


func _expect_color_equal(actual: Color, expected: Color, label: String) -> void:
	if not actual.is_equal_approx(expected):
		_fail("%s expected %s got %s" % [label, expected.to_html(true), actual.to_html(true)])


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
