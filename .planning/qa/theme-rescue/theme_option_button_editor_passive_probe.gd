extends SceneTree

const SHOWCASE_PATH := "res://showcase/showcase.tscn"
const THEME_PICKER_PATH := NodePath("RootMargin/RootStack/HeaderPanel/HeaderMargin/HeaderStack/ControlsRow/NeoCadeThemeOptionButton")


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	print("THEME_OPTION_BUTTON_EDITOR_PASSIVE_PROBE editor_hint=%s" % Engine.is_editor_hint())
	var scene_resource := load(SHOWCASE_PATH) as PackedScene
	var scene := scene_resource.instantiate() as Control
	var picker := scene.get_node(THEME_PICKER_PATH) as NeoCadeThemeOptionButton
	picker.select(5)
	root.add_child(scene)
	await process_frame

	var before_theme := scene.theme
	var before_style := _style_name(before_theme)
	var emitted := 0
	picker.theme_selected.connect(func(_theme: Theme, _index: int) -> void:
		emitted += 1
	)

	picker.refresh_theme_list()
	picker.call("_queue_selected_apply")
	await process_frame

	var after_theme := scene.theme
	var after_style := _style_name(after_theme)
	print("  selected=%d before=%s after=%s same_theme=%s emitted=%d" % [
		picker.selected,
		before_style,
		after_style,
		str(before_theme == after_theme),
		emitted,
	])

	var failed := false
	if not Engine.is_editor_hint():
		push_error("Probe must be run with --editor so Engine.is_editor_hint() is true.")
		failed = true
	if before_theme != after_theme:
		push_error("Editor picker refresh reassigned the target theme.")
		failed = true
	if emitted != 0:
		push_error("Editor picker refresh emitted theme_selected.")
		failed = true
	if after_theme != null:
		push_error("Showcase root should not serialize/assign a scene theme in editor mode.")
		failed = true
	if picker.selected != -1:
		push_error("Editor picker should not mirror a null root theme to the None entry; selected=%d." % picker.selected)
		failed = true

	scene.queue_free()
	print("THEME_OPTION_BUTTON_EDITOR_PASSIVE_PROBE: %s" % ("FAIL" if failed else "PASS"))
	quit(1 if failed else 0)


func _style_name(theme: Theme) -> String:
	var neocade_theme := theme as NeoCadeTheme
	if neocade_theme == null:
		return "<none>"
	return NeoCadeTheme.style_label(neocade_theme.style)
