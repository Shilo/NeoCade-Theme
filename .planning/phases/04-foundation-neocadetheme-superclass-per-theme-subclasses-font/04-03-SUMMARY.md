---
phase: 04-foundation-neocadetheme-superclass-per-theme-subclasses-font
plan: 03
subsystem: addon-button-family-icons
tags: [foundation, icons, svg, monochrome, modulate, scale-2x, mipmaps, godot-4-6, wave-1]
requires:
  - phase: 03.4-visual-direction-flat-extruded-flat-mockup-approval-gate
    provides: visual identity rule (flat MD3, no textures, no embossing) drives the strict #FFFFFF monochrome icon policy
  - plan: 04-01
    provides: addon root layout (the `icons/` subdirectory is added under the layout established in 04-01)
provides:
  - addons/neocade_theme/icons/check.svg
  - addons/neocade_theme/icons/checkbox_checked.svg
  - addons/neocade_theme/icons/checkbox_unchecked.svg
  - addons/neocade_theme/icons/radio_checked.svg
  - addons/neocade_theme/icons/radio_unchecked.svg
  - addons/neocade_theme/icons/checkbutton_checked.svg
  - addons/neocade_theme/icons/checkbutton_unchecked.svg
  - addons/neocade_theme/icons/arrow_down.svg
  - addons/neocade_theme/icons/clear.svg
  - addons/neocade_theme/icons/close.svg
  - 10 matching `.svg.import` sidecars (Godot-normalized: real `.ctex` md5 paths + Godot-issued UIDs, zero literal placeholders)
affects: [phase-04, button-family-binding, icon-contract, future-icon-plans-phases-6-7]
tech-stack:
  added:
    - "Hand-authored SVG icon contract: 32x32 viewBox, single fill/stroke color #FFFFFF only, geometric primitives only (rect / circle / path)"
  patterns:
    - "Strict single-color monochrome icons (Cross-AI Cycle 1 MEDIUM fix). Every fill and stroke is `#FFFFFF` only, so Godot's icon `modulate = accent_color` produces predictable tinted output across every state. Two-tone state communication (e.g. CheckButton on/off track fill) is composed via the StyleBoxFlat backing the icon, not baked into the icon itself."
    - ".import sidecar contract: `svg/scale=2.0` (so 32x32 reference renders at 64x64 baseline texture for crisp downscale) + `mipmaps/generate=true` (Linear With Mipmaps when assigned with the default texture filter) + `compress/mode=0` (lossless — vector-derived bitmaps degrade with lossy compression at icon edges) + `process/fix_alpha_border=true` (cleans premultiplied-alpha bleed). Same template will apply to Tree / TabBar / ColorPicker / FileDialog / ScrollBar icons in Phases 6/7."
    - "Three-stage icon import workflow (Cycle 6 F5 fix): Stage A author placeholder `.import` with synthetic `path=` + `uid=` placeholders, Stage B run `godot --headless --import` to materialize the `.ctex` cache and rewrite paths/UIDs to real values, Stage C commit only the post-Stage-B normalized files. Mirrors the font-import workflow Plan 04-02 used for `Inter-Variable.ttf.import`."
key-files:
  created:
    - addons/neocade_theme/icons/check.svg
    - addons/neocade_theme/icons/check.svg.import
    - addons/neocade_theme/icons/checkbox_checked.svg
    - addons/neocade_theme/icons/checkbox_checked.svg.import
    - addons/neocade_theme/icons/checkbox_unchecked.svg
    - addons/neocade_theme/icons/checkbox_unchecked.svg.import
    - addons/neocade_theme/icons/radio_checked.svg
    - addons/neocade_theme/icons/radio_checked.svg.import
    - addons/neocade_theme/icons/radio_unchecked.svg
    - addons/neocade_theme/icons/radio_unchecked.svg.import
    - addons/neocade_theme/icons/checkbutton_checked.svg
    - addons/neocade_theme/icons/checkbutton_checked.svg.import
    - addons/neocade_theme/icons/checkbutton_unchecked.svg
    - addons/neocade_theme/icons/checkbutton_unchecked.svg.import
    - addons/neocade_theme/icons/arrow_down.svg
    - addons/neocade_theme/icons/arrow_down.svg.import
    - addons/neocade_theme/icons/clear.svg
    - addons/neocade_theme/icons/clear.svg.import
    - addons/neocade_theme/icons/close.svg
    - addons/neocade_theme/icons/close.svg.import
    - .planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-03-SUMMARY.md
  modified:
    - .planning/REQUIREMENTS.md
    - .planning/STATE.md
    - .planning/ROADMAP.md
key-decisions:
  - "Strict single-color `#FFFFFF` policy on every icon (Cross-AI Cycle 1 MEDIUM fix). Two-tone visual contrast (toggle knob-on-track, checked-box-with-check) is composed by the StyleBoxFlat backing the icon, not baked into the icon SVG. Reason: `Color.BLACK * accent` stays black under any tint; single-color icons multiply cleanly with `icon_modulate = accent_color`."
  - "Hand-authored SVG path data committed verbatim from the plan. No external icon library is bundled (per ICON-04 + STACK Decision 5 + D-12). Future icon plans (Phases 6/7) follow the same hand-authored geometric-primitive approach."
  - "Three-stage icon import workflow (Cycle 6 F5 fix) used to satisfy the no-`<` / no-`>` acceptance criterion: placeholder authored, `godot --headless --import` invoked against the locally-installed Godot 4.6.2 binary, normalized files committed. Verified the committed `.import` files contain real md5 hashes (`check.svg-1da97d24aa667c2d321edd2649ffbbfc.ctex`) and Godot-issued UIDs (`uid://ve3dudp5t6uu`)."
  - "Icon SVG byte sizes are well under the 2 KB sanity ceiling — largest is `checkbox_checked.svg` at 391 bytes, smallest is `radio_unchecked.svg` at 241 bytes. Total addon icon payload before .import: ~3.0 KB across 10 files."
  - "CheckButton icon naming clarified per Cycle 6 F4 fix: filenames mirror the Godot 4.6 CheckButton theme icon slot names (`checked` / `unchecked`), even though the visual still renders the toggle/switch pill+knob style. Icon files: `checkbutton_checked.svg` + `checkbutton_unchecked.svg`."
patterns-established:
  - "Single-color `#FFFFFF` monochrome SVG icon contract (geometric primitives only, no gradients, no patterns, no embossing). Applies to every icon in the addon — Button family in this plan, Tree / TabBar / ColorPicker / FileDialog / ScrollBar in Phases 6/7."
  - ".svg + .svg.import sidecar pair as the unit of authoring. Same template applies to every icon slot. Phase 6/7 icon plans copy the .import body verbatim and substitute `<name>` for the icon's filename."
  - "Icon import normalization via `godot --headless --import` is part of the build workflow. Same Godot binary used for Plan 04-02 font import — single tool, two asset types."
requirements-completed:
  - ICON-03 (monochrome SVG policy locked + applied to 10 icons)
  - ICON-04 (no external icon library bundled — hand-authored SVGs only)
  - ICON-01 (partial — 10 of ~25-40 icons; remaining slots in Phases 6/7 under the same contract)
  - ICON-02 (partial — Button family + CheckBox/CheckButton on/off + OptionButton arrow + LineEdit clear + dialog close; Tree/TabBar/ColorPicker/FileDialog/ScrollBar slots in Phases 6/7)
duration: ~7 min (Wed 2026-05-06 afternoon)
completed: 2026-05-06
---

# Phase 4 Plan 03: Button-Family Bespoke Icons + Import Contract Summary

**Authored 10 hand-written monochrome SVG icons at 32x32 reference covering the Button family (Button check, CheckBox on/off, RadioButton on/off, CheckButton on/off, OptionButton arrow, LineEdit clear, dialog close), plus 10 matching `.import` sidecars locking `svg/scale=2.0` + Linear With Mipmaps + lossless compression — closes ICON-03 + ICON-04 and partially closes ICON-01 + ICON-02.**

## Performance

- **Started:** 2026-05-06 (after Plan 04-01 commit `d1d596c` and Plan 04-02 commit `7adaa6c`)
- **Completed:** 2026-05-06 (atomic commit `ec27939` + this metadata commit)
- **Tasks:** 3 (per plan: author 10 SVGs / author + normalize 10 .import sidecars / atomic commit)

## Accomplishments

- Authored 10 hand-written monochrome SVG icons at 32x32 reference, every fill/stroke `#FFFFFF` only, every file under 2 KB:
  - `check.svg` — 286 bytes (single-path checkmark stroke)
  - `checkbox_checked.svg` — 391 bytes (rounded-corner box outline + check stroke)
  - `checkbox_unchecked.svg` — 258 bytes (rounded-corner box outline)
  - `radio_checked.svg` — 292 bytes (circle outline + filled inner dot)
  - `radio_unchecked.svg` — 241 bytes (circle outline)
  - `checkbutton_checked.svg` — 309 bytes (pill outline + filled knob on right)
  - `checkbutton_unchecked.svg` — 309 bytes (pill outline + filled knob on left)
  - `arrow_down.svg` — 287 bytes (chevron)
  - `clear.svg` — 342 bytes (circle outline + inset X)
  - `close.svg` — 255 bytes (bare X)
- Authored 10 placeholder `.import` sidecars with the locked Plan 04-03 template (`svg/scale=2.0`, `mipmaps/generate=true`, `compress/mode=0`, `process/fix_alpha_border=true`).
- Ran `godot --headless --import` against the locally-installed Godot 4.6.2 binary (`C:\Programming_Files\Godot\Godot_v4.6.2-stable_win64.exe`) to materialize each `.ctex` cache file under `res://.godot/imported/` and rewrite every `path=`, `dest_files=`, and `uid=` line in the sidecars with real values.
- Verified every committed `.import` file:
  - Contains zero literal `<` or `>` characters (Cycle 6 F5 acceptance criterion).
  - `path=` line points at `res://.godot/imported/<icon>.svg-<32-hex-md5>.ctex`.
  - `uid=` line points at a Godot-issued `uid://[a-z0-9]+` UUID.
- Atomic commit `ec27939` lands all 20 files under `addons/neocade_theme/icons/`.

## Task Commits

1. **Tasks 1+2+3 (atomic): author SVGs + normalize .import sidecars + commit** — `ec27939` (`feat(04-03): author Button-family bespoke icons + import contract`).
2. **Plan metadata: SUMMARY.md + STATE.md + ROADMAP.md + REQUIREMENTS.md** — this commit.

The plan was structured as three tasks (Task 1 = author SVGs, Task 2 = author + normalize .import sidecars, Task 3 = atomic commit). Task 3's `<action>` block explicitly demands a single combined commit for all 20 files, so the per-task commits collapse into one atomic feat commit per the plan's instruction.

## Files Created/Modified

**Created (addon-distributed):**
- 10 SVG icons at `addons/neocade_theme/icons/*.svg` (~3.0 KB total)
- 10 `.import` sidecars at `addons/neocade_theme/icons/*.svg.import` (~10.7 KB total, Godot-normalized)

**Modified:**
- `.planning/REQUIREMENTS.md` — ICON-03 and ICON-04 marked Complete; ICON-01 and ICON-02 marked In Progress; traceability table updated for all four
- `.planning/STATE.md` — Plan 04-03 complete, advance to Plan 04-04, performance metric appended, decision logged
- `.planning/ROADMAP.md` — Phase 4 progress 1/8 -> 3/8 (Plans 04-01, 04-02, 04-03 done)

## Decisions Made

- **Strict single-color `#FFFFFF` policy across the entire Button family.** Cross-AI Cycle 1 MEDIUM fix. Reason: Godot's icon `modulate` multiplies — `Color.BLACK * accent` stays black under any tint, breaking accent-aware coloring. Single-color icons multiply cleanly with `icon_modulate = accent_color` so the binding-table walk in Plan 04-05 can drive every per-state icon color from a single `accent_color` value.
- **Two-tone state communication is composed by the StyleBoxFlat backing the icon, not baked into the icon SVG.** The CheckButton on-state visual ("track filled accent + knob on right") is achieved by the binding-table setting the StyleBoxFlat's `bg_color = accent_color` for the on-state; the icon itself only draws the outline + knob, in `#FFFFFF`, so the modulate multiplies cleanly against any base. This keeps icons composable across the 5 v1 directions without per-direction icon authoring.
- **Three-stage icon import workflow (Cycle 6 F5 fix) used.** Stage A authored placeholders, Stage B ran `godot --headless --import` against the local Godot 4.6.2 install, Stage C committed only the post-Stage-B normalized files. The placeholder `<hash>` and `<name>` literals from the plan body were swapped for `PLACEHOLDERHASH` during Stage A so Godot's import scanner could parse the file before normalizing it (literal `<` is a reserved character in Windows filenames, which would break the placeholder dest_files entry).
- **The `.import` template gained extra params after Godot ran.** Godot 4.6 added `compress/uastc_level=0`, `compress/rdo_quality_loss=0.0`, and `process/channel_remap/{red,green,blue,alpha}` to each `[params]` block during normalization. These are Godot-default values and don't affect the contract (the six values the plan demands — `importer`, `type`, `svg/scale=2.0`, `mipmaps/generate=true`, `compress/mode=0`, `process/fix_alpha_border=true` — are all present and verified).

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 3 — Blocking] Substituted `PLACEHOLDERHASH` for the literal `<hash>` placeholder during Stage A authoring.**
- **Found during:** Task 2 Stage A.
- **Issue:** The plan's `.import` template body contains literal `<hash>` and `<name>` strings as placeholders. On Windows, `<` is a reserved filename character; if Godot's import scanner attempts to parse `path="res://.godot/imported/check.svg-<hash>.ctex"` it may throw a malformed-path error before reaching the rewrite step.
- **Fix:** Substituted `PLACEHOLDERHASH` for the `<hash>` token during Stage A. After Stage B (`godot --headless --import`), every committed file contains the real md5-hash filename, so the final committed state matches the plan's no-`<` / no-`>` acceptance criterion either way. The `<name>` token in the template was always template-substituted (per-icon name) before write, so it never appeared in any actual file.
- **Files modified during fix:** None — the substitution happens in the build script (`.tmp-author-imports.ps1`) which is not committed.
- **Commit:** N/A (build-time-only).

### Architectural Changes Requested

None.

### Asks for User

None.

## Authentication Gates

None encountered.

## Verification

### Task 1 (10 monochrome SVGs)

PASS — all 10 files exist, every file's first line begins with `<?xml version="1.0"`, every `<svg>` tag contains `width="32" height="32" viewBox="0 0 32 32"`, every file uses only `#FFFFFF` for fills/strokes (no `#000000` or other colors), every file is under 2 KB. Per-element checks pass: `radio_checked` / `radio_unchecked` / `checkbutton_*` / `clear` contain `<circle>`; `checkbox_*` / `checkbutton_*` contain `<rect>`; `check` / `arrow_down` / `close` / `checkbox_checked` / `clear` contain `<path>`.

### Task 2 (10 .import sidecars normalized via godot --headless --import)

PASS — all 10 files exist; every file contains `importer="texture"`, `type="CompressedTexture2D"`, `svg/scale=2.0`, `mipmaps/generate=true`, `compress/mode=0`, `process/fix_alpha_border=true`; every `source_file=` line correctly points at the matching `.svg`; every file is under 2 KB; no file contains literal `<` or `>` characters; every `path=` line matches `path="res://\.godot/imported/[A-Za-z0-9_]+\.svg-[0-9a-f]{32}\.ctex"`; every `uid=` line matches `uid="uid://[a-z0-9]+"`.

### Task 3 (atomic commit)

PASS — `git log -1 --pretty=%s` returns `feat(04-03): author Button-family bespoke icons + import contract`; `git log -1 --name-status` shows exactly 20 `A` entries for the 10 SVG + 10 `.import` paths; `git status --porcelain addons/neocade_theme/icons` is empty.

## Known Stubs

- The 10 icon `.tres` resources are NOT yet wired into Theme entries via `set_icon`. That binding closes in Plan 04-05's BINDING_TABLE walk (additive `set_icon(slot_name, type_name, preload(path_to_svg))` calls). The icons exist on disk + are import-ready; the `_regenerate_theme()` consumer is the next plan.
- The remaining icon slots (Tree expand/collapse, TabBar increment/decrement/menu, ColorPicker preset/screen-pick/sample-bg/recent, FileDialog parent/folder/file/file-up/back/forward/reload, ScrollBar increment/decrement/grabber) are NOT in scope for Plan 04-03; they land in Phase 6 (Lists/Layout/Range — Tree, TabBar, ScrollBar) and Phase 7 (Dialogs/Popups/Advanced — ColorPicker, FileDialog) under the same `.import` contract established here.

## Self-Check: PASSED

- All 10 SVGs present at `addons/neocade_theme/icons/*.svg` and tracked in commit `ec27939`.
- All 10 `.import` sidecars present at `addons/neocade_theme/icons/*.svg.import` and tracked in commit `ec27939`.
- Every SVG strict single-color `#FFFFFF` (regex check + manual review).
- Every `.import` file Godot-normalized (real md5 hash + Godot-issued UID, zero `<` or `>`).
- REQUIREMENTS.md ICON-03 + ICON-04 marked Complete; ICON-01 + ICON-02 marked In Progress with Phases 6/7 contribution noted.
- STATE.md advanced to Plan 04-04; ROADMAP.md updated 1/8 -> 3/8 for Phase 4.
- `addons/neocade_theme/` still has exactly 1 `.gd` file (`neocade_theme.gd`) — FOUND-01 / Phase 4 SC#1 invariant intact.
