# TileDown source

`TileDown/content/` is the source for aleahim.com: Markdown posts grouped by slug
under `blog/`, images under `images/`, and `tiledown.yml`. The TileDown engine
builds it into `TileDown/dist/`, which is copied to the repo root for GitHub Pages.

Build:

```sh
make tiledown-build
```

Build, run the engine doctor, and check the RSS full-text and localhost
invariants:

```sh
make tiledown-check
```

Preview locally with root-relative links on http://localhost:8098:

```sh
make tiledown-preview
```

The Makefile uses the sibling engine checkout at `../TileDown/tile-down`. Override
with `TILEDOWN_REPO`, or use an installed binary with `TILEDOWN=tiledown`:

```sh
TILEDOWN_REPO=/path/to/tile-down make tiledown-check
TILEDOWN=tiledown make tiledown-check
```

`tiledown.yml` keeps the production `baseURL` so canonical URLs, RSS, sitemap, and
share links are valid. The preview target builds from a temporary copy with
`baseURL` removed so links are root-relative on localhost.
