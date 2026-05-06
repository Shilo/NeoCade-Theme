---
phase: 04-foundation-neocadetheme-superclass-per-theme-subclasses-font
plan: 02
type: execute
wave: 1
depends_on: []
files_modified:
  - addons/neocade_theme/fonts/Inter-Variable.ttf
  - addons/neocade_theme/fonts/Inter-Variable.ttf.import
  - addons/neocade_theme/fonts/Inter-Variable.tres
  - addons/neocade_theme/fonts/Inter-HeaderLarge.tres
  - addons/neocade_theme/fonts/Inter-HeaderMedium.tres
  - addons/neocade_theme/fonts/Inter-HeaderSmall.tres
  - addons/neocade_theme/fonts/Inter-Body.tres
  - addons/neocade_theme/fonts/Inter-Caption.tres
  - addons/neocade_theme/OFL.txt
autonomous: true
requirements:
  - FONT-01
  - FONT-02
  - FONT-03
  - FONT-05
  - FONT-06
  - FONT-08
  - TOKEN-10
must_haves:
  truths:
    - "`addons/neocade_theme/fonts/Inter-Variable.ttf` exists (Inter Variable Roman from Inter v4.x; binary NOT renamed — Reserved Font Name preserved per FONT-05)."
    - "`addons/neocade_theme/fonts/Inter-Variable.ttf.import` sets `antialiasing=1` (Grayscale), `hinting=1` (Light), `subpixel_positioning=2` (Auto), and `mipmaps=true` (per STACK + PITFALLS 5.5 for GL Compatibility)."
    - "`addons/neocade_theme/fonts/Inter-Variable.tres` is a `FontFile` resource pointing at `Inter-Variable.ttf` via `uid://` resource path (FONT-01)."
    - "Five `FontVariation` `.tres` resources at `addons/neocade_theme/fonts/` cover the M3 type scale per DESIGN_TOKENS §8.5: `Inter-HeaderLarge.tres` (wght=800, opsz=32), `Inter-HeaderMedium.tres` (wght=700, opsz=32), `Inter-HeaderSmall.tres` (wght=600, opsz=24), `Inter-Body.tres` (wght=400), `Inter-Caption.tres` (wght=400, smaller binding scale)."
    - "Each FontVariation `.tres` references the base FontFile at `Inter-Variable.tres` (or the TTF directly via UID), and sets `variation_opentype` keys for `wght` and (where applicable) `opsz` axes."
    - "`addons/neocade_theme/OFL.txt` contains the verbatim SIL Open Font License 1.1 body, the Inter Reserved Font Name notice (`Reserved Font Name 'Inter'`), and the Inter copyright block (`Copyright (c) 2016 The Inter Project Authors`)."
    - "Synthetic italic transform note for FONT-07 is recorded in CHANGELOG.md (lands in Plan 04-08), so this plan does NOT need to ship italic glyphs."
  artifacts:
    - addons/neocade_theme/fonts/Inter-Variable.ttf
    - addons/neocade_theme/fonts/Inter-Variable.ttf.import
    - addons/neocade_theme/fonts/Inter-Variable.tres
    - addons/neocade_theme/fonts/Inter-HeaderLarge.tres
    - addons/neocade_theme/fonts/Inter-HeaderMedium.tres
    - addons/neocade_theme/fonts/Inter-HeaderSmall.tres
    - addons/neocade_theme/fonts/Inter-Body.tres
    - addons/neocade_theme/fonts/Inter-Caption.tres
    - addons/neocade_theme/OFL.txt
  key_links:
    - ".planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-CONTEXT.md D-14 step 3"
    - ".planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-RESEARCH.md §5"
    - ".planning/DESIGN_TOKENS.md §8.5"
    - ".planning/research/FONT-REVIEW.md (UD-4 Option D)"
    - ".planning/research/PITFALLS.md §5.5"
---

<objective>
Bundle Inter Variable Roman as the ONLY font (UD-4 Option D), author the FontFile + 5 FontVariation `.tres` resources covering the M3 type scale, set the GL-Compatibility-correct import settings, and ship the OFL.txt with the Inter Reserved Font Name notice.

Purpose: provide every font surface Phase 4's `_regenerate_theme()` and Phases 5/6/7's per-direction Theme Editor authoring will reference (FOUND-02 typography binding + TYPEVAR-01..04 explicit fonts).
Output: 1 TTF + 1 `.import` sidecar + 1 FontFile.tres + 5 FontVariation.tres + OFL.txt = 9 new files at `addons/neocade_theme/fonts/` (and `OFL.txt` at addon root).
</objective>

<execution_context>
@$HOME/.codex/get-shit-done/workflows/execute-plan.md
@$HOME/.codex/get-shit-done/templates/summary.md
</execution_context>

<context>
@.planning/DESIGN_TOKENS.md
@.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-CONTEXT.md
@.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-RESEARCH.md
@.planning/research/FONT-REVIEW.md
@.planning/research/STACK.md
@.planning/research/PITFALLS.md

<interfaces>
Files to create:
- `addons/neocade_theme/fonts/Inter-Variable.ttf` — the binary (Inter v4.x Variable Roman; downloaded once, committed to repo).
- `addons/neocade_theme/fonts/Inter-Variable.ttf.import` — Godot import sidecar with grayscale AA + light hinting + auto subpixel + mipmaps.
- `addons/neocade_theme/fonts/Inter-Variable.tres` — `FontFile` resource referencing the TTF (the canonical font UID Phase 4-5/6/7 reference).
- `addons/neocade_theme/fonts/Inter-HeaderLarge.tres` — `FontVariation` (wght=800, opsz=32) for display-small / HeaderLarge type variation.
- `addons/neocade_theme/fonts/Inter-HeaderMedium.tres` — `FontVariation` (wght=700, opsz=32) for headline-small / HeaderMedium.
- `addons/neocade_theme/fonts/Inter-HeaderSmall.tres` — `FontVariation` (wght=600, opsz=24) for title-large / HeaderSmall.
- `addons/neocade_theme/fonts/Inter-Body.tres` — `FontVariation` (wght=400) for body / Label default.
- `addons/neocade_theme/fonts/Inter-Caption.tres` — `FontVariation` (wght=400) for body-small / Caption type variation.
- `addons/neocade_theme/OFL.txt` — SIL OFL 1.1 license body + Inter Reserved Font Name notice + Inter copyright.

This plan is parallel-eligible with Plans 04-01 and 04-03 (Wave 1).
</interfaces>
</context>

<tasks>

<task type="auto">
  <name>Task 1: Acquire Inter-Variable.ttf and place at addons/neocade_theme/fonts/</name>
  <read_first>
    - .planning/research/FONT-REVIEW.md (UD-4 Option D — Inter Variable Roman ONLY)
    - .planning/research/STACK.md (font import settings)
  </read_first>
  <files>
    - addons/neocade_theme/fonts/Inter-Variable.ttf (NEW — binary)
  </files>
  <action>
    Download the Inter Variable Roman TTF from Inter v4.x. Source of truth: the official Inter releases page at https://github.com/rsms/inter/releases. Use the variable-axis Roman TTF specifically (NOT the static Regular TTF, NOT Italic, NOT the OTF).

    Steps:
    1. Use PowerShell `Invoke-WebRequest` to download the latest Inter v4.x release archive zip (or the standalone `Inter-Variable.ttf` if available as a direct asset). Example URL pattern (verify against the latest release): `https://github.com/rsms/inter/releases/download/v4.0/Inter-4.0.zip`.
    2. If a zip was downloaded, extract it to a temp directory. Locate the file named `InterVariable.ttf` or `Inter-Variable.ttf` (Roman variable TTF — single file, NOT the italic variant).
    3. Rename to `Inter-Variable.ttf` (canonical NeoCade filename — preserves Reserved Font Name; no other rename allowed per FONT-05).
    4. Place at `addons/neocade_theme/fonts/Inter-Variable.ttf`.
    5. Verify file size is plausible for a variable font (typically 600 KB – 1.2 MB).

    NOTE: the binary will be tracked by git; commit lands in the final task of this plan.
  </action>
  <acceptance_criteria>
    - `addons/neocade_theme/fonts/Inter-Variable.ttf` exists.
    - File is a valid TTF: first 4 bytes are `0x00 0x01 0x00 0x00` (TTF signature) OR `0x4F 0x54 0x54 0x4F` (OTF/CFF; reject — Inter Variable is TTF).
    - File size is between 500 KB and 2 MB (sanity bounds for Inter Variable Roman).
    - Filename is exactly `Inter-Variable.ttf` (Reserved Font Name preserved per FONT-05).
  </acceptance_criteria>
  <verify>
    <automated>
      powershell -NoProfile -Command "$p='addons/neocade_theme/fonts/Inter-Variable.ttf'; if (-not (Test-Path $p)) { throw 'Inter-Variable.ttf missing' }; $size=(Get-Item $p).Length; if ($size -lt 500000 -or $size -gt 2000000) { throw \"Inter-Variable.ttf size $size bytes outside expected range\" }; $sig=[System.IO.File]::ReadAllBytes($p)[0..3]; if (-not (($sig[0] -eq 0x00) -and ($sig[1] -eq 0x01) -and ($sig[2] -eq 0x00) -and ($sig[3] -eq 0x00))) { throw 'Not a valid TTF (signature mismatch)' }"
    </automated>
  </verify>
  <done>The Inter Variable Roman binary is in place at the canonical NeoCade path with Reserved Font Name preserved.</done>
</task>

<task type="auto">
  <name>Task 2: Author Inter-Variable.ttf.import sidecar with GL-Compatibility-correct settings</name>
  <read_first>
    - addons/neocade_theme/fonts/Inter-Variable.ttf
    - .planning/research/PITFALLS.md (§5.5 GL Compat font settings)
    - .planning/research/STACK.md
  </read_first>
  <files>
    - addons/neocade_theme/fonts/Inter-Variable.ttf.import (NEW)
  </files>
  <action>
    Create `addons/neocade_theme/fonts/Inter-Variable.ttf.import` with the Godot 4.6 FontFile import sidecar format. Required settings per DESIGN_TOKENS + PITFALLS 5.5:

    ```ini
    [remap]

    importer="font_data_dynamic"
    type="FontFile"
    uid="uid://<godot-generated-uid>"
    path="res://.godot/imported/Inter-Variable.ttf-<hash>.fontdata"

    [deps]

    source_file="res://addons/neocade_theme/fonts/Inter-Variable.ttf"
    dest_files=["res://.godot/imported/Inter-Variable.ttf-<hash>.fontdata"]

    [params]

    Rendering=null
    antialiasing=1
    generate_mipmaps=true
    multichannel_signed_distance_field=false
    msdf_pixel_range=8
    msdf_size=48
    allow_system_fallback=true
    force_autohinter=false
    hinting=1
    subpixel_positioning=2
    keep_rounding_remainders=true
    oversampling=0.0
    Fallbacks=null
    fallbacks=[]
    Compress=null
    compress=true
    preload=[]
    language_support={}
    script_support={}
    opentype_features={}
    ```

    Notes (verify against Godot 4.6's FontFile importer; the values matter, not the exact comment headers):
    - `antialiasing=1` → Grayscale (NOT LCD subpixel; GL Compat over-renders LCD per Conflict 3 / PITFALLS 5.5).
    - `hinting=1` → Light hinting (Auto-hint+full produces blurry weights under GL Compat).
    - `subpixel_positioning=2` → Auto.
    - `generate_mipmaps=true` → required for crisp scaling at multiple sizes.
    - `allow_system_fallback=true` → enables OS-side CJK fallback (UD-2; documented in README via Plan 04-08).
    - `multichannel_signed_distance_field=false` → bitmap glyphs, not MSDF (per PITFALLS / project decisions).

    The exact UID and import-cache hash values are generated by Godot at first import; this sidecar's UID + path placeholders WILL be rewritten by Godot when the file is first opened. The plan-level requirement is that the `[params]` block has the correct values; the `[remap]` UID/hash will normalize on first editor launch. To avoid Godot's UID overwrite blocking verification, this task uses a synthetic UID (`uid://neocade_inter_variable_v1`) that Godot will replace; the verify command checks the param values, not the UID.

    Author the file with the synthetic UID; on first `godot --headless --import` (in a later plan or manually) Godot rewrites it. The settings persist.

    Step-by-step: write the file using PowerShell `Set-Content` (UTF-8 no BOM), with the contents above. Replace `<godot-generated-uid>` with `neocade_inter_variable_v1` and `<hash>` with `placeholder` (Godot will rewrite both on first import).
  </action>
  <acceptance_criteria>
    - `addons/neocade_theme/fonts/Inter-Variable.ttf.import` exists.
    - File contains `importer="font_data_dynamic"`.
    - File contains `type="FontFile"`.
    - File contains `antialiasing=1` (Grayscale).
    - File contains `hinting=1` (Light).
    - File contains `subpixel_positioning=2` (Auto).
    - File contains `generate_mipmaps=true`.
    - File contains `allow_system_fallback=true`.
    - File contains `multichannel_signed_distance_field=false`.
    - File's `source_file` line points to `res://addons/neocade_theme/fonts/Inter-Variable.ttf`.
  </acceptance_criteria>
  <verify>
    <automated>
      powershell -NoProfile -Command "$p='addons/neocade_theme/fonts/Inter-Variable.ttf.import'; if (-not (Test-Path $p)) { throw 'import sidecar missing' }; $g=Get-Content -Raw $p; foreach($n in 'importer=\"font_data_dynamic\"','type=\"FontFile\"','antialiasing=1','generate_mipmaps=true','hinting=1','subpixel_positioning=2','allow_system_fallback=true','multichannel_signed_distance_field=false','source_file=\"res://addons/neocade_theme/fonts/Inter-Variable.ttf\"') { if ($g -notmatch [regex]::Escape($n)) { throw \"missing required substring: $n\" } }"
    </automated>
  </verify>
  <done>The import sidecar enforces GL-Compatibility-correct font rendering for the lifetime of the addon.</done>
</task>

<task type="auto">
  <name>Task 3: Author Inter-Variable.tres FontFile resource wrapper</name>
  <read_first>
    - addons/neocade_theme/fonts/Inter-Variable.ttf
    - addons/neocade_theme/fonts/Inter-Variable.ttf.import
  </read_first>
  <files>
    - addons/neocade_theme/fonts/Inter-Variable.tres (NEW)
  </files>
  <action>
    Author `addons/neocade_theme/fonts/Inter-Variable.tres` as a Godot 4.6 `FontFile` resource that points at the imported `Inter-Variable.ttf`. This is the canonical font UID that Phase 4-5 / 6 / 7 reference for `default_font` and as the `base_font` for FontVariation resources.

    File contents:

    ```
    [gd_resource type="FontFile" load_steps=2 format=3 uid="uid://neocade_inter_var_tres"]

    [ext_resource type="FontFile" uid="uid://neocade_inter_variable_v1" path="res://addons/neocade_theme/fonts/Inter-Variable.ttf" id="1_ttf"]

    [resource]
    fallbacks = []
    ```

    Note: in practice, when Godot imports the TTF, it produces a FontFile that is itself loadable. The `Inter-Variable.tres` wrapper exists to give the project a stable, hand-authored UID that survives reimports and is referenced by FontVariation children. If Godot's importer already publishes a stable UID via the `.import` sidecar, this wrapper duplicates that UID indirection — but it's conventional in Godot 4 projects to ship an explicit `.tres` for the font asset (so consumer code can `preload("res://addons/neocade_theme/fonts/Inter-Variable.tres")` rather than the TTF directly).

    Implementation note: the actual `[gd_resource]` `format=3` files in Godot 4 may need slightly different syntax depending on FontFile's serialized properties. If `[ext_resource type="FontFile" ...]` is rejected (because the importer auto-generates the FontFile), the alternative is to ship `Inter-Variable.tres` as a direct duplicate FontFile (loaded from the TTF) with `font_data` pointing at the TTF. The executor should choose whichever form opens correctly in Godot Editor; both forms map to "the canonical Inter FontFile."

    Acceptance criterion is loadability + correct UID, NOT exact byte equivalence to a reference file.
  </action>
  <acceptance_criteria>
    - `addons/neocade_theme/fonts/Inter-Variable.tres` exists.
    - First line begins with `[gd_resource type="FontFile"`.
    - File references `res://addons/neocade_theme/fonts/Inter-Variable.ttf` (via `path=` or `font_data=`).
    - File contains a `[resource]` section.
    - File parses as valid Godot resource syntax (no syntax errors when Godot reads it).
  </acceptance_criteria>
  <verify>
    <automated>
      powershell -NoProfile -Command "$p='addons/neocade_theme/fonts/Inter-Variable.tres'; if (-not (Test-Path $p)) { throw 'Inter-Variable.tres missing' }; $g=Get-Content -Raw $p; if ($g -notmatch '^\[gd_resource type=\"FontFile\"') { throw 'not a FontFile resource (header mismatch)' }; if ($g -notmatch 'res://addons/neocade_theme/fonts/Inter-Variable\.ttf') { throw 'does not reference Inter-Variable.ttf' }; if ($g -notmatch '\[resource\]') { throw 'missing [resource] section' }"
    </automated>
  </verify>
  <done>The canonical FontFile wrapper is in place and ready to be referenced by FontVariation children + consumer preload calls.</done>
</task>

<task type="auto">
  <name>Task 4: Author 5 FontVariation .tres resources for the M3 type scale</name>
  <read_first>
    - .planning/DESIGN_TOKENS.md (§8.5 — M3 type scale + Inter wght/opsz axes)
    - addons/neocade_theme/fonts/Inter-Variable.tres
  </read_first>
  <files>
    - addons/neocade_theme/fonts/Inter-HeaderLarge.tres (NEW)
    - addons/neocade_theme/fonts/Inter-HeaderMedium.tres (NEW)
    - addons/neocade_theme/fonts/Inter-HeaderSmall.tres (NEW)
    - addons/neocade_theme/fonts/Inter-Body.tres (NEW)
    - addons/neocade_theme/fonts/Inter-Caption.tres (NEW)
  </files>
  <action>
    For each of the 5 type-scale variations below, author a `FontVariation` `.tres` at `addons/neocade_theme/fonts/{name}.tres`. Each variation uses Inter's `wght` and (where listed) `opsz` axes; per DESIGN_TOKENS §8.5 the values are:

    | File | M3 token | wght | opsz |
    |---|---|---|---|
    | Inter-HeaderLarge.tres | display-small | 800 | 32 |
    | Inter-HeaderMedium.tres | headline-small | 700 | 32 |
    | Inter-HeaderSmall.tres | title-large | 600 | 24 |
    | Inter-Body.tres | body-medium / Label default | 400 | (omit — not applicable for body) |
    | Inter-Caption.tres | body-small / Caption | 400 | (omit) |

    Template for each (substitute name + values):

    ```
    [gd_resource type="FontVariation" load_steps=2 format=3 uid="uid://neocade_inter_<name>_v1"]

    [ext_resource type="FontFile" uid="uid://neocade_inter_var_tres" path="res://addons/neocade_theme/fonts/Inter-Variable.tres" id="1_inter"]

    [resource]
    base_font = ExtResource("1_inter")
    variation_opentype = {
        "wght": <wght>,
        "opsz": <opsz>
    }
    ```

    For `Inter-Body.tres` and `Inter-Caption.tres` (no `opsz` axis specified), the `variation_opentype` dict has only `"wght": 400`.

    UID convention: each FontVariation gets a unique synthetic UID (`uid://neocade_inter_headerlarge_v1` etc.) that Godot will normalize on first import. Verification checks param values, not UID format.

    Step-by-step:
    1. Author `Inter-HeaderLarge.tres` with `wght=800, opsz=32`.
    2. Author `Inter-HeaderMedium.tres` with `wght=700, opsz=32`.
    3. Author `Inter-HeaderSmall.tres` with `wght=600, opsz=24`.
    4. Author `Inter-Body.tres` with `wght=400`.
    5. Author `Inter-Caption.tres` with `wght=400`.

    Use PowerShell `Set-Content` per file. Verify each parses by checking for the required substrings.
  </action>
  <acceptance_criteria>
    - All 5 files exist at `addons/neocade_theme/fonts/Inter-Header{Large,Medium,Small}.tres`, `Inter-Body.tres`, `Inter-Caption.tres`.
    - Each file's first line begins with `[gd_resource type="FontVariation"`.
    - Each file has an `[ext_resource ...]` line referencing `Inter-Variable.tres`.
    - Each file has a `[resource]` section with `base_font = ExtResource(`.
    - Each file has a `variation_opentype = {` block.
    - `Inter-HeaderLarge.tres` contains `"wght": 800` and `"opsz": 32`.
    - `Inter-HeaderMedium.tres` contains `"wght": 700` and `"opsz": 32`.
    - `Inter-HeaderSmall.tres` contains `"wght": 600` and `"opsz": 24`.
    - `Inter-Body.tres` contains `"wght": 400`.
    - `Inter-Caption.tres` contains `"wght": 400`.
  </acceptance_criteria>
  <verify>
    <automated>
      powershell -NoProfile -Command "$base='addons/neocade_theme/fonts'; $files=@{'Inter-HeaderLarge.tres'=@('\"wght\": 800','\"opsz\": 32');'Inter-HeaderMedium.tres'=@('\"wght\": 700','\"opsz\": 32');'Inter-HeaderSmall.tres'=@('\"wght\": 600','\"opsz\": 24');'Inter-Body.tres'=@('\"wght\": 400');'Inter-Caption.tres'=@('\"wght\": 400')}; foreach($k in $files.Keys) { $p=\"$base/$k\"; if (-not (Test-Path $p)) { throw \"$k missing\" }; $g=Get-Content -Raw $p; if ($g -notmatch '^\[gd_resource type=\"FontVariation\"') { throw \"$k not a FontVariation\" }; if ($g -notmatch 'Inter-Variable\.tres') { throw \"$k missing base_font ref\" }; if ($g -notmatch 'variation_opentype = \{') { throw \"$k missing variation_opentype\" }; foreach($req in $files[$k]) { if ($g -notmatch [regex]::Escape($req)) { throw \"$k missing $req\" } } }"
    </automated>
  </verify>
  <done>All 5 FontVariation resources are authored and ready for `_regenerate_theme()` and Theme Editor reference.</done>
</task>

<task type="auto">
  <name>Task 5: Author OFL.txt with the Inter Reserved Font Name notice</name>
  <read_first>
    - .planning/research/FONT-REVIEW.md
    - addons/neocade_theme/fonts/Inter-Variable.ttf
  </read_first>
  <files>
    - addons/neocade_theme/OFL.txt (NEW)
  </files>
  <action>
    Author `addons/neocade_theme/OFL.txt` with this structure:

    ```
    Inter Variable Font
    -------------------

    Copyright (c) 2016 The Inter Project Authors (https://github.com/rsms/inter)

    This Font Software is licensed under the SIL Open Font License, Version 1.1.

    Reserved Font Name "Inter".

    -----------------------------------------------------------
    SIL OPEN FONT LICENSE Version 1.1 - 26 February 2007
    -----------------------------------------------------------

    PREAMBLE
    The goals of the Open Font License (OFL) are to stimulate worldwide
    development of collaborative font projects, to support the font creation
    efforts of academic and linguistic communities, and to provide a free and
    open framework in which fonts may be shared and improved in partnership
    with others.

    The OFL allows the licensed fonts to be used, studied, modified and
    redistributed freely as long as they are not sold by themselves. The
    fonts, including any derivative works, can be bundled, embedded,
    redistributed and/or sold with any software provided that any reserved
    names are not used by derivative works. The fonts and derivatives,
    however, cannot be released under any other type of license. The
    requirement for fonts to remain under this license does not apply to any
    document created using the fonts or their derivatives.

    DEFINITIONS
    "Font Software" refers to the set of files released by the Copyright
    Holder(s) under this license and clearly marked as such. This may
    include source files, build scripts and documentation.

    "Reserved Font Name" refers to any names specified as such after the
    copyright statement(s).

    "Original Version" refers to the collection of Font Software components as
    distributed by the Copyright Holder(s).

    "Modified Version" refers to any derivative made by adding to, deleting,
    or substituting -- in part or in whole -- any of the components of the
    Original Version, by changing formats or by porting the Font Software to a
    new environment.

    "Author" refers to any designer, engineer, programmer, technical
    writer or other person who contributed to the Font Software.

    PERMISSION & CONDITIONS
    Permission is hereby granted, free of charge, to any person obtaining
    a copy of the Font Software, to use, study, copy, merge, embed, modify,
    redistribute, and sell modified and unmodified copies of the Font
    Software, subject to the following conditions:

    1) Neither the Font Software nor any of its individual components,
    in Original or Modified Versions, may be sold by itself.

    2) Original or Modified Versions of the Font Software may be bundled,
    redistributed and/or sold with any software, provided that each copy
    contains the above copyright notice and this license. These can be
    included either as stand-alone text files, human-readable headers or
    in the appropriate machine-readable metadata fields within text or
    binary files as long as those fields can be easily viewed by the user.

    3) No Modified Version of the Font Software may use the Reserved Font
    Name(s) unless explicit written permission is granted by the
    corresponding Copyright Holder. This restriction only applies to the
    primary font name as presented to the users.

    4) The name(s) of the Copyright Holder(s) or the Author(s) of the Font
    Software shall not be used to promote, endorse or advertise any
    Modified Version, except to acknowledge the contribution(s) of the
    Copyright Holder(s) and the Author(s) or with their explicit written
    permission.

    5) The Font Software, modified or unmodified, in part or in whole,
    must be distributed entirely under this license, and must not be
    distributed under any other license. The requirement for fonts to
    remain under this license does not apply to any document created
    using the Font Software.

    TERMINATION
    This license becomes null and void if any of the above conditions are
    not met.

    DISCLAIMER
    THE FONT SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
    EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OF
    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT
    OF COPYRIGHT, PATENT, TRADEMARK, OR OTHER RIGHT. IN NO EVENT SHALL THE
    COPYRIGHT HOLDER BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
    INCLUDING ANY GENERAL, SPECIAL, INDIRECT, INCIDENTAL, OR CONSEQUENTIAL
    DAMAGES, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
    FROM, OUT OF THE USE OR INABILITY TO USE THE FONT SOFTWARE OR FROM
    OTHER DEALINGS IN THE FONT SOFTWARE.
    ```

    Use PowerShell `Set-Content -Encoding UTF8` (no BOM). The exact OFL 1.1 body above is the canonical SIL release; Inter's project README publishes the same text.
  </action>
  <acceptance_criteria>
    - `addons/neocade_theme/OFL.txt` exists.
    - File contains the literal substring `Copyright (c) 2016 The Inter Project Authors`.
    - File contains the literal substring `Reserved Font Name "Inter"`.
    - File contains the literal substring `SIL OPEN FONT LICENSE Version 1.1`.
    - File contains the literal substring `PERMISSION & CONDITIONS`.
    - File contains the literal substring `TERMINATION`.
    - File contains the literal substring `DISCLAIMER`.
    - File size is between 3 KB and 8 KB (sanity bounds for the OFL 1.1 body).
  </acceptance_criteria>
  <verify>
    <automated>
      powershell -NoProfile -Command "$p='addons/neocade_theme/OFL.txt'; if (-not (Test-Path $p)) { throw 'OFL.txt missing' }; $g=Get-Content -Raw $p; foreach($n in 'Copyright (c) 2016 The Inter Project Authors','Reserved Font Name \"Inter\"','SIL OPEN FONT LICENSE Version 1.1','PERMISSION & CONDITIONS','TERMINATION','DISCLAIMER') { if ($g -notmatch [regex]::Escape($n)) { throw \"OFL.txt missing required substring: $n\" } }; $size=(Get-Item $p).Length; if ($size -lt 3000 -or $size -gt 8000) { throw \"OFL.txt size $size bytes outside expected range\" }"
    </automated>
  </verify>
  <done>OFL compliance is in place; FONT-05 closes.</done>
</task>

<task type="auto">
  <name>Task 6: Atomic commit — Inter Variable Roman + FontVariations + OFL</name>
  <read_first>
    - addons/neocade_theme/fonts/Inter-Variable.ttf
    - addons/neocade_theme/OFL.txt
  </read_first>
  <files>(commit only)</files>
  <action>
    Stage all 9 new files (TTF + import sidecar + FontFile.tres + 5 FontVariation.tres + OFL.txt) and commit:

    ```
    feat(04-02): bundle Inter Variable Roman + FontVariations + OFL.txt

    Plan 04-02 wave-1 fonts:
    - Inter-Variable.ttf (Inter v4.x, Reserved Font Name preserved per FONT-05)
    - Inter-Variable.ttf.import (Grayscale AA + Light hinting + Auto subpixel
      + Mipmaps for GL Compat per PITFALLS 5.5)
    - Inter-Variable.tres (canonical FontFile resource wrapper)
    - 5 FontVariation .tres for M3 type scale per DESIGN_TOKENS §8.5:
      HeaderLarge (wght=800, opsz=32), HeaderMedium (wght=700, opsz=32),
      HeaderSmall (wght=600, opsz=24), Body (wght=400), Caption (wght=400)
    - OFL.txt with Inter Reserved Font Name notice + SIL OFL 1.1 license body

    Refs: FONT-01, FONT-02, FONT-03, FONT-05, FONT-06, FONT-08
    Plan: 04-02
    ```

    `git add` the 9 files, then commit. Do NOT push.
  </action>
  <acceptance_criteria>
    - `git log -1 --pretty=%s` returns a subject line starting with `feat(04-02):`.
    - `git log -1 --name-status` shows `A` entries for: `addons/neocade_theme/fonts/Inter-Variable.ttf`, `addons/neocade_theme/fonts/Inter-Variable.ttf.import`, `addons/neocade_theme/fonts/Inter-Variable.tres`, `addons/neocade_theme/fonts/Inter-HeaderLarge.tres`, `addons/neocade_theme/fonts/Inter-HeaderMedium.tres`, `addons/neocade_theme/fonts/Inter-HeaderSmall.tres`, `addons/neocade_theme/fonts/Inter-Body.tres`, `addons/neocade_theme/fonts/Inter-Caption.tres`, `addons/neocade_theme/OFL.txt`.
    - `git status --porcelain` is empty for all 9 paths.
  </acceptance_criteria>
  <verify>
    <automated>
      powershell -NoProfile -Command "$msg = git log -1 --pretty=%s; if ($msg -notmatch '^feat\\(04-02\\):') { throw \"commit subject wrong: $msg\" }; $ns = git log -1 --name-status; foreach($f in 'addons/neocade_theme/fonts/Inter-Variable\\.ttf$','addons/neocade_theme/fonts/Inter-Variable\\.ttf\\.import','addons/neocade_theme/fonts/Inter-Variable\\.tres','addons/neocade_theme/fonts/Inter-HeaderLarge\\.tres','addons/neocade_theme/fonts/Inter-HeaderMedium\\.tres','addons/neocade_theme/fonts/Inter-HeaderSmall\\.tres','addons/neocade_theme/fonts/Inter-Body\\.tres','addons/neocade_theme/fonts/Inter-Caption\\.tres','addons/neocade_theme/OFL\\.txt') { if ($ns -notmatch \"A\\s+$f\") { throw \"commit missing $f\" } }"
    </automated>
  </verify>
  <done>Fonts and OFL land as a single atomic commit; Wave 1 fonts portion of Phase 4 is complete.</done>
</task>

</tasks>
