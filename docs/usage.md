# NeoCade Theme

A drop-in [Godot 4.6](https://godotengine.org/) UI Theme system styling every
built-in `Control` with a flat [Material Design 3 / MD3 Expressive](https://m3.material.io/)
aesthetic. Native, accessibility-first, universal across the Godot Editor
and game runtime. Optional "extruded flat 3D" raised variation per the
[Flat-3D Game UI](https://hcgamestudios.itch.io/flat-game-ui-for-mobile-games)
pattern.

**No textures. No patterns. No embossing. No painterly chrome. No gradients
on chrome.** Solid colors + offset darker shape duplicates for depth on the
raised variation only.

## Recommended Starter

**Pulse** is the recommended starter preset for new consumers. Try this first:

```gdscript
@export var theme: NeoCadeTheme = preload("res://addons/neocade_theme/neocade_theme.tres")
```

Or assign `res://addons/neocade_theme/neocade_theme.tres` via the Editor's
Inspector `theme` slot on any `Control`.

## Presets

v1 ships one canonical `.tres` file with five built-in presets. All presets
share the same `NeoCadeTheme` engine and the same exported controls.

| Preset | Personality |
|---|---|
| **Pulse** | Arcade-dense; cabinet-bezel rectangles; bold accent fill on primary |
| **Slate** | Spacious-premium-quiet; rounded-pill primary; iOS-style focus offset |
| **Bubble** | Friendly-airy-generous; pillowy fully-rounded primary; pastel pink accent |
| **Daybreak** | Airy-breathing; gentle rounded; mint-halo focus ring |
| **Burst** | Event-spread-hierarchy-amplified; oversized statement primary; gold accent |

Select a preset in the Inspector through the `preset` export, or in code:

```gdscript
var active_theme: NeoCadeTheme = preload("res://addons/neocade_theme/neocade_theme.tres").duplicate(true)
active_theme.preset = NeoCadeTheme.Preset.SLATE
theme = active_theme
```

The `raised` and `platform` exports are universal variants. They work with
every preset:

```gdscript
active_theme.raised = true
active_theme.platform = NeoCadeTheme.Platform.MOBILE
```

`Platform.AUTO` is the default and auto-detects mobile targets with
`OS.has_feature("mobile")`.

Migration note: older per-preset files such as `pulse_neocade_theme.tres` have
been replaced by `neocade_theme.tres` plus the `preset` export.

## Custom Themes

Set `preset = NeoCadeTheme.Preset.NONE` to make the direction exports manual.
Changing direction-defining exports such as `base_color`, `accent_color`,
`corner_radius`, `spacing`, `raised_strength`, `focus_thickness`, or
`outline_width` will update the preset back to a matching built-in preset when
the values match one exactly; otherwise it falls back to `NONE`.
`Preset.NONE` uses NeoCade's default hidden direction personality rather than
inferring one from `base_color`.

```gdscript
var custom_theme := NeoCadeTheme.new()
custom_theme.preset = NeoCadeTheme.Preset.NONE
custom_theme.base_color = Color("#080A1E")
custom_theme.accent_color = Color("#FF66AA")
custom_theme.corner_radius = 10
theme = custom_theme
```

Or in the Godot FileSystem dock: right-click -> New Resource ->
`NeoCadeTheme`, set `preset` to `NONE` or a built-in preset, then save the
resource anywhere in your project.

## Theme Editor Authoring

The exported properties drive generated theme entries through
`_regenerate_theme()`. Godot's standard Theme Editor can still author extra
entries by hand. Slots not owned by NeoCade's binding table are left untouched;
slots owned by the binding table regenerate when exported values change.

Do not edit a `NeoCadeTheme` resource through a Control inspector context menu.
Use the dedicated Theme Editor, the exported properties on the
`NeoCadeTheme` resource, or code/formula edits in
`addons/neocade_theme/scripts/neocade_theme.gd`. This avoids Godot issue
`#115500`.

Godot may serialize generated Theme entries after you edit and save a
`NeoCadeTheme` resource. That is expected Godot behavior for scripted `Theme`
resources and does not require an editor plugin.

## CJK / Non-Latin Script Support

NeoCade ships only Inter Variable Roman as its bundled font. Consumers needing
CJK or other script-specific visual harmony can append a fallback to the
theme's `default_font.fallbacks`:

```gdscript
func _ready() -> void:
    var active_theme: NeoCadeTheme = preload("res://addons/neocade_theme/neocade_theme.tres").duplicate(true)
    var inter: FontFile = active_theme.default_font as FontFile
    var cjk_fallback: FontFile = preload("res://path/to/NotoSansCJK-Regular.ttf")
    inter.fallbacks = [cjk_fallback]
    theme = active_theme
```

Godot's system font fallback remains available when no explicit fallback is
set.

## Code Font

NeoCade does not bundle a monospaced font. Consumers who use CodeEdit or
`[code]` BBCode should ship their preferred mono font:

```gdscript
code_edit.add_theme_font_override("font", preload("res://your_mono.ttf"))
```

Recommended monos: JetBrains Mono, Fira Code, IBM Plex Mono, Source Code Pro.

## Italic Emphasis

Inter Italic Variable is not bundled in v1. For italic emphasis on bundled
Inter, use Godot's synthetic italic transform:

```gdscript
var italic := FontVariation.new()
italic.base_font = preload("res://addons/neocade_theme/fonts/inter_variable.ttf")
italic.transform = Transform2D(1.0, tan(deg_to_rad(12)), 0.0, 1.0, 0.0, 0.0)
label.add_theme_font_override("font_italic", italic)
```

## Architecture

- **Single concrete class:** `addons/neocade_theme/scripts/neocade_theme.gd`
  declares `@tool class_name NeoCadeTheme extends Theme`.
- **One canonical resource:** `addons/neocade_theme/neocade_theme.tres`
  stores the reusable theme resource.
- **Preset enum:** `NeoCadeTheme.Preset` switches Pulse, Slate, Bubble,
  Daybreak, Burst, or `NONE`.
- **Dynamic regeneration:** exported setters update Theme entries through
  `set_stylebox`, `set_color`, `set_constant`, `set_font`, and related APIs.
- **No plugin:** NeoCade does not require `plugin.cfg`, `EditorPlugin`, or a
  custom resource saver.

## Showcase

The repository-level `showcase/showcase.tscn` opens with Pulse and includes:

- a `NeoCadeThemeOptionButton` preset picker that lists Bubble, Burst,
  Daybreak, Pulse, Slate, and optional `None`;
- an editor-authored Control tree previewable directly in the Godot editor;
- a reusable picker script at
  `res://addons/neocade_theme/scripts/neocade_theme_option_button.gd`;
- a `theme_selected(theme, index)` signal emitted after the picker applies a
  theme; `None` emits `null`;
- 9 sections covering controls, dialogs, graph, token gallery, and coverage.

The Web export preset is named `Web`; the release workflow publishes the
showcase as both a zip asset and a GitHub Pages deployment.

## Distribution

v1 is distributed through GitHub Releases, not the Godot Asset Library. Install
by downloading `neocade_theme-v<VERSION>.zip` and copying its
`addons/neocade_theme/` directory into your project.

## Cross-References

- **CHANGELOG:** [CHANGELOG.md](../CHANGELOG.md)
- **Font license:** [addons/neocade_theme/fonts/inter_ofl.txt](../addons/neocade_theme/fonts/inter_ofl.txt)
- **Code license:** [LICENSE.md](../LICENSE.md)
- **Version:** [VERSION](../VERSION)
- **Internal design tokens:** `.planning/DESIGN_TOKENS.md`
- **Internal mobile design spec:** `.planning/MOBILE-DESIGN-SPEC.md`

---

_Updated through the one-resource preset architecture cleanup._
