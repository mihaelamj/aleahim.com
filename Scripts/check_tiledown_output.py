#!/usr/bin/env python3
"""Verify the built TileDown site preserves production-critical Aleahim output."""

from html.parser import HTMLParser
from pathlib import Path
from urllib.parse import unquote, urlparse
import sys

from tiledown_site import SITE_DOMAIN, SITE_RELEASE_TAG, SITE_URL


ROOT = Path(__file__).resolve().parents[1]
TOUCAN_DIST = ROOT / "dist"
TILEDOWN_DIST = ROOT / "TileDown" / "dist"
results = []


class AssetParser(HTMLParser):
    def __init__(self):
        super().__init__()
        self.assets = []

    def handle_starttag(self, tag, attrs):
        values = dict(attrs)
        if tag in {"img", "script", "iframe", "source"}:
            value = values.get("src")
            if value:
                self.assets.append(value)
        if tag == "link" and values.get("rel") == "stylesheet":
            value = values.get("href")
            if value:
                self.assets.append(value)
        if tag == "meta" and values.get("property") in {"og:image"}:
            value = values.get("content")
            if value:
                self.assets.append(value)
        if tag == "meta" and values.get("name") in {"twitter:image"}:
            value = values.get("content")
            if value:
                self.assets.append(value)


def check(name, ok, detail=""):
    results.append((name, bool(ok), detail))


def local_path(url):
    parsed = urlparse(url)
    if parsed.scheme and f"{parsed.scheme}://{parsed.netloc}" != SITE_URL:
        return None
    if parsed.scheme == "mailto":
        return None
    path = parsed.path if parsed.scheme else url
    if not path.startswith("/"):
        return None
    return unquote(path.split("#", 1)[0].split("?", 1)[0])


def output_path(path):
    if path == "/":
        return TILEDOWN_DIST / "index.html"
    relative = path.removeprefix("/")
    if path.endswith("/"):
        return TILEDOWN_DIST / relative / "index.html"
    return TILEDOWN_DIST / relative


def html_routes(root):
    return {
        str(path.relative_to(root))
        for path in root.rglob("*.html")
        if path.is_file()
    }


def published_post_slugs():
    result = []
    for source in (ROOT / "TileDown" / "content" / "blog").glob("*/index.md"):
        text = source.read_text(errors="replace")
        if "\ndraft: true\n" not in text:
            result.append(source.parent.name)
    return sorted(result)


def check_route_parity():
    old = html_routes(TOUCAN_DIST)
    new = html_routes(TILEDOWN_DIST)
    missing = sorted(old - new)
    extra = sorted(new - old)
    unexpected_extra = [route for route in extra if not route.startswith("tags/")]
    check("TileDown preserves every Toucan HTML route", not missing, ", ".join(missing[:10]))
    check("TileDown only adds generated tag HTML routes", not unexpected_extra, ", ".join(unexpected_extra[:10]))


def check_static_files():
    expectations = {
        "CNAME": lambda text: text.strip() == SITE_DOMAIN,
        ".nojekyll": lambda _text: True,
        "robots.txt": lambda text: f"Sitemap: {SITE_URL}/sitemap.xml" in text,
        "rss.xml": lambda text: "<content:encoded>" in text,
        "sitemap.xml": lambda text: f"<loc>{SITE_URL}/</loc>" in text,
    }
    for relative, predicate in expectations.items():
        path = TILEDOWN_DIST / relative
        exists = path.is_file()
        check(f"{relative} exists at output root", exists)
        if exists:
            text = path.read_text(errors="replace")
            check(f"{relative} has expected content", predicate(text))

    for relative in [
        "Mihaela_Mihaljevic_Jakic_CV.pdf",
        "assets/Mihaela_Mihaljevic_Jakic_CV.pdf",
        "images/logo.png",
        "images/og-image.png",
        "images/blog/cupertino-first-light/hero.jpg",
        "css/style.css",
        "styles.css",
    ]:
        path = TILEDOWN_DIST / relative
        check(f"{relative} is published", path.is_file() and path.stat().st_size > 0)


def check_generated_assets():
    missing = []
    for html in sorted(TILEDOWN_DIST.rglob("*.html")):
        parser = AssetParser()
        parser.feed(html.read_text(errors="replace"))
        for asset in parser.assets:
            path = local_path(asset)
            if path is None:
                continue
            if not output_path(path).exists():
                missing.append(f"{html.relative_to(TILEDOWN_DIST)} -> {asset}")
    check("generated pages reference no missing local assets", not missing, "\n".join(missing[:20]))


def check_rss():
    rss = (TILEDOWN_DIST / "rss.xml").read_text(errors="replace")
    post_count = len(published_post_slugs())
    item_count = rss.count("<item>")
    encoded_count = rss.count("<content:encoded>")
    check(
        "RSS has one item per published post",
        item_count == post_count,
        "" if item_count == post_count else f"{item_count} != {post_count}",
    )
    check(
        "RSS full-content blocks match items",
        encoded_count == item_count,
        "" if encoded_count == item_count else f"{encoded_count} != {item_count}",
    )
    check("RSS uses public links", f"<link>{SITE_URL}/blog/cupertino-first-light/</link>" in rss)


def check_article_pdfs():
    config = (ROOT / "TileDown" / "content" / "tiledown.yml").read_text(errors="replace")
    check("article PDFs are enabled", "\narticlePDF: true\n" in f"\n{config}\n")

    missing = []
    stale_nested = []
    missing_links = []
    for slug in published_post_slugs():
        pdf_path = TILEDOWN_DIST / f"{slug}.pdf"
        if not pdf_path.is_file() or pdf_path.stat().st_size == 0:
            missing.append(f"{slug}.pdf")

        nested_pdf = TILEDOWN_DIST / "blog" / slug / "index.pdf"
        if nested_pdf.exists():
            stale_nested.append(str(nested_pdf.relative_to(TILEDOWN_DIST)))

        html = (TILEDOWN_DIST / "blog" / slug / "index.html").read_text(errors="replace")
        expected = f'<a href="{SITE_URL}/{slug}.pdf" download>Download PDF</a>'
        if expected not in html:
            missing_links.append(f"blog/{slug}/index.html")

    check("each published article has a root slug PDF", not missing, ", ".join(missing[:10]))
    check("article PDFs are not nested under blog", not stale_nested, ", ".join(stale_nested[:10]))
    check("each article links its root slug PDF", not missing_links, ", ".join(missing_links[:10]))


def check_site_features():
    index = (TILEDOWN_DIST / "index.html").read_text(errors="replace")
    blog = (TILEDOWN_DIST / "blog" / "index.html").read_text(errors="replace")
    irelay = (TILEDOWN_DIST / "blog" / "irelay" / "index.html").read_text(errors="replace")
    expected_nav = (
        '<nav class="td-nav"><a class="td-nav-link" href="https://aleahim.com/about/">About</a>'
        '<a class="td-nav-link" href="https://aleahim.com/blog/">Blog</a>'
        '<a class="td-nav-link" href="https://aleahim.com/speaking/">Speaking</a></nav>'
    )
    check("analytics script is injected", "cloud.umami.is/script.js" in index)
    check(
        "brand title renders as Aleahim.com",
        '<span class="td-brand-title">Aleahim.com</span>' in index,
    )
    check(
        "site release tag renders below Aleahim.com",
        f'<span class="td-brand-subtitle">{SITE_RELEASE_TAG}</span>' in index,
    )
    check("top nav replaces CV with Blog in order", expected_nav in index)
    check("top nav omits Curriculum Vitae", 'class="td-nav-link" href="https://aleahim.com/cv/">' not in index)
    check("Blog page shows tag bar", 'class="td-tagbar"' in blog)
    check("Blog page renders one heading", blog.count("<h1") == 1)
    check("Blog page lists article cards", 'class="td-post-card"' in blog)
    check("homepage does not show stale Latest copy", "Latest:" not in index)
    check("homepage latest list starts with newest post", "blog/cupertino-v1-3-0-platform-filtering/" in index)
    check(
        "homepage does not promote old latest post before list",
        "Cupertino v1.1.0, my Apple docs index was 30% lies" not in index,
    )
    check("iRelay iframe renders through safe embed tile", "https://www.youtube-nocookie.com/embed/ehOY7BnPOf0" in irelay)
    check("iRelay raw iframe is not escaped as visible text", "&lt;iframe" not in irelay)


def print_results():
    failed = [(name, detail) for name, ok, detail in results if not ok]
    for name, ok, detail in results:
        marker = "PASS" if ok else "FAIL"
        suffix = f" - {detail}" if detail else ""
        print(f"{marker}: {name}{suffix}")
    if failed:
        print(f"\n{len(failed)} TileDown output check(s) failed.", file=sys.stderr)
        return 1
    print(f"\nAll {len(results)} TileDown output checks passed.")
    return 0


def main():
    if not TILEDOWN_DIST.is_dir():
        print("TileDown/dist does not exist. Run `make tiledown-build` first.", file=sys.stderr)
        return 1
    check_route_parity()
    check_static_files()
    check_generated_assets()
    check_rss()
    check_article_pdfs()
    check_site_features()
    return print_results()


if __name__ == "__main__":
    sys.exit(main())
