# Mockup Revision 3 Handoff — Surgical Fix for Black Panel Edges

**Status:** Revision 2 (commit `a68a8a1`) succeeded on 5 of 6 issues — moods are now differentiated, primary buttons have correct color-tinted offsets, the slideshow works, and platform sizing visibly differs between desktop and mobile. **One issue remains:** the per-color offset fix only landed for accent-filled elements (primary buttons, selected tabs, selected rows, toggle thumbs). Surface-colored elements (panels, dialogs, popup overlays, brand-mark badges, state-strip cells, unselected tabs) still have near-black bottom edges in raised mode.

This is a small, surgical revision. Do not re-litigate any other rev-2 decision — the wider radius spread, the slideshow, the platform sizing, the mood differentiation, and the broader raised matrix are all working. The only fix needed is the offset-color computation for non-accent surfaces.

## The bug, root-caused

In `src/neocade-mockups.js` `deriveSurfaceRamp()` and `deriveTokens()`, the rev-2 fix introduced per-color offset tokens computed via `darken(color, 22%)` (HSL-lightness reduction). This works for bright accent-filled elements (e.g., Bubble's `#FFB3E6` accent at ~84% lightness has plenty of room to darken). But it **fails for already-dark surface colors**:

- Bubble's `surface_panel` ≈ `#2A1B2D` (~10% HSL lightness)
- `darken(#2A1B2D, 22%)` tries to subtract 22 lightness points → goes negative → clamps to 0 → renders as essentially black

Same failure mode for `surface_high`, `surface_overlay`, `surface_low`, and the brand-mark badge bg. Every dark-surface element ends up with a near-black bottom edge, which reads as Neobrutalism — exactly what the user rejected.

## The fix

Replace `darken(color, 22%)` with `mix(element_color, page_base_color, 40%)` for **all** offset tokens. This shifts each element's color 40% toward the page background, producing a "darker variant in the same hue family" that **never goes past the page base** and **never reaches absolute black**.

### Why mix-with-page-base is correct

For a panel surface like Bubble's `#2A1B2D` against the page base `#241326`:
- `mix(#2A1B2D, #241326, 40%)` = `0.6 × panel + 0.4 × base` ≈ `#28192C`
- Result: a slightly darker berry, in the same berry family as the panel, lighter than the page base — visible against the page as a "shadow" without going black

For an accent-filled button like Bubble's primary (`#FFB3E6`) against page base `#241326`:
- `mix(#FFB3E6, #241326, 40%)` ≈ `#A879B0`
- Result: a darker pink in the pink family — still visible, still in-hue, never black

For Pulse's green accent (`#8BFF6A`) against page base (`#151A2E`):
- `mix(#8BFF6A, #151A2E, 40%)` ≈ `#5BA346`
- Result: darker green, green family, visible

This single formula covers every element correctly: brights have room to "darken" toward the page; darks shift subtly toward the page without going past it. **Same hue family** is preserved at every brightness level.

### Implementation

In `src/neocade-mockups.js`:

1. **Replace the `darken()` helper** (or repurpose it) with a `tintTowardBase(elementHex, baseHex, ratio = 0.4)` function. Returns `mix(elementHex, baseHex, ratio)` using the existing `mix()` helper. Keep `darken()` if other code depends on it but stop using it for offsets.

2. **In `deriveSurfaceRamp()` and `deriveTokens()`**, change every offset-token computation from:

   ```js
   "--accent-offset":          darken(accent_color, 22),
   "--surface-panel-offset":   darken(ramp.surface_panel, 22),
   "--surface-high-offset":    darken(ramp.surface_high, 22),
   "--surface-overlay-offset": darken(ramp.surface_overlay, 22),
   "--surface-low-offset":     darken(ramp.surface_low, 22),
   ```

   to:

   ```js
   "--accent-offset":          tintTowardBase(accent_color,         base_color, 0.40),
   "--surface-panel-offset":   tintTowardBase(ramp.surface_panel,   base_color, 0.40),
   "--surface-high-offset":    tintTowardBase(ramp.surface_high,    base_color, 0.40),
   "--surface-overlay-offset": tintTowardBase(ramp.surface_overlay, base_color, 0.40),
   "--surface-low-offset":     tintTowardBase(ramp.surface_low,     base_color, 0.40),
   ```

   Verify in the rendered PNGs that no element's bottom edge appears black. Spot-check by zooming into the action-panel container of `bubble-mobile-raised.png` — its bottom edge should be a clearly darker berry, in the berry family, distinguishable from the page base but in the same hue range.

3. **Tune the `0.40` ratio if needed.** If after re-rendering the offsets look too subtle (i.e. you can barely see them), bump to `0.50` or `0.55`. If they look too prominent for surface elements (i.e. panels look like they're floating awkwardly), drop to `0.30-0.35`. The accent buttons may benefit from a slightly different ratio than the surfaces — feel free to use `0.45` for accent and `0.35` for surfaces, two separate constants. Pick whatever produces a clean "extruded-flat" look matching the user's PLAY-button reference.

4. **Optional, recommended:** add a 1px lighter rim on the top edge of accent-filled raised elements (the inner highlight visible on the user's PLAY-button reference). On the existing primary-button shadow declaration:

   ```css
   .mode-raised .nc-art-button.primary {
     box-shadow:
       0 var(--raise-button) 0 0 var(--accent-offset),
       inset 0 1px 0 0 color-mix(in srgb, var(--accent) 60%, white);
   }
   ```

   Skip this if it makes any direction's primary look gimmicky. It's a polish detail, not a binding requirement.

## Verify these other small things during the same pass

While you're re-rendering anyway, audit these too — they may already be working but could be auto-fixed by the offset-color change:

- **Unselected tabs (Cabinets / Profile / Settings in nav, Match / Audio in dialog stack):** per `directions.json` `axis_10_raised_lifts`, every direction includes `unselected-tabs`. Verify after the fix that unselected tabs visibly raise (tiny offset is fine; they shouldn't be flat). If they're not raising at all in any direction, ensure the CSS rule for unselected tabs has the `box-shadow` declaration in `.mode-raised`, not just selected tabs.
- **Brand-mark badge raised offset:** Bubble's circle brand mark, Pulse's square cabinet bezel, Burst's tilted asymmetric badge — all should have visible color-tinted offsets after the fix.
- **State-strip cells at the bottom of each artboard** (NORMAL / HOVER / FOCUS / PRESSED / DISABLED): each cell should have a visible color-tinted bottom edge in raised mode. They're demo cells but they raise too.
- **Selected list row** (e.g. Cabinet A): should visibly lift with a `--surface-high-offset` colored bottom edge.

If any of these still look black after the offset fix, that element's CSS rule probably uses the wrong offset variable (e.g. uses `--surface-low-offset` when it should use `--surface-panel-offset`). Trace each raised box-shadow declaration to its surface variable and verify alignment.

## Re-render and update audit

After the fix:

1. `node render.js concept-images` to re-render all 15 concept PNGs.
2. `node render.js` (default mode) to re-render `screenshots/color-overview.png`.
3. Re-render `screenshots/greyscale-sufficiency-test.png` via the existing render path.
4. Update `render-check.md` — change the per-direction "raised-mode feel" audit row from "appropriate" to a more precise "all raised elements use color-tinted offsets in their own hue family; no near-black bottom edges anywhere." Add a sentence to each direction's section confirming the fix landed for non-accent surfaces specifically.
5. The user's plan is to do a side-by-side compare between the rev-3 Bubble mobile-raised and the v0 `prize-pop-plaza-concept.png` — the mood they want recovered. Verify yourself by zooming into Bubble's primary button, panel container, popup surface, and brand mark; every bottom edge should be a clearly-pink-tinted darker shade.

## What NOT to change

- All other rev-2 decisions stand: corner radius spread (0/14/26/8/18), categorical shape variety, slideshow component, platform sizing values, broader raised matrix. Don't re-litigate.
- Direction names, palettes, locked architecture: untouchable.
- Phase 3.4 governance docs (CORRECTIVE-ADDENDUM, direction-shape-language-spec): unchanged.
- HTML structure of `concept-gallery.html`, `concept-image.html`, `finalist-gallery.html`: unchanged.
- v0 historical artifacts (`.planning/mockups/concepts/`, `.planning/mockups/03-direction-boards.*`): untouched.

## Stop point

After re-rendering and verifying, the Plan 02 user gate **remains open** at finalist-selection (Task 4 in `03.4-02-stage-1-concept-boards-and-finalist-selection-PLAN.md`). Do not auto-select finalists. The user reviews rev-3 PNGs and either picks finalists, requests another revision, or asks for the recommended-starter call.

## Commit style

```
fix(03.4-02): mockup revision 3 — color-tinted offsets on all raised surfaces (no black panel edges)
```

Body should:
- Note the rev-2 issue (offset fix only landed for accent-filled elements; surface-colored elements still rendered near-black due to `darken()` flooring on dark surfaces).
- State the fix (replace `darken(color, 22%)` with `mix(element_color, page_base, 40%)`).
- List the elements now correctly tinted (panels, dialogs, popup overlay, brand mark, state-strip cells, unselected tabs, selected list rows).
- Confirm 15 PNGs + 2 audit composites re-rendered.
- Confirm `render-check.md` updated.
- End with the standard `Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>` line.
