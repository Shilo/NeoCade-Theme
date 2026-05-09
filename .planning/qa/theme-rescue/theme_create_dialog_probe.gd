extends SceneTree

const THEME_PATH := "res://addons/neocade_theme/neocade_theme.tres"

var _failures: PackedStringArray = []


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
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

	var tree_panel := theme.get_stylebox(&"panel", &"Tree") as StyleBoxFlat
	var tree_secondary_panel := theme.get_stylebox(&"panel", &"TreeSecondary") as StyleBoxFlat
	if tree_panel == null or tree_secondary_panel == null:
		_fail("%s missing Tree/TreeSecondary panel" % label)
	elif not tree_panel.bg_color.is_equal_approx(tree_secondary_panel.bg_color):
		_fail("%s TreeSecondary.panel should match Tree.panel" % label)

	var item_panel := theme.get_stylebox(&"panel", &"ItemList") as StyleBoxFlat
	var item_secondary_panel := theme.get_stylebox(&"panel", &"ItemListSecondary") as StyleBoxFlat
	if item_panel == null or item_secondary_panel == null:
		_fail("%s missing ItemList/ItemListSecondary panel" % label)
	elif not item_panel.bg_color.is_equal_approx(item_secondary_panel.bg_color):
		_fail("%s ItemListSecondary.panel should match ItemList.panel" % label)

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
