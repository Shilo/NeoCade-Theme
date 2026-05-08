# Godot Dynamic Theme Architecture Research

Phase 03.2 validates whether NeoCade v1 can ship a dynamic Godot Theme architecture: one `@tool extends Theme` superclass with exported knobs, per-direction subclasses that call `super._regenerate()` first, and saved `.tres` instances users can edit without production addon changes during research.

## Scope and Non-Scope

**Scope**

- Verify export-driven `Theme` regeneration from `@export` properties.
- Confirm subclass extension mechanics for base coverage plus personality overrides.
- Validate runtime application and saved `.tres` serialization behavior.
- Define platform resolution for `DESKTOP`, `MOBILE`, and `AUTO`, including Web ambiguity.
- Port the relevant passivestar editor-theme formula pattern into runtime-safe pseudocode.
- Produce a research-only spike under `.planning/spikes/dynamic-theme/`.

**Non-Scope**

- No production edits under `addons/neocade_theme/`.
- No final `neocade_theme.tres`, `neocade_mobile_theme.tres`, fonts, icons, screenshots, or mockups.
- No editor plugin dependency, JavaScript bridge, or `EditorInterface` runtime contract.
- No final visual token decisions. Phase 3.4 remains the mockup approval gate.

## Source Map and Provenance

All claims in this file must use source labels. Source labels are stable shorthand for the material inspected during Phase 03.2.

| Label | Source | Use in this document | Status |
|-------|--------|----------------------|--------|
| `CTX-03.2` | `.planning/phases/03.2-godot-dynamic-theme-architecture-research/03.2-CONTEXT.md` | User decisions and gray-area resolutions | Read |
| `PLAN-03.2` | `.planning/phases/03.2-godot-dynamic-theme-architecture-research/*-PLAN.md` | Execution requirements and review-converged acceptance criteria | Read |
| `RES-03.2` | `.planning/phases/03.2-godot-dynamic-theme-architecture-research/03.2-RESEARCH.md` | Official-doc research summary | Read |
| `PROJECT` | `.planning/PROJECT.md` | Hard constraints and research charter | Read |
| `ROADMAP` | `.planning/ROADMAP.md` | Phase goal and downstream dependency context | Read |
| `SOURCES` | `.planning/research/SOURCES.md` | Existing source dossier and Section 13 update target | Read |
| `GODOT-EDITOR-THEME` | `C:/Programming_Files/Godot/godot-master/editor/themes/editor_theme_manager.cpp` and `.h` | Editor theme generation flow and anti-pattern boundaries | Read |
| `GODOT-COLOR-MAP` | `C:/Programming_Files/Godot/godot-master/editor/themes/editor_color_map.cpp` | Named color derivation context | Not needed for Plan 02 lock; no direct runtime dependency |
| `GODOT-THEME-RUNTIME` | `C:/Programming_Files/Godot/godot-master/scene/resources/theme.*`, `theme_db.cpp`, `theme_owner.cpp` | Runtime Theme APIs and fallback model | Read |
| `GODOT-STYLEBOX` | `C:/Programming_Files/Godot/godot-master/scene/resources/style_box*.{h,cpp}` | `StyleBoxFlat` mutation and shadow constraints | Read |
| `MINIMAL-DISSECTION` | `.planning/research/MINIMAL-THEME-DISSECTION.md` | `godot-minimal-theme` bar and formula anchors | Read |
| `SPIKE-03.2` | `.planning/spikes/dynamic-theme/*` | Dynamic Theme evidence | Read / PASS |

**Citation contract:** final locked claims must include at least one source label. Spike-only claims must name `SPIKE-03.2` plus the evidence mode: `EXECUTED`, `STATIC-FALLBACK`, or `SIMULATED`.

## Strict Feasibility Gate

Phase 4 may treat the dynamic architecture as locked only if every strict check passes. A blocked or failed row makes the outcome **NOT LOCKED** and requires a fallback recommendation for user approval.

| Check | Required evidence | Current status | Result |
|-------|-------------------|----------------|--------|
| Export-driven regeneration | Changing exported `base_color`, `accent_color`, `raised`, or `platform` causes required subset entries to regenerate | Executed in Godot 4.6.2; see `SPIKE-03.2/VERIFY-RESULTS.md` | PASS |
| Subclass super-first overrides | Good subclass calls `super._regenerate()` and keeps base entries while overriding personality entries | Executed; good subclass kept required entries and added direct override marker | PASS |
| Negative subclass failure | Bad subclass skipping `super._regenerate()` leaves detectable coverage gaps | Executed; verifier caught LineEdit/Tree/Window gaps | PASS |
| Runtime application | Saved dynamic `.tres` can be loaded and assigned to a Control tree | Executed; Button resolved stylebox through Control tree | PASS |
| Serialization behavior | Export values and script references survive saved `.tres` round trip, with generated entries understood as runtime/editor-time output | Executed; saved resources inspected and `user://` roundtrip passed | PASS |
| Platform detection | `DESKTOP`, `MOBILE`, and `AUTO` paths resolve with local, simulated, and Web-ambiguous cases documented | Executed; simulated Web desktop/mobile/ambiguous and local fallback covered | PASS |

## Editor Theme Generation Flow

Godot's editor theme generation is a useful model but not a portable runtime dependency.

**Flow extracted from source (`GODOT-EDITOR-THEME`):**

1. `_create_theme_config()` reads editor settings for style, color preset, spacing preset, `base_color`, `accent_color`, `contrast`, icon saturation, corner radius, spacing, and touchscreen optimization settings (`editor_theme_manager.cpp:240-445`).
2. Non-custom presets rewrite `base_color`, `accent_color`, contrast, extra-border toggles, and icon saturation; system theme/accent can also override those values (`editor_theme_manager.cpp:293-393`).
3. Generated config values derive dark-mode flags, base margins, popup margins, window border margins, and other scale-adjusted constants, many multiplied by `EDSCALE` (`editor_theme_manager.cpp:438-445`).
4. `generate_theme()` creates a base `EditorTheme`, optionally merges an editor custom theme from `interface/theme/custom_theme`, and returns the generated resource (`editor_theme_manager.cpp:691-710`).
5. `is_generated_theme_outdated()` tracks editor-settings groups that should cause regeneration (`editor_theme_manager.cpp:714-729`).

**Adopt for NeoCade:** generated themes can be deterministic products of a small configuration object; cache/outdated checks are useful conceptually; formulas should live in helper methods so subclasses can tune them without copying a whole matrix.

**Reject for NeoCade:** do not read `EditorSettings`, `EditorInterface`, `DisplayServer` system theme colors, or `EDSCALE` in the shipped runtime architecture. NeoCade exports (`base_color`, `accent_color`, `raised`, `platform`) are the source of truth.

**Open:** performance of full regeneration for all 35 Controls is not measured until an executable Godot spike runs; Plan 04 records a representative subset timing and leaves full-matrix timing to Phase 4.

## Runtime Theme API Surface

Godot's runtime `Theme` resource exposes exactly the item families NeoCade needs: icons, styleboxes, fonts, font sizes, colors, constants, generic theme items, type variations, and clearing/resetting (`GODOT-THEME-RUNTIME`, `theme.h:133-232`; method bindings in `theme.cpp:1834-1910`).

| Item family | Runtime API | Notes for NeoCade |
|-------------|-------------|-------------------|
| Styleboxes | `set_stylebox`, `get_stylebox`, `has_stylebox`, `clear_stylebox` | Primary surface for Control chrome; `set_stylebox` records by item name and theme type and emits theme-changed (`theme.cpp:315-340`). |
| Colors | `set_color`, `get_color`, `has_color`, `clear_color` | Required for text, caret, selection, separators, icons where no texture is used. |
| Fonts | `set_font`, `get_font`, `has_font`, `clear_font` | v1 should set Inter once through theme defaults and per-type entries where required. |
| Font sizes | `set_font_size`, `get_font_size`, `has_font_size`, `clear_font_size` | Desktop/mobile divergence belongs here and in constants. |
| Constants | `set_constant`, `get_constant`, `has_constant`, `clear_constant` | Margins, separations, line widths, grabber sizes, and popup offsets. |
| Icons | `set_icon`, `get_icon`, `has_icon`, `clear_icon` | Needed for check/radio/submenu/close icons, but Phase 03.2 spike may use null/no-icon placeholders. |
| Type variations | `set_type_variation`, `is_type_variation`, `clear_type_variation` | Later phases can use this for named variants, but the Phase 03.2 subclass feasibility check is separate. |
| Reset | `clear()` / `reset_state()` | Useful in `_regenerate()` to prevent stale entries when exports change (`theme.cpp:1781-1830`). |

Runtime resolution first searches owner-attached themes along the Control/Window branch, then global themes in the active context, then fallback theme values (`theme_owner.cpp:228-263`). `ThemeDB` always creates a default theme fallback and accepts a project custom theme path (`theme_db.cpp:51-94`). This means an incomplete dynamic theme may appear to "work" because fallback fills gaps; the strict verifier must use `has_*` checks on the resource itself, not visual appearance alone.

`StyleBoxFlat` is safe as the v1 workhorse: source exposes `bg_color`, border color/width, corner radii, draw center, expand/content margins through base `StyleBox`, shadow color/size/offset, and anti-aliasing (`GODOT-STYLEBOX`, `style_box_flat.h:38-106`; bindings `style_box_flat.cpp:649-734`). Drawing only renders shadow when `shadow_size > 0` (`style_box_flat.cpp:459-462`, `532-542`), so NeoCade's no-shadow rule should set `shadow_size = 0` in research spikes and final generated styleboxes.

## Passivestar Formula Port

`godot-minimal-theme` uses symbolic formula extraction around `_get_base_color(brightness_offset, saturation_multiplier)` (`MINIMAL-DISSECTION:131-150`). The key model is not the exact editor settings, but the fact that a small set of color knobs can derive a tonal surface ramp (`MINIMAL-DISSECTION:104-110`).

**Ported runtime-safe recipe:**

```gdscript
func _derive_surface(brightness_offset: float = 0.0, saturation_multiplier: float = 1.0) -> Color:
	var color := Color(base_color)
	var hsv := {
		"h": color.h,
		"s": clampf(color.s * saturation_multiplier, 0.0, 1.0),
		"v": color.v,
	}
	var polarity := 1.0 if color.get_luminance() < 0.5 else -1.0
	hsv.v = clampf(hsv.v + brightness_offset * contrast_strength * polarity, 0.0, 1.0)
	return Color.from_hsv(hsv.h, hsv.s, hsv.v, color.a)
```

**NeoCade substitutions:**

- `base_color` comes from the exported theme resource, not `EditorSettings`.
- `accent_color` is used directly for focus/accent states and may be lightly mixed into hovered/pressed states per subclass hooks.
- `contrast_strength` is a superclass or subclass tunable, not the editor's contrast setting.
- `raised` chooses between a flat tonal ramp and a stronger border/elevation treatment; it does not enable shadow chrome in v1.
- `platform` changes size constants and font sizes, not the semantic color ramp.

**Representative surface aliases for the spike:**

| Alias | Formula |
|-------|---------|
| `surface_lowest` | `_derive_surface(-1.15, 0.90)` |
| `surface_low` | `_derive_surface(-0.55, 0.95)` |
| `surface_base` | `_derive_surface(0.00, 1.00)` |
| `surface_raised` | `_derive_surface(0.30, 0.90)` |
| `surface_overlay` | `_derive_surface(0.55, 0.80)` |

Plan 03 is unblocked: this formula port is now populated and avoids editor-only dependencies.

## Dynamic Theme Spike Evidence

Spike artifacts live under `.planning/spikes/dynamic-theme/` only (`SPIKE-03.2`). They are research evidence, not addon implementation.

| Artifact | Role |
|----------|------|
| `README.md` | Research-only boundary, run commands, limitations, and representative subset declaration. |
| `SpikeNeoCadeTheme.gd` | Dynamic superclass prototype with exported knobs, formula-derived surfaces, platform resolution, and required subset generation. |
| `PrizePopSpikeNeoCadeTheme.gd` | Positive subclass: calls `super._regenerate()` first and adds a documented direct Button override marker. |
| `BrokenNoSuperSpikeTheme.gd` | Negative subclass: skips `super._regenerate()` so missing entries can be detected. |
| `prize_pop_spike_neocade_theme.tres` | Saved positive Theme resource. |
| `broken_no_super_spike_theme.tres` | Saved negative Theme resource. |
| `dynamic_theme_spike.tscn` | Visual scene using Button, OptionButton, CheckBox, LineEdit, Tree, PopupMenu, Window, and HScrollBar. |
| `verify_dynamic_theme_spike.gd` | Headless verifier script for strict checks. |

| Evidence item | What must be shown | Evidence mode | Status | Notes |
|---------------|--------------------|---------------|--------|-------|
| Export-driven regeneration | Required representative controls change when exports change | EXECUTED | READY FOR PLAN 04 GATE | Verified once during Plan 03 smoke run; Plan 04 records formal results. |
| Correct subclass | Good subclass retains superclass entries and adds personality overrides | EXECUTED | READY FOR PLAN 04 GATE | `PrizePopSpikeNeoCadeTheme` sets `Button.prize_pop_direct_override_marker`. |
| Negative subclass | Bad subclass omits `super._regenerate()` and verifier catches missing entries | EXECUTED | READY FOR PLAN 04 GATE | `BrokenNoSuperSpikeTheme` only sets Button entries. |
| Runtime saved `.tres` | Saved resource loads and can be applied to a scene/control tree | EXECUTED | READY FOR PLAN 04 GATE | Production addon untouched. |
| Serialization | Saved resource records script refs and exported values | EXECUTED | READY FOR PLAN 04 GATE | Verifier saves/loads a `user://` roundtrip copy. |
| AUTO local/simulated | Desktop, mobile, Web desktop, Web mobile, ambiguous Web, and forced modes are covered | EXECUTED | READY FOR PLAN 04 GATE | Godot-only fallback; no JS bridge in v1 research. |
| Anti-pattern audit | Spike avoids editor-only APIs and addon implementation edits | STATIC-FALLBACK | READY FOR PLAN 04 GATE | Formal file-scope audit occurs in Plan 06. |

## Subclass Contract

Phase 4 should implement a production version of this contract.

| Hook/category | Purpose | Allowed subclass freedom | Direct override allowed? | Required verifier coverage | Mobile/a11y guardrail | Forbidden APIs |
|---------------|---------|--------------------------|--------------------------|----------------------------|----------------------|----------------|
| `NeoCadeTheme._regenerate()` | Clear and rebuild full 35-Control matrix from exported values | Superclass-owned only | No | Every required Control/type slot exists after regeneration | Desktop/mobile sizing both covered | `EditorSettings`, `EditorInterface`, `EDSCALE` |
| `super._regenerate()` in subclasses | Populate base entries before personality deltas | Mandatory first line of subclass regeneration when overriding | N/A | Negative fixture must prove no-super gaps are detected | Missing base entries fail mobile and desktop variants | Resource-level inheritance assumptions |
| `_theme_profile()` | Return personality constants: radius, border width, accent mix, contrast, density | Yes; subclasses may tune scalar values | Yes, via returned dictionary only | Snapshot profile values in verifier | Must not reduce touch targets below mobile spec | Editor-only scale/system theme reads |
| `_derive_surface()` | Formula-driven tonal ramp from `base_color` | Limited; subclass may tune contrast through profile | Avoid direct replacement unless tested | Color output changes when exports change | Maintain WCAG targets in later token phases | Texture/pattern/painterly effects |
| `_build_*` control groups | Generate theme entries per Control family | Superclass-owned by default | Only for documented exceptions | Full 35-Control coverage verifier | Mobile constants/font sizes must remain paired | Partial visual-only acceptance |
| `_after_base_regenerate(context)` | Add personality after base coverage exists | Preferred subclass extension point | Yes, for narrow direct overrides | Direct override marker + affected slots tested | Overrides must include desktop/mobile expectations | Clearing the theme after superclass run |
| Direct `set_*` override in subclass | Exceptional one-off personality slot | Allowed only after `super._regenerate()` | Yes, documented exception | Required per-slot verifier assertion | Must not remove focus/pressed/disabled states | Unverified override drift |
| Platform resolver | Resolve forced desktop/mobile or AUTO | Superclass-owned | No | Forced, local, Web desktop/mobile/ambiguous cases | Ambiguous Web is mobile-preferred | JavaScript bridge in v1 architecture |

Contract rule: a subclass may be visually opinionated, but coverage remains a superclass obligation. Every subclass that overrides generation must either call `super._regenerate()` first or fail verification by design.

## AUTO Platform Strategy

Recommended resolver order:

1. If `platform == DESKTOP` or `platform == MOBILE`, use the forced value.
2. For `AUTO`, prefer Godot feature tags: `mobile`, `android`, `ios`, `web_android`, `web_ios` all resolve mobile.
3. `web_windows`, `web_macos`, and `web_linuxbsd` resolve desktop.
4. Ambiguous `web` with no platform-specific tag resolves mobile-preferred.
5. Fallback to `OS.get_name()`: `Android`/`iOS` mobile; `Windows`/`macOS`/`Linux`/BSD desktop; unknown mobile-preferred.

Validation status:

| Case | Status |
|------|--------|
| Forced DESKTOP | Verified in Godot 4.6.2 |
| Forced MOBILE | Resolver path covered; future mobile visual check needed |
| Native desktop local | Verified as known enum on Windows host |
| Native Android/iOS | Simulated by resolver logic; real-device confirmation deferred to UD-5 / Phase 10 |
| Web desktop tags | Verified by simulated `web_windows` |
| Web mobile tags | Verified by simulated `web_android` and `web_ios` |
| Ambiguous Web | Verified mobile-preferred |

No JavaScript bridge is needed for v1 architecture. If Web ambiguity becomes unacceptable during export QA, research it then as a targeted fallback, not as a Phase 4 dependency.

## Serialization Findings

Saved dynamic `.tres` fixtures serialize script references and exported values:

- `prize_pop_spike_neocade_theme.tres` references `PrizePopSpikeNeoCadeTheme.gd` and stores `base_color`, `accent_color`, `raised=true`, `platform=AUTO`.
- `broken_no_super_spike_theme.tres` references `BrokenNoSuperSpikeTheme.gd` and stores `base_color`, `accent_color`, `raised=false`, `platform=AUTO`.
- Generated theme entries are not relied on as hand-authored table data; the verifier proves they regenerate after load and after a `ResourceSaver.save()` / load roundtrip (`SPIKE-03.2`, EXECUTED).

Conclusion: dynamic scripted Theme resources are feasible as saved `.tres` instances, provided Phase 4 keeps regeneration deterministic and verifier coverage rejects missing generated entries.

## Runtime and Editor-Time Findings

Runtime findings:

- A saved scripted `Theme` resource can be loaded in headless Godot 4.6.2 and assigned to a Control tree.
- `Theme.has_*` checks correctly expose generated entries and missing entries; this is the correct gate because engine fallback can mask visual gaps.
- Representative subset regeneration reported `187 usec`. This is a subset smoke metric, not a full 35-Control timing guarantee.

Editor-time findings:

- `@tool` scripts parse and execute under Godot 4.6.2 when loaded from `.planning/spikes/dynamic-theme/`.
- The spike does not prove Inspector editing UX for exported properties; Phase 4 should verify that exported knobs regenerate live in the editor when the production script exists.
- The research confirms editor-specific APIs are unnecessary for runtime generation.

## Pitfall Catalogue

| Pitfall | Risk | Phase 4 prevention |
|---------|------|--------------------|
| Fallback masks missing entries | Theme visually appears okay because Godot default theme fills gaps | Use `Theme.has_*` coverage verifier, not screenshots alone. |
| Subclass skips `super._regenerate()` | Non-overridden Controls render default/unbranded | Keep bad no-super fixture and require a failing-gap assertion. |
| Generated entries become stale | Export changes leave old entries in resource | Start regeneration with `clear()` and verify changed outputs. |
| Editor-only dependencies leak in | Theme breaks in exports/runtime | Static audit for `EditorSettings`, `EditorInterface`, `EDSCALE`, editor-only classes. |
| Web platform ambiguity | Desktop browser may get mobile sizing or vice versa | Forced platform escape hatch plus documented mobile-preferred AUTO. |
| Shadow chrome sneaks back | GL Compatibility shadow over-render risk | `StyleBoxFlat.shadow_size = 0` in helpers and audit for shadows. |
| Partial subset confidence | Spike passes but full 35-Control matrix fails | Treat Phase 03.2 as architecture feasibility only; Phase 4+ must run full coverage verifier. |
| Direct subclass overrides drift | Personality override deletes accessibility/focus states | Require direct override table and per-slot verifier rows. |
| Serialization misunderstanding | Generated entries expected to be hand-authored in `.tres` | Accept saved scripts/exports plus deterministic regeneration; document this in README. |
| Mobile density regressions | Desktop values accidentally ship to mobile | Pair font-size/constants by platform in verifier. |

## Anti-Pattern Audit

| Surface | Status | Rationale |
|---------|--------|-----------|
| `EditorInterface` | Forbidden in architecture/spike | Theme must work in export/runtime contexts |
| `EditorSettings` | Forbidden in architecture/spike | User-facing `.tres` exports are the source of truth |
| `EDSCALE` | Forbidden in runtime architecture | Editor-only scale assumptions do not transfer cleanly to game runtime |
| Editor-only theme types | Research citation only | v1 user-facing Control coverage is the target |
| Textures/patterns/gradients/soft shadows | Forbidden for v1 theme style | Project direction is flat MD3/MD3 Expressive with no texture chrome |
| Production addon edits | Forbidden in Phase 03.2 | Spike must stay under `.planning/spikes/` |

| Pattern | Decision | Why |
|---------|----------|-----|
| Editor preset cloning | Reject | Pulls in `EditorSettings`, system accent behavior, and editor-only assumptions. |
| Direct `Theme.set_*` generation from exports | Adopt | Runtime-safe, supported by public Theme resource APIs. |
| `Theme.clear()` at regeneration start | Adopt with care | Prevents stale entries; verifier must ensure required entries are rebuilt. |
| Fallback-driven visual acceptance | Reject | Engine fallback can hide missing entries; verifier must use `has_*`. |
| StyleBoxFlat shadows | Reject for v1 | `shadow_size > 0` is the draw gate; project has no-shadow GL Compatibility constraint. |

## Fallback Options and Recommendation

| Option | Description | Pros | Cons | Recommendation |
|--------|-------------|------|------|----------------|
| Dynamic scripted `Theme` superclass | `@tool extends Theme` with exported values and per-theme subclasses | One `.tres` per direction, user-editable exports, verified representative feasibility | Requires strong verifier discipline and full-matrix generator work | **Recommended** because strict gate passed |
| Hybrid `@tool` static `.tres` generator | Editor/tool script writes static desktop/mobile `.tres` resources from the same formulas | Most robust fallback for Asset Library consumers if dynamic scripting breaks later | More files, less elegant user editing, generation workflow returns | **Chosen fallback** if full-matrix dynamic fails |
| Older 4N static matrix | Flat/raised x desktop/mobile per theme direction | Simple runtime story | Explodes file count and contradicts architecture revision | Reject unless emergency |
| Reduced dynamic model | Dynamic only for colors; static sizing/resources | Reduces moving parts | Less coherent, still needs fallback files | Reject unless a narrow Godot serialization issue appears |

Recommendation: proceed with dynamic scripted `Theme` architecture. Keep the hybrid static generator as the one fallback to revisit only if Phase 4 full-matrix implementation exposes a blocker that the representative spike did not cover.

## Architecture Recipe for Phase 4

**Status: LOCKED for Phase 4 planning, subject to full-matrix verification.**

1. Create production `NeoCadeTheme.gd` as `@tool extends Theme` in the addon.
2. Export `base_color`, `accent_color`, `raised`, and `platform: { DESKTOP, MOBILE, AUTO }`.
3. Store all default base-direction values in the superclass; Phase 3.4 mockup approval chooses those defaults.
4. Implement `_regenerate()` as superclass-owned full-matrix generation:
   - `clear()` first.
   - Resolve platform.
   - Derive color ramp from exported values.
   - Set styleboxes, colors, fonts, font sizes, icons, and constants for every required Control and state.
   - Call `_after_base_regenerate(context)` last.
5. Per-theme direction subclasses may override `_theme_profile()` and `_after_base_regenerate(context)`. If a subclass overrides `_regenerate()`, verifier requires `super._regenerate()` first.
6. Use `StyleBoxFlat` helpers for flat MD3/MD3 Expressive chrome; set `shadow_size = 0`.
7. Implement platform sizing through constants/font sizes, not separate desktop/mobile `.tres` files.
8. Keep forced `DESKTOP`/`MOBILE` modes for deterministic QA and user escape hatches.
9. Build a coverage verifier that checks `Theme.has_*` for all 35 user-facing Controls and required type variations.
10. Add tests/fixtures for a good subclass and no-super bad subclass before adding visual polish.

Phase 4 must not treat the 187 usec subset timing as a final performance result. Retain the timing hook and measure the full generated matrix.

## Phase 3.2 Verification Log

| Date | Plan | Verification | Result |
|------|------|--------------|--------|
| 2026-05-06 | 01 | Research artifact created with required sections, source labels, strict gate rows, spike evidence matrix, no-addon boundary, and anti-pattern audit skeleton | PASS |
| 2026-05-06 | 02 | Godot source inspection populated editor generation flow, runtime Theme APIs, StyleBoxFlat constraints, formula port, and anti-pattern decisions | PASS |
| 2026-05-06 | 03 | Research-only dynamic Theme spike artifacts created under `.planning/spikes/dynamic-theme/`; smoke verifier passed on Godot 4.6.2 | PASS |
| 2026-05-06 | 04 | Formal strict feasibility verifier passed in Godot 4.6.2; `VERIFY-RESULTS.md` records checks, raw output, serialization inspection, AUTO matrix, and performance note | PASS |
| 2026-05-06 | 05 | Subclass contract, AUTO strategy, fallback comparison, pitfall catalogue, and Phase 4 architecture recipe finalized | PASS |
| 2026-05-06 | 06 | `SOURCES.md` Section 13 appended; changed-file scope audit found only `.planning/STATE.md`, Phase 03.2 summaries, research doc, and `.planning/spikes/dynamic-theme/` files | PASS |

## Final Scope Audit

Allowed changed surfaces during Phase 03.2 execution:

- `.planning/STATE.md`
- `.planning/phases/03.2-godot-dynamic-theme-architecture-research/03.2-01..06-SUMMARY.md`
- `.planning/research/GODOT-DYNAMIC-THEME-RESEARCH.md`
- `.planning/research/SOURCES.md`
- `.planning/spikes/dynamic-theme/`

Forbidden production surfaces checked and not changed:

- `addons/neocade_theme/`
- `main.tscn`
- `project.godot`
- production `.tres` theme resources
- fonts, icons, and mockup images

Spike code audit found no `EditorSettings`, `EditorInterface`, `EDSCALE`, `JavaScriptBridge`, or positive `shadow_size` dependency in executable spike scripts. The only `addons/neocade_theme/` mention in the spike is the README no-copy boundary.
