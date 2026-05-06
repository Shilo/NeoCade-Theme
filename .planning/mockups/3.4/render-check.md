# Phase 3.4 Render Check

**Status (revision 3, 2026-05-06):** Mockup revision 3 complete per `MOCKUP-REVISION-3-HANDOFF.md` — surgical fix for the dark-surface near-black bottom-edge bug introduced by rev-2's `darken()` HSL helper. Surface-colored elements (panels, dialogs, popup overlays, brand-mark badge, state-strip cells, unselected tabs, selected list rows) now correctly land color-tinted offsets in their own hue family. 15 concept PNGs + 2 audit composites re-rendered. All other rev-2 decisions (wider radius spread, broader raised matrix, slideshow, platform sizing, mood differentiation) stand unchanged.

**Rev-3 fix:** Replaced `darken(color, 22%)` with `tintTowardBase(color, base, 0.40)` (= `mix(element_color, page_base, 40%)`) for `--accent-offset`, `--surface-panel-offset`, `--surface-high-offset`, `--surface-overlay-offset`, `--surface-low-offset`. The previous formula floored at HSL lightness 0 on already-dark surfaces (e.g., Bubble's `surface_panel` ≈ L=10%; minus 22 clamps to L=0 → near-black), reading as Neobrutalism — the look the user explicitly rejected. The new formula shifts each element 40% toward the page background, preserving hue at every brightness and never crossing past the base. The legacy `--offset` alias still uses `darken()` for a distinct-from-base sentinel (no CSS rule consumes `var(--offset)` today).

**Status (revision 2, 2026-05-07):** Mockup revision 2 complete per `MOCKUP-REVISION-2-HANDOFF.md`. 15 concept PNGs + 2 audit composites re-rendered. All six handoff issues addressed:

1. **Issue 1 — Broad raised matrix.** Most interactables now lift in raised mode (primary/secondary/ghost buttons, selected & unselected tabs, panels, dialogs, list cards, brand mark, chips, selected list rows, toggle thumb, checkbox, progress fill). Explicit do-not-raise list (text inputs, passive labels, kickers, h2 headers, scrollbar, separators, unselected list rows, focus ring, state-strip demo swatches) stays flat.
2. **Issue 2 — Per-color offset tokens.** New `darken(hex, pct)` HSL helper drives `--accent-offset`, `--surface-high-offset`, `--surface-panel-offset`, `--surface-overlay-offset`, `--surface-low-offset`. Each raised element consumes the offset matching its own bg color. Optional 1px lighter top rim (`--accent-rim`) on raised primary buttons mimics the user's PLAY-button reference.
3. **Issue 3 — Wider radius spread.** 0/8/14/18/26 (Pulse 0 / Daybreak 8 / Slate 14 / Burst 18 / Bubble 26). Categorical shape-axis updates: Bubble brand mark = true circle (999px), Burst primary = oversized 28px, Pulse all = 0px sharp.
4. **Issue 4 — Slideshow.** Top-of-page A/B comparison view in `concept-gallery.html` with `transition: none` and ←/→ keyboard cycle. All 5 PNGs preloaded on first paint; tab buttons under the image for direct selection.
5. **Issue 5 — Mood differentiation.** Each direction reads as a meaningfully different vibe per its inspirational compass point (cabinet control panel / premium tool app / cozy mobile game / community lobby / achievement screen). Validated by D-30 greyscale composite.
6. **Issue 6 — Platform sizing.** `PLATFORM_TOKENS` overhauled: desktop matches Steam/Battle.net/Epic conventions (36 standard / 44 primary / 14 body / 36 row); mobile matches Material 3 component specs (48 dp tap floor / 56 dp emphasis primary / 56 dp text field / 56 dp list row / 16 sp body / 32 sp Headline Large) with `densityScale: 1.5` for the +50% inter-control gap rule. `.nc-artboard.mobile` no longer downward-overrides sizes — the same base CSS rule produces visibly different output on each platform via the new sizing variables. Mobile artboard physical height bumped from 932 → 1500 px so the M3-floored control inventory fits in one image (a phone IRL would scroll; the mockup shows the full mobile content for direction comparison).

**Awaiting:** finalist-selection user gate (Plan 02 Task 4). Stop point per handoff.

## Foundation Checks

| Check | Status | Notes |
|---|---|---|
| Pulse direction present | PASS | `data/directions.json` + JS direction object encode shape_language. |
| Slate direction present | PASS | `data/directions.json` + JS direction object encode shape_language. |
| Bubble direction present | PASS | `data/directions.json` + JS direction object encode shape_language. |
| Daybreak direction present | PASS | `data/directions.json` + JS direction object encode shape_language. |
| Burst direction present | PASS | `data/directions.json` + JS direction object encode shape_language. |
| Per-direction shape-language tokens encoded | PASS | All 10 axes per direction; `shape_language` block in `directions.json`, mirrored in `NEOCADE_DIRECTIONS[*].shape` in JS for file:// runtime. Revision-2 radius spread (0/8/14/18/26) committed. |
| Artboard CSS does NOT hard-code shape tokens | PASS | `.nc-artboard` reads `var(--radius-base)`, `var(--button-pad-h)`, etc.; no `--radius: 12px` literal anywhere on the artboard or board path. |
| Artboard CSS does NOT hard-code platform sizes | PASS | `.nc-art-button` reads `var(--button-min)`; `.nc-art-input` reads `var(--input-min)`; `.nc-art-list-row` reads `var(--row-min)`; etc. `.nc-artboard.mobile` only overrides physical width/height, not control sizes. |
| Per-color offset tokens emitted | PASS | `deriveSurfaceRamp()` emits `accent_offset`, `surface_high_offset`, `surface_panel_offset`, `surface_overlay_offset`, `surface_low_offset` via `tintTowardBase(hex, base, 0.40)` (rev-3 — replaces rev-2's `darken()` which clamped to near-black on already-dark surfaces). Each offset is `mix(element_color, page_base, 40%)`, preserving hue at every brightness. |
| Slideshow component bound | PASS | `concept-gallery.html` includes `<section class="nc-slideshow">`; `bindSlideshow()` wires arrows + keyboard + tabs; image transition is `none !important`. |
| Flat concept output path | PASS | `concept-image.html?raised=false` renders the flat artboard. |
| Raised concept output path | PASS | `concept-image.html?raised=true` renders the raised artboard with broad raise matrix and per-color offsets. |
| Generated mockup image paths | PASS | 15 `concepts/{pulse,slate,bubble,daybreak,burst}-{desktop-flat,mobile-flat,mobile-raised}.png`. Desktop = 2560×1440 px; mobile = 860×3000 px (430×1500 logical at 2× device pixels). |
| Audit composites rendered | PASS | `screenshots/color-overview.png` + `screenshots/greyscale-sufficiency-test.png` re-rendered via `node render.js color-overview` and `node render.js greyscale` (new render.js modes for revision 2). |
| Fixed control inventory + order | PASS | Every artboard renders, in order: brand mark + nav tabs (top), action panel (header → primary/secondary/ghost row → input → toggle row), dialog stack (header → segmented → popup → progress → action row), list/tree (header → selected row → 2 normal rows → scrollbar), state strip (normal/hover/focus/pressed/disabled), palette swatches (low/panel/high/accent). |
| Dark accessible palettes | PASS | `wcag-palette-audit.md` records all 5 base/accent pairs at 10.74:1 or higher. Unchanged by revision 2 (no palette changes). |
| Finalist 4-grid readiness | PASS | `finalist-gallery.html` placeholder + renderer support intact. |
| No production addon/theme files changed | PASS | git status: only `.planning/mockups/3.4/**` modified; no `addons/**`, `main.tscn`, `project.godot`, `*.tres`, `*.gd` touched. |
| Historical v0 artifacts untouched | PASS | `.planning/mockups/concepts/`, `.planning/mockups/03-direction-boards.*`, `.planning/research/mood-board/` not edited. |

## Stage 1 Concept Matrix — per-direction audit (revision 2)

### Pulse — "vibrant arcade hall by day, cabinet control panel"

| Axis | Committed | Visible in renders |
|---|---|---|
| 1 corner radius | base 0 / chip 0 (was 5/4 in rev 1) | sharpest possible — cabinet hardware square edges |
| 2 button anatomy | 0px radius, 14×10 padding, bold-accent-fill-dark-text uppercase primary | "START" reads as lit cabinet button |
| 3 chip / tab | rectangular-strip, 0px, accent fill + 2px bottom rule + uppercase tracked tab labels | flush cabinet selector strip |
| 4 brand mark | square-cabinet-bezel, 0px radius, accent fill + thick ink border + inset bezel | mechanical / panel-like |
| 5 density | 18px padding, 10px gap | arcade-dense, packed |
| 6 focus ring | 2px solid, 0px offset | tight cabinet ring |
| 7 type | H1 800 / H2 740 / uppercase tracked accent kicker | bold control-panel headlines |
| 8 surface ramp | 4 stops, wide spread | strong tonal hierarchy visible |
| 9 state behavior | hover +6%, pressed -10%, disabled 0.42 | tactile, mechanical |
| 10 raised offset | primary 3 / tab 2 / row 0 / secondary 1; broad matrix lifts buttons + panels + dialogs + brand mark + tabs + chips + thumb + check + progress | flat-3D depth on every interactable; passive elements stay flat |

| Audit row | Result | Note |
|---|---|---|
| anti-cyberpunk | PASS | No glow, no neon outlines, no synthwave tropes; bright green is daylight cabinet, not nightclub. |
| anti-texture | PASS | Solid fills only; no patterns, gradients, embossing, or painterly chrome. |
| anti-painterly-chrome / anti-embossing | PASS | All depth via hard offset, never via gradient or inner-shadow embossing. |
| raised-mode feel | appropriate | 3px primary / 2px tab offsets read tactile without becoming toy-like; broad matrix lifts the interactable surfaces but inputs / scrollbars / unselected rows / passive labels stay flat. All raised elements use color-tinted offsets in their own hue family — no near-black bottom edges anywhere (rev-3 fix landed for non-accent surfaces specifically). |
| per-color offset (Issue 2 + rev-3) | PASS | START button bottom edge ≈ `#5CA352` (`mix(#8BFF6A, #151A2E, 40%)` — green family, not near-black). Cabinet-bezel brand mark, selected Lobby tab (offset stacks under the inset bottom-rule), Confirm primary in dialog all lift on green-tinted edges. Action-panel + dialog-stack + list-tree containers use `--surface-panel-offset` = `mix(surface_panel, base, 40%)`; popup overlay uses `--surface-overlay-offset` = `mix(surface_overlay, base, 40%)`; state-strip cells use `--surface-high-offset`. None near-black. |
| dark-only compliance (D-28) | PASS | base `#151A2E`. |
| shape-language differentiation (D-29) | 10/10 axes | Distinct on every axis from at least 3 of 4 siblings. 0px corners are categorically unique. |
| greyscale sufficiency (D-30) | PASS | Reads as CABINET CONTROL PANEL. Sharp 0px corners + flush rectangular tab strip + square cabinet-bezel mark + uppercase-tracked kickers are unmistakable in greyscale. |
| platform-sizing audit (Issue 6) | PASS | Mobile START primary visibly larger (~56 px M3 FAB) than desktop (~44 px); mobile body text 16 px vs desktop 14 px; mobile list rows 56 px vs desktop 36 px; mobile toggle thumb 32 px vs desktop 22 px; mobile checkbox 20 px vs desktop 18 px; mobile inter-control gaps +50% via `densityScale: 1.5`. |

### Slate — "premium dark default, premium tool app"

| Axis | Committed | Visible in renders |
|---|---|---|
| 1 corner radius | base 14 / chip 999 (was 11/999 in rev 1) | iOS-app pill polish, slightly larger to lean further into premium-Settings vibe |
| 2 button anatomy | 14px radius, 16×11 padding, quiet-pill primary, thin-accent-outline ghost | restrained primary |
| 3 chip / tab | rounded-pill 999px, accent-fill subdued | sophisticated tab pills |
| 4 brand mark | rounded-square, 14px radius, no border | calm symbol |
| 5 density | 22px padding, 14px gap | spacious-premium-quiet |
| 6 focus ring | 2px solid, 2px offset | iOS-style offset |
| 7 type | H1 720 / H2 640 / small-caps subtle kicker | restrained type voice |
| 8 surface ramp | 3 stops, narrow spread | calm continuous tonal feel |
| 9 state behavior | hover +4%, pressed -6%, disabled 0.50 | quiet, not aggressive |
| 10 raised offset | primary 2 / tab 1 / row 1 / secondary 1; restrained but broad matrix | tool-friendly subtle depth on every interactable |

| Audit row | Result | Note |
|---|---|---|
| anti-cyberpunk | PASS | Restraint is the personality; cool sky-blue is professional, not neon. |
| anti-texture | PASS | Solid fills, no decorative chrome. |
| anti-painterly-chrome / anti-embossing | PASS | No gradients on chrome surfaces. |
| raised-mode feel | appropriate | 2px primary, 1px tab/row/secondary — quiet broad matrix matches premium-tool restraint. All raised elements use color-tinted offsets in their own hue family — no near-black bottom edges anywhere (rev-3 fix landed for non-accent surfaces specifically). |
| per-color offset (Issue 2 + rev-3) | PASS | Start primary bottom edge ≈ `#5A88A6` (`mix(#8BD3FF, #111820, 40%)` — sky-blue family, not near-black). Selected pill tab, rounded-square brand mark, Confirm primary all lift on subtle blue-tinted edges. Action panel + dialog stack + list/tree containers lift on `mix(surface_panel, base, 40%)` (cool slate-tinted, not black). Popup overlay lifts on `mix(surface_overlay, base, 40%)`. Selected list row uses `--surface-high-offset`. Inputs stay flat. Quiet 1-2px depths preserve premium-tool restraint while fixing the rev-2 black-edge issue. |
| dark-only compliance (D-28) | PASS | base `#111820`. |
| shape-language differentiation (D-29) | 10/10 axes | Pill chips + small-caps "01 action panel" kickers + narrow-spread surface ramp uniquely identify Slate. |
| greyscale sufficiency (D-30) | PASS | Reads as PREMIUM TOOL APP. Pill chips + small-caps subtle kickers + smallest button surface deltas + narrowest surface ramp set it apart even without color. |
| platform-sizing audit (Issue 6) | PASS | Mobile primary ~56 px vs desktop ~44 px; mobile body 16 px vs desktop 14 px; mobile list rows 56 px vs desktop 36 px; mobile toggles + checkboxes chunkier. |

### Bubble — "playful candy-counter at night, cozy mobile game"

| Axis | Committed | Visible in renders |
|---|---|---|
| 1 corner radius | base 26 / chip 999 (was 18/999 in rev 1) | genuinely bubbly — biggest base radius in the set |
| 2 button anatomy | 26px radius, 20×14 padding, primary fully-rounded 999px, pillowy primary, rounded ghost with thicker outline | invites pressing |
| 3 chip / tab | fully-rounded pill large 999px + 22px h padding, accent fill + raised-offset on selected | cheerful, not businesslike |
| 4 brand mark | circle-or-squircle, 999px radius (true circle, was 22px in rev 1), accent fill + soft halo | friendly, organic |
| 5 density | 22px padding, 14px gap | friendly-airy |
| 6 focus ring | 3px solid, 2px offset | cheerful chunky ring |
| 7 type | H1 800 / H2 760 / uppercase tracked accent kicker | bright punchy headlines |
| 8 surface ramp | 3 stops, medium spread | playful soft layers |
| 9 state behavior | hover +8% (bouncy), pressed -10%, disabled 0.45 | feels alive |
| 10 raised offset | primary 6 / tab 4 / row 3 / secondary 3 (was 5/3/2/2 in rev 1); broad matrix | "poked-out" tactile depth on every interactive element — the user's PLAY-button reference vibe |

| Audit row | Result | Note |
|---|---|---|
| anti-cyberpunk | PASS | Friendly mobile-game brightness on dark berry, not nightclub. |
| anti-texture | PASS | Solid berry surfaces, no patterns or stickers. |
| anti-painterly-chrome / anti-embossing | PASS | Box-shadow hard offset only — no soft inner shadow / no fake bevels. The 1px accent-rim inner highlight on primary mimics the PLAY-button reference but stays in the flat-3D pattern. |
| raised-mode feel | appropriate | 6px primary is the bubbliest in the set; broad matrix lifts buttons + panels + dialog + tabs + brand mark + thumb + check + progress; inputs / scrollbars / unselected rows / passive labels stay flat. All raised elements use color-tinted offsets in their own hue family — no near-black bottom edges anywhere (rev-3 fix landed for non-accent surfaces specifically). |
| per-color offset (Issue 2 + rev-3) | PASS — fidelity check passed | Start primary bottom edge ≈ `#A77399` (`mix(#FFB3E6, #241326, 40%)` — darker berry-pink, pink family). Action-panel container, popup-surface dialog, brand-mark true-circle, state-strip cells, selected Cabinet A row, fully-rounded pill tabs, Confirm primary all lift on darker-berry tinted edges in the same hue family. Side-by-side compare against v0 `prize-pop-plaza-concept.png`: the candy-counter mood is recovered — every offset reads as a darker berry, never as a black slab. The rev-2 black-edge bug on dark-surface elements (panels, dialog, brand, state-strip) is gone. |
| dark-only compliance (D-28) | PASS | base `#241326` (dark berry). |
| shape-language differentiation (D-29) | 10/10 axes | Largest base radii (26px), true-circle brand mark (999px), fully-rounded pill chips, biggest raised offsets, fully-rounded primary — uniquely Bubble. |
| greyscale sufficiency (D-30) | PASS | Reads as COZY MOBILE GAME. Circle brand mark + fully-rounded pill chips + biggest raised offsets are unmistakable in greyscale. |
| platform-sizing audit (Issue 6) | PASS | Mobile primary ~56 px (full pill) vs desktop ~44 px; mobile body 16 px vs desktop 14 px; mobile list rows 56 px vs desktop 36 px; mobile toggle thumb 32 px vs desktop 22 px; mobile body content fills the 1500-px tall artboard with all 3 cards visible. |

### Daybreak — "fresh evening lobby, community lobby"

| Axis | Committed | Visible in renders |
|---|---|---|
| 1 corner radius | base 8 / chip 8 (was 13/12 in rev 1) | subtle softness — daylight mood carried by halo decorations + airy density + bright mint, not radius |
| 2 button anatomy | 8px radius, 18×12 padding, friendly primary + soft-outline ghost | breathing, not loud |
| 3 chip / tab | rounded-rect 8px, accent fill + mint halo behind selected | daylight signal |
| 4 brand mark | rounded-square 8px with accent halo aura | welcoming, lit-from-behind |
| 5 density | 24px padding, 16px gap | airiest in the set |
| 6 focus ring | 2px solid, 2px offset, mint glow halo | airy fresh ring |
| 7 type | H1 720 / H2 660 / sentence-case-accent kicker ("01 Action panel" — Title Case) | calm, welcoming voice |
| 8 surface ramp | 4 stops, medium spread | airy fresh layers |
| 9 state behavior | hover +6%, pressed -6%, disabled 0.50 | soft, friendly response |
| 10 raised offset | primary 3 / tab 2 / row 1 / secondary 1 (was 3/2/0/0 in rev 1); broad matrix | tactile but spare; broader than rev 1 |

| Audit row | Result | Note |
|---|---|---|
| anti-cyberpunk | PASS | Mint accent is daylight, not neon; halo decorations are soft auras, not glow rims. |
| anti-texture | PASS | Solid teal surfaces, no patterns. |
| anti-painterly-chrome / anti-embossing | PASS | Halos are CSS color-mix box-shadow, not painted gradient surfaces. |
| raised-mode feel | appropriate | 3px primary, 2px tab — tactile without floating shells; sentence-case kickers reinforce calm tone. All raised elements use color-tinted offsets in their own hue family — no near-black bottom edges anywhere (rev-3 fix landed for non-accent surfaces specifically). |
| per-color offset (Issue 2 + rev-3) | PASS | Start primary bottom edge ≈ `#4BA08A` (`mix(#76F2D1, #0B2420, 40%)` — mint/teal family). Brand mark with halo, selected halo-tab, Confirm primary all lift on mint-tinted edges. Action panel + dialog stack + list/tree containers lift on `mix(surface_panel, base, 40%)` (deep teal-tinted, not black). Popup overlay lifts on `mix(surface_overlay, base, 40%)`. State-strip cells lift on `--surface-high-offset` in the teal family. The airy-lobby mood is preserved. |
| dark-only compliance (D-28) | PASS | base `#0B2420`. |
| shape-language differentiation (D-29) | 10/10 axes | Sentence-case kickers + brand-mark halo aura + mint-glow focus ring + 8px subtle rounding + airiest density distinguish Daybreak. |
| greyscale sufficiency (D-30) | PASS | Reads as COMMUNITY LOBBY. Halos behind selected tab and brand mark are visible in greyscale; sentence-case kickers contrast Pulse / Bubble / Burst's uppercase. |
| platform-sizing audit (Issue 6) | PASS | Mobile primary ~56 px vs desktop ~44 px; mobile body 16 px vs desktop 14 px; mobile list rows 56 px vs desktop 36 px; mobile toggle/check chunkier; airy density carries +50% inter-control gap rule. |

### Burst — "celebratory MD3 Expressive max, achievement screen"

| Axis | Committed | Visible in renders |
|---|---|---|
| 1 corner radius | base 18 / chip 16 / primary 28 (was 16/14/22 in rev 1) | bold but not extreme; drama from oversized primary radius (28), asymmetric tab, chunky brand mark — not from base scalar |
| 2 button anatomy | 18px radius (primary 28px, 26×18 padding), oversized statement primary | event-grade primary |
| 3 chip / tab | rounded-rect 16px, asymmetric on selected (selected tab is bigger) | hierarchy-amplified |
| 4 brand mark | chunky asymmetric badge, asymmetric border weights, slight rotation | eye-catching, not symmetric-corporate |
| 5 density | 22px padding, 14px gap | event-spread |
| 6 focus ring | 3px solid, 1px offset | dramatic event ring |
| 7 type | H1 820 / H2 780 / uppercase bold larger-scale kicker | biggest headlines in the set |
| 8 surface ramp | 4 stops, wide spread | dramatic layered emphasis |
| 9 state behavior | hover +8%, pressed -12% (bold), disabled 0.45 | strong press feedback |
| 10 raised offset | primary 5 / tab 3 / row 2 / secondary 2; broad matrix | clear depth hierarchy |

| Audit row | Result | Note |
|---|---|---|
| anti-cyberpunk | PASS | Celebratory bold gold reads achievement screen, not casino glow; no painted shine. |
| anti-texture | PASS | Solid surfaces, no patterns. |
| anti-painterly-chrome / anti-embossing | PASS | All emphasis via radius / size / weight / hard offset — never via faux 3D bevels. |
| raised-mode feel | appropriate | 5px primary + 2px secondary creates clear depth hierarchy without becoming gimmicky; oversized 28px primary radius keeps the "event launcher" feel. All raised elements use color-tinted offsets in their own hue family — no near-black bottom edges anywhere (rev-3 fix landed for non-accent surfaces specifically). |
| per-color offset (Issue 2 + rev-3) | PASS | Start primary bottom edge ≈ `#A68450` (`mix(#FFD166, #20112E, 40%)` — gold family). Asymmetric brand mark, oversized Confirm primary, asymmetric selected tab all lift on gold-tinted edges. Action panel + dialog stack + list/tree containers lift on `mix(surface_panel, base, 40%)` (dark plum-tinted, not black). Popup overlay lifts on `mix(surface_overlay, base, 40%)`. State-strip cells lift on `--surface-high-offset` in the plum family. Achievement-screen drama is preserved. |
| dark-only compliance (D-28) | PASS | base `#20112E` (dark plum). |
| shape-language differentiation (D-29) | 10/10 axes | Asymmetric brand mark + asymmetric selected tab + oversized 28px primary radius + biggest type weights uniquely identify Burst. |
| greyscale sufficiency (D-30) | PASS | Reads as ACHIEVEMENT SCREEN. Asymmetric (visibly wider) selected Lobby tab + chunky asymmetric/tilted brand mark + biggest H1 + oversized primary radius. |
| platform-sizing audit (Issue 6) | PASS | Mobile primary ~56 px (28px-radius super-rounded) vs desktop ~44 px; mobile body 16 px vs desktop 14 px; mobile list rows 56 px vs desktop 36 px. |

## D-30 Greyscale Sufficiency Test — composite (revision 2)

Composite at `screenshots/greyscale-sufficiency-test.png` shows all 5 desktop-flat artboards rendered with `filter: grayscale(1) contrast(1.05)` side by side. Source page: `src/greyscale-check.html`.

Reviewer test: hide direction labels, identify each direction by shape alone.

| Direction | Identifiable in greyscale? | Strongest shape-only differentiator (revision 2) |
|---|---|---|
| Pulse | YES | 0px corners EVERYWHERE + flush rectangular tab strip + square cabinet-bezel brand mark + uppercase-tracked kickers |
| Slate | YES | Pill chips + small-caps "01 action panel" kickers (lowercase look) + narrow surface tonal range + 14px iOS rounding |
| Bubble | YES | True circle brand mark (999px) + fully-rounded pill chips + 26px biggest base radius + biggest hard-offset raised buttons |
| Daybreak | YES | Halo aura around brand mark + halo behind selected tab + sentence-case "01 Action panel" + airiest spacing + 8px softest base |
| Burst | YES | Asymmetric (visibly wider) selected Lobby tab + chunky asymmetric/tilted brand mark + biggest H1 + oversized 28px primary radius |

D-30 PASSES on all five (revision 2 confirms — wider radius spread makes shape-only differentiation more decisive than rev 1).

Mood-target check (per `MOCKUP-REVISION-2-HANDOFF.md` Issue 5):

- Pulse → CABINET CONTROL PANEL — PASS
- Slate → PREMIUM TOOL APP — PASS
- Bubble → COZY MOBILE GAME — PASS
- Daybreak → COMMUNITY LOBBY — PASS
- Burst → ACHIEVEMENT SCREEN — PASS

## Platform-Sizing Audit — composite check

Each direction now visibly differentiates desktop and mobile, per Issue 6. The change-table below summarizes the floors (driven by `PLATFORM_TOKENS` in `src/neocade-mockups.js`):

| Token | Desktop (game-UI density) | Mobile (Material 3 floors) | Visible delta in renders |
|---|---|---|---|
| `--button-min` | 36 px | 48 px | +33% mobile bump on standard buttons (Options, Cancel) |
| `--button-min-primary` | 44 px | 56 px | +27% mobile bump on hero button (Start, Confirm) — most-visible delta |
| `--input-min` | 34 px | 56 px | +65% mobile bump on text fields — clearly chunkier on mobile |
| `--toggle-min` | 22 px | 32 px | +45% mobile bump; track and thumb noticeably thicker |
| `--checkbox-size` | 18 px | 20 px | +11% mobile bump on visible box; tap target via `--tap-padding` |
| `--body-size` | 14 px | 16 px | +14% mobile bump on body text — readable across the artboard |
| `--label-size` | 12 px | 14 px | +17% mobile bump on labels and kickers |
| `--row-min` | 36 px | 56 px | +56% mobile bump on list rows — most-visible delta after primary buttons |
| `--tab-min` | 32 px | 48 px | +50% mobile bump on tabs and segments |
| `--density-scale` | 1.0 | 1.5 | +50% inter-control gap on button rows, segments, list rows, tabs (per architecture revision 2026-05-04) |

| Direction | Desktop vs mobile audit | Result |
|---|---|---|
| Pulse | Desktop: 36px sharp 0-corner buttons in dense 3-column grid, 14px body. Mobile: 48-56px sharp 0-corner buttons in single column, 16px body, 56px list rows. Both 100% identifiable as "Pulse" via 0px corners + uppercase tracked kickers + cabinet-bezel mark, but the size delta between platforms is unmistakable. | PASS |
| Slate | Desktop: 36-44px subtle 14px-rounded buttons, narrow surface ramp barely registers in greyscale. Mobile: 48-56px buttons, taller list rows, body text bumps to 16px. Slate's "premium tool app" feel translates intact across platforms — quiet on both, just at different size floors. | PASS |
| Bubble | Desktop: 36-44px 26px-rounded chrome with 999px primary pill. Mobile: 48-56px chrome with bigger pill primary at 56px (M3 Extended FAB), chunkier toggles, generous spacing. Mobile-raised primary button pink with darker-pink offset reads decisively as "candy machine" not "Neobrutalism". | PASS |
| Daybreak | Desktop: 36-44px 8px-rounded chrome with sentence-case kickers. Mobile: 48-56px chrome, brighter mint halos preserved, 56px list rows. Airy density rule (+50% gap) most visible here because of the already-airy base spacing. | PASS |
| Burst | Desktop: 36-44px chrome with oversized 28px primary radius. Mobile: 48-56px chrome, asymmetric selected tab visibly bigger on mobile due to the size scaling, chunky tilted brand mark unchanged across platforms. Most expressive shape language stays expressive at both sizes. | PASS |

## Concept Render Evidence

- Render command: `node .planning/mockups/3.4/render.js concept-images` (15 PNGs); `node render.js color-overview`; `node render.js greyscale` (audit composites)
- Runtime: `playwright-core` (locally installed in `.planning/mockups/3.4/node_modules/`, no committed dependency) driving system Microsoft Edge at `C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe` via `executablePath`. No browser download required.
- Desktop image dimensions: 1280×720 logical pixels at deviceScaleFactor=2 → 2560×1440 PNG.
- Mobile image dimensions: 430×1500 logical pixels at deviceScaleFactor=2 → 860×3000 PNG (revision 2 bump from 932 → 1500 logical to fit M3-floored control inventory).
- Desktop file-size sanity: every desktop PNG between ~140KB and ~250KB.
- Mobile file-size sanity: every mobile PNG between ~200KB and ~400KB (taller than rev 1).
- Anti-aliasing: text rendered via Inter system fallback. Shape-language differentiation does not depend on the specific font; type WEIGHT and KICKER STYLE are the differentiators, both of which render correctly.
- Per-direction shape-language source-of-truth lives in `data/directions.json` `shape_language` blocks AND in JS `NEOCADE_DIRECTIONS[*].shape` (mirrored intentionally for file:// runtime). Revision-2 corner_radius and raised matrix changes committed in both.
- Artboard CSS variable injection: every `.nc-artboard` element receives an inline `style="--radius-base: <r>px; --accent: <hex>; --button-min: <p>px; --accent-offset: <tinted-hex>; ..."` declaration set by `deriveTokens(direction, platform, raised)` in `src/neocade-mockups.js`. Revision-2 added per-color offset tokens + platform sizing variables; revision-3 reformulated the offsets via `tintTowardBase()` (mix-toward-base 40%) so already-dark surfaces no longer floor at near-black.

## Forbidden-Surface Audit

Allowed in Phase 3.4:
- `.planning/mockups/3.4/**/*.html`
- `.planning/mockups/3.4/**/*.css`
- `.planning/mockups/3.4/**/*.js`
- `.planning/mockups/3.4/**/*.json`
- `.planning/mockups/3.4/**/*.md`
- `.planning/mockups/3.4/concepts/**/*.png`
- `.planning/mockups/3.4/screenshots/**/*.png`

Forbidden before Phase 4 — verified untouched in revision 2:
- `addons/neocade_theme/**`
- `main.tscn`
- `project.godot`
- production `.tres` (no .tres files modified)
- production `.gd` (no .gd files modified)
- fonts / icons subfolders
- historical v0 mockup artifacts: `.planning/mockups/concepts/`, `.planning/mockups/03-direction-boards.*`, `.planning/research/mood-board/`

Local-only artifacts (gitignored, do not commit):
- `.planning/mockups/3.4/node_modules/` — playwright-core install for render.js. NOT committed.
- `.planning/mockups/3.4/package.json` + `package-lock.json` — created by `npm init -y` for the render dep.

## Finalist Readiness

- Concept boards: all 15 PNGs present and pass D-28 / D-29 / D-30 / per-color-offset / platform-sizing audits.
- Audit composites: 2 PNGs in `screenshots/` re-rendered.
- Awaiting user gate: `.planning/mockups/3.4/finalist-selection.md` will be written by Plan 02 Task 4 once user picks 1-3 finalists.
- Plan 03 (finalist 4-grid) does NOT start until that file exists.
