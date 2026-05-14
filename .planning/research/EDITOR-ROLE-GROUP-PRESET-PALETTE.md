# Editor Role Group Preset Palette

Date: 2026-05-13
Scope: exact resolved preset colors for the active Option B role-group mockup.

## Status

- Option B: role-group palette.
- Option A conservative baseline is deferred.
- `category_1_fill` through `category_6_fill` are rejected research, not implementation targets.
- `menu_boundary` is an internal provisional derived boundary. It is not a public fill token and is only visible when `menu_fill` fails the 3:1 surrounding-panel separation target.
- `PrimaryButton` consumes `positive_fill`; there is no separate `PositiveButton`. `DangerButton` consumes `danger_fill`; there is no duplicate `NegativeButton`.
- `success_fill` aliases `positive_fill` for v1 unless a future status-specific need requires a split.

## Audit Snapshot

- Audit result: `PASS 5 themes x 9 sources x 26 audit pairs`.
- Text-bearing fills target 4.5:1. Required non-text boundaries/indicators target 3:1.
- Foregrounds prefer the theme dark/light foreground when it passes; pure black/white is fallback only.

## Pulse

Preset source color: `#3AA8FF`
Mood: Pulse keeps LDtk spirit through stable roles: amber action, blue menu/input/selection, green range, aqua toggle, and green positive.

| Token | Fill | Foreground / note |
| --- | --- | --- |
| `surface_fill` | `#141A26` | #F5F9FF |
| `shell_fill` | `#0F141E` | #F5F9FF |
| `panel_fill` | `#1B2838` | #F5F9FF |
| `panel_alt_fill` | `#24354C` | #F5F9FF |
| `popup_shell` | `#202F44` | #F5F9FF |
| `dialog_header` | `#2C3F58` | #F5F9FF |
| `separator_fill` | `#324256` | #F5F9FF |
| `code_fill` | `#151E2B` | #F5F9FF |
| `input_fill` | `#273C54` | #F5F9FF |
| `input_edge` | `#67A3CB` | #0D1420 |
| `list_panel_fill` | `#1A2534` | #F5F9FF |
| `list_row_hover` | `#23344B` | #F5F9FF |
| `selection_fill` | `#4081B6` | #05070B |
| `text_selection_fill` | `#4180B4` | #05070B |
| `action_fill` | `#D6BC34` | #0D1420 |
| `menu_fill` | `#4F8BB7` | #0D1420 |
| `menu_boundary internal` | `#84AECE` | inactive for preset, 4.06:1 visible boundary vs panel_fill |
| `range_fill` | `#5ECD7B` | #0D1420 |
| `toggle_fill` | `#40D6C9` | #0D1420 |
| `positive_fill / success_fill` | `#40CA8F` | #0D1420 |
| `warning_fill` | `#C98339` | #0D1420 |
| `info_fill` | `#3E9FD8` | #0D1420 |
| `danger_fill` | `#BC394F` | #F5F9FF |
| `focus_ring` | `#6FBEEB` | #F5F9FF |

## Daybreak

Preset source color: `#76F2D1`
Mood: Daybreak uses coastal roles: gold actions, blue-teal menus, teal selection, mint range, aqua toggle, calm teal inputs.

| Token | Fill | Foreground / note |
| --- | --- | --- |
| `surface_fill` | `#122024` | #F4FFFB |
| `shell_fill` | `#0D181B` | #F4FFFB |
| `panel_fill` | `#1B333B` | #F4FFFB |
| `panel_alt_fill` | `#22474F` | #F4FFFB |
| `popup_shell` | `#213E46` | #F4FFFB |
| `dialog_header` | `#315851` | #F4FFFB |
| `separator_fill` | `#33555E` | #F4FFFB |
| `code_fill` | `#142429` | #F4FFFB |
| `input_fill` | `#26494E` | #F4FFFB |
| `input_edge` | `#72C3B5` | #0D1715 |
| `list_panel_fill` | `#182C32` | #F4FFFB |
| `list_row_hover` | `#23444A` | #F4FFFB |
| `selection_fill` | `#3D978A` | #0D1715 |
| `text_selection_fill` | `#3E9588` | #0D1715 |
| `action_fill` | `#D9BB34` | #0D1715 |
| `menu_fill` | `#38A6AD` | #0D1715 |
| `menu_boundary internal` | `#87CBCE` | inactive for preset, 4.56:1 visible boundary vs panel_fill |
| `range_fill` | `#62DAA7` | #0D1715 |
| `toggle_fill` | `#49D9BF` | #0D1715 |
| `positive_fill / success_fill` | `#42CB87` | #0D1715 |
| `warning_fill` | `#C98834` | #0D1715 |
| `info_fill` | `#44B0D7` | #0D1715 |
| `danger_fill` | `#BB3A45` | #F4FFFB |
| `focus_ring` | `#7AEBD0` | #F4FFFB |

## Slate

Preset source color: `#8BD3FF`
Mood: Slate is restrained utility: graphite surfaces, icy selection, champagne action, steel menu, mint state controls.

| Token | Fill | Foreground / note |
| --- | --- | --- |
| `surface_fill` | `#14181F` | #F6F9FF |
| `shell_fill` | `#0F1217` | #F6F9FF |
| `panel_fill` | `#1D2632` | #F6F9FF |
| `panel_alt_fill` | `#273548` | #F6F9FF |
| `popup_shell` | `#222D3C` | #F6F9FF |
| `dialog_header` | `#2D3D55` | #F6F9FF |
| `separator_fill` | `#354557` | #F6F9FF |
| `code_fill` | `#131A22` | #F6F9FF |
| `input_fill` | `#273748` | #F6F9FF |
| `input_edge` | `#6B97B5` | #0E141C |
| `list_panel_fill` | `#19212D` | #F6F9FF |
| `list_row_hover` | `#243243` | #F6F9FF |
| `selection_fill` | `#4683AF` | #0E141C |
| `text_selection_fill` | `#4782AD` | #05070B |
| `action_fill` | `#D8C578` | #0E141C |
| `menu_fill` | `#5982B0` | #0E141C |
| `menu_boundary internal` | `#8BA8C9` | inactive for preset, 3.81:1 visible boundary vs panel_fill |
| `range_fill` | `#6AD3D2` | #0E141C |
| `toggle_fill` | `#65D7B7` | #0E141C |
| `positive_fill / success_fill` | `#5DCB94` | #0E141C |
| `warning_fill` | `#C6964E` | #0E141C |
| `info_fill` | `#4E9DD0` | #0E141C |
| `danger_fill` | `#B73E52` | #F6F9FF |
| `focus_ring` | `#88C3E7` | #F6F9FF |

## Burst

Preset source color: `#FFD166`
Mood: Burst keeps reward color in roles: gold action, violet menu/selection, lime range, aqua toggle, green positive.

| Token | Fill | Foreground / note |
| --- | --- | --- |
| `surface_fill` | `#191428` | #FFF8FF |
| `shell_fill` | `#120F1E` | #FFF8FF |
| `panel_fill` | `#291B3B` | #FFF8FF |
| `panel_alt_fill` | `#37264F` | #FFF8FF |
| `popup_shell` | `#312144` | #FFF8FF |
| `dialog_header` | `#422B5E` | #FFF8FF |
| `separator_fill` | `#463657` | #FFF8FF |
| `code_fill` | `#191428` | #FFF8FF |
| `input_fill` | `#332846` | #FFF8FF |
| `input_edge` | `#9B77C5` | #15101D |
| `list_panel_fill` | `#211830` | #FFF8FF |
| `list_row_hover` | `#322545` | #FFF8FF |
| `selection_fill` | `#9A65C2` | #05070B |
| `text_selection_fill` | `#9666C1` | #05070B |
| `action_fill` | `#E2A737` | #15101D |
| `menu_fill` | `#A260BE` | #05070B |
| `menu_boundary internal` | `#C091D3` | inactive for preset, 3.77:1 visible boundary vs panel_fill |
| `range_fill` | `#87DD4E` | #15101D |
| `toggle_fill` | `#4EDA8D` | #15101D |
| `positive_fill / success_fill` | `#44CD66` | #15101D |
| `warning_fill` | `#D7713B` | #15101D |
| `info_fill` | `#40CDDD` | #15101D |
| `danger_fill` | `#BD3852` | #FFF8FF |
| `focus_ring` | `#74EADB` | #FFF8FF |

## Bubble

Preset source color: `#57C7FF`
Mood: Bubble stays flat mobile-game UI: dark shell, light islands, blue action, lavender menu, sky selection, aqua range/toggle, green positive.

| Token | Fill | Foreground / note |
| --- | --- | --- |
| `surface_fill` | `#234369` | #FFFFFF |
| `shell_fill` | `#1B3456` | #FFFFFF |
| `panel_fill` | `#F3F1E9` | #151923 |
| `panel_alt_fill` | `#E3D9C5` | #151923 |
| `popup_shell` | `#F8F6F2` | #151923 |
| `dialog_header` | `#8880CF` | #151923 |
| `separator_fill` | `#A4B7C7` | #151923 |
| `code_fill` | `#EFF3F5` | #151923 |
| `input_fill` | `#F5F7F9` | #151923 |
| `input_edge` | `#497CA2` | #05070B |
| `list_panel_fill` | `#F3F1E9` | #151923 |
| `list_row_hover` | `#EEF2F5` | #151923 |
| `selection_fill` | `#296E99` | #FFFFFF |
| `text_selection_fill` | `#2A678D` | #FFFFFF |
| `action_fill` | `#2D9BD4` | #151923 |
| `menu_fill` | `#5C79B0` | #05070B |
| `menu_boundary internal` | `#455A83` | inactive for preset, 3.86:1 visible boundary vs panel_fill |
| `range_fill` | `#1A8B8A` | #05070B |
| `toggle_fill` | `#229370` | #151923 |
| `positive_fill / success_fill` | `#229351` | #05070B |
| `warning_fill` | `#E6C333` | #151923 |
| `info_fill` | `#2C9BD4` | #151923 |
| `danger_fill` | `#C8375C` | #FFFFFF |
| `focus_ring` | `#19668E` | #151923 |

## Component Alias Table

| Alias | Canonical color source | Reason |
| --- | --- | --- |
| `list_row_selected` | `selection_fill` | V1 keeps selected rows and selected tabs on one readable selection role; split later only if editor source tracing proves it is needed. |
| `tab_selected_fill` | `selection_fill` | Selected tab face should share the same navigation/selection meaning. |
| `tab_selected_indicator` | `action_fill` | The compact top/side indicator can carry the stronger action color without painting a broad text surface. |
| `text_selection_fill` | Dedicated derived role near `selection_fill` | Text selection is audited separately because LineEdit/TextEdit/CodeEdit body text is dense. |
| `success_fill` | `positive_fill` | Avoids duplicating green semantics before implementation proves a separate success status is necessary. |
| `menu_boundary` | Internal derived boundary from `menu_fill` | Used only when `menu_fill` itself cannot separate from adjacent panels at 3:1. Not a public role. |
