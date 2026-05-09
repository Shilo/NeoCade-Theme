extends SceneTree

const THEME_PATH := "res://addons/neocade_theme/neocade_theme.tres"
const OUTPUT_PATH := "res://.planning/qa/theme-rescue/theme-default-vs-neocade.log"

const DATA_TYPES := ["stylebox", "color", "constant", "font", "font_size", "icon"]

var _lines: PackedStringArray = []
var _summary := {
	"SAME": 0,
	"FALLS_BACK": 0,
	"INTENTIONAL_AUTHORED": 0,
	"UNINTENTIONAL_EXTRA": 0,
	"UNINTENTIONAL_STYLE": 0,
	"NEOCADE_ONLY": 0,
	"DEFAULT_ONLY": 0,
}


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var default_theme := ThemeDB.get_default_theme()
	var canonical := load(THEME_PATH) as NeoCadeTheme
	if default_theme == null:
		_die("ThemeDB.get_default_theme() returned null")
		return
	if canonical == null:
		_die("Could not load NeoCadeTheme from %s" % THEME_PATH)
		return

	var cases: Array[Dictionary] = [
		{"name": "pulse-desktop-flat", "theme": _theme_variant(canonical, NeoCadeTheme.Style.PULSE, false, NeoCadeTheme.Platform.DESKTOP)},
		{"name": "pulse-desktop-raised", "theme": _theme_variant(canonical, NeoCadeTheme.Style.PULSE, true, NeoCadeTheme.Platform.DESKTOP)},
		{"name": "pulse-mobile-flat", "theme": _theme_variant(canonical, NeoCadeTheme.Style.PULSE, false, NeoCadeTheme.Platform.MOBILE)},
	]

	_line("NeoCade default-vs-runtime comparison")
	_line("Default source: ThemeDB.get_default_theme()")
	_line("NeoCade source: %s" % THEME_PATH)
	_line("")

	for compare_case in cases:
		_compare_case(default_theme, compare_case["theme"], String(compare_case["name"]))

	_line("")
	_line("Summary:")
	for key in _summary.keys():
		_line("- %s=%s" % [key, _summary[key]])

	var absolute_path := ProjectSettings.globalize_path(OUTPUT_PATH)
	DirAccess.make_dir_recursive_absolute(absolute_path.get_base_dir())
	var file := FileAccess.open(absolute_path, FileAccess.WRITE)
	if file == null:
		_die("Could not write %s error=%s" % [absolute_path, FileAccess.get_open_error()])
		return
	file.store_string("\n".join(_lines) + "\n")
	file.close()

	print("THEME_DEFAULT_COMPARE: wrote %s" % OUTPUT_PATH)
	for key in _summary.keys():
		print("THEME_DEFAULT_COMPARE: %s=%s" % [key, _summary[key]])
	quit(0)


func _theme_variant(source: NeoCadeTheme, style_value: int, raised: bool, platform: int) -> NeoCadeTheme:
	var theme := source.duplicate(true) as NeoCadeTheme
	theme.style = style_value
	theme.raised = raised
	theme.platform = platform
	return theme


func _compare_case(default_theme: Theme, neocade_theme: NeoCadeTheme, case_name: String) -> void:
	_line("## %s" % case_name)

	var slot_map := _collect_slots(default_theme, neocade_theme)
	var sorted_types := slot_map.keys()
	sorted_types.sort()

	for theme_type in sorted_types:
		for data_type in DATA_TYPES:
			var slots: Array = slot_map[theme_type].get(data_type, [])
			slots.sort()
			for slot in slots:
				_compare_slot(default_theme, neocade_theme, StringName(theme_type), data_type, StringName(slot), case_name)

	_line("")


func _collect_slots(default_theme: Theme, neocade_theme: Theme) -> Dictionary:
	var slots := {}
	_add_slots_from_runtime_theme(slots, default_theme)
	_add_slots_from_runtime_theme(slots, neocade_theme)
	_add_slots_from_canonical_tables(slots)
	return slots


func _add_slots_from_runtime_theme(slots: Dictionary, theme: Theme) -> void:
	for theme_type in theme.get_type_list():
		_add_slot_list(slots, String(theme_type), "stylebox", theme.get_stylebox_list(theme_type))
		_add_slot_list(slots, String(theme_type), "color", theme.get_color_list(theme_type))
		_add_slot_list(slots, String(theme_type), "constant", theme.get_constant_list(theme_type))
		_add_slot_list(slots, String(theme_type), "font", theme.get_font_list(theme_type))
		_add_slot_list(slots, String(theme_type), "font_size", theme.get_font_size_list(theme_type))
		_add_slot_list(slots, String(theme_type), "icon", theme.get_icon_list(theme_type))


func _add_slots_from_canonical_tables(slots: Dictionary) -> void:
	for theme_type in NeoCadeTheme.CANONICAL_SLOT_NAMES.keys():
		var type_spec: Dictionary = NeoCadeTheme.CANONICAL_SLOT_NAMES[theme_type]
		for data_type in DATA_TYPES:
			if not type_spec.has(data_type):
				continue
			var raw_slots: Variant = type_spec[data_type]
			if raw_slots is Array:
				_add_slot_list(slots, String(theme_type), data_type, raw_slots)
			elif raw_slots is Dictionary:
				_add_slot_list(slots, String(theme_type), data_type, raw_slots.keys())


func _add_slot_list(slots: Dictionary, theme_type: String, data_type: String, names: Array) -> void:
	if not slots.has(theme_type):
		slots[theme_type] = {}
	if not slots[theme_type].has(data_type):
		slots[theme_type][data_type] = []

	for raw_name in names:
		var slot_name := String(raw_name)
		if not slots[theme_type][data_type].has(slot_name):
			slots[theme_type][data_type].append(slot_name)


func _compare_slot(default_theme: Theme, neocade_theme: NeoCadeTheme, theme_type: StringName, data_type: String, slot: StringName, case_name: String) -> void:
	var default_has := _has_theme_item(default_theme, data_type, slot, theme_type)
	var neo_has := _has_theme_item(neocade_theme, data_type, slot, theme_type)
	var default_value: Variant = _theme_item_value(default_theme, data_type, slot, theme_type) if default_has else null
	var neo_value: Variant = _theme_item_value(neocade_theme, data_type, slot, theme_type) if neo_has else null
	var same := default_has == neo_has and _value_signature(default_value) == _value_signature(neo_value)
	var classification := _classify(theme_type, data_type, slot, default_has, neo_has, same, default_value, neo_value, neocade_theme.raised)
	_summary[classification] = int(_summary.get(classification, 0)) + 1

	if same and classification == "SAME":
		return

	_line("%s %s.%s.%s default=%s neocade=%s" % [
		classification,
		theme_type,
		data_type,
		slot,
		_value_signature(default_value) if default_has else "<missing>",
		_value_signature(neo_value) if neo_has else "<missing>",
	])


func _classify(theme_type: StringName, data_type: String, slot: StringName, default_has: bool, neo_has: bool, same: bool, _default_value: Variant, neo_value: Variant, is_raised: bool) -> String:
	if _is_label_stylebox(theme_type, data_type, slot) and neo_has:
		return "UNINTENTIONAL_STYLE"

	if same:
		return "SAME"

	if data_type == "stylebox" and neo_value is StyleBoxFlat:
		var flat := neo_value as StyleBoxFlat
		if flat.shadow_size > 0 or flat.shadow_offset != Vector2.ZERO:
			return "UNINTENTIONAL_STYLE"
		if is_raised and flat.border_width_right > flat.border_width_left and flat.border_width_bottom > flat.border_width_top:
			return "UNINTENTIONAL_STYLE"

	if not neo_has and default_has:
		return "FALLS_BACK" if _is_authored(theme_type, data_type, slot) else "DEFAULT_ONLY"

	if neo_has and _is_runtime_typography(data_type):
		return "INTENTIONAL_AUTHORED"

	if neo_has and not default_has:
		return "INTENTIONAL_AUTHORED" if _is_authored(theme_type, data_type, slot) else "UNINTENTIONAL_EXTRA"

	if neo_has and default_has:
		return "INTENTIONAL_AUTHORED" if _is_authored(theme_type, data_type, slot) else "UNINTENTIONAL_EXTRA"

	return "SAME"


func _is_runtime_typography(data_type: String) -> bool:
	return data_type == "font" or data_type == "font_size"


func _is_label_stylebox(theme_type: StringName, data_type: String, slot: StringName) -> bool:
	return data_type == "stylebox" and slot == &"normal" and (theme_type == &"Label" or _label_variation_names().has(String(theme_type)))


func _label_variation_names() -> PackedStringArray:
	return PackedStringArray(["HeaderLarge", "HeaderMedium", "HeaderSmall", "Caption", "CodeLabel", "Kicker"])


func _is_authored(theme_type: StringName, data_type: String, slot: StringName) -> bool:
	if not NeoCadeTheme.BINDING_TABLE.has(theme_type):
		return false

	var type_table: Dictionary = NeoCadeTheme.BINDING_TABLE[theme_type]
	if not type_table.has(data_type):
		return false

	var slots: Variant = type_table[data_type]
	if slots is Dictionary:
		return (slots as Dictionary).has(slot)
	if slots is Array:
		return (slots as Array).has(slot)
	return false


func _has_theme_item(theme: Theme, data_type: String, slot: StringName, theme_type: StringName) -> bool:
	match data_type:
		"stylebox":
			return theme.has_stylebox(slot, theme_type)
		"color":
			return theme.has_color(slot, theme_type)
		"constant":
			return theme.has_constant(slot, theme_type)
		"font":
			return theme.has_font(slot, theme_type)
		"font_size":
			return theme.has_font_size(slot, theme_type)
		"icon":
			return theme.has_icon(slot, theme_type)
	return false


func _theme_item_value(theme: Theme, data_type: String, slot: StringName, theme_type: StringName) -> Variant:
	match data_type:
		"stylebox":
			return theme.get_stylebox(slot, theme_type)
		"color":
			return theme.get_color(slot, theme_type)
		"constant":
			return theme.get_constant(slot, theme_type)
		"font":
			return theme.get_font(slot, theme_type)
		"font_size":
			return theme.get_font_size(slot, theme_type)
		"icon":
			return theme.get_icon(slot, theme_type)
	return null


func _value_signature(value: Variant) -> String:
	if value == null:
		return "<null>"
	if value is StyleBoxFlat:
		var sb := value as StyleBoxFlat
		return "StyleBoxFlat(bg=%s border=%s/%s/%s/%s border_color=%s radius=%s/%s/%s/%s margin=%s/%s/%s/%s expand=%s/%s/%s/%s shadow=%s offset=%s)" % [
			_color_hex(sb.bg_color),
			sb.border_width_left, sb.border_width_top, sb.border_width_right, sb.border_width_bottom,
			_color_hex(sb.border_color),
			sb.corner_radius_top_left, sb.corner_radius_top_right, sb.corner_radius_bottom_right, sb.corner_radius_bottom_left,
			sb.content_margin_left, sb.content_margin_top, sb.content_margin_right, sb.content_margin_bottom,
			sb.expand_margin_left, sb.expand_margin_top, sb.expand_margin_right, sb.expand_margin_bottom,
			sb.shadow_size, sb.shadow_offset,
		]
	if value is StyleBox:
		return "%s" % value.get_class()
	if value is Color:
		return _color_hex(value)
	if value is Texture2D:
		var texture := value as Texture2D
		return "Texture2D(size=%s path=%s)" % [texture.get_size(), texture.resource_path]
	if value is Font:
		var font := value as Font
		return "Font(path=%s)" % font.resource_path
	return str(value)


func _color_hex(color: Color) -> String:
	return "#%02x%02x%02x%02x" % [
		int(round(color.r * 255.0)),
		int(round(color.g * 255.0)),
		int(round(color.b * 255.0)),
		int(round(color.a * 255.0)),
	]


func _line(text: String) -> void:
	_lines.append(text)


func _die(message: String) -> void:
	printerr("THEME_DEFAULT_COMPARE: " + message)
	quit(1)
