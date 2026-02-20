pico-8 cartridge // http://www.pico-8.com
version 35
__lua__
cls()
-- camera(-64,-64)
_set_fps(60)
poke(0x5f2d, 1) --enable mouse
w=stat(6)
seed=1
for i=1,#w do
ch=ord(sub(w,i,i))seed+=seed*31+ch
end
if(#w==0)seed=rnd(-1) 
srand(seed)

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
 local new_c = 0
 if(c==0)new_c=15 else new_c=c-1
 return new_c
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
  local a = burn(c) % #config.colors.palette / #config.colors.palette
  
  local dx = round(x*pull) + ffx
  local dy = round(y*pull) + ffy

  if rot_direc != 0 then 
   local pt = rotate(rot_direc * a, cx, cy, dx, dy)
   dx = pt[1]
   dy = pt[2]
  end

  if c > 0 then
   ovalfill(dx-rect_w,dy-rect_h,dx+rect_w,dy+rect_h,burn(c))
  end
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
  local a = burn(c) % #config.colors.palette / #config.colors.palette

  local dx = round(x*pull) + ffx
  local dy = round(y*pull) + ffy

  if rot_direc != 0 then 
   local pt = rotate(rot_direc * a, cx, cy, dx, dy)
   dx = pt[1]
   dy = pt[2]
  end

  if c > 0 then
   pset(dx,dy,burn(c))
  end
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
   if c > 0 then
    circ(x,y,circ_r,burn(c))
   end
  elseif dm == "burn" then
   local pxl = rnd_pixel()
   local x = (pxl.x - cx)
   local y = (pxl.y - cy)
   c=pget(x,y)
   local a = burn(c) % #config.colors.palette / #config.colors.palette

   local dx = round(x*pull) + ffx
   local dy = round(y*pull) + ffy

   if rot_direc != 0 then 
    local pt = rotate(rot_direc * a, cx, cy, dx, dy)
    dx = pt[1]
    dy = pt[2]
   end

   if c > 0 then
    circ(dx,dy,circ_r,burn(c))
   end
  elseif dm == "burn_rect" then
   local pxl = rnd_pixel()
   local x = (pxl.x - cx)
   local y = (pxl.y - cy)
   c=pget(x,y)
   local a = burn(c) % #config.colors.palette / #config.colors.palette

   local dx = round(x*pull) + ffx
   local dy = round(y*pull) + ffy

   if rot_direc != 0 then 
    local pt = rotate(rot_direc * a, cx, cy, dx, dy)
    dx = pt[1]
    dy = pt[2]
   end

   if c > 0 then
    rect(dx-rect_w,dy-rect_h,dx+rect_w,dy+rect_h,burn(c))
   end
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
  local a = burn(c) % #config.colors.palette / #config.colors.palette

  local dx = round(x*pull) + ffx
  local dy = round(y*pull) + ffy

  if rot_direc != 0 then 
   local pt = rotate(rot_direc * a, cx, cy, dx, dy)
   dx = pt[1]
   dy = pt[2]
  end

  if c > 0 then 
   circfill(dx,dy,circ_r,burn(c))
  end
  pxl = rnd_pixel()
  x = (pxl.x - cx)
  y = (pxl.y - cy)
  c=pget(x,y)
  dx = round(x*pull) + ffx
  dy = round(y*pull) + ffy

  a = burn(c) % #config.colors.palette / #config.colors.palette

  if rot_direc != 0 then 
   local pt = rotate(rot_direc * a, cx, cy, dx, dy)
   dx = pt[1]
   dy = pt[2]
  end
  
  local h = round(rnd(config.dither.recth))
  local w = round(rnd(config.dither.rectw))

  if c > 0 then
   line(dx+w,dy-h,dx-w,dy+h,burn(c))
   line(dx-w,dy-h,dx+w,dy+h,burn(c))
  end
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
add(config.colors.methods, "hashed")
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
 {"mouse_ctrl", "bool"},
 {"circ_r", "int"},
 {"recth", "int"},
 {"rectw", "int"},
 {"color", "int_lim", {0,15}},
 {"angle", "float_lim", {0.0,1.0}},
 {"auto_rotate", "int_lim", {-1,1}},
 {"line_wt", "int_lim", {0,100}},
 {"drop_shadows", "bool"},
 {"wiggle", "int"}
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
config.sketch.mousex,config.sketch.mousey=64,64
config.sketch.zoom1prob = 0.9
config.sketch.zoom2prob = 0.9
config.sketch.seed_prob = 0.93

function g()return rnd(12)-rnd(4)end

function config.sketch.init()
 config.sketch.p8loops = rnd(30)+5
 config.sketch.colors = rnd(5)+5
 



 config.dither.loops = rnd(60)+30
 config.dither.circ_r = rnd({1,2})
 config.dither.recth = rnd({0,1,2,3})
 config.dither.rectw = rnd({0,1,2,3})


 config.effects.glitch_freq = rnd(13)+7
 config.effects.mirror_type = rnd({5,7})

 if config.effects.mirror_type == 5 then 
  config.sketch.mousey = rnd(128)
 else 
  config.sketch.mousey = rnd(64)
 end
 

 config.brush.circ_r=rnd(30)+2
 config.brush.recth=rnd(30)+2
 config.brush.rectw=rnd(30)+2

end

config.sketch.init()

config.sketch.params = {
 {"p8loops", "int"},
 {"colors", "int"},
 {"zoom1prob", "float_fine"},
 {"zoom2prob", "float_fine"},
 {"seed_prob", "float_fine"}
}

-- always present mouse brush
function config.sketch.mouse_brush()
 if not (stat(34) == 2) then
  local brush_name = config.brush.methods[config.brush.i]
  local brush_func = config.brush[brush_name]
  if config.brush.mouse_ctrl then
   -- mouse controls
   -- only move mouse paint if clicking
   if stat(34) == 1 then
    config.sketch.mousex = stat(32)
    config.sketch.mousey = stat(33)
   end
   brush_func(config.sketch.mousex,config.sketch.mousey)
  end
 end
end


function config.sketch.sketch()

 for i=0,config.sketch.p8loops do
 ?rnd({"\^i","\^i",""})..chr(rnd(240)\1+16),rnd(132)-1,rnd(132)-1,rnd(config.sketch.colors)
 end

 poke(0x5f54,0x60)


 if(rnd()>config.sketch.zoom1prob)sspr(rnd(1.5)\1,rnd(2)\1,126,126,0,0,128,128)
 if(rnd()>config.sketch.zoom2prob)sspr(0,0,128,128,1,1,126,126)
 poke(0x5f54,0x00)

 -- if(rnd()>.9 and t()>0.3)srand(seed)
 if(rnd()>config.sketch.seed_prob)srand(seed)

 -- srand(seed)
 if((btnp(❎)and not display_params))config.sketch.init()cls()

end


-- add layers in order
add(config.sketch.methods, "mouse_brush")
add(config.sketch.methods, "sketch")
--add(config.sketch.methods, "mouse_brush")


-- overrides:

--  dither:
config.dither.i=4
config.dither.cx=64
config.dither.cy=64

--  palettes/colors:
if rnd()>.1 then
 config.colors.i = #config.colors.methods
else
 config.colors.i = flr(rnd(#config.colors.methods)+1)
end
-- brush
config.brush.mouse_ctrl=true
config.brush.i=2

-- timing
config.timing.seed_loop = false
config.timing.loop_len=8
config.timing.rec_loop_start = 12
config.timing.rec_loop_end = 14
config.timing.gif_record = false

-- effects
config.effects.enable_all = true 



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

 if config.colors.i==#config.colors.methods then

  if config.colors.hashed[1]==config.colors.hashed[pr_col] then
   
   ?"\#2"..current_param_name..": "..current_method_name.." <- ⬅️,❎",4,4,pr_col

   local curr_param_param_idx = config[config.params[config.param_i]].param_i
   if curr_param_param_idx != nil then
    local curr_param_param_name = config[config.params[config.param_i]].params[curr_param_param_idx][1]
    local curr_param_param_value = config[config.params[config.param_i]][curr_param_param_name]
    ?"\#2"..curr_param_param_name..": "..tostr(curr_param_param_value).." <- ➡️,⬆️⬇️",4,11,pr_col
   end

  else 

   ?"\#1"..current_param_name..": "..current_method_name.." <- ⬅️,❎",4,4,pr_col

   local curr_param_param_idx = config[config.params[config.param_i]].param_i
   if curr_param_param_idx != nil then
    local curr_param_param_name = config[config.params[config.param_i]].params[curr_param_param_idx][1]
    local curr_param_param_value = config[config.params[config.param_i]][curr_param_param_name]
    ?"\#1"..curr_param_param_name..": "..tostr(curr_param_param_value).." <- ➡️,⬆️⬇️",4,11,pr_col
   end
  end

 else  

  ?"\#1"..current_param_name..": "..current_method_name.." <- ⬅️,❎",4,4,pr_col

  local curr_param_param_idx = config[config.params[config.param_i]].param_i
  if curr_param_param_idx != nil then
   local curr_param_param_name = config[config.params[config.param_i]].params[curr_param_param_idx][1]
   local curr_param_param_value = config[config.params[config.param_i]][curr_param_param_name]
   ?"\#1"..curr_param_param_name..": "..tostr(curr_param_param_value).." <- ➡️,⬆️⬇️",4,11,pr_col
  end

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
ff00ff88ffppffpfhhhfhhhhhohhhohhgghhgggggghhnpnp8fnp8fff888f88888888f888fff8pnf8pnpnhhgggggghhgghhohhhohhhhhfhhhfpffppff88ff00ff
8ff88ff88ffppffpfhhhfhhhhhohhhohhghhgggggghhnpnp8fnp8fff888f88888888f888fff8pnf8pnpnhhgggggghhghhohhhohhhhhfhhhfpffppff88ff88ff8
88ff88ff88ffppffpfhhhfhhhhhohhhohghhgggggghhnpnp8fnp8fff888f88888888f888fff8pnf8pnpnhhgggggghhghohhhohhhhhfhhhfpffppff88ff88ff88
888ff88ff88ffppffpfhhhfhhhhhohhhoghhgggggghhnpnp8fnp8fff888f88888888f888fff8pnf8pnpnhhgggggghhgohhhohhhhhfhhhfpffppff88ff88ff888
8888ff88ff88ffppffpfhhhfhhhhhohhhghhgggggghhnpnp8fnp8fff888f88888888f888fff8pnf8pnpnhhgggggghhghhhohhhhhfhhhfpffppff88ff88ff8888
p8888ff88ff88ffppffpfhhhfhhhhhohhghhgggggghhnpnp8fnp8fff88fffff88fffff88fff8pnf8pnpnhhgggggghhghhohhhhhfhhhfpffppff88ff88ff8888p
ppppp8ff88ff88ffppffpfhhhfhhhhhohghhgggggghhnpnp8hhhhhffppfffff88fffffppffhhhhh8pnpnhhgggggghhghohhhhhfhhhfpffppff88ff88ff8ppppp
pppppp8ff88ff88ffppffpfhhhfhhhhhoghhgggggghhnpnp8hhhhhfpppfffpf88fpfffpppfhhhhh8pnpnhhgggggghhgohhhhhfhhhfpffppff88ff88ff8pppppp
ppppppp8ff88ff88ffppffpfhhhfhhhhhghhgggggghhnpnp8hhhhhfpppfffpf88fpfffpppfhhhhh8pnpnhhgggggghhghhhhhfhhhfpffppff88ff88ff8ppppppp
pppppppp8ff88ff88ffppffpfhhhfhhhhghhgggggghhnpnp8hhhfhfpppfffpf88fpfffpppfhfhhh8pnpnhhgggggghhghhhhfhhhfpffppff88ff88ff8pppppppp
ppppppppp8ff88ff88ffppffpfhhhfhhhghhgggggghhnpnp8hhhfhfpppfpppf88fpppfpppfhfhhh8pnpnhhgggggghhghhhfhhhfpffppff88ff88ff8ppppppppp
pppppppppp8ff88ff88ffppffpfhhhfhhg0g0ggggghhnpnp8hhhhhfpppfffff88fffffpppfhhhhh8pnpnhhggggg0g0ghhfhhhfpffppff88ff88ff8pppppppppp
ppppppppppp8ff88ff8fffppffpfhhhfhg0ggggggghhnpnp8hhhhhffohfffff88fffffhoffhhhhh8pnpnhhggggggg0ghfhhhfpffppfff8ff88ff8ppppppppppp
pppppppp8hpp8ff88ffffffppffhfgfhfg0pgggggghhnphhnphhhhffohfffff88fffffhoffhhhhpnhhpnhhggggggp0gfhfgfhffppffffff88ff8pph8pppppppp
ppgpppppp8hpp8ff88ffffffppffhfgfhg0p0ghhgghhnphhnphhhhffohf8ohf88fho8fhoffhhhhpnhhpnhhgghhg0p0ghfgfhffppffffff88ff8pph8ppppppgpp
pppgpppppp8ffo8ff88ffffffppffhfhpfophghhgghhnphhooooopffohf8ohf88fho8fhoffpooooohhpnhhgghhghpofphfhffppffffff88ff8off8ppppppgppp
gpppgpppppp8ffo8ffooooofffppffhfhfophghhgghhnphhooo0offfohf8ohf88fho8fhofffo0ooohhpnhhgghhghpofhfhffppfffoooooff8off8ppppppgpppg
pgpppgpppppp8ffo8foooooofffppffhffophghhgghhnphhooooofffohf8ohf88fho8fhofffooooohhpnhhgghhghpoffhffppfffoooooof8off8ppppppgpppgp
8pgpppgpppppp8ffo8ooooooofffppffhfophghhgghhnphhooooofffohf8ohf88fho8fhofffooooohhpnhhgghhghpofhffppfffooooooo8off8ppppppgpppgp8
p8pgpppgpp8hpp8888o888o8oofffqffffophghhgghhoonhooooofffohf8ohp88pho8fhofffooooohnoohhgghhghpoffffqfffoo8o888o8888pph8ppgpppgp8p
gp8pgpp8hpp8hpf888o8o8o88fqf8fqfffophghhggnhhgnhooooohffohf8nhp88phn8fhoffhooooohnghhngghhghpofffqf8fqf88o8o8o888fph8pph8ppgp8pg
qgp8php8phpp8hf888o888oqfg8qf8fqffophghhhgnhhgnhooooohffohp8ohp88pho8phoffhooooohnghhnghhhghpoffqf8fq8gfqo888o888fh8pphp8php8pgq
8qgp8php8phpp8f888ooooo8qfg8qf8fqfophghhhgnhhgnhooooohffohp8ohp88pho8phoffhooooohnghhnghhhghpofqf8fq8gfq8ooooo888f8pphp8php8pgq8
g8qgp8php8phppf88888f8f88qfg8qf8ffophghhhgnhhgnhooooohffohp8ohp88pho8phoffhooooohnghhnghhhghpoff8fq8gfq88f8f88888fpphp8php8pgq8g
qg8qgp8php8phpf88f88ff8888qfg8qf8fophghhhgnhhgnhooooohfppppppppppppppppppfhooooohnghhnghhhghpof8fq8gfq8888ff88f88fphp8php8pgq8gq
gqg8qgp8php8phf888p88888888qfg8qffophghhhgnhhgnhooooohfppppppppppppppppppfhooooohnghhnghhhghpoffq8gfq88888888p888fhp8php8pgq8gqg
hgqg8qgp8php8pfffppppff88888qfg8qfophghhhgnhhgnhooooohfppppppppppppppppppfhooooohnghhnghhhghpofq8gfq88888ffppppfffp8php8pgq8gqgh
hhgqg8qgp8php8pfffppppff88888qfg8fophghhhgnhhgnhooooohfppppppppppppppppppfhooooohnghhnghhhghpof8gfq88888ffppppfffp8php8pgq8gqghh
hhhgqg8qgp8php8pffpppppff88888qfgfophghhhgnhhgnhooooohfppppppppppppppppppfhooooohnghhnghhhghpofgfq88888ffpppppffp8php8pgq8gqghhh
ghhhgqg8qgp8php8pffpppppff88888qffophghhhgnhhgnhooooohfppppppppppppppppppfhooooohnghhnghhhghpoffq88888ffpppppffp8php8pgq8gqghhhg
pghhhgqg8qgp8php8pfppofppff88888qpophghhhgnhooqhooooohfppppppppppppppppppfhooooohqoohnghhhghpopq88888ffppfoppfp8php8pgq8gqghhhgp
fpghhhgqg8qgp8php8pfppofppff88888pophghhhgnhooqhooooohfppppppppppppppppppfhooooohqoohnghhhghpop88888ffppfoppfp8php8pgq8gqghhhgpf
ffpghhhgqg8qgp8php8hhhhhhhhhggg88pophghhhgnhooqh0ho00hfppppppppppppppppppfh00oh0hqoohnghhhghpop88ggghhhhhhhhh8php8pgq8gqghhhgpff
ggggggggggggggggggghhhghhhghhgggg8hg88fhgfhhgfho0hn00hhhhpppppppppppppphhhh00nh0ohfghhfghf88gh8gggghhghhhghhhggggggggggggggggggg
ggggggggggggggggggghhhhhhhhhhggggppg8pgffhhffooo00oo0ogoogpgppppppppgpgoogo0oo00oooffhhffgp8gppgggghhhhhhhhhhggggggggggggggggggg
ppppppppppppppppppphhhghhhghgggpggpg8g0ggghhhphg0o0g0ooggophhhhhhhhhhpoggoo0g0o0ghphhhggg0g8gpggpggghghhhghhhppppppppppppppppppp
nnnnnonnnnnnnnnnnnnhhhhhghhhgggggggg8gg0ggpphgpp0oop0oofffphfhphhphfhpfffoo0poo0ppghppgg0gg8gggggggghhhghhhhhnnnnnnnnnnnnnonnnnn
oooooooooooooooohnohhhhhhhhhggggghhgghhggghhg8hh00000hph8hphphphhphphph8hph00000hh8ghhggghhgghhggggghhhhhhhhhonhoooooooooooooooo
ggggggggggggggggggggggggggggghgggggg8gggggggggfhggfhhh8hpfphphphhphphpfph8hhhfgghfggggggggg8gggggghggggggggggggggggggggggggggggg
nnhhhhhhhhhhhhhhhhhhhohhhhhhhhhhhphh8pgggpggghghhhhhhhhhpfghphghhghphgfphhhhhhhhhghgggpgggp8hhphhhhhhhhhhhohhhhhhhhhhhhhhhhhhhnn
ggggggggggggggggggggggggggggggggg8888888888hhghhfhhhfhohphfhhhfhhfhhhfhphohfhhhfhhghh8888888888ggggggggggggggggggggggggggggggggg
ooooooooooooooooooooooooooooooooo88888h8888888ghfhhhfhfhfhfhhhhhhhhhhfhfhfhfhhhfhg8888888h88888ooooooooooooooooooooooooooooooooo
oooooooooooooooooohhhhhhhhhhhhhhh88888p88888g8fhfhhhfhhhgfffhhffffhhfffghhhfhhhfhf8g88888p88888hhhhhhhhhhhhhhhoooooooooooooooooo
ooooooooooooogggggghgggggggggggggp888p88p88pppfhhhphhhhhhh888888888888hhhhhhhphhhfppp88p88p888pggggggggggggghggggggooooooooooooo
oooooooooooooggggghhhhhhhhhhhhh8888888888888pp8hhhghhhhhhh888hhhhhh888hhhhhhhghhh8pp8888888888888hhhhhhhhhhhhhgggggooooooooooooo
hhpooooooooggoogggghggghghggg88hg8888888p888pphhhhhhhhhhhh88hh8888hh88hhhhhhhhhhhhpp888p8888888gh88ggghghggghggggooggoooooooophh
pppooooooggqogggghgghhhgggg88pg888888888hhhhhhhhhhhhnhhhhgnhhgggggghhnghhhhnhhhhhhhhhhhh888888888gp88gggghhhgghggggoqggooooooppp
ooooooooooooogggggggg8888888888888g8p88ghhhhphhhhnnhhnhqnn888gggggg888nnqhnhhnnhhhhphhhhg88p8g8888888888888ggggggggooooooooooooo
pppppppppppppgggggggg888888888888888p888hhhhpphhhhohhhhhhh888gg88gg888hhhhhhhohhhhpphhhh888p888888888888888ggggggggppppppppppppp
pppppppppppppggghghgg8888888888888f88888hhhhhhghhhghhhphpn888gg88gg888nphphhhghhhghhhhhh88888f8888888888888gghghgggppppppppppppp
ppppppppppppppphhhhhh8888888888888888888hhhhhhghhhghhhphppppggggggggpppphphhhghhhghhhhhh8888888888888888888hhhhhhppppppppppppppp
pppppppppppppppphhhhh88888888888888888g8hhhpp8hhh8ohhhhhhpgohgggggghogphhhhhho8hhh8pphhh8g88888888888888888hhhhhpppppppppppppppp
ggggggggggggggggghhhh8888888888888888888hhhhhhhhh8ohho88pofffggggggfffop88ohho8hhhhhhhhh8888888888888888888hhhhggggggggggggggggg
ppppppppppppppppphhhh8888888888888g8f8gghgggg88888gghppgpffgfffhhfffgffpgpphgg88888gggghgg8f8g8888888888888hhhhppppppppppppppppp
pppppppppppppppppppppppppppppppppfhp8fgggffgg88888hgh88ohpfpfgfppfgfpfpho88hgh88888ggffgggf8phfppppppppppppppppppppppppppppppppp
pppppppppppppppppppppppppppppppppppppppgggggg88g88fg8h888gfgfffggfffgfg888h8gf88g88ggggggppppppppppppppppppppppppppppppppppppppp
hhhhhhhhhhhhhhhhhhhhhpppppppppppppphppppffhgf8g888ggg8h8gg000000000000gg8h8ggg888g8fghffpppphpppppppppppppphhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhppppppppppppppppppphgg88888fgfgggfg0000f00f0000gfgggfgf88888gghppppppppppppppppppphhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhppppppppppppphppppppgffgghhhghhhhhg00ffgffgff00ghhhhhghhhggffgpppppphppppppppppppphhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhppfpppfpppffgggggfppphhphhh0000g00g0000hhhphhpppfgggggffpppfpppfpphhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhpppppphphhhhfffffpppphhhhhg0000g00g0000ghhhhhppppfffffhhhhphpppppphhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhpppphpppffppfphpphhhggg000g0000g000ggghhhpphpfppffppphpppphhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhh88hhhhhhhhhhp888888888fppppphggghg000000000000ghggghpppppf888888888phhhhhhhhhh88hhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh8888h88888fppgppgghhg0ohg00gg00gho0ghhggppgppf88888h8888hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh888hh8hh88fppppg8888hhhhfgffffgfhhhh8888gppppf88hh8hh888hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhh0000hhhhhhhhhhhhh0hhhhhhhhhhh08888h8h888pppgp8888hhhhffffffffhhhh8888pgppp888h8h88880hhhhhhhhhhh0hhhhhhhhhhhhh0000hhhhhhh
hhhhhhhhh00hhhhhhhhhhhhhhhhhhhh000000888888h88ffggpfghh8hhhhf0ffff0fhhhh8hhgfpggff88h888888000000hhhhhhhhhhhhhhhhhhhh00hhhhhhhhh
8888888ppp0hhhhhhhhhhhhhhhhhhhh0000ppppp8888888ggh8g8h88hhhh888ff888hhhh88h8g8hgg8888888ppppp0000hhhhhhhhhhhhhhhhhhhh0ppp8888888
88888888888hhhhhhhhhhhhhhhhhhhh0g00pp8pp8888888g888g8888g88888ffff88888g8888g888g8888888pp8pp00g0hhhhhhhhhhhhhhhhhhhh88888888888
oooooooooo0hhhhhhhhhhhhhhhhhhhhggg0ppoppp888888g88gg8888pppppppppppppppp8888gg88g888888pppopp0ggghhhhhhhhhhhhhhhhhhhh0oooooooooo
ooooooogg00hhhhhhhhhhhhhhhhghhh0p00ppppp8pgg8pgg88gg8888000gf00gg00fg0008888gg88ggp8ggp8ppppp00p0hhhghhhhhhhhhhhhhhhh00ggooooooo
ooooooo0000oooooooooooooooooooo0000ppppp888p8gggg8ggg800ppp0080pp0800ppp008ggg8gggg8p888ppppp0000oooooooooooooooooooo0000ooooooo
ggggggggggggggggggggggggggggggg0000ppfppff888gg8880f88000p00000pp00000p00088f0888gg888ffppfpp0000ggggggggggggggggggggggggggggggg
oooooooooooooooooooooooooooooooggfgpppppff8ofgg000000000pgpop00pp00popgp000000000ggfo8ffpppppgfggooooooooooooooooooooooooooooooo
ffffffffffffffffffffffffffffffhgggggfgpfffpffgg088gg88000f000p0hh0p000f00088gg880ggffpfffpgfggggghffffffffffffffffffffffffffffff
oooooooooooooooooooooooooooooohfhff8ffffffffggf088fg88g0gggggggggggggggg0g88gf880fggffffffff8ffhfhoooooooooooooooooooooooooooooo
ffffffffffffffffffffffffffffffhphff8foffffffggg08g808gg0gggggggggggggggg0gg808g80gggffffffof8ffhphffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffpfff8ffpffffgggg08g008gg0gggggggggggggggg0gg800g80ggggffffpff8fffpfffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffggg0gg8pggg000000000000000000gggp8gg0gggffffffffffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffff8888ffffffgggg0000000fffffffff00fffffffff0000000ggggffffff8888fffffffffffffffffffffffffffffffff
fffffffgggggggggghhhhhhhhhhhhhhhhfnh8f8pfffogggfffffggff000ffff00ffff000ffggfffffgggofffp8f8hnfhhhhhhhhhhhhhhhhggggggggggfffffff
fffffffgggffggggghhhhhhhhhhhhhhhhpnhfpohfpffgggffffffffffgfffff00fffffgffffffffffgggffpfhopfhnphhhhhhhhhhhhhhhhgggggffgggfffffff
fffffffggffffgggghhhhhhhhhhhhhhhhpohfp8h8g8hgggffppfppff0000fff00fff0000ffppfppffgggh8g8h8pfhophhhhhhhhhhhhhhhhggggffffggfffffff
fffffffgggggggggghhhhhhhhhhhhhhhhghhggnhgggggfffpfpfppf0ffpfgff00ffgfpff0fppfpfpfffggggghngghhghhhhhhhhhhhhhhhhggggggggggfffffff
ppfffffgggggggggghhhhhhhhhhhhhhnhhnhhh8fgg8fgggfpf8fphff00ff0ff00ff0ff00ffhpf8fpfgggf8ggf8hhhnhhnhhhhhhhhhhhhhhggggggggggfffffpp
fffffffgggggggggghhhhhhhhhhhhhhhhpnhpppppppggggffpfffpfffffffff88fffffffffpfffpffggggppppppphnphhhhhhhhhhhhhhhhggggggggggfffffff
ggggggggggggggggghhhhhhhhhhhhhhhh0nh00oppppggggfffffhho0008hhhh88hhhh8000ohhfffffggggppppo00hn0hhhhhhhhhhhhhhhhggggggggggggggggg
fffffffffffffffffffoooooooooooooohqophpppppg8ggggg00ggggg0hhhhh88hhhhh0ggggg00ggggg8gppppphpoqhoooooooooooooofffffffffffffffffff
8888888888888888888oooooooooooooohooph8gpppoooooooooggggg0gh8hh88hh8hg0gggggooooooooopppg8hpoohoooooooooooooo8888888888888888888
ppppppgggggggggggggoooooooooooooo0000000000oo8ggoooogpgfg0hhghh88hhghh0gfgpgoooogg8oo0000000000oooooooooooooogggggggggggggpppppp
ppppppgggggggggggggoooooooooooooo00o000p000ooogooooogop8g0gghhh88hhhgg0g8pogooooogooo000p000o00oooooooooooooogggggggggggggpppppp
ppppppgggggggggggggoooooooooooooop000p000p0ooggogoooggggghghghhhhhhghghgggggooogoggoo0p000p000poooooooooooooogggggggggggggpppppp
gggggggggggggggggggoooooooooooooo00o000o000ohoofogoogppgghhhghhhhhhghhhggppgoogofooho000o000o00ooooooooooooooggggggggggggggggggg
gggggggggggggggggggoooooooooooooof000f000f0oofpoogooggggghhhhhhhhhhhhhhgggggoogoopfoo0f000f000fooooooooooooooggggggggggggggggggg
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhg800h000f000ooooooooopgpphnhhhhhhhhhhhhnhppgpooooooooo000f000h008ghhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
8888888888888888888888888888888nh0000000000ggooogpnogppngphhpppffppphhpgnppgonpgooogg0000000000hn8888888888888888888888888888888
8hfpopppggpfphpppgooopooooofofopp88oooo8qoo8f888gp88gpphgpggggggggggggpghppg88pg888f8ooq8oooo88ppofofooooopooogppphpfpggpppopfh8
hppopppggpfphpppgooooooooofofo88p88ooo8888o8f888gpf8gpphgpggggggggggggpghppg8fpg888f8o8888ooo88p88ofofooooooooogppphpfpggpppopph
ppopppggpfphpppgooooooooofofo888p88ooo8888o8f888gp88gpphgpggggggggggggpghppg88pg888f8o8888ooo88p888ofofooooooooogppphpfpggpppopp
popppggpfphpppgooooooooofofo8888p88ooo8888o8f888gp88gpphgpggggggggggggpghppg88pg888f8o8888ooo88p8888ofofooooooooogppphpfpggpppop
opppggpfphpppgooooooooofofofo888p88ooo8888o8f888gp88gpphgpggggggggggggpghppg88pg888f8o8888ooo88p888ofofofooooooooogppphpfpggpppo
pppggpfphpppgpoooooofofofofoh888h88ooo8888o8f888gp88gpphgpggggggggggggpghppg88pg888f8o8888ooo88h888hofofofofoooooopgppphpfpggppp
ppggpfphpppgpfooooooooooooohh88hh88ooo8888o8f888gp88gpphgpggggggggggggpghppg88pg888f8o8888ooo88hh88hhooooooooooooofpgppphpfpggpp
pp00fphpppgpffoooooooooooohh88hhp88ooo8888o8f888gp88gpphgpggggggggggggpghppg88pg888f8o8888ooo88phh88hhooooooooooooffpgppphpf00pp
ppp0phpppgpfffooooooooooohhhhhhpp88ooo8888o8f888gp88gpphgpggggggggggggpghppg88pg888f8o8888ooo88pphhhhhhooooooooooofffpgppphp0ppp
pp0fhpppgpfffhoooooooooohhhhhhpph88ooo8888o8f888gp88gpphgpggggggggggggpghppg88pg888f8o8888ooo88hpphhhhhhoooooooooohfffpgppphf0pp
ppffpppgpfffhhooooooooohhhhhhpphg88ooo8888o8f888gp88gpphgpggggggggggggpghppg88pg888f8o8888ooo88ghpphhhhhhooooooooohhfffpgpppffpp
ppf0ppgpfffhhhhhhhhhhhhhhhhhpphgp88ooo8888o8f888gp88gpphgpggggggggggggpghppg88pg888f8o8888ooo88pghpphhhhhhhhhhhhhhhhhfffpgpp0fpp
pf00pgpfffhhhhhhhhhhhhhhhhhpphgph88ooo8888o8f888gp88gpphgpggggggggggggpghppg88pg888f8o8888ooo88hpghpphhhhhhhhhhhhhhhhhfffpgp00fp
08ffgpffffhhhhhhhhhhhhhhhhpphgphh88ooo8888o8f888gp88gpphgpggggggggggggpghppg88pg888f8o8888ooo88hhpghpphhhhhhhhhhhhhhhhffffpgff80
8ffgpffffhhhhhhhhhhhhhhhhpphgphhg88ooo8888o8f888gp88gpphgpggggggggggggpghppg88pg888f8o8888ooo88ghhpghpphhhhhhhhhhhhhhhhffffpgff8
ffgpffffhhhhhhhhhhhhhhhhpphgphhgp88ooo8888o8f888gp88gpphgpggggggggggggpghppg88pg888f8o8888ooo88pghhpghpphhhhhhhhhhhhhhhhffffpgff
fgpffffhhhhhhhhhhhhhhhhpphgphhgph88ooo8888o8f888gp88gpphgpggggggggggggpghppg88pg888f8o8888ooo88hpghhpghpphhhhhhhhhhhhhhhhffffpgf
gpffffhhhhhhhhhhhhhhhhpphgphhgpho88ooo8888o8f888gp88gpphgpggggggggggggpghppg88pg888f8o8888ooo88ohpghhpghpphhhhhhhhhhhhhhhhffffpg
pffffhhhhhhhhhhhhhhhhpphgphhgphog88ooo8888o8f888gp88gpphgpggggggggggggpghppg88pg888f8o8888ooo88gohpghhpghpphhhhhhhhhhhhhhhhffffp
ffffhhhhhhhhhhhhhhhhpphgphhgphogp88ooo8888o8f888gp88gpphgpggggggggggggpghppg88pg888f8o8888ooo88pgohpghhpghpphhhhhhhhhhhhhhhhffff
fffhhhhhhhhhhhhhhhhpphgphhgphogph88ooo8888o8f888gp88gpphgpggggggggggggpghppg88pg888f8o8888ooo88hpgohpghhpghpphhhhhhhhhhhhhhhhfff
ffhhhhhhhhhhhhhhhhpphgphhgphogpho88ooo8888o8f888gp88gpphgpggggggggggggpghppg88pg888f8o8888ooo88ohpgohpghhpghpphhhhhhhhhhhhhhhhff
fhhhphhhh000hh800pphgphhgphogph0o88ooo8888o8f888gp88gpphgpggggggggggggpghppg88pg888f8o8888ooo88o0hpgohpghhpghpp008hh000hhhhphhhf
hhhpphhhh00hh8800phgphhgphogphhhg88ooo8888o8f888gp88gpphgpggggggggggggpghppg88pg888f8o8888ooo88ghhhpgohpghhpghp0088hh00hhhhpphhh
hhpphhhhh00008800hgphhgphogphhhgp88ooo8888o8f888gp88gpphgpggggggggggggpghppg88pg888f8o8888ooo88pghhhpgohpghhpgh00880000hhhhhpphh
hpph8hhhh00008h00gphhgphogphhhgpp8888o8888o8f888gp88gpphgpggggggggggggpghppg88pg888f8o8888o8888ppghhhpgohpghhpg00h80000hhhh8hpph
pph88hhhh00hhh880phhgphogphhhgpph88ooo8888o8f888gp88gpphgpppphpppphppppghppg88pg888f8o8888ooo88hppghhhpgohpghhp088hhh00hhhh88hpp
ph888fpf80hhh8800hhgphogphhhgpph888oo88p88o8f888gp88gpphgpppphpppphppppghppg88pg888f8o88p88oo888hppghhhpgohpghh0088hhh08fpf888hp
h888fpf88hfhhhggghgphogphhhgp0h8o88oooopo8o8f888gp88gpphgpppphpppphppppghppg88pg888f8o8opoooo88o8h0pghhhpgohpghggghhhfh88fpf888h
888fpf88hfhhhggghgphogphhhgpp80op88oooopo8o8f888gp88gpphgpppphpppphppppghppg88pg888f8o8opoooo88po08ppghhhpgohpghggghhhfh88fpf888
88fpf88hf0hhggghgphogphhhgpp80op880000080008f888gp88gpphgpppphpppphppppghppg88pg888f800080000088po08ppghhhpgohpghggghh0fh88fpf88
00pf000f00hggghgphogphhhgpp800p8800000080008f888gp88gpphgpppphpppphppppghppg88pg888f8000800000088p008ppghhhpgohpghgggh00f000fp00

