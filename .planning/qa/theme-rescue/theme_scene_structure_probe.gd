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

	var window := scene.get_node_or_null("Window") as Window
	var content_panel := scene.get_node_or_null("Window/WindowContentPanel") as PanelContainer
	var margin := scene.get_node_or_null("Window/WindowContentPanel/WindowMargin") as MarginContainer
	var direct_margin := scene.get_node_or_null("Window/WindowMargin")

	_expect(window != null, "showcase Window exists")
	_expect(content_panel != null, "WindowMargin is wrapped by WindowContentPanel")
	_expect(margin != null, "WindowMargin remains inside WindowContentPanel")
	_expect(direct_margin == null, "WindowMargin should not be a direct Window child")

	if content_panel != null:
		_expect(content_panel.theme_type_variation == &"WindowContentPanel", "WindowContentPanel uses the dedicated theme variation")
		_expect(content_panel.anchor_left == 0.0 and content_panel.anchor_top == 0.0 and content_panel.anchor_right == 1.0 and content_panel.anchor_bottom == 1.0, "WindowContentPanel fills the Window viewport")
		_expect(content_panel.offset_left == 0.0 and content_panel.offset_top == 0.0 and content_panel.offset_right == 0.0 and content_panel.offset_bottom == 0.0, "WindowContentPanel has no offsets")

	if margin != null:
		_expect(margin.get_parent() == content_panel, "WindowMargin parent is WindowContentPanel")
		_expect(margin.get_theme_constant("margin_left") == 16, "WindowMargin keeps existing left spacing")
		_expect(margin.get_theme_constant("margin_top") == 16, "WindowMargin keeps existing top spacing")

	scene.free()
	_finish()


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_fail(message)


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
