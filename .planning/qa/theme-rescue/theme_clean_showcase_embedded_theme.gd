extends SceneTree

const SCENE_PATH := "res://showcase/showcase.tscn"
const THEME_PATH := "res://addons/neocade_theme/neocade_theme.tres"


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var packed := load(SCENE_PATH) as PackedScene
	if packed == null:
		_die("Could not load %s" % SCENE_PATH)
		return
	var scene := packed.instantiate() as Control
	if scene == null:
		_die("%s root is not Control" % SCENE_PATH)
		return
	var theme := load(THEME_PATH) as Theme
	if theme == null:
		_die("Could not load %s" % THEME_PATH)
		return

	scene.theme = theme
	var next_packed := PackedScene.new()
	var pack_error := next_packed.pack(scene)
	if pack_error != OK:
		scene.free()
		_die("PackedScene.pack failed: %s" % pack_error)
		return
	var save_error := ResourceSaver.save(next_packed, SCENE_PATH)
	scene.free()
	if save_error != OK:
		_die("ResourceSaver.save failed: %s" % save_error)
		return
	print("SHOWCASE_THEME_CLEANUP: saved %s with external theme %s" % [SCENE_PATH, THEME_PATH])
	quit(0)


func _die(message: String) -> void:
	push_error("SHOWCASE_THEME_CLEANUP_FAIL: %s" % message)
	quit(1)
