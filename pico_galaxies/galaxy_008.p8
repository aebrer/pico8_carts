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
  flr(rnd(128)) + 1
 ) - 64
 local px_y = (
  flr(rnd(128)) + 1
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


function isoutside(r,x,y)
 local dist = x*x + y*y
 if dist <= r*r then
  return true
 else
  return false
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

function dither(loops)


 for i=loops,1,-1 do 
  local fudge_x = (
   (
    flr(rnd(4)) + 1
   ) * rnd_sign()
  )
  local fudge_y = (
   (
    flr(rnd(4)) + 1
   ) * rnd_sign()
  )
  --skip some nunber (12) pixels
  for x=128+fudge_x,0,-12 do
   for y=128+fudge_y,0,-12 do
    local pxl = rnd_pixel()
     c=pget(pxl.x,pxl.y)
     local new_c = burn(c)
     -- pset(pxl.x,pxl.y,1)
     drw_tri(pxl.x,pxl.y,min(rnd(4),2),0,rnd(),burn(c))
     -- drw_tri(pxl.x,pxl.y,new_c/2,0,rnd(),new_c)

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


-- setting params
seed = flr(rnd(-1))
srand(seed)
seed_rst_needed = false
colors = {
 0, 7, 0, -6,
 0, 12, 0, 14,
 7
}
pal(colors,1)

loop_l = 10
loop_counter = 0
oa_zero = false
loop_started = false
loop_ended = false
frame = 1

-- the actual drawing loop
::_::

 -- cls()

 local radius = 25.0
 local shrink = 5
 local tri_rad = 25
 local tri_cols = {9,9,9,9,9,8,8,8,8,8,6,6,6,6,6,4,4,4,4,4}
 
 --outer angle for overall rotation
 local oa = t()%(loop_l/2)/(loop_l/2)
 for ia=0.5,0.0,-0.1 do
  local pt=rotate(oa,0,0,radius,0)
  -- print(ia)
  local npt = rotate(ia,0,0,pt[1],pt[2])
  -- drw_sqr(npt[1],npt[2],square_rad,oa*2)
  drw_tri(npt[1],npt[2],tri_rad,5,-oa*2,tri_cols[(frame%#tri_cols)+1])
  -- drw_tri(-npt[1],npt[2],tri_rad,shrink,-oa*2,9)

  -- flip()
  tri_rad-=shrink
  if tri_rad <= 1 then
   break
  end
 end

 if oa == 0.01 and not oa_zero then
  loop_counter+=1
  oa_zero = true
  srand(seed)
 end

 if oa != 0.0 then
  oa_zero = false
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
 
 -- ?t(),8
 -- ?oa,8
 -- ?loop_counter,8
 dither(1)
 pal(colors,1)
 flip()
 frame += 1

goto _


__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
