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

  local rect_width = 1

  local pxl = rnd_pixel()
  pxl.x += cx
  pxl.y += cy
  c=pget(pxl.x,pxl.y)
  x = pxl.x * pull
  y = pxl.y * pull
  rect(x-rect_width,y-rect_width,x+rect_width,y+rect_width,burn(c))

  pxl = rnd_pixel()
  pxl.x += cx
  pxl.y += cy
  c=pget(pxl.x,pxl.y)
  x = pxl.x * pull
  y = pxl.y * pull
  -- local pt = rotate(normal_a,0,0,x,y)
  -- -- circfill(pt[1],pt[2],3,burn(c))
  -- circfill(pt[1],pt[2],2,burn(c))
  circfill(x,y,1,burn(c))

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

loop_l = 15
loop_counter = 0
oa_zero = false


big_circ_r = 4
huge_circ_r = 50
prev_cam_pos = {0,0}


all_colors = {
 {0,0,0,-15,1,-4,12,6,7,-9,10,9,-7,-2,8,-8},
 {0,0,0,-13,3,-5,-6,-9,7,-9,10,9,-7,-2,8,-8},
 {0,0,0,-13,3,-5,-6,-9,7,6,12,-4,1,-15,0,0},
 {0,-9,10,9,-7,-2,8,-8,0,-8,8,-2,-7,9,10,-9},
 {0,0,0,-13,3,-5,-6,-9,7,-9,-6,-5,3,-13,0,0},
 {0,0,0,-15,1,-4,12,6,7,6,12,-4,1,-15,0,0},
 {0,0,0,-15,1,-4,12,6,7,14,13,-3,2,-11,-14,0},
 {0,0,0,-13,3,-5,-6,-9,7,14,13,-3,2,-11,-14,0},
 {0,-9,10,9,-7,-2,8,-8,0,-14,-11,2,-3,13,14,7},
 {0,5,6,7,7,6,5,0,0,5,6,7,7,6,5,0},
 {0,5,6,7,7,6,5,-8,-8,5,6,7,7,6,5,0},
 {0,5,6,7,7,6,5,-4,-4,5,6,7,7,6,5,0},
 {0,5,6,7,7,6,5,-13,-13,5,6,7,7,6,5,0}

}

col_i = flr(rnd(#all_colors)) + 1

pal(all_colors[col_i], 1)
cls(1)


::_:: 

if btn(4) then
 --z/🅾️ button
 z_button_pressed = true
else
 z_button_pressed = false
end

if btn(5) then
 x_button_pressed = true
else
 x_button_pressed = false
end


if (z_button_pressed or x_button_pressed) and not color_changed then
 if z_button_pressed then
  next_color(-1)
 elseif x_button_pressed then
  next_color(1)
 end
 color_changed = true
end

-- reset buttons
if not x_button_pressed and not z_button_pressed then
 color_changed = false
end


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

hour = stat(93)
if hour > 12 then
 hour -= 12
end
hour /= 12
-- hour = 0
minute = stat(94) / 60-- minutes
second = stat(95) / 60 -- minutes
-- debug.print(hour)
-- debug.print(minute)
-- debug.print(second)

dither(0,0,30,1.0)
dither(0,0,10,0.5)

-- local c = t()*20%(#all_colors[col_i]-8) + 8
drw_halo(0,0,(huge_circ_r * 0.5), normal_a,c)


-- now add some trails?
local x = -cos(normal_a) * (huge_circ_r * 0.5)
local y = sin(normal_a) * (huge_circ_r * 0.5)
local c = t()*20%(#all_colors[col_i]-8) + 8
pset(x,y,c)
pset(-x,y,c)
pset(x,-y,c)
pset(-x,-y,c)
x = -cos(normal_a+0.25) * (huge_circ_r * 0.5)
y = sin(normal_a+0.25) * (huge_circ_r * 0.5)
pset(x,y,c)
pset(-x,y,c)
pset(x,-y,c)
pset(-x,-y,c)


x = -cos(normal_a) * (huge_circ_r * 0.8)
y = sin(normal_a) * (huge_circ_r * 0.8)
pset(x,y,c)
pset(-x,y,c)
pset(x,-y,c)
pset(-x,-y,c)
x = -cos(normal_a+0.25) * (huge_circ_r * 0.8)
y = sin(normal_a+0.25) * (huge_circ_r * 0.8)
pset(x,y,c)
pset(-x,y,c)
pset(x,-y,c)
pset(-x,-y,c)

x = -cos(normal_a) * (huge_circ_r)
y = sin(normal_a) * (huge_circ_r)
pset(x,y,c)
pset(-x,y,c)
pset(x,-y,c)
pset(-x,-y,c)
x = -cos(normal_a+0.25) * (huge_circ_r)
y = sin(normal_a+0.25) * (huge_circ_r)
pset(x,y,c)
pset(-x,y,c)
pset(x,-y,c)
pset(-x,-y,c)

-- second
x = -cos(second+0.25) * (huge_circ_r)
y = sin(second+0.25) * (huge_circ_r)
c = t()*50%(#all_colors[col_i]-8) + 8
line(0,0,x,y,c)
circfill(x,y,big_circ_r*0.5,c)
-- minute
x = -cos(minute+0.25) * (huge_circ_r * 0.8)
y = sin(minute+0.25) * (huge_circ_r * 0.8)
c = t()*20%(#all_colors[col_i]-8) + 8
line(0,0,x,y,c)
circfill(x,y,big_circ_r*0.7,c)
-- hour
x = -cos(hour+0.25) * (huge_circ_r * 0.5)
y = sin(hour+0.25) * (huge_circ_r * 0.5)
c = t()*10%(#all_colors[col_i]-8) + 8
line(0,0,x,y,c)
circfill(x,y,big_circ_r,c)

flip()
pal(all_colors[col_i], 1) 


-- -- gif recording
-- if loop_counter == 2 and not loop_started then
--  extcmd("rec") -- start recording
--  loop_started = true
-- end
-- if loop_counter == 10 and not loop_ended then
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
