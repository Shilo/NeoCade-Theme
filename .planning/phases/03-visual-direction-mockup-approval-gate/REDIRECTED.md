---
phase: 03-visual-direction-mockup-approval-gate
status: REDIRECTED
redirect_date: 2026-05-04
replaced_by:
  - 03.1-source-dive-md3-and-flat-3d-game-ui-research
  - 03.2-visual-direction-flat-extruded-flat-mockup-approval-gate
---

# Phase 3 — REDIRECTED 2026-05-04

This phase reached **Plan 03-03 (finalist-selection gate checkpoint)** before the user redirected the project. The painterly arcade-venue direction was rejected at the gate.

## Why redirected

The user reviewed the 5 generated direction concept images and direction boards, then rejected the painterly / 3D / textured / embossed direction across all 5 candidates. Specifically:

- **Boardwalk Sunset** (the Phase 3 recommended baseline) was the *most* rejected — too warm, leather-like, painterly, textured background.
- The other 4 directions (Midnight Marquee, Cabinet Chrome, Prize Pop Plaza, Orbital Playdeck) had elements the user liked — colors, certain shape language, certain personality — but **all had textures, embossing, or painterly chrome that violated what the user actually wanted**.

The user's revised direction is **flat Material Design 3 / MD3 Expressive language with optional "extruded flat 3D" raised variation** per the [Flat-3D Game UI](https://hcgamestudios.itch.io/flat-game-ui-for-mobile-games) and [UI Button Flat Design](https://fajrulaslim.itch.io/ui-button-flat-design) itch.io references. Hard rules: **no textures, no patterns, no embossing, no painterly/leather/wood/grunge, no gradients on chrome.**

## What's preserved (DO NOT DELETE)

- This phase directory in full: `03-CONTEXT.md`, `03-DISCUSSION-LOG.md`, `03-RESEARCH.md`, `03-REVIEWS.md`, `03-01..05-PLAN.md`, `03-01-SUMMARY.md`, `03-02-SUMMARY.md`
- `.planning/mockups/concepts/*.png` + `*-prompt.md` — 5 concept images + prompt files
- `.planning/mockups/03-direction-boards.html/.md/.png` — direction-board comparison gallery
- `.planning/mockups/03-direction-boards-check.md` — render-check report
- `.planning/research/mood-board/` — 25 mood-board references with INDEX.md + references.json

The user explicitly requested historical retention: any v0 direction may be revisited later (e.g., re-rendered through the flat-MD3 filter in v1.x or v2). Reproducing concept images from scratch costs time, so they stay.

## What's stopped (DO NOT advance)

- The **finalist-selection checkpoint from Plan 03-03 is NOT to be answered.**
- Plans 03-04 and 03-05 will not be executed in their current form.
- Phase 3 will not be re-executed; its functionality is split into Phase 3.1 (research) + Phase 3.2 (revised mockup phase).

## What's next

1. `/gsd-discuss-phase 3.1` — gather context for Phase 3.1 (MD3 + MD3 Expressive + Flat-3D Game UI research spike)
2. `/gsd-plan-review-convergence 3.1 --opencode` — plan + cross-AI review
3. `/gsd-execute-phase 3.1` — execute research
4. `/gsd-verify-work 3.1` → `/clear` → `/gsd-discuss-phase 3.2`
5. Phase 3.2 mockup phase produces 5 new themes × 4 variations and replaces the original Phase 3 gate

## User feedback log captured for Phase 3.2 input

- **Midnight Marquee** — colors loved (LDtk-like, arcade vibe). Reject: 3D elements, textured backgrounds. Want: flat, no 3D, no textures.
- **Boardwalk Sunset** — REJECTED. Background too warm/leather/old-fashioned. Has texture. Did appreciate flat/simple feel.
- **Cabinet Chrome** — colors loved (similar to Midnight Marquee). Reject: 3D, textures. Want: flat.
- **Prize Pop Plaza** — LOVED. Childish, friendly, mobile-game vibe. Raised buttons (extruded flat) work in this design. 3D bubbly/jelly/candy works. Reject: textures, embossing. Want: simple 3D interactables with colorful flat fill.
- **Orbital Playdeck** — safest/best. Modern, dark theme, big buttons, color where it matters, nice rounding (iOS-like). Reject: textured backgrounds.

## Universal new constraints surfaced by the redirect

- **Avoid texture and patterns entirely** — backgrounds and surfaces are flat solid colors.
- **No embossing, no painterly/leather/wood backgrounds, no gradients on chrome.**
- **Flat design like Material Design 3** + **MD3 Expressive** is the primary reference language.
- The "Flat 3D Game UI" / "Extruded Flat UI" pattern (per user's itch.io references) is the optional **raised** variation: solid color + offset darker shape underneath = depth, no soft shadows/textures.
- 5 themes, each in 4 variations (flat × raised × desktop × mobile) — undefined number of themes supported by architecture.

## Theme variation matrix (NEW v1 spec)

Per theme, 4 `.tres` files:

| Variation | Filename pattern |
|-----------|------------------|
| Flat × Desktop | `{theme}_flat_desktop.tres` |
| Flat × Mobile | `{theme}_flat_mobile.tres` |
| Raised × Desktop | `{theme}_raised_desktop.tres` |
| Raised × Mobile | `{theme}_raised_mobile.tres` |

5 themes × 4 variations = 20 `.tres` files for v1. Architecture supports undefined N. Phase 4 generator updated to produce N × 4 from a single TokenSet matrix.
