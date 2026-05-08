# NeoCade Theme — Source Coverage Dossier

**Project:** NeoCade Theme (Godot 4.6 dark UI Theme addon)
**Authored:** 2026-05-04 by gsd-research-synthesizer
**Mandated by:** PROJECT.md "Source Coverage Commitment" section

This dossier catalogues each source the user explicitly named in PROJECT.md. For each source, this document captures: what was read, what was adopted, what was rejected (with reasoning), what's still open, and confidence in coverage. Sources where the initial 4-researcher pass was thin are explicitly flagged with a recommendation to deepen coverage in a roadmap-level source-dive spike phase.

**Catalogue update policy:** this file evolves with each source-dive spike phase. Initial pass entries are dated 2026-05-04. Subsequent updates dated at the time of the spike phase that generated them.

---

## 1. godot-minimal-theme by passivestar

**Source name + location:**
- Repository: https://github.com/passivestar/godot-minimal-theme
- License: MIT
- Now productized as Godot 4.6's default "Modern" editor theme

**What was read (initial pass, 2026-05-04):**
- README in full — recommended editor settings: base color `#272727`, accent `#569eff`, Inter font, corner radius 4-5px, high icon saturation
- Issue tracker: #19 (plugins crash with minimal theme — `StyleBoxEmpty` method-not-found), #8 (general feedback / suggestions)
- License terms (MIT — compatible with NeoCade redistribution)
- **NOT read in initial pass:** the `.tres` file itself line-by-line; per-Control × per-state entry enumeration; interaction state transforms; accent strategy; how it handles popups; whether it themes `TooltipPanel`/`TooltipLabel`/`Window` etc.

**What was read (Phase 1 source-dive, 2026-05-04):**
- `minimal_theme.tres` enumerated line-by-line — provenance recorded (SHA-256 `102fd6b3cab3b30b3c05878badff83e321df06a98adf4bb17e6a94d1b0a73f2e`, 1118 lines, 48,442 bytes). 27 user-facing Controls × per-state × per-entry tabulated; 80-class active-verification audit; FlatButton dissected as Button TYPEVAR-01 research per CONTEXT.md D-10. See `.planning/research/MINIMAL-THEME-DISSECTION.md`.
- `default_theme.cpp` cross-referenced for engine-declared slots; per-Control omission tables for slots upstream chose NOT to populate.
- `theme_db.cpp` + `base_button.cpp` consulted for Pitfall 1.1 (focus stylebox overlay) and Pitfall 1.7 (popup separate-Window theming) confirmation/refutation; both pitfalls **CONFIRMED** with engine-source + theme-resource evidence cited.
- Coverage delta vs FEATURES.md 35-class matrix computed: 27 themed-in-upstream + 8 NeoCade-additives + FlatButton (research-only) + container-chrome reconciliation. See `.planning/research/MINIMAL-THEME-COVERAGE-DELTA.md`.

**What we adopted:**
- **Function-as-completeness-benchmark posture** — see PROJECT.md decision: "godot-minimal-theme is the feature-completeness benchmark, NOT visual reference." Reflected in FEATURES.md's 35-class coverage matrix.
- **Inter as primary UI font** — same choice as minimal theme; harmonizes NeoCade with Godot 4.6's new default editor theme. STACK.md adopts Inter Variable v4.x.
- **Corner radius default 4px** — STACK.md and ARCHITECTURE.md both anchor to this (godot-minimal-theme uses 4-5; we pick 4 with 8/12 escalations for popups/dialogs).
- **High icon saturation discipline** — bespoke SVG icon set per STACK.md authored at full saturation against dark surface.
- **Single-accent dominance pattern** — even though NeoCade has 8 accent hues, only ONE is the primary `role.primary` (cyan in Midnight Marquee, amber in Boardwalk Sunset, orange in Cabinet Chrome). Same discipline as minimal theme's `#569eff`.
- **Composite-state slot strategy (from Pitfall 1.1 confirmation, Phase 1)** — populating `pressed_focus`, `hover_pressed`, `checked_focus`, `radio_checked_focus` slots is mandatory for visible focus on focusable Controls; relying on bare `focus` slot leaves focus invisible when also pressed/checked (engine behavior, not theme behavior). Phase 5 focus-ring design depends on this.
- **Popup type-level theming as required pattern (from Pitfall 1.7 confirmation, Phase 1)** — every popup class (PopupMenu, PopupPanel, AcceptDialog, FileDialog, ConfirmationDialog, TooltipPanel, TooltipLabel, Window) must have type-level theme-resource entries; runtime `add_theme_*_override` on parents does NOT inherit through popups (separate Windows). NeoCade's coverage strategy aligns with this prescription.
- **7-stop tonal surface ramp pattern documented as reference (Phase 1)** — upstream's 7-stop ramp (`color_surface_lowest..._highest` via `_get_base_color(brightness, sat_mult)`) is the design pattern; NeoCade's M3 5-stop ramp (per ARCHITECTURE.md) is the chosen architecture. Divergence is intentional (M3 is the canonical model adopted in Conflict 2 resolution); the upstream pattern is now research material, not direction.

**What we rejected:**
- **Verbatim numeric values** — Pitfall 6.1: minimal-theme numerics are tuned for editor scale (with `EDSCALE` factors); lifting them produces a theme that looks "minimal-ish" without distinct identity. NeoCade derives numerics from the design system in ARCHITECTURE.md, not from minimal-theme.
- **Single-accent palette** — NeoCade is a multi-accent arcade theme by mandate; FEATURES.md DF-4 specifies 8 accent hues with semantic role aliases. Minimal theme's mono-accent approach would miss the brief.
- **`StyleBoxEmpty` for transparent slots** — Pitfall 2.3: plugins assume `StyleBoxFlat` methods (issue #19 in minimal-theme). NeoCade prefers transparent `StyleBoxFlat` over `StyleBoxEmpty` whenever a slot may be queried by third-party code.
- **`#272727` base color** — too cool/neutral for arcade direction. Boardwalk Sunset uses `#1A1410` (warm near-black, brown undertone); Cabinet Chrome uses `#1E2229` (matches LDtk's `$bgDark` exactly, slightly warmer than minimal theme).
- **`#569eff` accent** — too generic-cool-blue per ARCHITECTURE.md Section 7. Replaced with arcade-amber/orange for distinctive identity.
- **Editor-only theme types** — minimal theme styles `FlatButton`/`MainScreenButton`/`BottomPanelButton`/`EditorInspector*` etc. NeoCade v1 scopes to user-facing public Control hierarchy only (FEATURES.md AF-6); editor parity is v1.x.
- **`@tool extends Theme` + `EditorInterface.get_editor_settings()` + `EDSCALE` runtime pattern** — D-05 rejection re-confirmed by Phase 1 enumeration. Upstream's GDScript reads 9 `interface/theme/*` editor settings + uses `EditorInterface.get_editor_scale()`. NeoCade's `@tool` token-generator (Phase 4) reads from a hand-authored TokenSet resource, not from EditorSettings — runtime-first; works in shipped games on all 6 export targets. The 13 specific Editor-API touchpoints with line citations are documented in `MINIMAL-THEME-DISSECTION.md` `## Editor-API Touchpoints (Forbidden in NeoCade per D-05)`.

**What's still open:**
- **Accent application strategy** — partially resolved by Phase 1 enumeration (per-Control accent-using rows are now visible in DISSECTION.md). Synthesizing the cross-class accent pattern into a NeoCade design rule remains Phase 3 mockup-design work. Reduced from "open in initial pass" to "design synthesis pending Phase 3."
- **Editor-theme-only types' theme entries** — even though we don't theme them in v1, we may want the entry list for v1.x editor-only coverage.
- **Comparison against Godot 4.6's "Modern" editor theme** — minimal-theme was ported but may have been tuned. Need diff.

**Confidence in coverage:** **HIGH** for v1. Phase 1 source-dive (2026-05-04) opened the `.tres` and enumerated every entry per-Control × per-state with line citations; coverage delta vs FEATURES.md 35-class matrix computed; Pitfall 1.1 and Pitfall 1.7 confirmed from data with engine-source + theme-resource evidence. **Remaining uncertainty (LOW-impact):** edge-case Godot version drift between user's local engine clone and Godot 4.6 release tag; recommend re-pinning the omission cross-reference once Godot 4.6 is finalized in user's clone (caveat noted in DISSECTION.md `### Engine-Default Cross-Reference`).

---

## 2. LDtk UI docs

**Source name + location:**
- https://ldtk.io/docs/general/editor-components/

**What was read (initial pass, 2026-05-04):**
- LDtk editor-components page (component patterns, layout strategies)
- LDtk's UI conventions referenced in user's prior research report

**What was read/refined (Phase 2 source-dive, 2026-05-04):**
- LDtk web-doc patterns were cross-checked against source evidence in `.planning/research/LDTK-UI-MINING.md`.
- The source pass refined the docs-level panel, dropdown, context-menu, icon, palette/list, form, notification, and collapse observations into file:line-cited patterns.
- Web-doc "polish benchmark" language remains valid, but implementation transfer is now explicitly inspiration-grade only.

**What we adopted:**
- **Polish/quality discipline as benchmark** — per PROJECT.md decision, LDtk is the polish bar, not visual copy. Reflected throughout ARCHITECTURE.md as "LDtk-grade clarity."
- **Tinted-sidebar concept** — adapted into NeoCade's accent-palette approach (8 hues with role aliases per FEATURES.md DF-4) without copying LDtk's specific tints.
- **Flat iconography baseline** — NeoCade's bespoke SVG set follows the same monochrome-on-accent flat-icon discipline (STACK.md icon strategy).
- **Status-strip pattern** — bottom status bar with project info, layer, save status — informed FEATURES.md Section 5.4 showcase scope (resolution test selector, coverage counter).
- **Toggleable panel pattern** — informed FoldableContainer requirement in FEATURES.md TS coverage.
- **Keyboard-hint inline labels** — informed accessibility consideration (label every focus path).
- **Source-refined interaction density** — from `.planning/research/LDTK-UI-MINING.md`: icon-bearing compact launchers, searchable popups, grid/list palette variants, reset/default affordances, row markers, and explicit unsupported/active states.

**What we rejected:**
- **Color-by-function-tinted sidebars** — LDtk does this for editor mode (blue=entities, brown=walls). NeoCade is a general theme, not a single-app editor — this pattern would over-constrain consuming projects.
- **Bitmap atlas font discipline** — LDtk bakes Noto Sans into PNG atlases due to Heaps engine constraints. Godot 4.6 has mature TTF/VF support — STACK.md uses dynamic FontFile/FontVariation, not BMFont (Pitfall 5.4).
- **`pixel_berry.png` pixel font for tiny labels** — pixel fonts categorically rejected by PROJECT.md (HD-only constraint).
- **Fixed Endesga32 palette for content** — LDtk's content palette is for tile-art use, not UI; not relevant to NeoCade theme.
- **Binding LDtk component behavior into the theme** — Phase 2 confirms singleton panels, popout palettes, viewport cursors, and CodeMirror-style editors are app/editor logic, not v1 Godot Theme deliverables.

**What's still open:**
- None for v1 LDtk UI-doc usage. Phase 3 decides which non-binding inspiration sketches appear in the mockup.

**Confidence in coverage:** **HIGH for v1 inspiration use** after Phase 2. Web docs are no longer standing alone; their relevant UI claims are cross-checked against `.planning/research/LDTK-UI-MINING.md`.

---

## 3. LDtk source code

**Source name + location:**
- `C:\Programming_Files\ldtk-master\` (Haxe/Heaps; UI in `src/electron.renderer/` and `res/atlas/`, `res/fonts/`)
- User explicit mandate: "must read all of it for UI"

**What was read (initial pass, 2026-05-04):**
- `app/assets/css/app.scss` lines 1-24 — palette extracted: `$bgDark: #1e2229; $bgMed: #2e333f; $bgLight: #545d73; $orange: #ffcc00; $almostWhite: ...` (extracted by ARCHITECTURE.md Section 1, basis for Cabinet Chrome palette)
- `res/fonts/` directory — verified LDtk bundles `noto_sans_display_semicondensed_*.png/.xml` (bitmap atlas font, multiple weights/sizes baked) plus `pixel_berry.png` (pixel font for tiny labels); identified by STACK.md as confirmation that even a polished pixel-art tool ships Noto Sans for chrome
- LDtk CHANGELOG (surface read for major UI lessons-learned)
- **NOT read in initial pass:** `src/electron.renderer/` UI implementation files (the user's "must read all of it" mandate); per-component code patterns; tinted-sidebar/icon/font/atlas implementation patterns under `res/`; full CHANGELOG audit for UI lessons; specific component implementation files

**What was read (Phase 2 source-dive, 2026-05-04):**
- `.planning/research/LDTK-UI-MINING.md` was created as the durable LDtk source-dive artifact.
- Provenance pinned LDtk `1.5.3`, source root `C:\Programming_Files\ldtk-master\`, no `.git` metadata in the local snapshot, 143 renderer Haxe files, 69 UI Haxe files, `Editor.hx`, 9 tool files, 10,819 physical `app.scss` lines by `rg`, 98 SVG icons, 2 Aseprite atlases, and 13 font-related files.
- File-by-file Haxe index covered 80 UI-relevant Haxe surfaces: 69 `src/electron.renderer/ui/**/*.hx`, `page/Editor.hx`, `Tool.hx`, and 9 tool files. One `DebugMenu.hx` surface was explicitly marked not-ui.
- 14 Haxe patterns, 10 SCSS patterns, 16 changelog lessons, 98-icon metadata inventory, atlas/font inventory, active verification audit, and prior-report claim verification were appended with line citations.
- `app.scss` source ranges were mined beyond the initial palette lines, including buttons, tabs, forms, select picker, notifications, modal/dialog/panel shells, context menus, command palette, palette/list rows, and scrollbars.
- CHANGELOG UI lessons were audited across versioned entries, including hotfix UI feedback, panel organization, compact/zen views, icon/color list scanning, dropdown search, warning/tooltip changes, Noto typography, and large-dialog scrollbars.
- LDtk-related prior-report claims were checked against local source evidence.

**What we adopted:**
- **Palette extraction informed Cabinet Chrome palette** — ARCHITECTURE.md Palette C uses `$bgDark` exactly (`#1E2229`) and tunes `$orange` to `#FFB020` for AA contrast; informed by real LDtk source values.
- **"Single warm signature accent against neutral ramp" discipline** — extracted from LDtk's palette structure (one orange, multi-stop neutral). Reflected in NeoCade's role-primary-dominance pattern.
- **"No glow effects, all elevation through tonal value" discipline** — extracted from observing LDtk's UI is precise because there's no ambiguity about which surface a thing sits on. Adopted as NeoCade's elevation-via-color philosophy (FEATURES.md DF-10, Conflict 3 resolution).
- **Confirmation that pixel-art tools ship sans-serif chrome fonts** — STACK.md cites this as evidence supporting Inter+Noto Sans over arcade flair fonts.
- **Explicit state coverage taxonomy** — disabled, hover, focus, active, selected, checked, unsupported, defaulted, required/error, resettable, and collapsed/folded states should be deliberately demonstrated in NeoCade.
- **Dense tool-surface grammar** — compact icon launchers, grid/list palette modes, searchable dropdowns/popups, icon-bearing rows, row markers, and context-menu alternatives are adopted as inspiration sketches only.
- **Popup/dialog coverage pressure** — LDtk's modal, panel, command-palette, select, context-menu, and notification evidence reinforces the need to theme Godot popup/window/dialog surfaces explicitly.
- **Readable sans-serif chrome** — LDtk's Noto usage reinforces the Inter/Noto-family direction without adopting bitmap atlases.

**What we rejected:**
- **Bitmap atlas font approach** — Godot 4.6 has mature dynamic TTF/VF rendering; Pitfall 5.4 forbids BMFont in v1.
- **`pixel_berry.png`** — pixel fonts categorically rejected.
- **Heaps-specific UI primitives** — NeoCade is a Godot Theme; LDtk's UI architecture is not directly portable.
- **jQuery/class-mutation implementation model** — state names are useful, but DOM mutation patterns are not portable to `.tres`.
- **Singleton panel/popout/cursor behavior as a theme requirement** — these are consuming-app/editor logic, not Godot Theme resource behavior.
- **LDtk content-domain colors as NeoCade semantic UI roles** — Endesga32 and layer/entity/IntGrid colors are content data, not reusable theme roles.
- **LDtk shadows, filters, gradients, and blinking/glow attention language as visual defaults** — Phase 2 treats them as state evidence only.
- **Copying LDtk SVGs, Aseprite atlases, bitmap fonts, or icon attributions** — asset inventory is for non-binding design inspiration and license caution only.

**What's still open:**
- **Closed by Phase 2 for v1 UI-theme research:** UI pattern mining, atlas/font/icon inventory, CHANGELOG UI lessons, and LDtk-related prior-report claim verification.
- **Still open by design:** non-UI LDtk internals, exact visual asset rendering, and any behavior that belongs to a consuming app rather than a Godot Theme. These are not blockers for NeoCade v1.

**Confidence in coverage:** **HIGH for v1 LDtk UI-source research**. Phase 2 closes the four prior source-dive gaps for NeoCade's theme-planning purposes: UI patterns, atlas/font/icon conventions, CHANGELOG UI lessons, and LDtk claim verification. Remaining gaps are non-UI or implementation-behavior questions outside `.tres` scope.

---

## 4. Material Design 3

**Source name + location:**
- https://m3.material.io/
- Upstream SCSS: `https://raw.githubusercontent.com/material-components/material-web/main/tokens/versions/v0_192/_md-sys-typescale.scss`
- Upstream SCSS: `https://raw.githubusercontent.com/material-components/material-web/main/tokens/versions/v0_192/_md-sys-state.scss`

**What was read (initial pass, 2026-05-04):**
- Color roles page (`m3.material.io/styles/color/roles`) — surface tonal ramp, on-surface variants, accent role pattern
- Type scale tokens page (`m3.material.io/styles/typography/type-scale-tokens`) — full type scale with px/line-height/tracking/weight values
- State layers page (`m3.material.io/foundations/interaction/states/state-layers`) — opacity values per state
- Spacing applied-layout page (`m3.material.io/foundations/layout/applying-layout/spacing`) — 4-step base
- Components page (`m3.material.io/components`) — button variation taxonomy (Filled/Tonal/Outlined/Text/Elevated)
- Upstream `_md-sys-typescale.scss` v0.192 (verified raw via GitHub) — pulled exact values
- Upstream `_md-sys-state.scss` v0.192 — verified hover 0.08, focus 0.12, pressed 0.12, dragged 0.16
- Flutter TextTheme reference (canonical M3 type scale values)

**What we adopted:**
- **5-step tonal surface ramp as canonical surface taxonomy** — ARCHITECTURE.md Section 1 + SUMMARY.md Conflict 2 resolution. Token names: `surface` / `surface-container-low` / `surface-container` / `surface-container-high` / `surface-container-highest`.
- **Type scale spine** — ARCHITECTURE.md Section 3 uses M3 `display-small` / `headline-small` / `title-large` / `title-medium` / `body-large/medium/small` / `label-large/small` / `code` with px values pulled from upstream SCSS.
- **Deterministic state-layer opacities** — ARCHITECTURE.md Section 5: hover 8%, focus 12%, pressed 12%, dragged 16%, disabled 38%/12% (text/container).
- **4-step spacing base** — ARCHITECTURE.md Section 4: `xs=4 / sm=8 / md=12 / lg=16 / xl=24 / 2xl=32 / 3xl=48`.
- **Button variation taxonomy as inspiration** — FEATURES.md DF-1: Material 3's Filled/Tonal/Outlined/Text/Elevated maps to NeoCade's Primary/Secondary/Ghost/Flat/Icon/Danger (role-semantic naming, not fill-semantic).
- **System-architecture posture** — every color is a token, every state is a layer, every size is a scale step. Lets us produce a v2 light theme later by changing token values only, not touching architecture.
- **WCAG accessibility math discipline** — M3 advises 4.5:1 text / 3:1 non-text via WCAG 2.1; ARCHITECTURE.md verifies all color pairs against W3C luminance formula.

**What we rejected:**
- **Pill-shaped buttons / 24px corner radii** — read iOS-mobile and clash with Godot editor expectations. NeoCade defaults to 4px radius (godot-minimal-theme parity).
- **Material Symbols icon font** — STACK.md rejects: Texture2D-per-slot mismatch, multi-MB bundle for ~30 icons we need, optical-size axis is web-tuned. Bespoke SVG set replaces.
- **Material Theme Builder dynamic theming** — NeoCade ships fixed palettes; v2 alt-palettes are explicit forks, not generated.
- **M3's "elevation via shadow" model** — replaced by elevation-via-color (color-ramp surface stops). Forced by GL Compatibility shadow bug (#23640) per Conflict 3 resolution.
- **M3's brand-named expressive themes** — NeoCade's identity is arcade-specific, not Material-specific.
- **Material's pill-button "Tonal" name** — NeoCade uses role-semantic names (Primary/Secondary/Danger/Ghost/Flat/Icon).

**What's still open:**
- **Direct comparison against Godot 4.6's existing "Modern" theme** — does it follow M3 conventions? Mismatch could create visual dissonance.
- **CSS-to-StyleBoxFlat translation table** for M3 component specs (e.g. M3 specifies `--md-sys-state-hover-state-layer-opacity: 0.08` — direct mapping to `Color(1,1,1,0.08).blend(base)` documented in ARCHITECTURE.md but not exhaustively tabulated for every M3 component).
- **M3 light-theme token pairings** — for v2 light mode work; surface-pair luminance flips need their own contrast verification.

**Confidence in coverage:** **HIGH** — all values pulled from upstream SCSS source with version pin (v0.192). Cross-checked with Flutter implementation. **What would raise it further:** N/A for v1 needs.

---

## 5. Real & virtual arcade aesthetics

**Source name + location:**
- (Research must source — no canonical URL)
- Reference points named in PROJECT.md Context: Round1, Dave & Buster's, Two Bit Circus, classic 80s halls
- Reference points sourced in initial research: 1000logos.net (D&B brand palette), aesthetics.fandom.com (Arcadecore wiki), Wikipedia (Round One Corporation)

**What was read (initial pass, 2026-05-04):**
- Dave & Buster's brand palette page (1000logos.net/dave-busters-logo) — confirmed brand stack is deep blue + vibrant orange (NOT neon pink + cyan synthwave-coded)
- Round One Corporation (Wikipedia) — surface read of business model and visual presence
- Arcadecore aesthetic wiki (aesthetics.fandom.com/wiki/Arcadecore) — surface read of the aesthetic descriptors
- Synthwave / Cyberpunk wiki entries (aesthetics.fandom.com/wiki/Synthwave, /Cyberpunk) — surface read to define the **rejected** aesthetic explicitly
- Lethal Audio "Shared Aesthetics of Synthwave and Cyberpunk" (lethalaudio.com) — surface read to articulate the dark+neon trap
- Joel Chan "Outrun aesthetic deconstructed" (Medium) — surface read to articulate visual signatures
- Steam Community Synthwave/Vaporwave/OutRun guide — surface read of forbidden visual moves

**Phase 3 update (2026-05-04):**
- `.planning/research/mood-board/INDEX.md` and `.planning/research/mood-board/references.json` — 25 URL-only or license-screened references collected across modern arcade venues, prize/ticket/counter/crane references, classic/barcade/pinball/cabinet rows, and a curated minority of future/neo/sci-fi immersive venues.
- Representative source families now include Round1 official location/activity pages, Dave & Buster's play/events pages, Main Event games/bowling pages, Two Bit Circus, Andretti arcade, Neon Retro Arcade, Barcade, Pinball Hall of Fame, Wikimedia Commons arcade/claw categories, Internet Arcade, AREA15, Electric Playhouse, Level99, and Sandbox VR.
- `.planning/research/PHASE-3-TOOLING.md` — Godot/Coding-Solo MCP and GoPeak availability recorded; screenshot baseline captured at `.planning/research/godot-screenshot-smoke.png`; Plan 02 image-generation path confirmed as Codex app `image_gen` via the `imagegen` skill.

**What we adopted:**
- **"Vibrant arcade hall by day, NOT neon noir alley by night" mental model** — PROJECT.md Key Decision; reinforced by ARCHITECTURE.md Section 7.
- **Warm-neutral surface direction (Boardwalk Sunset)** — derived from the observation that real-arcade interior lighting is warm-coded (cabinet wood, painted booths, ticket-counter coral, marquee gold), not cool-coded (Tron-blue, computer-screen cyan). ARCHITECTURE.md Palette B.
- **Multi-hue accent palette discipline** — synthwave is two-color (cyan + magenta on dark); arcade is multi-color (orange + coral + teal + green). FEATURES.md DF-4 specifies 8 hues.
- **High-luminance saturation discipline** — ARCHITECTURE.md anti-cyberpunk rules require accents test ABOVE 60% lightness on dark surfaces (synthwave is below 50%, twilight-coded).
- **Dave & Buster's brand stack as reality check** — ARCHITECTURE.md Section 7: real arcade brands lean warm/orange-coded, not magenta/cyan synthwave-coded. Boardwalk Sunset's amber primary is anchored to this.
- **Explicit anti-cyberpunk rules** — ARCHITECTURE.md Section 7 lists 12 forbidden moves (chromatic aberration, scanlines, grid overlays, glow halos, drop-shadow on text, monospace body, pure-black surfaces, ALL CAPS body, sci-fi terminology, "TRANSMISSION"/"SYSTEM" labels, hex-grid backgrounds, fake circuitry).
- **Mockup-gate detection ritual** — "Could this be the menu screen of a Hotline Miami / Cyberpunk 2077 / Tron clone?" If yes → drift. (PITFALLS.md 7.1)
- **Reference tags and constrained influence model** — Phase 3 mood-board entries use `theme-safe`, `game-world`, `palette`, `surface`, `shape`, and `risky` tags. `game-world` and `risky` references can inspire extracted moves only; they do not become the whole NeoCade mood.
- **Two additional direction candidates grounded in references** — Prize Pop Plaza derives from prize/crane/counter/reward-loop evidence; Orbital Playdeck derives from a minority future-facing immersive-venue lane. Both remain candidates until mockup review.

**What we rejected:**
- **User's prior research report claim "Synthwave/Vaporwave Vibe — references to 1980s-90s sci-fi (Tron, synth music)"** — explicitly forbidden by PROJECT.md. Tracked in Source 8 below.
- **Aesthetics-wiki Arcadecore palette suggestions** — wiki is broad; specific palette suggestions may include synthwave-adjacent hues. NeoCade scopes to Boardwalk Sunset / Cabinet Chrome / Midnight Marquee — three curated directions, not wiki-pick.
- **"Arcadecore" as a brand alignment** — too internet-aesthetic-coded; NeoCade aligns with real-place-arcade (Round1/D&B), not aesthetics-fandom-arcade.
- **Copying or embedding promotional venue imagery** — all-rights-reserved images remain URL-only research references; no venue photos are copied into distributable or committed visual assets.

**What's still open (significant gap):**
- **Mockup approval** — mood-board coverage is now adequate, but final visual direction confidence cannot be HIGH until the Phase 3 concept images and boards are reviewed and approved by the user.
- **Specific StyleBox translation** — the mood-board identifies design moves, but concrete token values for borders, fills, radii, disabled/focus states, and panel hierarchy are intentionally deferred until after finalist selection and the final mockup board.
- **Generated concept quality** — Plan 02 must prove that the concept-design images and HTML boards can carry the reference evidence without drifting into cyberpunk, synthwave, or childish prize-room styling.

**Confidence in coverage:** **MEDIUM-HIGH** for reference-source coverage after the Phase 3 mood-board; **MEDIUM** for final design certainty until user mockup approval. **What would raise it:** Complete Plan 02 concept boards, then pass the Phase 3 finalist and final approval checkpoints without anti-cyberpunk or accessibility concerns.

---

## 6. Godot Theme docs

**Source name + location:**
- https://docs.godotengine.org/en/stable/tutorials/ui/ (root)
- Specific URLs from PROJECT.md Inspirations table:
  - `class_theme.html` — Theme class API
  - `class_styleboxflat.html` — StyleBoxFlat properties
  - `gui_theme_type_variations.html` — type variations workflow
  - `gui_using_fonts.html` — fonts and text rendering

**What was read (initial pass, 2026-05-04):**
- Theme class docs in full — 6 theme item types (color/constant/font/font_size/icon/stylebox), `default_font`, `default_font_size`, `default_base_scale`, `set_type_variation()` API
- StyleBoxFlat docs in full — bg_color, border, corner_radius (per-corner), shadow_*, anti_aliasing, anti_aliasing_size, expand_margin, skew, draw_center
- Theme Type Variations tutorial in full — workflow: theme editor → `+ Type` → set `Base Type` → use `theme_type_variation` on Control
- Using Fonts tutorial in full — TTF/OTF/WOFF/WOFF2 supported; FontFile vs FontVariation distinction; MSDF; `opsz`, `wght`, `slnt` axes; fallbacks via Advanced Import Settings or `FontFile.fallbacks`
- All major Control class pages (Button, LineEdit, Tree, ItemList, TabBar, TabContainer, PopupMenu, ColorPicker, GraphEdit, FileDialog, MenuBar, ProgressBar, Slider, ScrollBar, AcceptDialog, Popup, CodeEdit, Label, Panel, RichTextLabel, Window) — theme entry tables enumerated in FEATURES.md Section 2
- FontVariation docs — `variation_opentype` axis-tag dictionary; `variation_transform` for synthetic skew; `base_font` chain
- Godot 4.6 release notes — Modern theme default, focus stylebox decoupling, `pivot_offset_ratio`, MarginContainer indicators
- Multiple resolutions docs — `content_scale_factor`, `default_base_scale`
- Asset Library submission docs — `addons/asset_name/` convention, `.gitignore` and LICENSE required, square 128×128 icon, manual approval

**What we adopted:**
- **Authoritative API reference everywhere** — STACK.md, FEATURES.md, ARCHITECTURE.md, PITFALLS.md all cite specific API surfaces from these docs.
- **35-class user-facing Control inventory** — FEATURES.md Section 1 derives directly from the Control hierarchy.
- **Per-Control theme entry matrix** — FEATURES.md Section 2 enumerates every theme entry per Control with cardinality (S=stylebox, C=color, F=font, FS=font_size, I=icon, K=constant).
- **Type Variation as the recommended reuse mechanism** — FEATURES.md Section 4 specifies 13 variations using `theme_type_variation` API.
- **Font import settings (Grayscale AA, Light hinting, Auto subpixel)** — STACK.md and ARCHITECTURE.md Section 2 derive from font docs and the LCD subpixel + GL Compat bug (#77443).
- **`uid://` reference scheme over bare `res://`** — PITFALLS.md 9.4 + STACK.md addon layout — derived from Asset Library submission docs and resource UID system.
- **Theme Editor as authoring surface** — PROJECT.md mandate confirmed by Theme docs as the canonical workflow.
- **Asset Library layout convention** — STACK.md addon directory layout follows `addons/<asset_name>/` strictly.

**What we rejected:**
- **`SystemFont` resource as default_font** — Defeats the "consistent across machines" promise; documented in STACK.md "What NOT to Use."
- **`StyleBoxFlat` sharp corners + AA** — issue #87226 confirmed via docs; STACK.md mandates `corner_radius >= 2` minimum on AA-enabled boxes.
- **MSAA-based 2D AA expectations** — issue #69462 confirmed via docs; rely on per-stylebox AA instead.
- **Synthetic italic via `variation_transform` skew** — Inter v4 has real italic VF; STACK.md mandates real italic file.
- **Subpixel positioning AUTO without verification** — issue #102509 (warning misfire) flagged in PITFALLS.md 5.5.

**What's still open:**
- **Verification of any 4.6.x point release fixes** — particularly #115500 (theme inspector crash) and #80731 (font inheritance). Phase 5 implementation must verify against latest stable.
- **`accessibility_name` API surface** — added in 4.5; PITFALLS.md 2.5 + 4.4 flag for showcase scene + screen-reader sanity. Initial pass surface-read only.
- **`pivot_offset_ratio` use cases for theme contexts** — new in 4.6, not yet evaluated for theme application.
- **MarginContainer in-viewport indicators** — new 4.6 feature; not yet evaluated.

**Confidence in coverage:** **HIGH** — official docs are authoritative; per-Control theme entry tables verified against class pages. **Per the user's global rule**, implementation phases must re-verify via Context7 MCP rather than relying on this initial pass's WebFetch reads.

---

## 7. Godot controls gallery (godot-demo-projects/gui/control_gallery)

**Source name + location:**
- https://github.com/godotengine/godot-demo-projects/tree/master/gui/control_gallery

**What was read (initial pass, 2026-05-04):**
- Repository tree structure
- README and surface-level scene file inspection (verified sections "Basic controls / Numbers / Lists" and Control list including FoldableContainer)
- Layout patterns: top-toolbar, scrollable section content, per-Control sample panels
- **NOT read in initial pass:** `.tscn` file in full; per-Control sample-content patterns; layout constants (separations, margins, MarginContainer values used)

**What we adopted:**
- **Showcase scope reference** — FEATURES.md Section 5 mirrors the gallery sections (Buttons, Inputs, Numbers, Lists, Containers, Dialogs, Advanced) plus NeoCade additions (Token Gallery, Coverage Verification 35/35).
- **FoldableContainer requirement** — control_gallery includes it; FEATURES.md TS-coverage includes it (Godot 4.4+ Container).
- **Sample-content discipline** — PITFALLS.md 10.1 derives from the gallery's pattern of populating every control with realistic content (Tree with multi-level items, OptionButton with multiple options, etc.).
- **Section-headed scrolling layout** — informed showcase scene structure.

**What we rejected:**
- **control_gallery's literal layout** — it's a Godot-default-styled reference; NeoCade's showcase is themed and adds the toggle button + Token Gallery. Structural reference, not visual copy.

**What's still open:**
- **Full `.tscn` enumeration** — exact node tree, exact layout constants, exact sample content per Control. Phase 8 showcase implementation will likely reference the actual `.tscn` file at that point.
- **Comparison of control_gallery scope vs Godot 4.6's full Control hierarchy** — does the gallery cover all 35 user-facing classes? Initial check suggests yes for the major ones; minor classes (Separator, ReferenceRect, MenuBar in some demos) may need explicit inclusion.

**Confidence in coverage:** **MEDIUM-HIGH**. Section list verified; per-section detail not yet compiled. **What would raise it:** open the `.tscn` during Phase 8 (showcase implementation) and copy the sample-content structure rather than re-invent.

---

## 8. `.planning/inputs/NeoCade-Research-Report.md` (user's prior research)

**Source name + location:**
- `C:\Programming_Files\Shilocity\Godot\NeoCade-Theme\.planning\inputs\NeoCade-Research-Report.md`
- Status per PROJECT.md: "Reference, NOT source of truth — researchers MUST challenge it."

**What was read (initial pass, 2026-05-04):**
- The full document, claim-by-claim
- Cross-referenced against PROJECT.md hard constraints (theme name, anti-cyberpunk, HD-only, full Control coverage)

**Claim-by-claim audit:**

| # | Prior-report claim | NeoCade verdict | Evidence / replacement |
|---|---|---|---|
| 1 | "VirtuCade Godot Theme" naming throughout | **REJECT** | PROJECT.md hard constraint: theme is **NeoCade**; VirtuCade is consuming game. STACK.md, ARCHITECTURE.md, SUMMARY.md all enforce. |
| 2 | LDtk's UI uses "Material Design SVG icons" | **REJECT exact source claim after Phase 2** | `.planning/research/LDTK-UI-MINING.md` found 98 local SVGs but no Google/Material source metadata; evidence instead includes internal/FinalBossBlues attribution and one Font Awesome-marked SVG. Use clear icon metaphors, not LDtk's assets or unverified attribution. |
| 3 | LDtk uses Endesga32 palette for level tiles | **CONFIRM content-only; REJECT as UI palette** | Phase 2 verified Endesga32 in `docs/CHANGELOG.md`, `README.md`, and `Const.hx` as generated content colors for entities/IntGrid/enums, not LDtk UI chrome. NeoCade must not use Endesga32 as its UI palette. |
| 4 | LDtk UI is "dark mode base" with "color accents" tinted per panel/mode | **PARTIALLY ADOPT** | Real LDtk `app.scss` confirms dark base (`#1e2229`) and orange accent (`#ffcc00`). Per-panel-tinted-by-function rejected (over-constrains consuming projects). |
| 5 | LDtk uses "flat iconography, monochrome white/light on colored backgrounds" | **ADOPT (without claim verification)** | Discipline aligns with NeoCade's bespoke SVG approach; claim's specific Material-icon source not verified in initial pass. |
| 6 | Godot Minimal Theme: `#272727` base, `#569eff` accent, Inter font, 4-5px corner, high icon saturation | **ADOPT (Inter, 4-5px, saturation); REJECT (`#272727`, `#569eff`)** | Verified accurate (godot-minimal-theme README confirms). Numerics rejected for NeoCade per Pitfall 6.1 (editor-scale-tuned) and identity discipline. |
| 7 | "Material You can extract palettes from images or allow user customization" | **NOT ADOPTED** | NeoCade ships fixed palettes; Material Theme Builder is a v2 alt-palette tool. |
| 8 | "Use subtle shadows or highlights on buttons (hover/pressed states) to convey depth" | **REJECT shadows; ADOPT highlights** | Conflict 3 resolution: no drop shadows in v1 (GL Compat over-renders alpha 2× per #23640). 1px lighter top-bevel border allowed as arcade button cap highlight without engaging broken shadow path. |
| 9 | "Slight corner rounding (4-8 px) on panels/buttons" | **ADOPT** | NeoCade default 4px, 8px on PopupPanel/Window, 12px on dialogs. |
| 10 | "Synthwave/Vaporwave Vibe — references to 1980s-90s sci-fi (Tron, synth music) – think magenta and cyan glows, grid patterns or scanlines as subtle background texture" | **HARD REJECT** | PROJECT.md hard constraint: "Synthwave/vaporwave/scanline/glow-effect aesthetic — explicitly rejected as too cyberpunk-adjacent." ARCHITECTURE.md Section 7 codifies 12 forbidden visual moves. |
| 11 | "Bright neon colors (hot pink, electric cyan, bright green, purple) on deep black or navy backgrounds" | **PARTIALLY REJECT** | "Pure neon on near-black" reads synthwave. NeoCade keeps multi-hue palette but uses warm hues, >60% lightness, warm-near-black surfaces (`#1A1410` Boardwalk Sunset), not pure black. |
| 12 | "Reserve a stylized pixel font for title logos only" | **HARD REJECT** | PROJECT.md: "Pixel font for any UI element including logos — conflicts with HD-only constraint." Inter Display via `opsz=32` replaces. |
| 13 | "Buttons might have a slight 8-bit outline or glow" | **HARD REJECT** | No glow halos in v1 (PITFALLS.md 7.2). 8-bit outlines conflict with HD constraint. |
| 14 | "Bold buttons & icons — chunky, framed buttons labeled in pixel/bitmap fonts" | **REJECT pixel fonts; ADOPT bold + chunky discipline** | PROJECT.md anti-pixel-font; FEATURES.md adopts bold weight + larger size for headings. |
| 15 | Color tokens: `BG_DARK=#101010`, `ACCENT_PRIMARY=#00ffff`, `ACCENT_SECONDARY=#ff33cc`, `TEXT_HIGH=#f0f0f0`, `TEXT_LOW=#888` | **REJECT** | Pure-black `#101010` reads "matrix terminal" (PITFALLS.md 7.1). Pure neon `#00ffff` and `#ff33cc` are the literal synthwave palette. NeoCade uses Boardwalk Sunset / Cabinet Chrome / Midnight Marquee instead. |
| 16 | Example StyleBox: `border_width_all = 2`, `border_color = ACCENT_PRIMARY.darker(0.8)` | **REJECT** | Heavy boxed look fights modern arcade brief. STACK.md: default `border_width = 1`; reserve `>= 2` for Active/Selected/Focused states. |
| 17 | `corner_radius = 5` | **NEAR-ADOPT** | Adopt 4px default (godot-minimal-theme parity). |
| 18 | Name suggestions: "ArcadeGlow UI", "NeonGrid Theme", "RetroSynth Theme", "VirtuPixel Theme", "SynthWave UI", "CyberCade", "NeonCade", "NightArcade Theme" | **HARD REJECT entire list** | Name is locked by user as **NeoCade**. ALL synthwave-coded suggestions ("SynthWave UI", "CyberCade", "RetroSynth", "NeonGrid") are explicitly anti-cyberpunk-violating. |
| 19 | Use Material icon library | **REJECT for default; ALLOW as user opt-in via separate plugin** | Texture2D-per-slot mismatch + size cost. Bespoke SVG set replaces. The existing Lucide-icons Godot Asset Library plugin (asset/5047) is orthogonal and fine for consuming projects. |
| 20 | "Tertiary Accent: Bright green or purple (#00ff66 or #cc00ff) for alerts or toggles" | **REJECT pure-saturation; ADOPT desaturated equivalents** | `#00ff66` and `#cc00ff` are pure-saturation neon and fail readable contrast as text. NeoCade's success/warning/danger tokens use desaturated mid-luminance hues per ARCHITECTURE.md (e.g. Boardwalk Sunset's `#9CD168` pinball-bumper green). |

**What we adopted:**
- The **structural framing** (LDtk + Material 3 + arcade as inputs) is broadly aligned with the user's mental model, even where specific claims fail.
- The **discipline of writing things down** before implementation — the prior report set the precedent for committed research artifacts (now mandated as Research Charter).
- The **list of motifs to investigate** (neon/dark contrast, pixel/vector art, bold buttons, sound/animation suggestions) — even where the specific motifs are rejected, they identify the design space researchers had to enter and counter.

**What we rejected:** Most specific recommendations (see audit table). The prior report consistently leans synthwave/cyberpunk-adjacent and uses "VirtuCade Theme" naming. Both are PROJECT.md hard-constraint violations.

### Phase 2 LDtk Claim Verification

Phase 2 checked LDtk-specific report claims in `.planning/research/LDTK-UI-MINING.md`.

- Material/Google icon claim: not evidenced locally and rejected as an exact source claim. LDtk has 98 SVGs under `app/assets/icons`, but local metadata did not prove Google Material usage; source evidence points to internal/FinalBossBlues attribution and one Font Awesome-marked SVG.
- Endesga32 claim: confirmed for generated content colors only, not UI chrome. It can inform content swatch contrast thinking, but it is rejected as a NeoCade UI palette.
- Dark base with bright accents: broadly confirmed as LDtk-like, but non-binding for NeoCade token values.
- Tinted sidebar/per-panel colors: partially true as app/content semantics, rejected as global NeoCade theme roles.
- "UI colors come from themes/custom overrides": overstated; LDtk source uses app SCSS plus content/user color features.
- Neon/synthwave/pixel-font and VirtuCade naming claims: already rejected by project hard constraints; Phase 2 reinforces those rejections with LDtk source boundaries.

**What's still open:**
- **Verification of cited sources** (e.g. "【3†L72-L80】", "【5†L384-L389】", "【44†L1360-L1368】") — the report uses internal citation tokens that don't link to verifiable sources. Initial pass did not back-trace these.
- **Whether the report's palette suggestions overlap with any v2 alt-palette idea** — e.g., "Magenta-led" v2 palette could borrow some of the rejected hues if reframed warmer.

**Confidence in coverage:** **HIGH** for the audit (claim-by-claim with explicit verdicts and PROJECT.md cross-references). **What would raise it:** N/A — the report is now correctly bounded as "challenged reference, not source of truth."

---

## 9. `.planning/inputs/NeoCade-Theme-Prototype.png` (user's prior mockup)

**Source name + location:**
- `C:\Programming_Files\Shilocity\Godot\NeoCade-Theme\.planning\inputs\NeoCade-Theme-Prototype.png`
- Status per PROJECT.md: "Reference, NOT source of truth — researchers MUST challenge it."

**What was read (initial pass, 2026-05-04):**
- The full image, visually inspected
- Cross-referenced against PROJECT.md hard constraints and FEATURES.md token gaps
- ARCHITECTURE.md Section 8 produced an element-by-element critique

**Element-by-element critique:**

| # | Prototype element | NeoCade verdict | Evidence / replacement |
|---|---|---|---|
| 1 | Title label "VirtuCade Godot Theme" with subtitle "UIs early • Material surface + arcade neon" | **REJECT name** | PROJECT.md: theme is **NeoCade**. Every artifact must say NeoCade. Subtitle's "Material surface + arcade neon" framing is on-target. |
| 2 | Top-right corner: "Save / Preview / Settings" buttons | **PRESERVE pattern (toolbar)** | Useful showcase pattern — Phase 8 showcase scene includes a top toolbar with NeoCade↔Godot toggle in this slot (replacing prototype's Save). |
| 3 | Left sidebar: vertical icon column (Select, Brush, Layers, Magic, History) | **PRESERVE structural pattern** | Sidebar layout informs FEATURES.md Section 5 layout (left section nav, central scrolling area). |
| 4 | Surface ramp legend top-left: Base/Secondary/Panel/Raised/Elevated 5 stops | **ADOPT structure; RENAME to M3 canonical** | Conflict 2 resolution: M3 canonical names (`surface` → `surface-container-highest`) + friendlier aliases (base/secondary/panel/raised/overlay) preserved. ADD `surface.overlay` (mapped to `surface-container-highest`). REJECT `surface.sunken` for v1. |
| 5 | Accent palette legend: 8 hues (Cyan/Pink/Violet/Green/Amber/Red/Orange/Blue or similar) | **ADOPT shape; SWAP to chosen palette's hues** | FEATURES.md DF-4 specifies 8 hues. ARCHITECTURE.md provides 3 candidate palettes (A/B/C) for mockup gate; final hex values chosen by user at Step 1 approval. |
| 6 | Typography legend: "Stroke / Strong / Text / Muted / Dim" labels | **ADOPT structure; RENAME** | FEATURES.md gap-fix: rename "Stroke" to `text.strong` (in design-system parlance "stroke" means border thickness; ambiguous). Add separate `type.*` size scale (h1/h2/h3/body/code) — prototype legend conflates color and size. |
| 7 | Center-right: "Apply Theme" modal with Apply/Cancel buttons + "Open Theme Editor" link | **PRESERVE pattern** | Clean modal pattern; informs Phase 8 showcase AcceptDialog/ConfirmationDialog example. |
| 8 | Right column: "Godot Controls" comprehensive list — Button, OptionButton, CheckBox, RadioButton, Slider, SpinBox, ColorPicker, Tabs, ProgressBar, MenuBar, Tree, ItemList, file dialog | **ADOPT scope** | Mirrors FEATURES.md Section 1 35-class coverage. Prototype's Control inventory is the right scope to mirror in showcase scene — no scope changes needed. |
| 9 | Bottom strip: status pills "0.5 \| Layer: Arcade Props \| Project saved" | **PRESERVE pattern** | Status-bar pattern informs showcase Section 5.4 (resolution test selector, coverage counter strip). |
| 10 | Overall background color: deep navy / dark blue with magenta CTA chrome | **REJECT — read as cyberpunk** | ARCHITECTURE.md Section 8: cool slate panel + magenta CTA reads "Cyber Cafe at midnight." User's "leans too futuristic" feeling is real. Boardwalk Sunset (warm pine surface) is the recommended fix; Cabinet Chrome is the disciplined alternative. |
| 11 | Magenta primary + electric cyan tab highlights | **REJECT — synthwave signature** | PITFALLS.md 7.1: dark + neon = synthwave by default; magenta + cyan paired is the literal synthwave color signature. ARCHITECTURE.md replaces with amber + coral + mint-teal (Boardwalk Sunset) or orange + cool blue (Cabinet Chrome). |
| 12 | Visible glow halos / soft outer light on active tab and primary button | **HARD REJECT** | PITFALLS.md 7.2: glow effects creep in via "soft shadow or outer stroke" → synthwave drift. ARCHITECTURE.md Section 7 forbidden visual moves. Replace with 8% tonal hover overlay + solid 2px focus ring only. |
| 13 | Visible focus indicator | **MISSING — must add** | ARCHITECTURE.md Section 8: prototype shows hover-ish styling on tabs/buttons but no dedicated 2px solid focus ring — accessibility regression vs WCAG 2.1 SC 1.4.11 + SC 2.4.7. Every focusable Control must get the 2px outer focus ring. |
| 14 | Status pill icons (CRT-styled, glowing) | **REJECT — synthwave drift** | ARCHITECTURE.md Section 8: pill icons reinforce cyberpunk drift. Replace with flat material-style monochrome accent fill, no glow. |
| 15 | Rounded panel corners throughout | **PRESERVE — value 4px default** | Aligns with godot-minimal-theme parity. |
| 16 | Comprehensive Control coverage in showcase | **PRESERVE — extends to FEATURES.md scope** | Prototype proves the 35-class coverage is achievable in one scene; FEATURES.md Section 5 extends with 9 sections + Token Gallery + Coverage Verification strip. |

**What we adopted:**
- **Surface ramp structural concept** (5 stops) — preserved, renamed to M3 canonical with friendlier aliases.
- **8-hue accent palette concept** — preserved, hex values become the user's pick at mockup gate.
- **Typography color hierarchy** — preserved, renamed and extended (separate `type.*` size scale added).
- **Comprehensive Control showcase scope** — preserved.
- **Modal/dialog pattern, status strip pattern, sidebar pattern** — preserved as showcase structural patterns.

**What we rejected:**
- **Theme name "VirtuCade Godot Theme"** — hard rejection (PROJECT.md).
- **Magenta + cyan color story** — synthwave signature; replaced with Boardwalk Sunset (amber/coral/teal) or alternates.
- **Glow halos on active tab and primary button** — anti-cyberpunk rule.
- **Pure-deep-navy backdrop** — reads cool/computer-screen; replaced with warm-neutral pine (Boardwalk) or LDtk-inspired neutral charcoal (Cabinet Chrome).
- **Status pill CRT styling** — synthwave drift.
- **Implicit focus indicator** — must be made explicit (2px outer ring).
- **"Stroke" naming for brightest text color** — ambiguous in design-system parlance; renamed to `text.strong`.
- **Single typography axis (color only)** — gap-fix: separate `type.*` size scale added.

**What's still open:**
- **Comparison against the post-mockup-gate user-chosen palette** — Phase 3 produces 3 palette mockups for user approval; "what the user actually wants" is determined there, not pre-committed in this synthesis.
- **Whether the prototype's specific layout proportions translate to Godot Theme** — toolbar height, sidebar width, modal width-to-height ratios need translation from PNG to Container/MarginContainer constants in Phase 8.
- **What the prototype gets right that researchers might have missed** — the prototype is the user's curated mental model; subtle preserve-this signals (e.g. spacing between sidebar icons, status pill size) may be re-evaluated during Phase 8 showcase implementation.

**Confidence in coverage:** **HIGH** for the element-by-element critique. **What would raise it:** Phase 3 mockup phase produces direct side-by-side comparison (prototype vs Boardwalk Sunset vs Cabinet Chrome vs Midnight Marquee) so the user can make the picker decision with full visual context.

---

## 10. CROSS-PLATFORM dimension sources (added 2026-05-04 after 5th researcher landed)

**Source name + location:**
- See `.planning/research/CROSS-PLATFORM.md` for full dimension document.

### 10a. Godot 4.6 export docs (per target)

**What was read:** Godot 4.6 export tutorials for Web, iOS, Android, Windows, macOS, Linux; Multiple resolutions / `content_scale_factor`; Godot 4.6 release notes for export-relevant changes.

**What we adopted:**
- **GL Compatibility renderer is the cross-platform-safe choice** — already locked in `project.godot`. Avoids two new Godot 4.6 regressions (#116090 iOS Mobile-renderer Metal validation failure on iPhone SE 2nd gen; #111729 Android Mobile-renderer reduces Play Store device coverage). Stay on GL Compat.
- **`content_scale_factor` + Godot stretch modes (`canvas_items` + `expand`) for density** — ONE mobile theme covers all Android density buckets; no per-bucket .tres needed.
- **`uid://` references mandatory** for all theme/font/icon resources — survives PCK remap on all targets including Web.
- **Web export: SystemFont fails silently** — must use FontFile + bundled `.ttf`. `.ttf` files added to "Filters to export non-resources" OR wrapped in saved `FontFile.tres`.

**What we rejected:**
- **Switching to Mobile renderer** for iOS/Android — explicit anti-pattern given current 4.6 regressions.
- **Per-density-bucket theme files** (`mdpi.tres`, `hdpi.tres`, etc.) — Godot doesn't use Android density qualifiers for theme resources.
- **Pixel-parity expectation across targets** — iOS Safari WebGL2 has documented quirks; v1 acceptance is "render correctly," not "pixel-identical to desktop."

**What's still open:**
- Whether 4.6.x has fixed the iOS Safari/Chrome HTML5 audio crash (#107390, was 4.5 dev5) — informational only since theme has no audio.
- Whether iOS Mobile-renderer regression (#116090) gets backported to 4.6.x point release — informational only since we use GL Compat.

**Confidence:** HIGH on Godot 4.6 export docs and named regression issues; MEDIUM on Web export real-world reliability.

### 10b. iOS Human Interface Guidelines (HIG)

**What was read:** developer.apple.com/design/human-interface-guidelines pages — Layout, Typography, Touch targets, Accessibility.

**What we adopted:**
- **44×44 pt minimum tap target** — mobile theme Button minimum height = 48px (Godot pixels at base scale 1.0) covers iOS HIG 44pt and Android Material 48dp simultaneously.
- **Type-scale uplift on mobile** — body text 16px on mobile vs 14px desktop; line-height retained as M3 spec.
- **Visible focus indicator on all focusable controls** — 2px outer ring (already mandated by ARCHITECTURE.md Section 5).

**What we rejected:**
- **Native iOS visual look** — NeoCade retains arcade visual identity across platforms; we adopt iOS HIG *minimums*, not its visual language.
- **iOS-specific dark/light auto-switching** — v1 is dark-only; auto-switching is v2.

**Confidence:** HIGH (current HIG verified; numerics cited from spec).

### 10c. Android Material 3 mobile guidance

**What was read:** m3.material.io pages — Layout (window size classes), Touch targets (48dp), Accessibility (contrast and adaptive sizing).

**What we adopted:**
- **48dp minimum tap target** — same value as iOS HIG 44pt × 1.09 — covered by 48px theme constant.
- **Spacing scale +50% on space.4 and above on mobile** — preserves usability without breaking desktop visual rhythm.
- **Window size classes are application-level concern, not theme-level** — NeoCade ships two themes (desktop + mobile); consuming app picks per platform/window size.

**What we rejected:**
- **Material You dynamic palettes on Android** — NeoCade ships fixed palettes; v2 alt-palette generation is explicit fork, not generated.
- **Adaptive theming via Android theme XML** — orthogonal to Godot theme system.

**Confidence:** HIGH.

### 10d. Token-sharing strategy: ThemeGen reference + Godot Theme class verification

**What was read:** Godot Theme class API docs (verified `merge_with()` and `copy_from()` are runtime-only; no .tres-to-.tres inheritance exists); ThemeGen MIT (github.com/Inspiaaa/ThemeGen) — proven `@tool` script generator pattern.

**What we adopted:**
- **`@tool` Theme subclass pattern** — `addons/neocade_theme/scripts/neocade_theme.gd` backs five data-only direction resources and regenerates entries from exported state, including desktop/mobile/AUTO platform behavior.
- **ThemeGen as prior-art reference only** — verifies code-generated theme entries are practical; NeoCade does not ship a `_dev/` generator in v1.

**What we rejected:**
- **`.tres`-to-`.tres` inheritance** — does not exist in Godot's Theme system (verified, not assumed).
- **Separate generated desktop/mobile `.tres` resources** — superseded by the `platform` export on the single concrete class.
- **External tool dependency for consumers** — consumers receive direction `.tres` files, scripts, fonts, and icons with no generator dependency.

**Confidence:** HIGH on Godot Theme limits; MEDIUM on generator implementation (well-precedented but custom code path).

### 10e. Font license compliance — SIL OFL FAQ + Inter OFL text

**What was read:** openfontlicense.org/ofl-faq, Inter OFL text, and candidate-font licenses for Noto Sans, Outfit, and JetBrains Mono.

**What we adopted:**
- **Inter passes App Store + Play Store + Web embedding** under OFL 1.1.
- **`addons/neocade_theme/fonts/inter_ofl.txt`** covers the bundled Inter font.
- **Reserved-name clause: do not modify font internals or rebrand derivative fonts** — keeps OFL compliance intact.
- **Consuming apps surface `inter_ofl.txt` content in About/Credits** — README/docs document this requirement for downstream developers.

**What we rejected:**
- Renaming bundled font binaries (would violate OFL Reserved Font Name).
- Modifying font binary metadata (same).

**Confidence:** HIGH (cited authoritative sources).

### 10f. Open testing-matrix questions (NOT sources, but raised by CROSS-PLATFORM research)

- Real-device Android testing matrix: 3 devices needed (low/mid/high-end). User hardware unknown.
- iOS testing requires Mac + paid Apple Developer Program. User status unknown.
- ~~Whether to ship Inter Italic in v1 (~+0.85 MB) or defer to v1.x.~~ **RESOLVED 2026-05-04 in SUMMARY Conflict 1 revision: defer Inter Italic to v1.x; ship Outfit Variable in v1 instead. Synthetic italic transform used until v1.x.**
- AccessKit / VoiceOver / TalkBack screen-reader integration is partial in Godot 4.6 — full integration deferred to v1.x or v2; v1 sets `accessibility_name` on showcase Controls only.

These are surfaced for the roadmap planning phase to convert into open user decisions or scope decisions.

---

**Net change to SOURCES.md after Phase 2 LDtk source-dive:** Sources 2, 3, and 8 now link to `.planning/research/LDTK-UI-MINING.md`; LDtk source coverage is HIGH for v1 UI-theme research. Remaining highest-priority gap is Phase 3 real-arcade reference photos.

---

## 11. MD3 + MD3 Expressive sources (added 2026-05-05 by Phase 3.1)

**Source name + location:**
- Final artifact: `.planning/research/MD3-RESEARCH.md`
- Material official pages: https://m3.material.io/styles/color/system/overview, https://m3.material.io/styles/typography/type-scale-tokens, https://m3.material.io/styles/shape/shape-scale-tokens, https://m3.material.io/foundations/interaction/states/state-layers, https://m3.material.io/blog/building-with-m3-expressive
- Android Developers Material 3: https://developer.android.com/develop/ui/compose/designsystems/material3
- Material Web token sources: https://github.com/material-components/material-web/tree/main/tokens/versions
- Godot docs: https://docs.godotengine.org/en/stable/classes/class_styleboxflat.html, https://docs.godotengine.org/en/stable/classes/class_theme.html, https://docs.godotengine.org/en/stable/tutorials/ui/gui_theme_type_variations.html
- Google/Android MD3 Expressive sources: https://blog.google/products/android/material-3-expressive-android-wearos-launch/, https://developer.android.com/jetpack/androidx/releases/compose-material3, https://developer.android.com/training/wearables/versions/6/features?hl=en, https://android-developers.googleblog.com/2025/08/introducing-material-3-expressive-for-wear-os.html

**What was read (Phase 3.1, 2026-05-05):**
- Material official URLs were retained as canonical entry points; direct non-JS extraction was limited and labeled as `browser/manual verified`, `fallback source used`, or `unresolved extraction gap`.
- Android Developers Material 3 in Compose page for key colors, tonal palettes, dynamic color, semantic roles, typography, shape, accessibility, and current MD3 Expressive guidance.
- Material Web raw SCSS token files for type scale, shape scale, state-layer values, color roles, elevation values, and filled/outlined button disabled opacity.
- Godot official `StyleBoxFlat`, `Theme`, and Theme type variation documentation for visual recipe and mapping feasibility notes.
- Google/Android MD3 Expressive launch/current sources, including a post-launch check after the 2025-05-13 announcement.

**Source-access status:**
- Official Material pages: `browser/manual verified` + `fallback source used`; several public pages require JavaScript in this runtime.
- Android Developers and Godot docs: `directly extracted`.
- Material Web token files: `upstream-token corroborated`.
- Expressive official-page direct extraction: `unresolved extraction gap`, non-blocking because Android/Google/Material Web sources corroborate the facts used.

**What NeoCade adopts:**
- MD3 as a static design-system grammar: role colors, tonal surface ladder, 15-role type scale, shape scale, state-layer values, component hierarchy, and accessible on-role pairing.
- Numeric state values: hover 8%, focus 12%, pressed 12%, dragged 16%, disabled 38% content, disabled container 12%, plus NeoCade's project-required 2px focus ring.
- MD3 Expressive static principles: stronger personality, controlled saturated color, larger emphasis moments, expressive shape/scale, and glanceable hierarchy.
- Exact/composed/NeoCade-owned Material-to-Godot mapping discipline.

**What NeoCade rejects:**
- Roboto or any new font family for v1; Inter Variable Roman remains the only assumption.
- Android dynamic wallpaper color, Android/Wear OS system UI behavior, Live Updates, notification behavior, haptics, spring animation, blur/depth backgrounds, and motion-only behavior.
- Soft shadow elevation, glow, bevel gradients, texture, painterly chrome, synthwave/cyberpunk drift, and fake Material equivalents for Godot-specific Controls.

**What remains open:**
- Phase 3.3 decides how much Expressive personality each candidate direction uses.
- Phase 3.4 mockups decide which Controls can safely get larger, rounder, or more saturated without breaking desktop density.
- Phase 3.2 validates architecture support for the mapped visual recipes; Phase 3.1 did not run an architecture spike.

**source agreement / conflict notes:**
- Material Web and Android Developers agree on the 15-role type scale and core state-layer values.
- Material Web and Android Developers use the same shape-role family; one non-blocking numeric difference remains for extra-large shape sample/token values. NeoCade does not choose final radii in Phase 3.1.
- Disabled 38% content and 12% container/outline values are corroborated by Material Web filled/outlined button token sources.
- Official `m3.material.io` JavaScript extraction gaps are non-blocking because every numeric fact used downstream has an accessible fallback source.

**Rerun execution pass (2026-05-05):**
- Live spot-checks reconfirmed access to Android Developers Material 3, Material Web token sources, and Godot StyleBoxFlat/Theme/type-variation documentation.
- Local hard-fail audit rechecked MD3 numeric state values, source-access/source-agreement labels, Godot mapping terms, Flat-vs-Raised guidance, and forbidden implementation surfaces.
- No adoption/rejection/open-decision changes were required.

**Confidence:** HIGH for numeric MD3 token values and Godot API facts; MEDIUM-HIGH for MD3 Expressive synthesis because platform behavior must be filtered carefully for static Godot Theme scope.

---

## 12. Flat-3D Game UI sources (added 2026-05-05 by Phase 3.1)

**Source name + location:**
- Final artifact: `.planning/research/FLAT-3D-UI-RESEARCH.md`
- User exemplars: https://hcgamestudios.itch.io/flat-game-ui-for-mobile-games, https://fajrulaslim.itch.io/ui-button-flat-design/devlog/157464/ui-button-flat-design
- Broad-survey examples: https://kenney.nl/assets/ui-pack, https://www.gameart2d.com/minimalist-game-gui.html, https://www.deviantart.com/sungraphica/art/Flat-GUI-game-asset-pack-for-game-designers-975580487, https://assetstore.unity.com/packages/2d/gui/6000-flat-buttons-icons-pack-190732, https://interfaceingame.com/screenshots/brawl-stars-menu/, https://www.mobygames.com/game/166470/royal-match/screenshots/, https://apps.apple.com/us/app/candy-crush-saga/id553834731, https://craftpix.net/freebies/free-christmas-game-gui/, https://gamedesignskills.com/game-design/ui/, https://dribbble.com/tags/game-ui-buttons

**What was read (Phase 3.1, 2026-05-05):**
- The two user-supplied itch.io asset-pack pages, including textual pack descriptions and image/visual preview notes.
- Public asset-pack examples to identify common flat/extruded construction patterns.
- Commercial mobile-game screenshot sources to calibrate hierarchy, friendliness, and action prominence.
- Design-commentary source material to keep UI hierarchy/readability as the real design target.

**Source-access status:**
- Itch.io user exemplars: `directly extracted` and `browser/manual verified`, with screenshot/image link or visual-capture notes.
- Asset packs and commercial screenshot pages: mostly `browser/manual verified`, because source value is visual evidence rather than prose.
- Design commentary: `directly extracted`.

**What NeoCade adopts:**
- The construction evidence: solid top shape plus offset darker duplicate, simple rounded silhouettes, role-colored buttons, clear icon+label hierarchy, large friendly action targets, and mobile-game affordance clarity.
- The matrix principle: buttons and button-like controls change most visibly under `raised=true`; inputs and panels mostly stay flat; popups/dialogs selectively gain raised actions; passive text/decorative controls have no visible raised delta.
- Recipe B default recommendation: wrapper/two-layer composition for raised treatment, not direct soft shadows.

**What NeoCade rejects:**
- Copying asset artwork, sprites, icons, silhouettes, PSD/EPS/AI files, or commercial-game assets.
- Any effect that depends on blur, soft shadow, glow, bevel gradient, texture, painterly material, chrome, seasonal illustration, or low-context mood-board copying.
- Candy/holiday/themed decorative UI as reusable addon identity.

**What remains open:**
- Phase 3.2 must validate whether the recommended wrapper/two-layer raised recipe is architecture-feasible in a dynamic `NeoCadeTheme` system.
- Phase 3.3/3.4 decide whether `RaisedButton` should become a formal requirement and whether each candidate direction uses raised treatment heavily or sparingly.
- Direct `StyleBoxFlat.shadow_offset` remains a research note until Phase 3.2 proves it can create a hard duplicate without violating `shadow_size = -1` / no-soft-shadow rules.

**source agreement / conflict notes:**
- User exemplars and broad asset packs agree on flat game UI as solid, colorful, shape-driven button/panel composition.
- Commercial examples agree that large readable action hierarchy matters, but often include painterly/illustrative/gradient/texture effects that NeoCade explicitly rejects.
- Design commentary agrees with the adopted hierarchy/clarity principle, but does not override the hard visual filter.

**construction evidence / visual-capture summary:**
- Accepted survey rows include source URL, evidence role, source-access status, screenshot/image URL or visual-capture note, hard-filter audit, and adopt/reject/open decision.
- Rejected rows are intentionally retained to keep the future design out of gradient, texture, seasonal illustration, candy-gloss, and low-context board territory.
- Asset packs are inspiration and construction evidence only, not artwork to copy.

**Rerun execution pass (2026-05-05):**
- Live spot-checks reconfirmed access to both user exemplar pages and Godot StyleBoxFlat/Theme documentation relevant to raised recipe feasibility.
- Local hard-fail audit rechecked construction evidence, visual-capture fields, hard-filter audit language, Control-family matrix coverage, escape-hatch notes, and forbidden implementation surfaces.
- No adoption/rejection/open-decision changes were required.

**Confidence:** HIGH that the valid raised grammar is narrow and well-scoped; MEDIUM that the final raised intensity should be chosen before mockups, so Phase 3.4 must show both flat and raised variants.

---

## 13. Godot Dynamic Theme Architecture sources (added 2026-05-06 by Phase 3.2)

**Source name + location:**
- Final artifact: `.planning/research/GODOT-DYNAMIC-THEME-RESEARCH.md`
- Strict verifier output: `.planning/spikes/dynamic-theme/VERIFY-RESULTS.md`
- Research-only spike: `.planning/spikes/dynamic-theme/`
- Godot source: `C:/Programming_Files/Godot/godot-master/editor/themes/editor_theme_manager.cpp`, `.h`; `scene/resources/theme.*`; `scene/theme/theme_db.cpp`; `scene/theme/theme_owner.cpp`; `scene/resources/style_box*.{h,cpp}`
- Existing dissection dependency: `.planning/research/MINIMAL-THEME-DISSECTION.md`

**What was read (Phase 3.2, 2026-05-06):**
- Godot editor theme generation source around `_create_theme_config()`, `generate_theme()`, editor-settings dependencies, preset handling, and outdated checks.
- Runtime `Theme` APIs for `set_stylebox`, `set_color`, `set_font`, `set_font_size`, `set_constant`, `set_icon`, type variations, `clear()`, and fallback behavior.
- `ThemeOwner` and `ThemeDB` fallback lookup behavior to confirm why `has_*` verification is mandatory.
- `StyleBoxFlat` and `StyleBoxLine` APIs and draw behavior, especially shadow draw gating.
- Existing `godot-minimal-theme` dissection around `_get_base_color()` and representative Control coverage.
- Phase 03.2 dynamic Theme spike scripts/resources plus formal Godot 4.6.2 verifier output.

**Source-access status:**
- Godot source: `local source inspected`.
- Spike verifier: `executed locally` with Godot `4.6.2.stable.mono.official.71f334935`.
- Existing dissection: `local prior-phase artifact inspected`.

**What NeoCade adopts:**
- Dynamic scripted `Theme` architecture: `@tool extends Theme`, exported `base_color`, `accent_color`, `raised`, and `platform` values, deterministic `clear()` + regenerate flow.
- Runtime `Theme.set_*` APIs as the production mechanism for styleboxes, colors, fonts, font sizes, constants, icons, and type variations.
- Formula-derived tonal surfaces ported from passivestar-style `_get_base_color()` logic, but driven by NeoCade exports rather than editor settings.
- Super-first subclass contract: direction subclasses call `super._regenerate()` before personality overrides.
- `Theme.has_*` coverage verification to avoid fallback-masked missing entries.
- Godot-only `AUTO` platform resolution with forced DESKTOP/MOBILE escape hatches, feature tags, `OS.get_name()` fallback, and mobile-preferred ambiguous Web behavior.

**What NeoCade rejects:**
- Shipped dependency on `EditorSettings`, `EditorInterface`, `DisplayServer` system theme colors, `EDSCALE`, or editor custom-theme merge flow.
- Resource-level inheritance assumptions where a subclass `.tres` magically inherits generated entries without calling superclass code.
- JavaScript bridge as a Phase 4 dependency for Web platform detection.
- Soft shadow/elevation behavior for v1; `StyleBoxFlat.shadow_size` must remain zero in generated v1 chrome.
- Visual acceptance based only on screenshots or default fallback appearance.

**What remains open:**
- Phase 4 must implement and time the full 35-Control generator; the spike only proves a representative subset.
- Phase 4+ must add icons, fonts, type variations, and full coverage verifier rows.
- Phase 10 / UD-5 must handle real-device Android/iOS/Web validation; Phase 3.2 only simulated Web feature-tag cases.
- Inspector live-edit UX for exported properties should be verified once production addon scripts exist.

**source agreement / conflict notes:**
- Godot source confirms runtime `Theme` APIs and fallback behavior align with the planned dynamic architecture.
- Editor theme source confirms the formula/config pattern is useful but editor-bound; NeoCade must port the pattern, not the dependencies.
- The dynamic spike confirms that saved scripted `.tres` resources can load, regenerate, apply to a Control tree, and roundtrip through `ResourceSaver`.
- The negative subclass fixture confirms the critical failure mode: skipping `super._regenerate()` leaves detectable coverage gaps.

**strict feasibility outcome:**
- Overall: PASS for Phase 3.2 representative subset.
- Formal verifier command: `Godot_v4.6.2-stable_mono_win64_console.exe --headless --path . --script .planning/spikes/dynamic-theme/verify_dynamic_theme_spike.gd`
- Representative regeneration timing: `187 usec`.

**fallback status:**
- Recommended architecture: dynamic scripted `Theme`.
- One fallback retained for contingency: hybrid `@tool` static `.tres` generator if Phase 4 full-matrix dynamic implementation reveals a blocker.

**Confidence:** HIGH for representative architecture feasibility; MEDIUM-HIGH for full v1 feasibility until Phase 4 proves all 35 Controls, icons, fonts, and type variations.

---

## 14. Theme Direction Research sources (added 2026-05-06 by Phase 3.3)

**Source name + location:**
- Final artifact: `.planning/research/THEME-DIRECTIONS.md`
- Phase context and decisions: `.planning/phases/03.3-theme-direction-research/03.3-CONTEXT.md`
- Redirect feedback: `.planning/phases/03-visual-direction-mockup-approval-gate/REDIRECTED.md`
- Local inputs: `.planning/research/MD3-RESEARCH.md`, `.planning/research/FLAT-3D-UI-RESEARCH.md`, `.planning/research/GODOT-DYNAMIC-THEME-RESEARCH.md`, `.planning/spikes/dynamic-theme/VERIFY-RESULTS.md`
- User exemplars: https://hcgamestudios.itch.io/flat-game-ui-for-mobile-games, https://fajrulaslim.itch.io/ui-button-flat-design/devlog/157464/ui-button-flat-design
- Official MD3/Expressive references: https://m3.material.io/blog/building-with-m3-expressive, https://design.google/library/expressive-material-design-google-research, https://material-web.dev/theming/material-theming/, https://developer.android.com/design/ui/wear/guides/get-started/design-language, https://android-developers.googleblog.com/2025/08/introducing-material-3-expressive-for-wear-os.html
- Commercial / asset-pack survey references: https://kenney.nl/assets/ui-pack, https://www.gameart2d.com/minimalist-game-gui.html, https://modi-assets.itch.io/, https://gamecontentdeals.com/assets/2d/pinky-ui/, https://sungraphica.itch.io/flat-game-user-interface-asset-pack/purchase, https://interfaceingame.com/games/brawl-stars/, https://www.mobygames.com/game/204301/royal-match/screenshots/

**What was read (Phase 3.3, 2026-05-06):**
- THEME-DIRECTIONS.md was created and populated with provenance, filter contract, 14-source commercial survey, v0 feedback DNA mapping, five candidate directions, WCAG AA base/accent checks, per-direction filter audit, final verification log, and text-level approval checkpoint stub.
- 03.3-CONTEXT.md decisions D-01 through D-16 were used as the controlling requirements, especially D-03 broad personality spread, D-03b universal export axes, D-07 filters, D-11 SOURCES update, and D-12/D-13 approval gate.
- REDIRECTED.md was read for exact v0 user reactions and the hard Boardwalk Sunset rejection.
- Phase 3.1 MD3/Flat-3D research and Phase 3.2 dynamic theme architecture research were read as upstream constraints.
- External survey pages were inspected or retained with honest access-status labels in THEME-DIRECTIONS.md.

**Source-access status:**
- THEME-DIRECTIONS.md and local research: `local artifact inspected`.
- User exemplars and many asset-pack sources: `directly extracted` and/or `browser/manual verified`.
- `m3.material.io` Expressive page: `fallback source used`; canonical URL retained because direct extraction is JavaScript-gated in this runtime.
- Brawl Stars interface page: `blocked in direct open`; search-result summary plus Phase 3.1 visual-capture note used, with Royal Match and asset-pack rows covering the same evidence role.
- External survey rows in THEME-DIRECTIONS.md record retrieved dates individually; all Phase 3.3 survey rows were retrieved 2026-05-06 unless marked as local artifact evidence.

**What NeoCade adopts:**
- Five approved peer candidate directions for Phase 3.4 mockup: Pulse, Slate, Bubble, Daybreak, and Burst.
- Broad-spread personality model: dark saturated arcade, modern minimal dark, playful bubbly, friendly daylight, and expressive statement.
- Inspiration-only survey discipline: commercial and asset-pack examples validate hierarchy, construction, and personality, but not artwork, exact values, names, or layouts.
- Per-direction base/accent defaults with arithmetic WCAG AA checks at a stricter 4.5:1 floor for normal text/icons/focus affordances.
- Universal export-axis language: every direction supports flat/raised and desktop/mobile through the dynamic `NeoCadeTheme` superclass.

**What NeoCade rejects:**
- Boardwalk Sunset as a direction identity; its only retained lesson is the already-universal flat/simple mandate.
- Any direction differentiated by being the base, flat, raised, desktop, or mobile theme.
- Texture, patterns, embossing, painterly/leather/wood/grunge surfaces, gradients on chrome, glow-first focus, scanlines, synth/noir/dystopian framing, copied marketplace assets, exact commercial palettes, or app-specific UI layouts.
- Mockup, image, addon, theme resource, font, icon, scene, project, or `.tres` edits during Phase 3.3.

**What remains open:**
- Phase 3.3 user approval is complete after one naming revision to generic one-word names.
- Phase 3.4 mockups must visualize the approved directions in both flat and raised modes before selecting finalists.
- The Phase 3.4 gate still chooses which approved direction becomes the base `NeoCadeTheme` default.
- Phase 4 converts approved direction recipes into subclass profiles only after Phase 3.4 approval.

**source agreement or conflict notes:**
- User exemplars, asset-pack sources, and Flat-3D research agree on solid flat construction plus optional offset duplicate for tactile raised controls.
- MD3/MD3 Expressive sources agree with using role colors, shape, hierarchy, and accessible pairing as the static design grammar.
- Commercial examples validate energy and hierarchy but often include artwork/gradient/gloss effects that NeoCade explicitly rejects.
- Phase 3.2 architecture confirms directions must be personality subclasses over a common dynamic superclass, not a matrix of static flat/raised/mobile files.

**requirements / decision coverage:**
- RES-NEW-06: covered by five documented candidate directions.
- DESIGN-NEW-DIR-01: covered by the 14-source commercial example survey.
- DESIGN-NEW-DIR-02: covered by the per-direction filter audit.
- DOCS-05: this Section 14 update keeps SOURCES.md current for Phase 3 source-dive outputs.
- D-11: implemented by this Section 14.
- D-12/D-13: approval remains text-level and is recorded in THEME-DIRECTIONS.md; no mockups are created here.

**Confidence:** HIGH for text-level direction research readiness after the user approved the directions with generic one-word names.

---

## Summary of Source-Dive Spike Recommendations

Of the nine sources catalogued above, four have HIGH or HIGH-MEDIUM coverage from the initial parallel research pass; the other five have explicit gaps that the roadmap-level spike phases must close:

| # | Source | Initial coverage | Spike phase recommended |
|---|---|---|---|
| 1 | godot-minimal-theme | MEDIUM (README only) | **Phase 1: `.tres` line-by-line dissection** |
| 2 | LDtk UI docs | HIGH for v1 inspiration use after Phase 2 | Complete for v1; Phase 3 mockup decides which sketches to use |
| 3 | LDtk source code | HIGH for v1 UI-theme research after Phase 2 | Complete for v1; non-UI internals remain out of scope |
| 4 | Material Design 3 | HIGH | None needed |
| 5 | Real & virtual arcade aesthetics | MEDIUM-HIGH source coverage / MEDIUM final design certainty | Phase 3 mood-board complete; mockup approval still pending |
| 6 | Godot Theme docs | HIGH | None needed (re-verify via Context7 at each phase per user's global rule) |
| 7 | Godot controls gallery | MEDIUM-HIGH | (Folded into Phase 8 showcase implementation) |
| 8 | NeoCade-Research-Report.md | HIGH (audited) | None — correctly bounded as "challenged reference" |
| 9 | NeoCade-Theme-Prototype.png | HIGH (critiqued) | (Comparison surfaced at Phase 3 mockup gate) |
| 10 | CROSS-PLATFORM (pending) | PENDING | Will produce its own spike-phase recommendations |

Additional spike recommendations not tied to a specific source:
- **MCP/QA tooling baseline spike** (UD-1 + GoPeak smoke test) — Phase 3 baseline recorded in `.planning/research/PHASE-3-TOOLING.md`; direct GoPeak screenshot call remains pending until GoPeak is loaded as the active MCP server, but a programmatic screenshot fallback is proven.
- **Accessibility QA phase** — focus stylebox audit + CVD simulation + screen-reader sanity test. Phase 9 sub-phase.
- **Dual-renderer screenshot pass** (Forward+ vs GL Compatibility) — Phase 9 sub-phase.
- **Fresh-install dry-run** — pre-Asset-Library submission. Phase 9 sub-phase.
- **Cross-platform validation phase** (pending CROSS-PLATFORM researcher findings).
- **Mobile variant authoring phase** (pending CROSS-PLATFORM researcher findings).

---

*Source coverage dossier authored: 2026-05-04*
*Last updated: 2026-05-06*
*Update policy: append per-source updates with date+phase reference as roadmap-level spike phases produce deeper findings.*
