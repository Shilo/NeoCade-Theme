extends SceneTree

## Phase 7 verifier foundation. Run via:
##
##   <godot-cli> --headless --path . --script \
##     .planning/phases/07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr/helpers/_phase7_verify_headless.gd \
##     -- --stage slot-freeze
##
## Stages:
##   slot-freeze     Strict foundation gate for Plan 07-01.
##   popups-menus    Window, popup, tooltip, MenuBar, and PopupMenu gate from Plan 07-02.
##   filedialog      FileDialog gate from Plan 07-03.
##   colorpicker     ColorPicker and ColorPickerButton gate from Plan 07-04.
##   graph           GraphEdit, GraphNode, and GraphFrame gate from Plan 07-05.
##   full            Fails while any future group is pending.

const PRODUCTION_GD := "res://addons/neocade_theme/neocade_theme.gd"
const PULSE_PATH := "res://addons/neocade_theme/pulse_neocade_theme.tres"
const SLOT_FREEZE_PATH := "res://.planning/phases/07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr/helpers/phase7-slot-freeze.txt"

const EXPECTED_EXPORTS := [
	"base_color", "accent_color", "raised", "platform",
	"corner_radius", "spacing", "raised_strength", "focus_thickness", "outline_width",
]

const EXPECTED_SLOT_FREEZE := {
	"Window": {
		"stylebox": ["embedded_border", "embedded_unfocused_border"],
		"color": ["title_color", "title_outline_modulate"],
		"constant": ["close_h_offset", "close_v_offset", "resize_margin", "title_height", "title_outline_size"],
		"font": ["title_font"],
		"font_size": ["title_font_size"],
		"icon": ["close", "close_pressed"],
	},
	"PopupPanel": {
		"stylebox": ["panel"],
		"color": [],
		"constant": [],
		"font": [],
		"font_size": [],
		"icon": [],
	},
	"PopupMenu": {
		"stylebox": ["hover", "labeled_separator_left", "labeled_separator_right", "panel", "separator"],
		"color": ["font_accelerator_color", "font_color", "font_disabled_color", "font_hover_color",
			"font_outline_color", "font_separator_color", "font_separator_outline_color"],
		"constant": ["gutter_compact", "h_separation", "icon_max_width", "indent", "item_end_padding",
			"item_start_padding", "outline_size", "separator_outline_size", "v_separation"],
		"font": ["font", "font_separator"],
		"font_size": ["font_separator_size", "font_size"],
		"icon": ["checked", "checked_disabled", "radio_checked", "radio_checked_disabled",
			"radio_unchecked", "radio_unchecked_disabled", "submenu", "submenu_mirrored",
			"unchecked", "unchecked_disabled"],
	},
	"AcceptDialog": {
		"stylebox": ["panel"],
		"color": [],
		"constant": ["buttons_separation"],
		"font": [],
		"font_size": [],
		"icon": [],
	},
	"ConfirmationDialog": {
		"stylebox": [],
		"color": [],
		"constant": [],
		"font": [],
		"font_size": [],
		"icon": [],
	},
	"FileDialog": {
		"stylebox": [],
		"color": ["file_disabled_color", "file_icon_color", "folder_icon_color"],
		"constant": ["thumbnail_size"],
		"font": [],
		"font_size": [],
		"icon": ["back_folder", "clear", "create_folder", "favorite", "favorite_down",
			"favorite_up", "file", "file_thumbnail", "folder", "folder_thumbnail",
			"forward_folder", "list_mode", "load", "parent_folder", "reload", "save",
			"sort", "thumbnail_mode", "toggle_filename_filter", "toggle_hidden"],
	},
	"TooltipPanel": {
		"stylebox": ["panel"],
		"color": [],
		"constant": [],
		"font": [],
		"font_size": [],
		"icon": [],
	},
	"TooltipLabel": {
		"stylebox": [],
		"color": ["font_color", "font_outline_color", "font_shadow_color"],
		"constant": ["outline_size", "shadow_offset_x", "shadow_offset_y"],
		"font": ["font"],
		"font_size": ["font_size"],
		"icon": [],
	},
	"MenuBar": {
		"stylebox": ["disabled", "hover", "normal", "pressed"],
		"color": ["font_color", "font_disabled_color", "font_focus_color", "font_hover_color",
			"font_hover_pressed_color", "font_outline_color", "font_pressed_color"],
		"constant": ["h_separation", "outline_size"],
		"font": ["font"],
		"font_size": ["font_size"],
		"icon": [],
	},
	"ColorPicker": {
		"stylebox": ["picker_focus_circle", "picker_focus_rectangle", "sample_focus"],
		"color": ["focused_not_editing_cursor_color"],
		"constant": ["center_slider_grabbers", "h_width", "label_width", "margin", "sv_height", "sv_width"],
		"font": [],
		"font_size": [],
		"icon": ["add_preset", "bar_arrow", "color_hue", "color_script", "expanded_arrow",
			"folded_arrow", "menu_option", "overbright_indicator", "picker_cursor",
			"picker_cursor_bg", "sample_bg", "sample_revert", "screen_picker",
			"shape_circle", "shape_rect", "shape_rect_wheel"],
	},
	"ColorPickerButton": {
		"stylebox": ["disabled", "focus", "hover", "normal", "pressed"],
		"color": ["font_color", "font_disabled_color", "font_focus_color", "font_hover_color",
			"font_outline_color", "font_pressed_color"],
		"constant": ["h_separation", "outline_size"],
		"font": ["font"],
		"font_size": ["font_size"],
		"icon": ["bg"],
	},
	"GraphEdit": {
		"stylebox": ["menu_panel", "panel", "panel_focus"],
		"color": ["activity", "connection_hover_tint_color", "connection_rim_color",
			"connection_valid_target_tint_color", "grid_major", "grid_minor",
			"selection_fill", "selection_stroke"],
		"constant": ["connection_hover_thickness", "port_hotzone_inner_extent", "port_hotzone_outer_extent"],
		"font": [],
		"font_size": [],
		"icon": ["grid_toggle", "layout", "minimap_toggle", "snapping_toggle",
			"zoom_in", "zoom_out", "zoom_reset"],
	},
	"GraphNode": {
		"stylebox": ["panel", "panel_focus", "panel_selected", "slot", "slot_selected", "titlebar", "titlebar_selected"],
		"color": ["resizer_color"],
		"constant": ["port_h_offset", "separation"],
		"font": [],
		"font_size": [],
		"icon": ["port", "resizer"],
	},
	"GraphFrame": {
		"stylebox": ["panel", "panel_selected", "titlebar", "titlebar_selected"],
		"color": ["resizer_color"],
		"constant": [],
		"font": [],
		"font_size": [],
		"icon": ["resizer"],
	},
}

const EXPECTED_PHASE7_ICON_RECIPES := {
	"Window": {
		"close": "close",
		"close_pressed": "close",
	},
	"PopupMenu": {
		"checked": "checkbox_checked",
		"checked_disabled": "checkbox_checked",
		"unchecked": "checkbox_unchecked",
		"unchecked_disabled": "checkbox_unchecked",
		"radio_checked": "radio_checked",
		"radio_checked_disabled": "radio_checked",
		"radio_unchecked": "radio_unchecked",
		"radio_unchecked_disabled": "radio_unchecked",
		"submenu": "popup_submenu",
		"submenu_mirrored": "popup_submenu_mirrored",
	},
	"FileDialog": {
		"back_folder": "filedialog_back_folder",
		"clear": "filedialog_clear",
		"create_folder": "filedialog_create_folder",
		"favorite": "filedialog_favorite",
		"favorite_down": "filedialog_favorite_down",
		"favorite_up": "filedialog_favorite_up",
		"file": "filedialog_file",
		"file_thumbnail": "filedialog_file_thumbnail",
		"folder": "filedialog_folder",
		"folder_thumbnail": "filedialog_folder_thumbnail",
		"forward_folder": "filedialog_forward_folder",
		"list_mode": "filedialog_list_mode",
		"load": "filedialog_load",
		"parent_folder": "filedialog_parent_folder",
		"reload": "filedialog_reload",
		"save": "filedialog_save",
		"sort": "filedialog_sort",
		"thumbnail_mode": "filedialog_thumbnail_mode",
		"toggle_filename_filter": "filedialog_toggle_filename_filter",
		"toggle_hidden": "filedialog_toggle_hidden",
	},
	"ColorPicker": {
		"add_preset": "colorpicker_add_preset",
		"bar_arrow": "colorpicker_bar_arrow",
		"color_hue": "colorpicker_color_hue",
		"color_script": "colorpicker_color_script",
		"expanded_arrow": "colorpicker_expanded_arrow",
		"folded_arrow": "colorpicker_folded_arrow",
		"menu_option": "colorpicker_menu_option",
		"overbright_indicator": "colorpicker_overbright_indicator",
		"picker_cursor": "colorpicker_picker_cursor",
		"picker_cursor_bg": "colorpicker_picker_cursor_bg",
		"sample_bg": "colorpicker_sample_bg",
		"sample_revert": "colorpicker_sample_revert",
		"screen_picker": "colorpicker_screen_picker",
		"shape_circle": "colorpicker_shape_circle",
		"shape_rect": "colorpicker_shape_rect",
		"shape_rect_wheel": "colorpicker_shape_rect_wheel",
	},
	"ColorPickerButton": {
		"bg": "colorpicker_button_bg",
	},
	"GraphEdit": {
		"grid_toggle": "graph_grid_toggle",
		"layout": "graph_layout",
		"minimap_toggle": "graph_minimap_toggle",
		"snapping_toggle": "graph_snapping_toggle",
		"zoom_in": "graph_zoom_in",
		"zoom_out": "graph_zoom_out",
		"zoom_reset": "graph_zoom_reset",
	},
	"GraphNode": {
		"port": "graph_port",
		"resizer": "graph_resizer",
	},
	"GraphFrame": {
		"resizer": "graph_resizer",
	},
}

var _stage := "slot-freeze"
var _failures: Array[String] = []
var _pending: Array[String] = []
var _ok: Array[String] = []

func _init() -> void:
	_parse_args()
	_run()
	_emit_summary_and_quit()


func _parse_args() -> void:
	for source in [OS.get_cmdline_user_args(), OS.get_cmdline_args()]:
		var args: PackedStringArray = source
		var i := 0
		while i < args.size():
			if args[i] == "--stage" and i + 1 < args.size():
				_stage = args[i + 1]
				break
			i += 1
	if not ["slot-freeze", "popups-menus", "filedialog", "colorpicker", "graph", "full"].has(_stage):
		_failures.append("unknown stage: %s" % _stage)
		_stage = "slot-freeze"
	print("PHASE7_VERIFY: stage=%s" % _stage)


func _run() -> void:
	if not _verify_helper_wiring():
		return
	assert_slot_freeze()
	assert_known_stale_phase7_slots_absent()
	assert_phase7_icon_recipe_names()
	assert_no_theme_clear()
	assert_one_addon_root_gd()
	assert_public_export_lock()
	assert_slot_freeze_artifact()
	if ["popups-menus", "filedialog", "colorpicker", "graph", "full"].has(_stage):
		assert_popups_menus_stage()
	if ["filedialog", "colorpicker", "graph", "full"].has(_stage):
		assert_filedialog_stage()
	if ["colorpicker", "graph", "full"].has(_stage):
		assert_colorpicker_stage()
	if ["graph", "full"].has(_stage):
		assert_graph_stage()


func _verify_helper_wiring() -> bool:
	var loaded := ResourceLoader.load(PULSE_PATH, "", ResourceLoader.CACHE_MODE_IGNORE)
	if loaded == null or not (loaded is NeoCadeTheme):
		_failures.append("Pulse direction did not load as NeoCadeTheme: %s" % PULSE_PATH)
		return false
	var theme: NeoCadeTheme = loaded
	if not theme.has_stylebox("normal", "Button"):
		_failures.append("Phase 4/5 baseline missing: Button.normal stylebox absent")
		return false
	if not FileAccess.file_exists(PRODUCTION_GD):
		_failures.append("production script missing: %s" % PRODUCTION_GD)
		return false
	print("PHASE7_VERIFY: helper wiring OK")
	return true


func assert_slot_freeze() -> void:
	var group := "assert_slot_freeze"
	var constants := _script_constants()
	var canonical: Dictionary = constants.get("CANONICAL_SLOT_NAMES", {})
	var problems: Array[String] = []
	for type_name in EXPECTED_SLOT_FREEZE.keys():
		var expected_block: Dictionary = EXPECTED_SLOT_FREEZE[type_name]
		if not canonical.has(type_name):
			problems.append("%s missing from CANONICAL_SLOT_NAMES" % type_name)
			continue
		var actual_block: Dictionary = canonical.get(type_name, {})
		var expected_types := _sorted_strings(expected_block.keys())
		var actual_types := _sorted_strings(actual_block.keys())
		if actual_types != expected_types:
			problems.append("%s data types mismatch expected=%s actual=%s" % [type_name, str(expected_types), str(actual_types)])
			continue
		for data_type in expected_block.keys():
			var expected := _sorted_strings(expected_block[data_type])
			var actual := _sorted_slot_values(actual_block.get(data_type, []))
			if actual != expected:
				problems.append("%s.%s mismatch expected=%s actual=%s" % [type_name, data_type, str(expected), str(actual)])
	if problems.is_empty():
		_group_ok(group, "official Phase 7 slot freeze matches local Godot 4.6.2 probe")
	else:
		_group_fail(group, "; ".join(problems))


func assert_known_stale_phase7_slots_absent() -> void:
	var group := "assert_known_stale_phase7_slots_absent"
	var constants := _script_constants()
	var binding: Dictionary = constants.get("BINDING_TABLE", {})
	var canonical: Dictionary = constants.get("CANONICAL_SLOT_NAMES", {})
	var problems: Array[String] = []

	var file_colors: Dictionary = binding.get("FileDialog", {}).get("color", {})
	if file_colors.has("icon_normal_color"):
		problems.append("BINDING_TABLE.FileDialog.color still has unsupported icon_normal_color")
	var file_icons: Dictionary = binding.get("FileDialog", {}).get("icon", {})
	if file_icons.has("file_up"):
		problems.append("BINDING_TABLE.FileDialog.icon has guessed stale file_up slot")

	var canonical_file: Dictionary = canonical.get("FileDialog", {})
	if _sorted_slot_values(canonical_file.get("color", [])).has("icon_normal_color"):
		problems.append("CANONICAL_SLOT_NAMES.FileDialog.color still includes icon_normal_color")
	if _sorted_slot_values(canonical_file.get("icon", [])).has("file_up"):
		problems.append("CANONICAL_SLOT_NAMES.FileDialog.icon still includes guessed file_up")

	for type_name in ["GraphEdit", "GraphNode", "GraphFrame"]:
		var expected_graph_styles: Array[String] = _sorted_strings(EXPECTED_SLOT_FREEZE[type_name].get("stylebox", []))
		var graph_style: Dictionary = binding.get(type_name, {}).get("stylebox", {})
		for slot in graph_style.keys():
			var slot_name := String(slot)
			if slot_name.find("focus") != -1 and not expected_graph_styles.has(slot_name):
				problems.append("%s.stylebox has invented graph focus combo slot %s" % [type_name, slot_name])

	var source := _read_production_source_non_comment()
	for token in ["\"file_up\"", "\"panel_selected_focus\"", "\"slot_focus\"", "\"titlebar_focus\""]:
		if source.find(token) != -1:
			problems.append("non-comment production source still contains stale Phase 7 token %s" % token)

	if problems.is_empty():
		_group_ok(group, "known stale Phase 7 slot names are absent")
	else:
		_group_fail(group, "; ".join(problems))


func assert_phase7_icon_recipe_names() -> void:
	var group := "assert_phase7_icon_recipe_names"
	var binding: Dictionary = _script_constants().get("BINDING_TABLE", {})
	var problems: Array[String] = []
	for type_name in EXPECTED_PHASE7_ICON_RECIPES.keys():
		var expected: Dictionary = EXPECTED_PHASE7_ICON_RECIPES[type_name]
		var icon_block: Dictionary = binding.get(type_name, {}).get("icon", {})
		for slot in icon_block.keys():
			var slot_name := String(slot)
			if not expected.has(slot_name):
				problems.append("%s.icon has unsupported Phase 7 slot %s" % [type_name, slot_name])
				continue
			var recipe: Dictionary = icon_block.get(slot_name, {})
			var actual_icon: String = recipe.get("icon", "")
			if actual_icon != expected[slot_name]:
				problems.append("%s.icon recipe %s expected %s got %s" % [type_name, slot_name, expected[slot_name], actual_icon])
	if problems.is_empty():
		_group_ok(group, "Phase 7 icon recipe filenames are canonical or intentionally allowlisted")
	else:
		_group_fail(group, "; ".join(problems))


func assert_no_theme_clear() -> void:
	var group := "assert_no_theme_clear"
	var source := _read_production_source_non_comment()
	var forbidden := ["Theme.clear(", ".clear(", "set_theme(null)"]
	var found: Array[String] = []
	for token in forbidden:
		if source.find(token) != -1:
			found.append(token)
	if found.is_empty():
		_group_ok(group, "non-comment production source has no Theme.clear/.clear/set_theme(null)")
	else:
		_group_fail(group, "forbidden regeneration reset calls found: " + ", ".join(found))


func assert_one_addon_root_gd() -> void:
	var group := "assert_one_addon_root_gd"
	var dir := DirAccess.open("res://addons/neocade_theme")
	if dir == null:
		_group_fail(group, "cannot open addon root")
		return
	var files: Array[String] = []
	dir.list_dir_begin()
	var name := dir.get_next()
	while name != "":
		if not dir.current_is_dir() and name.ends_with(".gd"):
			files.append(name)
		name = dir.get_next()
	dir.list_dir_end()
	files.sort()
	if files == ["neocade_theme.gd"]:
		_group_ok(group, "addon root contains exactly one production .gd")
	else:
		_group_fail(group, "addon root .gd files expected [neocade_theme.gd], got %s" % str(files))


func assert_public_export_lock() -> void:
	var group := "assert_public_export_lock"
	var raw := _read_file(PRODUCTION_GD)
	var found: Array[String] = []
	for line in raw.split("\n"):
		var s := line.strip_edges()
		if not s.begins_with("@export var "):
			continue
		var rest := s.substr("@export var ".length())
		var name := rest.split(":", true, 1)[0].strip_edges()
		found.append(name)
	if found == EXPECTED_EXPORTS:
		_group_ok(group, "public export surface remains locked at 9 properties")
	else:
		_group_fail(group, "public exports drifted expected=%s actual=%s" % [str(EXPECTED_EXPORTS), str(found)])


func assert_slot_freeze_artifact() -> void:
	var group := "assert_slot_freeze_artifact"
	var text := _read_file(SLOT_FREEZE_PATH)
	var required := [
		"Godot 4.6.2.stable.mono.official.71f334935",
		"logs/07-research-slot-probe.log",
		"FileDialog",
		"ColorPicker",
		"GraphNode",
		"icon_normal_color",
		"file_up",
	]
	var missing: Array[String] = []
	for token in required:
		if text.find(token) == -1:
			missing.append(token)
	if missing.is_empty():
		_group_ok(group, "phase7-slot-freeze.txt records engine, source log, stale exclusions, and official lists")
	else:
		_group_fail(group, "slot-freeze artifact missing: " + ", ".join(missing))


func assert_popups_menus_stage() -> void:
	var group := "assert_popups_menus_stage"
	var theme := _loaded_theme()
	if theme == null:
		_group_fail(group, "Pulse direction did not reload as NeoCadeTheme")
		return

	var problems: Array[String] = []
	_append_missing_slots(problems, theme, "Window", "stylebox", ["embedded_border", "embedded_unfocused_border"])
	_append_missing_slots(problems, theme, "Window", "color", ["title_color", "title_outline_modulate"])
	_append_missing_slots(problems, theme, "Window", "constant", ["close_h_offset", "close_v_offset", "resize_margin", "title_height", "title_outline_size"])
	_append_missing_slots(problems, theme, "Window", "font", ["title_font"])
	_append_missing_slots(problems, theme, "Window", "font_size", ["title_font_size"])
	_append_missing_slots(problems, theme, "Window", "icon", ["close", "close_pressed"])

	_append_missing_slots(problems, theme, "PopupPanel", "stylebox", ["panel"])
	_append_missing_slots(problems, theme, "AcceptDialog", "stylebox", ["panel"])
	_append_missing_slots(problems, theme, "AcceptDialog", "constant", ["buttons_separation"])
	_assert_binding_key_present(problems, "ConfirmationDialog")
	_append_missing_slots(problems, theme, "ConfirmationDialog", "stylebox", ["panel"])
	_append_missing_slots(problems, theme, "TooltipPanel", "stylebox", ["panel"])
	_append_missing_slots(problems, theme, "TooltipLabel", "color", ["font_color", "font_outline_color", "font_shadow_color"])
	_append_missing_slots(problems, theme, "TooltipLabel", "constant", ["outline_size", "shadow_offset_x", "shadow_offset_y"])
	_append_missing_slots(problems, theme, "TooltipLabel", "font", ["font"])
	_append_missing_slots(problems, theme, "TooltipLabel", "font_size", ["font_size"])
	_append_missing_slots(problems, theme, "MenuBar", "stylebox", ["normal", "hover", "pressed", "disabled"])
	_append_missing_slots(problems, theme, "MenuBar", "color", ["font_color", "font_disabled_color", "font_focus_color", "font_hover_color",
		"font_hover_pressed_color", "font_outline_color", "font_pressed_color"])
	_append_missing_slots(problems, theme, "MenuBar", "constant", ["h_separation", "outline_size"])
	_append_missing_slots(problems, theme, "MenuBar", "font", ["font"])
	_append_missing_slots(problems, theme, "MenuBar", "font_size", ["font_size"])

	_assert_no_phase7_font_table_entries(problems, ["Window", "TooltipLabel", "MenuBar"])
	_assert_direct_font_calls_after_binding_walk(problems, {
		"Window.title_font": "set_font(\"title_font\", \"Window\"",
		"Window.title_font_size": "set_font_size(\"title_font_size\", \"Window\"",
		"TooltipLabel.font": "set_font(\"font\", \"TooltipLabel\"",
		"TooltipLabel.font_size": "set_font_size(\"font_size\", \"TooltipLabel\"",
		"MenuBar.font": "set_font(\"font\", \"MenuBar\"",
		"MenuBar.font_size": "set_font_size(\"font_size\", \"MenuBar\"",
	})
	_assert_tooltip_readability(problems, theme)
	_assert_popup_shells_no_soft_shadow(problems, theme)
	_assert_popupmenu_stage(problems, theme)

	if problems.is_empty():
		_group_ok(group, "Window, popup/dialog shells, Tooltip, MenuBar, and PopupMenu production coverage is complete")
	else:
		_group_fail(group, "; ".join(problems))


func assert_filedialog_stage() -> void:
	var group := "assert_filedialog_stage"
	var theme := _loaded_theme()
	if theme == null:
		_group_fail(group, "Pulse direction did not reload as NeoCadeTheme")
		return

	var problems: Array[String] = []
	_assert_binding_key_present(problems, "FileDialog")
	_assert_filedialog_binding_matches_official_slots(problems)
	_append_missing_slots(problems, theme, "FileDialog", "color", ["file_disabled_color", "file_icon_color", "folder_icon_color"])
	_append_missing_slots(problems, theme, "FileDialog", "constant", ["thumbnail_size"])
	_append_missing_slots(problems, theme, "FileDialog", "icon", ["back_folder", "clear", "create_folder", "favorite", "favorite_down",
		"favorite_up", "file", "file_thumbnail", "folder", "folder_thumbnail", "forward_folder", "list_mode", "load",
		"parent_folder", "reload", "save", "sort", "thumbnail_mode", "toggle_filename_filter", "toggle_hidden"])
	_assert_filedialog_no_stale_entries(problems, theme)
	_assert_filedialog_thumbnail_size(problems, theme)
	_assert_filedialog_shell(problems, theme)
	_assert_filedialog_icon_mapping(problems)
	_assert_filedialog_icons_load_as_texture2d(problems, theme)
	_assert_filedialog_thumbnail_platform_delta(problems)
	_assert_filedialog_no_extra_artifacts(problems)

	if problems.is_empty():
		_group_ok(group, "FileDialog official color, constant, icon, and shell coverage is complete")
		print("PHASE7_COV:COV-06 FileDialog popup-class coverage complete")
		print("PHASE7_COV:COV-01 FileDialog contributes to desktop structural scorecard closure")
		print("PHASE7_COV:COV-07 FileDialog shell resolves through dialog/window chrome")
	else:
		_group_fail(group, "; ".join(problems))


func assert_colorpicker_stage() -> void:
	_group_pending("assert_colorpicker_stage", "Plan 07-04 owns ColorPicker and ColorPickerButton icons and production coverage")


func assert_graph_stage() -> void:
	_group_pending("assert_graph_stage", "Plan 07-05 owns GraphEdit, GraphNode, and GraphFrame production coverage")


func _loaded_theme() -> NeoCadeTheme:
	var loaded := ResourceLoader.load(PULSE_PATH, "", ResourceLoader.CACHE_MODE_IGNORE)
	if loaded == null or not (loaded is NeoCadeTheme):
		return null
	return loaded


func _append_missing_slots(problems: Array[String], theme: Theme, type_name: String, data_type: String, slots: Array) -> void:
	for raw_slot in slots:
		var slot := String(raw_slot)
		var has_slot := false
		match data_type:
			"stylebox":
				has_slot = theme.has_stylebox(slot, type_name)
			"color":
				has_slot = theme.has_color(slot, type_name)
			"constant":
				has_slot = theme.has_constant(slot, type_name)
			"font":
				has_slot = theme.has_font(slot, type_name)
			"font_size":
				has_slot = theme.has_font_size(slot, type_name)
			"icon":
				has_slot = theme.has_icon(slot, type_name)
		if not has_slot:
			problems.append("%s.%s missing %s" % [type_name, data_type, slot])


func _assert_binding_key_present(problems: Array[String], type_name: String) -> void:
	var binding: Dictionary = _script_constants().get("BINDING_TABLE", {})
	if not binding.has(type_name):
		problems.append("BINDING_TABLE missing explicit %s key" % type_name)


func _assert_no_phase7_font_table_entries(problems: Array[String], type_names: Array) -> void:
	var binding: Dictionary = _script_constants().get("BINDING_TABLE", {})
	for raw_type in type_names:
		var type_name := String(raw_type)
		var type_block: Dictionary = binding.get(type_name, {})
		if type_block.has("font"):
			problems.append("BINDING_TABLE.%s must not contain font entries" % type_name)
		if type_block.has("font_size"):
			problems.append("BINDING_TABLE.%s must not contain font_size entries" % type_name)


func _assert_direct_font_calls_after_binding_walk(problems: Array[String], required_calls: Dictionary) -> void:
	var source := _read_production_source_non_comment()
	var walk_index := source.find("for theme_type in BINDING_TABLE.keys():")
	if walk_index == -1:
		problems.append("BINDING_TABLE walk not found in _regenerate_theme() source")
		return
	for label in required_calls.keys():
		var needle := String(required_calls[label])
		var index := source.find(needle)
		if index == -1:
			problems.append("%s missing direct call %s" % [String(label), needle])
		elif index < walk_index:
			problems.append("%s direct call must occur after BINDING_TABLE walk" % String(label))


func _assert_tooltip_readability(problems: Array[String], theme: Theme) -> void:
	var label_color := theme.get_color("font_color", "TooltipLabel")
	var panel := theme.get_stylebox("panel", "TooltipPanel")
	if panel is StyleBoxFlat:
		var bg := (panel as StyleBoxFlat).bg_color
		var ratio := _contrast_ratio(label_color, bg)
		if ratio < 4.5:
			problems.append("TooltipLabel contrast below AA: %.2f" % ratio)
	else:
		problems.append("TooltipPanel.panel is not StyleBoxFlat")
	if theme.get_constant("shadow_offset_x", "TooltipLabel") != 0:
		problems.append("TooltipLabel.shadow_offset_x must be 0")
	if theme.get_constant("shadow_offset_y", "TooltipLabel") != 0:
		problems.append("TooltipLabel.shadow_offset_y must be 0")
	if theme.get_color("font_shadow_color", "TooltipLabel").a > 0.05:
		problems.append("TooltipLabel.font_shadow_color must be transparent")


func _assert_popup_shells_no_soft_shadow(problems: Array[String], theme: Theme) -> void:
	var shell_slots := {
		"Window": ["embedded_border", "embedded_unfocused_border"],
		"PopupPanel": ["panel"],
		"AcceptDialog": ["panel"],
		"ConfirmationDialog": ["panel"],
		"TooltipPanel": ["panel"],
	}
	for type_name in shell_slots.keys():
		for raw_slot in shell_slots[type_name]:
			var slot := String(raw_slot)
			if not theme.has_stylebox(slot, type_name):
				continue
			var sb := theme.get_stylebox(slot, type_name)
			if not (sb is StyleBoxFlat):
				problems.append("%s.%s must use StyleBoxFlat, not texture chrome" % [type_name, slot])
				continue
			var flat := sb as StyleBoxFlat
			if flat.shadow_size > 0:
				problems.append("%s.%s must not use soft shadow_size=%d" % [type_name, slot, flat.shadow_size])


func _assert_popupmenu_stage(problems: Array[String], theme: Theme) -> void:
	_append_missing_slots(problems, theme, "PopupMenu", "stylebox", ["panel", "hover", "separator", "labeled_separator_left", "labeled_separator_right"])
	_append_missing_slots(problems, theme, "PopupMenu", "color", ["font_accelerator_color", "font_color", "font_disabled_color", "font_hover_color",
		"font_outline_color", "font_separator_color", "font_separator_outline_color"])
	_append_missing_slots(problems, theme, "PopupMenu", "constant", ["gutter_compact", "h_separation", "icon_max_width", "indent",
		"item_end_padding", "item_start_padding", "outline_size", "separator_outline_size", "v_separation"])
	_append_missing_slots(problems, theme, "PopupMenu", "font", ["font", "font_separator"])
	_append_missing_slots(problems, theme, "PopupMenu", "font_size", ["font_size", "font_separator_size"])
	_append_missing_slots(problems, theme, "PopupMenu", "icon", ["checked", "checked_disabled", "radio_checked", "radio_checked_disabled",
		"radio_unchecked", "radio_unchecked_disabled", "submenu", "submenu_mirrored", "unchecked", "unchecked_disabled"])
	_assert_no_phase7_font_table_entries(problems, ["PopupMenu"])
	_assert_direct_font_calls_after_binding_walk(problems, {
		"PopupMenu.font": "set_font(\"font\", \"PopupMenu\"",
		"PopupMenu.font_separator": "set_font(\"font_separator\", \"PopupMenu\"",
		"PopupMenu.font_size": "set_font_size(\"font_size\", \"PopupMenu\"",
		"PopupMenu.font_separator_size": "set_font_size(\"font_separator_size\", \"PopupMenu\"",
	})
	_assert_popupmenu_icon_mapping(problems)
	_assert_popupmenu_separators(problems, theme)
	_assert_popupmenu_metrics(problems, theme)


func _assert_popupmenu_icon_mapping(problems: Array[String]) -> void:
	var icon_block: Dictionary = _script_constants().get("BINDING_TABLE", {}).get("PopupMenu", {}).get("icon", {})
	var expected: Dictionary = EXPECTED_PHASE7_ICON_RECIPES["PopupMenu"]
	for slot in expected.keys():
		if not icon_block.has(slot):
			problems.append("PopupMenu.icon missing canonical slot %s" % String(slot))
			continue
		var recipe: Dictionary = icon_block[slot]
		if recipe.get("icon", "") != expected[slot]:
			problems.append("PopupMenu.icon %s expected %s got %s" % [String(slot), expected[slot], recipe.get("icon", "")])
	var reuse_pairs := {
		"checked_disabled": "checked",
		"unchecked_disabled": "unchecked",
		"radio_checked_disabled": "radio_checked",
		"radio_unchecked_disabled": "radio_unchecked",
	}
	for disabled_slot in reuse_pairs.keys():
		var base_slot: String = reuse_pairs[disabled_slot]
		if icon_block.has(disabled_slot) and icon_block.has(base_slot):
			if icon_block[disabled_slot].get("icon", "") != icon_block[base_slot].get("icon", ""):
				problems.append("PopupMenu.%s must reuse %s artwork" % [String(disabled_slot), base_slot])


func _assert_popupmenu_separators(problems: Array[String], theme: Theme) -> void:
	for slot in ["separator", "labeled_separator_left", "labeled_separator_right"]:
		if not theme.has_stylebox(slot, "PopupMenu"):
			continue
		var sb := theme.get_stylebox(slot, "PopupMenu")
		if not (sb is StyleBoxFlat):
			problems.append("PopupMenu.%s separator must be StyleBoxFlat" % slot)
			continue
		var flat := sb as StyleBoxFlat
		if flat.content_margin_left != 0 or flat.content_margin_right != 0 or flat.content_margin_top != 0 or flat.content_margin_bottom != 0:
			problems.append("PopupMenu.%s separator must have zero content margins" % slot)
		if flat.bg_color.a > 0.75:
			problems.append("PopupMenu.%s separator alpha too panel-like: %.2f" % [slot, flat.bg_color.a])


func _assert_popupmenu_metrics(problems: Array[String], theme: Theme) -> void:
	var max_values := {
		"v_separation": 6,
		"h_separation": 8,
		"item_start_padding": 10,
		"item_end_padding": 10,
		"indent": 24,
		"icon_max_width": 24,
		"outline_size": 1,
		"separator_outline_size": 1,
	}
	for slot in max_values.keys():
		var value := theme.get_constant(String(slot), "PopupMenu")
		if value > int(max_values[slot]):
			problems.append("PopupMenu.%s too loose for desktop density: %d" % [String(slot), value])
	if theme.get_constant("gutter_compact", "PopupMenu") != 1:
		problems.append("PopupMenu.gutter_compact must be 1")


func _assert_filedialog_binding_matches_official_slots(problems: Array[String]) -> void:
	var file_block: Dictionary = _script_constants().get("BINDING_TABLE", {}).get("FileDialog", {})
	var expected_block: Dictionary = EXPECTED_SLOT_FREEZE["FileDialog"]
	for raw_data_type in file_block.keys():
		var data_type := String(raw_data_type)
		if not expected_block.has(data_type):
			problems.append("BINDING_TABLE.FileDialog has unsupported data type %s" % data_type)
			continue
		var expected_slots := _sorted_strings(expected_block[data_type])
		var actual_slots := _sorted_slot_values(file_block.get(data_type, {}))
		for slot in actual_slots:
			if not expected_slots.has(slot):
				problems.append("BINDING_TABLE.FileDialog.%s has unsupported slot %s" % [data_type, slot])
	for raw_data_type in ["color", "constant", "icon"]:
		var data_type := String(raw_data_type)
		var expected_slots := _sorted_strings(expected_block[data_type])
		var actual_slots := _sorted_slot_values(file_block.get(data_type, {}))
		for slot in expected_slots:
			if not actual_slots.has(slot):
				problems.append("BINDING_TABLE.FileDialog.%s missing official slot %s" % [data_type, slot])


func _assert_filedialog_no_stale_entries(problems: Array[String], theme: Theme) -> void:
	var file_colors: Dictionary = _script_constants().get("BINDING_TABLE", {}).get("FileDialog", {}).get("color", {})
	if file_colors.has("icon_normal_color"):
		problems.append("BINDING_TABLE.FileDialog.color still has unsupported icon_normal_color")
	if theme.has_color("icon_normal_color", "FileDialog"):
		problems.append("loaded theme still exposes unsupported FileDialog.icon_normal_color")


func _assert_filedialog_thumbnail_size(problems: Array[String], theme: Theme) -> void:
	if not theme.has_constant("thumbnail_size", "FileDialog"):
		return
	var size := theme.get_constant("thumbnail_size", "FileDialog")
	if size < 64 or size > 160:
		problems.append("FileDialog.thumbnail_size must be desktop-appropriate 64..160, got %d" % size)


func _assert_filedialog_shell(problems: Array[String], theme: Theme) -> void:
	var has_shell := theme.has_stylebox("panel", "AcceptDialog") or theme.has_stylebox("panel", "ConfirmationDialog") or theme.has_stylebox("embedded_border", "Window")
	if not has_shell:
		problems.append("FileDialog shell must resolve through AcceptDialog/ConfirmationDialog/Window theme entries")


func _assert_filedialog_icon_mapping(problems: Array[String]) -> void:
	var icon_block: Dictionary = _script_constants().get("BINDING_TABLE", {}).get("FileDialog", {}).get("icon", {})
	var expected: Dictionary = EXPECTED_PHASE7_ICON_RECIPES["FileDialog"]
	for slot in expected.keys():
		if not icon_block.has(slot):
			problems.append("FileDialog.icon missing canonical slot %s" % String(slot))
			continue
		var recipe: Dictionary = icon_block[slot]
		if recipe.get("icon", "") != expected[slot]:
			problems.append("FileDialog.icon %s expected %s got %s" % [String(slot), expected[slot], recipe.get("icon", "")])


func _assert_filedialog_icons_load_as_texture2d(problems: Array[String], theme: Theme) -> void:
	var expected: Dictionary = EXPECTED_PHASE7_ICON_RECIPES["FileDialog"]
	for slot in expected.keys():
		var slot_name := String(slot)
		var icon_name := String(expected[slot])
		var path := "res://addons/neocade_theme/icons/%s.svg" % icon_name
		var loaded := load(path)
		if not (loaded is Texture2D):
			problems.append("FileDialog icon asset %s did not load as Texture2D" % path)
		if theme.has_icon(slot_name, "FileDialog"):
			var theme_icon := theme.get_icon(slot_name, "FileDialog")
			if theme_icon == null or not (theme_icon is Texture2D):
				problems.append("FileDialog.%s bound icon is not Texture2D" % slot_name)


func _assert_filedialog_thumbnail_platform_delta(problems: Array[String]) -> void:
	var desktop := NeoCadeTheme.new()
	desktop.platform = NeoCadeTheme.Platform.DESKTOP
	var mobile := NeoCadeTheme.new()
	mobile.platform = NeoCadeTheme.Platform.MOBILE
	if not desktop.has_constant("thumbnail_size", "FileDialog") or not mobile.has_constant("thumbnail_size", "FileDialog"):
		problems.append("FileDialog.thumbnail_size missing on desktop or mobile platform instance")
		return
	var desktop_size := desktop.get_constant("thumbnail_size", "FileDialog")
	var mobile_size := mobile.get_constant("thumbnail_size", "FileDialog")
	if desktop_size != 96:
		problems.append("FileDialog desktop thumbnail_size expected 96 got %d" % desktop_size)
	if mobile_size <= desktop_size:
		problems.append("FileDialog mobile thumbnail_size should exceed desktop for Phase 8 tuning, got desktop=%d mobile=%d" % [desktop_size, mobile_size])


func _assert_filedialog_no_extra_artifacts(problems: Array[String]) -> void:
	var expected: Dictionary = EXPECTED_PHASE7_ICON_RECIPES["FileDialog"]
	var allowed: Array[String] = []
	for slot in expected.keys():
		var base := String(expected[slot])
		allowed.append("%s.svg" % base)
		allowed.append("%s.svg.import" % base)

	var addon_dir := DirAccess.open("res://addons/neocade_theme")
	if addon_dir == null:
		problems.append("could not inspect addon root for FileDialog-specific artifacts")
	else:
		addon_dir.list_dir_begin()
		var root_name := addon_dir.get_next()
		while root_name != "":
			if not addon_dir.current_is_dir():
				var lower := root_name.to_lower()
				if lower.find("filedialog") != -1 or lower.find("file_dialog") != -1:
					problems.append("FileDialog-specific artifact outside icons dir: addons/neocade_theme/%s" % root_name)
			root_name = addon_dir.get_next()
		addon_dir.list_dir_end()

	var icons_dir := DirAccess.open("res://addons/neocade_theme/icons")
	if icons_dir == null:
		problems.append("could not inspect icons dir for FileDialog-specific artifacts")
		return
	icons_dir.list_dir_begin()
	var icon_file := icons_dir.get_next()
	while icon_file != "":
		if not icons_dir.current_is_dir() and icon_file.begins_with("filedialog_"):
			if not allowed.has(icon_file):
				problems.append("unexpected FileDialog icon-side artifact: addons/neocade_theme/icons/%s" % icon_file)
			if not (icon_file.ends_with(".svg") or icon_file.ends_with(".svg.import")):
				problems.append("FileDialog artifact is not SVG/import sidecar: addons/neocade_theme/icons/%s" % icon_file)
		icon_file = icons_dir.get_next()
	icons_dir.list_dir_end()


func _contrast_ratio(a: Color, b: Color) -> float:
	var l1 := _relative_luminance(a)
	var l2 := _relative_luminance(b)
	if l1 < l2:
		var tmp := l1
		l1 = l2
		l2 = tmp
	return (l1 + 0.05) / (l2 + 0.05)


func _relative_luminance(c: Color) -> float:
	return 0.2126 * _srgb_channel(c.r) + 0.7152 * _srgb_channel(c.g) + 0.0722 * _srgb_channel(c.b)


func _srgb_channel(value: float) -> float:
	if value <= 0.03928:
		return value / 12.92
	return pow((value + 0.055) / 1.055, 2.4)


func _script_constants() -> Dictionary:
	var loaded := ResourceLoader.load(PULSE_PATH, "", ResourceLoader.CACHE_MODE_IGNORE)
	if loaded == null:
		return {}
	return loaded.get_script().get_script_constant_map()


func _sorted_slot_values(raw: Variant) -> Array[String]:
	if typeof(raw) == TYPE_DICTIONARY:
		return _sorted_strings((raw as Dictionary).keys())
	return _sorted_strings(raw)


func _sorted_strings(raw: Variant) -> Array[String]:
	var out: Array[String] = []
	if raw is Array:
		for item in raw:
			out.append(String(item))
	elif raw is PackedStringArray:
		for item in raw:
			out.append(String(item))
	elif typeof(raw) == TYPE_DICTIONARY:
		for item in (raw as Dictionary).keys():
			out.append(String(item))
	else:
		return out
	out.sort()
	return out


func _read_file(path: String) -> String:
	var f := FileAccess.open(path, FileAccess.READ)
	if f == null:
		return ""
	var text := f.get_as_text()
	f.close()
	return text


func _read_production_source_non_comment() -> String:
	var raw := _read_file(PRODUCTION_GD)
	var out: PackedStringArray = []
	for line in raw.split("\n"):
		var index := line.find("#")
		if index >= 0:
			out.append(line.substr(0, index))
		else:
			out.append(line)
	return "\n".join(out)


func _group_ok(group: String, detail: String) -> void:
	print("PHASE7_GROUP_OK:%s ENFORCED  %s" % [group, detail])
	_ok.append(group)


func _group_pending(group: String, detail: String) -> void:
	if _stage == "full":
		print("PHASE7_GROUP_FAIL:%s FULL pending  %s" % [group, detail])
		_failures.append("%s pending in full stage: %s" % [group, detail])
		return
	print("PHASE7_GROUP_PENDING:%s  %s" % [group, detail])
	_pending.append(group)


func _group_fail(group: String, detail: String) -> void:
	print("PHASE7_GROUP_FAIL:%s  %s" % [group, detail])
	_failures.append("%s -- %s" % [group, detail])


func _emit_summary_and_quit() -> void:
	print("----- PHASE7_VERIFY summary -----")
	print("  stage:          %s" % _stage)
	print("  groups OK:      %d" % _ok.size())
	print("  groups PENDING: %d  %s" % [_pending.size(), str(_pending)])
	print("  failures:       %d" % _failures.size())
	for f in _failures:
		print("    - %s" % f)
	print("---------------------------------")
	if not _failures.is_empty():
		quit(1)
		return
	print("PHASE7_VERIFY OK (stage=%s)" % _stage)
	quit(0)
