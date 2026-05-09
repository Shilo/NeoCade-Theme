@tool
extends EditorScript

## Run this from the headed Godot editor Script workspace.
##
## It benchmarks the same path the inspector uses when a Theme resource is applied
## to the currently edited scene root, then restores the original root theme so the
## scene is not left dirty by the benchmark.

const THEME_PATH := "res://addons/neocade_theme/neocade_theme.tres"
const RESTORE_AFTER := true


func _run() -> void:
	print("")
	print("NEOCADE_HEADED_EDITOR_THEME_BENCHMARK: begin")
	print("  theme=%s" % THEME_PATH)
	print("  editor_hint=%s" % Engine.is_editor_hint())

	_benchmark_resource_costs()
	_benchmark_regeneration_costs()
	await _benchmark_current_scene_apply()

	print("NEOCADE_HEADED_EDITOR_THEME_BENCHMARK: end")
	print("")


func _benchmark_resource_costs() -> void:
	_measure("ResourceLoader.load cached", func() -> void:
		var theme := load(THEME_PATH) as NeoCadeTheme
		_consume(theme)
	)
	_measure("ResourceLoader.load uncached", func() -> void:
		var theme := ResourceLoader.load(THEME_PATH, "", ResourceLoader.CACHE_MODE_IGNORE) as NeoCadeTheme
		_consume(theme)
	)
	_measure("NeoCadeTheme.new", func() -> void:
		var theme := NeoCadeTheme.new()
		_consume(theme)
		print("    last_regen=%7.3fms" % (float(theme._last_regeneration_usec) / 1000.0))
	)
	var source := load(THEME_PATH) as NeoCadeTheme
	_measure("Theme.duplicate(true)", func() -> void:
		var theme := source.duplicate(true) as NeoCadeTheme
		_consume(theme)
	)


func _benchmark_regeneration_costs() -> void:
	var theme := load(THEME_PATH).duplicate(true) as NeoCadeTheme
	_measure("regen: toggle raised", func() -> void:
		theme.raised = not theme.raised
		print("    last_regen=%7.3fms" % (float(theme._last_regeneration_usec) / 1000.0))
	)
	_measure("regen: style Slate", func() -> void:
		theme.style = NeoCadeTheme.Style.SLATE
		print("    last_regen=%7.3fms" % (float(theme._last_regeneration_usec) / 1000.0))
	)
	_measure("regen: style Pulse", func() -> void:
		theme.style = NeoCadeTheme.Style.PULSE
		print("    last_regen=%7.3fms" % (float(theme._last_regeneration_usec) / 1000.0))
	)


func _benchmark_current_scene_apply() -> void:
	var edited_root := get_editor_interface().get_edited_scene_root()
	if edited_root == null:
		print("  SKIP: no edited scene root is open.")
		return
	if not edited_root is Control:
		print("  SKIP: edited scene root is %s, not Control." % edited_root.get_class())
		return

	var root_control := edited_root as Control
	var original_theme := root_control.theme
	var theme := load(THEME_PATH) as Theme
	print("  edited_root=%s descendants=%d control_descendants=%d" % [
		root_control.name,
		_count_descendants(root_control),
		_count_control_descendants(root_control),
	])

	var assign_start := Time.get_ticks_usec()
	root_control.theme = theme
	var assign_elapsed := Time.get_ticks_usec() - assign_start
	print("  APPLY root.theme assignment=%7.3fms" % (float(assign_elapsed) / 1000.0))

	var frame_start := Time.get_ticks_usec()
	await get_editor_interface().get_base_control().get_tree().process_frame
	var first_frame_elapsed := Time.get_ticks_usec() - frame_start
	print("  APPLY first editor frame after assignment=%7.3fms" % (float(first_frame_elapsed) / 1000.0))

	frame_start = Time.get_ticks_usec()
	for _index in range(5):
		await get_editor_interface().get_base_control().get_tree().process_frame
	var five_frames_elapsed := Time.get_ticks_usec() - frame_start
	print("  APPLY next five editor frames=%7.3fms" % (float(five_frames_elapsed) / 1000.0))

	if RESTORE_AFTER:
		var restore_start := Time.get_ticks_usec()
		root_control.theme = original_theme
		var restore_elapsed := Time.get_ticks_usec() - restore_start
		print("  RESTORE root.theme assignment=%7.3fms" % (float(restore_elapsed) / 1000.0))
		await get_editor_interface().get_base_control().get_tree().process_frame


func _measure(label: String, callable: Callable) -> void:
	var start := Time.get_ticks_usec()
	callable.call()
	var elapsed := Time.get_ticks_usec() - start
	print("  %-36s %7.3fms" % [label, float(elapsed) / 1000.0])


func _count_descendants(node: Node) -> int:
	var count := 0
	for child in node.get_children():
		count += 1 + _count_descendants(child)
	return count


func _count_control_descendants(node: Node) -> int:
	var count := 0
	for child in node.get_children():
		if child is Control:
			count += 1
		count += _count_control_descendants(child)
	return count


func _consume(value: Variant) -> void:
	if value == null:
		push_error("Unexpected null in headed editor benchmark.")
