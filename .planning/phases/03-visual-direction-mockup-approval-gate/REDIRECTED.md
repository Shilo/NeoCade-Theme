---
phase: 03-visual-direction-mockup-approval-gate
status: REDIRECTED
redirect_date: 2026-05-04
replaced_by:
  - 03.1-source-dive-md3-and-flat-3d-game-ui-research
  - 03.2-godot-dynamic-theme-architecture-research
  - 03.3-visual-direction-flat-extruded-flat-mockup-approval-gate
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

## What's next (post-architecture-revision 2026-05-04)

Three replacement phases (1 + 2 are parallel-eligible):

1. `/gsd-discuss-phase 3.1` — Phase 3.1: Source-Dive — MD3 + MD3 Expressive + Flat-3D Game UI Research (visual design language)
2. `/gsd-discuss-phase 3.2` — Phase 3.2 (NEW): Source-Dive — Godot Dynamic Theme Architecture Research (`NeoCadeTheme` superclass + per-theme subclass feasibility validation; primary deliverable is a working code spike at `.planning/spikes/dynamic-theme/`)
3. After Phase 3.1 + 3.2 verify: `/gsd-discuss-phase 3.3` — Phase 3.3 (was Phase 3.2): Visual Direction Mockup + Approval Gate (Flat / Extruded-Flat). Mockups demonstrate the dynamic superclass through 4-grid format (flat × raised × desktop × mobile from one subclass).

Phase 3.3 mockup gate replaces the original Phase 3 gate. Phase 4 cannot start until Phase 3.3 user approval is logged in writing.

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

## Architecture revision (2026-05-04 — supersedes the original 4-`.tres`-per-theme plan)

The user revised the architecture to be **dynamic, not pre-baked**. Per theme, **one `.tres` file**:

```
addons/neocade_theme/themes/prize_pop_plaza_neocade_theme.tres   # extends PrizePopPlazaNeoCadeTheme
addons/neocade_theme/themes/cabinet_chrome_neocade_theme.tres    # extends CabinetChromeNeoCadeTheme
... (one per approved theme)
```

Each subclass extends a `NeoCadeTheme` superclass:

```gdscript
@tool
class_name NeoCadeTheme extends Theme

enum Platform { DESKTOP, MOBILE, AUTO }

@export var base_color: Color
@export var accent_color: Color
@export var raised: bool = false
@export var platform: Platform = Platform.DESKTOP
# Setters trigger _regenerate_theme() that recomputes all entries
```

**Variation semantics:**
- `raised = false` → flat surfaces, `shadow_size = -1` everywhere
- `raised = true` → extruded-flat (offset darker shape underneath, no blur)
- `platform = DESKTOP` → forced desktop sizes (32px button, 14px body)
- `platform = MOBILE` → forced mobile sizes (48px button, 16px body, +50% spacing on space.4+)
- `platform = AUTO` → auto-detect via `OS.has_feature("mobile")` at runtime

**v1 file count:** N approved themes × 1 = N `.tres` files (was 4N). Each consumer toggles exports for the variation they want. Architecture supports undefined N.

**Phase 3.2 (NEW) must validate this is feasible** with a working code spike before Phase 3.3 mockups assume it works. If feasibility fails, fallback to static-`.tres`-per-variation generator per the original plan.
