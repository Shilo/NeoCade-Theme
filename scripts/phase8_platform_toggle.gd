extends Control

const PULSE_THEME := preload("res://addons/neocade_theme/pulse_neocade_theme.tres")

var _theme: NeoCadeTheme
var _platforms := [
	NeoCadeTheme.Platform.DESKTOP,
	NeoCadeTheme.Platform.MOBILE,
	NeoCadeTheme.Platform.AUTO,
]
var _platform_index := 0
var _platform_button: Button
var _raised_toggle: CheckButton

func _ready() -> void:
	_theme = (PULSE_THEME as NeoCadeTheme).duplicate(true)
	theme = _theme
	_build_controls()
	_apply_state()

func _build_controls() -> void:
	var root := MarginContainer.new()
	root.add_theme_constant_override("margin_left", 24)
	root.add_theme_constant_override("margin_top", 24)
	root.add_theme_constant_override("margin_right", 24)
	root.add_theme_constant_override("margin_bottom", 24)
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(root)

	var stack := VBoxContainer.new()
	stack.add_theme_constant_override("separation", 12)
	root.add_child(stack)

	var toolbar := HBoxContainer.new()
	toolbar.add_theme_constant_override("separation", 12)
	stack.add_child(toolbar)

	_platform_button = Button.new()
	_platform_button.pressed.connect(_cycle_platform)
	toolbar.add_child(_platform_button)

	_raised_toggle = CheckButton.new()
	_raised_toggle.text = "Raised"
	_raised_toggle.toggled.connect(_set_raised)
	toolbar.add_child(_raised_toggle)

	var button := Button.new()
	button.text = "Button"
	stack.add_child(button)

	var line_edit := LineEdit.new()
	line_edit.text = "LineEdit"
	stack.add_child(line_edit)

	var check_box := CheckBox.new()
	check_box.text = "CheckBox"
	check_box.button_pressed = true
	stack.add_child(check_box)

	var option := OptionButton.new()
	option.add_item("OptionButton")
	option.add_item("Second")
	stack.add_child(option)

	var tabs := TabBar.new()
	tabs.add_tab("TabBar")
	tabs.add_tab("Mobile")
	tabs.add_tab("Auto")
	stack.add_child(tabs)

func _cycle_platform() -> void:
	_platform_index = (_platform_index + 1) % _platforms.size()
	_apply_state()

func _set_raised(enabled: bool) -> void:
	_theme.raised = enabled
	_apply_state()

func _apply_state() -> void:
	if _theme == null:
		return
	_theme.platform = _platforms[_platform_index]
	_theme.raised = _raised_toggle.button_pressed if _raised_toggle != null else _theme.raised
	theme = _theme
	if _platform_button != null:
		_platform_button.text = _platform_name(_theme.platform)

func _platform_name(value: NeoCadeTheme.Platform) -> String:
	match value:
		NeoCadeTheme.Platform.DESKTOP:
			return "DESKTOP"
		NeoCadeTheme.Platform.MOBILE:
			return "MOBILE"
		NeoCadeTheme.Platform.AUTO:
			return "AUTO"
	return "DESKTOP"
