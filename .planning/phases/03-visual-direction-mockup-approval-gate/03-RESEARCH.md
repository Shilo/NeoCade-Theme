# Phase 3 Research: Visual Direction Mockup + Approval Gate

**Researched:** 2026-05-04
**Status:** Planning research complete

## Summary

Phase 3 is a design-research and approval-gate phase. It must not touch `addons/neocade_theme/neocade_theme.tres` or any future `neocade_mobile_theme.tres` styling. The work sequence should be:

1. Build a broad, tagged real-arcade and future-arcade reference corpus.
2. Smoke-test Godot visual tooling, preferring GoPeak for screenshots.
3. Generate concept-design images for five named art directions.
4. Convert those concepts into direction boards and let the user pick two or three finalists.
5. Build representative full-fidelity desktop and mobile HTML mockups for finalists.
6. After explicit approval, write `DESIGN_TOKENS.md` with exact desktop/mobile values.

The key correction from older research is that Phase 3 is no longer a simple "three palette mockups" task. User decisions in `03-CONTEXT.md` require five named art directions, concept-design images first, Inter-only typography across all directions, and full art-direction variation beyond color swaps.

## Source Signals For Planning

### Real Arcade Reference Targets

The mood-board should favor modern, inviting arcade interiors and use futuristic or sci-fi references as a curated minority.

| Source family | Planning use | Evidence to collect during execution |
|---|---|---|
| Round1 USA official location pages | Modern arcade and prize-counter visual language, crane machines, rhythm games, Victory Zone / prize store, food counter, party rooms. | High-resolution linked images plus captions for arcade rows, claw machines, prize store, card station, food counter, dance games. Round1 pages expose image alt text for these categories. |
| Dave & Buster's official play/events pages | Eatertainment layout: arcade, bar, Power Card station, ticket/prize loop, group tables near the Midway. | Official language around Midway Arcade, Power Card, tickets, WIN store, and group tables near the Million Dollar Midway. |
| Wikimedia Commons Dave & Buster's interior photo | Legally reusable real-venue reference with high-res original file. | Use as a licensed anchor if needed; original is 4608 x 3456 and CC BY-SA 4.0, so attribution/share-alike must be tracked if used as an image artifact. |
| Two Bit Circus coverage | Neo/future arcade inspiration: collaborative gameplay, immersive tech, boxy controllers, micro-amusement park energy. | Use sparingly as `game-world` / `risky` inspiration, not a default NeoCade theme mood. |
| Classic / barcade / pinball hall sources | Cabinet density, marquees, coin-op rows, wood/black cabinet rhythm, simple signage hierarchy. | Collect a minority of references to avoid over-modernizing; captions should extract layout/material rhythm rather than nostalgia. |

Reference-board rules from context:
- Tag every item: `theme-safe`, `game-world`, `palette`, `surface`, `shape`, `risky`.
- Every item needs an extraction caption: palette, surface, lighting, control shape, signage rhythm, density, or mood.
- No source becomes a binding design spec. The output of Phase 3 approval and `DESIGN_TOKENS.md` becomes binding.

### MCP / Screenshot Tooling

The currently visible Coding-Solo Godot MCP tool surface in this Codex session has launch/run/debug/project-info/UID tools, but no screenshot or input-injection tool. Coding-Solo's README describes launch/run/debug-output/control/project/scene/UID features, which matches that surface.

GoPeak's README advertises screenshot, viewport capture, and input injection in its testing tool group, plus compact/default tool exposure with dynamic groups. User has approved GoPeak. Phase 3 only needs screenshot capture smoke testing; full input-injection QA is deferred to Phase 10.

Planning implication:
- Try current `mcp__godot__get_godot_version`, `launch_editor`, and `get_debug_output` first for baseline.
- Then smoke-test `npx -y gopeak` or document why it cannot run in this environment.
- If GoPeak screenshot capture is unavailable from the active MCP tool surface, create a fallback Godot screenshot script using `get_viewport().get_texture().get_image().save_png(...)` or external capture and document it as a fallback, not as the preferred Phase 10 path.

### Art-Direction Funnel

Five art directions should be treated as complete concepts, not palettes:

| Direction | Status | Planning note |
|---|---|---|
| Midnight Marquee | Existing anchor | Cool prototype-descended direction; must be warmed enough to avoid synthwave/cyberpunk default. |
| Boardwalk Sunset | Existing anchor, recommended baseline | Warm arcade hall by day; still recommended but should not be a fake choice. |
| Cabinet Chrome | Existing anchor | Disciplined LDtk/minimal-theme-adjacent direction with orange signature accent. |
| New Direction 4 | Research-derived | Must come from real mood-board evidence. Candidate territory: prize-counter/kawaii crane-machine candy color, but professional and reusable. |
| New Direction 5 | Research-derived | Must come from real mood-board evidence. Candidate territory: optimistic spaceport / spaceship arcade, but `risky` and disciplined. |

The executor should name Directions 4 and 5 after the reference pass, not before. The plan may suggest candidate territories, but the execution artifact should justify the final names from the collected board.

### Typography

Inter-only is locked:
- Use Inter Variable Roman for all five directions.
- Use `opsz`, weight, size, layout, and composition for heading distinction.
- Include synthetic italic sample.
- Include Latin plus representative non-Latin fallback sample; label it functional system fallback.
- Include code/mono sample as consumer override, not bundled mono.

### Mockup Fidelity

Concept-design images come first. HTML/control mockups come after user selection of finalists. Finalist mockups are representative full-fidelity rather than an implementation-scale showcase:
- Desktop: enough Godot Control families and states to prove identity, readability, focus, hover, pressed, disabled, popups, panels, lists/tree/tabs, dialogs, and token gallery.
- Mobile: 360 x 800 and 768 x 1024 representations with 48px tap-target overlays and body 16px.
- Each mockup needs visuals/images and concise text annotations.

### Token Finalization

`DESIGN_TOKENS.md` is written only after approval. It must include:
- 5-stop surface ramp with aliases.
- 8-hue accent palette and semantic roles.
- Text colors with WCAG AA contrast ratios.
- Inter-only type scale.
- Desktop and mobile spacing/token blocks.
- Radius and stroke scales.
- No-shadows/color-only elevation policy.
- M3 state-layer opacities.
- Approval log and no-`.tres` gate.

## External References Checked During Planning

- https://github.com/HaD0Yun/Gopeak-godot-mcp — GoPeak README: compact/full tool surface, testing tools for screenshots/viewport capture/input injection, `npx -y gopeak`.
- https://github.com/Coding-Solo/godot-mcp — Coding-Solo README: launch editor, run projects, capture debug output, control execution, project analysis, scene/UID management.
- https://www.round1usa.com/locations/062jsg — Round1 official location page with multiple arcade/prize/food/card-station image categories.
- https://www.round1usa.com/locations/058mvj — Round1 official Mission Viejo page with crane/rhythm/Victory Zone image categories.
- https://www.daveandbusters.com/us/en/play — Dave & Buster's official play page with Midway Arcade, Power Card, tickets, WIN store language.
- https://www.daveandbusters.com/us/en/parties/company — Dave & Buster's official events page with group tables near Million Dollar Midway.
- https://commons.wikimedia.org/wiki/File:Dave_%26_Buster%27s_Marietta_interior_2.JPG — high-resolution CC BY-SA real interior photo reference.
- https://www.latimes.com/travel/story/2024-12-12/two-bit-circus-pop-up-santa-monica-space-elevator — Two Bit Circus future-arcade / collaborative gameplay reference.

## Risks

- The phase can drift into pure UI mockups too early. Mitigation: require image-generator concept designs before direction boards and HTML.
- Sci-fi/spaceship inspiration can overpower the reusable theme. Mitigation: tag as `game-world` or `risky`, keep curated minority, extract design moves only.
- External images may have unclear licenses. Mitigation: record source URL, license/usage status, and whether the image is reference-only or included in committed artifacts.
- Current MCP surface lacks screenshots. Mitigation: document Coding-Solo baseline, attempt GoPeak, provide fallback screenshot harness if needed.
- Approval gates can get fuzzy. Mitigation: write an approval log and do not write `DESIGN_TOKENS.md` until final representative mockups are approved.

## Research Complete

Phase 3 should be planned as a five-plan sequence with two hard user checkpoints: finalist selection after concept/direction boards, and final approval before token finalization. No `.tres` or addon styling files should be touched in any plan.
