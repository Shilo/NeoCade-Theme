# Phase 8: Mobile Variant Token Block + Tap-Target Audit - Context

**Gathered:** 2026-05-07
**Status:** Ready for planning

<domain>
## Phase Boundary

Phase 8 completes the mobile sizing branch of the existing dynamic `NeoCadeTheme` architecture. The deliverable is not a new mobile theme file; it is verified behavior when a single direction resource resolves as `platform=MOBILE` or `platform=AUTO` on mobile.

This phase must make mobile entries measurably accessible: 48px minimum tap targets where the theme can enforce them, mobile typography and spacing deltas documented, desktop/mobile toggling proven, and all five direction resources preserving identity under mobile regeneration. It does not perform real-device export QA, final screenshot matrices, or native iOS/Android visual mimicry.

</domain>

<decisions>
## Implementation Decisions

### Autonomous Discussion Scope
- **D-01:** Phase 8 discussion runs under the user-authorized autonomous Phases 6-8 lane. Use agent best judgement for sizing mechanics and documentation details; do not introduce user checkpoints unless implementation reveals a true hard gate.
- **D-02:** Phase 8 may proceed without resolving UD-5 real-device availability. Real-device Android/iOS confirmation is Phase 10 scope; Phase 8 proves deterministic theme-side mobile sizing in local Godot 4.6.2.

### Dynamic Mobile Architecture
- **D-03:** Keep the final architecture: one concrete `addons/neocade_theme/neocade_theme.gd` class plus five data-only direction `.tres` resources. Do not add `neocade_mobile_theme.tres`, per-density theme files, per-platform scripts, subclasses, `_dev/`, `themes/`, or a root fallback `neocade_theme.tres`.
- **D-04:** Forced `platform=DESKTOP` and `platform=MOBILE` are the deterministic QA paths. `platform=AUTO` remains the recommended consumer default, but verification must explicitly test forced modes so results do not depend on the host machine.
- **D-05:** Platform selection should affect sizing, spacing, typography scale, and minimum target constants only. Palette, direction personality, semantic color roles, icon vocabulary, and corner-radius identity must remain stable across desktop/mobile.
- **D-06:** If the AUTO resolver is hardened, keep it Godot-feature based. Do not read `DisplayServer.screen_get_scale()`, system DPI, native iOS/Android APIs, JavaScript bridges, or `EditorSettings` in the theme class.

### Mobile Sizing Defaults
- **D-07:** Mobile target floor is 48px on both axes for interactive Controls wherever theme entries can enforce size. This reconciles iOS HIG 44pt and Material 3 48dp by choosing the stricter/common practical value.
- **D-08:** Preserve the existing mobile type direction unless a local verifier proves a mismatch: body 16px, label/caption 14px, kicker 13px, title/headline values documented explicitly. Desktop remains body 14px and label 12px.
- **D-09:** Mobile spacing grows by density rather than new visual identity: `densityScale=1.5`, `tapPadding=12`, and spacing values at `space.4` and above should be +50% relative to desktop. Small hairline/stroke/focus widths should remain integer and visually crisp.
- **D-10:** Corner radii are brand identity. Do not scale corner radii between desktop and mobile unless the existing direction export value itself changes; mobile should feel like the same NeoCade direction with larger ergonomics.
- **D-11:** Raised mode remains orthogonal to platform mode. Phase 8 must prove `raised=true/false` can toggle separately from `platform=DESKTOP/MOBILE/AUTO` without stale state or entry loss.

### Tap-Target Audit
- **D-12:** The tap-target audit should be a phase-local helper that loads a direction theme, forces `platform=MOBILE`, regenerates entries, and evaluates each interactive Control against a documented per-type sizing formula.
- **D-13:** The audit must distinguish interactive, display-only, and layout-only scorecard rows. Interactive rows must pass the 48px rule; non-interactive rows should be documented as not applicable rather than padded into fake tap targets.
- **D-14:** The audit should use theme-side evidence that Godot actually exposes: `minimum_size` constants, StyleBox content margins, row/tab/grabber/thumbnail constants, and relevant per-type separation metrics. Where Godot exposes no enforceable minimum for a type, document the limitation and verify the closest theme-controlled proxy.
- **D-15:** The report must be strict enough to fail if any mobile interactive type falls below 48px on either axis in the computed theme-side proxy. Phase 8 acceptance is 100% pass for the enforceable interactive set.

### Documentation and Test Scene
- **D-16:** Create `MOBILE-DESIGN-SPEC.md` at the repository root, matching the project instruction path. It must document concrete desktop-vs-mobile deltas for all 37 scorecard rows and every type variation affected by mobile sizing.
- **D-17:** `MOBILE-DESIGN-SPEC.md` must explicitly state that mobile is an `@export platform` mode on the same direction resources, not a sibling `.tres` file, and that Android density buckets are handled by Godot project scaling/stretch configuration rather than per-density theme resources.
- **D-18:** The test-scene toggle can be a minimal Phase 8 proof fixture in `main.tscn`/support script if needed. It should cycle one direction through DESKTOP/MOBILE/AUTO and independently toggle `raised`, proving clean regeneration. The full showcase composition remains Phase 9.
- **D-19:** Do not add visible in-app explanatory prose beyond the controls needed to test the toggle. The scene should be a working test surface, not a marketing explainer.

### Verification
- **D-20:** Follow Phase 6/7 verifier discipline: phase-local helpers, staged assertions, full-stage zero pending groups, direction-resource checks after any ResourceSaver operation, and committed summary/verification artifacts.
- **D-21:** Verification must include all five direction resources in forced mobile mode so no direction-specific export value or manual override defeats the mobile sizing contract.
- **D-22:** Phase 8 should update requirements/docs traceability for `MOBILE-01..08`, `DOCS-02`, and `TYPEVAR-06`; final cross-platform screenshots/export validation remain Phase 10.

### the agent's Discretion
- Choose exact helper filenames, verifier stage names, and audit table format.
- Decide whether to implement mobile sizing through new token keys, existing token values, BINDING_TABLE recipes, direct calls after the table walk, or small helper functions, as long as the public export surface stays locked.
- Choose the minimal scene/script changes needed for toggle proof without pre-building the Phase 9 showcase.

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Project and Requirements
- `.planning/STATE.md` - Current phase and autonomous continuation status.
- `.planning/PROJECT.md` - Hard architecture constraints, mobile-as-platform-mode truth, no separate mobile `.tres`, and no-shadow/no-texture policy.
- `.planning/ROADMAP.md` - Phase 8 goal, requirements, and success criteria.
- `.planning/REQUIREMENTS.md` - `MOBILE-01..08`, `DOCS-02`, `TYPEVAR-06`, and cumulative architecture requirements.
- `.planning/config.json` - Workflow configuration and Phases 6-8 autonomous authorization.

### Research Canon
- `.planning/research/CROSS-PLATFORM.md` - Mobile tap-target/type/spacing numbers, per-target rationale, density-bucket guidance, and cross-platform constraints.
- `.planning/research/GODOT-DYNAMIC-THEME-RESEARCH.md` - Platform resolver, forced platform modes, AUTO behavior, and dynamic regeneration constraints.
- `.planning/research/PITFALLS.md` - DPI/scaling pitfalls, focus overlay, theme toggle state risk, and tap-target verification hazards.
- `.planning/research/FEATURES.md` - 37-row control scorecard and type variation expectations.
- `.planning/research/FLAT-3D-UI-RESEARCH.md` - Mobile-friendly flat UI density and raised/flat guidance.
- `.planning/research/STACK.md` - Addon layout and technology constraints; note that older static mobile-file wording is superseded by PROJECT.md and REQUIREMENTS.md.

### Prior Phase Evidence
- `.planning/phases/07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr/07-VERIFICATION.md` - Confirms desktop structural coverage, direct font wiring, direction-resource shape, and deferred visual proof boundary.
- `.planning/phases/07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr/07-CONTEXT.md` - Carries architecture invariants and verification discipline.
- `.planning/phases/07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr/07-RESEARCH.md` - Latest full-slot evidence after desktop completion.
- `.planning/phases/07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr/*-SUMMARY.md` - Execution summaries for current implementation state.

### Implementation Files
- `addons/neocade_theme/neocade_theme.gd` - Existing platform enum, `_resolve_platform()`, `_platform_tokens()`, BINDING_TABLE, direct font calls, and regeneration engine.
- `addons/neocade_theme/pulse_neocade_theme.tres` - Recommended starter direction resource to use for deterministic smoke tests.
- `addons/neocade_theme/slate_neocade_theme.tres` - Peer direction resource.
- `addons/neocade_theme/bubble_neocade_theme.tres` - Peer direction resource.
- `addons/neocade_theme/daybreak_neocade_theme.tres` - Peer direction resource.
- `addons/neocade_theme/burst_neocade_theme.tres` - Peer direction resource.
- `main.tscn` - Existing scene scaffold where minimal platform/raised toggle proof may be wired.
- `MOBILE-DESIGN-SPEC.md` - Phase 8 deliverable to create at repository root.

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- `NeoCadeTheme.Platform` already exposes `DESKTOP`, `MOBILE`, and `AUTO`.
- `_resolve_platform()` currently resolves AUTO through Godot feature flags and can be hardened without adding dependencies.
- `_platform_tokens()` already defines mobile values such as `buttonMin=48`, `primaryButtonMin=56`, `inputMin=56`, `body=16`, `label_=14`, `rowMin=56`, `tabMin=48`, `thumbnailSize=128`, `tapPadding=12`, and `densityScale=1.5`.
- BINDING_TABLE recipes already read `tokens.*`, so many mobile deltas can be validated or corrected through token usage rather than duplicating the whole desktop table.
- Phase 7 helpers provide a strong template for staged verification and direction resource shape assertions.

### Established Patterns
- Public export surface is locked at 9 properties.
- Theme regeneration is additive; no `Theme.clear`.
- Font entries that BINDING_TABLE cannot express must be direct `set_font` / `set_font_size` calls after the table walk.
- Direction personality is export/data driven. Platform mode should not change direction identity.

### Integration Points
- Production changes connect through `addons/neocade_theme/neocade_theme.gd`.
- Phase 8 verification helpers belong under `.planning/phases/08-mobile-variant-token-block-tap-target-audit-updated-for-dyna/helpers/`.
- Root `MOBILE-DESIGN-SPEC.md` becomes the handoff document for Phase 9/10.
- Minimal platform/raised toggle proof can touch `main.tscn` and, if needed, a phase-appropriate support script, but should avoid prematurely building the full showcase.

</code_context>

<specifics>
## Specific Ideas

- Treat Phase 8 as a contract phase: concrete numbers, audit tables, and forced-platform tests are more valuable than visual flourish.
- Mobile should feel like the same arcade direction with more breathing room and safer touch targets, not like native iOS/Android.
- Use `platform=MOBILE` as the deterministic local proof path and document `platform=AUTO` as consumer-friendly behavior.

</specifics>

<deferred>
## Deferred Ideas

- Real Android/iOS/Web device/browser validation remains Phase 10 and depends on UD-5.
- Full showcase visual coverage and screenshot decks remain Phase 9/10.
- Any high-contrast mobile preset, native Material You colors, JavaScript bridge, or DPI-adaptive theme generation is v2+.

</deferred>

---

*Phase: 8-Mobile Variant Token Block + Tap-Target Audit*
*Context gathered: 2026-05-07*
