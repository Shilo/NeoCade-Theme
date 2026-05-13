# ColorPickerButton Radius Finding

Date: 2026-05-13

## Summary

`ColorPickerButton` cannot get a truly rounded color swatch from `Theme` entries alone in Godot 4.6.2. NeoCade can round the button chrome styleboxes, but Godot draws the actual color preview as a raw rectangular fill inside the stylebox margins.

## Source Evidence

- `scene/gui/color_picker.h` defines `ColorPickerButton` as a `Button` subclass with only three theme cache entries relevant to drawing: `normal_style`, `background_icon`, and `overbright_indicator`.
- `scene/gui/color_picker.cpp` binds `ColorPickerButton.normal` and `ColorPickerButton.bg`, but the draw path uses the normal stylebox only to compute the inner swatch rect.
- In `ColorPickerButton::_notification(NOTIFICATION_DRAW)`, Godot computes:
  - `Rect2(theme_cache.normal_style->get_offset(), get_size() - theme_cache.normal_style->get_minimum_size())`
  - then draws `background_icon` into that rect
  - then calls `draw_rect(r, color)`
- `draw_rect(r, color)` does not consult `StyleBoxFlat` corner radii, so the color swatch remains square even when `ColorPickerButton.normal` has rounded corners.
- `ColorPresetButton` is different: it duplicates/draws a stylebox and sets that stylebox background to the preset color, so radius can work there. That behavior does not apply to `ColorPickerButton`.

## Current NeoCade State

NeoCade already assigns per-direction radius to `ColorPickerButton.normal`, `hover`, `pressed`, `focus`, and `disabled` in `addons/neocade_theme/scripts/neocade_theme.gd`. This affects the outer button chrome and the inner swatch rect margins, but it cannot round the swatch itself.

## Recommendation

Do not try to globally "fix" this in the theme for v1.

Theme-only mitigation would mean increasing `ColorPickerButton` padding so the square swatch sits farther inside a rounded shell. That makes the large showcase sample look a little less abrupt, but it shrinks the actual color preview everywhere, including inspector/resource fields where `ColorPickerButton` is already source-limited and small. It also still leaves square swatch corners, so it trades utility for only partial visual improvement.

Recommended handling:

1. Keep the built-in `ColorPickerButton` theme margins small so the color remains easy to inspect.
2. Document the square swatch as a Godot source limitation.
3. If NeoCade needs a polished runtime/demo swatch later, add an optional custom NeoCade control that owns its draw path and opens a `ColorPicker` popup. Do not present that as a drop-in replacement for Godot's built-in `ColorPickerButton`.
4. If this needs to be solved for every built-in `ColorPickerButton`, the proper fix is an upstream Godot change: either draw the swatch through a stylebox or expose a dedicated swatch radius/stylebox theme item.

## Decision

For the built-in theme: no global code change beyond documentation.

For showcase polish: only consider a scene-local/custom control if the square swatch remains distracting after the broader theme rescue work is complete.
