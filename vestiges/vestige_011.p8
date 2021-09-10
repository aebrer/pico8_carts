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
     if c == 8 then
      pset(pxl.x,pxl.y,burn(c))
     else
      rectfill(
       pxl.x-1,pxl.y-1,
       pxl.x+1,pxl.y+1,
       burn(c)
      )
      circfill(pxl.x,pxl.y,rnd(2),burn(c))
     end
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
    if c == 8 then
     pset(pxl.x,pxl.y,burn(c))
    else
     -- pset(pxl.x,pxl.y,burn(c))
     line(pxl.x+1,pxl.y-1,pxl.x-1,pxl.y+1,burn(c))
     line(pxl.x-1,pxl.y-1,pxl.x+1,pxl.y+1,burn(c))
    end
   end
  end
 end

end

function drw_sqr(x,y,sl,a,c)
 local sa = {-sl+x,-sl+y}
 local sb = {sl+x,-sl+y}
 local sc = {sl+x,sl+y}
 local sd = {-sl+x,sl+y}
 --rotate all four points
 sa = rotate(a,x,y,sa[1],sa[2])
 sb = rotate(a,x,y,sb[1],sb[2])
 sc = rotate(a,x,y,sc[1],sc[2])
 sd = rotate(a,x,y,sd[1],sd[2])

 line(sa[1], sa[2], sb[1], sb[2], c) 
 line(sb[1], sb[2], sc[1], sc[2], c) 
 line(sc[1], sc[2], sd[1], sd[2], c) 
 line(sd[1], sd[2], sa[1], sa[2], c)
end

-- setting params
seed = flr(rnd(-1))
srand(seed)
seed_rst_needed = false
colors = {
 0, -8, 8, -3,
 -8, 8, 7, 2,
 -8
}
pal(colors,1)

loop_l = 10
loop_counter = 0
oa_zero = false
loop_started = false
loop_ended = false


-- the actual drawing loop
::_::

 -- cls()

 local radius = 3.0
 local shrink = 0.3
 local square_rad = 15
 --outer angle for overall rotation
 local oa = t()%(loop_l/2)/(loop_l/2)
 for ia=0.2,0.0,-0.1 do
  local pt=rotate(oa,0,0,radius,0)
  -- print(ia)
  local npt = rotate(ia,0,0,pt[1],pt[2])
  -- drw_sqr(npt[1],npt[2],square_rad,oa*2)
  drw_sqr(npt[1]-11,npt[2]-10,rnd(6),-oa*2,9)
  drw_sqr(-npt[1]-11,-npt[2]-10,rnd(6),-oa*2,9)

  drw_sqr(npt[1]+14,npt[2]-9,rnd(6),-oa*2,9)
  drw_sqr(-npt[1]+14,-npt[2]-9,rnd(6),-oa*2,9)

  -- mouth
  drw_sqr(npt[1]-13,npt[2]+20,rnd(6),-oa*2,9)
  drw_sqr(-npt[1]-13,-npt[2]+20,rnd(6),-oa*2,9)
  drw_sqr(npt[1]-17,npt[2]+15,rnd(6),-oa*2,9)
  drw_sqr(-npt[1]-17,-npt[2]+15,rnd(6),-oa*2,9)
  drw_sqr(npt[1],npt[2]+20,rnd(6),-oa*2,9)
  drw_sqr(-npt[1],-npt[2]+20,rnd(6),-oa*2,9)
  drw_sqr(npt[1]+14,npt[2]+20,rnd(6),-oa*2,9)
  drw_sqr(-npt[1]+14,-npt[2]+20,rnd(6),-oa*2,9)
  drw_sqr(npt[1]+18,npt[2]+15,rnd(6),-oa*2,9)
  drw_sqr(-npt[1]+18,-npt[2]+15,rnd(6),-oa*2,9)

  -- flip()
  radius-=shrink
  if radius <= 1 then
   break
  end
 end

 for i=50,0,-1 do 
  local px = rnd_pixel()
  pset(px.x,px.y,9)
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
 dither(4)
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
