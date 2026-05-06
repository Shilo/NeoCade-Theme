# Godot Dynamic Theme Architecture Research

Phase 03.2 validates whether NeoCade v1 can ship a dynamic Godot Theme architecture: one `@tool extends Theme` superclass with exported knobs, per-direction subclasses that call `super._regenerate()` first, and saved `.tres` instances users can edit without production addon changes during research.

## Scope and Non-Scope

**Scope**

- Verify export-driven `Theme` regeneration from `@export` properties.
- Confirm subclass extension mechanics for base coverage plus personality overrides.
- Validate runtime application and saved `.tres` serialization behavior.
- Define platform resolution for `DESKTOP`, `MOBILE`, and `AUTO`, including Web ambiguity.
- Port the relevant passivestar editor-theme formula pattern into runtime-safe pseudocode.
- Produce a research-only spike under `.planning/spikes/dynamic-theme/`.

**Non-Scope**

- No production edits under `addons/neocade_theme/`.
- No final `neocade_theme.tres`, `neocade_mobile_theme.tres`, fonts, icons, screenshots, or mockups.
- No editor plugin dependency, JavaScript bridge, or `EditorInterface` runtime contract.
- No final visual token decisions. Phase 3.4 remains the mockup approval gate.

## Source Map and Provenance

All claims in this file must use source labels. Source labels are stable shorthand for the material inspected during Phase 03.2.

| Label | Source | Use in this document | Status |
|-------|--------|----------------------|--------|
| `CTX-03.2` | `.planning/phases/03.2-godot-dynamic-theme-architecture-research/03.2-CONTEXT.md` | User decisions and gray-area resolutions | Read |
| `PLAN-03.2` | `.planning/phases/03.2-godot-dynamic-theme-architecture-research/*-PLAN.md` | Execution requirements and review-converged acceptance criteria | Read |
| `RES-03.2` | `.planning/phases/03.2-godot-dynamic-theme-architecture-research/03.2-RESEARCH.md` | Official-doc research summary | Read |
| `PROJECT` | `.planning/PROJECT.md` | Hard constraints and research charter | Read |
| `ROADMAP` | `.planning/ROADMAP.md` | Phase goal and downstream dependency context | Pending |
| `SOURCES` | `.planning/research/SOURCES.md` | Existing source dossier and Section 13 update target | Read |
| `GODOT-EDITOR-THEME` | `C:/Programming_Files/Godot/godot-master/editor/themes/editor_theme_manager.cpp` and `.h` | Editor theme generation flow and anti-pattern boundaries | Pending |
| `GODOT-COLOR-MAP` | `C:/Programming_Files/Godot/godot-master/editor/themes/editor_color_map.cpp` | Named color derivation context | Pending |
| `GODOT-THEME-RUNTIME` | `C:/Programming_Files/Godot/godot-master/scene/resources/theme.*`, `theme_db.cpp`, `theme_owner.cpp` | Runtime Theme APIs and fallback model | Pending |
| `GODOT-STYLEBOX` | `C:/Programming_Files/Godot/godot-master/scene/resources/style_box*.{h,cpp}` | `StyleBoxFlat` mutation and shadow constraints | Pending |
| `MINIMAL-DISSECTION` | `.planning/research/MINIMAL-THEME-DISSECTION.md` | `godot-minimal-theme` bar and formula anchors | Pending |
| `SPIKE-03.2` | `.planning/spikes/dynamic-theme/*` | Dynamic Theme evidence | Pending |

**Citation contract:** final locked claims must include at least one source label. Spike-only claims must name `SPIKE-03.2` plus the evidence mode: `EXECUTED`, `STATIC-FALLBACK`, or `SIMULATED`.

## Strict Feasibility Gate

Phase 4 may treat the dynamic architecture as locked only if every strict check passes. A blocked or failed row makes the outcome **NOT LOCKED** and requires a fallback recommendation for user approval.

| Check | Required evidence | Current status | Result |
|-------|-------------------|----------------|--------|
| Export-driven regeneration | Changing exported `base_color`, `accent_color`, `raised`, or `platform` causes required subset entries to regenerate | Spike pending | PENDING |
| Subclass super-first overrides | Good subclass calls `super._regenerate()` and keeps base entries while overriding personality entries | Spike pending | PENDING |
| Negative subclass failure | Bad subclass skipping `super._regenerate()` leaves detectable coverage gaps | Spike pending | PENDING |
| Runtime application | Saved dynamic `.tres` can be loaded and assigned to a Control tree | Spike pending | PENDING |
| Serialization behavior | Export values and script references survive saved `.tres` round trip, with generated entries understood as runtime/editor-time output | Spike pending | PENDING |
| Platform detection | `DESKTOP`, `MOBILE`, and `AUTO` paths resolve with local, simulated, and Web-ambiguous cases documented | Spike pending | PENDING |

## Editor Theme Generation Flow

Pending Plan 02 source inspection.

## Runtime Theme API Surface

Pending Plan 02 source inspection.

## Passivestar Formula Port

Pending Plan 02 formula-port research. Plan 03 may not create executable spike code until this section is populated beyond this placeholder.

## Dynamic Theme Spike Evidence

| Evidence item | What must be shown | Evidence mode | Status | Notes |
|---------------|--------------------|---------------|--------|-------|
| Export-driven regeneration | Required representative controls change when exports change | Pending | PENDING | Required controls: Button, OptionButton, CheckBox, LineEdit, Tree, PopupMenu, Window, ScrollBar |
| Correct subclass | Good subclass retains superclass entries and adds personality overrides | Pending | PENDING | Must include at least one direct documented override |
| Negative subclass | Bad subclass omits `super._regenerate()` and verifier catches missing entries | Pending | PENDING | Prevents false confidence in resource-level inheritance |
| Runtime saved `.tres` | Saved resource loads and can be applied to a scene/control tree | Pending | PENDING | Production addon untouched |
| Serialization | Saved resource records script refs and exported values | Pending | PENDING | Generated entries may be runtime/editor-time output depending on Godot behavior |
| AUTO local/simulated | Desktop, mobile, Web desktop, Web mobile, ambiguous Web, and forced modes are covered | Pending | PENDING | Godot-only fallback; no JS bridge in v1 research |
| Anti-pattern audit | Spike avoids editor-only APIs and addon implementation edits | Pending | PENDING | See Anti-Pattern Audit |

## Subclass Contract

Pending Plan 05. Contract must define superclass hooks, allowed direct overrides, verifier obligations, mobile/a11y guardrails, and forbidden APIs.

## AUTO Platform Strategy

Pending Plan 05. Discussion decision favors Godot-only layered detection: explicit forced enum first, `OS.has_feature("mobile")`, named Web/mobile feature tags where available, `OS.get_name()` fallback, and mobile-preferred handling for ambiguous Web.

## Serialization Findings

Pending Plan 04.

## Runtime and Editor-Time Findings

Pending Plan 04.

## Pitfall Catalogue

Pending Plan 05.

## Anti-Pattern Audit

| Surface | Status | Rationale |
|---------|--------|-----------|
| `EditorInterface` | Forbidden in architecture/spike | Theme must work in export/runtime contexts |
| `EditorSettings` | Forbidden in architecture/spike | User-facing `.tres` exports are the source of truth |
| `EDSCALE` | Forbidden in runtime architecture | Editor-only scale assumptions do not transfer cleanly to game runtime |
| Editor-only theme types | Research citation only | v1 user-facing Control coverage is the target |
| Textures/patterns/gradients/soft shadows | Forbidden for v1 theme style | Project direction is flat MD3/MD3 Expressive with no texture chrome |
| Production addon edits | Forbidden in Phase 03.2 | Spike must stay under `.planning/spikes/` |

## Fallback Options and Recommendation

Pending Plan 05. The fallback recommendation may not be auto-adopted; the user requested one strongest fallback if the strict gate fails or is blocked.

## Architecture Recipe for Phase 4

Pending Plan 05. This recipe must be marked LOCKED only if the strict feasibility gate passes.

## Phase 3.2 Verification Log

| Date | Plan | Verification | Result |
|------|------|--------------|--------|
| 2026-05-06 | 01 | Research artifact created with required sections, source labels, strict gate rows, spike evidence matrix, no-addon boundary, and anti-pattern audit skeleton | PASS |
