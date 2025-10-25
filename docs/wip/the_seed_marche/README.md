# the seed marche

**Working title:** "just a bite"

Minimal unit derivative of CORAL HUNTING (for editart.xyz)

A play on "marsh" (returning to the coral theme), "march" (the seed navigation mechanic), and "marché" (market - exploring/trading seeds)

Follows the THE FALL → petite chute relationship:
- **CORAL HUNTING**: 420x420 chars, moiré hunting through viewport resizing
- **the seed marche**: 8x8 chars, isolated character vocabulary + burn dynamics

The minimal "bite" reveals the atomic behavior: seed-specific character vocabulary generation and color burn propagation at their smallest viable scale.

## Design Intent

Like petite chute strips THE FALL down to 8x8 pixels to reveal pure color harmony, "the seed marche" strips CORAL HUNTING down to 8x8 characters to reveal:
- Character vocabulary identity (matrixy, pipe patterns, varied aesthetics per seed)
- Pure burn dynamics without spatial moiré emergence
- The atomic unit that, when multiplied 420x420 times, becomes CORAL HUNTING

## Testing

Start a local server:
```bash
cd /home/andrew/pico8_carts/series/screensavers/the_seed_marche
python3 -m http.server 8069
```

Then test in editart sandbox (sliderless mode):
https://www.editart.xyz/sandbox?sliderLess=true

Paste: `http://localhost:8069/`

## Controls

- **i** - Toggle info overlay
- **p** - Pause/resume animation
- **f** - Toggle fullscreen
- **r** - Deterministic seed march (advances to next seed in infinite sequence)
- **← →** - Linear seed navigation (±0.01)
- **Tap** (mobile) - Same as 'r' key

The seed march ('r' or tap) is deterministic: starting from any seed, pressing 'r' will always give you the same next seed. This creates an explorable infinite sequence unique to your starting point. The arrow keys provide linear exploration, incrementing/decrementing the seed by 0.01 with wraparound at 0/1.

## Changes from CORAL HUNTING

- **Grid size**: 420x420 → 8x8 characters (64 cells total)
- **Iterations**: ~47k → ~17 per frame (auto-scaled by cell count)
- **Display**: Fixed centered scaling with viewport tiling (no viewport hunting mechanic)
- **Platform**: editart's `randomFull()` instead of fxhash RNG
- **Determinism**: Same seed always produces same output
- **Seed exploration**: Deterministic seed march for infinite exploration

## Technical

- WebGL-accelerated rendering
- 8x8 character grid (96x96px canvas base, upscaled with crisp pixel rendering)
- 30fps with ~17 iterations per frame
- Entropy locking at 0.1% probability per frame
- Seed-specific character sets via tight entropy-locked walk through master palette
- Character vocabulary generation creates distinct visual identities per seed
- Viewport tiling fills non-square displays seamlessly
