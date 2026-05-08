---
phase: 05-core-controls-buttons-inputs-labels-panels-desktop
plan: 06
subsystem: dynamic-theme-generator
tags:
  - spinbox-icons
  - spinbox-official-slot-names
  - icon-import-contract
  - d-11-icon-import-contract
  - d-12-spinbox-icons
  - cov-03
  - cov-01
  - phase5-verifier
  - spinbox-stage
dependency_graph:
  requires:
    - 05-01-SUMMARY  # Godot 4.6 CLI resolver + dual verifier scaffold + assert_spinbox_icons (PENDING from Wave 1)
    - 05-04-SUMMARY  # has_<kind> -> get_<kind>_list AUTHORED-slot detection pattern
    - 05-05-SUMMARY  # Three-stage SVG import workflow (D-11) reference (code_folded.svg pattern)
  provides:
    - "addons/neocade_theme/icons/spinbox_up.svg + .svg.import (32x32 monochrome white per D-11)"
    - "addons/neocade_theme/icons/spinbox_down.svg + .svg.import (32x32 monochrome white per D-11)"
    - "BINDING_TABLE.SpinBox.icon: 4 official Godot 4.6 slots wired (up / up_disabled / down / down_disabled)"
    - "spinbox stage in headless + EditorScript verifiers (PENDING == FAIL for assert_spinbox_icons + carry-forward of all prior strict groups)"
    - "assert_spinbox_icons flipped strict in spinbox stage (was PENDING since Wave 1)"
  affects:
    - addons/neocade_theme/neocade_theme.gd (BINDING_TABLE.SpinBox: +icon block with 4 official slots)
    - addons/neocade_theme/icons/spinbox_up.svg (NEW)
    - addons/neocade_theme/icons/spinbox_up.svg.import (NEW)
    - addons/neocade_theme/icons/spinbox_down.svg (NEW)
    - addons/neocade_theme/icons/spinbox_down.svg.import (NEW)
    - .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify_headless.gd (+spinbox stage)
    - .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify.gd (+spinbox stage in lockstep)
tech-stack:
  added: []
  patterns:
    - "Phase 4 D-11 icon contract honored verbatim: 32x32 reference, monochrome #FFFFFF, .import sidecar with svg/scale=2.0 + mipmaps/generate=true + compress/mode=0 + process/fix_alpha_border=true"
    - "Three-stage SVG import workflow (Wave 5 / code_folded.svg template): write SVG -> minimal placeholder .import (no uid/path) -> godot --headless --import -> commit godot-issued uid:// + ctex path. UIDs were NOT hand-authored."
    - "Disabled-icon SVG reuse (Wave 3 CheckBox disabled_icon pattern carried forward): up_disabled and down_disabled bind to the SAME SVG as up / down respectively. Godot tints the disabled state at draw time so two SVGs cover all four official slots; no separate disabled artwork required."
    - "BINDING_TABLE icon recipes use the existing data_type=='icon' branch in _resolve_recipe (Plan 04-05 wiring); no helper changes needed."
    - "Verifier spinbox stage flips assert_spinbox_icons strict + carries forward ALL prior strict groups (buttons / text-panels / text-final / shape / invariants) so a regression in any earlier wave's work still surfaces in spinbox-stage CI."
key-files:
  created:
    - addons/neocade_theme/icons/spinbox_up.svg
    - addons/neocade_theme/icons/spinbox_up.svg.import
    - addons/neocade_theme/icons/spinbox_down.svg
    - addons/neocade_theme/icons/spinbox_down.svg.import
    - .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/05-06-SUMMARY.md
  modified:
    - addons/neocade_theme/neocade_theme.gd
    - .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify_headless.gd
    - .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify.gd
decisions:
  - "Two SVGs (spinbox_up, spinbox_down), not four. Disabled variants reuse the base SVG via the Wave 3 CheckBox disabled_icon pattern — Godot tints the disabled state at draw time. The plan's <key_invariants> explicitly cited this precedent (`{\"icon\": \"spinbox_up\", \"disabled\": true}` was suggested as one option) and Wave 3's CheckBox row already proved the pattern works without a `disabled` flag on the icon recipe; we chose the simpler form (`{\"icon\": \"spinbox_up\"}`) for symmetry with the existing checked_disabled / unchecked_disabled rows."
  - "Chevron arrow style (NOT triangular fill). Stroke-based chevrons match the existing arrow_down.svg / code_folded.svg vocabulary (32x32 reference, stroke-width 3, stroke-linecap/linejoin round, monochrome #FFFFFF, fill=none). Reads cleanly at SpinBox's typical render size (~10-12px tall) and visually consistent with OptionButton's down arrow + CodeEdit's folded indicator. spinbox_up uses M8 20 L16 12 L24 20 (mirror of arrow_down's M8 12 L16 22 L24 12) so up/down chevrons are perfect inversions of each other."
  - "Three-stage SVG import workflow honored (D-11): wrote both SVGs -> wrote minimal `.import` placeholders (no uid/path/dest_files) -> ran `godot --headless --import` -> committed the populated `.import` sidecars (godot-issued uid://dji22umaddu4 for spinbox_up; uid://dqgua2l7igodd for spinbox_down). UIDs were NOT hand-authored."
  - "Verifier strict-stage names follow the Wave-N convention. Wave 2 added `shape`; Wave 3 added `buttons`; Wave 4 added `text-panels`; Wave 5 added `text-final`. Wave 6 adds `spinbox`. Each later stage carries forward ALL earlier strict groups (Wave 5 already carried Wave 4 strict; Wave 6 carries Waves 2/3/4/5 strict + adds assert_spinbox_icons) so a regression in any earlier wave's work still surfaces in the latest wave's CI."
  - "Verifier _phase5_verify.gd (EditorScript mirror) updated in lockstep so Editor 'File -> Run' coverage matches CI; `_stage` defaults to tooling but the spinbox_stage_strict list is identical."
  - "AUTHORED-slot detection (assert_spinbox_icons uses get_icon_list, not has_icon). The Wave 1 implementation already used `theme.get_icon_list(\"SpinBox\")` rather than `has_icon` — the verifier's pre-existing Plan 01 code anticipated the Wave 4 BL-02 carry-forward. No changes needed; just validating that the assertion is correctly authored-only."
metrics:
  duration: ~12 minutes (sequential mode on main working tree, no worktree)
  completed: 2026-05-07
  tasks_completed: 2
  commits: 2
  groups_ok_spinbox: 25
  groups_ok_text_final: 25
  groups_ok_text_panels: 25
  groups_ok_buttons: 25
  failures: 0
---

# Phase 5 Plan 06: SpinBox Icons + Imports Summary

Closes Plan 05-06 (Wave 6): SpinBox is themed end-to-end. The LineEdit-style interior was wired in Phase 4 (BINDING_TABLE row 970, "buttons_vertical_separation" / "buttons_width" / "field_and_buttons_separation" constants); Wave 6 adds the four official Godot 4.6 icon slots — `up`, `up_disabled`, `down`, `down_disabled` — via two new monochrome SVGs (D-11 contract) bound through the existing recipe schema. The Wave 1 PENDING marker (`assert_spinbox_icons`) flips to STRICT-PASS in the new `spinbox` stage; all prior strict stages still pass.

## What landed

**Production class (`addons/neocade_theme/neocade_theme.gd`) — BINDING_TABLE.SpinBox:**

1. **`icon` block added** to the existing SpinBox row (#27). Four official Godot 4.6 slots:
   - `up`            -> `{"icon": "spinbox_up"}`
   - `up_disabled`   -> `{"icon": "spinbox_up"}` (REUSE — Wave 3 disabled_icon pattern)
   - `down`          -> `{"icon": "spinbox_down"}`
   - `down_disabled` -> `{"icon": "spinbox_down"}` (REUSE)
2. The pre-existing `constant` block (`buttons_vertical_separation` / `buttons_width` / `field_and_buttons_separation`) is preserved verbatim from Phase 4.
3. NOT `up_arrow` / `down_arrow` — those are legacy names from earlier Godot and `assert_spinbox_icons` hard-fails on them (D-12 contract).

**New icon files (`addons/neocade_theme/icons/`):**

- `spinbox_up.svg` — 32x32 monochrome `#FFFFFF` chevron-up: `<path d="M8 20 L16 12 L24 20" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" />`. Mirror of arrow_down.svg.
- `spinbox_down.svg` — 32x32 monochrome `#FFFFFF` chevron-down: `<path d="M8 12 L16 20 L24 12" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" />`. Same path geometry as code_folded.svg (chevron-down vocabulary).
- `spinbox_up.svg.import` — committed AFTER `godot --headless --import` populated `uid="uid://dji22umaddu4"` and `path="res://.godot/imported/spinbox_up.svg-246dad3a455987e012e2f1f1c5ea8767.ctex"`.
- `spinbox_down.svg.import` — committed AFTER `godot --headless --import` populated `uid="uid://dqgua2l7igodd"` and `path="res://.godot/imported/spinbox_down.svg-6fb38c76106b7f33cc003ccb29a0be06.ctex"`.

All four files honor Phase 4 D-11: `svg/scale=2.0`, `mipmaps/generate=true`, `compress/mode=0`, `process/fix_alpha_border=true`. UIDs are godot-issued, never hand-authored.

**Verifier additions (both `_phase5_verify_headless.gd` and `_phase5_verify.gd` mirror):**

1. New stage `spinbox` registered in arg parser + stage policy.
2. `spinbox_stage_strict` list defined: 25 entries — `assert_spinbox_icons` (the Wave 1 PENDING that flips strict here) + ALL Wave 5 / Wave 4 / Wave 3 / Wave 2 strict groups + 2 invariants.
3. The `assert_spinbox_icons` group itself was authored in Wave 1 (Plan 05-01) and uses `get_icon_list("SpinBox").find(slot) != -1` (AUTHORED-slot detection per Wave 4 BL-02 carry-forward); no changes needed to the assertion body.
4. EditorScript verifier mirror (`_phase5_verify.gd`) updated in lockstep so Editor `File -> Run` coverage matches CI.

## Verifier results

```text
$ <godot> --headless --path . --script .../_phase5_verify_headless.gd -- --stage spinbox
PHASE5_VERIFY: stage=spinbox
...
PHASE5_GROUP_OK:assert_spinbox_icons ENFORCED  SpinBox icons present at official slots: up, up_disabled, down, down_disabled
...
----- PHASE5_VERIFY summary -----
  stage:          spinbox
  groups OK:      25 / 25
  groups PENDING: 0  []
  failures:       0
PHASE5_VERIFY OK (stage=spinbox)
```

Carry-forward regression check (post-Plan-05-06):

| Stage         | Exit | Failures | Status                                        |
| ------------- | ---- | -------- | --------------------------------------------- |
| `buttons`     | 0    | 0        | Plan 05-03 strict groups still pass           |
| `text-panels` | 0    | 0        | Plan 05-04 strict groups still pass           |
| `text-final`  | 0    | 0        | Plan 05-05 strict groups still pass           |
| `spinbox`     | 0    | 0        | Plan 05-06 strict groups pass (Wave 6 closes) |

Wave 1's pre-asserted `assert_spinbox_icons` group transitioned PENDING -> STRICT-PASS exactly as designed by Plan 01. No PENDING groups remain in any stage.

`godot --headless --import` exits 0 with no `ERROR:` / `SCRIPT ERROR:` lines.

## Tasks completed

| Task | Name                                                | TDD       | Commits |
| ---- | --------------------------------------------------- | --------- | ------- |
| 1    | Author SpinBox up/down SVGs and import sidecars     | RED+GREEN | 1f1ae5f |
| 2    | Wire SpinBox official icon slots                    | GREEN     | 88347d1 |

Total: 2 commits. (Task 1 RED — adding the spinbox stage to the verifier so it FAILed without BINDING_TABLE wiring — was bundled into the same commit as the SVG authoring because the assert_spinbox_icons function itself already existed from Wave 1; the only RED-side change was promoting it to strict via the new spinbox_stage_strict list.)

## Commits

| Hash      | Type | Files                                                                                                                                                          | Description                                                                |
| --------- | ---- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------- |
| 1f1ae5f   | feat | `addons/neocade_theme/icons/spinbox_{up,down}.svg`, `spinbox_{up,down}.svg.import`, `helpers/_phase5_verify_headless.gd`, `helpers/_phase5_verify.gd`           | T1 (RED+SVGs) — author chevrons + populated .import + spinbox stage scaffold |
| 88347d1   | feat | `addons/neocade_theme/neocade_theme.gd`                                                                                                                        | T2 (GREEN) — BINDING_TABLE.SpinBox icon block (4 official slots)            |

## Requirements addressed

- **COV-03** (paritally) — text/input class coverage extended: SpinBox is themed end-to-end (LineEdit interior from Phase 4 + up/down icons here).
- **COV-01** (paritally) — godot-minimal-theme bar progress: SpinBox icon parity with the upstream theme.
- **TYPEVAR-N/A** — SpinBox is a base class (not a type variation).
- **D-12** — `assert_spinbox_icons` flips strict; verifier asserts the four official Godot 4.6 slots are present and forbids `up_arrow` / `down_arrow` legacy names.
- **D-11** — icon import contract honored verbatim (32x32 monochrome white, svg/scale=2.0 + mipmaps/generate=true + compress/mode=0 + process/fix_alpha_border=true, godot-issued UIDs).

## Deviations from Plan

**None.** Plan executed exactly as written:

- Task 1 authored two chevron SVGs per the D-11 contract, ran the three-stage import workflow (write -> placeholder -> --import -> commit godot-issued UID), and added the new `spinbox` strict stage to both verifiers in lockstep.
- Task 2 wired the BINDING_TABLE.SpinBox.icon block with the four official Godot 4.6 slot names. `up_disabled` and `down_disabled` reuse the base SVGs (Wave 3 disabled_icon pattern) rather than authoring four separate SVGs — this matches the plan's `<key_invariants>` guidance (the disabled-icon reuse pattern was explicitly cited).
- The verifier's `assert_spinbox_icons` function itself was already authored correctly in Wave 1 (`get_icon_list("SpinBox").find(slot) != -1` — AUTHORED-slot detection per Wave 4 BL-02 carry-forward); no changes were needed to the assertion body.
- All four key-invariants from the executor brief were honored: D-01 (no Theme.clear), D-11 (icon contract), D-12 (official slot names), and the verifier `has_<kind>` Rule 1 fix (already in place from Wave 1).

### Auto-fixed Issues

None. Plan executed without deviations.

## Authentication gates

None required.

## Known stubs

None. SpinBox has authored chrome on all four official Godot 4.6 icon slots. The verifier's `get_icon_list("SpinBox")` returns exactly `[up, up_disabled, down, down_disabled]` (and any inherited LineEdit slots Godot exposes through the type chain — those are checked separately by the LineEdit assertions).

## Threat flags

None — no new network endpoints, auth paths, file access patterns, or schema changes at trust boundaries. Pure Theme metadata + static SVG asset work.

## Self-Check: PASSED

Verified post-write:

- **Files exist:**
  - FOUND: `addons/neocade_theme/icons/spinbox_up.svg` (32x32 SVG, 4 lines, contains `#FFFFFF`)
  - FOUND: `addons/neocade_theme/icons/spinbox_up.svg.import` (godot-issued `uid://dji22umaddu4`)
  - FOUND: `addons/neocade_theme/icons/spinbox_down.svg` (32x32 SVG, 4 lines, contains `#FFFFFF`)
  - FOUND: `addons/neocade_theme/icons/spinbox_down.svg.import` (godot-issued `uid://dqgua2l7igodd`)
  - FOUND: `addons/neocade_theme/neocade_theme.gd` (BINDING_TABLE.SpinBox extended with `icon` block)
  - FOUND: `helpers/_phase5_verify_headless.gd` updated (`spinbox` stage registered + `spinbox_stage_strict` list)
  - FOUND: `helpers/_phase5_verify.gd` updated in lockstep
  - FOUND: `.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/05-06-SUMMARY.md` (this file)
- **Commits exist (`git log --oneline -3`):**
  - FOUND: `1f1ae5f` (Task 1 — SVGs + spinbox verifier stage)
  - FOUND: `88347d1` (Task 2 — BINDING_TABLE SpinBox icon block)
- **Verifier gates:**
  - `spinbox` stage: 25/25 OK, 0 PENDING, 0 failures (PASS — Wave 1 PENDING `assert_spinbox_icons` flipped to STRICT-PASS)
  - `text-final` carry-forward: 25/25 OK, 0 failures (PASS — Wave 5 not regressed)
  - `text-panels` carry-forward: 25/25 OK, 0 failures (PASS — Wave 4 not regressed)
  - `buttons` carry-forward: 25/25 OK, 0 failures (PASS — Wave 3 not regressed)
- **Out-of-scope writes:** none. STATE.md, ROADMAP.md, addon `*_neocade_theme.tres` files, and `showcase/showcase.tscn` were not modified by this plan.
- **Icon count:** addon now has **13 SVG icons** (Phase 4's 10 + Wave 5's `code_folded` + Wave 6's `spinbox_up` and `spinbox_down`) — matches the README CHANGELOG target.

## TDD Gate Compliance

This plan's frontmatter `type: execute` (not `tdd`), but the individual tasks have `tdd="true"`. Per-task gate sequence verified:

- **Task 1:** RED was bundled with GREEN in `1f1ae5f` because the `assert_spinbox_icons` assertion already existed from Wave 1 (Plan 01); the only RED-side change was adding the `spinbox` strict stage policy that promotes the existing assertion from PENDING to FAIL. Pre-commit verification confirmed the spinbox stage exited 1 with exactly one failure (`assert_spinbox_icons -- SpinBox missing official icon slots: up, up_disabled, down, down_disabled`) — proper RED state.
- **Task 2:** GREEN-only — `88347d1` (feat) wired the BINDING_TABLE icon recipes and the spinbox stage immediately flipped from FAIL to PASS (25/25 OK, 0 failures).

REFACTOR phase: not needed. The icon recipes use the existing `data_type=='icon'` branch in `_resolve_recipe` (Phase 4 wiring); no helper extraction or refactor required.
