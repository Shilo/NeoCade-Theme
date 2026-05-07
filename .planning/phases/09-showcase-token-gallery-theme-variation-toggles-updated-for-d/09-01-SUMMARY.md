# Phase 9 Plan 01 Summary

**Completed:** 2026-05-07
**Result:** Showcase implemented

## Changes

- Added `scripts/showcase.gd`, a programmatic fullscreen showcase scene builder.
- Updated `main.tscn` to use the new showcase script while keeping Pulse as the default theme resource.
- Added runtime controls for:
  - Pulse, Slate, Bubble, Daybreak, Burst, and Godot default
  - flat/raised via `NeoCadeTheme.raised`
  - desktop/mobile/auto via `NeoCadeTheme.platform`
- Added nine showcase sections with realistic samples and token/coverage views.
- Added `export_presets.cfg` with Web, Windows, Linux, macOS, Android, and iOS presets.

## Validation

Godot 4.6.2 MCP run caught and fixed:

- `CodeEdit.draw_line_numbers` invalid property
- `MenuBar.add_menu()` nonexistent API call
- `PopupMenu.add_submenu_item()` child-order issue

Final Godot MCP smoke run started the project with no debug errors.

## Deferred

Screenshot decks, browser export output, and real-device validation remain Phase 10/11 scope.
