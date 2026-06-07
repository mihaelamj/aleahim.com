#!/usr/bin/env python3
"""Verify the TileDown migration source preserves Toucan content metadata."""

from pathlib import Path
import sys

from tiledown_site import SITE_RELEASE_TAG, TOUCAN_ANALYTICS_HEAD


ROOT = Path(__file__).resolve().parents[1]
TOUCAN = ROOT / "contents"
TILEDOWN = ROOT / "TileDown" / "content"
results = []


def check(name, ok, detail=""):
    results.append((name, bool(ok), detail))


def split_front_matter(path):
    lines = path.read_text().splitlines()
    if not lines or lines[0] != "---":
        raise ValueError(f"{path} has no front matter")
    for index in range(1, len(lines)):
        if lines[index] == "---":
            return lines[1:index]
    raise ValueError(f"{path} has unterminated front matter")


def normalized_scalar(value):
    value = value.strip()
    if len(value) >= 2 and value[0] == value[-1] and value[0] in {"'", "\""}:
        inner = value[1:-1]
        if value[0] == "\"":
            return inner.replace("\\\"", "\"")
        return inner.replace("''", "'")
    return value


def front_matter(path):
    values = {}
    skip_indent = False
    for line in split_front_matter(path):
        if not line.strip():
            continue
        if line.startswith((" ", "\t")):
            if skip_indent:
                continue
            raise ValueError(f"{path} has nested front matter outside a skipped block")
        skip_indent = False
        if line.startswith("views:"):
            skip_indent = True
            values["views"] = ""
            continue
        if ":" not in line:
            raise ValueError(f"{path} has unsupported front matter line: {line}")
        key, value = line.split(":", 1)
        values[key.strip()] = normalized_scalar(value)
    return values


def require_file(path):
    check(f"{path.relative_to(ROOT)} exists", path.is_file())
    return path.is_file()


def compare_keys(source, destination, keys):
    if not require_file(destination):
        return
    source_values = front_matter(source)
    destination_values = front_matter(destination)
    check(
        f"{destination.relative_to(ROOT)} has no Toucan views override",
        "views" not in destination_values,
    )
    for key in keys:
        ok = source_values.get(key) == destination_values.get(key)
        check(
            f"{destination.relative_to(ROOT)} preserves {key}",
            ok,
            "" if ok else f"{source_values.get(key)!r} != {destination_values.get(key)!r}",
        )


def check_pages():
    compare_keys(
        TOUCAN / "[home]" / "index.md",
        TILEDOWN / "index.md",
        ["slug", "title", "description", "hero"],
    )
    home_values = front_matter(TILEDOWN / "index.md")
    check("home maps Toucan blog view to TileDown latest posts", home_values.get("latest") == "true")
    for name in ["about", "speaking"]:
        compare_keys(
            TOUCAN / name / "index.md",
            TILEDOWN / name / "index.md",
            ["slug", "title", "description", "image"],
        )
    compare_keys(
        TOUCAN / "404" / "index.md",
        TILEDOWN / "404" / "index.md",
        ["title", "description", "type"],
    )
    blog_values = front_matter(TILEDOWN / "blog" / "index.md")
    check("Blog landing page exists", blog_values.get("slug") == "blog")
    check("Blog landing page lists posts", blog_values.get("postList") == "true")
    check("Blog landing page opts into tag bar", blog_values.get("tagBar") == "true")


def check_posts():
    source_posts = sorted((TOUCAN / "blog").glob("*/index.md"))
    destination_posts = sorted((TILEDOWN / "blog").glob("*/index.md"))
    check("all blog posts converted", len(source_posts) == len(destination_posts), str(len(destination_posts)))
    for source in source_posts:
        destination = TILEDOWN / "blog" / source.parent.name / "index.md"
        compare_keys(
            source,
            destination,
            ["slug", "title", "description", "date", "draft", "image"],
        )
        values = front_matter(destination)
        check(
            f"{destination.relative_to(ROOT)} has generated tags",
            bool(values.get("tags") or values.get("tag")),
        )
        if values.get("draft") == "true":
            output = ROOT / "TileDown" / "dist" / values["slug"] / "index.html"
            check(f"draft excluded from output: {values['slug']}", not output.exists())


def check_redirects():
    redirect_sources = sorted(
        source
        for source in (TOUCAN / "redirects").glob("*/index.md")
        if source.parent.name != "blog-root"
    )
    check(
        "legacy /blog/ redirect is replaced by Blog landing page",
        not (TILEDOWN / "redirects" / "blog-root" / "index.md").exists(),
    )
    for source in redirect_sources:
        destination = TILEDOWN / "redirects" / source.parent.name / "index.md"
        compare_keys(source, destination, ["type", "slug"])
        values = front_matter(destination)
        check(
            f"{destination.relative_to(ROOT)} has absolute redirect target",
            values.get("to", "").startswith(("https://", "mailto:")),
            values.get("to", ""),
        )
    compare_keys(
        TOUCAN / "services" / "index.md",
        TILEDOWN / "services" / "index.md",
        ["type", "slug"],
    )


def check_config():
    config = (TILEDOWN / "tiledown.yml").read_text()
    check("TileDown config titles site as Aleahim.com", "title: Aleahim.com" in config)
    check("TileDown postsDir preserves /blog/ routes", "postsDir: blog" in config)
    check("TileDown nav labels posts as Blog", "postsLabel: Blog" in config)
    check("TileDown config keeps site release tag", f"versionName: {SITE_RELEASE_TAG}" in config)
    check("TileDown config keeps GitHub avatar favicon", "favicon: /favicon.ico" in config)
    check(
        "TileDown config ports Toucan analytics exactly",
        f"analytics.head: {TOUCAN_ANALYTICS_HEAD}" in config,
    )
    check("TileDown config maps .nojekyll", "static..nojekyll: deployment/.nojekyll" in config)


def check_static_assets():
    for relative in [
        "CNAME",
        "robots.txt",
        "favicon.ico",
        "deployment/.nojekyll",
        "Mihaela_Mihaljevic_Jakic_CV.pdf",
        "assets/Mihaela_Mihaljevic_Jakic_CV.pdf",
        "images/logo.png",
        "images/og-image.png",
        "images/blog/cupertino-first-light/hero.jpg",
        "css/style.css",
    ]:
        require_file(TILEDOWN / relative)


def check_body_conversions():
    irelay = (TILEDOWN / "blog" / "irelay" / "index.md").read_text()
    check("YouTube iframe converted to embed tile", ":::tile embed" in irelay)
    check("raw YouTube iframe removed from content", "<iframe" not in irelay)

    home = (TILEDOWN / "index.md").read_text()
    check("stale hard-coded Latest line removed", "Latest:" not in home)
    check("home places dynamic recent posts", ":::recent:::" in home)


def print_results():
    failed = [(name, detail) for name, ok, detail in results if not ok]
    for name, ok, detail in results:
        marker = "PASS" if ok else "FAIL"
        suffix = f" - {detail}" if detail else ""
        print(f"{marker}: {name}{suffix}")
    if failed:
        print(f"\n{len(failed)} TileDown content check(s) failed.", file=sys.stderr)
        return 1
    print(f"\nAll {len(results)} TileDown content checks passed.")
    return 0


def main():
    try:
        check_config()
        check_pages()
        check_posts()
        check_redirects()
        check_static_assets()
        check_body_conversions()
    except Exception as error:
        print(f"content check failed: {error}", file=sys.stderr)
        return 1
    return print_results()


if __name__ == "__main__":
    sys.exit(main())
