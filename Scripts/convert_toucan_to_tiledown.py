#!/usr/bin/env python3
"""Convert the committed Toucan source tree into TileDown source."""

from pathlib import Path
import re
import shutil
import sys

from tiledown_site import SITE_DOMAIN, SITE_URL


ROOT = Path(__file__).resolve().parents[1]
TOUCAN = ROOT / "contents"
OUTPUT = ROOT / "TileDown" / "content"
GENERATOR_PACKAGE_PATH = ROOT.as_posix()


CONFIG = f"""title: Aleahim
baseURL: {SITE_URL}
layout: top-nav
theme: system
appearance: toggle
postsDir: blog
postsLabel: Blog
fontScale: 1.1
rss: true
rssPath: rss.xml
rssTitle: Aleahim
rssDescription: Technical articles on Swift, OpenAPI, and iOS development by Mihaela Mihaljevic.
shareLinks: true
social.github: https://github.com/mihaelamj
social.linkedin: https://www.linkedin.com/in/mihaelamj
analytics.head: <script defer src="https://cloud.umami.is/script.js" data-website-id="1ee8d39f-4184-4d60-89a3-13131860112a"></script>
generate.cv: swift run --package-path {GENERATOR_PACKAGE_PATH} GenerateCV --output cv/index.md
static..nojekyll: deployment/.nojekyll
"""

IFRAME_RE = re.compile(r"""<iframe\b(?P<attrs>[^>]*)>\s*</iframe>""", re.IGNORECASE)
ATTR_RE = re.compile(r"""([A-Za-z_:][-A-Za-z0-9_:.]*)\s*=\s*["']([^"']*)["']""")


def split_front_matter(text):
    lines = text.splitlines(keepends=True)
    if not lines or lines[0].strip() != "---":
        return [], lines
    for index in range(1, len(lines)):
        if lines[index].strip() == "---":
            return lines[1:index], lines[index + 1 :]
    raise ValueError("unterminated front matter")


def strip_toucan_views(lines):
    result = []
    index = 0
    while index < len(lines):
        line = lines[index]
        if line.startswith("views:"):
            index += 1
            while index < len(lines) and (
                lines[index].startswith(" ") or lines[index].strip() == ""
            ):
                index += 1
            continue
        result.append(line)
        index += 1
    return result


def normalized_scalar(value):
    value = value.strip()
    if len(value) >= 2 and value[0] == value[-1] and value[0] in {"'", "\""}:
        inner = value[1:-1]
        if value[0] == "\"":
            return inner.replace("\\\"", "\"")
        return inner.replace("''", "'")
    return value


def normalize_front_matter_scalars(lines):
    normalized = []
    for line in lines:
        if ":" not in line or line.startswith((" ", "\t")):
            normalized.append(line)
            continue
        key, value = line.split(":", 1)
        value = normalized_scalar(value)
        if value:
            normalized.append(f"{key}: {value}\n")
        else:
            normalized.append(f"{key}:\n")
    return normalized


def strip_trailing_markdown_whitespace(lines):
    return [
        line.rstrip(" \t\r\n") + ("\n" if line.endswith("\n") else "")
        for line in lines
    ]


def ensure_field(lines, field):
    key = field.split(":", 1)[0] + ":"
    if any(line.startswith(key) for line in lines):
        return lines
    return lines + [field + "\n"]


def iframe_embed_lines(line):
    match = IFRAME_RE.search(line.strip())
    if not match:
        return None

    attrs = {
        key.lower(): value
        for key, value in ATTR_RE.findall(match.group("attrs"))
    }
    src = attrs.get("src", "")
    if "youtube.com/embed/" not in src and "youtube-nocookie.com/embed/" not in src:
        return None

    width = attrs.get("width", "16")
    height = attrs.get("height", "9")
    if not width.isdigit() or not height.isdigit():
        width, height = "16", "9"

    return [
        ":::tile embed\n",
        f"url: {src}\n",
        "title: Demo video\n",
        f"aspectRatio: {width}/{height}\n",
        ":::\n",
    ]


def recent_posts_replacement(line):
    stripped = line.strip()
    followup = "See [Speaking](/speaking/) and [Hire me](https://codeweaver.info/)."
    marker = " Also see "
    if marker in stripped:
        tail = stripped.split(marker, 1)[1].rstrip(".")
        followup = f"See {tail}."
    return [
        "## Recent posts\n",
        "\n",
        ":::recent:::\n",
        "\n",
        followup + "\n",
    ]


def convert_body(lines, *, latest=False):
    converted = []
    for line in lines:
        if latest and line.startswith("Latest:"):
            converted.extend(recent_posts_replacement(line))
            continue
        embed_lines = iframe_embed_lines(line)
        if embed_lines is None:
            converted.append(line)
        else:
            converted.extend(embed_lines)
            if not line.endswith("\n"):
                converted.append("\n")
    return converted


def write_markdown(source, destination, *, latest=False):
    text = source.read_text()
    front_matter, body = split_front_matter(text)
    front_matter = strip_toucan_views(front_matter)
    front_matter = normalize_front_matter_scalars(front_matter)
    body = convert_body(body, latest=latest)
    if latest:
        front_matter = ensure_field(front_matter, "latest: true")
    front_matter = strip_trailing_markdown_whitespace(front_matter)
    body = strip_trailing_markdown_whitespace(body)
    destination.parent.mkdir(parents=True, exist_ok=True)
    destination.write_text("---\n" + "".join(front_matter) + "---\n" + "".join(body))


def redirect_target(raw_target):
    target = raw_target.strip()
    if not target:
        return SITE_URL + "/"
    if target.startswith(("http://", "https://", "mailto:")):
        return target
    if not target.startswith("/"):
        target = "/" + target
    if not target.endswith("/") and "." not in target.rsplit("/", 1)[-1]:
        target += "/"
    return SITE_URL + target


def convert_redirect(source, destination):
    text = source.read_text()
    front_matter, body = split_front_matter(text)
    converted = []
    for line in front_matter:
        if line.startswith("to:"):
            converted.append("to: " + redirect_target(line.split(":", 1)[1]) + "\n")
        elif line.startswith("external:"):
            continue
        else:
            converted.append(line)
    converted = normalize_front_matter_scalars(converted)
    converted = strip_trailing_markdown_whitespace(converted)
    body = strip_trailing_markdown_whitespace(body)
    destination.parent.mkdir(parents=True, exist_ok=True)
    destination.write_text("---\n" + "".join(converted) + "---\n" + "".join(body))


def copy_tree_files(source_root, destination_root):
    for source in sorted(source_root.rglob("index.md")):
        relative = source.relative_to(source_root)
        write_markdown(source, destination_root / relative)


def ignored_names(_directory, names):
    return {name for name in names if name == ".DS_Store"}


def copy_optional_tree(source, destination):
    if not source.is_dir():
        return
    if destination.exists():
        shutil.rmtree(destination)
    shutil.copytree(source, destination, ignore=ignored_names)


def copy_optional_file(source, destination):
    if not source.is_file():
        return
    destination.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(source, destination)


def copy_static_assets():
    copy_optional_tree(ROOT / "images", OUTPUT / "images")
    copy_optional_tree(ROOT / "css", OUTPUT / "css")
    write_deployment_files()
    copy_optional_file(
        ROOT / "Mihaela_Mihaljevic_Jakic_CV.pdf",
        OUTPUT / "Mihaela_Mihaljevic_Jakic_CV.pdf",
    )
    copy_optional_file(
        ROOT / "Mihaela_Mihaljevic_Jakic_CV.pdf",
        OUTPUT / "assets" / "Mihaela_Mihaljevic_Jakic_CV.pdf",
    )


def write_deployment_files():
    (OUTPUT / "CNAME").write_text(SITE_DOMAIN + "\n")
    (OUTPUT / "robots.txt").write_text(
        "User-agent: *\n"
        "Allow: /\n"
        "\n"
        f"Sitemap: {SITE_URL}/sitemap.xml\n"
    )
    deployment = OUTPUT / "deployment"
    deployment.mkdir(parents=True, exist_ok=True)
    (deployment / ".nojekyll").write_text("")


def convert():
    if not TOUCAN.is_dir():
        raise FileNotFoundError(TOUCAN)
    if OUTPUT.exists():
        shutil.rmtree(OUTPUT)
    OUTPUT.mkdir(parents=True)
    (OUTPUT / "tiledown.yml").write_text(CONFIG)

    write_markdown(TOUCAN / "[home]" / "index.md", OUTPUT / "index.md", latest=True)
    for name in ["404", "about", "cv", "speaking"]:
        write_markdown(TOUCAN / name / "index.md", OUTPUT / name / "index.md")
    copy_tree_files(TOUCAN / "blog", OUTPUT / "blog")
    convert_redirect(TOUCAN / "services" / "index.md", OUTPUT / "services" / "index.md")
    for source in sorted((TOUCAN / "redirects").rglob("index.md")):
        relative = source.relative_to(TOUCAN / "redirects")
        convert_redirect(source, OUTPUT / "redirects" / relative)
    copy_static_assets()


def main():
    try:
        convert()
    except Exception as error:
        print(f"conversion failed: {error}", file=sys.stderr)
        return 1
    print(f"Converted Toucan source into {OUTPUT.relative_to(ROOT)}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
