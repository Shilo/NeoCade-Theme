# Phase 06: Lists, Layout, Range - Research

**Researched:** 2026-05-07 [VERIFIED: local system date]  
**Domain:** Godot 4.6.2 Theme entry authoring for Tree, ItemList, tabs, FoldableContainer, range controls, and container chrome [VERIFIED: `06-CONTEXT.md`; `logs/06-research-slot-probe.log`]  
**Confidence:** HIGH for Godot 4.6.2 slot names and local architecture; MEDIUM for exact final visual constants because they remain implementation-tunable inside locked project direction. [VERIFIED: Godot 4.6.2 local probe; `.planning/DESIGN_TOKENS.md`]

<user_constraints>
## User Constraints (from CONTEXT.md)

> Provenance: copied from `.planning/phases/06-lists-layout-range-tree-itemlist-tabs-containers-sliders-des/06-CONTEXT.md`. [VERIFIED: `06-CONTEXT.md`]

### Locked Decisions

#### Delegated Decision Mode

- **D-01:** The user explicitly delegated Phase 6 gray-area decisions to the agent: "none, use all best judgement" (typo in original: "bust judgement"). Planning should not ask the user more Phase 6 taste questions unless a hard blocker appears. Use project canon, Phase 5 patterns, Godot official slot evidence, and conservative visual judgment.
- **D-02:** Apply all four identified gray areas, not a subset: Tree/ItemList density, Tabs/Foldable headers, Range/Scroll affordances, and Container boundaries. The context below is the locked direction for all four.

#### Tree and ItemList Density

- **D-03:** Favor an editor-capable dense data-view baseline for Tree and ItemList, with NeoCade polish coming through color, focus, selected-row treatment, and subtle direction-specific shape rather than oversized row padding. These Controls must work for inspector/file/tree-like data, not only game menus.
- **D-04:** Selection should be unmistakable but not loud: selected/selected_focus/hovered_selected rows use `accent_offset` or a derived accent surface, with text remaining high-contrast. Hover and cursor states stay overlay-like. Cursor styleboxes must remain transparent or semi-transparent because Godot draws cursor overlays above content; do not make them opaque.
- **D-05:** Tree guide/relationship/drop-position colors should use outline/accent roles, not new decorative colors. Relationship lines should remain visible enough for hierarchy, but secondary to text and selected rows.
- **D-06:** Tree row constants should start from desktop density, then keep platform-token awareness for Phase 8. Do not copy godot-minimal-theme's zero vertical Tree separation blindly if it harms readability; use a small, integer, GL-safe separation if needed.
- **D-07:** ItemList follows Tree's selected/focus vocabulary but with simpler geometry. If direction-specific row shape is useful, route it through `DIRECTION_PRESETS.shape.raised_lifts.selected_row` and existing shape lookup mechanisms rather than adding public exports.

#### Tabs and Foldable Headers

- **D-08:** TabBar and TabContainer must share the same tab stylebox construction wherever slot names overlap. Active tabs read as connected to content; inactive tabs are quieter surface chips. Hover lifts contrast slightly; disabled dims through existing disabled opacity. `tab_focus` remains an outer focus ring, not a filled replacement.
- **D-09:** Use direction-specific shape values already present in `DIRECTION_PRESETS.shape` for tab personality, especially `tab_radius`, `raised_lifts.selected_tab`, and `raised_lifts.unselected_tab`. Do not add new tab-specific public exports.
- **D-10:** Tab icons should be authored in the same visual family as OptionButton/SpinBox arrows: simple, crisp, monochrome, small-size legible. Required candidates include increment/decrement/menu/close or official equivalent slots discovered by Godot 4.6 introspection.
- **D-11:** FoldableContainer header chrome should borrow from Tab/Panel language rather than Button language. The header should feel like a section control, with a clear collapsed/open affordance that reuses or mirrors Tree expand/collapse icons where possible.

#### Range and Scroll Affordances

- **D-12:** Sliders and scrollbars should be tactile but restrained. Tracks are visible enough to understand range/overflow; grabbers/filled areas carry accent or raised surface roles. Raised mode can lift handles/grabbers subtly, but the hard-offset effect must be much weaker than on PrimaryButton.
- **D-13:** HSlider/VSlider should mirror each other by transposing margins and constants, not by hand-authoring divergent visual grammar. HScrollBar/VScrollBar follow the same rule. Any direction-specific differences should come from existing tokens/presets.
- **D-14:** ProgressBar fill uses `role_primary` and background uses a low surface. If text is shown by the consuming project, font/text colors must be themed; indeterminate animation is out of pure Theme scope.
- **D-15:** Scrollbar increment/decrement/grabber icons should be added only if Godot 4.6 exposes official icon slots for the Control. Do not invent unsupported icon names. If no official slot exists for a visual affordance, use stylebox shape/color/constant coverage instead.

#### Container Boundaries

- **D-16:** ScrollContainer gets a real focus stylebox and a panel treatment only as needed to make nested overflow surfaces coherent. Avoid turning every scroll area into a nested card.
- **D-17:** Split containers should prioritize usable grab thickness and clear separation over decorative chrome. Desktop values can be moderate; platform-aware branches must preserve the ability for Phase 8 to reach mobile touch affordances.
- **D-18:** MarginContainer and layout-only containers should stay boring on purpose. Populate margin/separation constants where Godot exposes them and where the phase verifier can assert them; do not create false visual surfaces for layout helpers.

#### Icons and Verification

- **D-19:** Phase 6 icon work should cover Tree expand/collapse/check/indeterminate/sort/select affordances, TabBar/TabContainer navigation/menu/close affordances, and ScrollBar affordances only after official Godot 4.6 slot-name discovery. Use helper introspection rather than remembered slot names.
- **D-20:** Continue Phase 4/5 file discipline: addon root still contains exactly one production `.gd`; helpers live under `.planning/phases/06-.../helpers/`; direction `.tres` files stay data-only and small.
- **D-21:** The Phase 6 verifier must include a Godot 4.6 slot-name discovery step or generated seed output for the official slots being wired. This is especially important for Tree and TabBar because they have many version-sensitive slots.
- **D-22:** Focus coverage extends Phase 5's COV-09 pattern to all Phase 6 focusable Controls. Use the official `focus`, `scroll_focus`, or `tab_focus` slots as appropriate; do not invent `pressed_focus`, `checked_focus`, or similar combo slots.

### the agent's Discretion

- Exact Tree icon count and naming, provided every official Godot 4.6 slot used in Phase 6 is verified by introspection and the icon files follow the Phase 4 SVG import contract.
- Exact row heights/separation values, provided desktop density remains useful and Phase 8 can scale via existing platform tokens.
- Exact active-tab geometry per direction, provided TabBar and TabContainer remain coherent and derive from existing `shape.*` keys.
- Whether to add dedicated helper functions for list/tab/range StyleBox construction or keep them as BINDING_TABLE recipes. Prefer helpers only when they remove real duplication or prevent subtle divergence.
- Whether Tree and ItemList use one shared selected-row helper. Prefer sharing if it keeps contrast/focus behavior consistent.

### Deferred Ideas (OUT OF SCOPE)

- Popup-class and dialog theming - Phase 7.
- MenuBar, ColorPicker, GraphEdit, GraphNode, GraphFrame - Phase 7.
- Mobile-specific range/list/tabs touch-target tuning and `MOBILE-DESIGN-SPEC.md` - Phase 8.
- Showcase visual QA with populated Tree/ItemList/Tab/Foldable examples - Phase 9.
- Final focus Tab-walk and cross-platform visual QA - Phase 10.
- TYPEVAR-06 final documentation - Phase 8.
- Light mode and alternate palettes - v2.
</user_constraints>

## Project Constraints (from AGENTS.md)

- Use the single concrete `@tool class_name NeoCadeTheme extends Theme`; do not add per-direction `.gd` files, subclasses, `themes/`, `_dev/`, root `neocade_theme.tres`, or `neocade_mobile_theme.tres`. [VERIFIED: `AGENTS.md`; `.planning/DESIGN_TOKENS.md`]
- The five direction `.tres` files at addon root must stay data-only and script-linked to the one concrete class. [VERIFIED: `AGENTS.md`; current addon file listing]
- Do not call `Theme.clear()`; regeneration is additive and leaves unowned Theme Editor entries untouched. [VERIFIED: `AGENTS.md`; `addons/neocade_theme/neocade_theme.gd`]
- Verify official Godot 4.6 slot names, especially Tree, TabBar, and ScrollBar icons, before wiring. [VERIFIED: `AGENTS.md`; `06-CONTEXT.md`]
- Do not ask more Phase 6 taste questions; the user delegated gray areas to best judgment. [VERIFIED: `06-CONTEXT.md`]
- Keep production code to exactly one addon-root `.gd`; Phase 6 helpers belong under `.planning/phases/06-.../helpers/`. [VERIFIED: `AGENTS.md`; current addon file listing]
- Use `/gsd-plan-review-convergence N --opencode` for planning, not plain `/gsd-plan-phase` or plain `/gsd-review`. [VERIFIED: `AGENTS.md`]

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| COV-04 | All range controls themed: HSlider, VSlider, ProgressBar, HScrollBar, VScrollBar, SpinBox. | Phase 6 owns HSlider, VSlider, ProgressBar, HScrollBar, and VScrollBar because SpinBox icons landed in Phase 5; official Slider/ScrollBar slots were verified locally and against Godot docs. [VERIFIED: `.planning/REQUIREMENTS.md`; `05-VERIFICATION.md`; `logs/06-research-slot-probe.log`; CITED: https://docs.godotengine.org/en/4.6/classes/class_slider.html; CITED: https://docs.godotengine.org/en/4.6/classes/class_scrollbar.html] |
| COV-05 | All list/tree controls themed: ItemList, Tree, TabBar, TabContainer, FoldableContainer. | Phase 6 slot matrix enumerates Tree, ItemList, TabBar, TabContainer, and FoldableContainer styleboxes, colors, constants, fonts, font sizes, and icons. [VERIFIED: `.planning/REQUIREMENTS.md`; `logs/06-research-slot-probe.log`; CITED: Godot 4.6 class docs for Tree, ItemList, TabBar, TabContainer, FoldableContainer] |
| COV-01 | All user-facing Godot 4.6 Control classes are themed in v1 with full state coverage where applicable. | Phase 6 contributes the lists/layout/range slice; Phase 7 closes remaining popup/advanced classes. [VERIFIED: `.planning/ROADMAP.md`; `05-VERIFICATION.md`] |
| COV-07 | Container-level controls themed where chrome applies. | Phase 6 contributes ScrollContainer, SplitContainer/HSplitContainer/VSplitContainer, MarginContainer, separators, and layout separation constants where exposed. [VERIFIED: `.planning/REQUIREMENTS.md`; `logs/06-research-slot-probe.log`] |
| COV-09 | Visible focus indicator on every focusable Control. | Phase 6 should reuse Phase 5's outer-ring pattern on `focus`, `tab_focus`, and `scroll_focus`, and must not invent combo focus slots. [VERIFIED: `06-CONTEXT.md`; `05-VERIFICATION.md`; CITED: https://docs.godotengine.org/en/4.6/classes/class_theme.html] |
| TYPEVAR-06 | All variations documented in Phase 8. | Phase 6 should not finalize docs, but any list/tree/tab variation decisions must be recorded for Phase 8. [VERIFIED: `.planning/REQUIREMENTS.md`; `05-VERIFICATION.md`] |
</phase_requirements>

## Summary

Phase 6 should be planned as a slot-correction and polish phase, not as a greenfield theme rewrite: `addons/neocade_theme/neocade_theme.gd` already has baseline BINDING_TABLE entries for every Phase 6 family, but several baseline names are incomplete or wrong for Godot 4.6.2. [VERIFIED: `addons/neocade_theme/neocade_theme.gd`; `logs/06-research-slot-probe.log`]

The highest-risk implementation item is Tree: local Godot 4.6.2 reports 18 Tree styleboxes, 12 icons, 15 colors, 27 constants, 2 fonts, and 2 font sizes; current `CANONICAL_SLOT_NAMES` and BINDING_TABLE still use older shorthand and include invalid `Tree.hover` instead of valid `Tree.hovered`. [VERIFIED: `logs/06-research-slot-probe.log`; `addons/neocade_theme/neocade_theme.gd`; `.planning/research/MINIMAL-THEME-DISSECTION.md`]

The second risk is stale guessed slot names around FoldableContainer and tabs: FoldableContainer uses `title_panel`, `title_hover_panel`, `title_collapsed_panel`, and `title_collapsed_hover_panel`, not the current baseline's `title_hover` / `title_collapsed`; TabBar/TabContainer icon slots were verified as `increment`, `increment_highlight`, `decrement`, `decrement_highlight`, `drop_mark`, plus `close` for TabBar and `menu` / `menu_highlight` for TabContainer. [VERIFIED: `logs/06-research-slot-probe.log`; `addons/neocade_theme/neocade_theme.gd`; CITED: https://docs.godotengine.org/en/4.6/classes/class_tabbar.html; CITED: https://docs.godotengine.org/en/4.6/classes/class_tabcontainer.html]

**Primary recommendation:** Plan Phase 6 in five waves: slot-freeze correction, Tree, ItemList+FoldableContainer, Tabs, Range+Containers+round-trip verification. [VERIFIED: phase scope and dependency shape in `06-CONTEXT.md`; current code in `neocade_theme.gd`]

## Architectural Responsibility Map

| Capability | Primary Tier | Secondary Tier | Rationale |
|------------|--------------|----------------|-----------|
| Runtime/control theming | Godot Theme resource | Godot Control renderers | The addon owns Theme entries through `NeoCadeTheme._regenerate_theme()`, while built-in Controls consume those entries. [VERIFIED: `neocade_theme.gd`; CITED: https://docs.godotengine.org/en/4.6/classes/class_theme.html] |
| Tree/ItemList density and states | Godot Theme resource | Showcase scene later | Phase 6 can author row styleboxes/constants, but realistic populated visual QA is Phase 9. [VERIFIED: `06-CONTEXT.md`; `.planning/research/PITFALLS.md`] |
| Tab and Foldable header grammar | Godot Theme resource | SVG icon assets | Styleboxes/colors/constants live in BINDING_TABLE; disclosure/navigation icons live under `addons/neocade_theme/icons/`. [VERIFIED: `06-CONTEXT.md`; existing icon directory] |
| Sliders, ProgressBar, ScrollBars | Godot Theme resource | SVG icon assets | Tracks/grabbers/fill are Theme entries; grabber/tick/arrow icons use official Texture2D slots where populated. [VERIFIED: `logs/06-research-slot-probe.log`; CITED: Slider/ScrollBar docs] |
| Data-only direction persistence | ResourceSaver round trip | Strip helper | The five `.tres` files must remain small data resources after regeneration and save. [VERIFIED: `06-CONTEXT.md`; `05-VERIFICATION.md`] |
| Verification | Godot headless helper scripts | Human visual QA in Phase 9/10 | Phase 6 can assert slot coverage and resource structure headlessly; full showcase screenshots are deferred. [VERIFIED: `06-CONTEXT.md`; `.planning/ROADMAP.md`] |

## Standard Stack

### Core

| Library/Tool | Version | Purpose | Why Standard |
|--------------|---------|---------|--------------|
| Godot Engine .NET console | 4.6.2.stable.mono.official.71f334935 | Headless import, Theme introspection, verifier execution, ResourceSaver round trips. | Local project is a Godot 4.6 project and the installed engine matches current 4.6.2 stable. [VERIFIED: `mcp__godot__.get_godot_version`; `project.godot`; `godot --version`; CITED: https://godotengine.org/article/maintenance-release-godot-4-6-2/] |
| GDScript `@tool` Theme class | Godot 4.6.2 | Implements dynamic Theme regeneration through `NeoCadeTheme._regenerate_theme()`. | Existing architecture is single concrete class plus data-only direction resources. [VERIFIED: `neocade_theme.gd`; `.planning/DESIGN_TOKENS.md`] |
| `Theme` API | Godot 4.6 docs | `set_stylebox`, `set_color`, `set_constant`, `set_font`, `set_font_size`, `set_icon`, `set_type_variation`, and list/get methods. | Official API supports all required Theme item types. [CITED: https://docs.godotengine.org/en/4.6/classes/class_theme.html] |
| `StyleBoxFlat` | Godot 4.6.2 | Flat fills, borders, radius, focus rings, and hard-offset raised mode. | Project visual language forbids textures/gradients/shaders and already uses StyleBoxFlat helpers. [VERIFIED: `.planning/DESIGN_TOKENS.md`; `neocade_theme.gd`] |
| SVG icon import pipeline | Godot 4.6.2 | Tree, tab, FoldableContainer, Slider, and ScrollBar icon resources. | Existing icons use 32x32 monochrome `#FFFFFF` SVG plus Godot `.import` sidecars. [VERIFIED: `addons/neocade_theme/icons/`; `06-CONTEXT.md`] |

### Supporting

| Tool | Version | Purpose | When to Use |
|------|---------|---------|-------------|
| `npx ctx7@latest` | resolved `/websites/godotengine_en_4_6` | Documentation lookup fallback when Context7 MCP is unavailable. | Use only as a docs locator; exact Phase 6 slot claims should still be checked against official docs/local Godot because retrieved snippets were not specific enough. [VERIFIED: Context7 CLI output] |
| PowerShell | Windows shell | Run Godot helpers and inspect files. | Existing project workflow and phase helper commands are PowerShell-based. [VERIFIED: `05-RESEARCH.md`; local environment] |
| `rg` | available | Fast file and requirement scanning. | Required by Codex/project practice for codebase reads. [VERIFIED: successful local `rg` calls] |

### Alternatives Considered

| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| Godot headless slot probe | Remembered slot names from older research | Rejected because Phase 6 found stale/wrong names (`Tree.hover`, Foldable title slots). [VERIFIED: `logs/06-research-slot-probe.log`; `neocade_theme.gd`] |
| BINDING_TABLE extension | Per-direction scripts/subclasses | Rejected by locked architecture: one concrete class and data-only `.tres` peers. [VERIFIED: `AGENTS.md`; `.planning/DESIGN_TOKENS.md`] |
| Custom drawing scripts for lists/sliders | Control subclasses or `_draw()` | Rejected because addon deliverable is a Theme resource and must style built-in Controls universally. [VERIFIED: `.planning/PROJECT.md`; CITED: Theme docs] |
| External icon library | Lucide/Material icons | Rejected because Phase 4 icon contract requires bespoke SVGs, monochrome `#FFFFFF`, and Godot import sidecars. [VERIFIED: `06-CONTEXT.md`; existing icons] |

**Installation:** no package installation is required for implementation; use the existing Godot path from Phase 5. [VERIFIED: `.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/godot-cli-path.txt`]

```powershell
$godot = (Get-Content '.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/godot-cli-path.txt' -Raw).Trim()
& $godot --version
```

**Version verification:** Godot 4.6.2 was verified locally through MCP and CLI; `npx`/Node were checked only because Context7 CLI fallback was used for documentation lookup. [VERIFIED: `mcp__godot__.get_godot_version`; local `godot --version`; local `node --version`; local `npm --version`]

## Architecture Patterns

### System Architecture Diagram

```text
Theme export mutation
  -> NeoCadeTheme._regenerate_theme()
     -> derive base/accent/surface/state/platform/direction tokens
     -> walk BINDING_TABLE by type and data kind
        -> _resolve_recipe()
           -> StyleBoxFlat / Color / constant / font_size / icon
        -> Theme.set_* official slot
     -> built-in Godot Controls render entries
        -> Tree/ItemList rows
        -> TabBar/TabContainer/Foldable headers
        -> Slider/ProgressBar/ScrollBar range chrome
        -> Scroll/Split/Margin/layout container chrome
```

This is the existing data flow and should not be replaced by per-Control scripts. [VERIFIED: `neocade_theme.gd`; `.planning/DESIGN_TOKENS.md`]

### Recommended Project Structure

```text
addons/neocade_theme/
  neocade_theme.gd                 # only production script
  *_neocade_theme.tres             # five data-only direction resources
  icons/                           # Phase 4/5 icons plus Phase 6 SVGs
.planning/phases/06-lists-layout-range-tree-itemlist-tabs-containers-sliders-des/
  06-RESEARCH.md
  helpers/
    _phase6_research_slot_probe.gd # research-time slot evidence
    _phase6_verify_headless.gd     # Wave 0 planner should add
    _phase6_resource_saver.gd      # Wave 0 planner should add or port
  logs/
    06-research-slot-probe.log     # local Godot 4.6.2 slot evidence
```

The addon-root production script count is currently one, matching project constraints. [VERIFIED: addon file listing; `AGENTS.md`]

### Pattern 1: Slot Freeze Before Styling

**What:** Update `CANONICAL_SLOT_NAMES` and/or verifier constants from official docs plus a local Godot probe before visual recipes are edited. [VERIFIED: `logs/06-research-slot-probe.log`; `05-VERIFICATION.md`]  
**When to use:** First Phase 6 wave, before changing Tree/TabBar/ScrollBar/Foldable entries. [VERIFIED: `06-CONTEXT.md`]  
**Example:**

```gdscript
# Source: Theme API list methods and Phase 6 probe pattern.
var theme := ThemeDB.get_default_theme()
print(theme.get_icon_list("Tree"))
print(theme.get_icon_list("TabBar"))
print(theme.get_icon_list("HScrollBar"))
```

### Pattern 2: Shared StyleBox Builders for Similar Families

**What:** Use narrow helpers for selected rows, tab chrome, range tracks, and scrollbar grabbers when the same visual grammar must be mirrored across multiple classes. [VERIFIED: `06-CONTEXT.md`; current `_resolve_recipe()` supports helper-backed recipes]  
**When to use:** Use helpers when BINDING_TABLE recipes alone would duplicate transposed geometry or create subtle divergence. [VERIFIED: `06-CONTEXT.md`]

```gdscript
# Source: current StyleBoxFlat helper patterns in neocade_theme.gd.
func _make_transparent_overlay(role_table: Dictionary, role: String, alpha: float, radius: int) -> StyleBoxFlat:
	var sb := StyleBoxFlat.new()
	var c: Color = role_table.get(role, Color.WHITE)
	sb.bg_color = Color(c.r, c.g, c.b, alpha)
	_set_radius_all(sb, radius)
	sb.shadow_size = -1
	return sb
```

### Pattern 3: Transparent Overlay Cursor and Focus Slots

**What:** Cursor/focus styleboxes drawn over content must be transparent or outline-only; opaque `cursor`, `cursor_unfocused`, `focus`, `tab_focus`, and `scroll_focus` hide state/content. [VERIFIED: `.planning/research/MINIMAL-THEME-DISSECTION.md`; `06-CONTEXT.md`]  
**When to use:** Tree, ItemList, ScrollContainer, ScrollBar, FoldableContainer, and tabs. [VERIFIED: `logs/06-research-slot-probe.log`]

```gdscript
# Source: DESIGN_TOKENS focus ring contract and current _resolve_recipe("focus_ring").
var focus_sb := StyleBoxFlat.new()
focus_sb.bg_color = Color(0, 0, 0, 0)
focus_sb.border_color = role_table.role_primary
focus_sb.border_width_left = focus_thickness
focus_sb.border_width_top = focus_thickness
focus_sb.border_width_right = focus_thickness
focus_sb.border_width_bottom = focus_thickness
focus_sb.expand_margin_left = focus_offset_int
focus_sb.expand_margin_top = focus_offset_int
focus_sb.expand_margin_right = focus_offset_int
focus_sb.expand_margin_bottom = focus_offset_int
focus_sb.shadow_size = -1
```

### Pattern 4: ResourceSaver Round Trip, Then Strip Generated Entries

**What:** Save direction `.tres` files through Godot ResourceSaver and strip generated theme entries so resources stay data-only. [VERIFIED: `05-VERIFICATION.md`; `06-CONTEXT.md`]  
**When to use:** Final Phase 6 verification after BINDING_TABLE/icon imports are complete. [VERIFIED: `06-CONTEXT.md`]

### Anti-Patterns to Avoid

- **Invented slots:** `Tree.hover`, `FoldableContainer.title_hover`, `FoldableContainer.title_collapsed`, and fake combo focus slots are not valid Phase 6 wiring targets. [VERIFIED: `logs/06-research-slot-probe.log`; `neocade_theme.gd`]
- **Opaque cursor overlays:** Tree and ItemList cursor overlays draw above rows, so opaque backgrounds obscure text/icons. [VERIFIED: `.planning/research/MINIMAL-THEME-DISSECTION.md`; `06-CONTEXT.md`]
- **Card soup containers:** ScrollContainer can have panel/focus, but HBox/VBox/Flow/Grid/Center should receive constants only or remain untouched. [VERIFIED: `06-CONTEXT.md`; `.planning/research/FEATURES.md`]
- **Divergent H/V range controls:** HSlider/VSlider and HScrollBar/VScrollBar should share construction and transpose orientation-specific margins/icons. [VERIFIED: `06-CONTEXT.md`; `.planning/research/MINIMAL-THEME-DISSECTION.md`]

## Verified Slot Matrix

This table is the planner's canonical Phase 6 target surface. Counts are from local Godot 4.6.2 default/control probes unless a note says docs conflict. [VERIFIED: `logs/06-research-slot-probe.log`]

| Control | StyleBoxes | Colors | Constants | Fonts / Sizes | Icons | Planning Notes |
|---------|-------------|--------|-----------|---------------|-------|----------------|
| Tree | `button_hover`, `button_pressed`, `cursor`, `cursor_unfocused`, `custom_button`, `custom_button_hover`, `custom_button_pressed`, `focus`, `hovered`, `hovered_dimmed`, `hovered_selected`, `hovered_selected_focus`, `panel`, `selected`, `selected_focus`, `title_button_hover`, `title_button_normal`, `title_button_pressed` | 15 slots incl. `font_*`, `guide_color`, `relationship_line_color`, `drop_position_color`, `title_button_color` | 27 slots incl. row margins, relationship lines, scrollbar margins, scroll speed/border | `font`, `title_button_font`; `font_size`, `title_button_font_size` | `arrow`, `arrow_collapsed`, `arrow_collapsed_mirrored`, `checked`, `checked_disabled`, `indeterminate`, `indeterminate_disabled`, `scroll_hint`, `select_arrow`, `unchecked`, `unchecked_disabled`, `updown` | Current code uses invalid `hover`; plan must rename to `hovered` and add `custom_button` / `hovered_dimmed`. [VERIFIED: probe log; `neocade_theme.gd`] |
| ItemList | `cursor`, `cursor_unfocused`, `focus`, `hovered`, `hovered_selected`, `hovered_selected_focus`, `panel`, `selected`, `selected_focus` | 7 | 5 | `font`; `font_size` | `scroll_hint` | Use shared selected-row helper with Tree, simpler geometry. [VERIFIED: probe log; `06-CONTEXT.md`] |
| TabBar | `button_highlight`, `button_pressed`, `tab_disabled`, `tab_focus`, `tab_hovered`, `tab_selected`, `tab_unselected` | 10 | 4 runtime-reported: `h_separation`, `hover_switch_wait_msec`, `icon_max_width`, `outline_size` | `font`; `font_size` | `close`, `decrement`, `decrement_highlight`, `drop_mark`, `increment`, `increment_highlight` | `tab_separation` appears in project notes/docs but local runtime reports missing; do not bind it unless source/Theme Editor confirms during execution. [VERIFIED: probe log; CITED: TabBar docs] |
| TabContainer | `panel`, `tab_disabled`, `tab_focus`, `tab_hovered`, `tab_selected`, `tab_unselected`, `tabbar_background` | 10 | 4 runtime-reported: `icon_max_width`, `icon_separation`, `outline_size`, `side_margin` | `font`; `font_size` | `decrement`, `decrement_highlight`, `drop_mark`, `increment`, `increment_highlight`, `menu`, `menu_highlight` | Share all overlapping tab stylebox construction with TabBar. [VERIFIED: probe log; `06-CONTEXT.md`] |
| FoldableContainer | `focus`, `panel`, `title_collapsed_hover_panel`, `title_collapsed_panel`, `title_hover_panel`, `title_panel` | `collapsed_font_color`, `font_color`, `font_outline_color`, `hover_font_color` | `h_separation`, `outline_size` | `font`; `font_size` | `expanded_arrow`, `expanded_arrow_mirrored`, `folded_arrow`, `folded_arrow_mirrored` | Current baseline slot names are wrong and must be corrected. [VERIFIED: probe log; `neocade_theme.gd`; CITED: stable FoldableContainer docs] |
| ProgressBar | `background`, `fill` | `font_color`, `font_outline_color` | `outline_size` | `font`; `font_size` | none | Theme text colors/fonts even if Phase 9 later demonstrates labels. [VERIFIED: probe log; CITED: ProgressBar docs] |
| HSlider / VSlider | `grabber_area`, `grabber_area_highlight`, `slider` | none | `center_grabber`, `grabber_offset`, `tick_offset` | none | `grabber`, `grabber_disabled`, `grabber_highlight`, `tick` | Use mirrored construction; icons are official Texture2D slots. [VERIFIED: probe log; CITED: Slider docs] |
| HScrollBar / VScrollBar | `grabber`, `grabber_highlight`, `grabber_pressed`, `scroll`, `scroll_focus` | none | none | none | `decrement`, `decrement_highlight`, `decrement_pressed`, `increment`, `increment_highlight`, `increment_pressed` | Official icon slots exist; bind only official names and reuse state icons where appropriate. [VERIFIED: probe log; CITED: ScrollBar docs] |
| ScrollContainer | `focus`, `panel` | `scroll_hint_horizontal_color`, `scroll_hint_vertical_color` | none reported locally | none | `scroll_hint_horizontal`, `scroll_hint_vertical` | `scrollbar_h_separation` / `scrollbar_v_separation` were in older notes but not local runtime; do not bind without execution-time confirmation. [VERIFIED: probe log; CITED: ScrollContainer docs] |
| HSplitContainer / VSplitContainer | `split_bar_background` | none on H/V subclasses | `autohide`, `minimum_grab_thickness`, `separation` | none | `grabber`, `touch_dragger` | SplitContainer base also has `touch_dragger_*_color` and h/v grabber variants, but Phase 6 target subclasses report compact slots. [VERIFIED: probe log; CITED: SplitContainer docs] |
| MarginContainer | none | none | `margin_bottom`, `margin_left`, `margin_right`, `margin_top` | none | none | Constants only. [VERIFIED: probe log; CITED: MarginContainer docs] |
| HBoxContainer / VBoxContainer | none | none | `separation` | none | none | Constants only. [VERIFIED: probe log] |
| FlowContainer / GridContainer | none | none | `h_separation`, `v_separation` | none | none | Constants only. [VERIFIED: probe log; CITED: Flow/Grid docs snippets] |
| HSeparator / VSeparator | `separator` | none | `separation` | none | none | Include if planner treats separator/layout constants as Phase 6 container chrome. [VERIFIED: probe log; `.planning/research/MINIMAL-THEME-DISSECTION.md`] |

## Current Code Delta

| Area | Current State | Required Plan Action |
|------|---------------|----------------------|
| `CANONICAL_SLOT_NAMES.Tree` | Freezes old 16-stylebox shorthand and includes `hover`, not valid `hovered`. [VERIFIED: `neocade_theme.gd`; probe log] | Replace with 4.6.2-probed Tree list; assert invalid `hover` absent. |
| `BINDING_TABLE.Tree` | Uses `hover` and lacks `custom_button`, `hovered_dimmed`, many colors/constants/fonts/icons. [VERIFIED: `neocade_theme.gd`; probe log] | Full Tree plan slice should add all target surface and icon recipes. |
| `BINDING_TABLE.FoldableContainer` | Uses `title_hover`, `title_collapsed`, and `title_font_color`, which do not match probed official slots. [VERIFIED: `neocade_theme.gd`; probe log] | Rename to `title_hover_panel`, `title_collapsed_panel`, `title_collapsed_hover_panel`, `collapsed_font_color`, `hover_font_color`, etc. |
| Tab icons | Baseline has no TabBar/TabContainer icon recipes. [VERIFIED: `neocade_theme.gd`; probe log] | Add official icon slots and import sidecars. |
| Slider icons | Baseline has styleboxes but no `grabber` / `grabber_highlight` / `grabber_disabled` / `tick` icon recipes. [VERIFIED: `neocade_theme.gd`; probe log] | Add official slider icon slots or intentional project-owned icon decisions. |
| ScrollBar icons | Baseline has styleboxes but no increment/decrement icon recipes. [VERIFIED: `neocade_theme.gd`; probe log] | Use official slots only; do not invent names. |
| Container constants | Baseline covers H/V split partially and omits Margin/HBox/VBox/Flow/Grid/Separator constants. [VERIFIED: `neocade_theme.gd`; probe log] | Populate constants where Phase 6 scope includes them; keep layout-only containers visually boring. |

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Theme item discovery | Remembered slot list or regex over old docs | Local Godot probe plus official class docs | Phase 6 already found stale slot names in current code. [VERIFIED: probe log; `neocade_theme.gd`] |
| List/tree rendering | Custom `Tree`/`ItemList` subclasses | Theme entries on built-in Controls | Addon promise is drop-in Theme coverage across editor/runtime. [VERIFIED: `.planning/PROJECT.md`; CITED: Theme docs] |
| Focus state combinations | Fake `pressed_focus` / `checked_focus` slots | Official `focus`, `tab_focus`, `scroll_focus` overlays | Godot exposes focus overlay slots for these controls; project locked this policy. [VERIFIED: `06-CONTEXT.md`; probe log] |
| Direction-specific tab/list behavior | New public exports | Existing `DIRECTION_PRESETS.shape.*` values | Export surface is locked to 9 public properties. [VERIFIED: `.planning/DESIGN_TOKENS.md`; `neocade_theme.gd`] |
| Icons | External icon pack or handwritten `.import` guesses | Bespoke SVG plus Godot-generated `.import` sidecar | Phase 4 icon contract and import settings are already established. [VERIFIED: `addons/neocade_theme/icons/`; `06-CONTEXT.md`] |
| Direction resource persistence | Manual `.tres` string authoring | ResourceSaver save plus strip helper | Phase 5 retired the hand-authored fallback. [VERIFIED: `05-VERIFICATION.md`] |
| Container styling | Fake panels for layout-only containers | Separation/margin constants only | COV-07 and AF-11 explicitly limit layout-only chrome. [VERIFIED: `.planning/REQUIREMENTS.md`; `.planning/research/FEATURES.md`] |

**Key insight:** Phase 6 complexity is not inventing visuals; it is aligning a formula-driven Theme generator with exact 4.6.2 slot surfaces while preserving the one-class, data-only architecture. [VERIFIED: `06-CONTEXT.md`; `neocade_theme.gd`; probe log]

## Common Pitfalls

### Pitfall 1: Stale Slot Names

**What goes wrong:** BINDING_TABLE writes to a non-consumed slot, so the visual state silently stays engine-default. [VERIFIED: `Tree.hover` and Foldable baseline mismatch in current code]  
**Why it happens:** Prior project notes and older dissection shorthand do not exactly match local Godot 4.6.2 runtime slot names. [VERIFIED: probe log; `.planning/research/FEATURES.md`]  
**How to avoid:** Make Wave 0 update canonical slot lists from the probe and assert invalid names are absent. [VERIFIED: `logs/06-research-slot-probe.log`]  
**Warning signs:** Verifier uses `has_*()` only, or accepts `Tree.hover` / `title_hover` as proof of coverage. [VERIFIED: `05-VERIFICATION.md` warns authored-list checks matter]

### Pitfall 2: Tree Cursor and Focus Become Opaque

**What goes wrong:** Tree cursor overlays hide labels, icons, custom buttons, and selection states. [VERIFIED: `.planning/research/MINIMAL-THEME-DISSECTION.md`; `06-CONTEXT.md`]  
**Why it happens:** Godot draws cursor over item contents. [VERIFIED: minimal-theme dissection notes]  
**How to avoid:** Use transparent/semi-transparent overlays for `cursor` and `cursor_unfocused`, and outline-only `focus`. [VERIFIED: `06-CONTEXT.md`]  
**Warning signs:** Cursor stylebox has fully opaque `bg_color` or a high raised shadow. [VERIFIED: `06-CONTEXT.md`]

### Pitfall 3: Tabs Do Not Read as Attached to Content

**What goes wrong:** Selected tabs look like floating chips disconnected from `TabContainer.panel`. [VERIFIED: `.planning/research/MINIMAL-THEME-DISSECTION.md`]  
**Why it happens:** TabBar and TabContainer styleboxes diverge or selected-tab bottom geometry is not coordinated with the panel. [VERIFIED: `06-CONTEXT.md`]  
**How to avoid:** Share tab builders and make active tabs connect visually to the content panel. [VERIFIED: `06-CONTEXT.md`]  
**Warning signs:** TabBar and TabContainer have different `tab_selected` recipes for overlapping slots. [VERIFIED: current planning context]

### Pitfall 4: Range Controls Rely on Engine Default Icons

**What goes wrong:** Slider grabbers, ticks, and ScrollBar arrows look like stock Godot while the rest of NeoCade is custom. [VERIFIED: current `neocade_theme.gd`; probe log]  
**Why it happens:** Existing baseline covers range styleboxes but not all official Texture2D slots. [VERIFIED: `neocade_theme.gd`]  
**How to avoid:** Add official icon recipes for `grabber`, `grabber_highlight`, `grabber_disabled`, `tick`, and ScrollBar increment/decrement states if visual arrows are used. [VERIFIED: probe log; CITED: Slider/ScrollBar docs]  
**Warning signs:** `get_icon_list("HSlider")` or `get_icon_list("HScrollBar")` in the loaded NeoCade theme is empty after Phase 6. [VERIFIED: Theme API docs]

### Pitfall 5: Data-Only Direction Files Accumulate Generated Entries

**What goes wrong:** ResourceSaver writes large generated Theme entries into all five `.tres` files, breaking the data-only architecture. [VERIFIED: `05-VERIFICATION.md`; `06-CONTEXT.md`]  
**Why it happens:** Saving a dynamic Theme resource serializes generated entries unless stripped. [VERIFIED: Phase 5 resource saver pattern]  
**How to avoid:** Port Phase 5's ResourceSaver/strip pattern and assert each direction `.tres` remains small and only links script/export data. [VERIFIED: `05-VERIFICATION.md`]  
**Warning signs:** Direction `.tres` files grow from hundreds of bytes to many kilobytes after verification. [VERIFIED: current addon file listing]

## Code Examples

### Official Slot Probe

```gdscript
# Source: .planning/phases/06-.../helpers/_phase6_research_slot_probe.gd
extends SceneTree

func _initialize() -> void:
	var theme := ThemeDB.get_default_theme()
	print(theme.get_stylebox_list("Tree"))
	print(theme.get_icon_list("TabBar"))
	print(theme.get_icon_list("HScrollBar"))
	quit()
```

### Shared Tab StyleBox Pattern

```gdscript
# Source: Phase 6 decisions plus current StyleBoxFlat helpers.
func _make_tab_stylebox(role_table: Dictionary, presets: Dictionary, role: String, selected: bool) -> StyleBoxFlat:
	var lift_key := "shape.raised_lifts.selected_tab" if selected else "shape.raised_lifts.unselected_tab"
	var intensity := int(_lookup_shape(presets, lift_key))
	var sb := _make_raised_stylebox(role_table.get(role), role_table.surface_panel_offset, intensity)
	var radius := int(_lookup_shape(presets, "shape.tab_radius"))
	_set_radius_all(sb, radius)
	sb.border_color = role_table.outline_color
	return sb
```

### Invalid Slot Guard

```gdscript
# Source: Phase 6 probe result.
func assert_no_known_bad_phase6_slots(theme: Theme) -> void:
	assert(not theme.get_stylebox_list("Tree").has("hover"))
	assert(not theme.get_stylebox_list("FoldableContainer").has("title_hover"))
	assert(not theme.get_color_list("FoldableContainer").has("title_font_color"))
```

## State of the Art

| Old Approach | Current Approach | When Changed / Verified | Impact |
|--------------|------------------|--------------------------|--------|
| `Tree.hover` shorthand | `Tree.hovered` official slot | Verified locally on Godot 4.6.2 during Phase 6 research. [VERIFIED: probe log] | Planner must include a correction task before Tree polish. |
| Foldable guessed title names | `title_panel`, `title_hover_panel`, `title_collapsed_panel`, `title_collapsed_hover_panel` | Verified locally and cross-checked with stable official docs. [VERIFIED: probe log; CITED: FoldableContainer docs] | Existing baseline recipes must be renamed. |
| Phase 4 hand-authored `.tres` fallback | Godot CLI + ResourceSaver + strip pass | Closed in Phase 5 verification. [VERIFIED: `05-VERIFICATION.md`] | Phase 6 should not hand-author direction resources. |
| Minimal-theme zero Tree `v_separation` | Dense but readable integer row separation | User locked D-06 in Phase 6 context. [VERIFIED: `06-CONTEXT.md`] | Start small; do not copy zero blindly. |
| Engine default Slider/Tab icons | NeoCade-owned SVGs through official icon slots | Phase 6 icon scope and probe confirm official slots. [VERIFIED: `06-CONTEXT.md`; probe log] | Add icon authoring/import tasks. |

**Deprecated/outdated:**
- `Tree.hover` in current `neocade_theme.gd` is outdated for Godot 4.6.2. [VERIFIED: probe log; `neocade_theme.gd`]
- Foldable `title_hover`, `title_collapsed`, and `title_font_color` are outdated guessed names. [VERIFIED: probe log; `neocade_theme.gd`]
- Treating Tree as 16 styleboxes is outdated shorthand; the local default Theme reports 18 stylebox names. [VERIFIED: probe log]

## Assumptions Log

| # | Claim | Section | Risk if Wrong |
|---|-------|---------|---------------|

All claims in this research were verified against local project files, the local Godot 4.6.2 runtime, official Godot docs, or Context7 CLI resolution output; no `[ASSUMED]` claims are used. [VERIFIED: sources listed below]

## Open Questions

1. **Should `tab_separation` be treated as valid for 4.6.2?**  
   - What we know: project notes and docs snippets mention it, but local `TabBar` / `TabContainer` control probes report `tab_separation` missing. [VERIFIED: probe log; CITED: TabBar/TabContainer docs]  
   - What's unclear: whether this is a docs/runtime mismatch or a ThemeDB probing limitation. [VERIFIED: probe log]  
   - Recommendation: do not bind `tab_separation` in Phase 6 unless execution rechecks Godot source or Theme Editor "Add All Items" on this exact engine. [VERIFIED: local runtime evidence]

2. **Should ScrollBar end-arrow icons be visible?**  
   - What we know: official slots exist for increment/decrement normal/highlight/pressed on HScrollBar and VScrollBar. [VERIFIED: probe log; CITED: ScrollBar docs]  
   - What's unclear: exact visual preference is delegated, but upstream minimal-theme intentionally relied on empty/default end icons. [VERIFIED: `.planning/research/MINIMAL-THEME-DISSECTION.md`; `06-CONTEXT.md`]  
   - Recommendation: use subtle official icons only if they improve discoverability; otherwise document intentional no-end-arrow behavior and ensure no unsupported names are invented. [VERIFIED: `06-CONTEXT.md`; FEATURES notes]

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|-------------|-----------|---------|----------|
| Godot CLI | Import, slot probes, verifier, ResourceSaver | yes | 4.6.2.stable.mono.official.71f334935 | none needed. [VERIFIED: `godot --version`; MCP Godot version] |
| Godot MCP | Project/version metadata | yes | 4.6.2.stable.official.71f334935 | CLI path from Phase 5. [VERIFIED: `mcp__godot__.get_project_info`] |
| Node.js | Context7 CLI fallback | yes | v25.0.0 | Official docs via web if unavailable. [VERIFIED: local `node --version`] |
| npm/npx | Context7 CLI fallback | yes | npm 11.11.1 | Official docs via web if unavailable. [VERIFIED: local `npm --version`] |
| Context7 docs set | Godot docs lookup | yes via CLI | `/websites/godotengine_en_4_6` | Official docs/source because fetched snippets were not exact enough. [VERIFIED: Context7 CLI output] |

**Missing dependencies with no fallback:** none for research/planning. [VERIFIED: environment probes]  
**Missing dependencies with fallback:** no formal test framework directory exists; Phase 6 should use Godot headless helper scripts as Phase 5 did. [VERIFIED: `rg --files` test scan; `05-VERIFICATION.md`]

## Validation Architecture

### Test Framework

| Property | Value |
|----------|-------|
| Framework | Godot 4.6.2 GDScript headless scripts. [VERIFIED: Phase 5 verifier pattern; local Godot CLI] |
| Config file | none; helpers live under the phase directory. [VERIFIED: `rg --files` test scan] |
| Quick run command | `& $godot --headless --path . --script .planning/phases/06-lists-layout-range-tree-itemlist-tabs-containers-sliders-des/helpers/_phase6_verify_headless.gd` after Wave 0 creates it. [VERIFIED: Phase 5 pattern] |
| Full suite command | `& $godot --headless --path . --import --quit-after 2`, then the Phase 6 verifier, then ResourceSaver round-trip script. [VERIFIED: `05-VERIFICATION.md`; `06-CONTEXT.md`] |

### Phase Requirements -> Test Map

| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|--------------|
| COV-04 | HSlider/VSlider/ProgressBar/HScrollBar/VScrollBar target slots populated and invalid range icon names absent. | headless unit/smoke | Phase 6 verifier stage `range` | No; Wave 0. [VERIFIED: phase scope] |
| COV-05 | Tree/ItemList/TabBar/TabContainer/FoldableContainer target slots populated, including official icons. | headless unit/smoke | Phase 6 verifier stage `lists-tabs` | No; Wave 0. [VERIFIED: phase scope] |
| COV-07 | Scroll/Split/Margin/layout container constants/styleboxes populated only where official slots exist. | headless unit/smoke | Phase 6 verifier stage `containers` | No; Wave 0. [VERIFIED: phase scope] |
| COV-09 | Focus ring slots exist for focusable Phase 6 controls and no combo focus slots are invented. | headless unit + visual smoke later | Phase 6 verifier stage `focus` | No; Wave 0. [VERIFIED: `06-CONTEXT.md`] |
| TYPEVAR-06 | Any Phase 6 variation implications recorded for Phase 8 docs. | doc check | verifier checks `06-SUMMARY.md`/plan outputs for notes | No; Wave 0. [VERIFIED: requirements traceability] |

### Sampling Rate

- **Per task commit:** run the relevant Phase 6 verifier stage after it exists. [VERIFIED: Phase 5 pattern]
- **Per wave merge:** run Godot import plus full Phase 6 verifier. [VERIFIED: Phase 5 pattern]
- **Phase gate:** full Phase 6 verifier green, clean import log, and all five `.tres` resources still data-only before `$gsd-verify-work`. [VERIFIED: `06-CONTEXT.md`; `05-VERIFICATION.md`]

### Wave 0 Gaps

- [ ] `.planning/phases/06-lists-layout-range-tree-itemlist-tabs-containers-sliders-des/helpers/_phase6_verify_headless.gd` - strict slot/icon/constant verifier. [VERIFIED: missing from current phase directory]
- [ ] `.planning/phases/06-lists-layout-range-tree-itemlist-tabs-containers-sliders-des/helpers/_phase6_resource_saver.gd` - ResourceSaver round-trip and strip helper. [VERIFIED: Phase 5 pattern; missing from current phase directory]
- [ ] `.planning/phases/06-lists-layout-range-tree-itemlist-tabs-containers-sliders-des/helpers/phase6-slot-freeze.txt` or equivalent generated seed output from `_phase6_research_slot_probe.gd`. [VERIFIED: `06-CONTEXT.md` D-21]

## Sources

### Primary (HIGH confidence)

- Local Godot 4.6.2 slot probe: `.planning/phases/06-lists-layout-range-tree-itemlist-tabs-containers-sliders-des/helpers/_phase6_research_slot_probe.gd` and `logs/06-research-slot-probe.log` - exact runtime default/control theme item evidence. [VERIFIED: local Godot CLI]
- Godot MCP `get_godot_version` / `get_project_info` - installed Godot and project version. [VERIFIED: MCP output]
- `addons/neocade_theme/neocade_theme.gd` - current production class, `DIRECTION_PRESETS`, `CANONICAL_SLOT_NAMES`, and BINDING_TABLE. [VERIFIED: local file]
- `.planning/phases/06-lists-layout-range-tree-itemlist-tabs-containers-sliders-des/06-CONTEXT.md` - locked Phase 6 decisions. [VERIFIED: local file]
- `.planning/DESIGN_TOKENS.md` - direction shape/raised/focus/platform contracts. [VERIFIED: local file]
- `.planning/research/MINIMAL-THEME-DISSECTION.md` - upstream minimal-theme slot enumeration and pitfalls. [VERIFIED: local file]
- `.planning/research/FEATURES.md` and `.planning/research/PITFALLS.md` - coverage matrix, anti-features, and known risks. [VERIFIED: local files]
- Official Godot Theme docs: https://docs.godotengine.org/en/4.6/classes/class_theme.html - Theme setters, getters, type variations, and data types. [CITED: official docs]
- Official Godot class docs for Tree, ItemList, TabBar, TabContainer, ProgressBar, Slider, ScrollBar, ScrollContainer, SplitContainer, MarginContainer, and FoldableContainer. [CITED: official docs URLs opened/search results]
- Godot 4.6.2 official release article/archive - current local engine branch checked. [CITED: https://godotengine.org/article/maintenance-release-godot-4-6-2/; https://godotengine.org/download/archive/4.6.2-stable/]

### Secondary (MEDIUM confidence)

- Context7 CLI resolution for `/websites/godotengine_en_4_6`; useful for locating docs, but exact slot snippets were not relied on when they were nonspecific. [VERIFIED: Context7 CLI output]

### Tertiary (LOW confidence)

- None. [VERIFIED: source review]

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH - local Godot 4.6.2 and official docs were verified. [VERIFIED: local CLI/MCP; official release/docs]
- Architecture: HIGH - current production class and project contracts are explicit and internally consistent. [VERIFIED: `neocade_theme.gd`; `.planning/DESIGN_TOKENS.md`; `AGENTS.md`]
- Slot names: HIGH for local 4.6.2 runtime-reported slots; MEDIUM for `tab_separation` and ScrollContainer separator constants because docs/notes conflict with local runtime probe. [VERIFIED: probe log; docs URLs]
- Pitfalls: HIGH - risks are backed by Phase 1 dissection, Phase 5 verifier lessons, and local current-code mismatches. [VERIFIED: `.planning/research/MINIMAL-THEME-DISSECTION.md`; `05-VERIFICATION.md`; `neocade_theme.gd`]

**Research date:** 2026-05-07 [VERIFIED: local system date]  
**Valid until:** 2026-06-06 for Godot 4.6.x work; re-run slot probe before implementation if the project upgrades beyond 4.6.2. [VERIFIED: official release status; local engine version]
