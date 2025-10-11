pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
cls()
camera(-64,-64)
_set_fps(60)
seed=flr(rnd(-1))+1
srand(seed)
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
dither_modes = {
 "mixed",
 -- "burn_spiral",
 "burn_rect",
 "burn",
 -- "circles", 
 -- "circfill", 
 "rect"
} 
dither_prob = 0.35
dither_mode="burn"
n_dither_modes = #dither_modes

colors = {
 "0", "7", "0", 
 "7", "-3", "2", 
 "-8", "8"
}

pal(colors,0)

function draw_noise(amt)
 for i=0,amt*amt*amt do
  poke(0x6000+rnd(0x2000), peek(rnd(0x7fff)))
  poke(0x6000+rnd(0x2000),rnd(0xff))
 end
end

function draw_glitch(gr)
 local on=(t()*4.0)%gr<0.1
 gso=on and 0 or rnd(0x1fff)\1
 gln=on and 0x1ffe or rnd(0x1fff-gso)\16
 for a=0x6000+gso,0x6000+gso+gln,rnd(16)\1 do
  poke(a,peek(a+2),peek(a-1)+(rnd(3)))
 end
end


function rnd_choice(itr)
 local i = flr(rnd(#itr)) + 1
 return(itr[i])
end

function vfx_smoothing()
 local pixel = rnd_pixel()
 c=abs(pget(pixel.x,pixel.y)-1) 
end

function rnd_pixel()
 local px_x = (flr(rnd(128)) + 1) - 64
 local px_y = (flr(rnd(128)) + 1) - 64
 local pixel = {
  x=px_x,
  y=px_y
 }
 return(pixel)
end

function dither(dm)
 if dm == "mixed" then
  while dm == "mixed" do
   dm = rnd_choice(dither_modes)
  end
  dither(dm)
 elseif dm == "cls" then
  cls()
 elseif dm == "circles" then
  for i=1,6 do 
   local fudge_x = (flr(rnd(4)) + 1) * rnd_sign()
   local fudge_y = (flr(rnd(4)) + 1) * rnd_sign()
   --skip some nunber (12) pixels
   for x=128+fudge_x,0,-12 do
    for y=128+fudge_y,0,-12 do
     local pxl = rnd_pixel()
     if rnd(1) > dither_prob then
      circ(pxl.x,pxl.y,16,colors[0])
     end
    end
   end
  end
 elseif dm == "circfill" then
  for i=1,6 do 
   local fudge_x = (flr(rnd(4)) + 1) * rnd_sign()
   local fudge_y = (flr(rnd(4)) + 1) * rnd_sign()
   --skip some nunber (12) pixels
   for x=128+fudge_x,0,-12 do
    for y=128+fudge_y,0,-12 do
     local pxl = rnd_pixel()
     if rnd(1) > dither_prob then
      circfill(pxl.x,pxl.y,4,colors[0])
     end
    end
   end
  end
 elseif dm == "rect" then
  for i=1,6 do 
   local fudge_x = (flr(rnd(4)) + 1) * rnd_sign()
   local fudge_y = (flr(rnd(4)) + 1) * rnd_sign()
   --skip some nunber (12) pixels
   for x=128+fudge_x,0,-12 do
    for y=128+fudge_y,0,-12 do
     local pxl = rnd_pixel()
     if rnd(1) > dither_prob then
      rect(pxl.x-1,pxl.y-1,pxl.x+1,pxl.y+1,colors[0])
     end
    end
   end
  end
 elseif dm == "burn_spiral" then
  for i=500,1,-1 do
   local pxl = rnd_pixel()
   c=pget(pxl.x,pxl.y)
   circ(pxl.x,pxl.y,2,burn(c))
  end
 elseif dm == "burn" then
  for i=1,4 do 
   local fudge_x = (flr(rnd(4)) + 1) * rnd_sign()
   local fudge_y = (flr(rnd(4)) + 1) * rnd_sign()
   --skip some nunber (12) pixels
   for x=128+fudge_x,0,-12 do
    for y=128+fudge_y,0,-12 do
     local pxl = rnd_pixel()
      c=pget(pxl.x,pxl.y)
      circ(pxl.x,pxl.y,1,burn(c))
    end
   end
  end
 elseif dm == "burn_rect" then
  for i=1,4 do 
   local fudge_x = (flr(rnd(4)) + 1) * rnd_sign()
   local fudge_y = (flr(rnd(4)) + 1) * rnd_sign()
   --skip some nunber (12) pixels
   for x=128+fudge_x,0,-12 do
    for y=128+fudge_y,0,-12 do
     local pxl = rnd_pixel()
      c=pget(pxl.x,pxl.y)
      rect(pxl.x-1,pxl.y-1,pxl.x+1,pxl.y+1,burn(c))
    end
   end
  end
 end
end

function burn(c)
 local new_c = abs(c-1)
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

seed_reset_needed = false

::_::
 local loop_len =10
 local loop = flr(t())%loop_len == 0
 local srf = flr(t())%(loop_len/2) == 0
 local r = t()/loop_len
 local x,y=0,0

 if srf and seed_reset_needed then
  srand(seed)
  seed_reset_needed = false
 elseif not srf and not seed_reset_needed then
  seed_reset_needed = true
 end

 for i=0,20 do
  x=sin(r+i)*(20+(i*rnd(3)+1))
  y=(cos(r+i)*sin(r+i))*(20+(i*rnd(3)+1))
  
  pset(x*flr(rnd(3)+1),y,8)
  pset(-x*flr(rnd(3)+1),y,8)
  pset(x*flr(rnd(3)+1),-y,8)
  pset(-x*flr(rnd(3)+1),-y,8)

  pset(x/flr(rnd(3)+1),y*i,8)
  pset(-x/flr(rnd(3)+1),y*i,8)
  pset(x/flr(rnd(3)+1),-y*i,8)
  pset(-x/flr(rnd(3)+1),-y*i,8)

 end
 
 draw_noise(0.5)
 dither(dither_mode)
 undither(10,0.3)
 for i=-15,1 do
  ellipse(
   0,
   0,
   5*sin(r)*cos(r)+max(5,rnd(14)+5),
   -5*sin(r)-min(-14,rnd(14)-14-5),
   colors[0]
  )
 end

 for i=-2,1 do
  ellipse(
   0,
   0,
   (5+rnd(30))*sin(r)*cos(r)+max(5,rnd(14)+5),
   (-5-rnd(30))*sin(r)-min(-14,rnd(14)-14-5),
   colors[0]
  )
 end
 pal(colors,1)

goto _


__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
