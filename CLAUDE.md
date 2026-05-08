# NeoCade Theme

NeoCade is a Godot 4.6 native UI Theme system, distributed as a drop-in addon, that styles every built-in Control with a flat Material Design 3 / MD3 Expressive aesthetic: modern, colorful, expressive, accessibility-first, with an optional "extruded flat 3D" raised variation. It is built for editor and runtime use across all 6 Godot export targets: Windows, macOS, Linux, iOS, Android, and Web/Browser.

The theme is built primarily to power the author's upcoming game, codename VirtuCade, but NeoCade is a standalone reusable addon. The canonical theme name is **NeoCade**; VirtuCade is the consuming game, not the theme.

**Visual identity locked 2026-05-04:** flat MD3 / MD3 Expressive. Hard rules: no textures, no patterns, no embossing, no painterly/leather/wood/grunge chrome, no gradients on chrome, no synthwave/neon-noir/cyberpunk, and no pixel art in the theme itself. Raised depth uses solid colors plus offset darker flat shape duplicates only.

**Current architecture, updated 2026-05-08:** one concrete `@tool class_name NeoCadeTheme extends Theme` script at `res://addons/neocade_theme/scripts/neocade_theme.gd` plus one canonical resource at `res://addons/neocade_theme/neocade_theme.tres`. There are no production subclasses, no per-direction `.gd` files, no per-style `.tres` files, no `themes/` folder, no `_dev/` folder, and no separate mobile theme resource.

`NeoCadeTheme` has 10 exports:

- Top level: `style`, `raised`, `platform`
- Style Overrides group: `base_color`, `accent_color`, `corner_radius`, `spacing`, `raised_strength`, `focus_thickness`, `outline_width`

`style` selects the built-in direction (`BUBBLE`, `BURST`, `DAYBREAK`, `PULSE`, `SLATE`, `CUSTOM`). Built-in styles apply the exported direction values and explicit direction personality; `CUSTOM` is the manual/custom mode. Setters regenerate theme entries dynamically. `platform=AUTO` auto-detects mobile with `OS.has_feature("mobile")`; `DESKTOP` and `MOBILE` force sizing. Light/dark behavior is luminance-derived from `base_color`; v1 ships dark-first styles, while formal light variants are future work.

**Current v1 resource:** one canonical `NeoCadeTheme` resource at `res://addons/neocade_theme/neocade_theme.tres`. Pulse is the recommended starter and showcase default style, but it has no architectural privilege.

**Current project state as of 2026-05-08:** autonomous implementation is complete through Phase 11 verification. Remaining work is manual release/UAT: confirm GitHub repo/release workflow settings, run release workflow when ready, perform any deferred screenshot/device checks the user wants, then archive the milestone with `$gsd-complete-milestone`.

# Progressive Discovery

Read these files when the topic is relevant. Do not duplicate or summarize their contents here.

- Current project state, active phase, blockers, and next step: `.planning/STATE.md`
- Hard constraints, current architecture, source coverage, key decisions: `.planning/PROJECT.md`
- v1 requirements and traceability: `.planning/REQUIREMENTS.md`
- Roadmap, phase statuses, and success criteria: `.planning/ROADMAP.md`
- Workflow config: `.planning/config.json`
- Research synthesis and source dossiers: `.planning/research/SUMMARY.md`, `.planning/research/SOURCES.md`
- Current architecture research and feasibility evidence: `.planning/research/GODOT-DYNAMIC-THEME-RESEARCH.md`, `.planning/spikes/dynamic-theme/`
- Current visual language research: `.planning/research/MD3-RESEARCH.md`, `.planning/research/FLAT-3D-UI-RESEARCH.md`
- Approved theme directions: `.planning/research/THEME-DIRECTIONS.md`
- Final design tokens and mobile spec: `.planning/DESIGN_TOKENS.md`, `.planning/MOBILE-DESIGN-SPEC.md`
- Coverage, stack, cross-platform, editor, and pitfall research: `.planning/research/FEATURES.md`, `.planning/research/STACK.md`, `.planning/research/CROSS-PLATFORM.md`, `.planning/research/EDITOR-COVERAGE.md`, `.planning/research/PITFALLS.md`
- Historical Phase 3 redirect notes and v0 feedback DNA: `.planning/phases/03-visual-direction-mockup-approval-gate/REDIRECTED.md`
- User-supplied inputs, not sources of truth: `.planning/inputs/NeoCade-Research-Report.md`, `.planning/inputs/NeoCade-Theme-Prototype.png`
- Godot project and showcase: `project.godot`, `showcase/showcase.tscn`
- Current addon implementation: `addons/neocade_theme/neocade_theme.tres`, `addons/neocade_theme/scripts/neocade_theme.gd`, and `addons/neocade_theme/scripts/neocade_theme_option_button.gd`
