pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
cls()
camera(-64,-64)
_set_fps(60)
--aebrer 2021


-- functions

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


function burn(c)
 local new_c = max(abs(c-1),1)
 return new_c
end

function dither(cx,cy,loops,pull)

 for i=loops,1,-1 do 
  local pxl = rnd_pixel()
  pxl.x += cx-3
  pxl.y += cy
  c=pget(pxl.x,pxl.y)
  local x = pxl.x * pull
  local y = pxl.y * pull

  circfill(x,y,rnd(3),burn(c))
  -- pset(x,y,min(burn_outer(c)+rnd(4),#colors))

  pxl = rnd_pixel()
  pxl.x += cx-3
  pxl.y += cy
  c=pget(pxl.x,pxl.y)
  x = pxl.x * pull
  y = pxl.y * pull
  
  local k = rnd(3)
  line(x+k,y-k,x-k,y+k,burn(c))
  line(x-k,y-k,x+k,y+k,burn(c))
  
 end
end

function drw_star(x,y,rad,a,c)

 line()
 
 local points = {}
 for i=18,378,72 do
  local tpx = cos(i/360.0) * rad --+ (rnd(1)*rnd_sign())
  local tpy = sin(i/360.0) * rad --+ (rnd(1)*rnd_sign())
  
  local pt = rotate(a,x,y,tpx,tpy)
  add(points, pt)
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
  local pt = rotate(a,x,y,tpx,tpy)
  add(inner_points, pt)
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

-- setting params
seed = flr(rnd(-1))
srand(seed)
colors = {
 0, 10, 9, -7, -2, 8, -8, 7
}
-- cls(colors[#colors])
pal(colors,1)

loop_l = 5
lem_rad = 15
tri_rad=10
loop_counter = 0
oa_zero = false
loop_started = false
loop_ended = false

-- the actual drawing loop
::_::

 -- cls()

 --angle for triangle rotation
 local a = (t())%(loop_l/2)/(loop_l/2)
 local r=t()/(loop_l)
 local x=0
 local y=0


 if a <= 0.001 and not oa_zero then
  oa_zero = true
 end

 if a > 0.001 and oa_zero then
  oa_zero = false
  loop_counter+=1
  srand(seed)
  -- cls()
 end 

 x=sin(r)*(lem_rad+(rnd(2)))
 y=(cos(r)*sin(r))*(lem_rad+(rnd(2)))
 drw_star(x,y,tri_rad,a,8)
 drw_star(-x,-y,tri_rad,a,8)


 dither(0,0,50,1.0)
 dither(0,0,60,1.2)
 dither(0,0,10,1.4)


 pal(colors,1)
 flip()

 --   -- gif recording
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
