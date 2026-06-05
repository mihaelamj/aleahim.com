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


SITE_RELEASE_TAG = latest_release_tag()
