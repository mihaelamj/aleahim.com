---
name: aleahim-new-post
description: Scaffold, hero-image, build, and deploy a new blog post on aleahim.com (TileDown + GitHub Pages). Pauses to generate an Apple Creator Studio image prompt matched to the post topic, waits for the Keynote-exported PNG/JPG in ~/Downloads, then runs the full live build + commit + push. Use when the user asks to "new blog post", "publish to aleahim", "add post", "ship blog post", "create blog post <title>", or hands you a draft markdown file/path to publish.
argument-hint: <draft.md path | "Post Title">
---

# aleahim-new-post

End-to-end workflow for a new aleahim.com post. Wraps the steps documented in `AGENTS.md` + `CONTENT-GUIDE.md` + `DEPLOYMENT.md` with a hard pause for the hero image (Apple Creator Studio → Keynote → ~/Downloads).

## Build system: TileDown (not Toucan)

The site migrated from Toucan to TileDown (Mihaela's own static site generator).
Authoring is unchanged: posts still live in `contents/blog/<slug>/index.md` with
the same frontmatter. The build and deploy are different:

- A conversion step (`Scripts/convert_toucan_to_tiledown.py`, run by the Makefile)
  turns `contents/` into `TileDown/content`.
- The TileDown engine builds `TileDown/content` into `TileDown/dist`.
- Deploy = copy `TileDown/dist/*` over the repo root, commit, push. GitHub Pages
  serves committed HTML from the root.
- The engine is a sibling checkout at `../TileDown/tile-down` (override with
  `TILEDOWN_REPO=...`). The Makefile `tiledown-*` targets drive everything.

The old Toucan commands (`make dev`, `toucan generate`, `/tmp/output`, `dist/`)
are dead. `DEPLOYMENT.md`'s main body still documents the old flow; only its
"TileDown Production Check" section is current.

## 0. Always do first — repo guard

```bash
ROOT="$(git rev-parse --show-toplevel 2>/dev/null)" || { echo "abort: not in a git repo"; exit 1; }
cd "$ROOT"
# Verify we're in aleahim.com and origin is the github repo (not a fork, not gitlab).
git remote get-url origin | grep -q "github.com[:/]mihaelamj/aleahim.com" \
  || { echo "abort: origin is not github.com:mihaelamj/aleahim.com"; exit 1; }
# Clean tree (modified files block; untracked files are OK).
test -z "$(git status --porcelain | grep -v '^??')" \
  || { echo "abort: working tree has uncommitted modifications"; git status --short; exit 1; }
# TileDown engine checkout must be present (or pass TILEDOWN_REPO to make).
test -d "${TILEDOWN_REPO:-../TileDown/tile-down}/Packages" \
  || { echo "abort: TileDown engine not at ${TILEDOWN_REPO:-../TileDown/tile-down}; set TILEDOWN_REPO"; exit 1; }
```

Every subsequent step assumes pwd is the aleahim.com repo root and the tree is clean.

## Inputs

- Path to a draft markdown file (frontmatter optional; if present, respect it), OR
- A title + body pasted in chat, OR
- A brief — ask before drafting; never invent technical content.

Always confirm: slug, title, description, date (default today's local date), tags, post body source.

## Slug + paths

- Slug = kebab-case derived from title unless user provides one.
- Post dir: `contents/blog/<slug>/index.md`
- Image dir: `assets/images/blog/<slug>/`
- Hero file: `assets/images/blog/<slug>/hero.<ext>` where `<ext>` matches the source (PNG stays PNG, JPG stays JPG). Recent posts use `hero.png` from Keynote exports; older ones use `hero.jpg`. TileDown doesn't care which — the `image:` frontmatter field just points at whatever is on disk.

## Frontmatter template

```yaml
---
slug: blog/<slug>
title: "<Title>"
description: <one-line listing description, no period, no em dashes>
date: <YYYY-MM-DD>
draft: false
image: /images/blog/<slug>/hero.<ext>   # <ext> = png or jpg, matches the file on disk
tags: <Tag, Tag, Tag>                    # optional; comma-separated, used by the blog tag nav
---
```

The `image:` extension must match the actual hero file extension (step 4 picks it from the source).

`slug:` MUST be `blog/<slug>`, not bare `<slug>` (per AGENTS.md). `tags:` is optional; omit the line if the post has none.

## Workflow

Speak each major step: `say -v "Ava" "Ava: <8-word update>"`. Every bash block aborts on non-zero exit.

### 1. Confirm inputs

Print proposed slug, title, description, date, tags. Wait for user confirmation before writing any file. If slug collides:
```bash
test ! -d "contents/blog/<slug>" || { echo "abort: contents/blog/<slug> already exists, ask user before overwriting"; exit 1; }
```

### 2. Scaffold post

```bash
mkdir -p "contents/blog/<slug>" "assets/images/blog/<slug>"
```

Write `contents/blog/<slug>/index.md`. If the user supplied a draft md, strip any pre-existing frontmatter and emit the canonical block above so `slug`/`image` are consistent. Body must contain no em dashes (commas/colons/periods only — global rule).

### 3. Generate Apple Creator Studio prompt

Read the post body. Pick a style based on topic:

| Post type | Style | Why |
|---|---|---|
| Release / launch / version bump | **Bold** | High-impact announcement aesthetic |
| Technical deep-dive / architecture | **Illustration** | Clean concept art reads well |
| Product showcase / feature demo | **Photorealistic** | Quality signal |
| Reflective / personal / process | **Watercolor** | Soft, contemplative |
| Code / diagram / system flow | **Line** | Technical diagram feel |
| Numbers / performance / benchmark | **Bold** | Impact |
| Tutorial / how-to / explanatory | **Illustration** | Friendly, instructional |

Always specify: **View = Any**, **Aspect = Landscape (16:9)**. This matches the recent posts (1280×720 = 16:9). If the user explicitly wants Square or Portrait, honor that, but the default is Landscape.

**Image model: OpenAI (ChatGPT), via Apple Creator Studio in Keynote.** Mihaela does not use the on-device Apple styles; she generates the hero through the OpenAI image model. So the style table above is mood guidance only: fold the chosen style word (for example "editorial illustration" or "bold poster art") directly into the prompt sentence, because the OpenAI model reads style from the prompt text, not from a style picker. Write one rich free-form paragraph, Landscape 16:9, no text, no logos, no readable letters.

Output in this exact block:

```
HERO IMAGE PROMPT (Apple Creator Studio)
────────────────────────────────────────
Style:   <picked style> (folded into the prompt, see note above)
View:    Any
Aspect:  Landscape (16:9)
Model:   OpenAI (ChatGPT)

Prompt:
<one rich free-form paragraph. Subject, mood, colour cues, composition.
Fold the style word into the sentence. No text, no logos, no readable
letters. Avoid abstract words like "innovative". Reference the post's
central concrete idea. No em dashes.>

Why this style: <one sentence>
────────────────────────────────────────

Next: in Keynote, insert an image via Apple Creator Studio → choose the
OpenAI (ChatGPT) model → paste the Prompt → generate → place on a 16:9
slide and adjust → export the slide as PNG (or JPG) to ~/Downloads. Then
tell me "image ready" (or "use <filename>" for a specific file).
```

**Worked example** (post "The Morlocks Built SwiftUI"):

```
HERO IMAGE PROMPT (Apple Creator Studio)
────────────────────────────────────────
Style:   Editorial illustration (folded into the prompt)
View:    Any
Aspect:  Landscape (16:9)
Model:   OpenAI (ChatGPT)

Prompt:
An editorial illustration in cinematic landscape composition: a serene,
sunlit upper world of soft rounded pastel shapes floating effortlessly
above a smooth glassy floor, and beneath that floor, revealed through a
wide cutaway, an enormous intricate brass-and-steel machine of
interlocking gears, pistons, pipes and softly glowing conduits that
silently powers everything above. Warm golden daylight on the calm
surface fades into cool teal shadow and amber machine-glow in the depths.
The mood is quiet awe: the effortless surface is clearly driven by the
vast hidden engine underneath. Clean flat-shaded vector-like rendering,
rich sense of depth, no text, no logos, no readable letters.

Why this style: technical/architecture piece; clean concept art sells the
surface-over-hidden-machine idea without spelling it out.
────────────────────────────────────────
```

HARD PAUSE. Do not proceed. Speak: `say -v "Ava" "Ava: Prompt ready. Waiting for hero image."`

### 4. Pick up the image

When the user says "image ready" / "done" / "use <filename>":

```bash
# Newest PNG/JPG/JPEG in ~/Downloads, last 24h, sorted by mtime.
CANDIDATE=$(find ~/Downloads -maxdepth 1 -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" \) -mmin -1440 -print0 \
  | xargs -0 ls -t 2>/dev/null | head -1)
test -n "$CANDIDATE" || { echo "abort: no recent png/jpg in ~/Downloads"; exit 1; }
echo "Candidate: $CANDIDATE"
```

Show the candidate to the user. If they named a specific file, use that instead. On confirmation — preserve the source format (PNG stays PNG, JPG stays JPG, no recompression):

```bash
SRC="<confirmed source path>"
case "$SRC" in
  *.png|*.PNG)              EXT="png" ;;
  *.jpg|*.jpeg|*.JPG|*.JPEG) EXT="jpg" ;;
  *) echo "abort: unsupported source extension ($SRC)"; exit 1 ;;
esac
DEST="assets/images/blog/<slug>/hero.$EXT"
cp "$SRC" "$DEST" || { echo "abort: cp failed"; exit 1; }
test -f "$DEST" || { echo "abort: hero.$EXT not written"; exit 1; }

# Frontmatter image path must match.
sed -i "" "s|^image: /images/blog/<slug>/hero\\.[a-z]*$|image: /images/blog/<slug>/hero.$EXT|" \
  "contents/blog/<slug>/index.md"
grep -q "^image: /images/blog/<slug>/hero\\.$EXT$" "contents/blog/<slug>/index.md" \
  || { echo "abort: frontmatter image path mismatch after sed"; exit 1; }

# Optimise — best-effort, never abort the deploy.
case "$EXT" in
  png) which optipng    >/dev/null && optipng -o2 "$DEST" || true ;;
  jpg) which jpegoptim  >/dev/null && jpegoptim --all-progressive --strip-all "$DEST" || true ;;
esac
sips -g pixelWidth -g pixelHeight "$DEST" | grep pixel
```

If `optipng`/`jpegoptim` aren't installed, the deploy still proceeds. To enable: `brew install optipng jpegoptim`.

### 5. Preview (TileDown)

`make tiledown-preview` converts the content, builds a preview site with `baseURL` stripped (so links are root-relative on localhost), and serves it on port 8098. It runs in the foreground, so start it in a separate terminal:

```bash
make tiledown-preview     # serves http://localhost:8098/ (blocking; run in its own terminal)
```

Open `http://localhost:8098/blog/<slug>/` and spot-check the post page AND the homepage listing card. For a build-only check without serving, use `make tiledown-preview-build`. Wait for "looks good" / "ship it" / "deploy" before step 6. If edits needed, loop back to step 2/3.

### 6. Live build + deploy (TileDown)

Pre-deploy assertions:

```bash
HERO_PATH=$(grep "^image:" "contents/blog/<slug>/index.md" | sed 's/^image: *//')
test -n "$HERO_PATH" || { echo "abort: image: missing in frontmatter"; exit 1; }
HERO_FILE="assets${HERO_PATH}"
test -f "$HERO_FILE" || { echo "abort: hero file $HERO_FILE missing; cannot deploy without it"; exit 1; }
grep -q "^draft: false" "contents/blog/<slug>/index.md" || { echo "abort: draft is not false in frontmatter"; exit 1; }
```

Build with TileDown. `make tiledown-check` runs the converter (`contents/` → `TileDown/content`), the doctor, the `build-site` into `TileDown/dist`, and the output checks (route parity, root files, images, RSS full content, analytics):

```bash
make tiledown-check \
  || { say -v "Ava" "Ava: TileDown build failed."; echo "abort: make tiledown-check failed"; exit 1; }
test -f TileDown/dist/index.html || { echo "abort: TileDown/dist/index.html missing after build"; exit 1; }
```

Deploy: copy the built site over the repo root (GitHub Pages serves committed HTML from root). `TileDown/dist` includes `CNAME`:

```bash
cp -R TileDown/dist/* . || { echo "abort: cp from TileDown/dist failed"; exit 1; }
```

Verify the root:

```bash
test -f "blog/<slug>/index.html" || { echo "abort: blog/<slug>/index.html missing at root after copy"; exit 1; }
LEAK=$(grep -c "localhost" index.html || true)
test "$LEAK" -eq 0 || { echo "abort: localhost URL leaked into index.html (LEAK=$LEAK)"; exit 1; }
grep -qx "aleahim.com" CNAME || { echo "abort: root CNAME is not aleahim.com"; exit 1; }
# RSS full-text invariant (CLAUDE.md): every <item> carries <content:encoded>, new post present.
RSS_ITEMS=$(grep -c "<item>" rss.xml); RSS_FULLTEXT=$(grep -c "<content:encoded>" rss.xml)
test "$RSS_ITEMS" = "$RSS_FULLTEXT" || { echo "abort: rss.xml item/content:encoded mismatch ($RSS_ITEMS/$RSS_FULLTEXT)"; exit 1; }
grep -q "blog/<slug>/" rss.xml || { echo "abort: new post slug missing from rss.xml after build"; exit 1; }
echo "OK: post built, no localhost leak, CNAME intact, RSS full-text, new post present"
```

Commit + push:

```bash
git add . || { echo "abort: git add failed"; exit 1; }
git status   # show user what's staged (post, image, regenerated TileDown/content + TileDown/dist + root site)
# Commit message: lowercase scoped style. No em dashes, no AI attribution.
git commit -m "blog: add \"<Title>\"" || { echo "abort: git commit failed (hook?)"; exit 1; }
git push origin main || { say -v "Ava" "Ava: Push failed."; echo "abort: git push failed"; exit 1; }
```

Speak: `say -v "Ava" "Ava: Pushed to main. Pages will publish soon."`

### 7. Verify (post-deploy)

```bash
sleep 45
CODE=$(curl -s -o /dev/null -w "%{http_code}" "https://aleahim.com/blog/<slug>/")
echo "GET /blog/<slug>/ → $CODE"
if [ "$CODE" != "200" ]; then
  sleep 30
  CODE=$(curl -s -o /dev/null -w "%{http_code}" "https://aleahim.com/blog/<slug>/")
  echo "Retry → $CODE"
fi
LIVE_RSS=$(curl -s https://aleahim.com/rss.xml)
echo "$LIVE_RSS" | grep -q "blog/<slug>/" || echo "warning: new slug not in live RSS yet (Pages/CDN cache?)"
LI=$(echo "$LIVE_RSS" | grep -c "<item>"); LF=$(echo "$LIVE_RSS" | grep -c "<content:encoded>")
echo "live RSS: $LI items, $LF content:encoded"
test "$LI" = "$LF" || echo "warning: live RSS item/content:encoded mismatch ($LI/$LF)"
```

If still not 200 after retry: `gh run list --limit 3` to inspect Pages build status. Surface to user, do not loop forever.

Final voice: `say -v "Ava" "Ava: Post is live. Aleahim dot com."`

## Hard rules

- **NEVER** push anywhere other than `origin/main` on `github.com:mihaelamj/aleahim.com`. Repo guard in step 0 enforces this.
- **NEVER** push to a GitLab remote (global rule). Repo guard blocks this.
- **NEVER** copy from `dist/` (the dead Toucan dev output, localhost URLs) or `/tmp/output/` to root. The live site comes from `TileDown/dist/` only.
- **NEVER** add `Co-Authored-By: Claude`, "Generated with", or any AI attribution to the commit (global rule).
- **NEVER** use em dashes in post body, frontmatter `description`, or commit message. Commas, colons, periods.
- **NEVER** assume the post body. Ask if the user only supplied a title.
- **NEVER** deploy without the hero image. The pre-deploy assertion blocks this.
- **NEVER** silently overwrite an existing slug. Step 1 blocks this.
- **NEVER** hand-edit the `CNAME` file. It ships from `TileDown/content/CNAME` through the build; the verify step asserts it stays `aleahim.com`.

## Files this skill touches

Source (committed manually):
- `contents/blog/<slug>/index.md`               (new)
- `assets/images/blog/<slug>/hero.<png|jpg>`    (new, extension matches source)

Generated + built (regenerated by the TileDown flow, then committed via `git add .`):
- `TileDown/content/...`   (converted from `contents/` by `Scripts/convert_toucan_to_tiledown.py`)
- `TileDown/dist/...`      (built by the TileDown engine)
- Root site: `blog/<slug>/index.html`, `blog/index.html`, `index.html`, `rss.xml`, `sitemap.xml`, `CNAME`, and other root pages (the whole site is rebuilt and copied each time)

The clean-tree pre-flight (step 0) guarantees `git add .` stages only the skill's own output.

## Idempotency / re-runs

- If `contents/blog/<slug>/index.md` exists: step 1 aborts. User must say whether this is an edit (then skip to step 3 or 5) or a different slug.
- If only the hero is missing: re-enter at step 3.
- If build succeeded but push failed: re-run step 6 from the `git push` line.

## Cross-Mac install

Canonical file lives at `aleahim.com/skills/aleahim-new-post/SKILL.md` (git-tracked, NOT under `.claude/` which is gitignored). After `git pull` in aleahim.com on another Mac, create the global symlink there:

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
