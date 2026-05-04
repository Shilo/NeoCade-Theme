# LDtk UI Mining

Authored: 2026-05-04

## Provenance

| Field | Live value |
|---|---|
| Source root | `C:\Programming_Files\ldtk-master\` |
| Snapshot date | 2026-05-04 |
| LDtk version | `1.5.3` from `docs/version.txt` and `app/package.json` |
| Repository metadata | No `.git` directory in local snapshot; no commit SHA available, version-only |
| License | MIT License, copyright Sebastien Benard / Deepnight Games |
| `src/electron.renderer/**/*.hx` | 143 Haxe files |
| `src/electron.renderer/ui/**/*.hx` | 69 Haxe files |
| `src/electron.renderer/page/Editor.hx` | 1 file, 2456 lines |
| `src/electron.renderer/tool/**/*.hx` | 9 Haxe files |
| `app/assets/css/app.scss` | 9322 lines |
| `docs/CHANGELOG.md` | 1023 lines |
| `app/assets/icons/*.svg` | 98 SVG files |
| `res/atlas/` | 2 files: `appElements.aseprite`, `icons.aseprite` |
| `res/fonts/` | 13 files: Noto Sans Display Semicondensed bitmap atlases, `pixel_berry`, and notes |

Inventory commands were run from Windows PowerShell. Preferred `rg` commands were paired with `Get-ChildItem` or `Get-Content | Measure-Object` fallbacks; when both were available for SVG icons, they agreed at 98 files. The local LDtk root has no root `version.txt`; `docs/version.txt` and `app/package.json` both report `1.5.3`.

## Scope and Method

LDtk is a loose inspiration resource, not a NeoCade design spec, value source, or implementation dependency. This document mines LDtk for polish patterns that can inform future design discussion; it does not promote LDtk's UI architecture, palette, icon set, asset pipeline, or editor-specific behavior into requirements.

The order below is optimized for Phase 2 mining flow while preserving every D-10 deliverable from `02-CONTEXT.md`. The Haxe pass records per-file UI behavior first, then extracts adopt/reject candidates with file:line citations. The SCSS, CHANGELOG, asset, and prior-report passes append evidence under their reserved headings.

Every adopted pattern must cite at least one source file path and line range. Every translation note must start with this exact prefix:

`Inspiration sketch - Phase 3 mockup or Phase 5+ designer's call.`

Anti-cyberpunk filtering is mandatory for every candidate pattern. NeoCade's target remains vibrant arcade hall by day: no synthwave/noir drift, no glow halos, no scanline/grid overlays, no sci-fi console terminology, no pixel-art theme chrome, and no direct LDtk visual copying.

PowerShell-native inventory fallbacks used during this phase:

| Intent | Preferred command | PowerShell fallback |
|---|---|---|
| Haxe renderer file count | `rg --files C:\Programming_Files\ldtk-master\src\electron.renderer -g '*.hx'` | `Get-ChildItem C:\Programming_Files\ldtk-master\src\electron.renderer -Recurse -Filter *.hx` |
| Haxe UI file count | `rg --files C:\Programming_Files\ldtk-master\src\electron.renderer\ui -g '*.hx'` | `Get-ChildItem C:\Programming_Files\ldtk-master\src\electron.renderer\ui -Recurse -Filter *.hx` |
| SVG icon count | `rg --files C:\Programming_Files\ldtk-master\app\assets\icons -g '*.svg'` | `Get-ChildItem C:\Programming_Files\ldtk-master\app\assets\icons -Filter *.svg` |
| SCSS line count | `rg --files ...` plus reader count | `(Get-Content C:\Programming_Files\ldtk-master\app\assets\css\app.scss | Measure-Object -Line).Lines` |
| CHANGELOG line count | `rg --files ...` plus reader count | `(Get-Content C:\Programming_Files\ldtk-master\docs\CHANGELOG.md | Measure-Object -Line).Lines` |
| Git metadata | `git -C C:\Programming_Files\ldtk-master rev-parse --short HEAD` | `if (Test-Path C:\Programming_Files\ldtk-master\.git) { git -C ... } else { 'No .git directory in snapshot' }` |

## File-by-File UI Index

Target reconciliation: 80 indexed Haxe surfaces total: 69 files under `src/electron.renderer/ui/**/*.hx`, `src/electron.renderer/page/Editor.hx`, `src/electron.renderer/Tool.hx`, and 9 files under `src/electron.renderer/tool/**/*.hx`. No target files were silently omitted. Verification aliases covered: `ui\CommandPalette.hx`, `ui\modal\ContextMenu.hx`, `ui\modal\Panel.hx`, `ui\palette\`, `ui\vp\`, `page\Editor.hx`, `tool\`.

| Source path | UI role | Primary UI pattern | Disposition |
|---|---|---|---|
| `src/electron.renderer/page/Editor.hx` | Main editor chrome wiring | Main panel buttons, status banners, command routing, layer list, edit-option state classes | adopt-candidate |
| `src/electron.renderer/Tool.hx` | Base tool lifecycle | Tool activation/deactivation, palette injection, cursor state, edit gating | adopt-candidate |
| `src/electron.renderer/tool/LayerTool.hx` | Layer-specific tool base | Thin bridge from tool behavior to current layer context | background |
| `src/electron.renderer/tool/PanView.hx` | Pan/zoom special tool | Body `panning` class and cursor mode switching | adopt-candidate |
| `src/electron.renderer/tool/PickPoint.hx` | Point picker special tool | Link/grid cursor preview and pick feedback | adopt-candidate |
| `src/electron.renderer/tool/ResizeTool.hx` | Resize handles | UI overlay handles and resize cursor modes | adopt-candidate |
| `src/electron.renderer/tool/SelectionTool.hx` | Selection tool | Pick previews, selection feedback, value-pick shortcuts | adopt-candidate |
| `src/electron.renderer/tool/lt/DoNothing.hx` | Disabled layer tool | Forbidden cursor for non-editable layer modes | rejected |
| `src/electron.renderer/tool/lt/EntityTool.hx` | Entity placement tool | Entity preview cursor, grab/move cursor, chain-link preview | adopt-candidate |
| `src/electron.renderer/tool/lt/IntGridTool.hx` | IntGrid paint tool | Colored grid-cell and grid-rect cursor previews | adopt-candidate |
| `src/electron.renderer/tool/lt/TileTool.hx` | Tile paint tool | Tile palette binding, selected tile preview, bad tileset warning | adopt-candidate |
| `src/electron.renderer/ui/CommandPalette.hx` | Command/search overlay | Focus-trapping quick search with icon/category/context result rows | adopt-candidate |
| `src/electron.renderer/ui/Cursor.hx` | Viewport cursor renderer | Semantic cursor types with native cursor and overlay rendering | adopt-candidate |
| `src/electron.renderer/ui/EntityInstanceEditor.hx` | Floating entity editor | Resizable instance editor with faded invalid-state handling | adopt-candidate |
| `src/electron.renderer/ui/FieldDefsForm.hx` | Definition form builder | Form controls for custom field definitions | adopt-candidate |
| `src/electron.renderer/ui/FieldInstancesForm.hx` | Instance form builder | Default-value collapse, reset buttons, required/error marking | adopt-candidate |
| `src/electron.renderer/ui/LastChance.hx` | Undo/last-chance banner | Temporary action banner with buttons and timed dismissal | adopt-candidate |
| `src/electron.renderer/ui/LevelInstanceForm.hx` | Level property form | Level settings form composition | background |
| `src/electron.renderer/ui/Modal.hx` | Modal base | Shared modal lifecycle, template loading, close stack | adopt-candidate |
| `src/electron.renderer/ui/NamePatternEditor.hx` | Pattern text editor | Inline pattern-edit helper | background |
| `src/electron.renderer/ui/Notification.hx` | Toast system | Severity taxonomy plus quick transient notification | adopt-candidate |
| `src/electron.renderer/ui/ProjectLoader.hx` | Project load flow | Progress/error load UI hooks | background |
| `src/electron.renderer/ui/ProjectSaver.hx` | Project save flow | Save status/backup UI hooks | background |
| `src/electron.renderer/ui/QuickSearch.hx` | Small search helper | Shared search interaction helper | adopt-candidate |
| `src/electron.renderer/ui/RulePatternEditor.hx` | Rule pattern editor | Auto-layer rule visual editing control | background |
| `src/electron.renderer/ui/TagEditor.hx` | Tag editor | Tag list/chip editing behavior | adopt-candidate |
| `src/electron.renderer/ui/Tileset.hx` | Tileset renderer | Tileset preview support | background |
| `src/electron.renderer/ui/Tip.hx` | Tooltip system | Attached tips, suppression/clear behavior | adopt-candidate |
| `src/electron.renderer/ui/ToolPalette.hx` | Tool palette base | Palette render/focus/popout lifecycle | adopt-candidate |
| `src/electron.renderer/ui/ValuePicker.hx` | Value picker helper | Generic value-pick interaction | background |
| `src/electron.renderer/ui/modal/ContextMenu.hx` | Context menu modal | Right-click, button-open, submenu, selected state, separators | adopt-candidate |
| `src/electron.renderer/ui/modal/DebugMenu.hx` | Debug menu | Developer/debug-only modal | not-ui |
| `src/electron.renderer/ui/modal/Dialog.hx` | Dialog base | Button bar, icon buttons, confirm/cancel/close contracts | adopt-candidate |
| `src/electron.renderer/ui/modal/MetaProgress.hx` | Aggregate progress modal | Background/progress aggregation | background |
| `src/electron.renderer/ui/modal/Panel.hx` | Side panel base | Singleton panels, close button, mask, linked button state | adopt-candidate |
| `src/electron.renderer/ui/modal/Progress.hx` | Progress modal | Progress operations display | background |
| `src/electron.renderer/ui/modal/ToolPalettePopOut.hx` | Palette popout modal | Detachable palette behavior | adopt-candidate |
| `src/electron.renderer/ui/modal/dialog/Changelog.hx` | Changelog dialog | Release-note modal | background |
| `src/electron.renderer/ui/modal/dialog/Choice.hx` | Choice dialog | Multi-choice prompt buttons | adopt-candidate |
| `src/electron.renderer/ui/modal/dialog/ColorPicker.hx` | Color picker dialog | Color picking flow | adopt-candidate |
| `src/electron.renderer/ui/modal/dialog/CommandRunner.hx` | Command runner dialog | Command execution prompt/result flow | background |
| `src/electron.renderer/ui/modal/dialog/Confirm.hx` | Confirmation dialog | Confirm/cancel action pattern | adopt-candidate |
| `src/electron.renderer/ui/modal/dialog/EditAppSettings.hx` | App settings dialog | Settings form modal | background |
| `src/electron.renderer/ui/modal/dialog/EnumSync.hx` | Enum sync dialog | Data-sync resolution UI | background |
| `src/electron.renderer/ui/modal/dialog/ExternalFileChanged.hx` | External change dialog | File change warning flow | background |
| `src/electron.renderer/ui/modal/dialog/InputDialog.hx` | Text input dialog | Inline validation and submit/cancel behavior | adopt-candidate |
| `src/electron.renderer/ui/modal/dialog/IntGridValuePicker.hx` | IntGrid value picker | Active value tiles and pick-to-close behavior | adopt-candidate |
| `src/electron.renderer/ui/modal/dialog/LockMessage.hx` | Lock message dialog | Lock/readonly notice | background |
| `src/electron.renderer/ui/modal/dialog/LogPrint.hx` | Log dialog | Short/full labels, severity styling | adopt-candidate |
| `src/electron.renderer/ui/modal/dialog/LostFile.hx` | Missing file dialog | Recovery choice flow | background |
| `src/electron.renderer/ui/modal/dialog/Message.hx` | Message dialog | Icon/error class variants | adopt-candidate |
| `src/electron.renderer/ui/modal/dialog/MoveEntitiesBetweenLayers.hx` | Move entities dialog | Required-state select validation | adopt-candidate |
| `src/electron.renderer/ui/modal/dialog/Retry.hx` | Retry dialog | Retry action prompt | background |
| `src/electron.renderer/ui/modal/dialog/RuleEditor.hx` | Rule editor dialog | Guided mode, palettes, active values, grid columns | adopt-candidate |
| `src/electron.renderer/ui/modal/dialog/RuleGroupRemap.hx` | Rule remap dialog | Remap chips, new value picker | background |
| `src/electron.renderer/ui/modal/dialog/RuleModuloEditor.hx` | Rule modulo editor | Reset/default classes and active grid cells | adopt-candidate |
| `src/electron.renderer/ui/modal/dialog/RulePerlinSettings.hx` | Rule settings dialog | Linked/reset fields | adopt-candidate |
| `src/electron.renderer/ui/modal/dialog/RuleRandomOffsets.hx` | Offset dialog | Reset/link buttons and icon class switching | adopt-candidate |
| `src/electron.renderer/ui/modal/dialog/RulesWizard.hx` | Rules wizard | Validation notifications, active grid fragments, empty/defined states | adopt-candidate |
| `src/electron.renderer/ui/modal/dialog/SelectPicker.hx` | Select replacement dialog | Search, keyboard focus, list/grid view persistence | adopt-candidate |
| `src/electron.renderer/ui/modal/dialog/TextEditor.hx` | Text editor dialog | CodeMirror/text edit modal | rejected |
| `src/electron.renderer/ui/modal/dialog/UnsavedChanges.hx` | Unsaved-change dialog | Save/discard/cancel flow | adopt-candidate |
| `src/electron.renderer/ui/modal/dialog/Warning.hx` | Warning dialog | Warning-specific dialog styling | adopt-candidate |
| `src/electron.renderer/ui/modal/panel/EditAllAutoLayerRules.hx` | Auto-layer rules panel | Domain-heavy rule editing surface | background |
| `src/electron.renderer/ui/modal/panel/EditEntityDefs.hx` | Entity definitions panel | Entity definition list/form editing | adopt-candidate |
| `src/electron.renderer/ui/modal/panel/EditEnumDefs.hx` | Enum definitions panel | Enum list/form editing | background |
| `src/electron.renderer/ui/modal/panel/EditLayerDefs.hx` | Layer definitions panel | Layer list/form editing | adopt-candidate |
| `src/electron.renderer/ui/modal/panel/EditLevelFieldDefs.hx` | Level field definitions panel | Level field form editing | background |
| `src/electron.renderer/ui/modal/panel/EditProject.hx` | Project settings panel | Collapsers, backup path, trusted/untrusted command controls | adopt-candidate |
| `src/electron.renderer/ui/modal/panel/EditTilesetDefs.hx` | Tileset definitions panel | Tileset list/form editing | background |
| `src/electron.renderer/ui/modal/panel/Help.hx` | Help panel | Help/changelog panel links | background |
| `src/electron.renderer/ui/modal/panel/LevelInstancePanel.hx` | Level instance panel | Level settings side panel | background |
| `src/electron.renderer/ui/modal/panel/WorldPanel.hx` | World panel | Toolbar buttons, layout state class, world/level forms | adopt-candidate |
| `src/electron.renderer/ui/palette/EntityPalette.hx` | Entity palette | Entity definition palette | adopt-candidate |
| `src/electron.renderer/ui/palette/IntGridPalette.hx` | IntGrid palette | Value palette with active/current color semantics | adopt-candidate |
| `src/electron.renderer/ui/palette/TilePalette.hx` | Tile palette | Scrollable tile palette and selected tile behavior | adopt-candidate |
| `src/electron.renderer/ui/ts/TileTagger.hx` | Tileset tagger | Active tag/value tiles and tag editing controls | adopt-candidate |
| `src/electron.renderer/ui/ts/TileToolPicker.hx` | Tileset tool picker | Tool buttons for tileset-local operations | background |
| `src/electron.renderer/ui/vp/EntityRefPicker.hx` | Viewport entity reference picker | Pick-in-viewport flow | adopt-candidate |
| `src/electron.renderer/ui/vp/LevelSpotPicker.hx` | Viewport level spot picker | Pick-in-viewport flow | adopt-candidate |

## UI Pattern Catalogue

Haxe-derived adopted pattern count after Plan 02-02: 14.

### HAXE-01: Semantic Main-Panel Launcher Buttons

Evidence: `C:\Programming_Files\ldtk-master\src\electron.renderer\page\Editor.hx:173-212`.

LDtk wires visible top-level buttons (`editProject`, `world`, `editLevelInstance`, `editLayers`, `editEntities`, `editTilesets`, `editEnums`, help, settings) to app commands instead of burying primary editing surfaces in generic menus. This is useful for NeoCade's future showcase/editor demo because it argues for clear icon-button affordances around major surfaces rather than decorative chrome.

Anti-cyberpunk filter: The pattern is command clarity, not sci-fi ornament; it can remain arcade-friendly with ordinary labels/icons and no glow language.

Inspiration sketch - Phase 3 mockup or Phase 5+ designer's call. Treat showcase navigation and tool-surface launchers as compact semantic icon buttons with obvious active/focus states.

### HAXE-02: Singleton Side Panels With Linked Button State

Evidence: `C:\Programming_Files\ldtk-master\src\electron.renderer\page\Editor.hx:849-883`; `C:\Programming_Files\ldtk-master\src\electron.renderer\ui\modal\Panel.hx:12-24`; `C:\Programming_Files\ldtk-master\src\electron.renderer\ui\modal\Panel.hx:81-94`.

LDtk opens each large editor panel as a singleton: pressing an already-open panel command closes all panels, while `Panel.linkToButton` marks the launching button active and fades its button group. The portable lesson is that active panel triggers should never be ambiguous.

Anti-cyberpunk filter: Active/linked state is plain UI feedback, not neon-noir drama.

Inspiration sketch - Phase 3 mockup or Phase 5+ designer's call. Panel launch buttons in showcase scaffolds should expose active, hover, focus, disabled, and faded-group states explicitly.

### HAXE-03: Persistent Banners For Blocking Context

Evidence: `C:\Programming_Files\ldtk-master\src\electron.renderer\page\Editor.hx:229-280`.

LDtk separates persistent notifications such as backup/tutoral context from transient toasts by assigning stable notification IDs and replacing/removing them as state changes. This is useful for NeoCade because theme samples need both transient and persistent status surfaces; persistent warnings should not visually compete with ordinary notifications.

Anti-cyberpunk filter: The pattern is information hierarchy and stable placement; no dystopian alert styling is implied.

Inspiration sketch - Phase 3 mockup or Phase 5+ designer's call. Reserve a calm but unmistakable banner style for persistent editor/runtime status messages.

### HAXE-04: Focus-Trapped Command Palette With Context Rows

Evidence: `C:\Programming_Files\ldtk-master\src\electron.renderer\page\Editor.hx:645-649`; `C:\Programming_Files\ldtk-master\src\electron.renderer\ui\CommandPalette.hx:43-72`; `C:\Programming_Files\ldtk-master\src\electron.renderer\ui\CommandPalette.hx:236-327`.

LDtk's command palette traps focus in a search input, closes on mask/Escape, filters cached keywords, and renders rows with icon, short description, optional context, category class, and active row. The portable lesson is that search surfaces need dense scannable result rows plus obvious current selection.

Anti-cyberpunk filter: Search and command rows are productivity UI; avoid terminal/console styling and it stays on-brief.

Inspiration sketch - Phase 3 mockup or Phase 5+ designer's call. NeoCade dropdowns/popups should have a polished selected-row/focus language that still works with keyboard navigation.

### HAXE-05: Context Menus With Button, Right-Click, Keyboard-Like Alternatives, And Selected Items

Evidence: `C:\Programming_Files\ldtk-master\src\electron.renderer\ui\modal\ContextMenu.hx:104-135`; `C:\Programming_Files\ldtk-master\src\electron.renderer\ui\modal\ContextMenu.hx:168-218`; `C:\Programming_Files\ldtk-master\src\electron.renderer\page\Editor.hx:2823-2844`.

LDtk can attach a visible context button, native contextmenu event, macOS Ctrl-click emulation, separators, selected ticks, icons, submenu state, and per-action show predicates. Layer-list actions reuse the same mechanism for visibility/rules/settings. The portable lesson is that secondary actions should be discoverable both visibly and contextually.

Anti-cyberpunk filter: Context-menu discoverability is conventional app polish; keep icons flat and labels direct.

Inspiration sketch - Phase 3 mockup or Phase 5+ designer's call. Godot `PopupMenu`, `MenuButton`, and item-list demos should include separators, checked/selected rows, disabled rows, and icon-bearing actions.

### HAXE-06: Select Replacement With Search, Grid/List Mode, And Keyboard Focus

Evidence: `C:\Programming_Files\ldtk-master\src\electron.renderer\ui\modal\dialog\SelectPicker.hx:15-93`; `C:\Programming_Files\ldtk-master\src\electron.renderer\ui\modal\dialog\SelectPicker.hx:139-167`; `C:\Programming_Files\ldtk-master\src\electron.renderer\ui\modal\dialog\SelectPicker.hx:215-245`.

LDtk expands dense select choices into a modal picker with selected/disabled/default/null classes, optional image grid, persistent search focus, arrow/Page key navigation, Enter/Escape actions, and grid/list toggling. The portable lesson is that option-heavy Godot controls need state differentiation that remains readable in both compact and expanded layouts.

Anti-cyberpunk filter: List/grid toggling is neutral interaction design, not arcade spectacle.

Inspiration sketch - Phase 3 mockup or Phase 5+ designer's call. Theme `OptionButton`, `PopupMenu`, `ItemList`, and `Tree` demos should prove selected, disabled, default, focus, and dense-grid states.

### HAXE-07: Tool Palette Focus And Popout Lifecycle

Evidence: `C:\Programming_Files\ldtk-master\src\electron.renderer\Tool.hx:314-363`; `C:\Programming_Files\ldtk-master\src\electron.renderer\ui\ToolPalette.hx:21-53`; `C:\Programming_Files\ldtk-master\src\electron.renderer\ui\ToolPalette.hx:79-93`.

LDtk tools recreate palette content on activation, focus the current selection, cancel auto-scroll on user wheel/mousedown, and pop out oversized palettes through a placeholder and modal handoff. The portable lesson is to design palette/list states for selected item, scroll target, popout/expanded state, and tool deactivation.

Anti-cyberpunk filter: Palette ergonomics are workbench-like; no cyber terminal metaphor is needed.

Inspiration sketch - Phase 3 mockup or Phase 5+ designer's call. NeoCade samples should include long tool/value palettes and an expanded popup state so scrollbars and selected rows are validated.

### HAXE-08: Explicit Active And Unsupported Option Classes

Evidence: `C:\Programming_Files\ldtk-master\src\electron.renderer\page\Editor.hx:1521-1568`.

LDtk clears stale state, reapplies `active`, and separately applies `unsupported` when a toggle is not meaningful for the current layer. This is valuable because NeoCade must distinguish disabled, unsupported, selected, checked, and focus-composite states instead of flattening them into one gray state.

Anti-cyberpunk filter: State semantics are accessibility work, not visual genre work.

Inspiration sketch - Phase 3 mockup or Phase 5+ designer's call. Define visual differences among disabled, unchecked, checked, active, unsupported, hover, focus, and checked-focus states in token work.

### HAXE-09: Layer List Rows Combine Filter, Active State, Type Icon, Documentation Tip, Visibility Gesture, And Context Actions

Evidence: `C:\Programming_Files\ldtk-master\src\electron.renderer\page\Editor.hx:2670-2844`.

LDtk builds layer-list rows from data, adds tag filter controls, active row class, hidden-list class, custom color, type icon, doc tooltip, shortcut labels, visibility gestures, and context actions. The portable lesson is that dense lists benefit from multiple lightweight affordances rather than one oversized row style.

Anti-cyberpunk filter: Dense app-list readability supports professional arcade-tool polish and avoids spectacle.

Inspiration sketch - Phase 3 mockup or Phase 5+ designer's call. `Tree` and `ItemList` demos should show icons, active row, hidden/disabled row, color swatch/role marker, tooltip affordance, and right-click actions.

### HAXE-10: Default-Value Collapse And Reset Affordances

Evidence: `C:\Programming_Files\ldtk-master\src\electron.renderer\ui\FieldInstancesForm.hx:43-121`.

LDtk marks defaulted fields with `usingDefault`, hides or wraps the real input, provides a readable default/required replacement, and adds a transparent reset icon button next to editable values. This maps well to Godot form controls because reset/default affordances are easy to under-theme until real forms expose them.

Anti-cyberpunk filter: Reset/default states are ordinary form usability; no genre drift.

Inspiration sketch - Phase 3 mockup or Phase 5+ designer's call. Showcase form rows should include required/error, defaulted, resettable, readonly, and disabled variants.

### HAXE-11: Dialog Base Provides Button Taxonomy

Evidence: `C:\Programming_Files\ldtk-master\src\electron.renderer\ui\modal\Dialog.hx:66-113`.

LDtk centralizes dialog buttons into ordinary text buttons, icon buttons, confirm, cancel, and close helpers. The portable lesson is that dialog surfaces need consistent confirm/cancel/destructive/close treatment rather than ad hoc per-dialog styling.

Anti-cyberpunk filter: Button taxonomy is neutral and professional.

Inspiration sketch - Phase 3 mockup or Phase 5+ designer's call. Godot `AcceptDialog`, `ConfirmationDialog`, `Window`, and `PopupPanel` demos should include confirm/cancel/close/icon-button states.

### HAXE-12: Notification Severity And Quick Toast Split

Evidence: `C:\Programming_Files\ldtk-master\src\electron.renderer\ui\Notification.hx:54-121`.

LDtk separates `msg`, `success`, `copied`, `warning`, `appUpdate`, `error`, `debug`, and `quick` flows. Quick notifications remove any prior quick toast before showing the next one, while full notifications can have title/subtext and blink/latest classes. The portable lesson is to reserve visual intensity by severity and duration.

Anti-cyberpunk filter: Severity styling should be readable and friendly, not alarmist or neon warning-console coded.

Inspiration sketch - Phase 3 mockup or Phase 5+ designer's call. Define status/notification samples for info, success, warning, danger, copied, and quick transient states.

### HAXE-13: Semantic Cursor Feedback For Viewport Tools

Evidence: `C:\Programming_Files\ldtk-master\src\electron.renderer\ui\Cursor.hx:42-78`; `C:\Programming_Files\ldtk-master\src\electron.renderer\ui\Cursor.hx:154-189`; `C:\Programming_Files\ldtk-master\src\electron.renderer\tool\SelectionTool.hx:156-214`.

LDtk distinguishes cursor intent: none, pointer, grid cell, grid rectangle, moving/move, entity, tile stack, pick-nothing, and native grab/resize. The portable lesson for NeoCade is not to implement LDtk's viewport cursors in a Theme, but to make cursor-adjacent feedback such as focus rings, drag targets, and selected outlines legible.

Anti-cyberpunk filter: Semantic feedback stays practical; avoid glowing targeting reticles or sci-fi HUD language.

Inspiration sketch - Phase 3 mockup or Phase 5+ designer's call. Drag/drop and selection demos should prove selected outline, drag hover, invalid-drop, resize, and pickable states.

### HAXE-14: Tool-Specific Invalid And Preview States

Evidence: `C:\Programming_Files\ldtk-master\src\electron.renderer\Tool.hx:285-297`; `C:\Programming_Files\ldtk-master\src\electron.renderer\tool\lt\TileTool.hx:319-339`; `C:\Programming_Files\ldtk-master\src\electron.renderer\tool\lt\EntityTool.hx:91-116`; `C:\Programming_Files\ldtk-master\src\electron.renderer\tool\PanView.hx:20-24`.

LDtk changes feedback based on what the current tool can do: forbidden cursor when editing is invalid, grid/tile/entity preview when valid, and body-level `panning` class during pan mode. The portable lesson is that invalid, active, and in-progress states need first-class styling in controls that represent tools.

Anti-cyberpunk filter: Invalid/preview states can be crisp and tactile without becoming HUD graphics.

Inspiration sketch - Phase 3 mockup or Phase 5+ designer's call. Tool buttons and palette cells should include invalid/unsupported, active, pressed, and in-progress treatment.

## SCSS Chrome and Interaction Conventions

Reserved for Plan 02-03.

## Rejected Patterns

Haxe-derived rejected pattern count after Plan 02-02: 6. Later Phase 2 plans may append additional SCSS/asset/claim rejections below these.

### HAXE-R01: Copying LDtk's jQuery/Class-Mutation Implementation Model

Evidence: `C:\Programming_Files\ldtk-master\src\electron.renderer\page\Editor.hx:1521-1568`; `C:\Programming_Files\ldtk-master\src\electron.renderer\ui\FieldInstancesForm.hx:43-121`.

Rejected because NeoCade is a Godot Theme resource, not an app-specific DOM runtime. The states are useful, but the mechanism (`addClass`, `removeClass`, event handlers) belongs to LDtk's Electron/Haxe stack and cannot become a theme implementation pattern.

Rejection basis: Godot Theme limitation and copying risk.

### HAXE-R02: Scripting Panel Singleton Behavior Into Theme Requirements

Evidence: `C:\Programming_Files\ldtk-master\src\electron.renderer\page\Editor.hx:849-883`; `C:\Programming_Files\ldtk-master\src\electron.renderer\ui\modal\Panel.hx:12-24`.

Rejected as an implementation requirement. NeoCade can style panels, windows, popups, close buttons, masks, and active buttons, but opening/closing singleton panels is application logic outside `.tres` scope.

Rejection basis: Godot Theme limitation and phase scope.

### HAXE-R03: Porting Heaps Viewport Cursor Rendering As Theme Chrome

Evidence: `C:\Programming_Files\ldtk-master\src\electron.renderer\ui\Cursor.hx:140-189`; `C:\Programming_Files\ldtk-master\src\electron.renderer\tool\SelectionTool.hx:156-214`.

Rejected for direct adoption. LDtk's cursor graphics are canvas/viewport overlays, not reusable Godot Control theme assets. NeoCade should learn from the state taxonomy, not ship LDtk-like cursor drawings.

Rejection basis: Godot Theme limitation and copying risk.

### HAXE-R04: Treating Tool-Palette Popout Behavior As A Theme Feature

Evidence: `C:\Programming_Files\ldtk-master\src\electron.renderer\Tool.hx:346-351`; `C:\Programming_Files\ldtk-master\src\electron.renderer\ui\ToolPalette.hx:79-93`.

Rejected as a Theme deliverable. Popout/placeholder behavior is app layout logic. NeoCade can theme `PopupPanel`, `ScrollContainer`, selected rows, and palette cells so an app can implement this pattern, but the behavior itself is not part of v1.

Rejection basis: Godot Theme limitation and phase scope.

### HAXE-R05: LDtk Content-Domain Colors As Theme Semantic Roles

Evidence: `C:\Programming_Files\ldtk-master\src\electron.renderer\page\Editor.hx:2741-2756`; `C:\Programming_Files\ldtk-master\src\electron.renderer\tool\lt\IntGridTool.hx:42-46`.

Rejected for direct theme semantics. LDtk applies layer/int-grid/entity colors from project content data; NeoCade is a general Control theme and must not bake content-domain colors into reusable UI roles.

Rejection basis: phase scope and copying risk.

### HAXE-R06: CodeMirror/Text-Editor Modal Styling As A v1 Theme Target

Evidence: `C:\Programming_Files\ldtk-master\src\electron.renderer\ui\modal\dialog\TextEditor.hx:11-38`; `C:\Programming_Files\ldtk-master\src\electron.renderer\ui\modal\dialog\TextEditor.hx:110-177`.

Rejected for v1. Code editor theming is outside the 35 user-facing Godot Control coverage matrix and would drag NeoCade into app/plugin-specific editor surfaces. TextEdit/LineEdit states remain in scope; a full code-editor style is not.

Rejection basis: phase scope.

## CHANGELOG Lessons Learned

Reserved for Plan 02-04.

## Asset Inventory

Reserved for Plan 02-04.

## Prior Research Report Claim Verification

Reserved for Plan 02-04.

## Anti-Cyberpunk Filter Audit

Reserved for Plan 02-05.

## Open Questions

Reserved for Plan 02-05.

## Phase 2 Verification Log

Reserved for Plan 02-05.
