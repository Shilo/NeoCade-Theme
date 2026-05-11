extends Control

## Phase 12 SC#4 attestation aid — full-size renderer.
##
## Like `_phase12_thumbnail_render_runtime.gd` but writes the captured viewport
## at native 1920x1080 with NO desaturation, so the 5 per-direction visual
## moves are inspectable. The thumbnail variant remains the canonical SC#4 gate
## artifact; this one exists purely for human review when the thumbnail is too
## small to read.
##
## Output: 5 color PNGs at 1920x1080 to
## .planning/phases/12-signature-visual-moves/artifacts/fullsize/<style>-raised-true.png

const CANONICAL_TRES := "res://addons/neocade_theme/neocade_theme.tres"
const SHOWCASE_SCENE := "res://showcase/showcase.tscn"
const OUTPUT_DIR := "res://.planning/phases/12-signature-visual-moves/artifacts/fullsize"


func _ready() -> void:
	print("PHASE12_FULLSIZE: begin")

	set_anchors_preset(Control.PRESET_FULL_RECT)

	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(OUTPUT_DIR))

	var theme_res: Resource = ResourceLoader.load(CANONICAL_TRES)
	assert(theme_res != null and theme_res is NeoCadeTheme)
	var scene: PackedScene = ResourceLoader.load(SHOWCASE_SCENE)
	assert(scene != null)

	await get_tree().create_timer(0.4).timeout

	var success_count := 0

	for style_value in NeoCadeTheme.selectable_styles():
		var t: NeoCadeTheme = (theme_res as NeoCadeTheme).duplicate(true) as NeoCadeTheme
		t.style = style_value
		t.raised = true

		var instance := scene.instantiate()
		if instance is Control:
			(instance as Control).theme = t
		add_child(instance)
		if instance is Control:
			(instance as Control).set_anchors_preset(Control.PRESET_FULL_RECT)

		await get_tree().create_timer(1.0).timeout
		await RenderingServer.frame_post_draw
		await get_tree().process_frame
		await RenderingServer.frame_post_draw

		var img: Image = get_viewport().get_texture().get_image()
		if img == null:
			push_error("PHASE12_FULLSIZE: capture failed for %s" % NeoCadeTheme.style_label(style_value))
			instance.queue_free()
			await get_tree().process_frame
			continue

		var style_label := NeoCadeTheme.style_label(style_value).to_lower()
		var save_path := ProjectSettings.globalize_path("%s/%s-raised-true.png" % [OUTPUT_DIR, style_label])
		var err: int = img.save_png(save_path)
		if err != OK:
			push_error("PHASE12_FULLSIZE: save_png failed (err=%d) for %s" % [err, save_path])
		else:
			print("PHASE12_FULLSIZE: wrote %s (%d bytes)" % [save_path, FileAccess.get_file_as_bytes(save_path).size()])
			success_count += 1

		instance.queue_free()
		await get_tree().process_frame
		await get_tree().process_frame

	print("PHASE12_FULLSIZE: complete — %d/5 at %s" % [success_count, OUTPUT_DIR])
	get_tree().quit(0 if success_count == 5 else 1)
