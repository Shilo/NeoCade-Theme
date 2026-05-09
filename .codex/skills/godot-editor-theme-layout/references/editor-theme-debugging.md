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
- Add editor-specific rows/variations for editor chrome: `EditorDock`, `DockTabContainer`, `NoBorderHorizontalBottom`, etc.
- Register custom variations in `TYPE_VARIATIONS` when inheritance from another theme type matters.
- Add `BINDING_TABLE` entries for every intentional dynamic override so regeneration is stable.
- Update verification scripts whenever adding a new intentional override. The default comparison log should classify it as intentional, not unintentional or fallback.
- Avoid soft shadows. Raised NeoCade depth should be solid border/extrusion behavior.
- Labels and rich text labels should remain text-only unless source proves a panel is needed.

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

## Screenshot Measurement

When the user provides a local screenshot and asks about spacing, measure the image. Useful approach:

1. Load the screenshot with Python/PIL.
2. Print row/column dominant colors and runs.
3. Identify background, border, and control fill colors.
4. Convert the visual complaint into concrete pixel gaps.
5. Patch the theme hook that owns that gap, then verify with logs.

Do not take new screenshots if the user has asked not to. User-provided screenshots can still be measured.
