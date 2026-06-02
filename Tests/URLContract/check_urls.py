#!/usr/bin/env python3
"""Check the committed Aleahim public URL contract."""

from pathlib import Path
import re
import sys


ROOT = Path(__file__).resolve().parents[2]
DOC = ROOT / "examples" / "current-public-url-contract.md"
ORIGIN = "https://aleahim.com"
results = []


def check(name, ok, detail=""):
    results.append((name, bool(ok), detail))


def section(name):
    text = DOC.read_text()
    marker = f"## {name}"
    start = text.index(marker)
    next_section = text.find("\n## ", start + len(marker))
    if next_section == -1:
        return text[start:]
    return text[start:next_section]


def table_rows_from_text(text):
    rows = []
    for line in text.splitlines():
        line = line.strip()
        if not line.startswith("|") or "---" in line:
            continue
        cells = [cell.strip() for cell in line.strip("|").split("|")]
        if cells and cells[0] not in {"Route", "Current Route", "Legacy Path", "Legacy Prefix"}:
            rows.append(cells)
    return rows


def table_rows(section_name):
    return table_rows_from_text(section(section_name))


def code_values(text):
    return re.findall(r"`([^`]+)`", text)


def route_pairs(section_name):
    return [
        (code_values(route_cell)[0], code_values(url_cell)[0])
        for route_cell, url_cell in table_rows(section_name)
    ]


def route_file(route):
    if route == "/":
        return ROOT / "index.html"
    if route.endswith((".html", ".xml", ".txt", ".pdf")):
        return ROOT / route.lstrip("/")
    if route.endswith("/"):
        return ROOT / route.lstrip("/") / "index.html"
    return ROOT / route.lstrip("/")


def html(route):
    path = route_file(route)
    if not path.is_file():
        return ""
    return path.read_text(errors="replace")


def check_canonical_route(route, canonical):
    path = route_file(route)
    check(f"{route} file exists", path.is_file(), str(path.relative_to(ROOT)))
    if path.suffix == ".html":
        page = html(route)
        expected = f'<link rel="canonical" href="{canonical}">'
        check(f"{route} canonical", expected in page, canonical)


def check_primary_and_blog_routes():
    for route, canonical in route_pairs("Primary Routes"):
        check_canonical_route(route, canonical)
    for route, canonical in route_pairs("Blog Routes"):
        check_canonical_route(route, canonical)


def check_other_routes():
    for route_cell, _state in table_rows("Other Published Routes"):
        route = code_values(route_cell)[0]
        path = route_file(route)
        check(f"{route} published route exists", path.is_file(), str(path.relative_to(ROOT)))


def check_root_files():
    for route_cell, _shape in table_rows("Generated Feed And Index Files"):
        route = code_values(route_cell)[0]
        path = route_file(route)
        check(f"{route} root file exists", path.is_file(), str(path.relative_to(ROOT)))
    rss = (ROOT / "rss.xml").read_text(errors="replace")
    sitemap = (ROOT / "sitemap.xml").read_text(errors="replace")
    check("RSS uses production origin", f"<link>{ORIGIN}/</link>" in rss)
    check("sitemap uses production origin", f"<loc>{ORIGIN}/</loc>" in sitemap)
    for route, canonical in route_pairs("Primary Routes"):
        if route != "/404.html":
            check(f"{route} sitemap loc", f"<loc>{canonical}</loc>" in sitemap, canonical)
    for route, canonical in route_pairs("Blog Routes"):
        check(f"{route} RSS item link", f"<link>{canonical}</link>" in rss, canonical)
        check(f"{route} RSS item guid", f"<guid isPermaLink=\"true\">{canonical}</guid>" in rss, canonical)
        check(f"{route} sitemap loc", f"<loc>{canonical}</loc>" in sitemap, canonical)


def check_static_redirect_pages():
    for route_cell, target_cell in table_rows("Static Redirect Pages"):
        route = code_values(route_cell)[0]
        target = code_values(target_cell)[0]
        path = route_file(route)
        page = html(route)
        check(f"{route} redirect file exists", path.is_file(), str(path.relative_to(ROOT)))
        check(f"{route} redirect target", target in page, target)


def check_404_redirect_entries():
    page = (ROOT / "404.html").read_text(errors="replace")
    redirect_section = section("404 Script Redirects")
    exact_text = redirect_section.split("Prefix mappings:", 1)[0]
    exact_text = exact_text.split("Exact mappings:", 1)[-1]
    prefix_text = redirect_section.split("Prefix mappings:", 1)[1]

    for source_cell, target_cell in table_rows_from_text(exact_text):
        sources = code_values(source_cell)
        targets = code_values(target_cell)
        if not targets:
            continue
        target = targets[0]
        for source in sources:
            check(f"404 exact redirect has {source}", source in page, source)
        check(f"404 exact redirect target {target}", target in page, target)

    for source_cell, target_cell in table_rows_from_text(prefix_text):
        source = code_values(source_cell)[0]
        target = code_values(target_cell)[0]
        check(f"404 prefix redirect has {source}", source in page, source)
        check(f"404 prefix redirect target {target}", target in page, target)


def print_results():
    failed = [(name, detail) for name, ok, detail in results if not ok]
    for name, ok, detail in results:
        marker = "PASS" if ok else "FAIL"
        suffix = f" - {detail}" if detail else ""
        print(f"{marker}: {name}{suffix}")
    if failed:
        print(f"\n{len(failed)} URL contract check(s) failed.", file=sys.stderr)
        return 1
    print(f"\nAll {len(results)} URL contract checks passed.")
    return 0


def main():
    check_primary_and_blog_routes()
    check_other_routes()
    check_root_files()
    check_static_redirect_pages()
    check_404_redirect_entries()
    return print_results()


if __name__ == "__main__":
    sys.exit(main())
