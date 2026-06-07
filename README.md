# Aleahim.com

Personal website and technical writing archive for Mihaela Mihaljevic Jakic.

The site contains project notes, release posts, and articles about Swift, OpenAPI,
Apple-platform development, and AI-assisted developer tooling. It is built with
TileDown.

## What Is In This Repo

- `TileDown/content/`: the site source. Markdown posts grouped by slug under
  `TileDown/content/blog/`, images under `TileDown/content/images/`, and
  `tiledown.yml`.
- Root-level HTML: the built static site that GitHub Pages serves.

## Local Preview

```bash
make tiledown-preview
```

Serves the site at `http://localhost:8098`.

## Content Workflow

Authored content lives under `TileDown/content/`. Build and check the site with:

```bash
make tiledown-check
```

To add a post, the `aleahim-new-post` skill scaffolds, builds, and deploys it.
See [DEPLOYMENT.md](DEPLOYMENT.md) for the full deploy flow.

## Deployment

Built with the TileDown engine (`make tiledown-build`) and deployed to GitHub
Pages by committing the built static output at the repo root on `main`.

## License

Content copyright Mihaela Mihaljevic Jakic. All rights reserved unless a page
states otherwise.
