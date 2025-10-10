# Entropy-Locked Series

**Concept:** Pieces showcasing **entropy locking**—a technique where the RNG is periodically reseeded to its origin, creating controlled chaos.

## What is Entropy Locking?

Entropy locking is both a technical innovation and a conceptual exploration. The code periodically resets the random number generator back to its original seed during runtime:

```lua
-- Example pattern
if use_entropy_lock then
  if(rnd()>0.7)srand(seed)
end
```

This creates a dynamic balance:
- The system drifts toward chaos (entropy)
- But keeps getting "pulled back" to its origin
- Creating **structured decay** and **controlled chaos**

It's not pure randomness, and it's not pure determinism. It's entropy with resistance.

## Origin Piece

**Entropy Generator** (`tic80/noise_gen.lua`) ⭐

The foundational piece that established the entropy locking technique. A TIC-80 experiment that became the basis for many subsequent cascade-based works. More colorful evolutions followed.

## Major Works in This Series

### Published
- **Entropy Generator** (TIC-80) ⭐ - The origin
- **The Fall** (p5.js, fxhash) ⭐ - JS version with expanded color palette
- **Petite Chute** (p5.js) ⭐ - Refined entropy cascade
- **Entropy Locked Wave Function Collapse** (fxhash) ⭐ - Combining entropy lock with WFC algorithms
- **Entropy Locked Recursive Glitch Textures** (fxhash) - Recursive texture generation with controlled decay

### Unpublished
- **entropy_locked_starburst** - Radiating patterns with entropy lock

## The Concept

This technique embodies a philosophy about entropy itself: it's not pure disorder or heat death. Entropy is a tendency toward equilibrium with structure, rhythm, and moments of resistance.

These pieces try to help people think about entropy in a way closer to what it really is.

## Technical Variations

Different pieces implement entropy locking differently:
- **Probability-based**: Reset seed with X% chance per frame
- **Time-based**: Reset every N frames
- **Event-based**: Reset on user interaction or state change
- **Conditional**: Reset when certain visual conditions are met

The specific implementation changes the character of the decay.

## Common Features

- Cascade effects (changes propagating through the system)
- Burn/fade mechanics
- Color degradation
- Dithering and noise
- Visual "drift" and "snap-back"
- Balance between chaos and order

---

*Entropy locking appears throughout the body of work, but these pieces make it central to their concept and execution.*
