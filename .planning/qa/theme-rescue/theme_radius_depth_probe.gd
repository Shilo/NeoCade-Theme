extends SceneTree

const THEME_PATH := "res://addons/neocade_theme/neocade_theme.tres"
const EXPECTED_TAB_RADIUS := {
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
	for theme_type in [&"PrimaryButton", &"DangerButton"]:
		var stylebox := theme.get_stylebox(&"normal", theme_type) as StyleBoxFlat
		if stylebox == null:
			_fail("%s missing %s.normal" % [label, theme_type])
			continue
		if expect_raised:
			_expect_depth_cap(stylebox, label, theme_type, 3, 2)
		else:
			_expect_flat_edge(stylebox, label, theme_type)

	var option := theme.get_stylebox(&"normal", &"OptionButton") as StyleBoxFlat
	if option == null:
		_fail("%s missing OptionButton.normal" % label)
		return
	if expect_raised:
		_expect_depth_cap(option, label, &"OptionButton", 2, 1)
		var primary := theme.get_stylebox(&"normal", &"PrimaryButton") as StyleBoxFlat
		if primary != null and primary.border_width_bottom < option.border_width_bottom:
			_fail("%s PrimaryButton bottom edge should be at least OptionButton: primary=%d option=%d" % [
				label,
				primary.border_width_bottom,
				option.border_width_bottom,
			])
	else:
		_expect_flat_edge(option, label, &"OptionButton")


func _expect_depth_cap(stylebox: StyleBoxFlat, label: String, theme_type: StringName, max_bottom_width: int, max_extra_depth: int) -> void:
	var face_width := _face_width(stylebox)
	var extra_depth := maxi(0, stylebox.border_width_bottom - face_width)
	if stylebox.border_width_bottom <= face_width:
		_fail("%s raised %s should have a visible bottom depth edge: face=%d bottom=%d" % [
			label,
			theme_type,
			face_width,
			stylebox.border_width_bottom,
		])
	if stylebox.border_width_bottom > max_bottom_width:
		_fail("%s raised %s bottom border too deep: got %d max %d" % [
			label,
			theme_type,
			stylebox.border_width_bottom,
			max_bottom_width,
		])
	if extra_depth > max_extra_depth:
		_fail("%s raised %s extra bottom depth too large: got %d max %d" % [
			label,
			theme_type,
			extra_depth,
			max_extra_depth,
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
