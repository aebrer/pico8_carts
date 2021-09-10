pico-8 cartridge // http://www.pico-8.com
version 32
__lua__

camera(-64,-64)
_set_fps(60)
loop_l = 8
loop_counter = 0
v_zero = false

circ_r = 2

-- setting params
seed = flr(rnd(-1))
srand(seed)

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


function burn(c)
 local new_c = max(abs(c-1),1)
 return new_c
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
  pset(x,y,burn(burn(c)))

 end
end



::⌂::
-- cls(1)
v = (((t())%(loop_l/2))/(loop_l/2))
ang = (((t())%(loop_l/2))/(loop_l/2))
v = abs(v-0.5)
for i=v*50, -v*50, -0.1 do
 x = (i+(v^2))--*(rnd(1)+1)
 y = i*(v*(rnd(4)+1))
 
 pt = rotate(ang,0,0,x,y)
 x = pt[1]
 y = pt[2]

 c = ((i*100-(v))%10) + 6 
 circ(x,y,1,c)
 circ(-x,-y,1,c)
 circ(x,-y,1,c)
 circ(-x,y,1,c)
end

dither(0,0,100,1.0)

-- ?v,0,0,7
flip()
pal({0,0,0,-15,1,-4,12,6,7,-9,10,9,-7,-2,8,-8},1)


if v <= 0.01 and not v_zero then
 v_zero = true
end

if v > 0.01 and v_zero then
 v_zero = false
 loop_counter+=1
 srand(seed)
end  

-- gif recording
if loop_counter == 2 and not loop_started then
 extcmd("rec") -- start recording
 loop_started = true
end
if loop_counter == 4 and not loop_ended then
 extcmd("video") -- save video
 loop_ended = true
end

goto ⌂


__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
