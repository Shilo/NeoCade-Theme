# Phase 5: Core Controls — Buttons, Inputs, Labels, Panels (desktop) - Context

**Gathered:** 2026-05-07
**Status:** Ready for planning

<domain>
## Phase Boundary

Author the **per-direction personality** of the keystone Controls — every BaseButton-family class (7), every text input/display class (5), every Label class, every Panel class, plus SpinBox — by extending `NeoCadeTheme._regenerate_theme()`'s formula surface so the most-used Controls go from "baseline state coverage" (Phase 4 close) to "feature-complete with direction-specific shape language and chrome strategies" for ALL 5 approved directions (Pulse, Slate, Bubble, Daybreak, Burst).

**In scope:**

- **Variation chrome for all 14 type variations × 5 directions** — formula-derived StyleBoxFlat per state for: PrimaryButton / SecondaryButton / GhostButton / DangerButton / IconButton / FlatButton (TYPEVAR-01 — 6 button variations); HeaderLarge / HeaderMedium / HeaderSmall / Caption / CodeLabel (TYPEVAR-02 — 5 label variations); InfoText (TYPEVAR-03 — 1 RichTextLabel variation); CardPanel / HeroPanel (TYPEVAR-04 — 2 panel variations). Phase 4 already registered these and set explicit fonts + font_sizes (PITFALLS 1.2). Phase 5 authors the per-direction styleboxes that give them visual personality.
- **15th type variation: `Kicker`** — extend `TYPE_VARIATIONS` with `"Kicker": "Label"`; add explicit font + size (`tokens.kicker`); per-direction kicker style via `DIRECTION_PRESETS.shape` (Pulse/Bubble "uppercase-tracked-accent" — letter_spacing constant + uppercase font_color tint; Slate "small-caps-subtle"; Daybreak "sentence-case-accent"; Burst "uppercase-bold-larger" — wght=700 + size=`tokens.kicker+1`). Closes DESIGN_TOKENS §8.6's explicit Phase 5 todo.
- **Per-direction shape language baked into `DIRECTION_PRESETS.shape` sub-block** — `primary_radius`, `primary_padding` (Vector2i), `primary_strategy` ("bold-accent-fill" / "quiet-pill" / "pillowy-fully-rounded" / "friendly-generous" / "oversized-statement"), `ghost_strategy`, `tab_radius`, `chip_radius`, `surface_alpha_panels`, `surface_alpha_popup`, `surface_alpha_buttons`, `raised_lifts: {primary, secondary, ghost, panel, dialog, list, mark, chip, selected_tab, unselected_tab, selected_row}` (per DESIGN_TOKENS §5.1-§5.5 "Raised lifts"), `focus_offset` (per DESIGN_TOKENS §8.2: 0/2/2/2/1), and `kicker_style`. Sourced verbatim from DESIGN_TOKENS §5.1-§5.5.
- **BINDING_TABLE recipe schema extension** — add `"radius": "shape.<key>"`, `"padding": "shape.<key>"`, `"alpha": "shape.<key>"`, `"raised_intensity": "shape.<key>"` lookups. Extend `_resolve_recipe()` to dereference `shape.*` keys against the active direction's `DIRECTION_PRESETS.shape` block (with `DIRECTION_PRESET_DEFAULT.shape` fallback for custom themes — `NeoCadeTheme.new()` with non-approved hex). NEW recipe key per category: `{"role": "...", "radius": "shape.primary_radius", "padding": "shape.primary_padding", "raised_intensity": "shape.raised_lifts.primary"}`.
- **CodeEdit gutter chrome** (ROADMAP SC#2) — populate gutter colors (`breakpoint_color`, `code_folding_color`, `bookmark_color`, `executing_line_color`, `line_length_guideline_color`); add `folded` icon (the Phase 5-authored `code_folded.svg`) following Phase 4's icon contract (D-11). Syntax highlighting NOT in scope (FEATURES AF-7); only chrome around the text.
- **SpinBox themed end-to-end** (ROADMAP SC#4) — line-edit interior already covered by LineEdit-style baseline (Phase 4 BINDING_TABLE row 970); Phase 5 adds the up/down arrow icons (`spinbox_up.svg`, `spinbox_down.svg` at 32×32 reference, monochrome `#FFFFFF`, per Phase 4 D-11 import contract) + their wiring via BINDING_TABLE icon recipes.
- **Text class polish** for the 5 text Controls (Label / RichTextLabel / LineEdit / TextEdit / CodeEdit) — verify Phase 4 baseline caret/selection/placeholder/font colors render correctly per direction; add per-direction `selection_color` if `accent_offset` doesn't read well at base × surface combos; finalize InfoText (RichTextLabel variation) using the BL-02-corrected `normal_font` slot (Phase 4 close already wired; Phase 5 confirms variation chrome inherits correctly).
- **Pitfall 1.1 state-combo strategy resolution** — researcher empirically validates Godot 4.6's actual draw-order behavior (does the focus stylebox draw OVER pressed/checked, or does Godot replace it with `pressed_focus`/`checked_focus` slots when those slots are populated?). Planner picks one of two paths based on findings: (a) keep focus-as-overlay only — no explicit combo entries; (b) add explicit `pressed_focus`, `checked_focus`, `hover_pressed_focus` to BINDING_TABLE for Button / CheckBox / CheckButton / OptionButton (4 BaseButton variants where Godot exposes those slots). PLAN.md must document the empirical finding before authoring combo entries.
- **Panel + PanelContainer + variations** — Phase 4 has Panel base; Phase 5 adds CardPanel + HeroPanel variation styleboxes per direction (`shape.card_radius`, `shape.hero_radius`, surface_alpha_panels, raised_lifts.panel).
- **Phase 5 Plan 01: Godot 4.6 CLI prerequisite** — install `Godot_v4.6.x-stable_win64.exe` on the user's Windows machine, verify `godot --headless --import` round-trips this repo without errors (PentaTile pitfall #1 pattern), document path in `.planning/phases/05-.../helpers/godot-cli-path.txt`. ALL subsequent Phase 5 plans use `_save_*_tres()` helpers (Phase 4 pattern) that round-trip through Godot's ResourceSaver, replacing the Cycle 6 F7 hand-author fallback. This unblocks larger `.tres` files (variations may push past Phase 4's < 2 KB cap if the formula schema produces sub_resources for any reason).
- **Phase 5 verifier extensions** — `_phase5_verify.gd` (EditorScript) + `_phase5_verify_headless.gd` extending Phase 4's dual verifier with: 14-variation × 5-direction × per-state stylebox population check; Kicker variation registration + font + size assertion; CodeEdit gutter color presence; SpinBox arrow icon load; per-direction `shape.*` lookup integrity.

**Out of scope:**

- Tree (16 styleboxes + 12 icons + ~26 constants), ItemList, TabBar, TabContainer, FoldableContainer — Phase 6 (heavy class theming).
- Range controls beyond SpinBox (HSlider, VSlider, ProgressBar, HScrollBar, VScrollBar) — Phase 6.
- ScrollContainer, SplitContainer, MarginContainer constants — Phase 6 (per ROADMAP "container chrome where applicable").
- Layout-only Containers (HBox, VBox, Flow, Grid, Center) — anti-feature AF-11; only `separation` constants.
- Popup-class types (PopupPanel, PopupMenu, AcceptDialog, ConfirmationDialog, FileDialog, TooltipPanel, TooltipLabel, Window) — Phase 7 (separate Windows, Pitfall 1.7).
- MenuBar, ColorPicker (16 bespoke icons), GraphEdit / GraphNode / GraphFrame — Phase 7.
- Mobile branch tuning of variation chrome — Phase 8 (`platform=MOBILE` formula branch closes after desktop personality is locked).
- Showcase scene / theme picker / variation toggles — Phase 9.
- WCAG audit / cross-platform export QA / fresh-install dry-run — Phase 10.
- v2 light mode (`is_light=true` branch already structurally present from Phase 4; Phase 5 keeps the dark-only personality).
- Bespoke icons for Tree expand/collapse, ColorPicker, FileDialog, ScrollBar — Phases 6/7.
- Re-deriving DESIGN_TOKENS values, palettes, or `@export` set composition — locked at Phase 3.4 + 4.

</domain>

<decisions>
## Implementation Decisions

### Variation Authoring Mechanism

- **D-01:** **Formula-driven via BINDING_TABLE extension.** All 14 (15 with Kicker) type variations get first-class entries in `BINDING_TABLE` keyed by variation name (e.g., `BINDING_TABLE["PrimaryButton"]`, `BINDING_TABLE["GhostButton"]`, `BINDING_TABLE["CardPanel"]`, `BINDING_TABLE["Kicker"]`). Per-state recipes resolve through `_resolve_recipe()` exactly like base-Control entries, with new recipe schema keys (`shape.*`) for direction-specific shape values. The seamless `@exports` ↔ Theme Editor model from Phase 4 D-02 is preserved end-to-end: mutating `base_color` / `accent_color` / `corner_radius` / `raised` etc. re-derives all variation chrome on every direction. The `.tres` files stay data-only (~440 bytes); no `[sub_resource]` blocks for variation styleboxes.
- **D-02:** **`DIRECTION_PRESETS.shape` sub-block** carries per-direction shape language. The 5 `DIRECTION_PRESETS` rows (keyed by base_color hex) gain a `shape: Dictionary` sub-block with: `primary_radius: int`, `primary_padding: Vector2i`, `primary_strategy: StringName`, `ghost_strategy: StringName`, `secondary_radius: int`, `tab_radius: int`, `chip_radius: int`, `card_radius: int`, `hero_radius: int`, `surface_alpha_panels: float`, `surface_alpha_popup: float`, `surface_alpha_buttons: float`, `raised_lifts: Dictionary` (sub-keys: `primary`, `secondary`, `ghost`, `selected_tab`, `unselected_tab`, `panel`, `dialog`, `list`, `mark`, `selected_row`, `chip`), `focus_offset: int`, `kicker_style: StringName`. Values come VERBATIM from DESIGN_TOKENS §5.1-§5.5 (Pulse all-rectangular-radius-0 / Slate radius-14-rounded-pill / Bubble radius-26-pillowy-999-on-primary / Daybreak radius-8-airy / Burst radius-18-statement-28-on-primary). `DIRECTION_PRESET_DEFAULT.shape` is medium-spread / medium-radius (8 / 8 / `[16, 11]` / `friendly-generous` / `soft-outline` / surface_alpha 1.0 / focus_offset 2) for custom-themed `NeoCadeTheme.new()` consumers.
- **D-03:** **Recipe schema extensions.** New recipe keys: `"radius": "shape.<key>"` → applies to all four `corner_radius_*` properties on the StyleBoxFlat; `"padding": "shape.<key>"` → applies to all four `content_margin_*` properties (Vector2i interpreted as `[horizontal, vertical]`); `"alpha": "shape.<key>"` → multiplies the resolved bg_color's alpha (for surface_alpha_* family); `"raised_intensity": "shape.<key>"` → looked up against `presets.shape.raised_lifts.<sub_key>` instead of the literal int. `_resolve_recipe()` gains a new helper `_lookup_shape(presets, dotted_path)` that splits on `.` and walks the shape dict (e.g., `shape.raised_lifts.primary`).
- **D-04:** **Variation strategy enums drive multi-property recipes.** Some variations need different stylebox structures per direction — Pulse PrimaryButton is "bold-accent-fill" (bg=accent, text=text-on-accent), Slate is "quiet-pill" (bg=surface_panel + thin accent border, text=text_strong), Bubble is "pillowy-fully-rounded" (bg=accent, radius=999 even when corner_radius=26), Burst is "oversized-statement" (bg=accent, padding bigger than other directions). Implementation: BINDING_TABLE recipe references `"strategy": "shape.primary_strategy"`; `_resolve_recipe()` reads the StringName and dispatches to a small `_apply_strategy(sb, strategy_name, role_table, presets)` function that mutates the StyleBoxFlat per the strategy's known transforms. Strategies are first-class enums; planner enumerates them up-front (PRIMARY: 5 strategies; GHOST: 5 strategies). Adding a 6th direction in the future = adding strategy entries, not editing 14 recipe rows.

### Direction Coverage Scope

- **D-05:** **All 5 directions ship in Phase 5.** Phase 5 ships variation personality for Pulse + Slate + Bubble + Daybreak + Burst simultaneously. Formula-driven mechanism (D-01) means the per-direction cost is data entry into `DIRECTION_PRESETS.shape` (5 rows × ~15 keys = 75 values, all sourced from DESIGN_TOKENS §5.1-§5.5). Visual verification = single Godot editor pass loading each direction `.tres` and confirming variation chrome matches §5 intent (helped by `_phase5_verify.gd`). Maintains Phase 4's all-5-directions cadence; consumer can pick any direction immediately after Phase 5 close; Phase 9 showcase demos all 5 with full variation chrome.
- **D-06:** **No new `.tres` files in Phase 5.** The 5 existing direction `.tres` files (`pulse_neocade_theme.tres` … `burst_neocade_theme.tres`) stay byte-identical except for any `_regenerate_theme()` re-run via `ResourceSaver` (which may stabilize the ext_resource UID list). Variation chrome flows from BINDING_TABLE + DIRECTION_PRESETS at load time; no per-direction `[sub_resource]` blocks. Each `.tres` remains < 2 KB after Phase 5.

### Pitfall 1.1 State Combos

- **D-07:** **Researcher empirically validates Godot 4.6 draw-order behavior FIRST; planner picks combo strategy SECOND.** Researcher's RESEARCH.md must include a concrete test result: when `Button.focus` is populated with the Phase 4 focus_ring stylebox (transparent bg + 2px accent border + 2px expand) AND the Button is in `pressed`/`checked` state, does Godot draw the focus stylebox over the pressed/checked stylebox, or does it replace the focus stylebox with `pressed_focus`/`checked_focus` (and fall back to default if those slots are empty)? Test via `--headless` + a script that screenshots a Button in each state combination, OR via authoritative Godot source citation (`scene/gui/base_button.cpp` `_get_default_stylebox()` logic). Planner THEN picks: (a) overlay-only — keep current Phase 4 entries — OR (b) explicit combo BINDING_TABLE entries for Button / CheckBox / CheckButton / OptionButton. If (b), recipes layer state bg + focus border via a new `_make_combo_stylebox(state_role, focus_thickness)` helper.
- **D-08:** **COV-09 (focus indicator on every focusable Control) baseline established here, completes in Phase 7.** Phase 5 ensures every Control with a focus stylebox in BINDING_TABLE renders the focus ring correctly under hover / pressed / checked / disabled state combinations. Verified in `_phase5_verify.gd` by introspection (every focusable Control type has a `focus` slot populated). Final Tab-walk QA happens in Phase 10 (QA-03).

### Kicker Variation

- **D-09:** **Kicker added as 15th type variation in Phase 5.** Closes DESIGN_TOKENS §8.6's explicit Phase 5 todo. Implementation: extend `TYPE_VARIATIONS` with `"Kicker": "Label"`; `set_font("font", "Kicker", body_font)` (PITFALLS 1.2); `set_font_size("font_size", "Kicker", tokens.kicker)` (12px desktop / 13px mobile per PLATFORM_TOKENS). Per-direction kicker style via `DIRECTION_PRESETS.shape.kicker_style` enum: `"uppercase-tracked-accent"` (Pulse, Bubble) — applies font_color = accent + a constant `letter_spacing = 2` (wired via Theme constant if Godot Label supports it; else fallback to `tracking_via_string_transform = true` documented as v1.x limitation); `"small-caps-subtle"` (Slate) — font_color = text_muted; `"sentence-case-accent"` (Daybreak) — font_color = accent, no transform; `"uppercase-bold-larger"` (Burst) — wght=700 + size = `tokens.kicker + 1`. BINDING_TABLE adds `"Kicker": {"color": {"font_color": {"role": "..."}}}` per direction-aware lookup; concrete font_color resolves via `kicker_style`-dispatched `_apply_kicker_style()` similar to D-04's strategy dispatch.
- **D-10:** **Kicker counts toward TYPEVAR-06 documentation deliverable** (finalized in Phase 8). Phase 5 adds Kicker to `_phase5_verify.gd`'s variation list (15 entries); Phase 8 documents Kicker in `MOBILE-DESIGN-SPEC.md` per TYPEVAR-06.

### Verification & Build Tooling

- **D-11:** **Godot 4.6 CLI is a Phase 5 prerequisite** (Plan 01 deliverable). The Cycle 6 F7 hand-author fallback used in Phase 4 (executor lacked Godot CLI; `.tres` files hand-authored byte-identical to ResourceSaver output) is REPLACED for Phase 5: `Godot_v4.6.x-stable_win64.exe` installed on the user's Windows machine; Phase 5 helpers (`_phase5_save_*.gd`) round-trip through `ResourceSaver.save()`. Plan 01 must verify (a) `godot --version` returns 4.6.x; (b) `godot --headless --path . --import` returns clean stderr (no `^(ERROR|SCRIPT ERROR):` lines per PentaTile pitfall #1); (c) loading any direction `.tres` from `--headless` script and asserting `Theme.has_stylebox("normal", "PrimaryButton")` succeeds. Path documented in `.planning/phases/05-.../helpers/godot-cli-path.txt` (typical: `C:\Users\shilo\Godot\Godot_v4.6.x-stable_win64.exe` or wherever user installs).
- **D-12:** **Dual EditorScript + headless verifier extended for Phase 5.** `_phase5_verify.gd` (Tools menu in Godot editor) + `_phase5_verify_headless.gd` (CLI batch) share an assertion battery covering: 15-variation count (TYPE_VARIATIONS.size() == 15); per-variation `set_font` + `set_font_size` calls fire; per-direction `shape.*` lookups resolve (5 directions × ~15 shape keys = 75 values present, no nulls); BINDING_TABLE variation entries present for all 15 (e.g., `BINDING_TABLE.has("PrimaryButton")`); Pitfall 1.1 result codified per D-07 outcome (overlay-only OR combo entries present); CodeEdit gutter color slots populated; SpinBox up/down arrow icons load. The verifier becomes the structural gate for Phase 5 verification.

### Carry-Forward From Phase 4

- **D-13:** **D-01 (additive iteration, no `clear()`) preserved.** Phase 5 BINDING_TABLE additions follow the same iteration contract; never call `Theme.clear()`.
- **D-14:** **D-04 escape hatch preserved.** Variations not in BINDING_TABLE remain untouched at load — kept as the published architectural escape hatch for consumers who want to author one-off variations via `theme.set_stylebox(...)` calls outside `_regenerate_theme()`.
- **D-15:** **D-13 class defaults stay Slate-ish neutral.** Phase 5 doesn't touch `@export` defaults. Pulse remains the recommended starter via `main.tscn` + README; class-default custom themes use `DIRECTION_PRESET_DEFAULT.shape`.
- **D-16:** **BL-02 fix carries forward.** RichTextLabel variations use `normal_font` slot (Phase 4 close fix); Phase 5's InfoText polish + future RTL variations follow the same pattern. Documented in code comment near `set_font("normal_font", "InfoText", body_font)`.
- **D-17:** **Inter Variable Roman ONLY (UD-4 Option D).** Phase 5 doesn't bundle additional fonts. Kicker variation uses Inter (no display font); CodeLabel uses Inter (consumer overrides per FONT-04 stricken / FONT-09 (b)).

### Claude's Discretion

- Exact recipe-key naming for shape lookups (`"radius": "shape.primary_radius"` vs `"corner_radius": "shape.primary_radius"` — pick whichever reads cleaner alongside existing `"role"` and `"raised_intensity"` keys).
- Strategy dispatch implementation (`_apply_strategy()` as a switch, dictionary-of-Callables, or inline in `_resolve_recipe()` — pick simplest that scales to ~10 strategies across primary/ghost/kicker categories).
- Vector2i vs `[int, int]` array for paddings in DIRECTION_PRESETS (Vector2i is the project convention per Phase 4 FOUND-02 "any future paired x/y values use Vector2i" — adopt for `primary_padding`).
- CodeEdit gutter color granularity — populate only the named slots in DESIGN_TOKENS roles (5-6 colors) vs full Godot 4.6 gutter color set (8-10 colors); pick based on visual completeness of the showcase CodeEdit demo.
- SpinBox arrow icon style — single triangular arrow vs chevron-style, monochrome 32×32 reference following Phase 4 D-11 import contract; pick whichever reads at small sizes.
- Whether to add `pressed_focus` / `checked_focus` to BINDING_TABLE per D-07's research outcome — researcher's empirical finding determines this; don't pre-commit.
- File location for `_phase5_save_*.gd` helpers (`.planning/phases/05-.../helpers/` per Phase 4 F3 path discipline; addon root contains exactly the 1 production `.gd` file).

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents (researcher, planner, executor) MUST read these before planning or implementing.**

### Primary Phase 5 Contract (MUST READ FIRST)

- `.planning/DESIGN_TOKENS.md` §5.1–§5.5 — per-direction "Theme Editor override intent" lines that source `DIRECTION_PRESETS.shape` values verbatim (Pulse rectangular radius=0; Slate rounded-pill radius=14; Bubble pillowy radius=26+999-on-primary; Daybreak airy radius=8; Burst statement radius=18+28-on-primary).
- `.planning/DESIGN_TOKENS.md` §7.3 — Pitfall 1.1 state combinations contract (the empirical question for D-07).
- `.planning/DESIGN_TOKENS.md` §8.2 — focus ring construction (per-direction `focus_offset`).
- `.planning/DESIGN_TOKENS.md` §8.5 — typography contract + PITFALLS 1.2 mandate (every variation needs explicit `set_font` + `set_font_size`).
- `.planning/DESIGN_TOKENS.md` §8.6 — kicker variation explicit Phase 5 todo (closed by D-09).

### Phase 4 Foundation (MUST READ — Phase 5 builds on this)

- `addons/neocade_theme/neocade_theme.gd` — production class; Phase 5 extends `BINDING_TABLE`, `DIRECTION_PRESETS`, `TYPE_VARIATIONS`, `_resolve_recipe()`, `_regenerate_theme()`. D-01 (additive iteration), D-04 (escape hatch) invariants preserved.
- `.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-CONTEXT.md` — Phase 4 architectural decisions (D-01, D-02 seamless `@exports` ↔ Theme Editor model, D-04, D-13 class defaults).
- `.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-VERIFICATION.md` — Phase 4 verification report; BL-01 (font bundle) + BL-02 (RTL slot) both fixed; Phase 5 inherits the corrected pattern.
- `.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/helpers/_phase4_verify.gd` + `_phase4_verify_headless.gd` — dual verifier pattern that Phase 5 extends.
- `.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/helpers/_phase4_import.gd` — `_save_pulse_tres()` / `_save_peer_tres()` ResourceSaver round-trip pattern Phase 5 reuses.

### Project Canon

- `.planning/PROJECT.md` — hard constraints, architecture lock, `each subclass .tres must be feature-complete to godot-minimal-theme's bar` (informs D-05 all-5-directions scope).
- `.planning/ROADMAP.md` §"Phase 5" (lines 191-201) — 5 success criteria. SC#1 (7 BaseButton family full state coverage); SC#2 (5 text classes + CodeEdit gutter); SC#3 (14 variations declared); SC#4 (Panel + PanelContainer + SpinBox); SC#5 (focus = OUTER ring, not fill replacement).
- `.planning/ROADMAP.md` §"Phase 6" + §"Phase 7" — out-of-scope reference (what Phase 5 does NOT ship).
- `.planning/REQUIREMENTS.md` lines 100-119 — COV-02 (BaseButton 7), COV-03 (5 text), COV-09 (focus indicator), TYPEVAR-01..05 (14 variations + explicit fonts). Lines 86-97 — TOKEN-05 (4-rung corner radius scale, base radius), TOKEN-09 (M3 state-layer constants), TOKEN-10 (M3 type scale incl. label-small 11/12 for Kicker).
- `.planning/STATE.md` — current phase + sequencing guard.

### Architecture + Feasibility Inputs (Phase 5 reads to validate D-07)

- `.planning/research/PITFALLS.md` 1.1 — focus is OUTSIDE corner radius bounds; state combos. PHASE 5 RESEARCHER MUST validate empirically per D-07.
- `.planning/research/PITFALLS.md` 1.2 — type variations don't inherit fonts (Phase 4 close already complies; Phase 5 adds Kicker following same pattern).
- `.planning/research/PITFALLS.md` 10.3 — clean state switching (variations must regenerate cleanly when consumer mutates `@exports`).
- `.planning/research/MINIMAL-THEME-DISSECTION.md` — godot-minimal-theme per-Control state enumeration (the "godot-minimal-theme bar" reference for variation completeness).
- `.planning/research/MINIMAL-THEME-COVERAGE-DELTA.md` — 37-row scorecard; Phase 5 contributes to COV-01 (begins here, completes Phase 7).

### Visual Design Inputs

- `.planning/mockups/3.4/data/directions.json` — per-direction `shape_language` blocks (the source for DIRECTION_PRESETS.shape values, alongside DESIGN_TOKENS §5.1-§5.5).
- `.planning/mockups/3.4/finalist-gallery.html` — 4-grid mockup output the Phase 5 result should visually match for Pulse (recommended starter benchmark).
- `.planning/mockups/3.4/src/neocade-mockups.js` — `deriveTokens(direction, platform, raised)` strategy dispatch reference; some of the strategy-name dispatches Phase 5 ports may have analogues here.
- `.planning/research/MD3-RESEARCH.md` — M3 grammar; type scale + role tokens (Phase 5 reaffirms TOKEN-09 state-layer model is structurally identical for variations as for base Controls).
- `.planning/research/FLAT-3D-UI-RESEARCH.md` — extruded-flat raised-mode StyleBoxFlat construction (Phase 5 wires `raised_lifts.<sub_key>` per variation so primary/secondary/ghost lift differently per direction).
- `.planning/research/FEATURES.md` — 35-class Control coverage matrix + 13 type variations (Phase 5 ships 14+1=15 with Kicker; Phase 4 set the 14 baseline). AF-7 (no syntax highlighting) constrains CodeEdit scope.

### Godot 4.6 API References

- Godot 4.6 `Theme` class — `set_type_variation(variation, base_type)` (already done Phase 4); `set_stylebox(name, theme_type, stylebox)` accepts variation names directly (no separate registration); `set_color`/`set_constant`/`set_font_size`/`set_icon` same.
- Godot 4.6 `StyleBoxFlat` — `corner_radius_top_left/top_right/bottom_left/bottom_right`, `content_margin_left/right/top/bottom`, `border_width_*`, `bg_color.a` (alpha), `expand_margin_*` (focus ring).
- Godot 4.6 `BaseButton` source — Phase 5 researcher cites `scene/gui/base_button.cpp` for D-07 draw-order finding.
- Godot 4.6 `CodeEdit` class — gutter color slot names (`breakpoint_color`, `code_folding_color`, `bookmark_color`, `executing_line_color`, `line_length_guideline_color`).
- Godot 4.6 `SpinBox` — `up_arrow` / `down_arrow` icon slot names (verify via `Theme.get_icon_list("SpinBox")`).
- Godot 4.6 `ResourceSaver.save(theme, path)` — round-trip serialization for variation chrome (D-11 prerequisite).

### Phase 4 Outputs Phase 5 Extends

- `addons/neocade_theme/neocade_theme.gd` lines 393-412 — `TYPE_VARIATIONS` dict (14 entries; Phase 5 adds Kicker = 15).
- `addons/neocade_theme/neocade_theme.gd` lines 362-379 — `DIRECTION_PRESETS` (Phase 5 adds `shape` sub-block to all 5 + DEFAULT).
- `addons/neocade_theme/neocade_theme.gd` lines 552-1124 — `BINDING_TABLE` (Phase 5 adds 15 variation entries; potentially adds combo entries per D-07).
- `addons/neocade_theme/neocade_theme.gd` lines 1135-1230 — `_resolve_recipe()` (Phase 5 adds `shape.*` lookups + strategy dispatch).
- `addons/neocade_theme/neocade_theme.gd` lines 165-211 — `set_font` + `set_font_size` calls (Phase 5 adds Kicker pair).

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets

- **`addons/neocade_theme/neocade_theme.gd`** — Phase 4's production class. Phase 5 extends in place; no new addon-root `.gd` files (Phase 4 F3 path discipline).
- **`DIRECTION_PRESETS` table** (lines 362-379) — 5 hex-keyed entries; Phase 5 adds `shape` sub-block to each + the DEFAULT.
- **`BINDING_TABLE`** (lines 552-1124) — 37 base-Control rows; Phase 5 adds 15 variation rows (PrimaryButton, SecondaryButton, GhostButton, DangerButton, IconButton, FlatButton, HeaderLarge, HeaderMedium, HeaderSmall, Caption, CodeLabel, InfoText, CardPanel, HeroPanel, Kicker).
- **`_resolve_recipe()`** (lines 1135-1230) — already supports `role`, `raised_intensity`, `disabled`, `alpha`, `value: tokens.<key>`, `icon: <name>`. Phase 5 adds `radius: shape.<key>`, `padding: shape.<key>`, `alpha: shape.<key>`, `raised_intensity: shape.<key>` lookups + strategy dispatch.
- **Phase 4 dual verifier pattern** (`.planning/phases/04-.../helpers/_phase4_verify.gd` + `_phase4_verify_headless.gd`) — Phase 5 forks/extends with Phase 5-specific assertion battery.
- **Phase 4 ResourceSaver helper** (`.planning/phases/04-.../helpers/_phase4_import.gd` `_save_pulse_tres()` / `_save_peer_tres()`) — Phase 5 reuses or re-emits as `_phase5_*.gd` once Godot 4.6 CLI is installed (D-11).
- **Phase 4 icon import contract** (D-11) — Phase 5's new icons (`code_folded.svg`, `spinbox_up.svg`, `spinbox_down.svg`) follow the exact contract: 32×32 reference, monochrome `#FFFFFF`, `.import` sidecar with `svg/scale=2.0` + `mipmaps/generate=true` + `compress/mode=0` + `process/fix_alpha_border=true`.

### Established Patterns

- **Recipe-as-Dictionary in BINDING_TABLE** — Phase 4 schema: `{"role": ..., "raised_intensity": ..., "disabled": ..., "alpha": ...}` for stylebox; `{"role": ..., "disabled": ...}` for color; `{"value": "tokens.<key>"}` for constant/font_size; `{"icon": "<filename>"}` for icon. Phase 5 schema additions: `{"radius": "shape.<key>", "padding": "shape.<key>", "strategy": "shape.<strategy_key>"}` for stylebox; `{"role": ..., "kicker_style": "shape.kicker_style"}` for color (Kicker font_color).
- **Per-direction lookup keyed by base_color hex** — `DIRECTION_PRESETS.get(base_color.to_html(false).to_upper(), DIRECTION_PRESET_DEFAULT)`. Phase 5 keeps this pattern; `shape` sub-block goes through the same lookup.
- **No `Theme.clear()` invariant (D-01)** — Phase 5 BINDING_TABLE additions do `set_stylebox`/`set_color`/etc. via the existing iteration loop; never `clear()`.
- **D-04 escape hatch** — variations not in BINDING_TABLE are left untouched. If a consumer wants a one-off variation outside Phase 5's 15, they can `theme.set_stylebox("normal", "MyCustomVariation", custom_sb)` and Phase 5's iteration won't overwrite it.
- **Helper file path discipline (Phase 4 F3 fix)** — addon root contains exactly 1 `.gd` (`neocade_theme.gd`); Phase 5 helpers go under `.planning/phases/05-.../helpers/`.
- **Atomic-commit discipline** — Phase 1-4 plans show file-scoped commits per task; Phase 5 plans continue this pattern.
- **PowerShell `-EncodedCommand` verification on Windows** (Phase 3.4-04 SUMMARY tech-stack.patterns) — Phase 5 plans use this for any Windows-side verification.

### Integration Points

- **`addons/neocade_theme/neocade_theme.gd`** — single edit target for Phase 5 production code; all changes are extensions to existing structures (TYPE_VARIATIONS, DIRECTION_PRESETS, BINDING_TABLE, _resolve_recipe).
- **`addons/neocade_theme/icons/`** — gains 3 new SVGs in Phase 5 (`code_folded.svg`, `spinbox_up.svg`, `spinbox_down.svg`) + their `.import` sidecars; brings icon count from 10 to 13.
- **`addons/neocade_theme/{name}_neocade_theme.tres` ×5** — no new files; existing 5 round-trip through ResourceSaver once Godot 4.6 CLI lands per D-11.
- **`main.tscn`** — no changes (still references `pulse_neocade_theme.tres`).
- **`.planning/phases/05-.../helpers/`** — new directory; mirrors Phase 4 helpers structure.
- **REQUIREMENTS.md updates** — Phase 5 closes COV-02 (BaseButton 7 with full state coverage), COV-03 (5 text + CodeEdit gutter), TYPEVAR-01 (6 button variations chrome authored), TYPEVAR-02 (5 label + new Kicker), TYPEVAR-03 (InfoText polish), TYPEVAR-04 (CardPanel + HeroPanel chrome), TYPEVAR-05 (explicit fonts already done Phase 4; Phase 5 confirms Kicker complies). Marks COV-09 / COV-01 / COV-07 / TYPEVAR-06 as in-progress (cumulative across phases).

</code_context>

<specifics>
## Specific Ideas

- **The seamless `@exports` ↔ Theme Editor model (Phase 4 D-02) is preserved at the variation layer in Phase 5.** Variations are formula-derived just like base entries; mutating any `@export` re-derives all variation chrome on every direction. No `[sub_resource]` blocks for variations in `.tres` files. The architectural through-line of "exports DRIVE Theme Editor entries" extends from base Controls (Phase 4) to variation chrome (Phase 5) without exception.
- **Per-direction shape language lives in `DIRECTION_PRESETS.shape`, NOT in `@export`.** The 9 `@export` set is intentionally minimal (Phase 4 FOUND-02 lock); per-direction radii / strategies / surface alphas / raised lift maps live in DIRECTION_PRESETS keyed by base_color hex. Custom themes (`NeoCadeTheme.new()` with non-approved hex) get `DIRECTION_PRESET_DEFAULT.shape`.
- **Strategies are first-class enums, not free-form recipe properties.** `primary_strategy` is `"bold-accent-fill" | "quiet-pill" | "pillowy-fully-rounded" | "friendly-generous" | "oversized-statement"` — closed enum sourced from DESIGN_TOKENS §5.1-§5.5. `ghost_strategy` is similarly enumerated. Adding a 6th approved direction in v2 = adding a strategy entry, not editing 14 recipes.
- **Kicker closes a literal Phase 5 todo from DESIGN_TOKENS §8.6.** "Phase 5 defines the kicker variation; for now, recorded here as a Phase 5 todo." Phase 5 honors the marker — Kicker ships as the 15th type variation.
- **Pitfall 1.1 strategy is empirically grounded.** Researcher's RESEARCH.md must include a concrete Godot 4.6 draw-order test result before planner picks (a) overlay-only vs (b) explicit combo entries. No speculation; the choice is derived from Godot's actual behavior on the project's GL Compatibility renderer.
- **Godot 4.6 CLI is a Phase 5 hard prerequisite.** Cycle 6 F7 hand-author fallback is retired; Phase 5 Plan 01 is "install + verify Godot CLI". Subsequent plans use `ResourceSaver` round-trip exclusively. Eliminates the brittle byte-alignment work Phase 4 had to do.
- **All 5 directions ship together in Phase 5, not staggered.** Maintains Phase 4 cadence; demos correctly in Phase 9 showcase; matches PROJECT.md "feature-complete to godot-minimal-theme's bar" pledge per direction.
- **COV-09 baseline established here, completes in Phase 7.** Phase 5 covers focus indicators on every Phase 5 Control; Phases 6/7 add the same pattern to their Controls; Phase 10 verifies via Tab-walk QA.

</specifics>

<deferred>
## Deferred Ideas

- **Bespoke icons for non-Phase-5 Controls** — Tree expand/collapse + checked/unchecked + sort arrows + TabBar/TabContainer increment/decrement/menu (Phase 6); ColorPicker preset/screen-pick/sample-bg/recent + FileDialog parent/folder/file/file-up/back/forward/reload + ScrollBar increment/decrement/grabber (Phase 7).
- **Tree theming** — 16 styleboxes + 12 icons + ~26 constants — heaviest single class — Phase 6.
- **Range Controls beyond SpinBox** — HSlider, VSlider, ProgressBar, HScrollBar, VScrollBar — Phase 6.
- **Container chrome where applicable** — ScrollContainer, SplitContainer, MarginContainer — Phase 6 (Panel + PanelContainer ship in Phase 5).
- **Popup-class theming** — PopupPanel, PopupMenu, AcceptDialog, ConfirmationDialog, FileDialog, TooltipPanel, TooltipLabel, Window — Phase 7 (separate Windows, Pitfall 1.7 — themed as first-class types).
- **MenuBar + ColorPicker (16 icons) + GraphEdit / GraphNode / GraphFrame** — Phase 7 (closes 37/37 desktop coverage).
- **Mobile-branch tap-target audit + `MOBILE-DESIGN-SPEC.md`** — Phase 8.
- **Showcase scene + theme picker + raised toggle + platform selector** — Phase 9.
- **WCAG audit + cross-platform export QA + COV-10 zero-fallback verification** — Phase 10.
- **TYPEVAR-06 documentation finalization** — Phase 8 (incorporates Kicker per D-10).
- **Light mode (`is_light=true` branch already structurally present from Phase 4)** — v2.
- **Alternate palette variants (magenta, amber)** — v2.
- **Inter Italic Variable** — v1.x (synthetic italic transform in v1 per FONT-07).
- **CJK font bundling** — v2 / opt-in per UD-2; Phase 5 doesn't change UD-2 default.
- **Editor-only theme types (FlatButton-as-editor / MainScreenButton / etc.)** — v1.x (Phase 5's FlatButton is the runtime variation, not the editor's `FlatButton` class which is a different type).
- **Deeper VoiceOver/TalkBack/AccessKit screen-reader QA** — v1.x per UD-6.
- **Strategy enum expansion (6th direction)** — v2; current 5 strategies cover all 5 approved directions.
- **EditorInspectorPlugin for variation authoring UX** — deferred indefinitely (Phase 4 D-05 holds; Claude authors variations programmatically).
- **Binding mechanism revision (per-resource metadata vs property-name convention)** — v1.x refinement (Phase 4 D-03 noted this as REVISABLE; Phase 5 picks up the slot-name + property-name binding table approach unchanged).

### Reviewed Todos (not folded)

None — no pending todos matched Phase 5 (per `gsd-sdk query todo.match-phase 5`).

</deferred>

---

*Phase: 05-core-controls-buttons-inputs-labels-panels-desktop*
*Context gathered: 2026-05-07*
