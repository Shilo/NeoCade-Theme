# NeoCade Theme

## What This Is

NeoCade is a Godot 4.6 native UI Theme system, distributed as a drop-in addon, that styles every built-in Control with a **flat Material Design 3 / MD3 Expressive aesthetic** — modern, colorful, expressive, accessibility-first, with optional "extruded flat 3D" raised variation per the Flat-3D Game UI pattern. It works universally across the Godot Editor and game runtime, and is designed to scale from desktop to mobile. **Architecture (updated 2026-05-09):** `@tool class_name NeoCadeTheme extends Theme` — single concrete class (NOT abstract; users can instantiate to make their own custom themes). Lives at `addons/neocade_theme/scripts/neocade_theme.gd`. The canonical resource lives at `addons/neocade_theme/neocade_theme.tres`. The class has 12 `@export` properties total: **Top level (3)** — `style: {BUBBLE, BURST, DAYBREAK, PULSE, SLATE, CUSTOM}`, `raised: bool`, `platform: {DESKTOP, MOBILE, AUTO}`. **Style Overrides group (7, collapsible @export_group("Style Overrides"))** — `base_color: Color`, `accent_color: Color`, `corner_radius: int`, `spacing: int`, `raised_strength: int`, `focus_thickness: int`, `outline_width: int`. **Advanced group (2)** — `use_runtime_popup_selection_icons: bool`, which allows consumers to disable the tiny runtime-generated PopupMenu check/radio icons if they prefer static SVG fallback over perfect menu-state color consistency, and `texture_cache: bool`, which keeps loaded/generated textures across regenerations for faster live tweaking when enabled. `style` is the explicit direction selector; built-in styles apply the approved direction values and hidden direction personality, while `Style.CUSTOM` is the manual/custom mode. Setters on exported properties trigger `_regenerate_theme()` which dynamically populates derived theme entry color/state values via `_get_base_color`-style formulas (ported from passivestar's `godot-minimal-theme` but driven by exports instead of `EditorSettings`). **Dark/light handling is luminance-derived** (NOT a separate toggle): `var is_light: bool = base_color.get_luminance() >= 0.5` is computed in `_regenerate_theme()`. v1 ships dark-first built-in styles; consumers wanting light mode set a light `base_color` in `Style.CUSTOM` or future light styles. **No production subclasses. No per-direction `.gd` files. No per-style `.tres` files.** Reusable scripts live under `addons/neocade_theme/scripts/`; `fonts/` and `icons/` remain asset subfolders. Pulse is the recommended starter style and showcase default, but it has no architectural privilege. Consumer toggles exports for flat/raised + desktop/mobile/AUTO variations. `platform=AUTO` auto-detects via `OS.has_feature("mobile")` at runtime; `DESKTOP` and `MOBILE` are forced sizes. Future variants plug in as new enum styles or consumer-authored `Style.CUSTOM` resources.

The theme is built primarily to power the author's upcoming game (codename: **VirtuCade**) — a 2D tile-based pixel-art online multiplayer game set inside a large interior arcade environment with interactive booths and mini-games — but is designed as a standalone, reusable addon for the Godot community. The theme name is **NeoCade**; VirtuCade is the consuming game, not the theme.

**Visual identity LOCKED 2026-05-04 (Phase 3 redirect):** Flat MD3 / MD3 Expressive language. **Hard rules:** no textures, no patterns, no embossing, no painterly/leather/wood/grunge backgrounds, no gradients on chrome. Solid colors + offset darker shape duplicates for depth on the raised variation only (extruded-flat per [hcgamestudios.itch.io](https://hcgamestudios.itch.io/flat-game-ui-for-mobile-games) and [fajrulaslim.itch.io](https://fajrulaslim.itch.io/ui-button-flat-design)). Anti-cyberpunk discipline preserved (no synthwave / no neon-noir / no dystopian). The earlier "neo/neon arcade" framing is **historical** — see Phase 3 redirect notes in ROADMAP.md and STATE.md.

## Core Value

A drop-in Godot 4.6 **flat MD3 / MD3 Expressive Theme system** that styles **every** built-in Control to a Godot Minimal Theme bar of feature-completeness, with a colorful, expressive, professional, accessible, modern visual identity — universal across editor and runtime — installable as a single addon. **v1 ships one canonical `.tres` theme resource** at `res://addons/neocade_theme/neocade_theme.tres`, of type `NeoCadeTheme`, with built-in styles for Bubble, Burst, Daybreak, Pulse, and Slate. Consumers toggle `style` / `raised` / `platform` / `base_color` / `accent_color` exports at use-time; the single `NeoCadeTheme` class regenerates all theme entries to match. Drift is structurally constrained because all variations come from one class and the same 12-property export contract. Architecture supports future styles and consumer-authored custom resources.

If everything else fails, this single deliverable must work: a polished, feature-complete `res://addons/neocade_theme/neocade_theme.tres` of type `NeoCadeTheme` that "just works" when applied to any Godot Control tree, with consumer-tunable `style` / `base_color` / `accent_color` / `raised` / `platform` exports.

## Requirements

### Validated

- **Exhaustive research & spiking is a first-class deliverable**: completed through Phase 3.x research, Phase 4-8 implementation research, and Phase 10 QA evidence artifacts.
- **Feature-complete Control coverage**: implemented across Phases 5-7 and surfaced in the Phase 9 showcase; Phase 10 coverage evidence package is committed.
- **Dark theme v1**: five approved dark built-in styles ship for v1; light mode remains v2 scope.
- **Universal usage**: addon is designed for editor and runtime usage through pure Theme resources; Phase 10 fresh-install and documentation evidence are committed.
- **HD resolution**: theme assets are HD/vector/font-based, not pixel-art UI.
- **Mobile-aware theme behavior**: implemented as `@export platform` on the single `NeoCadeTheme` class and documented in `.planning/MOBILE-DESIGN-SPEC.md`.
- **Bundled fonts**: Inter Variable Roman is the only bundled font; opt-in fallback/mono/italic patterns are documented.
- **Strict design system documentation**: `.planning/DESIGN_TOKENS.md` and `.planning/MOBILE-DESIGN-SPEC.md` are committed.
- **Mockup approval gate**: Phase 3.4 closed before Phase 4 implementation began; Pulse is the recommended starter and all five approved directions ship as built-in styles.
- **Theme editor authoring**: shared behavior lives in `neocade_theme.gd`; the canonical resource and consumer-saved `NeoCadeTheme` resources persist export values and intentional non-formula overrides as `.tres` files.
- **Type variations**: the live `TYPE_VARIATIONS` registry contains the documented core runtime variations plus editor-only integration variations.
- **Showcase scene + theme picker**: `showcase/showcase.tscn` is an editor-authored Control tree for the nine-section showcase, Godot-null-theme comparison, and direction picker. The reusable `class_name NeoCadeThemeOptionButton` at `addons/neocade_theme/scripts/neocade_theme_option_button.gd` lists built-in `NeoCadeTheme.Style` values alphabetically from the canonical resource, appends optional `None`, and applies selection to an exported target or scene root. `None` applies `null` to the target theme via the `allow_no_theme` / "Allow No Theme" export. The picker emits `theme_selected(theme, index)` after applying a theme; `None` emits `null`. `showcase/showcase.gd` is limited to showcase behavior glue such as scoreboard Window open/close handling. The showcase UI itself must not be created by a runtime builder script. Raised/platform variations remain `NeoCadeTheme` resource exports previewed through the inspector or consumer code, not showcase runtime controls.
- **MCP/QA and accessibility evidence**: autonomous QA evidence is committed for tooling, coverage, contrast, exports, and fresh-install dry-run. Manual screenshot/device/screen-reader UAT remains deferred by user instruction.

### Active

- [ ] **Visual identity distinctiveness initiative (post-v1)**: production-readiness audit on 2026-05-10 confirmed v1 is mechanically ship-ready, but the user flagged that the rendered output reads as a "generic dark Godot theme with an accent color" rather than a unique NeoCade identity in the lineage of LDtk. A spike + dedicated phase are scoped in ROADMAP.md "Visual Identity Distinctiveness" section. They run after v1 cut so the shipped foundation is not destabilized.
- [ ] **Release dispatch (owner action)**: confirm GitHub Pages source and release workflow permissions, then manually trigger `release.yml`. Phase 11 UAT for this is closed by user attestation 2026-05-10; the dispatch itself is a repository-side owner action and out of autonomous scope.

### Out of Scope (v1)

- **Light color mode** — deferred to v1.x or v2; arcades are dark-ambient, dark-first matches the brand and Godot editor default
- **Alternate palette variants** (e.g., `neocade_neon_magenta.tres`, `neocade_amber.tres`) — explicitly future work
- **Light color mode for mobile variant** — mobile theme follows the same dark-only constraint as desktop in v1; iOS/Android system theme integration deferred to v2
- **Native iOS/Android system look** — the mobile variant follows iOS HIG + Material 3 mobile guidance loosely (touch targets, type scale, accessibility) but retains the NeoCade arcade visual identity. We are NOT trying to make a Godot UI look like native iOS or Android.

> Note on mobile variant: previously listed as Out of Scope; **moved into v1 Active on 2026-05-04** per user constraint update. See Active requirements above and `.planning/research/CROSS-PLATFORM.md` for specs.
- **Cyberpunk aesthetic** — explicitly rejected; theme leans arcade/neo/modern, not dystopian/grimy/glitchy
- **Pixelated/retro-pixel theming** — VirtuCade's game content is pixel art, but the UI theme is HD and crisp
- **Editor plugin behaviors** (`plugin.cfg`, EditorPlugin scripts) — addon ships only the Theme resource and bundled fonts, no editor extensions
- **Animations beyond Godot's built-in StyleBox transitions** — micro-interactions out of scope unless they emerge naturally from theme properties
- **Custom shaders** for control rendering — keep within Theme/StyleBox primitives for portability
- **Audio assets** — no sound effects bundled with the theme
- **Localized strings** — theme styles UI; localization belongs to consuming projects
- **VirtuCade game content** — this project is the theme only; game development is separate
- **Source-of-truth status for the prototype image and research report attachments** — both are inspirational references to be challenged by research, not prescriptive inputs
- **Synthwave/vaporwave/scanline/glow-effect aesthetic** — research report leans into these; explicitly rejected as too cyberpunk-adjacent. NeoCade is bright, friendly, modern arcade — not 1980s sci-fi noir.
- **Pixel font for any UI element including logos** — research report suggested pixel font for titles; conflicts with the HD-only constraint. Theme stays crisp HD throughout.
- **Name "VirtuCade Theme"** — research report and prototype label the theme "VirtuCade Godot Theme"; the canonical theme name is **NeoCade**. VirtuCade is the consuming game.

## Context

**Engine & rendering:**
- Godot 4.6 (`config_version=5`)
- Renderer: GL Compatibility (broad device reach including web/mobile)
- Physics: Jolt (3D) — irrelevant to theme but documented
- .NET / C# enabled (`project/assembly_name="NeoCade Theme"`)

**Addon layout (decided):**
- `res://addons/neocade_theme/scripts/neocade_theme.gd` — `@tool class_name NeoCadeTheme extends Theme` (the theme-engine script; concrete, instantiable, NOT abstract; users can subclass or instance it directly to author custom themes). Defines 12 `@export` properties total — top level (3): `style`, `raised`, `platform`; Style Overrides group (7, under `@export_group("Style Overrides")`): `base_color`, `accent_color`, `corner_radius`, `spacing`, `raised_strength`, `focus_thickness`, `outline_width`; Advanced group (2): `use_runtime_popup_selection_icons`, `texture_cache` — and the `_regenerate_theme()` method that populates derived theme entry color/state values from those exports via formulas. Computes `var is_light: bool = base_color.get_luminance() >= 0.5` internally and branches all formulas accordingly. Lives under `scripts/` with the reusable addon scripts.
- `res://addons/neocade_theme/neocade_theme.tres` — canonical `NeoCadeTheme` resource. It defaults to the Pulse starter style and exposes all five built-in styles through the `style` export. There are no per-style `.tres` files.
- `res://addons/neocade_theme/scripts/neocade_theme_option_button.gd` — reusable `@tool class_name NeoCadeThemeOptionButton extends OptionButton` for editor-authored showcases and consumer projects. It lists built-in NeoCade styles alphabetically, appends optional `None`, and applies the selection to an exported target or the scene root. `None` applies `null` to the target theme. Consumers can connect to `theme_selected(theme, index)` after a selection is applied.
- ~~`res://addons/neocade_theme/{name}_neocade_theme.gd`~~ — **NOT NEEDED per simplification 2026-05-06e.** No per-direction `.gd` files. Each direction is purely data (a `.tres` with different `@export` values). The single `neocade_theme.gd` handles all regeneration logic.
- ~~`res://addons/neocade_theme/{name}_neocade_theme.tres`~~ — **REMOVED 2026-05-08.** Per-direction resources were consolidated into the canonical `neocade_theme.tres` plus `NeoCadeTheme.Style`.
- ~~`res://addons/neocade_theme/neocade_mobile_theme.tres`~~ — REMOVED per architecture revision 2026-05-04; mobile is a `@export platform=MOBILE` toggle on the single concrete class, not a separate file.
- `res://addons/neocade_theme/fonts/inter_variable.ttf` — single bundled font per UD-4 / Option D (Inter Variable Roman ONLY in v1)
- `res://addons/neocade_theme/icons/` — bespoke SVG icon set (~25-40 icons, per STACK research)
- `res://addons/neocade_theme/fonts/inter_ofl.txt` — OFL license file for bundled Inter; retained inside the addon because the font binary is redistributed there
- `res://showcase/showcase.tscn` — showcase scene, applies theme to a fullscreen Control root
- `res://icon.svg` — Godot project icon (default, may be rebranded later)

**Export targets (all required for v1):**
- Windows (desktop + mobile theme both work)
- macOS (desktop + mobile theme both work)
- Linux (desktop + mobile theme both work)
- iOS (mobile theme primary; OFL/Apache font licensing required for App Store)
- Android (mobile theme primary; density-bucket testing required)
- Web / Browser (highest-risk: font loading from `res://addons/`, GL Compatibility quirks, .tres path resolution under HTML5)

**Inspirations & references:**

| Source | Role | Location |
|--------|------|----------|
| godot-minimal-theme by passivestar | Quality bar for Control coverage and editor-friendliness — functionality benchmark, NOT visual copy | https://github.com/passivestar/godot-minimal-theme |
| LDtk map editor UI | Polish/quality benchmark for visual craft — NOT visual copy | https://ldtk.io/docs/general/editor-components/ |
| LDtk source code | UI implementation patterns to mine for ideas | `C:\Programming_Files\ldtk-master` (Haxe/Heaps; UI is in `src/electron.renderer/` and `res/atlas/`, `res/fonts/`) |
| Material Design 3 | Loose styleguide reference for spacing, contrast, accessibility, interaction states | https://m3.material.io/ |
| Real & virtual arcade aesthetics | Primary visual language — neon, colorful, inviting, slightly futuristic; NOT cyberpunk | (research must source) |
| Godot Theme docs | Authoritative API reference for implementation | https://docs.godotengine.org/en/stable/tutorials/ui/ |
| Godot control_gallery demo | Reference scope for showcase scene contents | https://github.com/godotengine/godot-demo-projects/tree/master/gui/control_gallery |
| `.planning/inputs/NeoCade-Research-Report.md` | User's prior research synthesis, NOT source of truth — researchers MUST challenge it. Known critiques to validate: (a) uses "VirtuCade Theme" name throughout — wrong, the theme is **NeoCade**; (b) leans into synthwave/vaporwave/scanlines/glow — adjacent to cyberpunk which is explicitly rejected; (c) suggests a pixel font for logos — conflicts with HD-only constraint; (d) name suggestions include "CyberCade" (rejected) and others — name is already locked as NeoCade. | `.planning/inputs/` |
| `.planning/inputs/NeoCade-Theme-Prototype.png` | Early design mockup. Strong palette, surface token system (Base/Secondary/Panel/Raised/Elevated), comprehensive Control showcase. User feels it leans too futuristic / not arcade-y enough. Researchers must produce variations that explore more arcade warmth (e.g., booth-style chrome, marquee glow, ticket-stub texture cues) while preserving the prototype's strengths. Also misnames the theme as "VirtuCade Godot Theme" — must be **NeoCade**. | `.planning/inputs/` |
| `.planning/research/SUMMARY.md` | **Project canon for original synthesis** — synthesized research findings, conflict resolutions (display font, surface tokens, shadows), original 11-phase roadmap seed, open user decisions UD-1 through UD-6. Superseded where later Phase 3.x artifacts, ROADMAP.md, or PROJECT.md key decisions explicitly revise it. | `.planning/research/` |
| `.planning/research/SOURCES.md` | **Project canon** — per-source dossier (10 sources). What was read, adopted, rejected, open. Mandated by Source Coverage commitment below. | `.planning/research/` |
| `.planning/research/EDITOR-COVERAGE.md` | **Project canon** — explicit map of which Editor surfaces are themed in v1 vs which fall back to default. Resolves ambiguity about "Universal Editor + Runtime usage." | `.planning/research/` |
| `.planning/research/CROSS-PLATFORM.md` + STACK.md + FEATURES.md + ARCHITECTURE.md + PITFALLS.md | **Project canon** — dimension reports backing the synthesis. Roadmapper and phase planners read these as authoritative for technical specifics. | `.planning/research/` |

**Tooling available:**
- Godot MCP (`mcp__godot__*`) — editor launch, scene CRUD, run/stop, debug output, screenshots
- Context7 MCP (`mcp__context7__*`) — current docs for Godot, Material 3, font libraries
- Web fetch / search — for LDtk patterns, arcade aesthetic research

**Process discipline:**
- Subagent-driven research at every major step (multiple parallel researchers per dimension) — see Research Charter section below for full mandate
- Subagent-driven design and implementation review (separate eyes on each artifact)
- Mockup approval gate is non-negotiable before implementation begins
- Heavy MCP-based screenshot QA — every Control class verified visually
- Research findings can override Pending Key Decisions; user's hard constraints cannot be overridden without explicit reconsideration (see Research Charter)

## Constraints

- **Tech stack**: Godot 4.6+ Theme resource (.tres). Pure Theme/StyleBox primitives — no custom shaders, no GDExtension, no plugin scripts in v1.
- **Distribution**: GitHub Releases + GitHub Pages via a single manually-triggered GitHub Actions workflow (modeled on [Shilo/PentaTile release.yml](https://github.com/Shilo/PentaTile/blob/main/.github/workflows/release.yml)). Each release: (a) attaches `neocade_theme-v<VERSION>.zip` (clean `addons/neocade_theme/` runtime folder plus root docs/licenses and `VERSION` — extract the `addons/` folder into your project); (b) attaches `neocade_theme-showcase-web-v<VERSION>.zip` (offline web build); (c) **auto-deploys the web build to GitHub Pages** at `https://<owner>.github.io/<repo>/` for instant browser-playable showcase. **No Godot Asset Library submission in v1.** No `plugin.cfg` (not an editor plugin — just a theme resource + assets). Version source: root `VERSION` (single-line `MAJOR.MINOR.PATCH`).
- **Resolution**: HD-first. Theme must look sharp at 1080p, 1440p, 4K, and DPI-scaled displays. No pixel-art textures in the theme itself.
- **Universal**: theme must work in both Editor (when applied as editor theme via add-on usage patterns) and Runtime (game UI). Both contexts are v1 must-haves.
- **Cross-platform exports**: theme + assets must work across all six Godot export targets — Windows, macOS, Linux, iOS, Android, Web/Browser. Asset paths must resolve from `res://addons/neocade_theme/` on every target. Fonts must load over Web export (no system-font fallback assumption). License compliance verified for iOS App Store (Inter Variable Roman is OFL 1.1). v1 requires screenshot QA on every target before release.
- **Mobile guidelines reference (loose, not strict)**: iOS Human Interface Guidelines + Android Material 3 mobile guidance inform the mobile variant's tap target sizes, type scale, and accessibility minima. We adopt their *minimums* (44pt iOS / 48dp Android tap targets, scaled type), not their visual language. NeoCade arcade identity persists across all platforms.
- **Aesthetic**: arcade-leaning, neo, neon, modern, colorful, professional, friendly. Explicitly NOT cyberpunk, NOT grimy, NOT dystopian. Closer to "vibrant arcade hall" than "Blade Runner street".
- **Accessibility**: WCAG 2.1 AA minimum for text contrast and interactive elements. Visible focus indicators. No color-only information.
- **Fonts**: v1 bundles Inter Variable Roman only (OFL 1.1). Full language coverage relies on Godot's `Font.allow_system_fallback = true` plus documented consumer-side fallback patterns for script-specific Noto Sans variants. Inter Italic, Outfit, Noto Sans, and JetBrains Mono are deferred or opt-in.
- **License**: theme intended to be open and shareable; all bundled assets must permit redistribution.
- **Coverage bar**: every Control class in the Godot 4.6 stable docs must have appropriate theme styling — measured against godot-minimal-theme's coverage list.
- **No runtime dependencies**: addon must work standalone (no required external libraries beyond Godot stdlib).

## Research Charter

**Research and spiking are first-class deliverables for this project — not background activities.** The user has explicitly mandated exhaustive subagent-driven investigation that **must challenge every prior input**, including the user's own attached research report, the prototype image, AND any decision currently sitting in this document marked as `Pending`. Research can — and should, where evidence warrants — propose a different direction.

### Sources to challenge (NOT to follow)

| Source | Status | What "challenge" means |
|--------|--------|------------------------|
| `.planning/inputs/NeoCade-Research-Report.md` | Reference, NOT source of truth | Verify every claim against current Godot 4.6 docs, real arcade reference imagery, accessibility math, and font license texts. Disagree freely. Already-flagged issues to validate: misnames theme as "VirtuCade"; recommends synthwave/scanline/glow direction; suggests pixel font for logos. |
| `.planning/inputs/NeoCade-Theme-Prototype.png` | Reference, NOT source of truth | Visually critique. Identify what works and what reads as cyberpunk/futuristic instead of arcade. Produce alternative directions for user comparison. |
| Any `Pending` Key Decision in this document | Defeasible | Research that surfaces strong counter-evidence may propose a reversal. The reversal must be a written recommendation with reasoning, not a silent override. |

### Sources NOT subject to override (user's hard constraints)

These cannot be overturned by research without explicit user reconsideration:

- The theme name is **NeoCade** (not VirtuCade, not CyberCade, not anything else)
- Aesthetic is **arcade-friendly, NOT cyberpunk** — no synthwave, no neon-noir, no dystopian
- Theme is **HD-only** — no pixel art in the theme itself
- Theme must be **feature-complete to godot-minimal-theme's bar** — coverage is non-negotiable
- Theme distributes as **1 canonical `.tres`** (`addons/neocade_theme/neocade_theme.tres`) + **1 theme-engine `.gd`** (`addons/neocade_theme/scripts/neocade_theme.gd` — `@tool class_name NeoCadeTheme extends Theme`, concrete and instantiable, 11 `@export` properties total) + **1 reusable UI control `.gd`** (`addons/neocade_theme/scripts/neocade_theme_option_button.gd` — `@tool class_name NeoCadeThemeOptionButton extends OptionButton`). `NeoCadeTheme.Style` is the explicit direction selector for Bubble, Burst, Daybreak, Pulse, Slate, or Custom. No per-direction `.gd` files, no per-style `.tres` files, no `_dev/`, no `themes/`, no editor plugin, and no separate mobile resource. Dark/light handling is luminance-derived from `base_color`.
- Mockup approval gate is mandatory before implementation
- **All external sources are inspiration / coverage-benchmark / pattern inventory — NEVER design spec.** This includes godot-minimal-theme, LDtk source, Material Design 3, real-arcade references, the user's prior research report and prototype. Source-dive phases (Phase 1, Phase 2, future Phase X spikes) produce *idea inventories* and *coverage matrices*. Design decisions live exclusively at the **Phase 3 mockup approval gate** + the **per-phase PLAN.md / .planning/DESIGN_TOKENS.md / .planning/MOBILE-DESIGN-SPEC.md artifacts**. No phase plan or executor may treat a source-dive output as authoritative for color values, typography, spacing, or visual identity. Translation sketches in source-dive artifacts must carry the prefix *"Inspiration sketch — Phase 3 mockup or Phase 5+ designer's call."* If a downstream agent ever quotes a source-dive value as a binding decision, it is wrong — refuse and redirect to the canonical Phase 3 / per-phase artifact.
- **v1 ships Inter Variable ONLY.** Per FONT-REVIEW.md (2026-05-04) and user's locked decision: a single bundled font (Inter Variable upright, OFL 1.1, ~810 KB). Headings differentiated by `opsz=32` axis + heavier `wght`, NOT a separate display font. **No Outfit, no Noto Sans, no JetBrains Mono in v1 bundle.** Non-Latin scripts (Arabic, Hebrew, Indic, Thai, CJK, etc.) render via Godot's `Font.allow_system_fallback = true` (default). README points consumers at **script-specific Noto Sans variants** (Noto Sans SC for Chinese, Noto Sans Arabic, Noto Sans Devanagari, etc. — all OFL 1.1, designed to harmonize with Inter) for opt-in visual consistency in their consuming project. CodeEdit / RichTextLabel `[code]` users override `theme.default_font` per-Control via documented README pattern. Inter Italic deferred to v1.x. **Matches godot-minimal-theme's bundle exactly (Inter only).** Total bundle ~810 KB. **No additional fonts will be bundled — consistency principle is non-negotiable.**
- Cross-platform: all 6 Godot export targets (Windows/macOS/Linux/iOS/Android/Web)
- ~~Mobile variant `neocade_mobile_theme.tres` is v1 must-have alongside desktop primary~~ **SUPERSEDED 2026-05-04 architecture revision and 2026-05-06e/f simplification:** mobile is a `@export platform=MOBILE` toggle on the single concrete `NeoCadeTheme` class — NOT a separate `.tres` file. Same v1 must-have requirement, different mechanism.

### Research workflow expectations

1. **Initial parallel research pass** (in flight as of project init): 4 parallel `gsd-project-researcher` subagents covering STACK, FEATURES, ARCHITECTURE, PITFALLS — outputs in `.planning/research/`. A `gsd-research-synthesizer` produces `.planning/research/SUMMARY.md`.
2. **Roadmap-level research/spike phases** (to be authored by `gsd-roadmapper`): the roadmap MUST include dedicated research and/or spike phases beyond the initial pass. Examples likely to appear: a deep visual-direction spike (multiple mockup variations for user comparison), a Control coverage audit spike, a font/typography validation spike, an accessibility math spike, an MCP-driven QA tooling spike. Implementation phases must be downstream of these.
3. **Per-phase pre-planning research** (workflow-level): `gsd-phase-researcher` runs before each phase plan is written, producing a `RESEARCH.md` consumed by `gsd-planner`.
4. **Mid-execution spikes are allowed and encouraged**: if implementation hits an unknown, the team pauses and spikes before proceeding — never guesses.
5. **Subagent peer review at every artifact boundary**: research → review; design → review; implementation → review. Multiple sets of eyes are mandatory, not optional.
6. **Findings are committed and dated**. Verbal/in-context conclusions are not durable and don't count as research output.

### Source coverage commitment

Every source the user named must end up catalogued — not just generally referenced. Each source gets a documented entry stating what was read, what was adopted, what was rejected (with reasoning), and what remains open. This catalogue is produced as `.planning/research/SOURCES.md` by the synthesizer, and updated as roadmap-level source-dive spike phases produce deeper findings.

**Sources requiring explicit catalogue entries:**

| Source | Type | Catalogue entry must capture |
|--------|------|------------------------------|
| godot-minimal-theme (passivestar) | Repo + theme.tres | Full enumeration of theme entries it defines (per Control × per state); interaction state transforms; accent strategy; what NeoCade adopts vs differs |
| LDtk UI docs (ldtk.io/docs/general/editor-components/) | Web docs | Component patterns, layout strategies, interaction conventions worth borrowing |
| LDtk source code (C:\Programming_Files\ldtk-master) | Source — "must read all of it for UI" per user | UI implementation patterns under `src/electron.renderer/`; tinted-sidebar/icon/font/atlas patterns under `res/`; lessons learned from CHANGELOG; what to adopt vs leave |
| Material Design 3 (m3.material.io) | Styleguide | Spacing/contrast/accessibility/state-system principles adopted; visual language explicitly NOT adopted |
| Real & virtual arcade aesthetics | Visual research | Concrete reference imagery and what makes it distinct from cyberpunk; specific design moves to adopt (marquee, ticket-stub, booth chrome, prize counter palette) |
| Godot Theme docs (4 specific URLs listed in Inspirations) | Authoritative docs | Authoritative Godot 4.6 Theme API behavior, type variations, theme editor workflow; verified via Context7 not training data |
| Godot controls gallery (godot-demo-projects/gui/control_gallery) | Demo project | Showcase scope reference: every Control to include, layout patterns |
| `.planning/inputs/NeoCade-Research-Report.md` | User's prior research | Claim-by-claim audit: which claims hold, which to reject, which to verify further. Known rejections: "VirtuCade Theme" name, synthwave direction, pixel fonts |
| `.planning/inputs/NeoCade-Theme-Prototype.png` | User's prior mockup | Element-by-element critique: tokens to keep (palette, surface ramp, control panel scope), elements to rework (chrome restraint, arcade warmth, naming) |

Each catalogue entry must be evidence-grade — citations, file paths, specific values — not vibes. The roadmap will include dedicated source-dive spike phases for the top-value sources (godot-minimal-theme `.tres` dissection, LDtk source code UI mining, real arcade visual reference collection) where the initial research pass alone won't be deep enough.

### What "exhaustive" means here

Concretely, "exhaustive" for this project includes (non-exhaustive list):

- Reading the actual `.tres` of `passivestar/godot-minimal-theme` to enumerate its theme entries — not just describing it
- Mining `C:\Programming_Files\ldtk-master/src/electron.renderer/` for actual UI patterns, not just looking at LDtk's website
- Computing real WCAG contrast ratios for every proposed text-on-surface and stateful combination
- Verifying current Godot 4.6 Theme API behavior via Context7 — not relying on training data
- Sourcing real arcade visual references (Round1, Dave & Buster's, Two Bit Circus, classic 80s halls) and articulating what makes them visually distinct from cyberpunk
- Producing 2+ palette options and 2+ mockup directions for user comparison, not a single "best guess"
- Auditing the user's prior research report claim-by-claim with citation-grade verification

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Dark color mode only for v1 | Matches arcade ambiance + Godot editor default; halves the design/test surface vs shipping light too; light deferred to v2. User explicitly delegated this call to my judgement on follow-up. | ✓ Good |
| ~~Inter + Noto Sans as primary font stack~~ | Superseded by UD-4 Option D / FONT-REVIEW.md: v1 ships Inter Variable Roman only; Noto Sans is documented as consumer-side opt-in for script-specific harmony. | ⊘ Superseded |
| Single canonical Theme resource at `res://addons/neocade_theme/neocade_theme.tres` | Reinstated 2026-05-08 in a cleaner form: one resource plus `NeoCadeTheme.Style`, while keeping the external `class_name NeoCadeTheme` script for Godot-native ergonomics. | ✓ Good |
| godot-minimal-theme is the feature-completeness benchmark, NOT visual reference | It remained the coverage bar through Phase 10; visuals stayed original NeoCade. | ✓ Good |
| LDtk is the quality/polish benchmark, NOT visual copy | Phase 2 mined implementation patterns; NeoCade did not copy LDtk's visual identity. | ✓ Good |
| Material Design 3 is a loose styleguide, NOT visual copy | Phase 3.1 produced MD3/MD3 Expressive research; implementation uses the accessibility/state/spacing vocabulary without becoming a Material clone. | ✓ Good |
| Showcase scene mirrors godot-demo-projects/gui/control_gallery scope | Phase 9 built the nine-section showcase covering the 37-row scorecard. | ✓ Good |
| Theme toggle in showcase: NeoCade ↔ null target theme (NOT light/dark) | Phase 9 implemented null-theme comparison plus the style picker. Raised/platform remain resource exports rather than showcase runtime controls. | ✓ Good |
| Mockup approval gate before implementation | Phase 3.4 closed before Phase 4 styling implementation began. | ✓ Good |
| Mobile-aware theme behavior elevated to v1 must-have | User constraint update: support mobile sizing in v1 with mobile-tuned scale, iOS HIG + Material 3 mobile guidance. ~~Originally framed as a separate `neocade_mobile_theme.tres` file~~ — **architecture revision 2026-05-04 changed this to a `@export platform=MOBILE` toggle; 2026-05-06e/f places that toggle on the single concrete `NeoCadeTheme` class (no separate file).** Alternate palettes remain v2. | ✓ Good |
| Cross-platform export support — all 6 Godot targets in v1 | User constraint: Windows, macOS, Linux, iOS, Android, Web/Browser. Web is highest-risk (font loading, path resolution); iOS requires OFL/Apache-only licensing. Screenshot QA on every target before v1 ships. | ✓ Good |
| ~~Two `.tres` files share one underlying token system~~ | Superseded by the single-class/canonical-resource architecture: desktop/mobile are `platform` export modes on the canonical `neocade_theme.tres` resource or consumer-saved `NeoCadeTheme` resources, not separate sibling `.tres` files. | ⊘ Superseded |
| Subagent research/review at every major step | Cross-AI review and phase-specific verification were used throughout planning/execution where the GSD workflow required them. | ✓ Good |
| MCP-driven QA (Godot MCP screenshots, Context7 docs) | Godot MCP smoke/testing supported implementation; final screenshot/device work is documented as deferred UAT. | ✓ Good |
| Cyberpunk aesthetic explicitly rejected | User specified "Neo/Neon/Modern, not Cyberpunk"; arcade-friendly, not dystopian | ✓ Good |
| Research report and prototype are inspirational refs only — NOT source of truth | User explicitly required research to challenge them. Specific critiques to enforce: theme is **NeoCade** (not VirtuCade); no synthwave/vaporwave/scanlines/glow; no pixel fonts; arcade warmth must come through stronger than the prototype shows. | ✓ Good |
| Theme aesthetic anchor: "vibrant arcade hall by day", not "neon noir alley by night" | Superseded/refined by the locked flat MD3 / MD3 Expressive + extruded-flat identity after the Phase 3 redirect. | ⊘ Superseded |
| Exhaustive research/spiking is a first-class deliverable | Research is mandated to challenge ALL prior inputs (the report, the prototype, and any Pending decision in this doc). The roadmap will include dedicated research/spike phases beyond the initial parallel pass. See Research Charter section. | ✓ Good |
| Research can override `Pending` Key Decisions; cannot override user's hard constraints | Hard constraints (theme name, anti-cyberpunk, HD-only, full Control coverage, addon distribution path, mockup gate, Inter-only v1 font bundle) require explicit user reconsideration to change. Pending decisions are defeasible by evidence. | ✓ Good |
| Dynamic `NeoCadeTheme` architecture feasibility — PASS (Phase 3.2 outcome, 2026-05-06; production simplified 2026-05-06e/f) | Strict feasibility gate (export-driven regeneration, subclass positive/negative controls, runtime saved-`.tres` application, serialization roundtrip, AUTO platform matrix) PASSED 6/6 in Godot 4.6.2 headless against representative Control subset. The durable production lesson is export-driven dynamic Theme regeneration + saved `.tres` use are feasible; the subclass contract itself was superseded by the single concrete class + data-only `.tres` model. Hybrid `@tool` static `.tres` generator retained as the fallback if full-matrix dynamic implementation reveals a blocker. Full 37-row scorecard coverage + icons + fonts + real-device validation remain Phase 4-10 obligations. Evidence: `.planning/research/GODOT-DYNAMIC-THEME-RESEARCH.md`, `.planning/spikes/dynamic-theme/VERIFY-RESULTS.md`, and the 2026-05-06e/f architecture decision. | ✓ Good |
| Theme directions approved — 5 peer candidates (Phase 3.3 outcome, 2026-05-06) | Approved at text-level after one naming revision (1/2 rounds): **Pulse** (#151A2E + #8BFF6A — dark saturated arcade), **Slate** (#111820 + #8BD3FF — modern minimal dark), **Bubble** (#FFF4FA + #7B1B55 — playful bubbly), **Daybreak** (#EAF7F1 + #006A68 — friendly daylight), **Burst** (#20112E + #FFD166 — expressive statement). Future subclass forms: `{Name}NeoCadeTheme`. All 5 base/accent pairs WCAG AA-verified (5.85:1 to 13.62:1; floor 4.5:1). All 5 PASS anti-cyberpunk + anti-texture + universal-axes-still-work + no-base-preselection + no-mockup/`.tres` filter audit. Direction Set = "Keep broad spread" per user 2026-05-06; flat/raised + desktop/mobile are universal `@export` axes per Phase 3.2, NOT direction-differentiation axes — every direction supports both modes through dynamic subclass behavior. **Base-direction designation deferred to Phase 3.4 approval gate.** Boardwalk Sunset hard-rejected; no name carryover. **SUPERSEDED 2026-05-06b by Phase 3.3 Revision Round 2/2** — Bubble + Daybreak migrated from light to dark palettes; see corrected row below. | ⊘ Superseded |
| ~~Subclass architecture refined to symmetric — every approved direction gets a named subclass class (2026-05-06b)~~ **SUPERSEDED 2026-05-06c by `@abstract` refinement** | Same-day refinement: instead of "concrete NeoCadeTheme superclass with the base direction's defaults baked in + 5 named subclasses (one of which is an empty alias)", the architecture moved to "`@abstract` NeoCadeTheme + 5 concrete named subclasses (none empty)". See row below. | ⊘ Superseded |
| ~~Subclass architecture finalized — `@abstract` base + concrete named subclasses (2026-05-06c)~~ **SUPERSEDED 2026-05-06e** | The `@abstract` base + 5 concrete subclasses model was a refinement step that was superseded the same week by the simpler single-class data-driven model. See 2026-05-06e row below. | ⊘ Superseded |
| ~~Architecture simplified to single concrete class + data-driven `.tres` per direction; tight 9-property `@export` set~~ | Superseded 2026-05-08 by the single-resource style architecture below. | ⊘ Superseded |
| Architecture consolidated to one canonical `.tres` + explicit `style` enum (2026-05-08 — current) | Keeps the proven single concrete `NeoCadeTheme` class and external `class_name` workflow, but replaces five peer resource files and base-color direction inference with one canonical `neocade_theme.tres` and `NeoCadeTheme.Style`. Built-in styles apply Bubble/Burst/Daybreak/Pulse/Slate exported values and hidden personality; `Style.CUSTOM` supports manual style values. | ✓ Good |
| Theme directions — Phase 3.3 Revision Round 2/2 + Phase 3.4 corrective addendum (2026-05-06b) | All five v1 directions are dark-mode (PROJECT.md Out of Scope: Light color mode (v1)). Final approved palettes: **Pulse** (#151A2E + #8BFF6A, 13.62:1), **Slate** (#111820 + #8BD3FF, 10.94:1), **Bubble** (#241326 + #FFB3E6, 10.74:1 — dark berry-aubergine + bubblegum pink, redesigned from light), **Daybreak** (#0B2420 + #76F2D1, 11.96:1 — dark forest-teal + fresh mint, redesigned from light), **Burst** (#20112E + #FFD166, 12.33:1). All 5 PASS WCAG AAA (>= 7:1; floor 4.5:1 AA). Direction identity, naming, personality intent, target use case, and DNA inputs are preserved across the revision; only Bubble + Daybreak palette values changed. **Phase 3.4 Plan 02 first execution (Codex) was rejected** because it produced color-only differentiation (single template, ten shape-language axes implicitly held constant). Plan 02 is REDIRECTED for re-execution by Claude Code under the new `direction-shape-language-spec.md` and corrective decisions D-28 (dark only), D-29 (per-direction shape-language tokens required to vary on ten axes), and D-30 (greyscale sufficiency test). 15 first-execution PNGs discarded. Evidence: `.planning/research/THEME-DIRECTIONS.md` Verification Log entry 2026-05-06b, `.planning/mockups/3.4/wcag-palette-audit.md`, `.planning/mockups/3.4/image-prompts/direction-shape-language-spec.md`, `.planning/phases/03.4-visual-direction-flat-extruded-flat-mockup-approval-gate/03.4-CORRECTIVE-ADDENDUM.md`. | ✓ Good |

## Evolution

This document evolves at phase transitions and milestone boundaries.

**After each phase transition** (via `/gsd-transition`):
1. Requirements invalidated? → Move to Out of Scope with reason
2. Requirements validated? → Move to Validated with phase reference
3. New requirements emerged? → Add to Active
4. Decisions to log? → Add to Key Decisions
5. "What This Is" still accurate? → Update if drifted

**After each milestone** (via `/gsd-complete-milestone`):
1. Full review of all sections
2. Core Value check — still the right priority?
3. Audit Out of Scope — reasons still valid?
4. Update Context with current state

---
*Last updated: 2026-05-08 — synchronized after Phase 11 autonomous closeout; active work reduced to manual release/UAT and milestone archive*
