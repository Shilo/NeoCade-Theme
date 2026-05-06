# Phase 4: Foundation — `NeoCadeTheme` class + 5 data-only `.tres` + Fonts + Icons - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md — this log preserves the alternatives considered, including the conversational re-framings that happened mid-discussion.

**Date:** 2026-05-06
**Phase:** 04-foundation-neocadetheme-superclass-per-theme-subclasses-font
**Areas discussed:** Override-preservation strategy; Phase 4 coverage scope; Theme Editor override authoring; Icon authoring scope

---

## Override-preservation strategy

This area required two reframings driven by the user's pushback on early framings. The conversation arc:

### Q1.1 — Initial framing: clear+rebuild vs three preservation tactics

| Option | Description | Selected |
|--------|-------------|----------|
| Encode personality in code | Pure clear()+rebuild like the spike. NO Theme Editor entry overrides per .tres. Personality in a per-direction config dict. | |
| Diff-aware skip via has_*() | _regenerate runs before deserialization wins; .tres-authored entries naturally overwrite via Godot's resource load. | |
| Skip flag + manifest | .tres carries a `_overridden_slots: PackedStringArray` manifest read by _regenerate. | |
| Hybrid: per-direction _profile() + .tres data | Each .tres has only @export values + one extra `_profile_id: String`; lookup table in .gd. | |

**User's response:** *"I dont understand this at all and it worries me. Theme Editor should indeed be used for theme tres or else it ruins the point of them being unique. And it also would ruin the whole point of using Godot theming system which replies on Theme Editor. perhaps im misunderstanding you."*

**Reframing:** The user was right — the framing forced a false choice. Theme Editor authoring MUST be the primary surface; the question is HOW `_regenerate_theme()` coexists with it without destroying authored content.

### Q1.2 — Reframed: how does `_regenerate_theme()` coexist with Theme Editor overrides?

| Option | Description | Selected |
|--------|-------------|----------|
| Additive regenerate — no clear() | _regenerate sets only formula-owned slots; authored slots untouched. Clear partition between formula vs author scope. | ✓ |
| Editor-time generation | _regenerate runs only at editor time. Runtime mutation no longer auto-updates entries. Probably blocks Phase 9. | |
| Author-then-clear sentinel | _regenerate calls clear() then re-applies any slot whose StyleBox has `meta('_authored', true)`. | |

**User's choice:** Additive regenerate, no clear().

### Q1.3 — Where's the line between formula-owned and author-owned theme entries?

| Option | Description | Selected |
|--------|-------------|----------|
| Base = formulas, Variations = authored | Formulas own every slot on base Control types; type variations are Theme-Editor-authored. | ✓ (LATER SUPERSEDED) |
| Color/constants = formulas, ALL styleboxes = authored | Formulas own colors + sizes + constants; every StyleBoxFlat (base AND variation) is authored. | |
| Everything formula, nothing authored | Formulas own everything; per-direction personality encoded in .gd dict. | |

**User's choice:** Base = formulas, Variations = authored — but this answer was effectively SUPERSEDED at Q1.4 below.

### Q1.4 — Should variation styleboxes update at runtime when base_color/accent_color change?

| Option | Description | Selected |
|--------|-------------|----------|
| Variations stay baked | Authored variations bake colors at .tres authoring time. Runtime @export mutation updates only base Controls. | |
| Variations also re-derive (formula path) | Phase 4 derives variation styleboxes too, using a per-direction shape profile in .gd. | |
| Hybrid — variations bake shape, formulas paint colors | Authored variations bake shape; _regenerate iterates each authored stylebox and recomputes colors. | |

**User's response:** *"I absolutely dont understand where you are getting all these limitations. I envision all the base class NeoCadeTheme exports just to iterate through every theme override and change the relevant properties related to that exact export. so in bases like base_color and accent_color it would change whatever control overrides have a color property. what is the problem here? this logic should apply to all exports. perhaps you need to research the api more."*

**Reframing:** Researched Godot 4.6 Theme API via Context7. Confirmed `Theme.get_type_list()`, `get_*_list(type)` family, `set_*()` family, and `Resource.set_meta()/get_meta()` all support full iteration with per-property update in place. The user's vision is fully implementable — the "limitations" I was projecting were imaginary. STRUCK Q1.3's "Base = formulas, Variations = authored" partition; the right model is full-iteration with property-level binding. ALL slots (base + variations + author-added) can participate in regeneration. NO slot-level partition.

### Q1.5 — How does _regenerate_theme() decide which derived value goes into which property?

| Option | Description | Selected |
|--------|-------------|----------|
| Resource metadata tags | Every StyleBoxFlat / Color slot carries Resource metas like `_neocade_bg_role: 'accent'`. _regenerate reads metas. | ✓ (LATER MARKED TENTATIVE) |
| Slot-name binding table in .gd | Central dict in `neocade_theme.gd` maps `(theme_type, slot_name, sub_property)` → role token. | |
| Property-value heuristic | _regenerate matches current property values against a 'last-known-derived-set' to detect bindings. | |

**User's choice:** Resource metadata tags. NOTE: at Q3.3 below, user reconsidered; binding mechanism is now TENTATIVE, pending future revision.

### Q1.6 — When _regenerate_theme() encounters a slot with NO binding info, what should happen?

| Option | Description | Selected |
|--------|-------------|----------|
| Leave untouched | Untagged/unbound slots are escape hatch — left alone by _regenerate. | ✓ |
| Best-effort heuristic | Untagged slots run through a fallback heuristic. | |
| Strict warn | Untagged slots are skipped AND _regenerate prints a warning at editor time. | |

**User's choice:** Leave untouched. Untagged slots are the artist's escape hatch.

---

## Phase 4 coverage scope

### Q2.1 — What should Phase 4 actually deliver in terms of Control coverage?

| Option | Description | Selected |
|--------|-------------|----------|
| Infrastructure + minimum 37/37 baseline | Phase 4 ships class + formulas + helpers + baseline pass for all 37 Controls so SC#7 passes. Phases 5/6/7 refine. | ✓ |
| Infrastructure only — defer SC#7 to Phase 7 | Phase 4 ships infrastructure + smoke-test on Button only. SC#7 reinterpreted as cumulative through Phase 7. | |
| Complete base coverage for ALL 37 + all 13 variations | Phase 4 authors every base + every variation baseline. Phases 5/6/7 = pure polish. | |

**User's choice:** Infrastructure + minimum 37/37 baseline.

### Q2.2 — What's the depth of Phase 4's baseline pass for each Control?

| Option | Description | Selected |
|--------|-------------|----------|
| Full formula state coverage | Phase 4 formulas author EVERY required slot for every Control. Phases 5/6/7 are polish (icons, variations, Pitfall 1.1). | ✓ |
| Keystone full + others placeholder | Phase 4 = full state coverage for Buttons/Inputs/Labels/Panels; placeholder for the rest. | |
| One stylebox per Control + colors | Phase 4 = one canonical stylebox per Control + all colors + font_sizes + constants. | |

**User's choice:** Full formula state coverage.

### Q2.3 — What does Phase 4 do for the 13 type variations?

| Option | Description | Selected |
|--------|-------------|----------|
| Register + minimum font/size set | Phase 4 calls Theme.set_type_variation + sets fonts explicitly. Stylebox/color/constants auto-inherit from base. | ✓ |
| Register + full formula baseline per variation | Phase 4 also authors a formula-derived baseline stylebox + color + font set per variation. | |
| Register only — no entries | Phase 4 calls set_type_variation only. Fonts deferred to Phase 5. | |

**User's response:** *"wait, where did we get the type variations? is that built in godot type variations? if so, just do recommended"*

**Notes:** Confirmed that `Theme.set_type_variation(name, base_type)` is built-in Godot API; the 13 specific variation NAMES (PrimaryButton, HeaderLarge, etc.) are NeoCade-defined per REQUIREMENTS TYPEVAR-01..04. User then locked the recommended option.

---

## Theme Editor override authoring

### Q3.1 — How should artists tag slots with `_neocade_*` metas? (initial framing)

| Option | Description | Selected |
|--------|-------------|----------|
| EditorInspectorPlugin sidecar | Phase 4 ships an EditorInspectorPlugin with dropdowns for binding properties to roles. | ✓ (LATER REJECTED) |
| @tool 'Tag this slot' button in Inspector | Phase 4 adds a static @tool helper method callable from a sidecar `.gd`. | |
| Naming-convention slot binding | Slot names themselves carry the binding; iteration parses slot names. | |

**Initial choice:** EditorInspectorPlugin sidecar.

### Q3.2 — How should the addon be structured to host the EditorInspectorPlugin?

| Option | Description | Selected |
|--------|-------------|----------|
| Two addons split | `addons/neocade_theme/` (no plugin.cfg) + `addons/neocade_theme_authoring/` (plugin.cfg). | |
| One addon + optional plugin.cfg | Single addon with optional plugin; consumers can disable. | |
| EditorScript helper (no Inspector plugin) | Sidecar EditorScript run via Ctrl+Shift+X; offers TagDialog. | |

**User's response:** *"What is the EditorInspectorPlugin for? i dont understand why its needed. please explain."*

**Reframing:** Explained with a concrete example (StyleBoxFlat with `_neocade_bg_role: 'accent'` meta showing how `_regenerate_theme()` reads the meta and updates `bg_color` when `accent_color` changes; without the plugin, artists would manually type meta names in Godot's built-in Inspector Metadata section). User then realized the plugin is purely authoring-time UX, not required for runtime.

### Q3.3 — Given the plugin is purely authoring-time UX, do we ship it?

| Option | Description | Selected |
|--------|-------------|----------|
| Yes, ship as separate authoring addon | Two-addon structure with plugin.cfg in the authoring sibling. | |
| No, skip the plugin | Phase 4 ships only the consumer addon. Manual tagging via built-in Metadata section. | ✓ |
| Defer plugin to v1.x | Same as skip but explicitly v1.x scope. | |

**User's response:** *"Skip the plugin for now. you may indefinitely defer it. I actually dont know if the metadata approach is even the right approach. we will discuss it again later. I actually think a better approach would be that NeoCadeTheme directly applies the exports to the themed overrides based on a set of property names or something similar. but we can discuss that as a revision later. for now just assume only you will author themes"*

**Outcome locked:**
- No EditorInspectorPlugin in v1; deferred indefinitely.
- Metadata-tag binding mechanism is TENTATIVE (Q1.5's answer is now marked TENTATIVE in CONTEXT.md D-03). User signaled a possible alternative: property-name-convention binding (NeoCadeTheme applies exports based on property names directly, no per-resource metas).
- Phase 4 (and Phases 5/6/7) author themes programmatically — Claude does the authoring, no human-artist UX surface required.
- For Phase 4 planning purposes: prefer the simplest workable binding (slot-name + property-name binding table in `.gd`), document as REVISABLE.

---

## Icon authoring scope

### Q4.1 — When does Phase 4 author icons?

| Option | Description | Selected |
|--------|-------------|----------|
| Button-family only + import contract | Phase 4 authors ~10 Button-family SVGs + the import contract. Phases 5/6/7 add icons by following the contract. | ✓ |
| All ~25-40 upfront | Phase 4 authors every icon listed in ICON-02. Phases 5/6/7 only wire icons. | |
| Seed set + per-phase top-up | Phase 4 authors ~15 highest-traffic icons + import contract. | |

**User's choice:** Button-family only + import contract.

### Q4.2 — More questions about Icon authoring, or wrap up?

**User's choice:** I'm ready for context. (Wrap up; remaining 4 deferred gray areas — Regeneration trigger sequence, Font/FontVariation resource shape, Scaffold deletion sequencing, README scope — are Claude's discretion or covered implicitly in DESIGN_TOKENS.md / Phase 4 SC enumeration.)

---

## Claude's Discretion

The following Phase 4 decisions are intentionally left to Claude per the discussion outcome and the explicit "for now just assume only you will author themes" statement:

- Implementation detail of the binding table structure (per-Control nested Dictionary vs flat slot-name keys vs sub-property index — pick simplest that works).
- Reentry-guard pattern for `_regenerate_theme()` setter recursion (the spike uses a `_regenerating := false` flag; production may use that or a cleaner mechanism).
- When `_regenerate_theme()` runs (the spike does `_init()` + setters; production may use setter-only with `Engine.is_editor_hint()` aware behavior, deferred call, or explicit `regenerate()` public method — pick what's correct for `.tres` deserialization order).
- SVG authoring approach (hand-written SVG XML vs parametric template generation — both are Claude's-authoring; choose based on icon style consistency).
- Exact filename casing for FontVariation resources (`Inter-Variable.tres` is FONT-01; variation file naming convention TBD).
- README structure beyond required content (consumer pattern + Pulse + UD-2 + custom authoring); polish to v1 scope happens in Phase 11.
- Scaffold `.tres` deletion sequencing (delete-first vs swap-and-delete vs keep-as-safety-net) — DESIGN_TOKENS §12.2 says delete in the FIRST task; Claude picks the atomic-swap pattern that keeps `main.tscn` valid throughout.

## Deferred Ideas

(All explicitly logged in CONTEXT.md `<deferred>` section.)

- EditorInspectorPlugin — deferred indefinitely.
- Binding mechanism revision (property-name-convention alternative) — revisit after Phase 4 implementation experience.
- Pitfall 1.1 state-combo authoring (`pressed_focus`, `checked_focus`, `hover_pressed`) — Phase 5 polish.
- Per-direction Theme Editor variation styleboxes (PrimaryButton/GhostButton/HeaderLarge/CardPanel etc.) — Phases 5/6/7.
- Bespoke SVG icons for non-Button Controls (Tree, ColorPicker, FileDialog, ScrollBar, TabBar) — Phases 6/7.
- Mobile branch validation + tap-target audit — Phase 8.
- Showcase scene + theme/variation toggles — Phase 9.
- Cross-platform export QA + WCAG audit + COV-10 zero-fallback verification — Phase 10.
- Full v1 README + CHANGELOG `[Unreleased]` body — Phase 11 distribution.
- Asset Library submission — REJECTED for v1.
- Light mode + alternate palettes + additional theme directions — v2.
