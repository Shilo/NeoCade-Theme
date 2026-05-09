# Editor Theme Debugging Playbook

## Local References

- Godot source: `C:\Programming_Files\Godot\godot-master`
- Godot Minimal Theme: `C:\Programming_Files\Godot\godot-minimal-theme-main\minimal_theme.tres`
- NeoCade repo: `C:\Programming_Files\Shilocity\Godot\NeoCade-Theme`
- Main implementation: `addons/neocade_theme/scripts/neocade_theme.gd`
- QA scripts/logs: `.planning/qa/theme-rescue/`

## Investigation Pattern

Start from the visible symptom and find the owning source class:

```powershell
rg -n "Filter Properties|InspectorDock|NoBorderHorizontalBottom|set_theme_type_variation|MarginContainer" C:\Programming_Files\Godot\godot-master\editor
rg -n "FileSystemDock|toolbar_hbc|toolbar2_hbc|FlatMenuButton|NoBorderHorizontalBottom" C:\Programming_Files\Godot\godot-master\editor
rg -n "DockTabContainer|SideDockTabContainer|BottomSideDockTabContainer" C:\Programming_Files\Godot\godot-master\editor C:\Programming_Files\Godot\godot-master\scene
```

Then compare reference theme behavior:

```powershell
rg -n "EditorInspector|FlatMenuButton|NoBorderHorizontalBottom|TabContainer|HBoxContainer|VBoxContainer" C:\Programming_Files\Godot\godot-minimal-theme-main\minimal_theme.tres
rg -n "EditorInspector|FlatMenuButton|NoBorderHorizontalBottom|TabContainer|HBoxContainer|VBoxContainer" C:\Programming_Files\Godot\godot-master\editor\themes\theme_modern.cpp
```

## Common Source Mappings

- Inspector toolbar rows:
  - Source: `editor/docks/inspector_dock.cpp`
  - Main dock class: `InspectorDock`
  - Inheritance: `InspectorDock -> EditorDock -> MarginContainer`
  - Toolbar rows: plain `HBoxContainer`s inside a `VBoxContainer`
  - Object selector row: `EditorObjectSelector`
  - Scroll body wrapper: `MarginContainer` variation `NoBorderHorizontalBottom`
  - Useful theme hooks: `EditorDock.margin_*`, `VBoxContainer.separation`, `NoBorderHorizontalBottom.margin_top`

- FileSystem dock toolbar:
  - Source: `editor/docks/filesystem_dock.cpp`
  - Toolbar rows: `toolbar_hbc`, `toolbar2_hbc`
  - Buttons: `FlatButton`, `FlatMenuButton`
  - Search/path inputs: `LineEdit`
  - Scroll/tree wrappers often use `NoBorderHorizontalBottom`

- Dock tab chrome:
  - Source: `editor/docks/dock_tab_container.h/cpp`, `scene/gui/tab_container.cpp`
  - Classes: `DockTabContainer`, `SideDockTabContainer`, `BottomSideDockTabContainer`
  - `TabContainer.tabbar_background` draws the full tab header rectangle.
  - `TabContainer.panel` draws the content area behind dock children.
  - Do not add generic `TabContainer` padding for an editor-only dock issue unless runtime tabs need it too.

- Editor "more" / overflow icons:
  - Source often pulls from `EditorIcons`, not only Control icon slots.
  - Useful icon names seen in editor tabs/toolbars: `GuiTabMenu`, `GuiTabMenuHl`, `GuiTabMenuHlDarkBackground`, `TripleBar`.

## Theme Editing Heuristics

- Keep `MarginContainer` generic margins at zero unless the whole app should inherit padding.
- Treat generic base classes as high blast radius. Do not patch generic `TabContainer`, `MarginContainer`, `HBoxContainer`, `VBoxContainer`, `PanelContainer`, or `Button` behavior for an editor-only symptom until source proves the same hook owns the runtime and editor cases.
- Add editor-specific rows/variations for editor chrome: `EditorDock`, `DockTabContainer`, `NoBorderHorizontalBottom`, etc.
- Register custom variations in `TYPE_VARIATIONS` when inheritance from another theme type matters.
- Add `BINDING_TABLE` entries for every intentional dynamic override so regeneration is stable.
- Update verification scripts whenever adding a new intentional override. The default comparison log should classify it as intentional, not unintentional or fallback.
- Avoid soft shadows. Raised NeoCade depth should be solid border/extrusion behavior.
- Labels and rich text labels should remain text-only unless source proves a panel is needed.

## Invisible Fix Recovery

When a theme value changes in logs but the visible UI does not move, stop tuning that hook and trace the next wrapper layer.

1. Confirm the changed theme item resolves at runtime.
2. Check whether the visible control has an editor-only parent, wrapper, or theme variation.
3. Read the source that adds each parent and child node.
4. Add a targeted probe for each suspected class or variation.
5. Prefer editor-specific hooks when the problem exists only inside the editor.

Session example: `DockTabContainer.panel` looked plausible for Inspector toolbar padding but did not visibly affect the row stack. The working source path was `InspectorDock -> EditorDock -> MarginContainer`, then `NoBorderHorizontalBottom` for the body wrapper gap.

## Verification Additions

When fixing a new editor class or theme variation, add one targeted assertion or probe. Good probes answer one of these:

- Does the theme contain the intended type variation base?
- Does the runtime theme item resolve to the intended value?
- Does the class inheritance path make the override reachable?
- Does the default-vs-NeoCade comparison classify the override as intentional?

Example checks:

```gdscript
if theme.get_type_variation_base(&"NoBorderHorizontalBottom") != &"NoBorderHorizontal":
    _fail("NoBorderHorizontalBottom should inherit NoBorderHorizontal")

_expect_equal(theme.get_constant(&"margin_top", &"NoBorderHorizontalBottom"), 4, "NoBorderHorizontalBottom.margin_top")

if ClassDB.class_exists("InspectorDock") and not ClassDB.is_parent_class("InspectorDock", "EditorDock"):
    _fail("InspectorDock should inherit EditorDock")
```

Useful existing targeted probes:

```powershell
& 'C:\Programming_Files\Godot\Godot_v4.6.2-stable_win64.exe\Godot_v4.6.2-stable_win64.exe' --headless --path . --script .planning/qa/theme-rescue/theme_editor_dock_probe.gd
& 'C:\Programming_Files\Godot\Godot_v4.6.2-stable_win64.exe\Godot_v4.6.2-stable_win64.exe' --headless --path . --script .planning/qa/theme-rescue/theme_scene_structure_probe.gd
& 'C:\Programming_Files\Godot\Godot_v4.6.2-stable_win64.exe\Godot_v4.6.2-stable_win64.exe' --headless --path . --script .planning/qa/theme-rescue/theme_tab_state_probe.gd
& 'C:\Programming_Files\Godot\Godot_v4.6.2-stable_win64.exe\Godot_v4.6.2-stable_win64.exe' --headless --path . --script .planning/qa/theme-rescue/theme_popup_scrollbar_probe.gd
```

## Screenshot Measurement

When the user provides a local screenshot for a spacing, padding, clipping, icon-size, or alignment complaint, measure the image before changing constants. Useful approach:

1. Load the screenshot with Python/PIL.
2. Print row/column dominant colors and runs.
3. Identify background, border, and control fill colors.
4. Convert the visual complaint into concrete pixel gaps.
5. Patch the theme hook that owns that gap, then verify with logs.

Do not take new screenshots if the user has asked not to. User-provided screenshots can still be measured.
