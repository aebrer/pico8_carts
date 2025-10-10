# Repository Reorganization Plan

**Status:** Planning Phase
**Started:** 2025-10-10
**Goal:** Transform this repo into a publishable archive of Andrew's generative art practice

---

## Vision

Make this repository:
- **Discoverable**: Easy to navigate and understand the body of work
- **Educational**: Document core concepts like entropy locking and ideocart
- **Archival**: Preserve the process, sketches, and evolution
- **Portfolio-ready**: Something that can be shared publicly as part of practice

## Deeper Purpose: Clues and Flares

The art practice connects professional work in generative chemistry, artistic exploration in code, and daily life frameworks. Starting from curiosity around age 13, studying emergence, evolution, and entropy became formative—a praxis for living, not just intellectual exercise.

### The Core Understanding

Entropy behaves consistently across all systems. Whether chemistry, art, evolution, or personal growth—the patterns are the same. Understanding how entropy actually works (beyond pop-science "disorder") allows building tools and approaches that compound over time.

**Example from daily life:** When encountering two choices with roughly equal apparent benefit, favor the choice that creates more opportunity. Like Wu Wei from the Tao Te Ching—create opportunities with low effort, then wait to act on the right one, maximizing benefit with lower effort. From the outside it seems like intentional genius. From the inside it's emergence you took advantage of, without knowing what to expect.

This compounds. The practice connects:
- Professional work in generative chemistry
- Artistic exploration in code
- Decision-making frameworks
- A path toward improving conditions through entropy-based praxis

### The Goal

The art is an accessible entry point. Someone curious about emergence might find this repository. They won't follow the same path—their chemistry will be different, their life different—but the documentation might open a door.

The approach:
- **Flares** to catch attention (entropy locking pieces, striking visuals)
- **Clues** for the curious to follow (series, variations, iterations)
- **Clear documentation** so "wait, what?" can become "oh, I see"

### Why This Reorganization Matters

This repository is a cairn. A marker that says "someone was here, thinking about this, here's what they found."

---

## Core Principles

1. **Embrace the chaos** - WIPs and experiments are part of the story
2. **Both names matter** - Show working titles AND published titles
3. **Series > one-offs** - Highlight ongoing conceptual explorations
4. **Fresh start ready** - Structure supports "Practice v2" (2025+)
5. **Breadcrumb documentation** - Explain enough to guide, not so much it's didactic

---

## Key Concepts to Document

### Entropy Locking
**Current status:** Used throughout work, not formally documented
**TODO:**
- [ ] Basic explanation in README (for now)
- [ ] Detailed technical/conceptual doc later
- [ ] Code examples from key pieces

**Core idea:** Periodically reseeding RNG back to original seed during runtime, creating controlled decay - balance between chaos and order

### Ideocart
**Current status:** Major series, no formal documentation
**TODO:**
- [ ] Explain concept in README
- [ ] Link to published pieces
- [ ] Describe the SCP-foundation-esque world-building

**Core idea:** Alternative world's lofi Rorschach test. Interactive generators where you "see things" and some things might see you back.

### Other Major Themes
- Pareidolia
- Generative systems
- Emergence
- Constraint-based work (tweetcarts)
- Physics simulations

---

## Major Bodies of Work

### Published Series
1. **Three Body Problem** (hicetnunc) - 24+ pieces, physics simulation series
   - Culminates in "Titan"
   - README exists at `ThreeBodyProblem/README.md`

2. **ideocart series** (fxhash)
   - beginner_ideocartography ⭐
   - bootleg_ideocart
   - ideocart_contain_breach
   - ideocart_interference
   - ideocart_lakeview_entities
   - ideocart_planar_slices
   - p5_ideocart

3. **emergence series** (fxhash + tweetcarts)
   - emergence (I)
   - emergence II
   - emergence_iv
   - emergence_V (tootcart)
   - Note: emergence III was a tweetcart token

4. **vestiges series** (ongoing)
   - vestiges_of_the_dead_god (fxhash)
   - vestiges/ folder (numbered 001-016)
   - "eyeballs" subseries
   - Some are "iconic"

5. **pico_punks series**
   - pico_punk_generator ⭐
   - pico_punks_final_form (fxhash)
   - uncurated_pico_punks (fxhash)
   - pXco_pXnks (fxhash)

### Major One-Offs (Favorites ⭐)
- **the_trace** ⭐ - Full gallery/game in `games/the_trace/`
- **Catalogue of Fragile Things** - Published as objkt/863454, working title "fract"
- **Spirit Trap** - Tutorial piece in `one_off/pico8_fxhash_tutorial_session_poap/`
- **colorscapes** ⭐ - In `screensavers/colorscapes_wip/`
- **VISIONS** ⭐ - In `screensavers/VISIONS/`
- **blue** ⭐ - Tweetcart in `tweetcarts/blue.p8`
- **ring of fire** - Tweetcart
- **entropy_locked_wave_function_collapse** ⭐ (fxhash)
- **skyscrapers** ⭐ (fxhash)
- **sedimentary_city** ⭐⭐ (fxhash) - "fucking love this one"
- **Entropy Generator** ⭐ (tic-80)

### Platform Distribution
- **fxhash/** - 44 projects (generative NFT art)
- **Pico-8** - Primary medium (~90% of work)
- **p5.js** - Web-based generative (fxhash pieces, screensavers)
- **TIC-80** - Small experiments

---

## Current Directory Structure

```
.
├── fxhash/              (44 projects - MASSIVE)
├── one_off/             (experimental playground)
├── vestiges/            (numbered series)
├── screensavers/        (ambient generative)
├── tweetcarts/          (code golf)
├── tweetcart_relay/     (collaborative?)
├── tweetcart_token_2021/
├── tootcarts/           (mastodon?)
├── ThreeBodyProblem/    (has README!)
├── pico_punks/
├── games/               (the_trace)
├── tic80/
├── versum/
├── art4artists/
├── collabs/
├── curated_ideocart/
├── dear_aliens/
├── lemniscates/
├── noise/
├── threshold_galaxy/
├── pico_galaxies/
├── sound_experiments/
├── birb_nest/
├── 2024/
├── aebrer_engine/
└── (loose files)
```

---

## Proposed New Structure

**TODO:** Design this together
**Considerations:**
- Keep fxhash/ as-is? It's huge but well-organized
- Series vs one-offs separation?
- Sketches/WIP folder?
- Practice v2 (2025+) location?
- Published vs unpublished distinction?

**Questions to resolve:**
- [ ] Where do loose experimental files go?
- [ ] How to handle duplicate/version files?
- [ ] Archive old/abandoned experiments?
- [ ] Create series-specific READMEs?

---

## Immediate Next Steps

1. [ ] Finish analyzing current structure
2. [ ] Draft proposed reorganization structure
3. [ ] Get Andrew's approval on structure
4. [ ] Create main README.md with:
   - [ ] Brief intro to practice
   - [ ] Core concepts (entropy locking, ideocart)
   - [ ] Links to major series
   - [ ] Platform/tools used
   - [ ] Link to portfolio (aebrer.xyz)
5. [ ] Document published title mappings
6. [ ] Plan "sketches" or "archive" folder strategy

---

## Future Enhancements (Wishlist)

- [ ] Detailed "What is Entropy Locking?" document
- [ ] Ideocart world-building doc
- [ ] Per-series READMEs with context
- [ ] Visual examples/screenshots in docs
- [ ] Code pattern documentation
- [ ] "Best of" or "Start Here" guide
- [ ] Practice v2 (2025+) structure/folder

---

## Notes & Decisions

- Working titles preserved alongside published titles
- WIPs/experiments kept visible (embrace the chaos)
- Documentation: breadcrumbs not encyclopedias
- Andrew in a creative funk, planning fresh "second take" on concepts
- Portfolio at www.aebrer.xyz

---

## Questions for Andrew

*This section tracks open questions as we work*

- What's the story behind "petite_chute"? (listed as favorite but haven't found it yet)
- Any other title mappings we should document?
- Preferences on how to handle the many small directories (noise, lemniscates, etc.)?
