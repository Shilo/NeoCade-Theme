extends SceneTree

const THEME_PATH := "res://addons/neocade_theme/neocade_theme.tres"
const SHOWCASE_PATH := "res://showcase/showcase.tscn"


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	print("THEME_PERF_PROBE editor_hint=%s" % Engine.is_editor_hint())
	_benchmark_new_theme()
	_benchmark_load_theme()
	_benchmark_duplicate_theme()
	_benchmark_regeneration_mutations()
	await _benchmark_scene_assignment()
	quit(0)


func _benchmark_new_theme() -> void:
	var samples: Array[int] = []
	for index in range(12):
		var start := Time.get_ticks_usec()
		var theme := NeoCadeTheme.new()
		var elapsed := Time.get_ticks_usec() - start
		if index >= 2:
			samples.append(elapsed)
		_consume(theme)
	_print_samples("NeoCadeTheme.new", samples)


func _benchmark_load_theme() -> void:
	var samples: Array[int] = []
	for index in range(8):
		var start := Time.get_ticks_usec()
		var theme := ResourceLoader.load(THEME_PATH, "", ResourceLoader.CACHE_MODE_IGNORE) as NeoCadeTheme
		var elapsed := Time.get_ticks_usec() - start
		if index >= 1:
			samples.append(elapsed)
		_consume(theme)
	_print_samples("ResourceLoader.load uncached", samples)


func _benchmark_duplicate_theme() -> void:
	var source := load(THEME_PATH) as NeoCadeTheme
	var samples: Array[int] = []
	for index in range(12):
		var start := Time.get_ticks_usec()
		var theme := source.duplicate(true) as NeoCadeTheme
		var elapsed := Time.get_ticks_usec() - start
		if index >= 2:
			samples.append(elapsed)
		_consume(theme)
	_print_samples("Theme.duplicate(true)", samples)


func _benchmark_regeneration_mutations() -> void:
	var theme := load(THEME_PATH).duplicate(true) as NeoCadeTheme
	print("PERF %-34s value=%s active_icons=%d active_generated=%d" % [
		"texture_cache default",
		str(theme.texture_cache),
		theme._active_icon_cache.size(),
		theme._active_generated_texture_cache.size(),
	])
	var cases: Array[Dictionary] = [
		{"name": "toggle raised temp cache", "call": func() -> void: theme.raised = not theme.raised},
		{"name": "set style SLATE", "call": func() -> void: theme.style = NeoCadeTheme.Style.SLATE},
		{"name": "set style PULSE", "call": func() -> void: theme.style = NeoCadeTheme.Style.PULSE},
		{"name": "set base color", "call": func() -> void: theme.base_color = Color("#151B30")},
		{"name": "toggle popup icons", "call": func() -> void: theme.use_runtime_popup_selection_icons = not theme.use_runtime_popup_selection_icons},
		{"name": "enable texture cache", "call": func() -> void: theme.texture_cache = true},
		{"name": "toggle raised persistent cache", "call": func() -> void: theme.raised = not theme.raised},
		{"name": "disable texture cache", "call": func() -> void: theme.texture_cache = false},
	]
	for perf_case in cases:
		var start := Time.get_ticks_usec()
		(perf_case["call"] as Callable).call()
		var elapsed := Time.get_ticks_usec() - start
		print("PERF %-34s elapsed=%7.3fms last_regen=%7.3fms active_icons=%d active_generated=%d" % [
			String(perf_case["name"]),
			float(elapsed) / 1000.0,
			float(theme._last_regeneration_usec) / 1000.0,
			theme._active_icon_cache.size(),
			theme._active_generated_texture_cache.size(),
		])


func _benchmark_scene_assignment() -> void:
	var scene_resource := load(SHOWCASE_PATH) as PackedScene
	var scene := scene_resource.instantiate() as Control
	root.add_child(scene)
	await process_frame

	var theme := load(THEME_PATH) as Theme
	var start := Time.get_ticks_usec()
	scene.theme = theme
	var assign_elapsed := Time.get_ticks_usec() - start
	var frame_start := Time.get_ticks_usec()
	await process_frame
	var frame_elapsed := Time.get_ticks_usec() - frame_start
	print("PERF %-34s elapsed=%7.3fms next_frame=%7.3fms descendants=%d" % [
		"showcase Control.theme assignment",
		float(assign_elapsed) / 1000.0,
		float(frame_elapsed) / 1000.0,
		_count_descendants(scene),
	])
	scene.queue_free()


func _print_samples(label: String, samples: Array[int]) -> void:
	var min_value := samples[0]
	var max_value := samples[0]
	var total := 0
	for sample in samples:
		min_value = mini(min_value, sample)
		max_value = maxi(max_value, sample)
		total += sample
	print("PERF %-34s avg=%7.3fms min=%7.3fms max=%7.3fms n=%d" % [
		label,
		float(total) / float(samples.size()) / 1000.0,
		float(min_value) / 1000.0,
		float(max_value) / 1000.0,
		samples.size(),
	])


func _count_descendants(node: Node) -> int:
	var count := 0
	for child in node.get_children():
		count += 1 + _count_descendants(child)
	return count


func _consume(value: Variant) -> void:
	if value == null:
		push_error("Unexpected null in performance probe.")
