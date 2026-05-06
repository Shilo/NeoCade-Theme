@tool
extends "res://.planning/spikes/dynamic-theme/SpikeNeoCadeTheme.gd"
class_name PrizePopSpikeNeoCadeTheme

func _theme_profile() -> Dictionary:
	var profile := super._theme_profile()
	profile.corner_radius = 10
	profile.border_width = 2
	profile.accent_mix = 0.22
	return profile

func _after_base_regenerate(context: Dictionary) -> void:
	super._after_base_regenerate(context)

	var prize_button := _make_box(
		_mix(context.surface_raised, context.accent, 0.20),
		context.accent,
		context.radius + 2,
		context.border_width,
		context.min_touch
	)
	set_stylebox("normal", "Button", prize_button)
	set_color("font_color", "Button", _readable_on(prize_button.bg_color))
	set_constant("prize_pop_direct_override_marker", "Button", 1)
