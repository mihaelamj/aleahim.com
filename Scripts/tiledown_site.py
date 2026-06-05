"""Shared production site settings for the TileDown migration."""

from pathlib import Path
import os
import re
import subprocess

SITE_DOMAIN = "aleahim.com"
SITE_URL = f"https://{SITE_DOMAIN}"
ROOT = Path(__file__).resolve().parents[1]

_RELEASE_TAG_PATTERN = re.compile(r"^v\d+(?:\.\d+)*(?:[-+][0-9A-Za-z.-]+)?$")
_RELEASE_TAG_FALLBACK = "v1.17"
_ANALYTICS_SCRIPT_PATTERN = re.compile(
    r"""<script\b[^>]*\bsrc=["']https://cloud\.umami\.is/script\.js["'][^>]*>\s*</script>""",
)


def _is_release_tag(value):
    return bool(_RELEASE_TAG_PATTERN.match(value))


def _release_tag_from_environment():
    for name in ["ALEAHIM_RELEASE_TAG", "GITHUB_REF_NAME"]:
        value = os.environ.get(name, "").strip()
        if _is_release_tag(value):
            return value
    return ""


def _release_tag_from_git():
    try:
        output = subprocess.check_output(
            ["git", "tag", "--list", "v*", "--sort=-version:refname"],
            cwd=ROOT,
            text=True,
            stderr=subprocess.DEVNULL,
        )
    except (OSError, subprocess.CalledProcessError):
        return ""

    for line in output.splitlines():
        tag = line.strip()
        if _is_release_tag(tag):
            return tag
    return ""


def latest_release_tag():
    return _release_tag_from_environment() or _release_tag_from_git() or _RELEASE_TAG_FALLBACK


def toucan_analytics_head():
    template = ROOT / "templates" / "overrides" / "default" / "views" / "html.mustache"
    lines = template.read_text().splitlines()
    for index, line in enumerate(lines):
        if "cloud.umami.is/script.js" not in line:
            continue
        script = line.strip()
        if not _ANALYTICS_SCRIPT_PATTERN.fullmatch(script):
            raise ValueError(f"Unexpected Toucan analytics script in {template}")

        previous = ""
        for prior in reversed(lines[:index]):
            stripped = prior.strip()
            if not stripped:
                continue
            if stripped.startswith("<!--") and stripped.endswith("-->") and "Analytics" in stripped:
                previous = stripped
            break
        return f"{previous}{script}" if previous else script

    raise ValueError(f"Toucan analytics script not found in {template}")


SITE_RELEASE_TAG = latest_release_tag()
TOUCAN_ANALYTICS_HEAD = toucan_analytics_head()
