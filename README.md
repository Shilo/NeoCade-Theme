# NeoCade Theme

NeoCade is a Godot 4.6 UI Theme addon for polished, accessible, arcade-inspired Control styling. It is designed as a drop-in theme resource for game runtime UI, optional Godot Editor use, and all six Godot export targets: Windows, macOS, Linux, iOS, Android, and Web.

The theme is built for the author's upcoming game, codename VirtuCade, but this repository is only the reusable theme addon. The theme name is **NeoCade**.

> Status: pre-release. The repository currently contains the Godot project scaffold, an empty `neocade_theme.tres`, and planning/research artifacts. The active roadmap is in Phase 2, LDtk source UI mining. The complete desktop theme, mobile theme, generator, fonts, icons, showcase scene, QA matrix, and release workflow are planned v1 deliverables.

## What v1 Will Ship

- `addons/neocade_theme/neocade_theme.tres` - desktop dark theme.
- `addons/neocade_theme/neocade_mobile_theme.tres` - mobile-tuned dark theme with the same visual identity.
- Shared token-to-theme generator in `addons/neocade_theme/_dev/`.
- Bundled Inter Variable Roman font under OFL 1.1.
- Bespoke SVG icons for Godot's built-in theme icon slots.
- A showcase scene at `main.tscn` covering every themed Control.
- GitHub Release zip for the addon and a separate Web showcase build.

NeoCade v1 is dark-only. Light mode and alternate palettes are planned for v2 or later.

## Design Direction

NeoCade aims for a vibrant arcade hall by day: warm, colorful, modern, inviting, and professional. It is explicitly not cyberpunk, synthwave, neon-noir, vaporwave, glitch, CRT, or pixel-art themed.

Key design rules:

- HD-only visuals, with no pixel fonts or pixel-art textures in the theme.
- StyleBoxFlat-first implementation for scalable, portable UI chrome.
- No drop shadows in v1; elevation is expressed through tonal surface colors.
- Visible focus rings on every focusable Control.
- WCAG 2.1 AA contrast target for text and interactive states.
- No color-only communication for important UI state.

## Current Repository

```text
addons/neocade_theme/
  neocade_theme.tres        # current empty Theme scaffold

main.tscn                   # current minimal Control root using the theme scaffold
project.godot               # Godot 4.6, GL Compatibility renderer
.planning/                  # project requirements, research, roadmap, phase artifacts
```

The current `main.tscn` is intentionally minimal. The full showcase scene is scheduled for Phase 9 after theme coverage and mobile authoring are complete.

## Installation

### From a Release

Once v1 releases are available:

1. Download `neocade_theme-v<VERSION>.zip` from GitHub Releases.
2. Extract `addons/neocade_theme/` into your Godot project's `addons/` folder.
3. Apply the theme project-wide or per scene.

NeoCade is a theme-resource addon, not an editor plugin. It does not use `plugin.cfg`, autoloads, GDExtension, shaders, or runtime dependencies.

### From This Repository During Development

Clone this repository and open it with Godot 4.6. The current theme file is a scaffold until the implementation phases land.

## Usage

### Project-Wide Theme

In Godot:

```text
Project Settings -> GUI -> Theme -> Custom
```

Set the custom theme to:

```text
res://addons/neocade_theme/neocade_theme.tres
```

For mobile-targeted UI, use:

```text
res://addons/neocade_theme/neocade_mobile_theme.tres
```

### Per-Scene Theme

Assign the theme to a root `Control` so only that scene subtree uses NeoCade. In the editor, select the root `Control`, then set its serialized `theme` property in the Inspector to:

```text
res://addons/neocade_theme/neocade_theme.tres
```

Godot's [`Control.theme`](https://docs.godotengine.org/en/stable/classes/class_control.html#class-control-property-theme) property applies a Theme resource to that Control branch, so child Controls resolve NeoCade before falling back to the project and default themes.

You can also assign the same property from script when you need dynamic setup:

```gdscript
extends Control

func _ready() -> void:
    theme = preload("res://addons/neocade_theme/neocade_theme.tres")
```

The serialized Inspector property is the recommended path for normal per-scene use. The scripted preload path is useful when selecting desktop/mobile themes at runtime or when building UI scenes procedurally.

### Runtime Theme Switching

```gdscript
const DESKTOP_THEME := preload("res://addons/neocade_theme/neocade_theme.tres")
const MOBILE_THEME := preload("res://addons/neocade_theme/neocade_mobile_theme.tres")

func apply_desktop_theme(root: Control) -> void:
    root.theme = DESKTOP_THEME

func apply_mobile_theme(root: Control) -> void:
    root.theme = MOBILE_THEME

func clear_theme(root: Control) -> void:
    root.theme = null
```

The showcase scene will include a three-way toggle for NeoCade desktop, NeoCade mobile, and Godot default.

## Mobile Variant

The mobile theme shares NeoCade's color, typography, corner radius, icon, and state identity with the desktop theme. It only changes density and touch ergonomics.

Planned v1 mobile differences:

- Interactive tap targets at least 48 px tall.
- Body text 16 px on mobile, compared with 14 px desktop.
- Larger spacing from the middle of the spacing scale upward.
- Same corner radii as desktop, to preserve brand identity.
- One mobile theme for all Android density buckets and iOS devices.

Consuming games are still responsible for responsive layout, safe-area handling, and choosing when to apply the mobile theme.

## Control Coverage

NeoCade v1 targets every user-facing Godot 4.6 Control class that has theme entries, matching the feature-completeness bar established by `godot-minimal-theme`.

Coverage groups:

- Buttons: Button, CheckBox, CheckButton, OptionButton, MenuButton, ColorPickerButton, LinkButton.
- Text: Label, RichTextLabel, LineEdit, TextEdit, CodeEdit.
- Range: ProgressBar, HSlider, VSlider, HScrollBar, VScrollBar, SpinBox.
- Lists and tabs: ItemList, Tree, TabBar, TabContainer, FoldableContainer.
- Containers and chrome: Panel, PanelContainer, ScrollContainer, SplitContainer, MarginContainer, layout separation constants.
- Popups and windows: PopupPanel, PopupMenu, AcceptDialog, ConfirmationDialog, FileDialog, TooltipPanel, TooltipLabel, Window.
- Advanced controls: MenuBar, ColorPicker, GraphEdit, GraphNode, GraphFrame.

Texture-driven Controls such as TextureButton, TextureRect, NinePatchRect, and TextureProgressBar are content-driven and are not meaningfully styled by a Theme resource.

## Type Variations

Planned v1 semantic variations:

- Buttons: `PrimaryButton`, `SecondaryButton`, `GhostButton`, `DangerButton`, `IconButton`, `FlatButton`.
- Labels: `HeaderLarge`, `HeaderMedium`, `HeaderSmall`, `Caption`, `CodeLabel`.
- RichTextLabel: `InfoText`.
- Panels: `CardPanel`, `HeroPanel`.

Variation names are role-based rather than hue-based so future palettes can change without requiring scenes to rename their UI roles.

## Fonts

NeoCade v1 plans to bundle only Inter Variable Roman. Non-Latin scripts render through Godot's `Font.allow_system_fallback` default behavior where platform support is available. Web builds may need explicit bundled fallback fonts for languages outside Inter's coverage.

This keeps the addon small and consistent, but consumers with specific typography needs can extend the theme.

### Add Script-Specific Fallbacks

```gdscript
var theme := preload("res://addons/neocade_theme/neocade_theme.tres").duplicate()
var font := theme.default_font
font.fallbacks.append(preload("res://fonts/NotoSansArabic-VariableFont_wdth,wght.ttf"))
theme.default_font = font
```

Recommended opt-in families include script-specific Noto Sans variants such as Noto Sans SC, TC, JP, KR, Arabic, Hebrew, Devanagari, Bengali, Tamil, Thai, Khmer, Lao, and Myanmar.

### Add a Monospace Font for Code Surfaces

```gdscript
$CodeEdit.add_theme_font_override("font", preload("res://fonts/JetBrainsMono-VariableFont_wght.ttf"))
```

JetBrains Mono, Fira Code, Cascadia Code, and IBM Plex Mono are good consumer-side options.

### Add True Italic

Inter Italic is deferred from the core v1 bundle. If your project needs true italic text instead of synthetic slanting, add Inter Italic to your project and wire it into the specific Controls that render italic text, such as RichTextLabel theme font entries for italic BBCode.

## Editor Usage

NeoCade can be applied as a Godot Editor custom theme, but v1 only targets public user-facing Control classes. Editor-internal theme types fall back to Godot's default editor styling.

Themed in v1:

- Inspector fields that use LineEdit, SpinBox, OptionButton, ColorPickerButton.
- Scene tree and FileSystem dock surfaces using Tree and ItemList.
- Script editor text area chrome through CodeEdit.
- Standard dialogs, popups, menus, tabs, tooltips, sliders, and progress bars.

Not themed in v1:

- Editor-only toolbar buttons such as `FlatButton`, `FlatMenuButton`, `MainScreenButton`, and `BottomPanelButton`.
- EditorInspector and EditorProperty internal chrome.
- Godot's editor-managed node-type icons.

For selective runtime use, prefer assigning NeoCade to a root Control's serialized `theme` property instead of setting it as the project-wide theme.

## Showcase

The planned showcase scene will include:

- All 35 themed Control classes with realistic sample content.
- Desktop, mobile, and Godot-default theme toggle.
- Token gallery for colors, typography, spacing, radius, and state samples.
- Coverage strip showing the current themed Control count.
- Accessibility names on interactive Controls.
- Exportable Web build for browser-based preview.

The GitHub Pages showcase link will be added once the release workflow exists.

## Cross-Platform Notes

NeoCade targets Godot 4.6 with the GL Compatibility renderer. The project is already configured for:

```text
renderer/rendering_method="gl_compatibility"
renderer/rendering_method.mobile="gl_compatibility"
```

The v1 validation plan covers:

- Windows, macOS, Linux.
- iOS and Android real-device checks where available.
- Web export with bundled FontFile resources and PCK-safe references.
- HiDPI and multiple scale factors.
- WCAG contrast, focus visibility, color-vision deficiency checks, and multi-script text samples.

Render-correctness is the goal across targets, not exact pixel parity.

## Roadmap

The v1 roadmap has 11 phases:

- [x] Phase 1: Source-dive `godot-minimal-theme` `.tres` dissection.
- [ ] Phase 2: Source-dive LDtk source UI mining.
- [ ] Phase 3: Visual direction mockups and approval gate.
- [ ] Phase 4: Tokens, fonts, icons, scaffolds, and `@tool` generator.
- [ ] Phase 5: Core desktop Controls.
- [ ] Phase 6: Lists, layout, range Controls.
- [ ] Phase 7: Dialogs, popups, advanced Controls.
- [ ] Phase 8: Mobile variant authoring and tap-target audit.
- [ ] Phase 9: Showcase scene and token gallery.
- [ ] Phase 10: QA and cross-platform export validation.
- [ ] Phase 11: GitHub Actions release pipeline.

No `.tres` styling work begins until the Phase 3 mockup approval gate passes.

## Development Notes

- Open the project in Godot 4.6.
- Keep the renderer on GL Compatibility.
- Theme authoring should go through the dedicated Theme editor or the planned `_dev/generate_themes.gd` generator.
- Avoid editing Theme resources from a Control inspector context; Godot 4.6 has known Theme inspector crash risks.
- Commit generated `.tres`, font import sidecars, icon import sidecars, and release files.

The planning source of truth lives under `.planning/`, especially:

- `.planning/PROJECT.md`
- `.planning/REQUIREMENTS.md`
- `.planning/ROADMAP.md`
- `.planning/research/SUMMARY.md`
- `.planning/research/FEATURES.md`
- `.planning/research/CROSS-PLATFORM.md`
- `.planning/research/EDITOR-COVERAGE.md`

## License

License files have not landed yet. The planned v1 package includes:

- A theme code/content license file, expected to be MIT or another permissive license.
- `addons/neocade_theme/OFL.txt` for the bundled Inter font.

Downstream games using NeoCade should surface the bundled font license in their credits or acknowledgements.

## Acknowledgements

NeoCade's research and planning reference:

- Godot 4.6 Theme, Control, StyleBox, FontFile, FontVariation, and export documentation.
- `godot-minimal-theme` by passivestar as the Control coverage benchmark.
- LDtk as a polished UI craft reference.
- Material Design 3 for token, spacing, type scale, state, and accessibility discipline.
- Real arcade interiors and venue aesthetics for the arcade-by-day visual direction.

## 🔧 Maintainer: publish the addon branch

The public subtree branch is always named `addon`. After changing files under `addons/neocade_theme` on `main`, the GitHub workflow publishes that directory as the root of `addon` automatically.

To create or repair the branch manually from the NeoCade Theme repo root, publish the addon directory tree with `git commit-tree`:

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

The `addon` branch contains only the files that belong inside a dependent project's `addons/neocade_theme` directory. It is a generated one-way publish branch, so make source changes under `addons/neocade_theme` on `main` instead of editing `addon` directly.

The `.github/workflows/sync-addon-branch.yml` workflow uses the same `git commit-tree` publish flow whenever `main` receives changes under `addons/neocade_theme`.

## Using NeoCade Theme as a subtree dependency

Dependent Godot projects should keep these shared files at:

```text
addons/neocade_theme
```

Git subtree is useful here because the dependent repo gets real committed files instead of a submodule pointer. That means the project still opens normally in Godot and does not require an extra clone step.

This repository is a full Godot demo project. The reusable addon files live in `addons/neocade_theme`, so subtree consumers should use the generated `addon` branch.

### Initialize the subtree

From the root of the repo that depends on NeoCade Theme:

```powershell
git subtree add --prefix=addons/neocade_theme https://github.com/Shilo/NeoCade-Theme.git addon --squash
```

This adds the shared NeoCade Theme files into `addons/neocade_theme` and records enough subtree history for future updates.

### Update to the latest NeoCade Theme commit

From the dependent repo root:

```powershell
git subtree pull --prefix=addons/neocade_theme https://github.com/Shilo/NeoCade-Theme.git addon --squash
```

If Git reports conflicts, resolve them like a normal merge, then commit the result.

## VS Code task for updating without typing the CLI command

In any dependent repo, create `.vscode/tasks.json` with this task:

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

Then run it from VS Code:

1. Open the Command Palette with `Ctrl+Shift+P`.
2. Choose `Tasks: Run Task`.
3. Choose `Update NeoCade Theme subtree`.

Optional keyboard shortcut in VS Code `keybindings.json`:

```json
{
  "key": "ctrl+alt+u",
  "command": "workbench.action.tasks.runTask",
  "args": "Update NeoCade Theme subtree"
}
```

The task still runs Git under the hood, but you can trigger it from VS Code without retyping the subtree command.

## 📦 Dependencies

None.
