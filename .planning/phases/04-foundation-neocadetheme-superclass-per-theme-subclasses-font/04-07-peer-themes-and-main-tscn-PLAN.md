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
    - "Loading any of the 4 peer `.tres` produces a `NeoCadeTheme` instance with `_regenerate_theme()` populating all 37 BINDING_TABLE Controls + 13 type variations (same engine as Pulse; only `@export` values differ)."
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
    - `_phase4_import.gd` `_run()` calls `_save_peer_tres()` after `_save_pulse_tres()`.
    - All 4 peer files exist at `addons/neocade_theme/{slate,bubble,daybreak,burst}_neocade_theme.tres`.
    - Each peer file's first line begins with `[gd_resource` and contains `format=3`.
    - Each peer file contains `NeoCadeTheme` in the header (form matches Pulse).
    - Each peer file PASSES `ResourceLoader.load(path) is NeoCadeTheme` at runtime (verified by extending `_phase4_verify.gd` / `_phase4_verify_headless.gd` to spot-check at least 2 of the 4 peers; the verify runs as part of Plan 04-06's verification — Cross-AI Cycle 1 LOW assertion fix).
    - **Slate** file contains: `base_color = Color(0.0666667, 0.0941176, 0.12549, 1)`, `accent_color = Color(0.545098, 0.827451, 1, 1)`, `corner_radius = 14`, `spacing = 22`, `raised_strength = 2`, `focus_thickness = 2`, `outline_width = 1`, `raised = false`, `platform = 2`.
    - **Bubble** file contains: `base_color = Color(0.141176, 0.0745098, 0.14902, 1)`, `accent_color = Color(1, 0.701961, 0.901961, 1)`, `corner_radius = 26`, `spacing = 22`, `raised_strength = 6`, `focus_thickness = 3`, `outline_width = 1`.
    - **Daybreak** file contains: `base_color = Color(0.0431373, 0.141176, 0.12549, 1)`, `accent_color = Color(0.462745, 0.94902, 0.819608, 1)`, `corner_radius = 8`, `spacing = 24`, `raised_strength = 3`, `focus_thickness = 2`, `outline_width = 1`.
    - **Burst** file contains: `base_color = Color(0.12549, 0.0666667, 0.180392, 1)`, `accent_color = Color(1, 0.819608, 0.4, 1)`, `corner_radius = 18`, `spacing = 22`, `raised_strength = 5`, `focus_thickness = 3`, `outline_width = 1`.
  </acceptance_criteria>
  <verify>
    <automated>
      powershell -NoProfile -Command "$base='addons/neocade_theme'; $checks=@{ 'slate_neocade_theme.tres' = @('Color(0.0666667, 0.0941176, 0.12549, 1)','Color(0.545098, 0.827451, 1, 1)','corner_radius = 14','spacing = 22','raised_strength = 2','focus_thickness = 2'); 'bubble_neocade_theme.tres' = @('Color(0.141176, 0.0745098, 0.14902, 1)','Color(1, 0.701961, 0.901961, 1)','corner_radius = 26','raised_strength = 6','focus_thickness = 3'); 'daybreak_neocade_theme.tres' = @('Color(0.0431373, 0.141176, 0.12549, 1)','Color(0.462745, 0.94902, 0.819608, 1)','corner_radius = 8','spacing = 24','raised_strength = 3'); 'burst_neocade_theme.tres' = @('Color(0.12549, 0.0666667, 0.180392, 1)','Color(1, 0.819608, 0.4, 1)','corner_radius = 18','raised_strength = 5','focus_thickness = 3') }; foreach($k in $checks.Keys) { $p=\"$base/$k\"; if (-not (Test-Path $p)) { throw \"$k missing\" }; $g=Get-Content -Raw $p; if ($g -notmatch '^\\[gd_resource') { throw \"$k bad header\" }; if ($g -notmatch 'NeoCadeTheme') { throw \"$k missing NeoCadeTheme reference\" }; foreach($req in $checks[$k]) { if ($g -notmatch [regex]::Escape($req)) { throw \"$k missing: $req\" } } }"
    </automated>
  </verify>
  <done>4 peer direction `.tres` files ship; the FOUND-03 5-direction set is complete (Pulse + 4 peers).</done>
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
    Stage the 4 new `.tres` files + the modified `main.tscn` + the modified `_phase4_import.gd` and commit:

    ```
    feat(04-07): ship Slate/Bubble/Daybreak/Burst .tres (Godot-serialized) + main.tscn

    Plan 04-07 wave-4 (depends on Plan 04-06 Pulse; Cross-AI Cycle 1 C6 fix):
    - addons/neocade_theme/_phase4_import.gd — extended with _save_peer_tres()
    - All 4 peer .tres are GENERATED via ResourceSaver.save (NOT hand-authored):
      * slate_neocade_theme.tres — §5.2: base=#111820, accent=#8BD3FF,
        corner_radius=14, spacing=22, raised_strength=2, focus_thickness=2
      * bubble_neocade_theme.tres — §5.3: base=#241326, accent=#FFB3E6,
        corner_radius=26, spacing=22, raised_strength=6, focus_thickness=3
      * daybreak_neocade_theme.tres — §5.4: base=#0B2420, accent=#76F2D1,
        corner_radius=8, spacing=24, raised_strength=3, focus_thickness=2
      * burst_neocade_theme.tres — §5.5: base=#20112E, accent=#FFD166,
        corner_radius=18, spacing=22, raised_strength=5, focus_thickness=3
    - main.tscn — replace Plan 04-01's placeholder comment with live
      theme = ExtResource(...) pointing at pulse_neocade_theme.tres
      (recommended starter, per CONTEXT.md D-13).

    Refs: FOUND-03 (full 5-direction set)
    Plan: 04-07
    ```

    `git add` the 6 paths; commit. Do NOT push.
  </action>
  <acceptance_criteria>
    - `git log -1 --pretty=%s` returns a subject line starting with `feat(04-07):`.
    - `git log -1 --name-status` shows 4 `A` entries (the peer .tres files), `M main.tscn`, and `M addons/neocade_theme/_phase4_import.gd`.
    - `git status --porcelain` is empty for all 6 paths.
  </acceptance_criteria>
  <verify>
    <automated>
      powershell -NoProfile -Command "$msg = git log -1 --pretty=%s; if ($msg -notmatch '^feat\\(04-07\\):') { throw \"commit subject wrong: $msg\" }; $ns = git log -1 --name-status; foreach($f in 'addons/neocade_theme/slate_neocade_theme\\.tres','addons/neocade_theme/bubble_neocade_theme\\.tres','addons/neocade_theme/daybreak_neocade_theme\\.tres','addons/neocade_theme/burst_neocade_theme\\.tres') { if ($ns -notmatch \"A\\s+$f\") { throw \"commit missing $f\" } }; if ($ns -notmatch 'M\\s+main\\.tscn') { throw 'commit missing main.tscn modification' }; if ($ns -notmatch 'M\\s+addons/neocade_theme/_phase4_import\\.gd') { throw 'commit missing _phase4_import.gd modification' }"
    </automated>
  </verify>
  <done>4 peer themes + main.tscn reassignment land as a single atomic Wave 4 commit. The full 5-direction set ships.</done>
</task>

</tasks>
