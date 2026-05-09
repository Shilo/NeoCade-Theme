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
	_expect_icon_at_least(theme, &"CheckBox", &"checked", Vector2(32, 32))
	_expect_icon_at_least(theme, &"CheckBox", &"unchecked", Vector2(32, 32))
	_expect_icon_at_least(theme, &"CheckBox", &"radio_checked", Vector2(32, 32))
	_expect_icon_at_least(theme, &"CheckBox", &"radio_unchecked", Vector2(32, 32))
	_expect_icon_at_least(theme, &"CheckButton", &"checked", Vector2(46, 24))
	_expect_icon_at_least(theme, &"CheckButton", &"unchecked", Vector2(46, 24))
	_expect_icon_at_least(theme, &"LineEdit", &"clear", Vector2(24, 24))
	_expect_icon_at_least(theme, &"TabBar", &"increment", Vector2(24, 24))
	_expect_icon_at_least(theme, &"TabBar", &"decrement", Vector2(24, 24))


func _expect_icon_at_least(theme: Theme, theme_type: StringName, slot: StringName, minimum: Vector2) -> void:
	var icon := theme.get_icon(slot, theme_type)
	var size := icon.get_size()
	print("MOBILE_ICON %-18s %-20s size=%s min=%s" % [theme_type, slot, size, minimum])
	if size.x < minimum.x or size.y < minimum.y:
		_failures.append("%s.%s icon %s below %s" % [theme_type, slot, size, minimum])
