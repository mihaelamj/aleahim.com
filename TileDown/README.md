# TileDown Migration Source

This directory holds the TileDown source tree generated from the current Toucan
`contents/` directory.

For the full migration procedure, including slug checks, local preview,
production cutover, and rollback, see [MIGRATION.md](MIGRATION.md).

Regenerate it with:

```sh
make tiledown-content
```

Check the migration end to end with:

```sh
make tiledown-check
```

That command:

- regenerates `TileDown/content` from Toucan `contents/`
- verifies converted front matter, redirects, static assets, analytics, and embed
  conversion
- builds `TileDown/dist` with the adjacent TileDown checkout
- verifies route parity, root deployment files, local assets, full-content RSS,
  analytics, and the iRelay video embed

Preview locally with root-relative links:

```sh
make tiledown-preview
```

The committed generated source keeps the production `baseURL` from the shared
TileDown site settings so canonical URLs, RSS, sitemap, and share links are
valid for deployment. The preview target copies `TileDown/content` to `/tmp`,
removes `baseURL` from that temporary copy, builds into
`/tmp/aleahim-tiledown-preview-site`, and serves it with links such as
`/styles.css`.

Build only with:

```sh
make tiledown-build
```

The Makefile defaults to the sibling checkout at `../TileDown/tile-down`. If the
engine lives elsewhere, override `TILEDOWN_REPO` or provide an installed binary:

```sh
TILEDOWN_REPO=/path/to/tile-down make tiledown-check
TILEDOWN=tiledown make tiledown-check
```

The current production Toucan source remains in `contents/` until the migration
is fully verified and deployed.
