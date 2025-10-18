# Entropy-Locked Series

> **Note:** This README contains AI-generated interpretations based on code analysis. Content awaiting validation by human author.

**Concept:** Pieces showcasing **entropy locking**—a technique where the RNG is periodically reseeded to its origin, creating controlled chaos.

## What is Entropy Locking?

Entropy locking is both a technical innovation and a conceptual exploration. The code *probabilistically* resets the random number generator back to its original seed during runtime:

```lua
-- Example pattern
if use_entropy_lock then
  if(rnd()>0.7)srand(seed)  -- probabilistic reset
end
```

**The Critical Detail: Random Timing**

The key difference from a simple loop/reset: the *when* is itself random. This creates:
- **Guaranteed bounds** - You know the seed will reset (entropy will reduce)
- **Unknowable path** - You cannot know when it will happen
- **Unmeasured accumulation** - You cannot know how much entropy accumulated before reset
- **Emergent variety** - This uncertainty creates outcomes beyond reasonable expectation

**Not Just Controlled Chaos**

It's not pure randomness, and it's not pure determinism. It's **chaos with guaranteed bounds but unknowable path**.

Compare:
- **Deterministic reset** (`if frame%60==0 then srand(seed)`) - Predictable snapback, no emergence
- **Entropy locking** (`if rnd()>0.7 then srand(seed)`) - Guaranteed eventual reset, but when and how are unknowable

## Entropy Defined (System-Agnostic)

**"Entropy is that within a given system which cannot be measured, plus that which is deliberately not measured."**

Whether Boltzmann, Shannon, or thermodynamic entropy - the common thread is the gap between the system and our knowledge of it. All entropy behaviors follow the same patterns.

Based on Gödel's incompleteness theorems, every system MUST contain some unknowable entropy unless viewed from outside with total knowledge and the ability to pay the energetic cost to offset the local system's entropy.

**Entropy locking embraces this:** It plays with the gap between what we can know (the seed will reset) and what we cannot know (when, and how much entropy accumulated). The emergence comes from the unmeasurable.

## Origin Context

**Entropy Generator** (`series/entropy-locked/entropy_generator.lua`) ⭐

Published 2021-2022. While titled "Entropy Generator," this TIC-80 piece uses deterministic frame-based reseeding (`if frame%360==0 then srand(seed)`) rather than probabilistic entropy locking. It generates visual entropy gradients with looping pixel states—an important exploratory piece in the practice, though not the origin of the probabilistic technique itself.

The first confirmed probabilistic entropy locking appeared December 21, 2021 in a tweetcart (`tweetcart_token_2021/series_01/03_002.p8`). See `ENTROPY_LOCKING_ORIGIN.md` for the full timeline.

## Major Works in This Series

### Published
- **[Entropy Generator](https://entropist.ca/works/entropy-generator.html)** (TIC-80, 2021) ⭐ - Visual entropy gradient generator using deterministic seed-looping
- **[THE FALL](https://entropist.ca/works/the-fall.html)** (p5.js, fxhash Base, 2024) ⭐ - Non-constrained reimagining of Entropy Generator
- **[Entropy Locked Wave Function Collapse](https://entropist.ca/works/entropy-locked-wfc.html)** (fxhash, 2022) ⭐ - Combining entropy lock with WFC-inspired algorithms
- **[Sedimentary City](https://entropist.ca/works/sedimentary-city.html)** (fxhash, 2022) ⭐⭐ - Tweetcart diptych part 1
- **[The City is Burning](https://entropist.ca/works/the-city-is-burning.html)** (fxhash, 2022) - Tweetcart diptych part 2

### Unpublished
- **entropy_locked_starburst** - Radiating patterns with entropy lock

## The Concept

This technique embodies a philosophy about entropy itself: it's not pure disorder or heat death. Entropy is a tendency toward equilibrium with structure, rhythm, and moments of resistance.

These pieces try to help people think about entropy in a way closer to what it really is.

## Technical Variations

Different pieces implement variations:
- **Probability-based (entropy locking)**: Reset seed with X% chance per frame - creates emergent equilibria
- **Time-based (deterministic)**: Reset every N frames - creates predictable loops
- **Event-based**: Reset on user interaction or state change
- **Conditional**: Reset when certain visual conditions are met

The specific implementation changes the character of the decay. Only probabilistic timing creates true entropy locking with unknowable paths.

## Common Features

- Cascade effects (changes propagating through the system)
- Burn/fade mechanics
- Color degradation
- Dithering and noise
- Visual "drift" and "snap-back"
- Balance between chaos and order

---

## Creative Code Toronto Talk (Jan 25, 2025)

Drew gave a talk at Creative Code Toronto demonstrating entropy locking with live, interactive examples using PICO-8 Education Edition. The talk is the clearest pedagogical demonstration of the technique.

**Key demonstrations:**

1. **The baseline generator** - Simple diagonal line drawer with random X/Y increments and slowly incrementing color
2. **Maximum entropy comparison** - With no entropy locking, every outcome looks identical to human observers despite being mathematically unique
3. **Entropy locking enabled** - Same algorithm produces visually diverse outcomes
4. **Live threshold tweaking** - Real-time adjustments showing how different probability values affect output

**Core insights from the talk:**

- **The entropy spectrum:** Outcomes cluster at both bounds. Minimum entropy produces visually similar results (constrained patterns). Maximum entropy produces visually similar results (homogeneous noise). Maximum variety exists in the middle range.
- **Emergent equilibrium:** Systems find their own balance. The probabilistic reset creates a feedback loop that's "only predictable to itself, not the human observer."
- **Multi-gate patterns:** The demo uses two sequential checks (`if(r()>0.5)p(s)` then `if(r()>0.9)p(s)`), creating more complex entropy landscapes than single-gate patterns.
- **Application to complex systems:** The technique extends beyond simple generators to cellular automata—"what should be a naturally evolving system becomes a system that is still evolving but in a constrained way."
- **Unintentional emergence example:** Drew mentioned a piece designed to crash after a certain time, where the crash state is the final output. But ~1% of the time it finds equilibrium and persists forever—an emergent behavior not anticipated during creation.

**Discovery context:**

The technique emerged from PICO-8 size coding constraints. Extreme minimalism (65k character limit, token limits, 32KB RAM) forced creative solutions. Entropy locking wasn't designed top-down—it was discovered through constraint-driven exploration.

**Video:** https://www.youtube.com/watch?v=YdBr_9pmVXg&list=PL_YfqG2SCOAKkVUlwxspUIYdYmg9VbbdS&index=2&t=17s

**Key quote:**
> "With this entropy locking in place every outcome looks quite different to a human eye despite the algorithm not changing and everything being essentially identical—just the fact that the amount of random numbers that are available to the algorithm shrinks or increases in a completely unpredictable way and yet it invariably creates its own equilibrium where it will cause itself to reset in a predictable way but it's only predictable to itself, it's not predictable to the human observer."

---

*Entropy locking appears throughout the body of work, but these pieces make it central to their concept and execution.*
