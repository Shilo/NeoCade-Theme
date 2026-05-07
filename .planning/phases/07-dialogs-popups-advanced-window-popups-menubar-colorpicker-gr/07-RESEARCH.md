# Phase 07: Dialogs, Popups, Advanced - Research

**Researched:** 2026-05-07  
**Domain:** Godot 4.6.2 Theme entry authoring for Window, popup/dialog classes, MenuBar, PopupMenu, FileDialog, ColorPicker, ColorPickerButton, GraphEdit, GraphNode, and GraphFrame.  
**Confidence:** HIGH for local Godot 4.6.2 slot names and NeoCade architecture; MEDIUM for final visual constants because execution can tune exact recipes inside locked decisions.

<user_constraints>
## User Constraints

Phase 7 context is authoritative at `.planning/phases/07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr/07-CONTEXT.md`.

- Phase 7 runs under the user's autonomous authorization for Phases 6-8; no new taste checkpoint is needed unless a hard gate appears.
- Popup-class controls must be themed as first-class theme types because popup instances cross Window boundaries.
- Use solid tonal surfaces, subtle borders, existing radius tokens, no shadows, no glow, no texture chrome.
- Window chrome should be quiet but complete: embedded borders, title colors/fonts, close icon styling, offsets, title height, resize margins, and unfocused variants.
- PopupMenu and MenuBar must stay practical for editor/runtime scanning, with dense readable rows and explicit separator, submenu, check/radio, disabled, and accelerator coverage.
- FileDialog and ColorPicker icon work follows the existing bespoke SVG contract: 32x32 reference art, `#FFFFFF`, Godot `.import` sidecars, no external icon packs.
- ColorPicker owns chrome, labels, presets, and official icons; engine-rendered gradients/samplers stay engine-rendered.
- Graph stack quality is basic v1: usable grid, minimap/menu icons, selection/connection colors, compact GraphNode panels, grouping-oriented GraphFrame.
- Preserve architecture: one addon-root `.gd`, data-only direction `.tres`, no public export expansion unless proven, no `Theme.clear`, no per-direction scripts, no root fallback `neocade_theme.tres`.
</user_constraints>

## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| COV-06 | Popup-class controls themed first-class: PopupPanel, PopupMenu, AcceptDialog, ConfirmationDialog, FileDialog, TooltipPanel, TooltipLabel, Window. | The local probe shows concrete Window, PopupPanel, PopupMenu, AcceptDialog, FileDialog, TooltipPanel, TooltipLabel slots; ConfirmationDialog inherits AcceptDialog and should still get explicit entries for traceability. |
| COV-08 | Advanced controls themed: MenuBar, ColorPicker, GraphEdit, GraphNode, GraphFrame. | The local probe shows official 4.6.2 slots for all five. |
| COV-01 | Desktop scorecard closes at 37/37 user-facing rows. | Phase 5 + 6 already contributed core/list/range rows; Phase 7 covers the remaining popup and advanced rows. |
| COV-07 | Container chrome complete. | Phase 7 closes the popup/window shell portion of container-like chrome after Phase 5/6 Panel/Scroll/Split/Margin work. |
| COV-09 | Focus indicator on every focusable Control. | Phase 7 must keep focus entries limited to official `focus`, `panel_focus`, `sample_focus`, `picker_focus_*`, and Button-family focus slots. |

## Local Slot Evidence

The slot freeze was generated with local Godot 4.6.2:

- Probe script: `.planning/phases/07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr/helpers/_phase7_research_slot_probe.gd`
- Probe log: `.planning/phases/07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr/logs/07-research-slot-probe.log`
- Engine line: `Godot Engine v4.6.2.stable.mono.official.71f334935`

### Window and Popup/Dialog Slots

| Type | Styleboxes | Colors | Constants | Fonts / Font Sizes | Icons |
|------|------------|--------|-----------|--------------------|-------|
| Window | `embedded_border`, `embedded_unfocused_border` | `title_color`, `title_outline_modulate` | `close_h_offset`, `close_v_offset`, `resize_margin`, `title_height`, `title_outline_size` | `title_font`, `title_font_size` | `close`, `close_pressed` |
| PopupPanel | `panel` | none | none | none | none |
| PopupMenu | `hover`, `labeled_separator_left`, `labeled_separator_right`, `panel`, `separator` | `font_accelerator_color`, `font_color`, `font_disabled_color`, `font_hover_color`, `font_outline_color`, `font_separator_color`, `font_separator_outline_color` | `gutter_compact`, `h_separation`, `icon_max_width`, `indent`, `item_end_padding`, `item_start_padding`, `outline_size`, `separator_outline_size`, `v_separation` | `font`, `font_separator`, `font_size`, `font_separator_size` | `checked`, `checked_disabled`, `radio_checked`, `radio_checked_disabled`, `radio_unchecked`, `radio_unchecked_disabled`, `submenu`, `submenu_mirrored`, `unchecked`, `unchecked_disabled` |
| AcceptDialog | `panel` | none | `buttons_separation` | none | none |
| ConfirmationDialog | none | none | none | none | none |
| FileDialog | none | `file_disabled_color`, `file_icon_color`, `folder_icon_color` | `thumbnail_size` | none | `back_folder`, `clear`, `create_folder`, `favorite`, `favorite_down`, `favorite_up`, `file`, `file_thumbnail`, `folder`, `folder_thumbnail`, `forward_folder`, `list_mode`, `load`, `parent_folder`, `reload`, `save`, `sort`, `thumbnail_mode`, `toggle_filename_filter`, `toggle_hidden` |
| TooltipPanel | `panel` | none | none | none | none |
| TooltipLabel | none | `font_color`, `font_outline_color`, `font_shadow_color` | `outline_size`, `shadow_offset_x`, `shadow_offset_y` | `font`, `font_size` | none |

### Advanced Slots

| Type | Styleboxes | Colors | Constants | Fonts / Font Sizes | Icons |
|------|------------|--------|-----------|--------------------|-------|
| MenuBar | `disabled`, `hover`, `normal`, `pressed` | `font_color`, `font_disabled_color`, `font_focus_color`, `font_hover_color`, `font_hover_pressed_color`, `font_outline_color`, `font_pressed_color` | `h_separation`, `outline_size` | `font`, `font_size` | none |
| ColorPicker | `picker_focus_circle`, `picker_focus_rectangle`, `sample_focus` | `focused_not_editing_cursor_color` | `center_slider_grabbers`, `h_width`, `label_width`, `margin`, `sv_height`, `sv_width` | none | `add_preset`, `bar_arrow`, `color_hue`, `color_script`, `expanded_arrow`, `folded_arrow`, `menu_option`, `overbright_indicator`, `picker_cursor`, `picker_cursor_bg`, `sample_bg`, `sample_revert`, `screen_picker`, `shape_circle`, `shape_rect`, `shape_rect_wheel` |
| ColorPickerButton | `disabled`, `focus`, `hover`, `normal`, `pressed` | `font_color`, `font_disabled_color`, `font_focus_color`, `font_hover_color`, `font_outline_color`, `font_pressed_color` | `h_separation`, `outline_size` | `font`, `font_size` | `bg` |
| GraphEdit | `menu_panel`, `panel`, `panel_focus` | `activity`, `connection_hover_tint_color`, `connection_rim_color`, `connection_valid_target_tint_color`, `grid_major`, `grid_minor`, `selection_fill`, `selection_stroke` | `connection_hover_thickness`, `port_hotzone_inner_extent`, `port_hotzone_outer_extent` | none | `grid_toggle`, `layout`, `minimap_toggle`, `snapping_toggle`, `zoom_in`, `zoom_out`, `zoom_reset` |
| GraphNode | `panel`, `panel_focus`, `panel_selected`, `slot`, `slot_selected`, `titlebar`, `titlebar_selected` | `resizer_color` | `port_h_offset`, `separation` | none | `port`, `resizer` |
| GraphFrame | `panel`, `panel_selected`, `titlebar`, `titlebar_selected` | `resizer_color` | none | none | `resizer` |

## Current Code Delta

| Area | Current State | Required Plan Action |
|------|---------------|----------------------|
| Window | Baseline has embedded borders, `title_color`, `close_h_offset`, `title_height`; missing unfocused title/modulate, outline, vertical offset, resize margin, fonts, close icons. | Expand Window coverage and set explicit title font/font size outside or through a supported path. |
| PopupMenu | Baseline covers five styleboxes, five colors, three constants, four icons; missing outline/separator outline colors, several constants, separator font, disabled check/radio icon variants, submenu icons, and explicit font/font sizes. | Full PopupMenu row with dense menu metrics and icon coverage. |
| AcceptDialog / ConfirmationDialog | Baseline has panel and `buttons_separation`; ConfirmationDialog has explicit entries despite no own slots. | Keep explicit entries and make shell recipes consistent with PopupPanel/Window. |
| FileDialog | Baseline has panel, three official colors, extra stale `icon_normal_color`, and no official icon recipes. | Bind all official 20 FileDialog icons, `thumbnail_size`, and remove/avoid unsupported stale color names. |
| TooltipLabel | Baseline has only `font_color`. | Add font outline/shadow colors, zero or controlled shadow offsets, font/font size, and readable AA text. |
| MenuBar | Baseline missing font focus/hover-pressed/outline/pressed colors, outline size, and explicit font/font size. | Bring MenuBar to Button/MenuButton quality while preserving desktop menu density. |
| ColorPicker | Baseline has only `margin`. | Bind all three focus styleboxes, focused cursor color, six constants, and exactly 16 official icons. |
| ColorPickerButton | Baseline misses focus/hover/pressed/focus colors, outline size, font/font size, and `bg` icon. | Complete button-family slot surface without changing the Button contract. |
| Graph stack | Baseline GraphEdit covers partial style/color set; GraphNode/GraphFrame absent or minimal. | Add full basic-v1 graph coverage and icons. |

## Recommended Plan Shape

Use five sequential waves:

1. Slot-freeze and verifier foundation.
2. Window, popups, tooltips, MenuBar, PopupMenu.
3. FileDialog icons and structural coverage.
4. ColorPicker and ColorPickerButton.
5. GraphEdit/GraphNode/GraphFrame plus final coverage and ResourceSaver round-trip.

This mirrors Phase 6's successful pattern: freeze slots first, implement risk clusters in order, then run the full verifier and direction resource round-trip only after production bindings are complete.

## Pitfalls

- Popup resources must be type-level Theme entries, not per-Control overrides. Popup Windows do not inherit override bags from their spawner.
- TooltipPanel alone is not enough; TooltipLabel owns readable text.
- FileDialog and ColorPicker icon lists must come from the local 4.6.2 probe, not remembered docs.
- `ConfirmationDialog` has no own slots in the probe, but explicit entries are still useful for scorecard traceability and inheritance clarity.
- Graph stack should not turn into a heavy graph-editor redesign. Basic v1 coverage is enough.
- ResourceSaver can serialize generated Theme entries into all five direction `.tres` files unless the Phase 6 strip pattern is preserved.

## Validation Architecture

Phase 7 should create helper scripts under `.planning/phases/07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr/helpers/`:

- `Resolve-Godot46.ps1` copied/adapted from Phase 6.
- `_run-phase7-verify.ps1` with stages `slot-freeze`, `popups-menus`, `filedialog`, `colorpicker`, `graph`, and `full`.
- `_phase7_verify_headless.gd` asserting official slot coverage, no stale entries, no `Theme.clear()`, one addon-root `.gd`, focus discipline, final 37-row structural coverage, and direction `.tres` data-only resource shape.
- `_phase7_resource_saver.gd` copied/adapted from Phase 6 and run only in the final wave.
- `phase7-slot-freeze.txt` generated from the probe log.

## Sources

- `.planning/phases/07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr/07-CONTEXT.md`
- `.planning/phases/07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr/logs/07-research-slot-probe.log`
- `addons/neocade_theme/neocade_theme.gd`
- `.planning/phases/06-lists-layout-range-tree-itemlist-tabs-containers-sliders-des/06-RESEARCH.md`
- `.planning/phases/06-lists-layout-range-tree-itemlist-tabs-containers-sliders-des/helpers/_phase6_verify_headless.gd`
- `.planning/research/MINIMAL-THEME-DISSECTION.md`
- `.planning/research/FEATURES.md`
- `.planning/research/PITFALLS.md`
- `.planning/research/EDITOR-COVERAGE.md`

## Metadata

**Valid until:** project upgrades beyond Godot 4.6.2, or local slot probe output changes. Re-run the probe before execution if engine version changes.
