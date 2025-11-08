# Content Guide

This guide explains how to add and manage content on your Toucan-based site.

## Table of Contents

1. [Adding a New Page](#adding-a-new-page)
2. [Adding a Menu Item](#adding-a-menu-item)
3. [Adding Images](#adding-images)
4. [Adding a Blog Post](#adding-a-blog-post)
5. [Working with Links](#working-with-links)

---

## Adding a New Page

### Step 1: Create Content Directory

Create a new directory in `contents/` with your page name:

```bash
mkdir -p contents/portfolio
```

### Step 2: Create index.md

Create `index.md` with YAML frontmatter:

```bash
cat > contents/portfolio/index.md << 'EOF'
---
slug: portfolio
title: Portfolio
description: My work and projects
---

# My Portfolio

Here are some of my recent projects...

## Project 1

Description of your first project.

## Project 2

Description of your second project.
EOF
```

**Required frontmatter fields:**
- `slug` - URL-friendly identifier (e.g., "portfolio" → `/portfolio/`)
- `title` - Page title (shown in browser tab and `<title>`)
- `description` - Meta description for SEO

### Step 3: Build and Test

```bash
# Rebuild site
make dev

# View at: http://localhost:3000/portfolio/
```

---

## Adding a Menu Item

After creating a new page, add it to the navigation menu.

### Edit site.yml

Open `site.yml` and add your page to the `navigation` array:

```yaml
name: "Aleahim"
language: "en-US"
navigation:
  - label: "Home"
    url: "/"
  - label: "CV"
    url: "/cv/"
  - label: "Services"
    url: "/services/"
  - label: "Portfolio"      # New menu item
    url: "/portfolio/"       # Must match your slug
  - label: "About"
    url: "/about/"
```

**Navigation fields:**
- `label` - Text shown in menu
- `url` - Path to page (must start and end with `/`)
- `class` (optional) - CSS class for styling

### Menu Order

Items appear in the order listed. Rearrange them by changing their position in the array.

**Example:** Move Portfolio before Services:

```yaml
navigation:
  - label: "Home"
    url: "/"
  - label: "CV"
    url: "/cv/"
  - label: "Portfolio"      # Now appears before Services
    url: "/portfolio/"
  - label: "Services"
    url: "/services/"
  - label: "About"
    url: "/about/"
```

---

## Adding Images

### Step 1: Add Image Files

Place images in `assets/images/`:

```bash
# For a specific project/post
mkdir -p assets/images/portfolio
cp ~/Desktop/screenshot.png assets/images/portfolio/

# For site-wide images
cp ~/Desktop/avatar.jpg assets/images/
```

**Recommended structure:**
```
assets/images/
├── logo.svg              # Site logo
├── avatar.jpg            # Profile photo
├── portfolio/            # Portfolio images
│   ├── project1.png
│   └── project2.png
├── blog/
│   ├── token/           # Token middleware post
│   ├── xpack/           # ExtremePackaging post
│   └── ...
```

### Step 2: Reference Images in Markdown

Use absolute paths from the site root:

```markdown
---
slug: portfolio
title: Portfolio
description: My work
---

# My Portfolio

![Project Screenshot](/images/portfolio/project1.png)

## Project Details

Here's another image:

![Architecture Diagram](/images/portfolio/architecture.png)
```

**Image path rules:**
- Always start with `/images/` (not `/assets/images/`)
- Use absolute paths, not relative
- File names are case-sensitive
- Supported formats: `.jpg`, `.png`, `.svg`, `.gif`, `.webp`

### Step 3: Add Images to Blog Post Frontmatter

```markdown
---
slug: my-new-post
title: Building Something Cool
description: A technical deep dive
date: 2025-01-15
image: /images/blog/cool-project/hero.jpg    # Featured image
---

# Building Something Cool

Content here...
```

The `image` field in frontmatter is used for:
- Blog post thumbnail on listing pages
- Social media previews (Open Graph, Twitter Cards)
- Hero image at top of post

---

## Adding a Blog Post

### Step 1: Create Blog Directory

```bash
# Use kebab-case for URL-friendly names
mkdir -p contents/blog/my-new-post
```

### Step 2: Create index.md

```bash
cat > contents/blog/my-new-post/index.md << 'EOF'
---
slug: my-new-post
title: Building a Server-Driven UI in Swift
description: How to create flexible, backend-controlled interfaces
date: 2025-01-15
image: /images/blog/server-ui/hero.jpg
---

# Building a Server-Driven UI in Swift

Server-driven UI allows you to update your app's interface without releasing a new version...

## Why Server-Driven UI?

1. **Flexibility** - Update UI without app store review
2. **A/B Testing** - Test different layouts dynamically
3. **Personalization** - Tailor UI per user

## Implementation

Here's how to build it in Swift:

```swift
struct ServerDrivenView: View {
    @StateObject var viewModel = ServerUIViewModel()

    var body: some View {
        // Your code here
    }
}
```

## Conclusion

Server-driven UI is powerful for...
EOF
```

**Blog post frontmatter fields:**
- `slug` - URL identifier (e.g., "my-new-post" → `/blog/my-new-post/`)
- `title` - Post title (can include colons, use quotes if so)
- `description` - Short summary for listings
- `date` - Publication date (format: `YYYY-MM-DD`)
- `image` - Featured image path (optional)

**Important:** If your title contains a colon, wrap it in quotes:
```yaml
title: "CVBuilder: A Swift Package for Professional CV Management"
```

### Step 3: Add Images (Optional)

```bash
mkdir -p assets/images/blog/my-new-post
cp ~/Desktop/hero.jpg assets/images/blog/my-new-post/
cp ~/Desktop/diagram.png assets/images/blog/my-new-post/
```

Reference in markdown:
```markdown
![System Architecture](/images/blog/my-new-post/diagram.png)
```

### Step 4: Build and Preview

```bash
make dev

# View your post at:
# http://localhost:3000/blog/my-new-post/
#
# See it in the blog listing at:
# http://localhost:3000/
```

Blog posts automatically appear on the homepage (which shows the blog listing) in reverse chronological order (newest first).

---

## Working with Links

### Internal Links (to other pages on your site)

Use absolute paths starting with `/`:

```markdown
Check out my [CV](/cv/) and [services](/services/).

Read my latest post on [Token Middleware](/blog/token-middleware/).
```

### External Links

Use full URLs:

```markdown
View my work on [GitHub](https://github.com/mihaelamj).

Connect on [LinkedIn](https://www.linkedin.com/in/mihaelamj).
```

### Links to Images

```markdown
See the [full-size diagram](/images/architecture/complete-system.png).
```

### Email Links

```markdown
Contact me at [mihaelamj@me.com](mailto:mihaelamj@me.com).
```

### Phone Links

```markdown
Call me: [+385995491157](tel:+385995491157)
```

### Anchor Links (within same page)

```markdown
Jump to [Implementation](#implementation).

## Implementation

Content here...
```

Anchors are auto-generated from headings in kebab-case.

---

## Advanced Topics

### Custom CSS for a Page

Add custom CSS in frontmatter:

```yaml
---
slug: portfolio
title: Portfolio
description: My work
css:
  - /css/portfolio.css
---
```

Then create `assets/css/portfolio.css`.

### Custom JavaScript

```yaml
---
slug: interactive-demo
title: Interactive Demo
description: Try it yourself
js:
  - /js/demo.js
---
```

Then create `assets/js/demo.js`.

### Code Syntax Highlighting

Code blocks are automatically highlighted with Prism.js:

````markdown
```swift
func greet(name: String) -> String {
    return "Hello, \(name)!"
}
```

```javascript
function greet(name) {
    return `Hello, ${name}!`;
}
```
````

Supported languages: Swift, JavaScript, Python, Bash, YAML, JSON, and more.

### Blockquotes

```markdown
> "The best way to predict the future is to invent it."
> — Alan Kay
```

### Tables

```markdown
| Feature | Supported |
|---------|-----------|
| Dark mode | ✅ |
| Syntax highlighting | ✅ |
| Blog posts | ✅ |
| Analytics | ✅ |
```

---

## File Naming Conventions

- **Directories**: Use kebab-case (`my-new-post`, not `My New Post`)
- **Images**: Use lowercase with hyphens (`hero-image.jpg`, not `Hero Image.jpg`)
- **Always use `index.md`** in each content directory

**Good:**
```
contents/blog/server-driven-ui/index.md
assets/images/blog/server-driven-ui/hero-image.jpg
```

**Bad:**
```
contents/blog/ServerDrivenUI/post.md
assets/images/blog/ServerDrivenUI/Hero Image.jpg
```

---

## Troubleshooting

### Page Not Showing

1. Check frontmatter has `slug`, `title`, `description`
2. Ensure file is named `index.md`
3. Rebuild: `make dev`
4. Check for YAML syntax errors in frontmatter

### Image Not Loading

1. Verify image exists in `assets/images/`
2. Use absolute path: `/images/...` (not `images/...`)
3. Check file name matches exactly (case-sensitive)
4. Hard refresh browser: `Cmd+Shift+R`

### Menu Item Not Appearing

1. Check `site.yml` syntax (proper indentation)
2. Ensure `url` starts and ends with `/`
3. Rebuild: `make dev`
4. Hard refresh browser

### Blog Post Not in Listing

1. Check `date` format is `YYYY-MM-DD`
2. Ensure file is at `contents/blog/[slug]/index.md`
3. Check frontmatter has all required fields
4. Rebuild: `make dev`

---

## Quick Reference

### New Page Checklist

- [ ] Create directory: `mkdir -p contents/page-name`
- [ ] Create `contents/page-name/index.md`
- [ ] Add frontmatter (slug, title, description)
- [ ] Write content
- [ ] Add to navigation in `site.yml`
- [ ] Rebuild: `make dev`
- [ ] Test at: `http://localhost:3000/page-name/`

### New Blog Post Checklist

- [ ] Create directory: `mkdir -p contents/blog/post-name`
- [ ] Create `contents/blog/post-name/index.md`
- [ ] Add frontmatter (slug, title, description, date, image)
- [ ] Write content
- [ ] Add images to `assets/images/blog/post-name/`
- [ ] Rebuild: `make dev`
- [ ] Test at: `http://localhost:3000/blog/post-name/`
- [ ] Check appears in listing at: `http://localhost:3000/`

---

## Need Help?

- **Toucan Docs**: https://toucansites.com/docs/
- **Markdown Guide**: https://www.markdownguide.org/
- **YAML Syntax**: https://yaml.org/spec/1.2/spec.html

---

Happy writing! 🚀
