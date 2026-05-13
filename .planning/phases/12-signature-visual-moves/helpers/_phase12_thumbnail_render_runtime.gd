extends Control

## Phase 12 SC#4 thumbnail renderer — runtime variant.
##
## Sibling of `_phase12_thumbnail_render.gd` (the EditorScript). Runs as a
## Control scene root so showcase.tscn (also a Control with anchor-full) can
## size itself to the parent. Captures the main window viewport rather than a
## SubViewport because SubViewport timing under runtime CLI is unreliable.

const CANONICAL_TRES := "res://addons/neocade_theme/neocade_theme.tres"
const SHOWCASE_SCENE := "res://showcase/showcase.tscn"
const OUTPUT_DIR := "res://.planning/phases/12-signature-visual-moves/artifacts/thumbnails"
const THUMB_W := 256
const THUMB_H := 144
const SATURATION_VALUE := 0.0


func _ready() -> void:
	print("PHASE12_THUMBNAIL: begin (runtime, main-viewport mode)")

	# Take up the whole window.
	set_anchors_preset(Control.PRESET_FULL_RECT)

	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(OUTPUT_DIR))

	var theme_res: Resource = ResourceLoader.load(CANONICAL_TRES)
	assert(theme_res != null and theme_res is NeoCadeTheme, "PHASE12_THUMBNAIL: cannot load canonical .tres")

	var scene: PackedScene = ResourceLoader.load(SHOWCASE_SCENE)
	assert(scene != null, "PHASE12_THUMBNAIL: cannot load showcase scene at %s" % SHOWCASE_SCENE)

	# Wait for the window to be fully ready and visible.
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

		# Force layout pass and wait for several render frames so the showcase
		# (with tabs, fonts, dynamic theme regeneration) actually paints.
		if instance is Control:
			(instance as Control).set_anchors_preset(Control.PRESET_FULL_RECT)

		await get_tree().create_timer(1.0).timeout
		await RenderingServer.frame_post_draw
		await get_tree().process_frame
		await RenderingServer.frame_post_draw

		var img: Image = get_viewport().get_texture().get_image()
		if img == null:
			push_error("PHASE12_THUMBNAIL: viewport.get_image() returned null for %s" % NeoCadeTheme.style_label(style_value))
			instance.queue_free()
			await get_tree().process_frame
			continue

		img.resize(THUMB_W, THUMB_H, Image.INTERPOLATE_BILINEAR)
		# adjust_bcs takes multipliers: 1.0 = no change. The EditorScript variant
		# passed 0.0/0.0 for brightness/contrast which zeros them both and produces
		# solid mid-grey. Keep brightness and contrast at 1.0; only saturation
		# changes (0.0 = greyscale).
		img.adjust_bcs(1.0, 1.0, SATURATION_VALUE)

		var style_label := NeoCadeTheme.style_label(style_value).to_lower()
		var out_path := "%s/%s-raised-true.png" % [OUTPUT_DIR, style_label]
		var save_path := ProjectSettings.globalize_path(out_path)
		var err: int = img.save_png(save_path)
		if err != OK:
			push_error("PHASE12_THUMBNAIL: save_png failed (err=%d) for %s" % [err, save_path])
		else:
			var written_size := FileAccess.get_file_as_bytes(save_path).size()
			print("PHASE12_THUMBNAIL: wrote %s (%d bytes)" % [save_path, written_size])
			success_count += 1

		instance.queue_free()
		await get_tree().process_frame
		await get_tree().process_frame

	print("PHASE12_THUMBNAIL: complete — %d/5 thumbnails at %s" % [success_count, OUTPUT_DIR])
	get_tree().quit(0 if success_count == 5 else 1)
