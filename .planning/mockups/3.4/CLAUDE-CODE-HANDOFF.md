# Phase 3.4 Plan 02 — Claude Code Handoff

**Created:** 2026-05-06b
**Audience:** Claude Code, taking over Phase 3.4 Plan 02 re-execution from Codex.
**Goal:** Generate 15 Stage 1 concept PNGs that let the user pick 1-3 finalist theme directions on personality, not on color preference.

## TL;DR — What changed and why you're here

The first execution of Phase 3.4 Plan 02 (by Codex) produced 15 concept PNGs that the user rejected. Every direction looked like the same UI template with only color tokens swapped — Pulse, Slate, Bubble, Daybreak, and Burst were pixel-for-pixel layout-identical. The user's word: "every theme looks like the same, only with a color difference." On audit, the underlying spec encoded "single fixed template, only `base_color` / `accent_color` / corner radius / state colors vary" — but the implementing CSS hard-coded `--radius: 12px` for all five directions, and never expressed personality through shape language at all.

The user's intent (now explicit and locked):
1. Same controls, same control order, same content, same dark base across all five directions — so side-by-side comparison is honest.
2. Each direction expresses its personality through shape language and styling (corner radius, button anatomy, density, brand mark, focus rings, etc.) — not through different layouts and not through color alone.
3. All five directions are dark mode (Bubble + Daybreak migrated from light to dark in Phase 3.3 Revision 2/2).
4. Direction names stay one-word generic non-trademark: Pulse, Slate, Bubble, Daybreak, Burst.

You are taking over because the user judges Claude Code superior to Codex on UI design.

## Mood priming (read this first — it's the lens for everything below)

This is the part the previous executor (Codex) most clearly missed. Each of the five directions has a **distinct emotional target** that the mockups must convey. The 10 shape-language axes in the spec are TOOLS for expressing these moods — not the moods themselves. If your committed token values reproduce the geometry but lose the vibe, the mockups will still fail. Internalize each direction's emotional signature first, then pick token values that serve it.

### Pulse — "Vibrant arcade hall by day, lights on, UI doing the work"

The mood is **social, fast, clear, energetic**. Imagine walking into a busy arcade in mid-afternoon — cabinets humming, players engaged, primary actions like "Start" or "Insert Coin" lit up and demanding attention. NOT cyberpunk, NOT after-dark glow. Day-bright energy on a dark hall.

Visual translation:
- Tight cabinet-bezel corner radius (4-6px) — mechanical, panel-like, NOT soft
- Bold green accent dominates primary actions — they look like LIT cabinet buttons
- Dense layout — packed control deck, no airy lobby breathing
- Rectangular tab strip rather than pills — like cabinet selector buttons in a row
- Strong state contrast on hover/press — UI feels tactile, responsive, mechanical

If Pulse's mockup looks "calm" or "spacious," you missed the mood.

### Slate — "Premium dark default, iOS-style polish, quiet confidence"

The mood is **calm, polished, restrained, professional**. Imagine a high-end iPad app or a senior editor's tool palette — every detail considered, no shouty emphasis, accent used sparingly so it MEANS something when it appears.

Visual translation:
- iOS-pill medium radius (10-12px) on most chrome, slightly sharper on inputs
- Pill-shape (999px) for chips/tabs — restrained, sophisticated
- Spacious layout (22px padding) — breathing room communicates premium
- Sky-blue accent appears ONLY on primary action / focus / selection / important toggles — never decorative
- 2px focus ring with 2px offset (iOS-style) — feels considered
- Gentle hover delta (4%) — quiet, not aggressive

If Slate's mockup looks "dense" or "loud," you missed the mood. Restraint IS the personality.

### Bubble — "Playful candy-counter at night, tactile cheerful warmth"

The mood is **friendly, childlike, mobile-game-bright, tactile**. Think candy crush, cozy cafe game, kids' arcade redemption counter — but at night on dark berry surfaces, so the cheer is contained and grown-up-friendly.

Visual translation:
- Generous corner radius (16-22px) on everything — pillowy, squircle, soft
- Fully-rounded (999px) pill chips — cheerful, not businesslike
- Circle or squircle brand mark — friendly, organic, NOT corporate-square
- BIG raised offset (4-5px) on primary buttons — they feel "poked-out" and inviting to press
- 3px focus ring with offset — chunky, joyful emphasis
- Bouncy hover delta (8%) — feels alive

If Bubble's mockup looks "minimal" or "professional," you missed the mood. Cheerful tactility IS the personality.

### Daybreak — "Fresh evening lobby, welcoming-daylight feel via bright accents on dark"

The mood is **welcoming, fresh, social, airy**. Imagine the lobby of a community center at evening — lights are on, people are gathering, the space is calm but inviting. The "daylight" feel comes from BRIGHT mint accents on dark teal surfaces, not from light backgrounds.

Visual translation:
- Medium-soft corner radius (12-14px) — friendly squircle, not too round
- Airy spacing (24px padding) — open lobby, room to breathe
- Bright mint accent with subtle halo behind primary actions — daylight signal in the dark
- Rounded square brand mark with halo decoration — welcoming, lit-from-behind
- 2px focus ring with mint glow halo — fresh emphasis
- Generous breathing in mobile mode

If Daybreak's mockup looks "tight" or "dim," you missed the mood. Airiness + bright accent IS the personality.

### Burst — "Celebratory MD3 Expressive max, bold event-like energy"

The mood is **bold, celebratory, dramatic, achievement-ready**. Think party-game launcher, achievement unlock screen, brand-forward showcase. Maximum permitted expressiveness while staying readable and professional.

Visual translation:
- Bold corner radius (14-18px) on chrome, OVERSIZED radius (22+) on primary buttons — primary actions feel event-grade
- Asymmetric or chunky brand-mark badge — eye-catching, not symmetric-corporate
- Asymmetric size on selected tab/chip — primary visual break from the rest
- BIG raised offset (4-6px) on primary, smaller on secondary — clear depth hierarchy
- 3px gold focus ring — dramatic, gilded emphasis
- Strong pressed delta (-12%) — bold press feedback

If Burst's mockup looks "balanced" or "symmetric," you missed the mood. Hierarchy-amplified emphasis IS the personality.

### Self-check before you render anything

After committing your shape-language values in Task 1, ask yourself for each direction:

> *If a stranger looked at this mockup with all color removed, would they correctly guess which one is the "playful candy-counter" vs the "premium iOS-style" vs the "celebratory event"?*

If you can't answer yes, push the differentiation harder before generating PNGs. The greyscale test in Task 3 is the formal gate — but the goal is to pass it on the first render, not to discover failures after generating 15 images.

### What "passing on mood" looks like

Five mockups, all dark, all using the same screen layout and control inventory, but:

- Pulse feels like a CABINET CONTROL PANEL
- Slate feels like a PREMIUM TOOL APP
- Bubble feels like a COZY MOBILE GAME
- Daybreak feels like a COMMUNITY LOBBY
- Burst feels like an ACHIEVEMENT SCREEN

Different rooms in the same arcade. Same architecture, different vibes.

## Read these before doing anything

In this order:

1. **`.planning/mockups/3.4/image-prompts/direction-shape-language-spec.md`** — authoritative spec. Defines what's constant vs what must vary per direction. Lists ten shape-language axes with proposed per-direction values you may refine.
2. **`.planning/phases/03.4-visual-direction-flat-extruded-flat-mockup-approval-gate/03.4-CORRECTIVE-ADDENDUM.md`** — corrective decisions D-28 (dark only), D-29 (per-direction shape-language tokens required to vary), D-30 (greyscale sufficiency test). Binding.
3. **`.planning/phases/03.4-visual-direction-flat-extruded-flat-mockup-approval-gate/03.4-02-stage-1-concept-boards-and-finalist-selection-PLAN.md`** — patched Plan 02. Tasks 0-4 are what you execute.
4. **`.planning/research/THEME-DIRECTIONS.md`** — direction identities, palettes (Revision Round 2/2 applied — all dark), personality summaries. Locked.
5. **`.planning/mockups/3.4/data/directions.json`** — already encodes the locked palettes plus a starting-point `shape_language` block per direction. You may refine values in Task 1, but must preserve direction identity and the constants from the spec.
6. **`.planning/research/MD3-RESEARCH.md`** + **`.planning/research/FLAT-3D-UI-RESEARCH.md`** — design grammar references for MD3 / MD3 Expressive shape and emphasis tokens, and for extruded-flat raised construction rules.

## What's already prepared for you

| Asset | Status | Disposition |
|---|---|---|
| `data/directions.json` | Updated | Has dark palettes + per-direction `shape_language` proposals. Refine in Task 1; commit your final values here. |
| `image-prompts/direction-shape-language-spec.md` | NEW | Authoritative spec. The ten axes table includes proposed values per direction. |
| `image-prompts/fixed-control-order-spec.md` | DEPRECATED in-place | Do not consume. Preserved with deprecation header for audit trail. |
| `wcag-palette-audit.md` | Already correct | All 5 dark palettes verified at WCAG AAA. No re-verification needed unless you change a palette (you should not). |
| `concept-gallery.html`, `finalist-gallery.html` | Reusable shells | Do not redesign the gallery wrappers. They link to the artboard images which is what you're regenerating. |
| `concept-image.html` | Shell only (440 bytes) | Mounts `data-gallery="concept-image"` for `neocade-mockups.js` to fill. You may rewrite the artboard rendering logic. |
| `render.js` | Reusable | Playwright-based screenshot script. The `Plan 01` summary says it uses the bundled Codex runtime `NODE_PATH`; on Claude Code, you may render screenshots however works best for you. |
| `src/neocade-mockups.css` | Mixed | The gallery-page rules (`.nc-page`, `.nc-direction-section`, `.nc-concept-image-grid`, etc.) are reusable. The artboard rules (`.nc-artboard`, `.nc-board`, `--radius: 12px`) encoded the bug — rewrite to consume per-direction tokens, not hard-coded shared values. |
| `src/neocade-mockups.js` | Reusable scaffold | Renderer/data-binding logic; rewrite the artboard rendering paths to apply per-direction shape-language tokens. |
| `concepts/*.png` | DELETED | All 15 first-execution PNGs removed before this handoff. Generate replacements. |
| `render-check.md` | Update during re-execution | Add D-30 greyscale sufficiency test results per direction. |

## What you must produce

**15 concept PNGs**, in `.planning/mockups/3.4/concepts/`, with these exact filenames:

| Direction | Desktop flat (1280×720) | Mobile flat (430×932) | Mobile raised (430×932) |
|---|---|---|---|
| Pulse | `pulse-desktop-flat.png` | `pulse-mobile-flat.png` | `pulse-mobile-raised.png` |
| Slate | `slate-desktop-flat.png` | `slate-mobile-flat.png` | `slate-mobile-raised.png` |
| Bubble | `bubble-desktop-flat.png` | `bubble-mobile-flat.png` | `bubble-mobile-raised.png` |
| Daybreak | `daybreak-desktop-flat.png` | `daybreak-mobile-flat.png` | `daybreak-mobile-raised.png` |
| Burst | `burst-desktop-flat.png` | `burst-mobile-flat.png` | `burst-mobile-raised.png` |

Each image must:

- Use the **same screen layout, same control inventory, same control order, same content/labels** as every other direction's images at the same variant. Section "Constants" in the shape-language spec is binding.
- Use the **direction-specific shape-language values** committed in `data/directions.json` (or per-direction CSS variable scopes). Section "Required-to-vary per direction" is binding. All ten axes must vary per direction.
- Be dark-mode (D-28). No light surfaces. No light themes.
- Pass anti-cyberpunk, anti-texture, anti-painterly-chrome, anti-embossing review (Phase 3 redirect rules).
- Pass the greyscale sufficiency test (D-30): a colorblind reviewer must still be able to identify each direction by shape language alone.

## Suggested execution flow

1. **Task 0 (already done)** — first-execution PNGs deleted. The concepts dir is empty.

2. **Task 1 — Commit shape-language token values per direction.** Read the spec's "Required-to-vary" table. The `directions.json` `shape_language` block per direction is a starting point; refine the values to match your design judgement and the direction's documented personality. Either:
   - Keep all token values in `data/directions.json` and have `src/neocade-mockups.js` read them at render time, OR
   - Encode them as per-direction CSS variable scopes (e.g., `[data-direction="Bubble"] { --radius-base: 18px; ... }`) in `src/neocade-mockups.css`, OR
   - Both (recommended — JSON is self-documenting, CSS is what the renderer consumes).

   Either way, the artboard rules MUST consume per-direction tokens. The previous `--radius: 12px` hard-code is the bug; remove it.

3. **Task 2 — Render the 15 PNGs.** Use whichever rendering path fits Claude Code best (Playwright via `render.js`, headless browser, MCP tooling, etc.). The 1280×720 and 430×932 aspect ratios are baseline expectations from Plan 01; you may adjust if your render path requires it but the desktop-vs-mobile distinction must be visible.

4. **Task 3 — Render-check audit + greyscale sufficiency test.** Update `render-check.md` per Plan 02 Task 3. The greyscale test is the most important new check: convert each direction's `*-desktop-flat.png` to greyscale, place all five greyscale renders side by side, and confirm each is identifiable by shape alone. If two directions merge in greyscale, go back to Task 1 and increase shape-language differentiation on the affected directions.

5. **Task 4 — Present the finalist-selection user gate.** Plan 02 Task 4 (formerly Task 3) is unchanged: present the 15 images to the user via the `concept-gallery.html` (open in browser), ask them to select 1-3 finalists, write their decision to `.planning/mockups/3.4/finalist-selection.md`. Do not auto-select.

## Hard rules

- Do not change direction names. They are locked at Pulse, Slate, Bubble, Daybreak, Burst.
- Do not change palettes. They are locked in `THEME-DIRECTIONS.md` Revision Round 2/2 and `wcag-palette-audit.md`.
- Do not introduce light themes. All five v1 directions are dark.
- Do not modify production files: `addons/`, `main.tscn`, `project.godot`, any `.tres` or `.gd`. Phase 4+ owns those.
- Do not modify v0 historical artifacts: `.planning/mockups/concepts/` (different folder from `.planning/mockups/3.4/concepts/` — note the absence of `3.4`), `.planning/mockups/03-direction-boards.*`, `.planning/research/mood-board/`. Those are preserved by the Phase 3 redirect.
- Do not invent atmospheric venue artwork separate from the UI mockup. The mood is carried by the styling of the same screen, not by separate concept-art renders.
- Do not start Plan 03 (finalist 4-grid) before the user has selected finalists at the Plan 02 gate.

## Optional but valuable

- If your render of a particular direction visibly fails the greyscale test, push the direction's shape-language values further apart from its nearest sibling. Don't be conservative on shape — the comparison is the whole point.
- If you find that two of the ten axes are redundant (e.g., axis 5 density and axis 8 surface ramp depth co-vary too tightly), document that observation in `render-check.md` so Plan 03 can collapse them.
- If the desktop-flat render of any direction screams "iOS native" or "Material default" loudly enough that the user might confuse NeoCade with the platform UI it's running on, adjust the brand-mark or kicker to keep NeoCade identity visible.

## Phase 4 implications (for your awareness, not your execution)

Phase 4 will translate the approved direction's shape-language tokens into Godot StyleBox parameters via the `NeoCadeTheme` superclass. The committed values in `data/directions.json` `shape_language` blocks become the seed values for Phase 4's `_get_button_radius()`-style formulas. So choose token values you'd be comfortable seeing in the actual Godot theme. The closer your mockups match the Godot rendering capabilities (no exotic CSS the StyleBox can't replicate), the smoother Phase 4 will be.

**Single concrete class + data-driven `.tres` per direction (locked 2026-05-06e, `@export` set finalized 2026-05-06f — godot-minimal-theme pattern):** `NeoCadeTheme` is `@tool class_name NeoCadeTheme extends Theme` (concrete, NOT abstract; users can instantiate directly to author custom themes). Lives at `addons/neocade_theme/neocade_theme.gd` (the **only** `.gd` file in the addon). Has **9 `@export` properties total**: Core (4) — `base_color`, `accent_color`, `raised`, `platform`; Shape (5, under `@export_group("Shape")`) — `corner_radius`, `spacing`, `raised_strength`, `focus_thickness`, `outline_width`. The `@export` set is intentionally minimal — limited to values that should be consistent across the entire theme; per-direction unique mood lives in Theme Editor entry overrides per `.tres` (StyleBoxFlat per Control state with direction-specific bg/border/padding/etc.), NOT in a long list of exports. `_regenerate_theme()` computes `var is_light: bool = base_color.get_luminance() >= 0.5` (dark default; `is_light` flags deviation) and branches all conditional formulas on `is_light` (godot-minimal-theme line-56 pattern with renamed/inverted variable). Each approved theme direction is purely **data** — a `.tres` file `[gd_resource type="NeoCadeTheme" format=3]` with its specific `@export` values + Theme Editor authored entry overrides for personality. **No per-direction `.gd` files, no class hierarchy, no subclasses.** **Flat addon layout (2026-05-06d):** all files at `addons/neocade_theme/` root; no `_dev/` or `themes/` subfolders; `fonts/` and `icons/` remain as their own subfolders. **No root `neocade_theme.tres`** — consumers preload a specific named direction. v1 ships **1 `.gd` + 5 `.tres`** at the addon root. The Phase 3.4 user pick designates the **recommended starter direction**: used as the showcase scene's default theme + the README "try this first" suggestion; ships no separate file. This does not affect Plan 02 mockup execution — render all 5 directions as peers; the recommended-starter pick happens after Plan 03 finalist mockups. See `.planning/phases/03.4-visual-direction-flat-extruded-flat-mockup-approval-gate/03.4-CORRECTIVE-ADDENDUM.md` D-31 for the full contract.

## Questions

If a decision is ambiguous between the spec, the addendum, the plan, the directions data, and the WCAG audit:
1. Spec (`direction-shape-language-spec.md`) wins on what varies vs what's constant.
2. Addendum (`03.4-CORRECTIVE-ADDENDUM.md`) wins on the dark-only, ten-axes, greyscale-test rules.
3. THEME-DIRECTIONS.md wins on direction identity, naming, and personality intent.
4. WCAG audit wins on contrast / palette values.
5. directions.json `shape_language` block is your starting point for token values; you may refine within the spec's bounds.
6. Plan ties go to the user — open a checkpoint via the existing Plan 02 Task 4 mechanism.

Good luck.
