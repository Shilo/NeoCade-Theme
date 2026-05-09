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
- Treat generic base classes as high blast radius. Do not patch base `TabContainer`, `MarginContainer`, `HBoxContainer`, `VBoxContainer`, `PanelContainer`, or `Button` behavior for an editor-only symptom until source proves the same hook owns the visible editor case and the runtime case.

## Invisible Fix Recovery

If a theme change verifies in logs but the user reports no visible change, stop tuning that same hook. Re-trace the editor node stack from source and find the wrapper that actually owns the visible spacing, background, or chrome.

Recovery order:

1. Confirm the changed theme item resolves at runtime.
2. Check whether the visible control is wrapped by editor-only classes or theme variations.
3. Trace parent and child containers in Godot source.
4. Add a targeted probe for each suspected layer before accepting the fix.
5. Prefer editor-specific hooks over generic Control hooks unless the issue is truly global.

Session pattern to remember: `DockTabContainer.panel` did not visibly fix Inspector toolbar spacing; `EditorDock.margin_*` affected the dock content; `NoBorderHorizontalBottom.margin_top` controlled the remaining bottom gap.

## Verification Standard

Use scripts and logs as the main proof. Existing useful commands:

```powershell
& 'C:\Programming_Files\Godot\Godot_v4.6.2-stable_win64.exe\Godot_v4.6.2-stable_win64.exe' --headless --path . --import
& 'C:\Programming_Files\Godot\Godot_v4.6.2-stable_win64.exe\Godot_v4.6.2-stable_win64.exe' --headless --path . --script .planning/qa/theme-rescue/theme_rescue_verify.gd
& 'C:\Programming_Files\Godot\Godot_v4.6.2-stable_win64.exe\Godot_v4.6.2-stable_win64.exe' --headless --path . --script .planning/qa/theme-rescue/theme_default_compare.gd
& 'C:\Programming_Files\Godot\Godot_v4.6.2-stable_win64.exe\Godot_v4.6.2-stable_win64.exe' --headless --path . --script .planning/qa/theme-rescue/theme_editor_dock_probe.gd
& 'C:\Programming_Files\Godot\Godot_v4.6.2-stable_win64.exe\Godot_v4.6.2-stable_win64.exe' --headless --path . --script .planning/qa/theme-rescue/theme_scene_structure_probe.gd
& 'C:\Programming_Files\Godot\Godot_v4.6.2-stable_win64.exe\Godot_v4.6.2-stable_win64.exe' --headless --path . --script .planning/qa/theme-rescue/theme_tab_state_probe.gd
& 'C:\Programming_Files\Godot\Godot_v4.6.2-stable_win64.exe\Godot_v4.6.2-stable_win64.exe' --headless --path . --script .planning/qa/theme-rescue/theme_popup_scrollbar_probe.gd
& 'C:\Programming_Files\Godot\Godot_v4.6.2-stable_win64.exe\Godot_v4.6.2-stable_win64.exe' --headless --path . --script .planning/qa/theme-rescue/theme_create_dialog_probe.gd
git diff --check
```

Prefer adding a small targeted GDScript probe when a bug depends on an editor class, theme variation, or inherited theme lookup. Keep probes in `.planning/qa/theme-rescue/`.

For spacing, padding, clipping, icon-size, or alignment complaints based on a user-provided screenshot, measure pixels before changing constants. Do not guess spacing by eye. User-provided screenshots may be measured even when new screenshots are forbidden. Report measured values and what theme hook controls them.

## What Helps Behind The Scenes

- Comparing runtime theme values against `ThemeDB.get_default_theme()`.
- Logging stylebox colors, borders, content margins, expand margins, corner radii, icon sizes, and constants.
- Testing flat, raised, desktop, and mobile variants across all selectable styles when a change affects shared bindings.
- Checking for `UNINTENTIONAL_STYLE`, positive shadows, wrong label chrome, excessive icon sizes, missing type variations, and fallback/default-only drift.
- Checking `StyleBoxEmpty` vs `StyleBoxFlat` when a Godot default gap should inherit its parent surface instead of painting its own color.
- Fully authoring state slots for editor secondary variations when probes show Godot is falling back to defaults instead of resolving inherited NeoCade slots.
- Tracing flat editor inspector controls back to their parent paint source. Many editor property `OptionButton`s and `EditorSpinSlider`s set `flat = true`, so their normal face is not drawn by the control itself; `EditorProperty.child_bg` is the reusable value-cell surface.
- Using Godot Minimal Theme as a practical reference for compact editor spacing and editor-specific variations, while avoiding code-for-code copying.
- Regenerating comparison logs after changing intentional overrides so future sessions can see what changed and why.

## Reusable Editor Patterns

- Treat editor screenshots as compositions of nested generic controls plus editor-specific variations. Trace the owning source class first, then decide whether the fix belongs to the base control, an editor variation, or a wrapper.
- Splitter gaps should usually be contextual. Godot's default theme sets `SplitContainer.split_bar_background`, `HSplitContainer.split_bar_background`, and `VSplitContainer.split_bar_background` to `StyleBoxEmpty`; the modern editor theme and Godot Minimal Theme mostly set splitter constants/icons, not a painted background. This lets docks, dialogs, and panels inherit the parent surface instead of forcing one global stripe color.
- Do not globally paint split-bar backgrounds to the darkest surface unless the user explicitly wants a visible stripe everywhere. The safer editor-layout default is an empty split-bar background with explicit grabber icons/colors.
- Secondary editor variations can be inheritance traps. Variations such as `TreeSecondary`, `ItemListSecondary`, `ScrollContainerSecondary`, and editor-only container variants may not resolve every dynamic NeoCade slot the way the base type does. If probes show fallback colors or sizes, explicitly author the variation slots.
- For list/tree views with no separator/border/outline, check all relevant theme paths: panel border width, guide/relationship colors, guide/relationship constants, `outline_size`, and `font_outline_color`. Use Button hover/pressed styleboxes as the reference for item hover/selected backgrounds when the user asks for state consistency.
- For Tree nesting paths, do not confuse row guides with relationship lines. `draw_guides`/`guide_color` control guide/separator style lines; `draw_relationship_lines`, `relationship_line_width`, `parent_hl_line_width`, `children_hl_line_width`, and the related colors control the parent-child path lines.
- For editor settings/project settings property inputs, source usually routes enum and numeric fields through `EditorProperty` children. Theme the value surface with `EditorProperty.child_bg`, keep `EditorProperty.bg` transparent, and use `EditorSpinSlider.label_bg` plus `EditorInspectorButton` sizing/color slots for consistency.
- Keep concrete source maps as examples, not as the only target. Example: `CreateDialog` / "Create New Node" is built in `editor/gui/create_dialog.cpp` with nested split containers, `TreeSecondary`, `ItemListSecondary`, and `HeaderSmall`; the same investigation pattern applies to other editor dialogs and docks.

## Collaboration Style

The user will often iterate from screenshots and corrections. Treat corrections as new evidence, not as failure noise. Keep working autonomously, but explain the source mapping and verification briefly. If screenshots are forbidden for a session, do not take them; use scripts, logs, source reads, and pixel measurement of user-provided images instead.
