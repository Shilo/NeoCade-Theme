# Color Identity Mockups

HTML mockups for the 2026-05-13 theme color identity rethink.

Open:

- `theme-color-identity-mockups.html`
- `theme-color-identity-approval-gate.html`

Use `theme-color-identity-approval-gate.html` as the implementation approval artifact. It includes a live `source_color` picker, side-by-side cards for all five themes, Godot slot labels, state examples, flat raised offsets, mobile density, and contrast badges.

The approval-gate mockup includes a live `source_color` picker. You can also set it from the URL:

- `theme-color-identity-approval-gate.html?mode=preset`
- `theme-color-identity-approval-gate.html?mode=stress&source=%2357c7ff`
- `theme-color-identity-approval-gate.html?mode=stress&source=%23ff5f6f`

Recommended preset sources:

- Pulse: `#3AA8FF`
- Daybreak: `#76F2D1`
- Slate: `#8BD3FF`
- Burst: `#FFD166`
- Bubble: `#57C7FF`

Direct theme URLs:

- `theme-color-identity-mockups.html?theme=pulse`
- `theme-color-identity-mockups.html?theme=daybreak`
- `theme-color-identity-mockups.html?theme=slate`
- `theme-color-identity-mockups.html?theme=burst`
- `theme-color-identity-mockups.html?theme=bubble`

Add `&raised=1` to preview the flat hard-offset raised mode.

Purpose:

- Test whether each theme has a distinct out-of-box identity using default controls only.
- Avoid relying on `theme_type_variation` for core color personality.
- Keep the mockup mapped to Godot Theme-feasible control families: Button, OptionButton, LineEdit/TextEdit, TabBar, ItemList/Tree-like rows, sliders/progress, CheckBox/CheckButton-like states, and popup/dialog chrome.
