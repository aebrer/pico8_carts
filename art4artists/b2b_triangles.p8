pico-8 cartridge // http://www.pico-8.com
version 38
__lua__
cls()
camera(-64,-64)
_set_fps(60)
poke(0x5f2d, 1) --enable mouse
w=stat(6)
seed=1
for i=1,#w do
ch=ord(sub(w,i,i))seed+=seed*31+ch
end
if(#w==0)seed=rnd(-1) 
srand(seed)
palt(0,true)

-- local sprite_sheet_loc = 0x5f54
-- local screen_loc = 0x5f55
-- local sprite_sheet_val = 0x00 -- 0x00 (default) or 0x60
-- local screen_val = 0x60 -- 0x00 or 0x60 (default)

-- poke(sprite_sheet_loc, sprite_sheet_val)
-- poke(screen_loc, screen_val)


--------------------------------
--        functions           --
--------------------------------
function rnd_sign()
 if rnd(1) >= 0.5 then
  return(-1)
 else
  return(1)
 end
end

function rnd_pixel()
 local px_x = (
  flr(rnd(128))
 ) - 64
 local px_y = (
  flr(rnd(128))
 ) - 64
 local pixel = {
  x=px_x,
  y=px_y
 }
 return(pixel)
end

function safe_inc(idx, lim)
 local new_idx = idx + 1
 if new_idx > lim then
  new_idx = 1 
 end
 return new_idx
end

function round(n)
 return (n%1<0.5) and flr(n) or ceil(n)
end

-- rotation function
-- og credit to @dec_hl on twitter
-- c := center for rotation
-- p := point to rotate
-- a := angle
function rotate(a,cx,cy,px,py)
 local x = px - cx
 local y = py - cy
 local xr = x*cos(a) - y*sin(a)
 local yr = y*cos(a) + x*sin(a)
 return {xr+cx, yr+cy}
end
--------------------------------
--       config init          --
--------------------------------
config = {}
config.param_i = 1
config.params = {}


--------------------------------
--          burns             --
--------------------------------
function burn(c)
 return c-1
end

--------------------------------
--         dithers            --
--------------------------------
-- init
config.dither = {}
config.dither.i = 1
add(config.params,"dither")
config.dither.param_i = 1
config.dither.methods = {}

config.dither.cx = 0
config.dither.cy = 0
config.dither.loops = 300
config.dither.pull = 1.0
config.dither.rectw = 2
config.dither.recth = 2
config.dither.circ_r = 2
config.dither.pxl_prob = 0.55
config.dither.fuzz_factor = 0
config.dither.rotate = 0

-- method params
config.dither.params = {
 {"loops", "int_lim", {0,3000}},
 {"pull", "float_fine"},
 {"rectw", "int"},
 {"recth", "int"},
 {"circ_r", "int"},
 {"pxl_prob", "float_lim", {0.01, 1.0}},
 {"fuzz_factor", "int_lim", {0,100}},
 {"rotate", "int_lim", {-1,1}},
 {"cx", "int"},
 {"cy", "int"}
}

-- dither functions
function config.dither.ovalfill_burn()
 local cx = config.dither.cx
 local cy = config.dither.cy
 local loops = config.dither.loops
 local pull = config.dither.pull
 local rect_w = config.dither.rectw
 local rect_h = config.dither.recth
 local fuzz_factor = config.dither.fuzz_factor
 local fuzz = fuzz_factor > 0
 local ffx = 0
 local ffy = 0
 local rot_direc = config.dither.rotate

 for i=1,loops do
  if fuzz then 
   ffx = (round(rnd(fuzz_factor)) + 1) * rnd_sign()
   ffy = (round(rnd(fuzz_factor)) + 1) * rnd_sign()
  end
  local pxl = rnd_pixel()
  local x = (pxl.x - cx)
  local y = (pxl.y - cy)
  c=pget(x,y)
  local a = burn(c)
  
  local dx = round(x*pull) + ffx
  local dy = round(y*pull) + ffy

  if rot_direc != 0 then 
   local pt = rotate(rot_direc * a, cx, cy, dx, dy)
   dx = pt[1]
   dy = pt[2]
  end
  ovalfill(dx-rect_w,dy-rect_h,dx+rect_w,dy+rect_h,burn(c))
 end
end
add(config.dither.methods, "ovalfill_burn") -- 1


function config.dither.pset_burn()
 local cx = config.dither.cx
 local cy = config.dither.cy
 local loops = config.dither.loops
 local pull = config.dither.pull
 local fuzz_factor = config.dither.fuzz_factor
 local fuzz = fuzz_factor > 0
 local ffx = 0
 local ffy = 0
 local rot_direc = config.dither.rotate

 for i=1,loops do 
  if fuzz then 
   ffx = (round(rnd(fuzz_factor)) + 1) * rnd_sign()
   ffy = (round(rnd(fuzz_factor)) + 1) * rnd_sign()
  end
  local pxl = rnd_pixel()
  local x = (pxl.x - cx)
  local y = (pxl.y - cy)
  c=pget(x,y)
  local a = burn(c)
  local dx = round(x*pull) + ffx
  local dy = round(y*pull) + ffy

  if rot_direc != 0 then 
   local pt = rotate(rot_direc * a, cx, cy, dx, dy)
   dx = pt[1]
   dy = pt[2]
  end

  pset(dx,dy,burn(c))
  
 end
end
add(config.dither.methods, "pset_burn") -- 2

function config.dither.luna_theory()

 local dither_modes = {
  "burn_spiral",
  "burn_rect",
  "burn",
  "circfill", 
  "rect"
 } 

 local cx = config.dither.cx
 local cy = config.dither.cy
 local loops = config.dither.loops
 local pull = config.dither.pull
 local rect_w = config.dither.rectw
 local rect_h = config.dither.recth
 local circ_r = config.dither.circ_r
 local pxl_prob = config.dither.pxl_prob
 local fuzz_factor = config.dither.fuzz_factor
 local fuzz = fuzz_factor > 0
 local ffx = 0
 local ffy = 0
 local rot_direc = config.dither.rotate

 for i=1,loops do
  if fuzz then 
   ffx = round(rnd(fuzz_factor) * rnd_sign())
   ffy = round(rnd(fuzz_factor) * rnd_sign())
  end
  local dm = rnd(dither_modes)
  if dm == "circfill" then
   if rnd(1) > pxl_prob then
    local pxl = rnd_pixel()
    local dx = pxl.x + ffx - cx
    local dy = pxl.y + ffy - cy
    circfill(dx,dy,circ_r,0)
   end
  elseif dm == "rect" then
   if rnd(1) > pxl_prob then
    local pxl = rnd_pixel()
    local dx = pxl.x + ffx - cx
    local dy = pxl.y + ffy - cy
    rect(dx-rect_w,dy-rect_h,dx+rect_w,dy+rect_h,0)
   end
  elseif dm == "burn_spiral" then
   local pxl = rnd_pixel()
   local x = (pxl.x - cx)
   local y = (pxl.y - cy)
   c=pget(x,y)
   x = round(x*pull) + ffx
   y = round(y*pull) + ffy
   circ(x,y,circ_r,burn(c))
  elseif dm == "burn" then
   local pxl = rnd_pixel()
   local x = (pxl.x - cx)
   local y = (pxl.y - cy)
   c=pget(x,y)
   local a = burn(c)
   local dx = round(x*pull) + ffx
   local dy = round(y*pull) + ffy

   if rot_direc != 0 then 
    local pt = rotate(rot_direc * a, cx, cy, dx, dy)
    dx = pt[1]
    dy = pt[2]
   end
   circ(dx,dy,circ_r,burn(c))
  elseif dm == "burn_rect" then
   local pxl = rnd_pixel()
   local x = (pxl.x - cx)
   local y = (pxl.y - cy)
   c=pget(x,y)
   local a = burn(c)
   local dx = round(x*pull) + ffx
   local dy = round(y*pull) + ffy

   if rot_direc != 0 then 
    local pt = rotate(rot_direc * a, cx, cy, dx, dy)
    dx = pt[1]
    dy = pt[2]
   end
  rect(dx-rect_w,dy-rect_h,dx+rect_w,dy+rect_h,burn(c))
  end
 end
end
add(config.dither.methods, "luna_theory") -- 3

function config.dither.starfire()
 
 local cx = config.dither.cx
 local cy = config.dither.cy
 local loops = config.dither.loops
 local pull = config.dither.pull
 local circ_r = config.dither.circ_r
 circ_r = round(rnd(circ_r))
 local fuzz_factor = config.dither.fuzz_factor
 local fuzz = fuzz_factor > 0
 local ffx = 0
 local ffy = 0
 local rot_direc = config.dither.rotate

 -- local h = round(rnd(config.dither.recth))
 -- local w = round(rnd(config.dither.rectw))

 for i=1,loops do 
  if fuzz then 
   ffx = round(rnd(fuzz_factor) * rnd_sign())
   ffy = round(rnd(fuzz_factor) * rnd_sign())
  end
  local pxl = rnd_pixel()
  local x = (pxl.x - cx)
  local y = (pxl.y - cy)
  local c=pget(x,y)
  local a = burn(c)
  local dx = round(x*pull) + ffx
  local dy = round(y*pull) + ffy

  if rot_direc != 0 then 
   local pt = rotate(rot_direc * a, cx, cy, dx, dy)
   dx = pt[1]
   dy = pt[2]
  end 
  circfill(dx,dy,circ_r,burn(c))
  pxl = rnd_pixel()
  x = (pxl.x - cx)
  y = (pxl.y - cy)
  c=pget(x,y)
  dx = round(x*pull) + ffx
  dy = round(y*pull) + ffy

  a = burn(c)
  if rot_direc != 0 then 
   local pt = rotate(rot_direc * a, cx, cy, dx, dy)
   dx = pt[1]
   dy = pt[2]
  end
  
  local h = round(rnd(config.dither.recth))
  local w = round(rnd(config.dither.rectw))
  line(dx+w,dy-h,dx-w,dy+h,burn(c))
  line(dx-w,dy-h,dx+w,dy+h,burn(c))
 end
end
add(config.dither.methods, "starfire") -- 4

--------------------------------
--         colors             --
--------------------------------
-- init
config.colors = {}
add(config.params, "colors")
config.colors.methods = {}
config.colors.i = 1
config.colors.params = {}
config.colors.param_i = nil

function q()return rnd(32)-16end

-- palettes
config.colors.heatmap = {[0]=0,0,0,-15,1,-4,12,6,7,-9,10,9,-7,-2,8,-8}
add(config.colors.methods, "heatmap")  -- 1
config.colors.heatmap_green = {[0]=0,0,0,-13,3,-5,-6,-9,7,-9,10,9,-7,-2,8,-8}
add(config.colors.methods, "heatmap_green") -- 2
config.colors.blue_white_green = {[0]=0,0,0,-13,3,-5,-6,-9,7,6,12,-4,1,-15,0,0}
add(config.colors.methods, "blue_white_green") -- 3
config.colors.yellow_orange_red = {[0]=0,0,-9,10,9,-7,-2,8,-8,0,-8,8,-2,-7,9,10}
add(config.colors.methods, "yellow_orange_red") -- 4
config.colors.black_green = {[0]=0,0,0,-13,3,-5,-6,-9,7,-9,-6,-5,3,-13,0,0}
add(config.colors.methods, "black_green") -- 5
config.colors.black_blue = {[0]=0,0,0,-15,1,-4,12,6,7,6,12,-4,1,-15,0,0}
add(config.colors.methods, "black_blue") -- 6
config.colors.purple_white_blue = {[0]=0,0,0,-15,1,-4,12,6,7,14,13,-3,2,-11,-14,0}
add(config.colors.methods, "purple_white_blue") -- 7
config.colors.purple_white_green = {[0]=0,0,0,-13,3,-5,-6,-9,7,14,13,-3,2,-11,-14,0}
add(config.colors.methods, "purple_white_green") -- 8
config.colors.pnk_prpl_rd_yllw = {[0]=0,0,-9,10,9,-7,-2,8,-8,-14,-11,2,-3,13,14,7}
add(config.colors.methods, "pnk_prpl_rd_yllw") -- 9
config.colors.mono_loops = {[0]=0,0,5,6,7,7,6,5,0,0,5,6,7,7,6,5}
add(config.colors.methods, "mono_loops") -- 10
config.colors.mono_red_highlight = {[0]=0,0,5,6,7,7,6,5,-8,-8,5,6,7,7,6,5}
add(config.colors.methods, "mono_red_highlight") -- 11
config.colors.mono_blue_highlight = {[0]=0,0,5,6,7,7,6,5,-4,-4,5,6,7,7,6,5}
add(config.colors.methods, "mono_blue_highlight") -- 12
config.colors.mono_dgreen_highlight = {[0]=0,0,5,6,7,7,6,5,-13,-13,5,6,7,7,6,5}
add(config.colors.methods, "mono_dgreen_highlight") -- 13
config.colors.onebit_bw = {[0]=0,7,0,0,0,7,0,0,7,0,7,7,0,7,7,7}
add(config.colors.methods, "onebit_bw") -- 14
config.colors.onebit_red = {[0]=0,8,0,0,0,8,0,0,8,0,8,8,0,8,8,8}
add(config.colors.methods, "onebit_red") -- 15
config.colors.onebit_green = {[0]=0,3,0,0,0,3,0,0,3,0,3,3,0,3,3,3}
add(config.colors.methods, "onebit_green") -- 16
config.colors.onebit_blue = {[0]=0,-4,0,0,0,-4,0,0,-4,0,-4,-4,0,-4,-4,-4}
add(config.colors.methods, "onebit_blue") -- 17
config.colors.onebit_purple = {[0]=0,2,0,0,0,2,0,0,2,0,2,2,0,2,2,2}
add(config.colors.methods, "onebit_purple") -- 18
config.colors.onebit_yellow = {[0]=0,10,0,0,0,10,0,0,10,0,10,10,0,10,10,10}
add(config.colors.methods, "onebit_yellow") -- 19
config.colors.default = {[0]=0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15}
add(config.colors.methods, "default") -- 20
config.colors.alt_default = {[0]=0,-15,-14,-13,-12,-11,-10,-9,-8,-7,-6,-5,-4,-3,-2,-1}
add(config.colors.methods, "alt_default") -- 21
config.colors.dead_god = {[0]=0,0,-16,-16,-15,-15,-15,-15,-14,-14,-14,-11,-11,2,-8,-8}
add(config.colors.methods, "dead_god") -- 22
config.colors.dead_god_2 = {[0]=0,0,-8,8,-3,-8,8,7,2,-8,0,-8,8,-3,-8,-8}
add(config.colors.methods, "dead_god_2") -- 23
config.colors.twobit_bw = {[0]=0,6,0,0,0,6,0,0,6,0,6,6,0,6,6,7}
add(config.colors.methods, "twobit_bw") -- 24
config.colors.twobit_red = {[0]=0,-8,0,0,0,-8,0,0,-8,0,-8,-8,0,-8,-8,8}
add(config.colors.methods, "twobit_red") -- 25
config.colors.twobit_green = {[0]=0,3,0,0,0,3,0,0,3,0,3,3,0,3,3,11}
add(config.colors.methods, "twobit_green") -- 26
config.colors.twobit_blue = {[0]=0,-4,0,0,0,-4,0,0,-4,0,-4,-4,0,-4,-4,12}
add(config.colors.methods, "twobit_blue") -- 27
config.colors.twobit_purple = {[0]=0,2,0,0,0,2,0,0,2,0,2,2,0,2,2,13}
add(config.colors.methods, "twobit_purple") -- 28
config.colors.twobit_yellow = {[0]=0,0,10,0,0,10,0,0,10,0,10,10,0,10,10,-9}
add(config.colors.methods, "twobit_yellow") -- 29
config.colors.terminal_green = {[0]=-15,11,-15,-15,-15,11,-15,-15,11,-15,11,11,-15,11,11,11}
-- config.colors.terminal_green = {[0]=-15,-5,-15,-15,-15,-5,-15,-15,-5,-15,-5,-5,-15,-5,-5,-5}
add(config.colors.methods, "terminal_green") -- 30
config.colors.terminal_red = {[0]=-15,8,-15,-15,-15,8,-15,-15,8,-15,8,8,-15,8,8,8}
add(config.colors.methods, "terminal_red") -- 31
config.colors.terminal_blue = {[0]=-15,12,-15,-15,-15,12,-15,-15,12,-15,12,12,-15,12,12,12}
add(config.colors.methods, "terminal_blue") -- 32
config.colors.mutant = {[0]=0,0,-6,0,-6,10,0,0,-6,0,10,-6,0,10,10,-9}
add(config.colors.methods, "mutant") -- 33
config.colors.dead_god_3 = {[0]=0,8,-16,-16,-15,-15,-15,-15,-14,-14,-14,-11,-11,2,-8,-8}
add(config.colors.methods, "dead_god_3") -- 35
config.colors.rainbow = {[0]=0,-8,8,9,10,11,12,-4,0,-8,8,9,10,11,12,-4}
add(config.colors.methods, "rainbow") -- 36
config.colors.hashed = {[0]=0,q(),q(),q(),q(),q(),q(),q(),q(),q(),q(),q(),q(),q(),q(),q()}
add(config.colors.methods, "hashed") -- 36
config.colors.deadgod_sym = {[0]=0,8,-16,-15,-14,-11,2,-8,-8,2,-11,-14,-15,-16,8,0}
add(config.colors.methods, "deadgod_sym") -- 37
--_pal({[0]=0,133,130,141,2,136,8,7},1)
config.colors.deadgod_sym2 = {[0]=0,133,130,141,2,136,8,7,7,8,136,2,141,130,133,0}
add(config.colors.methods, "deadgod_sym2") -- 38
config.colors.rainbow_sym = {[0]=0,-8,8,9,10,11,12,-4,-4,12,11,10,9,8,-8,0}
add(config.colors.methods, "rainbow_sym") -- 39
config.colors.rainbow_heatmap = {[0]=0,-8,8,9,10,11,12,-4,0,-15,-14,-13,-12,-11,-10,-9}
add(config.colors.methods, "rainbow_heatmap") -- 40
--                                {[0]=0,0,0,-15,1,-4,12,6,7,-9,10,9,-7,-2,8,-8}
config.colors.rainbow_heatmap_2 = {[0]=0,0,0,-8,8,9,10,11,12,-4,10,9,-7,-2,8,-8}
add(config.colors.methods, "rainbow_heatmap_2") -- 41
--------------------------------
--         brushes            --
--------------------------------

config.brush = {}
add(config.params, "brush")
config.brush.methods = {}
config.brush.i = 1
config.brush.params = {}
config.brush.param_i = 1

config.brush.circ_r = 6
config.brush.line_wt = 0
config.brush.rectw = 2
config.brush.recth = 2
config.brush.color = #config.colors[config.colors.methods[config.colors.i]]
config.brush.angle = 0.0
config.brush.auto_rotate = 0
config.brush.drop_shadows = false
config.brush.wiggle = 0
config.brush.mouse_ctrl = false

config.brush.params = {
 {"circ_r", "int"},
 {"recth", "int"},
 {"rectw", "int"},
 {"color", "int_lim", {0,15}},
 {"angle", "float_lim", {0.0,1.0}},
 {"auto_rotate", "int_lim", {-1,1}},
 {"line_wt", "int_lim", {0,100}},
 {"drop_shadows", "bool"},
 {"wiggle", "int"},
 {"mouse_ctrl", "bool"}
}

-- brush functions
function config.brush.circfill(x,y)
 local c = config.brush.color
 local r = config.brush.circ_r
 local wiggle = config.brush.wiggle
 local wglx = (round(rnd(wiggle)) * rnd_sign())
 local wgly = (round(rnd(wiggle)) * rnd_sign())

 circfill(x+wglx,y+wgly,r,c)
end 
add(config.brush.methods, "circfill") -- 1

function config.brush.circ(x,y)
 local c = config.brush.color
 local r = config.brush.circ_r
 local lw = config.brush.line_wt
 local wiggle = config.brush.wiggle
 local wglx = (round(rnd(wiggle)) * rnd_sign())
 local wgly = (round(rnd(wiggle)) * rnd_sign())

 for i=0,lw do
  circ(x+wglx,y+wgly,r-i,c)
 end

end 
add(config.brush.methods, "circ") -- 2

function config.brush.pulsing_circ(x,y)
 local c = config.brush.color
 local r = config.brush.circ_r
 local t = config.timing.time
 local lw = config.brush.line_wt
 local wiggle = config.brush.wiggle
 local wglx = (round(rnd(wiggle)) * rnd_sign())
 local wgly = (round(rnd(wiggle)) * rnd_sign())

 r *= (abs(t-0.5) + 1) 
 for i=0,lw do
  circ(x+wglx,y+wgly,r-i,c)
 end
end 
add(config.brush.methods, "pulsing_circ") -- 3

function config.brush.pulsing_circfill(x,y)
 local c = config.brush.color
 local r = config.brush.circ_r
 local t = config.timing.time
 local wiggle = config.brush.wiggle
 local wglx = (round(rnd(wiggle)) * rnd_sign())
 local wgly = (round(rnd(wiggle)) * rnd_sign())
 r *= (abs(t-0.5) + 1) 
 circfill(x+wglx,y+wgly,r,c)
end 
add(config.brush.methods, "pulsing_circfill") -- 4

function config.brush.rect(x,y)
 local c = config.brush.color
 local w = config.brush.rectw
 local h = config.brush.recth
 local lw = config.brush.line_wt
 local wiggle = config.brush.wiggle
 local wglx = (round(rnd(wiggle)) * rnd_sign())
 local wgly = (round(rnd(wiggle)) * rnd_sign())

 for i=0,lw do
  rect(x+w-i+wglx,y+h-i+wgly,x-w+i+wglx,y-h+i+wgly,c)
 end
end 
add(config.brush.methods, "rect") -- 5

function config.brush.rectfill(x,y)
 local c = config.brush.color
 local w = config.brush.rectw
 local h = config.brush.recth
 local wiggle = config.brush.wiggle
 local wglx = (round(rnd(wiggle)) * rnd_sign())
 local wgly = (round(rnd(wiggle)) * rnd_sign())
 rectfill(x+w+wglx,y+h+wgly,x-w+wglx,y-h+wgly,c)
end 
add(config.brush.methods, "rectfill") -- 6

function config.brush.oval(x,y)
 local c = config.brush.color
 local w = config.brush.rectw
 local h = config.brush.recth
 local lw = config.brush.line_wt
 local wiggle = config.brush.wiggle
 local wglx = (round(rnd(wiggle)) * rnd_sign())
 local wgly = (round(rnd(wiggle)) * rnd_sign())

 for i=0,lw do 
  oval(x+w-i+wglx,y+h-i+wgly,x-w+i+wglx,y-h+i+wgly,c)
 end
end 
add(config.brush.methods, "oval") -- 7

function config.brush.ovalfill(x,y)
 local c = config.brush.color
 local w = config.brush.rectw
 local h = config.brush.recth
 local lw = config.brush.line_wt
 local wiggle = config.brush.wiggle
 local wglx = (round(rnd(wiggle)) * rnd_sign())
 local wgly = (round(rnd(wiggle)) * rnd_sign())
 for i=0,lw do
  ovalfill(x+w-i+wglx,y+h-i+wgly,x-w+i+wglx,y-h+i+wgly,c)
 end
end 
add(config.brush.methods, "ovalfill") -- 8

function config.brush.circ_ol(x,y)
 local c = config.brush.color
 local r = config.brush.circ_r
 local lw = config.brush.line_wt
 local wiggle = config.brush.wiggle
 local wglx = (round(rnd(wiggle)) * rnd_sign())
 local wgly = (round(rnd(wiggle)) * rnd_sign())

 circfill(x+wglx,y+wgly,r,c)
 for i=0,lw do
  circ(x+wglx,y+wgly,r-i,0)
 end
end 
add(config.brush.methods, "circ_ol") -- 9

function config.brush.pulse_circ_ol(x,y)
 local c = config.brush.color
 local r = config.brush.circ_r
 local t = config.timing.time
 local lw = config.brush.line_wt
 local wiggle = config.brush.wiggle
 local wglx = (round(rnd(wiggle)) * rnd_sign())
 local wgly = (round(rnd(wiggle)) * rnd_sign())

 r *= (abs(t-0.5) + 1) 
 circfill(x+wglx,y+wgly,r,c)
 for i=0,lw do
  circ(x+wglx,y+wgly,r-i,0)
 end
end 
add(config.brush.methods, "pulse_circ_ol") -- 10

function config.brush.oval_ol(x,y)
 local c = config.brush.color
 local w = config.brush.rectw
 local h = config.brush.recth
 local lw = config.brush.line_wt
 local wiggle = config.brush.wiggle
 local wglx = (round(rnd(wiggle)) * rnd_sign())
 local wgly = (round(rnd(wiggle)) * rnd_sign())

 ovalfill(x+w+wglx,y+h+wgly,x-w+wglx,y-h+wgly,c)
 for i=0,lw do
  oval(x+w-i+wglx,y+h-i+wgly,x-w+i+wglx,y-h+i+wgly,0)
 end
end 
add(config.brush.methods, "oval_ol") -- 11

function config.brush.star(x,y)

 local lw = config.brush.line_wt
 local wiggle = config.brush.wiggle

 for line_i=0,lw do 

  local rad = config.brush.circ_r
  local a = config.brush.angle
  if config.brush.auto_rotate == -1 then 
   a = -config.timing.time
  elseif config.brush.auto_rotate == 1 then
   a = config.timing.time
  end

  local c = config.brush.color
  if config.brush.drop_shadows then 
   if line_i <= 1 then 
    c = 0
   end
  end

  line()
  
  local points = {}
  for i=18,378,72 do
   local tpx = (cos(i/360.0)) * rad + round(rnd(wiggle) * rnd_sign())
   local tpy = (sin(i/360.0)) * rad + round(rnd(wiggle) * rnd_sign())
   add(points, {tpx,tpy})
  end

  local midpoint = {
   (points[1][1]-points[2][1])*0.5,
   (points[1][2]-points[2][2])*0.5
  }
  
  local opposite = sqrt((points[1][1]-midpoint[1])^2 + (points[1][2]-midpoint[2])^2)
  local adjacent = opposite / (1.14)
  local inner_rad = rad - adjacent

  local inner_points = {}
  for i=54,414,72 do
   local tpx = (cos(i/360.0)) * inner_rad + (round(rnd(wiggle)) * rnd_sign())
   local tpy = (sin(i/360.0)) * inner_rad + (round(rnd(wiggle)) * rnd_sign())
   add(inner_points, {tpx, tpy})
  end

  local r_points = {}

  for pt in all(points) do
   local new_pt = {pt[1] + x - line_i,pt[2] + y - line_i}  
   local new_new_pt = rotate(a,x,y,new_pt[1],new_pt[2])
   add(r_points, new_new_pt)
  end

  local r_inner_points = {}
  for pt in all(inner_points) do
   local new_pt = {pt[1] + x - line_i,pt[2] + y - line_i}  
   local new_new_pt = rotate(a,x,y,new_pt[1],new_pt[2])
   add(r_inner_points, new_new_pt)
  end

  line(r_points[1][1], r_points[1][2], r_inner_points[1][1], r_inner_points[1][2],c)
  line(r_points[2][1], r_points[2][2],c)
  line(r_inner_points[2][1], r_inner_points[2][2],c)
  line(r_points[3][1], r_points[3][2],c)
  line(r_inner_points[3][1], r_inner_points[3][2],c)
  line(r_points[4][1], r_points[4][2],c)
  line(r_inner_points[4][1], r_inner_points[4][2],c)
  line(r_points[5][1], r_points[5][2],c)
  line(r_inner_points[5][1], r_inner_points[5][2],c)
  line(r_points[1][1], r_points[1][2],c)
  
 end
end

add(config.brush.methods, "star") -- 12

function config.brush.triangle(x,y)

  local c = config.brush.color
  local shrink = config.brush.shrink
  local tri_rad = config.brush.circ_r

  -- Dynamic rotation based on config
  local a = config.brush.angle
  if config.brush.auto_rotate == -1 then 
    a = -config.timing.time
  elseif config.brush.auto_rotate == 1 then
    a = config.timing.time
  end

  local triangle_points = {}
  for i=360,0,-120 do
    local tpx = cos(i/360.0) * tri_rad
    local tpy = sin(i/360.0) * tri_rad
    add(triangle_points, {flr(tpx),flr(tpy)})
    tri_rad -= shrink
  end

  -- Add x, y offsets
  for pt in all(triangle_points) do
    pt[1] += x
    pt[2] += y
  end

  -- Rotate points
  for i, pt in ipairs(triangle_points) do
    triangle_points[i] = rotate(a, x, y, pt[1], pt[2])
  end

  -- Draw the triangle
  local ta = triangle_points[1]
  local tb = triangle_points[2]
  local tc = triangle_points[3]
  line(ta[1], ta[2], tb[1], tb[2], c)
  line(tb[1], tb[2], tc[1], tc[2], c)
  line(tc[1], tc[2], ta[1], ta[2], c)

end
 
add(config.brush.methods, "triangle") -- 13


--------------------------------
--         effects            --
--------------------------------

-- todo: add palette cycling to this section

config.effects = {}
add(config.params, "effects")
config.effects.methods = {}
config.effects.i = 1
config.effects.params = {}
config.effects.param_i = 1

config.effects.noise_amt = 0
config.effects.glitch_freq = 0
config.effects.enable_all = false
config.effects.mirror_type = 0

config.effects.params = {
 {"enable_all", "bool"},
 {"noise_amt", "int"},
 {"glitch_freq", "int"},
 {"mirror_type", "int_lim", {0,7}}
}

function config.effects.noise()
 local amt = config.effects.noise_amt
 if amt >= 1 then
  for i=0,amt*amt do
   poke(
       0x6000+rnd(0x2000),
       peek(rnd(0x7fff)))
   poke(
       0x6000+rnd(0x2000),
       rnd(0xff))
  end
 end
end
add(config.effects.methods, "noise")

function config.effects.glitch()
 local gr = config.effects.glitch_freq
 if gr >= 1 then 
  local on=(t()*4.0)%gr<0.1
  local gso=on and 0 or rnd(0x1fff)\1
  local gln=on and 0x1ffe or rnd(0x1fff-gso)\16
  for a=0x6000+gso,0x6000+gso+gln,rnd(16)\1 do
   poke(a,peek(a+2),peek(a-1)+(rnd(3)))
  end
 end
end
add(config.effects.methods, "glitch")

function config.effects.mirror()
 local m = config.effects.mirror_type
 poke(24364,m)
end
add(config.effects.methods, "mirror")
--------------------------------
--          timing            --
--------------------------------

config.timing = {}
add(config.params, "timing")
config.timing.methods = {}
config.timing.i = 1
config.timing.time = 0.0
config.timing.param_i = 1

config.timing.loop_len = 8
config.timing.loop_div = 2
config.timing.rec_loop_start = 10
config.timing.rec_loop_end = 12

config.timing.loop_counter = 0
config.timing.timing_zero = true  -- not displayed

config.timing.gif_record = false
config.timing.rec_started = false  -- not displayed
config.timing.rec_ended = false  -- not displayed
config.timing.cls_needed = true  -- not displayed
config.timing.seed_loop = true

config.timing.params = {
 {"gif_record", "bool"},
 {"time", "null"},
 {"loop_len", "int_lim", {1,16}},
 {"loop_div", "int_lim", {1,16}},
 {"rec_loop_start", "int_lim", {1,99}},
 {"rec_loop_end", "int_lim", {2,100}},
 {"loop_counter", "null"},  -- resets to zero when scrolled
 {"seed_loop", "bool"}
}

function config.timing.standard_loop() 
 return (t())%(config.timing.loop_len/config.timing.loop_div)/(config.timing.loop_len/config.timing.loop_div) 
end
add(config.timing.methods, "standard_loop")


--------------------------------
--     change trackers        --
--------------------------------
display_params = false
prev_gif_record = false

local palette_name = config.colors.methods[config.colors.i]
config.colors.palette = config.colors[palette_name]

--------------------------------
--  sketch specific override  --
--------------------------------
config.sketch = {}
add(config.params, "sketch")
config.sketch.methods = {}
config.sketch.i = 1
config.sketch.param_i = 1


-- todo: fix init params for new sketch
function config.sketch.init()
 config.sketch.fc = 0
 --config.effects.glitch_freq = rnd(13)+7
 --config.effects.mirror_type = rnd({5,5,5,7,7})

end

config.sketch.init()


-- todo fix params for new sketch
config.sketch.params = {
  -- {"spi_r", "int"},
 {"fc", "hidden"},
}

--config.sketch.spi_r = 1
config.sketch.fc = 1500



function config.sketch.sketch()

  local brush_name = config.brush.methods[config.brush.i]
  local brush_func = config.brush[brush_name]

  -- Large triangle's circumscribed circle radius
  local large_radius = 64 -- Distance from the canvas center to the centers of the outer circles
  local small_radius = 32 -- Radius of each individual circle's emitter path

  -- Dynamic rotation based on timing
  local a = config.brush.angle
  if config.brush.auto_rotate == -1 then
    a = -config.timing.time
  elseif config.brush.auto_rotate == 1 then
    a = config.timing.time
  end

  -- Calculate positions of three outer circles forming a larger triangle
  local outer_circles = {}
  for i = 0, 2 do
    local angle = i / 3 -- PICO-8 expects angles in turns, so use fractions of 1
    local cx = large_radius * cos(angle)
    local cy = large_radius * sin(angle)

    -- Apply rotation to outer circle
    local rotated_circle = rotate(a, 0, 0, cx, cy)
    add(outer_circles, rotated_circle)
  end

  -- For each outer circle, calculate triangle emitters
  for outer_circle in all(outer_circles) do
    local circle_x = outer_circle[1]
    local circle_y = outer_circle[2]

    for i = 0, 2 do
      -- Calculate positions of emitters on the smaller circle
      local emitter_angle = i / 3 -- Divide the smaller circle into thirds
      local ex = small_radius * cos(emitter_angle)
      local ey = small_radius * sin(emitter_angle)

      -- Apply rotation to emitter around the outer circle
      local rotated_emitter = rotate(a, circle_x, circle_y, circle_x + ex, circle_y + ey)

      -- Configure triangle brush parameters
      config.brush.angle = a -- Rotate triangles dynamically
      config.brush.color = (flr(rotated_emitter[1]^2 + rotated_emitter[2]^2) % 16) + 1 -- Color based on position

      -- Call the triangle brush function
      brush_func(rotated_emitter[1], rotated_emitter[2])
    end
  end

  -- Update frame count
  config.sketch.fc -= 1
end




-- add layers in order
--add(config.sketch.methods, "mouse_brush")
add(config.sketch.methods, "sketch")
--add(config.sketch.methods, "mouse_brush")


-- overrides:
config.brush.shrink = 0


--  dither:
config.dither.i=2
config.dither.loops=420
config.dither.pull=1.07
--config.dither.loops=0
--  palettes/colors:
config.colors.i = 1
-- config.colors.i = #config.colors.methods


-- brush 4
config.brush.i = 13

config.brush.circ_r = 32
config.brush.auto_rotate = 1


-- timing
config.timing.seed_loop = true
config.timing.loop_len=8
config.timing.rec_loop_start = 4
config.timing.rec_loop_end = 6
config.timing.gif_record = false

-- effects
config.effects.enable_all = true
config.effects.mirror_type = 7
config.effects.glitch_freq = 1

--------------------------------
--        main loop           --
--------------------------------
::_:: 


if display_params then
--------------------------------
--       input process        --
--------------------------------
 -- change what method is being used for active param
 if btnp(❎) then
  local idx = config.params[config.param_i]
  config[idx].i = safe_inc(config[idx].i, #config[idx].methods)
 end

 -- cycle through the changable parameters
 if btnp(⬅️) then
  config.param_i = safe_inc(config.param_i, #config.params)
 end

 if btnp(➡️) then  -- change the selected param
  local curr_param_param_idx = config[config.params[config.param_i]].param_i
   if curr_param_param_idx != nil then
    local param = config[config.params[config.param_i]]
    local new_param_i = safe_inc(param.param_i, #param.params)
    config[config.params[config.param_i]].param_i = new_param_i
   end
  end

 if btnp(⬇️) then  -- scroll down
  local curr_param_param_idx = config[config.params[config.param_i]].param_i
  if curr_param_param_idx != nil then
   local curr_param_param_name = config[config.params[config.param_i]].params[curr_param_param_idx][1]
   local curr_pp_type = config[config.params[config.param_i]].params[curr_param_param_idx][2]
   local curr_param_param_value = config[config.params[config.param_i]][curr_param_param_name]
   local new_param_param_value = 0
   if curr_pp_type == "int" then 
    new_param_param_value = curr_param_param_value - 1
   elseif curr_pp_type == "float" then
    new_param_param_value = curr_param_param_value * 0.97
   elseif curr_pp_type == "float_fine" then
    new_param_param_value = curr_param_param_value * 0.998
   elseif curr_pp_type == "float_lim" then
    local curr_pp_lim = config[config.params[config.param_i]].params[curr_param_param_idx][3]
    local low_lim = curr_pp_lim[1]
    local high_lim = curr_pp_lim[2]
    new_param_param_value = curr_param_param_value * 0.97
    new_param_param_value = min(new_param_param_value, high_lim)
    new_param_param_value = max(new_param_param_value, low_lim)
   elseif curr_pp_type == "int_lim" then
    local curr_pp_lim = config[config.params[config.param_i]].params[curr_param_param_idx][3]
    local low_lim = curr_pp_lim[1]
    local high_lim = curr_pp_lim[2]
    new_param_param_value = curr_param_param_value - 1
    new_param_param_value = min(new_param_param_value, high_lim)
    new_param_param_value = max(new_param_param_value, low_lim)
   elseif curr_pp_type == "bool" then
    new_param_param_value = not curr_param_param_value
   elseif curr_pp_type == "null" then
    new_param_param_value = curr_param_param_value
   end
   config[config.params[config.param_i]][curr_param_param_name] = new_param_param_value
  end
 end

 if btnp(⬆️) then  -- scroll up
  local curr_param_param_idx = config[config.params[config.param_i]].param_i
  if curr_param_param_idx != nil then
   local curr_param_param_name = config[config.params[config.param_i]].params[curr_param_param_idx][1]
   local curr_pp_type = config[config.params[config.param_i]].params[curr_param_param_idx][2]
   local curr_param_param_value = config[config.params[config.param_i]][curr_param_param_name]
   local new_param_param_value = 0
   if curr_pp_type == "int" then 
    new_param_param_value = curr_param_param_value + 1
   elseif curr_pp_type == "float" then
    new_param_param_value = curr_param_param_value * 1.03
   elseif curr_pp_type == "float_fine" then
    new_param_param_value = curr_param_param_value * 1.002
   elseif curr_pp_type == "float_lim" then
    local curr_pp_lim = config[config.params[config.param_i]].params[curr_param_param_idx][3]
    local low_lim = curr_pp_lim[1]
    local high_lim = curr_pp_lim[2]
    if curr_param_param_value == 0 then 
     new_param_param_value = 0.01 
    else
     new_param_param_value = curr_param_param_value * 1.03
     new_param_param_value = min(new_param_param_value, high_lim)
     new_param_param_value = max(new_param_param_value, low_lim)
    end
   elseif curr_pp_type == "int_lim" then
    local curr_pp_lim = config[config.params[config.param_i]].params[curr_param_param_idx][3]
    local low_lim = curr_pp_lim[1]
    local high_lim = curr_pp_lim[2]
    new_param_param_value = curr_param_param_value + 1
    new_param_param_value = min(new_param_param_value, high_lim)
    new_param_param_value = max(new_param_param_value, low_lim)
   elseif curr_pp_type == "bool" then
    new_param_param_value = not curr_param_param_value
   elseif curr_pp_type == "null" then
    new_param_param_value = curr_param_param_value
   end
   config[config.params[config.param_i]][curr_param_param_name] = new_param_param_value
  end
 end
end
--------------------------------
--        debug menu          --
--------------------------------

if btnp(🅾️) then 
 display_params = not display_params
 if(not display_params)cls()
end

--------------------------------
--          timing            --
--------------------------------

local timing_name = config.timing.methods[config.timing.i]
local timing_func = config.timing[timing_name]
config.timing.time = timing_func()
local timing_zero = config.timing.timing_zero
local loop_counter = config.timing.loop_counter
local t = config.timing.time

if t <= 0.01 and not timing_zero then
 config.timing.timing_zero = true
end

if t > 0.01 and timing_zero then
 config.timing.timing_zero = false
 config.timing.loop_counter += 1
 if (config.timing.seed_loop) srand(seed)
end  

--------------------------------
--       do dithering         --
--------------------------------
local dither_name = config.dither.methods[config.dither.i]
local dither_func = config.dither[dither_name]
dither_func()

--------------------------------
--       do effects         --
--------------------------------
if config.effects.enable_all then
 for effect_name in all(config.effects.methods) do 
  local effect_func = config.effects[effect_name]
  effect_func()
 end
 if(display_params)poke(24364,0)
end

--------------------------------
--       setup palette        --
--------------------------------
local palette_name = config.colors.methods[config.colors.i]
config.colors.palette = config.colors[palette_name]
local palette = config.colors.palette


--------------------------------
--       setup brushes        --
--------------------------------

for method_name in all(config.sketch.methods) do 
 local method_func = config.sketch[method_name]
 method_func()
end

--------------------------------
--       onscreen gui         --
--------------------------------
if display_params then
 -- get a safe print color
 local pr_col = #palette
 while palette[pr_col] == palette[1] do
  pr_col -= 1
 end

 local current_param_name = config.params[config.param_i]
 local current_method_idx = config[current_param_name].i
 local current_method_name = config[current_param_name].methods[current_method_idx]


 ?"\#1"..current_param_name..": "..current_method_name.." <- ⬅️,❎",-60,-60,pr_col

 local curr_param_param_idx = config[config.params[config.param_i]].param_i
 if curr_param_param_idx != nil then
  local curr_param_param_name = config[config.params[config.param_i]].params[curr_param_param_idx][1]
  local curr_param_param_value = config[config.params[config.param_i]][curr_param_param_name]
  ?"\#1"..curr_param_param_name..": "..tostr(curr_param_param_value).." <- ➡️,⬆️⬇️",-60,-53,pr_col
 end
end

flip()
pal(palette, 1) 

--------------------------------
--         recording          --
--------------------------------

if config.timing.gif_record then
 if prev_gif_record == false then 
  config.timing.loop_counter = 0
 end
 
 if loop_counter == config.timing.rec_loop_start and not config.timing.rec_started then
  extcmd("rec") -- start recording
  config.timing.rec_started = true
 end
 if loop_counter == config.timing.rec_loop_end and not config.timing.rec_ended and config.timing.rec_started then
  extcmd("video") -- save video
  config.timing.rec_ended = true
  config.timing.gif_record = false
 end

 if config.timing.loop_counter == 0 and config.timing.cls_needed then
  config.timing.rec_started = false
  config.timing.rec_ended = false
  cls()
  config.timing.cls_needed = false
  display_params = false
 elseif config.timing.loop_counter >= 1 then
  config.timing.cls_needed = true
 end
end
prev_gif_record = config.timing.gif_record

-- screenshots
local kbp=stat(31)
if kbp=="s" then 
 extcmd("screen")
elseif kbp=="g" then 
 extcmd("video")
end 

goto _
__label__
0000000022020iii0000pp000000000000ii208i0000000000000020000pp0i00i0pp0000200000000000000i802ii000000000000pp0000iii0202200000000
00000000200002200ppppp000202020200i02iii0000002000000000000p2p0000p2p0000000000002000000iii20i002020202000ppppp00220000200000000
0000000i0000020000ppp20i000002000020ppppi00002i2i0i00000000p2p0000p2p00000000i0i2i20000ipppp020000200000i02ppp0000200000i0000000
000000000000000000000000000002000p0ii08ii000000000p20000000pp000000pp00000002p000000000ii80ii0p000200000000000000000000000000000
000000000000p2pii20000000000ii00ppiippiippp00000ppi0ppi000i0i0i00i0i0i000ipp0ipp00000pppiippiipp00ii00000000002iip2p000000000000
00p000000000p000002022000000ip20ip20ppp2p2p20200000000ii00ii00000000ii00ii00000000202p2p2ppp02pi02pi000000220200000p000000000p00
00p02000000000p0002i20000000ii0iip2p2pp20202020000i000i0i0i0i0ippi0i0i0i0i000i00002020202pp2p2pii0ii00000002i2000p00000000020p00
i0i0i2i0000pp0i0i0222000000p0p0i02p2ipp2p2p20200000000i0i00000000000000i0i00000000202p2p2ppi2p20i0p0p0000002220i0i0pp0000i2i0i0i
0000i20ippppp000000i000p00000ii0002p2ip2p2p2p20000i000i0i0i00ip00pi00i0i0i000i00002p2p2p2pi2p2000ii00000p000i000000pppppi02i0000
i0i0p2i0pp0000i0i020200002000202000piip2i2i2p2ii000000i2i22iippppppii22i2i000000ii2p2i2i2piip000202000200002020i0i0000pp0i2p0i0i
00082020p000pppi0iii00200i0i00000000pppppi2000pi00ii0pi22222i0p00p0i22222ip0ii00ip0002ippppp00000000i0i00200iii0ippp000p02028000
i0p0000ppp0pppppi022p22202i2020200000000pp000000000i00p20222i00ii00i22202p00i000000000pp0000000020202i20222p220ippppp0ppp0000p0i
00ppp0000ip0p0000i00002000i000000000000002200000000000022222i0i00i0i222220000000000002200000000000000i00020000i0000p0pi0000ppp00
ipi0p0ipp0ipppppi0i2020002i2020002020000020202p0000020ip222piiippiiip222pi0200000p2020200000202000202i2000202i0ipppppi0ppi0p0ipi
080800p0p0i0ppp00p0p0p200i0i00000p0p000002222202pii0i0i0ippii2i00i2iippi0i0i0iip202222200000p0p00000i0i002p0p0p00ppp0i0p0p008080
i0ppp0ipipppipi2222202200202p2000202i0000p2220000i0p00000iiii080080iiii00000p0i0000222p0000i2020002p2020022022222ipipppipi0ppp0i
0p0000000pp2222222220200000ppppp20222i00000000ip20ip0pipiiipiiippiiipiiipip0pi02pi00000000i22202ppppp0000020222222222pp0000000p0
i0i0i000pp0222220002p220000000p202020000000p0ipp00000000002000088000020000000000ppi0p000000020202p000000022p2000222220pp000i0i0i
0iii0p00000222200000ppi000000002000200i00020200000002022202020222202020222020000000202000i002000200000000ipp00000222200000p0iii0
i0i2i2i0000222200002p2i2020000000202000000022000p00002p000p0000000000p000p20000p0002200000002020000000202i2p2000022220000i2i2i0i
0000222p00002220002222i8i80000000000082i00000000000020p000p0000220000p000p02000000000000i28000000000008i8i22220002220000p2220000
0i02p2pp0pp00p0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000p00pp0pp2p20i0
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00020008000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080002000
02000i20002000000000002000p000600020002000p000p000p000p000p000p00p000p000p000p000p000p000200020006000p00020000000000020002i00020
02000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020
0p008p002222200i0p0p0p0p2020000i020i080000000000002020p020222020020222020p020200000000000080i020i0000202p0p0p0p0i002222200p800p0
0ip00i0022222002p2p0p0pp22222i0000i0000000000000002000000002202882022000000002000000000000000i0000i22222pp0p0p2p2002222200i00pi0
000pi0i002220000020208002220iiii08ii0800000000002020222020i0200000020i0202220202000000000080ii80iiii022200802020000022200i0ip000
00000iii000000020222208p00020i00000000000000000020pppppp0pp0200000020pp0pppppp02000000000000000000i02000p802222020000000iii00000
000020i0p0p222i0i2i0i0i0000020000800080000020000002p222000202022220202000222p2000000200000800080000200000i0i0i2i0i222p0p0i020000
000020200022222ip0p00002p0p200p0000000000002020000pppppp0pp8220000228pp0pppppp0000202000000000000p002p0p20000p0pi222220002020000
00000pp000222220i000i0i2i00000000000p8p0000000p000ppppppippi80022008ippipppppp000p0000000p8p00000000000i2i0i000i022222000pp00000
20i0200000222220ppipp2p2ppp00200000p000i0000000020pppppipppi02222220ipppippppp0200000000i000p00000200ppp2p2ppipp0222220000020i02
0000002000022222i2i202i2i0022020000pp0pi00i0000022pp220ppppipp8008ppipppp022pp2200000i00ip0pp0000202200i2i202i2i2222200002000000
800002000000ipippipppp2000200002022222000p0000p02pppppppppppppp00pppppppppppppp20p0000p0002222202000020002ppppippipi000000200008
22202000000000p2i0022p22i2220020022222ppp0ppp0000p0p2pipi2pppppppppppp2ipip2p0p0000ppp0ppp2222200200222i22p2200i2p00000000020222
00pi000ii0pp000piiipp222p2p202220222020p020p02ipp00000p000ppppp00ppppp000p00000ppi20p020p020222022202p2p222ppiiip000pp0ii000ip00
0000iiii0002000iii0ii2i0i22000000222222ppp2p200p222p0ppppppppp2pp2ppppppppp0p222p002p2ppp22222200000022i0i2ii0iii0002000iiii0000
000ii0iiii0i002000ipp2p022200002p22202ppp0i2i0i2i2i20pp0020ppp2pp2ppp0200pp02i2i2i0i2i0ppp20222p200002220p2ppi000200i0iiii0ii000
0000000000i20000i00pi0i0i222220p0200022pi22p2p0222220ppppp2ppp2222ppp2ppppp0222220p2p22ip2200020p022222i0i0ip00i00002i0000000000
000p0000pp0000iiiiip000ii22202002222220p020p02i2i2i2ipp2220ppp2222ppp0222ppi2i2i2i20p020p02222220020222ii000piiiii0000pp0000p000
0000000000000022i0ipi2i0ipi00ppp000iiiipiippp00p222p0ppppp0ppp2222ppp0ppppp0p222p00pppiipiiii000ppp00ipi0i2ipi0i2200000000000000
0000000p0p00000200ip0pi002ip020000000iiiiii0i2i2i0i0ipp2020ppp2222ppp0202ppi0i0i2i2i0iiiiii000000020pi200ip0pi00200000p0p0000000
000000pp0202p0000iii02ii2i2p2p202000iiipip0222222p0p0ppppppppp2222ppppppppp0p0p2222220pipiii000202p2p2i2ii20iii0000p2020pp000000
000pp0020p0p222pp0i000i202ip0p0000000i0pip0202i22000i0200020020000200200020i00022i2020pip0i0000000p0pi202i000i0pp222p0p0200pp000
pp0ppppp220222222202220i202p202p200iiiipiip222222p000000000002i00i200000000000p222222piipiiii002p202p202i022202222222022ppppp0pp
pppppp02pp2220202020i2000202000202ii00pp2pp2022200000000000200piip0020000000000022202pp2pp00ii2020002020002i0202020222pp20pppppp
0pippppp0p02p0p202pp0p0020i0202i2iiip0pp222222220p000000000pp2piip2pp000000000p022222222pp0piii2i2020i0200p0pp202p0p20p0pppppip0
00000p000p0p00i008p0000002220200020p002p202pp0p000000000002222p22p222200000000000p0pp202p200p0200020222000000p800i00p0p000p00000
000pppp000i0p02i88ppp08020i0202020ppp0pp20202020b020000020022600006220020000020b02020202pp0ppp0202020i02080ppp88i20p0i000pppp000
06000600p6ii00i08000g602b60p1800lppppppp20p0p1iip10p22pp0111110000111110pp22p01pii1p0p02pppppppl0081p06b206g00080i00ii6p00600060
0000g020ag200gp08800eg002g20200p2p0pppii20202020i02020p0p00i06000060i00p0p02020i02020202iippp0p2p00202g200ge00880pg002ga020g0000
000000020000000008000220000002pppppppp00ii0220ppi00p22p2ppp0020220200ppp2p22p00ipp0220ii00pppppppp200000022000800000000020000000
000000020p0000000200p2002220i00p200000p0000020p0i02020p0p0pi02000020ip0p0p02020i0p0200000p000002p00i0222002p0020000000p020000000
00002222i000p00000202000022200pppppp2p00i0000pi0000020p2ppp0000000000ppp2p0200000ip0000i00p2pppppp00222000020200000p000i22220000
000ii222iip2020ipppp0p222222200p2p000002i020i000i02000i0p00000022000000p0i00020i000i020i200000p2p002222222p0ppppi0202pii222ii000
p002p022ii00222p202i0000220000000000i2220i2ippi000i00000ii000002200000ii00000i000ippi2i0222i0000000000220000i202p22200ii220p200p
000022020220p20p22ip0200020000000000p02000i0i000i020002020000002200000020200020i000i0i00020p0000000000200020pi22p02p022020220000
00p02220022p00i0i0i00000000222022000p22220ii0p100000000000000002200000000000000001p0ii02222p00022022200000000i0i0i00p22002220p00
00000p0p0020p00220i002p0p0p2p00022002222i0i0i020i000202000200002200002000202000i020i0i0i22220022000p2p0p0p200i02200p0200p0p00000
p000p0pp0p00ppipipii000000022000i002022p2iii22p0000i0000ppp0000000000ppp0000i0000p22iii2p220200i000220000000iipipipp00p0pp0p000p
02220002p202000008i000p0p0p2p2p00000000ii0p0i000p0p0p0p000p0000000000p000p0p0p0p000i0p0ii00000000p2p2p0p0p000i800000202p20002220
022000i0i0iii0i0i0i0i0ii0ii222000020p0p0ppppppp0p0pi0ippp2p2000000002p2pppi0ip0p0ppppppp0p0p020000222ii0ii0i0i0i0i0iii0i0i000220
022000i0i0iii0i0i0i0i0ii0ii222000020p0p0ppppppp0p0pi0ippp2p2000000002p2pppi0ip0p0ppppppp0p0p020000222ii0ii0i0i0i0i0iii0i0i000220
02220002p202000008i000p0p0p2p2p00000000ii0p0i000p0p0p0p000p0000000000p000p0p0p0p000i0p0ii00000000p2p2p0p0p000i800000202p20002220
p000p0pp0p00ppipipii000000022000i002022p2iii22p0000i0000ppp0000000000ppp0000i0000p22iii2p220200i000220000000iipipipp00p0pp0p000p
00000p0p0020p00220i002p0p0p2p00022002222i0i0i020i000202000200002200002000202000i020i0i0i22220022000p2p0p0p200i02200p0200p0p00000
00p02220022p00i0i0i00000000222022000p22220ii0p100000000000000002200000000000000001p0ii02222p00022022200000000i0i0i00p22002220p00
000022020220p20p22ip0200020000000000p02000i0i000i020002020000002200000020200020i000i0i00020p0000000000200020pi22p02p022020220000
p002p022ii00222p202i0000220000000000i2220i2ippi000i00000ii000002200000ii00000i000ippi2i0222i0000000000220000i202p22200ii220p200p
000ii222iip2020ipppp0p222222200p2p000002i020i000i02000i0p00000022000000p0i00020i000i020i200000p2p002222222p0ppppi0202pii222ii000
00002222i000p00000202000022200pppppp2p00i0000pi0000020p2ppp0000000000ppp2p0200000ip0000i00p2pppppp00222000020200000p000i22220000
000000020p0000000200p2002220i00p200000p0000020p0i02020p0p0pi02000020ip0p0p02020i0p0200000p000002p00i0222002p0020000000p020000000
000000020000000008000220000002pppppppp00ii0220ppi00p22p2ppp0020220200ppp2p22p00ipp0220ii00pppppppp200000022000800000000020000000
0000g020ag200gp08800eg002g20200p2p0pppii20202020i02020p0p00i06000060i00p0p02020i02020202iippp0p2p00202g200ge00880pg002ga020g0000
06000600p6ii00i08000g602b60p1800lppppppp20p0p1iip10p22pp0111110000111110pp22p01pii1p0p02pppppppl0081p06b206g00080i00ii6p00600060
000pppp000i0p02i88ppp08020i0202020ppp0pp20202020b020000020022600006220020000020b02020202pp0ppp0202020i02080ppp88i20p0i000pppp000
00000p000p0p00i008p0000002220200020p002p202pp0p000000000002222p22p222200000000000p0pp202p200p0200020222000000p800i00p0p000p00000
0pippppp0p02p0p202pp0p0020i0202i2iiip0pp222222220p000000000pp2piip2pp000000000p022222222pp0piii2i2020i0200p0pp202p0p20p0pppppip0
pppppp02pp2220202020i2000202000202ii00pp2pp2022200000000000200piip0020000000000022202pp2pp00ii2020002020002i0202020222pp20pppppp
pp0ppppp220222222202220i202p202p200iiiipiip222222p000000000002i00i200000000000p222222piipiiii002p202p202i022202222222022ppppp0pp
000pp0020p0p222pp0i000i202ip0p0000000i0pip0202i22000i0200020020000200200020i00022i2020pip0i0000000p0pi202i000i0pp222p0p0200pp000
000000pp0202p0000iii02ii2i2p2p202000iiipip0222222p0p0ppppppppp2222ppppppppp0p0p2222220pipiii000202p2p2i2ii20iii0000p2020pp000000
0000000p0p00000200ip0pi002ip020000000iiiiii0i2i2i0i0ipp2020ppp2222ppp0202ppi0i0i2i2i0iiiiii000000020pi200ip0pi00200000p0p0000000
0000000000000022i0ipi2i0ipi00ppp000iiiipiippp00p222p0ppppp0ppp2222ppp0ppppp0p222p00pppiipiiii000ppp00ipi0i2ipi0i2200000000000000
000p0000pp0000iiiiip000ii22202002222220p020p02i2i2i2ipp2220ppp2222ppp0222ppi2i2i2i20p020p02222220020222ii000piiiii0000pp0000p000
0000000000i20000i00pi0i0i222220p0200022pi22p2p0222220ppppp2ppp2222ppp2ppppp0222220p2p22ip2200020p022222i0i0ip00i00002i0000000000
000ii0iiii0i002000ipp2p022200002p22202ppp0i2i0i2i2i20pp0020ppp2pp2ppp0200pp02i2i2i0i2i0ppp20222p200002220p2ppi000200i0iiii0ii000
0000iiii0002000iii0ii2i0i22000000222222ppp2p200p222p0ppppppppp2pp2ppppppppp0p222p002p2ppp22222200000022i0i2ii0iii0002000iiii0000
00pi000ii0pp000piiipp222p2p202220222020p020p02ipp00000p000ppppp00ppppp000p00000ppi20p020p020222022202p2p222ppiiip000pp0ii000ip00
22202000000000p2i0022p22i2220020022222ppp0ppp0000p0p2pipi2pppppppppppp2ipip2p0p0000ppp0ppp2222200200222i22p2200i2p00000000020222
800002000000ipippipppp2000200002022222000p0000p02pppppppppppppp00pppppppppppppp20p0000p0002222202000020002ppppippipi000000200008
0000002000022222i2i202i2i0022020000pp0pi00i0000022pp220ppppipp8008ppipppp022pp2200000i00ip0pp0000202200i2i202i2i2222200002000000
20i0200000222220ppipp2p2ppp00200000p000i0000000020pppppipppi02222220ipppippppp0200000000i000p00000200ppp2p2ppipp0222220000020i02
00000pp000222220i000i0i2i00000000000p8p0000000p000ppppppippi80022008ippipppppp000p0000000p8p00000000000i2i0i000i022222000pp00000
000020200022222ip0p00002p0p200p0000000000002020000pppppp0pp8220000228pp0pppppp0000202000000000000p002p0p20000p0pi222220002020000
000020i0p0p222i0i2i0i0i0000020000800080000020000002p222000202022220202000222p2000000200000800080000200000i0i0i2i0i222p0p0i020000
00000iii000000020222208p00020i00000000000000000020pppppp0pp0200000020pp0pppppp02000000000000000000i02000p802222020000000iii00000
000pi0i002220000020208002220iiii08ii0800000000002020222020i0200000020i0202220202000000000080ii80iiii022200802020000022200i0ip000
0ip00i0022222002p2p0p0pp22222i0000i0000000000000002000000002202882022000000002000000000000000i0000i22222pp0p0p2p2002222200i00pi0
0p008p002222200i0p0p0p0p2020000i020i080000000000002020p020222020020222020p020200000000000080i020i0000202p0p0p0p0i002222200p800p0
02000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020
02000i20002000000000002000p000600020002000p000p000p000p000p000p00p000p000p000p000p000p000200020006000p00020000000000020002i00020
00020008000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080002000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0i02p2pp0pp00p0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000p00pp0pp2p20i0
0000222p00002220002222i8i80000000000082i00000000000020p000p0000220000p000p02000000000000i28000000000008i8i22220002220000p2220000
i0i2i2i0000222200002p2i2020000000202000000022000p00002p000p0000000000p000p20000p0002200000002020000000202i2p2000022220000i2i2i0i
0iii0p00000222200000ppi000000002000200i00020200000002022202020222202020222020000000202000i002000200000000ipp00000222200000p0iii0
i0i0i000pp0222220002p220000000p202020000000p0ipp00000000002000088000020000000000ppi0p000000020202p000000022p2000222220pp000i0i0i
0p0000000pp2222222220200000ppppp20222i00000000ip20ip0pipiiipiiippiiipiiipip0pi02pi00000000i22202ppppp0000020222222222pp0000000p0
i0ppp0ipipppipi2222202200202p2000202i0000p2220000i0p00000iiii080080iiii00000p0i0000222p0000i2020002p2020022022222ipipppipi0ppp0i
080800p0p0i0ppp00p0p0p200i0i00000p0p000002222202pii0i0i0ippii2i00i2iippi0i0i0iip202222200000p0p00000i0i002p0p0p00ppp0i0p0p008080
ipi0p0ipp0ipppppi0i2020002i2020002020000020202p0000020ip222piiippiiip222pi0200000p2020200000202000202i2000202i0ipppppi0ppi0p0ipi
00ppp0000ip0p0000i00002000i000000000000002200000000000022222i0i00i0i222220000000000002200000000000000i00020000i0000p0pi0000ppp00
i0p0000ppp0pppppi022p22202i2020200000000pp000000000i00p20222i00ii00i22202p00i000000000pp0000000020202i20222p220ippppp0ppp0000p0i
00082020p000pppi0iii00200i0i00000000pppppi2000pi00ii0pi22222i0p00p0i22222ip0ii00ip0002ippppp00000000i0i00200iii0ippp000p02028000
i0i0p2i0pp0000i0i020200002000202000piip2i2i2p2ii000000i2i22iippppppii22i2i000000ii2p2i2i2piip000202000200002020i0i0000pp0i2p0i0i
0000i20ippppp000000i000p00000ii0002p2ip2p2p2p20000i000i0i0i00ip00pi00i0i0i000i00002p2p2p2pi2p2000ii00000p000i000000pppppi02i0000
i0i0i2i0000pp0i0i0222000000p0p0i02p2ipp2p2p20200000000i0i00000000000000i0i00000000202p2p2ppi2p20i0p0p0000002220i0i0pp0000i2i0i0i
00p02000000000p0002i20000000ii0iip2p2pp20202020000i000i0i0i0i0ippi0i0i0i0i000i00002020202pp2p2pii0ii00000002i2000p00000000020p00
00p000000000p000002022000000ip20ip20ppp2p2p20200000000ii00ii00000000ii00ii00000000202p2p2ppp02pi02pi000000220200000p000000000p00
000000000000p2pii20000000000ii00ppiippiippp00000ppi0ppi000i0i0i00i0i0i000ipp0ipp00000pppiippiipp00ii00000000002iip2p000000000000
000000000000000000000000000002000p0ii08ii000000000p20000000pp000000pp00000002p000000000ii80ii0p000200000000000000000000000000000
0000000i0000020000ppp20i000002000020ppppi00002i2i0i00000000p2p0000p2p00000000i0i2i20000ipppp020000200000i02ppp0000200000i0000000
00000000200002200ppppp000202020200i02iii0000002000000000000p2p0000p2p0000000000002000000iii20i002020202000ppppp00220000200000000
0000000022020iii0000pp000000000000ii208i0000000000000020000pp0i00i0pp0000200000000000000i802ii000000000000pp0000iii0202200000000

