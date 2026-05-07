---
phase: 05-core-controls-buttons-inputs-labels-panels-desktop
reviewers:
  - OpenCode (deepseek/deepseek-v4-pro)
  - Claude (claude -p)
reviewed_at: "2026-05-06T20:41:53.9964027-07:00"
plans_reviewed:
  - 05-01-godot-cli-and-phase5-verifier-scaffold-PLAN.md
  - 05-02-direction-shape-schema-and-recipe-resolution-PLAN.md
  - 05-03-basebutton-family-and-button-variations-PLAN.md
  - 05-04-text-label-and-panel-variations-PLAN.md
  - 05-05-text-codeedit-polish-PLAN.md
  - 05-06-spinbox-icons-and-imports-PLAN.md
  - 05-07-final-resource-saver-and-data-only-verification-PLAN.md
---

# Phase 05 Cross-AI Plan Review - Cycle 1

## OpenCode Review

**Reviewer:** OpenCode via `opencode run --model deepseek/deepseek-v4-pro -`  
**Exit code:** 0

## Verdict

**Revise** (1 HIGH x SpinBox icon slot name conflict; converge after fixing Plan 05-06 to use RESEARCH.md-verified `up`/`down` official names).

---

## HIGH Concerns

- `[HIGH]` **Plan 05-06 contradicts RESEARCH.md on SpinBox icon slot names** (affects Plans 05-06, 05-07 verifier). RESEARCH.md section "Pattern 4" explicitly cites official Godot 4.6 SpinBox docs resolving names to `up`, `up_disabled`, `down`, `down_disabled`, with a stated prescription: "the plan should use those names rather than `up_arrow`/`down_arrow`." But Plan 05-06 Tasks 1-2 default to `up_arrow` / `down_arrow` and write the verifier assertion against that name. If Plan 05-06 ships `up_arrow`/`down_arrow`, SpinBox icons silently fail to render (wrong slot name -> `Theme.get_icon` returns null), and the verifier passes because it checks equally wrong names. Fix: hard-code `up`/`down` in Plan 05-06 tasks and verifier as RESEARCH.md directed, and add a check that the resolved slot names exist in `Theme.get_icon_list("SpinBox")`.

---

## MEDIUM Concerns

- `[MEDIUM]` **Plan 05-03 Task 3 focus probe may stall on headless rendering** (affects Plan 05-03, Plan 05-07). The probe's `<action>` requires a Viewport pixel-check: "If headless rendering cannot produce an image, the probe must fail with a clear error." Godot headless on GL Compatibility (the project's locked renderer) may not produce meaningful Viewport output. The structural fallback (assert `focus` stylebox has transparent bg + accent border + correct thickness/focus_offset) is already covered by the verifier scaffold. The pixel-check gate should be downgraded to a WARN or moved to a manual-visual pass in Phase 9/10; otherwise Plan 05-03 blocks execution on an environment-level capability the project cannot guarantee. Additionally, the verification command references `_phase5_focus_probe.gd` but Plan 05-01 only scaffolds it - the actual focus probe implementation body is authored in Plan 05-03 Task 3 itself, creating a transient gap where the Plan 05-01 tooling stage verification can't exercise the probe.

- `[MEDIUM]` **Plan 05-05 Task 2 folded icon slot name is discovered at runtime** (affects Plan 05-05). The plan wisely defers to introspection ("record the exact slot name in the verifier assertion") but the BINDING_TABLE recipe must use that name. If the `folded` slot is named differently across Godot 4.6.x patch versions, the plan has no author-time guard. Mitigation: Plan 05-05 should specify that the verifier `--stage text-final` introspects `Theme.get_icon_list("CodeEdit")` and asserts that the resolved name matches what the BINDING_TABLE recipe wired, creating a self-checking loop.

---

## LOW Concerns

- `[LOW]` **Plan 05-01 Task 1 Godot installation path unspecified** (affects Plan 05-01). `Resolve-Godot46.ps1` searches common paths and may download, but the download URL and binary integrity check (no hash) are not specified. Mitigated by the immediate `--version` and `--import` smoke tests, which catch a wrong binary.

- `[LOW]` **Plan 05-01 Task 2 verifier group-name check may false-positive** (affects Plan 05-01). The verify block greps source with `$sourceText -notmatch ('\b' + [regex]::Escape($_) + '\b')` to confirm assertion function names exist. This matches comments, string literals, and method-call lines equally. Risks accepting a stub that declares the name but implements nothing. Mitigated by the `--stage tooling` execution pass that exercises the real functions.

- `[LOW]` **Plan 05-02 Task 2 "as needed" helper hedging** (affects Plan 05-02). The `<action>` says "Add small helper functions such as ... as needed," which leaves ambiguity about whether `_apply_primary_strategy`, `_apply_ghost_strategy`, and `_apply_kicker_style` are all required. Plans 05-03 and 05-04 depend on these being present; if "as needed" means the executor omits one, a downstream plan fails. Fix: list them explicitly as required outputs in the `<done>` block.

- `[LOW]` **CodeEdit `line_number_color` not in Plan 05-05 gutter color set** (affects Plan 05-05). The 5 named gutter colors omit `line_number_color`, which is visible in every CodeEdit with line numbers enabled and is a theme-owned color slot in Godot 4.6. The plan delegates to executor discretion ("pick based on visual completeness"), but the verifier assertion group (`assert_codeedit_gutter_slots`) should at minimum include it in the list of slots checked for presence.

- `[LOW]` **Plan 05-04 Task 3 "PanelContainer have panel styleboxes" is imprecise** (affects Plan 05-04). PanelContainer uses a single `panel` stylebox (same slot name as Panel), not multiple styleboxes. The behavior test is fine (checks `has_stylebox("panel", ...)` for both), but the wording could mislead during implementation. No functional impact if the executor follows the BINDING_TABLE pattern.

---

## Strengths

- D-07 focus overlay resolution is correctly anchored in Godot 4.6 source-code evidence, and every plan verbatim preserves "no invented `pressed_focus` / `checked_focus` / `hover_pressed_focus` slots" with verifier enforcement.
- Data-only `.tres` contract is systolically guarded: Plans 05-02 through 05-06 never create `.tres` files; Plan 05-07 runs a final gate checking 5 exact filenames, <=2 KiB, no `[sub_resource]`/`theme_data/` sections, and `shadow_size == -1` on flat.
- All 17 decisions (D-01-D-17 from 05-CONTEXT.md) are explicitly preserved: D-01 additive iteration, D-02-D-04 shape schema, D-05 all-5-directions, D-06 no-new-tres, D-07 focus overlay, D-09 Kicker, D-11 Godot CLI prerequisite, D-13 no-`clear()`, D-14 escape hatch, D-15 defaults unchanged, D-16 BL-02 carry-forward, and D-17 Inter-only. No plan silently reverses or omits any decision.
- Verification architecture is comprehensive: Phase 4 dual-verifier pattern is extended with 7 named assertion groups, strict `^(ERROR|SCRIPT ERROR):` log scanning on every Godot invocation, per-stage verifier gates, and a PowerShell-based exact-filename-and-count final invariant.
- Dependency ordering is correct: all 7 plans chain sequentially on real prerequisites (Plan 05-01 -> CLI path; 05-02 -> shape schema; 05-03 -> button rows use shape; 05-04 -> text/panels use existing buttons; 05-05 and 05-06 -> independent polish after variation core; 05-07 -> final save after all preceding plans land). No broken forward-reference.
- Kicker is the right size of implementation: Theme-owned font/size/color only; no fake `letter_spacing` constant, with Research note that uppercase/tracking is content behavior. This avoids the documented Pitfall 5 over-promise.
- CodeEdit scope is well-disciplined: gutter chrome + folded icon, explicit "no syntax highlighting" guard, with introspected icon slot name (avoiding hard-coded name risk).
- Roadmap success criteria are all mapped: SC#1 (7 BaseButton) -> Plan 05-03; SC#2 (5 text + CodeEdit gutter) -> Plans 05-04, 05-05; SC#3 (14->15 variations) -> Plans 05-03, 05-04; SC#4 (Panel + PanelContainer + SpinBox) -> Plans 05-04, 05-06; SC#5 (focus = outer ring) -> Plan 05-03.

## Claude Review

**Reviewer:** Claude via `claude -p -`  
**Exit code:** 0

## Verdict

Revise. The plan set is well-architected - the dependency ordering (CLI bootstrap -> schema -> Buttons -> Text/Panels -> Text polish -> SpinBox -> ResourceSaver) is sound, D-07 is correctly resolved as overlay-only, the Theme.clear invariant is preserved, and the data-only `.tres` contract has multiple guards. However, four HIGH issues block convergence: the SpinBox icon slot names contradict the research's own conclusion, Plan 05-01 silently authorizes downloading and installing Godot 4.6.x as part of an autonomous run, Plan 05-03 references a `danger` role token that does not exist in the current `role_table`, and Plan 05-07's ResourceSaver round-trip will reintroduce theme entry sections into the five `.tres` files without the strip helper that Phase 4 used. Each is a one-cycle revision; the architecture itself does not need to change.

## HIGH Concerns

- [HIGH] Plan 05-06 Task 2 contradicts 05-RESEARCH.md on SpinBox icon slot names. Research section Pattern 4 / section Don't Hand-Roll explicitly verifies the official slots are `up`, `up_disabled`, `down`, `down_disabled` (compact) and prescribes `"up": {"icon": "spinbox_up"}` recipes. The plan instead defaults to `up_arrow`/`down_arrow` ("Start with `up_arrow` and `down_arrow`; if Godot CLI introspection returns different official names, correct..."). If executed as written the SpinBox arrows will not bind - they target nonexistent slots. Acceptable: pre-commit the research-verified slot set (`up`, `up_disabled`, `down`, `down_disabled`) in the recipe and verifier, with a single verifier introspection assertion that those exact names are present in `Theme.get_icon_list("SpinBox")` before authoring; abort the task if introspection disagrees.

- [HIGH] Plan 05-01 Resolve-Godot46.ps1 is permitted to download or install Godot 4.6.x during an `autonomous: true` execution. Plan text: "If no executable is found, download or install the current Godot 4.6.x stable Windows 64-bit CLI from official Godot distribution endpoints, without committing the binary." This is a network-fetched executable being installed without explicit user confirmation, on a project whose AGENTS.md/CLAUDE.md flag destructive/risky actions for confirmation. Acceptable: split Resolve-Godot46.ps1 into search-only mode (default) and `-AllowInstall` mode; if no executable is found the plan must produce a checkpoint asking the user to install Godot 4.6.x or supply a path, then resume. Document the SHA256 of the downloaded archive when install is approved.

- [HIGH] Plan 05-03 Task 1 references a `danger` semantic role for DangerButton, but `role_table` (built in `_regenerate_theme()` in `addons/neocade_theme/neocade_theme.gd:214-233`) contains no `role_danger`/`danger` key - only `role_primary`, surface family, text family, state_hover/pressed, accent_rim. The plan says "DangerButton must use the semantic danger role already established in role tokens or add a local role color without adding a new export," but no plan explicitly adds this role. As written, Plan 05-03 either fails recipe resolution or DangerButton silently falls back to `surface_panel`. Acceptable: Plan 05-02 should explicitly add `role_danger`/`role_warning`/`role_success`/`role_info` derivations to `_regenerate_theme()` and `role_table`, with verifier assertions, before Plan 05-03 references them; alternatively Plan 05-03 explicitly adds `role_danger` as part of its surface area.

- [HIGH] Plan 05-07 Task 1 round-trips the five `.tres` files through `ResourceSaver.save()` but does not preserve the strip-pass that kept them data-only in Phase 4. Phase 4 had `_strip_theme_entries(path)` + `_strip_load_steps_attr(header_line)` in `_phase4_import.gd`; without an equivalent, Godot's `ResourceSaver` will serialize every populated theme entry from `_regenerate_theme()` into each `.tres`, blowing past the < 2 KiB invariant Plan 05-07 Task 2 then asserts. The plan's mitigation is one sentence: "strip generated theme entry sections after save if Godot serializes them, leaving only script linkage plus exported values." That is not a specification, just an aspiration. Acceptable: spell out a `_phase5_resource_saver.gd` that (a) loads the resource, (b) saves it, (c) re-runs the strip helper (reuse `_strip_theme_entries`/`_strip_load_steps_attr` verbatim from Phase 4 or move them to a shared helpers/ module), and (d) asserts byte-size and absence of `[sub_resource]`/`theme_data/` BEFORE Plan 05-07 Task 2's PowerShell gate runs. Also pin which property values are expected to change versus stay byte-identical.

## MEDIUM Concerns

- [MEDIUM] Plan 05-04 Task 1 fixes InfoText to use `normal_font_size` but does not require removal of the existing `set_font_size("font_size", "InfoText", tokens.body)` call at `addons/neocade_theme/neocade_theme.gd:205`. Both calls together do not break behavior (RTL ignores `font_size`), but leaving the wrong slot is a future-confusion trap that Phase 4's BL-02 fix already partially repaired and that 05-RESEARCH.md flags as Pitfall 2. Acceptable: explicit instruction to delete the wrong `font_size` line and assert in the verifier that `theme.has_font_size("font_size", "InfoText") == false` AND `theme.has_font_size("normal_font_size", "InfoText") == true`.

- [MEDIUM] Plan 05-04 Burst Kicker styling can't honor "uppercase-bold-larger" wght=700 with the current font bundle. Phase 4 ships HeaderLarge wght=800, HeaderMedium wght=700, HeaderSmall wght=600, Body wght=400, Caption wght=400 - no Kicker-specific FontVariation. The plan's instruction "use an existing Inter variation only if it already exists; do not bundle a new font" leaves Burst Kicker unable to differentiate weight from other directions' Kickers. Acceptable: either author a new `Inter-Kicker.tres` FontVariation referencing the same `Inter-Variable.ttf` (FontVariation is data, no new bundled font asset) and wire it conditionally per `kicker_style`, or document that Burst Kicker reuses HeaderMedium (wght=700) with size adjusted via `tokens.kicker + 1`. Pick one and write it into the plan.

- [MEDIUM] Plan 05-05 Task 2 leaves the CodeEdit folded icon slot name undetermined ("Wire the folded icon only to the official CodeEdit icon slot confirmed by the verifier; record the exact slot name in the verifier assertion"). Godot 4.6's `class_codeedit.html` exposes `folded` (icon) and `can_fold` (icon) - the planner should commit to one of these by name in the plan, not push slot-discovery to execution. Acceptable: pre-name the slot (likely `folded`) and assert via `Theme.get_icon_list("CodeEdit").has("folded")` in the verifier. If introspection disagrees, abort and replan rather than silently picking a wrong slot.

- [MEDIUM] Plan 05-02 Task 1 Test 4 ("Primary and ghost strategy values differ across Pulse, Slate, Bubble, Daybreak, Burst") is overly strict. From DESIGN_TOKENS section 5.1-5.5 Daybreak's primary strategy is "friendly-generous" and DIRECTION_PRESET_DEFAULT is also "friendly-generous"; depending on how the planner enumerates the closed-enum set, two directions may legitimately share a strategy value. Acceptable: change the assertion from "differ across all 5 directions" to "the union of distinct strategy values across the 5 directions is >= 4" OR enumerate which directions are expected to share a strategy. As written the test will fail for Daybreak vs DEFAULT.

- [MEDIUM] Plan 05-03 Task 3's pixel-check focus probe assumes headless Godot 4.6 can render Control trees to a Viewport `get_texture()`. This is fragile on GL Compatibility (research even cites Godot #23640 for shadow alpha overdraw). The probe will likely succeed on a desktop dev environment but may fail in CI or headless WSL contexts. Acceptable: either downgrade the assertion to "structural focus stylebox properties match expected `bg_color.a == 0`, `border_color == accent`, `expand_margin_left == focus_offset`" without the pixel render, or wrap the pixel render in a try/skip with a documented `--no-render` flag.

- [MEDIUM] Plan 05-07 Task 2's PowerShell gate `Get-ChildItem addons/neocade_theme -File -Filter '*.tres'` only lists files at the addon root and does not catch a stray `addons/neocade_theme/themes/foo.tres` or `addons/neocade_theme/_dev/foo.tres` that some careless future task could introduce. PROJECT.md flat-layout 2026-05-06d explicitly forbids those subdirs. Acceptable: change to `Get-ChildItem addons/neocade_theme -Recurse -File -Filter '*.tres'` and assert the recursive set equals exactly the five approved direction filenames.

- [MEDIUM] Plan 05-01 Task 2's verifier-group check is source-only (`$sourceText -notmatch ('\b' + ...)`). It confirms the function names exist as text in the file but not that they are wired into the stage routing or that they actually run. A future plan could rename a group function and the source-text gate would catch it, but a no-op stub body would pass. Acceptable: in Plan 05-01 Task 2, run the headless verifier with each stage and assert each stage exits with status 0 and emits a known marker line per group (e.g., `PHASE5_GROUP_OK:assert_variation_count_15`); Plan 05-01 establishes the markers, later plans flip groups from "skip" to "active."

## LOW Concerns

- [LOW] Plan 05-04 Task 1 mentions "If execution discovers an official Label theme constant for tracking via `Theme.get_constant_list("Label")`, it may wire it." This is an open-ended escape hatch with no concrete acceptance criterion. Acceptable: specify that the discovery requires a documented Godot 4.6 docs/source citation, AND a verifier assertion proving the constant name, OR the plan must default to "no tracking, content-side only."

- [LOW] All plans use PowerShell verification; the project supports both PowerShell and Bash. Acceptable: optional Bash equivalents in a `<verify>` `<bash>` sub-block, or an explicit declaration "Phase 5 is Windows-only because of Resolve-Godot46.ps1; Linux/macOS support deferred to Phase 10 cross-platform export."

- [LOW] Plan 05-07 Task 2's "every generated `StyleBoxFlat.shadow_size == -1` for raised=false" is correct by construction (per `_make_raised_stylebox`), but the assertion as worded ("only `raised=true` may have hard-offset shadow values") doesn't pin the relationship to `raised_intensity`. With `raised=true` AND `raised_intensity == 0` (e.g., Button.pressed), `shadow_size` is `raised_strength * 0 = 0`, not `-1`. Acceptable: clarify the rule as `(raised==false) -> shadow_size == -1` AND `(raised==true AND raised_intensity > 0) -> shadow_size == raised_strength * raised_intensity`. Avoids ambiguity at the gate.

- [LOW] Plan 05-03 IconButton padding/sizing is described as "compact" without concrete numbers. Acceptable: bind to `shape.icon_button_padding` or reuse `tokens.tapPadding` so the verifier can check a deterministic value.

- [LOW] Plan 05-04 Task 2's Kicker direction-aware behavior for "small-caps-subtle" (Slate) is implemented as `font_color = text_muted`. There is no Theme constant for true small-caps; the plan should make explicit that "small-caps" is a content cue and the theme owns only color/size, identical to how Pitfall 5 (Kicker overpromising) is documented. Currently the description risks reading as if small-caps actually renders.

- [LOW] No plan explicitly verifies that `set_font_size("font_size", "InfoText", ...)` is *removed* (vs. `normal_font_size` being *added*). The verifier could assert `false` on the wrong slot - adds belt-and-braces given Phase 4 BL-02 history.

## Strengths

- Dependency graph is clean and matches research's "four wave" recommendation, with the Godot CLI bootstrap correctly gating every ResourceSaver-dependent task.
- D-07 focus-overlay-only is consistently applied across Plans 05-01 / 05-02 / 05-03; the verifier explicitly fails on `pressed_focus`/`checked_focus`/`hover_pressed_focus` strings in production BINDING_TABLE rows. Solid guard against the most-cited Pitfall 1.
- The `assert_no_theme_clear` group in Plan 05-01 Task 2 correctly excludes comments from the scan, fixing a self-invalidating check pattern (matches the Phase 4 Plan 05 Cycle 6 deviation #3 fix).
- Data-only `.tres` invariants are pinned at multiple layers (no new `.tres`, no `[sub_resource]`, no `theme_data/`, < 2 KiB cap, exact addon-root file set) - the strip-helper gap (HIGH #4) is a one-spot fix, not an architectural problem.
- Strict log scanning for `^(ERROR|SCRIPT ERROR):` is uniform across every Godot invocation in every plan; nonzero `$LASTEXITCODE` always fails.
- 15-variation count, Kicker-as-15th, InfoText `normal_font_size` correction, and CodeEdit gutter scope are all consistent across plans 05-04 / 05-05 / 05-07.
- Plan 05-02's `_lookup_shape` design (dotted-path with null on miss for approved directions, fallback only for custom themes) correctly diagnoses Pitfall 3 (Shape Fallback Hiding Typos).
- 05-VALIDATION.md documents a per-task command matrix that mirrors each plan's `<verify>` block, giving the convergence reviewer a single reconciliation point.
- The plan set correctly scopes COV-04 (range controls beyond SpinBox), COV-05, COV-06, COV-08 to later phases and does not silently reach into Tree/TabBar/Popup territory.

## Consensus Summary

### Agreed Strengths

- Both reviewers found the overall Phase 5 structure sound: the seven plans are ordered around real dependencies from CLI bootstrap through schema work, core controls, polish, SpinBox, and final ResourceSaver/data-only verification.
- Both reviewers agreed the plan set preserves the major project invariants: additive Theme iteration, no `Theme.clear()`, data-only direction `.tres` resources, no production subclasses or per-direction `.gd`, no root `neocade_theme.tres`, and no `neocade_mobile_theme.tres`.
- Both reviewers praised the D-07 focus outcome: the plans avoid invented focus-combo slots and anchor the focus behavior in Godot 4.6 evidence.
- Both reviewers found the validation architecture strong, especially strict Godot log scanning for `^(ERROR|SCRIPT ERROR):`, per-stage verifier gates, and final data-only `.tres` checks.

### Agreed Concerns

- **HIGH - SpinBox icon slots are wrong in Plan 05-06.** Both reviewers independently flagged that 05-RESEARCH.md identifies `up`, `up_disabled`, `down`, and `down_disabled` as the official Godot 4.6 SpinBox icon slots, while Plan 05-06 still defaults to `up_arrow` / `down_arrow`. This is an unresolved convergence blocker because implementation and verification could both target nonexistent slots.
- **MEDIUM - Headless focus pixel verification is fragile.** Both reviewers flagged Plan 05-03's focus probe as risky under headless GL Compatibility rendering. Structural stylebox assertions or a skip/manual path should replace or qualify hard pixel-render blocking.
- **MEDIUM - CodeEdit folded icon slot should be pinned or self-checked.** Both reviewers saw risk in deferring the CodeEdit folded icon slot name to execution. The plan should commit to the official slot, likely `folded`, and assert it through `Theme.get_icon_list("CodeEdit")`.
- **LOW/MEDIUM - Source-text-only verifier group checks are weak.** Both reviewers noted that grepping function names is less reliable than executing stage routes or asserting marker output.

### Divergent Views

- Claude raised three additional HIGH concerns not raised by OpenCode: (1) Plan 05-01 permits autonomous Godot binary download/install without explicit user approval or hash-pinning, (2) Plan 05-03 references a missing `danger` role token for DangerButton, and (3) Plan 05-07 underspecifies the ResourceSaver strip pass needed to keep direction `.tres` files data-only.
- OpenCode treated the Godot download path only as a LOW issue about unspecified path/hash, while Claude escalated it to HIGH because it combines network-fetched executable installation with autonomous execution.
- OpenCode accepted the data-only `.tres` gate as strong overall, while Claude found a HIGH implementation gap because ResourceSaver serialization will likely reintroduce generated theme entries unless the Phase 4 strip helper is explicitly reused.
- Claude provided more detailed medium/low findings around InfoText wrong-slot removal, Kicker weight, recursive `.tres` discovery, strategy-value assertions, and raised shadow assertions; OpenCode did not raise those.

### Unresolved HIGH Count

Current unresolved HIGH concerns after Cycle 1: **4**.


# Phase 05 Cross-AI Plan Review - Cycle 2

**Reviewed at:** 2026-05-06T20:41:53.9964027-07:00
**Cycle context:** Review after Cycle 1 replan for `/gsd-plan-review-convergence 5 --opencode --claude`.
**Review scope:** Revised Phase 05 plans only. No PLAN files were edited during this review step.

## OpenCode Review

**Reviewer:** OpenCode via `opencode run --model deepseek/deepseek-v4-pro -`
**Exit code:** 0

## Verdict

**Proceed.** OpenCode found **0 unresolved HIGH concerns** after Cycle 2.

## Cycle 1 HIGH Resolution Check

- **HIGH 1 - SpinBox icon slot names:** **Resolved.** Plan 05-06 now hard-codes `up`, `up_disabled`, `down`, and `down_disabled`, with no `up_arrow` / `down_arrow` fallback. The verifier introspects `Theme.get_icon_list("SpinBox")` for those exact names, rejects the old names, and Plan 05-01 plus Plan 05-07 repeat the same assertion set.
- **HIGH 2 - Godot autonomous download/install:** **Resolved.** Plan 05-01 is search-only by default and blocks on a human checkpoint before any install. `-AllowInstall` requires an explicit official URL plus `-ExpectedSha256`, verifies with `Get-FileHash`, and writes `godot-cli-provenance.txt`.
- **HIGH 3 - DangerButton role token:** **Resolved.** Plan 05-02 adds explicit `role_danger`, `role_warning`, `role_success`, and `role_info` derivations before `role_table` is consumed. Plan 05-03 depends on 05-02 and forbids local fallback for DangerButton.
- **HIGH 4 - ResourceSaver `.tres` data-only round-trip:** **Resolved.** Plan 05-07 now specifies a concrete Phase-4-equivalent strip pass, preserving script linkage and the nine exports while removing `load_steps`, non-script ext_resources, `[sub_resource]` blocks, generated theme entries, and `theme_data/...` lines. The post-strip gate asserts byte size, no generated sections, and export-value stability.

## New Concerns

OpenCode reported no new HIGH, MEDIUM, or LOW concerns in Cycle 2.

## Current HIGH Concerns

None.

## Claude Review

**Reviewer:** Claude via `claude -p -`
**Exit code:** 0

## Verdict

**Proceed.** Claude found **0 unresolved HIGH concerns** after Cycle 2.

## Cycle 1 HIGH Resolution Check

- **HIGH 1 - SpinBox icon slot names:** **Resolved.** Plan 05-06 binds `up` / `up_disabled` to `spinbox_up.svg` and `down` / `down_disabled` to `spinbox_down.svg`, requires `Theme.get_icon_list("SpinBox")` introspection, rejects `up_arrow` / `down_arrow`, and aborts for replan if introspection disagrees. Plan 05-01 and Plan 05-07 independently reassert the compact slot set.
- **HIGH 2 - Godot autonomous download/install:** **Resolved.** Plan 05-01 has `autonomous: false`, defaults `Resolve-Godot46.ps1` to `-VerifyOnly`, explicitly forbids downloading/installing/extracting/executing network-fetched binaries in that mode, writes `GODOT-CLI-MISSING.md` when no executable is found, and gates any install behind a blocking human checkpoint with URL and SHA256 provenance.
- **HIGH 3 - DangerButton role token:** **Resolved.** Plan 05-02 derives `role_success`, `role_warning`, `role_danger`, and `role_info` inside `_regenerate_theme()` from `DESIGN_TOKENS` defaults, lifts them into `role_table`, and verifies no fallback to `surface_panel` or `text_strong`. Plan 05-03 consumes `role_danger` only after 05-02.
- **HIGH 4 - ResourceSaver `.tres` data-only round-trip:** **Resolved.** Plan 05-07 specifies `_phase5_resource_saver.gd` loading each `.tres`, snapshotting all nine export values, calling `ResourceSaver.save()`, running `_strip_theme_entries` plus `_strip_load_steps_attr`, and asserting no `[sub_resource]`, no `theme_data/`, under-2-KiB size, and byte-stable exported values.

## New Concerns

### HIGH

None.

### MEDIUM

- `[MEDIUM]` **Plan 05-01 verifier stage may demand future Phase 5 content too early.** Claude noted that `assert_spinbox_icons`, `assert_codeedit_gutter_slots`, `assert_inf_text_normal_font_size`, and `assert_variation_count_15` describe assertions whose content is not authored until later plans. Recommended clarification: in the `tooling` stage, groups should establish contracts and markers, then harden content assertions only in their dedicated later stages.
- `[MEDIUM]` **Plan 05-07 should post-strip reload the saved resources.** The strip pass text invariants are strong, but Claude recommended a post-strip `ResourceLoader.load(path)` assertion that the file still loads as `NeoCadeTheme` and has a representative stylebox, so header/resource `script_class` placement cannot silently break reloadability.
- `[MEDIUM]` **Plan 05-04 should remove the Label letter-spacing escape hatch.** Research already concludes Godot 4.6 Label has no Theme-level letter-spacing slot, so leaving an introspection escape hatch could encourage a fake constant.

### LOW

- `[LOW]` **Plan 05-02 `.clear(` PowerShell scan is weaker than the verifier.** It filters full-line comments but may still match strings or trailing comments. The verifier group remains the stronger gate.
- `[LOW]` **Plan 05-03 IconButton padding still has optionality.** Claude recommended committing to one deterministic source, such as `tokens.tapPadding`.
- `[LOW]` **Plan 05-05 should pin the `line_number_color` recipe source.** The slot is asserted, but its role/value source should be explicit.
- `[LOW]` **Plan 05-04 Burst Kicker verification wording could be tighter.** If the verifier checks font weight rather than font reference/size, the plan should name the exact expected resource behavior.

## Current HIGH Concerns

None.

## Consensus Summary

### Agreed Cycle 1 HIGH Closure

- **SpinBox slots:** Both reviewers agree the revised plans fully resolve the slot-name conflict by requiring `up`, `up_disabled`, `down`, and `down_disabled`, backed by introspection and negative checks for `up_arrow` / `down_arrow`.
- **Godot install/download:** Both reviewers agree autonomous download/install is no longer allowed. Default behavior is search-only, and install requires explicit user approval plus SHA256 provenance.
- **DangerButton role:** Both reviewers agree `role_danger` is now introduced before use, verified through the shared role table, and protected from fallback behavior.
- **ResourceSaver/data-only strip pass:** Both reviewers agree Plan 05-07 now contains a concrete Phase-4-equivalent strip pass with data-only invariants.

### Remaining Non-HIGH Work

- OpenCode reported no new concerns.
- Claude reported three MEDIUM and four LOW concerns. These are useful implementation-plan polish notes, but Claude did not classify any as convergence blockers.

### Unresolved HIGH Count

Current unresolved HIGH concerns after Cycle 2: **0**.

CYCLE_SUMMARY: current_high=0

## Current HIGH Concerns

None.
