# NeoCade Theme

NeoCade is a drop-in Godot 4.6 UI Theme addon for polished, accessible,
flat-MD3 / MD3 Expressive Control styling. It ships as one concrete
`NeoCadeTheme` class plus one canonical theme resource with five built-in
styles: Pulse, Slate, Bubble, Daybreak, and Burst.

The theme is built for the author's upcoming game, codename VirtuCade, but
this repository is only the reusable NeoCade theme addon.

## Status

v1 implementation is in final QA/release preparation. The live showcase is
`res://showcase/showcase.tscn` and opens with the Pulse style.

## What Ships

```text
addons/neocade_theme/
  neocade_theme.tres            # canonical Theme resource
  scripts/neocade_theme.gd      # @tool class_name NeoCadeTheme extends Theme
  scripts/neocade_theme_option_button.gd
  fonts/inter_variable.ttf
  fonts/inter_ofl.txt
  icons/*.svg
```

There is no `plugin.cfg`, no editor plugin, no per-style `.tres` files, and
no separate `neocade_mobile_theme.tres`. Mobile is handled by the exported
`platform` property on the same theme resource.

## Usage

See [docs/usage.md](docs/usage.md) for style details, custom theme authoring,
and font fallback patterns.

Apply NeoCade to a root `Control`:

```gdscript
extends Control

const NEOCADE_THEME := preload("res://addons/neocade_theme/neocade_theme.tres")

func _ready() -> void:
    theme = NEOCADE_THEME
```

For runtime style or variant toggles, duplicate before mutating:

```gdscript
var active_theme: NeoCadeTheme = NEOCADE_THEME.duplicate(true)
active_theme.style = NeoCadeTheme.Style.BUBBLE
active_theme.raised = true
active_theme.platform = NeoCadeTheme.Platform.MOBILE
theme = active_theme
```

Set `style = NeoCadeTheme.Style.CUSTOM` to make all exported direction values
manual. When the direction exports match a built-in style again, NeoCade
automatically reflects that style in the inspector.

Migration note: older per-style files such as `pulse_neocade_theme.tres` have
been replaced by `neocade_theme.tres` plus the `style` export.

## Showcase

Open `showcase/showcase.tscn` in Godot 4.6.2 to inspect:

- 10 sections covering controls, dialogs, graph, tokens, coverage, and role variations.
- `NeoCadeThemeOptionButton` dropdown in `addons/neocade_theme/scripts/`
  lists NeoCade styles alphabetically and appends `None` when allowed.
  `None` applies a null theme. It emits `theme_selected(theme, index)` after
  a theme is applied.
- Editor-authored Control tree; scripts are limited to the theme picker and
  scoreboard window open/close behavior.
- BBCode sample, multi-script sample, token gallery, and coverage strip.

`export_presets.cfg` includes a Web preset for release builds and named
desktop/mobile target presets for QA.

## Role Variations (opt-in)

NeoCade ships 9 opt-in type variations that consumers can apply when a widget
semantically represents success / warning / danger / info / accent state. Default
`Label` and `PanelContainer` chrome stay unchanged; the variations only activate
when the consumer assigns `theme_type_variation`.

**4 Role Labels** (extend `Label`) recolor `font_color` to the matching role token:

| Variation       | Color token   |
|-----------------|---------------|
| `SuccessLabel`  | `role_success` |
| `WarningLabel`  | `role_warning` |
| `DangerLabel`   | `role_danger`  |
| `InfoLabel`     | `role_info`    |

**5 Role Panels** (extend `PanelContainer`) replace the panel face with a 6%
opacity wash of the matching role color so the underlying surface shows through.
When `raised = true`, the panel additionally picks up a darker role-tinted edge
from the `raised_face_edge` treatment (consistent with every other raised panel
chrome); keep `raised` off for a flat translucent banner.

| Variation       | Tint role      |
|-----------------|----------------|
| `AccentPanel`   | `role_primary` |
| `InfoPanel`     | `role_info`    |
| `WarningPanel`  | `role_warning` |
| `DangerPanel`   | `role_danger`  |
| `SuccessPanel`  | `role_success` |

Apply via the Inspector's `Theme Type Variation` field or in code:

```gdscript
my_label.theme_type_variation = &"SuccessLabel"
my_panel.theme_type_variation = &"AccentPanel"
```

The 10th showcase section in `showcase/showcase.tscn` ("Role Variations")
demonstrates each one with consumer-style content.

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

## Subtree Integration

Dependent Godot projects should keep the shared files at
`addons/neocade_theme/` and pull from the generated `addon` branch, which
contains only the files that belong inside a consumer project's addon
directory. The `addon` branch is auto-published from `main` by the
`.github/workflows/sync-addon-branch.yml` workflow whenever
`addons/neocade_theme/` changes.

Git subtree is preferred over submodules here because the consumer repo
gets real committed files — the project still opens normally in Godot
with no extra clone step.

### Initialize

From the root of the consuming repo:

```powershell
git subtree add --prefix=addons/neocade_theme https://github.com/Shilo/NeoCade-Theme.git addon --squash
```

### Update

```powershell
git subtree pull --prefix=addons/neocade_theme https://github.com/Shilo/NeoCade-Theme.git addon --squash
```

If Git reports conflicts, resolve them like a normal merge, then commit.

### VS Code Task

Add `.vscode/tasks.json` in the consumer repo so updates are one command
from the editor:

```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Update NeoCade Theme subtree",
      "type": "shell",
      "command": "git",
      "args": [
        "subtree",
        "pull",
        "--prefix=addons/neocade_theme",
        "https://github.com/Shilo/NeoCade-Theme.git",
        "addon",
        "--squash"
      ],
      "problemMatcher": []
    }
  ]
}
```

Run via Command Palette (`Ctrl+Shift+P`) → `Tasks: Run Task` →
`Update NeoCade Theme subtree`. Optional shortcut in `keybindings.json`:

```json
{
  "key": "ctrl+alt+u",
  "command": "workbench.action.tasks.runTask",
  "args": "Update NeoCade Theme subtree"
}
```

### Maintainer: Republish the Addon Branch Manually

The CI workflow is the normal path, but to repair or bootstrap `addon`
from the repo root:

```powershell
$addonDir = "addons/neocade_theme"
git fetch origin "+refs/heads/addon:refs/remotes/origin/addon" 2>$null
$addonTree = git rev-parse "main:$addonDir"
$currentTree = git rev-parse "origin/addon^{tree}" 2>$null

if ($LASTEXITCODE -eq 0 -and $addonTree -eq $currentTree) {
  "addon branch already up to date"
} else {
  $parent = git rev-parse --verify origin/addon 2>$null
  if ($LASTEXITCODE -eq 0) {
    $newCommit = git commit-tree $addonTree -p $parent -m "chore: sync addon branch from $(git rev-parse --short main)"
  } else {
    $newCommit = git commit-tree $addonTree -m "chore: sync addon branch from $(git rev-parse --short main)"
  }
  git push origin "${newCommit}:refs/heads/addon"
}
```

The `addon` branch is a generated one-way publish branch — make source
changes under `addons/neocade_theme/` on `main`, never on `addon`.

## Dependencies

None.

## Used By

- [Tyle Map Editor](https://github.com/Shilo/tyle-map-editor) — uses
  NeoCade Theme as a child subtree at
  `addons/tyle_map_editor/neocade_theme`.
- [PentaTile](https://github.com/Shilo/PentaTile) — receives NeoCade
  Theme recursively through Tyle Map Editor at
  `addons/penta_tile/tyle_map_editor/neocade_theme`.
- [VirtuMap](https://github.com/Shilo/VirtuMap) — receives NeoCade Theme
  recursively through PentaTile and Tyle Map Editor at
  `addons/virtumap/penta_tile/tyle_map_editor/neocade_theme`.
- [VirtuCade Prototype](https://github.com/Shilo/VirtuCadePrototype) —
  direct subtree consumer at `addons/neocade_theme`.
