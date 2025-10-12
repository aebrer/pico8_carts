# GitHub Pages Setup Instructions

**How to point aebrer.xyz to the new gallery in pico8_carts repo**

## Current Setup
- Domain: aebrer.xyz
- Currently points to: aebrer.github.io repo
- New location: pico8_carts repo, `docs/` folder

## Steps to Switch

### 1. In GitHub Settings for `pico8_carts` repo

1. Go to: https://github.com/aebrer/pico8_carts/settings/pages
2. Under "Build and deployment":
   - **Source:** Deploy from a branch
   - **Branch:** `master` (or `repo-reorganization-2025` if you want to test first)
   - **Folder:** `/docs` (important! not root)
3. Click "Save"

### 2. Wait for Deployment

- GitHub will build and deploy automatically
- Takes 1-2 minutes
- Check deployment status: https://github.com/aebrer/pico8_carts/deployments

### 3. Verify It Works

- Visit: https://aebrer.github.io/pico8_carts/ (temporary GitHub Pages URL)
- Should show your new gallery
- If it works, the domain will automatically redirect once GitHub processes the CNAME

### 4. Domain Should Automatically Switch

Since we have `CNAME` file in the `docs/` folder with `aebrer.xyz`, GitHub Pages will automatically:
- Recognize the custom domain
- Redirect aebrer.xyz → new gallery
- Handle HTTPS certificates

**If the domain doesn't switch automatically:**
1. Go to repo settings → Pages
2. Under "Custom domain", ensure it shows: `aebrer.xyz`
3. Check "Enforce HTTPS"
4. Save

### 5. Optional: Disable Old Repo's GitHub Pages

To prevent confusion:
1. Go to: https://github.com/aebrer/aebrer.github.io/settings/pages
2. Under "Build and deployment":
   - **Source:** None (disable GitHub Pages)
3. Save

## Testing Before Full Switch

If you want to test before switching the domain:

1. Deploy to a branch first:
   - Set branch to `repo-reorganization-2025`
   - Access via: https://aebrer.github.io/pico8_carts/

2. Once everything looks good:
   - Merge `repo-reorganization-2025` → `master`
   - Change Pages settings to use `master` branch
   - Domain will automatically redirect

## What the CNAME File Does

The `docs/CNAME` file contains:
```
aebrer.xyz
```

This tells GitHub Pages:
- "This repo should be accessible at aebrer.xyz"
- GitHub handles DNS and HTTPS automatically
- No manual DNS changes needed (already configured)

## Rollback Plan

If something breaks:
1. Go to pico8_carts repo settings → Pages
2. Set Source to "None" (disable)
3. Go to aebrer.github.io repo settings → Pages
4. Re-enable Pages (source: Deploy from branch, branch: main or master, folder: /docs)
5. Domain will revert to old site

## Expected Result

- ✅ aebrer.xyz → New gallery with beginner_ideocartography
- ✅ All links preserved from old site
- ✅ HTTPS working
- ✅ Fast load times
- ✅ Old site disabled to prevent confusion

---

*The CNAME file is already in place. Just need to enable Pages with the right settings!*
