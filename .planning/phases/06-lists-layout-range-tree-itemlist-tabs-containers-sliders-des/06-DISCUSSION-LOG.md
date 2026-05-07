# Phase 6: Lists, Layout, Range - Tree, ItemList, Tabs, Containers, Sliders (desktop) - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md - this log preserves the alternatives considered.

**Date:** 2026-05-07
**Phase:** 6 - Lists, Layout, Range - Tree, ItemList, Tabs, Containers, Sliders (desktop)
**Areas discussed:** Tree + ItemList Density, Tabs + Foldable Headers, Range + Scroll Affordances, Container Boundaries

---

## Gray Area Selection

| Option | Description | Selected |
|--------|-------------|----------|
| Tree + ItemList Density | Editor-dense data view vs more spacious arcade UI; selected, hovered, focused, cursor, guides, and multi-level row treatment. | ✓ |
| Tabs + Foldable Headers | Active tab shape, inactive tab restraint, drag/drop marks, tab scrolling/menu icons, and FoldableContainer header personality. | ✓ |
| Range + Scroll Affordances | Sliders, progress bars, scrollbars, grabber thickness, track visibility, arrow/icon presence, and raised-mode tactility. | ✓ |
| Container Boundaries | ScrollContainer focus/panel treatment, SplitContainer handles, MarginContainer constants, and how much chrome is too much for layout surfaces. | ✓ |

**User's choice:** "none, use all bust judgement" - interpreted as "no areas to discuss; use all and use best judgment."

**Notes:** The user explicitly delegated Phase 6 implementation taste decisions. The workflow therefore captured agent-discretion decisions for all four gray areas instead of asking follow-up questions.

---

## Tree + ItemList Density

| Option | Description | Selected |
|--------|-------------|----------|
| Editor-dense baseline | Preserve dense, scan-friendly data views suitable for inspector/file/tree workflows; NeoCade personality comes through state treatment and subtle shape. | ✓ |
| Spacious arcade menu | Larger rows and bolder surfaces; better for game menus but risks weakening editor/runtime universality. | |
| You decide | Let the agent choose based on project canon. | ✓ |

**User's choice:** Delegated to agent judgment.

**Notes:** CONTEXT.md locks a dense but readable baseline, with selected rows clear and cursor overlays transparent or semi-transparent.

---

## Tabs + Foldable Headers

| Option | Description | Selected |
|--------|-------------|----------|
| Shared tab construction | TabBar and TabContainer share overlapping stylebox logic; active tabs connect visually to content. | ✓ |
| Distinct tab families | Standalone TabBar and TabContainer get more divergent visual treatments. | |
| You decide | Let the agent choose based on project canon. | ✓ |

**User's choice:** Delegated to agent judgment.

**Notes:** CONTEXT.md locks shared TabBar/TabContainer grammar and a FoldableContainer header that borrows disclosure language from Tree rather than Button.

---

## Range + Scroll Affordances

| Option | Description | Selected |
|--------|-------------|----------|
| Subtle tactile controls | Tracks stay calm; grabbers/fills carry the tactile/accent role; raised mode is restrained. | ✓ |
| Bold arcade controls | More prominent tracks and lifted handles; more expressive but potentially noisy in editor-like contexts. | |
| You decide | Let the agent choose based on project canon. | ✓ |

**User's choice:** Delegated to agent judgment.

**Notes:** CONTEXT.md locks subtle raised behavior for sliders/scrollbars and official-slot-only icon wiring.

---

## Container Boundaries

| Option | Description | Selected |
|--------|-------------|----------|
| Minimal structural chrome | Containers get focus, separation, and usable constants without turning every layout surface into a card. | ✓ |
| Framed surface-heavy chrome | More panel boundaries everywhere; visually rich but risks nested-card clutter. | |
| You decide | Let the agent choose based on project canon. | ✓ |

**User's choice:** Delegated to agent judgment.

**Notes:** CONTEXT.md locks minimal container chrome, with layout-only containers intentionally boring.

---

## Agent's Discretion

- User delegated all Phase 6 gray-area choices.
- Agent selected all four areas and made conservative decisions aligned with PROJECT.md, DESIGN_TOKENS.md, Phase 5 verification, and Godot slot evidence.
- Downstream agents should proceed without re-asking taste questions unless official Godot 4.6 slot discovery reveals a hard ambiguity.

## Deferred Ideas

- Popup/dialog/advanced Control polish remains Phase 7.
- Mobile branch tuning remains Phase 8.
- Showcase visual QA remains Phase 9.
- Cross-platform and final accessibility QA remains Phase 10.
