# Fixed Concept Image Control Order

The Phase 3.4 concept PNGs are generated from `concept-image.html` using the same HTML/CSS artboard template for every direction. This replaces freeform image composition because the comparison needs exact control-order parity.

Every generated image uses this order:

1. Header brand mark and navigation tabs.
2. Action panel with primary, secondary, and ghost buttons.
3. Focused input plus checked checkbox and enabled switch.
4. Dialog stack with segmented controls, popup surface, progress bar, and confirm/back actions.
5. List/tree panel with one selected row, two normal rows, and a scrollbar.
6. State strip in the order normal, hover, focus, pressed, disabled.
7. Palette strip in the order surface-low, surface-panel, surface-high, accent.

Only theme variables change between images: `base_color`, `accent_color`, derived dark surfaces, corner radius, and state colors. The layout, control order, and label order are intentionally identical across Pulse, Slate, Bubble, Daybreak, and Burst.

