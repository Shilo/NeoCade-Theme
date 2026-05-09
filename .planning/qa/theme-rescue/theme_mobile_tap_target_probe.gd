extends SceneTree

const TARGET := 48.0

var _failures: PackedStringArray = []


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var theme := load("res://addons/neocade_theme/neocade_theme.tres").duplicate(true) as NeoCadeTheme
	theme.platform = NeoCadeTheme.Platform.MOBILE

	var root_control := Control.new()
	root.add_child(root_control)
	root_control.theme = theme

	var checks: Array[Dictionary] = [
		{"name": "Button", "node": Button.new(), "axis": "height", "text": "Button"},
		{"name": "PrimaryButton", "node": Button.new(), "axis": "height", "text": "Primary", "variation": &"PrimaryButton"},
		{"name": "GhostButton", "node": Button.new(), "axis": "height", "text": "Ghost", "variation": &"GhostButton"},
		{"name": "DangerButton", "node": Button.new(), "axis": "height", "text": "Danger", "variation": &"DangerButton"},
		{"name": "IconButton", "node": Button.new(), "axis": "both", "icon": true, "variation": &"IconButton"},
		{"name": "FlatButton", "node": Button.new(), "axis": "both", "icon": true, "variation": &"FlatButton"},
		{"name": "FlatMenuButton", "node": MenuButton.new(), "axis": "both", "icon": true, "variation": &"FlatMenuButton"},
		{"name": "CheckBox", "node": CheckBox.new(), "axis": "height", "text": "On"},
		{"name": "CheckButton", "node": CheckButton.new(), "axis": "height", "text": "On"},
		{"name": "RadioButton", "node": CheckBox.new(), "axis": "height", "text": "Auto", "radio": true},
		{"name": "ColorPickerButton", "node": ColorPickerButton.new(), "axis": "colorpicker_compatible", "custom_min": Vector2(48, 48)},
		{"name": "MenuButton", "node": MenuButton.new(), "axis": "height", "text": "Menu"},
		{"name": "OptionButton", "node": OptionButton.new(), "axis": "height"},
		{"name": "LineEdit", "node": LineEdit.new(), "axis": "height"},
		{"name": "SpinBox", "node": SpinBox.new(), "axis": "height"},
		{"name": "HSlider", "node": HSlider.new(), "axis": "height"},
		{"name": "VSlider", "node": VSlider.new(), "axis": "width"},
		{"name": "FoldableContainer", "node": FoldableContainer.new(), "axis": "height", "title": "Section"},
		{"name": "HScrollBar", "node": HScrollBar.new(), "axis": "compact_height"},
		{"name": "VScrollBar", "node": VScrollBar.new(), "axis": "compact_width"},
		{"name": "TabBar", "node": TabBar.new(), "axis": "height", "tab": true},
		{"name": "PopupMenuItem", "node": PopupMenu.new(), "axis": "height", "popup": true},
	]

	for check in checks:
		var node := check["node"] as Node
		root.add_child(node) if node is Window else root_control.add_child(node)
		if node is Control:
			(node as Control).theme = theme
		elif node is Window:
			(node as Window).theme = theme
		if check.has("text"):
			node.set("text", check["text"])
		if check.has("title"):
			node.set("title", check["title"])
		if check.has("variation"):
			(node as Control).theme_type_variation = check["variation"]
		if check.has("custom_min"):
			(node as Control).custom_minimum_size = check["custom_min"]
		if check.get("icon", false):
			(node as Button).icon = _make_probe_icon()
		if check.get("radio", false):
			(node as CheckBox).set_button_group(ButtonGroup.new())
		if check.get("tab", false):
			(node as TabBar).add_tab("Tab")
		if check.get("popup", false):
			var popup := node as PopupMenu
			popup.add_item("Menu item")
			var item_height := _popup_item_height(popup)
			_log_and_check(check["name"], Vector2(0, item_height), check["axis"])
		else:
			_log_and_check(check["name"], (node as Control).get_combined_minimum_size(), check["axis"])

	_check_mobile_icon_sizes(theme)
	_check_mobile_window_chrome(theme)
	_check_mobile_list_rows(theme)
	_check_mobile_popup_icons(theme)
	var fallback_popup_theme := theme.duplicate(true) as NeoCadeTheme
	fallback_popup_theme.use_runtime_popup_selection_icons = false
	_check_mobile_popup_icons(fallback_popup_theme, "fallback")

	if _failures.is_empty():
		print("THEME_MOBILE_TAP_TARGET_PROBE: PASS")
	else:
		for failure in _failures:
			push_error(failure)
		print("THEME_MOBILE_TAP_TARGET_PROBE: FAIL count=%d" % _failures.size())
	quit(_failures.size())


func _popup_item_height(popup: PopupMenu) -> float:
	var font := popup.get_theme_font("font")
	var font_size := popup.get_theme_font_size("font_size")
	var v_separation := popup.get_theme_constant("v_separation")
	return float(font.get_height(font_size) + v_separation)


func _make_probe_icon() -> Texture2D:
	var image := Image.create(16, 16, false, Image.FORMAT_RGBA8)
	image.fill(Color.WHITE)
	return ImageTexture.create_from_image(image)


func _log_and_check(label: String, size: Vector2, axis: String) -> void:
	print("MOBILE_TAP_TARGET %-18s min_size=%s axis=%s" % [label, size, axis])
	if axis == "height" and size.y < TARGET:
		_failures.append("%s height %.1f below %.1f" % [label, size.y, TARGET])
	elif axis == "limited_height" and size.y < TARGET:
		print("MOBILE_TAP_TARGET_LIMITED %s height %.1f below %.1f; Godot exposes no theme-only min-size slot without shrinking the swatch." % [label, size.y, TARGET])
	elif axis == "width" and size.x < TARGET:
		_failures.append("%s width %.1f below %.1f" % [label, size.x, TARGET])
	elif axis == "both" and (size.x < TARGET or size.y < TARGET):
		_failures.append("%s size %s below %.1f on at least one axis" % [label, size, TARGET])
	elif axis == "colorpicker_compatible":
		if size.x < TARGET or size.y < TARGET:
			_failures.append("%s custom minimum %s below %.1f on at least one axis" % [label, size, TARGET])
		var panel := (load("res://addons/neocade_theme/neocade_theme.tres") as Theme).get_stylebox(&"normal", &"ColorPickerButton")
		if panel != null and panel.get_minimum_size().x > 8.0:
			_failures.append("%s chrome minimum %s would consume too much of a 48px swatch" % [label, panel.get_minimum_size()])
	elif axis == "compact_height" and (size.y < 6.0 or size.y > 8.0):
		_failures.append("%s mobile indicator height %.1f should stay compact in 6-8 logical px" % [label, size.y])
	elif axis == "compact_width" and (size.x < 6.0 or size.x > 8.0):
		_failures.append("%s mobile indicator width %.1f should stay compact in 6-8 logical px" % [label, size.x])


func _check_mobile_icon_sizes(theme: Theme) -> void:
	_expect_icon_at_least(theme, &"CheckBox", &"checked", Vector2(40, 40))
	_expect_icon_at_least(theme, &"CheckBox", &"unchecked", Vector2(40, 40))
	_expect_icon_at_least(theme, &"CheckBox", &"radio_checked", Vector2(40, 40))
	_expect_icon_at_least(theme, &"CheckBox", &"radio_unchecked", Vector2(40, 40))
	_expect_icon_at_least(theme, &"CheckButton", &"checked", Vector2(56, 29))
	_expect_icon_at_least(theme, &"CheckButton", &"unchecked", Vector2(56, 29))
	_expect_icon_at_least(theme, &"HSlider", &"grabber", Vector2(48, 48))
	_expect_icon_at_least(theme, &"VSlider", &"grabber", Vector2(48, 48))
	_expect_visible_icon_bbox_at_least(theme, &"HSlider", &"grabber", Vector2(20, 20))
	_expect_visible_icon_bbox_at_least(theme, &"VSlider", &"grabber", Vector2(20, 20))
	_expect_stylebox_axis_at_least(theme, &"HSlider", &"slider", "height", 8.0)
	_expect_stylebox_axis_at_least(theme, &"VSlider", &"slider", "width", 8.0)
	_expect_icon_at_least(theme, &"FoldableContainer", &"expanded_arrow", Vector2(24, 24))
	_expect_icon_at_least(theme, &"FoldableContainer", &"folded_arrow", Vector2(24, 24))
	_expect_icon_at_least(theme, &"LineEdit", &"clear", Vector2(24, 24))
	_expect_icon_at_least(theme, &"TabBar", &"increment", Vector2(24, 24))
	_expect_icon_at_least(theme, &"TabBar", &"decrement", Vector2(24, 24))


func _check_mobile_window_chrome(theme: Theme) -> void:
	var close_icon := theme.get_icon(&"close", &"Window")
	var close_size := close_icon.get_size()
	var title_height := theme.get_constant(&"title_height", &"Window")
	var close_v_offset := theme.get_constant(&"close_v_offset", &"Window")
	print("MOBILE_WINDOW close_size=%s title_height=%d close_v_offset=%d" % [close_size, title_height, close_v_offset])
	if close_size.x < 24.0 or close_size.y < 24.0:
		_failures.append("Window.close mobile icon %s below 24px" % close_size)
	if title_height < TARGET:
		_failures.append("Window.title_height %d below %.1f" % [title_height, TARGET])
	var expected_center := (float(title_height) + close_size.y) * 0.5
	if absf(float(close_v_offset) - expected_center) > 1.0:
		_failures.append("Window.close_v_offset %d should center %s icon in %d title height, expected %.1f" % [close_v_offset, close_size, title_height, expected_center])


func _check_mobile_list_rows(theme: Theme) -> void:
	for theme_type in [&"ItemList", &"Tree"]:
		var font := theme.get_font(&"font", theme_type)
		var font_size := theme.get_font_size(&"font_size", theme_type)
		var row_height := font.get_height(font_size) + theme.get_constant(&"v_separation", theme_type)
		print("MOBILE_ROW %-10s row_height=%.1f font_size=%d v_separation=%d" % [theme_type, row_height, font_size, theme.get_constant(&"v_separation", theme_type)])
		if row_height < TARGET:
			_failures.append("%s mobile row height %.1f below %.1f" % [theme_type, row_height, TARGET])


func _check_mobile_popup_icons(theme: Theme, label: String = "generated") -> void:
	print("MOBILE_POPUP_MODE %s" % label)
	_expect_icon_at_least(theme, &"PopupMenu", &"checked", Vector2(40, 40))
	_expect_icon_at_least(theme, &"PopupMenu", &"checked_disabled", Vector2(40, 40))
	_expect_icon_at_least(theme, &"PopupMenu", &"unchecked", Vector2(40, 40))
	_expect_icon_at_least(theme, &"PopupMenu", &"radio_checked", Vector2(40, 40))
	_expect_icon_at_least(theme, &"PopupMenu", &"radio_checked_disabled", Vector2(40, 40))
	_expect_icon_at_least(theme, &"PopupMenu", &"radio_unchecked", Vector2(40, 40))
	_expect_icon_at_least(theme, &"PopupMenu", &"search", Vector2(32, 32))
	if label == "generated":
		_expect_icons_visibly_different(theme, &"PopupMenu", &"checked", &"checked_disabled")
		_expect_icons_visibly_different(theme, &"PopupMenu", &"radio_checked", &"radio_checked_disabled")
	var icon_max_width := theme.get_constant(&"icon_max_width", &"PopupMenu")
	print("MOBILE_POPUP icon_max_width=%d" % icon_max_width)
	if icon_max_width < 40:
		_failures.append("PopupMenu.icon_max_width %d below 40 for mobile selection icons" % icon_max_width)


func _expect_icon_at_least(theme: Theme, theme_type: StringName, slot: StringName, minimum: Vector2) -> void:
	var icon := theme.get_icon(slot, theme_type)
	var size := icon.get_size()
	print("MOBILE_ICON %-18s %-20s size=%s min=%s" % [theme_type, slot, size, minimum])
	if size.x < minimum.x or size.y < minimum.y:
		_failures.append("%s.%s icon %s below %s" % [theme_type, slot, size, minimum])


func _expect_visible_icon_bbox_at_least(theme: Theme, theme_type: StringName, slot: StringName, minimum: Vector2) -> void:
	var image := theme.get_icon(slot, theme_type).get_image()
	if image == null:
		_failures.append("%s.%s image data unavailable for visible-size check" % [theme_type, slot])
		return
	var min_x := image.get_width()
	var min_y := image.get_height()
	var max_x := -1
	var max_y := -1
	for y in range(image.get_height()):
		for x in range(image.get_width()):
			if image.get_pixel(x, y).a > 0.05:
				min_x = mini(min_x, x)
				min_y = mini(min_y, y)
				max_x = maxi(max_x, x)
				max_y = maxi(max_y, y)
	if max_x < min_x or max_y < min_y:
		_failures.append("%s.%s has no visible alpha for mobile icon check" % [theme_type, slot])
		return
	var visible_size := Vector2(max_x - min_x + 1, max_y - min_y + 1)
	print("MOBILE_ICON_VISIBLE %-18s %-20s visible=%s min=%s" % [theme_type, slot, visible_size, minimum])
	if visible_size.x < minimum.x or visible_size.y < minimum.y:
		_failures.append("%s.%s visible bbox %s below %s" % [theme_type, slot, visible_size, minimum])


func _expect_stylebox_axis_at_least(theme: Theme, theme_type: StringName, slot: StringName, axis: String, minimum: float) -> void:
	var stylebox := theme.get_stylebox(slot, theme_type)
	var size := stylebox.get_minimum_size()
	print("MOBILE_STYLEBOX %-18s %-20s min_size=%s" % [theme_type, slot, size])
	if axis == "height" and size.y < minimum:
		_failures.append("%s.%s height %.1f below %.1f" % [theme_type, slot, size.y, minimum])
	elif axis == "width" and size.x < minimum:
		_failures.append("%s.%s width %.1f below %.1f" % [theme_type, slot, size.x, minimum])


func _expect_icons_visibly_different(theme: Theme, theme_type: StringName, first_slot: StringName, second_slot: StringName) -> void:
	var first_image := theme.get_icon(first_slot, theme_type).get_image()
	var second_image := theme.get_icon(second_slot, theme_type).get_image()
	if first_image == null or second_image == null:
		_failures.append("%s.%s/%s image data unavailable for disabled-state comparison" % [theme_type, first_slot, second_slot])
		return
	var sample := Vector2i(12, 12)
	var first_color := first_image.get_pixel(sample.x, sample.y)
	var second_color := second_image.get_pixel(sample.x, sample.y)
	var distance := absf(first_color.r - second_color.r) + absf(first_color.g - second_color.g) + absf(first_color.b - second_color.b)
	print("MOBILE_ICON_STATE %-18s %s/%s distance=%.3f" % [theme_type, first_slot, second_slot, distance])
	if distance < 0.05:
		_failures.append("%s.%s and %s should differ so disabled PopupMenu icons do not read active" % [theme_type, first_slot, second_slot])
