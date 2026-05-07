extends SceneTree

## Phase 4 verification helper (headless variant). Run autonomously via:
##   godot --headless --quit --script .planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/helpers/_phase4_verify_headless.gd
## NOT distributed with the addon (lives outside addons/neocade_theme/ per Cycle 6 F3 fix —
## FOUND-01 / Phase 4 SC#1 requires exactly 1 .gd file at addon root: neocade_theme.gd).
## DELETE BEFORE v1 PUBLICATION marker retained for Phase 11 audit.

func _init() -> void:
	var path := "res://addons/neocade_theme/pulse_neocade_theme.tres"
	var loaded: Resource = ResourceLoader.load(path)
	if loaded == null:
		push_error("FAIL: ResourceLoader.load returned null for %s" % path)
		quit(1)
		return
	if not (loaded is NeoCadeTheme):
		push_error("FAIL: loaded resource is not NeoCadeTheme")
		quit(1)
		return
	var theme: NeoCadeTheme = loaded

	# Inline the same assertion logic as _phase4_verify.gd._verify_pulse() — duplicated
	# rather than `load`-ed to keep this file standalone (the helper file is a few KB; KISS).
	var failures: Array[String] = []
	if theme.base_color != Color("#151A2E"): failures.append("base_color mismatch")
	if theme.accent_color != Color("#8BFF6A"): failures.append("accent_color mismatch")
	if theme.raised: failures.append("raised should be false")
	if theme.platform != NeoCadeTheme.Platform.AUTO: failures.append("platform mismatch")
	if theme.corner_radius != 0: failures.append("corner_radius mismatch")
	if theme.spacing != 18: failures.append("spacing mismatch")
	if theme.is_light: failures.append("is_light should be false for #151A2E")
	if theme.default_font == null: failures.append("default_font not set (FONT-06)")
	if theme.default_font_size <= 0: failures.append("default_font_size not set")

	var binding_table = theme.get_script().get_script_constant_map().get("BINDING_TABLE", {})
	if binding_table.size() != 37:
		failures.append("BINDING_TABLE size %d != 37" % binding_table.size())
	var type_variations = theme.get_script().get_script_constant_map().get("TYPE_VARIATIONS", {})
	if type_variations.size() != 14:
		failures.append("TYPE_VARIATIONS size %d != 14" % type_variations.size())
	if not type_variations.has("CodeLabel"):
		failures.append("TYPE_VARIATIONS missing CodeLabel")

	if not theme.has_stylebox("normal", "Button"): failures.append("Button.normal stylebox missing")
	if not theme.has_stylebox("panel", "Tree"): failures.append("Tree.panel stylebox missing")
	if not theme.has_font("font", "HeaderLarge"): failures.append("HeaderLarge font missing")
	if not theme.has_font("font", "CodeLabel"): failures.append("CodeLabel font missing")

	# Cross-AI Cycle 2 C1 fix — CANONICAL_SLOT_NAMES iteration. Iterate the frozen
	# slot-name table and assert each declared slot exists on the loaded theme.
	var canonical_slots = theme.get_script().get_script_constant_map().get("CANONICAL_SLOT_NAMES", {})
	if canonical_slots.size() < 22:
		failures.append("CANONICAL_SLOT_NAMES freeze coverage too small: %d (expected >= 22)" % canonical_slots.size())
	for theme_type in canonical_slots.keys():
		var by_data_type: Dictionary = canonical_slots[theme_type]
		for dt in by_data_type.keys():
			var slot_list: Array = by_data_type[dt]
			for slot_name in slot_list:
				var present := false
				match dt:
					"stylebox":  present = theme.has_stylebox(slot_name, theme_type)
					"color":     present = theme.has_color(slot_name, theme_type)
					"constant":  present = theme.has_constant(slot_name, theme_type)
					"font_size": present = theme.has_font_size(slot_name, theme_type)
					"icon":      present = theme.has_icon(slot_name, theme_type)
					_: present = true
				if not present:
					failures.append("CANONICAL_SLOT_NAMES freeze fail: %s.%s.%s missing" % [theme_type, dt, slot_name])

	# Raised toggle test (Cross-AI Cycle 1 MEDIUM reconcile)
	theme.raised = true
	var raised_btn: StyleBoxFlat = theme.get_stylebox("normal", "Button") as StyleBoxFlat
	if raised_btn != null and raised_btn.shadow_size <= 0:
		failures.append("raised=true: Button.normal shadow_size %d not > 0" % raised_btn.shadow_size)
	theme.raised = false

	# Cross-AI Cycle 2 C2 fix — disabled alpha sourced from presets, not 0.38.
	var btn_disabled: Color = theme.get_color("font_disabled_color", "Button")
	if abs(btn_disabled.a - 0.42) > 0.001:
		failures.append("C2 fix regression: Button.font_disabled_color.a = %f; expected Pulse 0.42" % btn_disabled.a)

	# Cross-AI Cycle 2 M2 fix — platform tokens reach stylebox margins.
	theme.platform = NeoCadeTheme.Platform.DESKTOP
	var btn_desktop: StyleBoxFlat = theme.get_stylebox("normal", "Button") as StyleBoxFlat
	var desktop_margin: int = btn_desktop.content_margin_left if btn_desktop else -1
	theme.platform = NeoCadeTheme.Platform.MOBILE
	var btn_mobile: StyleBoxFlat = theme.get_stylebox("normal", "Button") as StyleBoxFlat
	var mobile_margin: int = btn_mobile.content_margin_left if btn_mobile else -1
	if mobile_margin <= desktop_margin:
		failures.append("M2 fix regression: MOBILE margin %d not > DESKTOP %d" % [mobile_margin, desktop_margin])
	theme.platform = NeoCadeTheme.Platform.AUTO

	# Cross-AI Cycle 2 L2 fix — Pulse vs Slate cross-direction smoke test.
	var pulse_presets: Dictionary = theme._resolve_direction_presets()
	if abs(pulse_presets.spread_factor - 1.3) > 0.001:
		failures.append("L2 fix: Pulse spread_factor %f != 1.3 (hex-key lookup falling to DEFAULT?)" % pulse_presets.spread_factor)
	var slate_test: NeoCadeTheme = NeoCadeTheme.new()
	slate_test.base_color = Color("#111820")
	var slate_presets: Dictionary = slate_test._resolve_direction_presets()
	if abs(slate_presets.spread_factor - 0.7) > 0.001:
		failures.append("L2 fix: Slate spread_factor %f != 0.7 (hex-key lookup falling to DEFAULT?)" % slate_presets.spread_factor)
	if abs(pulse_presets.spread_factor - slate_presets.spread_factor) <= 0.5:
		failures.append("L2 fix: Pulse and Slate spread_factor not differentiated (%f vs %f)" % [pulse_presets.spread_factor, slate_presets.spread_factor])

	# Cross-AI Cycle 6 F1 fix — per-direction hover_pct/pressed_pct/disabled_opacity assertions
	# vs DESIGN_TOKENS §5.1-§5.5. Catches state-layer regressions that pass L2's spread_factor
	# smoke test but ship visibly-wrong state layers.
	var f1_expected: Dictionary = {
		"151A2E": {"hover_pct": 6.0, "pressed_pct": -10.0, "disabled_opacity": 0.42},  # Pulse §5.1
		"111820": {"hover_pct": 4.0, "pressed_pct": -6.0,  "disabled_opacity": 0.50},  # Slate §5.2
		"241326": {"hover_pct": 8.0, "pressed_pct": -10.0, "disabled_opacity": 0.45},  # Bubble §5.3
		"0B2420": {"hover_pct": 6.0, "pressed_pct": -6.0,  "disabled_opacity": 0.50},  # Daybreak §5.4
		"20112E": {"hover_pct": 8.0, "pressed_pct": -12.0, "disabled_opacity": 0.45},  # Burst §5.5
	}
	for hex_key in f1_expected.keys():
		var probe: NeoCadeTheme = NeoCadeTheme.new()
		probe.base_color = Color("#" + hex_key)
		var got: Dictionary = probe._resolve_direction_presets()
		var want: Dictionary = f1_expected[hex_key]
		if abs(got.hover_pct - want.hover_pct) > 0.001:
			failures.append("F1 fix: direction %s hover_pct %f != expected %f (DESIGN_TOKENS §5)" % [hex_key, got.hover_pct, want.hover_pct])
		if abs(got.pressed_pct - want.pressed_pct) > 0.001:
			failures.append("F1 fix: direction %s pressed_pct %f != expected %f (DESIGN_TOKENS §5)" % [hex_key, got.pressed_pct, want.pressed_pct])
		if abs(got.disabled_opacity - want.disabled_opacity) > 0.001:
			failures.append("F1 fix: direction %s disabled_opacity %f != expected %f (DESIGN_TOKENS §5)" % [hex_key, got.disabled_opacity, want.disabled_opacity])

	if failures.size() > 0:
		print("FAIL — Phase 4 headless verify failures:")
		for f in failures:
			print("  - ", f)
		quit(1)
		return

	print("PASS — Phase 4 headless verification: pulse_neocade_theme.tres passes all gates.")
	quit(0)
