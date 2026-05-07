# Phase 08: Mobile Variant Token Block + Tap-Target Audit - Research

**Researched:** 2026-05-07
**Domain:** Godot 4.6.2 dynamic Theme mobile sizing, forced platform verification, tap-target audit, and mobile design documentation for the existing `NeoCadeTheme` architecture.
**Confidence:** HIGH for project constraints and existing code shape; HIGH for 48px mobile minimums from prior CROSS-PLATFORM research; MEDIUM for exact per-Control tap proxy formulas until the audit helper is implemented against live Godot controls.

<user_constraints>
## User Constraints

Phase 8 context is authoritative at `.planning/phases/08-mobile-variant-token-block-tap-target-audit-updated-for-dyna/08-CONTEXT.md`.

- Keep the dynamic architecture: one concrete `addons/neocade_theme/neocade_theme.gd` plus five data-only direction `.tres` resources.
- Do not add `neocade_mobile_theme.tres`, per-density resources, subclasses, root fallback `.tres`, `_dev/`, or `themes/`.
- Preserve the 9 public exports: `base_color`, `accent_color`, `raised`, `platform`, `corner_radius`, `spacing`, `raised_strength`, `focus_thickness`, `outline_width`.
- Mobile sizing is a platform mode on each direction resource. Forced `DESKTOP`, `MOBILE`, and host `AUTO` must be verified.
- All five directions must pass forced mobile verification.
- Tap-target audit must enforce a 48px floor for the theme-enforceable interactive set.
- Raised mode remains orthogonal to platform mode; raised/flat and desktop/mobile/AUTO must not overwrite each other.
- No `Theme.clear()` or broad reset is allowed; regeneration remains additive.
- `MOBILE-DESIGN-SPEC.md` belongs at the repository root and must cover `MOBILE-01..08`, `DOCS-02`, and `TYPEVAR-06`.
</user_constraints>

## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| MOBILE-01 | Mobile sizing is `@export platform=MOBILE` on `NeoCadeTheme`, not a separate mobile file. | Current script already exposes `platform` and `_platform_tokens()`. Phase 8 must harden and verify it rather than create resources. |
| MOBILE-02 | Mobile tap targets are at least 48px. | CROSS-PLATFORM locks 48px as the common stricter floor across iOS HIG 44pt and Material 3 48dp. |
| MOBILE-03 | Mobile body text is 16px versus desktop 14px; headings stay documented. | `_platform_tokens()` already contains `body=16` mobile and `body=14` desktop. Phase 8 verifies all relevant direct font calls and docs. |
| MOBILE-04 | Mobile spacing grows by density; corner radii stay unchanged. | Existing recipe resolver already uses `densityScale` and `tapPadding`; Phase 8 must prove radii are platform-stable. |
| MOBILE-05 | One dynamic mobile mode covers density buckets through Godot scaling, not per-density `.tres`. | CROSS-PLATFORM rejects Android density-qualifier theme resources; docs must state this clearly. |
| MOBILE-06 | Tap-target audit script passes for every enforceable interactive mobile Control. | New Phase 8 helper should compute theme-side proxies from stylebox margins, font sizes, and constants. |
| MOBILE-07 | `MOBILE-DESIGN-SPEC.md` documents concrete deltas and rationale. | Root doc is a Phase 8 deliverable and a Phase 9/10 handoff artifact. |
| MOBILE-08 | Mobile keeps NeoCade identity and avoids native iOS/Android imitation. | Verification should compare color/radius identity across forced desktop/mobile and all five directions. |
| DOCS-02 | Mobile delta documentation exists. | Same root doc closes this. |
| TYPEVAR-06 | Type variations are documented with mobile behavior. | The current script has 15 variation entries, while requirements still speak of 13. The doc must reconcile all current shipped variations without changing the public export surface. |

## Existing Code State

`addons/neocade_theme/neocade_theme.gd` already has the right architecture and several mobile hooks:

- `enum Platform { DESKTOP, MOBILE, AUTO }`
- 9 public `@export` properties, including `platform`, `raised`, and shape exports.
- `_resolve_platform()` returns forced modes and host desktop/mobile for `AUTO`.
- `_platform_tokens()` already defines `buttonMin=48`, `primaryButtonMin=56`, `inputMin=56`, `body=16`, `label_=14`, `rowMin=56`, `tabMin=48`, `thumbnailSize=128`, `tapPadding=12`, and `densityScale=1.5` for mobile.
- `_resolve_recipe()` uses `densityScale` and `tapPadding` for default stylebox content margins.
- BINDING_TABLE recipes already use `tokens.tapPadding`, `tokens.thumbnailSize`, and direct font-size calls.
- Phase 7 verification proves the architecture invariants: one addon-root `.gd`, five data-only `.tres`, no root fallback resource, no `Theme.clear()`, 37/37 desktop scorecard coverage, and ResourceSaver strip discipline.

The gaps are not architectural invention gaps; they are enforcement gaps:

- No Phase 8 helper currently verifies forced `DESKTOP` / `MOBILE` / `AUTO` values.
- No helper checks all five directions in forced mobile mode.
- No tap-target audit computes per-Control mobile hit-area proxies.
- No root `MOBILE-DESIGN-SPEC.md` exists.
- `main.tscn` is still a bare Control with the Pulse theme applied; it does not yet prove platform/raised toggling.

## Recommended Plan Shape

Use five sequential waves:

1. Verifier and tap-target audit foundation.
2. Production mobile token hardening and forced platform verification.
3. All-direction forced mobile pass plus strict 48px tap-target audit.
4. Root `MOBILE-DESIGN-SPEC.md` with 37-row and type-variation documentation.
5. Minimal `main.tscn` platform/raised toggle proof plus final full verification and data-only resource checks.

This mirrors the successful Phase 6/7 pattern: helper foundation first, production contract hardening second, strict audit third, documentation handoff fourth, final scene/resource closure last.

## Validation Architecture

Create Phase 8 helpers under `.planning/phases/08-mobile-variant-token-block-tap-target-audit-updated-for-dyna/helpers/`:

- `Resolve-Godot46.ps1` copied/adapted from Phase 7.
- `_run-phase8-verify.ps1` with stages `architecture`, `platform-tokens`, `tap-targets`, `docs`, `scene-toggle`, and `full`.
- `_phase8_verify_headless.gd` asserting architecture invariants, no `Theme.clear`, forced `DESKTOP` / `MOBILE` / host `AUTO`, raised/platform orthogonality, all five directions forced mobile, root docs existence, scene toggle wiring, no mobile/root fallback resources, and zero pending groups in `full`.
- `_phase8_tap_target_audit.gd` that loads directions, forces `platform=MOBILE`, and reports each interactive/display/layout row as `PASS`, `LIMITED`, or `N/A`, failing if any enforceable interactive proxy is below 48px.
- `phase8-mobile-contract.txt` documenting the local engine, required directions, forced platform matrix, interactive scorecard classification, and exact 48px floor.

## Tap-Target Proxy Research

Theme resources cannot set `Control.custom_minimum_size` directly for every class, so the audit should compute the strongest theme-side proxy Godot exposes:

- Button-family rows: font size plus vertical stylebox content margins, with recipe constants such as `tokens.buttonMin` and `tokens.primaryButtonMin` where the implementation exposes them.
- Text inputs and SpinBox: text font size plus input stylebox margins, with `tokens.inputMin` as the contract floor where available.
- CheckBox/CheckButton: icon/toggle size plus stylebox margins and `h_separation`; do not fake a larger target by padding display-only glyphs without affecting the interactive row.
- ItemList/Tree/PopupMenu rows: row or separation constants plus font size and stylebox margins.
- Tabs/MenuBar/MenuButton/OptionButton: tab/menu constants plus stylebox margins and font size.
- Scrollbars/sliders/split handles: grabber/track thickness and hotzone constants where Godot exposes them; otherwise mark a limitation and verify the closest theme-controlled proxy.
- Dialog/window shells, labels, panels, separators, and layout-only containers: classify as display-only or layout-only, not interactive tap targets.

The audit must fail for any enforceable interactive row under 48px on either axis in mobile mode. Limitations are allowed only when the theme API has no enforceable minimum for that type, and those rows must still be documented in `MOBILE-DESIGN-SPEC.md`.

## Sources

- `.planning/phases/08-mobile-variant-token-block-tap-target-audit-updated-for-dyna/08-CONTEXT.md`
- `.planning/PROJECT.md`
- `.planning/ROADMAP.md`
- `.planning/REQUIREMENTS.md`
- `.planning/research/CROSS-PLATFORM.md`
- `.planning/research/GODOT-DYNAMIC-THEME-RESEARCH.md`
- `.planning/research/PITFALLS.md`
- `.planning/research/FEATURES.md`
- `.planning/research/FLAT-3D-UI-RESEARCH.md`
- `.planning/research/STACK.md`
- `.planning/phases/07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr/07-VERIFICATION.md`
- `.planning/phases/07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr/helpers/_phase7_verify_headless.gd`
- `.planning/phases/07-dialogs-popups-advanced-window-popups-menubar-colorpicker-gr/helpers/_phase7_resource_saver.gd`
- `addons/neocade_theme/neocade_theme.gd`
- `addons/neocade_theme/*_neocade_theme.tres`
- `main.tscn`

## Metadata

**Valid until:** Godot version changes beyond 4.6.2, the five direction resources change shape, or the public 9-export surface changes. Re-run local slot/proxy verification before execution if any of those happens.
