#!/usr/bin/env bash
# Run Aleahim browser acceptance checks against the committed static output.
#
# This intentionally uses Python Playwright, not Node tooling. The test harness
# intercepts https://aleahim.com/* in Chromium and serves files from this
# repository, so absolute production URLs are exercised without hitting the
# network.
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo="$(cd "$here/../.." && pwd)"
python="${PYTHON:-python3}"

run_with_python() {
  SITE_ROOT="$repo" "$python" "$here/test_site.py"
}

if "$python" - <<'PY' >/dev/null 2>&1
import playwright.sync_api
PY
then
  run_with_python
elif command -v uv >/dev/null 2>&1; then
  SITE_ROOT="$repo" uv run --with playwright python "$here/test_site.py"
else
  echo "Python Playwright is not installed. Install it for $python, or install uv for the ephemeral Playwright runner." >&2
  exit 1
fi
