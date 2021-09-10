pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
cls()
camera(-64,-64)
_set_fps(60)
--aebrer 2021


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


function rotate(x,y,a,w)
 local ca,sa=cos(a),sin(a)
 local srcx,srcy
 local ddx0,ddy0=ca,sa
 ca*=w-0.5
 sa*=w-0.5
 local dx0,dy0=sa-ca+w,-ca-sa+w
 w=2*w-1
 for ix=0,w do
  srcx,srcy=dx0,dy0
  for iy=0,w do
   pset(x+ix,y+iy,9)
   srcx-=ddy0
   srcy+=ddx0
  end
  dx0+=ddx0
  dy0+=ddy0
 end
end


function isoutside(r,x,y)
 local dist = x*x + y*y
 if dist <= r*r then
  return true
 else
  return false
 end
end


function marbelize(mx,my)
 local x=flr(rnd(64))
 local y=flr(rnd(64))
 while isoutside(37,x,y) do
  x=flr(rnd(64))
  y=flr(rnd(64))
 end
 x *= rnd_sign()
 y *= rnd_sign()
 circfill(x,y,4,0)
end

function burn(c)
 local new_c = max(abs(c-1),0)
 if new_c == 7 then
  if rnd(1) > 0.3 then
   new_c=6
  end 
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
     rect(
      pxl.x-2,pxl.y-2,
      pxl.x+2,pxl.y+2,
      burn(c)
     )
   end
  end
 end
end


seed = rnd(-1)
srand(seed)
seed_reset_needed = false
colors = {
 "0", "-8", "0", -3,
 "-8", "8", "7", "2",
 "-8"
}

pal(colors,1)

loop_l = 10
frame = 0
seed_reset_needed = false
mb_loops=flr(rnd(900))+100

::_::
 local srf=flr(t())%loop_l/2==0
 local r = t()/8
 local x,y=0,0


 -- if srf then
 --  srand(seed)
 -- end


 local radius = 15
 -- if frame % 6 == 0 then
  for i=50,100 do
   y=sin((r+i)/360) * radius * (i/10000) 
   x=cos(r+i/360)*sin(r) * radius * (i/(rnd(10)+500))
   
   rotate(x,y,r,1)
   rotate(-x,-y,r,1)

   y*=10
   x*=10
   rotate(x,y,r,1)
   rotate(-x,-y,r,1)

   x = x/sin(r)
   rotate(x,y,r,1)
   rotate(-x,-y,r,1)

   y = y/sin(r)
   rotate(x,y,r,1)
   rotate(-x,-y,r,1)
   rotate(-x,y,r,1)
   rotate(x,-y,r,1)

   -- if frame % 4 == 0 then
    for i=mb_loops/8,0,-1 do
     marbelize(74,74)
    end
   -- end
  end
 -- end

 dither(2)
 -- for i=mb_loops,0,-1 do
 --  marbelize(74,74)
 -- end
 pal(colors,1)
 frame+=1
 flip()



goto _


__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
