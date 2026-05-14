# Editor Role-Group Preset Palette

Date: 2026-05-13
Status: reviewer input artifact
Scope: exact resolved preset colors for the active Option B role-group mockup.

Source mockup:

- `.planning/mockups/editor-color-readability/godot-editor-role-groups-mockup.html`

Active direction:

- Option B: role-group palette.
- Option A conservative baseline is deferred.
- `menu_edge` is provisional and exists only to test colorblind-visible menu separation without changing `menu_fill`.

Verification snapshot:

- Preset and stress audit passed in the mockup script.
- Stress sources tested: `#3aa8ff`, `#ff3355`, `#ffd166`, `#57f287`, `#a855f7`, `#ffffff`, `#111111`, `#00d5c8`.
- Audit result: `PASS 5 themes x 9 sources x 22 audit pairs`.

## Pulse

Preset `source_color`: `#3AA8FF`

| Token | Hex | Foreground / note |
| --- | --- | --- |
| `surface_fill` | `#141A26` | `#FFFFFF` |
| `shell_fill` | `#0F141E` | `#FFFFFF` |
| `panel_fill` | `#1B2838` | `#FFFFFF` |
| `panel_alt_fill` | `#24354C` | `#FFFFFF` |
| `popup_shell` | `#202F44` | `#FFFFFF` |
| `dialog_header` | `#2C3F58` | `#FFFFFF` |
| `input_fill` | `#273C54` | `#FFFFFF` |
| `input_edge` | `#67A3CB` | `4.13:1` vs `input_fill` |
| `list_panel_fill` | `#1A2534` | `#FFFFFF` |
| `list_row_hover` | `#23344B` | `#FFFFFF` |
| `selection_fill` | `#4081B6` | `#05070B` |
| `action_fill` | `#D6BC34` | `#05070B` |
| `menu_fill` | `#366991` | `#FFFFFF` |
| `menu_edge` provisional | `#6089A9` | `4.01:1` vs `panel_fill`, `1.58:1` vs `menu_fill` |
| `range_fill` | `#5ECD7B` | `#05070B` |
| `toggle_fill` | `#51DC98` | `#05070B` |
| `positive_fill` | `#40CA8F` | `#05070B` |
| `danger_fill` | `#BC394F` | `#FFFFFF` |
| `focus_ring` | `#6FBEEB` | `7.28:1` vs `panel_fill` |
| `separator_fill` | `#324256` | `1.46:1` vs `panel_fill` |
| `code_fill` | `#151E2B` | `#FFFFFF` |

## Daybreak

Preset `source_color`: `#76F2D1`

| Token | Hex | Foreground / note |
| --- | --- | --- |
| `surface_fill` | `#122024` | `#FFFFFF` |
| `shell_fill` | `#0D181B` | `#FFFFFF` |
| `panel_fill` | `#1B333B` | `#FFFFFF` |
| `panel_alt_fill` | `#22474F` | `#FFFFFF` |
| `popup_shell` | `#213E46` | `#FFFFFF` |
| `dialog_header` | `#315851` | `#FFFFFF` |
| `input_fill` | `#26494E` | `#FFFFFF` |
| `input_edge` | `#72C3B5` | `4.75:1` vs `input_fill` |
| `list_panel_fill` | `#182C32` | `#FFFFFF` |
| `list_row_hover` | `#23444A` | `#FFFFFF` |
| `selection_fill` | `#3D978A` | `#05070B` |
| `action_fill` | `#D9BB34` | `#05070B` |
| `menu_fill` | `#2E7D75` | `#FFFFFF` |
| `menu_edge` provisional | `#5A9A92` | `4.09:1` vs `panel_fill`, `1.50:1` vs `menu_fill` |
| `range_fill` | `#62DAA7` | `#05070B` |
| `toggle_fill` | `#52E090` | `#05070B` |
| `positive_fill` | `#42CB87` | `#05070B` |
| `danger_fill` | `#BB3A45` | `#FFFFFF` |
| `focus_ring` | `#7AEBD0` | `9.24:1` vs `panel_fill` |
| `separator_fill` | `#33555E` | `1.64:1` vs `panel_fill` |
| `code_fill` | `#142429` | `#FFFFFF` |

## Slate

Preset `source_color`: `#8BD3FF`

| Token | Hex | Foreground / note |
| --- | --- | --- |
| `surface_fill` | `#14181F` | `#FFFFFF` |
| `shell_fill` | `#0F1217` | `#FFFFFF` |
| `panel_fill` | `#1D2632` | `#FFFFFF` |
| `panel_alt_fill` | `#273548` | `#FFFFFF` |
| `popup_shell` | `#222D3C` | `#FFFFFF` |
| `dialog_header` | `#2D3D55` | `#FFFFFF` |
| `input_fill` | `#273748` | `#FFFFFF` |
| `input_edge` | `#6B97B5` | `3.89:1` vs `input_fill` |
| `list_panel_fill` | `#19212D` | `#FFFFFF` |
| `list_row_hover` | `#243243` | `#FFFFFF` |
| `selection_fill` | `#4683AF` | `#05070B` |
| `action_fill` | `#5CA6D6` | `#05070B` |
| `menu_fill` | `#4A6996` | `#FFFFFF` |
| `menu_edge` provisional | `#7089AD` | `4.27:1` vs `panel_fill`, `1.56:1` vs `menu_fill` |
| `range_fill` | `#6AD3D2` | `#05070B` |
| `toggle_fill` | `#63DAA6` | `#05070B` |
| `positive_fill` | `#5DCB94` | `#05070B` |
| `danger_fill` | `#B73E52` | `#FFFFFF` |
| `focus_ring` | `#88C3E7` | `8.00:1` vs `panel_fill` |
| `separator_fill` | `#354557` | `1.56:1` vs `panel_fill` |
| `code_fill` | `#131A22` | `#FFFFFF` |

## Burst

Preset `source_color`: `#FFD166`

| Token | Hex | Foreground / note |
| --- | --- | --- |
| `surface_fill` | `#191428` | `#FFFFFF` |
| `shell_fill` | `#120F1E` | `#FFFFFF` |
| `panel_fill` | `#291B3B` | `#FFFFFF` |
| `panel_alt_fill` | `#37264F` | `#FFFFFF` |
| `popup_shell` | `#312144` | `#FFFFFF` |
| `dialog_header` | `#422B5E` | `#FFFFFF` |
| `input_fill` | `#332846` | `#FFFFFF` |
| `input_edge` | `#9B77C5` | `3.81:1` vs `input_fill` |
| `list_panel_fill` | `#211830` | `#FFFFFF` |
| `list_row_hover` | `#322545` | `#FFFFFF` |
| `selection_fill` | `#9A65C2` | `#05070B` |
| `action_fill` | `#E2A737` | `#05070B` |
| `menu_fill` | `#6E4790` | `#FFFFFF` |
| `menu_edge` provisional | `#8E6EA8` | `3.76:1` vs `panel_fill`, `1.67:1` vs `menu_fill` |
| `range_fill` | `#87DD4E` | `#05070B` |
| `toggle_fill` | `#52E064` | `#05070B` |
| `positive_fill` | `#44CD66` | `#05070B` |
| `danger_fill` | `#BD3852` | `#FFFFFF` |
| `focus_ring` | `#74EADB` | `11.06:1` vs `panel_fill` |
| `separator_fill` | `#463657` | `1.47:1` vs `panel_fill` |
| `code_fill` | `#191428` | `#FFFFFF` |

## Bubble

Preset `source_color`: `#57C7FF`

| Token | Hex | Foreground / note |
| --- | --- | --- |
| `surface_fill` | `#234369` | `#FFFFFF` |
| `shell_fill` | `#1B3456` | `#FFFFFF` |
| `panel_fill` | `#F3F1E9` | `#05070B` |
| `panel_alt_fill` | `#E3D9C5` | `#05070B` |
| `popup_shell` | `#F8F6F2` | `#05070B` |
| `dialog_header` | `#8880CF` | `#05070B` |
| `input_fill` | `#F5F7F9` | `#05070B` |
| `input_edge` | `#497CA2` | `4.17:1` vs `input_fill` |
| `list_panel_fill` | `#F3F1E9` | `#05070B` |
| `list_row_hover` | `#EEF2F5` | `#05070B` |
| `selection_fill` | `#296E99` | `#FFFFFF` |
| `action_fill` | `#2D9BD4` | `#05070B` |
| `menu_fill` | `#91AAD4` | `#05070B` |
| `menu_edge` provisional | `#697C9B` | `3.75:1` vs `panel_fill`, `1.80:1` vs `menu_fill` |
| `range_fill` | `#229158` | `#05070B` |
| `toggle_fill` | `#1E954D` | `#05070B` |
| `positive_fill` | `#229351` | `#05070B` |
| `danger_fill` | `#C8375C` | `#FFFFFF` |
| `focus_ring` | `#19668E` | `5.57:1` vs `panel_fill` |
| `separator_fill` | `#A4B7C7` | `1.82:1` vs `panel_fill` |
| `code_fill` | `#EFF3F5` | `#05070B` |

