# Phase 7: Dialogs, Popups, Advanced - Window, Popups, MenuBar, ColorPicker, Graph (desktop) - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md - this log preserves the alternatives considered.

**Date:** 2026-05-07
**Phase:** 7-Dialogs, Popups, Advanced - Window, Popups, MenuBar, ColorPicker, Graph (desktop)
**Areas discussed:** Autonomous discussion scope, Popup and Window coverage, MenuBar and PopupMenu, FileDialog and ColorPicker icons, Graph stack, Coverage and verification

---

## Autonomous Discussion Scope

| Option | Description | Selected |
|--------|-------------|----------|
| Use agent best judgement | Continue under the user's prior "use best judgement" direction and Phases 6-8 autonomous authorization. | yes |
| Pause for user decisions | Stop before Phase 7 planning and ask about each visual/behavioral choice. | |
| Narrow to technical-only defaults | Decide only implementation mechanics and leave visual defaults unspecified. | |

**User's choice:** Auto-selected recommended option under `/gsd-autonomous` and prior best-judgement delegation.
**Notes:** No hard user-decision gate was identified for Phase 7. Real-device/mobile gates remain later-phase concerns.

---

## Popup and Window Coverage

| Option | Description | Selected |
|--------|-------------|----------|
| First-class popup types | Explicitly theme Window, PopupPanel, PopupMenu, dialogs, FileDialog, TooltipPanel, and TooltipLabel by type. | yes |
| Shared Window fallback | Rely on Window/PopupPanel inheritance or parent overrides where possible. | |
| Minimal smoke coverage | Add only enough entries to change visible defaults. | |

**User's choice:** Auto-selected recommended option.
**Notes:** Pitfall 1.7 makes inheritance/parent overrides unsafe because popups are separate Windows.

---

## MenuBar and PopupMenu

| Option | Description | Selected |
|--------|-------------|----------|
| MenuBar triggers plus PopupMenu rows | Theme MenuBar states and spawned PopupMenu type entries explicitly. | yes |
| MenuBar only | Theme top-level MenuBar and rely on popup defaults. | |
| PopupMenu only | Theme menus but leave top-level MenuBar bare. | |

**User's choice:** Auto-selected recommended option.
**Notes:** Keeps editor/runtime menu behavior coherent and closes the roadmap MenuBar success criterion.

---

## FileDialog and ColorPicker Icons

| Option | Description | Selected |
|--------|-------------|----------|
| Slot-freeze first, bespoke icons | Probe Godot 4.6.2 slots before making the roadmap icon set. | yes |
| Use roadmap list only | Implement only the listed icons without probing official slots. | |
| Defer icon completeness | Theme chrome now and leave icon set gaps to a later phase. | |

**User's choice:** Auto-selected recommended option.
**Notes:** The roadmap names the required FileDialog icons and a 16-icon ColorPicker target, but implementation should freeze exact official slot names locally.

---

## Graph Stack

| Option | Description | Selected |
|--------|-------------|----------|
| Basic v1 clean coverage | Theme GraphEdit, GraphNode, and GraphFrame enough to render cleanly and remain usable. | yes |
| Deep graph editor redesign | Invest in advanced graph UX and visual behavior now. | |
| Structural-only coverage | Add entries but avoid meaningful visual tuning. | |

**User's choice:** Auto-selected recommended option.
**Notes:** Matches roadmap wording that GraphEdit is heavyweight and deeper polish can move to v1.x.

---

## Coverage and Verification

| Option | Description | Selected |
|--------|-------------|----------|
| Strict structural verifier | Add Phase 7 slot-freeze and coverage verification, deferring visual screenshot proof to Phase 9/10. | yes |
| Visual proof now | Build runtime scenes/screenshots for every popup and advanced control in Phase 7. | |
| Manual audit only | Rely on planner/executor judgement without a verifier. | |

**User's choice:** Auto-selected recommended option.
**Notes:** Phase 7 must close desktop 37/37 structurally; final visual QA remains assigned to later phases.

---

## the agent's Discretion

- Exact token-role choices, alpha values, border colors, icon metaphors, and graph colors.
- Whether each entry belongs in `BINDING_TABLE`, direct `_regenerate_theme()` calls, or helper construction.
- Exact verifier decomposition and staging.

## Deferred Ideas

- Phase 8 mobile-specific tuning.
- Phase 9/10 screenshot/editor visual proof.
- v1.x GraphEdit polish beyond basic v1.
- v2 light mode and alternate palettes.
