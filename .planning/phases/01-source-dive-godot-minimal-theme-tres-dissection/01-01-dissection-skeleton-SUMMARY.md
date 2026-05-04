---
phase: 01-source-dive-godot-minimal-theme-tres-dissection
plan: 01
subsystem: research
tags: [godot, theme, minimal-theme, dissection, provenance, editor-api, gdscript, surface-ramp]

# Dependency graph
requires:
  - phase: pre-phase-1 (research synthesis + 01-CONTEXT.md + 01-RESEARCH.md)
    provides: locked decisions D-01..D-15, glossary, methodology, 80-class enumeration prep
provides:
  - .planning/research/MINIMAL-THEME-DISSECTION.md (created — skeleton with provenance, methodology, glossary, Editor-API touchpoints, Globals, Helper Functions, plus reserved Per-Control Enumeration and Engine-Default Cross-Reference placeholder headings)
  - SHA-256-pinned provenance block as the reproducibility anchor for every downstream Phase 1 plan
  - Verbatim helper-function bodies (_get_base_color, _set_margin, _set_border) so per-class enumerations cite by name
  - Line-citation runtime validation stamp confirming the 12 forbidden-API touchpoint line numbers (15, 18, 20, 21, 24, 26, 28, 30, 32, 34, 36, 56) match the live snapshot
affects:
  - 01-02 (per-class enumeration — appends under "## Per-Control Enumeration"; cites globals/helpers by name)
  - 01-03 (engine-default cross-reference + Pitfall confirmations — appends under "## Engine-Default Cross-Reference and Pitfall Confirmations")
  - 01-04 (coverage-delta — references the Globals/helpers section for shared vocabulary)
  - 01-05 (SOURCES.md update — links into this doc)
  - phase-04 (token generator — must drop EDSCALE `* scale` factors flagged here per D-05)

# Tech tracking
tech-stack:
  added: [] # research-only, no new tooling installed
  patterns:
    - "Symbolic formula extraction (D-04 + RESEARCH.md Pattern 1) — per-class tables cite globals/helpers by name rather than expanding formulas inline"
    - "SHA-256 + line-count + first-line provenance triple — reproducibility anchor pattern for any future re-extraction (replaces commit SHA when source is a ZIP download)"
    - "Editor-API touchpoint enumeration as a top-of-document callout — establishes the D-05 forbidden boundary at the highest visible point, before any per-class data is laid down"
    - "Runtime line-citation validation stamp pattern — sed -n 'Np' spot-check loop produces a greppable verification artifact that downstream plans can rely on without re-grepping"

key-files:
  created:
    - .planning/research/MINIMAL-THEME-DISSECTION.md
  modified: []

key-decisions:
  - "Provenance triple (SHA-256 102fd6b3..a73f2e + 1118 lines + 48,442 bytes) live-verified against the snapshot at C:\\Programming_Files\\Godot\\godot-minimal-theme-main\\minimal_theme.tres before any other writes — not assumed from plan values"
  - "Helper-function bodies pasted verbatim from `sed -n '1096,1103p' / '1104,1110p' / '1111,1118p'` rather than paraphrased — preserves the EDSCALE `* scale` multiplications so downstream Phase 4 reimplementation can spot every NeoCade-forbidden site"
  - "_set_border body included the trailing `\"`, blank line, and `[resource]` token from line 1118 (closing of the GDScript sub-resource string + start of Theme [resource] block) — kept intact in the doc with an explanatory note rather than truncated, to surface provenance honestly"
  - "Globals 'scale' row carries an explicit `FORBIDDEN in NeoCade per D-05` callout at the cell level (per cross-AI review 2026-05-04) so no downstream reader mistakes EDSCALE-derived values for NeoCade-usable constants"
  - "Per-task commits made for the 2 file-write tasks (Task 2 = skeleton creation, Task 3 = line-citation stamp); Task 1 was verification-only with no file writes and produced no commit, per plan spec `<files>(no files written this task — verification step)</files>`"

patterns-established:
  - "Pattern: Provenance block at top of every research artifact — snapshot path + file size + first line + line count + ISO date + SHA-256 + source repo + license + acquisition note (ZIP vs git). Future research-doc artifacts should copy this layout."
  - "Pattern: 'Editor-API Touchpoints (Forbidden in NeoCade per D-05)' callout positioned ABOVE per-class enumeration — sets the runtime-first reuse boundary at the most visible point of the doc."
  - "Pattern: Line-citation runtime validation — for any document that hardcodes line numbers into a third-party file, append a `> Line-citation runtime validation` stamp citing the lines verified, the date, and the verifier mechanism (`sed -n 'Np'`). Greppable, dated, makes drift detectable on re-run."
  - "Pattern: Reserved placeholder headings for downstream-plan appends — Per-Control Enumeration and Engine-Default Cross-Reference headings already in place so Plans 02/03 can append-only without needing to re-organize the file."

requirements-completed:
  - RES-01

# Metrics
duration: ~10min
completed: 2026-05-04
---

# Phase 1 Plan 1: Dissection Skeleton Summary

**MINIMAL-THEME-DISSECTION.md created with SHA-256-pinned provenance, verbatim helper-function bodies, 13-row Editor-API forbidden-touchpoint table, 7-stop surface ramp + named font/icon color globals, and a runtime-validated line-citation stamp — establishing the shared vocabulary every per-class enumeration in plans 02-03 will reference**

## Performance

- **Duration:** ~10 min
- **Started:** 2026-05-04T17:58:30Z (per STATE.md `last_updated`)
- **Completed:** 2026-05-04T18:02:37Z
- **Tasks:** 3 executed (Task 1 verification-only, Tasks 2-3 produced file writes)
- **Files modified:** 1 created (`.planning/research/MINIMAL-THEME-DISSECTION.md`)

## Accomplishments

- **Provenance live-verified before any writes.** All four provenance values (SHA-256 `102fd6b3..a73f2e`, 1118 lines, 48,442 bytes, first line `[gd_resource type="Theme" load_steps=2 format=3 uid="uid://bcibt73qths3g"]`) confirmed byte-identical against the live snapshot via `sha256sum` / `wc -l` / `wc -c` / `head -1`. Snapshot is unchanged since plan was authored.
- **DISSECTION.md skeleton complete with all required sections in correct order** — Provenance (line 7) → Methodology (line 21) → Editor-API Touchpoints (line 40) → Globals (line 66) → Helper Functions (line 123) → reserved Per-Control Enumeration (line 189) → reserved Engine-Default Cross-Reference (line 193). Total: 195 lines, 14,306 bytes.
- **All 13 helper-function-related forbidden-API touchpoints catalogued** with line citations and per-row NeoCade substitute notes (Phase 3 / Phase 4 / Phase 8 mappings).
- **All three helper functions documented verbatim** — `_get_base_color` (lines 1096-1103, the function powering the 7-stop tonal ramp), `_set_margin` (lines 1104-1110, EDSCALE-multiplied content_margin setter), `_set_border` (lines 1111-1118, EDSCALE-multiplied border setter). Each annotated with a NeoCade reimplementation note ("drop the `* scale` factor for NeoCade-token use").
- **Globals dictionary fully populated** — base_spacing/base_margin/extra_spacing/increased_margin/popup_margin/scale, dark_theme/dark_theme_icon_and_font, color_mono/color_mono_inv/color_mono_font, the 7-stop surface ramp (lowest/lower/low/base/high/higher/highest), and 8 font/icon named colors. Every entry carries its line citation into the source file.
- **D-05 callout reinforced at the cell level** — the `scale` row in the Margins/spacing table contains the literal string `FORBIDDEN in NeoCade per D-05` so cross-AI-review HIGH #1 is closed.
- **Line-citation runtime validation stamp appended** — all 12 cited forbidden-API line numbers (15, 18, 20, 21, 24, 26, 28, 30, 32, 34, 36, 56) spot-checked via `sed -n 'Np'` against the live snapshot; verification stamp greppable as `Line-citation runtime validation` and `All 12 cited lines`. Closes cross-AI-review HIGH #2.
- **All 13 Task-2 grep acceptance checks pass; all 8 Task-3 verify checks pass.** No stub patterns (`TODO`/`FIXME`/`executor extracts at runtime`) remain in the doc.

## Task Commits

Each task was committed atomically (Task 1 was verification-only per plan spec, no commit produced):

1. **Task 1: Verify provenance values match the live file** — _no commit_ (`<files>(no files written this task — verification step)</files>` per plan)
2. **Task 2: Create MINIMAL-THEME-DISSECTION.md with header, provenance, glossary, and section skeleton** — `fd46354` (docs)
3. **Task 3: Runtime line-citation grep validation + verification stamp** — `55f73de` (docs)

**Plan metadata commit:** to be made by the executor's final commit step (includes this SUMMARY.md, STATE.md orchestrator update, and ROADMAP.md progress update).

## Files Created/Modified

- `.planning/research/MINIMAL-THEME-DISSECTION.md` (created, 195 lines, 14,306 bytes) — Phase 1 dissection skeleton: provenance + methodology + glossary + Editor-API touchpoints + Globals + Helper Functions + reserved heading anchors for plans 02-03 to append.

## Decisions Made

- **Helper bodies extracted via `sed -n` and pasted verbatim, not paraphrased.** The plan's `<interfaces>` block left them as runtime-extraction placeholders ("executor extracts at runtime via `sed -n '1096,1103p'` and pastes verbatim"). I ran the three sed commands and pasted each output as-is inside fenced GDScript code blocks, preserving the trailing comment lines (`# Shorthand content margin setter`, `# Shorthand border setter`) and the `_set_border` block's tail (the closing `"`, blank line, and `[resource]` from line 1118). The tail is annotated in-doc as "the closing of the GDScript sub-resource string literal and the start of the Theme `[resource]` block at line 1118 — NOT part of `_set_border`."
- **Task 1 was verification-only and produced no commit** (per plan spec `<files>(no files written this task — verification step)</files>`). The SHA / line-count / byte-count / first-line outputs are recorded in this SUMMARY's Accomplishments rather than as a commit message.
- **STATE.md modification (made by orchestrator at execution-start time, before this agent spawned) was deliberately deferred** to the executor's final metadata commit step — kept out of Tasks 2 & 3 commits to preserve clean per-task atomicity.
- **No content beyond the plan's `<action>` block was added.** I considered adding cross-references into ARCHITECTURE.md / PITFALLS.md within the Globals section, but the plan reserves cross-AI-synthesized analysis to Plan 05 (SOURCES.md update). Skeleton stays purely descriptive per D-15.

## Deviations from Plan

None - plan executed exactly as written.

(The plan's `<interfaces>` block sketched line 26 as `maxi(settings.get_setting('interface/theme/base_spacing'), 2)` — the live file actually reads `base_spacing` directly on line 26 and applies `maxi(base_spacing, 2)` later on line 48. I honored the plan's exact-text Globals table verbatim because the SHA-pinned grep acceptance criteria require byte-exact strings; line 48 is an internal-to-script clamp, not a setting read, so the table's `26, 48` line citation correctly captures both. No table cell was altered.)

## Issues Encountered

None. All three tasks completed first-attempt with all acceptance criteria passing.

## User Setup Required

None — research-only phase, no external service configuration.

## Next Phase Readiness

- **Plan 02 (per-class enumeration) is unblocked.** It can append under the `## Per-Control Enumeration` heading at line 189 without re-organizing the file. It must cite globals/helpers by name (e.g., `color_surface_base`, `color_font_normal`, `_set_margin(sb, 4, 4)`) per the dictionary in this doc.
- **Plan 03 (engine-default cross-reference + Pitfall 1.1/1.7 confirmations) is unblocked.** It can append under the `## Engine-Default Cross-Reference and Pitfall Confirmations` heading at line 193. It must cross-read Plan 02's per-Control slot tables.
- **Plan 04 (coverage delta) is unblocked at the read-dependency layer** (it does not append into this file; it consumes the Globals + Editor-API sections as shared vocabulary).
- **Phase 4 token generator (downstream consumer)** has a clear D-05 forbidden-API enumeration to guard its `@tool` design — the 13-row table is the canonical "do not replicate these patterns" reference.
- **No blockers.** Wave 1 (Plan 02) can begin immediately; Wave 0 closure is clean.

## Self-Check: PASSED

**Files claimed created:**
- `.planning/research/MINIMAL-THEME-DISSECTION.md` — FOUND (195 lines, 14,306 bytes; section ordering verified via `grep -nE '^## '`)

**Commits claimed:**
- `fd46354` (Task 2: skeleton creation) — FOUND in `git log --oneline`
- `55f73de` (Task 3: line-citation stamp) — FOUND in `git log --oneline`

**Acceptance criteria:**
- 13 / 13 Task-2 grep checks pass
- 8 / 8 Task-3 verify checks pass
- 0 / 0 stub patterns remaining in DISSECTION.md
- 0 commits to `addons/neocade_theme/` (Phase 1 is research-only — verified via `git log --oneline 11c4043..HEAD -- addons/neocade_theme/`)

---
*Phase: 01-source-dive-godot-minimal-theme-tres-dissection*
*Completed: 2026-05-04*
