extends SceneTree

const GOOD_PATH := "res://.planning/spikes/dynamic-theme/prize_pop_spike_neocade_theme.tres"
const BAD_PATH := "res://.planning/spikes/dynamic-theme/broken_no_super_spike_theme.tres"

var failures: Array[String] = []
var checks: Array[String] = []

func _init() -> void:
	_run()
	if failures.is_empty():
		print("VERIFY: PASS dynamic theme spike")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		print("VERIFY: FAIL dynamic theme spike failures=%d" % failures.size())
		quit(1)

func _run() -> void:
	var good := load(GOOD_PATH)
	var bad := load(BAD_PATH)
	_expect(good != null, "good theme loads")
	_expect(bad != null, "bad theme loads")
	if good == null or bad == null:
		return

	good._regenerate()
	bad._regenerate()

	_verify_required_subset(good)
	_verify_bad_gaps(bad)
	_verify_export_regeneration(good)
	_verify_runtime_application(good)
	_verify_platform_resolution(good)
	_verify_serialization(good)
	_expect(good.get_last_regeneration_usec() > 0, "regeneration duration hook reports non-zero usec")
	print("VERIFY: good_regeneration_usec=%d" % good.get_last_regeneration_usec())
	print("VERIFY: checks=%s" % [", ".join(checks)])

func _verify_required_subset(theme: Theme) -> void:
	var required := [
		["stylebox", "normal", "Button"],
		["stylebox", "focus", "Button"],
		["color", "font_color", "Button"],
		["constant", "prize_pop_direct_override_marker", "Button"],
		["stylebox", "normal", "OptionButton"],
		["constant", "arrow_margin", "OptionButton"],
		["color", "font_color", "CheckBox"],
		["stylebox", "normal", "LineEdit"],
		["color", "caret_color", "LineEdit"],
		["stylebox", "panel", "Tree"],
		["constant", "item_margin", "Tree"],
		["stylebox", "panel", "PopupMenu"],
		["constant", "v_separation", "PopupMenu"],
		["stylebox", "embedded_border", "Window"],
		["constant", "title_height", "Window"],
		["stylebox", "grabber", "HScrollBar"],
		["constant", "grabber_minimum_size", "HScrollBar"],
	]
	for entry in required:
		_expect(_has_entry(theme, entry[0], entry[1], entry[2]), "good has %s.%s %s" % [entry[2], entry[1], entry[0]])

func _verify_bad_gaps(theme: Theme) -> void:
	_expect(_has_entry(theme, "stylebox", "normal", "Button"), "bad has Button.normal marker")
	_expect(!_has_entry(theme, "stylebox", "normal", "LineEdit"), "bad lacks LineEdit.normal")
	_expect(!_has_entry(theme, "stylebox", "panel", "Tree"), "bad lacks Tree.panel")
	_expect(!_has_entry(theme, "stylebox", "embedded_border", "Window"), "bad lacks Window.embedded_border")

func _verify_export_regeneration(theme: Theme) -> void:
	var before: Color = theme.get_stylebox("normal", "Button").bg_color
	theme.base_color = Color("#123b4c")
	theme.accent_color = Color("#ffcc33")
	theme.raised = false
	theme.platform = 0
	theme._regenerate()
	var after: Color = theme.get_stylebox("normal", "Button").bg_color
	_expect(before != after, "export changes regenerate Button.normal color")
	_expect(theme.get_constant("grabber_minimum_size", "HScrollBar") == 28, "forced desktop resolves desktop sizing")

func _verify_runtime_application(theme: Theme) -> void:
	var root_control := Control.new()
	var button := Button.new()
	root_control.theme = theme
	root.add_child(root_control)
	root_control.add_child(button)
	_expect(button.get_theme_stylebox("normal") != null, "saved theme applies to Control tree")
	root_control.queue_free()

func _verify_platform_resolution(theme: Theme) -> void:
	_expect(theme._resolve_auto_platform(PackedStringArray(["web", "web_android"]), "Web") == 1, "web_android resolves mobile")
	_expect(theme._resolve_auto_platform(PackedStringArray(["web", "web_ios"]), "Web") == 1, "web_ios resolves mobile")
	_expect(theme._resolve_auto_platform(PackedStringArray(["web", "web_windows"]), "Web") == 0, "web_windows resolves desktop")
	_expect(theme._resolve_auto_platform(PackedStringArray(["web"]), "Web") == 1, "ambiguous web resolves mobile-preferred")
	_expect(theme._resolve_auto_platform(PackedStringArray(), OS.get_name()) in [0, 1], "local OS fallback returns known platform")

func _verify_serialization(theme: Theme) -> void:
	var save_path := "user://dynamic_theme_spike_roundtrip.tres"
	var result := ResourceSaver.save(theme, save_path)
	_expect(result == OK, "ResourceSaver saves dynamic theme")
	var loaded := load(save_path)
	_expect(loaded != null, "roundtrip dynamic theme loads")
	if loaded != null:
		loaded._regenerate()
		_expect(loaded.has_stylebox("normal", "Button"), "roundtrip keeps script-driven generation")
		_expect(loaded.has_stylebox("panel", "PopupMenu"), "roundtrip keeps PopupMenu generation")

func _has_entry(theme: Theme, kind: String, name: String, theme_type: String) -> bool:
	match kind:
		"stylebox":
			return theme.has_stylebox(name, theme_type)
		"color":
			return theme.has_color(name, theme_type)
		"constant":
			return theme.has_constant(name, theme_type)
		"font_size":
			return theme.has_font_size(name, theme_type)
		_:
			return false

func _expect(condition: bool, message: String) -> void:
	if condition:
		checks.append(message)
	else:
		failures.append(message)
