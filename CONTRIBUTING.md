# Contributing to NeoCade Theme

## Theme Authoring

Use the dedicated Godot Theme editor or the `NeoCadeTheme` export-driven
regeneration flow. Do not edit theme resources through a Control inspector
context menu while authoring NeoCade entries; Godot 4.x theme-inspector
workflows have known instability around nested Theme editing.

Safe authoring paths:

- edit the 9 exported `NeoCadeTheme` properties on a direction resource
- use the dedicated Theme editor for intentional per-slot overrides
- update `addons/neocade_theme/scripts/neocade_theme.gd` formulas and verify by
  loading `main.tscn`

Keep the addon layout compact:

- core scripts under `addons/neocade_theme/scripts/`
- five v1 direction `.tres` files at the addon root
- no `plugin.cfg`
- no root `neocade_theme.tres`
- no `neocade_mobile_theme.tres`

## QA Expectations

Before release work, run or update:

- Godot 4.6.2 project import/open smoke
- showcase scene open smoke
- contrast and focus audit notes
- export preset checks
- deferred manual/device validation notes when hardware is unavailable
