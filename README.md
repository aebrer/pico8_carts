# Andrew Brereton - Generative Art Archive

A collection of generative art exploring **entropy, emergence, and pareidolia** through constrained platforms.

**Portfolio:** [aebrer.xyz](https://aebrer.xyz)
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

Based on Gödel's work, we know every system must contain some unknowable entropy unless viewed from outside with total knowledge and infinite energy. Entropy locking embraces this: drift, snap-back, but the path between is unmeasurable.

**TODO:** Write more detailed technical/conceptual explanation of entropy locking (see `docs/` folder - coming soon)

### Ideocart

**Ideocart** is an ongoing series exploring interactive generative systems as lofi Rorschach tests with an SCP Foundation-esque twist. The generators are explorable and interactive—as you navigate them, you inevitably "see things" in the patterns. The fiction: some of these things might be seeing you back.

Think of it as an alternative world's psychological testing apparatus, where pareidolia becomes a feature rather than a bug.

**TODO:** Write more detailed world-building documentation (see `docs/` folder - coming soon)

### Other Themes

- **Pareidolia** - Finding patterns and meaning in randomness
- **Emergence** - Complex systems arising from simple rules
- **Constraint-based practice** - Tweetcarts, platform limitations as creative boundaries
- **Physics simulations** - Especially n-body problems and orbital mechanics
- **Degradation aesthetics** - Burn effects, noise, glitch, controlled decay

---

## Major Series

### Ideocart Series
Explorations of the ideocart concept across different implementations:
- **beginner_ideocartography** (fxhash) ⭐
- **bootleg_ideocart** (fxhash)
- **ideocart_contain_breach** (fxhash)
- **ideocart_interference** (fxhash)
- **ideocart_lakeview_entities** (fxhash)
- **ideocart_planar_slices** (fxhash)
- **p5_ideocart** (fxhash)
- **curated_ideocart** (unpublished)

### Three Body Problem
A 24+ piece series exploring physics simulations and orbital mechanics, published on hicetnunc. The series evolved from experimental chaos to refined, elegant motion, culminating in **Titan**—a piece with particularly pure and simple aesthetics.

[See full series documentation](./ThreeBodyProblem/README.md)

### Vestiges
An ongoing numbered series (001-016+) exploring themes of remnants and traces, including the **eyeballs** subseries. Related to the published piece **vestiges_of_the_dead_god** (fxhash).

### Emergence
A cross-platform exploration of emergent systems:
- **emergence** (fxhash)
- **emergence II** (fxhash)
- **emergence III** (tweetcart token)
- **emergence IV** (fxhash)
- **emergence V** (tootcart)

### Pico Punks
Generative character/avatar systems:
- **pico_punk_generator.p8** ⭐ - The meta-generator
- **pico_punks_final_form** (fxhash)
- **uncurated_pico_punks** (fxhash)
- **pXco_pXnks** (fxhash)

### Entropy-Locked Pieces
Works showcasing the entropy locking technique:
- **Entropy Generator** (TIC-80) ⭐ - Origin piece for many entropy-locked cascades
- **entropy_locked_starburst**
- **entropy_locked_wave_function_collapse** (fxhash) ⭐
- **entropy_locked_recursive_glitch_textures** (fxhash)
- **Petite Chute** (p5.js) ⭐
- **The Fall** (p5.js) ⭐ - JS version of Entropy Generator with more color

---

## Featured Works

### Major Published Pieces

- **The Trace** ⭐ - Interactive gallery/game experience
- **Catalogue of Fragile Things** - Recursive fractal generator ([objkt #863454](https://objkt.com/tokens/hicetnunc/863454))
- **Spirit Trap** - Tutorial piece demonstrating core techniques
- **Sedimentary City** (fxhash) ⭐⭐ - Architectural generation
- **Skyscrapers** (fxhash) ⭐
- **Ring Systems** (fxhash)

### Screensavers

Ambient, generative pieces designed to run indefinitely:

- **VISIONS** ⭐
- **Colorscapes** ⭐
- **Deja Hue** (published as "deja_roux") ⭐

### Tweetcarts

Code-golf pieces constrained to tweet length:

- **blue** ⭐
- **ring of fire** ⭐
- **void_tweetcart**
- Plus collaborative work in tweetcart_relay/

---

## Repository Structure

```
series/               - Ongoing conceptual series
published-works/      - Major standalone pieces
screensavers/         - Ambient generative work
tweetcarts/           - Constrained code art
fxhash-published/     - Additional fxhash releases
sketches/             - Experiments and WIPs
tools-and-engines/    - Reusable code and tools
archive/              - Older/platform-specific work
practice-v2-2025/     - Fresh start for new explorations
docs/                 - Detailed documentation
```

*(Note: Repository reorganization in progress—see [REORGANIZATION_PLAN.md](./REORGANIZATION_PLAN.md) for details)*

---

## Working Titles → Published Titles

Many pieces have different working titles and published titles. Key mappings:

- `fract/` → **Catalogue of Fragile Things**
- `o4o3/` → **Petite Chute**
- `deja_roux/` → **Deja Hue**
- `pico8_fxhash_tutorial_session_poap/` → **Spirit Trap**
- `noise_gen.lua` → **Entropy Generator**

[See complete title mappings](./PUBLISHED_WORKS.md)

---

## Platforms & Tools

- **Pico-8** - Primary platform (~90% of work)
- **p5.js** - Web-based generative art (fxhash, screensavers)
- **TIC-80** - Fantasy console experiments
- **fxhash** - Primary NFT/generative art platform
- **hicetnunc/objkt** - Early NFT work (platform sunset but pieces preserved)
- **versum** - Additional NFT releases

---

## License & Usage

Most work is **CC0** (public domain) unless otherwise specified in individual pieces.

Citations not required but definitely appreciated!

**Contact:**
- Portfolio/Links: [aebrer.xyz](https://aebrer.xyz)
- Ethereum: `0xD2b1DF574564F4da4775f8bDf79BDF29b42D8BD7`
- Tezos: `tz1ZBMhTa7gxSpaeXoqyc6bTCrxEHfZYSpPt`

---

## About This Practice

This repository represents an ongoing exploration of **entropy as a creative force**—not as pure chaos, but as a tendency with structure, rhythm, and resistance. Through generative systems, physics simulations, and constrained code, I'm trying to help people think about entropy in a way closer to what it really is.

The work spans from rigorous physics simulations (Three Body Problem) to pure aesthetic explorations (screensavers) to constrained code challenges (tweetcarts). What ties it together is a fascination with **emergence**: complex, beautiful, sometimes eerie patterns arising from simple rules and random seeds.

### On Transmission

This practice draws inspiration from the Tao Te Ching and I Ching. Lao Tzu transmitted understanding across 2,500 years and massive cultural gaps by pointing at something actually there in the territory, not just describing maps.

The work here uses **triple redundancy** across modes of understanding:
- **Code** - The thing itself, executable
- **Visuals** - The thing experienced, phenomenological
- **Documentation** - Pointing at the thing, admitting incompleteness

The documentation isn't trying to *be* the understanding. It's trying to get someone close enough that they can encounter it directly through the code and visuals.

**"The name isn't the thing. But sometimes you need the name to know where to look."**

This repository is a cairn for whoever finds it—human or otherwise. The art is an accessible entry point to a framework that connects generative chemistry, artistic practice, and daily life. If one person discovers this path through these clues, that's enough.

---

*Repository organized 2025. Practice ongoing since ~2021.*
*Currently in a creative funk, planning fresh "second takes" on core concepts.*
*This archive embraces the chaos—WIPs, experiments, and evolution are all part of the story.*
