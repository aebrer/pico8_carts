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
  flr(rnd(200))
 ) - 64
 local px_y = (
  flr(rnd(200))
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

function dither(loops)

 for i=loops,1,-1 do 
  local pxl = rnd_pixel()
  c=pget(pxl.x,pxl.y)

  line(pxl.x-2,pxl.y-1,pxl.x+1,pxl.y+2,burn(c))
  line(pxl.x,pxl.y-3,burn(c))
  line(pxl.x-1,pxl.y+2,burn(c))
  line(pxl.x+2,pxl.y-1,burn(c))
  line(pxl.x-2,pxl.y-1,burn(c))
  line()

  -- drw_star(pxl.x,pxl.y,2,burn(c))
  -- pset(pxl.x,pxl.y,burn(c))
  -- circfill(pxl.x,pxl.y,3,burn(c))

 end
end


function drw_star(x,y,rad,c)

 line()
 
 local points = {}
 for i=18,378,72 do
  local tpx = cos(i/360.0) * rad --+ (rnd(1)*rnd_sign())
  local tpy = sin(i/360.0) * rad --+ (rnd(1)*rnd_sign())
  add(points, {(flr(tpx)+x),(flr(tpy)+y)})
 end

 local midpoint = {
  (points[1][1]-points[2][1])*0.5,
  (points[1][2]-points[2][2])*0.5
 }
 
 local opposite = sqrt((points[1][1]-midpoint[1])^2 + (points[1][2]-midpoint[2])^2)
 local adjacent = opposite / (1.14)-- + ((rad/max_rad)*0.01))
 local inner_rad = rad - adjacent

 local inner_points = {}
 for i=54,414,72 do
  local tpx = cos(i/360.0) * inner_rad --+ (rnd(1)*rnd_sign())
  local tpy = sin(i/360.0) * inner_rad --+ (rnd(1)*rnd_sign())
  add(inner_points, {(flr(tpx)+x),(flr(tpy)+y)})
 end

 line(points[1][1], points[1][2], inner_points[1][1], inner_points[1][2],c)
 line(points[2][1], points[2][2],c)
 line(inner_points[2][1], inner_points[2][2],c)
 line(points[3][1], points[3][2],c)
 line(inner_points[3][1], inner_points[3][2],c)
 line(points[4][1], points[4][2],c)
 line(inner_points[4][1], inner_points[4][2],c)
 line(points[5][1], points[5][2],c)
 line(inner_points[5][1], inner_points[5][2],c)
 line(points[1][1], points[1][2],c)
 
end

function isinside(cx,cy,r,x,y)
 local dist = (cx-x)^2 + (cy-y)^2
 if dist <= r^2 then
  return true
 else
  return false
 end
end

-- setting params
seed = flr(rnd(-1))
srand(seed)
seed_rst_needed = false
colors = {
 0, 8, 13, -7, 12, 11, 14, -9
}
-- cls(colors[#colors])
pal(colors,1)

loop_l = 10
loop_counter = 0
oa_zero = false
loop_started = false
loop_ended = false
max_rad = 128


-- the actual drawing loop
::_::

 -- cls(9)

 --outer angle for overall rotation
 local oa = (t())%(loop_l/5)/(loop_l/5)
 oa-=0.5
 -- ?oa
 local rad = max_rad * abs(oa)

 drw_star(0,7,rad,8)
 
 if oa <= -0.499 and not oa_zero then
  oa_zero = true
 end

 if oa > -0.499 and oa_zero then
  oa_zero = false
  loop_counter+=1
  srand(seed)
  -- cls()
 end  

 -- if oa <= 0.001 then
 --  srand(seed)
 -- end


  -- gif recording
 if loop_counter == 2 and not loop_started then
  extcmd("rec") -- start recording
  loop_started = true
 end
 if loop_counter == 4 and not loop_ended then
  extcmd("video") -- save video
  loop_ended = true
 end


 dither(500)

 pal(colors,1)
 flip()

goto _


__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
