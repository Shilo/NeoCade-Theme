extends SceneTree

## Phase 12 30-config smoke matrix runner.
## Invoke via: godot --headless --quit --script ".planning/phases/12-signature-visual-moves/helpers/_phase12_smoke_matrix.gd"
##
## Exits 0 if all 30 configs regenerate cleanly AND maintain invariants
## (BINDING_TABLE == 140 rows, @export count == 12, Button.normal stylebox produced).
## Exits 1 on first invariant violation (with collected failure list).
##
## Note: EXPECTED_BINDING_TABLE_ROWS = 140 at pre-Phase-12 baseline (top-level theme_type keys).
## The historical "37 rows" note referred to the Phase 4 scorecard Control count; subsequent
## phases grew the table to 140.

const CANONICAL_TRES := "res://addons/neocade_theme/neocade_theme.tres"
const EXPECTED_EXPORT_COUNT := 12
## BINDING_TABLE.size() = 140 at pre-Phase-12 baseline (top-level theme_type keys).
const EXPECTED_BINDING_TABLE_ROWS := 140

var _failures: Array[String] = []


func _init() -> void:
	print("PHASE12_SMOKE: begin")
	var configs := _build_curated_configs()
	print("PHASE12_SMOKE: %d configs queued" % configs.size())
	assert(configs.size() == 30, "PHASE12_SMOKE: curated matrix size = %d (expected 30)" % configs.size())

	var loaded: Resource = ResourceLoader.load(CANONICAL_TRES)
	if loaded == null or not (loaded is NeoCadeTheme):
		push_error("PHASE12_SMOKE: cannot load canonical .tres")
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

		# Invariants per config.
		if not t.has_stylebox("normal", "Button"):
			_failures.append("config %d (%s): no Button.normal stylebox" % [idx, _label(cfg)])
		var script: Script = t.get_script() as Script
		var consts: Dictionary = script.get_script_constant_map()
		var bt: Dictionary = consts.get("BINDING_TABLE", {})
		if bt.size() != EXPECTED_BINDING_TABLE_ROWS:
			_failures.append("config %d (%s): BINDING_TABLE = %d rows (expected %d)" % [idx, _label(cfg), bt.size(), EXPECTED_BINDING_TABLE_ROWS])
		var export_count: int = _count_top_level_exports(script)
		if export_count != EXPECTED_EXPORT_COUNT:
			_failures.append("config %d (%s): @export count = %d (expected %d)" % [idx, _label(cfg), export_count, EXPECTED_EXPORT_COUNT])

	if _failures.size() > 0:
		print("PHASE12_SMOKE: FAIL — %d failure(s):" % _failures.size())
		for f in _failures:
			print("  - %s" % f)
		quit(1)
		return
	print("PHASE12_SMOKE: PASS — 30 configs regenerated cleanly, invariants held")
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
