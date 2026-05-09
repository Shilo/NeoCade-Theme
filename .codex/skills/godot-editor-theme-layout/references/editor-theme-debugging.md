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
rg -n "CreateDialog|TreeSecondary|ItemListSecondary|split_bar_background|HSplitContainer" C:\Programming_Files\Godot\godot-master\editor C:\Programming_Files\Godot\godot-master\scene
rg -n "EditorProperty|EditorInspectorButton|EditorSpinSlider|set_flat\(true\)" C:\Programming_Files\Godot\godot-master\editor\inspector C:\Programming_Files\Godot\godot-master\editor\gui C:\Programming_Files\Godot\godot-master\editor\settings
rg -n "BottomPanel|BottomPanelButton|EditorLogFilterButton|TabContainerOdd|prop_subsection|draw_relationship_lines|relationship_line_opacity" C:\Programming_Files\Godot\godot-master\editor C:\Programming_Files\Godot\godot-master\scene
rg -n "FileBigThumb|FolderBigThumb|file_thumbnail|folder_thumbnail|checkbox_checked_color|button_checked_color|EditorResourcePicker" C:\Programming_Files\Godot\godot-master\editor C:\Programming_Files\Godot\godot-master\scene
```

Then compare reference theme behavior:

```powershell
rg -n "EditorInspector|FlatMenuButton|NoBorderHorizontalBottom|TabContainer|HBoxContainer|VBoxContainer" C:\Programming_Files\Godot\godot-minimal-theme-main\minimal_theme.tres
rg -n "EditorInspector|FlatMenuButton|NoBorderHorizontalBottom|TabContainer|HBoxContainer|VBoxContainer" C:\Programming_Files\Godot\godot-master\editor\themes\theme_modern.cpp
rg -n "SplitContainer|split_bar_background|ItemListSecondary|TreeSecondary|draw_guides|guide_color" C:\Programming_Files\Godot\godot-minimal-theme-main\minimal_theme.tres C:\Programming_Files\Godot\godot-master\editor\themes C:\Programming_Files\Godot\godot-master\scene\theme\default_theme.cpp
rg -n "EditorProperty|EditorSpinSlider|relationship_line|ScrollBar|grabber_style" C:\Programming_Files\Godot\godot-minimal-theme-main\minimal_theme.tres C:\Programming_Files\Godot\godot-master\editor\themes\theme_modern.cpp
rg -n "BottomPanelButton|EditorLogFilterButton|TabContainerOdd|EditorInspectorCategory|EditorHelpBit|Tree.panel" C:\Programming_Files\Godot\godot-minimal-theme-main\minimal_theme.tres C:\Programming_Files\Godot\godot-master\editor\themes\theme_modern.cpp
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

- Bottom panel:
  - Source: `editor/gui/editor_bottom_panel.cpp`, `editor/editor_log.cpp`
  - The bottom labels such as Output/Debugger are tabs on `EditorBottomPanel -> DockTabContainer -> TabContainer` with theme variation `BottomPanel`.
  - Pin/expand/clear/collapse buttons use `BottomPanelButton`.
  - Output filter/count buttons use `EditorLogFilterButton`.
  - The Output log body itself is a plain `RichTextLabel` owned by `EditorLog`; identify it before changing any `RichTextLabel`/bottom-panel surface.

- Create New Node dialog:
  - Source: `editor/gui/create_dialog.cpp`
  - Dialog inheritance: `CreateDialog -> ConfirmationDialog -> AcceptDialog`
  - Main layout: outer `HSplitContainer`; left column `VSplitContainer`; right column `VSplitContainer`
  - Side lists: Favorites and Matches are `Tree` with `TreeSecondary`; Recent is `ItemList` with `ItemListSecondary`
  - Section labels come from `VBoxContainer::add_margin_child`, which uses `HeaderSmall`
  - Useful theme hooks: `AcceptDialog.panel`, `ConfirmationDialog.panel`, `PopupDialog.panel`, `HeaderSmall.font_size`, `TreeSecondary.panel`, `ItemListSecondary.panel`, `ItemListSecondary` selected/hovered styleboxes and selected font colors, `SplitContainer/HSplitContainer/VSplitContainer.split_bar_background`

- Editor/Project Settings property grids:
  - Source: `editor/settings/editor_settings_dialog.cpp` feeds settings into inspector-style property editors.
  - Property drawing: `editor/inspector/editor_inspector.cpp`, especially `EditorProperty::_notification`.
  - Enum controls: `EditorPropertyEnum` and `EditorPropertyTextEnum` create `OptionButton`, call `set_flat(true)`, and set variation `EditorInspectorButton`.
  - Numeric controls: many properties create `EditorSpinSlider`, call `set_flat(true)`, and rely on `LineEdit` metrics plus editor-specific theme items.
  - Important consequence: flat controls do not draw their normal stylebox in `Button::_notification`/`EditorSpinSlider::_draw_spin_slider`. The reusable normal-state value surface is `EditorProperty.child_bg`, not `OptionButton.normal`.
  - Useful theme hooks: `EditorProperty.bg`, `EditorProperty.bg_selected`, `EditorProperty.child_bg`, `EditorSpinSlider.label_bg`, `EditorSpinSlider.label_color`, `EditorSpinSlider.line_edit_margin`, `EditorInspectorButton` styleboxes/colors, and the `SpinBox.updown` icon used by `EditorSpinSlider`.

- Resource picker fields:
  - Source: `editor/inspector/editor_resource_picker.cpp`, `editor/inspector/editor_properties.cpp`
  - Resource fields such as Theme, Material, Script route through `EditorPropertyResource -> EditorResourcePicker`.
  - Assign button uses `EditorInspectorButton`; quick-load/edit buttons use `EditorInspectorFlatButton`.
  - Current Godot source draws the picker background from `Tree.panel`, so if these fields look unlike other inspector values, check whether `Tree.panel` is painting over `EditorProperty.child_bg`.

- Signals dock headers:
  - Source: `editor/docks/signals_dock.cpp`, `editor/scene/connections_dialog.cpp`
  - Class/header rows are custom `TreeItem`s, not Tree column title buttons.
  - Useful hooks are `Editor.prop_subsection`, `Editor.prop_subsection_stylebox`, and related left/right subsection styleboxes.

- Editor Settings top tabs:
  - Source: `editor/settings/editor_settings_dialog.cpp`
  - The General/Shortcuts tabs are a `TabContainer` with type variation `TabContainerOdd`.
  - `TabContainer` forwards its `tab_*` slots to its internal `TabBar`, so author the `TabContainerOdd` variation if only this dialog is wrong.

- File dialog and filesystem thumbnails:
  - `FileDialog` thumbnail mode uses `FileDialog.thumbnail_size` plus `file_thumbnail` / `folder_thumbnail`.
  - The filesystem dock uses `EditorIcons` thumbnail names: `FileBigThumb`, `FileDeadBigThumb`, `FolderBigThumb`, `FileMediumThumb`, `FileDeadMediumThumb`, `FolderMediumThumb`.
  - Blurry fallback icons usually mean the imported SVG texture is much smaller than the fixed icon size and is being scaled up.

## Theme Editing Heuristics

- Keep `MarginContainer` generic margins at zero unless the whole app should inherit padding.
- Treat generic base classes as high blast radius. Do not patch generic `TabContainer`, `MarginContainer`, `HBoxContainer`, `VBoxContainer`, `PanelContainer`, or `Button` behavior for an editor-only symptom until source proves the same hook owns the runtime and editor cases.
- Add editor-specific rows/variations for editor chrome: `EditorDock`, `DockTabContainer`, `NoBorderHorizontalBottom`, etc.
- Register custom variations in `TYPE_VARIATIONS` when inheritance from another theme type matters.
- Add `BINDING_TABLE` entries for every intentional dynamic override so regeneration is stable.
- Do not assume a custom variation will resolve every inherited dynamic slot the way the editor preview implies. If a probe shows fallback colors like Godot default red selected rows or black selected text, author the variation slots explicitly.
- Update verification scripts whenever adding a new intentional override. The default comparison log should classify it as intentional, not unintentional or fallback.
- Avoid soft shadows. Raised NeoCade depth should be solid border/extrusion behavior.
- Labels and rich text labels should remain text-only unless source proves a panel is needed.
- Prefer `StyleBoxEmpty` for contextual split-bar backgrounds. Godot default sets `split_bar_background` to empty for `SplitContainer`, `HSplitContainer`, and `VSplitContainer`; the modern editor theme and Godot Minimal Theme mostly set splitter constants/icons. A filled split-bar style paints a visible stripe and can make dialog layout look like unexpected spacing.
- For list views that should be text/item focused, hide lines through `guide_color` alpha, remove panel borders, keep `outline_size` at 0, and make selected text color intentionally match the accent if that is the Tree convention.
- For Tree views, distinguish guide/separator lines from hierarchy relationship lines. Keep `draw_guides` and `guide_color` off when row guides look noisy, but use `draw_relationship_lines`, `relationship_line_width`, `parent_hl_line_width`, `children_hl_line_width`, and muted relationship colors when the hierarchy path should remain visible like the Godot editor.
- For selected-only Tree relationship lines, match Godot Modern: `draw_relationship_lines=1`, `relationship_line_width=0`, highlighted parent/child widths nonzero, and opacity from `interface/theme/relationship_line_opacity`. Guard `EditorInterface` access with `Engine.is_editor_hint()`; headless project scripts can report the singleton but still reject retrieval.
- For checkbox/toggle icon color, check the control-specific draw colors: `CheckBox.checkbox_checked_color` / `checkbox_unchecked_color` and `CheckButton.button_checked_color` / `button_unchecked_color`. Ordinary `Button.icon_pressed_color` will not tint those icons.
- For scrollbars, Godot modern uses an empty/transparent track and semi-transparent thumb fills. In `theme_modern.cpp`, normal grabber alpha is roughly 0.225 and hover/pressed roughly 0.5; Godot Minimal Theme uses a similar translucent color recipe. Preserve Pulse square corners if that is part of the style, but avoid opaque thumbs unless the user asks.

## Reusable Bug Patterns

- Contextual gap vs painted stripe:
  Split containers, tab headers, toolbar gutters, and dialog margins can all look like "spacing bugs" when the real issue is a child stylebox painting a color that should have been inherited from the parent. Compare against Godot default for `StyleBoxEmpty` before choosing a darker/lighter fill.

- Base type fixed, variation still wrong:
  Editor variants can retain default fallback slots after the base control looks correct. Probe both the base type and the exact variation seen in source, especially for selected/hovered state styleboxes, text colors, panel borders, and constants.

- List/tree visual cleanup:
  No separators usually requires more than one setting. Check guide colors, relationship line colors, draw constants, panel border widths, selected/hovered styleboxes, selected font colors, and outline constants together.

- Flat inspector input controls:
  If `OptionButton`, `Button`, or `EditorSpinSlider` looks transparent only inside Editor Settings, Project Settings, or Inspector rows, check source for `set_flat(true)` before changing base `OptionButton` or `SpinBox`. Flat buttons skip stylebox drawing entirely in normal/hover/pressed states; the visible normal surface is usually the `EditorProperty.child_bg` rectangle behind the right-side child control.

- Dialogs share Control primitives:
  A dialog-specific screenshot may still point to reusable primitives such as `AcceptDialog`, `PopupDialog`, `SplitContainer`, `Tree`, `ItemList`, `LineEdit`, `Button`, or `HeaderSmall`. Fix the primitive or variation when source proves it is reused; keep the dialog source map as evidence, not as a one-off patch target.

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
& 'C:\Programming_Files\Godot\Godot_v4.6.2-stable_win64.exe\Godot_v4.6.2-stable_win64.exe' --headless --path . --script .planning/qa/theme-rescue/theme_create_dialog_probe.gd
```

## Screenshot Measurement

When the user provides a local screenshot for a spacing, padding, clipping, icon-size, or alignment complaint, measure the image before changing constants. Useful approach:

1. Load the screenshot with Python/PIL.
2. Print row/column dominant colors and runs.
3. Identify background, border, and control fill colors.
4. Convert the visual complaint into concrete pixel gaps.
5. Patch the theme hook that owns that gap, then verify with logs.

Do not take new screenshots if the user has asked not to. User-provided screenshots can still be measured.
