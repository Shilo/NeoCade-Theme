extends Control

@onready var scoreboard_window: Window = $Window
@onready var window_button: Button = %WindowButton


func _ready() -> void:
	window_button.pressed.connect(_on_window_button_pressed)
	scoreboard_window.close_requested.connect(_on_scoreboard_window_close_requested)


func _on_window_button_pressed() -> void:
	scoreboard_window.popup_centered(scoreboard_window.size)


func _on_scoreboard_window_close_requested() -> void:
	scoreboard_window.hide()
