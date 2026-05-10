---
spike: 005
name: before-after-comparison
type: deliverable + tooling
related: [001, 002a, 002b, 003, 004]
tags: [identity, mockup, screenshot, comparison, tooling]
---

# Spike 005: Before / After comparison artifacts

A user-facing decision artifact for the refined Phase 12 plan: a
forward-looking HTML mockup of what the changes will look like, a Godot
script that captures real screenshots of every theme variant, and a
comparison website that hosts BEFORE (real screenshots) and AFTER
(populated after Phase 12 ships) side-by-side.

## What's in this directory

| File | Purpose |
|---|---|
| [`mockup-refined-plan.html`](mockup-refined-plan.html) | Forward-looking HTML mockup. All 5 themes × BEFORE/AFTER on a game-shaped layout (HUD strip, hero, tabs, card grid, bottom nav). Captures HCGames + LDtk + MD3 Expressive spirit. Self-contained, browser-openable, ~37 KB. |
| [`comparison.html`](comparison.html) | Comparison website skeleton. Real Godot screenshots of each direction × flat/raised on the left (BEFORE), placeholders on the right (AFTER) that auto-populate once Phase 12 ships and `phase=after` capture runs. Self-contained, browser-openable, ~25 KB. |
| [`capture_screenshots.gd`](capture_screenshots.gd) | Godot `SceneTree` script. Boots `showcase/showcase.tscn` in a hidden SubViewport, iterates through all 5 styles × {flat, raised} = 10 captures, saves PNGs + manifest JSON to `screenshots/<phase>/`. |
| `screenshots/before/` | 10 BEFORE PNGs (1280×800, RGBA8). Captured 2026-05-10 against commit `96b4e52` (color_hue perf only — no visual changes vs 53df7dc). |
| `screenshots/before/manifest.json` | Machine-readable index of BEFORE captures (slug, style label, raised, dimensions, byte size). Drives `comparison.html`'s placeholder swap. |
| `screenshots/after/` | (empty) Will hold AFTER PNGs once Phase 12 ships and `phase=after` capture runs. |

## What got captured (BEFORE)

10 PNGs at 1280×800 RGBA8 (each ~4.1 MB):

```
screenshots/before/
├── pulse-flat.png        ← navy + lime, radius 0
├── pulse-raised.png
├── slate-flat.png        ← slate + sky blue, radius 14
├── slate-raised.png
├── bubble-flat.png       ← berry + bubblegum, radius 26/999 pill
├── bubble-raised.png
├── daybreak-flat.png     ← teal + mint, radius 8
├── daybreak-raised.png
├── burst-flat.png        ← plum + gold, radius 18-28
└── burst-raised.png
```

Each renders the actual `showcase/showcase.tscn` Control tree with the
direction's style applied via the canonical resource path. Same code path
the end user sees.

## How to capture

### Required

- Godot 4.6.2-stable binary
- A display server (the capture script needs OpenGL — does NOT work under
  `--headless` because Godot's dummy rasterizer can't paint a viewport)

### Command

```powershell
# Capture BEFORE (re-run if you want to refresh against current HEAD)
& "C:\Program Files\Godot\Godot_v4.6.2-stable_win64.exe\Godot_v4.6.2-stable_win64.exe" `
    --script .planning/spikes/visual-identity-distinctiveness/005-before-after-comparison/capture_screenshots.gd `
    -- phase=before

# Capture AFTER (run this after Phase 12 ships)
& "C:\Program Files\Godot\Godot_v4.6.2-stable_win64.exe\Godot_v4.6.2-stable_win64.exe" `
    --script .planning/spikes/visual-identity-distinctiveness/005-before-after-comparison/capture_screenshots.gd `
    -- phase=after
```

The script:

1. Loads the canonical `addons/neocade_theme/neocade_theme.tres` and instances
   `showcase/showcase.tscn` into a hidden `SubViewport` at 1280×800.
2. For each of 10 (style × raised) configurations: duplicates the theme,
   applies the style + raised flag + DESKTOP platform, waits 6 frames for
   layout + regen to settle, captures via
   `viewport.get_texture().get_image().save_png(...)`.
3. Writes a `manifest.json` alongside the PNGs.
4. Quits with exit code 0 on success, 1 if any capture failed.

The script briefly flashes a Godot window because OpenGL needs a display.
Total runtime: ~3-5 seconds.

### Verification after running

```powershell
ls .planning/spikes/visual-identity-distinctiveness/005-before-after-comparison/screenshots/<phase>/
# Should show 10 PNGs + manifest.json. Each PNG ~4.1 MB.
```

Open `comparison.html` in a browser. The `<phase>` shots populate
automatically (BEFORE is direct `<img>` tags; AFTER is fetched lazily via
`screenshots/after/manifest.json` if present).

## Forward-looking mockup vs real screenshots

`mockup-refined-plan.html` is a **CSS-rendered mockup**, not real Godot
rendering. CSS gives a reasonable preview of what Theme/StyleBox primitives
can do, but pixel-perfect parity is not guaranteed. Use it to approve
SPIRIT/DIRECTION before Phase 12 starts; use `comparison.html` (with real
AFTER shots) to verify after Phase 12 ships.

The two artifacts cover different decision points:

| Artifact | Used when | Decides |
|---|---|---|
| `mockup-refined-plan.html` | Before Phase 12 starts | Whether to approve the refined plan (C2'+C4+C6+C1+C3) |
| `comparison.html` (BEFORE only) | Before Phase 12 starts | What the gap actually looks like in real Godot rendering today |
| `comparison.html` (BEFORE + AFTER) | After Phase 12 ships | Whether Phase 12's implementation actually delivers the promised changes |

## Honest disclaimers

- **The hidden SubViewport still needs a display server.** Godot's
  headless renderer (`--headless`) uses a dummy backend that returns null
  textures. The capture script attempts headless first as a courtesy log
  line but actually requires a windowed Godot run. CI environments without
  a display will need xvfb on Linux or a virtual display on Windows.
- **Showcase header text is hardcoded.** The "Pulse starter style" label
  in the top-left of every screenshot is static text in `showcase.tscn`,
  not theme-dependent. The chrome around it is correctly rendered with
  the active direction's theme. Don't read the text — read the chrome.
- **Mockup uses CSS approximations.** HSV value-darken is computed in
  inline CSS; real Godot rendering will use the actual replacement formula
  Phase 12 implements (likely `Color.from_hsv(h, s, v * (1.0 - strength))`).
  Slight pixel differences are expected.
- **BEFORE PNGs are large** (~4.1 MB each, 41 MB for the set). Committed
  as-is because the comparison artifact must remain self-contained and
  reproducible.

## Connection to other spikes

- [001](../001-color-monoculture-diagnostic/) measured the color
  monoculture numerically. The BEFORE shots here are visual evidence for
  the 001 numbers.
- [002a](../002a-raised-depth-formula-current/) /
  [002b](../002b-raised-depth-formula-hsv-darken/) chose the C4 depth
  formula. The Pulse / Bubble / Burst raised BEFORE shots in
  `comparison.html` show the current ~23% darkening that C4 will replace
  with HSV value-darken at ~40%.
- [003](../003-per-direction-signature-move-catalog/) catalogued the
  refined Phase 12 moves. `mockup-refined-plan.html` is the visual
  rendering of that catalog.
- [004](../004-signature-moves-html-mockups/) produced the original
  6-candidate mockup. This spike (005) is the **refined** mockup after
  the user-driven scope narrowing of 2026-05-10 — drops C2, C5; reframes
  C1 + C3 as opt-in only with generic names.

## When to re-run

- **Re-run BEFORE capture** if the live theme code changes meaningfully
  before Phase 12 starts (e.g., a hotfix lands). The current BEFORE
  baseline is against commit `96b4e52`.
- **Run AFTER capture** as soon as Phase 12 implementation lands. Both
  artifacts (`mockup-refined-plan.html` and the AFTER cells in
  `comparison.html`) become outdated checks the moment real shots exist.
