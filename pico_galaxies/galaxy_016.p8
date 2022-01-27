pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
cls()
camera(-64,-64)
_set_fps(60)
--aebrer 2021


-- functions
function rnd_choice(itr)
 local i = flr(rnd(#itr)) + 1
 return(itr[i])
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

function dotter()
 for x=90,-90,-dotter_x do
  for y=90,-90,-dotter_y do
   if x%dotter_mod_x == 0 or y%dotter_mod_y == 0 then
    local c = colors[(x%#colors)+1]
    local pt = rotate(normal_a,0,0,x,y)
    circfill(pt[1],pt[2],dotter_circ_rad,c)
    patience = 0
   else
    patience += 1
   end
  end
 end
end


-- setting params
seed = flr(rnd(-1))
-- good seeds: 9,11,12,15,25,31,41,43,48!,56
-- seed = 67
srand(seed)

colors = {
 7, -9, 10, 9, -7, -2, 8, -8
}
cls(colors[1])
pal(colors,1)

loop_l = 4
loop_counter = 0
oa_zero = false
patience = 0
patience_lim = 20

dotter_x = flr(rnd(5))+2
dotter_y = flr(rnd(5))+2

dotter_mod_x = flr(rnd(7))+3
dotter_mod_y = flr(rnd(7))+3

dotter_circ_rad = flr(rnd(4)) + 1


if dotter_x == 2 and dotter_y == 2 then
 local ct = rnd_sign()
 if ct > 0 then
  dotter_x+=2
 else
  dotter_y+=2
 end
end

-- the actual drawing loop
::_::

 _set_fps(60)
 -- cls()
 -- print(dotter_x,0,-10,10)
 -- print(dotter_y,0,0,10)
 -- print(dotter_mod_x,0,10,10)
 -- print(dotter_mod_y,0,20,10)



 --outer angle for overall rotation
 normal_a = (t())%(loop_l/2)/(loop_l/2)

 if normal_a <= 0.01 and not oa_zero then
  oa_zero = true
 end

 if normal_a > 0.01 and oa_zero then
  oa_zero = false
  loop_counter+=1
  srand(seed)
  -- cls()
 end 


 dotter()



 -- if screen is blank, fix it
 if patience > patience_lim then
  local ct = rnd_sign()
  if ct > 0 then
   dotter_x+=1
  else
   dotter_y+=1
  end
 end
 pal(colors,1)

 flip()

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
