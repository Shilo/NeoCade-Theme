extends SceneTree

const KEYWORDS := [
	"Bottom",
	"bottom",
	"Toaster",
	"toaster",
	"Output",
	"Audio",
	"Shader",
	"Debugger",
	"Canvas",
	"canvas",
	"Toolbar",
	"toolbar",
	"Context",
	"context",
]


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	if not Engine.is_editor_hint():
		print("THEME_LIVE_EDITOR_LAYOUT_PROBE: SKIP Engine.is_editor_hint() is false; run with --editor")
		quit(0)
		return

	for i in 8:
		await process_frame

	print("THEME_LIVE_EDITOR_LAYOUT_PROBE: BEGIN")
	_print_theme_value_summary()
	_walk(root, 0, false)
	print("THEME_LIVE_EDITOR_LAYOUT_PROBE: END")
	quit(0)


func _print_theme_value_summary() -> void:
	var theme := load("res://addons/neocade_theme/neocade_theme.tres") as Theme
	_print_theme_values(theme, "THEME_LIVE_NEOCADE")
	_print_theme_values(EditorInterface.get_editor_theme(), "THEME_LIVE_MERGED_EDITOR")


func _print_theme_values(theme: Theme, prefix: String) -> void:
	for entry in [
		{"type": &"EditorStyles", "slot": &"Content"},
		{"type": &"EditorStyles", "slot": &"ContextualToolbar"},
		{"type": &"EditorStyles", "slot": &"BottomPanel"},
		{"type": &"BottomPanel", "slot": &"panel"},
	]:
		var stylebox := theme.get_stylebox(entry["slot"], entry["type"]) as StyleBoxFlat
		if stylebox == null:
			print("%s_STYLE %s.%s=<missing>" % [prefix, entry["type"], entry["slot"]])
			continue
		print("%s_STYLE %s.%s bg=%s border=%d/%d/%d/%d margins=%.1f/%.1f/%.1f/%.1f" % [
			prefix,
			entry["type"],
			entry["slot"],
			stylebox.bg_color.to_html(true),
			stylebox.border_width_left,
			stylebox.border_width_top,
			stylebox.border_width_right,
			stylebox.border_width_bottom,
			stylebox.content_margin_left,
			stylebox.content_margin_top,
			stylebox.content_margin_right,
			stylebox.content_margin_bottom,
		])
	var menu_icon := theme.get_icon(&"menu", &"TabContainer")
	print("%s_ICON TabContainer.menu size=%s" % [prefix, menu_icon.get_size()])


func _walk(node: Node, depth: int, force_branch: bool) -> void:
	var matches := _matches(node)
	var branch := force_branch or matches
	if branch and node is Control:
		_print_control(node as Control, depth)

	for child in node.get_children():
		_walk(child, depth + 1, branch)


func _matches(node: Node) -> bool:
	var text := "%s %s %s" % [node.name, node.get_class(), node.get_path()]
	for keyword in KEYWORDS:
		if text.contains(keyword):
			return true
	return false


func _print_control(control: Control, depth: int) -> void:
	var indent := ""
	for i in depth:
		indent += "  "

	var variation := control.theme_type_variation
	var size := control.size
	var min_size := control.get_combined_minimum_size()
	var custom_min := control.custom_minimum_size
	var parent_name := "<none>"
	if control.get_parent() != null:
		parent_name = "%s:%s" % [control.get_parent().name, control.get_parent().get_class()]

	print("%s%s class=%s var=%s parent=%s pos=%s size=%s min=%s custom_min=%s visible=%s" % [
		indent,
		control.name,
		control.get_class(),
		variation,
		parent_name,
		control.position,
		size,
		min_size,
		custom_min,
		control.visible,
	])
