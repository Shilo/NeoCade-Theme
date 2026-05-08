---
status: ready
authorized_at: 2026-05-07
authorized_for: [6, 7, 8]
authorized_by: user (Shilo)
override: CLAUDE.md "Refuse /gsd-autonomous" rule, scope-limited to Phases 6-8
created_at_head: 6939b3e
---

# Handoff — Autonomous Chain for Phases 6, 7, 8

This document hands off Phase 5 → Phase 6 with permission to chain Phases 6, 7, and 8
end-to-end without further interactive prompts. Phase 9 (showcase scene + theme picker)
still requires user visual approval — the chain stops there.

## What's done before this handoff (Phase 5 close state)

- HEAD: `6939b3e` (`docs(05): STATE.md -- Phase 5 verified, sanctioned to advance to Phase 6`)
- Phase 5 verified: `05-VERIFICATION.md` verdict `VERIFIED-WITH-DEFERRED-ITEMS` (5/5 ROADMAP success criteria; 28/28 verifier strict groups OK; 50/50 focus slots OK; 7/7 plan SUMMARYs committed; 0 gaps; 11 deferred items routed to Phase 6/7/8/9/10).
- Headless verifier passes 8/8 stages: tooling, shape, buttons, text-panels, text-final, spinbox, final, strict.
- 5 direction `.tres` files data-only at 331-373 bytes each; D-06 invariant met.
- Phase 4 LSP type-inference fix landed at `c3e0690` (typed `path: String`).

## Settings changed for autonomy

`.planning/config.json`:
- `workflow.discuss_mode: "quick"` (was `"discuss"`) — defaults answers to non-blocking questions; only asks user on hard decisions.
- `workflow.use_worktrees: false` (new) — Wave 4 of Phase 5 hit a worktree base mismatch; sequential mode on main is more reliable.
- `workflow._phases_6_8_autonomous_authorized` marker — records the override.

`CLAUDE.md`:
- Refuse rule scoped to Phase 9+ instead of all-phases.
- Autonomy override block added for Phases 6-8.

## How to invoke

### Option A — Single command (recommended)

Open a fresh Claude Code session (`/clear` first) and type:

```
/gsd-autonomous
```

The skill will read CLAUDE.md, see the scoped authorization, run discuss → plan-review-convergence → execute → verify for Phase 6, advance to Phase 7, repeat, advance to Phase 8, repeat. **Stop the chain manually after Phase 8 verify-work commits** — do NOT let it continue into Phase 9 (visual approval gate).

If `/gsd-autonomous` does NOT honor the scope marker and tries to push past Phase 8, abort with `Ctrl+C` and switch to Option B.

### Option B — Sequential per-phase commands

For each phase in `[6, 7, 8]`, invoke this 4-step sequence in a fresh session:

```
/gsd-discuss-phase {N}
/gsd-plan-review-convergence {N} --opencode
/gsd-execute-phase {N}
/gsd-verify-work {N}
/clear
```

After Phase 8's `/gsd-verify-work 8` commits VERIFICATION.md, **stop**. Phase 9 starts with manual `/gsd-discuss-phase 9` — the showcase scene needs your visual approval throughout.

### Option C — Mid-stream resume after a usage limit

If the chain halts mid-phase (org usage limit, network failure, etc.):

1. Open a fresh session, run `git status` and `git log --oneline -10` to see how far it got.
2. Find the last completed phase artifact: look for `{phase}-SUMMARY.md`, `{phase}-UAT.md`, `{phase}-VERIFICATION.md` files.
3. Resume from the next missing artifact:
   - No DISCUSS.md → `/gsd-discuss-phase {N}`
   - DISCUSS.md present, no PLAN.md → `/gsd-plan-review-convergence {N} --opencode`
   - PLAN.md present, no SUMMARYs → `/gsd-execute-phase {N}`
   - All SUMMARYs but no VERIFICATION.md → `/gsd-verify-work {N}`
   - VERIFICATION.md present → `/clear`, then `/gsd-discuss-phase {N+1}`

`/gsd-resume-work` may also detect state and route correctly.

## Phase scope quick-reference (read for context, do NOT plan from this — the discuss step does that)

### Phase 6 — Lists, Layout, Range (5 plans pre-defined in ROADMAP)
**Goal:** desktop chrome for Tree (16 styleboxes/12 icons/~26 constants), ItemList, TabBar/TabContainer, FoldableContainer, range controls (HSlider/VSlider/ProgressBar/HScrollBar/VScrollBar), container chrome (ScrollContainer/SplitContainer/MarginContainer + layout-only `separation` constants).
**Requirements:** COV-04, COV-05; cumulative contributors COV-01, COV-07, COV-09, TYPEVAR-06.
**Plans (pre-listed):**
- 06-01 — Freeze Godot 4.6.2 slots + Phase 6 verifier/ResourceSaver helpers.
- 06-02 — Tree (heaviest single class).
- 06-03 — ItemList + FoldableContainer.
- 06-04 — TabBar + TabContainer.
- 06-05 — Range controls + container chrome + ResourceSaver round-trip.

### Phase 7 — Dialogs, Popups, Advanced (TBD plan count)
**Goal:** popup-class as FIRST-CLASS theme types (Pitfall 1.7) — PopupPanel, PopupMenu, AcceptDialog, ConfirmationDialog, FileDialog, TooltipPanel, TooltipLabel, Window. Plus MenuBar, ColorPicker (16 bespoke icons), GraphEdit/GraphNode/GraphFrame. **Closes 37/37 desktop COV-01 100%.**
**Requirements:** COV-06, COV-08; closes COV-01, COV-07, COV-09.

### Phase 8 — Mobile Variant Token Block + Tap-Target Audit (TBD plan count)
**Goal:** Fill in `_resolve_platform()=MOBILE` branch in `_regenerate_theme()` so any direction `.tres` with `platform=MOBILE` produces correctly sized mobile entries (button heights → 48px floor, body text 16px, +50% spacing scale on `space.4`+, corner radii UNCHANGED across desktop/mobile per brand-identity rule). Tap-target audit script asserts ≥48px on every interactive Control. `.planning/MOBILE-DESIGN-SPEC.md` committed.
**Requirements:** MOBILE-01..08, DOCS-02, TYPEVAR-06.

## Risk callouts

1. **Usage limits.** We hit the org's monthly cap once during Phase 5 Wave 2. Each unattended phase is ~3-6 hours of executor wall time. Plan accordingly — start the chain with margin in your usage budget. If interrupted, resume per Option C.

2. **Plan quality without user clarification.** `discuss_mode: "quick"` defaults non-blocking ambiguity but cannot read your mind on edge cases. If a phase produces lower-quality artifacts than Phase 5, you can `/gsd-undo` and re-run with full `discuss_mode`.

3. **Cross-AI peer review HIGH concerns.** `/gsd-plan-review-convergence` iterates up to 3 cycles; if HIGH concerns persist after cycle 3, the convergence command escalates. In autonomous mode, the orchestrator should accept the cycle-3 plan and proceed; this is a known trade-off.

4. **Worktree base mismatch is fixed.** `workflow.use_worktrees: false` means executors run sequentially on main. This is slower than parallel worktrees but eliminates the Wave 4 base-mismatch class of bug.

5. **Out-of-scope addon `.tres` drift.** Godot's `--headless --import` rewrites `addons/neocade_theme/*_neocade_theme.tres` and `showcase/showcase.tscn` (UID stabilization + serialized theme entries). The Phase 5 pattern is: only the final ResourceSaver-round-trip plan (e.g., 06-05, the equivalent in Phase 7, and Phase 8's mobile-emit plan) commits those changes; all earlier plans must `git checkout -- <path>` any drift before staging. The executor agent prompts already include this warning.

6. **STATE.md / ROADMAP.md are orchestrator-owned.** Executor subagents must NOT modify them — only the orchestrator does after each plan completes. This is enforced in the executor prompts.

7. **Phase 9 is the hard stop.** Phase 9 (showcase scene + theme picker + variation toggles) requires your visual approval. The autonomy authorization in CLAUDE.md does NOT extend past Phase 8. After Phase 8 verifies, manually `/clear` and `/gsd-discuss-phase 9` to start the visual phase with full user oversight.

## What you do after this handoff

1. `/clear` (sanctioned at phase boundary).
2. Either `/gsd-autonomous` (Option A) or the first command in Option B (`/gsd-discuss-phase 6`).
3. Walk away or check back in 3-6 hours per phase.
4. Resume per Option C if interrupted.
5. After Phase 8 verifies cleanly, manually start Phase 9 with `/gsd-discuss-phase 9` (visual gate).

## What you do NOT do

- Do NOT run `/gsd-autonomous` past Phase 8 — Phase 9 is a visual gate.
- Do NOT manually edit `.planning/*` files mid-chain (CLAUDE.md "Refuse" still applies).
- Do NOT skip `/gsd-verify-work {N}` between phases — STATE.md sequencing guard refuses advance without VERIFICATION.md.
- Do NOT run multiple `/gsd-*` commands in parallel sessions — state collisions.

## Reverting the autonomy override

If you want to restore the original behavior:

```bash
gsd-sdk query config-set workflow.discuss_mode "discuss"
gsd-sdk query config-set workflow.use_worktrees "true"
gsd-sdk query config-set workflow._phases_6_8_autonomous_authorized null
```

And in `CLAUDE.md`, replace the **Autonomy override** block with the original
**Refuse** wording (see `git log -p CLAUDE.md` to find the pre-handoff version).
