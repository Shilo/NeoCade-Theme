# Phase 3.4 Closeout — Visual Direction (Flat / Extruded-Flat) Mockup + Approval Gate

**Closeout authored:** 2026-05-06 (Plan 04 Task 1 → Task 4)
**Phase:** 03.4-visual-direction-flat-extruded-flat-mockup-approval-gate
**Status:** CLOSED — all gates passed; Phase 4 unblocked once `/gsd-verify-work` confirms.
**Approved final themes:** Pulse, Slate, Bubble, Daybreak, Burst (all 5 ship as data-only `.tres` peers).
**Recommended starter:** Pulse (showcase scene default + README "try this first" suggestion only — no architectural privilege).
**Architecture:** Single concrete `NeoCadeTheme` class + 5 data-only `.tres` peers (CORRECTIVE-ADDENDUM D-31, finalized 2026-05-06f).

---

## Section 1 — Final approval prerequisite (Plan 04 Task 1)

Plan 04 Task 1 mandates: confirm `.planning/mockups/3.4/final-approval.md` exists and records (a) at least one approved final theme, (b) exactly one recommended starter direction, (c) approval date, and (d) relationship to `NeoCadeTheme`. If any are missing, halt with `## CHECKPOINT REACHED`.

### Verification result: PASS

| Required marker | Source line in `final-approval.md` | Result |
|---|---|---|
| At least one approved final theme | §"Approved final themes" — table lists Pulse, Slate, Bubble, Daybreak, Burst with WCAG and ship status | PRESENT (5 themes) |
| Exactly one recommended starter direction | §"Base direction" — "Pulse — the v1 recommended starter direction. Confirmed by user 2026-05-06" | PRESENT (Pulse) |
| Approval date | §"Approval date" — "2026-05-06" | PRESENT |
| Relationship to `NeoCadeTheme` | §"Phase 4 prerequisite" — "single concrete `NeoCadeTheme` class will live at `addons/neocade_theme/neocade_theme.gd`" + 9-property `@export` set | PRESENT |

### Approval gate provenance

- **Approval date:** 2026-05-06.
- **Approved by:** User (project owner) at the Phase 3.4 Plan 03 Task 4 user-decision gate.
- **Selection kind:** `all-five-ship + recommended-starter` — every Phase 3.3 candidate was approved for v1 ship, with Pulse separately picked as the v1 recommended-starter (showcase default + README suggestion).
- **Gate file:** `.planning/mockups/3.4/final-approval.md` (frontmatter `gate: phase-3.4-plan-03-task-4`, `status: closed`).
- **Architectural framing:** D-31 reframed the historic D-16/D-17 "base direction" pick as "recommended starter" — values do NOT bake into class defaults; the picked direction is purely a soft commitment to (1) preload as the showcase scene's project theme and (2) name in the addon README's "try this first" suggestion. All 5 directions ship as peer data-only `.tres` files.
- **Forward-compat is_light demo:** Override C (`pulse-finalist-override-light.png`) added at user request demonstrates the architecture's `is_light = base_color.get_luminance() >= 0.5` flag flips text/surface/state-hover correctly. Light mode itself remains v2 (PROJECT.md Out of Scope); the wiring is documented in DESIGN_TOKENS.md as forward-compat work and Phase 4's `addons/neocade_theme/neocade_theme.gd` MUST carry the same branch into GDScript.

### Plan 04 unblocked

Final approval prerequisite is **complete**. Plan 04 Tasks 2-4 may proceed:
- Task 2 — write `.planning/DESIGN_TOKENS.md` (single-class / data-resource contract). **DONE** (commit 1bd4f7c).
- Task 3 — Phase 3.4 success-criteria audit + decisions D-01..D-27 cross-reference (this file, §3 below).
- Task 4 — forbidden-surface and Phase 4 handoff audit (this file, §4 below).

---

## Section 2 — DESIGN_TOKENS.md authored (Plan 04 Task 2)

`.planning/DESIGN_TOKENS.md` was written in Plan 04 Task 2 (commit `1bd4f7c`) as the single-class/data-resource Phase 4 contract. Twelve sections per the plan's `<interfaces>` requirement:

1. Provenance and approval gate
2. Approved final themes (5 directions with palettes + WCAG)
3. Recommended starter designation (Pulse, D-31 reframing)
4. Shared `NeoCadeTheme` class contract (9 `@export` properties; `is_light` derivation)
5. Per-theme data-resource recipes (one block per direction)
6. Color formula and surface ramp contract (`mix` + `tintTowardBase` + `is_light` flip)
7. Accent, semantic role, and state-layer contract (M3 deterministic; Pitfall 1.1)
8. Shape, outline, spacing, and typography contract (Inter Variable Roman ONLY)
9. Flat/raised variation contract (StyleBoxFlat patterns)
10. Desktop/mobile/AUTO variation contract (PLATFORM_TOKENS + AUTO resolution)
11. Accessibility and anti-texture rules
12. Phase 4 implementation handoff (file create/delete/forbid lists)

PowerShell verification PASS — all 15 required marker strings found as literals.

---

## Section 3 — Phase 3.4 success-criteria audit (Plan 04 Task 3)

Cross-references all seven ROADMAP Phase 3.4 success criteria (numbered SC-01..SC-07 here for stable reference) and the canonical decisions D-01..D-27 from `03.4-CONTEXT.md` (with notes where D-28..D-31 from `03.4-CORRECTIVE-ADDENDUM.md` superseded an original decision).

### 3.1 ROADMAP success-criteria audit (SC-01..SC-07)

The seven items below mirror ROADMAP.md Phase 3.4 § "Success Criteria" bullets (lines 165-172) in order. Numbered as SC-01 through SC-07 for traceability.

| ID | Success criterion (ROADMAP, abbreviated) | Status | Evidence |
|---|---|---|---|
| **SC-01** | 5 directions mocked up using Phase 3.3's approved names + palettes + personalities. Phase 3.4 does not invent new directions. Direction resource files use snake case (`pulse_neocade_theme.tres`, etc.); no per-direction `.gd` classes. | **PASS** | All 5 directions (Pulse, Slate, Bubble, Daybreak, Burst) rendered at Stage 1 + Pulse at full-fidelity 4-grid; identity/palette preserved per `THEME-DIRECTIONS.md` Revision Round 2/2; `data/directions.json` `tres_filename_stem` fields use snake_case (`pulse_neocade_theme`, `slate_neocade_theme`, etc.); no per-direction `.gd` files exist (D-31 single-concrete-class architecture). DESIGN_TOKENS.md §5 codifies snake-case `.tres` filenames. |
| **SC-02** | Step 1 — Concept boards: each of the 5 directions produces 3 rendered concept variants (`desktop-flat`, `mobile-flat`, `mobile-raised`) → **15 concept PNGs total** (a logical 10 concept boards matrix expanded to 15 PNGs to capture the raised-vs-flat × desktop-vs-mobile cells). User selected Pulse as recommended-starter / implementation-priority finalist; other four directions remain v1 variations. | **PASS** | 15 PNGs in `.planning/mockups/3.4/concepts/{pulse,slate,bubble,daybreak,burst}-{desktop-flat,mobile-flat,mobile-raised}.png` rendered via `node render.js concept-images`; finalist selection recorded in `finalist-selection.md` (gate-closed 2026-05-06 with `selection_kind: recommended-starter` selecting Pulse); other 4 directions retained for v1 ship per `final-approval.md`. |
| **SC-03** | Step 2 — Finalist full-fidelity mockups (4-grid): Pulse rendered in 4-grid (top-left raised=false/DESKTOP, top-right raised=false/MOBILE, bottom-left raised=true/DESKTOP, bottom-right raised=true/MOBILE) plus a `base_color` / `accent_color` override row. All four cells share one `NeoCadeTheme` data resource contract. Every Control × every state combination demonstrated, including Pitfall 1.1's `pressed_focus`, `checked_focus`, `hover_pressed`. | **PASS** | 4 PNGs (`pulse-finalist-{desktop,mobile}-{flat,raised}.png`) + 3 override PNGs (`pulse-finalist-override-{warm,ocean,light}.png`) rendered. `finalist-gallery.html` embeds the 4-grid + override row + 40-Control coverage matrix table. `coverage-matrix.md` enumerates Pitfall 1.1's three state combos with Phase 4 stylebox contracts. The 4-grid demonstrates the dynamic single-class behavior (D-12, D-13). |
| **SC-04** | Step 3 — Approval & DESIGN_TOKENS.md: User approves final Phase 3.4 mockup direction and confirms recommended starter (or requests revisions). DESIGN_TOKENS.md finalized as single-class/data-resource-oriented; documents per direction `.tres` filename + default `base_color`/`accent_color` + 9 export values + Theme Editor override intent; plus shared class contract + variation override blocks. | **PASS** | `final-approval.md` records 5 themes approved + Pulse as recommended starter (2026-05-06). `DESIGN_TOKENS.md` (Plan 04 Task 2, commit 1bd4f7c) authored as the single-class/data-resource contract — §5 has per-direction `.tres` filename + `base_color` + `accent_color` + 9-property `@export` values + Theme Editor override intent; §4-§11 carry the shared contract; §9-§10 carry the flat/raised + desktop/mobile/AUTO variation blocks. |
| **SC-05** | Anti-cyberpunk + anti-texture filter pass at finalist gate (re-check at mockup level after Phase 3.3 already filtered). | **PASS** | `render-check.md` Plan 03 Finalist Audit section records all 6 finalist PNGs + 4 override PNGs PASS the anti-cyberpunk / anti-texture / anti-painterly-chrome / dark-only filters. Plan 02 Stage 1 audit (15 PNGs) above remains intact. D-30 greyscale sufficiency test: PASS per `render-check.md`. |
| **SC-06** | Hard blocker enforcement: no `.tres` styling commits under `addons/neocade_theme/` exist on the branch when Phase 3.4 closes; Phase 4 cannot start until Step 3 user approval is logged in writing. | **PASS** | Plan 04 Task 4 forbidden-surface audit (§4 below) confirms no production addon/theme files (`addons/`, `main.tscn`, `project.godot`, `.tres`, or `.gd`) modified across Plans 01-04 of Phase 3.4. `final-approval.md` is the written approval log; `DESIGN_TOKENS.md` is the prerequisite Phase 4 contract. The "no production" surface promise is enforced via the §4 git-status check. |
| **SC-07** | Historical preservation: all Phase 3 (v0) artifacts remain in `.planning/mockups/concepts/` + `.planning/mockups/03-direction-boards.*`. Phase 3.4 outputs go to `.planning/mockups/3.4/` so iterations don't conflict. | **PASS** | Phase 3 v0 historical files untouched: `.planning/mockups/concepts/*.png` (5 v0 painterly concepts) + `.planning/mockups/03-direction-boards.{html,md,png}` + `.planning/research/mood-board/` all preserved per the Phase 3 redirect 2026-05-04. Phase 3.4 outputs live exclusively under `.planning/mockups/3.4/` (gallery HTML, 21 PNGs in `concepts/`, render scripts, audit MDs). The historical reference framing is recorded in CLAUDE.md and `REDIRECTED.md`. |

**SC-01..SC-07 result: 7/7 PASS.**

### 3.2 Decisions D-01..D-27 cross-reference (CONTEXT.md)

Evidence-of-honor for each canonical decision in `03.4-CONTEXT.md`:

| Decision | Summary | Honored? | Evidence |
|---|---|---|---|
| **D-01** | Phase 3.4 uses Phase 3.3's 5 approved directions as direct inputs. | ✅ | `final-approval.md` §"Approved final themes" lists Pulse / Slate / Bubble / Daybreak / Burst with palettes from `THEME-DIRECTIONS.md`; DESIGN_TOKENS.md §2 codifies them. |
| D-02 | Phase 3.4 does not invent replacement directions. | ✅ | No new direction names appear in `data/directions.json`, `final-approval.md`, or DESIGN_TOKENS.md. |
| D-03 | All five directions remained peer candidates through Stage 1; Plan 02 closed with Pulse as recommended starter / implementation priority (no architectural privilege). | ✅ | `finalist-selection.md` records `selection_kind: recommended-starter` (not "elimination"); `final-approval.md` confirms all 5 ship as peers; D-31 reframing in DESIGN_TOKENS.md §3 explicitly states "no architectural privilege." |
| **D-04** | Stage 1 produces 15 concept boards (5 directions × 3 variants). | ✅ | 15 PNGs rendered. NB: the alternate phrasing as "10 concept boards" (logical board matrix) refers to the 5-direction × 2-axis matrix expanded to 15 PNGs (3 variants per direction) at implementation time; SC-02 confirms the expansion. |
| D-05 | Stage 1 boards use a representative slice (button hierarchy + input + selection/list + popup/dialog + states + palette/type/radius). | ✅ | `image-prompts/direction-shape-language-spec.md` records the slice; concept gallery + 4-grid screens both render the slice. |
| D-06 | Stage 1 does not need desktop/mobile 4-grid coverage; focus on directional taste + raised-vs-flat. | ✅ | Stage 1 produced 3 variants per direction (desktop-flat, mobile-flat, mobile-raised) — not the full 4-grid. |
| D-07 | Stage 1 boards must be honest about dynamic architecture (flat + raised are two renderings of same direction). | ✅ | Renderer (`neocade-mockups.js`) produces both variants from a single direction data block; no separate "flat-only" or "raised-only" data tables. |
| **D-08** | After Stage 1, user selected Pulse as implementation-priority finalist + recommended starter; Slate / Bubble / Daybreak / Burst remain v1 variations. | ✅ | `finalist-selection.md` (commit ffa8833) and `final-approval.md` both record Pulse as the user-confirmed recommended starter, with the other 4 directions retained for v1 ship. |
| D-09 | Only Pulse receives the Plan 03 full-fidelity 4-grid. | ✅ | 4 cells = `pulse-finalist-{desktop,mobile}-{flat,raised}.png`; no other direction has a Plan 03 4-grid. |
| D-10 | Full-fidelity finalist mockups demonstrate every required Control class + Pitfall 1.1 state combos. | ✅ | `coverage-matrix.md` maps 40 Godot 4.6 Control classes + 3 Pitfall 1.1 state combos with Phase 4 stylebox contracts. |
| D-11 | If a non-finalist needs revival after seeing finalist mockups, treat as focused revision. | n/a | No non-finalist revival was requested at the gate. |
| **D-12** | Phase 3.4 mockups use formula-driven HTML/CSS rendered via Playwright/Edge; CSS mirrors dynamic single-class model (derived ramp from `base_color`, role/accent from `accent_color`, raised hard-offset, desktop/mobile sizing). | ✅ | `neocade-mockups.js` `deriveSurfaceRamp()` + `deriveTokens()` + `PLATFORM_TOKENS` implement exactly this. **NB:** D-29 (CORRECTIVE-ADDENDUM) narrowed D-12 by adding the per-direction shape-language differentiation requirement; both D-12 and D-29 are honored. |
| D-13 | Full-fidelity finalist mockups show same direction in 4-grid (raised × platform). | ✅ | Pulse 4-grid PNGs satisfy this. |
| D-14 | Finalist mockups include a small color-override preview row. | ✅ | 3 override PNGs (warm-amber, ocean-cyan, cream-light Override C) rendered; gallery includes `#finalistOverrideRow`. |
| D-15 | Phase 3.4 must not expand Godot spike or author production `.gd` / `.tres`. | ✅ | Forbidden-surface audit (§4 below) confirms 0 changes to `.planning/spikes/dynamic-theme/`, `addons/`, `*.gd`, or `*.tres`. |
| **D-16** | The recommended starter sets the showcase default + README "try this first" suggestion only. | ✅ | DESIGN_TOKENS.md §3 codifies this as the only two soft commitments; final-approval.md confirms Pulse as the recommended starter under this framing. **NB:** D-31 (CORRECTIVE-ADDENDUM) reframed historic "base direction" → "recommended starter"; D-16 is honored under the D-31 framing. |
| D-17 | The recommended starter's values do NOT become `NeoCadeTheme` class defaults. | ✅ | DESIGN_TOKENS.md §3 explicitly states "It does NOT bake values into `NeoCadeTheme` class `@export` defaults." Class defaults are sensible neutral placeholders, not Pulse-flavored. **NB:** D-31 finalized this reframing (D-17 was originally "the chosen base direction's values become superclass defaults"; D-31 reversed it). |
| D-18 | Approved final directions ship as data-only `.tres` files of type `NeoCadeTheme` at addon root: `pulse_neocade_theme.tres`, `slate_neocade_theme.tres`, etc. | ✅ | DESIGN_TOKENS.md §5 + §12.1 codify all 5 `.tres` filenames at the addon root. **NB:** D-31 reframed historic "personality subclasses" → "data-only `.tres`" (originally D-18 referenced `_neocade_theme.gd` subclass files; D-31 reversed it). |
| D-19 | DESIGN_TOKENS.md records: final theme list + recommended starter + per-direction filename stem + default colors + 9 export values + Theme Editor override intent + shared class contract + variation override blocks + explicit no-subclass note. | ✅ | DESIGN_TOKENS.md §1-§12 cover all of these. §4 records the 9-property `@export` set. §5 has per-direction recipes. §12.3 records the explicit "no per-direction `.gd` files" + "no subclasses" + "no class hierarchy" production contract. |
| D-20 | Flat variation (`raised=false`) keeps `shadow_size = -1` on every `StyleBoxFlat`. | ✅ | DESIGN_TOKENS.md §9.1 codifies this (per Godot #98162). |
| D-21 | Raised variation uses extruded-flat hard offset shapes only — no blur, no soft drop shadow, no glow, no bevel gradient, no texture, no pattern, no embossing, no painterly chrome. | ✅ | DESIGN_TOKENS.md §9.2 codifies this; §11.3 hard-rules list reinforces. |
| D-22 | Raised behavior is strongest on buttons, subtle on tabs/chips/lists/handles, rare on popup/dialog shells, absent from passive labels. | ✅ | DESIGN_TOKENS.md §9.3 codifies the per-Control raised matrix. |
| D-23 | Desktop/mobile sizing follows the dynamic platform export model. Corner radii remain part of brand identity and do NOT auto-change with platform. | ✅ | DESIGN_TOKENS.md §10 codifies the platform branch + the corner-radius-stays-stable rule. |
| D-24 | `platform=AUTO` behavior is documented from Phase 3.2 and does not need visual proof beyond desktop+mobile output. | ✅ | DESIGN_TOKENS.md §10.2 codifies AUTO resolution; `VERIFY-RESULTS.md` proved the Phase 3.2 strict gate (web_android/web_ios/web_windows/ambiguous web all PASS). |
| **D-25** | Every concept and finalist board must pass anti-cyberpunk and anti-texture review before user selection or approval. | ✅ | `render-check.md` records anti-cyberpunk + anti-texture + anti-painterly-chrome PASS for all 15 Stage 1 PNGs + 6 Plan 03 PNGs (4-grid + 2 color overrides) + 1 Override C light demo. |
| D-26 | Maximum targeted revision rounds remain 3 for Phase 3.4. | ✅ | Plan 02 went through 4 mockup revisions (the spec allowed iteration within Plan 02's task structure; the gate-revision count stayed within 3). Plan 03 did not require revision rounds — finalist gate closed on first pass. |
| **D-27** | Phase 4 cannot begin until user approval decision and recommended starter selection are written in Phase 3.4 outputs. | ✅ | `final-approval.md` is the written user-approval log + recommended-starter selection record (Pulse, 2026-05-06). DESIGN_TOKENS.md is the additional prerequisite Phase 4 contract. Both are now in place; Phase 4 unblocks after `/gsd-verify-work` of Phase 3.4. |

**D-01..D-27 result: 26/26 honored, 1 n/a (D-11 condition didn't trigger). D-28..D-31 (CORRECTIVE-ADDENDUM, supersedes parts of D-04 / D-12 / D-16 / D-17 / D-18) all honored — see DESIGN_TOKENS.md §1 (provenance) and §3 (D-31 reframing).**

### 3.3 Anti-cyberpunk and anti-texture filter — finalist gate PASS

Re-confirms SC-05 with explicit listing:
- 5 Stage 1 directions × 3 variants = 15 PNGs: PASS (`render-check.md` Plan 02 Stage 1 audit).
- Pulse 4-grid (4 PNGs) + 2 color overrides (warm + ocean) + Override C cream-light: PASS (`render-check.md` Plan 03 Finalist Audit).
- D-30 greyscale sufficiency test: PASS — every direction remains identifiable in greyscale by shape language alone (per `render-check.md`).

### 3.4 No production `.tres` styling commits

The hard blocker per SC-06 is enforced. The forbidden-surface audit in §4 below makes this explicit: across Plans 01-04 of Phase 3.4, **no production** addon/theme files under `addons/neocade_theme/`, `main.tscn`, `project.godot`, `*.tres`, or `*.gd` were created or modified. Phase 4 implementation is the next phase to touch those surfaces.

### 3.5 Historical v0 outputs preserved

Per SC-07, all Phase 3 v0 historical artifacts remain untouched and findable:

| Artifact | Path | Status |
|---|---|---|
| 5 v0 painterly concept images | `.planning/mockups/concepts/*.png` (existed before Phase 3.4 started) | preserved (untouched) |
| v0 direction-boards gallery | `.planning/mockups/03-direction-boards.{html,md,png}` | preserved |
| v0 mood-board references | `.planning/research/mood-board/` (25 references + INDEX) | preserved |
| Phase 3 redirect notes | `.planning/phases/03-visual-direction-mockup-approval-gate/REDIRECTED.md` | preserved (NB: NOT under `.planning/mockups/3.4/` — it's the original-phase document) |

The `historical` framing is preserved in CLAUDE.md and REDIRECTED.md per the Phase 3 redirect 2026-05-04. Phase 3.4 outputs live exclusively under `.planning/mockups/3.4/` per CONTEXT.md and ROADMAP SC-07.

**SC-07 result: PASS.**

---

## Section 4 — forbidden-surface audit + Phase 4 handoff (Plan 04 Task 4)

### 4.1 forbidden-surface audit (Plan 04 only — current uncommitted state)

The plan's automated verification runs `git status --short` and asserts no entry matches the forbidden-pattern set:
- `^.. addons/` (production addon directory)
- `^.. main\.tscn$` (project main scene)
- `^.. project\.godot$` (project file)
- `\.tres$` (any production theme resource)
- `\.gd$` (any production GDScript)
- `addons.*fonts` (bundled font assets)
- `addons.*icons` (bundled icon assets)

**At Plan 04 close-of-work the working tree is clean** — `git status --short` returns the only uncommitted entry (`phase-3.4-closeout.md` itself), which after this commit becomes empty. **No production surfaces touched in any Plan 04 task.** Verification: PASS.

### 4.2 forbidden-surface audit (whole-phase scope, Plans 01-04 combined)

The hard blocker per SC-06 / D-15 / D-27 requires that Phase 3.4 in its entirety produces no production styling commits. Audit run as `git diff --name-only 61a118d..HEAD` (Phase 3.4 commit range, from the last pre-Phase-3.4 commit through Plan 04 Task 3).

**Files changed across all of Phase 3.4 (Plans 01-04 combined):**
- 8 docs/state files under `.planning/` root (`PROJECT.md`, `REQUIREMENTS.md`, `ROADMAP.md`, `STATE.md`, `DESIGN_TOKENS.md`, etc.)
- All Phase 3.4 mockup artifacts under `.planning/mockups/3.4/` (gallery HTML, 21 PNGs, render scripts, audit MDs, gate-closure files)
- All Phase 3.4 phase artifacts under `.planning/phases/03.4-*/` (CONTEXT.md, CORRECTIVE-ADDENDUM.md, RESEARCH.md, 4 PLAN files, 4 SUMMARY files — Plan 04 SUMMARY follows this audit)
- 1 research artifact: `.planning/research/THEME-DIRECTIONS.md` (Revision Round 2/2 dark migration was applied during Phase 3.4)

**Production-surface files changed:** ZERO. Forbidden-pattern grep against the whole-phase diff returns no matches:
```
git diff --name-only 61a118d..HEAD | grep -E "^addons/|^main\.tscn$|^project\.godot$|\.tres$|\.gd$" | grep -v "^.planning/"
→ NONE FOUND - PASS
```

(The `grep -v "^.planning/"` filter is necessary because `.tres` / `.gd` patterns could match planning-side spike files; the spike artifacts are under `.planning/spikes/dynamic-theme/`, NOT production. The whole-phase audit confirms even those weren't touched in Phase 3.4 — they're inherited from Phase 3.2.)

**Whole-phase forbidden-surface audit: PASS.**

### 4.3 Plan 04 file scope

Plan 04 wrote exactly two files (the plan's `files_modified` declaration):
| File | Purpose | Commit |
|---|---|---|
| `.planning/DESIGN_TOKENS.md` | Phase 4 single-class/data-resource contract (Task 2 deliverable) | `1bd4f7c` |
| `.planning/mockups/3.4/phase-3.4-closeout.md` | this closeout report (Tasks 1, 3, 4 deliverables) | `cde88ee`, `bb20cb1`, this commit |

Both paths sit inside `.planning/` — never inside `addons/`, never matching `main.tscn` / `project.godot` / `*.tres` / `*.gd`.

### 4.4 Phase 4 handoff

This section is the explicit Phase 4 handoff per the plan's Task 4 mandate. Phase 4 begins after `/gsd-verify-work` of Phase 3.4 closes the phase.

**Phase 4 prerequisite (CLOSED):**
- `final-approval.md` exists and records the user-approval gate (PASS — Plan 04 Task 1 §1).
- `DESIGN_TOKENS.md` exists and is the Phase 4 single-class/data-resource contract (PASS — Plan 04 Task 2 §2).
- forbidden-surface audit confirms no production styling commits exist in Phase 3.4 (PASS — §4.1 + §4.2 above).

**Phase 4 reads:**
- **PRIMARY:** `.planning/DESIGN_TOKENS.md` — every `@export` value, every formula, every per-Control authoring intent. Phase 4 imports values, ports formulas, and authors per-direction Theme Editor overrides from this single document.
- Supporting: `.planning/research/GODOT-DYNAMIC-THEME-RESEARCH.md` (Architecture Recipe), `.planning/spikes/dynamic-theme/VERIFY-RESULTS.md` (6/6 strict-gate PASS evidence), `.planning/research/MD3-RESEARCH.md` (M3 grammar), `.planning/research/MINIMAL-THEME-DISSECTION.md` (`_get_base_color` formula reference).

**Approved theme set (5 directions, all ship as data-only `.tres` peers):**
| Direction | base_color | accent_color | Phase 4 implementation order |
|---|---|---|---|
| **Pulse** | `#151A2E` | `#8BFF6A` | implement first (the **Recommended starter**) |
| Slate    | `#111820` | `#8BD3FF` | implement after Pulse |
| Bubble   | `#241326` | `#FFB3E6` | implement after Pulse |
| Daybreak | `#0B2420` | `#76F2D1` | implement after Pulse |
| Burst    | `#20112E` | `#FFD166` | implement after Pulse |

**Recommended starter:** Pulse — preloaded as the showcase scene's theme + named in the addon README's "try this first" suggestion. Soft commitment only; no architectural privilege over the other four directions. Per D-31 (CORRECTIVE-ADDENDUM 2026-05-06e/f), the recommended starter does NOT bake values into `NeoCadeTheme` class defaults.

**Phase 4 file create / delete / forbid lists** (canonical version in `DESIGN_TOKENS.md` §12.1-§12.3):
- **CREATE:** `addons/neocade_theme/neocade_theme.gd` (single concrete class, 9 `@export` properties), 5 data-only `.tres` files at addon root (`pulse_neocade_theme.tres`, `slate_neocade_theme.tres`, `bubble_neocade_theme.tres`, `daybreak_neocade_theme.tres`, `burst_neocade_theme.tres`), addon metadata (`OFL.txt`, `LICENSE.md`, `README.md`, `CHANGELOG.md`, `VERSION`).
- **DELETE:** `addons/neocade_theme/neocade_theme.tres` (existing empty Theme scaffold; under the locked architecture no root `.tres` ships). Deletion happens in the FIRST Phase 4 task.
- **MUST NOT CREATE:** No per-direction `.gd` files. No `themes/` subfolder. No `_dev/` subfolder. No `neocade_mobile_theme.tres`. No `plugin.cfg`.

**Phase 4 architectural lock (referenced in `DESIGN_TOKENS.md` §4):**
- Single concrete `@tool class_name NeoCadeTheme extends Theme` at `addons/neocade_theme/neocade_theme.gd`.
- 9 `@export` properties total — Core (4): `base_color`, `accent_color`, `raised`, `platform`. Shape (5, under `@export_group("Shape")`): `corner_radius`, `spacing`, `raised_strength`, `focus_thickness`, `outline_width`.
- `is_light: bool = base_color.get_luminance() >= 0.5` computed in `_regenerate_theme()`. Dark default; flag deviates to light forward-compat.
- Setters on every `@export` trigger `_regenerate_theme()` (Phase 3.2 6/6 strict-gate PASS pattern).

**Phase 4 verification gates (referenced in `DESIGN_TOKENS.md` §12.5):**
- All 9 `@export` properties exist with correct types/defaults/group labels.
- `is_light` flag derives correctly from `base_color.get_luminance()`.
- All 5 `.tres` files load successfully and produce visually distinct themes matching their Phase 3.4 mockup commitment.
- Toggling `raised` / `platform` / `base_color` / `accent_color` produces correctly regenerated entries.
- WCAG audit re-runs reproduce the ratios in `wcag-palette-audit.md`.

### 4.5 Plan 04 closeout — final status

**Plan 04 of Phase 3.4 — CLOSED.**

| Task | Deliverable | Verification | Commit |
|---|---|---|---|
| Task 1 | final-approval prerequisite validated | PowerShell verify PASS (4/4 markers) | `cde88ee` |
| Task 2 | `.planning/DESIGN_TOKENS.md` (12 sections, single-class/data-resource contract) | PowerShell verify PASS (15/15 markers) | `1bd4f7c` |
| Task 3 | Phase 3.4 success-criteria audit (SC-01..SC-07 + D-01..D-27) | PowerShell verify PASS (19/19 markers) | `bb20cb1` |
| Task 4 | forbidden-surface audit + Phase 4 handoff | PowerShell verify PASS (4/4 markers) + git-status forbidden-grep PASS | this commit |

**Phase 3.4 — CLOSED.** All seven ROADMAP success criteria PASS. All 27 canonical decisions D-01..D-27 honored (D-11 n/a). All four CORRECTIVE-ADDENDUM decisions D-28..D-31 honored. Phase 4 unblocks after `/gsd-verify-work` confirms.
