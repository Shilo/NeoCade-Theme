extends SceneTree

## Phase 5 Plan 01 -- CLI smoke script.
##
## Run via:
##   <godot-cli> --headless --path . --script .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_cli_smoke.gd
##
## Purpose: prove that the resolved Godot 4.6.x CLI can:
##   1. start headless against this project,
##   2. load `res://addons/neocade_theme/pulse_neocade_theme.tres`,
##   3. cast the loaded resource to NeoCadeTheme (Phase 4 production class),
##   4. observe that load-time `_init() -> _regenerate_theme()` populated the
##      Phase 4 baseline (asserts `has_stylebox("normal", "Button")`).
##
## This is the bare-minimum proof that the CLI + the addon load path work together
## before any Phase 5 implementation plan starts using ResourceSaver, screenshots,
## or the headless verifier.
##
## NOT distributed with the addon. Lives outside addons/neocade_theme/ per the
## Phase 4 F3 path-discipline rule (addon root contains exactly 1 .gd file:
## neocade_theme.gd).

const PULSE_PATH := "res://addons/neocade_theme/pulse_neocade_theme.tres"

func _init() -> void:
	var failures: Array[String] = []

	var loaded: Resource = ResourceLoader.load(PULSE_PATH)
	if loaded == null:
		push_error("PHASE5_CLI_SMOKE FAIL: ResourceLoader.load returned null for %s" % PULSE_PATH)
		quit(1)
		return

	if not (loaded is NeoCadeTheme):
		push_error("PHASE5_CLI_SMOKE FAIL: loaded resource is not NeoCadeTheme (got %s)" % loaded.get_class())
		quit(1)
		return

	var theme: NeoCadeTheme = loaded

	# Phase 4 baseline: load-time `_init() -> _regenerate_theme()` populates Button.normal.
	if not theme.has_stylebox("normal", "Button"):
		failures.append("Pulse theme missing Button.normal stylebox after load-time regeneration")

	# Sanity: the @export values match the expected Pulse direction.
	if theme.base_color.to_html(false).to_upper() != "151A2E":
		failures.append("base_color hex mismatch (got %s, expected 151A2E)" % theme.base_color.to_html(false).to_upper())
	if theme.accent_color.to_html(false).to_upper() != "8BFF6A":
		failures.append("accent_color hex mismatch (got %s, expected 8BFF6A)" % theme.accent_color.to_html(false).to_upper())

	if failures.size() > 0:
		print("PHASE5_CLI_SMOKE FAIL -- failures:")
		for f in failures:
			print("  - ", f)
		quit(1)
		return

	print("PHASE5_CLI_SMOKE OK: pulse_neocade_theme.tres loads as NeoCadeTheme and Button.normal is populated.")
	quit(0)
