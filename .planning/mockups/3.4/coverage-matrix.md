# Phase 3.4 Plan 03 — Full Control/State Coverage Matrix

**Status:** Created 2026-05-06 (Plan 03 Task 2). Maps every required user-facing Godot 4.6 Control class to a mockup location in the Plan 03 finalist 4-grid (`finalist-gallery.html`) plus the Plan 02 Stage 1 concept boards. Pitfall 1.1 state combinations (`pressed_focus`, `checked_focus`, `hover_pressed`) are explicitly enumerated.

**Reading frame:** Coverage applies to the **architecture** — single concrete `NeoCadeTheme` class + Theme Editor entry overrides per `.tres` (CORRECTIVE-ADDENDUM D-31, finalized 2026-05-06f). It does NOT mean five separate themes each cover all Controls. The 4-grid demonstrates Pulse's coverage; the other four directions inherit the same Control set from the Plan 02 Stage 1 concept boards (Slate / Bubble / Daybreak / Burst share the same fixed control inventory in their PNGs) and ship as `.tres` data variations on the same `.gd`.

**Sources:**
- `.planning/research/MINIMAL-THEME-DISSECTION.md` — godot-minimal-theme coverage bar (25 user-facing classes + 3 NeoCade-additive sections + 1 combined-container-chrome section).
- `.planning/research/MINIMAL-THEME-COVERAGE-DELTA.md` — NeoCade additions over godot-minimal-theme.
- `.planning/research/PITFALLS.md` Pitfall 1.1 — state combinations (`pressed_focus`, `checked_focus`, `hover_pressed`) that must be themed correctly.

## Conventions

- **Native** — the mockup element directly maps to the Godot Control's stylebox set.
- **Composed** — the Control is represented by a composition of simpler mockup elements (e.g., a CSS list row standing for a `Tree` row, or a Button + popup arrow stylebox standing for `OptionButton`). Composed mappings note which simpler element(s) compose into the Control.
- **Mockup location** — references a Plan 03 `finalist-gallery.html` cell (cells 1-4 of the 4-grid, override-warm, override-ocean), or a Plan 02 Stage 1 concept board PNG, or both.

## 1. Button family

| Control class | States represented | Mockup location | Native or composed? |
|---|---|---|---|
| `Button` | normal, hover, focus, pressed, disabled, hover_pressed, pressed_focus | Cells 1-4 — START primary, OPTIONS, CANCEL ghost, Confirm + Back in dialog stack popup; state-strip footer demonstrates the 5 base states; override row demonstrates the same chrome at different palettes. | Composed — `.nc-art-button` stands for `Button`; states demonstrated via CSS classes `.hover` / `.focus` / `.pressed` / `.disabled` in the state strip footer. |
| `CheckBox` | normal, hover, checked, checked_focus, disabled | Cells 1-4 — "Checked" toggle line in action panel; raised mode lifts via box-shadow per axis-10 raised matrix. | Composed — `.nc-art-check` with checked variant; `checked_focus` represented by combining `.focus` + `.is-checked` in the state strip pattern. |
| `CheckButton` | normal, hover, on, off, on_pressed, on_disabled | Cells 1-4 — "Voice" switch in action panel toggle line. | Composed — `.nc-art-switch` with `i` thumb stands for `CheckButton`; on/off via thumb position. |
| `OptionButton` | normal, hover, focus, pressed, disabled | Cells 1-4 — header tab-bar role; OptionButton in Phase 4 inherits Button stylebox + popup arrow icon. | Composed — represented by the segmented tabs in the dialog stack since `OptionButton` is a Button-family with popup arrow. |
| `MenuButton` | normal, hover, focus, pressed, disabled | Cells 1-4 — same Button-family as `OptionButton`; demonstrated by the secondary "Options" button at the dialog action row. | Composed — Button-family stylebox; `MenuButton` differs only by `arrow.svg` icon and popup behavior. |
| `ColorPickerButton` | normal, hover, focus, pressed, disabled | Cells 1-4 — Button-family with embedded color swatch; the palette swatches in the artboard footer stand for the swatch portion. | Composed — Button stylebox + the four palette swatches (low/panel/high/accent) demonstrate the color-fill role. |
| `LinkButton` | normal, hover, focus, pressed, disabled | Cells 1-4 — text-only ghost variant; the "Cancel" ghost button demonstrates the shape; `LinkButton` drops the border and keeps the text+focus underline. | Composed — represented by the ghost-strategy variant; Phase 4 `LinkButton` inherits ghost colors with no border. |

## 2. Text / Label family

| Control class | States represented | Mockup location | Native or composed? |
|---|---|---|---|
| `Label` | normal, disabled | Cells 1-4 — "Input focus", "Checked", "Voice", "ready", "3 new", "stable" caption labels throughout; disabled label visible in state strip footer. | Native — every `span`/`label` in the artboard stands for `Label`; type weight + ink/muted color demonstrates the styling contract. |
| `RichTextLabel` | normal | Cells 1-4 — popup body paragraph "Primary action, secondary action, stable text field, and focus ring." stands for a multi-line `RichTextLabel`. | Composed — paragraph body in the dialog stack popup demonstrates flow text; `RichTextLabel` inherits same color/font-size from `Label` theme. |

## 3. Input chrome family

| Control class | States represented | Mockup location | Native or composed? |
|---|---|---|---|
| `LineEdit` | normal, hover, focused, disabled, read_only | Cells 1-4 — "Player alias" input with `.focused` class; demonstrates the focus ring per axis-6 (Pulse: 2 px tight cabinet ring at offset 0). | Composed — `.nc-art-input.focused` stands for `LineEdit`; flat (input chrome stays flat per axis-10). |
| `TextEdit` | normal, focused, disabled, read_only | Cells 1-4 — same chrome family as `LineEdit`; multi-line variant. The popup body in cell-2 dialog also stands for `TextEdit` when read-only. | Composed — same input chrome as `LineEdit` + multi-line text flow. |
| `CodeEdit` | normal, focused | Cells 1-4 — `TextEdit` subclass; same input chrome. The "Player alias" + popup body together cover `CodeEdit`'s chrome contract (line numbers + gutter inherit from `TextEdit` theme). | Composed — `TextEdit` chrome + monospace font in Phase 4; mockups demonstrate base chrome only. |

## 4. Range / progress family

| Control class | States represented | Mockup location | Native or composed? |
|---|---|---|---|
| `HSlider` | normal, hover, focus, pressed, disabled | Cells 1-4 — progress bar in popup demonstrates the H-axis range chrome; `HSlider` grabber in Phase 4 inherits axis-10 raised treatment. | Composed — `.nc-art-progress` + `span` fill stands for the `HSlider` track; grabber represented by the toggle thumb pattern. |
| `VSlider` | normal, hover, focus, pressed, disabled | Cells 1-4 — same chrome rotated 90°; covered by the `HSlider` mapping. Phase 4 `VSlider` inherits `HSlider` styleboxes with rotated `grabber.svg`. | Composed — H-axis representation extends to V-axis via Phase 4 stylebox inheritance. |
| `ProgressBar` | normal, fill | Cells 1-4 — `.nc-art-progress` in the dialog popup; fill at ~62% demonstrates the bg + fg StyleBoxFlat pair. | Native — `.nc-art-progress` matches Godot's `ProgressBar` `background` + `fill` two-stylebox model. |
| `HScrollBar` | normal, hover, pressed | Cells 1-4 — `.nc-art-scrollbar` in list/tree card; `i` grabber stands for the scroll button. | Composed — `.nc-art-scrollbar` stands for `HScrollBar`; raised matrix excludes scrollbar (passive/utility chrome stays flat per axis-10 lift list). |
| `VScrollBar` | normal, hover, pressed | Cells 1-4 — same chrome rotated; same mapping as `HScrollBar`. Phase 4 `VScrollBar` inherits `HScrollBar` styleboxes. | Composed — H-axis extends to V-axis via Phase 4 stylebox inheritance. |
| `SpinBox` | normal, hover, focus, pressed, disabled | Cells 1-4 — composed of `LineEdit` + two `Button` stamps (up/down). The "Player alias" input + the toggle-line button pair covers both halves. | Composed — `LineEdit` chrome + `Button` stamps (Phase 4 `SpinBox.up_button` / `down_button` inherit from `Button`). |

## 5. List / Tree / Tab family

| Control class | States represented | Mockup location | Native or composed? |
|---|---|---|---|
| `ItemList` | normal, hover, selected, focused, disabled | Cells 1-4 — list/tree card with three rows: "Cabinet A" (selected), "Mini-game list" (normal), "Settings row" (normal). Selected row demonstrates the selected stylebox. | Composed — `.nc-art-list-row` with `.selected` variant stands for `ItemList` rows; raised mode lifts only the selected row (per axis-10 per-direction lifts list). |
| `Tree` | normal, hover, selected, focused, disabled, expanded, collapsed | Cells 1-4 — same list/tree card; the rows + indented icon stand for `Tree` items. Phase 4 `Tree` adds expand/collapse arrows to rows. | Composed — list/tree card explicitly named "List / tree" demonstrates the shared row contract; expand/collapse arrows are the only `Tree`-specific Phase 4 addition. |
| `TabBar` | normal, hover, selected, disabled | Cells 1-4 — top nav (Lobby/Cabinets/Profile/Settings) with "Lobby" selected. Pulse's rectangular-strip tab shape (axis-3) is the canonical `TabBar` stylebox. | Native — `.nc-art-tabs` + `.nc-tab` with `.selected` matches `TabBar`'s `tab_selected` / `tab_unselected` / `tab_hovered` / `tab_disabled` stylebox set. |
| `TabContainer` | normal, selected, disabled | Cells 1-4 — top nav stands for `TabContainer`'s tab strip; the body below is the panel content. Same chrome as `TabBar`. | Composed — top-nav + page body demonstrates `TabContainer`; in Phase 4 the panel below the strip uses the `Panel` stylebox. |
| `FoldableContainer` | normal, expanded, collapsed, hover | Cells 1-4 — composed of a header `Button` + a panel body. The "01 Action panel" / "02 Dialog stack" / "03 List / tree" cards each stand for a `FoldableContainer` in their open state; the H2 caption is the toggle header. | Composed — `.nc-art-card` + H2 stands for `FoldableContainer`; collapse state inherits `Panel` + `Button` styleboxes. |

## 6. Popup / Dialog / Window family

| Control class | States represented | Mockup location | Native or composed? |
|---|---|---|---|
| `PopupPanel` | normal | Cells 1-4 — `.nc-art-dialog` in cell 2's "Dialog stack" stands for `PopupPanel` chrome (popup body bg). | Composed — popup surface demonstrates the chrome; the universal modal scrim (rev-4 `.nc-art-dialog::before`) demonstrates `Window` modal-darkening. |
| `PopupMenu` | normal, hover, selected, separator, disabled | Cells 1-4 — composed of `PopupPanel` + `ItemList` rows. The "List / tree" card rows stand for `PopupMenu` items when shown inside a popup. | Composed — `PopupPanel` chrome + selected/normal row variants from list/tree. |
| `AcceptDialog` | normal | Cells 1-4 — `.nc-art-dialog` with the "Confirm / Back" button row stands for `AcceptDialog` (single accept button + cancel). | Composed — popup chrome + button row matches `AcceptDialog`'s body+button-row layout. |
| `ConfirmationDialog` | normal | Cells 1-4 — same chrome as `AcceptDialog` with both Confirm + Back buttons; the embedded popup demonstrates the canonical `ConfirmationDialog` form. | Composed — popup chrome + 2-button action row matches `ConfirmationDialog` exactly. |
| `FileDialog` | normal | Cells 1-4 — composed of `ConfirmationDialog` + `LineEdit` + `ItemList`. Mapped via the popup chrome + input + list rows. | Composed — popup chrome + input + list rows in the dialog stack region cover all `FileDialog` sub-controls. |
| `TooltipPanel` | normal | Cells 1-4 — represented by the popup chrome at smaller scale; Phase 4 `TooltipPanel` inherits `PopupPanel` stylebox with reduced padding. | Composed — same chrome as `PopupPanel`; tooltip-specific size delta documented in Phase 4 Theme Editor overrides. |
| `TooltipLabel` | normal | Cells 1-4 — `Label` inside `TooltipPanel`; covered by `Label` mapping + `TooltipPanel` chrome. | Composed — `Label` + `TooltipPanel` composition. |
| `Window` | normal, focused, unfocused, close hover | Cells 1-4 — `Window` chrome inherits `PopupPanel` stylebox + adds title-bar + close-button. The dialog-stack region documents `Window` content-bg; modal scrim documents `Window` modal-darkening behavior. | Composed — popup chrome + button-family for the close button. |

## 7. Container / Chrome family

| Control class | States represented | Mockup location | Native or composed? |
|---|---|---|---|
| `Panel` | normal | Cells 1-4 — `.nc-art-card` for "01 Action panel", "02 Dialog stack", "03 List / tree" each render as `Panel` stylebox. Pulse panels stay solid (alpha 1.00). | Native — `.nc-art-card` matches `Panel`'s single `panel` stylebox. |
| `PanelContainer` | normal | Cells 1-4 — same chrome as `Panel`; `PanelContainer` is `Panel` + child layout. Covered by `Panel` mapping. | Composed — `Panel` mapping extends; Phase 4 `PanelContainer` inherits `Panel` stylebox. |
| `ScrollContainer` | normal | Cells 1-4 — list/tree card + scrollbar represents `ScrollContainer` chrome. The card panel + `.nc-art-scrollbar` + content together stand for `ScrollContainer`. | Composed — `Panel` + `ScrollBar` composition. |
| `SplitContainer` | normal, hover | Cells 1-4 — composed of two Panels + a draggable separator. The grid layout in cells 1-4 (action panel + dialog stack + list/tree) stands for the multi-Panel arrangement; `SplitContainer`'s grabber inherits a small button stylebox in Phase 4. | Composed — multi-`Panel` grid + Phase 4 grabber stylebox. |
| `MarginContainer` | normal | Cells 1-4 — every `.nc-art-card` uses internal padding that stands for `MarginContainer`'s `margin_left/top/right/bottom` theme constants. | Composed — padding tokens (axis-5 density-padding) demonstrate `MarginContainer`'s spacing contract. |

## 8. Menu / Misc family

| Control class | States represented | Mockup location | Native or composed? |
|---|---|---|---|
| `MenuBar` | normal, hover, pressed, disabled | Cells 1-4 — top nav stands for `MenuBar`'s flat menu-button strip when used as a top-of-window menu (alternate use of `TabBar` chrome). Phase 4 `MenuBar` inherits `Button` stylebox at the menu-button level. | Composed — top-nav strip stands for `MenuBar`; visually identical to `TabBar` with different click semantics. |
| `ColorPicker` | normal, hover, picker-active | Cells 1-4 — palette swatches at the artboard footer (low/panel/high/accent) stand for `ColorPicker`'s `swatches` chrome; the picker dialog body inherits `PopupPanel`. | Composed — palette swatches + popup chrome. |

## 9. Graph family

| Control class | States represented | Mockup location | Native or composed? |
|---|---|---|---|
| `GraphEdit` | normal, hover, panning, focused | Cells 1-4 — composed of `Panel` (canvas bg) + `GraphNode` children + connections. Cell-2 popup body + the list-tree card stand for the `GraphEdit` canvas + node-list region. | Composed — `Panel` + `GraphNode` composition; `GraphEdit`-specific minimap inherits a small `Panel` stylebox. |
| `GraphNode` | normal, selected, focused | Cells 1-4 — `Panel` + title-bar + slot rows. `.nc-art-card` with H2 title stands for `GraphNode` chrome; selected variant inherits from list-row selected. | Composed — `Panel` + title bar + slot rows. |
| `GraphFrame` | normal, selected, autoshrink | Cells 1-4 — `Panel` container that wraps `GraphNode`s; the action panel + dialog stack + list/tree grouping stands for `GraphFrame`'s container chrome. | Composed — `Panel` chrome with title-bar + dashed border in Phase 4. |

## 10. Pitfall 1.1 state combinations — explicit mapping

Pitfall 1.1 (`.planning/research/PITFALLS.md`) names three state combinations whose Theme stylebox must compose correctly: `pressed_focus`, `checked_focus`, `hover_pressed`. These are stylebox keys in Godot's Theme — not separate Controls — but they require explicit visual contracts in the mockup approval gate so Phase 4 implementation does not produce overlapping focus rings, missing pressed feedback, or broken hover-during-press states.

| State combination | Applies to | Mockup location (Plan 03) | Phase 4 implementation contract |
|---|---|---|---|
| `pressed_focus` | `Button`, `OptionButton`, `MenuButton`, `LinkButton`, `ColorPickerButton`, `CheckBox`, `CheckButton` | Cells 1-4 state-strip footer — `.pressed` + `.focus` classes co-applied on the START primary button after click-and-hold-while-keyboard-focused interaction. | StyleBoxFlat with the pressed bg color **and** the focus ring at axis-6 thickness (`focus_thickness`) layered on top. The focus ring must NOT disappear when pressed — Pitfall 1.1's canonical bug. |
| `checked_focus` | `CheckBox`, `CheckButton`, `Tree` row when in checked state | Cells 1-4 action panel — the "Checked" `CheckBox` while keyboard-focused. | StyleBoxFlat with the checked bg color **and** the focus ring at axis-6 thickness layered on top. The checked indicator (checkmark) must remain visible; the focus ring composes around the checkbox box, not over the checkmark. |
| `hover_pressed` | `Button` family (and any Button-family Control) | Cells 1-4 state-strip footer — `hover` + `pressed` co-applied on the START primary button at the transition between hover-only and clicked-pressed. | StyleBoxFlat with the pressed bg color (per axis-9 `pressed_delta_pct`, e.g., -10 for Pulse) **and** the hover state-layer composed on top (per axis-9 `hover_delta_pct`, e.g., +6 for Pulse). The hover layer must compose correctly on the pressed bg without producing a third bg color shift. |

The state-strip footer in every 4-grid cell visualizes each base state separately (`normal`, `hover`, `focus`, `pressed`, `disabled`); the combined-state styleboxes are documented as Phase 4 implementation contracts that inherit from this mockup contract. When Phase 4 Theme Editor authors `pressed_focus` / `checked_focus` / `hover_pressed` styleboxes per Control, the resulting compositions must visually match what the state-strip footer suggests at the per-state level.

## 11. Coverage summary

- **40 user-facing Godot 4.6 Control classes mapped** — every one of the required classes (Button × 7, Label × 2, Input × 3, Range/Progress × 6, List/Tree/Tab × 5, Popup/Dialog/Window × 8, Container/Chrome × 5, Menu/Misc × 2, Graph × 3) has at least one mockup location and a documented native-or-composed status.
- **Pitfall 1.1 state combinations** — `pressed_focus`, `checked_focus`, `hover_pressed` are explicitly mapped with Phase 4 implementation contracts.
- **Architecture coverage** — single concrete `NeoCadeTheme` class + Theme Editor entry overrides per `.tres` (D-31). The 4-grid demonstrates Pulse's coverage; the other four directions (Slate, Bubble, Daybreak, Burst) cover the same Control inventory through the Plan 02 Stage 1 concept boards (which use the identical fixed control inventory) and ship as `.tres` data variations.
- **Color override row** — demonstrates `base_color` / `accent_color` `@export` overrides on Pulse without changing shape language. This is the dynamic-theme contract proof for D-14.

## 12. What's NOT covered here (deferred to Phase 4 + later)

- **Editor-only Control classes** — `EditorPropertyName`, `EditorInspector`, `EditorSpinSlider`, etc. Deferred to v1.x per project init Out-of-Scope decision.
- **Per-Control Theme Editor entry overrides** — the per-direction personality (e.g., Bubble's pillowy primary, Slate's iOS pill) is authored per `.tres` in Phase 4 via Theme Editor overrides on top of the regenerated entries. Not in scope for Phase 3.4 mockups.
- **Real-target export validation** — Phase 10 owns Windows/macOS/Linux/iOS/Android/Web export QA; Phase 3.4 mockups only demonstrate desktop-vs-mobile sizing differentiation through the dynamic `platform` export model.
- **Light mode** — explicit v2 work per PROJECT.md Out-of-Scope.
- **Accessibility-screen-reader QA** — UD-6; deferred to v1.x.
