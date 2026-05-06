# Fixed Concept Image Control Order — DEPRECATED 2026-05-06b

**Status:** DEPRECATED. This spec is superseded by `direction-shape-language-spec.md` in this same directory.
**Replaced:** 2026-05-06b
**Reason:** This spec correctly held the control order, content, and layout identical across the five directions, but it implicitly held shape-language tokens (corner radius, button anatomy, density, brand-mark style, focus rings, type weights, surface ramp depth, state-layer behavior, raised offset depth, chip/tab anatomy) identical too — collapsing all five directions to "the same UI with a color swap" when Plan 02 rendered. The user rejected the resulting 15 PNGs because no direction-specific personality came through.

The replacement spec preserves the same-screen / same-controls / same-order comparison contract (which the user explicitly wants, so the differences between directions are honestly comparable) and adds an explicit ten-axis shape-language differentiation channel that each direction must commit values on.

**Do not consume this file.** Read `direction-shape-language-spec.md` instead.

## Original spec (preserved for audit trail)

The text below is the original spec as written by Codex on 2026-05-06. It is preserved here so that future audits of "what went wrong with Phase 3.4 Plan 02 first execution" can reference what the executor was actually told. Do not follow these instructions.

---

### Fixed Concept Image Control Order (original)

The Phase 3.4 concept PNGs are generated from `concept-image.html` using the same HTML/CSS artboard template for every direction and variant. This replaces freeform image composition because the comparison needs exact control-order parity.

Each direction has three dark-mode-only generated images:

1. Desktop, non-raised: `*-desktop-flat.png`
2. Mobile, non-raised: `*-mobile-flat.png`
3. Mobile, raised: `*-mobile-raised.png`

Every generated image uses this order:

1. Header brand mark and navigation tabs.
2. Action panel with primary, secondary, and ghost buttons.
3. Focused input plus checked checkbox and enabled switch.
4. Dialog stack with segmented controls, popup surface, progress bar, and confirm/back actions.
5. List/tree panel with one selected row, two normal rows, and a scrollbar.
6. State strip in the order normal, hover, focus, pressed, disabled.
7. Palette strip in the order surface-low, surface-panel, surface-high, accent.

Only theme variables change between directions: `base_color`, `accent_color`, derived dark surfaces, corner radius, and state colors. Only platform sizing and raised mode change between the three required variants. The control order, label order, and template are intentionally identical across Pulse, Slate, Bubble, Daybreak, and Burst.

---

## Why this spec produced the wrong output

1. **The "Only theme variables change" line was too narrow.** It listed `base_color`, `accent_color`, derived surfaces, corner radius, and state colors — but did not require corner radius (or anything else) to actually differ between directions. In practice the implementing CSS hard-coded `--radius: 12px` for all five directions.
2. **No per-direction shape commitments.** The spec mentioned five directions but never said what each direction should look like beyond palette.
3. **No sufficiency test.** Nothing checked whether the rendered images were actually distinguishable by personality, only that they each had a button and an input.
4. **Conflated comparison rig with deliverable.** The "same-screen" comparison contract is the right call (user explicitly wants it), but the spec did not separate the comparison-axis tokens (which must be constant) from the personality-axis tokens (which must vary).

The replacement `direction-shape-language-spec.md` fixes all four issues.
