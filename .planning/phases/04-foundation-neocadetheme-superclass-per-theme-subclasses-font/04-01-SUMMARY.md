---
phase: 04-foundation-neocadetheme-superclass-per-theme-subclasses-font
plan: 01
subsystem: addon-foundation
tags: [foundation, neocade-theme, gdscript, class-shell, scaffold-deletion, wave-1]
requires:
  - phase: 03.4-visual-direction-flat-extruded-flat-mockup-approval-gate
    provides: Phase 3.4 mockup approval (final-approval.md gating Plans 04-04..08; not blocking 04-01 class-shell scaffolding)
  - phase: 03.2-godot-dynamic-theme-architecture-research
    provides: dynamic-theme architecture pattern (export-driven regeneration + reentry guard) and D-01 no-clear() invariant
provides:
  - addons/neocade_theme/neocade_theme.gd class shell (`@tool class_name NeoCadeTheme extends Theme` with 9 @exports, Platform enum, is_light derivation, _regenerating reentry guard, _regenerate_theme() skeleton)
  - main.tscn cleared of broken scaffold theme reference (parses cleanly without `theme = ExtResource(...)` and without ext_resource line for the deleted `.tres`)
  - File-presence + class-shape contract that unblocks Wave 2 plans (04-02 fonts, 04-03 icons, 04-04 formulas, 04-05 binding-table)
affects: [phase-04, addon-layout, class-contract, design-tokens-implementation]
tech-stack:
  added: []
  patterns:
    - "@tool class_name script attached to a Resource subtype (Theme) with @export setters that re-derive Resource state via a reentry-guarded helper"
    - "Equality short-circuit on every @export setter (`if prop == value: return`) to avoid no-op regenerations"
    - "Boolean reentry guard (`_regenerating`) to make the regeneration helper safe to call from `_init()` and from setter cascades during deserialization"
    - "Luminance-derived dark/light flag (`is_light = base_color.get_luminance() >= 0.5`) replacing an explicit `light_mode` toggle"
key-files:
  created:
    - addons/neocade_theme/neocade_theme.gd
    - .planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-01-SUMMARY.md
  modified:
    - main.tscn
  deleted:
    - addons/neocade_theme/neocade_theme.tres
key-decisions:
  - "D-01 enforced from day 1 — no `Theme.clear()` call anywhere in the regeneration code path. The skeleton enforces this even before Plans 04-04/04-05 fill in the body, and the comment placeholder for future plans deliberately avoids the literal `clear()` token to keep a hard grep boundary."
  - "main.tscn `theme = ExtResource(...)` line is REMOVED entirely (Cycle 6 F2 fix 2026-05-06) rather than replaced with a placeholder comment — Godot 4.6 `.tscn` comments use `;` not `#`, and the parser discards comments on save, so any placeholder strategy would silently vanish on the first editor save. Plan 04-07 reintroduces a live theme reference pointing at Pulse."
  - "Class-header docstring documents the binding-mechanism choice (slot-name + property-name table) as REVISABLE per CONTEXT.md D-03 — explicit grep anchors (`REVISABLE`, `D-03`, `D-31`, `D-04 escape hatch`, `binding`) carry forward to the audit trail."
  - "Defaults match DESIGN_TOKENS §3 / CONTEXT.md D-13 sensible-neutral values (`#111820`, `#8BD3FF`, `false`, `AUTO`, `12`, `4`, `3`, `2`, `1`) — explicitly NOT pre-baked Pulse colors. Pulse mood is encoded in `pulse_neocade_theme.tres` data (Plan 04-06), not in the class defaults."
patterns-established:
  - "Phase 4 implementation order: file presence + class shape FIRST (this plan), then formulas (04-04), then binding-table walk (04-05). The shell carries enough invariants (no-clear(), reentry guard, is_light) that downstream plans cannot accidentally regress D-01 or trigger infinite regeneration loops."
  - "@export setter pattern for any future Theme-derived Resource: equality short-circuit → write field → call regenerate helper. Documented inline as a reusable shape."
  - "Naming discipline 2026-05-06f carried forward — `corner_radius` not `corner_radius_base`, `spacing` not `base_spacing`, `raised_strength` not `raised_offset`, `@export_group(\"Shape\")` not `\"Shape Language\"`."
requirements-completed:
  - FOUND-01 (partial — addon layout shape established; full layout closes with Plans 04-02/03/06/07/08)
  - FOUND-02 (partial — class shell + 9-property @export surface; formula + binding-table body close in 04-04/04-05)
  - TOKEN-05 (partial — `corner_radius: int` export wired; full 4-rung scale binding closes in 04-04/04-05)
  - TOKEN-07 (partial — `outline_width: int` + `focus_thickness: int` exports wired; stroke-width binding closes in 04-04/04-05)
duration: 25 min
completed: 2026-05-06
---

# Phase 4 Plan 01: Scaffold Deletion + NeoCadeTheme Class Shell Summary

**Authored the production NeoCadeTheme class shell with all 9 @exports, deleted the empty scaffold .tres, and cleared the broken main.tscn theme reference — unblocking Wave 1 parallel plans.**

## Performance

- **Started:** 2026-05-06T23:02:02Z (phase context gathered)
- **Completed:** 2026-05-06T23:06:38Z (commit `d1d596c`)
- **Tasks:** 3 (delete + clear scene + author class shell, all in one atomic commit)
- **Files touched:** 3 (1 deleted, 1 modified, 1 created)

## Accomplishments

- Deleted the empty `addons/neocade_theme/neocade_theme.tres` scaffold from project init (`[gd_resource type="Theme" format=3]` + bare `[resource]`, no theme content) per CONTEXT.md D-14 step 1 + DESIGN_TOKENS §12.2.
- Removed the `main.tscn` `[ext_resource ... id="1_ig7tw"]` line and the root Control's `theme = ExtResource("1_ig7tw")` line entirely. The scene now parses cleanly as a stand-alone Control with no theme override; Plan 04-07 will reintroduce a live `theme = ExtResource("1_pulse_theme")` line pointing at Pulse.
- Authored `addons/neocade_theme/neocade_theme.gd` with the locked-2026-05-06f architecture: `@tool class_name NeoCadeTheme extends Theme`, the `enum Platform { DESKTOP, MOBILE, AUTO }`, all 9 `@export` properties in the canonical order (Core 4 first, then Shape 5 under `@export_group("Shape")`), with sensible-neutral defaults `#111820 / #8BD3FF / false / AUTO / 12 / 4 / 3 / 2 / 1` exactly matching DESIGN_TOKENS §3 / CONTEXT.md D-13.
- Every `@export` setter applies the equality short-circuit pattern (`if prop == value: return`) before writing the field and calling `_regenerate_theme()`, so no-op assignments do not trigger regeneration churn.
- Added the non-exported `is_light: bool` field, the `_regenerating: bool` reentry guard, and the `_last_regeneration_usec: int` diagnostic.
- Wrote the `_regenerate_theme()` skeleton: reentry guard at the top, `is_light = base_color.get_luminance() >= 0.5` derivation, a placeholder comment marking where Plans 04-04 (formulas) and 04-05 (binding-table walk) will fill the body, and the `_regenerating = false` reset at the bottom. **Crucially, no `Theme.clear` call appears anywhere in the file — D-01 invariant enforced from day 1.**
- Wrote the class-header docstring with the required grep anchors (`REVISABLE`, `D-03`, `D-31`, `D-04 escape hatch`, `binding`) so future audits can locate the binding-mechanism revisability statement without ambiguity.
- `_init()` calls `_regenerate_theme()` once on resource construction so `is_light` is derived even before any setter fires.

## Task Commits

1. **Tasks 1+2+3 (atomic): delete scaffold + clear scene ref + author class shell** — `d1d596c` (`feat(04-01): delete scaffold .tres + scene ref + author NeoCadeTheme class shell`)

The plan's Task 3 directs a single atomic commit covering all three changes (deletion + scene edit + new file) so the working tree never holds a half-applied state. Per-task commits collapse to one Plan 04-01 commit by design.

**Plan metadata:** this summary commit (separate from the implementation commit; carries SUMMARY.md + STATE.md + ROADMAP.md updates).

## Files Created/Modified

- **CREATED** `addons/neocade_theme/neocade_theme.gd` (102 lines) — production NeoCadeTheme class shell. `@tool` annotation on line 1, `class_name NeoCadeTheme` on line 2, `extends Theme` on line 3. Class-header docstring (lines 5-22) documents architecture lock 2026-05-06f, D-31, D-04 escape hatch for Theme-Editor-authored content, and the D-03 REVISABLE binding-mechanism note. `enum Platform { DESKTOP, MOBILE, AUTO }` declared at line 24. Core 4 `@export` properties in order: `base_color`, `accent_color`, `raised`, `platform`. `@export_group("Shape")` opens the Shape block, then `corner_radius`, `spacing`, `raised_strength`, `focus_thickness`, `outline_width` in order. Internal state: `is_light: bool`, `_regenerating: bool`, `_last_regeneration_usec: int`. `_init() -> void` calls `_regenerate_theme()`. `_regenerate_theme() -> void` skeleton with reentry guard, `is_light` derivation, and the no-`Theme.clear` invariant comment for future plans.
- **MODIFIED** `main.tscn` — removed the `[ext_resource type="Theme" uid="uid://dyblavdboqhji" path="res://addons/neocade_theme/neocade_theme.tres" id="1_ig7tw"]` line and the root Control's `theme = ExtResource("1_ig7tw")` property line. The scene now parses as a clean Control root with `layout_mode = 3`, fullscreen anchors, and no theme override. Plan 04-07 reassigns Pulse.
- **DELETED** `addons/neocade_theme/neocade_theme.tres` — empty scaffold from project init (`[gd_resource type="Theme" format=3 uid="uid://dyblavdboqhji"]` + bare `[resource]`). No theme content was carried; deletion is non-destructive.

## Decisions Made

- **D-01 enforced from day 1.** The skeleton intentionally contains no `Theme.clear` call, AND the placeholder comment documenting the invariant for future plans uses the prose phrasing `NO Theme.clear call permitted` rather than the literal token `clear()`. This preserves a hard grep boundary so any future implementation regression (a `clear()` call landing in the file) is detectable by a single `\bclear\(\)` regex.
- **No placeholder comment in main.tscn** (Cycle 6 F2 fix 2026-05-06). The `theme = ExtResource(...)` line is removed entirely rather than commented out, because Godot 4.6 `.tscn` files use `;` (not `#`) for single-line comments per `engine_details/file_formats/tscn.md` AND the parser discards comments on save — any placeholder would silently vanish on the first editor open + save. The `[node ...]` block parses cleanly without a `theme` line; Plan 04-07 reintroduces a live reference.
- **Defaults are sensible-neutral, not Pulse-flavored.** `base_color = #111820`, `accent_color = #8BD3FF` match DESIGN_TOKENS §3 / CONTEXT.md D-13 and are intentionally close to (but not identical to) Slate's palette so an unset NeoCadeTheme instance produces a usable dark theme without baking any approved direction into class-level defaults. Pulse's specific colors land in `pulse_neocade_theme.tres` data via Plan 04-06.
- **Reentry guard pattern over backing-field pattern.** The spike at `.planning/spikes/dynamic-theme/SpikeNeoCadeTheme.gd` uses backing fields to suppress recursion during deserialization; this plan uses a single `_regenerating: bool` flag instead, per RESEARCH.md §4 minimal-shape recommendation. Backing fields are reserved as an escalation path if Plan 04-05 surfaces a deserialization-order issue the flag cannot solve.

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 — Bug] Rephrased the `_regenerate_theme()` placeholder comment to avoid the literal `clear()` token**
- **Found during:** Task 2 verification.
- **Issue:** The plan's verbatim skeleton in `<action>` includes the comment `# NO `clear()` call permitted in this method per D-01 (additive iteration).`. This comment contains the literal substring `clear()`, which trips the plan's own `\bclear\(\)` grep guard (`if ($g -match '\bclear\(\)') { throw 'clear() call found — D-01 forbids' }`). The author's intent is "no `Theme.clear()` invocation"; the comment is documentation, not a call site, but the grep regex cannot distinguish.
- **Fix:** Rephrased the comment to `# NO Theme.clear call permitted in this method per D-01 (additive iteration only).` — same documentation intent, no literal `clear()` token, grep guard remains a hard boundary against any future regression that lands an actual `Theme.clear()` invocation.
- **Files modified:** `addons/neocade_theme/neocade_theme.gd` (one comment line).
- **Commit:** `d1d596c` (folded into the atomic Plan 04-01 commit before staging).

### Architectural Changes Requested

None.

### Asks for User

None.

## Authentication Gates

None encountered.

## Verification

### Task 1 (scaffold deletion + scene clear)

PASS — verified via `verify-task1.ps1`:
- `Test-Path 'addons/neocade_theme/neocade_theme.tres'` → False
- `main.tscn` does NOT match `neocade_theme\.tres`
- `main.tscn` does NOT match `theme = ExtResource\(`
- `main.tscn` does NOT match `(?m)^\s*[#;]\s*theme = ExtResource` (no placeholder comment)
- `main.tscn` first line matches `^\[gd_scene` (valid scene file)

### Task 2 (class shell)

PASS — verified via `verify-task2.ps1`:
- All 30 required substrings present (`@tool`, `class_name NeoCadeTheme`, `extends Theme`, `enum Platform { DESKTOP, MOBILE, AUTO }`, all 9 `@export var ...` declarations, `@export_group("Shape")`, both default color literals, `Platform.AUTO`, `var is_light: bool`, `var _regenerating: bool`, `func _regenerate_theme() -> void:`, all three reentry-guard substrings, `is_light = base_color.get_luminance() >= 0.5`, `func _init() -> void:`, all 5 docstring grep anchors).
- `\bclear\(\)` regex finds zero matches (D-01 invariant).
- All 9 `@export` setters carry the equality short-circuit pattern `if {prop} == value: return`.

### Task 3 (atomic commit)

PASS — verified via `verify-task3.ps1`:
- `git log -1 --pretty=%s` matches `^feat\(04-01\):`.
- `git log -1 --name-status` shows `D addons/neocade_theme/neocade_theme.tres`, `M main.tscn`, `A addons/neocade_theme/neocade_theme.gd`.
- `git status --porcelain` filtered to the three Plan 04-01 paths is empty (no leftover staged/unstaged changes).

### Manual / Editor verification

- Godot CLI (`godot --headless --check-only`) is not on PATH in this shell; the file's GDScript-4.6 syntax is verified by static-string assertion (all required tokens present, no `clear()` call, all setters well-formed). Phase 4 Plan 04-04/05 will exercise the file at runtime via headless test invocations; any parse error would surface there.

## Known Stubs

- `_regenerate_theme()` body is intentionally a SKELETON (the only live behavior is the `is_light` derivation and the reentry-guard bookkeeping). The comment marks where Plans 04-04 (formulas) and 04-05 (binding-table walk) will fill the body. This is documented in PLAN.md `<interfaces>` and is the explicit Wave 1 contract — not an unwired stub. No theme entries are populated by Plan 04-01; that is by design and does NOT block Wave 1 parallel plans (04-02 fonts, 04-03 icons), which need only the file presence + class shape.

## Self-Check: PASSED

- `addons/neocade_theme/neocade_theme.gd` exists.
- `main.tscn` exists and parses (starts with `[gd_scene`).
- `addons/neocade_theme/neocade_theme.tres` does NOT exist (verified deleted).
- Commit `d1d596c` exists in `git log --oneline --all` and shows the expected 3-file payload.
- Post-commit deletion check: `git diff --diff-filter=D --name-only HEAD~1 HEAD` returned exactly `addons/neocade_theme/neocade_theme.tres` (intentional, no unexpected deletions).
