# Editor Color Taxonomy V2

Date: 2026-05-13
Status: second design gate after readability mockup
Scope: make NeoCade colorful again without repeating the unreadable editor screenshot failure.

## Problem Statement

The first editor readability mockup fixed the obvious failure: broad text-heavy controls no longer became high-chroma yellow, pink, or red. That correction was necessary, but it risks another failure mode: every theme can drift back into one source-colored surface ladder with only a few accents.

The goal for this iteration is stricter:

- Keep dense editor/runtime text readable.
- Keep ordinary inputs and list rows calm enough for repeated work.
- Make each theme feel unique out of the box without requiring Button/Control variations.
- Restore the "colorful tool UI" feeling from the early direction board and LDtk reference.
- Avoid assigning red-family colors to ordinary actions, tabs, inputs, or list rows.

## Mature Design System Findings

### Material Design 3

Material 3 does not paint a UI by directly reusing one source color everywhere. A color scheme maps generated palettes to roles, then components consume those roles. Material Web describes a scheme as key color tones assigned to roles that map to components, and each role has a corresponding `on-*` content color.

NeoCade lesson:

- Keep `source_color`.
- Generate roles, not direct component hexes.
- Every text-bearing fill gets its own `on_*` from the final fill.
- Broad surfaces should mostly come from neutral/surface roles, while primary/tertiary style color appears in smaller interactive states.

Sources:

- https://material-web.dev/theming/color/
- https://m3.material.io/styles/color/system/how-the-system-works

### Ant Design

Ant separates system-level palettes, product-level brand color, functional colors, and neutral colors. Its docs explicitly call out restrained color use in background applications so information delivery and operational efficiency are not hurt. It also recommends keeping functional colors consistent because users attach meaning to them.

NeoCade lesson:

- A colorful editor theme still needs neutral-ish text surfaces.
- `danger_fill`, `warning_fill`, `success_fill`, and `info_fill` should stay semantic.
- Brand/theme personality belongs in action, focus, selected indicators, icons, and categorical accents, not every background.

Source: https://ant.design/docs/spec/colors/

### daisyUI

daisyUI themes are a useful colorful-system reference because a theme defines `base-100/200/300`, `base-content`, `primary`, `secondary`, `accent`, and semantic statuses such as success/warning/error. The colorful themes do not rely on one accent; they ship multiple named roles.

NeoCade lesson:

- A theme can have multiple expressive role lanes while still having base surfaces.
- NeoCade should not collapse everything into action/input/selection.
- Add categorical accent lanes for non-status color variety.

Source: https://daisyui.com/docs/themes/

### Mantine

Mantine expects color ramps with at least 10 shades per color. Its generator can derive shades from one value, but the docs warn that generated colors can have poor contrast for lighter colors like yellow, teal, and orange, so pre-generation or curated shades are often safer.

NeoCade lesson:

- Do not trust a raw source-color ramp for text-heavy controls.
- Author each theme's role anchors, then allow source-color pull within safe bounds.
- Yellow/orange source colors need special clamping for inputs, list rows, and selected fills.

Source: https://mantine.dev/theming/colors/

### Chakra UI

Chakra distinguishes raw tokens from semantic tokens. Semantic tokens are context-specific and may reference raw tokens or condition-specific values.

NeoCade lesson:

- Keep primitive generated colors internal.
- Public/internal implementation should talk in semantic roles: `input_fill`, `list_row_selected`, `category_3`, `danger_fill`.
- Component aliases can map Godot classes to those roles without inventing a new color for every Control.

Sources:

- https://chakra-ui.com/docs/theming/tokens
- https://chakra-ui.com/docs/theming/semantic-tokens

### Shopify Polaris

Polaris is conservative, but it clarifies the hazard: color should have purpose. Red means critical, green means success, and blue draws attention. It warns against using color as decoration in an admin/productivity UI.

NeoCade lesson:

- NeoCade can be more playful than Polaris, but red cannot be ordinary theme decoration.
- Categorical accents must be non-semantic by definition: swappable without changing meaning.
- If an accent color would imply "delete", "error", or "warning", do not use it as a default lane.

Source: https://polaris-react.shopify.com/design/colors

### Atlassian Accents

Atlassian's accent colors are specifically for differentiating interface elements and categorizing content. Their docs explicitly separate accents from success/warning/status roles.

NeoCade lesson:

- Add `category_*` lanes for LDtk-like color identity.
- Use them where color helps differentiate regions or content categories: dock tabs, file/tree icons, selected-row rails, badges, property-group strips, graph ports, compact indicators.
- Do not use `category_*` for danger/success/warning semantics.

Source: https://atlassian.design/foundations/color/accents

### Adobe Spectrum

Spectrum Design Data separates palette tokens, semantic color palettes, color aliases, and component-specific color tokens.

NeoCade lesson:

- A layered token model is normal for mature systems.
- NeoCade should keep component coverage broad through aliases, but the authored palette should remain semantic and categorical rather than one-off per widget.

Sources:

- https://opensource.adobe.com/spectrum-design-data/tokens/
- https://opensource.adobe.com/spectrum-design-data/tokens/semantic-color-palette/

### Catppuccin, Monokai Pro, And VS Code Themes

Editor themes get rich color from explicit editor slots, syntax tokens, icon colors, and named accent palettes. Catppuccin ships multiple variants with pastel accents over controlled bases. Monokai Pro advertises dark/light schemes and mood filters plus recognizable file icons. VS Code exposes a large workbench color surface for activity bars, lists, badges, tabs, input backgrounds, foregrounds, and contrast borders.

NeoCade lesson:

- Highly colorful editor UIs are usually not "one color algorithm painted broadly."
- They combine stable surfaces with many named slot colors.
- NeoCade needs enough role slots to express the editor, but not so many public knobs that users must configure everything.

Sources:

- https://catppuccin.com/palette/
- https://github.com/catppuccin/catppuccin
- https://monokai.pro/
- https://code.visualstudio.com/api/references/theme-color

### Casual And Mobile Game UI

Casual/mobile game UI references are the strongest reminder that "colorful" does not mean "every component is saturated." The common pattern is:

- Broad panels are readable islands: cream, sky, navy, blue-gray, purple, or muted green.
- Text inputs are often pale/neutral fields or dark low-chroma fields with strong text.
- High-chroma color appears in buttons, ribbons, badges, resource chips, progress bars, icons, tab strips, and rewards.
- Icons and item art carry much of the color variety.
- Large readable typography and simple shapes make high color density easier to parse.
- Colorful kits often provide multiple button colors, icon colors, tabs, headers, and popup styles, rather than relying on one global accent.

This matters for NeoCade because Godot Theme can map component classes and states, but it cannot know arbitrary game content. The safe translation is:

- Use readable panel/input/list foundations.
- Add more compact categorical lanes.
- Let icon/button/range/toggle/tab/rail roles carry the game UI mood.
- Keep rewards/warnings/yellows compact unless the theme is a light-island game UI like Bubble.

Reference patterns reviewed:

- HC Game Studios/Renderman flat mobile UI: sky background, pink/blue/yellow/green buttons, cream panels, strong blue/purple outlines, reward yellow used in compact stars/coins.
- LayerLab casual kits: separate assets for buttons, progress bars, tabs, chests, inputs, tickets, switches, checks, resources, and icons.
- Coco Games casual UI pack: complete popup/button/icon/shop systems described as clean, colorful, and engaging.
- Unco Games casual GUI: soft pastel cartoon look, multiple main color themes, colorful icons, tabs, panels, and headers.
- GameArt2D bright casual GUI: green/yellow vector kit described for clean, colorful mobile/casual use.
- Behance/Dribbble casual UI examples: authors repeatedly describe the target as colorful/visually rich while also clean, readable, and mobile-first.

Sources:

- https://hcgamestudios.itch.io/flat-game-ui-for-mobile-games
- https://layerlab.io/products/casual-game-gui-kit
- https://www.cocogames.in/product-page/2d-casual-game-ui
- https://uncogames.itch.io/casual-gui
- https://www.gameart2d.com/game-gui-9.html
- https://www.behance.net/gallery/227396515/Word-Quest-Casual-Mobile-Game-UIUX-Visual-Design
- https://dribbble.com/shots/27089121-Candy-Muncher-Mobile-Game-UI-Design-Fantasy-Arcade-App

## LDtk Source Review

LDtk's colorful identity is not only a theme-level palette. It is heavily content-driven and explicit:

- Entity definitions get a stored `color`.
- Enum values get stored colors.
- IntGrid values and groups get stored colors.
- Auto-layer rule groups can get colors.
- JSON exports include `__smartColor` for entities and levels.
- Fields can opt into `useForSmartColor`, which lets a field color or enum value override the default entity/level smart color.
- New colors are auto-picked from a fixed nice palette (`Endesga32`) or a colorblind palette when that setting is enabled.

Local source evidence:

- `C:\Programming_Files\ldtk-master\src\electron.renderer\Const.hx`
- `C:\Programming_Files\ldtk-master\src\electron.renderer\data\def\EntityDef.hx`
- `C:\Programming_Files\ldtk-master\src\electron.renderer\data\def\EnumDef.hx`
- `C:\Programming_Files\ldtk-master\src\electron.renderer\data\def\LayerDef.hx`
- `C:\Programming_Files\ldtk-master\src\electron.renderer\data\inst\EntityInstance.hx`
- `C:\Programming_Files\ldtk-master\src\electron.renderer\data\inst\FieldInstance.hx`
- `C:\Programming_Files\ldtk-master\src\electron.renderer\data\Level.hx`

Conclusion:

NeoCade cannot reproduce LDtk's exact variety through generic Godot Theme slots alone because Godot Theme does not know what a user's items mean. LDtk knows "this entity is Gem" and "this IntGrid value is Water"; NeoCade sees "Tree row" or "Button." The best spiritual translation is categorical lanes: implicit, reusable colors for non-semantic differentiation.

## Token Model Update

### 1. Structural Roles

These keep the editor/runtime readable.

- `surface_fill`
- `shell_fill`
- `panel_fill`
- `panel_alt_fill`
- `popup_shell`
- `dialog_header`
- `separator_fill`

### 2. Text-Heavy Component Roles

These are deliberately clamped for readability.

- `input_fill`
- `input_edge`
- `list_panel_fill`
- `list_row_hover`
- `list_row_selected`
- `text_selection_fill`
- `code_fill`

### 3. Interactive Roles

These may carry more personality because they are smaller or clearly actionable.

- `action_fill`
- `menu_fill`
- `tab_selected_fill`
- `tab_selected_indicator`
- `range_fill`
- `toggle_fill`
- `focus_ring`

### 4. Semantic Roles

These retain common meaning and should not rotate by theme identity.

- `positive_fill`
- `success_fill`
- `warning_fill`
- `info_fill`
- `danger_fill`

`PrimaryButton` should consume `positive_fill`. Do not add a separate `PositiveButton` variation unless a future Godot/API reason appears. For destructive actions, pick one public variation name and keep it singular. Current planning preference remains `DangerButton`; if existing code says `NegativeButton`, rename rather than supporting both.

### 5. Categorical Accent Lanes

These restore the color variety that LDtk gets from explicit content colors:

- `category_1_fill`
- `category_2_fill`
- `category_3_fill`
- `category_4_fill`
- `category_5_fill`
- `category_6_fill`

Rules:

- They are non-semantic accents.
- They should avoid red-family hues by default.
- They may use amber/yellow only as compact rails/chips/icons, not broad input or list fills.
- They must pass 3:1 when used as required state/affordance indicators.
- If text is placed on them, compute `on_category_*` from the actual fill.

Default places where category lanes can work without user variations:

- Active tab indicator stripes by dock area.
- Selected row rails.
- Tree/file/folder/item icon modulates where available.
- GraphEdit/GraphElement port colors and compact headers.
- FoldableContainer title rails or icons.
- PopupMenu check/radio generated icons.
- Inspector/property group accent strips.
- Small status badges and counters.
- Scroll/range accents where the role is not semantic.

## Source Color Mapping

Keep a single public `source_color`, but do not let it flatten the palette.

Each theme has authored anchors for every role. Changing `source_color` shifts those anchors, with different pull strengths:

| Role family | Pull from `source_color` | Reason |
| --- | --- | --- |
| Structural surfaces | Very low | Preserve readability and mood. |
| Inputs/lists/code | Very low to low | Avoid screenshot failure. |
| Actions/menus/tabs | Medium | Let user color personalize UI chrome. |
| Range/toggle/focus | Medium to high | Compact state indicators can carry more color. |
| Category lanes | Medium, orbit-based | Keep multi-color variety while letting source color rotate the theme. |
| Danger | Almost none | Red remains destructive/error. |
| Positive/success/warning/info | Low | Preserve semantic expectations. |

For category lanes, do not generate six tints of source color. Generate six hues from a theme-specific orbit around `source_color`, then clamp luminance/chroma per role. That keeps "one source color" workflow while still producing a multi-color palette.

## Revised Theme Identities

### Pulse

LDtk-inspired dark editor taxonomy: navy shell, blue input/menu surfaces, amber category/action markers, cyan rails, green state controls. Pulse should feel like a flat game editor, not like a yellow app.

### Daybreak

Coastal dawn: deep teal shell, mint/aqua focus and range, warm gold action, soft green and sky category lanes. It should feel bright and optimistic without becoming orange/brown or washed out.

### Slate

Futuristic/iOS-adjacent utility: graphite shell, icy blue focus, steel/lavender category lanes, restrained cyan actions. It can be quieter than the other themes, but still needs distinct lanes for tabs, rails, and icons.

### Burst

Reward/event UI: plum/indigo shell, gold action and reward markers, cyan/lime/violet lanes. It should feel celebratory, not random rainbow and not warning-yellow everywhere.

### Bubble

Flat 3D mobile-game UI: dark outer shell with cream/sky light islands, blue primary action, lavender menu/header, green confirm/toggle, yellow reward chips. Keep the current recommendation: no separate dark/light variant yet.

## Practical Guardrails For Implementation

- No broad high-chroma yellow, orange, pink, magenta, or red on `LineEdit`, `TextEdit`, `CodeEdit`, `SpinBox`, `Tree`, or `ItemList`.
- Lists and trees should get muted selected rows plus colorful rails/icons.
- If a node has text on a fill, compute the foreground from that exact fill.
- If a Label/RichTextLabel can be placed anywhere, default to `on_panel`/`on_surface` style text, not a category color.
- Category lanes are for differentiation, not status.
- Semantic status colors are separate from category lanes.
- WCAG targets remain 4.5:1 for text and 3:1 for required non-text state indicators.

## New Mockup Gate

Create a second editor mockup that is intentionally more colorful than the readability baseline:

- Keep readable input/list/value-cell fills.
- Add six category lanes and show them in tabs, rails, icons, badges, GraphEdit-like ports, and property strips.
- Show that the UI can have 4-6 visible colors without turning text fields into colored billboards.
- Include source-color stress testing to prove palette variety remains when the source color changes.

File:

- `.planning/mockups/editor-color-readability/godot-editor-color-taxonomy-mockup.html`
