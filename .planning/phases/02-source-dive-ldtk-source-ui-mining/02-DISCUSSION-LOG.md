# Phase 2: Source-Dive — LDtk Source UI Mining - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in 02-CONTEXT.md — this log preserves the alternatives considered.

**Date:** 2026-05-04
**Phase:** 2-Source-Dive — LDtk Source UI Mining
**Areas discussed:** Mining depth, Asset mining handling, Output artifact structure, Translation depth

---

## Mining Depth & Breadth

| Option | Description | Selected |
|--------|-------------|----------|
| Comprehensive — close the mandate | File-by-file pass through `src/electron.renderer/ui/` (40+ Haxe files) + `ui/modal/`, `ui/palette/`, `ui/vp/` + `page/Editor.hx`. Each file gets a one-line UI-pattern summary; promising files get full pattern extraction. Closes SOURCES.md Source 3 "must read all of it" mandate. Mirrors Phase 1's exhaustive discipline. Effort: heavy (~3-5 plans). | ✓ |
| Targeted to RES-02's 7 named patterns | Hunt only the 7 patterns RES-02 names: sidebar tinting, layer panel chrome, tool-button conventions, modal flow, panel collapse, context menus, status indicators. Effort: lighter (~2 plans). Risk: leaves "must read all of it" mandate partially open. | |
| Pattern-driven from NeoCade open questions | Start from NeoCade's open design questions and reverse-search LDtk for examples. Risk: misses patterns not yet on NeoCade's radar. | |

**User's choice:** Comprehensive — close the mandate.
**Notes:** Re-affirms PROJECT.md's "must read all of it for UI" mandate. Comprehensive depth does NOT promote LDtk to spec depth — adoption posture stays curated (see Translation Depth below).

---

## Asset Mining Handling

| Option | Description | Selected |
|--------|-------------|----------|
| Inventory + visual preview of SVG icons | Catalog every file. For `app/assets/icons/*.svg` (~80 files) — open and visually inspect to inform NeoCade's bespoke SVG set inspiration. Aseprite documented as "sprite-sheet, not adoptable." `res/fonts/` rejection re-confirmed. | ✓ |
| Inventory only — paths and roles, no visual review | List paths + role descriptions; no visual opening. Risk: misses visual-language patterns hidden inside SVGs. | |
| Visual review + decompose aseprite to PNG slices | Comprehensive: catalog all + visually preview SVGs + extract aseprite layers to PNG. Effort: heaviest. | |

**User's choice:** Deferred to Claude's recommendation. Claude recommended **Inventory + visual preview of SVG icons** based on the user's "loose inspiration" framing — visual review where free and informs design (silhouette + stroke conventions only, NOT pixel-copy); aseprite decompose left out as over-effort that would over-promote LDtk to spec territory.
**Notes:** SVG inspection stays at "silhouette/stroke discipline" level. No copying — NeoCade icons (Phase 4 ICON-01..04) are independently designed against the inspiration brief.

---

## Output Artifact Structure

| Option | Description | Selected |
|--------|-------------|----------|
| Single `LDTK-UI-MINING.md` + SOURCES.md updates | One new artifact at `.planning/research/LDTK-UI-MINING.md` covering all sections; SOURCES.md Sections 2 + 3 updated. Single source of truth. | ✓ |
| Two-doc split (mirror Phase 1 multi-doc pattern) | `LDTK-UI-PATTERNS.md` + `LDTK-CHANGELOG-LESSONS.md` + SOURCES.md. Cleaner separation but more files. | |
| SOURCES.md inline only (no new artifact) | Findings written directly into SOURCES.md Section 3. Risk: SOURCES.md Section 3 swells past 500 lines if mining goes deep. | |

**User's choice:** Deferred to Claude's recommendation. Claude recommended **Single `LDTK-UI-MINING.md` + SOURCES.md updates** because Phase 1's multi-doc split was driven by exhaustive enumeration (description vs analysis on a 1118-line `.tres`); Phase 2 is curated mining (synthesis), where one integrated doc reads better than fragments. CHANGELOG lessons land as a section inside the main doc.
**Notes:** Output structure mirrors the right-sized pattern for "loose inspiration" research — comprehensive in mining, single-source in artifact.

---

## Translation Depth

| Option | Description | Selected |
|--------|-------------|----------|
| Translation column where obvious, descriptive otherwise | Each pattern has the LDtk description PLUS a brief NeoCade equivalent note where StyleBoxFlat translation is obvious; ambiguous translations left as Phase 3+ design questions. | ✓ |
| Pure description — no translation | Strictly descriptive. Cleaner research/design separation but downstream phases re-derive. | |
| Full translation table for every pattern | Mandatory LDtk-side spec + Godot StyleBoxFlat-side spec. Risk: blurs research/design boundary; over-promotes LDtk to spec. | |

**User's choice:** Deferred to Claude's recommendation. Claude recommended **Translation column where obvious, descriptive otherwise**, with a **mandatory wording prefix on every translation note**: *"Inspiration sketch — Phase 3 mockup or Phase 5+ designer's call."* This prevents downstream phases from treating LDtk-derived sketches as authoritative. The user explicitly added: "LDtk is used as a loose inspiration resource. Not a full spec and source of truth." That guidance ruled out the full-translation-table option and shapes the entire Phase 2 artifact's tone.
**Notes:** Translation sketches are non-binding inspiration only. Binding specs are `DESIGN_TOKENS.md` (Phase 3) + per-phase implementation plans (Phase 5+).

---

## Claude's Discretion

- File-walking order through `src/electron.renderer/` (alphabetical / category-grouped / importance-ordered)
- Grep + manual reading vs. one-shot Haxe parser tooling
- Whether to include a glossary section explaining LDtk-specific terminology (Heaps, Electron, hxml, atlas baking)
- How to subdivide the UI Pattern Catalogue (by UI region vs by NeoCade Control affinity vs alphabetical)
- Whether to include screenshots from a running LDtk instance (out of strict scope; allowed if cheap; do NOT spin up Electron/Heaps)
- Exact provenance fields beyond mandatory (path, version pin, line counts, ISO date)

## Deferred Ideas

- Decompose aseprite atlases to PNG slices for visual reference — Phase 3 mood-board / Phase 4 icon-design territory if needed.
- Spin up running LDtk instance for live UI screenshots — Phase 3 mockup work if needed; not Phase 2.
- Checkout-and-diff older LDtk versions to study UI evolution — defer to v1.x if a specific evolution question arises.
- Use LDtk's Tip / Notification patterns as direct inputs for NeoCade Tooltip behavior — Phase 7 (Popups + Advanced) chooses whether to adopt; Phase 2 documents only.
- Mine LDtk's CommandPalette + QuickSearch UI patterns as Showcase additions — Phase 9 (Showcase) territory.
- Translate every LDtk pattern to a binding StyleBoxFlat spec — out of "loose inspiration" frame; Phase 3 mockup + Phase 5+ implementation work.
- Build a visual style comparison between LDtk's chrome and NeoCade's three palette directions (Midnight Marquee / Boardwalk Sunset / Cabinet Chrome) — Phase 3 mood-board / palette mockup territory.
