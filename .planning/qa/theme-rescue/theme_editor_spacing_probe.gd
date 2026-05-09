extends SceneTree

const THEME_PATH := "res://addons/neocade_theme/neocade_theme.tres"
const SCRIPT_PATH := "res://addons/neocade_theme/scripts/neocade_theme.gd"

var _failures: PackedStringArray = []


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var theme := load(THEME_PATH) as NeoCadeTheme
	if theme == null:
		_fail("Could not load %s as NeoCadeTheme" % THEME_PATH)
		_finish()
		return

	_expect_shared_flat_buttons_keep_default_like_padding(theme)
	_expect_popup_spacing_and_separators(theme)
	_expect_tree_icon_button_spacing(theme)
	_expect_split_grabber_length(theme)
	_expect_spacing_source_guard()

	_finish()


func _expect_shared_flat_buttons_keep_default_like_padding(theme: Theme) -> void:
	for theme_type in [&"FlatButton", &"FlatMenuButton"]:
		for slot in [&"normal", &"hover", &"pressed", &"hover_pressed", &"disabled"]:
			var stylebox := theme.get_stylebox(slot, theme_type) as StyleBoxFlat
			if stylebox == null:
				_fail("%s.%s missing StyleBoxFlat" % [theme_type, slot])
				continue
			if stylebox.content_margin_left < 6.0 or stylebox.content_margin_right < 6.0:
				_fail("%s.%s side padding should follow Godot's wide flat-button spacing" % [theme_type, slot])
			if stylebox.content_margin_top < 4.0 or stylebox.content_margin_bottom < 4.0:
				_fail("%s.%s vertical padding should preserve a toolbar hit area" % [theme_type, slot])


func _expect_popup_spacing_and_separators(theme: Theme) -> void:
	var popup_menu_panel := theme.get_stylebox(&"panel", &"PopupMenu") as StyleBoxFlat
	if popup_menu_panel == null:
		_fail("PopupMenu.panel missing StyleBoxFlat")
	else:
		if popup_menu_panel.content_margin_left != 0.0 or popup_menu_panel.content_margin_top != 0.0 or popup_menu_panel.content_margin_right != 0.0:
			_fail("PopupMenu.panel should stay dense for normal menu lists, got margins %.1f/%.1f/%.1f/%.1f" % [
				popup_menu_panel.content_margin_left,
				popup_menu_panel.content_margin_top,
				popup_menu_panel.content_margin_right,
				popup_menu_panel.content_margin_bottom,
			])

	var popup_panel := theme.get_stylebox(&"panel", &"PopupPanel") as StyleBoxFlat
	if popup_panel == null:
		_fail("PopupPanel.panel missing StyleBoxFlat")
	else:
		if popup_panel.content_margin_left < 8.0 or popup_panel.content_margin_right < 8.0:
			_fail("PopupPanel.panel horizontal edge padding too narrow: %.1f/%.1f" % [
				popup_panel.content_margin_left,
				popup_panel.content_margin_right,
			])
		if popup_panel.content_margin_top < 6.0 or popup_panel.content_margin_bottom < 6.0:
			_fail("PopupPanel.panel vertical edge padding too narrow: %.1f/%.1f" % [
				popup_panel.content_margin_top,
				popup_panel.content_margin_bottom,
			])

	for entry in [
		{"type": &"HSeparator", "slot": &"separator", "vertical": false},
		{"type": &"VSeparator", "slot": &"separator", "vertical": true},
		{"type": &"PopupMenu", "slot": &"separator", "vertical": false},
		{"type": &"PopupMenu", "slot": &"labeled_separator_left", "vertical": false},
		{"type": &"PopupMenu", "slot": &"labeled_separator_right", "vertical": false},
	]:
		var line := theme.get_stylebox(entry["slot"], entry["type"]) as StyleBoxLine
		if line == null:
			_fail("%s.%s should use StyleBoxLine" % [entry["type"], entry["slot"]])
			continue
		if line.vertical != bool(entry["vertical"]):
			_fail("%s.%s vertical flag mismatch" % [entry["type"], entry["slot"]])
		if line.thickness < 1 or line.color.a <= 0.01:
			_fail("%s.%s should draw a visible divider" % [entry["type"], entry["slot"]])


func _expect_tree_icon_button_spacing(theme: Theme) -> void:
	for slot in [&"button_hover", &"button_pressed", &"custom_button", &"custom_button_hover", &"custom_button_pressed"]:
		var stylebox := theme.get_stylebox(slot, &"Tree") as StyleBoxFlat
		if stylebox == null:
			_fail("Tree.%s missing StyleBoxFlat" % slot)
			continue
		if stylebox.content_margin_left < 6.0 or stylebox.content_margin_right < 6.0:
			_fail("Tree.%s should reserve side padding for script/visibility/action icons" % slot)
		if stylebox.content_margin_top > 1.0 or stylebox.content_margin_bottom > 1.0:
			_fail("Tree.%s should not inflate row height" % slot)


func _expect_split_grabber_length(theme: Theme) -> void:
	for entry in [
		{"type": &"SplitContainer", "slot": &"h_grabber", "vertical": true},
		{"type": &"SplitContainer", "slot": &"v_grabber", "vertical": false},
		{"type": &"HSplitContainer", "slot": &"grabber", "vertical": true},
		{"type": &"VSplitContainer", "slot": &"grabber", "vertical": false},
	]:
		var icon := theme.get_icon(entry["slot"], entry["type"])
		var size := icon.get_size()
		if bool(entry["vertical"]):
			if size.x != 6 or size.y < 48:
				_fail("%s.%s should be 6px thick and at least 48px long, got %s" % [entry["type"], entry["slot"], size])
		elif size.y != 6 or size.x < 48:
			_fail("%s.%s should be 6px thick and at least 48px long, got %s" % [entry["type"], entry["slot"], size])


func _expect_spacing_source_guard() -> void:
	var source := FileAccess.get_file_as_string(SCRIPT_PATH)
	if source.is_empty():
		_fail("Could not read %s" % SCRIPT_PATH)
		return
	source = source.replace("\r\n", "\n")
	if source.contains("_apply_editor_wide_flat_button_styleboxes"):
		_fail("stale editor-only flat-button widening helper should be removed")
	if source.contains("Vector4i(4, 3, 4, 2)"):
		_fail("stale compact flat-button margins remain in source")
	if not source.contains("\"FlatButton\"") or not source.contains("content_margins\": Vector4i(6, 4, 6, 4)"):
		_fail("shared flat-button recipes should own 6/4/6/4 margins directly")
	if not source.contains("\"BottomPanel\": {\"role\": \"surface_panel\", \"border_role\": \"surface_panel_edge\",\n\t\t\t\t\t\t\t\"raised_intensity\": \"shape.raised_lifts.panel\",\n\t\t\t\t\t\t\t\"raised_face_edge\": true, \"content_margins\": Vector4i(0, 0, 0, 0)}"):
		_fail("EditorStyles.BottomPanel should not add an outer shell inset around Output/Audio/Shader bottom panes")
	if not source.contains("\"PopupPanel\"") or not source.contains("\"padding\": Vector2i(8, 6)"):
		_fail("PopupPanel should own dock-position/custom-popup edge padding")
	if not source.contains("\"PopupMenu\"") or not source.contains("\"padding\": Vector2i(0, 0)"):
		_fail("PopupMenu should stay dense; do not add panel padding for normal menu lists")
	if not source.contains("if not Engine.is_editor_hint():\n\t\treturn"):
		_fail("editor runtime settings must stay guarded by Engine.is_editor_hint()")


func _fail(message: String) -> void:
	_failures.append(message)
	printerr("THEME_EDITOR_SPACING_PROBE_FAIL: %s" % message)


func _finish() -> void:
	if _failures.is_empty():
		print("THEME_EDITOR_SPACING_PROBE: PASS")
		quit(0)
	else:
		for failure in _failures:
			printerr(failure)
		quit(1)
