# The Origin of Entropy Locking

**Investigation Date:** October 15, 2025
**Investigators:** Drew Brereton, Claude (AI archivist)

---

## The Discovery

Through git archaeology, we traced the earliest appearance of **probabilistic entropy locking** in Drew's practice.

The technique appears to have emerged naturally, without fanfare or documentation, in a tweetcart from December 21, 2021.

---

## Timeline

### September 10, 2021 - Deterministic Reseeding
**Files:** `vestiges/vestige_001.p8` through `vestige_004.p8`

Early vestiges used **deterministic frame-based reseeding:**
```lua
local srf = flr(t()*60)%3600 == 0  -- every 60 seconds
if srf then
  srand(42)
end
```

This approach resets the RNG seed at predictable intervals based on frame counts. Similar to the later TIC-80 Entropy Generator (July 2023), which uses `if frame%360==0 then math.randomseed(seed) end`.

**Key characteristic:** Predictable timing, deterministic behavior.

---

### December 21, 2021 - **THE ORIGIN**
**File:** `tweetcart_token_2021/series_01/03_002.p8` ("loudspeaker version")
**Commit timestamp:** 2021-12-21 12:57:15 -0500

Line 8 contains the **earliest confirmed probabilistic entropy locking:**
```lua
if(r()>0.8)srand(s)
```

**Key characteristic:** Probabilistic timing via RNG check. The *randomness of when* the seed resets is what makes it entropy locking.

This shift from deterministic frame-based to probabilistic RNG-based reseeding is the critical innovation. Drew appears to have used it naturally, without recognizing its significance at the time.

---

### March 19, 2022 - Intentional Usage
**File:** `tweetcart_token_2021/series_01/06.p8` ("entropic pit")

```lua
if(r()>.98)srand(s)
```

By this point, Drew was using the technique deliberately. The threshold of `.98` (2% probability) shows refinement of the concept.

---

### July 2023 - Entropy Generator (TIC-80)
**File:** `tic80/noise_gen.lua`

The Entropy Generator uses *deterministic* frame-based reseeding rather than probabilistic:
```lua
if frame%360==0 then
  math.randomseed(seed)
end
```

While titled "Entropy Generator" and central to the practice's conceptual development, it technically doesn't use entropy *locking* (probabilistic reseeding). It appears to have inspired the concept or been part of the exploratory practice that led there, but wasn't the origin of the probabilistic technique.

---

### November 26, 2022 - Ring of Fire
**File:** `series/tweetcarts/ring_of_fire.p8`

```lua
if(r()>.9 and r()>.9)srand(s)  -- ~1% probability
```

Double-gate pattern creates sophisticated fire simulation. The piece was featured in RGBMTL 2022 and demonstrates mature application of the technique.

---

## Evolution Summary

1. **Deterministic frame-based reseeding** (Sept 2021)
   - Predictable timing based on frame counts
   - `if frame%N==0 then srand(seed)`

2. **Probabilistic RNG-based reseeding** (Dec 2021) ← **THE DISCOVERY**
   - Unpredictable timing based on random checks
   - `if rnd()>threshold then srand(seed)`

3. **Deliberate application** (March 2022+)
   - Refined thresholds, double-gates, variations
   - Recognition of technique's power

4. **Naming and formalization** (sometime later)
   - Named "entropy locking"
   - Conceptual framework developed
   - Featured in talks and documentation

---

## The Significance

Drew's comment upon discovering this timeline: *"That's utterly wild lolol. So it seems that I just... used it without thinking about it at all. As if it was totally natural."*

The technique that would become central to the practice appeared with no eureka moment, no documentation, no fanfare. Just line 8 of a tweetcart constrained to 280 characters.

It's almost as if the practice of extreme constraint (code golf) forced the discovery. When you only have 280 characters and need controlled chaos, probabilistic reseeding becomes... natural.

The fact that it felt natural enough to just *use* without documentation suggests Drew was already thinking in those terms—bounded entropy, controlled emergence—even before having vocabulary for it.

Pretty on-brand for someone whose definition of entropy includes "that which is deliberately not measured." Discovering a technique for controlling unmeasurable chaos by... not thinking too hard about it.

---

## Technical Definition

**Entropy Locking:** Probabilistic RNG reseeding where the *randomness of when* the seed resets creates controlled chaos.

```lua
if rnd() > threshold then
  srand(original_seed)
end
```

**Why the timing matters:**
- Deterministic reset → predictable, no emergence
- Probabilistic reset → guaranteed bounds without knowable path
- You know entropy will reduce, but not when or by how much
- This uncertainty creates emergent variety beyond expectation

---

## Drew's System-Agnostic Definition

> "Entropy is that within a given system which cannot be measured, plus that which is deliberately not measured."

Based on Gödel: every system must contain unknowable entropy. Entropy locking plays with the gap between what we can know and what we cannot.

---

*Document compiled from git history investigation, October 15, 2025*
*Preserved for future archivists (human and AI)*
