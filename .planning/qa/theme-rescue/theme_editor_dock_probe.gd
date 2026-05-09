extends SceneTree

const THEME_PATH := "res://addons/neocade_theme/neocade_theme.tres"


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	if not Engine.is_editor_hint():
		print("THEME_EDITOR_DOCK_PROBE: SKIP Engine.is_editor_hint() is false; run with --editor")
		quit(0)
		return

	var canonical := load(THEME_PATH) as NeoCadeTheme
	if canonical == null:
		printerr("THEME_EDITOR_DOCK_PROBE: missing NeoCadeTheme")
		quit(1)
		return

	var theme := canonical.duplicate(true) as NeoCadeTheme
	theme.style = NeoCadeTheme.Style.PULSE
	theme.raised = false
	theme.platform = NeoCadeTheme.Platform.DESKTOP

	if not ClassDB.class_exists(&"EditorDock"):
		printerr("THEME_EDITOR_DOCK_PROBE: EditorDock class is not registered")
		quit(1)
		return
	if not ClassDB.is_parent_class(&"EditorDock", &"MarginContainer"):
		printerr("THEME_EDITOR_DOCK_PROBE: EditorDock is not a MarginContainer")
		quit(1)
		return
	if theme.get_type_variation_base(&"NoBorderHorizontal") != &"MarginContainer":
		printerr("THEME_EDITOR_DOCK_PROBE: NoBorderHorizontal should inherit MarginContainer")
		quit(1)
		return
	if theme.get_type_variation_base(&"NoBorderHorizontalBottom") != &"NoBorderHorizontal":
		printerr("THEME_EDITOR_DOCK_PROBE: NoBorderHorizontalBottom should inherit NoBorderHorizontal")
		quit(1)
		return
	if theme.get_constant(&"margin_top", &"NoBorderHorizontalBottom") != 4:
		printerr("THEME_EDITOR_DOCK_PROBE: expected NoBorderHorizontalBottom.margin_top=4")
		quit(1)
		return
	if not ClassDB.can_instantiate(&"EditorDock"):
		_expect_theme_margins(theme)
		print("THEME_EDITOR_DOCK_PROBE: PASS EditorDock registered as MarginContainer; headless ClassDB cannot instantiate it")
		quit(0)
		return

	var dock_object: Object = ClassDB.instantiate(&"EditorDock")
	var dock := dock_object as MarginContainer
	if dock == null:
		printerr("THEME_EDITOR_DOCK_PROBE: EditorDock did not instantiate as MarginContainer")
		quit(1)
		return

	dock.theme = theme
	root.add_child(dock)
	await process_frame

	var margins := Vector4i(
		dock.get_theme_constant(&"margin_left"),
		dock.get_theme_constant(&"margin_top"),
		dock.get_theme_constant(&"margin_right"),
		dock.get_theme_constant(&"margin_bottom")
	)
	dock.queue_free()

	if margins != Vector4i(6, 6, 6, 6):
		printerr("THEME_EDITOR_DOCK_PROBE: expected EditorDock margins 6/6/6/6 got %s" % margins)
		quit(1)
		return

	print("THEME_EDITOR_DOCK_PROBE: PASS margins=%s" % margins)
	quit(0)


func _expect_theme_margins(theme: Theme) -> void:
	var margins := Vector4i(
		theme.get_constant(&"margin_left", &"EditorDock"),
		theme.get_constant(&"margin_top", &"EditorDock"),
		theme.get_constant(&"margin_right", &"EditorDock"),
		theme.get_constant(&"margin_bottom", &"EditorDock")
	)
	if margins != Vector4i(6, 6, 6, 6):
		printerr("THEME_EDITOR_DOCK_PROBE: expected theme EditorDock margins 6/6/6/6 got %s" % margins)
		quit(1)
