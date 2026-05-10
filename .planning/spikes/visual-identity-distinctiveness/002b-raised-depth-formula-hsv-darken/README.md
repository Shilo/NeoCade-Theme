---
spike: 002b
name: raised-depth-formula-hsv-darken
type: comparison
validates: "Given the same hot-pink raised=true button, when depth uses HSV value-darken with no base-pull, then depth stays in same hue family and reads as a clearly-darker affordance."
verdict: VALIDATED-WINNER
related: [002a]
tags: [identity, raised, comparison]
---

# Spike 002b: HSV value-darken candidate

## What This Validates

**Given** the same representative test set as 002a (hot pink, vivid green, royal blue, gold, NeoCade direction normal/accent colors, crimson danger), **when** depth color is computed via pure HSV value-darken at 30%, 40%, 50% strength with NO base-pull and NO black-pull, **then** the depth strip reads as "noticeably darker, same hue family" per HCGames' flat-game-UI convention and matches the user's verbal target.

## Research

### The candidate formula

```python
def hsv_value_darken(element_rgb, strength):
    h, s, v = colorsys.rgb_to_hsv(*element_rgb)
    return colorsys.hsv_to_rgb(h, s, v * (1.0 - strength))
```

One operation: multiply the HSV value channel. Hue and saturation are preserved by construction. The strength parameter is the entire knob — `0.30` = 30% darker, `0.40` = 40% darker, `0.50` = 50% darker.

### Why HSV value-darken matches HCGames

HCGames Flat GUI for Mobile Games (the BRIEF's anchor reference) uses depth strips that read as "a darker shade of the same color" — explicitly NOT desaturated, NOT hue-shifted, NOT pulled toward the surface color. The BRIEF describes this as: *"bright pink button → noticeably darker pink shadow (not black, not desaturated, same hue family ~40-50% darker)"*.

HSV value-darken is the most direct mathematical implementation of "noticeably darker same hue same saturation". `_mix(element, BLACK, 0.40)` would also work but reduces saturation as a side effect (mixing toward black moves the color toward the achromatic axis, dropping chroma along with luminance).

### Comparison with three strengths

Tested at 30%, 40%, 50% darken to find the right calibration. HCGames-spirit per the BRIEF is "40-50% darker", so the candidate set spans that target.

## How to Run

```powershell
# from this directory
python compare_formulas.py
# wrote ../002-comparison.html and measurements.json
```

Open `../002-comparison.html` and look at columns 2-4 (`hsv-darken 30%`, `hsv-darken 40%`, `hsv-darken 50%`).

## Investigation Trail

### Iteration 1 — implementation + measurement
HSV value-darken is trivial in Python's stdlib `colorsys`. Implemented all three strengths in one pass. Measured every test case.

### Iteration 2 — confirming hue invariance
For every test color and every strength, hue rotation measured as **0.0°** (within float epsilon, ~1e-14). Saturation drop **0.0%**. Value drop matches the strength parameter exactly (e.g., 40% strength → 40% value drop). The formula does what it says on the tin.

### Iteration 3 — comparing to HCGames target
HCGames-style depth strips are described in `FLAT-3D-UI-RESEARCH.md` and the BRIEF as roughly 40-50% darker than the button face. The 40% candidate is the cleanest match — it reads as a clearly-distinct, candy-button-affordance shadow that does not become near-black even on dark NeoCade-direction normal buttons. The 50% candidate works on saturated accents but pushes Pulse-normal-button depth into territory that's barely distinguishable from base surface (#0f1320 vs base #0e1218).

### Iteration 4 — head-to-head with 002a
Verdict from 002a's investigation: the current formula's actual problem is darkness (~23% drop), not hue (≤2° rotation). HSV-darken at 40% delivers 40% darkness with 0° hue rotation — it fixes the *real* problem cleanly while also fixing the *theoretical* problem the BRIEF flagged (hue drift in the worst-case mixed-direction configuration). No regression on either axis.

### Iteration 5 — calibration suggestion per direction
HSV value-darken is uniform — every element color darkens by the same fraction. This works for "loud" directions (Burst, Bubble) where the depth strip is meant to read as bold. For "quiet" directions (Slate, Daybreak), 40% may be too much shouting. The candidate could plumb through `raised_strength` (already an export!) such that `effective_darken = 0.20 + 0.10 * raised_strength` (raised_strength=2 → 40%, =3 → 50%, =1 → 30%, =0 → 20%). This keeps the public-API surface unchanged while exposing the calibration knob.

## Results

### Verdict: **VALIDATED — WINNER over 002a**

HSV-value-darken at **40% strength** is the clean replacement for `_raised_depth_color`:

| Property | 002a (current) | 002b (hsv-darken 40%) |
|---|---|---|
| Hue rotation worst case | 4.7° | **0.0°** |
| Hue rotation typical | 0.1-2° | **0.0°** |
| Saturation drop | 1-4% | **0%** |
| Value drop | **18-24%** | 40% |
| Knobs | `base_pull`, `depth_amount` (2 hard-coded constants) | `strength` (1 parameter) |
| Couples to base_color | Yes (16% pull) | **No** |
| Matches HCGames target | No (too subtle) | **Yes** (40% darker, same hue) |

Both columns of "002a wins" are blank. 002b is strictly better or no worse on every measured axis.

### Recommended Phase 12 implementation

```gdscript
func _raised_depth_color(element: Color, base_c: Color) -> Color:
    # base_c kept in the signature for callsite compatibility but unused;
    # depth is now element-anchored, not surface-anchored.
    var strength: float = 0.20 + 0.10 * float(raised_strength)
    var h: float = element.h
    var s: float = element.s
    var v: float = element.v * (1.0 - strength)
    var result := Color.from_hsv(h, s, max(v, 0.04))
    result.a = element.a
    return result
```

The `max(v, 0.04)` floor prevents already-very-dark element colors (e.g., disabled-state buttons) from going to absolute black on raised_strength=3 — a 50% darken on V=0.06 → V=0.03 is below display gamut on most monitors.

### Surprises

1. **The simpler formula is also strictly more configurable.** One parameter instead of two, plumbed through an existing export instead of two hard-coded constants. The current formula's `base_pull` and `depth_amount` are both untunable from outside the script.

2. **No hue rotation across any test case.** 0.0° on every cell — the formula provably preserves hue families.

3. **Decoupling depth from base_color is a feature, not a regression.** The current formula's "harmonize with surface" rationale (pulling 16% toward base so the depth strip belongs to the tonal ramp) is a *design choice that fights the HCGames anchor*. HCGames depth strips are intentionally same-hue-family AS THE BUTTON, not the surface. The decoupling matches the reference set.

### Signal for downstream spikes / Phase 12

- **Adopt this candidate verbatim** in Phase 12. The implementation is ~6 lines.
- **Plumb through `raised_strength`** so the calibration is a public-API knob, not a constant. This satisfies the BRIEF's "lift `raised_strength` defaults" recommendation by giving each direction-default `raised_strength` a more meaningful effect.
- **Spike 003 should NOT spend further effort on depth-color** — that question is closed. Spike 003 concentrates on per-direction signature moves, lift thickness, and pillow-silhouette decisions, all of which are orthogonal to depth color.
- **Consider an additional `raised_depth_floor` advanced export** if there's user concern about absolute-darkness clamping on already-dark normal buttons. Default `0.04` should not need exposure.
