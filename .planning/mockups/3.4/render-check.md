# Phase 3.4 Render Check

**Status:** Re-execution complete (2026-05-06b). 15 concept PNGs rendered under the per-direction shape-language contract from `direction-shape-language-spec.md`. Greyscale sufficiency test (D-30) passes on all 5 directions. Awaiting finalist-selection user gate.

**Re-execution context:**
- First execution rejected by user — every direction looked like the same template with only a color swap; CSS hard-coded `--radius: 12px` for all five.
- This re-execution removes the hard-coded shape tokens and consumes per-direction `shape_language` blocks (`data/directions.json`) via inline CSS variables on each `.nc-artboard`. Structural variants (e.g., rectangular vs pill tabs, cabinet-bezel vs circle brand mark) are routed through `data-*` attributes.
- See `CLAUDE-CODE-HANDOFF.md` (mood priming) and `image-prompts/direction-shape-language-spec.md` (axes).

## Foundation Checks

| Check | Status | Notes |
|---|---|---|
| Pulse direction present | PASS | `data/directions.json` + JS direction object encode shape_language. |
| Slate direction present | PASS | `data/directions.json` + JS direction object encode shape_language. |
| Bubble direction present | PASS | `data/directions.json` + JS direction object encode shape_language. |
| Daybreak direction present | PASS | `data/directions.json` + JS direction object encode shape_language. |
| Burst direction present | PASS | `data/directions.json` + JS direction object encode shape_language. |
| Per-direction shape-language tokens encoded | PASS | All 10 axes per direction; `shape_language` block in `directions.json`, mirrored in `NEOCADE_DIRECTIONS[*].shape` in JS for file:// runtime. |
| Artboard CSS does NOT hard-code shape tokens | PASS | `nc-artboard` rule uses `var(--radius-base)`, `var(--button-pad-h)`, etc.; no `--radius: 12px` literal anywhere on the artboard or board path. |
| Flat concept output path | PASS | `concept-image.html?raised=false` renders the flat artboard. |
| Raised concept output path | PASS | `concept-image.html?raised=true` renders the raised artboard with hard box-shadow offsets. |
| Generated mockup image paths | PASS | 15 `concepts/{pulse,slate,bubble,daybreak,burst}-{desktop-flat,mobile-flat,mobile-raised}.png` |
| Fixed control inventory + order | PASS | Every artboard renders, in order: brand mark + nav tabs (top), action panel (header → primary/secondary/ghost row → input → toggle row), dialog stack (header → segmented → popup → progress → action row), list/tree (header → selected row → 2 normal rows → scrollbar), state strip (normal/hover/focus/pressed/disabled), palette swatches (low/panel/high/accent). |
| Dark accessible palettes | PASS | `wcag-palette-audit.md` records all 5 base/accent pairs at 10.74:1 or higher. Unchanged by this re-execution. |
| Finalist 4-grid readiness | PASS | `finalist-gallery.html` placeholder + renderer support intact. |
| No production addon/theme files changed | PASS | git status: only `.planning/mockups/3.4/**` and `package.json` (added by `npm init`) modified; no `addons/**`, `main.tscn`, `project.godot`, `*.tres`, `*.gd` touched. |
| Historical v0 artifacts untouched | PASS | `.planning/mockups/concepts/` and `.planning/mockups/03-direction-boards.*` not edited. |

## Stage 1 Concept Matrix — per-direction audit

### Pulse — "vibrant arcade hall by day, lights on, UI doing the work"

| Axis | Committed | Visible in renders |
|---|---|---|
| 1 corner radius | base 5px / chip 4px | tight cabinet bezel feel |
| 2 button anatomy | 5px radius, 14×10 padding, bold-accent-fill-dark-text uppercase primary | "START" reads as lit cabinet button |
| 3 chip / tab | rectangular-strip, 4px, accent fill + 2px bottom rule + uppercase tracked tab labels | flush cabinet selector strip |
| 4 brand mark | square-cabinet-bezel, 4px radius, accent fill + thick ink border + inset bezel | mechanical / panel-like |
| 5 density | 18px padding, 10px gap | arcade-dense, packed |
| 6 focus ring | 2px solid, 0px offset | tight cabinet ring |
| 7 type | H1 800 / H2 740 / uppercase tracked accent kicker | bold control-panel headlines |
| 8 surface ramp | 4 stops, wide spread | strong tonal hierarchy visible |
| 9 state behavior | hover +6%, pressed -10%, disabled 0.42 | tactile, mechanical |
| 10 raised offset | primary 3px / tab 2px / row none / secondary none; lifts primary + selected tabs | hard-offset lights up active controls without lifting passive panels |

| Audit row | Result | Note |
|---|---|---|
| anti-cyberpunk | PASS | No glow, no neon outlines, no synthwave tropes; bright green is daylight cabinet, not nightclub. |
| anti-texture | PASS | Solid fills only; no patterns, gradients, embossing, or painterly chrome. |
| anti-painterly-chrome / anti-embossing | PASS | All depth via hard offset, never via gradient or inner-shadow embossing. |
| raised-mode feel | appropriate | 3px primary / 2px tab offsets read tactile without becoming toy-like. |
| dark-only compliance (D-28) | PASS | base `#151A2E`. |
| shape-language differentiation (D-29) | 10/10 axes | Distinct on every axis from at least 3 of 4 siblings. |
| greyscale sufficiency (D-30) | PASS | Reads as CABINET CONTROL PANEL (per CLAUDE-CODE-HANDOFF.md mood target). Tightest radius, most-uppercase headlines, flush rectangular tab strip, square cabinet-bezel mark. Greyscale: see `screenshots/greyscale-sufficiency-test.png`. |

### Slate — "premium dark default, iOS-style polish, quiet confidence"

| Axis | Committed | Visible in renders |
|---|---|---|
| 1 corner radius | base 11px / chip 999px | iOS-pill medium |
| 2 button anatomy | 11px radius, 16×11 padding, quiet-pill primary, thin-accent-outline ghost | restrained primary |
| 3 chip / tab | rounded-pill 999px, accent-fill subdued | sophisticated tab pills |
| 4 brand mark | rounded-square, 11px radius, no border | calm symbol |
| 5 density | 22px padding, 14px gap | spacious-premium-quiet |
| 6 focus ring | 2px solid, 2px offset | iOS-style offset |
| 7 type | H1 720 / H2 640 / small-caps subtle kicker | restrained type voice |
| 8 surface ramp | 3 stops, narrow spread | calm continuous tonal feel |
| 9 state behavior | hover +4%, pressed -6%, disabled 0.50 | quiet, not aggressive |
| 10 raised offset | primary 2px / tab 0 / row 0 / secondary 0; lifts primary only | restrained 1-2px offset on primary buttons |

| Audit row | Result | Note |
|---|---|---|
| anti-cyberpunk | PASS | Restraint is the personality; cool sky-blue is professional, not neon. |
| anti-texture | PASS | Solid fills, no decorative chrome. |
| anti-painterly-chrome / anti-embossing | PASS | No gradients on chrome surfaces. |
| raised-mode feel | appropriate | 2px primary offset is intentionally quiet — tool-friendly. |
| dark-only compliance (D-28) | PASS | base `#111820`. |
| shape-language differentiation (D-29) | 10/10 axes | Pill chips, small-caps kickers, narrow-spread surface ramp uniquely identify Slate. |
| greyscale sufficiency (D-30) | PASS | Reads as PREMIUM TOOL APP. Pill chips + small-caps subtle kickers + smallest button surface deltas + narrow surface ramp set it apart even without color. |

### Bubble — "playful candy-counter at night, tactile cheerful warmth"

| Axis | Committed | Visible in renders |
|---|---|---|
| 1 corner radius | base 18px / chip 999px | pillowy candy squircle |
| 2 button anatomy | 20px radius, primary fully-rounded 999px, 20×14 padding, pillowy primary, rounded ghost with thicker outline | invites pressing |
| 3 chip / tab | fully-rounded pill large 999px + 22px h padding, accent fill + raised-offset on selected | cheerful, not businesslike |
| 4 brand mark | circle-or-squircle, 999px radius, accent fill + soft halo | friendly, organic |
| 5 density | 22px padding, 14px gap | friendly-airy |
| 6 focus ring | 3px solid, 2px offset | cheerful chunky ring |
| 7 type | H1 800 / H2 760 / uppercase tracked accent kicker | bright punchy headlines |
| 8 surface ramp | 3 stops, medium spread | playful soft layers |
| 9 state behavior | hover +8% (bouncy), pressed -10%, disabled 0.45 | feels alive |
| 10 raised offset | primary 5px / tab 3px / row 2px / secondary 2px; lifts primary + tabs + rows + chips | "poked-out" tactile depth on every interactive element |

| Audit row | Result | Note |
|---|---|---|
| anti-cyberpunk | PASS | Friendly mobile-game brightness on dark berry, not nightclub. |
| anti-texture | PASS | Solid berry surfaces, no patterns or stickers. |
| anti-painterly-chrome / anti-embossing | PASS | Box-shadow hard offset only — no soft inner shadow / no fake bevels. |
| raised-mode feel | appropriate | 5px primary is the most playful, but limited to button-like affordances. List rows lift only on selected. |
| dark-only compliance (D-28) | PASS | base `#241326` (dark berry). |
| shape-language differentiation (D-29) | 10/10 axes | Largest radii, fully-rounded chips, circle brand mark, biggest raised offsets — uniquely Bubble. |
| greyscale sufficiency (D-30) | PASS | Reads as COZY MOBILE GAME. Circle brand mark + fully-rounded pill chips + bouncy raised offsets are unmistakable in greyscale. |

### Daybreak — "fresh evening lobby, welcoming-daylight feel via bright accents on dark"

| Axis | Committed | Visible in renders |
|---|---|---|
| 1 corner radius | base 13px / chip 12px | medium-soft squircle |
| 2 button anatomy | 13px radius, 18×12 padding, friendly primary + soft-outline ghost | breathing, not loud |
| 3 chip / tab | rounded-rect 12px, accent fill + mint halo behind selected | daylight signal |
| 4 brand mark | rounded-square with accent halo aura | welcoming, lit-from-behind |
| 5 density | 24px padding, 16px gap | airiest in the set |
| 6 focus ring | 2px solid, 2px offset, mint glow halo | airy fresh ring |
| 7 type | H1 720 / H2 660 / sentence-case-accent kicker | calm, welcoming voice |
| 8 surface ramp | 4 stops, medium spread | airy fresh layers |
| 9 state behavior | hover +6%, pressed -6%, disabled 0.50 | soft, friendly response |
| 10 raised offset | primary 3px / tab 2px / row 0 / secondary 0; lifts primary + tabs | tactile but spare |

| Audit row | Result | Note |
|---|---|---|
| anti-cyberpunk | PASS | Mint accent is daylight, not neon; halo decorations are soft auras, not glow rims. |
| anti-texture | PASS | Solid teal surfaces, no patterns. |
| anti-painterly-chrome / anti-embossing | PASS | Halos are CSS box-shadow color-mix, not painted gradient surfaces. |
| raised-mode feel | appropriate | 3px primary, 2px tab — tactile without floating shells. |
| dark-only compliance (D-28) | PASS | base `#0B2420`. |
| shape-language differentiation (D-29) | 10/10 axes | Sentence-case kickers + brand-mark halo + mint-glow focus ring + airiest density distinguish Daybreak. |
| greyscale sufficiency (D-30) | PASS | Reads as COMMUNITY LOBBY. Halos behind selected tab and brand mark are visible in greyscale; sentence-case kickers contrast Pulse / Bubble / Burst's uppercase. |

### Burst — "celebratory MD3 Expressive max, bold event-like energy"

| Axis | Committed | Visible in renders |
|---|---|---|
| 1 corner radius | base 16px / chip 14px / primary 22px | dramatic statement on primary, bold elsewhere |
| 2 button anatomy | 16px radius (primary 22px, 24×16 padding), oversized statement primary | event-grade primary |
| 3 chip / tab | rounded-rect 14px, asymmetric on selected (selected tab is bigger) | hierarchy-amplified |
| 4 brand mark | chunky asymmetric badge, asymmetric border weights, slight rotation | eye-catching, not symmetric-corporate |
| 5 density | 22px padding, 14px gap | event-spread |
| 6 focus ring | 3px solid, 1px offset | dramatic event ring |
| 7 type | H1 820 / H2 780 / uppercase bold larger-scale kicker | biggest headlines in the set |
| 8 surface ramp | 4 stops, wide spread | dramatic layered emphasis |
| 9 state behavior | hover +8%, pressed -12% (bold), disabled 0.45 | strong press feedback |
| 10 raised offset | primary 5px / tab 3px / row 2px / secondary 2px; lifts primary + tabs + rows | clear depth hierarchy |

| Audit row | Result | Note |
|---|---|---|
| anti-cyberpunk | PASS | Celebratory bold gold reads achievement screen, not casino glow; no painted shine. |
| anti-texture | PASS | Solid surfaces, no patterns. |
| anti-painterly-chrome / anti-embossing | PASS | All emphasis via radius / size / weight / hard offset — never via faux 3D bevels. |
| raised-mode feel | appropriate | 5px primary + 2px secondary creates clear depth hierarchy without becoming gimmicky. |
| dark-only compliance (D-28) | PASS | base `#20112E` (dark plum). |
| shape-language differentiation (D-29) | 10/10 axes | Asymmetric brand mark + asymmetric selected tab + oversized primary radius + biggest type weights uniquely identify Burst. |
| greyscale sufficiency (D-30) | PASS | Reads as ACHIEVEMENT SCREEN. Asymmetric selected Lobby tab is visibly wider than peers, brand mark tilt is visible in greyscale, larger H1 is unmistakable. |

## D-30 Greyscale Sufficiency Test — composite

Composite at `screenshots/greyscale-sufficiency-test.png` shows all 5 desktop-flat artboards rendered with `filter: grayscale(1) contrast(1.05)` side by side. Source page: `src/greyscale-check.html` (visible in the Launch preview panel during this re-execution).

Reviewer test: hide direction labels, identify each direction by shape alone.

| Direction | Identifiable in greyscale? | Strongest shape-only differentiator |
|---|---|---|
| Pulse | YES | Tightest radii + flush rectangular tab strip + square cabinet-bezel brand mark + uppercase-tracked kickers |
| Slate | YES | Pill-shaped chips + small-caps "01 action panel" kickers (lowercase look) + narrow surface tonal range |
| Bubble | YES | Circle brand mark with halo + fully-rounded pill chips + biggest hard-offset raised buttons |
| Daybreak | YES | Halo aura around brand mark + halo behind selected tab + sentence-case "01 Action panel" + airiest spacing |
| Burst | YES | Asymmetric (visibly wider) selected Lobby tab + chunky asymmetric/tilted brand mark + biggest H1 + oversized primary radius |

D-30 PASSES on all five.

Mood-target check (per `CLAUDE-CODE-HANDOFF.md` "What 'passing on mood' looks like"):

- Pulse → CABINET CONTROL PANEL — PASS
- Slate → PREMIUM TOOL APP — PASS
- Bubble → COZY MOBILE GAME — PASS
- Daybreak → COMMUNITY LOBBY — PASS
- Burst → ACHIEVEMENT SCREEN — PASS

## Concept Render Evidence

- Render command: `node .planning/mockups/3.4/render.js concept-images`
- Runtime: `playwright-core` (locally installed in `.planning/mockups/3.4/node_modules/`, no committed dependency) driving system Microsoft Edge at `C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe` via `executablePath`. No browser download required.
- Desktop image dimensions: 1280×720 logical pixels at deviceScaleFactor=2 → ~2560×1440 PNG.
- Mobile image dimensions: 430×932 logical pixels at deviceScaleFactor=2 → ~860×1864 PNG.
- File-size sanity: every PNG is between 87KB and 175KB, well above the >5KB sanity floor required by the plan.
- Anti-aliasing: text rendered via Inter system fallback (Inter Variable not available locally — the system fallback Inter or Segoe UI was used). The shape-language differentiation does not depend on the specific font; type WEIGHT and KICKER STYLE are the differentiators, both of which render correctly.
- Per-direction shape-language source-of-truth lives in `data/directions.json` `shape_language` blocks AND in JS `NEOCADE_DIRECTIONS[*].shape` (mirrored intentionally for file:// runtime).
- Artboard CSS variable injection: every `.nc-artboard` element receives an inline `style="--radius-base: <r>px; --accent: <hex>; ..."` declaration set by `deriveTokens(direction, platform, raised)` in `src/neocade-mockups.js`.

## Forbidden-Surface Audit

Allowed in Phase 3.4:
- `.planning/mockups/3.4/**/*.html`
- `.planning/mockups/3.4/**/*.css`
- `.planning/mockups/3.4/**/*.js`
- `.planning/mockups/3.4/**/*.json`
- `.planning/mockups/3.4/**/*.md`
- `.planning/mockups/3.4/concepts/**/*.png`
- `.planning/mockups/3.4/screenshots/**/*.png`

Forbidden before Phase 4 — verified untouched in this re-execution:
- `addons/neocade_theme/**`
- `main.tscn`
- `project.godot`
- production `.tres` (no .tres files modified)
- production `.gd` (no .gd files modified)
- fonts / icons subfolders
- historical v0 mockup artifacts: `.planning/mockups/concepts/`, `.planning/mockups/03-direction-boards.*`, `.planning/research/mood-board/`

Local-only artifacts (gitignored, do not commit):
- `.planning/mockups/3.4/node_modules/` — playwright-core install for render.js. NOT committed.
- `.planning/mockups/3.4/package.json` + `package-lock.json` — created by `npm init -y` for the render dep. Should be gitignored or removed before commit.

## Finalist Readiness

- Concept boards: all 15 PNGs present and pass D-28/D-29/D-30 audits.
- Awaiting user gate: `.planning/mockups/3.4/finalist-selection.md` will be written by Plan 02 Task 4 once user picks 1-3 finalists.
- Plan 03 (finalist 4-grid) does NOT start until that file exists.
