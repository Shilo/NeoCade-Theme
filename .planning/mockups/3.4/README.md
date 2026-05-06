# Phase 3.4 Mockup Pipeline

> **Status (2026-05-06):** Plan 02 re-executed by Claude Code under the per-direction shape-language contract. 15 concept PNGs in `concepts/` pass D-28 (dark-only), D-29 (10-axis differentiation), and D-30 (greyscale sufficiency — each direction reads as the right mood without color). **Awaiting user finalist selection** at the Plan 02 Task 4 gate. See `render-check.md` for the per-direction audit and `screenshots/greyscale-sufficiency-test.png` for the D-30 composite. Plan 03 (finalist 4-grid) does NOT start until `finalist-selection.md` exists.

This directory contains the visual contract workspace for Phase 3.4. It is planning-only: no production theme resources, scene files, project settings, fonts, icons, or files under `addons/neocade_theme/` are edited here.

## Phase Boundary

Phase 3.4 turns the five approved Phase 3.3 directions into reviewable HTML mockups. The output is a decision record and `DESIGN_TOKENS.md`, not production `.tres` styling.

Historical v0 work remains preserved outside this directory:

- `.planning/mockups/concepts/`
- `.planning/mockups/03-direction-boards.html`
- `.planning/mockups/03-direction-boards.md`
- `.planning/mockups/03-direction-boards-*.png`
- `.planning/mockups/03-direction-boards-check.md`

## Stage 1

Stage 1 renders **15 concept PNGs** — 5 directions × 3 variants each:

- desktop-flat (1280×720, `raised=false`, `platform=DESKTOP`)
- mobile-flat (430×932, `raised=false`, `platform=MOBILE`)
- mobile-raised (430×932, `raised=true`, `platform=MOBILE`)

Directions: Pulse, Slate, Bubble, Daybreak, Burst. Every direction shows both flat and raised modes; raised is shown on mobile to also exercise platform sizing. Each artboard uses the same fixed control inventory (brand mark + nav tabs, action panel with primary/secondary/ghost + input + toggle, dialog stack with segmented + popup + progress + actions, list/tree with selected + 2 normal rows, state strip, palette swatches) so direction comparison is honest. Per-direction personality comes from the 10 shape-language axes in `image-prompts/direction-shape-language-spec.md`. Stage 1 is a taste gate, not full Control coverage.

## User Gate 1

After the 10 boards are reviewable, the user gate asks for 1-3 finalist directions. Selecting a finalist chooses the direction itself; both flat and raised variants remain supported.

The decision file is:

- `.planning/mockups/3.4/finalist-selection.md`

## Finalist 4-Grid

Only selected finalists receive full-fidelity mockups. Each finalist is shown in a 4-grid:

- `raised=false`, `platform=DESKTOP`
- `raised=false`, `platform=MOBILE`
- `raised=true`, `platform=DESKTOP`
- `raised=true`, `platform=MOBILE`

The finalist gallery also includes `base_color` and `accent_color` override previews so the dynamic `NeoCadeTheme` export model is visible before implementation.

## User Gate 2

After finalist review, the user approves N final themes and chooses exactly one approved direction as the `NeoCadeTheme` base direction. That decision unlocks `DESIGN_TOKENS.md`.

The decision file is:

- `.planning/mockups/3.4/final-approval.md`

## Render Or Inspect

Open the gallery directly in a browser (no dependencies needed):

- `.planning/mockups/3.4/concept-gallery.html`
- `.planning/mockups/3.4/finalist-gallery.html`

The pre-rendered concept PNGs live at `.planning/mockups/3.4/concepts/` and the audit composites at `.planning/mockups/3.4/screenshots/`.

To re-render PNGs from the HTML, install `playwright-core` once locally (gitignored — does NOT add a project dependency):

```powershell
cd .planning/mockups/3.4
npm install --no-save playwright-core
```

Then run one of the render modes (driven by system Microsoft Edge — no browser download required):

```powershell
node .planning/mockups/3.4/render.js                  # captures the concept gallery overview
node .planning/mockups/3.4/render.js concept-images   # captures all 15 per-direction PNGs
node .planning/mockups/3.4/render.js finalist         # captures the finalist gallery shell
```

Outputs land in `.planning/mockups/3.4/concepts/` (per-direction PNGs) and `.planning/mockups/3.4/screenshots/` (composite audits).

## Phase 4 Handoff

Phase 4 may begin only after:

- finalist selection is recorded;
- final approval and base direction are recorded;
- `DESIGN_TOKENS.md` exists;
- the closeout audit confirms no production files changed.
