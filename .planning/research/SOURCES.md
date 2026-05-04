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

**What we adopted:**
- **Function-as-completeness-benchmark posture** — see PROJECT.md decision: "godot-minimal-theme is the feature-completeness benchmark, NOT visual reference." Reflected in FEATURES.md's 35-class coverage matrix.
- **Inter as primary UI font** — same choice as minimal theme; harmonizes NeoCade with Godot 4.6's new default editor theme. STACK.md adopts Inter Variable v4.x.
- **Corner radius default 4px** — STACK.md and ARCHITECTURE.md both anchor to this (godot-minimal-theme uses 4-5; we pick 4 with 8/12 escalations for popups/dialogs).
- **High icon saturation discipline** — bespoke SVG icon set per STACK.md authored at full saturation against dark surface.
- **Single-accent dominance pattern** — even though NeoCade has 8 accent hues, only ONE is the primary `role.primary` (cyan in Midnight Marquee, amber in Boardwalk Sunset, orange in Cabinet Chrome). Same discipline as minimal theme's `#569eff`.

**What we rejected:**
- **Verbatim numeric values** — Pitfall 6.1: minimal-theme numerics are tuned for editor scale (with `EDSCALE` factors); lifting them produces a theme that looks "minimal-ish" without distinct identity. NeoCade derives numerics from the design system in ARCHITECTURE.md, not from minimal-theme.
- **Single-accent palette** — NeoCade is a multi-accent arcade theme by mandate; FEATURES.md DF-4 specifies 8 accent hues with semantic role aliases. Minimal theme's mono-accent approach would miss the brief.
- **`StyleBoxEmpty` for transparent slots** — Pitfall 2.3: plugins assume `StyleBoxFlat` methods (issue #19 in minimal-theme). NeoCade prefers transparent `StyleBoxFlat` over `StyleBoxEmpty` whenever a slot may be queried by third-party code.
- **`#272727` base color** — too cool/neutral for arcade direction. Boardwalk Sunset uses `#1A1410` (warm near-black, brown undertone); Cabinet Chrome uses `#1E2229` (matches LDtk's `$bgDark` exactly, slightly warmer than minimal theme).
- **`#569eff` accent** — too generic-cool-blue per ARCHITECTURE.md Section 7. Replaced with arcade-amber/orange for distinctive identity.
- **Editor-only theme types** — minimal theme styles `FlatButton`/`MainScreenButton`/`BottomPanelButton`/`EditorInspector*` etc. NeoCade v1 scopes to user-facing public Control hierarchy only (FEATURES.md AF-6); editor parity is v1.x.

**What's still open:**
- **Full `.tres` enumeration** — what entries are defined per Control × per state; what are the actual numeric values of styleboxes; how does interaction state transform per class. **Recommended phase:** Phase 1 source-dive spike (per SUMMARY.md roadmap).
- **Accent application strategy** — how does minimal-theme apply its single accent across Tree selection, ItemList cursor, Tab selected, focus rings? Pattern catalogue not extracted.
- **Editor-theme-only types' theme entries** — even though we don't theme them in v1, we may want the entry list for v1.x editor-only coverage.
- **Comparison against Godot 4.6's "Modern" editor theme** — minimal-theme was ported but may have been tuned. Need diff.

**Confidence in coverage:** **MEDIUM** for v1 (README-level claims verified; coverage delta vs FEATURES.md not yet computed). **What would raise it:** Phase 1 source-dive spike that opens the `.tres` and enumerates entries.

---

## 2. LDtk UI docs

**Source name + location:**
- https://ldtk.io/docs/general/editor-components/

**What was read (initial pass, 2026-05-04):**
- LDtk editor-components page (component patterns, layout strategies)
- LDtk's UI conventions referenced in user's prior research report

**What we adopted:**
- **Polish/quality discipline as benchmark** — per PROJECT.md decision, LDtk is the polish bar, not visual copy. Reflected throughout ARCHITECTURE.md as "LDtk-grade clarity."
- **Tinted-sidebar concept** — adapted into NeoCade's accent-palette approach (8 hues with role aliases per FEATURES.md DF-4) without copying LDtk's specific tints.
- **Flat iconography baseline** — NeoCade's bespoke SVG set follows the same monochrome-on-accent flat-icon discipline (STACK.md icon strategy).
- **Status-strip pattern** — bottom status bar with project info, layer, save status — informed FEATURES.md Section 5.4 showcase scope (resolution test selector, coverage counter).
- **Toggleable panel pattern** — informed FoldableContainer requirement in FEATURES.md TS coverage.
- **Keyboard-hint inline labels** — informed accessibility consideration (label every focus path).

**What we rejected:**
- **Color-by-function-tinted sidebars** — LDtk does this for editor mode (blue=entities, brown=walls). NeoCade is a general theme, not a single-app editor — this pattern would over-constrain consuming projects.
- **Bitmap atlas font discipline** — LDtk bakes Noto Sans into PNG atlases due to Heaps engine constraints. Godot 4.6 has mature TTF/VF support — STACK.md uses dynamic FontFile/FontVariation, not BMFont (Pitfall 5.4).
- **`pixel_berry.png` pixel font for tiny labels** — pixel fonts categorically rejected by PROJECT.md (HD-only constraint).
- **Fixed Endesga32 palette for content** — LDtk's content palette is for tile-art use, not UI; not relevant to NeoCade theme.

**What's still open:**
- **Specific component API patterns** beyond the surface read (panel collapse behaviors, modal flow, dropdown reveal, multi-select interactions).
- **Color application rules from LDtk's `app.scss`** beyond the lines 1-24 already extracted by ARCHITECTURE.md.

**Confidence in coverage:** **MEDIUM**. The web docs were read at surface level. Deeper UI pattern mining lives in the source-code dossier below.

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

**What we adopted:**
- **Palette extraction informed Cabinet Chrome palette** — ARCHITECTURE.md Palette C uses `$bgDark` exactly (`#1E2229`) and tunes `$orange` to `#FFB020` for AA contrast; informed by real LDtk source values.
- **"Single warm signature accent against neutral ramp" discipline** — extracted from LDtk's palette structure (one orange, multi-stop neutral). Reflected in NeoCade's role-primary-dominance pattern.
- **"No glow effects, all elevation through tonal value" discipline** — extracted from observing LDtk's UI is precise because there's no ambiguity about which surface a thing sits on. Adopted as NeoCade's elevation-via-color philosophy (FEATURES.md DF-10, Conflict 3 resolution).
- **Confirmation that pixel-art tools ship sans-serif chrome fonts** — STACK.md cites this as evidence supporting Inter+Noto Sans over arcade flair fonts.

**What we rejected:**
- **Bitmap atlas font approach** — Godot 4.6 has mature dynamic TTF/VF rendering; Pitfall 5.4 forbids BMFont in v1.
- **`pixel_berry.png`** — pixel fonts categorically rejected.
- **Heaps-specific UI primitives** — NeoCade is a Godot Theme; LDtk's UI architecture is not directly portable.

**What's still open:**
- **`src/electron.renderer/` UI patterns end-to-end** — sidebar tinting implementation, layer panel chrome, tool-button conventions, modal flow, drag-and-drop UI, panel collapse behaviors, context menu patterns, status indicator rendering. The user's "must read all of it" mandate is **explicitly unsatisfied** by the initial pass.
- **`res/atlas/` UI atlas conventions** — what UI elements are atlased, how state transitions are encoded.
- **CHANGELOG end-to-end UI lessons** — what UI changes shipped in each version, what was reverted, what design decisions surfaced post-release.
- **Verification of user's prior research report's LDtk claims** (e.g. "uses Material Design SVG icons", "uses Endesga32 for level tiles") against actual source.

**Confidence in coverage:** **LOW**. Palette extraction is HIGH-confidence (real file, real values), but the "must read all of it" UI mining mandate is largely deferred. **What would raise it:** Phase 2 source-dive spike (per SUMMARY.md roadmap) — Haxe code reading of `src/electron.renderer/`, file-by-file UI pattern catalogue, CHANGELOG audit.

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

**What we adopted:**
- **"Vibrant arcade hall by day, NOT neon noir alley by night" mental model** — PROJECT.md Key Decision; reinforced by ARCHITECTURE.md Section 7.
- **Warm-neutral surface direction (Boardwalk Sunset)** — derived from the observation that real-arcade interior lighting is warm-coded (cabinet wood, painted booths, ticket-counter coral, marquee gold), not cool-coded (Tron-blue, computer-screen cyan). ARCHITECTURE.md Palette B.
- **Multi-hue accent palette discipline** — synthwave is two-color (cyan + magenta on dark); arcade is multi-color (orange + coral + teal + green). FEATURES.md DF-4 specifies 8 hues.
- **High-luminance saturation discipline** — ARCHITECTURE.md anti-cyberpunk rules require accents test ABOVE 60% lightness on dark surfaces (synthwave is below 50%, twilight-coded).
- **Dave & Buster's brand stack as reality check** — ARCHITECTURE.md Section 7: real arcade brands lean warm/orange-coded, not magenta/cyan synthwave-coded. Boardwalk Sunset's amber primary is anchored to this.
- **Explicit anti-cyberpunk rules** — ARCHITECTURE.md Section 7 lists 12 forbidden moves (chromatic aberration, scanlines, grid overlays, glow halos, drop-shadow on text, monospace body, pure-black surfaces, ALL CAPS body, sci-fi terminology, "TRANSMISSION"/"SYSTEM" labels, hex-grid backgrounds, fake circuitry).
- **Mockup-gate detection ritual** — "Could this be the menu screen of a Hotline Miami / Cyberpunk 2077 / Tron clone?" If yes → drift. (PITFALLS.md 7.1)

**What we rejected:**
- **User's prior research report claim "Synthwave/Vaporwave Vibe — references to 1980s-90s sci-fi (Tron, synth music)"** — explicitly forbidden by PROJECT.md. Tracked in Source 8 below.
- **Aesthetics-wiki Arcadecore palette suggestions** — wiki is broad; specific palette suggestions may include synthwave-adjacent hues. NeoCade scopes to Boardwalk Sunset / Cabinet Chrome / Midnight Marquee — three curated directions, not wiki-pick.
- **"Arcadecore" as a brand alignment** — too internet-aesthetic-coded; NeoCade aligns with real-place-arcade (Round1/D&B), not aesthetics-fandom-arcade.

**What's still open (significant gap):**
- **Curated mood-board of real reference photos** — interior shots of Round1, Dave & Buster's, Two Bit Circus, classic 80s halls (Pac-Man arcade cabinets, Galaga cabinets, Skee-Ball alleys, ticket booths, prize counters). Initial pass relied on **textual interpretation** of color brands and aesthetic-wiki entries, not photo-grade visual reference. PITFALLS.md 7.x detection rituals require side-by-side comparison against real photos at the mockup gate, but the photos haven't been collected yet.
- **Specific design-move inventory** — what does a "ticket-stub texture cue" actually look like in StyleBoxFlat terms? What is "booth chrome" in geometric terms? What is "marquee bulb" feel without a glow primitive? These need translation from photo to StyleBox spec.
- **Prize counter palette** — distinct from cabinet palette; teal/green-coded historically, not yet sampled.
- **Marquee typography** — real arcade marquees use bold-condensed sans (Metro Bold, Microgramma, Eurostile derivatives) — Outfit was proposed in Conflict 1 but the visual reference for "what marquee actually looks like" wasn't curated.

**Confidence in coverage:** **MEDIUM** for written articulation of arcade-vs-cyberpunk distinction; **LOW** for visual-reference grounding. **What would raise it:** Phase 3 mood-board sub-phase — collect ~20-30 high-res reference photos before mockup production; explicitly review them against the proposed palettes A/B/C.

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
| 2 | LDtk's UI uses "Material Design SVG icons" | **PARTIALLY VERIFY** | Initial pass did not open `src/electron.renderer/` to confirm; LDtk's `app.scss` palette extracted but icon source not directly verified. **Open** — Phase 2 source-dive spike addresses. |
| 3 | LDtk uses Endesga32 palette for level tiles | **TANGENTIAL — IRRELEVANT TO THEME** | Endesga32 is for tile-art content, not UI. NeoCade is a UI theme. Not adopted. |
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

## Pending — Source 10: CROSS-PLATFORM dimension

**Status:** Researcher in flight as of 2026-05-04. SOURCES.md will be amended with sources catalogued by the cross-platform research dimension before REQUIREMENTS.md is authored. Anticipated sources to be catalogued:
- Godot 4.6 export docs (Web, iOS, Android, desktop)
- iOS Human Interface Guidelines (Layout, Typography, Touch targets, Accessibility)
- Android Material 3 mobile guidance (Window size classes, Touch targets, Adaptive contrast)
- Godot GitHub issues filtered by export-target topics
- Real-device testing requirements per target

---

## Summary of Source-Dive Spike Recommendations

Of the nine sources catalogued above, four have HIGH or HIGH-MEDIUM coverage from the initial parallel research pass; the other five have explicit gaps that the roadmap-level spike phases must close:

| # | Source | Initial coverage | Spike phase recommended |
|---|---|---|---|
| 1 | godot-minimal-theme | MEDIUM (README only) | **Phase 1: `.tres` line-by-line dissection** |
| 2 | LDtk UI docs | MEDIUM | (Folded into Phase 2) |
| 3 | LDtk source code | LOW (palette only; "must read all" mandate unsatisfied) | **Phase 2: `src/electron.renderer/` UI mining** |
| 4 | Material Design 3 | HIGH | None needed |
| 5 | Real & virtual arcade aesthetics | MEDIUM (text) / LOW (visual) | **Phase 3 sub-spike: real-arcade reference photo collection** |
| 6 | Godot Theme docs | HIGH | None needed (re-verify via Context7 at each phase per user's global rule) |
| 7 | Godot controls gallery | MEDIUM-HIGH | (Folded into Phase 8 showcase implementation) |
| 8 | NeoCade-Research-Report.md | HIGH (audited) | None — correctly bounded as "challenged reference" |
| 9 | NeoCade-Theme-Prototype.png | HIGH (critiqued) | (Comparison surfaced at Phase 3 mockup gate) |
| 10 | CROSS-PLATFORM (pending) | PENDING | Will produce its own spike-phase recommendations |

Additional spike recommendations not tied to a specific source:
- **MCP/QA tooling baseline spike** (UD-1 + GoPeak smoke test) — necessary infrastructure for Phase 9 QA harness.
- **Accessibility QA phase** — focus stylebox audit + CVD simulation + screen-reader sanity test. Phase 9 sub-phase.
- **Dual-renderer screenshot pass** (Forward+ vs GL Compatibility) — Phase 9 sub-phase.
- **Fresh-install dry-run** — pre-Asset-Library submission. Phase 9 sub-phase.
- **Cross-platform validation phase** (pending CROSS-PLATFORM researcher findings).
- **Mobile variant authoring phase** (pending CROSS-PLATFORM researcher findings).

---

*Source coverage dossier authored: 2026-05-04*
*Last updated: 2026-05-04*
*Update policy: append per-source updates with date+phase reference as roadmap-level spike phases produce deeper findings.*
