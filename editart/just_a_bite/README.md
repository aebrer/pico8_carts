# just a bite

**Working title** - Minimal unit derivative of CORAL HUNTING (for editart.xyz)

Follows the THE FALL → petite chute relationship:
- **CORAL HUNTING**: 420x420 chars, moiré hunting through viewport resizing
- **just a bite**: 8x8 chars, isolated character vocabulary + burn dynamics

The minimal "bite" reveals the atomic behavior: seed-specific character vocabulary generation and color burn propagation at their smallest viable scale.

## Design Intent

Like petite chute strips THE FALL down to 8x8 pixels to reveal pure color harmony, "just a bite" strips CORAL HUNTING down to 8x8 characters to reveal:
- Character vocabulary identity (matrixy, pipe patterns, varied aesthetics per seed)
- Pure burn dynamics without spatial moiré emergence
- The atomic unit that, when multiplied 420x420 times, becomes CORAL HUNTING

Future iteration direction: entropy-locked self-copying post-process (homage to beginner_ideocartography) where the rendered frame copies parts of itself before display.

## Testing

Start a local server:
```bash
cd /home/andrew/pico8_carts/editart/just_a_bite
python3 -m http.server 8069
```

Then test in editart sandbox (sliderless mode):
https://www.editart.xyz/sandbox?sliderLess=true

Paste: `http://localhost:8069/`

## Changes from CORAL HUNTING

- **Grid size**: 420x420 → 8x8 characters (64 cells total)
- **Iterations**: ~47k → ~17 per frame (auto-scaled by cell count)
- **Display**: Fixed centered scaling (no viewport hunting mechanic)
- **Platform**: editart's `randomFull()` instead of fxhash RNG
- **Determinism**: Same seed always produces same output
- **Architecture**: render() kept separate for future self-copying step

## Technical

- WebGL-accelerated rendering
- 8x8 character grid (64x96px canvas, upscaled with crisp pixel rendering)
- 30fps with ~17 iterations per frame
- Entropy locking at 0.1% probability per frame
- Seed-specific character sets via tight entropy-locked walk through master palette
- Character vocabulary generation creates distinct visual identities per seed
- Iosevka monospace font embedded for complete Unicode glyph coverage (box-drawing, arrows, symbols)
