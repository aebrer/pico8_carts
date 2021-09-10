pico-8 cartridge // http://www.pico-8.com
version 32
__lua__

camera(-64,-64)

colors = {0,-8,8,9,10,11,12,-4,0,-8,8,9,10,11,12,-4}
pal(colors, 1) 
_set_fps(60)
cls(1)

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


loop_l = flr(rnd(32))+8
loop_counter = 0
oa_zero = false

kajiggy = rnd(0.01)+0.001
circ_r = flr(rnd(3))+1
vfac = rnd(45)+30.0
sym_num = flr(rnd(2))+1

was_3 = flr(rnd(5)) + 1
rot_direc = rnd_sign()
point_freq = -1 * (flr(rnd(3)) + 2)
was_2 = 2
do_dither = rnd_sign() > 0


::_:: 
_set_fps(60)


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

-- print(vfac,-40,-40,16)

if do_dither then
 dither(0,0,200,1.0)
end

for l=8,2,-2 do
 for i=150,2,point_freq do
  v=vfac*(l/16)
  z=i*cos(
   normal_a
   )*(1/2)+was_3+l
  x=sin(
   kajiggy*i-l*oa
   )*v
  y=cos(
   kajiggy*i-(oa/was_2)
   )*v

  local pt = {0,0}

  if rot_direc > 0 then
   pt = rotate(normal_a,0,0,x,y)
  else
   pt = rotate(normal_a,0,0,y,x)
  end


  circfill(pt[1],pt[2],circ_r,z)
  circfill(-pt[1],-pt[2],circ_r,z)
  circfill(pt[1],-pt[2],circ_r,z)
  circfill(-pt[1],pt[2],circ_r,z)

  if sym_num >= 2 then
   new_pt = rotate(0.25,0,0,pt[1],pt[2])
   circfill(new_pt[1],new_pt[2],circ_r,z)
   circfill(-new_pt[1],-new_pt[2],circ_r,z)
   circfill(new_pt[1],-new_pt[2],circ_r,z)
   circfill(-new_pt[1],new_pt[2],circ_r,z)
  end


 end
end


flip()
pal(colors, 1) 

-- -- gif recording
-- if loop_counter == 2 and not loop_started then
--  extcmd("rec") -- start recording
--  loop_started = true
-- end
-- if loop_counter == 4 and not loop_ended then
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
