extends SceneTree

## Phase 5 Plan 05-04 diagnostic: figure out why theme.has_font_size("font_size", "InfoText")
## returns true even after the production class drops the wrong slot.
## Run: <godot> --headless --path . --script .planning/.../helpers/_phase5_diag_inftext.gd
## Self-cleans by quit(0); not part of the verifier suite.

func _init() -> void:
	var theme: Theme = ResourceLoader.load("res://addons/neocade_theme/pulse_neocade_theme.tres")
	print("=== Pulse Theme InfoText/RichTextLabel inspection ===")
	print("default_font_size = %d" % theme.default_font_size)
	# InfoText
	print("--- InfoText ---")
	print("  has_font('font', 'InfoText') = %s" % theme.has_font("font", "InfoText"))
	print("  has_font('normal_font', 'InfoText') = %s" % theme.has_font("normal_font", "InfoText"))
	print("  has_font_size('font_size', 'InfoText') = %s" % theme.has_font_size("font_size", "InfoText"))
	print("  has_font_size('normal_font_size', 'InfoText') = %s" % theme.has_font_size("normal_font_size", "InfoText"))
	# RichTextLabel (base)
	print("--- RichTextLabel (base) ---")
	print("  has_font_size('font_size', 'RichTextLabel') = %s" % theme.has_font_size("font_size", "RichTextLabel"))
	print("  has_font_size('normal_font_size', 'RichTextLabel') = %s" % theme.has_font_size("normal_font_size", "RichTextLabel"))
	# Get the actual list
	print("--- get_font_size_list('InfoText') ---")
	for name in theme.get_font_size_list("InfoText"):
		print("  %s" % name)
	print("--- get_font_size_list('RichTextLabel') ---")
	for name in theme.get_font_size_list("RichTextLabel"):
		print("  %s" % name)
	quit(0)
