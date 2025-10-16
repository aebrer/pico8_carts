#!/usr/bin/env python3
"""
Comprehensive validation script to ensure data.js and HTML files stay in sync.
This is the single source of truth checker - run before commits!
"""

import json
import re
import sys
from pathlib import Path
from typing import Dict, List, Tuple

class Colors:
    GREEN = '\033[92m'
    YELLOW = '\033[93m'
    RED = '\033[91m'
    BLUE = '\033[94m'
    END = '\033[0m'

def parse_data_js() -> Tuple[Dict, Dict]:
    """Parse WORKS and SERIES from data.js"""
    data_js_path = Path(__file__).parent.parent / "docs/assets/js/data.js"
    with open(data_js_path, 'r') as f:
        content = f.read()

    # Extract WORKS
    works_match = re.search(r'const WORKS = \{(.+?)\n\};', content, re.DOTALL)
    if not works_match:
        print(f"{Colors.RED}ERROR: Could not find WORKS object in data.js{Colors.END}")
        sys.exit(1)

    works_text = works_match.group(1)
    work_blocks = re.split(r"\n\s+'([^']+)':\s*\{", works_text)
    works = {}
    for i in range(1, len(work_blocks), 2):
        if i + 1 < len(work_blocks):
            work_id = work_blocks[i]
            work_content = work_blocks[i + 1]
            # Extract series
            series_match = re.search(r"series:\s*'([^']+)'", work_content)
            works[work_id] = {
                'series': series_match.group(1) if series_match else None
            }

    # Extract SERIES
    series_match = re.search(r'const SERIES = \{(.+?)\n\};', content, re.DOTALL)
    if not series_match:
        print(f"{Colors.RED}ERROR: Could not find SERIES object in data.js{Colors.END}")
        sys.exit(1)

    series_text = series_match.group(1)
    series_data = {}
    # Match both quoted and unquoted keys
    for match in re.finditer(r"\n\s+(?:'([^']+)'|([a-z0-9_-]+)):\s*\{([^}]+)\}", series_text, re.DOTALL):
        series_id = match.group(1) or match.group(2)
        series_content = match.group(3)
        # Extract works array
        works_match = re.search(r"works:\s*\[([^\]]+)\]", series_content)
        if works_match:
            works_str = works_match.group(1)
            work_ids = [w.strip().strip("'\"") for w in works_str.split(',')]
            series_data[series_id] = {'works': work_ids}

    return works, series_data

def get_html_files() -> Tuple[List[str], List[str]]:
    """Get list of work and series HTML files"""
    docs_path = Path(__file__).parent.parent / "docs"

    work_files = []
    for f in (docs_path / "works").glob("*.html"):
        if f.name != "_template.html":
            work_files.append(f.stem)

    series_files = []
    for f in (docs_path / "series").glob("*.html"):
        if f.name != "_template.html":
            series_files.append(f.stem)

    return sorted(work_files), sorted(series_files)

def validate():
    """Run all validation checks"""
    print(f"{Colors.BLUE}{'=' * 70}{Colors.END}")
    print(f"{Colors.BLUE}GALLERY VALIDATION (Single Source of Truth Check){Colors.END}")
    print(f"{Colors.BLUE}{'=' * 70}{Colors.END}\n")

    errors = []
    warnings = []

    # Parse data.js
    print(f"{Colors.BLUE}📖 Parsing data.js...{Colors.END}")
    works, series = parse_data_js()
    print(f"   Found {len(works)} works and {len(series)} series in data.js\n")

    # Get HTML files
    print(f"{Colors.BLUE}📁 Scanning HTML files...{Colors.END}")
    work_html_files, series_html_files = get_html_files()
    print(f"   Found {len(work_html_files)} work HTML files and {len(series_html_files)} series HTML files\n")

    # Check 1: Every work in data.js should have an HTML file
    print(f"{Colors.BLUE}✓ Check 1: Works in data.js have HTML files{Colors.END}")
    for work_id in works:
        if work_id not in work_html_files:
            errors.append(f"Work '{work_id}' exists in data.js but docs/works/{work_id}.html not found")
    if not any(work_id not in work_html_files for work_id in works):
        print(f"   {Colors.GREEN}✓ All works in data.js have HTML files{Colors.END}\n")
    else:
        print()

    # Check 2: Every work HTML file should be in data.js
    print(f"{Colors.BLUE}✓ Check 2: Work HTML files are in data.js{Colors.END}")
    for work_id in work_html_files:
        if work_id not in works:
            errors.append(f"HTML file docs/works/{work_id}.html exists but work not found in data.js")
    if not any(work_id not in works for work_id in work_html_files):
        print(f"   {Colors.GREEN}✓ All work HTML files are in data.js{Colors.END}\n")
    else:
        print()

    # Check 3: Every series in data.js should have an HTML file
    print(f"{Colors.BLUE}✓ Check 3: Series in data.js have HTML files{Colors.END}")
    for series_id in series:
        if series_id not in series_html_files:
            errors.append(f"Series '{series_id}' exists in data.js but docs/series/{series_id}.html not found")
    if not any(series_id not in series_html_files for series_id in series):
        print(f"   {Colors.GREEN}✓ All series in data.js have HTML files{Colors.END}\n")
    else:
        print()

    # Check 4: Every series HTML file should be in data.js
    print(f"{Colors.BLUE}✓ Check 4: Series HTML files are in data.js{Colors.END}")
    for series_id in series_html_files:
        if series_id not in series:
            errors.append(f"HTML file docs/series/{series_id}.html exists but series not found in data.js")
    if not any(series_id not in series for series_id in series_html_files):
        print(f"   {Colors.GREEN}✓ All series HTML files are in data.js{Colors.END}\n")
    else:
        print()

    # Check 5: Series references are valid
    print(f"{Colors.BLUE}✓ Check 5: Work series references are valid{Colors.END}")
    for work_id, work_data in works.items():
        if work_data['series'] and work_data['series'] not in series:
            errors.append(f"Work '{work_id}' references series '{work_data['series']}' which doesn't exist in SERIES")
    if not any(work_data['series'] and work_data['series'] not in series for work_data in works.values()):
        print(f"   {Colors.GREEN}✓ All work series references are valid{Colors.END}\n")
    else:
        print()

    # Check 6: Series work lists are valid
    print(f"{Colors.BLUE}✓ Check 6: Series work lists reference valid works{Colors.END}")
    for series_id, series_data in series.items():
        for work_id in series_data['works']:
            if work_id not in works:
                errors.append(f"Series '{series_id}' references work '{work_id}' which doesn't exist in WORKS")
    if not any(work_id not in works for series_data in series.values() for work_id in series_data['works']):
        print(f"   {Colors.GREEN}✓ All series work lists reference valid works{Colors.END}\n")
    else:
        print()

    # Check 7: Bidirectional consistency (work says series A, series A includes work)
    print(f"{Colors.BLUE}✓ Check 7: Bidirectional series/work consistency{Colors.END}")
    for work_id, work_data in works.items():
        if work_data['series']:
            series_id = work_data['series']
            if series_id in series:
                if work_id not in series[series_id]['works']:
                    warnings.append(f"Work '{work_id}' says it's in series '{series_id}', but series doesn't list it in works array")

    for series_id, series_data in series.items():
        for work_id in series_data['works']:
            if work_id in works:
                if works[work_id]['series'] != series_id:
                    warnings.append(f"Series '{series_id}' lists work '{work_id}', but work says its series is '{works[work_id]['series']}'")

    if not warnings:
        print(f"   {Colors.GREEN}✓ All series/work relationships are bidirectionally consistent{Colors.END}\n")
    else:
        print()

    # Print results
    print(f"{Colors.BLUE}{'=' * 70}{Colors.END}")
    print(f"{Colors.BLUE}RESULTS{Colors.END}")
    print(f"{Colors.BLUE}{'=' * 70}{Colors.END}\n")

    if errors:
        print(f"{Colors.RED}❌ ERRORS ({len(errors)}):{Colors.END}")
        for error in errors:
            print(f"   {Colors.RED}✗{Colors.END} {error}")
        print()

    if warnings:
        print(f"{Colors.YELLOW}⚠️  WARNINGS ({len(warnings)}):{Colors.END}")
        for warning in warnings:
            print(f"   {Colors.YELLOW}⚠{Colors.END} {warning}")
        print()

    if not errors and not warnings:
        print(f"{Colors.GREEN}🎉 SUCCESS! Gallery data is fully consistent.{Colors.END}\n")
        return 0
    elif errors:
        print(f"{Colors.RED}❌ FAILED: {len(errors)} error(s) must be fixed.{Colors.END}\n")
        return 1
    else:
        print(f"{Colors.YELLOW}⚠️  PASSED with {len(warnings)} warning(s).{Colors.END}\n")
        return 0

if __name__ == "__main__":
    sys.exit(validate())
