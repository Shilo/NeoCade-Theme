# Gallery Layout Handoff — Image-Primary Vertical Stack

**Goal:** Reflow `concept-gallery.html` so each direction reads as **image-first**, with the desktop mockup as a hero at full available width, the two mobile mockups in a pair below it, and ALL text (title chip, copy, specs) below that. The current layout puts images on the left and text on the right — the user wants images dominant, text supporting.

**Scope:** CSS layout rules only. The HTML structure and JS renderer already produce all the right elements; nothing in the structure or in the rendered PNGs changes.

## What stays exactly the same

- `concept-gallery.html` HTML structure — every `<section class="nc-direction-section">` already contains the three `<figure class="nc-concept-card">` elements (one per variant) and the brief container in the right order.
- `src/neocade-mockups.js` renderer — `directionConcept()` and `fillDirectionSection()` already emit the correct DOM. Do not touch.
- The 15 concept PNGs in `concepts/` — do NOT re-render. Layout reflow doesn't change the underlying mockups.
- `concept-image.html`, `finalist-gallery.html`, the `screenshots/` audit composites, `render.js`, `render-check.md`, `data/directions.json`, `image-prompts/direction-shape-language-spec.md` — none of these change.

## What to change

Only `.planning/mockups/3.4/src/neocade-mockups.css` — specifically two rules around lines 125-140.

### 1. `.nc-concept-layout` — switch from 2-column to 1-column stack

Currently (around line 125):

```css
.nc-concept-layout {
  display: grid;
  grid-template-columns: minmax(640px, 1.3fr) minmax(320px, 0.7fr);
  gap: 18px;
  align-items: stretch;
  padding: 18px;
  background: var(--panel);
  border-bottom: 1px solid var(--line);
}
```

Replace with:

```css
.nc-concept-layout {
  display: grid;
  grid-template-columns: 1fr;
  gap: 24px;
  padding: 24px;
  background: var(--panel);
  border-bottom: 1px solid var(--line);
}
```

This stacks the children vertically: image grid first, brief below.

### 2. `.nc-concept-image-grid` — desktop full width on top, two mobiles below

Currently (around line 135):

```css
.nc-concept-image-grid {
  display: grid;
  grid-template-columns: minmax(0, 1fr) repeat(2, minmax(160px, 0.42fr));
  gap: 12px;
  align-items: start;
}
```

Replace with:

```css
.nc-concept-image-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 16px;
  align-items: start;
}

/* Desktop variant spans the full width row above the two mobile columns. */
.nc-concept-card[data-concept-variant="desktopFlat"] {
  grid-column: 1 / -1;
}
```

This produces a 2-row layout:
- Row 1: desktop card spanning both columns (full width)
- Row 2: mobile-flat (left col) + mobile-raised (right col)

The existing `aspect-ratio: 16/9` (desktop) and `aspect-ratio: 430/932` (mobile) rules at lines 153-158 already make each image render at the right shape — no change needed there.

### 3. Optional: cap desktop image max-width for ultrawide screens

On an ultrawide monitor the desktop image at 16:9 full-width can become absurdly tall (e.g., ~1100px tall on a 2000px-wide page). Reasonable cap:

```css
.nc-concept-card[data-concept-variant="desktopFlat"] img {
  max-width: 1280px;             /* native render width */
  margin-inline: auto;            /* center when capped */
  aspect-ratio: 16 / 9;           /* (already set; restate to override the bare width:100% above) */
}
```

If this looks too constrained on regular widescreen monitors, raise the cap or remove it. The priority is "image is dominant"; some sense of cap just prevents absurdity on ultrawide.

### 4. Optional: cap brief max-width for readability

Long-line prose is hard to read at 1600px. Cap the brief:

```css
.nc-concept-brief {
  display: grid;
  align-content: start;
  gap: 14px;
  min-width: 0;
  max-width: 880px;               /* readable measure */
  /* don't margin-auto — let it left-align under the images */
}
```

### 5. Verify the responsive breakpoint still makes sense

The existing media query around line 209-211:

```css
@media (max-width: 1100px) {
  .nc-header,
  .nc-concept-layout,
  .nc-concept-image-grid { grid-template-columns: 1fr; }
}
```

At narrow widths this currently collapses the image grid to a single column too — meaning on a narrow viewport the user gets desktop, then mobile-flat, then mobile-raised stacked vertically. After your change `.nc-concept-layout` is already 1-column at all widths, so that part of the media query is redundant. Keep `.nc-concept-image-grid { grid-template-columns: 1fr; }` so the two mobile cards stack on narrow viewports too — that's the right behavior. Remove the `.nc-concept-layout` line from the breakpoint since it's already 1-column.

## Verification

After editing the CSS, verify in the browser:

1. Open `file:///.../concept-gallery.html` (use absolute file:// URL).
2. Confirm each direction section reads top-to-bottom as: **desktop hero image → two mobile images side-by-side → title/chip/copy/specs**.
3. Resize the window to ~900px wide and confirm the two mobile images stack into a single column gracefully.
4. Resize to ~2000px wide and confirm the desktop image doesn't become absurdly tall (the optional max-width cap helps here).
5. Confirm the page is internally consistent across all 5 direction sections (Pulse, Slate, Bubble, Daybreak, Burst).

No need to re-render any PNGs. No need to update `render.js` or anything outside the CSS file.

## Hard rules

- Do NOT modify HTML structure of `concept-gallery.html` — the existing element order and class names already produce the right DOM.
- Do NOT modify `src/neocade-mockups.js` — the renderer is already correct.
- Do NOT modify any of the 15 PNGs in `concepts/`. Layout is not mockup content.
- Do NOT touch `concept-image.html` (internal render template), `finalist-gallery.html` (Plan 03 placeholder), `screenshots/*.png` (audit composites), or anything outside `.planning/mockups/3.4/`.
- Keep all changes confined to `src/neocade-mockups.css`.

## Commit style

When done:

```
style(03.4-02): reflow concept gallery to image-primary vertical stack
```

Body should note the layout change (desktop hero + two mobiles below + brief at bottom) and confirm no HTML/JS/PNG changes.
