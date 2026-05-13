# Theme Color Identity Rethink

Date: 2026-05-13
Status: research plus dynamic source-color plan
Scope: built-in theme color identity, default control mappings, and pre-implementation mockup plan.

## Why This Exists

The current NeoCade themes still feel too similar because most default controls are driven by `base_color`-derived surfaces, while `accent_color` appears mainly in focus rings, selection details, toggles, progress fills, links, and opt-in type variations such as `PrimaryButton` or `PremiumButton`.

That means a user can select Pulse, Daybreak, Slate, Burst, or Bubble and still get the same basic interaction language unless they know to use theme variations. This violates the new working rule:

**Built-in styles must feel distinct out of the box, assuming users never apply button or control variations.**

## Current Documentation Alignment

The last two documentation commits were reviewed:

- `2d4c3f8 docs: sync planning documents for May 2026`
- `abd8736 docs: update design tokens documentation for Phase 4`

They confirm the current architecture:

- One concrete `@tool class_name NeoCadeTheme extends Theme` script.
- One canonical resource at `addons/neocade_theme/neocade_theme.tres`.
- Built-in styles are selected through the `style` export.
- Public exports remain `style`, `raised`, `platform`, `base_color`, `accent_color`, `corner_radius`, `spacing`, `raised_strength`, `focus_thickness`, `outline_width`, `use_runtime_popup_selection_icons`, and `texture_cache`.
- Role variations exist, but they are opt-in through `theme_type_variation`.

Important conflict: current planning docs say the Phase 12 visual identity gap is closed and the direction integrity rule says built-in styles must not be recolored or rederived. This new user feedback reopens that decision. If this plan is approved, `DESIGN_TOKENS.md` and related planning docs should be updated to supersede the old color lock.

## Current Implementation Findings

The issue is not that `accent_color` is unused. It is that the most visible default control chrome still comes from the same base-derived family.

Observed implementation pattern in `addons/neocade_theme/scripts/neocade_theme.gd`:

- Base `Button` uses `button_normal`, `button_hover`, and `button_pressed`, which are derived from `base_color`.
- `OptionButton` follows the same base-derived button family.
- `LineEdit`, `TextEdit`, and related input surfaces mostly use the same base-derived button/input family.
- `TabBar` selected state gets a colored accent edge, but not a strongly distinct fill in the default theme.
- `ItemList` and `Tree` selected states use accent details and selected text, but the row surface still stays close to the base-derived family.
- `PrimaryButton`, `SuccessButton`, `WarningButton`, `DangerButton`, `InfoButton`, and similar role variations show stronger color identity, but users cannot be expected to opt into them.
- Semantic roles are currently static across themes, so success/warning/danger/info do not help each style build its own world.

Result: style identity is carried too much by radius, raised depth, and a narrow source/base palette instead of by a full component color system.

## Material Design 3 Takeaway

Material Design 3 dynamic color is not simply "one accent color used everywhere." Its useful lesson for NeoCade is the role architecture:

- A source color creates several tonal palettes: primary, secondary, tertiary, neutral, neutral variant, and error.
- Expressive variants intentionally alter hue/chroma relationships so one source can produce multiple coordinated color families.
- Components consume roles, not the raw source color directly.

NeoCade should borrow that structure, not necessarily the full algorithm. The goal is an internal role palette where default controls use different generated or authored roles per theme.

Source references:

- [Material Color Utilities repository](https://github.com/material-foundation/material-color-utilities)
- [CorePalette source](https://raw.githubusercontent.com/material-foundation/material-color-utilities/main/typescript/palettes/core_palette.ts)
- [Dynamic color variants](https://raw.githubusercontent.com/material-foundation/material-color-utilities/main/typescript/dynamiccolor/variant.ts)
- [Material Web theming guide](https://material-web.dev/theming/material-theming/)

## Material Dynamic Source Color Review

The named `m3.material.io` pages currently require JavaScript in text-fetch tools, so this pass cross-checked them through official Android, Material Theme Builder, Material Color Utilities, and Material Web sources.

Source-backed findings:

- Material 3 starts from key colors. Each key color relates to a tonal palette, and specific tones become UI roles. Material Theme Builder says Primary should be set first because it behaves like the dynamic source color and can override other key colors.
- Android Compose documentation describes five key colors, each with 13 tones, and notes that dynamic color derives custom colors from wallpaper as the starting point for light and dark schemes.
- Material Color Utilities `themeFromSourceColor()` builds light and dark schemes plus `primary`, `secondary`, `tertiary`, `neutral`, `neutralVariant`, and `error` tonal palettes from a source.
- The older `CorePalette.of(source)` formula is instructive: primary keeps source hue with stronger chroma, secondary keeps hue with lower chroma, tertiary shifts hue, neutral palettes keep very low chroma, and error is a fixed red-family palette.
- Newer `DynamicScheme` adds more context than "one color": source HCT, variant, dark/light, contrast level, platform, spec version, and the generated palettes. Variants such as expressive, vibrant, tonal spot, and neutral are how Material changes palette personality from the same seed.
- Material Web confirms the important implementation pattern: components consume system roles. A filled button maps its container to `primary` and label to `on-primary`; checkbox selected state maps to `primary`; error states map to `error`.

References:

- [Android Compose Material 3 color scheme](https://developer.android.com/develop/ui/compose/designsystems/material3)
- [Material Theme Builder README](https://github.com/material-foundation/material-theme-builder#how-to-use---web)
- [Material Web color tokens guide](https://material-web.dev/theming/color/)
- [Material Color Utilities README](https://github.com/material-foundation/material-color-utilities)
- [Material Color Utilities `theme_utils.ts`](https://raw.githubusercontent.com/material-foundation/material-color-utilities/main/typescript/utils/theme_utils.ts)
- [Material Color Utilities `core_palette.ts`](https://raw.githubusercontent.com/material-foundation/material-color-utilities/main/typescript/palettes/core_palette.ts)
- [Material Color Utilities `dynamic_scheme.ts`](https://raw.githubusercontent.com/material-foundation/material-color-utilities/main/typescript/dynamiccolor/dynamic_scheme.ts)
- [Material Web filled button tokens](https://raw.githubusercontent.com/material-components/material-web/main/tokens/versions/v0_192/_md-comp-filled-button.scss)
- [Material Web checkbox tokens](https://raw.githubusercontent.com/material-components/material-web/main/tokens/versions/v0_192/_md-comp-checkbox.scss)

Conclusion for NeoCade:

- Copy the role-palette architecture.
- Copy the idea that one source can regenerate a full accessible system.
- Do not copy Material's exact role assignments or generic hue behavior.
- Do not make every role a tint of the same source. That would recreate the current sameness problem in a new form.
- Use one public source color as the workflow, but each built-in style needs its own palette strategy, role mapping, and semantic guardrails.

## Godot Theme Feasibility

Godot `Theme` can set colors, constants, icons, fonts, font sizes, and styleboxes by control type and item name. It can also support type variations, but the new direction should not depend on them for core identity.

Feasible through the existing Godot Theme system:

- Give default `Button` a distinct theme-specific fill.
- Give `OptionButton`, `MenuButton`, and popup selections a separate color role.
- Give inputs their own surface and border role.
- Give `TabBar` selected tabs a stronger theme-specific fill or underline strategy.
- Give `ItemList` and `Tree` selected rows stronger role containers.
- Give sliders, progress bars, checks, and toggles their own role choices.
- Give semantic roles per-style values instead of global static values.
- Keep `raised` behavior as solid darker offset shapes.

Not automatically feasible through global Theme alone:

- LDtk-style different colors for each arbitrary list item or game entity type.
- Per-content semantic colors when the Control does not expose item metadata to the Theme.

Middle ground for LDtk-like identity:

- Map different default control families to different colors: buttons, tabs, inputs, lists, menus, range controls, toggles, and selected rows.
- For app-specific per-item taxonomy, document that consumers need custom item drawing, custom controls, item metadata, or optional variations. NeoCade can still make the default editor/runtime UI feel much closer to LDtk without requiring those app-specific hooks.

Godot references:

- [Theme class documentation](https://docs.godotengine.org/en/4.6/classes/class_theme.html)
- [Using Theme editor](https://docs.godotengine.org/en/stable/tutorials/ui/gui_using_theme_editor.html)

## Godot Control Mapping Contract

Every mockup color role must map to real Godot theme slots or be rejected before production.

| Mockup role | Godot control family | Likely theme slots |
| --- | --- | --- |
| Default action fill | `Button` | `normal`, `hover`, `pressed`, `disabled`, font/icon colors |
| Menu/dropdown fill | `OptionButton`, `MenuButton`, `PopupMenu` | `OptionButton.normal`, `MenuButton` inherited `Button` slots or variation slots, `PopupMenu.panel`, `PopupMenu.hover` |
| Input fill and border | `LineEdit`, `TextEdit`, `SpinBox`, `TreeLineEdit` | `normal`, `focus`, `read_only`, caret/selection colors |
| Selected tabs | `TabBar`, `TabContainer` | `tab_selected`, `tab_unselected`, `tab_hovered`, selected/unselected font and icon colors |
| Selected rows | `ItemList`, `Tree` | `selected`, `selected_focus`, hover/guide colors, relationship/guide line colors |
| Range/progress | `HSlider`, `VSlider`, `ProgressBar`, `HScrollBar`, `VScrollBar` | slider track styleboxes, grabber icons/colors, `ProgressBar.fill`, scrollbar grabber styleboxes |
| Toggle/check active state | `CheckBox`, `CheckButton`, `PopupMenu` check/radio icons | checked/unchecked icon slots, `checkbox_checked_color`, `button_checked_color`, generated PopupMenu selection icons |
| Dialog/popup shell | `Window`, `PopupPanel`, `AcceptDialog`, `ConfirmationDialog`, `PopupMenu` | embedded borders, `PopupPanel.panel`, `Window` embedded borders, popup/menu panels |
| Destructive state | `Button` variations plus base danger state where applicable | `DangerButton` remains optional, but danger color can also be used by explicit destructive UI examples |

The HTML mockup may use CSS for speed, but it must behave like this table: no visual effect should depend on CSS selectors that Godot Theme cannot approximate through control type slots, styleboxes, colors, constants, icons, fonts, or optional type variations.

## Semantic Color Guardrails

NeoCade is a reusable theme, not a one-off game skin. Color meaning must stay readable across editor and runtime contexts.

- Reserve red and red-adjacent hues for danger, destructive actions, errors, invalid states, and delete/remove semantics.
- Avoid red-orange, hot pink, coral, rose, and saturated reddish magenta for ordinary default buttons, selected rows, menu hovers, and neutral headers.
- Use amber/yellow for reward, warning, or sunny action only when text contrast passes and the action is clearly non-destructive.
- Use blue/cyan for info, options, menus, and technical/editor actions.
- Use green for success, confirmation, enabled toggles, and safe progress.
- Use violet/lavender/purple for expressive secondary roles when a theme needs energy without implying danger.
- If a commercial game UI reference uses pink for primary actions, treat that as a genre-specific cue. NeoCade should test a safer translation first: blue actions, lavender headers, yellow rewards, green confirms, red danger only.
- Always compute or choose readable foreground colors per role. Bright fills usually need dark text; dark or muted fills usually need light text.

## Research Round 2 Evidence Review

This pass treats the first proposal as a hypothesis. The goal is to test it against the named references before building production code.

| Source | What it proves | Constraint for NeoCade |
| --- | --- | --- |
| User-provided LDtk screenshot | The mood comes from color taxonomy, not just sharp corners. Toolbar groups, active layers, shortcut chips, category labels, selected rows, and entity rows all use distinct roles. | Pulse cannot be "dark navy plus green accent." It needs several default control-family colors. |
| [LDtk interface overview](https://ldtk.io/docs/general/editor-components/) | LDtk's side panel includes top project buttons, layer lists, and a lower palette whose content changes by active layer. | Some LDtk color behavior is content semantic. Godot Theme can mimic the feeling at the control-family level, but not infer arbitrary entity/item colors globally. |
| [LDtk entities docs](https://ldtk.io/docs/general/editor-components/entities/) | Entities are user/project data with custom fields and constraints. | Per-entity colors require app data, custom item drawing, custom controls, or optional variations. A global Theme alone cannot know that `Gem` should be blue and `Enemy` should be red. |
| [HCGames/Renderman Flat GUI for mobile games](https://hcgamestudios.itch.io/flat-game-ui-for-mobile-games) | The pack is flat, customizable, mobile-oriented, broad in screen coverage, and explicitly ships buttons in five colors with many icon states. | Bubble needs many default roles: blue, green, yellow/orange, cream, lavender, and muted lock/disabled colors. The reference uses pink, but NeoCade should first test a safer translation where red-adjacent hues stay reserved for danger. |
| [Material Color Utilities](https://github.com/material-foundation/material-color-utilities) and [CorePalette source](https://raw.githubusercontent.com/material-foundation/material-color-utilities/main/typescript/palettes/core_palette.ts) | Material dynamic color creates multiple tonal palettes from source colors: accent palettes, neutral palettes, neutral-variant palettes, and error. | NeoCade should generate or author role families, not pipe one accent directly into a few slots. |
| [Material Web theming](https://material-web.dev/theming/material-theming/) | Material uses reference tokens, system tokens, and component tokens. Components consume roles. | NeoCade should add an internal role layer, then bind Godot control types to component aliases. |
| [Google M3 Expressive research](https://design.google/library/expressive-material-design-google-research?pubDate=20250521) | Expressive design uses color, shape, size, motion, and containment to make important actions easier to find, but warns that breaking familiar patterns hurts usability. | Burst can be loud, but it must keep familiar Godot/editor patterns and accessibility. Expressive does not mean random color everywhere. |
| [Android Developers M3 Expressive Wear guidance](https://developer.android.com/design/ui/wear/guides/get-started/design-language?hl=en) | Newer M3 expands color tokens, uses deeper tonal palettes, and treats shapes/containers as identity. | Slate and Daybreak can be distinct through role choices and containment without resorting to texture, glow, or decorative images. |
| [Godot Theme class](https://docs.godotengine.org/en/4.6/classes/class_theme.html) | One Theme resource can style all controls of the same type, while local overrides and branch themes exist for special cases. | Out-of-box identity must live in base control type slots. Type variations are useful extras, not the default path. |
| [Godot Theme editor docs](https://docs.godotengine.org/en/stable/tutorials/ui/gui_using_theme_editor.html) | Theme types expose colors, constants, styles, icons, and fonts; defaults can be overridden item by item. | The mockup must map to real Godot slots: `Button.normal`, `OptionButton.normal`, `LineEdit.normal`, `TabBar.tab_selected`, `ItemList.selected`, `PopupMenu.hover`, etc. |

## Self-Challenge Findings

1. **The previous Pulse idea was under-specified.**
   - Weak version: sharp dark arcade with green accent.
   - Better version: LDtk-like editor taxonomy. Buttons, tabs, list selections, shortcuts, and data rows need different colors by default.

2. **The previous Bubble idea conflicts with the v1 dark-only constraint.**
   - The actual reference is bright sky/cream/pink/blue/green/yellow mobile UI.
   - If Bubble must stay fully dark, it will never strongly hit that reference.
   - The best v1 test is a dark outer shell with light cream/sky UI islands. This needs explicit approval because it bends the old "all v1 themes are dark" reading.

3. **The previous Daybreak idea risks reviving rejected Boardwalk DNA.**
   - Useful: warm, welcoming, public arcade/daylight emotion.
   - Rejected: old-fashioned brown, wood/leather, sunset gradients, texture, painterly venue mood.
   - Corrected goal: fresh morning kiosk or community lobby, not Boardwalk Sunset 2.

4. **The previous Slate idea risks being generic premium dark.**
   - A quiet theme still needs an ownable color system.
   - Slate should use icy blue, steel, muted lavender, graphite, and mint in precise roles, not simply "blue accent on dark gray."

5. **The previous Burst idea risks becoming Bubble with plum paint.**
   - Burst must be expressive, event-like, and reward-forward.
   - It needs contrast between gold, violet/blue, cyan/lime, and danger red while keeping familiar UI structure.

6. **A single-source-color export is tempting but not automatically better.**
   - Material can generate multiple palettes from one source, but NeoCade also needs a deliberate dark environment source.
   - Keeping `base_color` plus `accent_color` for v1 is still safer, provided built-in styles add authored role palettes and `CUSTOM` derives roles from the two sources.

7. **Too much color can damage scan speed.**
   - The answer is not "make every widget rainbow."
   - The answer is role assignment: one color for actions, one for navigation/selection, one for inputs, one for range/toggle, one for semantic states, with each theme choosing different mappings.

## Theme Identity Contracts

These are the current goals to test in the HTML mockup. They are not yet implementation locks.

| Theme | Identity goal | Must feel like | Must not feel like | Color identity requirement |
| --- | --- | --- | --- | --- |
| Pulse | LDtk-inspired flat arcade editor taxonomy. | Dense control panel, sharp utility, mixed-color categories, active workbench. | Green-accent-only dark theme, synthwave, generic terminal, pixel-art skin. | At least four visible default UI families: amber/orange action, yellow selection/nav, blue input/menu, green toggles/status, red danger only. |
| Daybreak | Fresh morning community lobby translated into flat dark UI. | Warm, open, social, clean, sunrise energy on teal shadow. | Boardwalk Sunset revival, brown/orange monotone, cozy leather/wood, mint-only dark theme. | Amber action, mint navigation/selection, sun-gold highlights, aqua info, dark pine/teal surfaces, red danger only. |
| Slate | Premium futuristic utility with slight iOS inspiration. | Calm, precise, professional, cool, restrained, expensive. | Generic corporate dark, cyber HUD, colorless grayscale, glassmorphism dependency. | Icy blue action, steel/lavender secondary, graphite inputs, mint success, amber warning, soft red danger. |
| Burst | MD3 Expressive celebration and reward UI. | Energetic, event-like, bold, playful but still readable. | Random rainbow, childish toy UI, Bubble recolor, nightclub/neon, broken usability. | Gold action, violet navigation, blue/violet input, cyan selection, lime progress/toggle, red danger only. |
| Bubble | Flat 3D mobile game UI. | Chunky, friendly, candy-like, touch-first, bright game menu. | Dark berry with pink accent only, glossy jelly, copied asset-pack art, decorative texture. | Blue default actions, lavender menu/header roles, cream/sky panels, yellow rewards, green confirms, blue-gray locked/disabled states, red danger only. |

## First-Pass Look Breakdown

This is what the HTML mockup should test. It intentionally uses default controls only.

### Pulse Look

- Root/shell: deep navy black with charcoal-blue panels.
- Toolbar/menu strip: multiple solid blocks, especially blue, orange, green, and yellow.
- Default Button: amber/orange fill with dark readable text.
- OptionButton/MenuButton: blue/steel fill.
- Inputs: dark blue container with bright blue border or caret.
- Tabs: yellow/gold selected state, squared and dense.
- Lists/Trees: dark rows with strong colored selection and left rails.
- Popup/Dialog: dark solid shell with colored category/header strips.
- Range/toggle/progress: green or cyan, not the same orange as buttons.

### Daybreak Look

- Root/shell: dark pine and deep teal.
- Panels: slightly warmer teal surfaces with more breathing room.
- Default Button: amber/sunrise fill with dark readable text.
- OptionButton/MenuButton: seafoam or muted teal fill.
- Inputs: dark teal fill with cream/amber border or inset.
- Tabs: mint selected state, calm and readable.
- Lists/Trees: mint selected row with amber secondary emphasis.
- Popup/Dialog: amber or aqua header accent on warm dark panels.
- Range/toggle/progress: aqua or mint.

### Slate Look

- Root/shell: graphite blue-black.
- Panels: narrow cool ramp with restrained contrast.
- Default Button: icy blue container or outline, not a bright primary slab.
- OptionButton/MenuButton: steel or muted lavender.
- Inputs: darker graphite field with blue-gray border.
- Tabs: cool blue selected state with restrained fill or precise bar.
- Lists/Trees: blue-gray selected row, low drama.
- Popup/Dialog: graphite shell with cool blue action/footer accents.
- Range/toggle/progress: cyan/blue; success remains mint.

### Burst Look

- Root/shell: deep plum and dark violet.
- Panels: saturated violet/plum ramp.
- Default Button: gold/yellow fill with dark readable text.
- OptionButton/MenuButton: violet or electric blue.
- Inputs: violet/blue container.
- Tabs: cyan or violet selected state, larger and louder than other themes.
- Lists/Trees: gold/cyan selection container, not just a stripe.
- Popup/Dialog: statement header and high-contrast action row.
- Range/toggle/progress: cyan or lime.

### Bubble Look

- Root/shell: dark navy/berry outer frame for v1 compatibility.
- Panels/dialogs: cream, peach, or sky-blue islands.
- Default Button: sky-blue chunky fill with hard lower edge in raised mode.
- OptionButton/MenuButton: lavender or sky blue.
- Inputs: light cream/white field with blue-gray border.
- Tabs: yellow or lavender selected tab state.
- Lists/Trees: rounded blue/yellow/lavender tiles.
- Popup/Dialog: cream panel with lavender header and blue/green/yellow button families.
- Range/toggle/progress: yellow reward progress and green confirm toggles.

## Export Strategy Recommendation

Revised recommendation after the Material dynamic color review: make the normal NeoCade workflow `style + source_color`, where changing `source_color` regenerates every color role.

This is a workflow decision, not a promise to copy Material exactly.

Why this is better for NeoCade's current problem:

- Users should not have to understand why `accent_color` barely affects default controls.
- Users should not have to tune `base_color` and `accent_color` together just to get a coherent theme.
- The built-in styles should remain recognizable while still being personalizable from one color.
- A source color can feed all roles if the roles are generated through a real palette system instead of direct color reuse.

Subagent challenge:

- The independent review argued for keeping `base_color + accent_color` because NeoCade needs separate control over "world color" and "action color."
- That warning is valid if the one-source algorithm is generic.
- The answer is not to keep the awkward two-color workflow. The answer is to make each style own a color strategy that derives the world, action, navigation, input, selection, range, and semantic roles differently from the same source.

Compatibility path:

- In the rework branch, introduce `source_color` as the canonical public color knob.
- Retire `base_color` and `accent_color` from the normal user workflow.
- If serialized-resource compatibility is needed, keep old values only as migration/advanced fields and derive `source_color` from `accent_color` for old resources.
- `CUSTOM` can remain the escape hatch for manually authored palettes later, but built-in styles should never become `CUSTOM` just because the user changes the source color.
- Update `AGENTS.md`, `.planning/PROJECT.md`, `.planning/REQUIREMENTS.md`, `.planning/DESIGN_TOKENS.md`, and the canonical resource export list when implementation begins.

## One-Source Dynamic Role Algorithm

Do not use simple tinting. Use a style-specific anchored dynamic palette.

Inputs:

- `style`
- `source_color`
- `raised`
- `platform`
- shape/spacing exports

Internal steps:

1. Convert `source_color` into a perceptual-ish working model.
   - Preferred long-term model: HCT/CAM16-like hue, chroma, tone.
   - Practical Godot implementation can start with HSV plus luminance/contrast helpers if full HCT is too much for this rework.

2. Load the active style's color strategy.
   - Each style defines anchor hues, chroma bands, tone targets, and role mappings.
   - Anchors are not final fixed colors. They are the style's identity compass.

3. Harmonize each anchor toward the source.
   - Every visible role changes when `source_color` changes.
   - Each role moves by a controlled amount so Pulse stays taxonomic, Daybreak stays morning/teal, Slate stays restrained, Burst stays expressive, and Bubble stays game-UI playful.
   - This is different from tinting: roles have independent hue, chroma, and tone formulas.

4. Generate tonal ramps for each family.
   - `surface`
   - `surface_variant`
   - `action`
   - `navigation`
   - `input`
   - `selection`
   - `range`
   - `positive`
   - `success`
   - `warning`
   - `danger`
   - `info`

5. Resolve component aliases from those ramps.
   - `action_fill`
   - `menu_fill`
   - `input_fill`
   - `selection_fill`
   - `tab_selected_fill`
   - `range_fill`
   - `toggle_fill`
   - `positive_fill`
   - `focus_ring`
   - `popup_shell`
   - `dialog_header`
   - `raised_offset_*`

6. Compute foregrounds per role.
   - Never reuse one global text color for every component.
   - Use `on_action`, `on_menu`, `on_input`, `on_selection`, `on_surface`, and `on_danger` pairs.
   - Use `on_action`, `on_menu`, `on_input`, `on_selection`, `on_positive`, `on_surface`, and `on_danger` pairs.
   - Enforce at least 4.5:1 for normal UI text where possible, with explicit exceptions only for disabled states.

7. Apply semantic guardrails.
   - `danger/error` remains red-family and is never used for ordinary default controls.
   - If a generated ordinary role lands in a red, rose, coral, or hot-pink danger-adjacent range, shift it through that style's safe route.
   - Bubble's pink reference should translate to lavender/blue/yellow by default, with red reserved for destructive UI.

8. Generate explicit state colors.
   - Normal, hover, pressed, focus, selected, checked, and disabled should be real role colors in the table.
   - Do not rely on CSS-like brightness/filter tricks or Godot fallback state layering.

9. Bind Godot controls to aliases.
   - Default controls must carry the palette without variations.
   - Variations remain optional semantic tools, not the only way to see color.

Core rule:

`style + source_color` should produce an identifiable theme, not just a recolored theme.

## Proposed Internal Role Layer

Add an internal generated/authored palette layer between exports and control bindings.

Core roles:

- `role_primary`
- `role_secondary`
- `role_tertiary`
- `role_quaternary`
- `role_neutral`
- `role_neutral_variant`
- `role_success`
- `role_warning`
- `role_danger`
- `role_info`

Container roles:

- `role_primary_container`
- `role_secondary_container`
- `role_tertiary_container`
- `role_quaternary_container`
- `role_success_container`
- `role_warning_container`
- `role_danger_container`
- `role_info_container`

Component aliases:

- `action_fill`
- `navigation_fill`
- `input_fill`
- `selection_fill`
- `range_fill`
- `toggle_fill`
- `positive_fill`
- `menu_hover_fill`
- `focus_ring`
- `panel_mark`

Each built-in style can map these aliases differently. This is the key change: Pulse, Daybreak, Slate, Burst, and Bubble should not share the same component color mapping.

## Control Coverage Rule

The role system must cover every themeable user-facing Control class, but not every `Control` subclass receives a fill. Some Controls paint content supplied by the scene or are layout-only. Implementation must update the existing 35/37-control coverage matrix and the live `BINDING_TABLE`, not just the representative mockup controls.

Coverage contract:

| Control family | Role mapping |
| --- | --- |
| `BaseButton` family: `Button`, `OptionButton`, `MenuButton`, `CheckBox`, `CheckButton`, `ColorPickerButton`, `LinkButton` | Default `Button` uses `action_fill`; option/menu controls use `menu_fill`; check/toggle controls use their own `toggle_fill` or range-family role; link text uses link/info role; `PositiveButton` uses `positive_fill`; `DangerButton` uses `danger_fill`. |
| `LineEdit`, `TextEdit`, `CodeEdit`, `SpinBox`, `TreeLineEdit` | `input_fill`, `input_border`, caret, selection, placeholder, read-only, focus, and disabled roles. |
| `ItemList`, `Tree`, `TabBar`, `TabContainer` | `selection_fill`, `navigation_fill`, row hover, selected focus, cursor, guide/drop-mark, and selected text roles. |
| `Range` family: `ProgressBar`, sliders, scrollbars, texture progress | `range_fill`, range track, range grabber, disabled range, and raised offsets. |
| `Panel`, `PanelContainer`, `ScrollContainer`, `PopupPanel`, dialogs/windows, `FoldableContainer`, `GraphEdit`, `GraphNode`, `GraphFrame` | Surface/panel/popup/dialog roles, with selected/active graph states mapped to selection or action roles. |
| `MenuBar`, `PopupMenu`, tooltip types | `menu_fill`, `menu_hover_fill`, popup shell, menu text, menu disabled, check/radio icon colors. |
| `Label`, `RichTextLabel` | Text roles only by default. No visible fill unless a documented variation or editor-specific wrapper has a panel. |
| `Container` layout subclasses, `ColorRect`, `TextureRect`, `NinePatchRect`, `ReferenceRect`, `VideoStreamPlayer` | No default fill from the Theme. Layout containers get constants; texture/content/debug controls are content-driven or have no useful Theme fill slots. |
| `Separator` | Outline/separator roles, not action/menu/input colors. |

Important limitation:

- Godot Theme cannot know that an arbitrary `Button` whose text says "OK" is a confirm button. Default `Button` should use `action_fill`.
- `positive_fill` is for the explicit `PositiveButton` variation and any future explicit positive-role variations. It should not be applied automatically to ordinary buttons or inferred from button text.
- `danger_fill` is for the explicit `DangerButton` variation and destructive/error states.
- Built-in dialogs that expose only ordinary `Button` controls will inherit `action_fill` unless Godot exposes a specific type/variation or NeoCade adds a targeted scene-side helper.

Implementation gate:

- Add a role-coverage verifier that enumerates the generated Theme entries for the canonical scorecard and fails if any themeable visible stylebox still resolves through old base/accent-only roles.
- Add a semantic verifier that ordinary roles avoid red-family hues while `danger/error` stays red-family.

## Theme Goals

### Pulse

Goal: LDtk-inspired arcade editor panel.

Pulse should feel flat, dense, sharp, utilitarian, and color-taxonomic. Color should behave like a control-panel language: active rows, tools, entities, menu strips, and panels each have a clear job. This is the strongest candidate for multiple default control-family colors.

Proposed mood words: editor, cabinet, taxonomy, sharp, mixed-color, dense.

Proposed color language:

- Environment: deep blue-black and charcoal navy.
- Default actions: amber/orange, not red-orange.
- Active tabs and selected rows: yellow/gold.
- Inputs and option controls: blue or steel.
- Positive/help/toggles: green.
- Danger/destructive: red.

### Daybreak

Goal: warm daylight translated into a flat dark-friendly UI.

Daybreak currently has the least clear identity. It should become the welcoming, public, social, early-morning arcade theme: warm light, teal shade, sun-gold highlights, mint freshness, and readable cream-tinted panels.

This can borrow the useful emotional lesson from the old Boardwalk direction without reviving rejected texture, wood, leather, sunset-gradient, or brown-heavy choices.

Proposed mood words: welcoming, sunrise, social, clean, warm, readable.

Proposed color language:

- Environment: dark pine, deep teal, or blue-green shadow.
- Default actions: amber or sunrise yellow.
- Navigation and selected states: mint or seafoam.
- Inputs: muted teal/cream containers.
- Important headers or highlights: amber, sun-gold, or aqua.
- Info: aqua.

### Slate

Goal: futuristic premium utility with slight iOS inspiration.

Slate should be the calm, precise, professional theme. It should not be loud, but it still needs a real palette. Its identity comes from restrained cool colors, crisp contrast, hairline outlines, and icy interaction states.

Proposed mood words: premium, calm, glassy-without-glass, precise, futuristic, utility.

Proposed color language:

- Environment: graphite, blue-black, and cool charcoal.
- Default actions: icy blue container or outline.
- Secondary controls: steel or desaturated lavender.
- Inputs: darker graphite with blue-gray borders.
- Selected states: blue/cyan.
- Success: mint.
- Warning: muted amber.
- Danger: soft red.

### Burst

Goal: MD3 Expressive celebration theme.

Burst should be the loudest style: reward screens, party-game menus, achievement moments, and expressive high-energy UI. It should use several saturated roles by default and feel intentionally colorful, not merely purple with yellow accents.

Proposed mood words: event, reward, confetti-without-patterns, energetic, expressive, bold.

Proposed color language:

- Environment: deep plum, dark violet, or night berry.
- Default actions: gold/yellow.
- Navigation and selected states: violet or cyan.
- Inputs: violet/blue containers.
- Range/progress/check states: cyan or lime.
- Danger: red only.

### Bubble

Goal: flat 3D mobile game UI.

Bubble should lean hard into the HCGames/Renderman-style mobile UI reference: chunky, playful, touch-first, candy colors, blue buttons, cream panels, yellow rewards, green confirms, and lavender/purple header energy as a safer substitute for pink ribbons.

The current dark berry plus pink direction captures only a fraction of that. To hit the reference, Bubble likely needs either a light/default variant later or a v1 compromise where the outer shell remains dark but panels and dialogs can become cream/sky islands.

Proposed mood words: mobile game, candy, chunky, friendly, puffy, reward.

Proposed color language:

- Environment: dark berry/navy shell for v1 dark compatibility.
- Panels/dialog islands: cream, peach, or sky blue.
- Default actions: bright blue.
- Secondary actions: lavender or sky blue.
- Rewards/warnings: yellow/gold.
- Confirms/success: green.
- Disabled/locked: muted blue-gray.

Reference:

- [Flat Game UI for Mobile Games](https://hcgamestudios.itch.io/flat-game-ui-for-mobile-games)

## Default Control Color Matrix

This is the proposed "no variations required" mapping. Exact values should be tested in mockups before implementation.

| Theme | Button | Option/Menu | Input | Selected Tab | List/Tree Selection | Range/Progress | Toggle/Check | PositiveButton | DangerButton | Popup/Dialog |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Pulse | amber/orange fill | blue/steel | dark blue with bright border | yellow/gold filled or strong strip | gold or role-coded row with colored rail | green or cyan | green | distinct green | red only | dark panels with colored category headers |
| Daybreak | amber fill | mint/teal | pine/cream-tinted input | mint selected state | mint/amber selected container | aqua or mint | mint | fresh green/mint | red only | amber/aqua highlights on warm dark panels |
| Slate | icy blue quiet fill or outline | steel/lavender | graphite with blue-gray border | icy blue selected state | blue-gray selected container | cyan/blue | mint/blue | restrained mint | red only | graphite panels with cool blue accents |
| Burst | gold fill | violet/blue | violet/blue | cyan or violet selected state | gold/cyan selected container | lime/cyan | lime/cyan | high-confidence green | red only | plum panels with violet/cyan statement headers |
| Bubble | blue chunky fill | lavender/sky blue | cream/sky input island | yellow or lavender selected tab | blue/yellow/lavender selected tile | yellow/green | green | bright confirm green | red only | cream panels with lavender headers |

## Dynamic Source Behavior By Theme

These strategies answer the key workflow question: what changes when the user changes `source_color`?

All themes:

- Surfaces change through a low-chroma harmonized surface ramp.
- Default buttons change through an action ramp.
- Option/Menu controls change through a menu/navigation ramp.
- Inputs change through an input/container ramp.
- Tabs, selected rows, and popup hovers change through selection/navigation ramps.
- Progress, sliders, checkboxes, and checkbuttons change through range/toggle ramps.
- `PositiveButton` changes through a dedicated positive ramp instead of borrowing danger, warning, or default action.
- Focus rings change through a high-contrast focus role.
- Raised lower edges change from the final role colors, not from fixed hard-coded shadows.
- Danger/error stays red-family; warning stays amber-family; success stays green-family, with only controlled harmonization.

Theme-specific behavior:

| Theme | Source-color behavior | Identity guardrail |
| --- | --- | --- |
| Pulse | Source shifts a wide arcade control taxonomy: action, menu, selection, input, and range roles move independently around the source. | Must keep at least four visibly different default control families. Never collapse into source plus darker source. |
| Daybreak | Source harmonizes pine/teal surfaces, sun action, mint selection, and aqua info roles. | Must feel fresh and morning-like even from a cool or purple source. Avoid brown/orange monotone. |
| Slate | Source subtly cools graphite surfaces and icy/steel controls with low chroma and tight tone spread. | Must stay restrained. A hot source should become an elegant cool-accent Slate, not a loud red/pink UI. |
| Burst | Source drives the largest hue/chroma spread: statement action, vivid navigation, cyan-like selection, and lime/cool range roles. | Must be expressive but organized. No random rainbow and no ordinary red controls. |
| Bubble | Source harmonizes blue action, lavender headers, cream/sky panels, yellow rewards, and green confirms. | Must read as flat mobile game UI. Pink reference energy becomes safe lavender/blue/yellow unless the role is danger. |

Recommended implementation model:

```text
source_strength = clamp((source_chroma_or_saturation - gray_floor) / usable_chroma_span, 0, 1)
role_hue = harmonize_anchor_toward_source(anchor_hue, source_hue, role_weight * source_strength, max_degrees)
role_chroma = clamp(style_chroma_target + source_chroma_delta * role_chroma_influence * source_strength, min_chroma, max_chroma)
role_tone = style_tone_target_for_mode_and_role
role_color = from_hue_chroma_tone_or_hsv(role_hue, role_chroma, role_tone)
on_role = choose_readable_foreground(role_color)
```

This means a blue source and a green source both change every role, but Pulse still feels like Pulse and Bubble still feels like Bubble.

## Approval Mockup Algorithm Draft

The approval-gate HTML now tests this as a live source-color algorithm. It uses HSL for speed and browser portability; production can either keep a similar Godot-local model or replace the internals with HCT/CAM16-style helpers later.

Shared formula:

```text
source = rgb_to_hsl(source_color)
source_strength = clamp((source.saturation - 0.12) / 0.42, 0, 1)
role_hue = anchor_hue + clamp(shortest_hue_delta(anchor_hue, source.hue) * pull * source_strength, -max_shift, max_shift)
role_hue = avoid_danger_adjacent_red_family(role_hue, safe_hue) unless role is danger/error
role_saturation = clamp(anchor_saturation + (source.saturation - 0.58) * saturation_influence * source_strength)
role_lightness = clamp(anchor_lightness + (source.lightness - 0.52) * lightness_influence)
role_fill = hsl(role_hue, role_saturation, role_lightness)
role_foreground = best accessible foreground from theme dark ink, theme light ink, pure black, or pure white
role_edge = mix(role_fill, style_edge_base, edge_amount)
state_foregrounds = recompute foreground per hover/pressed/selected state, not reuse normal text blindly
```

Theme anchors in the mockup:

| Theme | Surface anchor | Action anchor | Menu/input anchor | Selection anchor | Range/toggle anchor | Positive anchor | Strategy |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Pulse | 224 navy | 42 amber | 208/212 blue | 50 yellow | 118 green | 134 green | Wide LDtk-like taxonomy; source nudges each family but ordinary roles stay non-red. |
| Daybreak | 166 pine/teal | 42 sunrise | 158/164 seafoam | 156 mint | 186 aqua | 143 green | Morning teal environment with sun action and mint selection. |
| Slate | 214 graphite-blue | 205 icy blue | 236/210 steel | 200 cyan-blue | 194 cyan | 156 mint | Low-chroma and restrained; hot sources become cool accents, not hot controls. |
| Burst | 274 plum/violet | 48 gold | 264/245 violet-blue | 188 cyan | 105 lime | 133 green | Strongest source pull and highest chroma spread, but still role-disciplined. |
| Bubble | 214 dark shell / 39 light islands | 199 blue | 258/210 lavender/sky | 47 yellow | 132 green | 128 green | Mobile-game palette; pink source energy translates to lavender/blue/yellow unless danger. |

Red-family guardrail:

- Ordinary roles are prevented from landing in roughly red, rose, coral, and hot-pink hue space.
- The mockup currently models that danger-adjacent band as hue `310..360` or `0..38`; production may tune the exact band after visual tests, but it must include red-orange/coral and hot-pink, not only pure red.
- If a generated ordinary role enters that band, it is moved back toward the role's safe hue with a tiny source-dependent nudge so the color still responds to the source.
- `danger/error` is the only family allowed to remain red-family.
- Achromatic or nearly achromatic source colors use source-strength gating so white, gray, and black do not behave like red just because HSL hue resolves to `0`.
- Hover, pressed, selected, and disabled samples need their own foreground contrast checks; production must not assume the normal-state foreground still works after state color mixing.
- If a stylized per-theme foreground cannot pass contrast on a generated role, the algorithm may fall back to pure black or pure white for that role. Accessibility wins over palette purism.

## Independent Reviewer Pass

Read-only subagent review completed after Research Round 2 and the first HTML mockup.

Verdict: **partially on track**.

Confirmed:

- The diagnosis is right: production default controls are still mostly base-derived, while stronger color identity lives in opt-in variations.
- Pulse should be a control-family color taxonomy, not a green-accent arcade dark theme.
- Godot Theme can support out-of-box variety at the control-family level, but cannot infer arbitrary LDtk-like per-entity/content colors without custom item drawing, custom controls, item metadata, or variations.
- Keeping `base_color` plus `accent_color` is the lowest-risk compatibility choice, but it does not solve the user's desired one-knob workflow by itself.

Decision after challenge:

- Adopt one public `source_color` for the color rework.
- Treat the reviewer's `base_color + accent_color` warning as a requirement for stronger internal style strategies, not as the final public workflow.
- Preserve or migrate old `base_color`/`accent_color` only if needed for resource compatibility.

Warnings:

- Current `DESIGN_TOKENS.md` locks the old palettes and says built-in styles must not be recolored/rederived. This rethink must explicitly supersede that lock before implementation.
- Bubble is the riskiest theme because light cream/sky islands inside a dark v1 style need component-local text roles instead of the current global dark-theme text model.
- The first HTML mockup is a hypothesis board, not an approval artifact.
- CSS-only hover filters should not be treated as implementation evidence. The final mockup needs authored state colors that map to Godot Theme slots.

### Skeptical Review Gate

A follow-up read-only subagent review returned **NOT READY** before implementation. The plan direction was considered much stronger and feasible, but not merge-ready without tightening the dynamic color contract.

Reviewer blockers and resolution in this document/mockup:

| Blocker | Resolution |
| --- | --- |
| Gray/white/black sources resolve to HSL hue `0`, making achromatic source colors behave like red. | Added source-strength/saturation gating so near-gray sources do not pull role hue/chroma strongly. |
| Red guardrail was too narrow; coral/red-orange/hot-pink could leak into ordinary roles. | Broadened danger-adjacent guardrail to include `310..360` and `0..38` in the mockup. |
| Hover/pressed samples reused normal foregrounds after state color mixing. | Mockup now recomputes state foregrounds for hover/pressed/disabled samples and falls back to black/white when stylized ink fails contrast. Production must do the same per state. |
| `PositiveButton` role was ambiguous. | `positive_fill` is explicitly for `PositiveButton` / explicit positive variations; `DangerButton` uses `danger_fill`; no text/intent inference. |
| Bubble light islands require local foreground roles. | Kept Bubble as a dark shell with light islands, but marked this as an explicit product decision requiring component-local `on_*` roles. |
| `DESIGN_TOKENS.md` old direction integrity lock conflicts with this rework. | Added a pending rework note to `DESIGN_TOKENS.md` that this research supersedes the old color lock if approved. |

Required before implementation:

- One approval-grade mockup pass focused on `source_color` dynamic roles, not old base/accent comparison.
- One side-by-side board showing all five themes together.
- Exact role palette swatches with contrast badges.
- Flat and raised states.
- Desktop and mobile density.
- Disabled, hover, pressed, focus, and selected states.
- Labels mapping every visible role to real Godot slots such as `Button.normal`, `OptionButton.normal`, `LineEdit.normal`, `TabBar.tab_selected`, `ItemList.selected`, `Tree.selected`, and `PopupMenu.hover`.
- Explicit decision on whether Bubble may use light islands inside a dark-shell v1 theme.

## Mockup Plan

Before changing production code, create Godot-feasible mockups.

Current artifacts:

- `.planning/mockups/color-identity/theme-color-identity-mockups.html`
- `.planning/mockups/color-identity/theme-color-identity-approval-gate.html`

The first file is the experiential sketch. The approval-gate file is the stricter review artifact and should be used for the implementation decision because it includes:

- A live `source_color` picker and source-stress presets.
- Side-by-side cards for all five built-in themes.
- Default-control examples only: Button, OptionButton/MenuButton, LineEdit, TabBar, ItemList/Tree rows, Progress/Slider, CheckBox/CheckButton, Popup/Dialog.
- Flat raised-offset examples using solid darker lower edges.
- Desktop and mobile density samples.
- Visible state samples for normal, hover, pressed, disabled, selected, checked, `PositiveButton`, and `DangerButton`.
- Contrast badges for the proposed role foreground/background pairs.
- Labels mapping visual roles to real Godot Theme slots and internal component aliases.

1. Finalize this research doc with user edits.
2. Build a scratch mockup pack under `.planning/mockups/color-identity/`.
3. Use the same control families NeoCade styles today: buttons, option buttons, line edits, text edits, tab bars, lists, trees, sliders, progress bars, checkboxes, radio buttons, popup/menu states, and dialogs.
4. Represent the proposal through actual Godot Theme slots and styleboxes, not CSS-only tricks.
5. Avoid required type variations in the mockup. Variations may be shown as optional extras, but the default controls must already carry the theme.
6. Produce one comparison board per style and one combined side-by-side board.
7. Review against these gates:
   - Can the style be recognized without reading its name?
   - Are default Button, OptionButton, Input, Tab, List, and Popup colors meaningfully different?
   - Does the theme still work with `raised=false`?
   - Does the theme still work with `raised=true` using solid flat offsets only?
   - Is contrast acceptable for text, focus, disabled, hover, pressed, and selected states?
   - Does any style become a one-hue palette?
   - Does any style rely on textures, patterns, gradients on chrome, or pixel art?
8. After approval, update production token generation and binding table mappings.
9. Update `DESIGN_TOKENS.md`, `THEME-DIRECTIONS.md`, and showcase notes to match the approved direction.

## Approval-Gate Mockup Findings

The approval-gate mockup currently supports the direction, with caveats.

Findings:

- Pulse reads much closer to the LDtk reference when default control families are separated: amber actions, blue menus, yellow selection, green range/status, dark blue inputs, and red only for danger.
- Daybreak gains a clearer identity as pine/teal plus amber/mint/aqua. It still needs amber to remain visible in production so it does not collapse into "green Slate."
- Slate can stay restrained without becoming generic if icy action/select roles, steel menu roles, graphite inputs, and mint/amber semantic states are all authored separately.
- Burst reads distinct from Bubble when gold is the action role, violet is the menu/navigation family, cyan is selection, and lime is range/status.
- Bubble only becomes faithful to the mobile-game reference when cream/sky panels and a blue action family are allowed. This requires shell-local and component-local foreground roles; a single global dark-theme text color is not enough.
- The proposed role foreground/background pairs pass AA contrast in the current mockup data. A local script verified ten source colors across all five theme strategies, including hover/pressed/disabled state pairs, with no low-contrast role badges and no ordinary role leakage into the broadened red-family guardrail.
- Browser screenshot verification is intentionally not required for this review pass. Script-level mockup verification is enough until the implementation branch needs rendered Godot proof.

Remaining caveats:

- The HTML is still a target mockup, not production proof. Implementation must replace CSS layout conveniences with actual Godot `Theme` slots, styleboxes, constants, icon modulation, and generated textures.
- Hover and pressed states in production should be authored or deterministically derived as explicit colors, with foreground recomputed per state.
- Bubble's light islands are a product decision, not just an implementation detail. Approving this mockup approves that exception to the older dark-first interpretation.

## Implementation Direction After Mockup Approval

Likely production changes:

- Replace the normal public color workflow with `source_color`.
- Keep `base_color` and `accent_color` only as migration/advanced compatibility fields if needed.
- Add per-style authored palette data to `STYLE_PERSONALITY` or a new adjacent constant.
- Generate richer role tokens from `source_color` and the active style's color strategy.
- Replace global static semantic colors with per-style semantic colors.
- Change default `Button` bindings to use `action_fill` instead of `button_normal`.
- Change default `OptionButton`/`MenuButton` bindings to use a distinct menu/control role.
- Change input controls to use `input_fill` and a theme-specific border role.
- Strengthen selected `TabBar`, `ItemList`, and `Tree` states.
- Keep type variations, but treat them as optional explicit semantic tools rather than the only path to color identity.
- Add regression screenshots or visual probes that confirm default controls show multiple roles per style.

## Open Decisions

1. Use one source color or keep base plus accent?
   - Recommendation: use one public `source_color` for the rework. Keep old fields only for migration or advanced compatibility if required.

2. Should Bubble be allowed to use light cream/sky panels inside a dark outer shell?
   - Recommendation: yes, if contrast passes. Otherwise Bubble cannot fully hit the mobile-game reference.

3. Should Daybreak inherit any emotional DNA from the rejected Boardwalk Sunset direction?
   - Recommendation: yes, but only the flat warm/welcoming mood. No textures, no wood/leather, no brown-heavy theme, no sunset gradient chrome.

4. Should the base `Button` become colored by default?
   - Recommendation: yes. If default `Button` remains base-derived and color is reserved for variations, the core problem persists.

5. Should LDtk-like per-item colors be supported automatically?
   - Recommendation: no for v1 global Theme. Emulate the feeling through control-family color mapping. Document app-specific per-item color as requiring custom controls, item metadata, custom drawing, or optional variations.

6. Should NeoCade implement full Material HCT/CAM16 immediately?
   - Recommendation: not as a blocker. Start with deterministic Godot-local hue/chroma/tone-style helpers plus contrast checks, then consider a fuller HCT port only if HSV/luminance results fail the mockup and probe gates.
