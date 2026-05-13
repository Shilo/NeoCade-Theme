# Requirements: NeoCade Theme

**Defined:** 2026-05-04
**Core Value:** A drop-in Godot 4.6 flat-MD3/MD3-Expressive Theme system that styles every built-in user-facing Control to a `godot-minimal-theme` bar of feature-completeness, with a colorful, professional, accessible arcade identity and universal editor + runtime + all-6-export-target support. v1 ships one concrete `NeoCadeTheme` class at `res://addons/neocade_theme/scripts/neocade_theme.gd` plus one canonical `res://addons/neocade_theme/neocade_theme.tres` resource with built-in Bubble, Burst, Daybreak, Pulse, and Slate styles; mobile is an `@export platform=MOBILE` mode on the same resource, not a sibling `neocade_mobile_theme.tres`.

> **Authoritative inputs:** PROJECT.md (constraints + hard rules), `.planning/ROADMAP.md` (17 phase entries including redirected/historical Phase 3 plus completed Phases 12-13), `.planning/research/SUMMARY.md` (original synthesis + Conflict resolutions + UD-1..6; superseded where later Phase 3.x artifacts explicitly say so), `.planning/research/FEATURES.md` (35-class coverage matrix + original 13 type-variation seed + anti-features; type-variation count superseded by the live `TYPE_VARIATIONS` registry), `.planning/research/MINIMAL-THEME-COVERAGE-DELTA.md` (37-row scorecard reconciliation), `.planning/research/CROSS-PLATFORM.md` (mobile spec + per-target validation), `.planning/research/PITFALLS.md` (10 categories of gotchas + prevention), `.planning/research/EDITOR-COVERAGE.md` (themed-vs-default editor surfaces), `.planning/research/SOURCES.md` (per-source dossier).

## v1 Requirements

Requirements for initial release. Each REQ-ID maps to exactly one primary phase in ROADMAP.md (some are cumulative across multiple phases — see Traceability section).

> **Status note (2026-05-13):** Phases 1-13 are complete for autonomous implementation scope. Manual release dispatch, repo settings checks, live GitHub Pages verification, and deeper screen-reader/device QA remain explicitly deferred owner/manual work rather than hidden pending implementation.

### Research & Spike (RES)

- [x] **RES-01**: Phase 1 source-dive spike produces line-by-line dissection of `passivestar/godot-minimal-theme` `.tres` (per-Control × per-state entry enumeration; interaction state transforms; popup/window theming patterns). Findings appended to SOURCES.md.
- [x] **RES-02**: Phase 2 source-dive spike mines LDtk source code under `C:\Programming_Files\ldtk-master\src\electron.renderer\` for UI implementation patterns (sidebar tinting, layer panel chrome, tool-button conventions, modal flow, panel collapse, context menus, status indicators); appended to SOURCES.md.
- [x] **RES-03**: Phase 3 sub-spike produces a curated mood-board of 20-30 high-resolution real-arcade interior reference photos (Round1 / Dave & Buster's / Two Bit Circus / classic 80s halls / cabinet imagery / ticket booth / prize counter / marquee). Saved to `.planning/research/mood-board/`.
- [x] **RES-04**: Phase 3 sub-spike resolves UD-1 by verifying GoPeak is runnable, documenting that it is not active in Codex's current MCP tool surface, proving Godot launch/debug plus a repeatable screenshot fallback, and deferring direct GoPeak screenshot/input-injection validation to QA-01 in Phase 10.
- ~~[ ] **RES-05**: Asset Library policy re-verification~~ — **STRICKEN 2026-05-04 per Phase 11 revision.** No Asset Library submission in v1; distribution is GitHub Releases via GitHub Actions workflow only.

### Design Mockups & Approval Gate (DESIGN)

- [x] **DESIGN-01** *(superseded by Phase 3 redirect, preserved historically)*: Phase 3 v0 produced palette/direction artifacts in `.planning/mockups/`; user rejected the painterly direction and the requirement was replaced by Phase 3.3's approved five dark flat-MD3 directions plus Phase 3.4 Stage 1 concept boards.
- [x] **DESIGN-02** *(superseded by UD-4 Option D, preserved historically)*: Typography gate resolved to Inter Variable Roman only in v1; Outfit, Inter Italic, Noto Sans, and JetBrains Mono are deferred/consumer-side.
- [x] **DESIGN-03** *(completed Phase 3.4 Plan 03)*: Full-fidelity Pulse 4-grid HTML mockup showed the implementation-priority direction across flat desktop, flat mobile, raised desktop, and raised mobile with realistic Control content and required state combinations. Approved at the Phase 3.4 final approval checkpoint.
- [x] **DESIGN-04** *(completed Phase 3.4 Plan 03)*: Mobile mockup evidence was included in the Pulse 4-grid with mobile sizing/tap-target audit notes; approved together with DESIGN-03.
- [x] **DESIGN-05** *(completed Phase 3.4 Plan 04)*: `DESIGN_TOKENS.md` finalized with desktop/mobile, flat/raised, and per-direction data-resource token blocks (color tokens, typography scale, spacing scale, corner radius/shape values, stroke widths, elevation/surface ramp, interaction state opacities). Committed before addon `.tres`/`.gd` styling work began.
- [x] **DESIGN-06**: Mockup approval gate is an explicit blocker — no `.tres` styling commits until approved. Maximum 3 revision rounds; if not approved by round 3, escalation discussion before proceeding.

### Theme Foundation (FOUND)

- [x] **FOUND-01** *(updated 2026-05-13 for autoload helper)*: `addons/neocade_theme/` directory layout: `fonts/`, `icons/`, and `scripts/` subdirs; addon root contains one canonical `neocade_theme.tres` runtime resource, runtime asset subfolders, and no README/CHANGELOG/LICENSE/VERSION metadata. `scripts/neocade_theme.gd` is the concrete, instantiable `@tool class_name NeoCadeTheme extends Theme`; `scripts/neocade_theme_option_button.gd` is the reusable style picker Control; `scripts/neocade_theme_autoload.gd` is the optional one-shot autoload helper that calls `NeoCadeTheme.apply_globally()`. Required font license text stays beside the redistributed font at `fonts/inter_ofl.txt`. Package docs live outside the addon (`README.md`, `docs/usage.md`, `CHANGELOG.md`, `LICENSE.md`, `VERSION`). **No per-direction `.gd` files. No per-style `.tres` files. No `_dev/` subfolder. No `themes/` subfolder. No `neocade_mobile_theme.tres`. No `plugin.cfg`.**
- [x] **FOUND-02** *(updated 2026-05-13 for source-color rework)*: `addons/neocade_theme/scripts/neocade_theme.gd` is `@tool class_name NeoCadeTheme extends Theme` — the **single, concrete, instantiable** class with **11 `@export` properties total**. **Top level (3):** `style: {BUBBLE, BURST, DAYBREAK, PULSE, SLATE, CUSTOM}`, `raised: bool`, `platform: {DESKTOP, MOBILE, AUTO}`. **Style Overrides group (6, under `@export_group("Style Overrides")`)**: `source_color: Color`, `corner_radius: int`, `spacing: int`, `raised_strength: int`, `focus_thickness: int`, `outline_width: int`. **Advanced group (2):** `use_runtime_popup_selection_icons: bool`, allowing users to disable runtime-generated PopupMenu check/radio icons and use static fallback icons, and `texture_cache: bool`, allowing users to retain loaded/generated textures across regenerations for faster live tweaking. The `_regenerate_theme()` method dynamically populates derived theme entry values from a per-style source-color role palette and resolves direction personality from `style`, not from a magic color lookup. `Style.CUSTOM` is manual/custom mode. Setters on exported properties trigger regeneration. The old `base_color` / `accent_color` API was intentionally removed without backwards compatibility. The class is **NOT abstract**.
- [x] **FOUND-03** *(updated 2026-05-13)*: `addons/neocade_theme/neocade_theme.tres` is the canonical `NeoCadeTheme` resource. Loading it into a Godot scene yields a `NeoCadeTheme` instance that automatically calls `_regenerate_theme()` to populate entries for ALL 37 scorecard Control rows plus the current runtime/editor/role variations from `addons/neocade_theme/scripts/neocade_theme.gd::TYPE_VARIATIONS`. Built-in styles cover Bubble, Burst, Daybreak, Pulse, and Slate. Current live registry counts: `BINDING_TABLE.size() == 150`, `TYPE_VARIATIONS.size() == 62`.

### Fonts (FONT)

- [x] **FONT-01**: Inter Variable Roman (`inter_variable.ttf` from Inter v4.x, OFL 1.1) bundled at `addons/neocade_theme/fonts/inter_variable.ttf` — **the ONLY font bundled in v1 (Option D, locked 2026-05-04).** Reserved Font Name preserved in the font metadata; imported as `FontFile.tres` referenced by `uid://`. `allow_system_fallback` left at default `true` so non-Latin scripts (Arabic, Hebrew, Indic, Thai, CJK, etc.) render via the user's OS system fonts.
- ~~[ ] **FONT-02**: Outfit Variable~~ — **STRICKEN 2026-05-04 per FONT-REVIEW.md.** Outfit dropped from v1 per user's consistency principle. Headings handled by Inter Variable at `opsz=32` + heavier `wght`. Outfit may be reconsidered at Phase 3 typography mockup gate (Variant B); if user picks Variant B there, this requirement is reinstated.
- ~~[ ] **FONT-03**: Noto Sans Variable~~ — **STRICKEN 2026-05-04 (Option D).** Not bundled in v1. Non-Latin scripts handled by Godot's `Font.allow_system_fallback=true` using the user's OS system fonts. README documents how to add Noto Sans (or any preferred coordinated cross-script font) for consumers who want designed-together cross-script harmony.
- ~~[ ] **FONT-04**: JetBrains Mono Variable~~ — **STRICKEN 2026-05-04 (Option D).** Not bundled in v1. CodeEdit / `[code]` BBCode is rare in shipped games. README documents the override pattern: `code_edit.add_theme_font_override("font", preload("res://your_mono.ttf"))`. Consumers who use code surfaces ship their preferred mono.
- [x] **FONT-05**: `addons/neocade_theme/fonts/inter_ofl.txt` ships Inter's Reserved Font Name notice + copyright block (single-font OFL, since Inter is the only bundled font). Surfaced in README install instructions for downstream projects to embed in their About/Credits.
- [x] **FONT-06**: Theme `default_font` is Inter Variable Roman; `default_font.fallbacks = []` (empty); `default_font.allow_system_fallback = true` (Godot 4.x default — explicit set for clarity in `.tres`). Heading type variations (HeaderLarge / HeaderMedium / HeaderSmall) use Inter at `opsz=32` + heavier `wght` (700-800) via `FontVariation`, NOT a separate display font. Per Pitfall 1.2 (type variations don't inherit fonts from base type), fonts are set explicitly for type variations.
- [x] **FONT-07**: Italic emphasis falls back to synthetic transform on Inter upright (Inter Italic deferred to v1.x per Conflict 1 revision). Body text rendering is acceptable; documented limitation in CHANGELOG.
- [x] **FONT-08**: Font import settings: Grayscale antialiasing, Light hinting, Auto subpixel positioning (per STACK + PITFALLS 5.5; verified for GL Compatibility renderer).
- [x] **FONT-09**: README documents three consumer-side font override patterns. **Opt-in fonts are NEVER bundled with NeoCade — Option D ships Inter only.** Consumers download and add what their audience needs:

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

  Override pattern:
  ```gdscript
  var theme = preload("res://addons/neocade_theme/neocade_theme.tres").duplicate()
  theme.style = NeoCadeTheme.Style.SLATE
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

- [x] **ICON-01**: Bespoke SVG icons authored at 32×32 reference, imported with `Scale = 2.0` and mipmaps/filtering configured in sidecars. Stored at `addons/neocade_theme/icons/`.
- [x] **ICON-02** *(closed across Phases 4, 6, and 7)*: Icon coverage maps 1:1 to Godot's hard-coded theme icon slots: Button check / radio / toggle / arrow_down / clear / close; OptionButton arrow; CheckBox/CheckButton on/off; Tree expand/collapse; TabBar/TabContainer increment/decrement/menu; ColorPicker preset/screen-pick/sample-bg/recent; FileDialog parent/folder/file/file-up/back/forward/reload; ScrollBar increment/decrement/grabber. Per FEATURES.md icon coverage list.
- [x] **ICON-03**: Icons are monochrome SVGs (single-color or with a small fixed accent palette mapped via Godot's icon `modulate` rather than baked color); allows tinting per accent role. *(Plan 04-03 locked the strict single-color `#FFFFFF` policy across the Button family; future icon plans (Phases 6/7) follow the same contract.)*
- [x] **ICON-04**: NO bundled Material Symbols / Lucide / Phosphor / external icon library (per STACK "What NOT to Use"). Texture2D-per-slot mismatch + bundle size cost. *(Plan 04-03 ships hand-authored SVGs only.)*

### Design System Tokens (TOKEN)

- [x] **TOKEN-01**: Color token system: 5-stop M3 tonal surface ramp (`surface` / `surface-container-low` / `surface-container` / `surface-container-high` / `surface-container-highest`) with friendlier aliases (base / secondary / panel / raised / overlay) per SUMMARY Conflict 2.
- [x] **TOKEN-02**: 8-hue accent palette + semantic role aliases (`role.primary` → chosen accent, `role.success`, `role.warning`, `role.danger`, `role.info`, plus decorative accents).
- [x] **TOKEN-03**: 3 text colors (`text.strong` / `text.default` / `text.muted`) verified WCAG 2.1 AA against every surface stop.
- [x] **TOKEN-04**: `surface.sunken` token is REJECTED for v1 (per SUMMARY Conflict 2); inputs are distinguished via focus/normal stylebox + corner radius.
- [x] **TOKEN-05**: 4-rung corner radius scale: `radius.none=0` / `radius.sm=4` / `radius.md=8` / `radius.lg=12`. Default 4px (godot-minimal-theme parity); 8px on PopupPanel/Window; 12px on dialogs.
- [x] **TOKEN-06**: 8-step spacing scale: `space.0` through `space.8` (4px base scale: 0/4/8/12/16/24/32/48 — desktop). Mobile overrides: +50% on `space.4` and above.
- [x] **TOKEN-07**: Stroke width set: 1px hairline default; 2px focus rings; 3px reserved for danger emphasis. Integer pixels only (no fractional widths under GL Compatibility).
- [x] **TOKEN-08**: Elevation model: color-only (tonal surface ramp). NO drop shadows in v1 (per SUMMARY Conflict 3 + FEATURES AF-13 + GL Compatibility issue #23640). Optional 1px lighter top-bevel border allowed on raised buttons.
- [x] **TOKEN-09**: Interaction state system uses M3 deterministic state-layer model: hover 8% overlay, focus 12% overlay + 2px outer ring in `role.primary`, pressed 12% overlay, dragged 16% overlay, disabled 38% text / 12% container. Reproducible from any base color.
- [x] **TOKEN-10**: Type scale spine (M3-derived; all UI surfaces use Inter — heading discrimination via `opsz` axis + `wght`, not via family switch): display-small 36 (Inter opsz=32 wght=800) / headline-small 24 (Inter opsz=32 wght=700) / title-large 20 (Inter opsz=24 wght=600) / title-medium 16 (Inter wght=600) / body-large 16 (Inter wght=400) / body-medium 14 (Inter wght=400) / body-small 12 (Inter wght=400) / label-large 14 (Inter wght=500) / label-small 11 (Inter wght=500) / code 13 (consumer-supplied mono via override pattern; theme provides no mono in v1 per Option D).

### Control Coverage (COV)

- [x] **COV-01**: All 35 user-facing Godot 4.6 Control classes are themed in v1 with full state coverage (normal/hover/pressed/focused/disabled where applicable). Per FEATURES.md Section 1.
- [x] **COV-02**: 7 BaseButton family classes themed: Button, CheckBox, CheckButton, OptionButton, MenuButton, ColorPickerButton, LinkButton. (Note: Editor-only FlatButton/FlatMenuButton/MainScreenButton/BottomPanelButton deferred to v1.x.)
- [x] **COV-03**: 5 text input/display classes themed: Label, RichTextLabel, LineEdit, TextEdit, CodeEdit. Caret + selection + placeholder colors configured. CodeEdit gutter (line numbers, breakpoint glyph, fold arrow) styled; syntax highlighting NOT in scope (per FEATURES AF-7).
- [x] **COV-04**: All range controls themed: HSlider, VSlider, ProgressBar, HScrollBar, VScrollBar, SpinBox.
- [x] **COV-05**: All list/tree controls themed: ItemList, Tree (16 styleboxes + 12 icons + ~26 constants — half-day work alone), TabBar, TabContainer, FoldableContainer.
- [x] **COV-06**: All popup-class controls themed as separate first-class types (per PITFALLS 1.7 — popups are separate Windows that don't inherit overrides): PopupPanel, PopupMenu, AcceptDialog, ConfirmationDialog, FileDialog, TooltipPanel, TooltipLabel, Window.
- [x] **COV-07**: Container-level controls themed (where chrome applies): Panel, PanelContainer, ScrollContainer, SplitContainer, MarginContainer constants. Layout-only Containers (HBox/VBox/Flow/Grid/Center) get separation constants only (per FEATURES AF-11).
- [x] **COV-08**: Advanced controls themed (basic v1 level): MenuBar, ColorPicker (16 bespoke icons), GraphEdit + GraphNode + GraphFrame.
- [x] **COV-09**: Visible focus indicator on every focusable Control (WCAG 2.1 SC 1.4.11): 2px outer ring in `role.primary`, drawn outside corner radius bounds, NOT replaceable by hover/pressed/checked styleboxes (per PITFALLS 1.1 focus-overlay-not-state behavior).
- [x] **COV-10**: Static coverage evidence package maps the showcase and shared `NeoCadeTheme._regenerate_theme()` coverage to the 37-row scorecard. Closed 2026-05-10 by user attestation that the slot-by-slot manual diff was performed against the Phase 1 enumeration; `.planning/qa/coverage-audit.md` remains the recorded artifact.

### Type Variations (TYPEVAR)

- [x] **TYPEVAR-01** *(updated 2026-05-09 after removing redundant SecondaryButton)*: 5 core runtime Button type variations: PrimaryButton, GhostButton, DangerButton, IconButton, FlatButton (role-semantic naming, not fill-semantic). Editor-specific button variations exist separately for Godot editor integration.
- [x] **TYPEVAR-02** *(reconciled 2026-05-07; live `TYPE_VARIATIONS` is authoritative)*: 6 Label type variations: HeaderLarge (Inter opsz=32 wght=800, display-small), HeaderMedium (Inter opsz=32 wght=700, headline-small), HeaderSmall (Inter opsz=24 wght=600, title-large), Caption (Inter wght=400, body-small), CodeLabel (consumer-supplied mono via override; theme defines the variation but ships no mono in v1), Kicker (Inter body weight, 12 desktop / 13 mobile; content owns uppercase/tracking because Godot 4.6 exposes no Label theme letter-spacing slot).
- [x] **TYPEVAR-03**: 1 RichTextLabel type variation: InfoText.
- [x] **TYPEVAR-04**: 2 Panel type variations: CardPanel, HeroPanel.
- [x] **TYPEVAR-05**: Fonts set explicitly on every type variation (per PITFALLS 1.2 — type variations DO NOT inherit fonts from base type, even when stylebox inheritance works).
- [x] **TYPEVAR-06** *(updated 2026-05-13)*: The 14 core runtime type variations and 9 Phase 13 opt-in role variations are documented in `.planning/MOBILE-DESIGN-SPEC.md` and `DESIGN_TOKENS.md` with concrete usage examples. Source of truth is `addons/neocade_theme/scripts/neocade_theme.gd::TYPE_VARIATIONS`: current live count is 62 total entries, including core runtime, role, and editor/integration variations.

### Mobile Variant (MOBILE)

- [x] **MOBILE-01** *(rewritten 2026-05-06d/f; updated 2026-05-08 for style architecture)*: Mobile sizing is a `@export platform=MOBILE` toggle on the single concrete `NeoCadeTheme` class — NOT a separate `.tres` file. Setting `platform=MOBILE` (or `platform=AUTO` on a mobile target) triggers `_regenerate_theme()` to use mobile-tuned constants (44pt iOS / 48dp Android tap targets, 16px body vs 14px desktop, +50% spacing on `space.4+` per Phase 8 mobile-sizing branch). The canonical resource exposes `platform`; consumers can duplicate `neocade_theme.tres`, choose any style, and switch platforms at instantiation or via `platform=AUTO` for runtime detection.
- [x] **MOBILE-02**: Tap targets ≥48px (Godot pixels at base scale 1.0) on every interactive Control in the mobile theme. Satisfies iOS HIG 44pt minimum + Material 3 48dp minimum simultaneously.
- [x] **MOBILE-03**: Body text 16px on mobile vs 14px desktop. Headings retain their desktop sizes (Inter at opsz=32 + wght=700-800; no scale change for headings).
- [x] **MOBILE-04**: Spacing scale +50% on `space.4` and above on mobile. Corner radii STAY IDENTICAL across desktop/mobile (brand identity, not platform-specific).
- [x] **MOBILE-05**: One mobile theme covers all Android density buckets (per CROSS-PLATFORM 3.5; Godot uses `content_scale_factor` + stretch modes, NOT density qualifiers). Authored values are dp-equivalent at base scale 1.0.
- [x] **MOBILE-06**: Tap-target audit script confirms every interactive Control in mobile theme is ≥48px; runs as part of Phase 8 acceptance.
- [x] **MOBILE-07**: `.planning/MOBILE-DESIGN-SPEC.md` documents every delta vs desktop with concrete numbers + rationale.
- [x] **MOBILE-08**: Mobile theme follows iOS HIG + Material 3 mobile guidance loosely (touch targets, type scale, accessibility minima) but retains the NeoCade arcade visual identity. NOT making Godot UI look native iOS or Android.

### Showcase Scene (SHOW)

- [x] **SHOW-01**: `res://showcase/showcase.tscn` is the showcase scene; applied as project main scene. Uses NeoCade Theme as project theme (or per-scene `theme` override if leak avoidance preferred). Completed Phase 9.
- [x] **SHOW-02** *(updated 2026-05-13)*: Showcase scene contains 10 sections: Buttons / Text Inputs / Numbers & Range / Selection & Lists / Containers & Layout / Dialogs & Popups / Advanced & Graph / Token Gallery / Coverage 37/37 / Role Variations. The canonical 37-row coverage strip remains unchanged; Role Variations are additive opt-ins.
- [x] **SHOW-03**: Realistic sample content per Control (Tree with multi-level items, ItemList with options, OptionButton with multiple options, etc.) per PITFALLS 10.1 — empty controls render invisibly.
- [x] **SHOW-04** *(updated 2026-05-13)*: `NeoCadeThemeOptionButton` dropdown switches built-in `NeoCadeTheme.Style` values from the canonical resource, sorted alphabetically with optional `None` last; `None` applies `null` to the target theme. The picker emits `theme_selected(theme, index)` after applying a selection. Per 2026-05-08 correction, the showcase UI is editor-authored in `showcase/showcase.tscn`; scripts are limited to `addons/neocade_theme/scripts/neocade_theme_option_button.gd` for the dropdown and `showcase/showcase.gd` for scoreboard Window open/close behavior plus runtime raised/platform controls.
- [x] **SHOW-05**: BBCode demo in RichTextLabel section showcasing inline color/weight/italic.
- [x] **SHOW-06**: `accessibility_name` set on every interactive Control in showcase (per PITFALLS 2.5 + 4.4 — minimum bar for screen-reader sanity in v1).
- [x] **SHOW-07**: Token Gallery section displays design tokens visually (color swatches with hex + role label, type scale samples, radius scale visualization).
- [x] **SHOW-08**: Coverage Verification strip displays "37/37 Controls themed ✓" or accurate count if any deferred.

### Cross-Platform Export (EXPORT)

- [x] **EXPORT-01**: Export presets/release workflow cover all 6 Godot 4.6 export targets: Windows, macOS, Linux, iOS, Android, Web/Browser. Manual per-target execution is deferred UAT where hardware/accounts are unavailable.
- [x] **EXPORT-02**: Per-target screenshot deck closed 2026-05-10 by user attestation; `.planning/qa/exports/<target>/` carries the workflow-side evidence and the user has performed the render-correctness review per the documented acceptance bar (render-correctness, not pixel-parity).
- [x] **EXPORT-03**: Web/Browser export specifics handled in export presets/release workflow: theme/font/icon resources are exported and no `SystemFont` dependency is used.
- [x] **EXPORT-04**: Project remains on GL Compatibility renderer (per CROSS-PLATFORM TL;DR Decision 1; avoids Godot 4.6 regressions #116090 iOS Mobile and #111729 Android Mobile).
- [x] **EXPORT-05**: Release workflow prepares CI import/open gates and Web export smoke path. Full live workflow run is manual release/UAT.
- [x] **EXPORT-06**: Manual Android validation closed 2026-05-10 by user attestation. Any post-release regressions become v1.0.1 follow-up.
- [x] **EXPORT-07**: Manual iOS validation closed 2026-05-10 by user attestation. macOS signing/notarization is performed by the user at release time using the workflow-built artifacts.
- [x] **EXPORT-08**: License compliance verified: the single bundled font (Inter Variable Roman) is OFL 1.1 — App Store + Play Store + Web embedding all legal. Reserved Font Name clause preserved in font metadata. Web export uses bundled font resources plus documented system fallback behavior.

### Accessibility (A11Y)

- [x] **A11Y-01**: WCAG 2.1 AA contrast verified for text-on-surface and interactive state combinations in `.planning/qa/contrast-audit.md`.
- [x] **A11Y-02**: Visible focus indicator on focusable Controls implemented as a 2px outer ring outside `corner_radius`; Phase 10 evidence documents the audit. Manual tab-walk screenshots remain deferred UAT.
- [x] **A11Y-03**: No information conveyed by color alone; showcase/status patterns use label/icon/color combinations.
- [x] **A11Y-04**: Color-blindness visual simulation closed 2026-05-10 by user attestation; token-level legibility documented in `.planning/qa/contrast-audit.md`.
- [x] **A11Y-05**: Multi-script label behavior is supported through Inter plus `Font.allow_system_fallback = true`, with optional consumer-supplied Noto Sans fallbacks documented for projects that need designed-together script harmony.
- [x] **A11Y-06**: `accessibility_name` set on every interactive Control in showcase (Godot 4.5 API, partial AccessKit integration in 4.6). Deeper screen-reader QA (VoiceOver/TalkBack) deferred to v1.x per UD-6.

### QA & Visual Regression (QA)

- [x] **QA-01**: Tooling baseline documented in `.planning/qa/tooling-baseline.md`; direct screenshot/input MCP validation remains part of deferred manual UAT.
- [x] **QA-02**: Visual QA screenshot matrix closed 2026-05-10 by user attestation; the user performed the manual visual review across the documented matrix.
- [x] **QA-03**: Manual tab-walk focused-state screenshot pass closed 2026-05-10 by user attestation.
- [x] **QA-04**: Dual-renderer screenshot pass closed 2026-05-10 by user attestation; GL Compatibility remains the ship target.
- [x] **QA-05**: Fresh-install dry-run closed 2026-05-10 by user attestation; checklist preserved at `.planning/qa/fresh-install-dry-run.md`.
- [x] **QA-06**: Theme inspector workaround: per PITFALLS 4.6 active issue #115500, do NOT edit theme resources through a Control inspector context menu. Safe authoring paths are the dedicated Theme editor, the 12 exported `NeoCadeTheme` properties on the canonical resource or consumer-saved resources, and formula edits in `addons/neocade_theme/scripts/neocade_theme.gd`. Documented in `docs/usage.md`.

### Distribution (DIST)

- [x] **DIST-01** (REVISED 2026-05-04): `.github/workflows/release.yml` exists. Single `workflow_dispatch` trigger with NO inputs (per PentaTile reference D-05-15). Manually triggered from Actions tab. Runs on `ubuntu-latest`. Uses `actions/checkout@v6` with `fetch-depth: 0` and `persist-credentials: true`. Job-level `permissions: contents: write`. Uses `github-actions[bot]` git identity.
- [x] **DIST-02**: `addons/neocade_theme/fonts/inter_ofl.txt` covers Inter (the single bundled font in v1, Option D) — Reserved Font Name notice block + copyright lines.
- [x] **DIST-03**: Root `LICENSE.md` for theme code plus root `CHANGELOG.md` entries for release preparation.
- [x] **DIST-04** (REVISED 2026-05-04): Version commit + tag + push: workflow rewrites root `VERSION` to new version, rewrites `CHANGELOG.md`'s `## [Unreleased]` heading to `## [<NEW_VERSION>] — <DATE>`, commits with `chore(release): v<NEW_VERSION>`, creates annotated tag `v<NEW_VERSION>`, runs `git push origin HEAD:main` + `git push origin "v<NEW_VERSION>"`.
- [x] **DIST-05** (REVISED 2026-05-04): Addon zip via `git archive --format=zip --prefix="neocade_theme-v<VERSION>/" -o "neocade_theme-v<VERSION>.zip" "v<VERSION>" -- addons/neocade_theme/ README.md docs/usage.md CHANGELOG.md LICENSE.md VERSION` — only tracked files at the tagged commit, with runtime addon files under `addons/neocade_theme/` and docs/licenses outside the addon folder (PentaTile pitfall #11 — excludes `.godot/`, build artifacts, untracked).
- [x] **DIST-06** (NEW): Auto-version-increment from root `VERSION` (single-line `MAJOR.MINOR.PATCH` file). Default bump: minor +1. If minor would exceed 9: major +1, minor=0. Patch always 0 (patches NOT supported by this scheme — same as PentaTile D-05-16). Sed-based rewrite preserves quote style if any.
- [x] **DIST-07** (NEW): CI gates run before version bump. Workflow downloads pinned `Godot_v4.6.x-stable_linux.x86_64`; runs headless project import (`godot --headless --path . --import --quit-after 2`) checking stderr for `^(ERROR|SCRIPT ERROR):` markers (PentaTile pitfall #1); opens `res://showcase/showcase.tscn` headless to verify showcase loads cleanly. Failure aborts release before any commits/pushes.
- [x] **DIST-08** (NEW): Godot Web export build. Workflow downloads matching Godot 4.6.x Web export templates (`Godot_v4.6.x-stable_export_templates.tpz`), installs them to `~/.local/share/godot/export_templates/4.6.x.stable/`, runs `godot --headless --export-release "Web" <output_dir>/index.html` against a committed `export_presets.cfg` "Web" preset (created as part of Phase 9 showcase work). Archives the resulting web build into `neocade_theme-showcase-web-v<VERSION>.zip`.
- [x] **DIST-09** (NEW): CHANGELOG slice extraction. awk-based extraction of the `[<NEW_VERSION>] — <DATE>` section from `CHANGELOG.md` into `release-notes-body.md`. Trim trailing blank lines. Fail fast (exit 1) if the slice is empty.
- [x] **DIST-10** (NEW): GitHub Release published via `softprops/action-gh-release@v3` (REQUIRES `ubuntu-latest` for Node 24 — PentaTile pitfall #5; do NOT pin to ubuntu-22.04). Attach BOTH `neocade_theme-v<VERSION>.zip` AND `neocade_theme-showcase-web-v<VERSION>.zip` as release assets. `body_path: release-notes-body.md`. `draft: false`, `prerelease: false`. Auth via implicit `GITHUB_TOKEN` from job-level `permissions: contents: write`.
- [x] **DIST-11** (NEW): Root `VERSION` exists as a single-line `MAJOR.MINOR.PATCH` file. This is the v1 source of truth for theme version (replaces `plugin.cfg` pattern from PentaTile — NeoCade has no `plugin.cfg` per Option D).
- [x] **DIST-12** (NEW): `addons/neocade_theme/fonts/inter_ofl.txt` ships Inter's Reserved Font Name notice + copyright (single-font OFL per Option D).
- [x] **DIST-13** (NEW): Root `LICENSE.md` covers theme code.
- [x] **DIST-14** (NEW): Root `CHANGELOG.md` exists with release-prep entries; the v1.0.0 heading will be generated by the release workflow on first dispatch.
- [x] **DIST-15** (NEW): `export_presets.cfg` committed at repo root with a "Web" export preset configured for `showcase/showcase.tscn` (showcase scene). Created as part of Phase 9 showcase deliverables. Required for DIST-08 web build.
- [x] **DIST-16** (NEW): GitHub Pages deployment of the Web build. Workflow uses `actions/upload-pages-artifact@v3` (upload the web export directory as a Pages artifact) followed by `actions/deploy-pages@v4` (deploy to the `github-pages` environment). Adds `pages: write` and `id-token: write` to the workflow's `permissions` block. **One-time repo-side setup required** (manual): GitHub repo settings → Pages → Source = "GitHub Actions".
- [x] **DIST-17** (NEW): README + release notes include the GitHub Pages "Try the showcase in your browser" placeholder/link pattern (`https://<owner>.github.io/<repo>/`). Live URL verification waits until release workflow dispatch.
- [x] **DIST-18** (NEW): COOP/COEP service worker verification closed 2026-05-10 by user attestation that the `crossOriginIsolated` check will be performed at release dispatch as part of the documented post-release smoke. The export preset and workflow are scaffolded; the live URL test is repository-side.
- [x] **DIST-19** (NEW): Repository visibility/plan check closed 2026-05-10 by user attestation; user is responsible for the public-repo (or Pro+) state at release dispatch.

### Documentation (DOCS)

- [x] **DOCS-01**: `DESIGN_TOKENS.md` is committed and contains finalized desktop + mobile token blocks sourced from approved Phase 3.4 mockups.
- [x] **DOCS-02**: `.planning/MOBILE-DESIGN-SPEC.md` documents every mobile delta vs desktop with concrete numbers + rationale (MOBILE-07 deliverable).
- [x] **DOCS-03**: `EDITOR-COVERAGE.md` maps which Editor surfaces are themed in v1 vs which fall back to default.
- [x] **DOCS-04**: `README.md` and `docs/usage.md` are comprehensive enough for v1 release preparation: project description; install path via GitHub Releases zip; usage examples; cross-platform notes; font override patterns; Web showcase artifact/Pages notes; license; and distribution flow.
- [x] **DOCS-05**: SOURCES.md is updated by Phase 1, 2, 3 source-dive spike outputs (RES-01..03) with new findings.

## v2 Requirements

Deferred to future release. Tracked but not in v1 roadmap.

### Light Mode

- **LIGHT-01**: Light color mode for desktop theme (`neocade_theme_light.tres`)
- **LIGHT-02**: Light color mode behavior for `platform=MOBILE` on future light styles or consumer custom resources — IF mobile-light is in v2 scope (per PROJECT.md note that mobile-light may stay deferred even in v2)

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
- **A11YV1X-02**: User-customizable contrast style (high-contrast variant)

### Future Features

- **FUTURE-01**: Theme animation system (would require GDScript on every Control — out of pure-Theme scope; explicit v2+ if pursued)
- **FUTURE-02**: CodeEdit syntax-highlight color styles (orthogonal to theme; v2+ as separate addon)

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

Phase mapping per ROADMAP.md (17 phase entries including redirected/historical Phase 3 and completed post-v1 Phases 12-13; originally seeded by SUMMARY.md's 11-phase plan, then updated by Phase 3 redirect and later architecture/visual-identity work). Every v1 REQ-ID maps to exactly ONE primary phase. Cumulative requirements (those whose work accrues across multiple phases) are assigned a primary phase with explicit cumulative reasoning.

| Requirement | Primary Phase | Cumulative Contributors | Status |
|-------------|---------------|------------------------|--------|
| RES-01 | Phase 1 (Source-Dive: godot-minimal-theme `.tres` dissection) | — | Complete |
| RES-02 | Phase 2 (Source-Dive: LDtk source UI mining) | — | Complete |
| RES-03 | Phase 3 (mood-board sub-spike) | — | Complete |
| RES-04 | Phase 3 (MCP tooling baseline sub-spike — UD-1) | — | Complete: fallback proven; direct GoPeak/input validation deferred to QA-01 |
| ~~RES-05~~ | _STRICKEN 2026-05-04 — no AssetLib in v1_ | — | _N/A_ |
| DESIGN-01 | Phase 3/3.4 (palette/direction mockups; v0 superseded, flat-MD3 replacement approved) | — | Complete / Superseded |
| DESIGN-02 | Phase 3/3.4 (typography gate; Inter-only v1 locked) | — | Complete / Superseded |
| DESIGN-03 | Phase 3.4 Plan 03 (Pulse full-fidelity 4-grid desktop evidence) | — | Complete |
| DESIGN-04 | Phase 3.4 Plan 03 (Pulse mobile 4-grid evidence) | — | Complete |
| DESIGN-05 | Phase 3.4 Plan 04 (`DESIGN_TOKENS.md` finalized pre-Phase-4) | — | Complete |
| DESIGN-06 | Phase 3.4 (gate enforcement) | — | Complete |
| FOUND-01 | Phase 4 (addon directory layout) | — | Complete |
| FOUND-02 | Phase 4 + 2026-05-08 style cleanup + 2026-05-09 Advanced popup-icon/cache toggles (single concrete `NeoCadeTheme` class + 12-property export surface) | Plan 04-05 atomic commit `d9e405a`; Phase 5 Kicker addition; 2026-05-08 `style` export consolidation; 2026-05-09 editor-menu icon consistency and performance work | Complete |
| FOUND-03 | Phase 4 + 2026-05-08 style cleanup (one canonical `neocade_theme.tres` with built-in styles) | — | Complete |
| FONT-01 | Phase 4 (Plan 04-02 bundled Inter Variable v4.0 with verified SHA256) | — | Complete |
| FONT-02 | Phase 4 | — | Stricken (UD-4 Option D 2026-05-04 — Outfit removed) |
| FONT-03 | Phase 4 | — | Stricken (UD-4 Option D 2026-05-04 — Noto Sans removed) |
| FONT-04 | Phase 4 | — | Stricken (UD-4 Option D 2026-05-04 — JetBrains Mono removed) |
| FONT-05 | Phase 4 (Plan 04-02 `addons/neocade_theme/fonts/inter_ofl.txt` with Reserved Font Name + 2016 Inter Project Authors copyright) | — | Complete |
| FONT-06 | Phase 4 (default_font + fallbacks wiring) | Plan 04-02 + Plan 04-05 binding table | Complete |
| FONT-07 | Phase 4 (synthetic italic policy + CHANGELOG note) | — | Complete |
| FONT-08 | Phase 4 (Plan 04-02 set Grayscale AA + Light hinting + Auto subpixel + mipmaps + system fallback in inter_variable.ttf.import for GL Compatibility per PITFALLS 5.5) | — | Complete |
| FONT-09 | Phase 4 (CJK exclusion + README override pattern) | — | Complete |
| ICON-01 | Phase 4 + Phases 6/7 (bespoke SVG icon set and import sidecars) | — | Complete |
| ICON-02 | Phase 4 (Plan 04-03 covers Button family + CheckBox/CheckButton on/off + OptionButton arrow + LineEdit clear + dialog close — 10 of ~25-40 icon slots; Tree/TabBar/ColorPicker/FileDialog/ScrollBar slots land in Phases 6/7) | Plan 04-05 atomic commit `d9e405a` | Complete for Phase 4 baseline (Plan 04-03 authored 10 SVGs + .import sidecars; Plan 04-05 atomic commit `d9e405a` wired the 10 SVGs to BINDING_TABLE icon recipes for CheckBox / RadioButton / CheckButton (`checked`/`unchecked` per Cycle 6 F4) / OptionButton.arrow / LineEdit.clear / PopupMenu menu indicators. Tree/TabBar/ColorPicker/FileDialog/ScrollBar icon slots remain Phase 6/7 polish per row scope.) |
| ICON-03 | Phase 4 (Plan 04-03 locked monochrome SVG policy: every Button-family icon strictly single-color #FFFFFF for predictable Godot icon `modulate` tinting; Cross-AI Cycle 1 MEDIUM fix). Pattern applies to all future icons | — | Complete |
| ICON-04 | Phase 4 (Plan 04-03 ships zero external icon library binaries — Material Symbols / Lucide / Phosphor all excluded per STACK Decision 5 + D-12; only hand-authored SVGs in `addons/neocade_theme/icons/`) | — | Complete |
| TOKEN-01 | Phase 3 (token values defined) | Phase 4 implementation | Complete |
| TOKEN-02 | Phase 3 | Phase 4 implementation | Complete |
| TOKEN-03 | Phase 3 (WCAG AA verification) | Phase 4 implementation + Phase 10 contrast audit | Complete |
| TOKEN-04 | Phase 3 (`surface.sunken` rejection) | Phase 4 implementation | Complete |
| TOKEN-05 | Phase 3 (radius scale) | Phase 4-8 implementation | Complete |
| TOKEN-06 | Phase 3 (spacing scale + mobile +50%) | Phase 4 + Phase 8 mobile branch | Complete |
| TOKEN-07 | Phase 3 (stroke widths) | Phase 4-8 implementation | Complete |
| TOKEN-08 | Phase 3 (no-shadows policy) | Phase 4 implementation | Complete |
| TOKEN-09 | Phase 3 (M3 state-layer model) | Phase 4-8 implementation | Complete |
| TOKEN-10 | Phase 3 (M3 type scale spine) | Phase 4-8 implementation | Complete |
| COV-01 | Phase 7 (37/37 scorecard desktop coverage closes here) | Phase 5 + Phase 6 (cumulative authoring) | Complete |
| COV-02 | Phase 5 (Core Controls — BaseButton family) | — | Complete |
| COV-03 | Phase 5 (Core Controls — text classes) | — | Complete |
| COV-04 | Phase 6 (range controls) | — | Complete |
| COV-05 | Phase 6 (lists/tree/tabs) | — | Complete |
| COV-06 | Phase 7 (popup-class as first-class types) | — | Complete |
| COV-07 | Phase 7 (container chrome closes here) | Phase 5 (Panel) + Phase 6 (Scroll/Split/Margin) | Complete |
| COV-08 | Phase 7 (MenuBar/ColorPicker/Graph) | — | Complete |
| COV-09 | Phase 5 (focus-as-outer-ring pattern established) | Phase 6 + 7 (applied); Phase 10 evidence | Complete |
| COV-10 | Phase 10 (verification against RES-01 enumeration) | Depends on Phase 1 RES-01 | Deferred manual/tooling UAT; static coverage evidence complete |
| TYPEVAR-01 | Phase 5 (6 Button variations) | — | Complete |
| TYPEVAR-02 | Phase 5 (5 Label variations) | — | Complete |
| TYPEVAR-03 | Phase 5 (RichTextLabel InfoText) | — | Complete |
| TYPEVAR-04 | Phase 5 (2 Panel variations) | — | Complete |
| TYPEVAR-05 | Phase 5 (fonts set explicitly per variation) | Phase 6 + 7 (any variations declared in later phases follow same pattern) | Complete |
| TYPEVAR-06 | Phase 8 + Phase 13 (`.planning/MOBILE-DESIGN-SPEC.md` + `DESIGN_TOKENS.md` synchronized with live `TYPE_VARIATIONS`) | Phase 5 + 6 + 7 (variation declarations and polish), Phase 13 (9 role variations), 2026-05-13 docs sync (live count 62) | Complete |
| MOBILE-01 | Phase 8 | — | Complete |
| MOBILE-02 | Phase 8 (≥48px tap targets) | — | Complete |
| MOBILE-03 | Phase 8 (16px body / heading parity) | — | Complete |
| MOBILE-04 | Phase 8 (spacing +50% / radii unchanged) | — | Complete |
| MOBILE-05 | Phase 8 (single mobile theme covers all density buckets) | — | Complete |
| MOBILE-06 | Phase 8 (tap-target audit script) | — | Complete |
| MOBILE-07 | Phase 8 (`.planning/MOBILE-DESIGN-SPEC.md`) | — | Complete |
| MOBILE-08 | Phase 8 (NeoCade identity preservation) | — | Complete |
| SHOW-01 | Phase 9 (`res://showcase/showcase.tscn` as project main scene) | — | Complete |
| SHOW-02 | Phase 9 + Phase 13 (10 sections / 37 scorecard rows + Role Variations) | Phase 13 adds opt-in role section without changing the 37-row scorecard | Complete |
| SHOW-03 | Phase 9 (realistic sample content) | — | Complete |
| SHOW-04 | Phase 9 (three-way theme toggle) | — | Complete |
| SHOW-05 | Phase 9 (BBCode demo) | — | Complete |
| SHOW-06 | Phase 9 (`accessibility_name` on every interactive Control) | — | Complete |
| SHOW-07 | Phase 9 (Token Gallery section) | — | Complete |
| SHOW-08 | Phase 9 (Coverage Verification strip) | — | Complete |
| EXPORT-01 | Phase 10 (all 6 targets export) | — | Complete for presets/workflow; manual execution deferred |
| EXPORT-02 | Phase 10 (per-target screenshot decks) | — | Deferred UAT |
| EXPORT-03 | Phase 10 (Web export specifics) | — | Complete |
| EXPORT-04 | Phase 10 (GL Compatibility lock) | — | Complete |
| EXPORT-05 | Phase 10 (CI workflow) | — | Complete for workflow preparation; live run deferred to release |
| EXPORT-06 | Phase 10 (Android validation; UD-5 conditional) | — | Deferred UAT |
| EXPORT-07 | Phase 10 (iOS validation; UD-5 conditional) | — | Deferred UAT |
| EXPORT-08 | Phase 10 (font license verification) | — | Complete |
| A11Y-01 | Phase 10 (WCAG 2.1 AA contrast audit) | — | Complete |
| A11Y-02 | Phase 10 (focus indicator audit) | Phase 5 (pattern), Phase 6 + 7 (applied) | Complete; manual tab-walk screenshots deferred |
| A11Y-03 | Phase 10 (no color-only information) | — | Complete |
| A11Y-04 | Phase 10 (CVD simulation pass) | — | Deferred UAT |
| A11Y-05 | Phase 10 (multi-script label test) | — | Complete for system-fallback/documentation evidence |
| A11Y-06 | Phase 10 (`accessibility_name` verification) | Phase 9 (set) | Complete; deeper screen-reader QA deferred |
| QA-01 | Phase 10 (MCP/QA tooling baseline reconfirmation; also Phase 3 sub-spike for initial baseline) | Phase 3 (GoPeak availability + screenshot fallback via RES-04) | Complete for documented baseline; direct screenshot/input deferred |
| QA-02 | Phase 10 (visual QA matrix) | — | Deferred UAT |
| QA-03 | Phase 10 (Tab-walk focus audit) | — | Deferred UAT |
| QA-04 | Phase 10 (dual-renderer screenshot pass) | — | Deferred UAT |
| QA-05 | Phase 10 (fresh-install dry-run) | — | Deferred UAT; checklist complete |
| QA-06 | Phase 10 (theme inspector workaround documented in `docs/usage.md`) | — | Complete |
| DIST-01 | Phase 11 (release.yml workflow scaffold) | — | Complete |
| DIST-02 | Phase 11 (auto-version-increment from `VERSION` file) | — | Complete |
| DIST-03 | Phase 11 (CI gates — headless import + showcase open) | — | Complete |
| DIST-04 | Phase 11 (version commit + tag + push) | — | Complete in workflow; live run deferred |
| DIST-05 | Phase 11 (addon zip via git archive) | — | Complete in workflow; live run deferred |
| DIST-06 | Phase 11 (auto-version-increment policy) | — | Complete |
| DIST-07 | Phase 11 (CI gates) | — | Complete |
| DIST-08 | Phase 11 (Godot Web export build + zip) | — | Complete in workflow; live run deferred |
| DIST-09 | Phase 11 (CHANGELOG slice extraction) | — | Complete |
| DIST-10 | Phase 11 (GitHub Release publish via softprops/action-gh-release@v3) | — | Complete in workflow; live run deferred |
| DIST-11 | Phase 4/root cleanup (`VERSION` file scaffold) — Phase 11 reads it | — | Complete |
| DIST-12 | Phase 4/root cleanup (`addons/neocade_theme/fonts/inter_ofl.txt`; addon zip ships it with the font) | — | Complete |
| DIST-13 | Phase 4/root cleanup (`LICENSE.md`; root repo ships it) | — | Complete |
| DIST-14 | Phase 4/root cleanup (`CHANGELOG.md`; populated continuously through phases; Phase 11 reads it) | — | Complete |
| DIST-15 | Phase 9 (`export_presets.cfg` Web preset; Phase 11 uses it) | — | Complete |
| DIST-16 | Phase 11 (GitHub Pages deployment of web build) | — | Complete in workflow; repo setting/live deploy deferred |
| DIST-17 | Phase 11 (README + release notes link to Pages URL) | — | Complete for docs; live URL deferred |
| DIST-18 | Phase 9 (head_include export preset) + Phase 10 (deploy verification — `crossOriginIsolated===true`) | — | Deferred release UAT |
| DIST-19 | Phase 11 prerequisite (repo public OR user has Pro+ plan) | — | Deferred manual release check |
| DOCS-01 | Phase 3 (`DESIGN_TOKENS.md` pre-Phase-4) | — | Complete |
| DOCS-02 | Phase 8 (`.planning/MOBILE-DESIGN-SPEC.md`) | — | Complete |
| DOCS-03 | Already complete (EDITOR-COVERAGE.md exists) | — | Complete |
| DOCS-04 | Phase 11 (README — closes DIST-04) | — | Complete |
| DOCS-05 | Phase 1 (initial SOURCES.md update) | Phase 2 + Phase 3.x (continuous update through source-dive spikes) | Complete / Ongoing |

**Coverage:**
- v1 requirements: 113 total (RES-5, DESIGN-6, FOUND-3, FONT-9, ICON-4, TOKEN-10, COV-10, TYPEVAR-6, MOBILE-8, SHOW-8, EXPORT-8, A11Y-6, QA-6, DIST-19, DOCS-5)
- Mapped to a primary phase or pre-roadmap artifact: 113
- Unmapped: 0 ✓
- Autonomous implementation/evidence complete through Phase 13; remaining unchecked items are intentionally deferred manual release/device/screen-reader checks, not missing implementation plans.
- Cumulative requirements (assigned primary phase + documented contributors): TOKEN-01..10, COV-01, COV-07, COV-09, COV-10, TYPEVAR-05, TYPEVAR-06, A11Y-02, A11Y-06, QA-01, DOCS-05

**Phase distribution (primary-phase counts):**
- Phase 1: 2 (RES-01, plus Phase 1 contribution to DOCS-05)
- Phase 2: 1 (RES-02)
- Pre-roadmap: 1 (DOCS-03)
- Phase 3: 19 (RES-03, RES-04, DESIGN-01..06, DOCS-01, TOKEN-01..10 design definitions)
- Phase 4: 16 (FOUND-01..03, FONT-01..09, ICON-01..04 — TOKEN-01..10 contribute as `NeoCadeTheme` formula/binding implementation)
- Phase 5: 8 (COV-02, COV-03, COV-09, TYPEVAR-01..05; plus Phase 5 contributions to COV-01 and COV-07)
- Phase 6: 2 (COV-04, COV-05)
- Phase 7: 4 (COV-06, COV-08, plus closing of COV-01, COV-07)
- Phase 8: 10 (MOBILE-01..08, DOCS-02, TYPEVAR-06)
- Phase 9: 8 (SHOW-01..08)
- Phase 10: 21 (COV-10, EXPORT-01..08, A11Y-01..06, QA-01..06)
- Phase 11: 21 (RES-05, DIST-01..19, DOCS-04)
- Phase 12: 0 v1 REQ-IDs (post-v1 signature visual moves; governed by locked success criteria)
- Phase 13: 0 v1 REQ-IDs (post-v1 role variations; governed by SC-13-1..3)

**Mockup approval gate:** Hard blocker between Phase 3.4 and Phase 4. No addon `.tres`/`.gd` styling commits permitted before Phase 3.4 final approval is logged and DESIGN_TOKENS.md is written.

**Open user decisions (UD-1..UD-6):** Tracked in-phase per ROADMAP.md "Coverage Summary" section. None block roadmap creation.

---
*Requirements defined: 2026-05-04*
*Last updated: 2026-05-13 — synchronized after Phase 12/13 completion and current implementation audit*
*Next update trigger: manual release/UAT decision or milestone archive*
