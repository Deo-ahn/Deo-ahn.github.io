// Render the maintained HTML CV with its local fonts, print CSS and clickable links.
const fs = require("node:fs/promises");
const path = require("node:path");
const { pathToFileURL } = require("node:url");
const { chromium } = require("@playwright/test");

async function main() {
  const root = path.resolve(__dirname, "..");
  const output = path.resolve(root, process.argv[2] ?? "output/pdf/cv.pdf");
  const executablePath = process.argv[3];
  await fs.mkdir(path.dirname(output), { recursive: true });
  const browser = await chromium.launch({ headless: true, ...(executablePath ? { executablePath } : {}) });
  try {
    const page = await browser.newPage();
    const errors = [];
    page.on("pageerror", (error) => errors.push(error.message));
    page.on("requestfailed", (request) => errors.push(`${request.url()}: ${request.failure()?.errorText}`));
    await page.goto(pathToFileURL(path.join(root, "docs/CV.html")).href, { waitUntil: "load" });
    await page.emulateMedia({ media: "print" });
    await page.evaluate(() => document.fonts.ready);
    if (errors.length) throw new Error(errors.join("\n"));
    await page.pdf({
      path: output,
      format: "A4",
      preferCSSPageSize: true,
      printBackground: true,
      tagged: true,
      displayHeaderFooter: true,
      headerTemplate: "<div></div>",
      footerTemplate:
        '<div style="font:8px Arial,sans-serif;color:#68717d;width:100%;text-align:right;padding:0 13mm;box-sizing:border-box"><span class="pageNumber"></span> / <span class="totalPages"></span></div>',
    });
    console.log(`Rendered CV: ${output}`);
  } finally {
    await browser.close();
  }
}

main().catch((error) => {
  console.error(error.message);
  process.exitCode = 1;
});
