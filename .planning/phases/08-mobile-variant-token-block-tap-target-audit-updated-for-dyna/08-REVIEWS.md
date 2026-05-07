---
phase: 8
reviewers: [opencode]
reviewed_at: 2026-05-07T05:04:28.6230464-07:00
cycle: 1
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
**Cycle:** 1 of `/gsd-plan-review-convergence 8 --opencode --chain --auto`

---

## 1. Summary

The five-wave plan is structurally sound, mirrors the successful Phase 6/7 verifier-first pattern, and protects the locked 9-export dynamic architecture. Sequential dependencies are rational: foundation -> production hardening -> strict audit -> documentation -> scene closure. The plans collectively address all ten required REQ-IDs (MOBILE-01..08, DOCS-02, TYPEVAR-06). However, one direct requirements conflict (HeaderLarge font-size delta contradicts MOBILE-03), underspecified audit formulas, and an unresolved 13-vs-15 type-variation discrepancy will cause rework or false passes if not corrected before execution.

---

## 2. Strengths

- **Verifier-first discipline preserved:** Plan 08-01 deploys architecture invariants before any production mutation, exactly replicating the Phase 6/7 pattern that worked.
- **TDD enforcement embedded:** Plans 08-02 and 08-03 use explicit RED->GREEN cycles with the verifier asserting expected values before production code is corrected.
- **Raised/platform orthogonality is explicitly tested:** Plan 08-02 Task 3 verifies all four forced combinations (`raised x platform`), preventing the common bug where toggling one silently resets the other.
- **All five directions are in the audit path:** Plans 08-03 and 08-05 both require all-direction verification, preventing per-direction export drift from defeating the mobile contract.
- **Forbidden-resource enforcement is relentless:** Every plan cross-checks against `neocade_mobile_theme.tres`, per-density resources, root fallback `.tres`, subclasses, and `Theme.clear()` - appropriate for an architecture where drift risk is explicitly documented.
- **`MOBILE-DESIGN-SPEC.md` section requirements are well-specified:** Plan 08-04 names concrete required sections (token table, platform behavior, scorecard deltas, traceability table, limitations, handoff notes), giving the doc author a clear template.

---

## 3. Concerns

### HIGH

- **H-1: Header font-size delta contradicts MOBILE-03.** Plan 08-02 Task 1 asserts `HeaderLarge` is `36` desktop and `32` mobile - a shrink on mobile. MOBILE-03 and CONTEXT D-08 both state: "Headings retain their desktop sizes" and "title/headline values documented explicitly" (not shrunk). A heading shrinking by 4px on mobile violates the documented brand-identity rule. Either the verifier assertion is wrong, or MOBILE-03 needs updating - but both cannot coexist. This will block the `platform-tokens` stage from passing correctly.

- **H-2: Tap-target audit formulas are completely unspecified.** Plan 08-03 is a pass/fail contract plan, yet it defers all per-type formulas to implementation with only a description of intent ("Button-family: font size plus vertical stylebox content margins, with recipe constants"). A contract phase where the audit can produce false passes or false failures because formulas were guessed at implementation time creates a verification integrity risk. At minimum, the plan should codify formula categories with bounds (e.g., "Button Y proxy = max(default_font_size + content_margin_top + content_margin_bottom, tokens.buttonMin)"). Without this, a reviewer cannot assess whether `PASS` results are trustworthy.

- **H-3: Unresolved 13-vs-15 type-variation count carried forward.** CONTEXT and RESEARCH.md both flag: "The current script has 15 variation entries, while requirements still speak of 13." Plan 08-04 Task 1 says "include CodeLabel and Kicker if present in TYPE_VARIATIONS" - disclaiming rather than resolving. Plan 08-04 Task 2 likewise says "derive or check current type-variation names instead of relying on the older 13-only wording." This pushes the discrepancy into `MOBILE-DESIGN-SPEC.md`'s TYPEVAR-06 closure without a principled decision on which count is authoritative. A spec that can't state its own variation count is not a spec.

### MEDIUM

- **M-1: `web_android` / `web_ios` feature tags may not exist in Godot 4.6.** Plan 08-02 Task 2 permits `_resolve_platform()` hardening with feature tags `mobile`, `android`, `ios`, `web_android`, or `web_ios`. Godot's standard `OS.has_feature()` tags for 4.x are `mobile`, `android`, `ios`, and `web`. Tags `web_android` and `web_ios` are not standard Godot feature tags (they exist in some Godot 3.x documentation but not reliably in 4.x). Using them would silently fail, causing web-on-mobile to resolve as DESKTOP. The `web` tag + `OS.get_name()` check is the correct pattern for distinguishing web-on-mobile, but `OS.get_name()` may violate D-06's "no native platform APIs" constraint. This needs explicit resolution.

- **M-2: `main.tscn` is pre-modified before Phase 9 owns it.** Plan 08-05 writes a minimal toggle fixture into `main.tscn` and adds `scripts/phase8_platform_toggle.gd`. Phase 9 must later turn this file into the full 9-section showcase. Without a clear handoff agreement (e.g., Phase 9 replaces the entire scene, or Phase 8's toggle lives in a sub-scene), Phase 9 will either overwrite Phase 8's work or inherit dead toggle script references. The plan should either place the toggle proof in a separate scene (`test_platform_toggle.tscn`) or add an explicit "Phase 9 will replace main.tscn" clause.

- **M-3: 2048-byte size cap on direction `.tres` files is fragile.** Plan 08-01 Task 1 asserts direction `.tres` files "stay under 2048 bytes." Godot's `.tres` format serializes StyleBoxFlat entries with expanding key=value pairs - each new state variation adds dozens of bytes. A `.tres` that passes at 1900 bytes could fail at 2100 bytes after a legitimate styling addition without any architecture violation. A content-based assertion (no `[sub_resource]`, script linkage present, all 9 exports present) is durable; a byte-count assertion will produce false-positives.

- **M-4: Density-bucket verification is documented but never tested.** MOBILE-05 requires proof that one mobile theme covers all Android density buckets via Godot's `content_scale_factor` + stretch modes. Plan 08-04 says the spec must document this, but no plan actually verifies it (e.g., running the tap-target audit at `test_width=1080, test_height=1920` with a `content_scale_factor` multiplier). The audit may pass at base scale 1.0 but fail when Godot's scaling interacts with theme minimums. This is a deferred risk rather than a gap, but MOBILE-05 says Phase 8 closes it.

- **M-5: No ResourceSaver round-trip verification in Plans 08-02 or 08-03.** Plans 08-02 and 08-03 modify `neocade_theme.gd` - which changes the regeneration formulas that determine what gets written into direction `.tres` files during Theme Editor save. Plan 08-05 Task 3 mentions "if any direction-resource ResourceSaver round-trip is needed," but this should be a mandatory checkpoint in the plans that modify `neocade_theme.gd`. A formula change that produces the right runtime values but adds `[sub_resource]` to `.tres` files on save would escape detection until Phase 11 distribution.

### LOW

- **L-1: No explicit regression test for Phase 7 desktop coverage.** Plan 08-02 Task 2 modifies production code in `neocade_theme.gd`. If the mobile token corrections accidentally change desktop entries, the Phase 7 37/37 desktop coverage could silently regress. The `platform-tokens` stage should include a guard: after setting `platform=DESKTOP`, verify the resulting theme still has the same entry count as pre-modification state, or run the Phase 7 architecture subset.

- **L-2: `logs/` directory creation not specified.** Plan 08-03 commits `logs/08-tap-target-audit.log` to a new `logs/` subdirectory not mentioned in prior plans. The runner script should ensure this directory exists, but neither the runner nor the plan tasks specify `mkdir` creation.

- **L-3: Plan 08-05 Task 2 "full" verifier does not enumerate all checks.** The task describes the `full` stage as including "architecture, platform-token, tap-target, docs, scene-toggle, all-five-direction forced mobile, no-root-fallback, no-mobile-fallback, no-per-density-resource, no-subclass/per-direction-gd, no-Theme.clear, and zero-pending checks." This list is reasonable but should be in the verifier contract itself (or at minimum in the acceptance criteria), not just the task prose, so the verifier author doesn't miss any sub-check.

- **L-4: Plan 08-04 Task 1 "all 37 scorecard rows by name" - name source ambiguous.** The context references a 37-row scorecard from FEATURES.md, but the row count and exact names must match the verifier's understanding. If FEATURES.md says 37 and the verifier's scorecard array has 38 or 36, the docs stage will either incorrectly pass or incorrectly fail. The spec check should cross-reference the verifier's scorecard list, not a separately-maintained document.

---

## 4. Suggestions

- **S-1 (addresses H-1):** Align HeaderLarge verifier assertion with MOBILE-03. Either change MOBILE-03 to allow heading shrinkage on mobile (with rationale in `MOBILE-DESIGN-SPEC.md`), or change the verifier to assert `HeaderLarge == 36` on both desktop and mobile. A 36->32 heading shrink is unusual for mobile accessibility and warrants explicit justification if kept.

- **S-2 (addresses H-2):** Add a formula appendix to 08-03-PLAN.md. Codify each category's proxy formula in the plan itself, e.g.: `Button Y = tokens.buttonMin` (production constant), `LineEdit Y = tokens.inputMin`, `Tab Y = direct font_size + 2 * tapPadding`, `CheckBox Y = max(icon_size, font_size) + 2 * tapPadding`, etc. This makes the audit verifiable before implementation and prevents implementation from discovering mid-stream that 48px can't be met for certain types.

- **S-3 (addresses H-3):** Resolve 13-vs-15 before executing Plan 08-04. Make `TYPE_VARIATIONS` count authoritative and update REQUIREMENTS.md TYPEVAR-06 to match. If 15 is the new truth, the spec should document all 15. This is a one-line REQUIREMENTS.md update with low blast radius.

- **S-4 (addresses M-1):** Remove `web_android` / `web_ios` from permitted feature tags. Use only `mobile`, `android`, `ios`, `web` in `_resolve_platform()`. For `platform=AUTO` on web, `web` + `OS.get_name()` with `"Android"` or `"iOS"` as fallback (or document the limitation that web-on-mobile detection may not resolve) is more honest than referencing non-existent feature tags.

- **S-5 (addresses M-2):** Move toggle proof to `scripts/test_platform_toggle.tscn` with its own root Control, leaving `main.tscn` untouched for Phase 9. Phase 8 verifier scene-toggle stage checks the alternative scene path. This prevents Phase 9 merge friction.

- **S-6 (addresses M-3):** Remove the 2048-byte assertion. Replace with: "all direction `.tres` files contain no `[sub_resource]`, contain script_link, contain all 9 explicit exports, and serialize cleanly (load->save->reload produces bit-identical content)." This is content-correct and robust.

- **S-7 (addresses M-5):** Add a mandatory ResourceSaver round-trip check to Plan 08-02 Task 2 and Plan 08-03 Task 2 acceptance criteria: "Direction `.tres` files saved after regeneration contain no `[sub_resource]` and bit-identical reload matches."

---

## 5. Risk Assessment

**Overall Risk Level: MEDIUM**

The five-wave structure is mature and the verifier-first discipline is well-established from Phases 6-7. The dynamic architecture constraints are well-understood and consistently enforced across all plans. However, the combination of a direct requirements conflict (H-1), completely unspecified audit formulas in a contract phase (H-2), and an unresolved type-variation count (H-3) means the plans cannot execute to completion without decisions being made at implementation time - exactly what a plan should prevent. These three HIGH concerns are all resolvable with small plan amendments (not replanning), but they must be resolved before execution.

---

## Consensus Summary

This cycle used the requested single external reviewer: OpenCode with `deepseek/deepseek-v4-pro`.

### Agreed Strengths

- Single-reviewer cycle; no multi-reviewer agreement data is available.
- OpenCode found the overall five-plan structure sound and consistent with the Phase 6/7 verifier-first pattern.
- OpenCode found the forbidden-resource checks, raised/platform orthogonality checks, all-direction audit path, and `MOBILE-DESIGN-SPEC.md` section contract to be strong.

### Agreed Concerns

- Single-reviewer cycle; no 2+ reviewer consensus can be computed.
- Current unresolved HIGH concerns are H-1, H-2, and H-3 below.

### Divergent Views

- None. Only OpenCode was invoked per the `--opencode` requirement.

## Current HIGH Concerns

- **H-1:** Plan 08-02 Task 1 asserts `HeaderLarge` shrinks from 36px to 32px on mobile, directly contradicting MOBILE-03 / D-08 ("headings retain their desktop sizes"). Both cannot be true; one must change before execution.
- **H-2:** Plan 08-03 provides no per-type tap-target proxy formulas - all 37-row formula logic is deferred to implementation. A contract phase whose pass/fail audit has unspecified formulas cannot be meaningfully reviewed or trusted.
- **H-3:** The 13-vs-15 type-variation count discrepancy is acknowledged but deferred across plans 08-03 and 08-04 without a resolution decision. TYPEVAR-06 cannot be "finalized" from an unresolved count.
