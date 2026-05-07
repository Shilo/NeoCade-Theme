extends SceneTree

const TYPES := [
	"Window",
	"PopupPanel",
	"PopupMenu",
	"AcceptDialog",
	"ConfirmationDialog",
	"FileDialog",
	"TooltipPanel",
	"TooltipLabel",
	"MenuBar",
	"ColorPicker",
	"ColorPickerButton",
	"GraphEdit",
	"GraphNode",
	"GraphFrame",
]

func _initialize() -> void:
	var theme := ThemeDB.get_default_theme()
	var version := Engine.get_version_info()
	print("GODOT_VERSION: %s.%s.%s.%s.%s" % [
		version.major,
		version.minor,
		version.patch,
		version.status,
		version.hash,
	])
	for theme_type in TYPES:
		print("")
		print("## %s" % theme_type)
		print("stylebox: %s" % _join_sorted(theme.get_stylebox_list(theme_type)))
		print("color: %s" % _join_sorted(theme.get_color_list(theme_type)))
		print("constant: %s" % _join_sorted(theme.get_constant_list(theme_type)))
		print("font: %s" % _join_sorted(theme.get_font_list(theme_type)))
		print("font_size: %s" % _join_sorted(theme.get_font_size_list(theme_type)))
		print("icon: %s" % _join_sorted(theme.get_icon_list(theme_type)))
	quit()

func _join_sorted(items: PackedStringArray) -> String:
	var values: Array[String] = []
	for item in items:
		values.append(String(item))
	values.sort()
	return ", ".join(values)
