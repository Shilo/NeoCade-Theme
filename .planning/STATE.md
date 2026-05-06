---
gsd_state_version: 1.0
milestone: v1.0.0
milestone_name: milestone
status: executing
stopped_at: Phase 3.3 context gathered
last_updated: "2026-05-06T05:56:11.467Z"
last_activity: 2026-05-06 -- Phase 03.3 planning complete
progress:
  total_phases: 15
  completed_phases: 4
  total_plans: 30
  completed_plans: 24
  percent: 80
---

# Project State

## Project Reference

See: .planning/PROJECT.md (updated 2026-05-06)

**Core value:** A drop-in Godot 4.6 **flat MD3 / MD3 Expressive** Theme system at `res://addons/neocade_theme/` that ships **N approved theme subclass `.tres` files** (one per theme) extending a dynamic `NeoCadeTheme` superclass. Consumer toggles `raised` / `platform` / `base_color` / `accent_color` exports for flat/raised × desktop/mobile/AUTO variations — every built-in Control themed to a `godot-minimal-theme` bar of feature-completeness, accessible (WCAG 2.1 AA), universal across editor + runtime + all 6 Godot export targets. **No textures / no patterns / no embossing / no painterly chrome** (locked 2026-05-04 redirect). **Dynamic-theme architecture** locked 2026-05-04 architecture revision and feasibility-validated 2026-05-06 (Phase 3.2 strict gate 6/6 PASS in Godot 4.6.2): `NeoCadeTheme` superclass (`@tool extends Theme`) regenerates entries from `@export` props; per-theme subclasses contribute personality via super-first `_regenerate()`.
**Current focus:** Phase 03.3 — theme-direction-research

## Current Position

Phase: 03.3
Plan: Not started
Next: /gsd-plan-review-convergence 3.3 --opencode --claude
Status: Ready to execute
Last activity: 2026-05-06 -- Phase 03.3 planning complete

Progress: [██████████████████░░] 24/27 plans (89%)

## Performance Metrics

**Velocity:**

- Total plans completed: 24
- Average duration: —
- Total execution time: 0 hours

**By Phase:**

| Phase | Plans | Total | Avg/Plan |
|-------|-------|-------|----------|
| — | — | — | — |
| 1 | 5 | - | - |
| 02 | 5 | - | - |
| 03.1 | 6 | - | - |
| 03.2 | 6 | - | - |

**Recent Trend:**

- Last 5 plans: —
- Trend: —

*Updated after each plan completion*
| Phase 01-source-dive-godot-minimal-theme-tres-dissection P01 | 10min | 3 tasks | 1 files |
| Phase 01-source-dive-godot-minimal-theme-tres-dissection P02 | 16min | 8 tasks | 1 files |
| Phase 03 P01 | 55min | 5 tasks | 6 files |
| Phase 03 P02 | 70min | 5 tasks | 16 files |
| Phase 03.1 P01 | 12 min | 2 tasks | 3 files |
| Phase 03.1 P02 | 32 min | 3 tasks | 2 files |
| Phase 03.1 P03 | 24 min | 3 tasks | 2 files |
| Phase 03.1 P04 | 28 min | 3 tasks | 2 files |
| Phase 03.1 P05 | 25 min | 3 tasks | 2 files |
| Phase 03.1 P06 | 18 min | 3 tasks | 4 files |

## Accumulated Context

### Decisions

Decisions are logged in PROJECT.md Key Decisions table.
Recent decisions affecting current work:

- Project init (2026-05-04): Mobile variant elevated to v1 must-have alongside desktop primary; cross-platform support across all 6 Godot export targets locked as v1 must-have.
- ~~Research synthesis (2026-05-04): SUMMARY.md Conflict 1 revised — ship Outfit Variable in v1 as display/marquee font; defer Inter Italic to v1.x; net bundle smaller (~1.85 MB) and more on-brand.~~ **SUPERSEDED 2026-05-04 by UD-4 Option D:** Inter Variable Roman ONLY in v1; Outfit + Noto Sans + JetBrains Mono all deferred (~810 KB bundle). See FONT-REVIEW.md.
- Research synthesis (2026-05-04): SUMMARY.md Conflict 2 — adopt M3 5-stop tonal surface ramp as canonical with friendlier aliases (base/secondary/panel/raised/overlay); reject `surface.sunken` for v1.
- Research synthesis (2026-05-04): SUMMARY.md Conflict 3 — no drop shadows in v1 (GL Compat over-renders shadow alpha per Godot #23640); elevation conveyed via tonal surface ramp only; `shadow_size = -1` on every StyleBoxFlat.
- ~~Roadmap (2026-05-04): 11-phase structure adopted from SUMMARY.md verbatim; mockup approval gate is hard blocker between Phase 3 and Phase 4; token-sharing strategy is `@tool` script generator (not `.tres` inheritance).~~ **SUPERSEDED 2026-05-04 by Phase 3 redirect + architecture revision:** 15-phase structure (Phase 3 REDIRECTED, 3.1/3.2/3.3/3.4 inserted); mockup approval gate is between Phase 3.4 and Phase 4; token-sharing strategy is `NeoCadeTheme` superclass + per-theme subclasses (effective `.tres` inheritance via GDScript `class_name extends NeoCadeTheme`), NOT a TokenSet generator script.
- [Phase ?]: Phase 1 Plan 01 (2026-05-04): Dissection skeleton MINIMAL-THEME-DISSECTION.md committed with SHA-256-pinned provenance, verbatim helper bodies, and runtime-validated line citations — Plans 02/03 unblocked.
- [Phase ?]: Phase 1 Plan 02 (2026-05-04): Per-Control enumeration appended to MINIMAL-THEME-DISSECTION.md — 80-token Active Verification Audit + 25 user-facing class sections + 3 NeoCade-additive sections (MenuBar/Panel/Window) + 1 combined container-chrome section + Pitfall 1.7 evidence anchor; 225 enumeration rows total; D-08 reconciliation surfaces 3 user-facing classes upstream does not theme.
- Phase 2 verification (2026-05-04): LDtk source mining passed UAT with 5/5 checks, 0 issues; LDtk coverage is HIGH for v1 UI-theme research, with source outputs explicitly non-binding inspiration for Phase 3 mockups.
- **Phase 3 REDIRECTED (2026-05-04):** User rejected the painterly arcade-venue direction at Plan 03-03 finalist-selection checkpoint. **Boardwalk Sunset (the original recommended baseline) is rejected.** New direction: **flat MD3 / MD3 Expressive visual identity, no textures / no patterns / no embossing / no gradients on chrome.** Optional "extruded flat 3D" raised variation per the Flat-3D Game UI pattern (per user's itch.io references). Phase 3 outputs (mood-board, 5 concept images, direction boards) preserved as v0 historical reference. Replaced by Phase 3.1 (MD3 visual research) + Phase 3.3 (revised mockup phase).
- **Architecture revision (2026-05-04):** Replaced "4 static `.tres` per theme generated from TokenSet matrix" with **dynamic `NeoCadeTheme` superclass + per-theme subclasses**. Superclass is `@tool extends Theme` with `@export` props (`base_color`, `accent_color`, `raised: bool`, `platform: {DESKTOP, MOBILE, AUTO}`). Setters dynamically regenerate theme entries via `_get_base_color`-style formulas ported from passivestar's editor theme (driven by exports, not `EditorSettings`). Per-theme subclasses contribute personality (corner radii, outlines, color tint formula parameters). **One `.tres` per theme** (consumer toggles exports for variations). `platform=AUTO` auto-detects via `OS.has_feature("mobile")` at runtime; `DESKTOP` and `MOBILE` are forced sizes. **NEW Phase 3.2 inserted** between Phase 3.1 (visual research) and what was Phase 3.2 (mockup phase, now renumbered 3.4): Godot Dynamic Theme Architecture Research with feasibility validation as primary deliverable.
- **Theme-direction phase insertion (2026-05-04):** **NEW Phase 3.3 inserted** to address gap — original phases 3.1/3.2/3.3 covered design language + architecture + mockups, but NO phase explicitly researched/derived theme directions. Phase 3.3 (Theme Direction Research) derives 5 candidate directions using user's new goals/restrictions + per-v0-direction reactions as DNA + Phase 3.1 findings + commercial flat-MD3 example survey. **Direction names: keep / revise / replace per fit** (not a hard "must be new" rule — only Boardwalk Sunset is rejected entirely). Universal anti-texture / flat-MD3 revisions apply to ALL 5 directions regardless of name retention. Outputs `.planning/research/THEME-DIRECTIONS.md` with text-level user-approval checkpoint before Phase 3.4 mockups. **Phase 3.4 (was 3.3) updated:** concept boards now show BOTH flat AND raised per direction (10 boards: 5 directions × 2 variations) so user picks finalists having seen both variations. **Base-direction designation:** at the Phase 3.4 approval gate, user picks ONE of the N approved directions to be the `NeoCadeTheme` base (its values become superclass defaults; consumer instantiating `NeoCadeTheme` directly gets that style). Remaining approved directions are personality subclasses with `super._regenerate()` + delta overrides. **Critical Godot Theme override mechanic** (Phase 3.2 must validate): Theme resources don't auto-inherit at the resource level — subclass `_regenerate()` MUST call `super._regenerate()` first to populate base entries before overriding specifics, otherwise non-overridden Controls render unthemed at runtime.

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

Last session: 2026-05-06T05:46:30.615Z
Stopped at: Phase 3.3 context gathered
Resume file: .planning/phases/03.3-theme-direction-research/03.3-CONTEXT.md

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
Phase 3.1 (MD3 visual research) and Phase 3.2 (Godot dynamic theme architecture research with feasibility spike) are **parallel-eligible** — different research domains, no shared deliverables. Phase 3.3 (theme direction research) depends on Phase 3.1 (uses MD3 findings as design vocabulary). Phase 3.4 (mockup gate) depends on all three.

Recommended sequence (sequential, simpler):

1. `/gsd-discuss-phase 3.1` → `/gsd-plan-review-convergence 3.1 --opencode` → `/gsd-execute-phase 3.1` → `/gsd-verify-work 3.1`
2. `/clear` → `/gsd-discuss-phase 3.2` → `/gsd-plan-review-convergence 3.2 --opencode` → `/gsd-execute-phase 3.2` → `/gsd-verify-work 3.2`
3. `/clear` → `/gsd-discuss-phase 3.3` → `/gsd-plan-review-convergence 3.3 --opencode --claude` → `/gsd-execute-phase 3.3` → text-level user-approval of 5 candidate directions → `/gsd-verify-work 3.3`
4. `/clear` → `/gsd-discuss-phase 3.4` → `/gsd-plan-review-convergence 3.4 --opencode` → `/gsd-execute-phase 3.4` → user-approval of N final mockups → `/gsd-verify-work 3.4`
5. Phase 3.4 mockup gate replaces the redirected Phase 3 gate; Phase 4 starts after approval

Alternative parallel sequence (faster but more state to juggle):

1. Run Phase 3.1 and Phase 3.2 in parallel sessions (each on its own branch ideally)
2. Both complete → merge → Phase 3.3 begins with both research outputs available
3. Phase 3.4 begins after Phase 3.3 closes
