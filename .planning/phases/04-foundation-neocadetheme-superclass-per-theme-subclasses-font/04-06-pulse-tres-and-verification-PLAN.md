---
phase: 04-foundation-neocadetheme-superclass-per-theme-subclasses-font
plan: 06
type: execute
wave: 3
depends_on:
  - "04-04"
  - "04-05"
files_modified:
  - addons/neocade_theme/pulse_neocade_theme.tres
autonomous: true
requirements:
  - FOUND-03
must_haves:
  truths:
    - "`addons/neocade_theme/pulse_neocade_theme.tres` exists and is `[gd_resource type=\"NeoCadeTheme\" format=3]` (NOT `Theme`)."
    - "The `.tres` saves the 9 `@export` values per DESIGN_TOKENS §5.1: `base_color = Color(\"#151A2E\")`, `accent_color = Color(\"#8BFF6A\")`, `raised = false`, `platform = 2` (Platform.AUTO), `corner_radius = 0`, `spacing = 18`, `raised_strength = 3`, `focus_thickness = 2`, `outline_width = 1`."
    - "Loading `pulse_neocade_theme.tres` in Godot Editor opens it as a `NeoCadeTheme` instance with the values above; `_regenerate_theme()` runs at load time (per `_init()` in Plan 04-01) populating all 37 BINDING_TABLE Control entries + 13 type variations."
    - "Verification (manual or scripted): after load, `theme.has_stylebox(\"normal\", \"Button\")` returns `true`; `theme.has_stylebox(\"panel\", \"Tree\")` returns `true`; `theme.has_color(\"font_color\", \"Button\")` returns `true`; `theme.get_type_variation_base(\"PrimaryButton\")` returns `\"Button\"`; `theme.has_font(\"font\", \"HeaderLarge\")` returns `true`."
    - "Toggling `raised = true` then `raised = false` on the loaded `.tres` (in Godot Editor's Inspector) triggers `_regenerate_theme()` and produces correct shadow_size values on raised-eligible Controls (verified visually or via spot-check on 1-2 stylebox slots)."
    - "Toggling `platform = MOBILE` on the loaded `.tres` triggers regeneration and produces `Button.normal.content_margin_*` values consistent with mobile platform tokens (the spacing scaling is observable)."
    - "Setting `base_color = Color(\"#F0F0F0\")` (a forced-light test) on the loaded `.tres` triggers regeneration; `theme.get_color(\"font_color\", \"Button\")` returns `Color(\"#1B2230\")` (the dark text on light surface, per DESIGN_TOKENS §6.4 `is_light` flip). After this verification the `.tres` is reverted to `Color(\"#151A2E\")`."
  artifacts:
    - addons/neocade_theme/pulse_neocade_theme.tres (Pulse direction; recommended starter)
  key_links:
    - ".planning/DESIGN_TOKENS.md §5.1 (Pulse @export values)"
    - ".planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-CONTEXT.md D-13, D-14 step 7-8"
    - ".planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-RESEARCH.md §7 (Pulse verification methodology)"
    - ".planning/mockups/3.4/finalist-gallery.html (Pulse 4-grid visual reference)"
---

<objective>
Author the Pulse `.tres` (the recommended starter direction; FIRST per D-14 + DESIGN_TOKENS §12.4 implementation order) and verify end-to-end that loading it produces a fully-populated Theme matching the Phase 3.4 finalist mockup output. This is the Phase 4 critical path: Pulse must work before Slate / Bubble / Daybreak / Burst (Plan 04-07) follow.

Purpose: validate that the engine (Plans 04-01..05) correctly produces a renderable Theme from the Pulse `@export` values + that subsequent direction `.tres` files only need to ship data.
Output: 1 new `.tres` file at `addons/neocade_theme/pulse_neocade_theme.tres` + verification artifacts (a small GDScript helper script that loads + spot-checks values; runtime smoke evidence in the Plan 04 SUMMARY).
</objective>

<execution_context>
@$HOME/.codex/get-shit-done/workflows/execute-plan.md
@$HOME/.codex/get-shit-done/templates/summary.md
</execution_context>

<context>
@.planning/DESIGN_TOKENS.md
@.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-CONTEXT.md
@.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-RESEARCH.md
@.planning/mockups/3.4/finalist-gallery.html
@.planning/mockups/3.4/data/directions.json
@addons/neocade_theme/neocade_theme.gd

<interfaces>
After Plan 04-05 closes, `NeoCadeTheme` (`addons/neocade_theme/neocade_theme.gd`) is feature-complete: loading any `[gd_resource type="NeoCadeTheme"]` `.tres` with the 9 `@export` values populated triggers `_regenerate_theme()` which populates 37 Controls + 13 variations.

This plan ships only the Pulse direction's `.tres` data + verification. Plan 04-07 ships the remaining 4 directions; Plan 04-08 ships metadata.
</interfaces>
</context>

<tasks>

<task type="auto">
  <name>Task 1: Author addons/neocade_theme/pulse_neocade_theme.tres</name>
  <read_first>
    - .planning/DESIGN_TOKENS.md (§5.1 Pulse table)
    - addons/neocade_theme/neocade_theme.gd (verify NeoCadeTheme class is loadable as a resource type)
    - .planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-CONTEXT.md (D-14 step 7)
  </read_first>
  <files>
    - addons/neocade_theme/pulse_neocade_theme.tres (NEW)
  </files>
  <action>
    Author `addons/neocade_theme/pulse_neocade_theme.tres` with this exact content (Godot 4.6 resource format 3):

    ```
    [gd_resource type="NeoCadeTheme" script_class="NeoCadeTheme" load_steps=2 format=3 uid="uid://neocade_pulse_v1"]

    [ext_resource type="Script" path="res://addons/neocade_theme/neocade_theme.gd" id="1_script"]

    [resource]
    script = ExtResource("1_script")
    base_color = Color(0.0823529, 0.101961, 0.180392, 1)
    accent_color = Color(0.545098, 1, 0.415686, 1)
    raised = false
    platform = 2
    corner_radius = 0
    spacing = 18
    raised_strength = 3
    focus_thickness = 2
    outline_width = 1
    ```

    Color value derivation (RGBA 0..1 floats from hex):
    - `base_color = Color("#151A2E")` → `Color(21/255, 26/255, 46/255, 1)` = `Color(0.0823529, 0.101961, 0.180392, 1)`.
    - `accent_color = Color("#8BFF6A")` → `Color(139/255, 255/255, 106/255, 1)` = `Color(0.545098, 1, 0.415686, 1)`.

    Platform value derivation: `Platform.AUTO` is the third enum value (DESKTOP=0, MOBILE=1, AUTO=2). Godot's enum serialization in `.tres` is the integer index. `platform = 2` is correct for AUTO.

    Implementation steps:
    1. Use PowerShell `Set-Content -Encoding UTF8` to write the file (no BOM).
    2. The synthetic UID `uid://neocade_pulse_v1` is normalized by Godot on first import; verification checks the resource type + `@export` values, not UID format.
    3. Verify the file parses as a `[gd_resource]` block (Godot 4 syntax).

    NOTE: in Godot 4.6, when a resource references a custom `class_name` script, the `[gd_resource]` header may include `script_class="NeoCadeTheme"` (the global class name registered via `class_name NeoCadeTheme`). If Godot complains about the `type="NeoCadeTheme"` attribute (which it should accept once the script is registered), the alternative is `[gd_resource type="Resource" script_class="NeoCadeTheme" ...]` with the `[ext_resource type="Script"]` line referring to `neocade_theme.gd`. Both forms produce the same loaded resource. Pick whichever opens correctly in Godot Editor; the verify script checks the loaded type via `theme is NeoCadeTheme` runtime check.
  </action>
  <acceptance_criteria>
    - `addons/neocade_theme/pulse_neocade_theme.tres` exists.
    - File first line begins with `[gd_resource` and includes `format=3`.
    - File references the script `res://addons/neocade_theme/neocade_theme.gd` via `[ext_resource type="Script"`.
    - File contains a `[resource]` section.
    - File contains `base_color = Color(0.0823529, 0.101961, 0.180392, 1)` (the float-encoded `#151A2E`).
    - File contains `accent_color = Color(0.545098, 1, 0.415686, 1)` (the float-encoded `#8BFF6A`).
    - File contains `raised = false`.
    - File contains `platform = 2` (Platform.AUTO).
    - File contains `corner_radius = 0`.
    - File contains `spacing = 18`.
    - File contains `raised_strength = 3`.
    - File contains `focus_thickness = 2`.
    - File contains `outline_width = 1`.
    - File contains `script_class="NeoCadeTheme"` OR `type="NeoCadeTheme"` in the header (one or both — Godot accepts either pattern for class-named resources).
    - File is between 200 and 800 bytes (sanity bounds — small data-only resource).
  </acceptance_criteria>
  <verify>
    <automated>
      powershell -NoProfile -Command "$p='addons/neocade_theme/pulse_neocade_theme.tres'; if (-not (Test-Path $p)) { throw '.tres missing' }; $g=Get-Content -Raw $p; foreach($n in '[gd_resource','format=3','[ext_resource type=\"Script\"','res://addons/neocade_theme/neocade_theme.gd','[resource]','base_color = Color(0.0823529, 0.101961, 0.180392, 1)','accent_color = Color(0.545098, 1, 0.415686, 1)','raised = false','platform = 2','corner_radius = 0','spacing = 18','raised_strength = 3','focus_thickness = 2','outline_width = 1') { if ($g -notmatch [regex]::Escape($n)) { throw \"missing: $n\" } }; if ($g -notmatch 'NeoCadeTheme') { throw 'NeoCadeTheme reference missing in header' }; $size=(Get-Item $p).Length; if ($size -lt 200 -or $size -gt 800) { throw \"file size $size bytes outside 200-800 range\" }"
    </automated>
  </verify>
  <done>Pulse `.tres` ships the recommended-starter direction's `@export` values; the engine produces a renderable theme on load.</done>
</task>

<task type="auto">
  <name>Task 2: Author a verification helper at addons/neocade_theme/_phase4_verify.gd and run smoke checks</name>
  <read_first>
    - addons/neocade_theme/pulse_neocade_theme.tres
    - addons/neocade_theme/neocade_theme.gd
    - .planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-RESEARCH.md (§7 verification methodology, §11 verification gates)
  </read_first>
  <files>
    - addons/neocade_theme/_phase4_verify.gd (NEW — temp helper, deleted in Phase 11)
  </files>
  <action>
    Author a `@tool`-able GDScript helper that loads `pulse_neocade_theme.tres` and asserts:
    1. Loaded resource is a `NeoCadeTheme` instance.
    2. The 9 `@export` values match the §5.1 spec.
    3. After `_regenerate_theme()` (which `_init()` triggers): every BINDING_TABLE root key has `has_stylebox` / `has_color` / `has_constant` / `has_font` / `has_icon` returning true for at least one slot.
    4. Every TYPE_VARIATIONS key returns `get_type_variation_base()` == its base type.
    5. `is_light` is `false` (Pulse base `#151A2E` luminance < 0.5).
    6. Spot-check 3 derived values: `theme.get_stylebox("normal", "Button")` returns a non-null StyleBoxFlat; `theme.get_color("font_color", "Label")` is a non-default Color; `theme.has_font("font", "HeaderLarge")` is true.

    Helper file content:

    ```gdscript
    @tool
    extends EditorScript

    ## Phase 4 verification helper. Run via Godot Editor → File → Run → script.
    ## Asserts that loading pulse_neocade_theme.tres produces a feature-complete NeoCadeTheme.
    ## DELETE this file in Phase 11 before distribution.

    func _run() -> void:
        var path := "res://addons/neocade_theme/pulse_neocade_theme.tres"
        var theme: NeoCadeTheme = load(path) as NeoCadeTheme
        assert(theme != null, "pulse_neocade_theme.tres did not load as NeoCadeTheme")

        # 1. Verify @export values
        assert(theme.base_color == Color("#151A2E"), "base_color mismatch")
        assert(theme.accent_color == Color("#8BFF6A"), "accent_color mismatch")
        assert(theme.raised == false, "raised mismatch")
        assert(theme.platform == NeoCadeTheme.Platform.AUTO, "platform mismatch")
        assert(theme.corner_radius == 0, "corner_radius mismatch")
        assert(theme.spacing == 18, "spacing mismatch")
        assert(theme.raised_strength == 3, "raised_strength mismatch")
        assert(theme.focus_thickness == 2, "focus_thickness mismatch")
        assert(theme.outline_width == 1, "outline_width mismatch")
        assert(theme.is_light == false, "is_light should be false for Pulse #151A2E")

        # 2. Verify BINDING_TABLE coverage
        var binding_table = theme.get_script().get_script_constant_map().get("BINDING_TABLE", {})
        assert(binding_table.size() >= 37, "BINDING_TABLE has fewer than 37 keys: %d" % binding_table.size())
        var sampled_types := ["Button", "Tree", "LineEdit", "PopupMenu", "Window", "HScrollBar"]
        for t in sampled_types:
            assert(theme.has_stylebox("normal", t) or theme.has_stylebox("panel", t) or theme.has_stylebox("scroll", t) or theme.has_stylebox("embedded_border", t), "%s has no stylebox after regenerate" % t)

        # 3. Verify TYPE_VARIATIONS registration
        var type_variations = theme.get_script().get_script_constant_map().get("TYPE_VARIATIONS", {})
        assert(type_variations.size() == 13, "TYPE_VARIATIONS not 13: %d" % type_variations.size())
        for variation in type_variations.keys():
            var base_type: String = type_variations[variation]
            assert(theme.get_type_variation_base(variation) == base_type,
                "%s should derive from %s" % [variation, base_type])

        # 4. Verify explicit fonts on header variations (PITFALLS 1.2)
        for v in ["HeaderLarge", "HeaderMedium", "HeaderSmall", "Caption", "InfoText"]:
            assert(theme.has_font("font", v), "%s missing explicit font (PITFALLS 1.2)" % v)

        # 5. Spot-check 3 derived values
        var btn_normal: StyleBox = theme.get_stylebox("normal", "Button")
        assert(btn_normal != null, "Button.normal stylebox null")
        var label_color: Color = theme.get_color("font_color", "Label")
        assert(label_color != Color(0, 0, 0, 1), "Label.font_color is engine default — derivation didn't run")

        # 6. Toggle test: raised true → false → check shadow_size flips
        theme.raised = true
        var btn_raised: StyleBoxFlat = theme.get_stylebox("normal", "Button") as StyleBoxFlat
        if btn_raised:
            assert(btn_raised.shadow_size > 0, "raised=true should set shadow_size > 0")
        theme.raised = false
        var btn_flat: StyleBoxFlat = theme.get_stylebox("normal", "Button") as StyleBoxFlat
        if btn_flat:
            assert(btn_flat.shadow_size == -1, "raised=false should set shadow_size = -1")

        # 7. is_light flip test
        theme.base_color = Color("#F0F0F0")
        assert(theme.is_light == true, "is_light should flip to true on #F0F0F0")
        var light_label_color: Color = theme.get_color("font_color", "Label")
        assert(light_label_color.r < 0.5, "is_light=true should produce dark text (#1B2230 family)")
        # Revert
        theme.base_color = Color("#151A2E")

        print("✓ Phase 4 verification: pulse_neocade_theme.tres passes all gates.")
    ```

    Run the helper via Godot Editor's "File → Run" or via `godot --headless --script addons/neocade_theme/_phase4_verify.gd` (if the project's Godot binary supports headless EditorScript execution). If neither works in the autonomous executor's environment, the executor manually loads the `.tres` in Godot Editor, opens it in the Theme Editor, and visually confirms (a) Button has all states, (b) Tree has its slots, (c) PopupMenu has its slots, (d) variations show in the variation list with explicit fonts.

    NOTE: this helper file lives at `addons/neocade_theme/_phase4_verify.gd` (NOT distributed) and is deleted in Phase 11 before publication. Per RESEARCH.md §13.7. Mark it with a comment header stating "PHASE 4 VERIFICATION ONLY — DELETE BEFORE v1 PUBLICATION."

    The verify-script run should produce stdout `✓ Phase 4 verification: pulse_neocade_theme.tres passes all gates.` on success. Capture this output for inclusion in the Plan 04 SUMMARY.
  </action>
  <acceptance_criteria>
    - File `addons/neocade_theme/_phase4_verify.gd` exists.
    - File contains `@tool` and `extends EditorScript`.
    - File contains `func _run() -> void:`.
    - File contains a header comment with `DELETE BEFORE v1 PUBLICATION` (or equivalent — anchors the Phase 11 cleanup).
    - File contains assertions for all 9 `@export` properties (`base_color`, `accent_color`, `raised`, `platform`, `corner_radius`, `spacing`, `raised_strength`, `focus_thickness`, `outline_width`).
    - File contains assertion `is_light == false` for Pulse default.
    - File contains assertion `BINDING_TABLE.size() >= 37`.
    - File contains assertion `TYPE_VARIATIONS.size() == 13`.
    - File contains the toggle test (`theme.raised = true` then `false`, asserting `shadow_size` flips).
    - File contains the `is_light` flip test (`theme.base_color = Color("#F0F0F0")`, asserting `is_light == true`).
    - When run via Godot Editor's File → Run (or headless EditorScript invocation), the script completes without assertion failures (the executor captures the run output and includes it in the commit message + Plan 04 SUMMARY; if Godot Editor is unavailable in the autonomous executor's environment, the executor MUST run it manually outside autonomy and provide the output, OR document the manual visual verification as evidence).
  </acceptance_criteria>
  <verify>
    <automated>
      powershell -NoProfile -Command "$p='addons/neocade_theme/_phase4_verify.gd'; if (-not (Test-Path $p)) { throw '_phase4_verify.gd missing' }; $g=Get-Content -Raw $p; foreach($n in '@tool','extends EditorScript','func _run() -> void:','DELETE BEFORE','base_color == Color(\"#151A2E\")','accent_color == Color(\"#8BFF6A\")','raised == false','corner_radius == 0','spacing == 18','raised_strength == 3','focus_thickness == 2','outline_width == 1','is_light == false','BINDING_TABLE','TYPE_VARIATIONS','theme.raised = true','theme.raised = false','theme.base_color = Color(\"#F0F0F0\")','theme.is_light == true') { if ($g -notmatch [regex]::Escape($n)) { throw \"missing: $n\" } }"
    </automated>
  </verify>
  <done>The verification helper proves end-to-end that Pulse loads, regenerates, populates 37 Controls + 13 variations, and the `raised` and `is_light` toggles work. Manual or scripted run output is captured for Plan 04 SUMMARY.</done>
</task>

<task type="auto">
  <name>Task 3: Atomic commit — Pulse .tres + verification helper</name>
  <read_first>
    - addons/neocade_theme/pulse_neocade_theme.tres
    - addons/neocade_theme/_phase4_verify.gd
  </read_first>
  <files>(commit only)</files>
  <action>
    Stage the 2 new files and commit:

    ```
    feat(04-06): ship Pulse .tres + verification helper

    Plan 04-06 wave-3 (depends on Plans 04-04, 04-05):
    - addons/neocade_theme/pulse_neocade_theme.tres — recommended starter direction
      with the 9 @export values per DESIGN_TOKENS §5.1: base=#151A2E,
      accent=#8BFF6A, raised=false, platform=AUTO, corner_radius=0, spacing=18,
      raised_strength=3, focus_thickness=2, outline_width=1
    - addons/neocade_theme/_phase4_verify.gd — EditorScript helper that loads
      Pulse, asserts BINDING_TABLE coverage (>=37 types), TYPE_VARIATIONS
      registration (==13), explicit header fonts, raised toggle behavior, is_light
      flip on #F0F0F0; DELETED IN PHASE 11.

    Verification: Pulse loads, _regenerate_theme() populates all 37 Controls + 13
    variations, raised toggle flips shadow_size correctly, is_light flip produces
    dark text on light surfaces. SC#7 strict-reading first verification.

    Refs: FOUND-03 (Pulse subset)
    Plan: 04-06
    ```

    `git add` both files; commit. Do NOT push.
  </action>
  <acceptance_criteria>
    - `git log -1 --pretty=%s` returns a subject line starting with `feat(04-06):`.
    - `git log -1 --name-status` shows `A addons/neocade_theme/pulse_neocade_theme.tres` AND `A addons/neocade_theme/_phase4_verify.gd`.
    - `git status --porcelain` is empty for both files.
  </acceptance_criteria>
  <verify>
    <automated>
      powershell -NoProfile -Command "$msg = git log -1 --pretty=%s; if ($msg -notmatch '^feat\\(04-06\\):') { throw \"commit subject wrong: $msg\" }; $ns = git log -1 --name-status; foreach($f in 'addons/neocade_theme/pulse_neocade_theme\\.tres','addons/neocade_theme/_phase4_verify\\.gd') { if ($ns -notmatch \"A\\s+$f\") { throw \"commit missing $f\" } }"
    </automated>
  </verify>
  <done>Pulse + the verification helper land as a single atomic commit. Pulse is feature-complete and the engine's first end-to-end smoke test passes.</done>
</task>

</tasks>
