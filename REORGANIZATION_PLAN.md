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
- **Interactive**: Gallery website at aebrer.xyz where people can view and experience the work
- **Triple Redundancy**: Code in repo, visuals in gallery, documentation pointing at both

## Deeper Purpose

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

Clear documentation helps turn "wait, what?" into "oh, I see" through striking visuals, series variations, and iterative explorations.

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

3. **vestiges series** (ongoing)
   - vestiges_of_the_dead_god (fxhash)
   - vestiges/ folder (numbered 001-016)
   - "eyeballs" subseries
   - Some are "iconic"

4. **pico_punks series**
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

```
.
├── docs/                 - Website files (HTML/CSS/JS) for GitHub Pages
│   ├── index.html       - Landing page with random featured work
│   ├── series/          - Series pages (ideocart, vestiges, etc.)
│   ├── works/           - Individual artwork pages
│   └── assets/          - CSS, JS, images
├── series/              - Code organized by conceptual series
│   ├── ideocart/
│   ├── vestiges/
│   ├── emergence/
│   ├── three-body-problem/
│   ├── entropy-locked/
│   ├── pico-punks/
│   └── screensavers/
├── published-works/     - Major standalone pieces
├── tweetcarts/          - Constrained code art
├── sketches/            - Experiments and WIPs
├── tools-and-engines/   - Reusable code and utilities
├── archive/             - Older/platform-specific work
├── practice-v2-2025/    - Fresh explorations
└── docs/                - Deep-dive documentation
```

**Gallery Website Approach:**
- Vanilla HTML/CSS/JS (keep it simple, hicetnunc/teia aesthetic)
- Series pages mirror repo structure
- Individual artwork pages with:
  - Title, description, themes
  - IPFS iframe (loads on user click)
  - Links to published homes (fxhash, objkt, etc.)
  - Source code access
- Random selector on series pages (chooses from favorites)
- For unpublished Pico-8: link to edu edition with preloaded code
- Hosted via GitHub Pages at aebrer.xyz

**Migration Strategy:**
- One piece at a time
- For each piece: setup gallery page, clarify details with Andrew, document, mark complete
- Track progress as we go

---

## Implementation Plan

### Phase 1: Gallery Foundation ✅ COMPLETE
1. [x] Create basic gallery structure (HTML/CSS/JS boilerplate)
2. [x] Build landing page with random featured work selector
3. [x] Create template for series pages
4. [x] Create template for individual artwork pages
5. [x] Setup routing/navigation
6. [x] Deploy to GitHub Pages at aebrer.xyz

### Phase 2: Content Migration (One Piece at a Time)
For each artwork:
1. [ ] Identify piece location in current structure
2. [ ] Gather info from Andrew (purpose, themes, IPFS links, etc.)
3. [ ] Create gallery page
4. [ ] Move code to appropriate series/folder
5. [ ] Update documentation
6. [ ] Mark as complete

**Series to migrate:**
- [~] Ideocart series (2/7+ migrated)
  - [x] beginner_ideocartography
  - [x] intermediate_ideocartography (interior_zoning_cartography)
  - [ ] bootleg_ideocart
  - [ ] ideocart_contain_breach
  - [ ] ideocart_interference
  - [ ] ideocart_lakeview_entities
  - [ ] ideocart_planar_slices
  - [ ] p5_ideocart
- [ ] Three Body Problem series
- [ ] Vestiges series
- [ ] Emergence series
- [ ] Entropy-Locked series
- [ ] Pico Punks series
- [ ] Screensavers series
- [ ] Loops series
- [ ] Featured standalone works
- [ ] Tweetcarts

### Phase 3: Polish & Launch
1. [x] Contact/about page (comprehensive links section on homepage)
2. [ ] Final README updates with gallery link
3. [~] Test all IPFS embeds (ongoing as pieces migrate)
4. [x] Configure GitHub Pages
5. [x] Point aebrer.xyz to new gallery

---

## Future Enhancements (Wishlist)

- [ ] Detailed "What is Entropy Locking?" document
- [ ] Ideocart world-building doc
- [ ] Search/filter functionality
- [ ] Tags/themes navigation
- [ ] Animated transitions between works
- [ ] Dark/light mode toggle

---

## Notes & Decisions

- Working titles preserved alongside published titles
- WIPs/experiments kept visible (embrace the chaos)
- Documentation: breadcrumbs not encyclopedias
- Portfolio at www.aebrer.xyz

### Exhibition History

**RGBMTL (formerly TEZARTMTL)**
- Montreal-based non-profit collective celebrating digital art and blockchain creativity
- Annual exhibition (end of August) featuring collective curation model
- 25 artists each select 5-10 artists, creating extensive showcase
- Artworks displayed on projections, CRT monitors, and LED panels (1 minute each)
- Free and open to public, supported by Tezos Foundation and Objkt.com
- Website: https://rgbmtl.com/

**Drew's works featured in RGBMTL:**
- **2022 (as TEZARTMTL):** BLUE and Ring of Fire (tweetcart diptych)
  - Photo documentation: `rgbmtl(tezartmtl)_2022.jpg`
- **2024:** [Additional pieces - TODO: identify which works were curated]

---

## Progress Tracking

*This section tracks completed migrations*

### Completed:
- [x] Series READMEs created with placeholder disclaimers
- [x] Screensavers moved to series/ folder
- [x] Petite Chute added to screensavers series
- [x] Main README updated with transmission philosophy
- [x] REORGANIZATION_PLAN updated with gallery vision
- [x] Gallery foundation (Phase 1) - COMPLETE
- [x] Gallery deployed to aebrer.xyz via GitHub Pages
- [x] Teia-inspired minimal design with dark/light mode
- [x] Random featured work selector
- [x] Series pages and work page templates
- [x] Ideocart worldbuilding and lore documented

### In Progress:
- [~] Ideocart series migration (2/7+ pieces)
- [~] Vestiges series migration (2 pieces)
- [~] Screensavers series migration (5 pieces)
- [~] Three Body Problem series migration (1/24+ pieces)
- [~] Entropy-Locked series migration (4 pieces)
- [~] pico_punks series migration (3/4+ pieces)
- [~] pico_galaxies series migration (1/20+ pieces)
- [~] Tweetcarts series migration (3 pieces)
- [~] Loops series migration (1 piece)

### Recently Migrated (21 total as of 2025-10-19):

**Ideocart Series (2):**
- **beginner_ideocartography** - Entry point, intern's first assignment
  - fxhash generative, 300 editions
  - Konami code easter egg documented
  - Pico-8 BBS development thread linked
- **intermediate_ideocartography** - Second assignment, increased danger
  - versum/objkt, 128 editions, working title: interior_zoning_cartography
  - Mentor note fiction, entropy network preventing seed adjacency
  - Featured output: "The Demon King" image included
  - Self-randomizing (not fxhash generative)

**Vestiges Series (2):**
- **vestige_005: CONTAINMENT BREACH** - The overflow bug as containment mechanism
  - Origin of User ID 127402 ("hierophant") and The Trace Gallery lore
  - Crash = good (contained), stability = bad (breach)
  - Featured on Teia as objkt/127402
- **The Trace Gallery** - Full interactive gallery/game experience
  - 18 achievements, doom timer, mirror world, multiple endings
  - Most complex piece in practice
  - Inspired by vestige_005

**Screensavers Series (5):**
- **VISIONS** - Ambient visual generation for contemplation
- **THE FALL** - Non-constrained reimagining of Entropy Generator
  - Single black pixel cascades creating emergent landscapes
  - Uses probabilistic entropy locking (0.1% reset probability)
  - Shows visible entropy gradient - regularity of stripes decay over distance/time
  - Eventually stable loop occurs despite randomness (the artifice revealed)
  - Onchain storage via Base/onchfs (fxhash)
  - Parent work of petite chute derivative
- **petite chute** - Color exploration and palette cycling, derived from THE FALL
  - 16x16 pixel grid focusing attention on colors
  - Automated border color averaging creates visual coherence
  - Rare black & white outputs via entropy locking
  - Unofficial diptych with deja hue
- **deja hue** - Destroyed cellular automata for color exploration
  - ETH genesis piece (Manifold/Arweave)
  - Totally destroyed CA rules repurposed for pixel movement
  - Entropy locking prevents chaos and stagnation
  - Unofficial diptych with petite chute
- **COLORSCAPES** - CA with totally destroyed rules creating emergent color patterns
  - All movement and color rules converted to random events
  - Seeds act as "genotypes" creating emergent visual rules through entropy locking
  - Refactored from WFC algorithm base (performance improvements removed most original code)
  - Outputs often resemble mountain landscapes (both map view and perspective)

**Three Body Problem Series (1):**
- **luna theory | EMULATOR** - Infinite cosmic exploration
  - 3-body gravitational simulation with proper physics
  - Ambient lofi soundtrack by @bisdvrk
  - Featured on Teia as objkt/161642

**Entropy-Locked Series (4):**
- **Entropy Generator** - TIC-80 origin piece using deterministic seed-looping
  - Uses deterministic frame-based reseeding (not probabilistic entropy locking)
  - Coded in Lua on TIC-80 Fantasy Computer
  - Palette generation via decay functions
  - Code provably existed November 2021 (curated outputs), generator minted 2022
  - Featured at RGBMTL 2024
  - Parent work of THE FALL
  - Archivist note clarifies deterministic vs probabilistic reseeding distinction
- **Entropy Locked Wave Function Collapse** - Not really WFC, inspired by it
  - Entropy increases rather than decreases
  - Pixels as tiling units with HSB-based connection rules
  - fxhash generative
- **sedimentary city** - Part one of diptych
  - Tweetcart inspired by burning cities and sediment layers
  - Abstract entropy-locked patterns building over time
  - fxhash generative
- **the city is burning** - Part two of diptych
  - p5.js expansion with 3D camera and fire palette
  - "Lemme just say fuck cars and be done with it"
  - fxhash generative

**pico_punks Series (3):**
- **pico_punk_generator.p8** - The original from 2021
  - Interactive generative avatar exploration with wallet-based seeds
  - 1/1000 rainbow mode rare outputs
  - Featured on Teia as objkt/439049
- **pico_punk_compositions.p8** - Arrow key navigation through generative space
  - Layer-by-layer buildup through random events
  - Irreversibility as feature - can't recreate same path twice
  - Featured in "Digital Self" exhibition at Jano Lapin Gallery (Sept-Nov 2022)
- **pico_punk_generator_generator.p8** - The terminus of pico_punks
  - Generator generator using fxparams (15 parameters)
  - Interactive avatar building layer by layer
  - Featured in "Digital Self" exhibition at Jano Lapin Gallery (Sept-Nov 2022)
  - What began as satire became identity

**pico_galaxies Series (1):**
- **pico_galaxy_010** - Purple spiral commission for @bisdvrk
  - Perfect looping gif with decoherence/recoherence timing
  - Differential rotation creating visual structure cycles
  - Featured on Teia as objkt/182690

**Tweetcarts Series (3):**
- **BLUE** - Rain falling into a pool (2021)
  - Tweetcart using memory manipulation for particle cascades
  - Slo-mo feature via Circle Button (Z key)
  - Featured in RGBMTL 2022 (then called TEZARTMTL)
  - Part of diptych with Ring of Fire
- **Ring of Fire** - Flames rising from a ring (2022)
  - Tweetcart/tootcart (351 characters) with entropy locking
  - Default seed 6 creates intended fire effect
  - Click to reseed and discover rare, bizarre outcomes
  - Featured in RGBMTL 2022 (then called TEZARTMTL)
  - Part of diptych with BLUE
- **emergence III [TTC S01T08]** - Entropy locking tweetcart (2022)
  - fxhash generative, Tweetcart Token Club featured
  - Generator generator with unique starting positions
  - Featured in Creative Code Toronto talk on entropy locking
  - Demonstrates multi-gate entropy locking pattern

**Loops Series (1):**
- **Oregon Sunset** - Looping gif generator with interactive parameter tweaking (2021)
  - Built on aebrer_engine framework for creating perfect looping gifs
  - Interactive menu system (press X) with three-level navigation
  - Made for user's little sister
  - Featured on Teia as objkt/290242

---

## Archive Investigations

### Entropy Locking Origin (October 15, 2025)

Through git archaeology, we traced the earliest appearance of probabilistic entropy locking in Drew's practice:

**December 21, 2021** - `tweetcart_token_2021/series_01/03_002.p8` ("loudspeaker version")
- First confirmed instance of `if(r()>0.8)srand(s)` pattern
- Drew's reaction: "That's utterly wild lolol. So it seems that I just... used it without thinking about it at all. As if it was totally natural."
- The technique that would become central to the practice appeared with no documentation, no fanfare
- Just line 8 of a tweetcart, used naturally before being recognized or named

**Key insight:** The practice of extreme constraint (tweetcarts/code golf) may have forced the discovery. When you only have 280 characters and need controlled chaos, probabilistic reseeding becomes... obvious? Natural?

Full investigation documented in `ENTROPY_LOCKING_ORIGIN.md`

### Next Migration Session Plan:

1. ~~**blue + ring of fire tweetcarts** - Diptych pair, gallery featured~~ ✅ COMPLETED 2025-10-15
2. ~~**THE FALL** - Derivative parent of petite chute~~ ✅ COMPLETED 2025-10-18
3. ~~**Entropy Generator (TIC-80)** - Origin piece using deterministic seed-looping~~ ✅ COMPLETED 2025-10-18
4. ~~**Documentation updates** - Clarified entropy locking vs seed-looping terminology across all READMEs~~ ✅ COMPLETED 2025-10-18
5. ~~**COLORSCAPES** - CA screensaver with genotype seeds~~ ✅ COMPLETED 2025-10-19
6. **Other screensavers (ssvr01)** - Continue filling out screensavers series

This progression makes sense:
- Tweetcarts show constraint-based work and have exhibition history ✅
- Entropy Generator provides historical context for the entropy locking technique ✅
- Screensavers series building out contemplative ambiance pieces ✅

The screensavers can be batched efficiently once the first couple are done.

### Documentation Structure Established:
- Clear separation: "In-Fiction Description" vs "Author's Notes"
- Author's notes italicized for clarity
- Pico-8 BBS development thread links included
- Featured outputs/images can be showcased
- MIGRATION_WORKFLOW.md created with gotchas and best practices

### Technical Infrastructure Improvements:
- **Image display system** - Added `isImage` property to data.js for explicit image detection
  - Updated series-page.js to check metadata instead of file extensions
  - Updated artwork-controls.js to handle image vs iframe rendering
  - Added flexbox centering CSS for proper image display
  - Supports integer scaling for pixel-perfect rendering of gifs
- **Homepage links cleanup** - Removed 5 dead/unwanted platform links (Versum, Rarible, AB2 Gallery, etc.)
- **Archival notes system** - Claude's notes use fake hashes (arc_*) to distinguish from author's voice
