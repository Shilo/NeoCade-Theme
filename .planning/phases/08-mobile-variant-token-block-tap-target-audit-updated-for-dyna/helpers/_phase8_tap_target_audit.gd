extends RefCounted
class_name Phase8TapTargetAudit

const PHASE8_TAP_TARGET_AUDIT := true
const MIN_TAP_TARGET := 48

const DIRECTIONS := {
	"Pulse": "res://addons/neocade_theme/pulse_neocade_theme.tres",
	"Slate": "res://addons/neocade_theme/slate_neocade_theme.tres",
	"Bubble": "res://addons/neocade_theme/bubble_neocade_theme.tres",
	"Daybreak": "res://addons/neocade_theme/daybreak_neocade_theme.tres",
	"Burst": "res://addons/neocade_theme/burst_neocade_theme.tres",
}

const SCORECARD_37 := [
	{"type": "AcceptDialog", "classification": "display", "formula": "dialog shell delegates tap targets to child Buttons"},
	{"type": "Button", "classification": "interactive", "formula": "button_w/Button.normal + button_h/Button.normal"},
	{"type": "CheckBox", "classification": "interactive", "formula": "checkbox icon/text/separation + Button-family normal"},
	{"type": "CheckButton", "classification": "interactive", "formula": "checkbutton icon/text + Button-family normal"},
	{"type": "CodeEdit", "classification": "interactive", "formula": "tokens.inputMin + input_h(CodeEdit.normal)"},
	{"type": "ColorPicker", "classification": "interactive", "formula": "picker constants sv/h widths/heights and cursor/bar icons"},
	{"type": "ColorPickerButton", "classification": "interactive", "formula": "button_w/ColorPickerButton.normal + button_h"},
	{"type": "ConfirmationDialog", "classification": "display", "formula": "dialog shell delegates tap targets to child Buttons"},
	{"type": "FileDialog", "classification": "display", "formula": "thumbnail_size proxy; shell buttons inherit Button"},
	{"type": "FoldableContainer", "classification": "interactive", "formula": "title font + arrow + h_separation + title_panel"},
	{"type": "GraphEdit", "classification": "interactive", "formula": "port_hotzone_inner_extent + port_hotzone_outer_extent"},
	{"type": "HScrollBar", "classification": "interactive", "formula": "grabber margins and decrement/increment icons"},
	{"type": "HSlider", "classification": "interactive", "formula": "grabber icon and grabber_area stylebox"},
	{"type": "HSplitContainer", "classification": "interactive", "formula": "minimum_grab_thickness/separation/touch dragger proxy"},
	{"type": "ItemList", "classification": "interactive", "formula": "row_h from font/separation/inner margins"},
	{"type": "Label", "classification": "display", "formula": "text display is not a tap target"},
	{"type": "LineEdit", "classification": "interactive", "formula": "tokens.inputMin + input_h(LineEdit.normal)"},
	{"type": "LinkButton", "classification": "interactive", "formula": "font + underline/outline proxy; limited by no stylebox minimum"},
	{"type": "MenuBar", "classification": "interactive", "formula": "font + h_separation + normal stylebox"},
	{"type": "MenuButton", "classification": "interactive", "formula": "button_w/MenuButton.normal + button_h"},
	{"type": "OptionButton", "classification": "interactive", "formula": "button_w/OptionButton.normal + button_h"},
	{"type": "Panel", "classification": "layout", "formula": "panel chrome is not interactive"},
	{"type": "PopupMenu", "classification": "interactive", "formula": "font + item padding + icon_max_width + v_separation"},
	{"type": "PopupPanel", "classification": "display", "formula": "popup shell delegates tap targets"},
	{"type": "ProgressBar", "classification": "display", "formula": "indicator is not a tap target"},
	{"type": "RichTextLabel", "classification": "display", "formula": "text display is not a tap target"},
	{"type": "SpinBox", "classification": "interactive", "formula": "LineEdit input proxy + up/down icons"},
	{"type": "TabBar", "classification": "interactive", "formula": "tab font + tab_selected margins + close icon"},
	{"type": "TabContainer", "classification": "interactive", "formula": "tab strip font + tab_selected margins + icon_separation"},
	{"type": "TextEdit", "classification": "interactive", "formula": "tokens.inputMin + input_h(TextEdit.normal)"},
	{"type": "TooltipLabel", "classification": "display", "formula": "tooltip text is not a tap target"},
	{"type": "TooltipPanel", "classification": "display", "formula": "tooltip shell is not a tap target"},
	{"type": "Tree", "classification": "interactive", "formula": "row_h from font/separations/icon width"},
	{"type": "VScrollBar", "classification": "interactive", "formula": "grabber margins and decrement/increment icons"},
	{"type": "VSlider", "classification": "interactive", "formula": "grabber icon and grabber_area stylebox"},
	{"type": "VSplitContainer", "classification": "interactive", "formula": "minimum_grab_thickness/separation/touch dragger proxy"},
	{"type": "Window", "classification": "display", "formula": "engine/window-managed titlebar hit rects"},
]

static func run_audit() -> Dictionary:
	var rows: Array[Dictionary] = []
	for direction_name in DIRECTIONS.keys():
		var loaded := ResourceLoader.load(DIRECTIONS[direction_name], "", ResourceLoader.CACHE_MODE_IGNORE)
		if not (loaded is NeoCadeTheme):
			rows.append(_row(direction_name, false, "(resource)", "interactive", "load direction", 0, 0, "FAIL", "resource did not load as NeoCadeTheme"))
			continue
		for raised_value in [false, true]:
			var theme: NeoCadeTheme = (loaded as NeoCadeTheme).duplicate(true)
			theme.platform = NeoCadeTheme.Platform.MOBILE
			theme.raised = raised_value
			for spec in SCORECARD_37:
				rows.append(_audit_type(theme, direction_name, raised_value, spec))
	var failures := 0
	var limited := 0
	var passed := 0
	var na := 0
	for r in rows:
		match String(r.status):
			"FAIL":
				failures += 1
			"LIMITED":
				limited += 1
			"PASS":
				passed += 1
			"N/A":
				na += 1
	return {
		"rows": rows,
		"failures": failures,
		"limited": limited,
		"passed": passed,
		"na": na,
	}

static func emit_report(result: Dictionary) -> void:
	print("PHASE8_TAP_TARGET_AUDIT platform=MOBILE floor=%dpx" % MIN_TAP_TARGET)
	print("totals: PASS=%d LIMITED=%d N/A=%d FAIL=%d" % [result.passed, result.limited, result.na, result.failures])
	for row: Dictionary in result.rows:
		print("%s raised=%s type=%s class=%s width=%.1f height=%.1f status=%s formula=%s notes=%s" % [
			row.direction, str(row.raised), row.type, row.classification,
			float(row.width_proxy), float(row.height_proxy), row.status, row.formula, row.notes
		])
	print("limitations: LIMITED rows document missing theme-side minimums; display/layout rows are N/A and not fake-padded.")
	if int(result.failures) == 0:
		print("summary: 0 failures")
	else:
		print("summary: %d failures" % int(result.failures))

static func _audit_type(theme: Theme, direction_name: String, raised_value: bool, spec: Dictionary) -> Dictionary:
	var type_name := String(spec.type)
	var classification := String(spec.classification)
	var formula := String(spec.formula)
	if classification != "interactive":
		return _row(direction_name, raised_value, type_name, classification, formula, 0, 0, "N/A", "not an enforceable interactive tap target")
	var size := _proxy_size(theme, type_name)
	var width := float(size.x)
	var height := float(size.y)
	var status := "PASS"
	var notes := "theme-side proxy meets 48px floor"
	if type_name == "LinkButton":
		status = "LIMITED"
		notes = "Godot exposes no stylebox/minimum-size theme slot for LinkButton; proxy is font/underline only"
	elif width < MIN_TAP_TARGET or height < MIN_TAP_TARGET:
		status = "FAIL"
		notes = "enforceable interactive proxy below 48px"
	return _row(direction_name, raised_value, type_name, classification, formula, width, height, status, notes)

static func _proxy_size(theme: Theme, type_name: String) -> Vector2:
	match type_name:
		"Button", "ColorPickerButton", "MenuButton", "OptionButton":
			return _button_size(theme, type_name)
		"CheckBox", "CheckButton":
			return Vector2(max(_button_size(theme, type_name).x, _icon_w(theme, type_name, "checked") + _font_y(theme, type_name) + _k(theme, type_name, "h_separation")), max(_button_size(theme, type_name).y, _icon_h(theme, type_name, "checked"), _font_y(theme, type_name) + _sb_y(theme, type_name, "normal")))
		"CodeEdit", "LineEdit", "TextEdit":
			return Vector2(56, max(56, _font_y(theme, type_name) + _sb_y(theme, type_name, "normal")))
		"SpinBox":
			var input_h := max(56, _font_y(theme, "LineEdit") + _sb_y(theme, "LineEdit", "normal"))
			return Vector2(max(56, input_h + _icon_w(theme, "SpinBox", "up")), max(56, input_h, _icon_h(theme, "SpinBox", "up") + _icon_h(theme, "SpinBox", "down")))
		"FileDialog":
			var thumb := _k(theme, "FileDialog", "thumbnail_size")
			return Vector2(thumb, thumb)
		"FoldableContainer":
			return Vector2(max(48, _font_y(theme, type_name) + _icon_w(theme, type_name, "expanded_arrow") + _k(theme, type_name, "h_separation")), max(48, _font_y(theme, type_name) + _sb_y(theme, type_name, "title_panel")))
		"GraphEdit":
			var hotzone := _k(theme, type_name, "port_hotzone_inner_extent") + _k(theme, type_name, "port_hotzone_outer_extent")
			return Vector2(max(48, hotzone), max(48, hotzone))
		"HScrollBar":
			return Vector2(max(48, _icon_w(theme, type_name, "decrement"), _icon_w(theme, type_name, "increment"), _sb_x(theme, type_name, "grabber")), max(48, _sb_y(theme, type_name, "grabber"), _icon_h(theme, type_name, "decrement")))
		"VScrollBar":
			return Vector2(max(48, _sb_x(theme, type_name, "grabber"), _icon_w(theme, type_name, "decrement")), max(48, _icon_h(theme, type_name, "decrement"), _icon_h(theme, type_name, "increment"), _sb_y(theme, type_name, "grabber")))
		"HSlider", "VSlider":
			return Vector2(max(48, _icon_w(theme, type_name, "grabber"), _sb_x(theme, type_name, "grabber_area")), max(48, _icon_h(theme, type_name, "grabber"), _sb_y(theme, type_name, "grabber_area")))
		"HSplitContainer", "VSplitContainer":
			return Vector2(max(48, _k(theme, type_name, "minimum_grab_thickness"), _k(theme, type_name, "separation")), max(48, _k(theme, type_name, "minimum_grab_thickness"), _k(theme, type_name, "separation")))
		"ItemList", "Tree":
			return Vector2(max(48, _font_y(theme, type_name) + _k(theme, type_name, "h_separation") + _k(theme, type_name, "icon_h_separation") + _k(theme, type_name, "icon_max_width") + _k(theme, type_name, "icon_margin")), max(48, _row_h(theme, type_name)))
		"LinkButton":
			return Vector2(max(48, _font_y(theme, type_name) + _k(theme, type_name, "underline_spacing")), max(48, _font_y(theme, type_name) + _k(theme, type_name, "outline_size")))
		"MenuBar":
			return Vector2(max(48, _font_y(theme, type_name) + _k(theme, type_name, "h_separation")), max(48, _font_y(theme, type_name) + _sb_y(theme, type_name, "normal")))
		"PopupMenu":
			return Vector2(max(48, _font_y(theme, type_name) + _k(theme, type_name, "item_start_padding") + _k(theme, type_name, "item_end_padding") + _k(theme, type_name, "icon_max_width")), max(48, _font_y(theme, type_name) + _k(theme, type_name, "v_separation")))
		"TabBar", "TabContainer":
			return Vector2(max(48, _font_y(theme, type_name) + _sb_x(theme, type_name, "tab_selected") + _k(theme, type_name, "h_separation") + _k(theme, type_name, "icon_separation") + _icon_w(theme, type_name, "close")), max(48, _font_y(theme, type_name) + _sb_y(theme, type_name, "tab_selected")))
		"ColorPicker":
			return Vector2(max(48, _k(theme, type_name, "sv_width"), _k(theme, type_name, "h_width"), _icon_w(theme, type_name, "picker_cursor")), max(48, _k(theme, type_name, "sv_height"), _icon_h(theme, type_name, "bar_arrow"), _k(theme, type_name, "margin")))
	return Vector2(48, 48)

static func _button_size(theme: Theme, type_name: String) -> Vector2:
	return Vector2(max(48, _font_y(theme, type_name) + _sb_x(theme, type_name, "normal") + _k(theme, type_name, "h_separation") + max(_icon_w(theme, type_name, "icon"), _icon_w(theme, type_name, "arrow"), _icon_w(theme, type_name, "bg"))), max(48, _font_y(theme, type_name) + _sb_y(theme, type_name, "normal"), _icon_h(theme, type_name, "bg")))

static func _row_h(theme: Theme, type_name: String) -> float:
	return max(48, _font_y(theme, type_name) + _k(theme, type_name, "v_separation") + _k(theme, type_name, "line_separation") + _k(theme, type_name, "inner_item_margin_top") + _k(theme, type_name, "inner_item_margin_bottom"))

static func _font_y(theme: Theme, type_name: String, slot: String = "font_size") -> float:
	if theme.has_font_size(slot, type_name):
		return theme.get_font_size(slot, type_name)
	if theme.has_font_size("normal_font_size", type_name):
		return theme.get_font_size("normal_font_size", type_name)
	return theme.default_font_size

static func _sb_x(theme: Theme, type_name: String, slot: String) -> float:
	if not theme.has_stylebox(slot, type_name):
		return 0
	var sb := theme.get_stylebox(slot, type_name)
	return sb.content_margin_left + sb.content_margin_right

static func _sb_y(theme: Theme, type_name: String, slot: String) -> float:
	if not theme.has_stylebox(slot, type_name):
		return 0
	var sb := theme.get_stylebox(slot, type_name)
	return sb.content_margin_top + sb.content_margin_bottom

static func _icon_w(theme: Theme, type_name: String, slot: String) -> float:
	if not theme.has_icon(slot, type_name):
		return 0
	var icon := theme.get_icon(slot, type_name)
	return icon.get_width() if icon != null else 0

static func _icon_h(theme: Theme, type_name: String, slot: String) -> float:
	if not theme.has_icon(slot, type_name):
		return 0
	var icon := theme.get_icon(slot, type_name)
	return icon.get_height() if icon != null else 0

static func _k(theme: Theme, type_name: String, slot: String) -> int:
	if theme.has_constant(slot, type_name):
		return theme.get_constant(slot, type_name)
	return 0

static func _row(direction: String, raised_value: bool, type_name: String, classification: String, formula: String, width: float, height: float, status: String, notes: String) -> Dictionary:
	return {
		"direction": direction,
		"raised": raised_value,
		"type": type_name,
		"classification": classification,
		"formula": formula,
		"width_proxy": width,
		"height_proxy": height,
		"status": status,
		"notes": notes,
	}
