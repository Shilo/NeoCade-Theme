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
- Final design tokens (specific hex / px values; **created by Phase 3** after mockup approval; consumed by Phases 4-9): `.planning/DESIGN_TOKENS.md` (does not exist until Phase 3 closes)
- Mobile design spec (concrete mobile-vs-desktop overrides; **created by Phase 8**; consumed by Phase 9-10): `MOBILE-DESIGN-SPEC.md` (does not exist until Phase 8 closes)
- Per-phase plan (atomic task breakdown for Phase N; **created by `/gsd-plan-phase N`**): `.planning/phases/phase-N/PLAN.md`
- Per-phase verification (goal-backward audit for Phase N; **created by `/gsd-verify-work`**): `.planning/phases/phase-N/VERIFICATION.md`
- User-supplied research report (NOT source of truth — must be challenged): [.planning/inputs/NeoCade-Research-Report.md](.planning/inputs/NeoCade-Research-Report.md)
- User-supplied prototype mockup (NOT source of truth — must be challenged): [.planning/inputs/NeoCade-Theme-Prototype.png](.planning/inputs/NeoCade-Theme-Prototype.png)
- Godot project file (engine 4.6, GL Compatibility renderer, .NET enabled): [project.godot](project.godot)
- Showcase scene scaffold: [main.tscn](main.tscn)
- Theme resource scaffold: [addons/neocade_theme/neocade_theme.tres](addons/neocade_theme/neocade_theme.tres)

## GSD Workflow

Per phase, commands MUST run in order: `/gsd-discuss-phase N` → **`/gsd-plan-review-convergence N --opencode`** → `/gsd-execute-phase N` → `/gsd-verify-work` → `/clear`. No `/clear` within a phase. Auto-advance suggests the next command; user types it.

**Why `/gsd-plan-review-convergence --opencode` instead of `/gsd-plan-phase`:** Cross-AI peer review is mandatory on every phase. The user has configured (verified 2026-05-04):
- `workflow.plan_review_convergence=true` (config.json)
- `review.models.opencode="deepseek/deepseek-v4-pro"` (config.json)
- `DEEPSEEK_API_KEY` env var (set; OpenCode auto-detects)
- OpenCode CLI shim at `/c/Users/shilo/.local/bin/opencode` → forwards to `C:\Users\shilo\AppData\Local\opencode\opencade-cli.exe` v1.14.33

The convergence command auto-loops: `gsd-plan-phase` → `gsd-review --opencode` (DeepSeek V4 Pro) → if HIGH concerns → `gsd-plan-phase --reviews` → re-review → ... → converge or escalate at max-cycles=3. Never invoke plain `/gsd-plan-phase` directly — always use the convergence wrapper.

**If convergence fails:** check OpenCode shim works (`opencode --version` should print `1.14.33`), `DEEPSEEK_API_KEY` is set, and `gsd-sdk query config-get workflow.plan_review_convergence` returns `true`.

**Before any GSD command, read [.planning/STATE.md](.planning/STATE.md). If a step is skipped, REFUSE and name the missing step.** Common skips and refusal messages:

- No DISCUSS.md → "Run `/gsd-discuss-phase N` first."
- No PLAN.md / plan-checker not passed → "Run `/gsd-plan-phase N` first."
- Phase N unverified, user invokes phase N+1 → "Phase N not verified. Run `/gsd-verify-work` before advancing." **(most common skip — be vigilant)**
- Skipped `/clear` between phases → "Type `/clear` first."

**Hard-consequence verify-skips (refuse with extra emphasis):**
- Phase 3 → 4: mockup approval gate (PROJECT.md hard constraint)
- Phase 7 → 8: closes 35/35 Control coverage; gaps duplicate into mobile `.tres`
- Phase 10 → 11: ship-safety; don't publish unvalidated to Asset Library

**Recovery & special commands:** `/gsd-resume-work` (session start), `/gsd-progress` (uncertain — also use when user says "where are we"/"continue"), `/gsd-pause-work` (handoff), `/gsd-undo`, `/gsd-audit-uat`, `/gsd-ship` (after Phase 11).

**Refuse:** parallel `/gsd-*` commands (state collisions); hand-editing `.planning/*` mid-execution; `/gsd-autonomous` on this project (mockup gate + UD-1/UD-5 require user input — Phases 5-7 only with explicit user confirmation).

**Auto mode:** execute autonomously on mechanical work; do NOT auto-resolve user-decision gates (UD-1..UD-6, mockup approval, real-device confirmations); confirm destructive git actions even in auto mode.
