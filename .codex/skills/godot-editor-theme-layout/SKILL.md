---
name: godot-editor-theme-layout
description: Improve, debug, and repair NeoCade Godot editor theme layout, sizing, spacing, chrome, icons, colors, borders, and Control state styling. Use when working on the NeoCade Theme project in the Godot editor, comparing Pulse/Bubble/Burst/etc. against the default editor theme or Godot Minimal Theme, or when a user provides editor screenshots and asks to make the theme fit, align, or behave correctly.
---

# Godot Editor Theme Layout

## Purpose

Use this skill to iterate on NeoCade editor-theme problems with source-backed diagnosis, measured evidence, and log-only verification when requested. Treat editor screenshots as clues, not proof of which theme item is wrong.

Default local paths:

- NeoCade project: `C:\Programming_Files\Shilocity\Godot\NeoCade-Theme`
- Godot source: `C:\Programming_Files\Godot\godot-master`
- Godot Minimal Theme: `C:\Programming_Files\Godot\godot-minimal-theme-main`
- Canonical theme script: `addons/neocade_theme/scripts/neocade_theme.gd`
- Canonical theme resource: `addons/neocade_theme/neocade_theme.tres`
- Existing QA probes: `.planning/qa/theme-rescue/`

Read [references/editor-theme-debugging.md](references/editor-theme-debugging.md) when the task involves editor docks, inspector/filesystem/scene panels, popups, tabs, scrollbars, or any screenshot-to-source investigation.

## Workflow

1. Identify the visible editor area from the user's screenshot or description.
2. Trace the Godot source that creates that area before editing the theme.
3. Map rendered controls to actual classes, variations, and theme slots.
4. Compare with Godot Minimal Theme and/or Godot built-in editor theme source.
5. Patch NeoCade narrowly, usually in `BINDING_TABLE`, `TYPE_VARIATIONS`, verifier scripts, or generated icons.
6. Verify with headless scripts and logs. Do not rely on screenshots unless the user explicitly asks or has not forbidden them.
7. Report the exact source-class finding, changed theme hooks, and verification results.

## Source-First Rules

- Use `rg` against Godot source to find the actual editor class and node construction. Examples: `InspectorDock`, `FileSystemDock`, `SceneTreeDock`, `DockTabContainer`, `EditorInspector`.
- Read the relevant C++ around the node creation. Do not infer that a visible toolbar is a `TabContainer`, `PanelContainer`, or `HBoxContainer` until source confirms it.
- Follow class inheritance. Example: `InspectorDock -> EditorDock -> MarginContainer`; this means `EditorDock.margin_*` can affect dock content even when `DockTabContainer.panel` appears relevant.
- Check type variations. Godot editor often uses strings such as `FlatMenuButton`, `NoBorderHorizontalBottom`, `EditorInspectorContainer`, `EditorPropertyContainer`, `BottomPanel`, and `TabContainerInner`.
- Theme internal editor class names when needed. It is valid to add rows such as `EditorDock`, `DockTabContainer`, or `NoBorderHorizontalBottom` when source shows those classes/variations own the layout.

## Verification Standard

Use scripts and logs as the main proof. Existing useful commands:

```powershell
& 'C:\Programming_Files\Godot\Godot_v4.6.2-stable_win64.exe\Godot_v4.6.2-stable_win64.exe' --headless --path . --import
& 'C:\Programming_Files\Godot\Godot_v4.6.2-stable_win64.exe\Godot_v4.6.2-stable_win64.exe' --headless --path . --script .planning/qa/theme-rescue/theme_rescue_verify.gd
& 'C:\Programming_Files\Godot\Godot_v4.6.2-stable_win64.exe\Godot_v4.6.2-stable_win64.exe' --headless --path . --script .planning/qa/theme-rescue/theme_default_compare.gd
git diff --check
```

Prefer adding a small targeted GDScript probe when a bug depends on an editor class, theme variation, or inherited theme lookup. Keep probes in `.planning/qa/theme-rescue/`.

When the user provides screenshots and asks to measure spacing, use the local image path and measure pixels with an image tool or script. Report measured values and what theme hook controls them.

## What Helps Behind The Scenes

- Comparing runtime theme values against `ThemeDB.get_default_theme()`.
- Logging stylebox colors, borders, content margins, expand margins, corner radii, icon sizes, and constants.
- Testing flat, raised, desktop, and mobile variants across all selectable styles when a change affects shared bindings.
- Checking for `UNINTENTIONAL_STYLE`, positive shadows, wrong label chrome, excessive icon sizes, missing type variations, and fallback/default-only drift.
- Using Godot Minimal Theme as a practical reference for compact editor spacing and editor-specific variations, while avoiding code-for-code copying.
- Regenerating comparison logs after changing intentional overrides so future sessions can see what changed and why.

## Collaboration Style

The user will often iterate from screenshots and corrections. Treat corrections as new evidence, not as failure noise. Keep working autonomously, but explain the source mapping and verification briefly. If screenshots are forbidden for a session, do not take them; use scripts, logs, source reads, and pixel measurement of user-provided images instead.
