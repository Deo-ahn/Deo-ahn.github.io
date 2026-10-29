// Build the downloadable CV from docs/cv.tex (Jake's Resume).
// Usage: node bin/export_cv.cjs [output.pdf] [path/to/tectonic]
// Requires Tectonic; the first build downloads its LaTeX packages and fonts.
const fs = require("node:fs/promises");
const path = require("node:path");
const { execFileSync } = require("node:child_process");

async function main() {
  const root = path.resolve(__dirname, "..");
  const output = path.resolve(root, process.argv[2] ?? "output/pdf/cv.pdf");
  const tectonic = process.argv[3] ?? process.env.TECTONIC_BIN ?? "tectonic";
  const build = path.join(root, "output/pdf/latex");
  await fs.mkdir(build, { recursive: true });
  execFileSync(tectonic, ["--keep-logs", "--outdir", build, path.join(root, "docs/cv.tex")], { stdio: "inherit" });
  await fs.mkdir(path.dirname(output), { recursive: true });
  await fs.copyFile(path.join(build, "cv.pdf"), output);
  console.log(`Rendered CV: ${output}`);
}

main().catch((error) => {
  console.error(error.message);
  process.exitCode = 1;
});
