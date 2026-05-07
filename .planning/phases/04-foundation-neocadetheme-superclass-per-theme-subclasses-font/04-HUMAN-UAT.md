---
status: partial
phase: 04-foundation-neocadetheme-superclass-per-theme-subclasses-font
source:
  - .planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-VERIFICATION.md
  - .planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-REVIEW.md
started: 2026-05-06T23:30:00Z
updated: 2026-05-06T23:30:00Z
---

## Current Test

[awaiting human decision on 3 items]

## Tests

### 1. BL-01 — Inter-Variable.tres bundle bloat (1.15 MB) policy decision
expected: User decides between (a) accept 2× font bundle as known v1 size penalty (current shipped state — Inter ships once as `.ttf` 843 KB plus once again as `.tres` with embedded `PackedByteArray` 1.15 MB ≈ 2.0 MB total, vs. FONT-REVIEW.md's "~810 KB" pledge), OR (b) fix-forward (delete `Inter-Variable.tres`; Godot regenerates the import sidecar from `.ttf` on first editor load via the auto-import pipeline, restoring single-copy bundle). Code review classified as Blocker against PROJECT.md / FONT-REVIEW.md size pledge but does not break functionality (font loads correctly). 1-line fix or PROJECT.md amendment.
result: pending
evidence: `.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-REVIEW.md` BL-01; `addons/neocade_theme/fonts/Inter-Variable.tres` (1,151,164 bytes) and `addons/neocade_theme/fonts/Inter-Variable.ttf` (862,936 bytes) both present in `addons/neocade_theme/fonts/`.

### 2. BL-02 — RichTextLabel `set_font("font", "InfoText", ...)` slot-name typo policy decision
expected: User decides between (a) accept the InfoText font fallback as a v1.x backlog item (RTL falls back to `theme.default_font` which is still Inter Variable, so visually correct but not the explicit per-variation font set), OR (b) apply the 1-line fix in `addons/neocade_theme/neocade_theme.gd:185` — change `set_font("font", "InfoText", body_font)` to `set_font("normal_font", "InfoText", body_font)` (and consider also setting `bold_font` / `italic_font` / `bold_italic_font` if explicit per-variation font discipline is required). Defeats PITFALLS 1.2 only as documented; runtime behavior remains acceptable.
result: pending
evidence: `.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-REVIEW.md` BL-02; `addons/neocade_theme/neocade_theme.gd:185`.

### 3. Editor sanity check — `_regenerate_theme()` fires on `.tres` load + populates Theme entries
expected: User opens Godot 4.6.2 editor on `c:\Programming_Files\Shilocity\Godot\NeoCade-Theme`, loads `main.tscn`, confirms (1) the scene parses cleanly with the Pulse theme override active on the root Control, (2) opening `addons/neocade_theme/pulse_neocade_theme.tres` in the Theme Editor shows fully-populated entries for the 37 BINDING_TABLE rows + 14 type variations (Button, PrimaryButton, GhostButton, ToolButton, Card, Accent, Strong, Default, Muted, Bold, Caption, MicroLabel, InfoText, CodeLabel) — the helpers `_phase4_verify.gd` (EditorScript) and `_phase4_verify_headless.gd` (SceneTree) are wired and ready but were not executed in the orchestrator environment per Cycle 6 F7 fallback (Godot CLI unavailable in the executor's Windows shell). Run `_phase4_verify.gd` from the editor (Tools → Run Script) to confirm Pulse + 4 peers populate correctly.
result: pending
evidence: `.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/helpers/_phase4_verify.gd` + `_phase4_verify_headless.gd` exist; both have `_verify_peers()` extension from Plan 04-07 Cycle 2 M3.

## Summary

total: 3
passed: 0
issues: 0
pending: 3
skipped: 0
blocked: 0

## Gaps

None blocking — phase delivers its stated structural foundation per all 8 ROADMAP success criteria. The 3 items above are decision/inspection points that need user resolution before Phase 5 can begin (per the project's Phase N → N+1 verify-then-clear-then-discuss flow).
