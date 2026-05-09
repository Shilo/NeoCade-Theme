extends SceneTree

const THEME_PATH := "res://addons/neocade_theme/neocade_theme.tres"

var _failures: PackedStringArray = []


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var canonical := load(THEME_PATH) as NeoCadeTheme
	if canonical == null:
		_failures.append("Could not load %s as NeoCadeTheme" % THEME_PATH)
		_finish()
		return

	for style_value in NeoCadeTheme.Style.values():
		if int(style_value) == NeoCadeTheme.Style.CUSTOM:
			continue
		_check_pair(canonical, int(style_value), NeoCadeTheme.Platform.DESKTOP)
		_check_pair(canonical, int(style_value), NeoCadeTheme.Platform.MOBILE)

	_finish()


func _check_pair(source: NeoCadeTheme, style_value: int, platform_value: int) -> void:
	var flat := _variant(source, style_value, false, platform_value)
	var raised := _variant(source, style_value, true, platform_value)
	var label := "%s/%s" % [
		NeoCadeTheme.style_label(style_value),
		"MOBILE" if platform_value == NeoCadeTheme.Platform.MOBILE else "DESKTOP",
	]

	for theme_type in raised.get_type_list():
		var styleboxes := raised.get_stylebox_list(theme_type)
		styleboxes.sort()
		for slot in styleboxes:
			if not flat.has_stylebox(slot, theme_type):
				continue
			var flat_stylebox := flat.get_stylebox(slot, theme_type) as StyleBoxFlat
			var raised_stylebox := raised.get_stylebox(slot, theme_type) as StyleBoxFlat
			if flat_stylebox == null or raised_stylebox == null:
				continue
			_check_stylebox(label, String(theme_type), String(slot), flat_stylebox, raised_stylebox)


func _variant(source: NeoCadeTheme, style_value: int, raised_value: bool, platform_value: int) -> NeoCadeTheme:
	var theme := source.duplicate(true) as NeoCadeTheme
	theme.style = style_value
	theme.raised = raised_value
	theme.platform = platform_value
	return theme


func _check_stylebox(label: String, theme_type: String, slot: String, flat: StyleBoxFlat, raised: StyleBoxFlat) -> void:
	var flat_depth := _bottom_depth(flat)
	var raised_depth := _bottom_depth(raised)
	var added_depth := maxi(0, raised_depth - flat_depth)
	if added_depth == 0:
		return

	var added_bottom_margin := int(round(raised.content_margin_bottom - flat.content_margin_bottom))
	var min_height_delta := int(round(raised.get_minimum_size().y - flat.get_minimum_size().y))
	print("RAISED_DEPTH %-12s %-30s %-24s depth=+%d margin_bottom=+%d min_h=+%d" % [
		label,
		theme_type,
		slot,
		added_depth,
		added_bottom_margin,
		min_height_delta,
	])
	if added_bottom_margin < added_depth:
		_failures.append("%s %s.%s bottom depth +%d is inset: bottom margin only +%d" % [
			label,
			theme_type,
			slot,
			added_depth,
			added_bottom_margin,
		])
	if min_height_delta < added_depth:
		_failures.append("%s %s.%s bottom depth +%d does not append enough min height: +%d" % [
			label,
			theme_type,
			slot,
			added_depth,
			min_height_delta,
		])


func _bottom_depth(stylebox: StyleBoxFlat) -> int:
	var face_width := maxi(stylebox.border_width_left, maxi(stylebox.border_width_top, stylebox.border_width_right))
	return maxi(0, stylebox.border_width_bottom - face_width)


func _finish() -> void:
	if _failures.is_empty():
		print("THEME_RAISED_DEPTH_PROBE: PASS")
	else:
		for failure in _failures:
			push_error(failure)
		print("THEME_RAISED_DEPTH_PROBE: FAIL count=%d" % _failures.size())
	quit(_failures.size())
