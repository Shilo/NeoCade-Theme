extends SceneTree

const THEME_PATH := "res://addons/neocade_theme/neocade_theme.tres"
const SHOWCASE_PATH := "res://showcase/showcase.tscn"
const SCREENSHOT_DIR := "res://.planning/qa/theme-rescue/screenshots"
const VIEWPORT_SIZE := Vector2i(1920, 1080)


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
	]

	for capture_case in cases:
		await _capture_case(capture_case)

	print("THEME_RESCUE_CAPTURE: PASS screenshots=%s" % cases.size())
	quit(0)


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

	_log_layout(scene, String(capture_case["name"]))

	var image := root.get_texture().get_image()
	var output_path := "%s/%s.png" % [SCREENSHOT_DIR, String(capture_case["name"])]
	var error := image.save_png(ProjectSettings.globalize_path(output_path))
	if error != OK:
		printerr("THEME_RESCUE_CAPTURE: failed saving %s error=%s" % [output_path, error])
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

	var embedded_window := scene.get_node_or_null("Window") as Window
	if embedded_window == null:
		printerr("THEME_RESCUE_CAPTURE: %s missing Window" % label)
		return

	var window_rect := Rect2(Vector2(embedded_window.position), Vector2(embedded_window.size))
	var window_fits := viewport_rect.encloses(window_rect)
	print("THEME_RESCUE_CAPTURE: %s Window rect=%s fits=%s" % [label, window_rect, window_fits])
