extends SceneTree

const THEME_PATH := "res://addons/neocade_theme/neocade_theme.tres"
const EXPECTED_TAB_RADIUS := {
	NeoCadeTheme.Style.PULSE: 0,
	NeoCadeTheme.Style.DAYBREAK: 4,
	NeoCadeTheme.Style.SLATE: 8,
	NeoCadeTheme.Style.BURST: 12,
	NeoCadeTheme.Style.BUBBLE: 12,
}
const EXPECTED_POPUP_RADIUS := {
	NeoCadeTheme.Style.PULSE: 0,
	NeoCadeTheme.Style.DAYBREAK: 4,
	NeoCadeTheme.Style.SLATE: 8,
	NeoCadeTheme.Style.BURST: 12,
	NeoCadeTheme.Style.BUBBLE: 12,
}
const EXPECTED_CORNER_RADIUS := {
	NeoCadeTheme.Style.PULSE: 0,
	NeoCadeTheme.Style.DAYBREAK: 4,
	NeoCadeTheme.Style.SLATE: 8,
	NeoCadeTheme.Style.BURST: 12,
	NeoCadeTheme.Style.BUBBLE: 24,
}
const EXPECTED_DESKTOP_BUTTON_PADDING := Vector2(14, 9)
const EXPECTED_PRIMARY_DEPTH := {
	NeoCadeTheme.Style.PULSE: 3,
	NeoCadeTheme.Style.DAYBREAK: 3,
	NeoCadeTheme.Style.SLATE: 2,
	NeoCadeTheme.Style.BURST: 5,
	NeoCadeTheme.Style.BUBBLE: 4,
}
const EXPECTED_SECONDARY_DEPTH := {
	NeoCadeTheme.Style.PULSE: 2,
	NeoCadeTheme.Style.DAYBREAK: 2,
	NeoCadeTheme.Style.SLATE: 2,
	NeoCadeTheme.Style.BURST: 4,
	NeoCadeTheme.Style.BUBBLE: 3,
}
const EXPECTED_DEPTH_DARKEN := {
	NeoCadeTheme.Style.PULSE: 0.38,
	NeoCadeTheme.Style.DAYBREAK: 0.34,
	NeoCadeTheme.Style.SLATE: 0.30,
	NeoCadeTheme.Style.BURST: 0.42,
	NeoCadeTheme.Style.BUBBLE: 0.32,
}
const DEPTH_DARKEN_TOLERANCE := 0.02

var _failures: PackedStringArray = []


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var canonical := load(THEME_PATH) as NeoCadeTheme
	if canonical == null:
		_fail("canonical theme did not load as NeoCadeTheme")
		_finish()
		return

	for style_value in NeoCadeTheme.selectable_styles():
		for raised_value in [false, true]:
			var theme := _theme_variant(canonical, style_value, raised_value)
			var label := "%s:%s" % ["raised" if raised_value else "desktop", NeoCadeTheme.style_label(style_value)]
			_check_tab_radius(theme, label)
			_check_tab_side_margin(theme, label)
			_check_tab_separation(theme, label)
			_check_tab_border_contract(theme, label)
			_check_default_tabbar_background(theme, label)
			_check_popup_menu_radius(theme, label)
			_check_dialog_panel_radius(theme, label)
			_check_button_radius_and_padding(theme, label)
			_check_raised_depth(theme, label, raised_value)

	_finish()


func _theme_variant(source: NeoCadeTheme, style_value: int, raised_value: bool) -> NeoCadeTheme:
	var theme := source.duplicate(true) as NeoCadeTheme
	theme.style = style_value
	theme.raised = raised_value
	theme.platform = NeoCadeTheme.Platform.DESKTOP
	return theme


func _check_tab_radius(theme: NeoCadeTheme, label: String) -> void:
	var expected_radius: int = int(EXPECTED_TAB_RADIUS.get(theme.style, theme.corner_radius))
	for theme_type in [&"TabBar", &"TabContainer"]:
		for slot_name in [&"tab_selected", &"tab_unselected", &"tab_hovered", &"tab_disabled", &"tab_focus"]:
			if not theme.has_stylebox(slot_name, theme_type):
				continue
			var stylebox := theme.get_stylebox(slot_name, theme_type) as StyleBoxFlat
			if stylebox == null:
				_fail("%s %s.%s should be StyleBoxFlat" % [label, theme_type, slot_name])
				continue
			if stylebox.corner_radius_top_left != expected_radius or stylebox.corner_radius_top_right != expected_radius:
				_fail("%s %s.%s top radius expected %d got %d/%d" % [
					label,
					theme_type,
					slot_name,
					expected_radius,
					stylebox.corner_radius_top_left,
					stylebox.corner_radius_top_right,
				])
			if stylebox.corner_radius_bottom_left != 0 or stylebox.corner_radius_bottom_right != 0:
				_fail("%s %s.%s bottom radius should stay connected at 0 got %d/%d" % [
					label,
					theme_type,
					slot_name,
					stylebox.corner_radius_bottom_left,
					stylebox.corner_radius_bottom_right,
				])

		for slot_name in [&"tab_selected", &"tab_unselected", &"tab_hovered", &"tab_disabled"]:
			var state_stylebox := theme.get_stylebox(slot_name, theme_type) as StyleBoxFlat
			if state_stylebox != null and state_stylebox.border_width_bottom > _face_width(state_stylebox):
				_fail("%s %s.%s should not draw extra raised bottom tab depth, got face=%d bottom=%d" % [
					label,
					theme_type,
					slot_name,
					_face_width(state_stylebox),
					state_stylebox.border_width_bottom,
				])


func _check_tab_side_margin(theme: NeoCadeTheme, label: String) -> void:
	var expected_margin: int = int(EXPECTED_CORNER_RADIUS.get(theme.style, theme.corner_radius))
	if theme.corner_radius != expected_margin:
		_fail("%s exported corner_radius expected %d got %d" % [label, expected_margin, theme.corner_radius])
	for theme_type in [&"TabContainer"]:
		var actual_margin := theme.get_constant(&"side_margin", theme_type)
		if actual_margin != expected_margin:
			_fail("%s %s.side_margin expected corner_radius %d got %d" % [
				label,
				theme_type,
				expected_margin,
				actual_margin,
			])


func _check_tab_separation(theme: NeoCadeTheme, label: String) -> void:
	for theme_type in [&"TabBar", &"TabContainer"]:
		var actual_separation := theme.get_constant(&"tab_separation", theme_type)
		if actual_separation != 1:
			_fail("%s %s.tab_separation expected 1px gap between tab faces, got %d" % [
				label,
				theme_type,
				actual_separation,
			])


func _check_tab_border_contract(theme: NeoCadeTheme, label: String) -> void:
	for theme_type in [&"TabBar", &"TabContainer"]:
		var selected := theme.get_stylebox(&"tab_selected", theme_type) as StyleBoxFlat
		if selected == null:
			_fail("%s missing %s.tab_selected for border contract check" % [label, theme_type])
		elif selected.border_width_left != 0 or selected.border_width_top != 2 or selected.border_width_right != 0 or selected.border_width_bottom != 0:
			_fail("%s %s.tab_selected expected only 2px top accent, got %d/%d/%d/%d" % [
				label,
				theme_type,
				selected.border_width_left,
				selected.border_width_top,
				selected.border_width_right,
				selected.border_width_bottom,
			])

		for slot_name in [&"tab_unselected", &"tab_hovered", &"tab_disabled"]:
			var tab := theme.get_stylebox(slot_name, theme_type) as StyleBoxFlat
			if tab == null:
				_fail("%s missing %s.%s for border contract check" % [label, theme_type, slot_name])
				continue
			var max_border: int = maxi(tab.border_width_left, maxi(tab.border_width_top, maxi(tab.border_width_right, tab.border_width_bottom)))
			if max_border != 0:
				_fail("%s %s.%s should use the 1px layout gap, not painted borders, got %d/%d/%d/%d" % [
					label,
					theme_type,
					slot_name,
					tab.border_width_left,
					tab.border_width_top,
					tab.border_width_right,
					tab.border_width_bottom,
				])


func _check_default_tabbar_background(theme: NeoCadeTheme, label: String) -> void:
	var default_background := theme.get_stylebox(&"tabbar_background", &"TabContainer")
	if not (default_background is StyleBoxEmpty):
		_fail("%s TabContainer.tabbar_background should stay empty unless using FilledTabContainer" % label)

	var filled_background := theme.get_stylebox(&"tabbar_background", &"FilledTabContainer") as StyleBoxFlat
	if filled_background == null:
		_fail("%s FilledTabContainer.tabbar_background should provide the opt-in filled rail" % label)
	elif filled_background.bg_color.a < 0.99:
		_fail("%s FilledTabContainer.tabbar_background should be visibly filled" % label)


func _check_popup_menu_radius(theme: NeoCadeTheme, label: String) -> void:
	var expected_radius: int = int(EXPECTED_POPUP_RADIUS.get(theme.style, theme.corner_radius))
	for slot_name in [&"panel", &"hover"]:
		var stylebox := theme.get_stylebox(slot_name, &"PopupMenu") as StyleBoxFlat
		if stylebox == null:
			_fail("%s missing PopupMenu.%s for popup radius check" % [label, slot_name])
			continue
		if (
			stylebox.corner_radius_top_left != expected_radius
			or stylebox.corner_radius_top_right != expected_radius
			or stylebox.corner_radius_bottom_right != expected_radius
			or stylebox.corner_radius_bottom_left != expected_radius
		):
			_fail("%s PopupMenu.%s radius expected %d got %d/%d/%d/%d" % [
				label,
				slot_name,
				expected_radius,
				stylebox.corner_radius_top_left,
				stylebox.corner_radius_top_right,
				stylebox.corner_radius_bottom_right,
				stylebox.corner_radius_bottom_left,
			])


func _check_dialog_panel_radius(theme: NeoCadeTheme, label: String) -> void:
	var expected_window_radius: int = int(EXPECTED_CORNER_RADIUS.get(theme.style, theme.corner_radius))
	var window_panel := theme.get_stylebox(&"embedded_border", &"Window") as StyleBoxFlat
	if window_panel == null:
		_fail("%s missing Window.embedded_border for dialog shell radius check" % label)
	elif window_panel.corner_radius_top_left != expected_window_radius or window_panel.corner_radius_top_right != expected_window_radius:
		_fail("%s Window.embedded_border should own dialog radius %d got %d/%d" % [
			label,
			expected_window_radius,
			window_panel.corner_radius_top_left,
			window_panel.corner_radius_top_right,
		])

	for dialog_type in [&"AcceptDialog", &"ConfirmationDialog", &"PopupDialog"]:
		var panel := theme.get_stylebox(&"panel", dialog_type) as StyleBoxFlat
		if panel == null:
			_fail("%s missing %s.panel for dialog content radius check" % [label, dialog_type])
			continue
		if panel.corner_radius_top_left != 0 or panel.corner_radius_top_right != 0 or panel.corner_radius_bottom_left != 0 or panel.corner_radius_bottom_right != 0:
			_fail("%s %s.panel should stay square inside Window chrome got %d/%d/%d/%d" % [
				label,
				dialog_type,
				panel.corner_radius_top_left,
				panel.corner_radius_top_right,
				panel.corner_radius_bottom_left,
				panel.corner_radius_bottom_right,
			])


func _check_button_radius_and_padding(theme: NeoCadeTheme, label: String) -> void:
	var expected_radius: int = int(EXPECTED_CORNER_RADIUS.get(theme.style, theme.corner_radius))
	for entry in [
		{"type": &"Button", "slot": &"normal", "expect_padding": true},
		{"type": &"PrimaryButton", "slot": &"normal", "expect_padding": true},
		{"type": &"DangerButton", "slot": &"normal", "expect_padding": true},
		{"type": &"OptionButton", "slot": &"normal", "expect_padding": false},
		{"type": &"PanelContainer", "slot": &"panel", "expect_padding": false},
	]:
		var theme_type := entry["type"] as StringName
		var slot_name := entry["slot"] as StringName
		var stylebox := theme.get_stylebox(slot_name, theme_type) as StyleBoxFlat
		if stylebox == null:
			_fail("%s missing %s.%s for base radius check" % [label, theme_type, slot_name])
			continue
		if stylebox.corner_radius_top_left != expected_radius or stylebox.corner_radius_top_right != expected_radius:
			_fail("%s %s.%s radius expected %d got %d/%d" % [
				label,
				theme_type,
				slot_name,
				expected_radius,
				stylebox.corner_radius_top_left,
				stylebox.corner_radius_top_right,
			])
		if bool(entry["expect_padding"]):
			var actual_padding := Vector2(stylebox.content_margin_left, stylebox.content_margin_top)
			if actual_padding != EXPECTED_DESKTOP_BUTTON_PADDING:
				_fail("%s %s.%s desktop padding expected %s got %s" % [
					label,
					theme_type,
					slot_name,
					EXPECTED_DESKTOP_BUTTON_PADDING,
					actual_padding,
				])


func _check_raised_depth(theme: NeoCadeTheme, label: String, expect_raised: bool) -> void:
	var expected_primary_depth: int = int(EXPECTED_PRIMARY_DEPTH.get(theme.style, 3))
	var expected_secondary_depth: int = int(EXPECTED_SECONDARY_DEPTH.get(theme.style, 2))
	var expected_darken: float = float(EXPECTED_DEPTH_DARKEN.get(theme.style, 0.36))
	for theme_type in [&"PrimaryButton", &"DangerButton"]:
		var stylebox := theme.get_stylebox(&"normal", theme_type) as StyleBoxFlat
		if stylebox == null:
			_fail("%s missing %s.normal" % [label, theme_type])
			continue
		if expect_raised:
			_expect_depth_width(stylebox, label, theme_type, expected_primary_depth)
			_expect_depth_darken(stylebox, label, theme_type, expected_darken)
		else:
			_expect_flat_edge(stylebox, label, theme_type)

	var option := theme.get_stylebox(&"normal", &"OptionButton") as StyleBoxFlat
	if option == null:
		_fail("%s missing OptionButton.normal" % label)
		return
	if expect_raised:
		_expect_depth_width(option, label, &"OptionButton", expected_secondary_depth)
		_expect_depth_darken(option, label, &"OptionButton", expected_darken)
		var primary := theme.get_stylebox(&"normal", &"PrimaryButton") as StyleBoxFlat
		if primary != null and primary.border_width_bottom < option.border_width_bottom:
			_fail("%s PrimaryButton bottom edge should be at least OptionButton: primary=%d option=%d" % [
				label,
				primary.border_width_bottom,
				option.border_width_bottom,
			])
	else:
		_expect_flat_edge(option, label, &"OptionButton")


func _expect_depth_width(stylebox: StyleBoxFlat, label: String, theme_type: StringName, expected_bottom_width: int) -> void:
	var face_width := _face_width(stylebox)
	if stylebox.border_width_bottom <= face_width:
		_fail("%s raised %s should have a visible bottom depth edge: face=%d bottom=%d" % [
			label,
			theme_type,
			face_width,
			stylebox.border_width_bottom,
		])
	if stylebox.border_width_bottom != expected_bottom_width:
		_fail("%s raised %s bottom border expected %d got %d" % [
			label,
			theme_type,
			expected_bottom_width,
			stylebox.border_width_bottom,
		])


func _expect_depth_darken(stylebox: StyleBoxFlat, label: String, theme_type: StringName, expected_darken: float) -> void:
	var face_value: float = maxf(stylebox.bg_color.v, 0.001)
	var actual_darken: float = 1.0 - (stylebox.border_color.v / face_value)
	if absf(actual_darken - expected_darken) > DEPTH_DARKEN_TOLERANCE:
		_fail("%s raised %s depth darken expected %.2f got %.2f" % [
			label,
			theme_type,
			expected_darken,
			actual_darken,
		])


func _expect_flat_edge(stylebox: StyleBoxFlat, label: String, theme_type: StringName) -> void:
	var face_width := _face_width(stylebox)
	if stylebox.border_width_bottom > face_width:
		_fail("%s flat %s should not reserve raised depth: face=%d bottom=%d" % [
			label,
			theme_type,
			face_width,
			stylebox.border_width_bottom,
		])


func _face_width(stylebox: StyleBoxFlat) -> int:
	return maxi(stylebox.border_width_left, maxi(stylebox.border_width_top, stylebox.border_width_right))


func _fail(message: String) -> void:
	_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("THEME_RADIUS_DEPTH_PROBE: PASS")
		quit(0)
		return

	printerr("THEME_RADIUS_DEPTH_PROBE: FAIL")
	for failure in _failures:
		printerr("- " + failure)
	quit(1)
