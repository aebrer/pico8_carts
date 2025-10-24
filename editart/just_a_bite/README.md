# just a bite

**Working title** - EditART version of CORAL HUNTING engine

Entropy-locked ASCII screensaver where each seed generates its own character vocabulary through a random walk. Built for editart.xyz platform (sliderless mode).

## Testing

Start a local server:
```bash
cd /home/andrew/pico8_carts/editart/just_a_bite
python3 -m http.server 8000
```

Then test in editart sandbox (sliderless mode):
https://www.editart.xyz/sandbox?sliderLess=true

Paste: `http://localhost:8000/`

## Changes from CORAL HUNTING

- Uses editart's `randomFull()` instead of fxhash's `$fx.rand()`
- Wrapped in `drawArt()` function (called on seed change and resize)
- Calls `triggerPreview()` after initial render
- No interactive controls (r, p, f keys) - pure deterministic output

## Technical

- WebGL-accelerated rendering
- 420x420 character grid at 30fps
- Entropy locking at 0.1% probability per frame
- Seed-specific character sets via random walk through master palette
- Tight entropy locking during charset generation creates distinct visual identities
