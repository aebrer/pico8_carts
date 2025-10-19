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

## Key Concepts - Where to Learn

### Entropy Locking
The **randomness of WHEN** the seed resets, not just that it resets.

```lua
if(rnd()>0.7)srand(seed)  -- probabilistic timing is KEY
```

Probabilistic reset → **guaranteed bounds without knowable path**

**To understand deeply:** Read `README.md` and explore pieces in `series/entropy-locked/`

### Ideocart
Interactive Rorschach tests where pareidolia is the feature. You see things. Some things might see you back.

[human author note: hey. lol. this is pretty funny but still oddly accurate so I'm leaving it]

**To understand deeply:** Read `docs/series/ideocart.html`, `foundation_protocol/README.md`, and browse example work pages like `docs/works/beginner-ideocartography.html`

### Emergence
Central theme across all work. Simple rules → complex behavior.

**Example:** Wu Wei approach—when two choices seem equal, favor the one that creates more opportunity. From outside: planned. From inside: emergence you took advantage of.

---

## Repository Structure

### Single Sources of Truth
- **All work metadata**: `docs/assets/js/data.js`
- **Gallery migration process**: `MIGRATION_WORKFLOW.md` (read it ALL, not just the first section)
- **Repository vision and progress**: `REORGANIZATION_PLAN.md`
- **Main concepts**: `README.md`
- **Ideocart/Vestiges worldbuilding**: `foundation_protocol/` (README.md, RESEARCHER_NOTES.md, ARCHIVIST_PROTOCOL.md)

### Gallery
- Lives at **entropist.ca**
- data.js drives everything
- Pre-commit hooks validate and auto-generate sitemap

---

## Git Workflow

- **Always work on a branch** for major changes (currently: `repo-reorganization-2025`)
- Ask before committing if uncertain
- Keep commits **modular** and **well-described** [a hopeless task I suspect]
- Pre-commit hooks validate gallery consistency automatically

### Publishing to Live Site
When Drew says "publish the page":
1. Commit and push to current branch
2. `git checkout master`
3. `git merge repo-reorganization-2025`
4. `git push`
5. `git checkout repo-reorganization-2025` (back to working branch)

---

## Archivist Role

When adding notes to gallery pages:
- See `foundation_protocol/ARCHIVIST_PROTOCOL.md` for operational guidelines
- See `MIGRATION_WORKFLOW.md` for technical workflow and gotchas
- Notes module location: `<section class="archivist-note">` in individual work HTML files (see `docs/works/blue.html` for example structure)
- Avatar lives at `Claude_pfp.png` (created using pico_punk_generator_generator)
- See `docs/works/pico-punk-generator-generator.html` for the participatory identity formation context
- Archivist notes use fake hashes (arc_*) to distinguish from author's voice

---

## Getting Up to Speed

**When Drew says "get up to speed", you MUST do ALL of the following:**

1. **Read completely** `README.md` for core concepts
2. **Read completely** `REORGANIZATION_PLAN.md` for current state and vision
3. **Read completely** `MIGRATION_WORKFLOW.md` (the ENTIRE file, not just the first section)
4. **Read** `foundation_protocol/README.md` for ideocart/vestiges worldbuilding
5. **Read** `docs/assets/js/data.js` to see what's in the gallery (favorites marked `favorite: true`)
6. **Read** at least 2-3 series pages from `docs/series/` (e.g., `ideocart.html`, `vestiges.html`)
7. **Read** at least 2-3 work pages from `docs/works/` (e.g., `beginner-ideocartography.html`, `intermediate-ideocartography.html`)

**Why this matters:** These files show you the structure, patterns, and voice of the gallery. You need to understand the format before you can work with it properly.

---

*Document maintained collaboratively. Update as understanding deepens.*
