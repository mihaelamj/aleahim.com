---
name: aleahim-social-posts
description: Draft LinkedIn, Mastodon (500), Bluesky (300), and X (280) posts promoting an aleahim.com blog post, with platform-aware char counting (X/Mastodon count URLs as 23; Bluesky counts URLs at full length). Writes the result to ~/Downloads/social-<slug>.md ready to copy-paste. Use when the user asks for "social posts", "promote", "social blast", "linkedin post for the blog", "share on bluesky", or after a new post ships and they want share text.
argument-hint: <slug | URL | path to contents/blog/<slug>/index.md>
---

# aleahim-social-posts

End-to-end: read a published aleahim.com post, write four platform-tailored share posts to a markdown file in `~/Downloads/`, ready for copy-paste. No live posting — Mihaela posts manually.

## Inputs

One of:
- A slug (e.g. `why-i-built-openapi-doctor`)
- A full URL (e.g. `https://aleahim.com/blog/why-i-built-openapi-doctor/`)
- A path to `contents/blog/<slug>/index.md`

Resolve to `<slug>` and read `contents/blog/<slug>/index.md` from the aleahim.com repo (use `git rev-parse --show-toplevel` to locate the repo).

## Accounts (from memory)

- LinkedIn: https://www.linkedin.com/in/mihaelamj/
- Mastodon: https://mastodon.social/@ameahim
- Bluesky: https://bsky.app/profile/dijamantina.bsky.social
- X (tech alt account): https://x.com/diyamantina
  - Note: Mihaela uses the alt for tech to avoid mixing with main account's personal/political content. Never suggest posting tech to the main X account.

## Platform char-count rules (must enforce)

| Platform | Limit | URL counting | Ideal length |
|---|---:|---|---|
| LinkedIn | 3000 hard | actual chars | 1300–1700 (the "see more" cut hits ~210; hook lives there) |
| Mastodon (`mastodon.social`) | 500 | 23 per URL | aim 350–470 |
| Bluesky | 300 | actual chars (no shortening) | aim 250–290; URL is ~50 chars, plan for it |
| X | 280 | 23 per URL | aim 220–270 |

`mastodon.social` uses the default 500-char limit. Other instances may differ but Mihaela posts from `mastodon.social`.

## Voice rules

- **Hook with a concrete sentence from the post itself**, not a generic summary. Mihaela's posts open with the most quotable line from the piece (often the error message, the number, or the unexpected finding).
- **No em dashes** (global rule). Commas, colons, periods.
- **No AI attribution** anywhere (global rule). No "✨", no "powered by", no telltale structure.
- **No marketing hype**: avoid "innovative", "game-changing", "excited to share". Mihaela's voice is dry, specific, and self-aware.
- **Concrete numbers preferred**: "594 YAML files", "11 levels deep", "30 rounds capped" — these land. Vague claims don't.
- **First-person, past-tense story arc when possible**: "I lost an afternoon. Then I built X." The post is the hero; the tweet is the trailer.
- **No hashtag spam**. LinkedIn: 3–5 max. Mastodon: 1–3. Bluesky: 0–2. X: usually 0; only if a char budget allows.

## Workflow

Speak each major step: `say -v "Ava" "Ava: <8-word update>"`.

### 1. Resolve inputs

```bash
ROOT="$(git rev-parse --show-toplevel 2>/dev/null)" || { echo "abort: not in a git repo (cd into aleahim.com first)"; exit 1; }
cd "$ROOT"
git remote get-url origin | grep -q "github.com[:/]mihaelamj/aleahim.com" \
  || { echo "abort: not in aleahim.com repo"; exit 1; }

# SLUG = the kebab-case post slug.
# - argument is a path → derive from dirname
# - argument is a URL → strip prefix
# - argument is a bare slug → use as-is
SLUG="<derived slug>"
POST="contents/blog/$SLUG/index.md"
test -f "$POST" || { echo "abort: $POST not found"; exit 1; }
```

### 2. Read post

Parse frontmatter (title, description) and full body. Identify:
- The opening hook line (often a quoted error, a number, or the first paragraph's most concrete claim)
- 3–6 concrete facts to surface in long-form (LinkedIn)
- The single sharpest punchline for short-form (X / Bluesky)

### 3. Draft posts

Draft once per platform. Match Mihaela's voice. Use the structure that fits the platform:

- **X (280)**: 2–3 short paragraphs. Open with the hook line. Tag with `So I built <Tool>` or `Why I <thing>`. URL last.
- **Bluesky (300)**: similar to X but URL counts full, budget ~50 chars for URL. Trim more aggressively. Single hashtag at most.
- **Mastodon (500)**: middle ground. Can include one extra fact (numbers, scope). 1–2 hashtags at end.
- **LinkedIn**: hook + reveal + bulleted "What it does" + closing CTA + URL + hashtags. The first 210 chars are the preview before "see more"; load them with the hook.

Forbidden across all: em dashes, "—", "Generated with", AI signature emoji (🤖 ✨ 🪄), AI-tell preambles ("Let me…", "I'll now…").

### 4. Char-count enforcement

Compute counts with platform-aware URL handling and tighten until each fits:

```python
import re
def count(text, mode):
    # mode: "x", "masto", "bsky" (full URL), "linkedin" (full URL)
    urls = re.findall(r'https?://\S+', text)
    if mode in ("x", "masto"):
        text_no_urls = re.sub(r'https?://\S+', '', text)
        return len(text_no_urls) + len(urls) * 23
    return len(text)
```

Limits: X ≤ 280, Mastodon ≤ 500, Bluesky ≤ 300, LinkedIn ≤ 3000 (aim ≤ 1700).

If a post is over: tighten in this order before rewriting (cheapest edits first):
1. Drop redundant adverbs ("quietly", "actually")
2. Replace verbose constructions with shorter ones ("a typed validator and auto-repair CLI" → "a typed validator + auto-repair CLI", saves 4)
3. Remove the second sentence of a two-sentence setup if the first carries the hook
4. Drop hashtags
5. Last resort: rewrite the hook

Never silently truncate — always rewrite so the result still reads naturally.

### 5. Write output

```bash
OUT="$HOME/Downloads/social-$SLUG.md"
# Use Write tool with the structured markdown below.
```

Output file structure:

```markdown
# Social posts: <Title>

Post URL: https://aleahim.com/blog/<slug>/
Drafted: <YYYY-MM-DD>

Char count notes:
- **X**: URLs count as 23 chars (t.co wrapping)
- **Mastodon** (`mastodon.social`): URLs count as 23 chars
- **Bluesky**: URLs count at full length (no shortening)
- **LinkedIn**: no shortening; 3000 hard, 1300–1700 ideal for engagement

---

## LinkedIn

Account: https://www.linkedin.com/in/mihaelamj/

<post body>

---

## Mastodon (500 chars)

Account: https://mastodon.social/@ameahim

<post body>

---

## Bluesky (300 chars)

Account: https://bsky.app/profile/dijamantina.bsky.social

<post body>

---

## X (280 chars)

Account: https://x.com/diyamantina

<post body>
```

Post bodies are PLAIN TEXT, never blockquoted. Do NOT prefix lines with `> `. The whole point is that each post lifts straight into the platform's compose box with nothing to strip. The `## Platform` headings, `Account:` lines, and `---` separators are the only scaffolding.

### 6. Report

Print a summary to the user with computed counts:

```
Written: ~/Downloads/social-<slug>.md

LinkedIn:  <n> chars (ideal 1300–1700)
Mastodon:  <n>/500
Bluesky:   <n>/300
X:         <n>/280
```

Speak: `say -v "Ava" "Ava: Social posts ready in Downloads."`

## Hard rules

- **NEVER** post to any social network from this skill. The output is text in a file. Mihaela posts manually.
- **NEVER** suggest the main X account for tech posts. Tech goes to `@diyamantina` (the alt).
- **NEVER** use em dashes (`—`, `–`) anywhere in the output (global rule).
- **NEVER** add AI-tell phrasing, emoji signatures, or "generated by" suffixes (global rule).
- **NEVER** silently exceed a char limit. If you can't fit, tighten and re-verify; never publish numbers you didn't compute.
- **NEVER** fabricate post content. Pull lines, numbers, and facts from the actual post body. If the body doesn't have a strong hook, ask the user for the angle they want.
- **NEVER** blockquote-prefix the post bodies (`> `). Plain text only, so each post copies straight into the compose box with nothing to strip. (Mihaela finds the `> ` prefix annoying.)

## Files this skill touches

- Reads: `contents/blog/<slug>/index.md` (frontmatter + body)
- Reads: `~/.claude/projects/-Volumes-Code-DeveloperExt-public-aleahim-com/memory/user_socials.md` (handles)
- Writes: `~/Downloads/social-<slug>.md` (overwrites if exists)

No git operations, no deploys, no pushes. Pure local file generation.

## Idempotency / re-runs

- If `~/Downloads/social-<slug>.md` exists: overwrite without prompt. The file is disposable scratch; Mihaela copies from it into the social UIs, then doesn't need it.
- If the user asks to "retry with a different angle", regenerate; the input post body is the same but the hook/structure changes.

## Cross-Mac install

Canonical at `aleahim.com/skills/aleahim-social-posts/SKILL.md` (git-tracked). After `git pull`:

```bash
# Studio
ln -s /Volumes/Code/DeveloperExt/public/aleahim.com/skills/aleahim-social-posts ~/.claude/skills/aleahim-social-posts
# MacBook Air
ln -s ~/Developer/personal/public/aleahim.com/skills/aleahim-social-posts ~/.claude/skills/aleahim-social-posts
# Claw Mini
ln -s /Volumes/ClawSSD/Developer/personal/public/aleahim.com/skills/aleahim-social-posts ~/.claude/skills/aleahim-social-posts
# Torrent Mini
ln -s /Volumes/Scratch/DeveloperEx/public/aleahim.com/skills/aleahim-social-posts ~/.claude/skills/aleahim-social-posts
# Work MBP
ln -s /Users/mihaemih.mac/Developer/public/aleahim.com/skills/aleahim-social-posts ~/.claude/skills/aleahim-social-posts
```
