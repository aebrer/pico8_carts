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


function isinside(cx,cy,r,x,y)
 local dist = (x)^2 + (y)^2
 if dist <= r^2 then
  return true
 else
  return false
 end
end


function burn_outer(c)
 local new_c = max(abs(c-1),7)
 return new_c
end

function burn_inner(c)
 local new_c = min(abs(c-1),6)
 if new_c == 0 then
  new_c = 2
 end
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

function dither(cx,cy,loops,pull,rad)

 for i=loops,1,-1 do 
  local pxl = rnd_pixel()
  pxl.x += cx-3
  pxl.y += cy
  c=pget(pxl.x,pxl.y)
  local x = pxl.x * pull
  local y = pxl.y * pull

  if isinside(cx,cy,rad,x,y) then 
   rect(
    x-1,y-1,
    x+1,y+1,
    burn_inner(c)
   )
  else
   -- if c == 10 then
   --  pset(x,y,burn_outer(c))
   -- else
    circfill(x,y,rnd(2),burn_outer(c))
    pset(x,y,min(burn_outer(c)+rnd(4),#colors))
   -- end
  end

  pxl = rnd_pixel()
  pxl.x += cx-3
  pxl.y += cy
  c=pget(pxl.x,pxl.y)
  x = pxl.x * pull
  y = pxl.y * pull

  if isinside(cx,cy,rad,x,y) then 
   rect(
    x-2,y-2,
    x+2,y+2,
    burn_inner(c)
   )
  else
   if c == 10 then
    pset(x,y,burn_outer(c))
   else
    line(x+1,y-1,x-1,y+1,burn_outer(c))
    line(x-1,y-1,x+1,y+1,burn_outer(c))
   end
  end
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

function drw_eye(x,y,xr,yr,cr,loops,cs)
 local c = rnd_choice(cs)
 rectfill(x-xr,y-yr,x+xr,y+yr,1)
 for i=loops,0,-1 do
  -- circfill(x+rnd(xr)*rnd_sign(),y+rnd(yr)*rnd_sign(),1,c)
  pset(x+flr(rnd(xr)+1)*rnd_sign(),y+flr(rnd(yr)+1)*rnd_sign(),c)
 end
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
 1, 0, -11, 13, 7, 10,
 0, 1, 7, 13, -9
}
-- cls(colors[#colors])
pal(colors,1)

loop_l = 10
loop_counter = 0
oa_zero = false
loop_started = false
loop_ended = false


-- the actual drawing loop
::_::

 cls()

 --outer angle for overall rotation
 local oa = (t())%(loop_l/2)/(loop_l/2)
 local inner_rad = 45 
 local inner_eye = {3,-17}
 local tri_rad = 5

 drw_halo(inner_eye[1],inner_eye[2],inner_rad,oa,6)
 
 if oa <= 0.001 and not oa_zero then
  oa_zero = true
 end

 if oa > 0.001 and oa_zero then
  oa_zero = false
  loop_counter+=1
  -- srand(seed)
  -- cls()
 end  

 if oa <= 0.001 then
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

 -- rectfill(inner_eye[1]-5,inner_eye[2]-5,inner_eye[1]+5,inner_eye[2]+5,1)

 dither(inner_eye[1],inner_eye[2],200,1.0,inner_rad)


 --draw right eye
 local eye_cols = {2,5}
 local eye_xr = 11
 local eye_yr = 8
 local eye_r = 8
 
 --third eye
 drw_eye(inner_eye[1],inner_eye[2],eye_xr,eye_yr,eye_r,25,eye_cols)
 drw_tri(inner_eye[1],inner_eye[2],tri_rad,0,-oa,6)

 -- other eyes
 drw_eye(-13,-6,eye_xr,eye_yr,eye_r,75,eye_cols)
 drw_eye(14,-3,eye_xr,eye_yr,eye_r,75,eye_cols)
 
 -- mouth
 drw_eye(1,22,22,10,eye_r,75,eye_cols)

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
