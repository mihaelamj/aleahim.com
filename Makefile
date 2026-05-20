SHELL=/bin/bash

# brew install optipng jpegoptim

cv:
	swift run GenerateCV

dev: cv
	toucan generate --target dev

dist:
	toucan generate --target live

diff:
	diff --color=always -r dist-prev dist --exclude=api || true

watch:
	toucan watch .

serve:
	toucan serve ./dist -p 3000

png:
	find ./* -type f -name '*.png' -exec optipng -o7 {} \;

jpg:
	find ./* -type f -name '*.jpg' | xargs jpegoptim --all-progressive '*.jpg'

# Sync cupertino's search-quality dashboards into cupertino/quality/.
# Source of truth is mihaelamj/cupertino — this directory is a deployed
# mirror, not editable from here. Re-run on every cupertino release.
sync-cupertino:
	@test -d ../cupertino/docs/dashboards || \
		(echo "expected sibling repo at ../cupertino with docs/dashboards/"; exit 1)
	rsync -a --delete \
		--exclude '__pycache__' --exclude '*.py' --exclude '*.sh' \
		--exclude '_index_extras.json' --exclude '*-blog-embed.html' \
		../cupertino/docs/dashboards/ cupertino/quality/
	@echo "Synced ../cupertino/docs/dashboards/ → cupertino/quality/"
	@echo "Next: git add cupertino/quality/ && git commit && git push"
