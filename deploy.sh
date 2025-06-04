#!/bin/bash
set -e

echo "🚧 Running Ignite build..."
cd sitebuilder
ignite build
cd ..

echo "🚚 Deploying sitebuilder/Build/ to repo root..."
rsync -av --delete sitebuilder/Build/ . \
  --exclude .git \
  --exclude sitebuilder \
  --exclude README.md \
  --exclude .gitignore \
  --exclude .swiftpm \
  --exclude deploy.sh \
  --exclude CNAME \
  --exclude .nojekyll

echo "✅ Deploy complete! Review changes and push when ready."