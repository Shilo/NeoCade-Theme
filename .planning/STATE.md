---
gsd_state_version: 1.0
milestone: v1.0.0
milestone_name: milestone
status: redirected
stopped_at: Phase 3 REDIRECTED 2026-05-04 at Plan 03-03 finalist-selection gate; user rejected painterly arcade-venue direction; replacement is Phase 3.1 (research) + Phase 3.2 (revised mockup)
last_updated: "2026-05-04T19:00:00.000Z"
last_activity: 2026-05-04
progress:
  total_phases: 13
  completed_phases: 2
  total_plans: 15
  completed_plans: 12
  percent: 15
---

# Project State

## Project Reference

See: .planning/PROJECT.md (updated 2026-05-04)

**Core value:** A drop-in Godot 4.6 **flat MD3 / MD3 Expressive** Theme system at `res://addons/neocade_theme/` that ships **N approved themes × 4 variations** (flat-desktop, flat-mobile, raised-desktop with extruded-flat depth, raised-mobile) produced from a single `@tool` TokenSet matrix — every built-in Control themed to a `godot-minimal-theme` bar of feature-completeness, accessible (WCAG 2.1 AA), universal across editor + runtime + all 6 Godot export targets. **No textures / no patterns / no embossing / no painterly chrome** (locked 2026-05-04 redirect).
**Current focus:** Phase 3 REDIRECTED 2026-05-04 → next is Phase 3.1 (MD3 + Flat-3D Game UI Research Spike), then Phase 3.2 (revised mockup phase)

## Current Position

Phase: 3 REDIRECTED (visual-direction-mockup-approval-gate) — outputs preserved as v0 historical reference; functionality replaced by Phase 3.1 + 3.2
Next: Phase 3.1 (Source-Dive — MD3 + MD3 Expressive + Flat-3D Game UI Research)
Status: Awaiting `/gsd-discuss-phase 3.1`
Last activity: 2026-05-04 (Phase 3 redirect captured)

Progress: [██░░░░░░░░░░░] 15% (2 of 13 phases complete; Phase 3 REDIRECTED — does not count toward percent)

## Performance Metrics

**Velocity:**

- Total plans completed: 10
- Average duration: —
- Total execution time: 0 hours

**By Phase:**

| Phase | Plans | Total | Avg/Plan |
|-------|-------|-------|----------|
| — | — | — | — |
| 1 | 5 | - | - |
| 02 | 5 | - | - |

**Recent Trend:**

- Last 5 plans: —
- Trend: —

*Updated after each plan completion*
| Phase 01-source-dive-godot-minimal-theme-tres-dissection P01 | 10min | 3 tasks | 1 files |
| Phase 01-source-dive-godot-minimal-theme-tres-dissection P02 | 16min | 8 tasks | 1 files |
| Phase 03 P01 | 55min | 5 tasks | 6 files |
| Phase 03 P02 | 70min | 5 tasks | 16 files |

## Accumulated Context

### Decisions

Decisions are logged in PROJECT.md Key Decisions table.
Recent decisions affecting current work:

- Project init (2026-05-04): Mobile variant elevated to v1 must-have alongside desktop primary; cross-platform support across all 6 Godot export targets locked as v1 must-have.
- Research synthesis (2026-05-04): SUMMARY.md Conflict 1 revised — ship Outfit Variable in v1 as display/marquee font; defer Inter Italic to v1.x; net bundle smaller (~1.85 MB) and more on-brand.
- Research synthesis (2026-05-04): SUMMARY.md Conflict 2 — adopt M3 5-stop tonal surface ramp as canonical with friendlier aliases (base/secondary/panel/raised/overlay); reject `surface.sunken` for v1.
- Research synthesis (2026-05-04): SUMMARY.md Conflict 3 — no drop shadows in v1 (GL Compat over-renders shadow alpha per Godot #23640); elevation conveyed via tonal surface ramp only; `shadow_size = -1` on every StyleBoxFlat.
- Roadmap (2026-05-04): 11-phase structure adopted from SUMMARY.md verbatim; mockup approval gate is hard blocker between Phase 3 and Phase 4; token-sharing strategy is `@tool` script generator (not `.tres` inheritance).
- [Phase ?]: Phase 1 Plan 01 (2026-05-04): Dissection skeleton MINIMAL-THEME-DISSECTION.md committed with SHA-256-pinned provenance, verbatim helper bodies, and runtime-validated line citations — Plans 02/03 unblocked.
- [Phase ?]: Phase 1 Plan 02 (2026-05-04): Per-Control enumeration appended to MINIMAL-THEME-DISSECTION.md — 80-token Active Verification Audit + 25 user-facing class sections + 3 NeoCade-additive sections (MenuBar/Panel/Window) + 1 combined container-chrome section + Pitfall 1.7 evidence anchor; 225 enumeration rows total; D-08 reconciliation surfaces 3 user-facing classes upstream does not theme.
- Phase 2 verification (2026-05-04): LDtk source mining passed UAT with 5/5 checks, 0 issues; LDtk coverage is HIGH for v1 UI-theme research, with source outputs explicitly non-binding inspiration for Phase 3 mockups.
- **Phase 3 REDIRECTED (2026-05-04):** User rejected the painterly arcade-venue direction at Plan 03-03 finalist-selection checkpoint. **Boardwalk Sunset (the original recommended baseline) is rejected.** New direction: **flat MD3 / MD3 Expressive visual identity, no textures / no patterns / no embossing / no gradients on chrome.** Optional "extruded flat 3D" raised variation per the Flat-3D Game UI pattern (per user's itch.io references). Each theme delivers 4 `.tres` variations: flat-desktop, flat-mobile, raised-desktop, raised-mobile. Architecture supports undefined number of themes. Phase 3 outputs (mood-board, 5 concept images, direction boards) preserved as v0 historical reference. Replaced by Phase 3.1 (research spike) + Phase 3.2 (revised mockup phase).

### Pending Todos

[From .planning/todos/pending/ — ideas captured during sessions]

None yet.

### Blockers/Concerns

[Issues that affect future work]

- **UD-5 (real-device cross-platform testing matrix):** User hardware/account status for Android devices + Mac + Apple Developer Program is unknown. Decision needed before Phase 10 plan is authored: confirm available test surfaces, identify gaps, decide whether v1 ships with full mobile coverage or with "verified on Windows/macOS/Linux/Web; mobile-targets pending real-device QA in v1.0.1."
- **UD-1 (MCP server swap):** Current Coding-Solo `godot-mcp` lacks screenshot capture; QA phases require it. Recommended swap to GoPeak (`npx gopeak`) addressed in Phase 3 sub-spike but should be confirmed before Phase 3 starts.

## Deferred Items

Items acknowledged and carried forward from previous milestone close:

| Category | Item | Status | Deferred At |
|----------|------|--------|-------------|
| Typography | Inter Italic Variable bundling | Deferred to v1.x (Conflict 1 revision; synthetic italic transform used in v1) | 2026-05-04 |
| Fonts | CJK Noto Sans bundling (~30 MB) | Deferred to v2 / opt-in (UD-2 default; README documents override) | 2026-05-04 |
| Color modes | Light color mode (desktop + mobile) | Deferred to v2 | Project init |
| Palettes | Alternate palette variants (magenta, amber) | Deferred to v2 | Project init |
| Editor | Editor-only theme types (FlatButton, MainScreenButton, etc.) | Deferred to v1.x | Project init |
| Accessibility | Deeper VoiceOver/TalkBack/AccessKit screen-reader QA | Deferred to v1.x (UD-6; `accessibility_name` only in v1) | 2026-05-04 |
| QA | Real-device Android + iOS validation | Conditional on UD-5 resolution; v1 may ship with "deferred to v1.0.1" note | 2026-05-04 |

## Session Continuity

Last session: 2026-05-04T19:00:00.000Z
Stopped at: Phase 3 REDIRECTED — Phase 3.1 + 3.2 inserted; awaiting `/gsd-discuss-phase 3.1`
Resume file: .planning/ROADMAP.md (see Phase 3.1 + 3.2 entries)

## Phase 3 → 3.1/3.2 Redirect Notes (2026-05-04)

**What was preserved (do not delete):**
- `.planning/phases/03-visual-direction-mockup-approval-gate/` — full Phase 3 v0 work (CONTEXT.md, RESEARCH.md, REVIEWS.md, 5 PLAN files, SUMMARY.md for completed plans)
- `.planning/mockups/concepts/*.png` + `*-prompt.md` — 5 concept images + prompt files
- `.planning/mockups/03-direction-boards.html/.md/.png` — direction-board comparison gallery
- `.planning/mockups/03-direction-boards-check.md` — render-check report
- `.planning/research/mood-board/` — 25 mood-board references with INDEX.md + references.json

**Why preserved:** User explicitly requested historical retention so any v0 direction can be revisited later (e.g., re-rendered through the flat-MD3 filter in a future v1.x or v2 milestone). The five concept images alone took ~5-10 minutes per generation; reproducing them later would cost time.

**What's stopped (do not advance):**
- Plans 03-03, 03-04, 03-05 are obsolete in their current form — Phase 3 will not be re-executed.
- The finalist-selection checkpoint from Plan 03-03 is **NOT** to be answered; it's been routed around by this redirect.

**What's next:**
1. `/gsd-discuss-phase 3.1` — gather context for the MD3 / MD3 Expressive / Flat-3D Game UI research spike
2. `/gsd-plan-review-convergence 3.1 --opencode` — plan + cross-AI review
3. `/gsd-execute-phase 3.1` — execute research
4. `/gsd-verify-work 3.1` → `/clear` → `/gsd-discuss-phase 3.2`
5. Phase 3.2 mockup phase replaces the redirected Phase 3
