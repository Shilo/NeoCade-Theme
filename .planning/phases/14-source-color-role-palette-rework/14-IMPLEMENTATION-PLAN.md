# Phase 14 Implementation Plan - Source Color Role Palette Rework

Date: 2026-05-13  
Branch: `feat/signature-visual-moves`  
Status: Reviewed and patched after Claude/OpenCode/Codex review plus user breaking-change decision  
Planning baseline merged to `main`: yes, merge commit `901c412`

## Goal

Replace NeoCade's normal color workflow with `style + source_color`, so every built-in style generates a distinct multi-role palette out of one public source color. The result must make default Godot Controls feel different out of the box, without requiring users to opt into Button/node variations for ordinary identity.

The implementation must preserve the existing architecture:

- one concrete `@tool class_name NeoCadeTheme extends Theme`;
- one canonical resource at `res://addons/neocade_theme/neocade_theme.tres`;
- no per-style `.gd`, no per-style `.tres`, no `_dev/`, no texture/pattern/gradient chrome;
- all changes flow through `_regenerate_theme()`, `STYLE_PERSONALITY`, and `BINDING_TABLE`-style recipes.

## Approved Design Inputs

- `.planning/research/THEME-COLOR-IDENTITY-RETHINK.md`
- `.planning/research/THEME-COLOR-IDENTITY-REVIEW-2026-05-13.md`
- `.planning/mockups/color-identity/theme-color-identity-approval-gate.html`
- `.planning/DESIGN_TOKENS.md`

Approved preset `source_color` values:

| Style | Source | Identity Target |
| --- | --- | --- |
| Pulse | `#3AA8FF` | LDtk-inspired control-family taxonomy: amber actions, blue menus, yellow selections, green ranges/positive states. |
| Daybreak | `#76F2D1` | Bright dawn/coastal mint: pine/teal shell, amber action, aqua selection, mint range. |
| Slate | `#8BD3FF` | Restrained futuristic/iOS-adjacent cool palette: graphite shell, icy action/selection, quiet source response. |
| Burst | `#FFD166` | Arcade reward energy: gold actions, violet menus, cyan selection, lime range/status. |
| Bubble | `#57C7FF` | Flat 3D mobile-game spirit: dark outer shell, light cream/sky islands, blue actions, lavender headers, yellow rewards, green confirms. |

## Non-Goals

- Do not add light/dark mode variants yet.
- Do not add a second normal color knob for built-in styles.
- Do not require default Controls to use `theme_type_variation` to show identity.
- Do not implement full Material HCT/CAM16 in this pass unless the Godot-local verifier fails.
- Do not remove shape/radius/spacing/raised-depth work from Phases 12/13.
- Do not introduce textures, patterns, gradients on chrome, shadows, glow, pixel-art UI, or cyberpunk/neon-noir language.

## Hard Decisions

### 1. Public Color Contract

Normal public workflow becomes:

- `style`
- `source_color`
- existing non-color overrides: `corner_radius`, `spacing`, `raised_strength`, `focus_thickness`, `outline_width`
- existing mode toggles: `raised`, `platform`
- existing advanced toggles: `use_runtime_popup_selection_icons`, `texture_cache`

This is a forward-breaking color API change. There is no backwards compatibility requirement for old `base_color` / `accent_color` resources.

Implementation target:

- Add `@export var source_color: Color`.
- Remove `base_color` and `accent_color` exports from the script.
- Do not add `@export_storage` compatibility fields.
- Do not add `_color_contract_version`.
- Rewrite the canonical `neocade_theme.tres` with `source_color` and without `base_color` / `accent_color`.
- Treat old user resources that serialized `base_color` / `accent_color` as incompatible with this branch. The documented update path is manual: recreate or resave with `source_color`.

Consequences:

- No deserialization migration helper is needed.
- No hidden setter path may influence the generated palette.
- `source_color` is the only color source for built-in and custom styles.
- Forward breakage is acceptable by explicit user decision on 2026-05-13.

### 2. Built-In Style Export Sync

`STYLE_EXPORTS` should carry the new preset `source_color` values plus the existing non-color style exports.

When selecting a built-in style:

1. Set `source_color` from the style preset.
2. Set corner/spacing/raised/focus/outline exports from the style preset.

`_exports_match_style()` must compare `source_color` and non-color exports only.

Wave ordering guard:

- Do not commit or ship a state where `source_color` exists but `_regenerate_theme()` still derives surfaces, text, and roles from removed `base_color` / `accent_color`.
- Land Wave 1 and Wave 2 as one atomic implementation slice: public color export replacement and role palette generation must move together.
- Binding migration follows after the role palette exists.

### 3. Color Space

Ship v1 of this rework with deterministic Godot-local HSV + WCAG helpers:

- Hue uses `Color.h`.
- Chroma/saturation uses `Color.s` plus guardrails.
- Tone uses `Color.v` and WCAG relative luminance checks, not raw value alone.
- Every final foreground uses contrast ratio against the actual generated fill.

Do not port HCT/CAM16 in this pass. The mockup uses HSL as a browser stand-in; production may differ numerically as long as the role bands, identity goals, red guardrail, and contrast verifier pass.

`is_light` decision:

- `is_light` must no longer derive from removed `base_color`.
- The new derivation source is generated `surface_fill` after the style color strategy resolves the shell/background role.
- Existing branches that still need a broad light/dark decision use this generated surface luminance only as a fallback. Text/icons for actual controls must use role-specific `on_*` foregrounds.
- Gate 1 must assert `is_light == (surface_fill.get_luminance() >= 0.5)` for every built-in preset and stress source.

### 4. Bubble Light Islands

Bubble keeps a dark shell plus light cream/sky panels and dialogs. This is an approved exception to the older "all built-ins are dark-only surfaces" interpretation, not a light-mode variant.

Consequence:

- Composite controls compute their own `on_*` colors automatically.
- Free `Label` / `RichTextLabel` cannot infer parent background. Add v1 label variations for non-default surfaces, at minimum:
  - `PanelLabel`
  - `PopupLabel`
  - `DialogLabel`
  - `DialogHeaderLabel`
  - `OnActionLabel`
  - `OnSelectionLabel`
  - `OnPositiveLabel`
  - `OnDangerLabel`

Default `Label` / `RichTextLabel` still use `on_surface`.

### 5. Positive vs Success

- `positive_fill` is for affirmative actions, but it is exposed through the existing `PrimaryButton` variation rather than a second public positive button type.
- `success_fill` is for feedback state: valid/saved/completed/healthy status surfaces and explicit `Success*` variations.
- `DangerButton` remains destructive/error only.

Do not add `PositiveButton` or `NegativeButton`. Keep the public semantic button set small:

- `PrimaryButton` uses `primary_action_fill`, which aliases the theme's `positive_fill` ramp for confirm/apply/save/high-emphasis actions.
- `PrimaryButton` must differ visually from default `Button` through fill and/or stylebox emphasis.
- `DangerButton` uses `danger_fill` and is the only destructive/negative Button variation.

### 6. Review Findings Accepted / Rejected

Accepted from Claude/OpenCode/Codex reviews:

- `is_light` must derive from generated `surface_fill`.
- `PrimaryButton` needs a precise high-emphasis role and must differ from default `Button`.
- `PrimaryButton` must be the single public affirmative/high-emphasis Button variation; a separate `PositiveButton` is rejected as redundant.
- Slot coverage must enumerate actual `BINDING_TABLE.keys()` and `TYPE_VARIATIONS`, not only a hand-picked representative list.
- Gate checks must include icon/glyph foregrounds, radio/check slots, PopupMenu generated check/radio icons, `SplitContainer`, `ScrollContainer`, `RichTextLabel`, and dialog types.

Rejected because of the explicit breaking-change decision:

- Backward-compatible `@export_storage` fields.
- `_color_contract_version`.
- old `.tres` migration helpers.
- post-deserialization migration fixtures for old resources.

## Current Code Map

Key files:

- `addons/neocade_theme/scripts/neocade_theme.gd`
- `addons/neocade_theme/neocade_theme.tres`
- `showcase/showcase.tscn`
- `showcase/showcase.gd`
- `README.md`
- `.planning/DESIGN_TOKENS.md`
- `.planning/PROJECT.md`
- `.planning/REQUIREMENTS.md`
- `.planning/ROADMAP.md`
- `.planning/STATE.md`
- `AGENTS.md`

Important current implementation points:

- `base_color` and `accent_color` are exported under `Style Overrides`.
- `is_light` is derived from `base_color.get_luminance()`.
- Surface ramp, button colors, role tokens, text colors, and semantic colors are generated directly inside `_regenerate_theme()`.
- `role_primary` equals `accent_color`.
- Default Button still flows through `button_normal` derived from `base_color`.
- Many default control recipes still use `button_normal` and `role_primary`.
- Phase 13 added semantic label/panel variations that already bind to `role_success`, `role_warning`, `role_danger`, and `role_info`.

## New Internal Role Model

### Control-Facing Aliases

The implementation should generate these aliases once per regeneration:

- `surface_fill`
- `panel_fill`
- `popup_shell`
- `dialog_header`
- `action_fill`
- `menu_fill`
- `input_fill`
- `selection_fill`
- `tab_selected_fill`
- `range_fill`
- `toggle_fill`
- `positive_fill`
- `danger_fill`
- `success_fill`
- `warning_fill`
- `info_fill`
- `separator_fill`
- `link_text`
- `focus_ring`
- `raised_offset_*`

Do not create one alias per Godot slot. Slot-specific hover/pressed/disabled/read-only colors are derived state recipes from these aliases.

### Role Table Shape

Add role-table entries for canonical aliases. Do not keep legacy base/accent names as final public/internal contract.

- Canonical keys: `action_fill`, `action_hover`, `action_pressed`, `on_action`, `action_offset`, etc.

Legacy cleanup should be intentional:

- Replace `button_normal` recipes with explicit aliases such as `action_fill`, `panel_fill`, `input_fill`, or `menu_fill`.
- Replace `role_primary` recipes with explicit aliases such as `focus_ring`, `selection_fill`, `range_fill`, `toggle_fill`, `link_text`, or `primary_action_fill`.
- If a temporary local variable exists during the mechanical edit, it must not survive the final verifier gate as the source for menu/input/selection/range/toggle.
- Do not let any generic legacy accent role remain the only source of menu, selection, range, and toggle color.

The role coverage verifier must prove no default Control family is still accidentally getting all personality from old base/accent roles.

### Style Color Strategies

Add `STYLE_COLOR_STRATEGIES` or an adjacent constant keyed by `Style`.

Each style strategy should contain:

- `source_color` preset;
- shell/surface anchors;
- role anchors for action/menu/input/selection/tab/range/toggle/positive/danger/success/warning/info;
- source pull amount and max hue drift;
- saturation/value influence;
- safe fallback hue for ordinary roles;
- flags for warm-cream allowance where relevant;
- state-layer parameters if a role family needs stronger/lighter hover/pressed behavior.

The strategy should be data, not branching code scattered through the binding table.

### State Generation

Create a helper that derives a small state bundle from a fill:

- `normal`
- `hover`
- `pressed`
- `disabled`
- `border`
- `offset`
- `on_normal`
- `on_hover`
- `on_pressed`
- `on_disabled`

Foregrounds must be recomputed per state using contrast against that state fill. Do not reuse `on_action` for `action_pressed` unless it still passes.

## Binding Migration Map

### Background / Surface

Use:

- root/editor broad backgrounds: `surface_fill`
- panels/cards/foldable bodies/graph bodies: `panel_fill`
- popup/dialog bodies: `popup_shell`
- dialog headers, graph node titlebars, foldable headers: `dialog_header`
- separators/split bars/grid lines: `separator_fill`

Keep `ScrollContainer` visually empty unless a type variation explicitly needs a visible shell.

### Default Action

Use `action_fill` for normal Button-family faces:

- `Button.normal`
- `TextureButton` only if a generated fallback texture/modulate path exists; otherwise texture-driven and out of scope for flat fills.
- `ColorPickerButton` face and picker affordance chrome.
- Editor property child button faces where they are visible and not content-colored.

Button font/icon colors should use `on_action` state colors.

### Menu

Use `menu_fill` for:

- `OptionButton`
- `MenuButton`
- `MenuBar`
- popup hover/menu row surfaces
- popup check/radio icons where the icon generator currently uses `role_primary`

### Inputs

Use `input_fill` for:

- `LineEdit`
- `TextEdit`
- `CodeEdit`
- `SpinBox`
- `TreeLineEdit`
- input selection/caret roles, with foregrounds recomputed.

### Selection / Tabs

Use:

- `selection_fill` for `ItemList.selected`, `Tree.selected`, selected popup rows, and selection highlights.
- `tab_selected_fill` for `TabBar.tab_selected` and selected `TabContainer` tab faces. It may derive from `selection_fill` in v1, but must exist as a role-table alias.

### Range / Toggle

Use:

- `range_fill` for `ProgressBar.fill`, slider grabbers/tracks, scrollbar grabbers, and range value labels.
- `toggle_fill` for `CheckBox`, `CheckButton`, radio/check glyphs, and checked/on state colors.

`CheckBox` and `CheckButton` should not inherit plain Button's action color blindly.

### Semantic Variations

Use:

- `PrimaryButton`: `primary_action_fill` / `text_on_primary_button`; `primary_action_fill` aliases the affirmative `positive_fill` ramp in this rework.
- `DangerButton`: `danger_fill` / `on_danger`.
- `SuccessLabel`, `WarningLabel`, `DangerLabel`, `InfoLabel`: `success_fill`, `warning_fill`, `danger_fill`, `info_fill` or their text roles as appropriate.
- `SuccessPanel`, `WarningPanel`, `DangerPanel`, `InfoPanel`, `AccentPanel`: semantic fill roles with local foregrounds.

No `PositiveButton` or `NegativeButton` variation ships in v1. Default `Button` still carries `action_fill`, so the theme's core identity is visible without any type variation.

### Links / Passive Text

Use:

- `link_text` for `LinkButton` and rich text links, measured against the surrounding surface/panel.
- Default `Label` / `RichTextLabel`: `on_surface`.
- New surface-specific Label variations for panel/popup/dialog/action/selection/positive/danger contexts.
- Add RichTextLabel counterparts where the slot names differ enough that Label variations cannot cover them, at minimum `PanelRichTextLabel` and `DialogRichTextLabel`. If popup rich text is not implemented in v1, document that consumers should use `DialogRichTextLabel` or local overrides for rich text on non-default surfaces.

### Intentional Texture/Content Exclusions

Do not force flat fills onto controls whose visible surface is content- or texture-driven unless a generated fallback texture path already exists:

- `TextureButton`
- `TextureProgressBar`
- `TextureRect`
- `NinePatchRect`
- `VideoStreamPlayer`

These may receive icon modulation, fallback textures, or surrounding panel roles where Godot exposes them, but they are not part of the default role-fill proof.

### Separator Foregrounds

`separator_fill` is fill-only for normal separators, split bars, graph guides, and grid/guide lines. Generate `on_separator` only if a specific labeled/glyph-bearing variation needs it; do not require meaningless separator text states.

## Verification Gates

Create Phase 14 helpers under `.planning/phases/14-source-color-role-palette-rework/helpers/`.

### Gate 1 - Export Contract

Headless verifier asserts:

- `source_color` exists and is visible.
- `base_color` and `accent_color` are absent from the public export/property contract.
- selecting built-in style applies the expected preset `source_color`.
- `_exports_match_style()` depends only on `source_color` and non-color exports.
- canonical `neocade_theme.tres` loads as `NeoCadeTheme` and regenerates.
- setting `source_color` to a non-preset value regenerates once and does not recurse beyond the `_regenerating` guard.
- `is_light` matches generated `surface_fill`.
- no code path in `_regenerate_theme()` reads `base_color` or `accent_color`.

### Gate 2 - Role Generation Matrix

For each built-in style and each source stress input:

- preset source;
- red/hot-pink source `#FF5F6F`;
- gray source `#777777`;
- white source `#FFFFFF`;
- black source `#000000`;
- green source `#40E070`;
- blue source `#2E8BFF`;
- orange source `#FF8A00`;

Assert:

- every canonical role exists;
- every visible role changes when `source_color` changes unless the source is intentionally achromatic and the style strategy clamps influence;
- each style remains in its allowed mood bands;
- red-family ordinary fills are moved out of danger-adjacent hue/chroma/tone unless they are explicitly `danger_fill`;
- Bubble panel/dialog fills remain in the warm-cream or sky-island allowed zone for preset source.

### Gate 3 - Contrast / `on_*`

For every fill state generated by the role engine:

- normal;
- hover;
- pressed;
- selected;
- checked/on;
- disabled;
- read-only;
- popup hover;

Assert text/icon/glyph foreground contrast:

- normal text: WCAG AA 4.5:1 where text is expected;
- large display/primary labels: at least 3:1 only if the slot is truly large text;
- disabled may be lower but must be visibly legible against its disabled fill and not disappear.
- icon and glyph colors use the matching `on_*` role or a documented decorative exception.
- PopupMenu generated check/radio icons, disabled check/radio icons, and search/search-bar separator colors remain visible.

### Gate 4 - Godot Slot Coverage

Instantiate the generated theme and inspect actual Theme entries. Gate 4 has two layers:

1. Enumerate `BINDING_TABLE.keys()` and every registered `TYPE_VARIATIONS` entry.
2. For each visible fill/foreground slot, classify it as:
   - canonical alias-backed;
   - intentional non-fill structural slot;
   - content/texture-driven exclusion;
   - editor-only slot with documented mapping.

The following representative controls and variations must receive explicit assertions in addition to the full enumeration:

- `Button`
- `PrimaryButton`
- `DangerButton`
- `OptionButton`
- `MenuButton`
- `MenuBar`
- `PopupMenu`
- `LineEdit`
- `TextEdit`
- `CodeEdit`
- `SpinBox`
- `TreeLineEdit`
- `TabBar`
- `TabContainer`
- `ItemList`
- `Tree`
- `ProgressBar`
- `HSlider` / `VSlider`
- `HScrollBar` / `VScrollBar`
- `CheckBox`
- `CheckButton`
- `RadioButton`
- `Panel`
- `PanelContainer`
- `ScrollContainer`
- `PopupPanel`
- `Window`
- `AcceptDialog`
- `ConfirmationDialog`
- `FoldableContainer`
- `GraphEdit`
- `GraphNode`
- `GraphFrame`
- `SplitContainer`
- `Separator`
- `RichTextLabel`
- `LinkButton`
- `TooltipPanel` / `TooltipLabel`
- `FileDialog`
- `ColorPicker` / `ColorPickerButton` / `ColorPresetButton`

Assert that visible default control families resolve through the intended aliases, not generic old accent/base roles.

Minimum negative checks:

- `Button.normal` fill differs from `OptionButton.normal`/`MenuButton.normal` in at least Pulse, Burst, and Bubble.
- `Button.normal`, `LineEdit.normal`, `TabBar.tab_selected`, and `ProgressBar.fill` are not all the same hue family in any preset style.
- menu/input/selection/range/toggle controls are not driven by old `role_primary` / old `accent_color` behavior.
- `PrimaryButton` differs from default `Button`.
- Bubble `surface_fill` is dark while Bubble `panel_fill` / `popup_shell` are light, and their foregrounds flip accordingly.
- `RadioButton`, `CheckBox`, and `CheckButton` use toggle semantics rather than plain action semantics.
- Actual Godot radio/check slots are asserted, including `CheckBox.radio_checked`, `CheckBox.radio_unchecked`, disabled radio slots, checkbox slots, CheckButton on/off slots, and PopupMenu radio/check generated icons.

### Gate 5 - Existing Verifiers

Run or adapt existing Phase 12/13 helpers:

- `_phase12_verify_headless.gd`
- `_phase12_smoke_matrix.gd`
- `_phase13_verify_headless.gd`
- `_phase13_smoke_matrix.gd`

They must still pass after the rework or be intentionally updated with documented changed expectations.

### Gate 6 - Performance

Compare `_last_regeneration_usec` before/after:

- one default regeneration per built-in style;
- a source-color change loop across stress inputs;
- texture cache on/off.

Target: no material regression for normal theme regeneration. If slower, document the cost and cache strategy.

## Implementation Waves

### Wave 0 - Baseline and Harness

Files:

- `.planning/phases/14-source-color-role-palette-rework/helpers/_phase14_export_contract.gd`
- `.planning/phases/14-source-color-role-palette-rework/helpers/_phase14_role_palette_probe.gd`
- `.planning/phases/14-source-color-role-palette-rework/helpers/_phase14_contrast_probe.gd`
- `.planning/phases/14-source-color-role-palette-rework/helpers/_run-phase14-verify.ps1`

Tasks:

1. Capture baseline current export list, binding-table size, type-variation count, and verifier status.
2. Create helper scaffolds before the color rewrite so failures are attributable.
3. Add expected style preset table to helpers.
4. Add a baseline scan that records every `base_color`, `accent_color`, `button_normal`, and `role_primary` dependency so Wave 1+2 can remove or explicitly reclassify them.

Exit criteria:

- helpers run in headless Godot or fail clearly if local Godot path resolution fails;
- current baseline is recorded in `logs/`.
- stale base/accent dependency inventory is recorded.

### Wave 1 - Breaking Public Export Replacement

Files:

- `addons/neocade_theme/scripts/neocade_theme.gd`
- `addons/neocade_theme/neocade_theme.tres`
- docs after code passes.

Tasks:

1. Add `source_color` export and setter.
2. Remove `base_color` and `accent_color` exports.
3. Update `_apply_style_exports()` and `_exports_match_style()`.
4. Update `STYLE_EXPORTS` presets.
5. Rewrite the canonical resource so it serializes `source_color`.
6. Land this together with Wave 2 role generation, or do not commit it yet.

Exit criteria:

- style switching works;
- `source_color` drives regeneration;
- no infinite setter loops.
- no committed intermediate state leaves `_regenerate_theme()` dependent on removed base/accent fields.

### Wave 2 - Role Palette Engine

Files:

- `addons/neocade_theme/scripts/neocade_theme.gd`

Tasks:

1. Add color strategy data.
2. Add hue/source pull helpers.
3. Add red-family guardrail helpers.
4. Add contrast/foreground picker that tests preferred ink, dark ink, light ink, black, and white.
5. Generate canonical fill/on/state role bundles.
6. Populate role_table with canonical aliases only.
7. Replace remaining `_regenerate_theme()` base/accent derivation with generated role anchors and `source_color`.

Exit criteria:

- role matrix helper passes for all styles and stress sources;
- default roles visually differ per style through actual role values;
- Bubble cream/sky islands pass allowed warm-cream/sky checks;
- `danger_fill` is the only saturated ordinary red-family role.

### Wave 3 - Binding Table Migration

Files:

- `addons/neocade_theme/scripts/neocade_theme.gd`

Tasks:

1. Rebind default Button-family styleboxes/colors to `action_*`.
2. Rebind OptionButton/MenuButton/MenuBar/PopupMenu to `menu_*`.
3. Rebind input controls to `input_*`.
4. Rebind selection/list/tree/tab slots to `selection_*` / `tab_selected_*`.
5. Rebind range/toggle controls to `range_*` / `toggle_*`.
6. Rebind panels/popups/dialogs/background controls to `surface_fill`, `panel_fill`, `popup_shell`, `dialog_header`.
7. Rebind LinkButton/rich text links to `link_text`.
8. Keep texture/content-driven controls documented and avoid fake fills where Godot does not expose one.

Exit criteria:

- slot coverage helper proves default controls no longer collapse to base/accent only;
- existing Phase 12/13 verifiers still pass or are updated with documented expected color changes.

### Wave 4 - Semantic and Label Variations

Files:

- `addons/neocade_theme/scripts/neocade_theme.gd`
- `showcase/showcase.tscn`
- `showcase/showcase.gd` only if needed for picker/source controls.

Tasks:

1. Remove the redundant planned `PositiveButton` variation and do not add `NegativeButton`.
2. Keep `PrimaryButton` in `TYPE_VARIATIONS` as the single affirmative/high-emphasis action variation.
3. Pin `PrimaryButton` to `primary_action_fill`, with `primary_action_fill` mapped to the style's affirmative `positive_fill` ramp.
4. Keep `DangerButton` mapped to `danger_fill`.
5. Reconcile `SuccessLabel`, `WarningLabel`, `DangerLabel`, `InfoLabel`.
6. Reconcile `AccentPanel`, `InfoPanel`, `WarningPanel`, `DangerPanel`, `SuccessPanel`.
7. Add surface-context Label/RichTextLabel variations required by Bubble light islands.
8. Add showcase examples for source-color picker and Label-on-panel/Label-on-dialog contrast.

Exit criteria:

- semantic variations are optional and do not carry the default theme identity alone;
- Bubble label-on-cream case is visibly/readably covered;
- `PrimaryButton` and `DangerButton` are distinct and semantically correct.
- `PrimaryButton` is the only public positive/affirmative button variation; `success_fill` remains feedback/state semantics.

### Wave 5 - Documentation and Resource Sync

Files:

- `AGENTS.md`
- `.planning/PROJECT.md`
- `.planning/REQUIREMENTS.md`
- `.planning/ROADMAP.md`
- `.planning/STATE.md`
- `.planning/DESIGN_TOKENS.md`
- `README.md`
- any usage docs present in repo.

Tasks:

1. Update public export count and names.
2. Document source-color workflow.
3. Document that `base_color` / `accent_color` were removed as a breaking color API change.
4. Document Bubble dark-shell/light-island exception.
5. Document Positive vs Success.
6. Update canonical resource details.

Exit criteria:

- docs no longer say normal customization is `base_color + accent_color`;
- docs do not promise automatic foreground correctness for arbitrary free Labels without variations;
- roadmap/state reflect Phase 14 as active/completed depending on code status.

### Wave 6 - Full Verification and Commit

Tasks:

1. Run Phase 14 helpers.
2. Run Phase 12/13 helpers.
3. Run `git diff --check`.
4. If Godot CLI is available, run headless import/load smoke.
5. Capture logs under `.planning/phases/14-source-color-role-palette-rework/logs/`.
6. Commit the implementation in atomic chunks if possible:
   - source export replacement + palette engine;
   - binding migration;
   - semantic/label/showcase;
   - docs/verifiers.

Exit criteria:

- all required helpers pass;
- no untracked generated junk outside planned logs/artifacts;
- branch pushed after final implementation commit.

## Acceptance Criteria

1. A user can select any built-in style and adjust only `source_color`; every visible role palette changes dynamically.
2. Pulse, Daybreak, Slate, Burst, and Bubble remain recognizable and mood-distinct under preset source colors.
3. Default controls show role variety without variations:
   - Button != OptionButton/MenuButton != input != selection != range/toggle.
4. `PrimaryButton` and `DangerButton` exist for explicit semantic intent; `PositiveButton` and `NegativeButton` do not ship.
5. `success_fill` is not confused with `positive_fill`.
6. No ordinary default control uses saturated red/coral/hot-pink unless it is danger/error.
7. Every generated fill has a state-appropriate foreground with verified contrast.
8. Bubble dark shell + light islands works with explicit panel/dialog label variations.
9. Old resources with `base_color` / `accent_color` are allowed to break; docs clearly state this forward-breaking change and the manual recreate/resave path.
10. The implementation remains one class, one canonical resource, and no per-style assets.

## Known Risks and Countermeasures

| Risk | Countermeasure |
| --- | --- |
| HSL mockup differs from Godot HSV output. | Verifier checks identity bands, contrast, and guardrails rather than exact mockup hex values. |
| BINDING_TABLE migration is too large to review safely. | Add role aliases first, migrate one control family at a time, run coverage helper after each family. |
| Existing editor integration slots rely on `role_primary` semantics. | Replace `role_primary` with explicit aliases; editor slots need documented mappings or exclusions. |
| Bubble free Labels fail on cream islands. | Add v1 surface-specific Label/RichTextLabel variations and showcase examples. |
| Source changes feel too subtle for Slate. | Verifier includes source-response checks; Slate may stay restrained, but changes must be measurable. |
| Red guardrail overcorrects warm cream or amber. | Chroma/tone-aware checks allow warm cream/ivory; stress matrix catches saturated danger-adjacent leaks. |

## Review Questions for Claude and OpenCode

1. Is the breaking export replacement strategy sound now that backwards compatibility is intentionally out of scope?
2. Are the implementation waves ordered safely?
3. Does the plan overfit to the HTML mockup instead of Godot Theme realities?
4. Are any Controls or slot families missing from the binding migration map?
5. Are the verifier gates strong enough to catch wrong `on_*` foregrounds, red ordinary roles, and accidental base/accent regressions?
6. Is `PrimaryButton` sufficiently pinned as the single high-emphasis affirmative `primary_action_fill` role while `DangerButton` owns destructive semantics?
7. Are there any remaining accidental compatibility assumptions that should be removed before implementation?

## Next Action After Review

After Claude, OpenCode, and the Codex subagent review this plan:

1. Challenge findings.
2. Patch this plan if relevant.
3. Begin Wave 0 and Wave 1 implementation.
