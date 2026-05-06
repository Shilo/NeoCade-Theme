"use strict";

/* Phase 3.4 Plan 02 mockup renderer
 *
 * Re-execution 2026-05-06b: switched from bundled Codex `playwright` (with full
 * browser download) to local `playwright-core` driving the system Microsoft
 * Edge install — zero browser-download cost, deterministic on the user's box.
 *
 * Modes:
 *   node render.js                  — captures the concept gallery overview
 *   node render.js concept-images   — captures all 15 per-direction PNGs
 *   node render.js finalist         — captures the finalist gallery shell
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
  { name: "mobile-flat", platform: "mobile", raised: false, viewport: { width: 430, height: 932 } },
  { name: "mobile-raised", platform: "mobile", raised: true, viewport: { width: 430, height: 932 } }
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

async function main() {
  const mode = process.argv[2] || "concept";
  const root = __dirname;
  const browserPath = resolveBrowser();
  const playwright = loadPlaywright();

  if (mode === "concept-images") {
    await renderConceptImages(playwright, browserPath, root);
    return;
  }
  await renderGallery(playwright, browserPath, root, mode);
}

main().catch((error) => {
  console.error(error.message || error);
  process.exit(1);
});
