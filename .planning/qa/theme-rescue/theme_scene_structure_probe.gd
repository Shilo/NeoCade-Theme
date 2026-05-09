extends SceneTree

const SHOWCASE_PATH := "res://showcase/showcase.tscn"

var _failures: PackedStringArray = []


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var scene := load(SHOWCASE_PATH).instantiate() as Control
	if scene == null:
		_fail("showcase did not instantiate as Control")
		_finish()
		return
	root.add_child(scene)
	await process_frame

	var window := scene.get_node_or_null("Window") as Window
	var accept_dialog := scene.get_node_or_null("AcceptDialog") as AcceptDialog
	var confirmation_dialog := scene.get_node_or_null("ConfirmationDialog") as ConfirmationDialog
	var file_dialog := scene.get_node_or_null("FileDialog") as FileDialog
	var popup_panel := scene.get_node_or_null("PopupPanel") as PopupPanel
	var popup_menu := scene.get_node_or_null("PopupMenu") as PopupMenu
	var showcase_tabs := scene.get_node_or_null("RootMargin/RootStack/ShowcaseTabs") as TabContainer
	var content_panel := scene.get_node_or_null("Window/WindowContentPanel") as PanelContainer
	var margin := scene.get_node_or_null("Window/WindowContentPanel/WindowMargin") as MarginContainer
	var direct_margin := scene.get_node_or_null("Window/WindowMargin")

	_expect(window != null, "showcase Window exists")
	_expect(accept_dialog != null, "showcase AcceptDialog exists")
	_expect(confirmation_dialog != null, "showcase ConfirmationDialog exists")
	_expect(file_dialog != null, "showcase FileDialog exists")
	_expect(popup_panel != null, "showcase PopupPanel exists")
	_expect(popup_menu != null, "showcase PopupMenu exists")
	_expect(showcase_tabs != null, "showcase TabContainer exists")
	_expect(content_panel != null, "WindowMargin is wrapped by WindowContentPanel")
	_expect(margin != null, "WindowMargin remains inside WindowContentPanel")
	_expect(direct_margin == null, "WindowMargin should not be a direct Window child")
	_expect(FileAccess.file_exists("res://showcase/showcase.gd"), "showcase script exists")
	var showcase_script := FileAccess.get_file_as_string("res://showcase/showcase.gd")
	for handler_name in [
		"_on_accept_dialog_button_pressed",
		"_on_confirmation_dialog_button_pressed",
		"_on_file_dialog_button_pressed",
		"_on_popup_panel_button_pressed",
		"_on_popup_menu_button_pressed",
	]:
		_expect(showcase_script.contains(handler_name), "showcase script wires %s" % handler_name)
	_expect_popup_button_opens(scene, "RootMargin/RootStack/ShowcaseTabs/Dialogs & Popups/Margin/Grid/AcceptDialogButton", accept_dialog, "AcceptDialog")
	_expect_popup_button_opens(scene, "RootMargin/RootStack/ShowcaseTabs/Dialogs & Popups/Margin/Grid/ConfirmationDialogButton", confirmation_dialog, "ConfirmationDialog")
	_expect_popup_button_opens(scene, "RootMargin/RootStack/ShowcaseTabs/Dialogs & Popups/Margin/Grid/FileDialogButton", file_dialog, "FileDialog")
	_expect_popup_button_opens(scene, "RootMargin/RootStack/ShowcaseTabs/Dialogs & Popups/Margin/Grid/PopupPanelButton", popup_panel, "PopupPanel")
	_expect_popup_button_opens(scene, "RootMargin/RootStack/ShowcaseTabs/Dialogs & Popups/Margin/Grid/PopupMenuButton", popup_menu, "PopupMenu")
	_expect_showcase_tab_scrollbars(showcase_tabs)

	if content_panel != null:
		_expect(content_panel.theme_type_variation == &"WindowContentPanel", "WindowContentPanel uses the dedicated theme variation")
		_expect(content_panel.anchor_left == 0.0 and content_panel.anchor_top == 0.0 and content_panel.anchor_right == 1.0 and content_panel.anchor_bottom == 1.0, "WindowContentPanel fills the Window viewport")
		_expect(content_panel.offset_left == 0.0 and content_panel.offset_top == 0.0 and content_panel.offset_right == 0.0 and content_panel.offset_bottom == 0.0, "WindowContentPanel has no offsets")

	if margin != null:
		_expect(margin.get_parent() == content_panel, "WindowMargin parent is WindowContentPanel")
		_expect(margin.get_theme_constant("margin_left") == 16, "WindowMargin keeps existing left spacing")
		_expect(margin.get_theme_constant("margin_top") == 16, "WindowMargin keeps existing top spacing")

	scene.queue_free()
	_finish()


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_fail(message)


func _expect_popup_button_opens(scene: Node, button_path: NodePath, popup: Window, label: String) -> void:
	var button := scene.get_node_or_null(button_path) as Button
	if button == null:
		_fail("%s button missing" % label)
		return
	if popup == null:
		_fail("%s popup node missing" % label)
		return
	popup.hide()
	button.pressed.emit()
	_expect(popup.visible, "%s showcase button opens its popup/dialog" % label)
	popup.hide()


func _expect_showcase_tab_scrollbars(showcase_tabs: TabContainer) -> void:
	if showcase_tabs == null:
		return
	for child in showcase_tabs.get_children():
		var scroll := child as ScrollContainer
		if scroll == null:
			continue
		_expect(scroll.horizontal_scroll_mode != ScrollContainer.SCROLL_MODE_DISABLED, "%s tab page keeps horizontal scrolling available" % scroll.name)
		_expect(scroll.vertical_scroll_mode != ScrollContainer.SCROLL_MODE_DISABLED, "%s tab page keeps vertical scrolling available" % scroll.name)


func _fail(message: String) -> void:
	_failures.append(message)
	push_error("SCENE_STRUCTURE_FAIL: %s" % message)


func _finish() -> void:
	if _failures.is_empty():
		print("SCENE_STRUCTURE_PASS Window content PanelContainer wrapper verified")
		quit(0)
		return

	print("SCENE_STRUCTURE_FAIL count=%d" % _failures.size())
	for failure in _failures:
		print("- %s" % failure)
	quit(1)
