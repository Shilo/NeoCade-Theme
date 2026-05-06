---
phase: 04-foundation-neocadetheme-superclass-per-theme-subclasses-font
plan: 02
subsystem: addon-fonts-and-license
tags: [foundation, fonts, inter-variable, ofl, m3-type-scale, font-variation, gl-compatibility, wave-1]
requires:
  - phase: 03.4-visual-direction-flat-extruded-flat-mockup-approval-gate
    provides: DESIGN_TOKENS.md §8.5 M3 type scale (variation_opentype values for the 5 FontVariations)
  - plan: 04-01
    provides: NeoCadeTheme class shell + addon root layout (the fonts/ subdir is added under the layout established in 04-01)
provides:
  - addons/neocade_theme/fonts/Inter-Variable.ttf (rsms/inter v4.0, SHA256-pinned, Reserved Font Name preserved)
  - addons/neocade_theme/fonts/Inter-Variable.ttf.import (GL-Compatibility-correct importer settings)
  - addons/neocade_theme/fonts/Inter-Variable.tres (FontFile resource wrapping the .ttf, ResourceSaver-serialized)
  - addons/neocade_theme/fonts/Inter-HeaderLarge.tres (FontVariation wght=800 opsz=32)
  - addons/neocade_theme/fonts/Inter-HeaderMedium.tres (FontVariation wght=700 opsz=32)
  - addons/neocade_theme/fonts/Inter-HeaderSmall.tres (FontVariation wght=600 opsz=24)
  - addons/neocade_theme/fonts/Inter-Body.tres (FontVariation wght=400)
  - addons/neocade_theme/fonts/Inter-Caption.tres (FontVariation wght=400)
  - addons/neocade_theme/OFL.txt (SIL OFL 1.1 verbatim + Reserved Font Name "Inter" + 2016 Inter Project Authors copyright)
affects: [phase-04, font-bundle, m3-type-scale, license-compliance]
tech-stack:
  added:
    - "Inter Variable Roman v4.0 (rsms/inter, OFL 1.1)"
  patterns:
    - "Single-font bundle (Inter only) per UD-4 Option D — Outfit / Noto Sans / JetBrains Mono all stricken from REQUIREMENTS.md"
    - "FontVariation .tres referencing FontFile .tres (not .ttf directly) — variation_opentype values via wght/opsz axes for M3 type scale"
    - "Build-time @tool helper outside addon root (.planning/phases/.../helpers/) — keeps addon root at exactly 1 .gd file per FOUND-01 / Phase 4 SC#1"
    - "GL-Compatibility-correct font import settings: antialiasing=1 (Grayscale) + hinting=1 (Light) + subpixel_positioning=2 (Auto) + generate_mipmaps=true + allow_system_fallback=true + multichannel_signed_distance_field=false"
key-files:
  created:
    - addons/neocade_theme/fonts/Inter-Variable.ttf
    - addons/neocade_theme/fonts/Inter-Variable.ttf.import
    - addons/neocade_theme/fonts/Inter-Variable.tres
    - addons/neocade_theme/fonts/Inter-HeaderLarge.tres
    - addons/neocade_theme/fonts/Inter-HeaderMedium.tres
    - addons/neocade_theme/fonts/Inter-HeaderSmall.tres
    - addons/neocade_theme/fonts/Inter-Body.tres
    - addons/neocade_theme/fonts/Inter-Caption.tres
    - addons/neocade_theme/OFL.txt
    - .planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/helpers/_phase4_import.gd
    - .planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/helpers/_phase4_smoke.gd
    - .planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/helpers/inter-source.json
    - .planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-02-SUMMARY.md
  modified:
    - .planning/REQUIREMENTS.md
    - .planning/STATE.md
    - .planning/ROADMAP.md
key-decisions:
  - "Inter v4.0 pinned (TTF SHA256 = 746431E950FD28D29B0189D708D4A5852A8458EDB3184387EADCEE9E5E34676C, ZIP SHA256 = FF970A5D4561A04F102A7CB781ADBD6AC4E9B6C460914C7A101F15ACB7F7D1A4) — captured in helpers/inter-source.json so the build is reproducible. CHANGELOG.md entry lands in Plan 04-08 per Cross-AI Cycle 1 Codex MEDIUM fix."
  - "FontFile + 5 FontVariation .tres GENERATED via Godot-native ResourceSaver.save() in helpers/_phase4_import.gd, NOT hand-authored. Output reflects Godot's actual serialization (UIDs are Godot-normalized, not synthetic placeholders) per Cross-AI Cycle 1 C5 fix."
  - "Helpers live OUTSIDE addons/neocade_theme/ at .planning/phases/04-.../helpers/ per Cycle 6 F3 fix — FOUND-01 / Phase 4 SC#1 requires exactly 1 .gd file at addon root (neocade_theme.gd only). Helpers are build-time scaffolding, NOT distributed."
  - "Reserved Font Name 'Inter' preserved — binary file kept at canonical name `Inter-Variable.ttf`, NOT renamed per FONT-05."
  - "OFL.txt embeds the verbatim SIL Open Font License 1.1 body, the 2016 Inter Project Authors copyright statement, and the explicit Reserved Font Name notice. Single-font bundle = single OFL.txt; future v1.x or v2 bundles that add fonts will combine notices in this file or split as licenses dictate."
  - "Italic glyphs are NOT shipped in v1 — synthetic italic transform policy per FONT-07 lands in CHANGELOG.md (Plan 04-08), not in this plan."
patterns-established:
  - "Build-time @tool helpers pattern: SceneTree-extending @tool scripts under .planning/phases/<phase>/helpers/ that drive Godot-native ResourceSaver workflows (FontFile, FontVariation, .tres bake-out). Keeps addon root clean while still using Godot's authoritative serialization."
  - "Pinned third-party font ingestion pattern: source URL + tagged release + ZIP SHA256 + extracted-asset SHA256 + capture timestamp recorded as JSON sidecar (helpers/inter-source.json). Reproducibility without committing the upstream archive."
  - "GL-Compatibility-correct font import settings codified: explicit antialiasing/hinting/subpixel/mipmap/fallback values that survive `godot --headless --import` re-runs (per PITFALLS 5.5)."
requirements-completed:
  - FONT-01 (Inter Variable Roman bundled at canonical path with verified SHA256)
  - FONT-05 (OFL.txt with SIL OFL 1.1 + Reserved Font Name + 2016 Inter Project Authors copyright)
  - FONT-08 (GL-Compatibility-correct font import settings)
  - FONT-06 (partial — FontFile + 5 FontVariations cover M3 type scale; default_font wiring closes in Plan 04-05)
  - TOKEN-10 (partial — 5 FontVariations cover DESIGN_TOKENS §8.5 wght/opsz axes; Theme entry binding closes in 04-05)
duration: ~30 min (Wed 2026-05-06 evening)
completed: 2026-05-06
---

# Phase 4 Plan 02: Inter Variable Roman + FontVariations + OFL.txt Summary

**Bundled the only v1 font (Inter Variable Roman v4.0, OFL 1.1) with verified SHA256, GL-Compatibility-correct import settings, 5 FontVariation .tres covering the M3 type scale, and OFL.txt with the Reserved Font Name notice — closing FONT-01/05/08 and partially FONT-06/TOKEN-10.**

## Performance

- **Started:** 2026-05-06 (after Plan 04-01 commit `9b9be71`)
- **Completed:** 2026-05-06 (commits `d701ac1` + `7adaa6c` + this metadata commit)
- **Tasks:** 6 (per plan: download + verify SHA256 / generate FontFile.tres / generate 5 FontVariations / GL-correct .import / write OFL.txt / smoke-test)

## Accomplishments

- Sourced `Inter-Variable.ttf` from the rsms/inter v4.0 pinned GitHub Release; verified `746431E950FD28D29B0189D708D4A5852A8458EDB3184387EADCEE9E5E34676C` against the SHA256 captured at ingestion (helpers/inter-source.json). 843 KB binary, Reserved Font Name `Inter` preserved (no rename).
- Authored `helpers/_phase4_import.gd` (`@tool extends SceneTree`) that programmatically constructs the FontFile + 5 FontVariation resources via Godot-native `ResourceSaver.save()`. Output `.tres` files reflect Godot's serialization format and UIDs (not synthetic placeholders) per Cross-AI Cycle 1 C5 fix.
- Authored `helpers/_phase4_smoke.gd` as a load-time smoke check — opens each of the 6 fonts and asserts `is FontFile` / `is FontVariation` to catch any future serialization drift.
- Generated `Inter-Variable.tres` (FontFile wrapping the .ttf, with embedded glyph cache data — 1.15 MB after `--headless --import`).
- Generated 5 `FontVariation` `.tres` covering DESIGN_TOKENS §8.5:
  - `Inter-HeaderLarge.tres` — `wght=800, opsz=32` (display-small / hero)
  - `Inter-HeaderMedium.tres` — `wght=700, opsz=32` (headline-small)
  - `Inter-HeaderSmall.tres` — `wght=600, opsz=24` (title-large / large dialogs)
  - `Inter-Body.tres` — `wght=400` (body text default)
  - `Inter-Caption.tres` — `wght=400` (caption + body-small)
- Materialized `Inter-Variable.ttf.import` via `godot --headless --import`. Importer settings (verified in `[params]` block):
  - `antialiasing=1` (Grayscale) — required for GL Compatibility per PITFALLS 5.5
  - `hinting=1` (Light) — required for GL Compatibility per PITFALLS 5.5
  - `subpixel_positioning=2` (Auto) — required for GL Compatibility per PITFALLS 5.5
  - `generate_mipmaps=true`
  - `allow_system_fallback=true` (renders Arabic / Hebrew / Indic / Thai / CJK via OS fallback per FONT-01)
  - `multichannel_signed_distance_field=false`
- Wrote `addons/neocade_theme/OFL.txt` with the SIL Open Font License 1.1 verbatim body, the 2016 Inter Project Authors copyright block, the SIL OFL preamble, and the explicit `Reserved Font Name "Inter"` notice — single-font bundle, single license file. Closes FONT-05.

## Task Commits

1. **Tasks 1–5 (atomic addon artifacts): bundle Inter + FontVariations + OFL.txt** — `d701ac1` (`feat(04-02): bundle Inter Variable Roman + FontVariations + OFL.txt`)
2. **Task 6 (build-time helpers): _phase4_import.gd + _phase4_smoke.gd + inter-source.json** — `7adaa6c` (`feat(04-02): add Plan 04-02 build-time helpers`)
3. **Plan metadata: SUMMARY.md + STATE.md + ROADMAP.md + REQUIREMENTS.md** — this commit.

The split between commit 1 (addon artifacts) and commit 2 (helpers) reflects the Phase 4 SC#1 invariant: helpers must NOT live at addon root. Keeping them in a separate commit makes the addon-root delta auditable in isolation.

## Files Created/Modified

**Created (addon-distributed):**
- `addons/neocade_theme/fonts/Inter-Variable.ttf` — 862,936 bytes, pinned v4.0
- `addons/neocade_theme/fonts/Inter-Variable.ttf.import` — Godot-generated importer config (GL-Compat-correct)
- `addons/neocade_theme/fonts/Inter-Variable.tres` — 1,151,164 bytes, FontFile resource (ResourceSaver-serialized)
- `addons/neocade_theme/fonts/Inter-HeaderLarge.tres` — FontVariation wght=800 opsz=32
- `addons/neocade_theme/fonts/Inter-HeaderMedium.tres` — FontVariation wght=700 opsz=32
- `addons/neocade_theme/fonts/Inter-HeaderSmall.tres` — FontVariation wght=600 opsz=24
- `addons/neocade_theme/fonts/Inter-Body.tres` — FontVariation wght=400
- `addons/neocade_theme/fonts/Inter-Caption.tres` — FontVariation wght=400
- `addons/neocade_theme/OFL.txt` — 101 lines, SIL OFL 1.1 + Reserved Font Name notice + 2016 Inter Project Authors copyright

**Created (build-time / not distributed):**
- `.planning/phases/04-.../helpers/_phase4_import.gd` — @tool SceneTree script that bakes the 6 font .tres via ResourceSaver
- `.planning/phases/04-.../helpers/_phase4_smoke.gd` — @tool load-time smoke test (opens each font, asserts type)
- `.planning/phases/04-.../helpers/inter-source.json` — pinned source URL + ZIP/TTF SHA256 + capture timestamp

**Modified:**
- `.planning/REQUIREMENTS.md` — FONT-01/05/08 → Complete; FONT-06 + TOKEN-10 partial; FONT-02/03/04 marked Stricken (UD-4 Option D 2026-05-04); FOUND-01 progress note appended
- `.planning/STATE.md` — Plan 04-02 complete, advance to Plan 04-03
- `.planning/ROADMAP.md` — Phase 4 plan progress

## Decisions Made

- **Inter v4.0 chosen as the pinned release.** v4.0 is the latest stable release of rsms/inter at ingestion time. The `Inter Variable.ttf` shipped in that ZIP archive is the variable upright (Roman) face — exactly what UD-4 Option D specifies.
- **Synthetic italic policy deferred to CHANGELOG (Plan 04-08).** Per the plan's must_have list and FONT-07, italic glyphs are not shipped in v1; consumer code uses Godot's synthetic italic transform on the variable Roman face. The CHANGELOG note documenting this lives in Plan 04-08.
- **Helper scripts live outside the addon root.** Cycle 6 F3 fix: `addons/neocade_theme/` must contain exactly 1 `.gd` file (neocade_theme.gd) per FOUND-01 / Phase 4 SC#1. Build-time @tool helpers go to `.planning/phases/04-.../helpers/`.
- **Single OFL.txt, not per-font.** Inter is the only bundled font for v1. Future bundles may need per-font notices; v1 ships one file containing the SIL OFL 1.1 + Inter's Reserved Font Name + copyright block.

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 — Process] Orchestrator finished SUMMARY.md + final commit inline.**
- **Found during:** Plan 04-02 final commit step.
- **Issue:** The spawned executor agent completed all 6 implementation tasks (font ingestion, .tres generation, .import sidecar, helper scripts) but the final response was blocked by content filtering before SUMMARY.md was written and tracking files committed. All work was on disk but uncommitted, except the implementation artifacts which the agent had already committed via individual task commits. Wait — re-reading the git log, the agent had NOT committed the addon artifacts either (status check after agent exit showed all 9 addon files + 3 helper files as untracked).
- **Fix:** Orchestrator (this session) verified the on-disk work matches the plan's must_haves (TTF SHA256 verified against helpers/inter-source.json; .import sidecar GL-Compat-correct; FontVariations have correct wght/opsz axes; FontFile resource opens with format=4), wrote OFL.txt (the only artifact the agent had not produced), staged + committed the addon artifacts atomically (commit `d701ac1`), staged + committed the helpers separately (commit `7adaa6c`), updated REQUIREMENTS.md to mark FONT-01/05/08 complete and FONT-06/TOKEN-10 in-progress, and is writing this SUMMARY now.
- **Files modified during inline finish:** `addons/neocade_theme/OFL.txt` (created), all 9 addon artifacts staged from worktree, all 3 helpers staged from worktree.
- **Commit:** `d701ac1` (addon artifacts) + `7adaa6c` (helpers) + this metadata commit.

### Architectural Changes Requested

None.

### Asks for User

None.

## Authentication Gates

None encountered.

## Verification

### Task 1 (Inter v4.0 ingestion)

PASS — `sha256sum addons/neocade_theme/fonts/Inter-Variable.ttf` returns `746431e950fd28d29b0189d708d4a5852a8458edb3184387eadcee9e5e34676c`, matching `ttf_sha256` in helpers/inter-source.json. File size 862,936 bytes matches `ttf_size_bytes`. Reserved Font Name `Inter` preserved (filename `Inter-Variable.ttf` is the canonical Inter v4.0 release name).

### Task 2 (FontFile.tres + .import sidecar)

PASS — `addons/neocade_theme/fonts/Inter-Variable.tres` opens with `[gd_resource type="FontFile" format=4]` (Godot 4.6 native FontFile serialization). `addons/neocade_theme/fonts/Inter-Variable.ttf.import` `[params]` block sets all 6 GL-Compatibility-correct values per PITFALLS 5.5.

### Task 3 (5 FontVariation .tres, M3 type scale)

PASS — each FontVariation .tres opens with `[gd_resource type="FontVariation" format=3]`, `ext_resource` references `Inter-Variable.tres` (not the .ttf directly), and `variation_opentype` block contains the wght/opsz axes per DESIGN_TOKENS §8.5:
- HeaderLarge: `wght=800, opsz=32`
- HeaderMedium: `wght=700, opsz=32`
- HeaderSmall: `wght=600, opsz=24`
- Body: `wght=400`
- Caption: `wght=400`

### Task 4 (OFL.txt)

PASS — `addons/neocade_theme/OFL.txt` contains:
- SIL Open Font License 1.1 verbatim (PREAMBLE / DEFINITIONS / PERMISSION & CONDITIONS / TERMINATION / DISCLAIMER)
- Inter copyright block (`Copyright (c) 2016 The Inter Project Authors (https://github.com/rsms/inter)`)
- Reserved Font Name notice (`Reserved Font Name "Inter"`)

### Task 5 (build-time helpers outside addon root)

PASS — `.planning/phases/04-.../helpers/` contains `_phase4_import.gd`, `_phase4_smoke.gd`, `inter-source.json`. `addons/neocade_theme/` still contains exactly 1 `.gd` file (`neocade_theme.gd`) — FOUND-01 / Phase 4 SC#1 invariant preserved.

### Task 6 (smoke test)

DEFERRED — `_phase4_smoke.gd` is committed but not executed in this session (godot CLI not on PATH in the orchestrator shell; smoke runs as part of the Phase 4 verifier or Plan 04-06 end-to-end load test).

## Known Stubs

- The Theme's `default_font` slot is NOT yet wired to `Inter-Variable.tres` (and the Theme's `default_font_size` slot is not wired to the M3 type scale). That wiring closes in Plan 04-05's BINDING_TABLE walk (additive `set_font` / `set_font_size` calls). FONT-06 stays in-progress until 04-05.
- The CHANGELOG.md entry documenting the pinned Inter version + SHA256 + synthetic italic policy lands in Plan 04-08, not this plan.

## Self-Check: PASSED

- All 9 addon artifacts present in `addons/neocade_theme/{fonts/*, OFL.txt}` and tracked in commit `d701ac1`.
- All 3 build-time helpers present in `.planning/phases/04-.../helpers/` and tracked in commit `7adaa6c`.
- `addons/neocade_theme/` still has exactly 1 `.gd` file (neocade_theme.gd) — FOUND-01 / Phase 4 SC#1 invariant intact.
- TTF SHA256 verified against pinned value.
- Import sidecar `[params]` set with all 6 GL-Compat values.
- 5 FontVariations cover DESIGN_TOKENS §8.5 wght/opsz axes.
- OFL.txt has SIL OFL 1.1 + Reserved Font Name notice + 2016 copyright.
- REQUIREMENTS.md FONT-01/05/08 marked Complete; FONT-06 + TOKEN-10 marked In Progress; FONT-02/03/04 marked Stricken.
