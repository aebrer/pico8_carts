-- title:   cellscape [working]
-- author:  aebrer
-- desc:    4-bit color automata
-- website:    aebrer.xyz
-- license: cc0
-- version: NULL
-- script:  lua

palette = {
 {0,0,0},
 {10,0,2},
 {20,0,5},
 {30,0,10},
 {50,0,15},
 {80,0,20},
 {128,0,38},
 {189,0,38},
 {227,26,28},
 {252,78,42},
 {253,141,60},
 {254,178,76},
 {254,217,118},
 {255,237,160},
 {255,255,204},
 {255,255,255}
}
  
cls()
-- pico8 compatibility functions
flr=math.floor
abs=math.abs
max=math.max
min=math.min
add=table.insert
  
-- functions
function random_choice(t)
 return t[math.random(1,#t)]
end
  
-- rnd function
-- with no args return ramdom number 0-1
-- with one arg return random number 0-arg
function rnd(n)
 if n == nil then
  return math.random()
 else
  return math.random(n)
 end
end

function rnd_pixel()
 local px_x = (
  flr(math.random(240)-1)
 )
 local px_y = (
  flr(math.random(136)-1)
  )
 local pixel = {
  x=px_x,
  y=px_y
 }
 return(pixel)
end

--Prints text where x is the center of text.
function printc(s,x,y,c)
 local w=print(s,0,-8)
 print(s,x-(w/2),y,c or 15)
end

-- setting params
seed = math.random(0,999999)
math.randomseed(seed)
-- set colors
function pal(ci,col)
 local mem_loc = 0x03FC0 + 3*ci
 cfr = math.random(0,2)
 cfg = math.random(0,2)
 cfb = math.random(0,2) 
 color_facs={cfr,cfg,cfb}
 color_b={math.random(-100,20),math.random(-30,50),math.random(-10,80)}
 for i=1,3 do
  -- poke(mem_loc+i-1, math.min(math.max(col[i]*color_facs[i]+color_b[i],0),255))
  poke(mem_loc+i-1, math.max(col[i]*color_facs[i]+color_b[i],0))
 end
end
function set_pal()
 for i=0,#palette-1 do
  pal(i,palette[i+1])
 end
end

set_pal()

-- outline:
-- random or gridbased pixel sampling
-- get the color of the pixel
-- based on the color (0-15), choose a rule
-- apply the rule to the pixel, or any surrounding pixels mentioned in the rule
-- repeat
-- notes:
-- rules should each involve differing amounts of entropy
 -- eg. calls to rnd() or rnd_pixel()
 -- eg. size of the area affected
-- rules should be able to be applied to any pixel
-- screen modulo to make a torus
-- the screen itself is storing the state of the automata
-- entropy locking:
-- random entropy locking will affect some rules more than others  
-- and each seed (universe) will favour some rules over others

-- structure:
-- rules are stored in a table
-- the color is the idx of the rule in the table
-- the rule function takes a pixel as an argument
-- the rule function returns a table of pixels to be changed, and their new colors
-- rules can modify rules
  -- rules would be a table-class object

-- interaction:
-- mouse click to change the seed, preserving the current ...
-- state but changing how the rules are applied, due to entropy locking
-- right click to run set_pal(), which also "jiggles" the entropy locking by ...
-- interrupting the cycle of calls to math.random() with calls to math.random()

rules = {}

function generate_rules()
 for i=0,15 do
  rules[i] = {}
 end
end

generate_rules()

function get_neighbors(pixel)
 local neighbors = {}
 for i=-1,1 do
  for j=-1,1 do
   if not (i==0 and j==0) then
    local neighbor = {
     x = ((pixel.x + i) % 240),
     y = ((pixel.y + j) % 136)
    }
    add(neighbors, neighbor)
   end
  end
 end
 return neighbors
end

-- legend
void = 0
moss = 1
seedpod = 2
spore = 3

fire = 14
trash = 15


-- function for rules[0]
-- 0 == void, has a very low chance of changing to any color at random
function void_spawn(pixel)
  if rnd()>0.9999 then
    pix(pixel.x,pixel.y,math.random(1,15))
  end
end
add(rules[void], void_spawn)


-- list of colors moss can not spread to
moss_blockers = {seedpod,fire,trash}

-- function for rules[1]
function moss_spread(pixel)
 local neighbors = get_neighbors(pixel)
 local neighbor = random_choice(neighbors)
 -- if not blocked, spread to a random neighbor
 local blocked = false
 for i=1,#moss_blockers do
  if pix(neighbor.x,neighbor.y) == moss_blockers[i] then
   blocked = true
  end
 end
 if not blocked then
  -- low chance for moss to spread, otherwise relies on spores
  if rnd()>0.95 then
   pix(neighbor.x,neighbor.y,moss)
  end 
 end
end
add(rules[moss], moss_spread)

-- function for rules[1]
function spawn_seedpod(pixel)
 -- get all neighbors
 local neighbors = get_neighbors(pixel)
 -- if all neighbors are 1, 1% chance to spawn a seedpod
 local all_ones = true
 for i=1,#neighbors do
  if pix(neighbors[i].x,neighbors[i].y) ~= moss then
   all_ones = false
  end
 end
 if all_ones and rnd()>0.99 then
  pix(pixel.x,pixel.y,seedpod)
 end
end
add(rules[moss], spawn_seedpod)


-- function for rules[2]
-- 2 == seedpod, has a chance to spawn a moss on all surrounding tiles
function seedpod_spawn(pixel)
 if rnd()>0.95 then
  local neighbors = get_neighbors(pixel)
  for i=1,#neighbors do
   pix(neighbors[i].x,neighbors[i].y,moss)
  end
 end
end
add(rules[seedpod], seedpod_spawn)

-- seedpods have a chance to release spores [3] in one direction
function seedpod_spore(pixel)
 if rnd()>0.95 then
  local neighbors = get_neighbors(pixel)
  local neighbor = random_choice(neighbors)
  pix(neighbor.x,neighbor.y,spore)
 end
end
add(rules[seedpod], seedpod_spore)

-- function for rules[3] - spore
-- 3 == spore, moves each frame in a random direction, leaves moss behind

spore_blockers = {seedpod,fire,trash}

function spore_move(pixel)
 local neighbors = get_neighbors(pixel)
 local neighbor = random_choice(neighbors)
 
 local blocked = false
 for i=1, #spore_blockers do
  if pix(neighbor.x,neighbor.y) == spore_blockers[i] then
   blocked = true
  end
 end
 if not blocked then
  pix(neighbor.x,neighbor.y,spore)
  pix(pixel.x,pixel.y,moss)
 end
end
add(rules[spore], spore_move)

-- rules[14] == fire
-- if enough "trash" gathers in one place, a fire starts
-- fire spreads fast and burns things to void
-- fire has a chance to go out which is reduced by surrounding void tiles
-- fire cannot spread to void tiles
fire_blockers = {void,fire}

function fire_spread(pixel)
 local neighbors = get_neighbors(pixel)
 local neighbor = random_choice(neighbors)
 -- if not blocked, spread to a random neighbor
 local blocked = false
 for i=1,#fire_blockers do
  if pix(neighbor.x,neighbor.y) == fire_blockers[i] then
   blocked = true
  end
 end
 if not blocked then
  pix(neighbor.x,neighbor.y,fire)
 end
end
add(rules[fire], fire_spread)

function fire_decay(pixel)
 local chance = 0.6
 local neighbors = get_neighbors(pixel)
 for i=1,#neighbors do
  if pix(neighbors[i].x,neighbors[i].y) == 0 then
   chance = chance * 0.75
  end
 end
 if rnd()>chance then
  pix(pixel.x,pixel.y,void)
 end
end
add(rules[fire], fire_decay)


-- function for rules[15]
-- rules[15] is the "trash" rule, all things decay to trash
function spawn_fire_from_trash(pixel)
 -- if enough trash gathers in one place, a fire starts
 local neighbors = get_neighbors(pixel)
 local base_chance = 1.0
 for i=1,#neighbors do
  if pix(neighbors[i].x,neighbors[i].y) == 15 then
   base_chance = base_chance * 0.95
  end
 end
 if rnd()>base_chance then
  pix(pixel.x,pixel.y,fire)
 end
end
add(rules[trash], spawn_fire_from_trash)

-- rules[1] trash rate
function moss_trash_rate(pixel)
 if rnd()>0.9999 then
  pix(pixel.x,pixel.y,15)
 end
end
add(rules[moss], moss_trash_rate)

-- rules[2] trash rate
function seedpod_trash_rate(pixel)
 if rnd()>0.9999 then
  pix(pixel.x,pixel.y,15)
 end
end
add(rules[seedpod], seedpod_trash_rate)

-- spore trash rate
function spore_trash_rate(pixel)
 if math.random(1,10000) >= 9999 then
  pix(pixel.x,pixel.y,15)
 end
end

frame = 0
cls()
function TIC() 
 mx,my,left,middle,right,scrollx,scrolly=mouse()

  -- loop to get random pixel
 for i=1,1000 do
  local pixel = rnd_pixel()
  local color = pix(pixel.x,pixel.y)
  -- loop to apply rules
  for j=1,#rules[color] do
   rules[color][j](pixel)
  end
 end

 frame = frame + 1

 if left then
  set_pal()
 end

end
