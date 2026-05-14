extends SceneTree


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var host := Control.new()
	host.name = "Host"
	var target := Control.new()
	target.name = "Target"
	var picker := NeoCadeThemeOptionButton.new()
	picker.name = "Picker"
	picker.allow_no_theme = false
	picker.theme_target_path = NodePath("../Target")

	var existing := NeoCadeTheme.new()
	existing.style = NeoCadeTheme.Style.SLATE
	existing.source_color = Color("#8A4DFF")
	existing.raised = true
	existing.platform = NeoCadeTheme.Platform.MOBILE
	existing.use_runtime_popup_selection_icons = false
	existing.texture_cache = true
	target.theme = existing

	host.add_child(target)
	host.add_child(picker)
	root.add_child(host)
	await process_frame

	var pulse_index := _index_for_style(picker, NeoCadeTheme.Style.PULSE)
	var failed := false
	var emitted := {"count": 0}
	picker.theme_selected.connect(func(_theme: Theme, _index: int) -> void:
		emitted["count"] += 1
	)
	if pulse_index == -1:
		push_error("Runtime picker did not expose Pulse.")
		failed = true
	else:
		picker.call("_apply_theme", pulse_index)
		await process_frame
		var applied := target.theme as NeoCadeTheme
		if applied == null:
			push_error("Runtime picker did not apply NeoCadeTheme.")
			failed = true
		else:
			if applied.style != NeoCadeTheme.Style.PULSE:
				push_error("Runtime picker applied style %s, expected Pulse." % NeoCadeTheme.style_label(applied.style))
				failed = true
			if not applied.source_color.is_equal_approx(Color("#3AA8FF")):
				push_error("Runtime picker did not reset Pulse source_color; got %s." % applied.source_color)
				failed = true
			if not applied.raised:
				push_error("Runtime picker did not preserve raised=true.")
				failed = true
			if applied.platform != NeoCadeTheme.Platform.MOBILE:
				push_error("Runtime picker did not preserve platform=MOBILE.")
				failed = true
			if applied.use_runtime_popup_selection_icons:
				push_error("Runtime picker did not preserve use_runtime_popup_selection_icons=false.")
				failed = true
			if not applied.texture_cache:
				push_error("Runtime picker did not preserve texture_cache=true.")
				failed = true

		picker.call("_apply_theme", pulse_index)
		await process_frame
		if int(emitted["count"]) != 1:
			push_error("Runtime picker re-applied an already matching style preset; emitted=%d." % int(emitted["count"]))
			failed = true

	print("THEME_OPTION_BUTTON_RUNTIME_PRESET_PROBE: %s" % ("FAIL" if failed else "PASS"))
	host.queue_free()
	quit(1 if failed else 0)


func _index_for_style(picker: OptionButton, style_value: int) -> int:
	for i in range(picker.item_count):
		if int(picker.get_item_metadata(i)) == style_value:
			return i
	return -1
