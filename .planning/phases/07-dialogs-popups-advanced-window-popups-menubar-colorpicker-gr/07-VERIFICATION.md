---
phase: 07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr
verified: 2026-05-07T11:40:54Z
status: passed
score: 12/12 must-haves verified
overrides_applied: 0
deferred:
  - truth: "Runtime screenshot/human visual proof for triggered popup/dialog surfaces and graph appearance"
    addressed_in: "Phase 9 and Phase 10"
    evidence: "Phase 9 goal builds the showcase that visually proves every Control; Phase 10 success criteria require screenshot matrix, tab-walk focus screenshots, and COV-10 diff checks."
---

# Phase 7: Dialogs, Popups, Advanced Verification Report

**Phase Goal:** Author the desktop theme entries for popup-class Controls plus advanced Controls (MenuBar, ColorPicker with 16 bespoke icons, Graph stack), completing desktop COV-01 100% Control coverage.
**Verified:** 2026-05-07T11:40:54Z
**Status:** passed
**Re-verification:** No - initial verification; no previous `*-VERIFICATION.md` was present.

## Goal Achievement

Roadmap success criteria and PLAN frontmatter D-truths were merged. Closely repeated D-truths are grouped under their matching roadmap structural truth.

### Observable Truths

| # | Truth | Status | Evidence |
|---|-------|--------|----------|
| 1 | D-01/D-02 autonomous execution stayed inside authorized Phase 6-8 mechanical scope and no new taste gate was introduced. | VERIFIED | Phase 7 context authorizes autonomous execution; implementation stayed inside `neocade_theme.gd`, icons, and phase-local helpers. No user-decision gate or scope-expanding file appeared. |
| 2 | D-19 official Godot 4.6.2 Phase 7 slot evidence is captured and enforced. | VERIFIED | `phase7-slot-freeze.txt` records Godot `4.6.2.stable.mono.official.71f334935`; verifier `assert_slot_freeze` passed in full stage. |
| 3 | D-20 staged verifier and ResourceSaver helper pattern exists, with final full stage at zero pending groups. | VERIFIED | `_run-phase7-verify.ps1 -Stage full` passed: 12 groups OK, 0 pending, 0 failures; `_phase7_resource_saver.gd` contains `ResourceSaver.save`, strip, reload, and export-drift checks. |
| 4 | D-21 architecture invariants are preserved. | VERIFIED | Addon root contains exactly one `.gd` (`neocade_theme.gd`); public exports remain 9; no `Theme.clear`; no root `addons/neocade_theme/neocade_theme.tres`; five direction `.tres` files are 412-428 bytes, data-only, linked to the one script. |
| 5 | D-22/COV-09 focus discipline uses official focus-capable slots only. | VERIFIED | Focus recipes are on official slots such as `Window` none, `ColorPicker.picker_focus_*`, `ColorPicker.sample_focus`, `ColorPickerButton.focus`, `GraphEdit.panel_focus`, and `GraphNode.panel_focus`; full verifier emitted `PHASE7_COV:COV-09 focus discipline preserved`. |
| 6 | Roadmap SC1 + D-03..D-07: all 8 popup-class types are first-class theme types and tooltip readability is structurally enforced. | VERIFIED | `BINDING_TABLE` has explicit entries for `Window`, `PopupPanel`, `PopupMenu`, `AcceptDialog`, `ConfirmationDialog`, `FileDialog`, `TooltipPanel`, `TooltipLabel`; full verifier `assert_popups_menus_stage` and `assert_filedialog_stage` passed. Tooltip contrast and zero-offset/transparent shadow checks are in `_assert_tooltip_readability`. |
| 7 | Roadmap SC2 + D-08..D-10: MenuBar and PopupMenu are themed with practical states, separators, submenu arrows, check/radio icons, and dense metrics. | VERIFIED | `MenuBar` binds official styleboxes/colors/constants, with direct font/font_size calls after the table walk. `PopupMenu` binds all official styleboxes/colors/constants/fonts/icons; submenu icons map to `popup_submenu` and `popup_submenu_mirrored`; popup menu metric checks passed. |
| 8 | D-11 icon contract holds for Phase 7 icon work. | VERIFIED | 48 Phase 7 SVG/import pairs exist (2 popup submenu, 20 FileDialog, 17 ColorPicker family, 9 graph); all SVGs contain `#FFFFFF`; all imports contain `uid://`, `svg/scale=2.0`, `mipmaps/generate=true`, `compress/mode=0`, and `process/fix_alpha_border=true`. |
| 9 | Roadmap SC3 + D-13/D-14: ColorPicker has exact official 16 icon slots, chrome/focus/constants, and no custom sampler/shader replacement; ColorPickerButton is complete. | VERIFIED | `BINDING_TABLE.ColorPicker` enumerates 3 focus styleboxes, cursor color, 6 constants, and 16 icon slots; `ColorPickerButton` enumerates official button-family styleboxes/colors/constants/icon plus direct font calls. Full verifier `assert_colorpicker_stage` passed. |
| 10 | Roadmap SC4 + D-15..D-17: GraphEdit, GraphNode, and GraphFrame meet basic-v1 structural quality. | VERIFIED | `BINDING_TABLE` covers official GraphEdit, GraphNode, and GraphFrame slots; graph verifier checks canvas color alpha, connection visibility, compact GraphNode margins, selected/focus states, flat GraphFrame grouping, and loaded Texture2D icons. Full verifier `assert_graph_stage` passed. |
| 11 | Roadmap SC5 + D-18: desktop structural Control coverage is closed at 37/37. | VERIFIED | Full verifier `assert_full_stage` passed and emitted `PHASE7_COV:COV-01 desktop structural scorecard closed at 37/37`; `SCORECARD_37_TYPES` contains 37 rows and each has generated entries on loaded Pulse. |
| 12 | Roadmap SC6 + D-12: FileDialog required icons load, resolved through official Godot 4.6.2 slots. | VERIFIED | 20 official FileDialog icons are bound and loaded as Texture2D. The roadmap's old "file-up" wording is resolved by local slot freeze: unsupported `file_up` is explicitly absent; official `favorite_up`, `parent_folder`, `back_folder`, `forward_folder`, `folder`, `file`, and `reload` slots are present. |

**Score:** 12/12 truths verified

### Deferred Items

Items not yet met but explicitly addressed in later milestone phases.

| # | Item | Addressed In | Evidence |
|---|------|--------------|----------|
| 1 | Runtime screenshot/human visual proof for popup/dialog triggering, graph appearance, full showcase visual coverage, and focus screenshots. | Phase 9 and Phase 10 | Phase 9 builds the 37-Control showcase and coverage strip; Phase 10 requires screenshot matrix, tab-walk focus screenshots, visual QA, COV-10 diff check, and accessibility QA. |

### Required Artifacts

| Artifact | Expected | Status | Details |
|----------|----------|--------|---------|
| `addons/neocade_theme/neocade_theme.gd` | Production theme generator with Phase 7 bindings | VERIFIED | 2,990 lines; contains `CANONICAL_SLOT_NAMES` and `BINDING_TABLE` rows for popup, menu, FileDialog, ColorPicker, and graph controls; direct font calls occur after BINDING_TABLE walk. |
| `helpers/phase7-slot-freeze.txt` | Official Godot 4.6.2 slot freeze | VERIFIED | Records engine, probe log path, stale exclusions, canonical icon families, and official slots for all Phase 7 controls. |
| `helpers/_phase7_verify_headless.gd` | Strict staged verifier | VERIFIED | Substantive assertions for slot freeze, stale-slot absence, icon mappings, architecture invariants, popup/menu/FileDialog/ColorPicker/graph coverage, 37/37 scorecard, and data-only resources. |
| `helpers/_run-phase7-verify.ps1` | Godot stage runner | VERIFIED | Resolves Godot 4.6.x and runs `_phase7_verify_headless.gd` with `slot-freeze`, `popups-menus`, `filedialog`, `colorpicker`, `graph`, or `full`. |
| `helpers/_phase7_resource_saver.gd` | Direction resource round-trip helper | VERIFIED | Loads five direction resources, snapshots 9 exports, calls `ResourceSaver.save`, strips generated entries, reloads as `NeoCadeTheme`, and checks data-only shape under 2048 bytes. |
| `addons/neocade_theme/icons/*.svg` Phase 7 families | Popup, FileDialog, ColorPicker, and graph icons | VERIFIED | 48 SVG/import pairs; count and import settings verified. |
| `addons/neocade_theme/*_neocade_theme.tres` | Five data-only direction resources | VERIFIED | Pulse, Slate, Bubble, Daybreak, and Burst are 412-428 bytes, have script linkage, all 9 explicit exports, no `[sub_resource]`, and no `theme_data/`. |

### Key Link Verification

| From | To | Via | Status | Details |
|------|----|-----|--------|---------|
| `@export` setters | `_regenerate_theme()` | Setter calls on all 9 exports | WIRED | Each public export setter invokes `_regenerate_theme()`, so runtime direction/platform changes regenerate entries. |
| `_regenerate_theme()` | `BINDING_TABLE` | `for theme_type in BINDING_TABLE.keys()` | WIRED | Loop resolves recipes and calls `set_stylebox`, `set_color`, `set_constant`, `set_font_size`, and `set_icon`. |
| Phase 7 font slots | Loaded theme font entries | Direct `set_font` / `set_font_size` calls after table walk | WIRED | Window, TooltipLabel, MenuBar, PopupMenu, and ColorPickerButton font slots are direct calls; verifier rejects font entries in BINDING_TABLE. |
| Icon recipes | SVG Texture2D assets | `_resolve_recipe(..., "icon")` loads `res://addons/neocade_theme/icons/<name>.svg` | WIRED | Full verifier checks FileDialog, ColorPicker, ColorPickerButton, and graph icons load as `Texture2D`. |
| Direction `.tres` files | `NeoCadeTheme` class | `script = ExtResource(... neocade_theme.gd)` | WIRED | Full verifier loads Pulse as `NeoCadeTheme`; data-only assertion checks all five direction resources. |
| Verifier runner | Headless Godot verifier | `_run-phase7-verify.ps1` invokes Godot with `_phase7_verify_headless.gd -- --stage <stage>` | WIRED | Full command completed successfully in this verification pass. |

### Data-Flow Trace (Level 4)

| Artifact | Data Variable | Source | Produces Real Data | Status |
|----------|---------------|--------|--------------------|--------|
| `neocade_theme.gd` | `BINDING_TABLE` recipes | Static Dictionary in production script | Yes - all recipes are walked and become Theme entries on loaded `NeoCadeTheme` instances | FLOWING |
| `neocade_theme.gd` | `tokens` | `_platform_tokens(_resolve_platform())` | Yes - desktop/mobile token values feed constants such as `tapPadding` and `thumbnailSize` | FLOWING |
| `neocade_theme.gd` | `role_table` colors | `_regenerate_theme()` derived surface/text/accent roles | Yes - stylebox/color recipes resolve against computed roles | FLOWING |
| `neocade_theme.gd` | Icon `Texture2D` values | `_resolve_recipe()` loads SVG files from addon icons directory | Yes - full verifier confirms bound icons are `Texture2D` | FLOWING |
| Direction `.tres` files | Export values | Five data-only resources with explicit 9 exports | Yes - loading a direction as `NeoCadeTheme` regenerates entries from those exports | FLOWING |

### Behavioral Spot-Checks

| Behavior | Command | Result | Status |
|----------|---------|--------|--------|
| Full Phase 7 structural verifier | `powershell -NoProfile -ExecutionPolicy Bypass -File .planning/phases/07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr/helpers/_run-phase7-verify.ps1 -Stage full` | `PHASE7_VERIFY OK (stage=full)`, 12 groups OK, 0 pending, 0 failures; emitted COV-01, COV-06, COV-07, COV-08, COV-09 markers. | PASS |
| Plan artifact declarations | `gsd-sdk query verify.artifacts` for all five `07-*-PLAN.md` files | All 11 declared artifacts passed existence/substance checks. | PASS |
| Key-link declarations | `gsd-sdk query verify.key-links` for all five plans | No `must_haves.key_links` declared; manual wiring checks above used fallback patterns. | SKIP |
| Phase 7 icon contract | PowerShell count/settings checks over Phase 7 SVG/import families | 48 SVGs and 48 imports; all SVGs have `#FFFFFF`; all imports have required Godot settings. | PASS |
| Direction resource shape | PowerShell data-only scan over `*_neocade_theme.tres` | Five resources under 2048 bytes with script linkage and 9 exports; no `[sub_resource]` or `theme_data/`. | PASS |

### Requirements Coverage

| Requirement | Source Plan | Description | Status | Evidence |
|-------------|-------------|-------------|--------|----------|
| COV-06 | 07-01, 07-02, 07-03 | Popup-class controls first-class | SATISFIED | Explicit `BINDING_TABLE` entries for all 8 popup-class types; full verifier emitted COV-06 marker. |
| COV-08 | 07-01, 07-02, 07-04, 07-05 | Advanced controls: MenuBar, ColorPicker, Graph stack | SATISFIED | MenuBar, ColorPicker, ColorPickerButton, GraphEdit, GraphNode, and GraphFrame entries present and verified; COV-08 markers emitted. |
| COV-01 | All Phase 7 plans | 37/37 desktop scorecard coverage closes here | SATISFIED | Full verifier asserts 37/37 generated entries on loaded Pulse. |
| COV-07 | 07-01, 07-02, 07-03, 07-05 | Container/window chrome complete | SATISFIED | Popup/window/dialog shell entries present; FileDialog shell resolves through dialog/window chrome; COV-07 marker emitted. |
| COV-09 | 07-01, 07-02, 07-04, 07-05 | Focus indicator discipline | SATISFIED | Official focus slots and focus-ring recipes verified; COV-09 marker emitted. |

No orphaned Phase 7 requirement IDs were found: COV-01, COV-06, COV-07, COV-08, and COV-09 are all claimed by Phase 7 plans and supported by implementation evidence.

### Anti-Patterns Found

| File | Line | Pattern | Severity | Impact |
|------|------|---------|----------|--------|
| `addons/neocade_theme/neocade_theme.gd` | 303, 2611-2990 | `return null` / null guard matches | Info | Legitimate recipe-resolution and shape-lookup escape hatches; verifier coverage confirms Phase 7 recipes resolve to real loaded entries. |
| `helpers/_phase7_verify_headless.gd`, `helpers/_phase7_resource_saver.gd` | multiple | Empty arrays / null checks | Info | Local accumulator defaults and failure guards in verification helpers, not UI-flowing placeholder data. |

No blocker anti-patterns, TODO/FIXME placeholders, or user-visible stub implementations were found in Phase 7 production paths.

### Human Verification Required

None for Phase 7 structural goal achievement. Visual/runtime screenshot proof is deferred as roadmap-scoped QA/showcase work, not a Phase 7 blocker.

### Gaps Summary

No Phase 7 blocking gaps found. The desktop structural coverage goal is achieved: popup-class controls, MenuBar/PopupMenu, FileDialog icons, ColorPicker/ColorPickerButton, GraphEdit/GraphNode/GraphFrame, focus discipline, architecture invariants, icon contracts, and 37/37 scorecard closure are all verified in the actual codebase.

---

_Verified: 2026-05-07T11:40:54Z_
_Verifier: the agent (gsd-verifier)_
