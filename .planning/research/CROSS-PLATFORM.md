# Cross-Platform & Mobile-Variant Research — NeoCade Theme

**Domain:** Godot 4.6 UI Theme addon — cross-platform export validation (Win / macOS / Linux / iOS / Android / Web) + mobile-variant authoring (`neocade_mobile_theme.tres` alongside `neocade_theme.tres`)
**Researched:** 2026-05-04
**Overall confidence:** HIGH on per-target Godot behavior (cross-checked with Godot 4.6 release notes + official export docs + 5+ named GitHub issues); HIGH on iOS/Android tap-target/typography numerics (cited iOS HIG and Material 3); HIGH on font license compliance (cited SIL OFL FAQ + OFL official); MEDIUM on token-sharing strategy (Godot Theme has no `.tres`-to-`.tres` inheritance — verified, ThemeGen confirmed as the only mature pattern); MEDIUM on Web export font reliability under deployed hosting (multi-source community reports, no official Godot validation matrix).

---

## TL;DR — The 7 Decisions That Must Be Locked Before Phase 2

These are the cross-platform-specific decisions the synthesizer and roadmapper must reconcile. Each supersedes any prior STACK/FEATURES/ARCHITECTURE/PITFALLS guidance where it conflicts.

| # | Decision | Recommendation | Confidence | Why |
|---|---|---|---|---|
| 1 | **Renderer for cross-platform breadth** | **GL Compatibility** on every target. Already locked in `project.godot` (`renderer/rendering_method=gl_compatibility`, `renderer/rendering_method.mobile=gl_compatibility`). DO NOT switch to Mobile renderer for Android — issue #111729 confirms Mobile renderer reduces Play Store device coverage; iOS Mobile renderer has Metal validation regression on iPhone SE 2nd gen in Godot 4.6 (issue #116090, release blocker for 4.7). | HIGH | Single-renderer discipline keeps the theme's stylebox AA/shadow behavior identical across all 6 targets. |
| 2 | **Token-sharing strategy: `@tool` script generates BOTH `.tres` files from one `TokenSet.gd`** | Use a generator script (custom or ThemeGen) that authors `neocade_theme.tres` AND `neocade_mobile_theme.tres` from the same source-of-truth tokens. Godot's Theme class has NO `.tres`-to-`.tres` inheritance (verified — only `merge_with()` and `copy_from()` at runtime, neither persists at .tres-author time). Ship the two `.tres` files as final committed artifacts; ship the generator script in `addons/neocade_theme/_dev/` (NOT loaded at runtime). | HIGH | Confirmed via Godot 4.6 Theme class docs; ThemeGen (Inspiaaa, MIT, Asset Library 3299) is the proven implementation pattern. |
| 3 | **Mobile minimum tap target: `Button` minimum height = 48px (Godot pixels), 12px vertical / 16px horizontal padding** | This satisfies BOTH iOS HIG (44pt minimum, with 4pt of touch slop = effectively 48pt @1x) AND Material 3 (48dp Android minimum). Authoring in Godot pixels at base scale 1.0 with proper `content_scale_factor`/`content_scale_size` settings means 48px in the theme → 48dp on Android → 48pt on iOS @ recommended scale. Desktop primary stays at 32px button minimum. | HIGH | iOS HIG 44pt minimum + Material 3 48dp + 8dp button-to-button separation, all verified at developer.apple.com and m3.material.io |
| 4 | **Mobile body font_size = 16px (vs desktop 14px)** | iOS HIG body = 17pt; Material 3 body-medium = 14sp but body-large = 16sp and recommends 16sp for primary content. 16px is the safe middle that meets both. Caption/hint stays 14px on mobile (vs 12px desktop) so accessibility minimum is honored. | HIGH | Apple HIG body size 17pt; Material 3 body-large 16sp; LearnUI Design + a11y consensus on 16sp/16pt as mobile body floor. |
| 5 | **Bundle Inter Variable + Noto Sans Variable + Outfit Variable as committed `.ttf` files in `addons/neocade_theme/fonts/`. NO subsetting at v1.** | All three are OFL 1.1 — Inter v4.1 (rsms/inter), Noto Sans (notofonts), Outfit (Google Fonts). All explicitly redistributable embedded in App Store + Play Store apps per OFL FAQ + Apple licensing FAQs. License compliance: ship `OFL.txt` with copyright statements for all three fonts in the same folder as the `.ttf` files. Total bundle ~1.85 MB. CJK is NOT bundled in v1. | HIGH | OFL 1.1 + SIL FAQ explicit on App Store / Play Store legality; "reserved name" clause forbids renaming binaries — keep filenames intact (Inter-VariableFont*.ttf, etc.). |
| 6 | **Web export validation via project-level config flags, not platform detection in the theme** | Theme code has zero platform detection. Web export specifics (CORS headers, MIME types, font path resolution) are project config / hosting config, NOT theme concerns. The theme just needs to ensure: (a) all font and icon resources are referenced via `uid://` (not bare `res://`) so PCK remap survives, (b) all fonts use FontFile (NEVER SystemFont — verified breaks on Web), (c) all `.ttf` files have explicit `*.ttf` filter inclusion verified at Project → Export → Resources → "Filters to export non-resources". | HIGH | Multiple community reports converge: SystemFont silently breaks Web; explicit `*.ttf` export filter is required; FontFile-with-bundled-binary is the only reliable pattern. |
| 7 | **Cross-platform validation order: Linux → Windows → macOS → Web → Android → iOS** | Linux/Windows/macOS are functionally identical (all GL Compatibility, native FontFile, no PCK weirdness — same theme `.tres` renders identically modulo system DPI). Web is highest-risk (font binding, CORS). Android needs density-bucket physical-device sweep. iOS is last because requires a Mac + Xcode + paid developer account, and has unresolved Mobile-renderer regression in 4.6 (we use GL Compat so unaffected, but still last). | MEDIUM | Pragmatic ordering — verify cheap targets first, push expensive iOS to end. v1 acceptance is "render parity within 5% pixel diff vs desktop reference" plus tap-area validation on touch targets. |

---

## (1) Per-Export-Target Matrix — Asset Paths, Font Loading, Theme Parity, Known Bugs, Severity

This is the master cross-platform table. Each row is a target × concern. Severity: HIGH (blocks v1 ship), MED (visible regression), LOW (polish).

### 1.1 Windows

| Concern | Behavior | Severity | Citation / Notes |
|---|---|---|---|
| Asset path `res://addons/neocade_theme/fonts/Inter-Variable.ttf` | Works as expected. PCK packing transparently rewrites to internal pack offsets. `ResourceLoader.load()` finds it. | LOW | Standard Godot behavior. |
| Font loading (Variable .ttf / FontFile / FontVariation) | Reliable. `wght`/`opsz` axes work. Subpixel positioning AUTO. | LOW | Verified. |
| StyleBoxFlat `corner_radius=4 + AA=true` | Renders as authored. | LOW | GL Compatibility identical to other desktop targets. |
| Default renderer | D3D12 is default in Godot 4.6 for new projects ([Godot 4.6 release notes](https://godotengine.org/releases/4.6/)) but project.godot explicitly forces `gl_compatibility` — overrides the default. Safe. | LOW | Project locks renderer; D3D12 default doesn't apply. |
| Bundle size / distribution | No platform-specific limits at scale we care about. | LOW | |
| HiDPI scaling | `Allow HiDPI` project setting must be ON for sharp scaling on 4K Windows. NeoCade should document this in README. | MED | [Multiple resolutions docs](https://docs.godotengine.org/en/stable/tutorials/rendering/multiple_resolutions.html) — "Allow hiDPI ... only effective on Windows and macOS." |
| `DisplayServer.screen_get_scale()` | Returns 1.0 always on Windows (proposal #2661 still open). Don't auto-scale theme based on it. | MED | [Godot proposal 2661](https://github.com/godotengine/godot-proposals/issues/2661) (already covered in PITFALLS 3.2). |
| Known 4.6 bugs affecting theme | None tracked. | — | |

### 1.2 macOS

| Concern | Behavior | Severity | Citation / Notes |
|---|---|---|---|
| Asset paths | Identical to Windows. | LOW | |
| Font loading | Reliable. Retina scaling clean. | LOW | |
| StyleBoxFlat | Identical to Windows; uses Metal driver under the hood for GL Compat (Apple Silicon: GL on top of Metal via translation layer). | LOW | |
| `DisplayServer.screen_get_scale()` | **Implemented** — returns actual scale (1.0/2.0). Use this if dynamic scale is ever needed. | LOW | [Multiple resolutions docs](https://docs.godotengine.org/en/stable/tutorials/rendering/multiple_resolutions.html). |
| HiDPI / Retina | `Allow HiDPI` ON → automatically sharp on Retina. | LOW | Same as Windows. |
| Bundle size / signing | macOS App Store gating requires notarization; not a theme concern. | LOW | |
| Known 4.6 bugs affecting theme | None tracked specifically for theme rendering. Metal driver tracker (issue #95919) is for the Forward+/Mobile RenderingDevice path — irrelevant to GL Compat themes. | — | [Godot issue #95919](https://github.com/godotengine/godot/issues/95919). |

### 1.3 Linux

| Concern | Behavior | Severity | Citation / Notes |
|---|---|---|---|
| Asset paths | Identical to Windows / macOS. | LOW | |
| Font loading | Reliable (no system font dependency since we bundle). | LOW | |
| StyleBoxFlat | Identical to other desktop targets. | LOW | |
| `DisplayServer.screen_get_scale()` | Implemented on Wayland; X11 returns 1.0. | LOW | [Multiple resolutions docs](https://docs.godotengine.org/en/stable/tutorials/rendering/multiple_resolutions.html). |
| HiDPI scaling | `Allow HiDPI` setting is **ignored** on Linux — must use `content_scale_factor` manually. | MED | [Multiple resolutions docs](https://docs.godotengine.org/en/stable/tutorials/rendering/multiple_resolutions.html). |
| Distribution | Flatpak/AppImage/.deb wrappers don't affect theme. | LOW | |
| Known 4.6 bugs affecting theme | None. | — | |

### 1.4 iOS — App Store distribution

| Concern | Behavior | Severity | Citation / Notes |
|---|---|---|---|
| Asset path `res://addons/neocade_theme/...` | Works. PCK is embedded inside the iOS `.ipa` bundle. Resource remapping applies (`.tres` may become `.tres.remap` — use `ResourceLoader.load()` not `FileAccess`). | LOW | [Exporting packs/patches/mods](https://docs.godotengine.org/en/stable/tutorials/export/exporting_pcks.html) — "you may find the same file with a `.remap` suffix added in its place ... use ResourceLoader.load()." |
| Font loading (Variable .ttf via FontFile) | Reliable. iOS supports embedded `.ttf` files without restriction (no plist registration needed when loaded via Godot's FontFile rather than UIKit). | LOW | iOS supports TTF/OTF natively. Godot's FontFile is engine-internal — bypasses iOS's font registry entirely. |
| StyleBoxFlat | **Renders identically** under GL Compatibility on iOS (translation layer over Metal). All AA / corner-radius / shadow behavior matches desktop. | LOW | GL Compat behavior is consistent across all platforms — that's the renderer's purpose. |
| **Renderer choice — DO NOT use Mobile renderer on iOS in 4.6** | Issue #116090 confirmed: iPhone SE 2nd gen Metal API validation fails on Mobile renderer ("MTLSamplerBorderColorTransparentBlack is not supported"). Open, **release blocker for 4.7**, regression vs 4.5.1. | **HIGH** if anyone considers switching | [Godot issue #116090](https://github.com/godotengine/godot/issues/116090). NeoCade is locked on GL Compat — unaffected. |
| Variable font `wght`/`opsz` axes | Supported. Inter Variable renders correctly across all targets. (Per Option D FINAL, only Inter is bundled in v1.) | LOW | Godot's FontVariation is engine-side — works wherever FontFile loads. |
| App Store font licensing | **OFL 1.1 PASSES App Store review.** Per Option D (FINAL 2026-05-04), v1 bundles Inter Variable Roman ONLY — OFL 1.1, App Store + Play Store + Web embedding all legal. | LOW | [SIL OFL FAQ](https://openfontlicense.org/ofl-faq/), [Inter LICENSE.txt](https://github.com/rsms/inter/blob/master/LICENSE.txt). |
| Non-Latin script rendering on all 6 targets | Per Option D, NeoCade ships only Inter (Latin/Cyrillic/Greek/Vietnamese). Non-Latin (Arabic/Hebrew/Indic/Thai/CJK) rendered via Godot's `Font.allow_system_fallback=true` (Godot 4.x default). Functional on Win/Mac/Linux/Android/iOS via OS system fonts. **Web export caveat:** browser/WASM system-font access is more limited; non-Latin glyph rendering depends on browser+OS combo. Phase 10 cross-platform validation must screenshot CJK/Arabic test labels on all 6 targets to confirm. | LOW for desktop+mobile; MED for Web | Godot Font docs; verify in Phase 1 RES-01 + Phase 10 EXPORT-02. |
| App Store license-disclosure requirement | **Must include** the OFL.txt copyright + license notice in the app bundle — typically inside Settings → About → Acknowledgements, OR in an in-app Credits screen. NeoCade ships `OFL.txt` next to fonts; consuming app must surface it. NeoCade README must instruct this. | MED (consumer responsibility, not theme bug) | [openfontlicense.org/how-to-use-ofl-fonts/](https://openfontlicense.org/how-to-use-ofl-fonts/). |
| iOS Simulator export | **NOT supported** in Godot 4.6 (issue [#102149](https://github.com/godotengine/godot/issues/102149)). Must test on real iOS device or Apple Silicon Mac running iOS app natively. | MED | Documented Godot 4.6 limitation. |
| Bundle size constraints | App Store: 4 GB max IPA, 200 MB OTA download cap. Theme contributes ~2 MB — irrelevant. | LOW | Apple guidelines. |
| Safe area / notch / Dynamic Island | Theme cannot solve this — it's per-scene layout via MarginContainer + `DisplayServer.get_display_safe_area()`. NeoCade's mobile showcase scene MUST demonstrate the pattern. | MED | [Godot forum: Safe area for notch/Dynamic Island](https://forum.godotengine.org/t/simple-way-to-manage-the-notch-on-ios-and-android-mobile-devices/86971). |
| VoiceOver integration | Godot 4.5+ has AccessKit screen reader support. AccessKit integration on iOS is partial as of 4.6 — works on macOS/Windows reliably, iOS coverage incomplete. NeoCade should set `accessibility_name` on showcase Controls; full VoiceOver QA deferred to v1.x. | MED (accessibility regression risk) | [Godot 4.5 release](https://godotengine.org/releases/4.5/), [godot-accessibility-demo](https://github.com/aefren/godot-accessibility-demo). |
| C# (.NET) on iOS | Experimental as of 4.2; some limitations. Theme is pure resources — no C# code in theme — so unaffected. | LOW | [Godot iOS export docs](https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_ios.html). |

### 1.5 Android — Play Store distribution

| Concern | Behavior | Severity | Citation / Notes |
|---|---|---|---|
| Asset paths | Same as iOS — PCK packed in APK / AAB. ResourceLoader works. `res://` paths consistent. | LOW | |
| Font loading | Reliable. Variable fonts work. | LOW | |
| StyleBoxFlat | Renders identically under GL Compat (OpenGL ES 3 path). | LOW | |
| **Renderer choice — STAY ON GL Compat** | Issue #111729 (open as of Oct 2025): switching from `gl_compatibility` to `mobile` renderer **reduces** Play Store supported device count, not the inverse the user might expect. Mobile-renderer fallback to Compatibility is documented but **does not function on Android** per the issue. | HIGH risk if anyone proposes switching | [Godot issue #111729](https://github.com/godotengine/godot/issues/111729). NeoCade is locked on GL Compat — unaffected. Also: issue [#68048](https://github.com/godotengine/godot/issues/68048) — Vulkan crashed devices without Vulkan support in older 4.0 betas; resolved but illustrates the risk. |
| Density buckets (mdpi/hdpi/xhdpi/xxhdpi/xxxhdpi) | **Godot does NOT use Android density qualifiers.** Resources are not bucketed at the Godot layer. Density variation is handled at runtime via `content_scale_factor` (manual or computed from `DisplayServer.screen_get_scale()`). Variable / SVG / 2x-imported fonts and icons handle DPI without per-bucket files. | MED — DON'T try to ship 4 mobile theme variants by density | [Android export docs](https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_android.html) — "Godot only requires high-resolution icons (for `xxxhdpi` density screens) and will automatically generate lower-resolution variants" applies to APP icon, NOT theme assets. |
| `DisplayServer.screen_get_scale()` on Android | **Implemented** — returns device's scaling factor. Use this if NeoCade ever ships a runtime auto-scaler (NOT v1). | LOW | [Multiple resolutions docs](https://docs.godotengine.org/en/stable/tutorials/rendering/multiple_resolutions.html). |
| Material 3 / Material You integration | Godot does NOT integrate with Android's Material Theme system. NeoCade is application-level theme — does not pull system dynamic colors. v2 could explore via Android JNI plugin; out of scope for v1. | LOW | NeoCade's brief is "loose Material 3 reference" not "native Material" — no integration needed. |
| TalkBack accessibility | Works partially. Same status as iOS VoiceOver — AccessKit integration is incomplete for Android (community reports of coverage gaps). | MED | [Godot 4.5 release](https://godotengine.org/releases/4.5/), [godot forum: Android accessibility question](https://forum.godotengine.org/t/question-about-accessibility-on-android/122578). |
| APK / AAB size | Default APK ships ARMv7 + ARMv8 native libs (~30-50MB engine baseline). Theme contributes ~2 MB. Keep the architecture set as default for Play Store compatibility. | LOW | [Android export docs](https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_android.html). |
| Play Store font licensing | OFL 1.1 + Apache 2.0 both pass Play Store. Same compliance as iOS. | LOW | [openfontlicense.org/how-to-use-ofl-fonts](https://openfontlicense.org/how-to-use-ofl-fonts/). |
| Tap target enforcement | Play Store does NOT enforce 48dp programmatically. WCAG 2.5.5 (Target Size, Level AAA) recommends 44×44 CSS px; Material 3 recommends 48dp. NeoCade must self-enforce via theme constants. | MED | Material 3 specs. |
| Storage Access Framework (SAF) — new in 4.6 | Allows files outside res:// via system file picker. Theme is res:// only — irrelevant. | LOW | [Godot 4.6 release notes](https://godotengine.org/releases/4.6/). |
| Known 4.6 Android bugs affecting theme | "Series of crashes affecting devices with certain Mali and Adreno mobile GPUs" fixed in 4.6 (release notes). No theme-specific bugs tracked. | LOW | [Godot 4.6 release notes](https://godotengine.org/releases/4.6/). |

### 1.6 Web / Browser — HIGHEST-RISK target

| Concern | Behavior | Severity | Citation / Notes |
|---|---|---|---|
| Renderer | **Only WebGL 2.0 (GL Compatibility)** is supported on Web. Forward+ and Mobile renderers do NOT work on Web. NeoCade's renderer choice is FORCED for this target. | LOW (we already chose GL Compat) | [Web export docs](https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_web.html) — "Godot 4 can only target WebGL 2.0 (using the Compatibility rendering method). Forward+/Mobile are not supported on the web platform." |
| Asset path `res://addons/neocade_theme/...` | Works **inside the PCK** which is embedded next to the `.html` file as `<game>.pck` served via HTTP. **CRITICAL pitfall**: `.pck` is a single file — anything not packed into it is unreachable. The "Filters to export non-resources" in Project → Export must include `*.ttf` explicitly OR fonts must be referenced via FontFile resources (which package them automatically). | HIGH | [Custom fonts not in HTML5](https://forum.godotengine.org/t/why-do-custom-fonts-not-show-up-on-html5-export-but-work-when-testing-with-the-built-in-webserver/15456) — confirmed solution: `*.ttf` in export filter. |
| Font loading: FontFile vs SystemFont | **SystemFont is BROKEN on Web.** No system fonts exist in browser sandbox; SystemFont silently falls back. **MUST use FontFile** with bundled `.ttf` referenced via `uid://` to survive PCK remap. NeoCade architecture already specifies this (STACK.md "no SystemFont"); reinforce. | HIGH | [Custom fonts replaced in web export](https://forum.godotengine.org/t/custom-fonts-are-replaced-in-web-export/59371) — "I was telling Godot to look for an installed font on my OS instead of looking for a font file in the game files." |
| Unicode / non-Latin glyphs | Issue #78921 (open since 4.1, status as of 4.6 unclear): even with `allow_system_fonts` set, certain Unicode characters fail to render in Web. Workaround: bundle Noto Sans and chain it as FontFile fallback (`default_font.fallbacks`). | MED | [Godot issue #78921](https://github.com/godotengine/godot/issues/78921). NeoCade already does this. |
| Theme `.tres` loading on Web | Works. `.tres` is plain text inside the PCK. ResourceLoader resolves paths transparently. | LOW | Verified: theme resources load identically to other resource types on Web. |
| Theme parity (visual diff vs desktop) | StyleBoxFlat AA / corner-radius / shadow render **the same** under WebGL 2.0 as desktop GL Compat — same shader path. Expect visual identity within ~1-2% pixel diff (subpixel font rasterization can vary slightly per browser font hinting). | LOW | GL Compat single-renderer property; the only divergence is browser font rasterization. |
| Browser support — Chromium-based | Best support. Chrome/Edge/Brave/Opera all reliable. | LOW | [Web export docs](https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_web.html). |
| Browser support — Firefox | Reliable. | LOW | Same. |
| **Browser support — Safari (macOS + iOS)** | **High risk**. Documented issues: Safari has had WebGL 2 issues that other browsers don't (per Godot docs); audio in iOS Safari/Chrome was crashing on 4.5 dev5 with HTML5 export when audio is used (issue [#107390](https://github.com/godotengine/godot/issues/107390) — verify fix in 4.6). NeoCade theme has NO audio so the audio crash doesn't apply, BUT visual rendering on iOS Safari is the second-highest-risk validation point after font loading. | **HIGH** | [Web export docs](https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_web.html), [Godot issue #107390](https://github.com/godotengine/godot/issues/107390), [Godot issue #37931](https://github.com/godotengine/godot/issues/37931) (older but pattern is consistent). |
| MIME type for `.wasm` | Must be `application/wasm`. Itch.io and Cloudflare Pages handle this automatically; custom hosting needs server config. NeoCade docs should mention this for consumers. | MED (consumer config) | [Web export docs](https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_web.html). |
| CORS / SharedArrayBuffer | Multi-threaded exports require `Cross-Origin-Embedder-Policy: require-corp` + `Cross-Origin-Opener-Policy: same-origin`. Single-threaded (default since 4.3) does NOT need these. NeoCade theme has no threading — single-threaded export is fine. | LOW | [Web export docs](https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_web.html). |
| Bundle size constraints | Cloudflare Pages: 25 MB hard cap per file (issue [#70672](https://github.com/godotengine/godot/issues/70672)); GitHub Pages: 100 MB per file but on-the-fly gzip only on HTML/CSS/JS/WASM, NOT PCK. Itch.io: large but uploads can be slow. Theme contributes ~2 MB; total Web export with NeoCade is ~25-40 MB depending on engine modules. | MED (consumer hosting choice) | [Godot issue #70672](https://github.com/godotengine/godot/issues/70672), [jacobfilipp.com web export size guide](https://jacobfilipp.com/godot/). |
| Export-template subset | Godot 4.x web export is monolithic — no documented subset for theme-using apps. The wasm + PCK is what it is. | — | [Web export docs](https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_web.html). |
| `DisplayServer.screen_get_scale()` on Web | Implemented — returns `window.devicePixelRatio`. Works. | LOW | [Multiple resolutions docs](https://docs.godotengine.org/en/stable/tutorials/rendering/multiple_resolutions.html). |
| Mobile browsers (iOS Safari / Chrome on Android) | Higher risk than desktop browsers. Same WebGL 2 issues plus device performance concerns. v1 acceptance for Web mobile = "renders, no crash, no missing glyphs"; pixel-parity not required. | HIGH | Multi-source community reports. |

### Cross-Platform Risk Heatmap (consolidated)

| Risk | Affects | Severity | Mitigation |
|---|---|---|---|
| iOS Mobile-renderer regression (#116090) | iOS only | HIGH if not on GL Compat | Already on GL Compat — neutralized |
| Android Mobile-renderer reduces device support (#111729) | Android only | HIGH if not on GL Compat | Already on GL Compat — neutralized |
| Web font loading via SystemFont silently fails | Web | HIGH | Use FontFile + bundle `.ttf` + add `*.ttf` to non-resource export filter |
| Web Unicode/CJK gaps in HTML5 (#78921) | Web | MED | Noto Sans fallback chain bundled |
| iOS Safari WebGL 2 quirks | Web on iOS | HIGH | v1 acceptance: "no crash + no tofu"; pixel parity not required |
| Cloudflare 25MB cap on PCK / WASM | Web hosting | MED (consumer concern) | Document in README; gzip recommendation |
| Resource path break on PCK remap (`.tres.remap`) | iOS / Android / Web | HIGH if hand-coded paths | Use `uid://` in `.tres` ext_resource; never construct paths via string concatenation |
| AccessKit / VoiceOver / TalkBack incomplete on iOS/Android | iOS / Android | MED | v1 sets `accessibility_name`; full screen-reader QA deferred to v1.x |
| `DisplayServer.screen_get_scale()` returns 1.0 on Windows/X11 | Win/Linux X11 | MED | Don't auto-scale theme; ship at base scale 1.0; document `content_scale_factor` |
| `Allow HiDPI` ignored on Linux | Linux | MED | Document `content_scale_factor` recommendation |

---

## (2) Web/Browser Deep-Dive (Highest-Risk Target)

The user flagged Web as highest-risk. Here is concrete, opinionated guidance.

### 2.1 What works on Web

- `res://addons/neocade_theme/neocade_theme.tres` loads via `ResourceLoader.load()` — same as desktop. The PCK abstracts the file system.
- Bundled `.ttf` fonts (Inter Variable, Noto Sans, Outfit) load via FontFile + FontVariation chain.
- StyleBoxFlat AA, corner-radius, shadow, border render under WebGL 2.0 (GL Compat) **identically** to desktop GL Compat — pixel-for-pixel within 1-2% on identical browsers.
- `.tres` text format (recommended) loads fine; binary-on-export setting is OFF (project default) — keep it OFF.

### 2.2 What breaks on Web (and the fix)

| Failure | Why | Fix |
|---|---|---|
| Custom fonts replaced with system default | SystemFont resource was used instead of FontFile, OR `.ttf` not in PCK | (a) Always use FontFile pointing at bundled `.ttf`. (b) Add `*.ttf` to Project → Export → Resources → "Filters to export non-resources." (c) Alternatively, reference the .ttf via a saved FontFile `.tres` — Godot will pull the binary in automatically. NeoCade approach: **wrap each font in a FontFile `.tres` resource** under `addons/neocade_theme/fonts/` and reference those .tres files from `neocade_theme.tres` via `uid://`. |
| Unicode glyphs missing | Inter doesn't cover; Web has no system font fallback; AccessibilityFontFile fallback chain not configured | Wire `default_font.fallbacks = [NotoSans-Variable, ...]` in `neocade_theme.tres`. Also bundle Noto Sans Arabic / Hebrew / Devanagari subsets if target audience needs them (NeoCade v1 ships only Latin/Cyrillic/Greek/Vietnamese via Noto Sans Variable). |
| iOS Safari rendering anomalies | Safari WebGL 2 is the most-buggy browser per Godot docs | Document expected limitations in README. v1 acceptance criterion: "renders, all controls visible, all fonts load, no crash" — pixel parity not required for iOS Safari. |
| `.pck` doesn't load (404 or wrong MIME) | Hosting misconfiguration | Document required hosting config in README: `application/wasm` MIME for `.wasm`, `application/octet-stream` for `.pck`, gzip recommended. |
| Game freezes after a few minutes on iOS | Audio crash regression #107390 (4.5 dev5 → potentially 4.6) | Theme has zero audio. Showcase scene must also have zero audio. Re-verify on Godot 4.6.2+. |

### 2.3 Recommended Web export settings (for NeoCade showcase + for consuming projects)

Authored at `Project → Export → Web → Default`:

```
Custom Template: <leave empty>
Variant: Regular (single-threaded — no SharedArrayBuffer required)
Texture Format: BPTC, ETC2, S3TC checked (covers all browser GPU paths)
Resources Filters to export non-resources: *.ttf,*.otf,*.svg
Resources Filters to exclude: <none>
Encryption: <none>

Progressive Web App: <up to consumer>
Custom HTML Shell: <NeoCade ships none — just the default>
```

### 2.4 Recommended hosting config (excerpt for README)

```
# itch.io / Cloudflare Pages / GitHub Pages: works out of box for single-threaded export
# Custom server (nginx, etc.) — set headers:
location ~ \.wasm$ { add_header Content-Type application/wasm; }
location ~ \.pck$ { add_header Content-Type application/octet-stream; }

# If you ever upgrade to multi-threaded (NOT v1):
add_header Cross-Origin-Embedder-Policy require-corp;
add_header Cross-Origin-Opener-Policy same-origin;
```

### 2.5 Web QA acceptance criteria (v1)

Per browser × per device, validate:

1. Showcase scene loads to interactive state in <30s on broadband (subjective bar; we don't optimize wasm size, just verify load).
2. Every font renders the correct glyph for "Hello 한 中 ä Ω Ж Α" (Latin + CJK partial + Latin Extended + Cyrillic + Greek). CJK is expected to fall through to user's system font OR show tofu — NeoCade does not bundle CJK in v1, that's the documented limitation.
3. All 35 Control classes render in showcase without console errors.
4. Theme toggle (NeoCade ↔ Godot default) works.
5. No "Failed to load resource" warnings in browser console for theme assets.

---

## (3) Mobile Variant Specifics — Concrete Numbers for `neocade_mobile_theme.tres`

Concrete authoring values for the mobile variant. Numbers that "Material 3 says" cite m3.material.io; numbers that "iOS HIG says" cite developer.apple.com; numbers chosen as a compromise are flagged.

### 3.1 Tap-target sizing (Buttons, CheckBox, OptionButton, MenuButton, IconButton, etc.)

iOS HIG: **44×44 pt minimum** ([developer.apple.com/design/human-interface-guidelines/accessibility](https://developer.apple.com/design/human-interface-guidelines/accessibility)).
Material 3: **48×48 dp minimum** ([m3.material.io accessibility](https://m3.material.io/foundations/accessibility/accessible-design/overview)).
Material 3: **8 dp minimum separation between adjacent interactive elements**.

Godot is pixel-based; at base scale 1.0, with proper `content_scale_factor`/`content_scale_size` settings, **48 Godot pixels ≈ 48 dp on Android ≈ 48 pt on iOS** — the larger of the two minimums.

| Element | Desktop primary | Mobile variant | Why |
|---|---|---|---|
| Button minimum height | 32px | **48px** | Material 3 48dp minimum (also covers iOS 44pt with comfortable margin) |
| Button vertical padding (`content_margin_top/bottom`) | 6px | **12px** | Visual breathing room at larger height |
| Button horizontal padding (`content_margin_left/right`) | 12px | **16px** | Material 3 button horizontal padding spec |
| CheckBox / radio hit-area minimum | 24×24px (icon 16px + 4px padding) | **48×48px** (icon 24px + 12px padding) | Same tap-target rule applies — even though the visible glyph is small, the hit-area (CheckBox's `panel` stylebox + `h_separation`) must be 48×48 |
| OptionButton / MenuButton minimum height | 32px | **48px** | Same as Button |
| IconButton (square, icon-only) | 32×32px | **48×48px** | Same |
| LineEdit minimum height | 28px | **48px** | Single-line text input must be 48dp tap target |
| TextEdit minimum height | 60px | **80px** (multi-line; vertical scrolls) | Visual indication of multi-line; matches mobile UX expectations |
| SpinBox minimum height | 28px | **48px** | LineEdit-derived; same minimum |
| HSlider minimum thickness (`scroll` stylebox + grabber hit area) | 16px | **48px** (8px track + 40px transparent grabber-hitbox padding) | Slider thumb must be reachable by thumb; 48px hit area achieved via transparent expand_margin on grabber, not visual track |
| HScrollBar / VScrollBar visible thickness | 8px | **8px** (visible) + **20px** (transparent expand_margin for hit-area) | Scrollbars must be touch-grabbable but not visually huge; expand_margin is the hit-target trick |
| ScrollContainer scrollbar h_separation | 0 | **0** (transparent expand_margin already buys touch room) | |
| Tab minimum height (TabBar / TabContainer) | 32px | **48px** | Same Material 3 48dp rule for tabs |
| PopupMenu item minimum height | 28px | **48px** | Material 3: list-item minimum 48dp |
| Tree row minimum height (`v_separation` + content) | 22px | **48px** (item_margin top/bottom = 12px each + 24px item) | Touch-friendly list rows |
| ItemList row minimum height | 28px | **48px** | Same as Tree |
| Window close button hit area | 24×24px | **44×44px** | iOS 44pt minimum (smaller than 48dp because window chrome is allowed slightly tighter; cap at 44pt either way) |
| Separation between adjacent buttons (HBoxContainer `separation`) | 8px | **12px** (or 16px in roomy contexts) | Material 3 8dp minimum between targets, but mobile favors 12dp+ for accidental-tap protection |

### 3.2 Type scale on mobile (font_size deltas vs desktop)

iOS HIG: body 17pt, footnote 13pt, caption 12pt, title-3 20pt, title-2 22pt, title-1 28pt, large-title 34pt.
Material 3: body-medium 14sp, body-large 16sp, label-large 14sp, title-medium 16sp, title-large 22sp, headline-medium 28sp, headline-large 32sp ([m3.material.io type-scale-tokens](https://m3.material.io/styles/typography/type-scale-tokens)).

Reconciled to single mobile scale, balanced between iOS HIG and Material 3:

| Role | Desktop primary | Mobile variant | Reasoning |
|---|---|---|---|
| `display` | 36px | **40px** | Hero text — slightly larger for mobile impact |
| `h1` (HeaderLarge) | 24px | **28px** | Material 3 headline-medium 28sp |
| `h2` (HeaderMedium) | 20px | **24px** | One step up from desktop H2 |
| `h3` (HeaderSmall) | 16px (bold) | **20px** (semibold) | Card titles need more presence on touch |
| `body` (default) | 14px | **16px** | Material 3 body-large 16sp; iOS body 17pt-ish; 16px is the safe middle |
| `body.sm` (caption) | 12px | **14px** | iOS caption 12pt → 14px on mobile to honor accessibility minimum 14sp |
| `label` (button/tab) | 11px | **14px** | Material 3 label-large 14sp |
| `code` (mono) | 13px | **14px** | Slight bump for legibility on smaller mobile screens |

Mobile variant uses Inter **at heavier weights at body sizes** because lower DPI smartphones with shorter viewing distances benefit from slightly stronger stems. Specifically:

- `body` weight: **400 (regular) on mobile** (same as desktop) — iOS rendering is sharp enough; over-bolding looks cheap.
- `button label` weight: **500 (medium)** on both desktop and mobile; mobile keeps medium since it's at 14px now (label-large).
- `h1/h2/h3` weights: **600 (semibold) on mobile** for h2/h3, **700 (bold) on mobile** for h1.

### 3.3 Spacing scale on mobile

| Token | Desktop | Mobile | Use |
|---|---|---|---|
| `space.0` | 0 | 0 | Reset |
| `space.1` | 2 | 4 | Tightest |
| `space.2` | 4 | 6 | Tight |
| `space.3` | 6 | 8 | Compact |
| `space.4` | 8 | **12** | Default (most h_separation/v_separation on mobile) |
| `space.5` | 12 | **16** | Comfortable (popup item padding, button-to-button gap) |
| `space.6` | 16 | **20** | Roomy (panel inner padding) |
| `space.7` | 24 | **28** | Section gaps |
| `space.8` | 32 | **40** | Major gaps |

Mobile spacing is roughly **+50% on space.4 and above** — consistent with both Material 3 and iOS HIG mobile padding patterns where touch density is reduced vs desktop.

### 3.4 Corner radius — KEEP IDENTICAL across desktop and mobile

Reasoning: corner radius is a **brand identity property**, not a touch-density property. Mobile uses the same `radius.sm = 4px`, `radius.md = 6px`, etc. Visual identity stays unified across platforms — that's the point of having one NeoCade brand.

Exception: **`radius.full` (pill) buttons** look better on mobile at slightly larger radii in absolute terms because buttons are taller — but since `radius.full = 9999px` clamps to half the height, this is automatic.

### 3.5 Density-buckets question — answered: ONE mobile theme, NOT four

**Recommendation: ship ONE `neocade_mobile_theme.tres`.**

Rationale:

- Godot does NOT use Android density qualifiers (mdpi/hdpi/xhdpi/xxhdpi) for theme resources. There is no `res://theme-mdpi/` lookup mechanism.
- Density variation is handled at runtime via `content_scale_factor` (computed from `DisplayServer.screen_get_scale()` or set in Project → Display → Window → Stretch).
- Godot's stretch modes (`canvas_items` recommended for mobile; see [Multiple resolutions](https://docs.godotengine.org/en/stable/tutorials/rendering/multiple_resolutions.html)) automatically scale the entire UI proportionally — meaning a 48px button at base scale = 48dp at mdpi, 72dp at xhdpi, 96dp at xxhdpi WHEN STRETCH IS APPLIED. The author writes one set of dp-equivalent pixel values; Godot scales.
- Apps targeting both phone and tablet use **Stretch Aspect = "expand"** + **Stretch Mode = "canvas_items"** + **Project base resolution = 1280×720** (or 720×1280 portrait) — verified from the Multiple Resolutions doc as the recommended mobile setup.

What the consuming game must do:
- Set `Display → Window → Stretch → Mode = canvas_items` and `Aspect = expand` in `project.godot`.
- Set `Display → Window → Size → Override` (Window Width/Height Override) to a base resolution that matches design intent (1280×720 typical mobile landscape; 720×1280 portrait; 1920×1080 if targeting flagship-only).
- Apply `neocade_mobile_theme.tres` instead of `neocade_theme.tres` on mobile builds.

NeoCade README must clearly document this stretch-mode requirement.

### 3.6 Mobile-specific Control overrides (deltas from desktop primary)

Beyond raw constants/font sizes, certain Controls need different stylistic treatment on mobile:

| Control | Mobile delta | Why |
|---|---|---|
| `ScrollBar` | Reduce visible thickness to **6-8px**; add **20px transparent expand_margin** for hit area; auto-hide via Godot built-in `mouse_default_cursor_shape` + scroll-on-touch behavior (handled by ScrollContainer not theme) | Mobile UX favors thin chrome scrollbars + touch swipe for primary scroll |
| `Tooltip` | DISABLE or set very long `gui/timers/tooltip_delay_sec` — tooltips on touch are useless | Theme can't disable tooltips, but the variant should set tooltip font_size to 16px so when they DO appear (long-press in some configurations) they're readable |
| `PopupMenu` | Increase item height to 48px (already in 3.1); increase indent for submenu chevron; increase gutter_compact = 8 → 12 | Material 3 list density |
| `Window` (modal dialogs) | Increase `title_height` to 56px (Material 3 mobile app-bar height); increase `close_h_offset/close_v_offset` so the X is reachable | Mobile window chrome conventions |
| `Tree` | Increase `inner_item_margin_top/bottom = 8px each`; `item_margin = 12`; arrow icons 28px instead of 16px | Touch-friendly tree expansion |
| `ItemList` | `v_separation = 8`; `icon_margin = 12` | Same |
| `LineEdit` | Increase `caret_width = 2 → 3`; selection color same as desktop; consider larger `clear` icon (24px) | Caret visibility on mobile DPI |
| `Slider grabber` | Visual size 24px (vs desktop 16px); transparent hit-area expand_margin to 48px total | Touch-grabbable thumb |
| `TabBar` | `tab_separation = 4 → 8`; consider scroll-when-overflow (Godot built-in) | Material 3 tab pattern |

### 3.7 What to NOT do for mobile variant

| Anti-pattern | Why |
|---|---|
| Make the mobile variant look "iOS-native" or "Material-native" | NeoCade is unified arcade identity — the mobile variant is touch-tuned, not platform-skinned |
| Ship 4 density-bucket variants (xxhdpi.tres, xhdpi.tres, etc.) | Godot doesn't use Android resource qualifiers; one variant + Godot stretch is correct |
| Add iOS-specific safe-area logic into the theme | Safe areas are layout-time (MarginContainer + DisplayServer.get_display_safe_area()) not theme-time |
| Auto-detect platform at theme load and swap colors | Theme is data, not behavior; consuming app picks which `.tres` to load |
| Add haptic patterns | Theme is purely visual; haptics are application-level (and require platform GDExtension on iOS) |
| Add animations (tab swipe, button bounce) | Theme has no animation primitives; out of scope |
| Make the mobile variant darker/brighter than desktop | Same color tokens; same WCAG contrast; same brand identity |
| Increase corner radii to "look more iOS-native" (huge pill shapes) | Conflicts with arcade identity; keep radius scale identical |

### 3.8 iOS HIG / Material 3 specifics worth adopting beyond tap targets

| Spec | Origin | Adopt? | How |
|---|---|---|---|
| 44pt minimum tap target | iOS HIG | YES (already 48px = bigger) | Theme constants |
| 48dp minimum tap target | Material 3 | YES (used as binding minimum) | Theme constants |
| 8dp minimum element separation | Material 3 | YES (we go to 12px on mobile) | `h_separation` / `v_separation` |
| 16sp body-large / 14sp body-medium | Material 3 | YES (16px body on mobile) | font_size on Label / RichTextLabel |
| iOS 17pt body | iOS HIG | Compromise — 16px (between 14 desktop and iOS 17pt) | Same |
| Material 3 state-layer overlays (8% hover, 12% pressed) | Material 3 | YES — already adopted in ARCHITECTURE.md | StyleBox color computation |
| Material 3 dynamic color / Material You | Material 3 | NO — not v1 | Out of scope; theme is unified arcade identity |
| iOS Dynamic Type (system text-size scaling) | iOS HIG | NO — partial | Godot 4.6 cannot dynamically respond to iOS text-size preference at theme level. v2 may add a "user font_size scale" multiplier. |
| iOS focus indicators (system-level) | iOS HIG | PARTIAL | Theme provides focus stylebox; OS-level focus is handled by AccessKit (incomplete on iOS as of 4.6) |
| Material 3 adaptive contrast / increased contrast mode | Material 3 | NO — v2 | OS-level adaptive contrast is not surfaced through Godot's theme system |
| iOS safe areas / notch / Dynamic Island | iOS HIG | THEME-IRRELEVANT | Layout concern, handled per-scene via MarginContainer + safe-area API |
| Android navigation bar / status bar tint | Android Material | THEME-IRRELEVANT | Set in project.godot android_export, not theme |
| VoiceOver / TalkBack labels | iOS HIG / Material | YES (showcase only in v1) | Set `accessibility_name` on every showcase Control; theme itself can't add labels |

---

## (4) Token-Sharing Strategy — `@tool` Generator from Single `TokenSet.gd`

### 4.1 The verified facts

1. Godot's `Theme` class **does not support `.tres`-to-`.tres` inheritance**. There is no "extends" or "fallback_theme" property. Verified at [docs.godotengine.org/en/stable/classes/class_theme.html](https://docs.godotengine.org/en/stable/classes/class_theme.html).
2. Runtime composition exists: `Theme.merge_with(other)` and `Theme.copy_from(other)`. Both modify a Theme **in memory only**; the `.tres` file is not changed unless re-saved.
3. Theme **type variations** (`Theme.set_type_variation(name, base)`) provide pseudo-inheritance WITHIN a single theme — but cannot share across two `.tres` files at design time.
4. The proven pattern for "two themes from one source of truth" is **a `@tool` generator script** that programmatically constructs both Theme resources and saves them to `.tres`. Either custom-written or via `ThemeGen` (Inspiaaa, MIT, Asset Library #3299).

### 4.2 Recommended pattern — custom `@tool` script (lowest dependency)

Ship the generator at `addons/neocade_theme/_dev/generate_themes.gd`. The leading underscore + `_dev/` folder signals "not loaded at runtime". The generator script is `@tool`-marked and runs on demand from the editor (Tools menu, or by attaching to a temporary Node).

Code-shape sketch:

```gdscript
@tool
extends RefCounted
class_name NeoCadeThemeGenerator

# === SOURCE OF TRUTH: tokens shared by both themes ===

const COLOR_SURFACE_BASE      := Color("#1A1410")   # Boardwalk Sunset palette
const COLOR_SURFACE_CONTAINER := Color("#2C2218")
const COLOR_SURFACE_HIGH      := Color("#3A2C20")
const COLOR_SURFACE_HIGHEST   := Color("#4A3828")
const COLOR_OUTLINE           := Color("#5C4632")
const COLOR_ON_SURFACE        := Color("#FBF1E4")
const COLOR_ON_VARIANT        := Color("#D9C7B0")
const COLOR_PRIMARY           := Color("#FFB347")
const COLOR_DANGER            := Color("#E84855")
const COLOR_SUCCESS           := Color("#9CD168")
const COLOR_FOCUS             := Color("#FFB347")

const RADIUS_SM := 4
const RADIUS_MD := 6
const RADIUS_LG := 8

# === DESKTOP-vs-MOBILE deltas ===

class Variant:
    var name: String
    var save_path: String
    var btn_min_height: int
    var btn_pad_v: int
    var btn_pad_h: int
    var body_size: int
    var caption_size: int
    var space_default: int
    var space_roomy: int

const DESKTOP := Variant.new()
DESKTOP.name = "desktop"
DESKTOP.save_path = "res://addons/neocade_theme/neocade_theme.tres"
DESKTOP.btn_min_height = 32
DESKTOP.btn_pad_v = 6
DESKTOP.btn_pad_h = 12
DESKTOP.body_size = 14
DESKTOP.caption_size = 12
DESKTOP.space_default = 8
DESKTOP.space_roomy = 16

const MOBILE := Variant.new()
MOBILE.name = "mobile"
MOBILE.save_path = "res://addons/neocade_theme/neocade_mobile_theme.tres"
MOBILE.btn_min_height = 48
MOBILE.btn_pad_v = 12
MOBILE.btn_pad_h = 16
MOBILE.body_size = 16
MOBILE.caption_size = 14
MOBILE.space_default = 12
MOBILE.space_roomy = 20

# === GENERATION ENTRYPOINT ===

func generate_all() -> void:
    _generate_one(DESKTOP)
    _generate_one(MOBILE)

func _generate_one(v: Variant) -> void:
    var theme := Theme.new()
    
    # Default font (shared across desktop and mobile)
    var inter := load("res://addons/neocade_theme/fonts/Inter-VariableFont_opsz,wght.ttf") as FontFile
    var noto := load("res://addons/neocade_theme/fonts/NotoSans-VariableFont_wdth,wght.ttf") as FontFile
    inter.fallbacks = [noto]  # Cascade non-Latin
    theme.default_font = inter
    theme.default_font_size = v.body_size
    
    # Button base (5 states each)
    _author_button(theme, v)
    _author_lineedit(theme, v)
    _author_panel(theme, v)
    _author_popupmenu(theme, v)
    _author_tree(theme, v)
    # ... (all 35 Control classes)
    
    # Type variations (PrimaryButton, DangerButton, GhostButton, IconButton...)
    _author_type_variations(theme, v)
    
    # Save
    var err := ResourceSaver.save(theme, v.save_path)
    if err != OK:
        push_error("Failed to save %s: %s" % [v.save_path, err])
    else:
        print("Saved ", v.save_path)

func _author_button(theme: Theme, v: Variant) -> void:
    # Normal stylebox
    var sb_normal := StyleBoxFlat.new()
    sb_normal.bg_color = COLOR_SURFACE_HIGH
    sb_normal.set_corner_radius_all(RADIUS_MD)
    sb_normal.anti_aliasing = true
    sb_normal.anti_aliasing_size = 1.0
    sb_normal.content_margin_top = v.btn_pad_v
    sb_normal.content_margin_bottom = v.btn_pad_v
    sb_normal.content_margin_left = v.btn_pad_h
    sb_normal.content_margin_right = v.btn_pad_h
    theme.set_stylebox("normal", "Button", sb_normal)
    
    # ... hover, pressed, disabled, focus, hover_pressed
    # Each state derives from normal via documented Material 3 state-layer transforms
    
    # Constants
    theme.set_constant("h_separation", "Button", v.space_default / 2)
    theme.set_constant("outline_size", "Button", 0)

# ... and so on for every Control class
```

Author once. Run: `Tools → Run Script` with a tiny driver:

```gdscript
@tool
extends EditorScript

func _run() -> void:
    NeoCadeThemeGenerator.new().generate_all()
```

Both `neocade_theme.tres` and `neocade_mobile_theme.tres` are regenerated. Source of truth lives in the script. Drift is impossible because both `.tres` files are computed from the same constants — change a color in `COLOR_PRIMARY`, regenerate, both files update identically.

### 4.3 Alternative: ThemeGen (Inspiaaa, Asset Library)

If we want a more feature-rich generator with built-in stylebox helpers, [ThemeGen](https://github.com/Inspiaaa/ThemeGen) (MIT, Asset Library #3299) provides:
- `define_style(name, properties_dict)` — dict-based authoring (concise)
- `inherit(base_stylebox, overrides)` — true stylebox-level inheritance for hover-from-normal patterns
- `define_variant_style(name, base_name, style)` — type-variation authoring
- **Multiple variants from one `define_theme()` method** — each variant calls `setup_*()` to set differing token values, then the same `define_theme()` runs against those tokens and saves to a different output path

Trade-off: extra dependency (~200 lines of GDScript in the consumer's `addons/`); needs to be in NeoCade's `_dev/` folder, not bundled at runtime distribution. NeoCade's user pays no runtime cost because `_dev/` is not part of the shipped addon.

**Recommendation:** Author NeoCade's generator from scratch (fewer transitive deps), but model the `setup_desktop()` / `setup_mobile()` / shared `define_theme()` separation on ThemeGen's pattern. ~600 lines of `@tool` GDScript, single file, MIT-licensable.

### 4.4 What gets committed

```
addons/neocade_theme/
├── neocade_theme.tres                  ← committed final artifact (generated)
├── neocade_mobile_theme.tres           ← committed final artifact (generated)
├── fonts/...                           ← committed static assets
├── icons/...                           ← committed static assets
├── _dev/
│   ├── .gdignore                       ← Godot doesn't try to import contents
│   ├── generate_themes.gd              ← @tool script — source of truth
│   ├── generate_driver.gd              ← @tool EditorScript launcher
│   └── README.md                       ← "Run Tools → Run Script with generate_driver.gd to regenerate"
└── README.md                           ← user-facing
```

Why ship the generator alongside (in `_dev/`)?
- Documentation: future contributors see how the `.tres` was authored.
- Reproducibility: anyone proposing a token change can regenerate cleanly.
- Diff hygiene: PR shows token change in `.gd` AND visible delta in `.tres` — trivially reviewable.
- `.gdignore` ensures Godot doesn't index the folder in ResourceLoader (shipped users don't see it via res://).

### 4.5 What about Godot's built-in pseudo-inheritance via `theme_type_variation`?

Type variations work WITHIN a single Theme resource — they cannot share data across two `.tres` files. They are still useful for our PrimaryButton/DangerButton/GhostButton variations within `neocade_theme.tres` (and identically within `neocade_mobile_theme.tres`). The generator outputs both files with parallel type-variation registrations.

Pitfall (already documented in PITFALLS.md 1.2): Godot 4.6 type variations have known font-inheritance bugs (issue #80731). The generator must **explicitly set fonts on every type variation** rather than relying on inheritance. The script-based approach does this naturally — it's just code.

---

## (5) License Compliance Across All Targets

### 5.1 Verified facts

| Font | License | Verified Source | iOS App Store? | Play Store? | Web bundle? | Reserved Name? |
|---|---|---|---|---|---|---|
| Inter v4.1 | OFL 1.1 | [Inter LICENSE.txt](https://github.com/rsms/inter/blob/master/LICENSE.txt) | YES | YES | YES | YES — "Inter" is reserved; do not rename or modify the binary while keeping the name |
| Noto Sans (Variable) | OFL 1.1 | [notofonts.github.io](https://notofonts.github.io/) + [Wikipedia](https://en.wikipedia.org/wiki/Noto_fonts) | YES | YES | YES | YES — "Noto Sans" reserved; same rules |
| Outfit (Variable) | OFL 1.1 | [Google Fonts: Outfit](https://fonts.google.com/specimen/Outfit) | YES | YES | YES | YES — "Outfit" reserved |
| JetBrains Mono | OFL 1.1 | [jetbrains.com/lp/mono](https://www.jetbrains.com/lp/mono/) | YES | YES | YES | YES — "JetBrains Mono" reserved |

### 5.2 OFL 1.1 specific obligations (from [SIL OFL FAQ](https://openfontlicense.org/ofl-faq/))

For every bundled OFL font, NeoCade MUST:

1. **Include the copyright statement** for that font (e.g., "Copyright (c) 2016-2024 The Inter Project Authors").
2. **Include the license notice** (the "License" sentence directing users to the OFL text).
3. **Include the OFL license text** (1.1 official text). Single shared `OFL.txt` covers all OFL-licensed fonts as long as all four copyright holders are listed.
4. **NOT use reserved font names** in derivative works. Don't rename `Inter-VariableFont*.ttf` to `NeoCade-Variable.ttf`.
5. **NOT modify** the binary in a way that retains the reserved name.

NeoCade compliance:

```
addons/neocade_theme/fonts/
├── Inter-VariableFont_opsz,wght.ttf
├── Inter-Italic-VariableFont_opsz,wght.ttf
├── NotoSans-VariableFont_wdth,wght.ttf
├── Outfit-VariableFont_wght.ttf
├── JetBrainsMono-VariableFont_wght.ttf  (optional v1.x)
└── OFL.txt   ← combined: Inter copyright + Noto copyright + Outfit copyright + JetBrains Mono copyright + ONE shared OFL 1.1 text
```

### 5.3 iOS App Store specifics

- **OFL 1.1 PASSES App Store review.** Confirmed at [openfontlicense.org/how-to-use-ofl-fonts](https://openfontlicense.org/how-to-use-ofl-fonts/): "you can drop an OFL font into any project, embed it in your website, bundle it in an app".
- **Apache 2.0 PASSES** as well (Material Symbols, Roboto, etc.). NeoCade isn't using these but they're an alternative pool.
- **Apple's expectation**: license disclosure visible in the app. Standard mechanism: in-app About / Acknowledgements / Credits screen, or Settings.bundle entry. NeoCade's README must instruct consuming apps how to surface the OFL text.
- **What about copyrighted fonts (e.g., Helvetica, SF Pro)?** Apple licenses SF Pro for use *in iOS apps* but NOT for redistribution as part of an Asset Library theme. NeoCade explicitly does NOT use SF Pro, Helvetica, or any proprietary Apple-licensed font.

### 5.4 Play Store specifics

- **Same OFL / Apache rules.** Google Fonts itself is OFL/Apache distribution; Google Play has no additional font-redistribution restrictions.
- **No font-license-specific Play Store policy beyond standard "redistribute legally" requirement.**

### 5.5 Web "OFL Reserved Font Name" implications when font is served from .pck

The OFL Reserved Name clause restricts *renaming the font name as presented to users*. When the font is loaded inside Godot via FontFile, the binary's internal `name` table still contains "Inter" — this is correct and required.

When the `.pck` is fetched by a browser, the font binary is not "exposed as a downloadable font asset" — it's only consumed internally by Godot for rasterization. This is functionally equivalent to bundling Inter inside an iOS app or Android APK — the OFL allows it explicitly.

**No additional Web-specific compliance steps beyond the standard OFL.txt + copyright bundling.**

### 5.6 Combined `OFL.txt` template (for `addons/neocade_theme/fonts/OFL.txt`)

```
Bundled fonts in this directory are licensed under the SIL Open Font License,
Version 1.1.

----- Inter -----
Copyright (c) 2016-2024 The Inter Project Authors (https://github.com/rsms/inter)

----- Noto Sans -----
Copyright 2022 The Noto Project Authors (https://github.com/notofonts/latin-greek-cyrillic)

----- Outfit -----
Copyright 2021 The Outfit Project Authors (https://github.com/Outfitio/Outfit-Fonts)

----- JetBrains Mono (if bundled) -----
Copyright 2020 The JetBrains Mono Project Authors (https://github.com/JetBrains/JetBrainsMono)

This Font Software is licensed under the SIL Open Font License, Version 1.1.
This license is copied below, and is also available with a FAQ at:
http://scripts.sil.org/OFL

[full SIL OFL 1.1 text follows — pasted from https://openfontlicense.org/open-font-license-official-text/]
```

The README must direct consumers: "If you ship NeoCade Theme inside your iOS / Android / Web game, surface this OFL.txt content in your app's About / Credits / Acknowledgements section."

---

## (6) Cross-Platform Testing Strategy

### 6.1 Validation order (cheapest → most expensive)

1. **Linux** — primary dev target; cheapest validation.
2. **Windows** — secondary dev target; identical results expected (GL Compat).
3. **macOS** — physical Mac required; identical results expected.
4. **Web (desktop browsers)** — Chrome/Firefox/Edge on Linux; Safari on Mac. CI capable.
5. **Web (mobile browsers)** — iOS Safari + Chrome Android. Requires real devices OR BrowserStack. Manual.
6. **Android** — at least 3 physical devices: low-end xhdpi (~Pixel 3a / Galaxy A series), mid-range xxhdpi, high-end xxxhdpi. Manual.
7. **iOS** — physical iPhone (one budget = SE 3rd gen, one flagship), one iPad. Mac + Xcode + paid Apple Developer account required. Manual.

### 6.2 What CI can cover

| Test | CI? | How |
|---|---|---|
| Linux desktop screenshot diff | YES | GitHub Actions Ubuntu + Xvfb virtual display + Godot CLI + Godot MCP screenshot tools (PITFALLS 8.2 — `--headless` does NOT work for screenshots; need virtual display) |
| Windows desktop screenshot diff | YES | GitHub Actions windows-latest + Godot CLI |
| macOS desktop screenshot diff | YES | GitHub Actions macos-latest + Godot CLI (uses Mac runner allotment, costlier) |
| Web export build | YES | Godot CLI export to web; verify `.wasm + .pck` exist + size sanity |
| Web rendering on Chromium headless | YES | Puppeteer / Playwright loads localhost-served export, verifies canvas non-blank, no console errors |
| Android export build | YES | Godot CLI + Android SDK; verify APK builds, size sanity |
| iOS export build | NO | Requires Mac + Xcode + signed dev certificate; not feasible on hosted CI without paid Apple Developer config |
| Android device rendering | NO | Requires real device or expensive cloud (Firebase Test Lab) |
| iOS device rendering | NO | Requires real device + Mac |
| Visual diff vs design mockup | PARTIAL | Compare rendered screenshot to approved mockup HTML; pixel-diff with ~5% tolerance; CI can do this on Linux/Win/Mac/Web |
| WCAG contrast verification | YES | Static analysis of token colors via Python script (already used in ARCHITECTURE.md) |
| Font tofu detection | YES | Render multi-script test string, scan for `�` REPLACEMENT CHARACTER, fail on detection |
| Tap-target audit (mobile variant) | YES | Static analysis of `.tres` mobile variant — every interactive Control must have minimum size ≥ 48px |

### 6.3 What requires real devices

- iOS Safari Web export rendering.
- iOS native (.ipa) rendering — Metal driver behavior, system DPI.
- Android Chrome Web rendering — touch input, vendor-specific GPU drivers.
- Android native (.apk) rendering on Mali / Adreno / PowerVR GPU variants.
- Touch interaction validation (long-press, swipe, gesture) — no good emulator substitute.
- Notch / Dynamic Island / safe-area validation — emulators don't accurately reproduce.

### 6.4 MCP-driven screenshot QA (per target)

Godot MCP supports editor-side and running-game screenshots. Per-target capabilities:

| Target | Godot MCP screenshot? | How | Notes |
|---|---|---|---|
| Linux desktop | YES (running game) | `mcp__godot__*` from PROJECT.md — GoPeak's screenshot tool | Standard |
| Windows desktop | YES | Same | Standard |
| macOS desktop | YES | Same | Standard |
| Web (browser) | NO direct MCP | Browser automation (Playwright) renders the canvas; MCP is for the Godot editor + native runtime, NOT browser DOM | Use Playwright + canvas screenshot |
| Android device | PARTIAL — Godot 4.6 added scrcpy integration ([release notes](https://godotengine.org/releases/4.6/)) for mirroring Android devices to desktop during testing. Theoretical MCP integration: tunnel screenshots via scrcpy → desktop → MCP capture | Manual scrcpy + desktop screenshot tools |
| iOS device | NO direct MCP. Xcode DevTools provides device screenshot capability | Manual Xcode screenshot |

**Recommendation:** v1 acceptance is "screenshot at least once on every target". Automate where possible (Linux/Win/Mac/Web headless via Playwright); manual for Android/iOS in v1; consider scrcpy + custom MCP tooling for Android automation in v1.x.

### 6.5 v1 acceptance criteria per target

| Target | v1 acceptance criterion |
|---|---|
| Windows desktop (1080p, 1440p, 4K) | Pixel-diff vs approved mockup ≤ 5%; no missing fonts; no console errors; theme toggle works |
| macOS desktop (Retina included) | Same |
| Linux desktop (1080p, 1440p) | Same |
| Web (Chromium desktop) | Pixel-diff ≤ 5%; load time < 30s on broadband; no missing glyphs in test string; theme toggle works; no console errors |
| Web (Firefox desktop) | Same |
| Web (Safari macOS) | Renders, all controls visible, all fonts load, theme toggle works (pixel parity NOT required — known Safari quirks tolerated) |
| Web (Chrome Android) | Renders, scrollable, no crash, all controls visible (pixel parity NOT required) |
| Web (Safari iOS) | Renders, scrollable, no crash, all controls visible (pixel parity NOT required) |
| Android phone (xhdpi) | Mobile theme applied; tap targets all ≥ 48dp; renders without crash; theme toggle works |
| Android phone (xxhdpi/xxxhdpi) | Same |
| Android tablet | Mobile theme applied (or desktop theme — consumer choice); renders; tap targets honored |
| iOS iPhone (one budget, one flagship) | Mobile theme applied; tap targets all ≥ 44pt; renders without crash; safe-area-respecting showcase scene; theme toggle works |
| iOS iPad | Mobile theme applied (or desktop); renders; theme toggle works |

### 6.6 Plausible v1 test matrix

| Target | Device / Browser | Renderer | Theme | Tester |
|---|---|---|---|---|
| Linux | Dev machine | GL Compat | Desktop | CI + manual sanity |
| Windows | Dev machine | GL Compat | Desktop | CI + manual sanity |
| macOS | Borrowed Mac (or M1/M2 if owned) | GL Compat | Desktop | Manual |
| Web (desktop) | Chrome + Firefox + Safari (Mac) | WebGL 2 | Desktop | CI (headless Chromium) + manual Safari |
| Web (mobile) | iOS Safari (iPhone 12+) + Chrome on Pixel | WebGL 2 | Mobile | Manual |
| Android | Pixel 4a (xhdpi), Pixel 7 (xxhdpi) | GL Compat | Mobile | Manual |
| iOS | iPhone SE 3rd gen, iPhone 14 Pro | GL Compat | Mobile | Manual |

Estimated v1 QA time: 4-6 hours of physical-device testing across 5 devices, plus CI validation runs.

---

## (7) Risks Specifically Introduced by Mobile Variant + Cross-Platform Expansion

These are NEW risks vs the original desktop-only scope. Each gets a mitigation plan.

### Risk 1: Token-drift between the two `.tres` files (HIGH)

**What goes wrong:** Designer tweaks `neocade_theme.tres` directly via Theme editor; mobile variant doesn't get the tweak; over time the two themes diverge in palette/radius/typography unintentionally; brand identity fractures.

**Why it happens:** Two files = two places to edit. Without enforcement, drift is the default.

**Mitigation:**
- **Both `.tres` files are GENERATED, not hand-edited.** PR review enforces: changes to `.tres` files alone (without a corresponding `_dev/generate_themes.gd` change) are rejected.
- Add a CI check: regenerate the `.tres` files from the script; if the generated output differs from the committed `.tres`, fail the build. Forces the source-of-truth discipline.
- README's CONTRIBUTING.md explicitly documents the "edit script, regenerate, commit both" workflow.

### Risk 2: Web export silent font fallback to system default (HIGH)

**What goes wrong:** Theme uses FontFile referencing bundled `.ttf`, but the `.ttf` is not actually packaged in the PCK due to misconfigured export filter. On Web, font silently falls back to browser default. Theme looks broken but not error-flagged.

**Why it happens:** Godot's `.tres` exporter is conservative; doesn't always include "non-resource" files like raw `.ttf`. FontFile resource auto-includes the `.ttf` IF the FontFile is a saved resource referencing the binary; can fail if reference is broken.

**Mitigation:**
- Wrap each bundled font in a saved `FontFile.tres` (e.g., `addons/neocade_theme/fonts/Inter.tres`) — Godot's exporter pulls the binary in automatically.
- Reference the FontFile.tres from `neocade_theme.tres` via `uid://`, not bare path.
- Add `*.ttf` to Project → Export → Resources → "Filters to export non-resources" defensively (belt-and-braces).
- CI test: load the exported Web build via Playwright, render a sample text in NeoCade's body font, OCR the resulting canvas for the test glyph — confirm it's Inter (specific serifs/letterforms recognizable) and not browser-default sans.
- Manual smoke test on every release: deploy showcase to itch.io, verify font visually.

### Risk 3: iOS / Android touch target violations slip through (HIGH)

**What goes wrong:** A constant overlooked in mobile variant — say `Tree.v_separation = 4` instead of 8 — produces 32px-tall tree rows. Below 48dp tap target. Accessibility regression. App Store / Play Store don't enforce; users just struggle.

**Why it happens:** Mobile variant has dozens of constants to audit; manual audit misses one.

**Mitigation:**
- CI static-analysis script (Python + .tres parser): enumerate every Control class with interactive role; for each, compute the minimum bounding-box height implied by the styleboxes + content margins + constants; fail if any < 48 (mobile variant) or < 44 (desktop tolerable for some controls but flagged).
- Showcase scene visually shows tap-target overlay (red 48px box overlay on every interactive Control) toggleable via debug button — manual auditor can verify visually.
- Document the audit in v1 release notes.

### Risk 4: Cross-platform export-template mismatch (MED)

**What goes wrong:** Consumer's project has Godot 4.6.0 export templates installed, but their build environment uses 4.6.2 templates (or vice-versa). NeoCade theme renders subtly differently due to engine version drift.

**Why it happens:** Godot export templates are versioned with the editor; mismatches cause visual regressions.

**Mitigation:**
- README explicitly documents: "Recommended Godot version: 4.6.2 or later. Lower minor versions may have rendering regressions in font subpixel positioning and StyleBoxFlat AA — re-tested per version."
- v1 ships with a tested-version matrix — say "verified on 4.6.0, 4.6.1, 4.6.2".
- Asset Library description includes "Tested on Godot 4.6.x"; users with 4.5 or 4.7 are warned.

### Risk 5: Non-Latin glyph tofu on Web (especially mobile Web) (MED)

**What goes wrong:** Showcase scene includes "한국어 中文 Русский العربية" test text. NeoCade bundles Noto Sans Variable (Latin/Cyrillic/Greek/Vietnamese only). CJK and Arabic show as tofu on Web (no system font fallback). On Android, system font fallback rescues; on iOS native, system font fallback rescues; on Web — broken.

**Why it happens:** Web has no system font sandbox. Godot's FontFile fallback chain only includes what we explicitly bundle.

**Mitigation:**
- Document this as a KNOWN LIMITATION in README: "v1 ships Latin/Cyrillic/Greek coverage. For CJK/Arabic/Devanagari/Thai support, override the theme's `default_font.fallbacks` in your project."
- Showcase scene's multi-script test label is intentional — surfaces the limitation visually rather than hiding it. If a consumer needs broader script coverage, the showcase tells them how.
- v1.x roadmap consideration: ship optional `addons/neocade_theme/fonts/extras/` with Noto Sans CJK / Arabic subsets — separate ~10-30MB add-on download.

---

## (8) Recommended Roadmap Phase Additions

The synthesizer/roadmapper must add at least these two phases to the existing roadmap. Each has explicit deliverables.

### Phase: "Cross-Platform Export Validation" (lifted from v1.5 → v1 must-have)

**Position in roadmap:** After implementation Phase 4 (Dialogs/Advanced) and Phase 5 (Showcase/QA — desktop screenshot pass), before v1 release.

**Goal:** Verify NeoCade theme renders correctly + tap targets honored across all 6 export targets.

**Deliverables:**
1. **Per-target export build artifacts** — Windows .exe, macOS .app/.dmg, Linux binary, Web (.html + .pck + .wasm), Android .apk, iOS .ipa — each archived in `releases/v1/`.
2. **Per-target screenshot deck** — minimum 5 screenshots per target (showcase top-bar, button section, input section, lists section, dialog section) at native resolution, archived in `qa/v1/screenshots/<target>/`.
3. **Per-target findings doc** — `qa/v1/CROSS-PLATFORM-VALIDATION.md` — documents what was tested, what worked, what regressions surfaced (if any), what was deferred.
4. **CI workflow** — GitHub Actions config that builds + screenshots Linux/Windows/macOS/Web automatically on every PR; failure = block merge.
5. **Manual-validation checklist** — Android device, iOS device — completed and signed off by user before release.
6. **Release notes** — v1 documents tested-version matrix, known limitations (Web CJK gap, iOS Mobile-renderer regression note though we don't use it, etc.).

**Acceptance:** Every target's screenshot deck visually matches approved mockup within 5% pixel diff (desktop targets; Linux/Win/macOS/Web Chromium); mobile/Web-Safari targets meet "renders, no crash, no missing glyphs" bar.

**Estimated effort:** 8-12 hours including device testing.

### Phase: "Mobile Variant Authoring" (NEW)

**Position in roadmap:** After Phase 1 (Foundation — tokens locked, fonts bundled, mockup approval gate passed). Concurrent with or interleaved with Phase 2-4 desktop authoring — but with explicit gate that mobile variant is regenerated whenever desktop variant changes.

**Goal:** Author the mobile variant alongside desktop, sharing tokens via `@tool` script, with concrete tap-target/typography/spacing deltas.

**Deliverables:**
1. **`addons/neocade_theme/_dev/generate_themes.gd`** — `@tool` script with `generate_all()` → produces both `.tres` files from one source-of-truth.
2. **`addons/neocade_theme/_dev/generate_driver.gd`** — `@tool` EditorScript launcher.
3. **`addons/neocade_theme/_dev/README.md`** — explains the workflow: edit constants in `generate_themes.gd`, run via Tools menu, verify both `.tres` files updated, commit all three.
4. **`neocade_mobile_theme.tres`** — generated final artifact, committed.
5. **Mobile-specific tap-target audit script** — Python/GDScript that validates every interactive Control in mobile variant has minimum 48px hit area.
6. **Updated showcase scene `main.tscn`** — adds a theme-variant toggle button (Desktop / Mobile, distinct from the NeoCade ↔ Godot toggle) so reviewers can see both side-by-side.
7. **`MOBILE-DESIGN-SPEC.md`** in `.planning/` — written specification of every mobile delta vs desktop, citing iOS HIG / Material 3 sources for each value.

**Acceptance:**
- Both `.tres` files build from script with zero hand-edits.
- Tap-target audit passes (every interactive Control ≥ 48px on mobile, ≥ 32px on desktop).
- Mobile variant's body font renders at 16px in the showcase.
- Visual side-by-side comparison of desktop vs mobile shows IDENTICAL color palette, IDENTICAL corner-radius scale, IDENTICAL accent usage — only sizing/spacing/density differs.

**Estimated effort:** 12-18 hours (the variant doubles every Control's authoring scope, but the script-based approach amortizes most of that).

### Phase: "Cross-Platform Hardening Spike" (OPTIONAL — recommended)

**Position in roadmap:** Before v1 release, after Cross-Platform Export Validation.

**Goal:** Buffer time for hard-to-anticipate cross-platform issues that surface only during real-device QA.

**Deliverables:**
- Reactive bug-fix capacity for any Web Safari, iOS Mobile, Android Chrome regressions that show up.
- Fallback documentation if a target proves un-shippable in v1 (e.g., "Safari iOS rendering regression in 4.6.2 — pinned to Godot 4.6.0 for now; re-evaluate in 4.7").

**Estimated effort:** 4-8 hours buffer.

---

## (9) Additions / Corrections to Existing Research Files

This research changes or clarifies prior findings:

### 9.1 Corrections to STACK.md

- **TL;DR Decision 1 (font distribution):** STACK.md says ship Inter Variable + Inter Italic Variable + Noto Sans Variable. CROSS-PLATFORM concurs but adds: also bundle **Outfit Variable** for `H1`/`H2`/marquee headings (per ARCHITECTURE.md decision). Outfit is OFL 1.1 — same compliance posture as Inter/Noto.
- **STACK.md says total bundled font size ~2.3-2.5 MB.** With Outfit added: ~1.85 MB if we drop Inter Italic in v1 (defer to v1.x), or ~2.7 MB if we keep both Inter Italic + Outfit. Recommend defer Inter Italic to v1.x and add Outfit in v1 — shipped size ~1.85 MB.
- **STACK.md mentions `plugin.cfg` is unnecessary.** Concur. Cross-platform doesn't change this.

### 9.2 Corrections to FEATURES.md

- **FEATURES.md AF-5: "Mobile-specific theme variant — deferred."** This is now SUPERSEDED by user constraint update — mobile variant is v1 must-have. Strike from anti-features. CROSS-PLATFORM section 3 provides the concrete authoring spec.
- FEATURES.md "13 type variations" still accurate — both desktop and mobile share the same 13 type-variation NAMES (PrimaryButton, DangerButton, GhostButton, etc.); the values differ across the two `.tres` files but the variation REGISTRY is identical so consuming projects can swap themes without changing scene `theme_type_variation` strings.

### 9.3 Corrections to ARCHITECTURE.md

- ARCHITECTURE.md Section 1 lists 3 palette options (Midnight Marquee, Boardwalk Sunset, Cabinet Chrome). All three palettes apply IDENTICALLY to desktop and mobile variants — palette is brand identity, not platform-specific. CROSS-PLATFORM concurs.
- ARCHITECTURE.md Section 6 mockup strategy doesn't account for mobile mockups. ADD a Step 5b: produce a mobile-specific mockup (one HTML file showing the same Controls at mobile sizes, with tap-target overlays visible) for user approval, in addition to the desktop full-fidelity mockup.

### 9.4 Corrections to PITFALLS.md

- PITFALLS.md Section 3.4 ("Stylebox sizes hard-coded in pixels don't scale with content_scale_factor") gains weight: cross-platform makes this more material. Mobile variant assumes `content_scale_factor` is configured properly by consuming app. README must instruct.
- PITFALLS.md Section 5.1 ("`res://addons/...` font path doesn't survive when consumer copies only the .tres") gets a NEW MITIGATION: use `uid://` references in the .tres for ALL font + icon references — verified survives Web export PCK remap better than bare paths.
- PITFALLS.md Section 6.1 ("Minimal-theme values are tuned for editor scale, not runtime small UI") confirmed even more relevant: NeoCade desktop variant must NOT inherit Minimal Theme's editor-scale numerics; mobile variant especially needs runtime-first sizing.

---

## Sources

### Authoritative Godot 4.6 documentation (HIGH confidence)

- [Godot 4.6 Release notes](https://godotengine.org/releases/4.6/) — Modern editor theme as default, focus stylebox decoupling, Android Mali/Adreno crash fixes, scrcpy integration, D3D12 default on Windows, single-threaded Web export default
- [Web export docs](https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_web.html) — WebGL 2.0 only, Compatibility renderer, Safari issues, MIME types, CORS
- [iOS export docs](https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_ios.html) — Mac + Xcode required, Simulator unsupported (#102149)
- [Android export docs](https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_android.html) — APK structure, density qualifier note (icons only)
- [Multiple resolutions docs](https://docs.godotengine.org/en/stable/tutorials/rendering/multiple_resolutions.html) — content_scale_factor, default_theme_scale, screen_get_scale platform-specific implementation, recommended mobile base resolutions
- [Theme class docs](https://docs.godotengine.org/en/stable/classes/class_theme.html) — `merge_with()`, `copy_from()`, no .tres-to-.tres inheritance
- [Renderers overview](https://docs.godotengine.org/en/stable/tutorials/rendering/renderers.html) — Forward+ vs Mobile vs Compatibility
- [Exporting packs/patches/mods](https://docs.godotengine.org/en/stable/tutorials/export/exporting_pcks.html) — `.remap` suffix behavior, ResourceLoader.load() requirement

### Godot GitHub issues cited

- [#116090 — iOS Metal validation regression in 4.6 Mobile renderer](https://github.com/godotengine/godot/issues/116090) — release blocker for 4.7
- [#111729 — Android: Mobile renderer reduces Play Store device support](https://github.com/godotengine/godot/issues/111729) — open Oct 2025
- [#107390 — iOS Safari/Chrome HTML5 audio crash in 4.5 dev5](https://github.com/godotengine/godot/issues/107390) — verify 4.6 fix
- [#103696 — Godot 4.4 .ttf import hangs on export](https://github.com/godotengine/godot/issues/103696) — fixed in 4.6 lineage
- [#102149 — iOS Simulator export not supported](https://github.com/godotengine/godot/issues/102149)
- [#95919 — Metal rendering driver tracker](https://github.com/godotengine/godot/issues/95919)
- [#87226 — StyleBoxFlat AA only with non-zero corner radius](https://github.com/godotengine/godot/issues/87226)
- [#78921 — HTML5 Unicode missing despite system font fallbacks](https://github.com/godotengine/godot/issues/78921) — open since 4.1
- [#76829 — AccessKit screen reader integration](https://github.com/godotengine/godot/pull/76829)
- [#70672 — HTML5 WASM file > 25MB blocks Cloudflare Pages](https://github.com/godotengine/godot/issues/70672)
- [#68647 — HTML5 export size increased 3.x → 4.0](https://github.com/godotengine/godot/issues/68647)
- [#68048 — Android export uses Vulkan even when gl_compatibility selected (older 4.0 issue, illustrates risk)](https://github.com/godotengine/godot/issues/68048)
- [#37931 — Godot WebGL export Safari issues](https://github.com/godotengine/godot/issues/37931)
- [#23640 — StyleBoxFlat shadow opacity too strong](https://github.com/godotengine/godot/issues/23640)
- [Proposal #2661 — Implement screen_get_scale on Windows/Linux](https://github.com/godotengine/godot-proposals/issues/2661)
- [Proposal #5790 — Off-screen rendering](https://github.com/godotengine/godot-proposals/issues/5790)
- [Proposal #8404 — Built-in UI scaling solution](https://github.com/godotengine/godot-proposals/issues/8404)

### Forum / community sources

- [Custom fonts not in HTML5 export](https://forum.godotengine.org/t/why-do-custom-fonts-not-show-up-on-html5-export-but-work-when-testing-with-the-built-in-webserver/15456) — solution: `*.ttf` in non-resource export filter
- [Custom fonts replaced in web export](https://forum.godotengine.org/t/custom-fonts-are-replaced-in-web-export/59371) — SystemFont vs FontFile root cause
- [Safe area / notch handling](https://forum.godotengine.org/t/simple-way-to-manage-the-notch-on-ios-and-android-mobile-devices/86971) — DisplayServer.get_display_safe_area() pattern
- [Question about accessibility on Android](https://forum.godotengine.org/t/question-about-accessibility-on-android/122578)

### iOS HIG (HIGH confidence — official Apple)

- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- [Accessibility (44pt minimum)](https://developer.apple.com/design/human-interface-guidelines/accessibility)
- [Layout](https://developer.apple.com/design/human-interface-guidelines/layout)
- [Typography](https://developer.apple.com/design/human-interface-guidelines/typography) — body 17pt
- [LogRocket: All accessible touch target sizes](https://blog.logrocket.com/ux-design/all-accessible-touch-target-sizes/) — confirms 44×44pt iOS standard

### Material 3 (HIGH confidence — official Google)

- [Material 3 type-scale tokens](https://m3.material.io/styles/typography/type-scale-tokens) — body-medium 14sp, body-large 16sp
- [Material 3 accessibility / touch targets](https://m3.material.io/foundations/accessibility/accessible-design/overview) — 48dp
- [LearnUI Design: Android typography guidelines](https://www.learnui.design/blog/android-material-design-font-size-guidelines.html) — 14sp body floor
- [Android touch target accessibility](https://support.google.com/accessibility/android/answer/7101858?hl=en) — 48dp recommendation
- [Material Design 2 web touch target docs](https://m2.material.io/develop/web/supporting/touch-target)

### Font licensing (HIGH confidence)

- [SIL OFL official text](https://openfontlicense.org/open-font-license-official-text/)
- [SIL OFL FAQ](https://openfontlicense.org/ofl-faq/) — App Store / Play Store / web bundle legality
- [How to use OFL fonts](https://openfontlicense.org/how-to-use-ofl-fonts/) — copyright + license text bundling requirement
- [Inter LICENSE.txt](https://github.com/rsms/inter/blob/master/LICENSE.txt) — OFL 1.1 confirmed
- [Inter Project on GitHub](https://github.com/rsms/inter) — v4.1 reserved name "Inter"
- [Outfit on Google Fonts](https://fonts.google.com/specimen/Outfit) — OFL 1.1
- [Noto fonts](https://notofonts.github.io/) — OFL 1.1
- [Open Source Font Licenses Guide](https://font-converters.com/licensing/open-source-fonts) — App Store/Play Store applicability

### Token-sharing tooling

- [ThemeGen (Inspiaaa)](https://github.com/Inspiaaa/ThemeGen) — MIT, Asset Library #3299; multi-variant from one source pattern
- [DeepWiki Tool Scripts](https://deepwiki.com/godotengine/godot-docs/8.2-tool-scripts) — `@tool` annotation reference

### Web export specifics (MEDIUM confidence — community-aggregated)

- [How to shrink .pck size in Godot — jacobfilipp.com](https://jacobfilipp.com/godot/) — Web export size optimization
- [How to Minify Godot's Build Size](https://popcar.bearblog.dev/how-to-minify-godots-build-size/)
- [Godot Web Server Configs gist](https://gist.github.com/nisovin/cf9dd74678641fb70902866c79692b17)
- [DeepWiki: Web Platform Export](https://deepwiki.com/godotengine/godot-docs/7.4-web-platform-export)

### Android specifics

- [Android: Support multiple form factors](https://developer.android.com/games/engines/godot/godot-formfactor)
- [Android: Godot renderer options](https://developer.android.com/games/engines/godot/godot-renderers)
- [Android density buckets explained](https://chariotsolutions.com/blog/post/android-density-buckets-work-designers/)

### Cross-cutting

- [Godot 4.5 accessibility / AccessKit announcement](https://godotengine.org/releases/4.5/)
- [Godot accessibility demo (4.6)](https://github.com/aefren/godot-accessibility-demo)

---

*Cross-platform research for: Godot 4.6 NeoCade Theme — desktop primary + mobile variant, all 6 export targets*
*Researched: 2026-05-04*
*Confidence: HIGH on per-target Godot behavior; HIGH on iOS HIG / Material 3 numerics; HIGH on font licensing; MEDIUM on token-sharing strategy implementation; MEDIUM on Web mobile rendering.*
*Theme name throughout: NeoCade. Aesthetic: arcade-warm, NOT cyberpunk. Mobile variant retains unified NeoCade brand identity — only sizing/spacing/density differs from desktop.*
