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
 local new_c = max(abs(c-1),1)
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
config.dither.x_loops = 12
config.dither.y_loops = 12
config.dither.fudge_factor = 4

-- method params
config.dither.params = {
 {"cx", "int"},
 {"cy", "int"},
 {"loops", "int"},
 {"pull", "float"},
 {"rectw", "int"},
 {"recth", "int"},
 {"x_loops", "int"},
 {"y_loops", "int"},
 {"fudge_factor", "int"}
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
    local x = (pxl.x - cx) * pull
    local y = (pxl.y - cy) * pull
    c=pget(x,y)
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

 for i=1,loops do 
  local fudge_x = (flr(rnd(2)) + 1) * rnd_sign()
  local fudge_y = (flr(rnd(2)) + 1) * rnd_sign()
  for x=64+fudge_x,-64,-x_loops do
   for y=64+fudge_y,-64,-y_loops do
    local pxl = rnd_pixel()
    local x = (pxl.x - cx) * pull
    local y = (pxl.y - cy) * pull
    c=pget(x,y)
    pset(x,y,burn(c))
   end
  end
 end
end
add(config.dither.methods, "pset_burn")

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
config.colors.heatmap = {0,0,0,-15,1,-4,12,6,7,-9,10,9,-7,-2,8,-8}
add(config.colors.methods, "heatmap")
config.colors.heatmap_green = {0,0,0,-13,3,-5,-6,-9,7,-9,10,9,-7,-2,8,-8}
add(config.colors.methods, "heatmap_green")
config.colors.blue_white_green = {0,0,0,-13,3,-5,-6,-9,7,6,12,-4,1,-15,0,0}
add(config.colors.methods, "blue_white_green")
config.colors.yellow_orange_red = {0,-9,10,9,-7,-2,8,-8,0,-8,8,-2,-7,9,10,-9}
add(config.colors.methods, "yellow_orange_red")
config.colors.black_green = {0,0,0,-13,3,-5,-6,-9,7,-9,-6,-5,3,-13,0,0}
add(config.colors.methods, "black_green")
config.colors.black_blue = {0,0,0,-15,1,-4,12,6,7,6,12,-4,1,-15,0,0}
add(config.colors.methods, "black_blue")
config.colors.purple_white_blue = {0,0,0,-15,1,-4,12,6,7,14,13,-3,2,-11,-14,0}
add(config.colors.methods, "purple_white_blue")
config.colors.purple_white_green = {0,0,0,-13,3,-5,-6,-9,7,14,13,-3,2,-11,-14,0}
add(config.colors.methods, "purple_white_green")
config.colors.pnk_prpl_rd_yllw = {0,-9,10,9,-7,-2,8,-8,0,-14,-11,2,-3,13,14,7}
add(config.colors.methods, "pnk_prpl_rd_yllw")
config.colors.mono_loops = {0,5,6,7,7,6,5,0,0,5,6,7,7,6,5,0}
add(config.colors.methods, "mono_loops")
config.colors.mono_red_highlight = {0,5,6,7,7,6,5,-8,-8,5,6,7,7,6,5,0}
add(config.colors.methods, "mono_red_highlight")
config.colors.mono_blue_highlight = {0,5,6,7,7,6,5,-4,-4,5,6,7,7,6,5,0}
add(config.colors.methods, "mono_blue_highlight")
config.colors.mono_dgreen_highlight = {0,5,6,7,7,6,5,-13,-13,5,6,7,7,6,5,0}
add(config.colors.methods, "mono_dgreen_highlight")


--------------------------------
--         brushes            --
--------------------------------
brush_size = 6
brush_changed = false

--------------------------------
--         effects            --
--------------------------------


--------------------------------
--     change trackers        --
--------------------------------
param_i_changed = false
param_method_changed = false
param_param_changed = false
ppv_changed = false
display_params = true
display_params_changed = false


--------------------------------
--        main loop           --
--------------------------------
::_:: 

--------------------------------
--       input detect         --
--------------------------------
if stat(34) == 1 then
 lmbp = true
else
 lmbp = false
end

if stat(34) == 2 then
 rmbp = true
else
 rmbp = false
end

if stat(34) == 4 then
 mmbp = true
else
 mmbp = false
end

if stat(36) == -1 then
 scrl_dn = true
else
 scrl_dn = false
end

if stat(36) == 1 then
 scrl_up = true
else
 scrl_up = false
end

if btn(4) then
 zbp = true
else 
 zbp = false
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
   new_param_param_value = curr_param_param_value * 0.95
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
   new_param_param_value = curr_param_param_value * 1.05
  end
  config[config.params[config.param_i]][curr_param_param_name] = new_param_param_value
  ppv_changed = true
 end
end

if zbp and not display_params_changed then 
 display_params = not display_params
 display_params_changed = true
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
if not zbp and display_params_changed then 
 display_params_changed = false
end


--------------------------------
--       do dithering         --
--------------------------------
local dither_name = config.dither.methods[config.dither.i]
local dither_func = config.dither[dither_name]
dither_func()

--------------------------------
--       setup palette        --
--------------------------------
local palette_name = config.colors.methods[config.colors.i]
local palette = config.colors[palette_name]


--------------------------------
--       setup brushes        --
--------------------------------
local x = stat(32) - 64
local y = stat(33) - 64
local c = #palette-1
circfill(x,y,brush_size,c)


--------------------------------
--       onscreen gui         --
--------------------------------
if display_params then
 -- get a safe print color
 local pr_col = 2
 while palette[pr_col] == palette[1] do
  pr_col += 1
 end

 local current_param_name = config.params[config.param_i]
 local current_method_idx = config[current_param_name].i
 local current_method_name = config[current_param_name].methods[current_method_idx]


 ?current_param_name..": "..current_method_name,-60,-60,pr_col

 local curr_param_param_idx = config[config.params[config.param_i]].param_i
 if curr_param_param_idx != nil then
  local curr_param_param_name = config[config.params[config.param_i]].params[curr_param_param_idx][1]
  local curr_param_param_value = config[config.params[config.param_i]][curr_param_param_name]
  ?curr_param_param_name..": "..curr_param_param_value,-60,-53,pr_col
 end
end


flip()
pal(palette, 1) 

goto _
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
