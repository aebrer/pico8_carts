pico-8 cartridge // http://www.pico-8.com
version 32
__lua__

camera(-64,-64)
_set_fps(60)

debug_out_file = 'out.txt'
debug = {}

function debug.tstr(t, indent)
 indent = indent or 0
 local indentstr = ''
 for i=0,indent do
  indentstr = indentstr .. ' '
 end
 local str = ''
 for k, v in pairs(t) do
  if type(v) == 'table' then
   str = str .. indentstr .. k .. '\n' .. debug.tstr(v, indent + 1) .. '\n'
  else
   str = str .. indentstr .. tostr(k) .. ': ' .. tostr(v) .. '\n'
  end
 end
  str = sub(str, 1, -2)
 return str
end

function debug.print(...)
 printh("\n", debug_out_file)
 for v in all{...} do
  if type(v) == "table" then
   printh(debug.tstr(v), debug_out_file)
  elseif type(v) == "nil" then
    printh("nil", debug_out_file)
  else
   printh(v, debug_out_file)
  end
 end
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

function dither(cx,cy,loops,pull)

 for i=loops,1,-1 do 

  local rect_width = 2

  local pxl = rnd_pixel()
  pxl.x += cx
  pxl.y += cy
  c=pget(pxl.x,pxl.y)
  x = pxl.x * pull
  y = pxl.y * pull
  rect(x-rect_width,y-rect_width,x+rect_width,y+rect_width,burn(c))
  rect(-x-rect_width,-y-rect_width,-x+rect_width,-y+rect_width,burn(c))
  rect(x-rect_width,-y-rect_width,x+rect_width,-y+rect_width,burn(c))
  rect(-x-rect_width,y-rect_width,-x+rect_width,y+rect_width,burn(c))

  pxl = rnd_pixel()
  pxl.x += cx
  pxl.y += cy
  c=pget(pxl.x,pxl.y)
  x = pxl.x * pull
  y = pxl.y * pull
  local pt = rotate(normal_a,0,0,x,y)
  circfill(pt[1],pt[2],circ_r,burn(c))
  circfill(-pt[1],-pt[2],circ_r,burn(c))
  circfill(pt[1],-pt[2],circ_r,burn(c))
  circfill(-pt[1],pt[2],circ_r,burn(c))


  -- circfill(x,y,2,burn(c))

 end
end

function burn(c)
 local new_c = max(abs(c-1),1)
 return new_c
end

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

function next_color(direc)
 col_i += direc
 if col_i > #all_colors then
  col_i = 1
 end
 if col_i < 1 then
  col_i = #all_colors
 end
end

function drw_halo(x,y,rad,a,c)

 local points = {}
 for i=360,-120,-15 do
  local tpx = cos(i/360.0) * rad --+ (rnd(1)*rnd_sign())
  local tpy = sin(i/360.0) * rad --+ (rnd(1)*rnd_sign())
  add(points, {flr(tpx)+x,flr(tpy)+y})
 end

 local ready = false
 for i=#points,2,-1 do
  local pt_i = points[i]
  local pt_im1 = points[i-1]
  pt_i = rotate(a,x,y,pt_i[1],pt_i[2])
  if ready then
  line(pt_i[1], pt_i[2], pt_im1[1], pt_im1[2], c)
  -- pset(pt_i[1], pt_i[2],c)

  end
  ready = true
 end
 
end


loop_l = 12
loop_counter = 0
oa_zero = false

circ_r = 1
big_circ_r = 20
huge_circ_r = 1


all_colors = {
 0,0,0,-15,1,-4,12,6,7,-9,10,9,-7,-2,8,-8,
 0,0,0,-13,3,-5,-6,-9,7,-9,10,9,-7,-2,8,-8,
 0,0,0,-13,3,-5,-6,-9,7,6,12,-4,1,-15,0,0,
 0,-9,10,9,-7,-2,8,-8,0,-8,8,-2,-7,9,10,-9,
 0,0,0,-13,3,-5,-6,-9,7,-9,-6,-5,3,-13,0,0,
 0,0,0,-15,1,-4,12,6,7,6,12,-4,1,-15,0,0,
 0,0,0,-15,1,-4,12,6,7,14,13,-3,2,-11,-14,0,
 0,0,0,-13,3,-5,-6,-9,7,14,13,-3,2,-11,-14,0,
 0,-9,10,9,-7,-2,8,-8,0,-14,-11,2,-3,13,14,7,
 0,5,6,7,7,6,5,0,0,5,6,7,7,6,5,0
}

function cycle_colors()
 col_i = stat(94)%#all_colors
 if old_col_i != col_i then
  curr_cols = {}
  for i=col_i,col_i+17 do
   add(curr_cols, all_colors[i])
  end
  pal(curr_cols, 1)
 end
 old_col_i = col_i
 return curr_cols
end

cols = cycle_colors()
cls(1)

-- stat(90) -> year, e.g. 2018
-- stat(91) -> month of year, 1-12
-- stat(92) -> day of month, 1-31
-- stat(93) -> hour of day, 0-23
-- stat(94) -> minute of hour, 0-59
-- stat(95) -> second, 0-61 (usually 0-59, see note below)




::_:: 

cols = cycle_colors()

-- if btn(4) then
--  --z/🅾️ button
--  z_button_pressed = true
-- else
--  z_button_pressed = false
-- end

-- if btn(5) then
--  x_button_pressed = true
-- else
--  x_button_pressed = false
-- end


-- if (z_button_pressed or x_button_pressed) and not color_changed then
--  if z_button_pressed then
--   next_color(-1)
--  elseif x_button_pressed then
--   next_color(1)
--  end
--  color_changed = true
-- end

-- -- reset buttons
-- if not x_button_pressed and not z_button_pressed then
--  color_changed = false
-- end

--outer angle for overall rotation
oa = (t())%(loop_l/2)/(loop_l/2)
normal_a = (t())%(loop_l/2)/(loop_l/2)
oa-=0.5
oa = abs(oa)

if normal_a <= 0.01 and not oa_zero then
 oa_zero = true
end

if normal_a > 0.01 and oa_zero then
 oa_zero = false
 loop_counter+=1
 srand(seed)
 -- cls()
end  


bcx = cos(-normal_a) * huge_circ_r
bcy = sin(-normal_a) * huge_circ_r
local c = t()*20%(#cols-6) + 6

for i=0,100 do
 local pt = rnd_pixel()
 pset(bcx+pt.x, bcy+pt.y, flr(rnd(12))+1)
 -- pset(-(bcx+pt.x), -(bcy+pt.y), flr(rnd(12))+1)
 -- pset(bcx+pt.x, -(bcy+pt.y), flr(rnd(12))+1)
 -- pset(-(bcx+pt.x), bcy+pt.y, flr(rnd(12))+1)

end

dither(bcx,bcy,25,1.0)

camera(bcx-64,bcy-64)
drw_halo(bcx,bcy,big_circ_r*2,-normal_a,c)
circfill(bcx,bcy,big_circ_r,c)



circ_r = 1
big_circ_r = 20 * normal_a * 1.6
huge_circ_r = 1


cols = cycle_colors()
flip()
-- debug.print(cols)


-- -- gif recording
-- if loop_counter == 4 and not loop_started then
--  extcmd("rec") -- start recording
--  loop_started = true
-- end
-- if loop_counter == 8 and not loop_ended then
--  extcmd("video") -- save video
--  loop_ended = true
-- end

goto _
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
