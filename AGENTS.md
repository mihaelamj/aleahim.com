# Aleahim.com - Agent Instructions

The site is built with the TileDown engine. Content is authored under
`TileDown/content/` and built into the repo root, which GitHub Pages serves.
There is no separate generator step and no conversion.

For a guided post (with the hero-image step), use the `aleahim-new-post` skill.
The manual flow is below.

## Adding a New Blog Post

### 1. Create the post

```bash
mkdir -p TileDown/content/blog/your-post-slug
```

`TileDown/content/blog/your-post-slug/index.md`:

```markdown
---
slug: blog/your-post-slug
title: "Your Post Title"
description: Short description for listings
date: 2026-06-07
image: /images/blog/your-post-slug/hero.jpg
draft: false
tags: Swift, Tooling
---

# Your Post Title

Your content here...
```

### 2. Add images

```bash
mkdir -p TileDown/content/images/blog/your-post-slug
cp ~/path/to/hero.jpg TileDown/content/images/blog/your-post-slug/hero.jpg
```

### 3. Bump the site version

Edit `TileDown/content/tiledown.yml` and increment `versionName` (for example
v1.19 to v1.20).

### 4. Build, check, preview

```bash
make tiledown-check     # build + tiledown doctor + RSS full-text and localhost guards
make tiledown-preview   # serves at http://localhost:8098
```

### 5. Deploy

```bash
cp -R TileDown/dist/* .   # GitHub Pages serves committed HTML from the repo root
git add .
git commit -m "deploy: add your post (vX.Y)"
git push origin main
# Always tag the site: lightweight vX.Y tag matching versionName, pushed to origin.
VER=$(grep "^versionName:" TileDown/content/tiledown.yml | sed 's/^versionName: *//')
git tag "$VER" && git push origin "$VER"
```

## Important Notes

- **Slug format**: `slug: blog/post-name`, not just `post-name`.
- **Images**: under `TileDown/content/images/blog/post-name/`, referenced as
  `/images/blog/post-name/`.
- **Body H1**: start the body with `# Title` matching the frontmatter title.
- **Engine location**: the Makefile uses the sibling checkout at
  `../TileDown/tile-down`; override with `TILEDOWN_REPO`.
- **Cache**: after deploy, hard refresh (Cmd+Shift+R).

## File Structure

```
aleahim.com/
├── TileDown/content/      # site source: posts, images, tiledown.yml
├── TileDown/dist/         # built site (engine output)
├── blog/, index.html, ... # built HTML committed to the root for GitHub Pages
└── Makefile               # tiledown-build / tiledown-check / tiledown-preview
```
