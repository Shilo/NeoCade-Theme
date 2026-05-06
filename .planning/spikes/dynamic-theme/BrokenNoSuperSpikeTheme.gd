@tool
extends "res://.planning/spikes/dynamic-theme/SpikeNeoCadeTheme.gd"
class_name BrokenNoSuperSpikeTheme

func _regenerate() -> void:
	clear()
	var sb := _make_box(Color("#3d1639"), Color("#ff4fb8"), 8, 1, 32)
	set_stylebox("normal", "Button", sb)
	set_color("font_color", "Button", Color("#ffffff"))
	set_constant("broken_no_super_marker", "Button", 1)
