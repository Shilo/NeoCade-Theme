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
  scripts/neocade_theme_autoload.gd  # drop-in autoload — merges into ThemeDB.default_theme
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

That's it. One setting. On `_ready()` the autoload calls
`NeoCadeTheme.apply_globally()`, which merges the real `neocade_theme.tres`
into `ThemeDB.default_theme` at runtime. Standard Godot theme inheritance
then propagates NeoCade to every Control everywhere — main scene, other
autoloads, popups, dialogs, AcceptDialog OK buttons, every UI surface.
No `[gui] theme/custom` setting needed; no stub file.

To apply manually from any node's `_ready()` (e.g. if you don't want an
autoload, or want a customized theme):

```gdscript
func _ready() -> void:
    NeoCadeTheme.apply_globally()                     # canonical theme

# — or, for a customized theme, merge it into default_theme yourself —
func _ready() -> void:
    var t: NeoCadeTheme = preload("res://addons/neocade_theme/neocade_theme.tres").duplicate(true)
    t.style = NeoCadeTheme.Style.BUBBLE
    ThemeDB.get_default_theme().merge_with(t)
```

Scene-local alternative — set the theme on a single `Control` (via the
editor inspector or in code) when global inheritance isn't desired:

```gdscript
extends Control

const NEOCADE_THEME := preload("res://addons/neocade_theme/neocade_theme.tres")

func _ready() -> void:
    theme = NEOCADE_THEME
```

> **Do not** point `[gui] theme/custom` directly at `neocade_theme.tres`.
> The real theme is a `class_name`'d resource subclass with properties,
> which triggers the Godot engine bug (10 non-fatal errors at launch +
> broken scene live-sync). The autoload above is the drop-in equivalent —
> it mutates `ThemeDB.default_theme` (the deepest fallback every Control
> hits) at runtime, past the buggy boot window. See **Known Issues**.

When dogfooding NeoCade as the Godot editor custom theme, avoid also saving
the same `neocade_theme.tres` as a scene-root `theme` on showcase/sample
scenes. Prefer runtime-only assignment:

```gdscript
func _ready() -> void:
    NeoCadeTheme.apply_to_control(self)
```

`apply_to_control()` no-ops in the editor and only assigns the canonical theme
when the target `Control` has no theme yet.

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

### Editor custom theme icon polarity

NeoCade can be loaded into the Godot editor itself via
*Editor Settings > Interface > Theme > Custom Theme*, but Godot still
generates its built-in editor theme before merging the custom theme.
That means `interface/theme/base_color` and `interface/theme/accent_color`
can affect generated `EditorIcons` even though NeoCade overrides its own
surfaces and colors.

The most visible case is `interface/theme/base_color = #ffffff` while
`interface/theme/icon_and_font_color = Auto`: Godot treats the editor as a
light theme, bakes dark editor icons, and then merges NeoCade's dark editor
surfaces over them. Toolbars, main screen buttons, FileSystem icons, and other
editor-only icon textures can then look too dark.

**Workaround:** set
*Editor Settings > Interface > Theme > Icon And Font Color* to **Light** when
using NeoCade as the editor custom theme. This forces Godot to generate light
editor icons regardless of editor `base_color`.

NeoCade does not automatically change this setting because it is a global
editor preference that persists after the theme is removed. NeoCade also does
not vendor or override every built-in `EditorIcons` texture; doing so would be
a large Godot-version maintenance surface. If `accent_color` affects a specific
generated editor icon, treat it as an editor integration caveat unless that icon
is worth a narrow explicit override.

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

**Workaround — autoload (recommended):** register
`res://addons/neocade_theme/scripts/neocade_theme_autoload.gd` at
*Project Settings > AutoLoad*. Its `_ready()` calls
`NeoCadeTheme.apply_globally()`, which does:

```gdscript
ThemeDB.get_default_theme().merge_with(load("res://addons/neocade_theme/neocade_theme.tres"))
```

That single `merge_with` runs at autoload `_ready()` — well past the
buggy boot window — and stamps NeoCade's 75+ type entries into Godot's
`default_theme`. Every Control everywhere then picks it up via the
standard `theme → ancestor themes → project_theme → default_theme`
inheritance chain. No stub, no project setting, no boot-time bug.

> Why `default_theme` and not `Window.theme` on the root? Because
> `Window.theme` only styles the Window itself; it does not act as a
> fallback for descendant Controls. Why not `project_theme`?
> `ThemeDB.set_project_theme()` isn't bound to GDScript, and
> `get_project_theme()` returns `null` when `[gui] theme/custom` is
> unset. `get_default_theme()` always returns Godot's built-in default
> Theme — a mutable `Ref<Theme>` that's in the same fallback chain.
> Mutating it has the same reach as `theme/custom` would have.

**Alternative — scene-scoped:** assign the theme on a single root `Control`
via inspector or `_ready()`. Avoids the bug but only inherits to that
scene's subtree (not other autoloads, popups, dialogs).

All of this goes away the day Godot patches `scene_debugger.cpp:521`'s
`ERR_FAIL_NULL_V` to silently early-return when `SceneTree::get_singleton()`
is null.

### Editor custom theme plus scene-root theme can freeze scene switching

NeoCade supports use as a Godot editor custom theme via
*Editor Settings > Interface > Theme > Custom Theme*. A separate trap appears
when the same canonical `res://addons/neocade_theme/neocade_theme.tres`
resource is also serialized onto the root `Control.theme` of a scene being
edited, such as the Showcase scene. In Godot 4.6.2 this can make switching
back to that scene freeze the editor for minutes, especially after creating or
switching through another scene. Empty scenes do not reproduce it.

The observed freeze was not caused by recursive NeoCade regeneration: the
theme has a `_regenerating` guard, diagnostic logs showed one regeneration per
theme instance, and raw generation measured in milliseconds
(about 25ms uncached, about 4ms with the persistent texture cache warmed).
The expensive path was the editor applying/inspecting a live scene root theme
that referenced the same dynamic theme resource already merged into the editor
UI.

**Workaround:** do not serialize the canonical NeoCade theme onto showcase or
sample scene roots while also using NeoCade as the editor custom theme. Apply
it at runtime instead:

```gdscript
func _ready() -> void:
    NeoCadeTheme.apply_to_control(self)
```

`apply_to_control()` returns immediately in editor mode, so the `.tscn` stays
clean while the running game/showcase still gets the canonical Pulse theme.
If a scene includes `NeoCadeThemeOptionButton`, it should refresh after the
runtime assignment so stale editor-serialized picker state cannot clear the
runtime theme.

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

Add `.vscode/tasks.json` (and a sibling pre-flight script) in the consumer
repo so updates are one command from the editor. The recommended setup
includes a pre-flight check that catches a common pitfall: if an editor
buffer for any file under `addons/neocade_theme/` is stale (still showing
pre-pull content), an auto-save can write that older content back to
disk *after* `git subtree pull` succeeds — leaving the working tree dirty
and producing the cryptic `fatal: working tree has modifications. Cannot
add` error on the next run. The check turns that into an actionable
message.

The pre-flight logic lives in a sibling `.ps1` script so VSCode's task
runner doesn't have to navigate PowerShell-inside-PowerShell quoting hell
(inline `pwsh -Command '...'` breaks on the single quotes the check needs).

`.vscode/check_subtree_clean.ps1`:

```powershell
#!/usr/bin/env pwsh
$dirty = git status --porcelain addons/neocade_theme/
if ($dirty) {
    Write-Host ""
    Write-Host "ERROR: addons/neocade_theme has uncommitted changes:" -ForegroundColor Red
    Write-Host $dirty
    Write-Host ""
    Write-Host "Common cause: a stale IDE buffer auto-saved its older content over the freshly-pulled file." -ForegroundColor Yellow
    Write-Host "Fix: close the file(s) in your editor (or Ctrl+Shift+P > Revert File to discard the buffer and reload from disk)," -ForegroundColor Yellow
    Write-Host "     then re-run this task."
    exit 1
}
```

`.vscode/tasks.json`:

```jsonc
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "_check-subtree-clean",
      "type": "shell",
      "command": "pwsh",
      "args": [
        "-NoProfile",
        "-File",
        "${workspaceFolder}/.vscode/check_subtree_clean.ps1"
      ],
      "presentation": { "reveal": "silent", "panel": "shared" },
      "problemMatcher": []
    },
    {
      "label": "Update NeoCade Theme subtree",
      "type": "shell",
      "command": "git",
      "args": [
        "subtree", "pull",
        "--prefix=addons/neocade_theme",
        "https://github.com/Shilo/NeoCade-Theme.git",
        "addon", "--squash"
      ],
      "dependsOn": "_check-subtree-clean",
      "presentation": { "reveal": "always", "panel": "shared" },
      "problemMatcher": []
    }
  ]
}
```

If you don't use PowerShell, swap `check_subtree_clean.ps1` for an
equivalent bash/sh script and update `command`/`args` to `bash -lc
"./.vscode/check_subtree_clean.sh"`, or drop the pre-flight task entirely
(you'll just see the raw git error on a dirty working tree).

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
