# Phase 3.4 Mockup Pipeline

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

Stage 1 renders 10 concept boards:

- Pulse flat
- Pulse raised
- Slate flat
- Slate raised
- Bubble flat
- Bubble raised
- Daybreak flat
- Daybreak raised
- Burst flat
- Burst raised

Each board uses a representative Control slice: action buttons, an input, a selection/list area, a popup/dialog sample, state samples, and palette/type/radius swatches. Stage 1 is a taste gate, not full Control coverage.

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

Open the gallery directly in a browser:

- `.planning/mockups/3.4/concept-gallery.html`
- `.planning/mockups/3.4/finalist-gallery.html`

If bundled Playwright is available, render screenshots with:

```powershell
$env:NODE_PATH="C:\Users\shilo\.cache\codex-runtimes\codex-primary-runtime\dependencies\node\node_modules"
node .planning/mockups/3.4/render.js concept
```

The script writes screenshots under `.planning/mockups/3.4/screenshots/`.

## Phase 4 Handoff

Phase 4 may begin only after:

- finalist selection is recorded;
- final approval and base direction are recorded;
- `DESIGN_TOKENS.md` exists;
- the closeout audit confirms no production files changed.
