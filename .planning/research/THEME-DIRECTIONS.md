# NeoCade Theme Direction Research

**Phase:** 03.3-theme-direction-research  
**Created:** 2026-05-06  
**Status:** In progress; Plan 01 survey complete; Plan 02 synthesis pending.

## Provenance and Scope

Phase 3.3 is text-level direction research only. It derives five candidate theme directions for later user approval, but it must not create mockups, concept images, HTML/CSS boards, production theme resources, addon files, fonts, icons, scenes, project settings, or `.tres` styling commits.

The output is this research artifact plus a later text-level checkpoint. Phase 3.4 owns visual mockups. Phase 4 owns subclass implementation and production theme resources.

Primary inputs, in priority order per D-02:

1. User goal: colorful, flat, modern UI that can remain playful and expressive.
2. User restrictions: no textures, patterns, embossing, painterly/leather/wood/grunge surfaces, or gradients on chrome; anti-cyberpunk discipline remains.
3. User exemplars: HCGames/Renderman Flat GUI for mobile games and fajrulaslim UI Button Flat Design.
4. v0 reaction DNA: Midnight Marquee, Cabinet Chrome, Prize Pop Plaza, and Orbital Playdeck can contribute liked DNA; Boardwalk Sunset is hard-rejected.
5. Phase 3.1 and 3.2 outputs: MD3/MD3 Expressive grammar, Flat-3D construction rules, and dynamic `NeoCadeTheme` superclass architecture.

## Source Roles and Citation Contract

External examples are inspiration-only per D-09. NeoCade may adopt construction ideas, hierarchy lessons, personality vocabulary, and broad palette relationships; it must not copy artwork, names, layouts, exact palettes, screenshots, icons, sprites, or asset-pack silhouettes.

Source roles used in this artifact:

| Role | Use |
|---|---|
| user exemplar | User-provided references that define the intended flat/extruded-flat idiom. |
| official/spec | Material/Android/Material Web sources that define MD3 or MD3 Expressive principles. |
| commercial example | Shipped app or game UI screenshot/source used as inspiration-grade calibration. |
| asset-pack example | Public UI pack used to identify reusable construction patterns. |
| local research input | Prior NeoCade research artifact used as project-specific source of truth. |
| v0 feedback artifact | Redirect-era feedback used as DNA, not as visual treatment. |

Source-access statuses:

| Access status | Meaning |
|---|---|
| directly extracted | Text was accessible in the fetched page or local artifact. |
| browser/manual verified | Visual value required page/screenshot inspection or a prior visual-capture note. |
| fallback source used | The named URL is retained, but another accessible source fills the evidence role. |
| blocked in direct open | The URL stayed in the dossier, but direct extraction was blocked or empty. |
| local artifact inspected | Prior project artifact was read from `.planning/`. |

Every survey entry records: source name, URL, access status, retrieved date, source role, personality archetype anchor, what it does well, NeoCade adopt inspiration, NeoCade reject notes, and open follow-up.

## Filter Rules

| Rule | Decision coverage | Definition |
|---|---|---|
| Input priority | D-02 | Start from the user's flat, colorful, modern goal and hard restrictions before visual trend or v0-name nostalgia. |
| Broad personality spread | D-03 | Five directions must cover distinct personality space, not five nearby palettes or five dark-only variants. |
| Universal export axes | D-03b | Every direction supports flat/raised and desktop/mobile through the dynamic `NeoCadeTheme` exports. No direction may be "the flat one", "the raised one", "the desktop one", or "the mobile one". |
| Anti-cyberpunk | D-07 | Forbid synthwave, neon-noir, dystopian framing, scanlines, glow-first focus, sci-fi HUD geometry, and dark-for-dark's-sake mood. |
| Anti-texture | D-07 | Forbid textures, patterns, embossing, painterly chrome, leather, wood, grunge, background illustration dependency, and gradients on chrome. |
| Output structure | D-10 | Produce this artifact with provenance/scope, survey, v0 DNA mapping, five candidate directions, filter audit, user approval checkpoint, and verification log. |
| Carried constraints | D-16 | Inter Variable Roman only; dynamic superclass exports; 35-Control coverage discipline; focus/popup pitfalls remain authoritative; no fallback-masked coverage claims. |

Direction audit table structure for Plan 02:

| Direction | Anti-cyberpunk | Anti-texture | universal-axes-still-work | no base-direction preselection | no mockup or `.tres` output |
|---|---|---|---|---|---|
| Pending Plan 02 | Pending | Pending | Pending | Pending | Pending |

## Commercial Example Survey

Survey count: 14 baseline sources. D-03c expansion beyond 15 was not used because every seeded personality anchor has at least one evidence row.

| Source name | URL | Access status | Retrieved | Source role | Personality archetype anchor | What it does well | NeoCade adopt inspiration | NeoCade reject notes | Open follow-up |
|---|---|---|---|---|---|---|---|---|---|
| Renderman / HCGames Flat GUI for mobile games | https://hcgamestudios.itch.io/flat-game-ui-for-mobile-games | directly extracted; browser/manual verified | 2026-05-06 | user exemplar; asset-pack example | playful bubbly; friendly daylight | Large mobile GUI coverage, flat style, multiple button colors, many icons, and ready-made menu/dialog screens. | Adopt inspiration-only: solid flat button families, friendly mobile density, role-colored actions, broad UI-surface coverage. | Reject PNG/PSD asset copying, specific icons, font choices, background art, and any direct layout transfer. | Revisit preview images in Phase 3.4 only for broad affordance, not artwork. |
| fajrulaslim UI Button Flat Design | https://fajrulaslim.itch.io/ui-button-flat-design/devlog/157464/ui-button-flat-design | directly extracted; browser/manual verified | 2026-05-06 | user exemplar; asset-pack example | playful bubbly; expressive statement | Focused button/icon model set with vector source and hundreds of button/icon sprite variants. | Adopt inspiration-only: repeatable flat button state families and vector-simple silhouettes. | Reject specific models, icons, red-button identity, Illustrator/EPS workflow, and sprite import. | None for Phase 3.3. |
| Material 3 Expressive official blog | https://m3.material.io/blog/building-with-m3-expressive | fallback source used; official page requires JavaScript in this runtime | 2026-05-06 | official/spec | expressive statement | Official Material entry point for MD3 Expressive; retained as canonical even when direct extraction is JS-gated. | Adopt inspiration-only: official provenance for the expressive direction; use accessible Google/Android sources below for extractable facts. | Reject treating JS-gated page visuals as uncited evidence or copying official demo layouts. | None; extraction gap is already covered by Design.Google and Android Developers sources. |
| Expressive Design: Google's UX Research | https://design.google/library/expressive-material-design-google-research | directly extracted | 2026-05-06 | official/spec | expressive statement | Frames expressive design around color, shape, size, motion, containment, attention, grouping, usability, and accessibility. | Adopt inspiration-only: stronger static personality, bigger emphasis moments, clearer grouping, accessible attention. | Reject motion/haptics as Theme scope, copied Google product layouts, and any non-static behavior requirement. | Phase 3.4 decides how far expressive scale can go without hurting desktop density. |
| Material Web theming | https://material-web.dev/theming/material-theming/ | directly extracted | 2026-05-06 | official/spec | modern minimal dark; friendly daylight | Shows component tokens mapping to system tokens, branded products with familiar patterns, and accessible interactions. | Adopt inspiration-only: role tokens, system/component token split, scoped theme overrides, accessible role pairing discipline. | Reject direct web-component implementation details and Material defaults as final NeoCade values. | Phase 4 translates token discipline to Godot `Theme.set_*` entries. |
| Android Developers Material 3 Expressive design language for Wear | https://developer.android.com/design/ui/wear/guides/get-started/design-language | directly extracted | 2026-05-06 | official/spec | expressive statement; friendly daylight | Documents expressive color, typography, shape, grouped containers, and adaptive button groups. | Adopt inspiration-only: shape variety, richer palettes, larger touch-friendly controls, grouped containment, stronger visual hierarchy. | Reject Wear-specific round screen layouts, shape morphing motion, and Android-only platform behavior. | Use as a guardrail for mobile sizing notes, not as a direct visual template. |
| Android Developers Blog: Material 3 Expressive for Wear OS | https://android-developers.googleblog.com/2025/08/introducing-material-3-expressive-for-wear-os.html | directly extracted | 2026-05-06 | official/spec | expressive statement | Connects personality, vibrant palettes, quick actions, and glanceability to real platform examples. | Adopt inspiration-only: confident brand mood through color and typography while preserving quick-action clarity. | Reject watch-specific edge-hugging buttons, spring animation, and system dynamic color as a v1 Theme requirement. | None for Phase 3.3. |
| Kenney UI Pack | https://kenney.nl/assets/ui-pack | directly extracted; browser/manual verified | 2026-05-06 | asset-pack example | friendly daylight; modern minimal dark | Offers simple reusable UI parts with clean, low-detail game UI vocabulary. | Adopt inspiration-only: restrained reusable shapes, low-noise component construction, and asset-pack consistency. | Reject copying assets or making NeoCade look like generic placeholder UI. | Phase 3.4 can inspect preview images if a direction needs a quieter flat game baseline. |
| GameArt2D Minimalist and Modern Flat Game GUI | https://www.gameart2d.com/minimalist-game-gui.html | directly extracted; browser/manual verified | 2026-05-06 | asset-pack example | friendly daylight; playful bubbly | Complete flat GUI pack for casual and puzzle games with buttons, windows, HUDs, and vector scalability. | Adopt inspiration-only: complete surface families, icon+text button support, scalable flat construction, casual-game friendliness. | Reject tileable background, exact assets, Helsinki font dependency, and any copied window/button shapes. | None for Phase 3.3. |
| MODI itch.io profile and Main Menu UI Pack | https://modi-assets.itch.io/ | directly extracted; browser/manual verified | 2026-05-06 | asset-pack example | playful bubbly; expressive statement | Presents polished cartoon-clean mobile/PC game UI packs with consistent design systems. | Adopt inspiration-only: polish expectations, clean cartoon friendliness, cross-engine readiness, consistent pack-level identity. | Reject glossy rounded buttons, gold-trimmed fantasy framing, PNG-only asset-pack workflow, and marketplace artwork. | Useful negative/positive split for playful direction intensity. |
| LILA Design Pinky UI | https://gamecontentdeals.com/assets/2d/pinky-ui/ | directly extracted; browser/manual verified | 2026-05-06 | asset-pack example | friendly daylight; playful bubbly | Documents flat/minimal mobile UI elements with explicit large button, dialog, checkbox, progress, radio, slider, toggle, and icon dimensions. | Adopt inspiration-only: comprehensive mobile control family thinking and large target ergonomics. | Reject the exact pink palette, asset screenshots, Unity package transfer, and any fixed sprite dimensions as Godot constants. | Phase 8 owns final mobile target sizes; Phase 3.3 only records 44pt/48dp implication later. |
| SunGraphica Flat Game user interface asset pack | https://sungraphica.itch.io/flat-game-user-interface-asset-pack/purchase | directly extracted; browser/manual verified | 2026-05-06 | asset-pack example | dark saturated arcade; expressive statement | Shows a game UI + 450 icon + HUD pack with paid and free package structure. | Adopt inspiration-only: broad HUD/icon/menu coverage and reusable flat game UI system posture. | Reject direct icons, HUD artwork, package contents, and any marketplace asset dependency. | If visual access is needed, use preview pages in Phase 3.4, not this text phase. |
| Brawl Stars interface screenshot collection | https://interfaceingame.com/games/brawl-stars/ | blocked in direct open; search-result summary and Phase 3.1 visual-capture note used; fallback source used | 2026-05-06 | commercial example | dark saturated arcade; expressive statement | Commercial mobile game UI calibrates high-contrast action hierarchy, saturated roles, and dense game-menu organization. | Adopt inspiration-only: strong primary/secondary action hierarchy, event/menu scannability, and energetic arcade social density. | Reject character art, franchise identity, decorative game assets, and any glossy/game-specific treatment. | Direct page open was blocked; if Phase 3.4 needs screenshots, capture through browser/manual workflow or use another accessible screenshot source. |
| Royal Match screenshots on MobyGames | https://www.mobygames.com/game/204301/royal-match/screenshots/ | directly extracted; browser/manual verified | 2026-05-06 | commercial example | playful bubbly; friendly daylight | Screenshot index exposes colorful play, rewards, title, and competition surfaces from a shipped mobile puzzle game. | Adopt inspiration-only: approachable reward/action clarity, large touch surfaces, and friendly casual-game feedback density. | Reject illustrative castle/candy art, gradients, glossy materials, and any decorative content as Theme identity. | None for Phase 3.3. |

Coverage notes:

- dark saturated arcade is covered by Brawl Stars, SunGraphica, and the user-v0 Midnight/Cabinet color DNA carried in local research.
- modern minimal dark is covered by Material Web theming, MD3 token discipline, and Orbital Playdeck DNA.
- playful bubbly is covered by the two user exemplars, GameArt2D, MODI, Pinky UI, and Royal Match.
- friendly daylight is covered by HCGames, GameArt2D, Kenney, Material Expressive Wear guidance, Pinky UI, and Royal Match.
- expressive statement is covered by Google Expressive research, Android Developers Expressive sources, fajrulaslim, MODI, SunGraphica, and Brawl Stars.

## v0 Feedback DNA Mapping

Pending Plan 02.

## Candidate Directions

Pending Plan 02.

## Filter Audit Summary

Pending Plan 02.

## User Approval Checkpoint

Pending Plan 03. Approval is text-level only per D-12 and D-13. No mockups, design tokens, subclass code, or `.tres` resources are created in this phase.

## Phase 3.3 Verification Log

### 2026-05-06 - Plan 01 survey shell and commercial survey

| Check | Result |
|---|---|
| survey count | PASS: 14 baseline sources documented; D-03c expansion beyond 15 not used. |
| personality anchor coverage | PASS: dark saturated arcade, modern minimal dark, playful bubbly, friendly daylight, and expressive statement each have at least one survey row. |
| inspiration-only language | PASS: every external row uses adopt/reject/open notes and states inspiration-only adoption boundaries. |
| no mockup/image/addon/theme `.tres`/font/icon/scene/project file intentionally changed | PASS: Plan 01 edits are limited to this research document and `.planning/STATE.md` workflow metadata. |
| phase boundary | PASS: document states no mockups, no concept images, no production theme resources, no addon files, and no `.tres` styling commits. |
