---
spike: 002a
name: raised-depth-formula-current
type: comparison
validates: "Given a hot-pink raised=true button, when current _raised_depth_color (gd:800-806) renders, then depth strip drifts toward base+black (per BRIEF measurement)"
verdict: PARTIAL
related: [002b]
tags: [identity, raised, comparison]
---

# Spike 002a: Current `_raised_depth_color` measured

## What This Validates

**Given** a representative test set (hot pink, vivid green, royal blue, gold, NeoCade-Pulse normal button, NeoCade-Burst purple, NeoCade-Daybreak teal, crimson danger), **when** the current `_raised_depth_color` formula at `addons/neocade_theme/scripts/neocade_theme.gd:800-806` renders against Pulse-navy and Burst-purple base colors, **then** the BRIEF's complaint that "depth becomes a muted purple-black, not a darker pink" can be confirmed or refuted numerically.

## Research

The current formula:

```gdscript
func _raised_depth_color(element: Color, base_c: Color) -> Color:
    var base_pull := 0.16 if not is_light else 0.10
    var depth_amount := 0.10 if not is_light else 0.12
    var result := _mix(element, base_c, base_pull)
    result = _mix(result, Color.BLACK, depth_amount)
    result.a = element.a
    return result
```

Two operations on dark themes (NeoCade v1):
1. Pull element 16% toward `base_color` (typically a dark, low-chroma navy/purple).
2. Pull result 10% toward pure black.

The BRIEF predicts step 1 will rotate hue (because base differs from element in hue), and step 2 will erode any vivid identity into black-mush.

## How to Run

The measurement is shared with 002b. From `002b-raised-depth-formula-hsv-darken/`:

```powershell
python compare_formulas.py
```

Then open `../002-comparison.html` and look at the **first column** (`current (gd:800-806)`).

## Investigation Trail

### Iteration 1 — set up the test matrix
8 representative colors × 2 representative bases = 16 element/base pairings. Implemented the GDScript formula in Python verbatim using float-RGB linear mix (matches Godot's `Color.lerp` semantics for sRGB linear blending in this case, which is what the engine uses).

### Iteration 2 — the BRIEF's hue-drift claim is *partly* wrong
Expected hue rotation up to 30-60° on the hot-pink-vs-navy case based on the BRIEF's "muted purple" wording. Actual measured rotation:

| Test color | Base | Δhue (current) | Sat drop | Value drop |
|---|---|---|---|---|
| Hot pink #FF4D9A | Pulse navy | **0.5°** | 1.5% | 23.6% |
| Hot pink #FF4D9A | Burst purple | **1.7°** | 0.8% | 22.9% |
| Royal blue #4D7AFF | Pulse navy | 0.1° | 0.7% | 23.0% |
| Royal blue #4D7AFF | Burst purple | 1.0° | 1.3% | 21.8% |
| Gold #FFC857 | Pulse navy | 0.05° | 2.2% | 23.6% |
| Gold #FFC857 | Burst purple | 1.2° | 4.1% | 22.9% |
| Pulse normal #1E2640 | Pulse navy | 0.5° | 1.4% | **18.5%** |
| Pulse normal #1E2640 | Burst purple | **4.7°** | 1.6% | **13.6%** |
| Burst purple #7C3AED | Pulse navy | 0.4° | 1.5% | 22.9% |

Hue rotation is **≤2° for nearly every saturated test case** and only reaches ~5° for the pathological mismatched case (Pulse-navy normal button against Burst-purple base, a configuration that doesn't actually occur in production since each direction owns its own base).

### Iteration 3 — the actual defect is darkness, not hue
Re-reading the HCGames anchor reference and the BRIEF text: the user's specific phrasing is *"thin tool-bar shadow line"* and *"depth strips are visually 40-50% darker"*. The diagnostic that matches the data:

- Current formula produces a depth strip that is **18-24% darker** than the element. The BRIEF's "muted shadow line" reading is correct.
- Current formula **does NOT meaningfully rotate hue**. The "muted purple-black, not darker pink" framing is geometrically off — the depth IS a darker pink, just not dark *enough* to read as a bold affordance.
- The two failure modes are decoupled: subtle darkness can co-exist with preserved hue.

### Iteration 4 — when does the current formula actually rotate hue?
Hue rotation > 3° appears only when the element color and base color differ significantly in hue AND the element has low saturation. The "Pulse normal button (#1E2640) against Burst base purple (#1A0F2E)" case produces 4.7° rotation because:
- #1E2640 has low chroma (saturation ~0.30), so a 16% pull toward base has noticeable effect.
- Pulse-blue toward Burst-purple is a real hue swing.

In production this configuration doesn't occur — each direction's base color is co-derived with its element colors. So the *theoretical* hue-rotation failure mode of the formula doesn't actually fire on shipped configurations.

## Results

### Verdict: **PARTIAL — formula's hue handling is fine; its darkness is too subtle**

The BRIEF's framing was that the current formula **erases hue identity** in the depth strip. The math says otherwise: hue is preserved within ≤2° on every shipped configuration. The real defect is that the formula produces a depth strip only 18-24% darker than the element, where HCGames-style flat-game-UI affordance needs **40-50%**. The visible reading "muted shadow line vs candy button" is *darkness-driven*, not *hue-driven*.

**This is not a defense of the current formula.** It IS too subtle, it DOES underclaim depth, and it SHOULD be replaced. But the replacement priority is "hit 40% value-drop", not "stop rotating hue" — because the formula barely rotates hue to begin with.

### Surprises

1. **The BRIEF's hue-drift diagnosis is largely a misreading.** The math says the current formula does ≤2° hue rotation on saturated colors against dark base. The user is reading the depth strip's *insufficient darkness* as "wrong color" because a barely-darker pink against a dark surface looks visually muddy.

2. **The two-step formula's design has merit.** Pulling toward `base_color` 16% means the depth strip naturally harmonizes with the surrounding panel — a darker shape that "belongs" to the surface tonal ramp rather than punching out. This is a reasonable design choice, just calibrated too soft.

3. **The mixed-direction case (Pulse-blue normal button on Burst-purple base) doesn't occur in production.** Each direction's bases and element colors are co-derived in `DIRECTION_PRESETS`, so the worst hue-rotation case is theoretical. This makes the case for keeping the base-pull weaker (it would still work fine in production).

### Signal for downstream spikes / Phase 12

- **Replace the formula** because the *darkness* is too low, not because the *hue* is wrong.
- **The BRIEF's recommendation language should be rephrased** in spike 003 / REPORT.md: instead of "depth-color formula erases hue identity", say "depth-color formula underclaims depth darkness".
- **HSV-value-darken (002b) is still the cleanest replacement** because it makes the darkness intent explicit (one knob: V-multiplier) and decouples it from base color drift entirely.
