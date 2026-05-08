# Phase 7: Dialogs, Popups, Advanced - Window, Popups, MenuBar, ColorPicker, Graph (desktop) - Context

**Gathered:** 2026-05-07
**Status:** Ready for planning

<domain>
## Phase Boundary

Phase 7 completes desktop Control coverage for the popup/window and advanced-control tier: Window, popup/dialog/file/tooltip classes, MenuBar + spawned PopupMenu behavior, ColorPicker + its official icon surface, and the GraphEdit/GraphNode/GraphFrame stack at a basic v1 quality bar.

This phase must author explicit desktop theme entries for these Controls inside the existing `NeoCadeTheme._regenerate_theme()` system. It does not tune mobile sizing, perform final showcase screenshot QA, add v1.x editor-only types, or redesign heavyweight graph UX beyond clean first-pass coverage.

</domain>

<decisions>
## Implementation Decisions

### Autonomous Discussion Scope
- **D-01:** Phase 7 discussion ran in authorized autonomous mode for Phases 6-8. The user previously delegated mechanical/design-detail choices to agent best judgement; this context locks the recommended defaults below without adding new user gates.
- **D-02:** Downstream agents should proceed without prompting unless they hit an actual hard gate: missing Godot 4.6.2 slot evidence, impossible coverage claims, destructive git/file actions, or a scope change beyond Phase 7.

### Popup and Window Coverage
- **D-03:** Treat all popup-class types as first-class theme types: `Window`, `PopupPanel`, `PopupMenu`, `AcceptDialog`, `ConfirmationDialog`, `FileDialog`, `TooltipPanel`, and `TooltipLabel`. Do not rely on `PopupPanel`, `Window`, or parent override inheritance because popup instances cross Window boundaries.
- **D-04:** Popup/dialog shells should use solid tonal surfaces from the existing surface ramp, subtle borders, and existing radius tokens. Continue the v1 no-shadow policy: no soft shadows, blur, glow, or texture chrome.
- **D-05:** Window chrome should be quiet but complete: title colors/fonts, close icon styling, embedded border/unfocused variants, and spacing/offset constants should read as native-to-NeoCade without imitating OS window decorations.
- **D-06:** `AcceptDialog`, `ConfirmationDialog`, and `FileDialog` may reuse established Button, Label, LineEdit, Tree/ItemList, and container recipes internally, but each dialog type still needs explicit class entries for shell/chrome slots exposed by Godot 4.6.2.
- **D-07:** Tooltip readability is non-negotiable. `TooltipPanel` should stay compact and mostly structural, while `TooltipLabel` owns readable text color, font size, and padding. Preserve AA contrast on every approved direction.

### MenuBar and PopupMenu
- **D-08:** MenuBar triggers should align with existing Button/MenuButton/Tab visual language: low-emphasis normal state, clear hover and pressed/active overlays, disabled opacity consistent with direction presets, and no decorative landing-page styling.
- **D-09:** Menus spawned from MenuBar must resolve through `PopupMenu` type entries. PopupMenu rows need explicit state coverage for normal/hover/pressed/disabled/read-only-ish surfaces where official slots exist, plus separators, submenu arrows, check/radio icons, and accelerator readability.
- **D-10:** Keep popup menu shape practical for editor/runtime use: dense enough for desktop menus, readable text, visible row states, and no excessive arcade ornamentation that harms scanning.

### FileDialog and ColorPicker Icons
- **D-11:** Phase 7 icon work follows the Phase 4/6 icon contract: bespoke SVGs under `addons/neocade_theme/icons/`, 32x32 reference art, single `#FFFFFF` fill/stroke where possible, Godot-generated `.import` sidecars, no external icon packs.
- **D-12:** FileDialog must include the roadmap-listed icons: parent/folder/file/file-up/back/forward/reload. If Godot 4.6.2 exposes additional official FileDialog icon slots, freeze them by introspection before planning whether to bind or defer.
- **D-13:** ColorPicker must be driven by Godot 4.6.2 slot discovery. The roadmap target is 16 bespoke icons, but the exact slot list should be frozen from local introspection logs before implementation. Do not guess stale slot names from older docs.
- **D-14:** The theme owns ColorPicker chrome, buttons, labels, presets, and icon slots. Engine-rendered picker gradients/samplers remain engine-rendered; do not add custom shaders or image textures for the color field.

### Graph Stack
- **D-15:** GraphEdit quality bar is "basic v1": clean canvas, grid, minimap, selection, and connection colors that fit NeoCade and remain usable. Deeper graph-editor UX/polish can be deferred to v1.x.
- **D-16:** GraphNode should read as a compact functional panel: clear title area, selected/focused state, port/slot readability, and modest tonal elevation. Avoid large card-within-card styling.
- **D-17:** GraphFrame should be flat and grouping-oriented. It should help users parse graph regions without becoming a decorative container or adding shadow-based depth.

### Coverage and Verification
- **D-18:** Phase 7 must close the desktop structural coverage scorecard: every 37-row user-facing Control class needs at least one custom theme entry through `NeoCadeTheme._regenerate_theme()` for desktop. Final visual screenshot proof remains Phase 9/10, but Phase 7 must provide strict structural verification.
- **D-19:** Start planning with a Godot 4.6.2 slot-freeze/introspection step for the risky controls: `Window`, `PopupMenu`, `FileDialog`, `ColorPicker`, `ColorPickerButton`, `GraphEdit`, `GraphNode`, and `GraphFrame`.
- **D-20:** Reuse the Phase 6 verification pattern: helper scripts under the phase directory, explicit stage names, slot-freeze assertions, coverage assertions, and ResourceSaver/resource round-trip checks only after production bindings are complete.
- **D-21:** Preserve architecture invariants: one addon-root `.gd`, data-only direction `.tres` files under 2 KiB after ResourceSaver, no public export expansion unless a plan proves it necessary, no `Theme.clear`, no per-direction scripts, and no root fallback `neocade_theme.tres` resource resurrection.
- **D-22:** Continue COV-09 focus discipline. Add focus entries only for official focusable-control slots, and keep focus rings consistent with the Phase 4/6 focus recipe.

### the agent's Discretion
- Select exact surface roles, state-layer alpha values, border colors, icon metaphors, and graph colors using existing direction tokens and Phase 4/6 patterns.
- Choose whether a binding belongs in `BINDING_TABLE`, a direct `_regenerate_theme()` call, or a small local helper based on the current code structure.
- Decide whether verification should be one combined Phase 7 helper or staged helpers, as long as planning preserves slot-freeze first and a final full pass.

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Project and Requirements
- `.planning/STATE.md` - Current phase, workflow status, and known blockers.
- `.planning/PROJECT.md` - Hard constraints, architecture constraints, no-shadow/no-texture policy, and active project truth.
- `.planning/REQUIREMENTS.md` - COV-06, COV-08, cumulative COV-01/COV-07/COV-09 requirements and traceability.
- `.planning/ROADMAP.md` - Phase 7 goal, dependencies, success criteria, and phase boundary.
- `.planning/config.json` - Workflow flags, review convergence configuration, and Phases 6-8 autonomous authorization note.

### Prior Phase Context
- `.planning/phases/06-lists-layout-range-tree-itemlist-tabs-containers-sliders-des/06-CONTEXT.md` - Phase 6 slot-freeze, verifier, ResourceSaver, and structural coverage decisions to carry forward.
- `.planning/phases/06-lists-layout-range-tree-itemlist-tabs-containers-sliders-des/06-VERIFICATION.md` - Phase 6 formal verification status and deferred visual proof boundary.
- `.planning/phases/04-foundation-dynamic-theme-class-exports-icons-fonts/04-CONTEXT.md` - Dynamic theme architecture and icon/font constraints.
- `.planning/phases/04-foundation-dynamic-theme-class-exports-icons-fonts/04-VERIFICATION.md` - Foundation verification and direction-resource expectations.

### Research and Design Canon
- `.planning/research/FEATURES.md` - Control coverage matrix, popup/advanced categories, type variations, and anti-features.
- `.planning/research/MINIMAL-THEME-DISSECTION.md` - Godot minimal theme slot evidence, PopupMenu/PopupPanel/Tooltip/Window/ColorPicker/Graph/MenuBar notes, and Pitfall 1.7.
- `.planning/research/PITFALLS.md` - Pitfall 1.7 popup Window boundary, Pitfall 4.3 tooltip readability, slot drift, import, and verification hazards.
- `.planning/research/EDITOR-COVERAGE.md` - Editor surfaces affected by FileDialog, MenuBar, context menus, tooltips, ColorPicker, and GraphEdit-based editors.
- `.planning/research/FLAT-3D-UI-RESEARCH.md` - Flat depth guidance for popup shells, buttons, graph nodes, and no-shadow tonal elevation.
- `.planning/research/CROSS-PLATFORM.md` - Cross-platform constraints; mobile-specific deltas are deferred to Phase 8.
- `.planning/research/STACK.md` - Addon layout and locked technology decisions.

### Implementation Files
- `addons/neocade_theme/neocade_theme.gd` - Sole production script and binding table/regeneration engine.
- `addons/neocade_theme/icons/` - Existing icon vocabulary and import-sidecar pattern.
- `addons/neocade_theme/pulse_neocade_theme.tres` - Recommended starter direction resource.
- `addons/neocade_theme/slate_neocade_theme.tres` - Peer direction resource.
- `addons/neocade_theme/bubble_neocade_theme.tres` - Peer direction resource.
- `addons/neocade_theme/daybreak_neocade_theme.tres` - Peer direction resource.
- `addons/neocade_theme/burst_neocade_theme.tres` - Peer direction resource.
- `showcase/showcase.tscn` - Showcase scene scaffold; visual coverage expansion is Phase 9 unless needed as a temporary verifier fixture.

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- `NeoCadeTheme._regenerate_theme()` already derives tokens, direction presets, state overlays, focus styles, and platform density values that Phase 7 should reuse.
- `BINDING_TABLE`, `TYPE_VARIATIONS`, and `CANONICAL_SLOT_NAMES` already provide the pattern for structural coverage bindings; Phase 7 should extend or complement them rather than create a second theme engine.
- Existing SVGs and `.import` files under `addons/neocade_theme/icons/` define the contract for new FileDialog, ColorPicker, PopupMenu, Window, and Graph icons.
- Phase 6 helper scripts show the expected verifier style: headless Godot probes, staged assertions, and strict no-pending final verification.

### Established Patterns
- Direction personality is data/token driven; no per-direction scripts or subclass hierarchy.
- Public customization remains constrained to the 9 exports. Per-control polish belongs in generated theme entries, not new exports.
- `StyleBoxFlat` + tonal ramp + borders carry depth. `shadow_size = -1` remains the default posture for v1.
- ResourceSaver canonicalization must preserve the explicit 9-export contract on all five direction resources.

### Integration Points
- Phase 7 should add bindings and direct theme entries in `addons/neocade_theme/neocade_theme.gd`.
- New icons belong in `addons/neocade_theme/icons/` with Godot-generated imports.
- Phase-specific probes/verifiers belong under `.planning/phases/07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr/helpers/`.
- Any temporary test scenes or introspection scripts should remain planning/helper artifacts unless a plan explicitly promotes showcase coverage to `showcase/showcase.tscn`.

</code_context>

<specifics>
## Specific Ideas

- The popup family should feel like practical arcade/editor UI by day: colorful and polished, but not cyberpunk, neon-noir, dystopian, textured, or HD pixel-art.
- Popup/dialog chrome should favor readable tonal separation over theatrical glow.
- ColorPicker/FileDialog icons should be bespoke but plain enough to survive tinting and small sizes.
- Graph stack acceptance is intentionally modest for v1; clean usability matters more than heavy visual novelty.

</specifics>

<deferred>
## Deferred Ideas

- Mobile-specific popup/dialog/ColorPicker/MenuBar tuning belongs to Phase 8.
- Showcase gallery screenshots and editor-surface visual proof belong to Phase 9/10 unless a Phase 7 verifier needs minimal fixtures.
- Advanced GraphEdit/GraphNode UX polish beyond basic v1 coverage belongs to v1.x.
- Light mode, alternate palettes, editor-only theme variants, and deeper screen-reader QA remain out of v1 scope per project canon.

</deferred>

---

*Phase: 7-Dialogs, Popups, Advanced - Window, Popups, MenuBar, ColorPicker, Graph (desktop)*
*Context gathered: 2026-05-07*
