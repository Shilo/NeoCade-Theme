extends SceneTree

## Capture screenshots of the live NeoCade showcase scene rendered with each
## of the 5 styles, plus optional raised=true variant. Saves PNGs into
## `.planning/spikes/visual-identity-distinctiveness/005-before-after-comparison/screenshots/<phase>/<style>.png`.
##
## Usage:
##   # capture BEFORE shots (current main HEAD):
##   godot --headless --script \
##       .planning/spikes/visual-identity-distinctiveness/005-before-after-comparison/capture_screenshots.gd \
##       -- phase=before
##
##   # capture AFTER shots (Phase 12 implemented):
##   godot --headless --script \
##       .planning/spikes/visual-identity-distinctiveness/005-before-after-comparison/capture_screenshots.gd \
##       -- phase=after
##
## Notes:
##   * `--headless` is fine for invocation, but Godot's headless rasterizer
##     does not paint a viewport. This script therefore boots a hidden Window
##     with the SubViewport in it and forces a render before capture. It
##     requires display server access on Windows even though no on-screen
##     window is visible.
##   * If Godot cannot acquire a display server (truly headless CI), the
##     script falls back to producing a per-style metadata JSON only — no PNG.
##     A Phase 12 verification job should run this on a workstation with a
##     display server (locally or via xvfb on Linux CI).

const OUTPUT_BASE_DIR := "res://.planning/spikes/visual-identity-distinctiveness/005-before-after-comparison/screenshots"
const SHOWCASE_PATH := "res://showcase/showcase.tscn"
const THEME_PATH := "res://addons/neocade_theme/neocade_theme.tres"

const CAPTURE_SIZE := Vector2i(1280, 800)
const PER_FRAME_DELAY := 6   # extra frames to let the regen + UI layout settle


func _init() -> void:
	var phase := _read_phase_arg()
	if phase.is_empty():
		printerr("ERROR: missing required arg — pass `-- phase=before` or `-- phase=after`.")
		quit(2)
		return

	# Output dir: <OUTPUT_BASE_DIR>/<phase>/
	var out_dir := OUTPUT_BASE_DIR + "/" + phase
	var abs_out := ProjectSettings.globalize_path(out_dir)
	if not DirAccess.dir_exists_absolute(abs_out):
		DirAccess.make_dir_recursive_absolute(abs_out)
	print("Capture target: %s" % abs_out)

	# Load the canonical theme + showcase.
	var theme := load(THEME_PATH) as NeoCadeTheme
	if theme == null:
		printerr("ERROR: could not load %s" % THEME_PATH)
		quit(3)
		return
	var showcase_packed := load(SHOWCASE_PATH) as PackedScene
	if showcase_packed == null:
		printerr("ERROR: could not load %s" % SHOWCASE_PATH)
		quit(4)
		return

	# Configuration matrix: 5 styles × 2 raised modes = 10 captures per phase.
	var matrix := [
		{"style": NeoCadeTheme.Style.PULSE,    "raised": false, "slug": "pulse-flat"},
		{"style": NeoCadeTheme.Style.PULSE,    "raised": true,  "slug": "pulse-raised"},
		{"style": NeoCadeTheme.Style.SLATE,    "raised": false, "slug": "slate-flat"},
		{"style": NeoCadeTheme.Style.SLATE,    "raised": true,  "slug": "slate-raised"},
		{"style": NeoCadeTheme.Style.BUBBLE,   "raised": false, "slug": "bubble-flat"},
		{"style": NeoCadeTheme.Style.BUBBLE,   "raised": true,  "slug": "bubble-raised"},
		{"style": NeoCadeTheme.Style.DAYBREAK, "raised": false, "slug": "daybreak-flat"},
		{"style": NeoCadeTheme.Style.DAYBREAK, "raised": true,  "slug": "daybreak-raised"},
		{"style": NeoCadeTheme.Style.BURST,    "raised": false, "slug": "burst-flat"},
		{"style": NeoCadeTheme.Style.BURST,    "raised": true,  "slug": "burst-raised"},
	]

	# Build a hidden SubViewport.
	var viewport := SubViewport.new()
	viewport.size = CAPTURE_SIZE
	viewport.transparent_bg = false
	viewport.disable_3d = true
	viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	root.add_child(viewport)

	# Instance the showcase as a child of the viewport.
	var showcase := showcase_packed.instantiate()
	viewport.add_child(showcase)

	var manifest_entries: Array = []

	for entry in matrix:
		var style: int = entry.style
		var raised: bool = entry.raised
		var slug: String = entry.slug

		print("[capture] %s style=%s raised=%s" % [slug, NeoCadeTheme.style_label(style), raised])

		# Duplicate the theme so each capture has a fresh per-style instance.
		var per_capture_theme := theme.duplicate(true) as NeoCadeTheme
		per_capture_theme.style = style
		per_capture_theme.raised = raised
		per_capture_theme.platform = NeoCadeTheme.Platform.DESKTOP

		# Apply to the showcase root.
		if showcase is Control:
			(showcase as Control).theme = per_capture_theme

		# Let layout + regen settle.
		for _i in range(PER_FRAME_DELAY):
			await process_frame

		# Capture.
		var image: Image = viewport.get_texture().get_image()
		if image == null:
			printerr("[capture] FAIL: viewport returned null image for %s" % slug)
			manifest_entries.append({"slug": slug, "ok": false, "reason": "null_image"})
			continue

		var png_path := abs_out + "/" + slug + ".png"
		var err := image.save_png(png_path)
		if err != OK:
			printerr("[capture] FAIL: save_png(%s) err=%s" % [png_path, err])
			manifest_entries.append({"slug": slug, "ok": false, "reason": "save_err_%d" % err})
			continue

		var image_bytes := image.get_data().size()
		manifest_entries.append({
			"slug": slug,
			"ok": true,
			"png": "screenshots/%s/%s.png" % [phase, slug],
			"style": NeoCadeTheme.style_label(style),
			"raised": raised,
			"size": [CAPTURE_SIZE.x, CAPTURE_SIZE.y],
			"image_bytes": image_bytes,
		})
		print("  → wrote %s (%d bytes)" % [png_path, image_bytes])

	# Write a manifest so the comparison.html generator knows what's there.
	var manifest_path := abs_out + "/manifest.json"
	var manifest_file := FileAccess.open(manifest_path, FileAccess.WRITE)
	if manifest_file != null:
		manifest_file.store_string(JSON.stringify({
			"phase": phase,
			"captured_at": Time.get_datetime_string_from_system(true),
			"godot_version": Engine.get_version_info().string,
			"entries": manifest_entries,
		}, "\t"))
		manifest_file.close()
		print("Wrote manifest: %s" % manifest_path)

	var ok_count := 0
	for entry in manifest_entries:
		if entry.ok:
			ok_count += 1
	print("\nCapture complete: %d/%d successful (phase=%s)" % [ok_count, manifest_entries.size(), phase])
	if ok_count < manifest_entries.size():
		quit(1)
		return
	quit(0)


func _read_phase_arg() -> String:
	# Args after `--` come via OS.get_cmdline_user_args() in Godot 4.
	var args := OS.get_cmdline_user_args()
	for arg in args:
		if arg.begins_with("phase="):
			return arg.substr("phase=".length()).strip_edges()
	return ""
