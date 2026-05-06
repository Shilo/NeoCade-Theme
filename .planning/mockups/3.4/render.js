"use strict";

/* Phase 3.4 Plan 02 / Plan 03 mockup renderer
 *
 * Re-execution 2026-05-06b: switched from bundled Codex `playwright` (with full
 * browser download) to local `playwright-core` driving the system Microsoft
 * Edge install — zero browser-download cost, deterministic on the user's box.
 *
 * Modes:
 *   node render.js                  — captures the concept gallery overview
 *   node render.js concept-images   — captures all 15 per-direction PNGs (Plan 02)
 *   node render.js color-overview   — captures src/color-overview.html composite
 *   node render.js greyscale        — captures src/greyscale-check.html composite (D-30)
 *   node render.js finalist         — captures the finalist gallery shell (full page)
 *   node render.js finalist-images  — Plan 03: renders 4-grid + 2 color-override PNGs
 *                                     for the user-selected finalist (Pulse). Outputs
 *                                     to concepts/{finalist}-finalist-{...}.png with
 *                                     the `-finalist-` infix to avoid colliding with
 *                                     Plan 02's Stage 1 PNGs.
 */

const path = require("path");
const { pathToFileURL } = require("url");

function loadPlaywright() {
  try {
    return require("playwright-core");
  } catch (error) {
    throw new Error(
      `playwright-core not available. Run \`npm install --no-save playwright-core\` inside .planning/mockups/3.4 first.\nOriginal: ${error.message}`
    );
  }
}

const CONCEPT_IMAGE_DIRECTIONS = [
  ["Pulse", "pulse"],
  ["Slate", "slate"],
  ["Bubble", "bubble"],
  ["Daybreak", "daybreak"],
  ["Burst", "burst"]
];

const CONCEPT_IMAGE_VARIANTS = [
  { name: "desktop-flat", platform: "desktop", raised: false, viewport: { width: 1280, height: 720 } },
  // Mobile viewport bumped from 932 → 1500 to match the artboard's mobile
  // physical height (Issue 6: M3 / iOS HIG floors push the full control inventory
  // past a single-screen viewport — see .nc-artboard.mobile rule comment).
  { name: "mobile-flat", platform: "mobile", raised: false, viewport: { width: 430, height: 1500 } },
  { name: "mobile-raised", platform: "mobile", raised: true, viewport: { width: 430, height: 1500 } }
];

async function waitForReady(page) {
  await page.waitForLoadState("networkidle").catch(() => {});
  await page.evaluate(async () => {
    if (document.fonts && document.fonts.ready) await document.fonts.ready;
    await Promise.all([...document.images].map((img) => {
      if (img.complete && img.naturalWidth > 0) return Promise.resolve();
      return new Promise((resolve) => {
        img.addEventListener("load", resolve, { once: true });
        img.addEventListener("error", resolve, { once: true });
      });
    }));
    await new Promise((r) => requestAnimationFrame(() => requestAnimationFrame(r)));
  });
}

function resolveBrowser() {
  if (process.env.NEOCADE_BROWSER) return process.env.NEOCADE_BROWSER;
  const candidates = [
    "C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe",
    "C:/Program Files/Microsoft/Edge/Application/msedge.exe",
    "C:/Program Files/Google/Chrome/Application/chrome.exe"
  ];
  const fs = require("fs");
  for (const c of candidates) {
    if (fs.existsSync(c)) return c;
  }
  throw new Error("No Edge or Chrome found. Set NEOCADE_BROWSER to the executable path.");
}

async function renderConceptImages(playwright, browserPath, root) {
  const browser = await playwright.chromium.launch({
    headless: true,
    executablePath: browserPath,
    channel: undefined
  });

  const target = pathToFileURL(path.join(root, "concept-image.html")).href;
  let success = 0;
  for (const [direction, slug] of CONCEPT_IMAGE_DIRECTIONS) {
    for (const variant of CONCEPT_IMAGE_VARIANTS) {
      const context = await browser.newContext({
        viewport: variant.viewport,
        deviceScaleFactor: 2
      });
      const page = await context.newPage();
      const query = new URLSearchParams({
        direction,
        platform: variant.platform,
        raised: String(variant.raised)
      });
      await page.goto(`${target}?${query.toString()}`);
      await waitForReady(page);
      const artboard = await page.locator(".nc-artboard").first();
      const outPath = path.join(root, "concepts", `${slug}-${variant.name}.png`);
      await artboard.screenshot({ path: outPath, omitBackground: false });
      console.log(`  ✓ ${path.relative(root, outPath)}`);
      await context.close();
      success += 1;
    }
  }

  await browser.close();
  console.log(`Rendered ${success} concept PNGs to concepts/`);
}

/* Plan 03 — finalist-images mode.
 *
 * The user-selected finalist (Pulse, per finalist-selection.md gate-closed
 * 2026-05-06) gets the full 4-grid (flat × raised × desktop × mobile) plus
 * two plausible base_color / accent_color override variants on mobile-flat
 * to demonstrate the dynamic NeoCadeTheme @export contract (D-14, D-19).
 *
 * Output filenames use a `-finalist-` infix so Stage 1 PNGs from Plan 02
 * (e.g., concepts/pulse-desktop-flat.png) are NOT overwritten:
 *   concepts/pulse-finalist-desktop-flat.png       (1280×720, raised=false)
 *   concepts/pulse-finalist-mobile-flat.png        (430×1500, raised=false)
 *   concepts/pulse-finalist-desktop-raised.png     (1280×720, raised=true)
 *   concepts/pulse-finalist-mobile-raised.png      (430×1500, raised=true)
 *   concepts/pulse-finalist-override-warm.png      (430×1500, base_color override A)
 *   concepts/pulse-finalist-override-ocean.png     (430×1500, base_color override B)
 *
 * Mobile viewport stays at 430×1500 (Plan 02 Issue 6 — M3-floored content
 * needs more vertical space than 932 to fit a single image without scroll).
 */
const FINALIST_NAME = "Pulse";
const FINALIST_SLUG = "pulse";
const FINALIST_GRID = [
  { name: "desktop-flat",   platform: "desktop", raised: false, viewport: { width: 1280, height: 720 } },
  { name: "mobile-flat",    platform: "mobile",  raised: false, viewport: { width: 430,  height: 1500 } },
  { name: "desktop-raised", platform: "desktop", raised: true,  viewport: { width: 1280, height: 720 } },
  { name: "mobile-raised",  platform: "mobile",  raised: true,  viewport: { width: 430,  height: 1500 } }
];
/* Color-override examples — each pair preserves Pulse's WCAG-AA-or-better
 * contrast (verified against the project's deliberate AA floor) so the
 * override previews remain accessibility-compliant.
 *
 * Override A (warm-amber): #1A1410 base / #FFC857 accent — keeps Pulse's
 *   cabinet personality but swaps the green for a warm amber, simulating a
 *   brand that wants warmth without abandoning Pulse's shape language.
 * Override B (ocean-cyan): #0F1A22 base / #5FE3FF accent — cooler navy
 *   surface with a cool cyan accent, simulating a tool/streamer brand that
 *   wants Pulse's density + sharp 0px corners with a cool palette.
 */
const FINALIST_OVERRIDES = [
  { name: "override-warm",  platform: "mobile",  raised: false, viewport: { width: 430, height: 1500 },
    base: "#1A1410", accent: "#FFC857", label: "Warm amber override" },
  { name: "override-ocean", platform: "mobile",  raised: false, viewport: { width: 430, height: 1500 },
    base: "#0F1A22", accent: "#5FE3FF", label: "Ocean cyan override" }
];

async function renderFinalistImages(playwright, browserPath, root) {
  const browser = await playwright.chromium.launch({
    headless: true,
    executablePath: browserPath,
    channel: undefined
  });

  const target = pathToFileURL(path.join(root, "concept-image.html")).href;
  let success = 0;

  // 4-grid renders (canonical Pulse colors).
  for (const variant of FINALIST_GRID) {
    const context = await browser.newContext({
      viewport: variant.viewport,
      deviceScaleFactor: 2
    });
    const page = await context.newPage();
    const query = new URLSearchParams({
      direction: FINALIST_NAME,
      platform: variant.platform,
      raised: String(variant.raised)
    });
    await page.goto(`${target}?${query.toString()}`);
    await waitForReady(page);
    const artboard = await page.locator(".nc-artboard").first();
    const outPath = path.join(root, "concepts", `${FINALIST_SLUG}-finalist-${variant.name}.png`);
    await artboard.screenshot({ path: outPath, omitBackground: false });
    console.log(`  ✓ ${path.relative(root, outPath)}`);
    await context.close();
    success += 1;
  }

  // Color-override variants (same shape language, different base/accent).
  for (const variant of FINALIST_OVERRIDES) {
    const context = await browser.newContext({
      viewport: variant.viewport,
      deviceScaleFactor: 2
    });
    const page = await context.newPage();
    const query = new URLSearchParams({
      direction: FINALIST_NAME,
      platform: variant.platform,
      raised: String(variant.raised),
      base: variant.base,
      accent: variant.accent
    });
    await page.goto(`${target}?${query.toString()}`);
    await waitForReady(page);
    const artboard = await page.locator(".nc-artboard").first();
    const outPath = path.join(root, "concepts", `${FINALIST_SLUG}-finalist-${variant.name}.png`);
    await artboard.screenshot({ path: outPath, omitBackground: false });
    console.log(`  ✓ ${path.relative(root, outPath)} — ${variant.label}`);
    await context.close();
    success += 1;
  }

  await browser.close();
  console.log(`Rendered ${success} finalist PNGs to concepts/`);
}

async function renderGallery(playwright, browserPath, root, mode) {
  const gallery = mode === "finalist" ? "finalist-gallery.html" : "concept-gallery.html";
  const out = path.join(root, "screenshots", `${mode}-gallery.png`);
  const browser = await playwright.chromium.launch({ headless: true, executablePath: browserPath });
  const context = await browser.newContext({ viewport: { width: 1440, height: 1400 }, deviceScaleFactor: 1 });
  const page = await context.newPage();
  await page.goto(pathToFileURL(path.join(root, gallery)).href);
  await waitForReady(page);
  await page.screenshot({ path: out, fullPage: true });
  await browser.close();
  console.log(`Rendered ${gallery} to ${out}`);
}

async function renderAuditComposite(playwright, browserPath, root, opts) {
  const browser = await playwright.chromium.launch({ headless: true, executablePath: browserPath });
  const context = await browser.newContext({ viewport: opts.viewport, deviceScaleFactor: 1 });
  const page = await context.newPage();
  await page.goto(pathToFileURL(path.join(root, opts.html)).href);
  await waitForReady(page);
  const outPath = path.join(root, opts.out);
  await page.screenshot({ path: outPath, fullPage: true });
  await browser.close();
  console.log(`Rendered ${opts.html} → ${path.relative(root, outPath)}`);
}

async function main() {
  const mode = process.argv[2] || "concept";
  const root = __dirname;
  const browserPath = resolveBrowser();
  const playwright = loadPlaywright();

  if (mode === "concept-images") {
    await renderConceptImages(playwright, browserPath, root);
    return;
  }
  if (mode === "finalist-images") {
    await renderFinalistImages(playwright, browserPath, root);
    return;
  }
  if (mode === "color-overview") {
    await renderAuditComposite(playwright, browserPath, root, {
      html: "src/color-overview.html",
      out: "screenshots/color-overview.png",
      viewport: { width: 1600, height: 900 }
    });
    return;
  }
  if (mode === "greyscale") {
    await renderAuditComposite(playwright, browserPath, root, {
      html: "src/greyscale-check.html",
      out: "screenshots/greyscale-sufficiency-test.png",
      viewport: { width: 1600, height: 900 }
    });
    return;
  }
  await renderGallery(playwright, browserPath, root, mode);
}

main().catch((error) => {
  console.error(error.message || error);
  process.exit(1);
});
