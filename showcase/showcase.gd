extends Control

const SCOREBOARD_WINDOW_MARGIN := Vector2i(24, 32)
const PLATFORM_ITEMS := [
	{"label": "Auto", "value": NeoCadeTheme.Platform.AUTO},
	{"label": "Desktop", "value": NeoCadeTheme.Platform.DESKTOP},
	{"label": "Mobile", "value": NeoCadeTheme.Platform.MOBILE},
]

@onready var scoreboard_window: Window = $Window
@onready var theme_option_button: NeoCadeThemeOptionButton = $RootMargin/RootStack/HeaderPanel/HeaderMargin/HeaderStack/ControlsRow/NeoCadeThemeOptionButton
@onready var raised_check_box: CheckBox = $RootMargin/RootStack/HeaderPanel/HeaderMargin/HeaderStack/ControlsRow/RaisedCheckBox
@onready var platform_option_button: OptionButton = $RootMargin/RootStack/HeaderPanel/HeaderMargin/HeaderStack/ControlsRow/PlatformOptionButton
@onready var menu_button: MenuButton = $RootMargin/RootStack/ShowcaseTabs/Buttons/Margin/Grid/MenuButtonPanel/MenuButtonStack/Control
@onready var window_button: Button = %WindowButton

var _syncing_theme_controls := false


func _ready() -> void:
	if not theme_changed.is_connected(_on_showcase_theme_changed):
		theme_changed.connect(_on_showcase_theme_changed)
	_populate_platform_options()
	_populate_menu_button_popup()
	window_button.pressed.connect(_on_window_button_pressed)
	scoreboard_window.close_requested.connect(_on_scoreboard_window_close_requested)
	theme_option_button.theme_selected.connect(_on_theme_selected)
	raised_check_box.toggled.connect(_on_raised_check_box_toggled)
	platform_option_button.item_selected.connect(_on_platform_option_button_item_selected)
	_sync_theme_controls_from_current_theme()
	_sync_scoreboard_window_background()
	_move_scoreboard_window_to_top_right()


func _on_window_button_pressed() -> void:
	_move_scoreboard_window_to_top_right()
	scoreboard_window.popup(Rect2i(scoreboard_window.position, scoreboard_window.size))


func _on_scoreboard_window_close_requested() -> void:
	scoreboard_window.hide()


func _move_scoreboard_window_to_top_right() -> void:
	var viewport_size := Vector2i(get_viewport_rect().size)
	var top_right_x := viewport_size.x - scoreboard_window.size.x - SCOREBOARD_WINDOW_MARGIN.x
	scoreboard_window.position = Vector2i(maxi(SCOREBOARD_WINDOW_MARGIN.x, top_right_x), SCOREBOARD_WINDOW_MARGIN.y)


func _populate_platform_options() -> void:
	platform_option_button.clear()
	for platform_item in PLATFORM_ITEMS:
		platform_option_button.add_item(String(platform_item["label"]))
		platform_option_button.set_item_metadata(platform_option_button.item_count - 1, int(platform_item["value"]))


func _populate_menu_button_popup() -> void:
	var popup := menu_button.get_popup()
	if popup.item_count > 0:
		return
	for label in ["Prize vault", "Cabinet settings", "Attract mode"]:
		popup.add_item(label)


func _sync_theme_controls_from_current_theme() -> void:
	_syncing_theme_controls = true
	var current_theme := theme as NeoCadeTheme
	var has_neocade_theme := current_theme != null
	raised_check_box.disabled = not has_neocade_theme
	platform_option_button.disabled = not has_neocade_theme
	if has_neocade_theme:
		raised_check_box.button_pressed = current_theme.raised
		_select_platform(current_theme.platform)
	else:
		raised_check_box.button_pressed = false
		_select_platform(NeoCadeTheme.Platform.AUTO)
	_syncing_theme_controls = false


func _on_theme_selected(selected_theme: Theme, _index: int) -> void:
	var has_neocade_theme := selected_theme is NeoCadeTheme
	raised_check_box.disabled = not has_neocade_theme
	platform_option_button.disabled = not has_neocade_theme
	if has_neocade_theme:
		_apply_theme_controls_to_current_theme()
	_sync_scoreboard_window_background()


func _on_showcase_theme_changed() -> void:
	_sync_theme_controls_from_current_theme()
	_sync_scoreboard_window_background()


func _on_raised_check_box_toggled(_button_pressed: bool) -> void:
	_apply_theme_controls_to_current_theme()


func _on_platform_option_button_item_selected(_index: int) -> void:
	_apply_theme_controls_to_current_theme()


func _apply_theme_controls_to_current_theme() -> void:
	if _syncing_theme_controls:
		return

	var current_theme := _ensure_editable_neocade_theme()
	if current_theme == null:
		return

	current_theme.raised = raised_check_box.button_pressed
	current_theme.platform = _selected_platform()
	_sync_scoreboard_window_background()


func _sync_scoreboard_window_background() -> void:
	NeoCadeTheme.sync_inherited_window_background(scoreboard_window)


func _ensure_editable_neocade_theme() -> NeoCadeTheme:
	var current_theme := theme as NeoCadeTheme
	if current_theme == null:
		return null
	if not current_theme.resource_path.is_empty():
		current_theme = current_theme.duplicate(true) as NeoCadeTheme
		theme = current_theme
	return current_theme


func _select_platform(platform: NeoCadeTheme.Platform) -> void:
	for index in range(platform_option_button.item_count):
		if int(platform_option_button.get_item_metadata(index)) == int(platform):
			platform_option_button.select(index)
			return
	platform_option_button.select(0)


func _selected_platform() -> NeoCadeTheme.Platform:
	if platform_option_button.selected < 0:
		return NeoCadeTheme.Platform.AUTO
	return int(platform_option_button.get_item_metadata(platform_option_button.selected)) as NeoCadeTheme.Platform
