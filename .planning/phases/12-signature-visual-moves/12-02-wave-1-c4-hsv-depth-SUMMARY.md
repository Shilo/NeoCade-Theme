---
phase: 12
plan: 02
subsystem: color-helpers
tags: [wave-1, c4-hsv-depth, raised-fidelity, gdscript, phase12]
dependency_graph:
  requires:
    - .planning/phases/12-signature-visual-moves/helpers/_phase12_verify_headless.gd
    - .planning/phases/12-signature-visual-moves/helpers/_phase12_smoke_matrix.gd
  provides:
    - addons/neocade_theme/scripts/neocade_theme.gd (_raised_depth_color HSV body)
  affects:
    - All raised=true callsites of _raised_depth_color
tech_stack:
  added: []
  patterns:
    - HSV value-darken via Color.from_hsv (Godot 4.6 native)
    - Strength-scaled value channel with floor clamp (spike 002b iteration 5)
    - Alpha-restore pattern (mirrors _button_tonal_color idiom)
key_files:
  created: []
  modified:
    - addons/neocade_theme/scripts/neocade_theme.gd (lines 800-810, _raised_depth_color body)
decisions:
  - D-12.01: base_c parameter retained in signature for callsite compatibility, body does not use it
  - D-12.02: HSV value-darken formula verbatim from spike 002b iteration 5
  - D-12.03: No callsite changes; every existing call continues to compile and execute
metrics:
  duration: ~15min
  completed: "2026-05-11"
  tasks_completed: 2
  files_modified: 1
---

# Phase 12 Plan 02: Wave 1 C4 HSV Depth Summary

Replaced the body of `_raised_depth_color` with the HSV value-darken formula from spike 002b iteration 5 — green depth strips now stay in the button's hue family instead of collapsing onto the surface tonal ramp.

## One-liner

HSV value-darken depth formula replacing the old mix-toward-black body: `Color.from_hsv(h, s, max(v * (1-strength), 0.04))` with strength curve 20–50% across `raised_strength` 0–3.

## Completed Tasks

| Task | Name | Commit | Files |
|------|------|--------|-------|
| 1 | Replace _raised_depth_color body with HSV value-darken formula | 0c5c7aa | addons/neocade_theme/scripts/neocade_theme.gd |
| 2 | Smoke-matrix regression check after C4 rewrite | (no commit — pure run) | (none) |

## Exact Line Range Edited

**File:** `addons/neocade_theme/scripts/neocade_theme.gd`
**Lines:** 800–810 (function starts at 800; body expands from 6 lines to 10 lines including 3-line docstring)

## Verbatim Diff

```diff
 func _raised_depth_color(element: Color, base_c: Color) -> Color:
-	var base_pull := 0.16 if not is_light else 0.10
-	var depth_amount := 0.10 if not is_light else 0.12
-	var result := _mix(element, base_c, base_pull)
-	result = _mix(result, Color.BLACK, depth_amount)
-	result.a = element.a
-	return result
+	# Phase 12 C4 (D-12.02): HSV value-darken keeps depth in the element's hue family.
+	# `base_c` retained for callsite compatibility but unused — depth decouples from
+	# surface per the HCGames anchor (spike 002b iteration 5).
+	var strength: float = 0.20 + 0.10 * float(raised_strength)
+	var h: float = element.h
+	var s: float = element.s
+	var v: float = element.v * (1.0 - strength)
+	var result := Color.from_hsv(h, s, max(v, 0.04))
+	result.a = element.a
+	return result
```

**BEFORE:** 6 body lines (base_pull, depth_amount, two _mix calls, alpha restore, return)
**AFTER:** 10 body lines (3-line docstring + 5 formula lines + alpha restore + return)

## Verification Output

### --stage full

```
PHASE12_VERIFY: stage=full
PHASE12_VERIFY: architecture OK (BINDING_TABLE=140, TYPE_VARIATIONS=52)
PHASE12_VERIFY: sc1 OK (no depth chrome with raised=false across all selectable styles)
PHASE12_VERIFY: sc2 OK (tabs flat at raised=true across all selectable styles)
PHASE12_VERIFY: sc3 OK (2060 styleboxes inspected, 50 graph-type rows skipped)
PHASE12_VERIFY: sc6 OK (12 exports)
PHASE12_VERIFY: PASS — stage 'full' all assertions green
```

### Smoke matrix

```
PHASE12_SMOKE: begin
PHASE12_SMOKE: 30 configs queued
PHASE12_SMOKE: PASS — 30 configs regenerated cleanly, invariants held
```

## Export Count Confirmation

`grep -c '^@export ' addons/neocade_theme/scripts/neocade_theme.gd` returns **12** — SC#6 preserved.

## Spike 002b Empirical Observations

The `raised_strength=0` default produces a 20% value-darken (strength = 0.20 + 0.10*0 = 0.20). This is the intentional Pitfall 2 behavior from spike 002b — `raised_strength=0` does NOT mean "no depth", it means a mild 20% darken. Consumers wanting zero depth must use `raised=false` (the existing SC#1 gate). The `max(v, 0.04)` floor confirms that even very dark elements (near-black) do not clamp to pure black at high `raised_strength` values.

## Deviations from Plan

None — plan executed exactly as written.

## Known Stubs

None.

## Threat Flags

None. The formula is pure math on a single Color value. No new network endpoints, auth paths, file access patterns, or schema changes.

## Self-Check: PASSED

- `addons/neocade_theme/scripts/neocade_theme.gd` contains `Color.from_hsv(h, s, max(v, 0.04))` exactly once: CONFIRMED
- Function signature `func _raised_depth_color(element: Color, base_c: Color) -> Color:` present at line 800: CONFIRMED
- Old variable `base_pull` not found in file: CONFIRMED (count=0)
- Old variable `depth_amount` not found in file: CONFIRMED (count=0)
- `@export` count = 12: CONFIRMED
- Task 1 commit 0c5c7aa exists: CONFIRMED
- `--stage full` exits 0: CONFIRMED
- Smoke matrix exits 0: CONFIRMED
