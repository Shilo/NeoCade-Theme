---
phase: 04-foundation-neocadetheme-superclass-per-theme-subclasses-font
plan: 04
subsystem: color-formulas-and-role-tokens
tags: [foundation, gdscript, color-formulas, surface-ramp, state-layers, role-tokens, raised-stylebox, platform-branch, direction-presets, wave-2]
requires:
  - plan: 04-01
    provides: NeoCadeTheme class shell with 9 @exports + Platform enum + is_light + reentry guard
provides:
  - Color helpers (_mix, _tint_toward_base) ported from the renderer's neocade-mockups.js — DESIGN_TOKENS §6.1
  - Platform helpers (_resolve_platform, _platform_tokens) — DESIGN_TOKENS §10.1, §10.2
  - Raised stylebox helper (_make_raised_stylebox) — DESIGN_TOKENS §9
  - DIRECTION_PRESETS dict + DIRECTION_PRESET_DEFAULT + _resolve_direction_presets() — Cross-AI Cycle 1 C2 fix, Cycle 6 F1 reconciliation
  - Per-call derivation block in _regenerate_theme() (surface ramp + tinted offsets + text colors + state-layer overlays + role tokens)
  - Precomputed locals consumed by Plan 04-05's BINDING_TABLE walk
affects: [phase-04, color-system, state-system, raised-vs-flat]
tech-stack:
  added: []
  patterns:
    - "Linear RGB lerp via Color() constructor matching the JS renderer (Color(a.r + (b.r - a.r) * t, ...)) — keeps GDScript port byte-equivalent to the mockup formulas"
    - "Hue-preserving tint via _mix(element, base, ratio=0.40) — replaces the HSL-darken-floored-at-0 antipattern documented in MOCKUP-REVISION-3-HANDOFF.md"
    - "Const Dictionary for direction-specific non-exported parameters (DIRECTION_PRESETS keyed by uppercased base_color hex) — keeps the @export surface minimal while still differentiating Pulse (wide spread) from Slate (narrow spread)"
    - "Reentry-guarded derivation block runs on every setter — locals computed up-front so Plan 04-05's binding-table walk reads them without recomputing per-Control"
    - "Platform branch via OS.has_feature(\"mobile\") with explicit DESKTOP/MOBILE forced modes — AUTO resolves at runtime, not at scene authoring time"
key-files:
  created:
    - .planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-04-SUMMARY.md
  modified:
    - addons/neocade_theme/neocade_theme.gd
    - .planning/REQUIREMENTS.md
    - .planning/STATE.md
    - .planning/ROADMAP.md
  ignored:
    - .tmp/ (executor verification scratchpad — added to .gitignore in commit 4dccb3f)
key-decisions:
  - "DIRECTION_PRESETS keyed by uppercased hex without alpha (matches Color.to_html(false).to_upper()). Five direction entries (Pulse/Slate/Bubble/Daybreak/Burst) reconciled to DESIGN_TOKENS §5.1-§5.5 verbatim per Cycle 6 F1 fix. DIRECTION_PRESET_DEFAULT gives custom themes a sensible-medium fallback (spread_factor=1.0, hover_pct=8, pressed_pct=-12, disabled_opacity=0.38)."
  - "Method-not-static_func for _mix/_tint_toward_base. Methods read no instance state but stay on the instance for clarity + future extensibility (per-direction overrides could subclass and override; not in v1, but cheap to allow)."
  - "elevate_target = BLACK if is_light else WHITE applied to surface_panel/high/overlay/outline_color and state_hover, but NOT to surface_low — surface_low always mixes toward BLACK regardless of is_light (DESIGN_TOKENS §6.2 explicit semantic). Same pattern for state_pressed (always BLACK)."
  - "Text colors are concrete hex literals (#F7F8FB / #B9C1D0 dark; #1B2230 / #5A6478 light) per DESIGN_TOKENS §6.4 — NOT derived from base_color. The values were hand-calibrated for WCAG 2.1 AA across all approved palettes; deriving them would risk drift."
  - "_make_raised_stylebox returns a fresh StyleBoxFlat without setting bg_color/corner/border/content_margin — caller (Plan 04-05's binding table) is responsible for those slots. The helper handles only the raised-vs-flat shadow contract (shadow_size = -1 when flat per Godot #98162; shadow_color = offset_color, shadow_size = intensity, shadow_offset = (0, intensity) when raised)."
  - "presets.pressed_pct stored as negative magnitude (per DESIGN_TOKENS §6.5 convention: hover lifts toward elevate_target, pressed sinks toward BLACK). The derivation block applies abs() to extract magnitude. Reduces ambiguity vs. signed mixing semantics."
patterns-established:
  - "Wave 2 split (formulas first, binding-table second) keeps Plan 04-05's BINDING_TABLE walk pure data — every entry-population path consumes precomputed locals from the derivation block, so the table can stay declarative + readable."
  - "Direction-keyed const Dictionary pattern: any future per-direction non-exported parameter (e.g. v2 mood-curves, alternate state-layer pcts) plugs in by adding a row to DIRECTION_PRESETS keyed by base_color hex — no @export changes."
  - "PowerShell verification scratchpad pattern at .tmp/verify-NN-NN.ps1 — gitignored via .tmp/, used at executor task close to assert all needed substrings + structural patterns are present in the modified file before commit."
requirements-completed:
  - TOKEN-01 (partial — surface ramp formula implementation; binding-table consumption closes in 04-05)
  - TOKEN-02 (partial — role.primary + accent_rim derivation; binding-table consumption closes in 04-05)
  - TOKEN-03 (partial — text color derivation with is_light branch; binding-table consumption closes in 04-05)
  - TOKEN-06 (partial — _platform_tokens returns desktop/mobile sizing dict including mobile +50% via densityScale=1.5; binding-table consumption closes in 04-05)
  - TOKEN-08 (partial — _make_raised_stylebox sets shadow_size=-1 when flat; binding-table consumption closes in 04-05)
  - TOKEN-09 (partial — state-layer derivation with per-direction hover/pressed/disabled pcts from DIRECTION_PRESETS; binding-table consumption closes in 04-05)
  - FOUND-02 (partial — formulas + role tokens added; binding-table walk + entry population closes in 04-05)
duration: ~30 min effective (resumed by orchestrator inline after executor agent hit usage limit at turn-close)
completed: 2026-05-06
---

# Phase 4 Plan 04: Color Formulas + Role Tokens Summary

**Ported the renderer's color/derivation formulas + state-layer model + raised-stylebox helper + platform branch into NeoCadeTheme. _regenerate_theme() now precomputes surface ramp + tinted offsets + text colors + state layers + role tokens for Plan 04-05's BINDING_TABLE walk to consume.**

## Performance

- **Started:** 2026-05-06 (after Plan 04-03 commit `ae26d14`)
- **Completed:** 2026-05-06 (commits `4dccb3f` + `be370d6` + this metadata commit)
- **Tasks:** 5 (color helpers / platform helpers / raised stylebox / DIRECTION_PRESETS / derivation block) — all passed verify-04-04.ps1

## Accomplishments

- Added `_mix(a: Color, b: Color, amount: float) -> Color` (linear RGB lerp; matches `lerp(a, b, t)` in `neocade-mockups.js`).
- Added `_tint_toward_base(element: Color, base_c: Color, ratio: float = 0.40) -> Color` (hue-preserving tint replacing HSL-darken-floored-at-0 antipattern per MOCKUP-REVISION-3-HANDOFF.md).
- Added `_resolve_platform() -> Platform` (resolves `Platform.AUTO` to MOBILE/DESKTOP via `OS.has_feature("mobile")`; `DESKTOP`/`MOBILE` are forced and bypass detection).
- Added `_platform_tokens(p: Platform) -> Dictionary` returning the 14-key sizing dict per DESIGN_TOKENS §10.1: buttonMin/primaryButtonMin/inputMin/toggleMin/checkboxSize/body/label_/h1/h2/kicker/rowMin/tabMin/tapPadding/densityScale. Mobile values include the +50% bump (densityScale=1.5).
- Added `_make_raised_stylebox(bg: Color, offset_color: Color, intensity: int) -> StyleBoxFlat` per DESIGN_TOKENS §9: `shadow_size = -1` + `shadow_offset = ZERO` when flat (Godot #98162); `shadow_color = offset_color`, `shadow_size = intensity`, `shadow_offset = (0, intensity)` when raised — hard offset, no blur (extruded-flat 3D primitive per FLAT-3D-UI-RESEARCH.md).
- Added `const DIRECTION_PRESETS: Dictionary` keyed by uppercased base_color hex (no alpha) with sub-dict `{spread_factor, hover_pct, pressed_pct, disabled_opacity}` per direction. Reconciled to DESIGN_TOKENS §5.1-§5.5 verbatim per Cycle 6 F1 fix:
  - Pulse `#151A2E` → `1.3 / +6  / -10 / 0.42` (wide spread, restrained hover, deep pressed, near-AA disabled)
  - Slate `#111820` → `0.7 / +4  / -6  / 0.50` (narrow spread, subdued hover/pressed, baseline 0.50 disabled)
  - Bubble `#241326` → `1.0 / +8  / -10 / 0.45` (medium spread, lively hover, deep pressed)
  - Daybreak `#0B2420` → `1.0 / +6  / -6  / 0.50` (medium spread, gentle states, baseline disabled)
  - Burst `#20112E` → `1.3 / +8  / -12 / 0.45` (wide spread, lively hover, deepest pressed)
- Added `const DIRECTION_PRESET_DEFAULT: Dictionary` for custom themes that don't match any approved direction (`spread_factor=1.0, hover_pct=8, pressed_pct=-12, disabled_opacity=0.38`).
- Added `_resolve_direction_presets() -> Dictionary` (lookup by `base_color.to_html(false).to_upper()` with fallback to default).
- Wired the derivation block at the top of `_regenerate_theme()` (lines 96-153 in the new file). Computes:
  - 5-stop surface ramp via `_mix(base_color, elevate_target, k * spread_factor)` — `surface_low` mixes toward BLACK regardless of `is_light`; the rest use `elevate_target = BLACK if is_light else WHITE`.
  - 5 tinted offset tokens for raised mode (`accent_offset`, `surface_high_offset`, etc.) via `_tint_toward_base(...)` (default ratio 0.40).
  - `text_strong / text_default / text_muted` with `is_light` branch (DESIGN_TOKENS §6.4 hex literals).
  - `state_hover` (target flips with `is_light`) and `state_pressed` (always toward BLACK), with magnitudes from `presets.hover_pct / abs(presets.pressed_pct)`.
  - `role_primary = accent_color` and `accent_rim = _mix(accent_color, WHITE, 0.5)` per DESIGN_TOKENS §7.1.
- D-01 invariant preserved — zero `\bclear\(` matches anywhere in the file (verified post-commit).
- Added `.tmp/` to `.gitignore` (commit `4dccb3f`) so the executor's verification scratchpad (`verify-04-04.ps1`, `check-indent.ps1`) doesn't leak into version control.

## Task Commits

1. **`.gitignore` ← `.tmp/` exclusion (executor scratchpad)** — `4dccb3f` (`chore(04-04): ignore .tmp/ executor verification scratchpad`)
2. **Implementation: 176 insertions / 2 deletions in neocade_theme.gd (helpers + DIRECTION_PRESETS + derivation block)** — `be370d6` (`feat(04-04): port color formulas + state-layer model + raised stylebox + platform branch into NeoCadeTheme`)
3. **Plan metadata: SUMMARY.md + REQUIREMENTS.md + STATE.md + ROADMAP.md** — this commit.

## Files Created/Modified

**Modified:**
- `addons/neocade_theme/neocade_theme.gd` — 102 lines → 277 lines. Added 5 helper functions, DIRECTION_PRESETS const + DIRECTION_PRESET_DEFAULT const + `_resolve_direction_presets()`, and the per-call derivation block (60 lines) at the top of `_regenerate_theme()`. The placeholder skeleton comment from Plan 04-01 is replaced with the actual derivation block.
- `.gitignore` — added `# Local verification scratchpad (executor-only)` + `.tmp/` block.
- `.planning/REQUIREMENTS.md` — TOKEN-01..03/06/08/09 marked In Progress with Plan 04-04 evidence; binding-table consumption noted as closing in 04-05.
- `.planning/STATE.md` — Plan 04-04 advanced to current_plan: 5.
- `.planning/ROADMAP.md` — Phase 4 plan progress.

## Decisions Made

- **`func` over `static func` for color helpers.** `_mix` and `_tint_toward_base` read no instance state but stay on the instance for clarity + future extensibility (per-direction overrides could subclass and override; not in v1, but cheap to allow). DIRECTION_PRESETS lookup is also `func`-based (`_resolve_direction_presets`) for the same reason.
- **DIRECTION_PRESETS keyed by hex string, not direction enum.** Enables the lookup to work for any base_color the user sets — including custom themes — via `base_color.to_html(false).to_upper()` matching. Falls back to `DIRECTION_PRESET_DEFAULT` for non-matching colors. Avoids hardcoding a Direction enum that would have to know about all 5 approved directions at the language level.
- **Negative `pressed_pct` in DIRECTION_PRESETS, `abs()` in derivation.** Per DESIGN_TOKENS §6.5 convention, hover lifts toward elevate_target (positive %), pressed sinks toward BLACK (negative %). Storing the sign in the preset documents the directional intent at the data layer; the derivation block extracts magnitude via `abs()`. Reduces ambiguity vs. signed mixing semantics.
- **`elevate_target` applies to surface_panel/high/overlay/outline + state_hover, NOT surface_low.** Per DESIGN_TOKENS §6.2 explicit semantic — surface_low is "always slightly darker than base" regardless of color mode, so it always mixes toward BLACK. Same rule for state_pressed (always toward BLACK, even in light mode where hover would target BLACK too).

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 — Process] Orchestrator finished commit + SUMMARY inline after executor hit usage limit.**
- **Found during:** post-Task-5 close.
- **Issue:** The spawned executor agent (`gsd-executor`) completed all 5 implementation tasks, ran `verify-04-04.ps1` to PASS, committed the `.gitignore` change for `.tmp/`, but the next commit (the implementation diff) was blocked by an Anthropic monthly usage limit response on the model side. All implementation work was on disk and verified, but uncommitted (`git diff --stat addons/neocade_theme/neocade_theme.gd` showed `1 file changed, 176 insertions(+), 2 deletions(-)` matching the planned scope).
- **Fix:** Orchestrator (this session) re-ran `verify-04-04.ps1` (5/5 PASS), confirmed D-01 (`grep '\bclear\(' addons/neocade_theme/neocade_theme.gd` returns zero matches), committed the implementation atomically (`be370d6`), updated REQUIREMENTS.md TOKEN-01..03/06/08/09 with Plan 04-04 evidence, and is writing this SUMMARY now.
- **Files modified during inline finish:** `addons/neocade_theme/neocade_theme.gd` (already on disk, just staged + committed), `.planning/REQUIREMENTS.md`.
- **Commit:** `be370d6` (implementation) + this metadata commit.

### Architectural Changes Requested

None.

### Asks for User

None.

## Authentication Gates

None encountered.

## Verification

All 5 tasks verified by `.tmp/verify-04-04.ps1` (PowerShell). Output:

```
== Task 1: color helpers ==
  PASS
== Task 2: platform helpers ==
  PASS
== Task 3: raised stylebox helper ==
  PASS
== Task 3.5: DIRECTION_PRESETS ==
  PASS
== Task 4: derivation block ==
  PASS

ALL CHECKS PASSED
```

D-01 invariant verified separately:

```
$ grep -nE '\bclear\(' addons/neocade_theme/neocade_theme.gd
(no matches)
```

## Known Stubs

- The `BINDING_TABLE` walk that consumes the precomputed derivation locals lands in Plan 04-05. Until then, `_regenerate_theme()` computes the locals but does not yet populate any Theme entries — that's the explicit Wave 2 contract (formulas first, binding-table second).
- The 14 NeoCade type variations + per-Control font registration also land in Plan 04-05.

## Self-Check: PASSED

- `addons/neocade_theme/neocade_theme.gd` exists at 277 lines.
- Commit `be370d6` exists in `git log --oneline --all` and shows the expected single-file payload.
- All 5 task gates from `.tmp/verify-04-04.ps1` PASS.
- D-01 invariant: zero `\bclear\(` matches in the file.
- TOKEN-01..03/06/08/09 traceability rows updated with Plan 04-04 evidence.
- `.gitignore` includes `.tmp/` (executor scratchpad excluded from version control).
