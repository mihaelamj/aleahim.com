---
name: aleahim-new-post
description: Scaffold, hero-image, build, and deploy a new blog post on aleahim.com (Toucan + GitHub Pages). Pauses to generate an Apple Creator Studio image prompt matched to the post topic, waits for the Keynote-exported PNG/JPG in ~/Downloads, then runs the full live build + commit + push. Use when the user asks to "new blog post", "publish to aleahim", "add post", "ship blog post", "create blog post <title>", or hands you a draft markdown file/path to publish.
argument-hint: <draft.md path | "Post Title">
---

# aleahim-new-post

End-to-end workflow for a new aleahim.com post. Wraps the steps documented in `AGENTS.md` + `CONTENT-GUIDE.md` + `DEPLOYMENT.md` with a hard pause for the hero image (Apple Creator Studio → Keynote → ~/Downloads).

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
```

Every subsequent step assumes pwd is the aleahim.com repo root and the tree is clean.

## Inputs

- Path to a draft markdown file (frontmatter optional; if present, respect it), OR
- A title + body pasted in chat, OR
- A brief — ask before drafting; never invent technical content.

Always confirm: slug, title, description, date (default today's local date), post body source.

## Slug + paths

- Slug = kebab-case derived from title unless user provides one.
- Post dir: `contents/blog/<slug>/index.md`
- Image dir: `assets/images/blog/<slug>/`
- Hero file: `assets/images/blog/<slug>/hero.<ext>` where `<ext>` matches the source (PNG stays PNG, JPG stays JPG). Recent posts use `hero.png` from Keynote exports; older ones use `hero.jpg`. Toucan doesn't care which — the `image:` frontmatter field just points at whatever is on disk.

## Frontmatter template

```yaml
---
slug: blog/<slug>
title: "<Title>"
description: <one-line listing description, no period, no em dashes>
date: <YYYY-MM-DD>
draft: false
image: /images/blog/<slug>/hero.<ext>   # <ext> = png or jpg, matches the file on disk
---
```

The `image:` extension must match the actual hero file extension (step 4 picks it from the source).

`slug:` MUST be `blog/<slug>`, not bare `<slug>` (per AGENTS.md).

## Workflow

Speak each major step: `say -v "Ava" "Ava: <8-word update>"`. Every bash block aborts on non-zero exit.

### 1. Confirm inputs

Print proposed slug, title, description, date. Wait for user confirmation before writing any file. If slug collides:
```bash
test ! -d "contents/blog/<slug>" || { echo "abort: contents/blog/<slug> already exists, ask user before overwriting"; exit 1; }
```

### 2. Scaffold post

```bash
mkdir -p "contents/blog/<slug>" "assets/images/blog/<slug>"
```

Write `contents/blog/<slug>/index.md`. If the user supplied a draft md, strip any pre-existing frontmatter and emit the canonical block above so `slug`/`image` are consistent. Body must contain no em dashes (commas/colons/periods only — global rule).

### 3. Generate Apple Creator Studio prompt

Read the post body. Pick a style from the seven Creator Studio styles based on topic:

| Post type | Style | Why |
|---|---|---|
| Release / launch / version bump | **Bold** | High-impact announcement aesthetic |
| Technical deep-dive / architecture | **Illustration** | Clean concept art reads well |
| Product showcase / feature demo | **Photorealistic** | Quality signal |
| Reflective / personal / process | **Watercolor** | Soft, contemplative |
| Code / diagram / system flow | **Line** | Technical diagram feel |
| Numbers / performance / benchmark | **Bold** | Impact |
| Tutorial / how-to / explanatory | **Illustration** | Friendly, instructional |

Always specify: **View = Any**, **Aspect = Landscape (16:9)**. This matches the recent posts (cupertino-09, cupertino-10, irelay are all 1280×720 = 16:9). If the user explicitly wants Square or Portrait for a specific post, honor that — but the default is Landscape.

Output in this exact block:

```
HERO IMAGE PROMPT (Apple Creator Studio)
────────────────────────────────────────
Style:   <picked style>
View:    Any
Aspect:  Landscape (16:9)

Prompt:
<2–4 sentence concrete visual prompt. Subject, mood, colour cues, no text,
no logos. Avoid abstract words like "innovative". Reference the post's
central concrete idea. No em dashes.>

Why this style: <one sentence>
────────────────────────────────────────

Next: open Apple Creator Studio → paste the Prompt → pick "<picked style>"
→ set Aspect to Landscape → generate → drag into Keynote → adjust if needed
→ export as PNG or JPG → save to ~/Downloads. Then tell me "image ready"
(or "use <filename>" if you want a specific file).
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
# Derive destination extension from source. Lowercase. jpeg → jpg.
case "$SRC" in
  *.png|*.PNG)              EXT="png" ;;
  *.jpg|*.jpeg|*.JPG|*.JPEG) EXT="jpg" ;;
  *) echo "abort: unsupported source extension ($SRC)"; exit 1 ;;
esac
DEST="assets/images/blog/<slug>/hero.$EXT"
cp "$SRC" "$DEST" || { echo "abort: cp failed"; exit 1; }
test -f "$DEST" || { echo "abort: hero.$EXT not written"; exit 1; }

# Frontmatter image path must match. Update contents/blog/<slug>/index.md if needed.
sed -i "" "s|^image: /images/blog/<slug>/hero\\.[a-z]*$|image: /images/blog/<slug>/hero.$EXT|" \
  "contents/blog/<slug>/index.md"
grep -q "^image: /images/blog/<slug>/hero\\.$EXT$" "contents/blog/<slug>/index.md" \
  || { echo "abort: frontmatter image path mismatch after sed"; exit 1; }

# Optimise — best-effort, format-appropriate, never abort the deploy.
case "$EXT" in
  png) which optipng    >/dev/null && optipng -o2 "$DEST" || true ;;
  jpg) which jpegoptim  >/dev/null && jpegoptim --all-progressive --strip-all "$DEST" || true ;;
esac

# Sanity: report dimensions to the user.
sips -g pixelWidth -g pixelHeight "$DEST" | grep pixel
```

If `optipng`/`jpegoptim` aren't installed, the deploy still proceeds — image just isn't optimised. To enable optimisation: `brew install optipng jpegoptim` (per the Makefile note).

### 5. Preview

```bash
make dev || { say -v "Ava" "Ava: Dev build failed."; echo "abort: make dev failed (check swift run GenerateCV + toucan output)"; exit 1; }
```

Print the local URL: `http://localhost:3000/blog/<slug>/` (start `make serve` in a separate terminal if not already running). Tell user to spot-check the post page AND the homepage listing card. Wait for "looks good" / "ship it" / "deploy" before step 6. If edits needed, loop back to step 2/3.

### 6. Live build + deploy

Pre-deploy assertions:

```bash
# Hero image must exist before live build, or socials/listing break silently.
HERO_PATH=$(grep "^image:" "contents/blog/<slug>/index.md" | sed 's/^image: *//')
test -n "$HERO_PATH" || { echo "abort: image: missing in frontmatter"; exit 1; }
# Convert /images/... to assets/images/...
HERO_FILE="assets${HERO_PATH}"
test -f "$HERO_FILE" \
  || { echo "abort: hero file $HERO_FILE missing; cannot deploy without it"; exit 1; }
# Confirm post frontmatter has draft: false.
grep -q "^draft: false" "contents/blog/<slug>/index.md" \
  || { echo "abort: draft is not false in frontmatter"; exit 1; }
```

Build + copy + verify:

```bash
toucan generate --target live \
  || { say -v "Ava" "Ava: Live build failed."; echo "abort: toucan generate failed"; exit 1; }
test -d /tmp/output \
  || { echo "abort: /tmp/output missing after build"; exit 1; }
cp -r /tmp/output/* . \
  || { echo "abort: cp from /tmp/output failed"; exit 1; }
# Localhost-leak check (project convention, DEPLOYMENT.md step 3).
LEAK=$(grep -c "localhost" index.html || true)
test "$LEAK" -eq 0 \
  || { echo "abort: localhost URL leaked into index.html (LEAK=$LEAK)"; exit 1; }
# Sanity: the new post page must exist in the build.
test -f "blog/<slug>/index.html" \
  || { echo "abort: blog/<slug>/index.html missing after build"; exit 1; }
```

Commit + push:

```bash
git add . \
  || { echo "abort: git add failed"; exit 1; }
git status   # show user what's staged
# Commit message: lowercase scoped style (matches recent history: blog: add ...).
# No em dashes, no AI attribution.
git commit -m "blog: add \"<Title>\"" \
  || { echo "abort: git commit failed (hook?)"; exit 1; }
git push origin main \
  || { say -v "Ava" "Ava: Push failed."; echo "abort: git push failed"; exit 1; }
```

Note on `git add .`: pre-flight (step 0) guaranteed the tree was clean of modifications; everything staged now is from this skill's work (post, image, rebuilt site).

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
# RSS should include the new slug.
curl -s https://aleahim.com/rss.xml | grep -c "<slug>" || echo "warning: slug not in RSS yet (cache?)"
```

If still not 200 after retry: `gh run list --limit 3` to inspect Pages build status. Surface to user — do not loop forever.

Final voice: `say -v "Ava" "Ava: Post is live. Aleahim dot com."`

## Hard rules

- **NEVER** push anywhere other than `origin/main` on `github.com:mihaelamj/aleahim.com`. Repo guard in step 0 enforces this.
- **NEVER** push to a GitLab remote (global rule). Repo guard blocks this.
- **NEVER** copy from `dist/` to root. Always from `/tmp/output/`. `dist/` has localhost URLs.
- **NEVER** add `Co-Authored-By: Claude`, "Generated with", or any AI attribution to the commit (global rule).
- **NEVER** use em dashes in post body, frontmatter `description`, or commit message. Commas, colons, periods.
- **NEVER** assume the post body. Ask if the user only supplied a title.
- **NEVER** deploy without the hero image. The pre-deploy assertion blocks this.
- **NEVER** silently overwrite an existing slug. Step 1 blocks this.

## Files this skill touches

Source (committed manually):
- `contents/blog/<slug>/index.md`               (new)
- `assets/images/blog/<slug>/hero.<png|jpg>`    (new — extension matches source)

Built (rebuilt by Toucan, then committed via `git add .`):
- `blog/<slug>/index.html`
- `blog/index.html` (listing)
- `index.html` (homepage with blog listing)
- `rss.xml`, `sitemap.xml`
- Any other rebuilt root pages (Toucan rebuilds the whole site each time)

The clean-tree pre-flight (step 0) guarantees `git add .` stages only the skill's own output.

## Idempotency / re-runs

- If `contents/blog/<slug>/index.md` exists: step 1 aborts. User must say whether this is an edit (then we skip to step 3 or 5) or a different slug.
- If only `hero.jpg` is missing: re-enter at step 3.
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
