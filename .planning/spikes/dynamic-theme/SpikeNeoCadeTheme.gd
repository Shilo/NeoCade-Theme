@tool
extends Theme
class_name SpikeNeoCadeTheme

enum PlatformMode { DESKTOP, MOBILE, AUTO }

var _base_color: Color = Color("#252837")
var _accent_color: Color = Color("#35d2ff")
var _raised: bool = false
var _platform: int = PlatformMode.AUTO
var _regenerating := false
var _last_regeneration_usec := 0
var _last_resolved_platform := PlatformMode.DESKTOP

@export var base_color: Color:
	get:
		return _base_color
	set(value):
		_base_color = value
		_regenerate()

@export var accent_color: Color:
	get:
		return _accent_color
	set(value):
		_accent_color = value
		_regenerate()

@export var raised: bool:
	get:
		return _raised
	set(value):
		_raised = value
		_regenerate()

@export_enum("Desktop", "Mobile", "Auto") var platform: int:
	get:
		return _platform
	set(value):
		_platform = value
		_regenerate()

func _init() -> void:
	_regenerate()

func _theme_profile() -> Dictionary:
	return {
		"contrast_strength": 0.18,
		"corner_radius": 8,
		"border_width": 1,
		"accent_mix": 0.12,
		"font_size_desktop": 15,
		"font_size_mobile": 18,
		"min_touch_desktop": 32,
		"min_touch_mobile": 44,
	}

func _after_base_regenerate(_context: Dictionary) -> void:
	pass

func _regenerate() -> void:
	if _regenerating:
		return

	_regenerating = true
	var started := Time.get_ticks_usec()
	clear()

	var resolved_platform := _resolve_platform()
	_last_resolved_platform = resolved_platform
	var profile := _theme_profile()
	var mobile := resolved_platform == PlatformMode.MOBILE
	var font_size: int = profile.font_size_mobile if mobile else profile.font_size_desktop
	var min_touch: int = profile.min_touch_mobile if mobile else profile.min_touch_desktop
	var radius: int = int(profile.corner_radius) + (2 if _raised else 0)
	var border_width: int = int(profile.border_width) + (1 if _raised else 0)

	var context := {
		"profile": profile,
		"mobile": mobile,
		"font_size": font_size,
		"min_touch": min_touch,
		"radius": radius,
		"border_width": border_width,
		"surface_lowest": _derive_surface(-1.15, 0.90),
		"surface_low": _derive_surface(-0.55, 0.95),
		"surface_base": _derive_surface(0.00, 1.00),
		"surface_raised": _derive_surface(0.30, 0.90),
		"surface_overlay": _derive_surface(0.55, 0.80),
		"accent": _accent_color,
		"font": _readable_on(_base_color),
	}

	_build_button_family(context)
	_build_line_edit(context)
	_build_tree(context)
	_build_popup_menu(context)
	_build_window(context)
	_build_scrollbar(context)
	_after_base_regenerate(context)

	_last_regeneration_usec = Time.get_ticks_usec() - started
	_regenerating = false

func _build_button_family(context: Dictionary) -> void:
	var normal := _make_box(context.surface_raised, context.surface_overlay, context.radius, context.border_width, context.min_touch)
	var hover := _make_box(_mix(context.surface_raised, context.accent, 0.16), context.accent, context.radius, context.border_width, context.min_touch)
	var pressed := _make_box(_mix(context.surface_low, context.accent, 0.22), context.accent, context.radius, context.border_width, context.min_touch)
	var disabled := _make_box(_derive_surface(-0.75, 0.55), _derive_surface(-0.30, 0.45), context.radius, 1, context.min_touch)
	var focus := _make_focus_box(context.accent, context.radius + 2, 2)

	for theme_type in ["Button", "OptionButton"]:
		set_stylebox("normal", theme_type, normal.duplicate())
		set_stylebox("hover", theme_type, hover.duplicate())
		set_stylebox("pressed", theme_type, pressed.duplicate())
		set_stylebox("hover_pressed", theme_type, pressed.duplicate())
		set_stylebox("disabled", theme_type, disabled.duplicate())
		set_stylebox("focus", theme_type, focus.duplicate())
		set_color("font_color", theme_type, context.font)
		set_color("font_hover_color", theme_type, _readable_on(hover.bg_color))
		set_color("font_pressed_color", theme_type, _readable_on(pressed.bg_color))
		set_color("font_hover_pressed_color", theme_type, _readable_on(pressed.bg_color))
		set_color("font_disabled_color", theme_type, Color(context.font, 0.42))
		set_color("font_focus_color", theme_type, context.font)
		set_font_size("font_size", theme_type, context.font_size)
		set_constant("h_separation", theme_type, 8 if !context.mobile else 12)

	set_constant("arrow_margin", "OptionButton", 10 if !context.mobile else 14)

	set_color("font_color", "CheckBox", context.font)
	set_color("font_hover_color", "CheckBox", _readable_on(hover.bg_color))
	set_color("font_pressed_color", "CheckBox", _readable_on(pressed.bg_color))
	set_color("font_hover_pressed_color", "CheckBox", _readable_on(pressed.bg_color))
	set_color("font_disabled_color", "CheckBox", Color(context.font, 0.42))
	set_font_size("font_size", "CheckBox", context.font_size)
	set_constant("check_v_offset", "CheckBox", 0)
	set_constant("h_separation", "CheckBox", 8 if !context.mobile else 12)

func _build_line_edit(context: Dictionary) -> void:
	set_stylebox("normal", "LineEdit", _make_box(context.surface_low, context.surface_overlay, context.radius, context.border_width, context.min_touch))
	set_stylebox("focus", "LineEdit", _make_box(context.surface_lowest, context.accent, context.radius, 2, context.min_touch))
	set_stylebox("read_only", "LineEdit", _make_box(_derive_surface(-0.90, 0.55), context.surface_low, context.radius, 1, context.min_touch))
	set_color("font_color", "LineEdit", context.font)
	set_color("font_selected_color", "LineEdit", _readable_on(context.accent))
	set_color("caret_color", "LineEdit", context.accent)
	set_color("selection_color", "LineEdit", Color(context.accent, 0.42))
	set_font_size("font_size", "LineEdit", context.font_size)
	set_constant("minimum_character_width", "LineEdit", 4)

func _build_tree(context: Dictionary) -> void:
	set_stylebox("panel", "Tree", _make_box(context.surface_low, context.surface_overlay, context.radius, context.border_width, context.min_touch))
	set_stylebox("focus", "Tree", _make_focus_box(context.accent, context.radius + 2, 2))
	set_stylebox("cursor", "Tree", _make_box(Color(context.accent, 0.18), context.accent, 4, 1, 0))
	set_stylebox("selected", "Tree", _make_box(Color(context.accent, 0.26), context.accent, 4, 1, 0))
	set_color("font_color", "Tree", context.font)
	set_color("font_selected_color", "Tree", _readable_on(context.accent))
	set_color("guide_color", "Tree", Color(context.font, 0.20))
	set_font_size("font_size", "Tree", context.font_size)
	set_constant("h_separation", "Tree", 8 if !context.mobile else 12)
	set_constant("v_separation", "Tree", 2 if !context.mobile else 6)
	set_constant("item_margin", "Tree", 12 if !context.mobile else 16)

func _build_popup_menu(context: Dictionary) -> void:
	set_stylebox("panel", "PopupMenu", _make_box(context.surface_base, context.surface_overlay, 6, context.border_width, context.min_touch))
	set_stylebox("hover", "PopupMenu", _make_box(Color(context.accent, 0.22), context.accent, 4, 1, 0))
	set_stylebox("separator", "PopupMenu", _make_line(context.surface_overlay, false))
	set_stylebox("labeled_separator_left", "PopupMenu", _make_line(context.surface_overlay, false))
	set_stylebox("labeled_separator_right", "PopupMenu", _make_line(context.surface_overlay, false))
	set_color("font_color", "PopupMenu", context.font)
	set_color("font_hover_color", "PopupMenu", _readable_on(context.accent))
	set_color("font_disabled_color", "PopupMenu", Color(context.font, 0.45))
	set_font_size("font_size", "PopupMenu", context.font_size)
	set_constant("h_separation", "PopupMenu", 10 if !context.mobile else 14)
	set_constant("v_separation", "PopupMenu", 4 if !context.mobile else 8)
	set_constant("item_start_padding", "PopupMenu", 12 if !context.mobile else 16)

func _build_window(context: Dictionary) -> void:
	set_stylebox("embedded_border", "Window", _make_box(context.surface_base, context.surface_overlay, context.radius, context.border_width, context.min_touch))
	set_stylebox("embedded_unfocused_border", "Window", _make_box(context.surface_low, context.surface_overlay, context.radius, 1, context.min_touch))
	set_color("title_color", "Window", context.font)
	set_color("title_outline_modulate", "Window", Color(0, 0, 0, 0))
	set_font_size("title_font_size", "Window", context.font_size)
	set_constant("title_height", "Window", 30 if !context.mobile else 40)
	set_constant("resize_margin", "Window", 6 if !context.mobile else 10)

func _build_scrollbar(context: Dictionary) -> void:
	set_stylebox("scroll", "HScrollBar", _make_box(Color(context.surface_low, 0.70), context.surface_low, 999, 0, 8 if !context.mobile else 12))
	set_stylebox("grabber", "HScrollBar", _make_box(context.surface_overlay, context.surface_overlay, 999, 0, 8 if !context.mobile else 12))
	set_stylebox("grabber_highlight", "HScrollBar", _make_box(_mix(context.surface_overlay, context.accent, 0.18), context.accent, 999, 0, 8 if !context.mobile else 12))
	set_stylebox("grabber_pressed", "HScrollBar", _make_box(_mix(context.surface_overlay, context.accent, 0.30), context.accent, 999, 0, 8 if !context.mobile else 12))
	set_constant("grabber_minimum_size", "HScrollBar", 28 if !context.mobile else 44)

func _derive_surface(brightness_offset: float = 0.0, saturation_multiplier: float = 1.0) -> Color:
	var color := Color(_base_color)
	var polarity := 1.0 if color.get_luminance() < 0.5 else -1.0
	var contrast_strength: float = _theme_profile().contrast_strength
	return Color.from_hsv(
		color.h,
		clampf(color.s * saturation_multiplier, 0.0, 1.0),
		clampf(color.v + brightness_offset * contrast_strength * polarity, 0.0, 1.0),
		color.a
	)

func _make_box(bg: Color, border: Color, radius: int, border_width: int, minimum: int) -> StyleBoxFlat:
	var sb := StyleBoxFlat.new()
	sb.bg_color = bg
	sb.border_color = border
	sb.set_border_width_all(border_width)
	sb.set_corner_radius_all(radius)
	sb.set_content_margin_all(maxi(4, int(minimum * 0.28)))
	sb.shadow_size = 0
	return sb

func _make_focus_box(color: Color, radius: int, border_width: int) -> StyleBoxFlat:
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0, 0, 0, 0)
	sb.draw_center = false
	sb.border_color = color
	sb.set_border_width_all(border_width)
	sb.set_corner_radius_all(radius)
	sb.shadow_size = 0
	return sb

func _make_line(color: Color, vertical: bool) -> StyleBoxLine:
	var sb := StyleBoxLine.new()
	sb.color = color
	sb.thickness = 1
	sb.vertical = vertical
	return sb

func _mix(a: Color, b: Color, weight: float) -> Color:
	return a.lerp(b, clampf(weight, 0.0, 1.0))

func _readable_on(color: Color) -> Color:
	return Color("#151821") if color.get_luminance() > 0.54 else Color("#f7fbff")

func _feature_flags() -> PackedStringArray:
	var flags := PackedStringArray()
	for feature in ["mobile", "web", "web_android", "web_ios", "web_windows", "web_macos", "web_linuxbsd", "android", "ios"]:
		if OS.has_feature(feature):
			flags.append(feature)
	return flags

func _resolve_platform() -> int:
	if _platform == PlatformMode.DESKTOP or _platform == PlatformMode.MOBILE:
		return _platform
	return _resolve_auto_platform(_feature_flags(), OS.get_name())

func _resolve_auto_platform(features: PackedStringArray, os_name: String) -> int:
	if features.has("mobile") or features.has("android") or features.has("ios") or features.has("web_android") or features.has("web_ios"):
		return PlatformMode.MOBILE
	if features.has("web_windows") or features.has("web_macos") or features.has("web_linuxbsd"):
		return PlatformMode.DESKTOP
	if features.has("web"):
		return PlatformMode.MOBILE
	match os_name:
		"Android", "iOS":
			return PlatformMode.MOBILE
		"Windows", "macOS", "Linux", "FreeBSD", "NetBSD", "OpenBSD", "BSD":
			return PlatformMode.DESKTOP
		_:
			return PlatformMode.MOBILE

func get_last_resolved_platform() -> int:
	return _last_resolved_platform

func get_last_regeneration_usec() -> int:
	return _last_regeneration_usec
