@tool
extends EditorScript

## Phase 4 verification helper (EditorScript variant). Run via Godot Editor → File → Run.
## NOT distributed with the addon (lives outside addons/neocade_theme/ per Cycle 6 F3 fix —
## FOUND-01 / Phase 4 SC#1 requires exactly 1 .gd file at addon root: neocade_theme.gd).
## DELETE BEFORE v1 PUBLICATION marker retained for Phase 11 grep audit (no actual cleanup
## required since the file is already outside the addon).
## (Companion: _phase4_verify_headless.gd
## and _phase4_import.gd).

func _run() -> void:
	_verify_pulse()
	_verify_peers()  # Cross-AI Cycle 2 M3 fix — peer .tres runtime validation

func _verify_pulse() -> void:
	var path := "res://addons/neocade_theme/pulse_neocade_theme.tres"
	var loaded: Resource = ResourceLoader.load(path)
	assert(loaded != null, "ResourceLoader.load returned null for pulse_neocade_theme.tres")
	assert(loaded is NeoCadeTheme, "loaded resource is not a NeoCadeTheme — header form may be wrong")
	var theme: NeoCadeTheme = loaded
	assert(theme.has_stylebox("normal", "Button"), "pulse missing Button.normal stylebox after load+regenerate")

	# 1. Verify @export values
	assert(theme.base_color == Color("#151A2E"), "base_color mismatch")
	assert(theme.accent_color == Color("#8BFF6A"), "accent_color mismatch")
	assert(theme.raised == false, "raised mismatch")
	assert(theme.platform == NeoCadeTheme.Platform.AUTO, "platform mismatch")
	assert(theme.corner_radius == 0, "corner_radius mismatch")
	assert(theme.spacing == 18, "spacing mismatch")
	assert(theme.raised_strength == 3, "raised_strength mismatch")
	assert(theme.focus_thickness == 2, "focus_thickness mismatch")
	assert(theme.outline_width == 1, "outline_width mismatch")
	assert(theme.is_light == false, "is_light should be false for Pulse #151A2E")

	# 2. Verify BINDING_TABLE coverage — EXACT 37 (Cross-AI Cycle 1 C1 fix)
	var binding_table = theme.get_script().get_script_constant_map().get("BINDING_TABLE", {})
	assert(binding_table.size() == 37, "BINDING_TABLE size %d != 37 (canonical scorecard)" % binding_table.size())
	var canonical_37 := ["AcceptDialog","Button","CheckBox","CheckButton","CodeEdit","ColorPicker","ColorPickerButton","ConfirmationDialog","FileDialog","FoldableContainer","GraphEdit","HScrollBar","HSlider","HSplitContainer","ItemList","Label","LineEdit","LinkButton","MenuBar","MenuButton","OptionButton","Panel","PopupMenu","PopupPanel","ProgressBar","RichTextLabel","SpinBox","TabBar","TabContainer","TextEdit","TooltipLabel","TooltipPanel","Tree","VScrollBar","VSlider","VSplitContainer","Window"]
	for t in canonical_37:
		assert(binding_table.has(t), "BINDING_TABLE missing canonical key: %s" % t)

	var sampled_types := ["Button", "Tree", "LineEdit", "PopupMenu", "Window", "HScrollBar"]
	for t in sampled_types:
		assert(theme.has_stylebox("normal", t) or theme.has_stylebox("panel", t) or theme.has_stylebox("scroll", t) or theme.has_stylebox("embedded_border", t), "%s has no stylebox after regenerate" % t)

	# 2b. Cross-AI Cycle 2 C1 fix — CANONICAL_SLOT_NAMES iteration.
	# Iterate the frozen slot-name table from Plan 04-05 Task 2.5 and assert each declared
	# slot exists on the loaded theme. Catches wrong slot names that pass row-count checks.
	var canonical_slots = theme.get_script().get_script_constant_map().get("CANONICAL_SLOT_NAMES", {})
	assert(canonical_slots.size() >= 22, "CANONICAL_SLOT_NAMES freeze coverage too small: %d (expected >= 22)" % canonical_slots.size())
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
					_: present = true  # unknown data_type — skip
				assert(present, "CANONICAL_SLOT_NAMES freeze fail: %s.%s.%s missing" % [theme_type, dt, slot_name])

	# 3. Verify TYPE_VARIATIONS registration — EXACT 14 (Cross-AI Cycle 1 C4 fix; CodeLabel included)
	var type_variations = theme.get_script().get_script_constant_map().get("TYPE_VARIATIONS", {})
	assert(type_variations.size() == 14, "TYPE_VARIATIONS size %d != 14" % type_variations.size())
	assert(type_variations.has("CodeLabel"), "TYPE_VARIATIONS missing CodeLabel (Cross-AI Cycle 1 C4)")
	for variation in type_variations.keys():
		var base_type: String = type_variations[variation]
		assert(theme.get_type_variation_base(variation) == base_type,
			"%s should derive from %s" % [variation, base_type])

	# 3b. Verify theme defaults are set (Cross-AI Cycle 1 C3 fix; FONT-06)
	assert(theme.default_font != null, "theme.default_font not set (Cross-AI Cycle 1 C3)")
	assert(theme.default_font_size > 0, "theme.default_font_size not set")

	# 4. Verify explicit fonts on header + code variations (PITFALLS 1.2)
	for v in ["HeaderLarge", "HeaderMedium", "HeaderSmall", "Caption", "CodeLabel", "InfoText"]:
		assert(theme.has_font("font", v), "%s missing explicit font (PITFALLS 1.2)" % v)

	# 5. Spot-check 3 derived values
	var btn_normal: StyleBox = theme.get_stylebox("normal", "Button")
	assert(btn_normal != null, "Button.normal stylebox null")
	var label_color: Color = theme.get_color("font_color", "Label")
	assert(label_color != Color(0, 0, 0, 1), "Label.font_color is engine default — derivation didn't run")

	# 6. Toggle test: raised true → false → check shadow_size flips
	theme.raised = true
	var btn_raised: StyleBoxFlat = theme.get_stylebox("normal", "Button") as StyleBoxFlat
	if btn_raised:
		assert(btn_raised.shadow_size > 0, "raised=true should set shadow_size > 0")
	theme.raised = false
	var btn_flat: StyleBoxFlat = theme.get_stylebox("normal", "Button") as StyleBoxFlat
	if btn_flat:
		assert(btn_flat.shadow_size == -1, "raised=false should set shadow_size = -1")

	# 7. is_light flip test
	theme.base_color = Color("#F0F0F0")
	assert(theme.is_light == true, "is_light should flip to true on #F0F0F0")
	var light_label_color: Color = theme.get_color("font_color", "Label")
	assert(light_label_color.r < 0.5, "is_light=true should produce dark text (#1B2230 family)")
	# Revert
	theme.base_color = Color("#151A2E")

	# 8. Cross-AI Cycle 2 C2 fix — disabled alpha sourced from DIRECTION_PRESETS, not 0.38.
	# Pulse's DIRECTION_PRESETS sub-dict has disabled_opacity = 0.42; Button's
	# font_disabled_color recipe carries "disabled": true so its alpha equals 0.42.
	var btn_disabled: Color = theme.get_color("font_disabled_color", "Button")
	assert(abs(btn_disabled.a - 0.42) < 0.001,
		"C2 fix regression: Button.font_disabled_color.a = %f; expected Pulse's 0.42" % btn_disabled.a)

	# 9. Cross-AI Cycle 2 M2 fix — platform tokens reach stylebox margins.
	# Toggling MOBILE produces visibly larger Button.normal content_margin than DESKTOP.
	theme.platform = NeoCadeTheme.Platform.DESKTOP
	var btn_desktop: StyleBoxFlat = theme.get_stylebox("normal", "Button") as StyleBoxFlat
	var desktop_margin: int = btn_desktop.content_margin_left if btn_desktop else -1
	theme.platform = NeoCadeTheme.Platform.MOBILE
	var btn_mobile: StyleBoxFlat = theme.get_stylebox("normal", "Button") as StyleBoxFlat
	var mobile_margin: int = btn_mobile.content_margin_left if btn_mobile else -1
	assert(mobile_margin > desktop_margin,
		"M2 fix regression: MOBILE margin %d not > DESKTOP %d (densityScale/tapPadding not wired)" % [mobile_margin, desktop_margin])
	# Revert
	theme.platform = NeoCadeTheme.Platform.AUTO

	# 10. Cross-AI Cycle 2 L2 fix — cross-direction smoke test (Pulse spread != Slate spread).
	# Construct a transient Slate to verify hex-key lookup works under .tres reload.
	# If both directions resolve to DIRECTION_PRESET_DEFAULT (1.0) due to float round-trip,
	# this assertion fails — surfacing the silent-fallback regression.
	var pulse_presets: Dictionary = theme._resolve_direction_presets()
	assert(abs(pulse_presets.spread_factor - 1.3) < 0.001,
		"L2 fix: Pulse spread_factor %f != 1.3 (hex-key lookup may be falling through to DEFAULT)" % pulse_presets.spread_factor)
	var slate_test: NeoCadeTheme = NeoCadeTheme.new()
	slate_test.base_color = Color("#111820")
	var slate_presets: Dictionary = slate_test._resolve_direction_presets()
	assert(abs(slate_presets.spread_factor - 0.7) < 0.001,
		"L2 fix: Slate spread_factor %f != 0.7 (hex-key lookup may be falling through to DEFAULT)" % slate_presets.spread_factor)
	assert(abs(pulse_presets.spread_factor - slate_presets.spread_factor) > 0.5,
		"L2 fix: Pulse and Slate spread_factor too close (%f vs %f) — directions not differentiated" % [pulse_presets.spread_factor, slate_presets.spread_factor])

	# 11. Cross-AI Cycle 6 F1 fix — per-direction hover_pct / pressed_pct / disabled_opacity
	# value assertions vs DESIGN_TOKENS §5.1-§5.5. The L2 smoke test only checks spread_factor;
	# F1 caught state-layer pct regressions that passed L2 but shipped wrong values. Per-direction
	# expected values (DESIGN_TOKENS §5.x verbatim):
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
		assert(abs(got.hover_pct - want.hover_pct) < 0.001,
			"F1 fix: direction %s hover_pct %f != expected %f (DESIGN_TOKENS §5)" % [hex_key, got.hover_pct, want.hover_pct])
		assert(abs(got.pressed_pct - want.pressed_pct) < 0.001,
			"F1 fix: direction %s pressed_pct %f != expected %f (DESIGN_TOKENS §5)" % [hex_key, got.pressed_pct, want.pressed_pct])
		assert(abs(got.disabled_opacity - want.disabled_opacity) < 0.001,
			"F1 fix: direction %s disabled_opacity %f != expected %f (DESIGN_TOKENS §5)" % [hex_key, got.disabled_opacity, want.disabled_opacity])

	print("✓ Phase 4 verification: pulse_neocade_theme.tres passes all gates.")


## Cross-AI Cycle 2 M3 fix — peer .tres runtime validation.
## Loads each of the 4 peer files via ResourceLoader, asserts is NeoCadeTheme,
## asserts has_stylebox("normal", "Button") (proving _regenerate_theme ran),
## and asserts the per-direction spread_factor matches DIRECTION_PRESETS.
func _verify_peers() -> void:
	var peers := [
		{"file": "slate_neocade_theme.tres",    "expected_spread": 0.7, "base": Color("#111820")},
		{"file": "bubble_neocade_theme.tres",   "expected_spread": 1.0, "base": Color("#241326")},
		{"file": "daybreak_neocade_theme.tres", "expected_spread": 1.0, "base": Color("#0B2420")},
		{"file": "burst_neocade_theme.tres",    "expected_spread": 1.3, "base": Color("#20112E")},
	]
	for d in peers:
		var path: String = "res://addons/neocade_theme/" + str(d.file)
		var loaded: Resource = ResourceLoader.load(path)
		assert(loaded != null, "peer load null: %s" % d.file)
		assert(loaded is NeoCadeTheme, "peer not NeoCadeTheme: %s" % d.file)
		var t: NeoCadeTheme = loaded
		assert(t.has_stylebox("normal", "Button"), "peer %s missing Button.normal stylebox" % d.file)
		assert(t.base_color == d.base, "peer %s base_color mismatch" % d.file)
		var presets: Dictionary = t._resolve_direction_presets()
		assert(abs(presets.spread_factor - d.expected_spread) < 0.001,
			"peer %s spread_factor %f != expected %f (hex-key lookup falling to DEFAULT?)"
				% [d.file, presets.spread_factor, d.expected_spread])
	print("✓ Phase 4 peer verification: 4 peer .tres files load + differentiate correctly.")
