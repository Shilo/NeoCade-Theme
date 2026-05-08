---
phase: 05-core-controls-buttons-inputs-labels-panels-desktop
plan: 07
subsystem: dynamic-theme-generator
tags:
  - resource-saver
  - data-only-tres
  - d-06
  - d-11
  - raised-shadow-contract
  - final-strict-stage
  - phase5-verifier
  - cycle-6-f7-retired
dependency_graph:
  requires:
    - 05-01-SUMMARY  # Godot 4.6 CLI resolver + dual verifier scaffold + named D-12 assertion groups
    - 05-06-SUMMARY  # spinbox stage strict + carry-forward of all prior strict groups (last wave before final)
    - 04-06-SUMMARY  # Phase 4 ResourceSaver pattern (_save_pulse_tres + _strip_theme_entries + _strip_load_steps_attr)
    - 04-07-SUMMARY  # Phase 4 peer-direction byte-alignment pattern (Slate / Bubble / Daybreak / Burst)
  provides:
    - "addons/neocade_theme/{pulse,slate,bubble,daybreak,burst}_neocade_theme.tres ResourceSaver-round-tripped + stripped data-only"
    - ".planning/phases/05-.../helpers/_phase5_resource_saver.gd (new SceneTree script)"
    - "_phase5_verify_headless.gd + _phase5_verify.gd: 3 new strict groups (assert_resource_data_only, assert_flat_no_shadow_when_off, assert_raised_hard_offset_shadow) + new `final` strict stage"
    - "Cumulative Phase 5 gate: all 8 stages pass 28/28 with 0 failures (tooling/shape/buttons/text-panels/text-final/spinbox/final/strict)"
    - "Cycle 6 F7 fallback retired: Godot CLI is now used for all .tres serialization per D-11"
  affects:
    - addons/neocade_theme/pulse_neocade_theme.tres (round-tripped via ResourceSaver)
    - addons/neocade_theme/slate_neocade_theme.tres (round-tripped via ResourceSaver)
    - addons/neocade_theme/bubble_neocade_theme.tres (round-tripped via ResourceSaver)
    - addons/neocade_theme/daybreak_neocade_theme.tres (round-tripped via ResourceSaver)
    - addons/neocade_theme/burst_neocade_theme.tres (round-tripped via ResourceSaver)
    - .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_resource_saver.gd (NEW)
    - .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_diag_reload.gd (NEW; debug helper)
    - .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify_headless.gd (+final stage + 3 strict groups)
    - .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify.gd (+final stage + 3 strict groups in lockstep)
tech-stack:
  added: []
  patterns:
    - "ResourceSaver round-trip pattern (Phase 4 D-11 carry-forward, finally executable now that Plan 05-01 resolved Godot 4.6 CLI): instantiate_or_load -> ResourceSaver.save() -> _strip_theme_entries() -> _strip_load_steps_attr() -> assert_size < 2 KiB. Replaces the Phase 4 Cycle 6 F7 hand-author fallback."
    - "Static strip helpers verbatim-copied from Phase 4 _phase4_import.gd into _phase5_resource_saver.gd (rather than re-importing) because Phase 4 helpers live on the host filesystem under .planning/, not in the res:// virtual filesystem; copying the deterministic helper bodies is the clean isolation."
    - "Hot-reload via ResourceLoader.CACHE_MODE_IGNORE (CACHE_MODE_REPLACE was tried first but does not reliably re-trigger _init() in the same headless run, validated empirically via helpers/_phase5_diag_reload.gd)."
    - "Focus-ring exemption by STRUCTURAL signature (shadow_size == -1 + shadow_offset == ZERO) rather than by SLOT NAME — slot name varies across BINDING_TABLE rows (`focus`, `tab_focus`, `scroll_focus`) but the production class hard-sets `shadow_size = -1` for ALL `role: \"focus_ring\"` recipes regardless of slot name. Structural detection auto-exempts any future focus-ring slot wiring in Phase 6/7."
    - "Cumulative `final` strict stage carries forward ALL prior strict groups (Plan 05-02 shape / 05-03 buttons / 05-04 text-panels / 05-05 text-final / 05-06 spinbox + invariants). A regression in any earlier wave's work surfaces in the `final` gate."
key-files:
  created:
    - .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_resource_saver.gd
    - .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_diag_reload.gd
    - .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/05-07-SUMMARY.md
  modified:
    - addons/neocade_theme/pulse_neocade_theme.tres
    - addons/neocade_theme/slate_neocade_theme.tres
    - addons/neocade_theme/bubble_neocade_theme.tres
    - addons/neocade_theme/daybreak_neocade_theme.tres
    - addons/neocade_theme/burst_neocade_theme.tres
    - .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify_headless.gd
    - .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify.gd
decisions:
  - "Verbatim-copy strip helpers (NOT cross-script load). Phase 4 _phase4_import.gd lives outside the res:// virtual filesystem (under .planning/phases/04-.../helpers/), so a cross-script `load(\"res://...\")` cannot reach it. The cleanest isolation is verbatim duplication of `_strip_theme_entries()` + `_strip_load_steps_attr()` into _phase5_resource_saver.gd; the helper bodies are deterministic so the strip output is identical."
  - "CACHE_MODE_IGNORE for the post-strip reload (NOT CACHE_MODE_REPLACE). Empirical: CACHE_MODE_REPLACE within the same headless `--script` run leaves the previously-loaded NeoCadeTheme instance attached to the cache and the `Button.normal` stylebox check fails because _init() never re-fires. CACHE_MODE_IGNORE bypasses the cache entirely and reads the stripped file from disk; _init() then fires normally and _regenerate_theme() repopulates the entries. Validated via _phase5_diag_reload.gd (kept as a debug helper for future investigation)."
  - "Focus-ring exemption by STRUCTURAL signature (shadow_size == -1 + shadow_offset == ZERO), NOT by slot-name allowlist. Slot names vary across BINDING_TABLE: `focus` (Button family), `tab_focus` (TabBar / TabContainer), `scroll_focus` (HScrollBar / VScrollBar). A slot-name allowlist would drift as Phase 6/7 add more focus-ring slots; the structural signature is invariant — the production class explicitly sets shadow_size=-1 + ZERO offset for every `role: \"focus_ring\"` recipe (line 2129 of neocade_theme.gd) and the raised branch in _make_raised_stylebox always emits non-negative shadow_size. So `(shadow_size == -1 and shadow_offset == ZERO)` is an unambiguous focus-ring marker."
  - "Direction-only filter on the recursive `.tres` SET assertion (Rule 1 deviation from plan's verify block). The plan's PowerShell verify block as-written checked the recursive `*.tres` set against exactly 5 paths, which would have falsely failed against the 5 legitimate font wrapper `.tres` files at addons/neocade_theme/fonts/ (Phase 4 Plan 02 deliverable). The plan's STATED INTENT is to forbid stray nested DIRECTION `.tres` under themes/ / _dev/ / etc. — not to ban font wrappers (which PROJECT.md explicitly lists as legitimate addon assets). The fix is to filter the recursive scan to direction `.tres` files only (matching `*_neocade_theme.tres`), which preserves the intent precisely AND aligns with the next assertion 2 lines later in the plan that already uses the direction-only filename pattern."
metrics:
  duration: ~38 minutes (sequential mode on main working tree, no worktree)
  completed: 2026-05-07
  tasks_completed: 2
  commits: 2 (Task 1 + Task 2; SUMMARY commit follows)
  groups_ok_final: 28
  groups_ok_strict: 28
  groups_ok_carry_forward: "28/28 across all 8 stages (tooling/shape/buttons/text-panels/text-final/spinbox/final/strict)"
  failures: 0
  files_modified: 9 (5 .tres round-tripped + 2 verifier mirrors + 2 helpers created)
---

# Phase 5 Plan 07: Final ResourceSaver + Data-Only Verification Summary

Closes Plan 05-07 (Wave 7 — final). The five approved direction `.tres` files have been round-tripped through Godot's `ResourceSaver.save()` for the first time (replacing the Phase 4 Cycle 6 F7 hand-author fallback) and stripped to data-only per D-06. A new `final` strict stage in the dual verifier introduces three new assertion groups — data-only `.tres` invariant, flat-mode shadow contract, raised-mode hard-offset shadow contract — and carries forward strict every prior wave's groups. All 8 stages now pass 28/28 with 0 failures, including the full `strict` cumulative gate. Phase 5's structural verification surface is closed.

## What landed

**ResourceSaver round-trip helper (`.planning/phases/05-.../helpers/_phase5_resource_saver.gd`, NEW):**

A SceneTree script that for each of the five approved direction `.tres` files:
1. Loads + asserts `is NeoCadeTheme`.
2. Snapshots all 9 `@export` properties before save.
3. Calls `ResourceSaver.save(theme, original_path)` — Godot serializes the full `_regenerate_theme()` output (header + ext_resource list + every BINDING_TABLE-derived sub_resource and theme_data entry → ~94-117 KiB pre-strip).
4. Calls the verbatim Phase 4 strip pass (`_strip_theme_entries(path)` + `_strip_load_steps_attr(header_line)`, copied from Phase 4 `_phase4_import.gd`) which removes every `[sub_resource]`, every non-Script `[ext_resource]`, every `theme_data/...` line, and the stale `load_steps=N` attribute.
5. Re-loads the stripped `.tres` via `CACHE_MODE_IGNORE` and asserts (a) it loads as `NeoCadeTheme`, (b) the 9 `@export` values match the pre-save snapshot byte-for-byte (Color comparisons via `is_equal_approx`), (c) the Phase 4 baseline (`Button.normal` stylebox) is present after `_regenerate_theme()` repopulates entries, (d) the file is < 2048 bytes, (e) the file contains no `[sub_resource]` or `theme_data/`.

Reproducibility validated: running the helper twice produces byte-identical output (Godot's float-encoded `Color(...)` literals + stable ext_resource id assignments + deterministic strip pass).

**Round-tripped direction `.tres` files (`addons/neocade_theme/*_neocade_theme.tres`):**

| File                          | Before | After | Δ      |
| ----------------------------- | ------ | ----- | ------ |
| pulse_neocade_theme.tres      | 445 B  | 331 B | -114 B |
| slate_neocade_theme.tres      | 446 B  | 352 B | -94 B  |
| bubble_neocade_theme.tres     | 447 B  | 373 B | -74 B  |
| daybreak_neocade_theme.tres   | 456 B  | 342 B | -114 B |
| burst_neocade_theme.tres      | 440 B  | 366 B | -74 B  |

All five files now reflect Godot's canonical ResourceSaver float-encoded `Color(...)` form (e.g., `Color(0.0823529, 0.101961, 0.180392, 1)` for `#151A2E`) AND ResourceSaver's "omit class-default values" optimization (e.g., Pulse no longer serializes `raised=false`, `platform=2`, `raised_strength=3`, `focus_thickness=2`, `outline_width=1` because they match the class defaults — these still round-trip correctly because the load-time defaults are identical). All five remain well under SC#6's 2 KiB cap.

**Verifier additions (lockstep across `_phase5_verify_headless.gd` + `_phase5_verify.gd`):**

Three new strict assertion groups + a new `final` stage:

1. **`assert_resource_data_only`** — for each approved direction `.tres`: size < 2048 bytes; no `[sub_resource]` line in the file; no `theme_data/` line; reloads as `NeoCadeTheme` with `Button.normal` populated.
2. **`assert_flat_no_shadow_when_off`** — load each direction, force `raised = false`, walk every authored stylebox via `get_stylebox_type_list()` × `get_stylebox_list(ttype)`, assert every `StyleBoxFlat` has `shadow_size == -1` and `shadow_offset == Vector2.ZERO`.
3. **`assert_raised_hard_offset_shadow`** — load each direction, force `raised = true`, walk every authored stylebox, assert every `StyleBoxFlat` either matches the focus-ring structural signature (`shadow_size == -1 + shadow_offset == ZERO` — exempt) OR has hard-offset shadow semantics (`shadow_offset == Vector2(0, shadow_size)` AND `shadow_size` is a non-negative multiple of `raised_strength`, proving it flowed through `_make_raised_stylebox(bg, offset, raised_strength * raised_intensity_recipe)`).

The `final` stage strict-list carries forward every prior wave's strict groups (Plan 05-02 shape / 05-03 buttons / 05-04 text-panels / 05-05 text-final / 05-06 spinbox + the two invariant guards), so a regression in any earlier wave's work surfaces in the final stage. The total group count is now **28** (Plan 01 baseline 7 + Plan 05-02 added 4 + Plan 05-03 added 8 + Plan 05-04 added 4 + Plan 05-05 added 2 + Plan 05-07 added 3).

## Verifier results

```text
$ <godot> --headless --path . --script .../_phase5_verify_headless.gd -- --stage final
PHASE5_VERIFY: stage=final
PHASE5_VERIFY: helper wiring OK (Pulse loads + Phase 4 baseline holds + production .gd present).
PHASE5_GROUP_OK:assert_variation_count_15 ENFORCED  ...
... (26 more OK markers, all ENFORCED) ...
PHASE5_GROUP_OK:assert_resource_data_only ENFORCED  all 5 direction `.tres` files data-only, < 2 KiB, no [sub_resource], no theme_data/, reload as NeoCadeTheme with Phase 4 baseline
PHASE5_GROUP_OK:assert_flat_no_shadow_when_off ENFORCED  raised=false: every generated StyleBoxFlat has shadow_size == -1 and shadow_offset == ZERO across all 5 directions
PHASE5_GROUP_OK:assert_raised_hard_offset_shadow ENFORCED  raised=true: every generated StyleBoxFlat has shadow_offset == Vector2(0, shadow_size); shadow_size is a non-negative multiple of raised_strength; focus rings exempt (-1)
----- PHASE5_VERIFY summary -----
  stage:          final
  groups OK:      28 / 28
  groups PENDING: 0  []
  failures:       0
PHASE5_VERIFY OK (stage=final)
```

Carry-forward regression check (post-Plan-05-07):

| Stage         | Exit | Groups OK | Failures | Status                                                              |
| ------------- | ---- | --------- | -------- | ------------------------------------------------------------------- |
| `tooling`     | 0    | 28 / 28   | 0        | Plan 01 baseline still holds                                        |
| `shape`       | 0    | 28 / 28   | 0        | Plan 05-02 strict groups still pass                                 |
| `buttons`     | 0    | 28 / 28   | 0        | Plan 05-03 strict groups still pass                                 |
| `text-panels` | 0    | 28 / 28   | 0        | Plan 05-04 strict groups still pass                                 |
| `text-final`  | 0    | 28 / 28   | 0        | Plan 05-05 strict groups still pass                                 |
| `spinbox`     | 0    | 28 / 28   | 0        | Plan 05-06 strict groups still pass                                 |
| `final`       | 0    | 28 / 28   | 0        | Plan 05-07 closes (Wave 7) — three new strict groups all PASS       |
| `strict`      | 0    | 28 / 28   | 0        | Full cumulative gate — every PENDING flips to ENFORCED              |

Focus probe: structural assertions pass on every direction × every focusable target (5 dirs × 4 base controls × 6 variations); `PHASE5_FOCUS_RENDER_SKIPPED` emitted cleanly for the optional pixel sample.

`godot --headless --import` + `_phase5_resource_saver.gd` runs both exit 0 with no `^(ERROR|SCRIPT ERROR):` lines.

## Tasks completed

| Task | Name                                                       | Commit  |
| ---- | ---------------------------------------------------------- | ------- |
| 1    | ResourceSaver round-trip the five direction resources only | b6abd4f |
| 2    | Run final verifier and exact data-only resource gates      | 467977c |

Total: 2 commits (plus this SUMMARY commit).

## Commits

| Hash    | Type | Files                                                                                                                                                                                                                                                                                                                                                                  | Description                                                              |
| ------- | ---- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------ |
| b6abd4f | feat | `.planning/.../helpers/_phase5_resource_saver.gd` (NEW), `.planning/.../helpers/_phase5_diag_reload.gd` (NEW), `addons/neocade_theme/{pulse,slate,bubble,daybreak,burst}_neocade_theme.tres` (round-tripped via ResourceSaver + stripped data-only)                                                                                                                       | T1 — round-trip 5 direction .tres through ResourceSaver                  |
| 467977c | feat | `.planning/.../helpers/_phase5_verify_headless.gd` (+`final` stage + 3 strict groups), `.planning/.../helpers/_phase5_verify.gd` (+`final` stage + 3 strict groups in lockstep)                                                                                                                                                                                            | T2 — add `final` stage with data-only + raised-shadow gates              |

## Requirements addressed

- **COV-02** (BaseButton-family full state coverage) — strict in `final` via carry-forward.
- **COV-03** (5 text classes + CodeEdit gutter) — strict in `final` via carry-forward.
- **TYPEVAR-01** (6 button variations chrome) — strict in `final` via carry-forward.
- **TYPEVAR-02** (5 label + Kicker = 6 label variations) — strict in `final` via carry-forward.
- **TYPEVAR-03** (InfoText polish + RichTextLabel slot fix) — strict in `final` via carry-forward.
- **TYPEVAR-04** (CardPanel + HeroPanel chrome) — strict in `final` via carry-forward.
- **TYPEVAR-05** (explicit fonts on every variation, PITFALLS 1.2) — strict in `final` via carry-forward.
- **D-06** (data-only `.tres`) — flipped strict in `final` via the new `assert_resource_data_only` group.
- **D-11** (ResourceSaver round-trip; Cycle 6 F7 fallback retired) — closed by Task 1.
- **DESIGN_TOKENS §9 / Conflict 3** (no shadows in flat mode; hard-offset shadows in raised mode) — flipped strict in `final` via the two new shadow-contract groups.
- **COV-01** (godot-minimal-theme bar progress) — Phase 5 contributes 14/14 type variations + 6/7 BaseButton-family + 5/5 text classes; remaining COV-01 surface is in Phase 6 (Tree, Range, ItemList, TabBar, FoldableContainer) and Phase 7 (popups, MenuBar, ColorPicker, Graph). Strict carry-forward in `final` for Phase 5's contributors.
- **COV-07** (icon set) — Phase 5 contributes `code_folded.svg`, `spinbox_up.svg`, `spinbox_down.svg` (icon count 10 → 13); strict in `final` via carry-forward.
- **COV-09** (focus indicator on every focusable Phase 5 Control) — flipped strict in `buttons`/`final` via `assert_focus_overlay_visibility`.
- **TYPEVAR-06** (variation documentation) — Phase 5 finalizes the variation count (15 incl. Kicker); the documentation deliverable lands in Phase 8.

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 - Bug] PowerShell verify block's recursive `.tres` set check would have falsely failed against legitimate font wrapper `.tres` files**

- **Found during:** Task 2 verification (the plan's verify block as-written compares the recursive `*.tres` set against exactly 5 paths).
- **Issue:** Phase 4 Plan 02 ships 5 legitimate font wrapper `.tres` files at `addons/neocade_theme/fonts/` (Inter-Body / Inter-Caption / Inter-HeaderLarge / Inter-HeaderMedium / Inter-HeaderSmall — these are FontVariation wrappers around Inter-Variable.ttf, an explicit Phase 4 deliverable per FOUND-01). The plan's PowerShell `Get-ChildItem ... -Recurse -Filter '*.tres'` would discover these AND the 5 direction files, producing 10 paths total; `Compare-Object` against the plan's expected 5-path list would fail.
- **Fix:** Filter the recursive scan to direction `.tres` files only via `-Filter '*_neocade_theme.tres'`. This preserves the plan's STATED INTENT precisely (forbid stray nested DIRECTION `.tres` files under themes/, _dev/, or any other subdirectory — not ban font wrappers) and aligns with the very next assertion in the plan's verify block which already uses the direction-only filename pattern.
- **Files modified:** `.planning/.../logs/_run-task2.ps1` (the executor's wrapper script around the plan's verify recipe).
- **Verification:** All 5 gates in `_run-task2.ps1` pass (focus probe, final verifier, no-Theme.clear, direction `.tres` set match, data-only invariant). No legitimate addon files are flagged.
- **Documented as:** key-decision row above + this entry. The plan's verify block (in PLAN.md) remains as-written; the executor wrapper applies the directional filter.

**2. [Rule 1 - Bug] Initial `assert_raised_hard_offset_shadow` focus-ring exemption used a heuristic (transparent-bg + border) that falsely matched GhostButton non-focus styleboxes**

- **Found during:** Task 2 first verifier run.
- **Issue:** First-pass exemption was `bg_color.a == 0.0 and (border_width_left > 0 or expand_margin_left > 0)`. This matched GhostButton's `normal`/`hover`/`disabled` states (the ghost variant strategy uses transparent bg + thin border), causing 4 false failures per direction × 5 directions = 20 spurious failures. GhostButton.normal under raised=true legitimately has `shadow_size=3, offset=(0,3)` (Pulse) — that's correct hard-offset behavior, NOT a focus ring.
- **Fix attempt 1:** Use slot-name allowlist (`if slot == "focus": exempt`). This worked for Button-family slots but failed against `tab_focus` (TabBar / TabContainer) and `scroll_focus` (HScrollBar / VScrollBar) — those slot names also use `role: "focus_ring"` in BINDING_TABLE but do not equal `"focus"`. 4 new spurious failures per direction.
- **Fix attempt 2 (LANDED):** Use the unambiguous structural signature `shadow_size == -1 and shadow_offset == ZERO`. The production class hard-sets these values for every `role: "focus_ring"` recipe regardless of slot name (line 2129 of neocade_theme.gd) and the raised branch in `_make_raised_stylebox` always emits non-negative `shadow_size`. So the structural signature cleanly separates focus rings from non-focus styleboxes without depending on slot-name conventions. Bonus: this auto-exempts any future focus-ring slot wiring that lands in Phase 6/7 without verifier edits.
- **Files modified:** `.planning/.../helpers/_phase5_verify_headless.gd` (lines ~2018-2030), `.planning/.../helpers/_phase5_verify.gd` (matching lockstep change).
- **Verification:** `--stage final` exits 0 with 28/28 OK, 0 failures.
- **Committed in:** `467977c` (Task 2 commit).

**3. [Rule 3 - Blocking] `CACHE_MODE_REPLACE` does not reliably re-trigger `_init()` in the same headless `--script` run**

- **Found during:** Task 1 first run (round-trip helper's post-strip reload check).
- **Issue:** After `ResourceSaver.save(theme, path)` + `_strip_theme_entries(path)`, the helper attempts to re-load the stripped `.tres` via `ResourceLoader.load(path, "", ResourceLoader.CACHE_MODE_REPLACE)`. The reload returns a `NeoCadeTheme` instance but `has_stylebox("normal", "Button")` returns false — `_init() -> _regenerate_theme()` apparently does not fire on the cached instance. All 5 directions failed the post-reload baseline check.
- **Fix:** Switch to `CACHE_MODE_IGNORE`, which bypasses the cache entirely and reads the freshly-stripped file from disk; `_init()` then fires normally and `_regenerate_theme()` repopulates entries. Validated empirically via a temporary `_phase5_diag_reload.gd` (kept as a debug helper for future investigation — it proves out the `is NeoCadeTheme + has_stylebox + 9 @exports preserved` chain on demand).
- **Files modified:** `.planning/.../helpers/_phase5_resource_saver.gd` (Phase F: reload via `CACHE_MODE_IGNORE`); `.planning/.../helpers/_phase5_diag_reload.gd` (NEW; debug helper).
- **Verification:** All 5 directions round-trip cleanly; reproducibility check passes (re-running the helper produces byte-identical output).
- **Committed in:** `b6abd4f` (Task 1 commit).

---

**Total deviations:** 3 auto-fixed (2 Rule 1 bugs in verifier discrimination logic, 1 Rule 3 blocking cache-mode quirk).
**Impact on plan:** All 3 deviations were essential for correctness. None expanded scope — they all sit inside the Plan 05-07 deliverables (helper + verifier + .tres round-trip). The PowerShell filter fix is a precise honoring of the plan's stated intent; the slot-name → structural-signature swap on the focus-ring exemption is more robust than the original heuristic; the `CACHE_MODE_IGNORE` swap is a Windows-Godot-specific footgun documented for future Phase 6/7 ResourceSaver work.

## Authentication gates

None required.

## Known stubs

None. The five direction `.tres` files are now the canonical Godot-serialized form; they reload byte-identically as `NeoCadeTheme` instances with the full `_regenerate_theme()` entry set. The `_phase5_resource_saver.gd` helper is fully wired and idempotent.

## Threat flags

None — no new network endpoints, auth paths, file access patterns, or schema changes at trust boundaries. Pure Theme metadata + verifier additions.

## Self-Check: PASSED

Verified post-write that all artifacts exist on disk and the two task commits + the SUMMARY commit are present in git history.

```
Source-controlled (commit b6abd4f):
  FOUND: .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_resource_saver.gd
  FOUND: .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_diag_reload.gd
  FOUND: addons/neocade_theme/pulse_neocade_theme.tres (331 B, < 2 KiB, no [sub_resource], no theme_data/)
  FOUND: addons/neocade_theme/slate_neocade_theme.tres (352 B)
  FOUND: addons/neocade_theme/bubble_neocade_theme.tres (373 B)
  FOUND: addons/neocade_theme/daybreak_neocade_theme.tres (342 B)
  FOUND: addons/neocade_theme/burst_neocade_theme.tres (366 B)

Source-controlled (commit 467977c):
  FOUND: .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify_headless.gd (+final stage + 3 strict groups)
  FOUND: .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify.gd (+final stage + 3 strict groups in lockstep)

Source-controlled (this commit):
  FOUND: .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/05-07-SUMMARY.md

Commits (`git log --oneline -3`):
  FOUND: 467977c  feat(05-07): add final stage with data-only + raised-shadow gates
  FOUND: b6abd4f  feat(05-07): round-trip 5 direction .tres through ResourceSaver
  FOUND: 7c6b5bf  docs(phase-5): update tracking after wave 6  (parent — orchestrator-owned)

Out-of-scope writes: NONE.
  - .planning/STATE.md: untouched (orchestrator owns this).
  - .planning/ROADMAP.md: untouched (orchestrator owns this).
  - showcase/showcase.tscn: untouched (its `theme = ExtResource(pulse_neocade_theme.tres)` reference still resolves correctly because the round-tripped Pulse `.tres` retains the same `script_class="NeoCadeTheme"` form-2 header + script linkage).

Verifier gates (cumulative; all 8 stages):
  tooling      28/28 OK, 0 failures, exit 0
  shape        28/28 OK, 0 failures, exit 0
  buttons      28/28 OK, 0 failures, exit 0
  text-panels  28/28 OK, 0 failures, exit 0
  text-final   28/28 OK, 0 failures, exit 0
  spinbox      28/28 OK, 0 failures, exit 0
  final        28/28 OK, 0 failures, exit 0  (this plan)
  strict       28/28 OK, 0 failures, exit 0  (full cumulative)
```

## TDD Gate Compliance

This plan's frontmatter `type: execute` (not `tdd`) and the individual tasks do not carry `tdd="true"`. The Phase 5 final wave is structural verification + serialization round-trip, not feature TDD; the RED/GREEN cycle does not apply (the round-trip helper either succeeds or fails as a single deterministic operation, and the new strict groups either pass or fail against the existing implementation). Verification was end-to-end (run helper → check output → run verifier → assert all gates pass) rather than test-first.

---
*Phase: 05-core-controls-buttons-inputs-labels-panels-desktop*
*Plan: 07 (Wave 7 — Final)*
*Completed: 2026-05-07*
