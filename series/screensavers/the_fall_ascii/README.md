# THE FALL (ASCII)

**Status:** Work in Progress - Permission granted by ertdfgcvb

ASCII art interpretation of THE FALL screensaver. Collaborative experiment between Drew Brereton and Claude Code.

## Current Status

WebGL implementation with entropy locking, bidirectional symbol gradients, and interactive controls. Working on refinements and testing before publication.

## Credits & Attribution

This piece uses WebGL rendering techniques inspired by [ertdfgcvb](https://ertdfgcvb.xyz/)'s work (specifically Device 1). While our implementation was written from scratch, we relied heavily on their code as a reference for GPU-accelerated ASCII rendering.

**Permission to use rendering techniques granted by ertdfgcvb on 2025-10-20** ([Bluesky post](https://bsky.app/profile/ertdfgcvb.xyz/post/3m3naspbngc2d))

## Controls

- `i` - toggle info
- `p` - pause
- `s` - save PNG
- `f` - fullscreen toggle
- `r` - new seed (stays in fullscreen)

## Technical Details

- **Algorithm:** Same as original THE FALL (entropy locking, pixel burning, random movement)
- **Character Set:** Curated palette from Pico-8 font with bidirectional gradients for visual symmetry
- **Grid:** Dynamic sizing (120 chars tall, width scales with aspect ratio)
- **Rendering:** WebGL with font texture atlas and vertex/fragment shaders
- **RNG:** fxhash for deterministic generation (no Math.random)

## Concept

Entropy locking with colored ASCII characters. Each character's brightness maps to RGB color values, creating a flowing, burning pattern that's guaranteed to loop but never predictably.
