---
phase: 12
plan: 02
type: execute
wave: 1
depends_on: [12-01]
files_modified:
  - addons/neocade_theme/scripts/neocade_theme.gd
autonomous: true
requirements: []
must_haves:
  truths:
    - "`_raised_depth_color(element, base_c)` returns `Color.from_hsv(element.h, element.s, max(element.v * (1.0 - strength), 0.04))` where `strength = 0.20 + 0.10 * raised_strength`."
    - "`base_c` parameter is preserved in the signature (callsite compatibility) but unused in the body (depth decouples from surface per D-12.01)."
    - "Every existing callsite of `_raised_depth_color` continues to compile and execute (no signature change)."
    - "When `raised=false`, no callsite of `_raised_depth_color` is reached (existing zero-3D code path preserved — SC#1)."
    - "Result alpha equals input element alpha (`result.a = element.a` before return)."
    - "The 12-export contract is preserved (SC#6: `@export var` count = 12 before and after this plan)."
    - "No new hues introduced (SC#5: the formula only mutates the input element's value channel; no new `Color()` literals)."
  artifacts:
    - path: "addons/neocade_theme/scripts/neocade_theme.gd"
      provides: "Rewritten `_raised_depth_color` body at lines 800-806 (signature preserved)"
      contains: "Color.from_hsv(h, s, max(v, 0.04))"
  key_links:
    - from: "_raised_depth_color (element, base_c)"
      to: "Color.from_hsv (Godot 4.6 native)"
      via: "Color.h / Color.s / Color.v accessors + value-darken at raised_strength-scaled rate"
      pattern: "Color\\.from_hsv\\(h, s, max\\(v, 0\\.04\\)\\)"
    - from: "_raised_depth_color callers"
      to: "_raised_depth_color (unchanged signature)"
      via: "function signature preserved per D-12.03"
      pattern: "_raised_depth_color\\(.*,.*\\)"
---

<objective>
Replace the body of `_raised_depth_color(element, base_c) -> Color` at
`addons/neocade_theme/scripts/neocade_theme.gd:800-806` with the HSV value-darken
formula from spike 002b iteration 5 (D-12.02). The signature is preserved so every
existing callsite keeps compiling. This is a single-function, atomic rewrite per
D-12.20 (Wave 1 = ~30 min atomic).

Purpose: fix raised-button affordance on colored buttons. The old formula mixed
the element toward `base_c` (surface) then toward black, which collapsed accent-fill
buttons onto the surface ramp and broke the "depth stays in the button's hue family"
HCGames anchor. The new formula multiplies the element's value channel by
`(1.0 - strength)`, preserving hue and saturation — so a green button gets a darker
green depth strip, not a near-black one.

Output: 1 file modified (`addons/neocade_theme/scripts/neocade_theme.gd`), atomic
commit, ~7 lines changed.
</objective>

<execution_context>
@$HOME/.claude/get-shit-done/workflows/execute-plan.md
@$HOME/.claude/get-shit-done/templates/summary.md
</execution_context>

<context>
@.planning/PROJECT.md
@.planning/ROADMAP.md
@.planning/STATE.md
@.planning/phases/12-signature-visual-moves/12-CONTEXT.md
@.planning/phases/12-signature-visual-moves/12-RESEARCH.md
@.planning/phases/12-signature-visual-moves/12-PATTERNS.md
@CLAUDE.md

<interfaces>
<!-- Extracted from addons/neocade_theme/scripts/neocade_theme.gd via grep. -->

# Color helper neighborhood (lines 767-806):
func _mix(a: Color, b: Color, amount: float) -> Color                  # line 767
func _tint_toward_base(element: Color, base_c: Color, ratio: float = 0.40) -> Color   # line 776
func _button_tonal_color(source: Color, brightness_offset: float, saturation_multiplier: float) -> Color   # line 781
func _raised_depth_color(element: Color, base_c: Color) -> Color       # line 800  ← REWRITE TARGET

# Godot 4.6 stdlib (verified via Context7 in RESEARCH.md § Standard Stack):
static func Color.from_hsv(h: float, s: float, v: float, alpha: float = 1.0) -> Color
property Color.h: float    # read-only HSV hue, 0.0..1.0
property Color.s: float    # read-only HSV saturation, 0.0..1.0
property Color.v: float    # read-only HSV value, 0.0..1.0

# Public export the formula reads (line 109):
@export var raised_strength: int = 2   # 0..3 typical; clamped to >= 0 by setter

# SC#1 invariant — every _raised_depth_color callsite is inside an `if raised:` block
# per PATTERNS.md § 1 "Notes for planner". Wave 1 must NOT introduce a callsite
# that bypasses this gate.
</interfaces>

<formula_source>
## C4 formula — verbatim from D-12.02 / spike 002b iteration 5

```gdscript
func _raised_depth_color(element: Color, base_c: Color) -> Color:
    var strength: float = 0.20 + 0.10 * float(raised_strength)
    var h: float = element.h
    var s: float = element.s
    var v: float = element.v * (1.0 - strength)
    var result := Color.from_hsv(h, s, max(v, 0.04))
    result.a = element.a
    return result
```

Strength curve (D-12.02): `raised_strength=0 → 20%`, `=1 → 30%`, `=2 → 40%`, `=3 → 50%` value-darken.
The `max(v, 0.04)` floor prevents already-very-dark element colors from clamping to black at high strength.
</formula_source>
</context>

<tasks>

<task type="auto">
  <name>Task 1: Replace _raised_depth_color body at neocade_theme.gd:800-806 with the HSV value-darken formula</name>
  <files>addons/neocade_theme/scripts/neocade_theme.gd</files>
  <read_first>
    - addons/neocade_theme/scripts/neocade_theme.gd lines 767-806 (the entire color-helper neighborhood — confirms the surrounding _mix / _tint_toward_base / _button_tonal_color shape)
    - addons/neocade_theme/scripts/neocade_theme.gd lines 800-806 (the exact 7-line function body being replaced)
    - .planning/phases/12-signature-visual-moves/12-CONTEXT.md D-12.01..D-12.05 (the locked decisions)
    - .planning/phases/12-signature-visual-moves/12-PATTERNS.md § 1 "_raised_depth_color body rewrite (C4)" — Notes for planner section, especially the "Do not change the signature" and "alpha-restore pattern" instructions
    - .planning/phases/12-signature-visual-moves/12-RESEARCH.md § "Pattern 1: HSV value-darken depth (C4)" and Pitfall 2 (`raised_strength=0` produces 20% darken, NOT 0%; this is INTENTIONAL per spike 002b)
  </read_first>
  <action>
Open `addons/neocade_theme/scripts/neocade_theme.gd`. Locate the function `_raised_depth_color` starting at line 800. The CURRENT body is:

```gdscript
# Lines 800-806 BEFORE (the exact 7 lines to remove):
func _raised_depth_color(element: Color, base_c: Color) -> Color:
	var base_pull := 0.16 if not is_light else 0.10
	var depth_amount := 0.10 if not is_light else 0.12
	var result := _mix(element, base_c, base_pull)
	result = _mix(result, Color.BLACK, depth_amount)
	result.a = element.a
	return result
```

Replace lines 801-806 (the 6 body lines after the `func` signature line) with the HSV value-darken body. The function signature on line 800 stays unchanged. The replacement is:

```gdscript
# Lines 800-808 AFTER (signature preserved; body rewritten per D-12.02 verbatim):
func _raised_depth_color(element: Color, base_c: Color) -> Color:
	# Phase 12 C4 (D-12.02): HSV value-darken keeps depth in the element's hue family.
	# `base_c` retained for callsite compatibility but unused — depth decouples from
	# surface per the HCGames anchor (spike 002b iteration 5).
	var strength: float = 0.20 + 0.10 * float(raised_strength)
	var h: float = element.h
	var s: float = element.s
	var v: float = element.v * (1.0 - strength)
	var result := Color.from_hsv(h, s, max(v, 0.04))
	result.a = element.a
	return result
```

CRITICAL details:
- The signature line `func _raised_depth_color(element: Color, base_c: Color) -> Color:` is UNCHANGED. Do not edit it.
- `base_c` is kept in the parameter list. Do not rename it, do not remove it, do not warn-on-unused with a `_` prefix — D-12.01 explicitly says it stays in the signature.
- Use TABS for indentation to match the surrounding file's indent style (verified: lines 801-806 use tabs).
- The 3-line docstring comment above is required so future readers understand `base_c` is intentionally unused.
- Use `max(v, 0.04)` exactly — NOT `maxf(v, 0.04)`. `max()` is a GDScript built-in that works on both ints and floats. (Note: PATTERNS § 1 shows `max(v, 0.04)`; spike 002b uses `max(v, 0.04)`. Stick with `max`.)
- Use `Color.from_hsv(h, s, max(v, 0.04))` (3 args; alpha defaults to 1.0). Then immediately set `result.a = element.a` to restore the original alpha.
- The variable `result` is declared with `:=` (inferred type, will be `Color`). Match the surrounding helpers' style at line 783 (`var result := Color(source)`).

Do NOT make any other edits in this task. Do NOT touch callsites — they are intentionally unchanged (D-12.03). Do NOT add new `@export` properties (SC#6).
  </action>
  <verify>
    <automated>godot --headless --quit --script ".planning/phases/12-signature-visual-moves/helpers/_phase12_verify_headless.gd" -- --stage architecture && godot --headless --quit --script ".planning/phases/12-signature-visual-moves/helpers/_phase12_verify_headless.gd" -- --stage sc1-no-3d-when-flat && godot --headless --quit --script ".planning/phases/12-signature-visual-moves/helpers/_phase12_verify_headless.gd" -- --stage sc6-export-count</automated>
  </verify>
  <acceptance_criteria>
    - `addons/neocade_theme/scripts/neocade_theme.gd` contains the literal string `Color.from_hsv(h, s, max(v, 0.04))` exactly once (verifiable via `grep -c`).
    - The function signature `func _raised_depth_color(element: Color, base_c: Color) -> Color:` is unchanged (still present at line 800; verifiable via `grep -n "func _raised_depth_color"`).
    - The old line `var base_pull := 0.16 if not is_light else 0.10` is REMOVED from the file (verifiable via `grep -c "base_pull"` returns 0).
    - The old line `var depth_amount := 0.10 if not is_light else 0.12` is REMOVED (verifiable via `grep -c "depth_amount"` returns 0).
    - The old `_mix(element, base_c, base_pull)` and `_mix(result, Color.BLACK, depth_amount)` lines are REMOVED.
    - `result.a = element.a` is preserved as the second-to-last line of the new body.
    - `return result` is the last line of the new body.
    - The file contains exactly 12 `^@export ` lines (verifiable via `grep -c '^@export ' addons/neocade_theme/scripts/neocade_theme.gd` returns exactly 12 — SC#6 preserved).
    - The 5-line literal `var strength: float = 0.20 + 0.10 * float(raised_strength)` is present (the strength curve, verbatim from D-12.02).
    - `godot --headless --quit --script ".../_phase12_verify_headless.gd" -- --stage architecture` exits 0 (the canonical resource still loads and regenerates without error).
    - `godot --headless --quit --script ".../_phase12_verify_headless.gd" -- --stage sc1-no-3d-when-flat` exits 0 (raised=false still shows no 3D — C4 is gated by callers, not by the helper itself).
    - `godot --headless --quit --script ".../_phase12_verify_headless.gd" -- --stage sc6-export-count` exits 0 (12 exports preserved).
    - `godot --headless --quit --script ".../_phase12_verify_headless.gd" -- --stage full` exits 0.
  </acceptance_criteria>
  <done>The 6-line body at lines 801-806 has been replaced with the 8-line HSV value-darken body (plus 3-line docstring); signature, callsites, and exports unchanged; Wave 0 verifier full-stage green.</done>
</task>

<task type="auto">
  <name>Task 2: Smoke-matrix regression check after C4 rewrite</name>
  <files>(no file edits; this task only runs the verifier)</files>
  <read_first>
    - .planning/phases/12-signature-visual-moves/12-VALIDATION.md "Sampling Rate" — full-suite after every plan wave
    - .planning/phases/12-signature-visual-moves/helpers/_phase12_smoke_matrix.gd (created in Plan 01)
  </read_first>
  <action>
Run the 30-config smoke matrix to confirm the C4 rewrite does not regress any of the 30 representative `(style × raised × platform × base_color × accent_color)` configurations.

Command:
```bash
godot --headless --quit --script ".planning/phases/12-signature-visual-moves/helpers/_phase12_smoke_matrix.gd"
```

Expected output (last 2 lines):
```
PHASE12_SMOKE: PASS — 30 configs regenerated cleanly, invariants held
```
Exit code: 0.

If any config fails, the failure list will print before the exit. Capture it in the plan summary and investigate before proceeding to Plan 03. A regenerate failure here likely indicates one of:
- `raised_strength = 0` config triggered the `max(v, 0.04)` clamp on a near-black element color — this is INTENTIONAL per Pitfall 2; the smoke does not assert color values, only that regeneration succeeds.
- `is_light = true` config (light base_color, group 5 edge case "very light base") — the old formula branched on `is_light`; the new formula does not. This is intentional per D-12.01 ("depth decouples from surface"). If the smoke fails here, the formula was applied incorrectly.

No code edits in this task — it is a pure regression check.
  </action>
  <verify>
    <automated>godot --headless --quit --script ".planning/phases/12-signature-visual-moves/helpers/_phase12_smoke_matrix.gd"</automated>
  </verify>
  <acceptance_criteria>
    - `godot --headless --quit --script ".../_phase12_smoke_matrix.gd"` exits 0.
    - The final stdout line is `PHASE12_SMOKE: PASS — 30 configs regenerated cleanly, invariants held`.
    - No `PHASE12_SMOKE: FAIL` lines anywhere in the output.
    - No untracked file changes from this task (verifiable via `git status --short addons/`).
  </acceptance_criteria>
  <done>30-config smoke matrix is green after the C4 rewrite; no regression in any of the representative configurations.</done>
</task>

</tasks>

<threat_model>
## Trust Boundaries

| Boundary | Description |
|----------|-------------|
| Theme consumer (game / scene) → `NeoCadeTheme.raised_strength` | Consumer-supplied int (clamped to >= 0 by setter at line 109-114); value flows into the C4 formula as `strength = 0.20 + 0.10 * raised_strength`. |
| C4 formula → `Color.from_hsv` Godot stdlib | Internal call to a verified Godot 4.6 API. |

## STRIDE Threat Register

| Threat ID | Category | Component | Disposition | Mitigation Plan |
|-----------|----------|-----------|-------------|-----------------|
| T-12.02-01 | Tampering | `raised_strength` consumer input | accept | The export setter at line 109-114 clamps to `>= 0`. There is no upper bound, but `strength = 0.20 + 0.10 * raised_strength` only produces an unsafe value (>= 1.0) at `raised_strength >= 8` — then `v * (1.0 - strength) <= 0` and the `max(v, 0.04)` floor catches it. No data corruption possible. |
| T-12.02-02 | Information disclosure | Color values | accept | Colors are not secrets. No new colors are introduced (SC#5 hue invariant). |
| T-12.02-03 | Denial of service | C4 formula runtime cost | accept | Function is pure math on a single `Color`; ~5 ns per call. Even at thousands of calls per regenerate, total cost is negligible. |
| T-12.02-04 | Repudiation | Wrong depth color rendered | mitigate | The Wave 0 SC#1 / `--stage architecture` verifiers confirm the formula's output passes the locked invariants. Spike 002b iteration 5 already validated hue rotation = 0°, saturation drop = 0%, value drop = strength (D-12.04). |
</threat_model>

<verification>
After both tasks complete, run the full Phase 12 verifier suite:

```bash
godot --headless --quit --script ".planning/phases/12-signature-visual-moves/helpers/_phase12_verify_headless.gd" -- --stage full
godot --headless --quit --script ".planning/phases/12-signature-visual-moves/helpers/_phase12_smoke_matrix.gd"
```

Both MUST exit 0. The C4 rewrite is verified by:
- `--stage architecture` (file still loads, BINDING_TABLE intact)
- `--stage sc1-no-3d-when-flat` (raised=false still produces no 3D — proves the existing `if raised:` callsites are still the only entry into `_raised_depth_color`)
- `--stage sc6-export-count` (12 exports preserved — no new `@export var`)
- `--stage sc3-no-glow-halo` (no intermediate-alpha borders introduced)
- 30-config smoke (no regenerate regressions across the curated matrix)

Note: SC#4 (greyscale identifiability) is NOT a Wave 1 gate. C4 alone does not introduce per-direction signature differences — that lands in Wave 3 (C6). Defer SC#4 thumbnail render to Plan 04.
</verification>

<success_criteria>
- The 6-line body of `_raised_depth_color` at `addons/neocade_theme/scripts/neocade_theme.gd:801-806` is replaced with the HSV value-darken body from D-12.02 (verbatim).
- The function signature `func _raised_depth_color(element: Color, base_c: Color) -> Color:` is unchanged.
- The 12 `@export var` declarations are unchanged (SC#6).
- `--stage full` and the 30-config smoke matrix both exit 0.
- No other files modified.
- Plan completes as a single atomic commit (D-12.20 says Wave 1 = ~30 min atomic).
</success_criteria>

<output>
After completion, create `.planning/phases/12-signature-visual-moves/12-02-SUMMARY.md` documenting:
- The exact line range edited (`addons/neocade_theme/scripts/neocade_theme.gd:800-808`)
- Verbatim diff of the function body (BEFORE 6 lines / AFTER 8 lines + 3-line docstring)
- Output of `--stage full` (paste the `PHASE12_VERIFY: PASS` line for each sub-stage)
- Output of the smoke matrix (paste `PHASE12_SMOKE: PASS — 30 configs regenerated cleanly`)
- Confirmation that `grep -c '^@export ' addons/neocade_theme/scripts/neocade_theme.gd` returns 12
- Note any spike-002b empirical observations the executor noticed during smoke-matrix run (e.g., visual depth at `raised_strength=0` is 20% — Pitfall 2 awareness)
</output>
