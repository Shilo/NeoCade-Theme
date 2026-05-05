# NeoCade Theme

A Godot 4.6 native UI Theme **system**, distributed as a drop-in addon, that styles every built-in Control with a **flat Material Design 3 / MD3 Expressive aesthetic** — modern, colorful, expressive, accessibility-first, with optional "extruded flat 3D" raised variation per the Flat-3D Game UI pattern. Universal across the Godot Editor and game runtime, and across all 6 Godot export targets (Windows, macOS, Linux, iOS, Android, Web/Browser). **Architecture (locked 2026-05-04):** `class_name NeoCadeTheme extends Theme` (`@tool`) superclass with `@export` properties — `base_color`, `accent_color`, `raised: bool`, `platform: {DESKTOP, MOBILE, AUTO}`. Setters dynamically regenerate all theme entries via `_get_base_color`-style formulas. Per-theme subclasses (e.g., `PrizePopPlazaNeoCadeTheme`) contribute personality (shape language, outline widths, color tint formulas). **v1 ships N user-approved theme subclass `.tres` files (one per theme; consumer toggles exports for variations).** `platform=AUTO` auto-detects via `OS.has_feature("mobile")` at runtime; `DESKTOP`/`MOBILE` are forced sizes. Architecture supports undefined number of themes; light mode and alternate palettes are explicit v2 work but plug in as new subclasses.

The theme is built primarily to power the author's upcoming game (codename: VirtuCade) — a 2D tile-based pixel-art online multiplayer game set inside a large interior arcade environment with interactive booths and mini-games — but is designed as a standalone, reusable addon for the Godot community. **The theme name is NeoCade**; VirtuCade is the consuming game, not the theme.

**Visual identity LOCKED 2026-05-04 (Phase 3 redirect):** Flat MD3 / MD3 Expressive language. **Hard rules: no textures, no patterns, no embossing, no painterly/leather/wood/grunge backgrounds, no gradients on chrome.** Solid colors + offset darker shape duplicates for depth on the raised variation only (extruded-flat). Anti-cyberpunk discipline preserved (no synthwave / no neon-noir / no dystopian). HD-only — no pixel art in the theme itself, even though the consuming game is pixel art. References: [hcgamestudios.itch.io flat-game-ui-for-mobile-games](https://hcgamestudios.itch.io/flat-game-ui-for-mobile-games), [fajrulaslim.itch.io UI Button Flat Design](https://fajrulaslim.itch.io/ui-button-flat-design). The earlier "neo/neon arcade hall by day" framing is **historical** — see Phase 3 redirect notes in `.planning/phases/03-visual-direction-mockup-approval-gate/REDIRECTED.md`.

**Core deliverable:** `res://addons/neocade_theme/themes/{theme}_neocade_theme.tres` per approved theme (e.g., `prize_pop_plaza_neocade_theme.tres` extending `PrizePopPlazaNeoCadeTheme`). Each subclass `.tres` must be feature-complete to `godot-minimal-theme`'s bar — every one of the 35 user-facing Godot 4.6 Control classes themed across every state, with all four export-state configurations (flat × raised × desktop × mobile) regenerating correctly when consumer toggles exports. v1 file count is `N` where N = approved theme count (typical 1-3 for v1). Approved at Phase 3.3 gate (the renumbered mockup phase; was 3.2 before architecture revision).

# Progressive Discovery

Read these files when the topic is relevant. Do not duplicate or summarize their contents here.

- Hard constraints + Research Charter + Source Coverage commitment: [.planning/PROJECT.md](.planning/PROJECT.md)
- v1 requirements (99 REQ-IDs across 15 categories) + traceability: [.planning/REQUIREMENTS.md](.planning/REQUIREMENTS.md)
- 14-phase roadmap with goals + success criteria + cumulative reqs (Phase 3 REDIRECTED 2026-05-04 → Phase 3.1 + 3.2 + 3.3 inserted; architecture revised 2026-05-04 → NeoCadeTheme superclass + per-theme subclasses): [.planning/ROADMAP.md](.planning/ROADMAP.md)
- Current project state + active phase + open user decisions: [.planning/STATE.md](.planning/STATE.md)
- Workflow config (mode, granularity, model profile, agent toggles): [.planning/config.json](.planning/config.json)
- Research synthesis + 3 conflict resolutions + UD-1..6 + 11-phase rationale: [.planning/research/SUMMARY.md](.planning/research/SUMMARY.md)
- Per-source dossier (10 sources, adopt/reject/open per source): [.planning/research/SOURCES.md](.planning/research/SOURCES.md)
- Independent review findings (4 CRIT + 7 MAJ + 5 MIN, all reconciled): [.planning/research/REVIEW-INDEPENDENT.md](.planning/research/REVIEW-INDEPENDENT.md)
- Technology stack + addon layout + 5 locked decisions: [.planning/research/STACK.md](.planning/research/STACK.md)
- 35-class Control coverage matrix + 13 type variations + anti-features: [.planning/research/FEATURES.md](.planning/research/FEATURES.md)
- Visual design system + 3 palette options + M3 type scale + state model (HISTORICAL — `§1 palette proposals` superseded by Phase 3 redirect; `§3-§5 type scale + state model` carry forward to MD3-RESEARCH.md): [.planning/research/ARCHITECTURE.md](.planning/research/ARCHITECTURE.md)
- **MD3 + MD3 Expressive design language** (created by Phase 3.1; consumed by Phase 3.3 mockups + Phase 4-7): `.planning/research/MD3-RESEARCH.md` (does not exist until Phase 3.1 closes)
- **Flat-3D Game UI / Extruded Flat UI patterns** + Godot StyleBoxFlat translation recipes (created by Phase 3.1; consumed by Phase 3.3 raised variation + Phase 4-7): `.planning/research/FLAT-3D-UI-RESEARCH.md` (does not exist until Phase 3.1 closes)
- **Godot Dynamic Theme Architecture** + feasibility validation (created by Phase 3.2; consumed by Phase 3.3 mockups + Phase 4 NeoCadeTheme implementation): `.planning/research/GODOT-DYNAMIC-THEME-RESEARCH.md` + `.planning/spikes/dynamic-theme/` (do not exist until Phase 3.2 closes)
- **Phase 3 v0 redirect notes** + user feedback log per direction (MUST READ when working on Phase 3.3 or revisiting any v0 direction): [.planning/phases/03-visual-direction-mockup-approval-gate/REDIRECTED.md](.planning/phases/03-visual-direction-mockup-approval-gate/REDIRECTED.md)
- 10 categories of pitfalls + prevention checklists + phase mapping: [.planning/research/PITFALLS.md](.planning/research/PITFALLS.md)
- Cross-platform export specs + mobile variant deltas + token-sharing strategy: [.planning/research/CROSS-PLATFORM.md](.planning/research/CROSS-PLATFORM.md)
- Editor surfaces themed in v1 vs default-fallback: [.planning/research/EDITOR-COVERAGE.md](.planning/research/EDITOR-COVERAGE.md)
- Final design tokens — **subclass-recipe-oriented** (per-theme: class_name + default colors + personality overrides; per-variation: flat/raised/desktop/mobile/AUTO override blocks); **created by Phase 3.3** after mockup approval; consumed by Phase 4 `NeoCadeTheme` implementation + Phases 5-9: `.planning/DESIGN_TOKENS.md` (does not exist until Phase 3.3 closes)
- Mobile design spec (concrete mobile-vs-desktop overrides; **created by Phase 8**; consumed by Phase 9-10): `MOBILE-DESIGN-SPEC.md` (does not exist until Phase 8 closes)
- Per-phase plan (atomic task breakdown for Phase N; **created by `/gsd-plan-phase N`**): `.planning/phases/phase-N/PLAN.md`
- Per-phase verification (goal-backward audit for Phase N; **created by `/gsd-verify-work`**): `.planning/phases/phase-N/VERIFICATION.md`
- User-supplied research report (NOT source of truth — must be challenged): [.planning/inputs/NeoCade-Research-Report.md](.planning/inputs/NeoCade-Research-Report.md)
- User-supplied prototype mockup (NOT source of truth — must be challenged): [.planning/inputs/NeoCade-Theme-Prototype.png](.planning/inputs/NeoCade-Theme-Prototype.png)
- Godot project file (engine 4.6, GL Compatibility renderer, .NET enabled): [project.godot](project.godot)
- Showcase scene scaffold: [main.tscn](main.tscn)
- Theme resource scaffold: [addons/neocade_theme/neocade_theme.tres](addons/neocade_theme/neocade_theme.tres)

# GSD Workflow

Per phase, commands MUST run in order: `/gsd-discuss-phase N` → **`/gsd-plan-review-convergence N --opencode`** → `/gsd-execute-phase N` → `/gsd-verify-work` → `/clear`. **No `/clear` within a phase.** Auto-advance suggests the next command; user types it.

**`/clear` rule (project-specific override of GSD default):** clear ONLY at phase boundaries — after `/gsd-verify-work` of phase N, before `/gsd-discuss-phase N+1`. NOT between discuss → plan, plan → execute, or execute → verify within the same phase. Reason: DISCUSS.md captures structured outcomes but not every conversational nuance (subtle clarifications, "yeah but really X" moments, edge cases noticed mid-discuss). Those nuances inform the next command's subagent quality. Context bloat is the lesser cost. **If auto-advance suggests `/clear` between within-phase commands, IGNORE it for this project.**

**Never invoke plain `/gsd-plan-phase` or plain `/gsd-review` directly** — both are wrapped inside `/gsd-plan-review-convergence`. Running them separately duplicates work and risks state desync.

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
