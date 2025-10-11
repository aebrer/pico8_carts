# Gallery Website

Vanilla HTML/CSS/JS gallery for Andrew Brereton's generative art practice.

## Structure

```
gallery/
├── index.html              - Landing page with featured work
├── series/                 - Series pages
│   ├── _template.html     - Template for new series pages
│   ├── ideocart.html
│   ├── vestiges.html
│   └── ...
├── works/                  - Individual artwork pages
│   ├── _template.html     - Template for new work pages
│   └── [work-id].html
└── assets/
    ├── css/
    │   ├── reset.css      - Modern CSS reset
    │   └── main.css       - Main styles
    └── js/
        └── data.js        - Gallery data (works, series)
```

## Adding New Work

1. Add entry to `assets/js/data.js` in the `WORKS` object
2. Copy `works/_template.html` to `works/[work-id].html`
3. Replace placeholders:
   - `[WORK_TITLE]` - Title of the piece
   - `[WORK_DESCRIPTION]` - Brief description
   - `[SERIES_ID]` - Series identifier
   - `[SERIES_NAME]` - Series display name
   - `[YEAR]` - Year created
   - `[PLATFORM]` - Platform (fxhash, objkt, etc.)
   - `[THEMES]` - Theme tags
   - `[DESCRIPTION]` - Full description
   - `[LINKS]` - External links (fxhash, objkt, etc.)
   - `[CODE_LINK]` - Link to source code in repo
   - `[TECHNICAL_NOTES]` - Technical details
   - `[IPFS_URL]` - IPFS link for iframe

## Adding New Series

1. Add entry to `assets/js/data.js` in the `SERIES` object
2. Copy `series/_template.html` to `series/[series-id].html`
3. Replace placeholders:
   - `[SERIES_NAME]` - Display name
   - `[SERIES_DESCRIPTION]` - Description
   - `[SERIES_ID]` - Identifier (used in JS)

## Design Philosophy

- Minimal, clean aesthetic inspired by Teia/hicetnunc
- Monospace typography (IBM Plex Mono)
- Dark/light mode support via CSS variables
- Lazy-load iframes (click to view) to improve performance
- Mobile-responsive
- No build tools - pure HTML/CSS/JS

## Deployment

This will be deployed to GitHub Pages at aebrer.xyz once migration is complete.
