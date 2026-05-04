# Phase 3: Visual Direction Mockup + Approval Gate - Context

**Gathered:** 2026-05-04
**Status:** Ready for planning

<domain>
## Phase Boundary

Phase 3 delivers NeoCade's approved visual direction before any `.tres` styling work begins. The phase produces broad visual research, image-generated concept designs, named art-direction boards, finalist desktop/mobile UI mockups, a GoPeak screenshot baseline or fallback screenshot path, and the final `DESIGN_TOKENS.md` contract. Phase 4 remains blocked until the user approves the final representative mockups and the token spec is written.

**In scope:**
- Broad tagged mood-board and reference synthesis.
- Image-generator concept designs for five named art directions.
- Direction boards that explain what to extract from each reference/direction.
- Finalist HTML/control mockups for two to three user-selected directions.
- Representative desktop and mobile gallery mockups with images and text annotations.
- `DESIGN_TOKENS.md` with exact desktop/mobile token values after direction approval.
- GoPeak screenshot smoke test, or documented fallback screenshot harness if GoPeak screenshots fail.

**Out of scope:**
- Any styling commits to `addons/neocade_theme/neocade_theme.tres` or `neocade_mobile_theme.tres`.
- Treating source-dive outputs as binding visual specs.
- Locking VirtuCade's game-world aesthetic; the game may later become sci-fi/spaceship-themed.
- Full Phase 10 input-injection QA. Phase 3 needs screenshots only.

</domain>

<decisions>
## Implementation Decisions

### Real-Arcade Reference Brief
- **D-01:** Modern arcades dominate the mood-board, with optimistic neo-arcade references included for creativity, color, and fun.
- **D-02:** The strongest extraction target is interior warmth: warm lighting, prize-counter color, painted/wood cabinet surfaces, approachable social spaces, and real entertainment-venue energy.
- **D-03:** The neo/futuristic side should be optimistic and playful: creative lighting, future-facing details, polished materials, and fun color, while still feeling like a place people would visit.
- **D-04:** Do not hard-reject inspiration categories at collection time. Sci-fi, spaceship, retro, unusual, and risky imagery may be collected because VirtuCade's eventual game world is not yet decided.
- **D-05:** Organize the board with tags such as `theme-safe`, `game-world`, `palette`, `surface`, `shape`, and `risky`.
- **D-06:** `game-world` and `risky` references influence NeoCade only through extracted design moves: color relationships, material cues, layout energy, forms, affordances, or rhythm. Do not copy their whole mood into the reusable theme.
- **D-07:** Sci-fi/spaceship/future-venue imagery should be a curated minority, not an equal pillar.
- **D-08:** Every mood-board item needs a caption explaining what to extract: palette, surface material, lighting, control shape, signage rhythm, density, or mood.

### Art-Direction Funnel
- **D-09:** Phase 3 expands from three palette mockups to **five named art directions**.
- **D-10:** Keep the existing three directions as traceable anchors: `Midnight Marquee`, `Boardwalk Sunset`, and `Cabinet Chrome`.
- **D-11:** The Phase 3 plan must derive **two additional unique named directions** from the mood-board and compiled research. They must satisfy the same NeoCade constraints: reusable Godot theme identity, HD-only, accessible, modern/neo arcade, professional, colorful, and not accidentally cyberpunk by default.
- **D-12:** First pass is a two-stage funnel: five lighter concept/direction boards first, then two to three full-fidelity finalist mockups after the user selects finalists.
- **D-13:** The first artifacts are **image-generator concept designs first**, not implementation-style UI samples. They explore concept, energy, imagery, shape language, lighting, material cues, layout direction, and emotional target before narrowing into control mockups.
- **D-14:** Each art direction may vary layout, shapes, density, accent rhythm, surface treatment, control geometry, and color behavior. It should not merely recolor the same layout.
- **D-15:** `Boardwalk Sunset` remains the recommended baseline, but the other directions are serious alternatives with distinct strengths, not fake choices.

### Typography Surface
- **D-16:** All five art directions use an Inter-only baseline. Use Inter Variable Roman for all UI surfaces.
- **D-17:** Heading distinction comes from Inter `opsz`, weight, size, spacing/layout, and composition, not from a second display font.
- **D-18:** The user understands that Inter Variable Roman provides multiple upright weights in one file but does not provide true italic. Do not re-open the font stack during planning unless the user explicitly asks.
- **D-19:** Show a small synthetic italic/emphasis sample and label it as synthetic v1 behavior.
- **D-20:** Include a functional fallback text sample panel: Latin plus representative non-Latin strings using system fallback. Label this as functional; consumers can add script-specific Noto fonts for visual harmony.
- **D-21:** Show CodeEdit/inline code as a consumer-supplied mono override sample. NeoCade v1 does not bundle a monospace font.

### Gallery Approval Bar
- **D-22:** Finalist mockups are representative full-fidelity, not a full implementation-scale showcase. They include representative Control families, key states, desktop and mobile views, images/visual elements where useful, and text annotations.
- **D-23:** The approval mockups must prove theme identity plus usability: they feel like NeoCade, support real UI content, show focus/hover/disabled states, and remain readable.
- **D-24:** The user approves the visual direction first; `DESIGN_TOKENS.md` then captures exact values and becomes the implementation contract.
- **D-25:** Allow up to three targeted revision rounds. Each round addresses written issues. If still not approved after three rounds, pause and escalate the direction decision.

### MCP / GoPeak Tooling
- **D-26:** GoPeak is permitted. The user asked why it was needed, understood the screenshot/input capability difference, and approved its use.
- **D-27:** Phase 3 only needs a screenshot smoke test: prove GoPeak can capture a Godot screenshot. Input injection is deferred to Phase 10 QA.
- **D-28:** Coding-Solo `godot-mcp` remains useful for launch/run/debug-output workflows, but the currently visible tool surface does not provide screenshot capture.
- **D-29:** If GoPeak screenshot capture fails, keep Phase 3 moving with a fallback screenshot harness, such as a Godot screenshot script or external capture path, and document GoPeak as unresolved tooling.

### Claude's Discretion
- Exact prompts for image-generator concept designs.
- Exact names and framing for the two new art directions, subject to research evidence and hard constraints.
- Exact layout of direction boards and captions, as long as every board is actionable and tagged.
- Exact fallback screenshot harness implementation if GoPeak capture fails.

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Project Canon
- `.planning/PROJECT.md` — hard constraints, Research Charter, visual identity boundaries, mockup approval gate, and source coverage commitment.
- `.planning/REQUIREMENTS.md` — Phase 3 requirements: RES-03, RES-04, DESIGN-01..06, DOCS-01, TOKEN-01..10.
- `.planning/ROADMAP.md` — Phase 3 goal, success criteria, dependencies, and hard blocker before Phase 4.
- `.planning/STATE.md` — current phase state and open decisions.
- `.planning/config.json` — GSD workflow and model configuration.

### Research Canon
- `.planning/research/SUMMARY.md` — synthesized project canon, conflict resolutions, open user decisions, and current roadmap rationale.
- `.planning/research/SOURCES.md` — source dossier; Phase 3 must update real-arcade reference coverage and preserve Phase 1/2 source-dive results.
- `.planning/research/ARCHITECTURE.md` — current palette proposals, token architecture, mockup strategy, prototype critique, and anti-cyberpunk rules. Treat as prior research, not final Phase 3 output.
- `.planning/research/FEATURES.md` — 35-class coverage matrix, type variations, showcase scope, and anti-features.
- `.planning/research/CROSS-PLATFORM.md` — mobile variant constraints, token-sharing strategy, renderer/export risks, and screenshot/tooling concerns.
- `.planning/research/PITFALLS.md` — focus, popup, font, GL Compatibility, visual-identity, MCP, and showcase pitfalls.
- `.planning/research/FONT-REVIEW.md` — historical font-stack reasoning; superseded by Option D in SUMMARY.md, but useful background for Inter-only decisions.
- `.planning/research/MINIMAL-THEME-DISSECTION.md` — Phase 1 output; coverage and theme-entry benchmark.
- `.planning/research/MINIMAL-THEME-COVERAGE-DELTA.md` — Phase 1 output; upstream-vs-NeoCade class coverage delta.
- `.planning/research/LDTK-UI-MINING.md` — Phase 2 output; LDtk UI patterns and inspiration sketches.

### Prior Phase Context
- `.planning/phases/01-source-dive-godot-minimal-theme-tres-dissection/01-CONTEXT.md` — Phase 1 decisions and standards.
- `.planning/phases/02-source-dive-ldtk-source-ui-mining/02-CONTEXT.md` — Phase 2 LDtk source-mining scope, decisions, and loose-inspiration framing.

### User Inputs
- `.planning/inputs/NeoCade-Research-Report.md` — prior user research, challenged reference only.
- `.planning/inputs/NeoCade-Theme-Prototype.png` — prior prototype, structural inspiration only; not visual source of truth.

### Current Godot Scaffold
- `project.godot` — Godot 4.6, GL Compatibility renderer, .NET enabled, `main.tscn` set as main scene.
- `main.tscn` — current showcase scaffold: fullscreen `Control` root applying `neocade_theme.tres`.
- `addons/neocade_theme/neocade_theme.tres` — empty desktop theme scaffold. Do not style in Phase 3.

### External Tooling References
- `https://github.com/Coding-Solo/godot-mcp` — current MCP reference; launch/run/debug-output/project tooling.
- `https://github.com/HaD0Yun/Gopeak-godot-mcp` — permitted screenshot-capable MCP candidate; Phase 3 smoke-test target.

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- `main.tscn` — can remain the eventual in-Godot screenshot target, but Phase 3 mockups should be concept/image/HTML artifacts before `.tres` implementation.
- `addons/neocade_theme/neocade_theme.tres` — empty scaffold only; preserving it untouched is part of the Phase 3 gate.
- `project.godot` — already locks GL Compatibility, which matches the visual QA target and Web export renderer.

### Established Patterns
- Research artifacts live under `.planning/research/`.
- Per-phase context and logs live under `.planning/phases/03-visual-direction-mockup-approval-gate/`.
- Prior source-dive artifacts use evidence-grade citations and explicit adopt/reject/open framing. Phase 3 should keep that discipline for visual references and concept boards.
- Source-dive values and sketches are inspiration only. Binding design choices are created by this phase's approved concept/mockup gate and `DESIGN_TOKENS.md`.

### Integration Points
- `.planning/research/SOURCES.md` must be updated with Phase 3 real-arcade/mood-board findings.
- `.planning/mockups/` should contain generated concept/design artifacts and HTML mockups.
- `.planning/research/mood-board/` should contain tagged references and captions.
- `DESIGN_TOKENS.md` is created only after approval and becomes the Phase 4 contract.
- GoPeak or the fallback harness feeds screenshot evidence for design review, but input-driving is not a Phase 3 blocker.

</code_context>

<specifics>
## Specific Ideas

- User wants the mockup process to be **concept design first**, using image generation before the HTML/control mockup stage.
- Five named art directions are required. The first three are `Midnight Marquee`, `Boardwalk Sunset`, and `Cabinet Chrome`; the other two must be discovered through research and named by the planning/design work.
- Visual directions should not be only color swaps. They should explore complete theme variation energy: shape language, layout rhythm, surface treatment, density, imagery, icon/control feel, and color behavior.
- Broad sci-fi/spaceship inspiration is allowed because VirtuCade may later use a sci-fi or spaceship setting, but those references are not binding theme identity.
- Representative finalist mockups need both image/visual material and explanatory text.
- Typography stays Inter-only. Use the design system, not a second display font, to create arcade personality.

</specifics>

<deferred>
## Deferred Ideas

- VirtuCade's eventual game-world direction, including possible sci-fi/spaceship arcade setting, is deferred outside this theme phase. Preserve useful references as `game-world` inspiration, but do not make them binding NeoCade theme identity.
- Input injection and full runtime-driving MCP validation are deferred to Phase 10 QA.
- Broader real-device cross-platform matrix decisions remain UD-5 and belong to Phase 10 planning.

</deferred>

---

*Phase: 3-Visual Direction Mockup + Approval Gate*
*Context gathered: 2026-05-04*
