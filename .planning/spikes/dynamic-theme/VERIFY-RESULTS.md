# Dynamic Theme Spike Verification Results

Phase 03.2 Plan 04 formal strict feasibility verifier.

## Environment

| Item | Value |
|------|-------|
| Godot executable | `C:/Programming_Files/Godot/Godot_v4.6.2-stable_mono_win64/Godot_v4.6.2-stable_mono_win64_console.exe` |
| Godot version | `4.6.2.stable.mono.official.71f334935` |
| Command | `--headless --path . --script .planning/spikes/dynamic-theme/verify_dynamic_theme_spike.gd` |
| Result | PASS |

## Strict Checks

| Check | Evidence mode | Result | Evidence |
|-------|---------------|--------|----------|
| Export-driven regeneration | EXECUTED | PASS | Verifier changed `base_color`, `accent_color`, `raised`, and forced `platform=DESKTOP`; `Button.normal` color changed and `HScrollBar.grabber_minimum_size` became desktop-sized. |
| Correct subclass super-first required entries | EXECUTED | PASS | `PrizePopSpikeNeoCadeTheme` retained required superclass entries for Button, OptionButton, CheckBox, LineEdit, Tree, PopupMenu, Window, and HScrollBar, and added `Button.prize_pop_direct_override_marker`. |
| Bad no-super gaps | EXECUTED | PASS | `BrokenNoSuperSpikeTheme` retained only Button entries; verifier confirmed missing `LineEdit.normal`, `Tree.panel`, and `Window.embedded_border`. |
| Saved `.tres` runtime application | EXECUTED | PASS | Saved good theme resource loaded and supplied a Button stylebox through a Control tree. |
| Serialization behavior | EXECUTED | PASS | Saved `.tres` fixtures contain script refs and exported values; verifier saved and reloaded a `user://` roundtrip copy and regenerated Button/PopupMenu entries. |
| Platform detection local/simulated | EXECUTED | PASS | `web_android` and `web_ios` resolve mobile; `web_windows` resolves desktop; ambiguous `web` resolves mobile-preferred; local `OS.get_name()` fallback returns a known platform enum. |

## Raw Output

```text
Godot Engine v4.6.2.stable.mono.official.71f334935 - https://godotengine.org

VERIFY: good_regeneration_usec=187
VERIFY: checks=good theme loads, bad theme loads, good has Button.normal stylebox, good has Button.focus stylebox, good has Button.font_color color, good has Button.prize_pop_direct_override_marker constant, good has OptionButton.normal stylebox, good has OptionButton.arrow_margin constant, good has CheckBox.font_color color, good has LineEdit.normal stylebox, good has LineEdit.caret_color color, good has Tree.panel stylebox, good has Tree.item_margin constant, good has PopupMenu.panel stylebox, good has PopupMenu.v_separation constant, good has Window.embedded_border stylebox, good has Window.title_height constant, good has HScrollBar.grabber stylebox, good has HScrollBar.grabber_minimum_size constant, bad has Button.normal marker, bad lacks LineEdit.normal, bad lacks Tree.panel, bad lacks Window.embedded_border, export changes regenerate Button.normal color, forced desktop resolves desktop sizing, saved theme applies to Control tree, web_android resolves mobile, web_ios resolves mobile, web_windows resolves desktop, ambiguous web resolves mobile-preferred, local OS fallback returns known platform, ResourceSaver saves dynamic theme, roundtrip dynamic theme loads, roundtrip keeps script-driven generation, roundtrip keeps PopupMenu generation, regeneration duration hook reports non-zero usec
VERIFY: PASS dynamic theme spike
```

## Serialization Inspection

| Resource | Script reference | Exported values | Result |
|----------|------------------|-----------------|--------|
| `prize_pop_spike_neocade_theme.tres` | `res://.planning/spikes/dynamic-theme/PrizePopSpikeNeoCadeTheme.gd` | `base_color`, `accent_color`, `raised=true`, `platform=AUTO` | PASS |
| `broken_no_super_spike_theme.tres` | `res://.planning/spikes/dynamic-theme/BrokenNoSuperSpikeTheme.gd` | `base_color`, `accent_color`, `raised=false`, `platform=AUTO` | PASS |

Generated entries are script-driven output, not hand-authored `.tres` table data. This is acceptable for the dynamic architecture only because runtime load/regeneration and roundtrip load both passed.

## AUTO Strategy Matrix

| Case | Simulated inputs | Expected | Verified |
|------|------------------|----------|----------|
| Native desktop | local `OS.get_name()` | DESKTOP or MOBILE known enum | PASS |
| Native mobile | `Android` / `iOS` fallback path in resolver | MOBILE | Covered by resolver logic; not real-device verified |
| Web desktop | `web_windows` | DESKTOP | PASS |
| Web mobile | `web_android`, `web_ios` | MOBILE | PASS |
| Ambiguous Web | `web` only | MOBILE preferred | PASS |
| Forced desktop | `platform=DESKTOP` | DESKTOP sizes | PASS |
| Forced mobile | `platform=MOBILE` | MOBILE sizes | Covered by resolver path; not visually inspected |

## Performance Note

Representative subset regeneration reported `187 usec` in the headless verifier. This is not a full 35-Control performance guarantee; Phase 4 should retain the timing hook and add full-matrix timing once the real generator exists.

## Gate Outcome

Overall feasibility: **PASS** for Phase 03.2 representative subset.

Dynamic architecture may proceed to Plan 05 as the recommended Phase 4 architecture, with the caveat that full 35-Control coverage, icons/fonts, and real-device Web/mobile validation remain future-phase obligations.
