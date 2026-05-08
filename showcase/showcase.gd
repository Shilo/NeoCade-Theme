extends Control

const SCOREBOARD_WINDOW_MARGIN := Vector2i(24, 32)

@onready var scoreboard_window: Window = $Window
@onready var window_button: Button = %WindowButton


func _ready() -> void:
	window_button.pressed.connect(_on_window_button_pressed)
	scoreboard_window.close_requested.connect(_on_scoreboard_window_close_requested)
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
