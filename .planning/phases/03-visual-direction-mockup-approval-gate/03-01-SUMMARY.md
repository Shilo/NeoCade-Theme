---
phase: 03-visual-direction-mockup-approval-gate
plan: 01
subsystem: research/tooling
tags: [visual-research, mood-board, godot-mcp, gopeak, screenshot-baseline, imagegen]
requires: []
provides:
  - phase-3-reference-base
  - screenshot-smoke-baseline
  - concept-image-generation-path
affects: [phase-3-mockups, phase-10-qa]
tech-stack:
  added: []
  patterns:
    - URL-only all-rights-reserved visual references
    - programmatic screenshot fallback for Godot smoke capture
key-files:
  created:
    - .planning/research/mood-board/INDEX.md
    - .planning/research/mood-board/references.json
    - .planning/research/PHASE-3-TOOLING.md
    - .planning/research/godot-screenshot-smoke.png
  modified:
    - .planning/research/SOURCES.md
key-decisions:
  - "Recommend Prize Pop Plaza as Direction 4: a bright prize/crane/counter/reward-loop concept grounded in MB-012..MB-016."
  - "Recommend Orbital Playdeck as Direction 5: a constrained futuristic/immersive-venue concept grounded in MB-010 and MB-022..MB-025."
  - "Keep all promotional venue imagery URL-only unless explicit reusable licensing is selected and attributed."
  - "Use Coding-Solo Godot MCP for Phase 3 launch/debug, while documenting GoPeak as available but not active in this session."
requirements-completed:
  - RES-03
  - RES-04
  - DOCS-05
  - DESIGN-06
duration: 55min
completed: 2026-05-04
---

# Phase 3 Plan 01: Reference And Tooling Baseline Summary

Phase 3 now has a real-arcade evidence base, two researched new direction candidates, and an honest screenshot/tooling baseline before concept generation begins.

## Performance

- **Duration:** 55min
- **Tasks:** 5 completed
- **Files created/modified:** 6
- **Mood-board references:** 25

## Mood-Board Coverage

| Source family | Count | Use |
| --- | ---: | --- |
| Modern arcade / entertainment venue | 11 | Dominant evidence for real, public, social arcade energy. |
| Prize / ticket / counter / crane | 5 | Bright reward-loop vocabulary and large accessible affordances. |
| Classic / barcade / pinball / cabinet row | 5 | Cabinet, marquee, chrome, and tactile arcade grammar. |
| Future / neo / sci-fi / immersive venue | 4 | Curated minority for spaceship-adjacent inspiration without cyberpunk drift. |

Every reference includes source URL, image pointer, usage/licensing status, approved tags, an extraction caption, an anti-cyberpunk note, and candidate-direction influence. No venue or promotional images were copied into the repo.

## Direction Candidates

**Prize Pop Plaza** is my recommended fourth direction. It is distinct from Midnight Marquee, Boardwalk Sunset, and Cabinet Chrome because it leans into transparent prize cases, candy-bright redemption color, crane controls, ticket/card states, and success-state clarity.

**Orbital Playdeck** is my recommended fifth direction. It keeps the user's open sci-fi/spaceship possibility alive through real immersive venues, projected play, modular challenge rooms, clean onboarding stations, and playful future polish, but it remains a minority influence so NeoCade does not turn into cyberpunk or synthwave.

## Tooling Result

Godot MCP launch/debug works with Godot `4.6.2.stable.official.71f334935`; running and stopping the project produced no final errors. The active `mcp__godot__` surface includes version, project info, run, stop, editor launch, project listing, UID lookup, and UID update tools, but no direct screenshot tool.

GoPeak `v2.3.6` is available through `npx -y gopeak`, but it is not the active callable MCP server in this Codex session. Phase 3 therefore records a proven fallback screenshot at `.planning/research/godot-screenshot-smoke.png`, generated programmatically with PowerShell desktop capture while the Godot project was running. Phase 10 should prefer GoPeak or a viewport-native Godot screenshot harness if available.

The Codex app `image_gen` path is available through the `imagegen` skill and is the required Plan 02 route for concept-design images before HTML/Markdown boards.

## Task Commits

1. **Begin execution baseline** - `7b2b5a6`
2. **Create mood-board schema** - `29f47fc`
3. **Collect arcade mood-board references** - `df6a54f`
4. **Record phase tooling baseline** - `6d84efc`
5. **Update source coverage** - `19f2e26`

## Decisions And Deviations

The plan was followed with one tooling deviation: an early screenshot artifact was briefly committed before the mood-board task, then removed by the GSD commit helper when it was not part of the next file-scoped commit. The final screenshot evidence was regenerated and committed with the tooling report, so the final artifact set is correct.

No `.tres` files and no files under `addons/neocade_theme/` were modified.

## Next Plan Readiness

Ready for Plan 02: generate the five named concept-design directions, produce concept images first, then build the HTML/Markdown direction boards around those images and the supporting token/UI critique.
