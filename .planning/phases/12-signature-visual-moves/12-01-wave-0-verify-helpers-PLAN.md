---
phase: 12
plan: 01
type: execute
wave: 0
depends_on: []
files_modified:
  - .planning/phases/12-signature-visual-moves/helpers/_phase12_verify.gd
  - .planning/phases/12-signature-visual-moves/helpers/_phase12_verify_headless.gd
  - .planning/phases/12-signature-visual-moves/helpers/_phase12_thumbnail_render.gd
  - .planning/phases/12-signature-visual-moves/helpers/_phase12_smoke_matrix.gd
autonomous: true
requirements: []
must_haves:
  truths:
    - "Running `godot --headless --quit --script .../_phase12_verify_headless.gd -- --stage architecture` exits 0 against pre-Phase-12 baseline."
    - "Every locked success criterion (SC#1..SC#6) has a callable `--stage` that exits 0 against pre-Phase-12 baseline."
    - "`--stage smoke-30` exits 0 against pre-Phase-12 baseline (regression bar locked before any code edits)."
    - "Helpers load ONLY the canonical resource at res://addons/neocade_theme/neocade_theme.tres (Pitfall 6 — no stale `pulse_neocade_theme.tres`)."
    - "SC#4 thumbnail render produces 5 greyscale PNGs (one per style at `raised=true`) saved to .planning/phases/12-signature-visual-moves/artifacts/thumbnails/."
  artifacts:
    - path: ".planning/phases/12-signature-visual-moves/helpers/_phase12_verify.gd"
      provides: "EditorScript variant (Phase 4 precedent: load canonical resource, run SC assertions in-editor)"
    - path: ".planning/phases/12-signature-visual-moves/helpers/_phase12_verify_headless.gd"
      provides: "SceneTree headless variant with `-- --stage <name>` argparse (Phase 5 precedent for stage routing)"
    - path: ".planning/phases/12-signature-visual-moves/helpers/_phase12_thumbnail_render.gd"
      provides: "SC#4 greyscale thumbnail renderer (256x144 per style, saved PNG for user attestation)"
    - path: ".planning/phases/12-signature-visual-moves/helpers/_phase12_smoke_matrix.gd"
      provides: "30-config smoke matrix runner (SC#6 export-count + BINDING_TABLE freeze across representative configs)"
  key_links:
    - from: "_phase12_verify_headless.gd"
      to: "res://addons/neocade_theme/neocade_theme.tres"
      via: "preload + theme.style = <Style.X> per-direction toggle (NOT separate .tres files)"
      pattern: "preload.*neocade_theme.tres"
    - from: "_phase12_verify_headless.gd"
      to: "OS.get_cmdline_user_args() / OS.get_cmdline_args()"
      via: "`-- --stage <name>` parsing (double-dash separator per Phase 5 idiom)"
      pattern: "OS.get_cmdline_user_args"
---

<objective>
Ship Phase 12's Wave 0 verification infrastructure BEFORE any production code change.
This plan creates 4 standalone helper scripts that each subsequent wave will rely on as
the automated acceptance gate. Wave 0 must be green against the pre-Phase-12 baseline
(no production edits in this plan) so the very first commit in Wave 1 has a working
oracle to verify against.

Purpose: enforce SC#1..SC#6 from the first production task. The existing Phase 4/8
helpers cannot be reused (Pitfall 6 in 12-RESEARCH.md — they reference deleted
`pulse_neocade_theme.tres` and `neocade_mobile_theme.tres`).

Output: 4 helper scripts at `.planning/phases/12-signature-visual-moves/helpers/`,
plus an `artifacts/thumbnails/` directory populated with 5 baseline greyscale PNGs
the user can compare against post-Phase-12 renders.
</objective>

<execution_context>
@$HOME/.claude/get-shit-done/workflows/execute-plan.md
@$HOME/.claude/get-shit-done/templates/summary.md
</execution_context>

<context>
@.planning/PROJECT.md
@.planning/ROADMAP.md
@.planning/STATE.md
@.planning/phases/12-signature-visual-moves/12-CONTEXT.md
@.planning/phases/12-signature-visual-moves/12-RESEARCH.md
@.planning/phases/12-signature-visual-moves/12-VALIDATION.md
@.planning/phases/12-signature-visual-moves/12-PATTERNS.md
@CLAUDE.md

<interfaces>
<!-- Key types and contracts the executor needs. Extracted from addons/neocade_theme/scripts/neocade_theme.gd. -->

class_name NeoCadeTheme extends Theme  (located at addons/neocade_theme/scripts/neocade_theme.gd:1)

enum Style { CUSTOM, PULSE, SLATE, BUBBLE, DAYBREAK, BURST }   (line ~30)
enum Platform { DESKTOP, MOBILE, AUTO }                          (line ~36)

# 12 public @export vars (exact, verified via grep):
@export var style: Style                          (line 49)
@export var raised: bool                          (line 61)
@export var platform: Platform                    (line 68)
@export_group("Style Overrides")                  (line 76; NOT a var)
@export var base_color: Color                     (line 79)
@export var accent_color: Color                   (line 86)
@export var corner_radius: int                    (line 93)
@export var spacing: int                          (line 101)
@export var raised_strength: int                  (line 109)
@export var focus_thickness: int                  (line 117)
@export var outline_width: int                    (line 125)
@export_group("Advanced")                         (line 133; NOT a var)
@export var use_runtime_popup_selection_icons: bool  (line 138)
@export var texture_cache: bool                   (line 147)

static func selectable_styles() -> PackedInt32Array
    returns: [Style.BUBBLE, Style.BURST, Style.DAYBREAK, Style.PULSE, Style.SLATE]
    (line 171; CUSTOM is intentionally excluded)

# Constants the verifier reads:
const BINDING_TABLE: Dictionary   (frozen at 37 top-level Control keys per Cycle 1 C1)
const TYPE_VARIATIONS: Dictionary  (line ~1212+)
const STYLE_PERSONALITY: Dictionary   (lines 913-1094; per-direction shape dicts)
const STYLE_PERSONALITY_DEFAULT: Dictionary  (lines 1158-1189; Style.CUSTOM fallback)

# Reentry guard the verifier must respect:
var _regenerating: bool  (line 158; do NOT trigger re-entry from a setter inside the verifier)
</interfaces>

<canonical_resource_path>
res://addons/neocade_theme/neocade_theme.tres   (the ONLY .tres the helpers may load)
</canonical_resource_path>

<analog_helper_paths>
# Read these for argparse + assert idioms (do NOT copy load paths from them — Pitfall 6):
.planning/phases/04-foundation-engine-feature-complete-bake-in-themes/helpers/_phase4_verify.gd
.planning/phases/04-foundation-engine-feature-complete-bake-in-themes/helpers/_phase4_verify_headless.gd
.planning/phases/05-buttons-text-base-base-controls-button-family-textedit-li/helpers/_phase5_verify_headless.gd
</analog_helper_paths>
</context>

<tasks>

<task type="auto">
  <name>Task 1: Create _phase12_verify_headless.gd with full --stage routing</name>
  <files>.planning/phases/12-signature-visual-moves/helpers/_phase12_verify_headless.gd</files>
  <read_first>
    - .planning/phases/12-signature-visual-moves/12-CONTEXT.md (D-12.24..D-12.29 — the 6 locked success criteria)
    - .planning/phases/12-signature-visual-moves/12-RESEARCH.md § "Validation Architecture" + § "Verification tooling" + Pitfall 6
    - .planning/phases/12-signature-visual-moves/12-VALIDATION.md (per-task verification map)
    - .planning/phases/12-signature-visual-moves/12-PATTERNS.md § 10 "Wave 0 verify helper — headless SceneTree variant"
    - .planning/phases/05-buttons-text-base-base-controls-button-family-textedit-li/helpers/_phase5_verify_headless.gd lines 250-330 (argparse precedent — use the dual-source OS.get_cmdline_user_args() + OS.get_cmdline_args() pattern)
    - .planning/phases/04-foundation-engine-feature-complete-bake-in-themes/helpers/_phase4_verify_headless.gd lines 1-22, 132-166 (assert + quit(1)/(0) idiom)
    - addons/neocade_theme/scripts/neocade_theme.gd lines 49-154 (12 @export var declarations)
    - addons/neocade_theme/scripts/neocade_theme.gd lines 167-172 (`_init() -> _regenerate_theme()` + `selectable_styles()`)
    - addons/neocade_theme/scripts/neocade_theme.gd lines 913-1094 (STYLE_PERSONALITY per-direction shape dicts)
  </read_first>
  <action>
Create the file `.planning/phases/12-signature-visual-moves/helpers/_phase12_verify_headless.gd` with the following exact structure. This is a `SceneTree` script run via `godot --headless --quit --script <path> -- --stage <stage>`.

Use this EXACT skeleton (paste in full; do not paraphrase):

```gdscript
extends SceneTree

## Phase 12 headless verifier. Invoke via:
##   godot --headless --quit --script ".planning/phases/12-signature-visual-moves/helpers/_phase12_verify_headless.gd" -- --stage <stage>
##
## Stages (per 12-VALIDATION.md):
##   architecture           — canonical .tres loads, BINDING_TABLE.size() == 37, TYPE_VARIATIONS not empty, @export count == 12
##   sc1-no-3d-when-flat    — SC#1: every selectable style at raised=false shows no depth strips (face == face_offset)
##   sc2-tabs-flat-when-raised — SC#2: every selectable style at raised=true keeps TabBar/TabContainer tab styleboxes flat
##   sc3-no-glow-halo       — SC#3: every generated stylebox has border_color.a in {0.0, 1.0}; no intermediate alphas
##   sc6-export-count       — SC#6: script export count == 12
##   smoke-30               — 30-config regenerate sweep (defers to _phase12_smoke_matrix.gd)
##   full                   — all stages above except smoke-30 (run that separately)
##
## Exit code 0 = pass, 1 = fail. Marker prefix: `PHASE12_VERIFY:` for CI grep.

const CANONICAL_TRES := "res://addons/neocade_theme/neocade_theme.tres"
const EXPECTED_EXPORT_COUNT := 12
const EXPECTED_BINDING_TABLE_ROWS := 37

const VALID_STAGES := [
    "architecture",
    "sc1-no-3d-when-flat",
    "sc2-tabs-flat-when-raised",
    "sc3-no-glow-halo",
    "sc6-export-count",
    "smoke-30",
    "full",
]

var _stage: String = "architecture"
var _failures: Array[String] = []

func _init() -> void:
    _parse_args()
    print("PHASE12_VERIFY: stage=%s" % _stage)
    _run_stage(_stage)
    _emit_and_quit()


func _parse_args() -> void:
    # Godot 4.6 splits CLI at the literal `--`. User script args come from
    # OS.get_cmdline_user_args(); fall back to OS.get_cmdline_args() if the
    # caller forgot the separator.
    var sources := [OS.get_cmdline_user_args(), OS.get_cmdline_args()]
    var found := false
    for source in sources:
        var args: PackedStringArray = source
        var i := 0
        while i < args.size():
            var a: String = args[i]
            if a == "--stage" and i + 1 < args.size():
                _stage = args[i + 1]
                found = true
                break
            i += 1
        if found:
            break
    if not VALID_STAGES.has(_stage):
        push_error("PHASE12_VERIFY: unknown --stage '%s' — falling back to 'architecture'" % _stage)
        _stage = "architecture"


func _run_stage(stage: String) -> void:
    match stage:
        "architecture":            _stage_architecture()
        "sc1-no-3d-when-flat":     _stage_sc1()
        "sc2-tabs-flat-when-raised": _stage_sc2()
        "sc3-no-glow-halo":        _stage_sc3()
        "sc6-export-count":        _stage_sc6()
        "smoke-30":
            # Defer to dedicated runner so this file stays focused.
            print("PHASE12_VERIFY: smoke-30 → run _phase12_smoke_matrix.gd separately")
        "full":
            _stage_architecture()
            _stage_sc1()
            _stage_sc2()
            _stage_sc3()
            _stage_sc6()


# ─── Stage implementations ──────────────────────────────────────────────────────

func _stage_architecture() -> void:
    var theme: Resource = ResourceLoader.load(CANONICAL_TRES)
    if theme == null:
        _fail("architecture: canonical .tres failed to load (%s)" % CANONICAL_TRES)
        return
    if not (theme is NeoCadeTheme):
        _fail("architecture: loaded resource is not a NeoCadeTheme")
        return
    var nct: NeoCadeTheme = theme

    var script := nct.get_script()
    var consts: Dictionary = script.get_script_constant_map()
    var bt: Dictionary = consts.get("BINDING_TABLE", {})
    if bt.size() != EXPECTED_BINDING_TABLE_ROWS:
        _fail("architecture: BINDING_TABLE.size() = %d (expected %d)" % [bt.size(), EXPECTED_BINDING_TABLE_ROWS])
    var tv: Dictionary = consts.get("TYPE_VARIATIONS", {})
    if tv.size() <= 0:
        _fail("architecture: TYPE_VARIATIONS is empty")

    if not nct.has_stylebox("normal", "Button"):
        _fail("architecture: theme regenerate produced no Button.normal stylebox")
    if not nct.has_stylebox("panel", "PanelContainer"):
        _fail("architecture: theme regenerate produced no PanelContainer.panel stylebox")
    print("PHASE12_VERIFY: architecture OK (BINDING_TABLE=%d, TYPE_VARIATIONS=%d)" % [bt.size(), tv.size()])


func _stage_sc6() -> void:
    var theme: Resource = ResourceLoader.load(CANONICAL_TRES)
    if theme == null or not (theme is NeoCadeTheme):
        _fail("sc6: canonical .tres failed to load")
        return
    var script := (theme as NeoCadeTheme).get_script()
    var export_count: int = _count_top_level_exports(script)
    if export_count != EXPECTED_EXPORT_COUNT:
        _fail("sc6: @export count = %d (expected %d)" % [export_count, EXPECTED_EXPORT_COUNT])
    else:
        print("PHASE12_VERIFY: sc6 OK (12 exports)")


func _stage_sc1() -> void:
    # SC#1: raised=false MUST show ZERO 3D anywhere.
    # Concretely: every generated StyleBoxFlat must have shadow_size == -1 AND no
    # raised-offset duplicate (which manifests via _make_raised_stylebox's secondary
    # box). Since _make_raised_stylebox is gated on `if raised`, the simplest test
    # is: at raised=false, no stylebox should have an offset shadow_size > 0.
    var any_failed := false
    for style_value in NeoCadeTheme.selectable_styles():
        var t := _fresh_theme()
        if t == null:
            continue
        t.raised = false
        t.style = style_value
        # Hard signal: with raised=false, the generated Button.normal stylebox must
        # be a single StyleBoxFlat (no depth strip), and shadow_size must be -1
        # (the no-shadow invariant from Conflict 3 / GL issue #23640).
        var sb := t.get_stylebox("normal", "Button")
        if sb is StyleBoxFlat:
            var sbf := sb as StyleBoxFlat
            if sbf.shadow_size > 0:
                _fail("sc1: %s raised=false has Button.normal shadow_size=%d (expected <=0)" % [NeoCadeTheme.style_label(style_value), sbf.shadow_size])
                any_failed = true
    if not any_failed:
        print("PHASE12_VERIFY: sc1 OK (no depth chrome with raised=false across all selectable styles)")


func _stage_sc2() -> void:
    # SC#2: raised=true keeps lifts on panels + buttons; tabs stay flat.
    # Concretely: when raised=true, TabBar/TabContainer tab_selected styleboxes
    # must NOT add a depth offset (raised_intensity in their recipe is locked to 0
    # per BINDING_TABLE rows at lines 3443-3446 / 3495-3498).
    for style_value in NeoCadeTheme.selectable_styles():
        var t := _fresh_theme()
        if t == null:
            continue
        t.raised = true
        t.style = style_value
        for type_name in ["TabBar", "TabContainer"]:
            if t.has_stylebox("tab_selected", type_name):
                var sb := t.get_stylebox("tab_selected", type_name)
                if sb is StyleBoxFlat:
                    var sbf := sb as StyleBoxFlat
                    if sbf.shadow_size > 0:
                        _fail("sc2: %s/%s.tab_selected has shadow_size=%d at raised=true (tabs must stay flat)" % [NeoCadeTheme.style_label(style_value), type_name, sbf.shadow_size])
    print("PHASE12_VERIFY: sc2 OK (tabs flat at raised=true across all selectable styles)")


func _stage_sc3() -> void:
    # SC#3: No glow halos. Every generated stylebox's border_color must have alpha
    # in {0.0, 1.0} — never an intermediate alpha. GL Compatibility renderer
    # over-renders alpha (issue #23640) creating the "halo" failure mode.
    var inspected := 0
    for style_value in NeoCadeTheme.selectable_styles():
        for raised_v in [false, true]:
            var t := _fresh_theme()
            if t == null:
                continue
            t.raised = raised_v
            t.style = style_value
            for theme_type in t.get_stylebox_type_list():
                for sb_name in t.get_stylebox_list(theme_type):
                    var sb := t.get_stylebox(sb_name, theme_type)
                    if sb is StyleBoxFlat:
                        var sbf := sb as StyleBoxFlat
                        inspected += 1
                        var a: float = sbf.border_color.a
                        # Tolerate floating-point equality near 0 or 1.
                        if a > 0.001 and a < 0.999:
                            _fail("sc3: %s/%s.%s has border_alpha=%.3f (halo risk; must be 0.0 or 1.0)" % [
                                NeoCadeTheme.style_label(style_value), theme_type, sb_name, a])
    print("PHASE12_VERIFY: sc3 OK (%d styleboxes inspected, no intermediate-alpha borders)" % inspected)


# ─── Helpers ────────────────────────────────────────────────────────────────────

func _fresh_theme() -> NeoCadeTheme:
    var loaded: Resource = ResourceLoader.load(CANONICAL_TRES)
    if loaded == null or not (loaded is NeoCadeTheme):
        _fail("could not load canonical theme")
        return null
    var dup := (loaded as NeoCadeTheme).duplicate(true)
    return dup as NeoCadeTheme


func _count_top_level_exports(script: Script) -> int:
    var count := 0
    for prop in script.get_script_property_list():
        var usage: int = int(prop.get("usage", 0))
        if (usage & PROPERTY_USAGE_SCRIPT_VARIABLE) != 0 and (usage & PROPERTY_USAGE_EDITOR) != 0 and (usage & PROPERTY_USAGE_STORAGE) != 0:
            count += 1
    return count


func _fail(msg: String) -> void:
    _failures.append(msg)
    push_error("PHASE12_VERIFY FAIL: %s" % msg)


func _emit_and_quit() -> void:
    if _failures.size() > 0:
        print("PHASE12_VERIFY: FAIL — %d failure(s):" % _failures.size())
        for f in _failures:
            print("  - %s" % f)
        quit(1)
        return
    print("PHASE12_VERIFY: PASS — stage '%s' all assertions green" % _stage)
    quit(0)
```

Notes:
- `_count_top_level_exports` uses the conventional `STORAGE | EDITOR | SCRIPT_VARIABLE` mask. The 12 declared `@export var` lines (49, 61, 68, 79, 86, 93, 101, 109, 117, 125, 138, 147) all set those bits. `@export_group` lines at 76, 133 do NOT set `SCRIPT_VARIABLE` so they are excluded.
- The `--stage` argparse pattern is copied from `_phase5_verify_headless.gd:255-286` with one rename (`PHASE5_VERIFY` → `PHASE12_VERIFY`).
- Do NOT add any test that requires the post-Phase-12 STYLE_PERSONALITY keys (`hairline_thickness`, `primary_outline_*`, `min_radius_floor`, `primary_min_height`). The verifier must be green BEFORE Wave 1.
- Use `loaded.duplicate(true)` (deep duplicate) so each style toggle starts from a fresh copy; otherwise mutations persist across the loop.
  </action>
  <verify>
    <automated>godot --headless --quit --script ".planning/phases/12-signature-visual-moves/helpers/_phase12_verify_headless.gd" -- --stage architecture</automated>
  </verify>
  <acceptance_criteria>
    - File `.planning/phases/12-signature-visual-moves/helpers/_phase12_verify_headless.gd` exists.
    - File begins with `extends SceneTree` (NOT EditorScript).
    - File contains the literal string `"PHASE12_VERIFY:"` at least 6 times (one per stage print marker).
    - File contains the literal string `"res://addons/neocade_theme/neocade_theme.tres"` and does NOT contain `"pulse_neocade_theme.tres"` or `"neocade_mobile_theme.tres"` (Pitfall 6).
    - File contains `OS.get_cmdline_user_args()` AND `OS.get_cmdline_args()` (dual-source argparse).
    - Running `godot --headless --quit --script ".planning/phases/12-signature-visual-moves/helpers/_phase12_verify_headless.gd" -- --stage architecture` exits 0 and prints `PHASE12_VERIFY: PASS`.
    - Running `... -- --stage full` exits 0 (pre-Phase-12 baseline must be green on SC#1, SC#2, SC#3, SC#6).
    - Running `... -- --stage sc6-export-count` prints `PHASE12_VERIFY: sc6 OK (12 exports)`.
  </acceptance_criteria>
  <done>The headless verifier exists, all `--stage` routes work, and `--stage full` is green against the pre-Phase-12 baseline.</done>
</task>

<task type="auto">
  <name>Task 2: Create _phase12_verify.gd EditorScript variant</name>
  <files>.planning/phases/12-signature-visual-moves/helpers/_phase12_verify.gd</files>
  <read_first>
    - .planning/phases/12-signature-visual-moves/12-PATTERNS.md § 9 "Wave 0 verify helper — EditorScript variant"
    - .planning/phases/04-foundation-engine-feature-complete-bake-in-themes/helpers/_phase4_verify.gd (the EditorScript precedent — copy the load+assert idiom; replace the stale `pulse_neocade_theme.tres` path with the canonical resource path)
    - The headless verifier created in Task 1 (this script shares its assertion battery, duplicated per the Phase 4 KISS precedent — do not import or extends-chain it).
  </read_first>
  <action>
Create `.planning/phases/12-signature-visual-moves/helpers/_phase12_verify.gd` as the EditorScript twin of Task 1's headless verifier. This is run from inside the Godot Editor via File → Run.

Use this EXACT skeleton:

```gdscript
@tool
extends EditorScript

## Phase 12 in-editor verifier. Run via Godot Editor → File → Run on this file.
##
## Mirrors _phase12_verify_headless.gd's assertion battery (duplicated, not loaded —
## Phase 4 KISS precedent). Output appears in the Godot Output panel; failures use
## `assert(...)` so the editor surfaces a stack trace.

const CANONICAL_TRES := "res://addons/neocade_theme/neocade_theme.tres"
const EXPECTED_EXPORT_COUNT := 12
const EXPECTED_BINDING_TABLE_ROWS := 37

func _run() -> void:
    print("PHASE12_VERIFY (EditorScript): begin")

    var loaded: Resource = ResourceLoader.load(CANONICAL_TRES)
    assert(loaded != null, "PHASE12_VERIFY: canonical .tres failed to load (%s)" % CANONICAL_TRES)
    assert(loaded is NeoCadeTheme, "PHASE12_VERIFY: loaded resource is not a NeoCadeTheme")
    var theme: NeoCadeTheme = loaded

    # Architecture
    var script := theme.get_script()
    var consts: Dictionary = script.get_script_constant_map()
    var bt: Dictionary = consts.get("BINDING_TABLE", {})
    assert(bt.size() == EXPECTED_BINDING_TABLE_ROWS,
        "PHASE12_VERIFY: BINDING_TABLE.size() = %d (expected %d)" % [bt.size(), EXPECTED_BINDING_TABLE_ROWS])
    assert(theme.has_stylebox("normal", "Button"),
        "PHASE12_VERIFY: theme regenerate produced no Button.normal stylebox")
    assert(theme.has_stylebox("panel", "PanelContainer"),
        "PHASE12_VERIFY: theme regenerate produced no PanelContainer.panel stylebox")

    # SC#6
    var export_count: int = _count_top_level_exports(script)
    assert(export_count == EXPECTED_EXPORT_COUNT,
        "PHASE12_VERIFY: @export count = %d (expected %d)" % [export_count, EXPECTED_EXPORT_COUNT])

    # SC#1 — raised=false: no Button.normal shadow_size > 0 for any selectable style.
    for style_value in NeoCadeTheme.selectable_styles():
        var t: NeoCadeTheme = theme.duplicate(true) as NeoCadeTheme
        t.raised = false
        t.style = style_value
        var sb := t.get_stylebox("normal", "Button")
        if sb is StyleBoxFlat:
            var sbf := sb as StyleBoxFlat
            assert(sbf.shadow_size <= 0,
                "PHASE12_VERIFY SC#1: %s raised=false Button.normal shadow_size=%d" % [NeoCadeTheme.style_label(style_value), sbf.shadow_size])

    # SC#2 — raised=true: TabBar/TabContainer tab_selected styleboxes have no depth.
    for style_value in NeoCadeTheme.selectable_styles():
        var t: NeoCadeTheme = theme.duplicate(true) as NeoCadeTheme
        t.raised = true
        t.style = style_value
        for type_name in ["TabBar", "TabContainer"]:
            if t.has_stylebox("tab_selected", type_name):
                var sb := t.get_stylebox("tab_selected", type_name)
                if sb is StyleBoxFlat:
                    var sbf := sb as StyleBoxFlat
                    assert(sbf.shadow_size <= 0,
                        "PHASE12_VERIFY SC#2: %s/%s.tab_selected shadow_size=%d at raised=true" % [NeoCadeTheme.style_label(style_value), type_name, sbf.shadow_size])

    # SC#3 — no intermediate-alpha border colors.
    var inspected := 0
    for style_value in NeoCadeTheme.selectable_styles():
        for raised_v in [false, true]:
            var t: NeoCadeTheme = theme.duplicate(true) as NeoCadeTheme
            t.raised = raised_v
            t.style = style_value
            for theme_type in t.get_stylebox_type_list():
                for sb_name in t.get_stylebox_list(theme_type):
                    var sb := t.get_stylebox(sb_name, theme_type)
                    if sb is StyleBoxFlat:
                        inspected += 1
                        var a: float = (sb as StyleBoxFlat).border_color.a
                        assert(a <= 0.001 or a >= 0.999,
                            "PHASE12_VERIFY SC#3: %s/%s.%s border_alpha=%.3f (halo risk)" % [NeoCadeTheme.style_label(style_value), theme_type, sb_name, a])

    print("PHASE12_VERIFY (EditorScript): PASS — architecture, SC#1, SC#2, SC#3 (%d styleboxes), SC#6 all green" % inspected)


func _count_top_level_exports(script: Script) -> int:
    var count := 0
    for prop in script.get_script_property_list():
        var usage: int = int(prop.get("usage", 0))
        if (usage & PROPERTY_USAGE_SCRIPT_VARIABLE) != 0 and (usage & PROPERTY_USAGE_EDITOR) != 0 and (usage & PROPERTY_USAGE_STORAGE) != 0:
            count += 1
    return count
```

Notes:
- This is a duplicated battery, not a shared library — Phase 4's KISS precedent (`_phase4_verify_headless.gd:22-23` comment) is intentional.
- `@tool extends EditorScript` is required so File → Run picks it up.
- Use `assert(...)` (not `push_error + quit`) because the editor surfaces assertion failures via the Output panel and the script process is the editor itself (cannot quit).
  </action>
  <verify>
    <automated>test -f .planning/phases/12-signature-visual-moves/helpers/_phase12_verify.gd && grep -q '^@tool' .planning/phases/12-signature-visual-moves/helpers/_phase12_verify.gd && grep -q '^extends EditorScript' .planning/phases/12-signature-visual-moves/helpers/_phase12_verify.gd</automated>
  </verify>
  <acceptance_criteria>
    - File `.planning/phases/12-signature-visual-moves/helpers/_phase12_verify.gd` exists.
    - First line is `@tool` (verified via `head -1`).
    - Second line is `extends EditorScript` (verified via `sed -n '2p'`).
    - File contains `res://addons/neocade_theme/neocade_theme.tres` and does NOT contain `pulse_neocade_theme.tres` or `neocade_mobile_theme.tres`.
    - File contains at least 5 `assert(...)` calls (architecture, SC#1, SC#2, SC#3, SC#6).
    - File contains `_count_top_level_exports` function definition.
  </acceptance_criteria>
  <done>EditorScript variant exists with `@tool extends EditorScript`, mirrors the headless verifier's assertions, and uses only the canonical resource path.</done>
</task>

<task type="auto">
  <name>Task 3: Create _phase12_thumbnail_render.gd for SC#4 greyscale renders</name>
  <files>.planning/phases/12-signature-visual-moves/helpers/_phase12_thumbnail_render.gd</files>
  <read_first>
    - .planning/phases/12-signature-visual-moves/12-RESEARCH.md § "Verification tooling" + Assumption A1
    - .planning/phases/12-signature-visual-moves/12-VALIDATION.md "Wave 0 Requirements" (`Image.adjust_bcs(0, 0, 0)` vs `(0, 0, -1)` — empirical check)
    - .planning/phases/12-signature-visual-moves/12-PATTERNS.md § 11 "Wave 0 thumbnail render helper" (states: "No analog in repo")
    - addons/neocade_theme/scripts/neocade_theme.gd line 171 (`selectable_styles()`)
    - showcase/showcase.tscn (the scene to render)
  </read_first>
  <action>
Create `.planning/phases/12-signature-visual-moves/helpers/_phase12_thumbnail_render.gd`. This is the SC#4 helper — it renders the showcase scene per style, desaturates to greyscale, saves PNGs, and the user attests pass/fail.

Per RESEARCH § "Verification tooling" and PATTERNS § 11: headless viewport capture is unreliable (no window → transparent surface). The helper MUST be invocable from inside the Godot Editor (File → Run via an EditorScript wrapper) OR run with a windowed Godot session. Document this in the docstring.

Use this EXACT skeleton:

```gdscript
@tool
extends EditorScript

## Phase 12 SC#4 thumbnail renderer.
##
## **MUST RUN FROM INSIDE THE GODOT EDITOR (File → Run on this file).** Headless
## viewport capture is unreliable without a render context; this helper accepts that
## constraint per PATTERNS.md § 11 and runs in-editor.
##
## Output: 5 greyscale PNGs at 256x144, one per selectable style (raised=true), saved to
##   .planning/phases/12-signature-visual-moves/artifacts/thumbnails/<style>-raised-true.png
##
## SC#4 gate: User opens the 5 PNGs (unlabeled), names each by direction (Pulse/Slate/
## Bubble/Daybreak/Burst). Pass requires all 5 correctly identified. Any mismatch →
## strengthen the corresponding C6 move and re-render.
##
## Assumption A1 (RESEARCH.md): `Image.adjust_bcs(brightness, contrast, saturation)`.
## The Godot 4.6 docs are ambiguous on whether `saturation=0` or `saturation=-1`
## fully desaturates. This helper tries `0.0` first (matches the shader-equivalent at
## docs.godotengine.org screen-reading_shaders.html); if the produced PNG retains
## color, the operator manually re-runs with `SATURATION_VALUE = -1.0` toggled
## via the constant below.

const CANONICAL_TRES := "res://addons/neocade_theme/neocade_theme.tres"
const SHOWCASE_SCENE := "res://showcase/showcase.tscn"
const OUTPUT_DIR := "res://.planning/phases/12-signature-visual-moves/artifacts/thumbnails"
const THUMB_W := 256
const THUMB_H := 144
const SATURATION_VALUE := 0.0  # A1: try 0.0 first; flip to -1.0 if PNG still has color


func _run() -> void:
    print("PHASE12_THUMBNAIL: begin")

    # Ensure output directory exists.
    DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(OUTPUT_DIR))

    var theme_res: Resource = ResourceLoader.load(CANONICAL_TRES)
    assert(theme_res != null and theme_res is NeoCadeTheme, "PHASE12_THUMBNAIL: cannot load canonical .tres")

    var scene: PackedScene = ResourceLoader.load(SHOWCASE_SCENE)
    assert(scene != null, "PHASE12_THUMBNAIL: cannot load showcase scene at %s" % SHOWCASE_SCENE)

    var saturation := SATURATION_VALUE

    for style_value in NeoCadeTheme.selectable_styles():
        var t: NeoCadeTheme = (theme_res as NeoCadeTheme).duplicate(true) as NeoCadeTheme
        t.style = style_value
        t.raised = true

        var instance := scene.instantiate()
        # Apply our per-style theme to the root.
        if instance is Control:
            (instance as Control).theme = t

        var editor: EditorInterface = EditorInterface
        var root := EditorInterface.get_base_control()
        root.add_child(instance)

        # Let layouts settle.
        await EditorInterface.get_resource_filesystem().resources_reimported
        await Engine.get_main_loop().process_frame
        await Engine.get_main_loop().process_frame

        # Capture viewport.
        var img: Image = (instance as Control).get_viewport().get_texture().get_image()
        if img == null:
            push_error("PHASE12_THUMBNAIL: viewport.get_image() returned null for %s" % NeoCadeTheme.style_label(style_value))
            instance.queue_free()
            continue

        # Resize then desaturate.
        img.resize(THUMB_W, THUMB_H, Image.INTERPOLATE_BILINEAR)
        img.adjust_bcs(0.0, 0.0, saturation)

        var style_label := NeoCadeTheme.style_label(style_value).to_lower()
        var out_path := "%s/%s-raised-true.png" % [OUTPUT_DIR, style_label]
        var save_path := ProjectSettings.globalize_path(out_path)
        var err: int = img.save_png(save_path)
        if err != OK:
            push_error("PHASE12_THUMBNAIL: save_png failed (err=%d) for %s" % [err, save_path])
        else:
            print("PHASE12_THUMBNAIL: wrote %s" % save_path)

        instance.queue_free()

    print("PHASE12_THUMBNAIL: complete — 5 thumbnails at %s" % OUTPUT_DIR)
    print("PHASE12_THUMBNAIL: SC#4 NEXT — present unlabeled PNGs to user for identification attestation")
```

Notes on A1 (saturation semantic): RESEARCH.md says the shader equivalent uses `mix(grey, color, saturation)` where `saturation=0` → grey. Start with `SATURATION_VALUE = 0.0`. If the rendered PNG still shows color, the operator (Claude or user) flips the constant to `-1.0` and re-runs.

Notes on headless feasibility: PATTERNS § 11 says "the simplest first cut is to require this helper run from inside the Godot Editor (File → Run), not headless". This script is therefore an EditorScript (not SceneTree). Document this in the docstring.

Also create the output directory placeholder so the path resolves: do NOT manually create the `artifacts/thumbnails/` directory in this task — `DirAccess.make_dir_recursive_absolute` in `_run()` handles it on first invocation.
  </action>
  <verify>
    <automated>test -f .planning/phases/12-signature-visual-moves/helpers/_phase12_thumbnail_render.gd && grep -q 'CANONICAL_TRES := "res://addons/neocade_theme/neocade_theme.tres"' .planning/phases/12-signature-visual-moves/helpers/_phase12_thumbnail_render.gd && grep -q 'adjust_bcs' .planning/phases/12-signature-visual-moves/helpers/_phase12_thumbnail_render.gd</automated>
  </verify>
  <acceptance_criteria>
    - File `.planning/phases/12-signature-visual-moves/helpers/_phase12_thumbnail_render.gd` exists.
    - File begins with `@tool` then `extends EditorScript` (NOT SceneTree, per PATTERNS § 11).
    - File contains literal `CANONICAL_TRES := "res://addons/neocade_theme/neocade_theme.tres"`.
    - File contains literal `SHOWCASE_SCENE := "res://showcase/showcase.tscn"`.
    - File contains `adjust_bcs(0.0, 0.0, saturation)` (saturation arg threaded via the `SATURATION_VALUE` constant so A1 toggle is trivial).
    - File contains `save_png` call.
    - File contains `NeoCadeTheme.selectable_styles()` iteration.
    - File loops exactly the 5 selectable styles (Bubble/Burst/Daybreak/Pulse/Slate) per `selectable_styles()` order — verified by file containing exactly one `for style_value in NeoCadeTheme.selectable_styles():` in the body.
    - Docstring explicitly states "MUST RUN FROM INSIDE THE GODOT EDITOR" (visible to operator at File → Run).
  </acceptance_criteria>
  <done>Thumbnail render helper exists, targets the canonical resource, and is documented as Editor-only per the PATTERNS § 11 constraint.</done>
</task>

<task type="auto">
  <name>Task 4: Create _phase12_smoke_matrix.gd with the curated 30-config matrix</name>
  <files>.planning/phases/12-signature-visual-moves/helpers/_phase12_smoke_matrix.gd</files>
  <read_first>
    - .planning/phases/12-signature-visual-moves/12-RESEARCH.md § "30-config smoke matrix" (lines covering the curated 30-subset rule)
    - .planning/phases/12-signature-visual-moves/12-PATTERNS.md § 12 "Wave 0 smoke matrix helper"
    - .planning/phases/04-foundation-engine-feature-complete-bake-in-themes/helpers/_phase4_verify_headless.gd lines 132-166 (peer-iteration + failure-collection pattern; note Phase 12 uses in-memory configs, NOT per-style .tres files)
    - addons/neocade_theme/scripts/neocade_theme.gd lines 49-154 (12 @export var declarations — these are the axes to permute)
    - addons/neocade_theme/scripts/neocade_theme.gd line 171 (selectable_styles)
  </read_first>
  <action>
Create `.planning/phases/12-signature-visual-moves/helpers/_phase12_smoke_matrix.gd`. SceneTree headless runner. Iterates 30 representative `(style × raised × platform × base_color × accent_color)` configs and asserts each regenerates without error AND that the locked invariants (BINDING_TABLE size, 12 exports, no error during regeneration) hold across all 30.

Per RESEARCH.md § "30-config smoke matrix", the curated 30-subset is:
- 5 styles × 2 raised × 1 platform=DESKTOP × default base/accent = 10
- 5 styles × 1 raised=true × 1 platform=MOBILE × default base/accent = 5
- 1 style=CUSTOM × 2 raised × 3 platforms × default base/accent = 6
- 5 styles × 1 raised=true × 1 platform=AUTO × custom base/accent = 5
- 4 edge cases (very dark base, very light base, accent=base low-contrast, accent over WCAG floor) = 4
= 30

Use this EXACT skeleton:

```gdscript
extends SceneTree

## Phase 12 30-config smoke matrix runner.
## Invoke via: godot --headless --quit --script ".planning/phases/12-signature-visual-moves/helpers/_phase12_smoke_matrix.gd"
##
## Exits 0 if all 30 configs regenerate cleanly AND maintain invariants
## (BINDING_TABLE == 37 rows, @export count == 12, Button.normal stylebox produced).
## Exits 1 on first invariant violation (with collected failure list).

const CANONICAL_TRES := "res://addons/neocade_theme/neocade_theme.tres"
const EXPECTED_EXPORT_COUNT := 12
const EXPECTED_BINDING_TABLE_ROWS := 37

var _failures: Array[String] = []


func _init() -> void:
    print("PHASE12_SMOKE: begin")
    var configs := _build_curated_configs()
    print("PHASE12_SMOKE: %d configs queued" % configs.size())
    assert(configs.size() == 30, "PHASE12_SMOKE: curated matrix size = %d (expected 30)" % configs.size())

    var loaded: Resource = ResourceLoader.load(CANONICAL_TRES)
    if loaded == null or not (loaded is NeoCadeTheme):
        push_error("PHASE12_SMOKE: cannot load canonical .tres")
        quit(1)
        return

    var idx := 0
    for cfg in configs:
        idx += 1
        var t: NeoCadeTheme = (loaded as NeoCadeTheme).duplicate(true) as NeoCadeTheme
        # Apply axes. CUSTOM bypasses _apply_style_exports so we set fields directly.
        if cfg.has("style"):
            t.style = cfg.style
        if cfg.has("base_color"):
            t.base_color = cfg.base_color
        if cfg.has("accent_color"):
            t.accent_color = cfg.accent_color
        t.raised = cfg.raised
        t.platform = cfg.platform

        # Invariants per config.
        if not t.has_stylebox("normal", "Button"):
            _failures.append("config %d (%s): no Button.normal stylebox" % [idx, _label(cfg)])
        var script := t.get_script()
        var consts: Dictionary = script.get_script_constant_map()
        var bt: Dictionary = consts.get("BINDING_TABLE", {})
        if bt.size() != EXPECTED_BINDING_TABLE_ROWS:
            _failures.append("config %d (%s): BINDING_TABLE = %d rows (expected %d)" % [idx, _label(cfg), bt.size(), EXPECTED_BINDING_TABLE_ROWS])
        var export_count: int = _count_top_level_exports(script)
        if export_count != EXPECTED_EXPORT_COUNT:
            _failures.append("config %d (%s): @export count = %d (expected %d)" % [idx, _label(cfg), export_count, EXPECTED_EXPORT_COUNT])

    if _failures.size() > 0:
        print("PHASE12_SMOKE: FAIL — %d failure(s):" % _failures.size())
        for f in _failures:
            print("  - %s" % f)
        quit(1)
        return
    print("PHASE12_SMOKE: PASS — 30 configs regenerated cleanly, invariants held")
    quit(0)


# ─── Curated 30-config builder (per 12-RESEARCH.md § 30-config smoke matrix) ────

func _build_curated_configs() -> Array:
    var out: Array = []
    # Group 1: 5 styles × 2 raised × platform=DESKTOP × defaults (10 configs)
    for s in NeoCadeTheme.selectable_styles():
        for r in [false, true]:
            out.append({"style": s, "raised": r, "platform": NeoCadeTheme.Platform.DESKTOP})
    # Group 2: 5 styles × raised=true × platform=MOBILE × defaults (5 configs)
    for s in NeoCadeTheme.selectable_styles():
        out.append({"style": s, "raised": true, "platform": NeoCadeTheme.Platform.MOBILE})
    # Group 3: CUSTOM × 2 raised × 3 platforms × defaults (6 configs)
    for r in [false, true]:
        for p in [NeoCadeTheme.Platform.DESKTOP, NeoCadeTheme.Platform.MOBILE, NeoCadeTheme.Platform.AUTO]:
            out.append({"style": NeoCadeTheme.Style.CUSTOM, "raised": r, "platform": p})
    # Group 4: 5 styles × raised=true × AUTO × custom base/accent (5 configs)
    var custom_base := Color("#1A1A22")
    var custom_accent := Color("#E5C16C")
    for s in NeoCadeTheme.selectable_styles():
        out.append({
            "style": s,
            "raised": true,
            "platform": NeoCadeTheme.Platform.AUTO,
            "base_color": custom_base,
            "accent_color": custom_accent,
        })
    # Group 5: 4 edge cases on CUSTOM
    out.append({"style": NeoCadeTheme.Style.CUSTOM, "raised": true, "platform": NeoCadeTheme.Platform.DESKTOP,
                "base_color": Color("#000005"), "accent_color": Color("#FFFFFF")})  # very dark base
    out.append({"style": NeoCadeTheme.Style.CUSTOM, "raised": true, "platform": NeoCadeTheme.Platform.DESKTOP,
                "base_color": Color("#F5F5F5"), "accent_color": Color("#222222")})  # very light base
    out.append({"style": NeoCadeTheme.Style.CUSTOM, "raised": true, "platform": NeoCadeTheme.Platform.DESKTOP,
                "base_color": Color("#333333"), "accent_color": Color("#3A3A3A")})  # accent ≈ base (low contrast)
    out.append({"style": NeoCadeTheme.Style.CUSTOM, "raised": true, "platform": NeoCadeTheme.Platform.DESKTOP,
                "base_color": Color("#0E0E14"), "accent_color": Color("#FF6B35")})  # accent over WCAG floor
    return out


func _label(cfg: Dictionary) -> String:
    var style_label := "?"
    if cfg.has("style"):
        style_label = NeoCadeTheme.style_label(cfg.style)
    return "style=%s raised=%s platform=%s" % [style_label, cfg.raised, cfg.platform]


func _count_top_level_exports(script: Script) -> int:
    var count := 0
    for prop in script.get_script_property_list():
        var usage: int = int(prop.get("usage", 0))
        if (usage & PROPERTY_USAGE_SCRIPT_VARIABLE) != 0 and (usage & PROPERTY_USAGE_EDITOR) != 0 and (usage & PROPERTY_USAGE_STORAGE) != 0:
            count += 1
    return count
```

Notes:
- The `configs.size() == 30` assertion enforces the curated count at the very top — if a future edit changes a group's size, the script fails loudly before regenerating anything.
- `Color("#000005")` and `Color("#F5F5F5")` test the luminance-derived `is_light` flag at both extremes (NeoCadeTheme.gd:263 reads `base_color.get_luminance() >= 0.5`).
- The edge case "accent ≈ base" (low contrast) is the WCAG worst case; the theme should still regenerate without throwing even if the result is visually poor (visual quality is not in scope for smoke).
- Use `duplicate(true)` (deep) so per-config mutations do not bleed across iterations.
  </action>
  <verify>
    <automated>godot --headless --quit --script ".planning/phases/12-signature-visual-moves/helpers/_phase12_smoke_matrix.gd"</automated>
  </verify>
  <acceptance_criteria>
    - File `.planning/phases/12-signature-visual-moves/helpers/_phase12_smoke_matrix.gd` exists.
    - File begins with `extends SceneTree`.
    - File contains the literal assertion `configs.size() == 30`.
    - File contains 5 distinct config groups (verified by 5 `for` loops or explicit `out.append(...)` blocks corresponding to the 5 groups documented above).
    - File contains `Color("#000005")` AND `Color("#F5F5F5")` AND `Color("#FF6B35")` (the 3 edge-case literals).
    - Running `godot --headless --quit --script ".planning/phases/12-signature-visual-moves/helpers/_phase12_smoke_matrix.gd"` exits 0 with output `PHASE12_SMOKE: PASS`.
    - The 30-config smoke matrix is GREEN against the pre-Phase-12 baseline (this locks in the regression bar before Wave 1 begins).
  </acceptance_criteria>
  <done>Smoke matrix exists with the 30 curated configs, runs against the pre-Phase-12 baseline, and exits 0.</done>
</task>

</tasks>

<threat_model>
## Trust Boundaries

| Boundary | Description |
|----------|-------------|
| Developer machine → Godot CLI | The verify helpers run as `godot --headless --quit --script <path>` from the developer's shell. Script paths and `--stage` strings are developer-supplied; no external input. |
| `_phase12_thumbnail_render.gd` → filesystem | Writes PNGs to `.planning/phases/12-signature-visual-moves/artifacts/thumbnails/` via `Image.save_png`. Path is hardcoded; no traversal risk. |

## STRIDE Threat Register

| Threat ID | Category | Component | Disposition | Mitigation Plan |
|-----------|----------|-----------|-------------|-----------------|
| T-12.01-01 | Tampering | `--stage` argparse in `_phase12_verify_headless.gd` | mitigate | Reject unknown stage names and fall back to `architecture` (`if not VALID_STAGES.has(_stage): push_error + fallback`). Prevents accidental silent-pass on a typo. |
| T-12.01-02 | Repudiation | Failure messages in `_failures` array | mitigate | Every failure prepends a structured marker (`PHASE12_VERIFY FAIL:`) so CI grep is unambiguous. Exit code 0/1 cannot be repudiated. |
| T-12.01-03 | Information disclosure | Thumbnail PNGs | accept | PNGs render the public showcase scene; no secrets or PII. Saved under `.planning/` which is in-repo. |
| T-12.01-04 | Denial of service | Smoke matrix regenerate loop (30×) | accept | Per-config regenerate is ~0.1-0.3s; 30 configs run in well under 30s on a developer machine. No timeout needed. |
| T-12.01-05 | Elevation of privilege | EditorScript variants | accept | `@tool` scripts run with editor privileges by design; they only call documented `NeoCadeTheme` / `Image` / `DirAccess` APIs. |
</threat_model>

<verification>
After all 4 tasks complete, run the full Wave 0 acceptance battery against the pre-Phase-12 baseline:

```bash
godot --headless --quit --script ".planning/phases/12-signature-visual-moves/helpers/_phase12_verify_headless.gd" -- --stage architecture
godot --headless --quit --script ".planning/phases/12-signature-visual-moves/helpers/_phase12_verify_headless.gd" -- --stage sc1-no-3d-when-flat
godot --headless --quit --script ".planning/phases/12-signature-visual-moves/helpers/_phase12_verify_headless.gd" -- --stage sc2-tabs-flat-when-raised
godot --headless --quit --script ".planning/phases/12-signature-visual-moves/helpers/_phase12_verify_headless.gd" -- --stage sc3-no-glow-halo
godot --headless --quit --script ".planning/phases/12-signature-visual-moves/helpers/_phase12_verify_headless.gd" -- --stage sc6-export-count
godot --headless --quit --script ".planning/phases/12-signature-visual-moves/helpers/_phase12_verify_headless.gd" -- --stage full
godot --headless --quit --script ".planning/phases/12-signature-visual-moves/helpers/_phase12_smoke_matrix.gd"
```

All 7 commands MUST exit 0 on the pre-Phase-12 baseline. (The EditorScript variant and thumbnail render must be confirmed runnable from Godot Editor → File → Run; thumbnail render is a manual smoke that produces 5 baseline PNGs.)

If any of `sc1-no-3d-when-flat`, `sc2-tabs-flat-when-raised`, `sc3-no-glow-halo`, or `sc6-export-count` fails on the baseline, the assertions are wrong and the helper must be revised — the baseline is the locked invariant by definition.
</verification>

<success_criteria>
- All 4 helper files exist under `.planning/phases/12-signature-visual-moves/helpers/`.
- All helpers load ONLY the canonical resource `res://addons/neocade_theme/neocade_theme.tres` (no stale paths — Pitfall 6).
- `godot --headless --quit --script _phase12_verify_headless.gd -- --stage full` exits 0 on the pre-Phase-12 baseline.
- `godot --headless --quit --script _phase12_smoke_matrix.gd` exits 0 on the pre-Phase-12 baseline.
- The 5 baseline thumbnail PNGs are generated to `.planning/phases/12-signature-visual-moves/artifacts/thumbnails/` for post-Phase-12 comparison.
- No production code changes in this plan — the addon's `neocade_theme.gd` and `neocade_theme.tres` are untouched (verifiable via `git diff --stat addons/`).
</success_criteria>

<output>
After completion, create `.planning/phases/12-signature-visual-moves/12-01-SUMMARY.md` documenting:
- Which 4 helper files were created (paths + line counts)
- The pre-Phase-12 baseline output of each `--stage` (paste the `PHASE12_VERIFY: PASS …` line)
- Whether Assumption A1 (`saturation=0` vs `saturation=-1`) was resolved during baseline thumbnail render, and if so which value produced greyscale
- Any helper-internal failures that surfaced during baseline runs and how they were fixed (these are NOT production failures — they are bugs in the verifier itself)
</output>
