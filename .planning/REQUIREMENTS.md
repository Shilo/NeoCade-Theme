# Requirements: NeoCade Theme

**Defined:** 2026-05-04
**Core Value:** A drop-in Godot 4.6 dark Theme resource that styles every built-in user-facing Control to a `godot-minimal-theme` bar of feature-completeness, with an arcade-inspired neon visual identity that is colorful, professional, accessible, and universal across editor + runtime + all 6 Godot export targets, distributed as a single addon at `res://addons/neocade_theme/`, with a sibling `neocade_mobile_theme.tres` mobile-tuned variant.

> **Authoritative inputs:** PROJECT.md (constraints + hard rules), `.planning/research/SUMMARY.md` (synthesis + Conflict resolutions + 11-phase plan + UD-1..6), `.planning/research/FEATURES.md` (35-class coverage matrix + 13 type variations + anti-features), `.planning/research/CROSS-PLATFORM.md` (mobile spec + per-target validation), `.planning/research/PITFALLS.md` (10 categories of gotchas + prevention), `.planning/research/EDITOR-COVERAGE.md` (themed-vs-default editor surfaces), `.planning/research/SOURCES.md` (per-source dossier).

## v1 Requirements

Requirements for initial release. Each REQ-ID maps to exactly one phase in ROADMAP.md.

### Research & Spike (RES)

- [ ] **RES-01**: Phase 1 source-dive spike produces line-by-line dissection of `passivestar/godot-minimal-theme` `.tres` (per-Control × per-state entry enumeration; interaction state transforms; popup/window theming patterns). Findings appended to SOURCES.md.
- [ ] **RES-02**: Phase 2 source-dive spike mines LDtk source code under `C:\Programming_Files\ldtk-master\src\electron.renderer\` for UI implementation patterns (sidebar tinting, layer panel chrome, tool-button conventions, modal flow, panel collapse, context menus, status indicators); appended to SOURCES.md.
- [ ] **RES-03**: Phase 3 sub-spike produces a curated mood-board of 20-30 high-resolution real-arcade interior reference photos (Round1 / Dave & Buster's / Two Bit Circus / classic 80s halls / cabinet imagery / ticket booth / prize counter / marquee). Saved to `.planning/research/mood-board/`.
- [ ] **RES-04**: Phase 3 sub-spike resolves UD-1 (MCP server swap to GoPeak) with a hands-on smoke test capturing a Godot editor screenshot via `npx gopeak` and verifying input-injection works. Outcome documented; if approved, project's MCP config switches.
- [ ] **RES-05**: Phase 11 distribution sub-research re-verifies current Godot Asset Library submission policy via Context7 MCP at submission time (do NOT rely on training-data docs). Findings noted in distribution package.

### Design Mockups & Approval Gate (DESIGN)

- [ ] **DESIGN-01**: Phase 3 produces 3 HTML/SVG palette mockups in `.planning/mockups/` showing surface ramp + accent palette + sample Controls for each of the 3 candidate palettes (A: Midnight Marquee, B: Boardwalk Sunset recommended, C: Cabinet Chrome). User selects one at Step 1 approval.
- [ ] **DESIGN-02**: Phase 3 produces 2 typography mockups exploring Inter-only (no Outfit) vs Inter+Outfit display (recommended per Conflict 1 revision). User selects one at Step 2 approval.
- [ ] **DESIGN-03**: Phase 3 produces 1 full-fidelity desktop Control gallery HTML mockup showing every Godot Control class with realistic content, all states visible, ~1500 lines HTML+CSS. Approved by user at Step 3.
- [ ] **DESIGN-04**: Phase 3 produces 1 mobile-variant mockup (per ARCHITECTURE Section 6 Step 5b) showing the same Controls at mobile sizes (360×800 + 768×1024 viewports) with tap-target overlays visible (≥48px); approved together with DESIGN-03.
- [ ] **DESIGN-05**: `DESIGN_TOKENS.md` finalized with both desktop and mobile token blocks (color tokens, typography scale, spacing scale, corner radius scale, stroke widths, elevation/surface ramp, interaction state opacities). Committed before any `.tres` styling work begins.
- [ ] **DESIGN-06**: Mockup approval gate is an explicit blocker — no `.tres` styling commits until approved. Maximum 3 revision rounds; if not approved by round 3, escalation discussion before proceeding.

### Theme Foundation (FOUND)

- [ ] **FOUND-01**: `addons/neocade_theme/` directory layout: `fonts/`, `icons/`, `_dev/` subdirs; root contains `neocade_theme.tres`, `neocade_mobile_theme.tres`, `OFL.txt`, `LICENSE.md`, `README.md`, `CHANGELOG.md`. No `plugin.cfg` (per STACK Decision 5).
- [ ] **FOUND-02**: `addons/neocade_theme/_dev/generate_themes.gd` is a `@tool` script that produces both `neocade_theme.tres` and `neocade_mobile_theme.tres` from a single `TokenSet` constants block + `TokenSet.mobile` overrides. Single source of truth; drift structurally impossible (per CROSS-PLATFORM 4.2).
- [ ] **FOUND-03**: Initial run of `generate_themes.gd` produces empty-but-valid `.tres` scaffolds with all theme types declared (35 user-facing Control classes + Window + tooltip types + 13 type variations).

### Fonts (FONT)

- [ ] **FONT-01**: Inter Variable upright (`Inter-Variable.ttf` from Inter v4.x, OFL 1.1) bundled at `addons/neocade_theme/fonts/Inter-Variable.ttf`. Reserved Font Name preserved (file NOT renamed); imported as `FontFile.tres` referenced by `uid://`.
- [ ] **FONT-02**: Outfit Variable (OFL 1.1) bundled as the v1 display/marquee font (per SUMMARY Conflict 1 revision; replaces Inter Italic for v1). Reserved Font Name preserved; imported as `FontFile.tres`.
- [ ] **FONT-03**: Noto Sans Variable (Latin-extended, OFL 1.1) bundled as the multi-script fallback. Reserved Font Name preserved.
- [ ] **FONT-04**: JetBrains Mono Variable (OFL 1.1) bundled as the code/monospace font (used by CodeEdit and code-related label variations).
- [ ] **FONT-05**: Combined `OFL.txt` lists Reserved Font Name notice + copyright block per font (Inter + Outfit + Noto Sans + JetBrains Mono). Surfaced in README install instructions for downstream projects to embed in their About/Credits.
- [ ] **FONT-06**: Theme `default_font` is Inter Variable upright; `default_font.fallbacks` order: Inter → Noto Sans Variable. Outfit assigned to type variations (HeaderLarge / HeaderMedium / HeaderSmall) only.
- [ ] **FONT-07**: Italic emphasis falls back to synthetic transform on Inter upright (Inter Italic deferred to v1.x per Conflict 1 revision). Body text rendering is acceptable; documented limitation in CHANGELOG.
- [ ] **FONT-08**: Font import settings: Grayscale antialiasing, Light hinting, Auto subpixel positioning (per STACK + PITFALLS 5.5; verified for GL Compatibility renderer).
- [ ] **FONT-09**: CJK is NOT bundled in v1 (per UD-2 default); README documents the override pattern for consumers who need it: duplicate theme + append CJK font to `default_font.fallbacks`.

### Icons (ICON)

- [ ] **ICON-01**: ~25-40 bespoke SVG icons authored at 32×32 reference, imported with `Scale = 2.0` and `Linear With Mipmaps` filter explicitly set per resource. Stored at `addons/neocade_theme/icons/`.
- [ ] **ICON-02**: Icon coverage maps 1:1 to Godot's hard-coded theme icon slots: Button check / radio / toggle / arrow_down / clear / close; OptionButton arrow; CheckBox/CheckButton on/off; Tree expand/collapse; TabBar/TabContainer increment/decrement/menu; ColorPicker preset/screen-pick/sample-bg/recent; FileDialog parent/folder/file/file-up/back/forward/reload; ScrollBar increment/decrement/grabber. Per FEATURES.md icon coverage list.
- [ ] **ICON-03**: Icons are monochrome SVGs (single-color or with a small fixed accent palette mapped via Godot's icon `modulate` rather than baked color); allows tinting per accent role.
- [ ] **ICON-04**: NO bundled Material Symbols / Lucide / Phosphor / external icon library (per STACK "What NOT to Use"). Texture2D-per-slot mismatch + bundle size cost.

### Design System Tokens (TOKEN)

- [ ] **TOKEN-01**: Color token system: 5-stop M3 tonal surface ramp (`surface` / `surface-container-low` / `surface-container` / `surface-container-high` / `surface-container-highest`) with friendlier aliases (base / secondary / panel / raised / overlay) per SUMMARY Conflict 2.
- [ ] **TOKEN-02**: 8-hue accent palette + semantic role aliases (`role.primary` → chosen accent, `role.success`, `role.warning`, `role.danger`, `role.info`, plus decorative accents).
- [ ] **TOKEN-03**: 3 text colors (`text.strong` / `text.default` / `text.muted`) verified WCAG 2.1 AA against every surface stop.
- [ ] **TOKEN-04**: `surface.sunken` token is REJECTED for v1 (per SUMMARY Conflict 2); inputs distinguished via focus/normal stylebox + corner radius.
- [ ] **TOKEN-05**: 4-rung corner radius scale: `radius.none=0` / `radius.sm=4` / `radius.md=8` / `radius.lg=12`. Default 4px (godot-minimal-theme parity); 8px on PopupPanel/Window; 12px on dialogs.
- [ ] **TOKEN-06**: 8-step spacing scale: `space.0` through `space.8` (4px base scale: 0/4/8/12/16/24/32/48 — desktop). Mobile overrides: +50% on `space.4` and above.
- [ ] **TOKEN-07**: Stroke width set: 1px hairline default; 2px focus rings; 3px reserved for danger emphasis. Integer pixels only (no fractional widths under GL Compatibility).
- [ ] **TOKEN-08**: Elevation model: color-only (tonal surface ramp). NO drop shadows in v1 (per SUMMARY Conflict 3 + FEATURES AF-13 + GL Compatibility issue #23640). Optional 1px lighter top-bevel border allowed on raised buttons.
- [ ] **TOKEN-09**: Interaction state system uses M3 deterministic state-layer model: hover 8% overlay, focus 12% overlay + 2px outer ring in `role.primary`, pressed 12% overlay, dragged 16% overlay, disabled 38% text / 12% container. Reproducible from any base color.
- [ ] **TOKEN-10**: Type scale spine (M3-derived): display-small 36 (Outfit) / headline-small 24 (Outfit) / title-large 20 (Outfit) / title-medium 16 (Inter) / body-large 16 (Inter) / body-medium 14 (Inter) / body-small 12 (Inter) / label-large 14 (Inter) / label-small 11 (Inter) / code 13 (JetBrains Mono).

### Control Coverage (COV)

- [ ] **COV-01**: All 35 user-facing Godot 4.6 Control classes are themed in v1 with full state coverage (normal/hover/pressed/focused/disabled where applicable). Per FEATURES.md Section 1.
- [ ] **COV-02**: 7 BaseButton family classes themed: Button, CheckBox, CheckButton, OptionButton, MenuButton, ColorPickerButton, LinkButton. (Note: Editor-only FlatButton/FlatMenuButton/MainScreenButton/BottomPanelButton deferred to v1.x.)
- [ ] **COV-03**: 5 text input/display classes themed: Label, RichTextLabel, LineEdit, TextEdit, CodeEdit. Caret + selection + placeholder colors configured. CodeEdit gutter (line numbers, breakpoint glyph, fold arrow) styled; syntax highlighting NOT in scope (per FEATURES AF-7).
- [ ] **COV-04**: All range controls themed: HSlider, VSlider, ProgressBar, HScrollBar, VScrollBar, SpinBox.
- [ ] **COV-05**: All list/tree controls themed: ItemList, Tree (16 styleboxes + 12 icons + ~26 constants — half-day work alone), TabBar, TabContainer, FoldableContainer.
- [ ] **COV-06**: All popup-class controls themed as separate first-class types (per PITFALLS 1.7 — popups are separate Windows that don't inherit overrides): PopupPanel, PopupMenu, AcceptDialog, ConfirmationDialog, FileDialog, TooltipPanel, TooltipLabel, Window.
- [ ] **COV-07**: Container-level controls themed (where chrome applies): Panel, PanelContainer, ScrollContainer, SplitContainer, MarginContainer constants. Layout-only Containers (HBox/VBox/Flow/Grid/Center) get separation constants only (per FEATURES AF-11).
- [ ] **COV-08**: Advanced controls themed (basic v1 level): MenuBar, ColorPicker (16 bespoke icons), GraphEdit + GraphNode + GraphFrame.
- [ ] **COV-09**: Visible focus indicator on every focusable Control (WCAG 2.1 SC 1.4.11): 2px outer ring in `role.primary`, drawn outside corner radius bounds, NOT replaceable by hover/pressed/checked styleboxes (per PITFALLS 1.1 focus-overlay-not-state behavior).
- [ ] **COV-10**: Zero theme entries left default (engine fallback) for any Control class enumerated in COV-01..08; verified against `godot-minimal-theme` `.tres` enumeration produced in RES-01.

### Type Variations (TYPEVAR)

- [ ] **TYPEVAR-01**: 6 Button type variations: PrimaryButton, SecondaryButton, GhostButton, DangerButton, IconButton, FlatButton (role-semantic naming, not fill-semantic).
- [ ] **TYPEVAR-02**: 5 Label type variations: HeaderLarge (Outfit display-small), HeaderMedium (Outfit headline-small), HeaderSmall (Outfit title-large), Caption (Inter body-small), CodeLabel (JetBrains Mono code).
- [ ] **TYPEVAR-03**: 1 RichTextLabel type variation: InfoText.
- [ ] **TYPEVAR-04**: 2 Panel type variations: CardPanel, HeroPanel.
- [ ] **TYPEVAR-05**: Fonts set explicitly on every type variation (per PITFALLS 1.2 — type variations DO NOT inherit fonts from base type, even when stylebox inheritance works). Verify under runtime QA, not editor preview.
- [ ] **TYPEVAR-06**: All 13 type variations are documented in `MOBILE-DESIGN-SPEC.md` and `DESIGN_TOKENS.md` with concrete usage examples.

### Mobile Variant (MOBILE)

- [ ] **MOBILE-01**: `addons/neocade_theme/neocade_mobile_theme.tres` ships in v1 alongside the desktop primary, generated from `_dev/generate_themes.gd` `TokenSet.mobile` overrides.
- [ ] **MOBILE-02**: Tap targets ≥48px (Godot pixels at base scale 1.0) on every interactive Control in the mobile theme. Satisfies iOS HIG 44pt minimum + Material 3 48dp minimum simultaneously.
- [ ] **MOBILE-03**: Body text 16px on mobile vs 14px desktop. Headings retain Outfit display sizes (no scale change for headings).
- [ ] **MOBILE-04**: Spacing scale +50% on `space.4` and above on mobile. Corner radii STAY IDENTICAL across desktop/mobile (brand identity, not platform-specific).
- [ ] **MOBILE-05**: One mobile theme covers all Android density buckets (per CROSS-PLATFORM 3.5; Godot uses `content_scale_factor` + stretch modes, NOT density qualifiers). Authored values are dp-equivalent at base scale 1.0.
- [ ] **MOBILE-06**: Tap-target audit script confirms every interactive Control in mobile theme is ≥48px; runs as part of Phase 8 acceptance.
- [ ] **MOBILE-07**: `MOBILE-DESIGN-SPEC.md` documents every delta vs desktop with concrete numbers + rationale.
- [ ] **MOBILE-08**: Mobile theme follows iOS HIG + Material 3 mobile guidance loosely (touch targets, type scale, accessibility minima) but retains the NeoCade arcade visual identity. NOT making Godot UI look native iOS or Android.

### Showcase Scene (SHOW)

- [ ] **SHOW-01**: `res://main.tscn` is the showcase scene; applied as project main scene. Uses NeoCade Theme as project theme (or per-scene `theme` override if leak avoidance preferred).
- [ ] **SHOW-02**: Showcase scene contains 9 sections covering all 35 Control classes + Token Gallery + Coverage Verification: Buttons / Text Inputs / Numbers & Range / Selection & Lists / Containers & Layout / Dialogs & Popups / Advanced & Graph / Token Gallery / Coverage 35/35.
- [ ] **SHOW-03**: Realistic sample content per Control (Tree with multi-level items, ItemList with options, OptionButton with multiple options, etc.) per PITFALLS 10.1 — empty controls render invisibly.
- [ ] **SHOW-04**: Three-way prominent floating theme toggle button: NeoCade desktop ↔ NeoCade mobile ↔ Godot default. Bigger than other controls so its purpose is obvious. Toggles via inline `theme_overrides` (per PITFALLS 10.3 — clean state switching).
- [ ] **SHOW-05**: BBCode demo in RichTextLabel section showcasing inline color/weight/italic.
- [ ] **SHOW-06**: `accessibility_name` set on every interactive Control in showcase (per PITFALLS 2.5 + 4.4 — minimum bar for screen-reader sanity in v1).
- [ ] **SHOW-07**: Token Gallery section displays each design token visually (color swatches with hex + role label, type scale samples, spacing/radius scale visualizations).
- [ ] **SHOW-08**: Coverage Verification strip displays "35/35 Controls themed ✓" or accurate count if any deferred.

### Cross-Platform Export (EXPORT)

- [ ] **EXPORT-01**: Theme exports correctly to all 6 Godot 4.6 export targets: Windows, macOS, Linux, iOS, Android, Web/Browser.
- [ ] **EXPORT-02**: Per-target screenshot deck produced in `.planning/qa/exports/<target>/` showing showcase scene rendering on each target. Acceptance: render-correctness, not pixel-parity (iOS Safari WebGL2 quirks documented).
- [ ] **EXPORT-03**: Web/Browser export specifics handled: `.ttf` files added to "Filters to export non-resources" OR wrapped in saved `FontFile.tres`; all theme/font/icon resources referenced by `uid://`; no `SystemFont` resource (silently fails on Web per CROSS-PLATFORM 2.2).
- [ ] **EXPORT-04**: Project remains on GL Compatibility renderer (per CROSS-PLATFORM TL;DR Decision 1; avoids Godot 4.6 regressions #116090 iOS Mobile and #111729 Android Mobile).
- [ ] **EXPORT-05**: CI workflow exports + smoke-tests on Windows + Linux + macOS + Web targets (desktop runners + headless Web export).
- [ ] **EXPORT-06**: Manual Android validation on at least 1 device (low / mid / high end if 3 devices available; or "deferred to v1.0.1" with explicit changelog note per UD-5).
- [ ] **EXPORT-07**: Manual iOS validation on at least 1 device (requires Mac + paid Apple Developer Program; or "deferred to v1.0.1" with explicit changelog note per UD-5).
- [ ] **EXPORT-08**: License compliance verified: all 4 bundled fonts (Inter / Outfit / Noto Sans / JetBrains Mono) are OFL 1.1 — App Store + Play Store + Web embedding all legal. Reserved Font Name clauses preserved (no binary renames).

### Accessibility (A11Y)

- [ ] **A11Y-01**: WCAG 2.1 AA contrast verified for every text-on-surface combo and every interactive state combination. Computed via W3C luminance formula; reproducible from token values.
- [ ] **A11Y-02**: Visible focus indicator on every focusable Control (covers SC 2.4.7 + SC 1.4.11). Drawn as 2px outer ring outside `corner_radius` so it doesn't lose to pressed/checked replacement styleboxes (PITFALLS 1.1).
- [ ] **A11Y-03**: No information conveyed by color alone. Status states (success/warning/danger) include icon + text label + color cue.
- [ ] **A11Y-04**: Color-blindness verification pass: showcase rendered through deuteranopia, protanopia, tritanopia simulation; legibility confirmed for status/role colors.
- [ ] **A11Y-05**: Multi-script label test: Latin / Cyrillic / Arabic / Hebrew / Devanagari labels render correctly via `default_font.fallbacks` chain through Inter + Noto Sans.
- [ ] **A11Y-06**: `accessibility_name` set on every interactive Control in showcase (Godot 4.5 API, partial AccessKit integration in 4.6). Deeper screen-reader QA (VoiceOver/TalkBack) deferred to v1.x per UD-6.

### QA & Visual Regression (QA)

- [ ] **QA-01**: MCP/QA tooling baseline: Phase 10 sub-spike validates the chosen MCP server (UD-1: GoPeak recommended) end-to-end — capture editor screenshot, capture running-game screenshot, inject input.
- [ ] **QA-02**: Full visual QA matrix: 9 showcase sections × 2 renderers (Forward+ + GL Compatibility) × 3 resolutions (1080p / 1440p / 4K) × 3 scale factors (100% / 150% / 200%). Output: `.planning/qa/screenshots/`.
- [ ] **QA-03**: Tab-walk every Control in showcase + capture focused-state screenshot. Verify focus ring visibility under hover/pressed/checked combinations.
- [ ] **QA-04**: Dual-renderer screenshot pass: theme authored on GL Compatibility (project lock); also rendered on Forward+ for comparison; deltas documented but not fixed (GL Compat is the ship target).
- [ ] **QA-05**: Fresh-install dry-run: clone the addon into a clean Godot project; verify `addons/neocade_theme/` works without modifications; theme applies as both project theme and per-scene theme; fonts and icons load correctly.
- [ ] **QA-06**: Theme inspector workaround: per PITFALLS 4.6 active issue #115500, do NOT edit theme via Control inspector context — author via dedicated Theme tab + `@tool` generator only. Documented in CONTRIBUTING.md.

### Distribution (DIST)

- [ ] **DIST-01**: Asset Library submission package complete: square 128×128 PNG icon URL; README with both install paths (project theme + per-scene theme + optional editor theme); license attributions surfaced; "not an editor plugin" note; editor-leak caveat (per PITFALLS 2.2 + EDITOR-COVERAGE.md).
- [ ] **DIST-02**: Combined `OFL.txt` covers all bundled fonts (Inter + Outfit + Noto Sans + JetBrains Mono) with each font's Reserved Font Name notice block + copyright lines.
- [ ] **DIST-03**: `LICENSE.md` for theme code (recommend MIT or CC-BY) + initial `CHANGELOG.md` entry for v1.0.0.
- [ ] **DIST-04**: README documents: install paths (project theme / per-scene theme / editor theme); CJK override pattern (UD-2); editor-coverage map link (EDITOR-COVERAGE.md); cross-platform support summary; mobile variant usage.
- [ ] **DIST-05**: Asset Library current submission policy verified via Context7 MCP at submission time (NOT training data); RES-05 closes this.

### Documentation (DOCS)

- [ ] **DOCS-01**: `DESIGN_TOKENS.md` is committed before Phase 4 begins (FOUND-02 dependency); contains finalized desktop + mobile token blocks, sourced from approved Phase 3 mockups.
- [ ] **DOCS-02**: `MOBILE-DESIGN-SPEC.md` documents every mobile delta vs desktop with concrete numbers + rationale (MOBILE-07 deliverable).
- [ ] **DOCS-03**: `EDITOR-COVERAGE.md` (already exists; per MAJ-7 review finding) maps which Editor surfaces are themed in v1 vs which fall back to default.
- [ ] **DOCS-04**: README.md is comprehensive: project description, install paths, usage examples, cross-platform notes, accessibility notes, license, attributions, link to GitHub repo.
- [ ] **DOCS-05**: SOURCES.md is updated by Phase 1, 2, 3 source-dive spike outputs (RES-01..03) with new findings.

## v2 Requirements

Deferred to future release. Tracked but not in v1 roadmap.

### Light Mode

- **LIGHT-01**: Light color mode for desktop theme (`neocade_theme_light.tres`)
- **LIGHT-02**: Light color mode for mobile theme (`neocade_mobile_theme_light.tres`) — IF mobile-light is in v2 scope (per PROJECT.md note that mobile-light may stay deferred even in v2)

### Alternate Palettes

- **PALETTE-01**: Magenta-led alternate palette variant (`neocade_neon_magenta.tres`)
- **PALETTE-02**: Amber-led alternate palette variant (`neocade_amber.tres`)
- **PALETTE-03**: Mobile counterparts for each alternate palette

### Editor Parity

- **EDITORV1X-01**: Editor-only theme types styled (FlatButton, FlatMenuButton, MainScreenButton, BottomPanelButton, EditorInspector*, EditorProperty*) for full Godot Editor parity when applied as editor theme
- **EDITORV1X-02**: EDITOR-COVERAGE.md updated with the new themed surfaces

### Typography Polish

- **TYPOV1X-01**: Inter Italic Variable bundled (replaces synthetic italic transform from v1)
- **TYPOV1X-02**: CJK Noto Sans bundling decision (full bundle, ~30 MB, vs documented opt-in)

### Accessibility v1.x

- **A11YV1X-01**: Deeper VoiceOver/TalkBack/AccessKit screen-reader QA on showcase (currently `accessibility_name` only in v1)
- **A11YV1X-02**: User-customizable contrast preset (high-contrast variant)

### Future Features

- **FUTURE-01**: Theme animation system (would require GDScript on every Control — out of pure-Theme scope; explicit v2+ if pursued)
- **FUTURE-02**: CodeEdit syntax-highlight color presets (orthogonal to theme; v2+ as separate addon)

## Out of Scope

Explicitly excluded. Documented to prevent scope creep.

| Feature | Reason |
|---------|--------|
| Cyberpunk / synthwave / vaporwave / scanline / neon-noir aesthetics | Hard PROJECT.md constraint — explicitly anti-arcade |
| Pixel fonts (any UI element) | HD-only constraint |
| Glow halos on focus, hover, pressed, or any other state | StyleBoxFlat can't render natively; reads as synthwave |
| Drop shadows in v1 | GL Compatibility over-renders alpha (Godot #23640); ghosted-clone artifact |
| `surface.sunken` token | Depth-via-color-only philosophy; inputs distinguished via stylebox + radius (Conflict 2 resolution) |
| `StyleBoxTexture` for default chrome | HD scaling problem (FEATURES AF-12) |
| Custom shaders for control rendering | Pure Theme/StyleBox primitives only |
| GDExtension / native code | Pure Godot Theme resource |
| `EditorPlugin` script + `plugin.cfg` | Pure Theme addon, not an editor plugin |
| `SystemFont` fallback | Defeats consistent-rendering promise; fails silently on Web |
| Bundled Material Symbols / Lucide / Phosphor icon libraries | Texture2D-per-slot mismatch + bundle size cost |
| Sound effects bundled with theme | Theme is visual only; PROJECT.md explicit |
| Localized strings | Theme styles UI; localization is consumer responsibility |
| Per-platform native fonts (system font on macOS, Segoe UI on Windows) | Defeats bundled-fonts requirement |
| CodeEdit syntax-highlight color schemes | Not a theme entry; per-language; consumer-side |
| Theme-bundled animations beyond Godot built-in StyleBox transitions | Godot Theme has no animation primitives |
| Per-Container-subclass distinct theming (HBox≠VBox visual styling) | Layout-only Containers have no chrome; waste of effort |
| Per-density-bucket mobile theme files (`mdpi.tres`, `hdpi.tres` etc.) | Godot doesn't use Android density qualifiers; one mobile theme covers all via `content_scale_factor` |
| Mobile renderer (Vulkan/Metal) on iOS or Android in 4.6 | GL Compatibility avoids Godot 4.6 regressions #116090 + #111729; do NOT switch |
| Material You dynamic Android color theming | NeoCade ships fixed palettes; alt-palettes are explicit forks (v2) |
| Native iOS/Android system look | Mobile variant adopts iOS HIG + Material 3 minimums (tap targets, type scale, a11y), not visual language |
| Pixel-parity expectation across export targets | Render-correctness is the bar; iOS Safari WebGL2 has documented quirks |
| Theme name "VirtuCade" / "CyberCade" / "SynthWave UI" / "NeonCade" / etc. | Locked as **NeoCade** |

## Traceability

Phase mapping per SUMMARY.md's 11-phase plan. Updated when ROADMAP.md is created.

| Requirement | Phase | Status |
|-------------|-------|--------|
| RES-01 | Phase 1 (Source-Dive: godot-minimal-theme) | Pending |
| RES-02 | Phase 2 (Source-Dive: LDtk source) | Pending |
| RES-03 | Phase 3 (Mockup phase sub-spike) | Pending |
| RES-04 | Phase 3 (MCP tooling baseline sub-spike) | Pending |
| RES-05 | Phase 11 (Distribution sub-research) | Pending |
| DESIGN-01..06 | Phase 3 (Visual Direction Mockup) | Pending |
| FOUND-01..03 | Phase 4 (Foundation) | Pending |
| FONT-01..09 | Phase 4 (Foundation) | Pending |
| ICON-01..04 | Phase 4 (Foundation) | Pending |
| TOKEN-01..10 | Phase 3 (DESIGN-05) + Phase 4 (FOUND-02 generator) | Pending |
| COV-01 | Phase 5 + 6 + 7 (cumulative) | Pending |
| COV-02 | Phase 5 (Core Controls) | Pending |
| COV-03 | Phase 5 (Core Controls) | Pending |
| COV-04 | Phase 6 (Lists/Layout/Range) | Pending |
| COV-05 | Phase 6 (Lists/Layout/Range) | Pending |
| COV-06 | Phase 7 (Dialogs/Popups/Advanced) | Pending |
| COV-07 | Phase 5/6/7 cumulative | Pending |
| COV-08 | Phase 7 (Dialogs/Popups/Advanced) | Pending |
| COV-09 | Phase 5..7 cumulative; verified Phase 10 | Pending |
| COV-10 | Phase 10 verification (RES-01 dependency) | Pending |
| TYPEVAR-01..06 | Phase 5 + 6 | Pending |
| MOBILE-01..08 | Phase 8 (Mobile Variant Authoring) | Pending |
| SHOW-01..08 | Phase 9 (Showcase) | Pending |
| EXPORT-01..08 | Phase 10 (QA + Cross-Platform Export Validation) | Pending |
| A11Y-01..06 | Phase 10 (Accessibility QA sub-phase) | Pending |
| QA-01..06 | Phase 10 | Pending |
| DIST-01..05 | Phase 11 (Distribution) | Pending |
| DOCS-01 | Phase 3 (DESIGN-05 dependency) | Pending |
| DOCS-02 | Phase 8 (MOBILE-07 dependency) | Pending |
| DOCS-03 | Already created (EDITOR-COVERAGE.md exists) | Complete |
| DOCS-04 | Phase 11 (DIST-04 dependency) | Pending |
| DOCS-05 | Phase 1 + 2 + 3 (continuous update) | Pending |

**Coverage:**
- v1 requirements: 88 total
- Mapped to phases: 88
- Unmapped: 0 ✓

---
*Requirements defined: 2026-05-04*
*Last updated: 2026-05-04 after research synthesis + independent review reconciliation*
*Next update trigger: ROADMAP.md authoring; phase plans may surface additional requirements or move some to v1.x*
