@tool
extends SceneTree

## Phase 4 build-time smoke test — verifies the 6 .tres fonts load and pass `is` checks.
## Run via: godot --headless --script .planning/phases/04-.../helpers/_phase4_smoke.gd

func _init() -> void:
	var base := "res://addons/neocade_theme/fonts/"
	var failed := 0

	var inter_tres = ResourceLoader.load(base + "Inter-Variable.tres")
	if not (inter_tres is FontFile):
		push_error("Inter-Variable.tres is not a FontFile (got: %s)" % typeof(inter_tres))
		failed += 1
	else:
		print("[smoke] Inter-Variable.tres -> FontFile OK")

	var variants := [
		"Inter-HeaderLarge.tres",
		"Inter-HeaderMedium.tres",
		"Inter-HeaderSmall.tres",
		"Inter-Body.tres",
		"Inter-Caption.tres",
	]
	for vname in variants:
		var fv = ResourceLoader.load(base + vname)
		if not (fv is FontVariation):
			push_error("%s is not a FontVariation (got: %s)" % [vname, typeof(fv)])
			failed += 1
		else:
			print("[smoke] %s -> FontVariation OK (base_font=%s, variation_opentype=%s)" % [
				vname, fv.base_font, fv.variation_opentype])

	if failed > 0:
		push_error("[smoke] %d failures" % failed)
		quit(1)
		return
	print("[smoke] all 6 font .tres pass type assertions")
	quit(0)
