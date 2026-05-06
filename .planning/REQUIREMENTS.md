# Requirements: NeoCade Theme

**Defined:** 2026-05-04
**Core Value:** A drop-in Godot 4.6 flat-MD3/MD3-Expressive Theme system that styles every built-in user-facing Control to a `godot-minimal-theme` bar of feature-completeness, with a colorful, professional, accessible arcade identity and universal editor + runtime + all-6-export-target support. v1 ships one concrete `NeoCadeTheme` class at `res://addons/neocade_theme/neocade_theme.gd` plus 5 data-only direction `.tres` resources at the addon root (`pulse`, `slate`, `bubble`, `daybreak`, `burst`); mobile is an `@export platform=MOBILE` mode on the same resources, not a sibling `neocade_mobile_theme.tres`.

> **Authoritative inputs:** PROJECT.md (constraints + hard rules), `.planning/ROADMAP.md` (15-phase redirected roadmap), `.planning/research/SUMMARY.md` (original synthesis + Conflict resolutions + UD-1..6; superseded where later Phase 3.x artifacts explicitly say so), `.planning/research/FEATURES.md` (35-class coverage matrix + 13 type variations + anti-features), `.planning/research/MINIMAL-THEME-COVERAGE-DELTA.md` (37-row scorecard reconciliation), `.planning/research/CROSS-PLATFORM.md` (mobile spec + per-target validation), `.planning/research/PITFALLS.md` (10 categories of gotchas + prevention), `.planning/research/EDITOR-COVERAGE.md` (themed-vs-default editor surfaces), `.planning/research/SOURCES.md` (per-source dossier).

## v1 Requirements

Requirements for initial release. Each REQ-ID maps to exactly one primary phase in ROADMAP.md (some are cumulative across multiple phases — see Traceability section).

### Research & Spike (RES)

- [x] **RES-01**: Phase 1 source-dive spike produces line-by-line dissection of `passivestar/godot-minimal-theme` `.tres` (per-Control × per-state entry enumeration; interaction state transforms; popup/window theming patterns). Findings appended to SOURCES.md.
- [x] **RES-02**: Phase 2 source-dive spike mines LDtk source code under `C:\Programming_Files\ldtk-master\src\electron.renderer\` for UI implementation patterns (sidebar tinting, layer panel chrome, tool-button conventions, modal flow, panel collapse, context menus, status indicators); appended to SOURCES.md.
- [x] **RES-03**: Phase 3 sub-spike produces a curated mood-board of 20-30 high-resolution real-arcade interior reference photos (Round1 / Dave & Buster's / Two Bit Circus / classic 80s halls / cabinet imagery / ticket booth / prize counter / marquee). Saved to `.planning/research/mood-board/`.
- [x] **RES-04**: Phase 3 sub-spike resolves UD-1 by verifying GoPeak is runnable, documenting that it is not active in Codex's current MCP tool surface, proving Godot launch/debug plus a repeatable screenshot fallback, and deferring direct GoPeak screenshot/input-injection validation to QA-01 in Phase 10.
- ~~[ ] **RES-05**: Asset Library policy re-verification~~ — **STRICKEN 2026-05-04 per Phase 11 revision.** No Asset Library submission in v1; distribution is GitHub Releases via GitHub Actions workflow only.

### Design Mockups & Approval Gate (DESIGN)

- [x] **DESIGN-01** *(superseded by Phase 3 redirect, preserved historically)*: Phase 3 v0 produced palette/direction artifacts in `.planning/mockups/`; user rejected the painterly direction and the requirement was replaced by Phase 3.3's approved five dark flat-MD3 directions plus Phase 3.4 Stage 1 concept boards.
- [x] **DESIGN-02** *(superseded by UD-4 Option D, preserved historically)*: Typography gate resolved to Inter Variable Roman only in v1; Outfit, Inter Italic, Noto Sans, and JetBrains Mono are deferred/consumer-side.
- [ ] **DESIGN-03** *(now Phase 3.4 Plan 03, in progress)*: Full-fidelity Pulse 4-grid HTML mockup shows the implementation-priority direction across flat desktop, flat mobile, raised desktop, and raised mobile with realistic Control content and required state combinations. Approved by user at the Phase 3.4 final approval checkpoint.
- [ ] **DESIGN-04** *(now Phase 3.4 Plan 03, in progress)*: Mobile mockup evidence is included in the Pulse 4-grid with mobile sizing/tap-target audit notes; approved together with DESIGN-03.
- [ ] **DESIGN-05** *(Phase 3.4 Plan 04)*: `DESIGN_TOKENS.md` finalized with desktop/mobile, flat/raised, and per-direction data-resource token blocks (color tokens, typography scale, spacing scale, corner radius/shape values, stroke widths, elevation/surface ramp, interaction state opacities). Committed before any addon `.tres`/`.gd` styling work begins.
- [x] **DESIGN-06**: Mockup approval gate is an explicit blocker — no `.tres` styling commits until approved. Maximum 3 revision rounds; if not approved by round 3, escalation discussion before proceeding.

### Theme Foundation (FOUND)

- [ ] **FOUND-01** *(rewritten 2026-05-06e for single-class data-driven architecture; supersedes prior versions)*: `addons/neocade_theme/` directory layout: `fonts/` and `icons/` subdirs (preserved for asset organization); addon root contains exactly **1 `.gd` file** (`neocade_theme.gd` — `@tool class_name NeoCadeTheme extends Theme`, concrete and instantiable, NOT abstract), **N `.tres` files** (`{name}_neocade_theme.tres`, one per approved direction, each `[gd_resource type="NeoCadeTheme" format=3]` with its direction's `@export` values saved), and addon metadata (`OFL.txt`, `LICENSE.md`, `README.md`, `CHANGELOG.md`, `VERSION`). For the v1 approved set {Pulse, Slate, Bubble, Daybreak, Burst}: **1 `.gd` + 5 `.tres` at the addon root**. **No per-direction `.gd` files** (each direction is purely data on the single class). **No `_dev/` subfolder.** **No `themes/` subfolder.** **No root `neocade_theme.tres`.** **No `neocade_mobile_theme.tres`** (mobile is a `@export platform=MOBILE` toggle on `NeoCadeTheme`). **No `plugin.cfg`** (per STACK Decision 5).
- [ ] **FOUND-02** *(rewritten 2026-05-06f for finalized 9-property `@export` set + `is_light` semantics)*: `addons/neocade_theme/neocade_theme.gd` is `@tool class_name NeoCadeTheme extends Theme` — the **single, concrete, instantiable** class with **9 `@export` properties total**. **Core (4):** `base_color: Color`, `accent_color: Color`, `raised: bool`, `platform: {DESKTOP, MOBILE, AUTO}`. **Shape (5, under `@export_group("Shape")`):** `corner_radius: int`, `spacing: int`, `raised_strength: int`, `focus_thickness: int`, `outline_width: int`. The `@export` set is intentionally minimal — limited to values that should be consistent across the entire theme. Per-direction unique mood lives in Theme Editor entry overrides per `.tres` (StyleBoxFlat per Control state with direction-specific bg/border/padding/content_margin/icons), NOT in a long list of exports. The `_regenerate_theme()` method dynamically populates derived theme entry color/state values from the `@export` values via formulas; computes `var is_light: bool = base_color.get_luminance() >= 0.5` internally (dark default; `is_light` flags deviation) and branches all conditional formulas on `is_light` (godot-minimal-theme line-56 pattern with renamed/inverted variable for project-default-dark clarity). Setters on every `@export` property trigger `_regenerate_theme()`. The class is **NOT abstract** — users can instance it directly (`NeoCadeTheme.new()`) or save custom `.tres` files of type `NeoCadeTheme` to author their own themes. Convention: any future paired x/y `@export` values use `Vector2i`.
- [ ] **FOUND-03** *(rewritten 2026-05-06e for single-class data-driven architecture)*: Each per-direction `.tres` at `addons/neocade_theme/{name}_neocade_theme.tres` is `[gd_resource type="NeoCadeTheme" format=3]` with its direction's `@export` values saved. Loading any of these into a Godot scene yields a `NeoCadeTheme` instance that automatically calls `_regenerate_theme()` to populate entries for ALL 37 scorecard Control rows + 13 type variations. Optional per-`.tres` Theme Editor entry overrides are stored as additional sections in the `.tres` and survive `_regenerate_theme()` if Phase 4 designs the regenerate logic to preserve manual overrides on a flagged subset of entries.

### Fonts (FONT)

- [x] **FONT-01**: Inter Variable Roman (`Inter-Variable.ttf` from Inter v4.x, OFL 1.1) bundled at `addons/neocade_theme/fonts/Inter-Variable.ttf` — **the ONLY font bundled in v1 (Option D, locked 2026-05-04).** Reserved Font Name preserved (file NOT renamed); imported as `FontFile.tres` referenced by `uid://`. `allow_system_fallback` left at default `true` so non-Latin scripts (Arabic, Hebrew, Indic, Thai, CJK, etc.) render via the user's OS system fonts.
- ~~[ ] **FONT-02**: Outfit Variable~~ — **STRICKEN 2026-05-04 per FONT-REVIEW.md.** Outfit dropped from v1 per user's consistency principle. Headings handled by Inter Variable at `opsz=32` + heavier `wght`. Outfit may be reconsidered at Phase 3 typography mockup gate (Variant B); if user picks Variant B there, this requirement is reinstated.
- ~~[ ] **FONT-03**: Noto Sans Variable~~ — **STRICKEN 2026-05-04 (Option D).** Not bundled in v1. Non-Latin scripts handled by Godot's `Font.allow_system_fallback=true` using the user's OS system fonts. README documents how to add Noto Sans (or any preferred coordinated cross-script font) for consumers who want designed-together cross-script harmony.
- ~~[ ] **FONT-04**: JetBrains Mono Variable~~ — **STRICKEN 2026-05-04 (Option D).** Not bundled in v1. CodeEdit / `[code]` BBCode is rare in shipped games. README documents the override pattern: `code_edit.add_theme_font_override("font", preload("res://your_mono.ttf"))`. Consumers who use code surfaces ship their preferred mono.
- [x] **FONT-05**: `OFL.txt` ships Inter's Reserved Font Name notice + copyright block (single-font OFL, since Inter is the only bundled font). Surfaced in README install instructions for downstream projects to embed in their About/Credits.
- [ ] **FONT-06**: Theme `default_font` is Inter Variable Roman; `default_font.fallbacks = []` (empty); `default_font.allow_system_fallback = true` (Godot 4.x default — explicit set for clarity in `.tres`). Heading type variations (HeaderLarge / HeaderMedium / HeaderSmall) use Inter at `opsz=32` + heavier `wght` (700-800) via `FontVariation`, NOT a separate display font. Per Pitfall 1.2 (type variations don't inherit fonts from base type), recommend setting font ONLY on `default_font` and using `FontVariation` for heading variations — structurally avoids the inheritance bug.
- [ ] **FONT-07**: Italic emphasis falls back to synthetic transform on Inter upright (Inter Italic deferred to v1.x per Conflict 1 revision). Body text rendering is acceptable; documented limitation in CHANGELOG.
- [x] **FONT-08**: Font import settings: Grayscale antialiasing, Light hinting, Auto subpixel positioning (per STACK + PITFALLS 5.5; verified for GL Compatibility renderer).
- [ ] **FONT-09**: README documents three consumer-side font override patterns. **Opt-in fonts are NEVER bundled with NeoCade — Option D ships Inter only.** Consumers download and add what their audience needs:

  **(a) Multi-script visual harmony.** Inter alone relies on Godot's `Font.allow_system_fallback=true` for non-Latin scripts. System fonts vary by OS and may clash with Inter's metrics. For consumers who care, recommend **script-specific Noto Sans variants** (NOT the generic "Noto Sans" — that mostly covers Latin/Cyrillic/Greek which Inter already handles). All OFL 1.1, designed to harmonize with Inter:
  - Chinese Simplified — Noto Sans SC (~5 MB subset)
  - Chinese Traditional — Noto Sans TC
  - Japanese — Noto Sans JP
  - Korean — Noto Sans KR
  - Arabic — Noto Sans Arabic
  - Hebrew — Noto Sans Hebrew
  - Devanagari (Hindi/Marathi/Sanskrit) — Noto Sans Devanagari
  - Bengali / Tamil / Telugu / Kannada / Malayalam / Gujarati / Punjabi — Noto Sans Bengali/Tamil/Telugu/etc.
  - Thai / Khmer / Lao / Myanmar — Noto Sans Thai/Khmer/Lao/Myanmar
  - Source: https://fonts.google.com/noto

  Override pattern (per consuming project — pick a specific direction's `.tres`; per flat-layout 2026-05-06d, no root `neocade_theme.tres`):
  ```gdscript
  var theme = preload("res://addons/neocade_theme/slate_neocade_theme.tres").duplicate()
  theme.default_font.fallbacks.append(preload("res://your_noto_sans_sc.ttf"))
  # apply theme to scene root
  ```

  **(b) Code/monospace.** Per-Control override on CodeEdit / RichTextLabel `[code]`:
  ```gdscript
  $CodeEdit.add_theme_font_override("font", preload("res://your_jetbrains_mono.ttf"))
  ```
  Recommended monospace fonts (all OFL): JetBrains Mono, Fira Code, Cascadia Code, IBM Plex Mono. Consumer's choice.

  **(c) Italic upgrade.** v1 uses synthetic italic transform on Inter Variable. To upgrade to true italic, preload Inter Italic Variable:
  ```gdscript
  theme.default_font_italic = preload("res://Inter-Italic-VariableFont.ttf")
  ```

  Per UD-2, Option D, and Conflict 1 final — none of these fonts are bundled in v1.

### Icons (ICON)

- [ ] **ICON-01**: ~25-40 bespoke SVG icons authored at 32×32 reference, imported with `Scale = 2.0` and `Linear With Mipmaps` filter explicitly set per resource. Stored at `addons/neocade_theme/icons/`.
- [ ] **ICON-02**: Icon coverage maps 1:1 to Godot's hard-coded theme icon slots: Button check / radio / toggle / arrow_down / clear / close; OptionButton arrow; CheckBox/CheckButton on/off; Tree expand/collapse; TabBar/TabContainer increment/decrement/menu; ColorPicker preset/screen-pick/sample-bg/recent; FileDialog parent/folder/file/file-up/back/forward/reload; ScrollBar increment/decrement/grabber. Per FEATURES.md icon coverage list.
- [ ] **ICON-03**: Icons are monochrome SVGs (single-color or with a small fixed accent palette mapped via Godot's icon `modulate` rather than baked color); allows tinting per accent role.
- [ ] **ICON-04**: NO bundled Material Symbols / Lucide / Phosphor / external icon library (per STACK "What NOT to Use"). Texture2D-per-slot mismatch + bundle size cost.

### Design System Tokens (TOKEN)

- [x] **TOKEN-01**: Color token system: 5-stop M3 tonal surface ramp (`surface` / `surface-container-low` / `surface-container` / `surface-container-high` / `surface-container-highest`) with friendlier aliases (base / secondary / panel / raised / overlay) per SUMMARY Conflict 2.
- [x] **TOKEN-02**: 8-hue accent palette + semantic role aliases (`role.primary` → chosen accent, `role.success`, `role.warning`, `role.danger`, `role.info`, plus decorative accents).
- [x] **TOKEN-03**: 3 text colors (`text.strong` / `text.default` / `text.muted`) verified WCAG 2.1 AA against every surface stop.
- [ ] **TOKEN-04**: `surface.sunken` token is REJECTED for v1 (per SUMMARY Conflict 2); inputs distinguished via focus/normal stylebox + corner radius.
- [x] **TOKEN-05**: 4-rung corner radius scale: `radius.none=0` / `radius.sm=4` / `radius.md=8` / `radius.lg=12`. Default 4px (godot-minimal-theme parity); 8px on PopupPanel/Window; 12px on dialogs.
- [x] **TOKEN-06**: 8-step spacing scale: `space.0` through `space.8` (4px base scale: 0/4/8/12/16/24/32/48 — desktop). Mobile overrides: +50% on `space.4` and above.
- [x] **TOKEN-07**: Stroke width set: 1px hairline default; 2px focus rings; 3px reserved for danger emphasis. Integer pixels only (no fractional widths under GL Compatibility).
- [x] **TOKEN-08**: Elevation model: color-only (tonal surface ramp). NO drop shadows in v1 (per SUMMARY Conflict 3 + FEATURES AF-13 + GL Compatibility issue #23640). Optional 1px lighter top-bevel border allowed on raised buttons.
- [x] **TOKEN-09**: Interaction state system uses M3 deterministic state-layer model: hover 8% overlay, focus 12% overlay + 2px outer ring in `role.primary`, pressed 12% overlay, dragged 16% overlay, disabled 38% text / 12% container. Reproducible from any base color.
- [x] **TOKEN-10**: Type scale spine (M3-derived; all UI surfaces use Inter — heading discrimination via `opsz` axis + `wght`, not via family switch): display-small 36 (Inter opsz=32 wght=800) / headline-small 24 (Inter opsz=32 wght=700) / title-large 20 (Inter opsz=24 wght=600) / title-medium 16 (Inter wght=600) / body-large 16 (Inter wght=400) / body-medium 14 (Inter wght=400) / body-small 12 (Inter wght=400) / label-large 14 (Inter wght=500) / label-small 11 (Inter wght=500) / code 13 (consumer-supplied mono via override pattern; theme provides no mono in v1 per Option D).

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
- [ ] **TYPEVAR-02**: 5 Label type variations: HeaderLarge (Inter opsz=32 wght=800, display-small), HeaderMedium (Inter opsz=32 wght=700, headline-small), HeaderSmall (Inter opsz=24 wght=600, title-large), Caption (Inter wght=400, body-small), CodeLabel (consumer-supplied mono via override; theme defines the variation but ships no mono in v1).
- [ ] **TYPEVAR-03**: 1 RichTextLabel type variation: InfoText.
- [ ] **TYPEVAR-04**: 2 Panel type variations: CardPanel, HeroPanel.
- [ ] **TYPEVAR-05**: Fonts set explicitly on every type variation (per PITFALLS 1.2 — type variations DO NOT inherit fonts from base type, even when stylebox inheritance works). Verify under runtime QA, not editor preview.
- [ ] **TYPEVAR-06**: All 13 type variations are documented in `MOBILE-DESIGN-SPEC.md` and `DESIGN_TOKENS.md` with concrete usage examples.

### Mobile Variant (MOBILE)

- [ ] **MOBILE-01** *(rewritten 2026-05-06d/f; supersedes the separate-mobile-tres and abstract-base approaches)*: Mobile sizing is a `@export platform=MOBILE` toggle on the single concrete `NeoCadeTheme` class — NOT a separate `.tres` file. Setting `platform=MOBILE` (or `platform=AUTO` on a mobile target) triggers `_regenerate_theme()` to use mobile-tuned constants (44pt iOS / 48dp Android tap targets, 16px body vs 14px desktop, +50% spacing on `space.4+` per Phase 8 mobile-sizing branch). Every direction `.tres` exposes `platform`; consumers can ship the same direction `.tres` and switch platforms at instantiation or via `platform=AUTO` for runtime detection.
- [ ] **MOBILE-02**: Tap targets ≥48px (Godot pixels at base scale 1.0) on every interactive Control in the mobile theme. Satisfies iOS HIG 44pt minimum + Material 3 48dp minimum simultaneously.
- [ ] **MOBILE-03**: Body text 16px on mobile vs 14px desktop. Headings retain their desktop sizes (Inter at opsz=32 + wght=700-800; no scale change for headings).
- [ ] **MOBILE-04**: Spacing scale +50% on `space.4` and above on mobile. Corner radii STAY IDENTICAL across desktop/mobile (brand identity, not platform-specific).
- [ ] **MOBILE-05**: One mobile theme covers all Android density buckets (per CROSS-PLATFORM 3.5; Godot uses `content_scale_factor` + stretch modes, NOT density qualifiers). Authored values are dp-equivalent at base scale 1.0.
- [ ] **MOBILE-06**: Tap-target audit script confirms every interactive Control in mobile theme is ≥48px; runs as part of Phase 8 acceptance.
- [ ] **MOBILE-07**: `MOBILE-DESIGN-SPEC.md` documents every delta vs desktop with concrete numbers + rationale.
- [ ] **MOBILE-08**: Mobile theme follows iOS HIG + Material 3 mobile guidance loosely (touch targets, type scale, accessibility minima) but retains the NeoCade arcade visual identity. NOT making Godot UI look native iOS or Android.

### Showcase Scene (SHOW)

- [ ] **SHOW-01**: `res://main.tscn` is the showcase scene; applied as project main scene. Uses NeoCade Theme as project theme (or per-scene `theme` override if leak avoidance preferred).
- [ ] **SHOW-02**: Showcase scene contains 9 sections covering all 37 scorecard Control rows + Token Gallery + Coverage Verification: Buttons / Text Inputs / Numbers & Range / Selection & Lists / Containers & Layout / Dialogs & Popups / Advanced & Graph / Token Gallery / Coverage 37/37.
- [ ] **SHOW-03**: Realistic sample content per Control (Tree with multi-level items, ItemList with options, OptionButton with multiple options, etc.) per PITFALLS 10.1 — empty controls render invisibly.
- [ ] **SHOW-04**: Prominent floating theme/variation control panel: direction picker (Pulse/Slate/Bubble/Daybreak/Burst + Godot default), raised toggle, and platform selector (DESKTOP/MOBILE/AUTO). Bigger than other controls so its purpose is obvious. Toggles mutate the active `NeoCadeTheme` resource exports and verify clean state switching (per PITFALLS 10.3).
- [ ] **SHOW-05**: BBCode demo in RichTextLabel section showcasing inline color/weight/italic.
- [ ] **SHOW-06**: `accessibility_name` set on every interactive Control in showcase (per PITFALLS 2.5 + 4.4 — minimum bar for screen-reader sanity in v1).
- [ ] **SHOW-07**: Token Gallery section displays each design token visually (color swatches with hex + role label, type scale samples, spacing/radius scale visualizations).
- [ ] **SHOW-08**: Coverage Verification strip displays "37/37 Controls themed ✓" or accurate count if any deferred.

### Cross-Platform Export (EXPORT)

- [ ] **EXPORT-01**: Theme exports correctly to all 6 Godot 4.6 export targets: Windows, macOS, Linux, iOS, Android, Web/Browser.
- [ ] **EXPORT-02**: Per-target screenshot deck produced in `.planning/qa/exports/<target>/` showing showcase scene rendering on each target. Acceptance: render-correctness, not pixel-parity (iOS Safari WebGL2 quirks documented).
- [ ] **EXPORT-03**: Web/Browser export specifics handled: `.ttf` files added to "Filters to export non-resources" OR wrapped in saved `FontFile.tres`; all theme/font/icon resources referenced by `uid://`; no `SystemFont` resource (silently fails on Web per CROSS-PLATFORM 2.2).
- [ ] **EXPORT-04**: Project remains on GL Compatibility renderer (per CROSS-PLATFORM TL;DR Decision 1; avoids Godot 4.6 regressions #116090 iOS Mobile and #111729 Android Mobile).
- [ ] **EXPORT-05**: CI workflow exports + smoke-tests on Windows + Linux + macOS + Web targets (desktop runners + headless Web export).
- [ ] **EXPORT-06**: Manual Android validation on at least 1 device (low / mid / high end if 3 devices available; or "deferred to v1.0.1" with explicit changelog note per UD-5).
- [ ] **EXPORT-07**: Manual iOS validation on at least 1 device (requires Mac + paid Apple Developer Program; or "deferred to v1.0.1" with explicit changelog note per UD-5).
- [ ] **EXPORT-08**: License compliance verified: the single bundled font (Inter Variable Roman) is OFL 1.1 — App Store + Play Store + Web embedding all legal. Reserved Font Name clause preserved (Inter binary NOT renamed). Web export specifically: `Font.allow_system_fallback` behavior validated against Chrome / Firefox / Safari — non-Latin scripts render via browser-exposed system fonts.

### Accessibility (A11Y)

- [ ] **A11Y-01**: WCAG 2.1 AA contrast verified for every text-on-surface combo and every interactive state combination. Computed via W3C luminance formula; reproducible from token values.
- [ ] **A11Y-02**: Visible focus indicator on every focusable Control (covers SC 2.4.7 + SC 1.4.11). Drawn as 2px outer ring outside `corner_radius` so it doesn't lose to pressed/checked replacement styleboxes (PITFALLS 1.1).
- [ ] **A11Y-03**: No information conveyed by color alone. Status states (success/warning/danger) include icon + text label + color cue.
- [ ] **A11Y-04**: Color-blindness verification pass: showcase rendered through deuteranopia, protanopia, tritanopia simulation; legibility confirmed for status/role colors.
- [ ] **A11Y-05**: Multi-script label test: Latin / Cyrillic / Arabic / Hebrew / Devanagari labels render correctly via Inter plus `Font.allow_system_fallback = true`, with optional consumer-supplied Noto Sans fallbacks documented for projects that need designed-together script harmony.
- [ ] **A11Y-06**: `accessibility_name` set on every interactive Control in showcase (Godot 4.5 API, partial AccessKit integration in 4.6). Deeper screen-reader QA (VoiceOver/TalkBack) deferred to v1.x per UD-6.

### QA & Visual Regression (QA)

- [ ] **QA-01**: MCP/QA tooling baseline: Phase 10 sub-spike validates the chosen MCP server (UD-1: GoPeak recommended) end-to-end — capture editor screenshot, capture running-game screenshot, inject input.
- [ ] **QA-02**: Full visual QA matrix: 9 showcase sections × 2 renderers (Forward+ + GL Compatibility) × 3 resolutions (1080p / 1440p / 4K) × 3 scale factors (100% / 150% / 200%). Output: `.planning/qa/screenshots/`.
- [ ] **QA-03**: Tab-walk every Control in showcase + capture focused-state screenshot. Verify focus ring visibility under hover/pressed/checked combinations.
- [ ] **QA-04**: Dual-renderer screenshot pass: theme authored on GL Compatibility (project lock); also rendered on Forward+ for comparison; deltas documented but not fixed (GL Compat is the ship target).
- [ ] **QA-05**: Fresh-install dry-run: clone the addon into a clean Godot project; verify `addons/neocade_theme/` works without modifications; theme applies as both project theme and per-scene theme; fonts and icons load correctly.
- [ ] **QA-06**: Theme inspector workaround: per PITFALLS 4.6 active issue #115500, do NOT edit theme via Control inspector context — author via dedicated Theme tab + `@tool` generator only. Documented in CONTRIBUTING.md.

### Distribution (DIST)

- [ ] **DIST-01** (REVISED 2026-05-04): `.github/workflows/release.yml` exists. Single `workflow_dispatch` trigger with NO inputs (per PentaTile reference D-05-15). Manually triggered from Actions tab. Runs on `ubuntu-latest`. Uses `actions/checkout@v6` with `fetch-depth: 0` and `persist-credentials: true`. Job-level `permissions: contents: write`. Uses `github-actions[bot]` git identity.
- [ ] **DIST-02**: `OFL.txt` covers Inter (the single bundled font in v1, Option D) — Reserved Font Name notice block + copyright lines.
- [ ] **DIST-03**: `LICENSE.md` for theme code (recommend MIT or CC-BY) + initial `CHANGELOG.md` entry for v1.0.0.
- [ ] **DIST-04** (REVISED 2026-05-04): Version commit + tag + push: workflow rewrites `addons/neocade_theme/VERSION` to new version, rewrites `CHANGELOG.md`'s `## [Unreleased]` heading to `## [<NEW_VERSION>] — <DATE>`, commits with `chore(release): v<NEW_VERSION>`, creates annotated tag `v<NEW_VERSION>`, runs `git push origin HEAD:main` + `git push origin "v<NEW_VERSION>"`.
- [ ] **DIST-05** (REVISED 2026-05-04): Addon zip via `git archive --format=zip --prefix="neocade_theme-v<VERSION>/" -o "neocade_theme-v<VERSION>.zip" "v<VERSION>" -- addons/neocade_theme/` — only tracked files at the tagged commit, only the addon directory (PentaTile pitfall #11 — excludes `.godot/`, build artifacts, untracked).
- [ ] **DIST-06** (NEW): Auto-version-increment from `addons/neocade_theme/VERSION` (single-line `MAJOR.MINOR.PATCH` file). Default bump: minor +1. If minor would exceed 9: major +1, minor=0. Patch always 0 (patches NOT supported by this scheme — same as PentaTile D-05-16). Sed-based rewrite preserves quote style if any.
- [ ] **DIST-07** (NEW): CI gates run before version bump. Workflow downloads pinned `Godot_v4.6.x-stable_linux.x86_64`; runs headless project import (`godot --headless --path . --import --quit-after 2`) checking stderr for `^(ERROR|SCRIPT ERROR):` markers (PentaTile pitfall #1); opens `res://main.tscn` headless to verify showcase loads cleanly; runs any test suite present. Failure aborts release before any commits/pushes.
- [ ] **DIST-08** (NEW): Godot Web export build. Workflow downloads matching Godot 4.6.x Web export templates (`Godot_v4.6.x-stable_export_templates.tpz`), installs them to `~/.local/share/godot/export_templates/4.6.x.stable/`, runs `godot --headless --export-release "Web" <output_dir>/index.html` against a committed `export_presets.cfg` "Web" preset (created as part of Phase 9 showcase work). Archives the resulting `index.html` + `index.wasm` + `index.pck` + `index.js` + `index.audio.worklet.js` + supporting files into `neocade_theme-showcase-web-v<VERSION>.zip`.
- [ ] **DIST-09** (NEW): CHANGELOG slice extraction. awk-based extraction of the `[<NEW_VERSION>] — <DATE>` section from `CHANGELOG.md` into `release-notes-body.md`. Trim trailing blank lines. Fail fast (exit 1) if the slice is empty.
- [ ] **DIST-10** (NEW): GitHub Release published via `softprops/action-gh-release@v3` (REQUIRES `ubuntu-latest` for Node 24 — PentaTile pitfall #5; do NOT pin to ubuntu-22.04). Attach BOTH `neocade_theme-v<VERSION>.zip` AND `neocade_theme-showcase-web-v<VERSION>.zip` as release assets. `body_path: release-notes-body.md`. `draft: false`, `prerelease: false`. Auth via implicit `GITHUB_TOKEN` from job-level `permissions: contents: write`.
- [ ] **DIST-11** (NEW): `addons/neocade_theme/VERSION` exists as a single-line `MAJOR.MINOR.PATCH` file (initial value `0.1.0` or similar pre-release). This is the v1 source of truth for theme version (replaces `plugin.cfg` pattern from PentaTile — NeoCade has no `plugin.cfg` per Option D).
- [ ] **DIST-12** (NEW): `addons/neocade_theme/OFL.txt` ships Inter's Reserved Font Name notice + copyright (single-font OFL per Option D).
- [ ] **DIST-13** (NEW): `LICENSE.md` for theme code at addon root (recommend MIT or CC-BY).
- [ ] **DIST-14** (NEW): `CHANGELOG.md` at repo root with a `## [Unreleased]` section pre-populated by each phase's deliverables. v1.0.0 entry will be auto-generated by the release workflow on first dispatch.
- [ ] **DIST-15** (NEW): `export_presets.cfg` committed at repo root with a "Web" export preset configured for `main.tscn` (showcase scene). Created as part of Phase 9 showcase deliverables. Required for DIST-08 web build.
- [ ] **DIST-16** (NEW): GitHub Pages deployment of the Web build. Workflow uses `actions/upload-pages-artifact@v3` (upload the web export directory as a Pages artifact) followed by `actions/deploy-pages@v4` (deploy to the `github-pages` environment). Adds `pages: write` and `id-token: write` to the workflow's `permissions` block. **One-time repo-side setup required** (manual): GitHub repo settings → Pages → Source = "GitHub Actions". Once configured, every release auto-deploys to `https://<owner>.github.io/<repo>/`. The release zip (DIST-08) remains as the offline/archive artifact; Pages provides the "click and play" link surfaced in README and release notes.
- [ ] **DIST-17** (NEW): README + release notes include the GitHub Pages "Try the showcase in your browser" link (`https://<owner>.github.io/<repo>/`). Link surfaced in README's intro section + auto-included in CHANGELOG `[Unreleased]` template so each release body shows it.
- [ ] **DIST-18** (NEW): COOP/COEP service worker verification on the deployed Pages URL. Godot 4.x Web export uses `SharedArrayBuffer` which requires `Cross-Origin-Opener-Policy: same-origin` + `Cross-Origin-Embedder-Policy: require-corp` headers. GitHub Pages cannot set custom HTTP headers, so Godot's `coi-serviceworker.js` (shipped by the web export template) must be registered and active. **Acceptance test:** load the deployed Pages URL in Chrome DevTools console, evaluate `crossOriginIsolated`, must be `true`. Phase 9 export preset must have `head_include` set so the service worker is registered. Phase 10 cross-platform validation includes this check.
- [ ] **DIST-19** (NEW): Repository visibility check before Phase 11 ships. GitHub Pages free tier requires PUBLIC repo. If repo is private, requires GitHub Pro / Team / Enterprise — surface as a UD if user's plan status is unknown when Phase 11 starts.

### Documentation (DOCS)

- [ ] **DOCS-01**: `DESIGN_TOKENS.md` is committed before Phase 4 begins (FOUND-02 dependency); contains finalized desktop + mobile token blocks, sourced from approved Phase 3 mockups.
- [ ] **DOCS-02**: `MOBILE-DESIGN-SPEC.md` documents every mobile delta vs desktop with concrete numbers + rationale (MOBILE-07 deliverable).
- [ ] **DOCS-03**: `EDITOR-COVERAGE.md` (already exists; per MAJ-7 review finding) maps which Editor surfaces are themed in v1 vs which fall back to default.
- [ ] **DOCS-04**: README.md is comprehensive: project description; **install path = "Download `neocade_theme-v<VERSION>.zip` from GitHub Releases, extract `addons/neocade_theme/` into your project's `addons/` folder"** (no Asset Library reference); usage examples (project theme + per-scene theme + optional editor theme); cross-platform notes; accessibility notes; **font override patterns** (Noto Sans for non-Latin harmony, mono for CodeEdit, Inter Italic) per FONT-09; **link to web showcase** (`neocade_theme-showcase-web-v<VERSION>.zip` from the same release — extract and serve, or "play in browser" GitHub Pages link if v1.x adds it); editor-coverage map link (EDITOR-COVERAGE.md); license; attributions; link to GitHub repo.
- [x] **DOCS-05**: SOURCES.md is updated by Phase 1, 2, 3 source-dive spike outputs (RES-01..03) with new findings.

## v2 Requirements

Deferred to future release. Tracked but not in v1 roadmap.

### Light Mode

- **LIGHT-01**: Light color mode for desktop theme (`neocade_theme_light.tres`)
- **LIGHT-02**: Light color mode behavior for `platform=MOBILE` on light direction resources — IF mobile-light is in v2 scope (per PROJECT.md note that mobile-light may stay deferred even in v2)

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

Phase mapping per ROADMAP.md (15-phase redirected roadmap; originally seeded by SUMMARY.md's 11-phase plan, then updated by Phase 3 redirect and 2026-05-06e/f architecture simplification). Every v1 REQ-ID maps to exactly ONE primary phase. Cumulative requirements (those whose work accrues across multiple phases) are assigned a primary phase with explicit cumulative reasoning.

| Requirement | Primary Phase | Cumulative Contributors | Status |
|-------------|---------------|------------------------|--------|
| RES-01 | Phase 1 (Source-Dive: godot-minimal-theme `.tres` dissection) | — | Complete |
| RES-02 | Phase 2 (Source-Dive: LDtk source UI mining) | — | Complete |
| RES-03 | Phase 3 (mood-board sub-spike) | — | Complete |
| RES-04 | Phase 3 (MCP tooling baseline sub-spike — UD-1) | — | Complete: fallback proven; direct GoPeak/input validation deferred to QA-01 |
| ~~RES-05~~ | _STRICKEN 2026-05-04 — no AssetLib in v1_ | — | _N/A_ |
| DESIGN-01 | Phase 3/3.4 (palette/direction mockups; v0 superseded, flat-MD3 replacement approved) | — | Complete / Superseded |
| DESIGN-02 | Phase 3/3.4 (typography gate; Inter-only v1 locked) | — | Complete / Superseded |
| DESIGN-03 | Phase 3.4 Plan 03 (Pulse full-fidelity 4-grid desktop evidence) | — | In Progress |
| DESIGN-04 | Phase 3.4 Plan 03 (Pulse mobile 4-grid evidence) | — | In Progress |
| DESIGN-05 | Phase 3.4 Plan 04 (`DESIGN_TOKENS.md` finalized pre-Phase-4) | — | Pending |
| DESIGN-06 | Phase 3.4 (gate enforcement) | — | Active |
| FOUND-01 | Phase 4 (addon directory layout) | — | In Progress (Plan 04-01 deleted scaffold root .tres + authored neocade_theme.gd; Plan 04-02 added fonts/ + OFL.txt; full layout closes via Plans 04-03/06/07/08) |
| FOUND-02 | Phase 4 (single concrete `NeoCadeTheme` class + 9-property export surface) | — | In Progress (Plan 04-01 authored class shell with all 9 @exports + Platform enum + is_light + reentry guard; formula + binding-table body closes via Plans 04-04/05) |
| FOUND-03 | Phase 4 (five data-only direction `.tres` resources) | — | Pending |
| FONT-01 | Phase 4 (Plan 04-02 bundled Inter Variable v4.0 with verified SHA256) | — | Complete |
| FONT-02 | Phase 4 | — | Stricken (UD-4 Option D 2026-05-04 — Outfit removed) |
| FONT-03 | Phase 4 | — | Stricken (UD-4 Option D 2026-05-04 — Noto Sans removed) |
| FONT-04 | Phase 4 | — | Stricken (UD-4 Option D 2026-05-04 — JetBrains Mono removed) |
| FONT-05 | Phase 4 (Plan 04-02 OFL.txt with Reserved Font Name + 2016 Inter Project Authors copyright) | — | Complete |
| FONT-06 | Phase 4 (default_font + fallbacks wiring) | Plan 04-02 (FontFile + 5 FontVariations cover M3 type scale; default_font wiring closes in Plan 04-05 binding table) | In Progress |
| FONT-07 | Phase 4 (synthetic italic policy + CHANGELOG note) | — | Pending |
| FONT-08 | Phase 4 (Plan 04-02 set Grayscale AA + Light hinting + Auto subpixel + mipmaps + system fallback in Inter-Variable.ttf.import for GL Compatibility per PITFALLS 5.5) | — | Complete |
| FONT-09 | Phase 4 (CJK exclusion + README override pattern) | — | Pending |
| ICON-01 | Phase 4 | — | Pending |
| ICON-02 | Phase 4 (1:1 icon-slot mapping) | — | Pending |
| ICON-03 | Phase 4 (monochrome SVG policy) | — | Pending |
| ICON-04 | Phase 4 (no external icon library) | — | Pending |
| TOKEN-01 | Phase 3 (token values defined) | Phase 4 (generator implements) | Pending |
| TOKEN-02 | Phase 3 | Phase 4 | Pending |
| TOKEN-03 | Phase 3 (WCAG AA verification) | Phase 4 | Pending |
| TOKEN-04 | Phase 3 (`surface.sunken` rejection) | Phase 4 | Pending |
| TOKEN-05 | Phase 3 (radius scale) | Phase 4 | Pending |
| TOKEN-06 | Phase 3 (spacing scale + mobile +50%) | Phase 4 | Pending |
| TOKEN-07 | Phase 3 (stroke widths) | Phase 4 | Pending |
| TOKEN-08 | Phase 3 (no-shadows policy) | Phase 4 (`shadow_size = -1` everywhere) | Pending |
| TOKEN-09 | Phase 3 (M3 state-layer model) | Phase 4 | Pending |
| TOKEN-10 | Phase 3 (M3 type scale spine) | Phase 4 (Plan 04-02 authored 5 FontVariation .tres covering DESIGN_TOKENS §8.5: HeaderLarge wght=800/opsz=32, HeaderMedium wght=700/opsz=32, HeaderSmall wght=600/opsz=24, Body wght=400, Caption wght=400) | In Progress (font scaffold complete; binding-table wiring closes in 04-05) |
| COV-01 | Phase 7 (37/37 scorecard desktop coverage closes here) | Phase 5 + Phase 6 (cumulative authoring) | Pending |
| COV-02 | Phase 5 (Core Controls — BaseButton family) | — | Pending |
| COV-03 | Phase 5 (Core Controls — text classes) | — | Pending |
| COV-04 | Phase 6 (range controls) | — | Pending |
| COV-05 | Phase 6 (lists/tree/tabs) | — | Pending |
| COV-06 | Phase 7 (popup-class as first-class types) | — | Pending |
| COV-07 | Phase 7 (container chrome closes here) | Phase 5 (Panel) + Phase 6 (Scroll/Split/Margin) | Pending |
| COV-08 | Phase 7 (MenuBar/ColorPicker/Graph) | — | Pending |
| COV-09 | Phase 5 (focus-as-outer-ring pattern established) | Phase 6 + 7 (applied to every focusable Control); Phase 10 (verification) | Pending |
| COV-10 | Phase 10 (verification against RES-01 enumeration) | Depends on Phase 1 RES-01 | Pending |
| TYPEVAR-01 | Phase 5 (6 Button variations) | — | Pending |
| TYPEVAR-02 | Phase 5 (5 Label variations) | — | Pending |
| TYPEVAR-03 | Phase 5 (RichTextLabel InfoText) | — | Pending |
| TYPEVAR-04 | Phase 5 (2 Panel variations) | — | Pending |
| TYPEVAR-05 | Phase 5 (fonts set explicitly per variation) | Phase 6 + 7 (any variations declared in later phases follow same pattern) | Pending |
| TYPEVAR-06 | Phase 8 (`MOBILE-DESIGN-SPEC.md` + `DESIGN_TOKENS.md` finalized with all 13 variations) | Phase 5 + 6 (variation declarations) | Pending |
| MOBILE-01 | Phase 8 | — | Pending |
| MOBILE-02 | Phase 8 (≥48px tap targets) | — | Pending |
| MOBILE-03 | Phase 8 (16px body / heading parity) | — | Pending |
| MOBILE-04 | Phase 8 (spacing +50% / radii unchanged) | — | Pending |
| MOBILE-05 | Phase 8 (single mobile theme covers all density buckets) | — | Pending |
| MOBILE-06 | Phase 8 (tap-target audit script) | — | Pending |
| MOBILE-07 | Phase 8 (`MOBILE-DESIGN-SPEC.md`) | — | Pending |
| MOBILE-08 | Phase 8 (NeoCade identity preservation) | — | Pending |
| SHOW-01 | Phase 9 (`res://main.tscn` as project main scene) | — | Pending |
| SHOW-02 | Phase 9 (9 sections / 37 scorecard rows covered) | — | Pending |
| SHOW-03 | Phase 9 (realistic sample content) | — | Pending |
| SHOW-04 | Phase 9 (three-way theme toggle) | — | Pending |
| SHOW-05 | Phase 9 (BBCode demo) | — | Pending |
| SHOW-06 | Phase 9 (`accessibility_name` on every interactive Control) | — | Pending |
| SHOW-07 | Phase 9 (Token Gallery section) | — | Pending |
| SHOW-08 | Phase 9 (Coverage Verification strip) | — | Pending |
| EXPORT-01 | Phase 10 (all 6 targets export) | — | Pending |
| EXPORT-02 | Phase 10 (per-target screenshot decks) | — | Pending |
| EXPORT-03 | Phase 10 (Web export specifics) | — | Pending |
| EXPORT-04 | Phase 10 (GL Compatibility lock) | — | Pending |
| EXPORT-05 | Phase 10 (CI workflow) | — | Pending |
| EXPORT-06 | Phase 10 (Android validation; UD-5 conditional) | — | Pending |
| EXPORT-07 | Phase 10 (iOS validation; UD-5 conditional) | — | Pending |
| EXPORT-08 | Phase 10 (font license verification) | — | Pending |
| A11Y-01 | Phase 10 (WCAG 2.1 AA contrast audit) | — | Pending |
| A11Y-02 | Phase 10 (focus indicator audit) | Phase 5 (pattern), Phase 6 + 7 (applied) | Pending |
| A11Y-03 | Phase 10 (no color-only information) | — | Pending |
| A11Y-04 | Phase 10 (CVD simulation pass) | — | Pending |
| A11Y-05 | Phase 10 (multi-script label test) | — | Pending |
| A11Y-06 | Phase 10 (`accessibility_name` verification) | Phase 9 (set) | Pending |
| QA-01 | Phase 10 (MCP/QA tooling baseline reconfirmation; also Phase 3 sub-spike for initial baseline) | Phase 3 (GoPeak availability + screenshot fallback via RES-04) | Pending |
| QA-02 | Phase 10 (visual QA matrix) | — | Pending |
| QA-03 | Phase 10 (Tab-walk focus audit) | — | Pending |
| QA-04 | Phase 10 (dual-renderer screenshot pass) | — | Pending |
| QA-05 | Phase 10 (fresh-install dry-run) | — | Pending |
| QA-06 | Phase 10 (theme inspector workaround documented in CONTRIBUTING.md) | — | Pending |
| DIST-01 | Phase 11 (release.yml workflow scaffold) | — | Pending |
| DIST-02 | Phase 11 (auto-version-increment from VERSION file) | — | Pending |
| DIST-03 | Phase 11 (CI gates — headless import + showcase open) | — | Pending |
| DIST-04 | Phase 11 (version commit + tag + push) | — | Pending |
| DIST-05 | Phase 11 (addon zip via git archive) | — | Pending |
| DIST-06 | Phase 11 (auto-version-increment policy) | — | Pending |
| DIST-07 | Phase 11 (CI gates) | — | Pending |
| DIST-08 | Phase 11 (Godot Web export build + zip) | — | Pending |
| DIST-09 | Phase 11 (CHANGELOG slice extraction) | — | Pending |
| DIST-10 | Phase 11 (GitHub Release publish via softprops/action-gh-release@v3) | — | Pending |
| DIST-11 | Phase 4 (`addons/neocade_theme/VERSION` file scaffold) — set up alongside addon root files; Phase 11 reads it | — | Pending |
| DIST-12 | Phase 4 (`OFL.txt` scaffold; Phase 11 ships it) | — | Pending |
| DIST-13 | Phase 4 (`LICENSE.md`; Phase 11 ships it) | — | Pending |
| DIST-14 | Phase 4 (CHANGELOG.md scaffold; populated continuously through phases; Phase 11 reads it) | — | Pending |
| DIST-15 | Phase 9 (`export_presets.cfg` Web preset; Phase 11 uses it) | — | Pending |
| DIST-16 | Phase 11 (GitHub Pages deployment of web build) | — | Pending |
| DIST-17 | Phase 11 (README + release notes link to Pages URL) | — | Pending |
| DIST-18 | Phase 9 (head_include export preset) + Phase 10 (deploy verification — `crossOriginIsolated===true`) | — | Pending |
| DIST-19 | Phase 11 prerequisite (repo public OR user has Pro+ plan) | — | Pending — confirm repo visibility |
| DOCS-01 | Phase 3 (`DESIGN_TOKENS.md` pre-Phase-4) | — | Pending |
| DOCS-02 | Phase 8 (`MOBILE-DESIGN-SPEC.md`) | — | Pending |
| DOCS-03 | Already complete (EDITOR-COVERAGE.md exists) | — | Complete |
| DOCS-04 | Phase 11 (README — closes DIST-04) | — | Pending |
| DOCS-05 | Phase 1 (initial SOURCES.md update) | Phase 2 + Phase 3.x (continuous update through source-dive spikes) | Complete / Ongoing |

**Coverage:**
- v1 requirements: 99 total (RES-5, DESIGN-6, FOUND-3, FONT-9, ICON-4, TOKEN-10, COV-10, TYPEVAR-6, MOBILE-8, SHOW-8, EXPORT-8, A11Y-6, QA-6, DIST-5, DOCS-5)
- Mapped to a primary phase: 99 (DOCS-03 already Complete pre-roadmap; remaining 98 mapped Pending)
- Unmapped: 0 ✓
- Cumulative requirements (assigned primary phase + documented contributors): TOKEN-01..10, COV-01, COV-07, COV-09, COV-10, TYPEVAR-05, TYPEVAR-06, A11Y-02, A11Y-06, QA-01, DOCS-05

**Phase distribution (primary-phase counts):**
- Phase 1: 2 (RES-01, plus Phase 1 contribution to DOCS-05)
- Phase 2: 1 (RES-02)
- Phase 3: 16 (RES-03, RES-04, DESIGN-01..06, DOCS-01, TOKEN-01..10 design definitions)
- Phase 4: 16 (FOUND-01..03, FONT-01..09, ICON-01..04 — TOKEN-01..10 contribute as generator implementation)
- Phase 5: 9 (COV-02, COV-03, TYPEVAR-01..05, plus Phase 5 contributions to COV-01, COV-07, COV-09)
- Phase 6: 2 (COV-04, COV-05)
- Phase 7: 4 (COV-06, COV-08, plus closing of COV-01, COV-07)
- Phase 8: 10 (MOBILE-01..08, DOCS-02, TYPEVAR-06)
- Phase 9: 8 (SHOW-01..08)
- Phase 10: 21 (COV-10, EXPORT-01..08, A11Y-01..06, QA-01..06)
- Phase 11: 7 (RES-05, DIST-01..05, DOCS-04)

**Mockup approval gate:** Hard blocker between Phase 3.4 and Phase 4. No addon `.tres`/`.gd` styling commits permitted before Phase 3.4 final approval is logged and DESIGN_TOKENS.md is written.

**Open user decisions (UD-1..UD-6):** Tracked in-phase per ROADMAP.md "Coverage Summary" section. None block roadmap creation.

---
*Requirements defined: 2026-05-04*
*Last updated: 2026-05-06 — synchronized with Phase 3.4 Plan 02 closeout, current Plan 03 execution, 37-row scorecard wording, and single-class/data-`.tres` architecture*
*Next update trigger: Phase 3.4 Plan 04 DESIGN_TOKENS.md closeout or Phase 4 planning*
