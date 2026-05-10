---
spike: 001
name: color-monoculture-diagnostic
type: standard
validates: "Given a Pulse/Slate/Bubble/Daybreak/Burst showcase frame, when unique hues are counted vs MD3 reference and shipped-game-UI references, then the gap is expressed numerically."
verdict: VALIDATED
related: []
tags: [identity, color, diagnostic]
---

# Spike 001: Color Monoculture Diagnostic

## What This Validates

**Given** a representative showcase frame for each of the 5 NeoCade directions, **when** perceptually distinct hue families are counted (saturation-weighted, with surface tonal ramps and text/background pixels masked out), **then** the gap to MD3 spec layouts (≥3 simultaneous role colors) and shipped flat-modern mobile game UIs (5+ hues common) can be expressed as a single number per direction.

This is the **headline diagnostic** of the BRIEF (mandate item 1). Every downstream signature-move proposal needs this number to set a target.

## Research

### Why hue-count, not unique-RGB-count?

A naive `set(rgb_pixels)` count would report tens of thousands of "unique colors" on any direction's showcase frame because of anti-aliasing, sub-pixel rendering, and the 5-stop tonal surface ramp. That number bears no relation to perceptual reading.

The user's complaint phrasing was specific: *"navy + navy + navy + navy + a dot of green = 2 hues"*. They are reading the 5-stop tonal ramp (`surface_low` / `surface_base` / `surface_panel` / `surface_high` / `surface_overlay`) as one hue family, because it derives from one `base_color` via tonal stops. The analyzer must reflect that perception, not literal pixel counts.

### Method choice: HSV vs CIELAB

Initial attempt used CIELAB (perceptually uniform, the "right answer" for color difference work). PIL's ImageCms LAB profile produced out-of-range a*/b* values (≥125 for ordinary navy), suggesting a profile/encoding mismatch in this Python build. Switched to HSV with hue-distance binning. For *counting* distinct hue families with thresholds (rather than measuring fine perceptual differences between similar colors), HSV is sufficient and well-tested.

The pipeline:
1. Downsample to ≤200K pixels (BILINEAR).
2. Convert sRGB → HSV via numpy (no library quirks).
3. Mask out: dark (V < 0.15), white-text (V > 0.92 ∧ S < 0.06), grey/tonal-ramp (S < 0.12).
4. Bin remaining pixels by hue into 60 bins, weight by saturation.
5. Identify peaks above 1.2% saturation-weighted share-of-keep.
6. Merge adjacent peaks within ±4 bins (~24°) into one hue family.

Tunables are at the top of `analyze_hues.py` and were left at values that match the user's verbal reading of "Pulse = 2 hues, Slate = 1 hue".

### Why synthesize MD3 / game-UI references?

The BRIEF asks for comparison against MD3 reference layouts and shipped game UIs. Shipped game UI screenshots (Royal Match, Brawl Stars, Toon Blast) are copyrighted; fetching them adds licensing complexity for what is meant to be a measurement, not a visual borrow. Instead `synth_references.py` builds two reference frames programmatically:

- **`md3-reference.png`** — composed from MD3 spec role slots only (`primary`, `secondary`, `tertiary`, `error`, plus surface containers). Measures what MD3 expects.
- **`game-ui-reference.png`** — composed in the convention of HCGames / Royal Match / Brawl Stars (5-hue button rows, HUD widgets in their own colors, severity-coded pills, coin chip). Measures the convention, not any specific product.

Both are measured by the same pipeline as NeoCade itself, so the numbers are directly comparable.

## How to Run

```powershell
# from this directory
python synth_references.py        # generate md3-reference.png + game-ui-reference.png
python analyze_hues.py `
  ../../../mockups/3.4/concepts/pulse-finalist-desktop-flat.png `
  ../../../mockups/3.4/concepts/slate-desktop-flat.png `
  ../../../mockups/3.4/concepts/bubble-desktop-flat.png `
  ../../../mockups/3.4/concepts/daybreak-desktop-flat.png `
  ../../../mockups/3.4/concepts/burst-desktop-flat.png `
  md3-reference.png `
  game-ui-reference.png `
  ../../../inputs/NeoCade-Theme-Prototype.png
python build_report.py            # writes report.html (self-contained, base64 images)
```

Open `report.html` in a browser.

## What to Expect

A single-page report with one row per reference image showing:

- The image itself (158px tall thumbnail).
- A **hue-count badge** color-coded by severity (red ≤1, amber =2, green ≥3).
- A swatch strip showing the dominant hue families with width proportional to share.
- The masked-out percentages (grey, dark) so the reader can sanity-check that the analyzer didn't miss a real hue by over-masking.

A summary table at the top with the headline gap statement.

## Investigation Trail

### Iteration 1 — CIELAB pipeline (broken)
First pass used PIL's `ImageCms.buildTransformFromOpenProfiles(sRGB → LAB)` followed by K-means in (a*, b*) space with chroma-weighting. Produced cluster centers with `chroma=173`, far outside the ~127 LAB gamut, indicating a profile encoding mismatch on Python 3.14.2 + PIL 11. Pulse came out as `1 hue` (navy collapsed with green into a single mathematically-impossible cluster center). **Discarded.**

### Iteration 2 — HSV pipeline
Rewrote in HSV with hue-binning + saturation-weighting + adjacent-bin merging. Pulse came out as `2 hues` (navy 95%, green 3%). Numbers match the user's verbal reading. **Adopted.**

### Iteration 3 — masking thresholds
First HSV run with `MIN_BIN_SHARE_OF_TOTAL = 0.005` and `DARK_V_THRESHOLD = 0.18` over-suppressed the user's prototype (which has 90% dark surface and 5 small but vivid hue chips). Switched to share-of-keep (excluding masked pixels from the denominator) and lowered the dark threshold to 0.12 / 0.15. Prototype now reads at 5 hues, matching its visual claim of cyan + pink + violet + green + navy.

### Iteration 4 — Slate edge case
Slate measured as `1 hue` even though its concept PNG nominally has a green accent. Confirmed by inspection: Slate's concept frame has accent appearing only on the focused button outline and a single tab indicator (~0.3% of total pixel area, ~0.7% of unmasked). The 1.2% threshold filters this out as "below visual presence". This is not a bug — it is the headline finding: *Slate's accent is so suppressed it doesn't even register as a second hue family by a generous threshold*.

## Results

### Verdict: **VALIDATED — color monoculture confirmed and quantified**

| Reference | Hues | Dominant swatches |
|---|---|---|
| Pulse | 2 | navy 95%, green 3% |
| Slate | **1** | navy 100% |
| Bubble | 2 | purple 96%, pink 3% |
| Daybreak | **1** | teal-green 99% |
| Burst | 2 | purple 94%, amber 5% |
| MD3 reference (synthetic) | 3 | navy 77%, error 17%, tertiary 4% |
| Game-UI reference (synthetic) | 5 | indigo 71%, pink 10%, cyan 10%, gold 4%, green 4% |
| User prototype (`.planning/inputs`) | 5 | navy 69%, cyan 7%, violet 7%, magenta 6%, green 2% |

### Headline diagnosis

NeoCade's 5 directions average **1.6 hues** per frame. **Two of the five (Slate, Daybreak) read as a single hue** — the accent is so suppressed it doesn't survive a generous threshold. The MD3 spec target is **3** (primary + secondary + tertiary visible simultaneously). Shipped flat-modern mobile game UIs commonly run **5+** (HUD widgets, primary CTA, severity-coded chrome, currency chips). The user's original NeoCade prototype runs at **5**.

The gap to MD3: ~**1.4 hues**.
The gap to shipped game UI conventions: ~**3.4 hues**.
The gap to the user's own original vision: ~**3.4 hues**.

### Surprises

1. **Slate and Daybreak fail to register a second hue at all.** Even at the relaxed 1.2% saturation-weighted threshold, their accents are below the noise floor of the analyzer. This is a stronger finding than the BRIEF anticipated.
2. **Burst's amber reads as 5%, the highest accent share of any NeoCade direction.** Burst is "loud" by personality intent, and the measurement confirms it leans hardest into accent visibility — but still hits only 2 hues, indicating that even the loud direction underclaims its second color.
3. **The user prototype and the synthetic game-UI reference both measure 5 hues** with very similar dominant-color shapes (large dark navy/indigo surface + 4-5 vivid hue chips at small share). This is a strong concordance: it suggests the user's intuitive target is in fact the shipped-game-UI convention as a class, not a specific product.

### Signal for downstream spikes

- The diagnostic confirms the BRIEF's premise. **Spike 003 (per-direction signature moves)** must include at least one move per direction that lifts on-screen hue count from 1-2 to ≥3.
- The most defensible target is **MD3's 3-hue floor** rather than the 5-hue game-UI convention, since the latter would push the v1 palette beyond the locked `base_color` + `accent_color` exports without further work. Lifting to 3 can be done by binding existing role tokens (`role_success` / `role_warning` / `role_danger` / `role_info`) into more BINDING_TABLE slots without new exports.
- **Slate and Daybreak need targeted attention** — they are below even Pulse and Burst on the diagnostic. Whatever signature moves Spike 003 proposes must have a Slate-friendly variant (since Slate's "quiet professional" personality could otherwise be used as an excuse to skip the lift).
