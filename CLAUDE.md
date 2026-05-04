# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

**NeoCade Theme** — a Godot 4.6 native UI Theme resource, distributed as a drop-in addon, that styles every built-in Control with a polished neo/neon arcade aesthetic — modern, colorful, professional, accessibility-first. Universal across the Godot Editor and game runtime, and across all 6 Godot export targets (Windows, macOS, Linux, iOS, Android, Web/Browser). v1 ships a dark desktop theme PLUS a mobile-tuned variant alongside (sharing one TokenSet, generated via `@tool` script). Light mode and alternate palettes are explicit v2 work.

The theme is built primarily to power the author's upcoming game (codename: VirtuCade) — a 2D tile-based pixel-art online multiplayer game set inside a large interior arcade environment with interactive booths and mini-games — but is designed as a standalone, reusable addon for the Godot community. **The theme name is NeoCade**; VirtuCade is the consuming game, not the theme. Aesthetic is "vibrant arcade hall by day," explicitly NOT cyberpunk/synthwave/neon-noir/dystopian. HD-only — no pixel art in the theme itself, even though the consuming game is pixel art.

**Core deliverable:** `res://addons/neocade_theme/neocade_theme.tres` (desktop) + `res://addons/neocade_theme/neocade_mobile_theme.tres` (mobile). Both must be feature-complete to `godot-minimal-theme`'s bar — every one of the 35 user-facing Godot 4.6 Control classes themed across every state.

## Progressive Discovery

Read these files when the topic is relevant. Do not duplicate or summarize their contents here.

- Hard constraints + Research Charter + Source Coverage commitment: [.planning/PROJECT.md](.planning/PROJECT.md)
- v1 requirements (99 REQ-IDs across 15 categories) + traceability: [.planning/REQUIREMENTS.md](.planning/REQUIREMENTS.md)
- 11-phase roadmap with goals + success criteria + cumulative reqs: [.planning/ROADMAP.md](.planning/ROADMAP.md)
- Current project state + active phase + open user decisions: [.planning/STATE.md](.planning/STATE.md)
- Workflow config (mode, granularity, model profile, agent toggles): [.planning/config.json](.planning/config.json)
- Research synthesis + 3 conflict resolutions + UD-1..6 + 11-phase rationale: [.planning/research/SUMMARY.md](.planning/research/SUMMARY.md)
- Per-source dossier (10 sources, adopt/reject/open per source): [.planning/research/SOURCES.md](.planning/research/SOURCES.md)
- Independent review findings (4 CRIT + 7 MAJ + 5 MIN, all reconciled): [.planning/research/REVIEW-INDEPENDENT.md](.planning/research/REVIEW-INDEPENDENT.md)
- Technology stack + addon layout + 5 locked decisions: [.planning/research/STACK.md](.planning/research/STACK.md)
- 35-class Control coverage matrix + 13 type variations + anti-features: [.planning/research/FEATURES.md](.planning/research/FEATURES.md)
- Visual design system + 3 palette options + M3 type scale + state model: [.planning/research/ARCHITECTURE.md](.planning/research/ARCHITECTURE.md)
- 10 categories of pitfalls + prevention checklists + phase mapping: [.planning/research/PITFALLS.md](.planning/research/PITFALLS.md)
- Cross-platform export specs + mobile variant deltas + token-sharing strategy: [.planning/research/CROSS-PLATFORM.md](.planning/research/CROSS-PLATFORM.md)
- Editor surfaces themed in v1 vs default-fallback: [.planning/research/EDITOR-COVERAGE.md](.planning/research/EDITOR-COVERAGE.md)
- User-supplied research report (NOT source of truth — must be challenged): [.planning/inputs/NeoCade-Research-Report.md](.planning/inputs/NeoCade-Research-Report.md)
- User-supplied prototype mockup (NOT source of truth — must be challenged): [.planning/inputs/NeoCade-Theme-Prototype.png](.planning/inputs/NeoCade-Theme-Prototype.png)
- Godot project file (engine 4.6, GL Compatibility renderer, .NET enabled): [project.godot](project.godot)
- Showcase scene scaffold: [main.tscn](main.tscn)
- Theme resource scaffold: [addons/neocade_theme/neocade_theme.tres](addons/neocade_theme/neocade_theme.tres)

## GSD Workflow — Mandatory Per-Phase Order

This project uses the GSD (Get Shit Done) workflow. The user's working preference (per [config.json](.planning/config.json)) is `mode: yolo` (auto-approve) with `auto_advance: true`, `plan_check: true`, `verifier: true`, `code_review: true`. Per phase, GSD commands MUST run in this exact order:

```
1. /gsd-discuss-phase N      — gather context; surface ambiguity; read phase reqs
2. /gsd-plan-phase N         — write PLAN.md (auto-runs plan-checker)
3. /gsd-execute-phase N      — execute plans (atomic commits)
4. /gsd-verify-work          — verify phase goal achieved (writes VERIFICATION.md, closes phase)
5. /clear                    — clear ONLY at phase boundary (NOT between commands within a phase)
```

After step 4, auto-advance will SUGGEST the next-phase command. The user types it after `/clear`. Do NOT auto-execute the next phase without `/clear` and explicit user invocation.

### Enforcement: Block On Skip — Required Behavior

When the user invokes a GSD command, you MUST verify the workflow state in [.planning/STATE.md](.planning/STATE.md) before letting it proceed. If a step has been skipped, REFUSE the command and direct the user to the missing step. Specifically:

- **User runs `/gsd-plan-phase N` but Phase N has no committed `DISCUSS.md`.** Refuse: "Phase N has not been discussed. Run `/gsd-discuss-phase N` first." Read STATE.md to confirm phase status before refusing.
- **User runs `/gsd-execute-phase N` but Phase N has no committed `PLAN.md` or plan-checker has not passed.** Refuse: "Phase N has no committed plan (or plan-checker has not passed). Run `/gsd-plan-phase N` first."
- **User runs any next-phase command (e.g. `/gsd-discuss-phase N+1`, `/gsd-plan-phase N+1`) while STATE.md shows phase N as unverified.** Refuse: "Phase N is not verified. Run `/gsd-verify-work` before advancing." **This is the most common accidental skip — be vigilant.**
- **User skipped `/clear` between phases (consecutive `/gsd-*` commands at different phase numbers in the same context window).** Warn: "You skipped `/clear` between phase N and phase N+1. Context bloat will degrade subagent quality. Type `/clear` and re-run." Refuse the next-phase command until they do.

How to detect skips:
1. Read [.planning/STATE.md](.planning/STATE.md) — current phase, last completed step, verification status.
2. Cross-check against [.planning/ROADMAP.md](.planning/ROADMAP.md) "Progress" table.
3. If STATE.md is ambiguous, run `/gsd-progress` (it self-diagnoses) before refusing or proceeding.

### Critical Phase Boundaries — Verify-Skip Has Hard Consequences

For these three transitions, skipping `/gsd-verify-work` is NOT just inconvenient — it has hard data-integrity or ship-safety consequences. If STATE.md shows any of these unverified and the user attempts to advance, REFUSE with emphasis:

- **Phase 3 → 4 (mockup approval gate).** PROJECT.md hard constraint. No `.tres` styling commits permitted before Step 3 user-logged approval is verified. Skipping means Phase 4 starts authoring the theme against an unapproved design — direct PROJECT.md violation.
- **Phase 7 → 8 (closes cumulative COV-01: 35/35 Control coverage).** Skipping means Phase 8 mobile-variant authoring duplicates any Phase 7 desktop coverage gaps into the mobile `.tres`. The token-sharing generator does not detect missing entries — only verify does.
- **Phase 10 → 11 (QA + cross-platform export validation gate).** Skipping means publishing an unvalidated theme to Asset Library. Reputational + recall cost. Phase 11 must not start until Phase 10 verification is logged.

For other phases (1, 2, 4, 5, 6, 8, 9), skip is recoverable via `/gsd-progress` or `/gsd-audit-uat`, but still refuse forward motion until verify runs.

### Within-Phase Clearing

Do NOT `/clear` between discuss → plan → execute → verify within the same phase. Conversational context (user clarifications, edge cases noticed in discuss) informs the next step. Artifacts persist via committed files, but in-context reasoning produces tighter results downstream. Clear ONLY at phase boundaries (after `/gsd-verify-work`, before the next phase's `/gsd-discuss-phase`).

### When The User Is Lost

If the user types something like "where are we", "what's next", "continue", or any ambiguous status query:
1. Read [.planning/STATE.md](.planning/STATE.md).
2. Run `/gsd-progress` (it reads STATE.md and recommends the next correct command).
3. Echo the recommendation. Do not improvise a different command.

### Recovery Commands (use when needed)

- `/gsd-resume-work` — start of every session; restores context from STATE.md
- `/gsd-progress` — any time uncertain; tells you next correct step
- `/gsd-pause-work` — before stopping mid-phase; writes a handoff
- `/gsd-debug` — for bugs spanning multiple turns
- `/gsd-undo` — roll back a phase or plan if direction was wrong
- `/gsd-audit-uat` — cross-phase audit if multiple verifies were skipped
- `/gsd-ship` — AFTER Phase 11 verifies; creates PR + final review

### Anti-Patterns To Refuse

- Multiple `/gsd-*` commands in parallel (they share state files in `.planning/`; will collide).
- Editing `.planning/*` files by hand mid-execution (let GSD agents update them through their commands; manual edits desync STATE.md).
- Running `/gsd-autonomous` on this project. The mockup approval gate (Phase 3 → 4) and open user decisions (UD-1 MCP swap, UD-5 real-device test confirmation) require user input — autonomous would steamroll. Acceptable ONLY for Phases 5-7 (pure desktop authoring, low ambiguity) and only after explicit user confirmation.
- `/gsd-execute-phase` without committing the previous phase's verification.
- Re-authoring research without `/gsd-progress` confirming why.

## Auto-Mode Behavior

When the harness signals auto mode in a session:
- Execute autonomously where the workflow has a clear next step.
- Do NOT auto-resolve user-decision gates (UD-1..UD-6 in [SUMMARY.md](.planning/research/SUMMARY.md), mockup approval, real-device test confirmations). Auto mode means "do the obvious mechanical work without asking" — it does NOT mean "fabricate user approval."
- For destructive actions (git reset --hard, force-push, deleting branches, dropping data), still confirm even in auto mode.
- Auto-advance (config) suggests the next command after each step. The user types it. Do not chain past `/clear` boundaries automatically.
