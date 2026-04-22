# Aleahim.com — Priority Check First

## Known discoverability issue: RSS feed is excerpt-only (2026-04-23)

**Status: open. Fix before next blog post push.**

Context: `aleahim.com/rss.xml` is what feeds search engines like [appledevsearch.com](https://appledevsearch.com/) and [iosdevsearch.com](https://iosdevsearch.com/) (both pull from [iOS Dev Directory](https://iosdevdirectory.com/)). The blog is already indexed in the directory as "Mihaela MJ's Blog" under English Language > Development Blogs.

### The problem

The RSS template at `templates/default/views/rss.mustache` emits only `<description>` (the short front-matter blurb, ~92 chars), and no `<content:encoded>` element:

```xml
<item>
  <title>{{title}}</title>
  <link>{{permalink}}</link>
  <description>{{description}}</description>
  <pubDate>{{date.formats.rss}}</pubDate>
  <guid isPermaLink="true">{{permalink}}</guid>
</item>
```

Appledevsearch explicitly requires *full-text RSS feeds with complete history*. Currently only titles + excerpts are searchable, which is why 30-day referrals from appledevsearch.com are 1 visit despite ~999 blogs competing and our content being directly on-topic (Swift, Cupertino, modular architecture).

### The fix

1. In `templates/default/views/rss.mustache`:
   - Add the content namespace to `<rss>`: `xmlns:content="http://purl.org/rss/1.0/modules/content/"`
   - Inside each `<item>`, add: `<content:encoded><![CDATA[{{{body_html_variable}}}]]></content:encoded>`
   - Confirm the actual Toucan variable name for rendered post body HTML (check other views for how post content is rendered; it's likely `{{{contents}}}` or `{{{body}}}` — grep templates/default for a view that renders full post content).
2. The `{{{ }}}` triple-mustache is required to skip HTML-escaping so the CDATA holds real HTML.
3. After edit: `make dev`, verify `rss.xml` has `<content:encoded>` blocks, `make serve` and curl locally, then deploy.

### Directory entry also needs updating (separate PR to iOS Dev Directory)

File: `blogs.json` in [iOSDevDirectory/iOSDevDirectory](https://github.com/iOSDevDirectory/iOSDevDirectory), category "English Language > Development Blogs".

Current entry is incomplete / stale:
```json
{
  "title": "Mihaela MJ's Blog",
  "author": "Mihaela MJ",
  "site_url": "https://aleahim.com",
  "feed_url": "https://aleahim.com/rss.xml",
  "x_url": "https://x.com/civeljahim"
}
```

Issues:
- `x_url` is `@civeljahim` — verify whether this is a retired handle. Current X handle is `@diyamantina`.
- Missing `bluesky_url`, `mastodon_url`, `github_url`, `linkedin_url` (directory supports all of these).

Target entry:
```json
{
  "title": "Mihaela MJ's Blog",
  "author": "Mihaela Mihaljević Jakić",
  "site_url": "https://aleahim.com",
  "feed_url": "https://aleahim.com/rss.xml",
  "x_url": "https://x.com/diyamantina",
  "bluesky_url": "https://bsky.app/profile/dijamantina.bsky.social",
  "mastodon_url": "https://mastodon.social/@ameahim",
  "github_url": "https://github.com/mihaelamj",
  "linkedin_url": "https://www.linkedin.com/in/mihaelamj/"
}
```

### How to verify the fix worked

- After deploying, `curl -s https://aleahim.com/rss.xml | grep -c '<content:encoded>'` should return the number of items in the feed (currently 18).
- Appledevsearch re-indexes via RSS poll (cadence unknown; likely daily). Give it 48h, then search appledevsearch.com for a distinctive phrase from an old post that's NOT in its title (e.g., a phrase from the body of the ExtremePackaging post). If it matches, full-content indexing is working.
- Track the `appledevsearch.com` referrer count in `mihaela-analytics/umami/aleahim/raw/*/metrics-referrer.json` week-over-week.

## General agent instructions

See `AGENTS.md` in this repo for post-creation and deploy workflow.
