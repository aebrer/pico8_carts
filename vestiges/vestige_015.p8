pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
cls()
camera(-64,-64)
_set_fps(60)
--aebrer 2021


-- functions

-- based on:
-- "a fast bresenham type
-- algorithm for drawing
-- ellipses" by john kennedy
function ellipse(
 cx,cy,xr,yr,c,hlinefunc
)
 xr=flr(xr)
 yr=flr(yr)
 hlinefunc=hlinefunc or rectfill
 local xrsq=shr(xr*xr,16)
 local yrsq=shr(yr*yr,16)
 local a=2*xrsq
 local b=2*yrsq
 local x=xr
 local y=0
 local xc=yrsq*(1-2*xr)
 local yc=xrsq
 local err=0
 local ex=b*xr
 local ey=0
 while ex>=ey do
  local dy=cy-y
  hlinefunc(cx-x,cy-y,cx+x,dy,c)
  dy+=y*2
  hlinefunc(cx-x,dy,cx+x,dy,c)
  y+=1
  ey+=a
  err+=yc
  yc+=a
  if 2*err+xc>0 then
   x-=1
   ex-=b
   err+=xc
   xc+=b
  end
 end

 x=0
 y=yr
 xc=yrsq
 yc=xrsq*(1-2*yr)
 err=0
 ex=0
 ey=a*yr
 while ex<=ey do
  local dy=cy-y
  hlinefunc(cx-x,cy-y,cx+x,dy,c)
  dy+=y*2
  hlinefunc(cx-x,dy,cx+x,dy,c)
  x+=1
  ex+=b
  err+=xc
  xc+=b
  if 2*err+yc>0 then
   y-=1
   ey-=a
   err+=yc
   yc+=a
  end
 end
end

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

function dither(cx,cy,loops,pull)

 for i=loops,1,-1 do 

  local pxl = rnd_pixel()
  pxl.x += cx-3
  pxl.y += cy
  c=pget(pxl.x,pxl.y)
  x = pxl.x * pull
  y = pxl.y * pull

  if c == 6 then
   pset(pxl.x,pxl.y,burn(c))
  else
   circ(pxl.x,pxl.y,3,burn(c))
  end
  pxl = rnd_pixel()
  pxl.x += cx-3
  pxl.y += cy
  c=pget(pxl.x,pxl.y)
  x = pxl.x * pull
  y = pxl.y * pull
  if c == 6 then
   pset(pxl.x,pxl.y,burn(c))
  else
   rect(pxl.x-1,pxl.y-1,pxl.x+1,pxl.y+1,burn(c))
  end

 end
end


function drw_star(x,y,rad,a,c)

 line()
 
 local points = {}
 for i=18,378,72 do
  local tpx = cos(i/360.0) * rad --+ (rnd(1)*rnd_sign())
  local tpy = sin(i/360.0) * rad --+ (rnd(1)*rnd_sign())
  add(points, {tpx,tpy})
 end

 local r_points = {}
 for pt in all(points) do
  local new_pt = rotate(-a,pt[1]+(rnd(5)*rnd_sign()),pt[2]+(rnd(5)*rnd_sign()),pt[1]+(rnd(5)*rnd_sign()),pt[2]+(rnd(5)*rnd_sign()))
  add(r_points, new_pt)
 end

 local midpoint = {
  (r_points[1][1]-r_points[2][1])*0.5,
  (r_points[1][2]-r_points[2][2])*0.5
 }
 
 local opposite = sqrt((r_points[1][1]-midpoint[1])^2 + (r_points[1][2]-midpoint[2])^2)
 local adjacent = opposite / (1.14)-- + ((rad/max_rad)*0.01))
 local inner_rad = rad - adjacent

 local inner_points = {}
 for i=54,414,72 do
  local tpx = cos(i/360.0) * inner_rad --+ (rnd(1)*rnd_sign())
  local tpy = sin(i/360.0) * inner_rad --+ (rnd(1)*rnd_sign())
  add(inner_points, {tpx, tpy})
 end


 local r_inner_points = {}
 for pt in all(inner_points) do
  local new_pt = rotate(-a,pt[2],pt[2],pt[1],pt[2])
  add(r_inner_points, new_pt)
 end

 line(r_points[1][1], r_points[1][2], r_inner_points[1][1], r_inner_points[1][2],c)
 line(r_points[2][1], r_points[2][2],c)
 line(r_inner_points[2][1], r_inner_points[2][2],c)
 line(r_points[3][1], r_points[3][2],c)
 line(r_inner_points[3][1], r_inner_points[3][2],c)
 line(r_points[4][1], r_points[4][2],c)
 line(r_inner_points[4][1], r_inner_points[4][2],c)
 line(r_points[5][1], r_points[5][2],c)
 line(r_inner_points[5][1], r_inner_points[5][2],c)
 line(r_points[1][1], r_points[1][2],c)
 
end


function drw_halo(x,y,rad,a,c)
 local shrink = shrink_start
 local shirnk_fac = shirnk_fac_start
 local points = {}
 for i=360,0,-360 do
  local tpx = cos(i/360.0) * rad --+ (rnd(1)*rnd_sign())
  local tpy = sin(i/360.0) * rad --+ (rnd(1)*rnd_sign())
  add(points, {(flr(tpx)+x)*shrink,(flr(tpy)+y)*shrink})
  shrink -= shirnk_fac
 end

 local ready = false
 for i=#points,1,-1 do
  local pt_i = points[i]
  pt_i = rotate(a,x,y,pt_i[1],pt_i[2])
  pt_i = rotate(a,x,y,pt_i[1],pt_i[2])
  drw_star(pt_i[1], pt_i[2], star_rad, a, c)
 end
 
end



-- setting params
seed = flr(rnd(-1))
srand(seed)
direc = rnd_sign()
seed_rst_needed = false
colors = {
 "9", "0", "-15", "0", 
 "7", "-3", "2", 
 "-8", "8"
}
-- cls(colors[#colors])
pal(colors,1)
cls(1)

loop_l = 4
loop_counter = 0
oa_zero = false
loop_started = false
loop_ended = false
dloops1=rnd(30) + 100
dloops2=rnd(5) + 5
star_rad = rnd(10) + 5
two_star = rnd_sign()
shrink_start = 0.4 + rnd(0.6)
shirnk_fac_start = 0.01 + rnd(0.2) 

-- the actual drawing loop
::_::

 -- cls()

 --outer angle for overall rotation
 local oa = (t())%(loop_l/2)/(loop_l/2)
 local inner_rad = 20
 local a = oa * direc
 
 
 if oa <= 0.001 and not oa_zero then
  oa_zero = true
 end

 if oa > 0.001 and oa_zero then
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

 drw_halo(0,-5,inner_rad,a,9)
 
 dither(0,0,dloops1,1.0)
 dither(0,0,dloops2,1.1)

 for i=-4,1 do
  ellipse(
   0,
   0,
   5*sin(r)*cos(r)+max(2,rnd(7)+3),
   -5*sin(r)-min(-7,rnd(7)-7-3),
   2
  )
 end

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
