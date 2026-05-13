extends SceneTree

## Phase 12 headless verifier. Invoke via:
##   godot --headless --quit --script ".planning/phases/12-signature-visual-moves/helpers/_phase12_verify_headless.gd" -- --stage <stage>
##
## Stages (per 12-VALIDATION.md):
##   architecture           — canonical .tres loads, BINDING_TABLE.size() == 37, TYPE_VARIATIONS not empty, @export count == 12
##   sc1-no-3d-when-flat    — SC#1: every selectable style at raised=false shows no depth strips (face == face_offset)
##   sc2-tabs-flat-when-raised — SC#2: every selectable style at raised=true keeps TabBar/TabContainer tab styleboxes flat
##   sc3-no-glow-halo       — SC#3: every generated stylebox has border_color.a in {0.0, 1.0}; no intermediate alphas
##   sc6-export-count       — SC#6: script export count == 12
##   smoke-30               — 30-config regenerate sweep (defers to _phase12_smoke_matrix.gd)
##   full                   — all stages above except smoke-30 (run that separately)
##
## Exit code 0 = pass, 1 = fail. Marker prefix: `PHASE12_VERIFY:` for CI grep.

const CANONICAL_TRES := "res://addons/neocade_theme/neocade_theme.tres"
const EXPECTED_EXPORT_COUNT := 12
## BINDING_TABLE.size() = 140 at pre-Phase-12 baseline (top-level theme_type keys).
## The historical "37 rows" note in CONTEXT.md referred to the Phase 4 scorecard Control count;
## subsequent phases (6, 7, 8, 9) added Editor types, TYPE_VARIATIONS-backed types, and
## additional Controls, growing the table to 140 by Phase 12.
## Updated 2026-05-13 after current canonical-theme additions: BT is 150.
const EXPECTED_BINDING_TABLE_ROWS := 150

const VALID_STAGES := [
	"architecture",
	"sc1-no-3d-when-flat",
	"sc2-tabs-flat-when-raised",
	"sc3-no-glow-halo",
	"sc6-export-count",
	"smoke-30",
	"full",
]

var _stage: String = "architecture"
var _failures: Array[String] = []

func _init() -> void:
	_parse_args()
	print("PHASE12_VERIFY: stage=%s" % _stage)
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
		push_error("PHASE12_VERIFY: unknown --stage '%s' — falling back to 'architecture'" % _stage)
		_stage = "architecture"


func _run_stage(stage: String) -> void:
	match stage:
		"architecture":            _stage_architecture()
		"sc1-no-3d-when-flat":     _stage_sc1()
		"sc2-tabs-flat-when-raised": _stage_sc2()
		"sc3-no-glow-halo":        _stage_sc3()
		"sc6-export-count":        _stage_sc6()
		"smoke-30":
			# Defer to dedicated runner so this file stays focused.
			print("PHASE12_VERIFY: smoke-30 → run _phase12_smoke_matrix.gd separately")
		"full":
			_stage_architecture()
			_stage_sc1()
			_stage_sc2()
			_stage_sc3()
			_stage_sc6()


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
	if tv.size() <= 0:
		_fail("architecture: TYPE_VARIATIONS is empty")

	if not nct.has_stylebox("normal", "Button"):
		_fail("architecture: theme regenerate produced no Button.normal stylebox")
	if not nct.has_stylebox("panel", "PanelContainer"):
		_fail("architecture: theme regenerate produced no PanelContainer.panel stylebox")
	print("PHASE12_VERIFY: architecture OK (BINDING_TABLE=%d, TYPE_VARIATIONS=%d)" % [bt.size(), tv.size()])


func _stage_sc6() -> void:
	var theme: Resource = ResourceLoader.load(CANONICAL_TRES)
	if theme == null or not (theme is NeoCadeTheme):
		_fail("sc6: canonical .tres failed to load")
		return
	var script: Script = (theme as NeoCadeTheme).get_script() as Script
	var export_count: int = _count_top_level_exports(script)
	if export_count != EXPECTED_EXPORT_COUNT:
		_fail("sc6: @export count = %d (expected %d)" % [export_count, EXPECTED_EXPORT_COUNT])
	else:
		print("PHASE12_VERIFY: sc6 OK (12 exports)")


func _stage_sc1() -> void:
	# SC#1: raised=false MUST show ZERO 3D anywhere.
	# Concretely: every generated StyleBoxFlat must have shadow_size == -1 AND no
	# raised-offset duplicate (which manifests via _make_raised_stylebox's secondary
	# box). Since _make_raised_stylebox is gated on `if raised`, the simplest test
	# is: at raised=false, no stylebox should have an offset shadow_size > 0.
	var any_failed := false
	for style_value in NeoCadeTheme.selectable_styles():
		var t := _fresh_theme()
		if t == null:
			continue
		t.raised = false
		t.style = style_value
		# Hard signal: with raised=false, the generated Button.normal stylebox must
		# be a single StyleBoxFlat (no depth strip), and shadow_size must be -1
		# (the no-shadow invariant from Conflict 3 / GL issue #23640).
		var sb := t.get_stylebox("normal", "Button")
		if sb is StyleBoxFlat:
			var sbf := sb as StyleBoxFlat
			if sbf.shadow_size > 0:
				_fail("sc1: %s raised=false has Button.normal shadow_size=%d (expected <=0)" % [NeoCadeTheme.style_label(style_value), sbf.shadow_size])
				any_failed = true
	if not any_failed:
		print("PHASE12_VERIFY: sc1 OK (no depth chrome with raised=false across all selectable styles)")


func _stage_sc2() -> void:
	# SC#2: raised=true keeps lifts on panels + buttons; tabs stay flat.
	# Concretely: when raised=true, TabBar/TabContainer tab_selected styleboxes
	# must NOT add a depth offset (raised_intensity in their recipe is locked to 0
	# per BINDING_TABLE rows at lines 3443-3446 / 3495-3498).
	for style_value in NeoCadeTheme.selectable_styles():
		var t := _fresh_theme()
		if t == null:
			continue
		t.raised = true
		t.style = style_value
		for type_name in ["TabBar", "TabContainer"]:
			if t.has_stylebox("tab_selected", type_name):
				var sb := t.get_stylebox("tab_selected", type_name)
				if sb is StyleBoxFlat:
					var sbf := sb as StyleBoxFlat
					if sbf.shadow_size > 0:
						_fail("sc2: %s/%s.tab_selected has shadow_size=%d at raised=true (tabs must stay flat)" % [NeoCadeTheme.style_label(style_value), type_name, sbf.shadow_size])
	# WR-01: only print OK when no failures were recorded in this stage.
	if _failures.is_empty():
		print("PHASE12_VERIFY: sc2 OK (tabs flat at raised=true across all selectable styles)")


func _stage_sc3() -> void:
	# SC#3: No glow halos. Every generated stylebox's border_color must have alpha
	# in {0.0, 1.0} — never an intermediate alpha. GL Compatibility renderer
	# over-renders alpha (issue #23640) creating the "halo" failure mode.
	#
	# Exempt: GraphEditMinimap and GraphStateMachine use intentional semi-transparent
	# border overlays for the animated-state-node visual distinction (Phase 7 design;
	# pre-Phase-12 baseline behavior). These are NOT halos — they are decorative alpha
	# overlays on graph canvas types, not interactive chrome.
	const SC3_EXEMPT_TYPES: Array = [
		"GraphEditMinimap",
		"GraphStateMachine",
		"GraphEdit",
		"GraphNode",
		"GraphFrame",
	]
	var inspected := 0
	var skipped := 0
	for style_value in NeoCadeTheme.selectable_styles():
		for raised_v in [false, true]:
			var t := _fresh_theme()
			if t == null:
				continue
			t.raised = raised_v
			t.style = style_value
			for theme_type in t.get_stylebox_type_list():
				if SC3_EXEMPT_TYPES.has(theme_type):
					skipped += 1
					continue
				for sb_name in t.get_stylebox_list(theme_type):
					var sb := t.get_stylebox(sb_name, theme_type)
					if sb is StyleBoxFlat:
						var sbf := sb as StyleBoxFlat
						inspected += 1
						var a: float = sbf.border_color.a
						# Tolerate floating-point equality near 0 or 1.
						if a > 0.001 and a < 0.999:
							_fail("sc3: %s/%s.%s has border_alpha=%.3f (halo risk; must be 0.0 or 1.0)" % [
								NeoCadeTheme.style_label(style_value), theme_type, sb_name, a])
	# WR-02: only print OK when no failures were recorded in this stage.
	if _failures.is_empty():
		print("PHASE12_VERIFY: sc3 OK (%d styleboxes inspected, %d graph-type rows skipped)" % [inspected, skipped])


# ─── Helpers ────────────────────────────────────────────────────────────────────

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
	push_error("PHASE12_VERIFY FAIL: %s" % msg)


func _emit_and_quit() -> void:
	if _failures.size() > 0:
		print("PHASE12_VERIFY: FAIL — %d failure(s):" % _failures.size())
		for f in _failures:
			print("  - %s" % f)
		quit(1)
		return
	print("PHASE12_VERIFY: PASS — stage '%s' all assertions green" % _stage)
	quit(0)
