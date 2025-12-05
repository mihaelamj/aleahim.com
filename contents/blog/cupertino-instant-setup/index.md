---
slug: blog/cupertino-instant-setup
title: "Cupertino v0.3.0: From 20 Hours to 30 Seconds"
description: The new setup command downloads pre-built databases instantly - no more crawling Apple's documentation for hours
date: 2025-12-05
image: /images/blog/cupertino-instant-setup/hero.jpg
---

# Cupertino v0.3.0: From 20 Hours to 30 Seconds

**TL;DR:** `cupertino setup` now downloads pre-built databases in ~30 seconds. No more 20-hour crawls.

## The Problem With v0.2.x

When I released Cupertino, the setup process looked like this:

```bash
cupertino fetch --type docs --max-pages 15000  # ~20-24 hours
cupertino fetch --type evolution               # ~5 minutes
cupertino save                                 # ~5 minutes
```

Twenty hours. To respect Apple's servers, the crawler waits 0.5 seconds between requests. 21,000 pages × 0.5s = a very long initial setup.

Users loved the tool but hated the onboarding. Fair.

## The Solution: Pre-built Databases

Instead of everyone crawling Apple's documentation independently, I now publish pre-built databases on GitHub Releases. The new setup flow:

```bash
cupertino setup   # ~30 seconds
cupertino serve   # Start MCP server
```

That's it. Two commands. Under a minute.

## How It Works

### For Users

The `setup` command downloads a zip file from GitHub Releases containing:

- `search.db` (~1.1 GB) - 138,000+ documentation pages
- `samples.db` (~183 MB) - 606 sample projects, 18,000+ source files

```bash
$ cupertino setup

📦 Cupertino Setup

⬇️  Downloading Databases...
   ⠹ [████████████████░░░░░░░░░░░░░░]  53% (121.0 MB/228.1 MB)
   ✓ Databases (228.1 MB)
📂 Extracting databases...
   ✓ Extracted

✅ Setup complete!
   Documentation: /Users/you/.cupertino/search.db
   Sample code:   /Users/you/.cupertino/samples.db

💡 Start the server with: cupertino serve
```

If databases already exist, it skips the download:

```bash
$ cupertino setup

📦 Cupertino Setup

✅ Databases already exist
   Documentation: /Users/you/.cupertino/search.db
   Sample code:   /Users/you/.cupertino/samples.db

💡 Use --force to overwrite with latest version
💡 Start the server with: cupertino serve
```

### For Me (Maintainer)

A new `release` command automates publishing:

```bash
$ cupertino release

📦 Cupertino Release v0.3.0

📊 Database sizes:
   search.db:  1.2 GB
   samples.db: 192.2 MB

📁 Creating cupertino-databases-v0.3.0.zip...
   ✓ Created (228.3 MB)

🔐 Calculating SHA256...
   17dac4b84adaa04b5f976a7d1b9126630545f0101fe84ca5423163da886386a6

🚀 Creating release v0.3.0...
   ✓ Release created

⬆️  Uploading cupertino-databases-v0.3.0.zip...
   ✓ Upload complete

✅ Release v0.3.0 published!
   https://github.com/mihaelamj/cupertino-docs/releases/tag/v0.3.0
```

When I refresh the documentation (re-crawl Apple's docs), I bump the version and run `cupertino release`. Users get the update with `cupertino setup --force`.

## Version Parity

The CLI version matches the database release tag:

| CLI Version | Release Tag | Database |
|-------------|-------------|----------|
| 0.3.0 | v0.3.0 | cupertino-databases-v0.3.0.zip |
| 0.4.0 | v0.4.0 | cupertino-databases-v0.4.0.zip |

This ensures schema compatibility. If I change the database structure in v0.4.0, users with CLI v0.4.0 will download v0.4.0 databases.

## Three Ways to Set Up Cupertino

Now you have options:

### 1. Instant Setup (Recommended)

```bash
cupertino setup    # ~30 seconds
cupertino serve
```

Download pre-built databases. Fastest option.

### 2. Build from GitHub

```bash
cupertino save --remote    # ~45 minutes
cupertino serve
```

Stream documentation from GitHub and build locally. Useful if you want to verify the build process or can't download the 228MB zip.

### 3. Full Crawl (Advanced)

```bash
cupertino fetch --type docs --max-pages 15000    # ~20-24 hours
cupertino fetch --type evolution
cupertino save
cupertino serve
```

Crawl Apple's documentation yourself. Only needed if you want to modify the crawler or need documentation not in the pre-built database.

## Compression Matters

The uncompressed databases total ~1.3 GB. The zip file is 228 MB - about 1/6 the size. SQLite databases compress extremely well because they contain repetitive text data.

This makes the download fast and keeps GitHub Release storage reasonable.

## Database Updates

I'm actively crawling Apple's documentation and updating the databases several times a week. Run `cupertino setup --force` to get the latest version.

The documentation is hosted in two public repositories:

- **[cupertino-docs](https://github.com/mihaelamj/cupertino-docs)** - Pre-crawled documentation and database releases
- **[cupertino-sample-code](https://github.com/mihaelamj/cupertino-sample-code)** - 606 Apple sample code projects

## What's Next

- **Automatic updates** - Check for new database versions on startup
- **Delta updates** - Download only changed documents instead of full database
- **More documentation sources** - WWDC transcripts, Apple Tech Notes

## Try It

```bash
# Install
git clone https://github.com/mihaelamj/cupertino.git
cd cupertino && make build && sudo make install

# Setup (the new way)
cupertino setup
cupertino serve
```

Configure Claude Desktop and you're done. Full Apple documentation access in under a minute.

## Links

- **GitHub:** [github.com/mihaelamj/cupertino](https://github.com/mihaelamj/cupertino)
- **Release:** [v0.3.0](https://github.com/mihaelamj/cupertino/releases/tag/v0.3.0)
- **Databases:** [cupertino-docs releases](https://github.com/mihaelamj/cupertino-docs/releases)

---

*The best feature is the one that removes friction. Twenty hours of crawling was friction.*
