# sync-design — pull Claude Design bundles into this repo

`bin/sync-design.ps1` downloads the latest export of a Claude Design
project into `./design-import/` so the layout/SCSS/templates can be
re-synced from the canonical design.

## Why a script (and not direct fetch)?

- `claude.ai/design/p/<uuid>` is a private editing URL — agents can't
  fetch it. It needs a session cookie.
- `api.anthropic.com/v1/design/h/<hash>` is the public hash URL you
  get from the **Share / Export** action in Claude Design. This one
  works from anywhere; that's what the script consumes.

## Usage

```powershell
# from repo root
./bin/sync-design.ps1 -Url "https://api.anthropic.com/v1/design/h/XXXXXXXXXXXX?open_file=index.html"
```

After it finishes, `./design-import/personal-page/project/index.html`
plus the supporting `*.jsx` files are the latest design source of
truth. Ask Claude Code to "re-sync the design from `./design-import/`"
and the relevant pieces (hero markup, eyebrow numbers, section grids,
publication card layout) get ported into:

- `_layouts/about.liquid`
- `_includes/header.liquid`, `_includes/footer.liquid`
- `_sass/_navbar.scss`, `_sass/_themes.scss`
- `_news/*.md` (tag frontmatter)
- `_config.yml` (typography/footer flags)

`./design-import/` is gitignored — it's a scratch directory; nothing
gets committed from it directly.
