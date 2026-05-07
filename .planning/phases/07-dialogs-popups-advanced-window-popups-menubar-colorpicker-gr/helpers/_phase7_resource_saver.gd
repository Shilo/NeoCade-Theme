extends SceneTree

## PHASE7_RESOURCE_SAVER
##
## ResourceSaver round-trip helper for Phase 7. This is intentionally not run
## by Plan 07-01; Plan 07-05 runs it after all Phase 7 production bindings
## exist. The helper mirrors the Phase 6 data-only strip pattern:
##
## 1. Load exactly the five approved direction resources.
## 2. Assert each loads as NeoCadeTheme.
## 3. Snapshot the nine public @export values.
## 4. Call ResourceSaver.save(theme, path).
## 5. Strip generated Theme entries while preserving script linkage and exports.
## 6. Reload each file as NeoCadeTheme.
## 7. Assert each file is data-only and under 2048 bytes.

const APPROVED_DIRECTIONS := [
	"res://addons/neocade_theme/pulse_neocade_theme.tres",
	"res://addons/neocade_theme/slate_neocade_theme.tres",
	"res://addons/neocade_theme/bubble_neocade_theme.tres",
	"res://addons/neocade_theme/daybreak_neocade_theme.tres",
	"res://addons/neocade_theme/burst_neocade_theme.tres",
]

const EXPORT_KEYS := [
	"base_color", "accent_color", "raised", "platform",
	"corner_radius", "spacing", "raised_strength",
	"focus_thickness", "outline_width",
]


func _init() -> void:
	print("PHASE7_RESOURCE_SAVER: starting round-trip for %d approved directions" % APPROVED_DIRECTIONS.size())
	var failures: Array[String] = []

	for path in APPROVED_DIRECTIONS:
		print("PHASE7_RESOURCE_SAVER: ---- %s ----" % path)
		var loaded := ResourceLoader.load(path, "", ResourceLoader.CACHE_MODE_IGNORE)
		if loaded == null or not (loaded is NeoCadeTheme):
			failures.append("%s: did not load as NeoCadeTheme" % path)
			continue
		var theme: NeoCadeTheme = loaded
		var snapshot := _snapshot_exports(theme)

		var save_result := ResourceSaver.save(theme, path)
		if save_result != OK:
			failures.append("%s: ResourceSaver.save failed with error %d" % [path, save_result])
			continue

		var strip_error := _strip_theme_entries(path, snapshot)
		if not strip_error.is_empty():
			failures.append("%s: strip failed: %s" % [path, strip_error])
			continue

		var data_only_error := _assert_data_only_file(path)
		if not data_only_error.is_empty():
			failures.append("%s: %s" % [path, data_only_error])
			continue

		var reloaded := ResourceLoader.load(path, "", ResourceLoader.CACHE_MODE_IGNORE)
		if reloaded == null or not (reloaded is NeoCadeTheme):
			failures.append("%s: reload after strip did not produce NeoCadeTheme" % path)
			continue
		var rt: NeoCadeTheme = reloaded
		var drift := _diff_exports(snapshot, rt)
		if not drift.is_empty():
			failures.append("%s: @export drift after round-trip: %s" % [path, "; ".join(drift)])
			continue
		if not rt.has_stylebox("normal", "Button"):
			failures.append("%s: regenerated baseline missing Button.normal after reload" % path)
			continue

		var size := FileAccess.get_file_as_bytes(path).size()
		print("PHASE7_RESOURCE_SAVER_OK: %s (%d bytes, data-only)" % [path, size])

	if failures.is_empty():
		print("PHASE7_RESOURCE_SAVER OK: all direction resources round-tripped, stripped, and reloaded")
		quit(0)
		return
	push_error("PHASE7_RESOURCE_SAVER FAILED with %d failures" % failures.size())
	for failure in failures:
		push_error("  - %s" % failure)
		print("PHASE7_RESOURCE_SAVER_FAIL: %s" % failure)
	quit(1)


func _snapshot_exports(theme: NeoCadeTheme) -> Dictionary:
	return {
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


func _diff_exports(snapshot: Dictionary, theme: NeoCadeTheme) -> Array[String]:
	var diffs: Array[String] = []
	if not theme.base_color.is_equal_approx(snapshot.base_color):
		diffs.append("base_color")
	if not theme.accent_color.is_equal_approx(snapshot.accent_color):
		diffs.append("accent_color")
	if theme.raised != snapshot.raised:
		diffs.append("raised")
	if theme.platform != snapshot.platform:
		diffs.append("platform")
	if theme.corner_radius != snapshot.corner_radius:
		diffs.append("corner_radius")
	if theme.spacing != snapshot.spacing:
		diffs.append("spacing")
	if theme.raised_strength != snapshot.raised_strength:
		diffs.append("raised_strength")
	if theme.focus_thickness != snapshot.focus_thickness:
		diffs.append("focus_thickness")
	if theme.outline_width != snapshot.outline_width:
		diffs.append("outline_width")
	return diffs


func _assert_data_only_file(path: String) -> String:
	var bytes := FileAccess.get_file_as_bytes(path)
	if bytes.is_empty():
		return "file missing or empty"
	if bytes.size() >= 2048:
		return "size %d >= 2048 bytes" % bytes.size()
	var text := _read_file_text(path)
	if text.find("[sub_resource") != -1:
		return "contains [sub_resource block"
	if text.find("theme_data/") != -1:
		return "contains theme_data entry"
	if text.find("script = ExtResource(") == -1:
		return "script linkage missing"
	for key in EXPORT_KEYS:
		if text.find(key + " = ") == -1:
			return "missing exported value %s" % key
	return ""


## Strip generated Theme entries from a ResourceSaver-emitted .tres while
## preserving:
## - [gd_resource ...] header with load_steps removed
## - Script ext_resource blocks
## - [resource] header
## - script/script_class linkage
## - the nine public @export assignments
static func _strip_theme_entries(path: String, snapshot: Dictionary) -> String:
	var src := FileAccess.open(path, FileAccess.READ)
	if src == null:
		return "cannot open %s for read" % path
	var text := src.get_as_text()
	src.close()

	var lines := text.split("\n")
	var out: PackedStringArray = []
	var section := ""
	var skip_section := false
	var written_exports: Dictionary = {}

	for raw_line in lines:
		var line: String = raw_line
		var stripped := line.strip_edges()
		if stripped.begins_with("[") and stripped.ends_with("]"):
			if stripped.begins_with("[ext_resource") and stripped.find("type=\"Script\"") != -1:
				skip_section = false
				section = "ext_resource_script"
				out.append(line)
				continue
			if stripped.begins_with("[ext_resource"):
				skip_section = true
				section = "ext_resource_other"
				continue
			if stripped.begins_with("[sub_resource"):
				skip_section = true
				section = "sub_resource"
				continue
			skip_section = false
			section = stripped
			if stripped.begins_with("[gd_resource"):
				out.append(_strip_load_steps_attr(line))
			elif stripped == "[resource]":
				out.append(line)
			continue

		if skip_section:
			continue
		if section == "[resource]":
			if stripped == "":
				continue
			if stripped.begins_with("script = ExtResource(") or stripped.begins_with("script_class ="):
				out.append(line)
				continue
			var key := stripped.split("=", true, 1)[0].strip_edges()
			if EXPORT_KEYS.has(key):
				out.append(line)
				written_exports[key] = true
			continue
		if section == "":
			out.append(line)

	for key in EXPORT_KEYS:
		if not written_exports.has(key):
			out.append(_format_export_line(key, snapshot.get(key)))

	var final_text := "\n".join(out)
	if not final_text.ends_with("\n"):
		final_text += "\n"

	var dst := FileAccess.open(path, FileAccess.WRITE)
	if dst == null:
		return "cannot open %s for write" % path
	dst.store_string(final_text)
	dst.close()

	var size := FileAccess.get_file_as_bytes(path).size()
	if size >= 2048:
		return "post-strip size %d >= 2048" % size
	return ""


static func _format_export_line(key: String, value: Variant) -> String:
	if value is Color:
		var color: Color = value
		return "%s = Color(%s, %s, %s, %s)" % [
			key,
			_float_text(color.r),
			_float_text(color.g),
			_float_text(color.b),
			_float_text(color.a),
		]
	if typeof(value) == TYPE_BOOL:
		return "%s = %s" % [key, "true" if bool(value) else "false"]
	return "%s = %s" % [key, str(value)]


static func _float_text(value: float) -> String:
	var text := "%.7f" % value
	while text.find(".") != -1 and text.ends_with("0"):
		text = text.substr(0, text.length() - 1)
	if text.ends_with("."):
		text = text.substr(0, text.length() - 1)
	return text


static func _strip_load_steps_attr(header_line: String) -> String:
	var rx := RegEx.new()
	rx.compile(r"\s*load_steps=\d+")
	var cleaned := rx.sub(header_line, "", true)
	var rx2 := RegEx.new()
	rx2.compile(r" {2,}")
	return rx2.sub(cleaned, " ", true)


static func _read_file_text(path: String) -> String:
	var f := FileAccess.open(path, FileAccess.READ)
	if f == null:
		return ""
	var text := f.get_as_text()
	f.close()
	return text
