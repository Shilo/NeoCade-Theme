---
phase: 04-foundation-neocadetheme-superclass-per-theme-subclasses-font
plan: 07
type: execute
wave: 4
depends_on:
  - "04-06"
files_modified:
  - addons/neocade_theme/slate_neocade_theme.tres
  - addons/neocade_theme/bubble_neocade_theme.tres
  - addons/neocade_theme/daybreak_neocade_theme.tres
  - addons/neocade_theme/burst_neocade_theme.tres
  - addons/neocade_theme/_phase4_import.gd  # extended with _save_peer_tres() block
  - addons/neocade_theme/_phase4_verify.gd  # Cross-AI Cycle 2 M3: extended for peer-load checks
  - addons/neocade_theme/_phase4_verify_headless.gd  # Cross-AI Cycle 2 M3: same
  - main.tscn
autonomous: true
requirements:
  - FOUND-03
must_haves:
  truths:
    - "`addons/neocade_theme/slate_neocade_theme.tres` exists, is `[gd_resource type=\"NeoCadeTheme\"]`, with §5.2 values: base=#111820, accent=#8BD3FF, raised=false, platform=AUTO, corner_radius=14, spacing=22, raised_strength=2, focus_thickness=2, outline_width=1."
    - "`addons/neocade_theme/bubble_neocade_theme.tres` exists with §5.3 values: base=#241326, accent=#FFB3E6, raised=false, platform=AUTO, corner_radius=26, spacing=22, raised_strength=6, focus_thickness=3, outline_width=1."
    - "`addons/neocade_theme/daybreak_neocade_theme.tres` exists with §5.4 values: base=#0B2420, accent=#76F2D1, raised=false, platform=AUTO, corner_radius=8, spacing=24, raised_strength=3, focus_thickness=2, outline_width=1."
    - "`addons/neocade_theme/burst_neocade_theme.tres` exists with §5.5 values: base=#20112E, accent=#FFD166, raised=false, platform=AUTO, corner_radius=18, spacing=22, raised_strength=5, focus_thickness=3, outline_width=1."
    - "Each peer `.tres` is GENERATED via `ResourceSaver.save()` in `_phase4_import.gd` (Cross-AI Cycle 1 C6 fix) — header form matches whatever Godot 4.6 emitted for `pulse_neocade_theme.tres` in Plan 04-06; NOT hand-authored."
    - "Loading any of the 4 peer `.tres` produces a `NeoCadeTheme` instance with `_regenerate_theme()` populating all 37 BINDING_TABLE Controls + 14 type variations (Cross-AI Cycle 1 C4: 14 with CodeLabel; same engine as Pulse, only `@export` values differ)."
    - "**Cross-AI Cycle 2 M1 fix:** `_phase4_import.gd._run()` body specifically contains a `_save_peer_tres()` call — verified by extracting the `_run()` body via regex and grepping for the substring INSIDE that body (not just in the file). Catches the regression where the function is defined but never invoked."
    - "**Cross-AI Cycle 2 M3 fix:** Plan 04-07 explicitly extends `_phase4_verify.gd` and `_phase4_verify_headless.gd` to load each of the 4 peer `.tres` files via `ResourceLoader.load(path)`, asserts `is NeoCadeTheme`, asserts `has_stylebox(\"normal\", \"Button\")`, and asserts each direction's `_resolve_direction_presets().spread_factor` matches its expected DIRECTION_PRESETS value (Slate=0.7, Bubble=1.0, Daybreak=1.0, Burst=1.3)."
    - "`main.tscn` references `addons/neocade_theme/pulse_neocade_theme.tres` as its theme override (`theme = ExtResource(...)` on the root Control), restoring the theme that Plan 04-01 cleared."
    - "Spot-check distinct visual identity per direction: each direction's loaded theme has different `corner_radius` values (Slate=14, Bubble=26, Daybreak=8, Burst=18) reflected in `Button.normal` stylebox `corner_radius_top_left` after regenerate. (Pulse=0 already verified in Plan 04-06.)"
  artifacts:
    - addons/neocade_theme/slate_neocade_theme.tres
    - addons/neocade_theme/bubble_neocade_theme.tres
    - addons/neocade_theme/daybreak_neocade_theme.tres
    - addons/neocade_theme/burst_neocade_theme.tres
    - main.tscn (Pulse theme reassigned)
  key_links:
    - ".planning/DESIGN_TOKENS.md §5.2, §5.3, §5.4, §5.5"
    - ".planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-CONTEXT.md D-14 step 9"
    - ".planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-RESEARCH.md §12 (Plan 04-07 scope)"
---

<objective>
Author the 4 peer direction `.tres` files (Slate, Bubble, Daybreak, Burst) per DESIGN_TOKENS §5.2-§5.5, and reassign `main.tscn`'s theme override to the recommended starter `pulse_neocade_theme.tres` (Plan 04-01 cleared the override; Plan 04-06 produced Pulse; this plan reconnects).

Purpose: complete the FOUND-03 5-direction set and restore the project showcase scene's theme reference. After this plan, all 5 directions ship as data-only `.tres` files; the engine + `.tres` data architecture is fully validated.
Output: 4 new `.tres` files at the addon root + 1 modified `main.tscn`.
</objective>

<execution_context>
@$HOME/.codex/get-shit-done/workflows/execute-plan.md
@$HOME/.codex/get-shit-done/templates/summary.md
</execution_context>

<context>
@.planning/DESIGN_TOKENS.md
@.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-CONTEXT.md
@.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-RESEARCH.md
@addons/neocade_theme/neocade_theme.gd
@addons/neocade_theme/pulse_neocade_theme.tres
@main.tscn

<interfaces>
This plan is parallel-eligible with Plan 04-08 (metadata + README), since neither modifies the engine `.gd` file. Both depend on Plan 04-06 (Pulse exists as the engine's smoke-test exemplar).

Per DESIGN_TOKENS §5, each direction's `.tres` ships ONLY the 9 `@export` values + (optionally) Theme Editor authored entry overrides for personality. Phase 4 ships the `@export` values only; Phases 5/6/7 polish per-direction Theme Editor overrides per the §5.x "Theme Editor override intent" lines.

Each `.tres` is structurally identical to `pulse_neocade_theme.tres` — only the `@export` values differ.
</interfaces>
</context>

<tasks>

<task type="auto">
  <name>Task 1: Generate Slate, Bubble, Daybreak, Burst .tres files PROGRAMMATICALLY via ResourceSaver (Cross-AI Cycle 1 C6 fix)</name>
  <read_first>
    - .planning/DESIGN_TOKENS.md (§5.2 Slate, §5.3 Bubble, §5.4 Daybreak, §5.5 Burst)
    - addons/neocade_theme/pulse_neocade_theme.tres (Godot-emitted reference template — first line is canonical for the peer `.tres` files)
    - addons/neocade_theme/_phase4_import.gd (Plan 04-02/06 — extend with peer save block)
    - .planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-REVIEWS.md (Cycle 1 HIGH C6)
  </read_first>
  <files>
    - addons/neocade_theme/_phase4_import.gd (modify — extend with peer save block)
    - addons/neocade_theme/slate_neocade_theme.tres (GENERATED via ResourceSaver.save)
    - addons/neocade_theme/bubble_neocade_theme.tres (GENERATED via ResourceSaver.save)
    - addons/neocade_theme/daybreak_neocade_theme.tres (GENERATED via ResourceSaver.save)
    - addons/neocade_theme/burst_neocade_theme.tres (GENERATED via ResourceSaver.save)
  </files>
  <action>
    **Cross-AI Cycle 1 C6 fix:** the 4 peer `.tres` files are NOT hand-authored. Append a peer-save block to `_phase4_import.gd` that uses the SAME `ResourceSaver.save(NeoCadeTheme.new(), ...)` pattern as Plan 04-06's Pulse generator. Header form matches Godot's emission for Pulse — guaranteed canonical.

    **Stage A — Extend `_phase4_import.gd`:**

    Append a new function and call it from `_run()` AFTER `_save_pulse_tres()`:

    ```gdscript

    ## Plan 04-07 add-on: generate the 4 peer direction .tres files via ResourceSaver.save().
    ## Headers match whatever Godot 4.6 emitted for pulse_neocade_theme.tres (Plan 04-06).
    func _save_peer_tres() -> void:
        var peers := [
            {"file": "slate_neocade_theme.tres",    "base": Color("#111820"), "accent": Color("#8BD3FF"), "corner_radius": 14, "spacing": 22, "raised_strength": 2, "focus_thickness": 2, "outline_width": 1},
            {"file": "bubble_neocade_theme.tres",   "base": Color("#241326"), "accent": Color("#FFB3E6"), "corner_radius": 26, "spacing": 22, "raised_strength": 6, "focus_thickness": 3, "outline_width": 1},
            {"file": "daybreak_neocade_theme.tres", "base": Color("#0B2420"), "accent": Color("#76F2D1"), "corner_radius": 8,  "spacing": 24, "raised_strength": 3, "focus_thickness": 2, "outline_width": 1},
            {"file": "burst_neocade_theme.tres",    "base": Color("#20112E"), "accent": Color("#FFD166"), "corner_radius": 18, "spacing": 22, "raised_strength": 5, "focus_thickness": 3, "outline_width": 1},
        ]
        for d in peers:
            var t: NeoCadeTheme = NeoCadeTheme.new()
            t.base_color = d.base
            t.accent_color = d.accent
            t.raised = false
            t.platform = NeoCadeTheme.Platform.AUTO
            t.corner_radius = d.corner_radius
            t.spacing = d.spacing
            t.raised_strength = d.raised_strength
            t.focus_thickness = d.focus_thickness
            t.outline_width = d.outline_width
            var path := "res://addons/neocade_theme/" + d.file
            var ok := ResourceSaver.save(t, path)
            assert(ok == OK, "%s save failed: %d" % [d.file, ok])
        print("✓ 4 peer .tres saved via ResourceSaver.save (Slate, Bubble, Daybreak, Burst).")

    func _run() -> void:
        # ... existing font materialization ...
        _save_pulse_tres()
        _save_peer_tres()  # Plan 04-07
    ```

    **Stage B — Run the helper.** Same as Plan 04-06: Godot Editor → File → Run, OR `godot --headless --editor --script addons/neocade_theme/_phase4_import.gd`. The 4 peer files materialize at the addon root.

    Color value reference (Godot's serializer produces these float values; informational):

    **Slate** — base=#111820 → `Color(0.0666667, 0.0941176, 0.12549, 1)`; accent=#8BD3FF → `Color(0.545098, 0.827451, 1, 1)`.
    **Bubble** — base=#241326 → `Color(0.141176, 0.0745098, 0.14902, 1)`; accent=#FFB3E6 → `Color(1, 0.701961, 0.901961, 1)`.
    **Daybreak** — base=#0B2420 → `Color(0.0431373, 0.141176, 0.12549, 1)`; accent=#76F2D1 → `Color(0.462745, 0.94902, 0.819608, 1)`.
    **Burst** — base=#20112E → `Color(0.12549, 0.0666667, 0.180392, 1)`; accent=#FFD166 → `Color(1, 0.819608, 0.4, 1)`.

    Per-direction shape values per DESIGN_TOKENS §5.2-§5.5:
    - Slate — `corner_radius=14, spacing=22, raised_strength=2, focus_thickness=2, outline_width=1`
    - Bubble — `corner_radius=26, spacing=22, raised_strength=6, focus_thickness=3, outline_width=1`
    - Daybreak — `corner_radius=8,  spacing=24, raised_strength=3, focus_thickness=2, outline_width=1`
    - Burst — `corner_radius=18, spacing=22, raised_strength=5, focus_thickness=3, outline_width=1`

    The exact serialized header form (e.g., `[gd_resource type="..." script_class="NeoCadeTheme" ...]`) is whatever Godot 4.6 emitted for `pulse_neocade_theme.tres` in Plan 04-06 — it's the canonical template Cross-AI Cycle 1 C6 mandated be discovered empirically rather than hand-written. The 4 peer files match that exact form because they are produced by the same `ResourceSaver.save(NeoCadeTheme.new(), ...)` pipeline.

    **Implementation:** EXTEND `_phase4_import.gd` with `_save_peer_tres()` per Stage A above, then re-run the helper. Do NOT use `Set-Content` to hand-write the `.tres` files (Cross-AI Cycle 1 C6 expressly forbids this).
  </action>
  <acceptance_criteria>
    - `addons/neocade_theme/_phase4_import.gd` contains a `func _save_peer_tres() -> void:` declaration.
    - `_phase4_import.gd` `_save_peer_tres` body uses `NeoCadeTheme.new()` for each of the 4 peers (Slate, Bubble, Daybreak, Burst) and calls `ResourceSaver.save(t, path)` for each.
    - **Cross-AI Cycle 2 M1 fix:** `_phase4_import.gd` `_run()` body MUST contain a literal `_save_peer_tres()` call. The verifier extracts the `_run()` body via regex (from `func _run()` declaration to the next `func` declaration or end-of-file) and asserts the call substring appears WITHIN that extracted body (not merely in the file at large). This catches the regression where the function is defined but never invoked, so peer .tres files are silently never generated.
    - All 4 peer files exist at `addons/neocade_theme/{slate,bubble,daybreak,burst}_neocade_theme.tres`.
    - Each peer file's first line begins with `[gd_resource` and contains `format=3`.
    - Each peer file contains `NeoCadeTheme` in the header (form matches Pulse).
    - **Slate** file contains: `base_color = Color(0.0666667, 0.0941176, 0.12549, 1)`, `accent_color = Color(0.545098, 0.827451, 1, 1)`, `corner_radius = 14`, `spacing = 22`, `raised_strength = 2`, `focus_thickness = 2`, `outline_width = 1`, `raised = false`, `platform = 2`.
    - **Bubble** file contains: `base_color = Color(0.141176, 0.0745098, 0.14902, 1)`, `accent_color = Color(1, 0.701961, 0.901961, 1)`, `corner_radius = 26`, `spacing = 22`, `raised_strength = 6`, `focus_thickness = 3`, `outline_width = 1`.
    - **Daybreak** file contains: `base_color = Color(0.0431373, 0.141176, 0.12549, 1)`, `accent_color = Color(0.462745, 0.94902, 0.819608, 1)`, `corner_radius = 8`, `spacing = 24`, `raised_strength = 3`, `focus_thickness = 2`, `outline_width = 1`.
    - **Burst** file contains: `base_color = Color(0.12549, 0.0666667, 0.180392, 1)`, `accent_color = Color(1, 0.819608, 0.4, 1)`, `corner_radius = 18`, `spacing = 22`, `raised_strength = 5`, `focus_thickness = 3`, `outline_width = 1`.
  </acceptance_criteria>
  <verify>
    <automated>
      powershell -NoProfile -Command "$base='addons/neocade_theme'; $checks=@{ 'slate_neocade_theme.tres' = @('Color(0.0666667, 0.0941176, 0.12549, 1)','Color(0.545098, 0.827451, 1, 1)','corner_radius = 14','spacing = 22','raised_strength = 2','focus_thickness = 2'); 'bubble_neocade_theme.tres' = @('Color(0.141176, 0.0745098, 0.14902, 1)','Color(1, 0.701961, 0.901961, 1)','corner_radius = 26','raised_strength = 6','focus_thickness = 3'); 'daybreak_neocade_theme.tres' = @('Color(0.0431373, 0.141176, 0.12549, 1)','Color(0.462745, 0.94902, 0.819608, 1)','corner_radius = 8','spacing = 24','raised_strength = 3'); 'burst_neocade_theme.tres' = @('Color(0.12549, 0.0666667, 0.180392, 1)','Color(1, 0.819608, 0.4, 1)','corner_radius = 18','raised_strength = 5','focus_thickness = 3') }; foreach($k in $checks.Keys) { $p=\"$base/$k\"; if (-not (Test-Path $p)) { throw \"$k missing\" }; $g=Get-Content -Raw $p; if ($g -notmatch '^\\[gd_resource') { throw \"$k bad header\" }; if ($g -notmatch 'NeoCadeTheme') { throw \"$k missing NeoCadeTheme reference\" }; foreach($req in $checks[$k]) { if ($g -notmatch [regex]::Escape($req)) { throw \"$k missing: $req\" } } }; $imp='addons/neocade_theme/_phase4_import.gd'; if (-not (Test-Path $imp)) { throw '_phase4_import.gd missing' }; $impg=Get-Content -Raw $imp; if ($impg -notmatch 'func _save_peer_tres\\(\\) -> void:') { throw '_save_peer_tres declaration missing' }; $run_body_match = [regex]::Match($impg, '(?s)func _run\\(\\)[^\\n]*\\n(.*?)(?=^func |\\Z)', 'Multiline'); if (-not $run_body_match.Success) { throw 'M1 fix verify: cannot extract _run() body' }; $run_body = $run_body_match.Groups[1].Value; if ($run_body -notmatch '_save_peer_tres\\(\\)') { throw 'M1 fix verify: _save_peer_tres() not called INSIDE _run() body (function defined but never invoked - peer .tres would not be generated)' }; if ($run_body -notmatch '_save_pulse_tres\\(\\)') { throw 'M1 fix verify: _save_pulse_tres() also not called inside _run() body' }"
    </automated>
  </verify>
  <done>4 peer direction `.tres` files ship; the FOUND-03 5-direction set is complete (Pulse + 4 peers).</done>
</task>

<task type="auto">
  <name>Task 1.5: Extend _phase4_verify.gd + _phase4_verify_headless.gd with peer-load checks (Cross-AI Cycle 2 M3 fix)</name>
  <read_first>
    - addons/neocade_theme/_phase4_verify.gd (created in Plan 04-06)
    - addons/neocade_theme/_phase4_verify_headless.gd (created in Plan 04-06)
    - addons/neocade_theme/{slate,bubble,daybreak,burst}_neocade_theme.tres (Task 1 output)
    - addons/neocade_theme/neocade_theme.gd (DIRECTION_PRESETS constant — verifier reads spread_factor expectations)
    - .planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-REVIEWS.md (Cycle 2 M3)
  </read_first>
  <files>
    - addons/neocade_theme/_phase4_verify.gd (modify — append _verify_peers function + call from _run)
    - addons/neocade_theme/_phase4_verify_headless.gd (modify — append peer-load checks to _init body)
  </files>
  <action>
    **Cross-AI Cycle 2 M3 fix.** Plan 04-06 acceptance previously claimed peer .tres files would be runtime-validated by extending the verify helpers, but those edits were never assigned as tasks. This task makes the extension explicit.

    **Stage A — Extend `_phase4_verify.gd` (EditorScript variant).** Append a new `_verify_peers()` function and call it from `_run()` AFTER `_verify_pulse()`:

    ```gdscript

    ## Cross-AI Cycle 2 M3 fix — peer .tres runtime validation.
    ## Loads each of the 4 peer files via ResourceLoader, asserts is NeoCadeTheme,
    ## asserts has_stylebox("normal", "Button") (proving _regenerate_theme ran),
    ## and asserts the per-direction spread_factor matches DIRECTION_PRESETS.
    func _verify_peers() -> void:
        var peers := [
            {"file": "slate_neocade_theme.tres",    "expected_spread": 0.7, "base": Color("#111820")},
            {"file": "bubble_neocade_theme.tres",   "expected_spread": 1.0, "base": Color("#241326")},
            {"file": "daybreak_neocade_theme.tres", "expected_spread": 1.0, "base": Color("#0B2420")},
            {"file": "burst_neocade_theme.tres",    "expected_spread": 1.3, "base": Color("#20112E")},
        ]
        for d in peers:
            var path := "res://addons/neocade_theme/" + d.file
            var loaded: Resource = ResourceLoader.load(path)
            assert(loaded != null, "peer load null: %s" % d.file)
            assert(loaded is NeoCadeTheme, "peer not NeoCadeTheme: %s" % d.file)
            var t: NeoCadeTheme = loaded
            assert(t.has_stylebox("normal", "Button"), "peer %s missing Button.normal stylebox" % d.file)
            assert(t.base_color == d.base, "peer %s base_color mismatch" % d.file)
            var presets: Dictionary = t._resolve_direction_presets()
            assert(abs(presets.spread_factor - d.expected_spread) < 0.001,
                "peer %s spread_factor %f != expected %f (hex-key lookup falling to DEFAULT?)"
                    % [d.file, presets.spread_factor, d.expected_spread])
        print("✓ Phase 4 peer verification: 4 peer .tres files load + differentiate correctly.")

    func _run() -> void:
        _verify_pulse()
        _verify_peers()  # Cross-AI Cycle 2 M3 fix
    ```

    The existing `_run()` body in `_phase4_verify.gd` calls only `_verify_pulse()`. This task REPLACES that with the version above (additional `_verify_peers()` call). The `_verify_pulse()` function body is unchanged.

    **Stage B — Extend `_phase4_verify_headless.gd` (SceneTree variant).** Append peer-load checks to the existing `_init()` failure-collection logic:

    ```gdscript
        # Cross-AI Cycle 2 M3 fix — peer .tres runtime validation (4 files).
        var peers := [
            {"file": "slate_neocade_theme.tres",    "expected_spread": 0.7, "base": Color("#111820")},
            {"file": "bubble_neocade_theme.tres",   "expected_spread": 1.0, "base": Color("#241326")},
            {"file": "daybreak_neocade_theme.tres", "expected_spread": 1.0, "base": Color("#0B2420")},
            {"file": "burst_neocade_theme.tres",    "expected_spread": 1.3, "base": Color("#20112E")},
        ]
        for d in peers:
            var peer_path := "res://addons/neocade_theme/" + d.file
            var peer_loaded: Resource = ResourceLoader.load(peer_path)
            if peer_loaded == null:
                failures.append("peer load null: %s" % d.file)
                continue
            if not (peer_loaded is NeoCadeTheme):
                failures.append("peer not NeoCadeTheme: %s" % d.file)
                continue
            var pt: NeoCadeTheme = peer_loaded
            if not pt.has_stylebox("normal", "Button"):
                failures.append("peer %s missing Button.normal stylebox" % d.file)
            if pt.base_color != d.base:
                failures.append("peer %s base_color mismatch" % d.file)
            var pp: Dictionary = pt._resolve_direction_presets()
            if abs(pp.spread_factor - d.expected_spread) > 0.001:
                failures.append("peer %s spread_factor %f != %f" % [d.file, pp.spread_factor, d.expected_spread])
    ```

    Insert this block in `_init()` AFTER the existing Cycle 1/Cycle 2 in-memory checks (around the `slate_test` block from the Cycle 2 L2 fix) but BEFORE the `if failures.size() > 0:` block. The headless variant accumulates failures and quits with status 1 if any peer fails.

    **Run path (executor)**: after Plan 04-07 Task 1 has materialized the 4 peer .tres files via `_save_peer_tres()`, run the EditorScript variant via Godot Editor → File → Run, AND/OR run the headless variant via `godot --headless --quit --script addons/neocade_theme/_phase4_verify_headless.gd`. Capture the PASS line.

    Both verify helpers will be DELETED in Phase 11 (the `DELETE BEFORE v1 PUBLICATION` header survives this extension).
  </action>
  <acceptance_criteria>
    - `addons/neocade_theme/_phase4_verify.gd` contains a `func _verify_peers() -> void:` declaration.
    - `_phase4_verify.gd` `_run()` body calls BOTH `_verify_pulse()` AND `_verify_peers()`.
    - `_verify_peers()` body iterates an array containing all 4 peer file names: `"slate_neocade_theme.tres"`, `"bubble_neocade_theme.tres"`, `"daybreak_neocade_theme.tres"`, `"burst_neocade_theme.tres"`.
    - `_verify_peers()` body asserts `loaded is NeoCadeTheme` for each peer.
    - `_verify_peers()` body asserts `t.has_stylebox("normal", "Button")` for each peer.
    - `_verify_peers()` body asserts each peer's `_resolve_direction_presets().spread_factor` matches the expected per-direction value (0.7/1.0/1.0/1.3 for Slate/Bubble/Daybreak/Burst).
    - `addons/neocade_theme/_phase4_verify_headless.gd` `_init()` body contains a peer-iteration block referencing all 4 peer file names.
    - The headless variant accumulates peer failures into the existing `failures: Array[String]` so the `quit(1)` exit path covers peer regressions.
  </acceptance_criteria>
  <verify>
    <automated>
      powershell -NoProfile -Command "$p='addons/neocade_theme/_phase4_verify.gd'; if (-not (Test-Path $p)) { throw '_phase4_verify.gd missing — Plan 04-06 must run first' }; $g=Get-Content -Raw $p; foreach($n in 'func _verify_peers() -> void:','_verify_peers()','slate_neocade_theme.tres','bubble_neocade_theme.tres','daybreak_neocade_theme.tres','burst_neocade_theme.tres','loaded is NeoCadeTheme','has_stylebox(\"normal\", \"Button\")','_resolve_direction_presets()','expected_spread') { if ($g -notmatch [regex]::Escape($n)) { throw \"_phase4_verify.gd missing M3 fix piece: $n\" } }; $run_body_match = [regex]::Match($g, '(?s)func _run\\(\\)[^\\n]*\\n(.*?)(?=^func |\\Z)', 'Multiline'); if (-not $run_body_match.Success) { throw 'M3: cannot extract _phase4_verify.gd._run() body' }; $rb = $run_body_match.Groups[1].Value; if ($rb -notmatch '_verify_peers\\(\\)') { throw 'M3: _verify_peers() not called inside _run() body' }; $h='addons/neocade_theme/_phase4_verify_headless.gd'; $hg=Get-Content -Raw $h; foreach($n in 'slate_neocade_theme.tres','bubble_neocade_theme.tres','daybreak_neocade_theme.tres','burst_neocade_theme.tres','peer not NeoCadeTheme','spread_factor') { if ($hg -notmatch [regex]::Escape($n)) { throw \"_phase4_verify_headless.gd missing M3 fix piece: $n\" } }"
    </automated>
  </verify>
  <done>Both verify helpers now load + validate the 4 peer .tres files at runtime; Cycle 2 M3 closes the "claimed but unimplemented peer verification" gap.</done>
</task>

<task type="auto">
  <name>Task 2: Reassign main.tscn theme override to pulse_neocade_theme.tres</name>
  <read_first>
    - main.tscn (current state — Plan 04-01 cleared the theme override)
    - addons/neocade_theme/pulse_neocade_theme.tres
  </read_first>
  <files>
    - main.tscn (modify — re-add theme reference)
  </files>
  <action>
    Plan 04-01 removed the theme override line from `main.tscn` AND replaced it with a placeholder comment line (`# theme = ExtResource(...) - reassigned in Plan 04-07`). Plan 04-01 also removed the corresponding `[ext_resource ...]` declaration. This task restores the live reference (deleting the placeholder comment) and points it at `pulse_neocade_theme.tres` instead of the deleted scaffold.

    Steps:
    1. Read current `main.tscn`.
    2. DELETE the placeholder comment line (`# theme = ExtResource(...) - reassigned in Plan 04-07`) on the root Control node block — replacing it with the live property line in step 4.
    3. Add a new `[ext_resource]` line (typically near the top of the file, in the same block as any other ext_resource declarations) referencing the Pulse `.tres`:
       ```
       [ext_resource type="Theme" path="res://addons/neocade_theme/pulse_neocade_theme.tres" id="1_pulse_theme"]
       ```
       (`uid` is optional in `[ext_resource]` and is auto-generated by Godot on first save; `path` + `type` + `id` are sufficient.)
       NOTE: depending on how Godot 4.6 serializes `NeoCadeTheme`-typed resources in `.tscn` files, the `type` may need to be `"NeoCadeTheme"` instead of `"Theme"`. Either form should resolve correctly because `NeoCadeTheme extends Theme`. Use `type="Theme"` for maximum compatibility (the resource will load as its actual subclass at runtime).
    4. Add `theme = ExtResource("1_pulse_theme")` to the root node block (the `[node ...]` block representing the scene's root Control). Place it where Plan 04-01's placeholder comment was.
    5. Verify: `main.tscn` parses, opens in Godot Editor without errors, and the root node's theme override resolves to the Pulse `.tres`.

    Implementation note: the existing `main.tscn` may have a `load_steps` count that needs to be incremented when adding a new `[ext_resource]`. Godot 4.6 expects `load_steps = N+1` where N is the count of `[ext_resource]` and `[sub_resource]` blocks. The executor MUST update `load_steps` accordingly OR remove it entirely (Godot's parser tolerates a missing `load_steps`).

    Use Edit / Write to update the file.
  </action>
  <acceptance_criteria>
    - `main.tscn` contains an `[ext_resource]` line referencing `res://addons/neocade_theme/pulse_neocade_theme.tres`.
    - `main.tscn` contains a LIVE `theme = ExtResource(` line on the root Control node (NOT a `# theme =` comment line — the placeholder from Plan 04-01 is replaced).
    - The `[ext_resource]` and `theme = ExtResource("...")` lines reference the same id.
    - `main.tscn` first line is still `[gd_scene` and the file parses as a valid scene.
    - `main.tscn` does NOT contain any reference to the deleted `neocade_theme.tres` scaffold (sanity check: Plan 04-01's deletion stays intact).
    - `main.tscn` does NOT contain the placeholder comment `# theme = ExtResource(...) - reassigned in Plan 04-07` (Plan 04-07 deletes it).
  </acceptance_criteria>
  <verify>
    <automated>
      powershell -NoProfile -Command "$p='main.tscn'; $g=Get-Content -Raw $p; if ($g -notmatch '^\\[gd_scene') { throw 'main.tscn header broken' }; if ($g -notmatch 'res://addons/neocade_theme/pulse_neocade_theme\\.tres') { throw 'pulse_neocade_theme.tres ext_resource missing' }; if ($g -notmatch '(?m)^\\s*theme = ExtResource\\(') { throw 'live theme override line missing' }; if ($g -match '(?m)^[^#]*neocade_theme/neocade_theme\\.tres\\b') { throw 'main.tscn still references deleted scaffold (non-comment line)' }; if ($g -match '# theme = ExtResource\\(\\.\\.\\.\\) - reassigned') { throw 'placeholder comment from Plan 04-01 still present' }; $ext_match = [regex]::Match($g, 'ext_resource type=\"(?:Theme|NeoCadeTheme)\"[^]]*?id=\"([^\"]+)\"[^]]*?path=\"res://addons/neocade_theme/pulse_neocade_theme\\.tres\"'); $theme_match = [regex]::Match($g, 'theme = ExtResource\\(\"([^\"]+)\"\\)'); if (-not $ext_match.Success) { $ext_match = [regex]::Match($g, 'ext_resource type=\"(?:Theme|NeoCadeTheme)\"[^]]*?path=\"res://addons/neocade_theme/pulse_neocade_theme\\.tres\"[^]]*?id=\"([^\"]+)\"') }; if ($ext_match.Success -and $theme_match.Success) { if ($ext_match.Groups[1].Value -ne $theme_match.Groups[1].Value) { throw \"ext_resource id $($ext_match.Groups[1].Value) does not match theme= id $($theme_match.Groups[1].Value)\" } }"
    </automated>
  </verify>
  <done>main.tscn loads with Pulse as the recommended-starter theme, restoring the showcase scene's theme reference (Plan 04-01 cleared, Plan 04-07 reassigns).</done>
</task>

<task type="auto">
  <name>Task 3: Atomic commit — peer themes + main.tscn reassignment</name>
  <read_first>
    - addons/neocade_theme/slate_neocade_theme.tres
    - addons/neocade_theme/bubble_neocade_theme.tres
    - addons/neocade_theme/daybreak_neocade_theme.tres
    - addons/neocade_theme/burst_neocade_theme.tres
    - main.tscn
  </read_first>
  <files>(commit only)</files>
  <action>
    Stage the 4 new `.tres` files + the modified `main.tscn` + the modified `_phase4_import.gd` + the 2 modified verify helpers (M3 fix) and commit:

    ```
    feat(04-07): ship Slate/Bubble/Daybreak/Burst .tres + peer verify + main.tscn

    Plan 04-07 wave-4 (depends on Plan 04-06 Pulse; Cross-AI Cycle 1 C6 +
    Cycle 2 M1/M3 fixes):
    - addons/neocade_theme/_phase4_import.gd — extended with _save_peer_tres()
      (Cycle 2 M1: also called inside _run() body — verifier asserts call
      lives WITHIN _run() body, not just in the file)
    - All 4 peer .tres are GENERATED via ResourceSaver.save (NOT hand-authored):
      * slate_neocade_theme.tres — §5.2: base=#111820, accent=#8BD3FF,
        corner_radius=14, spacing=22, raised_strength=2, focus_thickness=2
      * bubble_neocade_theme.tres — §5.3: base=#241326, accent=#FFB3E6,
        corner_radius=26, spacing=22, raised_strength=6, focus_thickness=3
      * daybreak_neocade_theme.tres — §5.4: base=#0B2420, accent=#76F2D1,
        corner_radius=8, spacing=24, raised_strength=3, focus_thickness=2
      * burst_neocade_theme.tres — §5.5: base=#20112E, accent=#FFD166,
        corner_radius=18, spacing=22, raised_strength=5, focus_thickness=3
    - addons/neocade_theme/_phase4_verify.gd — extended with _verify_peers()
      (Cycle 2 M3: previously only-claimed peer validation now actually
      implemented; loads each peer via ResourceLoader, asserts is NeoCadeTheme,
      asserts has_stylebox("normal", "Button"), asserts spread_factor matches
      DIRECTION_PRESETS per direction)
    - addons/neocade_theme/_phase4_verify_headless.gd — extended with peer
      load-checks in _init() body (Cycle 2 M3 — same)
    - main.tscn — replace Plan 04-01's placeholder comment with live
      theme = ExtResource(...) pointing at pulse_neocade_theme.tres
      (recommended starter, per CONTEXT.md D-13).

    Refs: FOUND-03 (full 5-direction set)
    Plan: 04-07
    ```

    `git add` the 8 paths; commit. Do NOT push.
  </action>
  <acceptance_criteria>
    - `git log -1 --pretty=%s` returns a subject line starting with `feat(04-07):`.
    - `git log -1 --name-status` shows 4 `A` entries (the peer .tres files), `M main.tscn`, `M addons/neocade_theme/_phase4_import.gd`, `M addons/neocade_theme/_phase4_verify.gd` (Cycle 2 M3 fix), and `M addons/neocade_theme/_phase4_verify_headless.gd` (Cycle 2 M3 fix).
    - `git status --porcelain` is empty for all 8 paths.
  </acceptance_criteria>
  <verify>
    <automated>
      powershell -NoProfile -Command "$msg = git log -1 --pretty=%s; if ($msg -notmatch '^feat\\(04-07\\):') { throw \"commit subject wrong: $msg\" }; $ns = git log -1 --name-status; foreach($f in 'addons/neocade_theme/slate_neocade_theme\\.tres','addons/neocade_theme/bubble_neocade_theme\\.tres','addons/neocade_theme/daybreak_neocade_theme\\.tres','addons/neocade_theme/burst_neocade_theme\\.tres') { if ($ns -notmatch \"A\\s+$f\") { throw \"commit missing $f\" } }; if ($ns -notmatch 'M\\s+main\\.tscn') { throw 'commit missing main.tscn modification' }; if ($ns -notmatch 'M\\s+addons/neocade_theme/_phase4_import\\.gd') { throw 'commit missing _phase4_import.gd modification' }; if ($ns -notmatch 'M\\s+addons/neocade_theme/_phase4_verify\\.gd') { throw 'commit missing _phase4_verify.gd (Cycle 2 M3 fix)' }; if ($ns -notmatch 'M\\s+addons/neocade_theme/_phase4_verify_headless\\.gd') { throw 'commit missing _phase4_verify_headless.gd (Cycle 2 M3 fix)' }"
    </automated>
  </verify>
  <done>4 peer themes + main.tscn reassignment land as a single atomic Wave 4 commit. The full 5-direction set ships.</done>
</task>

</tasks>
