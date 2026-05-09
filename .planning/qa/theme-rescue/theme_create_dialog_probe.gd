extends SceneTree

const THEME_PATH := "res://addons/neocade_theme/neocade_theme.tres"

var _failures: PackedStringArray = []


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	if not Engine.is_editor_hint():
		print("THEME_CREATE_DIALOG_PROBE: SKIP Engine.is_editor_hint() is false; editor-only CreateDialog variations are gated in runtime")
		quit(0)
		return

	var canonical := load(THEME_PATH) as NeoCadeTheme
	if canonical == null:
		_fail("theme_create_dialog_probe: canonical theme did not load as NeoCadeTheme")
		_finish()
		return

	for style_value in NeoCadeTheme.selectable_styles():
		var theme := canonical.duplicate(true) as NeoCadeTheme
		theme.style = style_value
		theme.raised = false
		theme.platform = NeoCadeTheme.Platform.DESKTOP
		_check_theme(theme, NeoCadeTheme.style_label(style_value))

	_finish()


func _check_theme(theme: NeoCadeTheme, label: String) -> void:
	_expect_equal(theme.get_font_size(&"font_size", &"HeaderSmall"), theme.default_font_size, "%s HeaderSmall.font_size" % label)
	_expect_equal(theme.get_type_variation_base(&"TreeSecondary"), &"Tree", "%s TreeSecondary base" % label)
	_expect_equal(theme.get_type_variation_base(&"ItemListSecondary"), &"ItemList", "%s ItemListSecondary base" % label)
	_expect_equal(theme.get_type_variation_base(&"EditorHelpBitTitle"), &"RichTextLabel", "%s EditorHelpBitTitle base" % label)
	_expect_equal(theme.get_type_variation_base(&"EditorHelpBitContent"), &"RichTextLabel", "%s EditorHelpBitContent base" % label)

	if ClassDB.class_exists(&"CreateDialog") and not ClassDB.is_parent_class(&"CreateDialog", &"ConfirmationDialog"):
		_fail("%s CreateDialog should inherit ConfirmationDialog" % label)

	for dialog_type in [&"AcceptDialog", &"ConfirmationDialog", &"PopupDialog"]:
		var panel := theme.get_stylebox(&"panel", dialog_type) as StyleBoxFlat
		if panel == null:
			_fail("%s missing %s.panel" % [label, dialog_type])
			continue
		if not panel.bg_color.is_equal_approx(theme.base_color):
			_fail("%s %s.panel bg should be base color: got=%s base=%s" % [
				label,
				dialog_type,
				panel.bg_color.to_html(false),
				theme.base_color.to_html(false),
			])

	var tree_panel := theme.get_stylebox(&"panel", &"Tree")
	var tree_secondary_panel := theme.get_stylebox(&"panel", &"TreeSecondary") as StyleBoxFlat
	if tree_panel == null or tree_secondary_panel == null:
		_fail("%s missing Tree/TreeSecondary panel" % label)
	elif tree_panel is StyleBoxFlat and not (tree_panel as StyleBoxFlat).bg_color.is_equal_approx(tree_secondary_panel.bg_color):
		_fail("%s TreeSecondary.panel should match Tree.panel when Tree.panel draws a bg" % label)
	elif tree_panel is StyleBoxEmpty and tree_secondary_panel.bg_color.a < 0.99:
		_fail("%s TreeSecondary.panel should draw a contextual surface when Tree.panel is empty" % label)

	var item_panel := theme.get_stylebox(&"panel", &"ItemList") as StyleBoxFlat
	var item_secondary_panel := theme.get_stylebox(&"panel", &"ItemListSecondary") as StyleBoxFlat
	if item_panel == null or item_secondary_panel == null:
		_fail("%s missing ItemList/ItemListSecondary panel" % label)
	elif not item_panel.bg_color.is_equal_approx(item_secondary_panel.bg_color):
		_fail("%s ItemListSecondary.panel should match ItemList.panel" % label)
	elif _max_border_width(item_secondary_panel) != 0:
		_fail("%s ItemListSecondary.panel should not draw a border/outline" % label)

	var accent := theme.get_color(&"drop_position_color", &"Tree")
	var button_pressed := theme.get_stylebox(&"pressed", &"Button") as StyleBoxFlat
	for item_type in [&"ItemList", &"ItemListSecondary"]:
		for color_name in [&"font_selected_color", &"font_hovered_selected_color"]:
			var selected_font := theme.get_color(color_name, item_type)
			if not selected_font.is_equal_approx(accent):
				_fail("%s %s.%s should use accent color for selected item text" % [label, item_type, color_name])
		if theme.get_color(&"guide_color", item_type).a > 0.01:
			_fail("%s %s.guide_color should be transparent" % [label, item_type])
		if button_pressed != null:
			for slot_name in [&"selected", &"selected_focus", &"hovered_selected", &"hovered_selected_focus"]:
				var selected_style := theme.get_stylebox(slot_name, item_type) as StyleBoxFlat
				if selected_style == null:
					_fail("%s missing %s.%s" % [label, item_type, slot_name])
				elif not selected_style.bg_color.is_equal_approx(button_pressed.bg_color):
					_fail("%s %s.%s should match Button.pressed background" % [label, item_type, slot_name])
				elif _max_border_width(selected_style) != 0:
					_fail("%s %s.%s should not draw a selected border/outline" % [label, item_type, slot_name])

	for split_type in [&"SplitContainer", &"HSplitContainer", &"VSplitContainer"]:
		var split_bar := theme.get_stylebox(&"split_bar_background", split_type)
		if split_bar == null:
			_fail("%s missing %s.split_bar_background" % [label, split_type])
		elif not (split_bar is StyleBoxEmpty):
			_fail("%s %s.split_bar_background should be StyleBoxEmpty for contextual dialog spacing, got %s" % [
				label,
				split_type,
				split_bar.get_class(),
			])

	for help_type in [&"EditorHelpBitTitle", &"EditorHelpBitContent"]:
		var help_style := theme.get_stylebox(&"normal", help_type) as StyleBoxFlat
		if help_style == null:
			_fail("%s missing %s.normal" % [label, help_type])
			continue
		if help_style.bg_color.a < 0.99:
			_fail("%s %s.normal should draw a concrete panel" % [label, help_type])
		if help_style.content_margin_left < 6 or help_style.content_margin_top < 3:
			_fail("%s %s.normal padding too small: %s/%s/%s/%s" % [
				label,
				help_type,
				help_style.content_margin_left,
				help_style.content_margin_top,
				help_style.content_margin_right,
				help_style.content_margin_bottom,
			])


func _expect_equal(actual: Variant, expected: Variant, message: String) -> void:
	if actual != expected:
		_fail("%s expected=%s got=%s" % [message, expected, actual])


func _max_border_width(stylebox: StyleBoxFlat) -> int:
	return maxi(stylebox.border_width_left, maxi(stylebox.border_width_top, maxi(stylebox.border_width_right, stylebox.border_width_bottom)))


func _fail(message: String) -> void:
	_failures.append(message)
	printerr(message)


func _finish() -> void:
	if _failures.is_empty():
		print("THEME_CREATE_DIALOG_PROBE: PASS")
		quit(0)
	else:
		printerr("THEME_CREATE_DIALOG_PROBE: FAIL count=%s" % _failures.size())
		quit(1)
