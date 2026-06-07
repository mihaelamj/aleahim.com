---
name: aleahim-new-post
description: Scaffold, hero-image, build, and deploy a new blog post on aleahim.com (TileDown + GitHub Pages). Pauses to generate an Apple Creator Studio image prompt matched to the post topic, waits for the Keynote-exported PNG/JPG in ~/Downloads, then builds with the TileDown engine and deploys. Use when the user asks to "new blog post", "publish to aleahim", "add post", "ship blog post", "create blog post <title>", or hands you a draft markdown file/path to publish.
argument-hint: <draft.md path | "Post Title">
---

# aleahim-new-post

End-to-end workflow for a new aleahim.com post. The site is built with the TileDown
engine: content is authored under `TileDown/content/` and built into the repo root,
which GitHub Pages serves. There is no generator step and no conversion.

## 0. Always do first — repo guard

```bash
ROOT="$(git rev-parse --show-toplevel 2>/dev/null)" || { echo "abort: not in a git repo"; exit 1; }
cd "$ROOT"
git remote get-url origin | grep -q "github.com[:/]mihaelamj/aleahim.com" \
  || { echo "abort: origin is not github.com:mihaelamj/aleahim.com"; exit 1; }
test -z "$(git status --porcelain | grep -v '^??')" \
  || { echo "abort: working tree has uncommitted modifications"; git status --short; exit 1; }
test -d "${TILEDOWN_REPO:-../TileDown/tile-down}/Packages" \
  || { echo "abort: TileDown engine not at ${TILEDOWN_REPO:-../TileDown/tile-down}; set TILEDOWN_REPO"; exit 1; }
```

Every subsequent step assumes pwd is the aleahim.com repo root and the tree is clean.

## Inputs

- Path to a draft markdown file, OR a title + body pasted in chat, OR a brief.
  Ask before drafting; never invent technical content.

Always confirm: slug, title, description, date (default today), tags, body source.

## Slug + paths

- Slug = kebab-case from the title unless the user provides one.
- Post: `TileDown/content/blog/<slug>/index.md`
- Images: `TileDown/content/images/blog/<slug>/`, hero at `hero.<ext>` (PNG or JPG,
  matching the source; no recompression beyond optional optimisation).

## Frontmatter template

```yaml
---
slug: blog/<slug>
title: "<Title>"
description: <one-line listing description, no period, no em dashes>
date: <YYYY-MM-DD>
image: /images/blog/<slug>/hero.<ext>
draft: false
tags: <Tag, Tag>
---
```

`slug:` MUST be `blog/<slug>`. The `image:` extension must match the hero file.
Start the body with `# <Title>` (an H1 matching the frontmatter title), then the post.

## Workflow

Speak each major step: `say -v "Ava" "Ava: <8-word update>"`. Bash blocks abort on non-zero exit.

### 1. Confirm inputs

Print proposed slug, title, description, date, tags. Wait for confirmation. If the
slug collides:
```bash
test ! -d "TileDown/content/blog/<slug>" || { echo "abort: blog/<slug> exists, ask before overwriting"; exit 1; }
```

### 2. Scaffold post

```bash
mkdir -p "TileDown/content/blog/<slug>" "TileDown/content/images/blog/<slug>"
```
Write `TileDown/content/blog/<slug>/index.md` with the frontmatter block above and
the body. No em dashes (commas, colons, periods only).

### 3. Generate Apple Creator Studio prompt

Read the body. Pick a style by topic:

| Post type | Style |
|---|---|
| Release / launch / version bump | Bold |
| Technical deep-dive / architecture | Illustration |
| Product showcase / feature demo | Photorealistic |
| Reflective / personal / process | Watercolor |
| Code / diagram / system flow | Line |
| Numbers / performance / benchmark | Bold |
| Tutorial / how-to / explanatory | Illustration |

Always: View = Any, Aspect = Landscape (16:9). Image model: OpenAI (ChatGPT) via
Apple Creator Studio in Keynote. The model reads style from the prompt text, so
fold the style word into one rich free-form paragraph, no text, no logos, no
readable letters.

Output in this exact block:

```
HERO IMAGE PROMPT (Apple Creator Studio)
────────────────────────────────────────
Style:   <picked style> (folded into the prompt)
View:    Any
Aspect:  Landscape (16:9)
Model:   OpenAI (ChatGPT)

Prompt:
<one rich free-form paragraph. Subject, mood, colour cues, composition. Fold the
style word into the sentence. No text, no logos, no readable letters. Reference
the post's central concrete idea. No em dashes.>

Why this style: <one sentence>
────────────────────────────────────────

Next: in Keynote, insert an image via Apple Creator Studio → OpenAI (ChatGPT)
model → paste the Prompt → generate → place on a 16:9 slide → export PNG/JPG to
~/Downloads. Then tell me "image ready" (or "use <filename>").
```

HARD PAUSE. Speak: `say -v "Ava" "Ava: Prompt ready. Waiting for hero image."`

### 4. Pick up the image

```bash
CANDIDATE=$(find ~/Downloads -maxdepth 1 -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" \) -mmin -1440 -print0 \
  | xargs -0 ls -t 2>/dev/null | head -1)
test -n "$CANDIDATE" || { echo "abort: no recent png/jpg in ~/Downloads"; exit 1; }
echo "Candidate: $CANDIDATE"
```
On confirmation, preserve the source format:
```bash
SRC="<confirmed source path>"
case "$SRC" in
  *.png|*.PNG) EXT="png" ;;
  *.jpg|*.jpeg|*.JPG|*.JPEG) EXT="jpg" ;;
  *) echo "abort: unsupported source extension ($SRC)"; exit 1 ;;
esac
DEST="TileDown/content/images/blog/<slug>/hero.$EXT"
cp "$SRC" "$DEST" || { echo "abort: cp failed"; exit 1; }
sed -i "" "s|^image: /images/blog/<slug>/hero\\.[a-z]*$|image: /images/blog/<slug>/hero.$EXT|" \
  "TileDown/content/blog/<slug>/index.md"
case "$EXT" in
  png) which optipng   >/dev/null && optipng -o2 "$DEST" || true ;;
  jpg) which jpegoptim >/dev/null && jpegoptim --all-progressive --strip-all "$DEST" || true ;;
esac
sips -g pixelWidth -g pixelHeight "$DEST" | grep pixel
```

### 4b. Bump the site version

Edit `TileDown/content/tiledown.yml` and increment `versionName` (for example
v1.19 to v1.20). The header subtitle shows this on every page.

### 5. Preview

```bash
make tiledown-preview   # serves http://localhost:8098 (blocking; run in its own terminal)
```
Open `http://localhost:8098/blog/<slug>/` and spot-check the post page and the
homepage card. Wait for "looks good" / "ship it" before step 6.

### 6. Build + deploy

```bash
HERO_PATH=$(grep "^image:" "TileDown/content/blog/<slug>/index.md" | sed 's/^image: *//')
HERO_FILE="TileDown/content${HERO_PATH}"
test -f "$HERO_FILE" || { echo "abort: hero file $HERO_FILE missing"; exit 1; }
grep -q "^draft: false" "TileDown/content/blog/<slug>/index.md" || { echo "abort: draft not false"; exit 1; }

make tiledown-check || { say -v "Ava" "Ava: Build failed."; echo "abort: make tiledown-check failed"; exit 1; }
test -f TileDown/dist/index.html || { echo "abort: TileDown/dist/index.html missing"; exit 1; }

cp -R TileDown/dist/* . || { echo "abort: cp from TileDown/dist failed"; exit 1; }

test -f "blog/<slug>/index.html" || { echo "abort: blog/<slug>/index.html missing at root"; exit 1; }
test "$(grep -c localhost index.html)" = "0" || { echo "abort: localhost leaked into index.html"; exit 1; }
grep -qx "aleahim.com" CNAME || { echo "abort: root CNAME is not aleahim.com"; exit 1; }
grep -q "blog/<slug>/" rss.xml || { echo "abort: new post missing from rss.xml"; exit 1; }

git add .
git status
git commit -m "deploy: add \"<Title>\" (vX.Y)" || { echo "abort: git commit failed (hook?)"; exit 1; }
git push origin main || { say -v "Ava" "Ava: Push failed."; echo "abort: git push failed"; exit 1; }
```
Speak: `say -v "Ava" "Ava: Pushed to main. Pages will publish soon."`

### 7. Verify (post-deploy)

```bash
sleep 45
CODE=$(curl -s -o /dev/null -w "%{http_code}" "https://aleahim.com/blog/<slug>/")
echo "GET /blog/<slug>/ → $CODE"
[ "$CODE" = "200" ] || { sleep 30; echo "retry → $(curl -s -o /dev/null -w '%{http_code}' https://aleahim.com/blog/<slug>/)"; }
LI=$(curl -s https://aleahim.com/rss.xml | grep -c "<item>"); LF=$(curl -s https://aleahim.com/rss.xml | grep -c "<content:encoded>")
echo "live RSS: $LI items, $LF content:encoded"; test "$LI" = "$LF" || echo "warning: RSS full-text mismatch"
```
Final voice: `say -v "Ava" "Ava: Post is live. Aleahim dot com."`

## Hard rules

- NEVER push anywhere other than `origin/main` on `github.com:mihaelamj/aleahim.com`.
- NEVER push to a GitLab remote (global rule).
- The live site comes from `TileDown/dist/` only. Copy that to the root.
- NEVER add AI attribution to the commit (global rule).
- NEVER use em dashes in post body, frontmatter `description`, or commit message.
- NEVER assume the post body. Ask if the user only supplied a title.
- NEVER deploy without the hero image (step 6 asserts it).
- NEVER silently overwrite an existing slug (step 1 blocks it).
- NEVER hand-edit `CNAME`. It ships from `TileDown/content/CNAME`; step 6 asserts it stays `aleahim.com`.

## Files this skill touches

- `TileDown/content/blog/<slug>/index.md` (new)
- `TileDown/content/images/blog/<slug>/hero.<png|jpg>` (new)
- `TileDown/content/tiledown.yml` (version bump)
- `TileDown/dist/...` and the root site (rebuilt by the engine, copied to root)

## Idempotency

- If `TileDown/content/blog/<slug>/index.md` exists, step 1 aborts.
- If only the hero is missing, re-enter at step 3.
- If build succeeded but push failed, re-run step 6 from `git push`.

## Cross-Mac install

Canonical file: `aleahim.com/skills/aleahim-new-post/SKILL.md` (git-tracked). After
`git pull` on another Mac, create the global symlink:

```bash
# Studio
ln -s /Volumes/Code/DeveloperExt/public/aleahim.com/skills/aleahim-new-post ~/.claude/skills/aleahim-new-post
# MacBook Air
ln -s ~/Developer/personal/public/aleahim.com/skills/aleahim-new-post ~/.claude/skills/aleahim-new-post
# Claw Mini
ln -s /Volumes/ClawSSD/Developer/personal/public/aleahim.com/skills/aleahim-new-post ~/.claude/skills/aleahim-new-post
# Torrent Mini
ln -s /Volumes/Scratch/DeveloperEx/public/aleahim.com/skills/aleahim-new-post ~/.claude/skills/aleahim-new-post
# Work MBP
ln -s /Users/mihaemih.mac/Developer/public/aleahim.com/skills/aleahim-new-post ~/.claude/skills/aleahim-new-post
```
