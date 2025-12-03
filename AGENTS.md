# Aleahim.com - Agent Instructions

## Adding a New Blog Post

### 1. Create the post directory and file
```bash
mkdir -p contents/blog/your-post-slug
```

Create `contents/blog/your-post-slug/index.md`:
```markdown
---
slug: blog/your-post-slug
title: "Your Post Title"
description: Short description for listings
date: 2025-12-03
draft: false
image: /images/blog/your-post-slug/hero.jpg
---

Your content here...
```

### 2. Add hero image
```bash
mkdir -p assets/images/blog/your-post-slug
cp ~/path/to/image.jpg assets/images/blog/your-post-slug/hero.jpg
```

### 3. Build and preview locally
```bash
make dev
make serve
# Visit http://localhost:3000
```

### 4. Build for production and deploy
```bash
# Build with live URLs
toucan generate --target live

# Copy built files to root (required for GitHub Pages)
cp -r /tmp/output/* .

# Commit and push
git add .
git commit -m "Add new blog post: Your Post Title"
git push origin main
```

### 5. (Optional) Tag for workflow deploy
```bash
git tag v1.x.x
git push --tags
```

## Important Notes

- **Slug format**: Use `slug: blog/post-name` for blog posts (NOT just `post-name`)
- **Image paths**: Put images in `assets/images/blog/post-name/`, reference as `/images/blog/post-name/`
- **Live build**: Always use `toucan generate --target live` for production (uses aleahim.com URLs)
- **Copy to root**: Must copy from `/tmp/output/` or `dist/` to repo root for GitHub Pages
- **Cache**: After deploy, hard refresh (`Cmd+Shift+R`) to see changes

## Content Types

- `blog-post`: Posts in `contents/blog/` with date, title, description, image
- `page`: Standard pages (about, cv, services)

## File Structure

```
aleahim.com/
├── contents/blog/          # Blog post sources (markdown)
├── assets/images/blog/     # Blog images
├── blog/                   # Built blog HTML (committed for GitHub Pages)
├── templates/              # Mustache templates
├── types/                  # Content type definitions
├── pipelines/              # Build pipeline configs
└── site.yml                # Site config & navigation
```
