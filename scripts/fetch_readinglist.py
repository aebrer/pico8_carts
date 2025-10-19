#!/usr/bin/env python3
"""
Generate a random reading list for getting up to speed on the gallery.

Selects a random sample of series pages and work pages for a new Claude instance
to read as part of the onboarding process defined in CLAUDE.md.
"""

import random
import os
from pathlib import Path

def get_gallery_pages():
    """Get all available series and work pages."""
    repo_root = Path(__file__).parent.parent
    docs_dir = repo_root / "docs"

    series_dir = docs_dir / "series"
    works_dir = docs_dir / "works"

    # Get all series pages (exclude _template.html)
    series_pages = [
        f for f in series_dir.glob("*.html")
        if f.name != "_template.html"
    ]

    # Get all work pages (exclude _template.html)
    work_pages = [
        f for f in works_dir.glob("*.html")
        if f.name != "_template.html"
    ]

    return series_pages, work_pages

def generate_reading_list(num_series=2, num_works=3, seed=None):
    """
    Generate a random reading list.

    Args:
        num_series: Number of series pages to select (default: 2)
        num_works: Number of work pages to select (default: 3)
        seed: Optional random seed for reproducible results
    """
    if seed is not None:
        random.seed(seed)

    series_pages, work_pages = get_gallery_pages()

    # Select random samples
    selected_series = random.sample(series_pages, min(num_series, len(series_pages)))
    selected_works = random.sample(work_pages, min(num_works, len(work_pages)))

    # Print reading list
    print("=" * 60)
    print("GALLERY READING LIST")
    print("=" * 60)
    print()
    print("Series Pages:")
    for i, page in enumerate(selected_series, 1):
        print(f"  {i}. {page}")

    print()
    print("Work Pages:")
    for i, page in enumerate(selected_works, 1):
        print(f"  {i}. {page}")

    print()
    print("=" * 60)
    print(f"Total: {len(selected_series)} series + {len(selected_works)} works")
    print("=" * 60)

    return selected_series, selected_works

if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(
        description="Generate random reading list for gallery onboarding"
    )
    parser.add_argument(
        "--series",
        type=int,
        default=2,
        help="Number of series pages to select (default: 2)"
    )
    parser.add_argument(
        "--works",
        type=int,
        default=3,
        help="Number of work pages to select (default: 3)"
    )
    parser.add_argument(
        "--seed",
        type=int,
        help="Random seed for reproducible results"
    )

    args = parser.parse_args()

    generate_reading_list(
        num_series=args.series,
        num_works=args.works,
        seed=args.seed
    )
