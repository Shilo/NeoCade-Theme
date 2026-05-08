@tool
extends EditorPlugin

const NeoCadeThemeSaver := preload("res://addons/neocade_theme/scripts/neocade_theme_resource_format_saver.gd")

var _theme_saver: ResourceFormatSaver


func _enter_tree() -> void:
	if _theme_saver != null:
		return

	_theme_saver = NeoCadeThemeSaver.new()
	ResourceSaver.add_resource_format_saver(_theme_saver, true)


func _exit_tree() -> void:
	if _theme_saver == null:
		return

	ResourceSaver.remove_resource_format_saver(_theme_saver)
	_theme_saver = null
