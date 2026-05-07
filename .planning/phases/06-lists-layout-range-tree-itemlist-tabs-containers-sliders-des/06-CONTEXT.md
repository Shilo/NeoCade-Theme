# Phase 6: Lists, Layout, Range - Tree, ItemList, Tabs, Containers, Sliders (desktop) - Context

**Gathered:** 2026-05-07
**Status:** Ready for planning

<domain>
## Phase Boundary

Author the desktop polish pass for the second-tier Controls: Tree, ItemList, TabBar, TabContainer, FoldableContainer, ScrollContainer, HSplitContainer, VSplitContainer, MarginContainer constants where relevant, HSlider, VSlider, ProgressBar, HScrollBar, and VScrollBar. Phase 4 shipped a broad formula baseline and Phase 5 proved the per-direction shape/polish mechanism; Phase 6 turns the list/tree/tab/range/container family from "baseline populated" into feature-complete, direction-aware desktop chrome across all 5 approved NeoCade directions.

**In scope:**

- Tree full desktop theming: all 16 styleboxes, official icon slots, row/cell constants, guide/relationship colors, selected/hovered/focused/cursor states, multi-column/multi-level data behavior, and structural verification.
- ItemList full desktop theming: panel, focus, cursor, hovered, selected, hovered-selected, icon/text colors, separation constants, and realistic content assumptions for future showcase QA.
- TabBar and TabContainer polish: shared active/inactive/hover/disabled/focus tab model, coherent content panel/tab strip background, close/increment/decrement/menu/drop-mark affordances, and icons where official slots exist.
- FoldableContainer polish: header/title chrome, collapsed/open states, focus ring, and fold affordance aligned with Tree expand/collapse icon language.
- Range controls: HSlider, VSlider, ProgressBar, HScrollBar, VScrollBar with visible tracks, handle/fill/grabber states, mobile-aware constants still sourced through platform tokens, and raised-mode behavior kept subtle.
- Container chrome where applicable: ScrollContainer focus/panel, HSplitContainer/VSplitContainer grab thickness/separation/icons if supported, and MarginContainer/separator/layout constants only where Godot exposes theme entries.
- New Phase 6 bespoke icons under `addons/neocade_theme/icons/` following the Phase 4 SVG contract: 32x32 reference, monochrome `#FFFFFF`, Godot-generated `.import` sidecars, no external icon library.
- Phase 6 verifier helpers under `.planning/phases/06-.../helpers/`, extending the Phase 5 strict verifier approach for slot coverage, icons, constants, data-only `.tres` preservation, focus-ring structure, and no forbidden visual effects.

**Out of scope:**

- Popup-class polish: PopupPanel, PopupMenu, AcceptDialog, ConfirmationDialog, FileDialog, TooltipPanel, TooltipLabel, Window - Phase 7.
- Advanced Controls: MenuBar, ColorPicker, GraphEdit, GraphNode, GraphFrame - Phase 7.
- Mobile branch tuning and tap-target audit - Phase 8, even though Phase 6 entries must remain platform-token-aware.
- Showcase scene visual QA, populated Tree/ItemList/Tab samples, theme picker, and runtime toggles - Phase 9.
- Cross-platform/export/WCAG/CVD/Tab-walk validation - Phase 10.
- Reworking Phase 5 type variations or the 9-property public export surface.
- Layout-only container decoration. HBoxContainer, VBoxContainer, FlowContainer, GridContainer, CenterContainer, and similar layout-only types receive separation/margin constants only if relevant; no fake chrome.

</domain>

<decisions>
## Implementation Decisions

### Delegated Decision Mode

- **D-01:** The user explicitly delegated Phase 6 gray-area decisions to the agent: "none, use all best judgement" (typo in original: "bust judgement"). Planning should not ask the user more Phase 6 taste questions unless a hard blocker appears. Use project canon, Phase 5 patterns, Godot official slot evidence, and conservative visual judgment.
- **D-02:** Apply all four identified gray areas, not a subset: Tree/ItemList density, Tabs/Foldable headers, Range/Scroll affordances, and Container boundaries. The context below is the locked direction for all four.

### Tree and ItemList Density

- **D-03:** Favor an editor-capable dense data-view baseline for Tree and ItemList, with NeoCade polish coming through color, focus, selected-row treatment, and subtle direction-specific shape rather than oversized row padding. These Controls must work for inspector/file/tree-like data, not only game menus.
- **D-04:** Selection should be unmistakable but not loud: selected/selected_focus/hovered_selected rows use `accent_offset` or a derived accent surface, with text remaining high-contrast. Hover and cursor states stay overlay-like. Cursor styleboxes must remain transparent or semi-transparent because Godot draws cursor overlays above content; do not make them opaque.
- **D-05:** Tree guide/relationship/drop-position colors should use outline/accent roles, not new decorative colors. Relationship lines should remain visible enough for hierarchy, but secondary to text and selected rows.
- **D-06:** Tree row constants should start from desktop density, then keep platform-token awareness for Phase 8. Do not copy godot-minimal-theme's zero vertical Tree separation blindly if it harms readability; use a small, integer, GL-safe separation if needed.
- **D-07:** ItemList follows Tree's selected/focus vocabulary but with simpler geometry. If direction-specific row shape is useful, route it through `DIRECTION_PRESETS.shape.raised_lifts.selected_row` and existing shape lookup mechanisms rather than adding public exports.

### Tabs and Foldable Headers

- **D-08:** TabBar and TabContainer must share the same tab stylebox construction wherever slot names overlap. Active tabs read as connected to content; inactive tabs are quieter surface chips. Hover lifts contrast slightly; disabled dims through existing disabled opacity. `tab_focus` remains an outer focus ring, not a filled replacement.
- **D-09:** Use direction-specific shape values already present in `DIRECTION_PRESETS.shape` for tab personality, especially `tab_radius`, `raised_lifts.selected_tab`, and `raised_lifts.unselected_tab`. Do not add new tab-specific public exports.
- **D-10:** Tab icons should be authored in the same visual family as OptionButton/SpinBox arrows: simple, crisp, monochrome, small-size legible. Required candidates include increment/decrement/menu/close or official equivalent slots discovered by Godot 4.6 introspection.
- **D-11:** FoldableContainer header chrome should borrow from Tab/Panel language rather than Button language. The header should feel like a section control, with a clear collapsed/open affordance that reuses or mirrors Tree expand/collapse icons where possible.

### Range and Scroll Affordances

- **D-12:** Sliders and scrollbars should be tactile but restrained. Tracks are visible enough to understand range/overflow; grabbers/filled areas carry accent or raised surface roles. Raised mode can lift handles/grabbers subtly, but the hard-offset effect must be much weaker than on PrimaryButton.
- **D-13:** HSlider/VSlider should mirror each other by transposing margins and constants, not by hand-authoring divergent visual grammar. HScrollBar/VScrollBar follow the same rule. Any direction-specific differences should come from existing tokens/presets.
- **D-14:** ProgressBar fill uses `role_primary` and background uses a low surface. If text is shown by the consuming project, font/text colors must be themed; indeterminate animation is out of pure Theme scope.
- **D-15:** Scrollbar increment/decrement/grabber icons should be added only if Godot 4.6 exposes official icon slots for the Control. Do not invent unsupported icon names. If no official slot exists for a visual affordance, use stylebox shape/color/constant coverage instead.

### Container Boundaries

- **D-16:** ScrollContainer gets a real focus stylebox and a panel treatment only as needed to make nested overflow surfaces coherent. Avoid turning every scroll area into a nested card.
- **D-17:** Split containers should prioritize usable grab thickness and clear separation over decorative chrome. Desktop values can be moderate; platform-aware branches must preserve the ability for Phase 8 to reach mobile touch affordances.
- **D-18:** MarginContainer and layout-only containers should stay boring on purpose. Populate margin/separation constants where Godot exposes them and where the phase verifier can assert them; do not create false visual surfaces for layout helpers.

### Icons and Verification

- **D-19:** Phase 6 icon work should cover Tree expand/collapse/check/indeterminate/sort/select affordances, TabBar/TabContainer navigation/menu/close affordances, and ScrollBar affordances only after official Godot 4.6 slot-name discovery. Use helper introspection rather than remembered slot names.
- **D-20:** Continue Phase 4/5 file discipline: addon root still contains exactly one production `.gd`; helpers live under `.planning/phases/06-.../helpers/`; direction `.tres` files stay data-only and small.
- **D-21:** The Phase 6 verifier must include a Godot 4.6 slot-name discovery step or generated seed output for the official slots being wired. This is especially important for Tree and TabBar because they have many version-sensitive slots.
- **D-22:** Focus coverage extends Phase 5's COV-09 pattern to all Phase 6 focusable Controls. Use the official `focus`, `scroll_focus`, or `tab_focus` slots as appropriate; do not invent `pressed_focus`, `checked_focus`, or similar combo slots.

### Agent's Discretion

- Exact Tree icon count and naming, provided every official Godot 4.6 slot used in Phase 6 is verified by introspection and the icon files follow the Phase 4 SVG import contract.
- Exact row heights/separation values, provided desktop density remains useful and Phase 8 can scale via existing platform tokens.
- Exact active-tab geometry per direction, provided TabBar and TabContainer remain coherent and derive from existing `shape.*` keys.
- Whether to add dedicated helper functions for list/tab/range StyleBox construction or keep them as BINDING_TABLE recipes. Prefer helpers only when they remove real duplication or prevent subtle divergence.
- Whether Tree and ItemList use one shared selected-row helper. Prefer sharing if it keeps contrast/focus behavior consistent.

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Primary Phase 6 Contract

- `.planning/ROADMAP.md` lines 212-221 - Phase 6 goal and success criteria for Tree, ItemList, TabBar/TabContainer/FoldableContainer, range controls, container chrome, and dynamic regeneration round-trips.
- `.planning/REQUIREMENTS.md` - COV-04 (range controls), COV-05 (list/tree controls), cumulative COV-01/COV-07/COV-09/TYPEVAR-06 traceability.
- `.planning/STATE.md` - sequencing guard and current project position.

### Phase 5 Carry-Forward

- `.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/05-CONTEXT.md` - Phase 5 decisions D-01..D-17, especially formula-driven BINDING_TABLE extension, `DIRECTION_PRESETS.shape`, focus policy, all-5-directions cadence, and verifier pattern.
- `.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/05-VERIFICATION.md` - verifies Phase 5 passed, lists Phase 6 deferred items, and confirms no structural gaps before advancing.
- `.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify.gd` and `.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify_headless.gd` - strict verifier structure to extend.
- `.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_resource_saver.gd` - ResourceSaver round-trip helper pattern for keeping `.tres` resources data-only.

### Production Code

- `addons/neocade_theme/neocade_theme.gd` - single production class. Phase 6 extends `CANONICAL_SLOT_NAMES`, `BINDING_TABLE`, shape-aware recipe usage, icon bindings, and possibly helper functions.
- `addons/neocade_theme/icons/` - existing icon contract examples: checkbox/radio/checkbutton/arrow_down/clear/close/code_folded/spinbox icons plus `.import` sidecars.
- `addons/neocade_theme/{pulse,slate,bubble,daybreak,burst}_neocade_theme.tres` - data-only direction resources that must remain valid `NeoCadeTheme` instances after Phase 6.

### Design System Inputs

- `.planning/DESIGN_TOKENS.md` - final token contract. Relevant sections: per-direction shape/raised lift intent, state-layer model, range handle raised behavior, row minimums, platform tokens, anti-texture/no-shadow rules, and Phase 6 implementation note.
- `.planning/mockups/3.4/data/directions.json` - per-direction shape language and greyscale-sufficiency intent.
- `.planning/mockups/3.4/finalist-gallery.html` - Pulse visual benchmark for flat/raised, desktop/mobile direction behavior.
- `.planning/research/MD3-RESEARCH.md` - list item, tab, state-layer, contrast, and component grammar reference.
- `.planning/research/FLAT-3D-UI-RESEARCH.md` - raised-mode affordance matrix; range handles and selected tabs should lift subtly compared to buttons.

### Godot Coverage and Pitfalls

- `.planning/research/MINIMAL-THEME-DISSECTION.md` sections `ItemList`, `TabBar`, `TabContainer`, `Tree`, `ProgressBar`, `HSlider`, `VSlider`, `HScrollBar`, `VScrollBar`, and `User-facing container chrome` - evidence-grade upstream slot/style/constants enumeration and omitted-slot notes.
- `.planning/research/MINIMAL-THEME-COVERAGE-DELTA.md` - 37-row scorecard; Phase 6 contributes to COV-01 and COV-07 but does not close them fully.
- `.planning/research/FEATURES.md` sections for range controls, selection/tree views, tabs, containers, and anti-features AF-11/AF-7 - Control matrix and scope guardrails.
- `.planning/research/PITFALLS.md` - Pitfall 1.1 focus/state behavior, 1.6 integer pixels under GL Compatibility, 10.1 realistic populated content for visual QA, and tab/tree/list showcase pitfalls.

### Godot 4.6 API References

- Godot 4.6 `Theme` class - `set_stylebox`, `set_color`, `set_constant`, `set_icon`, `get_*_list`, `has_*` introspection, `set_type_variation`.
- Godot 4.6 `Tree` class theme entries - official icon/stylebox/color/constant slot names must be verified before wiring.
- Godot 4.6 `ItemList` class theme entries - official selected/cursor/hover/focus slots and constants.
- Godot 4.6 `TabBar` and `TabContainer` theme entries - official tab, close, increment/decrement, menu, drop-mark, and focus slots.
- Godot 4.6 `FoldableContainer` theme entries - official header/title/fold affordance slots.
- Godot 4.6 `HSlider`, `VSlider`, `ProgressBar`, `HScrollBar`, `VScrollBar` theme entries - track, fill, grabber, icon, and constant slots.
- Godot 4.6 `ScrollContainer`, `HSplitContainer`, `VSplitContainer`, and `MarginContainer` theme entries - panel/focus/constants/grabber behavior.

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets

- `addons/neocade_theme/neocade_theme.gd` already has Phase 4/5 baseline BINDING_TABLE entries for many Phase 6 Controls, including Tree, ItemList, TabBar, TabContainer, FoldableContainer, HSlider, VSlider, ProgressBar, HScrollBar, VScrollBar, HSplitContainer, and VSplitContainer. Phase 6 should refine these rather than rebuild from scratch.
- `CANONICAL_SLOT_NAMES` currently freezes some Phase 6 slot sets but not enough for final icon/constant coverage. Extend it with official introspection-backed lists before asserting.
- `DIRECTION_PRESETS.shape` already contains tab/selected-row/raised-lift/focus-offset data from Phase 5. Reuse it for Phase 6 instead of adding public exports.
- `_lookup_shape`, `_set_radius_all`, `_set_content_margin_from_padding`, `_apply_primary_strategy`, `_apply_ghost_strategy`, and `_resolve_recipe` already support `shape.*` lookups and strategy dispatch. Phase 6 can add narrow helpers for list/tab/range only if needed.
- Existing icons are monochrome SVG with import sidecars. New Tree/Tab/Scroll icons should copy that contract.
- Phase 5 helpers prove the local Godot CLI path and verifier setup. Reuse the same Godot 4.6.2 path resolution strategy.

### Established Patterns

- Additive regeneration only: no `Theme.clear()`, no wiping unbound Theme Editor content.
- BINDING_TABLE recipes own formula-derived entries; slots missing from BINDING_TABLE remain untouched as the escape hatch.
- All 5 direction `.tres` files stay data-only and rely on `neocade_theme.gd` for regeneration.
- Direction personality lives in `DIRECTION_PRESETS.shape` and per-entry recipes, not in new public exports or per-direction scripts.
- Focus is the official focus overlay slot only. Do not add combo slots.
- Official Godot slot names must be discovered or verified. Avoid remembered/invented names, especially for Tree, TabBar, and ScrollBar icons.
- GL Compatibility constraints still apply: integer pixels, no glow, no blur, no textures, no gradients, no custom shaders.

### Integration Points

- Production edits: `addons/neocade_theme/neocade_theme.gd`.
- New assets: `addons/neocade_theme/icons/*.svg` plus `.svg.import` sidecars for Phase 6 icon slots.
- Direction resources: all 5 `addons/neocade_theme/*_neocade_theme.tres` may be round-tripped but should remain small, data-only, and script-linked.
- Helpers: `.planning/phases/06-lists-layout-range-tree-itemlist-tabs-containers-sliders-des/helpers/`.
- Verification artifacts: Phase 6 strict verifier, icon slot discovery output, and ResourceSaver helper output under the Phase 6 helper directory.

</code_context>

<specifics>
## Specific Ideas

- The phase should preserve the user's delegated trust: use all four gray areas and make conservative, project-aligned calls.
- Tree is the heavy class. Treat it as a plan slice of its own unless planning evidence says otherwise.
- TabBar and TabContainer should share stylebox construction for overlapping slots, mirroring godot-minimal-theme's relationship while adding NeoCade direction personality.
- FoldableContainer should reuse Tree expand/collapse visual language so the user reads "disclosure" consistently across hierarchy controls.
- Range handles and scrollbar grabbers should be the tactile part; tracks should be calm. Raised mode is subtle here.
- Container surfaces should not become card soup. Chrome only where it helps scanning or focus.

</specifics>

<deferred>
## Deferred Ideas

- Popup-class and dialog theming - Phase 7.
- MenuBar, ColorPicker, GraphEdit, GraphNode, GraphFrame - Phase 7.
- Mobile-specific range/list/tabs touch-target tuning and `MOBILE-DESIGN-SPEC.md` - Phase 8.
- Showcase visual QA with populated Tree/ItemList/Tab/Foldable examples - Phase 9.
- Final focus Tab-walk and cross-platform visual QA - Phase 10.
- TYPEVAR-06 final documentation - Phase 8.
- Light mode and alternate palettes - v2.

### Reviewed Todos (not folded)

None - no pending todos matched Phase 6.

</deferred>

---

*Phase: 06-lists-layout-range-tree-itemlist-tabs-containers-sliders-des*
*Context gathered: 2026-05-07*
