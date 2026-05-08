extends SceneTree

## Phase 6 verifier foundation. Run via:
##
##   <godot-cli> --headless --path . --script \
##     .planning/phases/06-lists-layout-range-tree-itemlist-tabs-containers-sliders-des/helpers/_phase6_verify_headless.gd \
##     -- --stage slot-freeze
##
## Stages:
##   slot-freeze        Strict foundation gate for Plan 06-01.
##   tree               Tree gate from Plan 06-02.
##   itemlist-foldable  ItemList and FoldableContainer gate from Plan 06-03.
##   tabs               Strict TabBar/TabContainer gate from Plan 06-04.
##   range-containers   Strict range/control/container gate from Plan 06-05.
##   full               Fails while any future group is pending.

const PRODUCTION_GD := "res://addons/neocade_theme/scripts/neocade_theme.gd"
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

const EXPECTED_TREE_ICON_RECIPES := {
	"arrow": "disclosure_expanded",
	"arrow_collapsed": "disclosure_collapsed",
	"arrow_collapsed_mirrored": "disclosure_collapsed_mirrored",
	"checked": "checkbox_checked",
	"checked_disabled": "checkbox_checked",
	"unchecked": "checkbox_unchecked",
	"unchecked_disabled": "checkbox_unchecked",
	"indeterminate": "tree_indeterminate",
	"indeterminate_disabled": "tree_indeterminate",
	"scroll_hint": "tree_scroll_hint",
	"select_arrow": "tree_select_arrow",
	"updown": "tree_updown",
}

const EXPECTED_ITEMLIST_ICON_RECIPES := {
	"scroll_hint": "tree_scroll_hint",
}

const EXPECTED_FOLDABLE_ICON_RECIPES := {
	"expanded_arrow": "disclosure_expanded",
	"expanded_arrow_mirrored": "disclosure_expanded_mirrored",
	"folded_arrow": "disclosure_collapsed",
	"folded_arrow_mirrored": "disclosure_collapsed_mirrored",
}

const EXPECTED_TAB_ICON_RECIPES := {
	"TabBar": {
		"close": "close",
		"increment": "tab_increment",
		"increment_highlight": "tab_increment",
		"decrement": "tab_decrement",
		"decrement_highlight": "tab_decrement",
		"drop_mark": "tab_drop_mark",
	},
	"TabContainer": {
		"increment": "tab_increment",
		"increment_highlight": "tab_increment",
		"decrement": "tab_decrement",
		"decrement_highlight": "tab_decrement",
		"drop_mark": "tab_drop_mark",
		"menu": "tab_menu",
		"menu_highlight": "tab_menu",
	},
}

const EXPECTED_SLIDER_ICON_RECIPES := {
	"HSlider": {
		"grabber": "slider_grabber",
		"grabber_disabled": "slider_grabber",
		"grabber_highlight": "slider_grabber",
		"tick": "slider_tick",
	},
	"VSlider": {
		"grabber": "slider_grabber",
		"grabber_disabled": "slider_grabber",
		"grabber_highlight": "slider_grabber",
		"tick": "slider_tick",
	},
}

const EXPECTED_SCROLLBAR_ICON_RECIPES := {
	"HScrollBar": {
		"decrement": "scrollbar_left",
		"decrement_highlight": "scrollbar_left",
		"decrement_pressed": "scrollbar_left",
		"increment": "scrollbar_right",
		"increment_highlight": "scrollbar_right",
		"increment_pressed": "scrollbar_right",
	},
	"VScrollBar": {
		"decrement": "scrollbar_up",
		"decrement_highlight": "scrollbar_up",
		"decrement_pressed": "scrollbar_up",
		"increment": "scrollbar_down",
		"increment_highlight": "scrollbar_down",
		"increment_pressed": "scrollbar_down",
	},
}

const EXPECTED_CONTAINER_ICON_RECIPES := {
	"ScrollContainer": {
		"scroll_hint_horizontal": "scroll_hint_horizontal",
		"scroll_hint_vertical": "scroll_hint_vertical",
	},
	"SplitContainer": {
		"h_grabber": "split_grabber_h",
		"h_touch_dragger": "split_touch_dragger_h",
		"v_grabber": "split_grabber_v",
		"v_touch_dragger": "split_touch_dragger_v",
	},
	"HSplitContainer": {
		"grabber": "split_grabber_h",
		"touch_dragger": "split_touch_dragger_h",
	},
	"VSplitContainer": {
		"grabber": "split_grabber_v",
		"touch_dragger": "split_touch_dragger_v",
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
	assert_no_addon_root_gd()
	assert_public_export_lock()
	assert_slot_freeze_artifact()
	if ["tree", "itemlist-foldable", "tabs", "range-containers", "full"].has(_stage):
		assert_tree_stage()
	if ["itemlist-foldable", "tabs", "range-containers", "full"].has(_stage):
		assert_itemlist_foldable_stage()
	if ["tabs", "range-containers", "full"].has(_stage):
		assert_tabs_stage()
	if ["range-containers", "full"].has(_stage):
		assert_range_containers_stage()


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


func assert_no_addon_root_gd() -> void:
	var group := "assert_no_addon_root_gd"
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
	if files.is_empty():
		_group_ok(group, "addon root contains no .gd files")
	else:
		_group_fail(group, "addon root .gd files expected [], got %s" % str(files))


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


func assert_tree_stage() -> void:
	var group := "assert_tree_stage"
	var loaded := ResourceLoader.load(PULSE_PATH, "", ResourceLoader.CACHE_MODE_IGNORE)
	if loaded == null or not (loaded is NeoCadeTheme):
		_group_fail(group, "Pulse direction did not load as NeoCadeTheme")
		return
	var theme: NeoCadeTheme = loaded
	var problems: Array[String] = []
	_assert_tree_slots_present(theme, problems)
	_assert_tree_cursor_overlays(theme, problems)
	_assert_tree_focus_discipline(theme, problems)
	_assert_tree_line_colors(theme, problems)
	_assert_tree_icon_recipes(problems)
	if problems.is_empty():
		print("PHASE6_COVERAGE_OK:COV-05 Tree list/tree coverage contribution enforced")
		print("PHASE6_COVERAGE_OK:COV-01 Tree contributes to cumulative 37-Control scorecard")
		print("PHASE6_COVERAGE_OK:COV-09 Tree focus uses official outer focus slot only")
		print("PHASE6_CARRY_FORWARD:TYPEVAR-06 Tree density/focus/icon behavior to document in Phase 8 final variation/mobile spec")
		_group_ok(group, "Tree official slots, role colors, focus, fonts, constants, and icons are covered")
	else:
		_group_fail(group, "; ".join(problems))


func assert_itemlist_foldable_stage() -> void:
	var failure_count := _failures.size()
	assert_itemlist_stage()
	assert_foldable_stage()
	if _failures.size() == failure_count:
		print("PHASE6_COVERAGE_OK:COV-05 ItemList and FoldableContainer list/control coverage contribution enforced")
		print("PHASE6_COVERAGE_OK:COV-01 ItemList and FoldableContainer contribute to cumulative 37-Control scorecard")
		print("PHASE6_COVERAGE_OK:COV-09 ItemList and FoldableContainer use official focus slots")
		print("PHASE6_CARRY_FORWARD:TYPEVAR-06 ItemList density and Foldable disclosure behavior to document in Phase 8 final variation/mobile spec")


func assert_tabs_stage() -> void:
	var group := "assert_tabs_stage"
	var loaded := ResourceLoader.load(PULSE_PATH, "", ResourceLoader.CACHE_MODE_IGNORE)
	if loaded == null or not (loaded is NeoCadeTheme):
		_group_fail(group, "Pulse direction did not load as NeoCadeTheme")
		return
	var theme: NeoCadeTheme = loaded
	var problems: Array[String] = []
	_assert_tab_slots_present(theme, problems)
	_assert_tab_table_owns_official_slots(problems)
	_assert_tab_shared_style_recipes(problems)
	_assert_tab_shape_recipes(theme, problems)
	_assert_tab_focus_discipline(theme, problems)
	_assert_tab_stale_slots_absent(theme, problems)
	_assert_tab_icon_recipes(problems)
	if problems.is_empty():
		print("PHASE6_COVERAGE_OK:COV-05 TabBar and TabContainer list/tab coverage contribution enforced")
		print("PHASE6_COVERAGE_OK:COV-01 TabBar and TabContainer contribute to cumulative 37-Control scorecard")
		print("PHASE6_COVERAGE_OK:COV-09 TabBar and TabContainer use transparent outer tab_focus rings")
		print("PHASE6_CARRY_FORWARD:TYPEVAR-06 Tab shared state/icon behavior to document in Phase 8 final variation/mobile spec")
		_group_ok(group, "TabBar and TabContainer official slots, shared recipes, focus, constants, fonts, and icons are covered")
	else:
		_group_fail(group, "; ".join(problems))


func assert_range_containers_stage() -> void:
	var group := "assert_range_containers_stage"
	var loaded := ResourceLoader.load(PULSE_PATH, "", ResourceLoader.CACHE_MODE_IGNORE)
	if loaded == null or not (loaded is NeoCadeTheme):
		_group_fail(group, "Pulse direction did not load as NeoCadeTheme")
		return
	var theme: NeoCadeTheme = loaded
	var problems: Array[String] = []
	_assert_range_slots_present(theme, problems)
	_assert_range_table_owns_official_slots(problems)
	_assert_progressbar_chrome(theme, problems)
	_assert_slider_mirroring(problems)
	_assert_slider_icon_recipes(problems)
	_assert_scrollbar_focus_discipline(theme, problems)
	_assert_scrollbar_icon_recipes(problems)
	_assert_container_slots_present(theme, problems)
	_assert_container_table_owns_official_slots(problems)
	_assert_container_focus_and_chrome(theme, problems)
	_assert_container_icon_recipes(problems)
	_assert_range_container_stale_slots_absent(problems)
	if problems.is_empty():
		print("PHASE6_COVERAGE_OK:COV-04 Range controls complete: HSlider/VSlider/ProgressBar/HScrollBar/VScrollBar plus Phase 5 SpinBox carry-forward")
		print("PHASE6_COVERAGE_OK:COV-07 Scroll/Split/Margin/layout/separator container contribution enforced")
		print("PHASE6_COVERAGE_OK:COV-01 Range and container controls contribute to cumulative 37-Control scorecard")
		print("PHASE6_COVERAGE_OK:COV-09 Range/container focus uses official outer focus slots")
		_group_ok(group, "Range controls, scrollbars, containers, separators, official icons, focus slots, and forbidden-slot guards are covered")
	else:
		_group_fail(group, "; ".join(problems))


func _assert_tree_slots_present(theme: Theme, problems: Array[String]) -> void:
	var expected: Dictionary = EXPECTED_SLOT_FREEZE.Tree
	for slot in expected.stylebox:
		if not theme.has_stylebox(slot, "Tree"):
			problems.append("Tree.stylebox missing %s" % slot)
	for slot in expected.color:
		if not theme.has_color(slot, "Tree"):
			problems.append("Tree.color missing %s" % slot)
	for slot in expected.constant:
		if not theme.has_constant(slot, "Tree"):
			problems.append("Tree.constant missing %s" % slot)
	for slot in expected.font:
		if not theme.has_font(slot, "Tree"):
			problems.append("Tree.font missing %s" % slot)
	for slot in expected.font_size:
		if not theme.has_font_size(slot, "Tree"):
			problems.append("Tree.font_size missing %s" % slot)
	for slot in expected.icon:
		if not theme.has_icon(slot, "Tree"):
			problems.append("Tree.icon missing %s" % slot)


func _assert_tree_cursor_overlays(theme: Theme, problems: Array[String]) -> void:
	for slot in ["cursor", "cursor_unfocused", "hovered", "hovered_dimmed"]:
		var sb := theme.get_stylebox(slot, "Tree") as StyleBoxFlat
		if sb == null:
			problems.append("Tree.%s is not a StyleBoxFlat" % slot)
			continue
		if sb.bg_color.a >= 1.0:
			problems.append("Tree.%s overlay is opaque (alpha=%s)" % [slot, str(sb.bg_color.a)])


func _assert_tree_focus_discipline(theme: Theme, problems: Array[String]) -> void:
	var focus := theme.get_stylebox("focus", "Tree") as StyleBoxFlat
	if focus == null:
		problems.append("Tree.focus is not a StyleBoxFlat")
	else:
		if focus.bg_color.a != 0.0:
			problems.append("Tree.focus background is not transparent")
		if focus.border_width_left <= 0 or focus.border_width_top <= 0:
			problems.append("Tree.focus has no outer border ring")
	var binding: Dictionary = _script_constants().get("BINDING_TABLE", {})
	var tree_style: Dictionary = binding.get("Tree", {}).get("stylebox", {})
	for invalid in ["pressed_focus", "checked_focus", "hover_pressed", "hovered_focus", "selected_hover_focus"]:
		if tree_style.has(invalid):
			problems.append("Tree.stylebox has invented combo focus slot %s" % invalid)


func _assert_tree_line_colors(theme: NeoCadeTheme, problems: Array[String]) -> void:
	var base: Color = theme.base_color
	var accent: Color = theme.accent_color
	var presets := _direction_presets_for_theme(theme)
	var spread_factor: float = float(presets.get("spread_factor", 1.0))
	var elevate_target := Color.BLACK if theme.is_light else Color.WHITE
	var expected_outline := _mix_color(base, elevate_target, 0.24 * spread_factor)
	var outline_slots := [
		"guide_color",
		"relationship_line_color",
		"parent_hl_line_color",
		"children_hl_line_color",
	]
	for slot in outline_slots:
		if not _color_close(theme.get_color(slot, "Tree"), expected_outline):
			problems.append("Tree.%s does not match derived outline role" % slot)
	if not _color_close(theme.get_color("drop_position_color", "Tree"), accent):
		problems.append("Tree.drop_position_color does not match role_primary/accent")


func _assert_tree_icon_recipes(problems: Array[String]) -> void:
	var binding: Dictionary = _script_constants().get("BINDING_TABLE", {})
	var tree_icons: Dictionary = binding.get("Tree", {}).get("icon", {})
	for slot in EXPECTED_TREE_ICON_RECIPES.keys():
		var expected_icon: String = EXPECTED_TREE_ICON_RECIPES[slot]
		var recipe: Dictionary = tree_icons.get(slot, {})
		var actual_icon: String = recipe.get("icon", "")
		if actual_icon != expected_icon:
			problems.append("Tree.icon recipe %s expected %s got %s" % [slot, expected_icon, actual_icon])


func assert_itemlist_stage() -> void:
	var group := "assert_itemlist_stage"
	var loaded := ResourceLoader.load(PULSE_PATH, "", ResourceLoader.CACHE_MODE_IGNORE)
	if loaded == null or not (loaded is NeoCadeTheme):
		_group_fail(group, "Pulse direction did not load as NeoCadeTheme")
		return
	var theme: NeoCadeTheme = loaded
	var problems: Array[String] = []
	_assert_itemlist_slots_present(theme, problems)
	_assert_itemlist_cursor_overlays(theme, problems)
	_assert_itemlist_focus_discipline(theme, problems)
	_assert_itemlist_selected_vocabulary(theme, problems)
	_assert_itemlist_line_colors(theme, problems)
	_assert_itemlist_icon_recipes(problems)
	if problems.is_empty():
		_group_ok(group, "ItemList official slots, selection vocabulary, cursor overlays, focus, and scroll hint are covered")
	else:
		_group_fail(group, "; ".join(problems))


func _assert_itemlist_slots_present(theme: Theme, problems: Array[String]) -> void:
	var expected: Dictionary = EXPECTED_SLOT_FREEZE.ItemList
	for slot in expected.stylebox:
		if not theme.has_stylebox(slot, "ItemList"):
			problems.append("ItemList.stylebox missing %s" % slot)
	for slot in expected.color:
		if not theme.has_color(slot, "ItemList"):
			problems.append("ItemList.color missing %s" % slot)
	for slot in expected.constant:
		if not theme.has_constant(slot, "ItemList"):
			problems.append("ItemList.constant missing %s" % slot)
	for slot in expected.font:
		if not theme.has_font(slot, "ItemList"):
			problems.append("ItemList.font missing %s" % slot)
	for slot in expected.font_size:
		if not theme.has_font_size(slot, "ItemList"):
			problems.append("ItemList.font_size missing %s" % slot)
	for slot in expected.icon:
		if not theme.has_icon(slot, "ItemList"):
			problems.append("ItemList.icon missing %s" % slot)


func _assert_itemlist_cursor_overlays(theme: Theme, problems: Array[String]) -> void:
	for slot in ["cursor", "cursor_unfocused"]:
		var sb := theme.get_stylebox(slot, "ItemList") as StyleBoxFlat
		if sb == null:
			problems.append("ItemList.%s is not a StyleBoxFlat" % slot)
			continue
		if sb.bg_color.a >= 1.0:
			problems.append("ItemList.%s overlay is opaque (alpha=%s)" % [slot, str(sb.bg_color.a)])


func _assert_itemlist_focus_discipline(theme: Theme, problems: Array[String]) -> void:
	var focus := theme.get_stylebox("focus", "ItemList") as StyleBoxFlat
	if focus == null:
		problems.append("ItemList.focus is not a StyleBoxFlat")
	else:
		if focus.bg_color.a != 0.0:
			problems.append("ItemList.focus background is not transparent")
		if focus.border_width_left <= 0 or focus.border_width_top <= 0:
			problems.append("ItemList.focus has no outer border ring")
	var binding: Dictionary = _script_constants().get("BINDING_TABLE", {})
	var itemlist_style: Dictionary = binding.get("ItemList", {}).get("stylebox", {})
	for invalid in ["pressed_focus", "checked_focus", "hover_pressed", "hovered_focus", "selected_hover_focus"]:
		if itemlist_style.has(invalid):
			problems.append("ItemList.stylebox has invented combo focus slot %s" % invalid)


func _assert_itemlist_selected_vocabulary(theme: Theme, problems: Array[String]) -> void:
	var binding: Dictionary = _script_constants().get("BINDING_TABLE", {})
	var itemlist_style: Dictionary = binding.get("ItemList", {}).get("stylebox", {})
	var tree_style: Dictionary = binding.get("Tree", {}).get("stylebox", {})
	for slot in ["selected", "selected_focus", "hovered_selected", "hovered_selected_focus"]:
		var item_recipe: Dictionary = itemlist_style.get(slot, {})
		var tree_recipe: Dictionary = tree_style.get(slot, {})
		if item_recipe.get("role", "") != "accent_offset":
			problems.append("ItemList.%s does not use accent_offset selected-row role" % slot)
		if tree_recipe.get("role", "") != "accent_offset":
			problems.append("Tree.%s no longer exposes the selected-row vocabulary baseline" % slot)
		var item_sb := theme.get_stylebox(slot, "ItemList") as StyleBoxFlat
		var tree_sb := theme.get_stylebox(slot, "Tree") as StyleBoxFlat
		if item_sb == null or tree_sb == null:
			problems.append("ItemList/Tree %s selected stylebox is missing or wrong type" % slot)
			continue
		if not _color_close(item_sb.bg_color, tree_sb.bg_color):
			problems.append("ItemList.%s bg does not match Tree selected-row vocabulary" % slot)


func _assert_itemlist_line_colors(theme: NeoCadeTheme, problems: Array[String]) -> void:
	var base: Color = theme.base_color
	var presets := _direction_presets_for_theme(theme)
	var spread_factor: float = float(presets.get("spread_factor", 1.0))
	var elevate_target := Color.BLACK if theme.is_light else Color.WHITE
	var expected_outline := _mix_color(base, elevate_target, 0.24 * spread_factor)
	for slot in ["guide_color", "font_outline_color"]:
		if not _color_close(theme.get_color(slot, "ItemList"), expected_outline):
			problems.append("ItemList.%s does not match derived outline role" % slot)
	if theme.get_color("scroll_hint_color", "ItemList").a >= 1.0:
		problems.append("ItemList.scroll_hint_color should remain an alpha-bearing affordance")


func _assert_itemlist_icon_recipes(problems: Array[String]) -> void:
	var binding: Dictionary = _script_constants().get("BINDING_TABLE", {})
	var itemlist_icons: Dictionary = binding.get("ItemList", {}).get("icon", {})
	for slot in EXPECTED_ITEMLIST_ICON_RECIPES.keys():
		var expected_icon: String = EXPECTED_ITEMLIST_ICON_RECIPES[slot]
		var recipe: Dictionary = itemlist_icons.get(slot, {})
		var actual_icon: String = recipe.get("icon", "")
		if actual_icon != expected_icon:
			problems.append("ItemList.icon recipe %s expected %s got %s" % [slot, expected_icon, actual_icon])


func assert_foldable_stage() -> void:
	var group := "assert_foldable_stage"
	var loaded := ResourceLoader.load(PULSE_PATH, "", ResourceLoader.CACHE_MODE_IGNORE)
	if loaded == null or not (loaded is NeoCadeTheme):
		_group_fail(group, "Pulse direction did not load as NeoCadeTheme")
		return
	var theme: NeoCadeTheme = loaded
	var problems: Array[String] = []
	_assert_foldable_slots_present(theme, problems)
	_assert_foldable_focus_discipline(theme, problems)
	_assert_foldable_header_chrome(problems)
	_assert_foldable_stale_slots_absent(theme, problems)
	_assert_foldable_icon_recipes(problems)
	if problems.is_empty():
		_group_ok(group, "FoldableContainer official slots, section header chrome, focus, and disclosure icons are covered")
	else:
		_group_fail(group, "; ".join(problems))


func _assert_foldable_slots_present(theme: Theme, problems: Array[String]) -> void:
	var expected: Dictionary = EXPECTED_SLOT_FREEZE.FoldableContainer
	for slot in expected.stylebox:
		if not theme.has_stylebox(slot, "FoldableContainer"):
			problems.append("FoldableContainer.stylebox missing %s" % slot)
	for slot in expected.color:
		if not theme.has_color(slot, "FoldableContainer"):
			problems.append("FoldableContainer.color missing %s" % slot)
	for slot in expected.constant:
		if not theme.has_constant(slot, "FoldableContainer"):
			problems.append("FoldableContainer.constant missing %s" % slot)
	for slot in expected.font:
		if not theme.has_font(slot, "FoldableContainer"):
			problems.append("FoldableContainer.font missing %s" % slot)
	for slot in expected.font_size:
		if not theme.has_font_size(slot, "FoldableContainer"):
			problems.append("FoldableContainer.font_size missing %s" % slot)
	for slot in expected.icon:
		if not theme.has_icon(slot, "FoldableContainer"):
			problems.append("FoldableContainer.icon missing %s" % slot)


func _assert_foldable_focus_discipline(theme: Theme, problems: Array[String]) -> void:
	var focus := theme.get_stylebox("focus", "FoldableContainer") as StyleBoxFlat
	if focus == null:
		problems.append("FoldableContainer.focus is not a StyleBoxFlat")
	else:
		if focus.bg_color.a != 0.0:
			problems.append("FoldableContainer.focus background is not transparent")
		if focus.border_width_left <= 0 or focus.border_width_top <= 0:
			problems.append("FoldableContainer.focus has no outer border ring")
	var binding: Dictionary = _script_constants().get("BINDING_TABLE", {})
	var foldable_style: Dictionary = binding.get("FoldableContainer", {}).get("stylebox", {})
	for invalid in ["pressed_focus", "checked_focus", "hover_pressed", "title_focus", "title_hover"]:
		if foldable_style.has(invalid):
			problems.append("FoldableContainer.stylebox has invalid focus/title slot %s" % invalid)


func _assert_foldable_header_chrome(problems: Array[String]) -> void:
	var binding: Dictionary = _script_constants().get("BINDING_TABLE", {})
	var foldable_style: Dictionary = binding.get("FoldableContainer", {}).get("stylebox", {})
	var expected_roles := {
		"title_panel": ["surface_panel", "surface_high", "surface_overlay"],
		"title_hover_panel": ["state_hover"],
		"title_collapsed_panel": ["surface_panel", "surface_high", "surface_overlay"],
		"title_collapsed_hover_panel": ["state_hover"],
	}
	for slot in expected_roles.keys():
		var recipe: Dictionary = foldable_style.get(slot, {})
		var role: String = recipe.get("role", "")
		if not (expected_roles[slot] as Array).has(role):
			problems.append("FoldableContainer.%s role %s is not section/tab-panel chrome" % [slot, role])
		if ["role_primary", "accent_offset", "state_pressed"].has(role):
			problems.append("FoldableContainer.%s uses push-button/selected role %s" % [slot, role])


func _assert_foldable_stale_slots_absent(theme: Theme, problems: Array[String]) -> void:
	for bad in ["title_hover", "title_collapsed"]:
		if theme.has_stylebox(bad, "FoldableContainer"):
			problems.append("FoldableContainer stale stylebox %s is present" % bad)
	if theme.has_color("title_font_color", "FoldableContainer"):
		problems.append("FoldableContainer stale color title_font_color is present")


func _assert_foldable_icon_recipes(problems: Array[String]) -> void:
	var binding: Dictionary = _script_constants().get("BINDING_TABLE", {})
	var foldable_icons: Dictionary = binding.get("FoldableContainer", {}).get("icon", {})
	for slot in EXPECTED_FOLDABLE_ICON_RECIPES.keys():
		var expected_icon: String = EXPECTED_FOLDABLE_ICON_RECIPES[slot]
		var recipe: Dictionary = foldable_icons.get(slot, {})
		var actual_icon: String = recipe.get("icon", "")
		if actual_icon != expected_icon:
			problems.append("FoldableContainer.icon recipe %s expected %s got %s" % [slot, expected_icon, actual_icon])


func _assert_tab_slots_present(theme: Theme, problems: Array[String]) -> void:
	for type_name in ["TabBar", "TabContainer"]:
		var expected: Dictionary = EXPECTED_SLOT_FREEZE[type_name]
		for slot in expected.stylebox:
			if not theme.has_stylebox(slot, type_name):
				problems.append("%s.stylebox missing %s" % [type_name, slot])
		for slot in expected.color:
			if not theme.has_color(slot, type_name):
				problems.append("%s.color missing %s" % [type_name, slot])
		for slot in expected.constant:
			if not theme.has_constant(slot, type_name):
				problems.append("%s.constant missing %s" % [type_name, slot])
		for slot in expected.font:
			if not theme.has_font(slot, type_name):
				problems.append("%s.font missing %s" % [type_name, slot])
		for slot in expected.font_size:
			if not theme.has_font_size(slot, type_name):
				problems.append("%s.font_size missing %s" % [type_name, slot])
		for slot in expected.icon:
			if not theme.has_icon(slot, type_name):
				problems.append("%s.icon missing %s" % [type_name, slot])


func _assert_tab_table_owns_official_slots(problems: Array[String]) -> void:
	var binding: Dictionary = _script_constants().get("BINDING_TABLE", {})
	for type_name in ["TabBar", "TabContainer"]:
		var expected: Dictionary = EXPECTED_SLOT_FREEZE[type_name]
		var type_block: Dictionary = binding.get(type_name, {})
		for data_type in ["stylebox", "color", "constant", "font_size", "icon"]:
			var slot_block: Dictionary = type_block.get(data_type, {})
			for slot in expected.get(data_type, []):
				if not slot_block.has(slot):
					problems.append("BINDING_TABLE.%s.%s missing explicit recipe for %s" % [type_name, data_type, slot])


func _assert_tab_shared_style_recipes(problems: Array[String]) -> void:
	var binding: Dictionary = _script_constants().get("BINDING_TABLE", {})
	var tabbar_style: Dictionary = binding.get("TabBar", {}).get("stylebox", {})
	var tabcontainer_style: Dictionary = binding.get("TabContainer", {}).get("stylebox", {})
	for slot in ["tab_selected", "tab_unselected", "tab_hovered", "tab_disabled", "tab_focus"]:
		var bar_recipe: Dictionary = tabbar_style.get(slot, {})
		var container_recipe: Dictionary = tabcontainer_style.get(slot, {})
		if bar_recipe.is_empty():
			problems.append("TabBar.stylebox missing shared slot %s" % slot)
		if container_recipe.is_empty():
			problems.append("TabContainer.stylebox missing shared slot %s" % slot)
		if not bar_recipe.is_empty() and not container_recipe.is_empty() and bar_recipe != container_recipe:
			problems.append("TabBar/TabContainer %s recipes diverge" % slot)
	for overflow_slot in ["button_highlight", "button_pressed"]:
		if not tabbar_style.has(overflow_slot):
			problems.append("TabBar.stylebox missing overflow button slot %s" % overflow_slot)


func _assert_tab_shape_recipes(theme: Theme, problems: Array[String]) -> void:
	var binding: Dictionary = _script_constants().get("BINDING_TABLE", {})
	for type_name in ["TabBar", "TabContainer"]:
		var style: Dictionary = binding.get(type_name, {}).get("stylebox", {})
		var selected_recipe: Dictionary = style.get("tab_selected", {})
		if str(selected_recipe.get("radius", "")) != "shape.tab_radius":
			problems.append("%s.tab_selected does not read shape.tab_radius" % type_name)
		if str(selected_recipe.get("raised_intensity", "")) != "shape.raised_lifts.selected_tab":
			problems.append("%s.tab_selected does not read shape.raised_lifts.selected_tab" % type_name)
		if str(selected_recipe.get("corner_profile", "")) != "tab_connected":
			problems.append("%s.tab_selected is not marked as attached to the content panel" % type_name)
		var unselected_recipe: Dictionary = style.get("tab_unselected", {})
		if str(unselected_recipe.get("radius", "")) != "shape.tab_radius":
			problems.append("%s.tab_unselected does not read shape.tab_radius" % type_name)
		if str(unselected_recipe.get("raised_intensity", "")) != "shape.raised_lifts.unselected_tab":
			problems.append("%s.tab_unselected does not read shape.raised_lifts.unselected_tab" % type_name)
		var selected_sb := theme.get_stylebox("tab_selected", type_name) as StyleBoxFlat
		if selected_sb == null:
			problems.append("%s.tab_selected is not a StyleBoxFlat" % type_name)
		else:
			if selected_sb.corner_radius_top_left <= 0 and int(theme.corner_radius) > 0:
				problems.append("%s.tab_selected did not resolve top tab radius" % type_name)
			if selected_sb.corner_radius_bottom_left != 0 or selected_sb.corner_radius_bottom_right != 0:
				problems.append("%s.tab_selected bottom corners should be zero to read attached" % type_name)
	var container_panel := theme.get_stylebox("panel", "TabContainer") as StyleBoxFlat
	var container_selected := theme.get_stylebox("tab_selected", "TabContainer") as StyleBoxFlat
	if container_panel != null and container_selected != null:
		if not _color_close(container_panel.bg_color, container_selected.bg_color):
			problems.append("TabContainer.tab_selected bg does not match TabContainer.panel bg")


func _assert_tab_focus_discipline(theme: Theme, problems: Array[String]) -> void:
	for type_name in ["TabBar", "TabContainer"]:
		var focus := theme.get_stylebox("tab_focus", type_name) as StyleBoxFlat
		if focus == null:
			problems.append("%s.tab_focus is not a StyleBoxFlat" % type_name)
		else:
			if focus.bg_color.a != 0.0:
				problems.append("%s.tab_focus background is not transparent" % type_name)
			if focus.border_width_left <= 0 or focus.border_width_top <= 0:
				problems.append("%s.tab_focus has no outer border ring" % type_name)
		var style: Dictionary = _script_constants().get("BINDING_TABLE", {}).get(type_name, {}).get("stylebox", {})
		for invalid in ["pressed_focus", "checked_focus", "hover_pressed", "tab_selected_focus", "tab_hovered_focus"]:
			if style.has(invalid):
				problems.append("%s.stylebox has invented tab focus slot %s" % [type_name, invalid])


func _assert_tab_stale_slots_absent(theme: Theme, problems: Array[String]) -> void:
	for type_name in ["TabBar", "TabContainer"]:
		if theme.has_constant("tab_separation", type_name):
			problems.append("%s stale constant tab_separation is present" % type_name)
		var constants_block: Dictionary = _script_constants().get("BINDING_TABLE", {}).get(type_name, {}).get("constant", {})
		if constants_block.has("tab_separation"):
			problems.append("%s.constant recipe still binds tab_separation" % type_name)


func _assert_tab_icon_recipes(problems: Array[String]) -> void:
	var binding: Dictionary = _script_constants().get("BINDING_TABLE", {})
	for type_name in EXPECTED_TAB_ICON_RECIPES.keys():
		var icon_block: Dictionary = binding.get(type_name, {}).get("icon", {})
		var expected: Dictionary = EXPECTED_TAB_ICON_RECIPES[type_name]
		for slot in expected.keys():
			var expected_icon: String = expected[slot]
			var recipe: Dictionary = icon_block.get(slot, {})
			var actual_icon: String = recipe.get("icon", "")
			if actual_icon != expected_icon:
				problems.append("%s.icon recipe %s expected %s got %s" % [type_name, slot, expected_icon, actual_icon])


func _assert_range_slots_present(theme: Theme, problems: Array[String]) -> void:
	for type_name in ["ProgressBar", "HSlider", "VSlider", "HScrollBar", "VScrollBar"]:
		var expected: Dictionary = EXPECTED_SLOT_FREEZE[type_name]
		for slot in expected.get("stylebox", []):
			if not theme.has_stylebox(slot, type_name):
				problems.append("%s.stylebox missing %s" % [type_name, slot])
		for slot in expected.get("color", []):
			if not theme.has_color(slot, type_name):
				problems.append("%s.color missing %s" % [type_name, slot])
		for slot in expected.get("constant", []):
			if not theme.has_constant(slot, type_name):
				problems.append("%s.constant missing %s" % [type_name, slot])
		for slot in expected.get("font", []):
			if not theme.has_font(slot, type_name):
				problems.append("%s.font missing %s" % [type_name, slot])
		for slot in expected.get("font_size", []):
			if not theme.has_font_size(slot, type_name):
				problems.append("%s.font_size missing %s" % [type_name, slot])
		for slot in expected.get("icon", []):
			if not theme.has_icon(slot, type_name):
				problems.append("%s.icon missing %s" % [type_name, slot])
	if not theme.has_icon("up", "SpinBox") or not theme.has_icon("down", "SpinBox"):
		problems.append("SpinBox Phase 5 range-control carry-forward icons missing")


func _assert_range_table_owns_official_slots(problems: Array[String]) -> void:
	var binding: Dictionary = _script_constants().get("BINDING_TABLE", {})
	for type_name in ["ProgressBar", "HSlider", "VSlider", "HScrollBar", "VScrollBar"]:
		var expected: Dictionary = EXPECTED_SLOT_FREEZE[type_name]
		var type_block: Dictionary = binding.get(type_name, {})
		for data_type in ["stylebox", "color", "constant", "font_size", "icon"]:
			var slot_block: Dictionary = type_block.get(data_type, {})
			for slot in expected.get(data_type, []):
				if not slot_block.has(slot):
					problems.append("BINDING_TABLE.%s.%s missing explicit recipe for %s" % [type_name, data_type, slot])


func _assert_progressbar_chrome(theme: NeoCadeTheme, problems: Array[String]) -> void:
	var binding: Dictionary = _script_constants().get("BINDING_TABLE", {})
	var pb: Dictionary = binding.get("ProgressBar", {})
	if pb.get("stylebox", {}).get("fill", {}).get("role", "") != "role_primary":
		problems.append("ProgressBar.fill must use role_primary")
	if pb.get("stylebox", {}).get("background", {}).get("role", "") != "surface_low":
		problems.append("ProgressBar.background must use surface_low")
	if not pb.get("color", {}).has("font_outline_color"):
		problems.append("ProgressBar.color missing font_outline_color recipe")
	if not pb.get("constant", {}).has("outline_size"):
		problems.append("ProgressBar.constant missing outline_size recipe")
	if not pb.get("font_size", {}).has("font_size"):
		problems.append("ProgressBar.font_size missing font_size recipe")
	if not theme.has_font("font", "ProgressBar"):
		problems.append("ProgressBar.font not set explicitly")
	var fill := theme.get_stylebox("fill", "ProgressBar") as StyleBoxFlat
	if fill != null and not _color_close(fill.bg_color, theme.accent_color):
		problems.append("ProgressBar.fill bg does not match role_primary/accent")
	var background := theme.get_stylebox("background", "ProgressBar") as StyleBoxFlat
	if background != null:
		var presets := _direction_presets_for_theme(theme)
		var spread_factor: float = float(presets.get("spread_factor", 1.0))
		var expected_low := _mix_color(theme.base_color, Color.BLACK, 0.18 * spread_factor)
		if not _color_close(background.bg_color, expected_low):
			problems.append("ProgressBar.background bg does not match surface_low")


func _assert_slider_mirroring(problems: Array[String]) -> void:
	var binding: Dictionary = _script_constants().get("BINDING_TABLE", {})
	for data_type in ["stylebox", "constant", "icon"]:
		var h_block: Dictionary = binding.get("HSlider", {}).get(data_type, {})
		var v_block: Dictionary = binding.get("VSlider", {}).get(data_type, {})
		if h_block != v_block:
			problems.append("HSlider/VSlider %s recipes diverge" % data_type)
	for data_type in ["stylebox", "icon"]:
		var h_scroll: Dictionary = binding.get("HScrollBar", {}).get(data_type, {})
		var v_scroll: Dictionary = binding.get("VScrollBar", {}).get(data_type, {})
		if data_type == "stylebox" and h_scroll != v_scroll:
			problems.append("HScrollBar/VScrollBar stylebox recipes diverge")
		if data_type == "icon" and _sorted_strings(h_scroll.keys()) != _sorted_strings(v_scroll.keys()):
			problems.append("HScrollBar/VScrollBar official icon slot sets diverge")


func _assert_slider_icon_recipes(problems: Array[String]) -> void:
	var binding: Dictionary = _script_constants().get("BINDING_TABLE", {})
	for type_name in EXPECTED_SLIDER_ICON_RECIPES.keys():
		var icon_block: Dictionary = binding.get(type_name, {}).get("icon", {})
		var expected: Dictionary = EXPECTED_SLIDER_ICON_RECIPES[type_name]
		if _sorted_strings(icon_block.keys()) != _sorted_strings(expected.keys()):
			problems.append("%s icon slots are not exactly official slider slots" % type_name)
		for slot in expected.keys():
			var actual_icon: String = icon_block.get(slot, {}).get("icon", "")
			if actual_icon != expected[slot]:
				problems.append("%s.icon recipe %s expected %s got %s" % [type_name, slot, expected[slot], actual_icon])


func _assert_scrollbar_focus_discipline(theme: Theme, problems: Array[String]) -> void:
	for type_name in ["HScrollBar", "VScrollBar"]:
		var focus := theme.get_stylebox("scroll_focus", type_name) as StyleBoxFlat
		if focus == null:
			problems.append("%s.scroll_focus is not a StyleBoxFlat" % type_name)
			continue
		if focus.bg_color.a != 0.0:
			problems.append("%s.scroll_focus background is not transparent" % type_name)
		if focus.border_width_left <= 0 or focus.border_width_top <= 0:
			problems.append("%s.scroll_focus has no outer border ring" % type_name)


func _assert_scrollbar_icon_recipes(problems: Array[String]) -> void:
	var binding: Dictionary = _script_constants().get("BINDING_TABLE", {})
	for type_name in EXPECTED_SCROLLBAR_ICON_RECIPES.keys():
		var icon_block: Dictionary = binding.get(type_name, {}).get("icon", {})
		var expected: Dictionary = EXPECTED_SCROLLBAR_ICON_RECIPES[type_name]
		if _sorted_strings(icon_block.keys()) != _sorted_strings(expected.keys()):
			problems.append("%s icon slots are not exactly the six official increment/decrement slots" % type_name)
		for slot in icon_block.keys():
			if String(slot).find("grabber") != -1:
				problems.append("%s invented unsupported ScrollBar grabber icon slot %s" % [type_name, slot])
		for slot in expected.keys():
			var actual_icon: String = icon_block.get(slot, {}).get("icon", "")
			if actual_icon != expected[slot]:
				problems.append("%s.icon recipe %s expected %s got %s" % [type_name, slot, expected[slot], actual_icon])


func _assert_container_slots_present(theme: Theme, problems: Array[String]) -> void:
	for type_name in ["ScrollContainer", "SplitContainer", "HSplitContainer", "VSplitContainer",
			"MarginContainer", "HBoxContainer", "VBoxContainer", "FlowContainer", "GridContainer",
			"HSeparator", "VSeparator"]:
		var expected: Dictionary = EXPECTED_SLOT_FREEZE[type_name]
		for slot in expected.get("stylebox", []):
			if not theme.has_stylebox(slot, type_name):
				problems.append("%s.stylebox missing %s" % [type_name, slot])
		for slot in expected.get("color", []):
			if not theme.has_color(slot, type_name):
				problems.append("%s.color missing %s" % [type_name, slot])
		for slot in expected.get("constant", []):
			if not theme.has_constant(slot, type_name):
				problems.append("%s.constant missing %s" % [type_name, slot])
		for slot in expected.get("icon", []):
			if not theme.has_icon(slot, type_name):
				problems.append("%s.icon missing %s" % [type_name, slot])


func _assert_container_table_owns_official_slots(problems: Array[String]) -> void:
	var binding: Dictionary = _script_constants().get("BINDING_TABLE", {})
	for type_name in ["ScrollContainer", "SplitContainer", "HSplitContainer", "VSplitContainer",
			"MarginContainer", "HBoxContainer", "VBoxContainer", "FlowContainer", "GridContainer",
			"HSeparator", "VSeparator"]:
		var expected: Dictionary = EXPECTED_SLOT_FREEZE[type_name]
		var type_block: Dictionary = binding.get(type_name, {})
		for data_type in ["stylebox", "color", "constant", "icon"]:
			var slot_block: Dictionary = type_block.get(data_type, {})
			for slot in expected.get(data_type, []):
				if not slot_block.has(slot):
					problems.append("BINDING_TABLE.%s.%s missing explicit recipe for %s" % [type_name, data_type, slot])


func _assert_container_focus_and_chrome(theme: Theme, problems: Array[String]) -> void:
	var binding: Dictionary = _script_constants().get("BINDING_TABLE", {})
	var focus := theme.get_stylebox("focus", "ScrollContainer") as StyleBoxFlat
	if focus == null:
		problems.append("ScrollContainer.focus is not a StyleBoxFlat")
	else:
		if focus.bg_color.a != 0.0:
			problems.append("ScrollContainer.focus background is not transparent")
		if focus.border_width_left <= 0 or focus.border_width_top <= 0:
			problems.append("ScrollContainer.focus has no outer border ring")
	var scroll_panel_recipe: Dictionary = binding.get("ScrollContainer", {}).get("stylebox", {}).get("panel", {})
	if not ["surface_base", "surface_low"].has(scroll_panel_recipe.get("role", "")):
		problems.append("ScrollContainer.panel should be quiet overflow chrome, got role %s" % scroll_panel_recipe.get("role", ""))
	if int(scroll_panel_recipe.get("raised_intensity", 0)) != 0:
		problems.append("ScrollContainer.panel must not turn nested scroll areas into raised cards")
	for type_name in ["SplitContainer", "HSplitContainer", "VSplitContainer"]:
		var recipe: Dictionary = binding.get(type_name, {}).get("stylebox", {}).get("split_bar_background", {})
		if recipe.is_empty():
			problems.append("%s.split_bar_background recipe missing" % type_name)
			continue
		if ["role_primary", "accent_offset", "state_pressed"].has(recipe.get("role", "")):
			problems.append("%s.split_bar_background uses decorative/selected role %s" % [type_name, recipe.get("role", "")])
	for type_name in ["HSeparator", "VSeparator"]:
		var separator_recipe: Dictionary = binding.get(type_name, {}).get("stylebox", {}).get("separator", {})
		if separator_recipe.get("role", "") != "outline_color":
			problems.append("%s.separator should use outline_color role" % type_name)
		if int(separator_recipe.get("raised_intensity", 0)) != 0:
			problems.append("%s.separator must not be raised" % type_name)


func _assert_container_icon_recipes(problems: Array[String]) -> void:
	var binding: Dictionary = _script_constants().get("BINDING_TABLE", {})
	for type_name in EXPECTED_CONTAINER_ICON_RECIPES.keys():
		var icon_block: Dictionary = binding.get(type_name, {}).get("icon", {})
		var expected: Dictionary = EXPECTED_CONTAINER_ICON_RECIPES[type_name]
		if _sorted_strings(icon_block.keys()) != _sorted_strings(expected.keys()):
			problems.append("%s icon slots do not match official container slots" % type_name)
		for slot in expected.keys():
			var actual_icon: String = icon_block.get(slot, {}).get("icon", "")
			if actual_icon != expected[slot]:
				problems.append("%s.icon recipe %s expected %s got %s" % [type_name, slot, expected[slot], actual_icon])


func _assert_range_container_stale_slots_absent(problems: Array[String]) -> void:
	var constants := _script_constants()
	var binding: Dictionary = constants.get("BINDING_TABLE", {})
	var canonical: Dictionary = constants.get("CANONICAL_SLOT_NAMES", {})
	if binding.has("CenterContainer") or canonical.has("CenterContainer"):
		problems.append("CenterContainer must remain unbound because local Godot 4.6.2 reports no theme slots")
	var scroll_constants: Dictionary = binding.get("ScrollContainer", {}).get("constant", {})
	for bad in ["scrollbar_h_separation", "scrollbar_v_separation"]:
		if scroll_constants.has(bad):
			problems.append("ScrollContainer.constant invents unsupported %s" % bad)
	for type_name in ["HScrollBar", "VScrollBar"]:
		var icon_block: Dictionary = binding.get(type_name, {}).get("icon", {})
		for bad in ["grabber", "grabber_highlight", "grabber_pressed", "grabber_disabled"]:
			if icon_block.has(bad):
				problems.append("%s.icon invents unsupported ScrollBar grabber icon slot %s" % [type_name, bad])


func _direction_presets_for_theme(theme: NeoCadeTheme) -> Dictionary:
	var constants := _script_constants()
	var presets: Dictionary = constants.get("DIRECTION_PRESETS", {})
	var fallback: Dictionary = constants.get("DIRECTION_PRESET_DEFAULT", {})
	var key := theme.base_color.to_html(false).to_upper()
	return presets.get(key, fallback)


func _mix_color(a: Color, b: Color, amount: float) -> Color:
	return Color(
		a.r + (b.r - a.r) * amount,
		a.g + (b.g - a.g) * amount,
		a.b + (b.b - a.b) * amount,
		1.0
	)


func _color_close(a: Color, b: Color, tolerance := 0.004) -> bool:
	return abs(a.r - b.r) <= tolerance and abs(a.g - b.g) <= tolerance and abs(a.b - b.b) <= tolerance and abs(a.a - b.a) <= tolerance


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
