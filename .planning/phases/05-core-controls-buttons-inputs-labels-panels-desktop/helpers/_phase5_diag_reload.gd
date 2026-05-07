extends SceneTree

func _init() -> void:
	var paths := [
		"res://addons/neocade_theme/pulse_neocade_theme.tres",
		"res://addons/neocade_theme/slate_neocade_theme.tres",
	]
	for path in paths:
		print("---- diag %s ----" % path)
		var loaded: Resource = ResourceLoader.load(path, "", ResourceLoader.CACHE_MODE_IGNORE)
		if loaded == null:
			print("  load FAILED (null)")
			continue
		print("  is NeoCadeTheme: %s" % str(loaded is NeoCadeTheme))
		print("  get_class(): %s" % loaded.get_class())
		if loaded is NeoCadeTheme:
			var t: NeoCadeTheme = loaded
			print("  base_color=%s accent=%s corner_radius=%d spacing=%d raised_strength=%d focus_thickness=%d outline_width=%d raised=%s platform=%d" % [
				t.base_color.to_html(false), t.accent_color.to_html(false),
				t.corner_radius, t.spacing, t.raised_strength,
				t.focus_thickness, t.outline_width,
				str(t.raised), t.platform,
			])
			print("  has_stylebox normal Button = %s" % str(t.has_stylebox("normal", "Button")))
			print("  get_stylebox_list(Button) size = %d" % t.get_stylebox_list("Button").size())
			print("  get_color_list(Button) size = %d" % t.get_color_list("Button").size())
	quit(0)
