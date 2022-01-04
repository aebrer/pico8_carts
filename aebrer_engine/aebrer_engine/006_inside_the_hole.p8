pico-8 cartridge // http://www.pico-8.com
version 34
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

config.sketch.hole_r = 43
config.sketch.cloud_translate = 150
config.sketch.demon_rate = 0.9
config.sketch.glitch_rate = 0.7

config.sketch.params = {
 {"hole_r", "int"},
 {"cloud_translate", "int"},
 {"demon_rate", "float_fine", {0.01,1.0}},
 {"glitch_rate", "float_fine", {0.01,1.0}}
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

function config.sketch.hole() 
 local t = config.timing.time
 local r = config.sketch.hole_r
 local r2=r*r
 for j=-64,63 do
  local y=-j
  local x=sqrt(max(r2-y*y))
  rectfill(-64,j,-x,j,0)
  rectfill(x,j,63,j,0)
 end

 if t > config.sketch.demon_rate then  -- demon
  ?"\^phelp me",rnd(128)-64,rnd(128)-64,flr(rnd(15))+1
 end
end


function config.sketch.clouds()
 
 -- original cloud code from @von_rostock
 -- https://twitter.com/von_rostock/status/1114960244327763968?s=20
 -- fillp(▒\1)
 -- local t = config.timing.time
 local t = t()/10
 local hole_r = config.sketch.hole_r
 for y=-hole_r,hole_r do
  x=rnd(hole_r)*rnd_sign()
  u=(x-64)*64/(config.sketch.cloud_translate-y*2)+t
  v=t+y*y/64
  a=0
  f=.005
  g=f
  c=.5
  for b=1,3 do
   f*=2
   g*=4
   c*=.7
   a+=c*sin(f*u+sin(g*v/2)/2)+c*sin(g*v+sin(g*u/2)/3)
  end
  if(a<.2)a=12
  if(a<.4)a=6
  if(a<5)a=7
  circfill(x,y,rnd(3),a)
 end
end


function config.sketch.col_checker(col) 
 local banned_cols = {
  14,15,16,17,18,19,24,25,26,27,
  28,29,30,31,32,33
 }
 local banned = false
 for i in all(banned_cols) do 
  if (col == i) banned = true
 end
 return banned
end


function config.sketch.entity()
 local t = config.timing.time
 local dx = -10
 local dy = config.sketch.hole_r - 18
 if t > config.sketch.demon_rate then  -- demon
  sspr(46,11,20,23,dx,dy-3)
  local new_col_i = flr(rnd(#config.colors.methods))+1
  while config.sketch.col_checker(new_col_i) do 
   new_col_i = flr(rnd(#config.colors.methods))+1
  end
  
  config.colors.i = new_col_i
 
 else  -- preist
  sspr(15,14,20,20,dx,dy)
 end

 -- glitch buildup effect
 if t > config.sketch.glitch_rate then  -- demon
  config.effects.enable_all = true
 else  -- preist
  config.effects.enable_all = false
 end

end

-- add layers in order
add(config.sketch.methods, "clouds")
add(config.sketch.methods, "entity")
add(config.sketch.methods, "hole")
add(config.sketch.methods, "mouse_brush")

-- overrides:
--  brush:
config.brush.i = 9
config.brush.circ_r = 35
config.brush.wiggle = 1
config.brush.mouse_ctrl = false
config.brush.color = 12

--  dither:
config.dither.i = 2
config.dither.loops = 0
config.dither.recth = 0
config.dither.rectw = 0
config.dither.circ_r = 1

--  palettes/colors:
config.colors.i = 34

-- effects 
config.effects.glitch_freq = 1

-- timing
config.timing.seed_loop = false
config.timing.loop_len = 16

-- misc


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
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000cccccccccceccccc00000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000666ccc7cccc7cce6cc06cc000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000610666cc6677c867c666ccccccccc70000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000666666c676c67776677c877ccccc770097000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000661066cc6c7ccce7ccc6cce6c707c77c7c7c008c00000000000000000000000000000000000000000000
00000000000000000000000000000000000000000006cccc6cec6cccccccccecccecccc7cce7ccccc0ec00000000000000000000000000000000000000000000
00000000000000000000000000000000000000000c0cccccccc6cc06ccccccccccecccccccccc0ccc0ecc0c00000000000000000000000000000000000000000
0000000000000000000000000000000000000000cc1cccccccccccccccccccccccccccdcccccccccccdccccc0000000000000000000000000000000000000000
00000000000000000000000000000000000000006cccccccccccccdcccccccdcccecccccccdcccccccccccdccc00000000000000000000000000000000000000
0000000000000000000000000000000000000cc0ccc0ccccccccccdcccccccccccdccccccccccceccccccccc00c0000000000000000000000000000000000000
000000000000000000000000000000000000cccccccc77eccccc77cc77ec777ccc8cccaccccccccccccccccccccc000000000000000000000000000000000000
00000000000000000000000000000000000ccc20cccccccc77cc77ccccc77ce77c977cccc6ecc6ccccccc0ecc0ecc00000000000000000000000000000000000
0000000000000000000000000000000000cccccccceccccc67ccccecccc777777c877cc7cccccceccccccccccccccc0000000000000000000000000000000000
000000000000000000000000000000000ccccccccccc77cc77dc77dc77dc77667c66c7777777c6ccccdcccccccc600c000000000000000000000000000000000
00000000000000000000000000000000cccccceccccccccc77ccc776c6867786776677a777a7777ccc7cdc7c7c66666600000000000000000000000000000000
0000000000000000000000000000000cccccccccccccccccccccccecccc6666c7ccc777777777777778777c777c6666600000000000000000000000000000000
000000000000000000000000000000ccccccccccccdcecececcccccc6ccc6ccccccccccc6c7777777ccc77767cc600c600000000000000000000000000000000
000000000000000000000000000000cccceccc0cccccccccccccccccccc66cc6ccccccccc7cccccccccccc7ccc66ccc600000000000000000000000000000000
00000000000000000000000000000c10ccccccccc6dcc6ccccccccdccccccccccccccccccccccccccccccccccccccccc00c00000000000000000000000000000
0000000000000000000000000000ccccccecccc6ccccccdccc06cccccccccccccccccceccccccccccccccccccccc00ec006c0000000000000000000000000000
0000000000000000000000000000ccccc60c660c66cc6c66c676c66cccccccccccecccccccdcccccccccccdccccccccc00ec0000000000000000000000000000
00000000000000000000000000066616666c66ccc6ecc66c666ccc6cccccccccccccccccccccccccccccccccccdcccccc0dcc000000000000000000000000000
00000000000000000000000000776cc666e6666c766c6c6c6cd76ccccccccccccccccc0cccccccccccdcccccccccccccccdccc00000000000000000000000000
00000000000000000000000000777cc66666666666cccccc6cec6cccccccccccccccccccccdcccccccccccdccccccccccccccc00000000000000000000000000
000000000000000000000000077776cc6666666ccccccccccceccc0cccccccccccccccccccccccccccdcccccccdcccccccdc00d0000000000000000000000000
00000000000000000000000007777cc667c667ccccccccdcccecccccccccccccccccccecccccccccccdcccccccccccdcccccccc0000000000000000000000000
0000000000000000000000000777ccc6ccd6ccecccccccc6ccc6ccccccccccccccccccccccecccccccdccceccccccccccccc0cc0000000000000000000000000
000000000000000000000000ccccccdccccccccccccccccccccccceccccccccccccccccccceccc0cccecccdcccecccccccdc000c000000000000000000000000
000000000000000000000000cccccccccceccccccccccccccccccccccccccccccceccc0cccccccccccdccccccccccccccceccccc000000000000000000000000
000000000000000000000000cc10ccccccdccc0ccccccc6ccc7cccccccccccccccdcccccccecccccccdccceccccccccccccccccc000000000000000000000000
00000000000000000000000cccccccdccccccccc66dc666cccccccdcccccecccccccc6ccccc777cccc7cccccccccccccccecc0cdc00000000000000000000000
00000000000000000000000cccccccccccccccccccccccecccccccccccdccccccccccceccc777776cc86ccccccccccdccccccccc000000000000000000000000
00000000000000000000000ccc0cccccccccccdccccccccccccccccccccc66cccccc666666777776cc76cc76ccccdcccccecccccc00000000000000000000000
0000000000000000000000ccccccccccccdcccccccecccccccccccccccccccccccdcc66666777776c68cc666cc86ccccccdccccccc0000000000000000000000
0000000000000000000000ccccccccccccccccccccccccdcccdcccccccecccccccdc670c677777666686666c8cccccdcccdccccc000000000000000000000000
0000000000000000000000ccccccccccccdcccecccccccccccccccccccccc6ccc6ecc666777677666676668666ccccccccdccccccc0000000000000000000000
0000000000000000000000ccccccccccccccccccccdccccccccccceccccccccc6ccc6cc77777669766866666cc86cccccccccccccc0000000000000000000000
0000000000000000000000ccccccccccccecccccccccccdcccdcccccccdccccc66ec660c667777766696666ccc66cc66cccccccc000000000000000000000000
0000000000000000000000ccccdccccccccccceccccccccccceccccccccc66cc66ec66776787677766777ccccccccccccceccccccc0000000000000000000000
0000000000000000000000ccccccccdcccccccccccdccccccceccc0cccecccec670c677766676677677777ccccccccccccccccdccc0000000000000000000000
000000000000000000000000ccccccccccccccccccccccccccdcccccccecccccc6cc66ec66668777777777ccccccccdcccdccccc000000000000000000000000
0000000000000000000000ccccecccccccccccccccccccccccdcccdcdcccccdccceccc77668766766777778ccccccccccccccccccc0000000000000000000000
0000000000000000000000ccccccecccccccecccccccccccccccccccccccccccc7ecc7777766668666777767cc67cccccceccc0cccc000000000000000000000
0000000000000000000000106666ccccccccccccccccccdcccecccccccdcccccc7cc76ec7666667766676677ccccccdcccdccccc000000000000000000000000
0000000000000000000000c6cccccccccccccc0cccccccccccccccccccccccdcccccec776687666777777797777cccccccdccccccc0000000000000000000000
0000000000000000000000c6666ccc8ccceccccccceccceccceccccccccccccccceccc6776667786779667c766e7666ccc6cc07cc00000000000000000000000
00000000000000000000002066ccccccccdcccccccccccdcccecccccccccccccccecc6ecc66ccc67668766777776cc86cc86cccc000000000000000000000000
0000000000000000000000cc77cc7777ccdccc0ccccccceccc0cccccccccccdcccccccccccdcccc677c666c666766666cc86cccccc0000000000000000000000
0000000000000000000000cccccc77777ccccccccccccccccccccccccccccccccccccccccccc77cc77ec776666766666cc66cc76cc0000000000000000000000
000000000000000000000020cccc77777c77ccccdcccccccccccccccccecccccccccccdccccccccc76dc7666666cc68cc676cccc000000000000000000000000
0000000000000000000000ccc7cc77777c97ccb7cccccccccccccccccccccceccceccccccccccccc76dc660c6ccccc66cc86cccccc0000000000000000000000
0000000000000000000000cccccc67776c876c77cc87ccccccccccccccccccccccdccccccccc76ec76dc76666ccccc66cc86cca6cc0000000000000000000000
000000000000000000000000ccccccc6ccc6ccccccccccdcccccccccccdcccccccdccc0cccccccccccccccc6cccccc66cc7ccccc000000000000000000000000
000000000000000000000006cc06ccccccecccccccccccccccccccccccccccccccccccccccecccccccdccc0cccccccccccccccccc00000000000000000000000
00000000000000000000000ccccccccccccccccccccccccccceccc0cccccccccccec6c6cccccccecccecccccccccccccccccc0dcc00000000000000000000000
000000000000000000000000cccccceccc0cccccccccccdcccccccccccecccccccccccccccccccccccdccccccccccccccccccccc000000000000000000000000
000000000000000000000000ccc0cccccceccceccccccccccccccccccccccccccccccc6ccc6cccccccdcccccccccccccccdccccc000000000000000000000000
000000000000000000000000ccccccccccdcccccccccccccccccccdcccccccccccdcccccccccccdcccccccccccccccccccdc00ec000000000000000000000000
0000000000000000000000000cccccccccdcccccccccccdcccccccccccecccc66cd6cc06cccc6cccccecccccccccccccccccccc0000000000000000000000000
0000000000000000000000000ccccccccccccccccccccccccceccccccccc6ccc6ce66cccccc66cccccccccccccccccccccecccc0000000000000000000000000
0000000000000000000000000cccccecccdcccccccdccccccceccccdccccccccc6dcc6c6666ccccccccccccccceccccccccc00d0000000000000000000000000
00000000000000000000000000ccccccccdcccccccccecdccccccccccceccccc6cec6c0c6c866cccccecccccccccccdccceccc00000000000000000000000000
0000000000000000000000000000ccccccdcccecccccccccccccccccccdccc0cccdccc6666866666cc66cc76cccccccccceccc00000000000000000000000000
000000000000000000000000000ccc1cccecccccccccccccccdcccccccccccccc6ecc6eccccc7ccc76e67cccccccccccc0ec0000000000000000000000000000
0000000000000000000000000000c0ccccdcccccccccccecccdcccccccccccccccccccecccccccc66cd66ccccccc00dc00dc0000000000000000000000000000
0000000000000000000000000000cc6ccc6ccc6cccccdcccccccccccccccccccccccccccccccccccccccccccccccccdc00ec0000000000000000000000000000
00000000000000000000000000000c20cc8ccccccccccccccccccceccccccccccceccccccccc6ccc6cdc6cccccdcccc000e00000000000000000000000000000
00000000000000000000000000000067cc87ccccccccccecccccccccc0ccc000000ccc0dccccccccc6dcc6cccccc00dc00000000000000000000000000000000
00000000000000000000000000000077cc77cc77cccccceccccccccccccc0000000cccccccccccccccdcccecccccccc600000000000000000000000000000000
00000000000000000000000000000000777cccccccdccccccceccc0dccc0000000000cccccccccccccecccccccdccccc00000000000000000000000000000000
000000000000000000000000000000007777ccccccccccccccccccccc0ecc000000ccc0ccccccccccceccccccccc00cc00000000000000000000000000000000
000000000000000000000000000000000777cc20cccccccccccccccccccc0000000cccccccccccccccdccceccccccc6000000000000000000000000000000000
000000000000000000000000000000000077ccccccdcccccccccccecccccc0000000cccccccccccccccccccc00ec000000000000000000000000000000000000
000000000000000000000000000000000000ccccccccccdcccccccccccecc0000000cc11cccccccc66dc6666cccc000000000000000000000000000000000000
000000000000000000000000000000000000cc20cccccccccccccccccccc00000000ccccccecccccc6e666666c66000000000000000000000000000000000000
0000000000000000000000000000000000000ccccceccccccccccc0ccccccc000010cccccccc66ec666666660060000000000000000000000000000000000000
00000000000000000000000000000000000000ccccccccecccccccccccccc0000000cc00cccccc66667666666c00000000000000000000000000000000000000
0000000000000000000000000000000000000000ccc0cccccceccccccc000000000000ccccdcccc666e666660000000000000000000000000000000000000000
00000000000000000000000000000000000000000c20ccccccecc00dc00000000000000ccccc6ccc6cc76c700000000000000000000000000000000000000000
0000000000000000000000000000000000000000000c772c77e7777cc000000000000000cccccc67608760000000000000000000000000000000000000000000
000000000000000000000000000000000000000000006c77777777770000000000000000c70666e700e700000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000c766c700c7000000000000000066666666000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000006206660006000000000c60006666660000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000066000c0000000000ccc000660000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000c0c0000000000c000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

