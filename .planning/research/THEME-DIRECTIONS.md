# NeoCade Theme Direction Research

**Phase:** 03.3-theme-direction-research  
**Created:** 2026-05-06  
**Status:** Awaiting user text-level approval checkpoint.

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

Per D-01, D-01b, D-01c, D-04, and D-05, v0 directions are DNA inputs, not automatic carryovers. Boardwalk Sunset is hard-rejected and contributes no direction identity; the only usable lesson is "flat/simple felt closer", which is already absorbed by the universal flat-MD3 mandate.

| v0 direction | Liked DNA to extract | Rejected traits to drop | Eligible downstream use | Candidate direction(s) informed |
|---|---|---|---|---|
| Midnight Marquee | Dark surface, saturated accent energy, LDtk-like arcade/control-panel color confidence. | 3D elements, textured background panels, painterly venue mood. | Color and energy DNA only, flattened through MD3 roles. | ArcadePulse |
| Boardwalk Sunset | Only the flat/simple lesson, already covered by D-01c. | Hard-rejected; warm leather/old-fashioned mood, textured/painterly background, baseline recommendation status. | No downstream direction identity; no name carryover. | None |
| Cabinet Chrome | Dark/clean palette similar to Midnight Marquee, professional arcade/editor confidence. | 3D cabinet framing, chrome/material cue, texture. | Color restraint and neutral-ramp DNA only. | ArcadePulse; OrbitalSlate |
| Prize Pop Plaza | Childish, friendly, mobile-game vibe; simple raised interactables can work when built from flat fills. | Texture, embossing, jelly/painterly material, asset-art dependency. | Personality lineage may survive because the user loved the concept after flat/extruded-flat filtering. | PrizePopPlaza |
| Orbital Playdeck | Modern/safest dark theme, big buttons, color only where it matters, nice iOS-like rounding. | Textured backgrounds and any space/sci-fi HUD drift. | Modern minimal dark and restrained accent DNA. | OrbitalSlate |

## Candidate Directions

Shared direction constraints: All five are peer candidates per D-03 and D-03b. No base direction is selected here; base direction deferred to Phase 3.4. Each direction must work through the same dynamic `NeoCadeTheme` export model: `raised`, `platform`, `base_color`, and `accent_color`. D-06 seeded archetypes were retained because the survey provided evidence for all five anchors. D-14 and D-15 naming rules are applied through PascalCase future subclass names ending in `NeoCadeTheme`, with no cyber/synth/noir-coded names. D-16 carries Inter Variable Roman, dynamic superclass compatibility, and coverage discipline into every direction.

### ArcadePulseNeoCadeTheme

- Direction display name: Arcade Pulse
- Future subclass form: ArcadePulseNeoCadeTheme
- Suggested future `.tres` filename stem: `arcade_pulse_neocade_theme`
- Base color: #151A2E
- Accent color: #8BFF6A
- Contrast ratio: 13.62:1 - WCAG AA PASS
- Personality / palette / mood summary: Dark saturated arcade energy with a near-navy control-panel base and a lively green accent that reads like active cabinet buttons, not nightclub glow. The mood is social, fast, and clear: a vibrant arcade hall by day with the lights on and the UI doing the work. It takes the Midnight Marquee and Cabinet Chrome color DNA but removes all 3D, texture, chrome, and mood-board haze.
- Target use case: Multiplayer arcade lobbies, action-game menus, streamer-friendly tool surfaces, and dark runtime/editor UI where strong active states matter.
- Flat-mode behavior: Solid tonal surfaces use the base as the root/panel family, with the accent reserved for primary actions, selected tabs, focus rings, and high-value toggles.
- Raised-mode behavior: Filled buttons and selected chip/tab surfaces gain small extruded-flat offset duplicates in darker tonal variants; panels, inputs, lists, and passive labels stay flat for density.
- Mobile-sizing notes: Mobile keeps the same personality but increases button/toggle targets toward iOS 44pt and Android 48dp floors; the bright accent is limited to action/focus roles so small screens do not become noisy.
- DNA inputs used: Midnight Marquee palette love; Cabinet Chrome dark-clean palette; Boardwalk Sunset rejection as a no-texture reminder only.
- Commercial examples used: Brawl Stars screenshot collection for strong action hierarchy; SunGraphica for dark flat game UI breadth; Material Web for role-token discipline.
- Rationale: Phase 3.1 supports saturated but controlled color, state layers, and MD3 surface roles; Phase 3.2 supports export-driven base/accent regeneration through one subclass. This direction satisfies D-03 by taking the dark saturated arcade anchor, D-03b by supporting both flat/raised and desktop/mobile, and D-16 by staying Inter-only and Theme-compatible.
- Filter audit status: PASS; see Filter Audit Summary.

### OrbitalSlateNeoCadeTheme

- Direction display name: Orbital Slate
- Future subclass form: OrbitalSlateNeoCadeTheme
- Suggested future `.tres` filename stem: `orbital_slate_neocade_theme`
- Base color: #111820
- Accent color: #8BD3FF
- Contrast ratio: 10.94:1 - WCAG AA PASS
- Personality / palette / mood summary: Calm modern minimal dark with cool slate surfaces, restrained blue accenting, and iOS-like rounding. The personality is the "safest modern" candidate: polished, readable, and quiet without becoming corporate-flat or sci-fi. It preserves Orbital Playdeck's safety and big-button clarity while dropping textured/space-ui baggage.
- Target use case: Desktop tools, editor-style runtime UIs, settings-heavy games, launchers, and projects that want a premium dark default.
- Flat-mode behavior: Most controls use subtle tonal separation and clear focus rings; the accent appears only in primary actions, selection, caret/focus, and important active states.
- Raised-mode behavior: Raised mode is restrained: 1-2px hard offset or stronger outline on primary/button-like controls only, with no lifted shells or decorative depth.
- Mobile-sizing notes: Mobile mode keeps the quiet palette but expands spacing and button-like constants toward 44pt/48dp floors; focus rings stay high-contrast because the accent is sparse.
- DNA inputs used: Orbital Playdeck modern/dark/big-button DNA; Cabinet Chrome clean dark palette; rejected Orbital texture as a hard boundary.
- Commercial examples used: Material Web theming for token hierarchy; Android Developers Material 3 guidance for role pairing; Kenney UI Pack for restrained reusable shapes.
- Rationale: Phase 3.1's MD3 role system and state-layer discipline are strongest here; Phase 3.2's dynamic subclass contract lets this direction tune profile values without losing full base coverage. This direction covers the modern minimal dark D-06 anchor while still satisfying D-03b universal axes and D-14/D-15 naming.
- Filter audit status: PASS; see Filter Audit Summary.

### PrizePopPlazaNeoCadeTheme

- Direction display name: Prize Pop Plaza
- Future subclass form: PrizePopPlazaNeoCadeTheme
- Suggested future `.tres` filename stem: `prize_pop_plaza_neocade_theme`
- Base color: #FFF4FA
- Accent color: #7B1B55
- Contrast ratio: 9.19:1 - WCAG AA PASS
- Personality / palette / mood summary: Friendly, childlike, and mobile-game-bright with a soft candy-counter base and deep berry accent. This is the playful bubbly option, but "bubbly" is personality, not material: it remains flat, solid, and clean in normal mode. The name survives because the user explicitly loved the concept, while the old textured/embossed treatment does not.
- Target use case: Casual games, cozy menus, tutorial-heavy experiences, family-friendly apps, and mobile-first game UIs that need warmth without asset-art dependency.
- Flat-mode behavior: Controls use rounded solid fills, generous state-layer contrast, and cheerful but sparse accent placement; backgrounds stay simple and unillustrated.
- Raised-mode behavior: Buttons, stepper-like controls, and selected playful affordances can use 3-5px extruded-flat offsets; large panels and text inputs remain flat so the theme does not become toy-like chrome.
- Mobile-sizing notes: Mobile mode leans into larger buttons and toggles with 44pt/48dp minimum targets, while desktop mode tempers spacing to remain usable for editor/runtime panels.
- DNA inputs used: Prize Pop Plaza loved personality; user exemplar flat/raised button grammar; Boardwalk Sunset rejection prevents warm textured drift.
- Commercial examples used: HCGames Flat GUI, fajrulaslim UI Button Flat Design, GameArt2D, MODI, Pinky UI, and Royal Match.
- Rationale: Phase 3.1 validates extruded-flat as a solid top shape plus offset darker duplicate; MD3 Expressive supports stronger static personality through color, shape, and hierarchy. Phase 3.2 lets the same subclass support flat/raised and desktop/mobile from exports, satisfying D-03b and D-16.
- Filter audit status: PASS; see Filter Audit Summary.

### DaybreakLobbyNeoCadeTheme

- Direction display name: Daybreak Lobby
- Future subclass form: DaybreakLobbyNeoCadeTheme
- Suggested future `.tres` filename stem: `daybreak_lobby_neocade_theme`
- Base color: #EAF7F1
- Accent color: #006A68
- Contrast ratio: 5.85:1 - WCAG AA PASS
- Personality / palette / mood summary: Welcoming daylight arcade by day: mint-clean surfaces, teal wayfinding, and a lighter social-lobby mood. This direction exists to keep the five-theme spread honest; it is not a global light-mode system and does not create a new export axis. It should feel approachable and fresh while staying reusable for serious controls.
- Target use case: Community hubs, onboarding flows, cozy game menus, family-friendly settings screens, and bright mobile experiences.
- Flat-mode behavior: Flat mode uses clear high-contrast teal for primary/focus/selection and keeps secondary surfaces quiet through MD3 tonal roles rather than illustration.
- Raised-mode behavior: Raised mode adds tactile depth mainly to primary actions and cards-as-actions; ordinary panels, lists, and text fields remain flat for readability.
- Mobile-sizing notes: Mobile mode uses the same 44pt iOS and 48dp Android floor language as the other directions, with slightly more breathing room around touch clusters to preserve the daylight calm.
- DNA inputs used: Phase 3.1 daylight-friendly gap; HCGames/GameArt2D/Kenney friendliness; the "vibrant arcade hall by day" project identity.
- Commercial examples used: HCGames, GameArt2D, Kenney, Pinky UI, Royal Match, and Android Developers Expressive Wear guidance.
- Rationale: MD3/MD3 Expressive supports brighter tonal seeds and accessible role pairing, while NeoCade's dynamic base/accent exports let a bright default remain user-adjustable. This direction satisfies D-03 by widening personality spread and D-03b by treating desktop/mobile and flat/raised as universal, not identity.
- Filter audit status: PASS; see Filter Audit Summary.

### FestivalBurstNeoCadeTheme

- Direction display name: Festival Burst
- Future subclass form: FestivalBurstNeoCadeTheme
- Suggested future `.tres` filename stem: `festival_burst_neocade_theme`
- Base color: #20112E
- Accent color: #FFD166
- Contrast ratio: 12.33:1 - WCAG AA PASS
- Personality / palette / mood summary: The maximum MD3 Expressive statement: bold, celebratory, high-contrast, and saturated without using glow or nightclub cues. A deep plum base keeps the UI grounded while the warm gold accent makes primary action and focus feel event-like. It is the loudest candidate, intended to test how expressive NeoCade can be while staying professional.
- Target use case: Mini-game launchers, achievement/reward surfaces, party-game menus, showcase scenes, and brand-forward projects that still need all controls to be readable.
- Flat-mode behavior: Flat mode uses a disciplined dark surface ladder with the accent for critical actions, focus, selected states, progress, and reward-like callouts.
- Raised-mode behavior: Raised mode can use stronger extruded-flat button offsets and bolder corner radii on button-like controls, but range controls, inputs, tree/list rows, and panels stay stable and flat.
- Mobile-sizing notes: Mobile mode preserves the celebratory accent but enlarges touch affordances to 44pt/48dp targets and avoids filling every row with gold, which would reduce scan speed.
- DNA inputs used: Phase 3.1 MD3 Expressive findings; Prize Pop Plaza friendliness at a more polished intensity; Midnight/Cabinet dark arcade grounding.
- Commercial examples used: Google Expressive research, Material 3 Expressive official blog, Android Developers Blog for M3 Expressive, fajrulaslim, MODI, SunGraphica, and Brawl Stars.
- Rationale: This direction is the D-06 expressive statement anchor. It uses MD3 Expressive's static levers - color confidence, shape, containment, and emphasis - while Phase 3.2's superclass/subclass model keeps the implementation deterministic and complete.
- Filter audit status: PASS; see Filter Audit Summary.

## Filter Audit Summary

DESIGN-NEW-DIR-02 and D-07 audit result: all five directions pass after applying universal flat-MD3, anti-texture, anti-cyberpunk, and dynamic-export constraints.

| Direction | anti-cyberpunk | anti-texture | universal-axes-still-work | no base-direction preselection | no mockup or `.tres` output |
|---|---|---|---|---|---|
| ArcadePulse | PASS: Arcade energy is role/color hierarchy, not synth/noir framing. | PASS: Solid dark surfaces, no patterns, no embossing, no chrome material. | PASS: flat-mode surface uses #151A2E tonal ladder with #8BFF6A as action/focus; raised-mode depth uses small darker offset on pressable controls; mobile sizing explicitly respects 44pt iOS and 48dp Android floors. | PASS: Peer candidate only; base direction deferred. | PASS: Research text only. |
| OrbitalSlate | PASS: "Orbital" is retained as modern calm, not space HUD vocabulary. | PASS: Minimal dark surfaces and outlines only. | PASS: flat-mode surface stays quiet and role-driven; raised-mode depth is restrained 1-2px offset/outline for primary actions; mobile sizing expands touch controls to 44pt/48dp while preserving sparse accent. | PASS: Peer candidate only; base direction deferred. | PASS: Research text only. |
| PrizePopPlaza | PASS: Playful mobile-game tone has no dystopian or scanline framing. | PASS: Candy-like mood is expressed through solid color and shape, not texture, emboss, or glossy material. | PASS: flat-mode surface uses cheerful solids; raised-mode depth uses 3-5px extruded-flat offsets on button-like controls; mobile sizing uses 44pt/48dp targets and denser desktop restraint. | PASS: Peer candidate only; base direction deferred. | PASS: Research text only. |
| DaybreakLobby | PASS: Daylight social-lobby mood is explicitly non-noir. | PASS: Clean mint/teal solids, no leather/wood/grunge/painterly treatment. | PASS: flat-mode surface uses bright tonal roles and teal focus/action; raised-mode depth lifts only actions/cards-as-actions; mobile sizing adds touch breathing room while meeting 44pt/48dp floors. | PASS: Peer candidate only; base direction deferred. | PASS: Research text only. |
| FestivalBurst | PASS: Expressive does not mean synth/nightclub; no glow or sci-fi HUD dependency. | PASS: Event-like emphasis comes from color contrast, not decorative materials. | PASS: flat-mode surface uses deep plum role ladder with warm accent; raised-mode depth allows stronger offsets on key buttons only; mobile sizing keeps 44pt/48dp controls and limits accent saturation in dense rows. | PASS: Peer candidate only; base direction deferred. | PASS: Research text only. |

No direction is differentiated by being flat, raised, desktop, mobile, or base. All five are personality directions that support the same export axes.

## User Approval Checkpoint

CHECKPOINT REACHED: Phase 3.3 text-level direction approval is pending.

D-12 and D-13 checkpoint scope: approval is text-level only. No mockups, design tokens, subclass code, production addon files, or `.tres` resources are created in Phase 3.3. Phase 3.4 may mock up the approved directions only after this checkpoint is resolved.

Revision round: 0/2

| Option | Meaning | Result |
|---|---|---|
| approve | Approve these five directions for Phase 3.4 mockups. | Phase 3.3 can close after verification; Phase 3.4 may mock up the approved set. |
| revise | Revise specific directions by name, up to two focused revision rounds. | The named directions are updated, checks rerun, and this checkpoint returns. |
| reject all | Reject all five directions. | Stop before mockup effort and open escalation discussion for a new direction strategy. |

Five directions awaiting decision:

| Direction | Future subclass | Base color | Accent color | One-sentence personality summary |
|---|---|---|---|---|
| Arcade Pulse | ArcadePulseNeoCadeTheme | #151A2E | #8BFF6A | Dark saturated arcade energy with a near-navy control-panel base and lively green action/focus accent. |
| Orbital Slate | OrbitalSlateNeoCadeTheme | #111820 | #8BD3FF | Calm modern minimal dark with restrained blue accenting and iOS-like clarity. |
| Prize Pop Plaza | PrizePopPlazaNeoCadeTheme | #FFF4FA | #7B1B55 | Friendly, childlike, mobile-game-bright, and tactile without texture or embossing. |
| Daybreak Lobby | DaybreakLobbyNeoCadeTheme | #EAF7F1 | #006A68 | Welcoming daylight arcade by day with mint-clean surfaces and teal wayfinding. |
| Festival Burst | FestivalBurstNeoCadeTheme | #20112E | #FFD166 | Bold MD3 Expressive statement with deep plum grounding and warm event-like emphasis. |

## Phase 3.3 Verification Log

### 2026-05-06 - Plan 01 survey shell and commercial survey

| Check | Result |
|---|---|
| survey count | PASS: 14 baseline sources documented; D-03c expansion beyond 15 not used. |
| personality anchor coverage | PASS: dark saturated arcade, modern minimal dark, playful bubbly, friendly daylight, and expressive statement each have at least one survey row. |
| inspiration-only language | PASS: every external row uses adopt/reject/open notes and states inspiration-only adoption boundaries. |
| no mockup/image/addon/theme `.tres`/font/icon/scene/project file intentionally changed | PASS: Plan 01 edits are limited to this research document and `.planning/STATE.md` workflow metadata. |
| phase boundary | PASS: document states no mockups, no concept images, no production theme resources, no addon files, and no `.tres` styling commits. |

### 2026-05-06 - Plan 02 direction synthesis and filter audit

| Check | Result |
|---|---|
| v0 DNA mapping | PASS: Midnight Marquee, Boardwalk Sunset, Cabinet Chrome, Prize Pop Plaza, and Orbital Playdeck are mapped with liked DNA, rejected traits, and downstream use. |
| Boardwalk Sunset handling | PASS: hard-rejected and not carried forward as a candidate direction. |
| candidate count | PASS: exactly five peer candidate directions were documented: ArcadePulse, OrbitalSlate, PrizePopPlaza, DaybreakLobby, and FestivalBurst. |
| D-06 archetype validation | PASS: all five seeded anchors had commercial survey support, so no replacement archetype was needed. |
| contrast verification | PASS: all base/accent pairs exceed the deliberate 4.5:1 WCAG AA floor for normal text/icons/focus usage. |
| universal axes | PASS: every direction documents flat-mode behavior, raised-mode behavior, and mobile-sizing notes; none is the flat, raised, desktop, mobile, or base theme. |
| filter audit | PASS: every direction passes anti-cyberpunk, anti-texture, universal-axes-still-work, no-base-preselection, and no-mockup/no-.tres checks. |

### 2026-05-06 - Plan 03 final coverage audit and checkpoint

ROADMAP success criteria audit:

| SC | Roadmap success criterion | Evidence | Status |
|---|---|---|---|
| SC-01 | THEME-DIRECTIONS.md produced with 5 candidate directions, subclass-form names, base/accent hex values, WCAG AA contrast, personality summaries, target use cases, filter audit, and rationale. | Candidate Directions section and Filter Audit Summary. | PASS |
| SC-02 | Names may keep, revise, or replace per fit; Boardwalk Sunset is hard-rejected. | v0 Feedback DNA Mapping and direction naming decisions. | PASS |
| SC-03 | Five directions span personality space, not five similar themes. | ArcadePulse, OrbitalSlate, PrizePopPlaza, DaybreakLobby, FestivalBurst cover the five D-06 anchors. | PASS |
| SC-04 | Per-v0-direction reaction to DNA mapping table exists. | v0 Feedback DNA Mapping table names liked DNA, rejected traits, eligible use, and informed directions. | PASS |
| SC-05 | Commercial example survey documents 10-15 references and each direction cites surveyed examples. | 14-source Commercial Example Survey; each candidate lists commercial examples used. | PASS |
| SC-06 | Anti-cyberpunk and anti-texture filter pass per direction. | Filter Audit Summary rows for all five directions. | PASS |
| SC-07 | Universal flat-MD3 revisions apply across all directions. | Candidate shared constraints plus per-direction flat/raised behavior. | PASS |
| SC-08 | Base-direction selection is not pre-decided. | Shared constraints and audit state base direction deferred / no base preselection. | PASS |
| SC-09 | User-approval checkpoint is presented at text level. | User Approval Checkpoint section with approve/revise/reject all choices and Revision round: 0/2. | PENDING USER |
| SC-10 | SOURCES.md Section 14 added with adopt/reject/open synthesis. | `.planning/research/SOURCES.md` Section 14. | PASS |
| SC-11 | No mockup commits and no `.tres` commits. | Changed-file audit limited to `.planning/` markdown workflow artifacts. | PASS |

Requirement coverage audit:

| Requirement | Evidence | Status |
|---|---|---|
| RES-NEW-06 | Five candidate theme directions derived from user goals, restrictions, v0 DNA, survey, Phase 3.1, and Phase 3.2. | PASS |
| DESIGN-NEW-DIR-01 | Commercial Example Survey contains 14 baseline sources with access status, retrieved date, role, anchor, adopt/reject/open notes. | PASS |
| DESIGN-NEW-DIR-02 | Filter Audit Summary covers each direction against anti-cyberpunk, anti-texture, universal axes, no base preselection, and no mockup/.tres output. | PASS |
| DOCS-05 | SOURCES.md Section 14 updated for Phase 3.3. | PASS |

Context decision audit:

| Decision | Coverage | Status |
|---|---|---|
| D-01 | Names kept/revised/replaced by fit: Prize Pop Plaza retained; other direction names revised/replaced; Boardwalk Sunset dropped. | PASS |
| D-01b | base direction deferred to Phase 3.4; no base preselection in Phase 3.3. | PASS |
| D-01c | Universal no-texture/no-pattern/no-embossing/flat-MD3/dynamic-export constraints apply to all directions. | PASS |
| D-02 | Input priority is encoded in Provenance and Scope and applied to synthesis. | PASS |
| D-03 | Broad spread covered by five distinct personality anchors. | PASS |
| D-03b | Universal flat/raised and desktop/mobile axes documented for every direction. | PASS |
| D-03c | Expansion not needed; 14 baseline sources cover all seeded anchors. | PASS |
| D-04 | v0 feedback DNA table maps liked and rejected traits. | PASS |
| D-05 | Boardwalk Sunset contributes no direction identity. | PASS |
| D-06 | Seed archetypes validated by commercial survey rows. | PASS |
| D-07 | Per-direction filter audit complete. | PASS |
| D-08 | Commercial survey includes 10-15 baseline sources with anchor coverage. | PASS |
| D-09 | Inspiration-only discipline stated in source contract and every external survey row. | PASS |
| D-10 | Required output structure exists. | PASS |
| D-11 | SOURCES.md Section 14 added. | PASS |
| D-12 | Approval gate options are approve, revise, reject all. | PENDING USER |
| D-13 | Approval is text-level only before mockups. | PASS |
| D-14 | Candidate future subclass forms are PascalCase and end in NeoCadeTheme. | PASS |
| D-15 | Names avoid forbidden cyber/synth/noir coding; Boardwalk Sunset absent as candidate. | PASS |
| D-16 | Inter Variable Roman and dynamic `NeoCadeTheme` superclass compatibility are preserved. | PASS |

Final no-forbidden-file audit: PASS. No mockup, image, addon, theme resource, font, icon, scene, project, production `.gd`, or `.tres` file was intentionally changed during Phase 3.3 execution.
