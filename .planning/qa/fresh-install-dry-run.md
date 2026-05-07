# Fresh-Install Dry-Run Checklist

**Date:** 2026-05-07
**Status:** Checklist prepared; physical clean-project copy deferred.

## Expected Install Shape

Consumers copy only:

```text
addons/neocade_theme/
```

NeoCade does not require:

- `plugin.cfg`
- autoloads
- GDExtension
- shaders
- `.planning/`
- root showcase files

## Required Files

- `neocade_theme.gd`
- five direction `.tres` resources
- `fonts/Inter-Variable.ttf` and import sidecar
- FontVariation `.tres` files
- icon SVGs and import sidecars
- `README.md`, `CHANGELOG.md`, `LICENSE.md`, `OFL.txt`, `VERSION`

## Consumer Smoke

```gdscript
const THEME := preload("res://addons/neocade_theme/pulse_neocade_theme.tres")

func _ready() -> void:
    theme = THEME
```

For runtime mutation:

```gdscript
var active: NeoCadeTheme = THEME.duplicate(true)
active.platform = NeoCadeTheme.Platform.AUTO
active.raised = false
theme = active
```

## Deferred

Copying the addon into a brand-new Godot project and capturing screenshots is
deferred until a clean-project QA workspace is allocated.
