# Flat-3D Game UI and Extruded-Flat UI Research

**Authored:** 2026-05-05  
**Phase:** 03.1-source-dive-md3-and-flat-3d-game-ui-research  
**Status:** Execution skeleton created by Plan 03.1-01; detailed Flat-3D findings added by Plans 03.1-04, 03.1-05, and 03.1-06.

## Scope and Non-Scope

This document captures public evidence for flat/extruded game UI patterns that can inform NeoCade's optional `raised=true` mode. It focuses on visual construction principles, not copying asset art.

In scope: user itch.io exemplars, broad public visual survey, accepted/rejected pattern catalogue, Godot `StyleBoxFlat` translation notes, Control-family raised matrix, and flat-vs-raised decision guidance.

Out of scope: final theme directions, mockups, `.tres` styling, GDScript architecture validation, importing or copying third-party assets, or choosing which themes ship in v1.

## Source Roles and Citation Contract

Required evidence roles:

| Evidence role | Use in this document |
|---|---|
| official/spec | Godot documentation or platform docs used as authoritative implementation facts. |
| upstream token source | MD3 token source cross-references when state values or shape scales are reused. |
| user exemplar | The two itch.io sources the user specifically supplied. |
| commercial example | Shipped commercial game UI screenshots or store screenshots used as inspiration-grade evidence. |
| asset-pack example | Public UI packs used to identify common flat/extruded construction patterns. |
| design commentary | UI/game-design commentary used to interpret hierarchy, button affordance, or mobile ergonomics. |

Required source-access status labels:

| source-access status | Meaning |
|---|---|
| directly extracted | Text was accessible through the source itself. |
| upstream-token corroborated | Numeric facts were verified through upstream source files. |
| browser/manual verified | Visual evidence required image/manual/browser inspection. |
| fallback source used | A public equivalent source supplies the fact when the primary source is sparse or hard to extract. |
| unresolved extraction gap | The required fact could not be corroborated; name the missing value and downstream owner. |

Citation-quality contract:

- Numeric facts must include source URL, evidence role, access status, retrieved date, and source agreement note.
- JS-rendered, image-heavy, or hard-to-extract sources must include a screenshot/image URL or visual-capture note.
- Presence-only keyword checks are insufficient for final verification; downstream plans must add row quotas, rejection counts, hard-filter audit notes, and source-agreement checks.
- Asset packs are inspiration and construction evidence only. NeoCade adopts construction principles, not asset artwork.

## Hard NeoCade Filter

The valid raised pattern is extruded-flat only: a solid top shape plus offset darker duplicate underneath.

- NO textures, patterns, embossing, painterly chrome, gradients on chrome, cyberpunk, synthwave/noir drift, pixel art, soft shadows, blurred shadows, bevel gradients, conventional 3D.
- YES flat MD3/MD3 Expressive, colorful/playful/expressive, optional extruded-flat raised treatment using a solid top shape plus offset darker duplicate.
- Typography assumption: Inter Variable Roman only in v1. No display font, pixel font, mono font, or external font family is adopted here.

Raised-toggle semantics from Phase 3.1 context:

- `raised=false` means the flat baseline.
- `raised=true` means broadly raised within Control groups where it improves affordance and still reads modern.
- Raised is theme-wide, but not every Control visibly lifts.
- Buttons and button-like controls change most visibly.
- Panels mostly stay flat.
- Popups/dialogs selectively gain raised treatment.
- Inputs stay flat/outlined.
- Labels, separators, and non-interactive decorative slots do not change.

v0 DNA note: Midnight Marquee, Cabinet Chrome, Prize Pop Plaza, and Orbital Playdeck may provide light interpretation input only. Boardwalk Sunset is hard rejected. This document does not derive final theme directions.

## User Exemplar Provenance

These two sources are user exemplars: they define the visual direction the user meant by Flat-3D / extruded flat, but they are asset packs, not artwork to copy. NeoCade adopts construction principles only.

| Source | URL | Evidence role | source-access status | Retrieved | screenshot / visual-capture note | What was read | Adopted construction principles | Rejected / non-portable parts | hard-filter audit |
|---|---|---|---|---|---|---|---|---|---|
| Renderman / HCGames Flat GUI for mobile games | https://hcgamestudios.itch.io/flat-game-ui-for-mobile-games | user exemplar; asset-pack example | directly extracted; browser/manual verified | 2026-05-05 | Page exposes multiple image links at the bottom (`Image` links 44-50) plus product preview images; visual-capture note: mobile/casual GUI pack with colorful flat buttons, panels, menus, and icons. | Page says the pack is flat, customizable, mobile-ready, includes main/login/level/info/shop/settings/score/victory/fail screens, 5 button colors, 68 icons per color, 345 buttons, 70+ flat icons, Photoshop and PNG files, vector shapes, editable organization. | Broad mobile GUI coverage; colorful role-coded buttons; solid simple shapes; multiple button colors; menu/dialog/screen coverage; editable vector source as evidence of flat construction. | Asset artwork, PNG/PSD workflow, icon art, Junegull/free font choices, and sprite-pack composition are not portable into a Godot Theme resource. NeoCade does not import or imitate the artwork. | PASS for construction vocabulary if reduced to solid top shape, flat fills, crisp icons, and optional offset duplicate. REJECT any background art or decorative sprite content as Theme scope. |
| Fajrulaslim UI Button Flat Design | https://fajrulaslim.itch.io/ui-button-flat-design/devlog/157464/ui-button-flat-design | user exemplar; asset-pack example | directly extracted; browser/manual verified | 2026-05-05 | Page exposes image links 26-37; visual-capture note: button/icon model sheet with many flat variants. | Page says the asset is vector Adobe Illustrator, includes original Illustrator/EPS files, 678 UI button/icon models, 678 PNG sprites, and game-UI/button/icon tags. | Button-specific breadth; repeated button/icon states; editable vector shapes; solid, simple button families as construction evidence. | Illustrator/EPS/PNG sprite workflow, specific button silhouettes, and icon art are not portable. NeoCade must express only themeable shape/border/fill/state principles. | PASS for flat-button family evidence. REJECT copying icon/button models; use as construction principles only. |

User-exemplar conclusion: the common transferable pattern is not the asset art; it is a reusable construction grammar: simple solid foreground shape, clear rounded silhouette, crisp icon/text layer, high-saturation role colors, and optional tactile depth from a solid top shape plus offset darker duplicate.

## Broad Visual Survey

Survey posture: broad sources validate conventions, not authority. Every adoption below remains inspiration-grade and must pass the hard NeoCade filter.

| Source | URL | Evidence role | source-access status | screenshot / visual-capture note | Observed flat/extruded pattern | Adopt / Reject / Open | hard-filter audit |
|---|---|---|---|---|---|---|---|
| Kenney UI Pack | https://kenney.nl/assets/ui-pack | asset-pack example | directly extracted; browser/manual verified | Source page offers preview/download and game-asset screenshots; visual-capture note: clean vector UI elements with flat fills and simple iconography. | Generic, reusable flat GUI parts; simple buttons/panels/icons; low-detail construction. | Adopt construction discipline: simple reusable UI elements and crisp vector-style shapes. | PASS if reduced to solid StyleBoxFlat fills, borders, and icons. Do not copy assets. |
| GameArt2D Minimalist Game GUI | https://www.gameart2d.com/minimalist-game-gui.html | asset-pack example | directly extracted; browser/manual verified | Product page shows GUI preview; visual-capture note: colorful mobile-game panels/buttons with simple flat styling. | Role-colored buttons, shop/menu/popup surfaces, mobile-game density. | Adopt limited: mobile GUI completeness and friendly button hierarchy. | PASS for flat mobile-game coverage; reject any illustration/background art as Theme scope. |
| Sungraphica Flat GUI game asset pack | https://www.deviantart.com/sungraphica/art/Flat-GUI-game-asset-pack-for-game-designers-975580487 | asset-pack example | browser/manual verified | Visual-capture note: public preview image presents a flat GUI asset pack for game designers. | Flat panels/buttons/icons as a cohesive pack. | Adopt limited: pack-level consistency and simple reusable silhouettes. | PASS for inspiration; no artwork import, no copied silhouettes. |
| Unity Asset Store 6000+ Flat Buttons Icons Pack | https://assetstore.unity.com/packages/2d/gui/6000-flat-buttons-icons-pack-190732 | asset-pack example | browser/manual verified | Asset Store preview/listing is image-heavy; visual-capture note: large catalog of flat button/icon variations. | High-volume button/icon variants; visual breadth more than system thinking. | Open: useful for seeing repetition and icon/button role families; not a design source. | PASS only as breadth reference. REJECT direct icon/model copying and bloat. |
| Brawl Stars menu screenshot collection | https://interfaceingame.com/screenshots/brawl-stars-menu/ | commercial example | browser/manual verified | Screenshot/database page; visual-capture note: commercial game menu with large high-contrast action buttons and clear primary/secondary hierarchy. | Bold rounded button hierarchy, icon+label scannability, friendly commercial-game energy. | Adopt limited: glanceable hierarchy and action prominence. | PASS if translated to flat MD3 surfaces. Avoid glossy/painterly/3D art assets. |
| Royal Match screenshot collection | https://www.mobygames.com/game/166470/royal-match/screenshots/ | commercial example | browser/manual verified | Screenshot collection; visual-capture note: commercial mobile puzzle game with large friendly UI targets and reward/menu surfaces. | Large touch targets, readable reward/action surfaces, casual-game friendliness. | Open/adopt limited: friendly density and large action affordances; no asset/art transfer. | PASS for ergonomic lesson. REJECT decorative scene art and any gradient-heavy or texture-heavy candy/chrome effects. |
| Candy Crush Saga official app page | https://apps.apple.com/us/app/candy-crush-saga/id553834731 | commercial example | browser/manual verified | App-store screenshots are visual evidence; screenshot/image URL is page-hosted app media. | Bright reward buttons, candy-like surfaces, glossy and illustrative UI world. | REJECT as NeoCade visual source; use only as a negative commercial boundary. | FAIL: heavy texture/painterly candy material, gradient shine, and illustrative asset dependence exceed NeoCade's flat Theme resource scope. |
| CraftPix Christmas Game GUI | https://craftpix.net/freebies/free-christmas-game-gui/ | asset-pack example | browser/manual verified | Product/freebie page; visual-capture note: themed holiday GUI with illustrated decorations. | Buttons/panels exist, but they are wrapped in seasonal illustrations and decorative material. | REJECT for NeoCade v1; useful as negative evidence for avoiding theme-specific decorative sprites. | FAIL: texture/thematic illustration and seasonal art would violate reusable addon scope. |
| Game Design Skills game UI guide | https://gamedesignskills.com/game-design/ui/ | design commentary | directly extracted | Textual source, no screenshot requirement; visual-capture note: commentary source used for clarity/hierarchy vocabulary. | Frames game UI as communication: player information, feedback, clear controls, and visual hierarchy. | Adopt principle only: clarity, affordance, hierarchy, and feedback must guide the raised matrix. | PASS because it supplies design reasoning, not visual effects. |
| Dribbble flat game UI buttons/icons search result set | https://dribbble.com/tags/game-ui-buttons | design commentary; asset-pack example | browser/manual verified | Visual-capture note: broad public design-board style source with many flat/extruded button shots, but heterogeneous attribution/context. | Recurrent use of solid top shapes, offset darker under-shapes, and high-saturation role colors. | Open: useful for pattern recurrence only; low authority. | PASS only for recurrence; reject low-context boards as citation-grade design authority. |

Survey synthesis:

- Accepted evidence consistently supports friendly, large, rounded, flat, icon+label-heavy game UI with strong action hierarchy.
- The valid raised construction is narrow: solid top shape plus offset darker duplicate. It cannot become blur, glow, bevel gradient, texture, or painterly chrome.
- Commercial examples help calibrate energy and hierarchy, but asset packs better expose construction. Both remain subordinate to NeoCade's MD3/Inter/no-texture hard filter.

## Pattern Catalogue

Each pattern uses the same rule: accepted construction is solid, flat, and themeable; forbidden variants are sprite/material effects.

| Pattern | Accepted construction | Forbidden variants | Likely Godot targets | Common or rare in NeoCade |
|---|---|---|---|---|
| Raised action button | Foreground rounded `StyleBoxFlat` solid fill; optional offset darker duplicate underneath; crisp text/icon on top; 2px focus ring outside the top shape. | Soft shadow, blurred shadow, glow, bevel highlight, gradient shine, texture, metallic/chrome edge, imported button sprites. | Button, PrimaryButton, DangerButton, OptionButton, MenuButton, ColorPickerButton, dialog action buttons. | Common when `raised=true`; strongest on primary/interactive button-like controls. |
| Toggle / check button | Flat or raised thumb/track/check area with clear checked state; optional offset only on the clickable shell, not on every internal glyph. | 3D switch knobs, glossy toggles, embossed icons, texture, glow ring. | CheckButton, CheckBox, radio/check type variations if added, selected menu items. | Common but subtler than action buttons. |
| Icon button | Small square/circle/pill top shape with high-contrast glyph; raised mode may show a 1-3px hard offset if target size remains stable. | Icon sprites copied from packs, glossy glyphs, neon halo, drop-shadow-only hit target. | IconButton variation, toolbar buttons, clear buttons, color picker actions, graph toolbar actions. | Common for toolbars; raised offset should be reserved for high-value icons. |
| Pill / tab / chip | Flat pill or tab surface with selected/hover/focus state-layer fills; raised mode may use offset only for selected active chips/tabs. | Massive pillification of all controls, soft floating chips, bevel gradients, patterned fills. | TabBar tabs, CheckButton-style toggles, filter chips via Button type variations, MenuBar active items. | Moderate; tabs/chips should stay readable and dense. |
| Dialog / modal action surface | Dialog shell remains mostly flat/highest surface; action buttons may be raised; header/footer can use tonal separation. | Raised whole modal with soft shadow, background blur, painterly frame, arcade-cabinet texture. | AcceptDialog, ConfirmationDialog, FileDialog, PopupPanel, PopupMenu action zones. | Rare/selective; raise the actions more than the panel. |
| Progress / range affordance | Flat track and fill; handle may use a small raised top shape or offset duplicate while dragged; progress fill remains flat. | Glossy meter, beveled progress tube, textured fill, blurred handle shadow. | HSlider, VSlider, HScrollBar, VScrollBar, ProgressBar, GraphEdit connection handles if relevant. | Subtle; handles can lift, tracks normally stay flat. |

Catalogue conclusion: raised treatment is an affordance amplifier. It should be strongest on things the user can press now, subtle on handles, rare on large surfaces, and absent from passive text/decorative controls.

## Construction Recipes

These sketches are not implementation architecture. They define what visual outcomes future phases must support.

### Recipe A: Direct `StyleBoxFlat` Shadow Offset

| Field | Sketch | Feasibility |
|---|---|---|
| Top shape | `bg_color = action/surface role`, `corner_radius_* = token`, `border_width_*` optional. | Viable for flat top. |
| Offset shape | Try `shadow_color = darker duplicate`, `shadow_offset = Vector2(0, 3)`, `shadow_size` as hard offset. | Non-viable for v1 under no-soft-shadow rule unless Phase 3.2 proves a hard-edged duplicate with no blur/glow/soft shadow and no `shadow_size = -1` conflict. |
| Shadow disabled baseline | Flat mode and all non-raised families keep `shadow_size = -1`. | Required by project pitfall/no-soft-shadow resolution. |

Decision: Recipe A is **non-viable for v1 under no-soft-shadow rule** as a default research recommendation. Current Godot docs prove `shadow_color`, `shadow_offset`, and `shadow_size` exist, but they do not prove a clean hard-edged offset duplicate that preserves `shadow_size = -1`. Empirical validation belongs to Phase 3.2, not this visual research phase.

### Recipe B: Two-Layer / Wrapper Composition

Default research recommendation for extruded-flat raised mode: use **two stacked** layers in a wrapper-style composition.

```text
[offset darker duplicate layer]  y + 2..4px, same radius, darker role color
[foreground top layer]           y + 0px, solid role color, text/icon above
```

Sketch:

| Layer | Visual role | Notes |
|---|---|---|
| Wrapper/background | darker duplicate, same silhouette, translated down/right or down only | Could be a parent/background Control, extra stylebox host, or generated composition; Phase 3.2 decides feasibility. |
| Foreground/top | normal Button/Control stylebox | Contains content and focus ring. |
| Focus | 2px solid ring around foreground top shape | No glow. Ring must not be hidden behind offset layer. |

### State Recipe

| State | Value / sketch | Notes |
|---|---|---|
| normal | top shape at base role color; optional offset layer darker. | raised=false omits offset layer. |
| hover 8% | blend on-role/state-layer over the top shape at hover 8%. | Offset layer generally unchanged to avoid jitter. |
| focus 12% | top shape may blend focus 12% where useful, plus 2px solid ring. | Focus ring is required; blend alone is insufficient. |
| pressed 12% | top shape shifts/tones darker via pressed 12%; optional visual press can reduce offset from 3px to 1px if architecture allows. | Keep layout dimensions stable. |
| dragged 16% | use dragged 16% for sliders, split handles, tabs, GraphEdit objects. | Useful for handles, not all buttons. |
| disabled 38% / disabled container 12% | text/icon content uses disabled 38%; container/outline/offset uses disabled container 12% or a muted tonal step. | Do not leave a bright raised offset on disabled controls. |

## Godot StyleBoxFlat Translation Notes

Baseline flat recipe:

| Concept | Godot-oriented sketch |
|---|---|
| Fill | `StyleBoxFlat.bg_color` from role/surface token. |
| Border | `border_color` and `border_width_*` for outlined or focus-adjacent states. |
| Radius | `corner_radius_*` from direction-specific shape scale. |
| Padding | `content_margin_*` from desktop/mobile density tokens. |
| Shadow | `shadow_size = -1` for flat baseline and any family that should not use hard extruded composition. |

Extruded-flat translation:

- Prefer wrapper/two-layer composition (Recipe B) over direct `StyleBoxFlat` shadow.
- The offset duplicate must be a hard-edged solid shape, not a blurred shadow.
- Offset should be small: 2-4px desktop, potentially 3-5px mobile if Phase 3.4 mockups approve.
- Raised styling must preserve stable layout dimensions; hover, focus, pressed, text, and icons must not resize controls.
- Direct `shadow_offset` remains a research note only until Phase 3.2 proves it produces an acceptable hard duplicate without violating the no-soft-shadow rule.

## Control-Family Matrix

Reserved for Plan 03.1-05.

## Escape Hatch Type-Variation Notes

Reserved for Plan 03.1-05.

## Adoption, Rejection, and Open Questions

Reserved for Plans 03.1-04 and 03.1-05.

## Anti-Cyberpunk and Anti-Texture Audit

Skeleton audit gate: any adoption that depends on gradient shine, bevel highlights, soft blur, painterly detail, pixel texture, CRT treatment, sci-fi HUD geometry, or cyan/magenta synthwave pairing fails the NeoCade filter. Valid Flat-3D material is colorful, crisp, touch-friendly, and built from simple solid shapes. The raised mode should support affordance, not decorative 3D spectacle.

## Flat vs Raised: When to Use Which

Reserved final matrix for Plan 03.1-06. Baseline principle: flat is the default design language; raised is an optional extruded-flat affordance for controls that benefit from a more tactile invitation.

## Phase 3.1 Verification Log

| Date | Plan | Check | Result |
|---|---|---|---|
| 2026-05-05 | 03.1-01 | Skeleton created with source roles, source-access status labels, citation contract, hard filter, solid top shape plus offset darker duplicate rule, raised-toggle semantics, and reserved headings. | Pending command verification. |
