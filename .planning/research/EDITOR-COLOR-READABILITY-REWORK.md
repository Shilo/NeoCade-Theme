# Editor Color Readability Rework

Date: 2026-05-13
Status: research and pre-implementation design direction
Scope: color roles for Godot editor/runtime Controls after real editor screenshot failure.

## Why This Exists

The current source-color role system succeeded at making themes more colorful, but failed in the Godot editor because it let saturated identity roles own broad text-heavy surfaces. The user screenshot shows Pulse turning `Tree`, `ItemList`, selected tabs, inspector value cells, layer masks, and many inputs into a high-chroma yellow field. That creates two separate problems:

- Readability and scan hierarchy collapse because dense text is placed on broad luminous fills.
- The `on_*` foreground math can choose a technically contrasting text color while the overall editor still feels loud, warning-like, and hard to use.

The correction is not to make NeoCade bland. The correction is to make color roles more disciplined:

- Text-heavy controls use low-chroma readable containers.
- High-chroma theme identity appears in compact places: focus rings, rails, selected indicators, progress/toggle fills, small icon states, active tab strips, and high-emphasis action buttons.
- Default controls still look distinct per theme without requiring type variations.

## Source-Backed Guardrails

### WCAG Contrast

Use WCAG 2.2 as the floor, not the taste target.

- Normal text needs at least 4.5:1 contrast against its actual background.
- Large text can use 3:1, but Godot editor text is mostly small/dense, so use 4.5:1 for all normal control text.
- Disabled controls are exempt from strict contrast, but should remain visibly legible enough to understand the UI state.

Source: [W3C Understanding 1.4.3 Contrast Minimum](https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum)

### Non-Text UI Contrast

Interactive component boundaries, state indicators, selected markers, check/radio/toggle marks, focus indicators, and other non-text UI information need at least 3:1 contrast against adjacent colors when they convey state or affordance.

Yellow is specifically risky: W3C examples show pale yellow state fills can fail when they rely on hue instead of contrast. If yellow is used, pair it with a dark boundary, a dark text color, or a separate shape/rail indicator.

Source: [W3C Understanding 1.4.11 Non-text Contrast](https://www.w3.org/WAI/WCAG22/Understanding/non-text-contrast)

### Focus

Use a robust focus ring, not only a subtle background change. A 2px perimeter is the simplest reliable shape; if focus is inset or blended into the control, it needs enough area and at least 3:1 change of contrast from the unfocused state.

Source: [W3C Understanding 2.4.13 Focus Appearance](https://www.w3.org/WAI/WCAG22/Understanding/focus-appearance.html)

### Color Meaning

Do not rely on color alone to communicate state. Use text, icons, shape, rails, or state changes in addition to hue. This is especially important for danger/success/warning colors and selected/active states.

Source: [W3C Understanding 1.4.1 Use of Color](https://www.w3.org/WAI/WCAG22/Understanding/use-of-color.html)

### Material 3 Lessons

Material 3 does not apply one source color everywhere. It derives multiple tonal palettes from a source color, then components consume roles. In Material text fields, the filled text field container maps to `surface-container-highest`, input text maps to `on-surface`, and focus/caret indicators map to `primary`. This is exactly the pattern NeoCade needs: readable input container first, color identity on the active indicator.

Sources:

- [Android Developers: M3 color system process](https://developer.android.com/design/ui/mobile/guides/styles/color?hl=en)
- [Material Color Utilities README](https://github.com/material-foundation/material-color-utilities)
- [Material Web text field docs](https://material-web.dev/components/text-field/)
- [Material Web filled text field tokens](https://raw.githubusercontent.com/material-components/material-web/main/tokens/versions/v0_192/_md-comp-filled-text-field.scss)

### Apple HIG Lessons

Apple's color guidance is conservative but useful here: use color consistently, avoid assigning the same color to different meanings, verify contrast in light/dark/increased contrast contexts, and be careful with culturally loaded colors such as red.

Source: [Apple Human Interface Guidelines: Color](https://developer.apple.com/design/human-interface-guidelines/color)

## Local Evidence

### Godot Modern And Minimal Patterns

Godot Modern and Godot Minimal do not style editor input/list surfaces with saturated action colors. They use surface ladders:

- `LineEdit` and `TextEdit` get low-chroma surface fills.
- `EditorProperty.child_bg` and `EditorSpinSlider.label_bg` use quiet surface fills.
- `ItemList` and `Tree` selected/hovered rows use button-like neutral surfaces, not broad accent floods.
- `TreeSecondary` and `ItemListSecondary` own visible side-panel surfaces.
- `FlatButton` and toolbar buttons are mostly transparent until hover/pressed.
- `TabBar` selected tabs use neutral selected surfaces with readable selected text.

Practical implication: NeoCade can be more colorful than Godot Minimal, but text-heavy controls should still follow the same structural idea.

Local sources:

- `C:\Programming_Files\Godot\godot-master\editor\themes\theme_modern.cpp`
- `C:\Programming_Files\Godot\godot-minimal-theme-main\minimal_theme.tres`
- `.codex/skills/godot-editor-theme-layout/references/editor-theme-debugging.md`

### Current NeoCade Failure Pattern

The current implementation resolves broad roles in `_regenerate_theme()`:

- `input_fill = _role_color(..., "input", ...)`
- `selection_fill = _role_color(..., "select", ...)`
- `tab_selected_fill = selection_fill`
- `button_normal = action_fill`
- `role_primary = selection_fill`

Current `ItemList`, `Tree`, `LineEdit`, and `TabBar` bindings then use these roles directly for large painted areas:

- `ItemList.selected` and `Tree.selected` use `selection_fill`.
- `LineEdit.normal` uses `input_fill`.
- `LineEdit.selection_color` uses `selection_fill`.
- `TabBar.tab_selected` uses `tab_selected_fill`.

That is why Pulse's yellow `select` role can become a broad editor color instead of a compact LDtk-like category accent.

## Acceptable Color Bands

These are implementation targets, not exact hard-coded CSS values. Production should verify the final generated hex values with contrast probes.

### Text-Heavy Surfaces

Applies to `LineEdit`, `TextEdit`, `CodeEdit`, `SpinBox`, inspector value cells, `TreeLineEdit`, list panels, tree panels, item rows, property rows, and dialogs with dense text.

Dark-shell themes:

- Lightness: roughly 14 to 30 percent HSL for normal containers.
- Saturation: roughly 8 to 32 percent.
- Selected row lightness: roughly 24 to 38 percent.
- Selected row saturation: roughly 12 to 38 percent.
- Foreground: computed per actual fill, target 4.5:1 minimum.

Bubble light-island theme:

- Lightness: roughly 88 to 98 percent for panels/inputs.
- Saturation: roughly 8 to 35 percent.
- Selected row lightness: roughly 80 to 92 percent.
- Foreground: dark, target 4.5:1 minimum.

Guardrail: never use highlighter yellow, pure amber, saturated pink, or saturated red as a broad text-entry/list fill.

### Default Actions

Applies to normal `Button` and button-like controls that are not toolbar/icon/flat controls.

- May be colorful, but should not dominate the whole editor.
- Chroma can be moderate-high if the painted area is small and text contrast passes.
- Yellow/gold action fills should use dark text or a darker ochre fill; never white text on bright yellow.
- Red-family fills are reserved for `DangerButton`, invalid/error states, and destructive actions.

### Menus And Dropdowns

Applies to `OptionButton`, `MenuButton`, `PopupMenu` row hover/pressed, and editor menu-like controls.

- Use readable low/mid-chroma fills.
- Reserve brighter color for hover/pressed indicator or left rail.
- `OptionButton` should feel distinct from `LineEdit`, but should not become a CTA.

### Lists And Trees

Lists and trees need their own role group. They should not reuse `selection_fill` as a broad saturated surface.

Proposed roles:

- `list_panel_fill`
- `list_row_hover`
- `list_row_selected`
- `list_row_selected_rail`
- `on_list`
- `on_list_selected`

This preserves identity by making the selected rail or marker colorful while keeping the selected row readable.

### Tabs

Tabs are navigation/data chrome. Use either:

- a muted selected tab fill plus colored top/side stripe, or
- a neutral selected tab fill plus strong colored indicator.

Avoid full yellow selected tab faces in editor-scale layouts. Yellow can be the tab indicator for Pulse/Burst, not the entire tab body.

### Range, Toggle, Check, Progress

These controls can carry more color because they are compact and stateful:

- `range_fill` can be bright enough to feel thematic.
- `toggle_fill` can use green/mint/blue depending on theme.
- Checked/off states need 3:1 non-text distinction where the mark itself conveys state.

### Semantic Colors

- `danger_fill`: red family only for destructive/error/invalid states.
- `warning_fill`: amber/yellow family, but use as warning/status, not default input/list paint.
- `success_fill` or `positive_fill`: green/mint family for success/confirm.
- `info_fill`: blue/cyan family for information and editor technical status.

## Revised Role Model

Keep the current single public `source_color`, but split the role table by surface risk:

### Structural Surfaces

- `surface_fill`: app/editor root background.
- `shell_fill`: deepest editor shell bars and gutters.
- `panel_fill`: normal panels.
- `panel_alt_fill`: raised/secondary panel surface.
- `popup_shell`: popup/menu/dialog shell.
- `dialog_header`: dialog/header band.
- `separator_fill`: dividers, split bars, graph/grid guide lines.

### Text-Heavy Components

- `input_fill`: `LineEdit`, `TextEdit`, `CodeEdit`, `SpinBox`, `TreeLineEdit`.
- `input_edge`: input boundary and active indicator base.
- `list_panel_fill`: `Tree`, `ItemList`, secondary editor trees/lists.
- `list_row_hover`: hovered row background.
- `list_row_selected`: selected row background.
- `list_row_selected_rail`: selected row stripe, indicator, or active edge.

### Interactive Components

- `action_fill`: default `Button`.
- `menu_fill`: `OptionButton`, `MenuButton`, popup hover/pressed surfaces.
- `tab_selected_fill`: selected tab body, usually muted.
- `tab_selected_indicator`: selected tab top/side stripe.
- `range_fill`: progress, slider grabber/track active region, scrollbar active thumb.
- `toggle_fill`: checked/on state for CheckBox/CheckButton/radio and generated PopupMenu checks.
- `focus_ring`: focus outline, must pass focus/non-text contrast.

### Semantic Components

- `primary_action_fill`: `PrimaryButton`; aliases affirmative/high-emphasis behavior.
- `positive_fill`: affirmative action source used by `PrimaryButton`.
- `success_fill`: saved/valid/complete/healthy feedback.
- `warning_fill`: warning/caution.
- `info_fill`: information.
- `danger_fill`: error/destructive.

Every fill with text gets a matching `on_*` derived from the actual final fill, not from a family assumption.
The foreground helper should prefer the theme's authored dark/light text pair, but it must fall back to near-black or white when the authored pair lands in the medium-luminance failure band.

## Theme Direction Corrections

### Pulse

Goal: LDtk-inspired flat editor taxonomy.

Correction:

- Keep dark navy editor shell and sharp rectangles.
- Use amber/gold as compact category/action/indicator color, not broad selected/input fill.
- Use muted blue for inputs and menus.
- Use muted blue-gray selected rows with amber or cyan rails.
- Use green for range/toggles/positive state.

### Daybreak

Goal: bright dawn/coastal mint in a readable dark editor.

Correction:

- Keep dark pine/teal shell.
- Use low-chroma teal input/list surfaces.
- Use sunrise amber for primary actions and small highlights.
- Use mint/aqua for focus, selection rails, and range controls.
- Avoid brown/orange monotone.

### Slate

Goal: restrained futuristic/iOS-adjacent utility.

Correction:

- Keep graphite/blue-gray surfaces.
- Use icy blue and steel/lavender as compact active colors.
- Inputs and lists should be almost neutral graphite.
- This theme is allowed to be quieter, but selected rows and focus must still be visible.

### Burst

Goal: expressive reward/event UI that remains usable.

Correction:

- Keep plum/indigo shell.
- Use gold for high-emphasis actions and reward markers.
- Use cyan/lime/violet as compact active roles.
- Do not make broad input/list surfaces gold.
- Avoid random rainbow; every color must map to a stable role.

### Bubble

Goal: flat 3D mobile-game UI, dark shell plus light islands.

Correction:

- Keep current recommendation: dark outer shell with cream/sky light islands.
- Use blue for default actions, lavender/sky for menus and headers, yellow for reward markers, green for confirm/toggle.
- Avoid pink/red as ordinary default action because NeoCade is a reusable theme and red-adjacent hues imply danger for many users.
- Ensure every light island uses dark foregrounds.

## Proposed Preset Source Colors

Keep the current presets for now, but treat them as source inputs rather than literal broad fills:

| Theme | Preset `source_color` | Use |
| --- | --- | --- |
| Pulse | `#3AA8FF` | Pulls blue family and technical editor identity. Amber/green roles remain authored anchors. |
| Daybreak | `#76F2D1` | Pulls mint/aqua family while keeping amber action authored. |
| Slate | `#8BD3FF` | Pulls icy blue into a restrained graphite system. |
| Burst | `#FFD166` | Pulls gold reward energy but clamps broad text-heavy roles away from yellow. |
| Bubble | `#57C7FF` | Pulls sky-blue game UI identity into light islands and blue action roles. |

If a user changes `source_color`, all roles should move subtly or strongly according to role risk:

- Surfaces/input/list: low pull, clamped chroma and luminance.
- Actions/menu/tabs: medium pull, contrast-checked.
- Range/toggle/focus: stronger pull where safe.
- Danger: fixed or extremely low pull; red semantics must remain red.

## Implementation Consequences

1. Add `list_*` roles before changing production colors.
2. Stop binding broad list/tree selected backgrounds directly to saturated `selection_fill`.
3. Split `selection_fill` into:
   - compact `selection_indicator` / `selection_rail`;
   - muted `list_row_selected`;
   - text selection highlight for text fields/code editors.
4. Make `input_fill` low-chroma in every theme, including Pulse and Burst.
5. Recompute every `on_*` foreground after final state colors are resolved.
6. Add verifier coverage for text contrast on:
   - `Button`, `OptionButton`, `MenuButton`;
   - `LineEdit`, `TextEdit`, `CodeEdit`, `SpinBox`, `TreeLineEdit`;
   - `Tree`, `TreeSecondary`, `TreeTable`, `ItemList`, `ItemListSecondary`;
   - `TabBar`, `TabContainer`, `BottomPanel`;
   - `EditorProperty.child_bg`, `EditorSpinSlider.label_bg`, `EditorInspectorButton`;
   - `PopupMenu` rows and generated check/radio icons.
7. Add non-text contrast checks for focus rings, selected rails, check/radio/toggle marks, progress/range fills, and split/scrollbar indicators.

## Next Design Gate

Build a Godot-editor-shaped mockup that proves the roles under real editor pressure:

- top menu and workspace tabs;
- left Scene/FileSystem docks using `Tree` and `ItemList` patterns;
- center toolbar, viewport, and bottom output panel;
- right Inspector with property rows, `LineEdit`, `SpinBox`, `CheckBox`, `OptionButton`, and layer masks;
- default, primary, danger, flat, menu, and icon buttons;
- contrast audit table for every major role.

The mockup should fail loudly if any text role drops below 4.5:1 or any state indicator drops below 3:1.

## Mockup Created

File:

- `.planning/mockups/editor-color-readability/godot-editor-readability-mockup.html`

The mockup includes:

- five theme presets with editable `source_color`;
- Godot-editor-like top bar, docks, scene/file trees, viewport, output panel, and inspector;
- text-heavy controls separated from action/menu/range/toggle roles;
- `list_*` roles for readable tree/list selected rows with compact colored rails;
- an embedded contrast audit table.

Verification run:

- Preset audit: all five preset themes pass sampled 4.5:1 text checks.
- Preset audit: sampled state indicators pass 3:1.
- Stress audit: all five themes were tested against `#3AA8FF`, `#FF3355`, `#FFD166`, `#57F287`, `#A855F7`, `#FFFFFF`, and `#111111`; sampled pairs had zero contrast failures after adding near-black/white fallback candidates to `on_*` foreground selection.
- Browser visual open was attempted through the Codex Playwright tool, but the configured Chrome executable was missing on this machine. The mockup JavaScript was executed directly with the Node REPL to verify resolved style values and contrast math.
