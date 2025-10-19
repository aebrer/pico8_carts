# Andrew Brereton - Generative Art Archive

A collection of generative art exploring **entropy, emergence, and pareidolia** through constrained platforms.

**Portfolio:** [entropist.ca](https://entropist.ca)
**Platforms:** Pico-8, p5.js, TIC-80
**Published on:** fxhash, hicetnunc/objkt, versum

---

## Core Concepts

### Entropy Locking

**Entropy locking** is a technique where the random number generator is *probabilistically* reseeded back to its original seed during runtime. The key insight: the *timing* of the reset is itself random.

```lua
-- Example from entropy_locked_starburst.p8
if use_entropy_lock then
  if(rnd()>0.7)srand(seed)  -- probabilistic reset!
end
```

**Why the randomness matters:**

In a deterministic reset (e.g., "reset every 60 frames"), you know exactly when and how entropy reduces. But with probabilistic reset, you have **guaranteed bounds without knowable path**:

- You *know* entropy will be reduced (the seed will reset)
- You *cannot know* when it will happen
- You *cannot know* how much entropy accumulated before the reset
- This uncertainty creates emergent variety beyond what you'd expect

**Entropy Defined (System-Agnostic):**

"Entropy is that within a given system which cannot be measured, plus that which is deliberately not measured."

Whether Boltzmann, Shannon, or thermodynamic—entropy is always about the gap between the system and our knowledge of it. Entropy locking *plays* with that gap: it guarantees entropy reduction but keeps the specifics unknowable, creating emergence from uncertainty.

Based on Gödel's work, we know every system must contain some unknowable entropy unless viewed from outside with total knowledge and sufficient energy. Entropy locking embraces this: drift, snap-back, but the path between is unmeasurable.

