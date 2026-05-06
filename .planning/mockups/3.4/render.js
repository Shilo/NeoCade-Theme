"use strict";

const path = require("path");
const { pathToFileURL } = require("url");

async function loadPlaywright() {
  try {
    return require("playwright");
  } catch (error) {
    const message = [
      "Playwright is not available to this Node process.",
      "Set NODE_PATH to the bundled Codex runtime node_modules path or open the HTML file manually.",
      `Original error: ${error.message}`
    ].join("\n");
    throw new Error(message);
  }
}

const CONCEPT_IMAGE_DIRECTIONS = [
  ["Pulse", "pulse-concept.png"],
  ["Slate", "slate-concept.png"],
  ["Bubble", "bubble-concept.png"],
  ["Daybreak", "daybreak-concept.png"],
  ["Burst", "burst-concept.png"]
];

async function waitForImages(page) {
  await page.waitForLoadState("networkidle");
  await page.evaluate(async () => {
    await Promise.all([...document.images].map((image) => {
      if (image.complete && image.naturalWidth > 0) {
        return Promise.resolve();
      }
      return new Promise((resolve) => {
        image.addEventListener("load", resolve, { once: true });
        image.addEventListener("error", resolve, { once: true });
      });
    }));
  });
}

async function renderConceptImages(playwright, browserPath, root) {
  const browser = await playwright.chromium.launch({
    headless: true,
    executablePath: browserPath
  });

  for (const [direction, fileName] of CONCEPT_IMAGE_DIRECTIONS) {
    const page = await browser.newPage({ viewport: { width: 1280, height: 720 }, deviceScaleFactor: 1 });
    const target = pathToFileURL(path.join(root, "concept-image.html")).href;
    await page.goto(`${target}?direction=${encodeURIComponent(direction)}`);
    await waitForImages(page);
    await page.screenshot({ path: path.join(root, "concepts", fileName), fullPage: false });
    await page.close();
  }

  await browser.close();
  console.log("Rendered fixed-order concept images to concepts/*.png");
}

async function main() {
  const mode = process.argv[2] || "concept";
  const gallery = mode === "finalist" ? "finalist-gallery.html" : "concept-gallery.html";
  const root = __dirname;
  const output = path.join(root, "screenshots", `${mode}-gallery.png`);
  const browserPath = process.env.NEOCADE_BROWSER || "C:\\Program Files (x86)\\Microsoft\\Edge\\Application\\msedge.exe";
  const playwright = await loadPlaywright();
  if (mode === "concept-images") {
    await renderConceptImages(playwright, browserPath, root);
    return;
  }
  const browser = await playwright.chromium.launch({
    headless: true,
    executablePath: browserPath
  });
  const page = await browser.newPage({ viewport: { width: 1440, height: 1400 }, deviceScaleFactor: 1 });
  await page.goto(pathToFileURL(path.join(root, gallery)).href);
  await waitForImages(page);
  await page.screenshot({ path: output, fullPage: true });
  await browser.close();
  console.log(`Rendered ${gallery} to ${output}`);
}

main().catch((error) => {
  console.error(error.message);
  process.exit(1);
});
