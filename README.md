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

## Recommended starter

**Pulse** — `pulse_neocade_theme.tres` is the recommended starter direction
for new consumers. Try this first.

```gdscript
@export var theme: NeoCadeTheme = preload("res://addons/neocade_theme/pulse_neocade_theme.tres")
```

Or assign via the Editor's Inspector → `theme` slot on any `Control`.

## Available directions

v1 ships 5 approved directions, each as a data-only `.tres` file at the addon
root. All 5 directions share the same `NeoCadeTheme` engine — they differ
only in their 9 `@export` values and in optional Theme Editor authored entry
overrides for personality.

| Direction | File | Personality |
|---|---|---|
| **Pulse** ⭐ | `pulse_neocade_theme.tres` | Arcade-dense; cabinet-bezel rectangles; bold accent fill on primary |
| **Slate** | `slate_neocade_theme.tres` | Spacious-premium-quiet; rounded-pill primary; iOS-style focus offset |
| **Bubble** | `bubble_neocade_theme.tres` | Friendly-airy-generous; pillowy fully-rounded primary; pastel pink accent |
| **Daybreak** | `daybreak_neocade_theme.tres` | Airy-breathing; gentle rounded; mint-halo focus ring |
| **Burst** | `burst_neocade_theme.tres` | Event-spread-hierarchy-amplified; oversized statement primary; gold accent |

All 5 directions support both desktop and mobile via the `platform` `@export`
property (default: `Platform.AUTO` — auto-detects via
`OS.has_feature("mobile")`).

## Custom themes

`NeoCadeTheme` is **not abstract** — instantiate it directly to author your
own theme:

```gdscript
var custom_theme := NeoCadeTheme.new()
custom_theme.base_color = Color("#080A1E")
custom_theme.accent_color = Color("#FF66AA")
custom_theme.corner_radius = 10
# ... etc — see DESIGN_TOKENS.md for the 9 @export properties
apply_theme(custom_theme)
```

Or in the Godot FileSystem dock: right-click → New Resource → `NeoCadeTheme`,
fill in the 9 `@export` values, save as `my_neocade_theme.tres` somewhere in
your project, and use `preload("res://path/to/my_neocade_theme.tres")`.

## Theme Editor authoring

The 9 `@export` properties drive ALL theme entries via the BINDING_TABLE
iteration engine in `_regenerate_theme()`. **You can also author Theme Editor
entries by hand** — Godot's standard Theme Editor workflow works directly on
`NeoCadeTheme` resources. Slots not in BINDING_TABLE are LEFT UNTOUCHED by
`_regenerate_theme()` (the escape hatch); slots IN BINDING_TABLE are
formula-owned and will regenerate on `@export` mutations. This means custom
per-theme personality (e.g., a one-off splash-screen panel style) survives
`@export` changes.

## CJK / non-Latin script support

NeoCade ships **only** Inter Variable Roman as its bundled font (UD-4 Option
D); no CJK font is bundled. Consumers needing CJK script support append a
CJK fallback to the theme's `default_font.fallbacks`:

```gdscript
func _ready() -> void:
    var theme: NeoCadeTheme = preload("res://addons/neocade_theme/pulse_neocade_theme.tres").duplicate()
    # theme.default_font is the FontFile (Inter-Variable.ttf, imported by Godot)
    # per FONT-06; the cast succeeds. Godot 4 imports .ttf as a FontFile resource
    # via the .ttf.import sidecar, so we reference the .ttf directly.
    var inter: FontFile = theme.default_font as FontFile
    var cjk_fallback: FontFile = preload("res://path/to/NotoSansCJK-Regular.ttf")
    inter.fallbacks = [cjk_fallback]
    # Apply the modified theme to your Control / scene root
```

Godot's `default_font.allow_system_fallback = true` is already set in the
bundled `Inter-Variable.ttf.import` sidecar, so the OS-side font fallback
kicks in for unsupported scripts when no explicit fallback is set.

## Code font (CodeEdit / `[code]` BBCode)

NeoCade does **not** bundle a monospaced font (FONT-04 stricken — JetBrains
Mono Variable not bundled in v1). CodeEdit and `[code]` BBCode are rare in
shipped games; consumers who use code surfaces ship their preferred mono.

Override pattern:

```gdscript
# On a specific CodeEdit instance:
code_edit.add_theme_font_override("font", preload("res://your_mono.ttf"))
```

Or as a Theme entry override on a duplicated NeoCadeTheme:

```gdscript
var theme: NeoCadeTheme = preload("res://addons/neocade_theme/pulse_neocade_theme.tres").duplicate()
theme.set_font("font", "CodeEdit", preload("res://your_mono.ttf"))
```

Recommended monos: JetBrains Mono, Fira Code, IBM Plex Mono, Source Code Pro.

## Italic emphasis (synthetic fallback)

Inter Italic Variable is **not bundled** in v1 (FONT-07 deferred per UD-4
Option D). For italic emphasis on bundled Inter, use Godot's synthetic
italic transform:

```gdscript
# Option A — set the font_italic theme slot on a Label / RichTextLabel:
label.add_theme_font_override("font_italic", preload("res://addons/neocade_theme/fonts/Inter-Body.tres"))
# Then enable italic via BBCode [i]...[/i] in RichTextLabel; Godot applies
# the synthetic skew transform to render the upright glyphs as italic.

# Option B — author a FontVariation with a skew transform:
var italic := FontVariation.new()
italic.base_font = preload("res://addons/neocade_theme/fonts/Inter-Variable.ttf")
italic.transform = Transform2D(1.0, tan(deg_to_rad(12)), 0.0, 1.0, 0.0, 0.0)
```

Body text rendering with synthetic italics is acceptable; true Inter Italic
is deferred to v1.x.

## Architecture (v1)

- **Single concrete class:** `addons/neocade_theme/neocade_theme.gd` declares
  `@tool class_name NeoCadeTheme extends Theme` with 9 `@export` properties.
- **N data-only `.tres`:** v1 ships 5 (one per approved direction). No
  per-direction `.gd` files; no class hierarchy.
- **Dynamic regeneration:** Setters on every `@export` trigger
  `_regenerate_theme()` which walks an internal BINDING_TABLE, computes
  derived values (surface ramp, state layers, raised offsets, role tokens),
  and populates Theme entries via `set_stylebox` / `set_color` / etc.
- **Iteration is additive** — `_regenerate_theme()` does NOT call `clear()`.
  Slots not in BINDING_TABLE are untouched (escape hatch for custom Theme
  Editor authoring).

> **Note on the binding mechanism:** the current implementation uses a
> slot-name + property-name table compiled into `neocade_theme.gd`. This
> internal mechanism is **revisable** — that is, the binding table itself
> is REVISABLE in future v1.x — alternative approaches
> (property-name convention, metadata-tagged Resource model) may replace it
> without breaking the public `@export` surface or the `.tres` file format.

## Bundled font (Inter Variable Roman)

The `fonts/Inter-Variable.ttf` binary is licensed under the SIL Open Font
License 1.1 (see `OFL.txt`), separately from the addon code's MIT license
(see `LICENSE.md`). The Reserved Font Name "Inter" is preserved per the
OFL terms — do not rename the binary.

## Showcase

The repository-level `main.tscn` is a live showcase for this addon. It opens
with Pulse and includes:

- a direction picker for Pulse / Slate / Bubble / Daybreak / Burst / Godot default
- a flat/raised toggle
- a desktop/mobile/auto platform selector
- 9 sections covering controls, dialogs, graph, token gallery, and coverage

The Web export preset is named `Web`; the release workflow publishes the
showcase as both a zip asset and a GitHub Pages deployment.

## Distribution

v1 is distributed through GitHub Releases, not the Godot Asset Library. Install
by downloading `neocade_theme-v<VERSION>.zip` from the release and copying its
`addons/neocade_theme/` directory into your project.

The matching Web showcase artifact is
`neocade_theme-showcase-web-v<VERSION>.zip`. The latest release also deploys
to GitHub Pages for an instant browser preview.

## Cross-references

- **Design tokens (the canonical Phase 4 contract):** `.planning/DESIGN_TOKENS.md`
- **CHANGELOG:** `CHANGELOG.md`
- **Font license:** `OFL.txt`
- **Code license:** `LICENSE.md`
- **Version:** `VERSION`

---

_Updated through Phase 11 autonomous release preparation._
