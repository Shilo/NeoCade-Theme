extends Control

const THEME_OPTIONS := [
	{
		"name": "Pulse",
		"path": "res://addons/neocade_theme/pulse_neocade_theme.tres",
		"base": Color("#151A2E"),
		"accent": Color("#8BFF6A"),
	},
	{
		"name": "Slate",
		"path": "res://addons/neocade_theme/slate_neocade_theme.tres",
		"base": Color("#111820"),
		"accent": Color("#8BD3FF"),
	},
	{
		"name": "Bubble",
		"path": "res://addons/neocade_theme/bubble_neocade_theme.tres",
		"base": Color("#241326"),
		"accent": Color("#FFB3E6"),
	},
	{
		"name": "Daybreak",
		"path": "res://addons/neocade_theme/daybreak_neocade_theme.tres",
		"base": Color("#0B2420"),
		"accent": Color("#76F2D1"),
	},
	{
		"name": "Burst",
		"path": "res://addons/neocade_theme/burst_neocade_theme.tres",
		"base": Color("#20112E"),
		"accent": Color("#FFD166"),
	},
	{
		"name": "Godot Default",
		"path": "",
		"base": Color("#202124"),
		"accent": Color("#57B3FF"),
	},
]

const CONTROL_COVERAGE := [
	"Button",
	"CheckBox",
	"CheckButton",
	"OptionButton",
	"MenuButton",
	"ColorPickerButton",
	"LinkButton",
	"Label",
	"RichTextLabel",
	"LineEdit",
	"TextEdit",
	"CodeEdit",
	"SpinBox",
	"HSlider",
	"VSlider",
	"ProgressBar",
	"HScrollBar",
	"VScrollBar",
	"ItemList",
	"Tree",
	"TabBar",
	"TabContainer",
	"FoldableContainer",
	"Panel",
	"PanelContainer",
	"ScrollContainer",
	"SplitContainer",
	"MarginContainer",
	"HBoxContainer",
	"VBoxContainer",
	"FlowContainer",
	"GridContainer",
	"CenterContainer",
	"PopupPanel",
	"PopupMenu",
	"AcceptDialog",
	"ConfirmationDialog",
	"FileDialog",
	"TooltipPanel",
	"TooltipLabel",
	"Window",
	"MenuBar",
	"ColorPicker",
	"GraphEdit",
	"GraphNode",
	"GraphFrame",
]

var _active_theme: NeoCadeTheme
var _theme_index := 0
var _platform_index := 2
var _section_tabs: TabContainer
var _theme_picker: OptionButton
var _platform_picker: OptionButton
var _raised_toggle: CheckButton
var _default_badge: Label
var _accept_dialog: AcceptDialog
var _confirm_dialog: ConfirmationDialog
var _file_dialog: FileDialog
var _popup_panel: PopupPanel
var _popup_menu: PopupMenu
var _floating_panel: PanelContainer


func _ready() -> void:
	_build_showcase()
	_apply_theme_choice()


func _build_showcase() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)

	var root_margin := MarginContainer.new()
	root_margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	root_margin.add_theme_constant_override("margin_left", 18)
	root_margin.add_theme_constant_override("margin_top", 18)
	root_margin.add_theme_constant_override("margin_right", 18)
	root_margin.add_theme_constant_override("margin_bottom", 18)
	add_child(root_margin)

	var root_stack := VBoxContainer.new()
	root_stack.add_theme_constant_override("separation", 12)
	root_margin.add_child(root_stack)

	var header := _make_header()
	root_stack.add_child(header)

	_section_tabs = TabContainer.new()
	_section_tabs.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_section_tabs.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root_stack.add_child(_section_tabs)

	_add_section("Buttons", _build_buttons_section())
	_add_section("Text Inputs", _build_text_section())
	_add_section("Numbers & Range", _build_numbers_range_section())
	_add_section("Selection & Lists", _build_selection_lists_section())
	_add_section("Containers & Layout", _build_containers_layout_section())
	_add_section("Dialogs & Popups", _build_dialogs_popups_section())
	_add_section("Advanced & Graph", _build_advanced_graph_section())
	_add_section("Token Gallery", _build_token_gallery_section())
	_add_section("Coverage 37/37", _build_coverage_section())

	_build_floating_controls()
	_build_popup_nodes()


func _make_header() -> Control:
	var panel := PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 16)
	margin.add_theme_constant_override("margin_top", 14)
	margin.add_theme_constant_override("margin_right", 16)
	margin.add_theme_constant_override("margin_bottom", 14)
	panel.add_child(margin)

	var stack := VBoxContainer.new()
	stack.add_theme_constant_override("separation", 4)
	margin.add_child(stack)

	var title := Label.new()
	title.text = "NeoCade"
	title.theme_type_variation = "HeaderLarge"
	stack.add_child(title)

	var subtitle := Label.new()
	subtitle.text = "Pulse starter theme · 5 directions · flat/raised · desktop/mobile/auto"
	subtitle.theme_type_variation = "Caption"
	stack.add_child(subtitle)

	return panel


func _add_section(title: String, content: Control) -> void:
	var scroll := ScrollContainer.new()
	scroll.name = title
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 12)
	margin.add_theme_constant_override("margin_top", 12)
	margin.add_theme_constant_override("margin_right", 12)
	margin.add_theme_constant_override("margin_bottom", 72)
	margin.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(margin)
	margin.add_child(content)
	_section_tabs.add_child(scroll)


func _build_floating_controls() -> void:
	_floating_panel = PanelContainer.new()
	_floating_panel.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	_floating_panel.offset_left = -530
	_floating_panel.offset_top = 18
	_floating_panel.offset_right = -18
	_floating_panel.offset_bottom = 112
	_floating_panel.z_index = 10
	add_child(_floating_panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 14)
	margin.add_theme_constant_override("margin_top", 12)
	margin.add_theme_constant_override("margin_right", 14)
	margin.add_theme_constant_override("margin_bottom", 12)
	_floating_panel.add_child(margin)

	var stack := VBoxContainer.new()
	stack.add_theme_constant_override("separation", 8)
	margin.add_child(stack)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 10)
	stack.add_child(row)

	_theme_picker = OptionButton.new()
	_theme_picker.custom_minimum_size = Vector2(170, 44)
	for option: Dictionary in THEME_OPTIONS:
		_theme_picker.add_item(option["name"])
	_name_interactive(_theme_picker, "Theme picker")
	_theme_picker.item_selected.connect(_on_theme_selected)
	row.add_child(_theme_picker)

	_raised_toggle = CheckButton.new()
	_raised_toggle.text = "Raised"
	_raised_toggle.custom_minimum_size = Vector2(112, 44)
	_name_interactive(_raised_toggle, "Raised variation toggle")
	_raised_toggle.toggled.connect(_on_raised_toggled)
	row.add_child(_raised_toggle)

	_platform_picker = OptionButton.new()
	_platform_picker.custom_minimum_size = Vector2(144, 44)
	_platform_picker.add_item("Desktop")
	_platform_picker.add_item("Mobile")
	_platform_picker.add_item("Auto")
	_platform_picker.selected = _platform_index
	_name_interactive(_platform_picker, "Platform selector")
	_platform_picker.item_selected.connect(_on_platform_selected)
	row.add_child(_platform_picker)

	_default_badge = Label.new()
	_default_badge.theme_type_variation = "Caption"
	stack.add_child(_default_badge)


func _build_popup_nodes() -> void:
	_accept_dialog = AcceptDialog.new()
	_accept_dialog.title = "Prize Claim"
	_accept_dialog.dialog_text = "Ticket count confirmed. Reward ready for pickup."
	_name_interactive(_accept_dialog, "Accept dialog")
	add_child(_accept_dialog)

	_confirm_dialog = ConfirmationDialog.new()
	_confirm_dialog.title = "Reset Cabinet"
	_confirm_dialog.dialog_text = "Clear the selected cabinet profile and rebuild defaults?"
	_name_interactive(_confirm_dialog, "Confirmation dialog")
	add_child(_confirm_dialog)

	_file_dialog = FileDialog.new()
	_file_dialog.title = "Import Theme Snapshot"
	_file_dialog.access = FileDialog.ACCESS_FILESYSTEM
	_file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	_file_dialog.filters = PackedStringArray(["*.tres ; Godot Theme resource", "*.json ; Token snapshot"])
	_name_interactive(_file_dialog, "File dialog")
	add_child(_file_dialog)

	_popup_panel = PopupPanel.new()
	var popup_margin := MarginContainer.new()
	popup_margin.add_theme_constant_override("margin_left", 16)
	popup_margin.add_theme_constant_override("margin_top", 16)
	popup_margin.add_theme_constant_override("margin_right", 16)
	popup_margin.add_theme_constant_override("margin_bottom", 16)
	_popup_panel.add_child(popup_margin)
	var popup_stack := VBoxContainer.new()
	popup_stack.add_theme_constant_override("separation", 8)
	popup_margin.add_child(popup_stack)
	var pop_title := Label.new()
	pop_title.text = "Ticket Bonus"
	pop_title.theme_type_variation = "HeaderSmall"
	popup_stack.add_child(pop_title)
	var pop_body := RichTextLabel.new()
	pop_body.bbcode_enabled = true
	pop_body.fit_content = true
	pop_body.text = "[b]Combo streak:[/b] +25 tickets\n[color=#8BFF6A]Ready[/color] for the next round."
	popup_stack.add_child(pop_body)
	add_child(_popup_panel)

	_popup_menu = PopupMenu.new()
	_popup_menu.add_check_item("Show inactive booths", 0)
	_popup_menu.add_radio_check_item("Sort by ticket value", 1)
	_popup_menu.add_separator("Actions")
	_popup_menu.add_item("Duplicate cabinet", 2)
	var more := PopupMenu.new()
	more.name = "more"
	more.add_item("Archive booth")
	more.add_item("Export preset")
	_popup_menu.add_child(more)
	_popup_menu.add_submenu_item("More", "more")
	_name_interactive(_popup_menu, "Popup menu")
	add_child(_popup_menu)


func _build_buttons_section() -> Control:
	var grid := _new_grid(3)

	grid.add_child(_labeled_control("Primary", _make_button("Start Match", "PrimaryButton", true)))
	grid.add_child(_labeled_control("Secondary", _make_button("View Prizes", "SecondaryButton", true)))
	grid.add_child(_labeled_control("Ghost", _make_button("Queue Later", "GhostButton", true)))
	grid.add_child(_labeled_control("Danger", _make_button("Forfeit Run", "DangerButton", true)))
	grid.add_child(_labeled_control("Icon", _make_button("↻", "IconButton", true)))

	var disabled := _make_button("Disabled", "SecondaryButton", true)
	disabled.disabled = true
	grid.add_child(_labeled_control("Disabled", disabled))

	var check_box := CheckBox.new()
	check_box.text = "Prize locker synced"
	check_box.button_pressed = true
	_name_interactive(check_box, "Prize locker checkbox")
	grid.add_child(_labeled_control("CheckBox", check_box))

	var check_button := CheckButton.new()
	check_button.text = "Cabinet online"
	check_button.button_pressed = true
	_name_interactive(check_button, "Cabinet online toggle")
	grid.add_child(_labeled_control("CheckButton", check_button))

	var option := OptionButton.new()
	option.add_item("Prize Pop Plaza")
	option.add_item("Orbital Playdeck")
	option.add_item("Midnight Marquee")
	option.selected = 0
	_name_interactive(option, "Theme flavor option")
	grid.add_child(_labeled_control("OptionButton", option))

	var menu := MenuButton.new()
	menu.text = "Cabinet Menu"
	menu.get_popup().add_item("Open")
	menu.get_popup().add_item("Pin")
	menu.get_popup().add_separator()
	menu.get_popup().add_item("Archive")
	_name_interactive(menu, "Cabinet menu button")
	grid.add_child(_labeled_control("MenuButton", menu))

	var color_button := ColorPickerButton.new()
	color_button.color = Color("#8BFF6A")
	_name_interactive(color_button, "Accent color picker button")
	grid.add_child(_labeled_control("ColorPickerButton", color_button))

	var link := LinkButton.new()
	link.text = "Open release notes"
	link.uri = "https://github.com/"
	_name_interactive(link, "Release notes link")
	grid.add_child(_labeled_control("LinkButton", link))

	return grid


func _build_text_section() -> Control:
	var grid := _new_grid(2)

	var label := Label.new()
	label.text = "Arcade booth status: operational"
	grid.add_child(_labeled_control("Label", label))

	var header := Label.new()
	header.text = "Token Rally"
	header.theme_type_variation = "HeaderLarge"
	grid.add_child(_labeled_control("HeaderLarge", header))

	var rich := RichTextLabel.new()
	rich.bbcode_enabled = true
	rich.fit_content = true
	rich.custom_minimum_size = Vector2(320, 110)
	rich.text = "[b]BBCode sample[/b]\n[color=#8BFF6A]Accent text[/color], [i]synthetic italic[/i], and [code]score += combo[/code]."
	grid.add_child(_labeled_control("RichTextLabel", rich))

	var line_edit := LineEdit.new()
	line_edit.text = "Booth name: Meteor Match"
	line_edit.placeholder_text = "Cabinet nickname"
	line_edit.clear_button_enabled = true
	_name_interactive(line_edit, "Booth name input")
	grid.add_child(_labeled_control("LineEdit", line_edit))

	var text_edit := TextEdit.new()
	text_edit.text = "Daily note:\nRestock plush prizes before the evening rush."
	text_edit.custom_minimum_size = Vector2(320, 116)
	_name_interactive(text_edit, "Daily note text edit")
	grid.add_child(_labeled_control("TextEdit", text_edit))

	var code_edit := CodeEdit.new()
	code_edit.text = "func award_tickets(combo: int) -> int:\n\treturn 25 + combo * 3"
	code_edit.custom_minimum_size = Vector2(320, 116)
	_name_interactive(code_edit, "Code edit sample")
	grid.add_child(_labeled_control("CodeEdit", code_edit))

	var scripts := Label.new()
	scripts.text = "Latin · Кириллица · العربية · עברית · देवनागरी"
	scripts.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	grid.add_child(_labeled_control("Multi-script", scripts))

	return grid


func _build_numbers_range_section() -> Control:
	var grid := _new_grid(2)

	var spin := SpinBox.new()
	spin.min_value = 0
	spin.max_value = 999
	spin.value = 125
	_name_interactive(spin, "Ticket value spin box")
	grid.add_child(_labeled_control("SpinBox", spin))

	var progress := ProgressBar.new()
	progress.value = 72
	progress.show_percentage = true
	progress.custom_minimum_size = Vector2(300, 36)
	grid.add_child(_labeled_control("ProgressBar", progress))

	var hslider := HSlider.new()
	hslider.min_value = 0
	hslider.max_value = 100
	hslider.value = 64
	hslider.custom_minimum_size = Vector2(300, 36)
	_name_interactive(hslider, "Volume horizontal slider")
	grid.add_child(_labeled_control("HSlider", hslider))

	var vslider := VSlider.new()
	vslider.min_value = 0
	vslider.max_value = 100
	vslider.value = 40
	vslider.custom_minimum_size = Vector2(72, 170)
	_name_interactive(vslider, "Brightness vertical slider")
	grid.add_child(_labeled_control("VSlider", vslider))

	var hscroll := HScrollBar.new()
	hscroll.max_value = 100
	hscroll.page = 20
	hscroll.value = 35
	hscroll.custom_minimum_size = Vector2(300, 36)
	_name_interactive(hscroll, "Horizontal scroll bar")
	grid.add_child(_labeled_control("HScrollBar", hscroll))

	var vscroll := VScrollBar.new()
	vscroll.max_value = 100
	vscroll.page = 20
	vscroll.value = 35
	vscroll.custom_minimum_size = Vector2(72, 170)
	_name_interactive(vscroll, "Vertical scroll bar")
	grid.add_child(_labeled_control("VScrollBar", vscroll))

	return grid


func _build_selection_lists_section() -> Control:
	var grid := _new_grid(2)

	var item_list := ItemList.new()
	item_list.custom_minimum_size = Vector2(320, 190)
	for item in ["Meteor Match", "Prize Pop", "Stacker Alley", "Rhythm Rail", "Ticket Tornado"]:
		item_list.add_item(item)
	item_list.select(1)
	_name_interactive(item_list, "Booth item list")
	grid.add_child(_labeled_control("ItemList", item_list))

	var tree := Tree.new()
	tree.custom_minimum_size = Vector2(380, 230)
	tree.columns = 3
	tree.set_column_title(0, "Area")
	tree.set_column_title(1, "Status")
	tree.set_column_title(2, "Tickets")
	tree.column_titles_visible = true
	var root := tree.create_item()
	root.set_text(0, "NeoCade Floor")
	root.set_text(1, "Open")
	root.set_text(2, "12,450")
	for row in [
		["North Wing", "Busy", "4,820"],
		["Prize Counter", "Restock", "2,100"],
		["Rhythm Booth", "Online", "5,530"],
	]:
		var child := tree.create_item(root)
		child.set_text(0, row[0])
		child.set_text(1, row[1])
		child.set_text(2, row[2])
	_name_interactive(tree, "Arcade floor tree")
	grid.add_child(_labeled_control("Tree", tree))

	var tabs := TabBar.new()
	tabs.add_tab("Open")
	tabs.add_tab("Queued")
	tabs.add_tab("Offline")
	tabs.current_tab = 0
	_name_interactive(tabs, "Standalone tab bar")
	grid.add_child(_labeled_control("TabBar", tabs))

	var tab_container := TabContainer.new()
	tab_container.custom_minimum_size = Vector2(380, 160)
	for tab_name in ["Cabinets", "Prizes", "Staff"]:
		var page := MarginContainer.new()
		page.name = tab_name
		page.add_theme_constant_override("margin_left", 12)
		page.add_theme_constant_override("margin_top", 12)
		page.add_theme_constant_override("margin_right", 12)
		page.add_theme_constant_override("margin_bottom", 12)
		var page_label := Label.new()
		page_label.text = "%s queue synced and ready." % tab_name
		page.add_child(page_label)
		tab_container.add_child(page)
	_name_interactive(tab_container, "Tab container")
	grid.add_child(_labeled_control("TabContainer", tab_container))

	var foldable := FoldableContainer.new()
	foldable.custom_minimum_size = Vector2(320, 110)
	foldable.set("title", "FoldableContainer")
	var fold_label := Label.new()
	fold_label.text = "Hidden prizes, cabinet settings, and queue filters."
	foldable.add_child(fold_label)
	_name_interactive(foldable, "Foldable settings container")
	grid.add_child(_labeled_control("FoldableContainer", foldable))

	return grid


func _build_containers_layout_section() -> Control:
	var grid := _new_grid(2)

	var panel := Panel.new()
	panel.custom_minimum_size = Vector2(320, 110)
	var panel_label := _centered_label("Panel chrome")
	panel.add_child(panel_label)
	grid.add_child(_labeled_control("Panel", panel))

	var panel_container := PanelContainer.new()
	panel_container.custom_minimum_size = Vector2(320, 110)
	var pc_margin := MarginContainer.new()
	pc_margin.add_theme_constant_override("margin_left", 12)
	pc_margin.add_theme_constant_override("margin_top", 12)
	pc_margin.add_theme_constant_override("margin_right", 12)
	pc_margin.add_theme_constant_override("margin_bottom", 12)
	panel_container.add_child(pc_margin)
	pc_margin.add_child(_centered_label("PanelContainer with margin"))
	grid.add_child(_labeled_control("PanelContainer", panel_container))

	var split := HSplitContainer.new()
	split.custom_minimum_size = Vector2(380, 160)
	var left := TextEdit.new()
	left.text = "Left queue\nA-12\nB-08"
	_name_interactive(left, "Split container left pane")
	var right := TextEdit.new()
	right.text = "Right queue\nC-02\nD-19"
	_name_interactive(right, "Split container right pane")
	split.add_child(left)
	split.add_child(right)
	_name_interactive(split, "Split container")
	grid.add_child(_labeled_control("SplitContainer", split))

	var scroll := ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(380, 160)
	var scroll_stack := VBoxContainer.new()
	for index in range(10):
		var row := Label.new()
		row.text = "Scrollable ledger row %02d" % (index + 1)
		scroll_stack.add_child(row)
	scroll.add_child(scroll_stack)
	_name_interactive(scroll, "Scroll container")
	grid.add_child(_labeled_control("ScrollContainer", scroll))

	var flow := HFlowContainer.new()
	flow.custom_minimum_size = Vector2(320, 120)
	for chip in ["Pulse", "Slate", "Bubble", "Daybreak", "Burst"]:
		var button := _make_button(chip, "GhostButton", true)
		flow.add_child(button)
	grid.add_child(_labeled_control("FlowContainer", flow))

	var grid_container := GridContainer.new()
	grid_container.columns = 3
	for index in range(6):
		grid_container.add_child(_make_button("Pad %d" % (index + 1), "SecondaryButton", true))
	grid.add_child(_labeled_control("GridContainer", grid_container))

	var box_preview := HBoxContainer.new()
	box_preview.add_theme_constant_override("separation", 10)
	var vbox := VBoxContainer.new()
	vbox.add_child(Label.new())
	vbox.get_child(0).set("text", "VBox row A")
	vbox.add_child(Label.new())
	vbox.get_child(1).set("text", "VBox row B")
	box_preview.add_child(vbox)
	var center := CenterContainer.new()
	center.custom_minimum_size = Vector2(160, 80)
	center.add_child(_make_button("Centered", "PrimaryButton", true))
	box_preview.add_child(center)
	grid.add_child(_labeled_control("HBox/VBox/Center", box_preview))

	return grid


func _build_dialogs_popups_section() -> Control:
	var grid := _new_grid(3)

	var open_accept := _make_button("AcceptDialog", "PrimaryButton", true)
	open_accept.pressed.connect(func() -> void: _accept_dialog.popup_centered(Vector2i(420, 180)))
	grid.add_child(_labeled_control("AcceptDialog", open_accept))

	var open_confirm := _make_button("ConfirmationDialog", "SecondaryButton", true)
	open_confirm.pressed.connect(func() -> void: _confirm_dialog.popup_centered(Vector2i(460, 190)))
	grid.add_child(_labeled_control("ConfirmationDialog", open_confirm))

	var open_file := _make_button("FileDialog", "GhostButton", true)
	open_file.pressed.connect(func() -> void: _file_dialog.popup_centered(Vector2i(720, 500)))
	grid.add_child(_labeled_control("FileDialog", open_file))

	var open_popup := _make_button("PopupPanel", "SecondaryButton", true)
	open_popup.pressed.connect(_show_popup_panel)
	grid.add_child(_labeled_control("PopupPanel", open_popup))

	var open_menu := _make_button("PopupMenu", "SecondaryButton", true)
	open_menu.pressed.connect(_show_popup_menu)
	grid.add_child(_labeled_control("PopupMenu", open_menu))

	var menu_bar := MenuBar.new()
	menu_bar.custom_minimum_size = Vector2(320, 44)
	var file_menu := PopupMenu.new()
	file_menu.name = "File"
	file_menu.add_item("New snapshot")
	file_menu.add_item("Save snapshot")
	menu_bar.add_child(file_menu)
	var cabinet_menu := PopupMenu.new()
	cabinet_menu.name = "Cabinet"
	cabinet_menu.add_check_item("Live updates")
	cabinet_menu.add_item("Rebuild cache")
	menu_bar.add_child(cabinet_menu)
	_name_interactive(menu_bar, "Menu bar")
	grid.add_child(_labeled_control("MenuBar", menu_bar))

	var tooltip_pair := HBoxContainer.new()
	tooltip_pair.add_theme_constant_override("separation", 8)
	var tooltip_button := _make_button("Hover Target", "PrimaryButton", true)
	tooltip_button.tooltip_text = "TooltipPanel + TooltipLabel styled by NeoCade"
	tooltip_pair.add_child(tooltip_button)
	var tooltip_label := Label.new()
	tooltip_label.text = "TooltipPanel / TooltipLabel"
	tooltip_pair.add_child(tooltip_label)
	grid.add_child(_labeled_control("Tooltip", tooltip_pair))

	var window_button := _make_button("Window", "SecondaryButton", true)
	window_button.pressed.connect(_show_window_sample)
	grid.add_child(_labeled_control("Window", window_button))

	return grid


func _build_advanced_graph_section() -> Control:
	var grid := _new_grid(2)

	var color_picker := ColorPicker.new()
	color_picker.custom_minimum_size = Vector2(420, 360)
	color_picker.color = Color("#8BFF6A")
	_name_interactive(color_picker, "Color picker")
	grid.add_child(_labeled_control("ColorPicker", color_picker))

	var graph := GraphEdit.new()
	graph.custom_minimum_size = Vector2(560, 360)
	_name_interactive(graph, "Graph edit")

	var frame := GraphFrame.new()
	frame.title = "Arcade Flow"
	frame.position_offset = Vector2(24, 18)
	frame.size = Vector2(500, 290)
	graph.add_child(frame)

	var node_a := _make_graph_node("Entry Gate", Vector2(56, 56), ["Scan pass", "Route player"])
	var node_b := _make_graph_node("Ticket Booth", Vector2(300, 150), ["Award", "Receipt"])
	graph.add_child(node_a)
	graph.add_child(node_b)
	grid.add_child(_labeled_control("GraphEdit / GraphNode / GraphFrame", graph))

	return grid


func _build_token_gallery_section() -> Control:
	var stack := VBoxContainer.new()
	stack.add_theme_constant_override("separation", 16)

	var current: Dictionary = THEME_OPTIONS[_theme_index]
	var palette_grid := _new_grid(3)
	palette_grid.add_child(_swatch("base_color", current["base"]))
	palette_grid.add_child(_swatch("accent_color", current["accent"]))
	palette_grid.add_child(_swatch("success", Color("#5CC971")))
	palette_grid.add_child(_swatch("warning", Color("#FFD166")))
	palette_grid.add_child(_swatch("danger", Color("#FF6E6E")))
	palette_grid.add_child(_swatch("info", Color("#5FE3FF")))
	stack.add_child(palette_grid)

	var type_grid := _new_grid(2)
	for variation in ["HeaderLarge", "HeaderMedium", "HeaderSmall", "Caption", "Kicker", "CodeLabel"]:
		var sample := Label.new()
		sample.text = "%s · The quick arcade lobby" % variation
		sample.theme_type_variation = variation
		type_grid.add_child(_labeled_control(variation, sample))
	stack.add_child(type_grid)

	var radius_row := HBoxContainer.new()
	radius_row.add_theme_constant_override("separation", 12)
	for radius in [0, 4, 8, 12, 18, 26]:
		var panel := PanelContainer.new()
		panel.custom_minimum_size = Vector2(86, 56)
		var label := _centered_label("%dpx" % radius)
		panel.add_child(label)
		radius_row.add_child(panel)
	stack.add_child(_labeled_control("Radius Scale", radius_row))

	return stack


func _build_coverage_section() -> Control:
	var stack := VBoxContainer.new()
	stack.add_theme_constant_override("separation", 12)

	var banner := PanelContainer.new()
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 16)
	margin.add_theme_constant_override("margin_top", 14)
	margin.add_theme_constant_override("margin_right", 16)
	margin.add_theme_constant_override("margin_bottom", 14)
	banner.add_child(margin)
	var title := Label.new()
	title.text = "37/37 Controls themed ✓"
	title.theme_type_variation = "HeaderMedium"
	margin.add_child(title)
	stack.add_child(banner)

	var grid := GridContainer.new()
	grid.columns = 4
	grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	for control_name in CONTROL_COVERAGE:
		var label := Label.new()
		label.text = "✓ %s" % control_name
		label.theme_type_variation = "Caption"
		grid.add_child(label)
	stack.add_child(grid)

	var note := RichTextLabel.new()
	note.bbcode_enabled = true
	note.fit_content = true
	note.text = "[b]Coverage strip[/b] mirrors the Phase 7 scorecard plus additive popup, graph, and tooltip theme types. Runtime QA in Phase 10 validates entries against the source-dive enumeration."
	stack.add_child(note)

	return stack


func _make_graph_node(title: String, offset: Vector2, lines: Array[String]) -> GraphNode:
	var node := GraphNode.new()
	node.title = title
	node.position_offset = offset
	node.size = Vector2(180, 116)
	for line in lines:
		var label := Label.new()
		label.text = line
		node.add_child(label)
	return node


func _make_button(text: String, variation: String = "", interactive := false) -> Button:
	var button := Button.new()
	button.text = text
	if variation != "":
		button.theme_type_variation = variation
	if interactive:
		_name_interactive(button, "%s button" % text)
	return button


func _new_grid(columns: int) -> GridContainer:
	var grid := GridContainer.new()
	grid.columns = columns
	grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	grid.add_theme_constant_override("h_separation", 14)
	grid.add_theme_constant_override("v_separation", 14)
	return grid


func _labeled_control(label_text: String, control: Control) -> Control:
	var panel := PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 12)
	margin.add_theme_constant_override("margin_top", 12)
	margin.add_theme_constant_override("margin_right", 12)
	margin.add_theme_constant_override("margin_bottom", 12)
	panel.add_child(margin)

	var stack := VBoxContainer.new()
	stack.add_theme_constant_override("separation", 8)
	margin.add_child(stack)

	var label := Label.new()
	label.text = label_text
	label.theme_type_variation = "Kicker"
	stack.add_child(label)

	control.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	stack.add_child(control)
	return panel


func _centered_label(text: String) -> Label:
	var label := Label.new()
	label.text = text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.set_anchors_preset(Control.PRESET_FULL_RECT)
	return label


func _swatch(label_text: String, color: Color) -> Control:
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(220, 92)
	var sb := StyleBoxFlat.new()
	sb.bg_color = color
	sb.corner_radius_top_left = 10
	sb.corner_radius_top_right = 10
	sb.corner_radius_bottom_left = 10
	sb.corner_radius_bottom_right = 10
	panel.add_theme_stylebox_override("panel", sb)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 12)
	margin.add_theme_constant_override("margin_top", 12)
	margin.add_theme_constant_override("margin_right", 12)
	margin.add_theme_constant_override("margin_bottom", 12)
	panel.add_child(margin)

	var stack := VBoxContainer.new()
	margin.add_child(stack)

	var name_label := Label.new()
	name_label.text = label_text
	name_label.theme_type_variation = "Kicker"
	stack.add_child(name_label)

	var hex_label := Label.new()
	hex_label.text = color.to_html(false).to_upper()
	hex_label.theme_type_variation = "HeaderSmall"
	stack.add_child(hex_label)

	return panel


func _name_interactive(node: Node, readable_name: String) -> void:
	node.set("accessibility_name", readable_name)
	if node is Control:
		(node as Control).tooltip_text = readable_name


func _on_theme_selected(index: int) -> void:
	_theme_index = index
	_apply_theme_choice()


func _on_raised_toggled(enabled: bool) -> void:
	if _active_theme != null:
		_active_theme.raised = enabled
		theme = _active_theme


func _on_platform_selected(index: int) -> void:
	_platform_index = index
	if _active_theme != null:
		_active_theme.platform = _platform_from_index(index)
		theme = _active_theme


func _apply_theme_choice() -> void:
	var option: Dictionary = THEME_OPTIONS[_theme_index]
	if option["path"] == "":
		_active_theme = null
		theme = null
		if _default_badge != null:
			_default_badge.text = "Godot default comparison mode"
		return

	var loaded := load(option["path"]) as NeoCadeTheme
	_active_theme = loaded.duplicate(true) as NeoCadeTheme
	_active_theme.raised = _raised_toggle.button_pressed if _raised_toggle != null else false
	_active_theme.platform = _platform_from_index(_platform_index)
	theme = _active_theme
	if _default_badge != null:
		_default_badge.text = "%s · %s · %s" % [option["name"], _platform_name(_active_theme.platform), "raised" if _active_theme.raised else "flat"]


func _platform_from_index(index: int) -> NeoCadeTheme.Platform:
	match index:
		0:
			return NeoCadeTheme.Platform.DESKTOP
		1:
			return NeoCadeTheme.Platform.MOBILE
		_:
			return NeoCadeTheme.Platform.AUTO


func _platform_name(value: NeoCadeTheme.Platform) -> String:
	match value:
		NeoCadeTheme.Platform.DESKTOP:
			return "desktop"
		NeoCadeTheme.Platform.MOBILE:
			return "mobile"
		NeoCadeTheme.Platform.AUTO:
			return "auto"
	return "auto"


func _show_popup_panel() -> void:
	_popup_panel.popup(Rect2i(Vector2i(120, 140), Vector2i(320, 160)))


func _show_popup_menu() -> void:
	_popup_menu.popup(Rect2i(Vector2i(160, 160), Vector2i(260, 220)))


func _show_window_sample() -> void:
	var window := Window.new()
	window.title = "Detached Scoreboard"
	window.size = Vector2i(420, 220)
	window.initial_position = Window.WINDOW_INITIAL_POSITION_CENTER_MAIN_WINDOW_SCREEN
	_name_interactive(window, "Detached scoreboard window")
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 18)
	margin.add_theme_constant_override("margin_top", 18)
	margin.add_theme_constant_override("margin_right", 18)
	margin.add_theme_constant_override("margin_bottom", 18)
	window.add_child(margin)
	var stack := VBoxContainer.new()
	stack.add_theme_constant_override("separation", 10)
	margin.add_child(stack)
	var label := Label.new()
	label.text = "Player 1 · 18,240 tickets"
	label.theme_type_variation = "HeaderSmall"
	stack.add_child(label)
	var close := _make_button("Close", "PrimaryButton", true)
	close.pressed.connect(func() -> void: window.queue_free())
	stack.add_child(close)
	add_child(window)
	window.popup()
