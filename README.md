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
  scripts/neocade_theme_autoload.gd  # drop-in autoload — global theme without theme/custom
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

**Recommended (global, hassle-free):** register the bundled autoload at
`Project Settings > AutoLoad`:

| Field | Value |
|---|---|
| Path | `res://addons/neocade_theme/scripts/neocade_theme_autoload.gd` |
| Node Name | `NeoCadeThemeLoader` (or any name) |
| Global Variable | ✓ enabled |

That's it. NeoCade is applied to the SceneTree's root viewport on the
first frame, and every Control — main scene, other autoloads, popups,
error dialogs — inherits it. Same global reach as `[gui] theme/custom`,
no engine bug (see **Known Issues**).

To apply manually from any node's `_ready()` (e.g. if you don't want an
autoload, or want a customized theme):

```gdscript
func _ready() -> void:
    NeoCadeTheme.apply_to_root_viewport()             # canonical theme
    # — or —
    var t: NeoCadeTheme = preload("res://addons/neocade_theme/neocade_theme.tres").duplicate(true)
    t.style = NeoCadeTheme.Style.BUBBLE
    NeoCadeTheme.apply_to_root_viewport(t)            # custom theme
```

Scene-local alternative — set the theme on a single `Control` (via the
editor inspector or in code) when global inheritance isn't desired:

```gdscript
extends Control

const NEOCADE_THEME := preload("res://addons/neocade_theme/neocade_theme.tres")

func _ready() -> void:
    theme = NEOCADE_THEME
```

> **Do not** set NeoCade via the project setting `[gui] theme/custom` in
> `project.godot`. Doing so triggers an open Godot engine bug
> ([godotengine/godot#111656](https://github.com/godotengine/godot/issues/111656))
> that prints 10 non-fatal `SceneTree::get_singleton() is null` errors at
> launch and breaks editor scene live-sync. The autoload above is the
> drop-in equivalent — see **Known Issues** below.

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

## Known Issues

### Project `[gui] theme/custom` triggers Godot debugger spam

Setting `neocade_theme.tres` (or any `class_name`'d resource subclass with
properties) as the project GUI theme triggers an open Godot engine bug —
[godotengine/godot#111656](https://github.com/godotengine/godot/issues/111656),
regression since 4.4. At launch, 10 non-fatal errors print:

```
E 0:00:00:455   neocade_theme.gd:49 @ @implicit_new(): Parameter "SceneTree::get_singleton()" is null.
  <C++ Source>  scene/debugger/scene_debugger.cpp:521 @ parse_message()
  <Stack Trace> neocade_theme.gd:49 @ @implicit_new()
```

The trace points at `@implicit_new` and a `var` / `@export` declaration line,
but those are *symptoms* — the real source is engine-internal property
registration sending `live_*` debugger messages before `SceneTree` is set as
the main loop. The runtime's `parse_message()` then hits a null
`SceneTree::get_singleton()` and fires `ERR_FAIL_NULL_V` once per inbound
message. Per Godot maintainer YuriSizov, the trigger is the script having
*"any properties defined (which creates implicit_new in GDScript)"* — no
setter, no `@export`, no `class_name` required individually; the bug
reproduces with godot-minimal-theme, custom `StyleBoxFlat`, custom
`Texture2D`, custom `AudioEffect`. It is unfixable from the addon's side.

Side effect beyond the log spam: editor scene live-sync needs a manual
scene re-select after each launch.

**Workaround — drop-in autoload (recommended):** register
`res://addons/neocade_theme/scripts/neocade_theme_autoload.gd` at
*Project Settings > AutoLoad*. The autoload calls
`NeoCadeTheme.apply_to_root_viewport()` from its `_ready()`, setting the
SceneTree root viewport's `theme` at runtime — past the buggy boot window,
with the same global inheritance as `theme/custom`. See **Usage** above.

**Alternative — scene-scoped:** assign the theme on a single root `Control`
via inspector or `_ready()`. Avoids the bug but only inherits to that
scene's subtree (not other autoloads).

Both go away the day Godot patches `scene_debugger.cpp:521`'s `ERR_FAIL_NULL_V`
to silently early-return when `SceneTree::get_singleton()` is null.

## Showcase

Open `showcase/showcase.tscn` in Godot 4.6.2 to inspect:

- 9 sections covering controls, dialogs, graph, tokens, and coverage.
- `NeoCadeThemeOptionButton` dropdown in `addons/neocade_theme/scripts/`
  lists NeoCade styles alphabetically and appends `None` when allowed.
  `None` applies a null theme. It emits `theme_selected(theme, index)` after
  a theme is applied.
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
