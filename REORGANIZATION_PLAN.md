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

```
.
├── gallery/              - Website files (HTML/CSS/JS)
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

### Phase 1: Gallery Foundation
1. [ ] Create basic gallery structure (HTML/CSS/JS boilerplate)
2. [ ] Build landing page with random featured work selector
3. [ ] Create template for series pages
4. [ ] Create template for individual artwork pages
5. [ ] Setup routing/navigation

### Phase 2: Content Migration (One Piece at a Time)
For each artwork:
1. [ ] Identify piece location in current structure
2. [ ] Gather info from Andrew (purpose, themes, IPFS links, etc.)
3. [ ] Create gallery page
4. [ ] Move code to appropriate series/folder
5. [ ] Update documentation
6. [ ] Mark as complete

**Series to migrate:**
- [ ] Ideocart series
- [ ] Three Body Problem series
- [ ] Vestiges series
- [ ] Emergence series
- [ ] Entropy-Locked series
- [ ] Pico Punks series
- [ ] Screensavers series
- [ ] Featured standalone works
- [ ] Tweetcarts

### Phase 3: Polish & Launch
1. [ ] Contact/about page
2. [ ] Final README updates with gallery link
3. [ ] Test all IPFS embeds
4. [ ] Configure GitHub Pages
5. [ ] Point aebrer.xyz to new gallery

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

---

## Progress Tracking

*This section tracks completed migrations*

### Completed:
- [x] Series READMEs created with placeholder disclaimers
- [x] Screensavers moved to series/ folder
- [x] Petite Chute added to screensavers series
- [x] Main README updated with transmission philosophy
- [x] REORGANIZATION_PLAN updated with gallery vision

### In Progress:
- [ ] Gallery foundation (Phase 1)

### Pending Migration:
*(Will be populated as we work through each piece)*
