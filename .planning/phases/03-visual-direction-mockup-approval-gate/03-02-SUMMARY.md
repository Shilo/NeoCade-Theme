---
phase: 03-visual-direction-mockup-approval-gate
plan: 02
subsystem: visual-direction
tags: [concept-images, direction-boards, mockups, inter-only, accessibility]
requires:
  - 03-01-reference-and-tooling-baseline
provides:
  - five-named-art-directions
  - concept-design-images
  - html-direction-board-gallery
  - markdown-direction-board-companion
affects: [phase-3-finalist-selection, phase-3-final-token-approval]
tech-stack:
  added: []
  patterns:
    - concept-image-first direction exploration
    - Inter Variable Roman only typography baseline
    - token sketch before final token contract
key-files:
  created:
    - .planning/mockups/concepts/midnight-marquee-concept.png
    - .planning/mockups/concepts/boardwalk-sunset-concept.png
    - .planning/mockups/concepts/cabinet-chrome-concept.png
    - .planning/mockups/concepts/prize-pop-plaza-concept.png
    - .planning/mockups/concepts/orbital-playdeck-concept.png
    - .planning/mockups/03-direction-boards.html
    - .planning/mockups/03-direction-boards-check.md
    - .planning/mockups/03-direction-boards-desktop.png
    - .planning/mockups/03-direction-boards-mobile.png
  modified:
    - .planning/mockups/03-direction-boards.md
key-decisions:
  - "Recommended baseline remains Boardwalk Sunset."
  - "Recommended finalist set for user review: Boardwalk Sunset, Prize Pop Plaza, and Cabinet Chrome."
  - "Orbital Playdeck is worth keeping as the strongest sci-fi/future option, but only if the user wants a higher-risk finalist."
requirements-completed:
  - DESIGN-01
  - DESIGN-02
  - TOKEN-01
  - TOKEN-02
  - TOKEN-03
  - TOKEN-05
  - TOKEN-06
  - TOKEN-07
  - TOKEN-08
  - TOKEN-09
  - TOKEN-10
duration: 70min
completed: 2026-05-04
---

# Phase 3 Plan 02: Five Concept Directions Summary

Five distinct concept-first direction boards are ready for finalist selection, with generated images, token sketches, state/type samples, source traces, and render checks.

## Five Directions

| Direction | Differentiating axes | Best use |
| --- | --- | --- |
| Midnight Marquee | Dense cabinet rows, cool navy, warm marquee amber, prototype continuity | If we want to preserve the original mockup's energy after correcting synthwave risk. |
| Boardwalk Sunset | Warm venue flow, amber/coral/mint accents, professional public arcade feel | **Recommended baseline** for v1. |
| Cabinet Chrome | Charcoal hardware panels, orange focus, chrome/control-deck precision | Editor-safe fallback with disciplined arcade hardware personality. |
| Prize Pop Plaza | Transparent prize bays, reward cards, large controls, candy-bright mature accents | Strong playful alternative and best accessibility/tap-target energy. |
| Orbital Playdeck | Friendly future playdeck, modular zones, teal/amber/violet accents | Highest-risk option if the user wants sci-fi/spaceship inspiration in the finalist mix. |

## Recommendation

I recommend **Boardwalk Sunset** as the baseline because it best matches the locked phrase "vibrant arcade hall by day": warm, colorful, public, professional, and least likely to drift into cyberpunk. It also remains closest to the existing architecture research and has the strongest contrast story.

For finalists, my recommended set is **Boardwalk Sunset**, **Prize Pop Plaza**, and **Cabinet Chrome**. Prize Pop Plaza brings the most genuinely new arcade-specific playfulness, while Cabinet Chrome gives us the clean professional fallback. If you want the sci-fi lane represented in the next mockups, swap Cabinet Chrome for **Orbital Playdeck** or include four finalists only if you want extra work at the gate.

## Risks For Gate Discussion

- Midnight Marquee can drift back toward synthwave if cyan/pink dominate.
- Boardwalk Sunset can become too brown/orange if mint and coral are underused.
- Cabinet Chrome can become too generic if cabinet hardware geometry is softened.
- Prize Pop Plaza can become childish if mascots, novelty type, or toy clutter enter.
- Orbital Playdeck can become Tron/cockpit/cyberpunk if it stops reading as a friendly public play venue.

## Verification

- Generated 5 concept images and 5 prompt files under `.planning/mockups/concepts/`.
- Built `.planning/mockups/03-direction-boards.html` and `.planning/mockups/03-direction-boards.md`.
- Rendered desktop screenshot at 1440px: `.planning/mockups/03-direction-boards-desktop.png`.
- Rendered mobile/narrow screenshot at 390px: `.planning/mockups/03-direction-boards-mobile.png`.
- Recorded render check in `.planning/mockups/03-direction-boards-check.md`.
- No `.tres` files and no files under `addons/neocade_theme/` were modified.

## Task Commits

1. **Derive five art directions** - `8bcfdd1`
2. **Generate direction concept images** - `89e93f3`
3. **Build comparative direction boards** - `f667789`
4. **Verify direction board render** - `9062220`

## Next Gate

Ready for Plan 03 finalist-selection gate. The user should select two or three directions for desktop/mobile representative mockups, or request revisions to the five-direction board before finalist mockups begin.
