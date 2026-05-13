extends SceneTree

const SHOWCASE_PATH := "res://showcase/showcase.tscn"
const THEME_PICKER_PATH := NodePath("RootMargin/RootStack/HeaderPanel/HeaderMargin/HeaderStack/ControlsRow/NeoCadeThemeOptionButton")


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var scene_resource := load(SHOWCASE_PATH) as PackedScene
	var scene := scene_resource.instantiate() as Control
	var picker := scene.get_node(THEME_PICKER_PATH) as NeoCadeThemeOptionButton
	picker.select(5)
	root.add_child(scene)
	await process_frame

	var theme := scene.theme as NeoCadeTheme
	var failed := false

	if theme == null:
		push_error("Showcase runtime root did not assign NeoCadeTheme.")
		failed = true
	elif theme.style != NeoCadeTheme.Style.PULSE:
		push_error("Showcase runtime root assigned unexpected style: %s" % NeoCadeTheme.style_label(theme.style))
		failed = true

	if picker.selected != 3:
		push_error("Showcase runtime picker did not sync to Pulse index 3; selected=%d." % picker.selected)
		failed = true

	print("THEME_SHOWCASE_RUNTIME_THEME_PROBE root_style=%s picker_selected=%d" % [
		NeoCadeTheme.style_label(theme.style) if theme != null else "<none>",
		picker.selected,
	])
	print("THEME_SHOWCASE_RUNTIME_THEME_PROBE: %s" % ("FAIL" if failed else "PASS"))
	scene.queue_free()
	quit(1 if failed else 0)
