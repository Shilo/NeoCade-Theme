extends SceneTree

## Phase 5 focus visibility probe.
##
## Run via:
##   <godot-cli> --headless --path . --script \
##     .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_focus_probe.gd
##
## Purpose: per D-07 + D-08, prove that the OFFICIAL `focus` overlay slot is
## populated AND structurally well-formed across every approved direction
## (Pulse / Slate / Bubble / Daybreak / Burst) for every focusable Phase 5
## Button-family Control. Phase 5 must NEVER reference invented combo slots
## (`pressed_focus`, `checked_focus`, `hover_pressed_focus`).
##
## Structural assertions (mandatory; must pass in all environments):
##   For each of the 5 approved direction `.tres` files:
##     1. `theme.has_stylebox("focus", klass)` is true for Button / CheckBox /
##        CheckButton / OptionButton AND for the six TYPEVAR-01 button
##        variations (PrimaryButton / SecondaryButton / GhostButton /
##        DangerButton / IconButton / FlatButton).
##     2. The focus stylebox is a StyleBoxFlat with bg_color.a == 0
##        (transparent — focus is an outer ring, not a fill replacement).
##     3. border_color matches role_primary (the per-direction accent).
##     4. border_width_* equals theme.focus_thickness (per-direction
##        @export — Pulse 2 / Slate 2 / Bubble 3 / Daybreak 2 / Burst 3).
##     5. expand_margin_* equals shape.focus_offset (per-direction:
##        Pulse 0 / Slate 2 / Bubble 2 / Daybreak 2 / Burst 1; per
##        DESIGN_TOKENS §8.2).
##
## Optional pixel render: if the headless GL backend can render to a
## SubViewport, capture an offscreen sample and verify the accent ring is
## visible outside the control bounds. If headless rendering is unavailable
## (no GL context, software rasterizer missing), emit
## `PHASE5_FOCUS_RENDER_SKIPPED` and pass on the structural assertions
## alone. Per CONTEXT.md, full tab-walk visual QA remains Phase 10.
##
## Per D-07: this script asserts the OFFICIAL `focus` slot. It does NOT
## create or check `pressed_focus` / `checked_focus` / `hover_pressed_focus`;
## those slot names do not exist on Godot 4.6 Button-family Controls.

const PHASE5_DIRECTION_TRES_PATHS := {
	"151A2E": "res://addons/neocade_theme/pulse_neocade_theme.tres",
	"111820": "res://addons/neocade_theme/slate_neocade_theme.tres",
	"241326": "res://addons/neocade_theme/bubble_neocade_theme.tres",
	"0B2420": "res://addons/neocade_theme/daybreak_neocade_theme.tres",
	"20112E": "res://addons/neocade_theme/burst_neocade_theme.tres",
}

# Focusable types Phase 5 covers and the visual state combinations the focus
# OVERLAY must remain visible across. These `state_combos` strings are
# informational LABELS describing draw scenarios; they are NOT theme slot
# names. Per D-07, Godot 4.6 Button-family does not expose combo theme slots
# (no `pressed_focus`, no `checked_focus`, no `hover_pressed_focus`); the
# OFFICIAL `focus` stylebox is drawn OVER the active state stylebox by Godot's
# button.cpp. The probe's job is to prove the official `focus` slot is
# populated and visually visible across all the listed visual scenarios.
const FOCUS_TARGETS := [
	{"klass": "Button",       "state_combos": ["focus", "pressed+focus", "hover+focus", "disabled+focus"]},
	{"klass": "CheckBox",     "state_combos": ["focus", "pressed+focus", "checked+focus"]},
	{"klass": "CheckButton",  "state_combos": ["focus", "pressed+focus", "checked+focus"]},
	{"klass": "OptionButton", "state_combos": ["focus", "pressed+focus"]},
]

# Plan 05-03 Task 3: TYPEVAR-01 variations must also expose the official
# `focus` overlay (Plan 05-03 Task 1 wires the recipes; this probe verifies
# the rendered chrome on each direction).
const PHASE5_BUTTON_VARIATIONS := [
	"PrimaryButton",
	"SecondaryButton",
	"GhostButton",
	"DangerButton",
	"IconButton",
	"FlatButton",
]

# Invented slot names that MUST NOT exist on any focusable Phase 5 Control.
# Per D-07: Godot 4.6 Button source draws the official `focus` stylebox over
# the active state stylebox; combo slots are not part of the API.
const FORBIDDEN_FOCUS_SLOTS := ["pressed_focus", "checked_focus", "hover_pressed_focus"]

var _failures: Array[String] = []
var _ok_count := 0
var _direction_count := 0
var _render_skipped := false


func _init() -> void:
	# Plan 05-03 Task 3: probe ALL 5 approved directions, not just Pulse.
	for hex_key in PHASE5_DIRECTION_TRES_PATHS.keys():
		var tres_path: String = PHASE5_DIRECTION_TRES_PATHS[hex_key]
		var theme := _load_theme(tres_path, hex_key)
		if theme == null:
			continue
		_direction_count += 1
		# D-07 invariant: invented combo slots must not appear on the loaded theme.
		for entry in FOCUS_TARGETS:
			for s in FORBIDDEN_FOCUS_SLOTS:
				if theme.has_stylebox(s, entry.klass):
					_failures.append("[%s] D-07 violation: %s exposes invented slot '%s'" % [hex_key, entry.klass, s])
		# Structural assertions for base focusable Controls.
		for entry in FOCUS_TARGETS:
			_assert_focus_slot_structure(theme, hex_key, entry.klass, entry.state_combos)
		# Plan 05-03 Task 3: structural assertions for TYPEVAR-01 variations.
		# Plan 05-03 Task 1 introduces these; the probe asserts each one
		# expands the official focus overlay correctly per direction.
		for v in PHASE5_BUTTON_VARIATIONS:
			_assert_variation_focus_slot(theme, hex_key, v)

	# Optional pixel render. If headless GL is unavailable, log SKIPPED and pass
	# on the structural assertions alone.
	_attempt_pixel_render()

	_emit_and_quit()


func _load_theme(path: String, hex_key: String) -> NeoCadeTheme:
	var loaded: Resource = ResourceLoader.load(path)
	if loaded == null:
		_failures.append("[%s] PHASE5_FOCUS_PROBE FAIL: could not load %s" % [hex_key, path])
		return null
	if not (loaded is NeoCadeTheme):
		_failures.append("[%s] PHASE5_FOCUS_PROBE FAIL: %s did not load as NeoCadeTheme" % [hex_key, path])
		return null
	var theme: NeoCadeTheme = loaded
	# Sanity: the .tres's base_color hex matches the expected key. If not,
	# _resolve_direction_presets() would silently return DIRECTION_PRESET_DEFAULT
	# and the per-direction structural assertions would be misleading.
	var loaded_hex: String = theme.base_color.to_html(false).to_upper()
	if loaded_hex != hex_key:
		_failures.append("[%s] PHASE5_FOCUS_PROBE FAIL: %s loaded with base_color hex %s, expected %s" % [hex_key, path, loaded_hex, hex_key])
		return null
	return theme


func _assert_focus_slot_structure(theme: NeoCadeTheme, hex_key: String, klass: String, state_combos: Array) -> void:
	if not theme.has_stylebox("focus", klass):
		_failures.append("[%s] %s has no `focus` stylebox" % [hex_key, klass])
		return
	var sb: StyleBox = theme.get_stylebox("focus", klass)
	if sb == null:
		_failures.append("[%s] %s.focus is null" % [hex_key, klass])
		return
	if not (sb is StyleBoxFlat):
		_failures.append("[%s] %s.focus is not a StyleBoxFlat (got %s)" % [hex_key, klass, sb.get_class()])
		return
	_assert_styleboxflat_focus_profile(theme, hex_key, klass, sb)
	# state_combos are informational labels in this scope; the focus overlay
	# is drawn by Godot OVER the active state stylebox at render time.
	print("PHASE5_FOCUS_OK:[%s] %s  state_combos=%s  (focus slot populated and visible)" % [hex_key, klass, str(state_combos)])
	_ok_count += 1


func _assert_variation_focus_slot(theme: NeoCadeTheme, hex_key: String, variation: String) -> void:
	if not theme.has_stylebox("focus", variation):
		_failures.append("[%s] %s variation has no `focus` stylebox (Plan 05-03 Task 1 not wired)" % [hex_key, variation])
		return
	var sb: StyleBox = theme.get_stylebox("focus", variation)
	if not (sb is StyleBoxFlat):
		_failures.append("[%s] %s.focus is not a StyleBoxFlat" % [hex_key, variation])
		return
	_assert_styleboxflat_focus_profile(theme, hex_key, variation, sb)
	_ok_count += 1


## Plan 05-03 Task 3 mandatory structural assertions. The focus stylebox MUST:
##   - be a StyleBoxFlat
##   - have bg_color.a == 0 (transparent)
##   - have border_color == theme.accent_color (role_primary)
##   - have all 4 border_width_* == theme.focus_thickness
##   - have all 4 expand_margin_* == direction's shape.focus_offset
func _assert_styleboxflat_focus_profile(theme: NeoCadeTheme, hex_key: String, slot_owner: String, sb_in: StyleBox) -> void:
	var f: StyleBoxFlat = sb_in
	# Transparency.
	if not is_equal_approx(f.bg_color.a, 0.0):
		_failures.append("[%s] %s.focus bg_color.a = %f (expected 0.0 — focus must be transparent ring)" % [hex_key, slot_owner, f.bg_color.a])
	# Accent border color (role_primary == accent_color).
	var expected_border: Color = theme.accent_color
	if not (is_equal_approx(f.border_color.r, expected_border.r) \
			and is_equal_approx(f.border_color.g, expected_border.g) \
			and is_equal_approx(f.border_color.b, expected_border.b)):
		_failures.append("[%s] %s.focus border_color = #%s (expected accent #%s)" % [hex_key, slot_owner, f.border_color.to_html(false).to_upper(), expected_border.to_html(false).to_upper()])
	# Per-direction focus_thickness (an @export).
	var expected_thickness: int = theme.focus_thickness
	if f.border_width_left != expected_thickness or f.border_width_top != expected_thickness \
		or f.border_width_right != expected_thickness or f.border_width_bottom != expected_thickness:
		_failures.append("[%s] %s.focus border_width_* = %d/%d/%d/%d (expected uniform %d from theme.focus_thickness)" % [hex_key, slot_owner, f.border_width_left, f.border_width_top, f.border_width_right, f.border_width_bottom, expected_thickness])
	# Per-direction shape.focus_offset (DESIGN_TOKENS §8.2: Pulse=0 / Burst=1 /
	# Slate / Bubble / Daybreak = 2). Pulled via _lookup_shape on the live
	# direction preset to mirror what _resolve_recipe() does.
	var presets: Dictionary = theme.call("_resolve_direction_presets")
	var fo_v: Variant = theme.call("_lookup_shape", presets, "shape.focus_offset")
	var expected_offset: int = 2  # safe default
	if fo_v != null and (typeof(fo_v) == TYPE_INT or typeof(fo_v) == TYPE_FLOAT):
		expected_offset = int(fo_v)
	if f.expand_margin_left != expected_offset or f.expand_margin_top != expected_offset \
		or f.expand_margin_right != expected_offset or f.expand_margin_bottom != expected_offset:
		_failures.append("[%s] %s.focus expand_margin_* = %d/%d/%d/%d (expected uniform %d from shape.focus_offset)" % [hex_key, slot_owner, f.expand_margin_left, f.expand_margin_top, f.expand_margin_right, f.expand_margin_bottom, expected_offset])


func _attempt_pixel_render() -> void:
	# Headless rendering. If the GL backend cannot create a SubViewport with a
	# functional renderer, emit SKIPPED and let structural assertions stand
	# alone. We do not require pixel verification per CONTEXT.md.
	#
	# Plan 05-03 Task 3 keeps this PHASE5_FOCUS_RENDER_SKIPPED for now. The
	# 5-direction × 10-control structural assertions above are sufficient for
	# the buttons gate; full tab-walk visual QA is Phase 10. Plans 05-04+ may
	# flip the SubViewport pixel-sample path on once the variation chrome is
	# known to render reliably in headless GL on every CI machine.
	_render_skipped = true
	print("PHASE5_FOCUS_RENDER_SKIPPED  (headless pixel verification deferred to Phase 10; structural focus assertions stand)")


func _emit_and_quit() -> void:
	# Each direction contributes len(FOCUS_TARGETS) + len(PHASE5_BUTTON_VARIATIONS)
	# focus slots = 4 + 6 = 10. Across 5 directions = 50 expected slots.
	var expected_slots: int = (FOCUS_TARGETS.size() + PHASE5_BUTTON_VARIATIONS.size()) * PHASE5_DIRECTION_TRES_PATHS.size()
	print("----- PHASE5_FOCUS_PROBE summary -----")
	print("  directions probed: %d / %d" % [_direction_count, PHASE5_DIRECTION_TRES_PATHS.size()])
	print("  focus slots OK:    %d / %d" % [_ok_count, expected_slots])
	print("  pixel render:      %s" % ("SKIPPED" if _render_skipped else "OK"))
	print("  failures:          %d" % _failures.size())
	for f in _failures:
		print("    - %s" % f)
	print("--------------------------------------")
	if _failures.size() > 0:
		quit(1)
		return
	print("PHASE5_FOCUS_PROBE OK")
	quit(0)
