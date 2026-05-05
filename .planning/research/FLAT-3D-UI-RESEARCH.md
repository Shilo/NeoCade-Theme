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

Reserved for Plan 03.1-04.

## Broad Visual Survey

Reserved for Plan 03.1-04.

## Pattern Catalogue

Reserved for Plan 03.1-04.

## Construction Recipes

Reserved for Plan 03.1-05.

## Godot StyleBoxFlat Translation Notes

Reserved for Plan 03.1-05.

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
