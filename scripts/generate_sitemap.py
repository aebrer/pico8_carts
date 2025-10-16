#!/usr/bin/env python3
"""
Generate sitemap.xml from data.js for SEO.
Reads WORKS and SERIES from data.js and creates a sitemap with all pages.
"""

import json
import re
from pathlib import Path
from datetime import datetime

# Read data.js
data_js_path = Path(__file__).parent.parent / "docs/assets/js/data.js"
with open(data_js_path, 'r') as f:
    content = f.read()

# Extract WORKS object
works_match = re.search(r'const WORKS = \{(.+?)\n\};', content, re.DOTALL)
if not works_match:
    print("Could not find WORKS object in data.js")
    exit(1)

works_text = works_match.group(1)

# Extract SERIES object
series_match = re.search(r'const SERIES = \{(.+?)\n\};', content, re.DOTALL)
if not series_match:
    print("Could not find SERIES object in data.js")
    exit(1)

series_text = series_match.group(1)

# Parse work IDs
work_blocks = re.split(r"\n\s+'([^']+)':\s*\{", works_text)
work_ids = []
for i in range(1, len(work_blocks), 2):
    if i < len(work_blocks):
        work_ids.append(work_blocks[i])

# Parse series IDs (handles both quoted and unquoted keys)
series_ids = []
# Match both 'quoted': and unquoted: formats
for match in re.finditer(r"\n\s+(?:'([^']+)'|([a-z0-9_-]+)):\s*\{", series_text):
    series_id = match.group(1) or match.group(2)
    if series_id:
        series_ids.append(series_id)

# Generate sitemap XML
base_url = "https://entropist.ca"
today = datetime.now().strftime("%Y-%m-%d")

sitemap_lines = [
    '<?xml version="1.0" encoding="UTF-8"?>',
    '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">',
    '',
    '  <!-- Main page -->',
    '  <url>',
    f'    <loc>{base_url}/</loc>',
    f'    <lastmod>{today}</lastmod>',
    '    <changefreq>weekly</changefreq>',
    '    <priority>1.0</priority>',
    '  </url>',
    ''
]

# Add series pages
sitemap_lines.append('  <!-- Series pages -->')
for series_id in sorted(series_ids):
    sitemap_lines.extend([
        '  <url>',
        f'    <loc>{base_url}/series/{series_id}.html</loc>',
        f'    <lastmod>{today}</lastmod>',
        '    <changefreq>monthly</changefreq>',
        '    <priority>0.8</priority>',
        '  </url>'
    ])
sitemap_lines.append('')

# Add work pages
sitemap_lines.append('  <!-- Work pages -->')
for work_id in sorted(work_ids):
    sitemap_lines.extend([
        '  <url>',
        f'    <loc>{base_url}/works/{work_id}.html</loc>',
        f'    <lastmod>{today}</lastmod>',
        '    <changefreq>monthly</changefreq>',
        '    <priority>0.7</priority>',
        '  </url>'
    ])
sitemap_lines.append('')

sitemap_lines.append('</urlset>')

# Write sitemap
output_path = Path(__file__).parent.parent / "docs/sitemap.xml"
with open(output_path, 'w') as f:
    f.write('\n'.join(sitemap_lines))

print(f"✅ Generated sitemap.xml with:")
print(f"   - 1 main page")
print(f"   - {len(series_ids)} series pages")
print(f"   - {len(work_ids)} work pages")
print(f"   - Total: {1 + len(series_ids) + len(work_ids)} URLs")
print(f"\nWritten to: {output_path}")
