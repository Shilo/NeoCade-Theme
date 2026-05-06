# Direction Shape-Language Spec

**Phase:** 03.4-visual-direction-flat-extruded-flat-mockup-approval-gate
**Plan:** 02 (Stage 1 concept boards)
**Created:** 2026-05-06b (corrective rewrite)
**Replaces:** `fixed-control-order-spec.md` (deprecated — encoded a single-template / color-only-differentiation contract that collapsed all five directions to the same UI with hex swaps)
**Authoritative for:** Phase 3.4 Plan 02 (Stage 1 concept boards) and Plan 03 (finalist 4-grid mockups)

## Purpose

Phase 3.4 mockups must let the user pick a finalist on **direction personality**, not on color preference. Personality emerges from shape language, density, anatomy, and emphasis — not from base/accent hex values alone. This spec splits the mockup token system into:

- **Constants across all 5 directions** — so the user can compare directions side by side on the same screen, same controls, same content. (This is the user's explicit instruction: "each showcase/mockup should have the same controls and same order of controls, so i can verify the difference of each theme.")
- **Required-to-vary per direction** — so each direction expresses its personality through the visual style of those identical controls. (This is the user's explicit instruction: "what matters is unique mood, shapes, styles and everything else.")

A direction is NOT differentiated by being flat, raised, desktop, mobile, light, or dark. All five v1 directions are dark, all five support both raised modes, all five support both platform sizings — those are universal `@export` axes, not direction-identity axes. Each direction IS differentiated by its shape-language token values.

## Constants (held identical across all 5 directions)

These are part of the comparison contract. If any of these vary between Pulse, Slate, Bubble, Daybreak, and Burst, the comparison is broken.

### Page contract

- **Mode:** dark only (PROJECT.md "Out of Scope: Light color mode")
- **Aspect ratios:** desktop 1280×720, mobile 430×932 (matches Codex Plan 01 baseline)
- **Brand-mark slot:** top-left
- **Nav-tabs slot:** top-right
- **Body grid:** three columns — Action panel | Dialog stack | List/tree
- **Footer slots:** state strip + palette swatches at the bottom in that order
- **Type family:** Inter Variable Roman (per FONT-REVIEW.md UD-4 Option D)

### Control inventory and order

Every Stage 1 board must include the following controls in the following order. Labels and copy are fixed below so the comparison is honest.

| Slot | Control | Fixed labels / state |
|---|---|---|
| 1a | Brand mark | Direction display name (e.g., "Pulse") + secondary line `"Desktop flat / platform=DESKTOP / {contrast_ratio}"` |
| 1b | Nav tabs | `Lobby` (selected), `Cabinets`, `Profile`, `Settings` |
| 2a | Action panel header | `01 Action panel` |
| 2b | Primary button row | `Start` (primary), `Options` (secondary), `Cancel` (ghost) |
| 2c | Input field | label `INPUT FOCUS`, value `Player alias`, focused state |
| 2d | Toggle row | `Checked` (checkbox, checked) + `Voice` (switch, on) |
| 3a | Dialog header | `02 Dialog stack` |
| 3b | Segmented controls | `Lobby` (selected), `Match`, `Audio` |
| 3c | Popup surface | title `Popup surface`, body `Primary action, secondary action, stable text field, and focus ring.` |
| 3d | Progress bar | 62% filled |
| 3e | Dialog action row | `Confirm` (primary), `Back` (ghost) |
| 4a | List header | `03 List / tree` |
| 4b | Selected row | `Cabinet A` — meta `ready` |
| 4c | Normal row | `Mini-game list` — meta `3 new` |
| 4d | Normal row | `Settings row` — meta `stable` |
| 4e | Scrollbar | thumb at top |
| 5 | State strip | five cells in order: `normal`, `hover`, `focus`, `pressed`, `disabled` |
| 6 | Palette strip | four cells in order: surface-low, surface-panel, surface-high, accent |

### Variant matrix (Stage 1)

Per direction, render exactly three images:

1. `*-desktop-flat.png` — desktop sizing, `raised=false`
2. `*-mobile-flat.png` — mobile sizing, `raised=false`
3. `*-mobile-raised.png` — mobile sizing, `raised=true`

The 10-board matrix in CONTEXT.md D-04 (5 directions × flat + raised) is satisfied by these three variants per direction (raised is shown on mobile).

## Required-to-vary per direction (the personality channel)

For each axis below, every direction MUST commit to a distinct value, and the values together must produce visually different mockups even with the constants above held identical. **Color tokens (`base_color`, `accent_color`, surface ramp, state colors) are necessary but NOT sufficient differentiation.** All ten axes below must vary.

### Axis 1 — Corner radius scale

Each direction commits to a base radius `R` and a scale rule. Other radii in the direction derive from `R`.

| Direction | Base radius `R` | Scale | Feel |
|---|---|---|---|
| Pulse | 4-6px | tight cabinet (small) | cabinet bezel, control panel |
| Slate | 10-12px | iOS-pill medium | premium quiet rounded |
| Bubble | 16-22px | bubbly large + 999px on chips | pillowy candy squircle |
| Daybreak | 12-14px | medium-soft | airy friendly squircle |
| Burst | 14-18px chrome / 22+ on primary | bold expressive | dramatic statement |

### Axis 2 — Button anatomy

| Direction | Border-radius | Padding (h × v) | Border weight | Primary contrast strategy | Ghost treatment |
|---|---|---|---|---|---|
| Pulse | 4-6px | 14×10px | 1px outline | bold accent fill, dark text | accent-outlined, accent text |
| Slate | 10-12px | 16×11px | 1px outline | quiet pill primary | thin accent outline |
| Bubble | 18-22px | 20×14px | 1px outline | pillowy fully-rounded primary | rounded ghost with thicker outline |
| Daybreak | 12-14px | 18×12px | 1px outline | friendly primary, generous breathing | soft outline ghost |
| Burst | 14-18px (primary 22+) | 20×14px (primary 24×16px) | 1px or none on primary | oversized statement primary | normal accent ghost |

### Axis 3 — Chip / tab shape

| Direction | Tab shape | Tab corner radius | Selected indicator |
|---|---|---|---|
| Pulse | rectangular tab strip | 4px | accent fill + 2px bottom rule |
| Slate | rounded pill | 999px | accent fill, subdued |
| Bubble | fully-rounded pill (large) | 999px | accent fill, raised offset on selected |
| Daybreak | rounded rect | 12px | accent fill with mint halo behind |
| Burst | rounded rect, asymmetric on selected | 14px | accent fill + bigger size on selected |

### Axis 4 — Brand mark style

| Direction | Mark shape | Mark size | Decoration |
|---|---|---|---|
| Pulse | square cabinet bezel (sharp corners, 4px) | 54px desktop / 42px mobile | accent fill, dark border |
| Slate | rounded square | 54px / 42px | accent fill, no border |
| Bubble | circle or squircle (16-22px radius) | 54px / 42px | accent fill, soft halo |
| Daybreak | rounded square with bright accent halo | 54px / 42px | accent fill, halo behind |
| Burst | chunky badge, asymmetric | 60px / 48px | accent fill, dramatic outline |

### Axis 5 — Density / spacing scale

| Direction | Body padding | Inter-control gap | Card gap | Feel |
|---|---|---|---|---|
| Pulse | 18px | 10px | 14px | arcade-dense, packed |
| Slate | 22px | 14px | 18px | spacious, premium-quiet |
| Bubble | 22px | 14px | 18px | friendly-airy, generous |
| Daybreak | 24px | 16px | 20px | airy, breathing |
| Burst | 22px | 14px | 20px | event-spread, hierarchy-amplified |

### Axis 6 — Focus-ring style

| Direction | Thickness | Offset | Color | Style |
|---|---|---|---|---|
| Pulse | 2px solid | 0px | accent | tight cabinet ring |
| Slate | 2px solid | 2px | accent | iOS-style offset |
| Bubble | 3px solid | 2px | accent | cheerful chunky ring |
| Daybreak | 2px solid | 2px | accent + mint glow halo | airy fresh ring |
| Burst | 3px solid | 1px | accent | dramatic event ring |

### Axis 7 — Type-weight / emphasis scale

| Direction | H1 weight | H2 weight | Kicker treatment | Body |
|---|---|---|---|---|
| Pulse | 800 | 740 | uppercase tracked, accent-colored | 460 |
| Slate | 720 | 640 | small-caps subtle | 440 |
| Bubble | 800 | 760 | uppercase tracked, accent-colored | 460 |
| Daybreak | 720 | 660 | sentence case, accent-colored | 440 |
| Burst | 820 | 780 | uppercase bold, larger scale | 480 |

### Axis 8 — Surface ramp depth

Number of tonal stops + contrast magnitude between low/panel/high/overlay.

| Direction | Stops | Low→panel→high spread | Feel |
|---|---|---|---|
| Pulse | 4 stops | wide spread | arcade ladder, strong tonal hierarchy |
| Slate | 3 stops | narrow spread | calm continuous gradient feel |
| Bubble | 3 stops | medium spread | playful soft layers |
| Daybreak | 4 stops | medium spread | airy fresh layers |
| Burst | 4 stops | wide spread | dramatic layered emphasis |

### Axis 9 — State-layer behavior

| Direction | Hover | Pressed | Disabled |
|---|---|---|---|
| Pulse | brighten +6% | darken -10% | opacity 0.42 |
| Slate | brighten +4% | darken -6% | opacity 0.50 |
| Bubble | brighten +8% (bouncy) | darken -10% | opacity 0.45 |
| Daybreak | brighten +6% (lighten feel) | darken -6% | opacity 0.50 |
| Burst | brighten +8% | darken -12% (bold) | opacity 0.45 |

### Axis 10 — Raised offset depth (raised=true variants)

Per Phase 3.1 + 3.2 contract, raised mode adds a darker offset duplicate behind primary buttons / selected tabs / selected list rows. The offset depth varies per direction's depth personality.

| Direction | Primary button offset | Selected tab offset | Selected row offset | List of controls that lift |
|---|---|---|---|---|
| Pulse | 3px | 2px | 1px | primary buttons + selected tabs |
| Slate | 1-2px | 1px | none | primary buttons only |
| Bubble | 4-5px | 3px | 2px | primary buttons + selected tabs + selected rows + chips |
| Daybreak | 2-3px | 2px | none | primary buttons + selected tabs |
| Burst | 4-6px (primary), 2px (secondary) | 3px | 2px | primary buttons + selected tabs + selected rows |

## Per-direction commit checklist

For each of the five directions, before rendering any image, the executor must confirm the direction commits to specific values on all ten axes. Each direction's commitment is a small block of CSS variables / token values that will produce its mockups.

A direction passes shape-language validation when:

1. All ten axes have a committed value distinct from the same axis on at least 3 of the other 4 directions.
2. The committed values reflect the direction's documented personality from `.planning/research/THEME-DIRECTIONS.md`.
3. The committed values do not violate any Phase 3.1 anti-texture / anti-cyberpunk filter or Phase 3.2 dynamic-architecture compatibility.

## Sufficiency test

After rendering the 15 PNGs (5 directions × 3 variants), the executor must verify that the five directions look meaningfully different beyond color. The minimum bar is that **a reviewer who could not see color** (e.g., greyscale conversion) should still be able to identify each direction by shape language alone. If greyscale renders are indistinguishable, shape language has collapsed and the spec was not followed.

## Out of scope

- New direction names. The five names (Pulse, Slate, Bubble, Daybreak, Burst) are locked at Phase 3.3 with one-word generic non-trademark naming. Do not invent or rename.
- Changing approved palettes. The dark palettes are locked in `.planning/research/THEME-DIRECTIONS.md` Revision Round 2/2 and `.planning/mockups/3.4/wcag-palette-audit.md`.
- Wholly different layouts per direction. The constants section above is binding.
- Atmospheric venue artwork separate from the UI mockup. Phase 3.4 mockups are styled UI renders; mood is carried by the styling of the same screen.
- Production `.tres` styling, GDScript implementation, fonts, icons, scene work. Phase 4+ owns those.

## References

- `.planning/research/THEME-DIRECTIONS.md` — direction identities, palettes, personality
- `.planning/research/MD3-RESEARCH.md` — shape-language and emphasis grammar from MD3 / MD3 Expressive
- `.planning/research/FLAT-3D-UI-RESEARCH.md` — extruded-flat raised construction rules
- `.planning/research/GODOT-DYNAMIC-THEME-RESEARCH.md` — dynamic NeoCadeTheme contract
- `.planning/research/PITFALLS.md` — focus/state-combination pitfalls
- `.planning/mockups/3.4/wcag-palette-audit.md` — WCAG AAA evidence per direction
- `.planning/phases/03.4-visual-direction-flat-extruded-flat-mockup-approval-gate/03.4-CONTEXT.md` — Phase 3.4 decisions D-01 through D-27
- `.planning/phases/03.4-visual-direction-flat-extruded-flat-mockup-approval-gate/03.4-CORRECTIVE-ADDENDUM.md` — D-28, D-29, D-30 corrective decisions

## Why this spec exists (audit trail)

Phase 3.4 Plan 02 first execution (Codex, 2026-05-06) produced 15 PNGs that the user rejected because every direction looked like the same UI with a color swap. The original `fixed-control-order-spec.md` had locked the control order, layout, and template identical (correct) but had also held shape-language tokens (corner radius, button anatomy, density, brand-mark style, focus rings, etc.) implicitly identical (wrong). The spec said "Only theme variables change between directions: base_color, accent_color, derived dark surfaces, corner radius, and state colors" — which was already too narrow even on paper, and Codex's CSS hard-coded `--radius: 12px` for all five anyway.

This rewrite splits the token system into constants vs varying axes explicitly, names the ten axes, gives each direction a committed value per axis, and adds a greyscale sufficiency test. The same-screen comparison contract the user wants is preserved; the personality channel that was missing is added.
