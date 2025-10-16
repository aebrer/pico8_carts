#!/usr/bin/env python3
"""
Add JSON-LD structured data and canonical links to existing work pages.
Runs in dry-run mode by default - use --apply to actually make changes.
"""

import re
import sys
from pathlib import Path
from typing import Dict, Optional

def parse_data_js() -> Dict:
    """Parse WORKS from data.js to get year for each work"""
    data_js_path = Path(__file__).parent.parent / "docs/assets/js/data.js"
    with open(data_js_path, 'r') as f:
        content = f.read()

    works_match = re.search(r'const WORKS = \{(.+?)\n\};', content, re.DOTALL)
    if not works_match:
        print("ERROR: Could not find WORKS object in data.js")
        sys.exit(1)

    works_text = works_match.group(1)
    work_blocks = re.split(r"\n\s+'([^']+)':\s*\{", works_text)

    works = {}
    for i in range(1, len(work_blocks), 2):
        if i + 1 < len(work_blocks):
            work_id = work_blocks[i]
            work_content = work_blocks[i + 1]

            # Extract year
            year_match = re.search(r"year:\s*(\d+)", work_content)
            year = year_match.group(1) if year_match else "Unknown"

            works[work_id] = {'year': year}

    return works

def extract_meta_value(html: str, property_name: str) -> Optional[str]:
    """Extract value from meta tag"""
    # Try property= format (Open Graph)
    match = re.search(rf'<meta property="{property_name}" content="([^"]+)"', html)
    if match:
        return match.group(1)

    # Try name= format
    match = re.search(rf'<meta name="{property_name}" content="([^"]+)"', html)
    if match:
        return match.group(1)

    return None

def has_canonical_link(html: str) -> bool:
    """Check if page already has canonical link"""
    return bool(re.search(r'<link rel="canonical"', html))

def has_json_ld(html: str) -> bool:
    """Check if page already has JSON-LD"""
    return bool(re.search(r'<script type="application/ld\+json">', html))

def add_seo_tags(html: str, work_id: str, works_data: Dict) -> tuple[str, list]:
    """Add canonical link and JSON-LD to HTML. Returns (new_html, changes_made)"""
    changes = []

    # Extract existing meta values
    title = extract_meta_value(html, "og:title")
    description = extract_meta_value(html, "description")
    thumbnail = extract_meta_value(html, "og:image")
    year = works_data.get(work_id, {}).get('year', 'Unknown')

    if not all([title, description, thumbnail]):
        changes.append(f"⚠️  Warning: Missing meta tags (title={bool(title)}, desc={bool(description)}, thumb={bool(thumbnail)})")
        return html, changes

    # Check what's already there
    has_canonical = has_canonical_link(html)
    has_ld = has_json_ld(html)

    if has_canonical and has_ld:
        changes.append("✓ Already has both canonical link and JSON-LD")
        return html, changes

    new_html = html

    # Add canonical link if missing
    if not has_canonical:
        canonical = f'\n  <!-- Canonical URL -->\n  <link rel="canonical" href="https://entropist.ca/works/{work_id}.html">\n'

        # Insert after Twitter Card tags, before Fonts section
        pattern = r'(  <meta name="twitter:image" content="[^"]+">)\n\n(  <!-- Fonts -->)'
        if re.search(pattern, new_html):
            new_html = re.sub(pattern, r'\1' + canonical + r'\2', new_html)
            changes.append("✓ Added canonical link")
        else:
            changes.append("⚠️  Could not find insertion point for canonical link")

    # Add JSON-LD if missing
    if not has_ld:
        json_ld = f'''
  <!-- JSON-LD Structured Data -->
  <script type="application/ld+json">
  {{
    "@context": "https://schema.org",
    "@type": "VisualArtwork",
    "name": "{title}",
    "description": "{description}",
    "url": "https://entropist.ca/works/{work_id}.html",
    "image": "{thumbnail}",
    "dateCreated": "{year}",
    "creator": {{
      "@type": "Person",
      "name": "Drew Brereton",
      "alternateName": "aebrer",
      "url": "https://entropist.ca"
    }},
    "artform": "Digital Art",
    "artMedium": "Generative Code"
  }}
  </script>
'''

        # Try multiple patterns to find insertion point
        # Pattern 1: After canonical link
        pattern1 = r'(  <link rel="canonical" href="[^"]+">)\n\n(  <!-- Fonts -->)'
        # Pattern 2: After Twitter tags (if no canonical yet)
        pattern2 = r'(  <meta name="twitter:image" content="[^"]+">)\n\n(  <!-- Fonts -->)'
        # Pattern 3: After canonical but with only one newline (in case formatting varies)
        pattern3 = r'(  <link rel="canonical" href="[^"]+">)\n(  <!-- Fonts -->)'

        if re.search(pattern1, new_html):
            new_html = re.sub(pattern1, r'\1' + json_ld + r'\2', new_html)
            changes.append("✓ Added JSON-LD structured data")
        elif re.search(pattern2, new_html):
            new_html = re.sub(pattern2, r'\1' + json_ld + r'\2', new_html)
            changes.append("✓ Added JSON-LD structured data")
        elif re.search(pattern3, new_html):
            new_html = re.sub(pattern3, r'\1' + '\n' + json_ld + r'\2', new_html)
            changes.append("✓ Added JSON-LD structured data")
        else:
            changes.append("⚠️  Could not find insertion point for JSON-LD")

    return new_html, changes

def process_work_pages(dry_run: bool = True):
    """Process all work pages"""
    print("=" * 70)
    print("SEO TAG ADDITION TO EXISTING WORK PAGES")
    print("=" * 70)
    print()

    if dry_run:
        print("🔍 DRY RUN MODE - No files will be modified")
        print("   Run with --apply to make actual changes")
    else:
        print("✏️  APPLY MODE - Files will be modified")
    print()

    # Load data.js
    print("📖 Loading work data from data.js...")
    works_data = parse_data_js()
    print(f"   Found {len(works_data)} works")
    print()

    # Get all work HTML files
    docs_works = Path(__file__).parent.parent / "docs/works"
    work_files = sorted([f for f in docs_works.glob("*.html") if f.name != "_template.html"])

    print(f"📁 Found {len(work_files)} work HTML files")
    print()

    # Process each file
    results = {
        'success': 0,
        'already_done': 0,
        'warnings': 0,
        'errors': 0
    }

    for work_file in work_files:
        work_id = work_file.stem
        print(f"Processing: {work_id}")

        # Read file
        with open(work_file, 'r') as f:
            original_html = f.read()

        # Add SEO tags
        new_html, changes = add_seo_tags(original_html, work_id, works_data)

        # Print changes
        for change in changes:
            print(f"  {change}")

        # Categorize result
        if not changes:
            results['errors'] += 1
        elif any('Already has' in c for c in changes):
            results['already_done'] += 1
        elif any('⚠️' in c for c in changes):
            results['warnings'] += 1
        else:
            results['success'] += 1

        # Write file if not dry run and changes were made
        if not dry_run and new_html != original_html:
            with open(work_file, 'w') as f:
                f.write(new_html)
            print(f"  💾 File updated")

        print()

    # Print summary
    print("=" * 70)
    print("SUMMARY")
    print("=" * 70)
    print(f"✓ Successfully processed: {results['success']}")
    print(f"✓ Already complete: {results['already_done']}")
    if results['warnings']:
        print(f"⚠️  Warnings: {results['warnings']}")
    if results['errors']:
        print(f"❌ Errors: {results['errors']}")
    print()

    if dry_run:
        print("🔍 This was a dry run. No files were modified.")
        print("   Run with --apply to make actual changes:")
        print("   python3 scripts/add_seo_to_existing_pages.py --apply")
    else:
        print("✅ Files have been updated!")
        print("   Run 'python3 scripts/validate_gallery.py' to verify")
    print()

if __name__ == "__main__":
    dry_run = "--apply" not in sys.argv
    process_work_pages(dry_run)
