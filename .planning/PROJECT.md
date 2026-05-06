# NeoCade Theme

## What This Is

NeoCade is a Godot 4.6 native UI Theme system, distributed as a drop-in addon, that styles every built-in Control with a **flat Material Design 3 / MD3 Expressive aesthetic** — modern, colorful, expressive, accessibility-first, with optional "extruded flat 3D" raised variation per the Flat-3D Game UI pattern. It works universally across the Godot Editor and game runtime, and is designed to scale from desktop to mobile. **Architecture (LOCKED 2026-05-04, simplified 2026-05-06e to single class + data-driven `.tres` per direction; `@export` set finalized 2026-05-06f):** `@tool class_name NeoCadeTheme extends Theme` — single concrete class (NOT abstract; users can instantiate to make their own custom themes). Lives at `addons/neocade_theme/neocade_theme.gd`. Has a tight set of 9 `@export` properties total: **Core (4)** — `base_color: Color`, `accent_color: Color`, `raised: bool`, `platform: {DESKTOP, MOBILE, AUTO}`. **Shape (5, collapsible @export_group("Shape"))** — `corner_radius: int`, `spacing: int`, `raised_strength: int`, `focus_thickness: int`, `outline_width: int`. The `@export` set is intentionally minimal and limited to **values that should be consistent across the entire theme** (global radius, global spacing, raised depth, focus emphasis, border weight). **Per-direction unique mood lives in Theme Editor entry overrides per `.tres`** (StyleBoxFlat per Control state with direction-specific bg_color/border_color/padding/content_margin/etc., plus icons), not in a long list of exports. Setters on every `@export` trigger `_regenerate()` which dynamically populates derived theme entry color/state values via `_get_base_color`-style formulas (ported from passivestar's `godot-minimal-theme` but driven by `@export` props instead of `EditorSettings`). **Dark/light handling is luminance-derived** (NOT a separate toggle): `var is_light: bool = base_color.get_luminance() >= 0.5` is computed in `_regenerate()`; dark is the default, `is_light` flags the deviation, and all conditional formulas branch on it (matches godot-minimal-theme's line-56 pattern, with renamed/inverted variable for clarity since dark is the project default). v1 ships 5 dark-base `.tres` files; consumers wanting light mode just set a light `base_color` (light variants are v2 scope unless explicitly added later). Convention: any future paired x/y `@export` values use `Vector2i` rather than separate scalar `_x`/`_y` properties. **No production subclasses.** Each approved theme direction is just a `.tres` file: `[gd_resource type="NeoCadeTheme" format=3]` with its specific `@export` values saved + its Theme-Editor-authored entry overrides serialized alongside. The 5 `.tres` differ in `@export` values AND in their per-Control Theme Editor overrides — no per-direction `.gd` files, no class hierarchy. **Flat folder layout 2026-05-06d:** all `.gd` and `.tres` files live directly at `addons/neocade_theme/` — no `_dev/` and no `themes/` subfolders (`fonts/` and `icons/` remain as their own subfolders since they are different asset categories). **No root `neocade_theme.tres`** — consumers always preload a specific named direction (`addons/neocade_theme/{name}_neocade_theme.tres`). At the Phase 3.4 approval gate, the user picks ONE of the N approved directions as the **recommended starter** ("most universal or pretty"); the recommended starter is the showcase scene's default theme + the README "try this first" suggestion — it has no architectural privilege and ships no separate file. **Custom consumer themes:** any consumer can create a new `.tres` of type `NeoCadeTheme` (`@tool` class, instantiable), set their own `@export` values, author entry overrides via Godot's Theme Editor panel, and use it as their project's theme. **v1 ships N `.tres` files at `addons/neocade_theme/{name}_neocade_theme.tres`** (one per approved direction) + 1 `.gd` file at `addons/neocade_theme/neocade_theme.gd`; with the Phase 3.4 Plan 02 gate closed, N = 5 (Pulse, Slate, Bubble, Daybreak, Burst) and Pulse is the recommended starter. Consumer toggles exports for flat/raised + desktop/mobile/AUTO variations. `platform=AUTO` auto-detects via `OS.has_feature("mobile")` at runtime; `DESKTOP` and `MOBILE` are forced sizes. Architecture supports an undefined number of theme resources; future variants (light mode, alternate palettes, additional themes) plug in as additional data `.tres` files or consumer-authored `NeoCadeTheme` resources.

The theme is built primarily to power the author's upcoming game (codename: **VirtuCade**) — a 2D tile-based pixel-art online multiplayer game set inside a large interior arcade environment with interactive booths and mini-games — but is designed as a standalone, reusable addon for the Godot community. The theme name is **NeoCade**; VirtuCade is the consuming game, not the theme.

**Visual identity LOCKED 2026-05-04 (Phase 3 redirect):** Flat MD3 / MD3 Expressive language. **Hard rules:** no textures, no patterns, no embossing, no painterly/leather/wood/grunge backgrounds, no gradients on chrome. Solid colors + offset darker shape duplicates for depth on the raised variation only (extruded-flat per [hcgamestudios.itch.io](https://hcgamestudios.itch.io/flat-game-ui-for-mobile-games) and [fajrulaslim.itch.io](https://fajrulaslim.itch.io/ui-button-flat-design)). Anti-cyberpunk discipline preserved (no synthwave / no neon-noir / no dystopian). The earlier "neo/neon arcade" framing is **historical** — see Phase 3 redirect notes in ROADMAP.md and STATE.md.

## Core Value

A drop-in Godot 4.6 **flat MD3 / MD3 Expressive Theme system** that styles **every** built-in Control to a Godot Minimal Theme bar of feature-completeness, with a colorful, expressive, professional, accessible, modern visual identity — universal across editor and runtime — installable as a single addon. **v1 ships 5 user-approved data-only `.tres` theme resources** at `res://addons/neocade_theme/`, all of type `NeoCadeTheme`: Pulse, Slate, Bubble, Daybreak, and Burst. Consumers toggle `raised` / `platform` / `base_color` / `accent_color` exports at use-time; the single `NeoCadeTheme` class regenerates all theme entries to match. Drift is structurally constrained because all variations come from one class and the same 9-property export contract. Architecture supports an undefined number of themes (extensible for v1.x and beyond).

If everything else fails, this single deliverable must work: a polished, feature-complete data `.tres` of type `NeoCadeTheme` (starting with `pulse_neocade_theme.tres`) that "just works" when applied to any Godot Control tree, with consumer-tunable `base_color` / `accent_color` / `raised` / `platform` exports.

## Requirements

### Validated

(None yet — ship to validate)

### Active

- [ ] **Exhaustive research & spiking is a first-class deliverable**: produce committed, dated, written research artifacts that exhaustively investigate every domain area (Godot Theme API, Control coverage, font/icon strategy, palette/typography options, accessibility math, LDtk patterns, godot-minimal-theme dissection, Material 3, real arcade visual language, identity-drift risks, distribution). Research is **mandated to challenge** the user's existing NeoCade-Research-Report.md, the NeoCade-Theme-Prototype.png, AND any pending Key Decisions in this document — and may propose overturning them with evidence. Multiple dedicated research/spike phases in the roadmap (not just one upfront pass). Findings MUST be written down before they influence design or implementation; verbal-only conclusions don't count.
- [ ] **Feature-complete Control coverage**: every built-in Godot Control has theme styling — match godot-minimal-theme's coverage bar
- [ ] **Dark theme v1**: single polished dark color mode (light mode deferred to v2)
- [ ] **Universal usage**: theme works correctly in both Godot Editor and game runtime
- [ ] **HD resolution**: theme is high-resolution and non-pixelated (sharp at HD/4K), regardless of VirtuCade's pixel-art game content
- [ ] **Cross-platform export support — all 6 Godot export targets**: Windows, macOS, Linux, iOS, Android, Web/Browser. Theme + every bundled asset (fonts, icons, .tres) must load and render correctly on each target. Web export is the highest-risk target (font loading, .tres path resolution, GL Compatibility quirks); iOS App Store requires font license compliance (OFL/Apache-only); Android density buckets must be tested. v1 verification includes a screenshot pass on every target before release.
- [ ] **Mobile-aware theme behavior (v1 must-have, NOT a separate `.tres` file)**: mobile is an `@export platform=MOBILE` toggle on the single concrete `NeoCadeTheme` class — NOT a separate `neocade_mobile_theme.tres` file. Setting `platform=MOBILE` (or `platform=AUTO` on a mobile device) triggers regeneration with mobile sizing: minimum 44pt (iOS HIG) / 48dp (Android Material) tap targets, larger default text sizes (16px body vs 14px desktop), denser-content guards relaxed, simplified typography scale, mobile-appropriate spacing (+50% on space.4+). Visual identity (palette, typography, corner radii) stays unified across all platforms because all variations come from the same class + data-resource contract. References iOS Human Interface Guidelines + Material 3 mobile guidance loosely.
- [ ] **Bundled fonts**: Inter Variable Roman is the only bundled font in v1 (OFL 1.1, ~810 KB). Non-Latin scripts rely on `Font.allow_system_fallback = true`, with README patterns for consumer-supplied script-specific Noto Sans variants. Inter Italic, Outfit, Noto Sans, and JetBrains Mono are deferred/consumer-side.
- [ ] **Strict design system documentation**: written specs for color tokens, typography scale, spacing scale, corner radii, stroke widths, elevation/shadow, motion (if any) — committed before implementation
- [ ] **Mockup approval gate**: design variation mockups produced and explicitly approved by user before any styling is committed to the .tres
- [ ] **Theme editor authoring**: shared behavior is generated by `addons/neocade_theme/neocade_theme.gd`; per-direction personality is authored in Godot's Theme Editor and persisted to `res://addons/neocade_theme/{name}_neocade_theme.tres`
- [ ] **Type variations**: use Godot theme type variations to provide semantic variants (e.g., primary/secondary/danger buttons, heading levels) where appropriate
- [ ] **Showcase scene**: `res://main.tscn` displays every Godot Control (mirroring the godot-demo-projects control_gallery scope) for visual QA
- [ ] **Theme toggle button**: showcase scene has a prominent floating toggle to switch between NeoCade theme and Godot default theme — bigger than other controls so its purpose is obvious
- [ ] **MCP-driven QA**: heavy use of Godot MCP for editor automation + screenshot capture; subagents review implementation against design spec
- [ ] **UX/UI styleguide adherence**: follow Material Design 3 loosely as a styleguide reference for spacing, contrast, accessibility (WCAG 2.1 AA minimum for text), and interaction states
- [ ] **Accessibility**: meet or exceed WCAG 2.1 AA contrast for text and interactive elements; focus indicators visible on all focusable controls; no information conveyed by color alone

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
- `res://addons/neocade_theme/neocade_theme.gd` — `@tool class_name NeoCadeTheme extends Theme` (the **only** `.gd` file in the addon; concrete, instantiable, NOT abstract; users can subclass or instance it directly to author custom themes). Phase 4 deliverable; defines 9 `@export` properties total — Core (4): `base_color`, `accent_color`, `raised`, `platform`; Shape (5, under `@export_group("Shape")`): `corner_radius`, `spacing`, `raised_strength`, `focus_thickness`, `outline_width` — and the `_regenerate()` method that populates derived theme entry color/state values from those exports via formulas. Computes `var is_light: bool = base_color.get_luminance() >= 0.5` internally (dark is default, `is_light` flags the deviation) and branches all formulas accordingly. Per flat-layout 2026-05-06d, lives at addon root. Convention: any future paired x/y `@export` values use `Vector2i`.
- `res://addons/neocade_theme/{name}_neocade_theme.tres` — **`.tres`-only** per-direction theme files (no per-direction `.gd`). Each file is `[gd_resource type="NeoCadeTheme" format=3]` with its direction's specific `@export` values saved plus any intentional Theme Editor entry overrides. **N files** where N = approved themes at Phase 3.4 gate; after Plan 02, N = 5. For the v1 approved set {Pulse, Slate, Bubble, Daybreak, Burst}: `pulse_neocade_theme.tres`, `slate_neocade_theme.tres`, `bubble_neocade_theme.tres`, `daybreak_neocade_theme.tres`, `burst_neocade_theme.tres`. The same `neocade_theme.gd` regenerates entries for all of them. Per flat-layout 2026-05-06d, no `themes/` subdir.
- ~~`res://addons/neocade_theme/{name}_neocade_theme.gd`~~ — **NOT NEEDED per simplification 2026-05-06e.** No per-direction `.gd` files. Each direction is purely data (a `.tres` with different `@export` values). The single `neocade_theme.gd` handles all regeneration logic.
- ~~`res://addons/neocade_theme/neocade_theme.tres`~~ — **REMOVED 2026-05-06d.** No root `.tres` ships in v1. Consumers preload a specific named direction `.tres` directly. The currently-existing scaffold at this path will be deleted in Phase 4.
- ~~`res://addons/neocade_theme/neocade_mobile_theme.tres`~~ — REMOVED per architecture revision 2026-05-04; mobile is a `@export platform=MOBILE` toggle on the single concrete class, not a separate file.
- `res://addons/neocade_theme/fonts/Inter-Variable.ttf` — single bundled font per UD-4 / Option D (Inter Variable Roman ONLY in v1)
- `res://addons/neocade_theme/icons/` — bespoke SVG icon set (~25-40 icons, per STACK research)
- `res://addons/neocade_theme/OFL.txt` — OFL license file for bundled Inter
- `res://main.tscn` — showcase scene, applies theme to a fullscreen Control root
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
- **Distribution**: GitHub Releases + GitHub Pages via a single manually-triggered GitHub Actions workflow (modeled on [Shilo/PentaTile release.yml](https://github.com/Shilo/PentaTile/blob/main/.github/workflows/release.yml)). Each release: (a) attaches `neocade_theme-v<VERSION>.zip` (the addon — extract into your project's `addons/`); (b) attaches `neocade_theme-showcase-web-v<VERSION>.zip` (offline web build); (c) **auto-deploys the web build to GitHub Pages** at `https://<owner>.github.io/<repo>/` for instant browser-playable showcase. **No Godot Asset Library submission in v1.** No `plugin.cfg` (not an editor plugin — just a theme resource + assets). Version source: `addons/neocade_theme/VERSION` (single-line `MAJOR.MINOR.PATCH`).
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
- Theme distributes as **1 `.gd`** (`addons/neocade_theme/neocade_theme.gd` — `@tool class_name NeoCadeTheme extends Theme`, concrete and instantiable, 9 `@export` properties total) + **N `.tres` files** at `addons/neocade_theme/{name}_neocade_theme.tres` — one per approved direction. Per simplification 2026-05-06e: no per-direction `.gd` files (each direction is data — `.tres` with different `@export` values + Theme Editor entry overrides for personality). The 9 `@export` properties cover values that should be consistent across the theme (palette, raised toggle, platform, global corner radius, global spacing, raised strength, focus thickness, outline width). Per-direction unique mood comes from Theme Editor entry overrides authored in each `.tres` (StyleBoxFlat per Control state with direction-specific bg/border/padding/etc.). `NeoCadeTheme` is concrete (NOT abstract) so users can author custom themes by instancing or subclassing. Per flat-layout 2026-05-06d: no `_dev/` or `themes/` subfolders for `.gd`/`.tres`; no root `neocade_theme.tres`. The recommended starter direction (picked at Phase 3.4 approval gate) is the showcase scene's default theme + the README "try this first" suggestion, but ships no separate file. Dark/light handling is luminance-derived from `base_color` (`var is_light = base_color.get_luminance() >= 0.5`; dark default, `is_light` flags deviation), no separate toggle, per godot-minimal-theme's proven pattern.
- Mockup approval gate is mandatory before implementation
- **All external sources are inspiration / coverage-benchmark / pattern inventory — NEVER design spec.** This includes godot-minimal-theme, LDtk source, Material Design 3, real-arcade references, the user's prior research report and prototype. Source-dive phases (Phase 1, Phase 2, future Phase X spikes) produce *idea inventories* and *coverage matrices*. Design decisions live exclusively at the **Phase 3 mockup approval gate** + the **per-phase PLAN.md / DESIGN_TOKENS.md / MOBILE-DESIGN-SPEC.md artifacts**. No phase plan or executor may treat a source-dive output as authoritative for color values, typography, spacing, or visual identity. Translation sketches in source-dive artifacts must carry the prefix *"Inspiration sketch — Phase 3 mockup or Phase 5+ designer's call."* If a downstream agent ever quotes a source-dive value as a binding decision, it is wrong — refuse and redirect to the canonical Phase 3 / per-phase artifact.
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
| ~~Single Theme resource at `res://addons/neocade_theme/neocade_theme.tres`~~ | Superseded 2026-05-06d/e/f by flat addon layout + single concrete class + 5 data `.tres` files at addon root. The existing scaffold `neocade_theme.tres` is deleted in Phase 4. | ⊘ Superseded |
| godot-minimal-theme is the feature-completeness benchmark, NOT visual reference | It's the gold standard for "every Control styled" — visuals must be original NeoCade | — Pending |
| LDtk is the quality/polish benchmark, NOT visual copy | Polished feel only — we build a distinct identity | — Pending |
| Material Design 3 is a loose styleguide, NOT visual copy | Reference for spacing/contrast/accessibility patterns; visual language is arcade, not Material | — Pending |
| Showcase scene mirrors godot-demo-projects/gui/control_gallery scope | Established reference for "every Control"; ensures coverage | — Pending |
| Theme toggle in showcase: NeoCade ↔ Godot default (NOT light/dark) | Communicates "this is what NeoCade adds" to users | — Pending |
| Mockup approval gate before implementation | User explicitly required this — must approve design variations before any .tres styling is committed | — Pending |
| Mobile-aware theme behavior elevated to v1 must-have | User constraint update: support mobile sizing in v1 with mobile-tuned scale, iOS HIG + Material 3 mobile guidance. ~~Originally framed as a separate `neocade_mobile_theme.tres` file~~ — **architecture revision 2026-05-04 changed this to a `@export platform=MOBILE` toggle; 2026-05-06e/f places that toggle on the single concrete `NeoCadeTheme` class (no separate file).** Alternate palettes remain v2. | ✓ Good |
| Cross-platform export support — all 6 Godot targets in v1 | User constraint: Windows, macOS, Linux, iOS, Android, Web/Browser. Web is highest-risk (font loading, path resolution); iOS requires OFL/Apache-only licensing. Screenshot QA on every target before v1 ships. | ✓ Good |
| Two `.tres` files share one underlying token system | Desktop and mobile themes derive from the same color/typography tokens; mobile overrides scales/touch-targets/density. Avoids visual identity drift between the two. | — Pending |
| Subagent research/review at every major step | User explicitly required exhaustive subagent-driven research and review | — Pending |
| MCP-driven QA (Godot MCP screenshots, Context7 docs) | User explicitly required heavy MCP usage | — Pending |
| Cyberpunk aesthetic explicitly rejected | User specified "Neo/Neon/Modern, not Cyberpunk"; arcade-friendly, not dystopian | ✓ Good |
| Research report and prototype are inspirational refs only — NOT source of truth | User explicitly required research to challenge them. Specific critiques to enforce: theme is **NeoCade** (not VirtuCade); no synthwave/vaporwave/scanlines/glow; no pixel fonts; arcade warmth must come through stronger than the prototype shows. | ✓ Good |
| Theme aesthetic anchor: "vibrant arcade hall by day", not "neon noir alley by night" | Concrete mental image to keep researchers/designers oriented. Bright, inviting, energetic — like walking into Round1 or Dave & Buster's, not Blade Runner. | — Pending |
| Exhaustive research/spiking is a first-class deliverable | Research is mandated to challenge ALL prior inputs (the report, the prototype, and any Pending decision in this doc). The roadmap will include dedicated research/spike phases beyond the initial parallel pass. See Research Charter section. | ✓ Good |
| Research can override `Pending` Key Decisions; cannot override user's hard constraints | Hard constraints (theme name, anti-cyberpunk, HD-only, full Control coverage, addon distribution path, mockup gate, Inter-only v1 font bundle) require explicit user reconsideration to change. Pending decisions are defeasible by evidence. | ✓ Good |
| Dynamic `NeoCadeTheme` architecture feasibility — PASS (Phase 3.2 outcome, 2026-05-06; production simplified 2026-05-06e/f) | Strict feasibility gate (export-driven regeneration, subclass positive/negative controls, runtime saved-`.tres` application, serialization roundtrip, AUTO platform matrix) PASSED 6/6 in Godot 4.6.2 headless against representative Control subset. The durable production lesson is export-driven dynamic Theme regeneration + saved `.tres` use are feasible; the subclass contract itself was superseded by the single concrete class + data-only `.tres` model. Hybrid `@tool` static `.tres` generator retained as the fallback if full-matrix dynamic implementation reveals a blocker. Full 37-row scorecard coverage + icons + fonts + real-device validation remain Phase 4-10 obligations. Evidence: `.planning/research/GODOT-DYNAMIC-THEME-RESEARCH.md`, `.planning/spikes/dynamic-theme/VERIFY-RESULTS.md`, and the 2026-05-06e/f architecture decision. | ✓ Good |
| Theme directions approved — 5 peer candidates (Phase 3.3 outcome, 2026-05-06) | Approved at text-level after one naming revision (1/2 rounds): **Pulse** (#151A2E + #8BFF6A — dark saturated arcade), **Slate** (#111820 + #8BD3FF — modern minimal dark), **Bubble** (#FFF4FA + #7B1B55 — playful bubbly), **Daybreak** (#EAF7F1 + #006A68 — friendly daylight), **Burst** (#20112E + #FFD166 — expressive statement). Future subclass forms: `{Name}NeoCadeTheme`. All 5 base/accent pairs WCAG AA-verified (5.85:1 to 13.62:1; floor 4.5:1). All 5 PASS anti-cyberpunk + anti-texture + universal-axes-still-work + no-base-preselection + no-mockup/`.tres` filter audit. Direction Set = "Keep broad spread" per user 2026-05-06; flat/raised + desktop/mobile are universal `@export` axes per Phase 3.2, NOT direction-differentiation axes — every direction supports both modes through dynamic subclass behavior. **Base-direction designation deferred to Phase 3.4 approval gate.** Boardwalk Sunset hard-rejected; no name carryover. **SUPERSEDED 2026-05-06b by Phase 3.3 Revision Round 2/2** — Bubble + Daybreak migrated from light to dark palettes; see corrected row below. | ⊘ Superseded |
| ~~Subclass architecture refined to symmetric — every approved direction gets a named subclass class (2026-05-06b)~~ **SUPERSEDED 2026-05-06c by `@abstract` refinement** | Same-day refinement: instead of "concrete NeoCadeTheme superclass with the base direction's defaults baked in + 5 named subclasses (one of which is an empty alias)", the architecture moved to "`@abstract` NeoCadeTheme + 5 concrete named subclasses (none empty)". See row below. | ⊘ Superseded |
| ~~Subclass architecture finalized — `@abstract` base + concrete named subclasses (2026-05-06c)~~ **SUPERSEDED 2026-05-06e** | The `@abstract` base + 5 concrete subclasses model was a refinement step that was superseded the same week by the simpler single-class data-driven model. See 2026-05-06e row below. | ⊘ Superseded |
| Architecture simplified to single concrete class + data-driven `.tres` per direction; luminance-derived dark/light; tight 9-property `@export` set with Theme Editor as primary personality channel (2026-05-06e finalized 2026-05-06f — current) | Replaces all earlier subclass models (symmetric 2026-05-06b, `@abstract` 2026-05-06c) with the simplest possible architecture matching godot-minimal-theme's proven pattern: **single `.gd` file** at `addons/neocade_theme/neocade_theme.gd` declaring `@tool class_name NeoCadeTheme extends Theme` (concrete, NOT abstract — users can instantiate to author custom themes). Each approved theme direction is purely data — a `.tres` file `[gd_resource type="NeoCadeTheme" format=3]` with its specific `@export` values saved + its Theme-Editor-authored entry overrides serialized alongside. **No per-direction `.gd` files, no class hierarchy, no subclasses.** `@export` set is 9 properties total — **Core (4):** `base_color`, `accent_color`, `raised`, `platform`. **Shape group (5):** `corner_radius`, `spacing`, `raised_strength`, `focus_thickness`, `outline_width`. The `@export` set is intentionally minimal and limited to **values that should be consistent across the entire theme**; per-direction unique mood lives in Theme Editor entry overrides per `.tres` (StyleBoxFlat per Control state with direction-specific bg/border/padding/content_margin/icons), NOT in a long list of exports. Naming convention per user direction 2026-05-06f: drop redundant prefixes (`corner_radius_base` → `corner_radius`, `base_spacing` → `spacing`); intuitive verbs (`raised_offset` → `raised_strength`); `@export_group("Shape")` not `("Shape Language")`; pair x/y values as `Vector2i` (none in current 9 — convention noted for future). **Dark/light handling is luminance-derived** (NOT a separate `light_mode` toggle): `var is_light: bool = base_color.get_luminance() >= 0.5` is computed at every regeneration; dark is the project default and `is_light` flags the deviation; all conditional formulas branch on it (godot-minimal-theme line-56 pattern with renamed/inverted variable). v1 ships 5 dark-base `.tres` files (per Phase 3.3 Revision Round 2/2 approval); consumers wanting light mode just set a light `base_color` and the theme auto-adapts (light variants formally deferred to v2 per PROJECT.md Out of Scope unless explicitly added). **Flat addon layout** (carried forward from 2026-05-06d): all `.gd`/`.tres` at `addons/neocade_theme/` root; no `_dev/` or `themes/` subfolders; no root `neocade_theme.tres`. `fonts/` and `icons/` remain as their own subfolders for asset organization. Per-direction shape personality (Pulse arcade-tight ~5px radius, Slate iOS-pill ~11px, Bubble bubbly ~18px, Daybreak airy-soft ~13px, Burst bold ~16px, plus categorical differences in chip shape / brand mark / button anatomy / focus halo / etc.) is captured by **(a)** the shared `@export` shape values per `.tres` for global tendencies AND **(b)** Theme Editor entry overrides per `.tres` for categorical and per-Control specifics. Total v1 file count: **1 `.gd` + 5 `.tres` at the addon root** + assets in `fonts/` and `icons/`. Evidence: PROJECT.md "What This Is" / Addon layout / Constraints sections rewritten; ROADMAP.md Phase 4 success criteria simplified; REQUIREMENTS.md FOUND-01/02/03 rewritten; Phase 3.4 03.4-CORRECTIVE-ADDENDUM.md D-31 rewritten with final naming + 9-export set + is_light variable; Phase 3.4 Plan 04 rewritten; CLAUDE-CODE-HANDOFF.md updated. | ✓ Good |
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
*Last updated: 2026-05-06f — `@export` set finalized at 9 properties (Core 4 + Shape 5); naming cleaned (`corner_radius`, `spacing`, `raised_strength`); `is_light` variable replaces `dark_theme` (dark default); Theme Editor primary for personality*
