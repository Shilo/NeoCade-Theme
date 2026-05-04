# Roadmap: NeoCade Theme

## Overview

NeoCade is a feature-complete coverage project, not a velocity project. The journey is: dissect prior-art (`godot-minimal-theme` `.tres`, LDtk source) → produce arcade-by-day visual direction with user-approved mockups (hard gate) → scaffold an `@tool`-driven token-to-`.tres` generator producing both desktop and mobile themes from a single source → author every Godot 4.6 user-facing Control class across all states (Phases 5-7) → fill mobile token deltas and audit tap targets (Phase 8) → showcase scene with three-way theme toggle (Phase 9) → exhaustive QA + cross-platform export validation across all 6 Godot targets (Phase 10) → GitHub Actions release pipeline (Phase 11) producing the addon zip + a Godot Web showcase build attached to a GitHub Release. 11 phases. **No Asset Library submission in v1.** Mockup approval is a hard blocker between Phase 3 and Phase 4. Mobile variant is v1 must-have. All 6 Godot export targets are v1 must-haves.

## Phases

**Phase Numbering:**
- Integer phases (1, 2, 3): Planned milestone work
- Decimal phases (2.1, 2.2): Urgent insertions (marked with INSERTED)

Decimal phases appear between their surrounding integers in numeric order.

- [x] **Phase 1: Source-Dive — godot-minimal-theme `.tres` Dissection** - Line-by-line enumeration of passivestar's `.tres` to set the feature-completeness bar (completed 2026-05-04)
- [x] **Phase 2: Source-Dive — LDtk Source UI Mining** - Mine `C:\Programming_Files\ldtk-master\src\electron.renderer\` for polished-UI implementation patterns (completed 2026-05-04)
- [ ] **Phase 3: Visual Direction Mockup + Approval Gate** - 3-step approval (palette → typography → full-fidelity desktop+mobile gallery), MCP/QA tooling baseline, real-arcade reference photo collection
- [ ] **Phase 4: Foundation — Tokens, Fonts, Icons, Scaffold + `@tool` Generator** - TokenSet single-source-of-truth, bundled fonts, bespoke icons, generator producing both `.tres` files
- [ ] **Phase 5: Core Controls — Buttons, Inputs, Labels, Panels (desktop)** - 7 BaseButton family + 5 text classes + Label/RichTextLabel + Panel/PanelContainer with type variations
- [ ] **Phase 6: Lists, Layout, Range — Tree, ItemList, Tabs, Containers, Sliders (desktop)** - Tree (16 styleboxes/12 icons) + ItemList + TabBar/TabContainer + range controls + container chrome
- [ ] **Phase 7: Dialogs, Popups, Advanced — Window, Popups, MenuBar, ColorPicker, Graph (desktop)** - Popup-class controls themed as first-class types + ColorPicker (16 icons) + Graph stack
- [ ] **Phase 8: Mobile Variant Authoring** - TokenSet.mobile overrides, generated `neocade_mobile_theme.tres`, tap-target audit, MOBILE-DESIGN-SPEC.md
- [ ] **Phase 9: Showcase + Token Gallery + Theme Toggle** - `res://main.tscn` with 9 sections + three-way toggle (NeoCade desktop ↔ NeoCade mobile ↔ Godot default)
- [ ] **Phase 10: QA + Cross-Platform Export Validation** - Dual-renderer screenshot pass, accessibility QA, per-target export validation across all 6 Godot targets
- [ ] **Phase 11: Distribution — GitHub Actions Release** - Single manually-triggered workflow: CI checks → auto-version-bump → commit/tag/push → addon zip via `git archive` → Godot Web export of showcase scene → publish GitHub Release with both artifacts + CHANGELOG slice as body. NO Asset Library submission.

**Optional buffer:** Cross-Platform Hardening Spike (4-8 hours, inserted as Phase 10.1 only if Phase 10 surfaces real-device regressions).

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
**Plans**: TBD

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
**Plans**: TBD

### Phase 3: Visual Direction Mockup + Approval Gate
**Goal**: Produce the user-approved visual direction — palette + typography + full-fidelity desktop and mobile Control gallery mockups — before any `.tres` styling work begins. Hard gate.
**Depends on**: Phase 1, Phase 2 (their findings inform the mockups)
**Requirements**: RES-03, RES-04, DESIGN-01, DESIGN-02, DESIGN-03, DESIGN-04, DESIGN-05, DESIGN-06, DOCS-01, DOCS-05 (continuous update); also covers TOKEN-01..10 design definition (token values finalized here, generator implementation in Phase 4)
**Success Criteria** (what must be TRUE):
  1. **Step 0 — Mood-board:** `.planning/research/mood-board/` contains 20-30 high-resolution real-arcade interior reference photos (Round1 / Dave & Buster's / Two Bit Circus / classic 80s halls / cabinet imagery / ticket booth / prize counter / marquee) with captions noting what each contributes to the brief; verified visually distinct from cyberpunk/synthwave references.
  2. **Step 0 — MCP tooling baseline:** UD-1 resolved via hands-on smoke test — `npx gopeak` (or chosen MCP server) launches Godot, captures an editor screenshot, and demonstrates input injection on the running editor; outcome documented in `.planning/research/`; if approved, project's MCP config is switched.
  3. **Step 1 — Palette approval:** 3 HTML/SVG palette mockups (A: Midnight Marquee, B: Boardwalk Sunset recommended, C: Cabinet Chrome) saved to `.planning/mockups/`; each mockup shows the 5-stop surface ramp + 8-hue accent palette + sample Buttons/Inputs/Panels at 1080p reference; user selects ONE at Step 1 approval.
  4. **Step 2 — Typography approval:** 1 typography mockup confirming Inter-only (Option D, locked 2026-05-04) renders the full M3 type-scale spine (display/headline/title/body/label/code) acceptably with the chosen palette applied. Mockup also includes a sample showing CJK / Arabic / Hebrew / Hindi system-fallback rendering for visual review. Optional Variant B (Inter + Outfit headings) available as override surface — only produced if user requests it at the gate. User confirms Option D OR overrides to a different option at Step 2 approval.
  5. **Step 3 — Full-fidelity gallery approval:** ONE desktop Control gallery HTML mockup (~1500 lines HTML+CSS) showing every Godot Control class with realistic content + every state visible (normal/hover/pressed/focused/disabled) AND ONE mobile-variant mockup at 360×800 + 768×1024 viewports with tap-target overlays (≥48px) visible, both rendered with the approved Step 1+2 selections; user APPROVES at Step 3 (max 3 revision rounds total — if not approved by round 3, escalation discussion before proceeding).
  6. **Token spec finalized:** `DESIGN_TOKENS.md` committed before Phase 4 starts, containing both desktop and mobile token blocks (color tokens with WCAG AA-verified contrast, M3 type scale with concrete sizes, 8-step spacing scale, 4-rung corner radius, integer stroke widths, color-only elevation per Conflict 3, M3 deterministic state-layer model per TOKEN-09).
  7. **Hard blocker enforcement:** No `.tres` styling commits exist on the branch when Phase 3 closes; Phase 4 cannot start until Step 3 user approval is logged in writing.
**Plans**: TBD
**UI hint**: yes

### Phase 4: Foundation — Tokens, Fonts, Icons, Scaffold + `@tool` Generator
**Goal**: Build the structural foundation — addon directory layout, bundled OFL fonts, bespoke SVG icons, and the `@tool` generator that produces both `neocade_theme.tres` and `neocade_mobile_theme.tres` from a single TokenSet block — so every subsequent phase populates ONE source of truth and drift between desktop and mobile is structurally impossible.
**Depends on**: Phase 3 (mockup approval is a hard prerequisite)
**Requirements**: FOUND-01, FOUND-02, FOUND-03, FONT-01, FONT-02, FONT-03, FONT-04, FONT-05, FONT-06, FONT-07, FONT-08, FONT-09, ICON-01, ICON-02, ICON-03, ICON-04; also implements TOKEN-01..10 in code (token values were defined in Phase 3)
**Success Criteria** (what must be TRUE):
  1. **Addon layout exists:** `addons/neocade_theme/` contains `fonts/`, `icons/`, `_dev/` subdirectories and root files `neocade_theme.tres`, `neocade_mobile_theme.tres`, `OFL.txt`, `LICENSE.md`, `README.md`, `CHANGELOG.md`. No `plugin.cfg` (per STACK Decision 5 — this is not an editor plugin).
  2. **Fonts bundled correctly:** Inter Variable upright (`Inter-Variable.ttf` from v4.x), Outfit Variable, Noto Sans Variable, JetBrains Mono Variable all present at `addons/neocade_theme/fonts/`; Reserved Font Names preserved (no binary renames); each imported as `FontFile.tres` referenced by `uid://`; combined `OFL.txt` lists Reserved Font Name notice + copyright block per font; import settings on every font are Grayscale antialiasing + Light hinting + Auto subpixel positioning (per STACK + PITFALLS 5.5 for GL Compatibility).
  3. **Icons bundled correctly:** ~25-40 bespoke SVG icons authored at 32×32 reference at `addons/neocade_theme/icons/`; every icon has `Scale = 2.0` and `Linear With Mipmaps` filter explicitly set in its `.import` sidecar (per STACK + PITFALLS); icons are monochrome SVGs (no baked color) so Godot's icon `modulate` can tint per accent role; no Material Symbols/Lucide/Phosphor/external library bundled.
  4. **`@tool` generator works:** `addons/neocade_theme/_dev/generate_themes.gd` is a `@tool` script with a single `TokenSet` constants block + `TokenSet.mobile` override block; running it inside the editor regenerates BOTH `neocade_theme.tres` and `neocade_mobile_theme.tres` from current TokenSet values; both `.tres` files round-trip cleanly (open → no errors → save → identical on disk).
  5. **Scaffolds are valid-but-empty:** Both generated `.tres` files declare ALL theme types matching FEATURES.md scope (35 user-facing Control classes + Window + tooltip types + 13 type variations); declared types are present even though entries may be empty at this phase; opening either file in Godot's Theme Editor shows every type listed; fonts and icons resolve via `uid://`.
  6. **CJK is documented (UD-2 default):** README documents the override pattern for consumers who need CJK — duplicate theme + append CJK font to `default_font.fallbacks` — explicitly NOT bundled in v1.
**Plans**: TBD

### Phase 5: Core Controls — Buttons, Inputs, Labels, Panels (desktop)
**Goal**: Author the desktop theme entries for the keystone Controls — every BaseButton-family class, every text input/display class, every Label class, every Panel class — through the TokenSet generator, so the most-used surface area of the theme is feature-complete.
**Depends on**: Phase 4
**Requirements**: COV-02, COV-03, TYPEVAR-01, TYPEVAR-02, TYPEVAR-03, TYPEVAR-04, TYPEVAR-05; cumulative contributors: COV-01 (begins here, completes in Phase 7), COV-07 (begins here, completes in Phase 7), COV-09 (focus indicator pattern established here, applied through Phase 7, verified in Phase 10), TYPEVAR-06 (documentation written across phases, finalized in Phase 8)
**Success Criteria** (what must be TRUE):
  1. **All 7 BaseButton-family Controls themed:** Button, CheckBox, CheckButton, OptionButton, MenuButton, ColorPickerButton, LinkButton each have full state coverage (normal/hover/pressed/focused/disabled where applicable) populated via TokenSet generator; every state combination renders correctly in the showcase (or temporary test scene) on GL Compatibility renderer; bespoke SVG icons for check/radio/toggle/arrow_down/clear/close + OptionButton arrow + CheckBox/CheckButton on/off load correctly.
  2. **All 5 text classes themed:** Label, RichTextLabel, LineEdit, TextEdit, CodeEdit each have normal/focus/read_only styleboxes + caret + selection + placeholder colors populated; CodeEdit gutter (line numbers, breakpoint glyph, fold arrow) is styled (syntax highlighting NOT in scope per FEATURES AF-7).
  3. **All 6 Button type variations + 5 Label type variations + 1 RichTextLabel + 2 Panel variations declared:** PrimaryButton / SecondaryButton / GhostButton / DangerButton / IconButton / FlatButton; HeaderLarge / HeaderMedium / HeaderSmall / Caption / CodeLabel; InfoText; CardPanel / HeroPanel — all 14 variations declared in `.tres`. Fonts are set EXPLICITLY on every variation (per PITFALLS 1.2 — type variations DO NOT inherit fonts from base, even when stylebox inheritance works); verified in a runtime scene, not just editor preview.
  4. **Panel + PanelContainer + SpinBox themed:** Panel and PanelContainer have base + variations; SpinBox themed end-to-end (line edit + arrows).
  5. **Focus stylebox is an OUTER ring, not a fill replacement (Pitfall 1.1):** Focus rendered as 2px ring drawn OUTSIDE corner radius bounds in `role.primary`; verified that focus remains visible under hover, pressed, AND checked combinations (Tab-walk a test scene with one of each); shadow alpha on every StyleBoxFlat is `shadow_size = -1` (the disable value per Godot #98162).
**Plans**: TBD

### Phase 6: Lists, Layout, Range — Tree, ItemList, Tabs, Containers, Sliders (desktop)
**Goal**: Author the desktop theme entries for the second tier of Controls — Tree (the heaviest single class with 16 styleboxes + 12 icons + ~26 constants), ItemList, the Tab family, container chrome, all range controls — through the TokenSet generator.
**Depends on**: Phase 5
**Requirements**: COV-04, COV-05; cumulative contributors: COV-01, COV-07, COV-09, TYPEVAR-06
**Success Criteria** (what must be TRUE):
  1. **Tree fully themed:** All 16 Tree styleboxes (panel + selected/cursor styles for focused/unfocused × hover/pressed) populated; all 12 Tree icons (expand/collapse + checked/unchecked + indeterminate + select arrow + sort arrows) bundled and wired; all ~26 Tree constants (icon_separation, item_margin, indent, scroll_speed, etc.) set; Tree renders correctly with multi-level test data including selection, hover, expanded/collapsed states, and a focused-cell screenshot at base scale.
  2. **ItemList + TabBar + TabContainer + FoldableContainer themed:** ItemList renders selected/cursor states correctly; TabBar and TabContainer share a coherent state model (active/inactive/hover/disabled tabs); increment/decrement/menu icons load on TabBar + TabContainer; FoldableContainer header chrome themed.
  3. **All 6 range controls themed:** HSlider, VSlider, ProgressBar, HScrollBar, VScrollBar all have grabber + track + (where applicable) tick styling; ScrollBar increment/decrement/grabber icons load.
  4. **Container chrome where applicable:** Panel, PanelContainer (already in Phase 5), ScrollContainer, SplitContainer, MarginContainer constants populated; layout-only Containers (HBox/VBox/Flow/Grid/Center) get only `separation` constants per FEATURES AF-11 (no chrome).
  5. **Generator round-trips:** TokenSet additions for this phase regenerate both `neocade_theme.tres` and `neocade_mobile_theme.tres` cleanly; mobile `.tres` reflects mobile overrides for any tokens consumed by these Controls (e.g. ScrollBar grabber width); no manual edits to either `.tres`.
**Plans**: TBD

### Phase 7: Dialogs, Popups, Advanced — Window, Popups, MenuBar, ColorPicker, Graph (desktop)
**Goal**: Author the desktop theme entries for popup-class Controls (which are separate Windows that don't inherit overrides per Pitfall 1.7) plus the advanced Controls (MenuBar, ColorPicker with 16 bespoke icons, Graph stack), completing desktop COV-01 100% Control coverage.
**Depends on**: Phase 6
**Requirements**: COV-06, COV-08; closes cumulative COV-01 (35/35 user-facing classes themed on desktop), COV-07 (container chrome complete), COV-09 (focus indicator on every focusable Control)
**Success Criteria** (what must be TRUE):
  1. **All 8 popup-class types themed as FIRST-CLASS theme types (Pitfall 1.7):** PopupPanel, PopupMenu, AcceptDialog, ConfirmationDialog, FileDialog, TooltipPanel, TooltipLabel, Window each have explicit theme entries — NOT relying on inheritance from PopupPanel or Window. Verified at runtime in a test scene by triggering each popup type and screenshotting it. Tooltip readability verified per Pitfall 4.3 (sufficient text-on-bg contrast on TooltipPanel/TooltipLabel).
  2. **MenuBar themed:** MenuBar normal/hover/pressed/disabled states populated; submenu (PopupMenu spawned from MenuBar) inherits from PopupMenu type rather than relying on parent Control overrides.
  3. **ColorPicker themed with all 16 bespoke icons:** ColorPicker preset / screen-pick / sample-bg / recent / hue-cycle / color-mode / shape-mode / etc. icons all loaded; ColorPickerButton popup uses the ColorPicker theme correctly.
  4. **Graph stack themed (basic v1 level):** GraphEdit grid + minimap + connection lines styled; GraphNode title + slot styling + selected state; GraphFrame theming if applicable. Acceptance is "renders cleanly with arcade identity" — GraphEdit is heavyweight, deeper polish deferred to v1.x if needed.
  5. **35/35 user-facing Control coverage achieved on desktop:** Every Control class enumerated in COV-01..08 has at least one custom theme entry on `neocade_theme.tres` (no engine fallback for any of them); verifiable by diffing entry count against the godot-minimal-theme enumeration produced in Phase 1 RES-01 (final verification happens in Phase 10's COV-10 check).
  6. **FileDialog parent/folder/file/file-up/back/forward/reload icons all load.**
**Plans**: TBD

### Phase 8: Mobile Variant Authoring
**Goal**: Fill the `TokenSet.mobile` override block in the generator so `neocade_mobile_theme.tres` is feature-complete with the desktop variant, audit that every interactive Control on mobile satisfies the ≥48px tap-target rule (iOS HIG 44pt + Material 3 48dp), and document every delta.
**Depends on**: Phase 7 (mobile overrides need every desktop entry to exist first)
**Requirements**: MOBILE-01, MOBILE-02, MOBILE-03, MOBILE-04, MOBILE-05, MOBILE-06, MOBILE-07, MOBILE-08, DOCS-02, TYPEVAR-06 (variation documentation finalized)
**Success Criteria** (what must be TRUE):
  1. **Mobile token overrides complete:** `addons/neocade_theme/_dev/generate_themes.gd`'s `TokenSet.mobile` block contains every override required (button heights → 48px floor, body text 16px vs desktop 14px, headings retain Outfit display sizes unchanged, spacing scale +50% on `space.4` and above, corner radii UNCHANGED across desktop/mobile per brand-identity rule); regenerating the generator produces a `neocade_mobile_theme.tres` whose every entry is either inherited from the shared TokenSet or overridden via `TokenSet.mobile`.
  2. **Tap-target audit passes:** A tap-target audit script (Phase 8 deliverable) iterates every interactive Control type in `neocade_mobile_theme.tres`, computes the rendered minimum tap rect (`minimum_size` + relevant content margins), and asserts ≥48px on both axes; script produces a pass/fail report; in v1 the report MUST show 100% pass.
  3. **`MOBILE-DESIGN-SPEC.md` committed:** Documents every delta vs desktop with concrete numbers and rationale (e.g. "Button.minimum_size.y: desktop 32 / mobile 48 — satisfies iOS HIG 44pt + Material 3 48dp simultaneously"); covers all 35 user-facing Control classes; references CROSS-PLATFORM.md per-target table; documents that one mobile theme covers all Android density buckets via Godot's `content_scale_factor` + stretch modes (NOT per-density `.tres` files).
  4. **Three-way theme toggle wired in test scene (or showcase if Phase 9 is started):** Cycling the toggle moves between NeoCade desktop ↔ NeoCade mobile ↔ Godot default by inline `theme_overrides` clearing + reassignment (per PITFALLS 10.3 clean state switching); tap targets visibly grow when switching to mobile; the visual identity (palette, typography, corner radii) is recognisably the same — no drift.
  5. **Mobile retains NeoCade arcade identity:** The mobile theme follows iOS HIG + Material 3 minimums for tap targets / type scale / accessibility but explicitly does NOT mimic native iOS or Android visual language (verified by visual review against Phase 3 mobile mockup approval).
**Plans**: TBD
**UI hint**: yes

### Phase 9: Showcase + Token Gallery + Theme Toggle
**Goal**: Build `res://main.tscn` — the showcase scene that visually proves every Godot Control is themed in v1, doubles as the QA forcing function, and includes a prominent three-way theme toggle so consumers can compare NeoCade desktop ↔ NeoCade mobile ↔ Godot default.
**Depends on**: Phase 8
**Requirements**: SHOW-01, SHOW-02, SHOW-03, SHOW-04, SHOW-05, SHOW-06, SHOW-07, SHOW-08
**Success Criteria** (what must be TRUE):
  1. **Showcase scene exists and is project main scene:** `res://main.tscn` is set as the project's main scene; uses NeoCade theme as project theme (or per-scene `theme` override if leak avoidance preferred — decision documented); opens to a fullscreen Control root with all 9 sections visible/scrollable.
  2. **9 sections present, covering all 35 user-facing Control classes + Token Gallery + Coverage Verification:** Buttons / Text Inputs / Numbers & Range / Selection & Lists / Containers & Layout / Dialogs & Popups / Advanced & Graph / Token Gallery / Coverage 35/35. Every Control has REALISTIC sample content (Tree with multi-level items, ItemList with options, OptionButton with multiple options, dialog content with realistic text, etc. — per PITFALLS 10.1, empty controls render invisibly and are not valid QA).
  3. **Three-way theme toggle is prominent and obvious:** Floating toggle button visibly larger than other Controls so its purpose is clear; cycles NeoCade desktop ↔ NeoCade mobile ↔ Godot default via inline `theme_overrides` (Pitfall 10.3 clean state switching); state-cycling produces no visual artifacts (no leftover styles from previous theme).
  4. **BBCode demo + accessibility wiring:** RichTextLabel section showcases inline color/weight/italic via BBCode (verifies font-system handles italic transform per FONT-07); `accessibility_name` is set on every interactive Control in the scene (Godot 4.5 API per PITFALLS 2.5 + 4.4 — minimum bar for screen-reader sanity in v1; deeper VoiceOver/TalkBack QA deferred to v1.x per UD-6).
  5. **Token Gallery + Coverage Verification visible:** Token Gallery section displays each design token visually — color swatches with hex + role label, type-scale samples in actual fonts, spacing/radius scale visualizations; Coverage Verification strip displays "35/35 Controls themed ✓" (or accurate count if any deferred — verifiable against Phase 7 close).
**Plans**: TBD
**UI hint**: yes

### Phase 10: QA + Cross-Platform Export Validation
**Goal**: Prove the theme is ship-ready — visually consistent across renderers and resolutions, accessibility-compliant, and rendering correctly across all 6 Godot 4.6 export targets (Windows, macOS, Linux, iOS, Android, Web/Browser).
**Depends on**: Phase 9
**Requirements**: COV-10, EXPORT-01, EXPORT-02, EXPORT-03, EXPORT-04, EXPORT-05, EXPORT-06, EXPORT-07, EXPORT-08, A11Y-01, A11Y-02, A11Y-03, A11Y-04, A11Y-05, A11Y-06, QA-01, QA-02, QA-03, QA-04, QA-05, QA-06; closes cumulative COV-09 (focus indicator verification)
**Success Criteria** (what must be TRUE):
  1. **MCP/QA tooling baseline reconfirmed (QA-01):** GoPeak (or chosen MCP server per UD-1 resolution) successfully captures editor + running-game screenshots and injects input on the current build; baseline test passes before any other QA work begins.
  2. **Visual QA matrix complete (QA-02, QA-03, QA-04):** Screenshot pass covering 9 showcase sections × 2 renderers (Forward+ + GL Compatibility) × 3 resolutions (1080p / 1440p / 4K) × 3 scale factors (100% / 150% / 200%); per-scene-section deck saved to `.planning/qa/screenshots/`. Tab-walk every Control in showcase + capture focused-state screenshot under hover/pressed/checked combinations (Pitfall 1.1 audit). Dual-renderer pass documents deltas; GL Compat is the ship target.
  3. **Coverage verification (COV-10):** Diff-check every theme entry on `neocade_theme.tres` against Phase 1's `godot-minimal-theme` enumeration; zero theme entries left default for any Control class enumerated in COV-01..08; COV-10 verification report committed.
  4. **Accessibility QA pass (A11Y-01..06):** WCAG 2.1 AA contrast computed via W3C luminance formula for every text-on-surface combo and every interactive state combo, table reproducible from token values; visible focus indicator audit passes (covers SC 2.4.7 + SC 1.4.11); deuteranopia/protanopia/tritanopia CVD simulation pass — legibility confirmed for status/role colors, no information conveyed by color alone; multi-script label test renders Latin + Cyrillic + Arabic + Hebrew + Devanagari labels correctly via fallback chain through Inter + Noto Sans; `accessibility_name` set on every interactive showcase Control verified.
  5. **Cross-platform export validation (EXPORT-01..08):** Per-target export builds exist for all 6 Godot targets (Windows, macOS, Linux, iOS, Android, Web/Browser); per-target screenshot deck saved to `.planning/qa/exports/<target>/` showing showcase scene rendering on each target (acceptance is render-correctness, not pixel-parity); Web export specifics handled — `.ttf` files in "Filters to export non-resources" OR wrapped in saved `FontFile.tres`, all theme/font/icon resources referenced by `uid://`, no `SystemFont` resource. Project remains on GL Compatibility renderer (avoids #116090 + #111729 4.6 regressions). CI workflow exports + smoke-tests on Windows + Linux + macOS + Web targets. Manual Android validation on ≥1 device (or noted-deferred per UD-5 with explicit changelog note); manual iOS validation on ≥1 device (or noted-deferred per UD-5 with explicit changelog note). License compliance verified for all 4 bundled fonts (Inter / Outfit / Noto Sans / JetBrains Mono — all OFL 1.1).
  6. **Fresh-install dry-run (QA-05):** Cloning `addons/neocade_theme/` into a clean Godot 4.6 project — theme applies as both project theme and per-scene theme; fonts and icons load correctly without any editor action; documented for README.
  7. **Theme inspector workaround documented (QA-06):** CONTRIBUTING.md notes the active issue #115500 — do NOT edit theme via Control inspector context; author via dedicated Theme tab + `@tool` generator only.
**Plans**: TBD

### Phase 11: Distribution — GitHub Actions Release
**Goal**: Ship v1.0.0 via a single manually-triggered GitHub Actions workflow. The workflow runs CI checks, auto-bumps the version, builds the addon zip via `git archive`, builds a Godot Web export of the showcase scene, and publishes a GitHub Release containing both artifacts + the CHANGELOG slice as release body. **No Asset Library submission in v1** — distribution is GitHub-Releases-only.
**Depends on**: Phase 10
**Requirements**: DIST-01, DIST-02, DIST-03, DIST-04, DOCS-04 (RES-05 + DIST-05 stricken — Asset Library not in scope)
**Reference workflow:** [Shilo/PentaTile release.yml](https://github.com/Shilo/PentaTile/blob/main/.github/workflows/release.yml) — adapt the same 11-step pattern. Notable adaptations: version source is `addons/neocade_theme/VERSION` (single-line file) instead of `plugin.cfg` (NeoCade has no `plugin.cfg` per Option D); add a Godot Web export step that produces a separate web-build zip uploaded as a release asset.
**Success Criteria** (what must be TRUE):
  1. **`.github/workflows/release.yml` exists and runs:** `workflow_dispatch` trigger with NO inputs (per PentaTile D-05-15 "if it cannot be automatic, remove it"); manual one-click release from the Actions tab.
  2. **Version source + auto-increment:** `addons/neocade_theme/VERSION` is a single-line file holding the current `MAJOR.MINOR.PATCH`; workflow auto-bumps minor +1 by default, major +1 with minor=0 if minor would exceed 9, patch always 0. (Patches NOT supported by this scheme — same as PentaTile D-05-16.)
  3. **CI checks gate the release:** workflow downloads pinned Godot 4.6.x Linux build, runs headless project import (`godot --headless --path . --import --quit-after 2`) checking stderr for `ERROR`/`SCRIPT ERROR` markers, opens `res://main.tscn` headless to confirm the showcase loads, and runs any test suite (Phase 10 deliverables permitting). Failure aborts release.
  4. **Version commit + tag + push:** workflow rewrites `addons/neocade_theme/VERSION` to the new version, rewrites `CHANGELOG.md`'s `[Unreleased]` heading to `[<NEW_VERSION>] — <DATE>`, commits with `chore(release): v<NEW_VERSION>` message, creates annotated tag `v<NEW_VERSION>`, pushes both commit and tag to `main`. Uses `github-actions[bot]` identity.
  5. **Addon zip via `git archive`:** workflow runs `git archive --format=zip --prefix="neocade_theme-v<VERSION>/" -o "neocade_theme-v<VERSION>.zip" "v<VERSION>" -- addons/neocade_theme/` — only tracked files at the tagged commit, only the addon directory. (Pitfall #11 from PentaTile: this excludes `.godot/`, build artifacts, untracked.)
  6. **Godot Web export build:** workflow downloads the matching Godot 4.6.x Web export templates, runs `godot --headless --export-release "Web" <output_dir>/index.html` against the project's web export preset, then archives the web build (`index.html` + `index.wasm` + `index.pck` + `index.js` + `index.audio.worklet.js` + supporting files) into `neocade_theme-showcase-web-v<VERSION>.zip`. The export preset must be committed to `export_presets.cfg` ahead of time as part of Phase 9 showcase work.
  6a. **GitHub Pages deployment of web build:** workflow uses `actions/upload-pages-artifact@v3` (upload the web export directory as a Pages artifact) and `actions/deploy-pages@v4` (deploy to the `github-pages` environment). Adds `pages: write` + `id-token: write` to the workflow's `permissions` block. One-time repo setup: GitHub Settings → Pages → Source = "GitHub Actions". Result: each release auto-deploys to `https://<owner>.github.io/<repo>/` — instant browser-playable showcase.
  7. **CHANGELOG slice extraction:** workflow extracts the `[<NEW_VERSION>] — <DATE>` section from `CHANGELOG.md` using awk pattern from PentaTile, writes to `release-notes-body.md`, fails fast if empty.
  8. **GitHub Release published:** uses `softprops/action-gh-release@v3` (requires `ubuntu-latest` for Node 24 — pitfall #5 from PentaTile); attaches BOTH `neocade_theme-v<VERSION>.zip` AND `neocade_theme-showcase-web-v<VERSION>.zip`; release body is the CHANGELOG slice; `draft: false`, `prerelease: false`. Auth via job-level `permissions: contents: write`.
  9. **README + supporting docs in place (DOCS-04, DIST-04):** Project description, install path (download zip from GitHub Releases → extract `addons/neocade_theme/` into your Godot project's `addons/`), usage examples, cross-platform support summary, mobile variant usage, accessibility notes, font override patterns (Noto Sans for non-Latin harmony, mono for CodeEdit, Inter Italic), editor-coverage map link (EDITOR-COVERAGE.md), license, attributions. **Includes a "Try the showcase in your browser" link to the GitHub Pages URL (`https://<owner>.github.io/<repo>/`) — auto-deployed on every release.**
  10. **License + initial CHANGELOG (DIST-02, DIST-03):** `addons/neocade_theme/OFL.txt` covers Inter (single bundled font per Option D); `LICENSE.md` for theme code (MIT or CC-BY recommended); `CHANGELOG.md` has a `[Unreleased]` section with v1.0.0 entry pre-populated documenting every shipped feature + every documented limitation (Inter Italic deferred, no Noto Sans bundled, no JetBrains Mono bundled, real-device mobile QA status per UD-5, screen-reader QA status per UD-6).
**Plans**: TBD

## Progress

**Execution Order:**
Phases execute in numeric order: 1 → 2 → 3 → 4 → 5 → 6 → 7 → 8 → 9 → 10 → 11

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1. Source-Dive: godot-minimal-theme | 5/5 | Complete    | 2026-05-04 |
| 2. Source-Dive: LDtk source | 5/5 | Complete | 2026-05-04 |
| 3. Visual Direction Mockup + Approval Gate | 0/TBD | Not started | - |
| 4. Foundation + `@tool` Generator | 0/TBD | Not started | - |
| 5. Core Controls (Buttons/Inputs/Labels/Panels) | 0/TBD | Not started | - |
| 6. Lists/Layout/Range | 0/TBD | Not started | - |
| 7. Dialogs/Popups/Advanced | 0/TBD | Not started | - |
| 8. Mobile Variant Authoring | 0/TBD | Not started | - |
| 9. Showcase + Token Gallery + Theme Toggle | 0/TBD | Not started | - |
| 10. QA + Cross-Platform Export Validation | 0/TBD | Not started | - |
| 11. Distribution | 0/TBD | Not started | - |

---

## Coverage Summary

**Total v1 requirements:** 99 (across 15 categories: RES-5, DESIGN-6, FOUND-3, FONT-9, ICON-4, TOKEN-10, COV-10, TYPEVAR-6, MOBILE-8, SHOW-8, EXPORT-8, A11Y-6, QA-6, DIST-5, DOCS-5)
**Mapped to phases:** 99 (DOCS-03 already complete pre-roadmap; all other 98 mapped to a primary phase with explicit cumulative reasoning where applicable)
**Unmapped:** 0

**Cumulative requirements (assigned to a primary phase, contributed to by others with documented reasoning):**
- COV-01 (35/35 coverage) — primary Phase 7; contributed by Phase 5 + Phase 6
- COV-07 (container chrome) — primary Phase 7; contributed by Phase 5 + Phase 6
- COV-09 (focus indicator on every focusable Control) — primary Phase 5 (pattern); contributed by Phase 6 + 7; verified Phase 10
- COV-10 (zero engine-default entries) — primary Phase 10; depends on Phase 1 RES-01 enumeration
- TYPEVAR-06 (all 13 variations documented) — primary Phase 8 (DOCS-02 finalization); contributed by Phase 5 + 6
- TOKEN-01..10 — design definitions Phase 3; generator implementation Phase 4
- DOCS-05 (SOURCES.md updates) — continuous Phase 1 + 2 + 3

**Mockup approval gate enforcement:** Hard blocker between Phase 3 and Phase 4 — no `.tres` styling commits permitted before Step 3 user approval is logged in writing.

**Open user decisions tracked in-phase (not roadmap blockers):**
- UD-1 (MCP server swap to GoPeak) — addressed in Phase 3 sub-spike
- UD-2 (CJK font bundling) — default decision (defer) confirmed in Phase 4 README
- UD-3 (stylebox authoring tooling) — `@tool` generator primary, Theme Editor verification — established in Phase 4
- UD-4 (Inter Italic v1 vs v1.x) — FINAL: Option D locked 2026-05-04. v1 ships Inter Variable Roman ONLY (~810 KB, matches godot-minimal-theme exactly). Inter Italic, Noto Sans, JetBrains Mono, Outfit — all deferred to v1.x or to consumer-side override pattern. Non-Latin scripts handled via Godot's `Font.allow_system_fallback=true`. User can override at Phase 3 typography mockup gate.
- UD-5 (real-device cross-platform testing matrix) — addressed in Phase 10 acceptance with `(if-real-device-available)` qualifier; ship-or-defer decision in Phase 10
- UD-6 (AccessKit / VoiceOver / TalkBack screen-reader integration) — `accessibility_name` only in v1 (Phase 9 SHOW-06); deeper QA deferred to v1.x

---
*Roadmap authored: 2026-05-04 from SUMMARY.md 11-phase plan + REQUIREMENTS.md traceability*
*Source of truth: `.planning/research/SUMMARY.md` "Implications for Roadmap" section*
*Mockup approval gate is non-negotiable per PROJECT.md hard constraint*
