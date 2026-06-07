# Deployment Guide for aleahim.com

The site is built with the TileDown engine and deployed to GitHub Pages at
https://aleahim.com. GitHub Pages serves committed HTML from the `main` branch,
root folder.

## How it works

```
TileDown/content/   authored source (Markdown posts, images, tiledown.yml)
   │  tiledown build-site   (make tiledown-build, engine at ../TileDown/tile-down)
   ▼
TileDown/dist/      full built site (includes CNAME)
   │  cp -R TileDown/dist/* .
   ▼
repo root           committed and served by GitHub Pages
```

The engine is a sibling checkout at `../TileDown/tile-down`. Override with
`TILEDOWN_REPO=/path/to/tile-down`.

## Makefile targets

| Target | What it does |
|--------|--------------|
| `tiledown-build` | Build `TileDown/dist` from `TileDown/content` |
| `tiledown-doctor` | `tiledown doctor --publish` (engine checks) |
| `tiledown-check` | build + doctor + RSS full-text and localhost guards |
| `tiledown-preview` | Build a localhost preview and serve on port 8098 |

## Deploy to Production

### 1. Build and check

```bash
make tiledown-check
```

Builds `TileDown/dist`, runs the engine doctor, and verifies every RSS `<item>`
carries `<content:encoded>` (the appledevsearch full-text invariant) and that no
localhost URL leaked.

### 2. Copy the built site to the repo root

```bash
cp -R TileDown/dist/* .
```

`TileDown/dist` includes `CNAME`, so the custom domain is preserved.

### 3. Verify the root

```bash
grep -c "localhost" index.html        # must be 0
grep -qx "aleahim.com" CNAME && echo "CNAME OK"
```

### 4. Commit and push

```bash
git add .
git commit -m "deploy: <what changed> (vX.Y)"
git push origin main
```

GitHub Pages deploys within 30 to 60 seconds.

### 5. Verify live

```bash
curl -s -o /dev/null -w "%{http_code}\n" https://aleahim.com/
curl -s https://aleahim.com/rss.xml | grep -c "<content:encoded>"
```

## Local Preview

```bash
make tiledown-preview   # serves http://localhost:8098 (blocking; run in its own terminal)
```

Builds from a temporary copy with `baseURL` removed so links are root-relative on
localhost.

## New blog posts

Use the `aleahim-new-post` skill, which wraps this flow with the hero-image step.
Author posts under `TileDown/content/blog/<slug>/`, bump `versionName` in
`TileDown/content/tiledown.yml`, then build and deploy.

## GitHub Pages Settings

https://github.com/mihaelamj/aleahim.com/settings/pages

- Source: Deploy from a branch
- Branch: main, path: /
- Custom domain: aleahim.com (ships from `TileDown/content/CNAME`; do not hand-edit)
- Enforce HTTPS: enabled

## Troubleshooting

### Site shows localhost URLs
Rebuild with `make tiledown-check` and copy from `TileDown/dist/` only.

### Build fails with a missing engine
The engine checkout must be at `../TileDown/tile-down` (or set `TILEDOWN_REPO`).

### Swift build fails: "module compiled with Swift X cannot be imported by Swift Y"
A `.build` was left by a different toolchain. Clean the engine's build cache:
`rm -rf ../TileDown/tile-down/Packages/.build && make tiledown-check`.
