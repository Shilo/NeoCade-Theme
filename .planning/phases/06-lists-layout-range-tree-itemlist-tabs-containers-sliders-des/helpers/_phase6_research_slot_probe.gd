extends SceneTree

const TYPES := [
	"Tree",
	"ItemList",
	"TabBar",
	"TabContainer",
	"FoldableContainer",
	"ProgressBar",
	"HSlider",
	"VSlider",
	"Slider",
	"HScrollBar",
	"VScrollBar",
	"ScrollBar",
	"ScrollContainer",
	"SplitContainer",
	"HSplitContainer",
	"VSplitContainer",
	"MarginContainer",
	"HBoxContainer",
	"VBoxContainer",
	"FlowContainer",
	"GridContainer",
	"CenterContainer",
	"Separator",
	"HSeparator",
	"VSeparator",
]

const CANDIDATES := {
	"Tree": {
		"stylebox": ["button_hover", "button_pressed", "cursor", "cursor_unfocused", "custom_button", "custom_button_hover", "custom_button_pressed", "focus", "hover", "hovered", "hovered_dimmed", "hovered_selected", "hovered_selected_focus", "panel", "selected", "selected_focus", "title_button_hover", "title_button_normal", "title_button_pressed"],
		"color": ["children_hl_line_color", "custom_button_font_highlight", "drop_position_color", "font_color", "font_disabled_color", "font_hovered_color", "font_hovered_dimmed_color", "font_hovered_selected_color", "font_outline_color", "font_selected_color", "guide_color", "parent_hl_line_color", "relationship_line_color", "scroll_hint_color", "title_button_color"],
		"constant": ["button_margin", "check_h_separation", "children_hl_line_width", "dragging_unfold_wait_msec", "draw_guides", "draw_relationship_lines", "h_separation", "icon_h_separation", "icon_max_width", "inner_item_margin_bottom", "inner_item_margin_left", "inner_item_margin_right", "inner_item_margin_top", "item_margin", "outline_size", "parent_hl_line_margin", "parent_hl_line_width", "relationship_line_width", "scroll_border", "scroll_speed", "scrollbar_h_separation", "scrollbar_margin_bottom", "scrollbar_margin_left", "scrollbar_margin_right", "scrollbar_margin_top", "scrollbar_v_separation", "v_separation"],
		"font": ["font", "title_button_font"],
		"font_size": ["font_size", "title_button_font_size"],
		"icon": ["arrow", "arrow_collapsed", "arrow_collapsed_mirrored", "checked", "checked_disabled", "indeterminate", "indeterminate_disabled", "scroll_hint", "select_arrow", "unchecked", "unchecked_disabled", "updown"],
	},
	"ItemList": {
		"stylebox": ["cursor", "cursor_unfocused", "focus", "hovered", "hovered_selected", "hovered_selected_focus", "panel", "selected", "selected_focus"],
		"color": ["font_color", "font_hovered_color", "font_hovered_selected_color", "font_outline_color", "font_selected_color", "guide_color", "scroll_hint_color"],
		"constant": ["h_separation", "icon_margin", "line_separation", "outline_size", "v_separation"],
		"font": ["font"],
		"font_size": ["font_size"],
		"icon": ["scroll_hint"],
	},
	"TabBar": {
		"stylebox": ["button_highlight", "button_pressed", "tab_disabled", "tab_focus", "tab_hovered", "tab_selected", "tab_unselected"],
		"color": ["drop_mark_color", "font_disabled_color", "font_hovered_color", "font_outline_color", "font_selected_color", "font_unselected_color", "icon_disabled_color", "icon_hovered_color", "icon_selected_color", "icon_unselected_color"],
		"constant": ["h_separation", "hover_switch_wait_msec", "icon_max_width", "outline_size", "tab_separation"],
		"font": ["font"],
		"font_size": ["font_size"],
		"icon": ["close", "decrement", "decrement_highlight", "drop_mark", "increment", "increment_highlight"],
	},
	"TabContainer": {
		"stylebox": ["panel", "tab_disabled", "tab_focus", "tab_hovered", "tab_selected", "tab_unselected", "tabbar_background"],
		"color": ["drop_mark_color", "font_disabled_color", "font_hovered_color", "font_outline_color", "font_selected_color", "font_unselected_color", "icon_disabled_color", "icon_hovered_color", "icon_selected_color", "icon_unselected_color"],
		"constant": ["icon_max_width", "icon_separation", "outline_size", "side_margin", "tab_separation"],
		"font": ["font"],
		"font_size": ["font_size"],
		"icon": ["decrement", "decrement_highlight", "drop_mark", "increment", "increment_highlight", "menu", "menu_highlight"],
	},
	"FoldableContainer": {
		"stylebox": ["focus", "panel", "title_collapsed_hover_panel", "title_collapsed_panel", "title_hover_panel", "title_panel"],
		"color": ["collapsed_font_color", "font_color", "font_outline_color", "hover_font_color"],
		"constant": ["h_separation", "outline_size"],
		"font": ["font"],
		"font_size": ["font_size"],
		"icon": ["expanded_arrow", "expanded_arrow_mirrored", "folded_arrow", "folded_arrow_mirrored"],
	},
	"ProgressBar": {
		"stylebox": ["background", "fill"],
		"color": ["font_color", "font_outline_color"],
		"constant": ["outline_size"],
		"font": ["font"],
		"font_size": ["font_size"],
	},
	"HSlider": {
		"stylebox": ["grabber_area", "grabber_area_highlight", "slider"],
		"constant": ["center_grabber", "grabber_offset", "tick_offset"],
		"icon": ["grabber", "grabber_disabled", "grabber_highlight", "tick"],
	},
	"VSlider": {
		"stylebox": ["grabber_area", "grabber_area_highlight", "slider"],
		"constant": ["center_grabber", "grabber_offset", "tick_offset"],
		"icon": ["grabber", "grabber_disabled", "grabber_highlight", "tick"],
	},
	"HScrollBar": {
		"stylebox": ["grabber", "grabber_highlight", "grabber_pressed", "scroll", "scroll_focus"],
		"icon": ["decrement", "decrement_highlight", "decrement_pressed", "increment", "increment_highlight", "increment_pressed"],
	},
	"VScrollBar": {
		"stylebox": ["grabber", "grabber_highlight", "grabber_pressed", "scroll", "scroll_focus"],
		"icon": ["decrement", "decrement_highlight", "decrement_pressed", "increment", "increment_highlight", "increment_pressed"],
	},
	"ScrollContainer": {
		"stylebox": ["focus", "panel"],
		"color": ["scroll_hint_horizontal_color", "scroll_hint_vertical_color"],
		"constant": ["scrollbar_h_separation", "scrollbar_v_separation"],
		"icon": ["scroll_hint_horizontal", "scroll_hint_vertical"],
	},
	"HSplitContainer": {
		"stylebox": ["split_bar_background"],
		"constant": ["autohide", "minimum_grab_thickness", "separation"],
		"icon": ["grabber", "touch_dragger"],
	},
	"VSplitContainer": {
		"stylebox": ["split_bar_background"],
		"constant": ["autohide", "minimum_grab_thickness", "separation"],
		"icon": ["grabber", "touch_dragger"],
	},
	"MarginContainer": {
		"constant": ["margin_bottom", "margin_left", "margin_right", "margin_top"],
	},
	"HBoxContainer": {
		"constant": ["separation"],
	},
	"VBoxContainer": {
		"constant": ["separation"],
	},
	"FlowContainer": {
		"constant": ["h_separation", "v_separation"],
	},
	"GridContainer": {
		"constant": ["h_separation", "v_separation"],
	},
	"HSeparator": {
		"stylebox": ["separator"],
		"constant": ["separation"],
	},
	"VSeparator": {
		"stylebox": ["separator"],
		"constant": ["separation"],
	},
}

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
		if CANDIDATES.has(theme_type):
			_print_candidate_check(theme, theme_type, CANDIDATES[theme_type])
			_print_control_candidate_check(theme_type, CANDIDATES[theme_type])
	quit()

func _join_sorted(items: PackedStringArray) -> String:
	var values: Array[String] = []
	for item in items:
		values.append(String(item))
	values.sort()
	return ", ".join(values)

func _print_candidate_check(theme: Theme, theme_type: String, data: Dictionary) -> void:
	for kind in ["stylebox", "color", "constant", "font", "font_size", "icon"]:
		if not data.has(kind):
			continue
		var missing: Array[String] = []
		for slot in data[kind]:
			if not _has_item(theme, kind, String(slot), theme_type):
				missing.append(String(slot))
		missing.sort()
		print("candidate_missing_%s: %s" % [kind, ", ".join(missing)])

func _has_item(theme: Theme, kind: String, slot: String, theme_type: String) -> bool:
	match kind:
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
		_:
			return false

func _print_control_candidate_check(theme_type: String, data: Dictionary) -> void:
	var obj: Object = ClassDB.instantiate(theme_type)
	var control := obj as Control
	if control == null:
		print("control_candidate_check: unavailable")
		return
	for kind in ["stylebox", "color", "constant", "font", "font_size", "icon"]:
		if not data.has(kind):
			continue
		var missing: Array[String] = []
		for slot in data[kind]:
			if not _control_has_item(control, kind, String(slot)):
				missing.append(String(slot))
		missing.sort()
		print("control_missing_%s: %s" % [kind, ", ".join(missing)])
	control.free()

func _control_has_item(control: Control, kind: String, slot: String) -> bool:
	match kind:
		"stylebox":
			return control.has_theme_stylebox(slot)
		"color":
			return control.has_theme_color(slot)
		"constant":
			return control.has_theme_constant(slot)
		"font":
			return control.has_theme_font(slot)
		"font_size":
			return control.has_theme_font_size(slot)
		"icon":
			return control.has_theme_icon(slot)
		_:
			return false
