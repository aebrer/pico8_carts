# Gallery Migration Workflow

**Streamlined process for migrating pieces to the gallery**

## For Each Piece

### 1. Gather Information (5 min)

**If it's on fxhash/teia/objkt:**
- Get the page source (View Source in browser)
- Extract from JSON data:
  - `generativeUri` or `artifactUri` → IPFS link
  - `metadata.description` → Description text
  - `created_at` → Year
  - `metadata.tags` → Themes
- Note the platform URL

**If it's unpublished:**
- Find the code in the repo
- Ask Drew for description, themes, and context
- IPFS link will be N/A (just code + description)

### 2. Add to Data Structure (2 min)

Add entry to `docs/assets/js/data.js`:

```javascript
'piece-id': {
  id: 'piece-id',
  title: 'Piece Title',
  series: 'series-id',
  year: 2022,
  platform: 'fxhash' or 'objkt' or 'teia' or 'unpublished',
  description: 'Brief description',
  ipfs: 'https://gateway.fxhash2.xyz/ipfs/...' or 'https://ipfs.io/ipfs/...',
  isGenerative: true/false, // true for fxhash generative pieces
  links: {
    fxhash: 'https://...',
    teia: 'https://...',
    objkt: 'https://...',
  },
  provenance: 'ipfs://Qm...', // IPFS metadata link
  thumbnail: 'https://ipfs.io/ipfs/Qm...', // Extract from metadata (see step 2a)
  sourceCode: 'https://github.com/aebrer/pico8_carts/tree/master/series/[series]/[folder_name]', // IMPORTANT: Use exact folder name (underscores, capitalization, etc.)
  favorite: true/false, // Mark favorites
  themes: ['theme1', 'theme2', 'theme3']
}
```

**CRITICAL: Source Code Link**
- Must use the EXACT folder name from the filesystem
- Check with `ls series/[series-name]/` to get the exact name
- Common gotchas: underscores vs hyphens, capitalization (e.g., `VISIONS` not `visions`)
- Example: `beginner_ideocartography` NOT `beginner-ideocartography`

Add piece ID to the series works array in SERIES.

### 2a. Extract Thumbnail from Metadata (1 min)

**For published pieces with provenance:**

Fetch the metadata from the provenance IPFS/Arweave link to get the thumbnail URL:

```bash
# If you have a single new piece, manually fetch:
curl https://ipfs.io/ipfs/QmXXXX... | jq '.thumbnailUri, .displayUri, .image'

# For batch extraction, use the script:
python3 scripts/fetch_thumbnails.py
# This outputs to scripts/thumbnail_urls.json
```

**Metadata format differences:**
- **IPFS (fxhash/teia/objkt):** Uses `thumbnailUri` (smaller) and `displayUri` (larger)
- **Arweave:** Uses `image` field

Add the thumbnail URL to your data.js entry (see example above). Place it after the `provenance` field.

**For unpublished pieces:** Leave thumbnail as empty string or omit the field.

### 3. Move Code to Series Folder (1 min)

**For pieces with folders:**
```bash
mkdir -p series/[series-name]/
git mv [old-location] series/[series-name]/[piece-folder-name]
```

**For single-file pieces (e.g., tweetcarts):**
```bash
mkdir -p series/[series-name]/
git mv [old-location]/piece.p8 series/[series-name]/piece.p8
```

**CRITICAL:** After moving files, update the `sourceCode` link in data.js:
- For folders: `https://github.com/aebrer/pico8_carts/tree/master/series/[series]/[folder]`
- For single files: `https://github.com/aebrer/pico8_carts/blob/master/series/[series]/file.p8`
- Note: Use `blob` for files, `tree` for folders
- Point to the specific file when possible (not ambiguous folder)

### 4. Create Gallery Page (2 min)

Copy template:
```bash
cp docs/works/_template.html docs/works/[piece-id].html
```

Find/replace placeholders:
- `[WORK_ID]` → piece-id (must match data.js key)
- `[WORK_TITLE]` → Title
- `[SERIES_ID]` → series-id
- `[SERIES_NAME]` → Series Name
- `[DESCRIPTION]` → Full description (with proper structure - see below)
- `[IPFS_URL]` → IPFS link (with trailing slash!)
- `[IS_GENERATIVE]` → true or false
- `[THUMBNAIL_URL]` → Thumbnail URL from step 2a (for Open Graph social media previews)

**Auto-rendered from data.js:** Themes, links, provenance, and favorite star all render automatically!

**Open Graph / Social Media Tags:**
The template includes Open Graph and Twitter Card meta tags for rich social media previews. These tags use the thumbnail URL from step 2a:
```html
<meta property="og:image" content="[THUMBNAIL_URL]">
<meta name="twitter:image" content="[THUMBNAIL_URL]">
```
Replace `[THUMBNAIL_URL]` with the thumbnail URL extracted from the metadata. This ensures proper link previews on Twitter, Discord, Facebook, etc.

**Description Structure:**
Use clear headings to separate fiction from author commentary:
- `<h3>In-Fiction Description</h3>` for world/story content
- `<h3 style="margin-top: 30px;">Author's Notes</h3>` for meta commentary
- Italicize author's notes content: `<p><em>...</em></p>`
- Include Pico-8 BBS link if available: `<a href="https://www.lexaloffle.com/bbs/?tid=XXXXX" target="_blank">Pico-8 BBS</a>`

**Important:**
- `[WORK_ID]` must exactly match the key in data.js
- Themes, links, provenance, and stars automatically render from data.js
- Add trailing slash to IPFS URLs
- For PNG/image files, use `git add -f` to override .gitignore
- `[THUMBNAIL_URL]` should be the `thumbnail` field from data.js (extracted in step 2a)

### 5. Review Tags (1 min)

**IMPORTANT:** Before testing, review the themes list against all available tags to catch any that apply:
- Read through the complete list of existing themes across all works
- Check for: easter egg, secret hunting, entropy locking, pareidolia, SCP aesthetics, etc.
- Consider technical aspects (text-based, CYOA, seed-based, etc.)
- Consider thematic aspects (infohazard, cognitohazard, memetic, etc.)
- Think about gameplay mechanics (achievement system, doom timer, etc.)

### 6. Test (2 min)

Open in browser:
- `docs/index.html` → Check featured work
- `docs/series/[series].html` → Check series page
- `docs/works/[piece].html` → Check piece page, randomize button (if generative)

### 7. Validate and Commit (1 min)

```bash
# Validate before committing (optional - pre-commit hook runs automatically)
python3 scripts/validate_gallery.py

# Commit (pre-commit hook validates automatically)
git add -A
git commit -m "Migrate [piece-name] to gallery"
git push
```

**Note:** A pre-commit hook automatically validates gallery consistency. If validation fails, the commit is rejected. See `docs/VALIDATION.md` for details.

## Tips for Speed

- **Grab page source first** for published pieces (saves hunting for metadata)
- **Batch gather info** for multiple pieces from same series before coding
- **Use template liberally** - it has all the patterns ready
- **Test in batches** rather than after each piece
- **For fxhash pieces:** Always add trailing slash to IPFS URL and set `isGenerative: true`

## Centralized Modules (The "Navbar Treatment")

The gallery uses centralized JavaScript modules for consistency and maintainability:

### Artwork Pages (`/docs/assets/js/`)
- **`artwork-controls.js`** - Handles iframe loading, randomize button, fullscreen button
- **`artwork-metadata.js`** - Auto-renders themes, platform links, provenance from data.js
- **`series-page.js`** - Auto-renders series pages (featured work + works grid with stars)
- **`nav.js`** - Navigation bar

These modules read from meta tags and data.js to auto-render content. Just add the right meta tag!

### Creating New Pages

**Artwork page:**
```html
<meta name="work-id" content="piece-id">
```
Themes, links, provenance, controls → all auto-render

**Series page:**
```html
<meta name="series-id" content="series-id">
```
Featured work, works grid, favorite stars → all auto-render

## Common Gotchas

- ✅ IPFS URLs need trailing slash: `.../QmXXX/`
- ✅ IPFS URLs must be complete - check objkt if truncated
- ✅ **For onchfs URLs:** Full URL with query params, use exact link from fxhash page source
- ✅ **Double-check fxhash links** - use project page, NOT someone else's work by similar name
- ✅ Provenance uses `ipfs://` format in data.js (auto-converted to https)
- ✅ Provenance should be direct IPFS link, not fxhash server URL
- ✅ `[WORK_ID]` in HTML must exactly match key in data.js
- ✅ **Source code link MUST use exact folder name** - use `ls` to check! (underscores, caps, etc.)
- ✅ Themes, links, provenance, and stars auto-render from data.js - don't hardcode!
- ✅ Randomize/fullscreen buttons auto-render via `artwork-controls.js`
- ✅ Mark favorites so they appear in featured rotation AND get star emoji
- ✅ Add piece ID to series works array in SERIES object
- ✅ Use `git add -f` for images (.png files ignored by default)
- ✅ Structure descriptions with headings: "In-Fiction Description" and "Author's Notes"
- ✅ Italicize all author's notes content
- ✅ Include Pico-8 BBS development thread links when available
- ✅ **Extract thumbnail from metadata** (step 2a) and add to both data.js AND HTML Open Graph tags
- ✅ Open Graph `og:image` and `twitter:image` tags must use full HTTPS URLs (not ipfs:// format)
- ✅ **Stick to exact user wording** - don't add "flavor" to artist's notes

## Estimated Time Per Piece

- **Published generative (fxhash):** ~10 min (simplified with auto-rendering modules)
- **Published non-generative:** ~8 min
- **Unpublished:** ~7 min (less metadata to gather)

## Batch Processing Strategy

1. **Series at a time** - Do all ideocart, then all vestiges, etc.
2. **Gather first** - Collect all metadata/page sources before coding
3. **Code in batches** - Do 3-5 pieces, then test all at once
4. **Commit frequently** - After each successful batch

---

*This workflow will evolve as we learn what works best!*
