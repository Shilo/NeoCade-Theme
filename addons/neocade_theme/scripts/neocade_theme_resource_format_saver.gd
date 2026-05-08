@tool
extends ResourceFormatSaver

const FALLBACK_SCRIPT_RESOURCE_ID := "1_neocade_theme"
const SCRIPT_PATH := "res://addons/neocade_theme/scripts/neocade_theme.gd"
const TEMP_FILE_SUFFIX := ".neocade_save_tmp.tres"

static var _passthrough_depth := 0


func _get_recognized_extensions(resource: Resource) -> PackedStringArray:
	if _recognize(resource):
		return PackedStringArray(["tres"])

	return PackedStringArray()


func _recognize(resource: Resource) -> bool:
	return _passthrough_depth == 0 and resource is NeoCadeTheme


func _recognize_path(resource: Resource, path: String) -> bool:
	return _recognize(resource) and path.get_extension().to_lower() == "tres"


func _save(resource: Resource, path: String, flags: int) -> Error:
	if not (resource is NeoCadeTheme):
		return ERR_INVALID_PARAMETER
	if path.is_empty():
		path = resource.resource_path
	if path.is_empty():
		return ERR_FILE_BAD_PATH

	var theme := resource as NeoCadeTheme
	var result := _build_resource_text(theme, path, flags)
	var build_error := int(result.get("error", OK))
	if build_error != OK:
		return build_error

	var write_path := _temporary_write_path(path)
	var text := String(result.get("text", ""))
	var file := FileAccess.open(write_path, FileAccess.WRITE)
	if file == null:
		return ERR_CANT_OPEN

	file.store_string(text)
	file.close()

	var directory := DirAccess.open(path.get_base_dir())
	if directory == null:
		_remove_file(write_path)
		return ERR_CANT_OPEN

	var had_previous_file := FileAccess.file_exists(path)
	var previous_text := ""
	if had_previous_file:
		previous_text = FileAccess.get_file_as_string(path)

	var remove_error := OK
	if had_previous_file:
		remove_error = directory.remove(path.get_file())
	if remove_error != OK:
		_remove_file(write_path)
		return remove_error

	var rename_error := directory.rename(write_path.get_file(), path.get_file())
	if rename_error != OK:
		_remove_file(write_path)
		if had_previous_file:
			_restore_file(path, previous_text)
		return rename_error

	if (flags & ResourceSaver.FLAG_CHANGE_PATH) != 0:
		theme.take_over_path(path)

	return OK


func _set_uid(path: String, uid: int) -> Error:
	if uid == ResourceUID.INVALID_ID:
		return OK

	var text := FileAccess.get_file_as_string(path)
	if text.is_empty():
		return ERR_FILE_CANT_READ

	var lines := text.split("\n")
	var header := String(lines[0])
	if not header.begins_with("[gd_resource"):
		return ERR_PARSE_ERROR

	lines[0] = _with_header_uid(header, ResourceUID.id_to_text(uid))
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		return ERR_CANT_OPEN

	file.store_string("\n".join(lines))
	file.close()
	return OK


func _build_resource_text(theme: NeoCadeTheme, path: String, flags: int) -> Dictionary:
	var temp_path := _temporary_builtin_path(path)
	_remove_file(temp_path)

	var builtin_flags := flags & ~ResourceSaver.FLAG_CHANGE_PATH
	builtin_flags = builtin_flags & ~ResourceSaver.FLAG_REPLACE_SUBRESOURCE_PATHS
	_passthrough_depth += 1
	var save_error := ResourceSaver.save(theme, temp_path, builtin_flags)
	_passthrough_depth -= 1
	if save_error != OK:
		_remove_file(temp_path)
		return {"error": save_error, "text": ""}

	var serialized_text := FileAccess.get_file_as_string(temp_path)
	_remove_file(temp_path)
	if serialized_text.is_empty():
		return {"error": ERR_FILE_CANT_READ, "text": ""}

	return {
		"error": OK,
		"text": _strip_generated_resource_text(theme, path, serialized_text),
	}


func _strip_generated_resource_text(theme: NeoCadeTheme, path: String, serialized_text: String) -> String:
	var parsed := _parse_serialized_resource(serialized_text)
	var existing_text := FileAccess.get_file_as_string(path)
	var existing_script_id := _existing_script_resource_id(existing_text)
	var script_resource_id := existing_script_id if not existing_script_id.is_empty() else FALLBACK_SCRIPT_RESOURCE_ID
	var script_ext_resource_line := _script_ext_resource_line(existing_text, script_resource_id)
	var export_property_names := _export_property_names()
	var export_property_lookup := _property_lookup(export_property_names)
	var generated_properties := _generated_theme_property_names()
	var kept_resource_lines: PackedStringArray = PackedStringArray()
	var referenced_ext_ids := {}
	var referenced_sub_ids := {}

	for raw_line in parsed["resource_lines"]:
		var line := String(raw_line)
		var stripped := line.strip_edges()
		if stripped.is_empty() or stripped.begins_with("script = ExtResource("):
			continue

		var property_name := _resource_property_name(stripped)
		if property_name.is_empty() or export_property_lookup.has(property_name):
			continue
		if generated_properties.has(property_name):
			continue

		kept_resource_lines.append(line)
		_collect_resource_references(line, referenced_ext_ids, referenced_sub_ids)

	var kept_sub_resource_ids := _collect_kept_sub_resources(parsed["sub_resources"], referenced_ext_ids, referenced_sub_ids)
	var lines: PackedStringArray = PackedStringArray()
	lines.append(_resource_header(path, serialized_text))
	lines.append(script_ext_resource_line if not script_ext_resource_line.is_empty() else _new_script_ext_resource_line(script_resource_id))

	for ext_resource in parsed["ext_resources"]:
		var ext_id := String(ext_resource["id"])
		if ext_id != script_resource_id and referenced_ext_ids.has(ext_id):
			lines.append(String(ext_resource["line"]))

	if not kept_sub_resource_ids.is_empty():
		lines.append("")
		for sub_resource in parsed["sub_resources"]:
			var sub_id := String(sub_resource["id"])
			if kept_sub_resource_ids.has(sub_id):
				for sub_line in sub_resource["lines"]:
					lines.append(String(sub_line))
				lines.append("")
	elif _has_extra_ext_resources(lines):
		lines.append("")

	lines.append("[resource]")
	lines.append("script = ExtResource(\"%s\")" % _escape_string(script_resource_id))
	for line in kept_resource_lines:
		lines.append(line)
	for property_name in _export_property_order(path, export_property_names):
		lines.append("%s = %s" % [property_name, var_to_str(theme.get(property_name))])

	return "\n".join(lines) + "\n"


func _parse_serialized_resource(text: String) -> Dictionary:
	var ext_resources: Array[Dictionary] = []
	var sub_resources: Array[Dictionary] = []
	var resource_lines: PackedStringArray = PackedStringArray()
	var current_sub_resource: Dictionary = {}
	var in_sub_resource := false
	var in_resource := false

	for raw_line in text.split("\n"):
		var line := String(raw_line)
		var stripped := line.strip_edges()
		if stripped.begins_with("[ext_resource"):
			if in_sub_resource:
				sub_resources.append(current_sub_resource)
				current_sub_resource = {}
				in_sub_resource = false
			ext_resources.append({
				"id": _quoted_attribute(stripped, "id"),
				"line": line,
			})
			continue
		if stripped.begins_with("[sub_resource"):
			if in_sub_resource:
				sub_resources.append(current_sub_resource)
			current_sub_resource = {
				"id": _quoted_attribute(stripped, "id"),
				"lines": PackedStringArray([line]),
			}
			in_sub_resource = true
			in_resource = false
			continue
		if stripped == "[resource]":
			if in_sub_resource:
				sub_resources.append(current_sub_resource)
				current_sub_resource = {}
				in_sub_resource = false
			in_resource = true
			continue
		if stripped.begins_with("[") and stripped.ends_with("]"):
			if in_sub_resource:
				sub_resources.append(current_sub_resource)
				current_sub_resource = {}
				in_sub_resource = false
			in_resource = false
			continue

		if in_sub_resource:
			var sub_lines: PackedStringArray = current_sub_resource["lines"]
			sub_lines.append(line)
			current_sub_resource["lines"] = sub_lines
		elif in_resource:
			resource_lines.append(line)

	if in_sub_resource:
		sub_resources.append(current_sub_resource)

	return {
		"ext_resources": ext_resources,
		"sub_resources": sub_resources,
		"resource_lines": resource_lines,
	}


func _generated_theme_property_names() -> Dictionary:
	var generated := NeoCadeTheme.new()
	var property_names := {}
	for property in generated.get_property_list():
		var property_name := String(property.get("name", ""))
		if _is_generated_theme_property(property_name):
			property_names[property_name] = true

	return property_names


func _export_property_names() -> Array[String]:
	var theme := NeoCadeTheme.new()
	var property_names: Array[String] = []
	for property in theme.get_property_list():
		var property_name := String(property.get("name", ""))
		var usage := int(property.get("usage", 0))
		if property_name.is_empty():
			continue
		if (usage & PROPERTY_USAGE_SCRIPT_VARIABLE) == 0:
			continue
		if (usage & PROPERTY_USAGE_STORAGE) == 0:
			continue
		if (usage & PROPERTY_USAGE_EDITOR) == 0:
			continue

		property_names.append(property_name)

	return property_names


func _property_lookup(property_names: Array[String]) -> Dictionary:
	var lookup := {}
	for property_name in property_names:
		lookup[property_name] = true

	return lookup


func _is_generated_theme_property(property_name: String) -> bool:
	return property_name.contains("/") or property_name == "default_font" or property_name == "default_font_size"


func _resource_property_name(line: String) -> String:
	var assignment_index := line.find("=")
	if assignment_index == -1:
		return ""

	return line.substr(0, assignment_index).strip_edges()


func _collect_kept_sub_resources(
	sub_resources: Array,
	referenced_ext_ids: Dictionary,
	referenced_sub_ids: Dictionary
) -> Dictionary:
	var kept_sub_resource_ids := {}
	var changed := true
	while changed:
		changed = false
		for sub_resource in sub_resources:
			var sub_id := String(sub_resource["id"])
			if not referenced_sub_ids.has(sub_id) or kept_sub_resource_ids.has(sub_id):
				continue

			kept_sub_resource_ids[sub_id] = true
			changed = true
			for sub_line in sub_resource["lines"]:
				_collect_resource_references(String(sub_line), referenced_ext_ids, referenced_sub_ids)

	return kept_sub_resource_ids


func _collect_resource_references(text: String, referenced_ext_ids: Dictionary, referenced_sub_ids: Dictionary) -> void:
	_collect_reference_ids(text, "ExtResource(\"", referenced_ext_ids)
	_collect_reference_ids(text, "SubResource(\"", referenced_sub_ids)


func _collect_reference_ids(text: String, marker: String, ids: Dictionary) -> void:
	var search_from := 0
	while true:
		var value_start := text.find(marker, search_from)
		if value_start == -1:
			return

		value_start += marker.length()
		var value_end := text.find("\"", value_start)
		if value_end == -1:
			return

		ids[text.substr(value_start, value_end - value_start)] = true
		search_from = value_end + 1


func _resource_header(path: String, serialized_text: String) -> String:
	var uid_text := _existing_uid_text(path)
	if uid_text.is_empty():
		uid_text = _header_uid_text(_first_line(serialized_text))
	if uid_text.is_empty():
		var path_uid := ResourceSaver.get_resource_id_for_path(path, false)
		if path_uid != ResourceUID.INVALID_ID:
			uid_text = ResourceUID.id_to_text(path_uid)

	var uid_attr := ""
	if not uid_text.is_empty():
		uid_attr = " uid=\"%s\"" % _escape_string(uid_text)

	return "[gd_resource type=\"Theme\" script_class=\"NeoCadeTheme\" format=3%s]" % uid_attr


func _existing_uid_text(path: String) -> String:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return ""

	var header := file.get_line()
	file.close()
	return _header_uid_text(header)


func _header_uid_text(header: String) -> String:
	if not header.begins_with("[gd_resource"):
		return ""

	return _quoted_attribute(header, "uid")


func _with_header_uid(header: String, uid_text: String) -> String:
	var uid_marker := "uid=\""
	var uid_start := header.find(uid_marker)
	if uid_start == -1:
		var insert_at := header.rfind("]")
		if insert_at == -1:
			return header
		return header.substr(0, insert_at) + " uid=\"%s\"" % _escape_string(uid_text) + header.substr(insert_at)

	uid_start += uid_marker.length()
	var uid_end := header.find("\"", uid_start)
	if uid_end == -1:
		return header

	return header.substr(0, uid_start) + _escape_string(uid_text) + header.substr(uid_end)


func _existing_script_resource_id(text: String) -> String:
	var in_resource := false
	for raw_line in text.split("\n"):
		var line := String(raw_line).strip_edges()
		if line == "[resource]":
			in_resource = true
			continue
		if in_resource and line.begins_with("[") and line.ends_with("]"):
			break
		if in_resource and line.begins_with("script = ExtResource("):
			return _reference_id(line, "ExtResource(\"")

	return ""


func _script_ext_resource_line(text: String, script_resource_id: String) -> String:
	for raw_line in text.split("\n"):
		var line := String(raw_line).strip_edges()
		if line == "[resource]":
			return ""
		if not line.begins_with("[ext_resource"):
			continue
		if _quoted_attribute(line, "id") == script_resource_id:
			return String(raw_line)

	return ""


func _new_script_ext_resource_line(script_resource_id: String) -> String:
	return "[ext_resource type=\"Script\" path=\"%s\" id=\"%s\"]" % [
		_escape_string(SCRIPT_PATH),
		_escape_string(script_resource_id),
	]


func _export_property_order(path: String, export_property_names: Array[String]) -> Array[String]:
	var ordered: Array[String] = []
	var seen := {}
	var export_property_lookup := _property_lookup(export_property_names)
	var file := FileAccess.open(path, FileAccess.READ)
	if file != null:
		var in_resource := false
		while not file.eof_reached():
			var line := file.get_line().strip_edges()
			if line == "[resource]":
				in_resource = true
				continue
			if in_resource and line.begins_with("[") and line.ends_with("]"):
				break
			if not in_resource:
				continue

			var property_name := _resource_property_name(line)
			if export_property_lookup.has(property_name) and not seen.has(property_name):
				ordered.append(property_name)
				seen[property_name] = true
		file.close()

	for property_name in export_property_names:
		if not seen.has(property_name):
			ordered.append(property_name)

	return ordered


func _quoted_attribute(text: String, attribute_name: String) -> String:
	var marker := "%s=\"" % attribute_name
	var value_start := text.find(marker)
	if value_start == -1:
		return ""

	value_start += marker.length()
	var value_end := text.find("\"", value_start)
	if value_end == -1:
		return ""

	return text.substr(value_start, value_end - value_start)


func _reference_id(text: String, marker: String) -> String:
	var value_start := text.find(marker)
	if value_start == -1:
		return ""

	value_start += marker.length()
	var value_end := text.find("\"", value_start)
	if value_end == -1:
		return ""

	return text.substr(value_start, value_end - value_start)


func _first_line(text: String) -> String:
	var line_end := text.find("\n")
	if line_end == -1:
		return text

	return text.substr(0, line_end)


func _has_extra_ext_resources(lines: PackedStringArray) -> bool:
	for line in lines:
		if String(line).begins_with("[ext_resource") and String(line).find("type=\"Script\"") == -1:
			return true

	return false


func _temporary_builtin_path(path: String) -> String:
	return _temporary_path(path, ".builtin")


func _temporary_write_path(path: String) -> String:
	return _temporary_path(path, ".write")


func _temporary_path(path: String, label: String) -> String:
	var id := "%s_%s" % [Time.get_ticks_usec(), randi()]
	return path.get_base_dir().path_join("%s%s.%s%s" % [
		path.get_file().get_basename(),
		label,
		id,
		TEMP_FILE_SUFFIX,
	])


func _remove_file(path: String) -> void:
	if not FileAccess.file_exists(path):
		return

	var directory := DirAccess.open(path.get_base_dir())
	if directory != null:
		directory.remove(path.get_file())


func _restore_file(path: String, text: String) -> void:
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		return

	file.store_string(text)
	file.close()


func _escape_string(value: String) -> String:
	return value.replace("\\", "\\\\").replace("\"", "\\\"")
