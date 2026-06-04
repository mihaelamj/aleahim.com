# Aleahim TileDown Migration Runbook

This document describes how to move `aleahim.com` from the current Toucan build
to the TileDown build while preserving existing URLs, redirects, RSS, sitemap,
static assets, and local preview behavior.

The current production path is still Toucan. The TileDown migration source lives
under `TileDown/` and is generated from the existing Toucan `contents/` tree.

## Important Paths

- `contents/`: current Toucan content source
- `TileDown/content/`: generated TileDown content source
- `TileDown/dist/`: generated TileDown site output
- `Scripts/convert_toucan_to_tiledown.py`: Toucan-to-TileDown converter
- `Scripts/check_tiledown_content.py`: converted source checks
- `Scripts/check_tiledown_output.py`: built output checks
- `Scripts/tiledown_site.py`: the only TileDown migration source of truth for
  the production domain and URL

Do not hand-edit `TileDown/content/` for lasting changes. Change the original
Toucan source or the converter, then regenerate.

## Prerequisites

The Makefile defaults to a sibling TileDown engine checkout:

```sh
../TileDown/tile-down
```

If the engine is somewhere else, pass `TILEDOWN_REPO`:

```sh
TILEDOWN_REPO=/path/to/tile-down make tiledown-check
```

If a `tiledown` binary is installed, pass `TILEDOWN`:

```sh
TILEDOWN=tiledown make tiledown-check
```

## One URL Source Of Truth

Production domain settings for the TileDown migration live in one file:

```sh
Scripts/tiledown_site.py
```

That file defines:

```py
SITE_DOMAIN = "aleahim.com"
SITE_URL = f"https://{SITE_DOMAIN}"
```

The converter expands those values into generated files that need production
absolute URLs:

- `TileDown/content/tiledown.yml` `baseURL`
- redirect pages under `TileDown/content/redirects/`
- `TileDown/content/CNAME`
- `TileDown/content/robots.txt`
- production RSS and sitemap output

The generated files will still contain `https://aleahim.com`; that is expected.
The source value should not be duplicated in migration scripts.

## Regenerate TileDown Content

Run:

```sh
make tiledown-content
```

This deletes and recreates `TileDown/content/` from `contents/`.

Use this after changing:

- Toucan content in `contents/`
- migration behavior in `Scripts/convert_toucan_to_tiledown.py`
- site URL settings in `Scripts/tiledown_site.py`

## Check Converted Content

Run:

```sh
make tiledown-content-check
```

This verifies that converted TileDown source preserves critical Toucan metadata,
including page slugs, post slugs, dates, descriptions, draft flags, redirect
targets, static files, analytics config, and the converted iRelay video embed.

## Build TileDown Output

Run:

```sh
make tiledown-build
```

This regenerates `TileDown/content/`, removes `TileDown/dist/`, and builds the
TileDown site into `TileDown/dist/`.

## Run The Full Migration Gate

Before trusting a migration build, run:

```sh
make tiledown-check
```

This is the main safety gate. It performs all content checks, runs `tiledown
doctor --publish --run-generators`, builds the site, then verifies the generated
output.

The output checks currently assert:

- Toucan and TileDown have the same HTML route count
- every Toucan HTML route exists in TileDown output
- TileDown introduces no extra HTML routes
- `CNAME`, `.nojekyll`, `robots.txt`, `rss.xml`, and `sitemap.xml` exist
- CSS, images, OG images, and CV PDFs are published
- generated pages reference no missing local assets
- RSS has one item per published post
- RSS includes full-content `<content:encoded>` blocks
- RSS links use the public production URL
- analytics is injected
- the homepage no longer shows stale hard-coded `Latest:` copy
- the homepage recent-post list starts with the newest post
- the iRelay YouTube iframe renders as a safe embed tile

As of June 4, 2026, this gate passes with:

- 327 converted content checks
- 30 generated output checks
- 46 Toucan HTML routes
- 46 TileDown HTML routes
- 0 missing routes
- 25 preserved blog article slugs

## Preview Locally

Run:

```sh
make tiledown-preview
```

Open:

```text
http://localhost:8098/
```

The preview target does not serve production `baseURL` links. It copies
`TileDown/content/` to `/tmp`, removes `baseURL` only in that temporary copy,
builds into `/tmp/aleahim-tiledown-preview-site`, and serves that directory.

That keeps local CSS and internal links root-relative, for example:

```html
<link rel="stylesheet" href="/styles.css">
```

If port `8098` is busy, use another port:

```sh
TILEDOWN_PREVIEW_PORT=8100 make tiledown-preview
```

## Slug And Traffic Safety Audit

The standard `make tiledown-check` route parity check is the first line of
defense. For a focused slug audit, run:

```sh
python3 - <<'PY'
from pathlib import Path

old = {str(p.relative_to("dist")) for p in Path("dist").rglob("*.html")}
new = {str(p.relative_to("TileDown/dist")) for p in Path("TileDown/dist").rglob("*.html")}

print(f"old html routes: {len(old)}")
print(f"new html routes: {len(new)}")
print(f"missing: {len(old - new)}")
for route in sorted(old - new):
    print("MISSING", route)
print(f"extra: {len(new - old)}")
for route in sorted(new - old):
    print("EXTRA", route)
PY
```

To compare the live production sitemap against TileDown output, run:

```sh
python3 - <<'PY'
from pathlib import Path
from urllib.parse import urlparse
from urllib.request import urlopen
from xml.etree import ElementTree as ET

data = urlopen("https://aleahim.com/sitemap.xml", timeout=15).read()
root = ET.fromstring(data)
ns = {"sm": "http://www.sitemaps.org/schemas/sitemap/0.9"}

live = set()
for loc in root.findall(".//sm:loc", ns):
    path = urlparse(loc.text.strip()).path or "/"
    if path == "/":
        live.add("index.html")
    elif path.endswith("/"):
        live.add(path.strip("/") + "/index.html")
    else:
        live.add(path.strip("/"))

new = {str(p.relative_to("TileDown/dist")) for p in Path("TileDown/dist").rglob("*.html")}

print(f"live sitemap routes: {len(live)}")
print(f"missing from TileDown: {len(live - new)}")
for route in sorted(live - new):
    print("MISSING_LIVE", route)
PY
```

As of June 4, 2026, every live sitemap route exists in the TileDown build.

If there are high-traffic URLs from analytics, put one URL or path per line in
`/tmp/aleahim-top-urls.txt`, then run:

```sh
python3 - <<'PY'
from pathlib import Path
from urllib.parse import urlparse

dist = Path("TileDown/dist")

def output_path(raw):
    parsed = urlparse(raw.strip())
    path = parsed.path if parsed.scheme else raw.strip()
    if not path or path == "/":
        return dist / "index.html"
    if path.endswith("/"):
        return dist / path.strip("/") / "index.html"
    return dist / path.strip("/")

for raw in Path("/tmp/aleahim-top-urls.txt").read_text().splitlines():
    if not raw.strip():
        continue
    path = output_path(raw)
    print(("OK      " if path.exists() else "MISSING ") + raw)
PY
```

Do not cut over while any known traffic URL is missing.

## Production Cutover

GitHub Pages currently serves this repository from the `main` branch root. That
means generated HTML, source files, scripts, and docs coexist at repo root.

Use a branch for the cutover:

```sh
git switch -c migration/deploy-tiledown
```

Run the full gate:

```sh
make tiledown-check
```

Copy the TileDown output over the root generated files:

```sh
rsync -av TileDown/dist/ .
```

Do not use `--delete` for the first cutover copy. The repo root contains source
directories that must be preserved. If a route has intentionally been removed,
delete the old generated path manually after reviewing `git status`.

Verify the publish doctor is clean:

```sh
make tiledown-doctor
```

Doctor checks generated production links, assets, RSS, sitemap, and local URL
references. This is more precise than a blanket text search because some article
prose legitimately mentions localhost examples.

Inspect the generated deployment diff:

```sh
git status --short
git diff --stat
```

Check these files in the root after the copy:

- `index.html`
- `styles.css`
- `rss.xml`
- `sitemap.xml`
- `robots.txt`
- `CNAME`
- `.nojekyll`
- `blog/<slug>/index.html` for the articles with known traffic
- old redirect pages such as `CVBuilder/index.html` and `TokenMiddleware/index.html`

Commit and push the branch, then review the GitHub diff before merging to
`main`.

## Post-Deploy Verification

After GitHub Pages deploys, verify production:

```sh
curl -sI https://aleahim.com/
curl -sI https://aleahim.com/styles.css
curl -s https://aleahim.com/ | rg "Recent posts|cupertino-v1-3-0-platform-filtering"
curl -s https://aleahim.com/ | rg "localhost|127\\.0\\.0\\.1"
curl -s https://aleahim.com/rss.xml | rg "<content:encoded>"
curl -s https://aleahim.com/sitemap.xml | rg "https://aleahim.com/"
```

The localhost check should print nothing.

Spot-check known redirect URLs:

```sh
curl -sI https://aleahim.com/CVBuilder/
curl -sI https://aleahim.com/CoreAnimation3DCube/
curl -sI https://aleahim.com/LoggingMiddleware/
curl -sI https://aleahim.com/TokenMiddleware/
curl -sI https://aleahim.com/TokenMiddeware/
```

Spot-check known article URLs:

```sh
curl -sI https://aleahim.com/blog/c-v-builder/
curl -sI https://aleahim.com/blog/core-animation-3d-cube/
curl -sI https://aleahim.com/blog/extreme-packaging/
curl -sI https://aleahim.com/blog/logging-middleware/
curl -sI https://aleahim.com/blog/token-middleware/
curl -sI https://aleahim.com/blog/cupertino-v1-3-0-platform-filtering/
```

## Rollback

The rollback is a normal Git rollback because GitHub Pages serves committed root
files.

If the TileDown cutover has not been merged, close the branch and keep `main` as
is.

If the TileDown cutover has been merged and production is broken, revert the
merge commit:

```sh
git revert <merge-commit-sha>
git push origin main
```

Then wait for GitHub Pages to redeploy and repeat the post-deploy verification
against the restored Toucan output.

## Ongoing Content Workflow Before Cutover

Until the production cutover, continue authoring posts in the Toucan source
tree:

```text
contents/
```

Then regenerate and verify TileDown:

```sh
make tiledown-check
```

This keeps the migration branch current while Toucan remains production.

## Ongoing Content Workflow After Cutover

After TileDown becomes production, decide whether to keep `contents/` as the
temporary authoring source or move authoring directly to `TileDown/content/`.

If authoring moves directly to TileDown, remove or retire the converter workflow
so there is no confusion about which tree is authoritative.
