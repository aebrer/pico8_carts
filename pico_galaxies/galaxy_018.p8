pico-8 cartridge // http://www.pico-8.com
version 32
__lua__

camera(-64,-64)
_set_fps(60)

-- functions
function rnd_choice(itr)
 local i = flr(rnd(#itr)) + 1
 return(itr[i])
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

  local rect_width = circ_r / 2

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
  local pt = rotate(normal_a,0,0,x,y)
  -- circfill(pt[1],pt[2],3,burn(c))
  rectfill(pt[1]-1,pt[2]-1,pt[1]+1,pt[2]+1,burn(c))


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


loop_l = flr(rnd(24))+16
loop_counter = 0
oa_zero = false

kajiggy = rnd(0.01)+0.001
circ_r = flr(rnd(2))+1

vfac = rnd(45)+300.0
sym_num = flr(rnd(2))+1

was_3 = flr(rnd(5)) + 1

rot_direc = rnd_sign()
point_freq = -1 * (flr(rnd(2)) + 3)
was_2 = 2
-- do_dither = rnd_sign() > 0
do_dither = false

oval_squish_x = rnd(2.0)+0.2
oval_squish_y = rnd(2.0)+0.2

do_rect = rnd_sign() > 0

ring_num = flr(rnd(5)) + 4
ring_floor = flr(rnd(4))
ring_inc = -1
if ring_num >= 6 then
 ring_inc = -2
end

ring_len = flr(rnd(60)) + 50


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


if do_dither then
 dither(0,0,200,1.0)
end

for l=ring_num,ring_floor,ring_inc do
 for i=ring_len,0,point_freq do
  v=vfac*(l/16)
  z=i*cos(
   normal_a
   )*(1/2)+was_3+l
  x=sin(
   kajiggy*i-l*oa
   )*v
  y=cos(
   kajiggy*i-(oa/was_2)
   )*v*sin(kajiggy*i-(oa/was_2))

  local pt = {0,0}

  if rot_direc > 0 then
   pt = rotate(normal_a,0,0,x,y)
  else
   pt = rotate(normal_a,0,0,y,x)
  end

  if do_rect then
   rectfill(pt[1]-(circ_r*oval_squish_x),pt[2]-(circ_r*oval_squish_y),pt[1]+(circ_r*oval_squish_x),pt[2]+(circ_r*oval_squish_y),z)
   rectfill(-pt[1]-(circ_r*oval_squish_x),pt[2]-(circ_r*oval_squish_y),-pt[1]+(circ_r*oval_squish_x),pt[2]+(circ_r*oval_squish_y),z)
   rectfill(pt[1]-(circ_r*oval_squish_x),-pt[2]-(circ_r*oval_squish_y),pt[1]+(circ_r*oval_squish_x),-pt[2]+(circ_r*oval_squish_y),z)
   rectfill(-pt[1]-(circ_r*oval_squish_x),-pt[2]-(circ_r*oval_squish_y),-pt[1]+(circ_r*oval_squish_x),-pt[2]+(circ_r*oval_squish_y),z)
  else
   ovalfill(pt[1]-(circ_r*oval_squish_x),pt[2]-(circ_r*oval_squish_y),pt[1]+(circ_r*oval_squish_x),pt[2]+(circ_r*oval_squish_y),z)
   ovalfill(-pt[1]-(circ_r*oval_squish_x),pt[2]-(circ_r*oval_squish_y),-pt[1]+(circ_r*oval_squish_x),pt[2]+(circ_r*oval_squish_y),z)
   ovalfill(pt[1]-(circ_r*oval_squish_x),-pt[2]-(circ_r*oval_squish_y),pt[1]+(circ_r*oval_squish_x),-pt[2]+(circ_r*oval_squish_y),z)
   ovalfill(-pt[1]-(circ_r*oval_squish_x),-pt[2]-(circ_r*oval_squish_y),-pt[1]+(circ_r*oval_squish_x),-pt[2]+(circ_r*oval_squish_y),z)
  end

  if sym_num >= 2 then
   new_pt = rotate(0.25,0,0,pt[1],pt[2])
   
   if do_rect then
    rectfill(new_pt[1]-(circ_r*oval_squish_x),new_pt[2]-(circ_r*oval_squish_y),new_pt[1]+(circ_r*oval_squish_x),new_pt[2]+(circ_r*oval_squish_y),z)
    rectfill(-new_pt[1]-(circ_r*oval_squish_x),new_pt[2]-(circ_r*oval_squish_y),-new_pt[1]+(circ_r*oval_squish_x),new_pt[2]+(circ_r*oval_squish_y),z)
    rectfill(new_pt[1]-(circ_r*oval_squish_x),-new_pt[2]-(circ_r*oval_squish_y),new_pt[1]+(circ_r*oval_squish_x),-new_pt[2]+(circ_r*oval_squish_y),z)
    rectfill(-new_pt[1]-(circ_r*oval_squish_x),-new_pt[2]-(circ_r*oval_squish_y),-new_pt[1]+(circ_r*oval_squish_x),-new_pt[2]+(circ_r*oval_squish_y),z)
   else
    ovalfill(new_pt[1]-(circ_r*oval_squish_x),new_pt[2]-(circ_r*oval_squish_y),new_pt[1]+(circ_r*oval_squish_x),new_pt[2]+(circ_r*oval_squish_y),z)
    ovalfill(-new_pt[1]-(circ_r*oval_squish_x),new_pt[2]-(circ_r*oval_squish_y),-new_pt[1]+(circ_r*oval_squish_x),new_pt[2]+(circ_r*oval_squish_y),z)
    ovalfill(new_pt[1]-(circ_r*oval_squish_x),-new_pt[2]-(circ_r*oval_squish_y),new_pt[1]+(circ_r*oval_squish_x),-new_pt[2]+(circ_r*oval_squish_y),z)
    ovalfill(-new_pt[1]-(circ_r*oval_squish_x),-new_pt[2]-(circ_r*oval_squish_y),-new_pt[1]+(circ_r*oval_squish_x),-new_pt[2]+(circ_r*oval_squish_y),z)
   end

  end


 end
end

-- print(kajiggy,-40,-40,9)
-- print(circ_r,-40,-30,9)
-- print(was_3,-40,-20,9)
-- print(do_rect,-40,-10,9)

flip()
pal(all_colors[col_i], 1) 

-- -- gif recording
-- if loop_counter == 1 and not loop_started then
--  extcmd("rec") -- start recording
--  loop_started = true
-- end
-- if loop_counter == 2 and not loop_ended then
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
