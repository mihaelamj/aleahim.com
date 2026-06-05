# Aleahim.com

Personal website and technical writing archive for Mihaela Mihaljevic Jakic.

The site contains project notes, release posts, CV material, and articles about
Swift, OpenAPI, Apple-platform development, and AI-assisted developer tooling.
It is currently maintained as a TileDown/Toucan migration workspace.

## What Is In This Repo

- `TileDown/content/`: current source content for the TileDown version of the
  site.
- `Sources/GenerateCV/`: Swift code used to generate CV content.
- `Scripts/`: migration and validation helpers.
- Root-level generated HTML: previously built static output and compatibility
  redirects.

## Local Development

```bash
make dev
make serve
```

The local server is available at `http://localhost:3000`.

## Content Workflow

Most authored content lives under `TileDown/content/`. Blog posts are Markdown
files grouped by slug. Static assets live under `TileDown/content/images/` and
`TileDown/content/assets/`.

Useful references:

- [CONTENT-GUIDE.md](CONTENT-GUIDE.md)
- [DEPLOYMENT.md](DEPLOYMENT.md)
- [TileDown/README.md](TileDown/README.md)

## Deployment

The site deploys to GitHub Pages from the generated static output on `main`.

## License

Content copyright Mihaela Mihaljevic Jakic. All rights reserved unless a page
states otherwise.
