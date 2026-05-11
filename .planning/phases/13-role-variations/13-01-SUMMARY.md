---
phase: 13
plan: 01
subsystem: phase-13-role-variations
tags: [godot, theme, verifier, nyquist, wave-0, helpers]
requirements: [SC-13-1, SC-13-2, SC-13-3]
dependency_graph:
  requires:
    - .planning/phases/12-signature-visual-moves/helpers/_phase12_verify_headless.gd (analog source)
    - .planning/phases/12-signature-visual-moves/helpers/_phase12_smoke_matrix.gd (analog source)
    - .planning/phases/12-signature-visual-moves/helpers/_phase12_thumbnail_render_runtime.gd (analog source)
    - addons/neocade_theme/neocade_theme.tres (loaded by verifier at runtime)
    - addons/neocade_theme/scripts/neocade_theme.gd (NeoCadeTheme class, BINDING_TABLE, TYPE_VARIATIONS)
    - showcase/showcase.tscn (loaded by `role-variations-in-showcase` stage + Pitfall-1 render helper)
  provides:
    - Headless verifier with 6 stages pinning Phase 13 invariants (BT=149, TV=56, 12 exports, 9 new variations registered/in-showcase/font-explicit)
    - 30-config smoke matrix invariant runner (Phase 12 curated set + 9 Phase 13 invariants per config)
    - Pitfall-1 contingency render helper (Control-rooted, full-color full-res PNG capture; NOT auto-run)
  affects:
    - .planning/phases/13-role-variations/helpers/ (new directory, 4 files)
tech-stack:
  added: []
  patterns:
    - "Phase 12 SceneTree-extending headless verifier pattern with `--stage <name>` CLI arg (per 13-PATTERNS.md file #6)"
    - "Phase 12 30-config curated smoke matrix (5 groups: 10 + 5 + 6 + 5 + 4 = 30) — copied verbatim, augmented with Phase 13 invariant block (per 13-PATTERNS.md file #7)"
    - "Phase 12 Control-rooted runtime render with 4-step await chain (per 13-PATTERNS.md file #8)"
    - "WR-01/WR-02 OK-print gate (every stage's success print wrapped in `if _failures.is_empty():`) — Phase 12 invariant"
    - "PHASE13_* marker prefixes for CI grep (PHASE13_VERIFY, PHASE13_SMOKE, PHASE13_ROLE_RENDER)"
key-files:
  created:
    - path: .planning/phases/13-role-variations/helpers/_phase13_verify_headless.gd
      purpose: "Headless SceneTree verifier with 6 stages (architecture / role-variations-registered / role-variations-in-showcase / default-chrome-unchanged / role-label-fonts / full). Pins BT=149, TV=56, 12 exports."
      lines: 279
    - path: .planning/phases/13-role-variations/helpers/_phase13_smoke_matrix.gd
      purpose: "30-config invariant runner (Phase 12 curated 30 + 9 Phase 13 per-config invariants: 4 font_colors + 5 panel styleboxes)."
      lines: 134
    - path: .planning/phases/13-role-variations/helpers/_phase13_role_render.gd
      purpose: "Pitfall-1 contingency render helper. Control-rooted runtime script renders Pulse+raised showcase to full-color full-res PNG. NOT auto-run."
      lines: 80
    - path: .planning/phases/13-role-variations/helpers/_phase13_role_render.tscn
      purpose: "Sibling main scene for the Control-rooted Pitfall-1 render helper."
      lines: 9
  modified: []
decisions:
  - "Wave-0 RED state is the documented expected outcome until Wave 2 (per 13-RESEARCH.md lines 416-423); verifier --stage architecture WILL fail against current production (BT=140/TV=47) and this is correct behavior — not a bug."
  - "Pitfall-1 render helper is built but NOT invoked by Plan 13-04's verifier suite — it is the documented Pitfall 1 contingency fallback path (per 13-RESEARCH.md lines 300-314). Invoke only if visual inspection shows a 0.06-alpha halo on Role Panels under GL Compatibility."
  - "Sibling .tscn scene authored for the Control-rooted render helper (Phase 12 runtime pattern requires a main scene because Control-rooted scripts cannot be invoked via `--script` alone)."
  - "Acceptance criteria literal-token gate (no `adjust_bcs`, no `img.resize(`) tripped on a documentary comment in the render helper; comment reworded to satisfy the literal acceptance check while preserving the intent."
metrics:
  duration: ~3 minutes
  completed: 2026-05-11
  tasks: 3
  files: 4
  commits: 3
---

# Phase 13 Plan 01: Wave-0 Verifier Helpers Summary

**One-liner:** Wave-0 Nyquist gate landed — 3 Phase 12-derived verifier helpers (architecture/scene-walk verifier, 30-config smoke matrix, Pitfall-1 contingency render) plus a Control-rooted scene pair, all pinning BT=149/TV=56 and the 9 new Phase 13 role variations. Helpers are intentionally RED until Wave 1/2 land production additions.

## Objective Recap

Establish the automated verification surface for Phase 13 BEFORE any production edit lands. Mirror the Phase 12 helper precedent verbatim, swapping marker prefixes (`PHASE12_*` → `PHASE13_*`) and constants (BT 140→149, TV 47→56) and adding stages/invariants for the 9 new role variations (4 Role Labels + 5 Role Panels).

## What Was Built

### 1. `.planning/phases/13-role-variations/helpers/_phase13_verify_headless.gd` (279 lines)

Headless verifier extending `SceneTree`. CLI invocation:
```
godot --headless --quit --script "<path>" -- --stage <stage>
```

**Six stages registered:**

| Stage | Asserts |
|-------|---------|
| `architecture` | canonical .tres loads as NeoCadeTheme; `BINDING_TABLE.size() == 149`; `TYPE_VARIATIONS.size() == 56`; `@export count == 12`; Button.normal + PanelContainer.panel styleboxes produced |
| `role-variations-registered` | 9 new keys exist in TYPE_VARIATIONS with correct base types (4 Labels → "Label", 5 Panels → "PanelContainer"); `theme.has_color("font_color", v)` for each Role Label; `theme.has_stylebox("panel", v)` for each Role Panel |
| `role-variations-in-showcase` | Loads `res://showcase/showcase.tscn`, walks all descendant Controls, collects every `theme_type_variation` value; asserts every one of the 9 expected variation names is present |
| `default-chrome-unchanged` | For each `NeoCadeTheme.selectable_styles()` value: `theme.get_color("font_color", "Label")` does NOT match role_success/role_warning/role_danger/role_info/accent_color; `theme.get_stylebox("panel", "PanelContainer").bg_color.a` is NOT translucent (in [0.05, 0.99]) |
| `role-label-fonts` | For each of the 4 Role Labels: `theme.has_font("font", v)` and `theme.has_font_size("font_size", v)` are true, and `font_size > 0` (Pitfall 1.2 / Pitfall 6 invariant) |
| `full` | runs all 5 stages in sequence |

**Invariants:**
- `EXPECTED_BINDING_TABLE_ROWS = 149` (Phase 12 baseline 140 + 9 Phase 13 additions)
- `EXPECTED_TYPE_VARIATIONS_COUNT = 56` (Phase 12 baseline 47 + 9 Phase 13 additions)
- `EXPECTED_EXPORT_COUNT = 12`
- Marker prefix: `PHASE13_VERIFY:` (never `PHASE12_VERIFY:` in non-comment lines)
- **WR-01/WR-02 OK-print gate: 5/5 stage OK-prints wrapped in `if _failures.is_empty():`** (verified mechanically before commit)
- `_fresh_theme()`, `_count_top_level_exports()`, `_parse_args()`, `_fail()`, `_emit_and_quit()` ported verbatim from Phase 12 with marker prefix swaps.

### 2. `.planning/phases/13-role-variations/helpers/_phase13_smoke_matrix.gd` (134 lines)

Direct port of `_phase12_smoke_matrix.gd`. CLI invocation:
```
godot --headless --quit --script "<path>"
```

**Curated 30-config set preserved verbatim** (5 groups: 10 + 5 + 6 + 5 + 4 = 30):
- Group 1: 5 styles × 2 raised × DESKTOP × defaults
- Group 2: 5 styles × raised=true × MOBILE × defaults
- Group 3: CUSTOM × 2 raised × 3 platforms × defaults
- Group 4: 5 styles × raised=true × AUTO × custom base/accent
- Group 5: 4 CUSTOM edge cases (very dark / very light / low contrast / accent over WCAG floor)

**Per-config invariants (Phase 12 baseline + Phase 13 additions):**
- Phase 12 baseline: `has_stylebox("normal", "Button")`, `BINDING_TABLE.size() == 149`, `TYPE_VARIATIONS.size() == 56`, `@export count == 12`
- Phase 13 NEW: `has_color("font_color", v)` for each of 4 Role Labels; `has_stylebox("panel", v)` for each of 5 Role Panels

**Invariants:**
- `assert(configs.size() == 30, ...)` preserved verbatim from Phase 12
- Marker prefix: `PHASE13_SMOKE:`
- `_label()` and `_count_top_level_exports()` helpers ported verbatim from Phase 12

### 3. `.planning/phases/13-role-variations/helpers/_phase13_role_render.gd` + `.tscn` (80 + 9 lines)

Pitfall-1 contingency render helper. **Control-rooted** (extends Control, NOT SceneTree) — required because Phase 12 established that runtime Control-rooted main-viewport capture is more reliable than SubViewport timing under CLI.

**Behavior:**
- Loads canonical .tres, duplicates with `style = NeoCadeTheme.Style.PULSE` and `raised = true`.
- Loads showcase.tscn, instantiates, applies the duplicated theme, anchors full-rect.
- Phase-12-proven 4-step await chain: `create_timer(1.0).timeout` → `RenderingServer.frame_post_draw` → `process_frame` → `RenderingServer.frame_post_draw`.
- Captures `get_viewport().get_texture().get_image()` and saves as **full-color, full-resolution** PNG (no `adjust_bcs`, no `img.resize()`).
- Output: `.planning/phases/13-role-variations/artifacts/role-variations-pulse.png` (single PNG, NOT 5).
- Marker prefix: `PHASE13_ROLE_RENDER:`.
- Sibling `.tscn` is a 1-node Control scene referencing the script via `[ext_resource type="Script"]`.

**Status:** Built but NOT auto-invoked. Plan 13-04's verifier suite does not run it. It is the documented fallback path per 13-RESEARCH.md Pitfall 1 — invoke only if visual inspection of the showcase after 13-04 lands shows a `bg_color.a == 0.06` halo under GL Compatibility (Godot #23640 analog).

## Wave-0 RED-State Status (Expected)

Per 13-RESEARCH.md lines 416-423, the verifier helpers are intentionally RED in Wave 0:

| Helper / Stage | Wave 0 (now) | After Wave 1 (13-02) | After Wave 2 (13-03) |
|---------------|--------------|---------------------|---------------------|
| `--stage architecture` | RED (production BT=140, TV=47) | GREEN | GREEN |
| `--stage role-variations-registered` | RED (no role variations registered) | GREEN | GREEN |
| `--stage role-variations-in-showcase` | RED (showcase has no Role Variations section) | RED | GREEN |
| `--stage default-chrome-unchanged` | GREEN (vacuously — no role rebinds yet) | GREEN (assertion still holds) | GREEN |
| `--stage role-label-fonts` | RED (no explicit Role Label fonts set) | GREEN | GREEN |
| `_phase13_smoke_matrix.gd` | RED (BT/TV/role bindings missing) | GREEN (per-config) | GREEN |

Wave-0 helpers do NOT touch `addons/neocade_theme/*` — production state is untouched. The RED state IS the expected feedback signal that Wave 1/2 production work has work remaining. The contingency render helper (`_phase13_role_render`) has no automated success criterion at Wave 0; it is purely a visual halo inspection tool.

## Per-Task Commit Log

| Task | Commit | Files | Description |
|------|--------|-------|-------------|
| 1 — Port verifier headless | `86ecb03` | `_phase13_verify_headless.gd` (+279) | 6 stages, BT=149/TV=56 pinned, WR-01/WR-02 gates applied |
| 2 — Port smoke matrix | `b2c9000` | `_phase13_smoke_matrix.gd` (+134) | 30-config curated set + 9 Phase 13 per-config invariants |
| 3 — Build Pitfall-1 render helper | `2b344c9` | `_phase13_role_render.gd` (+80), `_phase13_role_render.tscn` (+9) | Control-rooted, full-color full-res, NOT auto-run |

## Verification Summary

All in-plan automated `<verify>` blocks for each task ran cleanly:

| Check | Verifier | Smoke | Render |
|-------|----------|-------|--------|
| File exists | ✅ | ✅ | ✅ (.gd + .tscn) |
| Required tokens present | ✅ all 9 variation names + 5 stages | ✅ BT=149, TV=56, configs.size() == 30 | ✅ extends Control, PULSE, role-variations-pulse.png |
| Marker prefix correct (PHASE13_*) | ✅ | ✅ | ✅ |
| No PHASE12_* leakage in non-comment lines | ✅ | ✅ | ✅ |
| No `adjust_bcs` / `img.resize(` tokens (render only) | n/a | n/a | ✅ (after re-wording the historical comment) |
| WR-01/WR-02 OK-print gate | ✅ 5/5 stages gated | n/a | n/a |

Plan-level success criteria (from `<success_criteria>` in 13-01-PLAN.md):

- [x] Task 1 (verifier helper) committed individually — `86ecb03`
- [x] Task 2 (smoke matrix helper) committed individually — `b2c9000`
- [x] Task 3 (role-render contingency .gd + .tscn) committed individually — `2b344c9`
- [x] SUMMARY.md created at `.planning/phases/13-role-variations/13-01-SUMMARY.md` (this file)
- [x] All four files (3 .gd + 1 .tscn) pass the in-plan `<verify>` automated checks
- [x] No PHASE12_* marker leaks after stripping comment lines
- [x] BT=149 / TV=56 pinned in both verifier and smoke matrix
- [x] All 9 variation names present in both helpers
- [x] WR-01/WR-02 OK-print gates applied to every verifier stage (5/5)
- [x] Pitfall-1 renderer is Control-rooted (extends Control)

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 3 - Blocking issue] Reworded acceptance-criteria-tripping comment in render helper**
- **Found during:** Task 3 in-plan `<verify>` check.
- **Issue:** The render helper acceptance criteria require that the `.gd` file "does NOT contain `adjust_bcs` (no desaturate) and does NOT contain `img.resize(` (no resize)" — a literal-token gate. The initial draft included a historical comment explaining what Phase 12 used to do (`adjust_bcs(1.0, 1.0, 0.0)` and `resize 256×144`), which tripped the literal-token gate even though the actual code does not desaturate or resize.
- **Fix:** Reworded the comment to convey the same information without those specific tokens. The render helper's behavior is unchanged.
- **Files modified:** `.planning/phases/13-role-variations/helpers/_phase13_role_render.gd`
- **Commit:** Folded into `2b344c9` (the Task 3 commit, which contains the corrected version directly — no separate fix commit needed because the rewording happened before the commit).

### Authentication Gates

None. This plan is helper-only and runs no external services.

### Other Notes

- The Phase 13 verifier `_stage_architecture()` adds an `@export count` assertion (`_count_top_level_exports`) that Phase 12's `_stage_architecture()` did NOT have (Phase 12 split that check into a separate `_stage_sc6` stage). Phase 13 consolidates because the plan only specifies 5 stages and the export-count invariant is core architecture. This is a faithful interpretation of the plan's architecture stage contract (`"@export == 12"` per file header docstring).
- The render helper's output directory (`res://.planning/phases/13-role-variations/artifacts`) does not currently exist. `DirAccess.make_dir_recursive_absolute(...)` creates it on first invocation (Phase 12 pattern).

## Known Stubs

None. Every helper is functionally complete for its Wave-0 contract:
- Verifier and smoke matrix encode all Phase 13 invariants and will turn GREEN once production additions land (no stub data; the assertions reflect the locked Phase 13 specification).
- Role render helper is fully implemented (no placeholder data); its "not auto-run" status is intentional — the helper is the documented Pitfall 1 contingency path, not a deferred feature.

## Threat Flags

None. This plan creates read-only helpers under `.planning/phases/13-role-variations/helpers/`. They do not modify `addons/neocade_theme/`, do not perform network I/O, and do not read environment variables.

## Self-Check: PASSED

**Files verified to exist:**
- FOUND: `.planning/phases/13-role-variations/helpers/_phase13_verify_headless.gd`
- FOUND: `.planning/phases/13-role-variations/helpers/_phase13_smoke_matrix.gd`
- FOUND: `.planning/phases/13-role-variations/helpers/_phase13_role_render.gd`
- FOUND: `.planning/phases/13-role-variations/helpers/_phase13_role_render.tscn`

**Commits verified to exist in `git log`:**
- FOUND: `86ecb03` feat(13-01): add _phase13_verify_headless.gd headless verifier
- FOUND: `b2c9000` feat(13-01): add _phase13_smoke_matrix.gd 30-config invariant runner
- FOUND: `2b344c9` feat(13-01): add _phase13_role_render Pitfall-1 contingency helper

**Plan-level invariants verified mechanically:**
- BT=149 / TV=56 pinned in BOTH verifier (lines 19-20) and smoke matrix (lines 16-17)
- WR-01/WR-02 OK-print gate: 5/5 stage OK-prints gated inside `if _failures.is_empty():`
- No PHASE12_VERIFY / PHASE12_SMOKE / PHASE12_THUMBNAIL leakage in non-comment lines of any helper
- All 9 variation names (SuccessLabel, WarningLabel, DangerLabel, InfoLabel, AccentPanel, InfoPanel, WarningPanel, DangerPanel, SuccessPanel) present in both verifier and smoke matrix
- Render helper is Control-rooted (`extends Control` on line 1) with sibling .tscn referencing it via `[ext_resource type="Script"]`

No caveats. Wave 0 Nyquist gate is ready to flip `nyquist_compliant: true` in `13-VALIDATION.md` and to unblock Wave 1 (Plan 13-02).
