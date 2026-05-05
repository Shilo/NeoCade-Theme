# Material Design 3 and MD3 Expressive Research

**Authored:** 2026-05-05  
**Phase:** 03.1-source-dive-md3-and-flat-3d-game-ui-research  
**Status:** Execution skeleton created by Plan 03.1-01; detailed MD3 findings added by Plans 03.1-02, 03.1-03, and 03.1-06.

## Scope and Non-Scope

This document captures Material Design 3 and MD3 Expressive visual-language research for NeoCade. It is evidence-grade research for downstream Phase 3.3 theme-direction derivation, Phase 3.4 mockups, and Phase 4+ visual formula implementation.

In scope: MD3 color system, tonal palettes, semantic roles, type scale, shape scale, state layers, elevation principles, static MD3 Expressive visual deltas, component patterns, and Godot Control mapping notes.

Out of scope: deriving the five NeoCade directions, making mockups, validating `NeoCadeTheme` architecture, writing `.gd` scripts, editing `.tres` resources, choosing final hex tokens, or approving final art direction.

## Source Roles and Citation Contract

Required evidence roles:

| Evidence role | Use in this document |
|---|---|
| official/spec | Material, Google, Android Developers, or Godot documentation used as authoritative facts. |
| upstream token source | Material Web source files or other upstream token/code sources used to corroborate numeric values. |
| user exemplar | User-provided sources. Not expected in the MD3 lane unless cross-referenced from Flat-3D research. |
| commercial example | Real shipped product examples. Not authoritative for MD3 facts. |
| asset-pack example | Public UI pack examples. Not authoritative for MD3 facts. |
| design commentary | Design-system or UI commentary used only as interpretive support. |

Required source-access status labels:

| source-access status | Meaning |
|---|---|
| directly extracted | Text or code was accessible through the source itself. |
| upstream-token corroborated | Numeric facts were verified through upstream source files. |
| browser/manual verified | Visual or JS-rendered content required browser/manual confirmation. |
| fallback source used | The official URL is retained, but an accessible equivalent source supplies the fact. |
| unresolved extraction gap | The required fact could not be corroborated; name the missing value and downstream owner. |

Citation-quality contract:

- Numeric facts must include source URL, evidence role, access status, retrieved date, and source agreement note.
- JS-rendered or hard-to-extract sources must keep the official URL in provenance and either cite a pinned upstream/source equivalent or mark `unresolved extraction gap`.
- Presence-only keyword checks are insufficient for final verification; downstream plans must add citation-density, numeric correctness, and source-agreement checks.
- Facts that affect Phase 3.3/3.4 visual choices should distinguish authority from inspiration.

## Hard NeoCade Filter

The Phase 3 redirect locks the design filter for this research:

- NO textures, patterns, embossing, painterly chrome, gradients on chrome, cyberpunk, synthwave/noir drift, pixel art, soft shadows, blurred shadows, bevel gradients, conventional 3D.
- YES flat MD3/MD3 Expressive, colorful/playful/expressive, optional extruded-flat raised treatment via a solid top shape plus offset darker duplicate.
- Typography assumption: Inter Variable Roman only in v1. No display font, pixel font, mono font, or external font family is adopted here. Headings may vary by optical size, weight, scale, spacing, and layout only.

v0 DNA note: Midnight Marquee and Cabinet Chrome dark saturated colors, Prize Pop Plaza friendly raised-mobile tone, and Orbital Playdeck modern-dark restraint may be interpreted lightly by downstream work. Boardwalk Sunset is hard rejected. No new direction is derived in this document.

## Provenance Table

| Source | URL | Evidence role | source-access status | Retrieved | Facts captured | source agreement / gap |
|---|---|---|---|---|---|---|
| Material color system overview | https://m3.material.io/styles/color/system/overview | official/spec | browser/manual verified; fallback source used | 2026-05-05 | Official landing URL for color system, key colors, tonal palettes, dynamic color principle, and semantic roles. | Official page returned `This website requires JavaScript`; Android Developers and Material Web token files supply extractable corroboration. |
| Android Developers Material Design 3 in Compose | https://developer.android.com/develop/ui/compose/designsystems/material3 | official/spec | directly extracted | 2026-05-05 | Material theme subsystems, five key colors, tonal palettes, dynamic color setup, color-role usage, 15-role typography values, shape examples, accessibility guidance, system UI ripple/overscroll notes, and MD3 Expressive current note. | Source agreement: corroborates Material official role model and Material Web token values. Last updated 2026-03-30 UTC per source/search result. |
| Material type scale tokens | https://m3.material.io/styles/typography/type-scale-tokens | official/spec | browser/manual verified; fallback source used | 2026-05-05 | Official URL retained for type scale token canon. | Official page returned `This website requires JavaScript`; Android Developers and Material Web raw `_md-sys-typescale.scss` supply accessible values. |
| Material Web type scale source | https://raw.githubusercontent.com/material-components/material-web/main/tokens/versions/v0_192/_md-sys-typescale.scss | upstream token source | upstream-token corroborated | 2026-05-05 | 15 typography roles with size, line-height, tracking, and weight tokens. | Source agreement: rem values match Android Developers px values at 16px root; Material Web additionally exposes tracking. |
| Material shape scale tokens | https://m3.material.io/styles/shape/shape-scale-tokens | official/spec | browser/manual verified; fallback source used | 2026-05-05 | Official URL retained for shape token canon. | Official URL redirected to a JS-rendered shape page in this runtime; Material Web shape source and Android Developers shape examples supply accessible values. |
| Material Web shape source | https://raw.githubusercontent.com/material-components/material-web/main/tokens/versions/v0_192/_md-sys-shape.scss | upstream token source | upstream-token corroborated | 2026-05-05 | Shape tokens: none, extra-small, small, medium, large, extra-large, full plus directional variants. | Source agreement: same role family as Android Developers; note numeric delta for `extraLarge` sample (Android page uses 24dp sample, Material Web v0.192 token says 28px). NeoCade does not adopt final radii here. |
| Material state layers | https://m3.material.io/foundations/interaction/states/state-layers | official/spec | browser/manual verified; fallback source used | 2026-05-05 | Official URL retained for state-layer model. | Official page returned `This website requires JavaScript`; Material Web raw state tokens supply hover/focus/pressed/dragged values. |
| Material Web state source | https://raw.githubusercontent.com/material-components/material-web/main/tokens/versions/v0_192/_md-sys-state.scss | upstream token source | upstream-token corroborated | 2026-05-05 | hover 8%, focus 12%, pressed 12%, dragged 16%. | Source agreement: matches ARCHITECTURE.md and ROADMAP.md expected values. |
| Material Web filled-button source | https://raw.githubusercontent.com/material-components/material-web/main/tokens/versions/v0_192/_md-comp-filled-button.scss | upstream token source | upstream-token corroborated | 2026-05-05 | Disabled container opacity 12%, disabled label/icon opacity 38%, button height 40px, full corner token, state-layer token wiring. | Source agreement: supplies component-level disabled values not present in the system state file. |
| Material Web outlined-button source | https://raw.githubusercontent.com/material-components/material-web/main/tokens/versions/v0_192/_md-comp-outlined-button.scss | upstream token source | upstream-token corroborated | 2026-05-05 | Disabled outline opacity 12%, disabled label/icon opacity 38%, outline width 1px, state-layer token wiring. | Source agreement: corroborates disabled 38% content / 12% container-outline pattern. |
| Material Web theming docs | https://material-web.dev/theming/material-theming/ | official/spec | directly extracted | 2026-05-05 | System token role names for color and typography in Material Web. | Source agreement: describes `--md-sys-color-*` and `--md-sys-typescale-*` role mapping used by components. |
| Material Web shape docs | https://material-web.dev/theming/shape/ | official/spec | directly extracted | 2026-05-05 | Public CSS custom-property naming for shape tokens. | Source agreement: lists shape token names and sample small/medium/large values. |
| Material Web elevation source | https://raw.githubusercontent.com/material-components/material-web/main/tokens/versions/v0_192/_md-sys-elevation.scss | upstream token source | upstream-token corroborated | 2026-05-05 | MD3 elevation level numerics 0, 1, 3, 6, 8, 12. | Source agreement: useful as MD3 reference only; NeoCade rejects soft shadows and adopts tonal depth only. |
| Material Web color source | https://raw.githubusercontent.com/material-components/material-web/main/tokens/versions/v0_192/_md-sys-color.scss | upstream token source | upstream-token corroborated | 2026-05-05 | Dark/light semantic roles including primary, secondary, tertiary, surface-container ladder, outline, scrim, shadow. | Source agreement: corroborates Android Developers color-role guidance and NeoCade's 5-stop tonal surface ramp. |
| Godot `StyleBoxFlat` docs | https://docs.godotengine.org/en/stable/classes/class_styleboxflat.html | official/spec | directly extracted | 2026-05-05 | `bg_color`, `border_color`, corner radius, content margins, `shadow_color`, `shadow_offset`, `shadow_size`, and skew warning. | Source agreement: confirms direct StyleBoxFlat shadow properties exist, but no hard-edged duplicate without shadow semantics is proven. |
| Godot `Theme` docs | https://docs.godotengine.org/en/stable/classes/class_theme.html | official/spec | directly extracted | 2026-05-05 | Theme items, type variation checks, and merge APIs. | Source agreement: sufficient for mapping research; architecture validation stays Phase 3.2. |
| Godot Theme type variations tutorial | https://docs.godotengine.org/en/stable/tutorials/ui/gui_theme_type_variations.html | official/spec | directly extracted | 2026-05-05 | Theme variation concepts used for Button/Label/Panel variant recommendations. | Source agreement: used for mapping/escape hatch notes only. |
| Official Material JS extraction gap note | https://m3.material.io/ | official/spec | unresolved extraction gap | 2026-05-05 | Direct text extraction from several `m3.material.io` pages was not available without JavaScript. | Non-blocking: all required numeric facts are corroborated through Android Developers and Material Web raw token sources. No downstream owner unless Phase 3.3 needs visual screenshots from Material pages. |

## MD3 Foundations

### Foundation Summary

Material Design 3 contributes a system grammar rather than a final NeoCade look: key colors generate tonal palettes; semantic color roles map those palettes into components; typography is organized into 15 named roles; shape is a token scale; interaction states are encoded as state layers; elevation is a system concept but NeoCade adopts only tonal depth because the project has a no-soft-shadow constraint.

### Color System

| MD3 concept | Source URL | evidence role | source-access status | Retrieved | Source fact / source agreement | NeoCade adoption boundary |
|---|---|---|---|---|---|---|
| key colors | https://developer.android.com/develop/ui/compose/designsystems/material3 | official/spec | directly extracted | 2026-05-05 | Android Developers says a color scheme is founded on five key colors, each related to a tonal palette of 13 tones. | Adopt the idea of key colors and tonal palettes as structure. Do not adopt Android wallpaper-derived dynamic color for v1. |
| dynamic color principle | https://developer.android.com/develop/ui/compose/designsystems/material3 | official/spec | directly extracted | 2026-05-05 | Dynamic color can generate light/dark schemes from wallpaper on Android 12+. | Reject dynamic wallpaper sourcing for NeoCade v1; theme subclasses use curated base/accent colors. |
| semantic roles | https://developer.android.com/develop/ui/compose/designsystems/material3 | official/spec | directly extracted | 2026-05-05 | Primary is used for prominent buttons/active states/tint of elevated surfaces; secondary expands color expression for less prominent components; tertiary balances or draws enhanced attention. | Adopt semantic role aliases (`primary`, `secondary`, `tertiary`, `danger`, etc.) rather than hue-only naming. |
| accessible role pairing | https://developer.android.com/develop/ui/compose/designsystems/material3 | official/spec | directly extracted | 2026-05-05 | Android Developers warns to pair `on-primary` with `primary`, `on-primary-container` with `primary-container`, and equivalent role pairs for contrast. | Adopt strict on-role pairing and WCAG checks before any final token is accepted. |
| surface roles | https://raw.githubusercontent.com/material-components/material-web/main/tokens/versions/v0_192/_md-sys-color.scss | upstream token source | upstream-token corroborated | 2026-05-05 | Material Web exposes `surface`, `surface-container-lowest`, `surface-container-low`, `surface-container`, `surface-container-high`, and `surface-container-highest`. | Adopt the surface-container ladder as NeoCade's tonal depth vocabulary; final hex values belong to Phase 3.4/4. |

NeoCade result: color should stay flat, saturated, playful, and role-driven. The source agreement across Android Developers and Material Web supports using MD3 as a role system. It does not justify glow, blur, or dynamic wallpaper-driven palettes.

### Typography: 15-Role Type Scale

All values below use the Android Developers px/sp display names and are cross-checked against Material Web rem tokens at a 16px root. NeoCade keeps Inter Variable Roman only; `displayLarge` etc. are roles, not font-family changes.

| MD3 role | Size / line-height | Weight | Tracking source note | Source URL | source-access status | source agreement / NeoCade note |
|---|---:|---|---|---|---|---|
| displayLarge | 57 / 64 | regular | -0.25px from Material Web `-0.015625rem` | https://developer.android.com/develop/ui/compose/designsystems/material3 and https://raw.githubusercontent.com/material-components/material-web/main/tokens/versions/v0_192/_md-sys-typescale.scss | directly extracted; upstream-token corroborated | Android values and Material Web rem values agree. NeoCade may use this only for rare showcase or direction-board scale, with Inter Variable Roman. |
| displayMedium | 45 / 52 | regular | 0 | same as above | directly extracted; upstream-token corroborated | Agreement. |
| displaySmall | 36 / 44 | regular | 0 | same as above | directly extracted; upstream-token corroborated | Agreement. |
| headlineLarge | 32 / 40 | regular | 0 | same as above | directly extracted; upstream-token corroborated | Agreement. |
| headlineMedium | 28 / 36 | regular | 0 | same as above | directly extracted; upstream-token corroborated | Agreement. |
| headlineSmall | 24 / 32 | regular | 0 | same as above | directly extracted; upstream-token corroborated | Agreement. |
| titleLarge | 22 / 28 | regular | 0 | same as above | directly extracted; upstream-token corroborated | Agreement. |
| titleMedium | 16 / 24 | medium | 0.15px from Material Web `0.009375rem` | same as above | directly extracted; upstream-token corroborated | Agreement. |
| titleSmall | 14 / 20 | medium | 0.1px from Material Web `0.00625rem` | same as above | directly extracted; upstream-token corroborated | Agreement. |
| bodyLarge | 16 / 24 | regular | 0.5px from Material Web `0.03125rem` | same as above | directly extracted; upstream-token corroborated | Agreement. |
| bodyMedium | 14 / 20 | regular | 0.25px from Material Web `0.015625rem` | same as above | directly extracted; upstream-token corroborated | Agreement. |
| bodySmall | 12 / 16 | regular | 0.4px from Material Web `0.025rem` | same as above | directly extracted; upstream-token corroborated | Agreement. |
| labelLarge | 14 / 20 | medium | 0.1px from Material Web `0.00625rem` | same as above | directly extracted; upstream-token corroborated | Agreement. |
| labelMedium | 12 / 16 | medium | 0.5px from Material Web `0.03125rem` | same as above | directly extracted; upstream-token corroborated | Agreement. |
| labelSmall | 11 / 16 | medium | 0.5px from Material Web `0.03125rem` | same as above | directly extracted; upstream-token corroborated | Agreement. |

NeoCade result: use the role ladder as a sizing spine, but do not copy Roboto or introduce a separate display family. Inter Variable Roman can vary by weight/opsz/size/layout. Letter spacing should be rounded cautiously in Godot because theme constants are not fractional typography systems.

### Shape Scale

| Shape token | Material Web value | Android Developers sample | Source URL | source-access status | source agreement / NeoCade note |
|---|---:|---:|---|---|---|
| corner-none | 0px | not listed in sample | https://raw.githubusercontent.com/material-components/material-web/main/tokens/versions/v0_192/_md-sys-shape.scss | upstream-token corroborated | Adopt as divider/tab-strip option only. |
| corner-extra-small | 4px | 4dp | same | upstream-token corroborated | Strong match; maps well to compact Godot controls. |
| corner-small | 8px | 8dp | same | upstream-token corroborated | Strong match; useful for panels and larger buttons if direction wants softness. |
| corner-medium | 12px | 12dp | same | upstream-token corroborated | Strong match; likely popup/card candidate. |
| corner-large | 16px | 16dp | same | upstream-token corroborated | Strong match; use sparingly for expressive controls. |
| corner-extra-large | 28px | 24dp sample | same plus https://developer.android.com/develop/ui/compose/designsystems/material3 | upstream-token corroborated; directly extracted | Numeric difference between Material Web token and Compose sample. Non-blocking because NeoCade final radii are not selected in Phase 3.1. |
| corner-full | 9999px | full/circular concept | same | upstream-token corroborated | Useful for pill/toggle mode only; not a global shape default. |

NeoCade mapping to `StyleBoxFlat`: use `corner_radius_*` for per-corner values. Shape can express personality, but must avoid bevels, embossing, texture, and conventional 3D.

### State Layers and Disabled Values

| State / value | Numeric fact | Source URL | evidence role | source-access status | Retrieved | source agreement / NeoCade translation |
|---|---:|---|---|---|---|---|
| hover 8% | `hover-state-layer-opacity: 0.08` | https://raw.githubusercontent.com/material-components/material-web/main/tokens/versions/v0_192/_md-sys-state.scss | upstream token source | upstream-token corroborated | 2026-05-05 | Matches ROADMAP.md required hover 8%. Translate to a hover stylebox by blending the content/on-role color over the container. |
| focus 12% | `focus-state-layer-opacity: 0.12` | same | upstream token source | upstream-token corroborated | 2026-05-05 | Matches ROADMAP.md required focus 12%. NeoCade additionally requires a 2px focus ring from project accessibility requirements. |
| pressed 12% | `pressed-state-layer-opacity: 0.12` | same | upstream token source | upstream-token corroborated | 2026-05-05 | Matches ROADMAP.md required pressed 12%. |
| dragged 16% | `dragged-state-layer-opacity: 0.16` | same | upstream token source | upstream-token corroborated | 2026-05-05 | Matches ROADMAP.md required dragged 16%; mostly relevant to sliders, tabs, graph nodes, splitters, and drag/drop affordances. |
| disabled 38% content | `disabled-label-text-opacity: 0.38`; disabled icon opacity also 0.38 | https://raw.githubusercontent.com/material-components/material-web/main/tokens/versions/v0_192/_md-comp-filled-button.scss and https://raw.githubusercontent.com/material-components/material-web/main/tokens/versions/v0_192/_md-comp-outlined-button.scss | upstream token source | upstream-token corroborated | 2026-05-05 | Matches ROADMAP.md disabled 38% content requirement. Use for disabled text/icon color derivation. |
| disabled container 12% | `disabled-container-opacity: 0.12`; outlined disabled outline opacity 0.12 | same filled/outlined button sources | upstream token source | upstream-token corroborated | 2026-05-05 | Matches ROADMAP.md disabled container 12% requirement. Use for disabled background or outline, never as hidden/unreadable content. |
| focus ring | 2px solid ring | .planning/ROADMAP.md and .planning/phases/03.1-source-dive-md3-and-flat-3d-game-ui-research/03.1-CONTEXT.md | project requirement | directly extracted from local project docs | 2026-05-05 | MD3 state-layer value alone is insufficient for Godot accessibility; NeoCade must provide a visible 2px ring without glow. |

### Elevation

| Concept | Source URL | source-access status | Source fact / source agreement | NeoCade decision |
|---|---|---|---|---|
| elevation levels | https://raw.githubusercontent.com/material-components/material-web/main/tokens/versions/v0_192/_md-sys-elevation.scss | upstream-token corroborated | Material Web exposes levels 0, 1, 3, 6, 8, 12. | Informational only. NeoCade does not use soft shadows in v1. |
| elevated surfaces and tint | https://developer.android.com/develop/ui/compose/designsystems/material3 | directly extracted | Android Developers describes primary tint and component elevation in Material contexts. | Adopt tonal surface depth only: surface/container roles carry hierarchy. |
| Godot shadow feasibility | https://docs.godotengine.org/en/stable/classes/class_styleboxflat.html | directly extracted | `shadow_color`, `shadow_offset`, and `shadow_size` exist; `shadow_color` has no effect when `shadow_size` is lower than 1. | Do not use StyleBoxFlat soft shadows as MD3 elevation. Raised-mode hard offset is investigated in Flat-3D research, not here. |

### Motion

Motion is informational for Phase 3.1. Android Developers and the Google MD3 Expressive launch post both discuss motion/system behavior, but a Godot Theme resource cannot encode spring animation, haptics, ripple behavior, overscroll, or runtime choreography. NeoCade may adopt the static visual intent behind motion: clear hierarchy, immediate state feedback, and glanceable emphasis. It rejects motion as a v1 Theme requirement.

## MD3 Expressive Delta

### Source Status and Dates

| Source | URL | Evidence role | source-access status | Retrieved / source date | Facts captured | source agreement / gap |
|---|---|---|---|---|---|---|
| Material official Expressive blog entry | https://m3.material.io/blog/building-with-m3-expressive | official/spec | browser/manual verified; fallback source used | Retrieved 2026-05-05 | Official Material URL for building with M3 Expressive. | Official page is JS-rendered in this runtime; Android Developers and Google blog sources provide extractable corroboration. |
| Google launch post | https://blog.google/products/android/material-3-expressive-android-wearos-launch/ | official/spec | directly extracted | Published 2025-05-13; retrieved 2026-05-05 | Public launch framing for Android/Wear OS refresh and personalization. | Source agreement: aligns with Android Developers page that M3 Expressive expands MD3 and complements Android 16 visual style/system UI. |
| Legacy/redirected Google URL from plan | https://blog.google/products-and-platforms/platforms/android/material-3-expressive-android-wearos-launch/ | official/spec | fallback source used | Retrieved 2026-05-05 | Planned URL path appears superseded by the `products/android` URL. | Non-blocking fallback: use canonical Google blog URL above. |
| Android Developers Material Design 3 in Compose | https://developer.android.com/develop/ui/compose/designsystems/material3 | official/spec | directly extracted | Last updated 2026-03-30 UTC; retrieved 2026-05-05 | Current source check: Jetpack Compose implements Material You and Material 3 Expressive; Expressive expands MD3 across theming, components, motion, typography, and more. | Source agreement: current developer docs confirm Expressive is still the active MD3 evolution, not only a 2025 announcement. |
| Compose Material 3 release notes | https://developer.android.com/jetpack/androidx/releases/compose-material3 | official/spec | directly extracted | Latest update 2026-04-22; retrieved 2026-05-05 | Current-source check after the 2025-05-13 announcement; lists stable 1.4.0 and alpha 1.5.0-alpha18, plus Wear OS Expressive guidance. | Source agreement: confirms active development and that Wear OS Expressive uses Wear Compose Material 3 rather than the phone/tablet library. |
| Wear OS 6 features | https://developer.android.com/training/wearables/versions/6/features?hl=en | official/spec | directly extracted | Last updated 2026-03-05 UTC; retrieved 2026-05-05 | Wear OS 6 includes a design refresh based on Material 3 Expressive. | Source agreement: separates Wear OS round-display behavior from reusable visual-language principles. |
| Android Developers Blog for Wear OS Expressive | https://android-developers.googleblog.com/2025/08/introducing-material-3-expressive-for-wear-os.html | official/spec | directly extracted | Published 2025-08-25; retrieved 2026-05-05 | Post-launch official/developer source describing Wear OS Expressive personality and round-screen quick-action confidence. | Source agreement: useful as platform-specific evidence; NeoCade rejects Wear OS round-display behavior as implementation scope. |
| Official extraction gap row | https://m3.material.io/ | official/spec | unresolved extraction gap | Retrieved 2026-05-05 | Direct non-JS extraction from Material official pages remains limited. | Non-blocking: all Expressive facts used here are corroborated by current Google/Android Developers sources; no downstream owner unless Phase 3.3 wants official-page screenshots. |

### Delta vs Baseline MD3

| Expressive delta | Official/source basis | NeoCade interpretation |
|---|---|---|
| More personality | Google launch post and Android Developers docs present Expressive as a research-backed expansion intended to make products more engaging/desirable. | Adopt stronger direction-level personality in Phase 3.3: different themes may vary shape, hierarchy, accent confidence, and density more than baseline MD3 would. |
| More expressive color | Google/Android sources connect Expressive to personalization and dynamic color. | Adopt controlled saturation and bolder color hierarchy, but not Android wallpaper dynamic color or magenta/cyan synthwave lock-in. |
| Theming + component updates | Android Developers current page names theming and components as part of the Expressive expansion. | Adopt larger emphasis moments and clearer action hierarchy in static controls. |
| Motion | Android Developers names motion as part of Expressive. | Reject/defer as Theme behavior. A Godot Theme resource cannot encode spring choreography or product-level animation. |
| Typography | Android Developers names typography as part of Expressive. | Adopt scale, weight, and layout expressiveness inside Inter Variable Roman only; do not add a display font. |
| Android 16 system UI | Android Developers says M3 Expressive complements Android 16 visual style/system UI. | Reject system UI behavior as out of scope. NeoCade is cross-platform Godot UI, not Android-native system chrome. |
| Wear OS behavior | Wear OS sources apply Expressive to round displays and quick actions. | Reject round-display-specific layout as source authority for NeoCade; keep only the idea of glanceable quick-action hierarchy. |

### Static Design-Language Value for NeoCade

Adopt:

- Stronger personality than baseline MD3, expressed through theme-direction-specific shapes, density, surface rhythm, and accent distribution.
- Saturated but controlled color: colorful/playful/expressive without making every surface loud.
- Larger emphasis moments where static Theme resources can show them: primary action buttons, selected tabs, active toggles, dialog actions, and major navigation surfaces.
- Expressive shape/scale where it improves hierarchy: larger corners or bigger target surfaces in some directions, without bevels or texture.
- Glanceable hierarchy: quick scan of primary/secondary/disabled/focused states through color, outline, scale, and typography.

Reject/defer:

- Android/Wear OS platform behavior, Live Updates, system notifications, system UI, round-display adaptation, dynamic wallpaper color, haptics, spring animation, blur/depth backgrounds, or any motion-only behavior.
- Glow, synthwave pairings, textured/materialized chrome, painterly effects, or display-font substitutions.

Post-launch check: A 2026-05-05 search found current official/developer sources after the 2025-05-13 announcement, specifically Android Developers Material 3 in Compose (last updated 2026-03-30 UTC), Compose Material 3 release notes (latest update 2026-04-22), and Wear OS 6 feature docs (last updated 2026-03-05 UTC). This means Phase 3.1 should treat Expressive as current active guidance, with Android/Wear OS platform features carefully filtered out for Godot Theme scope.

## Component to Godot Control Mapping

Mapping rule: exact Material component matches are useful where they exist, but Godot has many editor/runtime Controls that do not have a direct Material equivalent. Those must be composed from MD3 principles or labeled as NeoCade-owned decisions. No fake Material equivalent should be invented.

| Godot Control / family | MD3 reference pattern | Mapping type | Visual direction for NeoCade | Source basis / note |
|---|---|---|---|---|
| Button | Filled, filled tonal, outlined, text, elevated button families | Exact | Base Button maps to a flat filled or tonal action depending on type variation. PrimaryButton/DangerButton/GhostButton/FlatButton can mirror MD3 action hierarchy while using NeoCade role names. | https://developer.android.com/develop/ui/compose/designsystems/material3 and Material Web button tokens. |
| CheckBox | Checkbox selection control | Exact | Use MD3 state layers and role color for checked/focused states; keep icon geometry crisp and flat. | Material component pattern; Godot owns exact theme icon slots. |
| CheckButton | Switch / toggle control | Exact-adjacent | Map to MD3 switch semantics, but render using Godot CheckButton theme slots. | MD3 switch principle; no one-to-one name but behavior matches. |
| OptionButton | Button plus menu | Composed | Button chrome for closed state; PopupMenu surface/menu item rules for open state. | Compose Button + PopupMenu. Do not rely on parent theme inheritance because popup is a Window. |
| MenuButton | Button plus menu | Composed | Same as OptionButton but with command/menu semantics rather than selected-value semantics. | Compose Button + PopupMenu. |
| PopupMenu | Menus | Exact-adjacent | High surface role, item state layers, check/radio/submenu icons; no glow or texture. | Material menus; Godot PopupMenu has extensive item icons and separators. |
| LinkButton | Text button / link | Exact-adjacent | Use text-button state layers and link role color; keep underline/hover behavior Godot-native. | MD3 text button hierarchy; Godot LinkButton-specific theme entries. |
| ColorPickerButton | Button plus ColorPicker dialog | Composed | Button state model plus swatch affordance; open picker uses dialog/panel tokens. | No fake Material equivalent; compose from Button + ColorPicker + popup/dialog principles. |
| LineEdit | Text field | Exact | Flat/outlined input with visible focus ring, selection/caret colors, placeholder text, and disabled text/container opacity. | MD3 text field principles; Godot LineEdit theme slots. |
| TextEdit | Multi-line text field | Exact-adjacent | Same visual language as LineEdit with scroll, selection, caret, and read-only states. | MD3 text field principles; Godot TextEdit state entries. |
| CodeEdit | Text field plus code gutter | Composed | TextEdit chrome plus gutter/line-number/bookmark/breakpoint affordances. Syntax colors are app-level, not Theme scope. | No fake Material equivalent; compose from text field and NeoCade-owned code-surface rules. |
| SpinBox | Text field plus stepper buttons | Composed | LineEdit-style field with small button-like steppers; raised mode should not lift the whole field. | No fake Material equivalent; compose from text field + compact buttons. |
| Label | Typography roles | Exact | Map MD3 type roles to Label type variations using Inter Variable Roman only. | Type scale source rows above. |
| RichTextLabel | Typography roles plus rich text surface | Exact-adjacent | Same color/type scale as Label; BBCode/code snippets remain content-level, not new fonts. | Type scale source rows above; Godot RichTextLabel docs via FEATURES.md. |
| ProgressBar | Linear progress indicator | Exact | Track/fill colors from role and state tokens; avoid animated behavior beyond app logic. | MD3 progress indicator principle. |
| HSlider / VSlider | Slider | Exact | Track, active fill, handle, ticks, hover/dragged/focus states from MD3 state layers. | State-layer source rows; Godot Slider theme slots. |
| HScrollBar / VScrollBar | Scrollbar | NeoCade-owned decision | MD3 has platform scrolling principles but not a direct theme component. Use low-emphasis track, clear grabber, and dragged 16% state. | No fake Material equivalent; derive from MD3 state hierarchy and Godot-minimal coverage. |
| TabBar / TabContainer | Tabs | Exact-adjacent | Selected tab uses role accent and state layer; unselected tabs stay quiet; focus ring remains visible. | Material tab principles plus Godot TabBar slots. |
| ItemList | Lists | Exact-adjacent | List items use hover 8%, selected state, focus ring/cursor, and optional icon accents. | Material list principles; Godot ItemList has cursor/selected theme entries. |
| Tree | Lists plus disclosure / hierarchy | Composed | Tree rows follow list state layers; disclosure icons and guide lines are NeoCade-owned. | Compose Material lists + Godot tree affordances. |
| Panel / PanelContainer | Surface / card | Exact-adjacent | Flat surface role with border/radius; raised mode normally stays flat unless used as popup/dialog shell. | Material surfaces/cards as inspiration; NeoCade no soft shadow. |
| PopupPanel / TooltipPanel / TooltipLabel | Surface / tooltip | Exact-adjacent | Highest surface role, compact padding, high contrast, no blurred shadow. | Material tooltip/menu surface principles; popup separate-Window pitfall. |
| Window / AcceptDialog / ConfirmationDialog / FileDialog | Dialogs / sheets | Composed | Dialog surface, title typography, action buttons, and inner list/input controls. | Compose Material dialog principles with Godot Window/Dialog-specific slots. |
| MenuBar | App bar/menu launcher | NeoCade-owned decision | Quiet toolbar/menu row with button-like hover/focus states and PopupMenu continuity. | No fake Material equivalent; derive from navigation/action hierarchy. |
| ColorPicker | Picker / composite editor | NeoCade-owned decision | Treat as advanced composite: fields, sliders, swatches, preview surfaces, and action buttons share base recipes. | No fake Material equivalent; Godot owns picker-specific theme entries. |
| GraphEdit | Canvas/workspace surface | NeoCade-owned decision | Low-contrast workspace surface, grid/connection colors, drag/selection/focus feedback from state layers. | No fake Material equivalent; derive from MD3 surfaces and Godot graph editor needs. |
| GraphNode | Card/node surface | NeoCade-owned decision | Card-like node surface, title strip, port colors, selection/focus rings; no fake Material component name. | Derived from Material cards + NeoCade graph semantics. |
| GraphFrame | Grouping / section surface | NeoCade-owned decision | Low-emphasis grouping surface with outline and label typography; no raised treatment by default. | Derived from surface hierarchy. |
| FoldableContainer | Disclosure section | Composed | Header button/list row plus collapsible panel body; disclosure icon from Tree semantics. | Compose Tree disclosure + PanelContainer surface. |
| HSplitContainer / VSplitContainer | Drag handle / divider | NeoCade-owned decision | Divider line plus grabber icon; dragged 16% state if interactive. | No fake Material equivalent; derive from state layers and Godot split handle behavior. |
| HSeparator / VSeparator | Divider | Exact-adjacent | Outline/variant color only; no raised delta. | Material divider principle. |
| Passive layout Containers | Layout only | NeoCade-owned decision | Constants only where supported; no visible chrome. | No fake Material equivalent; do not theme invisible layout as surfaces. |

D-14 coverage note: `SpinBox`, `CodeEdit`, `GraphEdit`, `GraphNode`, `GraphFrame`, `FileDialog`, `FoldableContainer`, `MenuBar`, and splitter/separator chrome are composed or NeoCade-owned mappings. They should inherit MD3 discipline, not Material component names.

## Godot Visual Recipe Notes

These recipes are implementation-neutral sketches. They describe what Phase 3.2 architecture and Phase 4+ token implementation must support, without deciding code structure.

### Flat `StyleBoxFlat` Baseline

| Slot | Recipe sketch | Godot field / source |
|---|---|---|
| Fill | One solid semantic surface or role color. | `bg_color`; https://docs.godotengine.org/en/stable/classes/class_styleboxflat.html |
| Border | Optional 1px outline role for outlined controls and panels. | `border_color`, `border_width_*` |
| Corners | MD3 shape role translated to integer corner radii. | `corner_radius_top_left`, `corner_radius_top_right`, `corner_radius_bottom_left`, `corner_radius_bottom_right` |
| Padding | Tokenized content margins per Control family. | `content_margin_*` |
| Shadows | Disabled in the flat baseline. | `shadow_size = -1` per project no-soft-shadow rule and StyleBoxFlat shadow pitfall. |
| Anti-aliasing | Keep antialiased corners/edges enabled unless a future Godot screenshot pass proves a renderer issue. | StyleBoxFlat AA fields; verify in GL Compatibility later. |

### State-Layer Approximation

Create state styleboxes by blending the state-layer color over the container color:

```text
state_color = blend(container_color, state_layer_color, opacity)
```

State values cross-check:

| State | Value | Application sketch |
|---|---:|---|
| hover 8% | 0.08 | Blend role/on-role color over base container for `hover` stylebox. |
| focus 12% | 0.12 | Blend focus/on-role color where useful, plus visible 2px focus ring. |
| pressed 12% | 0.12 | Blend toward on-role or darken filled accents for `pressed`. |
| dragged 16% | 0.16 | Use for draggable sliders, split handles, tab reorder, graph elements. |
| disabled 38% content | 0.38 | Derive disabled text/icon colors. |
| disabled container 12% | 0.12 | Derive disabled filled/outline containers. |

Numeric correctness note: hover/focus/pressed/dragged are sourced from Material Web system state tokens; disabled 38% content / disabled container 12% is sourced from Material Web filled/outlined button component tokens. The Phase 3.1 Verification Log must keep this source agreement visible.

### Focus Recipe

Focus must be a separate visible ring, not only a font color or background tint:

- 2px solid focus ring.
- No glow, blur, chromatic aberration, or soft shadow.
- Ring color comes from the approved theme primary/focus role.
- The ring must remain visible against normal, hover, pressed, checked, selected, and disabled-adjacent surfaces.

### Disabled Recipe

Use two channels:

- Content: text, icon, checkmark, slider handle, and progress label use disabled 38% content treatment.
- Container: filled background, outline, or track uses disabled container 12% treatment.

Godot may require precomputed colors per state slot rather than runtime alpha stacking. That is implementation detail for Phase 4; this document only requires the derived colors to follow the documented values.

### Surface Ramp Translation

| MD3 role family | NeoCade research alias | Godot targets |
|---|---|---|
| `surface` | base/root | root Control background, Window base. |
| `surface-container-low` | low/secondary | inactive tabs, scroll tracks, low-emphasis list rows. |
| `surface-container` | panel | Panel, PanelContainer, GraphEdit workspace. |
| `surface-container-high` | raised/action field | Button normal, LineEdit, OptionButton, MenuBar. |
| `surface-container-highest` | overlay | PopupMenu, PopupPanel, TooltipPanel, AcceptDialog/FileDialog surface. |

The final hex values are intentionally absent. Phase 3.4 approval and Phase 4 token implementation own them.

## Adoption, Rejection, and Open Questions

| Category | Adopt | Reject / defer | Open for downstream |
|---|---|---|---|
| Baseline MD3 | Tokenized roles, tonal surfaces, state-layer values, shape/type scales, component hierarchy. | Roboto dependency, dynamic wallpaper sourcing, soft shadow elevation, app/runtime motion. | Which final NeoCade directions should be denser, rounder, brighter, or more restrained. |
| Godot mapping | Exact mappings where natural; composed mappings for SpinBox, CodeEdit, Tree, dialogs, and graph surfaces. | Fake Material component names for Godot-specific Controls. | Phase 3.2 must validate how dynamic theme subclasses generate all mapped slots. |
| Accessibility | 2px focus ring, state layers, on-role contrast discipline. | Glow-only focus, hover-only focus, low-contrast disabled text. | Final contrast values after theme palettes are approved. |

## Anti-Cyberpunk and Anti-Texture Audit

Skeleton audit gate: every adoption must be checked against the hard filter above. Any finding that relies on glow, blur, bevel gradient, texture, chrome shine, sci-fi HUD language, pixel art, or dark cyan/magenta synthwave pairing is rejected or rewritten before downstream use. MD3 Expressive can contribute stronger hierarchy, color confidence, playful shape, and glanceable emphasis, but only when translated into static, flat, Theme-compatible Godot styling.

## Flat vs Raised: When to Use Which

Reserved final matrix for Plan 03.1-06. Baseline principle: MD3 flat treatment is the default; raised treatment is optional extruded-flat affordance, not conventional shadow elevation.

## Phase 3.1 Verification Log

| Date | Plan | Check | Result |
|---|---|---|---|
| 2026-05-05 | 03.1-01 | Skeleton created with source roles, source-access status labels, citation contract, hard filter, Inter Variable Roman note, provenance table, and reserved headings. | Pending command verification. |
