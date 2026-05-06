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

  const target = pathToFileURL(path.join(root, "concept-image.html")).href;
  for (const [direction, slug] of CONCEPT_IMAGE_DIRECTIONS) {
    for (const variant of CONCEPT_IMAGE_VARIANTS) {
      const page = await browser.newPage({ viewport: variant.viewport, deviceScaleFactor: 1 });
      const query = new URLSearchParams({
        direction,
        platform: variant.platform,
        raised: String(variant.raised)
      });
      await page.goto(`${target}?${query.toString()}`);
      await waitForImages(page);
      await page.screenshot({ path: path.join(root, "concepts", `${slug}-${variant.name}.png`), fullPage: false });
      await page.close();
    }
  }

  await browser.close();
  console.log("Rendered 15 fixed-layout concept images to concepts/*.png");
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
