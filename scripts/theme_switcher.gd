extends OptionButton

const THEME_PATHS := [
	"res://addons/neocade_theme/pulse_neocade_theme.tres",
	"res://addons/neocade_theme/slate_neocade_theme.tres",
	"res://addons/neocade_theme/bubble_neocade_theme.tres",
	"res://addons/neocade_theme/daybreak_neocade_theme.tres",
	"res://addons/neocade_theme/burst_neocade_theme.tres",
	"",
]

@export var theme_target_path: NodePath


func _ready() -> void:
	if not item_selected.is_connected(_on_item_selected):
		item_selected.connect(_on_item_selected)

	if selected < 0 and item_count > 0:
		select(0)

	_apply_theme(selected)


func _on_item_selected(index: int) -> void:
	_apply_theme(index)


func _apply_theme(index: int) -> void:
	var target := _theme_target()
	if target == null or index < 0 or index >= THEME_PATHS.size():
		return

	var theme_path: String = THEME_PATHS[index]
	if theme_path.is_empty():
		target.theme = null
		return

	var next_theme := load(theme_path) as Theme
	if next_theme != null:
		target.theme = next_theme


func _theme_target() -> Control:
	if theme_target_path != NodePath():
		var explicit_target := get_node_or_null(theme_target_path)
		if explicit_target is Control:
			return explicit_target

	var current_scene := get_tree().current_scene
	if current_scene is Control:
		return current_scene

	return null
