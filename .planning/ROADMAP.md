# Roadmap: NeoCade Theme

## Overview

NeoCade is a feature-complete coverage project, not a velocity project. The journey is: dissect prior-art (`godot-minimal-theme` `.tres`, LDtk source) → research **flat MD3 / MD3 Expressive / Flat-3D Game UI** visual language (Phase 3.1) and **Godot dynamic theme architecture** (Phase 3.2) → derive and approve 5 candidate theme directions (Phase 3.3/3.4) → implement the **single concrete `NeoCadeTheme` class** + canonical `neocade_theme.tres` resource with built-in styles + fonts + icons (Phase 4 plus 2026-05-08 cleanup) → author every Godot 4.6 user-facing Control class across all states (Phases 5-7) → fill mobile + raised token deltas and audit tap targets (Phase 8) → showcase scene with style/variation controls (Phase 9) → exhaustive QA + cross-platform export validation across all 6 Godot targets (Phase 10) → GitHub Actions release pipeline (Phase 11). 15 phases (was 11; Phase 3 redirected; Phase 3.1 + 3.2 + 3.3 + 3.4 inserted 2026-05-04). **No Asset Library submission in v1.** Mockup approval is a hard blocker between Phase 3.4 and Phase 4. Mobile + raised + dynamic-theme architecture are all v1 must-haves. All 6 Godot export targets are v1 must-haves.

**v1 visual identity (locked 2026-05-04 redirect):** Flat, modern, colorful, expressive UI in the Material Design 3 / MD3 Expressive lineage with optional "extruded flat 3D" raised variation. **No textures, no patterns, no embossing, no painterly/leather backgrounds, no gradients on chrome.** Solid colors + offset darker shadow shapes for depth (extruded-flat) on the raised variation only. References: [hcgamestudios.itch.io flat-game-ui-for-mobile-games](https://hcgamestudios.itch.io/flat-game-ui-for-mobile-games), [fajrulaslim UI button flat design](https://fajrulaslim.itch.io/ui-button-flat-design/devlog/157464/ui-button-flat-design). The original Phase 3 explored 5 painterly/3D arcade-venue directions (Midnight Marquee / Boardwalk Sunset / Cabinet Chrome / Prize Pop Plaza / Orbital Playdeck) — those concept boards are preserved as v0 historical reference under `.planning/mockups/concepts/` + `.planning/mockups/03-direction-boards.*` for future revisit, but **Boardwalk Sunset is rejected**, and the other four directions are subject to a flat-MD3 reinterpretation (no textures, no embossing) in Phase 3.3.

**v1 architecture (updated 2026-05-09):** `addons/neocade_theme/scripts/neocade_theme.gd` declares `@tool class_name NeoCadeTheme extends Theme` as a single concrete, instantiable class. It has 12 `@export` properties total: top-level exports (`style`, `raised`, `platform`), the Style Overrides group (`base_color`, `accent_color`, `corner_radius`, `spacing`, `raised_strength`, `focus_thickness`, `outline_width`), and the Advanced exports (`use_runtime_popup_selection_icons`, `texture_cache`). Setters trigger `_regenerate_theme()`, which dynamically populates theme entries via `_get_base_color`-style formulas driven by exports instead of `EditorSettings`, with `is_light = base_color.get_luminance() >= 0.5` computed internally. The addon ships one canonical `addons/neocade_theme/neocade_theme.tres` resource; `NeoCadeTheme.Style` selects Bubble, Burst, Daybreak, Pulse, Slate, or Custom. The addon also ships reusable `addons/neocade_theme/scripts/neocade_theme_option_button.gd` (`@tool class_name NeoCadeThemeOptionButton extends OptionButton`) for editor-authored style pickers; it appends optional `None` after alphabetized styles and emits `theme_selected(theme, index)` after applying a selection. **No per-direction `.gd` files, no per-style `.tres` files, no class hierarchy, no subclasses, no `_dev/`, no `themes/` subfolder, and no `neocade_mobile_theme.tres`.** `platform=AUTO` auto-detects via `OS.has_feature("mobile")` at runtime.

## Phases

**Phase Numbering:**
- Integer phases (1, 2, 3): Planned milestone work
- Decimal phases (2.1, 2.2): Urgent insertions (marked with INSERTED)

Decimal phases appear between their surrounding integers in numeric order.

- [x] **Phase 1: Source-Dive — godot-minimal-theme `.tres` Dissection** - Line-by-line enumeration of passivestar's `.tres` to set the feature-completeness bar (completed 2026-05-04)
- [x] **Phase 2: Source-Dive — LDtk Source UI Mining** - Mine `C:\Programming_Files\ldtk-master\src\electron.renderer\` for polished-UI implementation patterns (completed 2026-05-04)
- [~] **Phase 3: Visual Direction Mockup + Approval Gate (REDIRECTED 2026-05-04)** - First iteration explored 5 painterly arcade-venue art directions (Midnight Marquee / Boardwalk Sunset / Cabinet Chrome / Prize Pop Plaza / Orbital Playdeck) using image-generated concepts + direction-board mockups. **User rejected the painterly/3D-textured/embossed direction at the finalist-selection checkpoint.** Outputs preserved as v0 historical reference (mood-board, concept images, direction boards). Phase superseded by Phase 3.1 + Phase 3.2; the user may revisit any of the 5 historical directions later, but each must be re-rendered through the flat-MD3 filter before becoming a v1 candidate.
- [x] **Phase 3.1: Source-Dive — Material Design 3, MD3 Expressive, and Flat-3D Game UI Research (INSERTED 2026-05-04)** - Exhaustive research on Material Design 3 (current spec: color/type/shape/motion/components/dynamic-color/surface-tinting), MD3 Expressive (newer evolution), and the "Flat-3D Game UI" / "Extruded Flat UI" pattern as exemplified by the user's itch.io references. Produces `.planning/research/MD3-RESEARCH.md` + `.planning/research/FLAT-3D-UI-RESEARCH.md`. **Parallel-eligible with Phase 3.2.** No mockups, no `.tres` work; pure research. (completed 2026-05-06)
- [x] **Phase 3.2: Source-Dive — Godot Dynamic Theme Architecture Research (INSERTED 2026-05-04 architecture revision)** - **Feasibility validation FIRST**, then architecture recipe. Reverse-engineered Godot's editor theme (`editor/themes/editor_theme_manager.cpp`) for the `base_color`/`accent_color`/`contrast` → theme entries flow, ported the relevant `godot-minimal-theme` formula ideas to export-driven theme generation, and validated the dynamic Theme spike at `.planning/spikes/dynamic-theme/`. Produces `.planning/research/GODOT-DYNAMIC-THEME-RESEARCH.md` + spike + SOURCES.md Section 13. Completed 2026-05-06; later simplified by the 2026-05-06e/f single-class data-driven architecture.
- [x] **Phase 3.3: Theme Direction Research — 5 Flat-MD3 Candidate Directions (INSERTED 2026-05-04 theme-direction insertion)** - Derived and text-approved 5 dark flat-MD3/extruded-flat directions: Bubble, Burst, Daybreak, Pulse, and Slate. All five pass anti-cyberpunk, anti-texture, dark-mode, and WCAG checks. Output: `.planning/research/THEME-DIRECTIONS.md` + SOURCES.md Section 14. Completed 2026-05-06.
- [x] **Phase 3.4: Visual Direction Mockup + Approval Gate (Flat / Extruded-Flat) (INSERTED 2026-05-04; was Phase 3.2 → 3.3 before theme-direction insertion)** - Mockups for the 5 approved directions from Phase 3.3 closed the revised gate. **Pulse is the v1 recommended starter / implementation priority; Slate, Bubble, Daybreak, and Burst still ship as v1 personality variations.** `DESIGN_TOKENS.md` is finalized and Phase 4 has consumed it.
- [x] **Phase 4: Foundation — Single `NeoCadeTheme` Class + Canonical Style Resource + Fonts + Icons (UPDATED 2026-05-09)** - Implements `addons/neocade_theme/scripts/neocade_theme.gd` as the single concrete `@tool class_name NeoCadeTheme extends Theme` with the finalized 12-property export set, including the Advanced `use_runtime_popup_selection_icons` and `texture_cache` toggles. Ships one canonical `neocade_theme.tres` resource with built-in Bubble/Burst/Daybreak/Pulse/Slate styles plus Inter Variable Roman and bespoke SVG icons. No subclasses, no per-direction `.gd`, no per-style `.tres`, no `_dev/`, no `themes/`, no `neocade_mobile_theme.tres`.
- [x] **Phase 5: Core Controls — Buttons, Inputs, Labels, Panels (desktop)** - 7 BaseButton family + 5 text classes + Label/RichTextLabel + Panel/PanelContainer with type variations (completed 2026-05-07)
- [x] **Phase 6: Lists, Layout, Range — Tree, ItemList, Tabs, Containers, Sliders (desktop)** - Tree (16 styleboxes/12 icons) + ItemList + TabBar/TabContainer + range controls + container chrome (completed 2026-05-07)
- [x] **Phase 7: Dialogs, Popups, Advanced — Window, Popups, MenuBar, ColorPicker, Graph (desktop)** - Popup-class controls themed as first-class types + ColorPicker (16 icons) + Graph stack (completed 2026-05-07)
- [x] **Phase 8: Mobile Variant Authoring** - mobile-sizing branch in `NeoCadeTheme._regenerate_theme()` (triggered by `@export platform=MOBILE`), tap-target audit, `.planning/MOBILE-DESIGN-SPEC.md` *(no separate `neocade_mobile_theme.tres`; mobile is a platform export on the single concrete class)* (completed 2026-05-07)
- [x] **Phase 9: Showcase + Token Gallery + Theme Picker** - editor-authored `res://showcase/showcase.tscn` with 9 sections + reusable `NeoCadeThemeOptionButton` dropdown that lists built-in `NeoCadeTheme.Style` values alphabetically from the canonical resource, appends optional `None`, and emits `theme_selected(theme, index)` after applying a selection; raised/platform remain resource exports, not showcase runtime controls (completed 2026-05-07; corrected 2026-05-08)
- [x] **Phase 10: QA + Cross-Platform Export Validation** - Autonomous QA evidence package complete; manual screenshot/device UAT deferred and documented (completed 2026-05-07)
- [x] **Phase 11: Distribution — GitHub Actions Release** - Single manually-triggered workflow prepared: CI checks → auto-version-bump → commit/tag/push → addon zip via `git archive` → Godot Web export of showcase scene → publish GitHub Release with both artifacts + CHANGELOG slice as body. NO Asset Library submission. (completed 2026-05-07)

**Optional buffer:** Cross-Platform Hardening Spike (4-8 hours, inserted as Phase 10.1 only if Phase 10 surfaces real-device regressions).

## Visual Identity Distinctiveness (post-v1, scoped 2026-05-10)

**Trigger:** /gsd-progress production-readiness audit on 2026-05-10. The user
flagged that the rendered theme reads as a "generic dark Godot theme with an
accent color" rather than a unique identity in the lineage of LDtk. The
underlying engine (single concrete `NeoCadeTheme`, 12-export contract, 79 SVG
icons, 5 styles with real shape language) is solid; what's missing is the
visible signature. Per user instruction, the v1 ship sequence is not gated on
this work — these run after the v1 cut so the shipped foundation stays
stable.

### Spike — Visual Identity Distinctiveness Audit (proposed)

**Trigger command:** `/gsd-spike visual-identity-distinctiveness`

**Frame:** Given the locked constraints (flat MD3 / MD3 Expressive,
anti-cyberpunk, anti-texture, anti-gradient on chrome, HD-only, dark-first
v1, single concrete `NeoCadeTheme` class), identify the signature visual
moves that would make NeoCade feel unique and "in the lineage of LDtk"
rather than a generic Godot theme.

**Inputs:**
- `.planning/research/LDTK-UI-MINING.md` — already catalogues 14+ adopt-candidate
  patterns (HAXE-01..HAXE-14+) that were studied but never translated into
  visual identity. Many were tagged "Inspiration sketch — Phase 3 mockup or
  Phase 5+ designer's call" and the call was never made.
- `.planning/mockups/3.4/concepts/*-finalist-*.png` — the user-approved Phase
  3.4 mockups, against which the spike measures the "uniqueness gap".
- The actual rendered showcase scene against the same scorecard.
- LDtk's icon library (~121 SVGs at `C:\Programming_Files\ldtk-master\app\assets\icons\`)
  and font choice (`Noto Sans Display Semicondensed`) for distinctiveness contrast.

**Deliverable:** `.planning/spikes/visual-identity-distinctiveness/REPORT.md`
that:
1. Articulates the "uniqueness gap" between the approved Phase 3.4 mockups
   and the LDtk-bar polish target — concrete, evidence-grade, not vibes.
2. Proposes 3-6 candidate signature moves that satisfy the locked
   constraints, each with a Godot 4.6 feasibility note (StyleBox primitives
   only, no shaders, no GDExtension).
3. Records 1-2 throwaway HTML mockups demonstrating the candidate moves
   against the showcase layout.
4. Marks each candidate as adopt / reject / open. The phase below consumes
   the adopt set.

### Phase 12 — Signature Visual Moves: Defaults (~7-10h)

**Trigger command:** `/gsd-phase add "Signature Visual Moves"`

**Status:** Spike series 001-005 closed 2026-05-10. Scope locked in
`.planning/spikes/visual-identity-distinctiveness/REPORT.md` and
`.planning/spikes/MANIFEST.md`. Phase 12 implements only the **default-
behavior moves** (C4 + C2' + C6). Opt-in role variations (C1 + C3)
deferred to Phase 13 to keep Phase 12 in a single executable session.

**Goal:** Resolve the user's "generic dark Godot theme with an accent
color" complaint by surfacing the existing accent in idle chrome (C2'),
fixing raised-button affordance on colored buttons (C4), and giving each
of the 5 directions a non-color/non-radius signature move (C6).

**Scope (3 default-behavior candidates):**

1. **C4 — HSV value-darken depth formula.** Replace `_raised_depth_color`
   at `addons/neocade_theme/scripts/neocade_theme.gd:800-806` with
   `Color.from_hsv(h, s, v * (1.0 - strength))` at
   `strength = 0.20 + 0.10 * raised_strength`. Hue/saturation preserved,
   depth strip stays in same hue family ~40% darker. Helps colored
   buttons (accent fills, role-colored CTAs); naturally no-op on dark
   neutral buttons where face and depth converge. ~30 min.

2. **C2' — Accent expansion in idle chrome.** Rebind ~6-8 existing
   BINDING_TABLE slots to use `accent_color` in idle state:
   selected TabBar indicator (top stripe), selected ItemList/Tree row
   left-stripe, kicker text color, active section indicators, slider
   value labels, section-header underlines. No new public exports.
   Same palette per direction — accent gets airtime via redistribution.
   ~2-3h. **The headline fix.**

3. **C6 — Per-direction signature moves.** Edit `STYLE_PERSONALITY`
   per direction with one non-color/non-radius distinguishing move:
   - Pulse: uppercase-tracked kicker labels (0.24em letter-spacing)
   - Slate: 1px hairline borders on panels + quiet-pill primary
   - Bubble: forced ≥26 corner radius across all chrome (pillow)
   - Daybreak: 1px outer mint outline (3px offset) + generous primary
     padding (no halo, no glow — fully flat per locked invariant)
   - Burst: oversized 56-64px primary CTAs with thicker depth strip
   ~4-6h.

**Minor showcase additions:** demo Pulse kicker chrome in the existing
"Buttons" section. C6 changes are otherwise visible automatically.

**Locked success criteria (carried from spike series):**
1. `raised=false` MUST show ZERO 3D elements anywhere
2. `raised=true` keeps current lift subset (panels + buttons, NOT tabs)
3. No glow halos in any state
4. Every direction identifiable at thumbnail scale without color cues
   (greyscale thumbnail render is a hard verification gate)
5. No new hues introduced — palette per direction unchanged
6. Zero public-export changes — 12-export contract preserved

**Mid-phase fallback if needed:** the natural micro-checkpoint is after
C4 + C2' (~3-4h). At that point the headline complaint is resolved
(depth fixed + accent present in idle). C6 (per-direction signatures)
can defer to a follow-up if execution runs long.

**Pre-implementation visual approval:** [mockup-refined-plan.html](.planning/spikes/visual-identity-distinctiveness/005-before-after-comparison/mockup-refined-plan.html)
shows the AFTER state for all 5 directions; [comparison.html](.planning/spikes/visual-identity-distinctiveness/005-before-after-comparison/comparison.html)
shows the BEFORE state. The forward-looking mockup is the visual contract.

### Phase 13 — Role Variation Type-Set: Opt-Ins (~5-6h)

**Trigger command:** `/gsd-phase add "Role Variations"` (after Phase 12 ships)

**Status:** Carved out from the original Phase 12 to keep each phase in a
single executable session. Independent of Phase 12 — no shared code path,
no shared verification surface.

**Goal:** Add opt-in role-coded type variations consumers can apply
deliberately when a widget semantically represents success / warning /
danger / info / accent state. Zero auto-bindings; baseline chrome
unchanged.

**Scope (2 opt-in candidates + showcase polish):**

1. **C1 — Role Label type variations.** Register 4 new entries in
   `TYPE_VARIATIONS`: `SuccessLabel`, `WarningLabel`, `DangerLabel`,
   `InfoLabel` (all extending Label). Add BINDING_TABLE color bindings
   so each variation's `font_color` reads from `role_success` /
   `role_warning` / `role_danger` / `role_info` respectively. Consumer
   usage: `my_label.theme_type_variation = "SuccessLabel"`. ~1.5h.

2. **C3 — Role Panel type variations.** Register 5 new entries:
   `AccentPanel`, `InfoPanel`, `WarningPanel`, `DangerPanel`,
   `SuccessPanel` (all extending PanelContainer). Add BINDING_TABLE
   stylebox bindings so each gets a 6%-mix tint of the corresponding
   role color over the current panel_bg. ~2-3h.

3. **New "Role Variations" showcase section.** Add a 10th section to
   `showcase/showcase.tscn` demonstrating the 4 Labels + 5 Panels with
   real consumer-style content. README documents the opt-in pattern.
   ~2h.

**Locked success criteria:**
- Default chrome unchanged from Phase 12 baseline (smoke test 30 configs)
- All 4 Labels + 5 Panels visible in the new Showcase section
- Type variations only activate when consumer applies them via
  `theme_type_variation` — never auto-bound to widget defaults

### Why split into two phases?

The user explicitly requested splitting due to token-window concerns
during execution. The split is non-deviating because:
- Phase 12 is the coherent ship-point (headline complaint resolved)
- Phase 13 is additive — depends on nothing in Phase 12, doesn't change
  Phase 12's rendered output
- Each phase has clearly bounded code surface (different files /
  different BINDING_TABLE sections / different showcase scope)
- Both phases respect the same 5 locked success criteria

### Deferred follow-up spikes (NOT in Phase 12 or 13)

- **C2** — MD3 secondary/tertiary auto-derivation from accent. Adds 2 new
  hues per direction; user explicitly rejected this in favor of C2' on
  2026-05-10. Revisit only if accent-expansion proves insufficient and
  user opts in via a future `use_md3_extended_palette: bool` export.
- **C5** — Per-direction lift thickness bump. Deferred until visual
  validation of the Phase 12 package proves the current lift sizes are
  too thin (they may already be sufficient once C2' lifts accent
  presence + C6 differentiates directions).
- **Surface tonal range expansion** — User idea: lift face brightness
  across the 5-stop ramp so dark themes like Pulse have more contrast
  between panel and button. Higher risk than C4 (touches every surface
  stop). Future spike.

**Out-of-scope guardrails:** any move that would require a custom shader,
a `plugin.cfg`, motion/animation, GDExtension, or breaking the 12-export
public contract is rejected at the phase planning gate, not the
implementation gate.

## Phase Details

### Phase 1: Source-Dive — godot-minimal-theme `.tres` Dissection
**Goal**: Produce evidence-grade enumeration of every theme entry in `passivestar/godot-minimal-theme` `.tres` (per-Control × per-state) so NeoCade's "feature-complete to godot-minimal-theme's bar" claim is verifiable, not aspirational.
**Depends on**: Nothing (first phase)
**Requirements**: RES-01, DOCS-05 (continuous update)
**Success Criteria** (what must be TRUE):
  1. SOURCES.md has a new section enumerating every theme entry in `passivestar/godot-minimal-theme` `.tres` — for each themed Control class, lists every stylebox / color / font / icon / constant entry with its base value and per-state value (normal / hover / pressed / focused / disabled where applicable).
  2. Coverage delta document compares `godot-minimal-theme`'s entries to FEATURES.md 35-class matrix; any Control themed in upstream but missing from FEATURES.md is flagged for inclusion; any Control NeoCade is themeing that upstream omits is documented as a NeoCade additive.
  3. Interaction-state transform conventions (e.g. how upstream darkens vs lightens on hover, how it handles pressed, how it draws focus) extracted as concrete numeric values, not prose impressions — feeds the M3 state-layer model decision in Phase 4.
  4. Popup/Window theming patterns (PopupMenu, PopupPanel, AcceptDialog, FileDialog, etc.) cataloged — confirms or refutes Pitfall 1.7's claim that popups need first-class type theming.
  5. Findings committed to `.planning/research/` as a dated artifact; SOURCES.md updated; no `.tres` styling commits made in this phase.
**Plans**:
- **Wave 1:** `01-01-dissection-skeleton-PLAN.md` - Create the dissection artifact skeleton and provenance anchors.
- **Wave 2:** `01-02-per-control-enumeration-PLAN.md` - Enumerate per-Control theme entries from `godot-minimal-theme`.
- **Wave 3:** `01-03-omission-and-pitfalls-PLAN.md` - Capture omissions, pitfalls, and popup/focus evidence.
- **Wave 4:** `01-04-coverage-delta-PLAN.md` - Reconcile upstream entries against NeoCade's coverage matrix.
- **Wave 5:** `01-05-sources-md-update-PLAN.md` - Update SOURCES.md and close the phase.

### Phase 2: Source-Dive — LDtk Source UI Mining
**Goal**: Mine `C:\Programming_Files\ldtk-master\src\electron.renderer\` for actual UI implementation patterns (sidebar tinting, layer panel chrome, tool-button conventions, modal flow, panel collapse, context menus, status indicators) so polish moves are anchored in a real polished UI rather than imagined ones.
**Depends on**: Nothing (parallel-eligible with Phase 1)
**Requirements**: RES-02, DOCS-05 (continuous update)
**Success Criteria** (what must be TRUE):
  1. SOURCES.md has a new section listing concrete LDtk UI patterns to adopt with file paths + line refs (e.g. "tinted sidebar: `src/electron.renderer/page/Editor.hx:N-M` — applies a per-layer hue overlay; adopt for Tree section headers"); minimum 8-12 patterns documented.
  2. SOURCES.md also lists patterns explicitly REJECTED for NeoCade with reasoning (e.g. "LDtk's hover-triggered palette popouts: rejected — Godot Theme can't carry that interaction without scripting"); minimum 3-5 rejections documented.
  3. CHANGELOG-derived "lessons learned" notes added (LDtk has shipped many UI iterations; their changelog reveals what was reverted and why).
  4. Asset directory mining: `res/atlas/` icon conventions and `res/fonts/` font choices documented; whether anything is adoptable for our bespoke SVG icon set is decided.
  5. Findings committed; SOURCES.md updated; no `.tres` styling commits made in this phase.
**Plans**:
- **Wave 1:** `02-01-provenance-and-artifact-skeleton-PLAN.md` - Establish provenance and research artifact structure.
- **Wave 2:** `02-02-haxe-ui-pattern-mining-PLAN.md` - Mine LDtk Haxe UI implementation patterns.
- **Wave 3:** `02-03-scss-chrome-and-active-verification-PLAN.md` - Mine SCSS/chrome behavior and verify active UI patterns.
- **Wave 4:** `02-04-changelog-assets-and-claim-audit-PLAN.md` - Mine changelog/assets and audit claims.
- **Wave 5:** `02-05-sources-update-and-final-verification-PLAN.md` - Update SOURCES.md and close verification.

### Phase 3: Visual Direction Mockup + Approval Gate
**Goal**: Produce the user-approved visual direction — palette + typography + full-fidelity desktop and mobile Control gallery mockups — before any `.tres` styling work begins. Hard gate.
**Depends on**: Phase 1, Phase 2 (their findings inform the mockups)
**Requirements**: RES-03, RES-04, DESIGN-01, DESIGN-02, DESIGN-03, DESIGN-04, DESIGN-05, DESIGN-06, DOCS-01, DOCS-05 (continuous update); also covers TOKEN-01..10 design definition (token values finalized here, `NeoCadeTheme` formula/binding implementation in Phase 4)
**Success Criteria** (what must be TRUE):
  1. **Step 0 — Mood-board + tooling baseline:** `.planning/research/mood-board/` contains 20-30 tagged real-arcade / cabinet / prize-counter / minority future-venue references with extraction captions, licensing status, and anti-cyberpunk notes. Coding-Solo MCP, GoPeak, screenshot fallback, and Codex image-generation availability are documented in `.planning/research/PHASE-3-TOOLING.md`; Phase 3 only requires screenshot smoke, while input injection remains Phase 10 QA work.
  2. **Step 1 — Five concept directions:** Five named art directions are produced: Midnight Marquee, Boardwalk Sunset, Cabinet Chrome, plus two research-derived directions. Each starts with an image-generated concept design, then a direction board varying layout, shape, density, accent rhythm, surfaces, control geometry, and color behavior, not just a palette recolor.
  3. **Step 2 — Typography confirmation:** Direction boards and finalist mockups use Inter Variable upright/Roman only (single variable upright file with `wght`/`opsz`; no italic file), synthetic italic labeled as v1 behavior, functional non-Latin system fallback, and consumer-supplied mono/code override. The user explicitly confirms or reopens this at a human checkpoint.
  4. **Step 3 — Finalist selection:** User selects two or three finalists from the five direction boards in writing, or routes back for targeted direction-board revisions. `DESIGN_TOKENS.md` is still not written at this point.
  5. **Step 4 — Representative full-fidelity approval:** Selected finalists receive representative desktop Control-family HTML mockups and mobile mockups at 360×800 + 768×1024 with tap-target overlays (≥48px), realistic content, visible key states, contrast math, and HTML-to-Godot fidelity disclaimers. This is a representative approval artifact, not the exhaustive 35-class implementation gallery; exhaustive Godot coverage is delivered in Phases 5-7 and proven in Phase 9/10. User approves one final direction (max 3 targeted mockup revision rounds; if not approved by round 3, `03-ESCALATION.md` captures options before proceeding).
  6. **Token spec finalized:** `DESIGN_TOKENS.md` committed before Phase 4 starts, containing both desktop and mobile token blocks (color tokens with WCAG AA-verified contrast, M3 type scale with concrete sizes, 8-step spacing scale, 4-rung corner radius, integer stroke widths, color-only elevation per Conflict 3, M3 deterministic state-layer model per TOKEN-09).
  7. **Hard blocker enforcement:** No `.tres` styling commits exist on the branch when Phase 3 closes; Phase 4 cannot start until Step 3 user approval is logged in writing.
**Plans**:
- **Wave 1:** `03-01-reference-and-tooling-baseline-PLAN.md` — Build the v0 visual-reference/tooling baseline.
- **Wave 2:** `03-02-five-concept-directions-PLAN.md` — Produce the five v0 concept directions and direction boards.
- **Wave 3:** `03-03-finalist-selection-gate-PLAN.md` — Obsolete after the 2026-05-04 redirect; preserved, not executed.
- **Wave 4:** `03-04-finalist-desktop-mobile-mockups-PLAN.md` — Obsolete after the 2026-05-04 redirect; preserved, not executed.
- **Wave 5:** `03-05-approval-tokens-and-gate-close-PLAN.md` — Obsolete after the 2026-05-04 redirect; preserved, not executed.
**UI hint**: yes

> **REDIRECTED 2026-05-04 — Phase 3 status:** First iteration reached Plan 03-03 (finalist selection gate checkpoint) before the user rejected the painterly arcade-venue direction. **All 5 direction concept images and direction boards are preserved** under `.planning/mockups/concepts/` and `.planning/mockups/03-direction-boards.*` as v0 historical reference. The user may revisit any historical direction later, but each must be re-rendered through the flat-MD3 filter before becoming a v1 candidate. **Boardwalk Sunset (the original recommended baseline) is explicitly rejected by the user.** Phase 3 will not be re-executed; its functionality is replaced by Phase 3.1 (visual research) + Phase 3.2 (architecture research) + Phase 3.3 (theme-direction research) + Phase 3.4 (flat/extruded-flat mockup approval gate).
>
> **User feedback log (2026-05-04 redirect, captured for Phase 3.2 input):**
> - **Midnight Marquee** — colors loved (LDtk-like, arcade vibe). Reject: 3D elements, textured backgrounds. Want: flat, no 3D, no textures.
> - **Boardwalk Sunset** — REJECTED. Background too warm/leather/old-fashioned. Has texture. Did appreciate flat/simple feel.
> - **Cabinet Chrome** — colors loved (similar to Midnight Marquee). Reject: 3D, textures. Want: flat.
> - **Prize Pop Plaza** — LOVED. Childish, friendly, mobile-game vibe. Raised buttons (extruded flat) work in this design. 3D bubbly/jelly/candy works. Reject: textures, embossing. Want: simple 3D interactables with colorful flat fill.
> - **Orbital Playdeck** — safest/best. Modern, dark theme, big buttons, color where it matters, nice rounding (iOS-like). Reject: textured backgrounds.
>
> **Universal new constraints surfaced by the redirect:**
> - **Avoid texture and patterns entirely** — backgrounds and surfaces are flat solid colors.
> - **No embossing, no painterly/leather/wood backgrounds, no gradients on chrome.**
> - **Flat design like Material Design 3** + **MD3 Expressive** is the primary reference language.
> - The "Flat 3D Game UI" / "Extruded Flat UI" pattern (per user's itch.io references) is the optional **raised** variation: solid color + offset darker shape underneath = depth, no soft shadows/textures.
> - 5 themes, each in 4 variations (flat × raised × desktop × mobile) — undefined number of themes supported by architecture.

### Phase 3.1: Source-Dive — Material Design 3, MD3 Expressive, and Flat-3D Game UI Research (INSERTED 2026-05-04)
**Goal**: Produce evidence-grade research on Material Design 3 (current spec), MD3 Expressive (newer evolution announced 2025-2026), and the "Flat-3D Game UI" / "Extruded Flat UI" pattern from real-world game-UI asset packs — so Phase 3.2 has a concrete, well-cited design language to build mockups against. The redirected Phase 3 produced rich painterly explorations the user rejected; this spike establishes the **flat MD3** language that the new direction must inhabit.
**Depends on**: Phase 1, Phase 2 (not Phase 3 — Phase 3.1 doesn't need the redirected painterly outputs as input)
**Requirements**: RES-NEW-01 (MD3 + MD3 Expressive research), RES-NEW-02 (Flat-3D Game UI / Extruded Flat UI pattern catalogue), DOCS-05 (continuous SOURCES.md update)
**Success Criteria** (what must be TRUE):
  1. **`.planning/research/MD3-RESEARCH.md` produced.** Covers: M3 color system (key colors, tonal palettes, dynamic-color principle, surface tinting, semantic role aliases — primary/secondary/tertiary/error/surface/on-surface/etc.), M3 type scale (display/headline/title/body/label sizes + weights with concrete pixel values), M3 shape system (corner radii by component class), M3 elevation (color-only tonal elevation per Conflict 3 — no drop shadows on chrome), M3 state-layer model (hover 8% / focus 12% + 2px ring / pressed 12% / dragged 16% / disabled 38%/12%), M3 motion principles (informational only — NeoCade has no motion in v1), and a Component → Godot Control mapping table.
  2. **MD3 Expressive coverage.** Documents what's new in MD3 Expressive vs MD3 (more saturated colors, stronger personality, expanded shape system, increased dynamic range), with explicit adopt/reject for NeoCade.
  3. **`.planning/research/FLAT-3D-UI-RESEARCH.md` produced.** Catalogues the "Flat 3D Game UI" / "Extruded Flat UI" pattern: solid-color shape + offset darker duplicate underneath = depth without gradient/texture/soft-shadow. Cites the user's itch.io references (`hcgamestudios.itch.io/flat-game-ui-for-mobile-games`, `fajrulaslim.itch.io/ui-button-flat-design`) and other public examples; documents typical button/panel/card construction recipes; produces a Godot StyleBoxFlat translation note (achievable via `bg_color` + `shadow_color` + `shadow_offset` OR via two stacked styleboxes).
  4. **Flat-MD3 vs Extruded-Flat: visual decision matrix.** Documents which Controls / contexts each variation suits (e.g., "buttons benefit from raised variation; panels stay flat in both variations; popups use raised in both variations").
  5. **Anti-cyberpunk filter audit applied** (per Phase 2 pattern). Confirms MD3 + Flat-3D-UI patterns satisfy the anti-cyberpunk hard constraint and the "no textures, no patterns" rule from the 2026-05-04 redirect.
  6. **SOURCES.md updated** with Section 11 (MD3 + MD3 Expressive) and Section 12 (Flat-3D Game UI references) — adopt/reject/open synthesis per existing dossier pattern.
  7. **No `.tres` styling commits, no mockup commits.** Phase 3.1 is pure research.
**Plans**:
- **Wave 1:** `03.1-01-provenance-and-artifact-skeletons-PLAN.md` — Create MD3 and Flat-3D research skeletons with provenance.
- **Wave 2:** `03.1-02-md3-foundations-and-godot-mapping-PLAN.md` — Map MD3 foundations to Godot Theme primitives.
- **Wave 3:** `03.1-03-md3-expressive-synthesis-PLAN.md` — Synthesize MD3 Expressive guidance for NeoCade.
- **Wave 4:** `03.1-04-flat-3d-source-survey-and-pattern-catalogue-PLAN.md` — Catalogue flat/extruded game-UI patterns.
- **Wave 5:** `03.1-05-raised-matrix-and-stylebox-recipes-PLAN.md` — Produce raised-mode matrix and StyleBoxFlat recipes.
- **Wave 6:** `03.1-06-sources-and-cross-doc-audit-PLAN.md` — Update SOURCES.md and audit cross-document consistency.
**UI hint**: no

### Phase 3.2: Source-Dive — Godot Dynamic Theme Architecture Research (INSERTED 2026-05-04 architecture revision)
**Goal**: Determine **whether and how** to implement NeoCade as a runtime-safe `@tool extends Theme` dynamic theme architecture. The original spike tested superclass/subclass behavior because that was the active hypothesis at the time; the durable finding is that export-driven Theme regeneration, saved `.tres` application, serialization round-trips, and `platform=AUTO` detection are feasible. The 2026-05-08 architecture keeps one concrete `NeoCadeTheme` class plus one canonical style `.tres` resource.
**Depends on**: Nothing (parallel-eligible with Phase 3.1)
**Requirements**: RES-NEW-03 (Godot editor theme dynamic-color flow research), RES-NEW-04 (`@tool extends Theme` export-driven feasibility validation), RES-NEW-05 (passivestar `_get_base_color` formula port), DOCS-05 (continuous SOURCES.md update)
**Success Criteria** (what must be TRUE):
  1. **Feasibility validated FIRST.** Working code spike at `.planning/spikes/dynamic-theme/` proves: (a) `@tool extends Theme` with `@export` props can regenerate entries on change, (b) a saved `.tres` instance applies regenerated entries to Controls at runtime, (c) layered Godot-only runtime detection for `platform=AUTO` using `OS.has_feature("mobile")`, Web feature tags / `OS.get_name()` where available, and mobile-preferred fallback when ambiguous, and (d) `.tres` serialization behavior is inspected and understood. The subclass positive/negative controls are retained as research evidence, but production no longer uses subclasses.
  2. **`.planning/research/GODOT-DYNAMIC-THEME-RESEARCH.md` produced.** Documents: editor theme generation flow (from `editor/themes/editor_theme_manager.cpp`), passivestar's `_get_base_color(brightness_offset, saturation_multiplier)` formula re-ported as a runtime-safe `NeoCadeTheme` method, `@tool extends Theme` + `@export` setter recipe, runtime API surface (`Theme.set_stylebox/set_color/set_font/set_constant`), `OS.has_feature("mobile")` runtime-detection contract, pitfall catalogue (infinite-loop setter traps, resource serialization, `@tool` editor vs runtime divergence, GL Compatibility compatibility).
  3. **Editor theme reverse-engineering.** `editor/themes/editor_theme_manager.cpp`/`editor_color_map.cpp`/`scene/theme/theme.cpp`/`theme_db.cpp`/`scene/resources/style_box.cpp` enumerated for the patterns that drive dynamic theme entries from base/accent/contrast inputs.
  4. **Anti-pattern audit.** Confirms zero `EditorInterface` / `EditorSettings` / `EDSCALE` references in the proposed runtime-safe architecture (Phase 1 D-05 discipline re-applied).
  5. **SOURCES.md Section 13 added** with adopt/reject/open synthesis. Confidence raised to HIGH if feasibility passes; otherwise LOW with blockers documented.
  6. **Fallback path documented.** If any strict feasibility check fails or is blocked, documents fallback options and recommends one strongest fallback for user approval. Historical fallback examples included a hybrid `@tool` generator script that produced static `.tres` resources from the formula model; the chosen Phase 4 path is direct `NeoCadeTheme` export-driven regeneration instead.
  7. **No `.tres` styling commits** under `addons/neocade_theme/`. Spike `.tres` files live under `.planning/spikes/dynamic-theme/` (research-only, not v1 implementation).
**Plans**:
- **Wave 0:** `03.2-01-provenance-and-source-map-PLAN.md` — Create the Godot dynamic-theme research artifact skeleton, source map, strict-gate placeholders, and spike evidence table.
- **Wave 1:** `03.2-02-engine-theme-flow-and-formula-port-PLAN.md` — Reverse-engineer Godot editor theme flow, inventory runtime Theme APIs, and document the passivestar formula port.
- **Wave 2 *(blocked on Wave 1 completion)*:** `03.2-03-spike-template-and-visual-scene-PLAN.md` — Build the research-only prototype-template spike under `.planning/spikes/dynamic-theme/`, consuming Plan 02's formula-port recipe before finalizing `_regenerate()` logic.
- **Wave 3 *(blocked on Wave 2 completion)*:** `03.2-04-strict-feasibility-verifier-PLAN.md` — Run strict feasibility validation, serialization inspection, negative-control checks, AUTO platform validation, and Godot-unavailable fallback evidence protocol.
- **Wave 4 *(blocked on Wave 3 completion)*:** `03.2-05-architecture-recipe-fallback-and-contract-PLAN.md` — Write the Phase 4 architecture recipe, AUTO recipe, regeneration performance note, and fallback recommendation. Its subclass-contract output is historical evidence superseded by the 2026-05-06e/f single-class simplification.
- **Wave 5 *(blocked on Wave 4 completion)*:** `03.2-06-sources-and-closeout-audit-PLAN.md` — Add SOURCES.md Section 13 and run the final cross-document/no-addon-change audit.
**UI hint**: no
**Parallel-eligible with**: Phase 3.1

### Phase 3.3: Theme Direction Research — 5 Flat-MD3 Candidate Directions (INSERTED 2026-05-04 theme-direction insertion)
**Goal**: Derive **5 candidate theme directions from scratch** in the flat-MD3 + extruded-flat idiom — informed by the user's new goals/restrictions, exemplar references, and per-v0-direction reactions (as DNA inputs only, NOT name carryovers). Produce a user-approval checkpoint at text-level (names + base/accent colors + personality summaries) before Phase 3.4 spends effort on mockups.
**Depends on**: Phase 3.1 (visual design language input). Optionally informed by Phase 3.2 (architecture findings) but does not require it to complete.
**Requirements**: RES-NEW-06 (5 candidate theme directions derived from user goals/restrictions/DNA), DESIGN-NEW-DIR-01 (commercial example survey), DESIGN-NEW-DIR-02 (per-direction filter audit), DOCS-05 (continuous SOURCES.md update)
**Success Criteria** (what must be TRUE):
  1. **`.planning/research/THEME-DIRECTIONS.md` produced** with 5 candidate directions, each carrying: one-word direction name, future `.tres` filename, base color hex, accent color hex (WCAG AA contrast verified), personality summary (2-3 sentences), target use case, anti-cyberpunk + anti-texture filter audit, rationale citing inputs.
  2. **Names: keep / revise / replace per fit.** Direction names are not under a hard "must be new" rule. Each direction's name is chosen based on fit: keep a v0 name if the personality concept still applies post-revision (with universal anti-texture/etc. revisions applied — see SC#7), revise it if the fit has shifted, or replace it entirely if research surfaces a stronger archetype. **Only Boardwalk Sunset is hard-rejected** (user explicitly rejected the concept). Other v0 names (Midnight Marquee, Cabinet Chrome, Prize Pop Plaza, Orbital Playdeck) are eligible to survive if appropriate.
  3. **5 directions span personality space.** Distinct archetypes (e.g., dark-saturated-arcade, modern-minimal-dark, playful-raised-friendly, daylight-friendly, MD3-Expressive-statement) — not 5 similar themes.
  4. **Per-v0-direction reaction → DNA mapping table.** Explicit table showing what user loved (extracted as DNA) vs rejected (dropped) per v0 direction. Each direction's rationale references which DNA elements informed it (positive AND negative).
  5. **Commercial example survey.** 10-15 commercial flat-MD3 / Flat-3D Game UI references documented (mobile games, MD3 Expressive showcases, itch.io packs similar to user's exemplars). Each new direction cites which surveyed examples validated it.
  6. **Anti-cyberpunk + anti-texture filter pass per direction.** Each of the 5 directions × each filter rule × pass/fail/notes. Any direction failing a filter is redesigned or replaced before commit.
  7. **Universal revisions applied across ALL directions** (regardless of name retention). Every direction is rendered through: no textures / no patterns / no embossing / no painterly chrome / no gradients on chrome; flat MD3 / MD3 Expressive language; optional extruded-flat raised variation; Inter Variable Roman typography; dynamic regeneration via `NeoCadeTheme` exports. Surviving v0 names get their *visual treatment* re-rendered — the *name* survives, the *painterly/textured/embossed treatment* does NOT.
  8. **Recommended-starter selection NOT pre-decided.** Phase 3.3 produces 5 peer directions; Phase 3.4 later selected Pulse as the recommended starter / implementation priority without giving it architectural privilege.
  9. **User-approval checkpoint.** After the 5 directions are documented, agent presents them via AskUserQuestion. User approves all 5 / revises specific directions (max 2 revision rounds) / rejects all 5 (escalation discussion). Approval is text-level only — no mockups exist yet at this phase.
  10. **SOURCES.md Section 14 added** with adopt/reject/open synthesis.
  11. **No mockup commits, no `.tres` commits.** Phase 3.3 is research-only.
**Plans**:
- **Wave 1:** `03.3-01-survey-provenance-and-filter-contract-PLAN.md` — Establish direction-survey provenance and filter contract.
- **Wave 2:** `03.3-02-direction-synthesis-and-filter-audit-PLAN.md` — Synthesize the five approved dark flat-MD3 directions.
- **Wave 3:** `03.3-03-sources-closeout-and-approval-gate-PLAN.md` — Update SOURCES.md and close the text-level approval gate.
**UI hint**: no
**Parallel-eligible with**: Phase 3.2 (Phase 3.1 must complete first; Phase 3.3 + 3.2 can run in parallel after that)

### Phase 3.4: Visual Direction Mockup + Approval Gate (Flat / Extruded-Flat) (INSERTED 2026-05-04; was Phase 3.2 → 3.3 before theme-direction insertion)
**Goal**: Mock up the 5 user-approved directions from Phase 3.3, demonstrating the dynamic `NeoCadeTheme` single-class architecture through flat/raised and desktop/mobile evidence. Plan 02 selected **Pulse** as the v1 recommended starter / implementation priority while keeping Slate, Bubble, Daybreak, and Burst as v1 personality variations. Plan 03 produces the full-fidelity Pulse 4-grid (flat × raised × desktop × mobile), color override preview row, and Control/state coverage matrix; Plan 04 writes DESIGN_TOKENS.md as the single-class style/data contract. Hard gate before Phase 4.
**Depends on**: Phase 3.1 (visual design language) + Phase 3.2 (architecture feasibility) + Phase 3.3 (5 approved candidate directions — names + palettes + personalities)
**Requirements**: DESIGN-NEW-01..06 (5 approved directions, later consolidated into built-in `NeoCadeTheme.Style` values), TOKEN-NEW-01..10 (single-class/canonical-resource token spec), DESIGN-NEW-MOBILE-01..03 (mobile variant spec), DESIGN-NEW-DYNAMIC-01 (mockups demonstrate dynamic class behavior)
**Success Criteria** (what must be TRUE):
  1. **5 directions mocked up using Phase 3.3's approved names + palettes + personalities.** Phase 3.4 does NOT invent new directions — it visualizes Phase 3.3's outputs. There are no per-direction `.gd` classes; the final implementation now exposes directions as `NeoCadeTheme.Style` enum values in one canonical resource.
  2. **Step 1 — Concept boards (flat/raised + desktop/mobile evidence):** Each of the 5 directions produces three rendered concept variants — desktop-flat, mobile-flat, and mobile-raised. 5 directions × 3 variants = **15 concept PNGs total**. User selected Pulse as the recommended starter / implementation-priority finalist after reviewing these boards; the other four directions remain v1 variations.
  3. **Step 2 — Finalist full-fidelity mockups (4-grid):** Pulse gets full-fidelity HTML mockups in the 4-grid format: top-left `raised=false, platform=DESKTOP`, top-right `raised=false, platform=MOBILE`, bottom-left `raised=true, platform=DESKTOP`, bottom-right `raised=true, platform=MOBILE`. Plus 1 row showing `base_color`/`accent_color` override examples (consumer-customization preview). **All four cells share one `NeoCadeTheme` data resource contract** (proving the dynamic system). Every Control × every state combination demonstrated, including Pitfall 1.1's combinations (`pressed_focus`, `checked_focus`, `hover_pressed`).
  4. **Step 3 — Approval & DESIGN_TOKENS.md:** User approves the final Phase 3.4 mockup direction and confirms Pulse as recommended starter (or requests focused revisions). DESIGN_TOKENS.md finalized as **single-class/canonical-resource-oriented**. Documents per direction: style name, default `base_color`, default `accent_color`, export values, and hidden direction personality intent. Plus shared class contract (Inter type scale, M3 state-layer model, focus-ring strategy, anti-texture rules) and variation override blocks (flat / raised / desktop / mobile / AUTO detection).
  5. **Anti-cyberpunk + anti-texture filter pass at finalist gate** (Phase 3.3 already filtered the directions; this is a re-check at mockup level).
  6. **Hard blocker enforcement:** No `.tres` styling commits under `addons/neocade_theme/` exist on the branch when Phase 3.4 closes; Phase 4 cannot start until Step 3 user approval is logged in writing.
  7. **Historical preservation:** All Phase 3 (v0) artifacts remain in `.planning/mockups/concepts/` + `.planning/mockups/03-direction-boards.*`. Phase 3.4 outputs go to `.planning/mockups/3.4/` so iterations don't conflict.
**Plans**:
- **Wave 1:** `03.4-01-mockup-foundation-and-data-contract-PLAN.md` — Build mockup foundation and direction data contract.
- **Wave 2:** `03.4-02-stage-1-concept-boards-and-finalist-selection-PLAN.md` — Produce/revise concept boards and select Pulse as recommended starter.
- **Wave 3:** `03.4-03-finalist-four-grid-mockups-and-approval-gate-PLAN.md` — Produce Pulse four-grid finalist mockups and close approval.
- **Wave 4:** `03.4-04-design-tokens-closeout-and-phase-4-handoff-PLAN.md` — Finalize DESIGN_TOKENS.md and Phase 4 handoff.
**UI hint**: yes

### Phase 4: Foundation — Single `NeoCadeTheme` Class + Canonical Style Resource + Fonts + Icons (UPDATED 2026-05-09)
**Goal**: Build the structural foundation — addon directory layout, bundled OFL font, bespoke SVG icons, and the **single concrete `NeoCadeTheme` class** that dynamically regenerates theme entries from the finalized 10 `@export` properties. v1 ships one canonical `neocade_theme.tres` resource with built-in Bubble, Burst, Daybreak, Pulse, and Slate styles. At runtime, consumers load `neocade_theme.tres`, optionally toggle `style` / `raised` / `platform` / `base_color` / `accent_color`, and the class regenerates all theme entries to match. `platform=AUTO` auto-detects via `OS.has_feature("mobile")`.
**Depends on**: Phase 3.4 (mockup approval is a hard prerequisite) + Phase 3.3 (5 approved directions define the built-in styles Phase 4 implements) + Phase 3.2 (dynamic theme feasibility validation must have passed)
**Requirements**: FOUND-01, FOUND-02, FOUND-03, FONT-01, FONT-02, FONT-03, FONT-04, FONT-05, FONT-06, FONT-07, FONT-08, FONT-09, ICON-01, ICON-02, ICON-03, ICON-04; also implements TOKEN-01..10 in code (token values were defined in Phase 3)
**Success Criteria** (what must be TRUE):
  1. **Addon layout exists (flat, single-class, 2026-05-08):** `addons/neocade_theme/` contains `fonts/`, `icons/`, and `scripts/` subdirectories and only runtime addon resources: `neocade_theme.tres`, `scripts/neocade_theme.gd`, `scripts/neocade_theme_option_button.gd`, `fonts/inter_variable.ttf`, `fonts/inter_ofl.txt`, header FontVariation resources, SVG icons, and Godot import sidecars. Package docs (`README.md`, `docs/usage.md`, `CHANGELOG.md`, `LICENSE.md`) and root `VERSION` stay outside the addon. **No per-style `.tres` files. No `plugin.cfg`. No separate `neocade_mobile_theme.tres` file** — mobile is a `@export platform=MOBILE` toggle on the single class.
  2. **Fonts bundled correctly:** Inter Variable upright (`inter_variable.ttf` from v4.x) bundled as the ONLY font at `addons/neocade_theme/fonts/` per UD-4 / Option D (Inter Variable Roman ONLY in v1; no Outfit, no Noto Sans, no JetBrains Mono — all deferred per FONT-REVIEW.md 2026-05-04). Reserved Font Name preserved in the font metadata; imported as `FontFile.tres` referenced by `uid://`; `fonts/inter_ofl.txt` carries Inter's Reserved Font Name notice + copyright block; import settings are Grayscale antialiasing + Light hinting + Auto subpixel positioning (per STACK + PITFALLS 5.5 for GL Compatibility).
  3. **Icons bundled correctly:** ~25-40 bespoke SVG icons authored at 32×32 reference at `addons/neocade_theme/icons/`; every icon has `Scale = 2.0` and `Linear With Mipmaps` filter explicitly set in its `.import` sidecar (per STACK + PITFALLS); icons are monochrome SVGs (no baked color) so Godot's icon `modulate` can tint per accent role; no Material Symbols/Lucide/Phosphor/external library bundled.
  4. **`NeoCadeTheme` class works (single concrete class, 12-property `@export` set, 2026-05-09):** `addons/neocade_theme/scripts/neocade_theme.gd` declares `@tool class_name NeoCadeTheme extends Theme` with **12 `@export` properties total**. **Top level (3):** `style`, `raised`, `platform`. **Style Overrides group (7):** `base_color`, `accent_color`, `corner_radius`, `spacing`, `raised_strength`, `focus_thickness`, `outline_width`. **Advanced group (2):** `use_runtime_popup_selection_icons`, `texture_cache`. `style` is the explicit direction selector and `Style.CUSTOM` is manual/custom mode. Setters regenerate theme entries via `_regenerate_theme()`.
  5. **Canonical `.tres` works (2026-05-08):** `addons/neocade_theme/neocade_theme.tres` is `[gd_resource type="Theme" script_class="NeoCadeTheme" format=3]` and defaults to the Pulse style. Changing `style` to Slate/Bubble/Daybreak/Burst applies that direction's exported values and hidden personality without loading another `.tres`.
  6. **Saved `.tres` behavior is honest Godot behavior:** Godot may serialize generated Theme entries after editing and saving the scripted Theme resource. NeoCade does not ship an EditorPlugin or custom resource saver to hide that behavior.
  7. **All theme entries declared via dynamic regeneration:** When `neocade_theme.tres` is loaded with any built-in style, the resulting Theme has entries for ALL 37 scorecard Control rows plus the current runtime and editor integration `TYPE_VARIATIONS` registry populated. Phase 8 treats the live registry as authoritative for TYPEVAR-06.
  8. **CJK is documented (UD-2 default):** README documents the override pattern for consumers who need CJK — append CJK font to a duplicated theme's `default_font.fallbacks` — explicitly NOT bundled in v1.
**Plans**:
- **Wave 1:** `04-01-scaffold-deletion-and-class-shell-PLAN.md` — Delete stale scaffold resource and author the `NeoCadeTheme` class shell.
- **Wave 2:** `04-02-fonts-and-OFL-PLAN.md` — Bundle Inter Variable Roman and OFL metadata.
- **Wave 3:** `04-03-button-family-icons-PLAN.md` — Author the baseline button-family SVG icon set.
- **Wave 4:** `04-04-color-formulas-and-role-tokens-PLAN.md` — Port dynamic color formulas and role token derivation.
- **Wave 5:** `04-05-binding-table-and-iteration-engine-PLAN.md` — Implement BINDING_TABLE, type variations, and regeneration walk.
- **Wave 6:** `04-06-pulse-tres-and-verification-PLAN.md` — Create Pulse `.tres` and verification helpers.
- **Wave 7:** `04-07-peer-themes-and-main-tscn-PLAN.md` — Add Slate/Bubble/Daybreak/Burst `.tres` resources and starter scene wiring.
- **Wave 8:** `04-08-addon-metadata-and-readme-PLAN.md` — Ship repo-root README/addon usage docs, CHANGELOG, VERSION, and license files while keeping the addon folder runtime-clean.

### Phase 5: Core Controls — Buttons, Inputs, Labels, Panels (desktop)
**Goal**: Author the desktop theme entries for the keystone Controls — every BaseButton-family class, every text input/display class, every Label class, every Panel class — by populating `NeoCadeTheme._regenerate_theme()` formulas and data-resource override rules so the most-used surface area of the theme is feature-complete dynamically.
**Depends on**: Phase 4
**Requirements**: COV-02, COV-03, TYPEVAR-01, TYPEVAR-02, TYPEVAR-03, TYPEVAR-04, TYPEVAR-05; cumulative contributors: COV-01 (begins here, completes in Phase 7), COV-07 (begins here, completes in Phase 7), COV-09 (focus indicator pattern established here, applied through Phase 7, verified in Phase 10), TYPEVAR-06 (documentation written across phases, finalized in Phase 8)
**Success Criteria** (what must be TRUE):
  1. **All 7 BaseButton-family Controls themed:** Button, CheckBox, CheckButton, OptionButton, MenuButton, ColorPickerButton, LinkButton each have full state coverage (normal/hover/pressed/focused/disabled where applicable) populated via `NeoCadeTheme._regenerate_theme()` formulas; every state combination renders correctly in the showcase (or temporary test scene) on GL Compatibility renderer; bespoke SVG icons for check/radio/toggle/arrow_down/clear/close + OptionButton arrow + CheckBox/CheckButton on/off load correctly.
  2. **All 5 text classes themed:** Label, RichTextLabel, LineEdit, TextEdit, CodeEdit each have normal/focus/read_only styleboxes + caret + selection + placeholder colors populated; CodeEdit gutter (line numbers, breakpoint glyph, fold arrow) is styled (syntax highlighting NOT in scope per FEATURES AF-7).
  3. **All 5 core runtime Button type variations + 6 Label type variations + 1 RichTextLabel + 2 Panel variations declared:** PrimaryButton / GhostButton / DangerButton / IconButton / FlatButton; HeaderLarge / HeaderMedium / HeaderSmall / Caption / CodeLabel / Kicker; InfoText; CardPanel / HeroPanel — all 14 core runtime variations declared in `TYPE_VARIATIONS` alongside editor-only integration variations. Fonts are set EXPLICITLY on every variation (per PITFALLS 1.2 — type variations DO NOT inherit fonts from base, even when stylebox inheritance works); verified in a runtime scene, not just editor preview.
  4. **Panel + PanelContainer + SpinBox themed:** Panel and PanelContainer have base + variations; SpinBox themed end-to-end (line edit + arrows).
  5. **Focus stylebox is an OUTER ring, not a fill replacement (Pitfall 1.1):** Focus rendered as 2px ring drawn OUTSIDE corner radius bounds in `role.primary`; verified that focus remains visible under hover, pressed, AND checked combinations (Tab-walk a test scene with one of each); shadow alpha on every StyleBoxFlat is `shadow_size = -1` (the disable value per Godot #98162).
**Plans:** 7/7 plans complete

Plans:
- [ ] `05-01-godot-cli-and-phase5-verifier-scaffold-PLAN.md` — Resolve Godot 4.6 CLI and create Phase 5 verifier scaffolding.
- [ ] `05-02-direction-shape-schema-and-recipe-resolution-PLAN.md` — Add direction shape schema and recipe resolution.
- [ ] `05-03-basebutton-family-and-button-variations-PLAN.md` — Theme BaseButton family and button variations.
- [ ] `05-04-text-label-and-panel-variations-PLAN.md` — Add Kicker, text variation slots, and panel variation chrome.
- [ ] `05-05-text-codeedit-polish-PLAN.md` — Finish text/CodeEdit polish and CodeEdit folded icon.
- [ ] `05-06-spinbox-icons-and-imports-PLAN.md` — Add SpinBox up/down SVG icons and official slot wiring.
- [ ] `05-07-final-resource-saver-and-data-only-verification-PLAN.md` — ResourceSaver round-trip and final exact `.tres` data-only verification.

### Phase 6: Lists, Layout, Range — Tree, ItemList, Tabs, Containers, Sliders (desktop)
**Goal**: Author the desktop theme entries for the second tier of Controls — Tree (the heaviest single class with 16 styleboxes + 12 icons + ~26 constants), ItemList, the Tab family, container chrome, all range controls — by extending `NeoCadeTheme._regenerate_theme()` formulas.
**Depends on**: Phase 5
**Requirements**: COV-04, COV-05; cumulative contributors: COV-01, COV-07, COV-09, TYPEVAR-06
**Success Criteria** (what must be TRUE):
  1. **Tree fully themed:** All 16 Tree styleboxes (panel + selected/cursor styles for focused/unfocused × hover/pressed) populated; all 12 Tree icons (expand/collapse + checked/unchecked + indeterminate + select arrow + sort arrows) bundled and wired; all ~26 Tree constants (icon_separation, item_margin, indent, scroll_speed, etc.) set; Tree renders correctly with multi-level test data including selection, hover, expanded/collapsed states, and a focused-cell screenshot at base scale.
  2. **ItemList + TabBar + TabContainer + FoldableContainer themed:** ItemList renders selected/cursor states correctly; TabBar and TabContainer share a coherent state model (active/inactive/hover/disabled tabs); increment/decrement/menu icons load on TabBar + TabContainer; FoldableContainer header chrome themed.
  3. **All 6 range controls themed:** HSlider, VSlider, ProgressBar, HScrollBar, VScrollBar all have grabber + track + (where applicable) tick styling; ScrollBar increment/decrement/grabber icons load.
  4. **Container chrome where applicable:** Panel, PanelContainer (already in Phase 5), ScrollContainer, SplitContainer, MarginContainer constants populated; layout-only Containers (HBox/VBox/Flow/Grid/Center) get only `separation` constants per FEATURES AF-11 (no chrome).
  5. **Dynamic regeneration round-trips:** Phase 6's additions to `NeoCadeTheme._regenerate_theme()` produce correctly themed entries for ALL Phase 6 Controls when `neocade_theme.tres` is loaded with any built-in style and `platform=DESKTOP`, `platform=MOBILE`, OR `platform=AUTO` (resolved at runtime). Mobile-specific values (e.g., ScrollBar grabber width) come from the `platform`-aware branch in the regeneration logic, not a separate `.tres` file. Verifiable by opening the canonical resource and toggling `style` / `platform` exports — entries update live in the Theme Editor.
**Plans**: 5 plans

Plans:
- [x] `06-01-PLAN.md` — Freeze official Godot 4.6.2 slots and create strict Phase 6 verification/ResourceSaver helpers.
- [x] `06-02-PLAN.md` — Theme Tree fully with official slots, dense data-view behavior, focus, constants, and disclosure/check/sort icons.
- [x] `06-03-PLAN.md` — Theme ItemList and FoldableContainer with shared list-selection and disclosure header vocabulary.
- [x] `06-04-PLAN.md` — Theme TabBar and TabContainer with a shared tab model plus navigation/menu/drop/close icons.
- [x] `06-05-PLAN.md` — Theme range controls and container chrome, then run full all-direction ResourceSaver round-trip verification.

### Phase 7: Dialogs, Popups, Advanced — Window, Popups, MenuBar, ColorPicker, Graph (desktop)
**Goal**: Author the desktop theme entries for popup-class Controls (which are separate Windows that don't inherit overrides per Pitfall 1.7) plus the advanced Controls (MenuBar, ColorPicker with 16 bespoke icons, Graph stack), completing desktop COV-01 100% Control coverage.
**Depends on**: Phase 6
**Requirements**: COV-06, COV-08; closes cumulative COV-01 (37/37 scorecard rows themed on desktop), COV-07 (container chrome complete), COV-09 (focus indicator on every focusable Control)
**Success Criteria** (what must be TRUE):
  1. **All 8 popup-class types themed as FIRST-CLASS theme types (Pitfall 1.7):** PopupPanel, PopupMenu, AcceptDialog, ConfirmationDialog, FileDialog, TooltipPanel, TooltipLabel, Window each have explicit theme entries — NOT relying on inheritance from PopupPanel or Window. Verified at runtime in a test scene by triggering each popup type and screenshotting it. Tooltip readability verified per Pitfall 4.3 (sufficient text-on-bg contrast on TooltipPanel/TooltipLabel).
  2. **MenuBar themed:** MenuBar normal/hover/pressed/disabled states populated; submenu (PopupMenu spawned from MenuBar) inherits from PopupMenu type rather than relying on parent Control overrides.
  3. **ColorPicker themed with all 16 bespoke icons:** ColorPicker preset / screen-pick / sample-bg / recent / hue-cycle / color-mode / shape-mode / etc. icons all loaded; ColorPickerButton popup uses the ColorPicker theme correctly.
  4. **Graph stack themed (basic v1 level):** GraphEdit grid + minimap + connection lines styled; GraphNode title + slot styling + selected state; GraphFrame theming if applicable. Acceptance is "renders cleanly with arcade identity" — GraphEdit is heavyweight, deeper polish deferred to v1.x if needed.
  5. **37/37 Control coverage achieved on desktop:** Every Control class enumerated in MINIMAL-THEME-COVERAGE-DELTA.md's 37-row scorecard has at least one custom theme entry produced by `NeoCadeTheme._regenerate_theme()` (no engine fallback for any of them); verifiable by loading the canonical resource with any built-in style and `platform=DESKTOP`, then diffing entry count against the Phase 1 godot-minimal-theme enumeration (final verification happens in Phase 10's COV-10 check).
  6. **FileDialog parent/folder/file/file-up/back/forward/reload icons all load.**
**Plans**: 5 plans

Plans:
- [x] `07-01-PLAN.md` — Freeze official Phase 7 Godot 4.6.2 slots and add verifier/ResourceSaver helper foundation.
- [x] `07-02-PLAN.md` — Theme Window, popup/dialog shells, tooltips, MenuBar, and PopupMenu.
- [x] `07-03-PLAN.md` — Theme FileDialog and bind official FileDialog icon slots.
- [x] `07-04-PLAN.md` — Theme ColorPicker and ColorPickerButton with official icon/focus coverage.
- [x] `07-05-PLAN.md` — Theme GraphEdit/GraphNode/GraphFrame and run full verification plus ResourceSaver round-trip.

### Phase 8: Mobile Variant Token Block + Tap-Target Audit (UPDATED for dynamic architecture)
**Goal**: Fill in the **mobile branch** of `NeoCadeTheme._regenerate_theme()` so that the canonical resource with any built-in style and `platform=MOBILE` (or `platform=AUTO` on a mobile device) produces correctly sized, accessible mobile entries. Audit that every interactive Control satisfies the >=48px tap-target rule (iOS HIG 44pt + Material 3 48dp). Document every desktop-vs-mobile delta. **Mobile is NOT a separate `.tres` file** — it's an `@export platform` toggle on the single concrete class.
**Depends on**: Phase 7 (mobile branch logic needs every desktop entry's regeneration formula to exist first)
**Requirements**: MOBILE-01, MOBILE-02, MOBILE-03, MOBILE-04, MOBILE-05, MOBILE-06, MOBILE-07, MOBILE-08, DOCS-02, TYPEVAR-06 (variation documentation finalized)
**Success Criteria** (what must be TRUE):
  1. **Mobile branch in `_regenerate_theme()` complete:** `NeoCadeTheme._regenerate_theme()` contains a `platform=MOBILE` (or `_resolve_platform()=MOBILE`) branch that applies all mobile sizing deltas: button heights -> 48px floor, body text 16px vs desktop 14px, spacing scale +50% on `space.4` and above, corner radii UNCHANGED across desktop/mobile per brand-identity rule. Verifiable by loading the canonical resource, setting `platform=MOBILE`, and inspecting the regenerated entries match the spec; doing the same with `platform=DESKTOP` produces desktop sizes.
  2. **Tap-target audit passes:** A tap-target audit script (Phase 8 deliverable) iterates every interactive Control type produced by `NeoCadeTheme._regenerate_theme()` with `platform=MOBILE`, computes the rendered minimum tap rect (`minimum_size` + relevant content margins), and asserts ≥48px on both axes; script produces a pass/fail report; in v1 the report MUST show 100% pass.
  3. **`.planning/MOBILE-DESIGN-SPEC.md` committed:** Documents every desktop-vs-mobile delta with concrete numbers and rationale (e.g. "Button.minimum_size.y: desktop 32 / mobile 48 — satisfies iOS HIG 44pt + Material 3 48dp simultaneously"); covers all 37 Controls in the scorecard; references CROSS-PLATFORM.md per-target table; documents that one dynamic theme covers all Android density buckets via Godot's `content_scale_factor` + stretch modes (NOT per-density `.tres` files); documents that `platform=AUTO` is the recommended setting for cross-platform consumers.
  4. **Theme toggle wired in test scene (or showcase if Phase 9 is started):** A toggle button in the test scene cycles the canonical resource's `platform` export between DESKTOP / MOBILE / AUTO, plus a separate toggle for `raised` (true/false). Cycling produces correct re-rendered entries (per PITFALLS 10.3 clean state switching); tap targets visibly grow when switching to MOBILE; visual identity (palette, typography, corner radii) stays consistent across all platform settings — proving brand-identity preservation.
  5. **Mobile retains theme identity across all directions:** Each approved built-in style produces correctly sized mobile entries when toggled to `platform=MOBILE`; no style loses its personality or accidentally overrides mobile sizing. The mobile branch follows iOS HIG + Material 3 minimums for tap targets / type scale / accessibility but explicitly does NOT mimic native iOS or Android visual language (verified by visual review against Phase 3.4 mobile mockup approval).
**Plans**: 5 plans

Plans:
- **Wave 1:** `08-01-PLAN.md` - Create the Phase 8 verifier, tap-target audit foundation, and mobile contract artifact.
- **Wave 2 *(blocked on Wave 1 completion)*:** `08-02-PLAN.md` - Harden forced platform token behavior and raised/platform orthogonality.
- **Wave 3 *(blocked on Wave 2 completion)*:** `08-03-PLAN.md` - Pass the all-direction forced-mobile 48px tap-target audit.
- **Wave 4 *(blocked on Wave 3 completion)*:** `08-04-PLAN.md` - Author `.planning/MOBILE-DESIGN-SPEC.md` with 37-row and type-variation traceability.
- **Wave 5 *(blocked on Wave 4 completion)*:** `08-05-PLAN.md` - Wire the minimal platform/raised test-scene proof and close full verification.

Cross-cutting constraints:
- Preserve the dynamic architecture: one concrete `addons/neocade_theme/scripts/neocade_theme.gd`, one canonical `addons/neocade_theme/neocade_theme.tres`, and the locked style/export surface.
- Do not create `neocade_mobile_theme.tres`, per-density theme resources, subclasses, per-direction scripts, per-style `.tres` files, `_dev/`, or `themes/`.
- Verification must cover forced `DESKTOP`, forced `MOBILE`, host `AUTO`, all five directions in forced mobile mode, 48px tap-target audit, raised/platform orthogonality, no `Theme.clear`, and `.planning/MOBILE-DESIGN-SPEC.md`.
**UI hint**: yes

### Phase 9: Showcase + Token Gallery + Theme Picker (UPDATED for dynamic architecture; corrected 2026-05-08)
**Goal**: Build `res://showcase/showcase.tscn` — an editor-authored showcase scene that visually proves every Godot Control is themed in v1, doubles as the QA forcing function, and includes a dropdown so consumers can compare built-in NeoCade styles plus NeoCade vs a null target theme. Raised/platform variations remain `NeoCadeTheme` resource exports previewed through the inspector or consumer code, not showcase runtime controls.
**Depends on**: Phase 8
**Requirements**: SHOW-01, SHOW-02, SHOW-03, SHOW-04, SHOW-05, SHOW-06, SHOW-07, SHOW-08
**Success Criteria** (what must be TRUE):
  1. **Showcase scene exists and is project main scene:** `res://showcase/showcase.tscn` is set as the project's main scene; uses `res://addons/neocade_theme/neocade_theme.tres` with Pulse as the starter style; opens to a fullscreen Control root with all 9 sections visible/scrollable.
  2. **9 sections present, covering all 37 Controls + Token Gallery + Coverage Verification:** Buttons / Text Inputs / Numbers & Range / Selection & Lists / Containers & Layout / Dialogs & Popups / Advanced & Graph / Token Gallery / Coverage 37/37. Every Control has REALISTIC sample content (Tree with multi-level items, ItemList with options, OptionButton with multiple options, dialog content with realistic text, etc. — per PITFALLS 10.1, empty controls render invisibly and are not valid QA).
  3. **Theme picker is dropdown-only; showcase behavior script is minimal:** The scene provides a Theme picker that cycles through the 5 built-in styles (Bubble, Burst, Daybreak, Pulse, Slate) + `None` (`null` target theme). The rest of the showcase UI is serialized scene nodes, not constructed by script; `showcase/showcase.gd` only handles behavior glue such as the scoreboard Window close/reopen path.
  4. **BBCode demo + accessibility wiring:** RichTextLabel section showcases inline color/weight/italic via BBCode (verifies font-system handles italic transform per FONT-07); `accessibility_name` is set on every interactive Control in the scene (Godot 4.5 API per PITFALLS 2.5 + 4.4 — minimum bar for screen-reader sanity in v1; deeper VoiceOver/TalkBack QA deferred to v1.x per UD-6).
  5. **Token Gallery + Coverage Verification visible:** Token Gallery section displays each design token visually — color swatches with hex + role label, type-scale samples in actual fonts, spacing/radius scale visualizations; Coverage Verification strip displays "37/37 Controls themed ✓" (or accurate count if any deferred — verifiable against Phase 7 close).
**Plans**: 1 plan

Plans:
- [x] `09-01-PLAN.md` — Implement the showcase scene with nine editor-authored sections, dropdown-only direction/none theme picker, minimal behavior glue, token gallery, and coverage strip.
**UI hint**: yes

### Phase 10: QA + Cross-Platform Export Validation
**Goal**: Prove the theme is ship-ready — visually consistent across renderers and resolutions, accessibility-compliant, and rendering correctly across all 6 Godot 4.6 export targets (Windows, macOS, Linux, iOS, Android, Web/Browser).
**Depends on**: Phase 9
**Requirements**: COV-10, EXPORT-01, EXPORT-02, EXPORT-03, EXPORT-04, EXPORT-05, EXPORT-06, EXPORT-07, EXPORT-08, A11Y-01, A11Y-02, A11Y-03, A11Y-04, A11Y-05, A11Y-06, QA-01, QA-02, QA-03, QA-04, QA-05, QA-06; closes cumulative COV-09 (focus indicator verification)
**Success Criteria** (what must be TRUE for the autonomous Phase 10 closeout):
  1. **MCP/QA tooling baseline documented (QA-01):** `.planning/qa/tooling-baseline.md` records the available QA surface and explicitly defers direct screenshot/input-injection validation where Codex lacks the needed MCP/browser surface.
  2. **Visual QA matrix scoped (QA-02, QA-03, QA-04):** Screenshot matrix, tab-walk focused-state pass, and dual-renderer pass are documented as deferred manual UAT with placeholder locations under `.planning/qa/`; GL Compatibility remains the ship target.
  3. **Coverage evidence scoped (COV-10):** `.planning/qa/coverage-audit.md` maps showcase samples and shared `NeoCadeTheme._regenerate_theme()` coverage to the 37-row scorecard. The exhaustive slot-by-slot diff against Phase 1's `godot-minimal-theme` enumeration remains deferred manual/tooling UAT until a scriptable Theme inspector/export surface exists.
  4. **Accessibility evidence scoped (A11Y-01..06):** Contrast, focus-indicator, color-not-alone, fallback-font, and `accessibility_name` evidence is documented where static/autonomous checks are available. CVD simulation, tab-walk screenshots, and deeper VoiceOver/TalkBack QA remain deferred UAT/v1.x scope.
  5. **Cross-platform export validation scoped (EXPORT-01..08):** Export presets and release workflow cover all 6 Godot targets (Windows, macOS, Linux, iOS, Android, Web/Browser); manual screenshot decks and real-device Android/iOS validation remain deferred. Web export specifics handled — bundled font/theme/icon resources are exportable, no `SystemFont` dependency is used, and the project remains on GL Compatibility renderer (avoids #116090 + #111729 4.6 regressions). License compliance is for the single bundled font, Inter Variable Roman (OFL 1.1); Outfit, Noto Sans, and JetBrains Mono are not bundled in v1.
  6. **Fresh-install dry-run scoped (QA-05):** `.planning/qa/fresh-install-dry-run.md` documents the clean install checklist and expected consumer smoke. Physical clean-project copy and screenshots remain deferred UAT.
  7. **Theme inspector workaround documented (QA-06):** `docs/usage.md` notes the active issue #115500 — do NOT edit theme resources through a Control inspector context menu. Safe authoring paths are the dedicated Theme editor, the 11 exported `NeoCadeTheme` properties on the canonical resource or consumer-saved resources, and formula edits in `addons/neocade_theme/scripts/neocade_theme.gd`.
**Plans**: 1 plan

Plans:
- [x] `10-01-PLAN.md` — Create autonomous QA evidence package and document deferred manual screenshot/device UAT.

### Phase 11: Distribution — GitHub Actions Release
**Goal**: Ship v1.0.0 via a single manually-triggered GitHub Actions workflow. The workflow runs CI checks, auto-bumps the version, builds the addon zip via `git archive`, builds a Godot Web export of the showcase scene, and publishes a GitHub Release containing both artifacts + the CHANGELOG slice as release body. **No Asset Library submission in v1** — distribution is GitHub-Releases-only.
**Depends on**: Phase 10
**Requirements**: DIST-01, DIST-02, DIST-03, DIST-04, DOCS-04 (RES-05 + DIST-05 stricken — Asset Library not in scope)
**Reference workflow:** [Shilo/PentaTile release.yml](https://github.com/Shilo/PentaTile/blob/main/.github/workflows/release.yml) — adapt the same 11-step pattern. Notable adaptations: version source is root `VERSION` (single-line file) instead of `plugin.cfg` (NeoCade has no `plugin.cfg` per Option D); add a Godot Web export step that produces a separate web-build zip uploaded as a release asset.
**Success Criteria** (what must be TRUE):
  1. **`.github/workflows/release.yml` exists and runs:** `workflow_dispatch` trigger with NO inputs (per PentaTile D-05-15 "if it cannot be automatic, remove it"); manual one-click release from the Actions tab.
  2. **Version source + auto-increment:** root `VERSION` is a single-line file holding the current `MAJOR.MINOR.PATCH`; workflow auto-bumps minor +1 by default, major +1 with minor=0 if minor would exceed 9, patch always 0. (Patches NOT supported by this scheme — same as PentaTile D-05-16.)
  3. **CI checks gate the release:** workflow downloads pinned Godot 4.6.x Linux build, runs headless project import (`godot --headless --path . --import --quit-after 2`) checking stderr for `ERROR`/`SCRIPT ERROR` markers, opens `res://showcase/showcase.tscn` headless to confirm the showcase loads, and runs any test suite (Phase 10 deliverables permitting). Failure aborts release.
  4. **Version commit + tag + push:** workflow rewrites root `VERSION` to the new version, rewrites root `CHANGELOG.md`'s `[Unreleased]` heading to `[<NEW_VERSION>] — <DATE>`, commits with `chore(release): v<NEW_VERSION>` message, creates annotated tag `v<NEW_VERSION>`, pushes both commit and tag to `main`. Uses `github-actions[bot]` identity.
  5. **Addon zip via `git archive`:** workflow runs `git archive --format=zip --prefix="neocade_theme-v<VERSION>/" -o "neocade_theme-v<VERSION>.zip" "v<VERSION>" -- addons/neocade_theme/ README.md docs/usage.md CHANGELOG.md LICENSE.md VERSION` — only tracked files at the tagged commit, with runtime addon files under `addons/neocade_theme/` and package docs/licenses outside the addon folder. (Pitfall #11 from PentaTile: this excludes `.godot/`, build artifacts, untracked.)
  6. **Godot Web export build:** workflow downloads the matching Godot 4.6.x Web export templates, runs `godot --headless --export-release "Web" <output_dir>/index.html` against the project's web export preset, then archives the web build (`index.html` + `index.wasm` + `index.pck` + `index.js` + `index.audio.worklet.js` + supporting files) into `neocade_theme-showcase-web-v<VERSION>.zip`. The export preset must be committed to `export_presets.cfg` ahead of time as part of Phase 9 showcase work.
  6a. **GitHub Pages deployment of web build:** workflow uses `actions/upload-pages-artifact@v3` (upload the web export directory as a Pages artifact) and `actions/deploy-pages@v4` (deploy to the `github-pages` environment). Adds `pages: write` + `id-token: write` to the workflow's `permissions` block. One-time repo setup: GitHub Settings → Pages → Source = "GitHub Actions". Result: each release auto-deploys to `https://<owner>.github.io/<repo>/` — instant browser-playable showcase.
  7. **CHANGELOG slice extraction:** workflow extracts the `[<NEW_VERSION>] — <DATE>` section from `CHANGELOG.md` using awk pattern from PentaTile, writes to `release-notes-body.md`, fails fast if empty.
  8. **GitHub Release published:** uses `softprops/action-gh-release@v3` (requires `ubuntu-latest` for Node 24 — pitfall #5 from PentaTile); attaches BOTH `neocade_theme-v<VERSION>.zip` AND `neocade_theme-showcase-web-v<VERSION>.zip`; release body is the CHANGELOG slice; `draft: false`, `prerelease: false`. Auth via job-level `permissions: contents: write`.
  9. **README + supporting docs in place (DOCS-04, DIST-04):** Project description, install path (download zip from GitHub Releases → extract `addons/neocade_theme/` into your Godot project's `addons/`), usage examples, cross-platform support summary, mobile variant usage, accessibility notes, font override patterns (Noto Sans for non-Latin harmony, mono for CodeEdit, Inter Italic), editor-coverage map link (EDITOR-COVERAGE.md), license, attributions. **Includes a "Try the showcase in your browser" link to the GitHub Pages URL (`https://<owner>.github.io/<repo>/`) — auto-deployed on every release.**
  10. **License + initial CHANGELOG (DIST-02, DIST-03):** `addons/neocade_theme/fonts/inter_ofl.txt` covers Inter (single bundled font per Option D); root `LICENSE.md` covers theme code; root `CHANGELOG.md` has a `[Unreleased]` section with v1.0.0 entry pre-populated documenting every shipped feature + every documented limitation (Inter Italic deferred, no Noto Sans bundled, no JetBrains Mono bundled, real-device mobile QA status per UD-5, screen-reader QA status per UD-6).
**Plans**: 1 plan

Plans:
- [x] `11-01-PLAN.md` — Prepare the manually triggered GitHub Actions release workflow, version/changelog release flow, addon zip, Web showcase export, Pages deployment, and release documentation.

## Progress

**Execution Order:**
Phases execute in numeric order: 1 → 2 → 3.1 → 3.2 → 3.3 → 3.4 → 4 → 5 → 6 → 7 → 8 → 9 → 10 → 11. Phase 3.1 + 3.2 are parallel-eligible; 3.3 depends on 3.1; 3.4 depends on 3.1 + 3.2 + 3.3. Phase 3 is REDIRECTED (does not execute).

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1. Source-Dive: godot-minimal-theme | 5/5 | Complete | 2026-05-04 |
| 2. Source-Dive: LDtk source | 5/5 | Complete | 2026-05-04 |
| 3. Visual Direction (v0) | n/a | REDIRECTED 2026-05-04 | preserved as historical reference |
| 3.1 Source-Dive: MD3 + MD3 Expressive + Flat-3D Game UI | 6/6 | Complete    | 2026-05-06 |
| 3.2 Source-Dive: Godot Dynamic Theme Architecture | 6/6 | Complete | 2026-05-06 |
| 3.3 Theme Direction Research (5 candidate directions) | 3/3 | Complete | 2026-05-06 |
| 3.4 Visual Direction Mockup + Approval Gate (Flat / Extruded-Flat) | 4/4 | Complete | 2026-05-06 |
| 4. Foundation: Single `NeoCadeTheme` class + data `.tres` files + Fonts + Icons | 8/8 | Complete | 2026-05-07 |
| 5. Core Controls (Buttons/Inputs/Labels/Panels) | 7/7 | Complete   | 2026-05-07 |
| 6. Lists/Layout/Range | 5/5 | Complete | 2026-05-07 |
| 7. Dialogs/Popups/Advanced | 5/5 | Complete | 2026-05-07 |
| 8. Mobile Variant Token Block + Tap-Target Audit | 5/5 | Complete | 2026-05-07 |
| 9. Showcase + Token Gallery + Theme/Variation Toggles | 1/1 | Complete | 2026-05-07 |
| 10. QA + Cross-Platform Export Validation | 1/1 | Complete (manual/device UAT deferred) | 2026-05-07 |
| 11. Distribution | 1/1 | Complete (workflow prepared; release not triggered) | 2026-05-07 |

---

## Coverage Summary

**Total v1 requirements:** 113 (across 15 categories: RES-5, DESIGN-6, FOUND-3, FONT-9, ICON-4, TOKEN-10, COV-10, TYPEVAR-6, MOBILE-8, SHOW-8, EXPORT-8, A11Y-6, QA-6, DIST-19, DOCS-5)
**Mapped to phases or pre-roadmap artifacts:** 113 (DOCS-03 already complete pre-roadmap; all other 112 mapped to a primary phase with explicit cumulative reasoning where applicable)
**Unmapped:** 0

**Cumulative requirements (assigned to a primary phase, contributed to by others with documented reasoning):**
- COV-01 (37/37 scorecard coverage) — primary Phase 7; contributed by Phase 5 + Phase 6
- COV-07 (container chrome) — primary Phase 7; contributed by Phase 5 + Phase 6
- COV-09 (focus indicator on every focusable Control) — primary Phase 5 (pattern); contributed by Phase 6 + 7; verified Phase 10
- COV-10 (zero engine-default entries) — primary Phase 10; depends on Phase 1 RES-01 enumeration
- TYPEVAR-06 (core runtime variations from `TYPE_VARIATIONS` documented; editor-only variations handled separately) — primary Phase 8 (DOCS-02 finalization); contributed by Phase 5 + 6 + 7
- TOKEN-01..10 — design definitions Phase 3; `NeoCadeTheme` formula/binding implementation Phase 4
- DOCS-05 (SOURCES.md updates) — continuous Phase 1 + 2 + 3

**Mockup approval gate enforcement:** Hard blocker between Phase 3.4 and Phase 4 — no addon `.tres`/`.gd` styling commits permitted before Phase 3.4 final approval is logged and DESIGN_TOKENS.md is written.

**Open user decisions tracked in-phase (not roadmap blockers):**
- UD-1 (MCP server swap to GoPeak) — addressed in Phase 3 sub-spike
- UD-2 (CJK font bundling) — default decision (defer) confirmed in Phase 4 README
- UD-3 (stylebox authoring tooling) — direct `NeoCadeTheme` export-driven regeneration plus Theme Editor override verification — established in Phase 4
- UD-4 (Inter Italic v1 vs v1.x) — FINAL: Option D locked 2026-05-04. v1 ships Inter Variable Roman ONLY (~810 KB, matches godot-minimal-theme exactly). Inter Italic, Noto Sans, JetBrains Mono, Outfit — all deferred to v1.x or to consumer-side override pattern. Non-Latin scripts handled via Godot's `Font.allow_system_fallback=true`. User can override at Phase 3 typography mockup gate.
- UD-5 (real-device cross-platform testing matrix) — addressed in Phase 10 acceptance with `(if-real-device-available)` qualifier; ship-or-defer decision in Phase 10
- UD-6 (AccessKit / VoiceOver / TalkBack screen-reader integration) — `accessibility_name` only in v1 (Phase 9 SHOW-06); deeper QA deferred to v1.x

### Phase 12: Signature Visual Moves

**Goal:** Resolve the "generic dark Godot theme with an accent color" complaint by adopting the three default-behavior signature moves locked by the Visual Identity Distinctiveness spike (C4 + C2' + C6) so the rendered theme reads as a unique flat-MD3 game-UI identity. (1) C4 replaces `_raised_depth_color` with HSV value-darken at `0.20 + 0.10 * raised_strength` to fix colored-button affordance. (2) C2' rebinds existing BINDING_TABLE slots (selected TabBar indicator, selected ItemList/Tree row left-stripe, kicker text color, active section indicators, slider value labels, section-header underlines) to use the existing `accent_color` in idle chrome — the headline fix, zero new hues. (3) C6 gives each of the 5 directions one non-color/non-radius signature: Pulse uppercase-tracked kicker, Slate 1px hairline borders + quiet-pill primary, Bubble forced ≥26 corner radius across all chrome, Daybreak 1px outer mint outline + generous primary padding, Burst oversized 56-64px primary CTAs with thicker depth strip. Locked success criteria (binding): `raised=false` shows ZERO 3D elements, no glow halos anywhere, every direction identifiable at thumbnail scale via greyscale render without color cues, no new hues introduced, zero public-export changes (12-export contract preserved).
**Requirements**: TBD (Phase 12 is post-v1 visual-identity work; no REQUIREMENTS.md REQ-IDs map to it — coverage is via the 6 locked success criteria above)
**Depends on:** Phase 11
**Plans:** 2/4 plans executed

Plans:
**Wave 1**
- [x] 12-01-wave-0-verify-helpers-PLAN.md — Wave 0: create the 4 Phase 12 verification helpers (architecture, SC#1..SC#6 stages, 30-config smoke, greyscale thumbnail render).
- [x] 12-02-wave-1-c4-hsv-depth-PLAN.md — Wave 1: rewrite _raised_depth_color body with the D-12.02 HSV value-darken formula (atomic, signature preserved).

**Wave 2** *(blocked on Wave 1 completion)*
- [ ] 12-03-wave-2-c2prime-accent-rebinds-PLAN.md — Wave 2: rebind 6 BINDING_TABLE rows (TabBar/TabContainer tab_selected, ItemList/Tree selected/selected_focus) to role_primary accent stripes — the headline fix (mid-phase fallback boundary per D-12.20).

**Wave 3** *(blocked on Wave 2 completion)*
- [ ] 12-04-wave-3-c6-per-direction-PLAN.md — Wave 3: per-direction signatures (Slate hairlines, Bubble ≥26 radius floor, Daybreak flat outline, Burst oversized primaries) + Pulse showcase Kicker + SC#4 greyscale thumbnail user attestation.

### Phase 13: Role Variations

**Goal:** [To be planned]
**Requirements**: TBD
**Depends on:** Phase 12
**Plans:** 0 plans

Plans:
- [ ] TBD (run /gsd-plan-phase 13 to break down)

---
*Roadmap authored: 2026-05-04 from SUMMARY.md 11-phase plan + REQUIREMENTS.md traceability*
*Last updated: 2026-05-07 — autonomous Phase 9-11 closeout; UAT/device QA deferred per user instruction*
*Mockup approval gate is non-negotiable per PROJECT.md hard constraint*
