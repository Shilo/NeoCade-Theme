extends Control

## Phase 13 Role Variations visual render — Pitfall 1 contingency helper.
##
## Renders showcase.tscn at Pulse style with raised=true, captures the main window
## viewport as a full-color PNG (NOT desaturated — visual halo inspection requires color),
## saves to .planning/phases/13-role-variations/artifacts/role-variations-pulse.png.
##
## Used as Pitfall 1 evidence: if a Role Panel `bg_color.a == 0.06` produces a visible
## halo under GL Compatibility, the rendered PNG will show it. Fallback path: precompute
## the mix and inject role_table keys (RESEARCH lines 305-313).
##
## Marker prefix: `PHASE13_ROLE_RENDER:` for CI grep.
## Invoke via: godot --quit res://.planning/phases/13-role-variations/helpers/_phase13_role_render.tscn
##
## NOT auto-run by Plan 13-04's verifier suite. Only invoke if visual inspection of
## the showcase after 13-04 shows a halo on the Role Panels under GL Compatibility.

const CANONICAL_TRES := "res://addons/neocade_theme/neocade_theme.tres"
const SHOWCASE_SCENE := "res://showcase/showcase.tscn"
const OUTPUT_DIR := "res://.planning/phases/13-role-variations/artifacts"
const OUTPUT_NAME := "role-variations-pulse.png"


func _ready() -> void:
	print("PHASE13_ROLE_RENDER: begin (runtime, main-viewport mode)")

	# Take up the whole window.
	set_anchors_preset(Control.PRESET_FULL_RECT)

	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(OUTPUT_DIR))

	var theme_res: Resource = ResourceLoader.load(CANONICAL_TRES)
	assert(theme_res != null and theme_res is NeoCadeTheme, "PHASE13_ROLE_RENDER: cannot load canonical .tres")

	var scene: PackedScene = ResourceLoader.load(SHOWCASE_SCENE)
	assert(scene != null, "PHASE13_ROLE_RENDER: cannot load showcase scene at %s" % SHOWCASE_SCENE)

	# Wait for the window to be fully ready and visible.
	await get_tree().create_timer(0.4).timeout

	# Render Pulse + raised=true (the showcase default direction).
	var t: NeoCadeTheme = (theme_res as NeoCadeTheme).duplicate(true) as NeoCadeTheme
	t.style = NeoCadeTheme.Style.PULSE
	t.raised = true

	var instance := scene.instantiate()
	if instance is Control:
		(instance as Control).theme = t
		(instance as Control).set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(instance)

	# Phase 12-proven 4-step await chain that produced the SC#4 attestation PNGs.
	await get_tree().create_timer(1.0).timeout
	await RenderingServer.frame_post_draw
	await get_tree().process_frame
	await RenderingServer.frame_post_draw

	var img: Image = get_viewport().get_texture().get_image()
	if img == null:
		push_error("PHASE13_ROLE_RENDER: viewport.get_image() returned null")
		instance.queue_free()
		get_tree().quit(1)
		return

	# Phase 13: full-color full-resolution capture for halo inspection.
	# (No post-processing applied — see Phase 12 SC#4 thumbnail helper for the
	# thumbnail-greyscale precedent if a smaller PNG is ever needed.)

	var out_path := "%s/%s" % [OUTPUT_DIR, OUTPUT_NAME]
	var save_path := ProjectSettings.globalize_path(out_path)
	var err: int = img.save_png(save_path)
	if err != OK:
		push_error("PHASE13_ROLE_RENDER: save_png failed (err=%d) for %s" % [err, save_path])
		instance.queue_free()
		get_tree().quit(1)
		return

	var written_size := FileAccess.get_file_as_bytes(save_path).size()
	print("PHASE13_ROLE_RENDER: wrote %s (%d bytes)" % [save_path, written_size])

	instance.queue_free()
	await get_tree().process_frame
	get_tree().quit(0)
