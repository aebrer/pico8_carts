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
  
  line(x+rnd(3),y-rnd(3),x-rnd(3),y+rnd(3),burn(c))
  line(x-rnd(3),y-rnd(3),x+rnd(3),y+rnd(3),burn(c))
  
 end
end

function drw_tri(x,y,tri_rad,shrink,a,c)

 local triangle_points = {}
 for i=360,0,-120 do
  local tpx = cos(i/360.0) * tri_rad
  local tpy = sin(i/360.0) * tri_rad
  add(triangle_points, {flr(tpx),flr(tpy)})
  tri_rad-=shrink
 end
 local ta=triangle_points[1]
 local tb=triangle_points[2]
 local tc=triangle_points[3]
 ta[1] += x
 ta[2] += y
 tb[1] += x
 tb[2] += y 
 tc[1] += x
 tc[2] += y

 --rotate all four points
 ta = rotate(a,x,y,ta[1],ta[2])
 tb = rotate(a,x,y,tb[1],tb[2])
 tc = rotate(a,x,y,tc[1],tc[2])
 
 line(ta[1], ta[2], tb[1], tb[2], c) 
 line(tb[1], tb[2], tc[1], tc[2], c) 
 line(tc[1], tc[2], ta[1], ta[2], c) 
 
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
lem_rad = 100
tri_rad=8

-- the actual drawing loop
::_::

 -- cls()

 --angle for triangle rotation
 local a = (t())%(loop_l/2)/(loop_l/2)
 local r=t()/(loop_l)
 local x=0
 local y=0

 for i=1,10 do
  x=sin(r+i)*(lem_rad+(i*rnd(2)))
  y=(cos(r+i)*sin(r+i))*(lem_rad+(i*rnd(2)))
  for j=tri_rad,0,-1 do
   drw_tri(x,y,tri_rad-j,0,a,8-j)
   
   --symmetry just for fun
   -- drw_tri(x,-y,tri_rad-j,0,a,8-j)
   -- drw_tri(-x,y,tri_rad-j,0,a,8-j)
   -- drw_tri(-x,-y,tri_rad-j,0,a,8-j)

  end
  drw_tri(x,y,tri_rad,0,a,8)
  --symmetry just for fun
  -- drw_tri(x,-y,tri_rad,0,a,8)
  -- drw_tri(-x,y,tri_rad,0,a,8)
  -- drw_tri(-x,-y,tri_rad,0,a,8)

 end 

 dither(0,0,50,1.0)
 dither(0,0,60,1.2)
 dither(0,0,10,1.4)


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
