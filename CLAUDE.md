# Aleahim.com — Priority Check First

## RSS full-text feed (fixed 2026-04-23)

**Status: deployed on `main` in commit `1461c507`.**

`aleahim.com/rss.xml` now emits `<content:encoded>` (CDATA) with the full rendered post HTML for every item. This feeds [appledevsearch.com](https://appledevsearch.com/) and [iosdevsearch.com](https://iosdevsearch.com/) via the [iOS Dev Directory](https://iosdevdirectory.com/).

### What changed

- `templates/default/views/rss.mustache`:
  - Added `xmlns:content="http://purl.org/rss/1.0/modules/content/"` to `<rss>`.
  - Added `<content:encoded><![CDATA[{{{contents.html}}}]]></content:encoded>` inside each `<item>`.
- No pipeline change was needed — Toucan 1.0.0-rc.1's `list` scope already hydrates `contents.html`.

### Verify

```bash
curl -s https://aleahim.com/rss.xml | grep -c '<content:encoded>'
# Must equal the number of <item> tags (currently 18).
```

48h after deploy, search appledevsearch.com for a distinctive phrase from an old post body (not in its title). If it matches, full-content indexing is working. Track `appledevsearch.com` referrer count in `mihaela-analytics/umami/aleahim/raw/*/metrics-referrer.json` week-over-week.

### Still open: iOS Dev Directory entry

The directory entry in `blogs.json` at [iOSDevDirectory/iOSDevDirectory](https://github.com/iOSDevDirectory/iOSDevDirectory), category "English Language > Development Blogs", is stale:

- `x_url` is `@civeljahim` (retired handle). Current X handle is `@diyamantina`.
- Missing `bluesky_url`, `mastodon_url`, `github_url`, `linkedin_url`.

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

Fork the repo, edit `blogs.json`, open a PR.

## General agent instructions

See `AGENTS.md` in this repo for post-creation and deploy workflow.
