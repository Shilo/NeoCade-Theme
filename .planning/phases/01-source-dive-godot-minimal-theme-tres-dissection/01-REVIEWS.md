---
phase: 1
cycle: 2
reviewers: [opencode]
reviewer_models:
  opencode: deepseek/deepseek-v4-pro
reviewed_at: 2026-05-04T18:05:00Z
plans_reviewed:
  - 01-01-dissection-skeleton-PLAN.md
  - 01-02-per-control-enumeration-PLAN.md
  - 01-03-omission-and-pitfalls-PLAN.md
  - 01-04-coverage-delta-PLAN.md
  - 01-05-sources-md-update-PLAN.md
high_concerns: 0
medium_concerns: 0
low_concerns: 4
overall_risk: LOW
convergence_judgment: EXIT
prior_cycle:
  cycle: 1
  high_concerns: 2
  medium_concerns: 4
  low_concerns: 4
  overall_risk: MEDIUM
---

# Cross-AI Plan Review — Phase 1 (Cycle 2)

## OpenCode Review (DeepSeek V4 Pro)

# Cross-AI Plan Review — NeoCade Theme Phase 1 (CYCLE 2)

## 1. Summary

All 6 cycle-1 concerns (2 HIGH + 4 MEDIUM) are **fully resolved** in the plan text. The re-waving is correct (01→02→[03,04]→05), line-citation validation is now a Task 3 with runtime `sed -n 'Np'` spot-checks, row counts use dynamic `grep -c` equality, the scorecard correctly pins FlatButton outside the 35-class universe, engine-source anchoring now extracts from `version.py` with a greppable `ENGINE-VERSION-CAVEAT` fallback, and the Globals `scale`/`popup_margin` rows carry explicit FORBIDDEN-in-NeoCade callouts. No new HIGH concerns. The coverage scorecard in Plan 01-04 lists 37 rows against a claimed 35-row universe (self-acknowledged, reconciled by Task 2) — polish-level, not blocking.

## 2. Verification of Cycle-1 Fixes

### HIGH #1 — Wave-1 parallelism broken
**RESOLVED.** Waves reordered: 01 (wave 0) → 02 (wave 1) → [03, 04] (wave 2) → 05 (wave 3). Plan 03 declares `depends_on: [01, 02]`; Plan 04 declares `depends_on: [01, 02]`; Plan 05 declares `depends_on: [01, 02, 03, 04]`. Task dependencies match the wave structure.

### HIGH #2 — Hardcoded line citations without runtime validation
**RESOLVED.** Plan 01-01 Task 3 validates all 12 cited line numbers against the live snapshot via `sed -n 'Np'` spot-checks, appends a `Line-citation runtime validation` stamp on success, and provides a correction path if any check fails. The verify block re-runs the same checks.

### MED #3 — False-fail static minimum row counts
**RESOLVED.** Plans 01-02 Tasks 2–7 all use dynamic equality: `discovery=$(grep -cE ...); enumerated=$(awk ...); test "$enumerated" -eq "$discovery"`. Zero-discovery classes require an explicit "no upstream entries" note instead of a row count.

### MED #4 — 38-vs-35 double-count for HSplit/VSplit
**RESOLVED.** Plan 01-04's `<interfaces>` block states: "HSplitContainer and VSplitContainer ARE in the v1 user-facing class matrix (both rows marked YES)." The Coverage Scorecard is scoped to 35 rows; FlatButton is in a separate `## FlatButton — Type Variation Note (D-10) — OUTSIDE the 35-class scope` section. The sum invariant `themed-in-upstream + NeoCade-additive + bare-class-unthemed + container-chrome = 35` is explicitly verified in Task 2.

### MED #5 — Engine-source anchor weak when not a git repo
**RESOLVED.** Plan 01-03 Task 1 extracts `major`/`minor`/`patch` from `version.py`; emits `ENGINE-VERSION-CAVEAT` only if version.py cannot confirm Godot ≥ 4.6 AND the dir is not a git repo. The acceptance criteria includes: "If NOT-A-GIT-REPO is present AND major=4 is NOT present, file MUST contain `ENGINE-VERSION-CAVEAT`."

### MED #6 — Globals `scale`/`popup_margin` missing FORBIDDEN callouts
**RESOLVED.** Plan 01-01 Task 2's Globals table has:
- `scale` row: `⚠ **EDSCALE-derived; FORBIDDEN in NeoCade per D-05.**`
- `popup_margin` row: `**NeoCade note:** the 4.0 * scale term is EDSCALE-derived and forbidden in NeoCade per D-05`
Acceptance criterion requires greppable `FORBIDDEN in NeoCade per D-05` on the `scale` row.

## 3. New HIGH Concerns

**None.** No new HIGH concerns introduced by the cycle-1 fixes.

## 4. Remaining MEDIUM Concerns

**None.** All 4 cycle-1 MEDIUMs are fully resolved; no new MEDIUMs found.

## 5. LOW Concerns

- **LOW (carry-over #7):** Plan 01-03 Task 4 uses `grep -rn` on `popup.cpp` and `window.cpp` with `2>/dev/null` — if either file doesn't exist in the user's Godot clone, Pitfall 1.7 engine evidence relies on `theme_db.cpp` alone. Non-blocking; grep won't crash.
- **LOW (carry-over #8):** Plan 01-03 Tasks 3/4 still use `head -20` / `head -30` in engine-source greps. If focus/popup draw logic falls outside the first 20-30 matches, evidence is missed. Acceptable for initial discovery; the pitfall sections already cite specific line numbers from prior research, so the heads are confirmatory, not foundational.
- **LOW (carry-over #9):** Plan 01-05's in-place edits on SOURCES.md require exact `old_string` matches. The plan mitigates this with `read_first` verification of current Section 1 state before any edits.
- **LOW:** Plan 01-04's Coverage Scorecard template has 37 numbered rows (1–37) but claims a 35-class universe. The plan self-acknowledges this ("Row count is 37 — wait, that's an off-by-one") and defers exact reconciliation to Task 2. The sum-invariant verify in Task 2 will catch any genuine miscount. Not a HIGH because: (a) the plan is aware of the discrepancy, (b) Task 2's verify block enforces `themed+additive+bare+chrome=35` exactly, (c) the acceptance criteria allow 35-37 rows pre-Task-2.
- **LOW (cycle-1 #10 — no longer a concern):** The cycle-1 concern about the awk pattern `/^### [A-Z]/` not matching `### User-facing container chrome` was based on a misunderstanding of regex — `[A-Z]` matches the single character `U`, so the pattern correctly matches. The awk script in Task 8 is sound for this document.

## 6. Risk Assessment

**Overall risk: LOW.** All 6 cycle-1 concerns (2 HIGH + 4 MEDIUM) are fully resolved in the plan text. No new HIGH or MEDIUM concerns found. The remaining LOWs are polish-level: grep-head truncation risk in engine-source searches, exact-string match fragility in SOURCES.md edits, and a self-acknowledged 37-vs-35 row count in the scorecard that Task 2 reconciles.

## 7. Convergence Judgment

**EXIT.** No HIGH concerns remain. The plans are ready for execution.

---

## Consensus Summary (single reviewer)

Only one reviewer was invoked this cycle (OpenCode + DeepSeek V4 Pro per project config `review.models.opencode`). No cross-reviewer consensus to synthesize.

### Cycle 2 Outcome

- **Cycle 1 → Cycle 2 deltas:**
  - HIGH concerns: 2 → 0 (-2, both RESOLVED)
  - MEDIUM concerns: 4 → 0 (-4, all RESOLVED)
  - LOW concerns: 4 → 4 (3 carry-overs + 1 new self-acknowledged scorecard row count)
  - Overall risk: MEDIUM → LOW
- **Convergence verdict:** EXIT — no HIGH concerns remain; plans ready for `/gsd-execute-phase 1`.

### Carry-over LOWs (planner discretion — non-blocking)

The 3 carry-over LOWs from cycle 1 (#7 popup.cpp/window.cpp existence, #8 head -20/-30 truncation, #9 SOURCES.md exact-match fragility) and the 1 new LOW (37-vs-35 scorecard row count, self-reconciled by Task 2) are flagged for planner awareness but do NOT block convergence per the cycle-2 severity bar.
