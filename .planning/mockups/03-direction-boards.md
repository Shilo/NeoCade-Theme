---
phase: 03-visual-direction-mockup-approval-gate
artifact: five-direction-boards
status: derivation-started
font-baseline: Inter Variable Roman only
---

# NeoCade Five Direction Boards

Concept images and detailed direction boards are produced after this derivation section. The boards are concept-design artifacts only; they do not modify `.tres` files or addon styling.

## Direction Derivation

### Locked Anchor Directions

The first three directions remain the traceable anchors from Phase 3 context and the prior architecture research:

| Direction | Source basis | Core read | Differentiating axes |
| --- | --- | --- | --- |
| **Midnight Marquee** | ARCHITECTURE.md Palette A, refined prototype direction, MB-001, MB-017, MB-020, MB-021 | Cool cabinet hall with warm marquee correction. | Dense display strips, deeper navy surface ramp, cabinet-row rhythm, warm pink/amber guardrails against synthwave. |
| **Boardwalk Sunset** | ARCHITECTURE.md Palette B, recommended baseline, MB-002, MB-005, MB-006, MB-008, MB-018 | Warm public arcade hall by day or early evening. | Warm pine/panel surfaces, amber/coral/mint accents, calmer editor-safe layout, hospitality warmth. |
| **Cabinet Chrome** | ARCHITECTURE.md Palette C, LDtk/minimal-theme discipline, MB-003, MB-007, MB-011, MB-019, MB-020 | Polished cabinet hardware and neutral professional chrome. | Charcoal panels, machine-like control decks, crisp orange focus, lower personality risk, strong editor fit. |

Boardwalk Sunset remains the recommended baseline because it best matches the locked v1 consistency principle and the real-venue arcade read: colorful and fun without turning into cyberpunk, synthwave, or a game-specific spaceship console.

### Mood-Board Evidence Clusters

| Cluster | Mood-board IDs | Design moves extracted |
| --- | --- | --- |
| Warm modern venue | MB-001..MB-011 | Public entertainment zoning, approachable density, cabinet rows, warm lighting, party/social surfaces, and readable attraction signage. |
| Prize, ticket, counter, and crane | MB-012..MB-016 | Transparent prize bays, candy-bright reward color, large button/joystick affordances, card/ticket progression, and success-state clarity. |
| Classic cabinet, barcade, and pinball | MB-017..MB-021 | Marquee rhythm, upright cabinet silhouette, chrome rails, control-deck proportions, score inserts, and tactile mechanical accents. |
| Future/neo/immersive venue | MB-010, MB-022..MB-025 | Playful portals, projected light fields, modular challenge rooms, clean onboarding stations, and visitable future polish. |

### Direction 4 Candidates Considered

| Candidate | Why considered | Why it lost or won |
| --- | --- | --- |
| **Prize Pop Plaza** | Strongly grounded in MB-012..MB-016; distinct from the three anchors; brings reward-loop color, transparent cases, and touchable controls into the theme vocabulary. | **Won.** It is the most evidence-backed new lane and adds a playful arcade-specific energy without needing sci-fi. |
| Crane Candy Concourse | Clear and vivid, but "candy" risks reading too childish and too snack/prize specific. | Lost to Prize Pop Plaza because "plaza" keeps it public-venue and reusable. |
| Ticket Rush Arcade | Good reward-state signal, but too motion/score focused and less useful for surface/material decisions. | Lost because it underplays shape and material language. |
| Victory Counter | Accurate to redemption areas, but narrower and less energetic. | Lost because it feels like a component subset, not a full art direction. |

### Direction 5 Candidates Considered

| Candidate | Why considered | Why it lost or won |
| --- | --- | --- |
| **Orbital Playdeck** | Grounded in MB-010 and MB-022..MB-025; supports the user's open spaceship/sci-fi possibility while staying venue-like and friendly. | **Won.** "Playdeck" reads as public entertainment space, not cockpit or command terminal. |
| Neon Habitat | Approachable but too close to banned neon/synthwave language. | Rejected for drift risk. |
| Starport Arcade | Fun, but "starport" can pull too much toward worldbuilding and away from reusable Godot theme. | Lost because it sounds more like VirtuCade world lore than NeoCade theme language. |
| Future Fairway | Friendly, but too soft and less arcade-specific. | Lost because it does not carry enough control-surface or panel geometry. |

### Final Five Direction Set

1. **Midnight Marquee** - Cool cabinet hall, warm marquee correction, highest nostalgia/prototype continuity.
2. **Boardwalk Sunset** - Warm real-venue arcade hall, recommended baseline, strongest daylit NeoCade identity.
3. **Cabinet Chrome** - Polished machine surfaces, LDtk/minimal-theme discipline, safest editor-facing option.
4. **Prize Pop Plaza** - Bright prize/counter/crane energy, reward-state clarity, accessible big-button playfulness.
5. **Orbital Playdeck** - Friendly future arcade deck, spaceship-adjacent but public and optimistic.

### Risks And Anti-Cyberpunk Guardrails

| Direction | Primary risk | Guardrail |
| --- | --- | --- |
| Midnight Marquee | Cool blue plus pink can drift synthwave. | Keep pink warm, use amber focus, avoid grids, scanlines, glow halos, and noir darkness. |
| Boardwalk Sunset | Warm surfaces can become brown/orange-heavy. | Preserve mint/teal and coral accents, keep contrast high, and use restrained panel density. |
| Cabinet Chrome | Can become generic editor/minimal theme. | Keep arcade cabinet control-deck geometry and orange focus rhythm visible. |
| Prize Pop Plaza | Can become childish or toy-store-like. | Extract reward clarity and transparent prize-case geometry without mascots, stickers, or novelty fonts. |
| Orbital Playdeck | Can become Tron, cyberpunk, or a spaceship cockpit. | Keep it bright, social, and visitable; use clean immersive-venue surfaces, not military, terminal, glitch, or dystopian cues. |

All directions use Inter Variable Roman only. Heading distinction comes from optical size, weight, scale, density, and composition, with synthetic italic and functional system-fallback samples shown in the detailed boards.

## Concept Image Outputs

Concept image: mood/atmosphere and shape-language reference, not a final UI preview.

| Direction | Concept image | Prompt |
| --- | --- | --- |
| Midnight Marquee | `concepts/midnight-marquee-concept.png` | `concepts/midnight-marquee-prompt.md` |
| Boardwalk Sunset | `concepts/boardwalk-sunset-concept.png` | `concepts/boardwalk-sunset-prompt.md` |
| Cabinet Chrome | `concepts/cabinet-chrome-concept.png` | `concepts/cabinet-chrome-prompt.md` |
| Prize Pop Plaza | `concepts/prize-pop-plaza-concept.png` | `concepts/prize-pop-plaza-prompt.md` |
| Orbital Playdeck | `concepts/orbital-playdeck-concept.png` | `concepts/orbital-playdeck-prompt.md` |

## Compact Comparison Matrix

| Axis | Midnight Marquee | Boardwalk Sunset | Cabinet Chrome | Prize Pop Plaza | Orbital Playdeck |
| --- | --- | --- | --- | --- | --- |
| Palette warmth | Cool navy with amber correction | Warm pine, amber, coral, mint | Neutral charcoal with orange focus | Dark neutral plus bright prize colors | Clean dark future with teal, amber, citrus, violet |
| Density | Dense cabinet rows | Moderate public venue flow | Compact professional panels | Organized prize-wall density | Airier modular play zones |
| Shape language | Bezel strips, marquee headers | Small-radius panels, ticket tabs | Hardware rails, bevels, control decks | Transparent bays, chunky controls | Rounded decks, capsules, modular portals |
| Risk | Synthwave if cyan/pink dominate | Brown/orange overload if accents collapse | Generic editor chrome | Childish/toy-store drift | Tron/cockpit drift |
| Accessibility status | Pass with warm accent discipline | Pass and recommended | Pass; muted text needs care | Pass in sketch; black labels on bright fills | Pass in sketch; violet text needs tuning |

## Detailed Direction Boards

### Midnight Marquee

- **Promise:** Cool cabinet hall, warm marquee correction, and highest continuity with the original prototype.
- **Sources:** ARCHITECTURE Palette A; MB-001, MB-017, MB-020, MB-021.
- **Layout rhythm and density:** Dense rows, horizontal marquee strips, compact dialogs, stacked cabinet-panel rhythm.
- **Shape and control geometry:** Small-radius cabinet bezels, narrow tab caps, tactile button clusters, slider rails with illuminated thumbs.
- **Surface/material treatment:** Deep navy lacquered cabinet paint, amber panel caps, warm pink action rails, cyan support only.
- **Token sketch:** Surface ramp `#0F1626`, `#141C2F`, `#1A2440`, `#243154`, `#2E3D68`; accents `#4FB8FF`, `#FF7BAC`, `#FFC857`, `#5BD99B`, `#FFB454`, `#FF6B6B`, `#7D8CFF`, `#E8EFFC`.
- **Contrast sanity:** Body text 15.63:1 vs base; muted text 5.19:1 vs raised; focus 11.74:1 vs base. PASS, with `needs accessibility tuning` if cyan/pink compete as primary label colors.
- **State sketch:** Hover raises tonal panel one stop, pressed darkens and shifts 1px, focus uses 2px amber ring, disabled opacity stays above readable contrast for labels.
- **Typography:** Inter Variable Roman only; headings at larger `opsz` and `wght` 800. Synthetic italic sample is v1 oblique behavior. Latin plus non-Latin system fallback sample: `NeoCade / 日本語 / عربى`. Mono/code override sample: `Control.theme_type_variation = "CodeSmall"`.
- **Desktop/mobile notes:** Desktop can carry dense cabinet rhythm. Mobile expands interactive rows to 48px and reduces simultaneous marquee rails.

### Boardwalk Sunset

- **Promise:** Recommended baseline; warm real-venue arcade hall with amber focus, coral reward accents, mint counter color, and professional editor-safe composition.
- **Sources:** ARCHITECTURE Palette B; MB-002, MB-005, MB-006, MB-008, MB-018.
- **Layout rhythm and density:** Open public venue flow, moderate density, panels that feel like counters and booths.
- **Shape and control geometry:** Small-radius panels, ticket-stub tab accents, balanced lists, warm focus rails.
- **Surface/material treatment:** Warm dark pine, amber/coral/mint accents, cream text color, no-shadow tonal elevation.
- **Token sketch:** Surface ramp `#1A1410`, `#221A14`, `#2C2218`, `#3A2C20`, `#4A3828`; accents `#FFB347`, `#FF6B8A`, `#5DD3C3`, `#9CD168`, `#FFD166`, `#E84855`, `#D9C7B0`, `#FBF1E4`.
- **Contrast sanity:** Body text 16.33:1 vs base; secondary text 9.45:1 vs panel; amber focus 10.24:1 vs base; danger non-text 3.52:1 vs raised. PASS and recommended.
- **State sketch:** Hover warms panel by one surface stop, pressed uses deeper warm surface, focus is amber 2px ring, disabled keeps cream-to-warm contrast with reduced opacity.
- **Typography:** Inter Variable Roman only; headings at `opsz` 32 and `wght` 780. Synthetic italic sample is v1 oblique behavior. Latin plus non-Latin system fallback sample: `NeoCade / 한국어 / हिन्दी`. Mono/code override sample remains consumer-supplied.
- **Desktop/mobile notes:** Desktop is balanced and editor-friendly. Mobile uses 48px rows, fewer list columns, and the same warm focus signature.

### Cabinet Chrome

- **Promise:** Polished machine surfaces, LDtk/minimal-theme discipline, and safest editor-facing option.
- **Sources:** ARCHITECTURE Palette C; MB-003, MB-007, MB-011, MB-019, MB-020.
- **Layout rhythm and density:** Inspector grids, control-deck rows, precise separators, compact density.
- **Shape and control geometry:** Hardware rails, bevel-like tonal edges, tabbed deck modules, dark molded controls.
- **Surface/material treatment:** Graphite, brushed chrome cues, dark plastic, crisp orange focus.
- **Token sketch:** Surface ramp `#1E2229`, `#252A33`, `#2E333F`, `#3A404D`, `#475065`; accents `#FFB020`, `#5C9CFF`, `#FF7849`, `#7FD984`, `#FFCC00`, `#C1CFEB`, `#8E99B8`, `#F2F5FA`.
- **Contrast sanity:** Body text 14.6:1 vs base; secondary text 8.06:1 vs panel; muted text 4.34:1 vs panel. PASS, but muted small text needs accessibility tuning.
- **State sketch:** Hover brightens panel edge, pressed uses inset darker deck, focus is orange 2px ring, disabled reduces control chrome without hiding labels.
- **Typography:** Inter Variable Roman only; headings use tighter `opsz` 28 and `wght` 760. Synthetic italic sample is v1 oblique behavior. Latin plus non-Latin system fallback sample: `NeoCade / 中文 / עברית`. Mono/code override sample: inspector token preview.
- **Desktop/mobile notes:** Desktop is strongest for dense editor panels. Mobile requires de-densifying grids into 48px stacked rows.

### Prize Pop Plaza

- **Promise:** Bright prize/counter/crane energy, reward-state clarity, and accessible big-button playfulness.
- **Sources:** MB-012, MB-013, MB-014, MB-015, MB-016.
- **Layout rhythm and density:** Prize-wall modules, progress cards, card-station rows, chunky 48px-friendly actions.
- **Shape and control geometry:** Transparent bay frames, rounded control pads, card/ticket chips, joystick/button references.
- **Surface/material treatment:** Mature dark neutral base, glassy prize cases, coral/lemon/mint/aqua reward color.
- **Token sketch:** Surface ramp `#16191E`, `#1E242A`, `#2A3036`, `#343B42`, `#45515B`; accents `#FF6B61`, `#FFD34E`, `#9FE6B8`, `#5BDDE0`, `#FF8AB3`, `#FFB347`, `#B8E86B`, `#A78BFA`.
- **Contrast sanity:** Body text 16.73:1 vs base; secondary text 9.87:1 vs panel; muted text 6.10:1 vs panel; coral/lemon/aqua non-text accents all pass 3:1. Bright fills use black labels.
- **State sketch:** Hover raises prize tile, pressed darkens bay fill, focus uses aqua or lemon ring, disabled dims reward saturation while retaining label contrast.
- **Typography:** Inter Variable Roman only; headings use larger playful scale and `wght` 800. Synthetic italic sample is v1 oblique behavior. Latin plus non-Latin system fallback sample: `NeoCade / ไทย / العربية`. Mono/code override sample: `reward_id: PRIZE_A7`.
- **Desktop/mobile notes:** Naturally supports 48px tap targets. Mobile should paginate dense prize tiles and avoid toy-store clutter.

### Orbital Playdeck

- **Promise:** Friendly future arcade deck, spaceship-adjacent but public, social, optimistic, and constrained.
- **Sources:** MB-010, MB-022, MB-023, MB-024, MB-025.
- **Layout rhythm and density:** Modular playdeck zones, broad segmented controls, airy team-session panels.
- **Shape and control geometry:** Rounded decks, capsule controls, portal-like panel modules, broad focus rings.
- **Surface/material treatment:** Clean consumer-tech panels, projected play fields, teal/amber/violet accents on neutral future surfaces.
- **Token sketch:** Surface ramp `#11171C`, `#192128`, `#242D35`, `#303B45`, `#41505A`; accents `#58DAD3`, `#FFC24A`, `#B896FF`, `#9BE86E`, `#FF7A67`, `#62A8FF`, `#F3F07B`, `#E76F9A`.
- **Contrast sanity:** Body text 17.06:1 vs base; secondary text 9.42:1 vs panel; muted text 5.37:1 vs panel; teal/amber/violet accents pass 3:1 non-text. Violet needs tuning if used for small text.
- **State sketch:** Hover uses projected-panel lift, pressed darkens capsule, focus uses amber ring, disabled removes future glow and keeps structure legible.
- **Typography:** Inter Variable Roman only; future feel comes from spacing and panels, not sci-fi typography. Synthetic italic sample is v1 oblique behavior. Latin plus non-Latin system fallback sample: `NeoCade / 日本語 / हिन्दी`. Mono/code override sample: `session_state = "ready"`.
- **Desktop/mobile notes:** Desktop can use broad playdeck zones. Mobile uses 48px segmented controls and fewer simultaneous team panels.
