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
 local new_c = max(abs(c-1),0)
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
  circ(
   pxl.x,pxl.y,
   rnd(5),
   burn(c)
  )
 end

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
     pset(pxl.x,pxl.y,burn(c))
   end
  end
 end
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
     -- rect(
     --  pxl.x-2,pxl.y-2,
     --  pxl.x+2,pxl.y+2,
     --  burn(c)
     -- )
     circfill(pxl.x,pxl.y,rnd(3),burn(c))
   end
  end
 end
end


-- setting params
seed = flr(rnd(-1))
srand(seed)
seed_rst_needed = false
colors = {
 "0", "12", "13", 14,
 "-9", "-7", "7", "-6",
 "-4"
}
pal(colors,1)
loop_l = 10

-- the actual drawing loop
::_::

 cls()
 local srf=flr(t()*10)%loop_l/2==0

 -- if srf and seed_rst_needed then
 if srf then
  srand(seed)
 --  seed_rst_needed = false
 -- elseif not srf and not seed_rst_needed then
 --  seed_rst_needed = true
 end

 local radius = 64.0
 local shrink = 0.05
 --outer angle for overall rotation
 local oa = t()%(loop_l/2)/(loop_l/2)
 while radius > 1 do
  local pt=rotate(oa,0,0,radius,0)
  for ia=0.5,1.0,0.015 do
   -- print(ia)
   local npt = rotate(ia,0,0,pt[1],pt[2])
   pset(npt[1], npt[2], 9)
   radius-=shrink
  end
 end  

 
 
 dither(1)
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
