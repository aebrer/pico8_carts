# THE FALL (ASCII)

**Status:** Work in Progress - Not for publication without permission

ASCII art interpretation of THE FALL screensaver. Collaborative experiment between Drew Brereton and Claude Code.

## Current Status

WebGL version is almost working - characters are rendering but there are still some visual issues to resolve.

## Credits & Attribution

This piece uses WebGL rendering techniques inspired by [ertdfgcvb](https://ertdfgcvb.xyz/)'s work (specifically Device 1). While our implementation was written from scratch, we relied heavily on their code as a reference for GPU-accelerated ASCII rendering.

**Cannot be published without permission from ertdfgcvb.**

## Versions

- `index.html` / `index.js` - Original DOM-based version (deprecated - performance issues)
- `index_canvas.html` / `index_canvas.js` - Canvas 2D version (deprecated - GC stutters)
- `index_webgl.html` / `index_webgl.js` - Current WebGL version (WIP)

## Controls

- `i` - toggle info
- `p` - pause
- `s` - save PNG

## Technical Details

- **Algorithm:** Same as original THE FALL (entropy locking, pixel burning, random movement)
- **Character Set:** Curated palette from Pico-8 font (no boring letters/numbers)
- **Grid:** 80x40 characters
- **Rendering:** WebGL with font texture atlas and vertex/fragment shaders

## Concept

Entropy locking with colored ASCII characters. Each character's brightness maps to RGB color values, creating a flowing, burning pattern that's guaranteed to loop but never predictably.
