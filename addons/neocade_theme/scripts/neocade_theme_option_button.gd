@tool
class_name NeoCadeThemeOptionButton extends OptionButton

signal theme_selected(theme: Theme, index: int)

const DEFAULT_THEME_DIRECTORY := "res://addons/neocade_theme"
const NO_THEME_LABEL := "None"
const SELECTED_PROPERTY := &"selected"
const THEME_FILE_EXTENSION := ".tres"
const THEME_NAME_SUFFIX := "_neocade_theme"

@export_dir var theme_directory := DEFAULT_THEME_DIRECTORY:
	set(value):
		theme_directory = value
		if _is_ready:
			_refresh_should_mirror_target = true
		_queue_refresh()

@export_node_path("Control") var theme_target_path: NodePath:
	set(value):
		theme_target_path = value
		if _is_ready:
			_refresh_should_mirror_target = true
		_queue_refresh()

@export var allow_no_theme := true:
	set(value):
		if allow_no_theme == value:
			return

		allow_no_theme = value
		_queue_refresh()

var _theme_paths: PackedStringArray = PackedStringArray()
var _is_ready := false
var _refresh_should_mirror_target := false
var _selected_apply_queued := false


func _set(property: StringName, _value: Variant) -> bool:
	if property == SELECTED_PROPERTY:
		_queue_selected_apply()

	return false


func _ready() -> void:
	_is_ready = true
	if not item_selected.is_connected(_on_item_selected):
		item_selected.connect(_on_item_selected)

	refresh_theme_list()


func refresh_theme_list() -> void:
	var target := _theme_target()
	var current_target_path := _current_target_theme_path(target)
	var requested_selected := selected

	clear()
	_theme_paths = PackedStringArray()

	for entry in _find_neocade_themes():
		_add_theme_item(String(entry["label"]), String(entry["path"]))

	if allow_no_theme:
		_add_theme_item(NO_THEME_LABEL, "")

	if item_count == 0:
		select(-1)
		return

	if _refresh_should_mirror_target:
		_refresh_should_mirror_target = false
		if _select_current_target_theme(target, current_target_path):
			return

		select(-1)
		return

	if requested_selected >= 0 and requested_selected < _theme_paths.size():
		select(requested_selected)
		_apply_theme(requested_selected)
		return

	if not _select_current_target_theme(target, current_target_path):
		select(-1)


func _on_item_selected(index: int) -> void:
	_apply_theme(index)


func _apply_theme(index: int) -> void:
	var target := _theme_target()
	if target == null or index < 0 or index >= _theme_paths.size():
		return

	var theme_path := _theme_paths[index]
	if _target_has_theme_path(target, theme_path):
		return

	if theme_path.is_empty():
		target.theme = null
		theme_selected.emit(null, index)
		return

	var next_theme := load(theme_path) as Theme
	if next_theme != null:
		target.theme = next_theme
		theme_selected.emit(next_theme, index)


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


func _current_target_theme_path(target: Control) -> String:
	if target == null or target.theme == null:
		return ""

	return target.theme.resource_path


func _index_for_theme_path(theme_path: String) -> int:
	for index in range(_theme_paths.size()):
		if _theme_paths[index] == theme_path:
			return index

	return -1


func _select_current_target_theme(target: Control, current_target_path: String) -> bool:
	if not current_target_path.is_empty():
		var matching_index := _index_for_theme_path(current_target_path)
		if matching_index != -1:
			select(matching_index)
			return true

	if target != null and target.theme == null:
		var no_theme_index := _index_for_theme_path("")
		if no_theme_index != -1:
			select(no_theme_index)
			return true

	return false


func _target_has_theme_path(target: Control, theme_path: String) -> bool:
	if theme_path.is_empty():
		return target.theme == null

	if target.theme == null:
		return false

	return target.theme.resource_path == theme_path


func _theme_target() -> Control:
	if theme_target_path != NodePath():
		var explicit_target := get_node_or_null(theme_target_path)
		if explicit_target is Control:
			return explicit_target
		return null

	var tree := get_tree()
	if tree == null:
		return null

	var edited_root := tree.get("edited_scene_root") as Node
	if edited_root is Control:
		return edited_root

	var current_scene := tree.current_scene
	if current_scene is Control:
		return current_scene

	if owner is Control:
		return owner

	return null


func _queue_refresh() -> void:
	if not _is_ready or not is_inside_tree():
		return

	call_deferred("refresh_theme_list")


func _queue_selected_apply() -> void:
	if not _is_ready or not is_inside_tree() or _selected_apply_queued:
		return

	_selected_apply_queued = true
	call_deferred("_apply_selected_change")


func _apply_selected_change() -> void:
	_selected_apply_queued = false
	_apply_theme(selected)
