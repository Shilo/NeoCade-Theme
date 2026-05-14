extends SceneTree

const TEXT_MIN := 4.5
const NON_TEXT_MIN := 3.0

const STYLE_PRESETS := {
	NeoCadeTheme.Style.PULSE: Color("#3AA8FF"),
	NeoCadeTheme.Style.DAYBREAK: Color("#76F2D1"),
	NeoCadeTheme.Style.SLATE: Color("#8BD3FF"),
	NeoCadeTheme.Style.BURST: Color("#FFD166"),
	NeoCadeTheme.Style.BUBBLE: Color("#57C7FF"),
}

const SOURCE_STRESS_COLORS := [
	Color("#3AA8FF"),
	Color("#C83A45"),
	Color("#37D67A"),
	Color("#8A4DFF"),
	Color("#FFD166"),
	Color("#FFFFFF"),
	Color("#05070B"),
	Color("#7A8794"),
	Color("#20D7D2"),
]

const ROLE_READERS := {
	"surface_fill": {"kind": "style_bg", "type": "EditorStyles", "slot": "Content"},
	"shell_fill": {"kind": "style_bg", "type": "WindowContentPanel", "slot": "panel"},
	"panel_fill": {"kind": "style_bg", "type": "Panel", "slot": "panel"},
	"panel_alt_fill": {"kind": "style_bg", "type": "TabBar", "slot": "tab_unselected"},
	"popup_shell": {"kind": "style_bg", "type": "PopupMenu", "slot": "panel"},
	"dialog_header": {"kind": "style_bg", "type": "EditorHelpBitTooltipTitle", "slot": "normal"},
	"separator_fill": {"kind": "style_line", "type": "HSeparator", "slot": "separator"},
	"code_fill": {"kind": "style_bg", "type": "CodeEdit", "slot": "normal"},
	"input_fill": {"kind": "style_bg", "type": "LineEdit", "slot": "normal"},
	"input_edge": {"kind": "style_border", "type": "LineEdit", "slot": "normal"},
	"list_panel_fill": {"kind": "style_bg", "type": "ItemList", "slot": "panel"},
	"list_row_hover": {"kind": "style_bg", "type": "ItemList", "slot": "hovered"},
	"selection_fill": {"kind": "style_bg", "type": "ItemList", "slot": "selected"},
	"text_selection_fill": {"kind": "color", "type": "LineEdit", "slot": "selection_color"},
	"action_fill": {"kind": "style_bg", "type": "Button", "slot": "normal"},
	"menu_fill": {"kind": "style_bg", "type": "OptionButton", "slot": "normal"},
	"range_fill": {"kind": "style_bg", "type": "ProgressBar", "slot": "fill"},
	"toggle_fill": {"kind": "color", "type": "CheckButton", "slot": "button_checked_color"},
	"positive_fill": {"kind": "style_bg", "type": "PrimaryButton", "slot": "normal"},
	"warning_fill": {"kind": "color", "type": "WarningLabel", "slot": "fill_color"},
	"info_fill": {"kind": "color", "type": "InfoLabel", "slot": "fill_color"},
	"danger_fill": {"kind": "style_bg", "type": "DangerButton", "slot": "normal"},
	"focus_ring": {"kind": "style_border", "type": "Button", "slot": "focus"},
	"link_text": {"kind": "color", "type": "LinkButton", "slot": "font_color"},
	"link_text_hover": {"kind": "color", "type": "LinkButton", "slot": "font_hover_color"},
}

const EXPECTED_PRESET_HEX := {
	NeoCadeTheme.Style.PULSE: {
		"surface_fill": "#141A26",
		"shell_fill": "#0F141E",
		"panel_fill": "#1B2838",
		"panel_alt_fill": "#24354C",
		"popup_shell": "#202F44",
		"dialog_header": "#2C3F58",
		"separator_fill": "#324256",
		"code_fill": "#151E2B",
		"input_fill": "#273C54",
		"input_edge": "#67A3CB",
		"list_panel_fill": "#1A2534",
		"list_row_hover": "#23344B",
		"selection_fill": "#4081B6",
		"text_selection_fill": "#4180B4",
		"link_text": "#4F8ABB",
		"link_text_hover": "#788691",
		"action_fill": "#D6BC34",
		"menu_fill": "#4F8BB7",
		"range_fill": "#5ECD7B",
		"toggle_fill": "#40D6C9",
		"positive_fill": "#40CA8F",
		"warning_fill": "#C98339",
		"info_fill": "#3E9FD8",
		"danger_fill": "#BC394F",
		"focus_ring": "#6FBEEB",
	},
	NeoCadeTheme.Style.DAYBREAK: {
		"surface_fill": "#122024",
		"shell_fill": "#0D181B",
		"panel_fill": "#1B333B",
		"panel_alt_fill": "#22474F",
		"popup_shell": "#213E46",
		"dialog_header": "#315851",
		"separator_fill": "#33555E",
		"code_fill": "#142429",
		"input_fill": "#26494E",
		"input_edge": "#72C3B5",
		"list_panel_fill": "#182C32",
		"list_row_hover": "#23444A",
		"selection_fill": "#3D978A",
		"text_selection_fill": "#3E9588",
		"link_text": "#3D978A",
		"link_text_hover": "#389489",
		"action_fill": "#D9BB34",
		"menu_fill": "#38A6AD",
		"range_fill": "#62DAA7",
		"toggle_fill": "#49D9BF",
		"positive_fill": "#42CB87",
		"warning_fill": "#C98834",
		"info_fill": "#44B0D7",
		"danger_fill": "#BB3A45",
		"focus_ring": "#7AEBD0",
	},
	NeoCadeTheme.Style.SLATE: {
		"surface_fill": "#14181F",
		"shell_fill": "#0F1217",
		"panel_fill": "#1D2632",
		"panel_alt_fill": "#273548",
		"popup_shell": "#222D3C",
		"dialog_header": "#2D3D55",
		"separator_fill": "#354557",
		"code_fill": "#131A22",
		"input_fill": "#273748",
		"input_edge": "#6B97B5",
		"list_panel_fill": "#19212D",
		"list_row_hover": "#243243",
		"selection_fill": "#4683AF",
		"text_selection_fill": "#4782AD",
		"link_text": "#4D88B2",
		"link_text_hover": "#5685A9",
		"action_fill": "#D8C578",
		"menu_fill": "#5982B0",
		"range_fill": "#6AD3D2",
		"toggle_fill": "#65D7B7",
		"positive_fill": "#5DCB94",
		"warning_fill": "#C6964E",
		"info_fill": "#4E9DD0",
		"danger_fill": "#B73E52",
		"focus_ring": "#88C3E7",
	},
	NeoCadeTheme.Style.BURST: {
		"surface_fill": "#191428",
		"shell_fill": "#120F1E",
		"panel_fill": "#291B3B",
		"panel_alt_fill": "#37264F",
		"popup_shell": "#312144",
		"dialog_header": "#422B5E",
		"separator_fill": "#463657",
		"code_fill": "#191428",
		"input_fill": "#332846",
		"input_edge": "#9B77C5",
		"list_panel_fill": "#211830",
		"list_row_hover": "#322545",
		"selection_fill": "#9A65C2",
		"text_selection_fill": "#9666C1",
		"link_text": "#A069C9",
		"link_text_hover": "#8B7E95",
		"action_fill": "#E2A737",
		"menu_fill": "#A260BE",
		"range_fill": "#87DD4E",
		"toggle_fill": "#4EDA8D",
		"positive_fill": "#44CD66",
		"warning_fill": "#D7713B",
		"info_fill": "#40CDDD",
		"danger_fill": "#BD3852",
		"focus_ring": "#74EADB",
	},
	NeoCadeTheme.Style.BUBBLE: {
		"surface_fill": "#234369",
		"shell_fill": "#1B3456",
		"panel_fill": "#F3F1E9",
		"panel_alt_fill": "#E3D9C5",
		"popup_shell": "#F8F6F2",
		"dialog_header": "#8880CF",
		"separator_fill": "#A4B7C7",
		"code_fill": "#EFF3F5",
		"input_fill": "#F5F7F9",
		"input_edge": "#497CA2",
		"list_panel_fill": "#F3F1E9",
		"list_row_hover": "#EEF2F5",
		"selection_fill": "#296E99",
		"text_selection_fill": "#2A678D",
		"link_text": "#72B5DF",
		"link_text_hover": "#A5AFB6",
		"action_fill": "#2D9BD4",
		"menu_fill": "#5C79B0",
		"range_fill": "#1A8B8A",
		"toggle_fill": "#229370",
		"positive_fill": "#229351",
		"warning_fill": "#E6C333",
		"info_fill": "#28A7C6",
		"danger_fill": "#C8375C",
		"focus_ring": "#19668E",
	},
}

var _failed := false


func _init() -> void:
	_assert(Engine.is_editor_hint(), "run this probe with --editor so editor-only theme slots are populated")
	var theme := NeoCadeTheme.new()
	for style_value in STYLE_PRESETS.keys():
		theme.style = style_value
		var label := NeoCadeTheme.style_label(style_value)
		_assert_color_close(theme.source_color, STYLE_PRESETS[style_value], "%s preset source_color" % label)
		_assert_exact_palette(theme, style_value, label)
		_assert_text_readability(theme, label)
		_assert_non_text_boundaries(theme, label)
		_assert_surface_subtlety(theme, style_value, label)
		_assert_role_semantics(theme, label, true)
		_assert_tree_role_exception(theme, label)

		var responsive_tokens := _responsive_token_snapshot(theme)
		theme.source_color = Color("#8A4DFF")
		for token in responsive_tokens.keys():
			var previous: Color = responsive_tokens[token]
			_assert(not previous.is_equal_approx(_read_role(theme, token)), "%s %s reacts to source_color" % [label, token])
		_assert_text_readability(theme, "%s violet-source stress" % label)
		_assert_surface_subtlety(theme, style_value, "%s violet-source stress" % label)
		_assert_role_semantics(theme, "%s violet-source stress" % label, false)
		_assert_tree_role_exception(theme, "%s violet-source stress" % label)

	for style_value in STYLE_PRESETS.keys():
		for source in SOURCE_STRESS_COLORS:
			theme.style = style_value
			theme.source_color = source
			var label := "%s source=%s" % [NeoCadeTheme.style_label(style_value), source.to_html(false)]
			_assert_text_readability(theme, label)
			_assert_surface_subtlety(theme, style_value, label)
			_assert_role_semantics(theme, label, false)
			_assert_tree_role_exception(theme, label)

	if _failed:
		print("THEME_OPTION_B_READABILITY_PROBE: FAIL")
		quit(1)
	else:
		print("THEME_OPTION_B_READABILITY_PROBE: PASS")
		quit(0)


func _assert_exact_palette(theme: NeoCadeTheme, style_value: int, label: String) -> void:
	var expected: Dictionary = EXPECTED_PRESET_HEX[style_value]
	for token in expected.keys():
		var actual := _read_role(theme, token)
		_assert_hex_close(actual, expected[token], "%s %s" % [label, token])


func _responsive_token_snapshot(theme: NeoCadeTheme) -> Dictionary:
	# Warning/danger/separator are intentionally omitted: they are hue-locked safety
	# and utility roles, so source-color edits should not pull them like ordinary
	# component fills.
	var tokens := [
		"surface_fill",
		"shell_fill",
		"panel_fill",
		"panel_alt_fill",
		"popup_shell",
		"dialog_header",
		"code_fill",
		"input_fill",
		"input_edge",
		"list_panel_fill",
		"list_row_hover",
		"selection_fill",
		"text_selection_fill",
		"action_fill",
		"menu_fill",
		"range_fill",
		"toggle_fill",
		"positive_fill",
		"info_fill",
		"focus_ring",
		"link_text",
		"link_text_hover",
	]
	var snapshot := {}
	for token in tokens:
		snapshot[token] = _read_role(theme, token)
	return snapshot


func _assert_text_readability(theme: NeoCadeTheme, label: String) -> void:
	var pairs := [
		["Button", "normal", "font_color"],
		["PrimaryButton", "normal", "font_color"],
		["DangerButton", "normal", "font_color"],
		["MenuButton", "normal", "font_color"],
		["OptionButton", "normal", "font_color"],
		["LineEdit", "normal", "font_color"],
		["TextEdit", "normal", "font_color"],
		["CodeEdit", "normal", "font_color"],
		["ItemList", "panel", "font_color"],
		["ItemList", "hovered", "font_hovered_color"],
		["ItemList", "selected", "font_selected_color"],
		["Tree", "panel", "font_color"],
		["Tree", "hovered", "font_hovered_color"],
		["Tree", "selected", "font_selected_color"],
		["TabBar", "tab_selected", "font_selected_color"],
		["TabBar", "tab_unselected", "font_unselected_color"],
		["TabBar", "tab_hovered", "font_hovered_color"],
		["TabContainer", "tab_selected", "font_selected_color"],
		["PopupMenu", "panel", "font_color"],
		["PopupMenu", "hover", "font_hover_color"],
		["EditorProperty", "child_bg", "property_color"],
		["EditorSpinSlider", "label_bg", "label_color"],
		["EditorHelp", "background", "text_color"],
		["EditorHelp", "background", "headline_color"],
		["EditorHelp", "background", "comment_color"],
		["EditorHelp", "background", "qualifier_color"],
		["EditorHelp", "background", "type_color"],
		["EditorHelp", "background", "title_color"],
		["EditorHelp", "background", "link_color"],
		["EditorHelp", "background", "code_color"],
		["TooltipPanel", "panel", "font_color", "TooltipLabel"],
	]
	for pair in pairs:
		if pair.size() >= 4:
			_assert_cross_type_contrast(theme, label, pair[0], pair[1], pair[2], pair[3], TEXT_MIN)
		else:
			_assert_contrast(theme, label, pair[0], pair[1], pair[2], TEXT_MIN)

	_assert_color_contrast(theme, label, "EditorHelp.kbd_bg_color vs kbd_color", theme.get_color("kbd_bg_color", "EditorHelp"), theme.get_color("kbd_color", "EditorHelp"), TEXT_MIN)

	for background_name in ["surface_fill", "shell_fill", "panel_fill", "popup_shell", "code_fill", "list_panel_fill"]:
		var background := _read_role(theme, background_name)
		_assert_text_or_outline_contrast(theme, label, "LinkButton over %s" % background_name, background, theme.get_color("font_color", "LinkButton"), theme.get_color("font_outline_color", "LinkButton"), theme.get_constant("outline_size", "LinkButton"), TEXT_MIN)
		_assert_text_or_outline_contrast(theme, label, "LinkButton hover over %s" % background_name, background, theme.get_color("font_hover_color", "LinkButton"), theme.get_color("font_outline_color", "LinkButton"), theme.get_constant("outline_size", "LinkButton"), TEXT_MIN)
		_assert_text_or_outline_contrast(theme, label, "GhostButton over %s" % background_name, background, theme.get_color("font_color", "GhostButton"), theme.get_color("font_outline_color", "GhostButton"), theme.get_constant("outline_size", "GhostButton"), TEXT_MIN)
		_assert_text_or_outline_contrast(theme, label, "Kicker over %s" % background_name, background, theme.get_color("font_color", "Kicker"), theme.get_color("font_outline_color", "Kicker"), theme.get_constant("outline_size", "Kicker"), TEXT_MIN)
	for background_name in ["surface_fill", "shell_fill"]:
		var background := _read_role(theme, background_name)
		_assert_color_contrast(theme, label, "GhostButton icon over %s" % background_name, background, theme.get_color("icon_normal_color", "GhostButton"), NON_TEXT_MIN)

	_assert_color_contrast(theme, label, "RichTextLabel.selection_color", theme.get_color("selection_color", "RichTextLabel"), theme.get_color("font_selected_color", "RichTextLabel"), TEXT_MIN)
	_assert_color_contrast(theme, label, "LineEdit.selection_color", theme.get_color("selection_color", "LineEdit"), theme.get_color("font_selected_color", "LineEdit"), TEXT_MIN)
	_assert_color_contrast(theme, label, "TextEdit.selection_color", theme.get_color("selection_color", "TextEdit"), theme.get_color("font_selected_color", "TextEdit"), TEXT_MIN)
	_assert_color_contrast(theme, label, "CodeEdit.selection_color", theme.get_color("selection_color", "CodeEdit"), theme.get_color("font_selected_color", "CodeEdit"), TEXT_MIN)
	_assert_selection_text_alpha(theme, label, "RichTextLabel")
	_assert_selection_text_alpha(theme, label, "LineEdit")
	_assert_selection_text_alpha(theme, label, "TextEdit")
	_assert_selection_text_alpha(theme, label, "CodeEdit")
	_assert_color_contrast(theme, label, "Label over ambient surface", _read_role(theme, "surface_fill"), theme.get_color("font_color", "Label"), TEXT_MIN)
	_assert_color_contrast(theme, label, "Label over ambient shell", _read_role(theme, "shell_fill"), theme.get_color("font_color", "Label"), TEXT_MIN)
	_assert_text_or_outline_contrast(theme, label, "Label over Panel", _style_bg(theme, "Panel", "panel"), theme.get_color("font_color", "Label"), theme.get_color("font_outline_color", "Label"), theme.get_constant("outline_size", "Label"), TEXT_MIN)
	_assert_text_or_outline_contrast(theme, label, "Label over AcceptDialog", _style_bg(theme, "AcceptDialog", "panel"), theme.get_color("font_color", "Label"), theme.get_color("font_outline_color", "Label"), theme.get_constant("outline_size", "Label"), TEXT_MIN)
	_assert_text_or_outline_contrast(theme, label, "Label over GraphEdit", _style_bg(theme, "GraphEdit", "panel"), theme.get_color("font_color", "Label"), theme.get_color("font_outline_color", "Label"), theme.get_constant("outline_size", "Label"), TEXT_MIN)
	_assert_color_contrast(theme, label, "RichTextLabel over ambient surface", _read_role(theme, "surface_fill"), theme.get_color("default_color", "RichTextLabel"), TEXT_MIN)
	_assert_color_contrast(theme, label, "RichTextLabel over ambient shell", _read_role(theme, "shell_fill"), theme.get_color("default_color", "RichTextLabel"), TEXT_MIN)
	_assert_text_or_outline_contrast(theme, label, "RichTextLabel over Panel", _style_bg(theme, "Panel", "panel"), theme.get_color("default_color", "RichTextLabel"), theme.get_color("font_outline_color", "RichTextLabel"), theme.get_constant("outline_size", "RichTextLabel"), TEXT_MIN)
	_assert_text_or_outline_contrast(theme, label, "RichTextLabel over AcceptDialog", _style_bg(theme, "AcceptDialog", "panel"), theme.get_color("default_color", "RichTextLabel"), theme.get_color("font_outline_color", "RichTextLabel"), theme.get_constant("outline_size", "RichTextLabel"), TEXT_MIN)
	_assert_text_or_outline_contrast(theme, label, "RichTextLabel over GraphEdit", _style_bg(theme, "GraphEdit", "panel"), theme.get_color("default_color", "RichTextLabel"), theme.get_color("font_outline_color", "RichTextLabel"), theme.get_constant("outline_size", "RichTextLabel"), TEXT_MIN)
	_assert_color_contrast(theme, label, "CheckBox over ambient surface", _read_role(theme, "surface_fill"), theme.get_color("font_color", "CheckBox"), TEXT_MIN)
	_assert_color_contrast(theme, label, "CheckBox over ambient shell", _read_role(theme, "shell_fill"), theme.get_color("font_color", "CheckBox"), TEXT_MIN)
	_assert_text_or_outline_contrast(theme, label, "CheckBox over Panel", _style_bg(theme, "Panel", "panel"), theme.get_color("font_color", "CheckBox"), theme.get_color("font_outline_color", "CheckBox"), theme.get_constant("outline_size", "CheckBox"), TEXT_MIN)
	_assert_text_or_outline_contrast(theme, label, "CheckBox over AcceptDialog", _style_bg(theme, "AcceptDialog", "panel"), theme.get_color("font_color", "CheckBox"), theme.get_color("font_outline_color", "CheckBox"), theme.get_constant("outline_size", "CheckBox"), TEXT_MIN)
	_assert_text_or_outline_contrast(theme, label, "CheckBox over GraphEdit", _style_bg(theme, "GraphEdit", "panel"), theme.get_color("font_color", "CheckBox"), theme.get_color("font_outline_color", "CheckBox"), theme.get_constant("outline_size", "CheckBox"), TEXT_MIN)
	_assert_color_contrast(theme, label, "CheckButton over ambient surface", _read_role(theme, "surface_fill"), theme.get_color("font_color", "CheckButton"), TEXT_MIN)
	_assert_color_contrast(theme, label, "CheckButton over ambient shell", _read_role(theme, "shell_fill"), theme.get_color("font_color", "CheckButton"), TEXT_MIN)
	_assert_text_or_outline_contrast(theme, label, "CheckButton over Panel", _style_bg(theme, "Panel", "panel"), theme.get_color("font_color", "CheckButton"), theme.get_color("font_outline_color", "CheckButton"), theme.get_constant("outline_size", "CheckButton"), TEXT_MIN)
	_assert_text_or_outline_contrast(theme, label, "CheckButton over AcceptDialog", _style_bg(theme, "AcceptDialog", "panel"), theme.get_color("font_color", "CheckButton"), theme.get_color("font_outline_color", "CheckButton"), theme.get_constant("outline_size", "CheckButton"), TEXT_MIN)
	_assert_text_or_outline_contrast(theme, label, "CheckButton over GraphEdit", _style_bg(theme, "GraphEdit", "panel"), theme.get_color("font_color", "CheckButton"), theme.get_color("font_outline_color", "CheckButton"), theme.get_constant("outline_size", "CheckButton"), TEXT_MIN)
	_assert_color_contrast(theme, label, "PanelLabel over Panel", _style_bg(theme, "Panel", "panel"), theme.get_color("font_color", "PanelLabel"), TEXT_MIN)
	_assert_color_contrast(theme, label, "DialogLabel over PopupMenu", _style_bg(theme, "PopupMenu", "panel"), theme.get_color("font_color", "DialogLabel"), TEXT_MIN)
	_assert_color_contrast(theme, label, "SuccessLabel over Panel", _style_bg(theme, "Panel", "panel"), theme.get_color("font_color", "SuccessLabel"), TEXT_MIN)
	_assert_color_contrast(theme, label, "WarningLabel over Panel", _style_bg(theme, "Panel", "panel"), theme.get_color("font_color", "WarningLabel"), TEXT_MIN)
	_assert_color_contrast(theme, label, "DangerLabel over Panel", _style_bg(theme, "Panel", "panel"), theme.get_color("font_color", "DangerLabel"), TEXT_MIN)
	_assert_color_contrast(theme, label, "InfoLabel over Panel", _style_bg(theme, "Panel", "panel"), theme.get_color("font_color", "InfoLabel"), TEXT_MIN)
	_assert_color_contrast(theme, label, "HeaderLarge over Panel", _style_bg(theme, "Panel", "panel"), theme.get_color("font_color", "HeaderLarge"), TEXT_MIN)
	_assert_color_contrast(theme, label, "HeaderMedium over AcceptDialog", _style_bg(theme, "AcceptDialog", "panel"), theme.get_color("font_color", "HeaderMedium"), TEXT_MIN)
	_assert_color_contrast(theme, label, "HeaderSmall over GraphEdit", _style_bg(theme, "GraphEdit", "panel"), theme.get_color("font_color", "HeaderSmall"), TEXT_MIN)
	_assert_text_or_outline_contrast(theme, label, "HeaderLarge over ambient shell", _read_role(theme, "shell_fill"), theme.get_color("font_color", "HeaderLarge"), theme.get_color("font_outline_color", "HeaderLarge"), theme.get_constant("outline_size", "HeaderLarge"), TEXT_MIN)
	_assert_text_or_outline_contrast(theme, label, "HeaderMedium over ambient shell", _read_role(theme, "shell_fill"), theme.get_color("font_color", "HeaderMedium"), theme.get_color("font_outline_color", "HeaderMedium"), theme.get_constant("outline_size", "HeaderMedium"), TEXT_MIN)
	_assert_text_or_outline_contrast(theme, label, "HeaderSmall over ambient shell", _read_role(theme, "shell_fill"), theme.get_color("font_color", "HeaderSmall"), theme.get_color("font_outline_color", "HeaderSmall"), theme.get_constant("outline_size", "HeaderSmall"), TEXT_MIN)
	_assert_color_contrast(theme, label, "CodeLabel over GraphEdit", _style_bg(theme, "GraphEdit", "panel"), theme.get_color("font_color", "CodeLabel"), TEXT_MIN)
	_assert_color_contrast(theme, label, "GraphFrameTitleLabel over titlebar", _style_bg_over(theme, "GraphFrame", "titlebar", _style_bg(theme, "GraphEdit", "panel")), theme.get_color("font_color", "GraphFrameTitleLabel"), TEXT_MIN)
	_assert_text_or_outline_contrast(theme, label, "GraphFrameTitleLabel over selected titlebar", _style_bg_over(theme, "GraphFrame", "titlebar_selected", _style_bg(theme, "GraphEdit", "panel")), theme.get_color("font_color", "GraphFrameTitleLabel"), theme.get_color("font_outline_color", "GraphFrameTitleLabel"), theme.get_constant("outline_size", "GraphFrameTitleLabel"), TEXT_MIN)
	_assert_color_contrast(theme, label, "MenuBar normal over shell", _style_bg(theme, "EditorStyles", "Content"), theme.get_color("font_color", "MenuBar"), TEXT_MIN)
	_assert_color_contrast(theme, label, "MenuBar hover", _style_bg(theme, "MenuBar", "hover"), theme.get_color("font_hover_color", "MenuBar"), TEXT_MIN)
	_assert_color_contrast(theme, label, "MenuBar pressed", _style_bg(theme, "MenuBar", "pressed"), theme.get_color("font_pressed_color", "MenuBar"), TEXT_MIN)
	_assert_color_contrast(theme, label, "Editor.font_dark_background_color over surface", _read_role(theme, "surface_fill"), theme.get_color("font_dark_background_color", "Editor"), TEXT_MIN)
	_assert_color_contrast(theme, label, "Editor.font_dark_background_color over shell", _read_role(theme, "shell_fill"), theme.get_color("font_dark_background_color", "Editor"), TEXT_MIN)
	var editor_child_bg := _style_bg(theme, "EditorProperty", "child_bg")
	_assert_color_contrast(theme, label, "EditorProperty.property_color_x", editor_child_bg, theme.get_color("property_color_x", "Editor"), TEXT_MIN)
	_assert_color_contrast(theme, label, "EditorProperty.property_color_y", editor_child_bg, theme.get_color("property_color_y", "Editor"), TEXT_MIN)
	_assert_color_contrast(theme, label, "EditorProperty.property_color_z", editor_child_bg, theme.get_color("property_color_z", "Editor"), TEXT_MIN)
	_assert_color_contrast(theme, label, "EditorProperty.property_color_w", editor_child_bg, theme.get_color("property_color_w", "Editor"), TEXT_MIN)
	_assert_color_contrast(theme, label, "TabContainerInner unselected", _style_bg(theme, "TabContainerInner", "tab_unselected"), theme.get_color("font_unselected_color", "TabContainerInner"), TEXT_MIN)
	_assert_color_contrast(theme, label, "TabBarInner unselected", _style_bg(theme, "TabBarInner", "tab_unselected"), theme.get_color("font_unselected_color", "TabBarInner"), TEXT_MIN)
	_assert_color_contrast(theme, label, "BottomPanel unselected", _style_bg(theme, "BottomPanel", "tab_unselected"), theme.get_color("font_unselected_color", "BottomPanel"), TEXT_MIN)


func _assert_non_text_boundaries(theme: NeoCadeTheme, label: String) -> void:
	var panel := _style_bg(theme, "Panel", "panel")
	var popup := _style_bg(theme, "PopupMenu", "panel")
	var list_panel := _style_bg(theme, "ItemList", "panel")
	var tree_panel := _style_bg(theme, "Tree", "panel")
	_assert_component_boundary(theme, label, "Button.normal boundary", "Button", "normal", panel)
	_assert_component_boundary(theme, label, "OptionButton.normal boundary", "OptionButton", "normal", panel)
	_assert_component_boundary(theme, label, "OptionButton.normal boundary vs panel_alt", "OptionButton", "normal", _read_role(theme, "panel_alt_fill"))
	_assert_component_boundary(theme, label, "OptionButton.normal boundary vs popup_shell", "OptionButton", "normal", _read_role(theme, "popup_shell"))
	_assert_component_boundary(theme, label, "LineEdit.normal boundary", "LineEdit", "normal", panel)
	_assert_component_boundary(theme, label, "EditorProperty.child_bg boundary", "EditorProperty", "child_bg", panel)
	_assert_component_boundary(theme, label, "PopupMenu.hover boundary", "PopupMenu", "hover", popup)
	_assert_component_boundary(theme, label, "Tree.selected boundary", "Tree", "selected", tree_panel)
	_assert_component_boundary(theme, label, "ItemList.selected boundary", "ItemList", "selected", list_panel)
	_assert_color_contrast(theme, label, "focus ring vs panel", panel, _style_border(theme, "Button", "focus"), NON_TEXT_MIN)


func _assert_surface_subtlety(theme: NeoCadeTheme, style_value: int, label: String) -> void:
	var large_tokens := ["surface_fill", "shell_fill", "panel_fill", "panel_alt_fill", "popup_shell", "input_fill", "list_panel_fill", "list_row_hover", "code_fill"]
	for token in large_tokens:
		var color := _read_role(theme, token)
		var hsl := _color_to_hsl(color)
		if style_value == NeoCadeTheme.Style.BUBBLE and token not in ["surface_fill", "shell_fill"]:
			_assert(float(hsl["l"]) >= 0.78, "%s %s remains a light readable island l=%.2f" % [label, token, hsl["l"]])
			_assert(float(hsl["s"]) <= 0.42, "%s %s light island saturation stays restrained s=%.2f" % [label, token, hsl["s"]])
		else:
			_assert(float(hsl["l"]) <= 0.36, "%s %s large surface is not attention-bright l=%.2f" % [label, token, hsl["l"]])
			var max_surface_chroma := 0.56 if style_value == NeoCadeTheme.Style.BUBBLE and token in ["surface_fill", "shell_fill"] else 0.52
			_assert(float(hsl["s"]) <= max_surface_chroma, "%s %s large surface chroma is restrained s=%.2f" % [label, token, hsl["s"]])

	var input_hsl := _color_to_hsl(_read_role(theme, "input_fill"))
	var code_hsl := _color_to_hsl(_read_role(theme, "code_fill"))
	_assert(float(input_hsl["s"]) <= 0.42, "%s input_fill stays suitable for text entry s=%.2f" % [label, input_hsl["s"]])
	_assert(float(code_hsl["s"]) <= 0.38, "%s code_fill stays suitable for dense text s=%.2f" % [label, code_hsl["s"]])


func _assert_role_semantics(theme: NeoCadeTheme, label: String, strict_identity: bool) -> void:
	var attention_tokens := ["action_fill", "menu_fill", "selection_fill", "range_fill", "toggle_fill", "positive_fill", "warning_fill", "info_fill"]
	var hue_families := []
	for token in attention_tokens:
		var hue := float(_color_to_hsl(_read_role(theme, token))["h"])
		_assert(not _is_red_family_hue(hue), "%s %s avoids danger-red hue %.1f" % [label, token, hue])
		var family := int(floor(hue / 35.0))
		if not hue_families.has(family):
			hue_families.append(family)
	var min_families := 4 if strict_identity else 3
	_assert(hue_families.size() >= min_families, "%s has at least %d attention hue families, got %d" % [label, min_families, hue_families.size()])

	var danger_hue := float(_color_to_hsl(_read_role(theme, "danger_fill"))["h"])
	_assert(_is_red_family_hue(danger_hue), "%s danger_fill remains the only red-family fill hue=%.1f" % [label, danger_hue])

	var toggle_hsl := _color_to_hsl(_read_role(theme, "toggle_fill"))
	var positive_hsl := _color_to_hsl(_read_role(theme, "positive_fill"))
	var state_hue_gap := _hue_distance(float(toggle_hsl["h"]), float(positive_hsl["h"]))
	var state_contrast := _contrast_ratio(_read_role(theme, "toggle_fill"), _read_role(theme, "positive_fill"))
	var min_state_hue_gap := 10.0 if strict_identity else 6.0
	var min_state_contrast := 1.20 if strict_identity else 1.10
	_assert(state_hue_gap >= min_state_hue_gap or state_contrast >= min_state_contrast, "%s toggle_fill stays distinguishable from positive_fill hue_gap=%.1f contrast=%.2f" % [label, state_hue_gap, state_contrast])


func _assert_tree_role_exception(theme: NeoCadeTheme, label: String) -> void:
	# Plain Tree.panel is intentionally input-like because Godot's EditorResourcePicker
	# paints inspector value cells through plain Tree. Visible list/tree surfaces stay on
	# ItemList, TreeSecondary, and TreeTable.
	_assert_color_close(_style_bg(theme, "Tree", "panel"), _read_role(theme, "input_fill"), "%s Tree.panel follows input_fill editor-resource-picker exception" % label)
	_assert_color_close(_style_bg(theme, "TreeSecondary", "panel"), _read_role(theme, "list_panel_fill"), "%s TreeSecondary.panel follows list_panel_fill" % label)
	_assert_color_close(_style_bg(theme, "TreeTable", "panel"), _read_role(theme, "list_panel_fill"), "%s TreeTable.panel follows list_panel_fill" % label)


func _assert_component_boundary(theme: NeoCadeTheme, label: String, name: String, theme_type: String, style_name: String, surround: Color) -> void:
	var face := _style_bg(theme, theme_type, style_name)
	var stylebox := theme.get_stylebox(style_name, theme_type)
	var edge := _style_border(theme, theme_type, style_name)
	var face_ratio := _contrast_ratio(face, surround)
	var edge_ratio := 0.0
	var border_visible := false
	if stylebox is StyleBoxFlat:
		var flat := stylebox as StyleBoxFlat
		border_visible = flat.border_width_left > 0 or flat.border_width_top > 0 or flat.border_width_right > 0 or flat.border_width_bottom > 0
	if border_visible and edge.a > 0.05:
		edge_ratio = _contrast_ratio(edge, surround)
	_assert(maxf(face_ratio, edge_ratio) >= NON_TEXT_MIN, "%s %s face %.2f edge %.2f needs %.1f" % [label, name, face_ratio, edge_ratio, NON_TEXT_MIN])


func _assert_contrast(theme: NeoCadeTheme, label: String, theme_type: String, stylebox_name: String, color_name: String, min_ratio: float) -> void:
	var bg := _style_bg(theme, theme_type, stylebox_name)
	var fg := theme.get_color(color_name, theme_type)
	_assert_color_contrast(theme, label, "%s.%s vs %s" % [theme_type, stylebox_name, color_name], bg, fg, min_ratio)


func _assert_cross_type_contrast(theme: NeoCadeTheme, label: String, bg_type: String, stylebox_name: String, color_name: String, fg_type: String, min_ratio: float) -> void:
	var bg := _style_bg(theme, bg_type, stylebox_name)
	var fg := theme.get_color(color_name, fg_type)
	_assert_color_contrast(theme, label, "%s.%s vs %s.%s" % [bg_type, stylebox_name, fg_type, color_name], bg, fg, min_ratio)


func _assert_color_contrast(_theme: NeoCadeTheme, label: String, name: String, bg: Color, fg: Color, min_ratio: float) -> void:
	var ratio := _contrast_ratio(bg, fg)
	_assert(ratio >= min_ratio, "%s %s contrast %.2f below %.1f bg=%s fg=%s" % [label, name, ratio, min_ratio, bg.to_html(), fg.to_html()])


func _assert_selection_text_alpha(theme: NeoCadeTheme, label: String, theme_type: String) -> void:
	var selection := theme.get_color("selection_color", theme_type)
	_assert(selection.a >= 0.85, "%s %s.selection_color remains opaque enough for font_selected_color contrast a=%.2f" % [label, theme_type, selection.a])


func _assert_text_or_outline_contrast(_theme: NeoCadeTheme, label: String, name: String, bg: Color, fg: Color, outline: Color, outline_size: int, min_ratio: float) -> void:
	var fill_ratio := _contrast_ratio(bg, fg)
	var effective_outline := _composite(outline, bg)
	var outline_ratio := _contrast_ratio(bg, effective_outline)
	_assert(
		fill_ratio >= min_ratio or (outline_size > 0 and outline.a > 0.05 and outline_ratio >= min_ratio),
		"%s %s fill %.2f outline %.2f/size=%d below %.1f bg=%s fg=%s outline=%s effective=%s" % [label, name, fill_ratio, outline_ratio, outline_size, min_ratio, bg.to_html(), fg.to_html(), outline.to_html(), effective_outline.to_html()]
	)


func _read_role(theme: NeoCadeTheme, token: String) -> Color:
	var reader: Dictionary = ROLE_READERS[token]
	match String(reader["kind"]):
		"style_bg":
			return _style_bg(theme, String(reader["type"]), String(reader["slot"]))
		"style_border":
			return _style_border(theme, String(reader["type"]), String(reader["slot"]))
		"style_line":
			return _style_line_color(theme, String(reader["type"]), String(reader["slot"]))
		"color":
			return theme.get_color(String(reader["slot"]), String(reader["type"]))
	_fail("Unknown role reader kind for %s" % token)
	return Color.BLACK


func _style_bg(theme: NeoCadeTheme, theme_type: String, style_name: String) -> Color:
	var stylebox := theme.get_stylebox(style_name, theme_type)
	if stylebox is StyleBoxFlat:
		return (stylebox as StyleBoxFlat).bg_color
	_fail("%s.%s is not StyleBoxFlat" % [theme_type, style_name])
	return Color.BLACK


func _style_bg_over(theme: NeoCadeTheme, theme_type: String, style_name: String, parent: Color) -> Color:
	var bg := _style_bg(theme, theme_type, style_name)
	return _composite(bg, parent)


func _style_border(theme: NeoCadeTheme, theme_type: String, style_name: String) -> Color:
	var stylebox := theme.get_stylebox(style_name, theme_type)
	if stylebox is StyleBoxFlat:
		return (stylebox as StyleBoxFlat).border_color
	_fail("%s.%s is not StyleBoxFlat" % [theme_type, style_name])
	return Color.BLACK


func _style_line_color(theme: NeoCadeTheme, theme_type: String, style_name: String) -> Color:
	var stylebox := theme.get_stylebox(style_name, theme_type)
	if stylebox is StyleBoxLine:
		return (stylebox as StyleBoxLine).color
	_fail("%s.%s is not StyleBoxLine" % [theme_type, style_name])
	return Color.BLACK


func _assert(condition: bool, message: String) -> void:
	if not condition:
		_fail(message)


func _assert_color_close(actual: Color, expected: Color, message: String) -> void:
	if not actual.is_equal_approx(expected):
		_fail("%s expected=%s actual=%s" % [message, expected.to_html(false), actual.to_html(false)])


func _assert_hex_close(actual: Color, expected_hex: String, message: String) -> void:
	var expected := Color(expected_hex)
	var dr := absf(actual.r - expected.r)
	var dg := absf(actual.g - expected.g)
	var db := absf(actual.b - expected.b)
	if maxf(dr, maxf(dg, db)) > (1.5 / 255.0):
		_fail("%s expected=%s actual=#%s" % [message, expected_hex, actual.to_html(false)])


func _fail(message: String) -> void:
	_failed = true
	push_error("THEME_OPTION_B_READABILITY_PROBE %s" % message)


func _contrast_ratio(a: Color, b: Color) -> float:
	var a_lum := _relative_luminance(a)
	var b_lum := _relative_luminance(b)
	var lighter: float = maxf(a_lum, b_lum)
	var darker: float = minf(a_lum, b_lum)
	return (lighter + 0.05) / (darker + 0.05)


func _composite(top: Color, bottom: Color) -> Color:
	var a := clampf(top.a, 0.0, 1.0)
	return Color(
		top.r * a + bottom.r * (1.0 - a),
		top.g * a + bottom.g * (1.0 - a),
		top.b * a + bottom.b * (1.0 - a),
		1.0
	)


func _relative_luminance(c: Color) -> float:
	return 0.2126 * _srgb_to_linear(c.r) + 0.7152 * _srgb_to_linear(c.g) + 0.0722 * _srgb_to_linear(c.b)


func _srgb_to_linear(channel: float) -> float:
	return channel / 12.92 if channel <= 0.03928 else pow((channel + 0.055) / 1.055, 2.4)


func _color_to_hsl(color: Color) -> Dictionary:
	var max_channel: float = maxf(color.r, maxf(color.g, color.b))
	var min_channel: float = minf(color.r, minf(color.g, color.b))
	var lightness: float = (max_channel + min_channel) * 0.5
	var hue := 0.0
	var saturation := 0.0
	if max_channel != min_channel:
		var delta: float = max_channel - min_channel
		saturation = delta / (2.0 - max_channel - min_channel) if lightness > 0.5 else delta / (max_channel + min_channel)
		if max_channel == color.r:
			hue = (color.g - color.b) / delta + (6.0 if color.g < color.b else 0.0)
		elif max_channel == color.g:
			hue = (color.b - color.r) / delta + 2.0
		else:
			hue = (color.r - color.g) / delta + 4.0
		hue *= 60.0
	return {"h": hue, "s": saturation, "l": lightness}


func _is_red_family_hue(hue: float) -> bool:
	var wrapped := fposmod(hue, 360.0)
	return wrapped >= 330.0 or wrapped <= 20.0


func _hue_distance(a: float, b: float) -> float:
	return absf(fposmod(a - b + 180.0, 360.0) - 180.0)
