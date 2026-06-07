SHELL=/bin/bash
TILEDOWN_REPO ?= ../TileDown/tile-down
TILEDOWN ?= swift run --package-path $(TILEDOWN_REPO)/Packages tiledown
TILEDOWN_PREVIEW_CONTENT ?= /tmp/aleahim-tiledown-preview-content
TILEDOWN_PREVIEW_SITE ?= /tmp/aleahim-tiledown-preview-site
TILEDOWN_PREVIEW_PORT ?= 8098

# brew install optipng jpegoptim

dev:
	toucan generate --target dev

dist:
	toucan generate --target live

diff:
	diff --color=always -r dist-prev dist --exclude=api || true

watch:
	toucan watch .

serve:
	toucan serve ./dist -p 3000

tiledown-content:
	python3 Scripts/convert_toucan_to_tiledown.py

tiledown-content-check: tiledown-content
	python3 Scripts/check_tiledown_content.py

tiledown-build: tiledown-content
	rm -rf TileDown/dist
	$(TILEDOWN) build-site TileDown/content TileDown/dist

tiledown-doctor: tiledown-content
	$(TILEDOWN) doctor --publish --run-generators TileDown/content

tiledown-output-check: tiledown-build
	python3 Scripts/check_tiledown_output.py

tiledown-check: tiledown-content-check tiledown-doctor tiledown-build
	python3 Scripts/check_tiledown_output.py

tiledown-preview-build: tiledown-content
	rm -rf "$(TILEDOWN_PREVIEW_CONTENT)" "$(TILEDOWN_PREVIEW_SITE)"
	cp -R TileDown/content "$(TILEDOWN_PREVIEW_CONTENT)"
	perl -0pi -e 's#^baseURL:.*\n##m' "$(TILEDOWN_PREVIEW_CONTENT)/tiledown.yml"
	$(TILEDOWN) build-site "$(TILEDOWN_PREVIEW_CONTENT)" "$(TILEDOWN_PREVIEW_SITE)"

tiledown-preview: tiledown-preview-build
	cd "$(TILEDOWN_PREVIEW_SITE)" && python3 -m http.server "$(TILEDOWN_PREVIEW_PORT)"

png:
	find ./* -type f -name '*.png' -exec optipng -o7 {} \;

jpg:
	find ./* -type f -name '*.jpg' | xargs jpegoptim --all-progressive '*.jpg'
