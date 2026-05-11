extends SceneTree

## Phase 13 headless verifier. Invoke via:
##   godot --headless --quit --script ".planning/phases/13-role-variations/helpers/_phase13_verify_headless.gd" -- --stage <stage>
##
## Stages (per 13-VALIDATION.md):
##   architecture                     — canonical .tres loads, BINDING_TABLE.size() == 149, TYPE_VARIATIONS == 56, @export == 12
##   role-variations-registered       — SC#2 part 1: 9 new keys exist in TYPE_VARIATIONS + live theme registries
##   role-variations-in-showcase      — SC#2 part 2: showcase.tscn contains 9 nodes with the expected theme_type_variation
##   default-chrome-unchanged         — SC#3: Label.font_color and PanelContainer.panel resolve to non-role-color values
##   role-label-fonts                 — Pitfall 2/6: each Role Label has an explicit `font` slot (and font_size)
##   full                             — all stages above
##
## Exit code 0 = pass, 1 = fail. Marker prefix: `PHASE13_VERIFY:` for CI grep.

const CANONICAL_TRES := "res://addons/neocade_theme/neocade_theme.tres"
const SHOWCASE_SCENE := "res://showcase/showcase.tscn"
const EXPECTED_EXPORT_COUNT := 12
const EXPECTED_BINDING_TABLE_ROWS := 149  # Phase 12 baseline 140 + 9 Phase 13 additions
const EXPECTED_TYPE_VARIATIONS_COUNT := 56  # Phase 12 baseline 47 + 9 Phase 13 additions
const PHASE_13_NEW_LABEL_VARIATIONS := ["SuccessLabel", "WarningLabel", "DangerLabel", "InfoLabel"]
const PHASE_13_NEW_PANEL_VARIATIONS := ["AccentPanel", "InfoPanel", "WarningPanel", "DangerPanel", "SuccessPanel"]
const PHASE_13_ROLE_KEYS_FOR_LABELS := {
	"SuccessLabel": "role_success",
	"WarningLabel": "role_warning",
	"DangerLabel":  "role_danger",
	"InfoLabel":    "role_info",
}
const PHASE_13_ROLE_KEYS_FOR_PANELS := {
	"AccentPanel":  "role_primary",
	"InfoPanel":    "role_info",
	"WarningPanel": "role_warning",
	"DangerPanel":  "role_danger",
	"SuccessPanel": "role_success",
}

const VALID_STAGES := [
	"architecture",
	"role-variations-registered",
	"role-variations-in-showcase",
	"default-chrome-unchanged",
	"role-label-fonts",
	"full",
]

var _stage: String = "architecture"
var _failures: Array[String] = []


func _init() -> void:
	_parse_args()
	print("PHASE13_VERIFY: stage=%s" % _stage)
	_run_stage(_stage)
	_emit_and_quit()


func _parse_args() -> void:
	# Godot 4.6 splits CLI at the literal `--`. User script args come from
	# OS.get_cmdline_user_args(); fall back to OS.get_cmdline_args() if the
	# caller forgot the separator.
	var sources := [OS.get_cmdline_user_args(), OS.get_cmdline_args()]
	var found := false
	for source in sources:
		var args: PackedStringArray = source
		var i := 0
		while i < args.size():
			var a: String = args[i]
			if a == "--stage" and i + 1 < args.size():
				_stage = args[i + 1]
				found = true
				break
			i += 1
		if found:
			break
	if not VALID_STAGES.has(_stage):
		push_error("PHASE13_VERIFY: unknown --stage '%s' — falling back to 'architecture'" % _stage)
		_stage = "architecture"


func _run_stage(stage: String) -> void:
	match stage:
		"architecture":                   _stage_architecture()
		"role-variations-registered":     _stage_role_variations_registered()
		"role-variations-in-showcase":    _stage_role_variations_in_showcase()
		"default-chrome-unchanged":       _stage_default_chrome_unchanged()
		"role-label-fonts":               _stage_role_label_fonts()
		"full":
			_stage_architecture()
			_stage_role_variations_registered()
			_stage_role_variations_in_showcase()
			_stage_default_chrome_unchanged()
			_stage_role_label_fonts()


# ─── Stage implementations ──────────────────────────────────────────────────────

func _stage_architecture() -> void:
	var theme: Resource = ResourceLoader.load(CANONICAL_TRES)
	if theme == null:
		_fail("architecture: canonical .tres failed to load (%s)" % CANONICAL_TRES)
		return
	if not (theme is NeoCadeTheme):
		_fail("architecture: loaded resource is not a NeoCadeTheme")
		return
	var nct: NeoCadeTheme = theme

	var script: Script = nct.get_script() as Script
	var consts: Dictionary = script.get_script_constant_map()
	var bt: Dictionary = consts.get("BINDING_TABLE", {})
	if bt.size() != EXPECTED_BINDING_TABLE_ROWS:
		_fail("architecture: BINDING_TABLE.size() = %d (expected %d)" % [bt.size(), EXPECTED_BINDING_TABLE_ROWS])
	var tv: Dictionary = consts.get("TYPE_VARIATIONS", {})
	if tv.size() != EXPECTED_TYPE_VARIATIONS_COUNT:
		_fail("architecture: TYPE_VARIATIONS.size() = %d (expected %d)" % [tv.size(), EXPECTED_TYPE_VARIATIONS_COUNT])

	var export_count: int = _count_top_level_exports(script)
	if export_count != EXPECTED_EXPORT_COUNT:
		_fail("architecture: @export count = %d (expected %d)" % [export_count, EXPECTED_EXPORT_COUNT])

	if not nct.has_stylebox("normal", "Button"):
		_fail("architecture: theme regenerate produced no Button.normal stylebox")
	if not nct.has_stylebox("panel", "PanelContainer"):
		_fail("architecture: theme regenerate produced no PanelContainer.panel stylebox")
	# WR-01 gate: only print OK when no failures were recorded in this stage.
	if _failures.is_empty():
		print("PHASE13_VERIFY: architecture OK (BINDING_TABLE=%d, TYPE_VARIATIONS=%d, exports=%d)" % [bt.size(), tv.size(), export_count])


func _stage_role_variations_registered() -> void:
	# SC#2 part 1: TYPE_VARIATIONS registry includes 9 new keys; theme runtime has the slots.
	var theme: NeoCadeTheme = _fresh_theme()
	if theme == null:
		return
	var script: Script = theme.get_script() as Script
	var tv: Dictionary = script.get_script_constant_map().get("TYPE_VARIATIONS", {})
	for v in PHASE_13_NEW_LABEL_VARIATIONS + PHASE_13_NEW_PANEL_VARIATIONS:
		if not tv.has(v):
			_fail("role-variations-registered: TYPE_VARIATIONS missing %s" % v)
	for v in PHASE_13_NEW_LABEL_VARIATIONS:
		if tv.get(v) != "Label":
			_fail("role-variations-registered: %s base type = %s (expected Label)" % [v, tv.get(v)])
	for v in PHASE_13_NEW_PANEL_VARIATIONS:
		if tv.get(v) != "PanelContainer":
			_fail("role-variations-registered: %s base type = %s (expected PanelContainer)" % [v, tv.get(v)])
	# Live registry: each Label variation must produce a font_color binding.
	for v in PHASE_13_NEW_LABEL_VARIATIONS:
		if not theme.has_color("font_color", v):
			_fail("role-variations-registered: theme.has_color(font_color, %s) == false" % v)
	# Live registry: each Panel variation must produce a panel stylebox.
	for v in PHASE_13_NEW_PANEL_VARIATIONS:
		if not theme.has_stylebox("panel", v):
			_fail("role-variations-registered: theme.has_stylebox(panel, %s) == false" % v)
	# WR-01 gate: only print OK when no failures were recorded in this stage.
	if _failures.is_empty():
		print("PHASE13_VERIFY: role-variations-registered OK (9 new variations live)")


func _stage_role_variations_in_showcase() -> void:
	# SC#2 part 2: showcase.tscn contains 9 nodes with the expected theme_type_variation values.
	var scene: PackedScene = ResourceLoader.load(SHOWCASE_SCENE)
	if scene == null:
		_fail("role-variations-in-showcase: failed to load %s" % SHOWCASE_SCENE)
		return
	var root: Node = scene.instantiate()
	if root == null:
		_fail("role-variations-in-showcase: scene.instantiate() returned null")
		return

	var found: Dictionary = {}
	_walk_collect_variations(root, found)

	var expected: Array = PHASE_13_NEW_LABEL_VARIATIONS + PHASE_13_NEW_PANEL_VARIATIONS
	for v in expected:
		if not found.has(v):
			_fail("role-variations-in-showcase: no node with theme_type_variation == %s in showcase.tscn" % v)

	root.queue_free()
	# WR-02 gate: only print OK when no failures were recorded in this stage.
	if _failures.is_empty():
		print("PHASE13_VERIFY: role-variations-in-showcase OK (all 9 variation nodes present in showcase.tscn)")


func _stage_default_chrome_unchanged() -> void:
	# SC#3: Default Label.font_color must NOT resolve to any role_* color.
	# Default PanelContainer.panel.bg_color must NOT have a translucent alpha
	# (would indicate the panel chrome was rebound to a role tint).
	var theme: NeoCadeTheme = _fresh_theme()
	if theme == null:
		return
	# Phase 13 role-token literal defaults (per RESEARCH.md Example 4 lines 668-672).
	var role_success := Color("#5CC971")
	var role_warning := Color("#FFD166")
	var role_danger  := Color("#FF6E6E")
	var role_info    := Color("#5FE3FF")
	for style_value in NeoCadeTheme.selectable_styles():
		theme.style = style_value
		var default_label_color: Color = theme.get_color("font_color", "Label")
		# role_primary == accent_color (per-style). Compare against accent_color too.
		if default_label_color.is_equal_approx(role_success) \
				or default_label_color.is_equal_approx(role_warning) \
				or default_label_color.is_equal_approx(role_danger) \
				or default_label_color.is_equal_approx(role_info) \
				or default_label_color.is_equal_approx(theme.accent_color):
			_fail("default-chrome-unchanged: style=%s Label.font_color resolves to a role color (%s) — SC#3 violation" % [NeoCadeTheme.style_label(style_value), default_label_color])
		# Same check on PanelContainer.panel.bg_color — must remain opaque (Phase 12 baseline).
		var panel_sb: StyleBoxFlat = theme.get_stylebox("panel", "PanelContainer") as StyleBoxFlat
		if panel_sb != null:
			var panel_bg: Color = panel_sb.bg_color
			if panel_bg.a > 0.05 and panel_bg.a < 0.99:
				_fail("default-chrome-unchanged: style=%s PanelContainer.panel bg_color has translucent alpha %.3f — Phase 12 baseline was opaque" % [NeoCadeTheme.style_label(style_value), panel_bg.a])
	# WR-01 gate: only print OK when no failures were recorded in this stage.
	if _failures.is_empty():
		print("PHASE13_VERIFY: default-chrome-unchanged OK across all selectable styles")


func _stage_role_label_fonts() -> void:
	# Pitfall 2 / Pitfall 6 mandate (RESEARCH lines 316-321, 344-349): each Role Label
	# variation must have an explicit `font` slot AND `font_size > 0` — Godot 4.6 type
	# variations do NOT inherit fonts from their base type.
	var theme: NeoCadeTheme = _fresh_theme()
	if theme == null:
		return
	for v in PHASE_13_NEW_LABEL_VARIATIONS:
		if not theme.has_font("font", v):
			_fail("role-label-fonts: theme.has_font(font, %s) == false (PITFALLS 1.2 — explicit binding required)" % v)
		if not theme.has_font_size("font_size", v):
			_fail("role-label-fonts: theme.has_font_size(font_size, %s) == false" % v)
		else:
			var size: int = theme.get_font_size("font_size", v)
			if size <= 0:
				_fail("role-label-fonts: %s font_size = %d (expected > 0)" % [v, size])
	# WR-01 gate: only print OK when no failures were recorded in this stage.
	if _failures.is_empty():
		print("PHASE13_VERIFY: role-label-fonts OK (4 Role Labels have explicit font + font_size)")


# ─── Helpers ────────────────────────────────────────────────────────────────────

func _walk_collect_variations(node: Node, found: Dictionary) -> void:
	if node is Control:
		var v: StringName = (node as Control).theme_type_variation
		if String(v) != "":
			found[String(v)] = true
	for child in node.get_children():
		_walk_collect_variations(child, found)


func _fresh_theme() -> NeoCadeTheme:
	var loaded: Resource = ResourceLoader.load(CANONICAL_TRES)
	if loaded == null or not (loaded is NeoCadeTheme):
		_fail("could not load canonical theme")
		return null
	var dup := (loaded as NeoCadeTheme).duplicate(true)
	return dup as NeoCadeTheme


func _count_top_level_exports(script: Script) -> int:
	var count := 0
	for prop in script.get_script_property_list():
		var usage: int = int(prop.get("usage", 0))
		if (usage & PROPERTY_USAGE_SCRIPT_VARIABLE) != 0 and (usage & PROPERTY_USAGE_EDITOR) != 0 and (usage & PROPERTY_USAGE_STORAGE) != 0:
			count += 1
	return count


func _fail(msg: String) -> void:
	_failures.append(msg)
	push_error("PHASE13_VERIFY FAIL: %s" % msg)


func _emit_and_quit() -> void:
	if _failures.size() > 0:
		print("PHASE13_VERIFY: FAIL — %d failure(s):" % _failures.size())
		for f in _failures:
			print("  - %s" % f)
		quit(1)
		return
	print("PHASE13_VERIFY: PASS — stage '%s' all assertions green" % _stage)
	quit(0)
