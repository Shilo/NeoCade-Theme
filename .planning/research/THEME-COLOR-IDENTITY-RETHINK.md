# Theme Color Identity Rethink

Date: 2026-05-13
Status: research and planning draft
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

## Export Strategy Recommendation

Recommendation: keep `base_color` and `accent_color` for v1 compatibility, but reinterpret them internally.

Proposed meaning:

- `base_color`: surface and environment source.
- `accent_color`: interactive palette source.

Do not remove `accent_color` yet. Removing it creates public API churn and makes dark themes harder to control because one source must define both environment and interaction. Instead, built-in styles should get richer authored palette personalities, while `CUSTOM` can derive a role palette from `base_color` plus `accent_color`.

Future option:

- A later breaking version could introduce a single `source_color` or `palette_source_color` export with MD3-like generated roles. That should be a separate API decision, not a prerequisite for fixing the built-in styles now.

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
- `menu_hover_fill`
- `focus_ring`
- `panel_mark`

Each built-in style can map these aliases differently. This is the key change: Pulse, Daybreak, Slate, Burst, and Bubble should not share the same component color mapping.

## Theme Goals

### Pulse

Goal: LDtk-inspired arcade editor panel.

Pulse should feel flat, dense, sharp, utilitarian, and color-taxonomic. Color should behave like a control-panel language: active rows, tools, entities, menu strips, and panels each have a clear job. This is the strongest candidate for multiple default control-family colors.

Proposed mood words: editor, cabinet, taxonomy, sharp, mixed-color, dense.

Proposed color language:

- Environment: deep blue-black and charcoal navy.
- Default actions: orange or red-orange.
- Active tabs and selected rows: yellow/gold.
- Inputs and option controls: blue or steel.
- Positive/help/toggles: green.
- Danger/destructive: red.

### Daybreak

Goal: warm daylight translated into a flat dark-friendly UI.

Daybreak currently has the least clear identity. It should become the welcoming, public, social, early-morning arcade theme: warm light, teal shade, soft coral highlights, mint freshness, and readable cream-tinted panels.

This can borrow the useful emotional lesson from the old Boardwalk direction without reviving rejected texture, wood, leather, sunset-gradient, or brown-heavy choices.

Proposed mood words: welcoming, sunrise, social, clean, warm, readable.

Proposed color language:

- Environment: dark pine, deep teal, or blue-green shadow.
- Default actions: amber or sunrise yellow.
- Navigation and selected states: mint or seafoam.
- Inputs: muted teal/cream containers.
- Important headers or highlights: coral.
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
- Navigation and selected states: coral or hot pink.
- Inputs: violet/blue containers.
- Range/progress/check states: cyan or lime.
- Danger: punchy red-pink.

### Bubble

Goal: flat 3D mobile game UI.

Bubble should lean hard into the HCGames/Renderman-style mobile UI reference: chunky, playful, touch-first, candy colors, pink ribbons, blue buttons, cream panels, yellow rewards, and green confirms.

The current dark berry plus pink direction captures only a fraction of that. To hit the reference, Bubble likely needs either a light/default variant later or a v1 compromise where the outer shell remains dark but panels and dialogs can become cream/sky islands.

Proposed mood words: mobile game, candy, chunky, friendly, puffy, reward.

Proposed color language:

- Environment: dark berry/navy shell for v1 dark compatibility.
- Panels/dialog islands: cream, peach, or sky blue.
- Default actions: pink or bright blue.
- Secondary actions: sky blue.
- Rewards/warnings: yellow/gold.
- Confirms/success: green.
- Disabled/locked: muted blue-gray.

Reference:

- [Flat Game UI for Mobile Games](https://hcgamestudios.itch.io/flat-game-ui-for-mobile-games)

## Default Control Color Matrix

This is the proposed "no variations required" mapping. Exact values should be tested in mockups before implementation.

| Theme | Button | Option/Menu | Input | Selected Tab | List/Tree Selection | Range/Progress | Toggle/Check | Popup/Dialog |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Pulse | orange/red-orange fill | blue/steel | dark blue with bright border | yellow/gold filled or strong strip | gold or role-coded row with colored rail | green or cyan | green | dark panels with colored category headers |
| Daybreak | amber fill | mint/teal | pine/cream-tinted input | mint selected state | mint/amber selected container | aqua or mint | mint | coral/amber highlights on warm dark panels |
| Slate | icy blue quiet fill or outline | steel/lavender | graphite with blue-gray border | icy blue selected state | blue-gray selected container | cyan/blue | mint/blue | graphite panels with cool blue accents |
| Burst | gold fill | coral/pink | violet/blue | coral or hot pink selected state | gold/coral selected container | cyan/lime | lime/cyan | plum panels with bright statement headers |
| Bubble | pink or blue chunky fill | sky blue | cream/sky input island | pink selected ribbon/tab | blue or pink selected tile | yellow/blue | green | cream panels with pink headers |

## Mockup Plan

Before changing production code, create Godot-feasible mockups.

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

## Implementation Direction After Mockup Approval

Likely production changes:

- Add per-style authored palette data to `STYLE_PERSONALITY` or a new adjacent constant.
- Generate richer role tokens from `base_color`, `accent_color`, and style palette overrides.
- Replace global static semantic colors with per-style semantic colors.
- Change default `Button` bindings to use `action_fill` instead of `button_normal`.
- Change default `OptionButton`/`MenuButton` bindings to use a distinct menu/control role.
- Change input controls to use `input_fill` and a theme-specific border role.
- Strengthen selected `TabBar`, `ItemList`, and `Tree` states.
- Keep type variations, but treat them as optional explicit semantic tools rather than the only path to color identity.
- Add regression screenshots or visual probes that confirm default controls show multiple roles per style.

## Open Decisions

1. Keep `base_color` plus `accent_color` for v1, or introduce a single source-color model now?
   - Recommendation: keep both for v1 and use them as sources for richer internal roles.

2. Should Bubble be allowed to use light cream/sky panels inside a dark outer shell?
   - Recommendation: yes, if contrast passes. Otherwise Bubble cannot fully hit the mobile-game reference.

3. Should Daybreak inherit any emotional DNA from the rejected Boardwalk Sunset direction?
   - Recommendation: yes, but only the flat warm/welcoming mood. No textures, no wood/leather, no brown-heavy theme, no sunset gradient chrome.

4. Should the base `Button` become colored by default?
   - Recommendation: yes. If default `Button` remains base-derived and color is reserved for variations, the core problem persists.

5. Should LDtk-like per-item colors be supported automatically?
   - Recommendation: no for v1 global Theme. Emulate the feeling through control-family color mapping. Document app-specific per-item color as requiring custom controls, item metadata, custom drawing, or optional variations.

