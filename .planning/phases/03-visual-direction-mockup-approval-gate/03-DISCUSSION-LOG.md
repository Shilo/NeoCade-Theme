# Phase 3: Visual Direction Mockup + Approval Gate - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md — this log preserves the alternatives considered.

**Date:** 2026-05-04
**Phase:** 3-Visual Direction Mockup + Approval Gate
**Areas discussed:** Real-Arcade Reference Brief, Palette Gate Framing, Typography Override Surface, Gallery Approval Bar, MCP/GoPeak Tooling Decision

---

## Real-Arcade Reference Brief

| Question | Options Considered | Selected |
|----------|--------------------|----------|
| Reference center | Modern arcades; Classic halls; Hybrid mix | Modern arcades, with futuristic/neo arcades included |
| Extraction target | Interior warmth; Cabinet details; Venue branding | Interior warmth |
| Futuristic allowance | Optimistic neo-arcade; Mostly grounded; Bolder concept arcade | Optimistic neo-arcade |
| Rejection filter | No sci-fi noir; No retro kitsch; No generic venue | None as hard collection rejects |
| Organization | Tagged broad board; Separate boards; Loose inspiration only | Tagged broad board |
| Risky/game-world influence | Extract design moves only; Use in one bold direction; Keep out | Extract design moves only |
| Sci-fi amount | Curated minority; Equal pillar; Only if arcade-linked | Curated minority |
| Caption purpose | What to extract; Why it looks cool; Theme vs game split | What to extract |

**User's choice:** Broad tagged inspiration, modern/neo arcade centered, with sci-fi/spaceship and future-venue references allowed as curated minority.
**Notes:** User clarified that the game world may later be sci-fi or set in a spaceship, so inspiration should stay open. Narrowing happens at the mockup gate, not during collection.

---

## Palette Gate Framing

| Question | Options Considered | Selected |
|----------|--------------------|----------|
| Initial framing | Recommended default + challengers; Equal bake-off; Exploratory spectrum | Recommended default + challengers |
| Challenger role | Different strengths; Direct competition; Boundary tests | Different strengths |
| Layout/content comparison | Identical layout; Light tailoring; Fully tailored | Fully tailored |
| Direction count/framing | Three named directions; Recommended + wildcards; Mood-board generated | Five named art directions |
| Fidelity funnel | Two-stage funnel; All full-fidelity; 5 desktop/finalists mobile | Two-stage funnel |
| Concept vs implementation first | Concept design first | Concept design first |

**User's choice:** Five named art directions, concept designs first, then direction boards, then finalist HTML/control mockups.
**Notes:** User explicitly wants full theme variations, not just palette swaps. The plan must perform extensive/exhaustive research and derive two additional directions beyond Midnight Marquee, Boardwalk Sunset, and Cabinet Chrome.

---

## Typography Override Surface

| Question | Options Considered | Selected |
|----------|--------------------|----------|
| Typography in funnel | Inter-only baseline; Varies by direction; Separate compare | Inter-only baseline |
| Italic handling | Show synthetic italic; Avoid italic; Ask again at gate | Show synthetic italic |
| Non-Latin fallback | Functional sample panel; Hide fallback; Designed fallback preview | Functional sample panel |
| Code/mono | Consumer override sample; Inter code fallback; Reopen mono decision | Consumer override sample |

**User's choice:** Inter-only across all directions.
**Notes:** User asked what "Inter Variable Roman" means. Clarification given: it is Inter's upright variable font, providing multiple weights from one file but not true italic. User then confirmed the Inter-only baseline.

---

## Gallery Approval Bar

| Question | Options Considered | Selected |
|----------|--------------------|----------|
| Full-fidelity meaning | Representative full-fidelity; Every Control visible; Near-showcase prototype | Representative full-fidelity, with images and text |
| What mockups prove | Theme identity + usability; Visual excitement; Implementation readiness | Theme identity + usability |
| Approval threshold | Approve direction, then tokens; Approve exact tokens too; Approve with comments | Approve direction, then tokens |
| Revision rounds | Up to 3 targeted rounds; Open-ended; One decisive revision | Up to 3 targeted rounds |

**User's choice:** Representative full-fidelity finalist mockups that combine visuals/images with written annotations.
**Notes:** User approves visual direction first. `DESIGN_TOKENS.md` then converts the approved direction into exact implementation values.

---

## MCP/GoPeak Tooling Decision

| Question | Options Considered | Selected |
|----------|--------------------|----------|
| GoPeak handling | Mechanical if smoke test passes; Explicit approval after test; Keep current MCP unless broken | GoPeak permitted |
| Smoke test scope | Visual QA minimum; Broad tooling baseline; Screenshot only | Screenshot only |
| Input injection | Defer input injection; Optional stretch; Still required in Phase 3 | Defer input injection |
| Failure path | Fallback screenshot harness; Block and fix tooling; Continue without screenshots | Fallback screenshot harness |

**User's choice:** Use GoPeak if needed, but Phase 3 only depends on screenshot capture.
**Notes:** User asked why GoPeak was recommended because Coding-Solo `godot-mcp` exists. Explanation: current visible Coding-Solo tool surface supports launch/run/debug-output workflows but not direct screenshot capture; GoPeak advertises screenshot capture. User then granted permission to use GoPeak.

---

## Claude's Discretion

- Exact prompts for image-generator concept designs.
- Exact naming and framing of the two additional art directions.
- Exact board layout and artifact structure, provided tags/captions and concept-first sequence are honored.
- Exact fallback screenshot harness if GoPeak screenshot capture fails.

## Deferred Ideas

- VirtuCade's possible sci-fi/spaceship game-world identity is preserved as future game inspiration, not binding NeoCade theme direction.
- Input injection and full interaction-driving MCP validation are deferred to Phase 10 QA.
