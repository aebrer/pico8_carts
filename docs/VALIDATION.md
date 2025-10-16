# Gallery Validation System

**Single Source of Truth: `docs/assets/js/data.js`**

## Philosophy

The gallery uses `data.js` as the single source of truth for all works and series. HTML files render from this data using JavaScript modules. This architecture prevents drift and ensures maintainability as the gallery grows.

## Validation

### Automatic Validation (Pre-Commit Hook)

A git pre-commit hook runs `scripts/validate_gallery.py` automatically before every commit. If validation fails, the commit is rejected.

### Manual Validation

Run validation anytime:
```bash
python3 scripts/validate_gallery.py
```

### What Gets Validated

1. **Bidirectional consistency**: Every work in data.js has an HTML file, and vice versa
2. **Series consistency**: Every series in data.js has an HTML file, and vice versa
3. **Reference validity**: Works reference valid series
4. **List accuracy**: Series work lists reference valid works
5. **Bidirectional relationships**: If work says it's in series X, series X lists that work

## Adding New Work (The Right Way)

**Always update data.js first**, then create the HTML file:

1. Add entry to `WORKS` object in `docs/assets/js/data.js`
2. Add work ID to the appropriate series' `works` array in `SERIES` object
3. Create HTML file from template: `cp docs/works/_template.html docs/works/[work-id].html`
4. Fill in placeholders in HTML
5. Run `python3 scripts/validate_gallery.py` to confirm everything is wired up
6. Commit - the pre-commit hook will validate automatically

## Adding New Series

1. Add entry to `SERIES` object in `docs/assets/js/data.js` with `works: []` array
2. Create HTML file from template: `cp docs/series/_template.html docs/series/[series-id].html`
3. Update series HTML with proper `<meta name="series-id" content="[series-id]">`
4. The series page will auto-render from data.js via `series-page.js`
5. Run validation to confirm

## Regenerating Sitemap

After adding new works or series:
```bash
python3 scripts/generate_sitemap.py
```

This reads from data.js and generates `docs/sitemap.xml` with all pages.

## Why This Matters

As the gallery grows to 100+ pieces, manual tracking becomes impossible. This validation system:
- **Prevents orphaned pages**: HTML files without data.js entries
- **Catches broken references**: Works referencing non-existent series
- **Enforces consistency**: Bidirectional relationships stay in sync
- **Enables automation**: Sitemap generation, metadata consistency checks, etc.

## Troubleshooting

### "HTML file exists but work not found in data.js"
You created an HTML file without adding it to data.js. Add the work to the `WORKS` object.

### "Work exists in data.js but HTML file not found"
You added to data.js but forgot to create the HTML file. Use the template.

### "Work says it's in series X, but series doesn't list it"
The work's `series` field references a series, but that series' `works` array doesn't include the work ID. Add it to the array.

### "Series lists work Y, but work says its series is Z"
The series `works` array includes a work, but that work's `series` field points elsewhere. Fix the mismatch.

## Git Hook Location

The pre-commit hook is at `.git/hooks/pre-commit`. It's not tracked in git (hooks directory is gitignored), so:
- **For collaborators**: Run `chmod +x .git/hooks/pre-commit` after cloning
- **For CI/CD**: Run validation as part of the build process

---

*This validation system ensures the gallery remains maintainable at scale. When in doubt, run the validation script!*
