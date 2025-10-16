#!/usr/bin/env python3
"""
Fetch thumbnail URLs from IPFS metadata for all published works.
Reads from docs/assets/js/data.js and outputs thumbnail mappings.
"""

import json
import re
import requests
import time
from pathlib import Path

# Read data.js and extract provenance links
data_js_path = Path(__file__).parent.parent / "docs/assets/js/data.js"
with open(data_js_path, 'r') as f:
    content = f.read()

# Extract WORKS object
works_match = re.search(r'const WORKS = \{(.+?)\};', content, re.DOTALL)
if not works_match:
    print("Could not find WORKS object in data.js")
    exit(1)

works_text = works_match.group(1)

# Simpler approach: find each work block by splitting on work IDs
# Split by pattern that looks like: '  'work-id': {
work_blocks = re.split(r"\n\s+'([^']+)':\s*\{", works_text)

matches = []
# work_blocks will be: [prefix, id1, content1, id2, content2, ...]
for i in range(1, len(work_blocks), 2):
    if i + 1 < len(work_blocks):
        work_id = work_blocks[i]
        work_content = work_blocks[i + 1]

        # Find provenance in this work's content
        prov_match = re.search(r"provenance:\s*['\"]([^'\"]+)['\"]", work_content)
        if prov_match:
            provenance = prov_match.group(1)
            matches.append((work_id, provenance))

results = {}

for work_id, provenance in matches:

    # Convert ipfs:// to https://
    if provenance.startswith('ipfs://'):
        ipfs_hash = provenance.replace('ipfs://', '')
        url = f'https://ipfs.io/ipfs/{ipfs_hash}'
    elif provenance.startswith('https://arweave.net/'):
        url = provenance
    else:
        url = provenance

    print(f"\nFetching metadata for: {work_id}")
    print(f"  URL: {url}")

    try:
        response = requests.get(url, timeout=30)
        response.raise_for_status()
        metadata = response.json()

        # Extract thumbnailUri and displayUri (or 'image' for Arweave)
        thumbnail_uri = metadata.get('thumbnailUri', '')
        display_uri = metadata.get('displayUri', metadata.get('image', ''))

        # Convert ipfs:// to https://
        if thumbnail_uri.startswith('ipfs://'):
            thumbnail_uri = thumbnail_uri.replace('ipfs://', 'https://ipfs.io/ipfs/')
        if display_uri.startswith('ipfs://'):
            display_uri = display_uri.replace('ipfs://', 'https://ipfs.io/ipfs/')

        results[work_id] = {
            'thumbnail': thumbnail_uri,
            'display': display_uri
        }

        print(f"  ✓ Thumbnail: {thumbnail_uri[:80]}...")
        print(f"  ✓ Display: {display_uri[:80]}...")

        # Be nice to IPFS gateways
        time.sleep(1)

    except requests.exceptions.RequestException as e:
        print(f"  ✗ Error fetching: {e}")
        results[work_id] = {
            'thumbnail': '',
            'display': '',
            'error': str(e)
        }
    except json.JSONDecodeError as e:
        print(f"  ✗ Error parsing JSON: {e}")
        results[work_id] = {
            'thumbnail': '',
            'display': '',
            'error': 'Invalid JSON'
        }

# Write results to a file
output_path = Path(__file__).parent.parent / "scripts/thumbnail_urls.json"
with open(output_path, 'w') as f:
    json.dump(results, f, indent=2)

print(f"\n\n{'='*60}")
print(f"Results written to: {output_path}")
print(f"{'='*60}\n")

# Print summary in a format easy to copy into data.js
print("\n// Add these thumbnail fields to data.js:\n")
for work_id, data in results.items():
    if data.get('thumbnail'):
        print(f"  '{work_id}': {{")
        print(f"    thumbnail: '{data['thumbnail']}',")
        print(f"  }},")
