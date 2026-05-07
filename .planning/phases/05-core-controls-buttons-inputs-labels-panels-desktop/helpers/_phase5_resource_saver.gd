extends SceneTree

## Phase 5 Plan 07 Task 1 — ResourceSaver round-trip the five approved direction
## resources and apply the data-only strip pass.
##
## Run via:
##   <godot-cli> --headless --path . --script \
##     .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_resource_saver.gd
##
## Behavior:
##   1. Load EXACTLY the five approved direction `.tres` files at the addon root.
##   2. Assert each loads as `NeoCadeTheme`.
##   3. Snapshot the nine `@export` properties for each before save.
##   4. Call `ResourceSaver.save(theme, original_path)` for each — this is the
##      Phase 4 D-11 round-trip pattern, replacing the Cycle 6 F7 hand-author
##      fallback.
##   5. Immediately apply the strip pass (a verbatim copy of Phase 4
##      `_phase4_import.gd._strip_theme_entries()` + `_strip_load_steps_attr()`)
##      to remove every `[sub_resource]` block, every non-Script
##      `[ext_resource]`, every `theme_data/...` line, and recompute load_steps.
##   6. Re-load each stripped `.tres` and assert it loads as `NeoCadeTheme` AND
##      that the nine `@export` values match the pre-save snapshot byte-for-byte
##      (== or `is_equal_approx` for `Color`s).
##   7. Assert each post-strip file is < 2048 bytes, contains no `[sub_resource]`,
##      and contains no `theme_data/`.
##
## Per Phase 5 PLAN 05-07 Task 1 / D-06 / D-11.
##
## Honored invariants:
##   - D-01: never call Theme.clear() (we only construct/load/save).
##   - D-06: post-strip `.tres` is data-only (script linkage + 9 @exports).
##   - D-11: round-trip uses Godot's ResourceSaver (deterministic given inputs).
##   - F3 path discipline: this helper lives outside the addon root.
##
## Reuse note: the strip helpers are static and authored verbatim from Phase 4's
## `_phase4_import.gd._strip_theme_entries()` / `_strip_load_steps_attr()` so a
## byte-for-byte structural match with Phase 4's output is guaranteed (modulo
## any genuine BINDING_TABLE growth from Phase 5 — which is fine; the strip pass
## drops everything except the script linkage + 9 @exports anyway).
##
## Idempotency: running this helper twice is byte-identical because (a) Godot's
## ResourceSaver emits the same float-encoded `Color(...)` values for the same
## input Colors, (b) the script `uid://` is stable across runs (loaded from the
## existing `.tres`, not re-allocated), and (c) the strip pass is deterministic.

const APPROVED_DIRECTIONS := [
	"res://addons/neocade_theme/pulse_neocade_theme.tres",
	"res://addons/neocade_theme/slate_neocade_theme.tres",
	"res://addons/neocade_theme/bubble_neocade_theme.tres",
	"res://addons/neocade_theme/daybreak_neocade_theme.tres",
	"res://addons/neocade_theme/burst_neocade_theme.tres",
]

# The nine @export property names (Phase 4 FOUND-02 lock). These are the ONLY
# property assignments that survive the strip pass inside the [resource] block;
# `script = ExtResource(...)` and `script_class = "NeoCadeTheme"` are also kept
# (Cycle 4 N5) for form-2 serialization compatibility.
const EXPORT_KEYS := [
	"base_color", "accent_color", "raised", "platform",
	"corner_radius", "spacing", "raised_strength",
	"focus_thickness", "outline_width",
]


func _init() -> void:
	print("PHASE5_RESOURCE_SAVER: starting round-trip for %d approved directions" % APPROVED_DIRECTIONS.size())
	var failures: Array[String] = []

	for path in APPROVED_DIRECTIONS:
		print("PHASE5_RESOURCE_SAVER: ---- %s ----" % path)
		# Phase A: load + assert NeoCadeTheme.
		var loaded: Resource = ResourceLoader.load(path)
		if loaded == null:
			failures.append("%s: ResourceLoader.load returned null" % path)
			continue
		if not (loaded is NeoCadeTheme):
			failures.append("%s: did not load as NeoCadeTheme (got %s)" % [path, loaded.get_class()])
			continue
		var theme: NeoCadeTheme = loaded

		# Phase B: snapshot the 9 @export values before save.
		var snapshot: Dictionary = {
			"base_color": theme.base_color,
			"accent_color": theme.accent_color,
			"raised": theme.raised,
			"platform": theme.platform,
			"corner_radius": theme.corner_radius,
			"spacing": theme.spacing,
			"raised_strength": theme.raised_strength,
			"focus_thickness": theme.focus_thickness,
			"outline_width": theme.outline_width,
		}
		print("  snapshot: base=%s accent=%s raised=%s platform=%d corner_radius=%d spacing=%d raised_strength=%d focus_thickness=%d outline_width=%d" % [
			snapshot.base_color.to_html(false),
			snapshot.accent_color.to_html(false),
			str(snapshot.raised),
			snapshot.platform,
			snapshot.corner_radius,
			snapshot.spacing,
			snapshot.raised_strength,
			snapshot.focus_thickness,
			snapshot.outline_width,
		])

		# Phase C: ResourceSaver.save() — Godot emits header + ext_resource list +
		# every BINDING_TABLE-derived sub_resource and theme_data entry. The
		# strip pass on Phase D removes everything except the data-only surface.
		var save_ok: int = ResourceSaver.save(theme, path)
		if save_ok != OK:
			failures.append("%s: ResourceSaver.save failed with error %d" % [path, save_ok])
			continue
		var pre_strip_size: int = FileAccess.get_file_as_bytes(path).size()
		print("  ResourceSaver.save -> %d bytes (pre-strip)" % pre_strip_size)

		# Phase D: strip pass. Removes [sub_resource] blocks, non-Script
		# [ext_resource] blocks, theme_data/* lines, and stale load_steps=N
		# from the [gd_resource] header.
		var strip_err: String = _strip_theme_entries(path)
		if not strip_err.is_empty():
			failures.append("%s: strip_theme_entries failed: %s" % [path, strip_err])
			continue
		var post_strip_size: int = FileAccess.get_file_as_bytes(path).size()
		print("  strip pass     -> %d bytes (post-strip)" % post_strip_size)

		# Phase E: post-strip data-only invariants (D-06).
		var post_text: String = _read_file_text(path)
		if post_text.find("[sub_resource") != -1:
			failures.append("%s: post-strip file still contains [sub_resource (D-06 violated)" % path)
			continue
		if post_text.find("theme_data/") != -1:
			failures.append("%s: post-strip file still contains theme_data/ (D-06 violated)" % path)
			continue
		if post_strip_size >= 2048:
			failures.append("%s: post-strip file size %d >= 2048 (D-06 / SC#6 violated)" % [path, post_strip_size])
			continue

		# Phase F: re-load + verify the 9 @export values match the snapshot.
		# Hot-reload is required because ResourceLoader caches; CACHE_MODE_IGNORE
		# bypasses the cache entirely and reads the freshly-stripped file from
		# disk (CACHE_MODE_REPLACE was tried first but does not reliably
		# re-trigger _init() in headless mode — empirically validated via
		# helpers/_phase5_diag_reload.gd 2026-05-07).
		var reloaded: Resource = ResourceLoader.load(path, "", ResourceLoader.CACHE_MODE_IGNORE)
		if reloaded == null or not (reloaded is NeoCadeTheme):
			failures.append("%s: re-load after strip failed (or did not type as NeoCadeTheme)" % path)
			continue
		var rt: NeoCadeTheme = reloaded
		var diffs: Array[String] = []
		if not rt.base_color.is_equal_approx(snapshot.base_color):
			diffs.append("base_color: %s -> %s" % [snapshot.base_color.to_html(false), rt.base_color.to_html(false)])
		if not rt.accent_color.is_equal_approx(snapshot.accent_color):
			diffs.append("accent_color: %s -> %s" % [snapshot.accent_color.to_html(false), rt.accent_color.to_html(false)])
		if rt.raised != snapshot.raised:
			diffs.append("raised: %s -> %s" % [str(snapshot.raised), str(rt.raised)])
		if rt.platform != snapshot.platform:
			diffs.append("platform: %d -> %d" % [snapshot.platform, rt.platform])
		if rt.corner_radius != snapshot.corner_radius:
			diffs.append("corner_radius: %d -> %d" % [snapshot.corner_radius, rt.corner_radius])
		if rt.spacing != snapshot.spacing:
			diffs.append("spacing: %d -> %d" % [snapshot.spacing, rt.spacing])
		if rt.raised_strength != snapshot.raised_strength:
			diffs.append("raised_strength: %d -> %d" % [snapshot.raised_strength, rt.raised_strength])
		if rt.focus_thickness != snapshot.focus_thickness:
			diffs.append("focus_thickness: %d -> %d" % [snapshot.focus_thickness, rt.focus_thickness])
		if rt.outline_width != snapshot.outline_width:
			diffs.append("outline_width: %d -> %d" % [snapshot.outline_width, rt.outline_width])
		if not diffs.is_empty():
			failures.append("%s: post-round-trip @export drift: %s" % [path, "; ".join(diffs)])
			continue

		# Phase G: structural sanity — Phase 4 baseline still loads.
		if not rt.has_stylebox("normal", "Button"):
			failures.append("%s: Phase 4 baseline regression -- Button.normal stylebox missing after re-load" % path)
			continue

		print("  round-trip OK: 9 @exports preserved, %d bytes, no [sub_resource], no theme_data/" % post_strip_size)

	if failures.is_empty():
		print("PHASE5_RESOURCE_SAVER OK: all %d direction `.tres` files round-tripped + stripped + re-verified" % APPROVED_DIRECTIONS.size())
		quit(0)
		return
	push_error("PHASE5_RESOURCE_SAVER FAILED with %d failures:" % failures.size())
	for f in failures:
		push_error("  - %s" % f)
		print("PHASE5_RESOURCE_SAVER_FAIL: %s" % f)
	quit(1)


# ----- helpers (verbatim copy from Phase 4 _phase4_import.gd) -----
#
# Why duplicate rather than `load("res://...phase4_import.gd").call_static(...)`?
# Phase 4 helpers live under `.planning/phases/04-.../helpers/` (NOT in the
# `res://` virtual filesystem — they're development-time scripts on the host
# filesystem, accessed via `--script <abs path>`). They cannot be re-loaded from
# a different `--script` invocation. Copying the static helpers verbatim is the
# clean isolation; the strip output is identical because the helper bodies are
# identical.


## Cross-AI Cycle 3 N4 Fix A + Cycle 4 N5 Fix — textual post-process to
## data-only the saved .tres. Verbatim copy from
## `.planning/phases/04-.../helpers/_phase4_import.gd._strip_theme_entries()`.
##
## Returns "" on success; non-empty error message on failure.
static func _strip_theme_entries(path: String) -> String:
	var src := FileAccess.open(path, FileAccess.READ)
	if src == null:
		return "cannot open %s for read" % path
	var text: String = src.get_as_text()
	src.close()

	# Whitelist of @export property names; lines whose left-hand side is one of
	# these survive in the [resource] block. Anything else (theme_data/...,
	# SubResource references, per-Control state entries) is dropped — EXCEPT the
	# `script = ExtResource(...)` / `script_class = ...` lines (Cycle 4 N5),
	# which are detected by prefix below and preserved separately.
	var EXPORT_KEYS_LOCAL := [
		"base_color", "accent_color", "raised", "platform",
		"corner_radius", "spacing", "raised_strength",
		"focus_thickness", "outline_width",
	]

	var lines: PackedStringArray = text.split("\n")
	var out: PackedStringArray = []
	var section: String = ""
	var skip_section: bool = false
	for raw_line in lines:
		var line: String = raw_line
		var stripped: String = line.strip_edges()
		if stripped.begins_with("[") and stripped.ends_with("]"):
			# Section header transition.
			# Cycle 4 N5: PRESERVE [ext_resource type="Script" ...] blocks
			# (script linkage required for form-2 serialization) — keep the
			# entire 1-line section as-is.
			if stripped.begins_with("[ext_resource") and stripped.find("type=\"Script\"") != -1:
				skip_section = false
				section = "ext_resource_script"
				out.append(line)
				continue
			# Drop other [ext_resource ...] blocks (non-script sub-asset refs).
			if stripped.begins_with("[ext_resource"):
				skip_section = true
				section = "ext_resource_other"
				continue
			# Drop [sub_resource ...] blocks entirely (regenerated at load).
			if stripped.begins_with("[sub_resource"):
				skip_section = true
				section = "sub_resource"
				continue
			skip_section = false
			section = stripped
			# Keep [gd_resource ...] header (with load_steps stripped — see
			# below) and [resource] header; everything else (per-Control entry
			# sections Godot may emit) is dropped.
			if stripped.begins_with("[gd_resource"):
				var cleaned_header: String = _strip_load_steps_attr(line)
				out.append(cleaned_header)
			elif stripped == "[resource]":
				out.append(line)
			continue
		if skip_section:
			continue
		if section == "[resource]":
			if stripped == "":
				continue
			# Cycle 4 N5: preserve script linkage lines inside [resource]
			# (form-2 serialization).
			if stripped.begins_with("script = ExtResource(") or stripped.begins_with("script_class ="):
				out.append(line)
				continue
			# Keep whitelisted @export property assignments.
			var key: String = stripped.split("=", true, 1)[0].strip_edges()
			if EXPORT_KEYS_LOCAL.has(key):
				out.append(line)
			# Otherwise (theme_data/..., SubResource(...) refs, etc.) drop.
			continue
		# Pre-[gd_resource] preamble: Godot rarely emits content here; pass-through.
		if section == "":
			out.append(line)

	var final_text: String = "\n".join(out)
	if not final_text.ends_with("\n"):
		final_text += "\n"

	var dst := FileAccess.open(path, FileAccess.WRITE)
	if dst == null:
		return "cannot open %s for write" % path
	dst.store_string(final_text)
	dst.close()

	var size: int = FileAccess.get_file_as_bytes(path).size()
	if size >= 2048:
		return "post-strip size %d >= 2048 (SC#6 < 2 KiB violated)" % size
	return ""


## Cross-AI Cycle 4 N5 Fix helper — strip `load_steps=N` attribute from a
## `[gd_resource ...]` header line. Verbatim copy from Phase 4.
static func _strip_load_steps_attr(header_line: String) -> String:
	var rx := RegEx.new()
	rx.compile(r"\s*load_steps=\d+")
	var cleaned: String = rx.sub(header_line, "", true)
	var rx2 := RegEx.new()
	rx2.compile(r" {2,}")
	cleaned = rx2.sub(cleaned, " ", true)
	return cleaned


static func _read_file_text(path: String) -> String:
	var f := FileAccess.open(path, FileAccess.READ)
	if f == null:
		return ""
	var t: String = f.get_as_text()
	f.close()
	return t
