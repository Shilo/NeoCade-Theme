# Mockup Revision 4 Handoff — Selective Alpha for Mood Tuning

**Status:** Apply AFTER rev-3 (`MOCKUP-REVISION-3-HANDOFF.md`) lands and the panel-edge fix is verified visually. Rev-4 is small mood-tuning that adds selective alpha (translucency) where it enhances the existing 5 directions' personalities, plus a universal modal scrim that all directions get for free.

This is small. Don't conflate it with rev-3's offset-color fix; that's independent and bigger.

## Background

User asked: "in v0 some themes had different mood for the opacity… this is very much possible in godot. when applicable to the theme's mood, it should also associate alpha value into its theme. you do research and choose what you think is best. must be entirely reasonable and not out of place."

Research summary (full version in chat history before this handoff):

- **Godot StyleBoxFlat supports alpha** on `bg_color`, `border_color`, `shadow_color`. Backdrop blur is NOT supported (would need shaders or textures, both anti-features) so glassmorphism is off the table.
- **Five common alpha patterns** in UI: modal scrim, translucent panels, glass/frosted, outlined/wireframe, state-layer overlays. Glass is the only one that's technically blocked; the others all work.
- **Mood fit varies per direction.** Solid wins for cabinet/candy/event personalities (Pulse, Bubble, Burst). Subtle alpha enhances iOS-clean and welcoming-lobby personalities (Slate, Daybreak).
- **No 6th wireframe direction in v1.** Phase 3.3 approval is locked; reopening for a 6th is too disruptive. Architecture (single concrete class + data-only `.tres` per direction) supports adding it in v1.x without breaking changes.

## Tier 1 — universal modal scrim (all 5 directions)

Every direction's popup/dialog needs a translucent backdrop that dims the page behind it. This is Material 3 + iOS HIG standard practice and isn't really mood differentiation; it's just-good-UX.

### Implementation

In `src/neocade-mockups.css`, add a backdrop element behind raised popup surfaces (or as a `::before` on the popup container if the backdrop is part of the same element). Recommended values:

```css
.nc-art-dialog-backdrop {
  position: absolute;
  inset: 0;
  background: rgba(0, 0, 0, 0.50);   /* MD3-comparable scrim */
  pointer-events: none;
  z-index: -1;                        /* behind the dialog content */
}

/* OR, simpler: pseudo-element on the dialog container */
.nc-art-dialog::before {
  content: "";
  position: absolute;
  /* extend to cover the artboard area behind the dialog */
  /* … */
  background: rgba(0, 0, 0, 0.50);
}
```

Note: in the current artboard layout, the popup surface lives inside the dialog stack panel — not as a true modal full-page overlay — so a literal page-covering scrim might not be visually appropriate at this mockup level. Pragmatic alternative: render a **subtle inset scrim** behind the popup surface that visually separates it from its parent panel. Something like:

```css
.nc-art-dialog {
  position: relative;   /* establishes containing block for the scrim */
}
.nc-art-dialog::before {
  content: "";
  position: absolute;
  inset: -8px;          /* extends slightly beyond the dialog into parent panel */
  background: rgba(0, 0, 0, 0.30);
  border-radius: inherit;
  z-index: -1;
  pointer-events: none;
}
```

If this looks awkward in the rendered PNG, drop it. The literal full-page-scrim only matters when the popup is a real modal overlay over the whole screen — which is a Phase 4 implementation detail in Godot, not a Phase 3.4 mockup detail. Use your judgment.

**Important:** the scrim is a UNIVERSAL behavior. Don't add per-direction variation here.

## Tier 2 — per-direction subtle alpha (Slate + Daybreak only)

Two directions benefit from subtle translucency on overlay/panel surfaces. The other three stay 100% solid.

### Slate — overlay translucency only

Slate's iOS-premium mood matches iOS's actual NavigationBar/Sheet/modal-backdrop translucency. Adjust:

- **`popup_surface` background**: 92% alpha — `Color(0xR, 0xG, 0xB, 0.92)` where the RGB is the existing `surface_overlay` color. The remaining 8% lets the underlying panel slightly bleed through.
- **All other surfaces**: 100% solid (no change).

In `data/directions.json` Slate `shape_language`, add a new axis:

```json
"axis_11_surface_alpha": {
  "popup_surface": 0.92,
  "panels": 1.00,
  "buttons": 1.00,
  "chrome": 1.00
}
```

Mirror to JS `NEOCADE_DIRECTIONS[Slate].shape` and have the renderer emit `--surface-overlay-alpha: 0.92` (etc.) as inline CSS variables; CSS rules apply alpha via `color-mix(in srgb, var(--surface-overlay) 92%, transparent)` or by computing the rgba directly in JS.

### Daybreak — overlay + container translucency

Daybreak's airy welcoming-lobby mood benefits from light translucency throughout. Adjust:

- **`popup_surface` background**: 90% alpha (slightly more translucent than Slate — leans into the airy lobby feel).
- **Container panels** (action panel, dialog stack, list/tree containers): 96% alpha (very subtle — just enough to "lift" the feel without becoming visually weak).
- **Buttons, chips, brand mark, list rows**: 100% solid (interactive elements stay defined and tappable).

In `data/directions.json` Daybreak `shape_language`:

```json
"axis_11_surface_alpha": {
  "popup_surface": 0.90,
  "panels": 0.96,
  "buttons": 1.00,
  "chrome": 1.00
}
```

### Pulse, Bubble, Burst — stay solid

```json
"axis_11_surface_alpha": {
  "popup_surface": 1.00,
  "panels": 1.00,
  "buttons": 1.00,
  "chrome": 1.00
}
```

Justification:
- **Pulse** — cabinet panels are solid hardware. Translucent cabinets read as "futuristic glass UI" not "arcade machine."
- **Bubble** — candy is opaque. Translucent candy reads as ice/gelatin, which shifts the mood toward sci-fi.
- **Burst** — celebration posters are solid. Translucent achievement screens feel weak, not bold.

## Update render-check.md

Add a new audit row per direction:

| Direction | Surface alpha policy | Visible in renders |
|---|---|---|
| Pulse | 100% solid (cabinet hardware) | Solid panels, fully-opaque popup |
| Slate | popup 92%, rest 100% (iOS-style overlay translucency) | Subtle bleed-through visible behind popup surface only |
| Bubble | 100% solid (candy is opaque) | Solid panels, fully-opaque popup |
| Daybreak | popup 90%, panels 96%, rest 100% (airy lobby) | Subtle translucency visible through panels and stronger through popup |
| Burst | 100% solid (poster-bold) | Solid panels, fully-opaque popup |

Plus a "modal scrim" row noting all 5 directions get the universal scrim behind dialogs (or skip if Tier 1 implementation didn't visibly help in the mockups).

## Verification

After re-rendering:

1. **Slate overlay translucency**: open `slate-mobile-raised.png`. The popup surface (containing "Popup surface… Primary action…") should have a SUBTLY visible bleed-through where the panel behind it shows faintly through the popup. Not so much that the popup looks weak — just enough that you can sense the layered depth.
2. **Daybreak airy panels**: open `daybreak-mobile-raised.png` and `daybreak-desktop-flat.png`. The action-panel and dialog-stack containers should feel airier — like the page background is faintly visible through them. The popup surface should feel even more translucent than the panels.
3. **Pulse / Bubble / Burst**: should look IDENTICAL to rev-3 (no alpha changes). If anything looks different, you've over-applied tier 2.
4. **Modal scrim**: if the dialog scrim implementation took, the popup should feel slightly "lifted" off the parent panel. If the inset-scrim approach makes the popup look bordered or boxed-in, drop it; the universal scrim is more meaningful in real Godot UI than in this mockup artboard.

## Don't do these (out of scope for rev-4)

- **Don't add a 6th direction.** Phase 3.3 approval is locked. A wireframe/HUD direction is queued for v1.x; not v1.
- **Don't add alpha to button surfaces in any direction.** Buttons should stay opaque so they remain visually solid affordances. The MD3 outlined-button variant (transparent fill + border) is a different conceptual style that conflicts with all five v1 personalities.
- **Don't apply alpha to hover/pressed state layers.** The state-layer alpha system (already in v1 via `--state-hover` / `--state-pressed` mix) is correct as-is. Don't change it.
- **Don't change anything from rev-3.** The offset-color fix from rev-3 must be in place before rev-4 — alpha tuning on top of black-edged panels won't fix the panel issue.

## Re-render

```
node render.js concept-images
node render.js                    # color-overview
# greyscale rerun via existing render path
```

Update `render-check.md` per Tier 1 and Tier 2 audit rows above.

## v1.x note (for the project changelog, not for this handoff)

Add a line item to a future v1.x roadmap: **Wireframe / HUD direction** — transparent fills + strong colored borders, for "futuristic UI / AR overlay / schematic" mood. Architecture supports adding this as a new `.tres` without code changes. Defer.

## Stop point

Plan 02 user gate remains open at finalist-selection. Don't auto-select.

## Commit style

```
feat(03.4-02): mockup revision 4 — selective alpha for Slate + Daybreak mood tuning
```

Body should:
- State the scope (universal modal scrim + Slate overlay translucency + Daybreak panel/overlay translucency; Pulse/Bubble/Burst unchanged).
- Note the v1.x deferral of a 6th wireframe direction.
- Confirm 15 PNGs + 2 audit composites re-rendered.
- Confirm `render-check.md` updated with surface-alpha policy rows.
- End with the standard `Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>` line.
