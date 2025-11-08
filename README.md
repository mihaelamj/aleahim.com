# Aleahim.com

Personal website for Mihaela Mihaljević Jakić - Senior iOS Architect & Developer.

Built with [Toucan](https://github.com/toucansites/toucan) static site generator.

## Features

- **Dark Gothic Theme** - Purple, almost-black, tan, and white color scheme
- **Blog Posts** - 7 technical articles on Swift, OpenAPI, and iOS development
- **CV** - Complete professional history
- **Services** - OpenAPI consulting offerings
- **Umami Analytics** - Privacy-friendly analytics
- **Syntax Highlighting** - Prism.js with Tomorrow dark theme

## Local Development

```bash
# Build the site
make dev

# Watch for changes (runs in background)
make watch

# Serve locally
make serve

# Visit: http://localhost:3000
```

## Adding Content

See [CONTENT-GUIDE.md](CONTENT-GUIDE.md) for detailed instructions on:
- Adding new pages
- Adding menu items
- Adding images
- Creating blog posts

## Site Structure

```
aleahim.com/
├── contents/           # All content pages
│   ├── [home]/        # Homepage (blog listing)
│   ├── about/         # About page
│   ├── cv/            # Curriculum Vitae
│   ├── services/      # Consulting services
│   └── blog/          # Blog posts
├── assets/
│   ├── css/           # Custom styles
│   └── images/        # All images
├── templates/
│   ├── default/       # Base templates (submodule)
│   └── overrides/     # Custom template overrides
├── types/             # Content type definitions
├── pipelines/         # Build pipeline configs
└── site.yml           # Site configuration & navigation
```

## Deployment

The site automatically deploys to GitHub Pages when you push to main.

```bash
git add .
git commit -m "Update content"
git push origin main
```

## Tech Stack

- **Generator**: Toucan (Swift-based)
- **Templating**: Mustache
- **Styling**: Custom CSS with CSS variables
- **Syntax Highlighting**: Prism.js
- **Analytics**: Umami (privacy-friendly)
- **Hosting**: GitHub Pages

## Contact

- Email: mihaelamj@me.com
- Phone: +385995491157
- [LinkedIn](https://www.linkedin.com/in/mihaelamj)
- [GitHub](https://github.com/mihaelamj)
- [Website](https://aleahim.com)

## License

Content © 2025 Mihaela Mihaljević Jakić. All rights reserved.
