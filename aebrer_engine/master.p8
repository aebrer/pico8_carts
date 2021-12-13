pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
cls()
camera(-64,-64)
_set_fps(60)
poke(0x5f2d, 1) --enable mouse
seed = rnd(-1)

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
 local new_c = max(c-1,0)
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
config.colors.hole = {[0]=0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,0}
add(config.colors.methods, "hole") -- 34
config.colors.dead_god_3 = {[0]=0,8,-16,-16,-15,-15,-15,-15,-14,-14,-14,-11,-11,2,-8,-8}
add(config.colors.methods, "dead_god_3") -- 35

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
config.timing.rec_loop_start = 2
config.timing.rec_loop_end = 4

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

config.sketch.r_step=0.11
config.sketch.rad=10
config.sketch.rndx=0
config.sketch.rndy=20
config.sketch.num_pts=2
config.sketch.fc=128

config.sketch.params = {
 {"r_step", "float_fine", {0.001,0.2}},
 {"rad", "int_lim", {1,100}},
 {"rndx", "float_lim", {0.1,50}},
 {"rndy", "float_lim", {0.1,50}},
 {"num_pts", "int"},
 {"fc", "int"}
}

-- always present mouse brush
function config.sketch.mouse_brush()
 if not (stat(34) == 2) then
  local brush_name = config.brush.methods[config.brush.i]
  local brush_func = config.brush[brush_name]
  if config.brush.mouse_ctrl then
   -- mouse controls
   local x = stat(32) - 64
   local y = stat(33) - 64
   brush_func(x,y)
  end
 end
end

function config.sketch.sketch()
 local brush_name = config.brush.methods[config.brush.i]
 local brush_func = config.brush[brush_name]
 local r_step = config.sketch.r_step
 local rad = config.sketch.rad
 local rndx = config.sketch.rndx
 local rndy = config.sketch.rndy
 local num_pts = config.sketch.num_pts

 for r=0,1,r_step do
 -- local r = config.timing.time
  for i=0,num_pts do
   local x=(sin(r)*(rad+(rnd(rndx))))
   local y=((cos(r)*sin(r))*(rad+(i*rnd(rndy))))
   -- config.brush.color=x*y%15
   brush_func(x,y)
  end
 end
end

function config.sketch.shred()
 -- config.sketch.fc-=rnd(0.5)
 -- local fc = config.sketch.fc
 local fc = 128

 for i=0,50 do
  p=0x6000+flr(rnd(8181))
  q=0x6000+flr(rnd(8181))
  poke(p,peek(p)/128-fc)
  poke(q,p)
 end

 if fc<=0 then
  fc=128
 end

 for i=1,500 do 
  local x = rnd(128)
  local y = rnd(128)
  c=pget(x,y)
  if c > 0 then
   pset(x,y,burn(c))
  end
 end

end

function config.sketch.crop()
  -- black bars
 local x=54
 local y=44
 local x2=96
 local y2=32
 local x0=-20
 local y0=158
 rectfill(x0-x,x0-y,y2-x,y0-y,0)
 rectfill(x2-x,x0-y,y0-x,y0-y)
 rectfill(x0-x,x0-y,y0-x,y2-y)
 rectfill(x0-x,x2-y,y0-x,y0-y)
end

-- add layers in order
--add(config.sketch.methods, "mouse_brush")
-- add(config.sketch.methods, "sketch")
add(config.sketch.methods, "shred")
-- add(config.sketch.methods, "crop")


-- overrides:
--  brush:
config.brush.i=11
config.brush.circ_r=0
config.brush.recth=1
config.brush.rectw=10
config.brush.wiggle=0
config.brush.color=15
config.brush.line_wt=0

--  dither:
config.dither.i=2
config.dither.loops=0
config.dither.pull=1.05
config.dither.rectw=2
config.dither.recth=2
config.dither.circ_r=2
config.dither.pxl_prob=0.575
config.dither.fuzz_factor=4
config.dither.rotate=1



--  palettes/colors:
config.colors.i = 35


-- timing
config.timing.seed_loop = true
config.timing.loop_len=4
config.timing.rec_loop_start = 12
config.timing.rec_loop_end = 14
config.timing.gif_record = true

-- effects
config.effects.enable_all = true 
config.effects.noise_amt = 0
config.effects.glitch_freq = 0
config.effects.mirror_type = 0


-- misc
config.sketch.r_step=0.11
config.sketch.rad=10
config.sketch.rndx=0
config.sketch.rndy=0
config.sketch.num_pts=2
config.sketch.fc=128


--------------------------------
--        main loop           --
--------------------------------
::_:: 


if display_params then
 --------------------------------
 --       input process        --
 --------------------------------
 -- change what method is being used for active param
 if btnp(1) then
  local idx = config.params[config.param_i]
  config[idx].i = safe_inc(config[idx].i, #config[idx].methods)
 end

 -- cycle through the changable parameters
 if btnp(0) then
  config.param_i = safe_inc(config.param_i, #config.params)
 end

 if btnp(5) then  -- change the selected param
  local curr_param_param_idx = config[config.params[config.param_i]].param_i
   if curr_param_param_idx != nil then
   local param = config[config.params[config.param_i]]
   local new_param_i = safe_inc(param.param_i, #param.params)
   config[config.params[config.param_i]].param_i = new_param_i
  end
 end

 if btnp(3) then  -- scroll down
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

 if btnp(2) then  -- scroll up
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

if btnp(4) then 
 display_params = not display_params
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


 ?"\#1"..current_param_name..": "..current_method_name.." <- ⬅️➡️",-60,-60,pr_col

 local curr_param_param_idx = config[config.params[config.param_i]].param_i
 if curr_param_param_idx != nil then
  local curr_param_param_name = config[config.params[config.param_i]].params[curr_param_param_idx][1]
  local curr_param_param_value = config[config.params[config.param_i]][curr_param_param_name]
  ?"\#1"..curr_param_param_name..": "..tostr(curr_param_param_value).." <- ❎, ⬆️⬇️",-60,-53,pr_col
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

goto _
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000f000000f00000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000f000000f00000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000ff0000ff00000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000ffffff000000000000000000000000ffffffff00000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000ffffff000000000000000000000000ffffffff00000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000ffffffffff00000000000000000000000f8ff8f000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000ffffff0000000000000000000000000ffffff000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000ffffff0000000000000000000000000f8ff8f000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000ffffff0000000000000000000000000ff88ff000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000ffffff0000000000000000000000000f8ff8f000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000ffff000000000000000000000000000ffff0000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000ffff000000000000000000000000000ffff0000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000ffffff0000000000000000000000000ffffff000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000ffffffffffff0000000000000000000ffffffffffff000000000000000000000000000000000000000000000000000000000000000000
000000000000000000ffffffffffffff00000000000000000ffffffffffffff00000000000000000000000000000000000000000000000000000000000000000
000000000000000000ffffffffffffff00000000000000000ffffffffffffff00000000000000000000000000000000000000000000000000000000000000000
00000000000000000ffffffffffffffff000000000000000ffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
00000000000000000ffffffffffffffff000000000000000ffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
0000000000000000fff00ffffffff00fff0000000000000fff00ffffffff00fff000000000000000000000000000000000000000000000000000000000000000
000000000000000fff000ffffffff000fff00000000000fff000ffffffff000fff00000000000000000000000000000000000000000000000000000000000000
000000000000000fff000ffffffff000fff00000000000fff000ffffffff000fff00000000000000000000000000000000000000000000000000000000000000
__label__
70000000777070707770077077707770000000007770000007707770777077700000707077707770700000000000777000007770770007707770770077700000
07000000700070707070707070700700000000007000000070007070707007000000707007007770700000000000707000007000707070000700707070000000
00700000770007007770707077000700000077707700000070007770770007000000777007007070700000007770777000007700707070000700707077000000
07000000700070707000707070700700000000007000000070007070707007000000707007007070700000000000700000007000707070700700707070000000
70000000777070707000770070700700000000007000000007707070707007000700707007007070777000000000700000007770707077707770707077707770
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000007770077077707770700077700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000aa000
0000000077707070707007007000700000000000000444444444444444f440000000000000000000000000000000000000000000000000000000000000000000
00000000707070707700070070007700000000000000000000000000000000060000000000000000000000000000000000000000000000000000000000000000
00000000707070707070070070007000000000000000000000506050000000006666000000000000000000000000000000000000000000000000000000000000
00000000707077007770777077707770000000000000000000000000000000000000000000000000000000000000000000000000000020000000000090000000
00000000000000000000000000000000000000001800000000050000000000000000000000002000a0000000000000000000000000000000000000ccc0000700
66606000666066600660666000000660666066606660606066606660000066600000600066606660666060000000666066606660066066600000000000000000
60606000600060606000600000006000606060600600606060606000000060600000600060606060600060000000600006006060600006000000000000000000
66606000660066606660660000006000666066600600606066006600000066600000600066606600660060000000660006006600666006000000000000000000
60006000600060600060600000006000606060000600606060606000000060600000600060606060600060000000600006006060006006000000000000000000
60006660666060606600666000000660606060000600066060606660000060600000666060606660666066600000600066606060660006000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7000000088880020000000000000002000000000000000006a000000000000000000000000000010000000000000001000000000000000200000000000000020
07000000888800200000000000000000007c00000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000
00700000888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007320
07000000888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
70000000888800000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000ad000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00200000000000000000140000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10000000000f000000000000000000000000000000000000000000000000000000c1000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00001f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000fffefffeff000000000000000000000000000000000000000000000
000000000000000000000000000000ed0000000000000000000000000000020000000ffffffffffff00000000000000000000000000000070700000000000000
0000000000000000000000000000290000b30000000065000000000000000000000ffffffffffffffffff000000000000000000000000000008b000000000000
00000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffffffe000000000000d00000000000000000000000
000000000000000000000000000100000000000000000000000000000000000ffffffffffffffffffffffffff0fefb00000bbbbbbbbbbbbb1111100000000000
0000000000000000000000000000000000000000000030000000200000000effffffffffffffffffffffffffff0eeee000eeeee0009900000000000000000000
00000000000000000000000000000000000000000000000000ee20e0000eeffffffffffffffffffffffffffffffeeeeeffed0000000000000000000000000000
0000000000000000000000000000000000000000000000c90b00000edddffffffffffffffffffffffffffffffffffccccccccccccccc000000003a0000000000
000000000000000000f000000000000000000000000000000d00000d00fffffffffffffffffffffffffffffffffffffdfffdccccc000e0000000000000000000
00001400000000000000000000000000000000000000000000000eeeeeffffffffffffffffffffffffffffffffffff0000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000eeeeffffffffffffffffffffffffffffffffffffffeeeeeeeee000000000000000000000000
00000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffffffffffffffffffffddddddddd00000000000000000000000
0000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffffffffffffffffffffffffe0000000000000000000000000000
0000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffffffffffffffffffffff0000dde000000000000000000000000
0000000000000000000000000000000000000000000000dddd0000ffffffffffffffffffffffffffffffffffffffffffff0000000d0000000000000000000000
00000000ca00000000000000000000000000000000000000000000ffffffffffffffffffffffffffffffffffffffffffffff0000000000000000000000000000
00000000000000000000000000000000000000100000003eeee00ffffffffffffffffffffffffffffffffffffffffffffffddddddd0000000000000000000000
00000000000000000000000000000000000000000000000000000ffffffffffffffffffffffffffffffffffffffffffffffff000000000000000000000000000
00000000000000000000000000000000000000000000000000000ffffffffffffffffffffffffffffffffffffffffffffffcccccccccc0000000000000000000
00000000000000000010000000000000000000000000000000000ffffffffffffffffffffffffffffffffffffffffffffffddddddddddddddde4000000000000
000000000000000000000000000aa900000ccccccccc0c7e0cc0fffffffffffffffffffffffffffffffffffffffffffffffffe0ede00eeee0000000010000000
0000000000000000000008000000000000000000000000000000ffffffffffffffffffffffffffffffffffffffffffffffffe0e0d00000000000000000000000
00000000000000000000000000000000000000aaa000fefffffffffffffffffffffffffffffffffffffffffffffffffffffffeedde0000000000000000000000
0000000000000000000000000000000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffaaaaaaaaaaaaaaaabbb000000000
000000000000000000000000000000c000000abbfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe10fe0000000000000000000020
00000000000000000500001000cc1c0000dccaffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffeee00e00000000000000000000
00000000000000000000000000000000000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdddd00ddddd00000000000000000
00000008000000000000000000000000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0f0000000077700000000000000
0000000000000000b0bbbbbbbbbbb00be0fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff000000000000070000000000000
00000000000000000000001b0000000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0088008000708870800000000000
000000000000000000000000000000eeefffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000000000700070000000000000
0000000000000000000000000deeeeeeefffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000000000000000
0000000000000000000000000000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffeee00ffe000000000000000000000
0000000000000000000000000000eecffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffddddeee00000001010b0000000000
00d000000000000000000000000feeefffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffddd000000000000000000000000000
00000000000000000000000000000efffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000000111111111111111111100000
000000000000000000000000000feffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000000a20000000000100000000000
0000000000000000000000000000bfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffeeeeeeeeeeee00000111000000000000
0000000000000000dcccccc00000cfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffeeeeeee000e000000000000007000000
0000000000000000000000e00000efffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffeeeee000cbbbbbbbbbbbbbbb0000000000
000000000000000000dddddd000ddffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff000000000000000000000000000000000
0000900000000000000000dddddffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffddddd000000000000000000000000000000
0000000000000000d100000eeeeeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00eee0000000000000000000000000000000
0000000000000000000000ddeeeeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffeeee0e00000000000000000000001a00000000
00000000000000000000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff000000000000000000000000000000000000000
000000000000000000000000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00000000000000000000000000000000f00000000
0000000000000000000000ddddddffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe00000000000000000000000000000000000000000
000000000000000ccccccccccdeeffffffffffffffffffffffffffffffffffffffffffffffffffffffeeeeeee0000a0000000000000000000000000000000000
0000000000000000000000ccc0efffffffffffffffffffffffffffffffffffffffffffffffffeeeee00000000010000010000000000010000000000000000010
00001000000000bb00bbe0000000ffffffffffffffffffffffffffffffffffffffffffffffffe0ddd0fdd0000000000000000000001000001000000000001000
000000000000aaaaaaaaaaaaaaaaaffffffffffffffffffffffffffffffffffffffffffffff0e00000000b000000000000000000000000000000000000000000
000000000000cbccbbccbcccccccfffffffffffffffffffffffffffffffffffffffffffffff00000000000000000000000000000000000000000000000200000
0000001000000b00bb00b0cccc0efffffffffffffffffffffffffffffffffffffffffffffffeeeeeee0000000000000000000000000000000000000000000001
00001000000000bb000b00000ffffffffffffffffffffffffffffffffffffffffffffffffff00000000000000000000000000000000000000000000000000000
000000000000000000000000ffffffffffffffffffffffffffffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000
00000000000000000000000000000fffffffffffffffffffffffffffffffffffffffffffff000000000000000000000000000000200000000000000000000000
000000000000000d0000000000fff0fffffffffffffffffffffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000
0000000020000000000000000000000ffffffffffffffffffffffffffffffffffffffffff000000000000000000000000000000000006c000000000000000000
0000000000000000000000000000e0ffffffffffffffffffffffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000
000000000000000000000000000000fffffffffffffffffffffffffffffffffffffffffeee000000000000000000000000000000000000000000000000000000
0000000000000bbb0bbbbbbbbbbbbeeeffffffffffffffffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000dddfffffffffffffffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000
0000000000000000000000000edddddddddffffffffffffffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000eeeeffffffffffffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000
00000000a00000999888888888888888880e00ffffffffffffffffffffffffffffeeeeeee0000000000000000000000000000000000000000000000000000000
00000000000000a700b000000000000000e0000ffffffffffffffffffffffffffeddd00000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000ffffffffffffffffffffff60e00000000000000000000000000009900000000000000000000000000000000
000000000000000000000000000000eeeee00000dddffffffffffffffffffeeeeee0000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000ee000deffffffffffffffffff0e0000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000d00fddddddddddddddddddd00000000000000000000000000000000000000000000000000000000000000
00000000000000070000000000000000000000001a00ddd0000000000eee00000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000400040000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000cbbbbbbbbbbbbbbbbbb0000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000005400000000060000000000000000087800700000
000000000000000000000000000000000000000000000000000000000000000000000000000000e4000000000000000000000000000000004400807080700000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000807a80700000
6666666666666666666000000000000000000000a600000000000000000000000000000088666666666666666666677666006666600000666600800000000000
00066700000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050665000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000089000010000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000002000000000100000
00000000000000200000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000002000000000000000001c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000b00930000008100000000b500000000ee000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000e40000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000bf0000000000000000000000000000000000b30000000000000000000000000000000056000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000009000000000000000000000000000000000008777777777770000000000000000ec00000000000000000000000000000000

