# NeoCade Mobile Design Spec

Phase 8 defines mobile as an export-driven platform mode on the same five NeoCade direction resources. It does not create `neocade_mobile_theme.tres`, per-density `.tres` files, subclasses, or a root fallback theme resource.

## Architecture Summary

- Production script: `addons/neocade_theme/scripts/neocade_theme.gd`.
- Direction resources: Pulse (`pulse_neocade_theme.tres`), Slate (`slate_neocade_theme.tres`), Bubble (`bubble_neocade_theme.tres`), Daybreak (`daybreak_neocade_theme.tres`), and Burst (`burst_neocade_theme.tres`).
- Public exports remain the locked 9 names: `base_color`, `accent_color`, `raised`, `platform`, `corner_radius`, `spacing`, `raised_strength`, `focus_thickness`, and `outline_width`.
- Mobile behavior is selected through `platform=MOBILE`; `platform=DESKTOP` and `platform=AUTO` remain available on the same resources.

## Forbidden Files And Resources

- `addons/neocade_theme/neocade_theme.tres` is forbidden as a root fallback.
- `addons/neocade_theme/neocade_mobile_theme.tres` is forbidden as a sibling mobile theme.
- Per-density theme resources are forbidden.
- Per-direction addon-root `.gd` subclasses, `_dev`, and `themes` folders are forbidden.

## Desktop Vs Mobile Tokens

| Token | Desktop | Mobile | Notes |
|---|---:|---:|---|
| Body font | 14 | 16 | MOBILE-03 body readability floor. |
| Label and Caption | 12 | 14 | Caption uses the mobile label scale. |
| Kicker | 12 | 13 | Kicker remains compact but grows on mobile. |
| HeaderLarge | 36 | 36 | HeaderLarge retains desktop size on mobile per MOBILE-03/D-08. |
| HeaderMedium | 22 | 22 | HeaderMedium retains desktop size on mobile. |
| HeaderSmall | 22 | 22 | HeaderSmall retains desktop size on mobile. |
| `tapPadding` | 8 | 12 | Used by button separations and many container/range constants. |
| `densityScale` | 1.0 | 1.5 | Shape-authored padding scales by density; radius does not. |
| FileDialog thumbnail | 96 | 128 | Touch-friendly thumbnail proxy. |
| Interactive floor | varies | 48px | Enforced where Theme entries expose a proxy. |

## Forced Platform Behavior

- `platform=DESKTOP`: deterministic desktop token branch.
- `platform=MOBILE`: deterministic mobile token branch used by local QA and audit scripts.
- `platform=AUTO`: host feature based resolver smoke path for consumers.

Platform mode affects sizing, spacing, type scale, and minimum target constants. It does not change palette, direction identity, semantic colors, icon vocabulary, or corner radii.

## Android Density Buckets

Android density buckets are handled by Godot project scaling and stretch configuration, not by per-density theme resources. NeoCade ships one dynamic mobile mode; consumers should tune viewport/content scaling at the project level for device classes.

## Raised And Platform Orthogonality

`raised` and `platform` are independent axes. Verification covers `raised=false/platform=DESKTOP`, `raised=true/platform=DESKTOP`, `raised=false/platform=MOBILE`, and `raised=true/platform=MOBILE`. Toggling platform after raised regeneration must preserve Button, LineEdit, and Tree entries.

## 37-row Scorecard Delta Table

| Row | Classification | Mobile delta |
|---|---|---|
| AcceptDialog | display | Shell delegates tap targets to child Buttons; buttons use mobile Button formulas. |
| Button | interactive | Mobile Button proxy reaches at least 48px through font, padding, and separation. |
| CheckBox | interactive | Mobile icon/text/separation plus Button-family padding reaches at least 48px. |
| CheckButton | interactive | Mobile toggle/text proxy reaches at least 48px. |
| CodeEdit | interactive | Mobile input proxy uses 16px body text and input minimum. |
| ColorPicker | interactive | Picker constants and cursor/bar proxies remain above 48px. |
| ColorPickerButton | interactive | LIMITED: Godot exposes only `normal` stylebox + `bg` icon for this class; a theme-only 48px min-size would consume the swatch draw rect, and the swatch fill itself is drawn as a square `draw_rect`. Consuming scenes should give standalone swatch buttons a mobile custom minimum size when needed; see `.planning/qa/theme-rescue/colorpickerbutton-radius-finding.md` for the radius limitation. |
| ConfirmationDialog | display | Shell delegates tap targets to child Buttons. |
| FileDialog | display | Thumbnail proxy grows from 96 to 128; shell buttons inherit Button formulas. |
| FoldableContainer | interactive | Title row and arrow proxy pass the 48px floor. |
| GraphEdit | interactive | Port hotzone proxy is checked against the 48px floor. |
| HScrollBar | interactive | Scrollbars are intentionally not inflated for mobile; mobile scroll affordances are expected to be visually smaller than tap buttons. |
| HSlider | interactive | Grabber and grabber_area proxies pass 48px. |
| HSplitContainer | interactive | Split handle proxy passes 48px. |
| ItemList | interactive | Row proxy uses mobile font/separation metrics and passes 48px. |
| Label | display | Text display is not a tap target. |
| LineEdit | interactive | Mobile input proxy uses 16px body text and input minimum. |
| LinkButton | interactive | LIMITED: Godot exposes no stylebox/minimum-size theme slot, so the audit documents font/underline proxy only. |
| MenuBar | interactive | Font plus separation and stylebox proxy pass 48px. |
| MenuButton | interactive | Button-family mobile sizing applies. |
| OptionButton | interactive | Button-family mobile sizing and arrow metrics apply. |
| Panel | layout | Panel chrome is not interactive. |
| PopupMenu | interactive | Item padding, font, and icon width proxy pass 48px. |
| PopupPanel | display | Popup shell delegates tap targets. |
| ProgressBar | display | Indicator is not a tap target. |
| RichTextLabel | display | Text display is not a tap target. |
| SpinBox | interactive | LineEdit proxy plus SpinBox icons pass 48px. |
| TabBar | interactive | Tab strip proxy passes 48px. |
| TabContainer | interactive | Tab strip proxy passes 48px; content panel is layout chrome. |
| TextEdit | interactive | Mobile input proxy uses 16px body text and input minimum. |
| TooltipLabel | display | Tooltip text is not a tap target. |
| TooltipPanel | display | Tooltip shell is not a tap target. |
| Tree | interactive | Row proxy uses mobile font/separation/icon metrics and passes 48px. |
| VScrollBar | interactive | Scrollbars are intentionally not inflated for mobile; mobile scroll affordances are expected to be visually smaller than tap buttons. |
| VSlider | interactive | Grabber and grabber_area proxies pass 48px. |
| VSplitContainer | interactive | Split handle proxy passes 48px. |
| Window | display | Embedded titlebar uses mobile-only `title_height`/close-offset/icon scale so the close affordance and title alignment match the larger mobile chrome. |

## Tap-target Audit Summary

Evidence lives at `.planning/phases/08-mobile-variant-token-block-tap-target-audit-updated-for-dyna/logs/08-tap-target-audit.log`.

The Phase 8 audit runs all five directions with `platform=MOBILE`, `raised=false`, and `raised=true`. Current result: 250 PASS, 10 LIMITED, 110 N/A, 0 FAIL. Follow-up runtime probing in 2026-05-09 added `theme_mobile_tap_target_probe.gd`, which verifies actual `get_combined_minimum_size()` for common controls, button variations, icon/flat buttons, MenuButton, Tree/ItemList row height, PopupMenu row/icon sizing, and embedded Window title/close chrome. It also verifies mobile-readable icons for CheckBox, RadioButton, CheckButton, PopupMenu check/radio items, LineEdit clear, and TabBar arrows. ColorPickerButton remains source-limited for theme-only minimum size and true swatch radius, so the theme keeps its chrome margins small and consuming mobile layouts should assign a 48x48 minimum where the swatch is standalone. Scrollbars remain intentionally compact. Mobile metrics are 1920x1080 design-space units that the project scales to device resolution, not raw physical device pixels.

## Limitations

| Area | Limitation | Handling |
|---|---|---|
| LinkButton | No Theme-side stylebox/minimum-size slot. | Reported LIMITED with the missing minimum named. |
| Dialog shells | Shell hit areas are delegated to child controls. | Rows are display/N/A; child Buttons inherit mobile sizing. |
| Window titlebar | Engine/window-managed hit rects. | Row is display/N/A. |
| Display text | Labels, tooltips, and rich text are not tap targets. | Rows are display/N/A. |
| Layout chrome | Panels and non-interactive chrome are not tap targets. | Rows are layout/N/A. |

## 14 Core Runtime Type Variations

The older 13-variation research wording is superseded by the live `TYPE_VARIATIONS` registry in `addons/neocade_theme/scripts/neocade_theme.gd`. Phase 8 documents the core runtime variations; editor-only variations may also exist in the registry for Godot editor integration:

| Variation | Base | Mobile behavior |
|---|---|---|
| PrimaryButton | Button | Uses mobile Button body size, density-scaled padding, and 48px floor. |
| GhostButton | Button | Uses mobile Button body size, density-scaled padding, and 48px floor. |
| DangerButton | Button | Uses mobile Button body size, density-scaled padding, and 48px floor. |
| IconButton | Button | Uses mobile Button body size and touch-friendly icon button padding. |
| FlatButton | Button | Uses mobile Button body size and larger hover/press target geometry. |
| HeaderLarge | Label | Retains 36px desktop size on mobile. |
| HeaderMedium | Label | Retains 22px desktop size on mobile. |
| HeaderSmall | Label | Retains 22px desktop size on mobile. |
| Caption | Label | Grows from 12px desktop to 14px mobile. |
| CodeLabel | Label | Uses mobile label size unless overridden by consumer monospace settings. |
| Kicker | Label | Grows from 12px desktop to 13px mobile. |
| InfoText | RichTextLabel | Uses mobile body size through `normal_font_size`. |
| CardPanel | PanelContainer | Keeps radius identity; padding follows density-scaled recipes where authored. |
| HeroPanel | PanelContainer | Keeps radius identity; mobile mode changes sizing, not brand identity. |

## Requirement Traceability

| Requirement | Phase 8 coverage |
|---|---|
| MOBILE-01 | Mobile is `platform=MOBILE` on `NeoCadeTheme`, not a separate file. |
| MOBILE-02 | Audit enforces the 48px mobile floor for enforceable interactive rows. |
| MOBILE-03 | Body is 16 on mobile; HeaderLarge/HeaderMedium/HeaderSmall retain desktop sizes. |
| MOBILE-04 | `densityScale=1.5`, `tapPadding=12`, and radii remain platform-stable. |
| MOBILE-05 | Density buckets are handled by Godot scaling/stretch, not per-density theme resources. |
| MOBILE-06 | Tap-target audit passes for every enforceable interactive row. |
| MOBILE-07 | This root spec documents deltas, rationale, evidence, and limitations. |
| MOBILE-08 | Mobile preserves NeoCade identity and avoids native iOS/Android imitation. |
| DOCS-02 | Root mobile delta documentation exists. |
| TYPEVAR-06 | The authoritative core runtime variations are documented with mobile behavior; editor-only variations are handled separately in `TYPE_VARIATIONS`. |

## Phase 9 And Phase 10 Handoff

- Phase 9 may build the full showcase, but should preserve this Phase 8 fixture boundary: no new mobile `.tres`, no per-density resources, and no subclasses.
- Phase 10 owns final cross-platform export and screenshot validation, including real Android/iOS/Web checks subject to UD-5.
- This spec is implementation evidence, not final device certification.
