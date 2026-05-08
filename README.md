# NeoCade Theme

NeoCade is a drop-in Godot 4.6 UI Theme addon for polished, accessible,
flat-MD3 / MD3 Expressive Control styling. It ships as one concrete
`NeoCadeTheme` class plus five approved data-only direction resources:
Pulse, Slate, Bubble, Daybreak, and Burst.

The theme is built for the author's upcoming game, codename VirtuCade, but
this repository is only the reusable NeoCade theme addon.

## Status

v1 implementation is in final QA/release preparation. The live showcase is
`res://main.tscn` and uses Pulse as the recommended starter direction.

## What Ships

```text
addons/neocade_theme/
  neocade_theme.gd              # @tool class_name NeoCadeTheme extends Theme
  pulse_neocade_theme.tres      # recommended starter
  slate_neocade_theme.tres
  bubble_neocade_theme.tres
  daybreak_neocade_theme.tres
  burst_neocade_theme.tres
  fonts/Inter-Variable.ttf
  icons/*.svg
  README.md
  CHANGELOG.md
  LICENSE.md
  OFL.txt
  VERSION
```

There is no `plugin.cfg`, no editor plugin, no root `neocade_theme.tres`, and
no separate `neocade_mobile_theme.tres`. Mobile is handled by the exported
`platform` property on the same theme resources.

## Usage

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

Open `main.tscn` in Godot 4.6.2 to inspect:

- 9 sections covering controls, dialogs, graph, tokens, and coverage.
- Theme picker for Pulse, Slate, Bubble, Daybreak, Burst, and Godot default.
- Editor-authored Control tree; only the theme picker is scripted.
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

- `neocade_theme-v<VERSION>.zip` containing `addons/neocade_theme/`.
- `neocade_theme-showcase-web-v<VERSION>.zip` containing the Web showcase.
- A GitHub Pages deployment of the latest Web showcase.

## License

Theme code/content is MIT licensed via `addons/neocade_theme/LICENSE.md`.
Inter Variable Roman is licensed under SIL OFL 1.1 via
`addons/neocade_theme/OFL.txt`.

## Subtree Consumers

Dependent projects can consume the generated addon branch:

```powershell
git subtree add --prefix=addons/neocade_theme https://github.com/Shilo/NeoCade-Theme.git addon --squash
git subtree pull --prefix=addons/neocade_theme https://github.com/Shilo/NeoCade-Theme.git addon --squash
```
