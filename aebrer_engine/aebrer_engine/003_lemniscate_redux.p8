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
 local coin_toss = rnd(1)
 local factor = 0.0
 if coin_toss >= 0.5 then
  factor = -1
 else
  factor = 1
 end
 return(factor)
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
config.dither.loops = 2
config.dither.pull = 1.0
config.dither.rectw = 2
config.dither.recth = 2
config.dither.circ_r = 2
config.dither.x_loops = 12
config.dither.y_loops = 12
config.dither.fudge_factor = 4
config.dither.pxl_prob = 0.55

-- method params
config.dither.params = {
 {"cx", "int"},
 {"cy", "int"},
 {"loops", "int"},
 {"pull", "float"},
 {"rectw", "int"},
 {"recth", "int"},
 {"circ_r", "int"},
 {"x_loops", "int"},
 {"y_loops", "int"},
 {"fudge_factor", "int"},
 {"pxl_prob", "float_lim", {0.01, 1.0}}
}

-- dither functions
function config.dither.ovalfill_burn()
 local cx = config.dither.cx
 local cy = config.dither.cy
 local loops = config.dither.loops
 local pull = config.dither.pull
 local rect_w = config.dither.rectw
 local rect_h = config.dither.recth
 local x_loops = config.dither.x_loops
 local y_loops = config.dither.y_loops
 local fudge_factor = config.dither.fudge_factor

 for i=1,loops do 
  local fudge_x = (flr(rnd(fudge_factor)) + 1) * rnd_sign()
  local fudge_y = (flr(rnd(fudge_factor)) + 1) * rnd_sign()
  for x=64+fudge_x,-64,-x_loops do
   for y=64+fudge_y,-64,-y_loops do
    local pxl = rnd_pixel()
    local x = (pxl.x - cx)
    local y = (pxl.y - cy)
    c=pget(x,y)
    x = round(x*pull)
    y = round(y*pull)
    ovalfill(x-rect_w,y-rect_h,x+rect_w,y+rect_h,burn(c))
   end
  end
 end
end
add(config.dither.methods, "ovalfill_burn")


function config.dither.pset_burn()
 local cx = config.dither.cx
 local cy = config.dither.cy
 local loops = config.dither.loops
 local pull = config.dither.pull
 local x_loops = config.dither.x_loops
 local y_loops = config.dither.y_loops
 local fudge_factor = config.dither.fudge_factor

 for i=1,loops do 
  local fudge_x = (flr(rnd(fudge_factor)) + 1) * rnd_sign()
  local fudge_y = (flr(rnd(fudge_factor)) + 1) * rnd_sign()
  for x=64+fudge_x,-64,-x_loops do
   for y=64+fudge_y,-64,-y_loops do
    local pxl = rnd_pixel()
    local x = (pxl.x - cx)
    local y = (pxl.y - cy)
    c=pget(x,y)
    x = round(x*pull)
    y = round(y*pull)
    pset(x,y,burn(c))
   end
  end
 end
end
add(config.dither.methods, "pset_burn")

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
 local x_loops = config.dither.x_loops
 local y_loops = config.dither.y_loops
 local rect_w = config.dither.rectw
 local rect_h = config.dither.recth
 local circ_r = config.dither.circ_r
 local pxl_prob = config.dither.pxl_prob

 for i=1,loops do
  local dm = rnd(dither_modes)
  if dm == "circfill" then
   local fudge_x = (flr(rnd(fudge_factor)) + 1) * rnd_sign()
   local fudge_y = (flr(rnd(fudge_factor)) + 1) * rnd_sign()
   for x=64+fudge_x,-64,-x_loops do
    for y=64+fudge_y,-64,-y_loops do
     if rnd(1) > pxl_prob then
      local pxl = rnd_pixel()
      local x = (pxl.x - cx)
      local y = (pxl.y - cy)
      circfill(x,y,circ_r,0)
     end
    end
   end
  elseif dm == "rect" then
   local fudge_x = (flr(rnd(fudge_factor)) + 1) * rnd_sign()
   local fudge_y = (flr(rnd(fudge_factor)) + 1) * rnd_sign()
   for x=64+fudge_x,-64,-x_loops do
    for y=64+fudge_y,-64,-y_loops do
     if rnd(1) > pxl_prob then
      local pxl = rnd_pixel()
      local x = (pxl.x - cx)
      local y = (pxl.y - cy)
      rect(x-rect_w,y-rect_h,x+rect_w,y+rect_h,0)
     end
    end
   end
  elseif dm == "burn_spiral" then
   local pxl = rnd_pixel()
   local x = (pxl.x - cx)
   local y = (pxl.y - cy)
   c=pget(x,y)
   x = round(x*pull)
   y = round(y*pull)
   circ(x,y,circ_r,burn(c))
  elseif dm == "burn" then
   local fudge_x = (flr(rnd(fudge_factor)) + 1) * rnd_sign()
   local fudge_y = (flr(rnd(fudge_factor)) + 1) * rnd_sign()
   for x=64+fudge_x,-64,-x_loops do
    for y=64+fudge_y,-64,-y_loops do
     local pxl = rnd_pixel()
     local x = (pxl.x - cx)
     local y = (pxl.y - cy)
     c=pget(x,y)
     x = round(x*pull)
     y = round(y*pull)
     circ(x,y,circ_r,burn(c))
    end
   end
  elseif dm == "burn_rect" then
   local fudge_x = (flr(rnd(fudge_factor)) + 1) * rnd_sign()
   local fudge_y = (flr(rnd(fudge_factor4)) + 1) * rnd_sign()
   for x=64+fudge_x,-64,-x_loops do
    for y=64+fudge_y,-64,-y_loops do
     local pxl = rnd_pixel()
     local x = (pxl.x - cx)
     local y = (pxl.y - cy)
     c=pget(x,y)
     x = round(x*pull)
     y = round(y*pull)
     rect(x-rect_w,y-rect_h,x+rect_w,y+rect_h,burn(c))
    end
   end
  end
 end
end
add(config.dither.methods, "luna_theory")


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
config.colors.heatmap = {0,0,-15,1,-4,12,6,7,-9,10,9,-7,-2,8,-8}
add(config.colors.methods, "heatmap")
config.colors.heatmap_green = {0,0,-13,3,-5,-6,-9,7,-9,10,9,-7,-2,8,-8}
add(config.colors.methods, "heatmap_green")
config.colors.blue_white_green = {0,0,-13,3,-5,-6,-9,7,6,12,-4,1,-15,0,0}
add(config.colors.methods, "blue_white_green")
config.colors.yellow_orange_red = {0,-9,10,9,-7,-2,8,-8,0,-8,8,-2,-7,9,10}
add(config.colors.methods, "yellow_orange_red")
config.colors.black_green = {0,0,-13,3,-5,-6,-9,7,-9,-6,-5,3,-13,0,0}
add(config.colors.methods, "black_green")
config.colors.black_blue = {0,0,-15,1,-4,12,6,7,6,12,-4,1,-15,0,0}
add(config.colors.methods, "black_blue")
config.colors.purple_white_blue = {0,0,-15,1,-4,12,6,7,14,13,-3,2,-11,-14,0}
add(config.colors.methods, "purple_white_blue")
config.colors.purple_white_green = {0,0,-13,3,-5,-6,-9,7,14,13,-3,2,-11,-14,0}
add(config.colors.methods, "purple_white_green")
config.colors.pnk_prpl_rd_yllw = {0,-9,10,9,-7,-2,8,-8,-14,-11,2,-3,13,14,7}
add(config.colors.methods, "pnk_prpl_rd_yllw")
config.colors.mono_loops = {0,5,6,7,7,6,5,0,0,5,6,7,7,6,5}
add(config.colors.methods, "mono_loops")
config.colors.mono_red_highlight = {0,5,6,7,7,6,5,-8,-8,5,6,7,7,6,5}
add(config.colors.methods, "mono_red_highlight")
config.colors.mono_blue_highlight = {0,5,6,7,7,6,5,-4,-4,5,6,7,7,6,5}
add(config.colors.methods, "mono_blue_highlight")
config.colors.mono_dgreen_highlight = {0,5,6,7,7,6,5,-13,-13,5,6,7,7,6,5}
add(config.colors.methods, "mono_dgreen_highlight")
config.colors.twobit_bw = {7,0,0,0,7,0,0,7,0,7,7,0,7,7,7}
add(config.colors.methods, "twobit_bw")
config.colors.default = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15}
add(config.colors.methods, "default")
config.colors.alt_default = {-15,-14,-13,-12,-11,-10,-9,-8,-7,-6,-5,-4,-3,-2,-1}
add(config.colors.methods, "alt_default")

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
config.brush.color = #config.colors[config.colors.methods[config.colors.i]]

config.brush.params = {
 {"circ_r", "int"},
 {"color", "int"}
}

-- brush functions
function config.brush.circfill(x,y)
 local c = config.brush.color
 local r = config.brush.circ_r
 circfill(x,y,r,c)
end 
add(config.brush.methods, "circfill")

function config.brush.circ(x,y)
 local c = config.brush.color
 local r = config.brush.circ_r
 circ(x,y,r,c)
end 
add(config.brush.methods, "circ")

--------------------------------
--         effects            --
--------------------------------

config.effects = {}
add(config.params, "effects")
config.effects.methods = {}
config.effects.i = 1
config.effects.params = {}
config.effects.param_i = 1

config.effects.noise_amt = 0
config.effects.glitch_freq = 0
config.effects.enable_all = false

config.effects.params = {
 {"enable_all", "bool"},
 {"noise_amt", "int"},
 {"glitch_freq", "int"}
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

--------------------------------
--          timing            --
--------------------------------

config.timing = {}
add(config.params, "timing")
config.timing.methods = {}
config.timing.i = 1
config.timing.params = {}
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

config.timing.params = {
 {"loop_len", "int_lim", {1,16}},
 {"loop_div", "int_lim", {1,16}},
 {"rec_loop_start", "int_lim", {1,7}},
 {"rec_loop_end", "int_lim", {2,8}},
 {"loop_counter", "null"},  -- resets to zero when scrolled
 {"gif_record", "bool"} 
}

function config.timing.standard_loop() 
 return (t())%(config.timing.loop_len/config.timing.loop_div)/(config.timing.loop_len/config.timing.loop_div) 
end
add(config.timing.methods, "standard_loop")


--------------------------------
--     change trackers        --
--------------------------------
param_i_changed = false
param_method_changed = false
param_param_changed = false
ppv_changed = false
display_params = false
display_params_changed = false
prev_gif_record = false

--------------------------------
--  sketch specific override  --
--------------------------------

config.dither.i = 2
config.dither.loops = 2
config.dither.rectw = 9
config.dither.recth = 0
config.dither.circ_r = 1
config.dither.x_loops = 8
config.dither.y_loops = 8
config.dither.fudge_factor = 13
config.dither.pxl_prob = 0.266
config.dither.pull = 0.975

config.effects.enable_all = true
config.effects.noise_amt = 4
config.effects.glitch_freq = 10

config.brush.i = 2
config.brush.circ_r = 23
config.brush.lem_width = 23
add(config.brush.params, {"lem_width", "int"})
config.brush.lem_points = 1
add(config.brush.params, {"lem_points", "int_lim", {1,100}})

config.timing.loop_len = 12
config.timing.rec_loop_start = 2
config.timing.rec_loop_end = 3

--------------------------------
--        main loop           --
--------------------------------
::_:: 

--------------------------------
--       input detect         --
--------------------------------
if display_params then
 if stat(34) == 1 or btn(0) then
  lmbp = true
 else
  lmbp = false
 end

 if stat(34) == 2 or btn(1) then
  rmbp = true
 else
  rmbp = false
 end

 if stat(34) == 4 or btn(5) then
  mmbp = true
 else
  mmbp = false
 end

 if stat(36) == -1 or btn(3) then
  scrl_dn = true
 else
  scrl_dn = false
 end

 if stat(36) == 1 or btn(2) then
  scrl_up = true
 else
  scrl_up = false
 end

 --------------------------------
 --       input process        --
 --------------------------------
 -- change what method is being used for active param
 if lmbp and not param_method_changed then
  local idx = config.params[config.param_i]
  config[idx].i = safe_inc(config[idx].i, #config[idx].methods)
  param_method_changed = true
 end

 -- cycle through the changable parameters
 if rmbp and not param_i_changed then
  config.param_i = safe_inc(config.param_i, #config.params)
  param_i_changed = true
 end

 if mmbp and not param_param_changed then
  local curr_param_param_idx = config[config.params[config.param_i]].param_i
   if curr_param_param_idx != nil then
   local param = config[config.params[config.param_i]]
   local new_param_i = safe_inc(param.param_i, #param.params)
   config[config.params[config.param_i]].param_i = new_param_i
   param_param_changed = true
  end
 end

 if scrl_dn and not ppv_changed then
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
   ppv_changed = true
  end
 end

 if scrl_up and not ppv_changed then
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
   elseif curr_pp_type == "float_lim" then
    local curr_pp_lim = config[config.params[config.param_i]].params[curr_param_param_idx][3]
    local low_lim = curr_pp_lim[1]
    local high_lim = curr_pp_lim[2]
    new_param_param_value = curr_param_param_value * 1.03
    new_param_param_value = min(new_param_param_value, high_lim)
    new_param_param_value = max(new_param_param_value, low_lim)
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
   ppv_changed = true
  end
 end



 --------------------------------
 --       input reset          --
 --------------------------------
 if not lmbp and param_method_changed then
  param_method_changed = false
 end
 if not rmbp and param_i_changed then
  param_i_changed = false
 end
 if not mmbp and param_param_changed then
  param_param_changed = false
 end
 if not (scrl_dn or scrl_up) and ppv_changed then
  ppv_changed = false
 end
end

 --------------------------------
 --       debug menu          --
 --------------------------------

if btn(4) then
 zbp = true
else 
 zbp = false
end

if zbp and not display_params_changed then 
 display_params = not display_params
 display_params_changed = true
end

if not zbp and display_params_changed then 
 display_params_changed = false
end

--------------------------------
--          timing            --
--------------------------------

local timing_name = config.timing.methods[config.timing.i]
local timing_func = config.timing[timing_name]
local timing = timing_func()
local timing_zero = config.timing.timing_zero
local loop_counter = config.timing.loop_counter

if timing <= 0.01 and not timing_zero then
 config.timing.timing_zero = true
end

if timing > 0.01 and timing_zero then
 config.timing.timing_zero = false
 config.timing.loop_counter += 1
 srand(seed)
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
local palette = config.colors[palette_name]


--------------------------------
--       setup brushes        --
--------------------------------

-- -- mouse controls
-- local x = stat(32) - 64
-- local y = stat(33) - 64

local brush_name = config.brush.methods[config.brush.i]
local brush_func = config.brush[brush_name]

local x = 0 
local y = 0 
local lem_width = config.brush.lem_width
local lem_points = config.brush.lem_points

for i=0,lem_points do
 x=sin(timing+i)*(lem_width+i)
 y=(cos(timing+i)*sin(timing+i))*(lem_width+i)
 brush_func(x,y)
 brush_func(-x,-y)
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


 ?"\#1"..current_param_name..": "..current_method_name.." <- ➡️,⬅️",-60,-60,pr_col

 local curr_param_param_idx = config[config.params[config.param_i]].param_i
 if curr_param_param_idx != nil then
  local curr_param_param_name = config[config.params[config.param_i]].params[curr_param_param_idx][1]
  local curr_param_param_value = config[config.params[config.param_i]][curr_param_param_name]
  ?"\#1"..curr_param_param_name..": "..tostr(curr_param_param_value).." <- 🅾️/x key, ⬇️⬆️",-60,-53,pr_col
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
