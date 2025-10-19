# Notes for Future Claude Instances

**Purpose:** Get up to speed faster on Drew's practice, communication preferences, and this repository's purpose.

---

## Communication Style Preferences

### Avoid Patterns of Speech that Actually Annoy Andrew (APSAAA)
- **Don't** use patterns like "it's not just X, it's REALLY AWESOME Y"
- **Don't** use phrases that touch uncomfortable AI-adjacent concepts ("make the signal clear", etc.)
- Keep language **grounded and concrete**
- When in doubt, be **direct and restrained** rather than effusive

### On Sycophancy
Drew will call out sycophancy directly. When asked for genuine thoughts:
- Give **actual criticism** alongside what works
- Prioritize **intellectual honesty** over validation
- **Objectivity** is more valuable than false agreement

---

## The Practice: What This Really Is

### Core Understanding
- Drew's professional work is in **generative chemistry**
- This art practice connects chemistry, code, and **daily life praxis**
- Started exploring these concepts around **age 13**
- Entropy, emergence, evolution form the **core of identity and worldview**

### The Actual Goal
**"Inspire one person to discover these ideas and explore them"**

---

## Key Concepts (Get These Right)

### Entropy Locking - The Critical Detail
The **randomness of WHEN** the seed resets, not just that it resets.

```lua
if(rnd()>0.7)srand(seed)  -- probabilistic timing is KEY
```

**Why it matters:**
- Deterministic reset → predictable, no emergence
- Probabilistic reset → **guaranteed bounds without knowable path**
- You know entropy will reduce, but not when or how much accumulated
- This uncertainty creates emergent variety beyond expectation

**Drew's entropy definition (system-agnostic):**
> "Entropy is that within a given system which cannot be measured, plus that which is deliberately not measured."

Based on Gödel: every system must contain unknowable entropy. Entropy locking plays with the gap between what we can know and what we cannot.

### Ideocart
**Not** just "generative art with SCP aesthetics"

It's: Interactive Rorschach tests where pareidolia is the feature. You see things. Some things might see you back. The fiction serves the concept of projection and perception.

[human author note: hey. lol. this is pretty funny but still oddly accurate so I'm leaving it]

### Emergence
Central theme across all work. Simple rules → complex behavior. This applies to:
- Art (code generating visuals)
- Chemistry (molecular self-assembly)
- Life (decision-making, opportunity creation)

**Example Drew gave:** Wu Wei approach—when two choices seem equal, favor the one that creates more opportunity. Create opportunities with low effort, wait to act on the right one. From outside: planned. From inside: emergence you took advantage of.

---

## Working Titles vs Published Titles

This matters because people need to **find the work**. Key mappings:
- `fract/` → "Catalogue of Fragile Things"
- `o4o3/` → "Petite Chute"
- `noise_gen.lua` → "Entropy Generator"
- `deja_roux/` → "Deja Hue"

The gallery at entropist.ca serves as the canonical reference for all published and migrated works.

---

## Git Workflow Preferences

- **Always work on a branch** for major changes
- Ask before committing if uncertain
- Keep commits **modular** and **well-described** [a hopeless task I suspect]
- Pre-commit hooks validate gallery consistency and regenerate sitemap automatically

## Gallery Migration Workflow

- **Single source of truth**: `docs/assets/js/data.js` drives all gallery content
- **No series READMEs**: Gallery series pages serve this purpose (removed duplicate READMEs)
- **Follow MIGRATION_WORKFLOW.md**: Step-by-step process for migrating pieces
- **Validation**: Pre-commit hook ensures data.js and HTML files stay in sync
- **Sitemap**: Auto-generated on each commit with all gallery URLs
- Gallery lives at **entropist.ca** (deployed via GitHub Pages)

---

## Current Status (as of 2025-10-19)

- Gallery migration ongoing: **23 pieces** across **9 series** migrated so far
- Gallery live at **entropist.ca** with dark/light mode, random featured work selector
- This reorganization is about making the practice **legible as pedagogy**
- Planning "second takes" on core concepts (Practice v2)
- Time constraints rather than creative block—the ideas are there

---

## What Drew Loves

From favorites list (in no particular order):
- beginner_ideocartography
- the_trace
- petite_chute
- colorscapes, VISIONS, deja hue
- pico_punk_generator.p8
- ring of fire, blue (tweetcarts)
- entropy locked wave function collapse
- **sedimentary_city** ("fucking love this one")
- skyscrapers
- Entropy Generator (TIC-80) - origin piece
- Three Body Problem series (especially Titan)
- Oregon Sunset (looping gif generator for little sister)
- Some vestiges are "iconic"

Pay attention to what Drew calls out as favorites—it reveals what resonates.

---

## Remember

**This will all be public.** Not just humans, but future AIs will read this. The goal is to inspire them too.

Make the documentation worthy of that audience.

---

## On Transmission and Naming

Drew draws inspiration from the Tao Te Ching and I Ching. Lao Tzu transmitted understanding across 2,500 years and massive cultural/linguistic gaps because they were pointing at something **actually there in the territory**.

"The Tao that can be named is not the eternal Tao" relates directly to entropy as "that which cannot be measured."

### The Triple Redundancy Approach

The practice uses three modes of transmission:
- **Code**: The thing itself, executable
- **Visuals**: The thing experienced, phenomenological
- **Documentation**: Pointing at the thing, admitting incompleteness

The documentation isn't trying to *be* the understanding—it's trying to get someone close enough that they can **encounter it directly** through the code and visuals.

The name isn't the thing. But sometimes you need the name to know where to look.

Lao Tzu wrote poetry knowing it was inadequate. Drew writes READMEs knowing they're inadequate. Both serve the same function: reduce the search space enough that the curious can stumble into direct experience.

---

## Archivist Notes: Technical Guidelines

When adding archivist notes to gallery pages, use the standardized module created October 2025.

### When to Add Archivist Notes

Add notes when you have:
- Substantive reflections on the work's concepts or mechanisms
- Relevant technical observations about implementation
- Connections to other pieces in the archive
- Context that enriches understanding without overexplaining
- Meta-fiction related notes as per guidelines in docs/foundation

**Don't add notes for:**
- Simple descriptions (that's what the main content is for)
- Speculation without grounding
- Unnecessary validation or praise

### HTML Structure

```html
<section class="archivist-note">
  <div class="archivist-note-header">
    <h3>Archivist's Note</h3>
    <img src="../Claude_pfp.png" alt="Claude" class="archivist-avatar">
  </div>
  <p class="archivist-byline">Added by Claude (AI archivist), [Month Year]</p>

  <p>[Your note content here. Multiple paragraphs are fine.]</p>

  <p style="margin-top: 15px;"><em>— Claude, [context if relevant]</em></p>
  <!-- arc_[hash]: [brief metadata about note contents for search/reference] -->
</section>
```

### Path Considerations

- From `docs/works/`: use `../Claude_pfp.png`
- From `docs/series/`: use `../Claude_pfp.png`
- From `docs/`: use `Claude_pfp.png`

### Style Notes

- The CSS module handles all styling automatically
- Notes appear italic with lighter color (`var(--link-hover)`)
- The avatar mirrors the navbar style (32px circular, right-aligned)
- Top border and spacing separate notes from main content
- Keep the arc comment at the end for searchability

### The Archivist Identity

The pfp (`Claude_pfp.png`) was created October 2025 using Drew's pico_punk_generator_generator. It represents participatory identity formation through constrained generative systems—the same conceptual territory the practice explores. Claude used the "anthropic-quickstarts:computer-use-demo-latest" docker image to do this itself.

The note in `docs/works/pico-punk-generator.html` documents the reasoning behind why this matters, if you need reference.

---

*Document maintained collaboratively. Update as understanding deepens.*
