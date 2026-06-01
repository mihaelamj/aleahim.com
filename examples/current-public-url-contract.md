# Aleahim Current Public URL Contract

Captured on June 1, 2026 from the committed Toucan output in this repository.
This is the URL contract TileDown must preserve or intentionally redirect before
Aleahim.com production traffic moves away from Toucan.

## Rules

- The home page is `/`. It is also the blog listing.
- Blog posts publish under `/blog/<slug>/` and keep a trailing slash.
- Standard pages publish with a trailing slash.
- Root XML files publish without a trailing slash: `/rss.xml` and
  `/sitemap.xml`.
- GitHub Pages 404 output is `/404.html`, with canonical URL
  `https://aleahim.com/404/`.
- Existing static redirect pages currently use HTML meta refresh plus
  JavaScript. GitHub Pages static hosting cannot emit HTTP 301 from a generated
  file. If the final host supports server redirects, intentional URL changes
  should use HTTP 301. On GitHub Pages, preserve equivalent static redirect
  pages.
- The current source of truth for blog slugs is `slug: blog/...` in
  `contents/blog/*/index.md`.
- The browser acceptance checks tracked by issue #15 should stay aligned with
  this inventory as routes are added or intentionally changed.

## Primary Routes

| Route | Canonical URL |
| --- | --- |
| `/` | `https://aleahim.com/` |
| `/about/` | `https://aleahim.com/about/` |
| `/cv/` | `https://aleahim.com/cv/` |
| `/speaking/` | `https://aleahim.com/speaking/` |
| `/404.html` | `https://aleahim.com/404/` |

## Other Published Routes

| Route | Current State |
| --- | --- |
| `/cupertino/` | Published HTML route with `http://localhost:3000` assets and no production canonical link. See migration decision below. |

## Blog Routes

| Route | Canonical URL |
| --- | --- |
| `/blog/c-v-builder/` | `https://aleahim.com/blog/c-v-builder/` |
| `/blog/core-animation-3d-cube/` | `https://aleahim.com/blog/core-animation-3d-cube/` |
| `/blog/cupertino/` | `https://aleahim.com/blog/cupertino/` |
| `/blog/cupertino-04-release/` | `https://aleahim.com/blog/cupertino-04-release/` |
| `/blog/cupertino-05-release/` | `https://aleahim.com/blog/cupertino-05-release/` |
| `/blog/cupertino-07-release/` | `https://aleahim.com/blog/cupertino-07-release/` |
| `/blog/cupertino-08-release/` | `https://aleahim.com/blog/cupertino-08-release/` |
| `/blog/cupertino-09-release/` | `https://aleahim.com/blog/cupertino-09-release/` |
| `/blog/cupertino-10-release/` | `https://aleahim.com/blog/cupertino-10-release/` |
| `/blog/cupertino-ecosystem/` | `https://aleahim.com/blog/cupertino-ecosystem/` |
| `/blog/cupertino-first-light/` | `https://aleahim.com/blog/cupertino-first-light/` |
| `/blog/cupertino-instant-setup/` | `https://aleahim.com/blog/cupertino-instant-setup/` |
| `/blog/cupertino-one-line-install/` | `https://aleahim.com/blog/cupertino-one-line-install/` |
| `/blog/cupertino-v1-0-2/` | `https://aleahim.com/blog/cupertino-v1-0-2/` |
| `/blog/cupertino-v1-1-0-poison-cleanup/` | `https://aleahim.com/blog/cupertino-v1-1-0-poison-cleanup/` |
| `/blog/cupertino-v1-2-0-ironclad/` | `https://aleahim.com/blog/cupertino-v1-2-0-ironclad/` |
| `/blog/cupertino-v1-3-0-platform-filtering/` | `https://aleahim.com/blog/cupertino-v1-3-0-platform-filtering/` |
| `/blog/extreme-packaging/` | `https://aleahim.com/blog/extreme-packaging/` |
| `/blog/extreme-packaging-open-a-p-i/` | `https://aleahim.com/blog/extreme-packaging-open-a-p-i/` |
| `/blog/irelay/` | `https://aleahim.com/blog/irelay/` |
| `/blog/logging-middleware/` | `https://aleahim.com/blog/logging-middleware/` |
| `/blog/morlocks-built-swiftui/` | `https://aleahim.com/blog/morlocks-built-swiftui/` |
| `/blog/swift-u-i-lab-advanced-animations/` | `https://aleahim.com/blog/swift-u-i-lab-advanced-animations/` |
| `/blog/token-middleware/` | `https://aleahim.com/blog/token-middleware/` |
| `/blog/why-i-built-openapi-doctor/` | `https://aleahim.com/blog/why-i-built-openapi-doctor/` |

## Generated Feed And Index Files

| Route | Expected URL Shape |
| --- | --- |
| `/rss.xml` | RSS channel and item links use `https://aleahim.com/...` |
| `/sitemap.xml` | Sitemap `loc` values use `https://aleahim.com/...` |
| `/robots.txt` | Root file remains at `/robots.txt` |
| `/CNAME` | Root file remains at `/CNAME` |
| `/Mihaela_Mihaljevic_Jakic_CV.pdf` | Root PDF remains at the same path |

## Static Redirect Pages

The committed Toucan redirect pages emit absolute production URLs for internal
targets. TileDown output should preserve the same browser-visible target URLs
unless a redirect is intentionally redesigned.

| Current Route | Target |
| --- | --- |
| `/CVBuilder/` | `https://aleahim.com/blog/c-v-builder/` |
| `/CoreAnimation3DCube/` | `https://aleahim.com/blog/core-animation-3d-cube/` |
| `/ExtremePackaging/` | `https://aleahim.com/blog/extreme-packaging/` |
| `/ExtremePackagingOpenAPI/` | `https://aleahim.com/blog/extreme-packaging-open-a-p-i/` |
| `/LoggingMiddleware/` | `https://aleahim.com/blog/logging-middleware/` |
| `/SwiftUILabAdvancedAnimations/` | `https://aleahim.com/blog/swift-u-i-lab-advanced-animations/` |
| `/TokenMiddeware/` | `https://aleahim.com/blog/token-middleware/` |
| `/TokenMiddleware/` | `https://aleahim.com/blog/token-middleware/` |
| `/blog/` | `https://aleahim.com/` |
| `/c-v-page/` | `https://aleahim.com/blog/c-v-builder/` |
| `/consulting/` | `https://aleahim.com/services/` |
| `/contact/` | `https://aleahim.com/about/` |
| `/core-animation-layers-forming-a-3d-cube/` | `https://aleahim.com/blog/core-animation-3d-cube/` |
| `/home/` | `https://aleahim.com/` |
| `/rss/` | `https://aleahim.com/rss.xml` |
| `/services/` | `https://codeweaver.info/` |

## 404 Script Redirects

The current `404.html` contains client-side redirects for additional legacy
paths. These must either be preserved in the generated 404 page or converted to
stronger redirect rules if hosting changes.

Exact mappings:

| Legacy Path | Target |
| --- | --- |
| `/cvbuilder` and `/cvbuilder/` | `/blog/c-v-builder/` |
| `/c-v-page` | `/blog/c-v-builder/` |
| `/extremepackaging` and `/extremepackaging/` | `/blog/extreme-packaging/` |
| `/extremepackagingopenapi` and `/extremepackagingopenapi/` | `/blog/extreme-packaging-open-a-p-i/` |
| `/coreanimation3dcube` and `/coreanimation3dcube/` | `/blog/core-animation-3d-cube/` |
| `/core-animation-layers-forming-a-3d-cube` | `/blog/core-animation-3d-cube/` |
| `/tokenmiddeware` and `/tokenmiddeware/` | `/blog/token-middleware/` |
| `/tokenmiddleware` and `/tokenmiddleware/` | `/blog/token-middleware/` |
| `/loggingmiddleware` and `/loggingmiddleware/` | `/blog/logging-middleware/` |
| `/swiftuilabadvancedanimations` and `/swiftuilabadvancedanimations/` | `/blog/swift-u-i-lab-advanced-animations/` |
| `/cupertino` and `/cupertino/null` | `/cupertino/` |
| `/blog/cupertino-ins` | `/blog/cupertino-instant-setup/` |
| `/home` and `/home/` | `/` |

Prefix mappings:

| Legacy Prefix | Target Prefix |
| --- | --- |
| `/tag/` | `/` |
| `/tags/` | `/` |
| `/author/` | `/about/` |
| `/p/` | `/` |
| `/posts/` | `/blog/` |
| `/read/` | `/` |

## Migration Decision Needed

`/cupertino/` currently exists as a committed HTML page but appears to be stale
development output: it uses `http://localhost:3000` asset URLs and lacks the
production canonical link shape used by the current `/blog/cupertino/` post.

Before switching to TileDown, choose one of these:

1. Preserve `/cupertino/` as a first-class public route with corrected
   production metadata and asset URLs.
2. Redirect `/cupertino/` to `/blog/cupertino/` and add that change to the
   redirect contract.

Do not drop `/cupertino/` silently. It is currently published.
