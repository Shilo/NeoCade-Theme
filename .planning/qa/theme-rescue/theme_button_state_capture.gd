extends SceneTree

const THEME_PATH := "res://addons/neocade_theme/neocade_theme.tres"
const SCREENSHOT_DIR := "res://.planning/qa/theme-rescue/screenshots"
const VIEWPORT_SIZE := Vector2i(1920, 1080)

var _failures: PackedStringArray = []


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var output_dir := ProjectSettings.globalize_path(SCREENSHOT_DIR)
	DirAccess.make_dir_recursive_absolute(output_dir)

	DisplayServer.window_set_size(VIEWPORT_SIZE)
	root.size = VIEWPORT_SIZE
	root.gui_embed_subwindows = true

	var canonical := load(THEME_PATH) as NeoCadeTheme
	var flat_theme := _theme_variant(canonical, false)
	var raised_theme := _theme_variant(canonical, true)

	var board := Control.new()
	board.size = VIEWPORT_SIZE
	root.add_child(board)

	var background := ColorRect.new()
	background.color = Color("#151a2e")
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	board.add_child(background)

	var stack := VBoxContainer.new()
	stack.position = Vector2(48, 42)
	stack.size = Vector2(1824, 996)
	stack.add_theme_constant_override("separation", 28)
	board.add_child(stack)

	stack.add_child(_make_title("NeoCade interactive states - Pulse / desktop"))
	stack.add_child(_make_section("Flat", flat_theme))
	stack.add_child(_make_section("Raised", raised_theme))

	await process_frame
	await process_frame
	await process_frame

	var image := root.get_texture().get_image()
	if image == null:
		_fail("renderer returned no viewport image")
	else:
		var output_path := "%s/11-pulse-button-states.png" % SCREENSHOT_DIR
		var error := image.save_png(ProjectSettings.globalize_path(output_path))
		if error != OK:
			_fail("failed saving %s error=%s" % [output_path, error])
		else:
			print("THEME_BUTTON_STATE_CAPTURE: saved %s" % output_path)

	board.queue_free()
	await process_frame

	if _failures.is_empty():
		print("THEME_BUTTON_STATE_CAPTURE: PASS")
		quit(0)
		return

	printerr("THEME_BUTTON_STATE_CAPTURE: FAIL")
	for failure in _failures:
		printerr("- " + failure)
	quit(1)


func _theme_variant(source: NeoCadeTheme, raised: bool) -> NeoCadeTheme:
	var theme := source.duplicate(true) as NeoCadeTheme
	theme.style = NeoCadeTheme.Style.PULSE
	theme.raised = raised
	theme.platform = NeoCadeTheme.Platform.DESKTOP
	return theme


func _make_title(text: String) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", 28)
	label.add_theme_color_override("font_color", Color("#f7f8fb"))
	return label


func _make_section(title: String, theme: Theme) -> VBoxContainer:
	var section := VBoxContainer.new()
	section.add_theme_constant_override("separation", 12)

	var heading := Label.new()
	heading.text = title
	heading.add_theme_font_size_override("font_size", 22)
	heading.add_theme_color_override("font_color", Color("#f7f8fb"))
	section.add_child(heading)

	var grid := GridContainer.new()
	grid.columns = 7
	grid.add_theme_constant_override("h_separation", 8)
	grid.add_theme_constant_override("v_separation", 12)
	section.add_child(grid)

	for theme_type in [&"Button", &"PrimaryButton", &"SecondaryButton", &"GhostButton", &"DangerButton", &"OptionButton", &"ColorPickerButton"]:
		grid.add_child(_make_button_column(String(theme_type), theme))

	section.add_child(_make_tab_samples(theme))
	return section


func _make_button_column(theme_type: String, theme: Theme) -> VBoxContainer:
	var column := VBoxContainer.new()
	column.custom_minimum_size = Vector2(248, 0)
	column.add_theme_constant_override("separation", 8)

	var heading := Label.new()
	heading.text = theme_type
	heading.add_theme_font_size_override("font_size", 16)
	heading.add_theme_color_override("font_color", Color("#b7bdcf"))
	column.add_child(heading)

	for state_data in [
		{"stylebox": "normal", "color": "font_color", "label": "normal"},
		{"stylebox": "hover", "color": "font_hover_color", "label": "hover"},
		{"stylebox": "pressed", "color": "font_pressed_color", "label": "pressed"},
	]:
		column.add_child(_make_state_row(theme_type, theme, state_data))

	return column


func _make_state_row(theme_type: String, theme: Theme, state_data: Dictionary) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 10)

	var state_label := Label.new()
	state_label.text = String(state_data["label"])
	state_label.custom_minimum_size = Vector2(76, 44)
	state_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	state_label.add_theme_font_size_override("font_size", 14)
	state_label.add_theme_color_override("font_color", Color("#b7bdcf"))
	row.add_child(state_label)

	var sample := PanelContainer.new()
	sample.custom_minimum_size = Vector2(150, 44)
	var stylebox_name := StringName(state_data["stylebox"])
	var stylebox := theme.get_stylebox(stylebox_name, StringName(theme_type))
	if stylebox == null:
		_fail("%s missing %s" % [theme_type, stylebox_name])
	else:
		sample.add_theme_stylebox_override("panel", stylebox)

	var text := Label.new()
	text.text = "View Prizes"
	text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	text.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	text.add_theme_font_size_override("font_size", 14)
	var color_name := StringName(state_data["color"])
	if theme.has_color(color_name, StringName(theme_type)):
		text.add_theme_color_override("font_color", theme.get_color(color_name, StringName(theme_type)))
	sample.add_child(text)
	row.add_child(sample)

	return row


func _make_tab_samples(theme: Theme) -> VBoxContainer:
	var section := VBoxContainer.new()
	section.add_theme_constant_override("separation", 8)

	var heading := Label.new()
	heading.text = "Tabs"
	heading.add_theme_font_size_override("font_size", 16)
	heading.add_theme_color_override("font_color", Color("#b7bdcf"))
	section.add_child(heading)

	var grid := GridContainer.new()
	grid.columns = 2
	grid.add_theme_constant_override("h_separation", 24)
	grid.add_theme_constant_override("v_separation", 8)
	section.add_child(grid)

	for theme_type in [&"TabBar", &"TabContainer"]:
		grid.add_child(_make_tab_column(String(theme_type), theme))

	return section


func _make_tab_column(theme_type: String, theme: Theme) -> VBoxContainer:
	var column := VBoxContainer.new()
	column.custom_minimum_size = Vector2(430, 0)
	column.add_theme_constant_override("separation", 6)

	var heading := Label.new()
	heading.text = theme_type
	heading.add_theme_font_size_override("font_size", 14)
	heading.add_theme_color_override("font_color", Color("#b7bdcf"))
	column.add_child(heading)

	for state_data in [
		{"stylebox": "tab_unselected", "color": "font_unselected_color", "label": "unselected"},
		{"stylebox": "tab_hovered", "color": "font_hovered_color", "label": "hovered"},
		{"stylebox": "tab_selected", "color": "font_selected_color", "label": "selected"},
	]:
		column.add_child(_make_state_row(theme_type, theme, state_data))

	return column


func _fail(message: String) -> void:
	_failures.append(message)
