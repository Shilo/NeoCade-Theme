# Fixed Concept Image Control Order

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
