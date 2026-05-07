---
phase: 8
reviewers: [opencode]
reviewed_at: 2026-05-07T05:20:17.7026428-07:00
cycle: 2
plans_reviewed:
  - 08-01-PLAN.md
  - 08-02-PLAN.md
  - 08-03-PLAN.md
  - 08-04-PLAN.md
  - 08-05-PLAN.md
---

# Cross-AI Plan Review - Phase 8

## OpenCode Review

**Reviewer:** OpenCode / DeepSeek V4 Pro
**Cycle:** 2 of /gsd-plan-review-convergence 8 --opencode --chain --auto
**Reviewer normalization:** OpenCode follow-up confirmed current_high=0 and current_high_section=none after the raw review emitted one. while listing no HIGH concerns.

---

# Cross-AI Plan Review - Phase 8 Cycle 2

## Summary

All five revised plans are substantively improved over Cycle 1. The plans now contain a complete executable tap-target formula contract (37-row table with per-row proxy formulas), unambiguous heading-parity enforcement matching MOBILE-03/D-08, and a clear resolution of the 13-vs-15 type-variation discrepancy anchored to the production `TYPE_VARIATIONS` registry. The plan structure (helper foundation -> token hardening -> strict audit -> root spec -> toggle proof) mirrors the successful Phase 6/7 pattern. The plans are internally consistent, respect the locked 9-export surface, and correctly forbid separate mobile `.tres` / density resources / subclasses / root fallback.

## Strengths

1. **Executable formula contract (08-03):** The `<audit_formula_contract>` block defines helper primitives (`font_y`, `sb_x`, `sb_y`, `icon_w`, `icon_h`, `k`) plus per-category baseline formulas (button, input, row, tab, handle) and a complete 37-row classification table. This is exactly what Cycle 1 H-2 asked for - no formula logic is deferred to implementation anymore.

2. **Heading-parity enforcement is now hard-coded in verifier assertions (08-02):** Task 1 explicitly asserts `HeaderLarge = 36` on both platforms and acceptance criteria state "The verifier fails if any Header* type variation shrinks on mobile." Task 2 explicitly corrects any production heading token that currently shrinks. H-1 is structurally resolved.

3. **15-variation resolution is production-anchored (08-04):** The `<type_variation_source_of_truth>` block declares the production `TYPE_VARIATIONS` dictionary as authoritative, lists all 15 entries by name, supersedes the older 13-entry research wording, and makes the docs verifier fail on any count other than 15. H-3 is definitively resolved.

4. **Raised/platform orthogonality is tested across all four combinations (08-02 Task 3):** The verifier duplicates Pulse and covers `raised=false/true x platform=DESKTOP/MOBILE`, checking shadow sentinels, content margin persistence, and entry survival after repeated toggles. This is a thorough contact-surface test.

5. **No mobile/root/per-density resource creation:** Every plan's acceptance criteria explicitly forbid `neocade_mobile_theme.tres`, root fallback `.tres`, per-density resources, subclasses, and per-direction `.gd` files. The verifier architecture stage enforces these as hard assertions, not prose conventions.

## Cycle 1 HIGH Resolution Check

- **H-1:** RESOLVED. Plan 08-02 Task 1 now asserts HeaderLarge = 36 on both desktop and mobile, and the acceptance criteria explicitly fail if any Header* variation shrinks. The earlier 36->32px contradiction is gone.
- **H-2:** RESOLVED. Plan 08-03 includes a complete 37-row formula contract with named helper primitives, per-category baseline formulas, and a per-row width/height proxy specification. No formula logic is deferred to implementation.
- **H-3:** RESOLVED. Plan 08-04 anchors the count to the production `TYPE_VARIATIONS` dictionary, lists all 15 entries by name, supersedes the 13-entry research wording, and makes the docs verifier enforce count = 15.

## Current HIGH Concerns

none

## Concerns

### MEDIUM

- **M-1: FileDialog classification ambiguity (08-03 audit table).** FileDialog is classified as `display` in the classification column but its Pass rule evaluates `thumbnail_size >= 48`. If it's truly display-only, the rule should be `N/A` (matching AcceptDialog/ConfirmationDialog/Window). If the thumbnail is considered an interactive proxy, the classification should be `interactive`. The current combination is internally contradictory, though the audit can resolve this at implementation time.

- **M-2: 08-05 Task 1 creates `scripts/phase8_platform_toggle.gd` but the task says to use a "duplicated Pulse direction theme."** If the script calls `theme.duplicate()` on a preloaded resource, subsequent export-mutation tests may not exercise the same code paths as `_regenerate()` triggered by export setters. If the approach is intentionally "duplicate then mutate exports" (triggering setters), the wording should clarify this. Not blocking - the implementation can get this right.

### LOW

- **L-1: 08-03 audit table uses `input_h("LineEdit")` inside the SpinBox height proxy formula.** SpinBox has its own theme entries; using the LineEdit slot inside its proxy calculation assumes SpinBox inherits or mirrors the LineEdit entry, which may not be true if SpinBox has its own `normal` StyleBox. The implementer should verify the actual slot access pattern.

- **L-2: 08-05 Task 1 mentions creating "only the controls needed to test the proof," but the acceptance criteria only grep-verify the script and scene references, not that the scene has the right set of representative Controls.** A visual runtime gate is implicitly Phase 9. This is fine.

## Suggestions

1. Resolve M-1 by classifying FileDialog as `interactive` (thumbnail click target) or changing its rule to `N/A` with the thumbnail proxy noted as informational in `notes`.
2. Add a companion resource-saver strip step to the 08-05 final verification sequence (Task 3) so direction `.tres` files are verified data-only at the end of the phase, not just during intermediate plans.

## Risk Assessment

- **Architectural drift risk:** LOW. Every plan's architecture stage enforces the 9-export surface, single-`.gd` addon root, five data-only `.tres`, and forbidden resource paths. The verifier is structural, not prose-based.
- **Mobile sizing correctness risk:** LOW. The formula contract is per-row specific, the 48px floor is explicit, and both RED/GREEN tasks force the audit to fail before production fixes land.
- **Type-variation staleness risk:** LOW. 08-04 derives the variation list from the production dictionary at verification time, so any future drift would fail the docs stage.
- **Cross-plan dependency risk:** LOW. The sequential wave structure (01->02->03->04->05) correctly sequences foundation before hardening before audit before docs before toggle proof.


---

## Consensus Summary

This cycle used the requested single external reviewer: OpenCode with deepseek/deepseek-v4-pro.

### Agreed Strengths

- Single-reviewer cycle; no multi-reviewer agreement data is available.
- OpenCode found the revised five-plan structure sound and aligned with the Phase 6/7 verifier-first pattern.
- OpenCode confirmed the Cycle 1 HIGH concerns H-1, H-2, and H-3 are resolved by the revised plans.

### Agreed Concerns

- Single-reviewer cycle; no 2+ reviewer consensus can be computed.
- OpenCode raised no current HIGH concerns.
- Remaining follow-ups are MEDIUM/LOW: FileDialog classification ambiguity, toggle-script wording, SpinBox proxy assumption, and scene representative-control assertion depth.

### Divergent Views

- None. Only OpenCode was invoked per the --opencode requirement.

## Current HIGH Concerns

none

