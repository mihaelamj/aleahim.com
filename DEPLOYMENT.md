# Deployment Guide for aleahim.com

## Overview

This site is built with **TileDown** (Mihaela's own static site generator) and
deployed to GitHub Pages at https://aleahim.com

GitHub Pages serves committed HTML from the `main` branch, root `/` folder. The
build output must be committed to the repo root.

The site migrated from Toucan to TileDown. Authoring is unchanged (posts live in
`contents/blog/<slug>/index.md`), but the build and deploy now go through
TileDown. The old Toucan commands are gone.

## Deployment Setup

- **Source**: Deploy from a branch
- **Branch**: `main`
- **Folder**: `/` (root)
- **Custom Domain**: aleahim.com (CNAME ships from `TileDown/content/CNAME`)
- **HTTPS**: Enforced

## How the build works

```
contents/                         authored source (markdown + frontmatter + assets)
   │  Scripts/convert_toucan_to_tiledown.py   (make tiledown-content)
   ▼
TileDown/content/                 TileDown source tree (generated, includes CNAME)
   │  tiledown build-site         (make tiledown-build, engine at ../TileDown/tile-down)
   ▼
TileDown/dist/                    full built site
   │  cp -R TileDown/dist/* .
   ▼
repo root                         committed + served by GitHub Pages
```

The TileDown engine is a sibling checkout at `../TileDown/tile-down`. Override the
location with `TILEDOWN_REPO=/path/to/tile-down`.

## Makefile targets

| Target | What it does |
|--------|--------------|
| `tiledown-content` | Convert `contents/` into `TileDown/content` |
| `tiledown-build` | Build `TileDown/dist` from `TileDown/content` |
| `tiledown-doctor` | `tiledown doctor --publish --run-generators` (no content generators declared) |
| `tiledown-check` | content-check + doctor + build + output-check (use this before deploy) |
| `tiledown-preview` | Build a localhost preview and serve it on port 8098 |

## Deploy to Production

### Step 1: Build and verify

```bash
make tiledown-check
```

This regenerates `TileDown/content`, runs the doctor, builds `TileDown/dist`, and
verifies route parity, root deployment files, images, RSS full content,
analytics, and embeds.

### Step 2: Copy the built site to the repo root

```bash
cp -R TileDown/dist/* .
```

`TileDown/dist` includes `CNAME`, so the custom domain is preserved.

### Step 3: Verify the root

```bash
grep -c "localhost" index.html   # must be 0
grep -qx "aleahim.com" CNAME && echo "CNAME OK"   # must print CNAME OK
```

### Step 4: Commit and push

```bash
git add .
git commit -m "deploy: rebuild site with [describe what changed]"
git push origin main
```

GitHub Pages deploys within 30 to 60 seconds.

### Step 5: Verify live

```bash
curl -s -o /dev/null -w "%{http_code}\n" https://aleahim.com/
curl -s https://aleahim.com/ | grep -c "localhost"   # must be 0
```

## Quick Deploy (copy-paste)

```bash
make tiledown-check
cp -R TileDown/dist/* .
grep -c "localhost" index.html   # verify: must be 0
git add .
git commit -m "deploy: rebuild site"
git push origin main
```

## Local Preview

```bash
make tiledown-preview     # serves http://localhost:8098/ (blocking, run in its own terminal)
```

The preview builds from a temporary content copy with `baseURL` removed, so CSS
and internal links are root-relative and work on localhost. For a build-only
check without serving, use `make tiledown-preview-build`.

## New blog posts

Use the `aleahim-new-post` skill (`skills/aleahim-new-post/SKILL.md`), which wraps
this flow with the hero-image step and the pre/post-deploy assertions.

## Troubleshooting

### Site shows localhost URLs in production
- You copied a preview/dev build to root. Rebuild with `make tiledown-check` and
  copy from `TileDown/dist/` only.

### Site shows old content after deployment
- Hard refresh: `Cmd + Shift + R`, or open in a private window.

### Site shows README instead of homepage
- Ensure you ran `cp -R TileDown/dist/* .` and `index.html` exists at the repo root.

### TileDown build fails with a missing engine
- The engine checkout must be at `../TileDown/tile-down` (or set `TILEDOWN_REPO`).

### Swift build fails: "module compiled with Swift X cannot be imported by Swift Y"
- A `.build` was left by a different Swift toolchain (for example a prior `xcrun`
  vs swiftly default). Clean the affected one and rebuild. For the TileDown engine:
  `rm -rf ../TileDown/tile-down/Packages/.build && make tiledown-check`.

## GitHub Pages Settings

https://github.com/mihaelamj/aleahim.com/settings/pages

- **Source**: Deploy from a branch
- **Branch**: main
- **Path**: / (root)
- **Custom domain**: aleahim.com
- **Enforce HTTPS**: Enabled

## DNS Configuration

The custom domain `aleahim.com` is configured with:
- A `CNAME` file in the repo root containing `aleahim.com` (shipped from
  `TileDown/content/CNAME` by the build; do not hand-edit it)
- DNS records (at Namecheap) pointing the apex to GitHub Pages servers

## Legacy: Toucan (removed)

The site previously used Toucan (`toucan generate --target live` to `/tmp/output/`,
then `cp -r /tmp/output/* .`). That path is dead. `toucan.yml`, `config.yml`, and
`site.yml` remain in the tree as historical config but are not used by the live
build. Do not run `make dev`, `make dist`, `make serve`, or `make watch` (the
Toucan targets) for deployment.
