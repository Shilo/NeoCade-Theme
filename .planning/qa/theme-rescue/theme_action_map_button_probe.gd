extends SceneTree

const OUTPUT_PATH := "res://.planning/qa/theme-rescue/action-map-button-rects.log"
const THEME_PATH := "res://addons/neocade_theme/neocade_theme.tres"

var _failures: PackedStringArray = []


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var theme := _resolve_theme()
	if theme == null:
		_fail("Could not resolve NeoCade/editor theme")
		_finish()
		return

	var tree := Tree.new()
	tree.theme = theme
	tree.theme_type_variation = &"TreeTable"
	tree.size = Vector2(360, 120)
	tree.columns = 3
	tree.hide_root = true
	tree.set_column_custom_minimum_width(1, 80)
	tree.set_column_custom_minimum_width(2, 50)
	get_root().add_child(tree)

	var item := tree.create_item()
	item.set_text(0, "action")
	item.add_button(2, theme.get_icon(&"ReloadSmall", &"EditorIcons"), 0, false, "Revert")
	item.add_button(2, theme.get_icon(&"Add", &"EditorIcons"), 1, false, "Add")
	item.add_button(2, theme.get_icon(&"Remove", &"EditorIcons"), 2, false, "Remove")

	await process_frame
	await process_frame

	var lines: PackedStringArray = []
	lines.append("TreeTable.button_margin=%d" % theme.get_constant(&"button_margin", &"TreeTable"))
	lines.append("TreeTable.h_separation=%d" % theme.get_constant(&"h_separation", &"TreeTable"))
	lines.append("TreeTable.icon_h_separation=%d" % theme.get_constant(&"icon_h_separation", &"TreeTable"))
	var button_pressed := theme.get_stylebox(&"button_pressed", &"TreeTable")
	var button_margin_left := 0.0
	var button_margin_right := 0.0
	if button_pressed != null:
		button_margin_left = button_pressed.content_margin_left
		button_margin_right = button_pressed.content_margin_right
		lines.append("TreeTable.button_pressed.min_size=%s" % button_pressed.get_minimum_size())
		lines.append("TreeTable.button_pressed.margins=%.1f,%.1f,%.1f,%.1f" % [
			button_pressed.content_margin_left,
			button_pressed.content_margin_top,
			button_pressed.content_margin_right,
			button_pressed.content_margin_bottom,
		])
	for icon_name in [&"ReloadSmall", &"Add", &"Remove"]:
		var icon := theme.get_icon(icon_name, &"EditorIcons")
		lines.append("EditorIcons.%s.size=%s" % [icon_name, icon.get_size()])

	var col_rect := tree.get_item_area_rect(item, 2)
	lines.append("item.col2=%s" % col_rect)

	var previous_right := -INF
	for button_index in range(3):
		var rect := tree.get_item_area_rect(item, 2, button_index)
		lines.append("button.%d.rect=%s" % [button_index, rect])
		if button_index > 0:
			var gap := rect.position.x - previous_right
			lines.append("button.%d.left_gap=%.1f" % [button_index, gap])
			var visual_gap := gap + button_margin_right + button_margin_left
			lines.append("button.%d.visual_icon_gap=%.1f" % [button_index, visual_gap])
			if visual_gap < 6.0:
				_fail("TreeTable action icon visual gap too small between %d and %d: %.1f" % [
					button_index - 1,
					button_index,
					visual_gap,
				])
		previous_right = rect.position.x + rect.size.x

	_write_log(lines)
	tree.queue_free()
	_finish()


func _resolve_theme() -> Theme:
	if Engine.is_editor_hint() and Engine.has_singleton("EditorInterface"):
		var editor_interface := Engine.get_singleton("EditorInterface")
		if editor_interface != null and editor_interface.has_method("get_editor_theme"):
			var editor_theme := editor_interface.call("get_editor_theme") as Theme
			if editor_theme != null:
				return editor_theme

	var theme := load(THEME_PATH) as NeoCadeTheme
	if theme != null:
		theme.style = NeoCadeTheme.Style.PULSE
		theme.raised = false
		theme.platform = NeoCadeTheme.Platform.DESKTOP
	return theme


func _write_log(lines: PackedStringArray) -> void:
	var file := FileAccess.open(OUTPUT_PATH, FileAccess.WRITE)
	if file == null:
		_fail("Could not write %s" % OUTPUT_PATH)
		return
	for line in lines:
		file.store_line(line)
	file.close()


func _fail(message: String) -> void:
	_failures.append(message)
	push_error(message)


func _finish() -> void:
	if _failures.is_empty():
		print("THEME_ACTION_MAP_BUTTON_PROBE: PASS")
		quit(0)
	else:
		for failure in _failures:
			print("THEME_ACTION_MAP_BUTTON_PROBE: FAIL %s" % failure)
		quit(1)
