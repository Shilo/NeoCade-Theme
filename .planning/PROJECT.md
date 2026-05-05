# NeoCade Theme

## What This Is

NeoCade is a Godot 4.6 native UI Theme system, distributed as a drop-in addon, that styles every built-in Control with a **flat Material Design 3 / MD3 Expressive aesthetic** — modern, colorful, expressive, accessibility-first, with optional "extruded flat 3D" raised variation per the Flat-3D Game UI pattern. It works universally across the Godot Editor and game runtime, and is designed to scale from desktop to mobile. **Architecture (LOCKED 2026-05-04 architecture revision):** `class_name NeoCadeTheme extends Theme` (`@tool`) superclass with `@export` properties — `base_color: Color`, `accent_color: Color`, `raised: bool`, `platform: {DESKTOP, MOBILE, AUTO}`. Setters dynamically regenerate all theme entries via `_get_base_color`-style formulas (ported from passivestar's editor theme but driven by `@export` props instead of `EditorSettings`). **`NeoCadeTheme` itself carries one of the user-approved theme directions as its baked-in default style** — at the Phase 3.4 approval gate, the user picks ONE of the N approved directions to be the base ("most universal or pretty"); that direction's values become NeoCadeTheme's `@export` defaults, so a consumer instantiating `NeoCadeTheme` directly gets that direction's style. The remaining N-1 approved directions are personality subclasses (e.g., `class_name PopPlazaNeoCadeTheme extends NeoCadeTheme`) that override personality (shape language, outline widths, color tint formula parameters) via `super._regenerate()` + delta overrides. **Critical override mechanic** (per Phase 3.2 finding): Godot Theme resources don't auto-inherit at the resource level; subclass `_regenerate()` MUST call `super._regenerate()` first to populate base entries, then override specifics — otherwise the subclass theme leaves non-overridden Controls unthemed at runtime. **v1 ships 1 base `neocade_theme.tres` (instance of NeoCadeTheme with the chosen direction's defaults) + N-1 personality subclass `.tres` files** under `addons/neocade_theme/themes/`. Consumer toggles exports for flat/raised + desktop/mobile/AUTO variations. `platform=AUTO` auto-detects via `OS.has_feature("mobile")` at runtime; `DESKTOP` and `MOBILE` are forced sizes. Architecture supports undefined number of theme subclasses; future variants (light mode, alternate palettes, additional themes) plug in as new subclasses.

The theme is built primarily to power the author's upcoming game (codename: **VirtuCade**) — a 2D tile-based pixel-art online multiplayer game set inside a large interior arcade environment with interactive booths and mini-games — but is designed as a standalone, reusable addon for the Godot community. The theme name is **NeoCade**; VirtuCade is the consuming game, not the theme.

**Visual identity LOCKED 2026-05-04 (Phase 3 redirect):** Flat MD3 / MD3 Expressive language. **Hard rules:** no textures, no patterns, no embossing, no painterly/leather/wood/grunge backgrounds, no gradients on chrome. Solid colors + offset darker shape duplicates for depth on the raised variation only (extruded-flat per [hcgamestudios.itch.io](https://hcgamestudios.itch.io/flat-game-ui-for-mobile-games) and [fajrulaslim.itch.io](https://fajrulaslim.itch.io/ui-button-flat-design)). Anti-cyberpunk discipline preserved (no synthwave / no neon-noir / no dystopian). The earlier "neo/neon arcade" framing is **historical** — see Phase 3 redirect notes in ROADMAP.md and STATE.md.

## Core Value

A drop-in Godot 4.6 **flat MD3 / MD3 Expressive Theme system** that styles **every** built-in Control to a Godot Minimal Theme bar of feature-completeness, with a colorful, expressive, professional, accessible, modern visual identity — universal across editor and runtime — installable as a single addon. **v1 ships N user-approved theme subclass `.tres` files** (one per theme) under `res://addons/neocade_theme/themes/`, each extending the dynamic `NeoCadeTheme` superclass. Consumers toggle `raised` / `platform` / `base_color` / `accent_color` exports at use-time; the superclass regenerates all theme entries to match. Drift is structurally impossible because all variations come from one subclass. Architecture supports undefined number of themes (extensible for v1.x and beyond).

If everything else fails, this single deliverable must work: a polished, feature-complete subclass `.tres` (e.g., `prize_pop_plaza_neocade_theme.tres`) extending `NeoCadeTheme` that "just works" when applied to any Godot Control tree, with consumer-tunable `base_color` / `accent_color` / `raised` / `platform` exports.

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
- [ ] **Mobile-optimized theme variant — `neocade_mobile_theme.tres` (v1 must-have)**: ships ALONGSIDE the desktop primary. Same visual identity (shared tokens), but tuned for touch and small screens — minimum 44pt (iOS HIG) / 48dp (Android Material) tap targets, larger default text sizes, denser-content guards relaxed, simplified typography scale, mobile-appropriate spacing. References iOS Human Interface Guidelines + Material 3 mobile guidance loosely. Both themes share the underlying color/typography token system so visual identity stays unified.
- [ ] **Bundled fonts**: Inter (UI) + Noto Sans (multi-script fallback) bundled in the addon under OFL license; bold/italic/weights/variable axes covered. Research must also evaluate arcade-styled display fonts as candidates, but readability and accessibility take priority over arcade flair
- [ ] **Strict design system documentation**: written specs for color tokens, typography scale, spacing scale, corner radii, stroke widths, elevation/shadow, motion (if any) — committed before implementation
- [ ] **Mockup approval gate**: design variation mockups produced and explicitly approved by user before any styling is committed to the .tres
- [ ] **Theme editor authoring**: theme is built using Godot's Theme editor and persisted to `res://addons/neocade_theme/neocade_theme.tres`
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
- `res://addons/neocade_theme/neocade_theme.tres` — desktop primary theme resource (currently empty scaffold)
- `res://addons/neocade_theme/neocade_mobile_theme.tres` — mobile-optimized variant (v1, to be authored)
- `res://addons/neocade_theme/fonts/` — bundled Inter Variable + Inter Italic + Noto Sans Variable (path TBC by font/icon spike phase)
- `res://addons/neocade_theme/icons/` — bespoke SVG icon set (~30 icons, per STACK research)
- `res://addons/neocade_theme/OFL.txt` — combined OFL license file for bundled fonts
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
| `.planning/research/SUMMARY.md` | **Project canon** — synthesized research findings, conflict resolutions (display font, surface tokens, shadows), 11-phase roadmap recommendation, open user decisions UD-1 through UD-6. Authoritative for downstream phase planning. | `.planning/research/` |
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
- **Cross-platform exports**: theme + assets must work across all six Godot export targets — Windows, macOS, Linux, iOS, Android, Web/Browser. Asset paths must resolve from `res://addons/neocade_theme/` on every target. Fonts must load over Web export (no system-font fallback assumption). License compliance verified for iOS App Store (OFL only — Inter, Noto Sans, JetBrains Mono all OFL 1.1). v1 requires screenshot QA on every target before release.
- **Mobile guidelines reference (loose, not strict)**: iOS Human Interface Guidelines + Android Material 3 mobile guidance inform the mobile variant's tap target sizes, type scale, and accessibility minima. We adopt their *minimums* (44pt iOS / 48dp Android tap targets, scaled type), not their visual language. NeoCade arcade identity persists across all platforms.
- **Aesthetic**: arcade-leaning, neo, neon, modern, colorful, professional, friendly. Explicitly NOT cyberpunk, NOT grimy, NOT dystopian. Closer to "vibrant arcade hall" than "Blade Runner street".
- **Accessibility**: WCAG 2.1 AA minimum for text contrast and interactive elements. Visible focus indicators. No color-only information.
- **Fonts**: must be popular, professional, OFL/Apache-licensed, bundled, with full language coverage (CJK, Cyrillic, Arabic, Hebrew, Devanagari, etc.) via fallback. Bold, italic, full weight range required. Inter + Noto Sans is the primary candidate stack.
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
- Theme distributes as `res://addons/neocade_theme/neocade_theme.tres`
- Mockup approval gate is mandatory before implementation
- **All external sources are inspiration / coverage-benchmark / pattern inventory — NEVER design spec.** This includes godot-minimal-theme, LDtk source, Material Design 3, real-arcade references, the user's prior research report and prototype. Source-dive phases (Phase 1, Phase 2, future Phase X spikes) produce *idea inventories* and *coverage matrices*. Design decisions live exclusively at the **Phase 3 mockup approval gate** + the **per-phase PLAN.md / DESIGN_TOKENS.md / MOBILE-DESIGN-SPEC.md artifacts**. No phase plan or executor may treat a source-dive output as authoritative for color values, typography, spacing, or visual identity. Translation sketches in source-dive artifacts must carry the prefix *"Inspiration sketch — Phase 3 mockup or Phase 5+ designer's call."* If a downstream agent ever quotes a source-dive value as a binding decision, it is wrong — refuse and redirect to the canonical Phase 3 / per-phase artifact.
- **v1 ships Inter Variable ONLY.** Per FONT-REVIEW.md (2026-05-04) and user's locked decision: a single bundled font (Inter Variable upright, OFL 1.1, ~810 KB). Headings differentiated by `opsz=32` axis + heavier `wght`, NOT a separate display font. **No Outfit, no Noto Sans, no JetBrains Mono in v1 bundle.** Non-Latin scripts (Arabic, Hebrew, Indic, Thai, CJK, etc.) render via Godot's `Font.allow_system_fallback = true` (default). README points consumers at **script-specific Noto Sans variants** (Noto Sans SC for Chinese, Noto Sans Arabic, Noto Sans Devanagari, etc. — all OFL 1.1, designed to harmonize with Inter) for opt-in visual consistency in their consuming project. CodeEdit / RichTextLabel `[code]` users override `theme.default_font` per-Control via documented README pattern. Inter Italic deferred to v1.x. **Matches godot-minimal-theme's bundle exactly (Inter only).** Total bundle ~810 KB. **No additional fonts will be bundled — consistency principle is non-negotiable.**
- Cross-platform: all 6 Godot export targets (Windows/macOS/Linux/iOS/Android/Web)
- Mobile variant `neocade_mobile_theme.tres` is v1 must-have alongside desktop primary (added 2026-05-04; specs in CROSS-PLATFORM.md)

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
| Inter + Noto Sans as primary font stack | Inter is the most popular modern UI font (OFL, full weights, italic, variable); Noto Sans gives universal script coverage. Readability and accessibility take priority over arcade flair. Research must also evaluate arcade-style display fonts as candidates. | — Pending |
| Single Theme resource at `res://addons/neocade_theme/neocade_theme.tres` | Standard Godot addon distribution; user already scaffolded the path | — Pending |
| godot-minimal-theme is the feature-completeness benchmark, NOT visual reference | It's the gold standard for "every Control styled" — visuals must be original NeoCade | — Pending |
| LDtk is the quality/polish benchmark, NOT visual copy | Polished feel only — we build a distinct identity | — Pending |
| Material Design 3 is a loose styleguide, NOT visual copy | Reference for spacing/contrast/accessibility patterns; visual language is arcade, not Material | — Pending |
| Showcase scene mirrors godot-demo-projects/gui/control_gallery scope | Established reference for "every Control"; ensures coverage | — Pending |
| Theme toggle in showcase: NeoCade ↔ Godot default (NOT light/dark) | Communicates "this is what NeoCade adds" to users | — Pending |
| Mockup approval gate before implementation | User explicitly required this — must approve design variations before any .tres styling is committed | — Pending |
| Mobile variant elevated to v1 must-have (alongside desktop primary) | User constraint update: ship `neocade_mobile_theme.tres` in v1 with shared tokens, mobile-tuned scale, iOS HIG + Material 3 mobile guidance. Alternate palettes remain v2. | ✓ Good |
| Cross-platform export support — all 6 Godot targets in v1 | User constraint: Windows, macOS, Linux, iOS, Android, Web/Browser. Web is highest-risk (font loading, path resolution); iOS requires OFL/Apache-only licensing. Screenshot QA on every target before v1 ships. | ✓ Good |
| Two `.tres` files share one underlying token system | Desktop and mobile themes derive from the same color/typography tokens; mobile overrides scales/touch-targets/density. Avoids visual identity drift between the two. | — Pending |
| Subagent research/review at every major step | User explicitly required exhaustive subagent-driven research and review | — Pending |
| MCP-driven QA (Godot MCP screenshots, Context7 docs) | User explicitly required heavy MCP usage | — Pending |
| Cyberpunk aesthetic explicitly rejected | User specified "Neo/Neon/Modern, not Cyberpunk"; arcade-friendly, not dystopian | ✓ Good |
| Research report and prototype are inspirational refs only — NOT source of truth | User explicitly required research to challenge them. Specific critiques to enforce: theme is **NeoCade** (not VirtuCade); no synthwave/vaporwave/scanlines/glow; no pixel fonts; arcade warmth must come through stronger than the prototype shows. | ✓ Good |
| Theme aesthetic anchor: "vibrant arcade hall by day", not "neon noir alley by night" | Concrete mental image to keep researchers/designers oriented. Bright, inviting, energetic — like walking into Round1 or Dave & Buster's, not Blade Runner. | — Pending |
| Exhaustive research/spiking is a first-class deliverable | Research is mandated to challenge ALL prior inputs (the report, the prototype, and any Pending decision in this doc). The roadmap will include dedicated research/spike phases beyond the initial parallel pass. See Research Charter section. | ✓ Good |
| Research can override `Pending` Key Decisions; cannot override user's hard constraints | Hard constraints (theme name, anti-cyberpunk, HD-only, full Control coverage, addon distribution path, mockup gate, Inter+Noto Sans primary) require explicit user reconsideration to change. Pending decisions are defeasible by evidence. | ✓ Good |

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
*Last updated: 2026-05-04 after initialization*
