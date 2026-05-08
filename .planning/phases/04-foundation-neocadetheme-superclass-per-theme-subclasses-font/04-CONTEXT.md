# Phase 4: Foundation — `NeoCadeTheme` class + 5 data-only `.tres` + Fonts + Icons - Context

**Gathered:** 2026-05-06
**Status:** Ready for planning

<domain>
## Phase Boundary

Build the structural foundation of the NeoCade addon: the single concrete `@tool class_name NeoCadeTheme extends Theme` (9 `@export` properties) at `addons/neocade_theme/neocade_theme.gd`, the 5 data-only direction `.tres` files (Pulse / Slate / Bubble / Daybreak / Burst) at the addon root, the bundled Inter Variable Roman font with FontVariation resources for headings, the Button-family bespoke SVG icons + the icon import contract, and addon metadata (`OFL.txt` / `LICENSE.md` / `README.md` / `CHANGELOG.md` / `VERSION`). Delete the existing scaffold root `.tres`. By Phase 4 close, loading any of the 5 direction `.tres` produces a Theme with entries for ALL 37 scorecard Control rows + 13 type variations populated via formula-derived `_regenerate_theme()`.

**In scope:**
- `addons/neocade_theme/neocade_theme.gd` (single concrete `@tool class_name NeoCadeTheme extends Theme`, 9 `@export` properties per DESIGN_TOKENS §4.1, `_regenerate_theme()` lifecycle, `is_light` derivation, additive iteration engine).
- 5 data-only direction `.tres` files at addon root (`pulse_neocade_theme.tres`, `slate_neocade_theme.tres`, `bubble_neocade_theme.tres`, `daybreak_neocade_theme.tres`, `burst_neocade_theme.tres`), each with the 9 `@export` values per DESIGN_TOKENS §5.1-§5.5.
- Inter Variable Roman bundled at `addons/neocade_theme/fonts/Inter-Variable.ttf` (the ONLY font, per UD-4 Option D); FontFile.tres + 3-5 FontVariation resources for heading variations (HeaderLarge wght=800 opsz=32, HeaderMedium wght=700 opsz=32, HeaderSmall wght=600 opsz=24, etc.).
- Button-family bespoke SVG icons at `addons/neocade_theme/icons/` (~10 icons: check, radio, toggle, arrow_down, clear, close, OptionButton arrow, CheckBox/CheckButton on/off) + the icon import contract documented in DESIGN_TOKENS §11 / SC #3.
- Full formula state coverage for all 37 base Controls (every required stylebox slot — normal/hover/pressed/focus/disabled/hover_pressed where applicable; Tree's 16 styleboxes; LineEdit's 3 styleboxes; etc.) populated via `_regenerate_theme()` formulas.
- `Theme.set_type_variation(...)` registration for all 13 type variations (TYPEVAR-01..04) + explicit fonts per variation (PITFALLS 1.2 — variations don't inherit fonts).
- Color formulas (`_mix`, `_tint_toward_base`, 5-stop surface ramp with `is_light` flip on elevated tier, M3 state-layer overlays 8/12/12/16/38) ported from `.planning/mockups/3.4/src/neocade-mockups.js` per DESIGN_TOKENS §6.
- Raised-mode StyleBoxFlat construction (`shadow_size = raised_strength`, `shadow_offset = (0, raised_strength)`, color = tinted offset; or `shadow_size = -1` when flat).
- Platform branch (`platform=AUTO` resolution via `OS.has_feature("mobile")`; `platform=DESKTOP/MOBILE` forced).
- Delete `addons/neocade_theme/neocade_theme.tres` (the empty scaffold from project init) and update `showcase/showcase.tscn` reference.
- Minimal Phase 4 README documenting consumer pattern (`preload("res://addons/neocade_theme/{name}_neocade_theme.tres")`), recommended starter (Pulse), custom theme authoring (`NeoCadeTheme.new()`), CJK override pattern (UD-2 / FONT-09).
- Pulse implemented FIRST per DESIGN_TOKENS §12.4; then Slate / Bubble / Daybreak / Burst.

**Out of scope:**
- Full per-Control state-combo authoring (Pitfall 1.1 `pressed_focus`, `checked_focus`, `hover_pressed`) — Phases 5/6/7 polish.
- Per-direction Theme Editor variation styleboxes (PrimaryButton/GhostButton/HeaderLarge/CardPanel/etc. authored personality) — Phases 5/6/7.
- Bespoke SVG icons for non-Button Controls (Tree expand/collapse, ColorPicker, FileDialog, ScrollBar, TabBar) — Phases 6/7.
- Mobile-branch tap-target audit script — Phase 8.
- Showcase scene + theme/variation toggles — Phase 9.
- Cross-platform export validation + WCAG audit — Phase 10.
- EditorInspectorPlugin or any editor-side authoring helper — DEFERRED INDEFINITELY.
- Re-deriving DESIGN_TOKENS values, palettes, or `@export` set composition.
- Implementing TOKEN-04 (`surface.sunken` rejected per SUMMARY Conflict 2).
- v2 light mode, alternate palettes, additional theme directions.

</domain>

<decisions>
## Implementation Decisions

### Override-Preservation Architecture (the seamless `@exports` ↔ Theme Editor model)

- **D-01:** `_regenerate_theme()` NEVER calls `clear()`. It is fully ADDITIVE — iterating every theme entry across every type via `Theme.get_type_list()` + `Theme.get_stylebox_list(type)` / `get_color_list(type)` / `get_constant_list(type)` / `get_font_size_list(type)` / `get_icon_list(type)`, and updating in-place properties on each tagged entry via `set_stylebox(...)`. This preserves Theme Editor authored content across `@export` mutations. Pure clear+rebuild would defeat Godot's whole theming system.
- **D-02:** **Architectural principle — `@exports` work seamlessly with Theme Editor authoring.** The 9 `@export` properties on `NeoCadeTheme` are NOT a parallel system to Theme Editor authoring — they DRIVE it. Artists (or Claude) author entries in Theme Editor (the standard Godot workflow); the iteration engine in `_regenerate_theme()` keeps every BOUND property in sync when `@exports` change. There is no "formula-owned vs author-owned" partition; there's "bound" (participates in regeneration) vs "unbound" (escape hatch).
- **D-03:** **Binding mechanism is TENTATIVE for Phase 4** — pending revision. Original discuss-phase answer was "Resource metadata tags" (`_neocade_bg_role: 'accent'` etc. attached via `Resource.set_meta()`). User then reconsidered: an alternative model is "NeoCadeTheme directly applies the exports to the themed overrides based on a set of property names or something similar." For Phase 4 planning purposes, prefer a slot-name + property-name binding table compiled into `neocade_theme.gd` (no per-resource metas required) — e.g., `(theme_type, slot_name, sub_property) → role_token`. Document the choice in PLAN.md as REVISABLE in a future revision pass after we have implementation experience.
- **D-04:** Slots without a binding entry are LEFT UNTOUCHED by `_regenerate_theme()` — escape hatch for one-off freeform authored content (e.g., a splash-screen panel that should never auto-update). Whichever binding mechanism is finalized, this default holds.
- **D-05:** No EditorInspectorPlugin, no `plugin.cfg`, no editor-side authoring helper in v1 (deferred indefinitely). STACK Decision 5 holds. For Phase 4 + Phases 5/6/7, Claude authors theme content programmatically (via `@tool` GDScript helper or hand-written `.tres` text), not via human-artist UI. No artist-UX surface required.

### Phase 4 Coverage Scope (what counts as "Foundation")

- **D-06:** Phase 4 ships **infrastructure + minimum 37/37 baseline** so SC#7 passes by Phase 4 close. Phase 4 ships: the class, the 9 `@export` setters wired to `_regenerate_theme()`, the `is_light` derivation (`base_color.get_luminance() >= 0.5`), the formula helpers (`_mix`, `_tint_toward_base`, surface ramp, state-layer overlays, raised stylebox construction, platform branch with `OS.has_feature("mobile")` for AUTO), the binding table (per D-03), AND a baseline pass for every one of the 37 Controls.
- **D-07:** **Baseline depth = full formula state coverage.** Phase 4 formulas author EVERY required slot for every base Control: Button gets normal/hover/pressed/focus/disabled/hover_pressed; Tree gets all 16 styleboxes; LineEdit gets normal/focus/read_only; PopupMenu gets panel/hover/separator + labeled separators; Window gets embedded_border/embedded_unfocused_border; HScrollBar gets scroll/grabber/grabber_highlight/grabber_pressed; etc. — all formula-derived StyleBoxFlat values + correct color/constant/font_size set + binding entries (per D-03). Phases 5/6/7 then become POLISH passes — bespoke icon wiring, 13 type variations authored per direction, Pitfall 1.1 state combos, per-Control edge cases.
- **D-08:** **Type variations: register + minimum font/size set.** Phase 4 calls `Theme.set_type_variation(name, base_type)` for all 13 NeoCade type variations (per TYPEVAR-01..04: PrimaryButton, SecondaryButton, GhostButton, DangerButton, IconButton, FlatButton; HeaderLarge, HeaderMedium, HeaderSmall, Caption, CodeLabel; InfoText; CardPanel, HeroPanel). Fonts + font_sizes set EXPLICITLY per variation (PITFALLS 1.2 — variations don't inherit fonts from base type). Stylebox/color/constants AUTO-INHERIT from base type via Godot's variation system. Phase 5/6/7 author per-direction personality styleboxes per variation. NOTE: `set_type_variation` is built-in Godot API; the 13 specific NAMES are NeoCade-defined.
- **D-09:** SC#7 ("ALL 37 Controls + 13 type variations populated") is read STRICTLY — every Control type has every required slot present (formula-derived) + every variation type registered with its required fonts. Verified by opening any direction `.tres` in Theme Editor and visually confirming every type lists every expected slot with a non-engine-default value (final COV-10 check happens in Phase 10).

### Icon Authoring Scope

- **D-10:** Phase 4 authors only the **Button-family icons** (~10 SVGs: check, radio, toggle, arrow_down, clear, close, OptionButton arrow, CheckBox on, CheckBox off, CheckButton on/off as needed). Each at 32×32 reference, monochrome SVG (`modulate`-tintable), with `.import` sidecar setting Scale=2.0 + Linear With Mipmaps filter (per ICON-01 + STACK).
- **D-11:** Phase 4 ships the **icon import contract** as a documented standard: SVG dimensions (32×32 reference), `.import` template, monochrome + `modulate`-tintable convention, naming convention. Phases 5/6/7 author their Controls' icons (Tree expand/collapse — Phase 6; ColorPicker/FileDialog/ScrollBar — Phase 7) by following the contract.
- **D-12:** No Material Symbols / Lucide / Phosphor / external icon library bundled (per ICON-04 + STACK "What NOT to Use"). All icons are bespoke author-time work.

### Class Defaults

- **D-13:** `NeoCadeTheme` class `@export` defaults are **sensible Slate-ish neutrals**, NOT Pulse-flavored (per DESIGN_TOKENS §3 / D-31 reframing of historical D-16/D-17). Recommended defaults (modifiable if Phase 4 finds better neutrals): `base_color = #111820`, `accent_color = #8BD3FF`, `raised = false`, `platform = AUTO`, `corner_radius = 12`, `spacing = 4`, `raised_strength = 3`, `focus_thickness = 2`, `outline_width = 1`. Pulse remains the recommended starter via showcase preload + README mention only.

### Implementation Order

- **D-14:** Phase 4 task ordering per DESIGN_TOKENS §12.4: (1) delete scaffold `addons/neocade_theme/neocade_theme.tres` AND swap `showcase/showcase.tscn` reference atomically in one task; (2) author `neocade_theme.gd` shell + 9 `@export` properties + setters + `_regenerate_theme()` skeleton + `is_light` derivation + iteration engine + binding table (per D-03); (3) bundle Inter Variable Roman + author FontFile.tres + heading FontVariation resources + import settings (Grayscale AA, Light hinting, Auto subpixel per FONT-08); (4) author Button-family icons + import contract (per D-10/D-11); (5) implement formulas — port DESIGN_TOKENS §6 surface ramp, §6.3 per-color offsets, §6.5 state layers, §7 role tokens, §8 typography binding, §9 raised stylebox construction, §10 platform branch; (6) full formula state coverage pass for all 37 base Controls + register 13 type variations; (7) author Pulse `.tres` (recommended starter — implement first); (8) verify Pulse — load into a test scene, toggle `raised` / `platform`, confirm regeneration matches Phase 3.4 mockup output; (9) author Slate / Bubble / Daybreak / Burst `.tres` per DESIGN_TOKENS §5.2-§5.5; (10) write Phase 4 README (consumer pattern + recommended starter + custom theme authoring + UD-2 CJK override); (11) addon metadata (`OFL.txt` with Inter Reserved Font Name notice + copyright; `LICENSE.md`; `CHANGELOG.md`; `VERSION` single-line file).

### Claude's Discretion

- Implementation detail of the binding table structure (per-Control nested Dictionary vs flat slot-name keys vs sub-property index — pick simplest that works).
- Reentry-guard pattern for `_regenerate_theme()` setter recursion (the spike uses a `_regenerating := false` flag; production may use that or a cleaner mechanism).
- When `_regenerate_theme()` runs (the spike does `_init()` + setters; production may use setter-only with `Engine.is_editor_hint()` aware behavior, deferred call, or explicit `regenerate()` public method — pick what's correct for `.tres` deserialization order).
- SVG authoring approach (hand-written SVG XML vs parametric template generation — both are Claude's-authoring; choose based on icon style consistency).
- Exact filename casing for FontVariation resources (`Inter-Variable.tres` is FONT-01; variation file naming convention TBD).
- README structure beyond required content (consumer pattern + Pulse + UD-2 + custom authoring); polish to v1 scope happens in Phase 11.

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents (researcher, planner, executor) MUST read these before planning or implementing.**

### Primary Phase 4 Contract (MUST READ FIRST)

- `.planning/DESIGN_TOKENS.md` — Phase 4 single-class/data-resource contract; 12 sections covering the 9 `@export` set, per-direction `.tres` recipes (§5.1-§5.5), GDScript-portable color formulas (§6), role tokens + state-layer constants (§7), shape/typography contract (§8), flat/raised contract (§9), platform contract (§10), accessibility + anti-texture rules (§11), Phase 4 implementation handoff (§12 — file create/delete/forbid lists, dependency order, verification gates). LOCKED at Phase 3.4 user-approval gate.

### Project Canon

- `.planning/PROJECT.md` — hard constraints, architecture lock, Inter-only font decision (UD-4 Option D), approved theme directions, mockup gate enforcement.
- `.planning/ROADMAP.md` §"Phase 4" (lines 176-189) — goal, dependencies, 8 success criteria, requirements list. Phase 5/6/7 goals (lines 191-227) for understanding the polish-pass split.
- `.planning/REQUIREMENTS.md` lines 29-84 (FOUND-01..03 + FONT-01/05/06/07/08/09 + ICON-01..04 — ~16 requirements primary to Phase 4) + lines 86-97 (TOKEN-01..10 — design definitions; Phase 4 implements as code). Note: FOUND-01..03 / FONT-01 / FONT-06 / MOBILE-01 are post-2026-05-06d/e/f rewritten versions superseding earlier static-`.tres`/abstract-base language.
- `.planning/STATE.md` — active phase + sequencing guard. (Note: STATE.md status header still reads "paused at Phase 3.4 Plan 03 Task 4" but commit log 29d6846..6b89e43 confirms Phase 3.4 is closed; verify via Phase 3.4 SUMMARY.)

### Architecture + Feasibility Inputs

- `.planning/research/GODOT-DYNAMIC-THEME-RESEARCH.md` §268 "Architecture Recipe for Phase 4" — Phase 4 implementation recipe. NOTE: subclass-specific items (`_after_base_regenerate`, `_theme_profile`, "subclass contract") are HISTORICAL evidence superseded by D-31's single-concrete-class architecture; the rest (formula port, platform resolution, StyleBoxFlat helpers, full-matrix coverage verifier) carries forward.
- `.planning/spikes/dynamic-theme/SpikeNeoCadeTheme.gd` — working pattern reference (Godot 4.6.2 spike, 6/6 strict-gate PASS). Use as a structural template for the production class. NOTE: spike calls `clear()` in `_regenerate()` — production must NOT (per D-01); rewrite the iteration body to be additive.
- `.planning/spikes/dynamic-theme/VERIFY-RESULTS.md` — Phase 3.2 strict feasibility verifier results.
- `.planning/research/MINIMAL-THEME-DISSECTION.md` — godot-minimal-theme `_get_base_color` formula reference + per-Control state enumeration discipline. The passivestar formula port comes from this artifact.
- `.planning/research/MINIMAL-THEME-COVERAGE-DELTA.md` — 37-row scorecard (the source for SC#7's "37 Controls + 13 type variations").

### Visual Design + Pattern Inputs

- `.planning/research/MD3-RESEARCH.md` — M3 / MD3 Expressive grammar, type scale (TOKEN-10 source), role tokens, state-layer model (TOKEN-09 source).
- `.planning/research/FLAT-3D-UI-RESEARCH.md` — extruded-flat raised-mode StyleBoxFlat translation; per-Control raised behavior matrix.
- `.planning/research/FONT-REVIEW.md` (UD-4 Option D) — Inter Variable Roman ONLY; no Outfit/Noto/JetBrains bundling.
- `.planning/research/PITFALLS.md` — 1.1 (focus is OUTSIDE corner radius bounds; state combos), 1.2 (type variations don't inherit fonts), 1.6 (integer pixels under GL Compatibility), 1.7 (popup-class are separate Windows; theme as first-class types), 5.5 (font hinting for GL Compatibility), 10.3 (clean state switching).
- `.planning/research/CROSS-PLATFORM.md` — mobile sizing floors (iOS HIG 44pt + Material 3 48dp); per-target validation table.
- `.planning/research/STACK.md` Decision 5 — no `plugin.cfg` (consumer addon is not an editor plugin). Decision held in v1 (D-05).
- `.planning/research/FEATURES.md` — 35-class Control coverage matrix + 13 type variations + anti-features (AF-7 syntax highlighting NOT in scope; AF-11 layout-only Containers; AF-13 no drop shadows).
- `.planning/research/EDITOR-COVERAGE.md` — editor surfaces themed in v1 vs default-fallback.

### Phase 3.4 Gate Outputs

- `.planning/phases/03.4-visual-direction-flat-extruded-flat-mockup-approval-gate/03.4-CONTEXT.md` — D-01..D-27 (Phase 3.4 decisions including base architecture; D-16/D-17/D-18 superseded by D-31 of CORRECTIVE-ADDENDUM).
- `.planning/phases/03.4-visual-direction-flat-extruded-flat-mockup-approval-gate/03.4-CORRECTIVE-ADDENDUM.md` — D-28..D-31 (greyscale sufficiency, single-concrete-class, recommended-starter reframing). D-31 is the LIVE architecture lock for Phase 4.
- `.planning/phases/03.4-visual-direction-flat-extruded-flat-mockup-approval-gate/03.4-04-SUMMARY.md` — Phase 3.4 closeout audit (SC-01..SC-07 + D-01..D-27 cross-reference + forbidden-surface audit + Phase 4 handoff).
- `.planning/mockups/3.4/final-approval.md` — gate-closure record; approved themes + recommended starter (Pulse).
- `.planning/mockups/3.4/data/directions.json` — per-direction `shape_language` blocks (the DESIGN_TOKENS §5 `@export` value source).
- `.planning/mockups/3.4/src/neocade-mockups.js` — the renderer's `deriveSurfaceRamp()` / `deriveTokens()` / `tintTowardBase()` / `is_light` formulas; Phase 4 ports verbatim per DESIGN_TOKENS §6.
- `.planning/mockups/3.4/coverage-matrix.md` — 40 Godot 4.6 Control classes + Pitfall 1.1 state combos for SC#7 verification.

### Godot 4.6 API References (verified during discussion via Context7)

- Godot 4.6 `Theme` class — `get_type_list()`, `get_stylebox_type_list()`, `get_color_type_list()`, `get_constant_type_list()`, `get_font_type_list()`, `get_font_size_type_list()`, `get_icon_type_list()`, `get_stylebox_list(type)`, `get_color_list(type)`, etc., `get_stylebox(name, type)`, `set_stylebox(name, type, stylebox)`, `has_stylebox(name, type)`, `set_type_variation(variation, base_type)`. These are the iteration engine APIs.
- Godot 4.6 `Resource` — `set_meta(name, value)`, `get_meta(name, default)`, `has_meta(name)`. Available if the binding mechanism is finalized as metadata-tagged (currently TENTATIVE per D-03).
- Godot 4.6 `StyleBoxFlat` — `bg_color`, `border_color`, 4× `corner_radius_*`, 4× `border_width_*`, `shadow_color` / `shadow_size` / `shadow_offset` / `expand_margin_*`. Hard-offset shadow (no blur) is the raised-mode primitive.
- Godot 4.6 `@tool` annotation — runs in editor; `Engine.is_editor_hint()` for editor-only branches.

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets

- **Spike implementation** (`.planning/spikes/dynamic-theme/SpikeNeoCadeTheme.gd`) is a working pattern for the production class — Godot 4.6.2-validated. Use as structural template: `enum PlatformMode`, `_resolve_platform()` (lines 244-262 with full feature-flag handling for Web/Android/iOS), `_resolve_auto_platform()` heuristic, StyleBoxFlat helpers (`_make_box`, `_make_focus_box`, `_make_line`), color helpers (`_mix`, `_readable_on`, `_derive_surface`), reentry guard (`_regenerating`). Production must REWRITE the `_regenerate()` body — spike's `clear()` call is forbidden (per D-01); the iteration must be additive.
- **Phase 3.4 mockup renderer formulas** (`.planning/mockups/3.4/src/neocade-mockups.js`) are the source of truth for color derivation. Phase 4 ports `deriveSurfaceRamp`, `deriveTokens`, `tintTowardBase`, `is_light` flip rules verbatim into GDScript per DESIGN_TOKENS §6.
- **Existing scaffold** at `addons/neocade_theme/neocade_theme.tres` is the empty Theme scaffold from project init. Phase 4 DELETES this in the first task (per D-14 + DESIGN_TOKENS §12.2). `showcase/showcase.tscn` references it and must be updated atomically.
- **Existing scaffold scene** `showcase/showcase.tscn` is a minimal Control root using the scaffold theme; full showcase implementation is Phase 9. Phase 4 only updates the theme reference.

### Established Patterns

- **godot-minimal-theme passivestar pattern** — `_get_base_color` formula structure ports to NeoCade's `_regenerate_theme()` driven by `@export` reads instead of `EditorSettings.get_setting()`. Reference: `.planning/research/MINIMAL-THEME-DISSECTION.md`.
- **Resource imports** — `.tres` files at `addons/neocade_theme/` are loaded via `preload("res://addons/neocade_theme/{name}_neocade_theme.tres")` per DESIGN_TOKENS §12.5 + FONT-09 override patterns. UID references via `uid://` for fonts (FONT-01).
- **Atomic-commit discipline** — Phase 1-3.4 plans show file-scoped commits per task with PowerShell `-EncodedCommand` verification on Windows (Phase 3.4-04 SUMMARY tech-stack.patterns). Continue this pattern in Phase 4 plan execution.

### Integration Points

- **`addons/neocade_theme/neocade_theme.gd`** — the new class file; loaded as `class_name NeoCadeTheme` globally available across the project.
- **`addons/neocade_theme/{name}_neocade_theme.tres`** ×5 — direction `.tres` files; consumers `preload()` to apply.
- **`addons/neocade_theme/fonts/`** — Inter-Variable.ttf + Inter-Variable.tres (FontFile) + ~3-5 FontVariation `.tres` for heading variations.
- **`addons/neocade_theme/icons/`** — Button-family SVG icons + `.import` sidecars.
- **`showcase/showcase.tscn`** — Phase 4 updates the theme reference from scaffold to recommended-starter `pulse_neocade_theme.tres` (Phase 9 polishes to a full showcase).
- **`addons/neocade_theme/`** root metadata — `OFL.txt`, `LICENSE.md`, `README.md`, `CHANGELOG.md`, `VERSION` (no `plugin.cfg` per STACK Decision 5 + D-05).

</code_context>

<specifics>
## Specific Ideas

- **The seamless-`@exports`-with-Theme-Editor model is the architectural through-line.** Every implementation choice in Phase 4 should preserve the principle: `NeoCadeTheme.@exports` mutate → `_regenerate_theme()` iterates ALL bound theme entries → properties update in place → Theme Editor authored content survives. The spike's `clear()` call is the antipattern to avoid.
- **Pulse first, peers second.** DESIGN_TOKENS §12.4 implementation order is binding. Pulse is the recommended starter; verify regeneration end-to-end against the Phase 3.4 finalist 4-grid mockup (`.planning/mockups/3.4/finalist-gallery.html`) before authoring Slate/Bubble/Daybreak/Burst.
- **Class defaults are intentionally "Slate-ish neutral" (not Pulse).** Pulse is the recommended STARTER for new consumers, not the default value carrier in `NeoCadeTheme.new()`. This preserves all 5 directions as architectural peers per D-31 §3.
- **No `clear()` in `_regenerate_theme()` — full stop.** Spike pattern is structural reference, not literal copy.
- **Inter Variable Roman is the ONLY font.** Reserved Font Name preserved (file NOT renamed); no Outfit, no Noto Sans, no JetBrains Mono — all deferred per UD-4 Option D + FONT-REVIEW.md. CJK / non-Latin scripts handled at runtime via `default_font.allow_system_fallback = true` + Godot OS fallback. README documents the consumer-side override pattern (FONT-09).
- **Icons are bespoke, monochrome SVGs at 32×32 reference, `modulate`-tintable. No external icon library.** Phase 4 ships only the Button-family icons (~10) + the import contract; Phases 6/7 add their Controls' icons by following the contract.
- **The binding mechanism (slot-name table vs metadata tags vs property-name convention) is REVISABLE after Phase 4 implementation.** User explicitly parked this for revision: "I actually think a better approach would be that NeoCadeTheme directly applies the exports to the themed overrides based on a set of property names or something similar. but we can discuss that as a revision later." Phase 4 picks the simplest workable approach (slot-name + property-name binding table in `.gd`) and documents the choice as revisable in PLAN.md.
- **No EditorInspectorPlugin, no `plugin.cfg`. Claude authors themes.** No artist-UX surface. Whatever binding mechanism the planner chooses, it must be authoring-toolable by Claude programmatically — no human UI dependency.

</specifics>

<deferred>
## Deferred Ideas

- **EditorInspectorPlugin** for tagging slots with `_neocade_*` metas — deferred indefinitely. Revisit only if/when human artists join authoring.
- **Binding mechanism revision** — user signaled they may prefer a property-name-convention approach over per-resource metadata. Revisit after Phase 4 implementation experience; treat as a v1.x or v1.0.x refinement once we see the slot-name table in production.
- **Pitfall 1.1 state-combo authoring** (`pressed_focus`, `checked_focus`, `hover_pressed`) — Phase 5 polish (specifically COV-09 focus indicator pattern + Phase 5 SC#5).
- **Per-direction Theme Editor variation styleboxes** (PrimaryButton/GhostButton/HeaderLarge/CardPanel/etc. authored personality per direction — chip pill shape, primary radius oversizing, brand mark, raised lifts list, surface alpha policy, kicker style) — Phases 5/6/7 per DESIGN_TOKENS §5.1-§5.5 "Theme Editor override intent" lines.
- **Bespoke SVG icons for non-Button Controls** — Tree expand/collapse + checked/unchecked + sort arrows + TabBar/TabContainer increment/decrement/menu (Phase 6); ColorPicker preset/screen-pick/sample-bg/recent + FileDialog parent/folder/file/file-up/back/forward/reload + ScrollBar increment/decrement/grabber (Phase 7).
- **Mobile branch validation** + tap-target audit script — Phase 8 (`MOBILE-DESIGN-SPEC.md` deliverable).
- **Showcase scene** with 9 sections + theme picker + raised toggle + platform selector — Phase 9.
- **Cross-platform export QA** + WCAG audit + COV-10 zero-fallback verification — Phase 10.
- **Full v1 README** (DOCS-04) — Phase 11 distribution. Phase 4 ships a minimal README covering consumer pattern + Pulse recommended starter + custom authoring + UD-2 CJK override; Phase 11 expands.
- **CHANGELOG.md `[Unreleased]` body** with all v1.0.0 features + documented limitations — Phase 11 (DIST-03).
- **Asset Library submission** — REJECTED for v1 (RES-05 + DIST-05 stricken); v1 ships GitHub-Releases-only.
- **Light mode + alternate palettes + additional theme directions** — v2.

### Reviewed Todos (not folded)

None — no pending todos matched Phase 4 (per `gsd-sdk query todo.match-phase 4`).

</deferred>

---

*Phase: 4-foundation-neocadetheme-superclass-per-theme-subclasses-font*
*Context gathered: 2026-05-06*
