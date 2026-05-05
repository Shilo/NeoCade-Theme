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
| Material color system overview | https://m3.material.io/styles/color/system/overview | official/spec | pending Plan 02 | 2026-05-05 | Reserved for MD3 color system. | Official URL retained; JS extraction fallback expected if needed. |
| Material type scale tokens | https://m3.material.io/styles/typography/type-scale-tokens | official/spec | pending Plan 02 | 2026-05-05 | Reserved for MD3 typography. | Official URL retained; upstream token corroboration expected. |
| Material shape scale tokens | https://m3.material.io/styles/shape/shape-scale-tokens | official/spec | pending Plan 02 | 2026-05-05 | Reserved for MD3 shape. | Official URL retained; upstream token corroboration expected. |
| Material state layers | https://m3.material.io/foundations/interaction/states/state-layers | official/spec | pending Plan 02 | 2026-05-05 | Reserved for state-layer values. | Official URL retained; upstream token corroboration expected. |
| Material Web tokens | https://github.com/material-components/material-web/tree/main/tokens/versions | upstream token source | pending Plan 02 | 2026-05-05 | Reserved for numeric token corroboration. | Source agreement to be checked against official/developer docs. |

## MD3 Foundations

Reserved for Plan 03.1-02.

## MD3 Expressive Delta

Reserved for Plan 03.1-03.

## Component to Godot Control Mapping

Reserved for Plan 03.1-02.

## Godot Visual Recipe Notes

Reserved for Plan 03.1-02.

## Adoption, Rejection, and Open Questions

Reserved for Plans 03.1-02 and 03.1-03.

## Anti-Cyberpunk and Anti-Texture Audit

Skeleton audit gate: every adoption must be checked against the hard filter above. Any finding that relies on glow, blur, bevel gradient, texture, chrome shine, sci-fi HUD language, pixel art, or dark cyan/magenta synthwave pairing is rejected or rewritten before downstream use. MD3 Expressive can contribute stronger hierarchy, color confidence, playful shape, and glanceable emphasis, but only when translated into static, flat, Theme-compatible Godot styling.

## Flat vs Raised: When to Use Which

Reserved final matrix for Plan 03.1-06. Baseline principle: MD3 flat treatment is the default; raised treatment is optional extruded-flat affordance, not conventional shadow elevation.

## Phase 3.1 Verification Log

| Date | Plan | Check | Result |
|---|---|---|---|
| 2026-05-05 | 03.1-01 | Skeleton created with source roles, source-access status labels, citation contract, hard filter, Inter Variable Roman note, provenance table, and reserved headings. | Pending command verification. |
