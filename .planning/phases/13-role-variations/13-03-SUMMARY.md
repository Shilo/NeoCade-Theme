---
phase: 13
plan: 03
subsystem: phase-13-role-variations
tags: [godot, theme, binding-table, role-tokens, wave-2, additive]
requirements: [SC-13-1, SC-13-2, SC-13-3]
dependency_graph:
  requires:
    - addons/neocade_theme/scripts/neocade_theme.gd (single edit target; Wave 1 left BINDING_TABLE.size()=140; Wave 2 closes to 149)
    - .planning/phases/13-role-variations/helpers/_phase13_verify_headless.gd (Wave 0 verifier; --stage architecture flips GREEN after this plan)
    - .planning/phases/13-role-variations/helpers/_phase13_smoke_matrix.gd (Wave 0 30-config smoke; flips GREEN after this plan)
    - .planning/phases/13-role-variations/13-02-SUMMARY.md (Wave 1 outcome — TYPE_VARIATIONS=61 baseline; role-label-fonts GREEN)
  provides:
    - 9 BINDING_TABLE recipe entries for the 9 Phase 13 role variations (4 Role Label font_color recipes + 5 Role Panel stylebox.panel recipes with alpha=0.06)
    - --stage architecture GREEN (BT=149, TV=61, exports=12)
    - --stage role-variations-registered GREEN (all 9 bindings live: 4 has_color(font_color, *Label) + 5 has_stylebox(panel, *Panel))
    - --stage role-label-fonts GREEN (Wave 1 fonts still wired)
    - _phase13_smoke_matrix GREEN (30 configs × all invariants)
    - Unblocks Plan 13-04 (showcase + README + final verifier suite)
  affects:
    - addons/neocade_theme/scripts/neocade_theme.gd (only edit target; +97 lines, zero existing lines modified)
tech-stack:
  added: []
  patterns:
    - "BINDING_TABLE additive insertion (13-PATTERNS.md file #2 + #3) — 9 new keys appended before closing brace; zero deletions / zero modifications of the existing 140 entries"
    - "Role Label recipe shape: single-key color.font_color with {role: role_<x>} (mirrors Caption analog at lines 4962-4969)"
    - "Role Panel recipe shape: full stylebox.panel recipe with role/alpha=0.06/border_role=surface_panel_edge/radius=shape.card_radius/raised_intensity/raised_face_edge/padding=Vector2i(12,10) (mirrors CardPanel analog at lines 5041-5060)"
    - "Pitfall 3 awareness: each Role Panel recipe is complete (Godot REPLACES not merges by slot/type); no partial recipes"
    - "Pitfall 1 contingency NOT triggered: the 0.06 alpha literal flows through the existing resolver alpha-branch (lines 5353-5360) which accepts both literal float and shape-key string"
    - "D-01 invariant preserved (no Theme.clear() added or removed); 12-export contract preserved (zero new @export declarations); SC#3 invariant preserved (default Label.font_color and default PanelContainer.panel recipes byte-identical to pre-Phase-13)"
key-files:
  created: []
  modified:
    - path: addons/neocade_theme/scripts/neocade_theme.gd
      change: "+97 lines: 9 new BINDING_TABLE entries (4 Role Labels + 5 Role Panels) + 7 comment lines. Zero existing-line modifications."
decisions:
  - "BINDING_TABLE: 140 -> 149 (Wave 2 atomic addition: 4 Role Label font_color recipes + 5 Role Panel stylebox.panel recipes). The plan's stale 'TV=56' acceptance reference was already reconciled in Wave 1 to TV=61; this plan applied the same drift-reconciliation posture and the verifier was already pinned to 149 by Wave 0, so no helper updates were needed in Wave 2."
  - "Role Panel border_role = 'surface_panel_edge' (NOT 'role_<x>_edge'). No per-role edge tokens exist in role_table; using the base panel edge family preserves visual coherence."
  - "Role Panel padding = Vector2i(12, 10) (NOT default PanelContainer's Vector2i(10, 8)). Matches CardPanel; Role Panels are meant to read like cards."
  - "Role Panels carry NO color block. PanelContainer renders no text; consumers can opt into a Role Label as inner content."
  - "Pitfall 1 (0.06-alpha halo under GL Compatibility) contingency NOT triggered. Phase 13 verifier stages all pass; visual halo inspection deferred to Plan 13-04 (showcase) — if a halo appears there, the precompute-mix fallback path is documented in 13-RESEARCH.md lines 300-314 and the Wave 0 _phase13_role_render.gd helper exists for visual fact-check."
  - "Authentication / external services: none. Plan is offline."
metrics:
  duration: ~5 minutes
  completed: 2026-05-11
  tasks: 3
  files: 1
  commits: 2
---

# Phase 13 Plan 03: Wave 2 — BINDING_TABLE Recipe Additions Summary

**One-liner:** Wave 2 atomic edit to neocade_theme.gd landed — 9 new BINDING_TABLE entries (4 Role Label font_color recipes + 5 Role Panel stylebox recipes with alpha=0.06) close the Phase 13 binding contract. BINDING_TABLE grows 140 -> 149; Phase 13 verifier stages `architecture` + `role-variations-registered` + `role-label-fonts` + 30-config smoke matrix all GREEN; D-01 + 12-export + SC#3 invariants intact. Plan 13-04 (showcase + README + final verifier suite) unblocked.

## Objective Recap

Wave 2: Add the 9 BINDING_TABLE recipe entries that wire the role-color visuals for the 4 Role Labels (single-key `color.font_color` recipe pointing to `role_<x>`) and 5 Role Panels (full `stylebox.panel` recipe with `role: role_<x>` + `alpha: 0.06` literal float + the rest of the CardPanel field family). Single atomic addition to `addons/neocade_theme/scripts/neocade_theme.gd`. After this plan: Phase 13 verifier `--stage architecture` flips GREEN (BT=149) and `--stage role-variations-registered` flips GREEN (binding-side has_color/has_stylebox checks pass).

## What Was Built

### Task 1 — 4 Role Label BINDING_TABLE entries (commit `5b40201`)

Inserted after the HeroPanel block (entry #54) and before the BINDING_TABLE closing brace. Each entry contains only a `color.font_color` recipe; analog is Caption (lines 4962-4969).

```gdscript
"SuccessLabel": { "color": { "font_color": {"role": "role_success"} } },
"WarningLabel": { "color": { "font_color": {"role": "role_warning"} } },
"DangerLabel":  { "color": { "font_color": {"role": "role_danger"}  } },
"InfoLabel":    { "color": { "font_color": {"role": "role_info"}    } },
```

Comment numbering: 55, 56, 57, 58 (continues sequentially from 54 = HeroPanel).

Role tokens (`role_success`, `role_warning`, `role_danger`, `role_info`) already exist in `role_table` (lines 603-606); no new role-table keys added.

Default Label entry at lines 3163-3171 (`"font_color": {"role": "text_strong"}`) untouched — SC#3 invariant preserved.

### Task 2 — 5 Role Panel BINDING_TABLE entries (commit `a251c60`)

Inserted after the 4 Role Label entries and before the BINDING_TABLE closing brace. Each entry contains a complete `stylebox.panel` recipe; analog is CardPanel (lines 5041-5060).

```gdscript
"AccentPanel":  { "stylebox": { "panel": { "role": "role_primary", "alpha": 0.06, "border_role": "surface_panel_edge", "radius": "shape.card_radius", "raised_intensity": "shape.raised_lifts.panel", "raised_face_edge": true, "padding": Vector2i(12, 10) } } },
"InfoPanel":    { ... "role": "role_info",    "alpha": 0.06, ... },
"WarningPanel": { ... "role": "role_warning", "alpha": 0.06, ... },
"DangerPanel":  { ... "role": "role_danger",  "alpha": 0.06, ... },
"SuccessPanel": { ... "role": "role_success", "alpha": 0.06, ... },
```

Comment numbering: 59, 60, 61, 62, 63 (continues sequentially from 58 = InfoLabel).

Recipe shape conventions per 13-PATTERNS.md file #3:
- **`alpha: 0.06`** as literal float (NOT a `"shape.<key>"` lookup). The existing resolver alpha branch at lines 5353-5360 already accepts both forms; literal 0.06 produces the documented 6% tint.
- **`border_role: "surface_panel_edge"`** (NOT `role_<x>_edge` — no such role exists in role_table).
- **`padding: Vector2i(12, 10)`** (matches CardPanel; reads like a card, NOT default PanelContainer's `Vector2i(10, 8)`).
- **No `color` block** (PanelContainer doesn't render text in this contract).
- **Field order matches the documented Pattern 3 order** (`role`, `alpha`, `border_role`, `radius`, `raised_intensity`, `raised_face_edge`, `padding`) — order-independent at resolve time but maintained for diff readability.

Default PanelContainer entry at lines 5011-5022 (`"role": "surface_panel"`, `"padding": Vector2i(10, 8)`) untouched — SC#3 invariant preserved.

### Task 3 — Architecture stage diagnostic (no source modifications)

Invoked `_phase13_verify_headless.gd --stage architecture` and `--stage role-variations-registered` against the canonical Godot 4.6.2 CLI at `C:\Programming_Files\Godot\Godot_v4.6.2-stable_mono_win64\Godot_v4.6.2-stable_mono_win64_console.exe`. Both stages PASS.

```
$ godot --headless --quit --script "_phase13_verify_headless.gd" -- --stage architecture
PHASE13_VERIFY: stage=architecture
PHASE13_VERIFY: architecture OK (BINDING_TABLE=149, TYPE_VARIATIONS=61, exports=12)
PHASE13_VERIFY: PASS — stage 'architecture' all assertions green

$ godot --headless --quit --script "_phase13_verify_headless.gd" -- --stage role-variations-registered
PHASE13_VERIFY: stage=role-variations-registered
PHASE13_VERIFY: role-variations-registered OK (9 new variations live)
PHASE13_VERIFY: PASS — stage 'role-variations-registered' all assertions green
```

Bonus confirmations (Wave 1 deliverable still green + smoke matrix):

```
$ ... --stage role-label-fonts
PHASE13_VERIFY: role-label-fonts OK (4 Role Labels have explicit font + font_size)
PHASE13_VERIFY: PASS — stage 'role-label-fonts' all assertions green

$ ... _phase13_smoke_matrix.gd
PHASE13_SMOKE: begin
PHASE13_SMOKE: 30 configs queued
PHASE13_SMOKE: PASS — 30 configs regenerated cleanly, invariants held
```

Static evidence (executor-side, independent of Godot CLI):

- **BINDING_TABLE entries** between `const BINDING_TABLE: Dictionary = {` (line 1827) and its closing `}` (now line 5176) total **149** (verified by PowerShell counter that matches `^\t"[A-Za-z_][A-Za-z0-9_]*": \{`).
- **TYPE_VARIATIONS** unchanged from Wave 1 baseline (61 entries, including the 9 added in Plan 13-02).
- **`@export var` count = 12** (12-export contract intact).
- **`Theme.clear()` count in non-comment lines = 0** (D-01 invariant intact).

## Post-Wave-2 Verifier State

The Wave-Status table from 13-01-SUMMARY now reads:

| Helper / Stage | Wave 0 | Wave 1 (13-02) | Wave 2 (13-03 — now) |
|---------------|--------|----------------|---------------------|
| `--stage architecture` | RED (BT=140 vs 149) | RED (BT=140 vs 149) | **GREEN (BT=149)** |
| `--stage role-variations-registered` | RED (no bindings) | RED (registry-side OK, binding-side missing) | **GREEN (9 bindings live)** |
| `--stage role-variations-in-showcase` | RED (showcase has no section) | RED (showcase has no section) | RED (Plan 13-04 owns) |
| `--stage default-chrome-unchanged` | RED (DI-13-01 false-RED) | RED (DI-13-01 false-RED) | RED (DI-13-01 — not fixed by this plan; see Deferred Issues) |
| `--stage role-label-fonts` | RED (no fonts) | **GREEN** | **GREEN** |
| `_phase13_smoke_matrix.gd` | RED (BT/TV/bindings) | RED (BT/bindings) | **GREEN (30/30 configs)** |

Wave 2 closes its full deliverable contract: every architecture and binding-side invariant the plan promised flipped GREEN.

## Per-Task Commit Log

| Task | Commit | Files | Description |
|------|--------|-------|-------------|
| 1 — Add 4 Role Label BINDING_TABLE entries | `5b40201` | `addons/neocade_theme/scripts/neocade_theme.gd` (+25) | 4 single-key color.font_color recipes (SuccessLabel/WarningLabel/DangerLabel/InfoLabel) mirroring Caption analog; comment numbering 55-58 |
| 2 — Add 5 Role Panel BINDING_TABLE entries | `a251c60` | `addons/neocade_theme/scripts/neocade_theme.gd` (+72) | 5 full stylebox.panel recipes with alpha=0.06 literal float (AccentPanel/InfoPanel/WarningPanel/DangerPanel/SuccessPanel) mirroring CardPanel analog; comment numbering 59-63 |
| 3 — Architecture stage diagnostic | (no commit — diagnostic only) | n/a | Ran `--stage architecture` + `--stage role-variations-registered` + `--stage role-label-fonts` + smoke matrix against Godot 4.6.2 CLI; all GREEN |

## Verification Summary

All in-plan automated `<verify>` blocks for each task:

| Check | Task 1 | Task 2 | Task 3 |
|-------|--------|--------|--------|
| All 4 Role Label names + role tokens present (literal substring) | PASS | n/a | n/a |
| Default `Label.font_color` recipe still `{"role": "text_strong"}` (SC#3) | PASS | n/a | n/a |
| All 5 Role Panel names present (literal substring) | n/a | PASS | n/a |
| `"alpha": 0.06` literal count == 5 (one per Role Panel) | n/a | PASS | n/a |
| Default `PanelContainer.panel` recipe still has `surface_panel` + `Vector2i(10, 8)` (SC#3) | n/a | PASS | n/a |
| Role Panel entries contain NO `color` block | n/a | PASS | n/a |
| Static BINDING_TABLE entry count = 149 | n/a | n/a | PASS |
| Runtime verifier `--stage architecture` GREEN | n/a | n/a | PASS |
| Runtime verifier `--stage role-variations-registered` GREEN | n/a | n/a | PASS |
| Bonus: `--stage role-label-fonts` still GREEN | n/a | n/a | PASS |
| Bonus: `_phase13_smoke_matrix.gd` 30/30 configs PASS | n/a | n/a | PASS |

Plan-level success criteria (from `<success_criteria>` in 13-03-PLAN.md):

- [x] BINDING_TABLE grew from 140 to 149 entries (9 new keys: 4 Role Labels + 5 Role Panels)
- [x] Each Role Label entry contains ONLY a `color.font_color` slot bound to its role token
- [x] Each Role Panel entry contains a full `stylebox.panel` recipe with `alpha: 0.06` literal float
- [x] Default `Label.font_color` recipe byte-identical to pre-Phase-13 state (SC#3)
- [x] Default `PanelContainer.panel` recipe byte-identical to pre-Phase-13 state (SC#3)
- [x] `Theme.clear()` does NOT appear anywhere in the file (D-01)
- [x] `@export` count remains exactly 12 (12-export contract)
- [x] No new role-table keys added (all 5 role tokens already exist at lines 603-610)
- [x] Phase 13 verifier `--stage architecture` PASSES (GREEN)
- [x] Phase 13 verifier `--stage role-variations-registered` PASSES (GREEN)

## Deviations from Plan

### Auto-fixed Issues

None. The plan executed exactly as written. The drift-reconciliation note in the executor context (Wave 1 had already corrected TV=56 -> 61) was already absorbed by Wave 1's Task-3 helper fix; Plan 13-03 inherited the corrected helpers and the runtime `--stage architecture` output reports `TYPE_VARIATIONS=61` as the post-correction baseline. The plan's `must_haves.truths` reference to "TV=56" is stale text from before Wave 1's reconciliation but does not affect Wave 2's mechanics — the binding work is independent of the TV count.

### Authentication Gates

None. Plan touches a single tracked source file in `addons/neocade_theme/`; no external services, no auth, no network.

### Other Notes

- The plan referenced "line 5057" as the BINDING_TABLE closing brace insertion point. By the time Plan 13-03 executed, Wave 1's `+11` lines (TYPE_VARIATIONS additions) plus the Phase 12 lineage already shifted that line. The pre-Wave-2 closing brace was at line 5079 (HeroPanel ending at 5078). The actual insertion landed correctly because the edit was anchored on the HeroPanel block content (not absolute line numbers). Post-Wave-2 closing brace is now at line 5176.
- The TYPE_VARIATIONS count remains 61 (set by Wave 1). Plan 13-03 does not modify TYPE_VARIATIONS; it only modifies BINDING_TABLE.

## Deferred Issues

### DI-13-01 (unchanged from Wave 1) — `_stage_default_chrome_unchanged` false-RED on Phase 12 baseline panel translucency

Tracked in `.planning/phases/13-role-variations/deferred-items.md`. Plan 13-03 did NOT attempt to fix this — it is out of scope per the deferred-items contract and 13-03-PLAN's `<critical_constraints>` (explicitly listed as not in scope for this plan).

The stage's alpha-band check is too strict and false-REDs on Daybreak's `shape.surface_alpha_panels=0.96` baseline translucency. SC#3 is genuinely intact (the diff for Plan 13-03 shows zero modifications to the default `Label.font_color` or default `PanelContainer.panel` recipes — only additive insertions before the BINDING_TABLE closing brace).

Recommended fix (Plan 13-04 owner discretion): relax the stage's alpha-band check to instead assert "no bound `bg_color` in default `PanelContainer.panel` resolves through a `role_<x>` token", which is what SC#3 actually mandates.

## Known Stubs

None. Every Phase 13 § C1 (Role Label) and § C3 (Role Panel) recipe slot is now live in BINDING_TABLE; the resolver's color and stylebox branches emit the appropriate `set_color("font_color", "<X>Label", role_color)` and `set_stylebox("panel", "<X>Panel", StyleBoxFlat)` calls at theme regenerate time. Plan 13-04's remaining work (showcase scene + README documentation + final verifier suite) is documented scope, not a stub of this plan.

## Threat Flags

None. Plan 13-03 only edits a single tracked addon source file (`addons/neocade_theme/scripts/neocade_theme.gd`) in non-overlapping regions (additive insertions). No network surface, no auth path, no file-access change, no schema change at any trust boundary. The added recipes flow through existing resolver branches that already accepted both literal alpha floats and shape-key strings (no new code paths added).

## Self-Check: PASSED

**Files verified to exist:**
- FOUND: `addons/neocade_theme/scripts/neocade_theme.gd` (production edit target, +97 lines)
- FOUND: `.planning/phases/13-role-variations/13-03-SUMMARY.md` (this file)

**Commits verified to exist in `git log`:**
- FOUND: `5b40201` feat(13-03): add 4 Role Label BINDING_TABLE entries (single-key font_color recipes)
- FOUND: `a251c60` feat(13-03): add 5 Role Panel BINDING_TABLE entries (stylebox recipes with alpha=0.06)

**Empirical runtime evidence (canonical Godot 4.6.2 CLI):**
- `--stage architecture`: PASS — `BINDING_TABLE=149, TYPE_VARIATIONS=61, exports=12`
- `--stage role-variations-registered`: PASS — 9 new variations live (4 has_color + 5 has_stylebox)
- `--stage role-label-fonts`: PASS — Wave 1 deliverable still wired
- `_phase13_smoke_matrix.gd`: PASS — 30 configs all invariants held

**Plan-level invariants verified mechanically and empirically:**
- 9 new BINDING_TABLE keys present (4 Labels + 5 Panels); existing 140 entries unmodified
- 4 Role Label recipes contain only `color.font_color`; 5 Role Panel recipes contain only `stylebox.panel`
- `"alpha": 0.06` literal float appears exactly 5 times (one per Role Panel)
- Default `Label` and default `PanelContainer` recipes byte-identical to pre-Phase-13 state (SC#3)
- D-01 invariant intact (`Theme.clear()` absent from non-comment code)
- 12-export contract intact (12 `@export var` declarations, unchanged)

No caveats. Wave 2 closes the BINDING_TABLE contract for Phase 13. Plan 13-04 (showcase + README + final Nyquist suite) is fully unblocked.
