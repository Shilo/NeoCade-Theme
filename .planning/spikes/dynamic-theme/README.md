# Dynamic Theme Spike

Research-only spike for Phase 03.2. These files are evidence for the dynamic `@tool extends Theme` architecture and must not be copied into `addons/neocade_theme/` without Phase 4 planning.

## Inventory

| File | Purpose |
|------|---------|
| `SpikeNeoCadeTheme.gd` | Superclass prototype with exported `base_color`, `accent_color`, `raised`, and `platform` knobs. |
| `PrizePopSpikeNeoCadeTheme.gd` | Good subclass: calls `super._regenerate()` first, then applies personality overrides. |
| `BrokenNoSuperSpikeTheme.gd` | Negative subclass: intentionally skips `super._regenerate()` and leaves coverage gaps. |
| `prize_pop_spike_neocade_theme.tres` | Saved good theme instance. |
| `broken_no_super_spike_theme.tres` | Saved bad theme instance. |
| `dynamic_theme_spike.tscn` | Visual scene with the representative control subset. |
| `verify_dynamic_theme_spike.gd` | Headless verifier for strict feasibility evidence. |

## Representative Subset

The spike covers Button, OptionButton, CheckBox, LineEdit, Tree, PopupMenu, Window, and HScrollBar. HScrollBar is the ScrollBar representative because horizontal grabber geometry is easy to assert through `grabber_minimum_size`; VScrollBar should use the same generation helper in Phase 4.

## Running

From the project root:

```powershell
godot --headless --path . --script .planning/spikes/dynamic-theme/verify_dynamic_theme_spike.gd
```

Open `.planning/spikes/dynamic-theme/dynamic_theme_spike.tscn` in Godot for a visual check if the editor is available.

## Strict Checks

- Export-driven regeneration changes representative entries.
- Good subclass preserves superclass coverage.
- Bad subclass leaves detectable gaps when `super._regenerate()` is skipped.
- Saved `.tres` resources load and can be applied to a Control tree.
- Exported values and script references can be inspected for serialization.
- AUTO platform detection is tested with local and simulated feature sets.

## Limitations

This spike intentionally does not cover TabBar, TabContainer, ColorPicker, MenuBar, icons, fonts, or the full 35-Control matrix. Those remain Phase 4-7 implementation and verification work.
