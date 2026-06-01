#!/usr/bin/env python3
"""Browser acceptance checks for the current Aleahim public URL contract.

These checks run in Chromium, but all aleahim.com requests are fulfilled from
the local repository checkout. That preserves the production absolute URL shape
while keeping the test deterministic and offline.
"""

from pathlib import Path
from urllib.parse import unquote, urlparse
import mimetypes
import os
import sys

from playwright.sync_api import sync_playwright


ORIGIN = "https://aleahim.com"
ROOT = Path(os.environ.get("SITE_ROOT", Path(__file__).resolve().parents[2])).resolve()
ALEAHIM_HOSTS = {"aleahim.com", "www.aleahim.com"}

results = []


def check(name, ok, detail=""):
    results.append((name, bool(ok), detail))


def content_type(path):
    if path.suffix == ".xml":
        return "application/xml; charset=utf-8"
    if path.suffix == ".svg":
        return "image/svg+xml"
    if path.suffix == ".pdf":
        return "application/pdf"
    guess, _ = mimetypes.guess_type(path.name)
    return guess or "application/octet-stream"


def local_file_for_url(url):
    parsed = urlparse(url)
    request_path = unquote(parsed.path.lstrip("/"))
    if request_path == "":
        request_path = "index.html"
    elif request_path.endswith("/"):
        request_path += "index.html"

    candidates = [ROOT / request_path]
    if not Path(request_path).suffix:
        candidates.append(ROOT / request_path / "index.html")

    for candidate in candidates:
        resolved = candidate.resolve()
        try:
            resolved.relative_to(ROOT)
        except ValueError:
            continue
        if resolved.is_file():
            return resolved, 200

    return ROOT / "404.html", 404


def route_local_site(route, request):
    parsed = urlparse(request.url)
    host = parsed.hostname or ""

    if host not in ALEAHIM_HOSTS:
        if request.resource_type == "stylesheet":
            route.fulfill(status=204, body="", headers={"content-type": "text/css"})
        elif request.resource_type == "script":
            route.fulfill(status=204, body="", headers={"content-type": "application/javascript"})
        else:
            route.fulfill(status=204, body="")
        return

    path, status = local_file_for_url(request.url)
    headers = {"content-type": content_type(path)}
    if request.method == "HEAD":
        route.fulfill(status=status, body="", headers=headers)
    else:
        route.fulfill(status=status, path=str(path), headers=headers)


def install_routes(context):
    context.route("**/*", route_local_site)


def full_url(path):
    return ORIGIN + path


def expect_page(page, path, title_fragment, h1_fragment, canonical_path):
    response = page.goto(full_url(path), wait_until="networkidle")
    detail = "" if response is None else str(response.status)
    check(f"{path} returns 200", response is not None and response.status == 200, detail)
    check(f"{path} title", title_fragment in page.title(), page.title())
    h1 = page.locator("main h1, main h2").first.inner_text()
    check(f"{path} h1", h1_fragment in h1, h1)
    canonical = page.locator('link[rel="canonical"]').first.get_attribute("href")
    check(f"{path} canonical", canonical == full_url(canonical_path), canonical or "")


def visible_image_failures(page):
    return page.eval_on_selector_all(
        "img",
        """images => images
            .filter(image => {
                const rect = image.getBoundingClientRect();
                return rect.width > 0 && rect.height > 0;
            })
            .filter(image => !image.complete || image.naturalWidth === 0 || image.naturalHeight === 0)
            .map(image => image.getAttribute("src") || image.currentSrc || image.alt)
        """,
    )


def asset_status(page, path):
    return page.evaluate(
        """async path => {
            const response = await fetch(path);
            const body = await response.arrayBuffer();
            return {
                status: response.status,
                type: response.headers.get("content-type") || "",
                size: body.byteLength
            };
        }""",
        full_url(path),
    )


def check_static_asset(page, path, expected_type):
    result = asset_status(page, path)
    check(
        f"{path} asset loads",
        result["status"] == 200 and expected_type in result["type"] and result["size"] > 0,
        str(result),
    )


def check_navigation(page):
    page.goto(full_url("/"), wait_until="networkidle")
    page.get_by_role("link", name="CV").first.click()
    page.wait_for_load_state("networkidle")
    check(
        "navigation reaches CV",
        page.url == full_url("/cv/") and "Curriculum Vitae" in page.title(),
        page.url,
    )

    page.get_by_role("link", name="Speaking").first.click()
    page.wait_for_load_state("networkidle")
    check(
        "navigation reaches Speaking",
        page.url == full_url("/speaking/") and "Speaking" in page.locator("main h1").first.inner_text(),
        page.url,
    )

    page.get_by_role("link", name="About").first.click()
    page.wait_for_load_state("networkidle")
    check(
        "navigation reaches About",
        page.url == full_url("/about/") and "About" in page.locator("main h1").first.inner_text(),
        page.url,
    )

    page.get_by_role("link", name="Home").first.click()
    page.wait_for_load_state("networkidle")
    check("navigation returns Home", page.url == full_url("/") and page.locator(".post-preview").count() >= 1, page.url)


def check_theme_behavior_if_present(page):
    page.goto(full_url("/"), wait_until="networkidle")
    candidates = page.locator("[data-td-theme-toggle], .theme-toggle")
    if candidates.count() == 0:
        check("theme toggle absent on current Toucan baseline", True)
        return

    before = page.evaluate("getComputedStyle(document.body).backgroundColor")
    candidates.first.click()
    after = page.evaluate("getComputedStyle(document.body).backgroundColor")
    check("theme toggle changes body background", before != after, f"{before} -> {after}")
    page.reload(wait_until="networkidle")
    persisted = page.evaluate("getComputedStyle(document.body).backgroundColor")
    check("theme choice persists after reload", persisted == after, f"{persisted} != {after}")


def check_redirect(nojs_page, path, target_path):
    target = full_url(target_path)
    result = nojs_page.evaluate(
        """async path => {
            const response = await fetch(path);
            const html = await response.text();
            const document = new DOMParser().parseFromString(html, "text/html");
            return {
                status: response.status,
                canonical: document.querySelector('link[rel="canonical"]')?.getAttribute("href") || "",
                refresh: document.querySelector('meta[http-equiv="refresh"]')?.getAttribute("content") || "",
                href: document.querySelector("a")?.getAttribute("href") || ""
            };
        }""",
        full_url(path),
    )
    check(f"{path} redirect page returns 200", result["status"] == 200, str(result["status"]))
    check(f"{path} redirect canonical", result["canonical"] == target, result["canonical"])
    check(f"{path} redirect refresh", target in result["refresh"], result["refresh"])
    check(f"{path} redirect link", result["href"] == target, result["href"])


def check_404_script_redirect(page, path, target_path):
    target = full_url(target_path)
    page.goto(full_url(path), wait_until="domcontentloaded")
    page.wait_for_url(target)
    check(f"{path} 404 script redirect lands on {target_path}", page.url == target, page.url)


def check_feed_and_sitemap(page):
    rss = page.evaluate("async () => await (await fetch('/rss.xml')).text()")
    check("RSS is XML", rss.startswith('<?xml version="1.0" encoding="UTF-8"?>'))
    check("RSS title is current Aleahim feed", "<title>Aleahim - iOS Development Blog</title>" in rss)
    check("RSS includes post links", "https://aleahim.com/blog/cupertino-first-light/" in rss)
    check("RSS includes rendered content", "<content:encoded><![CDATA[" in rss)

    sitemap = page.evaluate("async () => await (await fetch('/sitemap.xml')).text()")
    check("sitemap is urlset", sitemap.startswith("<urlset"))
    for route in ["/", "/cv/", "/speaking/", "/about/", "/blog/cupertino-first-light/"]:
        check(f"sitemap includes {route}", f"<loc>{full_url(route)}</loc>" in sitemap)
    check("sitemap excludes legacy redirect route", "<loc>https://aleahim.com/TokenMiddleware/</loc>" not in sitemap)


def run_checks(page, nojs_page):
    page.set_viewport_size({"width": 1280, "height": 900})

    expect_page(page, "/", "Mihaela Mihaljević", "Mihaela", "/")
    post_count = page.locator(".post-preview").count()
    check("home is the blog listing", post_count >= 20, str(post_count))
    check("home includes representative post", "Cupertino v1.0.0" in page.inner_text("body"))
    home_image_failures = visible_image_failures(page)
    check("home visible images load", home_image_failures == [], str(home_image_failures))

    expect_page(page, "/blog/cupertino-first-light/", "Cupertino v1.0.0", "Cupertino v1.0.0", "/blog/cupertino-first-light/")
    check("blog post has article shell", page.locator(".blog-post").count() == 1)
    post_image_failures = visible_image_failures(page)
    check("blog post hero image loads", post_image_failures == [], str(post_image_failures))

    expect_page(page, "/cv/", "Curriculum Vitae", "Mihaela Mihaljević Jakić", "/cv/")
    expect_page(page, "/speaking/", "Speaking", "Speaking", "/speaking/")
    expect_page(page, "/about/", "About", "About Me", "/about/")
    expect_page(page, "/404.html", "Not found", "Not found", "/404/")

    missing_status = page.evaluate("async () => (await fetch('/missing-route-for-browser-check/')).status")
    check("missing route returns 404 status", missing_status == 404, str(missing_status))

    check_static_asset(page, "/images/og-image.png", "image/png")
    check_static_asset(page, "/images/blog/cupertino-first-light/hero.jpg", "image/jpeg")
    check_static_asset(page, "/images/logo.svg", "image/svg+xml")
    check_static_asset(page, "/Mihaela_Mihaljevic_Jakic_CV.pdf", "application/pdf")

    check_navigation(page)
    check_theme_behavior_if_present(page)
    check_feed_and_sitemap(page)

    for path, target in [
        ("/blog/", "/"),
        ("/home/", "/"),
        ("/rss/", "/rss.xml"),
        ("/c-v-page/", "/blog/c-v-builder/"),
        ("/TokenMiddeware/", "/blog/token-middleware/"),
        ("/TokenMiddleware/", "/blog/token-middleware/"),
        ("/contact/", "/about/"),
        ("/consulting/", "/services/"),
    ]:
        check_redirect(nojs_page, path, target)

    for path, target in [
        ("/cvbuilder/", "/blog/c-v-builder/"),
        ("/loggingmiddleware/", "/blog/logging-middleware/"),
        ("/tag/swift/", "/"),
        ("/posts/cupertino-first-light/", "/"),
    ]:
        check_404_script_redirect(page, path, target)


def print_results():
    failed = [(name, detail) for name, ok, detail in results if not ok]
    for name, ok, detail in results:
        status = "PASS" if ok else "FAIL"
        suffix = f" - {detail}" if detail else ""
        print(f"{status}: {name}{suffix}")
    if failed:
        print(f"\n{len(failed)} browser checks failed.", file=sys.stderr)
        return 1
    print(f"\nAll {len(results)} browser checks passed.")
    return 0


def main():
    if not (ROOT / "index.html").is_file():
        print(f"Site root does not contain index.html: {ROOT}", file=sys.stderr)
        return 1

    with sync_playwright() as playwright:
        browser = playwright.chromium.launch()
        context = browser.new_context(ignore_https_errors=True)
        install_routes(context)
        nojs_context = browser.new_context(ignore_https_errors=True, java_script_enabled=False)
        install_routes(nojs_context)
        try:
            run_checks(context.new_page(), nojs_context.new_page())
        finally:
            browser.close()

    return print_results()


if __name__ == "__main__":
    sys.exit(main())
