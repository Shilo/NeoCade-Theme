extends SceneTree

const THEME_PATH := "res://addons/neocade_theme/neocade_theme.tres"
const SHOWCASE_PATH := "res://showcase/showcase.tscn"
const SCREENSHOT_DIR := "res://.planning/qa/theme-rescue/screenshots"
const VIEWPORT_SIZE := Vector2i(1920, 1080)

var _failures: PackedStringArray = []


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var output_dir := ProjectSettings.globalize_path(SCREENSHOT_DIR)
	DirAccess.make_dir_recursive_absolute(output_dir)

	DisplayServer.window_set_size(VIEWPORT_SIZE)
	root.size = VIEWPORT_SIZE
	root.gui_embed_subwindows = true

	var canonical := load(THEME_PATH) as NeoCadeTheme
	var cases: Array[Dictionary] = [
		{"name": "00-default-null", "theme": null},
		{"name": "01-pulse-desktop", "theme": _theme_variant(canonical, NeoCadeTheme.Style.PULSE, false, NeoCadeTheme.Platform.DESKTOP)},
		{"name": "02-pulse-raised", "theme": _theme_variant(canonical, NeoCadeTheme.Style.PULSE, true, NeoCadeTheme.Platform.DESKTOP)},
		{"name": "03-pulse-mobile", "theme": _theme_variant(canonical, NeoCadeTheme.Style.PULSE, false, NeoCadeTheme.Platform.MOBILE)},
		{"name": "04-bubble-desktop", "theme": _theme_variant(canonical, NeoCadeTheme.Style.BUBBLE, false, NeoCadeTheme.Platform.DESKTOP)},
		{"name": "05-burst-desktop", "theme": _theme_variant(canonical, NeoCadeTheme.Style.BURST, false, NeoCadeTheme.Platform.DESKTOP)},
		{"name": "06-daybreak-desktop", "theme": _theme_variant(canonical, NeoCadeTheme.Style.DAYBREAK, false, NeoCadeTheme.Platform.DESKTOP)},
		{"name": "07-slate-desktop", "theme": _theme_variant(canonical, NeoCadeTheme.Style.SLATE, false, NeoCadeTheme.Platform.DESKTOP)},
		{"name": "08-pulse-mobile-raised", "theme": _theme_variant(canonical, NeoCadeTheme.Style.PULSE, true, NeoCadeTheme.Platform.MOBILE)},
		{"name": "09-default-popups", "theme": null, "popups": true},
		{"name": "10-pulse-popups", "theme": _theme_variant(canonical, NeoCadeTheme.Style.PULSE, false, NeoCadeTheme.Platform.DESKTOP), "popups": true},
	]

	for capture_case in cases:
		await _capture_case(capture_case)

	if _failures.is_empty():
		print("THEME_RESCUE_CAPTURE: PASS screenshots=%s" % cases.size())
		quit(0)
		return

	printerr("THEME_RESCUE_CAPTURE: FAIL")
	for failure in _failures:
		printerr("- " + failure)
	quit(1)


func _theme_variant(source: NeoCadeTheme, style_value: int, raised: bool, platform: int) -> NeoCadeTheme:
	var theme := source.duplicate(true) as NeoCadeTheme
	theme.style = style_value
	theme.raised = raised
	theme.platform = platform
	return theme


func _capture_case(capture_case: Dictionary) -> void:
	var scene := (load(SHOWCASE_PATH) as PackedScene).instantiate() as Control
	scene.theme = capture_case["theme"]
	root.add_child(scene)

	await process_frame
	await process_frame
	await process_frame
	_show_scoreboard_window(scene)
	await process_frame
	await process_frame
	if bool(capture_case.get("popups", false)):
		await _open_popup_surfaces(scene)

	_log_layout(scene, String(capture_case["name"]))

	var viewport_texture := root.get_texture()
	var image := viewport_texture.get_image() if viewport_texture != null else null
	if image == null:
		_fail("%s renderer returned no viewport image; rerun without --headless/dummy renderer for screenshot capture" % String(capture_case["name"]))
		root.remove_child(scene)
		scene.queue_free()
		await process_frame
		return

	var output_path := "%s/%s.png" % [SCREENSHOT_DIR, String(capture_case["name"])]
	var error := image.save_png(ProjectSettings.globalize_path(output_path))
	if error != OK:
		_fail("failed saving %s error=%s" % [output_path, error])
	else:
		print("THEME_RESCUE_CAPTURE: saved %s" % output_path)

	root.remove_child(scene)
	scene.queue_free()
	await process_frame


func _log_layout(scene: Control, label: String) -> void:
	var viewport_rect := Rect2(Vector2.ZERO, VIEWPORT_SIZE)
	for node_path in [
		"RootMargin/RootStack/HeaderPanel",
		"RootMargin/RootStack/ShowcaseTabs",
	]:
		var control := scene.get_node_or_null(NodePath(node_path)) as Control
		if control == null:
			printerr("THEME_RESCUE_CAPTURE: %s missing %s" % [label, node_path])
			continue
		var rect := control.get_global_rect()
		var fits := viewport_rect.encloses(rect)
		print("THEME_RESCUE_CAPTURE: %s %s rect=%s fits=%s" % [label, node_path, rect, fits])
		if not fits:
			_fail("%s %s does not fit viewport: %s" % [label, node_path, rect])

	var embedded_window := scene.get_node_or_null("Window") as Window
	if embedded_window == null:
		printerr("THEME_RESCUE_CAPTURE: %s missing Window" % label)
		return

	var window_rect := Rect2(Vector2(embedded_window.position), Vector2(embedded_window.size))
	var window_fits := viewport_rect.encloses(window_rect)
	print("THEME_RESCUE_CAPTURE: %s Window rect=%s fits=%s" % [label, window_rect, window_fits])
	if not window_fits:
		_fail("%s Window does not fit viewport: %s" % [label, window_rect])


func _show_scoreboard_window(scene: Control) -> void:
	var embedded_window := scene.get_node_or_null("Window") as Window
	if embedded_window == null:
		return
	embedded_window.popup(Rect2i(embedded_window.position, embedded_window.size))


func _open_popup_surfaces(scene: Control) -> void:
	var style_picker := scene.get_node_or_null("RootMargin/RootStack/HeaderPanel/HeaderMargin/HeaderStack/ControlsRow/NeoCadeThemeOptionButton") as OptionButton
	if style_picker != null:
		style_picker.show_popup()
		await process_frame

	var tooltip_panel := PanelContainer.new()
	tooltip_panel.name = "SyntheticTooltipPanel"
	tooltip_panel.theme_type_variation = &"TooltipPanel"
	tooltip_panel.position = Vector2(520, 122)
	tooltip_panel.custom_minimum_size = Vector2(300, 28)

	var tooltip_label := Label.new()
	tooltip_label.theme_type_variation = &"TooltipLabel"
	tooltip_label.text = "TooltipPanel / TooltipLabel"
	tooltip_panel.add_child(tooltip_label)
	scene.add_child(tooltip_panel)
	await process_frame


func _fail(message: String) -> void:
	_failures.append(message)
