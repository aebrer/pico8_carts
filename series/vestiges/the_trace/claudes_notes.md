# Claude's Notes on "The Trace Gallery"

## Overview
The Trace Gallery is a gallery exploration/walking simulator with SCP-style horror elements, a doom timer system, collectible items, achievement tracking, and multiple endings. The game involves navigating through a surreal digital gallery while managing doom accumulation and discovering secrets.

---

## 1. Core Mechanics

### Page-Based Navigation
- The game is structured as a series of interconnected "pages" (locations in the gallery)
- Each page has:
  - A unique seed-based procedural logo/artwork
  - Title and text content (can have multiple text variants accessed via guided tour)
  - Up to 4 directional choices (⬆️ ⬇️ ⬅️ ➡️)
  - Optional callback functions that execute when entering/leaving
  - Visual effects (vfx)
  - Music state

### Seed System
- Every page has a deterministic seed generated from its title string (via `get_seed()`)
- Seeds control procedural art generation for that page
- Seeds can be manipulated via "drift away" and "look around" actions
- The title page seed is checked: `if lib[title].seed\1%17==0 then cursed=true`

### Dual Mode Display (O Button)
- Pressing O toggles between two displays:
  - **Even presses (side%2==0)**: Show navigation choices
  - **Odd presses (side%2==1)**: Show inventory options
- Each O press increases doom and plays an animated button sprite (8 frames, cycles)
- When cycling through all 8 O button animations, screen clears

### Bookmark/History System (X Button)
- Pressing X opens bookmark history view
- Shows last 10 visited pages
- Navigate with ⬆️/⬇️, select with O to jump back
- Pressing X or ❎ again exits bookmark mode
- Tracking: `history` table stores last 10 pages, `his_curr` tracks cursor position

---

## 2. Doom Timer System

### What IS Doom?
The doom timer (`dt`) represents corruption/danger level. When high enough, it triggers "dead god" events.

### What INCREASES Doom (doom_plus)
- **Every page transition** - Called in `on_leave()` for all pages
- **Every O button press** (inventory toggle)
- **Every seed manipulation** - "drift away" and "look around" actions
- **Reject choices in ending sequence** - Each reject multiplies doom: `dt+=100; dt*=1.2`

### What is the "Dead God" (dc)?
- Function: `dc() = rnd(dt/rnd(dtm))>1` where `dtm=1024`
- When dc() returns true, corrupted visuals appear
- Pages marked with `curr_page.dc=true` get special treatment:
  - Distorted color palette (dark colors: 8,-16,-15,-14,-11,2,-8,-8)
  - Music switches to "dead god" state
  - Can trigger containment breach
  - May randomly assign ch_breach to a random direction

### What GRANTS Anti-Doom
Anti-doom is a separate counter that creates white noise pixels on screen.

**Sources:**
1. **Drinking from fountain** (mirror world only): `anti_doom+=dt; dt=0` (complete reset!)
2. **Accept choices in ending sequence**: `anti_doom*=1.2; anti_doom+=dt; dt/=2`

**Visual Effect:**
```lua
for i=1,anti_doom do
  pset(rnd(128),rnd(128),rnd({0,15}))
end
```

---

## 3. Inventory System

All items are boolean flags in the `inventory` table.

### Collectible Items

1. **"open mind"**
   - Starting item (everyone begins with this)
   - Enables: "look around" action (⬇️ in inventory)
   - Most important item for progression

2. **"blank card"**
   - Found via "look around" (20% chance: `rnd()>0.8`)
   - Enables: "read card" action (➡️ in inventory)
   - Opens branching narrative paths (threat/art/news)
   - Can be reset by chance (0.5%: `rnd()>0.995`)

3. **"guided tour"**
   - Found via "look around" (6% chance: `0.66>rnd()>=0.6`)
   - Enables: "guided tour" action (⬆️ in inventory)
   - Cycles through alternate text for each page
   - Plays page turn sound (sfx 49)

4. **"instant camera"**
   - Found via "look around" (4% chance: `0.44>rnd()>=0.4`)
   - Enables: "take photo" action (⬅️ in inventory)
   - Captures current page's vfx to `cam_vfx` array
   - Photos overlay on all subsequent views
   - Max 3 photos stored (oldest deleted)
   - Plays shutter sound (sfx 29)
   - Also triggers video export (`extcmd("video")`)

5. **"cursed"**
   - Obtained by reading the "don't read" card option (when cursed variable is true)
   - OR by entering containment breach page
   - Effect: Locks seed on every frame: `if(inventory["cursed"])srand(curr_page.seed)`
   - Makes card options persist (normally they disappear after selection if not cursed)

---

## 4. Mirror World

### How to Access
- Find "a mirror" page in the statue garden (random chance)
- Mirror page shows cryptic text: "⬇️░█⬇️●🅾️⬇️\n⬅️☉ˇ░★"
- Choose "go in" (➡️) to toggle mirror_world

### What Changes in Mirror World
1. **Fountain replaces door** at the "good for you" page
2. **Color palette changes**:
   - Normal world: `pal(15,7,1)` (white is white)
   - Mirror world: `pal(15,0,1)` (white is black)
3. **Dead god palette** is different:
   - Normal: `pal(15,-8,1)`
   - Mirror: `pal(15,-14,1)`
4. **Memory address 24364** tracks state:
   - Normal: `poke(24364,0)`
   - Mirror: `poke(24364,129)`
   - In transition: `poke(24364,5)`

### The Fountain (Mirror World Only)
- Replaces the mysterious door option
- Offers: "take drink" action
- **Effect: COMPLETE DOOM RESET** - `anti_doom+=dt; dt=0`
- Multiple text variants with Taoist philosophy
- Special vfx: `fount_fx()` - randomizes palette continuously

---

## 5. Achievements (18 Total)

Achievement system tracked in `secrets` table. Display via pause menu option 3.

### Complete List:

1. **"debug"** - Access debug mode at startup
2. **"observed an omen"** - Trigger dead god state (dc() returns true)
3. **"drifted and saw 'it'"** - Drift until title page seed % 17 == 0 (sets cursed=true)
4. **"used bookmark"** - Use the bookmark/history system
5. **"debugged"** - Open debug info screen (pause menu option 2)
6. **"the card changes"** - Witness card reset (0.5% chance when reading card)
7. **"fake news or something"** - Read the back of the news card ("what the hell" page)
8. **"art lover"** - Visit the "just art" card page
9. **"drank the water"** - Drink from the fountain (mirror world)
10. **"braved the entropy maze"** - Enter the statue garden
11. **"found a mirror"** - Discover the mirror page
12. **"into the mirror world"** - Enter through the mirror
13. **"exit via the backrooms"** - Use the emergency exit in statue garden
14. **"got mad; it's just a game"** - Choose "fuck you" on the threat card
15. **"you let it out"** - Trigger containment breach
16. **"got a curse"** - Read the "don't read" card option
17. **"looked around"** - Use the "look around" action
18. **"director's cut!"** - Use the guided tour
19. **"say cheese"** - Take a photo

*Note: List appears to have 19 but code sets `n_sec=18`*

---

## 6. Endings

### Requirements for Good Ending
- Find ALL 18 secrets/achievements
- Navigate to "mysterious door" page
- Door callback checks: `for i,j in pairs(secrets) do n+=1 end`
- If `n>=n_sec`, door unlocks

### The Good Ending Sequence (6 Pages)
Once unlocked, the door leads to a 6-page narrative:

1. **"you found me"** - "i know you worked hard to get this far..."
2. **"i am dead"** - "the other copies of you have been hiding me here..."
3. **"it is not your fault"** - "we both knew the risks..."
4. **"you need to give up"** - "the real you is still alive out there..."
5. **"be careful"** - "if this thing gets out..."
6. **"promise me"** - "promise me you'll never return to this place again."

### Accept vs Reject Mechanic
Each page offers two choices:

**ACCEPT (➡️):**
```lua
anti_doom*=1.2
anti_doom+=dt
dt/=2
```
- Reduces doom, increases anti-doom
- Represents choosing to let go

**REJECT (⬅️):**
```lua
dt+=100
dt*=1.2
if dc() then
  cls()
  glitch()
  curr_page.choices[rnd({⬆️,⬇️,➡️,⬅️})]=ch_breach
end
```
- Massively increases doom
- Can trigger containment breach
- Represents refusal to accept the truth

### Final Choice (Page 6)
- **"i promise" (➡️)**: Resets the game - `extcmd("reset")`
- **"reject" (⬅️)**: Applies reject callback (more doom, potential breach)

### The Bad Ending (Containment Breach)
- Triggered when doom gets too high and dc() succeeds
- OR by navigating to breach page directly
- OR randomly when dc() is active
- Launches `containment_breach()` function (88% chance when entering breach page)
- Full-screen generative art piece (original: https://teia.art/objkt/127402)
- Plays "dead god" music
- No escape except restart

---

## 7. Camera/Photo System

### How It Works
```lua
ch_photo=new_choice(
 "take photo",
 nil,
 function()
  sfx(29, 3) --camera shutter sound
  doom_plus()
  extcmd("video")
  add(cam_vfx,curr_page.vfx)
  if(#cam_vfx>3)deli(cam_vfx,1)
  secrets["say cheese"]=true
 end
)
```

### What Gets Captured
- The current page's `vfx` function (visual effect)
- NOT a screenshot, but the generative effect function itself
- Maximum 3 photos stored (FIFO queue)

### Photo Playback
Photos play on EVERY subsequent page:
```lua
for cvfx in all(cam_vfx) do
  cvfx(curr_page)
end
```

### Side Effect
Also triggers PICO-8's video recording: `extcmd("video")`

---

## 8. Ideocartography Integration

The game includes three logo generators, each implementing different ideocartographic principles.

### Logo 1: v9_static
```lua
v9_static = {}
v9_static.name="v9_static"
```
- Default logo style
- Random fillp patterns (▥,█,▤)
- Concentric circles with random colors
- Grid-based with random palette mapping
- Uses `dc_pal()` for dead god corruption

### Logo 2: dg_logo (Entropy Locked)
```lua
dg_logo.name = "ttc_s01t04"
```
- **ENTROPY LOCKING IMPLEMENTATION:**
  ```lua
  if(rnd()>self.seed_rate)srand(curr_page.seed)
  ```
- seed_rate varies: 0.99 (new page) or 0.4 (revisit)
- The randomness of WHEN the seed resets creates bounded but unpredictable variation
- Screen-space manipulation: `sspr()` feedback loops
- Random circles and sprite stretching
- Applies to "dead god" pages

### Logo 3: ideocart_logo
```lua
ideocart_logo.name="trace_ideocart"
```
- Used for statue garden
- Variable grid size (xi, yi): 12, 16, 32, or 64
- Ensures at least one dimension is >16
- Circle grid + sprite scrambling
- Heavy use of `sspr()` coordinate swapping
- Resets seed at end: `srand(curr_page.seed)`

### Logo Assignment
- Pages specify which logo via `page.logo=<logo_name>`
- Default is `v9_static`
- Logos are initialized once per page visit
- "dead god" pages often use `dg_logo`

---

## 9. Page Navigation

### Primary Navigation (Choices)
Each page can have up to 4 directional choices:
```lua
page.choices[⬆️] = new_choice("title", target_page, callback)
page.choices[⬇️] = new_choice(...)
page.choices[⬅️] = new_choice(...)
page.choices[➡️] = new_choice(...)
```

### Navigation Flow
1. Player presses direction button
2. Button press detected in `_update60()`
3. Choice callback executes (if present)
4. `goto_page()` called if choice has target page
5. Current page's `on_leave()` and `leave_cb()` execute
6. New page becomes current
7. New page's initialization occurs
8. Page's `cb()` callback executes every frame while on page

### Special Navigation Mechanics

**"drift away" (title page ➡️):**
- Increments page seed: `curr_page.seed+=1`
- Forces reinitialization: `curr_page.i=false`
- Increases doom
- Allows seed hunting for special states

**"look around" (inventory ⬇️):**
- Random seed reset: `curr_page.seed=rnd(-1)`
- 20% chance to find blank card
- 6% chance to find guided tour
- 4% chance to find instant camera
- 1% chance to spawn statue garden entrance
- Forces reinitialization

### Dead End Pages
Some pages have no choices (dead ends). When this happens:
```lua
if (not (c⬆️ or c⬇️ or c⬅️ or c➡️)) then
  -- Display bookmark/inventory instructions
end
```
Player must use bookmark system to escape.

---

## 10. Hidden Mechanics

### The Cursed Variable (distinct from cursed item)
```lua
if lib[title].seed\1%17==0 then
  cursed=true
else
  cursed=false
end
```
- Checked every frame against title page seed
- When true, enables "tear" vfx and glitch effects
- Unlocks "don't read" option on the blank card
- Achievement: "drifted and saw 'it'"

### Statue Garden Secret Structure
- 13 randomly generated statue pages
- Each statue page has 4 random choices to other statues
- Infinite maze (can loop forever)
- Hidden pages can spawn: mirror, emergency exit
- Entrance appears randomly (1% chance) when looking around
- Also appears at "good for you" page when seed % 17 == 0

### Card Reset Secret
When reading the blank card, 0.5% chance all options reset:
```lua
if rnd()>0.995 then
  secrets["the card changes"]=true
  seed_rnd()
  -- All choices reassigned
end
```

### Mirror World Door Swap
At "good for you" page:
```lua
if mirror_world then
  lib[p_g4u].choices[➡️]=ch_fount
else
  lib[p_g4u].choices[➡️]=ch_door
end
```

### Containment Breach Trigger
When entering breach choice callback:
```lua
d=rnd()
if(d>.88)containment_breach()  -- 12% chance
```
Only 12% of breach entries actually trigger the full sequence.

### Music State System
Three music states via SFX swapping:
- **"angry"** - swaps to sfx 18,19,20,21
- **"dead god"** - swaps to sfx 22-28
- **"peaceful"** - swaps to sfx 30-37

Uses memory manipulation: `swap_sfx()` via `memcpy()` at address 0x3200

### Debug Mode
Set at line 7: `debug_mode=false`
- If true, starts at debug page
- All inventory items granted
- Only 1 achievement required
- Seed set to 42069

---

## 11. Narrative/Lore

### The Story Being Told
You are a copy/instance of someone exploring a digital gallery. The "real you" is still alive outside. You're searching for someone (another instance) who got trapped/died in here.

### Key Narrative Reveals (Ending)
1. **You are dead** - "i am dead. i am not coming back."
2. **Multiple copies exist** - "the other copies of you have been hiding me here"
3. **They distract the entity** - "they distract it, they feed it"
4. **Connection to real world** - "the real you is still alive out there... probably feeling a shadow of what we do in here"
5. **Containment horror** - Something dangerous is trapped here that must not escape
6. **Sacrifice** - The trapped instance sacrificed themselves
7. **The ask** - "promise me you'll never return to this place again"

### Thematic Elements
- **Digital consciousness/copies** - SCP-style entity containment
- **Doom as corruption/entropy** - Gallery as liminal backrooms space
- **Recursive exploration** - The trace/remnant left behind
- **Letting go vs. holding on** - Accept/reject binary

### The Entity
Never fully explained, but implied to be:
- Something contacted/unleashed at the gallery
- Feeds on attention/interaction (doom)
- Represented by "dead god" state
- Capable of escaping to the "mainland"/real world
- Contained by sacrificial instances serving as distraction

### User ID: 127402
- Required input at startup
- Codename: "hierophant"
- References the containment breach art: https://teia.art/objkt/127402
- The number itself is the artwork's ID on the Teia platform

---

## 12. Key Technical Details

### Page Initialization System
Every page has an `i` flag (initialized):
```lua
if not curr_page.i then
  -- One-time setup
  curr_page.dc=dc()
  -- Color palette setup
  srand(curr_page.seed)
  curr_page.logo:init()
  curr_page.i=true
end
```

### Seed Generation Algorithm
```lua
function get_seed(w)
  s=1
  for i=1,#w do
    ch=ord(sub(w,i,i))
    s+=s*31+ch
  end
  return(s)
end
```
- Polynomial rolling hash
- Uses multiplier of 31 (common in string hashing)
- Deterministic: same string = same seed

### Visual Effects (vfx) System
All vfx functions take `page` parameter and are called every frame:

- **glitch()** - Memory corruption effect
- **dither_noise()** - Random black pixels, disables cls
- **tear()** - Vertical strip of logo art
- **zoom()** - Slight zoom on logo area
- **more_art()** - Extends art into text area
- **newsy()** - Newspaper-style palette (7,6,5,0)
- **dg_newsy()** - Dead god newspaper palette
- **fount_fx()** - Randomizes single color in palette

### The Glitch Effect
```lua
local on=(t()*4.0)%13<0.1
local gso=on and 0 or rnd(0x1fff)\1
local gln=on and 0x1ffe or rnd(0x1fff-gso)\16
for a=0x6000+gso,0x6000+gso+gln,rnd(16)\1 do
  poke(a,peek(a+2),peek(a-1)+(rnd(3)))
end
```
- Operates directly on screen memory (0x6000)
- Time-based flickering
- Random memory offsets and lengths
- Creates scanline-like corruption

### Color Palette System
Pages can modify the display palette:
- Base sprite palette: `pal(colors,0)`
- Display palette: `pal(colors,1)`
- Dead god palette uses negative numbers for extended palette
- Mirror world swaps black/white
- Fountain continuously randomizes

### Fullscreen Mode
Toggle via pause menu:
```lua
if fullscreen then
  page.logo:draw(0,0,128,128)
else
  clip(0,8,128,32)
  page.logo:draw(0,8,128,32)
end
```
Removes UI, shows only generative art.

### Performance Notes
- Runs at 60 FPS (`_update60()`)
- Heavy use of `srand()` for deterministic randomness
- Entropy locking: probabilistic seed reset
- Memory manipulation for music swapping
- Screen memory effects for glitches
- No token count visible, but this is described as the most complex work

### The Containment Breach Art
Full standalone generative piece with:
- Custom camera offset (-64,-64)
- Multiple dither modes: mixed, burn_rect, burn, rect
- Color burn algorithm: `abs(c-1)`
- Orbital pattern generation
- Noise and undither passes
- Entropy-locked seed reset: `if srf and seed_reset_needed then srand(seed)`
- Overrides _draw() with empty function
- Infinite loop (no exit condition)

---

## Notes on Complexity

This is indeed remarkably complex for PICO-8:
- Dynamic page/choice graph structure
- Multiple layered systems (doom, inventory, achievements)
- Procedural art generation with entropy locking
- State preservation across navigation
- Photo system storing function references
- Mirror world state bifurcation
- Music state management via memory manipulation
- Meta-narrative about digital consciousness
- Hidden mechanics and secrets

The entropy locking in `dg_logo` is particularly elegant - the probabilistic seed reset creates guaranteed bounds (art will stay somewhat consistent) without a knowable path (can't predict which frames will reset), exemplifying the "that which cannot be measured" principle.
