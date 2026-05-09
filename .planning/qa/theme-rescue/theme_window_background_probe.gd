extends SceneTree

const THEME_PATH := "res://addons/neocade_theme/neocade_theme.tres"
const SHOWCASE_PATH := "res://showcase/showcase.tscn"

var _failures: PackedStringArray = []


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var renderer_clear_before := RenderingServer.get_default_clear_color()
	var project_clear_before: Color = ProjectSettings.get_setting("rendering/environment/defaults/default_clear_color")

	var showcase := load(SHOWCASE_PATH).instantiate() as Control
	if showcase == null:
		_fail("showcase did not instantiate as Control")
		_finish()
		return

	root.add_child(showcase)
	await process_frame

	var scoreboard := showcase.get_node_or_null("Window") as Window
	if scoreboard == null:
		_fail("showcase Window missing")
		_finish()
		return

	_expect(NeoCadeTheme.node_inherits_neocade_theme(scoreboard), "showcase Window should inherit NeoCade theme")
	_expect(scoreboard.transparent, "showcase Window should be transparent while inheriting NeoCade")
	_expect_window_background(scoreboard, "showcase")

	showcase.theme = null
	NeoCadeTheme.sync_inherited_window_background(scoreboard)
	await process_frame
	_expect(not NeoCadeTheme.node_inherits_neocade_theme(scoreboard), "showcase Window should not inherit NeoCade after null theme")
	_expect(not scoreboard.transparent, "showcase Window transparent flag should restore after null theme")
	_expect(scoreboard.get_node_or_null(NeoCadeTheme.WINDOW_BACKGROUND_NODE_NAME) == null, "showcase Window background should be removed after null theme")

	var plain_parent := Control.new()
	var plain_window := Window.new()
	root.add_child(plain_parent)
	plain_parent.add_child(plain_window)
	_expect(not NeoCadeTheme.sync_inherited_window_background(plain_window), "plain Window should not be managed without NeoCade inheritance")
	_expect(not plain_window.transparent, "plain Window transparent flag should stay untouched")
	_expect(plain_window.get_node_or_null(NeoCadeTheme.WINDOW_BACKGROUND_NODE_NAME) == null, "plain Window should not receive background")

	var neocade_parent := Control.new()
	neocade_parent.theme = load(THEME_PATH) as NeoCadeTheme
	var themed_window := Window.new()
	root.add_child(neocade_parent)
	neocade_parent.add_child(themed_window)
	_expect(NeoCadeTheme.sync_inherited_window_background(themed_window), "themed Window should be managed")
	_expect(themed_window.transparent, "themed Window transparent flag should be enabled")
	_expect_window_background(themed_window, "themed")

	var blocked_parent := Control.new()
	blocked_parent.theme = load(THEME_PATH) as NeoCadeTheme
	var blocked_window := Window.new()
	blocked_window.theme = Theme.new()
	root.add_child(blocked_parent)
	blocked_parent.add_child(blocked_window)
	_expect(not NeoCadeTheme.sync_inherited_window_background(blocked_window), "local non-NeoCade Window theme should block inheritance")
	_expect(not blocked_window.transparent, "blocked Window transparent flag should stay untouched")
	_expect(blocked_window.get_node_or_null(NeoCadeTheme.WINDOW_BACKGROUND_NODE_NAME) == null, "blocked Window should not receive background")

	_expect(RenderingServer.get_default_clear_color().is_equal_approx(renderer_clear_before), "renderer default clear color should not change")
	var project_clear_after: Color = ProjectSettings.get_setting("rendering/environment/defaults/default_clear_color")
	_expect(project_clear_after.is_equal_approx(project_clear_before), "project default clear color should not change")

	_finish()


func _expect_window_background(window: Window, label: String) -> void:
	var background := window.get_node_or_null(NeoCadeTheme.WINDOW_BACKGROUND_NODE_NAME) as Panel
	if background == null:
		_fail("%s Window missing managed background Panel" % label)
		return
	_expect(background.theme_type_variation == &"WindowContentPanel", "%s Window background should use WindowContentPanel variation" % label)
	_expect(background.mouse_filter == Control.MOUSE_FILTER_IGNORE, "%s Window background should ignore mouse input" % label)
	_expect(background.anchor_left == 0.0 and background.anchor_top == 0.0 and background.anchor_right == 1.0 and background.anchor_bottom == 1.0, "%s Window background should be full rect anchored" % label)
	_expect(NeoCadeTheme.node_inherits_neocade_theme(background), "%s Window background should inherit NeoCade theme" % label)

	var theme := _nearest_neocade_theme(window)
	if theme == null:
		_fail("%s Window could not resolve nearest NeoCade theme" % label)
		return

	var background_panel := background.get_theme_stylebox(&"panel") as StyleBoxFlat
	var button_panel := theme.get_stylebox(&"normal", &"Button") as StyleBoxFlat
	if background_panel == null or button_panel == null:
		_fail("%s Window background/Button stylebox missing" % label)
		return

	_expect(background_panel.bg_color.is_equal_approx(button_panel.bg_color), "%s Window background should match Button.normal face color" % label)
	_expect(background_panel.border_width_left == 0 and background_panel.border_width_top == 0 and background_panel.border_width_right == 0 and background_panel.border_width_bottom == 0, "%s Window background should not add its own border" % label)


func _nearest_neocade_theme(node: Node) -> NeoCadeTheme:
	var current := node
	while current != null:
		if current is Window:
			var window_theme := (current as Window).theme as NeoCadeTheme
			if window_theme != null:
				return window_theme
		if current is Control:
			var control_theme := (current as Control).theme as NeoCadeTheme
			if control_theme != null:
				return control_theme
		current = current.get_parent()
	return ThemeDB.get_project_theme() as NeoCadeTheme


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_fail(message)


func _fail(message: String) -> void:
	_failures.append(message)
	push_error("WINDOW_BACKGROUND_FAIL: %s" % message)


func _finish() -> void:
	if _failures.is_empty():
		print("WINDOW_BACKGROUND_PASS inherited-only Window background behavior verified")
		quit(0)
		return

	print("WINDOW_BACKGROUND_FAIL count=%d" % _failures.size())
	for failure in _failures:
		print("- %s" % failure)
	quit(1)
