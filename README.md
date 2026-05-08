# NeoCade Theme

NeoCade is a drop-in Godot 4.6 UI Theme addon for polished, accessible,
flat-MD3 / MD3 Expressive Control styling. It ships as one concrete
`NeoCadeTheme` class plus five approved data-only direction resources:
Pulse, Slate, Bubble, Daybreak, and Burst.

The theme is built for the author's upcoming game, codename VirtuCade, but
this repository is only the reusable NeoCade theme addon.

## Status

v1 implementation is in final QA/release preparation. The live showcase is
`res://showcase/showcase.tscn` and uses Pulse as the recommended starter direction.

## What Ships

```text
addons/neocade_theme/
  pulse_neocade_theme.tres      # recommended starter
  slate_neocade_theme.tres
  bubble_neocade_theme.tres
  daybreak_neocade_theme.tres
  burst_neocade_theme.tres
  scripts/neocade_theme.gd      # @tool class_name NeoCadeTheme extends Theme
  scripts/neocade_theme_option_button.gd
  fonts/inter_variable.ttf
  fonts/inter_ofl.txt
  icons/*.svg
```

There is no `plugin.cfg`, no editor plugin, no root `neocade_theme.tres`, and
no separate `neocade_mobile_theme.tres`. Mobile is handled by the exported
`platform` property on the same theme resources.

## Usage

See [docs/usage.md](docs/usage.md) for direction details, custom theme authoring, and font
fallback patterns.

Apply a direction resource to a root `Control`:

```gdscript
extends Control

const PULSE := preload("res://addons/neocade_theme/pulse_neocade_theme.tres")

func _ready() -> void:
    theme = PULSE
```

For runtime variation toggles, duplicate before mutating:

```gdscript
var active_theme: NeoCadeTheme = PULSE.duplicate(true)
active_theme.raised = true
active_theme.platform = NeoCadeTheme.Platform.MOBILE
theme = active_theme
```

## Showcase

Open `showcase/showcase.tscn` in Godot 4.6.2 to inspect:

- 9 sections covering controls, dialogs, graph, tokens, and coverage.
- `NeoCadeThemeOptionButton` dropdown in `addons/neocade_theme/scripts/` scans `addons/neocade_theme/` for
  `NeoCadeTheme` resources, keeps `None` first when allowed, then sorts themes alphabetically.
  It preserves the selected theme by resource path when the list rebuilds and emits
  `theme_selected(index, theme_path, theme)` after a theme is applied.
- Editor-authored Control tree; scripts are limited to the theme picker and
  scoreboard window open/close behavior.
- BBCode sample, multi-script sample, token gallery, and coverage strip.

`export_presets.cfg` includes a Web preset for release builds and named
desktop/mobile target presets for QA.

## Design Rules

- Flat MD3 / MD3 Expressive visual language.
- Optional raised mode uses hard offset darker shape duplicates only.
- No textures, patterns, embossing, painterly chrome, gradients on chrome,
  glow, synthwave, or cyberpunk/noir styling.
- GL Compatibility renderer remains the ship target.
- Inter Variable Roman is the only bundled font in v1; consumers can add
  script-specific Noto fallbacks, a mono font, or true Inter Italic.

## Distribution

v1 distribution is GitHub Releases only. The release workflow builds:

- `neocade_theme-v<VERSION>.zip` containing the clean `addons/neocade_theme/`
  folder plus `README.md`, `docs/usage.md`, `CHANGELOG.md`, `LICENSE.md`,
  and `VERSION`.
- `neocade_theme-showcase-web-v<VERSION>.zip` containing the Web showcase.
- A GitHub Pages deployment of the latest Web showcase.

## License

Theme code/content is MIT licensed via `LICENSE.md`.
Inter Variable Roman is licensed under SIL OFL 1.1 via
`addons/neocade_theme/fonts/inter_ofl.txt`, which ships inside the addon zip
because the font binary ships there too.

## Subtree Consumers

Dependent projects can consume the generated addon branch:

```powershell
git subtree add --prefix=addons/neocade_theme https://github.com/Shilo/NeoCade-Theme.git addon --squash
git subtree pull --prefix=addons/neocade_theme https://github.com/Shilo/NeoCade-Theme.git addon --squash
```
