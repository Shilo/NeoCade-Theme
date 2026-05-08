@tool
class_name NeoCadeThemeOptionButton extends OptionButton

signal theme_selected(theme: Theme, index: int)

const DEFAULT_THEME_RESOURCE_PATH := "res://addons/neocade_theme/neocade_theme.tres"
const NO_THEME_LABEL := "None"
const NO_THEME_PRESET := -1
const SELECTED_PROPERTY := &"selected"

@export_file("*.tres") var theme_resource_path := DEFAULT_THEME_RESOURCE_PATH:
	set(value):
		theme_resource_path = value
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

var _item_presets: PackedInt32Array = PackedInt32Array()
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
	var requested_selected := selected

	clear()
	_item_presets = PackedInt32Array()

	for preset_entry in _preset_entries():
		_add_preset_item(String(preset_entry["label"]), int(preset_entry["preset"]))

	if allow_no_theme:
		_add_preset_item(NO_THEME_LABEL, NO_THEME_PRESET)

	if item_count == 0:
		select(-1)
		return

	if requested_selected == -1:
		_refresh_should_mirror_target = false
		if _should_sync_selected_from_target() and _select_current_target_preset(target):
			return

		select(-1)
		return

	if _refresh_should_mirror_target:
		_refresh_should_mirror_target = false
		if _select_current_target_preset(target):
			return

		select(-1)
		return

	if requested_selected >= 0 and requested_selected < _item_presets.size():
		select(requested_selected)
		_apply_theme(requested_selected)
		return

	if not _select_current_target_preset(target):
		select(-1)


func _on_item_selected(index: int) -> void:
	_apply_theme(index)


func _apply_theme(index: int) -> void:
	var target := _theme_target()
	if target == null or index < 0 or index >= _item_presets.size():
		return

	var selected_preset := _item_presets[index]
	if selected_preset == NO_THEME_PRESET:
		if target.theme == null:
			return

		target.theme = null
		theme_selected.emit(null, index)
		return

	if _target_has_preset(target, selected_preset):
		return

	var next_theme := _theme_for_preset(selected_preset)
	if next_theme == null:
		return

	target.theme = next_theme
	theme_selected.emit(next_theme, index)


func _preset_entries() -> Array[Dictionary]:
	var entries: Array[Dictionary] = []
	for preset_value in NeoCadeTheme.selectable_presets():
		entries.append({
			"label": NeoCadeTheme.preset_label(preset_value),
			"preset": preset_value,
		})

	entries.sort_custom(_compare_preset_entries)
	return entries


func _compare_preset_entries(a: Dictionary, b: Dictionary) -> bool:
	var label_order := String(a["label"]).nocasecmp_to(String(b["label"]))
	if label_order != 0:
		return label_order < 0

	return int(a["preset"]) < int(b["preset"])


func _add_preset_item(label: String, preset_value: int) -> void:
	add_item(label)
	_item_presets.append(preset_value)
	set_item_metadata(item_count - 1, preset_value)


func _theme_for_preset(preset_value: int) -> NeoCadeTheme:
	var loaded_theme := load(theme_resource_path) as NeoCadeTheme
	if loaded_theme == null:
		return null

	var next_theme := loaded_theme.duplicate(true) as NeoCadeTheme
	next_theme.preset = preset_value
	return next_theme


func _select_current_target_preset(target: Control) -> bool:
	var matching_index := _index_for_target_theme(target)
	if matching_index == -1:
		return false

	select(matching_index)
	return true


func _index_for_target_theme(target: Control) -> int:
	if target == null:
		return -1

	if target.theme == null:
		return _index_for_preset(NO_THEME_PRESET)

	var neocade_theme := target.theme as NeoCadeTheme
	if neocade_theme == null:
		return -1

	return _index_for_preset(neocade_theme.preset)


func _index_for_preset(preset_value: int) -> int:
	for index in range(_item_presets.size()):
		if _item_presets[index] == preset_value:
			return index

	return -1


func _target_has_preset(target: Control, preset_value: int) -> bool:
	var neocade_theme := target.theme as NeoCadeTheme
	return neocade_theme != null and neocade_theme.preset == preset_value


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
	if selected == -1:
		if _should_sync_selected_from_target():
			var target := _theme_target()
			if not _select_current_target_preset(target):
				select(-1)
		return

	_apply_theme(selected)


func _should_sync_selected_from_target() -> bool:
	return not Engine.is_editor_hint()
