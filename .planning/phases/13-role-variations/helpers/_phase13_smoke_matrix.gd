extends SceneTree

## Phase 13 30-config smoke matrix runner.
## Invoke via: godot --headless --quit --script ".planning/phases/13-role-variations/helpers/_phase13_smoke_matrix.gd"
##
## Exits 0 if all 30 configs regenerate cleanly AND maintain invariants
## (BINDING_TABLE == 149 rows, TYPE_VARIATIONS == 56, @export count == 12, Button.normal stylebox produced,
## all 9 Phase 13 variations produce non-null bindings).
## Exits 1 on first invariant violation (with collected failure list).
##
## Note: EXPECTED_BINDING_TABLE_ROWS = 149 = Phase 12 baseline 140 + 9 Phase 13 additions.
## EXPECTED_TYPE_VARIATIONS_COUNT = 61 = Phase 12 actual baseline 52 + 9 Phase 13 additions (Plan 13-02 deviation: plan's "47 baseline" was stale).

const CANONICAL_TRES := "res://addons/neocade_theme/neocade_theme.tres"
const EXPECTED_EXPORT_COUNT := 12
const EXPECTED_BINDING_TABLE_ROWS := 149  # Phase 12 baseline 140 + 9 Phase 13 additions
const EXPECTED_TYPE_VARIATIONS_COUNT := 61  # Plan 13-02 deviation: Phase 12 actual baseline 52 + 9 Phase 13 additions (plan's "47 baseline" was stale).
const PHASE_13_NEW_LABEL_VARIATIONS := ["SuccessLabel", "WarningLabel", "DangerLabel", "InfoLabel"]
const PHASE_13_NEW_PANEL_VARIATIONS := ["AccentPanel", "InfoPanel", "WarningPanel", "DangerPanel", "SuccessPanel"]

var _failures: Array[String] = []


func _init() -> void:
	print("PHASE13_SMOKE: begin")
	var configs := _build_curated_configs()
	print("PHASE13_SMOKE: %d configs queued" % configs.size())
	assert(configs.size() == 30, "PHASE13_SMOKE: curated matrix size = %d (expected 30)" % configs.size())

	var loaded: Resource = ResourceLoader.load(CANONICAL_TRES)
	if loaded == null or not (loaded is NeoCadeTheme):
		push_error("PHASE13_SMOKE: cannot load canonical .tres")
		quit(1)
		return

	var idx := 0
	for cfg in configs:
		idx += 1
		var t: NeoCadeTheme = (loaded as NeoCadeTheme).duplicate(true) as NeoCadeTheme
		# Apply axes. CUSTOM bypasses _apply_style_exports so we set fields directly.
		if cfg.has("style"):
			t.style = cfg.style
		if cfg.has("base_color"):
			t.base_color = cfg.base_color
		if cfg.has("accent_color"):
			t.accent_color = cfg.accent_color
		t.raised = cfg.raised
		t.platform = cfg.platform

		# Phase 12 baseline invariants.
		if not t.has_stylebox("normal", "Button"):
			_failures.append("config %d (%s): no Button.normal stylebox" % [idx, _label(cfg)])
		var script: Script = t.get_script() as Script
		var consts: Dictionary = script.get_script_constant_map()
		var bt: Dictionary = consts.get("BINDING_TABLE", {})
		if bt.size() != EXPECTED_BINDING_TABLE_ROWS:
			_failures.append("config %d (%s): BINDING_TABLE = %d rows (expected %d)" % [idx, _label(cfg), bt.size(), EXPECTED_BINDING_TABLE_ROWS])
		var tv: Dictionary = consts.get("TYPE_VARIATIONS", {})
		if tv.size() != EXPECTED_TYPE_VARIATIONS_COUNT:
			_failures.append("config %d (%s): TYPE_VARIATIONS = %d (expected %d)" % [idx, _label(cfg), tv.size(), EXPECTED_TYPE_VARIATIONS_COUNT])
		var export_count: int = _count_top_level_exports(script)
		if export_count != EXPECTED_EXPORT_COUNT:
			_failures.append("config %d (%s): @export count = %d (expected %d)" % [idx, _label(cfg), export_count, EXPECTED_EXPORT_COUNT])

		# Phase 13 NEW invariants: 4 Role Label font_colors + 5 Role Panel styleboxes.
		for v in PHASE_13_NEW_LABEL_VARIATIONS:
			if not t.has_color("font_color", v):
				_failures.append("config %d (%s): missing font_color for %s" % [idx, _label(cfg), v])
		for v in PHASE_13_NEW_PANEL_VARIATIONS:
			if not t.has_stylebox("panel", v):
				_failures.append("config %d (%s): missing panel stylebox for %s" % [idx, _label(cfg), v])

	if _failures.size() > 0:
		print("PHASE13_SMOKE: FAIL — %d failure(s):" % _failures.size())
		for f in _failures:
			print("  - %s" % f)
		quit(1)
		return
	print("PHASE13_SMOKE: PASS — 30 configs regenerated cleanly, invariants held")
	quit(0)


# ─── Curated 30-config builder (per 12-RESEARCH.md § 30-config smoke matrix) ────

func _build_curated_configs() -> Array:
	var out: Array = []
	# Group 1: 5 styles × 2 raised × platform=DESKTOP × defaults (10 configs)
	for s in NeoCadeTheme.selectable_styles():
		for r in [false, true]:
			out.append({"style": s, "raised": r, "platform": NeoCadeTheme.Platform.DESKTOP})
	# Group 2: 5 styles × raised=true × platform=MOBILE × defaults (5 configs)
	for s in NeoCadeTheme.selectable_styles():
		out.append({"style": s, "raised": true, "platform": NeoCadeTheme.Platform.MOBILE})
	# Group 3: CUSTOM × 2 raised × 3 platforms × defaults (6 configs)
	for r in [false, true]:
		for p in [NeoCadeTheme.Platform.DESKTOP, NeoCadeTheme.Platform.MOBILE, NeoCadeTheme.Platform.AUTO]:
			out.append({"style": NeoCadeTheme.Style.CUSTOM, "raised": r, "platform": p})
	# Group 4: 5 styles × raised=true × AUTO × custom base/accent (5 configs)
	var custom_base := Color("#1A1A22")
	var custom_accent := Color("#E5C16C")
	for s in NeoCadeTheme.selectable_styles():
		out.append({
			"style": s,
			"raised": true,
			"platform": NeoCadeTheme.Platform.AUTO,
			"base_color": custom_base,
			"accent_color": custom_accent,
		})
	# Group 5: 4 edge cases on CUSTOM
	out.append({"style": NeoCadeTheme.Style.CUSTOM, "raised": true, "platform": NeoCadeTheme.Platform.DESKTOP,
				"base_color": Color("#000005"), "accent_color": Color("#FFFFFF")})  # very dark base
	out.append({"style": NeoCadeTheme.Style.CUSTOM, "raised": true, "platform": NeoCadeTheme.Platform.DESKTOP,
				"base_color": Color("#F5F5F5"), "accent_color": Color("#222222")})  # very light base
	out.append({"style": NeoCadeTheme.Style.CUSTOM, "raised": true, "platform": NeoCadeTheme.Platform.DESKTOP,
				"base_color": Color("#333333"), "accent_color": Color("#3A3A3A")})  # accent ≈ base (low contrast)
	out.append({"style": NeoCadeTheme.Style.CUSTOM, "raised": true, "platform": NeoCadeTheme.Platform.DESKTOP,
				"base_color": Color("#0E0E14"), "accent_color": Color("#FF6B35")})  # accent over WCAG floor
	return out


func _label(cfg: Dictionary) -> String:
	var style_label := "?"
	if cfg.has("style"):
		style_label = NeoCadeTheme.style_label(cfg.style)
	return "style=%s raised=%s platform=%s" % [style_label, cfg.raised, cfg.platform]


func _count_top_level_exports(script: Script) -> int:
	var count := 0
	for prop in script.get_script_property_list():
		var usage: int = int(prop.get("usage", 0))
		if (usage & PROPERTY_USAGE_SCRIPT_VARIABLE) != 0 and (usage & PROPERTY_USAGE_EDITOR) != 0 and (usage & PROPERTY_USAGE_STORAGE) != 0:
			count += 1
	return count
