# Phase 3.4 Mockup Pipeline

> **Status (2026-05-06):** Plan 02 re-executed by Claude Code under the per-direction shape-language contract and is closed. 15 concept PNGs in `concepts/` pass D-28 (dark-only), D-29 (10-axis differentiation), and D-30 (greyscale sufficiency — each direction reads as the right mood without color). User selected **Pulse** as the v1 recommended starter / implementation priority, while Slate, Bubble, Daybreak, and Burst remain v1 personality variations. **Plan 03 is paused at the final approval gate**: Pulse full-fidelity 4-grid + full Control/state matrix + color override row are complete; `.planning/mockups/3.4/final-approval.md` is still missing.

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

After the 15 boards are reviewable, the user gate asks for finalist directions. This gate is closed: Pulse is the recommended starter / implementation priority, and all five directions remain approved for v1 ship as personality variations.

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

After finalist review, the user approves final themes and confirms exactly one approved direction as the recommended starter direction. This has no architectural privilege; it only sets the showcase default and README "try this first" suggestion. That decision unlocks `DESIGN_TOKENS.md`.

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
- final approval and recommended starter are recorded;
- `DESIGN_TOKENS.md` exists;
- the closeout audit confirms no production files changed.
