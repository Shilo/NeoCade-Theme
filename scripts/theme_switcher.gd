@tool
class_name NeoCadeThemeSwitcher
extends OptionButton

const DEFAULT_THEME_DIRECTORY := "res://addons/neocade_theme"
const DEFAULT_LABEL := "Default"
const THEME_FILE_EXTENSION := ".tres"
const THEME_NAME_SUFFIX := "_neocade_theme"

@export_group("Theme Discovery")
@export_dir var theme_directory := DEFAULT_THEME_DIRECTORY:
	set(value):
		theme_directory = value
		_queue_refresh()

@export var allow_default_theme := true:
	set(value):
		allow_default_theme = value
		_queue_refresh()

@export_group("Target")
@export_node_path("Control") var theme_target_path: NodePath:
	set(value):
		theme_target_path = value
		_queue_refresh()

var _theme_paths: PackedStringArray = PackedStringArray()
var _is_ready := false


func _ready() -> void:
	_is_ready = true
	if not item_selected.is_connected(_on_item_selected):
		item_selected.connect(_on_item_selected)

	refresh_theme_list()


func refresh_theme_list() -> void:
	var current_target_path := _current_target_theme_path()
	var previous_selected_path := _theme_path_for_index(selected)

	clear()
	_theme_paths = PackedStringArray()

	if allow_default_theme:
		_add_theme_item(DEFAULT_LABEL, "")

	for entry in _find_neocade_themes():
		_add_theme_item(entry["label"], entry["path"])

	if item_count == 0:
		return

	var next_index := _index_for_theme_path(current_target_path)
	if next_index == -1:
		next_index = _index_for_theme_path(previous_selected_path)
	if next_index == -1:
		next_index = 0

	select(next_index)
	_apply_theme(next_index)


func _on_item_selected(index: int) -> void:
	_apply_theme(index)


func _apply_theme(index: int) -> void:
	var target := _theme_target()
	if target == null or index < 0 or index >= _theme_paths.size():
		return

	var theme_path := _theme_paths[index]
	if theme_path.is_empty():
		target.theme = null
		return

	var next_theme := load(theme_path) as Theme
	if next_theme != null:
		target.theme = next_theme


func _find_neocade_themes() -> Array[Dictionary]:
	var discovered: Array[Dictionary] = []
	var directory := DirAccess.open(theme_directory)
	if directory == null:
		return discovered

	directory.list_dir_begin()
	var file_name := directory.get_next()
	while not file_name.is_empty():
		if not directory.current_is_dir() and file_name.ends_with(THEME_FILE_EXTENSION):
			var theme_path := theme_directory.path_join(file_name)
			var resource := load(theme_path)
			if resource is NeoCadeTheme:
				discovered.append({
					"label": _theme_label_from_file_name(file_name),
					"path": theme_path,
				})
		file_name = directory.get_next()
	directory.list_dir_end()

	discovered.sort_custom(_compare_theme_entries)
	return discovered


func _compare_theme_entries(a: Dictionary, b: Dictionary) -> bool:
	var label_a := String(a["label"])
	var label_b := String(b["label"])
	var label_order := label_a.nocasecmp_to(label_b)
	if label_order != 0:
		return label_order < 0

	return String(a["path"]).nocasecmp_to(String(b["path"])) < 0


func _theme_label_from_file_name(file_name: String) -> String:
	var label := file_name.get_basename()
	if label.ends_with(THEME_NAME_SUFFIX):
		label = label.substr(0, label.length() - THEME_NAME_SUFFIX.length())

	return label.replace("_", " ").capitalize()


func _add_theme_item(label: String, theme_path: String) -> void:
	add_item(label)
	_theme_paths.append(theme_path)
	set_item_metadata(item_count - 1, theme_path)


func _current_target_theme_path() -> String:
	var target := _theme_target()
	if target == null or target.theme == null:
		return ""

	return target.theme.resource_path


func _theme_path_for_index(index: int) -> String:
	if index < 0 or index >= _theme_paths.size():
		return ""

	return _theme_paths[index]


func _index_for_theme_path(theme_path: String) -> int:
	for index in range(_theme_paths.size()):
		if _theme_paths[index] == theme_path:
			return index

	return -1


func _theme_target() -> Control:
	if theme_target_path != NodePath():
		var explicit_target := get_node_or_null(theme_target_path)
		if explicit_target is Control:
			return explicit_target

	var edited_root := get_tree().get("edited_scene_root") as Node
	if edited_root is Control:
		return edited_root

	var current_scene := get_tree().current_scene
	if current_scene is Control:
		return current_scene

	return null


func _queue_refresh() -> void:
	if not _is_ready or not is_inside_tree():
		return

	call_deferred("refresh_theme_list")
