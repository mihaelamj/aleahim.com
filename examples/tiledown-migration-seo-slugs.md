# TileDown Migration: SEO Slugs

When migrating Aleahim.com from Toucan to TileDown, keep the current public URL
shape unless there is a specific reason to change a page.

## Rule

Blog posts should keep their existing front matter slugs:

```yaml
slug: blog/example-post
```

That slug should continue to publish as:

```text
/blog/example-post/
```

The current route inventory is captured in
[`current-public-url-contract.md`](current-public-url-contract.md).

Do not let the new generator infer a different path such as:

```text
/posts/example-post/
/writing/example-post/
/blog/example-post/index.html
```

## Why

Existing slugs are part of the public contract of the site. Search results,
external links, bookmarks, social cards, RSS readers, and old newsletter links
may all point to those URLs.

Changing a slug is allowed only when the old URL gets a permanent redirect.

## Redirect Requirement

For every changed URL, add a `301` redirect from the old URL to the new URL:

```text
/blog/old-post-slug/ -> /blog/new-post-slug/
```

The redirect should be part of the generated static site, not only a local
server rule.

## Migration Checks

Before switching production to TileDown:

- Every current `/blog/.../` URL should still return `200`.
- Every legacy redirect should still return or behave as a permanent redirect.
- RSS item links should use the final public URLs.
- Canonical URLs should match the final public URLs.
- Trailing slash behavior should match the existing Toucan site.
