#!/usr/bin/env python3
"""
Local web server for testing docs with Cross-Origin headers.

This server adds the required Cross-Origin headers for SharedArrayBuffer,
which is needed for Godot's threading to work in browsers.

Usage:
    python3 scripts/serve_docs.py

Then open http://localhost:8069 in your browser.
"""

from http.server import HTTPServer, SimpleHTTPRequestHandler
import os
import sys

class ThreadSupportHTTPRequestHandler(SimpleHTTPRequestHandler):
    """HTTP handler that adds headers required for SharedArrayBuffer/threading"""

    def end_headers(self):
        # Required headers for SharedArrayBuffer (Godot threading)
        self.send_header('Cross-Origin-Opener-Policy', 'same-origin')
        self.send_header('Cross-Origin-Embedder-Policy', 'require-corp')

        # Optional: Cache control for development
        self.send_header('Cache-Control', 'no-cache, no-store, must-revalidate')

        super().end_headers()

    def log_message(self, format, *args):
        """Override to add colored output"""
        print(f"[{self.log_date_time_string()}] {format % args}")

def main():
    PORT = 8069
    DOCS_DIR = 'docs'

    # Verify docs directory exists
    if not os.path.exists(DOCS_DIR):
        print(f"ERROR: Directory '{DOCS_DIR}' not found!")
        sys.exit(1)

    # Change to docs directory
    os.chdir(DOCS_DIR)

    # Start server
    server = HTTPServer(('localhost', PORT), ThreadSupportHTTPRequestHandler)

    print()
    print("=" * 70)
    print("entropist.ca Docs Server (with Cross-Origin headers)")
    print("=" * 70)
    print()
    print(f"Server running at: http://localhost:{PORT}")
    print()
    print("Headers enabled:")
    print("  ✓ Cross-Origin-Opener-Policy: same-origin")
    print("  ✓ Cross-Origin-Embedder-Policy: require-corp")
    print()
    print("These headers enable SharedArrayBuffer for Godot games.")
    print()
    print("Press Ctrl+C to stop server")
    print("=" * 70)
    print()

    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print()
        print("Server stopped.")
        sys.exit(0)

if __name__ == '__main__':
    main()
