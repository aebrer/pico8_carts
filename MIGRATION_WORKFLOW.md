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
  platform: 'fxhash' or 'objkt' or 'unpublished',
  description: 'Brief description',
  ipfs: 'https://gateway.fxhash2.xyz/ipfs/...' or null,
  isGenerative: true/false, // true for fxhash generative pieces
  links: {
    fxhash: 'https://...',
    objkt: 'https://...',
  },
  favorite: true/false, // Mark favorites
  themes: ['theme1', 'theme2']
}
```

Add piece ID to the series works array.

### 3. Move Code to Series Folder (1 min)

```bash
mkdir -p series/[series-name]/[piece-name]
mv [old-location] series/[series-name]/[piece-name]/
```

### 4. Create Gallery Page (5 min)

Copy template:
```bash
cp docs/works/_template.html docs/works/[piece-id].html
```

Find/replace placeholders:
- `[WORK_TITLE]` → Title
- `[SERIES_ID]` → series-id
- `[SERIES_NAME]` → Series Name
- `[YEAR]` → Year
- `[PLATFORM]` → Platform name
- `[THEMES]` → Theme list
- `[DESCRIPTION]` → Full description (with proper structure - see below)
- `[LINKS]` → External links HTML
- `[IPFS_URL]` → IPFS link (with trailing slash!)
- `[IS_GENERATIVE]` → true or false
- `[CODE_LINK]` → GitHub link to master branch

**Description Structure:**
Use clear headings to separate fiction from author commentary:
- `<h3>In-Fiction Description</h3>` for world/story content
- `<h3 style="margin-top: 30px;">Author's Notes</h3>` for meta commentary
- Italicize author's notes content: `<p><em>...</em></p>`
- Include Pico-8 BBS link if available: `<a href="https://www.lexaloffle.com/bbs/?tid=XXXXX" target="_blank">Pico-8 BBS</a>`

**Important:**
- Use `master` branch (not main)
- Use new organized path: `series/[series-name]/[piece-name]/`
- Add trailing slash to IPFS URLs
- For PNG/image files, use `git add -f` to override .gitignore

### 5. Test (2 min)

Open in browser:
- `docs/index.html` → Check featured work
- `docs/series/[series].html` → Check series page
- `docs/works/[piece].html` → Check piece page, randomize button (if generative)

### 6. Commit (1 min)

```bash
git add -A
git commit -m "Migrate [piece-name] to gallery"
git push
```

## Tips for Speed

- **Grab page source first** for published pieces (saves hunting for metadata)
- **Batch gather info** for multiple pieces from same series before coding
- **Use template liberally** - it has all the patterns ready
- **Test in batches** rather than after each piece
- **For fxhash pieces:** Always add trailing slash to IPFS URL and set `isGenerative: true`

## Common Gotchas

- ✅ IPFS URLs need trailing slash: `.../QmXXX/`
- ✅ IPFS URLs must be complete - check objkt if truncated
- ✅ Use `master` branch not `main`
- ✅ Randomize button needs `IS_GENERATIVE = true`
- ✅ Source code links point to new `series/` location
- ✅ Mark favorites so they appear in featured rotation
- ✅ Add piece ID to series works array in data.js
- ✅ Use `git add -f` for images (.png files ignored by default)
- ✅ Structure descriptions with headings: "In-Fiction Description" and "Author's Notes"
- ✅ Italicize all author's notes content
- ✅ Include Pico-8 BBS development thread links when available

## Estimated Time Per Piece

- **Published generative (fxhash):** ~15 min
- **Published non-generative:** ~12 min
- **Unpublished:** ~10 min (less metadata to gather)

## Batch Processing Strategy

1. **Series at a time** - Do all ideocart, then all vestiges, etc.
2. **Gather first** - Collect all metadata/page sources before coding
3. **Code in batches** - Do 3-5 pieces, then test all at once
4. **Commit frequently** - After each successful batch

---

*This workflow will evolve as we learn what works best!*
