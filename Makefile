SHELL=/bin/bash
TILEDOWN_REPO ?= ../TileDown/tile-down
TILEDOWN ?= swift run --package-path $(TILEDOWN_REPO)/Packages tiledown
TILEDOWN_PREVIEW_CONTENT ?= /tmp/aleahim-tiledown-preview-content
TILEDOWN_PREVIEW_SITE ?= /tmp/aleahim-tiledown-preview-site
TILEDOWN_PREVIEW_PORT ?= 8098

# brew install optipng jpegoptim
#
# The site is authored under TileDown/content and built by the TileDown engine
# (../TileDown/tile-down).

tiledown-build:
	rm -rf TileDown/dist
	$(TILEDOWN) build-site TileDown/content TileDown/dist

tiledown-doctor:
	$(TILEDOWN) doctor --publish TileDown/content

tiledown-check: tiledown-build tiledown-doctor
	@items=$$(grep -c '<item>' TileDown/dist/rss.xml); enc=$$(grep -c '<content:encoded>' TileDown/dist/rss.xml); \
	  test "$$items" = "$$enc" || { echo "RSS full-text mismatch: $$items items, $$enc content:encoded"; exit 1; }; \
	  echo "RSS OK: $$items items, all full-text"
	@test "$$(grep -c localhost TileDown/dist/index.html)" = "0" || { echo "localhost leaked into index.html"; exit 1; }
	@echo "tiledown-check OK"

tiledown-preview:
	rm -rf "$(TILEDOWN_PREVIEW_CONTENT)" "$(TILEDOWN_PREVIEW_SITE)"
	cp -R TileDown/content "$(TILEDOWN_PREVIEW_CONTENT)"
	perl -0pi -e 's#^baseURL:.*\n##m' "$(TILEDOWN_PREVIEW_CONTENT)/tiledown.yml"
	$(TILEDOWN) build-site "$(TILEDOWN_PREVIEW_CONTENT)" "$(TILEDOWN_PREVIEW_SITE)"
	cd "$(TILEDOWN_PREVIEW_SITE)" && python3 -m http.server "$(TILEDOWN_PREVIEW_PORT)"

png:
	find ./* -type f -name '*.png' -exec optipng -o7 {} \;

jpg:
	find ./* -type f -name '*.jpg' | xargs jpegoptim --all-progressive '*.jpg'
