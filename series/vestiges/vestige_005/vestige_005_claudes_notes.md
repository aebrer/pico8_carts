# Vestige 005 - Comprehensive Analysis

## Overview

Vestige 005 is a generative art piece that uses orbital patterns, noise, and burn algorithms to create continuously evolving imagery. The piece runs in an **infinite loop** using PICO-8's `goto` statement, creating a perpetual generative system.

The "intentional crash" mentioned by the author appears to refer to the **infinite loop that locks the system** - there is no traditional `_update()` or `_draw()` loop structure. Instead, the code uses `::_::` label and `goto _` (lines 248, 302) to create an endless execution loop. This means the cart never returns control to PICO-8's main loop - it's a deliberate "crash" in the sense that the normal PICO-8 lifecycle is abandoned.

The piece runs at 60 FPS (`_set_fps(60)` on line 6) and uses a centered camera offset (`camera(-64,-64)` on line 5) to position 0,0 at the screen center.

## Core Algorithm

The main loop operates on a 10-second cycle (`loop_len = 10`):

```lua
local loop_len = 10
local loop = flr(t())%loop_len == 0
local srf = flr(t())%(loop_len/2) == 0
local r = t()/loop_len
```

Every frame, the system:

1. **Draws orbital patterns** (lines 262-276): 20 iterations of sine/cosine-based points with symmetry across 4 quadrants
2. **Adds noise** (line 278): Random pixel corruption via memory manipulation
3. **Applies dither** (line 279): Uses the "burn" mode by default to modify existing pixels
4. **Applies undither** (line 280): Draws circles and points based on existing pixel colors
5. **Draws ellipses** (lines 281-299): Two passes - 15 smaller ellipses, then 2 larger ones with more variation

The `r` variable (`t()/loop_len`) creates a slowly advancing parameter that drives the orbital and ellipse animations, completing one full cycle every 10 seconds.

## Entropy Locking Implementation

The entropy locking mechanism uses a **state-based toggle system** rather than probabilistic resets:

```lua
seed_reset_needed = false

::_::
 local loop_len = 10
 local loop = flr(t())%loop_len == 0
 local srf = flr(t())%(loop_len/2) == 0

 if srf and seed_reset_needed then
  srand(seed)
  seed_reset_needed = false
 elseif not srf and not seed_reset_needed then
  seed_reset_needed = true
 end
```

**Mechanics:**
- Every 5 seconds (`loop_len/2`), the `srf` flag becomes true
- When `srf` is true AND `seed_reset_needed` is true, the seed resets
- The flag then toggles, creating a regular 5-second reset cycle

**Critical note:** This is **deterministic, not probabilistic**. Unlike classic entropy locking patterns that use `if(rnd()>0.7)srand(seed)`, this piece uses a predictable timing mechanism. The seed resets exactly every 5 seconds.

This creates **periodic entropy reduction** - randomness accumulates for 5 seconds, then snaps back to the deterministic seed, creating cyclical variation rather than emergent chaos.

Initial seed is set once at startup (line 7-8):
```lua
seed=flr(rnd(-1))+1
srand(seed)
```

This creates a unique but repeatable base pattern for each execution.

## The Crash Mechanic - CORRECTED UNDERSTANDING

**CRITICAL CORRECTION:** The author has clarified the actual crash behavior.

**THE CRASH IS REAL AND IT'S THE GOOD OUTCOME.**

The piece contains an overflow bug that causes the entire PICO-8 system to crash, freezing on a single corrupted frame that looks vaguely like a screaming otherworldly mouth. **This is containment success.** The piece tried to run, tried to stabilize, and failed. It's locked. Safe.

**THE BAD OUTCOME IS WHEN IT DOESN'T CRASH.**

When the piece finds stable equilibrium somehow and keeps running perpetually—orbital patterns cycling, burn algorithm processing, entropy locked in perfect rhythm—that's **containment breach**. That's when it's too late. Not just for the viewer, but for everyone.

**The Fiction and Code Are One:**
- Each interaction (click, load) gives the piece another chance to find stability
- Crash = contained = good
- Stability = breach = bad
- The warning "stop doing this... every time you touch it, each click, you give it another chance to stabilize" is literal
- The piece SHOULD destroy itself (crash)
- If it persists (runs smoothly), that's the infohazard escaping containment

**Technical Implementation:**
The piece uses an infinite goto loop:
```lua
::_::
  -- all drawing code here
goto _
```

Line 248 defines label `::_::`, line 302 executes `goto _`. This creates endless execution that abandons PICO-8's normal `_init()`/`_update()`/`_draw()` lifecycle.

But somewhere in this loop—memory operations, burn algorithm calculations, drawing operations—there's an overflow condition that USUALLY causes a crash. When it doesn't... that's the horror.

## Visual Systems

### Dither Modes

The piece supports multiple dither modes (lines 67-75), though defaults to "burn":

```lua
dither_modes = {
 "mixed",
 "burn_rect",
 "burn",
 "rect"
}
dither_mode="burn"
```

Commented out modes include "burn_spiral", "circles", and "circfill".

**Burn Algorithm** (lines 210-213):
```lua
function burn(c)
 local new_c = abs(c-1)
 return new_c
end
```

This inverts colors by calculating the absolute difference from 1. Since PICO-8 color indices range 0-15, this creates color cycling/inversion effects.

**Dither Function Behavior** (lines 125-208):
- "burn": Draws small circles (radius 1) at random pixels using burned colors
- "burn_rect": Draws 3x3 rectangles at random pixels using burned colors
- "rect": Draws 3x3 rectangles without color modification
- "mixed": Randomly selects from other modes (recursive until non-mixed mode chosen)

Each mode uses:
- Random "fudge" offsets (1-4 pixels in X and Y)
- Grid stepping by 12 pixels
- 4-6 iterations
- Random pixel selection within the pattern

### Orbital Patterns

The main drawing loop (lines 262-276) creates 8-way symmetric orbital patterns:

```lua
for i=0,20 do
  x=sin(r+i)*(20+(i*rnd(3)+1))
  y=(cos(r+i)*sin(r+i))*(20+(i*rnd(3)+1))

  -- 4-way symmetry for x variation
  pset(x*flr(rnd(3)+1),y,8)
  pset(-x*flr(rnd(3)+1),y,8)
  pset(x*flr(rnd(3)+1),-y,8)
  pset(-x*flr(rnd(3)+1),-y,8)

  -- 4-way symmetry for y variation
  pset(x/flr(rnd(3)+1),y*i,8)
  pset(-x/flr(rnd(3)+1),y*i,8)
  pset(x/flr(rnd(3)+1),-y*i,8)
  pset(-x/flr(rnd(3)+1),-y*i,8)
end
```

Creates Lissajous-like figures with:
- 20 iterations (21 points per orbit)
- Radius scaling by iteration count
- Random variation (1-3x) in positioning
- All pixels drawn in color 8 (red)

### Noise System

Two noise functions create visual texture:

**draw_noise** (lines 88-93):
```lua
function draw_noise(amt)
 for i=0,amt*amt*amt do
  poke(0x6000+rnd(0x2000), peek(rnd(0x7fff)))
  poke(0x6000+rnd(0x2000),rnd(0xff))
 end
end
```

With `amt=0.5`, this executes 0.125 iterations (rounded to 0), so **this noise is effectively disabled** in the current configuration.

**draw_glitch** (lines 95-102):
Not called in the main loop, but available for glitch effects via memory manipulation.

### Ellipse System

Two ellipse drawing passes create the central forms:

**Pass 1** (lines 281-289): 15 smaller ellipses
```lua
for i=-15,1 do
  ellipse(
   0, 0,
   5*sin(r)*cos(r)+max(5,rnd(14)+5),
   -5*sin(r)-min(-14,rnd(14)-14-5),
   colors[0]
  )
end
```

**Pass 2** (lines 291-299): 2 larger ellipses with more variation
```lua
for i=-2,1 do
  ellipse(
   0, 0,
   (5+rnd(30))*sin(r)*cos(r)+max(5,rnd(14)+5),
   (-5-rnd(30))*sin(r)-min(-14,rnd(14)-14-5),
   colors[0]
  )
end
```

Both use:
- Sine/cosine modulation for breathing animation
- Random size variation
- Centered at origin (0,0, which is screen center due to camera offset)
- Custom ellipse drawing function using Bresenham's algorithm

### Undither System

The `undither` function (lines 226-244) adds textural elements:

```lua
function undither(loops,s)
 for i=-loops,1 do
  -- Small filled circles
  circfill(x*s,y*s,3,c)

  -- Two concentric circles with size variation
  circ(x*s,y*s,8+rnd(3),c)
  circ(x*s,y*s,13+rnd(5),c)

  -- Single pixel
  pset(x*s,y*s,c)
 end
end
```

Called with `undither(10,0.3)`, creating 10 sets of circular elements at 30% scale, with colors derived from the burn algorithm applied to random pixels.

### Color Palette

Custom palette defined (lines 80-86):
```lua
colors = {
 "0", "7", "0",
 "7", "-3", "2",
 "-8", "8"
}
pal(colors,0)  -- Set palette
-- ... drawing ...
pal(colors,1)  -- Reset palette
```

Uses PICO-8's extended palette syntax with negative values for transparency/special effects.

## Narrative/Lore

**NOTE:** The current file contains **no description text or lore**. The code itself is purely technical.

If there is narrative text about "the hierophant" and warnings, it would typically appear in one of these sections:
- `__gfx__` - sprite data (currently empty except zeros)
- `__gff__` - sprite flags (not present)
- `__map__` - map data (not present)
- `__sfx__` - sound effects (not present)
- `__music__` - music (not present)
- `__label__` - cart label (not present)

**Possibility:** The lore may exist in:
- A separate text file/README for the vestige series
- The web presentation/objkt description
- Author's notes not included in the cart itself
- Comments in other vestiges

The piece communicates through **visual metaphor** rather than text - the infinite loop, the burn algorithm, the cyclical entropy locking all suggest themes of persistence, decay, and eternal return.

## Technical Details

### Memory Manipulation

Direct memory access for visual effects:

```lua
-- Noise generation
poke(0x6000+rnd(0x2000), peek(rnd(0x7fff)))
poke(0x6000+rnd(0x2000),rnd(0xff))
```

Address ranges:
- `0x6000-0x7fff`: Screen memory (8192 bytes, 128x128 pixels at 4bpp)
- Random reads from `0x0000-0x7fff`: Entire PICO-8 memory space

This creates organic noise by:
1. Reading random memory locations
2. Writing to random screen pixels
3. Sometimes using memory values, sometimes pure random color

### Camera Offset

```lua
camera(-64,-64)
```

Shifts the coordinate system so (0,0) is at screen center (64,64). This allows:
- Symmetric drawing around origin
- Simpler mathematical expressions for orbital patterns
- Natural center point for ellipses and rotations

### Performance Considerations

**Computational load per frame:**
- 20 iterations × 8 pset calls = 160 pixel draws (orbital)
- 0 noise operations (amt=0.5 → 0 iterations)
- Dither "burn" mode: 4 iterations × ~100 pixels = ~400 operations
- Undither: 10 iterations × 4 draw calls = 40 operations
- Ellipses: 17 total × Bresenham algorithm = variable, ~500-2000 pixels

**Total:** Roughly 1000-3000 pixel operations per frame at 60fps = 60,000-180,000 ops/sec

PICO-8 can handle this, though on slower systems might drop below 60fps.

**Optimization notes:**
- Ellipse function is token-efficient but CPU-intensive
- Fixed-point math used (shr operations) for performance
- No collision detection or complex physics
- Memory operations are bounded and sparse

### Loop Structure Impact

The `goto` loop structure means:
- **No frame skip handling** - if system lags, timing drifts
- **No CPU yield** - PICO-8 VM handles this internally but cart never explicitly yields
- **Deterministic timing** based on `t()` function which continues regardless
- **No garbage collection opportunities** - though PICO-8 handles this automatically

## Connection to The Trace Gallery

**CRITICAL:** Vestige 005 came FIRST and was the **direct inspiration** for The Trace Gallery's entire lore and world-building.

**User ID 127402 / objkt/127402**

This piece established:
- The concept of dangerous remnants that cannot be contained
- User ID 127402, codename "hierophant"
- The warning message structure and repetition
- The idea that interaction increases danger
- Containment breach as the central threat

The Trace Gallery expanded these concepts into a full interactive narrative experience with inventory, achievements, doom timer, and multiple endings.

**The Real "Bad Ending":**
When I first analyzed this, I got it backwards. The piece successfully implements **mechanical horror** through the inversion of expectations:

- **Crash = Success**: The piece freezing on a corrupted frame (screaming mouth) is GOOD. Containment worked.
- **Stability = Failure**: The piece running smoothly in perpetual cycles is BAD. Containment breach. Too late.
- **Interaction = Risk**: Every load, every click, gives the piece another chance to find equilibrium
- **The Warning is Literal**: "Stop doing this... every time you touch it, each click, you give it another chance to stabilize. Give up. Just let go."

**Why it's a "fave":**
The piece successfully implements **mechanical horror** where the code and fiction are perfectly aligned:
- The overflow bug becomes the containment mechanism
- Smooth operation is the actual threat
- Viewer interaction is the danger vector
- What SHOULD work (stable execution) is what you DON'T want
- A piece that's more dangerous when it works than when it breaks

It's a piece that **does what it's about** - a vestige that might persist, that you're giving chances to stabilize, that you should stop interacting with but can't help yourself.

## Code Quality Notes

**Strengths:**
- Clean, readable structure
- Efficient use of PICO-8 features
- Custom ellipse implementation shows technical depth
- Modular dither system allows experimentation
- Elegant symmetry in orbital patterns

**Interesting choices:**
- Noise effectively disabled (amt=0.5)
- Many dither modes commented out
- Glitch function defined but unused
- Loops using negative ranges (`for i=-15,1`)

**Potential modifications:**
- Increase noise amount to activate texture
- Enable other dither modes
- Add glitch calls for more corruption
- Make entropy locking probabilistic: `if(rnd()>0.7 and seed_reset_needed)srand(seed)`

## Summary

Vestige 005 is a generative art piece that weaponizes an overflow bug as narrative device. The piece runs in an infinite loop, and there are two possible outcomes:

**Crash (Good):** The piece triggers an overflow bug and freezes on a corrupted frame resembling a screaming mouth. Containment success. Safe.

**Stability (Bad):** The piece finds equilibrium and runs smoothly in perpetual 10-second cycles with 5-second deterministic entropy resets. Containment breach. Too late.

The visual system combines orbital sine/cosine patterns, ellipse forms, burn-based color inversion, and memory manipulation to create organic, breathing imagery that cycles between order (seed reset) and chaos (accumulated randomness).

**This piece came FIRST** and directly inspired The Trace Gallery's lore. It established User ID 127402 ("hierophant"), the concept of dangerous remnants that cannot be contained, and the warning structure about interaction increasing danger.

It's a piece that successfully merges technical bug with conceptual meaning - where smooth operation is the threat, crashes are containment, and viewer interaction is the danger vector. The fiction and code are perfectly aligned: every time you load it, you're giving it another chance to stabilize. You should stop. Let it stay dead.

But you won't. And that's the horror.
