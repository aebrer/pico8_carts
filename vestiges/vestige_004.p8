pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
cls()
camera(-64,-64)
_set_fps(60)
colors = {
 0,0,-16,-16,
 -15,-15,-15,-15,
 -14,-14,-14,-11,
 -11,2,-8,-8 
}
r=0
-- colors = {
--  0,0,8,8,8,8,8,8,
--  8,8,8,8,8,8,8,8
-- }
-- pal(colors,0)

srand(42)

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

function ofst(a, x, y)
 --offset a point
 local b={a[1]+x, a[2]+y}
 return(b)
end

--noise
function noise(prob)
 if rnd() > prob then
  poke(0x6000+rnd(0x2000),peek(rnd(0x7fff)))
  poke(0x6000+rnd(0x2000),rnd(0xff))
 end
end

function dither(loops)
 
 for i=-loops,1 do
  local x=rnd(128)-64
  local y=rnd(128)-64
  local c=abs(pget(x,y)-1)
  
  circfill(x,y,2,c)
  x=rnd(128)-64
  y=rnd(128)-64
  c=abs(pget(x,y)-1)
  circ(x,y,3,c)
  x=rnd(128)-64
  y=rnd(128)-64
  c=abs(pget(x,y)-1)
  pset(x,y,c)
  -- circfill(x,y,2,c)
 end
end

function undither(loops,s)
 
 for i=-loops,1 do
  local x=rnd(128)-64
  local y=rnd(128)-64
  local c=min(abs(pget(x,y)-1),4)
  circfill(x*s,y*s,3,c)
  x=rnd(128)-64
  y=rnd(128)-64
  c=min(abs(pget(x,y)-1),colors[4])
  circ(x*s,y*s,8+rnd(3),c)
  circ(x*s,y*s,13+rnd(5),c)
  x=rnd(128)-64
  y=rnd(128)-64
  c=min(abs(pget(x,y)-1),colors[4])
  pset(x*s,y*s,c)
  -- circfill(x,y,2,c)
 end
end

function rnd_choice(itr)
 local i = flr(rnd(#itr)) + 1
 return(itr[i])
end

loop_len =10

::_::
 local loop = flr(t())%loop_len == 0
 local srf = flr(t())%(loop_len/2) == 0
 local r = t()
 if srf and seed_reset_needed then
  srand(42)
  seed_reset_needed = false
 elseif not srf and not seed_reset_needed then
  seed_reset_needed = true
 end
 
 cls()
 noise(0.53)
 circ(0,0,24,colors[15])
 dither(50)
 circ(0,0,25,colors[15])
 undither(10, 0.6)
 
 for i=-7,1 do
  ellipse(
   0,
   0,
   5*sin(r)*cos(r)+max(5,rnd(14)+5),
   -5*sin(r)-min(-14,rnd(14)-14-5),
   colors[0]
  )
 end

 -- rectfill(-64,64,64,61,0)
 -- line(-20,-5,55,40)
 -- pal(colors,1)
 flip()

goto _


__gfx__
77777777666666665555555544444444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77777777666666665555555544444444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77777777666666665555555544444444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77777777666666665555555544444444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77777777666666665555555544444444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77777777666666665555555544444444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77777777666666665555555544444444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77777777666666665555555544444444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
