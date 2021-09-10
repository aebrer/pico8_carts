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
      pxl.x-1,pxl.y-1,
      pxl.x+1,pxl.y+1,
      burn(c)
     )
   end
  end
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


seed = 42
srand(seed)
seed_reset_needed = false



colors = {
 "0", "-13", "0", "-13",
 "3", "-5", "-6", "-9",
 "7"
}

pal(colors,1)

loop_l = 10
frame = 0
cam_x = -64
cam_y = -64
cam_fac = 1
::_::
 local srf=flr(t()*10)%loop_l/2==0
 local r = t()*0.5+1
 local x,y=0,0


 if srf then
  srand(seed)
 end

 local radius = 10.0
 for i=1,61 do
  y=sin(r+i) * radius * (i/4) 
  x=cos(r+i)*sin(r)*radius*(i/4)

  rotate(x,y,r,1)
  rotate(-x,-y,r,1)
  rotate(x,-y,r,1)
  rotate(-x,y,r,1)

 end
 
 dither(1) 
 pal(colors,1)
 frame+=1
 camera(cam_x-5, cam_y)

 if frame%4 == 0 then
  cam_x-=5
 elseif frame%4 == 1 then
  cam_x+=10
 elseif frame%4 == 2 then
  cam_x-=10
 else
  cam_x+=5
 end

goto _


__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
