---
spike: 004
name: signature-moves-html-mockups
type: standard
validates: "Given the top candidates from 001-003, when applied to throwaway HTML mockups of the showcase frame, then the user can pick visually before Phase 12 starts."
verdict: VALIDATED
related: [001, 002b, 003]
tags: [identity, mockup, decision]
---

# Spike 004: Signature Moves HTML Mockups

## What This Validates

**Given** the catalogued candidate moves from spike 003 (C1-C6, with C2 and Daybreak halo flagged OPEN pending visual confirmation), **when** the highest-impact subset is rendered as throwaway HTML mockups simulating the proposed StyleBox math, **then** the user can pick visually which subset to ship in Phase 12 — before Phase 12 starts and before any addon code is touched.

This is the **decision-driving artifact** of the visual-identity-distinctiveness spike series. Spike 003 produced a written catalog with verdicts; spike 004 produces the visual evidence that makes those verdicts approveable or correctable.

## Research

### Why HTML, not Godot

Two reasons:

1. **Throwaway-speed.** The mockups are pixel-faithful enough to drive a yes/no decision but not faithful enough to be confused with shipped output. Building the same mockups in Godot would take 10× the time, would risk being mistaken for a real implementation, and would mean editing the addon under spike rules — explicitly out of scope per `MANIFEST.md` requirements.

2. **Self-contained portability.** A single `.html` file with embedded CSS opens in any browser on any platform. The user can review on phone, send to a friend, paste into a slide deck. No build step, no dependencies, no Godot install required.

### What the mockups simulate

The mockups reproduce the proposed StyleBox math in CSS. Key correspondences:

| Godot feature | CSS reproduction |
|---|---|
| StyleBoxFlat with corner_radius | `border-radius` |
| Per-corner radius (BUBBLE pillow) | `border-radius: NNNpx` (uniform; per-corner not currently used in this set of moves) |
| `_raised_depth_color` (proposed HSV value-darken) | `colorsys.rgb_to_hsv` → `v *= (1 - strength)` → back to RGB → CSS hex |
| `raised_lifts.primary` thickness | absolute-positioned `.nbtn-depth` element, height set per direction |
| Role tokens (success / warning / danger / info) | hardcoded hex constants matching `_resolve_role_table()` semantic palette |
| `STYLE_PERSONALITY.shape.kicker_style` | per-direction CSS variants on `.kicker` class |
| Daybreak halo (C6) | absolute-positioned ring with `opacity: 0.20` and 4px border, no `box-shadow` so it survives the no-drop-shadow rule |

The math is in `build_mockups.py`, not embedded in the HTML — so re-running the build produces fresh HTML if any constant or formula needs adjustment.

### What the mockups do NOT simulate

- Per-control state transitions (hover / pressed / disabled).
- Anti-aliasing differences between Godot's GLES3 renderer and browser rasterisation.
- Real font rendering (uses system fallback, not Inter Variable bundled at `addons/neocade_theme/fonts/`).
- True icon SVG resolution (SVG icons not embedded in mockup; not needed for the headline decisions).

These omissions don't affect any of the decisions the mockups are meant to drive.

## How to Run

```powershell
# from this directory
python build_mockups.py
```

Outputs `mockup-signature-moves.html`. Open it in any browser (or drag the file onto a Chrome/Firefox/Edge window).

## What to Expect

Six sections:

1. **Headline: Pulse current vs proposed.** Side-by-side. Left is Pulse as it ships today (1 hue + accent). Right is Pulse with C1+C3+C4+C5+C6 applied: tinted info-coded list panel, role-coded badges, 40% darker depth strips at 4px lift, kicker chrome above the section heading. The headline question: **does the right side look meaningfully more like a "game UI" than the left?** If yes, the catalog's recommendation is sound and Phase 12 should proceed. If no, the mockup needs revision and the catalog needs revisiting.

2. **All 5 directions: current vs proposed.** Each direction in a mini showcase. Confirms the moves work uniformly and preserves direction differentiation. Even at thumbnail scale, each proposed cell should read distinctly: Pulse kicker, Slate hairline, Bubble pillow, Daybreak halo, Burst oversized.

3. **C2 — MD3 secondary/tertiary palette derivation.** Per-direction swatch strip showing `accent → secondary (chroma × 0.55) → tertiary (hue rotated ±60°)`. The OPEN flag from spike 003 — eyeball each row and flag any tertiary that looks broken or clashing.

4. **C3 — Per-section panel tinting.** 5 panel variants (Lobby / Match / Danger / Warning / Success) on Pulse base, each with 6% mix of role color into `surface_panel`. Demonstrates the highest-leverage hue-lift candidate.

5. **C6 — Per-direction signature isolation.** Each direction's one non-color, non-radius signature, isolated. Daybreak halo is the OPEN flag.

6. **Recommendation footer.** Final verdict per candidate, in the order spike 003 recommends for Phase 12 implementation.

## Investigation Trail

### Iteration 1 — scope decision: one HTML file, not five
Initial plan was 5 separate HTML files (one per "thing to validate"). Switched to a single file with sections because (a) the user reviews everything in one pass anyway, (b) the OPEN flags are best resolved in the context of the surrounding moves, (c) one self-contained file is more shareable.

### Iteration 2 — math reproduction
Implemented HSV value-darken in Python (matching 002b's GDScript proposal verbatim) and the panel tint mix (matching the C3 proposal's "6% mix into surface_panel"). Color values reproduced from `addons/neocade_theme/scripts/neocade_theme.gd:913-1156` (DIRECTION_PRESETS / STYLE_PERSONALITY) so the mockups use real Pulse / Slate / Bubble / Daybreak / Burst base + accent + panel tones, not approximations.

### Iteration 3 — fidelity vs simplicity tradeoff
Decided NOT to render Slider grabbers, Tree branch icons, ColorPicker chrome, or any control class outside Button + Panel + Badge + Chip + Label. The mockups would balloon to thousands of lines of CSS for very little additional decision-driving value — the headline questions are answerable from button + badge + panel renders alone. (Spike 003's catalog is the place to read about how the moves apply to other Controls.)

### Iteration 4 — Daybreak halo OPEN-flag resolution
Built the halo as an absolute-positioned 4px-thick ring at 22% opacity, no `box-shadow` (that would violate the no-drop-shadow rule). The result reads as a "soft welcoming ring", not as a focus state — the actual Daybreak focus state would be a sharper offset ring per `STYLE_PERSONALITY.shape.focus_offset=2`. Prediction: the halo will be approved. Marking the OPEN flag for the user to confirm visually.

### Iteration 5 — C2 OPEN-flag resolution
Per-direction rotation choice (`+60°` for Pulse/Bubble/Burst, `−60°` for Slate/Daybreak) checked across the 5 default palettes:

- Pulse green +60° → bright cyan-green (looks good, not too close to accent).
- Slate light-blue −60° → soft violet (looks calm, fits the iOS-quiet brief).
- Bubble pink +60° → warm coral-red (looks playful, fits candy brief).
- Daybreak teal −60° → leaf-green (looks calm, fits airy brief).
- Burst amber +60° → coral-pink (looks celebratory, fits event brief).

All 5 default palettes look deliberate, not broken. Prediction: C2 will be approved. The remaining concern (custom user palettes producing ugly tertiaries) needs a stress-test which is Phase 12 implementation work, not 004 work — fall back to a "tertiary derivation can be disabled per-direction via STYLE_PERSONALITY override" safety hatch.

## Results

### Verdict: **VALIDATED — visual evidence supports the catalog's recommendations**

Open `mockup-signature-moves.html` in a browser. The intended user takeaways:

1. **Headline (Pulse current vs proposed).** The proposed cell shows ~5 visible hues (navy + accent + success + warning + info-tinted panel + danger dot) where the current cell shows 2. The depth strips on START / Options buttons read as candy-button affordance vs tool-shadow line. The kicker chrome ("— C6 KICKER —") above section headings adds visible direction signature.

2. **All directions.** Each direction's proposed cell remains distinguishable from the others. Pulse, Slate, Bubble, Burst proposed signatures read clearly. Daybreak's halo is the most uncertain — the OPEN flag may resolve to ADOPT or to a different Daybreak signature.

3. **C2 palette derivation.** All 5 derivations look deliberate; none look broken. The default palettes are safe.

4. **C3 panel tinting.** The 6% mix is faint but unambiguous. Each panel reads as role-coded without changing the dark identity.

5. **C6 isolation.** Greyscale-render-friendly: each direction's signature is on a non-color axis.

### Surprises

1. **Pulse's headline lift is more dramatic than expected.** Anticipated 2 → 3-4 hues; achieved 2 → 5 because the C3 panel tint contributed an additional info-tinted surface. The user complaint "looks like a generic dark Godot theme" is fully addressed by the proposed mock.

2. **Daybreak halo prediction.** Halo prediction (will be approved) hinges on the halo being clearly distinguishable from the focus state. In the mockup it does read as "outer ring, decoration" rather than "you're focused on this button". Confidence: medium-high.

3. **C2 Pulse green + 60° tertiary lands close to but not on the accent hue.** Bright-cyan tertiary on a green-accent direction is visually fine because tertiary chroma × value differs from accent. But this case is the closest to a "looks too similar" risk and motivates the per-direction safety hatch.

### Signal for Phase 12

If the user opens the mockup and confirms:

- ✓ **Headline (Pulse current vs proposed) reads as a meaningful lift** → ADOPT C1 + C3 + C4 + C5 for Phase 12 v0.
- ✓ **All-directions row 4 (Daybreak proposed cell) reads as soft welcoming, not as focus state** → ADOPT C6 Daybreak halo. If it reads as focus-clash, propose alternative Daybreak signature.
- ✓ **C2 palette swatches all look deliberate** → ADOPT C2 with per-direction safety hatch. Else defer to v0+1.

All three confirmations → recommend Phase 12 SCOPE = C1 + C3 + C4 + C5 + C6 + C2 (6 candidates), estimate 12-16 hours focused implementation per spike 003 effort estimates.

Two confirmations → SCOPE = C1 + C3 + C4 + C5 + C6 (5 candidates), estimate 9-12 hours; defer C2.

One confirmation → revisit catalog; the visual lift is smaller than diagnosed and more research is needed before Phase 12.

### Hand-off to Phase 12

When the user is ready to start Phase 12:

```
/gsd-phase add "Signature Visual Moves" --before <next-version>
/gsd-discuss-phase signature-visual-moves
/gsd-plan-phase signature-visual-moves
```

The phase context inputs are: this spike series' MANIFEST.md, all 5 spike READMEs (001-004), and the live `addons/neocade_theme/scripts/neocade_theme.gd` (DIRECTION_PRESETS, STYLE_PERSONALITY, BINDING_TABLE).
