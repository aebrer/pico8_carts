#!/usr/bin/env python3
"""
Verify that all thumbnail URLs from thumbnail_urls.json are present in the
corresponding HTML work pages as Open Graph og:image tags.
"""

import json
import re
from pathlib import Path

# Read the thumbnail URLs
thumbnails_path = Path(__file__).parent / "thumbnail_urls.json"
with open(thumbnails_path, 'r') as f:
    thumbnails = json.load(f)

# Check each work
docs_works = Path(__file__).parent.parent / "docs/works"
missing = []
mismatched = []
found = []

for work_id, urls in thumbnails.items():
    html_path = docs_works / f"{work_id}.html"

    if not html_path.exists():
        missing.append({
            'work_id': work_id,
            'issue': 'HTML file not found',
            'expected_path': str(html_path)
        })
        continue

    # Read the HTML file
    with open(html_path, 'r') as f:
        html_content = f.read()

    # Look for og:image meta tag
    og_image_match = re.search(r'<meta property="og:image" content="([^"]+)"', html_content)

    if not og_image_match:
        missing.append({
            'work_id': work_id,
            'issue': 'No og:image tag found in HTML',
            'expected_url': urls.get('thumbnail') or urls.get('display', '')
        })
        continue

    og_image_url = og_image_match.group(1)
    expected_url = urls.get('thumbnail') or urls.get('display', '')

    if og_image_url != expected_url:
        mismatched.append({
            'work_id': work_id,
            'html_url': og_image_url,
            'json_url': expected_url
        })
    else:
        found.append(work_id)

# Print results
print("=" * 60)
print("THUMBNAIL VERIFICATION REPORT")
print("=" * 60)
print()

if found:
    print(f"✅ CORRECTLY CONFIGURED ({len(found)} pieces):")
    for work_id in sorted(found):
        print(f"   - {work_id}")
    print()

if missing:
    print(f"❌ MISSING OR NOT FOUND ({len(missing)} pieces):")
    for item in missing:
        print(f"   - {item['work_id']}")
        print(f"     Issue: {item['issue']}")
        if 'expected_path' in item:
            print(f"     Expected: {item['expected_path']}")
        if 'expected_url' in item:
            print(f"     Expected URL: {item['expected_url']}")
        print()

if mismatched:
    print(f"⚠️  MISMATCHED ({len(mismatched)} pieces):")
    for item in mismatched:
        print(f"   - {item['work_id']}")
        print(f"     HTML has: {item['html_url']}")
        print(f"     JSON has: {item['json_url']}")
        print()

# Summary
print("=" * 60)
print(f"SUMMARY: {len(found)} correct, {len(missing)} missing, {len(mismatched)} mismatched")
print("=" * 60)

if not missing and not mismatched:
    print("\n🎉 All thumbnails are correctly configured!")
    exit(0)
else:
    exit(1)
