---
gsd_state_version: 1.0
milestone: v1.0.0
milestone_name: milestone
status: executing
stopped_at: Completed 12-03-wave-2-c2prime-accent-rebinds-PLAN.md
last_updated: "2026-05-11T09:49:47.627Z"
last_activity: 2026-05-11
progress:
  total_phases: 17
  completed_phases: 14
  total_plans: 71
  completed_plans: 67
  percent: 94
---

# Project State

## Project Reference

See: .planning/PROJECT.md (updated 2026-05-09)

**Core value:** A drop-in Godot 4.6 **flat MD3 / MD3 Expressive** Theme system at `res://addons/neocade_theme/` that ships one canonical `neocade_theme.tres` resource of type `NeoCadeTheme`, plus one concrete `addons/neocade_theme/scripts/neocade_theme.gd` class and one reusable `NeoCadeThemeOptionButton` picker. Consumers choose `style` (Pulse, Slate, Bubble, Daybreak, Burst, or `CUSTOM`) and toggle `raised` / `platform` / `base_color` / `accent_color` exports for flat/raised × desktop/mobile/AUTO variations — every built-in Control themed to a `godot-minimal-theme` bar of feature-completeness, accessible (WCAG 2.1 AA), universal across editor + runtime + all 6 Godot export targets. **No textures / no patterns / no embossing / no painterly chrome** (locked 2026-05-04 redirect). **Dynamic-theme architecture** feasibility-validated 2026-05-06 (Phase 3.2 strict gate 6/6 PASS in Godot 4.6.2), then consolidated 2026-05-08 and updated 2026-05-09: single concrete `@tool class_name NeoCadeTheme extends Theme`, 12 exports including `style` and the Advanced `use_runtime_popup_selection_icons` / `texture_cache` toggles, luminance-derived `is_light`, no subclasses, no `_dev/`, no `themes/`, no per-style `.tres`, no editor plugin, no `neocade_mobile_theme.tres`.
**Current focus:** Phase 12 — signature-visual-moves

## Current Position

Phase: 12 (signature-visual-moves) — EXECUTING
Plan: 4 of 4
Next: Execute Plan 12-02 (Wave 1: C4 HSV depth formula rewrite).
Status: Ready to execute
Last activity: 2026-05-11

Progress: [█████████░] 94%

## Performance Metrics

**Velocity:**

- Total plans completed: 52
- Average duration: —
- Total execution time: 0 hours

**By Phase:**

| Phase | Plans | Total | Avg/Plan |
|-------|-------|-------|----------|
| — | — | — | — |
| 1 | 5 | - | - |
| 02 | 5 | - | - |
| 03.1 | 6 | - | - |
| 03.2 | 6 | - | - |
| 03.3 | 3 | - | - |
| 03.4 | 2 | - | - |
| 04 | 8 | - | - |
| 06 | 5 | - | - |
| 07 | 5 | - | - |
| 08 | 5 | - | - |

**Recent Trend:**

- Last 5 plans: —
- Trend: —

*Updated after each plan completion*
| Phase 01-source-dive-godot-minimal-theme-tres-dissection P01 | 10min | 3 tasks | 1 files |
| Phase 01-source-dive-godot-minimal-theme-tres-dissection P02 | 16min | 8 tasks | 1 files |
| Phase 03 P01 | 55min | 5 tasks | 6 files |
| Phase 03 P02 | 70min | 5 tasks | 16 files |
| Phase 03.1 P01 | 12 min | 2 tasks | 3 files |
| Phase 03.1 P02 | 32 min | 3 tasks | 2 files |
| Phase 03.1 P03 | 24 min | 3 tasks | 2 files |
| Phase 03.1 P04 | 28 min | 3 tasks | 2 files |
| Phase 03.1 P05 | 25 min | 3 tasks | 2 files |
| Phase 03.1 P06 | 18 min | 3 tasks | 4 files |
| Phase 03.4 P01 | 17 min | 4 tasks | 8 files |
| Phase 03.4 P02 | re-executed 2026-05-06 | 5 tasks | mockup gallery + 15 concept PNGs |
| Phase 04 P01 | 25 min | 3 tasks | 3 files (1 D, 1 M, 1 A) |
| Phase 04 P03 | ~7 min | 3 tasks | 20 files (10 SVG + 10 .import sidecars, all A) |
| Phase 04 P05 | ~25 min | 5 tasks | 3 files (1 M neocade_theme.gd +940 net, 2 A helpers) |
| Phase 04 P06 | ~18 min | 3 tasks | 4 files (1 A pulse_neocade_theme.tres, 2 A verify helpers, 1 M _phase4_import.gd +148 net) |
| Phase 04 P07 | 12min | 3 tasks | 8 files |
| Phase 04 P08 | 6 min | 6 tasks tasks | 4 files (A) files |
| Phase 06-lists-layout-range-tree-itemlist-tabs-containers-sliders-des P01 | 12 min | 3 tasks | 8 files |
| Phase 06-lists-layout-range-tree-itemlist-tabs-containers-sliders-des P02 | 8 min | 3 tasks | 18 files |
| Phase 06-lists-layout-range-tree-itemlist-tabs-containers-sliders-des P03 | 6 min | 3 tasks | 3 files |
| Phase 06-lists-layout-range-tree-itemlist-tabs-containers-sliders-des P04 | 8 min | 3 tasks | 11 files |
| Phase 06-lists-layout-range-tree-itemlist-tabs-containers-sliders-des P05 | 10 min | 3 tasks | 32 files |
| Phase 07 P01 | 8 min | 3 tasks | 8 files |
| Phase 07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr P02 | 8 min | 3 tasks | 6 files |
| Phase 07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr P03 | 8 min | 3 tasks | 42 files |
| Phase 07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr P04 | 10 min | 3 tasks | 36 files |
| Phase 07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr P05 | 10 min | 3 tasks | 20 files |
| Phase 12 P12-01 | 25min | 4 tasks | 4 files |
| Phase 12 P12-02-wave-1-c4-hsv-depth | 15min | 2 tasks | 1 files |
| Phase 12 P12-03-wave-2-c2prime-accent-rebinds | 20min | 3 tasks | 1 files |

## Accumulated Context

### Decisions

Decisions are logged in PROJECT.md Key Decisions table.
Recent decisions affecting current work:

- Project init (2026-05-04): Mobile variant elevated to v1 must-have alongside desktop primary; cross-platform support across all 6 Godot export targets locked as v1 must-have.
- ~~Research synthesis (2026-05-04): SUMMARY.md Conflict 1 revised — ship Outfit Variable in v1 as display/marquee font; defer Inter Italic to v1.x; net bundle smaller (~1.85 MB) and more on-brand.~~ **SUPERSEDED 2026-05-04 by UD-4 Option D:** Inter Variable Roman ONLY in v1; Outfit + Noto Sans + JetBrains Mono all deferred (~810 KB bundle). See FONT-REVIEW.md.
- Research synthesis (2026-05-04): SUMMARY.md Conflict 2 — adopt M3 5-stop tonal surface ramp as canonical with friendlier aliases (base/secondary/panel/raised/overlay); reject `surface.sunken` for v1.
- Research synthesis (2026-05-04): SUMMARY.md Conflict 3 — no drop shadows in v1 (GL Compat over-renders shadow alpha per Godot #23640); elevation conveyed via tonal surface ramp only; `shadow_size = -1` on every StyleBoxFlat.
- ~~Roadmap (2026-05-04): 11-phase structure adopted from SUMMARY.md verbatim; mockup approval gate is hard blocker between Phase 3 and Phase 4; token-sharing strategy is `@tool` script generator (not `.tres` inheritance).~~ **SUPERSEDED 2026-05-04 by Phase 3 redirect + 2026-05-06e/f architecture simplification; updated 2026-05-08 by style consolidation:** 15-phase structure (Phase 3 REDIRECTED, 3.1/3.2/3.3/3.4 inserted); mockup approval gate is between Phase 3.4 and Phase 4; token-sharing strategy is a single concrete `NeoCadeTheme` class + one canonical style `.tres` resource, NOT a TokenSet generator script, NOT per-theme subclasses, and NOT per-style resources.
- [Phase ?]: Phase 1 Plan 01 (2026-05-04): Dissection skeleton MINIMAL-THEME-DISSECTION.md committed with SHA-256-pinned provenance, verbatim helper bodies, and runtime-validated line citations — Plans 02/03 unblocked.
- [Phase ?]: Phase 1 Plan 02 (2026-05-04): Per-Control enumeration appended to MINIMAL-THEME-DISSECTION.md — 80-token Active Verification Audit + 25 user-facing class sections + 3 NeoCade-additive sections (MenuBar/Panel/Window) + 1 combined container-chrome section + Pitfall 1.7 evidence anchor; 225 enumeration rows total; D-08 reconciliation surfaces 3 user-facing classes upstream does not theme.
- Phase 2 verification (2026-05-04): LDtk source mining passed UAT with 5/5 checks, 0 issues; LDtk coverage is HIGH for v1 UI-theme research, with source outputs explicitly non-binding inspiration for Phase 3 mockups.
- **Phase 3 REDIRECTED (2026-05-04):** User rejected the painterly arcade-venue direction at Plan 03-03 finalist-selection checkpoint. **Boardwalk Sunset (the original recommended baseline) is rejected.** New direction: **flat MD3 / MD3 Expressive visual identity, no textures / no patterns / no embossing / no gradients on chrome.** Optional "extruded flat 3D" raised variation per the Flat-3D Game UI pattern (per user's itch.io references). Phase 3 outputs (mood-board, 5 concept images, direction boards) preserved as v0 historical reference. Replaced by Phase 3.1 (MD3 visual research) + Phase 3.2 (dynamic-theme architecture research) + Phase 3.3 (theme direction research) + Phase 3.4 (revised mockup gate).
- **Architecture revision (2026-05-04, simplified 2026-05-06e/f, consolidated 2026-05-08, Advanced exports added 2026-05-09):** Replaced "4 static `.tres` per theme generated from TokenSet matrix" with dynamic export-driven Theme regeneration. Phase 3.2 first validated the superclass/subclass hypothesis, but production is now **single concrete `NeoCadeTheme` class + one canonical style `.tres` resource**. `NeoCadeTheme` is `@tool extends Theme` with 12 exports (`style`, `base_color`, `accent_color`, `raised`, `platform`, `corner_radius`, `spacing`, `raised_strength`, `focus_thickness`, `outline_width`, `use_runtime_popup_selection_icons`, `texture_cache`). Setters dynamically regenerate theme entries via `_get_base_color`-style formulas ported from passivestar's editor theme (driven by exports, not `EditorSettings`). Per-direction personality lives behind the explicit `style` enum and direction style dictionaries, not per-direction `.gd` classes or per-style `.tres` files. `platform=AUTO` auto-detects via `OS.has_feature("mobile")` at runtime; `DESKTOP` and `MOBILE` are forced sizes. **NEW Phase 3.2 inserted** between Phase 3.1 and Phase 3.4 to validate this dynamic-theme feasibility.
- **Theme-direction phase insertion (2026-05-04; completed 2026-05-06):** **NEW Phase 3.3 inserted** to address gap — original phases 3.1/3.2/3.3 covered design language + architecture + mockups, but NO phase explicitly researched/derived theme directions. Phase 3.3 (Theme Direction Research) derived 5 candidate directions using user's new goals/restrictions + per-v0-direction reactions as DNA + Phase 3.1 findings + commercial flat-MD3 example survey. Outputs `.planning/research/THEME-DIRECTIONS.md` with text-level user approval. **Phase 3.4 Plan 02 selected Pulse as the recommended starter / implementation priority; Slate, Bubble, Daybreak, and Burst remain v1 personality variations.** Pulse is the showcase default and canonical resource default, but has no architectural privilege over other built-in styles.
- Phase 4 Plan 01 (2026-05-06): NeoCadeTheme class shell authored at `addons/neocade_theme/scripts/neocade_theme.gd` — `@tool class_name NeoCadeTheme extends Theme` with 9 @exports (4 Core + 5 Shape under `@export_group("Shape")`), `enum Platform { DESKTOP, MOBILE, AUTO }`, `is_light` luminance-derivation, `_regenerating` reentry guard, `_regenerate_theme()` skeleton, no-`Theme.clear` invariant from day 1, D-03/D-31/D-04/REVISABLE/binding docstring anchors. Empty scaffold `addons/neocade_theme/neocade_theme.tres` deleted; `showcase/showcase.tscn` `theme = ExtResource(...)` line removed entirely (Cycle 6 F2 fix — no placeholder comment because Godot discards `.tscn` comments on save). Atomic commit `d1d596c`.
- Phase 4 Plan 03 (2026-05-06): Button-family bespoke icons authored — 10 monochrome SVGs at 32×32 reference (`check`, `checkbox_checked/unchecked`, `radio_checked/unchecked`, `checkbutton_checked/unchecked`, `arrow_down`, `clear`, `close`) under `addons/neocade_theme/icons/`. Strict single-color `#FFFFFF` policy (Cross-AI Cycle 1 MEDIUM fix). 10 `.import` sidecars locking `svg/scale=2.0` + `mipmaps/generate=true` + `compress/mode=0` + `process/fix_alpha_border=true`, normalized via `godot --headless --import` (Cycle 6 F5 three-stage workflow) so committed paths use real `.ctex` md5 hashes and Godot-issued `uid://` UUIDs. Atomic commit `ec27939`. ICON-03 + ICON-04 → Complete; ICON-01 + ICON-02 → In Progress (remaining slots land in Phases 6/7 under the same contract).
- Phase 4 Plan 04 (2026-05-06): Color formulas + role tokens ported into NeoCadeTheme — `_mix` / `_tint_toward_base` color helpers, `_resolve_platform` / `_platform_tokens` platform helpers, `_make_raised_stylebox` raised helper, `DIRECTION_PRESETS` per-direction non-exported parameters keyed by uppercased base_color hex (Pulse=1.3 wide / Slate=0.7 narrow / Bubble=1.0 / Daybreak=1.0 / Burst=1.3 — Cycle 6 F1 reconciliation), `DIRECTION_PRESET_DEFAULT` for custom themes (`disabled_opacity=0.38` legacy fallback), `_resolve_direction_presets()` lookup, and the per-call derivation block in `_regenerate_theme()` (5-stop surface ramp + tinted offsets + text colors + state-layer overlays + role tokens). 277 lines total. D-01 invariant preserved. Atomic commit `be370d6`.
- Phase 4 Plan 05 (2026-05-06): BINDING_TABLE + iteration engine + 14 type variations — `TYPE_VARIATIONS` (14 entries, CodeLabel INCLUDED per Cycle 1 C4), `CANONICAL_SLOT_NAMES` 22-Control slot-name freeze (Cycle 2 C1; closes verifier accuracy gap), `BINDING_TABLE` 37-key canonical scorecard freeze (Cycle 1 C1) with recipe-as-Dictionary entries (`{"role":..., "raised_intensity":..., "disabled":...}`), `_resolve_recipe()` helper with 5 branches (stylebox/color/constant/font_size/icon — NO font branch per Cycle 2 N1), Cycle 2 C2 fix sourcing disabled_opacity from per-direction styles (no hard-coded 0.38), Cycle 2 M2 fix wiring `tokens.densityScale + tokens.tapPadding` into content_margin (MOBILE > DESKTOP), Cycle 6 F6 fix using FontFile (not FontVariation) for `theme.default_font`, Cycle 6 F4 fix using `checked`/`unchecked` (not `on`/`off`) for CheckButton icon slots. 1216 lines total (+939 net). 10 Button-family icons wired to CheckBox/CheckButton/OptionButton/LineEdit/PopupMenu. `helpers/_phase4_introspect.gd` build-time empirical seed generator + `helpers/BINDING_TABLE_SEED.txt` documented placeholder (Godot CLI unavailable). D-01 invariant preserved. Atomic commit `d9e405a`. FOUND-02 + ICON-02 → Complete for Phase 4 baseline.
- Phase 4 Plan 06 (2026-05-06): Pulse `.tres` (recommended starter direction) + dual verification helpers — `addons/neocade_theme/pulse_neocade_theme.tres` (445 bytes, form-2 serialization: `[gd_resource type="Theme" script_class="NeoCadeTheme"]` + `[ext_resource type="Script"]` + `script = ExtResource(...)` inside `[resource]` — script linkage preserved per Cycle 4 N5 so the file loads as a `NeoCadeTheme` instance; SC#6 data-only by construction at < 2 KiB). `_phase4_import.gd` extended with `_save_pulse_tres()` + static `_strip_theme_entries(path)` (Cycle 3 N4 Fix A) + static `_strip_load_steps_attr(header_line)` (Cycle 4 N5 RegEx helper). Dual `.planning/phases/04-.../helpers/_phase4_verify.gd` (EditorScript) + `_phase4_verify_headless.gd` (SceneTree headless) with shared assertion battery: 9-@export check, BINDING_TABLE.size() == 37 (C1), TYPE_VARIATIONS.size() == 14 with CodeLabel (C4), CANONICAL_SLOT_NAMES iteration (C1), 0.42 disabled-alpha (C2), MOBILE > DESKTOP margin (M2), Pulse vs Slate spread differentiation (L2), per-direction hover/pressed/disabled value freeze (Cycle 6 F1). Cycle 6 F3 path discipline preserved: addon root contains exactly 1 `.gd` file (`neocade_theme.gd`); helpers under `.planning/phases/04-.../helpers/`. Godot CLI unavailable in executor environment — Pulse `.tres` hand-authored to byte-identical form per BINDING_TABLE_SEED.txt precedent (Plan 04-05 Cycle 6 F7 fallback); generator pass wired and ready for first run on Godot-equipped machine. Atomic commit `a3e219f`. FOUND-03 → Complete.
- [Phase ?]: Phase 4 Plan 07 (2026-05-06): Peer direction .tres files (Slate/Bubble/Daybreak/Burst) shipped per DESIGN_TOKENS §5.2-§5.5 — _phase4_import.gd extended with _save_peer_tres() (Cycle 2 M1: declared AND called inside _init()); _phase4_verify.gd + _phase4_verify_headless.gd extended with peer-load battery closing the Cycle 2 M3 gap (each peer loaded, asserted is NeoCadeTheme, has_stylebox(normal, Button), and spread_factor matched against DIRECTION_PRESETS 0.7/1.0/1.0/1.3); showcase/showcase.tscn theme override restored to pulse_neocade_theme.tres (CONTEXT.md D-13 recommended starter; Plan 04-01 Cycle 6 F2 fix had cleared it). Godot CLI unavailable in executor; peer .tres hand-authored byte-aligned with _save_peer_tres+_strip_theme_entries output (Plan 04-06 Cycle 6 F7 fallback precedent). Atomic commit a39c4aa. FOUND-03 5-direction set complete.
- [Phase ?]: Phase 4 Plan 08 (2026-05-07): Addon distribution metadata shipped — LICENSE.md (MIT + OFL footnote), CHANGELOG.md (Keep-a-Changelog [Unreleased] with Phase 4 deliverables, Inter v4.0 SHA256 pin, 37 canonical Controls, 14 type variations incl CodeLabel, FONT-07/UD-2/D-05/D-03 notes), VERSION (0.4.0-phase-4 pre-release), README.md (Phase 4 minimal: Pulse starter, NeoCadeTheme.new() custom auth, FONT-09 CJK fallback, FONT-04 code-font override, FONT-07 synthetic italic, REVISABLE binding disclosure). Layout asserted (11 files, 1 .gd, no plugin.cfg, all peer .tres < 2 KiB). Atomic commit bc192a1. FOUND-01 + FONT-04 + FONT-07 + FONT-09 closed. Phase 4 plans 8/8 complete; ready for verification.
- [Phase 06]: Later Phase 6 verifier groups are explicit pending groups; the full stage fails until Plans 06-02 through 06-05 implement them. — Keeps the foundation strict without pretending later polish groups are complete.
- [Phase 06]: The ResourceSaver helper was created but intentionally not run in Plan 06-01; Plan 06-05 owns direction resource round-trips. — Avoids mutating direction .tres files before all Phase 6 production bindings exist.
- [Phase 06]: Phase 6 slot evidence is frozen from logs/06-research-slot-probe.log and enforced by a headless Godot slot-freeze stage. — Prevents later list, tab, range, and container work from building on stale Godot slot names.
- [Phase 06-lists-layout-range-tree-itemlist-tabs-containers-sliders-des]: Tree keeps dense editor/data-view constants while selected rows use accent-derived fills and cursor/hover states remain semi-transparent overlays. — Plan 06-02 implemented all official Godot 4.6.2 Tree slots and verified Tree cursor/hover overlays are non-opaque.
- [Phase 06-lists-layout-range-tree-itemlist-tabs-containers-sliders-des]: Tree fonts are set explicitly outside BINDING_TABLE: body Inter for rows and header-weight Inter for title buttons. — BINDING_TABLE intentionally has no font data type, so Tree.font and Tree.title_button_font are set directly in _regenerate_theme().
- [Phase 06-lists-layout-range-tree-itemlist-tabs-containers-sliders-des]: ItemList cursor and cursor_unfocused stay semi-transparent overlays while selected rows share Tree accent-offset vocabulary. — Plan 06-03 keeps list focus/hover chrome accessible without opaque cursor blocks and aligns ItemList selection with Tree.
- [Phase 06-lists-layout-range-tree-itemlist-tabs-containers-sliders-des]: FoldableContainer uses only official Godot 4.6.2 title panel, color, constant, and arrow icon slots. — Plan 06-03 rejects stale Foldable names and reuses the Tree disclosure SVG recipes for mirrored and non-mirrored states.
- [Phase 06-lists-layout-range-tree-itemlist-tabs-containers-sliders-des]: The itemlist-foldable verifier stage is routed to zero pending groups. — Later tabs and range/container placeholders run only in their owner stages or full verification, so Plan 06-03 can pass independently.
- [Phase 06-lists-layout-range-tree-itemlist-tabs-containers-sliders-des]: TabBar and TabContainer share identical tab_selected, tab_unselected, tab_hovered, tab_disabled, and tab_focus recipes wherever official slots overlap. — Prevents selected/inactive/hover/focus tab divergence between standalone tab bars and tab containers.
- [Phase 06-lists-layout-range-tree-itemlist-tabs-containers-sliders-des]: Selected tabs use shape.tab_radius plus shape.raised_lifts.selected_tab and square bottom corners so they read attached to the TabContainer panel. — Uses existing direction personality without adding tab-specific public exports.
- [Phase 06-lists-layout-range-tree-itemlist-tabs-containers-sliders-des]: TabBar overflow buttons use explicit button_highlight and button_pressed styleboxes; TabContainer menu and menu_highlight both resolve to tab_menu.svg. — Closes the OpenCode review findings while staying on official Godot 4.6.2 slots.
- [Phase 06-lists-layout-range-tree-itemlist-tabs-containers-sliders-des]: Range controls use official Slider and ScrollBar slots only: slider grabber/tick icons are bound to Slider slots, while ScrollBar grabbers remain styleboxes and only increment/decrement icons are bound.
- [Phase 06-lists-layout-range-tree-itemlist-tabs-containers-sliders-des]: ScrollContainer receives quiet overflow chrome and focus/hint slots, but no unsupported scrollbar separation constants.
- [Phase 06-lists-layout-range-tree-itemlist-tabs-containers-sliders-des]: CenterContainer remains unbound because the local Godot 4.6.2 slot probe reports no theme slots.
- [Phase 06-lists-layout-range-tree-itemlist-tabs-containers-sliders-des]: Historical note: ResourceSaver canonicalization was explored for five direction resources, then superseded by the 2026-05-08 canonical resource + style architecture.
- [Phase 07]: Phase 7 slot evidence is frozen from logs/07-research-slot-probe.log and enforced by a headless Godot slot-freeze stage. — Prevents popup, dialog, ColorPicker, and graph work from relying on stale Godot slot names.
- [Phase 07]: Later Phase 7 verifier groups remain explicit pending groups; the full stage fails until Plans 07-02 through 07-05 implement them. — Keeps Plan 07-01 strict without pretending later production bindings are complete.
- [Phase 07]: Historical note: the Phase 7 ResourceSaver helper was created but intentionally not run in Plan 07-01; this path was later superseded by the no-plugin canonical style resource.
- [Phase 07]: Popup/menu font and font_size slots are set directly after the BINDING_TABLE walk; no Phase 7 font slots were added to BINDING_TABLE.
- [Phase 07]: PopupMenu disabled checked/unchecked/radio variants reuse the base checkbox/radio SVGs and depend on disabled tinting instead of separate artwork.
- [Phase 07]: PopupMenu separators are zero-margin structural line styleboxes, not panel/card surfaces.
- [Phase 07]: FileDialog shell chrome resolves through AcceptDialog/Window because Godot 4.6.2 exposes no FileDialog stylebox slots.
- [Phase 07]: FileDialog thumbnail_size uses an internal thumbnailSize platform token: 96 desktop and 128 mobile.
- [Phase 07]: FileDialog folder_icon_color uses accent_offset rather than raw accent to stay accent-derived without over-bright folder glyphs.
- [Phase 07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr]: ColorPicker binds exactly the official 16 icon slots from the Phase 7 slot freeze; ColorPickerButton uses the separate bg icon slot.
- [Phase 07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr]: ColorPickerButton font and font_size are wired with direct set_font/set_font_size calls after the BINDING_TABLE walk, not through BINDING_TABLE.
- [Phase 07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr]: ColorPicker focus styleboxes use transparent StyleBoxFlat focus rings so engine-rendered picker fields remain unobscured.
- [Phase 07-05]: Graph icons are shipped as nine reusable graph_*.svg assets with import sidecars and are wired through BINDING_TABLE Texture2D icon slots. — Keeps graph chrome data-driven and preserves the single theme-engine script invariant.
- [Phase 07-05]: Phase 7 full verification now treats the canonical 37 Control scorecard, GraphNode and GraphFrame extras, and style-backed canonical resource invariant as closure gates. — Makes the final Phase 7 verifier match the plan's success criteria under the current no-plugin architecture.
- [Phase 07-05]: Graph stack bindings are limited to official Godot 4.6 GraphEdit, GraphNode, and GraphFrame slots, including GraphFrame.resizer_color. — Keeps Phase 7 converged with the revised slot freeze and prevents stale Graph* slot names from entering BINDING_TABLE.
- [Phase 12-01]: BINDING_TABLE.size()=140 at pre-Phase-12 baseline. The historical "37 rows" note in CONTEXT.md referred to the Phase 4 canonical Control scorecard count; subsequent phases (6, 7, 8, 9) grew the table to 140 top-level theme_type keys. Phase 12 verify helpers use 140 as the freeze constant.
- [Phase 12-01]: SC#3 no-glow-halo verifier exempts GraphEditMinimap and GraphStateMachine from the border-alpha=1.0 check. These types use intentional semi-transparent borders for graph-canvas animated-state-node visual distinction (Phase 7 design). They are not new halos introduced by Phase 12.
- [Phase ?]: C2' rebinds: role_primary token (not accent_color) for consistency with Phase 5-7 idiom
- [Phase ?]: Section-header underline rebind DEFERRED (RESEARCH OQ2): HSeparator shares StyleBoxLine with PopupMenu separators
- [Phase ?]: Mid-phase fallback D-12.20 achieved: Wave 1 + Wave 2 leave shippable Phase 12 state

### Roadmap Evolution

- Phase 12 added: Signature Visual Moves (formalized in Phase Details; rich scope already documented in overview lines 81-143 from the 2026-05-10 split commit)
- Phase 13 added: Role Variations

### Pending Todos

[From .planning/todos/pending/ — ideas captured during sessions]

None yet.

### Blockers/Concerns

[Issues that affect future work]

- **Visual-identity gap (post-v1, NOT a v1 blocker):** Production-readiness audit on 2026-05-10 surfaced that the rendered theme reads as "a generic dark Godot theme with an accent color" rather than a unique identity in the lineage of LDtk. The technical foundation is excellent (single concrete `NeoCadeTheme`, 12 exports, 79 SVG icons, 5 styles with shape language); the visible chrome is generic MD3 with color swaps. Tracked as the "Visual Identity Distinctiveness" initiative (spike + phase) in ROADMAP.md.
- **Release repo settings (owner action):** Before running `.github/workflows/release.yml`, confirm GitHub Pages source is "GitHub Actions", release workflow permissions can push commits/tags, and branch protection allows the actions bot release commit.
- **Deferred manual QA — closed:** Phase 9/10/11 UATs and the 8-row deferred-UAT-matrix items closed by user attestation 2026-05-10 (heavy manual testing performed prior to audit). Logged here so future work knows the closure is on the basis of attestation, not regenerated evidence.

## Deferred Items

Items acknowledged and carried forward from previous milestone close:

| Category | Item | Status | Deferred At |
|----------|------|--------|-------------|
| Typography | Inter Italic Variable bundling | Deferred to v1.x (Conflict 1 revision; synthetic italic transform used in v1) | 2026-05-04 |
| Fonts | CJK Noto Sans bundling (~30 MB) | Deferred to v2 / opt-in (UD-2 default; README documents override) | 2026-05-04 |
| Color modes | Light color mode (desktop + mobile) | Deferred to v2 | Project init |
| Palettes | Alternate palette variants (magenta, amber) | Deferred to v2 | Project init |
| Editor | Editor-only theme types (FlatButton, MainScreenButton, etc.) | Deferred to v1.x | Project init |
| Accessibility | Deeper VoiceOver/TalkBack/AccessKit screen-reader QA | Deferred to v1.x (UD-6; `accessibility_name` only in v1) | 2026-05-04 |
| QA | Real-device Android + iOS validation | Conditional on UD-5 resolution; v1 may ship with "deferred to v1.0.1" note | 2026-05-04 |

## Session Continuity

Last session: 2026-05-11T09:49:47.617Z
Stopped at: Completed 12-03-wave-2-c2prime-accent-rebinds-PLAN.md
Resume file: 

None

1. `/gsd-spike` — frame: "What signature visual moves separate NeoCade from a generic dark Godot theme, given LDtk as the polish bar and the locked flat-MD3 / no-textures / no-gradients / anti-cyberpunk constraints?"
2. `/gsd-phase` — insert a "Signature Visual Moves" phase that consumes the spike's recommendations (sidebar tinting, severity-coded chrome, branded iconography pass, distinctive selected-row treatment, header marquee strategy).

The first execution of Phase 3.4 Plan 02 (by Codex) was rejected by the user. The 15 generated concept PNGs collapsed all five directions into the same UI template with only color tokens varying — every direction looked like the same screen with a hex swap. Two corrective tracks landed on 2026-05-06b:

**Track 1 — Palette correction (closed):** Phase 3.3 Revision Round 2/2 retroactively approved Codex's dark migration of Bubble (#241326 + #FFB3E6) and Daybreak (#0B2420 + #76F2D1). All five v1 directions are now dark, complying with PROJECT.md "Out of Scope: Light color mode (v1)". Direction identity, naming, personality intent, and DNA inputs preserved. See `.planning/research/THEME-DIRECTIONS.md` Verification Log entry 2026-05-06b.

**Track 2 — Shape-language correction (closed, 2026-05-06):** Corrective addendum D-28/D-29/D-30 bound the Phase 3.4 Plan 02 re-execution. The authoritative spec was `.planning/mockups/3.4/image-prompts/direction-shape-language-spec.md` (replacing the deprecated `fixed-control-order-spec.md`). Phase 3.4 later closed with Pulse approved as the recommended starter and `DESIGN_TOKENS.md` finalized.

**Track 3 — Subclass architecture refinement to `@abstract` (closed, 2026-05-06c):** D-31 rewritten. `NeoCadeTheme` is `@tool @abstract class_name NeoCadeTheme extends Theme` per [Godot 4.6 `@abstract` annotation](https://docs.godotengine.org/en/4.6/classes/class_%40gdscript.html#class-gdscript-annotation-abstract); cannot be instantiated directly. All 5 approved directions are concrete subclasses with real `_init()` bake-in (no empty alias). The Phase 3.4 user pick is reframed as the "recommended starter direction" (no longer "the base direction whose defaults are baked into NeoCadeTheme"). Architectural cleanup; does not affect Plan 02 mockup execution.

**Track 4 — Flat addon layout + no root `.tres` (closed, 2026-05-06d; root-resource rule superseded 2026-05-08):** All `.gd` and `.tres` files live directly at `addons/neocade_theme/` — no `_dev/` or `themes/` subfolders (`fonts/` and `icons/` remain). Root `neocade_theme.tres` was removed during this historical track, then reintroduced by Track 6 as the single canonical style resource. **The "5 subclass `.gd` files" portion of this track was further simplified by Track 5.**

**Track 5 — Single concrete class + data-driven `.tres` per direction (closed, 2026-05-06e; superseded by Track 6 on 2026-05-08):** Final 2026-05-06 simplification replaced subclass models with one concrete `NeoCadeTheme` class and five data-only direction `.tres` files. The class stayed correct, but the resource split was superseded by the later single-resource style architecture.

**Track 6 — Canonical resource + explicit style enum (current, 2026-05-08; Advanced exports added 2026-05-09):** Five per-direction `.tres` files are consolidated into `addons/neocade_theme/neocade_theme.tres`. `NeoCadeTheme` keeps the single concrete `@tool class_name NeoCadeTheme extends Theme` model and adds a `style` export (`CUSTOM`, `PULSE`, `SLATE`, `BUBBLE`, `DAYBREAK`, `BURST`) for built-in directions. Public exports now total 12 after adding `use_runtime_popup_selection_icons` and `texture_cache`. `Style.CUSTOM` is the manual/custom mode; built-in styles apply the approved direction values and hidden direction personality. The reusable `NeoCadeThemeOptionButton` loads the canonical resource, duplicates it per selection, applies the selected style, and emits `theme_selected(theme, index)`. The addon still has no editor plugin, no subclasses, no `_dev/`, no `themes/`, and no separate mobile resource.

**Re-execution executor:** Claude Code, per user direction 2026-05-06b ("i will use Claude Code from here as its clearly superior to UI design").

**Disposition of first-execution outputs:** 15 rejected PNGs in `.planning/mockups/3.4/concepts/` were deleted; gallery shells (`concept-gallery.html`, `finalist-gallery.html`, `render.js`, `data/directions.json`, `wcag-palette-audit.md`) were kept; the artboard CSS in `src/neocade-mockups.css` was rewritten during Phase 3.4 re-execution to support per-direction shape language. The deprecated `fixed-control-order-spec.md` remains preserved with a deprecation header for audit trail.

## Phase 3 → 3.1/3.2 Redirect Notes (2026-05-04)

**What was preserved (do not delete):**

- `.planning/phases/03-visual-direction-mockup-approval-gate/` — full Phase 3 v0 work (CONTEXT.md, RESEARCH.md, REVIEWS.md, 5 PLAN files, SUMMARY.md for completed plans)
- `.planning/mockups/concepts/*.png` + `*-prompt.md` — 5 concept images + prompt files
- `.planning/mockups/03-direction-boards.html/.md/.png` — direction-board comparison gallery
- `.planning/mockups/03-direction-boards-check.md` — render-check report
- `.planning/research/mood-board/` — 25 mood-board references with INDEX.md + references.json

**Why preserved:** User explicitly requested historical retention so any v0 direction can be revisited later (e.g., re-rendered through the flat-MD3 filter in a future v1.x or v2 milestone). The five concept images alone took ~5-10 minutes per generation; reproducing them later would cost time.

**What's stopped (do not advance):**

- Plans 03-03, 03-04, 03-05 are obsolete in their current form — Phase 3 will not be re-executed.
- The finalist-selection checkpoint from Plan 03-03 is **NOT** to be answered; it's been routed around by this redirect.

**What's next:**
Phase 3.1 (MD3 visual research) and Phase 3.2 (Godot dynamic theme architecture research with feasibility spike) are **parallel-eligible** — different research domains, no shared deliverables. Phase 3.3 (theme direction research) depends on Phase 3.1 (uses MD3 findings as design vocabulary). Phase 3.4 (mockup gate) depends on all three.

Recommended sequence (sequential, simpler):

1. `/gsd-discuss-phase 3.1` → `/gsd-plan-review-convergence 3.1 --opencode` → `/gsd-execute-phase 3.1` → `/gsd-verify-work 3.1`
2. `/clear` → `/gsd-discuss-phase 3.2` → `/gsd-plan-review-convergence 3.2 --opencode` → `/gsd-execute-phase 3.2` → `/gsd-verify-work 3.2`
3. `/clear` → `/gsd-discuss-phase 3.3` → `/gsd-plan-review-convergence 3.3 --opencode --claude` → `/gsd-execute-phase 3.3` → text-level user-approval of 5 candidate directions → `/gsd-verify-work 3.3`
4. `/clear` → `/gsd-discuss-phase 3.4` → `/gsd-plan-review-convergence 3.4 --opencode` → `/gsd-execute-phase 3.4` → user-approval of N final mockups → `/gsd-verify-work 3.4`
5. Phase 3.4 mockup gate replaces the redirected Phase 3 gate; Phase 4 starts after approval

Alternative parallel sequence (faster but more state to juggle):

1. Run Phase 3.1 and Phase 3.2 in parallel sessions (each on its own branch ideally)
2. Both complete → merge → Phase 3.3 begins with both research outputs available
3. Phase 3.4 begins after Phase 3.3 closes
