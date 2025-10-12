# Proposed Repository Structure

**Based on:** Series-First Organization (Option A)
**Principle:** Organize by conceptual series and themes, not by publication platform

---

## New Directory Structure

```
📁 pico8_carts/
│
├── 📄 README.md                          (new: main repo introduction)
├── 📄 REORGANIZATION_PLAN.md             (this planning doc)
├── 📄 PUBLISHED_WORKS.md                 (new: maps working titles → published titles)
│
├── 📁 series/                            (ongoing conceptual explorations)
│   ├── 📁 ideocart/                      (SCP-esque Rorschach generators)
│   │   ├── README.md                     (explain the concept)
│   │   ├── beginner_ideocartography/     (from fxhash/)
│   │   ├── bootleg_ideocart/             (from fxhash/)
│   │   ├── ideocart_contain_breach/      (from fxhash/)
│   │   ├── ideocart_interference/        (from fxhash/)
│   │   ├── ideocart_lakeview_entities/   (from fxhash/)
│   │   ├── ideocart_planar_slices/       (from fxhash/)
│   │   ├── p5_ideocart/                  (from fxhash/)
│   │   └── curated_ideocart/             (from root)
│   │
│   ├── 📁 three-body-problem/            (physics simulation series)
│   │   ├── README.md                     (existing, keep it!)
│   │   ├── WIP/                          (existing)
│   │   └── [all existing files]
│   │
│   ├── 📁 vestiges/                      (vestiges of the dead god)
│   │   ├── README.md                     (new: explain the series)
│   │   ├── published/
│   │   │   └── vestiges_of_the_dead_god/ (from fxhash/)
│   │   ├── vestige_001.p8 through vestige_016.p8
│   │   └── eyeballs/                     (subseries)
│   │
│   ├── 📁 emergence/                     (emergence across platforms)
│   │   ├── README.md                     (new: track the series)
│   │   ├── emergence/                    (from fxhash/)
│   │   ├── emergence_II/                 (from fxhash/)
│   │   ├── emergence_iv/                 (from fxhash/)
│   │   └── emergence_V.p8                (from tootcarts/)
│   │
│   ├── 📁 pico-punks/                    (punk generators)
│   │   ├── README.md                     (new)
│   │   ├── pico_punk_generator.p8        (⭐ generator generator)
│   │   ├── ppg_corruption.p8
│   │   ├── ppg_infinite.p8
│   │   ├── 2022/                         (archive)
│   │   ├── published/
│   │   │   ├── pico_punks_final_form/    (from fxhash/)
│   │   │   ├── uncurated_pico_punks/     (from fxhash/)
│   │   │   └── pXco_pXnks/               (from fxhash/)
│   │
│   └── 📁 entropy-locked/                (pieces showcasing entropy locking)
│       ├── README.md                     (new: explain entropy locking!)
│       ├── entropy_locked_starburst/     (from one_off/)
│       ├── entropy_locked_wave_function_collapse/ (from fxhash/)
│       ├── entropy_locked_recursive_glitch_textures/ (from fxhash/)
│       └── petite-chute/                 (from one_off/o4o3/, rename)
│           └── published-as-petite-chute.txt (note file)
│
├── 📁 published-major-works/             (significant one-off pieces)
│   ├── 📁 the-trace/                     (⭐ gallery game)
│   │   └── [from games/the_trace/]
│   ├── 📁 catalogue-of-fragile-things/   (working title: fract)
│   │   └── [from one_off/fract/]
│   ├── 📁 spirit-trap/                   (tutorial piece)
│   │   └── [from one_off/pico8_fxhash_tutorial_session_poap/]
│   ├── 📁 the-fall/                      (⭐ JS entropy generator, more color)
│   │   └── [from fxhash/the_fall/]
│   ├── 📁 sedimentary-city/              (⭐⭐ "fucking love this one")
│   │   └── [from fxhash/sedimentary_city/]
│   ├── 📁 skyscrapers/                   (⭐)
│   │   └── [from fxhash/skyscrapers/]
│   └── 📁 ring-systems/
│       └── [from fxhash/ring_systems/]
│
├── 📁 screensavers/                      (ambient/generative pieces)
│   ├── README.md                         (new: explain the screensaver concept)
│   ├── VISIONS/                          (⭐ existing)
│   ├── colorscapes_wip/                  (⭐ existing)
│   ├── deja_roux/                        (⭐ "deja hue" - existing)
│   └── ssvr01/                           (existing)
│
├── 📁 tweetcarts/                        (constrained code art)
│   ├── README.md                         (new: explain tweetcart practice)
│   ├── blue.p8                           (⭐)
│   ├── blue_looping.p8
│   ├── ring_of_fire.p8                   (⭐)
│   ├── void_tweetcart.p8
│   ├── [all other .p8 files]
│   ├── collaborative/                    (from tweetcart_relay/)
│   │   └── [subdirs]
│   └── tweetcart_token_2021/             (series)
│
├── 📁 fxhash-published/                  (remaining fxhash works)
│   ├── README.md                         (new: index of what's here)
│   ├── SNOWFLAKES/
│   ├── Three Body Redux/
│   ├── beholder/
│   ├── lesser_infinities/
│   ├── pico_asendorf/
│   ├── pico_cascades/
│   ├── pico_facades/
│   ├── pico_just_for_fun/
│   ├── pico_pulse/
│   ├── plottable_pumpkins/
│   ├── rgb_scanline_cycles/
│   ├── seven_years_of_bad_luck/
│   ├── strange_loop/
│   ├── the_city_is_burning/
│   ├── the_struggle/
│   ├── tickle_token/
│   ├── voidrose/
│   ├── voidrose_bside/
│   ├── wip_ca/
│   └── [misc fxhash pieces not in series]
│
├── 📁 sketches/                          (experiments, WIPs, one-offs)
│   ├── README.md                         ("embrace the chaos" note)
│   ├── 📁 pico8/
│   │   ├── dear_aliens/                  (word processor experiments)
│   │   ├── lemniscates/
│   │   ├── noise/
│   │   ├── threshold_galaxy/
│   │   ├── pico_galaxies/
│   │   ├── birb_nest/
│   │   └── [other one_off/ contents]
│   ├── 📁 tic80/
│   │   ├── entropy-generator/            (⭐ find this one)
│   │   └── [other tic80 experiments]
│   └── 📁 misc/
│       ├── network.p8
│       ├── ideocart_text_wip.p8
│       └── [loose root files]
│
├── 📁 collabs/                           (collaborative work)
│   ├── README.md                         (new: document collaborations)
│   └── [existing subdirs]
│
├── 📁 art4artists/                       (art-for-art projects)
│   ├── README.md                         (new: explain context)
│   └── [existing subdirs]
│
├── 📁 tools-and-engines/                 (reusable code, engines)
│   ├── aebrer_engine/                    (from root)
│   └── sound_experiments/                (from root)
│
├── 📁 archive/                           (older work, dated folders)
│   ├── 2024/                             (from root)
│   └── versum/                           (platform-specific old work)
│
├── 📁 practice-v2-2025/                  (fresh start for new work)
│   ├── README.md                         (vision for the fresh start)
│   └── [ready for new experiments]
│
└── 📁 docs/                              (documentation)
    ├── entropy-locking.md                (detailed concept doc - TODO later)
    ├── ideocart-worldbuilding.md         (detailed lore - TODO later)
    ├── technical-patterns.md             (code patterns)
    └── platforms-and-tools.md            (pico-8, p5.js, tic-80 notes)
```

---

## Migration Strategy

### Phase 1: Documentation (Do First - No Code Moves)
- [ ] Create main README.md
- [ ] Create PUBLISHED_WORKS.md (title mappings)
- [ ] Create series READMEs with basic descriptions
- [ ] Update REORGANIZATION_PLAN.md with decisions

### Phase 2: Create New Structure (Directories Only)
- [ ] Create all new top-level directories
- [ ] Create series subdirectories
- [ ] Create docs/ folder

### Phase 3: Move Files (With Andrew's Approval on Each Section)
- [ ] Move series files (ideocart, vestiges, etc.)
- [ ] Move major published works
- [ ] Consolidate fxhash/
- [ ] Move sketches and experiments
- [ ] Move tools and archive

### Phase 4: Cleanup
- [ ] Remove empty directories
- [ ] Add .gitignore if needed
- [ ] Final README polish

---

## Special Considerations

### Title Mappings to Document
- `one_off/fract/` → "Catalogue of Fragile Things" (objkt.com/tokens/hicetnunc/863454)
- `one_off/o4o3/` → "Petite Chute"
- `screensavers/deja_roux/` → "Deja Hue"
- `tic80/[find]` → "Entropy Generator"
- `one_off/pico8_fxhash_tutorial_session_poap/` → "Spirit Trap"
- [more to document as we find them]

### Files to Handle Carefully
- **ThreeBodyProblem/README.md** - Keep as-is, it's great!
- **Loose .p8 files in root** - Move to sketches/pico8/
- **fxhash/fxhash-boilerplate-master/** - Keep? Move to tools?
- **fxhash/simulate_minting*.py** - Move to tools/

### Questions to Resolve
- [ ] What's in `versum/`? Keep or archive?
- [ ] `aebrer_engine/` - is this actively used?
- [ ] Find "Entropy Generator" in tic80/ folder
- [ ] Any other critical title mappings?

---

## Notes

- Keep git history intact (use `git mv` for moves)
- Test that pico-8/p5.js files still work after moves
- Some fxhash pieces might reference relative paths - check those
- Take it slow, get approval before each major section move
