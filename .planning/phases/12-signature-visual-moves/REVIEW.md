---
phase: 12-signature-visual-moves
reviewed: 2026-05-11T12:00:00Z
depth: deep
files_reviewed: 10
files_reviewed_list:
  - addons/neocade_theme/scripts/neocade_theme.gd
  - showcase/showcase.tscn
  - .planning/phases/12-signature-visual-moves/helpers/_phase12_verify.gd
  - .planning/phases/12-signature-visual-moves/helpers/_phase12_verify_headless.gd
  - .planning/phases/12-signature-visual-moves/helpers/_phase12_thumbnail_render.gd
  - .planning/phases/12-signature-visual-moves/helpers/_phase12_thumbnail_render_runtime.gd
  - .planning/phases/12-signature-visual-moves/helpers/_phase12_fullsize_render_runtime.gd
  - .planning/phases/12-signature-visual-moves/helpers/_phase12_smoke_matrix.gd
  - .planning/phases/12-signature-visual-moves/12-CONTEXT.md
  - .planning/phases/12-signature-visual-moves/12-PATTERNS.md
findings:
  critical: 1
  warning: 5
  info: 3
  total: 9
status: issues_found
---

# Phase 12: Signature Visual Moves — Code Review Report

**Reviewed:** 2026-05-11
**Depth:** deep
**Files Reviewed:** 10
**Verdict:** SHIP-WITH-FIXES

## Summary

Phase 12 implements three signature visual moves (C4 HSV depth darken, C2' accent rebinds, C6 per-direction shape signatures) across `neocade_theme.gd`, `showcase/showcase.tscn`, and 6 verify helpers. The production code is well-structured and follows established BINDING_TABLE and STYLE_PERSONALITY idioms precisely. All six architectural invariants were checked:

- **Pitfall 5 mirror:** All 6 new shape keys are present in all 5 per-direction dicts AND `STYLE_PERSONALITY_DEFAULT`. PASS.
- **Pitfall 3 (border alpha):** C2' border_widths rows use full-alpha `role_primary`. Daybreak outline is explicitly full-alpha. PASS.
- **SC#1 (raised=false zero 3D):** Daybreak outline block is correctly gated on `if raised`. C4 depth colors are precomputed eagerly but only applied via `sb_intensity` which zeroes when `raised=false`. PASS.
- **SC#2 (tabs flat when raised):** TabBar/TabContainer `tab_selected` rebinds keep `raised_intensity: 0`. PASS.
- **SC#3 (no glow halos):** No new intermediate-alpha border colors introduced. PASS.
- **SC#5 (no new hues):** No new `Color()` literals in Phase 12 diff. PASS.
- **SC#6 (12 exports):** @export count remains exactly 12. PASS.
- **BINDING_TABLE row count:** 140 top-level keys. Verifier constant matches. PASS.

One BLOCKER was found: the Daybreak C6 outline unconditionally overwrites `expand_margin_*` to `outline_offset_resolved` (an `int`), but `StyleBoxFlat.expand_margin_*` is a `float` property in Godot 4.6. In GDScript an implicit `int → float` coercion is safe at the assignment site — this is not a crash — but more critically the outline block runs **after** the recipe-level `expand_margins: Vector4i` block (lines 5515-5524). For the current production recipes no primary-strategy stylebox carries an `expand_margins` key so there is no active conflict. However the ordering creates a silent architectural trap: any future primary-button recipe that legitimately uses `expand_margins` (e.g. a "floating CTA" variant) would have its margins silently overwritten by the Daybreak outline at `raised=true`, producing incorrect layout with no warning. Given the PATTERNS.md § 7 note that "no recipe currently uses both," this is a BLOCKER-by-architecture risk rather than a currently-manifesting bug.

Five warnings were found across the verify helper scripts, primarily around false-positive "OK" print messages and an unvalidated assumption about `Image.adjust_bcs` saturation semantics. Three informational findings are noted.

---

## Critical Issues

### CR-01: Daybreak C6 Outline Overwrites Recipe `expand_margins` Silently at `raised=true`

**File:** `addons/neocade_theme/scripts/neocade_theme.gd:5515-5569`
**Issue:** The Daybreak C6 outline block (lines 5541-5569) unconditionally assigns `sb.expand_margin_*` to `outline_offset_resolved` (currently 3 for Daybreak, 0 for all others). This block executes **after** the recipe-level `expand_margins: Vector4i` handler at lines 5515-5524. If any future primary-strategy recipe carries an `expand_margins` key, the Daybreak outline will silently overwrite it at `raised=true`. The comment in PATTERNS.md § 7 acknowledges "no recipe uses both" but that invariant is not enforced in code — no guard checks for recipe `expand_margins` conflict before overwriting.

Currently this causes no visible bug because no primary-button recipe in the BINDING_TABLE has an `expand_margins` key. But the execution order is architecturally fragile: the outline block modifies state written by a previous block using no exclusivity guard. Any reviewer adding a floating/elevated CTA recipe in a future phase would hit a silent layout break under Daybreak/raised=true with no diagnostic.

**Fix:** Add a guard that skips overwriting `expand_margins` when the recipe already specified them, OR reorder so the Daybreak outline block runs before the recipe `expand_margins` block so recipe values win over the outline offset. The simplest in-place fix:

```gdscript
# In the Daybreak C6 outline block, only set expand_margin when the recipe
# does not carry its own expand_margins — prevents silent overwrite.
if outline_offset_resolved > 0 and not recipe.has("expand_margins"):
    sb.expand_margin_left = float(outline_offset_resolved)
    sb.expand_margin_top = float(outline_offset_resolved)
    sb.expand_margin_right = float(outline_offset_resolved)
    sb.expand_margin_bottom = float(outline_offset_resolved)
elif outline_offset_resolved > 0:
    # Recipe has explicit expand_margins; add the outline offset to existing values
    # so both effects compose rather than the recipe silently losing.
    sb.expand_margin_left += float(outline_offset_resolved)
    sb.expand_margin_top += float(outline_offset_resolved)
    sb.expand_margin_right += float(outline_offset_resolved)
    sb.expand_margin_bottom += float(outline_offset_resolved)
```

Alternatively, since `outline_offset_resolved` is 0 for all non-Daybreak directions (because `primary_outline_offset: 0` in their shape dicts), a simpler fix is to add an explicit `assert(not recipe.has("expand_margins"), "...")` inside the `if outline_width_resolved > 0:` guard to fail loudly if a future recipe violates the assumption.

---

## Warnings

### WR-01: `_stage_sc2` Prints "OK" Unconditionally Even When Failures Were Recorded

**File:** `.planning/phases/12-signature-visual-moves/helpers/_phase12_verify_headless.gd:171`
**Issue:** The `_stage_sc2()` function calls `_fail()` to append failures but prints `"PHASE12_VERIFY: sc2 OK"` unconditionally at line 171 regardless of whether any failures occurred. In a CI grep for `"sc2 OK"` this produces a false pass signal in the log even when the exit code is 1. Compare with `_stage_sc1()` which correctly guards its OK print with `if not any_failed`.

```gdscript
# Current (line 171) — always prints OK:
print("PHASE12_VERIFY: sc2 OK (tabs flat at raised=true across all selectable styles)")

# Fix — guard the print:
if _failures.size() == 0 or not _failures.any(func(f): return f.begins_with("sc2:")):
    print("PHASE12_VERIFY: sc2 OK (tabs flat at raised=true across all selectable styles)")
```

A simpler approach matching the `_stage_sc1` idiom: track a local `var any_sc2_failed := false`, set it in the failure branch, and only print "OK" if it remains false.

### WR-02: `_stage_sc3` Also Prints "OK" Unconditionally Even When Failures Were Recorded

**File:** `.planning/phases/12-signature-visual-moves/helpers/_phase12_verify_headless.gd:213`
**Issue:** Same pattern as WR-01. `_stage_sc3()` appends to `_failures` via `_fail()` but prints `"PHASE12_VERIFY: sc3 OK"` unconditionally at line 213. For a test stage that inspects every border_color alpha across all styleboxes and styles, a false OK print is particularly misleading.

**Fix:** Apply the same guard pattern as recommended for WR-01.

### WR-03: `Image.adjust_bcs` Saturation Semantics Are Unvalidated — Assumption A1 Could Produce Color PNGs

**File:** `.planning/phases/12-signature-visual-moves/helpers/_phase12_thumbnail_render.gd:37,86`
`.planning/phases/12-signature-visual-moves/helpers/_phase12_thumbnail_render_runtime.gd:15,69`

**Issue:** Both thumbnail render helpers use `SATURATION_VALUE := 0.0` and call `img.adjust_bcs(1.0, 1.0, 0.0)` to desaturate. The inline comment acknowledges this as Assumption A1: "docs are ambiguous on whether `saturation=0` or `saturation=-1` fully desaturates." The SC#4 attestation commit message (4bf08694) confirms the zero-brightness/contrast bug was caught at runtime — meaning these helpers had never been run to completion before that commit. It is therefore unconfirmed whether `saturation=0.0` actually produces greyscale output in Godot 4.6.

If `adjust_bcs` uses a multiplier (0.0 = no saturation, range 0–1) the call is correct. If it uses an additive/offset model (0.0 = no change, -1.0 = fully desaturated), the SC#4 gate would pass attestation against silently colorful images, invalidating the greyscale identifiability test.

The `adjust_bcs` reference in Godot 4.6 docs states saturation is a multiplier where `0.0` removes all saturation (greyscale) and `1.0` is unchanged — consistent with usage here. But this was not empirically verified prior to the fix commit. The comment says "if the PNG retains color, re-run with -1.0" which implies an operator manual check is the safety net.

**Fix:** Add a runtime assertion after `adjust_bcs` in the non-fullsize helpers to confirm at least one pixel in the produced image is grey (R == G == B within tolerance). This would catch wrong desaturation semantics immediately rather than requiring visual inspection:

```gdscript
img.adjust_bcs(1.0, 1.0, saturation)
# Validate A1: sample center pixel to confirm desaturation occurred.
var center: Color = img.get_pixel(THUMB_W / 2, THUMB_H / 2)
if absf(center.r - center.g) > 0.05 or absf(center.r - center.b) > 0.05:
    push_warning("PHASE12_THUMBNAIL: center pixel appears non-grey (r=%.2f g=%.2f b=%.2f) — verify saturation=0.0 is correct for this Godot build" % [center.r, center.g, center.b])
```

### WR-04: `ButtonsSectionKicker` in a 3-Column GridContainer Without Column Span — Will Occupy Only 1/3 of Row Width

**File:** `showcase/showcase.tscn:128-132`
**Issue:** The new `ButtonsSectionKicker` Label is added as the first child of the `Grid` `GridContainer` at `columns = 3`. In a GridContainer, each child occupies exactly one cell. The Label has `size_flags_horizontal = 3` (EXPAND+FILL) which fills its cell, but the cell is only one column wide (1/3 of the row). The existing Kicker labels inside `PrimaryStack` / other inner containers are children of `VBoxContainer`s, not direct GridContainer children — they span full-width inside their parent container.

A direct GridContainer child Label with no column-span will float in the first column, with the remaining two columns empty on that row, giving a visually fragmented layout. Godot's `GridContainer` has no built-in column-span property, so the standard workaround is to wrap the Kicker in a `HBoxContainer` or place it in a separate parent that spans the full row above the grid (as a sibling of the GridContainer, not inside it).

**Fix:** Move the Kicker label to be a sibling of the `Grid` container (inside `RootMargin/RootStack/ShowcaseTabs/Buttons/Margin`) rather than a child of the grid itself. The `Margin` container is presumably a `MarginContainer` or `VBoxContainer` — placing the Kicker before the `Grid` inside that parent would let it span full width:

```
[node name="ButtonsSectionKicker" type="Label"
    parent="RootMargin/RootStack/ShowcaseTabs/Buttons/Margin"
    unique_id=2700000001]
layout_mode = 2
size_flags_horizontal = 3
theme_type_variation = &"Kicker"
text = "BUTTONS · IDENTITY"
```

### WR-05: Burst `primary_min_height` Uses Hardcoded 56 With No Mobile-Separate Value — D-12.11 Specifies "56 Desktop / 64 Mobile"

**File:** `addons/neocade_theme/scripts/neocade_theme.gd:1122`
**Issue:** Decision D-12.11 states "Burst C6 Move: primary_min_height = 56 desktop / 64 mobile." The implementation sets a single `"primary_min_height": 56` in Burst's shape dict with no mobile variant key. The recipe thread-through (lines 5499-5514) uses `tokens.get("body", 14)` as the content height proxy, which is density-scaled on mobile — but the `min_h_resolved` floor value (56) is constant regardless of platform.

At `platform=MOBILE`, the PATTERNS.md § 7 note says to use `tokens.primaryButtonMin` (56 mobile / 44 desktop per lines 850, 867). However the implementation appears to use only the single `primary_min_height: 56`, meaning the mobile minimum (intended as 64) is capped at 56. This means Burst's Oversized CTA is undersized on mobile per the locked spec.

**Fix:** Either add a separate `primary_min_height_mobile: 64` shape key (requires threading through in the resolver by checking `tokens.get("densityScale", 1.0) > 1.0`), or read `tokens.get("primaryButtonMin", 56)` as the effective floor value when the density scale indicates mobile:

```gdscript
# In the Burst min-height block:
var min_h_resolved: int = 0
if min_h_raw != null and (typeof(min_h_raw) == TYPE_INT or typeof(min_h_raw) == TYPE_FLOAT):
    min_h_resolved = int(min_h_raw)
# D-12.11: 64 on mobile. Lift from the density-scaled token if available.
if min_h_resolved > 0 and tokens.get("densityScale", 1.0) > 1.0:
    var mobile_floor: int = int(tokens.get("primaryButtonMin", min_h_resolved))
    min_h_resolved = maxi(min_h_resolved, mobile_floor)
```

---

## Info

### IN-01: `_raised_depth_color` `base_c` Parameter Is Intentionally Unused — No Static Analysis Suppression

**File:** `addons/neocade_theme/scripts/neocade_theme.gd:805`
**Issue:** The C4 replacement intentionally preserves `base_c` in the signature for callsite compatibility but does not use it. GDScript does not require explicit suppression of unused-parameter warnings, but the comment documents the intent. If the Godot editor or a future linter flags unused parameters, there is no mechanism to suppress this cleanly in GDScript (no `@warning_ignore` for unused function parameters). The risk is very low (GDScript does not currently warn on unused parameters at function scope), but worth noting for future GDScript version compatibility.

**Recommendation:** No action needed unless the project adds external linting. The comment at line 806-808 already documents the intent clearly.

### IN-02: `_phase12_smoke_matrix.gd` Asserts Config Count at Runtime — Will Crash Instead of Fail if Count Drifts

**File:** `.planning/phases/12-signature-visual-moves/helpers/_phase12_smoke_matrix.gd:26`
**Issue:** Line 26 uses a hard `assert(configs.size() == 30, ...)` which in Godot calls `OS.crash()` in release mode (though helpers are dev-only scripts). More subtly, if the test config is later updated to 31 or 29 configs, the assert fires before any actual smoke tests run, making the failure message opaque. Using `push_error + quit(1)` matches the rest of the script's error handling idiom.

**Fix:**
```gdscript
# Replace assert with explicit fail:
if configs.size() != 30:
    push_error("PHASE12_SMOKE: curated matrix size = %d (expected 30)" % configs.size())
    quit(1)
    return
```

### IN-03: `_phase12_thumbnail_render.gd` Layout-Settling Is Documented as "Best-Effort" — Produces Unreliable SC#4 Artifacts

**File:** `.planning/phases/12-signature-visual-moves/helpers/_phase12_thumbnail_render.gd:67-71`
**Issue:** The EditorScript variant uses a single `notification(NOTIFICATION_RESIZED)` call as a best-effort layout pass. The docstring already notes the two-pass workaround. The runtime variant (`_phase12_thumbnail_render_runtime.gd`) properly waits multiple frames and is the recommended path. The EditorScript is a fallback documented as unreliable for pixel-perfect results.

This is already documented and acknowledged. The finding is noted for completeness: SC#4 attestation artifacts should preferentially come from the runtime variant, not the EditorScript variant. The plan documents mention this but the helper itself only warns "for pixel-perfect results, run the script twice."

**Recommendation:** Add a `push_warning()` to the EditorScript variant's `_run()` body reminding the operator to use the runtime variant for SC#4 attestation purposes.

---

## Architectural Invariant Checklist

| Invariant | Status | Notes |
|-----------|--------|-------|
| **Pitfall 5: all 6 new shape keys in all 5 direction dicts + DEFAULT** | PASS | `hairline_thickness`, `min_radius_floor`, `primary_outline_color`, `primary_outline_offset`, `primary_outline_width`, `primary_min_height` present in all 5 directions and STYLE_PERSONALITY_DEFAULT |
| **Pitfall 3: no border_alpha < 1.0 on new C2'/C6 borders** | PASS | C2' `border_widths` rows set border_role to `role_primary` (resolved full-alpha). Daybreak outline explicitly full-alpha per comment. SC#3 exemption list for Graph types is accurate. |
| **SC#1: raised=false shows ZERO 3D** | PASS | Daybreak C6 outline gated on `if raised`. C4 depth colors computed but only applied via `sb_intensity = 0` when `raised=false`. |
| **SC#2: tabs stay flat when raised=true** | PASS | TabBar/TabContainer `tab_selected` rebinds keep `"raised_intensity": 0`. |
| **SC#3: no glow halos** | PASS | No new intermediate-alpha border colors in Phase 12 diff. Pre-existing Graph type exemptions are correct. |
| **SC#5: no new Color() literals** | PASS | All C2' rebinds use `role_primary` token. Daybreak outline uses `role_primary` token. No raw `Color("#...")` in diff. |
| **SC#6: @export count == 12** | PASS | Exactly 12 `@export var` declarations confirmed. No new exports introduced. |
| **BINDING_TABLE rows == 140** | PASS | Verifier constant is 140 and matches pre-Phase-12 baseline. C2' rebinds changed values inside existing rows, not row count. |
| **No 3D elements when raised=false (SC#1 broader)** | PASS | All C6 moves are either flat by construction (Kicker, hairline, min_radius_floor, min_height) or explicitly raised-gated (Daybreak outline). |

---

_Reviewed: 2026-05-11_
_Reviewer: Claude (gsd-code-reviewer)_
_Depth: deep_
