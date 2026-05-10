# Visual Identity Distinctiveness — Spike Brief

**Created:** 2026-05-10
**Trigger:** /gsd-progress production-readiness audit, 2026-05-10
**Driver question:** Why does NeoCade feel like a Godot Editor theme — neutral, dense,
tool-like — rather than a unique, characterful **Game UI** with stage presence?

---

## The User's Read

When the rendered showcase is viewed cold, it reads as "a competent dark
Godot editor theme with a green accent". It does not read as "a game UI
that belongs to a specific brand". The same kind of generic-tool-feel that
Godot's built-in editor theme, VSCode dark theme, or Sublime Text Mariana
have. **Tools, not games.**

Two specific axes of failure the user names:

1. **Not unique, expressive, or colorful enough.** The promised Phase 3.3
   personalities (Pulse / Slate / Bubble / Daybreak / Burst) read as muted
   variants of "dark theme + accent" rather than visually distinct game
   identities. LDtk — despite being a level editor — manages to be
   strikingly colorful and expressive through aggressive per-layer/per-
   section hue coding; that *color-expressive* lesson translates to game
   UI even if LDtk's chrome conventions don't.

2. **Color monoculture.** Current rendered output uses essentially **one
   tint at a time**: `base_color` derives a 5-stop tonal surface ramp
   (`surface_low` / `surface_base` / `surface_panel` / `surface_high` /
   `surface_overlay`), all in the same hue. The `accent_color` only surfaces
   on focused/selected/primary states (~5-10% of the visible chrome).
   Semantic role colors (`role_success` / `role_warning` / `role_danger` /
   `role_info`) exist in `role_table` but rarely appear in BINDING_TABLE
   bindings. Net effect: the user sees navy + navy + navy + navy + a dot
   of green; a Pulse showcase frame can be reduced to ~2 unique colors.

   **MD3 explicitly disagrees with this.** Material Design 3 expects
   **at least 2 unique role colors visible simultaneously** — primary AND
   secondary — and "MD3 Expressive" pushes further into primary +
   secondary + tertiary + surface containers in the same view. Real game
   UIs commonly run 4+ hues on screen at once (HP bar, MP bar, status
   indicators, section badges, primary CTA, dismiss action, currency
   chip). NeoCade is far below the MD3 floor, let alone the game-UI bar.

The intent has always been a **flat MD3 / MD3 Expressive Game UI** — not a
flat MD3 editor theme. The current implementation has crossed into editor
territory AND simultaneously underdelivers on MD3's own multi-color
expectation, which is the worst of both worlds.

3. **The `raised=true` export doesn't capture the spirit of flat game UI.**
   The user's anchor reference for flat game UI was always
   [HCGames Flat GUI for Mobile Games](https://hcgamestudios.itch.io/flat-game-ui-for-mobile-games)
   — explicitly a "user exemplar" in `FLAT-3D-UI-RESEARCH.md`. Its
   distinctive moves: (a) **5 button hues per screen** (blue / red / green /
   purple / orange) used as a role-color hierarchy; (b) **same-family
   strong depth strip** under each button — bright pink button → noticeably
   darker pink shadow (not black, not desaturated, same hue family ~40-50%
   darker); (c) **fully rounded pill silhouettes** with chunky generous
   padding; (d) **HUD widgets in their own colors** (red heart, gold coin
   chip on the top bar). NeoCade's `raised` mode currently delivers none
   of these:

   - **Depth-color drift.** `_raised_depth_color` at lines 800-806 mixes
     the source color 16% toward `base_color` *and* 10% toward black.
     Net effect on a hot-pink button: depth becomes a muted purple-black,
     not a darker pink. The per-button hue identity is literally erased
     in the depth strip. HCGames does the opposite — depth stays in the
     same hue family.
   - **Subtle depth instead of bold.** Combined ~26% darker yields a
     thin "tool-bar shadow line" reading, not a "candy button you can
     press" reading. HCGames depth strips are visually 40-50% darker
     and clearly readable as a 3D affordance.
   - **Only one button color.** Most BINDING_TABLE button slots resolve
     to `button_normal` (a tonal derivation of `base_color`); only
     `PrimaryButton` and `DangerButton` get a role color, and even then
     the rest of the chrome stays mono-tint.
   - **Rectangular silhouette by default.** Pulse `corner_radius=0`,
     Slate `14`, Daybreak `8`, Burst `18-28`. Only Bubble at `26 / 999`
     reaches HCGames-pillow territory. The other four directions look
     like editor rectangles by comparison.

   So `raised=true` currently produces "rectangular flat buttons with
   a thin same-color shadow line", not "extruded candy buttons in role
   colors with bold same-hue depth strips" the research dossier promised.

## Spike Mandate

Identify the specific patterns and design moves that make Game UIs read as
**unique, expressive, colorful game UIs** (rather than as productivity-tool
themes) — within NeoCade's locked constraints — and propose 3-6 signature
moves NeoCade should adopt to escape the editor-theme feel.

The driver is escaping mono-tint chrome and underclaiming MD3's
multi-color contract. Specifically the spike should:

1. **Diagnose the color monoculture.** Quantify how many distinct hues
   currently appear on a typical Pulse / Slate / Bubble / Daybreak / Burst
   showcase frame, and contrast that count against (a) MD3 reference
   layouts (b) shipped game UI screens. Expected gap: NeoCade ~1-2 hues,
   MD3 reference ~3-4, shipped game UIs 4-6+.

2. **Propose moves that lift the on-screen hue count without violating
   the locked palette.** Each direction is locked to its `base_color` +
   `accent_color`, but: (a) MD3 derives secondary/tertiary roles from
   primary via tonal palette math, (b) the existing `role_success` /
   `role_warning` / `role_danger` / `role_info` are wired but rarely
   bound in BINDING_TABLE, (c) per-section tinting (LDtk's lesson) lets
   different panels announce different roles without changing the
   palette. The spike should explore which of these mechanisms can lift
   visible-hue-count to ≥3 per screen.

3. **Take the color-expressive lesson from LDtk** — the per-layer hue
   coding, severity-tinted banners, status-color-coded indicators —
   while explicitly **rejecting LDtk's tool-theme chrome conventions**
   (dense rows, monoweight typography, no display headers, no primary-
   CTA hierarchy). LDtk is a divided reference: keep the color
   expressiveness, drop the tool conventions.

4. **Propose moves that make each direction visually unique.** Currently
   Pulse / Slate / Bubble / Daybreak / Burst differ mainly by `corner_radius`
   + 2 colors + minor padding. The spike should ask whether each direction
   needs a signature visual move that cannot be confused with the others
   (e.g., Burst gets oversized statement chrome, Bubble gets pill-stack
   compositions, Slate gets ultra-thin hairlines, etc.).

The reference set must be **shipped commercial games and quality game-UI
asset packs**, not editors/IDEs/productivity tools — except where (like
LDtk's color usage) a tool happens to demonstrate a game-UI-friendly
pattern.

## Comparison Methodology

For each comparison axis, the spike should:

1. **Sample the editor-theme cohort** — what conventions do they all share?
   - Godot Editor (built-in theme)
   - `passivestar/godot-minimal-theme` rendered output
   - VSCode dark, Sublime Text Mariana, JetBrains Darcula
   - LDtk editor (yes, despite being our polish-quality reference, LDtk is
     a level-editor and inherits tool-theme conventions)

2. **Sample the game-UI cohort** — what conventions do they all share that
   the editors don't?
   - **Anchor reference (highest priority):** HCGames Flat GUI for Mobile
     Games (`hcgamestudios.itch.io/flat-game-ui-for-mobile-games`). The
     user has named this as the canonical "what NeoCade's `raised=true`
     should look like". It is also already documented as a "user exemplar"
     in `.planning/research/FLAT-3D-UI-RESEARCH.md`. The spike must
     measure NeoCade's current Pulse/Slate/Bubble/Daybreak/Burst raised
     output against the specific HCGames moves listed in the user-read
     section above (5 hues per screen, same-family depth strips,
     pillow silhouettes, HUD widget chrome).
   - **Companion exemplar:** fajrulaslim UI Button Flat Design (also a
     documented user exemplar) for additional button-shape vocabulary.
   - Mobile flat-modern: Brawl Stars, Royal Match, Match Masters, Toon
     Blast, Among Us, Friday Night Funkin'
   - Indie flat-modern: Celeste menus, Untitled Goose Game, Mini Metro,
     Slay the Spire menus, Hades menus (lightly textured but mostly flat
     chrome), Balatro menu chrome (skip CRT scanlines per anti-cyberpunk
     filter)
   - Other game-UI asset packs already in the project's research surface:
     Kenney UI Pack, GameArt2D Minimalist Flat, MODI Main Menu UI Pack,
     LILA Pinky UI, SunGraphica Flat Game UI
   - **Exclude from the game cohort** anything that violates NeoCade's
     hard constraints: cyberpunk, neon-noir, synthwave, scanline, painterly,
     leather, wood, grunge, gradient-on-chrome, pixel-art chrome,
     drop-shadow-heavy, or animation-dependent designs.

3. **Diff the two cohorts on three axes:**

   **a. Color usage axis (highest priority — the user's primary complaint).**
   For a representative screen in each reference, count and report:
   - Total unique hues visible (excluding text and pure white/black).
   - Number of MD3 role colors used (primary, secondary, tertiary, error,
     surface variants).
   - Whether semantic roles (success/warning/danger/info) appear as
     normal-state chrome (not just transient alerts).
   - Whether per-section/per-role tinting is used (LDtk pattern).

   Then produce the same count for current NeoCade Pulse / Slate / Bubble /
   Daybreak / Burst showcase frames. The expected gap is the spike's
   primary diagnostic finding.

   **b. Chrome / hierarchy axis.** Likely candidates the spike should
   validate or reject:
   - **Display headline scale + weight** — game UIs use 32-48px+ headlines
     with heavy weight; editors max out at ~16-18px section headers.
   - **Primary CTA hierarchy** — game UIs make ONE button per screen
     unmistakably the primary action via size/color/elevation; editors
     give every button equal visual weight.
   - **Decorative chrome moves** — kickers, badges, score chips, status
     pills, edge stripes; editors avoid these as visual noise.
   - **Distinctive selected-row treatment** — color stripe + tick + lift;
     editors use a subtle bg highlight only.
   - **Generous spacing + tap target lift** — game UIs use 44-56px
     buttons with breathing room; editors pack 22-28px rows for density.

   **b'. Raised-mode fidelity axis (NEW — directly addresses the user's
   primary complaint).** The spike must specifically inspect what
   `raised=true` currently produces vs what it should produce per
   `FLAT-3D-UI-RESEARCH.md`:
   - **Depth-color formula.** Current `_raised_depth_color` (lines
     800-806) drifts the depth color toward `base_color` and black,
     erasing per-button hue identity. The spike should propose a
     replacement formula that keeps the depth in the same hue family
     (e.g., HSV value-darken at 30-40%, no base-pull) so a hot-pink
     button gets a darker pink shadow strip, matching HCGames.
   - **Depth strength.** Current ~26% darker is "tool shadow line"
     subtle; HCGames uses ~40-50% darker for clear "press me" affordance.
     The spike should propose a stronger default for `raised_strength`
     that doesn't break accessibility.
   - **Bottom-strip thickness.** Current `raised_lifts.primary=2`
     produces a 2px strip. HCGames-style strips look ~4-6px on similarly
     sized buttons. Propose a per-direction lift scale that fits
     each personality.

   **b''. Pillow silhouette per direction (NEW).** Of the 5 directions,
   only Bubble (`primary_radius=999`, `secondary_radius=26`) reaches
   HCGames-pillow territory. The other four (Pulse 0, Slate 14,
   Daybreak 8, Burst 28) read as editor rectangles by comparison. The
   spike should evaluate per direction:
   - Should each direction have at least ONE control class with a fully
     pilled / strongly rounded silhouette to anchor the "game UI"
     reading, even if other classes stay rectangular for the direction's
     personality?
   - Or should `raised=true` itself force a more rounded silhouette
     across the board (different visual contract: flat=rectangular,
     raised=pillow)?

   **c. Branding / character axis:**
   - **Section/role color coding** — HUD-style color semantics on panels
     (Lobby is one color, Match is another); editors stay monochrome.
   - **Branded iconography** — beyond-functional icons that signal the
     domain (marquee, ticket, scoreboard, prize, attract-mode); editors
     ship only Godot-slot mirrors.
   - **Display font with character** — game UIs use display-grade fonts
     (Outfit, Cabinet Grotesk, Sora, etc.) for headers; editors use
     neutral system fonts (Inter, SF Pro, Segoe UI).
   - **Notification/banner system** — game UIs have toast/banner severity
     stripes for game state; editors use plain modal dialogs.
   - **Per-direction signature move** — does each of the 5 directions
     have one visual move that no other direction has, so they don't read
     as recolors of each other?

4. **Identify which game-UI moves NeoCade can adopt** — given:
   - Hard constraints (anti-cyberpunk, anti-texture, anti-gradient, HD-only,
     pure Theme/StyleBox primitives, no shaders, no plugin.cfg, no
     GDExtension, no breaking the 12-export contract).
   - Soft preferences (Inter as the only bundled font in v1, but the spike
     can propose an opt-in display-font slot via consumer override
     pattern from FONT-09).

## Inputs (read-only references for the spike)

| File | What to use it for |
|---|---|
| `.planning/research/THEME-DIRECTIONS.md` | The 5 personality intents — every candidate move must serve at least one of Pulse/Slate/Bubble/Daybreak/Burst characteristics. |
| `.planning/research/MD3-RESEARCH.md` | MD3 grammar — moves must compose with M3 state-layer model and tonal surface ramp. |
| `.planning/research/FLAT-3D-UI-RESEARCH.md` | Extruded-flat construction patterns for raised mode. |
| `.planning/research/LDTK-UI-MINING.md` | 14+ patterns already vetted for anti-cyberpunk/anti-texture filter — many are game-UI-friendly. Treat as one of many references, not the spec. |
| `.planning/research/SUMMARY.md` | Research synthesis with hard rules. |
| `.planning/DESIGN_TOKENS.md` | Token surface — moves must compose with existing tokens, not introduce parallel systems. |
| `.planning/MOBILE-DESIGN-SPEC.md` | Mobile sizing baseline — moves must work in both desktop and mobile. |
| `.planning/mockups/3.4/concepts/` | Approved mockups + greyscale-sufficiency tests. |
| `addons/neocade_theme/scripts/neocade_theme.gd` | Live implementation — STYLE_PERSONALITY shape language is the existing extension point for direction-specific moves. |
| `addons/neocade_theme/icons/` | Current icon set (79 SVGs, all functional Godot-slot mirrors). |
| `showcase/showcase.tscn` | Live showcase scene to capture for "current state" reference. |

## Out of Scope (hard guardrails)

| Forbidden | Reason |
|---|---|
| Custom shaders, GDExtension, native code | Pure Theme / StyleBox primitives only |
| `plugin.cfg` / EditorPlugin scripts | Not an editor plugin |
| Breaking the 12-export public contract | Public API stability |
| Adding to the bundled font set in v1 | Inter-only is locked (Option D) |
| Drop shadows on chrome | GL Compatibility renders them wrong |
| Gradients on chrome | Visual identity rule |
| Textures, patterns, embossing | Visual identity rule |
| Animations beyond Godot StyleBox transitions | No motion in v1 |
| Cyberpunk / synthwave / neon-noir / dystopian | Hard rejection |
| Pixel-art chrome | HD-only |
| References to Persona 5, Cyberpunk 2077, Dark Souls, Borderlands, Diablo | These all use textures/painterly/gradient chrome — out of scope reference set |

## Definition of Done

A `REPORT.md` at `.planning/spikes/visual-identity-distinctiveness/REPORT.md`
that:

1. **Quantifies the color monoculture.** Numeric report of hue counts on
   a representative screen for each cohort: current NeoCade (5 directions),
   Godot Editor + 2 other editor themes, MD3 reference layouts (3+),
   shipped game UIs (3+ that pass the constraint filter). Include a small
   table like:
   ```
   Reference                    | unique hues | MD3 roles used | semantic-as-chrome
   NeoCade Pulse showcase       |       2     |       1        |   no
   NeoCade Slate showcase       |       2     |       1        |   no
   Godot Editor (default)       |       2     |       1        |   no
   MD3 reference (Material Web) |       4     |       3        |   yes
   Royal Match (mobile)         |       6     |     n/a        |   yes
   ```
   This is the headline diagnostic of the spike — the rest is downstream.

2. **States the editor-vs-game gap concretely.** Side-by-side at the same
   control surface (e.g. "ItemList row in Godot Editor vs in Royal Match")
   showing the specific visual moves that differ. Annotated screenshots
   or HTML mockups, not just prose.

3. **Catalogs 3-6 candidate signature moves** that NeoCade should adopt to
   read as game UI. AT LEAST ONE candidate must directly address the
   color-monoculture diagnosis (e.g., "wire MD3 secondary/tertiary roles",
   "bind semantic role colors to chrome states", "per-section/role panel
   tinting", "add a `secondary_color` export"). AT LEAST ONE candidate
   must directly address the raised-mode fidelity gap (e.g., "rewrite
   `_raised_depth_color` to keep depth in same hue family at 30-40%
   value-darken", "lift `raised_strength` defaults", "thicken
   `raised_lifts.primary` per direction to 4-6px"). Each candidate must
   include:
   - Move name + 1-paragraph description
   - Which game-UI references it pulls from (with citations)
   - Which Pulse/Slate/Bubble/Daybreak/Burst personality it serves
   - Hue-count delta: how many additional unique hues per screen this
     adds, and whether they are MD3-derived or fresh palette additions
   - Godot 4.6 feasibility note (which Theme entries are touched, whether
     STYLE_PERSONALITY.shape can carry it, what the public-export-surface
     impact is, whether new exports are needed)
   - Visual aesthetic risk: does it survive the anti-cyberpunk + anti-
     texture filter?
   - Rough effort estimate (lines of code touched, new icons needed)
   - **Verdict:** adopt / reject / open

4. **Throwaway HTML mockups** showing 1-3 of the highest-impact candidates
   applied to the existing showcase screen layout, so the user can decide
   visually before Phase 12 starts. The mockup that addresses color usage
   should annotate the on-screen hue count to make the lift visible.
   Mockups live alongside REPORT.md and follow `.planning/mockups/`
   conventions (HTML + per-mockup `.md` provenance, no JS frameworks).

5. **Closes with a recommendation:** which subset of candidates should
   feed Phase 12 ("Signature Visual Moves"). The user approves or
   redirects in writing. Phase 12 only begins after that approval.

## Out-of-Scope for the Spike Itself

- **Implementation in `neocade_theme.gd`** — that's Phase 12.
- **New BINDING_TABLE entries** — Phase 12.
- **New SVG icons committed to `addons/`** — Phase 12 (the spike may
  produce mockup-only SVGs in `.planning/spikes/.../mockups/` but they
  do not enter the addon).
- **Re-running visual research from scratch** — the existing research
  artifacts are sufficient; the spike consumes them.
- **Re-deriving the 5 approved theme directions** — those are locked.
  The spike adds character ON TOP of the existing direction definitions,
  not in place of them.

## Suggested Next Step

Run `/gsd-spike` with this brief as input. The spike orchestrator should
read this file as its canonical scope statement and produce REPORT.md +
mockups in this directory.
