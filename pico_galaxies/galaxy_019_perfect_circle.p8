pico-8 cartridge // http://www.pico-8.com
version 32
__lua__

camera(-64,-64)
_set_fps(60)


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

  pxl = rnd_pixel()
  pxl.x += cx
  pxl.y += cy
  c=pget(pxl.x,pxl.y)
  x = pxl.x * pull
  y = pxl.y * pull
  -- local pt = rotate(normal_a,0,0,x,y)
  -- -- circfill(pt[1],pt[2],3,burn(c))
  -- circfill(pt[1],pt[2],2,burn(c))
  circfill(x,y,2,burn(c))

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


loop_l = 32
loop_counter = 0
oa_zero = false


big_circ_r = 10
huge_circ_r = 250
prev_cam_pos = {0,0}


all_colors = {
 {0,0,0,-15,1,-4,12,6,7,-9,10,9,-7,-2,8,-8},
 {0,0,0,-13,3,-5,-6,-9,7,-9,10,9,-7,-2,8,-8},
 {0,0,0,-13,3,-5,-6,-9,7,6,12,-4,1,-15,0,0},
 {-9,-9,10,9,-7,-2,8,-8,0,-8,8,-2,-7,9,10,-9},
 {0,0,0,-13,3,-5,-6,-9,7,-9,-6,-5,3,-13,0,0},
 {0,0,0,-15,1,-4,12,6,7,6,12,-4,1,-15,0,0},
 {0,0,0,-15,1,-4,12,6,7,14,13,-3,2,-11,-14,0},
 {0,0,0,-13,3,-5,-6,-9,7,14,13,-3,2,-11,-14,0},
 {-9,-9,10,9,-7,-2,8,-8,0,-14,-11,2,-3,13,14,7},
 {0,5,6,7,7,6,5,0,0,5,6,7,7,6,5,0}
}

col_i = flr(rnd(#all_colors)) + 1

pal(all_colors[col_i], 1)
cls(1)


::_:: 
_set_fps(60)


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





local x = cos(normal_a) * huge_circ_r
local y = sin(normal_a) * huge_circ_r
local c = t()*20%(#all_colors[col_i]-8) + 8


dither(x,y,300,0.95)
-- dither(300,-80,100,1.0)
-- new_cam_pos = {x-prev_cam_pos[1], y-prev_cam_pos[2]}
-- camera(new_cam_pos[1],new_cam_pos[2])
camera(x-64,y-64)
circfill(x,y,big_circ_r,c)
-- print(x,x,y,7)
-- print(y,x,y+5,7)
-- print(normal_a,x,y+11,7)




flip()
pal(all_colors[col_i], 1) 

-- prev_cam_pos = {x,y}

-- gif recording
if loop_counter == 2 and not loop_started then
 extcmd("rec") -- start recording
 loop_started = true
end
if loop_counter == 4 and not loop_ended then
 extcmd("video") -- save video
 loop_ended = true
end

goto _
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
