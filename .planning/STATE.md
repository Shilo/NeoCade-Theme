---
gsd_state_version: 1.0
milestone: v1.0.0
milestone_name: milestone
status: executing
stopped_at: Phase 6 context gathered
last_updated: "2026-05-07T08:22:49.122Z"
last_activity: 2026-05-07 -- Phase 06 planning complete
progress:
  total_phases: 15
  completed_phases: 8
  total_plans: 54
  completed_plans: 46
  percent: 85
---

# Project State

## Project Reference

See: .planning/PROJECT.md (updated 2026-05-06)

**Core value:** A drop-in Godot 4.6 **flat MD3 / MD3 Expressive** Theme system at `res://addons/neocade_theme/` that ships **5 approved data-only direction `.tres` files** (Pulse, Slate, Bubble, Daybreak, Burst) of type `NeoCadeTheme`, plus one concrete `addons/neocade_theme/neocade_theme.gd` class. Consumer toggles `raised` / `platform` / `base_color` / `accent_color` exports for flat/raised × desktop/mobile/AUTO variations — every built-in Control themed to a `godot-minimal-theme` bar of feature-completeness, accessible (WCAG 2.1 AA), universal across editor + runtime + all 6 Godot export targets. **No textures / no patterns / no embossing / no painterly chrome** (locked 2026-05-04 redirect). **Dynamic-theme architecture** feasibility-validated 2026-05-06 (Phase 3.2 strict gate 6/6 PASS in Godot 4.6.2), then simplified 2026-05-06e/f: single concrete `@tool class_name NeoCadeTheme extends Theme`, 9 exports, luminance-derived `is_light`, no subclasses, no `_dev/`, no `themes/`, no root `.tres`, no `neocade_mobile_theme.tres`.
**Current focus:** Phase 5 — core-controls-buttons-inputs-labels-panels-desktop — VERIFIED. Next: Phase 6 (heavy Controls — Tree, ItemList, TabBar/TabContainer, sliders/scrollbars, FoldableContainer).

## Current Position

Phase: 5 — VERIFIED-WITH-DEFERRED-ITEMS (verdict from 05-VERIFICATION.md @ fea06b0)
Plan: 7 of 7 complete; SUMMARY + UAT + VERIFICATION all committed
Next: `/clear` → `/gsd-discuss-phase 6` (per CLAUDE.md — `/clear` allowed only at phase boundaries)
Status: Ready to execute
Last activity: 2026-05-07 -- Phase 06 planning complete

Progress: [████████░░] 80%

## Performance Metrics

**Velocity:**

- Total plans completed: 37
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

## Accumulated Context

### Decisions

Decisions are logged in PROJECT.md Key Decisions table.
Recent decisions affecting current work:

- Project init (2026-05-04): Mobile variant elevated to v1 must-have alongside desktop primary; cross-platform support across all 6 Godot export targets locked as v1 must-have.
- ~~Research synthesis (2026-05-04): SUMMARY.md Conflict 1 revised — ship Outfit Variable in v1 as display/marquee font; defer Inter Italic to v1.x; net bundle smaller (~1.85 MB) and more on-brand.~~ **SUPERSEDED 2026-05-04 by UD-4 Option D:** Inter Variable Roman ONLY in v1; Outfit + Noto Sans + JetBrains Mono all deferred (~810 KB bundle). See FONT-REVIEW.md.
- Research synthesis (2026-05-04): SUMMARY.md Conflict 2 — adopt M3 5-stop tonal surface ramp as canonical with friendlier aliases (base/secondary/panel/raised/overlay); reject `surface.sunken` for v1.
- Research synthesis (2026-05-04): SUMMARY.md Conflict 3 — no drop shadows in v1 (GL Compat over-renders shadow alpha per Godot #23640); elevation conveyed via tonal surface ramp only; `shadow_size = -1` on every StyleBoxFlat.
- ~~Roadmap (2026-05-04): 11-phase structure adopted from SUMMARY.md verbatim; mockup approval gate is hard blocker between Phase 3 and Phase 4; token-sharing strategy is `@tool` script generator (not `.tres` inheritance).~~ **SUPERSEDED 2026-05-04 by Phase 3 redirect + 2026-05-06e/f architecture simplification:** 15-phase structure (Phase 3 REDIRECTED, 3.1/3.2/3.3/3.4 inserted); mockup approval gate is between Phase 3.4 and Phase 4; token-sharing strategy is a single concrete `NeoCadeTheme` class + data-only direction `.tres` files, NOT a TokenSet generator script and NOT per-theme subclasses.
- [Phase ?]: Phase 1 Plan 01 (2026-05-04): Dissection skeleton MINIMAL-THEME-DISSECTION.md committed with SHA-256-pinned provenance, verbatim helper bodies, and runtime-validated line citations — Plans 02/03 unblocked.
- [Phase ?]: Phase 1 Plan 02 (2026-05-04): Per-Control enumeration appended to MINIMAL-THEME-DISSECTION.md — 80-token Active Verification Audit + 25 user-facing class sections + 3 NeoCade-additive sections (MenuBar/Panel/Window) + 1 combined container-chrome section + Pitfall 1.7 evidence anchor; 225 enumeration rows total; D-08 reconciliation surfaces 3 user-facing classes upstream does not theme.
- Phase 2 verification (2026-05-04): LDtk source mining passed UAT with 5/5 checks, 0 issues; LDtk coverage is HIGH for v1 UI-theme research, with source outputs explicitly non-binding inspiration for Phase 3 mockups.
- **Phase 3 REDIRECTED (2026-05-04):** User rejected the painterly arcade-venue direction at Plan 03-03 finalist-selection checkpoint. **Boardwalk Sunset (the original recommended baseline) is rejected.** New direction: **flat MD3 / MD3 Expressive visual identity, no textures / no patterns / no embossing / no gradients on chrome.** Optional "extruded flat 3D" raised variation per the Flat-3D Game UI pattern (per user's itch.io references). Phase 3 outputs (mood-board, 5 concept images, direction boards) preserved as v0 historical reference. Replaced by Phase 3.1 (MD3 visual research) + Phase 3.2 (dynamic-theme architecture research) + Phase 3.3 (theme direction research) + Phase 3.4 (revised mockup gate).
- **Architecture revision (2026-05-04, simplified 2026-05-06e/f):** Replaced "4 static `.tres` per theme generated from TokenSet matrix" with dynamic export-driven Theme regeneration. Phase 3.2 first validated the superclass/subclass hypothesis, but production is now **single concrete `NeoCadeTheme` class + data-only direction `.tres` files**. `NeoCadeTheme` is `@tool extends Theme` with 9 exports (`base_color`, `accent_color`, `raised`, `platform`, `corner_radius`, `spacing`, `raised_strength`, `focus_thickness`, `outline_width`). Setters dynamically regenerate theme entries via `_get_base_color`-style formulas ported from passivestar's editor theme (driven by exports, not `EditorSettings`). Per-direction personality lives in Theme Editor entry overrides per `.tres`, not per-direction `.gd` classes. `platform=AUTO` auto-detects via `OS.has_feature("mobile")` at runtime; `DESKTOP` and `MOBILE` are forced sizes. **NEW Phase 3.2 inserted** between Phase 3.1 and Phase 3.4 to validate this dynamic-theme feasibility.
- **Theme-direction phase insertion (2026-05-04; completed 2026-05-06):** **NEW Phase 3.3 inserted** to address gap — original phases 3.1/3.2/3.3 covered design language + architecture + mockups, but NO phase explicitly researched/derived theme directions. Phase 3.3 (Theme Direction Research) derived 5 candidate directions using user's new goals/restrictions + per-v0-direction reactions as DNA + Phase 3.1 findings + commercial flat-MD3 example survey. Outputs `.planning/research/THEME-DIRECTIONS.md` with text-level user approval. **Phase 3.4 Plan 02 selected Pulse as the recommended starter / implementation priority; Slate, Bubble, Daybreak, and Burst remain v1 personality variations.** Recommended starter affects showcase default + README "try this first" only; it does NOT bake Pulse into class defaults.
- Phase 4 Plan 01 (2026-05-06): NeoCadeTheme class shell authored at `addons/neocade_theme/neocade_theme.gd` — `@tool class_name NeoCadeTheme extends Theme` with 9 @exports (4 Core + 5 Shape under `@export_group("Shape")`), `enum Platform { DESKTOP, MOBILE, AUTO }`, `is_light` luminance-derivation, `_regenerating` reentry guard, `_regenerate_theme()` skeleton, no-`Theme.clear` invariant from day 1, D-03/D-31/D-04/REVISABLE/binding docstring anchors. Empty scaffold `addons/neocade_theme/neocade_theme.tres` deleted; `main.tscn` `theme = ExtResource(...)` line removed entirely (Cycle 6 F2 fix — no placeholder comment because Godot discards `.tscn` comments on save). Atomic commit `d1d596c`.
- Phase 4 Plan 03 (2026-05-06): Button-family bespoke icons authored — 10 monochrome SVGs at 32×32 reference (`check`, `checkbox_checked/unchecked`, `radio_checked/unchecked`, `checkbutton_checked/unchecked`, `arrow_down`, `clear`, `close`) under `addons/neocade_theme/icons/`. Strict single-color `#FFFFFF` policy (Cross-AI Cycle 1 MEDIUM fix). 10 `.import` sidecars locking `svg/scale=2.0` + `mipmaps/generate=true` + `compress/mode=0` + `process/fix_alpha_border=true`, normalized via `godot --headless --import` (Cycle 6 F5 three-stage workflow) so committed paths use real `.ctex` md5 hashes and Godot-issued `uid://` UUIDs. Atomic commit `ec27939`. ICON-03 + ICON-04 → Complete; ICON-01 + ICON-02 → In Progress (remaining slots land in Phases 6/7 under the same contract).
- Phase 4 Plan 04 (2026-05-06): Color formulas + role tokens ported into NeoCadeTheme — `_mix` / `_tint_toward_base` color helpers, `_resolve_platform` / `_platform_tokens` platform helpers, `_make_raised_stylebox` raised helper, `DIRECTION_PRESETS` per-direction non-exported parameters keyed by uppercased base_color hex (Pulse=1.3 wide / Slate=0.7 narrow / Bubble=1.0 / Daybreak=1.0 / Burst=1.3 — Cycle 6 F1 reconciliation), `DIRECTION_PRESET_DEFAULT` for custom themes (`disabled_opacity=0.38` legacy fallback), `_resolve_direction_presets()` lookup, and the per-call derivation block in `_regenerate_theme()` (5-stop surface ramp + tinted offsets + text colors + state-layer overlays + role tokens). 277 lines total. D-01 invariant preserved. Atomic commit `be370d6`.
- Phase 4 Plan 05 (2026-05-06): BINDING_TABLE + iteration engine + 14 type variations — `TYPE_VARIATIONS` (14 entries, CodeLabel INCLUDED per Cycle 1 C4), `CANONICAL_SLOT_NAMES` 22-Control slot-name freeze (Cycle 2 C1; closes verifier accuracy gap), `BINDING_TABLE` 37-key canonical scorecard freeze (Cycle 1 C1) with recipe-as-Dictionary entries (`{"role":..., "raised_intensity":..., "disabled":...}`), `_resolve_recipe()` helper with 5 branches (stylebox/color/constant/font_size/icon — NO font branch per Cycle 2 N1), Cycle 2 C2 fix sourcing disabled_opacity from per-direction presets (no hard-coded 0.38), Cycle 2 M2 fix wiring `tokens.densityScale + tokens.tapPadding` into content_margin (MOBILE > DESKTOP), Cycle 6 F6 fix using FontFile (not FontVariation) for `theme.default_font`, Cycle 6 F4 fix using `checked`/`unchecked` (not `on`/`off`) for CheckButton icon slots. 1216 lines total (+939 net). 10 Button-family icons wired to CheckBox/CheckButton/OptionButton/LineEdit/PopupMenu. `helpers/_phase4_introspect.gd` build-time empirical seed generator + `helpers/BINDING_TABLE_SEED.txt` documented placeholder (Godot CLI unavailable). D-01 invariant preserved. Atomic commit `d9e405a`. FOUND-02 + ICON-02 → Complete for Phase 4 baseline.
- Phase 4 Plan 06 (2026-05-06): Pulse `.tres` (recommended starter direction) + dual verification helpers — `addons/neocade_theme/pulse_neocade_theme.tres` (445 bytes, form-2 serialization: `[gd_resource type="Theme" script_class="NeoCadeTheme"]` + `[ext_resource type="Script"]` + `script = ExtResource(...)` inside `[resource]` — script linkage preserved per Cycle 4 N5 so the file loads as a `NeoCadeTheme` instance; SC#6 data-only by construction at < 2 KiB). `_phase4_import.gd` extended with `_save_pulse_tres()` + static `_strip_theme_entries(path)` (Cycle 3 N4 Fix A) + static `_strip_load_steps_attr(header_line)` (Cycle 4 N5 RegEx helper). Dual `.planning/phases/04-.../helpers/_phase4_verify.gd` (EditorScript) + `_phase4_verify_headless.gd` (SceneTree headless) with shared assertion battery: 9-@export check, BINDING_TABLE.size() == 37 (C1), TYPE_VARIATIONS.size() == 14 with CodeLabel (C4), CANONICAL_SLOT_NAMES iteration (C1), 0.42 disabled-alpha (C2), MOBILE > DESKTOP margin (M2), Pulse vs Slate spread differentiation (L2), per-direction hover/pressed/disabled value freeze (Cycle 6 F1). Cycle 6 F3 path discipline preserved: addon root contains exactly 1 `.gd` file (`neocade_theme.gd`); helpers under `.planning/phases/04-.../helpers/`. Godot CLI unavailable in executor environment — Pulse `.tres` hand-authored to byte-identical form per BINDING_TABLE_SEED.txt precedent (Plan 04-05 Cycle 6 F7 fallback); generator pass wired and ready for first run on Godot-equipped machine. Atomic commit `a3e219f`. FOUND-03 → Complete.
- [Phase ?]: Phase 4 Plan 07 (2026-05-06): Peer direction .tres files (Slate/Bubble/Daybreak/Burst) shipped per DESIGN_TOKENS §5.2-§5.5 — _phase4_import.gd extended with _save_peer_tres() (Cycle 2 M1: declared AND called inside _init()); _phase4_verify.gd + _phase4_verify_headless.gd extended with peer-load battery closing the Cycle 2 M3 gap (each peer loaded, asserted is NeoCadeTheme, has_stylebox(normal, Button), and spread_factor matched against DIRECTION_PRESETS 0.7/1.0/1.0/1.3); main.tscn theme override restored to pulse_neocade_theme.tres (CONTEXT.md D-13 recommended starter; Plan 04-01 Cycle 6 F2 fix had cleared it). Godot CLI unavailable in executor; peer .tres hand-authored byte-aligned with _save_peer_tres+_strip_theme_entries output (Plan 04-06 Cycle 6 F7 fallback precedent). Atomic commit a39c4aa. FOUND-03 5-direction set complete.
- [Phase ?]: Phase 4 Plan 08 (2026-05-07): Addon distribution metadata shipped — LICENSE.md (MIT + OFL footnote), CHANGELOG.md (Keep-a-Changelog [Unreleased] with Phase 4 deliverables, Inter v4.0 SHA256 pin, 37 canonical Controls, 14 type variations incl CodeLabel, FONT-07/UD-2/D-05/D-03 notes), VERSION (0.4.0-phase-4 pre-release), README.md (Phase 4 minimal: Pulse starter, NeoCadeTheme.new() custom auth, FONT-09 CJK fallback, FONT-04 code-font override, FONT-07 synthetic italic, REVISABLE binding disclosure). Layout asserted (11 files, 1 .gd, no plugin.cfg, all peer .tres < 2 KiB). Atomic commit bc192a1. FOUND-01 + FONT-04 + FONT-07 + FONT-09 closed. Phase 4 plans 8/8 complete; ready for verification.

### Pending Todos

[From .planning/todos/pending/ — ideas captured during sessions]

None yet.

### Blockers/Concerns

[Issues that affect future work]

- **UD-5 (real-device cross-platform testing matrix):** User hardware/account status for Android devices + Mac + Apple Developer Program is unknown. Decision needed before Phase 10 plan is authored: confirm available test surfaces, identify gaps, decide whether v1 ships with full mobile coverage or with "verified on Windows/macOS/Linux/Web; mobile-targets pending real-device QA in v1.0.1."
- **UD-1 (MCP server swap):** Current Coding-Solo `godot-mcp` lacks screenshot capture; QA phases require it. Recommended swap to GoPeak (`npx gopeak`) addressed in Phase 3 sub-spike but should be confirmed before Phase 3 starts.

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

Last session: 2026-05-07T07:19:09.830Z
Stopped at: Phase 6 context gathered
Resume file: .planning/phases/06-lists-layout-range-tree-itemlist-tabs-containers-sliders-des/06-CONTEXT.md

## Phase 3.4 Plan 02 redirect (2026-05-06b)

The first execution of Phase 3.4 Plan 02 (by Codex) was rejected by the user. The 15 generated concept PNGs collapsed all five directions into the same UI template with only color tokens varying — every direction looked like the same screen with a hex swap. Two corrective tracks landed on 2026-05-06b:

**Track 1 — Palette correction (closed):** Phase 3.3 Revision Round 2/2 retroactively approved Codex's dark migration of Bubble (#241326 + #FFB3E6) and Daybreak (#0B2420 + #76F2D1). All five v1 directions are now dark, complying with PROJECT.md "Out of Scope: Light color mode (v1)". Direction identity, naming, personality intent, and DNA inputs preserved. See `.planning/research/THEME-DIRECTIONS.md` Verification Log entry 2026-05-06b.

**Track 2 — Shape-language correction (open, ready for re-execution):** New corrective addendum D-28/D-29/D-30 binds Plan 02 re-execution. The new authoritative spec is `.planning/mockups/3.4/image-prompts/direction-shape-language-spec.md` (replaces the deprecated `fixed-control-order-spec.md`). Each direction must commit specific values on ten shape-language axes (corner radius, button anatomy, chip/tab shape, brand mark, density, focus ring, type weights, surface ramp depth, state-layer behavior, raised offset depth) in addition to color tokens. Mockups must pass a greyscale sufficiency test (D-30): each direction must remain identifiable in greyscale by shape language alone.

**Track 3 — Subclass architecture refinement to `@abstract` (closed, 2026-05-06c):** D-31 rewritten. `NeoCadeTheme` is `@tool @abstract class_name NeoCadeTheme extends Theme` per [Godot 4.6 `@abstract` annotation](https://docs.godotengine.org/en/4.6/classes/class_%40gdscript.html#class-gdscript-annotation-abstract); cannot be instantiated directly. All 5 approved directions are concrete subclasses with real `_init()` bake-in (no empty alias). The Phase 3.4 user pick is reframed as the "recommended starter direction" (no longer "the base direction whose defaults are baked into NeoCadeTheme"). Architectural cleanup; does not affect Plan 02 mockup execution.

**Track 4 — Flat addon layout + no root `.tres` (closed, 2026-05-06d):** All `.gd` and `.tres` files live directly at `addons/neocade_theme/` — no `_dev/` or `themes/` subfolders (`fonts/` and `icons/` remain). Root `neocade_theme.tres` is removed entirely. Phase 4 must delete the existing scaffold root `.tres` before authoring the new layout. **The "5 subclass `.gd` files" portion of this track was further simplified by Track 5.**

**Track 5 — Single concrete class + data-driven `.tres` per direction (closed, 2026-05-06e; `@export` set finalized 2026-05-06f):** Final architectural simplification. Replaces the symmetric (06b) and `@abstract` (06c) subclass models with the cleanest possible architecture: **single concrete `NeoCadeTheme` class + N data-only `.tres` files** (godot-minimal-theme proven pattern). The single `addons/neocade_theme/neocade_theme.gd` declares `@tool class_name NeoCadeTheme extends Theme` (concrete, NOT abstract — users can instantiate to author custom themes). Has **9 `@export` properties total** (finalized 2026-05-06f): Core (4) — `base_color`, `accent_color`, `raised`, `platform`; Shape (5, under `@export_group("Shape")`) — `corner_radius`, `spacing`, `raised_strength`, `focus_thickness`, `outline_width`. Naming cleaned per user direction 2026-05-06f: drop redundant prefixes (was `corner_radius_base` → now `corner_radius`; was `base_spacing` → now `spacing`); intuitive verbs (was `raised_offset` → now `raised_strength`); group label `"Shape"` not `"Shape Language"`; `Vector2i` convention for any future paired x/y values. The `@export` set is intentionally minimal — limited to values that should be consistent across the entire theme. **Per-direction unique mood lives in Theme Editor entry overrides per `.tres`** (StyleBoxFlat per Control state with direction-specific bg/border/padding/etc., plus icons), NOT in a long list of exports. Dark/light is luminance-derived (`var is_light: bool = base_color.get_luminance() >= 0.5`; dark default; `is_light` flags deviation; renamed/inverted from godot-minimal-theme's `dark_theme` for project-default-dark clarity) — no separate `light_mode` toggle in v1. Each approved direction is purely data: `[gd_resource type="NeoCadeTheme" format=3]` with that direction's `@export` values + Theme Editor authored entry overrides for personality. **No per-direction `.gd` files, no class hierarchy, no subclasses.** v1 ships **1 `.gd` + 5 `.tres`** at the addon root, plus assets in `fonts/` and `icons/`. Consumers preload a specific named direction (`addons/neocade_theme/{name}_neocade_theme.tres`) or instantiate `NeoCadeTheme` for custom themes. The recommended starter direction is the showcase default + README "try this first" suggestion; ships no separate file. Evidence: PROJECT.md "What This Is" / Addon layout / Constraints / Key Decisions row updated; ROADMAP.md Phase 4 success criteria #4 finalized; REQUIREMENTS.md FOUND-02 finalized; Phase 3.4 03.4-CORRECTIVE-ADDENDUM.md D-31 code skeleton finalized with new naming + `is_light` semantics; Phase 3.4 Plan 04 updated; CLAUDE-CODE-HANDOFF.md updated.

**Re-execution executor:** Claude Code, per user direction 2026-05-06b ("i will use Claude Code from here as its clearly superior to UI design").

**Disposition of first-execution outputs:** 15 PNGs in `.planning/mockups/3.4/concepts/` deleted; gallery shells (`concept-gallery.html`, `finalist-gallery.html`, `render.js`, `data/directions.json`, `wcag-palette-audit.md`) kept; the artboard CSS in `src/neocade-mockups.css` will be rewritten by Claude Code during re-execution (the hard-coded `--radius: 12px` artboard rule is the bug locus). The deprecated `fixed-control-order-spec.md` is preserved in-place with a deprecation header for audit trail.

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
