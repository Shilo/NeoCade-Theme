# NeoCade Theme — Editor Coverage Map

**Authored:** 2026-05-04 (independent reviewer MAJ-7)
**Audience:** users applying NeoCade as an editor theme via Godot's Editor Settings → Interface → Theme → Custom Theme.
**Status:** v1 scope. Updated when v1.x adds editor-only types.

When NeoCade is applied as the Godot editor theme, **every Control class that uses the user-facing public theme types is restyled**, but Godot's editor-internal theme types (which extend the public types) are NOT styled in v1 and fall back to the engine default. This document explicitly maps which surfaces are themed and which are not, so users know what to expect.

## Themed in v1 (the 35 user-facing Control classes from FEATURES.md Section 1)

When you set NeoCade as your editor theme, these surfaces will adopt NeoCade styling:

| Editor surface | Underlying Control class | Notes |
|---|---|---|
| Inspector property fields (LineEdit, SpinBox, OptionButton dropdowns, Color preview button) | `LineEdit`, `SpinBox`, `OptionButton`, `ColorPickerButton` | Themed |
| Scene tree (node list) | `Tree` | Themed (16 styleboxes + 12 icons) |
| FileSystem dock | `Tree` + `ItemList` | Themed |
| Output panel, Debugger panels | `RichTextLabel`, `Tree`, `ItemList` | Themed |
| Script editor — text area | `CodeEdit` (StyleBox + gutter colors) | Themed; **syntax highlighting NOT changed** (per FEATURES AF-7 — syntax colors are not theme entries; user keeps their own syntax preset) |
| Search-replace bar, Find dialog, Save dialog | `Window`, `AcceptDialog`, `ConfirmationDialog`, `FileDialog`, `LineEdit`, `Button` | Themed |
| Tab bar atop editor and inside docks | `TabBar`, `TabContainer` | Themed |
| Menubar (File / Edit / Project / etc.) | `MenuBar` + `PopupMenu` | Themed |
| Right-click context menus | `PopupMenu`, `PopupPanel` | Themed |
| Tooltips | `TooltipPanel`, `TooltipLabel` | Themed |
| Standard buttons (Play, Save, etc., where Godot uses `Button` not `FlatButton`) | `Button` | Themed |
| Sliders, ProgressBars in import dialogs and progress popups | `HSlider`, `VSlider`, `ProgressBar` | Themed |
| Container-level layout (separators, padding inside docks) | `HBoxContainer`, `VBoxContainer`, `MarginContainer`, `ScrollContainer`, `SplitContainer` | Constants (separation, margin) themed; chrome where applicable |
| Color picker dialogs | `ColorPicker` | Themed (16 bespoke icons) |
| Animation track UI, GraphEdit-based editors (visual shaders, animation tree) | `GraphEdit`, `GraphNode`, `GraphFrame` | Basic theming in v1 |

## NOT themed in v1 (editor-internal type variations — falls back to default)

These surfaces use Godot's editor-internal theme types that extend the public Control hierarchy. NeoCade does NOT theme them in v1 (per FEATURES.md AF-6) and they will render with the Godot default editor theme until v1.x adds editor parity:

| Editor surface | Editor-internal type | Why not in v1 |
|---|---|---|
| Toolbar buttons (Play / Pause / Stop / Run / Inspector tabs) | `FlatButton`, `FlatMenuButton` | Editor-only types not in public Control hierarchy |
| Main top-bar mode buttons (2D / 3D / Script / AssetLib) | `MainScreenButton` | Editor-only |
| Bottom panel toggle buttons (Output / Debugger / Animation) | `BottomPanelButton` | Editor-only |
| Inspector chrome — section headers, foldable group headers, property name column styling | `EditorInspectorPlugin`, `EditorProperty*` | Editor-internal API surfaces; not theme entries |
| Scene tree's per-node-type icons | Editor-managed icon set | Independent of user theme |
| Asset Library view chrome | Editor-internal | Out of scope |
| Plugin manager chrome | Editor-internal | Out of scope |

## What this means in practice

- **Most editor work surfaces (Inspector property editors, Scene tree, FileSystem, Script editor text area, dialogs, popups, menus, tooltips) ARE themed.** This is the bulk of where you spend time.
- **Editor chrome that uses editor-only types (toolbar pills, top-bar mode switcher, bottom-panel buttons, Inspector header/group chrome) FALLS BACK to default in v1.** You'll see a visual mix: NeoCade-styled property editors inside default-styled Inspector chrome, NeoCade-styled tabs inside default-styled toolbar.
- **This is documented in PITFALLS.md 2.2** as the "project theme leaks into editor" caveat. Setting NeoCade as the project theme also leaks user-facing types into editor surfaces in tool-script-mode plugins (e.g. addon panels using `LineEdit`) — that leak is intentional in v1 and may be incomplete (the underlying Control inherits NeoCade, but adjacent editor chrome doesn't).
- **v1.x roadmap items** address this: Editor-only theme types (FlatButton, MainScreenButton, BottomPanelButton, EditorInspector*) are explicit v1.x deliverables (FEATURES.md "Add After Validation").

## Recommended install paths (per ARCHITECTURE/STACK README guidance)

Two install paths are documented in the addon README:

1. **Project theme (recommended for game UI):** `ProjectSettings → GUI → Theme → Custom = res://addons/neocade_theme/neocade_theme.tres`. Theme applies to game runtime; leaks into editor chrome where Controls use the public types (most places). This is the "VirtuCade game uses NeoCade" path.
2. **Per-scene theme (recommended for selective use):** Set `theme` property on a root `Control` node. Theme applies only inside that scene's tree. No editor leak. Use this when consuming NeoCade only for specific UI screens.
3. **Editor theme (optional):** `Editor Settings → Interface → Theme → Custom Theme = res://addons/neocade_theme/neocade_theme.tres`. Theme applies to the editor as documented in this file (themed surfaces above; default fallbacks for editor-only types).

---
*Last updated: 2026-05-04 after independent review MAJ-7.*
*Next review trigger: v1.x ships with editor-only type coverage — update tables.*
