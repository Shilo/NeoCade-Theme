extends SceneTree

const THEME_PATH := "res://addons/neocade_theme/neocade_theme.tres"

const EDITOR_ONLY_TYPES := [
	&"Editor",
	&"EditorIcons",
	&"EditorStyles",
	&"EditorProperty",
	&"EditorInspectorButton",
	&"TreeSecondary",
	&"TreeTable",
	&"ItemListSecondary",
	&"BottomPanel",
	&"RunBarButton",
	&"TopBarOptionButton",
	&"PopupProgressBar",
]

var _failures: PackedStringArray = []


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var theme := load(THEME_PATH) as NeoCadeTheme
	if theme == null:
		_fail("canonical theme did not load as NeoCadeTheme")
		_finish()
		return

	if Engine.is_editor_hint():
		_fail("runtime editor gate probe must run outside editor hint")

	for theme_type in EDITOR_ONLY_TYPES:
		if theme.get_type_list().has(theme_type):
			_fail("runtime theme unexpectedly authored editor-only type %s" % theme_type)
		if theme.get_type_variation_base(theme_type) != &"":
			_fail("runtime theme unexpectedly registered editor-only variation %s -> %s" % [
				theme_type,
				theme.get_type_variation_base(theme_type),
			])

	if theme.has_color(&"gl_compatibility_color", &"Editor"):
		_fail("runtime theme should not author Editor.gl_compatibility_color")
	if theme.has_stylebox(&"FocusViewport", &"EditorStyles"):
		_fail("runtime theme should not author EditorStyles.FocusViewport")
	if theme.has_stylebox(&"child_bg", &"EditorProperty"):
		_fail("runtime theme should not author EditorProperty.child_bg")

	if not theme.has_stylebox(&"normal", &"Button"):
		_fail("runtime theme lost Button.normal while gating editor-only slots")
	if not theme.has_stylebox(&"normal", &"OptionButton"):
		_fail("runtime theme lost OptionButton.normal while gating editor-only slots")
	if not theme.has_stylebox(&"panel", &"Tree"):
		_fail("runtime theme lost Tree.panel while gating editor-only slots")

	_finish()


func _fail(message: String) -> void:
	_failures.append(message)
	push_error(message)


func _finish() -> void:
	if _failures.is_empty():
		print("PASS runtime editor-only theme slots are gated")
		quit(0)
	else:
		print("FAIL runtime editor-only theme slots are gated: %d issue(s)" % _failures.size())
		for failure in _failures:
			print(" - " + failure)
		quit(1)
