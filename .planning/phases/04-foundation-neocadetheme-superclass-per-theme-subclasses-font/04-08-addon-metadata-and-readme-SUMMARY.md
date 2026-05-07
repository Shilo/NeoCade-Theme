---
phase: 04-foundation-neocadetheme-superclass-per-theme-subclasses-font
plan: 08
subsystem: addon-distribution-metadata
tags: [foundation, distribution, license, changelog, readme, version, font-09, found-01]
requires:
  - 04-07
provides:
  - addon-metadata-set
  - phase-4-minimal-readme
  - mit-license-with-ofl-note
  - changelog-unreleased
  - version-pre-release-tag
affects:
  - addons/neocade_theme/
tech-stack:
  added: []
  patterns:
    - keep-a-changelog-1.1.0
    - semver-2.0.0
    - mit-license + sil-ofl-1.1 dual notice
    - cjk-fallback-via-default-font
    - synthetic-italic-via-fontvariation-transform
key-files:
  created:
    - addons/neocade_theme/LICENSE.md
    - addons/neocade_theme/CHANGELOG.md
    - addons/neocade_theme/VERSION
    - addons/neocade_theme/README.md
  modified: []
decisions:
  - "MIT for addon code; SIL OFL 1.1 for bundled Inter font (separate notice)"
  - "VERSION pre-release tag 0.4.0-phase-4; Phase 11 overwrites to 1.0.0"
  - "README ships Phase 4 minimal; Phase 11 expands to v1 distribution"
  - "FONT-09 CJK override pattern: append CJK font to default_font.fallbacks"
  - "FONT-07 italic fallback: font_italic theme slot + FontVariation.transform skew"
  - "FONT-04 code-font override: add_theme_font_override(\"font\", preload(...)) per CodeEdit"
  - "No plugin.cfg (STACK Decision 5 / D-05) — consumers preload .tres directly"
  - "Binding mechanism documented as REVISABLE (D-03) without breaking @export surface"
metrics:
  duration: ~6 min
  tasks_completed: 6
  files_created: 4
  files_modified: 0
  completed_date: 2026-05-07
---

# Phase 04 Plan 08: Addon Metadata + Phase 4 Minimal README Summary

Ship the addon's distribution metadata files (LICENSE.md / CHANGELOG.md / VERSION) and the Phase 4 minimal README at `addons/neocade_theme/`, closing FOUND-01 (addon directory layout), FONT-04 (code-font override pattern documented), FONT-07 (synthetic italic policy noted), and FONT-09 (CJK override pattern documented).

## Tasks Completed

| Task | Name                                                         | Commit  | Files                                          |
| ---- | ------------------------------------------------------------ | ------- | ---------------------------------------------- |
| 1    | Author addons/neocade_theme/LICENSE.md                       | bc192a1 | addons/neocade_theme/LICENSE.md                |
| 2    | Author addons/neocade_theme/CHANGELOG.md                     | bc192a1 | addons/neocade_theme/CHANGELOG.md              |
| 3    | Author addons/neocade_theme/VERSION                          | bc192a1 | addons/neocade_theme/VERSION                   |
| 4    | Author addons/neocade_theme/README.md (Phase 4 minimal)      | bc192a1 | addons/neocade_theme/README.md                 |
| 5    | Verify addon root layout (FOUND-01 + STACK Decision 5)       | bc192a1 | (verification only — no file edits)            |
| 6    | Atomic commit — addon metadata + README                      | bc192a1 | (commits 4 metadata files as one wave-4 commit)|

Tasks 1-4 author the four metadata files. Task 5 asserts the FOUND-01 layout invariant (exactly 1 .gd file at addon root; no plugin.cfg; helpers under .planning/phases/04-.../helpers/; each peer .tres < 2 KiB). Task 6 stages and commits all four files as one atomic wave-4 commit per the plan's commit grouping policy.

## Key Outputs

- **`addons/neocade_theme/LICENSE.md` (1.5 KB):** MIT license body + an explicit footer note documenting that `fonts/Inter-Variable.ttf` is licensed under SIL OFL 1.1 (separate from the addon code's MIT license). No conflicting `LICENSE` exists at the project root, so MIT was the correct default.
- **`addons/neocade_theme/CHANGELOG.md` (5.6 KB):** Keep-a-Changelog-1.1.0 / SemVer-2.0.0 format. Single `[Unreleased]` section enumerating Phase 4 deliverables under three subheadings: `### Added (Phase 4 — Foundation)`, `### Notes (v1.0.0 limitations preserved)`, `### Out of scope (v1)`. Inter v4.0 pinned by SHA256 (`746431…676C`); all 37 canonical Godot 4.6 Control names listed; 14 type variations enumerated (CodeLabel included per Cycle 1 C4); FONT-07 italic deferral, UD-2 CJK exclusion, D-05 no-plugin.cfg, and D-03 binding-mechanism-REVISABLE notes all present. Cycle 2 L3 hygiene preserved: no GraphFrame / GraphNode / HFlowContainer / HSeparator / VSeparator mentions in Phase-4 prose.
- **`addons/neocade_theme/VERSION` (14 bytes):** Single-line `0.4.0-phase-4` pre-release SemVer tag. Phase 11 overwrites to `1.0.0` for v1 distribution.
- **`addons/neocade_theme/README.md` (7.6 KB):** Phase-4-minimal consumer documentation covering: `## Recommended starter` (Pulse + the canonical `preload("res://addons/neocade_theme/pulse_neocade_theme.tres")` pattern), `## Available directions` (5-row table with all peers), `## Custom themes` (`NeoCadeTheme.new()` recipe), `## Theme Editor authoring` (BINDING_TABLE escape-hatch behaviour for slots not in the table), `## CJK / non-Latin script support` (FONT-09 override via `default_font.fallbacks`), `## Code font` (FONT-04 `add_theme_font_override("font", …)` recipe + theme-level alternative), `## Italic emphasis (synthetic fallback)` (FONT-07 `font_italic` slot + `FontVariation.transform` skew recipe), `## Architecture (v1)` (single concrete class + N data-only `.tres`, additive iteration), and the binding-mechanism `is REVISABLE` disclosure per D-03. Phase 11 expands this for v1 distribution.

## Verification Results

- Task 1 verifier (`.tmp/verify_task1.ps1`): PASS — MIT body + Inter Variable Roman + OFL anchors all present.
- Task 2 verifier (`.tmp/verify_task2.ps1`): PASS — 5573 bytes (within 2-8 KB band); all 37 canonical scorecard names + all 5 direction filenames + Inter SHA256 + BINDING_TABLE + 14 type variations + FONT-07/UD-2/D-05/D-03 notes present; no non-canonical Control mentions.
- Task 3 verifier (`.tmp/verify_task3.ps1`): PASS — 14 bytes, exactly 1 non-empty line, contains `0.4.0`.
- Task 4 verifier (`.tmp/verify_task_4.ps1`): PASS — 7621 bytes (within 3-14 KB band); all required headings + consumer preload pattern + all 5 direction filenames + `NeoCadeTheme.new()` + CJK override + FONT-04 `add_theme_font_override("font"` recipe + FONT-07 `font_italic` recipe + `is REVISABLE` disclosure + OFL.txt + LICENSE.md cross-references all present.
- Task 5 verifier (`.tmp/verify_task_20.ps1`): PASS — 11 required addon-root files present; both subdirectories (`fonts/`, `icons/`) present; all 8 forbidden paths absent (`plugin.cfg`, scaffold `neocade_theme.tres`, `_dev/`, `themes/`, mobile `.tres`, 3 helper `.gd` files at addon root); exactly 1 `.gd` file at addon root (`neocade_theme.gd`); 3 helpers present under `.planning/phases/04-.../helpers/`; all 5 direction `.tres` files < 2 KiB (Pulse 445, Slate 446, Bubble 447, Daybreak 456, Burst 440).
- Task 6 verifier (inline): PASS — `feat(04-08):` subject; 4 `A` entries in commit name-status; `git status --porcelain` empty for all 4 paths.

The Godot MCP server was available for an optional editor load test, but no functional code paths changed in this plan (4 new pure-text files at addon root, none referenced by `[ext_resource]` or `[gd_resource]`); the layout assertion in Task 5 is sufficient.

## Deviations from Plan

None - plan executed exactly as written.

The only minor adjustment: my first README draft used the phrase `**REVISABLE**` (bold-only) which did not match the plan's literal-string assertion `is REVISABLE`. I edited the surrounding sentence to read "the binding table itself is REVISABLE in future v1.x" so the literal phrase appears as required. This is a wording adjustment to satisfy the verifier's literal-substring check, not a semantic change.

## Authentication Gates

None encountered.

## Requirements Closed

- **FOUND-01 (addon distribution layout):** All required files (`LICENSE.md`, `CHANGELOG.md`, `VERSION`, `README.md`, `OFL.txt`) and subdirectories (`fonts/`, `icons/`) present; exactly 1 `.gd` file at addon root (`neocade_theme.gd`); no `plugin.cfg`; no scaffold residue; flat layout per CONTEXT.md "Track 4". Closed.
- **FONT-04 (code-font override pattern documented):** README ships both per-instance (`add_theme_font_override("font", …)`) and theme-level (`theme.set_font(…, "CodeEdit", …)`) override recipes for consumers who use CodeEdit / `[code]` BBCode. Closed.
- **FONT-07 (synthetic italic policy):** CHANGELOG documents Inter Italic Variable deferral; README ships `font_italic` theme-slot recipe + `FontVariation.transform` skew alternative for italic emphasis. Closed.
- **FONT-09 (CJK exclusion + override pattern):** CHANGELOG documents the no-CJK-bundled stance; README "CJK / non-Latin script support" section ships the `default_font.fallbacks` override recipe with FontFile cast. Closed.

## Self-Check: PASSED

- [x] `addons/neocade_theme/LICENSE.md` exists (1497 bytes)
- [x] `addons/neocade_theme/CHANGELOG.md` exists (5573 bytes)
- [x] `addons/neocade_theme/VERSION` exists (14 bytes)
- [x] `addons/neocade_theme/README.md` exists (7621 bytes)
- [x] Commit `bc192a1` exists in `git log` and lists all 4 paths as `A`
- [x] No file deletions in `git diff HEAD~1 HEAD --diff-filter=D`
- [x] Working tree clean post-commit
