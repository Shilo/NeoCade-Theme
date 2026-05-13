@tool
extends EditorScript

## Phase 12 SC#4 thumbnail renderer.
##
## **MUST RUN FROM INSIDE THE GODOT EDITOR (File -> Run on this file).** Headless
## viewport capture is unreliable without a render context; this helper accepts that
## constraint per PATTERNS.md § 11 and runs in-editor.
##
## Output: 5 greyscale PNGs at 256x144, one per selectable style (raised=true), saved to
##   .planning/phases/12-signature-visual-moves/artifacts/thumbnails/<style>-raised-true.png
##
## SC#4 gate: User opens the 5 PNGs (unlabeled), names each by direction (Pulse/Slate/
## Bubble/Daybreak/Burst). Pass requires all 5 correctly identified. Any mismatch ->
## strengthen the corresponding C6 move and re-render.
##
## Assumption A1 (RESEARCH.md): `Image.adjust_bcs(brightness, contrast, saturation)`.
## The Godot 4.6 docs are ambiguous on whether `saturation=0` or `saturation=-1`
## fully desaturates. This helper tries `0.0` first (matches the shader-equivalent at
## docs.godotengine.org screen-reading_shaders.html); if the produced PNG retains
## color, the operator manually re-runs with `SATURATION_VALUE = -1.0` toggled
## via the constant below.
##
## Usage note: This EditorScript renders via the editor's live viewport. The showcase
## scene is instantiated as a child of the editor base control, captured via
## get_viewport().get_texture().get_image(), then resized and desaturated.
## The `await` pattern from a SceneTree script is NOT available in EditorScript._run()
## (which is synchronous). Instead, layout settling is best-effort at single-frame
## capture time; for pixel-perfect results, run the script twice (first run warms
## the layout, second run captures steady-state).

const CANONICAL_TRES := "res://addons/neocade_theme/neocade_theme.tres"
const SHOWCASE_SCENE := "res://showcase/showcase.tscn"
const OUTPUT_DIR := "res://.planning/phases/12-signature-visual-moves/artifacts/thumbnails"
const THUMB_W := 256
const THUMB_H := 144
const SATURATION_VALUE := 0.0  # A1: try 0.0 first; flip to -1.0 if PNG still has color


func _run() -> void:
	print("PHASE12_THUMBNAIL: begin")

	# Ensure output directory exists.
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(OUTPUT_DIR))

	var theme_res: Resource = ResourceLoader.load(CANONICAL_TRES)
	assert(theme_res != null and theme_res is NeoCadeTheme, "PHASE12_THUMBNAIL: cannot load canonical .tres")

	var scene: PackedScene = ResourceLoader.load(SHOWCASE_SCENE)
	assert(scene != null, "PHASE12_THUMBNAIL: cannot load showcase scene at %s" % SHOWCASE_SCENE)

	var saturation := SATURATION_VALUE

	for style_value in NeoCadeTheme.selectable_styles():
		var t: NeoCadeTheme = (theme_res as NeoCadeTheme).duplicate(true) as NeoCadeTheme
		t.style = style_value
		t.raised = true

		var instance := scene.instantiate()
		# Apply our per-style theme to the root.
		if instance is Control:
			(instance as Control).theme = t

		var root := EditorInterface.get_base_control()
		root.add_child(instance)

		# Force a layout/notification pass. In-editor EditorScript._run() is synchronous;
		# the instance needs at least one notification cycle for minimum_size to propagate.
		# This is best-effort — see class docstring for the two-pass workaround.
		if instance is Control:
			(instance as Control).notification(Control.NOTIFICATION_RESIZED)

		# Capture viewport.
		var img: Image = (instance as Control).get_viewport().get_texture().get_image()
		if img == null:
			push_error("PHASE12_THUMBNAIL: viewport.get_image() returned null for %s" % NeoCadeTheme.style_label(style_value))
			instance.queue_free()
			continue

		# Resize then desaturate.
		# Image.adjust_bcs(brightness, contrast, saturation) takes MULTIPLIERS where
		# 1.0 = no change. The previous (0.0, 0.0, ...) zeroed brightness and contrast,
		# producing solid mid-grey output regardless of source. Discovered 2026-05-11
		# during SC#4 attestation; siblings _phase12_*_runtime.gd carry the same fix.
		img.resize(THUMB_W, THUMB_H, Image.INTERPOLATE_BILINEAR)
		img.adjust_bcs(1.0, 1.0, saturation)

		var style_label := NeoCadeTheme.style_label(style_value).to_lower()
		var out_path := "%s/%s-raised-true.png" % [OUTPUT_DIR, style_label]
		var save_path := ProjectSettings.globalize_path(out_path)
		var err: int = img.save_png(save_path)
		if err != OK:
			push_error("PHASE12_THUMBNAIL: save_png failed (err=%d) for %s" % [err, save_path])
		else:
			print("PHASE12_THUMBNAIL: wrote %s" % save_path)

		instance.queue_free()

	print("PHASE12_THUMBNAIL: complete — 5 thumbnails at %s" % OUTPUT_DIR)
	print("PHASE12_THUMBNAIL: SC#4 NEXT — present unlabeled PNGs to user for identification attestation")
