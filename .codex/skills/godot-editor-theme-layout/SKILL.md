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

## Regression Avoidance

- Do not turn overlay/focus styleboxes into normal filled panels. `EditorStyles.FocusViewport` is drawn directly over the 2D/3D viewport; it must be transparent center / outline-only (`draw_center=false` in Godot source terms, or NeoCade's `focus_ring` recipe). A filled background here hides the entire viewport on hover/focus.
- Do not fix one plain dialog by broadening base `Tree.panel` without checking every source path that also uses it. `EditorResourcePicker` draws its inspector fields from `Tree.panel`, and `TreeSecondary` / `TreeTable` inherit from `Tree`; a base Tree surface change can regress Scene, Signals, Groups, resource pickers, dependency dialogs, and settings tables.
- When a Signals/Groups/class subsection row should reveal the parent list edge on the left/right, keep the fix scoped to `Editor.prop_subsection` and `Editor.prop_subsection_stylebox`. Critical trap: these rows call `TreeItem.set_custom_bg_color()` with `Editor.prop_subsection`, and `Tree` draws that color edge-to-edge before drawing the stylebox. Keep `Editor.prop_subsection` transparent and put the visible inset fill in `Editor.prop_subsection_stylebox`; do not change `TreeSecondary`/`TreeTable` title buttons unless source inspection proves the target is a real Tree title row.

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
& 'C:\Programming_Files\Godot\Godot_v4.6.2-stable_win64.exe\Godot_v4.6.2-stable_win64.exe' --headless --path . --script .planning/qa/theme-rescue/theme_editor_regression_probe.gd
& 'C:\Programming_Files\Godot\Godot_v4.6.2-stable_win64.exe\Godot_v4.6.2-stable_win64.exe' --headless --editor --path . --script .planning/qa/theme-rescue/theme_editor_sentinel_leak_probe.gd
& 'C:\Programming_Files\Godot\Godot_v4.6.2-stable_win64.exe\Godot_v4.6.2-stable_win64.exe' --headless --editor --path . --script .planning/qa/theme-rescue/theme_editor_merge_leak_probe.gd
git diff --check
```

Prefer adding a small targeted GDScript probe when a bug depends on an editor class, theme variation, or inherited theme lookup. Keep probes in `.planning/qa/theme-rescue/`.

For spacing, padding, clipping, icon-size, or alignment complaints based on a user-provided screenshot, measure pixels before changing constants. Do not guess spacing by eye. User-provided screenshots may be measured even when new screenshots are forbidden. Report measured values and what theme hook controls them.

When investigating editor-setting color leaks, ask the user to temporarily set obvious sentinel colors in the Godot editor first; do not assume the editor is already using sentinel values. Best diagnostic pair: set `interface/theme/base_color` to `#ff00ff` (magenta) and `interface/theme/accent_color` to `#00ffff` (cyan), then reproduce/reload the editor theme and run `theme_editor_sentinel_leak_probe.gd`. Magenta marks generated editor base/surface leaks; cyan marks generated editor accent leaks. These colors are temporary diagnostic aids only and should not be treated as the normal theme configuration. Godot builds a generated editor theme from `interface/theme/*` and then merges the custom theme over it, so unowned editor slots can leak sentinel colors even when runtime controls are fully styled. Treat probe hits as missing theme ownership for real editor type/slot names, not as a reason to globally copy editor settings. `theme_editor_sentinel_leak_probe.gd` scans both the merged `EditorTheme` type/slot table and the live editor `Control` tree for resolved sentinel colors/styleboxes.

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
- SplitContainer grabbers may be correctly themed but hidden. Godot only draws the non-touch grabber while dragging, hovering, forced visible, or when `autohide` is disabled. Log `split_bar_background`, `separation`, `minimum_grab_thickness`, `autohide`, and grabber icon sizes from the merged editor theme before calling it a styling regression.
- Secondary editor variations can be inheritance traps. Variations such as `TreeSecondary`, `ItemListSecondary`, `ScrollContainerSecondary`, and editor-only container variants may not resolve every dynamic NeoCade slot the way the base type does. If probes show fallback colors or sizes, explicitly author the variation slots.
- For list/tree views with no separator/border/outline, check all relevant theme paths: panel border width, guide/relationship colors, guide/relationship constants, `outline_size`, and `font_outline_color`. Use Button hover/pressed styleboxes as the reference for item hover/selected backgrounds when the user asks for state consistency.
- `TreeTable` is a compact editor table variation, not just "Tree with table colors." Godot's `ActionMapEditor` uses `TreeTable` for the Input Map action rows and packs Revert/Add/Remove as `TreeItem` buttons, not normal `Button` nodes. `Tree` lays these buttons right-to-left. Godot's modern theme keeps `TreeTable.button_margin=0`, but its `button_pressed` and `button_hover` styleboxes reserve transparent left/right content margins; without those margins the icons visually collapse. Fix the TreeTable button stylebox minimum size before changing icon artwork, unrelated toolbar spacing, or generic Tree spacing. Verify with a `get_item_area_rect()` probe.
- For Tree nesting paths, do not confuse row guides with relationship lines. `draw_guides`/`guide_color` control guide/separator style lines; `draw_relationship_lines`, `relationship_line_width`, `parent_hl_line_width`, `children_hl_line_width`, and the related colors control the parent-child path lines.
- Respect Godot's editor relationship-line setting semantics. `interface/theme/draw_relationship_lines` maps `None=0`, `Selected Only=1`, `All=2`; `Selected Only` still sets `draw_relationship_lines=1`, but keeps `relationship_line_width=0` while `parent_hl_line_width`/`children_hl_line_width` draw only the selected branch path. Gate editor-setting reads behind `Engine.is_editor_hint()` before touching `EditorInterface`.
- For editor settings/project settings property inputs, source usually routes enum and numeric fields through `EditorProperty` children. Theme the value surface with `EditorProperty.child_bg`, keep `EditorProperty.bg` transparent, and use `EditorSpinSlider.label_bg` plus `EditorInspectorButton` sizing/color slots for consistency.
- Resource picker fields such as Theme, Material, and Script are `EditorResourcePicker` controls. Godot currently draws their background from `Tree.panel`, so making base `Tree.panel` empty lets `EditorProperty.child_bg` show through; keep visible tree/list surfaces on contextual variations such as `TreeSecondary` instead.
- If a plain editor dialog `Tree` needs a visible list surface, remember this competes with `EditorResourcePicker`, which also draws `Tree.panel`. This is a high-blast-radius tradeoff: keep the base Tree panel borderless/subtle, and re-run resource picker/editor property probes after changing it.
- Inspector resource fields (`Theme`, `Material`, `Script`) are `EditorPropertyResource` containing `EditorResourcePicker`; the picker paints `Tree.panel` directly. If these fields do not match inspector value cells, compare `Tree.panel` against `EditorProperty.child_bg` in a probe.
- Inspector/category/property text may use `EditorFonts.main` / `EditorFonts.bold` instead of ordinary Control font slots. When font families look mixed in editor-only UI, explicitly author `EditorFonts` aliases before chasing Label/Button font slots.
- Checkbox and CheckButton active icon tint is not controlled by ordinary `Button.icon_*_color`. Godot draws `CheckBox.checkbox_checked_color` / `checkbox_unchecked_color` and `CheckButton.button_checked_color` / `button_unchecked_color`; author those slots when checked state should use accent.
- Bottom panel tabs and counters are editor-specific. The `Output`, `Debugger`, etc. labels are `TabContainer` tabs under the `BottomPanel` variation, utility buttons use `BottomPanelButton`, and Output counters use `EditorLogFilterButton`.
- Editor Settings top tabs use `TabContainerOdd`, not the base `TabBar`. Signals/class header rows use `Editor.prop_subsection` and `Editor.prop_subsection_stylebox`, not Tree column title buttons.
- File dialog thumbnail blur usually means a tiny fallback icon is being scaled up. Check `FileDialog.file_thumbnail`/`folder_thumbnail` and filesystem `EditorIcons.FileBigThumb`/`FolderBigThumb`/medium variants; imported SVG texture size should be close to the requested thumbnail size.
- The Output log body is a plain `RichTextLabel` in `EditorLog`. Godot editor themes give it a background by styling global `RichTextLabel.normal`; NeoCade intentionally keeps base `RichTextLabel` text-only, so use `BottomPanel` / `EditorStyles.BottomPanel` for theme-only Output-safe background work unless a source/plugin hook adds an Output-specific variation.
- Plain editor `RichTextLabel` surfaces appear in logs, help, export result dialogs, warnings, and other editor panes. If runtime RichTextLabel must stay text-only, apply the opaque editor RichTextLabel panel from a guarded editor-only runtime hook (`Engine.is_editor_hint()` / `EditorInterface`) instead of changing the base runtime binding.
- Generic editor dialogs may use a plain `Tree` with no type variation. If a dialog list blends into the dialog background, trace whether the list is `Tree`, `ItemList`, or a secondary variation before assuming the shell panel is wrong. A visible, borderless base `Tree.panel` can be necessary for plain editor Tree dialogs.
- Inspector layout hints are `ControlPositioningWarning` and get their panel from `EditorProperty.bg_group_note`. If the icon/text hugs the edge, fix the stylebox content margins before changing Label or TextureRect behavior.
- Signals/Groups/class subsection rows use `Editor.prop_subsection_stylebox`. If the header should reveal the parent view edge, reserve only the needed transparent side space there and avoid full outlines that turn subsection rows into boxes. If changing the stylebox does nothing visually, inspect the paired `Editor.prop_subsection` color first; an opaque color masks the stylebox inset in `Tree`.
- Checkbox/toggle active fill should stay on Godot's built-in modulation path when possible. Use white mask SVGs with black internal marks/knobs, then set `CheckBox.checkbox_checked_color` / `CheckButton.button_checked_color` to accent and the unchecked colors to a lighter base-derived inactive fill. This keeps `base_color` / `accent_color` dynamic without baking per-color icons.
- CheckBox radio buttons use the CheckBox icon slots (`radio_checked`, `radio_unchecked`) and the same `checkbox_checked_color` / `checkbox_unchecked_color` modulation path. Keep radio, checkbox, and checkbutton active/inactive fills visually related unless the user asks for a deliberate distinction. PopupMenu radio/check items are different: `PopupMenu` draws those icons with item `icon_modulate`, so CheckBox color slots do not recolor popup menu radios; use tiny runtime-generated PopupMenu icons from the same accent/inactive roles when menu check/radio items must visually match the rest of the theme. NeoCade gates this with the Advanced export `use_runtime_popup_selection_icons` so overhead can be disabled deliberately.
- Static SVG checkbox/checkbutton/radio icons cannot automatically follow the exported corner radius. Dynamic radius support requires generated icons or a small family of per-radius assets; static SVGs are acceptable when the radius mismatch is minor and the visual contract values consistency over exact per-control radius.
- Godot's editor theme settings (`interface/theme/base_color`, `accent_color`, etc.) can leak through unstyled editor slots as obvious sentinel fallback colors when the user changes those settings. If NeoCade is not intentionally adopting editor settings as its source of truth, author the specific missing editor theme slots found by `theme_editor_merge_leak_probe.gd` so internal editor widgets stop falling back to Godot's generated editor theme.
- Sentinel leaks in editor screenshots often map to `EditorStyles` and editor-only variations, not ordinary runtime controls. `EditorStyles.Content` paints the main editor content panel, `EditorStyles.DebuggerPanel` paints the debugger bottom panel, `EditorStyles.PanelForeground` / `PanelForeground.panel` / `EditorInspectorForeground.panel` paint foreground editor panels, and `TabContainerInner` / `TabBarInner` own inner editor tab strips. Source-trace these first before changing base `Panel`, `TabContainer`, `TabBar`, or `MarginContainer`.
- A sentinel leak run is not finished until both sections in `theme-editor-sentinel-leaks.log` have zero `LEAK` lines: merged `EditorTheme` slots and live editor `Control` tree resolved values. Re-run the probe after each fix; do not claim success from source edits alone.
- Common editor sentinel leak families: `_mirrored` Button/CheckBox/CheckButton styleboxes, `FlatButton`/`FlatMenuButton` mirrored hover/pressed states, `SpinBox` pressed arrow colors plus up/down pressed background styleboxes, `PopupProgressBar.background/fill` during editor loading/import, `TreeTable` row-state styleboxes, `TreeLineEdit.normal`, and editor-only panels such as `GamePanel`, `PanelContainerTabbarInner`, `ScrollContainerSecondary`, `EditorAudioBus`, `EditorDebuggerInspector`, and `EditorValidationPanel`.
- Some editor classes are registered built-in classes, not type variations. If `set_type_variation()` logs "A type associated with a built-in class cannot be marked as a variation", remove that entry from `TYPE_VARIATIONS` and keep explicit `BINDING_TABLE` slots for the type instead.
- Label and RichTextLabel must remain visually text-only. If editor-generated fallback leaks through `Label.normal`, use `StyleBoxEmpty` or fully transparent zero-border chrome and update probes to treat that as intentional blocking of fallback, not as visible label chrome.
- EditorSpinSlider hover uses `HSlider.grabber_highlight`; generic sliders use `grabber_highlight` and `grabber_area_highlight`. If a hover knob changes shape, inspect the HSlider/VSlider icons rather than `EditorSpinSlider.label_bg`.
- ColorPicker alpha/checker artifacts usually come from tiled icon slots, not text. Check `ColorPicker.sample_bg`, `ColorPickerButton.bg`, and `ColorPresetButton.preset_bg`; they should be simple checker textures, not pictorial glyphs that repeat across swatches.
- Code editor readability is split between Theme and EditorSettings. `CodeEdit.normal`, gutter colors, caret, selection, completion, and line colors are theme slots; syntax token colors and several highlighting colors come from `text_editor/theme/highlighting/*` EditorSettings.
- Keep concrete source maps as examples, not as the only target. Example: `CreateDialog` / "Create New Node" is built in `editor/gui/create_dialog.cpp` with nested split containers, `TreeSecondary`, `ItemListSecondary`, and `HeaderSmall`; the same investigation pattern applies to other editor dialogs and docks.

## Collaboration Style

The user will often iterate from screenshots and corrections. Treat corrections as new evidence, not as failure noise. Keep working autonomously, but explain the source mapping and verification briefly. If screenshots are forbidden for a session, do not take them; use scripts, logs, source reads, and pixel measurement of user-provided images instead.
