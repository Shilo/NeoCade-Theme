extends SceneTree

## Phase 6 verifier foundation. Run via:
##
##   <godot-cli> --headless --path . --script \
##     .planning/phases/06-lists-layout-range-tree-itemlist-tabs-containers-sliders-des/helpers/_phase6_verify_headless.gd \
##     -- --stage slot-freeze
##
## Stages:
##   slot-freeze        Strict foundation gate for Plan 06-01.
##   tree               Future Plan 06-02 group placeholder.
##   itemlist-foldable  Future Plan 06-03 group placeholder.
##   tabs               Future Plan 06-04 group placeholder.
##   range-containers   Future Plan 06-05 group placeholder.
##   full               Fails while any future group is pending.

const PRODUCTION_GD := "res://addons/neocade_theme/neocade_theme.gd"
const PULSE_PATH := "res://addons/neocade_theme/pulse_neocade_theme.tres"
const SLOT_FREEZE_PATH := "res://.planning/phases/06-lists-layout-range-tree-itemlist-tabs-containers-sliders-des/helpers/phase6-slot-freeze.txt"

const EXPECTED_EXPORTS := [
	"base_color", "accent_color", "raised", "platform",
	"corner_radius", "spacing", "raised_strength", "focus_thickness", "outline_width",
]

const EXPECTED_SLOT_FREEZE := {
	"Tree": {
		"stylebox": ["button_hover", "button_pressed", "cursor", "cursor_unfocused",
			"custom_button", "custom_button_hover", "custom_button_pressed", "focus",
			"hovered", "hovered_dimmed", "hovered_selected", "hovered_selected_focus",
			"panel", "selected", "selected_focus", "title_button_hover",
			"title_button_normal", "title_button_pressed"],
		"color": ["children_hl_line_color", "custom_button_font_highlight", "drop_position_color",
			"font_color", "font_disabled_color", "font_hovered_color", "font_hovered_dimmed_color",
			"font_hovered_selected_color", "font_outline_color", "font_selected_color",
			"guide_color", "parent_hl_line_color", "relationship_line_color", "scroll_hint_color",
			"title_button_color"],
		"constant": ["button_margin", "check_h_separation", "children_hl_line_width",
			"dragging_unfold_wait_msec", "draw_guides", "draw_relationship_lines",
			"h_separation", "icon_h_separation", "icon_max_width", "inner_item_margin_bottom",
			"inner_item_margin_left", "inner_item_margin_right", "inner_item_margin_top",
			"item_margin", "outline_size", "parent_hl_line_margin", "parent_hl_line_width",
			"relationship_line_width", "scroll_border", "scroll_speed", "scrollbar_h_separation",
			"scrollbar_margin_bottom", "scrollbar_margin_left", "scrollbar_margin_right",
			"scrollbar_margin_top", "scrollbar_v_separation", "v_separation"],
		"font": ["font", "title_button_font"],
		"font_size": ["font_size", "title_button_font_size"],
		"icon": ["arrow", "arrow_collapsed", "arrow_collapsed_mirrored", "checked",
			"checked_disabled", "indeterminate", "indeterminate_disabled", "scroll_hint",
			"select_arrow", "unchecked", "unchecked_disabled", "updown"],
	},
	"FoldableContainer": {
		"stylebox": ["focus", "panel", "title_collapsed_hover_panel", "title_collapsed_panel",
			"title_hover_panel", "title_panel"],
		"color": ["collapsed_font_color", "font_color", "font_outline_color", "hover_font_color"],
		"constant": ["h_separation", "outline_size"],
		"font": ["font"],
		"font_size": ["font_size"],
		"icon": ["expanded_arrow", "expanded_arrow_mirrored", "folded_arrow", "folded_arrow_mirrored"],
	},
	"TabBar": {
		"stylebox": ["button_highlight", "button_pressed", "tab_disabled", "tab_focus",
			"tab_hovered", "tab_selected", "tab_unselected"],
		"color": ["drop_mark_color", "font_disabled_color", "font_hovered_color",
			"font_outline_color", "font_selected_color", "font_unselected_color",
			"icon_disabled_color", "icon_hovered_color", "icon_selected_color", "icon_unselected_color"],
		"constant": ["h_separation", "hover_switch_wait_msec", "icon_max_width", "outline_size"],
		"font": ["font"],
		"font_size": ["font_size"],
		"icon": ["close", "decrement", "decrement_highlight", "drop_mark", "increment", "increment_highlight"],
	},
	"TabContainer": {
		"stylebox": ["panel", "tab_disabled", "tab_focus", "tab_hovered", "tab_selected",
			"tab_unselected", "tabbar_background"],
		"color": ["drop_mark_color", "font_disabled_color", "font_hovered_color",
			"font_outline_color", "font_selected_color", "font_unselected_color",
			"icon_disabled_color", "icon_hovered_color", "icon_selected_color", "icon_unselected_color"],
		"constant": ["icon_max_width", "icon_separation", "outline_size", "side_margin"],
		"font": ["font"],
		"font_size": ["font_size"],
		"icon": ["decrement", "decrement_highlight", "drop_mark", "increment",
			"increment_highlight", "menu", "menu_highlight"],
	},
	"ItemList": {
		"stylebox": ["cursor", "cursor_unfocused", "focus", "hovered", "hovered_selected",
			"hovered_selected_focus", "panel", "selected", "selected_focus"],
		"color": ["font_color", "font_hovered_color", "font_hovered_selected_color",
			"font_outline_color", "font_selected_color", "guide_color", "scroll_hint_color"],
		"constant": ["h_separation", "icon_margin", "line_separation", "outline_size", "v_separation"],
		"font": ["font"],
		"font_size": ["font_size"],
		"icon": ["scroll_hint"],
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
		"icon": ["decrement", "decrement_highlight", "decrement_pressed",
			"increment", "increment_highlight", "increment_pressed"],
	},
	"VScrollBar": {
		"stylebox": ["grabber", "grabber_highlight", "grabber_pressed", "scroll", "scroll_focus"],
		"icon": ["decrement", "decrement_highlight", "decrement_pressed",
			"increment", "increment_highlight", "increment_pressed"],
	},
	"ScrollContainer": {
		"stylebox": ["focus", "panel"],
		"color": ["scroll_hint_horizontal_color", "scroll_hint_vertical_color"],
		"icon": ["scroll_hint_horizontal", "scroll_hint_vertical"],
	},
	"SplitContainer": {
		"stylebox": ["split_bar_background"],
		"color": ["touch_dragger_color", "touch_dragger_hover_color", "touch_dragger_pressed_color"],
		"constant": ["autohide", "minimum_grab_thickness", "separation"],
		"icon": ["h_grabber", "h_touch_dragger", "v_grabber", "v_touch_dragger"],
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
	"MarginContainer": {"constant": ["margin_bottom", "margin_left", "margin_right", "margin_top"]},
	"HBoxContainer": {"constant": ["separation"]},
	"VBoxContainer": {"constant": ["separation"]},
	"FlowContainer": {"constant": ["h_separation", "v_separation"]},
	"GridContainer": {"constant": ["h_separation", "v_separation"]},
	"HSeparator": {"stylebox": ["separator"], "constant": ["separation"]},
	"VSeparator": {"stylebox": ["separator"], "constant": ["separation"]},
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
	if not ["slot-freeze", "tree", "itemlist-foldable", "tabs", "range-containers", "full"].has(_stage):
		_failures.append("unknown stage: %s" % _stage)
		_stage = "slot-freeze"
	print("PHASE6_VERIFY: stage=%s" % _stage)


func _run() -> void:
	if not _verify_helper_wiring():
		return
	assert_slot_freeze()
	assert_known_stale_slots_absent()
	assert_no_theme_clear()
	assert_one_addon_root_gd()
	assert_public_export_lock()
	assert_slot_freeze_artifact()
	assert_tree_stage_pending()
	assert_itemlist_foldable_stage_pending()
	assert_tabs_stage_pending()
	assert_range_containers_stage_pending()


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
	print("PHASE6_VERIFY: helper wiring OK")
	return true


func assert_slot_freeze() -> void:
	var group := "assert_slot_freeze"
	var constants := _script_constants()
	var canonical: Dictionary = constants.get("CANONICAL_SLOT_NAMES", {})
	var problems: Array[String] = []
	for type_name in EXPECTED_SLOT_FREEZE.keys():
		var expected_block: Dictionary = EXPECTED_SLOT_FREEZE[type_name]
		var actual_block: Dictionary = canonical.get(type_name, {})
		if actual_block.is_empty():
			problems.append("%s missing from CANONICAL_SLOT_NAMES" % type_name)
			continue
		for data_type in expected_block.keys():
			var expected := _sorted_strings(expected_block[data_type])
			var actual := _sorted_slot_values(actual_block.get(data_type, []))
			if actual != expected:
				problems.append("%s.%s mismatch expected=%s actual=%s" % [type_name, data_type, str(expected), str(actual)])
	if problems.is_empty():
		_group_ok(group, "official Phase 6 slot freeze matches local Godot 4.6.2 probe")
	else:
		_group_fail(group, "; ".join(problems))


func assert_known_stale_slots_absent() -> void:
	var group := "assert_known_stale_slots_absent"
	var constants := _script_constants()
	var binding: Dictionary = constants.get("BINDING_TABLE", {})
	var problems: Array[String] = []
	var tree_style: Dictionary = binding.get("Tree", {}).get("stylebox", {})
	if tree_style.has("hover"):
		problems.append("BINDING_TABLE.Tree.stylebox still has invalid hover slot")
	for slot in EXPECTED_SLOT_FREEZE.Tree.stylebox:
		if not tree_style.has(slot):
			problems.append("BINDING_TABLE.Tree.stylebox missing official slot %s" % slot)
	var foldable_style: Dictionary = binding.get("FoldableContainer", {}).get("stylebox", {})
	for bad in ["title_hover", "title_collapsed"]:
		if foldable_style.has(bad):
			problems.append("FoldableContainer.stylebox still has stale %s" % bad)
	for required in ["title_hover_panel", "title_collapsed_panel", "title_collapsed_hover_panel"]:
		if not foldable_style.has(required):
			problems.append("FoldableContainer.stylebox missing %s" % required)
	var foldable_color: Dictionary = binding.get("FoldableContainer", {}).get("color", {})
	if foldable_color.has("title_font_color"):
		problems.append("FoldableContainer.color still has stale title_font_color")
	for required in ["collapsed_font_color", "hover_font_color"]:
		if not foldable_color.has(required):
			problems.append("FoldableContainer.color missing %s" % required)
	for type_name in ["TabBar", "TabContainer"]:
		var constants_block: Dictionary = binding.get(type_name, {}).get("constant", {})
		if constants_block.has("tab_separation"):
			problems.append("%s.constant still has stale tab_separation" % type_name)
	var source := _read_production_source_non_comment()
	for token in ["\"title_hover\"", "\"title_collapsed\"", "title_font_color", "tab_separation"]:
		if source.find(token) != -1:
			problems.append("non-comment production source still contains stale token %s" % token)
	if problems.is_empty():
		_group_ok(group, "known stale Phase 6 slot names are absent")
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
		"logs/06-research-slot-probe.log",
		"Tree",
		"FoldableContainer",
	]
	var missing: Array[String] = []
	for token in required:
		if text.find(token) == -1:
			missing.append(token)
	if missing.is_empty():
		_group_ok(group, "phase6-slot-freeze.txt records engine, source log, and official lists")
	else:
		_group_fail(group, "slot-freeze artifact missing: " + ", ".join(missing))


func assert_tree_stage_pending() -> void:
	_group_pending("assert_tree_stage", "Tree polish and icon groups are owned by Plan 06-02")


func assert_itemlist_foldable_stage_pending() -> void:
	_group_pending("assert_itemlist_foldable_stage", "ItemList and FoldableContainer polish groups are owned by Plan 06-03")


func assert_tabs_stage_pending() -> void:
	_group_pending("assert_tabs_stage", "TabBar and TabContainer polish/icon groups are owned by Plan 06-04")


func assert_range_containers_stage_pending() -> void:
	_group_pending("assert_range_containers_stage", "Range and container polish groups are owned by Plan 06-05")


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
	print("PHASE6_GROUP_OK:%s ENFORCED  %s" % [group, detail])
	_ok.append(group)


func _group_pending(group: String, detail: String) -> void:
	if _stage == "full":
		print("PHASE6_GROUP_FAIL:%s FULL pending  %s" % [group, detail])
		_failures.append("%s pending in full stage: %s" % [group, detail])
		return
	print("PHASE6_GROUP_PENDING:%s  %s" % [group, detail])
	_pending.append(group)


func _group_fail(group: String, detail: String) -> void:
	print("PHASE6_GROUP_FAIL:%s  %s" % [group, detail])
	_failures.append("%s -- %s" % [group, detail])


func _emit_summary_and_quit() -> void:
	print("----- PHASE6_VERIFY summary -----")
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
	print("PHASE6_VERIFY OK (stage=%s)" % _stage)
	quit(0)
